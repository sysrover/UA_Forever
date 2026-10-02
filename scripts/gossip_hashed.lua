local _, addon_table = ...

local module = addon_table.use("gossip_hashed")
local utils = addon_table.use("utils")

-- Separate indexes share one matcher; gossip scopes are IDs, chat scopes are names.
local function create_lookup(database_key, scope_value, lookup, chat_mode)
lookup = lookup or {}
local index, anchors, identities, source_templates, actor_key
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

local function source_template(text)
    text = text:gsub("<[nN][aA][mM][eE]>", "$n")
        :gsub("<[cC][lL][aA][sS][sS]>", "$c")
        :gsub("<[rR][aA][cC][eE]>", "$r")
        :gsub("%$[bB]", "\n")
    return canonical(text)
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
    if chat_mode then
        text = text:gsub("<([^<>/]+)/([^<>/]+)>", function(male, female)
            return "$t" .. male .. ":" .. female .. ";"
        end)
    end
    text = text:gsub("<hero/heroine>", "$ghero:heroine;")
        :gsub("<sir/ma'am>", "$gsir:ma'am;")
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
    text = text:gsub("<[nN][aA][mM][eE]>", "$n")
        :gsub("<[cC][lL][aA][sS][sS]>", "$c")
        :gsub("<[rR][aA][cC][eE]>", "$r")
    text = text:gsub("%$([nNcCrR])", function(token)
        local kind = token:lower() == "n" and "name" or token:lower() == "c" and "class" or "race"
        if not actor[kind] then missing = true; return "" end
        return actor[kind]
    end)
    if missing then return nil end
    return (text:gsub("%$[bB]", "\n"))
end

local function compile_template(text, actor, row, id, choices)
    local english = text
    if chat_mode then
        local captures, next_capture = {}, 90000
        local function dynamic(kind)
            if not captures[kind] then
                next_capture = next_capture + 1
                captures[kind] = "$" .. next_capture .. "k"
            end
            return captures[kind]
        end
        text = text:gsub("<([%a]+)>", function(kind)
            if kind == "name" or kind == "class" or kind == "race" or kind == "target" then
                return dynamic(kind)
            end
            return "<" .. kind .. ">"
        end):gsub("%$([nNcCrR])", function(token)
            return dynamic(token:lower() == "n" and "name" or token:lower() == "c" and "class" or "race")
        end)
    else
        text = actor_source(text, actor)
    end
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
        raw_source = raw_source, english = english,
        choices = choices, signature = signature(text, actor),
        literals = signature(literal_text, actor) }
end

local common_scope = "!common"

local function add_scoped(target, row, key, candidate)
    local scopes = row.npcs or {}
    if #scopes == 0 then scopes = { common_scope } end
    local added = {}
    for _, scope in ipairs(scopes) do
        if not added[scope] then
            target[scope] = target[scope] or {}
            local bucket = target[scope][key] or {}
            bucket[#bucket + 1] = candidate
            target[scope][key] = bucket
            added[scope] = true
        end
    end
end

local function scoped_bucket(target, scope, key)
    local scoped = target[scope]
    return scoped and scoped[key] or nil
end

local function rebuild(actor)
    index, anchors, identities, source_templates = {}, {}, {}, {}
    local database = addon_table[database_key]
    if type(database) ~= "table" or database.version ~= lookup.version then return end
    local compiled, frequencies = {}, {}
    local function compile_row(id, row)
        if type(row) ~= "table" then return end
        for _, identity in ipairs(row.identities or {}) do
            local key = utils.string_hash(identity.kind .. "\031" .. tostring(identity.value))
            add_scoped(identities, row, key, { row = row, id = id, identity = identity })
        end
        if type(row) == "table" and safe_string(row.text) and type(row.english) == "table" then
            for _, english in ipairs(row.english) do
                if chat_mode then
                    local template = source_template(english)
                    add_scoped(source_templates, row, utils.string_hash(template), {
                        row = row, id = id, template = template, raw_source = exact_text(english),
                    })
                end
                local source_sex = actor.sex
                if chat_mode then source_sex = nil end
                for _, variant in ipairs(conditional_variants(english, source_sex)) do
                    local template = source_template(variant.text)
                    local template_hash = utils.string_hash(template)
                    add_scoped(source_templates, row, template_hash, {
                        row = row, id = id, template = template, raw_source = exact_text(variant.text),
                    })
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
        for _, alternative in ipairs(row.alternatives or {}) do compile_row(id, alternative) end
    end
    for id, row in pairs(database.rows or {}) do
        compile_row(id, row)
    end
    for _, candidate in ipairs(compiled) do
        local hash = utils.string_hash(candidate.signature)
        add_scoped(index, candidate.row, hash, candidate)
        -- Rare literal anchors cover formatted duration captures and harmless numeric formatting.
        if #candidate.tokens > 0 then
            local anchor
            for word in candidate.literals:gmatch("%S+") do
                if not anchor or frequencies[word] < frequencies[anchor] then anchor = word end
            end
            if anchor then
                local anchor_hash = utils.string_hash(anchor)
                add_scoped(anchors, candidate.row, anchor_hash, candidate)
            elseif chat_mode then
                add_scoped(anchors, candidate.row, "!unanchored", candidate)
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

-- Source-less imports retain their original discriminator inside this same index.
-- Hash collisions are checked against the full identity and NPC scope.
local function find_identity(npc_id, source, role, actor, raw_translation)
    local codes = utils.get_gossip_lookup_codes(source)
    local function query(kind, value, scope)
        local key = utils.string_hash(kind .. "\031" .. tostring(value))
        local best, best_id, best_priority, ambiguous
        for _, candidate in ipairs(scoped_bucket(identities, scope or common_scope, key) or {}) do
            local row, identity = candidate.row, candidate.identity
            if identity.kind == kind and identity.value == value
                and (not role or (row.roles and row.roles[role])) then
                local translated = raw_translation and row.text
                    or substitute(row.text, actor, { choices = {} }, {})
                if translated and translated ~= source then
                    local priority = row.priority or 2
                    if not best_priority or priority > best_priority then
                        best, best_id, best_priority, ambiguous = translated, candidate.id, priority, false
                    elseif priority == best_priority and best ~= translated then ambiguous = true end
                end
            end
        end
        if ambiguous then return nil end
        return best, best_id
    end
    local scopes = { scope_value(npc_id) or false, false }
    for _, scope in ipairs(scopes) do
        for _, code in ipairs(codes) do
            local text, id = query("code", code, scope)
            if text then return text, id end
        end
    end
    local hash = utils.get_text_hash(source)
    for _, scope in ipairs(scopes) do
        local text, id = query("hash", hash, scope)
        if text then return text, id end
    end
    for _, scope in ipairs(scopes) do
        for _, code in ipairs(codes) do
            if #code >= 42 then
                local text, id = query("prefix", code:sub(1, 42), scope)
                if text then return text, id end
            end
        end
    end
end

lookup.prepare = function()
    local actor = actors()
    local key = table.concat({ actor.name or "", actor.class or "", actor.race or "", tostring(actor.sex) }, "\031")
    if not index or actor_key ~= key then rebuild(actor); actor_key = key end
    return actor
end

lookup.find = function(npc_id, source, role, raw_translation)
    source = safe_string(source)
    if not source or source == "" then return nil end
    local actor = lookup.prepare()
    local normalized = signature(source, actor)
    local candidates, seen = {}, {}
    local function add(bucket, rank)
        for _, candidate in ipairs(bucket or {}) do
            if not seen[candidate] then candidates[#candidates + 1] = candidate; seen[candidate] = rank end
        end
    end
    local scope = scope_value(npc_id)
    local hash = utils.string_hash(normalized)
    local words = {}
    for word in normalized:gmatch("%S+") do words[#words + 1] = utils.string_hash(word) end
    for _, entry in ipairs({ { scope or false, 4 }, { common_scope, 2 } }) do
        add(scoped_bucket(index, entry[1], hash), entry[2])
        if chat_mode then add(scoped_bucket(anchors, entry[1], "!unanchored"), entry[2]) end
        for _, word_hash in ipairs(words) do
            add(scoped_bucket(anchors, entry[1], word_hash), entry[2])
        end
    end
    local rendered_source = canonical(source)
    local raw_source = exact_text(source)
    local best, best_rank, best_id, best_source, ambiguous
    for _, candidate in ipairs(candidates) do
        local row = candidate.row
        if not role or (row.roles and row.roles[role]) then
            local rank = seen[candidate]
            if rank then
                rank = rank + (row.priority or 2) * 100
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
                        local translated = raw_translation and row.text
                            or substitute(row.text, actor, candidate, captured)
                        if translated and translated ~= source then
                            if not best_rank or rank > best_rank then
                                best, best_rank, best_id, best_source, ambiguous = translated, rank, candidate.id, candidate.english, false
                            elseif rank == best_rank and best ~= translated then ambiguous = true end
                        end
                    end
                end
            end
        end
    end
    if best_rank and best_rank >= 200 and not ambiguous then
        if chat_mode then return best, best_id, best_source end
        return best, best_id
    end
    if chat_mode then
        if ambiguous then return nil end
        return best, best_id, best_source
    end
    local identified, identified_id = find_identity(npc_id, source, role, actor, raw_translation)
    if identified then return identified, identified_id end
    if ambiguous then return nil end
    return best, best_id
end

-- Offline catalog tooling supplies source templates rather than a live player.
-- Return original dictionary wording; the game-only substitutions stay in find().
lookup.find_source = function(npc_id, source, role)
    source = safe_string(source)
    if not source or source == "" then return nil end
    lookup.prepare()
    local template, raw_source = source_template(source), exact_text(source)
    local best, best_id, best_rank, ambiguous
    local candidates = {}
    local hash = utils.string_hash(template)
    for _, entry in ipairs({ { scope_value(npc_id) or false, 4 }, { common_scope, 2 } }) do
        for _, candidate in ipairs(scoped_bucket(source_templates, entry[1], hash) or {}) do
            candidates[#candidates + 1] = { candidate = candidate, rank = entry[2] }
        end
    end
    for _, entry in ipairs(candidates) do
        local candidate = entry.candidate
        local row = candidate.row
        if candidate.template == template and (not role or (row.roles and row.roles[role])) then
            local rank = entry.rank
            if rank then
                rank = rank + (row.priority or 2) * 100
                    + (candidate.raw_source == raw_source and 1 or 0)
                if not best_rank or rank > best_rank then
                    best, best_id, best_rank, ambiguous = row.text, candidate.id, rank, false
                elseif rank == best_rank and best ~= row.text then ambiguous = true end
            end
        end
    end
    if best and not ambiguous then return best, best_id end
    return lookup.find(npc_id, source, role, true)
end

return lookup
end

create_lookup("gossip_hashed", tonumber, module)
module.create = create_lookup
