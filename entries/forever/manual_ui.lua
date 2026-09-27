local _, addonTable = ...

-- Deliberate last-resort UI overrides. Prefer ui.lua for ordinary curated
-- entries and reviewed_ui.lua when promoting a generated candidate.
local overrides = {
}

if addonTable.forever_catalog then
    addonTable.forever_catalog.register_ui_source(
        "manual_ui", "manual_override", overrides, 100)
end
