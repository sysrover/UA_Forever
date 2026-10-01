local _, addon_table = ...

local lookup = addon_table.use("gossip_hashed")
local utils = addon_table.use("utils")

local index, anchors, actor_key
local max_captures = 24
lookup.version = 1

local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value or nil
end

local function read_actor(api_name)
    local api = _G[api_name]
    if type(api) ~= "function" then return nil end
    local ok, value = pcall(api, "player")
    return ok and safe_string(value) or nil
end

local function actors()
    local sex
    if type(_G.UnitSex) == "function" then
        local ok, value = pcall(_G.UnitSex, "player")
        local readable = ok
        if readable and type(_G.issecretvalue) == "function" then
            local checked, secret = pcall(_G.issecretvalue, value)
            readable = checked and not secret
        end
        if readable and (value == 2 or value == 3) then sex = value == 2 and 1 or 2 end
    end
    return { name = read_actor("UnitName"), class = read_actor("UnitClass"),
        race = read_actor("UnitRace"), sex = sex }
end

local function canonical(text)
    return utils.lower(text:gsub("\194\160", " "):gsub("’", "'")
        :gsub("‘", "'"):gsub("“", '"'):gsub("”", '"'):gsub("%s+", " "))
        :match("^%s*(.-)%s*$")
end

local function exact_text(text)
    return utils.lower(text:gsub("\r\n", "\n"):gsub("\194\160", " "):gsub(" +", " "))
end

local function escape(text)
    return (text:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

local function word_byte(value)
    return value ~= "" and (value:match("[%w_]") or value:byte() >= 128)
end

local function remove_phrase(text, phrase)
    if not phrase or phrase == "" then return text end
    phrase = canonical(phrase)
    local parts, cursor = {}, 1
    while cursor <= #text do
        local first, last = text:find(phrase, cursor, true)
        if not first then break end
        local before = first > 1 and text:sub(first - 1, first - 1) or ""
        local after = last < #text and text:sub(last + 1, last + 1) or ""
        if not word_byte(before) and not word_byte(after) then
            parts[#parts + 1] = text:sub(cursor, first - 1)
            parts[#parts + 1] = " "
            cursor = last + 1
        else
            parts[#parts + 1] = text:sub(cursor, last)
            cursor = last + 1
        end
    end
    parts[#parts + 1] = text:sub(cursor)
    return table.concat(parts)
end

local function signature(text, actor)
    text = canonical(text)
    for _, kind in ipairs({ "name", "class", "race" }) do
        text = remove_phrase(text, actor[kind])
    end
    text = text:gsub("%$%d+[wWdk]", " "):gsub("%$[nNcCrR]", " ")
        :gsub("%d+", " "):gsub("[%p%c]", " "):gsub("%s+", " ")
    return text:match("^%s*(.-)%s*$")
end

local function conditional_variants(text, sex)
    local variants = { { text = text, choices = {} } }
    for _ = 1, 32 do
        local expanded, changed = {}, false
        for _, variant in ipairs(variants) do
            local first, last, token, male, female = variant.text:find("%$([gGtT])([^:;]*):([^;]*);")
            if not first then
                expanded[#expanded + 1] = variant
            else
                changed = true
                local choices = (token == "g" or token == "G") and sex and { sex } or { 1, 2 }
                for _, choice in ipairs(choices) do
                    local selected = choice == 1 and male or female
                    local decisions = {}
                    for i, old in ipairs(variant.choices) do decisions[i] = old end
                    decisions[#decisions + 1] = choice
                    expanded[#expanded + 1] = {
                        text = variant.text:sub(1, first - 1) .. selected:match("^%s*(.-)%s*$")
                            .. variant.text:sub(last + 1), choices = decisions,
                    }
                end
            end
        end
        if #expanded > 64 then return {} end
        variants = expanded
        if not changed then return variants end
    end
    return {}
end

local function actor_source(text, actor)
    local missing = false
    text = text:gsub("%$([nNcCrR])", function(token)
        local kind = token:lower() == "n" and "name" or token:lower() == "c" and "class" or "race"
        if not actor[kind] then missing = true; return "" end
        return actor[kind]
    end)
    if missing then return nil end
    return (text:gsub("%$[bB]", "\n"))
end

local function compile_template(text, actor, row, id, choices)
    text = actor_source(text, actor)
    if not text then return nil end
    local raw_source = exact_text(text)
    text = canonical(text)
    local parts, tokens, cursor, literals = { "^" }, {}, 1, {}
    while cursor <= #text do
        local first, last, token = text:find("(%$%d+[wWdk])", cursor)
        if not first then break end
        local literal = text:sub(cursor, first - 1)
        parts[#parts + 1] = escape(literal)
        literals[#literals + 1] = literal
        parts[#parts + 1] = token:match("[wW]$") and "(%-?%d[%d%., ]*)" or "(.-)"
        tokens[#tokens + 1] = token
        if #tokens > max_captures then return nil end
        cursor = last + 1
    end
    local tail = text:sub(cursor)
    parts[#parts + 1] = escape(tail); parts[#parts + 1] = "$"
    literals[#literals + 1] = tail
    local literal_text = table.concat(literals, " ")
    if literal_text:find("$", 1, true) then return nil end
    return { row = row, id = id, pattern = table.concat(parts), tokens = tokens,
        raw_source = raw_source,
        choices = choices, signature = signature(text, actor),
        literals = signature(literal_text, actor) }
end

local function rebuild(actor)
    index, anchors = {}, {}
    local database = addon_table.gossip_hashed
    if type(database) ~= "table" or database.version ~= lookup.version then return end
    local compiled, frequencies = {}, {}
    for id, row in pairs(database.rows or {}) do
        if type(row) == "table" and safe_string(row.text) and type(row.english) == "table" then
            for _, english in ipairs(row.english) do
                for _, variant in ipairs(conditional_variants(english, actor.sex)) do
                    local candidate = compile_template(variant.text, actor, row, id, variant.choices)
                    if candidate then
                        compiled[#compiled + 1] = candidate
                        local seen = {}
                        for word in candidate.literals:gmatch("%S+") do
                            if not seen[word] then frequencies[word] = (frequencies[word] or 0) + 1; seen[word] = true end
                        end
                    end
                end
            end
        end
    end
    for _, candidate in ipairs(compiled) do
        local hash = utils.string_hash(candidate.signature)
        index[hash] = index[hash] or {}; index[hash][#index[hash] + 1] = candidate
        -- Rare literal anchors cover formatted duration captures and harmless numeric formatting.
        if #candidate.tokens > 0 then
            local anchor
            for word in candidate.literals:gmatch("%S+") do
                if not anchor or frequencies[word] < frequencies[anchor] then anchor = word end
            end
            if anchor then
                local anchor_hash = utils.string_hash(anchor)
                anchors[anchor_hash] = anchors[anchor_hash] or {}
                anchors[anchor_hash][#anchors[anchor_hash] + 1] = candidate
            end
        end
    end
    lookup.record_count = #compiled
end

local function substitute(text, actor, candidate, captures)
    local decision = 0
    text = text:gsub("%$([gGtT])([^:;]*):([^;]*);", function(token, male, female)
        decision = decision + 1
        local choice = (token == "g" or token == "G") and actor.sex or candidate.choices[decision]
        if not choice then return "$" .. token .. male .. ":" .. female .. ";" end
        return (choice == 1 and male or female):match("^%s*(.-)%s*$")
    end)
    text = text:gsub("%$%d+[wWdk]", function(token) return captures[token:lower()] or token end)
    local codes = addon_table.codes or {}
    text = text:gsub("%$([nNcCrR])", function(token)
        local kind = token:lower() == "n" and "ім'я" or token:lower() == "c" and "клас" or "раса"
        return codes["{" .. kind .. ":н}"] or (kind == "ім'я" and actor.name) or "$" .. token
    end)
    text = text:gsub("%$[bB]", "\n")
    for pattern, replacement in pairs(codes) do text = text:gsub(pattern, replacement) end
    if text:find("%$%d+[A-Za-z]") or text:find("%$[nNcCrRgGtTbB]") then return nil end
    return text
end

lookup.prepare = function()
    local actor = actors()
    local key = table.concat({ actor.name or "", actor.class or "", actor.race or "", tostring(actor.sex) }, "\031")
    if not index or actor_key ~= key then rebuild(actor); actor_key = key end
    return actor
end

lookup.find = function(npc_id, source, role)
    source = safe_string(source)
    if not source or source == "" then return nil end
    local actor = lookup.prepare()
    local normalized = signature(source, actor)
    local candidates, seen = {}, {}
    local function add(bucket)
        for _, candidate in ipairs(bucket or {}) do
            if not seen[candidate] then candidates[#candidates + 1] = candidate; seen[candidate] = true end
        end
    end
    add(index[utils.string_hash(normalized)])
    for word in normalized:gmatch("%S+") do add(anchors[utils.string_hash(word)]) end
    local rendered_source = canonical(source)
    local raw_source = exact_text(source)
    local best, best_rank, best_id, ambiguous
    for _, candidate in ipairs(candidates) do
        local row = candidate.row
        if not role or (row.roles and row.roles[role]) then
            local scoped = false
            for _, id in ipairs(row.npcs or {}) do if id == tonumber(npc_id) then scoped = true; break end end
            -- Text-only matching remains available for records whose server links are absent.
            local rank = scoped and 4 or (#(row.npcs or {}) == 0 and 2 or nil)
            if rank then
                if candidate.raw_source == raw_source then rank = rank + 1 end
                local matches = { rendered_source:match(candidate.pattern) }
                if #matches > 0 then
                    local captured, valid = {}, true
                    for i, token in ipairs(candidate.tokens) do
                        local value = matches[i] and matches[i]:match("^%s*(.-)%s*$")
                        if not value or value == "" or (captured[token] and captured[token] ~= value) then valid = false; break end
                        captured[token] = value
                    end
                    if valid then
                        local translated = substitute(row.text, actor, candidate, captured)
                        if translated and translated ~= source then
                            if not best_rank or rank > best_rank then
                                best, best_rank, best_id, ambiguous = translated, rank, candidate.id, false
                            elseif rank == best_rank and best ~= translated then ambiguous = true end
                        end
                    end
                end
            end
        end
    end
    if ambiguous then return nil end
    return best, best_id
end
