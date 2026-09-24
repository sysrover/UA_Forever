# UA Forever

Experimental Ukrainian localization addon for World of Warcraft: Forever Beta.

Target client: `wow_forever_beta`, build `1.60.1.69977`, Interface `16001`.

The addon is based on [ClassicUA](https://github.com/greenya/ClassicUA) and
reuses its original-world translation data under `entries/forever`, but has a
separate Forever integration layer built around the modern Mainline UI/API. It
does not load the legacy ClassicUA frame hooks, options UI, or talent hooks.

## Current scope

- quest titles and text in visible quest frames, tracker rows, and tooltips;
- gossip text, replies, and quest titles;
- zone and taxi-node names;
- translated item, spell, aura, and NPC tooltip blocks;
- NPC chat and chat bubbles;
- target and nameplate NPC names.
- known standard interface strings and a visible-UI translation pass;
- ClassicUA terminology takes priority, with a Camelot-only Game Menu and
  Settings dictionary applied through safe FontString hooks;
- Ukrainian-capable replacements for the standard UI fonts;
- an EN/UA switch on the quest conversation window;
- an API/frame/data compatibility scanner with persistent ID collection.
- one-time automatic capture of newly opened panels, tabs, and Settings
  categories; Camelot Settings pages are distinguished by the visible content
  of the right-hand panel.

Classic data is used as a fallback and may not match new or changed Forever
content. Seen quest, NPC, item, spell, object, map, and area IDs are accumulated
under `UA_ForeverDB.scan.ids`; missing translations are stored under
`UA_ForeverDB.missing`. Automatically visited menu keys and scan statistics are
stored under `UA_ForeverDB.scan.menus`. WoW writes this table to the account SavedVariables file
when the UI reloads or the client exits.

## Commands

- `/uaf` or `/uaf status`
- `/uaf on`
- `/uaf off`
- `/uaf dev on`
- `/uaf dev off`
- `/uaf owner` — show the translation claim for the control under the cursor
- `/uaf tooltip [rows]` — show visible tooltip rows and their translation claims (use a macro while hovering)
- `/uaf aura 5` — watch for a known aura tooltip for five seconds (hover its icon), save the result to `UA_ForeverDB.scan.auraProbe`, then use `/reload`; `UA_ForeverDB.scan.auraCapture` records whether a tooltip was found; `/uaf aura` captures immediately while hovering
- `/uaf window 8` — watch for any visible tooltip window for eight seconds, save its entire object tree and public text to `UA_ForeverDB.scan.windowProbe`, then use `/reload`; secret text is marked without saving its value
- `/uaf ui`
- `/uaf capture [delay in seconds]`
- `/uaf scan`
- `/uaf report`
- `/uaf menus`
- `/uaf autoscan on`
- `/uaf autoscan off`

## Translation audits

Run `python tools/audit_translation_conflicts.py`,
`python tools/audit_domain_overrides.py`, and
`python tools/audit_pattern_overlaps.py` when updating dictionaries. The audits
record 79 existing domain field overrides and 15 exact UI keys that overlap
patterns. New or changed overlaps fail the test suite until reviewed. The
baselines record existing behavior; they do not authorize new overrides.

The Forever beta may change its UI API between builds. Test after every client
update and update the TOC Interface number when Blizzard changes it.
