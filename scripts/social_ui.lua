local _, addon_table = ...

local social_ui = addon_table.use("social_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("social_ui")

-- Support both legacy FriendsFrame and the SocialUIFrame used in build 70235.
-- Watch display regions after native writes; never change account/player data.
local function translate_social_region(region)
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region, nil, "ui.text", registry.get("social"))
end

local function translate_social_location(region)
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region, "zone", "zone.name", registry.get("social"))
end

local function watch_social_region(region, translate)
    if not region then return end
    translate = translate or translate_social_region
    hooks.region(region, "SetText", translate)
    hooks.region(region, "SetFormattedText", translate)
    translate(region)
end

local function watch_social_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then watch_social_region(region) end
end

local function translate_social_card(row)
    if not row then return end
    -- Name/FriendName contain player or Battle.net identity, not UI labels.
    for _, key in ipairs({ "Level", "Class", "MostRecentInteraction",
        "RequestTimestamp", "FriendType", "ButtonText" }) do
        watch_social_region(row[key])
    end
    watch_social_region(row.Location, translate_social_location)
end

local function translate_friend_row(button)
    if not button then return end
    if button.buttonType == _G.FRIENDS_BUTTON_TYPE_WOW and button.name
        and type(button.name.GetText) == "function" then
        -- This is the combined name + level + class display, not a bare name.
        local ok, text = pcall(button.name.GetText, button.name)
        if ok and not runtime.is_secret_value(text) and type(text) == "string"
            and text:find(", Level %d+ ") then
            translate_social_region(button.name)
        end
    end
    translate_social_location(button.info)
end

local function translate_recent_ally(row)
    if not row then return end
    local data = row.CharacterData or row
    for _, key in ipairs({ "Level", "Class", "Location", "MostRecentInteraction" }) do
        local region = data[key]
        local translate = key == "Location" and translate_social_location
            or translate_social_region
        watch_social_region(region, translate)
    end
end

local social_scroll_boxes = setmetatable({}, { __mode = "k" })

local function prepare_social_scroll_box(scroll_box, callback)
    local event = _G.ScrollBoxListMixin and ScrollBoxListMixin.Event
        and ScrollBoxListMixin.Event.OnInitializedFrame
    if not scroll_box or not event
        or type(scroll_box.RegisterCallback) ~= "function" then return end
    if not social_scroll_boxes[scroll_box] then
        scroll_box:RegisterCallback(event,
            function (_, row) callback(row) end, social_scroll_boxes)
        social_scroll_boxes[scroll_box] = true
    end
    if type(scroll_box.ForEachFrame) == "function" then
        scroll_box:ForEachFrame(callback)
    end
end

local function refresh_social() registry.refresh("social") end

local function prepare_modern_social()
    local root = _G.SocialUIFrame
    if not root then return end
    watch_social_region(root.TitleText or _G.SocialUIFrameTitleText)
    for _, key in ipairs({ "FriendsList", "RecentAlliesList", "FriendRequestsList" }) do
        local view = root[key]
        if view then
            prepare_social_scroll_box(view.ScrollBox, translate_social_card)
            hooks.region(view, "Refresh", refresh_social)
            local filter = view.FilterBar
            local dropdown = filter and filter.SearchFilterDropdown
            watch_social_button(dropdown)
            watch_social_region(dropdown and dropdown.Text)
            local search = filter and filter.SearchBar
            watch_social_region(search and search.Instructions)
            watch_social_button(view.ActionButton)
            watch_social_region(view.FriendsDisabledText)
        end
    end
    local raid = root.RaidFrame
    if raid then
        hooks.region(raid, "UpdateContents", refresh_social)
        watch_social_region(raid.RaidDescription)
        watch_social_button(raid.RaidInfoButton)
        watch_social_button(raid.ConvertToRaidButton)
    end
    local broadcast = root.BattleNetBroadcastFrame
    local input = broadcast and broadcast.EditBox
    watch_social_region(input and input.PromptText)
end

local function prepare_social_rows()
    prepare_modern_social()
    local friends = _G.FriendsListFrame
    local recent = _G.RecentAlliesFrame
    for _, pair in ipairs({
        { friends and friends.ScrollBox, translate_friend_row },
        { recent and recent.List and recent.List.ScrollBox, translate_recent_ally },
    }) do
        prepare_social_scroll_box(pair[1], pair[2])
    end
    local bnet = _G.FriendsFrameBattlenetFrame
    local broadcast = bnet and bnet.BroadcastFrame
    hooks.region_script(broadcast, "OnShow", function () registry.refresh("social") end)
    local ignore = _G.FriendsFrame and FriendsFrame.IgnoreListWindow
    hooks.region_script(ignore, "OnShow", function () registry.refresh("social") end)
end

local function skip_social_user_text(region)
    if not region or type(region.GetParent) ~= "function" then return false end
    local ok, parent = pcall(region.GetParent, region)
    if not ok or not parent then return true end
    for _, key in ipairs({ "name", "Name", "FriendName", "CharacterName",
        "InviteeName", "NoteText", "BroadcastText", "Header", "DisplayText" }) do
        if parent[key] == region then return true end
    end
    if type(parent.GetObjectType) == "function" then
        local type_ok, kind = pcall(parent.GetObjectType, parent)
        -- Search instructions are UI; typed searches and broadcasts are user text.
        if type_ok and kind == "EditBox" and parent.Instructions ~= region
            and parent.PromptText ~= region then return true end
    end
    -- Location has its own zone lookup, including colored/pooled text.
    if parent.Location == region then return true end
    return region == _G.FriendsTooltipHeader
        or region == _G.FriendsTooltipNoteText
        or region == _G.FriendsTooltipBroadcastText
end

local function declare_social_hooks()
    local social = registry.get("social")
    if social then
        social.skip_region = skip_social_user_text
        if not social.uaForeverContactsConfigured then
            local generic_static = social.static
            social.static = function (surface)
                prepare_social_rows()
                if generic_static then generic_static(surface) end
            end
            social.uaForeverContactsConfigured = true
        end
    end
    local function refresh() refresh_social() end
    -- Literal declarations are also consumed by the build compatibility audit.
    registry.declare_hook({ id = "social.modern.tab-selected", surface = "social",
        kind = "frame", target = "SocialUIFrame", method = "OnNewTabSelected",
        callback = refresh, blizzardAddon = "Blizzard_SocialUI",
        verifiedBuild = "1.60.1.70235" })
    registry.declare_hook({ id = "social.modern.title", surface = "social",
        kind = "frame", target = "SocialUIFrame", method = "RefreshTitle",
        callback = function ()
            local root = _G.SocialUIFrame
            watch_social_region(root and root.TitleText or _G.SocialUIFrameTitleText)
        end, blizzardAddon = "Blizzard_SocialUI", verifiedBuild = "1.60.1.70235" })
    registry.declare_hook({ id = "social.modern.tabs", surface = "social",
        kind = "frame", target = "SocialUIFrame", method = "RefreshTabs",
        callback = refresh, blizzardAddon = "Blizzard_SocialUI",
        verifiedBuild = "1.60.1.70235" })
    registry.declare_hook({ id = "social.modern.side-window", surface = "social",
        kind = "frame", target = "SocialUIFrame", method = "ShowSideWindow",
        callback = refresh, blizzardAddon = "Blizzard_SocialUI",
        verifiedBuild = "1.60.1.70235" })
    local function declare(target, method, callback, addon, kind)
        registry.declare_hook({
            id = "social:" .. target .. (method and "." .. method or ""),
            surface = "social", kind = kind or (method and "mixin" or "global"),
            target = target, method = method, callback = callback or refresh,
            blizzardAddon = addon or "Blizzard_FriendsFrame",
            verifiedBuild = "1.60.1.70205",
        })
    end
    for _, target in ipairs({ "FriendsFrame_Update", "FriendsList_Update",
        "FriendsFrame_ShowSubFrame", "FriendsFrame_CheckBattlenetStatus",
        "FriendsFrame_UpdateQuickJoinTab", "IgnoreList_Update" }) do
        declare(target)
    end
    declare("FriendsFrame_UpdateFriendButton", nil, translate_friend_row)
    for _, method in ipairs({ "GenerateHeaderTabs", "SelectTab" }) do
        declare("FriendsTabHeader", method, nil, nil, "frame")
    end
    declare("FriendsFrameTooltip_SetLine", nil, function (region)
        if not skip_social_user_text(region) then translate_social_region(region) end
    end)
    declare("AddFriendFrame", "ShowInfo", nil, "Blizzard_AddFriend", "frame")
    declare("AddFriendFrame", "ShowEntry", nil, "Blizzard_AddFriend", "frame")
    declare("BattleNetInviteFrame", "SetTextForFriendLevel", nil,
        "Blizzard_AddFriend", "frame")
    declare("FriendsFriendsFrame", "Update", nil, nil, "frame")
end

social_ui.prepare = function ()
    declare_social_hooks()
end
