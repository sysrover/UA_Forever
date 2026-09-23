local _, addon_table = ...

local assets    = addon_table.use("assets") ---@class assets_class
local fonts     = addon_table.use("fonts") ---@class fonts_class
local options   = addon_table.use("options") ---@class options_class

-- Since 2.5.6 (and corresponding builds for other versions) GetFont() reports internal font attributes (e.g. FILTER, FIXEDHEIGHT) among flags.
-- Passing FIXEDHEIGHT back into SetFont() breaks rendering of pooled combat text font strings,
-- so only real render flags are kept when reapplying.
local allowed_font_flags = { OUTLINE = true, THICKOUTLINE = true, MONOCHROME = true, SLUG = true }

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

fonts.apply_to_font_string = function (font_string)
    if not options.can_translate("override_system_fonts") or not font_string then
        return false
    end

    -- Blizzard_Menu's Compositor proxy raises while merely indexing SetFont;
    -- checking `font_string.SetFont` outside pcall therefore still produces a
    -- forbidden-function error. Resolve both methods inside the protected
    -- call and skip font replacement for restricted menu regions.
    local methods_ok, get_font, set_font = pcall(function ()
        return font_string.GetFont, font_string.SetFont
    end)
    if not methods_ok or type(get_font) ~= "function" or type(set_font) ~= "function" then
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
    local set_ok = pcall(set_font, font_string,
        assets.font_frizqt, height, sanitize_font_flags(flags))
    return set_ok
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
