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

local function rank_label(region, initializing_menu)
    if not region or runtime.is_applying(region)
        or not initializing_menu and not visible(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = addon_table.forever_surface_ui.guild.rank_names[source]
    if translated then
        ui.apply(region, translated, "guild.rank")
    else
        runtime.invalidate(region)
    end
end
guild_ui.rank_label = rank_label

local function initialize_rank_button(frame)
    local region = frame and frame.fontString
    if not region then return end
    rank_label(region, true)
    local claim = runtime.get(region)
    if not claim or claim.slot ~= "guild.rank"
        or ui.text(region) ~= claim.translated then return end
    local width = layout.safe_dimension(region, "GetUnboundedStringWidth")
        or layout.safe_dimension(region, "GetStringWidth")
    if width and not runtime.combat_locked() and runtime.can_write_text(region) then
        local current = layout.safe_dimension(region, "GetWidth")
        if current and not layout.dimensions_match(current, math.ceil(width)) then
            pcall(region.SetWidth, region, math.ceil(width))
        end
    end
end

local function prepare_rank_menu()
    local menu, util = _G.Menu, _G.MenuUtil
    if not menu or type(menu.ModifyMenu) ~= "function"
        or not util or type(util.TraverseMenu) ~= "function" then return end
    for _, tag in ipairs({ "MENU_GUILD_RANKS", "MENU_GUILD_RANK" }) do
        ui.hooks.once(tag, function ()
            local initialize = initialize_rank_button
            if profiler.wrap then initialize = profiler.wrap("guild_ui.rank-row", initialize) end
            local function modify(_, root)
                util.TraverseMenu(root, function (description)
                    description:AddInitializer(initialize)
                end)
            end
            if profiler.wrap then modify = profiler.wrap("guild_ui.ranks", modify) end
            return pcall(menu.ModifyMenu, tag, modify)
        end)
    end
end

-- Standard rank wording is display-only. Native names, notes and rank order
-- remain the data used by the membership and promotion APIs.
local function member_row(row)
    if not row then return end
    watch(row.Zone, location)
    watch(row.GuildInfo)
    watch(row.Rank, rank_label)
    watch(row.ProfessionHeader and row.ProfessionHeader.Name)
    ui.hooks.region_script(row, "OnShow", member_row)
end

local function note_placeholder(region, frame, field, global_name)
    if not region or runtime.is_applying(region) or not visible(region) then return end
    local ok, note = pcall(function ()
        local info = frame:GetMemberInfo()
        if runtime.is_secret_value(info) or type(info) ~= "table" then return false end
        local value = info[field]
        if runtime.is_secret_value(value) then return false end
        return value == nil or value == ""
    end)
    if not ok or note ~= true then runtime.invalidate(region); return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local expected = runtime.safe_string_or_nil(_G[global_name])
    if not expected or source ~= expected then runtime.invalidate(region); return end
    local translated = resolver.find_ui(expected, region)
    if translated then ui.apply(region, translated, "guild.note.placeholder") end
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
guild_ui.columns = columns

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

local function set_width(frame, width)
    local current = layout.safe_dimension(frame, "GetWidth")
    if current and not layout.dimensions_match(current, width)
        and runtime.can_write_text(frame) then
        pcall(frame.SetWidth, frame, width)
    end
end

local function set_height(frame, height)
    local current = layout.safe_dimension(frame, "GetHeight")
    if current and not layout.dimensions_match(current, height)
        and runtime.can_write_text(frame) then
        pcall(frame.SetHeight, frame, height)
    end
end

local function fit_note_box(box, region, width)
    if not visible(box) or not region then return 40 end
    set_width(box, width)
    set_width(region, width - 16)
    local height = 32
    local claim = runtime.get(region)
    if claim and claim.slot == "guild.note.placeholder"
        and ui.text(region) == claim.translated then
        local measured = layout.safe_dimension(region, "GetStringHeight")
        if measured then height = math.max(height, math.ceil(measured)) end
    end
    set_height(region, height)
    local box_height = height + 8
    set_height(box, box_height)
    return box_height
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
    -- The native note boxes are 31px narrower than the card, with 16px
    -- additional text padding. Measure placeholders after applying that width.
    local current_width = layout.safe_dimension(frame, "GetWidth")
    if not current_width then return end
    local public_box = frame.NoteBackground
    local officer_box = frame.OfficerNoteBackground
    local public_height = fit_note_box(public_box,
        public_box and public_box.PersonalNoteText, current_width - 31)
    local officer_height = fit_note_box(officer_box,
        officer_box and officer_box.OfficerNoteText, current_width - 31)
    local officer_label = frame.OfficerNoteLabel
    if visible(officer_label) then
        local ok, _, _, _, _, offset = pcall(officer_label.GetPoint, officer_label, 1)
        if ok and not runtime.is_secret_value(offset) and type(offset) == "number"
            and not layout.dimensions_match(offset, -public_height - 3)
            and runtime.can_write_text(officer_label) then
            pcall(officer_label.SetPoint, officer_label, "TOPLEFT",
                frame.NoteLabel, "BOTTOMLEFT", 0, -public_height - 3)
        end
    end
    local has_officer_note = visible(officer_box)
    local base_height = has_officer_note and _G.COMMUNITIES_GUILD_DETAIL_OFFICER_HEIGHT
        or _G.COMMUNITIES_GUILD_DETAIL_NORM_HEIGHT
    local name_height = layout.safe_dimension(frame.Name, "GetHeight")
    local rank_height = layout.safe_dimension(frame.RankLabel, "GetHeight")
    if not runtime.is_secret_value(base_height) and type(base_height) == "number"
        and name_height and rank_height then
        set_height(frame, base_height + name_height + rank_height
            + public_height - 40 + (has_officer_note and officer_height - 40 or 0))
    end
    local rank_label_width = layout.safe_dimension(frame.RankLabel, "GetWidth")
    if rank_label_width and visible(frame.RankDropdown) then
        set_width(frame.RankDropdown, math.max(1, current_width - 43 - rank_label_width))
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
    watch(frame.RankText, rank_label)
    watch(frame.RankDropdown and frame.RankDropdown.Text, rank_label)
    watch(frame.NoteBackground and frame.NoteBackground.PersonalNoteText, function (region)
        note_placeholder(region, frame, "memberNote", "GUILD_NOTE_EDITLABEL")
    end)
    watch(frame.OfficerNoteBackground and frame.OfficerNoteBackground.OfficerNoteText, function (region)
        note_placeholder(region, frame, "officerNote", "GUILD_OFFICERNOTE_EDITLABEL")
    end)
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

local function reward(row)
    if not row then return end
    if visible(row) and not runtime.is_secret_value(row.itemID) and type(row.itemID) == "number" then
        ui.item(row.Name, "item:" .. row.itemID)
        local achievement_id = row.achievementID
        if not runtime.is_secret_value(achievement_id) and type(achievement_id) == "number" then
            local entry = addon_table.use("achievement_client_db").get(achievement_id)
            local prefix = runtime.safe_string_or_nil(_G.REQUIRES_LABEL)
            local icon = runtime.safe_string_or_nil(_G.COMMUNITIES_GUILD_REWARDS_ACHIEVEMENT_ICON)
            if entry and entry.title and prefix and icon then
                ui.apply(row.SubText, (resolver.find_ui(prefix) or prefix) .. icon
                    .. _G.YELLOW_FONT_COLOR_CODE .. entry.title .. _G.FONT_COLOR_CODE_CLOSE,
                    "guild.reward.requirement")
            end
        else label(row.SubText) end
    end
    ui.hooks.region(row, "Init", reward)
    ui.hooks.region_script(row, "OnShow", reward)
end

local function perk(row)
    if not row then return end
    local id = row.spellID
    if visible(row) and not runtime.is_secret_value(id) and type(id) == "number" then
        local entry = addon_table.use("entries").get_entry("spell", id)
        local translated = entry and entry[1] or addon_table.use("spell_client_db").get_name(id)
        if translated then ui.apply(row.Name, translated, "spell.name", "translate_spell", "spell") end
    end
    ui.hooks.region(row, "Init", perk)
    ui.hooks.region_script(row, "OnShow", perk)
end

local function benefits(frame)
    if not frame then return end
    local perks, rewards = frame.Perks, frame.Rewards
    if perks then ui.watch_scroll(perks.ScrollBox, perk) end
    if rewards then ui.watch_scroll(rewards.ScrollBox, reward) end
    ui.hooks.region_script(frame, "OnShow", benefits)
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
    CommunitiesList = true, CommunitiesListDropdown = true,
    Chat = true, ChatEditBox = true, StreamDropdown = true,
    MemberList = true, GuildDetailsFrame = true, GuildPreferredPlaySettingsFrame = true,
    CommunitiesControlFrame = true, InviteButton = true, GuildLogButton = true,
    GuildFinderFrame = true, CommunityFinderFrame = true, ApplicantList = true,
    RecruitmentDialog = true, PostingExpirationText = true, GuildBenefitsFrame = true,
    InvitationFrame = true, ClubFinderInvitationFrame = true, TicketFrame = true,
    EditStreamDialog = true, NotificationSettingsDialog = true,
    GuildNameAlertFrame = true, GuildNameChangeFrame = true, CommunityNameChangeFrame = true,
    GuildPostingChangeFrame = true, CommunityPostingChangeFrame = true,
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
    benefits(root.GuildBenefitsFrame)
    other_panels(root)
end

guild_ui.prepare = function ()
    ui.prepare({ "CommunitiesFrame" }, "Blizzard_Communities", {}, {
        { "CommunitiesFrame", "SetDisplayMode" },
    }, refresh)
    prepare_rank_menu()
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
    benefits(root.GuildBenefitsFrame)
    ui.hooks.region_script(root.GuildMemberDetailFrame, "OnShow", member_detail)
    ui.hooks.region(root.GuildMemberDetailFrame, "DisplayMember", member_detail)
    ui.hooks.global("GuildNewsButton_SetText", news_text)
end
