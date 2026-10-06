local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local client_db = addon_table.use("spell_client_db")
local item_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")
local catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
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
local ITEM_NAME = 22
local ITEM_SPELL_USE = 44
local ITEM_SPELL_EQUIP = 45
local ITEM_SPELL_PROC = 46
local UNTYPED_LINE = 0

local function migrated_line(spell_id, source, kind, tooltip)
    if type(client_db.get_details) ~= "function" then return nil end
    local detail = client_db.get_details(spell_id)
    if not detail or type(source) ~= "string" then return nil end
    local exact = kind == "aura" and detail.aura_lines or detail.tooltip_lines
    if type(exact) == "table" and type(exact[source]) == "string" then
        return exact[source]
    end
    local patterns = kind == "aura" and detail.aura_patterns or nil
    for _, rule in ipairs(patterns or {}) do
        if type(rule) == "table" and type(rule[1]) == "string"
            and type(rule[2]) == "string" then
            local values = { source:match(rule[1]) }
            if #values > 0 then
                local ok, translated = pcall(string.format, rule[2], unpack(values))
                if ok then return translated end
            end
        end
    end
    -- $ token rows and legacy # capture templates are different schemas.
    -- A canonical translated description always takes precedence.
    local current = kind == "aura" and client_db.get_aura_description(spell_id)
        or kind == "spell" and client_db.get_description(spell_id)
    local template = detail[kind == "aura" and 3 or 2]
    if not current and type(template) == "string"
        and type(deps().make_text) == "function" then
        return deps().make_text(template, tooltip, source)
    end
end

adapter.translate_crafting_requirements = function (source, spell_id)
    if type(source) ~= "string" then return nil end
    return catalog.translate_spell_requirements(source, function (body)
        if not options.can_translate("translate_item")
            or not options.translate_name("item") then return body end
        local names = {}
        for _, reagent in ipairs(spell_id and item_db.get_spell_reagents(spell_id) or {}) do
            local id = type(reagent) == "table" and reagent.itemID or nil
            local english = id and item_db.get_english_name(id)
            local translated = id and item_db.get_name(id)
            if english and translated then
                names[english] = translated
            end
        end
        local function translate_part(part, item_id)
            local before, name, after = part:match("^(%s*)(.-)(%s*)$")
            local bare, count = name:match("^(.-)(%s+%(%d+%))$")
            name = bare or name
            local translated = item_id and item_db.get_name(item_id)
                or names[name] or item_db.get_name_by_english(name)
            if not translated then return part end
            return before .. utils.cap(translated) .. (count or "") .. after
        end
        local function translate_plain(text)
            local translated = translate_part(text)
            if translated ~= text then return translated end
            return (text:gsub("[^,\r\n]+", translate_part))
        end
        -- Translate visible text only. Link payloads, colors, textures, line
        -- breaks and counts must survive byte-for-byte; never substitute item
        -- names inside a hyperlink target or another markup token.
        local parts, position = {}, 1
        while position <= #body do
            local first = body:find("|", position, true)
            if not first then
                parts[#parts + 1] = translate_plain(body:sub(position))
                break
            end
            parts[#parts + 1] = translate_plain(body:sub(position, first - 1))
            local rest = body:sub(first)
            local payload, visible = rest:match("^(|H.-|h)(.-)|h")
            local token
            if payload then
                local native_length = #payload + #visible + 2
                local item_id = tonumber(payload:match("^|Hitem:(%d+)"))
                if item_id then
                    local name = visible:match("^%[(.*)%]$")
                    visible = name and ("[" .. translate_part(name, item_id) .. "]")
                        or translate_part(visible, item_id)
                end
                token = payload .. visible .. "|h"
                position = first + native_length
            else
                token = rest:match("^|c%x%x%x%x%x%x%x%x")
                    or rest:match("^|T.-|t") or rest:match("^|A.-|a")
                    or rest:match("^|[rn|]")
                if not token then
                    -- Unknown or incomplete markup stays native.
                    parts[#parts + 1] = rest
                    break
                end
                position = first + #token
            end
            parts[#parts + 1] = token
        end
        return table.concat(parts)
    end)
end

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

    local capture = options.capture_enabled and options.capture_enabled()
    local names_enabled = not options.section_enabled or options.section_enabled("spell_names")
    local details_enabled = not options.section_enabled or options.section_enabled("spell_details")
    local translated_name = (names_enabled or capture) and client_db.get_name(spell_id) or nil
    local english_raw = (details_enabled or capture) and client_db.get_english_description(spell_id) or nil
    local ukrainian_raw = (details_enabled or capture) and client_db.get_description(spell_id) or nil
    local native_name
    local crafted_item = false
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
                if details_enabled then
                    applied = translate_right_service(contract, tooltip, line_data,
                        line_index, "spell.service-right:") or applied
                end
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
                    if details_enabled and region and source
                        and options.can_translate("translate_spell") then
                        local translated = english_raw and ukrainian_raw and renderer.render(
                            spell_id, "spell", english_raw, ukrainian_raw, source)
                            or migrated_line(spell_id, source, "spell", tooltip)
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source, translated,
                                "spell.description:" .. line_index, nil,
                                "spell-tooltip"
                            ) or applied
                        end
                    end
                elseif line_type == ITEM_NAME then
                    crafted_item = true
                    if region and source and options.can_translate("translate_item") then
                        local prefix, name, suffix = source:match("^(%s*)(.-)(%s*)$")
                        local translated = name and item_db.get_name_by_english(name)
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, source,
                                prefix .. utils.cap(translated) .. suffix,
                                "spell.crafted-item.name", "item", "spell-tooltip"
                            ) or applied
                        end
                    end
                elseif line_type == ITEM_SPELL_USE or line_type == ITEM_SPELL_EQUIP
                    or line_type == ITEM_SPELL_PROC
                    or (crafted_item and line_type == UNTYPED_LINE) then
                    -- Recipes embed an item tooltip after ITEM_NAME. Build
                    -- 70235 also emits its effects and stats as type 0; use
                    -- the shared item rules instead of requiring effect types.
                    if region and options.can_translate("translate_item")
                        and (not options.section_enabled
                            or options.section_enabled("item_details")) then
                        -- Use the rendered row: TooltipData can still contain
                        -- unresolved plural tokens in the cooldown suffix.
                        local visible = contract.tooltip_line(tooltip, "Left", line_index)
                        local native = contract.safe_string(visible) or source
                        local translated = native and catalog.translate_item_line(native)
                        if translated then
                            applied = contract.set_translation(
                                tooltip, region, native, translated,
                                "item.crafted-effect:" .. line_type .. ":" .. line_index,
                                nil, "spell-tooltip", "tooltip-adapter"
                            ) or applied
                        elseif line_type == UNTYPED_LINE then
                            service_indexes[line_index] = true
                        end
                    end
                elseif details_enabled and line_type == SPELL_PASSIVE then
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
                    local translated = details_enabled and source and line_type == UNTYPED_LINE
                        and (adapter.translate_crafting_requirements(source, spell_id)
                            or migrated_line(spell_id, source, "spell", tooltip))
                    if translated and region and options.can_translate("translate_spell") then
                        applied = contract.set_translation(
                            tooltip, region, source, translated,
                            "spell.requirements:" .. line_index, nil, "spell-tooltip"
                        ) or applied
                    else
                        service_indexes[line_index] = true
                    end
                end
            end
        end
    end

    dev_log.record_id("spells", spell_id, native_name,
        translated_name ~= nil or ukrainian_raw ~= nil)
    if not translated_name and not ukrainian_raw then
        dev_log.missing_spell(spell_id, native_name or tostring(spell_id))
    end
    if details_enabled and options.can_translate("translate_spell") and max_line_index > 0 then
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
                local right_source = contract.safe_string(line_data.rightText)
                local dispel_name = line_index == 1 and right_source
                    and catalog.aura_dispel_names[right_source]
                if dispel_name and options.can_translate("translate_spell") then
                    local right_region = contract.line_region(tooltip, "Right", line_index)
                    if right_region then
                        applied = contract.set_translation(
                            tooltip, right_region, right_source, dispel_name,
                            "aura.dispel-type", nil, "spell-tooltip", "surface"
                        ) or applied
                    end
                else
                    applied = translate_right_service(contract, tooltip, line_data,
                        line_index, "aura.service-right:") or applied
                end
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
                    -- TooltipData can still contain native plural tokens such
                    -- as "1 |4hour:hrs;" after the FontString renders "1 hour".
                    -- Render and verify against that actual text, otherwise
                    -- the resolved SetText result looks like a failed write
                    -- and the tooltip appends the same description again.
                    local visible_source = contract.tooltip_line(
                        tooltip, "Left", line_index, true)
                    source = contract.safe_string(visible_source) or source
                    local translated
                    if region and source
                        and options.can_translate("translate_spell") then
                        translated = english_raw and ukrainian_raw and renderer.render(
                            spell_id, "aura", english_raw, ukrainian_raw, source)
                            or migrated_line(spell_id, source, "aura", tooltip)
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
