local _, addon_table = ...

local assets    = addon_table.use("assets") ---@class assets_class
local fonts     = addon_table.use("fonts") ---@class fonts_class
local options   = addon_table.use("options") ---@class options_class

-- Since 2.5.6 (and corresponding builds for other versions) GetFont() reports internal font attributes (e.g. FILTER, FIXEDHEIGHT) among flags.
-- Passing FIXEDHEIGHT back into SetFont() breaks rendering of pooled combat text font strings,
-- so only real render flags are kept when reapplying.
local allowed_font_flags = { OUTLINE = true, THICKOUTLINE = true, MONOCHROME = true, SLUG = true }
local compositor_fonts = {}
local compositor_font_count = 0

local function sanitize_font_flags(font_flags)
    if not font_flags or font_flags == "" then
        return ""
    end
    local result = {}
    for token in font_flags:gmatch("[^,%s]+") do
        if allowed_font_flags[token] then
            result[#result + 1] = token
        end
    end
    return table.concat(result, ", ")
end

local function compositor_managed(font_string)
    local ok, metatable = pcall(getmetatable, font_string)
    return ok and type(metatable) == "table"
        and type(rawget(metatable, "__index")) == "function"
        and type(rawget(metatable, "__newindex")) == "table"
end

local function apply_compositor_font(font_string, height, flags)
    if type(_G.CreateFont) ~= "function" then return false end
    local method_ok, set_font_object, get_text_color, set_text_color = pcall(function ()
        return font_string.SetFontObject, font_string.GetTextColor,
            font_string.SetTextColor
    end)
    if not method_ok or type(set_font_object) ~= "function" then return false end

    local key = tostring(height) .. ":" .. flags
    local font = compositor_fonts[key]
    if not font then
        compositor_font_count = compositor_font_count + 1
        local created, value = pcall(_G.CreateFont,
            "UAForeverCompositorFont" .. compositor_font_count)
        if not created or not value then return false end
        local set_ok, set_font = pcall(function () return value.SetFont end)
        if not set_ok or type(set_font) ~= "function" then return false end
        local applied_ok, applied = pcall(set_font, value,
            assets.font_frizqt, height, flags)
        if not applied_ok or applied == false then return false end
        font = value
        compositor_fonts[key] = font
    end

    local color_ok, r, g, b, a = false, nil, nil, nil, nil
    if type(get_text_color) == "function" then
        color_ok, r, g, b, a = pcall(get_text_color, font_string)
    end
    local assigned = pcall(set_font_object, font_string, font)
    if not assigned then return false end
    if color_ok and type(set_text_color) == "function"
        and type(r) == "number" and type(g) == "number"
        and type(b) == "number" then
        pcall(set_text_color, font_string, r, g, b,
            type(a) == "number" and a or 1)
    end
    return true
end

fonts.apply_to_font_string = function (font_string)
    if not options.can_translate("override_system_fonts") or not font_string then
        return false
    end

    -- Blizzard_Menu's compositor forbids even indexing SetFont, and assertsafe
    -- still reports the violation when the access is wrapped in pcall.
    local guarded = compositor_managed(font_string)
    local methods_ok, get_font = pcall(function () return font_string.GetFont end)
    if not methods_ok or type(get_font) ~= "function" then
        return false
    end

    local ok, _, height, flags = pcall(get_font, font_string)
    if not ok or type(height) ~= "number" or height <= 0 then return false end

    -- Some Camelot menu strings report an internal FIXEDHEIGHT value instead
    -- of their rendered size. Measure the still-English text before replacing
    -- it, with a conservative fallback for empty strings.
    if height > 120 then
        local height_method_ok, get_string_height = pcall(function ()
            return font_string.GetStringHeight
        end)
        local height_ok, rendered_height = false, nil
        if height_method_ok and type(get_string_height) == "function" then
            height_ok, rendered_height = pcall(get_string_height, font_string)
        end
        height = height_ok and type(rendered_height) == "number"
            and rendered_height >= 6 and rendered_height <= 60 and rendered_height or 16
    end
    flags = sanitize_font_flags(flags)
    if guarded then
        return apply_compositor_font(font_string, height, flags)
    end
    local set_ok, set_font = pcall(function () return font_string.SetFont end)
    if not set_ok or type(set_font) ~= "function" then return false end
    local call_ok, applied = pcall(set_font, font_string,
        assets.font_frizqt, height, flags)
    -- FontInstance:SetFont can return false without raising a Lua error while
    -- addon media are still becoming available during a cold login. Treat
    -- that as a failed application so callers do not replace visible English
    -- with Cyrillic that the old font cannot render.
    return call_ok and applied ~= false
end

fonts.prepare = function ()
    if not options.can_translate("override_system_fonts") then
        return
    end
    -- Camelot/Forever protects unit, aura, nameplate, and combat frames with
    -- secret values. Mutating shared FontObjects can taint those frames even
    -- when the addon only intends to translate an unrelated panel. On this
    -- client fonts are applied directly to safe visible FontStrings instead.
    if type(_G.issecretvalue) == "function" then
        return
    end

    local font_overrides = {
        { name="CombatTextFont",                    file=assets.font_frizqt, height=25 },
        { name="CombatTextFontOutline",             file=assets.font_frizqt, height=25 },
        { name="GameFontNormal",                    file=assets.font_frizqt },
        { name="GameFontNormalSmall",               file=assets.font_frizqt },
        { name="GameFontNormalLarge",               file=assets.font_frizqt },
        { name="GameFontNormalHuge",                file=assets.font_frizqt },
        { name="GameFontHighlight",                 file=assets.font_frizqt },
        { name="GameFontHighlightSmall",            file=assets.font_frizqt },
        { name="GameFontHighlightLarge",            file=assets.font_frizqt },
        { name="GameFontDisable",                   file=assets.font_frizqt },
        { name="GameFontDisableSmall",              file=assets.font_frizqt },
        { name="GameFontDisableLarge",              file=assets.font_frizqt },
        { name="GameTooltipHeader",                 file=assets.font_frizqt },
        { name="MailFont_Large",                    file=assets.font_morpheus },
        { name="PVPInfoTextFont",                   file=assets.font_frizqt },
        { name="QuestFont_Huge",                    file=assets.font_morpheus },
        { name="QuestFont_Super_Huge",              file=assets.font_morpheus },
        { name="QuestFont_Shadow_Huge",             file=assets.font_morpheus },
        { name="QuestFont_Enormous",                file=assets.font_morpheus },
        { name="QuestFont_Large",                   file=assets.font_morpheus },
        { name="QuestFont_Larger",                  file=assets.font_morpheus },
        { name="QuestFont",                         file=assets.font_frizqt },
        { name="QuestFontNormalSmall",              file=assets.font_frizqt },
        { name="SubZoneTextFont",                   file=assets.font_frizqt },
        { name="SystemFont_NamePlate",              file=assets.font_frizqt },
        { name="SystemFont_NamePlate_Outlined",     file=assets.font_frizqt },
        { name="SystemFont_Shadow_Large",           file=assets.font_frizqt },
        { name="SystemFont_Shadow_Large_Outline",   file=assets.font_frizqt },
        { name="SystemFont_Shadow_Large2",          file=assets.font_frizqt },
        { name="SystemFont_Shadow_Large2_Outline",  file=assets.font_frizqt },
        { name="SystemFont_Shadow_Med1",            file=assets.font_frizqt },
        { name="SystemFont_Shadow_Med1_Outline",    file=assets.font_frizqt },
        { name="SystemFont_Shadow_Med2",            file=assets.font_frizqt },
        { name="SystemFont_Shadow_Med2_Outline",    file=assets.font_frizqt },
        { name="SystemFont_Shadow_Small",           file=assets.font_frizqt },
        { name="SystemFont_Shadow_Small_Outline",   file=assets.font_frizqt },
        { name="SystemFont_Shadow_Small2",          file=assets.font_frizqt },
        { name="SystemFont_Shadow_Small2_Outline",  file=assets.font_frizqt },
        { name="Tooltip_Med",                       file=assets.font_frizqt },
        { name="Tooltip_Small",                     file=assets.font_frizqt },
        { name="WorldMapTextFont",                  file=assets.font_frizqt },
        { name="ZoneTextFont",                      file=assets.font_frizqt },
    }

    for _, f in ipairs(font_overrides) do
        local font = _G[f.name]
        if font then
            local _, font_height, font_flags = font:GetFont()
            if font_height and font_height > 120 and f.height then
                -- 120 is a maximum font height. But, as example, for CombatTextFont:GetFont() height is ~100256, though actual height in CombatText1..20 frames is 25
                font_height = f.height
            end
            if font_height then
                font:SetFont(f.file, font_height, sanitize_font_flags(font_flags))
            end
        end
    end
end
