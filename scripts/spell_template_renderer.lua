local _, addon_table = ...

local renderer = addon_table.use("spell_template_renderer")
local client_db = addon_table.use("spell_client_db")

local compiled_cache = {}
local rendered_cache = {}
local rendered_order = {}
local rendered_head = 1
local rendered_tail = 0
local rendered_count = 0
local RENDERED_CACHE_LIMIT = 512
local MAX_CAPTURES = 30
local MAX_MATCH_STEPS = 100000
local MAX_MATCH_RESULTS = 64
local tooltip_catalog = addon_table.forever_tooltip_ui or {}
local dynamic_value_words = tooltip_catalog.dynamic_value_words or {}

local function is_secret_value(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

local function copy_table(source)
    local result = {}
    for key, value in pairs(source) do result[key] = value end
    return result
end

local function split_colon(text)
    local result = {}
    local start = 1
    while true do
        local separator = text:find(":", start, true)
        if not separator then
            result[#result + 1] = text:sub(start)
            break
        end
        result[#result + 1] = text:sub(start, separator - 1)
        start = separator + 1
    end
    return result
end

local function match_dynamic_token(text)
    -- Client templates use the same value token with optional arithmetic
    -- formatting, for example $/10;s1, $*2;23478s1 and $/1000;S1.
    -- The client has already evaluated the expression in native_text, so the
    -- renderer only needs to preserve its complete identity for matching.
    return text:match("^%$[/%*%+%-]%d+%.?%d*;%d*[A-Za-z]~?%d+%.%d+")
        or text:match("^%$[/%*%+%-]%d+%.?%d*;%d*[A-Za-z]~?%d+")
        or text:match("^%$%d*[A-Za-z]~?%d+%.%d+")
        or text:match("^%$%d*[A-Za-z]~?%d+")
        or text:match("^%$<[%a_][%w_]*>")
        or text:match("^%$%d*[A-Za-z]")
end

local function localize_dynamic_value(value)
    local format = tooltip_catalog.format
    if format and type(format.dynamic_value_range) == "function" then
        value = format.dynamic_value_range(value)
    end
    return (value:gsub("([A-Za-z]+)", function (word)
        return dynamic_value_words[word:lower()] or word
    end))
end

local function parse_template(text)
    if type(text) ~= "string" or text == "" then return nil end

    local counters = {}
    local length = #text

    local function make_key(kind, identity)
        local counter_key = kind .. "\031" .. identity
        local occurrence = (counters[counter_key] or 0) + 1
        counters[counter_key] = occurrence
        return counter_key .. "\031" .. occurrence, occurrence
    end

    local parse_sequence
    parse_sequence = function (position, stop_character)
        local nodes = {}
        local text_start = position

        local function add_text(last)
            if last < text_start then return end
            local value = text:sub(text_start, last)
            if value ~= "" then
                nodes[#nodes + 1] = { kind = "text", value = value }
            end
        end

        -- The client also emits compact elseif chains without repeating the
        -- leading '$', for example:
        --   $?PL<24[6]?PL<38[11]?PL<52[20][$s1]
        -- Represent every following condition as the false branch of the
        -- previous one so English matching decisions can be reused verbatim
        -- while rendering the Ukrainian template.
        local parse_conditional_false
        parse_conditional_false = function (chain_position)
            if text:sub(chain_position, chain_position) == "?" then
                local open = text:find("[", chain_position + 1, true)
                if not open then return nil end
                local selector = "$" .. text:sub(chain_position, open - 1)
                local first, after_first, closed = parse_sequence(open + 1, "]")
                if not first or not closed then return nil end
                local second, after_second = parse_conditional_false(after_first)
                if not second then return nil end
                local key = make_key("conditional", selector)
                return { {
                    kind = "conditional", key = key,
                    identity = selector, branches = { first, second },
                } }, after_second
            end
            if text:sub(chain_position, chain_position) == "[" then
                local second, after_second, closed =
                    parse_sequence(chain_position + 1, "]")
                if not second or not closed then return nil end
                return second, after_second
            end
            return {}, chain_position
        end

        while position <= length do
            local character = text:sub(position, position)
            if stop_character and character == stop_character then
                add_text(position - 1)
                return nodes, position + 1, true
            end

            if character ~= "$" then
                position = position + 1
            else
                add_text(position - 1)
                local start = position
                local prefix = text:sub(position, position + 1)

                if prefix == "${" then
                    local depth = 1
                    position = position + 2
                    while position <= length and depth > 0 do
                        local current = text:sub(position, position)
                        if current == "{" then depth = depth + 1 end
                        if current == "}" then depth = depth - 1 end
                        position = position + 1
                    end
                    if depth ~= 0 then return nil end
                    local precision = text:sub(position):match("^%.%d+")
                    if precision then position = position + #precision end
                    local identity = text:sub(start, position - 1)
                    local _, occurrence = make_key("token", identity)
                    nodes[#nodes + 1] = {
                        kind = "token", identity = identity,
                        occurrence = occurrence,
                    }
                elseif prefix == "$?" then
                    local open = text:find("[", position + 2, true)
                    if not open then return nil end
                    local selector = text:sub(position, open - 1)
                    local first, after_first, closed = parse_sequence(open + 1, "]")
                    if not first or not closed then return nil end
                    local second, after_second =
                        parse_conditional_false(after_first)
                    if not second then return nil end
                    local branches = { first, second }
                    position = after_second
                    local key = make_key("conditional", selector)
                    nodes[#nodes + 1] = {
                        kind = "conditional", key = key,
                        identity = selector, branches = branches,
                    }
                elseif prefix == "$l" or prefix == "$L"
                    or prefix == "$g" or prefix == "$G" then
                    local close = text:find(";", position + 2, true)
                    if not close then return nil end
                    local options = split_colon(text:sub(position + 2, close - 1))
                    if #options < 2 or options[1] == "" then return nil end
                    local grammar_kind = prefix:sub(2, 2):lower()
                    local identity = options[1]
                    local key = make_key(
                        "grammar:" .. grammar_kind, grammar_kind)
                    nodes[#nodes + 1] = {
                        kind = "grammar", grammar_kind = grammar_kind,
                        identity = identity, key = key, options = options,
                    }
                    position = close + 1
                elseif prefix == "$N" then
                    nodes[#nodes + 1] = { kind = "text", value = "\n" }
                    position = position + 2
                elseif prefix == "$@" then
                    local identity, spell_id = text:sub(position):match(
                        "^(%$@spellname(%d+))")
                    spell_id = tonumber(spell_id)
                    if not identity or not spell_id then return nil end
                    local key = make_key("spell_name", tostring(spell_id))
                    nodes[#nodes + 1] = {
                        kind = "spell_name", identity = identity,
                        spell_id = spell_id, key = key,
                    }
                    position = position + #identity
                else
                    local rest = text:sub(position)
                    local identity = match_dynamic_token(rest)
                    if not identity then return nil end
                    local _, occurrence = make_key("token", identity)
                    nodes[#nodes + 1] = {
                        kind = "token", identity = identity,
                        occurrence = occurrence,
                    }
                    position = position + #identity
                end
                text_start = position
            end
        end

        if stop_character then return nil end
        add_text(length)
        return nodes, length + 1, true
    end

    local nodes, _, complete = parse_sequence(1, nil)
    if not nodes or not complete then return nil end
    return nodes
end

local function compile_match_program(nodes)
    local instructions = {}
    local capture_count = 0

    local function emit(instruction)
        instructions[#instructions + 1] = instruction
        return #instructions
    end

    local compile_sequence
    compile_sequence = function (sequence, next_pc)
        local pc = next_pc
        for index = #sequence, 1, -1 do
            local node = sequence[index]
            if node.kind == "text" then
                pc = emit({ kind = "literal", value = node.value, next = pc })
            elseif node.kind == "spell_name" then
                local value = client_db.get_english_name(node.spell_id)
                if not value then return nil end
                pc = emit({
                    kind = "spell_name", key = node.key,
                    value = value, next = pc,
                })
            elseif node.kind == "token" then
                capture_count = capture_count + 1
                if capture_count > MAX_CAPTURES then return nil end
                pc = emit({
                    kind = "token",
                    identity = node.identity,
                    occurrence = node.occurrence,
                    next = pc,
                })
            elseif node.kind == "grammar" then
                local alternatives = {}
                for choice, value in ipairs(node.options) do
                    alternatives[#alternatives + 1] = {
                        decision = choice,
                        pc = emit({ kind = "literal", value = value, next = pc }),
                    }
                end
                pc = emit({
                    kind = "choice", key = node.key,
                    alternatives = alternatives,
                })
            elseif node.kind == "conditional" then
                local alternatives = {}
                for choice, branch in ipairs(node.branches) do
                    local branch_pc = compile_sequence(branch, pc)
                    if not branch_pc then return nil end
                    alternatives[#alternatives + 1] = {
                        decision = choice, pc = branch_pc,
                    }
                end
                pc = emit({
                    kind = "choice", key = node.key,
                    alternatives = alternatives,
                })
            else
                return nil
            end
        end
        return pc
    end

    local accept = emit({ kind = "accept" })
    local start = compile_sequence(nodes, accept)
    if not start then return nil end
    return { instructions = instructions, start = start }
end

local function compile_pair(english_raw, ukrainian_raw)
    local english = parse_template(english_raw)
    local ukrainian = parse_template(ukrainian_raw)
    if not english or not ukrainian then return nil end
    local matcher = compile_match_program(english)
    if not matcher then return nil end
    return { ukrainian = ukrainian, matcher = matcher }
end

local function render_nodes(nodes, decisions, values, decorations)
    local output = {}
    for _, node in ipairs(nodes) do
        if node.kind == "text" then
            output[#output + 1] = node.value
        elseif node.kind == "token" then
            local token_values = values[node.identity]
            local value = token_values and token_values[node.occurrence]
            if value == nil and token_values and #token_values == 1 then
                value = token_values[1]
            end
            if value == nil then return nil end
            output[#output + 1] = localize_dynamic_value(value)
        elseif node.kind == "spell_name" then
            local value = client_db.get_name(node.spell_id)
            if not value then return nil end
            local decoration = decorations[node.key]
            if decoration then
                value = decoration.prefix .. value .. decoration.suffix
            end
            output[#output + 1] = value
        elseif node.kind == "conditional" then
            local choice = decisions[node.key]
            local branch = choice and node.branches[choice]
            if not branch then return nil end
            local rendered = render_nodes(
                branch, decisions, values, decorations)
            if rendered == nil then return nil end
            output[#output + 1] = rendered
        elseif node.kind == "grammar" then
            local choice = decisions[node.key]
            if not choice then return nil end
            local offset = #node.options > 2 and node.options[1] == node.identity
                and 1 or 0
            local value = node.options[choice + offset]
                or node.options[choice]
            if value == nil then return nil end
            output[#output + 1] = value
        else
            return nil
        end
    end
    return table.concat(output)
end

local function match_literal_at(native_text, position, literal)
    local source_index = 1
    while source_index <= #literal do
        local character = literal:sub(source_index, source_index)
        if character:match("%s") then
            repeat
                source_index = source_index + 1
                character = literal:sub(source_index, source_index)
            until source_index > #literal or not character:match("%s")

            local whitespace_start = position
            while position <= #native_text
                and native_text:sub(position, position):match("%s") do
                position = position + 1
            end
            if position == whitespace_start then return nil end
        else
            if native_text:sub(position, position) ~= character then return nil end
            source_index = source_index + 1
            position = position + 1
        end
    end
    return position
end

local function match_spell_name_at(native_text, position, spell_name)
    local color_prefix = native_text:sub(position, position + 9)
    if color_prefix:match("^|c%x%x%x%x%x%x%x%x$") then
        local next_position = match_literal_at(
            native_text, position + #color_prefix, spell_name)
        if next_position and native_text:sub(
            next_position, next_position + 1) == "|r" then
            return next_position + 2, {
                prefix = color_prefix,
                suffix = "|r",
            }
        end
    end

    return match_literal_at(native_text, position, spell_name)
end

local function clone_match_context(context)
    local values = {}
    for identity, bucket in pairs(context.values) do
        values[identity] = copy_table(bucket)
    end
    local decorations = {}
    for key, decoration in pairs(context.decorations) do
        decorations[key] = {
            prefix = decoration.prefix,
            suffix = decoration.suffix,
        }
    end
    return {
        decisions = copy_table(context.decisions),
        values = values,
        decorations = decorations,
    }
end

local function context_signature(context)
    local parts = {}
    local decision_keys = {}
    for key in pairs(context.decisions) do
        decision_keys[#decision_keys + 1] = key
    end
    table.sort(decision_keys)
    for _, key in ipairs(decision_keys) do
        parts[#parts + 1] = "d\030" .. key .. "\030"
            .. tostring(context.decisions[key])
    end

    local value_keys = {}
    for key in pairs(context.values) do value_keys[#value_keys + 1] = key end
    table.sort(value_keys)
    for _, key in ipairs(value_keys) do
        local occurrences = {}
        for occurrence in pairs(context.values[key]) do
            occurrences[#occurrences + 1] = occurrence
        end
        table.sort(occurrences)
        for _, occurrence in ipairs(occurrences) do
            parts[#parts + 1] = "v\030" .. key .. "\030"
                .. tostring(occurrence) .. "\030"
                .. context.values[key][occurrence]
        end
    end

    local decoration_keys = {}
    for key in pairs(context.decorations) do
        decoration_keys[#decoration_keys + 1] = key
    end
    table.sort(decoration_keys)
    for _, key in ipairs(decoration_keys) do
        local decoration = context.decorations[key]
        parts[#parts + 1] = "m\030" .. key .. "\030"
            .. decoration.prefix .. "\030" .. decoration.suffix
    end
    return table.concat(parts, "\029")
end

local function match_program(matcher, native_text)
    local instructions = matcher.instructions
    local dead = {}
    local results = {}
    local result_signatures = {}
    local steps = 0
    local exhausted = false

    local visit
    visit = function (pc, position, context)
        if exhausted then return true end
        steps = steps + 1
        if steps > MAX_MATCH_STEPS then
            exhausted = true
            return false
        end

        local memo_key = tostring(pc) .. ":" .. tostring(position)
        if dead[memo_key] then return false end
        local instruction = instructions[pc]
        if not instruction then
            dead[memo_key] = true
            return false
        end

        local matched = false
        if instruction.kind == "accept" then
            if native_text:sub(position):match("^%s*$") then
                local signature = context_signature(context)
                if not result_signatures[signature] then
                    if #results >= MAX_MATCH_RESULTS then
                        exhausted = true
                        return false
                    end
                    result_signatures[signature] = true
                    results[#results + 1] = context
                end
                matched = true
            end
        elseif instruction.kind == "literal" then
            local next_position = match_literal_at(
                native_text, position, instruction.value)
            if next_position then
                matched = visit(instruction.next, next_position, context)
            end
        elseif instruction.kind == "spell_name" then
            local next_position, decoration = match_spell_name_at(
                native_text, position, instruction.value)
            if next_position then
                local candidate = context
                if decoration then
                    candidate = clone_match_context(context)
                    candidate.decorations[instruction.key] = decoration
                end
                matched = visit(instruction.next, next_position, candidate)
            end
        elseif instruction.kind == "choice" then
            local selected = context.decisions[instruction.key]
            for _, alternative in ipairs(instruction.alternatives) do
                if not selected or selected == alternative.decision then
                    local candidate = clone_match_context(context)
                    candidate.decisions[instruction.key] = alternative.decision
                    if visit(alternative.pc, position, candidate) then
                        matched = true
                    end
                    if exhausted then break end
                end
            end
        elseif instruction.kind == "token" then
            for next_position = position, #native_text + 1 do
                -- Dynamic values belong to one rendered tooltip line. Letting
                -- a capture cross a newline makes repeated line terminators
                -- ambiguous and can consume following optional aura rows.
                if next_position > position then
                    local previous = native_text:sub(
                        next_position - 1, next_position - 1)
                    if previous == "\r" or previous == "\n" then break end
                end
                local candidate = clone_match_context(context)
                local bucket = candidate.values[instruction.identity]
                if not bucket then
                    bucket = {}
                    candidate.values[instruction.identity] = bucket
                end
                bucket[instruction.occurrence] = native_text:sub(
                    position, next_position - 1)
                if visit(instruction.next, next_position, candidate) then
                    matched = true
                end
                if exhausted then break end
            end
        end

        if not matched and not exhausted then dead[memo_key] = true end
        return matched
    end

    visit(matcher.start, 1, {
        decisions = {}, values = {}, decorations = {},
    })
    if exhausted or #results == 0 then return nil end
    return results
end

local function cache_rendered(key, value)
    if rendered_cache[key] ~= nil then return end
    while rendered_count >= RENDERED_CACHE_LIMIT do
        local oldest = rendered_order[rendered_head]
        rendered_order[rendered_head] = nil
        rendered_head = rendered_head + 1
        if oldest and rendered_cache[oldest] ~= nil then
            rendered_cache[oldest] = nil
            rendered_count = rendered_count - 1
        end
    end
    rendered_tail = rendered_tail + 1
    rendered_order[rendered_tail] = key
    rendered_cache[key] = value or false
    rendered_count = rendered_count + 1
end

local function expand_description_references(text, getter, seen, depth)
    if type(text) ~= "string" or type(getter) ~= "function" then return text end
    if (depth or 0) >= 8 then return text end
    seen = seen or {}
    return (text:gsub("%$@spelldesc(%d+)", function (raw_id)
        local spell_id = tonumber(raw_id)
        if not spell_id or seen[spell_id] then
            return "$@spelldesc" .. raw_id
        end
        local referenced = getter(spell_id)
        if type(referenced) ~= "string" or referenced == "" then
            return "$@spelldesc" .. raw_id
        end
        seen[spell_id] = true
        local expanded = expand_description_references(
            referenced, getter, seen, (depth or 0) + 1)
        seen[spell_id] = nil
        return expanded
    end))
end

local function resolve_aura_template(english_raw, ukrainian_raw)
    local templates = addon_table.aura_sentence_templates
    if type(templates) ~= "table" then return ukrainian_raw end
    local english_lines, ukrainian_lines = {}, {}
    for line in (english_raw:gsub("\r\n", "\n") .. "\n"):gmatch("(.-)\n") do
        english_lines[#english_lines + 1] = line
    end
    for line in (ukrainian_raw:gsub("\r\n", "\n") .. "\n"):gmatch("(.-)\n") do
        ukrainian_lines[#ukrainian_lines + 1] = line
    end
    -- Partial template coverage must not discard unrelated translated effects.
    if #english_lines ~= #ukrainian_lines then return ukrainian_raw end
    local changed = false
    for index, line in ipairs(english_lines) do
        local subject, token, percent = line:match(
            "^(.+) reduced by (%$s%d+)(%%?)%.$")
        local format = subject and templates[subject]
        if format then
            ukrainian_lines[index] = format:format(token, percent)
            changed = true
        end
    end
    if not changed then return ukrainian_raw end
    local separator = ukrainian_raw:find("\r\n", 1, true) and "\r\n" or "\n"
    return table.concat(ukrainian_lines, separator)
end

renderer.render = function (
    spell_id, kind, english_raw, ukrainian_raw, native_text
)
    if is_secret_value(spell_id) or is_secret_value(kind)
        or is_secret_value(english_raw) or is_secret_value(ukrainian_raw)
        or is_secret_value(native_text) then return nil end
    if type(spell_id) ~= "number"
        or kind ~= "spell" and kind ~= "aura"
        or type(english_raw) ~= "string" or english_raw == ""
        or type(ukrainian_raw) ~= "string" or ukrainian_raw == ""
        or type(native_text) ~= "string" or native_text == "" then return nil end

    english_raw = expand_description_references(
        english_raw, client_db.get_english_description)
    ukrainian_raw = expand_description_references(
        ukrainian_raw, client_db.get_description)
    if kind == "aura" then
        ukrainian_raw = resolve_aura_template(english_raw, ukrainian_raw)
    end

    local rendered_key = kind .. ":" .. spell_id .. "\031" .. native_text
    local cached = rendered_cache[rendered_key]
    if cached ~= nil then return cached ~= false and cached or nil end

    local compiled_key = kind .. ":" .. spell_id
    local cached_plan = compiled_cache[compiled_key]
    if not cached_plan or cached_plan.english_raw ~= english_raw
        or cached_plan.ukrainian_raw ~= ukrainian_raw then
        cached_plan = {
            english_raw = english_raw,
            ukrainian_raw = ukrainian_raw,
            plan = compile_pair(english_raw, ukrainian_raw) or false,
        }
        compiled_cache[compiled_key] = cached_plan
    end
    if cached_plan.plan == false then
        cache_rendered(rendered_key, nil)
        return nil
    end

    local contexts = match_program(
        cached_plan.plan.matcher, native_text)
    if contexts then
        local translated
        for _, context in ipairs(contexts) do
            local candidate = render_nodes(
                cached_plan.plan.ukrainian,
                context.decisions, context.values, context.decorations)
            if not candidate or candidate:find("$", 1, true)
                or translated and candidate ~= translated then
                cache_rendered(rendered_key, nil)
                return nil
            end
            translated = candidate
        end
        if translated then
            cache_rendered(rendered_key, translated)
            return translated
        end
    end

    cache_rendered(rendered_key, nil)
    return nil
end

renderer.clear_rendered_cache = function ()
    rendered_cache = {}
    rendered_order = {}
    rendered_head = 1
    rendered_tail = 0
    rendered_count = 0
end

renderer.cache_stats = function ()
    local compiled_count = 0
    for _ in pairs(compiled_cache) do compiled_count = compiled_count + 1 end
    return { compiled = compiled_count, rendered = rendered_count }
end
