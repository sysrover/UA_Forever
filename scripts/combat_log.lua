local _, addon_table = ...
local combat_log = addon_table.use("combat_log")
local catalog = assert(addon_table.forever_chat_system.combat_log)
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local templates, terms, term_heads, event_templates = {}, {}, {}, {}

local function enabled()
    return options.can_translate("translate_chat")
end

-- Native formatter calls from addon code produced recurring Lua errors in
-- build 70170. Keep the diagnostic command inert; never enter that bridge.
combat_log.probe = function()
    return { version = 2, status = "probe_disabled" }
end

local function normalize(text)
    return (text:gsub("%s+", " "):gsub(" ([.,])", "%1")
        :gsub("^[ .,]+", ""):gsub("%s+$", ""))
end

local function escape(text)
    return (text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

-- The processor uses positional printf arguments 1..11. Compile only the
-- ACTION_*_FULL_TEXT globals whose literal pieces belong to this build's
-- catalog. We never write globals in the processor's secure environment.
local function compile_template(source)
    local parts, indices, target, position, next_index = {}, {}, {}, 1, 1
    source = normalize(source)
    while position <= #source do
        local first, last, explicit, kind = source:find("%%(%d+)%$([sd])", position)
        if not first then first, last, kind = source:find("%%([sd])", position) end
        local literal = source:sub(position, first and first - 1 or #source)
        local translated = catalog.full_text_literals[literal]
        if literal:find("%a") and not translated then return end
        parts[#parts + 1] = escape(literal)
        -- Actor/ability pairs use a colon rather than inflecting player names.
        if literal == " " and #indices > 0 and explicit then
            local previous, current = indices[#indices], tonumber(explicit)
            if (previous == 1 or previous == 4) and (current == 2 or current == 5) then
                translated = catalog.actor_separator
            end
        end
        target[#target + 1] = { text = translated or literal }
        if not first then break end
        local index = tonumber(explicit) or next_index
        if not explicit then next_index = next_index + 1 end
        indices[#indices + 1] = index
        target[#target + 1] = { index = index }
        parts[#parts + 1] = "(.-)"
        position = last + 1
    end
    return { pattern = "^" .. table.concat(parts) .. "$", indices = indices,
        target = target, weight = #source:gsub("%%%d+%$s", "") }
end

local function prepare_vocabulary()
    templates, terms, term_heads, event_templates = {}, {}, {}, {}
    local seen = {}
    for tag, value in pairs(_G) do
        if type(tag) == "string" and tag:match("^ACTION_.+_FULL_TEXT") then
            local source = runtime.safe_string_or_nil(value)
            if source then
                local compiled = seen[source]
                if compiled == nil then
                    compiled = compile_template(source)
                    seen[source] = compiled or false
                    if compiled then compiled.events = {}; templates[#templates + 1] = compiled end
                end
                if compiled then
                    compiled.events[tag:match("^ACTION_(.-)_FULL_TEXT")] = true
                end
            end
        end
    end
    table.sort(templates, function(a, b)
        if a.weight == b.weight then return a.pattern < b.pattern end
        return a.weight > b.weight
    end)
    for source, translated in pairs(catalog.terms) do
        terms[#terms + 1] = { source = source, translated = translated }
    end
    -- Resource wording already belongs to the existing UI catalog.
    for _, value in pairs(_G.COMBAT_LOG_POWER_TYPE_STRINGS or {}) do
        local source = runtime.safe_string_or_nil(value)
        local translated = source and resolver.find_ui(source)
        if translated and translated ~= source and not catalog.terms[source] then
            terms[#terms + 1] = { source = source, translated = translated }
        end
    end
    table.sort(terms, function(a, b) return #a.source > #b.source end)
    for _, term in ipairs(terms) do
        local head = term.source:sub(1, 1)
        term_heads[head] = term_heads[head] or {}
        table.insert(term_heads[head], term)
    end
end

local function translate_terms(text)
    -- Replace in one pass so an English word inside a translated value cannot
    -- be fed into another rule. Names and spell labels are protected links.
    local out, position = {}, 1
    while position <= #text do
        local matched
        for _, term in ipairs(term_heads[text:sub(position, position)] or {}) do
            local last = position + #term.source - 1
            if text:sub(position, last) == term.source
                and not text:sub(position - 1, position - 1):match("[%a_]")
                and not text:sub(last + 1, last + 1):match("[%a_]") then
                out[#out + 1] = term.translated
                position, matched = last + 1, true
                break
            end
        end
        if not matched then
            out[#out + 1] = text:sub(position, position)
            position = position + 1
        end
    end
    return table.concat(out)
end

-- Walk readable label runs while preserving color codes, braces and textures.
local function map_label(label, callback)
    local out, position = {}, 1
    while position <= #label do
        local first = label:find("|", position, true)
        if not first then out[#out + 1] = callback(label:sub(position)); break end
        if first > position then out[#out + 1] = callback(label:sub(position, first - 1)) end
        local token = label:sub(first):match("^|c%x%x%x%x%x%x%x%x")
            or label:sub(first):match("^|[r]")
            or label:sub(first):match("^|T.-|t")
            or label:sub(first):match("^|A.-|a")
            or label:sub(first, first)
        out[#out + 1] = token
        position = first + #token
    end
    return table.concat(out)
end

local function translate_link(kind, payload, label)
    local id = tonumber(payload:match("^(%d+)"))
    local entry, category
    if kind == "spell" and options.can_translate("translate_spell")
        and options.translate_name("spell") then
        category = "spell"
        entry = id and entries.get_entry(category, id)
    elseif kind == "item" and options.can_translate("translate_item")
        and options.translate_name("item") then
        category = "item"
        entry = id and entries.get_entry(category, id)
    elseif kind == "unit" and (payload:match("^Creature%-") or payload:match("^Vehicle%-"))
        and options.can_translate("translate_npc") then
        category = "npc"
        id = tonumber(payload:match("^[^-]+%-[^-]*%-[^-]*%-[^-]*%-[^-]*%-(%d+)%-"))
        entry = id and entries.get_entry(category, id)
    end
    return map_label(label, function(text)
        local left, name, right = text:match("^(%[?)(.-)(%]?)$")
        if kind == "unit" then name = name:gsub("'s$", "") end
        if name == "" then return left .. right end
        local translated = entry and entry[1]
            or category and entries.lookup_name(category, name)
        if kind == "action" then translated = catalog.terms[name]
        elseif kind == "unit" then
            -- Player GUIDs never use the NPC/name glossary.
            local original_name = payload:match("^[^:]+:(.*)$")
            translated = (name == "You" or name == "Your") and name ~= original_name
                and catalog.terms[name] or translated
        elseif kind ~= "spell" and kind ~= "item" and kind ~= "icon" then
            translated = resolver.find_ui(name)
        end
        if type(translated) ~= "string" or translated == "" then translated = name end
        return left .. translated .. right
    end)
end

combat_log.translate = function(message)
    if not enabled() or not runtime.safe_string_or_nil(message) then return message end
    if message:find("|Hplayer:", 1, true) then return message end
    local outer_color, inner, outer_reset = message:match("^(|c%x%x%x%x%x%x%x%x)(.*)(|r)$")
    if outer_color then
        return outer_color .. combat_log.translate(inner) .. outer_reset
    end
    local atoms = {}
    local function store_atom(text)
        text = text:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end)
        atoms[#atoms + 1] = text
        return "\001" .. #atoms .. "\002"
    end
    local masked = message:gsub("(|H([^:|]+):([^|]*)|h)(.-)(|h)",
        function(prefix, kind, payload, label, suffix)
            return store_atom(prefix .. translate_link(kind, payload, label) .. suffix)
        end)
    -- A colored number/school is one argument even if its label has spaces.
    masked = masked:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", function(color, text, reset)
        -- Only mask argument-sized spans. An outer color can surround a
        -- whole sentence; hiding that span would hide its English template.
        if text:match("^\001%d+\002$") or text:match("^[-+%d,%.]+$")
            or catalog.terms[text] or resolver.find_ui(text) then
            return store_atom(color .. translate_terms(text) .. reset)
        end
        return color .. text .. reset
    end)
    local timestamp, body = masked:match("^(%d+:%d+:%d+>%s*)(.*)$")
    body = normalize(body or masked)
    local event = message:match("|Haction:([^|]+)|h")
        or message:match("|Hspell:%d+:[^:|]*:([^|]+)|h")
    local candidates = event and event_templates[event] or templates
    if event and not candidates then
        candidates = {}
        for _, template in ipairs(templates) do
            for family in pairs(template.events) do
                if family == event or family:sub(1, #event + 1) == event .. "_" then
                    candidates[#candidates + 1] = template
                    break
                end
            end
        end
        event_templates[event] = candidates
    end
    for _, template in ipairs(candidates) do
        local captures = { body:match(template.pattern) }
        if #captures > 0 then
            local values, valid = {}, true
            for i, index in ipairs(template.indices) do
                local value = captures[i]
                if values[index] and values[index] ~= value then
                    -- Repeated actors are different masked occurrences of the
                    -- same link. Compare their restored bytes, not atom IDs.
                    local function restore(s)
                        return (s:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end))
                    end
                    if restore(values[index]) ~= restore(value) then valid = false end
                end
                values[index] = value
            end
            if valid then
                local out = {}
                for _, part in ipairs(template.target) do
                    out[#out + 1] = part.text or values[part.index] or ""
                end
                body = table.concat(out)
                break
            end
        end
    end
    body = translate_terms(body)
    body = body:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end)
    return (timestamp or "") .. body
end

-- Live combat-log rows and quick filters belong to the secure Blizzard
-- display. Keep this module as a pure formatter for the settings previews;
-- do not hook, redraw or call the native combat-log processor.
combat_log.prepare = prepare_vocabulary
