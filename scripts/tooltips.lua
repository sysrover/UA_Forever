local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local utils = addon_table.use("utils")
local tooltip_line

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
end

local function safe_number(value)
    if value == nil or is_secret(value) then return nil end
    local ok, result = pcall(tonumber, value)
    if ok then return result end
end

local function first_template_part(text)
    if type(text) ~= "string" then return text end
    return text:match("^(.-)#") or text
end

local function make_text(text, tooltip)
    if type(text) ~= "string" then
        return nil
    end

    local ok, result = pcall(entries.make_entry_text, text, tooltip)
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

local function set_tooltip_translation(tooltip, region, source, translated)
    if not region or type(translated) ~= "string" or translated == "" then return false end
    if not options.is_bilingual_tooltip() then
        return strings.set_region_text(region, translated, tooltip)
    end
    if type(source) ~= "string" or is_secret(source) then return false end

    local key = source .. "\031" .. translated
    tooltip.uaForeverBilingualLines = tooltip.uaForeverBilingualLines or {}
    if tooltip.uaForeverBilingualLines[key] then return true end

    local r, g, b = 1, 1, 1
    if type(region.GetTextColor) == "function" then
        local ok_color, red, green, blue = pcall(region.GetTextColor, region)
        if ok_color and not is_secret(red) and not is_secret(green) and not is_secret(blue)
            and type(red) == "number" and type(green) == "number" and type(blue) == "number" then
            r, g, b = red, green, blue
        end
    end

    local ok = pcall(tooltip.AddLine, tooltip, translated, r, g, b, true)
    if ok then tooltip.uaForeverBilingualLines[key] = true end
    return ok
end

local function rewrite_generic_lines(tooltip, line_count)
    line_count = safe_number(line_count)
    if not line_count then
        local ok_count, value = pcall(tooltip.NumLines, tooltip)
        line_count = ok_count and safe_number(value) or nil
    end
    if not line_count then return end

    for index = 1, line_count do
        local left, left_region = tooltip_line(tooltip, "Left", index)
        local right, right_region = tooltip_line(tooltip, "Right", index)
        local translated_left = strings.find_ui_translation(left, left_region)
        local translated_right = strings.find_ui_translation(right, right_region)
        if translated_left then
            set_tooltip_translation(tooltip, left_region, left, translated_left)
        end
        if translated_right then
            set_tooltip_translation(tooltip, right_region, right, translated_right)
        end
    end
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

    local title = make_text(entry[1], tooltip)
    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    line_count = ok_count and safe_number(line_count) or nil
    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    if title and title_region then
        set_tooltip_translation(tooltip, title_region, native_title, title)
    end
    rewrite_generic_lines(tooltip, line_count)
    return title ~= nil
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

    local ok_count, native_line_count = pcall(tooltip.NumLines, tooltip)
    native_line_count = ok_count and safe_number(native_line_count) or nil

    local title = make_text(entry[1], tooltip)
    if not title then return false end

    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    if title_region then
        set_tooltip_translation(tooltip, title_region, native_title, title)
    end

    local translated_description = make_text(aura and entry[3] or entry[2], tooltip)
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
                set_tooltip_translation(tooltip, region, text, translated_description)
                break
            end
        end
    end
    rewrite_generic_lines(tooltip, native_line_count)
    return true
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

    local native_title, title_region = tooltip_line(tooltip, "Left", 1)
    if title_region then
        set_tooltip_translation(tooltip, title_region,
            native_title, utils.cap(entry[1]))
    end
    if entry[2] then
        local native_subtitle, subtitle_region = tooltip_line(tooltip, "Left", 2)
        if subtitle_region then
            set_tooltip_translation(tooltip, subtitle_region,
                native_subtitle, utils.cap(entry[2]))
        end
    end
    rewrite_generic_lines(tooltip)
    return true
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
        id = id_from_guid(data.guid)
        if not id and tooltip.GetUnit then
            local _, unit = tooltip:GetUnit()
            id = unit and utils.npc_id_from_unit_id(unit)
        end
    elseif kind == "object" then
        id = id_from_guid(data.guid, true) or tonumber(data.id)
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

local function reset_tooltip(self)
    self.uaForeverKey = nil
    self.uaForeverGenericText = nil
    self.uaForeverBilingualLines = nil
end

tooltip_line = function (tooltip, side, index)
    if not tooltip.GetName then return nil, nil end
    local ok_name, name = pcall(tooltip.GetName, tooltip)
    if not ok_name or type(name) ~= "string" or name == "" then return nil, nil end

    local region = _G[name .. "Text" .. side .. tostring(index)]
    if not region or not region.GetText then return nil, region end
    local ok_text, text = pcall(region.GetText, region)
    if not ok_text then return nil, region end
    return text, region
end

-- Forever uses one display style for every tooltip: replace known visible
-- FontStrings in place. Domain post-calls run after Blizzard has populated the
-- tooltip, while this generic pass covers ordinary SetText tooltips.
local function translate_generic_tooltip(tooltip)
    if not tooltip then return end

    local left_title = tooltip_line(tooltip, "Left", 1)
    if type(left_title) ~= "string" or is_secret(left_title) then return end
    if left_title == "" then return end

    -- Unlike older Classic clients, Forever makes aura data secret and taints
    -- secure aura consumers when an addon registers a UnitAura post-call.
    -- Read only the public spell ID from the already-built tooltip instead.
    if tooltip.GetSpell then
        local ok_spell, _, tooltip_spell_id = pcall(tooltip.GetSpell, tooltip)
        local spell_id = ok_spell and safe_number(tooltip_spell_id) or nil
        if spell_id then
            if safe_process(tooltip, { spellID = spell_id }, "aura") then return end
        end
    end

    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    if not ok_count or type(line_count) ~= "number" or is_secret(line_count)
        or line_count < 1 then return end

    rewrite_generic_lines(tooltip, line_count)
end

tooltips.prepare = function ()
    if tooltips.prepared then return end
    tooltips.prepared = true

    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType then
        dev_log.issue("TooltipDataProcessor недоступний")
        return
    end

    local types = Enum.TooltipDataType
    if types.Item then
        TooltipDataProcessor.AddTooltipPostCall(types.Item, function (tooltip, data)
            safe_process(tooltip, data, "item")
        end)
    end
    if types.Spell then
        TooltipDataProcessor.AddTooltipPostCall(types.Spell, function (tooltip, data)
            safe_process(tooltip, data, "spell")
        end)
    end
    -- Do not register Enum.TooltipDataType.UnitAura here. On Camelot/Forever
    -- that callback taints Blizzard's secret aura update path. Aura tooltips
    -- are handled after rendering through GameTooltip:GetSpell() above.
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

    for _, tooltip in ipairs({ GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2 }) do
        if tooltip and tooltip.HookScript then
            pcall(tooltip.HookScript, tooltip, "OnUpdate", translate_generic_tooltip)
            pcall(tooltip.HookScript, tooltip, "OnTooltipCleared", reset_tooltip)
        end
    end
end
