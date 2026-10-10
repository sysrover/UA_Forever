local _, addon_table = ...
local panel = addon_table.use("damage_meter_ui")
local api = addon_table.use("panel_ui_adapter").bind("damage-meter")

local function refresh_window(frame)
    if not frame then return end
    api.watch(frame.DamageMeterTypeDropdown and frame.DamageMeterTypeDropdown.TypeName)
    api.watch(frame.SessionDropdown and frame.SessionDropdown.SessionName)
    api.watch(frame.MinimizeContainer and frame.MinimizeContainer.NotActive)
    -- Source names, timers and combat values may be secret. Do not walk rows.
    for _, key in ipairs({ "DamageMeterTypeDropdown", "SessionDropdown", "SettingsDropdown" }) do
        api.hooks.region_script(frame[key], "OnEnter", api.tooltip)
    end
end

local function refresh()
    -- The 70338 client supports three independently created session windows.
    for index = 1, 3 do
        local frame = _G["DamageMeterSessionWindow" .. index]
        api.hooks.region_script(frame, "OnShow", refresh_window)
        refresh_window(frame)
    end
end

panel.prepare = function ()
    api.prepare({ "DamageMeter" }, "Blizzard_DamageMeter", {}, {}, refresh)
    api.hooks.region(_G.DamageMeter, "SetupSessionWindow", refresh)
end
