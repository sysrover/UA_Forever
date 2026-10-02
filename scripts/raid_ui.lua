local _, addon_table = ...

local raid_ui = addon_table.use("raid_ui")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local hooks = addon_table.use("translation_hooks").bind("raid-ui")
local surface

local function is_shown(frame)
    if not frame then return false end
    local ok, shown = pcall(frame.IsShown, frame)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function translate_region(region)
    if not region or runtime.is_applying(region) then return end
    return strings.translate_region(region, nil, "ui.label", surface)
end

local function prepare_region(region)
    if not region then return end
    hooks.region(region, "SetText", translate_region)
    hooks.region(region, "SetFormattedText", translate_region)
    return translate_region(region)
end

local function prepare_button(button)
    if not button then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then prepare_region(region) end
end

local function prepare_description()
    local raid = _G.RaidFrame
    local empty = raid and raid.RaidFrameNotInRaid
    local description = empty and empty.ScrollingDescription
    if not description then return end
    local ok, region = pcall(description.GetFontString, description)
    if not ok or not region then return end
    local before_ok, before = pcall(region.GetText, region)
    local changed = prepare_region(region)
    if not changed or runtime.combat_locked() then return end
    local after_ok, after = pcall(region.GetText, region)
    before = before_ok and runtime.safe_string_or_nil(before)
    after = after_ok and runtime.safe_string_or_nil(after)
    if not before or not after or before == after then return end
    -- ScrollingFontMixin sizes its container after writing the FontString.
    -- Native future writes use our region hook before that measurement; the
    -- initial translation needs the same height refresh without resetting scroll.
    local height_ok, height = pcall(region.GetStringHeight, region)
    if not height_ok or runtime.is_secret_value(height) or type(height) ~= "number" then return end
    local container_ok, container = pcall(description.GetFontStringContainer, description)
    if container_ok and container then pcall(container.SetHeight, container, height) end
    local scroll_ok, scroll_box = pcall(description.GetScrollBox, description)
    if scroll_ok and scroll_box and _G.ScrollBoxConstants then
        pcall(scroll_box.FullUpdate, scroll_box, ScrollBoxConstants.UpdateImmediately)
    end
end

local function prepare_info_row(row)
    if not row then return end
    -- These are saved-instance labels, never raid member names or unit data.
    for _, key in ipairs({ "name", "difficulty", "reset", "extended" }) do
        prepare_region(row[key])
    end
end

local function refresh()
    if not is_shown(_G.RaidFrame) and not is_shown(_G.RaidInfoFrame) then return end
    prepare_region(_G.FriendsFrameTitleText)
    prepare_region(_G.RaidParentFrameTitleText)
    local raid = _G.RaidFrame
    if raid then
        local ok, title = pcall(function ()
            local parent = raid:GetParent()
            return parent and parent:GetTitleText()
        end)
        if ok then prepare_region(title) end
    end
    for _, name in ipairs({ "RaidFrameConvertToRaidButton", "RaidFrameRaidInfoButton",
        "RaidInfoExtendButton", "RaidInfoCancelButton", "RaidParentFrameTab1",
        "RaidParentFrameTab2" }) do
        prepare_button(_G[name])
    end
    for _, name in ipairs({ "RaidInfoInstanceLabel", "RaidInfoIDLabel" }) do
        local frame = _G[name]
        prepare_region(frame and frame.text)
    end
    local assist = _G.RaidFrameAllAssistCheckButton
    prepare_region(assist and assist.Text)
    prepare_description()
    local info = _G.RaidInfoFrame
    local scroll_box = info and info.ScrollBox
    if scroll_box and type(scroll_box.ForEachFrame) == "function" then
        pcall(scroll_box.ForEachFrame, scroll_box, prepare_info_row)
    end
end

raid_ui.prepare = function ()
    -- Generic UI walks intentionally skip RaidFrame and unit-related trees.
    -- Translate this build's explicit public labels instead of relaxing that guard.
    surface = registry.register_surface({ id = "raid-ui",
        roots = { "RaidFrame", "RaidInfoFrame", "RaidParentFrame" }, domains = { "ui" },
        name_category = "none", slots = { "ui.label" }, static = refresh,
        is_open = function () return is_shown(_G.RaidFrame) or is_shown(_G.RaidInfoFrame) end })
    for _, target in ipairs({ "RaidFrame_OnShow", "RaidFrame_Update",
        "RaidInfoFrame_Update", "RaidInfoFrame_UpdateButtons" }) do
        registry.declare_hook({ id = "raid-ui:" .. target, surface = "raid-ui",
            kind = "global", target = target, callback = refresh,
            blizzardAddon = "Blizzard_RaidFrame", verifiedBuild = "1.60.1.70170" })
    end
    registry.declare_hook({ id = "raid-ui:instance-row", surface = "raid-ui",
        kind = "global", target = "RaidInfoFrame_InitButton", callback = prepare_info_row,
        blizzardAddon = "Blizzard_RaidFrame", verifiedBuild = "1.60.1.70170" })
    hooks.region_script(_G.RaidFrame, "OnShow", refresh)
    hooks.region_script(_G.RaidInfoFrame, "OnShow", refresh)
    refresh()
end
