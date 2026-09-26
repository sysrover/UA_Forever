local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local tooltips = addon_table.use("tooltips")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")

local groups = {
    { "items", "[ITEMS]" }, { "gossips", "[GOSSIPS]" },
    { "npcs", "[NPCS]" }, { "quests", "[QUESTS]" },
    { "books", "[BOOKS]" },
    { "skills", "[SKILLS]" }, { "spells", "[SPELLS]" },
    { "auras", "[AURAS]" }, { "chats", "[CHATS]" },
    { "system_chat", "[SYSTEM_CHAT]" },
    { "combat_text", "[COMBAT_TEXT]" },
    { "zones", "[ZONES]" },
    { "objects", "[OBJECTS]" },
    { "ui", "[UI]" },
    { "unapplied", "[NOT_APPLIED]" },
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
    local source = entry and type(entry.en) == "string" and entry.en or name
    return entry and type(entry[1]) == "string" and entry[1] ~= ""
        and (not source or entry[1] ~= source)
end

local function english_source(text)
    return safe_text(text) and text:find("[A-Za-z]")
        and not text:find("[\208\209]")
end

local function has_english_words(text)
    text = safe_text(text)
    if not text then return false end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|n", "")
    return text:find("[A-Za-z][A-Za-z]+") ~= nil
end

local function untranslated_key(owner, slot, source)
    local hash = type(utils.get_text_hash) == "function"
        and utils.get_text_hash(source) or source
    return tostring(owner or "ui") .. ":" .. tostring(slot or "text")
        .. ":" .. tostring(hash)
end

local surface_states = {}

local function get_surface_state(surface)
    surface = safe_text(surface)
    if not surface then return nil end
    local state = surface_states[surface]
    if not state then
        state = { attempts = 0, hooks = {}, results = {} }
        surface_states[surface] = state
    end
    return state
end

auto_scan.surface_event = function (surface, event)
    local state = get_surface_state(surface)
    if not state then return end
    state.event = safe_text(event)
    state.handler = nil
    state.attempts = 0
    state.results = {}
    for _, hook in pairs(state.hooks) do hook.observed = false end
end

auto_scan.surface_hook = function (surface, hook_name, available, observed)
    local state = get_surface_state(surface)
    hook_name = safe_text(hook_name)
    if not state or not hook_name then return end
    local hook = state.hooks[hook_name] or {}
    hook.available = available == true
    if observed == true then hook.observed = true
    elseif hook.observed == nil then hook.observed = false end
    state.hooks[hook_name] = hook
end

auto_scan.surface_attempt = function (surface, handler)
    local state = get_surface_state(surface)
    if not state then return end
    state.handler = safe_text(handler) or state.handler
    state.attempts = (state.attempts or 0) + 1
end

local function note_surface_runtime_result(owner, slot, source, visible, reason)
    local state = surface_states[owner]
    if not state then return end
    local key = untranslated_key(owner, slot, source)
    state.results[key] = {
        success = visible ~= source,
        reason = safe_text(reason),
    }
end

local function surface_diagnostic(state)
    local names = {}
    for name in pairs(state and state.hooks or {}) do names[#names + 1] = name end
    table.sort(names)
    local name = names[1]
    local hook = name and state.hooks[name]
    return name, hook and hook.available == true or false,
        hook and hook.observed == true or false
end

local function runtime_reason_code(reason)
    if reason == "захищений елемент" then return "PROTECTED_REGION" end
    if reason == "інший обробник утримує цей елемент" then
        return "CLAIM_CONFLICT"
    end
    if reason then return "APPLY_FAILED" end
    return "APPLY_FAILED"
end

auto_scan.verify_surface = function (spec)
    if type(spec) ~= "table" then return end
    local records = bucket("unapplied")
    local surface = safe_text(spec.surface) or safe_text(spec.owner) or "ui"
    local owner = safe_text(spec.owner) or surface
    local slot = safe_text(spec.slot) or "ui.text"
    local source = safe_text(spec.source)
    local translated = safe_text(spec.translation)
    local visible = safe_text(spec.visible)
    if not records or not source then return end
    local key = untranslated_key(owner, slot, source)
    if spec.expected ~= true or not translated or translated == source
        or not has_english_words(source) then
        records[key] = nil
        return
    end
    if visible and visible ~= source then
        records[key] = nil
        return
    end

    local state = surface_states[surface]
    local result = state and state.results[key]
    local attempts = state and state.attempts or 0
    local reason
    if attempts == 0 then
        reason = "HANDLER_NOT_TRIGGERED"
    elseif result and result.success then
        reason = "OVERWRITTEN_AFTER_APPLY"
    elseif result and result.reason then
        reason = runtime_reason_code(result.reason)
    else
        reason = "LOOKUP_FAILED"
    end
    local hook_name, hook_available, hook_observed = surface_diagnostic(state)
    records[key] = {
        owner = owner, slot = slot, surface = surface,
        text = source, translation = translated, visible = visible,
        event = state and state.event or nil,
        handler = state and state.handler or nil,
        attempts = attempts,
        hook = hook_name, hookAvailable = hook_name and hook_available or nil,
        hookObserved = hook_name and hook_observed or nil,
        reason = reason,
        reasonDetail = result and result.reason or nil,
    }
end

auto_scan.record_runtime_result = function (spec, visible, reason)
    local records = bucket("unapplied")
    if not records or type(spec) ~= "table" then return end
    local source = safe_text(spec.source)
    local translated = safe_text(spec.translated)
    visible = safe_text(visible)
    if not source or not translated or source == translated
        or not has_english_words(source) then return end
    local owner = safe_text(spec.owner) or "ui"
    local slot = safe_text(spec.slot) or "ui.text"
    local key = untranslated_key(owner, slot, source)
    note_surface_runtime_result(owner, slot, source, visible, reason)
    if visible == source then
        records[key] = {
            owner = owner, slot = slot, text = source,
            translation = translated,
            reason = runtime_reason_code(safe_text(reason)),
            reasonDetail = safe_text(reason),
        }
    else
        records[key] = nil
        local ui_records = bucket("ui")
        if ui_records then
            local ui_key = type(utils.get_text_hash) == "function"
                and utils.get_text_hash(source) or source
            ui_records[ui_key] = nil
        end
        -- The generic UI scan can run before a domain hook applies its
        -- translation. Once the real owner succeeds, discard that early
        -- snapshot of the same source text as well.
        for candidate_key, candidate in pairs(records) do
            if type(candidate) == "table" and candidate.owner == "ui-scan"
                and candidate.text == source then
                records[candidate_key] = nil
            end
        end
    end
end

auto_scan.clear_runtime_owner = function (owner)
    local records = bucket("unapplied")
    if not records then return end
    for key, record in pairs(records) do
        if type(record) == "table" and record.owner == owner then
            records[key] = nil
        end
    end
end

auto_scan.record_ui = function (source, translated, slot)
    local records = bucket("ui")
    source = safe_text(source)
    if not records or not source or not has_english_words(source) then return end
    local key = type(utils.get_text_hash) == "function"
        and utils.get_text_hash(source) or source
    local ui_translation
    if strings.find_ui_translation then
        local ok, value = pcall(strings.find_ui_translation, source)
        if ok then ui_translation = value end
    end
    local translated_success = translated == true
        or type(translated) == "string" and translated ~= "" and translated ~= source
    local has_translation = translated_success
        or type(ui_translation) == "string" and ui_translation ~= source
    if has_translation then
        records[key] = nil
        if type(ui_translation) == "string" and ui_translation ~= source then
            auto_scan.record_runtime_result({
                owner = "ui-scan", slot = safe_text(slot) or "ui.text",
                source = source, translated = ui_translation,
            }, translated_success and ui_translation or source, "видимий UI-текст")
        end
        return
    end
    records[key] = { text = source, slot = safe_text(slot) }
end

auto_scan.record_book = function (identity, page, source, visible, translated, name)
    local records = bucket("books")
    source = safe_text(source)
    visible = safe_text(visible)
    page = tonumber(page) or 1
    if not records or not identity or not source or not has_english_words(source) then return end
    local key = tostring(identity) .. ":" .. tostring(page)
    local has_translation = type(translated) == "string"
        and translated ~= "" and translated ~= source
    local still_source = visible == source
        or visible and visible:sub(1, #source) == source
    if has_translation and not still_source then
        records[key] = nil
        return
    end
    records[key] = {
        bookID = tonumber(identity), page = page,
        name = safe_text(name), text = source,
        unapplied = has_translation and still_source or nil,
    }
end

local function visible_english_tooltip_text(text)
    text = safe_text(text)
    if not text then return false end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|n", "")
    -- Shortcut letters such as F6 in an otherwise Ukrainian line are not
    -- untranslated English. Keep mixed lines with actual English words.
    return text:find("[A-Za-z][A-Za-z]+") ~= nil
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
            if not (record.unapplied and record.unapplied[key]) then
                record.fields[key] = nil
            end
        end
    end
    if next(record.fields) then
        record.name = safe_text(fields.title) or record.name
        records[id] = record
    elseif record.name and translated_name("quests", id, record.name) then
        records[id] = nil
    end
end

auto_scan.record_visible_quest_field = function (id, field, source, visible, expected)
    local records = bucket("quests")
    id = tonumber(id)
    field = safe_text(field)
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not id or id <= 0 or not field
        or not source or not visible then return end
    local entry = entries.get_entry and entries.get_entry("quest", id)
    local indices = { title = 1, description = 2, objective = 3,
        progress = 4, reward = 5 }
    local index = indices[field]
    local translation = index and entry and entry[index]
    local translated = type(translation) == "string"
        and translation ~= "" and translation ~= source
    local still_english = english_source(visible) and visible == source
    local record = records[id] or {}
    record.fields = record.fields or {}
    record.unapplied = record.unapplied or {}
    record.unapplied[field] = still_english and translated and expected or nil
    record.fields[field] = still_english and (not translated or expected) and source or nil
    if next(record.fields) then
        if field == "title" then record.name = source end
        records[id] = record
    else
        records[id] = nil
    end
end

auto_scan.record_visible_quest_title = function (id, source, visible, expected)
    auto_scan.record_visible_quest_field(id, "title", source, visible, expected)
end

auto_scan.record_gossip = function (id, code, source, is_reply)
    local records = bucket("gossips")
    local text = safe_text(source)
    if not records or not id or not code or not text then return end
    local key = tostring(id) .. ":" .. tostring(code)
    local previous = records[key]
    records[key] = {
        npcID = tonumber(id), text = text, reply = is_reply == true,
        unapplied = previous and previous.unapplied or nil,
    }
end

auto_scan.record_visible_gossip = function (id, source, visible, expected)
    local records = bucket("gossips")
    id = tonumber(id)
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not id or id <= 0 or not source or not visible then return end
    local code = utils.get_text_code(source)
    if not code or code == "" then return end
    local key = tostring(id) .. ":" .. code
    local translated = translated_gossip({ npcID = id, text = source })
    if english_source(visible) and visible == source
        and (not translated or expected) then
        records[key] = {
            npcID = id, text = source, reply = false,
            unapplied = translated and expected or nil,
        }
    else
        records[key] = nil
    end
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

auto_scan.record_system_chat = function (event, source, translated)
    local records = bucket("system_chat")
    local text = safe_text(source)
    if not records or not text or not english_source(text) then return end
    if translated then
        records[text] = nil
    elseif #text <= 500 then
        records[text] = { text = text, event = event }
    end
end

auto_scan.record_combat_text = function (kind, source, translated, global_name, current)
    local records = bucket("combat_text")
    kind = safe_text(kind)
    source = safe_text(source)
    if not records or not kind or not source then return end
    records[kind] = {
        text = source,
        translation = safe_text(translated),
        global = safe_text(global_name),
        current = safe_text(current),
        event = "COMBAT_TEXT_UPDATE",
        capture = "EVENT_ONLY",
    }
end

auto_scan.record_world_tooltip = function (source, visible)
    local records = bucket("objects")
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not source then return end
    local translated = addon_table.translate_object_name
        and addon_table.translate_object_name(source)
        or addon_table.zone and addon_table.zone[source]
    local unapplied = translated and visible == source
    if not english_source(source) or translated and not unapplied then
        records[source] = nil
        return
    end
    records[source] = { name = source, unapplied = unapplied or nil }
end

auto_scan.record_zone_name = function (source, visible)
    local records = bucket("zones")
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not source then return end
    local translated = addon_table.zone and addon_table.zone[source]
    local unapplied = translated and visible == source
    if not english_source(source) or translated and not unapplied then
        records[source] = nil
        return
    end
    records[source] = { name = source, unapplied = unapplied or nil }
end

auto_scan.capture_tooltip = function (tooltip, kind, id, missing_entry)
    -- Shift intentionally displays the original tooltip. Do not report that
    -- view as a failed translation.
    if tooltip and tooltip.uaForeverShowOriginal then return end
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
                unapplied = (row.visible == source
                    and (has_ui_translation(source)
                        or (row.index == 1 and row.side == "Left"
                            and translated_name(group, key, source)))) or nil,
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

local NOT_APPLIED = "[NOT_APPLIED]"

local function redundant_export_field(group, key, record, field)
    local value = record[field]
    if field == "name" and tostring(value) == tostring(key) then return true end
    if field == "text" and tostring(value) == tostring(key) then return true end
    if field == "reply" and value == false then return true end
    if field == "npcID" and group == "gossips"
        and tostring(key):match("^" .. tostring(value) .. ":") then return true end
    if field == "name" and type(record.fields) == "table"
        and record.fields.title == value then return true end
    return false
end

local function domain_store_has_text(store, source)
    for group, records in pairs(store) do
        if group ~= "ui" and group ~= "unapplied" and type(records) == "table" then
            for _, record in pairs(records) do
                if type(record) == "table" then
                    if record.name == source or record.text == source then return true end
                    if type(record.fields) == "table" then
                        for _, value in pairs(record.fields) do
                            if value == source then return true end
                        end
                    end
                    if type(record.lines) == "table" then
                        for _, row in ipairs(record.lines) do
                            if type(row) == "table" and row.text == source then return true end
                        end
                    end
                end
            end
        end
    end
    return false
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
                    keep = english_source(record.text)
                        and (record.unapplied or not translated_gossip(record))
                elseif group == "chats" then
                    local ok, _, translated = pcall(entries.get_chat_text,
                        record.npc, record.text)
                    keep = english_source(record.text) and not (ok and translated)
                elseif group == "system_chat" then
                    keep = english_source(record.text)
                    if keep and type(auto_scan.system_chat_translated) == "function" then
                        local ok, translated = pcall(auto_scan.system_chat_translated,
                            record.event, record.text)
                        keep = not (ok and translated)
                    end
                elseif group == "combat_text" then
                    keep = english_source(record.text)
                elseif group == "objects" then
                    local translated = addon_table.translate_object_name
                        and addon_table.translate_object_name(record.name)
                        or addon_table.zone and addon_table.zone[record.name]
                    keep = english_source(record.name)
                        and (not translated or record.unapplied == true)
                elseif group == "zones" then
                    local translated = addon_table.zone and addon_table.zone[record.name]
                    keep = english_source(record.name)
                        and (not translated or record.unapplied == true)
                elseif group == "unapplied" then
                    keep = english_source(record.text)
                        and type(record.translation) == "string"
                        and record.translation ~= "" and record.translation ~= record.text
                elseif group == "books" then
                    local book = record.bookID and addon_table.book
                        and addon_table.book[record.bookID]
                    local translated = type(book) == "table" and book[record.page]
                    keep = record.unapplied == true or english_source(record.text)
                        and not (type(translated) == "string" and translated ~= ""
                            and translated ~= record.text)
                elseif group == "ui" then
                    keep = english_source(record.text)
                        and not has_ui_translation(record.text)
                        and not domain_store_has_text(store, record.text)
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
                        if english_source(value) and ((record.unapplied
                            and record.unapplied[field]) or type(translation) ~= "string"
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
        local lines = { label .. " | " .. #keys }
        local function add(line)
            lines[#lines + 1] = line
        end
        for _, key in ipairs(keys) do
            local record = records[key]
            if type(record) == "table" then
                add("\n# " .. tostring(key))
                local record_unapplied = record.unapplied == true
                    or group == "unapplied"
                local fields_unapplied = false
                if type(record.unapplied) == "table" then
                    fields_unapplied = next(record.unapplied) ~= nil
                end
                local output_fields
                if group == "unapplied" then
                    output_fields = { "owner", "slot", "surface", "text",
                        "translation", "visible", "event", "handler", "attempts",
                        "hook", "hookAvailable", "hookObserved", "reason",
                        "reasonDetail" }
                elseif record_unapplied or fields_unapplied then
                    output_fields = { "spellID", "npcID", "bookID", "page" }
                else
                    output_fields = { "spellID", "npcID", "bookID", "page",
                        "npc", "name", "text", "translation", "owner", "slot",
                        "reason", "event", "language", "reply", "global",
                        "current", "capture" }
                end
                for _, field in ipairs(output_fields) do
                    if record[field] ~= nil
                        and not redundant_export_field(group, key, record, field) then
                        add(field .. " = " .. field_text(record[field]))
                    end
                end
                if record_unapplied then add(NOT_APPLIED) end
                if type(record.fields) == "table" then
                    local fields = {}
                    for field in pairs(record.fields) do fields[#fields + 1] = field end
                    table.sort(fields)
                    local tag_added = record_unapplied
                    for _, field in ipairs(fields) do
                        if record.unapplied and record.unapplied[field] then
                            if not tag_added then
                                add(NOT_APPLIED)
                                tag_added = true
                            end
                        else
                            add(field .. " = " .. field_text(record.fields[field]))
                        end
                    end
                end
                for _, row in ipairs(record.lines or {}) do
                    add(tostring(row.index) .. " " .. tostring(row.side) .. " = "
                        .. (row.unapplied and NOT_APPLIED or field_text(row.text)))
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
