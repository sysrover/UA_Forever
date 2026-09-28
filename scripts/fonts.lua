local _, addon_table = ...

local assets    = addon_table.use("assets") ---@class assets_class
local fonts     = addon_table.use("fonts") ---@class fonts_class
local options   = addon_table.use("options") ---@class options_class
local runtime   = addon_table.use("translation_runtime")

-- Since 2.5.6 (and corresponding builds for other versions) GetFont() reports internal font attributes (e.g. FILTER, FIXEDHEIGHT) among flags.
-- Passing FIXEDHEIGHT back into SetFont() breaks rendering of pooled combat text font strings,
-- so only real render flags are kept when reapplying.
local allowed_font_flags = { OUTLINE = true, THICKOUTLINE = true, MONOCHROME = true, SLUG = true }
local compositor_fonts = {}
local compositor_font_count = 0
local item_text_fonts = {}
local item_text_font_count = 0
local applied_signatures = setmetatable({}, { __mode = "k" })
local original_damage_text_font
local combat_text_font_names = {
    "CombatTextFont",
    "CombatTextFontOutline",
}

fonts.refresh_damage_text_font = function ()
    local current = _G.DAMAGE_TEXT_FONT
    if original_damage_text_font == nil and type(current) == "string"
        and current ~= "" then
        original_damage_text_font = current
    end
    if original_damage_text_font then
        _G.DAMAGE_TEXT_FONT = options.can_translate("override_system_fonts")
            and assets.font_frizqt or original_damage_text_font
    end
end

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

local function desired_signature(file, height, flags)
    return tostring(file) .. "\031" .. tostring(height) .. "\031" .. tostring(flags)
end

local function font_matches(font, file, height, flags)
    local method_ok, get_font = pcall(function () return font.GetFont end)
    if not method_ok or type(get_font) ~= "function" then return false end
    local ok, current_file, current_height, current_flags = pcall(get_font, font)
    return ok and current_file == file and current_height == height
        and sanitize_font_flags(current_flags) == flags
end

local function set_font_if_needed(font, file, height, flags)
    flags = sanitize_font_flags(flags)
    local signature = desired_signature(file, height, flags)
    if applied_signatures[font] == signature
        and font_matches(font, file, height, flags) then return true end
    if font_matches(font, file, height, flags) then
        applied_signatures[font] = signature
        return true
    end
    local method_ok, set_font = pcall(function () return font.SetFont end)
    if not method_ok or type(set_font) ~= "function" then return false end
    local ok, applied = pcall(set_font, font, file, height, flags)
    if type(runtime.metric) == "function" then runtime.metric("set_font_calls") end
    if not ok or applied == false then return false end
    applied_signatures[font] = signature
    return true
end

local function apply_combat_text_font_objects()
    if not options.can_translate("override_system_fonts") then return end
    for _, name in ipairs(combat_text_font_names) do
        local font = _G[name]
        if font then
            local get_ok, _, height, flags = pcall(font.GetFont, font)
            if get_ok then
                if type(height) ~= "number" or height <= 0 or height > 120 then
                    height = 25
                end
                set_font_if_needed(font, assets.font_frizqt, height, flags)
            end
        end
    end
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
        if type(runtime.metric) == "function" then
            runtime.metric("set_font_calls")
        end
        if not applied_ok or applied == false then return false end
        font = value
        compositor_fonts[key] = font
    end

    local signature = "compositor\031" .. key
    if applied_signatures[font_string] == signature then return true end
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
    applied_signatures[font_string] = signature
    return true
end

-- ItemTextPageText is a SimpleHTML region rather than a FontString. Its font
-- is assigned separately for every supported HTML tag, so GetFont/SetFont are
-- unavailable on the region itself. Clone Blizzard's current tag fonts with
-- the addon's Cyrillic-capable face and assign those clones to the tags.
local function item_text_font(source_font)
    local cached = item_text_fonts[source_font]
    if cached then return cached end
    if not source_font or type(_G.CreateFont) ~= "function" then return nil end

    local method_ok, get_font = pcall(function () return source_font.GetFont end)
    if not method_ok or type(get_font) ~= "function" then return nil end
    local font_ok, _, height, flags = pcall(get_font, source_font)
    if not font_ok or type(height) ~= "number" or height <= 0 or height > 120 then
        return nil
    end

    item_text_font_count = item_text_font_count + 1
    local created, font = pcall(_G.CreateFont,
        "UAForeverItemTextFont" .. item_text_font_count)
    if not created or not font then return nil end
    local set_ok, set_font = pcall(function () return font.SetFont end)
    if not set_ok or type(set_font) ~= "function" then return nil end
    local applied_ok, applied = pcall(set_font, font, assets.font_frizqt,
        height, sanitize_font_flags(flags))
    if type(runtime.metric) == "function" then
        runtime.metric("set_font_calls")
    end
    if not applied_ok or applied == false then return nil end

    item_text_fonts[source_font] = font
    return font
end

local function apply_item_text_html_fonts(region)
    local marker_ok, is_overlay = pcall(function ()
        return region.uaForeverItemTextOverlay == true
    end)
    if region ~= _G.ItemTextPageText
        and (not marker_ok or not is_overlay) then return false end
    local method_ok, set_font_object = pcall(function ()
        return region.SetFontObject
    end)
    if not method_ok or type(set_font_object) ~= "function" then return false end

    local material = "Parchment"
    if type(_G.ItemTextGetMaterial) == "function" then
        local material_ok, value = pcall(_G.ItemTextGetMaterial)
        if material_ok and type(value) == "string" and value ~= "" then
            material = value
        end
    end
    local catalog = _G.ITEM_TEXT_FONTS
    if type(catalog) ~= "table" then return false end
    local font_table = catalog[material] or catalog.default
    if type(font_table) ~= "table" then return false end

    local signature = "html\031" .. material
    for _, tag in ipairs({ "P", "H1", "H2", "H3" }) do
        signature = signature .. "\031" .. tostring(font_table[tag])
    end
    if applied_signatures[region] == signature then return true end
    local paragraph_applied = false
    for _, tag in ipairs({ "P", "H1", "H2", "H3" }) do
        local font = item_text_font(font_table[tag])
        if font then
            local assigned = pcall(set_font_object, region, tag, font)
            if tag == "P" and assigned then
                paragraph_applied = true
            end
        end
    end
    if paragraph_applied then applied_signatures[region] = signature end
    return paragraph_applied
end

fonts.apply_to_font_string = function (font_string)
    if not options.can_translate("override_system_fonts") or not font_string then
        return false
    end

    local marker_ok, is_item_text_overlay = pcall(function ()
        return font_string.uaForeverItemTextOverlay == true
    end)
    if font_string == _G.ItemTextPageText
        or marker_ok and is_item_text_overlay then
        return apply_item_text_html_fonts(font_string)
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
    -- FontInstance:SetFont can return false without raising a Lua error while
    -- addon media are still becoming available during a cold login. Failed
    -- calls are deliberately not signed so a later attempt can repair them.
    return set_font_if_needed(font_string, assets.font_frizqt, height, flags)
end

fonts.prepare = function ()
    -- World-space damage and combat-result text is rendered by the engine and
    -- has no FontString that an addon can safely update afterward.
    fonts.refresh_damage_text_font()
    -- CombatText1..N inherit these two FontObjects. They are safe to update
    -- independently of the protected unit/nameplate fonts skipped below.
    apply_combat_text_font_objects()
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
                set_font_if_needed(font, f.file, font_height, font_flags)
            end
        end
    end
end
