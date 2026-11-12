local _, addon_table = ...
local menus = addon_table.use("guild_menus_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-ui")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local layout = addon_table.use("translation_layout")
local profiler = addon_table.use("performance_profile")
local text = addon_table.use("guild_ui_text")
local registry = addon_table.use("translation_registry")
local options = addon_table.use("options")

local tags = {
    "MENU_GUILD_PERMISSIONS", "MENU_GUILD_NEWS", "MENU_GUILD_REWARDS",
    "MENU_CLUB_FINDER_APPLICANT", "MENU_CLUB_FOCUS", "MENU_CLUB_LOOKING_FOR",
    "MENU_CLUB_FILTER", "MENU_CLUB_FINDER_OPTIONS", "MENU_CLUB_SORT_BY", "MENU_CLUB_FINDER_CARD",
    "MENU_COMMUNITIES_LANGUAGE", "MENU_COMMUNITIES_GUILD_MEMBER_LIST", "MENU_COMMUNITIES_MEMBER_LIST",
    "MENU_COMMUNITIES_LIST", "MENU_COMMUNITIES_DIALOG_USES", "MENU_COMMUNITIES_DIALOG_EXPIRES",
    "MENU_COMMUNITIES_STREAM", "MENU_COMMUNITIES_ADD_TO_CHAT",
}
local owned = { MENU_GUILD_RANK = true, MENU_GUILD_RANKS = true }
for _, tag in ipairs(tags) do owned[tag] = true end
menus.owns = function (tag) return owned[tag] == true end
menus.preserves_owner = function (owner)
    local frame = _G.GuildControlUIRankDiscordFrame
    return frame and (owner == frame.serverDropdown or owner == frame.channelDropdown) or false
end

local function fit(region)
    if not region or runtime.combat_locked() or not runtime.can_write_text(region) then return end
    local width = layout.safe_dimension(region, "GetUnboundedStringWidth")
        or layout.safe_dimension(region, "GetStringWidth")
    local current = layout.safe_dimension(region, "GetWidth")
    if width and current and not layout.dimensions_match(current, math.ceil(width)) then
        pcall(region.SetWidth, region, math.ceil(width))
    end
end

local function custom_entry(tag, owner, description, source)
    if tag == "MENU_COMMUNITIES_LIST" then return true end
    local data = description:GetData()
    if tag == "MENU_COMMUNITIES_STREAM" then
        local kind = type(data) == "table" and data.streamType
        local types = _G.Enum and Enum.ClubStreamType
        return not types or kind ~= types.Guild and kind ~= types.Officer
    end
    if tag == "MENU_COMMUNITIES_ADD_TO_CHAT" then
        -- Radio data is a chat-window index; those names are user editable.
        return type(data) == "number"
    end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if owner then
        local info = owner.cardInfo or owner.Info or owner.newsInfo
        if type(info) == "table" then
            for _, key in ipairs({ "name", "whatText" }) do
                local value = runtime.safe_string_or_nil(info[key])
                if value and (source == value or plain == value) then return true end
            end
        end
    end
    return false
end

local function prepare_tag(tag)
    ui.hooks.once("guild-menu:" .. tag, function ()
        local function modify(owner, root)
            if options.can_lookup_section and not options.can_lookup_section("social_ui") then return end
            _G.MenuUtil.TraverseMenu(root, function (description)
                local source = runtime.safe_string_or_nil(_G.MenuUtil.GetElementText(description))
                if not source or custom_entry(tag, owner, description, source) then return end
                local function initialize(frame)
                    local region = frame and frame.fontString
                    if not region then return end
                    ui.surface = registry.get("guild-ui")
                    if tag == "MENU_GUILD_REWARDS" and owner and type(owner.itemID) == "number" then
                        local name_claim = runtime.get(owner.Name)
                        local name = name_claim and name_claim.source or ui.text(owner.Name)
                        if source == name then
                            ui.item(region, "item:" .. owner.itemID)
                            local claim = runtime.get(region)
                            if claim and ui.text(region) == claim.translated then fit(region) end
                            return
                        end
                    end
                    local native = ui.text(region)
                    local translated = native and (text.format(native, { "GUILDCONTROL_DISCORD_SETTINGS",
                        "CLUB_FINDER_REAPPLY" }, text.time) or resolver.find_ui(native, region)
                        or text.time(native))
                    if translated and translated ~= native then
                        ui.apply(region, translated, "guild.menu")
                        local claim = runtime.get(region)
                        if claim and ui.text(region) == claim.translated then fit(region) end
                    end
                end
                if profiler.wrap then initialize = profiler.wrap("guild-menu.label", initialize) end
                description:AddInitializer(initialize)
            end)
        end
        if profiler.wrap then modify = profiler.wrap("guild-menu:" .. tag, modify) end
        return pcall(_G.Menu.ModifyMenu, tag, modify)
    end)
end

menus.prepare = function ()
    if not _G.Menu or type(_G.Menu.ModifyMenu) ~= "function" or not _G.MenuUtil
        or type(_G.MenuUtil.TraverseMenu) ~= "function"
        or type(_G.MenuUtil.GetElementText) ~= "function" then return end
    for _, tag in ipairs(tags) do prepare_tag(tag) end
end
