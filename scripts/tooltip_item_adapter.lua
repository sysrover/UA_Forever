local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local client_db = addon_table.use("item_client_db")
local spell_db = addon_table.use("spell_client_db")
local renderer = addon_table.use("spell_template_renderer")
local strings = addon_table.use("strings")
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
    local metadata = client_db.get_metadata(item_id) or {}
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
            local english_names = {}
            local translated_names = {}
            local english_display_parts = {}
            local translated_display_parts = {}
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
                english_names[#english_names + 1] = english
                translated_names[#translated_names + 1] = deps().capitalize(translated)
                -- The client omits (1), but keeps counts for other reagents.
                local quantity = count > 1 and " (" .. tostring(count) .. ")" or ""
                english_display_parts[#english_display_parts + 1] = english .. quantity
                translated_display_parts[#translated_display_parts + 1] =
                    deps().capitalize(translated) .. quantity
            end
            if complete and #english_parts > 0 then
                recipe_reagent_lines[table.concat(english_parts, ", ")] =
                    table.concat(translated_parts, ", ")
                recipe_reagent_lines[table.concat(english_names, ", ")] =
                    table.concat(translated_names, ", ")
                recipe_reagent_lines[table.concat(english_display_parts, ", ")] =
                    table.concat(translated_display_parts, ", ")
            end
        end
    end
    return cache_item(key, {
        item_id = item_id,
        english_name = client_db.get_english_name(item_id),
        translated_name = client_db.get_name(item_id),
        english_description = client_db.get_english_description(item_id),
        translated_description = client_db.get_description(item_id),
        metadata = metadata,
        item_set = client_db.get_item_set(tonumber(metadata.ItemSet) or 0),
        required_skill = tonumber(metadata.RequiredSkill) or 0,
        required_skill_rank = tonumber(metadata.RequiredSkillRank) or 0,
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
        if suffix ~= "" then
            local leading, name, trailing = suffix:match("^(%s*)(.-)(%s*)$")
            local suffix_translation = catalog.item_name_suffixes
                and catalog.item_name_suffixes[name]
            translated = translated .. (suffix_translation
                and (leading .. suffix_translation .. trailing) or suffix)
        end
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
    local native_core, cooldown = split_effect_source(source)
    local translated
    for _, kind in ipairs({ "spell", "aura" }) do
        local english, ukrainian
        if kind == "spell" then
            english = spell_db.get_english_description(spell_id)
            ukrainian = spell_db.get_description(spell_id)
        else
            english = spell_db.get_english_aura_description(spell_id)
            ukrainian = spell_db.get_aura_description(spell_id)
        end
        if english and ukrainian then
            translated = renderer.render(spell_id, kind,
                english, ukrainian, native_core)
            if translated then break end
        end
    end
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

-- Inspect tooltips also emit effect rows with type 0. Match their visible
-- prefix and full description instead of relying on an ordinal in that type.
local function translate_visible_effect(state, source)
    local label = source:match("^([^:]+):")
    if not label then return nil end
    local line_type = label == "Equip" and ITEM_SPELL_EQUIP
        or label == "Use" and ITEM_SPELL_USE
        or label == "Chance on hit" and ITEM_SPELL_PROC or nil
    if not line_type then return nil end
    local result
    for _, effect in ipairs(state.effects[line_type] or {}) do
        local translated = render_effect(effect, line_type, source)
        if translated then
            if result and result ~= translated then return nil end
            result = translated
        end
    end
    return result
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

local function translate_classification(state, source)
    if type(source) ~= "string" then return nil end
    local class_id, subclass_id = client_db.get_classification(state.item_id)
    local class = class_id and client_db.get_item_class(class_id) or nil
    if type(class) == "table" and source == class.ClassName_lang then
        return catalog.item_class_names
            and catalog.item_class_names[class_id] or nil
    end
    local subclass = class_id and subclass_id
        and client_db.get_item_subclass(class_id, subclass_id) or nil
    if type(subclass) == "table" and source == subclass.DisplayName_lang then
        local names = catalog.item_subclass_names
            and catalog.item_subclass_names[class_id]
        return names and names[subclass_id] or nil
    end
end

local function translate_set_line(state, source, region)
    local set = state.item_set
    if type(set) ~= "table" or type(source) ~= "string" then return nil end
    local name, equipped, total = source:match("^(.-) %((%d+)/(%d+)%)$")
    if name == set.name then
        local translated = catalog.item_set_names[name]
            or addon_table.use("entries").lookup_name("spell", name)
            or strings.find_ui_translation(name, region)
        if translated and translated ~= name then
            return catalog.format.item_set_name(translated, equipped, total)
        end
    end
    local indent, member = source:match("^(%s*)(.-)%s*$")
    local aliases = catalog.item_set_member_aliases
        and catalog.item_set_member_aliases[tonumber(state.metadata.ItemSet)]
    local alias_id = aliases and aliases[member]
    for _, item_id in ipairs(set.itemIDs or {}) do
        if member == client_db.get_english_name(item_id) or item_id == alias_id then
            local translated = client_db.get_name(item_id)
            return translated and indent .. deps().capitalize(translated) or nil
        end
    end
    local count, body = source:match("^%((%d+)%) Set: (.+)$")
    if not count then return nil end
    local result
    for _, bonus in ipairs(set.bonuses or {}) do
        if tonumber(bonus.Threshold) == tonumber(count) then
            local spell_id = tonumber(bonus.SpellID)
            -- Match the actual visible description. Several bonuses can have
            -- the same threshold, so never select only by piece count.
            local translated
            for _, kind in ipairs({ "spell", "aura" }) do
                local english, ukrainian
                if kind == "spell" then
                    english = spell_db.get_english_description(spell_id)
                    ukrainian = spell_db.get_description(spell_id)
                else
                    english = spell_db.get_english_aura_description(spell_id)
                    ukrainian = spell_db.get_aura_description(spell_id)
                end
                if english and ukrainian then
                    translated = renderer.render(spell_id, kind,
                        english, ukrainian, body)
                    if translated then break end
                end
            end
            if translated then
                if result and result ~= translated then return nil end
                result = translated
            end
        end
    end
    return result and catalog.format.item_set_bonus(count, result) or nil
end

local function translate_shared_line(state, source, region)
    if type(source) ~= "string" then return nil end
    local clean = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local translated = translate_set_line(state, clean, region)
    -- A translated label is not a translated bonus. Never let the generic
    -- printf/UI fallbacks claim this row with its English body intact.
    if clean:match("^%(%d+%) Set: ") then
        return catalog.restore_item_markup(source, translated)
    end
    translated = translated
        or translate_visible_effect(state, clean)
        or catalog.translate_item_line(source)
        or strings.find_ui_translation(source, region)
    if not translated and clean ~= source then
        translated = strings.find_ui_translation(clean, region)
    end
    if translated == source or translated == clean then return nil end
    return catalog.restore_item_markup(source, translated)
end

local function translate_structured(tooltip, data, state)
    local contract = deps()
    local lines = type(data) == "table" and data.lines or nil
    if type(lines) ~= "table" then return false, 0 end

    local applied = false
    local effect_indexes = {}
    local transmog_name_index
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
                if structured_source == catalog.item_transmog_header then
                    transmog_name_index = line_index + 1
                end
                local translated
                local slot

                if line_index == 1 then
                    translated = source and translated_item_name(state, source)
                    slot = "item.name"
                elseif line_type == ITEM_NAME then
                    -- Recipe tooltips include a separate result-item title.
                    -- Resolve its own native name instead of using the recipe ID.
                    if source then
                        local indent, name, trailing = source:match("^(%s*)(.-)(%s*)$")
                        local result_name = client_db.get_name_by_english(name)
                        if result_name then
                            translated = indent .. contract.capitalize(result_name) .. trailing
                        end
                    end
                    slot = "item.secondary-name:" .. line_index
                elseif source and state.english_name
                    and source == state.english_name then
                    translated = translated_item_name(state, source)
                    slot = "item.secondary-name:" .. line_index
                elseif source and line_index == transmog_name_index then
                    local clean = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                    local name = client_db.get_name_by_english(clean)
                    translated = name and catalog.restore_item_markup(
                        source, contract.capitalize(name)) or nil
                    slot = "item.transmog-name:" .. line_index
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
                        or catalog.translate_item_line(source)
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
                    -- Recipe learn lines can lack a translated spell effect.
                    -- Use the shared visible-text templates as a fallback.
                    if not translated and source then
                        translated = translate_shared_line(state, source, region)
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
                        translated = translate_classification(state, source)
                        slot = translated
                            and "item.classification:" .. line_index or nil
                    end
                    if not translated and source then
                        translated = translate_shared_line(state, source, region)
                        slot = translated and "item.shared-line:" .. line_index or nil
                    end
                end

                -- Requirements, class restrictions and set rows can use
                -- specialized TooltipData types. The fallback must run after
                -- every semantic branch, rather than only for type 0.
                if not translated and source and line_index > 1 then
                    translated = translate_shared_line(state, source, region)
                    slot = translated and "item.shared-line:" .. line_index or slot
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
                    and translate_classification(state, right_source) or nil
                right_translated = right_translated or (right_source
                    and catalog.translate_item_line(right_source) or nil)
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

-- Blizzard can append build-owned bag metadata after SetInventoryItem() has
-- completed and the Item TooltipData post-call has already run. Translate
-- only those newly appended rows when their owning OnEnter method finishes.
adapter.translate_appended_lines = function (tooltip, first_index)
    local contract = deps()
    if not tooltip or tooltip.uaForeverShowOriginal
        or not options.can_translate("translate_item")
        or options.section_enabled and not options.section_enabled("item_details") then return false end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    first_index = contract.safe_number(first_index)
    if not count or not first_index or first_index > count then return false end

    local applied = false
    for index = first_index, count do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        source = contract.safe_string(source)
        local translated = source and catalog.translate_item_line(source) or nil
        if translated and region then
            applied = contract.set_translation(
                tooltip, region, source, translated,
                "item.appended:" .. index, nil, "item-tooltip",
                nil, false, false, nil, nil, nil, ITEM_RUNTIME_FLAGS
            ) or applied
        end
    end
    return applied
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
    if options.section_enabled and not options.section_enabled("item_details")
        and not (options.capture_enabled and options.capture_enabled()) then
        if not options.section_enabled("item_names") then
            return { status="blocked", applied=false }
        end
        local state = { english_name=client_db.get_english_name(item_id),
            translated_name=client_db.get_name(item_id) }
        local applied = translate_title_fallback(tooltip, state)
        for _, line in ipairs(type(data)=="table" and data.lines or {}) do
            local index = type(line)=="table" and deps().safe_number(line.lineIndex)
            if index and index > 1 then
                local source, region = deps().tooltip_line(tooltip, "Left", index)
                source = deps().safe_string(source)
                if source and region and source == state.english_name then
                    local translated = translated_item_name(state, source)
                    if translated then
                        applied = deps().set_translation(tooltip, region, source, translated,
                            "item.secondary-name:" .. index, "item", "item-tooltip",
                            nil, false, false, nil, nil, nil, ITEM_RUNTIME_FLAGS) or applied
                    end
                end
            end
        end
        return { status=applied and "complete" or "unchanged", applied=applied }
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
        -- Server-cached ItemSparse rows can arrive after the shipped database.
        -- Their native title remains visible, but shared stat/requirement
        -- templates still belong to this adapter and must be rendered.
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
    return translated_item_name({ english_name=client_db.get_english_name(item_id),
        translated_name=client_db.get_name(item_id) }, native)
end

adapter.replace_known_name = function (item_id, source)
    if type(item_id) ~= "number" or type(source) ~= "string" then return nil end
    local english = client_db.get_english_name(item_id)
    local translated = client_db.get_name(item_id)
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
