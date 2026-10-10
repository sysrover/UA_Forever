local _, addon_table = ...

local adapter = addon_table.use("tooltip_feedback_adapter")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local layout = addon_table.use("translation_layout")
local hooks = addon_table.use("translation_hooks").bind("ptr-feedback")
local tooltip_format = assert(addon_table.forever_tooltip_ui).format
local dependencies
local views = setmetatable({}, { __mode = "k" })
local watched_rows = setmetatable({}, { __mode = "k" })

local function row_text(region)
    local ok, value = pcall(region.GetText, region)
    return ok and runtime.safe_string_or_nil(value) or nil
end

local function release_view(view)
    local region = view.region
    view.region = nil
    view.label:Hide()
    runtime.invalidate(view.label)
    if region then
        watched_rows[region].view = nil
        pcall(region.SetAlpha, region, view.alpha)
        -- Only this hidden feedback row has a temporary height. Release it
        -- before Blizzard reuses the FontString for another item or quest.
        pcall(region.SetHeight, region, 0)
    end
end

local function feedback_view(tooltip, region)
    local view = views[tooltip]
    if not view then
        local label = tooltip:CreateFontString(nil, "OVERLAY", "GameTooltipText")
        label:Hide()
        view = { label = label }
        views[tooltip] = view
        -- Cleanup must also run when translation has just been disabled.
        tooltip:HookScript("OnTooltipCleared", function () release_view(view) end)
        tooltip:HookScript("OnHide", function () release_view(view) end)
    end
    local watcher = watched_rows[region]
    if not watcher then
        watcher = {}
        watched_rows[region] = watcher
        local function native_write()
            if watcher.view then release_view(watcher.view) end
        end
        hooksecurefunc(region, "SetText", native_write)
        hooksecurefunc(region, "SetFormattedText", native_write)
    end
    return view, watcher
end

local function apply_feedback(tooltip, region, native, translated, tier, provenance)
    -- Creating/anchoring the separate label is deferred until the next native
    -- tooltip refresh outside combat. The original instruction stays usable.
    if runtime.combat_locked() or not runtime.can_write_text(region)
        or not runtime.can_write_text(tooltip) then return end
    local view, watcher = feedback_view(tooltip, region)
    local existing = runtime.get(view.label)
    if view.region == region and existing
        and existing.generation == tooltip.uaForeverGeneration
        and existing.instance == tooltip.uaForeverSessionKey
        and existing.translated == translated then
        runtime.show_original(view.label, tooltip.uaForeverShowOriginal == true)
        return
    end
    release_view(view)
    local ok, alpha = pcall(region.GetAlpha, region)
    if not ok or runtime.is_secret_value(alpha) or type(alpha) ~= "number" then return end
    local label = view.label
    label:SetFontObject(region:GetFontObject())
    label:ClearAllPoints()
    label:SetPoint("TOPLEFT", region, "TOPLEFT")
    label:SetPoint("TOPRIGHT", region, "TOPRIGHT")
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetWordWrap(true)
    label:SetNonSpaceWrap(true)
    label:SetMaxLines(0)
    label:SetHeight(0)
    label:SetText(native)
    local fit = layout.tooltip_after_text(tooltip, label, native)
    if not fit then return end
    view.region, view.alpha = region, alpha
    watcher.view = view
    local function refresh()
        if view.region ~= region then return end
        local claim = runtime.get(label)
        if not claim or row_text(region) ~= native then
            release_view(view)
            return
        end
        local original = claim.visible_original or tooltip.uaForeverShowOriginal
            or not runtime.allowed(claim)
        if fit() then
            local height = layout.safe_dimension(label, "GetStringHeight")
            if height and height > 0 then region:SetHeight(original and 0 or height) end
        end
        region:SetAlpha(original and view.alpha or 0)
        label:SetShown(not original)
    end
    -- Leave GetText() on the native row unchanged: the secure PTR reporter
    -- scans it for duplicates. Never hide a token inside hyperlink markup.
    if not runtime.apply(label, {
        owner = "ptr-feedback", slot = "ptr-feedback",
        source = native, translated = translated,
        priority = runtime.PRIORITY.DOMAIN,
        tooltip = tooltip, surface = tooltip,
        generation = tooltip.uaForeverGeneration,
        instance = tooltip.uaForeverSessionKey, phase = "dynamic",
        lookup_tier = tier or "tooltip-adapter",
        catalog_source = provenance and provenance.source,
        after_visibility = refresh,
    }) then
        release_view(view)
    end
end

adapter.configure = function (value)
    dependencies = value
end

-- Build 70338 ships this owner with OnlyBetaAndPTR: 1. Do not create it,
-- load its addon, or search ordinary tooltips when the beta feature is absent.
adapter.is_instruction = function (source)
    source = runtime.safe_string_or_nil(source)
    local reporter = _G.PTR_IssueReporter
    if not source or not reporter then return false end
    local partial = runtime.safe_string_or_nil(reporter.BugTooltipPartialString)
    return partial and source:find(partial, 1, true) ~= nil
        or source == runtime.safe_string_or_nil(reporter.MissingBindTooltipString)
end

local function line_count(tooltip)
    if not tooltip or runtime.is_secret_value(tooltip) then return nil end
    local ok, count = pcall(function () return tooltip:NumLines() end)
    if not ok or runtime.is_secret_value(count) or type(count) ~= "number" then
        return nil
    end
    return count
end

local function translate_instruction(tooltip, tooltip_type)
    if not dependencies or not options.can_translate() then return end
    local count = line_count(tooltip)
    local reporter = _G.PTR_IssueReporter
    tooltip_type = runtime.safe_string_or_nil(tooltip_type)
    if not count or not reporter or not tooltip_type then return end
    local ok, shortcut = pcall(reporter.GetKeybind)
    -- Empty is the native signal for an unbound key, rather than missing text.
    if not ok or runtime.is_secret_value(shortcut)
        or type(shortcut) ~= "string" then return end
    local native, translated
    if shortcut ~= "" then
        local template = runtime.safe_string_or_nil(reporter.BugTooltipString)
        if not template then return end
        ok, native = pcall(string.format, template, shortcut, tooltip_type)
        if not ok then return end
        translated = tooltip_format.ptr_feedback(shortcut)
    else
        native = runtime.safe_string_or_nil(reporter.MissingBindTooltipString)
    end
    if not native then return end
    for index = count, 1, -1 do
        local source, region = dependencies.tooltip_line(tooltip, "Left", index)
        source = runtime.safe_string_or_nil(source)
        if region and source == native then
            if tooltip.uaForeverShowOriginal then return end
            -- Prefer existing approved exact wording, including the unbound-key
            -- instruction. The catalog formatter covers every native report type.
            local lookup, _, tier, _, _, _, provenance =
                strings.find_ui_translation(native, region)
            translated = runtime.safe_string_or_nil(lookup) or translated
            if not translated or translated == native then return end
            local color = native:match("^(|c%x%x%x%x%x%x%x%x)")
            if color and not translated:match("^|c%x%x%x%x%x%x%x%x") then
                translated = color .. translated
            end
            if native:sub(-2) == "|r" and translated:sub(-2) ~= "|r" then
                translated = translated .. "|r"
            end
            if not tooltip.uaForeverSessionKey then
                dependencies.begin_tooltip(tooltip, "ptr-feedback:" .. tostring(tooltip))
            end
            if tooltip.uaForeverShowOriginal then return end
            apply_feedback(tooltip, region, native, translated, tier, provenance)
            -- No AddLine fallback or Show: the native reporter owns both.
            return
        end
    end
end

adapter.prepare = function ()
    local reporter = _G.PTR_IssueReporter
    if not dependencies or not reporter
        or type(reporter.HookIntoTooltip) ~= "function" then return false end
    return hooks.once("tooltip-writer", function ()
        local template = runtime.safe_string_or_nil(reporter.BugTooltipString)
        local missing = runtime.safe_string_or_nil(reporter.MissingBindTooltipString)
        local marker = template and template:match("^(|c%x%x%x%x%x%x%x%x)")
        if not marker or not missing or missing:sub(1, #marker) ~= marker then
            return false
        end
        if not hooks.region(reporter, "HookIntoTooltip", translate_instruction,
            "tooltips") then return false end
        -- Keep both the native function and its data secure. Writing even the
        -- duplicate token taints string.gmatch when its first argument is secret.
        return true
    end)
end
