local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local translation = addon_table.use("translation")
local client_db = addon_table.use("spell_client_db")
local renderer = addon_table.use("spell_template_renderer")
local adapter = addon_table.use("tooltip_talent_adapter")
local catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local format = catalog.format
local dependencies
local trait_entries = addon_table.client_trait_entries
local trait_overrides = addon_table.client_trait_definition_overrides_en
local talent_ui = assert(addon_table.talent_ui,
    "UA Forever talent UI catalog is not loaded")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
local hooks = addon_table.use("translation_hooks").bind("talent-frame")
local tooltip_contexts = setmetatable({}, { __mode = "k" })

local SPELL_NAME = 13
local SPELL_PASSIVE = 33
local SPELL_DESCRIPTION = 34

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip talent dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip talent adapter is not configured")
end

adapter.translate_quest_conditions = function (self, tooltip, condition_ids,
    _, group_ids)
    local contract = deps()
    if not self or not tooltip or type(condition_ids) ~= "table"
        or type(self.GetAndCacheCondInfo) ~= "function"
        or type(tooltip.NumLines) ~= "function"
        or not options.can_lookup("translate_quest") then return end
    local getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or _G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID
    if type(getter) ~= "function" then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    if not count then return end
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
        local id = info_ok and info and contract.safe_number(info.questID)
        if id then
            local title_ok, native = pcall(getter, id)
            native = title_ok and contract.safe_string(native) or nil
            local entry = title_ok and entries.get_entry("quest", id)
            local translated = entry and contract.make_text(entry[1], tooltip)
            if native and translated and native ~= translated then
                for index = 1, math.min(count, contract.max_lines) do
                    local current, region = contract.tooltip_line(
                        tooltip, "Left", index)
                    current = contract.safe_string(current)
                    if current and region then
                        local source = current
                        local translated_at, translated_end = source:find(
                            translated, 1, true)
                        if translated_at then
                            source = source:sub(1, translated_at - 1) .. native
                                .. source:sub(translated_end + 1)
                        end
                        local at, ending = source:find(native, 1, true)
                        if at then
                            local translated_line = source:sub(1, at - 1)
                                .. translated .. source:sub(ending + 1)
                            if not tooltip.uaForeverSessionKey then
                                contract.begin_tooltip(tooltip, "generic")
                            end
                            contract.set_translation(tooltip, region, source,
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

local function trait_row(entry_id)
    local rows = type(trait_entries) == "table" and trait_entries.rows
    return type(rows) == "table" and rows[entry_id] or nil
end

local function override_row(definition_id)
    local rows = type(trait_overrides) == "table" and trait_overrides.rows
    return type(rows) == "table" and rows[definition_id] or nil
end

local function effective_spell_id(entry_id)
    local row = trait_row(entry_id)
    if not row then return nil end
    local spell_id = deps().safe_number(row.visibleSpellID)
    if not spell_id or spell_id <= 0 then
        spell_id = deps().safe_number(row.spellID)
    end
    if spell_id and spell_id > 0 then return spell_id, row end

    -- Forever build 70058 has a definition whose OverrideName is a numeric
    -- spell reference. Resolve numeric DB2 references generically; literal
    -- override text remains native until it has its own translated table.
    local override = override_row(row.definitionID)
    spell_id = override and deps().safe_number(override.name) or nil
    if spell_id and spell_id > 0 then return spell_id, row end
    return nil, row
end

adapter.get_spell_id_for_entry = effective_spell_id

local function processing_trait_context(tooltip)
    if not tooltip or type(tooltip.GetProcessingTooltipInfo) ~= "function" then
        return nil
    end
    local ok, info = pcall(tooltip.GetProcessingTooltipInfo, tooltip)
    if not ok or type(info) ~= "table" or info.getterName ~= "GetTraitEntry"
        or type(info.getterArgs) ~= "table" then return nil end
    local entry_id = deps().safe_number(info.getterArgs[1])
    local rank = deps().safe_number(info.getterArgs[2])
    if not entry_id then return nil end
    local spell_id, row = effective_spell_id(entry_id)
    return {
        entryID = entry_id,
        rank = rank,
        spellID = spell_id,
        row = row,
    }
end

adapter.is_processing_trait = function (tooltip)
    return processing_trait_context(tooltip) ~= nil
end

local function ensure_trait_session(tooltip)
    if tooltip.uaForeverSessionKey ~= "talent:structured" then
        deps().begin_tooltip(tooltip, "talent:structured")
        tooltip.uaForeverTalentLines = {}
        tooltip.uaForeverTalentEntries = {}
    end
    tooltip.uaForeverKind = "talent"
end

local function public_trait_description(entry_id, rank)
    if not _G.C_TooltipInfo
        or type(_G.C_TooltipInfo.GetTraitEntry) ~= "function" then return nil end
    local ok, data = pcall(_G.C_TooltipInfo.GetTraitEntry, entry_id, rank)
    if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
        return nil
    end
    for _, line in ipairs(data.lines) do
        if type(line) == "table"
            and deps().safe_number(line.type) == SPELL_DESCRIPTION then
            return deps().safe_string(line.leftText)
        end
    end
end

local function strip_color_markup(text)
    if type(text) ~= "string" then return nil end
    return (text:gsub("|[cC]%x%x%x%x%x%x%x%x", ""):gsub("|[rR]", ""))
end

local function embed_translation(visible, native_core, translated_core)
    if visible == native_core then return translated_core end
    if not visible or not native_core or not translated_core then return nil end
    local at, ending = visible:find(native_core, 1, true)
    if not at then
        native_core = strip_color_markup(native_core)
        if native_core and native_core ~= "" then
            at, ending = visible:find(native_core, 1, true)
            if at then translated_core = strip_color_markup(translated_core) end
        end
    end
    if not at then return nil end
    return visible:sub(1, at - 1) .. translated_core
        .. visible:sub(ending + 1)
end

adapter.translate_structured_line = function (tooltip, line_data)
    local context = processing_trait_context(tooltip)
    if not context then return false, false end
    if options.can_lookup_section and not options.can_lookup_section("talents") then return true, false end
    ensure_trait_session(tooltip)

    local line_type = type(line_data) == "table"
        and deps().safe_number(line_data.type) or nil
    local line_index = type(line_data) == "table"
        and deps().safe_number(line_data.lineIndex) or nil
    local source = type(line_data) == "table"
        and deps().safe_string(line_data.leftText) or nil
    if not line_type or not line_index or not source then return true, false end
    if line_type ~= SPELL_DESCRIPTION and line_type ~= SPELL_NAME
        and line_type ~= SPELL_PASSIVE then return true, false end

    local _, region = deps().tooltip_line(tooltip, "Left", line_index)
    if not region or not context.spellID
        or not options.can_lookup("translate_spell")
        or not options.can_translate("translate_spell") then return true, false end

    local line_key = tostring(context.entryID) .. ":"
        .. tostring(context.rank or 0) .. ":" .. tostring(line_index)
    if tooltip.uaForeverTalentLines[line_key] then return true, false end
    tooltip.uaForeverTalentLines[line_key] = true
    tooltip.uaForeverTalentEntries[line_key] = context

    local translated
    if line_type == SPELL_DESCRIPTION then
        local english_raw = client_db.get_english_description(context.spellID)
        local ukrainian_raw = client_db.get_description(context.spellID)
        if english_raw and ukrainian_raw then
            local native_core = public_trait_description(
                context.entryID, context.rank) or source
            local translated_core = renderer.render(
                context.spellID, "spell", english_raw, ukrainian_raw,
                native_core)
            translated = embed_translation(source, native_core, translated_core)
                or renderer.render(context.spellID, "spell", english_raw,
                    ukrainian_raw, source)
        end
    elseif line_type == SPELL_NAME then
        translated = client_db.get_name(context.spellID)
    elseif line_type == SPELL_PASSIVE then
        translated = deps().translate_static(source, region)
    end

    if not translated then return true, false end
    local slot = "talent.entry:" .. tostring(context.entryID)
        .. ":rank:" .. tostring(context.rank or 0)
        .. ":line:" .. tostring(line_index)
    return true, deps().set_translation(tooltip, region, source, translated,
        slot, nil, "talent-tooltip") == true
end

adapter.translate_structured_data = function (tooltip, data)
    local context = processing_trait_context(tooltip)
    if not context then return false, false end
    if options.can_lookup_section and not options.can_lookup_section("talents") then return true, false end
    local lines = type(data) == "table" and data.lines or nil
    if type(lines) ~= "table" then return true, false end
    local applied = false
    for _, line_data in ipairs(lines) do
        local _, changed = adapter.translate_structured_line(tooltip, line_data)
        applied = changed or applied
    end
    return true, applied
end

local function points_requirement(source)
    local visible = deps().normalized_text(source)
    if not visible then return nil end
    local count, tree = visible:match(
        "^Spend ([%d,]+) more points? in (.-) Talents$")
    local names = talent_ui.spec_names
    local translated_tree = tree and names and names[tree]
    if not translated_tree then
        count, tree = visible:match("^Spend ([%d,]+) more points? in the (.-) Legacy Tree$")
        if not count then
            count, tree = visible:match("^Spend ([%d,]+) more points? in (.-) Talents$")
        end
        translated_tree = tree and talent_ui.legacy_tree_names[tree]
    end
    if not count or not translated_tree then return nil end
    local digits = count:gsub(",", "")
    local amount = tonumber(digits)
    if not amount then return nil end
    local translated = format.talent_points(count,
        catalog.points_form(amount), translated_tree)
    local color = source:match("^(|[cC]%x%x%x%x%x%x%x%x)")
    if color then
        translated = color .. translated
        if source:sub(-2) == "|r" or source:sub(-2) == "|R" then
            translated = translated .. source:sub(-2)
        end
    end
    return translated
end

local function keep_inline_color(source, translated)
    if type(source) ~= "string" or type(translated) ~= "string" then
        return translated
    end
    local prefix = source:match("^(|[cC]%x%x%x%x%x%x%x%x)")
    if not prefix then return translated end
    local suffix = source:sub(-2)
    if suffix ~= "|r" and suffix ~= "|R" then suffix = "" end
    return prefix .. translated .. suffix
end

local function replacement_spell_ids(button, spell_id, entry_id)
    local result, known = {}, {}
    local function add(value)
        value = deps().safe_number(value)
        if value and value > 0 and value ~= spell_id and not known[value] then
            known[value] = true
            result[#result + 1] = value
        end
    end

    if _G.C_Spell and type(_G.C_Spell.GetOverrideSpell) == "function" then
        local ok, value = pcall(_G.C_Spell.GetOverrideSpell, spell_id)
        if ok then add(value) end
    end
    if type(button.GetOverriddenSpellID) == "function" then
        local ok, value = pcall(button.GetOverriddenSpellID, button)
        if ok then add(value) end
    end
    local row = entry_id and trait_row(entry_id)
    if row then add(row.overridesSpellID) end
    return result
end

local function replacement_line(button, spell_id, entry_id, source)
    local visible = deps().normalized_text(source)
    if not visible then return nil end
    local formats = { "Replaced by %s", "Replaces %s" }
    for _, replacement_id in ipairs(replacement_spell_ids(
        button, spell_id, entry_id)) do
        local english = client_db.get_english_name(replacement_id)
        local ukrainian = client_db.get_name(replacement_id)
        if english and ukrainian then
            for _, english_format in ipairs(formats) do
                if visible == english_format:format(english) then
                    local ukrainian_format = addon_table.forever_ui
                        and addon_table.forever_ui[english_format]
                    if type(ukrainian_format) == "string" then
                        return keep_inline_color(source,
                            ukrainian_format:format(ukrainian))
                    end
                end
            end
        end
    end
end

local function current_context(tooltip)
    local context = tooltip_contexts[tooltip]
    if not context or tooltip.uaForeverSessionKey ~= "talent:structured"
        or tooltip.uaForeverGeneration ~= context.generation then return nil end
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not ok or runtime.is_secret_value(owner) or owner ~= context.button then return nil end
    return context
end

local function translate_region(tooltip, side, index)
    local context = current_context(tooltip)
    if not context or not options.can_lookup_section("talents") then return end
    local contract = deps()
    local source, region = contract.tooltip_line(tooltip, side, index)
    if not region or runtime.is_applying(region) then return end
    local visible = contract.normalized_text(source)
    if not visible or visible == "" then return end
    local translated = points_requirement(source)
        or replacement_line(context.button, context.id, context.entryID, source)
        or contract.translate_static(source, region)
    if translated and translated ~= source and not translated:find("{%d+}") then
        local slot = side == "Left" and "talent.requirement:" .. index
            or "talent.requirement:Right:" .. index
        contract.set_translation(tooltip, region, source, translated,
            slot, nil, "talent-tooltip")
    end
end

local function prepare_tooltip_rows(tooltip)
    if not current_context(tooltip) then return end
    local contract = deps()
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = ok and contract.safe_number(count) or nil
    if not count then return end
    for index = 1, math.min(count, contract.max_lines) do
        for _, side in ipairs({ "Left", "Right" }) do
            -- The left title belongs to the structured spell-name handler.
            if index > 1 or side == "Right" then
                local _, region = contract.tooltip_line(tooltip, side, index)
                if region then
                    local row_index, row_side = index, side
                    local function written()
                        translate_region(tooltip, row_side, row_index)
                    end
                    hooks.region(region, "SetText", written)
                    hooks.region(region, "SetFormattedText", written)
                    written()
                end
            end
        end
    end
end

adapter.translate = function (_, button, tooltip)
    if options.can_lookup_section and not options.can_lookup_section("talents") then return end
    local contract = deps()
    local talent_frame = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.TalentsFrame
    local legacy_frame = _G.LegacySystemFrame and _G.LegacySystemFrame.TreePage
        and _G.LegacySystemFrame.TreePage.LegacyTreeTraitPanel
    if not button or not tooltip
        or type(button.GetTalentFrame) ~= "function"
        or type(button.GetSpellID) ~= "function" then return end
    local frame_ok, owner = pcall(button.GetTalentFrame, button)
    if not frame_ok or not owner
        or (owner ~= talent_frame and owner ~= legacy_frame) then return end
    local id_ok, id = pcall(button.GetSpellID, button)
    id = id_ok and contract.safe_number(id) or nil
    local entry_id
    if type(button.GetEntryID) == "function" then
        local ok, value = pcall(button.GetEntryID, button)
        entry_id = ok and contract.safe_number(value) or nil
    end
    local mapped_id = entry_id and effective_spell_id(entry_id) or nil
    if not id or id <= 0 then id = mapped_id end
    if not id or id <= 0 then return end
    if not options.can_lookup("translate_spell")
        or not options.can_translate("translate_spell") then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    if not count then return end
    ensure_trait_session(tooltip)
    tooltip.uaForeverID = id
    tooltip.uaForeverTalentEntryID = entry_id
    tooltip.uaForeverReservedFirst = 2
    tooltip_contexts[tooltip] = { button = button, id = id, entryID = entry_id,
        generation = tooltip.uaForeverGeneration }
    -- Issue-submission tools can append another instruction after TooltipCreated.
    -- Translate those writes immediately, including newly allocated rows.
    local function fit()
        if current_context(tooltip) then layout.fit_talent_tooltip(tooltip) end
    end
    local function appended()
        prepare_tooltip_rows(tooltip)
        fit()
    end
    -- Fit after the native Show has finished assigning the final row geometry.
    hooks.region(tooltip, "Show", fit)
    hooks.region(tooltip, "AddLine", appended)
    hooks.region(tooltip, "AddDoubleLine", appended)
    hooks.region(tooltip, "ClearLines", function () tooltip_contexts[tooltip] = nil end)

    local title_source, title_region = contract.tooltip_line(tooltip, "Left", 1)
    local translated_name = client_db.get_name(id)
    if title_region and translated_name then
        contract.set_translation(tooltip, title_region, title_source,
            translated_name, "talent.name", "spell", "talent-tooltip")
    end

    prepare_tooltip_rows(tooltip)
    fit()
end
