local _, addon_table = ...

local options = addon_table.use("options")
local utils = addon_table.use("utils")

local default_account = {
    enabled = true,
    dev_mode = false,
    dev_mode_notify_activity = false,
    auto_scan_content = false,
    auto_scan_diagnostics = false,
    override_system_fonts = true,
    disable_all_translation = false,
    translate_quest = true,
    translate_book = true,
    translate_gossip = true,
    translate_chat = true,
    translate_chat_bubble = true,
    chat_style = "replacement",
    translate_item = true,
    translate_quest_item = true,
    translate_spell = true,
    translate_npc = true,
    translate_nameplates = true,
    translate_npc_tooltip = true,
    translate_npc_target_frame = true,
    translate_other_tooltips = true,
    tooltip_language_mode = "ukrainian",
    translation_scope = "full",
    translate_item_names = true,
    translate_quest_names = true,
    translate_spell_names = true,
    translate_skill_names = true,
    shift_original_tooltip = true,
    translate_string = true,
    translate_combat_text = true,
    translate_zone = true,
}

local default_character = {
    name_cases = {},
}

-- IDs are also SavedVariables keys; wording lives in the addon locale.
options.section_groups = {
    { id = "quests", sections = { "quest_names", "quest_text", "quest_ui", "gossip", "books" } },
    { id = "items", sections = { "item_names", "item_details", "quest_items", "bags", "merchant", "loot", "auction" } },
    { id = "spells", sections = { "spell_names", "spell_details", "auras", "talents", "spell_ui", "skill_names", "recipes", "profession_ui", "trainer", "cast_bars" } },
    { id = "world", sections = { "npc_tooltips", "npc_target", "nameplates", "objects", "zone_names", "map_ui" } },
    { id = "chat", sections = { "npc_chat", "chat_bubbles", "system_chat", "chat_links", "chat_ui", "combat_log", "combat_text", "loss_of_control", "mirror_timers" } },
    { id = "character", sections = { "character_ui", "reputation", "pvp", "achievements", "achievement_alerts", "level_up" } },
    { id = "social", sections = { "social_ui", "raid_ui", "lfg", "mail" } },
    { id = "interface", sections = { "game_menu", "game_settings", "edit_mode", "generic_tooltips", "popups" } },
}

local legacy_sections = {
    item_names = "translate_item_names", quest_names = "translate_quest_names",
    spell_names = "translate_spell_names", skill_names = "translate_skill_names",
    zone_names = "translate_zone", combat_text = "translate_combat_text",
}
options.section_key = function (id) return legacy_sections[id] or "section_" .. id end
for _, group in ipairs(options.section_groups) do
    for _, id in ipairs(group.sections) do
        default_account[options.section_key(id)] = true
    end
end

options.section_enabled = function (id)
    local account = options.account
    return account and account.enabled and not account.disable_all_translation
        and (account.translation_scope ~= "custom"
            or account[options.section_key(id)] ~= false) or false
end

-- Inspect actual frame ancestry before broad registry groups (which contain
-- several independently configurable windows). Anonymous pooled rows inherit
-- their owning panel. Public reads only, including on protected frames.
local frame_sections = {
    { "UA_ForeverSettingsPanel", "addon" },
    { "StaticPopup", "popups" }, { "Quest", "quest_ui" },
    { "ObjectiveTracker", "quest_ui" }, { "Gossip", "gossip" },
    { "ItemText", "books" }, { "Merchant", "merchant" },
    { "ContainerFrame", "bags" }, { "Bank", "bags" },
    { "LootFrame", "loot" }, { "GroupLoot", "loot" },
    { "Auction", "auction" }, { "Professions", "profession_ui" },
    { "ClassTrainer", "trainer" }, { "PlayerSpells", "spell_ui" },
    { "SpellBook", "spell_ui" }, { "Talent", "spell_ui" },
    { "Skill", "spell_ui" }, { "Reputation", "reputation" },
    { "PVP", "pvp" }, { "Honor", "pvp" },
    { "AchievementAlert", "achievement_alerts" }, { "Achievement", "achievements" },
    { "Character", "character_ui" }, { "PaperDoll", "character_ui" },
    { "Token", "character_ui" }, { "Statistics", "character_ui" },
    { "GearManager", "character_ui" }, { "Friends", "social_ui" },
    { "Guild", "social_ui" }, { "Communities", "social_ui" },
    { "BattleNet", "social_ui" }, { "AddFriend", "social_ui" },
    { "Raid", "raid_ui" }, { "LFG", "lfg" }, { "GroupFinder", "lfg" },
    { "CompactRaid", "raid_ui" }, { "StackSplit", "popups" },
    { "Mail", "mail" }, { "Inbox", "mail" }, { "SendMail", "mail" },
    { "GameMenu", "game_menu" }, { "MainMenu", "game_menu" },
    { "Settings", "game_settings" }, { "EditMode", "edit_mode" },
    { "Chat", "chat_ui" }, { "GeneralDock", "chat_ui" }, { "FloatingChat", "chat_ui" },
    { "WorldMap", "map_ui" }, { "Minimap", "map_ui" }, { "AdventureMap", "map_ui" },
    { "EventToast", "level_up" },
}
local surface_sections = {
    ["game-menu"] = "game_menu", settings = "game_settings", ["edit-mode"] = "edit_mode",
    ["level-up"] = "level_up", mail = "mail", lfg = "lfg", character = "character_ui",
    skills = "spell_ui", professions = "profession_ui", trainer = "trainer",
    social = "social_ui", ["raid-ui"] = "raid_ui", ["achievement-ui"] = "achievements",
    ["achievement-alert"] = "achievement_alerts", ["chat-tabs"] = "chat_ui",
    ["chat-links"] = "chat_links", popup = "popups", trade = "unsupported",
}
local owner_sections = {
    ["book-title"] = "books", ["book-page"] = "books", gossip = "gossip",
    ["gossip-map"] = "gossip", ["chat-bubble"] = "chat_bubbles",
    ["chat-tabs"] = "chat_ui", ["chat-config"] = "chat_ui",
    ["npc-nameplate"] = "nameplates", ["npc-target"] = "npc_target",
    ["target-frame"] = "npc_target", ["npc-tooltip"] = "npc_tooltips",
    ["quest-npc"] = "npc_tooltips", ["cast-bar"] = "cast_bars",
    ["loss-of-control"] = "loss_of_control", ["mirror-timer"] = "mirror_timers",
    ["object-tooltip"] = "objects", ["cursor-tooltip"] = "objects",
    ["character-level"] = "character_ui", ["quest-timer"] = "quest_ui",
    ["quest-ui"] = "quest_ui", ["quest-greeting"] = "gossip",
    ["worldmap-coords"] = "map_ui", ["ui-message"] = "popups",
    ["combat-text"] = "combat_text", ["chat-links"] = "chat_links",
}

local function public_method(object, method)
    if not object then return nil end
    local ok, callback = pcall(function () return object[method] end)
    if not ok or type(callback) ~= "function" then return nil end
    local success, value = pcall(callback, object)
    if not success then return nil end
    if type(_G.issecretvalue) == "function" then
        local safe, secret = pcall(_G.issecretvalue, value)
        if not safe or secret then return nil end
    end
    return value
end

local function frame_section(region)
    local current = region
    for _ = 1, 20 do
        if not current then break end
        local name = public_method(current, "GetName")
        if type(name) == "string" then
            if name:match("MicroButton$") then return "game_menu" end
            for _, entry in ipairs(frame_sections) do
                if name:sub(1, #entry[1]) == entry[1] then return entry[2] end
            end
        end
        current = public_method(current, "GetOwnerRegion") or public_method(current, "GetOwner")
            or public_method(current, "GetParent")
    end
end

options.section_for = function (spec, region)
    spec = spec or {}
    if spec.section then return spec.section end
    local owner, slot = spec.owner or "", spec.slot or ""
    local category = spec.category
    if owner == "npc-target" or owner == "npc-nameplate" or owner == "npc-tooltip"
        or owner == "cast-bar" or owner == "chat-links" then return owner_sections[owner] end
    if slot:match("^aura%.") then return "auras" end
    if owner == "talent-tooltip" then return "talents" end
    if owner == "talent-frame" then return "spell_ui" end
    if slot:match("^quest[:.]") or category == "quest" then
        return slot:match("%.name$") and "quest_names" or "quest_text"
    end
    if slot:match("^profession%.") and slot:find("recipe", 1, true)
        or slot:match("^profession.search%-result") then return "recipes" end
    if slot:match("^item[:.]") or category == "item" then
        return (slot:match("%.name$") or slot:find("secondary-name", 1, true))
            and "item_names" or "item_details"
    end
    if category == "skill" or slot:match("^skill%.") then return "skill_names" end
    if slot:match("^spell[:.]") or slot:match("^pet%-action%.") or category == "spell" then
        return slot:match("%.name$") and "spell_names" or "spell_details"
    end
    if slot:match("^zone%.") or category == "zone" or owner:match("^zone%-") then
        return "zone_names"
    end
    if slot:match("^achievement%.") then
        local surface = type(spec.surface) == "table" and spec.surface.id or spec.surface
        return surface == "achievement-alert" and "achievement_alerts" or "achievements"
    end
    if spec.option == "translate_gossip" then return "gossip" end
    if spec.option == "translate_book" then return "books" end
    if slot:match("^npc%.") or category == "npc" then return "npc_tooltips" end
    if owner_sections[owner] then return owner_sections[owner] end
    if spec.tooltip then
        local kind = spec.tooltip.uaForeverKind
        local kinds = { item = "item_details", spell = "spell_details", aura = "auras",
            talent = "talents", npc = "npc_tooltips", quest = "quest_text",
            ["character-stat"] = "character_ui", ["equipment-slot"] = "character_ui",
            ["empty-bag-slot"] = "bags", trainer = "trainer" }
        return kinds[kind] or "generic_tooltips"
    end
    local panel = frame_section(region)
    if panel then return panel end
    local surface = spec.surface
    local id = type(surface) == "table" and surface.id or surface
    if type(id) == "string" and surface_sections[id] then return surface_sections[id] end
    if owner == "profession-frame" or owner == "profession-recipes" then return "profession_ui" end
    if owner == "merchant" then return "merchant" end
    -- Unclassified UI must stay native when only selected sections are enabled.
    return "unsupported"
end

options.allows_section = function (spec, region)
    if not options.account or options.account.translation_scope ~= "custom" then return true end
    local id = options.section_for(spec, region)
    if id == "addon" then return true end
    if id == "unsupported" then return false end
    if not options.section_enabled(id) then return false end
    for _, flag in ipairs(spec and spec.options or {}) do
        if flag == "translate_quest_item" and not options.section_enabled("quest_items") then return false end
    end
    return true
end

options.prepare = function ()
    UA_ForeverDB = UA_ForeverDB or {}
    UA_ForeverDB.account = UA_ForeverDB.account or utils.copy_table_deep({}, default_account)
    UA_ForeverDB.character = UA_ForeverDB.character or utils.copy_table_deep({}, default_character)
    UA_ForeverDB.missing = UA_ForeverDB.missing or {}

    local previous = UA_ForeverDB.account
    local migration = {
        books = "translate_book", gossip = "translate_gossip", chat_bubbles = "translate_chat_bubble",
        npc_tooltips = "translate_npc_tooltip", npc_target = "translate_npc_target_frame",
        nameplates = "translate_nameplates", quest_items = "translate_quest_item",
        quest_text = "translate_quest", item_details = "translate_item",
        spell_details = "translate_spell", auras = "translate_spell", talents = "translate_spell",
        npc_chat = "translate_chat", system_chat = "translate_chat", chat_links = "translate_chat",
        combat_log = "translate_chat", objects = "translate_other_tooltips",
    }
    for id, flag in pairs(migration) do
        local key = options.section_key(id)
        if previous[key] == nil and previous[flag] == false then previous[key] = false end
    end
    utils.table_sync_keys(UA_ForeverDB.account, default_account)
    utils.table_sync_keys(UA_ForeverDB.character, default_character)

    options.account = UA_ForeverDB.account
    options.character = UA_ForeverDB.character
end

local section_flags = {
    translate_book = "books", translate_gossip = "gossip",
    translate_chat_bubble = "chat_bubbles", translate_quest_item = "quest_items",
    translate_nameplates = "nameplates", translate_npc_tooltip = "npc_tooltips",
    translate_npc_target_frame = "npc_target", translate_zone = "zone_names",
}
local domains = { translate_item = true, translate_quest = true,
    translate_spell = true, translate_npc = true, translate_string = true,
    translate_chat = true, translate_other_tooltips = true }

options.can_translate = function (...)
    local account = options.account
    if not account or not account.enabled or account.disable_all_translation then
        return false
    end

    for i = 1, select("#", ...) do
        local flag = select(i, ...)
        if section_flags[flag] then
            if not options.section_enabled(section_flags[flag]) then return false end
        elseif not domains[flag] and not account[flag] then
            return false
        end
    end

    return true
end

options.can_lookup = function (...)
    return options.account and (options.account.dev_mode
        or options.account.auto_scan_content or options.can_translate(...))
end

options.is_bilingual_tooltip = function ()
    return options.account and options.account.tooltip_language_mode == "bilingual"
end

local name_flags = {
    item = "translate_item_names", quest = "translate_quest_names",
    spell = "translate_spell_names", skill = "translate_skill_names",
}

options.translate_name = function (category)
    local account = options.account
    if not account or account.translation_scope ~= "custom" then return true end
    local flag = name_flags[category]
    return not flag or account[flag] == true
end

options.name_enabled = function (spec)
    local section = options.section_for(spec)
    -- These controls explicitly own both names and descriptions.
    if section == "auras" or section == "recipes" or section == "talents"
        or section == "cast_bars" then return true end
    return options.translate_name(spec.category)
end

options.translate_combat_text = function ()
    local account = options.account
    if not account or account.translation_scope ~= "custom" then return true end
    return account.translate_combat_text ~= false
end
