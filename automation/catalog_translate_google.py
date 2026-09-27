"""Fill an autoscan worklist with reviewable Google translation drafts.

This script never updates addon catalogs. It only fills empty ``translation``
fields in a JSON worklist; catalog_apply.py remains the separate review/apply
step.
"""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import os
import re
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Callable

from catalog_pipeline import validate_translation


GOOGLE_ENDPOINT = "https://translation.googleapis.com/language/translate/v2"
PROTECTED_TOKEN = re.compile(
    r"\|A[^|]*\|a|\|T[^|]*\|t|\|H[^|]*\|h|\|h|"
    r"\|c[0-9A-Fa-f]{8}|\|r|\|n|"
    r"%(?:\d+\$)?[-+ #0]*(?:\d+|\*)?(?:\.\d+)?[cdeEfgGiouXxqs%]|"
    r"\{[^{}]+\}|\$[A-Za-z_][A-Za-z0-9_]*"
)


def mask_protected_tokens(source: str) -> tuple[str, dict[str, str]]:
    """Replace placeholders and WoW markup with markers Google must preserve."""
    replacements: dict[str, str] = {}
    digest = hashlib.sha1(source.encode("utf-8")).hexdigest()[:8].upper()

    def replace(match: re.Match[str]) -> str:
        marker = f"UAFTOKEN{digest}{len(replacements):04d}"
        while marker in source or marker in replacements:
            marker += "X"
        replacements[marker] = match.group(0)
        return marker

    return PROTECTED_TOKEN.sub(replace, source), replacements


def restore_protected_tokens(translated: str, replacements: dict[str, str]) -> str:
    """Restore protected values and reject a draft if a marker was changed."""
    restored = translated
    for marker, original in replacements.items():
        if restored.count(marker) != 1:
            raise ValueError(f"Google changed or removed protected marker {marker}")
        restored = restored.replace(marker, original)
    if re.search(r"UAFTOKEN[0-9A-F]{8}\d{4}", restored):
        raise ValueError("Google returned an unknown protected marker")
    return restored


class GoogleCloudTranslator:
    """Small client for the official Cloud Translation Basic v2 endpoint."""

    def __init__(self, api_key: str, source: str, target: str, timeout: float) -> None:
        self.api_key = api_key
        self.source = source
        self.target = target
        self.timeout = timeout

    def __call__(self, texts: list[str]) -> list[str]:
        body = json.dumps({
            "q": texts,
            "source": self.source,
            "target": self.target,
            "format": "text",
        }).encode("utf-8")
        url = GOOGLE_ENDPOINT + "?" + urllib.parse.urlencode({"key": self.api_key})
        request = urllib.request.Request(
            url,
            data=body,
            headers={"Content-Type": "application/json; charset=utf-8"},
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                payload = json.load(response)
        except urllib.error.HTTPError as exc:
            message = f"Google Cloud Translation returned HTTP {exc.code}"
            try:
                error_payload = json.loads(exc.read().decode("utf-8"))
                detail = error_payload.get("error", {}).get("message")
                if isinstance(detail, str) and detail:
                    message += f": {detail}"
            except (UnicodeDecodeError, json.JSONDecodeError, AttributeError):
                pass
            raise RuntimeError(message) from None
        except urllib.error.URLError as exc:
            raise RuntimeError(f"Could not reach Google Cloud Translation: {exc.reason}") from None

        translations = payload.get("data", {}).get("translations", [])
        if len(translations) != len(texts):
            raise RuntimeError("Google Cloud Translation returned an unexpected result count")
        result: list[str] = []
        for item in translations:
            value = item.get("translatedText") if isinstance(item, dict) else None
            if not isinstance(value, str):
                raise RuntimeError("Google Cloud Translation returned an invalid translation")
            result.append(html.unescape(value))
        return result


def fill_translations(
    units: list[dict],
    translate: Callable[[list[str]], list[str]],
    batch_size: int,
) -> tuple[int, int, list[str]]:
    """Fill safe empty rows, deduplicating identical source strings."""
    pending: dict[str, list[int]] = {}
    skipped = 0
    failures: list[str] = []
    for index, unit in enumerate(units):
        translation = unit.get("translation")
        if isinstance(translation, str) and translation.strip():
            skipped += 1
            continue
        if not unit.get("safe_to_apply", False):
            failures.append(f"{unit.get('id', index)}: requires manual review")
            continue
        personalized = unit.get("context", {}).get("personalized")
        if isinstance(personalized, str) and personalized:
            failures.append(
                f"{unit.get('id', index)}: personalized gossip needs a manual runtime tag"
            )
            continue
        source = unit.get("source")
        if not isinstance(source, str) or not source:
            failures.append(f"{unit.get('id', index)}: source is empty")
            continue
        pending.setdefault(source, []).append(index)

    sources = list(pending)
    completed = 0
    for offset in range(0, len(sources), batch_size):
        source_batch = sources[offset:offset + batch_size]
        masked_batch: list[str] = []
        replacement_batch: list[dict[str, str]] = []
        for source in source_batch:
            masked, replacements = mask_protected_tokens(source)
            masked_batch.append(masked)
            replacement_batch.append(replacements)
        translated_batch = translate(masked_batch)
        if len(translated_batch) != len(source_batch):
            raise RuntimeError("translator returned an unexpected result count")

        for source, translated, replacements in zip(
            source_batch, translated_batch, replacement_batch
        ):
            try:
                restored = restore_protected_tokens(translated, replacements).strip()
            except ValueError as exc:
                failures.append(f"{units[pending[source][0]].get('id')}: {exc}")
                continue
            source_completed = True
            for index in pending[source]:
                candidate = {**units[index], "translation": restored}
                errors = validate_translation(candidate)
                if errors:
                    failures.append(f"{units[index].get('id', index)}: {'; '.join(errors)}")
                    source_completed = False
                    continue
                units[index]["translation"] = restored
                completed += 1
            if not source_completed:
                continue
    return completed, skipped, failures


def write_json_atomic(path: Path, payload: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    handle, temporary_name = tempfile.mkstemp(
        prefix=path.name + ".", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(handle, "w", encoding="utf-8", newline="\n") as stream:
            json.dump(payload, stream, ensure_ascii=False, indent=2)
            stream.write("\n")
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def main() -> int:
    repo = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(
        description="Fill empty worklist translations using Google Cloud Translation Basic."
    )
    parser.add_argument(
        "worklist",
        nargs="?",
        type=Path,
        default=repo / "automation/results/needs_translation.json",
    )
    parser.add_argument("--output", type=Path, help="write a copy instead of updating the worklist")
    parser.add_argument("--source-language", default="en")
    parser.add_argument("--target-language", default="uk")
    parser.add_argument("--batch-size", type=int, default=50)
    parser.add_argument("--timeout", type=float, default=30.0)
    args = parser.parse_args()

    if not 1 <= args.batch_size <= 128:
        parser.error("--batch-size must be between 1 and 128")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    api_key = os.environ.get("GOOGLE_TRANSLATE_API_KEY", "").strip()
    if not api_key:
        parser.error("set GOOGLE_TRANSLATE_API_KEY before running this script")

    worklist = args.worklist.resolve()
    output = args.output.resolve() if args.output else worklist
    try:
        payload = json.loads(worklist.read_text(encoding="utf-8"))
    except FileNotFoundError:
        parser.error(f"worklist does not exist: {worklist}")
    except json.JSONDecodeError as exc:
        parser.error(f"invalid JSON in {worklist}: {exc}")
    if not isinstance(payload, list) or not all(isinstance(row, dict) for row in payload):
        parser.error("worklist must be a JSON array of translation records")

    translator = GoogleCloudTranslator(
        api_key, args.source_language, args.target_language, args.timeout
    )
    try:
        completed, skipped, failures = fill_translations(
            payload, translator, args.batch_size
        )
    except RuntimeError as exc:
        print(f"Translation failed: {exc}")
        return 2

    write_json_atomic(output, payload)
    print(f"Filled {completed} translations in {output}")
    print(f"Kept {skipped} already completed translations unchanged")
    if failures:
        print(f"Left {len(failures)} entries empty for manual review:")
        for failure in failures:
            print(f"  {failure}")
        return 2
    print("Review every translation, then preview it with catalog_apply.py without --apply.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
