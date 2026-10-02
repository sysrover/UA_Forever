local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").menus
local auto_scan = addon_table.use("auto_scan")
local entries = addon_table.use("entries")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")
local walker = addon_table.use("translation_walker")
local hooks = addon_table.use("translation_hooks").bind("menus")

local menu_walks = {
    popup = { id = "rendered-static-popup", surface = "popup",
        owner = "menus", reason = "ANONYMOUS_POPUP_LAYOUT" },
    modern = { id = "modern-open-menu", surface = "menus",
        owner = "menus", reason = "POOLED_MENU_DISCOVERY" },
    legacy = { id = "legacy-dropdown", surface = "menus",
        owner = "menus", reason = "POOLED_MENU_DISCOVERY" },
}

local function capture_auto_frame(frame)
    if frame and type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled()
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(frame)
    end
end

local function translate_and_capture_frame(frame)
    if not frame then return end
    if type(strings.translate_frame) == "function" then
        strings.translate_frame(frame, nil, menu_walks.popup)
    end
    capture_auto_frame(frame)
end

local function translate_game_menu(frame)
    if not frame then return end
    local surface = registry.get("game-menu")
    if not surface then return end
    local instance = "game-menu:" .. tostring(frame)
    runtime.begin_generation(surface, instance)

    -- GameMenuFrame is protected in Camelot, so the generic recursive walker
    -- intentionally refuses it. Its public display surface is small and
    -- stable: one header FontString and the FontString of each pooled button.
    -- Touch only those completed display regions and leave button data,
    -- callbacks, ordering, and secure descendants unchanged.
    local header = frame.Header
    strings.translate_region(header and header.Text, nil, "ui.title",
        surface, "dynamic", instance)
    if header and type(header.UpdateWidth) == "function" then
        pcall(header.UpdateWidth, header)
    end

    if type(frame.buttons) == "table" then
        local widest_button = 0
        for _, button in ipairs(frame.buttons) do
            if button and type(button.GetFontString) == "function" then
                local ok, font_string = pcall(button.GetFontString, button)
                if ok then
                    strings.translate_region(font_string, nil, "ui.action",
                        surface, "dynamic", instance)
                    strings.fit_button_to_text(button, font_string)
                    local width_ok, width = pcall(button.GetWidth, button)
                    if width_ok and type(width) == "number" then
                        widest_button = math.max(widest_button, width)
                    end
                end
            end
        end
        if widest_button > 0 then
            for _, button in ipairs(frame.buttons) do
                if button and type(button.SetWidth) == "function" then
                    pcall(button.SetWidth, button, widest_button)
                end
            end
            if type(frame.MarkDirty) == "function" then pcall(frame.MarkDirty, frame) end
        end
    end
end

local original_mail_widths = setmetatable({}, { __mode = "k" })

local function widen_mail_region(region, extra_width)
    if not region or type(region.GetWidth) ~= "function"
        or type(region.SetWidth) ~= "function" then return end
    local width = original_mail_widths[region]
    if not width then
        local ok, measured = pcall(region.GetWidth, region)
        if not ok or type(measured) ~= "number" or measured <= 0 then return end
        width = measured
        original_mail_widths[region] = width
    end
    pcall(region.SetWidth, region, width + extra_width)
end

local function widen_mail_frame()
    local mail = _G.MailFrame
    if not mail or type(mail.GetWidth) ~= "function"
        or type(mail.SetWidth) ~= "function" then return end
    if not original_mail_widths[mail] then
        local ok, width = pcall(mail.GetWidth, mail)
        if not ok or type(width) ~= "number" or width <= 0 then return end
        original_mail_widths[mail] = width
    end
    local original_width = original_mail_widths[mail]
    local extra_width = math.floor(original_width * 1.1 + 0.5) - original_width
    widen_mail_region(mail, extra_width)
    for _, name in ipairs({
        "SendMailScrollFrame", "SendMailScrollChildFrame",
        "SendMailBodyEditBox", "SendStationeryBackgroundLeft",
        "SendMailSubjectEditBox", "SendMailHorizontalBarLeft",
        "SendMailHorizontalBarLeft2", "InboxFrameBg",
    }) do
        widen_mail_region(_G[name], extra_width)
    end
    for index = 1, 7 do
        local row = _G["MailItem" .. index]
        widen_mail_region(row, extra_width)
        if row and type(row.GetRegions) == "function" then
            local ok, _, background, divider = pcall(row.GetRegions, row)
            if ok then
                widen_mail_region(background, extra_width)
                widen_mail_region(divider, extra_width)
            end
        end
        widen_mail_region(_G["MailItem" .. index .. "Subject"], extra_width)
    end
end

local function translate_mail_region(region)
    if not region or runtime.is_applying(region) then return end
    hooks.region(region, "SetText", translate_mail_region)
    if type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string"
        or source == "" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated, _, tier, category, _, option, provenance =
        resolver.find_ui(source, region)
    if not translated then
        -- Already-localized globals still need the shared font policy.
        strings.translate_region(region)
        return
    end
    runtime.apply(region, {
        owner = "menus", slot = "mail.ui:" .. source,
        source = source, translated = translated, category = category,
        option = option or "translate_string",
        priority = runtime.priority_for_source(tier),
        lookup_tier = tier, catalog_source = provenance and provenance.source,
        surface = registry.get("mail"), phase = "direct",
        reapply_cached = true,
    })
end

local function translate_mail_tab(tab)
    local label = tab and tab.Text
    translate_mail_region(label)
    if not label or type(label.GetUnboundedStringWidth) ~= "function"
        or type(label.SetWidth) ~= "function" then return end
    local ok, width = pcall(label.GetUnboundedStringWidth, label)
    if not ok or runtime.is_secret_value(width)
        or type(width) ~= "number" or width <= 0 then return end
    label:SetWidth(math.ceil(width + 4))
end

local function translate_mail_labels(owner, outside_input)
    if not owner or type(owner.GetRegions) ~= "function" then return end
    local ok, regions = pcall(function () return { owner:GetRegions() } end)
    if not ok then return end
    for _, region in ipairs(regions) do
        local type_ok, kind = pcall(region.GetObjectType, region)
        if type_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
            local is_label = not outside_input
            if outside_input and type(region.GetPoint) == "function" then
                -- The 70124 To/Subject labels are outside their EditBox:
                -- RIGHT -> LEFT. Never translate its editable text region.
                local point_ok, point, _, relative_point = pcall(region.GetPoint, region, 1)
                is_label = point_ok and not runtime.is_secret_value(point)
                    and not runtime.is_secret_value(relative_point)
                    and point == "RIGHT" and relative_point == "LEFT"
            end
            if is_label then translate_mail_region(region) end
        end
    end
end

local function update_inbox_controls()
    widen_mail_frame()
    for _, name in ipairs({
        "OpenAllMailText", "MailFrameTitleText", "SendMailMoneyText",
        "MailFrameTrialError", "InboxTooMuchMailText",
        "SendMailSendMoneyButtonText", "SendMailCODButtonText",
        "SendMailCancelButtonText", "SendMailMailButtonText",
    }) do
        translate_mail_region(_G[name])
    end
    for index = 1, 7 do
        translate_mail_region(_G["MailItem" .. index .. "ButtonCOD"])
    end
    for _, denomination in ipairs({ "Gold", "Silver", "Copper" }) do
        local money = _G["SendMailMoney" .. denomination]
        translate_mail_region(money and money.label)
    end
    local inbox = _G.InboxFrame
    translate_mail_labels(inbox and inbox.PrevPageButton)
    translate_mail_labels(inbox and inbox.NextPageButton)
    translate_mail_labels(_G.SendMailNameEditBox, true)
    translate_mail_labels(_G.SendMailSubjectEditBox, true)
    translate_mail_labels(_G.SendMailCostMoneyFrame)
    for index = 1, 2 do
        local tab = _G["MailFrameTab" .. index]
        hooks.region(tab and tab.Text, "SetText", function ()
            translate_mail_tab(tab)
        end)
        translate_mail_tab(tab)
    end
end

local function declare_inbox_hook()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "mail.inbox.update",
        surface = "mail",
        kind = "mixin",
        target = "InboxMixin",
        method = "Update",
        blizzardAddon = "Blizzard_MailFrame",
        required = true,
        fallbackEvent = "MAIL_INBOX_UPDATE",
        verifiedBuild = 70124,
        callback = update_inbox_controls,
    })
end

local function declare_game_menu_hook()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "game-menu.buttons.init",
        surface = "game-menu",
        kind = "frame",
        target = "GameMenuFrame",
        method = "InitButtons",
        required = true,
        fallbackEvent = "GameMenuFrame.OnShow",
        verifiedBuild = 70058,
        callback = translate_game_menu,
    })
end

local function translate_auction_category_button(button)
    local region = button and button.Text
    if not region then return end
    strings.translate_region(region, nil, "ui.text", registry.get("misc"))
end

local function translate_auction_summary_line(line, list_index)
    if list_index ~= 1 then return end
    local region = line and line.Text
    if region then
        strings.translate_region(region, nil, "ui.text", registry.get("misc"))
    end
end

local function translate_auction_table_header(header)
    local region = header and header.Text
    if region then
        strings.translate_region(region, nil, "ui.text", registry.get("misc"))
    end
end

local function declare_auction_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "auction-house.categories.setup",
        surface = "misc",
        kind = "global",
        target = "AuctionHouseFilterButton_SetUp",
        blizzardAddon = "Blizzard_AuctionHouseUI",
        required = true,
        fallbackEvent = "AuctionHouseFrame.OnShow",
        verifiedBuild = 70058,
        callback = translate_auction_category_button,
    })
    registry.declare_hook({
        id = "auction-house.summary-line.init",
        surface = "misc",
        kind = "mixin",
        target = "AuctionHouseAuctionsSummaryLineMixin",
        method = "Init",
        blizzardAddon = "Blizzard_AuctionHouseUI",
        required = true,
        fallbackEvent = "AuctionHouseFrame.AuctionsFrame.SetTab",
        verifiedBuild = 70058,
        callback = translate_auction_summary_line,
    })
    registry.declare_hook({
        id = "auction-house.table-header.init",
        surface = "misc",
        kind = "mixin",
        target = "AuctionHouseTableHeaderStringMixin",
        method = "Init",
        blizzardAddon = "Blizzard_AuctionHouseUI",
        required = true,
        fallbackEvent = "AuctionHouseFrame.AuctionsFrame.SetTab",
        verifiedBuild = 70058,
        callback = translate_auction_table_header,
    })
end

local function translate_auction_filter_dropdown(button)
    local region = button and button.Text
    if region and not runtime.is_applying(region) then
        strings.translate_region(region, nil, "ui.text", registry.get("misc"))
    end
end

local function translate_auction_duration_dropdown(dropdown)
    local region = dropdown and dropdown.Text
    if region and not runtime.is_applying(region) then
        strings.translate_region(region, nil, "ui.text", registry.get("misc"))
    end
end

local function prepare_auction_duration_dropdowns(auction_house)
    for _, key in ipairs({ "ItemSellFrame", "CommoditiesSellFrame" }) do
        local sell_frame = auction_house and auction_house[key]
        local dropdown = sell_frame and sell_frame.Duration
            and sell_frame.Duration.Dropdown
        hooks.region(dropdown, "UpdateText",
            translate_auction_duration_dropdown)
        translate_auction_duration_dropdown(dropdown)
    end
end

local function translate_auction_action_button(button, surface)
    if not button then return end
    local region = button.Text
    if not region and type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok then region = font_string end
    end
    if region then
        strings.translate_region(region, nil, "ui.action", surface)
    end
end

local function schedule_auction_item_buy_frame(frame)
    if not frame then return end
    scheduler.request("auction-house-item-buy-frame", nil, function ()
        local surface = registry.get("misc")
        translate_auction_action_button(frame.BackButton, surface)
        translate_auction_action_button(frame.BidFrame
            and frame.BidFrame.BidButton, surface)
        translate_auction_action_button(frame.BuyoutFrame
            and frame.BuyoutFrame.BuyoutButton, surface)
    end)
end

local function schedule_auction_auctions_frame(frame)
    if not frame then return end
    scheduler.request("auction-house-auctions-frame", nil, function ()
        local surface = registry.get("misc")
        if surface then strings.translate_frame(frame, surface) end
    end)
end

local function translate_micro_button_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip.GetOwner or tooltip:GetOwner() ~= button then return end
    if tooltips.finalize then tooltips.finalize(tooltip) end
end

local function is_edit_mode_layout_menu(menu)
    if not menu then return false end
    local manager = _G.EditModeManagerFrame
    local dropdown = manager and manager.LayoutDropdown
    if dropdown and type(menu.GetOwnerRegion) == "function" then
        local ok, owner = pcall(menu.GetOwnerRegion, menu)
        if ok and owner == dropdown then return true end
    end
    if type(menu.ToDebugString) == "function" then
        local ok, tag = pcall(menu.ToDebugString, menu)
        if ok and tag == "MENU_EDIT_MODE_MANAGER" then return true end
    end
    return false
end

local function edit_mode_user_layout_names()
    local names = {}
    local manager = _G.EditModeManagerFrame
    local layout_info = manager and manager.layoutInfo
    local layouts = layout_info and layout_info.layouts
    local types = _G.Enum and _G.Enum.EditModeLayoutType
    if type(layouts) ~= "table" or type(types) ~= "table" then return names end
    for _, info in ipairs(layouts) do
        local layout_type = info and info.layoutType
        if layout_type == types.Account or layout_type == types.Character then
            local name = info.layoutName
            if type(name) == "string" and name ~= "" then names[name] = true end
        end
    end
    return names
end

local function translate_open_menu()
    local function translate()
        local manager = _G.Menu and type(_G.Menu.GetManager) == "function"
            and _G.Menu.GetManager() or nil
        local menu = manager and type(manager.GetOpenMenu) == "function"
            and manager:GetOpenMenu() or nil
        if menu then
            if is_edit_mode_layout_menu(menu) then
                local user_layout_names = edit_mode_user_layout_names()
                local walk = {
                    id = menu_walks.modern.id,
                    surface = menu_walks.modern.surface,
                    owner = menu_walks.modern.owner,
                    reason = menu_walks.modern.reason,
                    skip_region = function (region)
                        if not region or type(region.GetText) ~= "function" then
                            return false
                        end
                        local ok, value = pcall(region.GetText, region)
                        return ok and type(value) == "string"
                            and user_layout_names[value] == true
                    end,
                }
                strings.translate_frame(menu, nil, walk)
                -- Account/character layout names are user data, so rendered
                -- rows from this menu do not belong in the UI text report.
            else
                strings.translate_frame(menu, nil, menu_walks.modern)
                capture_auto_frame(menu)
            end
        end
    end

    scheduler.request("open-menu", nil, translate)
end

local function translate_legacy_dropdown(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    local function translate()
        local frame = _G["DropDownList" .. level]
        if not frame then return end
        strings.translate_frame(frame, nil, menu_walks.legacy)
        capture_auto_frame(frame)
        local owner = _G.UIDROPDOWNMENU_OPEN_MENU
        local name_ok, name = owner and pcall(owner.GetDebugName, owner)
        if name_ok and type(name) == "string"
            and name:find("LFGWhoListFrame.FilterDropdown", 1, true) then
            walker.walk({ id = "legacy-dropdown-lfg-filter",
                surface = "group-finder", owner = "menus",
                reason = "POOLED_MENU_DISCOVERY" }, frame, function (region)
                strings.translate_region(region)
            end, nil, { frames = 0 })
        end
    end

    scheduler.request("legacy-dropdown:" .. level, nil, translate)
end

local function translate_lfg_frame(frame)
    local root = _G.LFGListFrame
    local entry = root and root.EntryCreation or frame
    if not entry then return end
    local surface = registry.get("lfg")
    if surface and runtime.generation(surface) == 0 then
        runtime.begin_generation(surface, "entry-creation")
    end
    local function translate_static(region)
        if region then strings.translate_region(region, nil, nil, surface, "static") end
    end
    translate_static(entry.Label)
    translate_static(entry.Name and entry.Name.Instructions)
    translate_static(entry.ItemLevel and entry.ItemLevel.EditBox
        and entry.ItemLevel.EditBox.Instructions)
    translate_static(entry.CrossFactionGroup and entry.CrossFactionGroup.Label)
    local button = entry.ListGroupButton
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate_static(region) end
    end
    -- Edit mode replaces this placeholder with a quest-specific description.
    -- Keep it dynamic so the quest owner can claim the reused region.
    strings.translate_region(entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions, nil, nil, surface, "dynamic",
        "entry-description")
end

local function translate_lfg_activity_button(button)
    if not button then return end
    if type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok and font_string and font_string.GetText then
            local text_ok, source = pcall(font_string.GetText, font_string)
            if text_ok and type(source) == "string" then
                runtime.invalidate(font_string)
                local translated, _, kind, _, _, option =
                    resolver.find_ui(source, font_string)
                if translated then
                    local id_ok, activity_id = pcall(function ()
                        return button.activityID or (button.info and button.info.activityID)
                    end)
                    local secret = false
                    if type(_G.issecretvalue) == "function" then
                        local secret_ok, value = pcall(_G.issecretvalue, activity_id)
                        secret = not secret_ok or value
                    end
                    local slot = id_ok and not secret and type(activity_id) == "number"
                        and "activity:" .. activity_id or "activity.name"
                    local instance = id_ok and not secret and activity_id or source
                    local generation = runtime.begin_generation(font_string, instance)
                    runtime.apply(font_string, { owner = "lfg", slot = slot,
                        source = source, translated = translated,
                        option = option,
                        surface = font_string, generation = generation,
                        instance = instance, phase = "dynamic",
                        priority = kind == "domain" and runtime.PRIORITY.DOMAIN
                            or runtime.PRIORITY.CONTEXT })
                end
            end
        end
    end
end

-- Vanilla-style Group Finder in 1.60.1.70170 has separate roots and native
-- writers. Bind completed display regions, including hidden controls; never
-- walk player names, guilds, comments or the contents of editable fields.
local function lfg_name(source)
    local translated = entries.get_glossary_text(source, source, "zone")
    if translated ~= source then return translated end
    return resolver.find_ui(source) or source
end

local function translate_lfg_display(region, category)
    if not region or runtime.is_applying(region)
        or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string"
        or source == "" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = surface_text.lfg_text(source, lfg_name)
    if category == "npc" then
        translated = entries.lookup_name("npc", source) or translated
    end
    if translated and translated ~= source then
        runtime.apply(region, {
            owner = "lfg", slot = category == "zone" and "activity.name" or "ui.text",
            source = source, translated = translated,
            option = category == "zone" and "translate_zone"
                or category == "npc" and "translate_npc" or "translate_string",
            category = category,
            priority = category == "npc" and runtime.PRIORITY.DOMAIN
                or runtime.PRIORITY.CONTEXT, reapply_cached = true,
        })
    else
        strings.translate_region(region, category, nil, registry.get("lfg"))
    end
end

local function bind_lfg_display(region, category)
    if not region then return end
    hooks.region(region, "SetText", function (self)
        translate_lfg_display(self, category)
    end)
    translate_lfg_display(region, category)
end

local function bind_lfg_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, label = pcall(button.GetFontString, button)
    if ok then bind_lfg_display(label) end
end

local function translate_lfg_vanilla_listing()
    local frame = _G.LFGListingFrame
    if not frame then return end
    bind_lfg_display(frame.TitleContainer and frame.TitleContainer.TitleText)
    bind_lfg_button(frame.BackButton)
    bind_lfg_button(frame.PostButton)
    local roles = frame.GroupRoleButtons
    bind_lfg_button(roles and roles.RolePollButton)
    bind_lfg_display(roles and roles.RoleDropdown and roles.RoleDropdown.Text)
    local view = frame.ActivityView
    bind_lfg_display(view and view.LevelRangesCheckbox and view.LevelRangesCheckbox.Text)
    bind_lfg_display(view and view.PlayStyleDropdown and view.PlayStyleDropdown.Text)
    bind_lfg_display(view and view.Comment and view.Comment.EditBox
        and view.Comment.EditBox.Instructions)
    local locked = frame.LockedView
    bind_lfg_display(locked and locked.ErrorText)
    bind_lfg_display(locked and locked.ActivityText)
end

local function translate_lfg_vanilla_categories(view)
    view = view or _G.LFGListingFrameCategoryView
    if not view or type(view.CategoryButtons) ~= "table" then return end
    for _, button in ipairs(view.CategoryButtons) do bind_lfg_button(button) end
end

local function translate_lfg_vanilla_activity(row)
    if not row then return end
    bind_lfg_display(row.NameButton and row.NameButton.Name, "zone")
    bind_lfg_display(row.Level)
end

local function translate_lfg_vanilla_result(row)
    if not row then return end
    bind_lfg_display(row.CategoryLabel)
    bind_lfg_display(row.ActivityName, "zone")
    bind_lfg_display(row.Level)
    bind_lfg_display(row.PlaystyleLabel)
    local data = row.DataDisplay
    bind_lfg_display(data and data.RolesText)
end

local function translate_lfg_vanilla_who_row(row)
    if not row then return end
    bind_lfg_display(row.Level)
    bind_lfg_display(row.Race)
    bind_lfg_display(row.Class)
    if row.Variable then runtime.invalidate(row.Variable) end
    -- Variable is selected by whoSortValue: area, guild or race.
    if _G.whoSortValue == 1 then translate_lfg_display(row.Variable, "zone") end
    if _G.whoSortValue == 3 then translate_lfg_display(row.Variable) end
end

local function translate_lfg_vanilla_tooltip(frame)
    if not frame then return end
    for _, key in ipairs({ "Delisted", "NewPlayerFriendlyText",
        "CompletedEncounterHeader", "MemberCount" }) do
        bind_lfg_display(frame[key])
    end
    bind_lfg_display(frame.Leader and frame.Leader.Level)
    if frame.memberPool and type(frame.memberPool.EnumerateActive) == "function" then
        for member in frame.memberPool:EnumerateActive() do bind_lfg_display(member.Level) end
    end
    if frame.activityPool and type(frame.activityPool.EnumerateActive) == "function" then
        for label in frame.activityPool:EnumerateActive() do bind_lfg_display(label, "zone") end
    end
    if frame.completedEncounterPool
        and type(frame.completedEncounterPool.EnumerateActive) == "function" then
        for label in frame.completedEncounterPool:EnumerateActive() do
            bind_lfg_display(label, "npc")
        end
    end
end

local lfg_scroll_boxes = setmetatable({}, { __mode = "k" })

local function translate_lfg_vanilla()
    local parent = _G.LFGParentFrame
    if parent then
        for index = 1, 3 do
            local tab = parent["Tab" .. index]
            bind_lfg_button(tab)
            if tab and type(_G.PanelTemplates_TabResize) == "function" then
                pcall(_G.PanelTemplates_TabResize, tab, 0)
            end
        end
    end
    translate_lfg_vanilla_listing()
    translate_lfg_vanilla_categories()
    local browse = _G.LFGBrowseFrame
    if browse then
        bind_lfg_display(browse.TitleContainer and browse.TitleContainer.TitleText)
        bind_lfg_display(browse.CategoryDropdown and browse.CategoryDropdown.Text)
        bind_lfg_display(browse.ActivityDropdown and browse.ActivityDropdown.Text, "zone")
        bind_lfg_display(browse.NoResultsFound)
        bind_lfg_display(browse.SearchingSpinner and browse.SearchingSpinner.Label)
        bind_lfg_button(browse.SendMessageButton)
        bind_lfg_button(browse.GroupInviteButton)
    end
    local who = _G.LFGWhoListFrame
    if who then
        bind_lfg_display(who.TitleContainer and who.TitleContainer.TitleText)
        bind_lfg_display(who.EditBox and who.EditBox.Instructions)
        bind_lfg_display(who.FilterDropdown and who.FilterDropdown.Text)
        bind_lfg_display(who.WhoFrameTotals)
    end
end

local function translate_lfg_quest_description(entry)
    local region = entry and entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions
    local info_getter = _G.C_LFGList and _G.C_LFGList.GetActiveEntryInfo
    if not region or type(info_getter) ~= "function" then return end
    local info_ok, info = pcall(info_getter)
    local id = info_ok and info and info.questID
    if type(id) ~= "number" then return end
    local title_getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(title_getter) ~= "function" then return end
    local title_ok, english = pcall(title_getter, id)
    local quest = entries.get_entry("quest", id)
    local ukrainian = quest and quest[1]
    if not title_ok or type(english) ~= "string" or english == ""
        or type(ukrainian) ~= "string" or ukrainian == "" then return end
    local world_ok, is_world = pcall(_G.QuestUtils_IsQuestWorldQuest or function () return false end, id)
    if not world_ok then return end
    local format = is_world and _G.AUTO_GROUP_CREATION_WORLD_QUEST
        or _G.AUTO_GROUP_CREATION_NORMAL_QUEST
    if type(format) ~= "string" then return end
    local translated_format = resolver.find_ui(format)
    if type(translated_format) ~= "string" then return end
    local source_ok, source = pcall(string.format, format, english)
    ukrainian = utils.cap(ukrainian)
    local native_uk_ok, native_uk = pcall(string.format, format, ukrainian)
    local ua_ok, translated = pcall(string.format, translated_format, ukrainian)
    local mixed_ok, name_original = pcall(string.format, translated_format, english)
    if not source_ok or not native_uk_ok or not ua_ok or not mixed_ok then return end
    local text_ok, current = pcall(region.GetText, region)
    if not text_ok or (current ~= source and current ~= native_uk) then return end
    runtime.invalidate(region)
    runtime.apply(region, {
        owner = "lfg-quest", slot = "quest:" .. id .. ".description",
        source = source, translated = translated, name_original = name_original,
        category = "quest", option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function translate_lfg_edit_mode(entry, edit_mode)
    if edit_mode then translate_lfg_quest_description(entry) end
    translate_lfg_frame(entry)
end

local function popup_text_region(dialog)
    if not dialog then return nil end
    if type(dialog.GetTextFontString) == "function" then
        local ok, region = pcall(dialog.GetTextFontString, dialog)
        if ok and region then return region end
    end
    local name
    if type(dialog.GetName) == "function" then
        local ok, value = pcall(dialog.GetName, dialog)
        if ok and type(value) == "string" then name = value end
    end
    return dialog.text or dialog.Text or name and _G[name .. "Text"]
end

local function resize_popup_for_text(dialog, text)
    if not dialog or type(text) ~= "string" or type(dialog.Resize) ~= "function"
        or dialog.uaForeverLayoutText == text then return end
    dialog.uaForeverLayoutText = text
    pcall(dialog.Resize, dialog)
end

local function translate_quit_countdown(dialog)
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    local count = ok and type(source) == "string"
        and source:match("^(%d+) Seconds until exit$")
    if not count then return end
    local applied = runtime.apply(region, {
        owner = "popup", slot = "quit.countdown", source = source,
        translated = surface_text.quit_countdown(count),
        priority = runtime.PRIORITY.CONTEXT,
    })
    if applied then resize_popup_for_text(dialog, surface_text.quit_countdown(count)) end
end

local function translate_popup_button(dialog, getter)
    if not dialog then return end
    local button
    if type(dialog[getter]) == "function" then
        local ok, value = pcall(dialog[getter], dialog)
        if ok then button = value end
    end
    if not button then
        local number = getter:match("(%d+)$")
        local name
        if type(dialog.GetName) == "function" then
            local ok, value = pcall(dialog.GetName, dialog)
            if ok and type(value) == "string" then name = value end
        end
        button = dialog["button" .. number]
            or name and _G[name .. "Button" .. number]
    end
    if not button or type(button.GetFontString) ~= "function" then return end
    local text_ok, region = pcall(button.GetFontString, button)
    if text_ok then strings.translate_region(region) end
end

local function translate_home_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    local text_ok, source
    if region then text_ok, source = pcall(region.GetText, region) end
    if not text_ok or type(source) ~= "string"
        or source:gsub("%s+", " "):match("^%s*(.-)%s*$") ~=
            "Do you want to make Thunderbrew Distillery your new home?" then
        return false
    end
    if strings.translate_region(region) and type(dialog.Resize) == "function" then
        pcall(dialog.Resize, dialog)
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function translate_resurrection_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return false end
    local text_ok, source = pcall(region.GetText, region)
    if not text_ok or type(source) ~= "string" then return false end
    local normalized = source:gsub("%s+", " ")
    local name, seconds = normalized:match(
        "^(.-) wants to resurrect you and will be able to in (%d+) seconds?$")
    local sickness
    if not name then
        name, seconds = normalized:match(
            "^(.-) wants to resurrect you and will be able to in (%d+) seconds?%. You will be afflicted with resurrection sickness%.$")
        sickness = name ~= nil
    end
    if not name then
        name = normalized:match("^(.-) wants to resurrect you$")
        if not name then
            name = normalized:match(
                "^(.-) wants to resurrect you%. You will be afflicted with resurrection sickness%.$")
            sickness = name ~= nil
        end
    end
    if not name then return false end
    local translated = surface_text.resurrection(name, seconds, sickness)
    local applied = runtime.apply(region, {
        owner = "popup", slot = "resurrection.message", source = source,
        translated = translated, priority = runtime.PRIORITY.CONTEXT,
    })
    if applied then resize_popup_for_text(dialog, translated) end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and (translate_home_popup(dialog)
            or translate_resurrection_popup(dialog)) then return end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        if translate_home_popup(dialog) or translate_resurrection_popup(dialog) then
            return
        end
    end
end

local function refresh_and_scan_popups(which, data)
    refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and dialog then
            translate_and_capture_frame(dialog)
            return
        end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        local shown_ok, shown = dialog and pcall(dialog.IsShown, dialog)
        if shown_ok and shown then
            translate_and_capture_frame(dialog)
        end
    end
end

local function after_static_popup_show(which, _, _, data)
    -- The bind-point text and buttons can be assigned after StaticPopup_Show
    -- returns, so inspect the rendered popup on the next frame as well.
    scheduler.request("home-popup:immediate", nil, function()
        refresh_and_scan_popups(which, data)
    end)
    scheduler.request("home-popup:retry", nil, function()
        refresh_and_scan_popups(which, data)
    end, 0.1)
    local find = _G.StaticPopup_FindVisible
    if type(find) ~= "function" then return end
    local ok, dialog = pcall(find, which, data)
    if not ok or not dialog then return end
    -- StaticPopup frames are pooled. A new show may reset native dimensions
    -- even when its translated countdown/message equals the previous show.
    dialog.uaForeverLayoutText = nil
    local region = popup_text_region(dialog)
    if which ~= "GENERIC_CONFIRMATION" and which ~= "QUIT"
        and not translate_home_popup(dialog)
        and not translate_resurrection_popup(dialog) then return end
    if which == "QUIT" then
        translate_quit_countdown(dialog)
    elseif data and data.text == _G.SELL_ALL_JUNK_ITEMS_POPUP then
        if strings.translate_region(region) and type(dialog.Resize) == "function" then
            pcall(dialog.Resize, dialog)
        end
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
end

local function after_static_popup_update(dialog)
    if not dialog then return end
    local which = dialog.which
    if which == "QUIT" then
        translate_quit_countdown(dialog)
    elseif which == "RESURRECT" or which == "RESURRECT_NO_SICKNESS" then
        translate_resurrection_popup(dialog)
    end
end

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
            verifiedBuild = "1.60.1.70170",
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

menus_ui.prepare = function ()
    declare_social_hooks()
    declare_inbox_hook()
    declare_game_menu_hook()
    declare_auction_hooks()
    local auction_house = _G.AuctionHouseFrame
    local auction_filter = auction_house and auction_house.SearchBar
        and auction_house.SearchBar.FilterButton
    hooks.region(auction_filter, "UpdateText",
        translate_auction_filter_dropdown)
    translate_auction_filter_dropdown(auction_filter)
    prepare_auction_duration_dropdowns(auction_house)
    local item_buy_frame = auction_house and auction_house.ItemBuyFrame
    hooks.region_script(item_buy_frame, "OnShow",
        schedule_auction_item_buy_frame, "auction-item-buy-actions")
    schedule_auction_item_buy_frame(item_buy_frame)
    local auctions_frame = auction_house and auction_house.AuctionsFrame
    hooks.region(auctions_frame, "SetTab", schedule_auction_auctions_frame)
    hooks.region_script(auctions_frame, "OnShow",
        schedule_auction_auctions_frame)
    local summary_scroll_box = auctions_frame and auctions_frame.SummaryList
        and auctions_frame.SummaryList.ScrollBox
    hooks.region(summary_scroll_box, "SetDataProvider", function ()
        schedule_auction_auctions_frame(auctions_frame)
    end)
    schedule_auction_auctions_frame(auctions_frame)
    hooks.region_script(_G.InboxFrame, "OnShow", update_inbox_controls,
        "inbox-controls")
    hooks.region_script(_G.SendMailFrame, "OnShow", update_inbox_controls,
        "mail-controls")
    hooks.global("MailFrameTab_OnClick", update_inbox_controls)
    hooks.global("SendMailFrame_Update", update_inbox_controls)
    update_inbox_controls()
    local mail = registry.get("mail")
    if mail then
        mail.static = function ()
            update_inbox_controls()
        end
    end
    local game_menu = registry.get("game-menu")
    if game_menu then
        game_menu.static = function ()
            translate_game_menu(_G.GameMenuFrame)
        end
    end
    local lfg = registry.get("lfg")
    if lfg then
        if not lfg.uaForeverStaticConfigured then
            local generic_static = lfg.static
            lfg.static = function (surface)
                translate_lfg_frame(_G.LFGListFrame)
                translate_lfg_vanilla()
                if generic_static and not _G.LFGParentFrame then generic_static(surface) end
            end
            lfg.uaForeverStaticConfigured = true
        end
        lfg.dynamic_hooks = {
            "LFGListEntryCreationActivityFinder_InitButton",
            "LFGListEntryCreation_SetEditMode", "LFGListEntryCreation_Select",
            "LFGParentFrame.UpdateTabs", "LFGListingFrame.UpdateFrameView",
            "LFGListingCategorySelection_UpdateCategoryButtons",
            "LFGListingActivityView_InitActivityButton",
            "LFGListingActivityView_InitActivityGroupButton",
            "LFGListingLockedView_SetLineContent", "LFGBrowseSearchEntry_Update",
            "LFGBrowseSearchEntryTooltip_UpdateAndShow", "LFGWhoListButtonMixin.InitButton",
            "ScrollBox.OnInitializedFrame",
        }
        lfg.slots = { "activity.name", "entry.label", "ui.text", "npc.name" }
        lfg.domains = { "ui", "context", "zone", "npc" }
        lfg.dynamic = function ()
            local root = _G.LFGListFrame
            local entry = root and root.EntryCreation
            if entry then translate_lfg_frame(entry) end
            translate_lfg_vanilla()
        end
    end
    -- Forever 1.60.1 creates the escape menu in GameMenuFrameMixin:InitButtons and
    -- micro-button titles in EvaluateTooltipVisibility. Post-hooks translate
    -- only completed FontStrings; button data and tooltipText stay English.
    -- XML mixins are copied onto frames when the frame is created. The
    -- executable frame-kind declaration therefore hooks the already-created
    -- GameMenuFrame instance; the mixin table is not a second owner.
    hooks.mixin("MainMenuBarMicroButtonMixin", "EvaluateTooltipVisibility", translate_micro_button_tooltip)

    -- The LFG entry-creation page fills pooled activity rows and resets its
    -- labels after the parent panel is already visible. Translate at those
    -- completed writes instead of relying on the initial ShowUIPanel pass.
    hooks.global("LFGListEntryCreationActivityFinder_InitButton",
        translate_lfg_activity_button)
    hooks.global("LFGListEntryCreation_SetEditMode", translate_lfg_edit_mode)
    hooks.global("LFGListEntryCreation_Show", translate_lfg_frame)
    hooks.global("LFGListEntryCreation_Select", translate_lfg_frame)

    -- Hook live instances: XML has already copied their mixin methods.
    for _, name in ipairs({ "LFGParentFrame", "LFGListingFrame",
        "LFGBrowseFrame", "LFGWhoListFrame", "LFGListingFrameActivityView",
        "LFGListingFrameCategoryView", "LFGListingFrameLockedView" }) do
        hooks.region_script(_G[name], "OnShow", translate_lfg_vanilla)
    end
    hooks.region(_G.LFGParentFrame, "UpdateTabs", translate_lfg_vanilla)
    hooks.region(_G.LFGListingFrame, "UpdateFrameView", translate_lfg_vanilla)
    hooks.region(_G.LFGBrowseFrame, "UpdateResults", translate_lfg_vanilla)
    hooks.region(_G.LFGWhoListFrame, "UpdateWhoList", translate_lfg_vanilla)
    for _, name in ipairs({ "LFGListingPostButton_UpdateText",
        "LFGListingBackButton_UpdateText", "LFGListingActivityView_OnShow",
        "LFGListingLockedView_RefreshContent" }) do
        hooks.global(name, translate_lfg_vanilla_listing)
    end
    hooks.global("LFGListingCategorySelection_UpdateCategoryButtons",
        translate_lfg_vanilla_categories)
    hooks.global("LFGListingActivityView_InitActivityButton", translate_lfg_vanilla_activity)
    hooks.global("LFGListingActivityView_InitActivityGroupButton", translate_lfg_vanilla_activity)
    hooks.global("LFGListingLockedView_SetLineContent", function (_, row)
        if row then bind_lfg_display(row.Text, "zone") end
    end)
    hooks.global("LFGBrowseSearchEntry_Update", translate_lfg_vanilla_result)
    hooks.global("LFGBrowseSearchEntryTooltip_UpdateAndShow", translate_lfg_vanilla_tooltip)
    hooks.mixin("LFGWhoListButtonMixin", "InitButton", translate_lfg_vanilla_who_row)
    -- Cover rows created before prepare(), and bind the copied InitButton on
    -- those instances as well as the mixin used by later pooled rows.
    local listing = _G.LFGListingFrame
    local browse = _G.LFGBrowseFrame
    local who = _G.LFGWhoListFrame
    local row_views = {
        { listing and listing.ActivityView and listing.ActivityView.ScrollBox,
            translate_lfg_vanilla_activity },
        { browse and browse.ScrollBox, translate_lfg_vanilla_result },
        { who and who.ScrollBox, translate_lfg_vanilla_who_row },
    }
    for _, view in ipairs(row_views) do
        local scroll_box, translate_row = view[1], view[2]
        local function initialize_row(row)
            if translate_row == translate_lfg_vanilla_who_row then
                hooks.region(row, "InitButton", translate_row)
            end
            translate_row(row)
        end
        if scroll_box and type(scroll_box.RegisterCallback) == "function"
            and _G.ScrollBoxListMixin and not lfg_scroll_boxes[scroll_box] then
            scroll_box:RegisterCallback(ScrollBoxListMixin.Event.OnInitializedFrame,
                function (_, row) initialize_row(row) end, lfg_scroll_boxes)
            lfg_scroll_boxes[scroll_box] = true
        end
        if scroll_box and type(scroll_box.ForEachFrame) == "function" then
            scroll_box:ForEachFrame(initialize_row)
        end
    end
    translate_lfg_vanilla()

    -- Modern dropdowns and context menus are anonymous pooled frames. Hook the
    -- public manager and translate only the completed menu returned as open.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hooks.region(menu_manager, "OpenMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenContextMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenSubmenu", translate_open_menu)

    hooks.global("UIDropDownMenu_AddButton", translate_legacy_dropdown)
    hooks.global("StaticPopup_Show", after_static_popup_show)
    hooks.global("StaticPopup_OnUpdate", after_static_popup_update)
    for index = 1, 4 do
        hooks.region_script(_G["StaticPopup" .. index], "OnShow", function()
            scheduler.request("home-popup:on-show", nil, refresh_and_scan_popups)
        end)
    end

    local game_menu_frame = _G.GameMenuFrame
    hooks.region_script(game_menu_frame, "OnShow", translate_game_menu)
    translate_game_menu(game_menu_frame)

    -- Micro buttons are created before third-party addons, so Camelot has
    -- already copied the mixin method onto each instance by this point.
    for _, name in ipairs({
        "CharacterMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton",
        "SpellbookMicroButton", "TalentMicroButton",
        "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton",
        "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton",
        "StoreMicroButton", "MainMenuMicroButton", "HelpMicroButton",
    }) do
        local button = _G[name]
        hooks.region(button, "EvaluateTooltipVisibility",
            translate_micro_button_tooltip)
    end
end
