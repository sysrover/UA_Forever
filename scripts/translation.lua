local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")

translation.original = {}
translation.preferred_quest_language = "uk"

local quest_text_cache = {}

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
end

local function pack(...)
    return { n = select("#", ...), ... }
end

local function report_wrapper_error(name, message)
    dev_log.issue("Forever API wrapper: " .. name, tostring(message))
end

local function wrap_global(name, transform)
    local original = _G[name]
    if type(original) ~= "function" then
        return
    end

    translation.original[name] = original
    _G[name] = function (...)
        local args = pack(...)
        local results = pack(original(...))
        local ok, message = pcall(transform, results, args)
        if not ok then
            report_wrapper_error(name, message)
        end
        return unpack(results, 1, results.n)
    end
end

local function wrap_table(table_name, key, transform)
    local owner = _G[table_name]
    local original = owner and owner[key]
    if type(original) ~= "function" then
        return
    end

    local full_name = table_name .. "." .. key
    translation.original[full_name] = original
    owner[key] = function (...)
        local args = pack(...)
        local results = pack(original(...))
        local ok, message = pcall(transform, results, args)
        if not ok then
            report_wrapper_error(full_name, message)
        end
        return unpack(results, 1, results.n)
    end
end

local function current_quest_id()
    if type(_G.GetQuestID) == "function" then
        local id = GetQuestID()
        if id and id > 0 then
            return id
        end
    end
    if C_QuestLog and type(C_QuestLog.GetSelectedQuest) == "function" then
        local id = C_QuestLog.GetSelectedQuest()
        if id and id > 0 then
            return id
        end
    end
end

local function selected_quest_id(index)
    if index and C_QuestLog and type(C_QuestLog.GetInfo) == "function" then
        local info = C_QuestLog.GetInfo(index)
        if info and info.questID then
            return info.questID
        end
    end
    return current_quest_id()
end

local function quest_field(id, field, fallback)
    if not options.can_lookup("translate_quest") or not id then
        return fallback
    end
    local entry = entries.get_entry("quest", id)
    local value = entry and entry[field]

    if field == 1 then
        dev_log.record_id("quests", id, fallback, entry ~= nil)
    end

    if type(fallback) == "string" and not is_secret(fallback)
        and type(value) == "string" and not is_secret(value) then
        local cache = quest_text_cache[id] or { fields = {}, lookup = {} }
        local pair = { en = fallback, uk = value }
        cache.fields[field] = pair
        cache.lookup[fallback] = pair
        cache.lookup[value] = pair
        quest_text_cache[id] = cache
    end

    return value and options.can_translate("translate_quest")
        and translation.preferred_quest_language == "uk" and value or fallback
end

translation.get_current_quest_id = current_quest_id

translation.get_quest_language = function ()
    return translation.preferred_quest_language
end

translation.set_quest_language = function (language)
    if language == "uk" or language == "en" then
        translation.preferred_quest_language = language
    end
end

translation.refresh_quest_frame = function (root)
    local id = current_quest_id()
    local cache = id and quest_text_cache[id]
    if not root or not cache then return 0 end

    local translated = 0
    local seen = {}
    local language = translation.preferred_quest_language

    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 12 then return end
        seen[frame] = true

        if frame.GetRegions then
            local ok, regions = pcall(function () return { frame:GetRegions() } end)
            if ok then
                for _, region in ipairs(regions) do
                    if region.GetText and region.SetText then
                        local text_ok, text = pcall(region.GetText, region)
                        if text_ok and type(text) == "string" and not is_secret(text) then
                            local pair = cache.lookup[text]
                            local replacement = pair and pair[language]
                            if replacement and replacement ~= text then
                                local set_ok = pcall(region.SetText, region, replacement)
                                if set_ok then translated = translated + 1 end
                            end
                        end
                    end
                end
            end
        end

        if frame.GetChildren then
            local ok, children = pcall(function () return { frame:GetChildren() } end)
            if ok then
                for _, child in ipairs(children) do
                    local shown_ok, shown = pcall(child.IsShown, child)
                    if shown_ok and shown then visit(child, depth + 1) end
                end
            end
        end
    end

    visit(root, 1)
    return translated
end

local function translate_glossary(text, option, hint)
    if type(text) ~= "string" or not options.can_lookup(option) then
        return text
    end
    local result = entries.get_glossary_text(text, text, hint)
    return options.can_translate(option) and result or text
end

local function prepare_quest_hooks()
    wrap_global("GetTitleText", function (results)
        results[1] = quest_field(current_quest_id(), 1, results[1])
    end)
    wrap_global("GetQuestText", function (results)
        results[1] = quest_field(current_quest_id(), 2, results[1])
    end)
    wrap_global("GetObjectiveText", function (results)
        results[1] = quest_field(current_quest_id(), 3, results[1])
    end)
    wrap_global("GetProgressText", function (results)
        results[1] = quest_field(current_quest_id(), 4, results[1])
    end)
    wrap_global("GetRewardText", function (results)
        results[1] = quest_field(current_quest_id(), 5, results[1])
    end)
    wrap_global("GetQuestLogQuestText", function (results, args)
        local id = selected_quest_id(args[1])
        results[1] = quest_field(id, 2, results[1])
        results[2] = quest_field(id, 3, results[2])
    end)
    wrap_global("GetQuestLogTitle", function (results)
        if type(results[1]) ~= "string" then
            return
        end
        if results[4] then
            results[1] = translate_glossary(results[1], "translate_quest")
        else
            results[1] = quest_field(results[8], 1, results[1])
        end
    end)
    wrap_global("GetQuestLogLeaderBoard", function (results)
        if type(results[1]) == "string" and options.can_lookup("translate_quest") then
            local translated = entries.translate_quest_objective_task(results[1])
            if options.can_translate("translate_quest") then
                results[1] = translated
            end
        end
    end)

    wrap_table("C_QuestLog", "GetTitleForQuestID", function (results, args)
        results[1] = quest_field(args[1], 1, results[1])
    end)
    wrap_table("C_QuestLog", "GetInfo", function (results)
        local info = results[1]
        if not info or type(info.title) ~= "string" then
            return
        end
        if info.isHeader then
            info.title = translate_glossary(info.title, "translate_quest")
        else
            info.title = quest_field(info.questID, 1, info.title)
        end
    end)
    -- On Camelot the objective table feeds the live quest tracker. Wrapping or
    -- mutating it can leave the tracker with the initial 0/N text while the
    -- legacy quest log already reports the current progress. Keep this API
    -- pristine on secret-value clients; visible objective text can be handled
    -- later at the FontString layer without altering Blizzard's live data.
    if type(_G.issecretvalue) ~= "function" then
        wrap_table("C_QuestLog", "GetQuestObjectives", function (results)
            local objectives = results[1]
            if type(objectives) ~= "table" or not options.can_lookup("translate_quest") then
                return
            end
            for _, objective in ipairs(objectives) do
                if type(objective.text) == "string" then
                    local translated = entries.translate_quest_objective_task(objective.text)
                    if options.can_translate("translate_quest") then
                        objective.text = translated
                    end
                end
            end
        end)
    end
end

local function npc_id()
    return utils.npc_id_from_unit_id("npc")
end

local function gossip_text(text, is_reply)
    if type(text) ~= "string" or not options.can_lookup("translate_gossip") then
        return text
    end
    local id = npc_id()
    if not id then
        return text
    end
    local npc_entry = entries.get_entry("npc", id)
    dev_log.record_id("npcs", id, UnitName("npc"), npc_entry ~= nil)
    local translated = is_reply
        and entries.get_gossip_text_for_player_reply(id, text)
        or entries.get_gossip_text_for_npc_talk(id, text)
    return translated and options.can_translate("translate_gossip") and translated or text
end

local function gossip_quest_title(title, quest_id)
    local translated = quest_field(quest_id, 1, nil)
        or entries.get_glossary_text(title)
    return translated and options.can_translate("translate_gossip") and translated or title
end

local function prepare_gossip_hooks()
    wrap_global("GetGreetingText", function (results)
        results[1] = gossip_text(results[1], false)
    end)
    wrap_global("GetAvailableTitle", function (results)
        results[1] = gossip_quest_title(results[1], nil)
    end)
    wrap_global("GetActiveTitle", function (results)
        results[1] = gossip_quest_title(results[1], nil)
    end)

    wrap_table("C_GossipInfo", "GetText", function (results)
        results[1] = gossip_text(results[1], false)
    end)
    wrap_table("C_GossipInfo", "GetOptions", function (results)
        if type(results[1]) ~= "table" then return end
        for _, option in ipairs(results[1]) do
            if option and type(option.name) == "string" then
                option.name = gossip_text(option.name, true)
            end
        end
    end)
    wrap_table("C_GossipInfo", "GetAvailableQuests", function (results)
        if type(results[1]) ~= "table" then return end
        for _, quest in ipairs(results[1]) do
            if quest and type(quest.title) == "string" then
                quest.title = gossip_quest_title(quest.title, quest.questID)
            end
        end
    end)
    wrap_table("C_GossipInfo", "GetActiveQuests", function (results)
        if type(results[1]) ~= "table" then return end
        for _, quest in ipairs(results[1]) do
            if quest and type(quest.title) == "string" then
                quest.title = gossip_quest_title(quest.title, quest.questID)
            end
        end
    end)
    wrap_table("C_GossipInfo", "GetPoiInfo", function (results)
        if results[1] and type(results[1].name) == "string" then
            results[1].name = translate_glossary(results[1].name, "translate_gossip")
        end
    end)
end

local function prepare_zone_hooks()
    local function translate_result_name(results, args)
        local info = results[1]
        if info and type(info.name) == "string" then
            local map_id = tonumber(info.mapID or (args and args[1]))
            if map_id then dev_log.record_id("maps", map_id, info.name, false) end
            info.name = translate_glossary(info.name, "translate_zone", "zone")
        end
    end

    wrap_table("C_Map", "GetMapInfo", translate_result_name)
    wrap_table("C_Map", "GetMapInfoAtPosition", translate_result_name)
    wrap_table("C_Map", "GetMapChildrenInfo", function (results)
        if type(results[1]) ~= "table" then return end
        for _, info in ipairs(results[1]) do
            if info and type(info.name) == "string" then
                if info.mapID then dev_log.record_id("maps", info.mapID, info.name, false) end
                info.name = translate_glossary(info.name, "translate_zone", "zone")
            end
        end
    end)
    wrap_table("C_Map", "GetAreaInfo", function (results, args)
        if args and args[1] then dev_log.record_id("areas", args[1], results[1], false) end
        results[1] = translate_glossary(results[1], "translate_zone", "zone")
    end)

    for _, name in ipairs({
        "GetZoneText", "GetRealZoneText", "GetSubZoneText", "GetAreaText", "GetMinimapZoneText"
    }) do
        wrap_global(name, function (results)
            results[1] = translate_glossary(results[1], "translate_zone", "zone")
        end)
    end

    wrap_global("TaxiNodeName", function (results)
        if type(results[1]) == "string" and options.can_lookup("translate_zone") then
            local value = entries.translate_taxi_node_name(results[1])
            if options.can_translate("translate_zone") then
                results[1] = value
            end
        end
    end)
end

translation.prepare = function ()
    if translation.prepared then
        return
    end
    translation.prepared = true
    prepare_quest_hooks()
    prepare_gossip_hooks()
    prepare_zone_hooks()
end
