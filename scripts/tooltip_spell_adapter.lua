local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local client_db = addon_table.use("spell_client_db")
local renderer = addon_table.use("spell_template_renderer")
local adapter = addon_table.use("tooltip_spell_adapter")
local pet_actions = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").skills.pet_actions
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip spell dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip spell adapter is not configured")
end

local SPELL_NAME = 13
local SPELL_PASSIVE = 33
local SPELL_DESCRIPTION = 34
local UNTYPED_LINE = 0

local function translate_right_service(contract, tooltip, line_data,
    line_index, slot_prefix)
    local source = contract.safe_string(line_data.rightText)
    if not source then return false end
    local region = contract.line_region(tooltip, "Right", line_index)
    if not region then return false end
    local translated, source_kind = contract.translate_static(source, region)
    if not translated then return false end
    return contract.set_translation(
        tooltip, region, source, translated,
        slot_prefix .. line_index, nil, "spell-tooltip", source_kind
    )
end

local function owner_spellbook_item_info(tooltip)
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return nil end
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not ok then return nil end
    for _ = 1, 8 do
        if not owner then break end
        local info_ok, info = pcall(function ()
            return owner.spellBookItemInfo
        end)
        if info_ok and type(info) == "table" then return info end
        if type(owner.GetParent) ~= "function" then break end
        local parent_ok, parent = pcall(owner.GetParent, owner)
        if not parent_ok or parent == owner then break end
        owner = parent
    end
end

adapter.resolve_structured_spell_id = function (tooltip, data)
    local contract = deps()
    if type(data) ~= "table" then return nil, false end

    local info = owner_spellbook_item_info(tooltip)
    if info then
        local expected_name
        if type(data.lines) == "table" then
            for _, line_data in ipairs(data.lines) do
                if type(line_data) == "table"
                    and contract.safe_number(line_data.type) == SPELL_NAME then
                    expected_name = contract.safe_string(line_data.leftText)
                    if expected_name then break end
                end
            end
        end
        local item_type = contract.safe_number(info.itemType)
        local pet_action_type = Enum and Enum.SpellBookItemType
            and Enum.SpellBookItemType.PetAction
        local native_name = expected_name or contract.safe_string(info.name)
        if item_type and pet_action_type and item_type == pet_action_type
            and native_name and pet_actions[native_name] then
            return nil, true
        end
        return client_db.resolve_spellbook_item_id(info, expected_name)
    end

    return contract.safe_number(data.spellID)
        or contract.safe_number(data.id), false
end

adapter.add_structured_spell = function (tooltip, data, confirmed_id)
    local contract = deps()
    if not tooltip or type(data) ~= "table"
        or not options.can_lookup("translate_spell") then return false end
    local spell_id = confirmed_id or adapter.resolve_structured_spell_id(tooltip, data)
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
                applied = translate_right_service(contract, tooltip, line_data,
                    line_index, "spell.service-right:") or applied
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

-- A trainer service index identifies a session, never a spell database row.
-- Return handled separately from applied: a confirmed spell with no matching
-- translation must not fall through to generic translation of its description.
adapter.add_trainer = function (tooltip, data)
    local contract = deps()
    if not tooltip then return false, false end
    if data == nil and type(tooltip.GetPrimaryTooltipData) == "function" then
        local ok, value = pcall(tooltip.GetPrimaryTooltipData, tooltip)
        if ok and not contract.is_secret(value) then data = value end
    end
    if type(data) ~= "table" or contract.is_secret(data) then return false, false end
    local spell_type = _G.Enum and _G.Enum.TooltipDataType and _G.Enum.TooltipDataType.Spell
    local data_type = contract.safe_number(data.type)
    local id = contract.safe_number(data.id)
    if not spell_type or data_type ~= spell_type or not id or id <= 0
        or type(data.lines) ~= "table" or contract.is_secret(data.lines) then
        return false, false
    end
    tooltip.uaForeverID = id
    if tooltip.uaForeverShowOriginal then return true, false end
    -- Pass only the confirmed public ID. Do not resolve the trainer owner as
    -- a spellbook item or accidentally treat serviceIndex as spellID.
    return true, adapter.add_structured_spell(tooltip, data, id)
end

adapter.add_structured_pet_action = function (tooltip, data)
    local contract = deps()
    if not tooltip or type(data) ~= "table" or type(data.lines) ~= "table"
        or not options.can_lookup("translate_spell") then return false end

    local applied = false
    local max_line_index = 0
    local service_indexes = {}
    tooltip.uaForeverReservedFirst = 2
    for _, line_data in ipairs(data.lines) do
        if type(line_data) == "table" then
            local line_type = contract.safe_number(line_data.type)
            local line_index = contract.safe_number(line_data.lineIndex)
            local source = contract.safe_string(line_data.leftText)
            if line_index then
                max_line_index = math.max(max_line_index, line_index)
                applied = translate_right_service(contract, tooltip, line_data,
                    line_index, "pet-action.service-right:") or applied
                local region = contract.line_region(tooltip, "Left", line_index)
                local translated = source and pet_actions[source]
                if region and translated then
                    local slot = line_type == SPELL_NAME
                        and "pet-action.name"
                        or line_type == SPELL_DESCRIPTION
                            and "pet-action.description:" .. line_index
                            or "pet-action.text:" .. line_index
                    applied = contract.set_translation(
                        tooltip, region, source, translated, slot, nil,
                        "pet-action-tooltip", "surface"
                    ) or applied
                elseif line_type ~= SPELL_NAME
                    and line_type ~= SPELL_DESCRIPTION then
                    service_indexes[line_index] = true
                end
            end
        end
    end
    if options.can_translate("translate_spell") and max_line_index > 0 then
        applied = contract.rewrite_generic(
            tooltip, max_line_index, 1, nil, nil, nil, service_indexes
        ) > 0 or applied
    end
    return applied
end

adapter.add_structured_aura = function (tooltip, data)
    local contract = deps()
    if not tooltip or type(data) ~= "table"
        or not options.can_lookup("translate_spell") then return false end
    local spell_id = contract.safe_number(data.spellID)
        or contract.safe_number(data.id)
    if not spell_id or type(data.lines) ~= "table" then return false end

    local translated_name = client_db.get_name(spell_id)
    local english_raw = client_db.get_english_aura_description(spell_id)
    local ukrainian_raw = client_db.get_aura_description(spell_id)
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
                applied = translate_right_service(contract, tooltip, line_data,
                    line_index, "aura.service-right:") or applied
                local region = contract.line_region(tooltip, "Left", line_index)
                -- Build 70058 exposes every UnitAura row as type None (0).
                -- Its stable structured slots are name first, description
                -- second; later rows are duration, caster, and other service
                -- data. Identification still comes exclusively from data.id.
                local is_name = line_type == SPELL_NAME
                    or line_type == UNTYPED_LINE and line_index == 1
                local is_description = line_type == SPELL_DESCRIPTION
                    or line_type == UNTYPED_LINE and line_index == 2
                if is_name then
                    native_name = source or native_name
                    if region and source and translated_name
                        and options.can_translate("translate_spell") then
                        applied = contract.set_translation(
                            tooltip, region, source, translated_name,
                            "aura.name", "spell", "spell-tooltip"
                        ) or applied
                    end
                elseif is_description then
                    local translated
                    if region and source and english_raw and ukrainian_raw
                        and options.can_translate("translate_spell") then
                        translated = renderer.render(
                            spell_id, "aura", english_raw, ukrainian_raw, source
                        )
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source, translated,
                                "aura.description:" .. line_index, nil,
                                "spell-tooltip"
                            ) or applied
                        end
                    end
                    if not translated then service_indexes[line_index] = true end
                elseif line_type == SPELL_PASSIVE then
                    if region and source
                        and options.can_translate("translate_spell") then
                        local translated, source_kind =
                            contract.translate_static(source, region)
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source, translated,
                                "aura.passive:" .. line_index, nil,
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
