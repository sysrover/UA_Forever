# UA Forever

Experimental Ukrainian localization addon for World of Warcraft: Forever Beta.

Target client: `wow_classic_beta`, build `1.60.1.69913`, Interface `16001`.

The addon reuses the original-world translation data from ClassicUA under
`entries/forever`, but has a separate
Forever integration layer built around the modern Mainline UI/API. It does not
load the legacy ClassicUA frame hooks, options UI, or talent hooks.

## Current scope

- quest titles and text exposed by the quest APIs;
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
- `/uaf ui`
- `/uaf capture [delay in seconds]`
- `/uaf scan`
- `/uaf report`
- `/uaf menus`
- `/uaf autoscan on`
- `/uaf autoscan off`

The Forever beta may change its UI API between builds. Test after every client
update and update the TOC Interface number when Blizzard changes it.
