local addon_name, addon_table = ...

local assets = addon_table.use("assets")
local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local auto_scan = addon_table.use("auto_scan")

local restricted_limit = 32
local restricted_store
local restricted_index = {}
local restricted_samples = setmetatable({}, { __mode = "k" })
local recording_restricted_action = false
local restricted_markers = { ["map-canvas"] = {}, ["unit-menu"] = {} }
local restricted_fields = {
    ["map-canvas"] = {
        { "WorldMapFrame", "AcquirePin" },
        { "WorldMapFrame", "RefreshAllDataProviders" },
        { "MapCanvasMixin", "AcquirePin" },
        { "MapCanvasMixin", "RefreshAllDataProviders" },
        { "MapCanvasPinMixin", "CheckMouseButtonPassthrough" },
    },
    ["unit-menu"] = {
        { false, "CheckInteractDistance" },
        { false, "UnitPopup_OpenMenu" },
        { "MenuUtil", "CreateContextMenu" },
        { "Menu", "PopulateDescription" },
        { "MenuManagerProxy", "OpenContextMenu" },
        { "UnitPopupSharedUtil", "IsEnabled" },
    },
}

-- Restricted-action events are synchronous. Capture their stack here, before
-- returning to Blizzard, without running protected UI methods.
local function public_diagnostic(value, expected_type)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret ~= false then return nil end
    end
    if type(value) ~= expected_type then return nil end
    if expected_type == "number" and (value ~= value
        or value == math.huge or value == -math.huge) then return nil end
    return value
end

local function diagnostic_value(callback, expected_type, ...)
    if type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, ...)
    if ok then return public_diagnostic(value, expected_type) end
end

dev_log.mark_restricted_path = function (path, label)
    local markers = restricted_markers[path]
    if not markers or type(label) ~= "string" then return end
    local uptime = diagnostic_value(_G.GetTime, "number")
    if not uptime then return end
    local last = markers[#markers]
    if last and last.label == label and uptime - last.uptime < 0.25 then return end
    if #markers == 8 then table.remove(markers, 1) end
    markers[#markers + 1] = { uptime = uptime, label = label }
end

local function restricted_path(function_name, stack)
    if function_name:match("SetPassThroughButtons%(%s*%)$")
        and stack:lower():find("blizzard_mapcanvas", 1, true) then
        return "map-canvas"
    end
    if function_name:match("CheckInteractDistance%(%s*%)$")
        and stack:lower():find("blizzard_unitpopupshared", 1, true) then
        return "unit-menu"
    end
end

local function marker_snapshot(path)
    local entries = {}
    for _, marker in ipairs(restricted_markers[path]) do
        entries[#entries + 1] = string.format("%.3f %s", marker.uptime, marker.label)
    end
    return #entries > 0 and table.concat(entries, "\n") or "<none yet>"
end

local function taint_snapshot(path)
    if type(_G.issecurevariable) ~= "function" then return "issecurevariable unavailable" end
    local entries = {}
    for _, field in ipairs(restricted_fields[path]) do
        local global, key = field[1], field[2]
        local object = global == false and _G or _G[global]
        if global == "MenuManagerProxy" then
            local ok, manager = pcall(function () return _G.Menu.GetManager() end)
            object = ok and manager or nil
        end
        local state = "unavailable"
        if (public_diagnostic(object, "table") or public_diagnostic(object, "userdata"))
            and diagnostic_value(function () return object[key] end, "function") then
            local ok, secure, source = pcall(_G.issecurevariable, object, key)
            secure = ok and public_diagnostic(secure, "boolean")
            if ok and secure == true then
                state = "secure"
            elseif ok and secure == false then
                source = public_diagnostic(source, "string")
                state = source and "tainted (" .. source:sub(1, 80) .. ")" or "tainted"
            end
        end
        entries[#entries + 1] = (global and global .. "." or "") .. key .. "=" .. state
    end
    return table.concat(entries, "\n")
end

local function record_restricted_action(event, name, function_name)
    event = public_diagnostic(event, "string")
    name = public_diagnostic(name, "string")
    if (event ~= "ADDON_ACTION_BLOCKED" and event ~= "ADDON_ACTION_FORBIDDEN")
        or name ~= addon_name then return false end
    function_name = public_diagnostic(function_name, "string") or "<unknown>"
    function_name = function_name:sub(1, 256)
    if type(UA_ForeverDB) ~= "table" then return false end
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    local scan = UA_ForeverDB.scan
    if type(scan.restrictedActions) ~= "table" then scan.restrictedActions = {} end
    local records = scan.restrictedActions
    if restricted_store ~= records then
        restricted_store = records
        restricted_index = {}
    end
    local key = event .. "\031" .. function_name
    local record = restricted_index[key]
    local now = diagnostic_value(_G.time, "number")
    local uptime = diagnostic_value(_G.GetTime, "number")
    local in_combat = diagnostic_value(_G.InCombatLockdown, "boolean")
    local input = _G.InputUtil
    local gamepad = diagnostic_value(input and input.IsGamepadUIEnabled, "boolean")
    if not record then
        -- Do not merge earlier sessions: a reload/build change may have a
        -- different cause even when Blizzard reports the same function.
        while #records >= restricted_limit do
            local removed = table.remove(records, 1)
            for indexed_key, value in pairs(restricted_index) do
                if value == removed then restricted_index[indexed_key] = nil end
            end
        end
        record = { event = event, addon = name, functionName = function_name,
            count = 0, firstSeen = now, firstUptime = uptime,
            firstInCombat = in_combat, firstGamepadUI = gamepad }
        if type(_G.GetBuildInfo) == "function" then
            local ok, version, build = pcall(_G.GetBuildInfo)
            if ok then
                record.clientVersion = public_diagnostic(version, "string")
                record.clientBuild = public_diagnostic(build, "string")
            end
        end
        local addons = _G.C_AddOns
        record.addonVersion = diagnostic_value(addons and addons.GetAddOnMetadata,
            "string", addon_name, "Version")
        records[#records + 1] = record
        restricted_index[key] = record
    end
    record.count = record.count + 1
    record.lastSeen, record.lastUptime = now, uptime
    record.lastInCombat, record.lastGamepadUI = in_combat, gamepad
    local sampled = restricted_samples[record]
    -- A popup loop must not build thousands of identical stack traces. When
    -- GetTime is unavailable, retain only the first synchronous sample.
    if not sampled or uptime and (not sampled.uptime
        or uptime < sampled.uptime or uptime - sampled.uptime >= 1) then
        local stack = diagnostic_value(_G.debugstack, "string", 2, 24, 0)
        stack = stack and stack:sub(1, 8192) or "<unavailable>"
        local path = restricted_path(function_name, stack)
        if path then
            local markers, taint = marker_snapshot(path), taint_snapshot(path)
            if not sampled then
                record.firstPath, record.firstMarkers, record.firstTaint = path, markers, taint
            end
            record.lastPath, record.lastMarkers, record.lastTaint = path, markers, taint
        else
            record.lastPath, record.lastMarkers, record.lastTaint = nil, nil, nil
        end
        record.stack = record.stack or stack
        record.lastStack = stack
        record.lastStackAt, record.lastStackUptime = now, uptime
        record.stackSamples = (record.stackSamples or 0) + 1
        restricted_samples[record] = { uptime = uptime }
    end
    return true
end

-- Keep this independent of autoscan/translation settings. A blocked action is
-- an error report, and exporting with diagnostics off must not discard it.
dev_log.record_restricted_action = function (...)
    if recording_restricted_action then return false end
    recording_restricted_action = true
    local ok, recorded = pcall(record_restricted_action, ...)
    recording_restricted_action = false
    return ok and recorded == true
end

local translation_groups = {
    quests = true,
    gossips = true,
    npcs = true,
    books = true,
    chats = true,
    objects = true,
}

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
end

local function safe_name(value)
    if type(value) ~= "string" or is_secret(value) then return nil end
    if value == "" then return nil end
    return value
end

local function safe_saved_value(value, depth)
    depth = depth or 0
    if depth > 4 then return true end
    local value_type = type(value)
    if value_type == "string" then
        return is_secret(value) and "<secret>" or value
    elseif value_type == "number" or value_type == "boolean" or value == nil then
        return value
    elseif value_type == "table" then
        local copy = {}
        for key, child in pairs(value) do
            if not is_secret(key) then
                copy[key] = safe_saved_value(child, depth + 1)
            end
        end
        return copy
    end
    return true
end

local function notify(text)
    if options.account and options.account.dev_mode_notify_activity and DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(assets.icon_ua_inline .. " |cff4488aa[UA Forever] " .. text .. "|r")
    end
end

local function put(group, key, value)
    local diagnostics = options.account
        and options.account.auto_scan_diagnostics == true
    if not translation_groups[group] and not diagnostics then return end
    local missing = UA_ForeverDB and UA_ForeverDB.missing
    if not missing then return end
    if is_secret(group) or is_secret(key) then return end
    missing[group] = missing[group] or {}
    if missing[group][key] == nil then
        value = safe_saved_value(value)
        missing[group][key] = value == nil and true or value
        notify("Новий запис: " .. group .. " " .. tostring(key))
    end
end

dev_log.prepare = function ()
    UA_ForeverDB.missing = UA_ForeverDB.missing or {}
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
end

dev_log.record_id = function (group, id, name, translated)
    id = tonumber(id)
    if not group or not id or id <= 0 then return end

    local clean_name = safe_name(name)
    if options.account and options.account.auto_scan_diagnostics == true
        and UA_ForeverDB and UA_ForeverDB.scan then
        local scanned_ids = UA_ForeverDB.scan.ids or {}
        UA_ForeverDB.scan.ids = scanned_ids
        scanned_ids[group] = scanned_ids[group] or {}
        local record = scanned_ids[group][id]
        local is_new = type(record) ~= "table"
        if is_new then record = {} end
        local translated_value = translated ~= nil and translated and true
            or translated ~= nil and false or nil
        local changed = is_new or clean_name and record.name ~= clean_name
            or translated ~= nil and record.translated ~= translated_value
        if changed then
            if clean_name then record.name = clean_name end
            if translated ~= nil then record.translated = translated_value end
            record.lastSeen = type(_G.date) == "function"
                and _G.date("!%Y-%m-%dT%H:%M:%SZ") or nil
            scanned_ids[group][id] = record
        end
    end

    if translated == false then
        put(group, id, clean_name or true)
    end
    if group == "items" or group == "npcs" or group == "quests"
        or group == "spells" or group == "skills" then
        auto_scan.record_id(group, id, clean_name, translated)
    end
end

dev_log.record_quest_text = function (id, fields, missing_fields)
    id = tonumber(id)
    if not id or id <= 0 or type(fields) ~= "table" then return end

    if options.account and options.account.auto_scan_diagnostics == true
        and UA_ForeverDB and UA_ForeverDB.scan then
        local scanned_ids = UA_ForeverDB.scan.ids or {}
        UA_ForeverDB.scan.ids = scanned_ids
        scanned_ids.quests = scanned_ids.quests or {}
        local record = scanned_ids.quests[id] or {}
        local safe_fields = safe_saved_value(fields)
        if type(safe_fields) == "table" then
            record.text = record.text or {}
            for key, value in pairs(safe_fields) do
                record.text[key] = value
            end
        end

        if type(missing_fields) == "table" then
            record.missingFields = record.missingFields or {}
            for key, is_missing in pairs(missing_fields) do
                if is_missing then
                    record.missingFields[key] = true
                else
                    record.missingFields[key] = nil
                end
            end
            if next(record.missingFields) == nil then
                record.missingFields = nil
            end
        end
        scanned_ids.quests[id] = record
    end
    auto_scan.record_quest(id, fields, missing_fields)
end

dev_log.issue = function (key, data) put("issues", tostring(key), data) end
dev_log.issue_entry = function (kind, id, key, data)
    put("issues", tostring(kind) .. "#" .. tostring(id) .. ": " .. tostring(key), data)
end
dev_log.missing_quest = function (id) put("quests", tonumber(id) or id, true) end
dev_log.missing_npc = function (id, name) put("npcs", tonumber(id) or id, name) end
dev_log.missing_item = function (id, name) put("items", tonumber(id) or id, name) end
dev_log.missing_spell = function (id, name) put("spells", tonumber(id) or id, name) end
dev_log.missing_sod_engraving = function (id, name) put("engravings", tonumber(id) or id, name) end
dev_log.missing_zone = function (name) put("zones", tostring(name), true) end
dev_log.missing_object = function (name) put("objects", tostring(name), true) end

dev_log.missing_book_page = function (id, page, text)
    local key = tostring(id) .. ":" .. tostring(page)
    put("books", key, text)
end

dev_log.missing_gossip = function (id, code, text, is_reply)
    put("gossips", tostring(id) .. ":" .. tostring(code), { text, is_reply = is_reply })
    auto_scan.record_gossip(id, code, text, is_reply)
end

dev_log.missing_chat_text = function (name, code, text, language)
    put("chats", tostring(name) .. ":" .. tostring(code), { text, language = language })
    auto_scan.record_chat(name, code, text, language)
end
