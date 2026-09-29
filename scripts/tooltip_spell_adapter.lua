local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local layout = addon_table.use("translation_layout")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local client_db = addon_table.use("spell_client_db")
local renderer = addon_table.use("spell_template_renderer")
local adapter = addon_table.use("tooltip_spell_adapter")
local dependencies
local aura_spell_titles = {}

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip spell dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip spell adapter is not configured")
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

local SPELL_NAME = 13
local SPELL_PASSIVE = 33
local SPELL_DESCRIPTION = 34

adapter.add_structured_spell = function (tooltip, data)
    local contract = deps()
    if not tooltip or type(data) ~= "table"
        or not options.can_lookup("translate_spell") then return false end
    local spell_id = contract.safe_number(data.id)
    if not spell_id or type(data.lines) ~= "table" then return false end

    local translated_name = client_db.get_name(spell_id)
    local english_raw = client_db.get_english_description(spell_id)
    local ukrainian_raw = client_db.get_description(spell_id)
    local native_name
    local applied = false
    local service_indexes = {}
    local max_line_index = 0
    tooltip.uaForeverReservedFirst = 2

    for _, line_data in ipairs(data.lines) do
        if type(line_data) == "table" then
            local line_type = contract.safe_number(line_data.type)
            local line_index = contract.safe_number(line_data.lineIndex)
            local source = contract.safe_string(line_data.leftText)
            if line_index then
                max_line_index = math.max(max_line_index, line_index)
                local region = contract.line_region(tooltip, "Left", line_index)
                if line_type == SPELL_NAME then
                    native_name = source or native_name
                    if region and source and translated_name
                        and options.can_translate("translate_spell") then
                        local category = "spell"
                        applied = contract.set_translation(
                            tooltip, region, source, translated_name,
                            category .. ".name", category, "spell-tooltip"
                        ) or applied
                    end
                elseif line_type == SPELL_DESCRIPTION then
                    if region and source and english_raw and ukrainian_raw
                        and options.can_translate("translate_spell") then
                        local translated = renderer.render(
                            spell_id, "spell", english_raw, ukrainian_raw, source
                        )
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source, translated,
                                "spell.description:" .. line_index, nil,
                                "spell-tooltip"
                            ) or applied
                        end
                    end
                elseif line_type == SPELL_PASSIVE then
                    if region and source
                        and options.can_translate("translate_spell") then
                        local translated, source_kind =
                            contract.translate_static(source, region)
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source, translated,
                                "spell.passive:" .. line_index, nil,
                                "spell-tooltip", source_kind
                            ) or applied
                        end
                    end
                else
                    service_indexes[line_index] = true
                end
            end
        end
    end

    dev_log.record_id("spells", spell_id, native_name,
        translated_name ~= nil or ukrainian_raw ~= nil)
    if not translated_name and not ukrainian_raw then
        dev_log.missing_spell(spell_id, native_name or tostring(spell_id))
    end
    if options.can_translate("translate_spell") and max_line_index > 0 then
        applied = contract.rewrite_generic(
            tooltip, max_line_index, 1, nil, nil, nil, service_indexes
        ) > 0 or applied
    end
    return applied
end

adapter.resolve_aura_id = function (title)
    local contract = deps()
    title = contract.normalized_text(title)
    if not title or title == "" then return nil end
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

    if _G.C_Spell and type(_G.C_Spell.GetSpellInfo) == "function" then
        local ok_info, info = pcall(_G.C_Spell.GetSpellInfo, title)
        local spell_id = ok_info and info
            and contract.safe_number(info.spellID) or nil
        if spell_id then
            aura_spell_titles[title] = spell_id
            return spell_id
        end
    end
    aura_spell_titles[title] = false
    return nil
end

local function translate_aura_text(entry, source)
    source = deps().safe_string(source)
    if not source or type(entry.aura_lines) ~= "table" then return nil end
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

local function translate_tooltip_lines(tooltip, entry, line_count)
    local contract = deps()
    if type(entry.tooltip_lines) ~= "table" then return 0 end
    local applied = 0
    for index = 2, math.min(line_count or contract.max_lines,
        contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        source = contract.safe_string(source)
        local translated = source
            and entry.tooltip_lines[contract.normalized_text(source)] or nil
        if translated and region and contract.set_translation(
            tooltip, region, source, translated,
            "spell.tooltip:" .. index, nil, "spell-tooltip"
        ) then
            applied = applied + 1
        end
    end
    return applied
end

adapter.add = function (tooltip, id, aura)
    local contract = deps()
    if not options.can_lookup("translate_spell") then return false end
    local entry = entries.get_entry("spell", id)
    local info = _G.C_Spell and _G.C_Spell.GetSpellInfo
        and _G.C_Spell.GetSpellInfo(id)
    dev_log.record_id("spells", id, info and info.name, entry ~= nil)
    if not entry then
        dev_log.missing_spell(id, info and info.name or tostring(id))
        return false
    end
    if not options.can_translate("translate_spell") then return false end
    tooltip.uaForeverReservedFirst = 2

    local ok_count, native_line_count = pcall(tooltip.NumLines, tooltip)
    native_line_count = ok_count and contract.safe_number(native_line_count) or nil
    local title = contract.make_text(entry[1], tooltip)
    local applied = false
    local native_title, title_region = contract.tooltip_line(tooltip, "Left", 1)
    if title and title_region then
        local category = spell_name_category(tooltip)
        applied = contract.set_translation(tooltip, title_region, native_title, title,
            category .. ".name", category, "spell-tooltip") or applied
    end

    do
        local right, right_region = contract.tooltip_line(tooltip, "Right", 1)
        if aura and not right_region then
            for _, candidate in ipairs(contract.visible_font_strings(tooltip)) do
                local ok, value = pcall(candidate.GetText, candidate)
                if ok and contract.normalized_text(value) == "Magic" then
                    right, right_region = value, candidate
                    break
                end
            end
        end
        local translated, _, source_kind = strings.find_ui_translation(
            right, right_region)
        if translated and translated ~= right then
            applied = contract.set_translation(tooltip, right_region, right,
                translated, aura and "spell.school" or "spell.header", nil,
                "spell-tooltip", source_kind, false, false) or applied
        end
        if aura and applied then
            layout.fit_aura_header_width(tooltip, title_region, right_region,
                contract.normalized_text(right) == "Magic" and 72 or nil)
        end
    end

    local translated_description = contract.make_text(
        aura and entry[3] or entry[2], tooltip)
    if aura and entry.aura_lines then
        for index = 2, math.min(native_line_count or contract.max_lines,
            contract.max_lines) do
            local native, region = contract.tooltip_line(tooltip, "Left", index)
            local translated = translate_aura_text(entry, native)
            if translated and region then
                applied = contract.set_translation(tooltip, region, native,
                    translated, "spell.description:" .. index, nil,
                    "spell-tooltip") or applied
            end
        end
    elseif aura and translated_description then
        local native_description, description_region = contract.tooltip_line(
            tooltip, "Left", 2)
        if description_region then
            applied = contract.set_translation(tooltip, description_region,
                native_description, translated_description, "spell.description",
                nil, "spell-tooltip") or applied
        end
    else
        local source_description
        if _G.C_Spell and _G.C_Spell.GetSpellDescription then
            local ok_description, value = pcall(
                _G.C_Spell.GetSpellDescription, id)
            value = ok_description and contract.safe_string(value) or nil
            if value then source_description = contract.normalized_text(value) end
        end
        if translated_description and source_description and native_line_count then
            for index = 2, native_line_count do
                local text, region = contract.tooltip_line(tooltip, "Left", index)
                if contract.normalized_text(text) == source_description then
                    applied = contract.set_translation(tooltip, region, text,
                        translated_description, "spell.description", nil,
                        "spell-tooltip") or applied
                    break
                end
            end
        end
    end
    applied = translate_tooltip_lines(tooltip, entry, native_line_count) > 0
        or applied
    return contract.rewrite_generic(tooltip, native_line_count, 2) > 0 or applied
end
