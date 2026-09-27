"""Tests for the machine-draft worklist filler."""

from __future__ import annotations

import unittest

from catalog_pipeline import _unit_identifier
from catalog_translate_google import (
    fill_translations,
    mask_protected_tokens,
    restore_protected_tokens,
)


def unit(source: str, record_key: str = "record") -> dict:
    return {
        "id": _unit_identifier("UI", record_key, "text", source),
        "section": "UI",
        "record_key": record_key,
        "field": "text",
        "source": source,
        "translation": "",
        "target": "entries/forever/catalogs/ui/core.lua",
        "apply": {"kind": "ui"},
        "context": {},
        "safe_to_apply": True,
        "reason": None,
    }


class GoogleDraftTests(unittest.TestCase):
    def test_fills_only_empty_translation(self) -> None:
        rows = [unit("Hello"), unit("Goodbye", "second")]
        rows[1]["translation"] = "До побачення"

        completed, skipped, failures = fill_translations(
            rows, lambda texts: ["Привіт" for _ in texts], 50
        )

        self.assertEqual((completed, skipped, failures), (1, 1, []))
        self.assertEqual(rows[0]["translation"], "Привіт")
        self.assertEqual(rows[1]["translation"], "До побачення")

    def test_protected_tokens_are_restored(self) -> None:
        source = "Hello %s |cffff0000world|r|n$PLAYER"
        masked, replacements = mask_protected_tokens(source)
        translated = masked.replace("Hello", "Привіт").replace("world", "світе")

        restored = restore_protected_tokens(translated, replacements)

        self.assertEqual(restored, "Привіт %s |cffff0000світе|r|n$PLAYER")

    def test_changed_marker_is_left_for_manual_review(self) -> None:
        rows = [unit("Hello %s")]

        completed, skipped, failures = fill_translations(
            rows, lambda texts: [texts[0].replace("UAFTOKEN", "BROKEN")], 50
        )

        self.assertEqual((completed, skipped), (0, 0))
        self.assertEqual(rows[0]["translation"], "")
        self.assertIn("changed or removed protected marker", failures[0])

    def test_duplicate_sources_are_sent_once_and_fill_each_row(self) -> None:
        rows = [unit("Hello", "first"), unit("Hello", "second")]
        calls: list[list[str]] = []

        def translate(texts: list[str]) -> list[str]:
            calls.append(texts)
            return ["Привіт"]

        completed, skipped, failures = fill_translations(rows, translate, 50)

        self.assertEqual(calls, [["Hello"]])
        self.assertEqual((completed, skipped, failures), (2, 0, []))
        self.assertEqual([row["translation"] for row in rows], ["Привіт", "Привіт"])

    def test_masking_is_deterministic(self) -> None:
        self.assertEqual(mask_protected_tokens("Value: %d"), mask_protected_tokens("Value: %d"))

    def test_personalized_gossip_is_left_for_manual_tag(self) -> None:
        row = unit("Darrin, are you ready?")
        row["apply"] = {"kind": "gossip", "npc_id": 1, "code": "normalized"}
        row["context"] = {
            "personalized": "name",
            "template": "<name>, are you ready?",
            "translationHint": "{ім'я:<відмінок>}",
        }

        completed, skipped, failures = fill_translations(
            [row], lambda texts: ["Цей виклик не має виконуватися"], 50
        )

        self.assertEqual((completed, skipped), (0, 0))
        self.assertEqual(row["translation"], "")
        self.assertIn("personalized gossip needs a manual runtime tag", failures[0])


if __name__ == "__main__":
    unittest.main()
