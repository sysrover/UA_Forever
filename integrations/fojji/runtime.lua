local _, addon_table = ...

local integration = addon_table.use("fojji")
local options = addon_table.use("options")
local assets = addon_table.use("assets")
local runtime = addon_table.use("translation_runtime")
local entries = addon_table.use("entries")
local item_db = addon_table.use("item_client_db")
local spell_db = addon_table.use("spell_client_db")
local layout = addon_table.use("translation_layout")
local text = addon_table.fojji_locale_uk
local settings_text = addon_table.fojji_settings_uk
local installed
local patterns
local native_sources = {}
local translated_values = {}
local cache, cache_size = {}, 0
local scanned = false
local pending_regions = setmetatable({}, { __mode = "k" })
local pending_scan = false
local tooltip_hooked = false
local pending_tooltip
local tooltip_epoch = 0
local journal_locale
local regions = setmetatable({}, { __mode = "k" })
for _, value in pairs(text) do translated_values[value] = true end

local function enabled()
    local account = options.account
    return account and account.enabled and not account.disable_all_translation
        and account.translate_fojji ~= false
end

integration.available = function ()
    if type(_G.FojjiCoreNS) == "table" then return true end
    if C_AddOns and type(C_AddOns.DoesAddOnExist) == "function" then
        return C_AddOns.DoesAddOnExist("FojjiCore")
    end
    if C_AddOns and type(C_AddOns.GetNumAddOns) == "function" then
        for index = 1, C_AddOns.GetNumAddOns() do
            if C_AddOns.GetAddOnInfo(index) == "FojjiCore" then return true end
        end
    end
    return false
end

local function safe_string(value)
    return not runtime.is_secret_value(value) and type(value) == "string"
end

local function escape(value)
    return (value:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local function conversion(source, offset)
    return source:sub(offset):match("^%%[-+ #0]*%d*%.?%d*[sdifg]")
end

local function render(template, captures)
    local result, offset, index = {}, 1, 0
    while offset <= #template do
        local first = template:find("%", offset, true)
        if not first then result[#result + 1] = template:sub(offset); break end
        result[#result + 1] = template:sub(offset, first - 1)
        local token = conversion(template, first)
        if template:sub(first, first + 1) == "%%" then
            result[#result + 1] = "%"
            offset = first + 2
        elseif token then
            index = index + 1
            result[#result + 1] = captures[index] or ""
            offset = first + #token
        else
            result[#result + 1] = "%"
            offset = first + 1
        end
    end
    return table.concat(result)
end

-- Match the printf templates shipped in Fojji's locale. Captures are inserted
-- literally, so links, player names and numbers are never translated as data.
local function compile_patterns()
    if patterns then return end
    patterns = {}
    for source, translated in pairs(text) do
        local parts, count, literal, offset = {}, 0, 0, 1
        while offset <= #source do
            local first = source:find("%", offset, true)
            if not first then break end
            local prefix = source:sub(offset, first - 1)
            parts[#parts + 1] = escape(prefix)
            literal = literal + #prefix
            local token = conversion(source, first)
            if source:sub(first, first + 1) == "%%" then
                parts[#parts + 1] = "%%"
                literal = literal + 1
                offset = first + 2
            elseif token then
                parts[#parts + 1] = token:sub(-1) == "s" and "(.-)" or "([%d%.,+%-]+)"
                count = count + 1
                offset = first + #token
            else
                parts[#parts + 1] = "%%"
                literal = literal + 1
                offset = first + 1
            end
        end
        local suffix = source:sub(offset)
        literal = literal + #suffix
        -- A bare %s must not match arbitrary user text.
        if count > 0 and count <= 16 and literal >= 4 then
            parts[#parts + 1] = escape(suffix)
            patterns[#patterns + 1] = {
                source = source, pattern = "^" .. table.concat(parts) .. "$",
                translation = translated,
            }
        end
    end
    table.sort(patterns, function (a, b)
        if #a.source == #b.source then return a.source < b.source end
        return #a.source > #b.source
    end)
end

local function remember(source, translated)
    if cache_size >= 1024 then cache, cache_size = {}, 0 end
    cache[source] = translated
    cache_size = cache_size + 1
    return translated
end

local translate

local function translate_markup(source)
    local result, offset, changed = {}, 1, false
    local function segment(value)
        local complete = translate(value)
        if complete ~= value then changed = true; return complete end
        local before, body, after = value:match("^(%s*)(.-)(%s*)$")
        if not body or body == "" then return value end
        local translated = translate(body)
        if translated ~= body then changed = true end
        return before .. translated .. after
    end
    while offset <= #source do
        local first = source:find("|", offset, true)
        if not first then result[#result + 1] = segment(source:sub(offset)); break end
        result[#result + 1] = segment(source:sub(offset, first - 1))
        local rest = source:sub(first)
        -- Keep texture, atlas and hyperlink payloads completely opaque.
        local token = rest:match("^|T.-|t") or rest:match("^|A.-|a")
            or rest:match("^|H.-|h.-|h")
            or rest:match("^|c%x%x%x%x%x%x%x%x")
            or rest:match("^|[rn]") or rest:match("^||")
        if not token then return source end
        result[#result + 1] = token
        offset = first + #token
    end
    return changed and table.concat(result) or source
end

translate = function (source)
    if not enabled() or not safe_string(source) then return source end
    source = native_sources[source] or source
    if translated_values[source] then return source end
    local translated = text[source]
    if translated then return translated end
    if cache[source] then return cache[source] end
    compile_patterns()
    for _, rule in ipairs(patterns) do
        local captures = { source:match(rule.pattern) }
        if #captures > 0 then
            return remember(source, render(rule.translation, captures))
        end
    end
    -- Reuse approved domain names without rewriting Fojji's IDs, search data,
    -- communication payloads, player notes or SavedVariables.
    translated = item_db.get_name_by_english(source) or spell_db.get_name_by_english(source)
    if translated and translated ~= source then return remember(source, translated) end
    -- The glossary accepts multiline quest text by its first line. Here only
    -- complete single-line names are eligible, so no paragraph can be lost.
    if addon_table.glossary and not source:find("[\r\n|]") then
        translated = entries.get_glossary_text(source)
        if translated and translated ~= source then return remember(source, translated) end
    end
    if source:find("|", 1, true) then
        translated = translate_markup(source)
        if translated ~= source then return remember(source, translated) end
    end
    -- Do not cache misses until entries.prepare() has built the name indexes.
    return addon_table.glossary and remember(source, source) or source
end

local function mutable(region)
    if InCombatLockdown and InCombatLockdown() then return false end
    if region.IsForbidden and region:IsForbidden() then return false end
    return true
end

local function valid_font_size(size)
    return not runtime.is_secret_value(size) and type(size) == "number" and size > 0
end

local function font_flags(flags)
    if not safe_string(flags) then return "" end
    local result = {}
    for flag in flags:gmatch("[^, ]+") do
        if flag == "OUTLINE" or flag == "THICKOUTLINE" or flag == "MONOCHROME"
            or flag == "SLUG" then result[#result + 1] = flag end
    end
    return table.concat(result, ",")
end

local function localize(region)
    if not region or regions[region] or not region.SetText then return region end
    if not mutable(region) then pending_regions[region] = true; return region end
    pending_regions[region] = nil
    local raw_set = region.trSetText or region.SetText
    local state = { writing = false }
    regions[region] = state
    region.SetText = function (self, source, ...)
        if state.writing or not mutable(self) then return raw_set(self, source, ...) end
        return raw_set(self, translate(source), ...)
    end
    local function refresh(self)
        if state.writing or not mutable(self) then return end
        local source = self:GetText()
        if not safe_string(source) then return end
        local translated = translate(source)
        if translated ~= source then
            state.writing = true
            raw_set(self, translated)
            state.writing = false
        end
    end
    if type(region.SetFormattedText) == "function" then
        hooksecurefunc(region, "SetFormattedText", refresh)
    end
    if type(region.SetFont) == "function" then
        local writing_font = false
        hooksecurefunc(region, "SetFont", function (self, file, size, flags)
            if writing_font or not valid_font_size(size)
                or runtime.is_secret_value(file) or file == assets.font_frizqt
                or not mutable(self) then return end
            writing_font = true
            self:SetFont(assets.font_frizqt, size, font_flags(flags))
            writing_font = false
        end)
        local _, size, flags = region:GetFont()
        -- Kit.Text calls Localize immediately after CreateFontString, before
        -- Kit.SetFont assigns its positive size. Lua treats zero as truthy.
        -- Leave this uninitialized string alone; the hook handles SetFont.
        if valid_font_size(size) then
            region:SetFont(assets.font_frizqt, size, font_flags(flags))
        end
    end
    refresh(region)
    return region
end

local watched = setmetatable({}, { __mode = "k" })
local function walk(frame)
    if not frame or not mutable(frame) then return end
    if frame.IsObjectType and frame:IsObjectType("EditBox") then return end
    if frame.GetRegions then
        for _, region in ipairs({ frame:GetRegions() }) do
            if region.IsObjectType and region:IsObjectType("FontString") then localize(region) end
        end
    end
    if not watched[frame] and frame.HookScript then
        watched[frame] = true
        frame:HookScript("OnShow", walk)
    end
    if frame.GetChildren then
        for _, child in ipairs({ frame:GetChildren() }) do walk(child) end
    end
end

local function owned(frame)
    for _ = 1, 32 do
        if not frame or frame == UIParent then return false end
        if frame.IsForbidden and frame:IsForbidden() then return false end
        local name = frame.GetName and frame:GetName()
        if safe_string(name) and name:find("^Fojji") then return true end
        frame = frame.GetParent and frame:GetParent()
    end
    return false
end

local function translate_journal(addon)
    local locale = addon.DJ and addon.DJ.L
    if not locale or journal_locale == locale then return end
    journal_locale = locale
    for key, value in pairs(locale) do
        if safe_string(value) then
            locale[key] = translate(value)
        elseif type(value) == "table" then
            for _, line in ipairs(value) do
                if type(line) == "table" and safe_string(line[2]) then
                    line[2] = translate(line[2])
                end
            end
        end
    end
end

local function fit_tooltip()
    local tooltip = _G.GameTooltip
    if not enabled() or not tooltip or not tooltip:IsShown() then return end
    local owner = tooltip:GetOwner()
    if not owned(owner) then return end
    if not mutable(tooltip) then
        pending_tooltip = { owner = owner, epoch = tooltip_epoch }
        return
    end
    pending_tooltip = nil
    for index = 1, tooltip:NumLines() do
        for _, side in ipairs({ "Left", "Right" }) do
            local region = _G["GameTooltipText" .. side .. index]
            if region and mutable(region) and region:IsShown() then
                local source = region:GetText()
                if safe_string(source) then
                    local translated = translate(source)
                    if translated ~= source then region:SetText(translated) end
                    runtime.ensure_font(region)
                end
            end
        end
    end
    layout.fit_addon_tooltip(tooltip)
end

integration.prepare = function (rescan)
    if not enabled() then return end
    local addon = _G.FojjiCoreNS
    if type(addon) ~= "table" or type(addon.TR) ~= "table" then return end
    if installed ~= addon then
        installed = addon
        for source, value in pairs(addon.TR) do
            if safe_string(value) and value ~= source then
                if native_sources[value] == nil then native_sources[value] = source
                elseif native_sources[value] ~= source then native_sources[value] = false end
            end
        end
        -- Locale.lua captures this very table, so retain its identity.
        for source, translated in pairs(text) do addon.TR[source] = translated end
        addon.Translated = true
        addon.WideFont = true
        addon.Tr = translate
        addon.Localize = localize
        addon.LocalFont = function () return assets.font_frizqt end
    end
    if not tooltip_hooked and _G.GameTooltip then
        tooltip_hooked = true
        hooksecurefunc(GameTooltip, "Show", fit_tooltip)
        local function clear_tooltip()
            pending_tooltip = nil
            tooltip_epoch = tooltip_epoch + 1
        end
        GameTooltip:HookScript("OnHide", clear_tooltip)
        GameTooltip:HookScript("OnTooltipCleared", function (self)
            clear_tooltip()
            layout.restore_tooltip_rows(self)
        end)
    end
    translate_journal(addon)
    if InCombatLockdown and InCombatLockdown() then pending_scan = true; return end
    if scanned and not rescan then return end
    pending_scan = false
    scanned = true
    if type(EnumerateFrames) == "function" then
        local frame = EnumerateFrames()
        while frame do
            if owned(frame) and not owned(frame:GetParent()) then walk(frame) end
            frame = EnumerateFrames(frame)
        end
    end
end

integration.recover = function ()
    if not enabled() or InCombatLockdown and InCombatLockdown() then return end
    if pending_scan then integration.prepare(true) end
    for region in pairs(pending_regions) do localize(region) end
    local pending = pending_tooltip
    if pending and pending.epoch == tooltip_epoch and GameTooltip
        and GameTooltip:GetOwner() == pending.owner then fit_tooltip() end
end

integration.add_settings = function (page, anchor)
    local group = CreateFrame("Frame", nil, page)
    group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -18)
    group:SetSize(275, 110)
    local check = CreateFrame("CheckButton", nil, group, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT")
    check.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(check.text, settings_text.label)
    local help = group:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    help:SetPoint("TOPLEFT", check, "BOTTOMLEFT", 0, -5)
    help:SetWidth(270)
    help:SetJustifyH("LEFT")
    runtime.set_fallback_text(help, settings_text.help)
    local reload = CreateFrame("Button", nil, group, "UIPanelButtonTemplate")
    reload:SetSize(210, 25)
    reload:SetPoint("TOPLEFT", help, "BOTTOMLEFT", 0, -10)
    runtime.set_fallback_text(reload, settings_text.reload)
    reload:SetScript("OnClick", ReloadUI)
    reload:Hide()
    check:SetScript("OnClick", function (self)
        options.account.translate_fojji = self:GetChecked() == true
        reload:Show()
    end)
    local function refresh()
        group:SetShown(integration.available())
        check:SetChecked(options.account and options.account.translate_fojji ~= false)
    end
    page:HookScript("OnShow", refresh)
    refresh()
end
