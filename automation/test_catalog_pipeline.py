from __future__ import annotations

import unittest
from pathlib import Path

from catalog_pipeline import (
    CatalogState,
    apply_unit_to_catalog,
    analyze,
    classify_ui_kind,
    ignored_source_reason,
    lua_quote,
    parse_autoscan,
    placeholder_signature,
    units_for_record,
    validate_translation,
)


class CatalogPipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.catalog_state = CatalogState(Path(__file__).resolve().parents[1])

    def test_parse_autoscan_lua_values(self) -> None:
        records = parse_autoscan(
            '[UI] | 1\n\n# 42\ntext = "Line\\nTwo"\nslot = "GameMenu.Button"\n'
        )
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0].fields["text"], "Line\nTwo")
        self.assertEqual(records[0].fields["slot"], "GameMenu.Button")

    def test_parse_multiline_lua_q_string(self) -> None:
        records = parse_autoscan(
            '[BOOKS] | 1\n\n# 10:1\nbookID = 10\npage = 1\ntext = "First\\\nSecond"\n'
        )
        self.assertEqual(records[0].fields["text"], "First\nSecond")

    def test_object_book_title_becomes_translation_work(self) -> None:
        record = parse_autoscan(
            '[BOOKS] | 1\n\n'
            '# Arathor and the Troll Wars:1\n'
            'page = 1\n'
            'name = "Arathor and the Troll Wars"\n'
            'text = "The page text."\n'
        )[0]

        result = analyze([record], self.catalog_state)

        self.assertEqual(len(result["needs_translation"]), 1)
        unit = result["needs_translation"][0]
        self.assertEqual(
            unit["apply"],
            {
                "kind": "book_page",
                "book_name": "Arathor and the Troll Wars",
                "page": 1,
            },
        )
        self.assertTrue(unit["safe_to_apply"])

    def test_unknown_book_title_stays_in_review(self) -> None:
        record = parse_autoscan(
            '[BOOKS] | 1\n\n'
            '# Unknown Exhibit:1\n'
            'page = 1\n'
            'name = "Unknown Exhibit"\n'
            'text = "The page text."\n'
        )[0]

        result = analyze([record], self.catalog_state)

        self.assertEqual(len(result["review"]), 1)
        self.assertEqual(
            result["review"][0]["reason"],
            "book title is not an exact object catalog key",
        )

    def test_title_book_identity_cannot_be_retargeted(self) -> None:
        record = parse_autoscan(
            '[BOOKS] | 1\n\n'
            '# Arathor and the Troll Wars:1\n'
            'page = 1\n'
            'name = "Arathor and the Troll Wars"\n'
            'text = "The page text."\n'
        )[0]
        unit = units_for_record(record)[0]
        unit["apply"]["book_name"] = "Horde Catapult"

        self.assertEqual(
            self.catalog_state.book_identity_error(unit),
            "book title/page do not match the scan identity",
        )

    def test_record_key_keeps_significant_spaces(self) -> None:
        records = parse_autoscan('[SYSTEM_CHAT] | 1\n\n#   padded text  \n')
        self.assertEqual(records[0].key, "  padded text  ")

    def test_ui_is_split_by_surface(self) -> None:
        self.assertEqual(classify_ui_kind("GameMenuFrame.Button"), "menus")
        self.assertEqual(classify_ui_kind("AuctionHouseFrame.Header.Text"), "widgets")
        self.assertEqual(classify_ui_kind(None), "other")

    def test_item_tooltip_units_are_safe(self) -> None:
        record = parse_autoscan(
            '[ITEMS] | 1\n\n# 10\nname = "Sword"\n2 Left = "Binds when picked up"\n'
        )[0]
        units = units_for_record(record)
        self.assertEqual([unit["apply"]["kind"] for unit in units],
                         ["item_name", "item_tooltip"])

    def test_spell_descriptions_require_review(self) -> None:
        record = parse_autoscan(
            '[SPELLS] | 1\n\n# 20\nname = "Fire"\n2 Left = "Deals 10 damage."\n'
        )[0]
        units = units_for_record(record)
        self.assertFalse(units[1]["safe_to_apply"])

    def test_markup_signature_preserves_structural_tokens(self) -> None:
        source = "Use %s |A:icon:16:16|a {ім'я:к}|n"
        translation = "Використати %s |A:icon:16:16|a {ім'я:к}|n"
        self.assertEqual(placeholder_signature(source), placeholder_signature(translation))
        self.assertNotEqual(placeholder_signature(source), placeholder_signature("Використати"))

    def test_personalized_gossip_uses_template_code_and_allows_runtime_tag(self) -> None:
        record = parse_autoscan(
            '[GOSSIPS] | 1\n\n'
            '# 12197:normalized-code\n'
            'text = "Darrin, are ye ready?"\n'
            'template = "<name>, are ye ready?"\n'
            'personalized = "name"\n'
            'personalizationConfidence = "exact"\n'
            'translationHint = "{ім\'я:<відмінок>}"\n'
            'templateCode = "normalized-code"\n'
        )[0]
        unit = units_for_record(record)[0]
        self.assertEqual(unit["apply"]["code"], "normalized-code")
        self.assertEqual(unit["context"]["template"], "<name>, are ye ready?")
        unit["translation"] = "{Ім'я:к}, ти готовий?"
        self.assertEqual(validate_translation(unit), [])

    def test_runtime_name_tag_is_rejected_for_static_gossip(self) -> None:
        record = parse_autoscan(
            '[GOSSIPS] | 1\n\n# 1:static-code\ntext = "Are you ready?"\n'
        )[0]
        unit = units_for_record(record)[0]
        unit["translation"] = "{Ім'я:к}, ти готовий?"
        self.assertIn(
            "placeholders or WoW markup do not match the source",
            validate_translation(unit),
        )

    def test_lua_quote(self) -> None:
        self.assertEqual(lua_quote('a"b\\c\n'), '"a\\"b\\\\c\\n"')

    def test_ignored_source_matches_exact_section_and_source(self) -> None:
        unit = {"section": "UI", "source": "iLvl"}
        rules = [{
            "section": "UI",
            "source": "iLvl",
            "reason": "Keep the standard abbreviation",
        }]
        self.assertEqual(
            ignored_source_reason(unit, rules),
            "Keep the standard abbreviation",
        )
        self.assertIsNone(
            ignored_source_reason({"section": "ITEMS", "source": "iLvl"}, rules)
        )

    def test_reported_object_with_local_translation_is_not_applied(self) -> None:
        class State:
            @staticmethod
            def existing_for(unit):
                return "Високий престол", "entries/forever/catalogs/objects/catalog.lua"

        record = parse_autoscan('[OBJECTS] | 1\n\n# The High Seat\n')[0]
        result = analyze([record], State())
        self.assertEqual(len(result["not_applied"]), 1)
        self.assertEqual(result["not_applied"][0]["context"], {
            "owner": "object-tooltip",
            "slot": "object.name",
            "surface": "GameTooltip",
        })
        self.assertNotIn("existing", result)

    def test_already_translated_visible_zone_is_not_work(self) -> None:
        record = parse_autoscan(
            '[ZONES] | 1\n\n# The Mystic Ward\n'
            'visible = "Містичний квартал"\n'
            'owner = "zone-minimap"\n'
        )[0]
        self.assertEqual(units_for_record(record), [])

        class State:
            pass

        self.assertEqual(dict(analyze([record], State())), {})

    def test_object_entry_is_inserted_inside_existing_table(self) -> None:
        source = (
            'local _, addonTable = ...\n'
            'addonTable.object = {\n["Existing"] = "Наявний",\n}\n\n'
            'addonTable.translate_object_name = function (name)\n    return name\nend\n'
        )
        unit = {
            "source": "New Object",
            "translation": "Новий об'єкт",
            "apply": {"kind": "object"},
        }

        updated = apply_unit_to_catalog(source, unit)

        self.assertIn('["New Object"] = "Новий об\'єкт",\n}', updated)
        self.assertTrue(updated.endswith("    return name\nend\n"))
        self.assertNotIn("catalog-pipeline", updated)

    def test_nested_tooltip_is_added_to_catalog_entry(self) -> None:
        source = (
            'local _, addonTable = ...\nlocal items = {\n'
            '[10] = { "Предмет", en="Item" },\n}\n'
        )
        unit = {
            "source": "Use: Test",
            "translation": "Використання: тест",
            "apply": {"kind": "item_tooltip", "id": 10},
        }

        updated = apply_unit_to_catalog(source, unit)

        self.assertIn(
            'tooltip_lines = {\n        ["Use: Test"] = "Використання: тест",\n    },',
            updated,
        )
        self.assertLess(updated.index("tooltip_lines"), updated.rindex("}"))

    def test_title_keyed_book_page_is_added_to_catalog(self) -> None:
        source = (
            'local _, addonTable = ...\nlocal book = {\n'
            '[10] = { "Наявна сторінка" },\n}\n'
        )
        unit = {
            "source": "The page text.",
            "translation": "Текст сторінки.",
            "apply": {
                "kind": "book_page",
                "book_name": "Arathor and the Troll Wars",
                "page": 1,
            },
        }

        updated = apply_unit_to_catalog(source, unit)

        self.assertIn(
            '["Arathor and the Troll Wars"] = {\n'
            '    [1] = "Текст сторінки.",\n'
            '},',
            updated,
        )

    def test_lua_table_parser_ignores_braces_in_strings_and_comments(self) -> None:
        source = (
            'local ui = {\n'
            '    ["Brace { in text"] = "дужка } у тексті", -- } ignored\n'
            '}\nlocal after = true\n'
        )
        unit = {
            "source": "Next",
            "translation": "Далі",
            "apply": {"kind": "ui"},
        }

        updated = apply_unit_to_catalog(source, unit)

        self.assertIn('    ["Next"] = "Далі",\n}', updated)
        self.assertTrue(updated.endswith("local after = true\n"))

    def test_ui_pattern_must_return_an_actual_translation(self) -> None:
        for source in (
            "Requires: Level 18, Defensive Stance",
            "Requires: Level 16, Defensive Stance",
            "Requires: Level 18, Thunder Clap (Rank 1)",
            "Requires: Level 20, Rend (Rank 2)",
        ):
            with self.subTest(source=source):
                translated = self.catalog_state.ui_pattern_translation(source)
                self.assertIsInstance(translated, str)
                self.assertNotEqual(translated, source)

    def test_system_template_candidate_prefers_specific_pattern(self) -> None:
        candidate = self.catalog_state.system_catalog_candidate(
            "Agulha seems to be sobering up."
        )
        self.assertIsNotNone(candidate)
        self.assertEqual(candidate[1], "%s seems to be sobering up.")

    def test_translated_tooltip_with_binding_suffix_is_not_unapplied(self) -> None:
        record = parse_autoscan(
            '[NOT_APPLIED] | 1\n\n# item-tooltip:item.name:test\n'
            'owner = "item-tooltip"\nslot = "item.name"\n'
            'text = "Red Linen Bag"\ntranslation = "Червона лляна сумка"\n'
            'visible = "Червона лляна сумка (F9)"\n'
            'reason = "OVERWRITTEN_AFTER_APPLY"\n[NOT_APPLIED]\n'
        )[0]

        self.assertEqual(dict(analyze([record], object())), {})


if __name__ == "__main__":
    unittest.main()
