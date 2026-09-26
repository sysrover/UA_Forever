local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local auto_scan = addon_table.use("auto_scan")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local scanner = addon_table.use("scanner")
local strings = addon_table.use("strings")
local scheduler = addon_table.use("translation_scheduler")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
end

local pending_menus = {}

local function scalar_key_part(value)
    local value_type = type(value)
    if (value_type == "string" or value_type == "number") and not is_secret(value) then
        local text = tostring(value)
        return text ~= "" and text or nil
    end
    return nil
end

local function safe_key_part(value)
    local part = scalar_key_part(value)
    if part then return part end
    local value_type = type(value)
    if value_type ~= "table" then return nil end

    for _, field in ipairs({ "ID", "id", "categoryID", "categoryId" }) do
        local ok, field_value = pcall(function () return value[field] end)
        local field_part = ok and scalar_key_part(field_value)
        if field_part then return field_part end
    end
    for _, method in ipairs({ "GetID", "GetCategoryID" }) do
        local ok_method, getter = pcall(function () return value[method] end)
        if ok_method and type(getter) == "function" then
            local ok, result = pcall(getter, value)
            local result_part = ok and scalar_key_part(result)
            if result_part then return result_part end
        end
    end
    return nil
end

local function menu_store()
    if not UA_ForeverDB then return nil end
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    UA_ForeverDB.scan.menus = UA_ForeverDB.scan.menus or {}
    return UA_ForeverDB.scan.menus
end

scanner.frame_key = function (frame)
    if not frame then return nil end
    local ok_method, getter = pcall(function () return frame.GetDebugName end)
    local ok, name
    if ok_method and type(getter) == "function" then
        ok, name = pcall(getter, frame)
    end
    if not ok or type(name) ~= "string" or is_secret(name) or name == "" then
        ok_method, getter = pcall(function () return frame.GetName end)
        if ok_method and type(getter) == "function" then
            ok, name = pcall(getter, frame)
        end
    end
    if not ok or type(name) ~= "string" or is_secret(name) or name == "" then return nil end
    return "frame:" .. name
end

local function collect_visible_text(frame, seen, depth, values)
    if not frame or seen[frame] or depth > 20 then return end
    seen[frame] = true

    local ok_method, get_regions = pcall(function () return frame.GetRegions end)
    if ok_method and type(get_regions) == "function" then
        local ok, regions = pcall(function () return { get_regions(frame) } end)
        if ok then
            for _, region in ipairs(regions) do
                local text_ok, get_text = pcall(function () return region.GetText end)
                if text_ok and type(get_text) == "function" then
                    local value_ok, value = pcall(get_text, region)
                    if value_ok and type(value) == "string" and not is_secret(value) then
                        value = value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                            :gsub("|T.-|t", ""):gsub("|A.-|a", "")
                            :gsub("%s+", " "):match("^%s*(.-)%s*$")
                        if value ~= "" and #value <= 200 then values[value] = true end
                    end
                end
            end
        end
    end

    local children_ok, get_children = pcall(function () return frame.GetChildren end)
    if children_ok and type(get_children) == "function" then
        local ok, children = pcall(function () return { get_children(frame) } end)
        if ok then
            for _, child in ipairs(children) do
                local shown_ok, shown = pcall(child.IsShown, child)
                if shown_ok and shown then collect_visible_text(child, seen, depth + 1, values) end
            end
        end
    end
end

scanner.frame_text_key = function (prefix, frame)
    if not frame then return nil end
    local values = {}
    collect_visible_text(frame, {}, 1, values)

    local sorted = {}
    for value in pairs(values) do sorted[#sorted + 1] = value end
    if #sorted == 0 then return scanner.frame_key(frame) end
    table.sort(sorted)

    local hash = 5381
    for _, value in ipairs(sorted) do
        for index = 1, #value do
            hash = (hash * 33 + value:byte(index)) % 2147483647
        end
        hash = (hash * 33 + 31) % 2147483647
    end
    return tostring(prefix) .. ":" .. string.format("%08x", hash)
end

scanner.menu_key = function (prefix, value, fallback_frame)
    local part = safe_key_part(value)
    if part then return tostring(prefix) .. ":" .. part end
    return scanner.frame_key(fallback_frame) or tostring(prefix)
end

scanner.menu_count = function ()
    local count = 0
    for _ in pairs(menu_store() or {}) do count = count + 1 end
    return count
end

scanner.menu_was_scanned = function (key)
    local menus = menu_store()
    return type(key) == "string" and menus and menus[key] ~= nil
end

scanner.schedule_menu_capture = function (key, callback, frame)
    if type(key) ~= "string" or key == "" or pending_menus[key] or scanner.menu_was_scanned(key) then
        return false
    end
    pending_menus[key] = true

    local function capture()
        pending_menus[key] = nil
        if scanner.menu_was_scanned(key) then return end

        local stats = frame and strings.capture_frame(frame, frame == _G.SettingsPanel)
            or strings.capture_visible_ui()
        local menus = menu_store()
        if not menus then return end
        menus[key] = {
            firstSeen = type(_G.date) == "function" and _G.date("!%Y-%m-%dT%H:%M:%SZ") or nil,
            frames = stats.frames or 0,
            captured = stats.captured or 0,
            new = stats.new or 0,
            unique = stats.unique or 0,
        }
        if type(callback) == "function" then callback(key, stats) end
    end

    scheduler.request("menu-capture:" .. key, nil, capture, 0.35)
    return true
end

local function resolve_path(path)
    local value = _G
    for part in path:gmatch("[^%.]+") do
        value = value and value[part]
    end
    return value
end

local function available(path)
    return resolve_path(path) ~= nil
end

local function normalize(text)
    if type(text) ~= "string" or is_secret(text) then return nil end
    return text:lower():gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function record_api(report, path)
    report.apis[path] = available(path)
end

local function record_frame(report, path)
    report.frames[path] = available(path)
end

local function sample_table(report, kind, source, get_name, limit)
    local result = { checked = 0, matched = 0, mismatched = 0, unavailable = 0, examples = {} }
    report.samples[kind] = result
    if type(source) ~= "table" or type(get_name) ~= "function" then return end

    for id, entry in pairs(source) do
        if result.checked >= limit then break end
        if type(id) == "number" and type(entry) == "table" and type(entry.en) == "string" then
            local ok, actual = pcall(get_name, id)
            result.checked = result.checked + 1
            if not ok or type(actual) ~= "string" or is_secret(actual) or actual == "" then
                result.unavailable = result.unavailable + 1
            elseif normalize(actual) == normalize(entry.en) then
                result.matched = result.matched + 1
            else
                result.mismatched = result.mismatched + 1
                if #result.examples < 8 then
                    result.examples[#result.examples + 1] = { id = id, expected = entry.en, actual = actual }
                end
            end
        end
    end
end

local function collect_unit_id(unit)
    local id = utils.npc_id_from_unit_id(unit)
    if not id then return end
    local entry = entries.get_entry("npc", id)
    dev_log.record_id("npcs", id, UnitName(unit), entry ~= nil)
end

local function collect_quest_log_ids()
    local get_count = C_QuestLog and C_QuestLog.GetNumQuestLogEntries
    local get_info = translation.original["C_QuestLog.GetInfo"]
        or (C_QuestLog and C_QuestLog.GetInfo)
    local get_text = translation.original["GetQuestLogQuestText"] or _G.GetQuestLogQuestText
    local get_objectives = translation.original["C_QuestLog.GetQuestObjectives"]
        or (C_QuestLog and C_QuestLog.GetQuestObjectives)
    if type(get_count) ~= "function" or type(get_info) ~= "function" then return 0 end

    local ok, count = pcall(get_count)
    if not ok or type(count) ~= "number" then return 0 end

    local found = 0
    for index = 1, count do
        local info_ok, info = pcall(get_info, index)
        if info_ok and info and info.questID and not info.isHeader then
            local entry = entries.get_entry("quest", info.questID)
            dev_log.record_id("quests", info.questID, info.title, entry ~= nil)
            local fields = {}
            if type(get_text) == "function" then
                local text_ok, description, objective = pcall(get_text, index)
                if text_ok then
                    fields.description = description
                    fields.objective = objective
                end
            end
            if type(get_objectives) == "function" then
                local objectives_ok, objectives = pcall(get_objectives, info.questID)
                if objectives_ok and type(objectives) == "table" then
                    fields.tasks = {}
                    for _, objective in ipairs(objectives) do
                        if type(objective) == "table" then
                            fields.tasks[#fields.tasks + 1] = objective.text
                        end
                    end
                end
            end
            dev_log.record_quest_text(info.questID, fields)
            local missing_fields = {}
            local scan_fields = { title = info.title }
            missing_fields.title = not entry or type(entry[1]) ~= "string"
                or entry[1] == "" or entry[1] == info.title
            for _, field in ipairs({ { "description", 2 }, { "objective", 3 } }) do
                local key, index = field[1], field[2]
                scan_fields[key] = fields[key]
                missing_fields[key] = not entry or type(entry[index]) ~= "string"
                    or entry[index] == "" or entry[index] == fields[key]
            end
            for task_index, task in ipairs(fields.tasks or {}) do
                local key = "task" .. task_index
                scan_fields[key] = task
                local ok_task, translated_task = pcall(
                    entries.translate_quest_objective_task, task, info.questID)
                missing_fields[key] = not ok_task or translated_task == task
            end
            auto_scan.record_quest(info.questID, scan_fields, missing_fields)
            found = found + 1
        end
    end
    return found
end


scanner.capture_quest_log = collect_quest_log_ids

local current_book_id
local current_book_name

scanner.note_book = function (...)
    for index = 1, select("#", ...) do
        local value = select(index, ...)
        if type(value) == "number" and value > 0 and not is_secret(value) then
            current_book_id = value
            break
        end
    end
    if type(_G.ItemTextGetItem) == "function" then
        local ok, name, id = pcall(_G.ItemTextGetItem)
        if ok then
            if type(name) == "string" and name ~= "" and not is_secret(name) then
                current_book_name = name
            end
            if type(id) == "number" and id > 0 and not is_secret(id) then
                current_book_id = id
            end
        end
    end
    if not current_book_id and current_book_name and entries.lookup_id then
        current_book_id = entries.lookup_id("item", current_book_name)
    end
    local legacy_id = utils.get_currently_viewed_book_id
        and utils.get_currently_viewed_book_id() or 0
    if type(legacy_id) == "number" and legacy_id > 0 then
        current_book_id = legacy_id
    end
end

scanner.begin_book = function (...)
    current_book_id = nil
    current_book_name = nil
    scanner.note_book(...)
end

scanner.capture_book_page = function ()
    scanner.note_book()
    if type(_G.ItemTextGetText) ~= "function" then return end
    local text_ok, source = pcall(_G.ItemTextGetText)
    if not text_ok or type(source) ~= "string" or source == ""
        or is_secret(source) then return end
    local page = 1
    if type(_G.ItemTextGetPage) == "function" then
        local page_ok, value = pcall(_G.ItemTextGetPage)
        if page_ok and type(value) == "number" and value > 0
            and not is_secret(value) then page = value end
    end
    local identity = current_book_id or current_book_name
        or (type(utils.get_text_hash) == "function" and utils.get_text_hash(source))
    if not identity then return end
    local translated
    local book = current_book_id and addon_table.book
        and addon_table.book[current_book_id]
    if type(book) == "table" and type(book[page]) == "string" then
        translated = book[page]
    end
    local visible
    local region = _G.ItemTextPageText
    local visible_ok, value = region and pcall(region.GetText, region)
    if visible_ok and type(value) == "string" and not is_secret(value) then
        visible = value
    end
    if type(auto_scan.record_book) == "function" then
        auto_scan.record_book(identity, page, source, visible or source,
            translated, current_book_name)
    end
end

local function greeting_region_text(region)
    if not region then return nil end
    local ok, value = pcall(region.GetText, region)
    if ok and type(value) == "string" and value ~= "" and not is_secret(value) then
        return value
    end
end

local function valid_quest_id(value)
    return type(value) == "number" and value > 0 and not is_secret(value)
        and value or nil
end

local function quest_id_from_data(value)
    if type(value) ~= "table" then return nil end
    local ok, id = pcall(function () return value.questID or value.questId end)
    return ok and valid_quest_id(id) or nil
end

local function greeting_quest_id(button)
    if not button then return nil end
    local ok, id = pcall(function () return button.questID or button.questId end)
    id = ok and valid_quest_id(id) or nil
    if id then return id end

    for _, field in ipairs({ "info", "data", "questInfo", "elementData" }) do
        local field_ok, value = pcall(function () return button[field] end)
        id = field_ok and quest_id_from_data(value) or nil
        if id then return id end
    end
    for _, method_name in ipairs({ "GetElementData", "GetData" }) do
        local method_ok, method = pcall(function () return button[method_name] end)
        if method_ok and type(method) == "function" then
            local data_ok, value = pcall(method, button)
            id = data_ok and quest_id_from_data(value) or nil
            if id then return id end
        end
    end

    local method_ok, method = pcall(function () return button.GetID end)
    if not method_ok or type(method) ~= "function" then return nil end
    local index_ok, index = pcall(method, button)
    if not index_ok or not valid_quest_id(index) then return nil end
    local active_ok, active = pcall(function () return button.isActive end)
    active = active_ok and active or nil
    if (active == 1 or active == true or active == nil)
        and type(_G.GetActiveQuestID) == "function" then
        local found, value = pcall(_G.GetActiveQuestID, index)
        id = found and valid_quest_id(value) or nil
        if id then return id end
    end
    if (active == 0 or active == false or active == nil)
        and type(_G.GetAvailableQuestInfo) == "function" then
        local found, _, _, _, _, value = pcall(_G.GetAvailableQuestInfo, index)
        id = found and valid_quest_id(value) or nil
        if id then return id end
    end
end

local function quest_greeting_snapshot()
    local panel = _G.QuestFrameGreetingPanel
    if not panel then return nil end
    local snapshot = {
        greeting_region = _G.GreetingText,
        greeting_source = greeting_region_text(_G.GreetingText),
        npc_id = utils.npc_id_from_unit_id("npc")
            or utils.npc_id_from_unit_id("questnpc"),
        quests = {},
    }
    if type(_G.GetGreetingText) == "function" then
        local ok, value = pcall(_G.GetGreetingText)
        if ok and type(value) == "string" and value ~= ""
            and not is_secret(value) then snapshot.greeting_source = value end
    end
    local pool = panel.titleButtonPool
    if pool and type(pool.EnumerateActive) == "function" then
        for button in pool:EnumerateActive() do
            local region_ok, region = pcall(button.GetFontString, button)
            region = region_ok and region or nil
            local title = greeting_region_text(region)
            if title then
                snapshot.quests[#snapshot.quests + 1] = {
                    button = button, region = region,
                    id = greeting_quest_id(button), source = title,
                }
            end
        end
    end
    return snapshot
end

scanner.capture_quest_greeting = function (snapshot, verify)
    snapshot = type(snapshot) == "table" and snapshot or quest_greeting_snapshot()
    if not snapshot then return end

    local visible = greeting_region_text(snapshot.greeting_region)
    local source = snapshot.greeting_source
    local npc_id = snapshot.npc_id or utils.npc_id_from_unit_id("npc")
        or utils.npc_id_from_unit_id("questnpc")
    if npc_id and source and visible then
        local translated = entries.get_gossip_text_for_npc_talk(npc_id, source)
        auto_scan.record_visible_gossip(npc_id, source, visible,
            options.can_translate("translate_gossip"))
        if verify then
            auto_scan.verify_surface({
                surface = "quest-greeting", owner = "quest-greeting",
                slot = "GreetingText", source = source,
                translation = translated, visible = visible,
                expected = options.can_translate("translate_gossip"),
            })
        end
    end

    for _, quest in ipairs(snapshot.quests or {}) do
        local title = greeting_region_text(quest.region)
        local id = quest.id or greeting_quest_id(quest.button)
        if id and quest.source and title then
            local entry = entries.get_entry("quest", id)
            local source_title = entry and entry.en or quest.source
            local translated = entry and entry[1]
            local expected = options.can_translate("translate_gossip", "translate_quest")
                and options.translate_name("quest")
            auto_scan.record_visible_quest_title(id, source_title, title, expected)
            if verify then
                auto_scan.verify_surface({
                    surface = "quest-greeting", owner = "quest-greeting",
                    slot = "quest:" .. id .. ".name", source = source_title,
                    translation = translated, visible = title, expected = expected,
                })
            end
        end
    end
end

scanner.schedule_quest_greeting_capture = function ()
    local snapshot = quest_greeting_snapshot()
    if not snapshot then return end
    scheduler.request("quest-greeting-capture", nil, function ()
        scanner.capture_quest_greeting(snapshot)
    end)
    scheduler.request("quest-greeting-capture-retry", nil, function ()
        scanner.capture_quest_greeting(snapshot)
    end, 0.2)
    scheduler.request("quest-greeting-capture-late", nil, function ()
        scanner.capture_quest_greeting(snapshot, true)
    end, 0.5)
end

local current_quest_fields = {
    { key = "title",       index = 1, getter = "GetTitleText" },
    { key = "description", index = 2, getter = "GetQuestText" },
    { key = "objective",   index = 3, getter = "GetObjectiveText" },
    { key = "progress",    index = 4, getter = "GetProgressText" },
    { key = "reward",      index = 5, getter = "GetRewardText" },
}

local visible_quest_fields = {
    QUEST_DETAIL = { title = true, description = true, objective = true },
    QUEST_PROGRESS = { title = true, progress = true },
    QUEST_COMPLETE = { title = true, reward = true },
}

local visible_quest_regions = {
    title = function (event)
        return event == "QUEST_PROGRESS" and _G.QuestProgressTitleText
            or _G.QuestInfoTitleHeader
    end,
    description = function () return _G.QuestInfoDescriptionText end,
    objective = function () return _G.QuestInfoObjectivesText end,
    progress = function () return _G.QuestProgressText end,
    reward = function () return _G.QuestInfoRewardText end,
}

local function original_quest_text(getter_name)
    local getter = translation.original[getter_name] or _G[getter_name]
    if type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter)
    if not ok or type(value) ~= "string" or is_secret(value) then return nil end
    if value == "" then return nil end
    return value
end

-- Quest detail/progress/reward getters are only populated while the matching
-- Blizzard quest panel is open. Capture them on that panel's event instead of
-- waiting for a broad compatibility scan. Always call the pristine getters so
-- SavedVariables receives the English source, never UA_Forever's replacement.
scanner.capture_current_quest = function (event)
    local get_id = translation.get_current_quest_id
    local id = type(get_id) == "function" and get_id() or nil
    if not id or id <= 0 then return false end

    local entry = entries.get_entry("quest", id)
    local visible = visible_quest_fields[event] or {}
    local captured = {}
    local missing_fields = {}
    local visible_translation_missing = entry == nil
    local title

    for _, field in ipairs(current_quest_fields) do
        local source = original_quest_text(field.getter)
        local translated = entry and type(entry[field.index]) == "string"
            and not is_secret(entry[field.index]) and entry[field.index] ~= ""
            and entry[field.index] ~= source

        if field.key == "title" then
            title = source
        end
        if source and not translated then
            captured[field.key] = source
        end
        if visible[field.key] then
            missing_fields[field.key] = not translated
            if not translated then
                visible_translation_missing = true
            end
        end
    end

    if not title then
        local title_getter = translation.original["C_QuestLog.GetTitleForQuestID"]
            or (C_QuestLog and C_QuestLog.GetTitleForQuestID)
        if type(title_getter) == "function" then
            local ok, value = pcall(title_getter, id)
            if ok and type(value) == "string" and not is_secret(value) and value ~= "" then
                title = value
                if not entry or type(entry[1]) ~= "string" or entry[1] == ""
                    or entry[1] == value then
                    captured.title = value
                end
            end
        end
    end

    dev_log.record_id("quests", id, title, not visible_translation_missing)
    dev_log.record_quest_text(id, captured, missing_fields)
    for _, field in ipairs(current_quest_fields) do
        if visible[field.key] then
            local region = visible_quest_regions[field.key]
                and visible_quest_regions[field.key](event)
            local shown = greeting_region_text(region)
            local source = original_quest_text(field.getter)
            if shown and source then
                auto_scan.record_visible_quest_field(id, field.key, source, shown,
                    options.can_translate("translate_quest")
                        and (field.key ~= "title" or options.translate_name("quest")))
            end
        end
    end
    return visible_translation_missing
end

local function collect_current_quest_rewards()
    if type(_G.GetQuestItemLink) ~= "function" then return 0 end
    local found = 0
    for _, reward_type in ipairs({ "choice", "reward", "required" }) do
        for index = 1, 20 do
            local ok, link = pcall(GetQuestItemLink, reward_type, index)
            if not ok or type(link) ~= "string" or is_secret(link) then break end
            local id = utils.item_id_from_link(link)
            if id then
                local entry = entries.get_entry("item", id)
                dev_log.record_id("items", id, link:match("%[(.-)%]"), entry ~= nil)
                found = found + 1
            end
        end
    end
    return found
end

local function scanned_id_counts()
    local result = {}
    local groups = UA_ForeverDB and UA_ForeverDB.scan and UA_ForeverDB.scan.ids or {}
    for group, records in pairs(groups) do
        local total, missing = 0, 0
        for _, record in pairs(records) do
            total = total + 1
            if type(record) == "table" and record.translated == false then missing = missing + 1 end
        end
        result[group] = { total = total, missing = missing }
    end
    return result
end

local function quest_source()
    local result = {}
    for id, entry in pairs(addon_table.quest_faction or {}) do result[id] = entry end
    for id, entry in pairs(addon_table.quest_both or {}) do result[id] = entry end
    return result
end

scanner.catalog_status = function (version, build)
    local catalog = addon_table.forever_client_catalog
    local catalog_build = catalog and catalog.build
    local client_build = type(version) == "string" and type(build) == "string"
        and version .. "." .. build or nil
    if type(catalog_build) ~= "string" or not client_build then return nil end
    return { build = catalog_build, matches = catalog_build == client_build }
end

scanner.run = function (capture_ui)
    local version, build, build_date, interface = GetBuildInfo()
    local report = {
        timestamp = _G.date("!%Y-%m-%dT%H:%M:%SZ"),
        client = { version = version, build = build, buildDate = build_date, interface = interface },
        catalog = scanner.catalog_status(version, build),
        project = { id = WOW_PROJECT_ID, mainline = WOW_PROJECT_MAINLINE },
        apis = {},
        frames = {},
        samples = {},
        collected = {},
    }

    if capture_ui ~= false then report.ui = strings.capture_visible_ui() end

    report.collected.questLog = collect_quest_log_ids()
    report.collected.questRewards = collect_current_quest_rewards()
    for _, unit in ipairs({ "target", "npc", "questnpc" }) do collect_unit_id(unit) end

    local current_quest = translation.get_current_quest_id and translation.get_current_quest_id()
    if current_quest and current_quest > 0 then
        local title_getter = translation.original["C_QuestLog.GetTitleForQuestID"]
            or (C_QuestLog and C_QuestLog.GetTitleForQuestID)
        local ok, title = pcall(title_getter or function () end, current_quest)
        local entry = entries.get_entry("quest", current_quest)
        dev_log.record_id("quests", current_quest, ok and title or nil, entry ~= nil)
    end

    for _, path in ipairs({
        "C_QuestLog.GetInfo", "C_QuestLog.GetTitleForQuestID", "C_QuestLog.GetQuestObjectives",
        "GetTitleText", "GetQuestText", "GetObjectiveText", "GetProgressText", "GetRewardText",
        "GetQuestLogQuestText", "C_GossipInfo.GetText", "C_GossipInfo.GetOptions",
        "C_Map.GetMapInfo", "C_Item.GetItemNameByID", "C_Spell.GetSpellInfo",
        "C_SkillInfo.GetSkillLineInfo", "GetSkillLineInfo", "GetNumSkillLines",
        "TooltipDataProcessor.AddTooltipPostCall", "Settings.RegisterCanvasLayoutCategory"
    }) do
        record_api(report, path)
    end

    for _, path in ipairs({
        "UIParent", "GameTooltip", "ItemRefTooltip", "TargetFrame",
        "TargetFrame.TargetFrameContent.TargetFrameContentMain.Name", "GossipFrame", "QuestFrame",
        "QuestInfoFrame", "QuestMapFrame", "ItemTextFrame"
    }) do
        record_frame(report, path)
    end

    local item_name = C_Item and C_Item.GetItemNameByID
    local spell_name = C_Spell and function (id)
        local info = C_Spell.GetSpellInfo(id)
        return info and info.name
    end
    local original_quest_title = translation.original["C_QuestLog.GetTitleForQuestID"]
        or (C_QuestLog and C_QuestLog.GetTitleForQuestID)

    sample_table(report, "items", addon_table.item, item_name, 40)
    sample_table(report, "spells", addon_table.spell, spell_name, 40)
    sample_table(report, "quests", quest_source(), original_quest_title, 40)

    report.ids = scanned_id_counts()
    report.menus = scanner.menu_count()

    UA_ForeverDB.diagnostics = report
    return report
end

scanner.summary = function (report)
    report = report or (UA_ForeverDB and UA_ForeverDB.diagnostics)
    if not report then return "сканування ще не виконувалося" end

    local missing_api = 0
    for _, ok in pairs(report.apis or {}) do if not ok then missing_api = missing_api + 1 end end
    local missing_frames = 0
    for _, ok in pairs(report.frames or {}) do if not ok then missing_frames = missing_frames + 1 end end

    local parts = { "API відсутні: " .. missing_api, "фрейми відсутні: " .. missing_frames }
    if report.catalog and report.catalog.matches == false then
        parts[#parts + 1] = "каталог клієнта: " .. report.catalog.build
            .. " ≠ " .. tostring(report.client and report.client.version)
            .. "." .. tostring(report.client and report.client.build)
    end
    if report.ui then
        parts[#parts + 1] = string.format("UI нових: %d, усього: %d", report.ui.new or 0, report.ui.unique or 0)
    end
    for _, kind in ipairs({ "items", "spells", "quests" }) do
        local s = report.samples and report.samples[kind]
        if s then
            parts[#parts + 1] = string.format("%s %d/%d, ≠%d, ?%d", kind, s.matched, s.checked, s.mismatched, s.unavailable)
        end
    end
    local id_total, id_missing = 0, 0
    for _, counts in pairs(report.ids or {}) do
        id_total = id_total + (counts.total or 0)
        id_missing = id_missing + (counts.missing or 0)
    end
    parts[#parts + 1] = string.format("ID записано: %d, без перекладу: %d", id_total, id_missing)
    parts[#parts + 1] = string.format("меню пройдено: %d", scanner.menu_count())
    return table.concat(parts, "; ")
end
