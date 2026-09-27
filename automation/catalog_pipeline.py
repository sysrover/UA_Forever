"""Autoscan-to-catalog pipeline for UA_Forever.

The module treats autoscan exports as data, checks the effective catalogs in
their XML load order, creates translation worklists, and inserts reviewed
entries into the existing tables of canonical domain catalogs.
"""

from __future__ import annotations

import hashlib
import json
import re
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterable


SECTION_TO_DOMAIN = {
    "ITEMS": "items",
    "NPCS": "npcs",
    "SPELLS": "spells",
    "AURAS": "auras",
    "QUESTS": "quests",
    "BOOKS": "books",
    "GOSSIPS": "gossip",
    "CHATS": "chat",
    "SYSTEM_CHAT": "system_chat",
    "COMBAT_TEXT": "combat_text",
    "ZONES": "zones",
    "OBJECTS": "objects",
    "SKILLS": "skills",
    "UI": "ui",
}

DIAGNOSTIC_SECTIONS = {
    "RUNTIME",
    "NOT_APPLIED",
    "UNSAFE",
    "HOOKS",
    "CATALOG_CONFLICTS",
    "COMPATIBILITY",
    "INVALID_CANDIDATES",
    "TECHNICAL_LITERALS",
}

TARGETS = {
    "item_name": "entries/forever/catalogs/items/catalog.lua",
    "item_tooltip": "entries/forever/catalogs/items/catalog.lua",
    "npc_name": "entries/forever/catalogs/npcs/catalog.lua",
    "npc_subtitle": "entries/forever/catalogs/npcs/catalog.lua",
    "spell_name": "entries/forever/catalogs/spells/catalog.lua",
    "aura_line": "entries/forever/catalogs/spells/catalog.lua",
    "quest_field": "entries/forever/catalogs/quests/tasks.lua",
    "quest_task": "entries/forever/catalogs/quests/tasks.lua",
    "book_page": "entries/forever/catalogs/books/catalog.lua",
    "gossip": "entries/forever/catalogs/gossip/catalog.lua",
    "chat": "entries/forever/catalogs/chat/npc.lua",
    "system_chat": "entries/forever/catalogs/chat/system.lua",
    "zone": "entries/zone.lua",
    "object": "entries/forever/catalogs/objects/catalog.lua",
    "skill": "entries/forever/catalogs/ui/skills.lua",
    "ui": "entries/forever/catalogs/ui/core.lua",
    "ui_settings": "entries/forever/catalogs/ui/settings.lua",
}

QUEST_FIELD_INDEX = {
    "title": 1,
    "description": 2,
    "objective": 3,
    "progress": 4,
    "reward": 5,
}

SECTION_HEADER = re.compile(r"^\[([A-Z_]+)\]\s*\|\s*(\d+)\s*$")
RECORD_HEADER = re.compile(r"^# (.*)$")
FIELD_LINE = re.compile(r"^([A-Za-z][A-Za-z0-9_]*)\s*=\s*(.*)$", re.DOTALL)
TOOLTIP_LINE = re.compile(r"^(\d+)\s+(Left|Right)\s*=\s*(.*)$", re.DOTALL)


@dataclass
class ScanRecord:
    section: str
    key: str
    fields: dict[str, Any] = field(default_factory=dict)
    tooltip_lines: list[dict[str, Any]] = field(default_factory=list)
    not_applied: bool = False
    source_line: int = 0

    def as_dict(self) -> dict[str, Any]:
        return {
            "section": self.section,
            "key": self.key,
            "fields": self.fields,
            "tooltip_lines": self.tooltip_lines,
            "not_applied": self.not_applied,
            "source_line": self.source_line,
        }


def _decode_lua_quoted(value: str) -> str:
    if len(value) < 2 or value[0] != '"' or value[-1] != '"':
        raise ValueError(f"not a Lua quoted string: {value!r}")
    output: list[str] = []
    index = 1
    simple = {
        "a": "\a",
        "b": "\b",
        "f": "\f",
        "n": "\n",
        "r": "\r",
        "t": "\t",
        "v": "\v",
        "\\": "\\",
        '"': '"',
        "'": "'",
    }
    while index < len(value) - 1:
        char = value[index]
        if char != "\\":
            output.append(char)
            index += 1
            continue
        index += 1
        if index >= len(value) - 1:
            raise ValueError(f"unfinished escape in {value!r}")
        escaped = value[index]
        if escaped in simple:
            output.append(simple[escaped])
            index += 1
        elif escaped == "z":
            index += 1
            while index < len(value) - 1 and value[index].isspace():
                index += 1
        elif escaped == "x" and index + 2 < len(value):
            output.append(chr(int(value[index + 1:index + 3], 16)))
            index += 3
        elif escaped.isdigit():
            end = index
            while end < min(index + 3, len(value) - 1) and value[end].isdigit():
                end += 1
            output.append(chr(int(value[index:end], 10)))
            index = end
        elif escaped in {"\n", "\r"}:
            if escaped == "\r" and index + 1 < len(value) and value[index + 1] == "\n":
                index += 1
            output.append("\n")
            index += 1
        else:
            output.append(escaped)
            index += 1
    return "".join(output)


def parse_lua_scalar(value: str) -> Any:
    value = value.strip()
    if value == "[NOT_APPLIED]":
        return None
    if value.startswith('"') and value.endswith('"'):
        return _decode_lua_quoted(value)
    if value == "true":
        return True
    if value == "false":
        return False
    if value == "nil":
        return None
    if re.fullmatch(r"-?\d+", value):
        return int(value)
    if re.fullmatch(r"-?(?:\d+\.\d*|\d*\.\d+)", value):
        return float(value)
    return value


def _quoted_value_complete(value: str) -> bool:
    value = value.lstrip()
    if not value.startswith('"'):
        return True
    index = 1
    while index < len(value):
        if value[index] == "\\":
            index += 2
            continue
        if value[index] == '"':
            return not value[index + 1:].strip()
        index += 1
    return False


def _logical_report_lines(text: str) -> list[tuple[int, str]]:
    physical = text.splitlines(keepends=True)
    logical: list[tuple[int, str]] = []
    index = 0
    while index < len(physical):
        start = index + 1
        value = physical[index].rstrip("\r\n")
        match = FIELD_LINE.match(value.strip()) or TOOLTIP_LINE.match(value.strip())
        raw_value = match.group(match.lastindex) if match else ""
        while match and raw_value.lstrip().startswith('"') and not _quoted_value_complete(raw_value):
            index += 1
            if index >= len(physical):
                raise ValueError(f"unterminated Lua string beginning on report line {start}")
            continuation = physical[index].rstrip("\r\n")
            value += "\n" + continuation
            match = FIELD_LINE.match(value.strip()) or TOOLTIP_LINE.match(value.strip())
            raw_value = match.group(match.lastindex) if match else ""
        logical.append((start, value))
        index += 1
    return logical


def parse_autoscan(text: str) -> list[ScanRecord]:
    records: list[ScanRecord] = []
    section: str | None = None
    current: ScanRecord | None = None
    for line_number, raw_line in _logical_report_lines(text):
        line = raw_line.strip()
        section_match = SECTION_HEADER.match(line)
        if section_match:
            if current is not None:
                records.append(current)
                current = None
            section = section_match.group(1)
            continue
        record_match = RECORD_HEADER.match(raw_line.rstrip("\r\n"))
        if record_match and section:
            if current is not None:
                records.append(current)
            current = ScanRecord(section=section, key=record_match.group(1), source_line=line_number)
            continue
        if current is None or not line:
            continue
        if line == "[NOT_APPLIED]":
            current.not_applied = True
            continue
        tooltip_match = TOOLTIP_LINE.match(line)
        if tooltip_match:
            raw_value = tooltip_match.group(3)
            current.tooltip_lines.append({
                "index": int(tooltip_match.group(1)),
                "side": tooltip_match.group(2),
                "text": parse_lua_scalar(raw_value),
                "not_applied": raw_value.strip() == "[NOT_APPLIED]",
            })
            continue
        field_match = FIELD_LINE.match(line)
        if field_match:
            current.fields[field_match.group(1)] = parse_lua_scalar(field_match.group(2))
    if current is not None:
        records.append(current)
    return records


def lua_quote(value: str) -> str:
    replacements = {
        "\\": "\\\\",
        '"': '\\"',
        "\n": "\\n",
        "\r": "\\r",
        "\t": "\\t",
        "\a": "\\a",
        "\b": "\\b",
        "\f": "\\f",
        "\v": "\\v",
    }
    result = []
    for char in value:
        if char in replacements:
            result.append(replacements[char])
        elif ord(char) < 32:
            result.append(f"\\{ord(char):03d}")
        else:
            result.append(char)
    return '"' + "".join(result) + '"'


def _is_lua_table(value: Any) -> bool:
    return value is not None and hasattr(value, "items")


def _lua_get(table: Any, key: Any) -> Any:
    if not _is_lua_table(table):
        return None
    try:
        return table[key]
    except (KeyError, TypeError):
        return None


def _translated(value: Any, source: str) -> str | None:
    if isinstance(value, str) and value and value != source:
        return value
    return None


class CatalogState:
    """Effective addon catalog state loaded from the checked-out Lua files."""

    def __init__(self, repo: Path):
        self.repo = repo.resolve()
        try:
            from lupa.luajit21 import LuaRuntime
        except ImportError as exc:  # pragma: no cover - environment message
            raise RuntimeError(
                "catalog automation requires lupa; install automation/requirements.txt"
            ) from exc
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.addon = self.lua.table()
        self.loaded_files: list[str] = []
        for manifest in (self.repo / "entries/index.xml", self.repo / "entries/forever/index.xml"):
            self._load_manifest(manifest)
        self.lua_match = self.lua.eval(
            "function(text, pattern) return string.match(text, pattern) ~= nil end"
        )
        self.lua_ui_pattern_translation = self.lua.eval("""
            function(text, rule)
                if type(text) ~= "string" or type(rule) ~= "table"
                    or type(rule.pattern) ~= "string"
                    or type(rule.replace) ~= "function" then return nil end
                local captures = { string.match(text, rule.pattern) }
                if #captures == 0 then return nil end
                local ok, translated = pcall(rule.replace, unpack(captures))
                if ok and type(translated) == "string"
                    and translated ~= "" and translated ~= text then
                    return translated
                end
            end
        """)
        chats_source = (self.repo / "scripts/chats.lua").read_text(encoding="utf-8")
        self.system_chat_patterns = []
        for raw_pattern in re.findall(
            r'message:match\(\s*"((?:\\.|[^"\\])*)"', chats_source, re.DOTALL
        ):
            try:
                self.system_chat_patterns.append(_decode_lua_quoted(f'"{raw_pattern}"'))
            except ValueError:
                continue
        self.reverse_names: dict[str, dict[str, str]] = defaultdict(dict)
        for domain in ("item", "npc", "spell"):
            table = _lua_get(self.addon, domain)
            if not _is_lua_table(table):
                continue
            for identity, entry in table.items():
                if not _is_lua_table(entry):
                    continue
                english = _lua_get(entry, "en")
                ukrainian = _translated(_lua_get(entry, 1), english or "")
                if isinstance(english, str) and ukrainian:
                    self.reverse_names[domain][english] = ukrainian
        entries_bridge = self.lua.table()
        entries_bridge["lookup_name"] = lambda domain, source: (
            self.reverse_names.get(str(domain), {}).get(str(source))
        )
        entries_bridge["get_glossary_text"] = lambda source, fallback=None: (
            self.domain_name_translation(str(source))[1]
            if self.domain_name_translation(str(source)) else fallback
        )
        original_use = _lua_get(self.addon, "use")

        def catalog_use(name: Any) -> Any:
            if name == "entries":
                return entries_bridge
            if callable(original_use):
                return original_use(name)
            return None

        self.addon["use"] = catalog_use
        self.ui_templates: list[tuple[str, str, re.Pattern[str], int]] = []
        visible_ui = _lua_get(self.addon, "forever_ui")
        if _is_lua_table(visible_ui):
            for english, ukrainian in visible_ui.items():
                if not isinstance(english, str) or not isinstance(ukrainian, str) \
                        or ukrainian == english or not PRINTF_TOKEN.search(english):
                    continue
                parts: list[str] = []
                cursor = 0
                for match in PRINTF_TOKEN.finditer(english):
                    parts.append(re.escape(english[cursor:match.start()]))
                    conversion = match.group(0)[-1]
                    if conversion in "diouxX":
                        parts.append(r"[-+]?\d+")
                    elif conversion in "eEfgG":
                        parts.append(r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)")
                    elif conversion == "%":
                        parts.append("%")
                    else:
                        parts.append(r".+?")
                    cursor = match.end()
                parts.append(re.escape(english[cursor:]))
                literal_length = len(PRINTF_TOKEN.sub("", english))
                self.ui_templates.append((
                    english, ukrainian, re.compile("^" + "".join(parts) + "$"),
                    literal_length,
                ))

    def _load_manifest(self, manifest: Path) -> None:
        names = re.findall(r'<Script file="([^"]+)"\s*/>', manifest.read_text(encoding="utf-8"))
        for name in names:
            path = manifest.parent / Path(name.replace("\\", "/"))
            self.lua.execute(path.read_text(encoding="utf-8"), "UA_Forever", self.addon)
            self.loaded_files.append(path.relative_to(self.repo).as_posix())

    def domain_name_translation(self, source: str) -> tuple[str, str] | None:
        for domain in ("item", "npc", "spell"):
            translation = self.reverse_names[domain].get(source)
            if translation:
                return domain, translation
        for domain in ("object", "zone"):
            translation = _translated(_lua_get(_lua_get(self.addon, domain), source), source)
            if translation:
                return domain, translation
        return None

    def ui_pattern_translation(self, source: str) -> str | None:
        patterns = _lua_get(self.addon, "forever_ui_patterns")
        if not _is_lua_table(patterns):
            return None
        for _, rule in patterns.items():
            try:
                translated = self.lua_ui_pattern_translation(source, rule)
                if isinstance(translated, str) and translated != source:
                    return translated
            except Exception:
                continue
        return None

    def system_pattern_translation(self, source: str) -> bool:
        for pattern in self.system_chat_patterns:
            try:
                if self.lua_match(source, pattern):
                    return True
            except Exception:
                continue
        return False

    def system_catalog_candidate(self, source: str) -> tuple[str, str] | None:
        visible_ui = _lua_get(self.addon, "forever_ui")
        exact = _translated(_lua_get(visible_ui, source), source)
        if exact:
            return exact, source
        candidates: list[tuple[int, str, str]] = []
        for english, ukrainian, pattern, literal_length in self.ui_templates:
            if pattern.fullmatch(source):
                candidates.append((literal_length, ukrainian, english))
        if not candidates:
            return None
        _, ukrainian, english = max(candidates, key=lambda row: row[0])
        return ukrainian, english

    def quest_entry(self, identity: int) -> Any:
        for name in ("quest_alliance", "quest_horde", "quest_both"):
            entry = _lua_get(_lua_get(self.addon, name), identity)
            if _is_lua_table(entry):
                return entry
        return None

    def book_identity_error(self, unit: dict[str, Any]) -> str | None:
        apply = unit.get("apply", {})
        if apply.get("kind") != "book_page":
            return None
        book_id = _int_value(apply.get("book_id"))
        book_name = apply.get("book_name")
        if book_id:
            return None
        if not isinstance(book_name, str) or not book_name:
            return "book identity is missing"
        page = _int_value(apply.get("page"))
        if not page:
            return "book page is missing"
        if unit.get("record_key") != f"{book_name}:{page}":
            return "book title/page do not match the scan identity"
        objects = _lua_get(self.addon, "object")
        if _lua_get(objects, book_name) is None:
            return "book title is not an exact object catalog key"
        return None

    def existing_for(self, unit: dict[str, Any]) -> tuple[str | None, str | None]:
        kind = unit["apply"]["kind"]
        apply = unit["apply"]
        source = unit["source"]
        if kind.startswith("item_"):
            entry = _lua_get(_lua_get(self.addon, "item"), apply["id"])
            value = _lua_get(entry, 1) if kind == "item_name" else _lua_get(_lua_get(entry, "tooltip_lines"), source)
            return _translated(value, source), None
        if kind.startswith("npc_"):
            entry = _lua_get(_lua_get(self.addon, "npc"), apply["id"])
            index = 1 if kind == "npc_name" else 2
            return _translated(_lua_get(entry, index), source), None
        if kind == "spell_name":
            entry = _lua_get(_lua_get(self.addon, "spell"), apply["id"])
            return _translated(_lua_get(entry, 1), source), None
        if kind == "aura_line":
            entry = _lua_get(_lua_get(self.addon, "spell"), apply["id"])
            return _translated(_lua_get(_lua_get(entry, "aura_lines"), source), source), None
        if kind in {"ui", "ui_settings", "skill"}:
            value = _lua_get(_lua_get(self.addon, "forever_ui"), source)
            translated = _translated(value, source)
            if translated:
                provenance = _lua_get(_lua_get(_lua_get(self.addon, "forever_catalog"), "ui_provenance"), source)
                return translated, _lua_get(provenance, "source")
            pattern_translation = self.ui_pattern_translation(source)
            if pattern_translation:
                return pattern_translation, "forever_ui_patterns"
            domain = self.domain_name_translation(source)
            if domain:
                return domain[1], f"{domain[0]} domain"
            return None, None
        if kind == "system_chat":
            exact = _lua_get(_lua_get(self.addon, "forever_chat_system"), "exact")
            return _translated(_lua_get(exact, source), source), None
        if kind == "zone":
            return _translated(_lua_get(_lua_get(self.addon, "zone"), source), source), None
        if kind == "object":
            value = _lua_get(_lua_get(self.addon, "object"), source)
            value = value or _lua_get(_lua_get(self.addon, "zone"), source)
            return _translated(value, source), None
        if kind == "gossip":
            values = _lua_get(_lua_get(self.addon, "gossip"), apply["npc_id"])
            value = _lua_get(values, apply["code"])
            if value is None:
                value = _lua_get(_lua_get(_lua_get(self.addon, "gossip"), "!common"), apply["code"])
            return _translated(value, source), None
        if kind == "chat":
            values = _lua_get(_lua_get(self.addon, "chat"), apply["npc"])
            value = _lua_get(values, apply["code"])
            if value is None:
                value = _lua_get(_lua_get(_lua_get(self.addon, "chat"), "!common"), apply["code"])
            return _translated(value, source), None
        if kind in {"quest_field", "quest_task"}:
            entry = self.quest_entry(apply["id"])
            if kind == "quest_field":
                value = _lua_get(entry, apply["index"])
            else:
                value = _lua_get(_lua_get(entry, "tasks"), source)
            return _translated(value, source), None
        if kind == "book_page":
            identity = _book_identity(apply)
            entry = _lua_get(_lua_get(self.addon, "book"), identity)
            return _translated(_lua_get(entry, apply["page"]), source), None
        return None, None


def _int_value(value: Any) -> int | None:
    if isinstance(value, int):
        return value
    if isinstance(value, str) and value.isdigit():
        return int(value)
    return None


def _book_identity(apply: dict[str, Any]) -> int | str | None:
    book_id = _int_value(apply.get("book_id"))
    if book_id:
        return book_id
    book_name = apply.get("book_name")
    if isinstance(book_name, str) and book_name:
        return book_name
    return None


def _book_lua_key(apply: dict[str, Any]) -> str:
    identity = _book_identity(apply)
    if isinstance(identity, int):
        return str(identity)
    if isinstance(identity, str):
        return lua_quote(identity)
    raise ValueError("book identity is missing")


def _unit_identifier(section: str, key: str, field_name: str, source: str) -> str:
    digest = hashlib.sha1(
        f"{section}\0{key}\0{field_name}\0{source}".encode("utf-8")
    ).hexdigest()[:16]
    return f"{section.lower()}-{digest}"


def _unit(section: str, key: str, field_name: str, source: str, apply: dict[str, Any],
          context: dict[str, Any] | None = None, safe: bool = True,
          reason: str | None = None) -> dict[str, Any]:
    return {
        "id": _unit_identifier(section, key, field_name, source),
        "section": section,
        "record_key": key,
        "field": field_name,
        "source": source,
        "translation": "",
        "target": TARGETS.get(apply["kind"]),
        "apply": apply,
        "context": context or {},
        "safe_to_apply": safe,
        "reason": reason,
    }


def classify_ui_kind(slot: str | None, surface: str | None = None) -> str:
    value = " ".join(filter(None, (slot, surface))).casefold()
    if any(token in value for token in ("menu", "dropdown", "context", "popup")):
        return "menus"
    if slot:
        return "widgets"
    return "other"


def _dynamic_system_text(source: str) -> bool:
    if re.search(r"\|H[^|]+\|h|\|A[^|]+\|a|\|T[^|]+\|t", source):
        return True
    if re.search(r"\b\d+\b", source):
        return True
    prefixes = (
        "A buyer has been found for your auction of ",
        "You are now Away: ",
        "You won an auction for ",
        "You receive ",
        "You gained: ",
    )
    return source.startswith(prefixes)


def units_for_record(record: ScanRecord) -> list[dict[str, Any]]:
    section, key, fields = record.section, record.key, record.fields
    units: list[dict[str, Any]] = []
    context = {k: v for k, v in fields.items() if k not in {"name", "text", "translation"}}
    if section in DIAGNOSTIC_SECTIONS:
        return units
    if section in {"ITEMS", "NPCS", "SPELLS", "AURAS"}:
        identity = _int_value(fields.get("spellID")) or _int_value(key)
        title = fields.get("name")
        if not title:
            title_row = next((row for row in record.tooltip_lines
                              if row["index"] == 1 and row["side"] == "Left" and row["text"]), None)
            title = title_row and title_row["text"]
        if identity and isinstance(title, str):
            kind = {"ITEMS": "item_name", "NPCS": "npc_name",
                    "SPELLS": "spell_name", "AURAS": "spell_name"}[section]
            units.append(_unit(section, key, "name", title, {"kind": kind, "id": identity}, context))
        for row in record.tooltip_lines:
            source = row.get("text")
            if not isinstance(source, str) or row["index"] == 1 and row["side"] == "Left":
                continue
            field_name = f"tooltip.{row['index']}.{row['side'].lower()}"
            if section == "ITEMS" and identity:
                units.append(_unit(section, key, field_name, source,
                                   {"kind": "item_tooltip", "id": identity}, context))
            elif section == "AURAS" and identity:
                units.append(_unit(section, key, field_name, source,
                                   {"kind": "aura_line", "id": identity}, context))
            else:
                units.append(_unit(section, key, field_name, source,
                                   {"kind": "spell_name", "id": identity or 0}, context,
                                   safe=False, reason="spell tooltip descriptions need positional schema review"))
        return units
    if section == "QUESTS":
        identity = _int_value(key)
        if not identity:
            return units
        for field_name, source in fields.items():
            if not isinstance(source, str):
                continue
            if field_name in QUEST_FIELD_INDEX:
                units.append(_unit(section, key, field_name, source, {
                    "kind": "quest_field", "id": identity,
                    "index": QUEST_FIELD_INDEX[field_name],
                }, context))
            elif re.fullmatch(r"task\d+", field_name):
                units.append(_unit(section, key, field_name, source, {
                    "kind": "quest_task", "id": identity,
                }, context))
        return units
    if section == "BOOKS":
        source = fields.get("text")
        book_id = _int_value(fields.get("bookID"))
        book_name = fields.get("name")
        page = _int_value(fields.get("page")) or 1
        if not isinstance(book_name, str) or not book_name:
            key_identity, separator, key_page = key.rpartition(":")
            if separator and key_identity and _int_value(key_identity) is None \
                    and _int_value(key_page):
                book_name = key_identity
        if isinstance(source, str) and (book_id or book_name):
            apply: dict[str, Any] = {"kind": "book_page", "page": page}
            if book_id:
                apply["book_id"] = book_id
            else:
                apply["book_name"] = book_name
            units.append(_unit(
                section, key, "text", source, apply, context,
                safe=bool(book_id),
                reason=None if book_id else "book title identity requires object catalog confirmation",
            ))
        return units
    if section == "GOSSIPS":
        source = fields.get("text")
        npc_text, separator, code = key.partition(":")
        npc_id = _int_value(fields.get("npcID")) or _int_value(npc_text)
        template_code = fields.get("templateCode")
        if isinstance(template_code, str) and template_code:
            code = template_code
        if isinstance(source, str) and npc_id and separator and code:
            units.append(_unit(section, key, "text", source, {
                "kind": "gossip", "npc_id": npc_id, "code": code,
            }, context))
        return units
    if section == "CHATS":
        source = fields.get("text")
        npc = fields.get("npc")
        prefix = f"{npc}:" if isinstance(npc, str) else ""
        code = key[len(prefix):] if prefix and key.startswith(prefix) else key.rpartition(":")[2]
        if isinstance(source, str) and isinstance(npc, str) and code:
            units.append(_unit(section, key, "text", source, {
                "kind": "chat", "npc": npc, "code": code,
            }, context))
        return units
    if section == "SYSTEM_CHAT":
        source = fields.get("text") if isinstance(fields.get("text"), str) else key
        units.append(_unit(section, key, "text", source, {"kind": "system_chat"}, context,
                           safe=not _dynamic_system_text(source),
                           reason="dynamic system message needs formatter review" if _dynamic_system_text(source) else None))
        return units
    if section in {"ZONES", "OBJECTS"}:
        source = fields.get("name") if isinstance(fields.get("name"), str) else key
        visible = fields.get("visible")
        if isinstance(visible, str) and visible != source:
            return units
        kind = "zone" if section == "ZONES" else "object"
        if section == "OBJECTS":
            context.setdefault("owner", "object-tooltip")
            context.setdefault("slot", "object.name")
            context.setdefault("surface", "GameTooltip")
        units.append(_unit(section, key, "name", source, {"kind": kind}, context))
        return units
    if section == "SKILLS":
        source = fields.get("name")
        if isinstance(source, str):
            units.append(_unit(section, key, "name", source, {"kind": "skill"}, context))
        return units
    if section == "UI":
        source = fields.get("text")
        slot = fields.get("slot") if isinstance(fields.get("slot"), str) else None
        surface = fields.get("surface") if isinstance(fields.get("surface"), str) else None
        ui_kind = classify_ui_kind(slot, surface)
        if isinstance(source, str):
            if re.fullmatch(r"(?:\|A[^|]+\|a|\|T[^|]+\|t|\s)+", source):
                units.append(_unit(section, key, "text", source, {"kind": "ui"},
                                   {**context, "ui_kind": ui_kind}, safe=False,
                                   reason="texture/atlas-only UI value is technical"))
            else:
                apply_kind = "ui_settings" if slot and "setting" in slot.casefold() else "ui"
                units.append(_unit(section, key, "text", source, {"kind": apply_kind},
                                   {**context, "ui_kind": ui_kind}))
        return units
    if section == "COMBAT_TEXT":
        source = fields.get("text")
        if isinstance(source, str):
            units.append(_unit(section, key, "text", source, {"kind": "ui"}, context,
                               safe=False, reason="combat text requires global/event route review"))
    return units


def load_ignored_sources(path: Path) -> list[dict[str, str]]:
    if not path.is_file():
        return []
    value = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(value, list):
        raise ValueError("ignored sources must be a JSON array")
    rules: list[dict[str, str]] = []
    for index, rule in enumerate(value):
        if not isinstance(rule, dict):
            raise ValueError(f"ignored source #{index + 1} must be an object")
        section = rule.get("section")
        source = rule.get("source")
        reason = rule.get("reason", "intentionally left untranslated")
        if not isinstance(section, str) or not section.strip():
            raise ValueError(f"ignored source #{index + 1} needs a section")
        if not isinstance(source, str) or not source:
            raise ValueError(f"ignored source #{index + 1} needs a source")
        if not isinstance(reason, str) or not reason.strip():
            raise ValueError(f"ignored source #{index + 1} needs a reason")
        rules.append({
            "section": section.strip().upper(),
            "source": source,
            "reason": reason.strip(),
        })
    return rules


def ignored_source_reason(unit: dict[str, Any],
                          rules: Iterable[dict[str, str]]) -> str | None:
    for rule in rules:
        if rule["section"] == unit["section"] and rule["source"] == unit["source"]:
            return rule["reason"]
    return None


def _translated_with_binding_suffix(fields: dict[str, Any]) -> bool:
    translated = fields.get("translation")
    visible = fields.get("visible")
    if not isinstance(translated, str) or not isinstance(visible, str):
        return False
    return re.fullmatch(re.escape(translated) + r" \(F\d+\)", visible) is not None


def analyze(records: Iterable[ScanRecord], state: CatalogState,
            ignored_sources: Iterable[dict[str, str]] = ()) -> dict[str, list[dict[str, Any]]]:
    result: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        if record.section in DIAGNOSTIC_SECTIONS:
            if record.section in {"RUNTIME", "NOT_APPLIED"} \
                    and _translated_with_binding_suffix(record.fields):
                continue
            result["not_applied" if record.section in {"RUNTIME", "NOT_APPLIED"}
                   else "diagnostics"].append(record.as_dict())
            continue
        if record.section in {"ZONES", "OBJECTS"}:
            source = (record.fields.get("name")
                      if isinstance(record.fields.get("name"), str) else record.key)
            visible = record.fields.get("visible")
            if isinstance(visible, str) and visible != source:
                continue
        units = units_for_record(record)
        if not units:
            result["review"].append({
                **record.as_dict(),
                "reason": "unsupported or incomplete identity",
            })
            continue
        for unit in units:
            ignored_reason = ignored_source_reason(unit, ignored_sources)
            if ignored_reason:
                unit["safe_to_apply"] = False
                unit["reason"] = ignored_reason
                unit["ignored_by"] = "automation/ignored_sources.json"
                result["ignored"].append(unit)
                continue
            if unit["apply"]["kind"] == "system_chat":
                existing, owner = state.existing_for(unit)
                if existing:
                    unit["existing_translation"] = existing
                    unit["existing_owner"] = owner or "chat/system.lua"
                    unit["reason"] = ("translation exists but autoscan observed it unapplied"
                                      if record.not_applied else
                                      "translation exists in the repository but autoscan reported it unresolved")
                    result["not_applied"].append(unit)
                    continue
                if state.system_pattern_translation(unit["source"]):
                    unit["existing_translation"] = "<covered by system-chat formatter>"
                    unit["existing_owner"] = "scripts/chats.lua"
                    unit["reason"] = "system-chat formatter exists but autoscan reported the text unresolved"
                    result["not_applied"].append(unit)
                    continue
                catalog_candidate = state.system_catalog_candidate(unit["source"])
                if catalog_candidate:
                    unit["existing_translation"] = catalog_candidate[0]
                    unit["existing_source"] = catalog_candidate[1]
                    unit["existing_owner"] = "UI catalog; missing system-chat route"
                    unit["reason"] = "translation exists in another catalog but is not applied here"
                    result["not_applied"].append(unit)
                    continue
            if unit["apply"]["kind"] in {"quest_field", "quest_task"} \
                    and state.quest_entry(unit["apply"]["id"]) is None:
                unit["safe_to_apply"] = False
                unit["reason"] = "quest ID is absent; choose alliance, horde, both, or missing catalog"
                result["review"].append(unit)
                continue
            if unit["apply"]["kind"] == "book_page":
                identity_error = state.book_identity_error(unit)
                if identity_error:
                    unit["safe_to_apply"] = False
                    unit["reason"] = identity_error
                    result["review"].append(unit)
                    continue
                unit["safe_to_apply"] = True
                unit["reason"] = None
            if not unit["safe_to_apply"]:
                bucket = "ignored" if unit["reason"] == "texture/atlas-only UI value is technical" else "review"
                result[bucket].append(unit)
                continue
            existing, owner = state.existing_for(unit)
            if existing:
                unit["existing_translation"] = existing
                unit["existing_owner"] = owner
                unit["reason"] = ("translation exists but autoscan observed it unapplied"
                                  if record.not_applied else
                                  "translation exists in the repository but autoscan reported it unresolved")
                result["not_applied"].append(unit)
                continue
            result["needs_translation"].append(unit)
    deduplicated: dict[str, dict[str, Any]] = {}
    for row in result.get("not_applied", []):
        fields = row.get("fields", {})
        signature = "\0".join(str(fields.get(name, "")) for name in ("owner", "slot", "text"))
        if not signature.strip("\0"):
            signature = str(row.get("id") or row.get("key"))
        current = deduplicated.get(signature)
        current_fields = current.get("fields", {}) if current else {}
        if current is None or bool(fields.get("reason")) >= bool(current_fields.get("reason")):
            deduplicated[signature] = row
    if deduplicated:
        result["not_applied"] = list(deduplicated.values())
    return result


def _write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def write_worklists(output: Path, analysis: dict[str, list[dict[str, Any]]],
                    source_log: Path, loaded_files: list[str], parsed_records: int) -> None:
    output.mkdir(parents=True, exist_ok=True)
    for directory in (output / "translate", output / "ui"):
        if directory.is_dir():
            for stale in directory.glob("*.json"):
                stale.unlink()
    stale_existing = output / "existing.json"
    if stale_existing.is_file():
        stale_existing.unlink()
    for name in ("needs_translation", "not_applied", "review", "ignored", "diagnostics"):
        _write_json(output / f"{name}.json", analysis.get(name, []))
    needs = analysis.get("needs_translation", [])
    _write_json(output / "translations.json", needs)
    by_domain: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for unit in needs:
        by_domain[unit["section"].lower()].append(unit)
    for domain, units in sorted(by_domain.items()):
        _write_json(output / "translate" / f"{domain}.json", units)
    ui_units = []
    for status in ("needs_translation", "not_applied", "review"):
        for unit in analysis.get(status, []):
            if unit.get("section") == "UI":
                ui_units.append({**unit, "status": status})
    for kind in ("menus", "widgets", "other"):
        selected = [unit for unit in ui_units if unit.get("context", {}).get("ui_kind") == kind]
        _write_json(output / "ui" / f"{kind}.json", selected)
    summary = {
        "source_log": str(source_log),
        "parsed_records": parsed_records,
        "loaded_catalog_files": loaded_files,
        "counts": {name: len(rows) for name, rows in sorted(analysis.items())},
        "workflow": [
            "Fill translation fields manually or run catalog_translate_google.py, then review every result.",
            "Run catalog_apply.py without --apply to render reviewable Lua fragments.",
            "Run catalog_apply.py with --apply only after reviewing those fragments.",
        ],
    }
    _write_json(output / "summary.json", summary)


PRINTF_TOKEN = re.compile(r"%(?:\d+\$)?[-+ #0]*(?:\d+|\*)?(?:\.\d+)?[cdeEfgGiouXxqs%]")
BRACE_TOKEN = re.compile(r"\{[^{}]+\}")
DOLLAR_TOKEN = re.compile(r"\$[A-Za-z_][A-Za-z0-9_]*")
ATLAS_TOKEN = re.compile(r"\|A[^|]+\|a")
TEXTURE_TOKEN = re.compile(r"\|T[^|]+\|t")
LINK_TARGET = re.compile(r"\|H([^|]+)\|h")
UK_CASE = r"(?:н|р|д|з|о|м|к|мн|мр|мд|мз|мо|мм|мк)"
GOSSIP_DYNAMIC_TAGS = {
    "name": re.compile(rf"\{{(?:ім'я|Ім'я|ІМ'Я)(?::{UK_CASE})?\}}"),
    "class": re.compile(rf"\{{(?:клас|Клас|КЛАС)(?::{UK_CASE})?\}}"),
}
GOSSIP_GENDER_TAG = re.compile(r"\{(?:стать|Стать|СТАТЬ):[^{}:]+:[^{}:]+\}")


def placeholder_signature(text: str) -> Counter[str]:
    tokens: list[str] = []
    tokens.extend(f"printf:{value}" for value in PRINTF_TOKEN.findall(text))
    tokens.extend(f"brace:{value}" for value in BRACE_TOKEN.findall(text))
    tokens.extend(f"dollar:{value}" for value in DOLLAR_TOKEN.findall(text))
    tokens.extend(f"atlas:{value}" for value in ATLAS_TOKEN.findall(text))
    tokens.extend(f"texture:{value}" for value in TEXTURE_TOKEN.findall(text))
    tokens.extend(f"link:{value}" for value in LINK_TARGET.findall(text))
    tokens.extend(["link-close"] * text.count("|h"))
    tokens.extend(["color-open"] * len(re.findall(r"\|c[0-9A-Fa-f]{8}", text)))
    tokens.extend(["color-close"] * text.count("|r"))
    tokens.extend(["newline"] * text.count("|n"))
    return Counter(tokens)


def _strip_allowed_gossip_tags(unit: dict[str, Any], translation: str) -> str:
    if unit.get("apply", {}).get("kind") != "gossip":
        return translation
    personalized = unit.get("context", {}).get("personalized")
    if not isinstance(personalized, str) or not personalized:
        return translation
    result = translation
    for kind in personalized.split(","):
        pattern = GOSSIP_DYNAMIC_TAGS.get(kind.strip())
        if pattern:
            result = pattern.sub("", result)
    return GOSSIP_GENDER_TAG.sub("", result)


def validate_translation(unit: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    source = unit.get("source")
    translation = unit.get("translation")
    if not isinstance(source, str) or not source:
        errors.append("source is empty")
    if not isinstance(translation, str) or not translation.strip():
        errors.append("translation is empty")
    elif translation == source:
        errors.append("translation is unchanged")
    elif placeholder_signature(source) != placeholder_signature(
            _strip_allowed_gossip_tags(unit, translation)):
        errors.append("placeholders or WoW markup do not match the source")
    if not unit.get("safe_to_apply", False):
        errors.append(unit.get("reason") or "unit requires manual review")
    if unit.get("apply", {}).get("kind") not in TARGETS:
        errors.append("unsupported apply kind")
    else:
        expected_target = TARGETS[unit["apply"]["kind"]]
        if unit.get("target") != expected_target:
            errors.append("target does not match the apply kind")
    if all(isinstance(unit.get(name), str) for name in ("section", "record_key", "field", "source")):
        expected_id = _unit_identifier(
            unit["section"], unit["record_key"], unit["field"], unit["source"]
        )
        if unit.get("id") != expected_id:
            errors.append("identity fields were modified; rerun catalog_scan.py")
    else:
        errors.append("identity fields are incomplete")
    return errors


def render_catalog_entry(unit: dict[str, Any]) -> list[str]:
    """Render the catalog-native entry shown in the review fragment."""
    apply = unit["apply"]
    kind = apply["kind"]
    source = lua_quote(unit["source"])
    translation = lua_quote(unit["translation"])
    if kind in {"ui", "ui_settings", "skill", "system_chat", "zone", "object"}:
        return [f"[{source}] = {translation},"]
    if kind in {"item_name", "npc_name", "spell_name"}:
        return [f"[{apply['id']}] = {{ [1] = {translation}, en = {source} }},"]
    if kind == "npc_subtitle":
        return [f"[{apply['id']}] = {{ [2] = {translation}, en = {source} }},"]
    if kind in {"item_tooltip", "aura_line"}:
        field = "tooltip_lines" if kind == "item_tooltip" else "aura_lines"
        return [f"[{apply['id']}] = {{ {field} = {{ [{source}] = {translation} }} }},"]
    if kind == "quest_field":
        return [f"[{apply['id']}] = {{ [{apply['index']}] = {translation} }},"]
    if kind == "quest_task":
        return [f"[{apply['id']}] = {{ tasks = {{ [{source}] = {translation} }} }},"]
    if kind == "book_page":
        return [f"[{_book_lua_key(apply)}] = {{ [{apply['page']}] = {translation} }},"]
    if kind == "gossip":
        return [f"[{apply['npc_id']}] = {{ [{lua_quote(apply['code'])}] = {translation} }},"]
    if kind == "chat":
        return [f"[{lua_quote(apply['npc'])}] = {{ [{lua_quote(apply['code'])}] = {translation} }},"]
    raise ValueError(f"unsupported apply kind: {kind}")


def _lua_code_mask(text: str) -> str:
    """Blank Lua strings/comments while preserving offsets and line breaks."""
    masked = list(text)
    long_pattern = re.compile(r"\[(=*)\[")

    def blank(start: int, end: int) -> None:
        for position in range(start, end):
            if masked[position] not in "\r\n":
                masked[position] = " "

    def long_bracket(start: int) -> tuple[int, str] | None:
        match = long_pattern.match(text, start)
        return (match.end() - start, "]" + match.group(1) + "]") if match else None

    index = 0
    while index < len(text):
        if text.startswith("--", index):
            long = long_bracket(index + 2)
            if long:
                opening_length, closing = long
                end = text.find(closing, index + 2 + opening_length)
                end = len(text) if end < 0 else end + len(closing)
            else:
                newline = text.find("\n", index + 2)
                end = len(text) if newline < 0 else newline
            blank(index, end)
            index = end
            continue
        if text[index] in {'"', "'"}:
            quote = text[index]
            end = index + 1
            while end < len(text):
                if text[end] == "\\":
                    end += 2
                    continue
                end += 1
                if text[end - 1] == quote:
                    break
            blank(index, min(end, len(text)))
            index = end
            continue
        long = long_bracket(index)
        if long:
            opening_length, closing = long
            end = text.find(closing, index + opening_length)
            end = len(text) if end < 0 else end + len(closing)
            blank(index, end)
            index = end
            continue
        index += 1
    return "".join(masked)


def _matching_brace(masked: str, opening: int) -> int:
    depth = 0
    for position in range(opening, len(masked)):
        if masked[position] == "{":
            depth += 1
        elif masked[position] == "}":
            depth -= 1
            if depth == 0:
                return position
    raise ValueError("unterminated Lua table")


def _declared_table(text: str, pattern: str) -> tuple[int, int]:
    masked = _lua_code_mask(text)
    match = re.search(pattern, masked)
    if not match:
        raise ValueError(f"catalog table was not found: {pattern}")
    opening = masked.find("{", match.start(), match.end())
    if opening < 0:
        raise ValueError(f"catalog declaration has no table: {pattern}")
    return opening, _matching_brace(masked, opening)


def _depth_between(masked: str, opening: int, position: int) -> int:
    return masked[opening + 1:position].count("{") - masked[opening + 1:position].count("}")


def _keyed_table(text: str, parent: tuple[int, int], key: str) -> tuple[int, int] | None:
    masked = _lua_code_mask(text)
    cursor = parent[0] + 1
    while cursor < parent[1]:
        position = text.find(key, cursor, parent[1])
        if position < 0:
            return None
        suffix = re.match(r"\s*=\s*\{", text[position + len(key):parent[1]])
        if suffix:
            opening = position + len(key) + suffix.end() - 1
            if masked[opening] == "{" and _depth_between(masked, parent[0], position) == 0:
                return opening, _matching_brace(masked, opening)
        cursor = position + len(key)
    return None


def _field_table(text: str, parent: tuple[int, int], field: str) -> tuple[int, int] | None:
    masked = _lua_code_mask(text)
    for match in re.finditer(rf"\b{re.escape(field)}\s*=\s*\{{", masked[parent[0] + 1:parent[1]]):
        position = parent[0] + 1 + match.start()
        if _depth_between(masked, parent[0], position) == 0:
            opening = parent[0] + 1 + match.end() - 1
            return opening, _matching_brace(masked, opening)
    return None


def _entry_indent(text: str, table: tuple[int, int]) -> str:
    masked = _lua_code_mask(text)
    cursor = table[0] + 1
    depth = 0
    while cursor < table[1]:
        line_end = text.find("\n", cursor, table[1])
        if line_end < 0:
            line_end = table[1]
        raw = text[cursor:line_end]
        stripped = raw.lstrip(" \t")
        if stripped and not stripped.startswith("--") \
                and depth == 0 \
                and re.match(r"(?:\[|[A-Za-z_])", stripped):
            return raw[:len(raw) - len(stripped)]
        code_line = masked[cursor:line_end]
        depth += code_line.count("{") - code_line.count("}")
        cursor = line_end + 1
    close_line = text.rfind("\n", 0, table[1]) + 1
    close_prefix = text[close_line:table[1]]
    if close_prefix.strip():
        open_line = text.rfind("\n", 0, table[0]) + 1
        base_indent = re.match(r"[ \t]*", text[open_line:table[0]]).group(0)
        return base_indent + "    "
    close_indent = close_prefix
    return close_indent + "    "


def _insert_table_lines(text: str, table: tuple[int, int], lines: list[str]) -> str:
    indent = _entry_indent(text, table)
    line_start = text.rfind("\n", 0, table[1]) + 1
    block = "".join(f"{indent}{line}\n" for line in lines)
    if text[line_start:table[1]].strip():
        open_line = text.rfind("\n", 0, table[0]) + 1
        base_indent = re.match(r"[ \t]*", text[open_line:table[0]]).group(0)
        content_end = table[1]
        while content_end > table[0] and text[content_end - 1] in " \t":
            content_end -= 1
        separator = "" if text[content_end - 1] in "{," else ","
        return (
            text[:content_end] + separator + "\n" + block + base_indent
            + text[table[1]:]
        )
    return text[:line_start] + block + text[line_start:]


def _ensure_entity(
    text: str,
    parent_pattern: str,
    key: str,
    create_lines: list[str],
) -> tuple[str, tuple[int, int], bool]:
    parent = _declared_table(text, parent_pattern)
    entity = _keyed_table(text, parent, key)
    if entity:
        return text, entity, False
    text = _insert_table_lines(text, parent, create_lines)
    parent = _declared_table(text, parent_pattern)
    entity = _keyed_table(text, parent, key)
    if not entity:
        raise ValueError(f"failed to create catalog entry {key}")
    return text, entity, True


def _insert_nested_mapping(
    text: str,
    parent_pattern: str,
    entity_key: str,
    nested_field: str | None,
    mapping_key: str,
    translation: str,
) -> str:
    if nested_field:
        create = [f"{entity_key} = {{", f"    {nested_field} = {{", 
                  f"        {mapping_key} = {translation},", "    },", "},"]
    else:
        create = [f"{entity_key} = {{", f"    {mapping_key} = {translation},", "},"]
    text, entity, created = _ensure_entity(text, parent_pattern, entity_key, create)
    if created:
        return text
    target = entity
    if nested_field:
        nested = _field_table(text, entity, nested_field)
        if not nested:
            text = _insert_table_lines(text, entity, [
                f"{nested_field} = {{", f"    {mapping_key} = {translation},", "},",
            ])
            return text
        target = nested
    return _insert_table_lines(text, target, [f"{mapping_key} = {translation},"])


def apply_unit_to_catalog(text: str, unit: dict[str, Any]) -> str:
    """Insert one reviewed translation into an existing canonical Lua table."""
    apply = unit["apply"]
    kind = apply["kind"]
    source = lua_quote(unit["source"])
    translation = lua_quote(unit["translation"])
    simple_tables = {
        "object": r"addonTable\.object\s*=\s*\{",
        "zone": r"addonTable\.zone\s*=\s*\{",
        "ui": r"local\s+ui\s*=\s*\{",
        "ui_settings": r"local\s+settings\s*=\s*\{",
        "skill": r"local\s+skills\s*=\s*\{",
        "system_chat": r"\bexact\s*=\s*\{",
    }
    if kind in simple_tables:
        table = _declared_table(text, simple_tables[kind])
        return _insert_table_lines(text, table, [f"[{source}] = {translation},"])

    entity_tables = {
        "item_name": r"local\s+items\s*=\s*\{",
        "item_tooltip": r"local\s+items\s*=\s*\{",
        "npc_name": r"local\s+npc\s*=\s*\{",
        "npc_subtitle": r"local\s+npc\s*=\s*\{",
        "spell_name": r"addonTable\.spell\s*=\s*\{",
        "aura_line": r"addonTable\.spell\s*=\s*\{",
    }
    if kind in entity_tables:
        identity = apply["id"]
        entity_key = f"[{identity}]"
        if kind in {"item_name", "npc_name", "spell_name"}:
            create = [f"{entity_key} = {{ [1] = {translation}, en = {source} }},"]
            text, entity, created = _ensure_entity(
                text, entity_tables[kind], entity_key, create
            )
            if created:
                return text
            return _insert_table_lines(text, entity, [f"[1] = {translation},", f"en = {source},"])
        if kind == "npc_subtitle":
            create = [f"{entity_key} = {{ [2] = {translation}, en = {source} }},"]
            text, entity, created = _ensure_entity(
                text, entity_tables[kind], entity_key, create
            )
            if created:
                return text
            return _insert_table_lines(text, entity, [f"[2] = {translation},"])
        field = "tooltip_lines" if kind == "item_tooltip" else "aura_lines"
        return _insert_nested_mapping(
            text, entity_tables[kind], entity_key, field, f"[{source}]", translation
        )

    if kind in {"quest_field", "quest_task"}:
        pattern = r"local\s+verified_updates\s*=\s*\{"
        entity_key = f"[{apply['id']}]"
        if kind == "quest_field":
            return _insert_nested_mapping(
                text, pattern, entity_key, None, f"[{apply['index']}]", translation
            )
        return _insert_nested_mapping(text, pattern, entity_key, "tasks", f"[{source}]", translation)
    if kind == "book_page":
        return _insert_nested_mapping(
            text, r"local\s+book\s*=\s*\{", f"[{_book_lua_key(apply)}]", None,
            f"[{apply['page']}]", translation,
        )
    if kind == "gossip":
        return _insert_nested_mapping(
            text, r"local\s+verified_entries\s*=\s*\{", f"[{apply['npc_id']}]", None,
            f"[{lua_quote(apply['code'])}]", translation,
        )
    if kind == "chat":
        return _insert_nested_mapping(
            text, r"local\s+verified_entries\s*=\s*\{", f"[{lua_quote(apply['npc'])}]", None,
            f"[{lua_quote(apply['code'])}]", translation,
        )
    raise ValueError(f"unsupported apply kind: {kind}")


def prepare_changes(repo: Path, units: list[dict[str, Any]], update_existing: bool = False
                    ) -> tuple[dict[str, str], list[dict[str, Any]]]:
    state = CatalogState(repo)
    grouped: dict[str, list[str]] = defaultdict(list)
    decisions: list[dict[str, Any]] = []
    seen_ids: set[str] = set()
    for unit in units:
        if unit.get("id") in seen_ids:
            decisions.append({"id": unit.get("id"), "status": "rejected", "reason": "duplicate unit id"})
            continue
        seen_ids.add(unit.get("id"))
        errors = validate_translation(unit)
        identity_error = state.book_identity_error(unit)
        if identity_error and identity_error not in errors:
            errors.append(identity_error)
        if errors:
            decisions.append({"id": unit.get("id"), "status": "rejected", "reason": "; ".join(errors)})
            continue
        existing, owner = state.existing_for(unit)
        if existing and not update_existing:
            decisions.append({
                "id": unit["id"], "status": "skipped_existing",
                "existing_translation": existing, "existing_owner": owner,
            })
            continue
        target = unit["target"]
        if not target or not (repo / target).is_file():
            decisions.append({"id": unit["id"], "status": "rejected", "reason": "target file is missing"})
            continue
        grouped[target].extend(render_catalog_entry(unit) + [""])
        decisions.append({"id": unit["id"], "status": "ready", "target": target})
    fragments = {
        target: "-- Catalog-native entries prepared by automation/catalog_apply.py.\n"
                + "\n".join(lines).rstrip() + "\n"
        for target, lines in grouped.items()
    }
    return fragments, decisions


def write_fragments(output: Path, fragments: dict[str, str], decisions: list[dict[str, Any]]) -> None:
    output.mkdir(parents=True, exist_ok=True)
    for stale in output.glob("entries__*.lua"):
        stale.unlink()
    for target, content in fragments.items():
        fragment_path = output / target.replace("/", "__")
        fragment_path.write_text(content, encoding="utf-8")
    _write_json(output / "apply_report.json", decisions)


def apply_fragments(
    repo: Path,
    fragments: dict[str, str],
    units: list[dict[str, Any]],
    decisions: list[dict[str, Any]],
) -> list[str]:
    """Apply ready units inside canonical Lua tables, never after the file."""
    ready_ids = {
        decision["id"] for decision in decisions if decision.get("status") == "ready"
    }
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for unit in units:
        if unit.get("id") in ready_ids:
            grouped[unit["target"]].append(unit)

    prepared: list[tuple[str, Path, str]] = []
    for target in fragments:
        path = (repo / target).resolve()
        if repo.resolve() not in path.parents:
            raise RuntimeError(f"target escaped repository: {path}")
        updated = path.read_text(encoding="utf-8")
        for unit in grouped[target]:
            updated = apply_unit_to_catalog(updated, unit)
        prepared.append((target, path, updated))
    changed: list[str] = []
    for target, path, updated in prepared:
        temporary = path.with_suffix(path.suffix + ".tmp")
        temporary.write_text(updated, encoding="utf-8", newline="\n")
        temporary.replace(path)
        changed.append(target)
    return changed


def load_units(path: Path) -> list[dict[str, Any]]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, list):
        raise ValueError("translation worklist must contain a JSON array")
    return value
