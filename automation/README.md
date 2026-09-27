# Catalog automation

The pipeline converts an in-game autoscan export into checked translation
worklists and then writes reviewed translations directly to the canonical
domain catalogs. It never creates `*_manual.lua` files.

```powershell
python -m pip install -r automation/requirements.txt
python automation/catalog_scan.py build/log.txt
```

Review `summary.json`, `not_applied.json`, and `review.json`.
Translate only the empty `translation` values in
`automation/results/needs_translation.json` or the smaller files under
`automation/results/translate/`. UI findings are additionally split into
`ui/menus.json`, `ui/widgets.json`, and `ui/other.json`.

Personalized gossip keeps the exact rendered English `source` for evidence
and adds `context.template`, `context.personalized`, and
`context.translationHint`. Do not edit `source`, `record_key`, or `apply`.
Use the indicated runtime token only inside `translation`, choosing the
Ukrainian grammatical case required by the sentence (for example
`{ім'я:к}` or `{клас:к}`). The normalized gossip code makes the reviewed
translation reusable by characters with another name or class. The Google
draft step leaves these rows empty because it cannot choose the Ukrainian case
reliably.

Strings intentionally left untranslated belong in
`automation/ignored_sources.json`. Each rule matches the exact `section` and
`source`; the scanner moves matching findings to `results/ignored.json` and
records the supplied reason.

The autoscan export is an unresolved-work report, not a full inventory. If a
reported source already has a translation in the current repository, the
pipeline puts it in `not_applied.json` instead of `existing.json`: the client
did not resolve or retain that translation. Records include `surface`,
`owner`, and `slot` where the client can observe them. UI files under
`results/ui/` include both missing translations and application failures, with
a `status` field distinguishing them.

To create a machine-translated draft, enable Google Cloud Translation Basic
and set its API key only in the environment:

```powershell
$env:GOOGLE_TRANSLATE_API_KEY = "your-api-key"
python automation/catalog_translate_google.py
```

The script updates only empty `translation` fields in
`automation/results/needs_translation.json`, preserves placeholders and WoW
markup, and writes the JSON atomically. It does not update addon catalogs.
Review every machine translation before continuing.

Generate reviewable Lua fragments without changing catalogs:

```powershell
python automation/catalog_apply.py automation/results/needs_translation.json
```

After reviewing `automation/results/ready/`, apply the same validated worklist:

```powershell
python automation/catalog_apply.py automation/results/needs_translation.json --apply
```

Existing translations are skipped by default. Use `--update-existing` only
for an explicitly reviewed correction. Placeholder or WoW-markup mismatches,
blank translations, unsafe tooltip schemas, and missing target files are
rejected before any catalog is changed. Apply inserts catalog-native entries
inside the existing Lua tables; it does not append standalone assignment
blocks after the catalog implementation.
