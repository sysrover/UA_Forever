local _, addon_table = ...

local layout = addon_table.use("translation_layout")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local session = addon_table.use("tooltip_session")

session.active = setmetatable({}, { __mode = "k" })

local function invalidate_claims(tooltip, on_invalidate)
    if not on_invalidate then return end
    runtime.for_each_claim(tooltip, function (region)
        on_invalidate(region)
    end)
end

session.begin = function (tooltip, key, show_original, on_invalidate)
    if not tooltip or tooltip.uaForeverSessionKey == key then return false end
    layout.restore_tooltip_width(tooltip)
    invalidate_claims(tooltip, on_invalidate)
    tooltip.uaForeverSessionKey = key
    tooltip.uaForeverGeneration = runtime.begin_generation(tooltip, key)
    tooltip.uaForeverFallback = {}
    tooltip.uaForeverBilingualLines = nil
    tooltip.uaForeverUnitRefreshAt = nil
    tooltip.uaForeverReservedFirst = nil
    tooltip.uaForeverShowOriginal = show_original == true
    session.active[tooltip] = true
    return true
end

session.reset = function (tooltip, on_invalidate)
    if not tooltip then return end
    local suffix = tostring(tooltip)
    for _, prefix in ipairs({
        "tooltip:", "tooltip-late:", "tooltip-item:", "tooltip-item-late:",
        "tooltip-comparison:", "tooltip-aura:",
    }) do
        scheduler.cancel(prefix .. suffix)
    end
    invalidate_claims(tooltip, on_invalidate)
    runtime.begin_generation(tooltip)
    layout.restore_tooltip_width(tooltip)
    tooltip.uaForeverGeneration = runtime.generation(tooltip)
    session.active[tooltip] = nil
    for _, field in ipairs({
        "uaForeverSessionKey", "uaForeverKind", "uaForeverID",
        "uaForeverReservedFirst", "uaForeverFallback",
        "uaForeverShowOriginal", "uaForeverKey", "uaForeverAuraRetryKey",
        "uaForeverGenericText", "uaForeverBilingualLines",
        "uaForeverUnitRefreshAt", "uaForeverUpdateBudget",
        "uaForeverAuraTooltip", "uaForeverAuraUnit",
    }) do
        tooltip[field] = nil
    end
end
