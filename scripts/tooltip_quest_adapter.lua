local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local translation = addon_table.use("translation")
local hooks = addon_table.use("translation_hooks").bind("quest-tooltips")
local adapter = addon_table.use("tooltip_quest_adapter")
local dependencies
local blob_cache = setmetatable({}, { __mode = "k" })
local BLOB_RUNTIME_FLAGS = {
    record_runtime = false,
    verify_after_apply = false,
    reapply_cached = true,
}

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip quest dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip quest adapter is not configured")
end

adapter.resolve_blob_id = function (tooltip)
    local contract = deps()
    if not options.can_translate("translate_quest") then return nil end
    local title, region = contract.tooltip_line(tooltip, "Left", 1)
    local claim = region and runtime.get(region)
    if claim and claim.owner == "quest-tooltip" and title == claim.translated then
        title = claim.source
    end
    title = contract.safe_string(title)
    if not title or not entries.quest_title_ids
        or not entries.quest_title_ids[title] then return nil end
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = ok and contract.safe_number(count) or nil
    if not count then return nil end
    -- Resolve the hovered quest, not the tracked/highlighted quest on the pin.
    -- A title can be ambiguous; its native task disambiguates it in the catalog.
    for index = 2, math.min(count, contract.max_lines) do
        local source = contract.tooltip_line(tooltip, "Left", index)
        source = contract.safe_string(source)
        local task = source and source:match("^%s*%-?%s*%d+%s*/%s*%d+%s+(.+)$")
        if task then
            local id = entries.lookup_quest_id_for_task(title, task)
            if id then return id, title end
        end
    end
    return entries.lookup_quest_id_for_task(title), title
end

adapter.translate_blob = function (tooltip, id, native_title)
    local contract = deps()
    if tooltip.uaForeverShowOriginal or not options.can_translate("translate_quest") then
        return false
    end
    local entry = entries.get_entry("quest", id)
    if not entry then return false end
    local cache = blob_cache[tooltip]
    if not cache or cache.id ~= id then
        cache = { id = id, title = contract.make_text(entry[1], tooltip), rows = {} }
        blob_cache[tooltip] = cache
    end
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = ok and contract.safe_number(count) or nil
    if not count then return false end
    local applied = false
    for index = 1, math.min(count, contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        source = contract.safe_string(source)
        if index == 1 then source = contract.safe_string(native_title) or source end
        local claim = region and runtime.get(region)
        if claim and claim.owner == "quest-tooltip" and source == claim.translated then
            source = claim.source
        end
        if source and region then
            local row = cache.rows[index]
            if not row or row.source ~= source then
                local translated = index == 1 and cache.title or nil
                if index > 1 then
                    local dash, objective = source:match("^(%s*%-%s*)(.+)$")
                    local raw = objective or source
                    local task_ok, value = pcall(entries.translate_quest_objective_task, raw, id)
                    if task_ok and type(value) == "string" and value ~= raw then
                        translated = (dash or "") .. value
                    end
                end
                -- One cache entry per visible row, including a failed lookup.
                row = { source = source, translated = translated or false }
                cache.rows[index] = row
            end
            if row.translated then
                applied = contract.set_translation(tooltip, region, source,
                    row.translated, index == 1 and "quest.name" or "quest.objective:" .. index,
                    index == 1 and "quest" or nil, "quest-tooltip",
                    nil, false, true, nil, nil, nil, BLOB_RUNTIME_FLAGS) or applied
            end
        end
    end
    return applied
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

adapter.add = function (tooltip, id, skip_title, data)
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
        -- Quest-link TooltipData in 70170 contains title, a blank spacer,
        -- then the native objective. It also works for quests outside the log.
        -- Use only this verified Quest layout; map and NPC rows are tasks.
        local quest_type = _G.Enum and _G.Enum.TooltipDataType
            and _G.Enum.TooltipDataType.Quest
        if type(data) == "table" and quest_type
            and contract.safe_number(data.type) == quest_type
            and contract.safe_number(data.id) == id
            and type(data.lines) == "table" then
            local spacer, objective = data.lines[2], data.lines[3]
            if type(spacer) == "table" and type(objective) == "table"
                and contract.safe_string(spacer.leftText) == " "
                and contract.safe_number(objective.type) == 0 then
                original_objective = contract.safe_string(objective.leftText)
                    or original_objective
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
                        entries.translate_quest_objective_task, raw, id, original_objective)
                    if ok and type(value) == "string" and value ~= raw then
                        translated = prefix .. value
                    end
                end
                if not translated then
                    local ok, value = pcall(
                        entries.translate_quest_objective_task, source, id, original_objective)
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

local function after_blob_tooltip(pin)
    local contract = deps()
    local tooltip = _G.GameTooltip
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= pin then return end
    local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
    if not shown_ok or runtime.is_secret_value(shown) or not shown then return end
    local id, native_title = adapter.resolve_blob_id(tooltip)
    if not id then return end
    local key = contract.session_key("quest", id)
    contract.begin_session(tooltip, key)
    tooltip.uaForeverKind = "quest"
    tooltip.uaForeverID = id
    tooltip.uaForeverReservedFirst = 2
    contract.cancel_finalize(tooltip)
    if adapter.translate_blob(tooltip, id, native_title) then
        tooltip.uaForeverKey = key
    end
end

local function hook_blob_pins(map)
    if not map or type(map.EnumeratePinsByTemplate) ~= "function" then return false end
    return pcall(function ()
        -- 70124 uses a single permanent blob pin. Never walk other templates
        -- or canvas descendants, and never enumerate from OnUpdate.
        for pin in map:EnumeratePinsByTemplate("QuestBlobPinTemplate") do
            hooks.region(pin, "UpdateTooltip", after_blob_tooltip)
        end
    end)
end

adapter.prepare = function ()
    local contract = deps()
    local map = _G.WorldMapFrame
    if map then
        -- XML mixins are copied onto frames: hook existing and future pins,
        -- not only the prototype. Hook registration is deduplicated.
        hooks.region(map, "AcquirePin", function (self, template)
            if not runtime.is_secret_value(template) and template == "QuestBlobPinTemplate" then
                hook_blob_pins(self)
            end
        end)
        hooks.once("quest-blob-existing:" .. tostring(map), function ()
            return hook_blob_pins(map)
        end)
    end
    hooks.once("event:MapCanvas.QuestPin.OnEnter", function ()
        local registry = _G.EventRegistry
        if not registry or type(registry.RegisterCallback) ~= "function" then return false end
        return pcall(registry.RegisterCallback, registry, "MapCanvas.QuestPin.OnEnter",
            function (_, _, id)
                id = contract.safe_number(id)
                if id and _G.GameTooltip then
                    contract.process(_G.GameTooltip, { id = id }, "quest")
                end
            end, adapter)
    end)
    hooks.global("GameTooltip_AddQuest", function (self)
        local id = self and contract.safe_number(self.questID)
        if id then contract.process(_G.GameTooltip, { id = id }, "quest") end
    end)
    hooks.global("QuestMapLogTitleButton_OnEnter", adapter.translate_map_button)
    hooks.region(_G.QuestPinMixin, "OnMouseEnter", function (self)
        local getter = self and self.GetQuestID
        if type(getter) ~= "function" then return end
        local ok, id = pcall(getter, self)
        id = ok and contract.safe_number(id) or nil
        if id then contract.process(_G.GameTooltip, { id = id }, "quest") end
    end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowBountyTooltip", function (self, index)
        local data = self.bounties and self.bounties[index]
        local id = data and contract.safe_number(data.questID)
        if id then contract.process(_G.GameTooltip, { id = id }, "quest") end
    end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowLockedByQuestTooltip", function (self)
        local id = contract.safe_number(self.lockedQuestID)
        if id then
            contract.process(_G.GameTooltip, { id = id, uaForeverSkipTitle = true }, "quest")
        end
    end)
    hooks.region(_G.RecruitActivityButtonMixin, "OnEnter", function (self)
        local id = self and self.activityInfo and contract.safe_number(self.activityInfo.rewardQuestID)
        local tooltip = _G.EmbeddedItemTooltip
        if not id or not tooltip or type(tooltip.GetOwner) ~= "function" then return end
        local ok, owner = pcall(tooltip.GetOwner, tooltip)
        if ok and owner == self and adapter.visible_title_matches(tooltip, id, self.questName) then
            contract.process(tooltip, { id = id }, "quest")
        end
    end)
    hooks.global("CallingPOI_OnEnter", function (pin)
        local id = pin and contract.safe_number(pin.questID)
        if id and _G.GameTooltip and adapter.visible_title_matches(_G.GameTooltip, id) then
            contract.process(_G.GameTooltip, { id = id }, "quest")
        end
    end)
    hooks.region(_G.CovenantCallingQuestMixin, "UpdateTooltipQuestActive", function (self)
        local id = self and self.calling and contract.safe_number(self.calling.questID)
        if id and _G.GameTooltip and adapter.visible_title_matches(_G.GameTooltip, id) then
            contract.process(_G.GameTooltip, { id = id }, "quest")
        end
    end)
end
