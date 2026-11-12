local _, addon_table = ...
local management = addon_table.use("guild_management_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-management")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local text = addon_table.use("guild_ui_text")
local fonts = addon_table.use("fonts")
local guild = addon_table.use("guild_ui")
local options = addon_table.use("options")
ui.verified_build = "1.60.1.70888"

local roots = {
    "GuildControlUI", "CommunitiesAvatarPickerDialog", "CommunitiesSettingsDialog",
    "CommunitiesTicketManagerDialog", "CommunitiesGuildTextEditFrame",
    "CommunitiesGuildLogFrame", "CommunitiesGuildNewsFiltersFrame",
}
local rank_frames = { "GuildControlUIRankOrderFrame", "GuildControlUIRankSettingsFrame",
    "GuildControlUIRankBankFrame", "GuildControlUIRankDiscordFrame" }
local embedded = { "InvitationFrame", "ClubFinderInvitationFrame", "TicketFrame",
    "EditStreamDialog", "NotificationSettingsDialog", "GuildNameAlertFrame",
    "GuildNameChangeFrame", "CommunityNameChangeFrame", "GuildPostingChangeFrame", "CommunityPostingChangeFrame" }

local function skip(region)
    local parent = region:GetParent()
    if not parent then return true end
    if parent:GetObjectType() == "EditBox" then
        return region ~= parent.Instructions and region ~= parent.PromptText
            and region ~= parent.LabelText
    end
    local container = parent:GetParent()
    if container and container.columnHeaders then return true end
    if container and parent == container.CommunitiesListDropdown then return true end
    if parent.StreamName == region then
        local ok, stream = pcall(function ()
            return _G.C_Club.GetStreamInfo(parent.clubId, parent.streamId)
        end)
        local types = _G.Enum and Enum.ClubStreamType
        if not ok or runtime.is_secret_value(stream) or type(stream) ~= "table" or not types then return true end
        local kind = stream.streamType
        return runtime.is_secret_value(kind) or kind ~= types.Guild and kind ~= types.Officer
    end
    for _, key in ipairs({ "tabName", "Creator", "Link", "LinkIDText", "Name", "ClubName", "ClubDescription" }) do
        if parent[key] == region then return true end
    end
    -- Discord dropdown selections contain external server/channel names.
    local discord = _G.GuildControlUIRankDiscordFrame
    return discord and (parent == discord.serverDropdown or parent == discord.channelDropdown)
end

local formats = { "COMMUNITIES_INVITE_MANAGER_LABEL", "COMMUNITIES_INVITE_MANAGER_USES_FORMAT",
    "GUILDCONTROL_DISCORD_SETTINGS", "CLUB_FINDER_RECRUITMENT_POSTING_EXPIRED",
    "DISCORD_GUILD_LINKED_SERVER", "DISCORD_GUILD_LINKED_CHANNEL", "DISCORD_VALID_SERVER_CHANNEL_LIST",
    "COMMUNITY_INVITATION_FRAME_INVITATION_TEXT", "COMMUNITIES_INVIVATION_FRAME_DESCRIPTION_FORMAT",
    "COMMUNITIES_INVIVATION_FRAME_LEADER_FORMAT", "COMMUNITIES_INVITATION_FRAME_MEMBER_COUNT" }
local function label(region)
    if not ui.visible(region) or runtime.is_applying(region) or skip(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    if not source then return end
    local translated = text.format(source, formats)
        or text.format(source, { "CLUB_FINDER_BANNED_POSTING_WARNING" }, function (value)
            return resolver.find_ui(value) or value
        end)
    local parent = region:GetParent()
    if parent.Description == region or parent.Leader == region or parent.linkedServer == region
        or parent.linkedChannel == region or parent.channelListTitle == region then
        if translated then ui.apply(region, translated) end
        return
    end
    translated = translated or text.time(source)
    if translated ~= source then ui.apply(region, translated) else ui.label(region) end
end

local function panel(frame, seen)
    if not frame then return end
    ui.hooks.region_script(frame, "OnShow", function (self) panel(self) end)
    ui.watch_frame(frame, skip, label, seen)
end

local function permissions(region)
    if not ui.visible(region) or runtime.is_applying(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = text.lines(source)
    if translated and translated ~= source then ui.apply(region, translated, "guild.permissions") end
end

local function control_frame(frame)
    if not frame then return end
    -- Register context-sensitive writers before generic static labels.
    ui.watch(frame.dropdown and frame.dropdown.Text, guild.rank_label)
    ui.watch(frame.OfficerPermissions, permissions)
    panel(frame)
end

local function control()
    local root = _G.GuildControlUI
    if not root then return end
    local seen = {}
    for _, name in ipairs(rank_frames) do
        local frame = _G[name]
        if frame then
            control_frame(frame)
            seen[frame] = true
        end
    end
    panel(root, seen)
    -- These rows are created lazily by BankTabPermissions_Update.
    local limit = tonumber(_G.MAX_GUILDBANK_TABS) or 8
    for i = 1, math.min(limit, 20) do panel(_G["GuildControlBankTab" .. i]) end
end

local function ticket_row(row)
    if not row then return end
    ui.watch(row.Uses, label)
    ui.watch(row.Expires, label)
    ui.hooks.region_script(row, "OnShow", ticket_row)
end

local function tickets()
    local frame = _G.CommunitiesTicketManagerDialog
    if not frame then return end
    local manager = frame.InviteManager
    local seen = {}
    if manager then
        if manager.ScrollBox then seen[manager.ScrollBox] = true end
        if manager.ColumnDisplay then seen[manager.ColumnDisplay] = true end
        ui.watch_scroll(manager.ScrollBox, ticket_row)
        guild.columns(manager.ColumnDisplay)
        ui.hooks.region(manager.ColumnDisplay, "LayoutColumns", guild.columns)
        ui.hooks.region_script(manager.ColumnDisplay, "OnShow", guild.columns)
    end
    panel(frame, seen)
end

local log_display = setmetatable({}, { __mode = "k" })
local function guild_log(html, source)
    if runtime.is_applying(html) or not ui.visible(html) then return end
    source = runtime.safe_string_or_nil(source)
    local translated = text.log(source)
    if translated and translated ~= source then
        runtime.apply(html, { owner = "guild-management", slot = "guild.log",
            source = source, translated = translated, surface = ui.surface,
            option = "translate_string", priority = runtime.PRIORITY.DOMAIN,
            reapply_cached = true, visible_matches = function (_, expected)
                return log_display[html] == expected
            end })
    end
end

local function prepare_log()
    local root = _G.CommunitiesGuildLogFrame
    local html = root and root.Container and root.Container.ScrollFrame
        and root.Container.ScrollFrame.Child and root.Container.ScrollFrame.Child.HTMLFrame
    if not html then return end
    fonts.register_html(html, { P = _G.GameFontHighlight })
    ui.hooks.region(html, "SetText", function (self, source)
        -- SimpleHTML has GetTextData but no GetText. Observe this exact native
        -- writer, including runtime restoration, for the claim's display check.
        log_display[self] = runtime.safe_string_or_nil(source)
        if options.work_enabled("guild-management") then guild_log(self, source) end
    end, nil, true)
end

local function refresh()
    if ui.surface then ui.surface.skip_region = skip end
    control()
    for _, name in ipairs(roots) do
        if name ~= "GuildControlUI" and name ~= "CommunitiesTicketManagerDialog" then panel(_G[name]) end
    end
    tickets()
    local log = _G.CommunitiesGuildLogFrame
    local html = log and log.Container and log.Container.ScrollFrame
        and log.Container.ScrollFrame.Child and log.Container.ScrollFrame.Child.HTMLFrame
    if html and ui.visible(html) then
        local source = log_display[html]
        local claim = runtime.get(html)
        if claim and source == claim.translated then source = claim.source end
        guild_log(html, source)
    end
    local root = _G.CommunitiesFrame
    if root then
        for _, key in ipairs(embedded) do panel(root[key]) end
        ui.hooks.region(root, "SetDisplayMode", refresh)
        ui.hooks.region_script(root, "OnShow", refresh)
        ui.hooks.region(root.NotificationSettingsDialog, "Refresh", function (self) panel(self) end)
    end
end

management.prepare = function ()
    ui.prepare(roots, nil, {}, {}, refresh)
    ui.surface.is_open = function ()
        for _, name in ipairs(roots) do if ui.visible(_G[name]) then return true end end
        local root = _G.CommunitiesFrame
        if root then
            for _, key in ipairs(embedded) do if ui.visible(root[key]) then return true end end
        end
        return false
    end
    for _, method in ipairs({ "GuildControlUI_SetupSelected", "GuildControlUI_RankOrder_Update",
        "GuildControlUI_RankPermissions_Update", "GuildControlUI_BankTabPermissions_Update",
        "GuildControlUI_Discord_Update" }) do ui.hooks.global(method, control) end
    local ticket = _G.CommunitiesTicketManagerDialog
    ui.hooks.region(ticket, "SetExpanded", tickets)
    ui.hooks.region(ticket, "Update", tickets)
    prepare_log()
end
