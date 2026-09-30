local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local client_db = addon_table.use("item_client_db")
local spell_db = addon_table.use("spell_client_db")
local renderer = addon_table.use("spell_template_renderer")
local adapter = addon_table.use("tooltip_item_adapter")
local catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip item dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip item adapter is not configured")
end

-- Enum.TooltipDataLineType values from the Forever client UI build.
local ITEM_NAME = 22
local FLAVOR_TEXT = 37
local ITEM_SPELL_LEARN = 38
local USAGE_REQUIREMENT = 43
local ITEM_SPELL_USE = 44
local ITEM_SPELL_EQUIP = 45
local ITEM_SPELL_PROC = 46

local EFFECT_TRIGGER_BY_LINE = {
    [ITEM_SPELL_LEARN] = { [6] = true },
    [ITEM_SPELL_USE] = { [0] = true, [5] = true },
    [ITEM_SPELL_EQUIP] = { [1] = true },
    [ITEM_SPELL_PROC] = { [2] = true },
}

local EFFECT_PREFIX_BY_LINE = {
    [ITEM_SPELL_LEARN] = catalog.item_effect_prefix.learn,
    [ITEM_SPELL_USE] = catalog.item_effect_prefix.use,
    [ITEM_SPELL_EQUIP] = catalog.item_effect_prefix.equip,
    [ITEM_SPELL_PROC] = catalog.item_effect_prefix.hit,
}

local item_cache = {}
local cache_order = {}
local cache_head = 1
local cache_tail = 0
local cache_count = 0
local CACHE_LIMIT = 256
local ITEM_RUNTIME_FLAGS = {
    record_runtime = false,
    verify_after_apply = false,
    reapply_cached = true,
}

local function cache_item(key, value)
    local current = item_cache[key]
    if current then return current end
    while cache_count >= CACHE_LIMIT do
        local oldest = cache_order[cache_head]
        cache_order[cache_head] = nil
        cache_head = cache_head + 1
        if oldest and item_cache[oldest] then
            item_cache[oldest] = nil
            cache_count = cache_count - 1
        end
    end
    cache_tail = cache_tail + 1
    cache_order[cache_tail] = key
    item_cache[key] = value
    cache_count = cache_count + 1
    return value
end

local function displayed_item(tooltip, data, fallback_id)
    local contract = deps()
    local hyperlink = type(data) == "table"
        and contract.safe_string(data.hyperlink) or nil
    local guid = type(data) == "table" and contract.safe_string(data.guid) or nil
    local item_id = fallback_id
        or type(data) == "table" and (contract.safe_number(data.id)
            or contract.safe_number(data.itemID)) or nil
    local native_name

    local tooltip_util = _G.TooltipUtil
    if tooltip_util and type(tooltip_util.GetDisplayedItem) == "function" then
        local ok, found_name, found_link, found_id = pcall(
            tooltip_util.GetDisplayedItem, tooltip)
        if ok then
            native_name = contract.safe_string(found_name)
            hyperlink = contract.safe_string(found_link) or hyperlink
            item_id = contract.safe_number(found_id) or item_id
        end
    end

    local key = guid and "guid:" .. guid
        or hyperlink and "link:" .. hyperlink
        or item_id and "id:" .. tostring(item_id) or nil
    return item_id, key, native_name
end

local function make_item_state(item_id, key)
    local effects = client_db.get_spell_effects(item_id) or {}
    local metadata = client_db.get_metadata(item_id)
    local buckets = {}
    for line_type, triggers in pairs(EFFECT_TRIGGER_BY_LINE) do
        local bucket = {}
        for _, effect in ipairs(effects) do
            if type(effect) == "table" and triggers[effect.triggerType]
                and type(effect.spellID) == "number" and effect.spellID > 0 then
                bucket[#bucket + 1] = effect
            end
        end
        table.sort(bucket, function (left, right)
            local left_slot = tonumber(left.slotIndex) or 0
            local right_slot = tonumber(right.slotIndex) or 0
            if left_slot == right_slot then
                return (tonumber(left.effectID) or 0)
                    < (tonumber(right.effectID) or 0)
            end
            return left_slot < right_slot
        end)
        buckets[line_type] = bucket
    end
    local recipe_reagent_lines = {}
    for _, effect in ipairs(buckets[ITEM_SPELL_LEARN] or {}) do
        local reagents = client_db.get_spell_reagents(effect.spellID)
        if type(reagents) == "table" then
            local english_parts = {}
            local translated_parts = {}
            local complete = true
            for _, reagent in ipairs(reagents) do
                local reagent_id = type(reagent) == "table"
                    and tonumber(reagent.itemID) or nil
                local count = type(reagent) == "table"
                    and tonumber(reagent.count) or nil
                local english = reagent_id
                    and client_db.get_english_name(reagent_id) or nil
                local translated = reagent_id
                    and client_db.get_name(reagent_id) or nil
                if not english or not translated or not count or count <= 0 then
                    complete = false
                    break
                end
                english_parts[#english_parts + 1] = english
                    .. " (" .. tostring(count) .. ")"
                translated_parts[#translated_parts + 1] = deps().capitalize(
                    translated) .. " (" .. tostring(count) .. ")"
            end
            if complete and #english_parts > 0 then
                recipe_reagent_lines[table.concat(english_parts, ", ")] =
                    table.concat(translated_parts, ", ")
            end
        end
    end
    return cache_item(key, {
        item_id = item_id,
        english_name = client_db.get_english_name(item_id),
        translated_name = client_db.get_name(item_id),
        english_description = client_db.get_english_description(item_id),
        translated_description = client_db.get_description(item_id),
        required_skill = type(metadata) == "table"
            and tonumber(metadata.RequiredSkill) or nil,
        required_skill_rank = type(metadata) == "table"
            and tonumber(metadata.RequiredSkillRank) or nil,
        effects = buckets,
        recipe_reagent_lines = recipe_reagent_lines,
        rendered_lines = {},
    })
end

local function translated_item_name(state, native)
    local translated = state.translated_name
    if type(translated) ~= "string" then return nil end
    translated = deps().capitalize(translated)
    local english = state.english_name
    if type(native) == "string" and type(english) == "string"
        and native:sub(1, #english) == english then
        local suffix = native:sub(#english + 1)
        if suffix ~= "" then translated = translated .. suffix end
    end
    return translated
end

local function split_effect_source(source)
    local body = source:match("^[^:]+:%s*(.+)$") or source
    local core, amount, unit = body:match(
        "^(.-)%s*%(([%d%.,]+)%s+([%a]+)%s+[Cc]ooldown%)$")
    if not core then
        local singular, plural
        core, amount, singular, plural = body:match(
            "^(.-)%s*%(([%d%.,]+)%s+|4([^:;]+):([^;]+);%s+[Cc]ooldown%)$")
        if core then
            unit = tonumber((amount:gsub(",", "."))) == 1
                and singular or plural
        end
    end
    if core then
        return core, catalog.format.item_cooldown(amount, unit) or ""
    end
    return body, ""
end

local function render_effect(effect, line_type, source)
    if type(effect) ~= "table" or type(source) ~= "string" then return nil end
    local spell_id = effect.spellID
    local english = spell_db.get_english_description(spell_id)
    local ukrainian = spell_db.get_description(spell_id)
    local kind = "spell"
    if not english or not ukrainian then
        english = spell_db.get_english_aura_description(spell_id)
        ukrainian = spell_db.get_aura_description(spell_id)
        kind = "aura"
    end
    if not english or not ukrainian then return nil end

    local native_core, cooldown = split_effect_source(source)
    local translated = renderer.render(
        spell_id, kind, english, ukrainian, native_core)
    if not translated then return nil end
    local prefix = EFFECT_PREFIX_BY_LINE[line_type]
    return prefix and prefix .. " " .. translated .. cooldown
        or translated .. cooldown
end

local function cached_line(state, line_index, line_type, source, build)
    local cached = state.rendered_lines[line_index]
    if cached and cached.line_type == line_type and cached.source == source then
        return cached.translated ~= false and cached.translated or nil
    end
    local translated = build()
    state.rendered_lines[line_index] = {
        line_type = line_type,
        source = source,
        translated = translated or false,
    }
    return translated
end

local function escape_pattern(text)
    return (text:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1"))
end

local function translate_arg_item_names(line_data, source)
    if type(line_data) ~= "table" or type(source) ~= "string" then return nil end
    local ok, args = pcall(function () return line_data.args end)
    if not ok or type(args) ~= "table" then return nil end
    local translated = source
    local changed = false
    for _, argument in ipairs(args) do
        if type(argument) == "table" then
            local fields_ok, field, item_id = pcall(function ()
                return argument.field, argument.intVal
            end)
            field = fields_ok and type(field) == "string" and field:lower() or nil
            item_id = fields_ok and tonumber(item_id) or nil
            if field and item_id and (field == "item" or field == "itemid"
                or field:match("^item%d*id$")) then
                local english = client_db.get_english_name(item_id)
                local ukrainian = client_db.get_name(item_id)
                if english and ukrainian and translated:find(english, 1, true) then
                    translated = translated:gsub(escape_pattern(english),
                        function () return ukrainian end, 1)
                    changed = true
                end
            end
        end
    end
    return changed and translated or nil
end

local function translate_skill_requirement(state, source)
    if type(source) ~= "string" or not state.required_skill
        or state.required_skill <= 0 or not state.required_skill_rank
        or state.required_skill_rank <= 0 then return nil end
    local english_skill = client_db.get_english_skill_line(state.required_skill)
    local translated_skill = client_db.get_skill_line(state.required_skill)
    if not english_skill or not translated_skill then return nil end
    local clean = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local skill, rank = clean:match("^Requires (.-) %((%d+)%)$")
    if skill ~= english_skill or tonumber(rank) ~= state.required_skill_rank then
        return nil
    end
    return catalog.format.item_skill_requirement(
        translated_skill, state.required_skill_rank)
end

local function translate_structured(tooltip, data, state)
    local contract = deps()
    local lines = type(data) == "table" and data.lines or nil
    if type(lines) ~= "table" then return false, 0 end

    local applied = false
    local effect_indexes = {}
    local max_line_index = 0

    for _, line_data in ipairs(lines) do
        if type(line_data) == "table" then
            local line_type = contract.safe_number(line_data.type)
            local line_index = contract.safe_number(line_data.lineIndex)
            local structured_source = contract.safe_string(line_data.leftText)
            if line_index then
                max_line_index = math.max(max_line_index, line_index)
                local rendered_source, region = contract.tooltip_line(
                    tooltip, "Left", line_index)
                -- TooltipData can retain unresolved build tokens (for example
                -- $1308027d) after Blizzard has already rendered "1 hour".
                -- Claims and numeric extraction must target the actual native
                -- FontString, with structured text only as a fallback.
                local source = contract.safe_string(rendered_source)
                    or structured_source
                local translated
                local slot

                if line_type == ITEM_NAME or line_index == 1 then
                    translated = source and translated_item_name(state, source)
                    slot = "item.name"
                elseif source and state.english_name
                    and source == state.english_name then
                    translated = translated_item_name(state, source)
                    slot = "item.secondary-name:" .. line_index
                elseif line_type == FLAVOR_TEXT
                    or source and state.english_description
                        and source == state.english_description then
                    translated = state.translated_description
                    if translated and source and source:match('^".*"$') then
                        translated = '"' .. translated .. '"'
                    end
                    slot = "item.description:" .. line_index
                elseif line_type == USAGE_REQUIREMENT then
                    translated = translate_skill_requirement(state, source)
                    slot = translated
                        and "item.requirement:" .. line_index or nil
                elseif EFFECT_TRIGGER_BY_LINE[line_type] then
                    local effect_index = (effect_indexes[line_type] or 0) + 1
                    effect_indexes[line_type] = effect_index
                    local effect = state.effects[line_type]
                        and state.effects[line_type][effect_index]
                    if effect and source then
                        translated = cached_line(state, line_index, line_type,
                            source, function ()
                                return render_effect(effect, line_type, source)
                            end)
                    end
                    if not translated and state.translated_description then
                        local prefix = EFFECT_PREFIX_BY_LINE[line_type]
                        translated = prefix and prefix .. " "
                            .. state.translated_description
                            or state.translated_description
                    end
                    slot = "item.effect:" .. tostring(line_type)
                        .. ":" .. tostring(effect_index)
                else
                    translated = source
                        and state.recipe_reagent_lines[source] or nil
                    if translated then
                        slot = "item.recipe-reagents:" .. line_index
                    else
                        translated = translate_arg_item_names(line_data, source)
                        slot = translated
                            and "item.arguments:" .. line_index or nil
                    end
                    if not translated and source then
                        translated = catalog.translate_item_line(source)
                        slot = translated and "item.line:" .. line_index or nil
                    end
                end

                if translated and source and region then
                    applied = contract.set_translation(
                        tooltip, region, source, translated, slot,
                        line_index == 1 and "item" or nil,
                        "item-tooltip", nil, false, false, nil,
                        line_index == 1 and contract.item_name_visible_matches
                            or nil, nil, ITEM_RUNTIME_FLAGS
                    ) or applied
                end

                local structured_right = contract.safe_string(line_data.rightText)
                local rendered_right, right_region = contract.tooltip_line(
                    tooltip, "Right", line_index)
                local right_source = contract.safe_string(rendered_right)
                    or structured_right
                local right_translated = right_source
                    and catalog.translate_item_line(right_source) or nil
                if right_translated and right_region then
                    applied = contract.set_translation(
                        tooltip, right_region, right_source, right_translated,
                        "item.right:" .. line_index, nil, "item-tooltip",
                        nil, false, false, nil, nil, nil,
                        ITEM_RUNTIME_FLAGS
                    ) or applied
                end
            end
        end
    end
    return applied, max_line_index
end

adapter.translate_line = function (source)
    return catalog.translate_item_line(source)
end

local function translate_title_fallback(tooltip, state)
    local contract = deps()
    local source, region = contract.tooltip_line(tooltip, "Left", 1)
    source = contract.safe_string(source)
    if not source or not region then return false end
    local translated = translated_item_name(state, source)
    if not translated then return false end
    return contract.set_translation(tooltip, region, source, translated,
        "item.name", "item", "item-tooltip", nil, false, false, nil,
        contract.item_name_visible_matches, nil, ITEM_RUNTIME_FLAGS) == true
end

adapter.add = function (tooltip, data, fallback_id)
    if not tooltip or not options.can_lookup("translate_item") then
        return { status = "blocked", applied = false }
    end

    local item_id, key, native_name = displayed_item(tooltip, data, fallback_id)
    if not item_id or not key then
        return { status = "incomplete", applied = false }
    end
    local state = item_cache[key]
    if not state or state.item_id ~= item_id then
        state = make_item_state(item_id, key)
    end

    local has_translation = client_db.has_translation(item_id)
    if tooltip.uaForeverItemLoggedIdentity ~= key then
        dev_log.record_id("items", item_id, native_name, has_translation)
        tooltip.uaForeverItemLoggedIdentity = key
    end
    if not has_translation then
        dev_log.missing_item(item_id, native_name)
        return { status = "blocked", applied = false }
    end
    if not options.can_translate("translate_item") then
        return { status = "blocked", applied = false }
    end

    tooltip.uaForeverReservedFirst = 2
    tooltip.uaForeverItemIdentity = key
    local applied, line_count = translate_structured(tooltip, data, state)
    if line_count == 0 then applied = translate_title_fallback(tooltip, state) end
    local result = {
        status = applied and "complete" or "unchanged",
        applied = applied,
    }
    tooltip.uaForeverItemStatus = result.status
    tooltip.uaForeverItemCompleteGeneration = tooltip.uaForeverGeneration
    return result
end

adapter.get_translated_name = function (item_id, native)
    if type(item_id) ~= "number" then return nil end
    local key = "id:" .. tostring(item_id)
    local state = item_cache[key] or make_item_state(item_id, key)
    return translated_item_name(state, native)
end

adapter.replace_known_name = function (item_id, source)
    if type(item_id) ~= "number" or type(source) ~= "string" then return nil end
    local key = "id:" .. tostring(item_id)
    local state = item_cache[key] or make_item_state(item_id, key)
    local english = state.english_name
    local translated = state.translated_name
    if type(english) ~= "string" or english == ""
        or type(translated) ~= "string" or translated == ""
        or not source:find(english, 1, true) then return nil end
    translated = deps().capitalize(translated)
    return (source:gsub(escape_pattern(english), function ()
        return translated
    end, 1))
end

adapter.has_translation = client_db.has_translation

adapter.clear_cache = function ()
    item_cache = {}
    cache_order = {}
    cache_head = 1
    cache_tail = 0
    cache_count = 0
end
