local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local gossip_ui = addon_table.use("gossip_ui")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("gossip")

local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function npc_id()
    local ok, id = pcall(utils.npc_id_from_unit_id, "npc")
    return ok and id or nil
end

local function apply(region, slot, source, translated, category, option)
    if not region then return end
    -- Setup has just written to a pooled row. Discard the previous row claim.
    runtime.clear(region)
    if not safe_string(source) or not safe_string(translated) then return end
    runtime.apply(region, {
        owner = "gossip", slot = slot, source = source,
        translated = translated, category = category,
        option = type(option) == "string" and option or nil,
        options = type(option) == "table" and option or nil,
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function font_string(button)
    local ok, region = pcall(button.GetFontString, button)
    return ok and region or nil
end

local function replace_title(source, title, translation)
    local first, last = source:find(title, 1, true)
    if not first then return nil end
    return source:sub(1, first - 1) .. translation .. source:sub(last + 1)
end

local function quest_title(button, info)
    local quest_id = info and info.questID
    local title = info and info.title
    local region = font_string(button)
    if not region then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and safe_string(source) or nil
    runtime.clear(region)
    if not source or not safe_string(title) or not options.can_lookup("translate_quest") then return end
    local entry = entries.get_entry("quest", quest_id)
    local translated = entry and safe_string(entry[1])
    if not translated then translated = entries.get_glossary_text(title) end
    translated = safe_string(translated)
    if not translated or translated == title then return end
    translated = replace_title(source, title, translated)
    if not translated then return end
    apply(region, "quest:" .. tostring(quest_id) .. ".name", source, translated, "quest",
        { "translate_quest", "translate_gossip" })
    if options.translate_name("quest") and type(button.Resize) == "function" then
        pcall(button.Resize, button)
    end
end

local function greeting(frame, source)
    local region = frame and frame.GreetingText
    local id = npc_id()
    if region then runtime.clear(region) end
    if not region or not id or not safe_string(source)
        or not options.can_lookup("translate_gossip") then return end
    local translated = entries.get_gossip_text_for_npc_talk(id, source)
    apply(region, "npc:" .. id .. ".greeting", source, translated, nil, "translate_gossip")
    if type(frame.SetSize) == "function" and type(region.GetHeight) == "function" then
        local ok, height = pcall(region.GetHeight, region)
        if ok and type(height) == "number" then pcall(frame.SetSize, frame, 270, height) end
    end
end

local function option(button, info)
    local region = font_string(button)
    local id = npc_id()
    if not region then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and safe_string(source) or nil
    runtime.clear(region)
    local name = info and safe_string(info.name)
    if not id or not source or not name or not options.can_lookup("translate_gossip") then return end
    local translated = entries.get_gossip_text_for_player_reply(id, name)
    translated = safe_string(translated)
    if not translated or translated == name then return end
    translated = replace_title(source, name, translated)
    if not translated then return end
    apply(region, "npc:" .. id .. ".option:" .. tostring(info.orderIndex), source, translated, nil, "translate_gossip")
    if type(button.Resize) == "function" then pcall(button.Resize, button) end
end

local function gossip_title(frame, source)
    if not frame or type(frame.GetTitleText) ~= "function"
        or not safe_string(source) or not options.can_lookup("translate_npc") then return end
    local unit_ok, unit_name = pcall(_G.UnitName or function () end, "npc")
    if not unit_ok then return end
    if not safe_string(unit_name) or source ~= unit_name then return end
    local id = npc_id()
    local entry = id and entries.get_entry("npc", id)
    local translated = entry and safe_string(entry[1])
    if not translated then return end
    local ok, region = pcall(frame.GetTitleText, frame)
    if not ok or not region then return end
    local text_ok, current = pcall(region.GetText, region)
    if not text_ok or current ~= source then return end
    apply(region, "npc.name", source, utils.cap(translated), nil,
        "translate_npc")
end

gossip_ui.prepare = function ()
    hooks.region(_G.GossipFrameSharedMixin, "SetGossipTitle", gossip_title)
    hooks.region(_G.GossipFrame, "SetGossipTitle", gossip_title)
    hooks.region(_G.GossipGreetingTextMixin, "Setup", greeting)
    hooks.region(_G.GossipOptionButtonMixin, "Setup", option)
    hooks.region(_G.GossipSharedAvailableQuestButtonMixin, "Setup", quest_title)
    hooks.region(_G.GossipSharedActiveQuestButtonMixin, "Setup", quest_title)
end
