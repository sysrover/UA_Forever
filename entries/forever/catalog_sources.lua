local _, addonTable = ...

local catalog = addonTable.forever_catalog or {}
addonTable.forever_catalog = catalog

catalog.TIERS = {
    generated_fallback = 10,
    validated_legacy = 20,
    reviewed_import = 30,
    curated = 40,
    manual_override = 50,
}
catalog.ui_sources = catalog.ui_sources or {}

catalog.register_ui_source = function (name, tier, values, priority, options)
    if type(name) ~= "string" or name == ""
        or catalog.TIERS[tier] == nil or type(values) ~= "table" then
        return false
    end
    catalog.ui_sources[name] = {
        name = name,
        tier = tier,
        values = values,
        priority = tonumber(priority) or 0,
        player_visible = not options or options.player_visible ~= false,
    }
    return true
end

if type(addonTable.string) == "table" then
    catalog.register_ui_source(
        "classic_string", "validated_legacy", addonTable.string, 500)
end
