local _, addon_table = ...
local inspect = addon_table.use("inspect_ui")
local api = addon_table.use("panel_ui_adapter").bind("inspect-ui")
local registry = addon_table.use("translation_registry")

local function refresh()
    local frame = _G.InspectFrame
    if not frame then return end
    -- The header and guild name are player data. Only watch UI labels.
    for index = 1, 3 do api.button(_G["InspectFrameTab" .. index]) end
    for _, tab in ipairs(frame.ModeTabs and frame.ModeTabs.Tabs or {}) do
        api.button(tab)
        api.hooks.region_script(tab, "OnEnter", api.tooltip)
    end
    api.watch(_G.InspectLevelText)
    local pvp = _G.InspectPVPFrame
    if pvp then
        api.watch(pvp.HKs)
        api.watch(pvp.HonorLevel)
        api.regions(pvp)
    end
    local guild = _G.InspectGuildFrame
    if guild then
        for _, key in ipairs({ "guildRealmName", "guildLevel", "guildNumMembers" }) do
            api.watch(guild[key])
        end
    end
end

inspect.prepare = function ()
    api.surface = registry.register_surface({ id = "inspect-ui", roots = { "InspectFrame" },
        domains = { "ui" }, name_category = "none", static = refresh,
        is_open = function ()
            return _G.InspectFrame and InspectFrame:IsShown() or false
        end })
    -- The 70291 frame copies its mixin methods during XML construction.
    -- Frame declarations cover late loading and subsequent writes.
    for _, method in ipairs({ "SetupModeTabsForUnit", "UpdateTabs", "SetSelectedModeTabByID" }) do
        registry.declare_hook({ id = "inspect-ui:" .. method, surface = "inspect-ui",
            kind = "frame", target = "InspectFrame", method = method, callback = refresh,
            blizzardAddon = "Blizzard_InspectUI", verifiedBuild = "1.60.1.70291" })
    end
    for _, name in ipairs({ "InspectSwitchTabs",
        "InspectPVPFrame_Update", "InspectGuildFrame_Update" }) do
        api.hooks.global(name, refresh)
    end
    api.hooks.region_script(_G.InspectPaperDollFrame, "OnShow", refresh)
    api.hooks.region_script(_G.InspectFrame, "OnShow", refresh)
    refresh()
end
