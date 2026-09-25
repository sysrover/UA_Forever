local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local tooltips = addon_table.use("tooltips")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")

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

local domains = { items = "item", npcs = "npc", quests = "quest", spells = "spell" }

local function translated_name(group, id, name)
    local domain = domains[group]
    local entry = domain and entries.get_entry and entries.get_entry(domain, id)
    return entry and type(entry[1]) == "string" and entry[1] ~= ""
        and (not name or entry[1] ~= name)
end

local function english_source(text)
    return safe_text(text) and text:find("[A-Za-z]")
        and not text:find("[\208\209]")
end

local function visible_english_tooltip_text(text)
    text = safe_text(text)
    if not text then return false end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|n", "")
    return text:find("[A-Za-z]") ~= nil
end

local function has_ui_translation(text)
    if not english_source(text) or not strings.find_ui_translation then return false end
    local ok, translated = pcall(strings.find_ui_translation, text)
    return ok and type(translated) == "string" and translated ~= text
end

local function translated_gossip(record)
    local catalog = addon_table.gossip
    if type(catalog) ~= "table" or not record.npcID or not record.text then return false end
    local code = utils.get_text_code(record.text)
    local hash = utils.get_text_hash(record.text)
    for _, key in ipairs({ record.npcID, "!common" }) do
        local values = catalog[key]
        if type(values) == "table" then
            local translation = values[code] or values[hash]
            if not translation and code and type(values["!code"]) == "table" then
                local pattern = utils.match_text_code(code,
                    utils.table_string_keys(values["!code"]))
                translation = pattern and values[values["!code"][pattern]]
            end
            if type(translation) == "string" and translation ~= record.text then
                return true
            end
        end
    end
    return false
end

auto_scan.record_id = function (group, id, name, translated)
    local records = bucket(group)
    id = tonumber(id)
    if not records or not id or id <= 0 then return end
    if translated_name(group, id, name) or (group == "skills" and translated == true) then
        if group ~= "quests" or not records[id] or not records[id].fields then
            records[id] = nil
        end
        return
    end
    if translated ~= false and group == "skills" then return end
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
        else
            record.fields[key] = nil
        end
    end
    if next(record.fields) then
        record.name = safe_text(fields.title) or record.name
        records[id] = record
    elseif record.name and translated_name("quests", id, record.name) then
        records[id] = nil
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
        or ((kind == "spell" or kind == "trainer") and "spells")
        or (kind == "aura" and "auras") or nil
    local records = group and bucket(group)
    if not records or not tooltip then return end
    local ok, rows = pcall(tooltips.inspect, tooltip, 40)
    if not ok or type(rows) ~= "table" or #rows == 0 then return end
    local title = safe_text(rows[1].source) or safe_text(rows[1].visible)
    local key = tonumber(id)
    if not key and kind == "trainer" and title and entries.lookup_id then
        key = entries.lookup_id("spell", title)
            or entries.lookup_id("spell", title:match("^[^:]+: (.+)$") or title)
    end
    local trainer_spell_id = kind == "trainer" and key or nil
    if kind == "trainer" and (key or title) then
        key = "trainer:" .. tostring(key or title)
    end
    if not key and kind == "aura" then key = title end
    if not key then return end

    local record = records[key] or {}
    record.name = title or record.name
    if kind == "trainer" then record.spellID = trainer_spell_id end
    local lines = {}
    for _, row in ipairs(rows) do
        local source = safe_text(row.source) or safe_text(row.visible)
        if visible_english_tooltip_text(row.visible)
            and visible_english_tooltip_text(source) then
            lines[#lines + 1] = {
                index = row.index, side = row.side, text = source,
                unapplied = has_ui_translation(source)
                    or (row.index == 1 and row.side == "Left"
                        and translated_name(group, key, source)) or nil,
            }
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

auto_scan.export_text = function ()
    local parts = {}
    local store = UA_ForeverDB and UA_ForeverDB.scan and UA_ForeverDB.scan.auto or {}
    for _, descriptor in ipairs(groups) do
        local group, label = descriptor[1], descriptor[2]
        local records = store[group] or {}
        local keys = {}
        for key, record in pairs(records) do
            if type(record) == "table" then
                local keep = true
                if group == "skills" then
                    keep = english_source(record.name) and not has_ui_translation(record.name)
                        and not entries.get_glossary_text(record.name)
                elseif domains[group] and group ~= "quests" then
                    keep = not translated_name(group, key, record.name)
                        or type(record.lines) == "table"
                elseif group == "gossips" then
                    keep = english_source(record.text) and not translated_gossip(record)
                elseif group == "chats" then
                    local ok, _, translated = pcall(entries.get_chat_text,
                        record.npc, record.text)
                    keep = english_source(record.text) and not (ok and translated)
                elseif group == "quests" then
                    local entry = entries.get_entry and entries.get_entry("quest", key)
                    local fields = {}
                    local indices = { title = 1, description = 2, objective = 3,
                        progress = 4, reward = 5 }
                    for field, value in pairs(record.fields or {}) do
                        local index = indices[field]
                        local translation = index and entry and entry[index]
                        if field:match("^task%d+$") and entries.translate_quest_objective_task then
                            local ok, result = pcall(entries.translate_quest_objective_task, value, key)
                            if ok then translation = result end
                        end
                        if english_source(value) and (type(translation) ~= "string"
                            or translation == "" or translation == value) then
                            fields[field] = value
                        end
                    end
                    if not next(fields) and english_source(record.name)
                        and not translated_name(group, key, record.name) then
                        fields.title = record.name
                    end
                    if next(fields) then
                        record.fields = fields
                    else keep = false end
                end
                if type(record.lines) == "table" then
                    local lines = {}
                    for _, row in ipairs(record.lines) do
                        local title_translated = row.index == 1 and row.side == "Left"
                            and translated_name(group, key, row.text)
                        if visible_english_tooltip_text(row.text)
                            and (row.unapplied or (not title_translated
                                and not has_ui_translation(row.text))) then
                            lines[#lines + 1] = row
                        end
                    end
                    record.lines = lines
                    if #lines == 0 then keep = false end
                end
                if keep then keys[#keys + 1] = key end
            end
        end
        table.sort(keys, function (a, b) return tostring(a) < tostring(b) end)
        local lines = { "UA Forever | " .. label .. " | " .. #keys .. " записів" }
        local function add(line)
            lines[#lines + 1] = line
        end
        for _, key in ipairs(keys) do
            local record = records[key]
            if type(record) == "table" then
                add("\n# " .. tostring(key))
                for _, field in ipairs({ "spellID", "npcID", "npc", "name", "text", "language", "reply" }) do
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
                        .. field_text(row.text)
                        .. (row.unapplied and " [переклад є, але не застосувався]" or ""))
                end
            end
        end
        if #lines > 1 then parts[#parts + 1] = table.concat(lines, "\n") end
    end
    return table.concat(parts, "\n\n")
end

auto_scan.clear = function ()
    if UA_ForeverDB and UA_ForeverDB.scan then
        UA_ForeverDB.scan.auto = {}
    end
end
