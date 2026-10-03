local _, addon_table = ...

local social_ui = addon_table.use("social_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("social_ui")

-- Contacts in 1.60.1.70170 uses pooled rows and separate dialog roots.
-- Hook completed display writes, keeping account/player data pristine.
local function translate_social_region(region)
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region, nil, "ui.text", registry.get("social"))
end

local function translate_social_location(region)
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region, "zone", "zone.name", registry.get("social"))
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
        hooks.region(region, "SetText", translate)
        translate(region)
    end
end

local social_scroll_boxes = setmetatable({}, { __mode = "k" })

local function prepare_social_rows()
    local friends = _G.FriendsListFrame
    local recent = _G.RecentAlliesFrame
    for _, pair in ipairs({
        { friends and friends.ScrollBox, translate_friend_row },
        { recent and recent.List and recent.List.ScrollBox, translate_recent_ally },
    }) do
        local scroll_box, callback = pair[1], pair[2]
        if scroll_box and type(scroll_box.RegisterCallback) == "function"
            and _G.ScrollBoxListMixin then
            if not social_scroll_boxes[scroll_box] then
                scroll_box:RegisterCallback(ScrollBoxListMixin.Event.OnInitializedFrame,
                    function (_, row) callback(row) end, social_scroll_boxes)
                social_scroll_boxes[scroll_box] = true
            end
            if type(scroll_box.ForEachFrame) == "function" then
                scroll_box:ForEachFrame(callback)
            end
        end
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
    for _, key in ipairs({ "name", "Name", "InviteeName", "NoteText",
        "BroadcastText", "Header" }) do
        if parent[key] == region then return true end
    end
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
    local function refresh() registry.refresh("social") end
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
