local _, addon_table = ...

local options = addon_table.use("options")
local utils = addon_table.use("utils")

local default_account = {
    enabled = true,
    dev_mode = false,
    dev_mode_notify_activity = false,
    auto_scan_menus = true,
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
    translate_zone = true,
}

local default_character = {
    name_cases = {},
}

options.prepare = function ()
    UA_ForeverDB = UA_ForeverDB or {}
    UA_ForeverDB.account = UA_ForeverDB.account or utils.copy_table_deep({}, default_account)
    UA_ForeverDB.character = UA_ForeverDB.character or utils.copy_table_deep({}, default_character)
    UA_ForeverDB.missing = UA_ForeverDB.missing or {}

    utils.table_sync_keys(UA_ForeverDB.account, default_account)
    utils.table_sync_keys(UA_ForeverDB.character, default_character)

    options.account = UA_ForeverDB.account
    options.character = UA_ForeverDB.character
end

options.can_translate = function (...)
    local account = options.account
    if not account or not account.enabled or account.disable_all_translation then
        return false
    end

    for i = 1, select("#", ...) do
        if not account[select(i, ...)] then
            return false
        end
    end

    return true
end

options.can_lookup = function (...)
    return options.account and (options.account.dev_mode or options.can_translate(...))
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
