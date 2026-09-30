local _, addon_table = ...

local layout = addon_table.use("translation_layout")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local session = addon_table.use("tooltip_session")

session.active = setmetatable({}, { __mode = "k" })

session.begin = function (tooltip, key, show_original, on_invalidate, force)
    if not tooltip or not force and tooltip.uaForeverSessionKey == key then
        return false
    end
    local same_instance = force == true and tooltip.uaForeverSessionKey == key
    local previous_fallback = same_instance and tooltip.uaForeverFallback or nil
    local previous_bilingual = same_instance
        and tooltip.uaForeverBilingualLines or nil
    layout.restore_tooltip_width(tooltip)
    if type(runtime.clear_surface) ~= "function" and on_invalidate
        and type(runtime.for_each_claim) == "function" then
        runtime.for_each_claim(tooltip, on_invalidate)
    end
    tooltip.uaForeverSessionKey = key
    tooltip.uaForeverGeneration = runtime.begin_generation(tooltip, key,
        on_invalidate)
    tooltip.uaForeverFallback = previous_fallback or {}
    tooltip.uaForeverBilingualLines = previous_bilingual
    tooltip.uaForeverUnitRefreshAt = nil
    tooltip.uaForeverReservedFirst = nil
    tooltip.uaForeverShowOriginal = show_original == true
    session.active[tooltip] = true
    return true
end

session.reset = function (tooltip, on_invalidate)
    if not tooltip then return end
    if type(runtime.clear_surface) ~= "function" then
        if on_invalidate and type(runtime.for_each_claim) == "function" then
            runtime.for_each_claim(tooltip, on_invalidate)
        end
        local suffix = tostring(tooltip)
        for _, prefix in ipairs({
            "tooltip:", "tooltip-late:", "tooltip-item:",
            "tooltip-item-late:", "tooltip-comparison:",
        }) do
            scheduler.cancel(prefix .. suffix)
        end
    end
    runtime.begin_generation(tooltip, nil, on_invalidate)
    layout.restore_tooltip_width(tooltip)
    tooltip.uaForeverGeneration = runtime.generation(tooltip)
    session.active[tooltip] = nil
    for _, field in ipairs({
        "uaForeverSessionKey", "uaForeverKind", "uaForeverID",
        "uaForeverReservedFirst", "uaForeverFallback",
        "uaForeverShowOriginal", "uaForeverKey",
        "uaForeverGenericText", "uaForeverBilingualLines",
        "uaForeverUnitRefreshAt", "uaForeverUpdateBudget",
        "uaForeverAuraTooltip", "uaForeverAuraUnit",
        "uaForeverItemStatus", "uaForeverItemCompleteGeneration",
        "uaForeverItemIdentity", "uaForeverItemLoggedIdentity",
        "uaForeverComparisonManagedPending",
        "uaForeverComparisonCompleteGeneration",
        "uaForeverComparisonFallbackGeneration",
        "uaForeverComparisonData", "uaForeverItemID",
        "uaForeverSellPriceLine",
        "uaForeverTalentLines", "uaForeverTalentEntries",
        "uaForeverTalentEntryID",
    }) do
        tooltip[field] = nil
    end
end
