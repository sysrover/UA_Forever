local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local assets = addon_table.use("assets")
local hooks = addon_table.use("translation_hooks").bind("spoken-places")
local profile = addon_table.use("performance_profile").wrap or function (_, callback) return callback end
local locale = addon_table.spoken_locale_uk.Places
local stories = addon_table.spoken_places_uk
local letters = {}
local alphabet = addon_table.zone_grammar and addon_table.zone_grammar.alphabet
if alphabet then
    local upper = alphabet.upper:gmatch("[%z\1-\127\194-\244][\128-\191]*")
    for letter in alphabet.lower:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        letters[letter] = upper()
    end
end

local function enabled()
    return options.can_translate("translate_spoken")
end

local function translated_name(source)
    if runtime.is_secret_value(source) or type(source) ~= "string" then return nil end
    local zones = addon_table.zone
    if not zones then return nil end
    local text = zones[source]
    if not text then
        local without_article = source:match("^The (.+)$")
        text = zones[without_article or ("The " .. source)]
    end
    if type(text) ~= "string" or text == "" or text == source then return nil end
    return (text:gsub("^([%z\1-\127\194-\244][\128-\191]*)", letters, 1))
end

spoken.place_name = translated_name

local function story_text(map_id, area_key)
    if runtime.is_secret_value(map_id) or type(map_id) ~= "number"
        or runtime.is_secret_value(area_key) then return nil end
    local zone = stories[map_id]
    if not zone then return nil end
    if area_key then return zone.areas and zone.areas[area_key] end
    return zone.text
end

local function translated_subtitle(source)
    if runtime.is_secret_value(source) or type(source) ~= "string" then return nil end
    local prefix = locale.IN_ZONE_FMT:match("^(.-)%%1%$s$")
    if prefix and source:sub(1, #prefix) == prefix then
        local rest = source:sub(#prefix + 1)
        local divider = rest:find(" · ", 1, true)
        local name = translated_name(divider and rest:sub(1, divider - 1) or rest)
        if name then return prefix .. name .. (divider and rest:sub(divider) or "") end
    end
    local before, after = locale.MAP_LORE_FOR_FMT:match("^(.-)%%1%$s(.*)$")
    if before and source:sub(1, #before) == before and source:sub(-#after) == after then
        local name = translated_name(source:sub(#before + 1, #source - #after))
        if name then return before .. name .. after end
    end
end

local function use_heading_font(region, file)
    local native_face
    return function (translated)
        if not runtime.can_write_text(region) then return end
        local current, size, flags = region:GetFont()
        if not current or not size then return end
        if translated and current ~= file then
            native_face = current
            region:SetFont(file, size, flags)
        elseif not translated and native_face and current == file then
            region:SetFont(native_face, size, flags)
            native_face = nil
        end
    end
end

local function wrap_page(page, places)
    if not page or not page.page or type(page.Show) ~= "function" then return page end
    local inner = page.page
    if not inner.body or not inner.title or not inner.sub or not inner.sub.text then return page end
    local original = page.Show
    local title_font = use_heading_font(inner.title, assets.font_morpheus)
    local subtitle_font = use_heading_font(inner.sub.text, assets.font_frizqt)
    local owner = inner.body.owner or places
    local use_uk_body = false
    inner.body.owner = {
        FontFor = function (_, font_object)
            if use_uk_body then return assets.font_frizqt end
            if type(owner.FontFor) == "function" then return owner:FontFor(font_object) end
        end,
    }
    page.Show = profile("spoken-places.page", function (self, entry)
        local title, subtitle, text
        use_uk_body = false
        if enabled() and type(entry) == "table" then
            if entry.reportAction and entry.panelTitle == locale.BOSS_LORE_TITLE then
                local target = entry.target or {}
                title = spoken.boss_title(target[1], target[2], entry.title)
                subtitle = translated_name(entry.subtitle)
                text = spoken.boss_text(target[1], target[2])
                use_uk_body = text ~= nil or entry.text == addon_table.spoken_locale_uk.Bosses.BOSS_NOT_FOUND
            elseif not entry.panelTitle then
                title = translated_name(entry.title)
                subtitle = translated_subtitle(entry.subtitle)
                local target = entry.audio or entry.report
                text = target and story_text(target[1], target[2])
                use_uk_body = text ~= nil or entry.text == locale.NOT_DISCOVERED
            end
        end
        title_font(title ~= nil)
        subtitle_font(subtitle ~= nil)
        if not title and not subtitle and not text then return original(self, entry) end
        -- The caller retains its native keys, contribution name and page actions.
        local display = {}
        for key, value in pairs(entry) do display[key] = value end
        display.title = title or display.title
        display.subtitle = subtitle or display.subtitle
        display.text = text or display.text
        return original(self, display)
    end)
    return page
end

spoken.prepare_places = function ()
    local places = _G.SpokenPlaces
    if type(places) ~= "table" then return end
    hooks.once("story-text", function ()
        local original = places.LoreText
        if type(original) ~= "function" then return false end
        places.LoreText = profile("spoken-places.text", function (self, map_id, area_key, ...)
            local text = enabled() and story_text(map_id, area_key)
            if text then return text end
            return original(self, map_id, area_key, ...)
        end)
        return true
    end)
    hooks.once("story-page", function ()
        local original = places.CreateLorePage
        if type(original) ~= "function" then return false end
        places.CreateLorePage = profile("spoken-places.create", function (self, ...)
            return wrap_page(original(self, ...), self)
        end)
        return true
    end)
    hooks.once("story-audio", function ()
        local original = places.NewLoreSound
        if type(original) ~= "function" then return false end
        places.NewLoreSound = profile("spoken-places.audio", function (self, map_id, area_key, ...)
            local clip = original(self, map_id, area_key, ...)
            if not clip or not clip.present or not enabled() then return clip end
            local display = clip.present
            local title, header = translated_name(display.label), translated_name(display.header)
            local text = story_text(map_id, area_key)
            if title then display.label = title end
            if header then display.header = header end
            if text then
                display.transcript = text
                display.timings = nil
            end
            if text or title or header then
                display.font = assets.font_frizqt
            end
            return clip
        end)
        return true
    end)
end
