local _, addon_table = ...

local adapter = addon_table.use("compact_raid_manager_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("compact-raid-manager")
local surface

local function is_open()
    local frame = _G.CompactRaidFrameManager
    if not frame then return false end
    local ok, shown = pcall(frame.IsShown, frame)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function translate(region)
    if not region or runtime.is_applying(region) then return end
    return strings.translate_region(region, nil, "ui.label", surface)
end

local function prepare_region(region)
    if not region then return end
    hooks.region(region, "SetText", translate)
    hooks.region(region, "SetFormattedText", translate)
    translate(region)
end

local function prepare_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then prepare_region(region) end
end

local function refresh()
    local root = _G.CompactRaidFrameManager
    local display = root and root.displayFrame
    if not display then return end
    -- Explicit public labels: this is a protected manager, not a unit-frame
    -- tree to walk. Counts, role/group filters and secure actions stay native.
    prepare_region(display.label)
    prepare_region(display.RestrictPingsLabel)
    for _, key in ipairs({ "ModeControlDropdown", "RestrictPingsDropdown", "difficulty" }) do
        local dropdown = display[key]
        prepare_region(dropdown and dropdown.Text)
    end
    local markers = display.raidMarkers
    prepare_button(markers and markers.raidMarkerUnitTab)
    prepare_button(markers and markers.raidMarkerGroundTab)
    prepare_button(_G.CompactRaidFrameManagerLeavePartyButton)
    prepare_button(_G.CompactRaidFrameManagerLeaveInstanceGroupButton)
    -- LeaveInstanceGroupButtonMixin:OnUpdate rewrites the button every frame.
    -- Its existing FontString hook translates that final write in the same call.
end

adapter.prepare = function ()
    surface = registry.register_surface({ id = "compact-raid-manager",
        roots = { "CompactRaidFrameManager" }, domains = { "ui" },
        name_category = "none", slots = { "ui.label" },
        static = refresh, is_open = is_open, protected = true })
    for _, target in ipairs({ "CompactRaidFrameManager_OnLoad",
        "CompactRaidFrameManager_UpdateLabel", "CompactRaidFrameManager_Expand",
        "CompactRaidFrameManager_UpdateOptionsFlowContainer",
        "CompactRaidFrameManager_UpdateDifficultyDropdown" }) do
        registry.declare_hook({ id = "compact-raid-manager:" .. target,
            surface = "compact-raid-manager", kind = "global", target = target,
            callback = refresh, blizzardAddon = "Blizzard_CompactRaidFrames",
            verifiedBuild = "1.60.1.70205" })
    end
    hooks.region_script(_G.CompactRaidFrameManager, "OnShow", refresh)
    refresh()
end
