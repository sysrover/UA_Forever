local _, addon_table = ...
local finder = addon_table.use("guild_finder_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-finder")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local text = addon_table.use("guild_ui_text")
local guild = addon_table.use("guild_ui")
ui.verified_build = "1.60.1.70888"

local formats = { "CLUB_FINDER_FOCUS_STRING", "CLUB_FINDER_REAPPLY",
    "CLUB_FINDER_RECRUITING_ONE_SPEC", "CLUB_FINDER_RECRUITING_TWO_SPECS",
    "CLUB_FINDER_RECRUITING_THREE_SPECS", "CLUB_FINDER_RECRUITING_FOUR_SPECS" }
local function skip(region)
    local parent = region:GetParent()
    if not parent then return true end
    if parent:GetObjectType() == "EditBox" then
        return parent.Instructions ~= region and parent.PromptText ~= region
    end
    local container = parent:GetParent()
    if container and container.columnHeaders then return true end
    for _, key in ipairs({ "Name", "Note", "ClubName", "ClubDescription", "RealmName" }) do
        if parent[key] == region then return true end
    end
    return parent.Description == region and parent.cardInfo ~= nil
end

local function label(region)
    if not ui.visible(region) or runtime.is_applying(region) or skip(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = text.format(source, formats, function (value)
        return resolver.find_ui(value) or text.time(value)
    end)
    if translated then ui.apply(region, translated) else ui.label(region) end
end

local function panel(frame, seen)
    if not frame then return end
    ui.watch_frame(frame, skip, label, seen)
    ui.hooks.region_script(frame, "OnShow", function (self) panel(self) end)
end

local function card(row)
    if not row then return end
    panel(row)
    ui.hooks.region(row, "UpdateCard", card)
    ui.hooks.region(row, "Init", card)
end

local function applicant(row)
    if not row then return end
    -- Keep the column geometry shared with the native sorting header.
    for _, key in ipairs({ "AllSpec", "RequestStatus" }) do ui.watch(row[key], label) end
    ui.hooks.region(row, "UpdateMemberInfo", applicant)
    ui.hooks.region_script(row, "OnShow", applicant)
end

local function cards(frame)
    if not frame then return end
    local seen = {}
    if type(frame.Cards) == "table" then
        for _, row in ipairs(frame.Cards) do card(row); seen[row] = true end
    end
    ui.watch_scroll(frame.ScrollBox, card)
    panel(frame, seen)
    ui.hooks.region(frame, "RefreshLayout", cards)
    ui.hooks.region_script(frame, "OnShow", cards, "cards")
end

local function search(frame)
    if not frame then return end
    local seen = {}
    for _, key in ipairs({ "GuildCards", "CommunityCards", "PendingGuildCards", "PendingCommunityCards" }) do
        cards(frame[key])
        if frame[key] then seen[frame[key]] = true end
    end
    for _, key in ipairs({ "OptionsList", "RequestToJoinFrame", "InsetFrame", "DisabledFrame" }) do
        panel(frame[key], seen)
    end
    ui.hooks.region(frame.RequestToJoinFrame, "Initialize", function (self) panel(self) end)
    panel(frame, seen)
    ui.hooks.region(frame, "UpdateDisplay", search)
end

local function refresh()
    if ui.surface then ui.surface.skip_region = skip end
    search(_G.ClubFinderGuildFinderFrame)
    search(_G.ClubFinderCommunityAndGuildFinderFrame)
    local root = _G.CommunitiesFrame
    if not root then return end
    local list = root.ApplicantList
    if list then
        ui.watch_scroll(list.ScrollBox, applicant)
        guild.columns(list.ColumnDisplay)
        ui.hooks.region(list.ColumnDisplay, "LayoutColumns", guild.columns)
        ui.hooks.region_script(list.ColumnDisplay, "OnShow", guild.columns)
        -- Do not scan pooled applicant text through the static path.
        local seen = {}
        if list.ScrollBox then seen[list.ScrollBox] = true end
        if list.ColumnDisplay then seen[list.ColumnDisplay] = true end
        panel(list, seen)
    end
    panel(root.RecruitmentDialog)
    ui.hooks.region(root.RecruitmentDialog, "UpdateSettingsInfoFromClubInfo", function (self) panel(self) end)
    ui.hooks.region(root.RecruitmentDialog, "OnUpdatedPostingInformationRecieved", function (self) panel(self) end)
    panel(root.PostingExpirationText)
    ui.hooks.region(root, "SetDisplayMode", refresh)
end

finder.prepare = function ()
    ui.prepare({ "ClubFinderGuildFinderFrame", "ClubFinderCommunityAndGuildFinderFrame" },
        "Blizzard_Communities", {}, {}, refresh)
    ui.surface.is_open = function ()
        local root = _G.CommunitiesFrame
        return ui.visible(_G.ClubFinderGuildFinderFrame) or ui.visible(_G.ClubFinderCommunityAndGuildFinderFrame)
            or root and (ui.visible(root.ApplicantList) or ui.visible(root.RecruitmentDialog)) or false
    end
end
