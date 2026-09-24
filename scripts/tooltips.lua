local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local layout = addon_table.use("translation_layout")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local hooks = addon_table.use("translation_hooks").bind("tooltips")
local tooltips = addon_table.use("tooltips")
local utils = addon_table.use("utils")
local tooltip_line
local visible_tooltip_font_strings
local MAX_TOOLTIP_LINES = 40
local aura_spell_titles
local tooltip_font_strings = setmetatable({}, { __mode = "k" })
local active_tooltips = setmetatable({}, { __mode = "k" })
local tooltip_events = setmetatable({}, { __mode = "k" })

local function note_tooltip_event(tooltip, event)
    local counts = tooltip_events[tooltip] or {}
    counts[event] = (counts[event] or 0) + 1
    tooltip_events[tooltip] = counts
end

local function shift_held()
    return options.account and options.account.shift_original_tooltip ~= false
        and type(_G.IsShiftKeyDown) == "function" and _G.IsShiftKeyDown()
end

local function begin_tooltip(tooltip, key)
    if tooltip.uaForeverSessionKey == key then return end
    for region in pairs(tooltip.uaForeverClaims or {}) do
        runtime.show_original(region, true)
        runtime.clear(region)
    end
    tooltip.uaForeverSessionKey = key
    tooltip.uaForeverGeneration = runtime.next_generation(tooltip)
    tooltip.uaForeverClaims = {}
    tooltip.uaForeverFallback = {}
    tooltip.uaForeverBilingualLines = nil
    tooltip.uaForeverReservedFirst = nil
    tooltip.uaForeverShowOriginal = shift_held() or not options.can_translate()
    tooltip_font_strings[tooltip] = nil
    active_tooltips[tooltip] = true
end

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function safe_number(value)
    if is_secret(value) or value == nil then return nil end
    local ok, result = pcall(tonumber, value)
    if ok then return result end
end

local function first_template_part(text)
    if type(text) ~= "string" then return text end
    return text:match("^(.-)#") or text
end

local function make_text(text, tooltip, source_line)
    if type(text) ~= "string" then
        return nil
    end

    local ok, result = pcall(entries.make_entry_text, text, tooltip, nil, source_line)
    result = ok and result or first_template_part(text)
    if type(result) ~= "string" or result:find("{%d+}") then
        return nil
    end
    return utils.cap(result)
end

local function normalized_tooltip_text(text)
    if type(text) ~= "string" or is_secret(text) then return nil end
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function spell_name_category(tooltip)
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not ok then return "spell" end
    for _ = 1, 8 do
        if not owner then break end
        if owner == _G.PlayerSpellsFrame or owner == _G.SpellBookFrame
            or owner == _G.SkillsFrame then return "skill" end
        if type(owner.GetParent) ~= "function" then break end
        local parent_ok, parent = pcall(owner.GetParent, owner)
        if not parent_ok or parent == owner then break end
        owner = parent
    end
    return "spell"
end

local function aura_spell_id_from_title(title)
    title = normalized_tooltip_text(title)
    if not title or title == "" then return nil end

    aura_spell_titles = aura_spell_titles or {}
    local cached = aura_spell_titles[title]
    if cached ~= nil then return cached or nil end

    local best_id, best_priority
    for spell_id, raw_entry in pairs(addon_table.spell or {}) do
        if type(raw_entry) == "table"
            and (raw_entry.en == title or raw_entry[1] == title) then
            local entry = entries.get_entry("spell", spell_id)
            local priority = entry and entry[3] and 2
                or entry and entry[2] and 1 or 0
            if not best_priority or priority > best_priority then
                best_id, best_priority = spell_id, priority
                if priority == 2 then break end
            end
        end
    end

    if best_id then
        aura_spell_titles[title] = best_id
        return best_id
    end

    -- The client may resolve a shared aura name to a different spell rank.
    -- Use its name lookup only when the addon's exact English title is absent.
    if C_Spell and type(C_Spell.GetSpellInfo) == "function" then
        local ok_info, info = pcall(C_Spell.GetSpellInfo, title)
        local spell_id = ok_info and info and safe_number(info.spellID) or nil
        if spell_id then
            aura_spell_titles[title] = spell_id
            return spell_id
        end
    end

    aura_spell_titles[title] = false
    return nil
end

local function set_tooltip_translation(tooltip, region, source, translated, slot, category, owner, source_kind, allow_fallback, adjust_layout)
    if not tooltip or type(translated) ~= "string" or translated == "" then return false end
    if type(source) == "string" and not is_secret(source)
        and translated == source then return false end
    if not options.can_translate() then return false end
    slot = slot or "generic.text"
    local name_enabled = not category or not slot:match("%.name$")
        or options.translate_name(category)
    if not name_enabled then
        if region then
            if runtime.get(region) then
                runtime.show_original(region, true)
            else
                runtime.restore_source(region, source)
            end
        end
        return false
    end
    local priority = owner == "generic" and runtime.priority_for_source(source_kind)
        or runtime.PRIORITY.DOMAIN
    local option = owner == "item-tooltip" and "translate_item"
        or owner == "spell-tooltip" and "translate_spell"
        or owner == "quest-tooltip" and "translate_quest"
        or owner == "zone-tooltip" and "translate_zone" or nil
    local domain_options = owner == "npc-tooltip"
        and { "translate_npc", "translate_npc_tooltip" } or nil
    if region and not options.is_bilingual_tooltip() then
        local previous_height, previous_tooltip_height
        if adjust_layout ~= false then
            previous_height = layout.safe_dimension(region, "GetStringHeight")
                or layout.safe_dimension(region, "GetHeight")
            previous_tooltip_height = previous_height
                and layout.safe_dimension(tooltip, "GetHeight") or nil
        end
        local ok = runtime.apply(region, {
            owner = owner or "tooltip", slot = slot, source = source,
            translated = translated, priority = priority, category = category,
            option = option, options = domain_options,
            generation = tooltip.uaForeverGeneration, tooltip = tooltip,
            allow_unknown_source = true,
            after_apply = function (applied)
                if adjust_layout ~= false then
                    layout.fit_tooltip_width_to_region(tooltip, applied)
                    layout.fit_tooltip_height_to_region(tooltip, applied,
                        previous_height, previous_tooltip_height)
                    layout.fit_bag_tooltip_width(tooltip, applied, source)
                end
            end,
        })
        if ok then
            tooltip.uaForeverClaims[region] = true
            local fallback = tooltip.uaForeverFallback and tooltip.uaForeverFallback[slot]
            if fallback and fallback.region then
                runtime.set_fallback_text(fallback.region, "")
            end
            return true
        end
    end

    if allow_fallback == false then return false end

    -- A rejected generic write must not reappear as an addon-owned line when
    -- a domain or context handler already owns this FontString.
    local existing = region and runtime.get(region)
    if existing and (existing.priority > priority
        or existing.priority == priority and existing.owner ~= (owner or "tooltip")) then
        return false
    end

    if tooltip.uaForeverShowOriginal or not name_enabled then return false end
    if region and options.is_bilingual_tooltip() then
        runtime.show_original(region, true)
    end

    -- Aura FontStrings can be protected even when the tooltip exposes a
    -- public spell ID. If in-place replacement is rejected, append an
    -- addon-owned line so the Ukrainian translation remains visible. A
    -- secret source is deliberately neither compared nor included in the key.
    local key = slot
    tooltip.uaForeverBilingualLines = tooltip.uaForeverBilingualLines or {}
    if tooltip.uaForeverBilingualLines[key] then
        local fallback = tooltip.uaForeverFallback[key]
        if fallback and fallback.region then
            runtime.set_fallback_text(fallback.region, translated)
        end
        return true
    end

    local r, g, b = 1, 1, 1
    if region and type(region.GetTextColor) == "function" then
        local ok_color, red, green, blue = pcall(region.GetTextColor, region)
        if ok_color and not is_secret(red) and not is_secret(green) and not is_secret(blue)
            and type(red) == "number" and type(green) == "number" and type(blue) == "number" then
            r, g, b = red, green, blue
        end
    end

    local before = {}
    for _, existing in ipairs(visible_tooltip_font_strings(tooltip)) do
        before[existing] = true
    end
    local ok = runtime.add_fallback(tooltip, translated, r, g, b)
    if ok then
        tooltip.uaForeverBilingualLines[key] = true
        tooltip_font_strings[tooltip] = nil
        local fallback_region
        for _, candidate in ipairs(visible_tooltip_font_strings(tooltip)) do
            if not before[candidate] then fallback_region = candidate end
        end
        local count_ok, count = pcall(tooltip.NumLines, tooltip)
        if not fallback_region and count_ok and safe_number(count) then
            local _, found = tooltip_line(tooltip, "Left", count)
            fallback_region = found
        end
        tooltip.uaForeverFallback[key] = {
            region = fallback_region, translated = translated,
            category = category, slot = slot,
            option = option, options = domain_options,
            force = not options.is_bilingual_tooltip(),
        }
    end
    return ok
end

tooltips.translate_profession_recipe = function (tooltip, english)
    if not tooltip or type(english) ~= "string" or is_secret(english) then return end
    local source, region = tooltip_line(tooltip, "Left", 1)
    if not region or source ~= english then return end
    local translated = entries.lookup_name("spell", english)
        or entries.lookup_name("item", english)
    if not translated then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    tooltip.uaForeverReservedFirst = 2
    set_tooltip_translation(tooltip, region, source, utils.cap(translated),
        "skill.name", "skill", "spell-tooltip")
end

local function rewrite_generic_lines(tooltip, line_count, first_index, allow_fallback, adjust_layout)
    line_count = safe_number(line_count)
    if not line_count then
        local ok_count, value = pcall(tooltip.NumLines, tooltip)
        line_count = ok_count and safe_number(value) or nil
    end
    -- Forever can mark NumLines() as secret even when individual rendered
    -- FontStrings remain readable. A fixed upper bound avoids comparing or
    -- iterating with the protected value while still reaching those regions.
    line_count = line_count or MAX_TOOLTIP_LINES
    local applied = 0

    for index = first_index or 1, line_count do
        local left, left_region = tooltip_line(tooltip, "Left", index)
        local right, right_region = tooltip_line(tooltip, "Right", index)
        local translated_left, _, left_kind = strings.find_ui_translation(left, left_region)
        local translated_right, _, right_kind = strings.find_ui_translation(right, right_region)
        if translated_left and translated_left ~= left then
            if set_tooltip_translation(tooltip, left_region, left, translated_left,
                "generic.left:" .. index, nil, "generic", left_kind,
                allow_fallback, adjust_layout) then applied = applied + 1 end
        end
        if translated_right and translated_right ~= right then
            if set_tooltip_translation(tooltip, right_region, right, translated_right,
                "generic.right:" .. index, nil, "generic", right_kind,
                allow_fallback, adjust_layout) then applied = applied + 1 end
        end
    end
    return applied
end

local function translate_item_use(tooltip, entry, line_count)
    local use_text = entry.use
    if type(use_text) == "number" then
        local spell_entry = entries.get_entry("spell", use_text)
        use_text = spell_entry and spell_entry[2]
    end
    if type(use_text) ~= "string" then return false end

    local translated = make_text(use_text, tooltip)
    if not translated then return false end
    if not line_count then
        local ok, count = pcall(tooltip.NumLines, tooltip)
        line_count = ok and safe_number(count) or nil
    end
    for index = 2, math.min(line_count or MAX_TOOLTIP_LINES, MAX_TOOLTIP_LINES) do
        local source, region = tooltip_line(tooltip, "Left", index)
        local visible = normalized_tooltip_text(source)
        if visible and visible:match("^Use:%s*") then
            local cooldown = visible:match("%(([%d,.]+) sec Cooldown%)")
            local unit = "sec"
            if not cooldown then
                cooldown = visible:match("%(([%d,.]+) min Cooldown%)")
                unit = "min"
            end
            local description = "Використання: " .. translated
            if cooldown then
                description = description .. " (Перезарядка: " .. cooldown
                    .. (unit == "min" and " хв.)" or " с)")
            end
            return set_tooltip_translation(tooltip, region, source,
                description, "item.use", nil, "item-tooltip")
        end
    end
    return false
end

local function translate_item_lines(tooltip, entry, line_count)
    if type(entry.tooltip_lines) ~= "table" then return 0 end
    local count = line_count
    if not count then
        local ok, value = pcall(tooltip.NumLines, tooltip)
        count = ok and safe_number(value) or nil
    end
    local applied = 0
    for index = 2, math.min(count or MAX_TOOLTIP_LINES, MAX_TOOLTIP_LINES) do
        local source, region = tooltip_line(tooltip, "Left", index)
        local translated = entry.tooltip_lines[normalized_tooltip_text(source)]
        if translated and region and set_tooltip_translation(tooltip, region,
            source, translated, "item.description:" .. index, nil, "item-tooltip") then
            applied = applied + 1
        end
    end
    return applied
end

local function item_field_text(value, tooltip, source_line)
    if type(value) == "number" then
        local spell = entries.get_entry("spell", value)
        value = spell and spell[2]
    end
    return type(value) == "string" and make_text(value, tooltip, source_line) or nil
end

local function item_field_values(value)
    if type(value) == "table" then return value end
    return value and { value } or {}
end

local function item_field_source_pattern(value)
    local raw = value
    if type(value) == "number" then
        local spell = entries.get_entry("spell", value)
        raw = spell and spell[2]
    end
    local hint = type(raw) == "string" and raw:match("#([^#]+)") or nil
    if not hint or hint == "" then return nil end
    return hint:lower():gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
        :gsub("{%d+}", "[%%d,.]+")
end

local function match_item_effects(effect)
    local values = effect.values
    local lines = effect.lines
    local matched = {}
    if #values == 1 then
        if effect.used[1] then return matched end
        local pattern = item_field_source_pattern(values[1])
        if pattern then
            local found
            for _, line in ipairs(lines) do
                if line.visible:lower():find(pattern) then
                    if found then return matched end
                    found = line.index
                end
            end
            if found then matched[found] = 1 end
        elseif #lines == 1 then
            matched[lines[1].index] = 1
        end
        return matched
    end

    local candidates, hints = {}, {}
    for value_index, value in ipairs(values) do
        local pattern = item_field_source_pattern(value)
        hints[value_index] = pattern
        candidates[value_index] = {}
        if pattern and not effect.used[value_index] then
            for _, line in ipairs(lines) do
                if line.visible:lower():find(pattern) then
                    local possible = candidates[value_index]
                    possible[#possible + 1] = line.index
                end
            end
        end
    end

    local used_values = {}
    local used_count = 0
    for value_index in pairs(effect.used) do
        used_values[value_index] = true
        used_count = used_count + 1
    end
    local changed = true
    while changed do
        changed = false
        local singles, conflicts = {}, {}
        for value_index, possible in ipairs(candidates) do
            if not used_values[value_index] then
                local available
                local count = 0
                for _, line_index in ipairs(possible) do
                    if not matched[line_index] then
                        available = line_index
                        count = count + 1
                    end
                end
                if count == 1 then
                    if singles[available] then conflicts[available] = true end
                    singles[available] = value_index
                end
            end
        end
        for line_index, value_index in pairs(singles) do
            if not conflicts[line_index] then
                matched[line_index] = value_index
                used_values[value_index] = true
                changed = true
            end
        end
    end

    if #lines + used_count == #values then
        local remaining_value, remaining_line, value_count, line_count
            = nil, nil, 0, 0
        for value_index in ipairs(values) do
            if not used_values[value_index] then
                remaining_value = value_index
                value_count = value_count + 1
            end
        end
        for _, line in ipairs(lines) do
            if not matched[line.index] then
                remaining_line = line.index
                line_count = line_count + 1
            end
        end
        if value_count == 1 and line_count == 1
            and not hints[remaining_value] then
            matched[remaining_line] = remaining_value
        end
    end
    return matched
end

local function translate_item_fields(tooltip, entry, line_count)
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = line_count or (ok and safe_number(count)) or MAX_TOOLTIP_LINES
    local effects = {
        equip = { values = item_field_values(entry.equip), lines = {}, used = {},
            prefix = "Екіпірування:" },
        hit = { values = item_field_values(entry.hit), lines = {}, used = {},
            prefix = "При влучанні:" },
    }
    for index = 2, math.min(count, MAX_TOOLTIP_LINES) do
        local source, region = tooltip_line(tooltip, "Left", index)
        local visible = normalized_tooltip_text(source)
        local claim = region and runtime.get(region)
        if claim and claim.owner == "item-tooltip" then
            local equip_index = claim.slot:match("^item%.equip:(%d+)$")
            local hit_index = claim.slot:match("^item%.hit:(%d+)$")
            if equip_index then effects.equip.used[tonumber(equip_index)] = true end
            if hit_index then effects.hit.used[tonumber(hit_index)] = true end
        end
        local effect = visible and visible:match("^Equip:%s*")
            and effects.equip or visible and visible:match("^Chance on hit:%s*")
            and effects.hit or nil
        if effect then
            effect.lines[#effect.lines + 1] = { index = index, visible = visible }
        end
    end
    effects.equip.matches = match_item_effects(effects.equip)
    effects.hit.matches = match_item_effects(effects.hit)
    local applied = 0
    for index = 2, math.min(count, MAX_TOOLTIP_LINES) do
        local source, region = tooltip_line(tooltip, "Left", index)
        local visible = normalized_tooltip_text(source)
        if visible and region then
            local value, slot
            if visible:match("^Equip:%s*") then
                local effect = effects.equip
                local value_index = effect.matches[index]
                value = value_index and item_field_text(effect.values[value_index], tooltip, visible)
                if value then value = effect.prefix .. " " .. value end
                slot = value_index and "item.equip:" .. value_index
            elseif visible:match("^Chance on hit:%s*") then
                local effect = effects.hit
                local value_index = effect.matches[index]
                value = value_index and item_field_text(effect.values[value_index], tooltip, visible)
                if value then value = effect.prefix .. " " .. value end
                slot = value_index and "item.hit:" .. value_index
            elseif type(entry.flavor) == "string"
                and visible:match('^".*"$') then
                value = item_field_text(entry.flavor, tooltip)
                if value then value = '"' .. value .. '"' end
                slot = "item.flavor"
            elseif type(entry.desc) == "string"
                and (visible:match("^Adds [%d.,]+ damage per second%.?$")
                    or visible:match("^%d+ Slot Herb Bag$")) then
                local number = entry.desc:match("[%d.,]+")
                if number and visible:find(number, 1, true) then
                    value = item_field_text(entry.desc, tooltip)
                end
                slot = "item.description"
            end
            local claim = runtime.get(region)
            if value and (not claim or claim.owner ~= "item-tooltip")
                and set_tooltip_translation(tooltip, region, source, value,
                    slot, nil, "item-tooltip") then
                applied = applied + 1
            end
        end
    end
    return applied
end

local function add_item(tooltip, id)
    if not options.can_lookup("translate_item") then return false end
    local entry = entries.get_entry("item", id)
    local name
    if tooltip.GetItem then
        local ok, value = pcall(tooltip.GetItem, tooltip)
        if ok then name = value end
    end
    dev_log.record_id("items", id, name, entry ~= nil)
    if not entry then
        dev_log.missing_item(id, name)
        return false
    end
    if not options.can_translate("translate_item") then return false end
    tooltip.uaForeverReservedFirst = 2

    local title = make_text(entry[1], tooltip)
    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    line_count = ok_count and safe_number(line_count) or nil
    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    local title_applied = false
    if title and title_region then
        title_applied = set_tooltip_translation(tooltip, title_region, native_title, title,
            "item.name", "item", "item-tooltip")
    end
    local use_applied = translate_item_use(tooltip, entry, line_count)
    local description_count = translate_item_lines(tooltip, entry, line_count)
        + translate_item_fields(tooltip, entry, line_count)
    local generic_count = rewrite_generic_lines(tooltip, line_count,
        tooltip.uaForeverReservedFirst)
    -- Blizzard and its issue reporter can append or rebuild item lines after
    -- TooltipDataProcessor callbacks finish. Repeat the display-only pass on
    -- the next frame so late durability, price, comparison, and F6 lines are
    -- translated without mutating the underlying tooltip data.
    local generation = tooltip.uaForeverGeneration
    scheduler.request("tooltip-item:" .. tostring(tooltip), generation, function ()
            local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
            if shown_ok and shown then
                translate_item_use(tooltip, entry)
                translate_item_lines(tooltip, entry)
                translate_item_fields(tooltip, entry)
                rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst)
            end
        end, nil, tooltip)
    return title_applied or use_applied or description_count > 0 or generic_count > 0
end

local function translate_aura_text(entry, source)
    if type(source) ~= "string" or is_secret(source)
        or type(entry.aura_lines) ~= "table" then return nil end
    local changed = false
    local result = source:gsub("[^\r\n]+", function (line)
        local leading, content, trailing = line:match("^(%s*)(.-)(%s*)$")
        local translated = entry.aura_lines[content]
        if not translated then
            for _, rule in ipairs(entry.aura_patterns or {}) do
                local amount = content:match(rule[1])
                if amount then
                    translated = string.format(rule[2], amount)
                    break
                end
            end
        end
        if translated then
            changed = true
            return leading .. translated .. trailing
        end
        return line
    end)
    return changed and result or nil
end

local function add_spell(tooltip, id, aura)
    if not options.can_lookup("translate_spell") then return false end
    local entry = entries.get_entry("spell", id)
    local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(id)
    dev_log.record_id("spells", id, info and info.name, entry ~= nil)
    if not entry then
        dev_log.missing_spell(id, info and info.name or tostring(id))
        return false
    end
    if not options.can_translate("translate_spell") then return false end
    tooltip.uaForeverReservedFirst = 2

    local ok_count, native_line_count = pcall(tooltip.NumLines, tooltip)
    native_line_count = ok_count and safe_number(native_line_count) or nil

    local title = make_text(entry[1], tooltip)
    local applied = false

    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    if title and title_region then
        local category = spell_name_category(tooltip)
        applied = set_tooltip_translation(tooltip, title_region, native_title, title,
            category .. ".name", category, "spell-tooltip") or applied
    end

    local translated_description = make_text(aura and entry[3] or entry[2], tooltip)
    if aura and entry.aura_lines then
        -- Some auras build a separate FontString for each active benefit,
        -- while others put the same lines into one region. Translate only
        -- public lines that match this spell's reviewed templates; replacing
        -- the whole description would erase benefits added later by the game.
        for index = 2, math.min(native_line_count or MAX_TOOLTIP_LINES, MAX_TOOLTIP_LINES) do
            local native, region = tooltip_line(tooltip, "Left", index)
            local translated = translate_aura_text(entry, native)
            if translated and region then
                applied = set_tooltip_translation(tooltip, region, native, translated,
                    "spell.description:" .. index, nil, "spell-tooltip") or applied
            end
        end
    elseif aura and translated_description then
        -- Aura text can be secret even when GameTooltip:GetSpell() exposes a
        -- public spell ID. Replace its fixed description region from the ID
        -- dictionary without comparing the protected English value.
        local native_description, description_region = tooltip_line(tooltip, "Left", 2)
        if description_region then
            applied = set_tooltip_translation(tooltip, description_region,
                native_description, translated_description, "spell.description", nil, "spell-tooltip")
                or applied
        end
    else
        local source_description
        if C_Spell and C_Spell.GetSpellDescription then
            local ok_description, value = pcall(C_Spell.GetSpellDescription, id)
            if ok_description and type(value) == "string" and not is_secret(value) then
                source_description = normalized_tooltip_text(value)
            end
        end
        if translated_description and source_description and native_line_count then
            for index = 2, native_line_count do
                local text, region = tooltip_line(tooltip, "Left", index)
                if normalized_tooltip_text(text) == source_description then
                    applied = set_tooltip_translation(tooltip, region, text, translated_description,
                        "spell.description", nil, "spell-tooltip") or applied
                    break
                end
            end
        end
    end
    return rewrite_generic_lines(tooltip, native_line_count, 2) > 0 or applied
end

local function add_npc(tooltip, id)
    if not options.can_lookup("translate_npc", "translate_npc_tooltip") then return false end
    local entry = entries.get_entry("npc", id)
    local name
    if tooltip.GetUnit then
        local ok, value = pcall(tooltip.GetUnit, tooltip)
        if ok then name = value end
    end
    dev_log.record_id("npcs", id, name, entry ~= nil)
    if not entry then
        dev_log.missing_npc(id, name or tostring(id))
        return false
    end
    if not options.can_translate("translate_npc", "translate_npc_tooltip") then return false end
    tooltip.uaForeverReservedFirst = entry[2] and 3 or 2

    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    local applied = false
    if title_region then
        applied = set_tooltip_translation(tooltip, title_region,
            native_title, utils.cap(entry[1]), "npc.name", nil, "npc-tooltip") or applied
    end
    if entry[2] then
        local native_subtitle, subtitle_region = tooltip_line(tooltip, "Left", 2)
        if subtitle_region then
            applied = set_tooltip_translation(tooltip, subtitle_region,
                native_subtitle, utils.cap(entry[2]), "npc.subtitle", nil, "npc-tooltip")
                or applied
        end
    end
    -- The first line and the optional NPC profession line were already
    -- translated from the ID-backed NPC entry above. Running the generic UI
    -- dictionary over them again can append a second, conflicting machine
    -- translation (for example Stable Master -> Керівник конюшні).
    return rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst) > 0 or applied
end

local function add_quest(tooltip, id, skip_title)
    if not options.can_lookup("translate_quest") then return false end
    local entry = entries.get_entry("quest", id)
    if not entry then return false end
    if not options.can_translate("translate_quest") then return false end
    tooltip.uaForeverReservedFirst = skip_title and 1 or 2
    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    local original_getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(original_getter) == "function" then
        local ok, original_title = pcall(original_getter, id)
        if ok and type(original_title) == "string" and not is_secret(original_title) then
            native_title = original_title
        end
    end
    local title = make_text(entry[1], tooltip)
    local applied = false
    if not skip_title and title and title_region then
        applied = set_tooltip_translation(tooltip, title_region, native_title, title,
            "quest.name", "quest", "quest-tooltip")
    end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    if count_ok and type(count) == "number" then
        local objective_text = type(entry[3]) == "string" and make_text(entry[3], tooltip)
        local original_objective
        local get_index = _G.C_QuestLog and _G.C_QuestLog.GetLogIndexForQuestID
        local get_text = translation.original and translation.original["GetQuestLogQuestText"]
            or _G.GetQuestLogQuestText
        if type(get_index) == "function" and type(get_text) == "function" then
            local index_ok, log_index = pcall(get_index, id)
            if index_ok and type(log_index) == "number" then
                local text_ok, _, value = pcall(get_text, log_index)
                if text_ok and type(value) == "string" and not is_secret(value) then
                    original_objective = value
                end
            end
        end
        local prefix = type(_G.QUEST_DASH) == "string" and _G.QUEST_DASH or ""
        for index = 2, math.min(count, MAX_TOOLTIP_LINES) do
            local source, region = tooltip_line(tooltip, "Left", index)
            if type(source) == "string" and not is_secret(source) and region then
                local translated
                if objective_text and original_objective
                    and source == original_objective then
                    translated = objective_text
                elseif objective_text and original_objective and prefix ~= ""
                    and source == prefix .. original_objective then
                    translated = prefix .. objective_text
                elseif prefix ~= "" and source:sub(1, #prefix) == prefix then
                    local raw = source:sub(#prefix + 1)
                    local ok, value = pcall(entries.translate_quest_objective_task, raw)
                    if ok and type(value) == "string" and value ~= raw then
                        translated = prefix .. value
                    end
                end
                if translated and translated ~= source then
                    applied = set_tooltip_translation(tooltip, region, source,
                        translated, "quest.objective:" .. index,
                        nil, "quest-tooltip") or applied
                end
            end
        end
    end
    return rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst) > 0 or applied
end

local function id_from_guid(guid, allow_object)
    if type(guid) ~= "string" or is_secret(guid) then return nil end
    local kind, _, _, _, _, id = strsplit("-", guid)
    if kind == "Creature" or kind == "Vehicle" or (allow_object and kind == "GameObject") then
        return tonumber(id)
    end
end

local function tooltip_key(kind, id)
    return kind .. ":" .. tostring(id)
end

local function process(tooltip, data, kind)
    if not tooltip or not data then return end

    local id
    if kind == "npc" then
        id = safe_number(data.uaForeverID) or id_from_guid(data.guid)
        if not id and tooltip.GetUnit then
            local _, unit = tooltip:GetUnit()
            id = unit and utils.npc_id_from_unit_id(unit)
        end
    elseif kind == "object" then
        id = safe_number(data.uaForeverID) or id_from_guid(data.guid, true) or safe_number(data.id)
    elseif kind == "aura" then
        -- Camelot exposes secret aura values in combat. Only use a public
        -- numeric spell ID; never compare, format, or cache a secret value.
        id = safe_number(data.spellID)
        if not id and tooltip.GetSpell then
            local ok_spell, _, tooltip_spell_id = pcall(tooltip.GetSpell, tooltip)
            if ok_spell then id = safe_number(tooltip_spell_id) end
        end
        -- Some builds expose the spell directly as data.id; keep that as the
        -- last fallback because other builds use id for the aura instance.
        if not id then id = safe_number(data.id) end
    else
        id = safe_number(data.id) or safe_number(data.itemID)
            or safe_number(data.spellID) or safe_number(data.questID)
    end
    if not id then return end

    local key = tooltip_key(kind, id)
    begin_tooltip(tooltip, key)
    tooltip.uaForeverKind = kind
    tooltip.uaForeverID = id
    local translated = false
    if kind == "item" then
        translated = add_item(tooltip, id)
    elseif kind == "spell" then
        translated = add_spell(tooltip, id, false)
    elseif kind == "aura" then
        translated = add_spell(tooltip, id, true)
    elseif kind == "npc" then
        translated = add_npc(tooltip, id)
    elseif kind == "quest" then
        local entry = entries.get_entry("quest", id)
        dev_log.record_id("quests", id, data.title, entry ~= nil)
        translated = add_quest(tooltip, id, data.uaForeverSkipTitle)
    elseif kind == "object" then
        dev_log.record_id("objects", id, data.name, false)
    end
    if translated then tooltip.uaForeverKey = key end
    return translated
end

local function safe_process(tooltip, data, kind)
    local ok, result = pcall(process, tooltip, data, kind)
    if not ok then
        dev_log.issue("Forever tooltip " .. tostring(kind), tostring(result))
        return false
    end
    return result == true
end

tooltips.refresh_quest_reward = function (tooltip, button, force)
    if not tooltip or not button or button.objectType ~= "item"
        or type(button.GetID) ~= "function" then return end
    local quest_frame = _G.QuestInfoFrame
    local getter = quest_frame and quest_frame.questLog
        and _G.GetQuestLogItemLink or _G.GetQuestItemLink
    if type(getter) ~= "function" then return end
    local index_ok, index = pcall(button.GetID, button)
    if not index_ok or not safe_number(index) then return end
    local link_ok, link = pcall(getter, button.type, index)
    if not link_ok or type(link) ~= "string" or is_secret(link) then return end
    local id = safe_number(utils.item_id_from_link(link))
    local entry = id and entries.get_entry("item", id)
    if not entry then return end
    local source = tooltip_line(tooltip, "Left", 1)
    if not force and source ~= entry.en then return end
    safe_process(tooltip, { itemID = id }, "item")
end

local function translate_quest_map_tooltip(button)
    local tooltip = _G.GameTooltip
    local id = button and button.questID
    if not tooltip or type(id) ~= "number" then return end
    safe_process(tooltip, { id = id }, "quest")
end

local function visible_quest_title_matches(tooltip, id, cached)
    local current = tooltip_line(tooltip, "Left", 1)
    if type(current) ~= "string" or is_secret(current) then return false end
    if type(cached) == "string" and not is_secret(cached)
        and current == cached then return true end
    local quest_api = _G.C_QuestLog
    local get_title = quest_api and quest_api.GetTitleForQuestID
    local original = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
    local function matches(getter)
        if type(getter) == "function" then
            local ok, title = pcall(getter, id)
            return ok and not is_secret(title) and current == title
        end
    end
    if matches(get_title) or matches(original) then return true end
    local task_api = _G.C_TaskQuest
    if task_api and type(task_api.GetQuestInfoByQuestID) == "function" then
        local ok, title = pcall(task_api.GetQuestInfoByQuestID, id)
        if ok and not is_secret(title) and current == title then return true end
    end
    return false
end

local function translate_talent_quest_conditions(self, tooltip, condition_ids,
    _, group_ids)
    if not self or not tooltip or type(condition_ids) ~= "table"
        or type(self.GetAndCacheCondInfo) ~= "function"
        or type(tooltip.NumLines) ~= "function"
        or not options.can_lookup("translate_quest") then return end
    local getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or _G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID
    if type(getter) ~= "function" then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    if not count_ok or type(count) ~= "number" then return end
    local tree_name
    if type(self.GetTalentTreeID) == "function"
        and type(self.GetTraitTreeName) == "function" then
        local tree_ok, tree_id = pcall(self.GetTalentTreeID, self)
        if tree_ok then
            local name_ok, value = pcall(self.GetTraitTreeName,
                self, tree_id, group_ids)
            if name_ok then tree_name = value end
        end
    end
    for _, condition_id in ipairs(condition_ids) do
        local info_ok, info = pcall(self.GetAndCacheCondInfo,
            self, condition_id, false, tree_name)
        local id = info_ok and info and safe_number(info.questID)
        if id then
            local title_ok, native = pcall(getter, id)
            local entry = title_ok and entries.get_entry("quest", id)
            local translated = entry and make_text(entry[1], tooltip)
            if type(native) == "string" and not is_secret(native)
                and translated and native ~= translated then
                for index = 1, math.min(count, MAX_TOOLTIP_LINES) do
                    local current, region = tooltip_line(tooltip, "Left", index)
                    if type(current) == "string" and not is_secret(current)
                        and region then
                        local source = current
                        local translated_at, translated_end = source:find(translated, 1, true)
                        if translated_at then
                            source = source:sub(1, translated_at - 1) .. native
                                .. source:sub(translated_end + 1)
                        end
                        local at, ending = source:find(native, 1, true)
                        if at then
                            local translated_line = source:sub(1, at - 1)
                                .. translated .. source:sub(ending + 1)
                            if not tooltip.uaForeverSessionKey then
                                begin_tooltip(tooltip, "generic")
                            end
                            set_tooltip_translation(tooltip, region, source,
                                translated_line, "quest.name", "quest",
                                "quest-tooltip")
                            break
                        end
                    end
                end
            end
        end
    end
end

local function set_native_zone_tooltip_line(tooltip, index, native, slot)
    if type(native) ~= "string" or native == "" or is_secret(native) then return end
    local current, region = tooltip_line(tooltip, "Left", index)
    if not region or is_secret(current) or current ~= native then return end
    local previous = runtime.get(region)
    if previous and previous.owner == "zone-tooltip"
        and previous.source ~= current then
        runtime.clear(region)
        if tooltip.uaForeverClaims then tooltip.uaForeverClaims[region] = nil end
    end
    if not options.can_lookup("translate_zone") then return end
    local translated = entries.get_glossary_text(current, current, "zone")
    if type(translated) == "string" and translated ~= current then
        set_tooltip_translation(tooltip, region, current, translated,
            slot, nil, "zone-tooltip")
    end
end

local function translate_minimap_zone_tooltip()
    local tooltip = _G.GameTooltip
    local button = _G.MinimapCluster and _G.MinimapCluster.ZoneTextButton
    if not tooltip or not button or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= button then return end
    local zone_getter, sub_getter = _G.GetZoneText, _G.GetSubZoneText
    if type(zone_getter) ~= "function" or type(sub_getter) ~= "function" then return end
    local zone_ok, zone = pcall(zone_getter)
    local sub_ok, subzone = pcall(sub_getter)
    if not zone_ok or not sub_ok or is_secret(zone) or is_secret(subzone) then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    tooltip.uaForeverReservedFirst = 3
    set_native_zone_tooltip_line(tooltip, 1, zone, "zone.name")
    if subzone ~= zone then
        set_native_zone_tooltip_line(tooltip, 2, subzone, "subzone.name")
    end
end

local function translate_taxi_node_tooltip(button)
    local tooltip = _G.GameTooltip
    local getter = _G.TaxiNodeName
    if not tooltip or not button or type(getter) ~= "function"
        or type(button.GetID) ~= "function"
        or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    local id_ok, index = pcall(button.GetID, button)
    if not owner_ok or owner ~= button or not id_ok or is_secret(index) then return end
    local name_ok, native = pcall(getter, index)
    if not name_ok or is_secret(native) or type(native) ~= "string" then return end
    local current, region = tooltip_line(tooltip, "Left", 1)
    if not region or is_secret(current) or current ~= native then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    local previous = runtime.get(region)
    if previous and previous.owner == "zone-tooltip"
        and previous.source ~= native then
        runtime.clear(region)
        tooltip.uaForeverClaims[region] = nil
    end
    tooltip.uaForeverReservedFirst = 2
    if not options.can_lookup("translate_zone") then return end
    local translated = entries.translate_taxi_node_name(native)
    if type(translated) == "string" and translated ~= native then
        set_tooltip_translation(tooltip, region, native, translated,
            "zone.name", nil, "zone-tooltip")
    end
end

local function translate_bag_portrait_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not button or type(button.GetParent) ~= "function"
        or type(tooltip.GetOwner) ~= "function"
        or not options.can_lookup("translate_item") then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= button then return end
    local parent_ok, parent = pcall(button.GetParent, button)
    if not parent_ok or not parent or type(parent.GetBagID) ~= "function" then return end
    local bag_ok, bag_id = pcall(parent.GetBagID, parent)
    local container = _G.C_Container
    if not bag_ok or is_secret(bag_id) or not container
        or type(container.ContainerIDToInventoryID) ~= "function"
        or type(_G.GetInventoryItemLink) ~= "function" then return end
    local slot_ok, slot = pcall(container.ContainerIDToInventoryID, bag_id)
    if not slot_ok or is_secret(slot) then return end
    local link_ok, link = pcall(_G.GetInventoryItemLink, "player", slot)
    if not link_ok or is_secret(link) or type(link) ~= "string" then return end
    local id = utils.item_id_from_link(link)
    local entry = id and entries.get_entry("item", id)
    if not entry or not entry[1] then return end
    local item_api = _G.C_Item
    if not item_api or type(item_api.GetItemInfo) ~= "function" then return end
    local name_ok, native = pcall(item_api.GetItemInfo, link)
    if not name_ok or is_secret(native) or type(native) ~= "string" then return end
    local current, region = tooltip_line(tooltip, "Left", 1)
    if not region or is_secret(current) or type(current) ~= "string"
        or current:sub(1, #native) ~= native then return end
    local translated = make_text(entry[1], tooltip)
    if not translated or translated == native then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    tooltip.uaForeverReservedFirst = 2
    set_tooltip_translation(tooltip, region, current,
        translated .. current:sub(#native + 1),
        "item.name", "item", "item-tooltip")
end

local function translate_guild_news_zone(button)
    local news = button and button.newsInfo
    local data = news and news.data
    if not data or news.newsType ~= _G.NEWS_DUNGEON_ENCOUNTER
        or not options.can_lookup("translate_zone") then return end
    local getter = translation.original and translation.original.GetRealZoneText
        or _G.GetRealZoneText
    if type(getter) ~= "function" then return end
    local ok, native = pcall(getter, data[1])
    if not ok or is_secret(native) or type(native) ~= "string" then return end
    local translated = entries.get_glossary_text(native, native, "zone")
    if type(translated) ~= "string" or translated == native then return end
    if type(data[2]) == "number" and not is_secret(data[2])
        and data[2] > 0 then
        local frame_ok, frame = pcall(function ()
            return button:GetParent():GetParent():GetParent()
        end)
        local model = frame_ok and frame and frame.BossModel
        local region = model and model.TextFrame and model.TextFrame.BossLocationText
        if not region or type(region.GetText) ~= "function" then return end
        local text_ok, current = pcall(region.GetText, region)
        if not text_ok or is_secret(current)
            or (current ~= native and current ~= translated) then return end
        runtime.clear(region)
        runtime.apply(region, {
            owner = "zone-guild-news", slot = "zone.name",
            source = native, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
        return
    end
    local tooltip = _G.GameTooltip
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= button then return end
    local current, region = tooltip_line(tooltip, "Left", 2)
    if not region or is_secret(current)
        or (current ~= native and current ~= translated) then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    set_tooltip_translation(tooltip, region, native, translated,
        "zone.name", nil, "zone-tooltip")
end

local function translate_adventure_zone_pin(pin)
    local tooltip = _G.GameTooltip
    local native = pin and pin.title
    if not tooltip or type(native) ~= "string" or is_secret(native)
        or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= pin then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    set_native_zone_tooltip_line(tooltip, 1, native, "zone.name")
end

local function translate_flight_map_tooltip(self)
    local tooltip = _G.GameTooltip
    if not tooltip or not self or type(self.GetMap) ~= "function" then return end
    local map_ok, map = pcall(self.GetMap, self)
    if not map or not map_ok or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= map then return end
    local id_ok, map_id = pcall(map.GetMapID, map)
    local pos_ok, x, y = pcall(map.GetNormalizedCursorPosition, map)
    if not id_ok or not pos_ok or is_secret(map_id) or is_secret(x)
        or is_secret(y) or type(map_id) ~= "number" then return end
    local api = _G.C_Map
    if not api or type(api.GetMapInfoAtPosition) ~= "function" then return end
    local info_ok, info = pcall(api.GetMapInfoAtPosition, map_id, x, y)
    if not info_ok or not info or is_secret(info) then return end
    local name_ok, sub_map_id, native_name = pcall(function ()
        return info.mapID, info.name
    end)
    if not name_ok or is_secret(sub_map_id) or is_secret(native_name)
        or sub_map_id == map_id or type(native_name) ~= "string" then return end
    local current, region = tooltip_line(tooltip, "Left", 1)
    if not region or is_secret(current) or current ~= native_name then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    tooltip.uaForeverReservedFirst = 2
    set_native_zone_tooltip_line(tooltip, 1, native_name, "zone.name")
end

local function prepare_quest_map_hook()
    hooks.global("GameTooltip_AddQuest", function (self)
            local id = self and self.questID
            if type(id) == "number" then
                safe_process(_G.GameTooltip, { id = id }, "quest")
            end
        end)
    hooks.global("QuestMapLogTitleButton_OnEnter", translate_quest_map_tooltip)
    hooks.region(_G.QuestPinMixin, "OnMouseEnter", function (self)
            local get_id = self and self.GetQuestID
            if type(get_id) ~= "function" then return end
            local id_ok, id = pcall(get_id, self)
            if id_ok and type(id) == "number" then
                safe_process(_G.GameTooltip, { id = id }, "quest")
            end
        end)
    hooks.region(_G.QuestBlobPinMixin, "UpdateTooltip", function (self)
            local tooltip = _G.GameTooltip
            if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
            local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
            if not owner_ok or owner ~= self then return end
            local shown_title = tooltip_line(tooltip, "Left", 1)
            if type(shown_title) ~= "string" or is_secret(shown_title) then return end
            local current_getter = _G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID
            if type(current_getter) ~= "function" then return end
            local original_getter = translation.original
                and translation.original["C_QuestLog.GetTitleForQuestID"]
            local candidates = {}
            local function add_candidate(id)
                if type(id) == "number" and not is_secret(id) and id > 0 then
                    candidates[#candidates + 1] = id
                end
            end
            add_candidate(self.questID)
            add_candidate(self.focusedQuestID)
            add_candidate(self.highlightedQuestID)
            add_candidate(self.highlightedQuestPOI)
            local highlight = _G.POIButtonHighlightManager
            if highlight and type(highlight.GetQuestID) == "function" then
                local id_ok, id = pcall(highlight.GetQuestID, highlight)
                if id_ok then add_candidate(id) end
            end
            local seen = {}
            for _, id in ipairs(candidates) do
                if not seen[id] then
                    seen[id] = true
                    local title_ok, title = pcall(current_getter, id)
                    local original_ok, original
                    if type(original_getter) == "function" then
                        original_ok, original = pcall(original_getter, id)
                    end
                    if (title_ok and not is_secret(title) and title == shown_title)
                        or (original_ok and not is_secret(original)
                            and original == shown_title) then
                        safe_process(tooltip, { id = id }, "quest")
                        return
                    end
                end
            end
        end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowBountyTooltip",
        function (self, index)
                local data = self.bounties and self.bounties[index]
                local id = data and data.questID
                if type(id) == "number" then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowLockedByQuestTooltip",
        function (self)
                local id = self.lockedQuestID
                if type(id) == "number" then
                    safe_process(_G.GameTooltip,
                        { id = id, uaForeverSkipTitle = true }, "quest")
                end
        end)
    hooks.region(_G.FlightMap_ZoneSummaryDataProvider, "CheckMouse",
        translate_flight_map_tooltip)
    hooks.global("Minimap_SetTooltip", translate_minimap_zone_tooltip)
    hooks.global("TaxiNodeOnButtonEnter", translate_taxi_node_tooltip)
    hooks.region(_G.ContainerFramePortraitButtonMixin, "OnEnter",
        translate_bag_portrait_tooltip)
    hooks.global("CommunitiesGuildNewsButton_OnEnter", translate_guild_news_zone)
    hooks.region(_G.AdventureMap_ZoneSummaryPinMixin, "OnMouseEnter",
        translate_adventure_zone_pin)
    hooks.region(_G.RecruitActivityButtonMixin, "OnEnter",
        function (self)
                local id = self and self.activityInfo
                    and self.activityInfo.rewardQuestID
                local tooltip = _G.EmbeddedItemTooltip
                if type(id) ~= "number" or is_secret(id) or not tooltip
                    or type(tooltip.GetOwner) ~= "function" then return end
                local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
                if owner_ok and owner == self
                    and visible_quest_title_matches(tooltip, id, self.questName) then
                    safe_process(tooltip, { id = id }, "quest")
                end
        end)
    hooks.global("CallingPOI_OnEnter", function (pin)
                local id = pin and pin.questID
                if type(id) == "number" and not is_secret(id) and _G.GameTooltip
                    and visible_quest_title_matches(_G.GameTooltip, id) then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.CovenantCallingQuestMixin, "UpdateTooltipQuestActive",
        function (self)
                local id = self and self.calling and self.calling.questID
                if type(id) == "number" and not is_secret(id) and _G.GameTooltip
                    and visible_quest_title_matches(_G.GameTooltip, id) then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.TalentFrameBaseMixin, "AddConditionsToTooltip",
        translate_talent_quest_conditions)
end

local function reset_tooltip(self)
    scheduler.cancel("tooltip:" .. tostring(self))
    scheduler.cancel("tooltip-late:" .. tostring(self))
    scheduler.cancel("tooltip-item:" .. tostring(self))
    scheduler.cancel("tooltip-aura:" .. tostring(self))
    for region in pairs(self.uaForeverClaims or {}) do runtime.clear(region) end
    runtime.clear_surface(self)
    self.uaForeverGeneration = runtime.generation(self)
    active_tooltips[self] = nil
    self.uaForeverSessionKey = nil
    self.uaForeverKind = nil
    self.uaForeverID = nil
    self.uaForeverReservedFirst = nil
    self.uaForeverClaims = nil
    self.uaForeverFallback = nil
    self.uaForeverShowOriginal = nil
    self.uaForeverKey = nil
    self.uaForeverAuraRetryKey = nil
    self.uaForeverGenericText = nil
    self.uaForeverBilingualLines = nil
    tooltip_font_strings[self] = nil
end

local function object_is_font_string(region)
    if not region or type(region.GetObjectType) ~= "function" then return false end
    local ok, object_type = pcall(region.GetObjectType, region)
    return ok and object_type == "FontString"
end

visible_tooltip_font_strings = function (tooltip)
    local cached = tooltip_font_strings[tooltip]
    if cached then return cached end

    local result = {}
    local seen = {}

    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 4 then return end
        seen[frame] = true

        if frame.GetRegions then
            local ok_regions, regions = pcall(function () return { frame:GetRegions() } end)
            if ok_regions then
                for _, region in ipairs(regions) do
                    if object_is_font_string(region) then
                        local shown_ok, shown = pcall(region.IsShown, region)
                        if shown_ok and shown then result[#result + 1] = region end
                    end
                end
            end
        end

        if frame.GetChildren then
            local ok_children, children = pcall(function () return { frame:GetChildren() } end)
            if ok_children then
                for _, child in ipairs(children) do
                    local shown_ok, shown = pcall(child.IsShown, child)
                    if shown_ok and shown then visit(child, depth + 1) end
                end
            end
        end
    end

    visit(tooltip, 1)
    tooltip_font_strings[tooltip] = result
    return result
end

tooltip_line = function (tooltip, side, index)
    local region
    if tooltip.GetName then
        local ok_name, name = pcall(tooltip.GetName, tooltip)
        if ok_name and type(name) == "string" and name ~= "" then
            region = _G[name .. "Text" .. side .. tostring(index)]
            if region and region.IsShown then
                local shown_ok, shown = pcall(region.IsShown, region)
                if not shown_ok or not shown then region = nil end
            end
        end
    end

    -- Some Forever/Camelot aura tooltips use anonymous FontStrings instead
    -- of the traditional GameTooltipTextLeftN globals. Resolve those visible
    -- regions by their rendered order so ID-backed translations can still be
    -- written without reading or comparing secret aura text.
    if not region and side == "Left" then
        region = visible_tooltip_font_strings(tooltip)[index]
    end
    if not region or not region.GetText then return nil, region end
    local ok_text, text = pcall(region.GetText, region)
    if not ok_text then return nil, region end
    return text, region
end

tooltips.inspect = function (tooltip, limit)
    if not tooltip then return {} end
    local ok_count, count = pcall(tooltip.NumLines, tooltip)
    count = ok_count and safe_number(count) or nil
    count = math.min(count or MAX_TOOLTIP_LINES, safe_number(limit) or 12,
        MAX_TOOLTIP_LINES)
    local result = {}
    for index = 1, count do
        for _, side in ipairs({ "Left", "Right" }) do
            local visible, region = tooltip_line(tooltip, side, index)
            local claim = region and runtime.get(region)
            if is_secret(visible) then visible = nil end
            if type(visible) == "string" and visible ~= "" or claim then
                result[#result + 1] = {
                    index = index, side = side,
                    visible = type(visible) == "string" and visible or nil,
                    owner = claim and claim.owner or nil,
                    slot = claim and claim.slot or nil,
                    source = claim and not is_secret(claim.source)
                        and claim.source or nil,
                    translated = claim and not is_secret(claim.translated)
                        and claim.translated or nil,
                }
            end
        end
    end
    return result
end

-- Forever uses one display style for every tooltip: replace known visible
-- FontStrings in place. Domain post-calls run after Blizzard has populated the
-- tooltip, while this generic pass covers ordinary SetText tooltips.
local function translate_generic_tooltip(tooltip)
    if not tooltip then return end
    note_tooltip_event(tooltip, "finalize")
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    if tooltip.uaForeverShowOriginal then return end

    -- Settings uses its own GameTooltip frame with UI text, not item or aura
    -- data. Resolve every rendered line directly through the UI dictionary.
    if tooltip == _G.SettingsTooltip then
        rewrite_generic_lines(tooltip)
        return
    end

    if tooltip.uaForeverKind == "item" or tooltip.uaForeverKind == "spell"
        or tooltip.uaForeverKind == "npc"
        or tooltip.uaForeverKind == "quest" then
        rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst or 2)
        return
    end

    local left_title = tooltip_line(tooltip, "Left", 1)
    local cast_spell = false
    for index = 2, 6 do
        local line = tooltip_line(tooltip, "Left", index)
        local visible = normalized_tooltip_text(line)
        if visible and (visible:match("^%d+ Rage$")
            or visible:match("^%d+ Mana$")
            or visible:match("^%d+ Energy$")
            or visible:match("^%d+ Focus$")
            or visible:match("^Requires .+ Stance")
            or visible == "Melee Range" or visible == "Instant") then
            cast_spell = true
            break
        end
    end

    -- Unlike older Classic clients, Forever makes aura data secret and taints
    -- secure aura consumers when an addon registers a UnitAura post-call.
    -- Prefer the public spell ID from the already-built tooltip. Some player
    -- aura tooltips expose no public ID, so fall back to the rendered title
    -- and the addon's own spell dictionary without querying protected auras.
    local spell_id
    if type(tooltip.GetSpell) == "function" then
        local ok_spell, _, tooltip_spell_id = pcall(tooltip.GetSpell, tooltip)
        spell_id = ok_spell and safe_number(tooltip_spell_id) or nil
    end
    if cast_spell and (not spell_id or not entries.get_entry("spell", spell_id))
        and type(left_title) == "string" and not is_secret(left_title)
        and C_Spell and type(C_Spell.GetSpellInfo) == "function" then
        local ok_info, info = pcall(C_Spell.GetSpellInfo, left_title)
        local resolved = ok_info and info and safe_number(info.spellID) or nil
        if resolved and entries.get_entry("spell", resolved) then spell_id = resolved end
    end
    if not spell_id or not entries.get_entry("spell", spell_id) then
        spell_id = aura_spell_id_from_title(left_title) or spell_id
    end
    if spell_id then
        local kind = cast_spell and "spell" or "aura"
        if safe_process(tooltip, { spellID = spell_id }, kind) then
            if cast_spell then return end
            local retry_key = tooltip_key("aura", spell_id)
            if tooltip.uaForeverAuraRetryKey ~= retry_key then
                tooltip.uaForeverAuraRetryKey = retry_key
                local generation = tooltip.uaForeverGeneration
                scheduler.request("tooltip-aura:" .. tostring(tooltip), generation, function ()
                    local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
                    if shown_ok and shown then
                        tooltip_font_strings[tooltip] = nil
                        safe_process(tooltip, { spellID = spell_id }, "aura")
                    end
                end, nil, tooltip)
            end
            return
        end
    end

    if type(left_title) ~= "string" or is_secret(left_title) then return end
    if left_title == "" then return end

    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    if not ok_count or type(line_count) ~= "number" or is_secret(line_count)
        or line_count < 1 then return end

    rewrite_generic_lines(tooltip, line_count, tooltip.uaForeverReservedFirst)
end

tooltips.finalize = translate_generic_tooltip

local refreshing_comparison = false
local function is_shopping_tooltip(tooltip)
    return tooltip == _G.ShoppingTooltip1 or tooltip == _G.ShoppingTooltip2
end

local function after_comparison_refresh(manager)
    if refreshing_comparison or not manager or not manager.tooltip then return end
    refreshing_comparison = true
    local ok_refresh, refresh_error = pcall(function ()
        for _, comparison in ipairs(manager.tooltip.shoppingTooltips or {}) do
            local ok, shown = pcall(comparison.IsShown, comparison)
            if ok and shown then
                if not comparison.uaForeverSessionKey then
                    begin_tooltip(comparison, "generic")
                end
                local source, region = tooltip_line(comparison, "Left", 1)
                local translated = source and not is_secret(source)
                    and entries.lookup_name("item", source)
                if translated then
                    set_tooltip_translation(comparison, region, source,
                        utils.cap(translated), "item.name", "item",
                        "item-tooltip", nil, false, false)
                end
                local header = comparison.CompareHeader
                local label = header and header.Label
                if label and type(label.GetText) == "function" then
                    local ok_text, header_source = pcall(label.GetText, label)
                    if ok_text and type(header_source) == "string"
                        and not is_secret(header_source) then
                        local header_text, _, source_kind =
                            strings.find_ui_translation(header_source, label)
                        if header_text then
                            set_tooltip_translation(comparison, label, header_source,
                                header_text, "comparison.header", nil, "generic",
                                source_kind, false, false)
                        end
                    end
                end
                -- The comparison manager has finished every native write,
                -- including delta lines. Replace them in this same frame only.
                rewrite_generic_lines(comparison, nil, 2, false, false)
            end
        end
    end)
    refreshing_comparison = false
    if not ok_refresh then
        dev_log.issue("Forever comparison tooltip", tostring(refresh_error))
    end
end

tooltips.aura_probe_candidate = function (tooltip)
    if not tooltip or type(tooltip.IsShown) ~= "function" then return false end
    local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
    if not ok_shown or shown ~= true then return false end
    if type(tooltip.GetSpell) == "function" then
        local ok_spell, _, spell_id = pcall(tooltip.GetSpell, tooltip)
        spell_id = ok_spell and safe_number(spell_id) or nil
        if spell_id and entries.get_entry("spell", spell_id) then return true end
    end
    local title = tooltip_line(tooltip, "Left", 1)
    return aura_spell_id_from_title(title) ~= nil
end

-- Explicit, bounded capture for aura tooltips. Values marked secret are never
-- formatted or stored; the player can save this through /uaf aura while hovering.
tooltips.capture_aura = function (tooltip)
    if not tooltip then return nil end
    local function snapshot()
        local result = {
            prepared = tooltips.prepared == true,
            events = {}, lines = {},
        }
        for event, count in pairs(tooltip_events[tooltip] or {}) do
            result.events[event] = count
        end
        local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
        result.shown = ok_shown and shown == true
        local kind = tooltip.uaForeverKind
        if type(kind) == "string" and not is_secret(kind) then result.kind = kind end
        result.id = safe_number(tooltip.uaForeverID)
        result.translated = tooltip.uaForeverKey ~= nil
        result.original = tooltip.uaForeverShowOriginal == true
        result.getSpell = type(tooltip.GetSpell) == "function"
        if result.getSpell then
            local ok_spell, name, spell_id = pcall(tooltip.GetSpell, tooltip)
            result.getSpellOK = ok_spell
            if ok_spell then
                result.spellID = safe_number(spell_id)
                if type(name) == "string" and not is_secret(name) then
                    result.spellName = name
                end
            end
        end
        local ok_count, count = pcall(tooltip.NumLines, tooltip)
        result.numLines = ok_count and safe_number(count) or nil
        for index = 1, math.min(result.numLines or 20, 20) do
            for _, side in ipairs({ "Left", "Right" }) do
                local value, region = tooltip_line(tooltip, side, index)
                if region then
                    local claim = runtime.get(region)
                    local secret = is_secret(value)
                    local row = { index = index, side = side, secret = secret }
                    if not secret and type(value) == "string" then row.text = value end
                    if claim then
                        if type(claim.owner) == "string" and not is_secret(claim.owner) then
                            row.owner = claim.owner
                        end
                        if type(claim.slot) == "string" and not is_secret(claim.slot) then
                            row.slot = claim.slot
                        end
                    end
                    result.lines[#result.lines + 1] = row
                end
            end
        end
        local first = result.lines[1]
        if first and first.side == "Left" and first.text then
            result.titleID = aura_spell_id_from_title(first.text)
        end
        return result
    end
    local report = { before = snapshot() }
    translate_generic_tooltip(tooltip)
    report.after = snapshot()
    if UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.auraProbe = report
    end
    return report
end

local function public_object_value(object, method)
    if not object then return nil end
    local ok_method, callback = pcall(function () return object[method] end)
    if not ok_method or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, object)
    if ok and not is_secret(value) then return value end
end

local function object_label(object)
    local debug_name = public_object_value(object, "GetDebugName")
    if type(debug_name) == "string" then return debug_name end
    local name = public_object_value(object, "GetName")
    return type(name) == "string" and name or "<anonymous>"
end

local function object_list(object, method)
    if not object then return {} end
    local ok_method, callback = pcall(function () return object[method] end)
    if not ok_method or type(callback) ~= "function" then return {} end
    local ok, result = pcall(function () return { callback(object) } end)
    return ok and result or {}
end

local function visible_tooltip_window()
    for _, name in ipairs({ "GameTooltip", "SettingsTooltip", "ItemRefTooltip",
        "ShoppingTooltip1", "ShoppingTooltip2", "EmbeddedItemTooltip",
        "BuffFrameTooltip" }) do
        local candidate = _G[name]
        if candidate and public_object_value(candidate, "IsShown") == true then
            return candidate
        end
    end
    for _, candidate in ipairs(object_list(_G.UIParent, "GetChildren")) do
        if public_object_value(candidate, "IsShown") == true then
            local object_type = public_object_value(candidate, "GetObjectType")
            local name = object_label(candidate)
            if object_type == "GameTooltip"
                or type(name) == "string" and name:find("Tooltip", 1, true) then
                return candidate
            end
        end
    end
end

tooltips.visible_window = visible_tooltip_window

-- One-shot diagnostic of every object under the visible tooltip window.
-- It never formats protected values and records only a marker for secret text.
tooltips.scan_window = function (save)
    local root = visible_tooltip_window()
    local report = { status = root and "captured" or "no_tooltip",
        root = root and object_label(root) or nil, objects = {}, topLevel = {} }
    for _, frame in ipairs(object_list(_G.UIParent, "GetChildren")) do
        if public_object_value(frame, "IsShown") == true then
            report.topLevel[#report.topLevel + 1] = {
                name = object_label(frame),
                kind = public_object_value(frame, "GetObjectType"),
            }
        end
    end
    local focus
    if type(_G.GetMouseFocus) == "function" then
        local ok, value = pcall(_G.GetMouseFocus)
        if ok and not is_secret(value) then focus = value end
    end
    if not focus and type(_G.GetMouseFoci) == "function" then
        local ok, values = pcall(_G.GetMouseFoci)
        if ok and type(values) == "table" then focus = values[1] end
    end
    if focus then report.mouseFocus = object_label(focus) end
    if root then
        local owner = public_object_value(root, "GetOwner")
        if owner then report.owner = object_label(owner) end
        local seen = {}
        local function visit(object, path, depth)
            if not object or seen[object] or #report.objects >= 3000 then return end
            seen[object] = true
            local row = {
                path = path, name = object_label(object),
                kind = public_object_value(object, "GetObjectType"),
                shown = public_object_value(object, "IsShown") == true,
            }
            for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
                row[measure] = safe_number(public_object_value(object, measure))
            end
            local ok_text, value = pcall(function ()
                return type(object.GetText) == "function" and object:GetText() or nil
            end)
            if ok_text then
                if is_secret(value) then
                    row.secretText = true
                elseif type(value) == "string" then
                    row.text = value:sub(1, 1000)
                    if #value > 1000 then row.textTruncated = true end
                end
            end
            report.objects[#report.objects + 1] = row
            if depth >= 20 then return end
            for index, region in ipairs(object_list(object, "GetRegions")) do
                visit(region, path .. "/region:" .. index, depth + 1)
            end
            for index, child in ipairs(object_list(object, "GetChildren")) do
                visit(child, path .. "/child:" .. index, depth + 1)
            end
        end
        visit(root, "root", 0)
        report.truncated = #report.objects >= 3000
    end
    if save ~= false and UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.windowProbe = report
    end
    return report
end

local function schedule_tooltip_finalize(tooltip)
    local generation = tooltip.uaForeverGeneration
    local function finalize()
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if ok and shown then
            translate_generic_tooltip(tooltip)
        end
    end
    scheduler.request("tooltip:" .. tostring(tooltip), generation,
        finalize, nil, tooltip)
    -- Some aura FontStrings arrive after the first deferred pass without
    -- another OnShow or OnTooltipCleared event. Retry once, for this generation.
    scheduler.request("tooltip-late:" .. tostring(tooltip), generation,
        finalize, 0.2, tooltip)
end

local function prepare_tooltip_frames()
    for _, name in ipairs({ "GameTooltip", "SettingsTooltip", "ItemRefTooltip",
        "ShoppingTooltip1", "ShoppingTooltip2", "EmbeddedItemTooltip",
        "BuffFrameTooltip" }) do
        local tooltip = _G[name]
        if tooltip then
            hooks.region_script(tooltip, "OnShow", function (self)
                note_tooltip_event(self, "onShow")
                if not self.uaForeverSessionKey then begin_tooltip(self, "generic") end
                if not is_shopping_tooltip(self) then
                    schedule_tooltip_finalize(self)
                end
            end)
            hooks.region_script(tooltip, "OnTooltipCleared", function (self)
                    note_tooltip_event(self, "onTooltipCleared")
                    reset_tooltip(self)
                    if not is_shopping_tooltip(self) then
                        schedule_tooltip_finalize(self)
                    end
                end)
            hooks.region_script(tooltip, "OnHide", reset_tooltip)
            -- Setter callbacks ignore their potentially secret aura arguments.
            for _, method in ipairs({ "SetUnitAuraByAuraInstanceID",
                "SetUnitBuffByAuraInstanceID", "SetUnitDebuffByAuraInstanceID", "SetUnitAura",
                "SetUnitBuff", "SetUnitDebuff" }) do
                hooks.region(tooltip, method, function (self)
                    note_tooltip_event(self, "auraMethod")
                    local shown_ok, shown = pcall(self.IsShown, self)
                    if shown_ok and shown then
                        translate_generic_tooltip(self)
                        if self.uaForeverKind == "aura" and self.uaForeverKey then
                            scheduler.cancel("tooltip:" .. tostring(self))
                            scheduler.cancel("tooltip-late:" .. tostring(self))
                        end
                    end
                end)
            end
        end
    end
end

local function after_game_tooltip_update(tooltip)
    if tooltip ~= _G.GameTooltip or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if owner_ok and owner and owner.objectType == "item"
        and owner.questID then
        tooltips.refresh_quest_reward(tooltip, owner)
    end
end

tooltips.prepare = function ()
    prepare_quest_map_hook()
    prepare_tooltip_frames()
    hooks.region(_G.TooltipComparisonManager, "RefreshItems",
        after_comparison_refresh)
    hooks.region_script(_G.GameTooltip, "OnUpdate", after_game_tooltip_update,
        "quest-reward")
    if tooltips.prepared then return end

    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType then
        dev_log.issue("TooltipDataProcessor недоступний")
        return
    end
    tooltips.prepared = true

    local types = Enum.TooltipDataType
    if types.Item then
        TooltipDataProcessor.AddTooltipPostCall(types.Item, function (tooltip, data)
            if not is_shopping_tooltip(tooltip) then
                safe_process(tooltip, data, "item")
            end
        end)
    end
    if types.Spell then
        TooltipDataProcessor.AddTooltipPostCall(types.Spell, function (tooltip, data)
            safe_process(tooltip, data, "spell")
        end)
    end
    -- Do not register Enum.TooltipDataType.UnitAura here. On Camelot/Forever
    -- that callback taints Blizzard's secret aura update path. Aura tooltips
    -- are handled by the tooltip setter post-hooks below and the generic pass.
    if types.Unit then
        TooltipDataProcessor.AddTooltipPostCall(types.Unit, function (tooltip, data)
            safe_process(tooltip, data, "npc")
        end)
    end
    if types.Quest then
        TooltipDataProcessor.AddTooltipPostCall(types.Quest, function (tooltip, data)
            safe_process(tooltip, data, "quest")
        end)
    end
    if types.Object then
        TooltipDataProcessor.AddTooltipPostCall(types.Object, function (tooltip, data)
            safe_process(tooltip, data, "object")
        end)
    end

    local shift_frame = CreateFrame("Frame")
    shift_frame:RegisterEvent("MODIFIER_STATE_CHANGED")
    shift_frame:SetScript("OnEvent", function (_, _, key)
        if key ~= "LSHIFT" and key ~= "RSHIFT" then return end
        tooltips.refresh_active()
    end)
end

tooltips.refresh_active = function ()
    local show = shift_held() or not options.can_translate()
    for tooltip in pairs(active_tooltips) do
        tooltip.uaForeverShowOriginal = show
        for region in pairs(tooltip.uaForeverClaims or {}) do
            local claim = runtime.get(region)
            local disabled = claim and claim.option
                and not options.can_translate(claim.option)
            for _, option in ipairs(claim and claim.options or {}) do
                if not options.can_translate(option) then disabled = true end
            end
            runtime.show_original(region,
                show or disabled or options.is_bilingual_tooltip())
        end
        tooltip_font_strings[tooltip] = nil
        local used = {}
        for _, fallback in pairs(tooltip.uaForeverFallback or {}) do
            if fallback.region then used[fallback.region] = true end
        end
        for _, fallback in pairs(tooltip.uaForeverFallback or {}) do
            if not fallback.region then
                for _, candidate in ipairs(visible_tooltip_font_strings(tooltip)) do
                    if not used[candidate] and not tooltip.uaForeverClaims[candidate]
                        and type(candidate.GetText) == "function" then
                        local ok, value = pcall(candidate.GetText, candidate)
                        if ok and not is_secret(value)
                            and value == fallback.translated then
                            fallback.region = candidate
                            used[candidate] = true
                            break
                        end
                    end
                end
            end
            if fallback.region and fallback.region.SetText then
                local name_disabled = fallback.category
                    and fallback.slot:match("%.name$")
                    and not options.translate_name(fallback.category)
                local domain_disabled = fallback.option
                    and not options.can_translate(fallback.option)
                for _, option in ipairs(fallback.options or {}) do
                    if not options.can_translate(option) then domain_disabled = true end
                end
                runtime.set_fallback_text(fallback.region,
                    (show or name_disabled or domain_disabled
                        or (not fallback.force and not options.is_bilingual_tooltip()))
                        and "" or fallback.translated)
            end
        end
        if not show then
            if tooltip.uaForeverKind and tooltip.uaForeverID then
                safe_process(tooltip, { uaForeverID = tooltip.uaForeverID,
                    id = tooltip.uaForeverID, spellID = tooltip.uaForeverID },
                    tooltip.uaForeverKind)
            else
                translate_generic_tooltip(tooltip)
            end
        end
    end
end
