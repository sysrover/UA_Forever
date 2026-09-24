# UA Forever

UA Forever is a Ukrainian localization addon for World of Warcraft: Forever
Beta, built for its modern Camelot interface. It translates quests, tooltips,
menus, character and profession panels, chat, NPC names, and other visible text.
Hold Shift to see the original tooltip; quest conversations have an EN/UA
switch. Target client: `wow_forever_beta` build `1.60.1.69977` (Interface
`16001`).

## ClassicUA translations

We use Ukrainian texts and terminology from ClassicUA for classic quests,
NPCs, items, spells, gossip, books, zones, and basic interface strings. We
adapted those texts for Forever and added new translations. UA Forever has its
own Camelot integration; it does not load ClassicUA's old UI hooks.

ClassicUA: [GitHub](https://github.com/greenya/ClassicUA) ·
[CurseForge](https://www.curseforge.com/wow/addons/classicua).

Classic translations can be outdated when Forever changes a spell or quest.
The bundled client catalog is tagged `1.60.1.69913`; `/uaf scan` reports its
build mismatch until it is regenerated for `1.60.1.69977`.

## Commands

- `/uaf [status|on|off]` and `/uaf dev on|off`
- `/uaf ui`, `/uaf capture [seconds]`, `/uaf scan`, `/uaf report`
- `/uaf menus`, `/uaf autoscan on|off`
- `/uaf owner`, `/uaf tooltip [rows]`, `/uaf aura [seconds]`, `/uaf window [seconds]`

Scanned IDs, missing translations, menu captures, and diagnostics are saved in
`UA_ForeverDB` when the client reloads or exits. Run the translation audits in
`tools/` when changing dictionaries. The pattern overlap audit currently fails
because its baseline still uses old pattern positions.
