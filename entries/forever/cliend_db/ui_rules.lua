-- Canonical translations, consolidated with the existing winning values.
local _, addonTable = ...

do
-- Forever/Camelot UI strings that are not present in the Classic Era table.
-- These are display-only replacements; global Blizzard string constants are
-- intentionally left untouched because Camelot also uses some as lookup keys.
local ui = {
    ["\nCrab Cake"] = addonTable.forever_ui["\nCrab Cake"],
    ["\nSpiced Wolf Meat"] = addonTable.forever_ui["\nSpiced Wolf Meat"],
    ["\nSpider Sausage"] = addonTable.forever_ui["\nSpider Sausage"],
    ["(Elite)"] = addonTable.forever_ui["(Elite)"],
    ["(Tier 1)"] = addonTable.forever_ui["(Tier 1)"],
    ["+1 Frost Resistance"] = addonTable.forever_ui["+1 Frost Resistance"],
    ["+1 Shadow Resistance"] = addonTable.forever_ui["+1 Shadow Resistance"],
    ["+1 Stamina"] = addonTable.forever_ui["+1 Stamina"],
    ["- Great for cross-game friends\n- Invite any player (members join as their BattleTag)"] = addonTable.forever_ui["- Great for cross-game friends\n- Invite any player (members join as their BattleTag)"],
    ["- Great for cross-game friends|n- Invite any player (members join as their BattleTag)"] = addonTable.forever_ui["- Great for cross-game friends|n- Invite any player (members join as their BattleTag)"],
    ["- Great for in-game friends\n- Invite characters from any realm\n- Calendar and Quick Join support"] = addonTable.forever_ui["- Great for in-game friends\n- Invite characters from any realm\n- Calendar and Quick Join support"],
    ["- Great for in-game friends|n- Invite characters from any realm|n- Calendar and Quick Join support"] = addonTable.forever_ui["- Great for in-game friends|n- Invite characters from any realm|n- Calendar and Quick Join support"],
    ["0.0 Sec"] = addonTable.forever_ui["0.0 Sec"],
    ["1.5 Sec"] = addonTable.forever_ui["1.5 Sec"],
    ["120 FPS"] = addonTable.forever_ui["120 FPS"],
    ["17 Health"] = addonTable.forever_ui["17 Health"],
    ["1920x1080"] = addonTable.forever_ui["1920x1080"],
    ["1920x1080 (100%)"] = addonTable.forever_ui["1920x1080 (100%)"],
    ["200% of normal experience gained from monsters."] = addonTable.forever_ui["200% of normal experience gained from monsters."],
    ["30 FPS"] = addonTable.forever_ui["30 FPS"],
    ["6 Minutes until release"] = addonTable.forever_ui["6 Minutes until release"],
    ["60 FPS"] = addonTable.forever_ui["60 FPS"],
    ["<Click for Bag Settings>"] = addonTable.forever_ui["<Click for Bag Settings>"],
    ["<Click to view Quest Details>"] = addonTable.forever_ui["<Click to view Quest Details>"],
    ["<Right click for Frame Settings>"] = addonTable.forever_ui["<Right click for Frame Settings>"],
    ["<Right click for Tab Settings>"] = addonTable.forever_ui["<Right click for Tab Settings>"],
    ["<Shift click to buy a different amount>"] = addonTable.forever_ui["<Shift click to buy a different amount>"],
    ["A guild is a tight-knit group of players who want to enjoy the game together. By joining a guild, you'll gain access to many benefits, including a shared guild bank and a guild chat channel.|n|nConsider forming a guild of your own if you have friends who also play World of Warcraft. To create a guild, talk to a Guild Master in a major city."] = addonTable.forever_ui["A guild is a tight-knit group of players who want to enjoy the game together. By joining a guild, you'll gain access to many benefits, including a shared guild bank and a guild chat channel.|n|nConsider forming a guild of your own if you have friends who also play World of Warcraft. To create a guild, talk to a Guild Master in a major city."],
    ["A self-found character cannot do the following:\r\n- Trade with other players\r\n- Send mail to other players, or receive player mail\r\n- Buy or sell from the auction house\r\nThese restrictions can be removed at any time by talking to an in-game character, but it can never be applied outside of character creation."] = addonTable.forever_ui["A self-found character cannot do the following:\r\n- Trade with other players\r\n- Send mail to other players, or receive player mail\r\n- Buy or sell from the auction house\r\nThese restrictions can be removed at any time by talking to an in-game character, but it can never be applied outside of character creation."],
    ["A strong attack that increases melee damage by 11 and causes a high amount of threat."] = addonTable.forever_ui["A strong attack that increases melee damage by 11 and causes a high amount of threat."],
    ["A strong attack that increases melee damage by 21 and causes a high amount of threat."] = addonTable.forever_ui["A strong attack that increases melee damage by 21 and causes a high amount of threat."],
    ["Abandon"] = addonTable.forever_ui["Abandon"],
    ["Absorb"] = addonTable.forever_ui["Absorb"],
    ["Accept"] = addonTable.forever_ui["Accept"],
    ["Accept quests by talking to characters with a ! above their head."] = addonTable.forever_ui["Accept quests by talking to characters with a ! above their head."],
    ["Account Collections"] = addonTable.forever_ui["Account Collections"],
    ["Achievements"] = addonTable.forever_ui["Achievements"],
    ["Action Bar 8"] = addonTable.forever_ui["Action Bar 8"],
    ["Add Community"] = addonTable.forever_ui["Add Community"],
    ["AddOn List"] = addonTable.forever_ui["AddOn List"],
    ["AddOn Usage"] = addonTable.forever_ui["AddOn Usage"],
    ["AddOns"] = addonTable.forever_ui["AddOns"],
    ["Adventure Guide"] = addonTable.forever_ui["Adventure Guide"],
    ["Agility:"] = addonTable.forever_ui["Agility:"],
    ["Ah, well aren't you a sturdy-looking one? Perhaps you can assist me with a thing or two. Not much help around here except for green apprentices, and they've other things to worry about."] = addonTable.forever_ui["Ah, well aren't you a sturdy-looking one? Perhaps you can assist me with a thing or two. Not much help around here except for green apprentices, and they've other things to worry about."],
    ["Aku'mai kills (Blackfathom Deeps)"] = addonTable.forever_ui["Aku'mai kills (Blackfathom Deeps)"],
    ["Alchemy Recipes learned"] = addonTable.forever_ui["Alchemy Recipes learned"],
    ["All Objectives"] = addonTable.forever_ui["All Objectives"],
    ["Alliance Auction House"] = addonTable.forever_ui["Alliance Auction House"],
    ["Allows the dwarf to sense nearby treasure, making it appear on the minimap.  Lasts until canceled."] = addonTable.forever_ui["Allows the dwarf to sense nearby treasure, making it appear on the minimap.  Lasts until canceled."],
    ["Allows the miner to smelt a chunk of copper ore into a copper bar. Smelting copper requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of copper ore into a copper bar. Smelting copper requires a forge."],
    ["Allows the miner to smelt a chunk of gold ore into a gold bar.  Smelting gold requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of gold ore into a gold bar.  Smelting gold requires a forge."],
    ["Allows the miner to smelt a chunk of iron ore and a lump of coal together into a steel bar.  Smelting steel requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of iron ore and a lump of coal together into a steel bar.  Smelting steel requires a forge."],
    ["Allows the miner to smelt a chunk of iron ore into an iron bar.  Smelting iron requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of iron ore into an iron bar.  Smelting iron requires a forge."],
    ["Allows the miner to smelt a chunk of mithril ore into a mithril bar.  Smelting mithril requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of mithril ore into a mithril bar.  Smelting mithril requires a forge."],
    ["Allows the miner to smelt a chunk of silver ore into a silver bar.  Smelting silver requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of silver ore into a silver bar.  Smelting silver requires a forge."],
    ["Allows the miner to smelt a chunk of thorium ore into a thorium bar.  Smelting thorium requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of thorium ore into a thorium bar.  Smelting thorium requires a forge."],
    ["Allows the miner to smelt a chunk of tin ore into a tin bar.  Smelting tin requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of tin ore into a tin bar.  Smelting tin requires a forge."],
    ["Allows the miner to smelt a chunk of truesilver ore into a truesilver bar.  Smelting truesilver requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a chunk of truesilver ore into a truesilver bar.  Smelting truesilver requires a forge."],
    ["Allows the miner to smelt a tin bar and a copper bar together into two bronze bars.  Smelting bronze requires a forge."] = addonTable.forever_ui["Allows the miner to smelt a tin bar and a copper bar together into two bronze bars.  Smelting bronze requires a forge."],
    ["Alterac Valley Honorable Kills"] = addonTable.forever_ui["Alterac Valley Honorable Kills"],
    ["Alterac Valley Killing Blows"] = addonTable.forever_ui["Alterac Valley Killing Blows"],
    ["Alterac Valley battles"] = addonTable.forever_ui["Alterac Valley battles"],
    ["Alterac Valley towers captured"] = addonTable.forever_ui["Alterac Valley towers captured"],
    ["Alterac Valley towers defended"] = addonTable.forever_ui["Alterac Valley towers defended"],
    ["Alterac Valley victories"] = addonTable.forever_ui["Alterac Valley victories"],
    ["Ammo Pouch"] = addonTable.forever_ui["Ammo Pouch"],
    ["Amnennar the Coldbringer kills (Razorfen Downs)"] = addonTable.forever_ui["Amnennar the Coldbringer kills (Razorfen Downs)"],
    ["Appearances"] = addonTable.forever_ui["Appearances"],
    ["Apply Changes"] = addonTable.forever_ui["Apply Changes"],
    ["Arathi Basin Honorable Kills"] = addonTable.forever_ui["Arathi Basin Honorable Kills"],
    ["Arathi Basin Killing Blows"] = addonTable.forever_ui["Arathi Basin Killing Blows"],
    ["Arathi Basin battles"] = addonTable.forever_ui["Arathi Basin battles"],
    ["Arathi Basin victories"] = addonTable.forever_ui["Arathi Basin victories"],
    ["Arcane:"] = addonTable.forever_ui["Arcane:"],
    ["Archaedas kills (Uldaman)"] = addonTable.forever_ui["Archaedas kills (Uldaman)"],
    ["Archmage Arugal kills (Shadowfang Keep)"] = addonTable.forever_ui["Archmage Arugal kills (Shadowfang Keep)"],
    ["Armor Piercing:"] = addonTable.forever_ui["Armor Piercing:"],
    ["Armor Proficiency"] = addonTable.forever_ui["Armor Proficiency"],
    ["Armor:"] = addonTable.forever_ui["Armor:"],
    ["Arms"] = addonTable.forever_ui["Arms"],
    ["Arrow"] = addonTable.forever_ui["Arrow"],
    ["At War"] = addonTable.forever_ui["At War"],
    ["Attack"] = addonTable.forever_ui["Attack"],
    ["Attack Power:"] = addonTable.forever_ui["Attack Power:"],
    ["Attack Speed (seconds)"] = addonTable.forever_ui["Attack Speed (seconds)"],
    ["Auction purchases"] = addonTable.forever_ui["Auction purchases"],
    ["Auctions posted"] = addonTable.forever_ui["Auctions posted"],
    ["Average gold earned per day"] = addonTable.forever_ui["Average gold earned per day"],
    ["Average quests completed per day"] = addonTable.forever_ui["Average quests completed per day"],
    ["Axe"] = addonTable.forever_ui["Axe"],
    ["Back"] = addonTable.forever_ui["Back"],
    ["Backpack"] = addonTable.forever_ui["Backpack"],
    ["Bag Slots:"] = addonTable.forever_ui["Bag Slots:"],
    ["Bandage used most"] = addonTable.forever_ui["Bandage used most"],
    ["Bandages"] = addonTable.forever_ui["Bandages"],
    ["Bandages used"] = addonTable.forever_ui["Bandages used"],
    ["Baron Rivendare kills (Stratholme)"] = addonTable.forever_ui["Baron Rivendare kills (Stratholme)"],
    ["Battle.net"] = addonTable.forever_ui["Battle.net"],
    ["Battleground Honorable Kills"] = addonTable.forever_ui["Battleground Honorable Kills"],
    ["Battleground Killing Blows"] = addonTable.forever_ui["Battleground Killing Blows"],
    ["Battleground played the most"] = addonTable.forever_ui["Battleground played the most"],
    ["Battleground with the most Honorable Kills"] = addonTable.forever_ui["Battleground with the most Honorable Kills"],
    ["Battleground with the most Killing Blows"] = addonTable.forever_ui["Battleground with the most Killing Blows"],
    ["Battleground won the most"] = addonTable.forever_ui["Battleground won the most"],
    ["Battlegrounds played"] = addonTable.forever_ui["Battlegrounds played"],
    ["Battlegrounds won"] = addonTable.forever_ui["Battlegrounds won"],
    ["Bazil Thredd kills (Stormwind Stockade)"] = addonTable.forever_ui["Bazil Thredd kills (Stormwind Stockade)"],
    ["Bazzalan kills (Ragefire Chasm)"] = addonTable.forever_ui["Bazzalan kills (Ragefire Chasm)"],
    ["Beverages consumed"] = addonTable.forever_ui["Beverages consumed"],
    ["Big Game Hunter"] = addonTable.forever_ui["Big Game Hunter"],
    ["Blacksmithing Plans learned"] = addonTable.forever_ui["Blacksmithing Plans learned"],
    ["Blasts nearby enemies, increasing the time between their attacks by 20% for 10 sec and doing 10 damage to them. Will affect up to 4 targets."] = addonTable.forever_ui["Blasts nearby enemies, increasing the time between their attacks by 20% for 10 sec and doing 10 damage to them. Will affect up to 4 targets."],
    ["Blazeroar Kills (Alcaz Prison)"] = addonTable.forever_ui["Blazeroar Kills (Alcaz Prison)"],
    ["Blizzard Whispers"] = addonTable.forever_ui["Blizzard Whispers"],
    ["Block"] = addonTable.forever_ui["Block"],
    ["Block:"] = addonTable.forever_ui["Block:"],
    ["Bloom Intensity"] = addonTable.forever_ui["Bloom Intensity"],
    ["Bolt Kills (Shaper's Terrace)"] = addonTable.forever_ui["Bolt Kills (Shaper's Terrace)"],
    ["Book"] = addonTable.forever_ui["Book"],
    ["Boss Frames"] = addonTable.forever_ui["Boss Frames"],
    ["Boss Kills"] = addonTable.forever_ui["Boss Kills"],
    ["Bow"] = addonTable.forever_ui["Bow"],
    ["Buffs and Debuffs"] = addonTable.forever_ui["Buffs and Debuffs"],
    ["Bullet"] = addonTable.forever_ui["Bullet"],
    ["Buyback"] = addonTable.forever_ui["Buyback"],
    ["By disabling transmogrification you will no longer see any appearances applied to other players' gear via transmogrification. You will only see the equipment other players actually have equipped. Are you sure you wish to disable transmogrification? You may re-enable this at any time by speaking with me again."] = addonTable.forever_ui["By disabling transmogrification you will no longer see any appearances applied to other players' gear via transmogrification. You will only see the equipment other players actually have equipped. Are you sure you wish to disable transmogrification? You may re-enable this at any time by speaking with me again."],
    ["By enabling transmogrification you will see any custom appearances applied to your own and other players' equipment via transmogrification. Are you sure you wish to enable transmogrification? You may disable transmogrification at any time by speaking with me again."] = addonTable.forever_ui["By enabling transmogrification you will see any custom appearances applied to your own and other players' equipment via transmogrification. Are you sure you wish to enable transmogrification? You may disable transmogrification at any time by speaking with me again."],
    ["Call to Arms: Arathi Basin"] = addonTable.forever_ui["Call to Arms: Arathi Basin"],
    ["Call to Arms: Darkspear Islands"] = addonTable.forever_ui["Call to Arms: Darkspear Islands"],
    ["Call to Arms: Warsong Gulch"] = addonTable.forever_ui["Call to Arms: Warsong Gulch"],
    ["Can't attack while incapacitated."] = addonTable.forever_ui["Can't attack while incapacitated."],
    ["Can't do that while incapacitated"] = addonTable.forever_ui["Can't do that while incapacitated"],
    ["Cancel"] = addonTable.forever_ui["Cancel"],
    ["Cannot change equip status while in combat"] = addonTable.forever_ui["Cannot change equip status while in combat"],
    ["Cast Bar"] = addonTable.forever_ui["Cast Bar"],
    ["Change Name/Icon"] = addonTable.forever_ui["Change Name/Icon"],
    ["Channeling"] = addonTable.forever_ui["Channeling"],
    ["Charlga Razorflank kills (Razorfen Kraul)"] = addonTable.forever_ui["Charlga Razorflank kills (Razorfen Kraul)"],
    ["Chief Ukorz Sandscalp kills (Zul'Farrak)"] = addonTable.forever_ui["Chief Ukorz Sandscalp kills (Zul'Farrak)"],
    ["Choose your reward:"] = addonTable.forever_ui["Choose your reward:"],
    ["Cinder Kills (Shaper's Terrace)"] = addonTable.forever_ui["Cinder Kills (Shaper's Terrace)"],
    ["Civilian"] = addonTable.forever_ui["Civilian"],
    ["Classic"] = addonTable.forever_ui["Classic"],
    ["Click To Edit"] = addonTable.forever_ui["Click To Edit"],
    ["Close"] = addonTable.forever_ui["Close"],
    ["Coldridge Valley"] = addonTable.forever_ui["Coldridge Valley"],
    ["Combat Audio Alert Say Target's Casts Voice set to %s"] = addonTable.forever_ui["Combat Audio Alert Say Target's Casts Voice set to %s"],
    ["Combat Audio Alerts are currently disabled. To enable them, type /<spell>tts</spell>combat"] = addonTable.forever_ui["Combat Audio Alerts are currently disabled. To enable them, type /<spell>tts</spell>combat"],
    ["Combat Log"] = addonTable.forever_ui["Combat Log"],
    ["Combined Backpack"] = addonTable.forever_ui["Combined Backpack"],
    ["Complete Quest"] = addonTable.forever_ui["Complete Quest"],
    ["Completing this quest while in Party Sync may reward:"] = addonTable.forever_ui["Completing this quest while in Party Sync may reward:"],
    ["Consumable"] = addonTable.forever_ui["Consumable"],
    ["Continent with the most Honorable Kills"] = addonTable.forever_ui["Continent with the most Honorable Kills"],
    ["Continent with the most Killing Blows"] = addonTable.forever_ui["Continent with the most Killing Blows"],
    ["Continue"] = addonTable.forever_ui["Continue"],
    ["Cooking"] = addonTable.forever_ui["Cooking"],
    ["Cooking Bag"] = addonTable.forever_ui["Cooking Bag"],
    ["Cooking Recipes known"] = addonTable.forever_ui["Cooking Recipes known"],
    ["Cooking daily quests completed"] = addonTable.forever_ui["Cooking daily quests completed"],
    ["Cooking skill"] = addonTable.forever_ui["Cooking skill"],
    ["Copper Bar"] = addonTable.forever_ui["Copper Bar"],
    ["Copper Ore"] = addonTable.forever_ui["Copper Ore"],
    ["Craft a Basic Campfire."] = addonTable.forever_ui["Craft a Basic Campfire."],
    ["Craft a First Aid Kit."] = addonTable.forever_ui["Craft a First Aid Kit."],
    ["Craft a Reagent Bot."] = addonTable.forever_ui["Craft a Reagent Bot."],
    ["Create"] = addonTable.forever_ui["Create"],
    ["Create All"] = addonTable.forever_ui["Create All"],
    ["Create Blizzard Group"] = addonTable.forever_ui["Create Blizzard Group"],
    ["Create World of Warcraft Community"] = addonTable.forever_ui["Create World of Warcraft Community"],
    ["Create World of Warcraft Community (Alliance or Cross-Faction)"] = addonTable.forever_ui["Create World of Warcraft Community (Alliance or Cross-Faction)"],
    ["Create World of Warcraft Community (Horde or Cross-Faction)"] = addonTable.forever_ui["Create World of Warcraft Community (Horde or Cross-Faction)"],
    ["Creates 3 Vials of Anti-Venom."] = addonTable.forever_ui["Creates 3 Vials of Anti-Venom."],
    ["Creates a Simple Poultice."] = addonTable.forever_ui["Creates a Simple Poultice."],
    ["Creature type killed the most"] = addonTable.forever_ui["Creature type killed the most"],
    ["Creatures"] = addonTable.forever_ui["Creatures"],
    ["Creatures killed"] = addonTable.forever_ui["Creatures killed"],
    ["Critical Strike:"] = addonTable.forever_ui["Critical Strike:"],
    ["Critters killed"] = addonTable.forever_ui["Critters killed"],
    ["Crossbow"] = addonTable.forever_ui["Crossbow"],
    ["Customer Support"] = addonTable.forever_ui["Customer Support"],
    ["DESCRIPTION"] = addonTable.forever_ui["DESCRIPTION"],
    ["DPS:"] = addonTable.forever_ui["DPS:"],
    ["Dagger"] = addonTable.forever_ui["Dagger"],
    ["Dalaran Cooking Awards gained"] = addonTable.forever_ui["Dalaran Cooking Awards gained"],
    ["Damage dealt versus Beasts increased by 5%."] = addonTable.forever_ui["Damage dealt versus Beasts increased by 5%."],
    ["Damage:"] = addonTable.forever_ui["Damage:"],
    ["Darkmaster Gandling kills (Scholomance)"] = addonTable.forever_ui["Darkmaster Gandling kills (Scholomance)"],
    ["Darkspear Island Killing Blows"] = addonTable.forever_ui["Darkspear Island Killing Blows"],
    ["Darkspear Island victories"] = addonTable.forever_ui["Darkspear Island victories"],
    ["Darkspear Islands Honorable Kills"] = addonTable.forever_ui["Darkspear Islands Honorable Kills"],
    ["Darkspear Islands battles"] = addonTable.forever_ui["Darkspear Islands battles"],
    ["Darnassus"] = addonTable.forever_ui["Darnassus"],
    ["Dead"] = addonTable.forever_ui["Dead"],
    ["Deaths from Drek'Thar"] = addonTable.forever_ui["Deaths from Drek'Thar"],
    ["Deaths from Hogger"] = addonTable.forever_ui["Deaths from Hogger"],
    ["Deaths from Vanndar Stormpike"] = addonTable.forever_ui["Deaths from Vanndar Stormpike"],
    ["Deaths from drowning"] = addonTable.forever_ui["Deaths from drowning"],
    ["Deaths from falling"] = addonTable.forever_ui["Deaths from falling"],
    ["Deaths from fatigue"] = addonTable.forever_ui["Deaths from fatigue"],
    ["Deaths from fire and lava"] = addonTable.forever_ui["Deaths from fire and lava"],
    ["Deaths in Alterac Valley"] = addonTable.forever_ui["Deaths in Alterac Valley"],
    ["Deaths in Arathi Basin"] = addonTable.forever_ui["Deaths in Arathi Basin"],
    ["Deaths in Darkspear Islands"] = addonTable.forever_ui["Deaths in Darkspear Islands"],
    ["Deaths in Warsong Gulch"] = addonTable.forever_ui["Deaths in Warsong Gulch"],
    ["Debuff Deadly Sting"] = addonTable.forever_ui["Debuff Deadly Sting"],
    ["Decline"] = addonTable.forever_ui["Decline"],
    ["Defense:"] = addonTable.forever_ui["Defense:"],
    ["Deflect"] = addonTable.forever_ui["Deflect"],
    ["Delete"] = addonTable.forever_ui["Delete"],
    ["Description"] = addonTable.forever_ui["Description"],
    ["Device"] = addonTable.forever_ui["Device"],
    ["Diceman Jr"] = addonTable.forever_ui["Diceman Jr"],
    ["Different creature types killed"] = addonTable.forever_ui["Different creature types killed"],
    ["Diminishing Returns (|cnRED_FONT_COLOR:Work in Progress)"] = addonTable.forever_ui["Diminishing Returns (|cnRED_FONT_COLOR:Work in Progress)"],
    ["Disable All"] = addonTable.forever_ui["Disable All"],
    ["Do you want to make Thunderbrew Distillery your new home?"] = addonTable.forever_ui["Do you want to make Thunderbrew Distillery your new home?"],
    ["Dodge"] = addonTable.forever_ui["Dodge"],
    ["Dodge:"] = addonTable.forever_ui["Dodge:"],
    ["Draught"] = addonTable.forever_ui["Draught"],
    ["Draughts"] = addonTable.forever_ui["Draughts"],
    ["Druid"] = addonTable.forever_ui["Druid"],
    ["Duels lost"] = addonTable.forever_ui["Duels lost"],
    ["Duels won"] = addonTable.forever_ui["Duels won"],
    ["Dungeon Journal"] = addonTable.forever_ui["Dungeon Journal"],
    ["Dungeons & Raids"] = addonTable.forever_ui["Dungeons & Raids"],
    ["Dungeons and Raids"] = addonTable.forever_ui["Dungeons and Raids"],
    ["Durgen Dirgehammer Kills (Hall of Thanes)"] = addonTable.forever_ui["Durgen Dirgehammer Kills (Hall of Thanes)"],
    ["Each week, the Rank Points cap is increased, up to a maximum of |cnHIGHLIGHT_FONT_COLOR:24750 for |cnHIGHLIGHT_FONT_COLOR:Rank 14."] = addonTable.forever_ui["Each week, the Rank Points cap is increased, up to a maximum of |cnHIGHLIGHT_FONT_COLOR:24750 for |cnHIGHLIGHT_FONT_COLOR:Rank 14."],
    ["Edit Mode"] = addonTable.forever_ui["Edit Mode"],
    ["Edwin Vancleef Kills (Deadmines)"] = addonTable.forever_ui["Edwin Vancleef Kills (Deadmines)"],
    ["Elixirs"] = addonTable.forever_ui["Elixirs"],
    ["Elixirs consumed"] = addonTable.forever_ui["Elixirs consumed"],
    ["Emote"] = addonTable.forever_ui["Emote"],
    ["Emperor Dagran Thaurissan kills (Blackrock Depths)"] = addonTable.forever_ui["Emperor Dagran Thaurissan kills (Blackrock Depths)"],
    ["Enable All"] = addonTable.forever_ui["Enable All"],
    ["Enable Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Functionality"] = addonTable.forever_ui["Enable Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Functionality"],
    ["Enchanting Bag"] = addonTable.forever_ui["Enchanting Bag"],
    ["Enchanting formulae learned"] = addonTable.forever_ui["Enchanting formulae learned"],
    ["Enemy Buffs, Personal Debuffs, Big Debuff"] = addonTable.forever_ui["Enemy Buffs, Personal Debuffs, Big Debuff"],
    ["Energy:"] = addonTable.forever_ui["Energy:"],
    ["Engineering Bag"] = addonTable.forever_ui["Engineering Bag"],
    ["Engineering Schematics learned"] = addonTable.forever_ui["Engineering Schematics learned"],
    ["English Voice 1 (Masculine)"] = addonTable.forever_ui["English Voice 1 (Masculine)"],
    ["Enter Macro Commands:"] = addonTable.forever_ui["Enter Macro Commands:"],
    ["Enter a community's invitation link or code:"] = addonTable.forever_ui["Enter a community's invitation link or code:"],
    ["Epic items acquired"] = addonTable.forever_ui["Epic items acquired"],
    ["Epic items looted"] = addonTable.forever_ui["Epic items looted"],
    ["Equip"] = addonTable.forever_ui["Equip"],
    ["Equip: Increases damage and healing done by magical spells and effects by up to 5."] = addonTable.forever_ui["Equip: Increases damage and healing done by magical spells and effects by up to 5."],
    ["Equipped"] = addonTable.forever_ui["Equipped"],
    ["Equipped epic items in item slots"] = addonTable.forever_ui["Equipped epic items in item slots"],
    ["Escort Miran to the excavation site (Complete)"] = addonTable.forever_ui["Escort Miran to the excavation site (Complete)"],
    ["Evade"] = addonTable.forever_ui["Evade"],
    ["Everyday Meals"] = addonTable.forever_ui["Everyday Meals"],
    ["Exit"] = addonTable.forever_ui["Exit"],
    ["Exit Game"] = addonTable.forever_ui["Exit Game"],
    ["Expertise:"] = addonTable.forever_ui["Expertise:"],
    ["Explore Dun Morogh"] = addonTable.forever_ui["Explore Dun Morogh"],
    ["Explosives"] = addonTable.forever_ui["Explosives"],
    ["Extra bank slots purchased"] = addonTable.forever_ui["Extra bank slots purchased"],
    ["Faction Tabard"] = addonTable.forever_ui["Faction Tabard"],
    ["Fill yer tankard and pull up a chair. We've stories to tell and kegs to empty."] = addonTable.forever_ui["Fill yer tankard and pull up a chair. We've stories to tell and kegs to empty."],
    ["Filter"] = addonTable.forever_ui["Filter"],
    ["Find Huldar, Miran, and Saean (Complete)"] = addonTable.forever_ui["Find Huldar, Miran, and Saean (Complete)"],
    ["Find Treasure"] = addonTable.forever_ui["Find Treasure"],
    ["Fire:"] = addonTable.forever_ui["Fire:"],
    ["First Aid"] = addonTable.forever_ui["First Aid"],
    ["First Aid Manuals learned"] = addonTable.forever_ui["First Aid Manuals learned"],
    ["First Aid skill"] = addonTable.forever_ui["First Aid skill"],
    ["First Profession"] = addonTable.forever_ui["First Profession"],
    ["Fish and other things caught"] = addonTable.forever_ui["Fish and other things caught"],
    ["Fish caught"] = addonTable.forever_ui["Fish caught"],
    ["Fishing"] = addonTable.forever_ui["Fishing"],
    ["Fishing Pole"] = addonTable.forever_ui["Fishing Pole"],
    ["Fishing daily quests completed"] = addonTable.forever_ui["Fishing daily quests completed"],
    ["Fishing skill"] = addonTable.forever_ui["Fishing skill"],
    ["Fist Weapon"] = addonTable.forever_ui["Fist Weapon"],
    ["Flasks"] = addonTable.forever_ui["Flasks"],
    ["Flasks consumed"] = addonTable.forever_ui["Flasks consumed"],
    ["Flight paths taken"] = addonTable.forever_ui["Flight paths taken"],
    ["Focus:"] = addonTable.forever_ui["Focus:"],
    ["Follow"] = addonTable.forever_ui["Follow"],
    ["Food eaten"] = addonTable.forever_ui["Food eaten"],
    ["For more information see our |HurlIndex:15|hPrivacy Policy|h"] = addonTable.forever_ui["For more information see our |HurlIndex:15|hPrivacy Policy|h"],
    ["For thousands of years, a band of high elven exiles has remained safe and hidden upon their flying sanctuary of Zephras Isle. These 'Skyborne', as they call themselves, shared a bond with air elementals who kept their island aloft in the realm of Skywall. But in recent years, the elementals vanished without a trace - disrupting the delicate magic that kept them safe in their haven amongst the clouds. Now, a new generation of Skyborne elves face a time of unprecedented change and must seek new allies and sources of magic - to protect their hidden home and secure their future..."] = addonTable.forever_ui["For thousands of years, a band of high elven exiles has remained safe and hidden upon their flying sanctuary of Zephras Isle. These 'Skyborne', as they call themselves, shared a bond with air elementals who kept their island aloft in the realm of Skywall. But in recent years, the elementals vanished without a trace - disrupting the delicate magic that kept them safe in their haven amongst the clouds. Now, a new generation of Skyborne elves face a time of unprecedented change and must seek new allies and sources of magic - to protect their hidden home and secure their future..."],
    ["Forge"] = addonTable.forever_ui["Forge"],
    ["Fought Together"] = addonTable.forever_ui["Fought Together"],
    ["Free Trial level cap reached."] = addonTable.forever_ui["Free Trial level cap reached."],
    ["Friendly"] = "Дружелюбність",
    ["Frost:"] = addonTable.forever_ui["Frost:"],
    ["Fury"] = addonTable.forever_ui["Fury"],
    ["Game Menu"] = addonTable.forever_ui["Game Menu"],
    ["Gear"] = addonTable.forever_ui["Gear"],
    ["General"] = addonTable.forever_ui["General"],
    ["General Drakkisath kills (Upper Blackrock Spire)"] = addonTable.forever_ui["General Drakkisath kills (Upper Blackrock Spire)"],
    ["General Macros"] = addonTable.forever_ui["General Macros"],
    ["General Tab"] = addonTable.forever_ui["General Tab"],
    ["Gives a chance to block enemy melee and ranged attacks."] = addonTable.forever_ui["Gives a chance to block enemy melee and ranged attacks."],
    ["Gnomeregan Exiles"] = "Вигнанці Гномреґана",
    ["Gold earned from auctions"] = addonTable.forever_ui["Gold earned from auctions"],
    ["Gold from quest rewards"] = addonTable.forever_ui["Gold from quest rewards"],
    ["Gold from vendors"] = addonTable.forever_ui["Gold from vendors"],
    ["Gold looted"] = addonTable.forever_ui["Gold looted"],
    ["Gold spent at barber shops"] = addonTable.forever_ui["Gold spent at barber shops"],
    ["Gold spent on postage"] = addonTable.forever_ui["Gold spent on postage"],
    ["Gold spent on talent tree respecs"] = addonTable.forever_ui["Gold spent on talent tree respecs"],
    ["Gold spent on travel"] = addonTable.forever_ui["Gold spent on travel"],
    ["Goodbye"] = addonTable.forever_ui["Goodbye"],
    ["Greed rolls made on loot"] = addonTable.forever_ui["Greed rolls made on loot"],
    ["Group Finder"] = addonTable.forever_ui["Group Finder"],
    ["Guild"] = addonTable.forever_ui["Guild"],
    ["Guild & Communities"] = addonTable.forever_ui["Guild & Communities"],
    ["Guild Config"] = addonTable.forever_ui["Guild Config"],
    ["Guild Finder"] = addonTable.forever_ui["Guild Finder"],
    ["Guild Master"] = addonTable.forever_ui["Guild Master"],
    ["Gun"] = addonTable.forever_ui["Gun"],
    ["HUD Edit Mode"] = addonTable.forever_ui["HUD Edit Mode"],
    ["Hail! Have a care, Datto, the tunnel to Dun Morogh is infested with troggs and is not safe for travel. If you haven't any pressing business in Dun Morogh, I'll have to ask you to remain in Anvilmar until the tunnel is safer."] = addonTable.forever_ui["Hail! Have a care, Datto, the tunnel to Dun Morogh is infested with troggs and is not safe for travel. If you haven't any pressing business in Dun Morogh, I'll have to ask you to remain in Anvilmar until the tunnel is safer."],
    ["Harvest Festival"] = addonTable.forever_ui["Harvest Festival"],
    ["Haste:"] = addonTable.forever_ui["Haste:"],
    ["Healing Potions"] = addonTable.forever_ui["Healing Potions"],
    ["Health potions consumed"] = addonTable.forever_ui["Health potions consumed"],
    ["Health:"] = addonTable.forever_ui["Health:"],
    ["Healthstones used"] = addonTable.forever_ui["Healthstones used"],
    ["Herb"] = addonTable.forever_ui["Herb"],
    ["Herb Bag"] = addonTable.forever_ui["Herb Bag"],
    ["High Inquisitor Whitemane kills (Scarlet Monastery)"] = addonTable.forever_ui["High Inquisitor Whitemane kills (Scarlet Monastery)"],
    ["Highest Alchemy skill"] = addonTable.forever_ui["Highest Alchemy skill"],
    ["Highest Blacksmithing skill"] = addonTable.forever_ui["Highest Blacksmithing skill"],
    ["Highest Enchanting skill"] = addonTable.forever_ui["Highest Enchanting skill"],
    ["Highest Engineering skill"] = addonTable.forever_ui["Highest Engineering skill"],
    ["Highest Herbalism skill"] = addonTable.forever_ui["Highest Herbalism skill"],
    ["Highest Inscription skill"] = addonTable.forever_ui["Highest Inscription skill"],
    ["Highest Leatherworking skill"] = addonTable.forever_ui["Highest Leatherworking skill"],
    ["Highest Mining skill"] = addonTable.forever_ui["Highest Mining skill"],
    ["Highest Skinning skill"] = addonTable.forever_ui["Highest Skinning skill"],
    ["Highest Tailoring skill"] = addonTable.forever_ui["Highest Tailoring skill"],
    ["Hit Chance:"] = addonTable.forever_ui["Hit Chance:"],
    ["Hm? You look a little young to be a siege engine pilot. But no matter...do you need something fixed? Well take a number and get comfortable. I'm working on a couple engines right now and won't have time for another job for at least a few days. Or, were you here for something else...?"] = addonTable.forever_ui["Hm? You look a little young to be a siege engine pilot. But no matter...do you need something fixed? Well take a number and get comfortable. I'm working on a couple engines right now and won't have time for another job for at least a few days. Or, were you here for something else...?"],
    ["Holiday"] = addonTable.forever_ui["Holiday"],
    ["Honor Points"] = addonTable.forever_ui["Honor Points"],
    ["Honor is gained by killing members of the opposite faction in PvP combat. You can use honor points to purchase special items."] = addonTable.forever_ui["Honor is gained by killing members of the opposite faction in PvP combat. You can use honor points to purchase special items."],
    ["Housing Dashboard"] = addonTable.forever_ui["Housing Dashboard"],
    ["Hunter"] = addonTable.forever_ui["Hunter"],
    ["Idol"] = addonTable.forever_ui["Idol"],
    ["Idols"] = addonTable.forever_ui["Idols"],
    ["Immune"] = addonTable.forever_ui["Immune"],
    ["Increase your pet's loyalty and level to gain Training Points."] = addonTable.forever_ui["Increase your pet's loyalty and level to gain Training Points."],
    ["Increased by |cFFFFFFFFAgility|r for Attacks\\r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"] = addonTable.forever_ui["Increased by |cFFFFFFFFAgility|r for Attacks\\r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"],
    ["Increased by |cFFFFFFFFAgility|r for Attacks|r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"] = addonTable.forever_ui["Increased by |cFFFFFFFFAgility|r for Attacks|r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"],
    ["Increases chance to |cFFFFFFFFBlock|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFFFFFFFBlock Value %d|r\\nIncreased by |cFFFFFFFFStrength|r\\n\\n|cFFBCBCBCBlocking reduces the attack's damage by your Block Value|r\\n\\n|cFFBCBCBCOnly Melee and Ranged attacks from the front may be Blocked|r"] = addonTable.forever_ui["Increases chance to |cFFFFFFFFBlock|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFFFFFFFBlock Value %d|r\\nIncreased by |cFFFFFFFFStrength|r\\n\\n|cFFBCBCBCBlocking reduces the attack's damage by your Block Value|r\\n\\n|cFFBCBCBCOnly Melee and Ranged attacks from the front may be Blocked|r"],
    ["Increases chance to |cFFFFFFFFDodge|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFAgility|r and |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCDodging nullifies the attack|r\\n\\n|cFFBCBCBCFor Players, only Melee attacks from the front may be Dodged\\n\\nFor Creatures, Melee attacks may be Dodged from any direction|r"] = addonTable.forever_ui["Increases chance to |cFFFFFFFFDodge|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFAgility|r and |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCDodging nullifies the attack|r\\n\\n|cFFBCBCBCFor Players, only Melee attacks from the front may be Dodged\\n\\nFor Creatures, Melee attacks may be Dodged from any direction|r"],
    ["Increases chance to |cFFFFFFFFParry|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCParrying nullifies the attack and reduces the time until the defender's next Melee attack by 40%%|r\\n\\n|cFFBCBCBCOnly Melee attacks from the front may be Parried|r"] = addonTable.forever_ui["Increases chance to |cFFFFFFFFParry|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCParrying nullifies the attack and reduces the time until the defender's next Melee attack by 40%%|r\\n\\n|cFFBCBCBCOnly Melee attacks from the front may be Parried|r"],
    ["Increases the damage of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Damage|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Damage\\n\\nSpell ranks far below your current level benefit less from Spell Damage and trigger class abilities less often|r"] = addonTable.forever_ui["Increases the damage of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Damage|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Damage\\n\\nSpell ranks far below your current level benefit less from Spell Damage and trigger class abilities less often|r"],
    ["Increases the healing of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Healing|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Healing\\n\\nSpell ranks far below your current level benefit less from Spell Healing and trigger class abilities less often|r"] = addonTable.forever_ui["Increases the healing of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Healing|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Healing\\n\\nSpell ranks far below your current level benefit less from Spell Healing and trigger class abilities less often|r"],
    ["Increases |cFFFFFFFFAttack Power|r by %d\\nIncreases |cFFFFFFFFBlock Value|r by %d"] = addonTable.forever_ui["Increases |cFFFFFFFFAttack Power|r by %d\\nIncreases |cFFFFFFFFBlock Value|r by %d"],
    ["Increases |cFFFFFFFFHealth|r by %s"] = addonTable.forever_ui["Increases |cFFFFFFFFHealth|r by %s"],
    ["Increases |cFFFFFFFFMelee|r critical chance by %.2f%%"] = addonTable.forever_ui["Increases |cFFFFFFFFMelee|r critical chance by %.2f%%"],
    ["Increases |cFFFFFFFFRanged|r critical chance by %.2f%%"] = addonTable.forever_ui["Increases |cFFFFFFFFRanged|r critical chance by %.2f%%"],
    ["Increases |cFFFFFFFFSpell|r critical chance by %.2f%%"] = addonTable.forever_ui["Increases |cFFFFFFFFSpell|r critical chance by %.2f%%"],
    ["Increases |cFFFFFFFFWeapon Skill|r improvement rate"] = addonTable.forever_ui["Increases |cFFFFFFFFWeapon Skill|r improvement rate"],
    ["Inert Enchanting Rods"] = addonTable.forever_ui["Inert Enchanting Rods"],
    ["Innkeeper"] = addonTable.forever_ui["Innkeeper"],
    ["Inscriptions learned"] = addonTable.forever_ui["Inscriptions learned"],
    ["Instance"] = addonTable.forever_ui["Instance"],
    ["Instance Entrances"] = addonTable.forever_ui["Instance Entrances"],
    ["Instance Leader"] = addonTable.forever_ui["Instance Leader"],
    ["Instantly removes and grants immunity to all Bleed, Poison, and Disease effects, and reduces all Physical damage taken by 10% for 8 sec."] = addonTable.forever_ui["Instantly removes and grants immunity to all Bleed, Poison, and Disease effects, and reduces all Physical damage taken by 10% for 8 sec."],
    ["Intellect:"] = addonTable.forever_ui["Intellect:"],
    ["Ironforge"] = addonTable.forever_ui["Ironforge"],
    ["Issue Reporter"] = addonTable.forever_ui["Issue Reporter"],
    ["Items"] = addonTable.forever_ui["Items"],
    ["Items disenchanted"] = addonTable.forever_ui["Items disenchanted"],
    ["Join"] = addonTable.forever_ui["Join"],
    ["Join Community"] = addonTable.forever_ui["Join Community"],
    ["Join or Create Community"] = addonTable.forever_ui["Join or Create Community"],
    ["Key"] = addonTable.forever_ui["Key"],
    ["King Gordok kills (Dire Maul)"] = addonTable.forever_ui["King Gordok kills (Dire Maul)"],
    ["Languages"] = addonTable.forever_ui["Languages"],
    ["Large (128MB)"] = addonTable.forever_ui["Large (128MB)"],
    ["Largest heal cast"] = addonTable.forever_ui["Largest heal cast"],
    ["Largest heal received"] = addonTable.forever_ui["Largest heal received"],
    ["Largest hit dealt"] = addonTable.forever_ui["Largest hit dealt"],
    ["Largest hit received"] = addonTable.forever_ui["Largest hit received"],
    ["Layout:"] = addonTable.forever_ui["Layout:"],
    ["Leatherworking Bag"] = addonTable.forever_ui["Leatherworking Bag"],
    ["Leatherworking Patterns learned"] = addonTable.forever_ui["Leatherworking Patterns learned"],
    ["Legacy"] = addonTable.forever_ui["Legacy"],
    ["Legendary items acquired"] = addonTable.forever_ui["Legendary items acquired"],
    ["Libram"] = addonTable.forever_ui["Libram"],
    ["Librams"] = addonTable.forever_ui["Librams"],
    ["Load out of date AddOns"] = addonTable.forever_ui["Load out of date AddOns"],
    ["Lockpick"] = addonTable.forever_ui["Lockpick"],
    ["Log Out"] = addonTable.forever_ui["Log Out"],
    ["Low-Level Quests"] = addonTable.forever_ui["Low-Level Quests"],
    ["Lyn the Ignored Kills (City of Dalaran)"] = addonTable.forever_ui["Lyn the Ignored Kills (City of Dalaran)"],
    ["Mace"] = addonTable.forever_ui["Mace"],
    ["Mace Specialization"] = addonTable.forever_ui["Mace Specialization"],
    ["Macros"] = addonTable.forever_ui["Macros"],
    ["Mage"] = addonTable.forever_ui["Mage"],
    ["Mage Portals taken"] = addonTable.forever_ui["Mage Portals taken"],
    ["Mage portal taken most"] = addonTable.forever_ui["Mage portal taken most"],
    ["Magic"] = addonTable.forever_ui["Magic"],
    ["Mail Belts"] = addonTable.forever_ui["Mail Belts"],
    ["Mail Boots"] = addonTable.forever_ui["Mail Boots"],
    ["Mail Bracers"] = addonTable.forever_ui["Mail Bracers"],
    ["Mail Chestguards"] = addonTable.forever_ui["Mail Chestguards"],
    ["Mail Gauntlets"] = addonTable.forever_ui["Mail Gauntlets"],
    ["Mail Legguards"] = addonTable.forever_ui["Mail Legguards"],
    ["Main Hand"] = addonTable.forever_ui["Main Hand"],
    ["Main Hand:"] = addonTable.forever_ui["Main Hand:"],
    ["Mana potions consumed"] = addonTable.forever_ui["Mana potions consumed"],
    ["Map & Quest Log"] = addonTable.forever_ui["Map & Quest Log"],
    ["Materials"] = addonTable.forever_ui["Materials"],
    ["Materials produced from disenchanting"] = addonTable.forever_ui["Materials produced from disenchanting"],
    ["Materials:"] = addonTable.forever_ui["Materials:"],
    ["Mekgineer Thermaplugg kills (Gnomeregan)"] = addonTable.forever_ui["Mekgineer Thermaplugg kills (Gnomeregan)"],
    ["Merchant"] = addonTable.forever_ui["Merchant"],
    ["Metal & Stone"] = addonTable.forever_ui["Metal & Stone"],
    ["Microsoft Zira Desktop - English (United States)"] = addonTable.forever_ui["Microsoft Zira Desktop - English (United States)"],
    ["Mining Bag"] = addonTable.forever_ui["Mining Bag"],
    ["Mining Pick"] = addonTable.forever_ui["Mining Pick"],
    ["Mining pick"] = addonTable.forever_ui["Mining pick"],
    ["Mining: Thorium Bar"] = addonTable.forever_ui["Mining: Thorium Bar"],
    ["Miss"] = addonTable.forever_ui["Miss"],
    ["Mob Buffs, Personal Debuffs, Shared CC"] = addonTable.forever_ui["Mob Buffs, Personal Debuffs, Shared CC"],
    ["Modifiers"] = addonTable.forever_ui["Modifiers"],
    ["More details about your group"] = addonTable.forever_ui["More details about your group"],
    ["Most Alliance factions at Exalted"] = addonTable.forever_ui["Most Alliance factions at Exalted"],
    ["Most Horde factions at Exalted"] = addonTable.forever_ui["Most Horde factions at Exalted"],
    ["Most expensive auction sold"] = addonTable.forever_ui["Most expensive auction sold"],
    ["Most expensive bid on auction"] = addonTable.forever_ui["Most expensive bid on auction"],
    ["Most factions at Exalted"] = addonTable.forever_ui["Most factions at Exalted"],
    ["Most factions at Honored or higher"] = addonTable.forever_ui["Most factions at Honored or higher"],
    ["Most factions at Revered or higher"] = addonTable.forever_ui["Most factions at Revered or higher"],
    ["Most gold ever owned"] = addonTable.forever_ui["Most gold ever owned"],
    ["Mounts owned"] = addonTable.forever_ui["Mounts owned"],
    ["Move to Inactive"] = addonTable.forever_ui["Move to Inactive"],
    ["Movement Speed:"] = addonTable.forever_ui["Movement Speed:"],
    ["Must be in Battle Stance"] = addonTable.forever_ui["Must be in Battle Stance"],
    ["Must be in Defensive Stance"] = addonTable.forever_ui["Must be in Defensive Stance"],
    ["Must have a Shield equipped"] = addonTable.forever_ui["Must have a Shield equipped"],
    ["Mutanus the Devourer kills (Wailing Caverns)"] = addonTable.forever_ui["Mutanus the Devourer kills (Wailing Caverns)"],
    ["Nanaya Kills (Shaper's Terrace)"] = addonTable.forever_ui["Nanaya Kills (Shaper's Terrace)"],
    ["Nature:"] = addonTable.forever_ui["Nature:"],
    ["Need rolls made on loot"] = addonTable.forever_ui["Need rolls made on loot"],
    ["New"] = addonTable.forever_ui["New"],
    ["New Recipe Learned!"] = addonTable.forever_ui["New Recipe Learned!"],
    ["New Set"] = addonTable.forever_ui["New Set"],
    ["Next"] = addonTable.forever_ui["Next"],
    ["Next melee"] = addonTable.forever_ui["Next melee"],
    ["No avoidable damage has been dealt. Avoidable damage tracking may not be available in all content."] = addonTable.forever_ui["No avoidable damage has been dealt. Avoidable damage tracking may not be available in all content."],
    ["No quests available"] = addonTable.forever_ui["No quests available"],
    ["No quests available|n|nAccept quests by talking to characters with a |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t above their head."] = addonTable.forever_ui["No quests available|n|nAccept quests by talking to characters with a |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t above their head."],
    ["No results found"] = addonTable.forever_ui["No results found"],
    ["No valid channels to link. Make sure you have Manage Channels permission on the server."] = addonTable.forever_ui["No valid channels to link. Make sure you have Manage Channels permission on the server."],
    ["Number of hugs"] = addonTable.forever_ui["Number of hugs"],
    ["Number of times hearthed"] = addonTable.forever_ui["Number of times hearthed"],
    ["Off Hand"] = addonTable.forever_ui["Off Hand"],
    ["Off Hand:"] = addonTable.forever_ui["Off Hand:"],
    ["Officer Chat"] = addonTable.forever_ui["Officer Chat"],
    ["Oh goodness Datto, this town is not well suited for the likes of me. There are as many nasty creatures here as there were in Gnomeregan before the accident! Do you have my belongings? If you don't, then who knows what the trolls have done with them now..."] = addonTable.forever_ui["Oh goodness Datto, this town is not well suited for the likes of me. There are as many nasty creatures here as there were in Gnomeregan before the accident! Do you have my belongings? If you don't, then who knows what the trolls have done with them now..."],
    ["One-Hand"] = addonTable.forever_ui["One-Hand"],
    ["One-Handed Exotics"] = addonTable.forever_ui["One-Handed Exotics"],
    ["Only Herbs can be placed in that."] = addonTable.forever_ui["Only Herbs can be placed in that."],
    ["Onyxia kills (Onyxia's Lair)"] = addonTable.forever_ui["Onyxia kills (Onyxia's Lair)"],
    ["Open All"] = addonTable.forever_ui["Open All"],
    ["Options"] = addonTable.forever_ui["Options"],
    ["Overlord Wyrmthalak kills (Lower Blackrock Spire)"] = addonTable.forever_ui["Overlord Wyrmthalak kills (Lower Blackrock Spire)"],
    ["Paladin"] = addonTable.forever_ui["Paladin"],
    ["Parry"] = addonTable.forever_ui["Parry"],
    ["Parry:"] = addonTable.forever_ui["Parry:"],
    ["Parts"] = addonTable.forever_ui["Parts"],
    ["Party"] = addonTable.forever_ui["Party"],
    ["Party Frames"] = addonTable.forever_ui["Party Frames"],
    ["Party Leader"] = addonTable.forever_ui["Party Leader"],
    ["Passive"] = addonTable.forever_ui["Passive"],
    ["Permanent"] = addonTable.forever_ui["Permanent"],
    ["Personal Buffs, Enemy Debuffs"] = addonTable.forever_ui["Personal Buffs, Enemy Debuffs"],
    ["Petition"] = addonTable.forever_ui["Petition"],
    ["Place %s back on your Action Bar to use it again."] = addonTable.forever_ui["Place %s back on your Action Bar to use it again."],
    ["Plate"] = addonTable.forever_ui["Plate"],
    ["Played World of Warcraft before?"] = addonTable.forever_ui["Played World of Warcraft before?"],
    ["Player vs. Player"] = addonTable.forever_ui["Player vs. Player"],
    ["Please enter a full character name."] = addonTable.forever_ui["Please enter a full character name."],
    ["Polearm"] = addonTable.forever_ui["Polearm"],
    ["Potions"] = addonTable.forever_ui["Potions"],
    ["Press F6 to submit an issue for this Item"] = addonTable.forever_ui["Press F6 to submit an issue for this Item"],
    ["Press F6 to submit an issue for this Spell"] = addonTable.forever_ui["Press F6 to submit an issue for this Spell"],
    ["Press|cFF00FFFF %s|r to %s"] = addonTable.forever_ui["Press|cFF00FFFF %s|r to %s"],
    ["Prev"] = addonTable.forever_ui["Prev"],
    ["Priest"] = addonTable.forever_ui["Priest"],
    ["Primary Attributes"] = addonTable.forever_ui["Primary Attributes"],
    ["Princess Theradras kills (Maraudon)"] = addonTable.forever_ui["Princess Theradras kills (Maraudon)"],
    ["Professions"] = addonTable.forever_ui["Professions"],
    ["Professions at maximum skill"] = addonTable.forever_ui["Professions at maximum skill"],
    ["Professions learned"] = addonTable.forever_ui["Professions learned"],
    ["Projectile"] = addonTable.forever_ui["Projectile"],
    ["Protection"] = addonTable.forever_ui["Protection"],
    ["Purchase has failed: insufficient funds."] = addonTable.forever_ui["Purchase has failed: insufficient funds."],
    ["PvP Ranks are currently unavailable."] = addonTable.forever_ui["PvP Ranks are currently unavailable."],
    ["QUEST OBJECTIVES"] = addonTable.forever_ui["QUEST OBJECTIVES"],
    ["Quest Difficulty Color"] = addonTable.forever_ui["Quest Difficulty Color"],
    ["Quest Item"] = addonTable.forever_ui["Quest Item"],
    ["Quest Log"] = addonTable.forever_ui["Quest Log"],
    ["Quest Objectives"] = addonTable.forever_ui["Quest Objectives"],
    ["Quest Timers"] = addonTable.forever_ui["Quest Timers"],
    ["Quests"] = addonTable.forever_ui["Quests"],
    ["Quests & Zones"] = addonTable.forever_ui["Quests & Zones"],
    ["Quests abandoned"] = addonTable.forever_ui["Quests abandoned"],
    ["Quests completed"] = addonTable.forever_ui["Quests completed"],
    ["REWARDS"] = addonTable.forever_ui["REWARDS"],
    ["Racial"] = addonTable.forever_ui["Racial"],
    ["Racial Passive"] = addonTable.forever_ui["Racial Passive"],
    ["Rage 20"] = addonTable.forever_ui["Rage 20"],
    ["Rage:"] = addonTable.forever_ui["Rage:"],
    ["Raid Leader"] = addonTable.forever_ui["Raid Leader"],
    ["Raid Warning"] = addonTable.forever_ui["Raid Warning"],
    ["Raise your herbalism skill to 20: 1/1"] = addonTable.forever_ui["Raise your herbalism skill to 20: 1/1"],
    ["Ranged"] = addonTable.forever_ui["Ranged"],
    ["Ranged Attack Power:"] = addonTable.forever_ui["Ranged Attack Power:"],
    ["Ranged:"] = addonTable.forever_ui["Ranged:"],
    ["Rath'mael Kills (Ruins of Lordaeron)"] = addonTable.forever_ui["Rath'mael Kills (Ruins of Lordaeron)"],
    ["Reagent"] = addonTable.forever_ui["Reagent"],
    ["Reagent Bag"] = addonTable.forever_ui["Reagent Bag"],
    ["Reagents:"] = addonTable.forever_ui["Reagents:"],
    ["Reagents:\nCopper Bar (4)"] = addonTable.forever_ui["Reagents:\nCopper Bar (4)"],
    ["Reagents:\nCopper Bar (6), Weak Flux, Linen Cloth (2)"] = addonTable.forever_ui["Reagents:\nCopper Bar (6), Weak Flux, Linen Cloth (2)"],
    ["Reagents:\nCrawler Meat, Mild Spices"] = addonTable.forever_ui["Reagents:\nCrawler Meat, Mild Spices"],
    ["Reagents:\nStringy Wolf Meat, Mild Spices"] = addonTable.forever_ui["Reagents:\nStringy Wolf Meat, Mild Spices"],
    ["Reagents:\nWhite Spider Meat (2)"] = addonTable.forever_ui["Reagents:\nWhite Spider Meat (2)"],
    ["Rebirthed by druids"] = addonTable.forever_ui["Rebirthed by druids"],
    ["Recipe"] = addonTable.forever_ui["Recipe"],
    ["Redeemed by paladins"] = addonTable.forever_ui["Redeemed by paladins"],
    ["Reflect"] = addonTable.forever_ui["Reflect"],
    ["Required Items:"] = addonTable.forever_ui["Required Items:"],
    ["Requires Herbalism 15"] = addonTable.forever_ui["Requires Herbalism 15"],
    ["Requires Reload"] = addonTable.forever_ui["Requires Reload"],
    ["Requires: Forge"] = addonTable.forever_ui["Requires: Forge"],
    ["Resist"] = addonTable.forever_ui["Resist"],
    ["Resistances"] = addonTable.forever_ui["Resistances"],
    ["Rested"] = addonTable.forever_ui["Rested"],
    ["Resurrected by priests"] = addonTable.forever_ui["Resurrected by priests"],
    ["Resurrected by soulstones"] = addonTable.forever_ui["Resurrected by soulstones"],
    ["Resurrection"] = addonTable.forever_ui["Resurrection"],
    ["Reticle Aiming: While the Targeting Modifier is active, move the HUD reticle in the center of the screen over a unit to target it.\\n\\nAnalog Stick Aiming: While the Targeting Modifier is active, tilt the Right Stick toward a unit to target it."] = addonTable.forever_ui["Reticle Aiming: While the Targeting Modifier is active, move the HUD reticle in the center of the screen over a unit to target it.\\n\\nAnalog Stick Aiming: While the Targeting Modifier is active, tilt the Right Stick toward a unit to target it."],
    ["Return to Game"] = addonTable.forever_ui["Return to Game"],
    ["Revert All Changes"] = addonTable.forever_ui["Revert All Changes"],
    ["Revived by druids"] = addonTable.forever_ui["Revived by druids"],
    ["Rewards"] = addonTable.forever_ui["Rewards"],
    ["Rewards may be purchased at the Champion's Hall in Stormwind."] = addonTable.forever_ui["Rewards may be purchased at the Champion's Hall in Stormwind."],
    ["Right-click an enemy to |cFFFFD200target|r it."] = addonTable.forever_ui["Right-click an enemy to |cFFFFD200target|r it."],
    ["Rogue"] = addonTable.forever_ui["Rogue"],
    ["Save"] = addonTable.forever_ui["Save"],
    ["Say"] = addonTable.forever_ui["Say"],
    ["Say Your Rage"] = addonTable.forever_ui["Say Your Rage"],
    ["Say:"] = addonTable.forever_ui["Say:"],
    ["Says when a debuff is applied to you"] = addonTable.forever_ui["Says when a debuff is applied to you"],
    ["Scarlet Commander Mograine kills (Scarlet Monastery)"] = addonTable.forever_ui["Scarlet Commander Mograine kills (Scarlet Monastery)"],
    ["Scrolls"] = addonTable.forever_ui["Scrolls"],
    ["Search Name, Guilds, Levels"] = addonTable.forever_ui["Search Name, Guilds, Levels"],
    ["Search Quest Log"] = addonTable.forever_ui["Search Quest Log"],
    ["Search abilities, keywords"] = addonTable.forever_ui["Search abilities, keywords"],
    ["Second Profession"] = addonTable.forever_ui["Second Profession"],
    ["Secondary Skills"] = addonTable.forever_ui["Secondary Skills"],
    ["Secondary skills at maximum skill"] = addonTable.forever_ui["Secondary skills at maximum skill"],
    ["Select a currency to view its details."] = addonTable.forever_ui["Select a currency to view its details."],
    ["Select a faction to view its details."] = addonTable.forever_ui["Select a faction to view its details."],
    ["Sell Price:"] = addonTable.forever_ui["Sell Price:"],
    ["Set Amount"] = addonTable.forever_ui["Set Amount"],
    ["Shade of Eranikus kills (Sunken Temple)"] = addonTable.forever_ui["Shade of Eranikus kills (Sunken Temple)"],
    ["Shade of the Archmage Kills (City of Dalaran)"] = addonTable.forever_ui["Shade of the Archmage Kills (City of Dalaran)"],
    ["Shadow:"] = addonTable.forever_ui["Shadow:"],
    ["Shaman"] = addonTable.forever_ui["Shaman"],
    ["Share"] = addonTable.forever_ui["Share"],
    ["Shield"] = addonTable.forever_ui["Shield"],
    ["Shop"] = addonTable.forever_ui["Shop"],
    ["Show All Level Ranges"] = addonTable.forever_ui["Show All Level Ranges"],
    ["Show Grid"] = addonTable.forever_ui["Show Grid"],
    ["Show Quest Levels"] = addonTable.forever_ui["Show Quest Levels"],
    ["Show as Experience Bar"] = addonTable.forever_ui["Show as Experience Bar"],
    ["Show:"] = addonTable.forever_ui["Show:"],
    ["Skip Tutorial"] = addonTable.forever_ui["Skip Tutorial"],
    ["Slams the opponent, causing weapon damage plus 16."] = addonTable.forever_ui["Slams the opponent, causing weapon damage plus 16."],
    ["Smelt Copper"] = addonTable.forever_ui["Smelt Copper"],
    ["Smelted Bars"] = addonTable.forever_ui["Smelted Bars"],
    ["Smelting"] = addonTable.forever_ui["Smelting"],
    ["Smelting Recipes learned"] = addonTable.forever_ui["Smelting Recipes learned"],
    ["Snap to Elements"] = addonTable.forever_ui["Snap to Elements"],
    ["Snowtalon Kills (Shaper's Terrace)"] = addonTable.forever_ui["Snowtalon Kills (Shaper's Terrace)"],
    ["Sonya Darkhallow Kills (Barrow Deeps)"] = addonTable.forever_ui["Sonya Darkhallow Kills (Barrow Deeps)"],
    ["Soul Bag"] = addonTable.forever_ui["Soul Bag"],
    ["Soulbound"] = addonTable.forever_ui["Soulbound"],
    ["Spear"] = addonTable.forever_ui["Spear"],
    ["Spears"] = addonTable.forever_ui["Spears"],
    ["Spell Damage:"] = addonTable.forever_ui["Spell Damage:"],
    ["Spell Healing:"] = addonTable.forever_ui["Spell Healing:"],
    ["Spell Name, Spell Icon, Highlight Important Casts, Flash When Targeted By Enemy"] = addonTable.forever_ui["Spell Name, Spell Icon, Highlight Important Casts, Flash When Targeted By Enemy"],
    ["Spell Piercing:"] = addonTable.forever_ui["Spell Piercing:"],
    ["Spellbook"] = addonTable.forever_ui["Spellbook"],
    ["Spellbook & Professions"] = addonTable.forever_ui["Spellbook & Professions"],
    ["Spiced Wolf Meat"] = addonTable.forever_ui["Spiced Wolf Meat"],
    ["Spirit returned to body by shamans"] = addonTable.forever_ui["Spirit returned to body by shamans"],
    ["Spirit:"] = addonTable.forever_ui["Spirit:"],
    ["Stable Master"] = addonTable.forever_ui["Stable Master"],
    ["Stable Slot Cost:"] = addonTable.forever_ui["Stable Slot Cost:"],
    ["Staff"] = addonTable.forever_ui["Staff"],
    ["Stamina Food"] = addonTable.forever_ui["Stamina Food"],
    ["Stamina:"] = addonTable.forever_ui["Stamina:"],
    ["Stoneform"] = addonTable.forever_ui["Stoneform"],
    ["Stormwind"] = addonTable.forever_ui["Stormwind"],
    ["Stormwind Auction House"] = addonTable.forever_ui["Stormwind Auction House"],
    ["Stranglethorn Fishing Extravaganza"] = addonTable.forever_ui["Stranglethorn Fishing Extravaganza"],
    ["Strength Food"] = addonTable.forever_ui["Strength Food"],
    ["Summons accepted"] = addonTable.forever_ui["Summons accepted"],
    ["Support"] = addonTable.forever_ui["Support"],
    ["Sword"] = addonTable.forever_ui["Sword"],
    ["Tackle Box"] = addonTable.forever_ui["Tackle Box"],
    ["Tailoring Patterns learned"] = addonTable.forever_ui["Tailoring Patterns learned"],
    ["Talent tree respecs"] = addonTable.forever_ui["Talent tree respecs"],
    ["Talents"] = addonTable.forever_ui["Talents"],
    ["Target and Focus"] = addonTable.forever_ui["Target and Focus"],
    ["Target casting Fireball"] = addonTable.forever_ui["Target casting Fireball"],
    ["Temporary"] = addonTable.forever_ui["Temporary"],
    ["The Alliance capital is populated by Night Elves and is located in the island of Teldrassil. Ruled by the Priestess of the Moon, Tyrande Whisperwind."] = addonTable.forever_ui["The Alliance capital is populated by Night Elves and is located in the island of Teldrassil. Ruled by the Priestess of the Moon, Tyrande Whisperwind."],
    ["The Ashbringer"] = addonTable.forever_ui["The Ashbringer"],
    ["The Wild King kills (Hyjal Summit)"] = addonTable.forever_ui["The Wild King kills (Hyjal Summit)"],
    ["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 10.  Lasts 3 min."] = addonTable.forever_ui["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 10.  Lasts 3 min."],
    ["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 11.  Lasts 3 min."] = addonTable.forever_ui["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 11.  Lasts 3 min."],
    ["The world around you will refresh in %s %s. Make sure you are out of combat and in a safe area, or click here to refresh now."] = addonTable.forever_ui["The world around you will refresh in %s %s. Make sure you are out of combat and in a safe area, or click here to refresh now."],
    ["This feature becomes available when your first character reaches level 25."] = addonTable.forever_ui["This feature becomes available when your first character reaches level 25."],
    ["This recipe requires you to be near a special crafting station. These can often be found in dungeons or in the open world."] = addonTable.forever_ui["This recipe requires you to be near a special crafting station. These can often be found in dungeons or in the open world."],
    ["This spell can only be cast in raid instances."] = addonTable.forever_ui["This spell can only be cast in raid instances."],
    ["This wick is still soulbound to its finder. Try again in a moment."] = addonTable.forever_ui["This wick is still soulbound to its finder. Try again in a moment."],
    ["Toggle Sound"] = addonTable.forever_ui["Toggle Sound"],
    ["Tools: Blacksmith Hammer"] = addonTable.forever_ui["Tools: Blacksmith Hammer"],
    ["Tools: Mining Pick"] = addonTable.forever_ui["Tools: Mining Pick"],
    ["Tools: Runed Golden Rod"] = addonTable.forever_ui["Tools: Runed Golden Rod"],
    ["Tools: Runed Silver Rod"] = addonTable.forever_ui["Tools: Runed Silver Rod"],
    ["Total 10-player raids entered"] = addonTable.forever_ui["Total 10-player raids entered"],
    ["Total 20-player raids entered"] = addonTable.forever_ui["Total 20-player raids entered"],
    ["Total 40-player raids entered"] = addonTable.forever_ui["Total 40-player raids entered"],
    ["Total 5-player dungeons entered"] = addonTable.forever_ui["Total 5-player dungeons entered"],
    ["Total Honorable Kills"] = addonTable.forever_ui["Total Honorable Kills"],
    ["Total Killing Blows"] = addonTable.forever_ui["Total Killing Blows"],
    ["Total cheers"] = addonTable.forever_ui["Total cheers"],
    ["Total damage done"] = addonTable.forever_ui["Total damage done"],
    ["Total damage received"] = addonTable.forever_ui["Total damage received"],
    ["Total deaths"] = addonTable.forever_ui["Total deaths"],
    ["Total deaths from opposite faction"] = addonTable.forever_ui["Total deaths from opposite faction"],
    ["Total deaths from other players"] = addonTable.forever_ui["Total deaths from other players"],
    ["Total deaths in 10-player raids"] = addonTable.forever_ui["Total deaths in 10-player raids"],
    ["Total deaths in 20-player raids"] = addonTable.forever_ui["Total deaths in 20-player raids"],
    ["Total deaths in 40-player raids"] = addonTable.forever_ui["Total deaths in 40-player raids"],
    ["Total deaths in 5-player dungeons"] = addonTable.forever_ui["Total deaths in 5-player dungeons"],
    ["Total facepalms"] = addonTable.forever_ui["Total facepalms"],
    ["Total factions encountered"] = addonTable.forever_ui["Total factions encountered"],
    ["Total gold acquired"] = addonTable.forever_ui["Total gold acquired"],
    ["Total healing done"] = addonTable.forever_ui["Total healing done"],
    ["Total healing received"] = addonTable.forever_ui["Total healing received"],
    ["Total kills"] = addonTable.forever_ui["Total kills"],
    ["Total kills that grant experience or honor"] = addonTable.forever_ui["Total kills that grant experience or honor"],
    ["Total raid and dungeon deaths"] = addonTable.forever_ui["Total raid and dungeon deaths"],
    ["Total times LOL'd"] = addonTable.forever_ui["Total times LOL'd"],
    ["Total times playing world's smallest violin"] = addonTable.forever_ui["Total times playing world's smallest violin"],
    ["Total waves"] = addonTable.forever_ui["Total waves"],
    ["Totem"] = addonTable.forever_ui["Totem"],
    ["Track"] = addonTable.forever_ui["Track"],
    ["Track Recipe"] = addonTable.forever_ui["Track Recipe"],
    ["Tracked Items"] = addonTable.forever_ui["Tracked Items"],
    ["Trade Goods"] = addonTable.forever_ui["Trade Goods"],
    ["Trinket Bag"] = addonTable.forever_ui["Trinket Bag"],
    ["Triple Buffering"] = addonTable.forever_ui["Triple Buffering"],
    ["Two-Handed Exotics"] = addonTable.forever_ui["Two-Handed Exotics"],
    ["Unconscious"] = addonTable.forever_ui["Unconscious"],
    ["Unspent Talents"] = addonTable.forever_ui["Unspent Talents"],
    ["Untrack"] = addonTable.forever_ui["Untrack"],
    ["Use |cFF00FFFFchat|r to ask questions. Find players to join you on quests, and get help from the community."] = addonTable.forever_ui["Use |cFF00FFFFchat|r to ask questions. Find players to join you on quests, and get help from the community."],
    ["Use: Heals 114 damage over 6 sec."] = addonTable.forever_ui["Use: Heals 114 damage over 6 sec."],
    ["Use: Heals 161 damage over 7 sec."] = addonTable.forever_ui["Use: Heals 161 damage over 7 sec."],
    ["Use: Increase sharp weapon damage by 3 for 30 minutes. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Increase sharp weapon damage by 3 for 30 minutes. (1 Sec Cooldown)"],
    ["Use: Increase the damage of a blunt weapon by 3 for 30 minutes. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Increase the damage of a blunt weapon by 3 for 30 minutes. (1 Sec Cooldown)"],
    ["Use: Restores 1,338 health over 30 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 15 Stamina for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 1,338 health over 30 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 15 Stamina for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"],
    ["Use: Restores 140 to 180 health."] = addonTable.forever_ui["Use: Restores 140 to 180 health."],
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Agility for 15 min. Additionally, experience gained from kills is increased by 5%."] = addonTable.forever_ui["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Agility for 15 min. Additionally, experience gained from kills is increased by 5%."],
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Intellect for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Intellect for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"],
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Strength for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Strength for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"],
    ["Use: Restores 530 health over 24 sec.  Must remain seated while eating.  If you spend at least 10 seconds eating you will become well fed and gain 6 Stamina and Spirit for 15 min. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 530 health over 24 sec.  Must remain seated while eating.  If you spend at least 10 seconds eating you will become well fed and gain 6 Stamina and Spirit for 15 min. (1 Sec Cooldown)"],
    ["Use: Restores 58 health over 18 sec.  Must remain seated while eating. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 58 health over 18 sec.  Must remain seated while eating. (1 Sec Cooldown)"],
    ["Use: Restores 58 health over 18 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 1 Agility for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = addonTable.forever_ui["Use: Restores 58 health over 18 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 1 Agility for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"],
    ["Use: Restores 70 to 90 health."] = addonTable.forever_ui["Use: Restores 70 to 90 health."],
    ["Use: Summons a Reagent Bot that allows you and others nearby to purchase reagents. Requires a Campfire nearby. All camping features share a cooldown of 1 hour."] = addonTable.forever_ui["Use: Summons a Reagent Bot that allows you and others nearby to purchase reagents. Requires a Campfire nearby. All camping features share a cooldown of 1 hour."],
    ["Use: Target is cured of poisons up to level 25. (1 Min Cooldown)"] = addonTable.forever_ui["Use: Target is cured of poisons up to level 25. (1 Min Cooldown)"],
    ["Vanity pets owned"] = addonTable.forever_ui["Vanity pets owned"],
    ["View all the appearance sets you can collect for your class here."] = addonTable.forever_ui["View all the appearance sets you can collect for your class here."],
    ["Visit a profession trainer in a major city to learn a new profession. You may have two professions. You may have any combination of gathering and production professions."] = addonTable.forever_ui["Visit a profession trainer in a major city to learn a new profession. You may have two professions. You may have any combination of gathering and production professions."],
    ["Visit a trainer to learn cooking. Cooking lets you learn recipes to create food that heals you out of combat and grants you temporary buffs."] = addonTable.forever_ui["Visit a trainer to learn cooking. Cooking lets you learn recipes to create food that heals you out of combat and grants you temporary buffs."],
    ["Visit a trainer to learn first aid. First aid lets you turn cloth into bandages for healing yourself and others."] = addonTable.forever_ui["Visit a trainer to learn first aid. First aid lets you turn cloth into bandages for healing yourself and others."],
    ["Visit a trainer to learn fishing. Fishing lets you catch fish and other strange things from water. Fish can be cooked into delicious meals with the Cooking skill."] = addonTable.forever_ui["Visit a trainer to learn fishing. Fishing lets you catch fish and other strange things from water. Fish can be cooked into delicious meals with the Cooking skill."],
    ["Voice Chat Volume"] = addonTable.forever_ui["Voice Chat Volume"],
    ["Wait, don't pull"] = addonTable.forever_ui["Wait, don't pull"],
    ["Wand"] = addonTable.forever_ui["Wand"],
    ["Warglaives"] = addonTable.forever_ui["Warglaives"],
    ["Warlock"] = addonTable.forever_ui["Warlock"],
    ["Warrior"] = addonTable.forever_ui["Warrior"],
    ["Warsong Gulch Honorable Kills"] = addonTable.forever_ui["Warsong Gulch Honorable Kills"],
    ["Warsong Gulch Killing Blows"] = addonTable.forever_ui["Warsong Gulch Killing Blows"],
    ["Warsong Gulch battles"] = addonTable.forever_ui["Warsong Gulch battles"],
    ["Warsong Gulch flags captured"] = addonTable.forever_ui["Warsong Gulch flags captured"],
    ["Warsong Gulch flags returned"] = addonTable.forever_ui["Warsong Gulch flags returned"],
    ["Warsong Gulch victories"] = addonTable.forever_ui["Warsong Gulch victories"],
    ["Wealth"] = addonTable.forever_ui["Wealth"],
    ["Weapon Stones"] = addonTable.forever_ui["Weapon Stones"],
    ["Weapon skills at maximum skill"] = addonTable.forever_ui["Weapon skills at maximum skill"],
    ["Weapons"] = addonTable.forever_ui["Weapons"],
    ["Welcome to WoW Classic Hardcore Realms. Any character that dies on a Hardcore realm can never resurrect on that realm for ANY reason. Customer Support cannot resurrect a dead Hardcore character.|n|nBy agreeing to play on these realms, you accept that your character's death is permanent for whatever reason. This includes disconnections, lag, server outages, gameplay bugs, or any other reason. Dying due to consensual PvP activity--such as a Duel to the Death or deliberately PvP flagging--is part of the game.|n|n"] = addonTable.forever_ui["Welcome to WoW Classic Hardcore Realms. Any character that dies on a Hardcore realm can never resurrect on that realm for ANY reason. Customer Support cannot resurrect a dead Hardcore character.|n|nBy agreeing to play on these realms, you accept that your character's death is permanent for whatever reason. This includes disconnections, lag, server outages, gameplay bugs, or any other reason. Dying due to consensual PvP activity--such as a Duel to the Death or deliberately PvP flagging--is part of the game.|n|n"],
    ["When the possess action bar is displayed, the selected action bar will be temporarily replaced with it."] = addonTable.forever_ui["When the possess action bar is displayed, the selected action bar will be temporarily replaced with it."],
    ["When the stance action bar is displayed, the selected action bar will be temporarily replaced with it."] = addonTable.forever_ui["When the stance action bar is displayed, the selected action bar will be temporarily replaced with it."],
    ["World"] = addonTable.forever_ui["World"],
    ["World Honorable Kills"] = addonTable.forever_ui["World Honorable Kills"],
    ["World Killing Blows"] = addonTable.forever_ui["World Killing Blows"],
    ["World refresh in %s %s"] = addonTable.forever_ui["World refresh in %s %s"],
    ["Wounds the target causing them to bleed for 15 damage over 9 sec."] = addonTable.forever_ui["Wounds the target causing them to bleed for 15 damage over 9 sec."],
    ["You are currently in a Timewalking Campaign. Speak to Chromie to exit."] = addonTable.forever_ui["You are currently in a Timewalking Campaign. Speak to Chromie to exit."],
    ["You are no longer rested."] = addonTable.forever_ui["You are no longer rested."],
    ["You haven't added this to your action bars"] = addonTable.forever_ui["You haven't added this to your action bars"],
    ["You retain up to 10 Rage when you change Stances."] = addonTable.forever_ui["You retain up to 10 Rage when you change Stances."],
    ["You will also receive"] = addonTable.forever_ui["You will also receive"],
    ["You will also receive:"] = addonTable.forever_ui["You will also receive:"],
    ["You will be able to choose one of these rewards:"] = addonTable.forever_ui["You will be able to choose one of these rewards:"],
    ["You will receive"] = addonTable.forever_ui["You will receive"],
    ["You will receive:"] = addonTable.forever_ui["You will receive:"],
    ["Your |cFFFFFFFFAttacks|r ignore %d of your enemies' |cFFFFFFFFArmor|r when attacking. Reducing an enemy's armor below 0 will increase your damage against them."] = addonTable.forever_ui["Your |cFFFFFFFFAttacks|r ignore %d of your enemies' |cFFFFFFFFArmor|r when attacking. Reducing an enemy's armor below 0 will increase your damage against them."],
    ["Zone"] = addonTable.forever_ui["Zone"],
    ["|Hplayer:%s|h[%s]|h has been slain in a duel by %s in %s! They were level %d"] = addonTable.forever_ui["|Hplayer:%s|h[%s]|h has been slain in a duel by %s in %s! They were level %d"],
    ["|c%s%s|r"] = addonTable.forever_ui["|c%s%s|r"],
    ["|cFFBCBCBCBase Speeds (In Yards Per Second):\\n7.0 yd/s Running\\n4.7 yd/s Swimming\\n4.5 yd/s Backpedaling\\n2.5 yd/s Walking|r"] = addonTable.forever_ui["|cFFBCBCBCBase Speeds (In Yards Per Second):\\n7.0 yd/s Running\\n4.7 yd/s Swimming\\n4.5 yd/s Backpedaling\\n2.5 yd/s Walking|r"],
    ["|cffffffffDeath is permanent|r|n|n|cffffd200Hold, adventurer. The realm you are selecting is a HARDCORE realm. If you choose to play on this realm, character death is permanent.|r|n|n|cffffffffCustomer Support will not restore fallen hardcore characters for any reason."] = addonTable.forever_ui["|cffffffffDeath is permanent|r|n|n|cffffd200Hold, adventurer. The realm you are selecting is a HARDCORE realm. If you choose to play on this realm, character death is permanent.|r|n|n|cffffffffCustomer Support will not restore fallen hardcore characters for any reason."],
    ["|n|n"] = addonTable.forever_ui["|n|n"],
    ["Корюшка Truesilver"] = addonTable.forever_ui["Корюшка Truesilver"],
    ["Корюшка Міфрилу"] = addonTable.forever_ui["Корюшка Міфрилу"],
}

local warrior_stances = {
    ["Battle Stance"] = "бойова стійка",
    ["Defensive Stance"] = "захисна стійка",
    ["Berserker Stance"] = "стійка берсерка",
}
local tooltip_catalog = addonTable.forever_tooltip_ui or {}
local requirement_names = tooltip_catalog.requirement_names or {}
local power_resources = tooltip_catalog.power_resources or {}

local function translate_requirement_part(requirement)
    requirement = requirement:match("^%s*(.-)%s*$")
    local skill, color, rank, reset = requirement:match(
        "^(.-) %((|c%x%x%x%x%x%x%x%x)(%d+)(|r)%)$")
    local explicit_rank = false
    if not skill then
        skill, rank = requirement:match("^(.-) %((%d+)%)$")
    end
    if not skill then
        skill, rank = requirement:match("^(.-) %(Rank (%d+)%)$")
        explicit_rank = skill ~= nil
    end
    local name = skill or requirement
    local level = name:match("^Level (%d+)$")
    if level then return "рівень " .. level, true end

    local translated = addonTable.use("faction_client_db").get_name(name)
        or warrior_stances[name] or requirement_names[name] or ui[name]
        or addonTable.string and addonTable.string[name]
    if not translated then
        local entries = addonTable.use("entries")
        translated = entries.lookup_name("spell", name)
            or addonTable.use("item_client_db").get_name_by_english(name)
    end
    if not translated then return nil end
    if rank then
        translated = translated .. " (" .. (explicit_rank and "ранг " or "")
            .. (color or "") .. rank .. (reset or "") .. ")"
    end
    return translated, false
end

local function translate_requirement(requirement)
    local parts, only_level = {}, true
    for part in requirement:gmatch("[^,]+") do
        local translated, is_level = translate_requirement_part(part)
        if not translated then return nil end
        parts[#parts + 1] = translated
        only_level = only_level and is_level == true
    end
    if #parts == 0 then return nil end
    if #parts == 1 and only_level then
        return "Необхідний " .. parts[1]
    end
    return "Потрібно: " .. table.concat(parts, ", ")
end

local function translate_quest_timer_value(first_count, first_unit,
        second_count, second_unit)
    local units = addonTable.forever_surface_ui
        and addonTable.forever_surface_ui.quest
        and addonTable.forever_surface_ui.quest.timer_units
    if type(units) ~= "table" then return nil end
    local translated_units = {}
    for _, unit in ipairs(units) do
        translated_units[unit.source] = unit.translated
    end
    local dynamic_value_words = tooltip_catalog.dynamic_value_words or {}
    local first = translated_units[first_unit]
        or dynamic_value_words[first_unit:lower()]
    if not first then return nil end
    local result = first_count .. " " .. first
    if second_count ~= "" or second_unit ~= "" then
        local second = translated_units[second_unit]
            or dynamic_value_words[second_unit:lower()]
        if second_count == "" or not second then return nil end
        result = result .. " " .. second_count .. " " .. second
    end
    return result
end

local social_time_units = {
    second = "с", seconds = "с", minute = "хв", minutes = "хв",
    hour = "год", hours = "год", day = "дн.", days = "дн.",
    month = "міс.", months = "міс.", year = "р.", years = "р.",
}

local function social_label(source)
    return addonTable.forever_ui and addonTable.forever_ui[source]
        or addonTable.string and addonTable.string[source] or ui[source]
end

-- MicroButtonTooltipText in 70291 appends an opaque binding to these titles.
-- Parenthesized explanations elsewhere are not binding suffixes.
local binding_titles = {
    ["Character Info"] = true, ["Game Menu"] = true,
    ["Quest Log"] = true, ["Spellbook"] = true, ["Social"] = true,
    ["Guild"] = true, ["Spellbook & Professions"] = true,
    ["Achievements"] = true, ["Group Finder"] = true,
    ["Guild Finder"] = true, ["Dungeon Journal"] = true,
    ["Account Collections"] = true, ["Adventure Guide"] = true,
    ["Guild & Communities"] = true, ["Professions"] = true,
    ["Talents"] = true, ["Housing Dashboard"] = true, ["Legacy"] = true,
}

local function translate_bound_title(label, binding, color, reset)
    if not binding_titles[label] or binding:find("[\r\n]") then return nil end
    local translated = social_label(label)
    return translated and (translated .. " " .. (color or "") .. binding
        .. (reset or "")) or nil
end

local function translate_social_time(value)
    if value == "< a minute" then return "менше хвилини" end
    local valid, count = true, 0
    local translated = value:gsub("(%d+)%s+([A-Za-z]+)", function (number, unit)
        local label = social_time_units[unit:lower()]
        if not label then valid = false; return end
        count = count + 1
        return number .. " " .. label
    end)
    if valid and count > 0 and not translated:find("[A-Za-z]") then
        return translated
    end
end

-- Dynamic dialog sources: GlobalStrings and Blizzard_StaticPopup_Game,
-- installed Forever build 1.60.1.70170. Keep names and links as rendered.
local function popup_requester(value)
    local owner, name = value:match("^(.-)'s friend (.+)$")
    if owner then return name .. " (друг гравця " .. owner .. ")" end
    owner, name = value:match("^(.-)'s guildmate (.+)$")
    if owner then return name .. " (з однієї гільдії з " .. owner .. ")" end
    owner, name = value:match("^(.-)'s community mate (.+)$")
    if owner then return name .. " (з однієї спільноти з " .. owner .. ")" end
    name, owner = value:match("^(.+) from (.+)$")
    if name then return name .. " зі спільноти " .. owner end
    return value
end

local function popup_warnings(value)
    if value == "" then return value end
    -- LFGUtil appends warnings and queue names on separate lines.
    return (value:gsub("[^\r\n]+", function (line)
        local color, body, reset = line:match("^(|c%x%x%x%x%x%x%x%x)(.*)(|r)$")
        local translated = addonTable.use("translation_resolver").find_ui(body or line)
        if translated then
            return color and color .. translated .. reset or translated
        end
        return line
    end))
end

local function popup_duration(count, unit)
    -- The client can pass a |4 token before FontString plural resolution.
    if unit == "|4Second:Seconds;" then return count .. " с" end
    if unit == "|4Minute:Minutes;" then return count .. " хв" end
    return translate_social_time(count .. " " .. unit)
end

local function mail_item_name(source)
    local item_db = addonTable.use("item_client_db")
    local translated = item_db.get_name_by_english(source)
    if translated then return translated end
    local name, quantity = source:match("^(.-)(%s+%(%d+%))$")
    translated = name and item_db.get_name_by_english(name)
    return translated and translated .. quantity or source
end

local function mail_party_name(source)
    if source == "Multiple Sellers" or source == "Multiple Buyers" then
        return social_label(source) or source
    end
    return source
end

local function popup_destination(zone)
    return addonTable.zone and addonTable.zone[zone] or zone
end

-- These 70291 popup templates are formatted before the display is translated.
-- Match their exact native text, preserving the player-name argument.
local function popup_argument_rule(tag, translate_argument)
    local template = _G[tag]
    local target = template and addonTable.forever_ui[template]
    if not target then return { pattern = "^$", replace = function () end } end
    local first, last = template:find("%s", 1, true)
    if not first then return { pattern = "^$", replace = function () end } end
    local function literal(text)
        return text:gsub("%%%%", "%%"):gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
    end
    return {
        pattern = "^" .. literal(template:sub(1, first - 1)) .. "(.-)"
            .. literal(template:sub(last + 1)) .. "$",
        replace = function (argument)
            if translate_argument then
                argument = addonTable.use("translation_resolver").find_ui(argument) or argument
            end
            return string.format(target, argument)
        end,
    }
end

-- Native cooldown/DPS menus format these strings before drawing FontStrings.
local panel_class_names = { Warrior = true, Paladin = true, Hunter = true,
    Rogue = true, Priest = true, Shaman = true, Mage = true, Warlock = true,
    Druid = true, Monk = true, Evoker = true, ["Death Knight"] = true, ["Demon Hunter"] = true }
local function panel_class_spec(class, spec)
    if panel_class_names[class] then
        return (social_label(class) or class) .. " - " .. (social_label(spec) or spec)
    end
end

local function panel_format_rule(template, pattern, translate_arguments)
    return { pattern = pattern, replace = function (...)
        local args = { ... }
        if translate_arguments then
            local resolver = addonTable.use("translation_resolver")
            for index, value in ipairs(args) do
                args[index] = resolver.find_ui(value) or value
            end
        end
        return string.format(addonTable.forever_ui[template], unpack(args))
    end }
end

addonTable.forever_ui_patterns = {
    panel_format_rule("Assign to %s", "^Assign to (.+)$", true),
    panel_format_rule("Add Alert (%d/%d)", "^Add Alert %((%d+)/(%d+)%)$"),
    panel_format_rule("Cannot change category: %s", "^Cannot change category: (.+)$", true),
    panel_format_rule("Cannot change cooldown order: %s", "^Cannot change cooldown order: (.+)$", true),
    panel_format_rule("Cannot add cooldown alert: %s", "^Cannot add cooldown alert: (.+)$", true),
    panel_format_rule("[PH] Cannot create layout named [%s], pick a different name",
        "^%[PH%] Cannot create layout named %[(.-)%], pick a different name$"),
    panel_format_rule("Cooldown layout \"%s\" copied to clipboard.",
        "^Cooldown layout \"(.-)\" copied to clipboard%.$"),
    panel_format_rule("Are you sure you want to delete the layout|n%s?",
        "^Are you sure you want to delete the layout|n(.-)%?$"),
    panel_format_rule("Enter New Name for Layout %s", "^Enter New Name for Layout (.+)$"),
    panel_format_rule("A max of %d character layouts and %d account layouts are allowed",
        "^A max of (%d+) character layouts and (%d+) account layouts are allowed$"),
    panel_format_rule("Only %d character specific layouts are allowed. Uncheck the box to save an account wide layout",
        "^Only (%d+) character specific layouts are allowed%. Uncheck the box to save an account wide layout$"),
    panel_format_rule("Only %d account wide layouts are allowed. Check the box to save a character specific layout",
        "^Only (%d+) account wide layouts are allowed%. Check the box to save a character specific layout$"),
    panel_format_rule("%s Specific", "^(.+) Specific$"),
    { pattern = "^(.+) %- (.+)$", replace = panel_class_spec },
    { pattern = "^(.+) is for (.+)$", replace = function (layout_name, who)
        local class, spec = who:match("^(.+) %- (.+)$")
        local translated = class and panel_class_spec(class, spec)
            or addonTable.use("translation_resolver").find_ui(who)
        return string.format(addonTable.forever_ui["%s is for %s"], layout_name, translated or who)
    end },
    panel_format_rule("No buff to track | Trinket Buff %d", "^No buff to track | Trinket Buff (%d+)$"),
    panel_format_rule("Empty Trinket Slot %d | No buff to track", "^Empty Trinket Slot (%d+) | No buff to track$"),
    panel_format_rule("Combat %d", "^Combat (%d+)$"),
    {
        pattern = "^Combat (%d+)( %[[%d:]+%])$",
        replace = function (number, duration)
            return string.format(addonTable.forever_ui["Combat %d"], number) .. duration
        end,
    },
    {
        pattern = "^Version ([%d%.]+)$",
        replace = function (version)
            return addonTable.forever_ui["Version"] .. " " .. version
        end,
    },
    {
        pattern = "^You have (%d+) quests that we need!$",
        replace = function (count)
            local number = tonumber(count)
            local last_two, last = number % 100, number % 10
            if last == 1 and last_two ~= 11 then
                return "У вас є " .. count .. " квест, який нам потрібен!"
            elseif last >= 2 and last <= 4 and (last_two < 12 or last_two > 14) then
                return "У вас є " .. count .. " квести, які нам потрібні!"
            end
            return "У вас є " .. count .. " квестів, які нам потрібні!"
        end,
    },
    {
        pattern = "^(%d+) (%a+) until release$",
        replace = function (count, unit)
            return addonTable.forever_surface_ui.menus.death_release_countdown(count, unit)
        end,
    },
    {
        -- AuctionHouseRefreshFrameMixin formats the currently available stock.
        pattern = "^([%d,]+) Available$",
        replace = function (quantity)
            local template = addonTable.forever_ui["%s Available"]
            return template and string.format(template, quantity) or nil
        end,
    },
    popup_argument_rule("CONFIRM_XP_LOSS", true),
    popup_argument_rule("CONFIRM_XP_LOSS_AGAIN", true),
    popup_argument_rule("TAKE_MONEY_FROM_STRANGER_WARNING", false),
    {
        -- VOICE_CHAT_JOIN_GROUP composes these two exact display strings.
        pattern = "^(This group is using voice chat for easier communication%.)\n\n(Text%-to%-Speech and Speech%-to%-Text are not supported in this channel because it uses the Discord service%..-)$",
        replace = function (message, warning)
            return (addonTable.forever_ui[message] or message) .. "\n\n"
                .. (addonTable.forever_ui[warning] or warning)
        end,
    },
    {
        -- Audio accessibility settings append a Discord warning in 70291.
        -- Translate both display components and retain the named error color.
        pattern = "^(.+)\n\n(|cnERROR_COLOR:)(.-)|r$",
        replace = function (tooltip, color, warning)
            local dictionary = addonTable.forever_ui
            return (dictionary[tooltip] or tooltip) .. "\n\n" .. color
                .. (dictionary[warning] or warning) .. "|r"
        end,
    },
    {
        pattern = "^Tools:(.*)$",
        replace = function (body)
            return addonTable.use("tooltip_spell_adapter")
                .translate_crafting_requirements("Tools:" .. body)
        end,
    },
    {
        pattern = "^Reagents:(.*)$",
        replace = function (body)
            return addonTable.use("tooltip_spell_adapter")
                .translate_crafting_requirements("Reagents:" .. body)
        end,
    },
    {
        pattern = "^(.+) ([%d,]+)%s*/%s*([%d,]+)$",
        replace = function (faction, current, maximum)
            local name = addonTable.use("faction_client_db").get_name(faction)
            return name and (name .. " " .. current .. " / " .. maximum) or nil
        end,
    },
    {
        pattern = "^(.+) %- (.+)$",
        replace = function (faction, standing)
            local name = addonTable.use("faction_client_db").get_name(faction)
            local status = social_label(standing)
            return name and status and (name .. " — " .. status) or nil
        end,
    },
    -- Contacts formats these values before writing its pooled FontStrings.
    {
        pattern = "^Social (|c%x%x%x%x%x%x%x%x)(%b())(|r)$",
        replace = function (color, binding, reset)
            local translated = social_label("Social")
            return translated and (translated .. " " .. color .. binding .. reset) or nil
        end,
    },
    {
        pattern = "^Level (%d+)%s+(|A:charactercreate%-customize%-dropdown%-linemouseover%-middle:[^|]+|a)%s+(.+)$",
        replace = function (level, divider, race)
            local key = race:lower():gsub("%s+", "")
            local record = addonTable.race and addonTable.race[key]
            local forms = record and record["н"]
            local name = addonTable.use("faction_client_db").get_player_name(race)
                or forms and (forms.neutral_singular or forms[1])
                or social_label(race) or race
            return "Рівень " .. level .. "  " .. divider .. "  " .. name
        end,
    },
    {
        pattern = "^Fought Together %- (.+)$",
        replace = function (zone)
            local name = addonTable.zone and addonTable.zone[zone] or zone
            return ui["Fought Together"] .. " — " .. name
        end,
    },
    {
        pattern = "^(.+), Level (%d+) (.+)$",
        replace = function (name, level, class)
            return name .. ", Рівень " .. level .. " " .. (social_label(class) or class)
        end,
    },
    {
        pattern = "^Friend Requests %((%d+)%)$",
        replace = function (count) return "Запрошення в друзі (" .. count .. ")" end,
    },
    {
        pattern = "^Received %((%d+)%)$",
        replace = function (count)
            local template = social_label("Received (%d)")
            return template and string.format(template, tonumber(count)) or nil
        end,
    },
    {
        pattern = "^Quick Join %((%d+)%)$",
        replace = function (count)
            return (social_label("Quick Join") or "Швидке приєднання") .. " (" .. count .. ")"
        end,
    },
    {
        pattern = "^Legacy Friends (%d+)/(%d+)$",
        replace = function (count, maximum) return "Давні друзі " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^Pinned (%d+)/(%d+)$",
        replace = function (count, maximum) return "Закріплені " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^Recent Allies (%d+)/(%d+)$",
        replace = function (count, maximum) return "Недавні союзники " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^Friends List (%d+)/(%d+)$",
        replace = function (count, maximum)
            local label = social_label("Friends List")
            return label and (label .. " " .. count .. "/" .. maximum) or nil
        end,
    },
    {
        pattern = "^last online (.+) ago$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("Востаннє в мережі: " .. translated .. " тому") or nil
        end,
    },
    {
        pattern = "^%((.+) ago%)$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("(" .. translated .. " тому)") or nil
        end,
    },
    {
        pattern = "^(.+) ago$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and (translated .. " тому") or nil
        end,
    },
    {
        pattern = "^Pinned Ally %(Expires in (.+)%)$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("Закріплений союзник (ще " .. translated .. ")") or nil
        end,
    },
    {
        pattern = "^Status: (|c%x%x%x%x%x%x%x%x)(.-)(|r)$",
        replace = function (color, status, reset)
            local translated = social_label(status)
            return translated and ("Статус: " .. color .. translated .. reset) or nil
        end,
    },
    {
        pattern = "^(|A:friends%-status%-[%a]+:[^|]+|a)(%s+)(.+)$",
        replace = function (icon, spacing, status)
            if status ~= "Online" and status ~= "Away" and status ~= "Busy"
                and status ~= "Appear Offline" then return nil end
            local translated = social_label(status)
            return translated and (icon .. spacing .. translated) or nil
        end,
    },
    {
        pattern = "^(|T.-|t) (.+)$",
        replace = function (icon, status)
            if status ~= "Available" and status ~= "Away" and status ~= "Busy" then return nil end
            local translated = social_label(status)
            return translated and (icon .. " " .. translated) or nil
        end,
    },
    {
        pattern = "^Tier (%d+)$",
        replace = function (tier) return "Рівень " .. tier end,
    },
    {
        pattern = "^Use: Restores ([%d%.,]+) to ([%d%.,]+) health%.$",
        replace = function (minimum, maximum)
            return "Використання: відновлює " .. minimum .. "–" .. maximum
                .. " здоров'я."
        end,
    },
    {
        pattern = '^Abandon "(.*)", destroying (.+)%?$',
        replace = function (name, items)
            local item_db = addonTable.use("item_client_db")
            local translated_items = item_db.get_name_by_english(items)
            if not translated_items then
                translated_items = items:gsub("([^,]+)(,?%s*)", function (item, separator)
                    return (item_db.get_name_by_english(item) or item) .. separator
                end)
            end
            return string.format(addonTable.forever_surface_ui.quest
                .ABANDON_QUEST_CONFIRM_WITH_ITEMS, name, translated_items)
        end,
    },
    {
        pattern = '^Abandon "(.*)"%?$',
        replace = function (name)
            return string.format(addonTable.forever_surface_ui.quest
                .ABANDON_QUEST_CONFIRM, name)
        end,
    },
    {
        -- SecondsToTime() emits at most two abbreviated units for quest timers.
        pattern = "^([%d%.,]+)%s+(%a+)%s*([%d%.,]*)%s*(%a*)$",
        replace = translate_quest_timer_value,
    },
    {
        pattern = "^Pass on Loot: (.+)$",
        replace = function (value)
            local translated = ({ Yes = "Так", No = "Ні" })[value] or value
            return "Відмова від здобичі: " .. translated
        end,
    },
    {
        pattern = "^(.+) slain: (%d+)/(%d+)$",
        replace = function (name, current, total)
            local entries = addonTable.use("entries")
            return entries.translate_quest_objective_task(
                name .. " slain: " .. current .. "/" .. total)
        end,
    },
    {
        pattern = "^(.+) invites you to a group%.$",
        replace = function (name)
            return name .. " запрошує вас до групи."
        end,
    },
    {
        -- INVITE_CONFIRMATION_REQUEST is formatted with the player name
        -- before the popup text reaches the display-only UI resolver.
        pattern = "^(.+) has requested to join your group%.(.*)$",
        replace = function (name, warnings)
            return popup_requester(name) .. " подав запит на приєднання до вашої групи."
                .. popup_warnings(warnings)
        end,
    },
    {
        pattern = "^(.+) has requested to join your group through Quick Join%.(.*)$",
        replace = function (name, warnings)
            return popup_requester(name) .. " подав запит на приєднання до вашої групи через функцію «Швидке приєднання»."
                .. popup_warnings(warnings)
        end,
    },
    {
        pattern = "^(.+) has suggested that you invite (.+) to join your group%.(.*)$",
        replace = function (suggester, name, warnings)
            return suggester .. " пропонує запросити " .. name .. " до вашої групи."
                .. popup_warnings(warnings)
        end,
    },
    {
        pattern = "^If (.+) joins your group, you will be removed from the following queues:$",
        replace = function (name)
            return "Якщо " .. name .. " приєднається до вашої групи, ви вийдете з таких черг:"
        end,
    },
    {
        pattern = "^(.+) has no valid roles%.$",
        replace = function (name) return name .. " не має відповідних ролей." end,
    },
    {
        pattern = "^(.+) has challenged you to a duel%.$",
        replace = function (name) return name .. " викликає вас на дуель." end,
    },
    {
        pattern = "^(.+) has challenged you to a duel to the death%.$",
        replace = function (name) return name .. " викликає вас на дуель на смерть." end,
    },
    {
        pattern = "^(.+) has challenged you to a pet%-battle%.$",
        replace = function (name) return name .. " викликає вас на бій улюбленців." end,
    },
    {
        pattern = "^Trade with (.+)%?$",
        replace = function (name) return "Торгувати з " .. name .. "?" end,
    },
    {
        pattern = "^(.+) has invited you to join the channel '(.-)'%.$",
        replace = function (name, channel)
            return name .. " запрошує вас до каналу «" .. channel .. "»."
        end,
    },
    {
        pattern = "^(.+) wants to summon you to (.-)%.[%s\\n]*You will be unable to return to this starting zone%.[%s\\n]*The spell will be canceled in (%d+) (.-)%.$",
        replace = function (name, zone, count, unit)
            local duration = popup_duration(count, unit)
            if not duration then return end
            return name .. " хоче прикликати вас до місця «" .. popup_destination(zone)
                .. "».\n\nВи не зможете повернутися до цієї початкової зони."
                .. "\n\nЗакляття буде скасовано через " .. duration .. "."
        end,
    },
    {
        pattern = "^(.+) has started a scenario in (.+)%. Do you want to join them%?[%s\\n]*This offer will expire in (%d+) (.-)%.$",
        replace = function (name, zone, count, unit)
            local duration = popup_duration(count, unit)
            if not duration then return end
            return name .. " розпочинає сценарій у місці «" .. popup_destination(zone)
                .. "». Хочете приєднатися?\n\nПропозиція діятиме ще " .. duration .. "."
        end,
    },
    {
        pattern = "^(.+) wants to summon you to (.+)%. The spell will be canceled in (%d+) (.-)%.$",
        replace = function (name, zone, count, unit)
            local duration = popup_duration(count, unit)
            if not duration then return end
            return name .. " хоче прикликати вас до місця «" .. popup_destination(zone)
                .. "». Закляття буде скасовано через " .. duration .. "."
        end,
    },
    {
        pattern = "^Do you want to destroy (.+)%?$",
        replace = function (name)
            local translated = addonTable.use("item_client_db")
                .get_name_by_english(name) or name
            return "Ви хочете знищити " .. translated .. "?"
        end,
    },
    {
        pattern = "^(%d+)%% Threat$",
        replace = function (percent) return "Загроза: " .. percent .. "%" end,
    },
    {
        pattern = "^Requires (.- Stance), (.- Stance)$",
        replace = function (first, second)
            if warrior_stances[first] and warrior_stances[second] then
                return "Потрібна одна зі стійок: " .. warrior_stances[first]
                    .. " або " .. warrior_stances[second]
            end
        end,
    },
    {
        pattern = "^Requires (.- Stance)$",
        replace = function (stance)
            if warrior_stances[stance] then
                return "Потрібна " .. warrior_stances[stance]
            end
        end,
    },
    {
        pattern = "^Rank (%d+)$",
        replace = function (rank) return "Ранг " .. rank end,
    },
    {
        pattern = "^Rank (%d+)/(%d+)$",
        replace = function (rank, maximum)
            return "Ранг " .. rank .. "/" .. maximum
        end,
    },
    {
        pattern = "^Increases the radius of your Battle Shout and Demoralizing Shout abilities by (%d+)%%%.$",
        replace = function (amount)
            return "Збільшує радіус дії «Бойового кличу» та «Деморалізуючого кличу» на "
                .. amount .. "%."
        end,
    },
    {
        pattern = "^([%+%-]?[%d%.,]+) ([A-Za-z]+)$",
        replace = function (amount, resource)
            local translated = power_resources[resource]
            return translated and amount .. " " .. translated or nil
        end,
    },
    {
        pattern = "^(%d+)%-(%d+) yd range$",
        replace = function (minimum, maximum)
            return "Дальність " .. minimum .. "–" .. maximum .. " м"
        end,
    },
    {
        pattern = "^(%d+) yd range$",
        replace = function (range) return "Дальність " .. range .. " м" end,
    },
    {
        pattern = "^([%d%.]+) sec cast$",
        replace = function (seconds) return "Час застосування: " .. seconds .. " с" end,
    },
    {
        pattern = "^([%d%.]+) sec cooldown$",
        replace = function (seconds) return "Відновлення: " .. seconds .. " с" end,
    },
    {
        pattern = "^([%d%.]+) min cooldown$",
        replace = function (minutes) return "Відновлення: " .. minutes .. " хв" end,
    },
    {
        pattern = "^Cooldown remaining: ([%d%.]+) sec$",
        replace = function (seconds) return "До відновлення: " .. seconds .. " с" end,
    },
    {
        -- Blizzard has already formatted Requires %s (%d) before the tooltip
        -- is rendered. Resolve its visible skill/item name separately.
        pattern = "^Requires (.+)$",
        replace = translate_requirement,
    },
    {
        -- RequiredTools contains a clickable hyperlink around the station
        -- name. Translate only visible text and keep the link payload intact.
        pattern = "^Requires: (.-)Forge(.-)$",
        replace = function (before, after)
            return "Потрібно: " .. before .. "кузня" .. after
        end,
    },
    {
        pattern = "^Requires: (.+)$",
        replace = translate_requirement,
    },
    {
        pattern = "^Mining (%d+)/(%d+)$",
        replace = function (current, maximum)
            return "Гірництво " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^(%d+) Health$",
        replace = function (amount)
            return amount .. " здоров'я"
        end,
    },
    {
        pattern = "^Create All %[(%d+)%]$",
        replace = function (count)
            return "Створити все [" .. count .. "]"
        end,
    },
    {
        pattern = "^Use: Restores ([%d,]+) mana over ([%d,]+) sec%. Must remain seated while drinking%.$",
        replace = function (mana, seconds)
            return "Використання: Відновлює " .. mana .. " мани протягом " .. seconds
                .. " с. Потрібно сидіти під час пиття."
        end,
    },
    {
        pattern = "^([%+%-]?%d+) Armor$",
        replace = function (value)
            return value .. " броні"
        end,
    },
    {
        pattern = "^Quantity: (%d+)$",
        replace = function (count)
            return "Кількість: " .. count
        end,
    },
    {
        pattern = "^Total: (.+)$",
        replace = function (total)
            return "Разом: " .. total
        end,
    },
    {
        pattern = "^Requires Level (%d+)$",
        replace = function (level)
            return "Необхідний рівень " .. level
        end,
    },
    {
        pattern = "^<Made by (.+)>$",
        replace = function (name)
            return "<Виготовлено: " .. name .. ">"
        end,
    },
    {
        pattern = "^(%d+) Block$",
        replace = function (value)
            return value .. " блокування"
        end,
    },
    {
        pattern = "^([%d%.]+) %- ([%d%.]+) Damage$",
        replace = function (minimum, maximum)
            return minimum .. "–" .. maximum .. " шкоди"
        end,
    },
    {
        pattern = "^Speed ([%d%.]+)$",
        replace = function (value)
            return "Швидкість " .. value
        end,
    },
    {
        pattern = "^%(([%d%.]+) damage per second%)$",
        replace = function (value)
            return "(" .. value .. " шкоди за секунду)"
        end,
    },
    {
        pattern = "^([%+%-]?[%d%.]+) damage per second$",
        replace = function (value)
            return value .. " шкоди за секунду"
        end,
    },
    {
        pattern = "^Durability (%d+) / (%d+)$",
        replace = function (current, maximum)
            return "Міцність " .. current .. " / " .. maximum
        end,
    },
    {
        -- The issue reporter includes an inline colour prefix in the actual
        -- FontString, so preserve that markup while translating its template.
        pattern = "^(.-)Press (.-) to submit an issue for this ([A-Za-z]+)(.-)$",
        replace = function (prefix, shortcut, issue_type, suffix)
            if issue_type ~= "Item" and issue_type ~= "Quest"
                and issue_type ~= "Spell" and issue_type ~= "Creature" then
                return prefix .. "Press " .. shortcut .. " to submit an issue for this "
                    .. issue_type .. suffix
            end
            return prefix .. shortcut .. ": повідомити про помилку" .. suffix
        end,
    },
    {
        -- Preserve the client's coin textures and amounts after the label.
        pattern = "^Sell Price: (.+)$",
        replace = function (price)
            return "Ціна продажу: " .. price
        end,
    },
    {
        -- The character name is player data and must remain unchanged.
        pattern = "^(.+) Specific Macros$",
        replace = function (character)
            return "Макроси: " .. character
        end,
    },
    {
        pattern = "^(%d+)/(%d+) Characters Used$",
        replace = function (current, maximum)
            return "Використано символів: " .. current .. "/" .. maximum
        end,
    },
    {
        -- Camelot build 70058 colors both values in QUEST_LOG_COUNT_TEMPLATE.
        -- Preserve those codes so an over-capacity count stays red.
        pattern = "^Quests: (|c%x%x%x%x%x%x%x%x)(%d+)|r(|c%x%x%x%x%x%x%x%x)/(%d+)|r$",
        replace = function (current_color, current, maximum_color, maximum)
            return "Завдання: " .. current_color .. current .. "|r"
                .. maximum_color .. "/" .. maximum .. "|r"
        end,
    },
    {
        pattern = "^Quests:%s*(%d+)%s*/%s*(%d+)$",
        replace = function (current, maximum)
            return "Завдання: " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^XP: ([%d,]+)/([%d,]+)$",
        replace = function (current, maximum)
            return "Досвід: " .. current .. "/" .. maximum
        end,
    },
    {
        -- FRIENDS_LEVEL_TEMPLATE / UNIT_TYPE_LEVEL_TEMPLATE are formatted by
        -- Blizzard before the FontString is updated, so the exact client
        -- string "Level %d %s" can never match the visible value.
        pattern = "^Level (%d+) (.+)$",
        replace = function (level, class)
            -- A sentence, building or character-boost title is not a unit type.
            local translated_class = ui[class]
            if not translated_class then return nil end
            return "Рівень " .. level .. ": " .. translated_class
        end,
    },
    {
        -- Blizzard formats the level before the FontString is updated, so the
        -- exact client string with "%d" cannot match the visible tooltip.
        pattern = "^This feature becomes available at level (%d+)%.$",
        replace = function (level)
            return "Ця функція стає доступною на " .. level .. "-му рівні."
        end,
    },
    {
        pattern = "^Page (%d+)%s*/%s*(%d+)$",
        replace = function (current, maximum)
            return "Сторінка " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^(%d+) seconds? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "секунд"
                or last == 1 and "секунда"
                or last >= 2 and last <= 4 and "секунди" or "секунд"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^(%d+) minutes? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "хвилин"
                or last == 1 and "хвилина"
                or last >= 2 and last <= 4 and "хвилини" or "хвилин"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^(%d+) hours? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "годин"
                or last == 1 and "година"
                or last >= 2 and last <= 4 and "години" or "годин"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^Next Rewards at Rank (%d+)$",
        replace = function (rank) return "Наступні нагороди на " .. rank .. "-му ранзі" end,
    },
    {
        pattern = "^Rank Points: (.+)$",
        replace = function (value) return "Очки рангу: " .. value end,
    },
    {
        pattern = "^Season (%d+)$",
        replace = function (season) return "Сезон " .. season end,
    },
    {
        pattern = "^Season ends in: (.+)$",
        replace = function (remaining) return "До завершення сезону: " .. remaining end,
    },
    {
        pattern = "^Current CPU: (.+)$",
        replace = function (value) return "Поточне використання ЦП: " .. value end,
    },
    {
        pattern = "^Average CPU: (.+)$",
        replace = function (value) return "Середнє використання ЦП: " .. value end,
    },
    {
        pattern = "^Peak CPU: (.+)$",
        replace = function (value) return "Пікове використання ЦП: " .. value end,
    },
    {
        pattern = "^Collapse options (.+)$",
        replace = function (suffix) return "Згорнути параметри " .. suffix end,
    },
    {
        pattern = "^Cursor: ([%d%.]+), ([%d%.]+)$",
        replace = function (x, y) return "Курсор: " .. x .. ", " .. y end,
    },
    {
        pattern = "^Player: ([%d%.]+), ([%d%.]+)$",
        replace = function (x, y) return "Гравець: " .. x .. ", " .. y end,
    },
    {
        pattern = "^Player: ([%d%.]+), ([%d%.]+) %((.+)%)$",
        replace = function (x, y, zone)
            local translated = addonTable.zone and addonTable.zone[zone] or zone
            return "Гравець: " .. x .. ", " .. y .. " (" .. translated .. ")"
        end,
    },
    {
        pattern = "^Lvl (%d+)$",
        replace = function (level) return "Рів. " .. level end,
    },
    {
        pattern = "^%((Rank %d+)%)$",
        replace = function (rank)
            return "(" .. rank:gsub("Rank", "Ранг") .. ")"
        end,
    },
    {
        pattern = "^Item Purchased: (.+)$",
        replace = function (item)
            return "Придбано: " .. mail_item_name(item)
        end,
    },
    {
        pattern = "^Auction won: (.+)$",
        replace = function (item)
            return "Виграно на аукціоні: "
                .. mail_item_name(item)
        end,
    },
    {
        pattern = "^Sold By: (.+)$",
        replace = function (seller) return "Продавець: " .. mail_party_name(seller) end,
    },
    {
        pattern = "^Item Sold: (.+)$",
        replace = function (item) return "Продано: " .. mail_item_name(item) end,
    },
    {
        pattern = "^Purchased By: (.+)$",
        replace = function (buyer) return "Покупець: " .. mail_party_name(buyer) end,
    },
    {
        pattern = "^Auction successful: (.+)$",
        replace = function (item) return "Продано на аукціоні: " .. mail_item_name(item) end,
    },
    {
        pattern = "^Sale Pending: (.+)$",
        replace = function (item) return "Очікується оплата: " .. mail_item_name(item) end,
    },
    {
        pattern = "^Requires Body of (.+)$",
        replace = function (name)
            local entries = addonTable.use("entries")
            return "Потрібне тіло: "
                .. (entries.lookup_name("npc", name) or name)
        end,
    },
    {
        pattern = "^Backpack %((.-)%)$",
        replace = function (binding) return "Рюкзак (" .. binding .. ")" end,
    },
    {
        pattern = "^(%d+) Empty Slots %(Total%)$",
        replace = function (count)
            local number = tonumber(count) or 0
            local last_two, last = number % 100, number % 10
            local slots = "вільних комірок"
            if last_two < 11 or last_two > 14 then
                if last == 1 then slots = "вільна комірка"
                elseif last >= 2 and last <= 4 then slots = "вільні комірки" end
            end
            return count .. " " .. slots .. " (усього)"
        end,
    },
    {
        pattern = "^(%d+) Empty Slots$",
        replace = function (count)
            local number = tonumber(count) or 0
            local last_two, last = number % 100, number % 10
            local slots = "вільних комірок"
            if last_two < 11 or last_two > 14 then
                if last == 1 then slots = "вільна комірка"
                elseif last >= 2 and last <= 4 then slots = "вільні комірки" end
            end
            return count .. " " .. slots
        end,
    },
    {
        -- Forever appends the current key binding to micro-menu tooltip titles,
        -- while ClassicUA stores the untranslated base label (for example,
        -- CHARACTER_INFO = "Character Info"). Translate the base and preserve
        -- whichever binding the player currently uses.
        pattern = "^(.-) (|c%x%x%x%x%x%x%x%x)(%b())(|r)$",
        replace = function (label, color, binding, reset)
            return translate_bound_title(label, binding, color, reset)
        end,
    },
    {
        pattern = "^(.-) (|cn[%w_]+:)(%b())(|r)$",
        replace = function (label, color, binding, reset)
            return translate_bound_title(label, binding, color, reset)
        end,
    },
    {
        pattern = "^(.-) (%b())$",
        replace = translate_bound_title,
    },
    {
        pattern = "^Equip: Your spells pierce ([%d,]+) Magical Resistance%.$",
        replace = function (amount)
            return "Екіпірування: Ваші заклинання долають " .. amount
                .. " од. магічного опору."
        end,
    },
    {
        pattern = "^Classes: (.+)$",
        replace = function (classes)
            local names = {
                Druid = "друїд", Hunter = "мисливець", Mage = "маг",
                Paladin = "паладин", Priest = "жрець", Rogue = "розбійник",
                Shaman = "шаман", Warlock = "чаклун", Warrior = "воїн",
            }
            local translated = {}
            for class in classes:gmatch("[^,]+") do
                class = class:match("^%s*(.-)%s*$")
                local name = names[class]
                if not name then return nil end
                translated[#translated + 1] = name
            end
            local label = #translated == 1 and "Клас: " or "Класи: "
            return label .. table.concat(translated, ", ")
        end,
    },
    {
        pattern = "^(Непрочитані листи від: )(.+)$",
        replace = function (prefix, location)
            local translated = ui[location]
            return translated and (prefix .. translated) or nil
        end,
    },
    {
        pattern = "^([%+%-])(%d+) (.+)$",
        replace = function (sign, amount, stat)
            local names = {
                Strength = "сили", Stamina = "витривалості",
                Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
            }
            local name = names[stat]
            return name and (sign .. amount .. " до " .. name) or nil
        end,
    },
    {
        pattern = "^%+(%d+) (.+)$",
        replace = function (amount, stat)
            local names = {
                Strength = "сили", Stamina = "витривалості",
                Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
            }
            local name = names[stat]
            return name and ("+" .. amount .. " до " .. name) or nil
        end,
    },
    {
        pattern = "^Level (%d+)$",
        replace = function (level)
            return "Рівень " .. level
        end,
    },
}

end

do
-- Same English label can mean different things in different parts of the UI.
addonTable.forever_ui_context = {
    { text = "C", frame = "DamageMeter", translation = "П" },
    { text = "O", frame = "DamageMeter", translation = "З" },
    -- Device selectors use this value inside the native 220px dropdown.
    { text = "System Default", frame = "SettingsPanel", translation = "Типовий пристрій системи" },
    { text = "Unit", frame = "CompactRaidFrameManager", translation = "Цілі" },
    { text = "Ground", frame = "CompactRaidFrameManager", translation = "Земля" },
    { text = "Restrict Pings To:", frame = "CompactRaidFrameManager", translation = "Дозволити позначки:" },
    { text = "Convert To Raid", frame = "RaidFrame", translation = "Створити рейд" },
    { text = "Convert To Party", frame = "RaidFrame", translation = "Перетворити на групу" },
    { text = "Extend Raid Lock", frame = "RaidInfo", translation = "Продовжити збереження рейду" },
    { text = "Reactivate Raid Lock", frame = "RaidInfo", translation = "Поновити збереження рейду" },
    { text = "Remove Raid Lock Extension", frame = "RaidInfo", translation = "Скасувати продовження" },
    -- Chat configuration labels describe message categories, not actions.
    { text = "Say", frame = "ChatConfig", translation = "Розмова" },
    { text = "Skill-ups", frame = "ChatConfig", translation = "Підвищення навичок" },
    { text = "Item Loot", frame = "ChatConfig", translation = "Здобич: предмети" },
    { text = "Money Loot", frame = "ChatConfig", translation = "Здобич: гроші" },
    { text = "Pet Info", frame = "ChatConfig", translation = "Інформація про вихованця" },
    { text = "Pet Battle Combat", frame = "ChatConfig", translation = "Бої вихованців" },
    { text = "Pet Battle Info", frame = "ChatConfig", translation = "Інформація про бої вихованців" },
    { text = "Battleground Horde", frame = "ChatConfig", translation = "Поле бою: Орда" },
    { text = "Battleground Alliance", frame = "ChatConfig", translation = "Поле бою: Альянс" },
    { text = "Battleground Neutral", frame = "ChatConfig", translation = "Поле бою — нейтральна" },
    { text = "Boss Emote", frame = "ChatConfig", translation = "Повідомлення боса" },
    { text = "Boss Whisper", frame = "ChatConfig", translation = "Шепіт боса" },
    { text = "Send Mail", frame = "MailFrameTab2.Text", translation = "Надіслати листа" },
    { text = "Custom", frame = "LFGListingFrameCategoryView", translation = "Користувацькі групи" },
    { text = "Back", frame = "Quest", translation = "Назад" },
    { text = "Play", frame = "QuestMapFrame", translation = "Програти" },
    { text = "Common", frame = "LootFrame", translation = "Звичайний" },
    { text = "Common", frame = "LootButton", translation = "Звичайний" },
    { text = "General", frame = "SpellBook", translation = "Загальні" },
    { text = "General", frame = "PVPRankFrame", translation = "Генерал" },
    { text = "General", frame = "ChatFrame", translation = "Загальний" },
    { text = "General", frame = "CharacterStatsPane", translation = "Загальний" },
    { text = "General", frame = "Settings", translation = "Загальний" },
    { text = "invites you to join the guild:", frame = "GuildInviteFrameInviteText", translation = "запрошує вас до гільдії:" },
    { text = "Join Guild", frame = "GuildInviteFrameJoinButton", translation = "Вступити" },
    { text = "Decline Invitation", frame = "GuildInviteFrameDeclineButton", translation = "Відхилити" },
}

end

do
-- Display-only translations for Camelot's Skills pane. Skill names are kept
-- here instead of replacing Blizzard globals because some UI code uses the
-- English values as internal lookup keys.
local skills = {
    ["Against Raid Bosses"] = addonTable.forever_ui["Against Raid Bosses"],
    ["Agility Food"] = addonTable.forever_ui["Agility Food"],
    ["Allows for the use of fist weapons.  Chance to hit is determined by the Unarmed skill."] = addonTable.forever_ui["Allows for the use of fist weapons.  Chance to hit is determined by the Unarmed skill."],
    ["Allows the use of shields."] = addonTable.forever_ui["Allows the use of shields."],
    ["Allows the wearing of cloth armor."] = addonTable.forever_ui["Allows the wearing of cloth armor."],
    ["Allows the wearing of leather armor."] = addonTable.forever_ui["Allows the wearing of leather armor."],
    ["Allows the wearing of mail armor."] = addonTable.forever_ui["Allows the wearing of mail armor."],
    ["Allows the wearing of plate armor."] = addonTable.forever_ui["Allows the wearing of plate armor."],
    ["Armor Proficiencies"] = addonTable.forever_ui["Armor Proficiencies"],
    ["Axes"] = addonTable.forever_ui["Axes"],
    ["Boots Enchants"] = addonTable.forever_ui["Boots Enchants"],
    ["Bows"] = addonTable.forever_ui["Bows"],
    ["Bracer Enchants"] = addonTable.forever_ui["Bracer Enchants"],
    ["Camping"] = addonTable.forever_ui["Camping"],
    ["Cloth"] = addonTable.forever_ui["Cloth"],
    ["Common"] = addonTable.forever_ui["Common"],
    ["Crossbows"] = addonTable.forever_ui["Crossbows"],
    ["Daggers"] = addonTable.forever_ui["Daggers"],
    ["Darnassian"] = addonTable.forever_ui["Darnassian"],
    ["Defense"] = addonTable.forever_ui["Defense"],
    ["Dual Wield"] = addonTable.forever_ui["Dual Wield"],
    ["Dwarven"] = addonTable.forever_ui["Dwarven"],
    ["Equal-Level Enemy"] = addonTable.forever_ui["Equal-Level Enemy"],
    ["Fist Weapons"] = addonTable.forever_ui["Fist Weapons"],
    ["Gnomish"] = addonTable.forever_ui["Gnomish"],
    ["Guns"] = addonTable.forever_ui["Guns"],
    ["Gutterspeak"] = addonTable.forever_ui["Gutterspeak"],
    ["Higher alchemy skill allows you to learn higher level alchemy recipes.  Alchemy recipes can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher alchemy skill allows you to learn higher level alchemy recipes.  Alchemy recipes can be found on trainers around the world as well as from quests and monsters."],
    ["Higher alchemy skill allows you to learn higher level alchemy recipes. Alchemy recipes can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher alchemy skill allows you to learn higher level alchemy recipes. Alchemy recipes can be found on trainers around the world as well as from quests and monsters."],
    ["Higher comprehension skill allows more powerful magical scrolls to be deciphered. Scrolls can be found throughout the world and are consumed when read, granting a variety of beneficial effects."] = addonTable.forever_ui["Higher comprehension skill allows more powerful magical scrolls to be deciphered. Scrolls can be found throughout the world and are consumed when read, granting a variety of beneficial effects."],
    ["Higher cooking skill allows you to learn higher level cooking recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] = addonTable.forever_ui["Higher cooking skill allows you to learn higher level cooking recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."],
    ["Higher cooking skill allows you to learn higher level cooking recipes. Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] = addonTable.forever_ui["Higher cooking skill allows you to learn higher level cooking recipes. Recipes can be found on trainers around the world as well as from quests and as drops from monsters."],
    ["Higher defense makes you harder to hit and makes monsters less likely to land a crushing blow."] = addonTable.forever_ui["Higher defense makes you harder to hit and makes monsters less likely to land a crushing blow."],
    ["Higher enchanting skill allows you to learn more powerful formulae.  Formulae can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher enchanting skill allows you to learn more powerful formulae.  Formulae can be found on trainers around the world as well as from quests and monsters."],
    ["Higher enchanting skill allows you to learn more powerful formulae. Formulae can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher enchanting skill allows you to learn more powerful formulae. Formulae can be found on trainers around the world as well as from quests and monsters."],
    ["Higher engineering skill allows you to learn higher level engineering schematics.  Schematics can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher engineering skill allows you to learn higher level engineering schematics.  Schematics can be found on trainers around the world as well as from quests and monsters."],
    ["Higher engineering skill allows you to learn higher level engineering schematics. Schematics can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher engineering skill allows you to learn higher level engineering schematics. Schematics can be found on trainers around the world as well as from quests and monsters."],
    ["Higher engraving skill allows you to learn higher level runes and apply them to your armor and weapons.  Runes can be found hidden throughout the world."] = addonTable.forever_ui["Higher engraving skill allows you to learn higher level runes and apply them to your armor and weapons.  Runes can be found hidden throughout the world."],
    ["Higher first aid skill allows you to learn higher level first aid abilities.  First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."] = addonTable.forever_ui["Higher first aid skill allows you to learn higher level first aid abilities.  First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."],
    ["Higher first aid skill allows you to learn higher level first aid abilities. First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."] = addonTable.forever_ui["Higher first aid skill allows you to learn higher level first aid abilities. First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."],
    ["Higher fishing skill increases your chance of catching fish in bodies of water around the world.  If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."] = addonTable.forever_ui["Higher fishing skill increases your chance of catching fish in bodies of water around the world.  If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."],
    ["Higher fishing skill increases your chance of catching fish in bodies of water around the world. If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."] = addonTable.forever_ui["Higher fishing skill increases your chance of catching fish in bodies of water around the world. If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."],
    ["Higher herbalism skill allows you to harvest more difficult herbs around the world.  If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."] = addonTable.forever_ui["Higher herbalism skill allows you to harvest more difficult herbs around the world.  If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."],
    ["Higher herbalism skill allows you to harvest more difficult herbs around the world. If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."] = addonTable.forever_ui["Higher herbalism skill allows you to harvest more difficult herbs around the world. If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."],
    ["Higher leatherworking skill allows you to learn higher level leatherworking patterns.  Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher leatherworking skill allows you to learn higher level leatherworking patterns.  Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."],
    ["Higher leatherworking skill allows you to learn higher level leatherworking patterns. Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher leatherworking skill allows you to learn higher level leatherworking patterns. Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."],
    ["Higher mining skill allows you to harvest more difficult minerals nodes around the world.  If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."] = addonTable.forever_ui["Higher mining skill allows you to harvest more difficult minerals nodes around the world.  If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."],
    ["Higher mining skill allows you to harvest more difficult minerals nodes around the world. If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."] = addonTable.forever_ui["Higher mining skill allows you to harvest more difficult minerals nodes around the world. If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."],
    ["Higher poison skill allows more powerful poisons to be crafted. Reagents can be purchased from poison vendors and shady dealers, then combined into deadly concoctions that rot, weaken, and wither foes."] = addonTable.forever_ui["Higher poison skill allows more powerful poisons to be crafted. Reagents can be purchased from poison vendors and shady dealers, then combined into deadly concoctions that rot, weaken, and wither foes."],
    ["Higher riding skill allows you to ride faster and more exotic beasts."] = addonTable.forever_ui["Higher riding skill allows you to ride faster and more exotic beasts."],
    ["Higher skill allows you to learn higher level recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] = addonTable.forever_ui["Higher skill allows you to learn higher level recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."],
    ["Higher skill increases your chance to hit."] = addonTable.forever_ui["Higher skill increases your chance to hit."],
    ["Higher skinning skill allows you to skin hides from higher level monsters around the world.    Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."] = addonTable.forever_ui["Higher skinning skill allows you to skin hides from higher level monsters around the world.    Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."],
    ["Higher skinning skill allows you to skin hides from higher level monsters around the world. Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."] = addonTable.forever_ui["Higher skinning skill allows you to skin hides from higher level monsters around the world. Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."],
    ["Higher smithing skill allows you to learn higher level smithing plans.  Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher smithing skill allows you to learn higher level smithing plans.  Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."],
    ["Higher smithing skill allows you to learn higher level smithing plans. Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher smithing skill allows you to learn higher level smithing plans. Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."],
    ["Higher tailoring skill allows you to learn higher level tailoring patterns.  Tailoring patterns can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher tailoring skill allows you to learn higher level tailoring patterns.  Tailoring patterns can be found on trainers around the world as well as from quests and monsters."],
    ["Higher tailoring skill allows you to learn higher level tailoring patterns. Tailoring patterns can be found on trainers around the world as well as from quests and monsters."] = addonTable.forever_ui["Higher tailoring skill allows you to learn higher level tailoring patterns. Tailoring patterns can be found on trainers around the world as well as from quests and monsters."],
    ["Higher weapon skill increases your chance to hit."] = addonTable.forever_ui["Higher weapon skill increases your chance to hit."],
    ["Languages"] = addonTable.forever_ui["Languages"],
    ["Leather"] = addonTable.forever_ui["Leather"],
    ["Maces"] = addonTable.forever_ui["Maces"],
    ["Mining"] = addonTable.forever_ui["Mining"],
    ["Misc specialization handling spells go here."] = addonTable.forever_ui["Misc specialization handling spells go here."],
    ["One-Handed Axes"] = addonTable.forever_ui["One-Handed Axes"],
    ["One-Handed Maces"] = addonTable.forever_ui["One-Handed Maces"],
    ["One-Handed Swords"] = addonTable.forever_ui["One-Handed Swords"],
    ["Orcish"] = addonTable.forever_ui["Orcish"],
    ["Plate Mail"] = addonTable.forever_ui["Plate Mail"],
    ["Polearms"] = addonTable.forever_ui["Polearms"],
    ["Relics"] = addonTable.forever_ui["Relics"],
    ["Runed Enchanting Rods"] = addonTable.forever_ui["Runed Enchanting Rods"],
    ["Shield"] = addonTable.forever_ui["Shield"],
    ["Skills"] = addonTable.forever_ui["Skills"],
    ["Staves"] = addonTable.forever_ui["Staves"],
    ["Swords"] = addonTable.forever_ui["Swords"],
    ["Taurahe"] = addonTable.forever_ui["Taurahe"],
    ["Thrown"] = addonTable.forever_ui["Thrown"],
    ["Troll"] = addonTable.forever_ui["Troll"],
    ["Two-Handed Axes"] = addonTable.forever_ui["Two-Handed Axes"],
    ["Two-Handed Maces"] = addonTable.forever_ui["Two-Handed Maces"],
    ["Two-Handed Swords"] = addonTable.forever_ui["Two-Handed Swords"],
    ["Two-Handed Weapon Enchants"] = addonTable.forever_ui["Two-Handed Weapon Enchants"],
    ["Unarmed"] = addonTable.forever_ui["Unarmed"],
    ["Wands"] = addonTable.forever_ui["Wands"],
    ["Weapon Skills"] = addonTable.forever_ui["Weapon Skills"],
    ["Wizard Oils"] = addonTable.forever_ui["Wizard Oils"],
    ["Your companions."] = addonTable.forever_ui["Your companions."],
    ["Your mounts."] = addonTable.forever_ui["Your mounts."],
}

addonTable.forever_ui_context = addonTable.forever_ui_context or {}
addonTable.forever_ui_context[#addonTable.forever_ui_context + 1] = {
    text = "Mail",
    frame = "CharacterFrame",
    translation = "Кольчуга",
}
addonTable.forever_ui_context[#addonTable.forever_ui_context + 1] = {
    text = "Mail",
    frame = "SkillsFrame",
    translation = "Кольчуга",
}

addonTable.forever_ui_patterns = addonTable.forever_ui_patterns or {}

-- SkillsFrame formats every percentage before writing these complete blocks.
-- Reuse the canonical translation and handle both native newline forms.
local function weapon_chance_rule(source, visible_newlines, normalized)
    local template = source
    if visible_newlines then template = template:gsub("\\n", "\n") end
    if normalized then
        template = template:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
            :gsub("%s+", " "):match("^%s*(.-)%s*$")
    end
    local parts, cursor, slots = {}, 1, 0
    local function literal(value)
        return value:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
    end
    while true do
        local first, last = template:find("%s", cursor, true)
        parts[#parts + 1] = literal(template:sub(cursor, first and first - 1 or -1))
        if not first then break end
        parts[#parts + 1] = "([%+%-]?[%d%.,]+%%)"
        slots, cursor = slots + 1, last + 1
    end
    return {
        pattern = "^" .. table.concat(parts) .. "$",
        replace = function (...)
            local values = { ... }
            local target = addonTable.forever_ui[source]
            if not target or #values ~= slots then return nil end
            local index = 0
            target = target:gsub("%%s", function ()
                index = index + 1
                return values[index]
            end)
            if index ~= slots then return nil end
            if visible_newlines then target = target:gsub("\\n", "\n") end
            return target
        end,
    }
end

local weapon_chance_same_level = "Chance to |cFFFFFFFFHit|r, and to avoid being |cFFFFFFFFDodged|r or |cFFFFFFFFParried|r: %s\\n\\nChance to |cFFFFFFFFCritically Hit|r: %s"
local weapon_chance_boss = weapon_chance_same_level .. "\\n\\n|cFFFFFFFFGlancing Blows|r occur %s of the time and deal %s less damage"
local patterns = {
    weapon_chance_rule(weapon_chance_same_level, false),
    weapon_chance_rule(weapon_chance_same_level, true),
    weapon_chance_rule(weapon_chance_same_level, false, true),
    weapon_chance_rule(weapon_chance_same_level, true, true),
    weapon_chance_rule(weapon_chance_boss, false),
    weapon_chance_rule(weapon_chance_boss, true),
    weapon_chance_rule(weapon_chance_boss, false, true),
    weapon_chance_rule(weapon_chance_boss, true, true),
    {
        pattern = "^Chance to Hit, and to avoid being Dodged or Parried:%s*([%+%-]?[%d%.,]+%%)$",
        replace = function (value)
            return "Ймовірність влучити й уникнути ухилення або парирування: " .. value
        end,
    },
    {
        pattern = "^Chance to Critically Hit:%s*([%+%-]?[%d%.,]+%%)$",
        replace = function (value)
            return "Ймовірність критичного удару: " .. value
        end,
    },
    {
        pattern = "^Glancing Blows occur ([%d%.,]+%%) of the time and deal ([%d%.,]+%%) less damage$",
        replace = function (frequency, damage)
            return "Ковзні удари трапляються у " .. frequency
                .. " випадків і завдають на " .. damage .. " менше шкоди"
        end,
    },
    {
        pattern = "^Language:%s*(.+)$",
        replace = function (language)
            local exact = addonTable.forever_ui["Language: " .. language]
            if exact then return exact end
            local translated = addonTable.language and addonTable.language[language]
            return translated and ("Мова: " .. translated) or nil
        end,
    },
}

for _, pattern in ipairs(patterns) do
    addonTable.forever_ui_patterns[#addonTable.forever_ui_patterns + 1] = pattern
end

end

