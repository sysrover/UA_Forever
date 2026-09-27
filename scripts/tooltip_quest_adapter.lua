local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local translation = addon_table.use("translation")
local adapter = addon_table.use("tooltip_quest_adapter")
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip quest dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip quest adapter is not configured")
end

adapter.translate_embedded = function (tooltip)
    local contract = deps()
    if not options.can_translate("translate_quest")
        or tooltip.uaForeverShowOriginal
        or type(entries.lookup_quest_id_for_task) ~= "function" then
        return false
    end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or contract.max_lines
    local applied, quest_id = false, nil
    for index = 2, math.min(count, contract.max_lines) do
        local visible, region = contract.tooltip_line(tooltip, "Left", index)
        local claim = region and runtime.get(region)
        local source = claim and claim.owner == "quest-tooltip"
            and claim.source or visible
        local normalized = contract.normalized_text(source)
        local id
        if normalized and entries.quest_title_ids
            and entries.quest_title_ids[normalized] then
            for next_index = index + 1, math.min(index + 4, count) do
                local next_text = contract.tooltip_line(
                    tooltip, "Left", next_index)
                local next_line = contract.normalized_text(next_text)
                local next_task = next_line and next_line:match(
                    "^%-?%s*%d+%s*/%s*%d+%s+(.+)$")
                if next_task then
                    id = entries.lookup_quest_id_for_task(normalized, next_task)
                    if id then break end
                end
            end
        end
        if id and region then
            local entry = entries.get_entry("quest", id)
            local title = entry and contract.make_text(entry[1], tooltip)
            quest_id = entry and id or nil
            if title and title ~= source
                and not (claim and visible == claim.translated) then
                applied = contract.set_translation(tooltip, region, source,
                    title, "npc.quest.name:" .. index, "quest",
                    "quest-tooltip") or applied
            end
        elseif quest_id and contract.safe_string(source) and region then
            local dash, objective = source:match(
                "^(%s*%-%s*)(%d+%s*/%s*%d+%s+.+)$")
            if not objective then
                dash, objective = source:match(
                    "^(%s*)(%d+%s*/%s*%d+%s+.+)$")
            end
            if objective then
                local normalized_objective = contract.normalized_text(objective)
                local ok, translated = pcall(
                    entries.translate_quest_objective_task,
                    normalized_objective, quest_id)
                if ok and type(translated) == "string"
                    and translated ~= normalized_objective
                    and not (claim and visible == claim.translated) then
                    applied = contract.set_translation(tooltip, region, source,
                        dash .. translated,
                        "npc.quest.objective:" .. index, nil,
                        "quest-tooltip") or applied
                end
            elseif normalized and entries.quest_title_ids
                and entries.quest_title_ids[normalized] then
                quest_id = nil
            end
        end
    end
    return applied
end

adapter.add = function (tooltip, id, skip_title)
    local contract = deps()
    if not options.can_lookup("translate_quest") then return false end
    local entry = entries.get_entry("quest", id)
    if not entry or not options.can_translate("translate_quest") then
        return false
    end
    tooltip.uaForeverReservedFirst = skip_title and 1 or 2
    local native_title, title_region = contract.tooltip_line(
        tooltip, "Left", 1)
    local original_getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(original_getter) == "function" then
        local ok, original_title = pcall(original_getter, id)
        original_title = ok and contract.safe_string(original_title) or nil
        if original_title then native_title = original_title end
    end
    local title = contract.make_text(entry[1], tooltip)
    local applied = false
    if not skip_title and title and title_region then
        applied = contract.set_translation(tooltip, title_region,
            native_title, title, "quest.name", "quest", "quest-tooltip")
    end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    if count then
        local objective_text = type(entry[3]) == "string"
            and contract.make_text(entry[3], tooltip)
        local original_objective
        local get_index = _G.C_QuestLog and _G.C_QuestLog.GetLogIndexForQuestID
        local get_text = translation.original
            and translation.original["GetQuestLogQuestText"]
            or _G.GetQuestLogQuestText
        if type(get_index) == "function" and type(get_text) == "function" then
            local index_ok, log_index = pcall(get_index, id)
            if index_ok and type(log_index) == "number" then
                local text_ok, _, value = pcall(get_text, log_index)
                value = text_ok and contract.safe_string(value) or nil
                if value then original_objective = value end
            end
        end
        local prefix = type(_G.QUEST_DASH) == "string" and _G.QUEST_DASH or ""
        for index = 2, math.min(count, contract.max_lines) do
            local source, region = contract.tooltip_line(tooltip, "Left", index)
            source = contract.safe_string(source)
            if source and region then
                local translated
                if objective_text and original_objective
                    and source == original_objective then
                    translated = objective_text
                elseif objective_text and original_objective and prefix ~= ""
                    and source == prefix .. original_objective then
                    translated = prefix .. objective_text
                elseif prefix ~= "" and source:sub(1, #prefix) == prefix then
                    local raw = source:sub(#prefix + 1)
                    local ok, value = pcall(
                        entries.translate_quest_objective_task, raw, id)
                    if ok and type(value) == "string" and value ~= raw then
                        translated = prefix .. value
                    end
                end
                if not translated then
                    local ok, value = pcall(
                        entries.translate_quest_objective_task, source, id)
                    if ok and type(value) == "string" and value ~= source then
                        translated = value
                    end
                end
                if translated and translated ~= source then
                    applied = contract.set_translation(tooltip, region, source,
                        translated, "quest.objective:" .. index, nil,
                        "quest-tooltip") or applied
                end
            end
        end
    end
    return contract.rewrite_generic(
        tooltip, nil, tooltip.uaForeverReservedFirst) > 0 or applied
end

adapter.visible_title_matches = function (tooltip, id, cached)
    local contract = deps()
    local current = contract.tooltip_line(tooltip, "Left", 1)
    current = contract.safe_string(current)
    if not current then return false end
    cached = contract.safe_string(cached)
    if cached and current == cached then return true end
    local quest_api = _G.C_QuestLog
    local get_title = quest_api and quest_api.GetTitleForQuestID
    local original = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
    local function matches(getter)
        if type(getter) == "function" then
            local ok, title = pcall(getter, id)
            title = ok and contract.safe_string(title) or nil
            return title and current == title
        end
    end
    if matches(get_title) or matches(original) then return true end
    local task_api = _G.C_TaskQuest
    if task_api and type(task_api.GetQuestInfoByQuestID) == "function" then
        local ok, title = pcall(task_api.GetQuestInfoByQuestID, id)
        title = ok and contract.safe_string(title) or nil
        if title and current == title then return true end
    end
    return false
end

adapter.translate_map_button = function (button)
    local tooltip = _G.GameTooltip
    local id = button and button.questID
    if not tooltip or type(id) ~= "number" then return end
    deps().process(tooltip, { id = id }, "quest")
end
