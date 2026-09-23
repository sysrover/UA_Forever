local _, addon_table = ...

local assets = addon_table.use("assets")
local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")

local missing
local scanned_ids

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
    if not missing then
        return
    end
    if is_secret(group) or is_secret(key) then return end
    value = safe_saved_value(value)
    missing[group] = missing[group] or {}
    if missing[group][key] == nil then
        missing[group][key] = value == nil and true or value
        notify("Новий запис: " .. group .. " " .. tostring(key))
    end
end

dev_log.prepare = function ()
    UA_ForeverDB.missing = UA_ForeverDB.missing or {}
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    UA_ForeverDB.scan.ids = UA_ForeverDB.scan.ids or {}
    UA_ForeverDB.scan.menus = UA_ForeverDB.scan.menus or {}
    missing = UA_ForeverDB.missing
    scanned_ids = UA_ForeverDB.scan.ids
end

dev_log.record_id = function (group, id, name, translated)
    id = tonumber(id)
    if not scanned_ids or not group or not id or id <= 0 then return end

    scanned_ids[group] = scanned_ids[group] or {}
    local record = scanned_ids[group][id] or {}
    local clean_name = safe_name(name)
    if clean_name then record.name = clean_name end
    if translated ~= nil then record.translated = translated and true or false end
    record.lastSeen = type(_G.date) == "function" and _G.date("!%Y-%m-%dT%H:%M:%SZ") or nil
    scanned_ids[group][id] = record

    if translated == false then
        put(group, id, clean_name or true)
    end
end

dev_log.record_quest_text = function (id, fields, missing_fields)
    id = tonumber(id)
    if not scanned_ids or not id or id <= 0 or type(fields) ~= "table" then return end

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
end

dev_log.missing_chat_text = function (name, code, text, language)
    put("chats", tostring(name) .. ":" .. tostring(code), { text, language = language })
end
