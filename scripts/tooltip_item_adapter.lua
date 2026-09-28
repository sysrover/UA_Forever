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

local function build_snapshot(tooltip)
    local contract = deps()
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = ok and contract.safe_number(count) or nil
    if not count or count < 1 then return nil, false end
    count = math.min(count, contract.max_lines)
    local snapshot = {
        count = count,
        tooltip_height = contract.safe_dimension(tooltip, "GetHeight"),
        tooltip_width = contract.safe_dimension(tooltip, "GetWidth"),
    }
    runtime.metric("line_passes", tooltip, tooltip.uaForeverGeneration)
    for index = 1, count do
        local left, left_region = contract.tooltip_line(tooltip, "Left", index,
            index == 1)
        local right, right_region = contract.tooltip_line(tooltip, "Right", index,
            index == 1)
        snapshot[index] = {
            left = { source = left, region = left_region,
                visible = contract.normalized_text(left),
                previous_height = contract.safe_dimension(left_region,
                    "GetStringHeight") or contract.safe_dimension(left_region,
                    "GetHeight") },
            right = { source = right, region = right_region,
                visible = contract.normalized_text(right),
                previous_height = contract.safe_dimension(right_region,
                    "GetStringHeight") or contract.safe_dimension(right_region,
                    "GetHeight") },
        }
    end
    return snapshot, snapshot[1] and snapshot[1].left.region ~= nil
end

adapter.snapshot = function (tooltip)
    return build_snapshot(tooltip)
end

local function current_entry(tooltip)
    local tooltip_util = _G.TooltipUtil
    if tooltip_util and type(tooltip_util.GetDisplayedItem) == "function" then
        local ok, _, _, id = pcall(tooltip_util.GetDisplayedItem, tooltip)
        id = ok and deps().safe_number(id) or nil
        if id then return entries.get_entry("item", id) end
    end
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
        description, "item.use", nil, "item-tooltip", nil, false, false)
end

local function translate_use(tooltip, entry, snapshot)
    local contract = deps()
    local applied = false
    local found = false
    for index = 2, snapshot and snapshot.count or 1 do
        local row = snapshot[index].left
        local source, region, visible = row.source, row.region, row.visible
        if visible and visible:match("^Use:%s*") then
            found = true
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
    return applied, found
end

local function translate_lines(tooltip, entry, snapshot)
    local contract = deps()
    if type(entry.tooltip_lines) ~= "table" then return 0, false end
    local applied = 0
    local found = false
    for index = 2, snapshot and snapshot.count or 1 do
        local row = snapshot[index].left
        local source, region = row.source, row.region
        local translated = entry.tooltip_lines[row.visible]
        if translated and region and contract.set_translation(tooltip, region,
            source, translated, "item.description:" .. index, nil,
            "item-tooltip", nil, nil, false) then
            applied = applied + 1
            found = true
        elseif translated then
            found = true
        end
    end
    return applied, found
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

local function translate_fields(tooltip, entry, snapshot)
    local contract = deps()
    local count = snapshot and snapshot.count or 0
    local effects = {
        equip = { values = field_values(entry.equip), lines = {}, used = {},
            prefix = catalog.item_effect_prefix.equip },
        hit = { values = field_values(entry.hit), lines = {}, used = {},
            prefix = catalog.item_effect_prefix.hit },
    }
    for index = 2, count do
        local row = snapshot[index].left
        local region, visible = row.region, row.visible
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
    local found = false
    for index = 2, count do
        local row = snapshot[index].left
        local source, region, visible = row.source, row.region, row.visible
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
            if value then found = true end
            if value and (not claim or claim.owner ~= "item-tooltip")
                and contract.set_translation(tooltip, region, source, value,
                    slot, nil, "item-tooltip", nil, nil, false) then
                applied = applied + 1
            end
        end
    end
    return applied, found
end

local function translate_snapshot(tooltip, entry, snapshot)
    local contract = deps()
    if not snapshot then return { status = "incomplete", applied = false } end
    local title_row = snapshot and snapshot[1] and snapshot[1].left
    local native_title = title_row and title_row.source
    local title_region = title_row and title_row.region
    local title = contract.make_text(entry[1], tooltip)
    local title_applied = false
    if title and title_region then
        local suffix = type(native_title) == "string" and entry.en
            and native_title:sub(1, #entry.en + 1) == entry.en .. " "
            and entries.get_item_suffix(native_title) or nil
        if suffix then title = title .. " " .. suffix end
        title_applied = contract.set_translation(tooltip, title_region,
            native_title, title, "item.name", "item", "item-tooltip",
            nil, nil, false, nil, contract.item_name_visible_matches)
    end

    local use_applied, use_found = translate_use(tooltip, entry, snapshot)
    local lines_applied, lines_found = translate_lines(tooltip, entry, snapshot)
    local fields_applied, fields_found = translate_fields(tooltip, entry, snapshot)
    local generic_count = contract.rewrite_generic(tooltip,
        snapshot and snapshot.count, tooltip.uaForeverReservedFirst,
        nil, false, snapshot)
    if type(contract.finish_layout) == "function" then
        contract.finish_layout(tooltip, snapshot)
    end

    local expects_use = entry.use ~= nil
    local expects_lines = type(entry.tooltip_lines) == "table"
        and next(entry.tooltip_lines) ~= nil
    local expects_fields = entry.equip ~= nil or entry.hit ~= nil
        or entry.flavor ~= nil or entry.desc ~= nil
    local incomplete = not snapshot or not title_region
        or expects_use and not use_found
        or expects_lines and not lines_found
        or expects_fields and not fields_found
    local applied = title_applied or use_applied or lines_applied > 0
        or fields_applied > 0 or generic_count > 0
    return {
        status = incomplete and "incomplete"
            or applied and "complete" or "unchanged",
        applied = applied,
    }
end

adapter.add = function (tooltip, id)
    local contract = deps()
    runtime.metric("item_adapter_runs", tooltip, tooltip.uaForeverGeneration)
    if not options.can_lookup("translate_item") then
        tooltip.uaForeverItemStatus = "blocked"
        return { status = "blocked", applied = false }
    end
    local entry = entries.get_entry("item", id)
    local name
    if tooltip.GetItem then
        local ok, value = pcall(tooltip.GetItem, tooltip)
        if ok then name = value end
    end
    dev_log.record_id("items", id, name, entry ~= nil)
    if not entry then
        dev_log.missing_item(id, name)
        tooltip.uaForeverItemStatus = "blocked"
        return { status = "blocked", applied = false }
    end
    if not options.can_translate("translate_item") then
        tooltip.uaForeverItemStatus = "blocked"
        return { status = "blocked", applied = false }
    end

    tooltip.uaForeverReservedFirst = 2
    local snapshot, ready = build_snapshot(tooltip)
    local result = translate_snapshot(tooltip, entry, snapshot)
    if not ready then result.status = "incomplete" end
    tooltip.uaForeverItemStatus = result.status
    if result.status ~= "incomplete" then
        tooltip.uaForeverItemCompleteGeneration = tooltip.uaForeverGeneration
        return result
    end

    local generation = tooltip.uaForeverGeneration
    scheduler.request({
        id = "tooltip-item-late:" .. tostring(tooltip),
        generation = generation,
        surface = tooltip,
        instance = "item-pipeline",
        task_kind = "item-retry",
        delay = 0.2,
        callback = function ()
            local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
            if not shown_ok or not shown then return end
            local retry_snapshot, retry_ready = build_snapshot(tooltip)
            local retry_result = translate_snapshot(tooltip, entry, retry_snapshot)
            if not retry_ready then retry_result.status = "incomplete" end
            tooltip.uaForeverItemStatus = retry_result.status
            if retry_result.status ~= "incomplete" then
                tooltip.uaForeverItemCompleteGeneration = generation
            end
        end,
    })
    return result
end
