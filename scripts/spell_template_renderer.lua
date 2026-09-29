local _, addon_table = ...

local renderer = addon_table.use("spell_template_renderer")

local compiled_cache = {}
local rendered_cache = {}
local rendered_order = {}
local rendered_head = 1
local rendered_tail = 0
local rendered_count = 0
local RENDERED_CACHE_LIMIT = 512
local MAX_VARIANTS = 64
local MAX_CAPTURES = 30

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

local function copy_segments(source)
    local result = {}
    for index, value in ipairs(source) do
        result[index] = copy_table(value)
    end
    return result
end

local function clone_variant(source)
    return {
        segments = copy_segments(source.segments),
        decisions = copy_table(source.decisions),
    }
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
                    local branches = { first }
                    position = after_first
                    if text:sub(position, position) == "[" then
                        local second, after_second, second_closed =
                            parse_sequence(position + 1, "]")
                        if not second or not second_closed then return nil end
                        branches[2] = second
                        position = after_second
                    else
                        branches[2] = {}
                    end
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
                    local key = make_key("grammar:" .. grammar_kind, identity)
                    nodes[#nodes + 1] = {
                        kind = "grammar", grammar_kind = grammar_kind,
                        identity = identity, key = key, options = options,
                    }
                    position = close + 1
                elseif prefix == "$N" then
                    nodes[#nodes + 1] = { kind = "text", value = "\n" }
                    position = position + 2
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

local function append_text(variant, value)
    if value == "" then return end
    local previous = variant.segments[#variant.segments]
    if previous and previous.kind == "text" then
        previous.value = previous.value .. value
    else
        variant.segments[#variant.segments + 1] = {
            kind = "text", value = value,
        }
    end
end

local function expand_nodes(nodes, variants)
    for _, node in ipairs(nodes) do
        if node.kind == "text" then
            for _, variant in ipairs(variants) do
                append_text(variant, node.value)
            end
        elseif node.kind == "token" then
            for _, variant in ipairs(variants) do
                variant.segments[#variant.segments + 1] = node
            end
        elseif node.kind == "grammar" then
            local expanded = {}
            for _, variant in ipairs(variants) do
                for choice, value in ipairs(node.options) do
                    if #expanded >= MAX_VARIANTS then return nil end
                    local candidate = clone_variant(variant)
                    candidate.decisions[node.key] = choice
                    append_text(candidate, value)
                    expanded[#expanded + 1] = candidate
                end
            end
            variants = expanded
        elseif node.kind == "conditional" then
            local expanded = {}
            for _, variant in ipairs(variants) do
                for choice, branch in ipairs(node.branches) do
                    if #expanded >= MAX_VARIANTS then return nil end
                    local candidate = clone_variant(variant)
                    candidate.decisions[node.key] = choice
                    local branch_variants = expand_nodes(branch, { candidate })
                    if not branch_variants then return nil end
                    for _, branch_variant in ipairs(branch_variants) do
                        if #expanded >= MAX_VARIANTS then return nil end
                        expanded[#expanded + 1] = branch_variant
                    end
                end
            end
            variants = expanded
        else
            return nil
        end
    end
    return variants
end

local function literal_pattern(text)
    local escaped = text:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
    return escaped:gsub("%s+", "%%s+")
end

local function compile_variant(variant)
    local parts = { "^" }
    local captures = {}
    local previous_was_token = false
    for _, segment in ipairs(variant.segments) do
        if segment.kind == "text" then
            parts[#parts + 1] = literal_pattern(segment.value)
            if segment.value ~= "" then previous_was_token = false end
        else
            if previous_was_token or #captures >= MAX_CAPTURES then return nil end
            parts[#parts + 1] = "(.-)"
            captures[#captures + 1] = {
                identity = segment.identity,
                occurrence = segment.occurrence,
            }
            previous_was_token = true
        end
    end
    parts[#parts + 1] = "$"
    return {
        pattern = table.concat(parts),
        captures = captures,
        decisions = variant.decisions,
    }
end

local function compile_pair(english_raw, ukrainian_raw)
    local english = parse_template(english_raw)
    local ukrainian = parse_template(ukrainian_raw)
    if not english or not ukrainian then return nil end
    local expanded = expand_nodes(english, { { segments = {}, decisions = {} } })
    if not expanded then return nil end
    local variants = {}
    for _, variant in ipairs(expanded) do
        local compiled = compile_variant(variant)
        if compiled then variants[#variants + 1] = compiled end
    end
    if #variants == 0 then return nil end
    return { ukrainian = ukrainian, variants = variants }
end

local function render_nodes(nodes, decisions, values)
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
            output[#output + 1] = value
        elseif node.kind == "conditional" then
            local choice = decisions[node.key]
            local branch = choice and node.branches[choice]
            if not branch then return nil end
            local rendered = render_nodes(branch, decisions, values)
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

local function match_variant(variant, native_text)
    if #variant.captures == 0 then
        if native_text:match(variant.pattern) then return {} end
        return nil
    end
    local captured = { native_text:match(variant.pattern) }
    if captured[1] == nil then return nil end
    local values = {}
    for index, spec in ipairs(variant.captures) do
        local bucket = values[spec.identity]
        if not bucket then
            bucket = {}
            values[spec.identity] = bucket
        end
        bucket[spec.occurrence] = captured[index]
    end
    return values
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

    for _, variant in ipairs(cached_plan.plan.variants) do
        local values = match_variant(variant, native_text)
        if values then
            local translated = render_nodes(
                cached_plan.plan.ukrainian, variant.decisions, values
            )
            if translated and not translated:find("$", 1, true) then
                cache_rendered(rendered_key, translated)
                return translated
            end
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
