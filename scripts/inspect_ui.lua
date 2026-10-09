local _, addon_table = ...
local inspect = addon_table.use("inspect_ui")
local api = addon_table.use("panel_ui_adapter").bind("inspect-ui")
local registry = addon_table.use("translation_registry")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")

local function translate_level(region)
    local source = api.text(region)
    local previous = region and runtime.get(region)
    if previous and source == previous.translated then source = previous.source end
    local level, color, description
    if source then
        level, color, description = source:match("^Level (.-) (|c%x%x%x%x%x%x%x%x)(.-)|r$")
    end
    if not level then return api.label(region) end
    -- Use the inspected unit's class, which can differ from the player's.
    local unit = _G.InspectFrame and InspectFrame.unit
    if unit and type(_G.UnitClass) == "function" then
        local ok, class = pcall(_G.UnitClass, unit)
        class = ok and runtime.safe_string_or_nil(class) or nil
        if class and class ~= "" then
            local first, last = description:find(class, 1, true)
            if first and last == #description then
                local spec = description:sub(1, first - 1):match("^(.-)%s*$")
                local translated_spec = spec ~= "" and (strings.find_ui_translation(spec) or spec) or ""
                description = (translated_spec ~= "" and translated_spec .. " " or "")
                    .. (strings.find_ui_translation(class) or class)
            end
        end
    end
    local wording = addon_table.forever_surface_ui.character
    api.apply(region, wording.level(level, color, description), "character.level_class")
end

local function translate_detail(region)
    local source = api.text(region)
    local previous = region and runtime.get(region)
    if previous and source == previous.translated then source = previous.source end
    local wording = addon_table.forever_surface_ui.inspect
    local translated = source and wording.detail(source, strings.find_ui_translation)
    if translated then api.apply(region, translated) else api.label(region) end
end

local function refresh()
    local frame = _G.InspectFrame
    if not frame then return end
    -- The header and guild name are player data. Only watch UI labels.
    for index = 1, 3 do api.button(_G["InspectFrameTab" .. index]) end
    for _, tab in ipairs(frame.ModeTabs and frame.ModeTabs.Tabs or {}) do
        api.button(tab)
        api.hooks.region_script(tab, "OnEnter", api.tooltip)
    end
    api.watch(_G.InspectLevelText, translate_level)
    api.button(_G.InspectPaperDollFrame and InspectPaperDollFrame.ViewButton)
    -- Install instance scripts when the load-on-demand frames actually exist.
    for _, panel in ipairs({ "InspectFrame", "InspectPaperDollFrame",
        "InspectModelFrame", "InspectPVPFrame", "InspectGuildFrame" }) do
        api.hooks.region_script(_G[panel], "OnShow", refresh)
    end
    local pvp = _G.InspectPVPFrame
    if pvp then
        api.watch(pvp.HKs)
        api.watch(pvp.HonorLevel)
        api.regions(pvp)
        local info = pvp.MainInfoFrame
        if info then
            for _, key in ipairs({ "CurrentSeasonField", "CurrentRankField",
                "CurrentRankProgressField", "HonorableKillsField",
                "LifetimeHKsField", "TodayHKsField" }) do
                api.watch(info[key], translate_detail)
            end
        end
    end
    local guild = _G.InspectGuildFrame
    if guild then
        for _, key in ipairs({ "guildRealmName", "guildLevel", "guildNumMembers" }) do
            api.watch(guild[key], translate_detail)
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
        registry.declare_hook({ id = "inspect-ui:" .. name, surface = "inspect-ui",
            kind = "global", target = name, callback = refresh,
            blizzardAddon = "Blizzard_InspectUI", verifiedBuild = "1.60.1.70291",
            required = false })
    end
    registry.declare_hook({ id = "inspect-ui:SetLevel", surface = "inspect-ui",
        kind = "frame", target = "InspectPaperDollFrame", method = "SetLevel",
        callback = refresh, blizzardAddon = "Blizzard_InspectUI",
        verifiedBuild = "1.60.1.70291" })
    refresh()
end
