local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local tooltips = addon_table.use("tooltips")

local groups = {
    { "items", "Предмети" }, { "gossips", "Діалоги NPC" },
    { "npcs", "Імена NPC" }, { "quests", "Квести" },
    { "skills", "Навички" }, { "spells", "Закляття та вміння" },
    { "auras", "Аури" }, { "chats", "Вислови NPC" },
}

local function safe_text(value)
    if type(value) ~= "string" or value == "" then return nil end
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return value
end

local function bucket(group)
    if not options.account or not options.account.auto_scan_content
        or not UA_ForeverDB then return nil end
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    UA_ForeverDB.scan.auto = UA_ForeverDB.scan.auto or {}
    local store = UA_ForeverDB.scan.auto
    store[group] = store[group] or {}
    return store[group]
end

auto_scan.record_id = function (group, id, name, translated)
    local records = bucket(group)
    id = tonumber(id)
    if not records or not id or id <= 0 then return end
    if group == "npcs" and translated == true then
        records[id] = nil
        return
    end
    if translated ~= false then
        local domain = group == "items" and "item" or group == "npcs" and "npc"
            or group == "quests" and "quest" or group == "spells" and "spell"
        local entry = domain and entries.get_entry and entries.get_entry(domain, id)
        if not entry or not name or entry[1] ~= name then return end
    end
    local record = records[id] or {}
    record.name = safe_text(name) or record.name
    records[id] = record
end

auto_scan.record_quest = function (id, fields, missing_fields)
    local records = bucket("quests")
    id = tonumber(id)
    if not records or not id or id <= 0 or type(fields) ~= "table"
        or type(missing_fields) ~= "table" then return end
    local record = records[id] or {}
    record.fields = record.fields or {}
    for key, value in pairs(fields) do
        if missing_fields[key] then
            local text = safe_text(value)
            if text then record.fields[key] = text end
        end
    end
    if next(record.fields) then
        record.name = safe_text(fields.title) or record.name
        records[id] = record
    end
end

auto_scan.record_gossip = function (id, code, source, is_reply)
    local records = bucket("gossips")
    local text = safe_text(source)
    if not records or not id or not code or not text then return end
    records[tostring(id) .. ":" .. tostring(code)] = {
        npcID = tonumber(id), text = text, reply = is_reply == true,
    }
end

auto_scan.record_chat = function (name, code, source, language)
    local records = bucket("chats")
    local text = safe_text(source)
    local npc = safe_text(name)
    if not records or not npc or not code or not text then return end
    records[npc .. ":" .. tostring(code)] = {
        npc = npc, text = text, language = safe_text(language),
    }
end

auto_scan.capture_tooltip = function (tooltip, kind, id, missing_entry)
    local group = kind == "item" and "items"
        or (kind == "spell" and "spells")
        or (kind == "aura" and "auras") or nil
    local records = group and bucket(group)
    if not records or not tooltip then return end
    local ok, rows = pcall(tooltips.inspect, tooltip, 40)
    if not ok or type(rows) ~= "table" or #rows == 0 then return end
    local title = safe_text(rows[1].source) or safe_text(rows[1].visible)
    local key = tonumber(id)
    if not key and kind == "aura" then key = title end
    if not key then return end

    local record = records[key] or {}
    record.name = title or record.name
    local lines = {}
    for _, row in ipairs(rows) do
        local source = safe_text(row.source) or safe_text(row.visible)
        local already_translated = safe_text(row.translated)
        local untranslated = missing_entry or not already_translated
            or already_translated == source
        if source and untranslated and (missing_entry or source:find("[A-Za-z]"))
            and (missing_entry or not source:find("[\208\209]")) then
            lines[#lines + 1] = { index = row.index, side = row.side, text = source }
        end
    end
    if #lines == 0 then
        records[key] = nil
    else
        record.lines = lines
        records[key] = record
    end
end

local function field_text(value)
    if type(value) == "string" then return string.format("%q", value) end
    return tostring(value)
end

auto_scan.export_parts = function ()
    local parts = {}
    local store = UA_ForeverDB and UA_ForeverDB.scan and UA_ForeverDB.scan.auto or {}
    for _, descriptor in ipairs(groups) do
        local group, label = descriptor[1], descriptor[2]
        local records = store[group] or {}
        local keys = {}
        for key in pairs(records) do keys[#keys + 1] = key end
        table.sort(keys, function (a, b) return tostring(a) < tostring(b) end)
        local lines = { "UA Forever | " .. label .. " | " .. #keys .. " записів" }
        local length = #lines[1]
        local function flush()
            if #lines > 1 then parts[#parts + 1] = table.concat(lines, "\n") end
            lines = { "UA Forever | " .. label .. " (продовження)" }
            length = #lines[1]
        end
        local function add(line)
            if length + #line > 12000 then flush() end
            lines[#lines + 1] = line
            length = length + #line + 1
        end
        for _, key in ipairs(keys) do
            local record = records[key]
            if type(record) == "table" then
                add("\n# " .. tostring(key))
                for _, field in ipairs({ "npcID", "npc", "name", "text", "language", "reply" }) do
                    if record[field] ~= nil then
                        add(field .. " = " .. field_text(record[field]))
                    end
                end
                if type(record.fields) == "table" then
                    local fields = {}
                    for field in pairs(record.fields) do fields[#fields + 1] = field end
                    table.sort(fields)
                    for _, field in ipairs(fields) do
                        add(field .. " = " .. field_text(record.fields[field]))
                    end
                end
                for _, row in ipairs(record.lines or {}) do
                    add(tostring(row.index) .. " " .. tostring(row.side) .. " = "
                        .. field_text(row.text))
                end
            end
        end
        flush()
    end
    return parts
end

auto_scan.clear = function ()
    if UA_ForeverDB and UA_ForeverDB.scan then
        UA_ForeverDB.scan.auto = {}
    end
end
