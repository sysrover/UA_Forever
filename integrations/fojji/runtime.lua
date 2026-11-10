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
local tooltip_layout_owned = false
local journal_locale
local regions = setmetatable({}, { __mode = "k" })
for _, value in pairs(text) do translated_values[value] = true end
local item_tooltip_literals = {}
for _, source in ipairs(addon_table.fojji_item_tooltip_sources) do
    item_tooltip_literals[source] = text[source]
end
local quest_format = addon_table.fojji_item_tooltip_quest_format
local quest_prefix = quest_format:match("^(.-)%%s$")
local translated_quest_prefix = text[quest_format]:match("^(.-)%%s$")
local item_line_cache, item_line_cache_size = {}, 0
local item_tooltip_hooks = setmetatable({}, { __mode = "k" })
local native_effect_rows = setmetatable({}, { __mode = "k" })

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

local function unwrap_item_line(source)
    local icon, body
    local token = source:sub(1, 2)
    if token == "|T" then icon, body = source:match("^(|T.-|t%s*)(.*)$")
    elseif token == "|A" then icon, body = source:match("^(|A.-|a%s*)(.*)$") end
    body = body or source
    local color, label, reset
    if body:sub(1, 2) == "|c" then
        color, label, reset = body:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
    end
    return (icon or "") .. (color or ""), label or body, reset or ""
end

local function translate_item_addition(source)
    local literal = item_tooltip_literals[source]
    if literal then return literal end
    if source:sub(1, 1) ~= "|"
        and source:sub(1, #quest_prefix) ~= quest_prefix
        and source:sub(1, #translated_quest_prefix) ~= translated_quest_prefix then return nil end
    local cached = item_line_cache[source]
    if cached ~= nil then return cached ~= false and cached or nil end
    local prefix, body, suffix = unwrap_item_line(source)
    local translated = item_tooltip_literals[body]
    if not translated then
        local title
        if body:sub(1, #quest_prefix) == quest_prefix then
            title = body:sub(#quest_prefix + 1)
        elseif body:sub(1, #translated_quest_prefix) == translated_quest_prefix then
            title = body:sub(#translated_quest_prefix + 1)
        else
            return nil
        end
        local title_prefix, english, title_suffix = unwrap_item_line(title)
        local ids = entries.get_quest_title_ids(english)
        local entry = ids and #ids == 1 and entries.get_entry("quest", ids[1], 1)
        local name = entry and entry[1]
        translated = translated_quest_prefix .. title_prefix
            .. (safe_string(name) and name or english) .. title_suffix
    end
    translated = translated and prefix .. translated .. suffix or nil
    -- Quest indexes are prepared at login; do not retain an early name miss.
    if entries.prepared then
        if item_line_cache_size >= 256 then item_line_cache, item_line_cache_size = {}, 0 end
        item_line_cache[source] = translated ~= source and translated or false
        item_line_cache_size = item_line_cache_size + 1
    end
    return translated ~= source and translated or nil
end

local function apply_item_addition(tooltip, row)
    if tooltip.uaForeverKind ~= "item" or not tooltip.uaForeverSessionKey then return end
    local ok, visible = pcall(row.region.GetText, row.region)
    if not ok or not safe_string(visible)
        or visible ~= row.source and visible ~= row.translated then return end
    local claim = runtime.get(row.region)
    local expected = tooltip.uaForeverShowOriginal and row.source or row.translated
    if claim and claim.owner == "fojji-tooltip" and claim.surface == tooltip
        and claim.generation == tooltip.uaForeverGeneration
        and claim.instance == tooltip.uaForeverSessionKey
        and claim.source == row.source and claim.translated == row.translated
        and visible == expected then return end
    runtime.apply(row.region, {
        owner = "fojji-tooltip", slot = "item.fojji:" .. row.index,
        option = "translate_item", options = { "translate_fojji" },
        source = row.source, translated = row.translated,
        priority = runtime.PRIORITY.DOMAIN, surface = tooltip, tooltip = tooltip,
        generation = tooltip.uaForeverGeneration, instance = tooltip.uaForeverSessionKey,
        allow_unknown_source = true, record_runtime = false,
        verify_after_apply = false, reapply_cached = true,
        combat_tooltip_text = runtime.combat_locked(), combat_text_only = true,
    })
end

integration.finish_item_lines = function (tooltip)
    local rows = tooltip and tooltip.uaForeverFojjiRows
    if not rows or not enabled() then return end
    -- A Fojji post-call may precede ours. Adopt only its recorded rows after
    -- the item/comparison adapter has established the authoritative session.
    for _, row in pairs(rows) do
        apply_item_addition(tooltip, row)
    end
end

local function item_line_added(tooltip, source)
    if not enabled() or not safe_string(source) then return end
    local translated = translate_item_addition(source)
    if not translated then return end
    local count_ok, index = pcall(tooltip.NumLines, tooltip)
    local name_ok, name = pcall(tooltip.GetName, tooltip)
    if not count_ok or runtime.is_secret_value(index) or type(index) ~= "number"
        or not name_ok or not safe_string(name) then return end
    local region = _G[name .. "TextLeft" .. index]
    if not region then return end
    local rows = tooltip.uaForeverFojjiRows
    if not rows then rows = {}; tooltip.uaForeverFojjiRows = rows end
    local row = { region = region, index = index, source = source, translated = translated }
    rows[index] = row
    -- Modifier state is synchronized by our item post-call. Avoid an early
    -- translated write if Fojji happens to run before that synchronization.
    if options.account.shift_original_tooltip ~= false and type(_G.IsShiftKeyDown) == "function" then
        local ok, shift = pcall(_G.IsShiftKeyDown)
        if not ok or runtime.is_secret_value(shift) or shift then return end
    end
    apply_item_addition(tooltip, row)
end

local function prepare_item_tooltips()
    for _, name in ipairs({ "GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2" }) do
        local tooltip = _G[name]
        if tooltip and not item_tooltip_hooks[tooltip] then
            hooksecurefunc(tooltip, "AddLine", item_line_added)
            local function clear(self)
                self.uaForeverFojjiRows = nil
                native_effect_rows[self] = nil
            end
            tooltip:HookScript("OnTooltipCleared", clear)
            tooltip:HookScript("OnHide", clear)
            item_tooltip_hooks[tooltip] = true
        end
    end
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

-- Recover effects left native after the Item post-call. Retry only known
-- effect templates at Fojji's completed Show boundary, using
-- the item owner's claims so Shift and subsequent native rebuilds retain them.
local function translate_native_effect(tooltip, region, source, side, index, owner)
    if tooltip.uaForeverKind ~= "item" or tooltip.uaForeverShowOriginal
        or not tooltip.uaForeverSessionKey or not tooltip.uaForeverGeneration
        or not options.can_translate("translate_item")
        or options.section_enabled and not options.section_enabled("item_details") then return false end
    local clean = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if not clean:match("^Equip:%s") and not clean:match("^Use:%s")
        and not clean:match("^Chance on hit:%s") then return false end
    local rows = native_effect_rows[tooltip]
    if not rows or rows.owner ~= owner or rows.generation ~= tooltip.uaForeverGeneration
        or rows.instance ~= tooltip.uaForeverSessionKey then
        rows = { owner = owner, generation = tooltip.uaForeverGeneration,
            instance = tooltip.uaForeverSessionKey }
        native_effect_rows[tooltip] = rows
    end
    local key = side .. index
    local row = rows[key]
    if not row or row.source ~= source or row.region ~= region then
        row = { source = source, region = region,
            translated = addon_table.forever_tooltip_ui.translate_item_line(source) or false }
        rows[key] = row
    end
    if not row.translated then return false end
    local claim = runtime.get(region)
    local same_claim = claim and claim.owner == "item-tooltip" and claim.surface == tooltip
        and claim.generation == rows.generation and claim.instance == rows.instance
        and claim.source == source
    return runtime.apply(region, {
        owner = "item-tooltip", slot = same_claim and claim.slot
            or (side == "Right" and "item.right:" or "item.shared-line:") .. index,
        option = "translate_item", source = source, translated = row.translated,
        priority = runtime.PRIORITY.DOMAIN, surface = tooltip, tooltip = tooltip,
        generation = rows.generation, instance = rows.instance, phase = "dynamic",
        allow_unknown_source = true, record_runtime = false,
        verify_after_apply = false, reapply_cached = true,
    }) == true
end

local function fit_tooltip()
    local tooltip = _G.GameTooltip
    if not enabled() or not tooltip or not tooltip:IsShown() then return end
    local owner = tooltip:GetOwner()
    if not owned(owner) then return end
    if not mutable(tooltip) then
        pending_tooltip = { owner = owner, epoch = tooltip_epoch,
            generation = tooltip.uaForeverGeneration, instance = tooltip.uaForeverSessionKey }
        return
    end
    pending_tooltip = nil
    local item = tooltip.uaForeverKind == "item"
    if item and tooltip.uaForeverShowOriginal then return end
    local changed = false
    for index = 1, tooltip:NumLines() do
        for _, side in ipairs({ "Left", "Right" }) do
            local region = _G["GameTooltipText" .. side .. index]
            if region and mutable(region) and region:IsShown() then
                local source = region:GetText()
                if safe_string(source) then
                    local translated = translate(source)
                    if translated ~= source then
                        region:SetText(translated)
                        runtime.ensure_font(region)
                        changed = true
                    elseif item then
                        changed = translate_native_effect(tooltip, region, source,
                            side, index, owner) or changed
                    else
                        runtime.ensure_font(region)
                    end
                end
            end
        end
    end
    if item then
        -- The shared Show hook owns item geometry and its measurement cache.
        -- A second fit is needed only when this pass actually changed a row.
        if changed then layout.fit_item_tooltip(tooltip) end
    elseif layout.fit_addon_tooltip(tooltip) then
        tooltip_layout_owned = true
    end
end

integration.prepare = function (rescan)
    if not enabled() then return end
    local addon = _G.FojjiCoreNS
    if type(addon) ~= "table" or type(addon.TR) ~= "table" then return end
    prepare_item_tooltips()
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
        GameTooltip:HookScript("OnHide", function ()
            clear_tooltip()
            tooltip_layout_owned = false
        end)
        GameTooltip:HookScript("OnTooltipCleared", function (self)
            clear_tooltip()
            if tooltip_layout_owned then
                tooltip_layout_owned = false
                layout.restore_tooltip_rows(self)
            end
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
        and GameTooltip:GetOwner() == pending.owner
        and GameTooltip.uaForeverGeneration == pending.generation
        and GameTooltip.uaForeverSessionKey == pending.instance then fit_tooltip() end
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
    return group
end
