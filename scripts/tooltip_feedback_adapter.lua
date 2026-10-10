local _, addon_table = ...

local adapter = addon_table.use("tooltip_feedback_adapter")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local layout = addon_table.use("translation_layout")
local hooks = addon_table.use("translation_hooks").bind("ptr-feedback")
local tooltip_format = assert(addon_table.forever_tooltip_ui).format
local dependencies
local translated_sources = {}

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
        local claim = region and runtime.get(region)
        local claimed_source = claim and claim.owner == "ptr-feedback"
            and (source == claim.translated or source == claim.source) and claim.source
        local original = claimed_source or source and translated_sources[source] or source
        if region and original == native then
            if tooltip.uaForeverShowOriginal then return end
            if type(runtime.is_stable_claim) == "function"
                and runtime.is_stable_claim(region, tooltip, tooltip.uaForeverGeneration) then
                return
            end
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
            -- The native duplicate scan searches raw text, including link data.
            -- An empty link keeps its English token without displaying it or
            -- tainting the reporter field read before secret tooltip titles.
            local partial = runtime.safe_string_or_nil(reporter.BugTooltipPartialString)
            if not partial then return end
            translated = translated .. "|Hua_forever_ptr:" .. partial .. "|h|h"
            if not tooltip.uaForeverSessionKey then
                dependencies.begin_tooltip(tooltip, "ptr-feedback:" .. tostring(tooltip))
            end
            if tooltip.uaForeverShowOriginal then return end
            local fit = layout.tooltip_after_text(tooltip, region, native, true)
            local combat = runtime.combat_locked()
            if runtime.apply(region, {
                owner = "ptr-feedback", slot = "ptr-feedback",
                source = native, translated = translated,
                priority = runtime.PRIORITY.DOMAIN,
                tooltip = tooltip, surface = tooltip,
                generation = tooltip.uaForeverGeneration,
                instance = tooltip.uaForeverSessionKey, phase = "dynamic",
                lookup_tier = tier or "tooltip-adapter",
                catalog_source = provenance and provenance.source,
                combat_tooltip_text = combat, combat_text_only = combat,
                after_apply = fit, after_visibility = fit,
            }) then
                translated_sources[translated] = native
            end
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
