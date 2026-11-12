local _, addon_table = ...
local guild_ui = addon_table.use("guild_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("social")
local profiler = addon_table.use("performance_profile")

local function visible(frame)
    if not frame then return false end
    local ok, shown = pcall(function () return frame:IsVisible() end)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function translate(region, category)
    if not region or runtime.is_applying(region) or not visible(region) then return end
    strings.translate_region(region, category,
        category == "zone" and "zone.name" or "ui.text", registry.get("social"))
end

local function translate_label(region) translate(region) end
local function translate_location(region) translate(region, "zone") end

local function watch(region, callback)
    if not region then return end
    callback = callback or translate_label
    hooks.region(region, "SetText", callback)
    hooks.region(region, "SetFormattedText", callback)
    callback(region)
end

local function watch_button(button)
    if not button then return end
    local ok, region = pcall(function () return button:GetFontString() end)
    if ok then watch(region) end
    watch(button.Text)
end

-- The native roster reuses these rows and rewrites expanded columns separately
-- from Init. Watch only display fields, leaving player names and notes alone.
local function prepare_member(row)
    if not row then return end
    watch(row.Zone, translate_location)
    watch(row.Rank)
    watch(row.GuildInfo)
end

local function translate_columns(member_list)
    local columns = member_list and member_list.ColumnDisplay
    if visible(columns) then strings.translate_frame(columns, registry.get("social")) end
end

local scroll_boxes = setmetatable({}, { __mode = "k" })
local function prepare_members(member_list)
    if not member_list then return end
    watch(member_list.MemberCount)
    watch_button(member_list.ShowOfflineButton)
    hooks.region(member_list, "RefreshLayout", translate_columns)
    translate_columns(member_list)
    local scroll_box = member_list.ScrollBox
    if not scroll_box then return end
    local event = _G.ScrollBoxListMixin and ScrollBoxListMixin.Event
        and ScrollBoxListMixin.Event.OnInitializedFrame
    if event and not scroll_boxes[scroll_box]
        and type(scroll_box.RegisterCallback) == "function" then
        local callback = function (_, row) prepare_member(row) end
        if profiler.wrap then callback = profiler.wrap("guild_ui.member", callback) end
        scroll_box:RegisterCallback(event, callback, scroll_boxes)
        scroll_boxes[scroll_box] = true
    end
    if type(scroll_box.ForEachFrame) == "function"
        and (type(scroll_box.HasView) ~= "function" or scroll_box:HasView()) then
        scroll_box:ForEachFrame(prepare_member)
    end
end

-- Also used by the shared social walk, including its first pass. Native guild
-- messages, descriptions and chat must never be treated as static UI labels.
guild_ui.skip_region = function (region, parent)
    local root = _G.CommunitiesFrame
    if not root or not parent then return false end
    if parent.Note == region or parent.MOTD == region or parent.Details == region then
        return true
    end
    if parent.Zone == region or parent.Rank == region or parent.GuildInfo == region then
        return true
    end
    local current = parent
    for _ = 1, 24 do
        if current == root.Chat then return true end
        if not current or current == root or current == _G.UIParent then return false end
        local ok, next_parent = pcall(function () return current:GetParent() end)
        if not ok or runtime.is_secret_value(next_parent) then return true end
        current = next_parent
    end
    return true
end

local function refresh_display(root)
    prepare_members(root and root.MemberList)
    -- SetDisplayMode shows the new child panels without showing the root again.
    -- The registry coalesces updates and walks only the currently shown branch.
    if visible(root) then registry.refresh("social") end
end

guild_ui.prepare = function ()
    local root = _G.CommunitiesFrame
    if not root then return end
    hooks.region(root, "SetDisplayMode", refresh_display)
    prepare_members(root.MemberList)

    local settings = root.GuildPreferredPlaySettingsFrame
    if settings then
        for _, key in ipairs({ "Title", "NotGuildMasterNotice", "LocaleLabel", "DatacenterLabel" }) do
            watch(settings[key])
        end
        for _, key in ipairs({ "LocaleDropdown", "DatacenterDropdown",
            "LocaleApplyButton", "DatacenterApplyButton" }) do
            watch_button(settings[key])
        end
    end
    local details = root.GuildDetailsFrame
    local info = details and details.Info
    if info then
        watch(info.TitleText)
        watch(info.Header1Label)
        watch(info.Header2Label)
        watch_button(info.EditMOTDButton)
        watch_button(info.EditDetailsButton)
    end
    watch_button(root.GuildLogButton)
    local controls = root.CommunitiesControlFrame
    watch_button(controls and controls.GuildControlButton)
end
