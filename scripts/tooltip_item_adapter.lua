local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local hooks = addon_table.use("translation_hooks").bind("tooltip-item-adapter")
local adapter = addon_table.use("tooltip_item_adapter")
local catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local format = catalog.format
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip item dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip item adapter is not configured")
end

local function current_entry(tooltip)
    if type(tooltip.GetPrimaryTooltipData) ~= "function" then return nil end
    local ok, data = pcall(tooltip.GetPrimaryTooltipData, tooltip)
    if not ok or not data or runtime.is_secret_value(data) then return nil end
    local fields_ok, kind, id = pcall(function () return data.type, data.id end)
    if not fields_ok or runtime.is_secret_value(kind)
        or not _G.Enum or not _G.Enum.TooltipDataType
        or kind ~= _G.Enum.TooltipDataType.Item then return nil end
    id = deps().safe_number(id)
    return id and entries.get_entry("item", id) or nil
end

local function translate_use_region(tooltip, entry, region, source)
    local contract = deps()
    local visible = contract.normalized_text(source)
    if not region or not visible or not visible:match("^Use:%s*") then
        return false
    end
    local use_text = entry.use
    if type(use_text) == "number" then
        local spell_entry = entries.get_entry("spell", use_text)
        use_text = spell_entry and spell_entry[2]
    end
    if type(use_text) ~= "string" then return false end
    local translated = contract.make_text(use_text, tooltip)
    if not translated then return false end
    local cooldown = visible:match("%(([%d,.]+) sec Cooldown%)")
    local unit = "sec"
    if not cooldown then
        cooldown = visible:match("%(([%d,.]+) min Cooldown%)")
        unit = "min"
    end
    local description = format.item_use(translated, cooldown, unit)
    return contract.set_translation(tooltip, region, source,
        description, "item.use", nil, "item-tooltip", nil, false)
end

local function translate_use(tooltip, entry, line_count)
    local contract = deps()
    if not line_count then
        local ok, count = pcall(tooltip.NumLines, tooltip)
        line_count = ok and contract.safe_number(count) or nil
    end
    local applied = false
    for index = 2, math.min(line_count or contract.max_lines,
        contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index, true)
        local visible = contract.normalized_text(source)
        if visible and visible:match("^Use:%s*") then
            hooks.region(region, "SetText", function (self)
                if runtime.is_applying(self) then return end
                local entry_now = current_entry(tooltip)
                if entry_now then
                    local ok, current = pcall(self.GetText, self)
                    if ok then
                        translate_use_region(tooltip, entry_now, self, current)
                    end
                end
            end)
            applied = translate_use_region(tooltip, entry, region, source)
                or applied
        end
    end
    return applied
end

local function translate_lines(tooltip, entry, line_count)
    local contract = deps()
    if type(entry.tooltip_lines) ~= "table" then return 0 end
    local count = line_count
    if not count then
        local ok, value = pcall(tooltip.NumLines, tooltip)
        count = ok and contract.safe_number(value) or nil
    end
    local applied = 0
    for index = 2, math.min(count or contract.max_lines,
        contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        local translated = entry.tooltip_lines[contract.normalized_text(source)]
        if translated and region and contract.set_translation(tooltip, region,
            source, translated, "item.description:" .. index, nil,
            "item-tooltip") then applied = applied + 1 end
    end
    return applied
end

local function field_text(value, tooltip, source_line)
    if type(value) == "number" then
        local spell = entries.get_entry("spell", value)
        value = spell and spell[2]
    end
    return type(value) == "string"
        and deps().make_text(value, tooltip, source_line) or nil
end

local function field_values(value)
    if type(value) == "table" then return value end
    return value and { value } or {}
end

local function source_pattern(value)
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

local function match_effects(effect)
    local values, lines, matched = effect.values, effect.lines, {}
    if #values == 1 then
        if effect.used[1] then return matched end
        local pattern = source_pattern(values[1])
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
        local pattern = source_pattern(value)
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
    local used_values, used_count = {}, 0
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
                local available, count
                count = 0
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
                remaining_value, value_count = value_index, value_count + 1
            end
        end
        for _, line in ipairs(lines) do
            if not matched[line.index] then
                remaining_line, line_count = line.index, line_count + 1
            end
        end
        if value_count == 1 and line_count == 1
            and not hints[remaining_value] then
            matched[remaining_line] = remaining_value
        end
    end
    return matched
end

local function translate_fields(tooltip, entry, line_count)
    local contract = deps()
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = line_count or (ok and contract.safe_number(count))
        or contract.max_lines
    local effects = {
        equip = { values = field_values(entry.equip), lines = {}, used = {},
            prefix = catalog.item_effect_prefix.equip },
        hit = { values = field_values(entry.hit), lines = {}, used = {},
            prefix = catalog.item_effect_prefix.hit },
    }
    for index = 2, math.min(count, contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        local visible = contract.normalized_text(source)
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
    effects.equip.matches = match_effects(effects.equip)
    effects.hit.matches = match_effects(effects.hit)
    local applied = 0
    for index = 2, math.min(count, contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        local visible = contract.normalized_text(source)
        if visible and region then
            local value, slot
            if visible:match("^Equip:%s*") then
                local effect = effects.equip
                local value_index = effect.matches[index]
                value = value_index and field_text(
                    effect.values[value_index], tooltip, visible)
                if value then value = effect.prefix .. " " .. value end
                slot = value_index and "item.equip:" .. value_index
            elseif visible:match("^Chance on hit:%s*") then
                local effect = effects.hit
                local value_index = effect.matches[index]
                value = value_index and field_text(
                    effect.values[value_index], tooltip, visible)
                if value then value = effect.prefix .. " " .. value end
                slot = value_index and "item.hit:" .. value_index
            elseif type(entry.flavor) == "string" and visible:match('^".*"$') then
                value = field_text(entry.flavor, tooltip)
                if value then value = '"' .. value .. '"' end
                slot = "item.flavor"
            elseif type(entry.desc) == "string"
                and (visible:match("^Adds [%d.,]+ damage per second%.?$")
                    or visible:match("^%d+ Slot Herb Bag$")) then
                local number = entry.desc:match("[%d.,]+")
                if number and visible:find(number, 1, true) then
                    value = field_text(entry.desc, tooltip)
                end
                slot = "item.description"
            end
            local claim = runtime.get(region)
            if value and (not claim or claim.owner ~= "item-tooltip")
                and contract.set_translation(tooltip, region, source, value,
                    slot, nil, "item-tooltip") then applied = applied + 1 end
        end
    end
    return applied
end

adapter.add = function (tooltip, id)
    local contract = deps()
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
    local title = contract.make_text(entry[1], tooltip)
    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    line_count = ok_count and contract.safe_number(line_count) or nil
    local native_title, title_region = contract.tooltip_line(tooltip, "Left", 1)
    local title_applied = false
    if title and title_region then
        local suffix = type(native_title) == "string" and entry.en
            and native_title:sub(1, #entry.en + 1) == entry.en .. " "
            and entries.get_item_suffix(native_title) or nil
        if suffix then title = title .. " " .. suffix end
        title_applied = contract.set_translation(tooltip, title_region,
            native_title, title, "item.name", "item", "item-tooltip")
    end
    local use_applied = translate_use(tooltip, entry, line_count)
    local description_count = translate_lines(tooltip, entry, line_count)
        + translate_fields(tooltip, entry, line_count)
    local generic_count = contract.rewrite_generic(
        tooltip, line_count, tooltip.uaForeverReservedFirst)
    local generation = tooltip.uaForeverGeneration
    local function finalize_item_lines()
        local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
        if shown_ok and shown then
            translate_use(tooltip, entry)
            translate_lines(tooltip, entry)
            translate_fields(tooltip, entry)
            contract.rewrite_generic(tooltip, nil,
                tooltip.uaForeverReservedFirst)
        end
    end
    scheduler.request("tooltip-item:" .. tostring(tooltip), generation,
        finalize_item_lines, nil, tooltip)
    scheduler.request("tooltip-item-late:" .. tostring(tooltip), generation,
        finalize_item_lines, 0.2, tooltip)
    return title_applied or use_applied or description_count > 0
        or generic_count > 0
end
