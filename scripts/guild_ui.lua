local _, addon_table = ...
local guild_ui = addon_table.use("guild_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-ui")
local strings = addon_table.use("strings")
local social_ui = addon_table.use("social_ui")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local format_renderer = addon_table.use("spell_template_renderer")
local layout = addon_table.use("translation_layout")
local profiler = addon_table.use("performance_profile")
ui.verified_build = "1.60.1.70888"

local function visible(frame)
    if not frame then return false end
    local ok, shown = pcall(function () return frame:IsVisible() end)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function label(region)
    if visible(region) then ui.label(region) end
end

local function location(region)
    if not region or runtime.is_applying(region) or not visible(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    if not source then return end
    local translated, _, _, category = resolver.find_ui(source, region,
        { category = "zone", slot = "zone.name" })
    if not translated then return end
    if category == "zone" then
        ui.apply(region, translated, "zone.name", "translate_zone", "zone")
    else
        ui.apply(region, translated, "ui.status")
    end
end

local function stream_label(region)
    if not region or runtime.is_applying(region) or not visible(region) then return end
    local root = _G.CommunitiesFrame
    local ok, stream = pcall(function ()
        return root:GetSelectedStreamForClub(root:GetSelectedClubId())
    end)
    if not ok or runtime.is_secret_value(stream) or type(stream) ~= "table" then return end
    local kind = stream.streamType
    local types = _G.Enum and Enum.ClubStreamType
    if runtime.is_secret_value(kind) or not types then return end
    if kind == types.Guild or kind == types.Officer then
        label(region)
    else
        runtime.invalidate(region)
    end
end

local function watch(region, callback)
    ui.watch(region, callback or label)
end

local function button(frame, callback)
    if not frame then return end
    local ok, region = pcall(function () return frame:GetFontString() end)
    if ok then watch(region, callback) end
    if frame.Text ~= region then watch(frame.Text, callback) end
end

local function regions(frame)
    if not frame then return end
    local ok, values = pcall(function () return { frame:GetRegions() } end)
    if not ok then return end
    for _, region in ipairs(values) do
        local kind_ok, kind = pcall(function () return region:GetObjectType() end)
        if kind_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
            watch(region)
        end
    end
end

-- Member names, guild-defined ranks and notes are player data. Only the zone,
-- presence, profession heading and fixed GuildInfo link have display handlers.
local function member_row(row)
    if not row then return end
    watch(row.Zone, location)
    watch(row.GuildInfo)
    watch(row.ProfessionHeader and row.ProfessionHeader.Name)
    ui.hooks.region_script(row, "OnShow", member_row)
end

local function column_label(region)
    if not region or runtime.is_applying(region) or not visible(region) then return end
    local source = ui.text(region)
    local translated = source and resolver.find_ui(source, region)
    if translated then ui.apply(region, translated, "ui.column") end
end

local function columns(frame)
    local pool = frame and frame.columnHeaders
    if not visible(frame) or not pool or type(pool.EnumerateActive) ~= "function" then return end
    -- Column widths also anchor the member cells. Use a claim without generic
    -- button expansion so sorting headers retain the native column geometry.
    for header in pool:EnumerateActive() do button(header, column_label) end
end

local scroll_boxes = setmetatable({}, { __mode = "k" })
local function member_list(frame)
    if not frame then return end
    watch(frame.MemberCount)
    button(frame.ShowOfflineButton)
    ui.hooks.region(frame.ColumnDisplay, "LayoutColumns", columns)
    ui.hooks.region_script(frame.ColumnDisplay, "OnShow", columns)
    columns(frame.ColumnDisplay)
    local box = frame.ScrollBox
    if not box then return end
    local event = _G.ScrollBoxListMixin and ScrollBoxListMixin.Event
        and ScrollBoxListMixin.Event.OnInitializedFrame
    if event and not scroll_boxes[box] and type(box.RegisterCallback) == "function" then
        local callback = function (_, row) member_row(row) end
        if profiler.wrap then callback = profiler.wrap("guild_ui.member", callback) end
        box:RegisterCallback(event, callback, scroll_boxes)
        scroll_boxes[box] = true
    end
    if visible(frame) and type(box.ForEachFrame) == "function"
        and (type(box.HasView) ~= "function" or box:HasView()) then
        box:ForEachFrame(member_row)
    end
end

local function fit_member_detail(frame)
    if not visible(frame) or runtime.combat_locked()
        or not runtime.can_write_text(frame) then return end
    local remove = frame.RemoveButton
    local invite = frame.GroupInviteButton
    if not remove or not invite then return end
    if runtime.can_write_text(remove) then strings.fit_button_to_text(remove) end
    if runtime.can_write_text(invite) then strings.fit_button_to_text(invite) end
    local remove_width = layout.safe_dimension(remove, "GetWidth")
    local invite_width = layout.safe_dimension(invite, "GetWidth")
    local width = layout.safe_dimension(frame, "GetWidth")
    if not remove_width or not invite_width or not width then return end
    -- Build 70888 anchors the footer at x=16, with a 1px gap and 3px
    -- remaining at the right of its native 212px card. Keep those insets.
    local required_width = math.max(212, math.ceil(16 + remove_width + 1 + invite_width + 3))
    if not layout.dimensions_match(width, required_width)
        and runtime.can_write_text(frame) then
        pcall(frame.SetWidth, frame, required_width)
    end
    local clamped_ok, clamped = pcall(function () return frame:IsClampedToScreen() end)
    if clamped_ok and not runtime.is_secret_value(clamped) and clamped == false
        and runtime.can_write_text(frame) then
        pcall(frame.SetClampedToScreen, frame, true)
    end
end

local function member_detail(frame)
    if not frame then return end
    for _, key in ipairs({ "ZoneLabel", "RankLabel", "OnlineLabel", "NoteLabel",
        "OfficerNoteLabel", "Level", "OnlineText" }) do
        watch(frame[key])
    end
    watch(frame.ZoneText, location)
    button(frame.RemoveButton)
    button(frame.GroupInviteButton)
    fit_member_detail(frame)
end

local function guild_info(frame)
    if not frame then return end
    -- These are the Info panel's own headings. MOTD and Details are descendants
    -- populated from C_GuildInfo and are deliberately outside this label set.
    regions(frame.Info)
    button(frame.Info and frame.Info.EditMOTDButton)
    button(frame.Info and frame.Info.EditDetailsButton)
    regions(frame.News)
    button(frame.News and frame.News.SetFiltersButton)
    button(frame.News and frame.News.GMImpeachButton)
end

local function preferred_settings(frame)
    if not frame then return end
    regions(frame)
    for _, key in ipairs({ "LocaleDropdown", "DatacenterDropdown",
        "LocaleApplyButton", "DatacenterApplyButton" }) do
        button(frame[key])
    end
end

-- Translate the native template while retaining all player-supplied arguments,
-- including MOTD, event titles, member names and already constructed item links.
local function news_text(frame, _, template)
    local region = frame and frame.text
    template = runtime.safe_string_or_nil(template)
    if not template or not region or not visible(region) then return end
    local source = ui.text(region)
    if not source or not format_renderer.matches_format(template, source) then return end
    local translated = resolver.find_ui(template)
    if not translated or translated == template then return end
    local text = format_renderer.render_format(template, translated, source)
    if text then ui.apply(region, text, "guild.news") end
end

local handled_panels = {
    CommunitiesList = true, Chat = true, ChatEditBox = true, StreamDropdown = true,
    MemberList = true, GuildDetailsFrame = true, GuildPreferredPlaySettingsFrame = true,
    CommunitiesControlFrame = true, InviteButton = true, GuildLogButton = true,
}

local function other_panels(root)
    local ok, mode = pcall(function () return root:GetDisplayMode() end)
    if not ok or runtime.is_secret_value(mode) or type(mode) ~= "table" then return end
    -- Finder, invitations and benefits retain the shared static-label path.
    -- The native mode lists only the children belonging to the selected tab.
    for _, key in ipairs(mode) do
        if not handled_panels[key] then
            local frame = root[key]
            if visible(frame) then strings.translate_frame(frame, ui.surface) end
        end
    end
end

local function refresh()
    if ui.surface then ui.surface.skip_region = social_ui.skip_user_text end
    local root = _G.CommunitiesFrame
    if not visible(root) then return end
    regions(root.TitleContainer)
    watch(root.StreamDropdown and root.StreamDropdown.Text, stream_label)
    button(root.InviteButton)
    button(root.GuildLogButton)
    local controls = root.CommunitiesControlFrame
    if visible(controls) then
        button(controls.GuildControlButton)
        button(controls.GuildRecruitmentButton)
    end
    if visible(root.MemberList) then member_list(root.MemberList) end
    if visible(root.GuildMemberDetailFrame) then member_detail(root.GuildMemberDetailFrame) end
    if visible(root.GuildDetailsFrame) then guild_info(root.GuildDetailsFrame) end
    if visible(root.GuildPreferredPlaySettingsFrame) then
        preferred_settings(root.GuildPreferredPlaySettingsFrame)
    end
    other_panels(root)
end

guild_ui.prepare = function ()
    ui.prepare({ "CommunitiesFrame" }, "Blizzard_Communities", {}, {
        { "CommunitiesFrame", "SetDisplayMode" },
    }, refresh)
    local root = _G.CommunitiesFrame
    if not root then return end
    -- Register writers before the first show. Each callback checks IsVisible,
    -- so a hidden tab's native refresh cannot translate another tab's content.
    regions(root.TitleContainer)
    watch(root.StreamDropdown and root.StreamDropdown.Text, stream_label)
    button(root.InviteButton)
    button(root.GuildLogButton)
    local controls = root.CommunitiesControlFrame
    button(controls and controls.GuildControlButton)
    button(controls and controls.GuildRecruitmentButton)
    member_list(root.MemberList)
    member_detail(root.GuildMemberDetailFrame)
    guild_info(root.GuildDetailsFrame)
    preferred_settings(root.GuildPreferredPlaySettingsFrame)
    ui.hooks.region_script(root.GuildMemberDetailFrame, "OnShow", member_detail)
    ui.hooks.global("GuildNewsButton_SetText", news_text)
end
