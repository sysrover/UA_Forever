local _, addon_table = ...
local adapter = addon_table.use("channel_ui")
local ui = addon_table.use("panel_ui_adapter").bind("channel-ui")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local catalog = assert(addon_table.forever_surface_ui.channel_panel)

local function is_custom(row)
    if not row or type(row.IsUserCreatedChannel) ~= "function" then return true end
    local ok, value = pcall(row.IsUserCreatedChannel, row)
    return not ok or runtime.is_secret_value(value) or value ~= false
end

local function source_text(region)
    local source = ui.text(region)
    local claim = region and runtime.get(region)
    return claim and source == claim.translated and claim.source or source
end

local function channel_label(region, row)
    if not region or runtime.is_applying(region) then return end
    if is_custom(row) then runtime.invalidate(region); return end
    local source = source_text(region)
    local translated = source and catalog.name(source)
    if translated then ui.apply(region, translated, "ui.channel") end
end

local function header(region)
    if not region or runtime.is_applying(region) then return end
    local source = source_text(region)
    local translated = source and resolver.find_ui(source, region)
    if not translated then return end
    local color, _, reset = source:match("^(|[cC]%x%x%x%x%x%x%x%x)(.-)(|[rR])$")
    if color and not translated:find("|c", 1, true) then translated = color .. translated .. reset end
    ui.apply(region, translated)
end

local function prepare_channel(row)
    ui.watch(row.Text, function (region) channel_label(region, row) end)
    ui.hooks.region(row, "Update", prepare_channel)
    ui.hooks.region_script(row, "OnHide", function () runtime.invalidate(row.Text) end)
end

local function roster_title(region)
    local frame = _G.ChannelFrame
    local list = frame and frame.ChannelList
    local row
    if list and type(list.GetSelectedChannelButton) == "function" then
        local ok, value = pcall(list.GetSelectedChannelButton, list)
        if ok and not runtime.is_secret_value(value) then row = value end
    end
    channel_label(region, row)
end

local function refresh()
    local frame = _G.ChannelFrame
    if not frame then return end
    ui.watch(frame.TitleText or _G.ChannelFrameTitleText)
    ui.button(frame.NewButton)
    ui.button(frame.SettingsButton)
    local list = frame.ChannelList
    local headers = list and list.headerButtonPool
    if headers and type(headers.EnumerateActive) == "function" then
        for row in headers:EnumerateActive() do ui.watch(row.Text, header) end
    end
    local channels = list and list.textChannelButtonPool
    if channels and type(channels.EnumerateActive) == "function" then
        for row in channels:EnumerateActive() do prepare_channel(row) end
    end
    local roster = frame.ChannelRoster
    ui.watch(roster and roster.ChannelName, roster_title)
    -- Roster member names, community/voice names and user-created channels
    -- remain native; only standard channel display labels are localized.
end

adapter.prepare = function ()
    ui.prepare({ "ChannelFrame" }, "Blizzard_Channels", {}, {
        { "ChannelFrame", "Update" },
    }, refresh)
    local frame = _G.ChannelFrame
    if frame then
        ui.hooks.region(frame.ChannelList, "Update", refresh)
        ui.hooks.region(frame.ChannelRoster, "Update", refresh)
    end
end
