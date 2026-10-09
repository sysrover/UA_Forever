local _, addon_table = ...

local auction_ui = addon_table.use("auction_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local item_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("auction_ui")

local function translate_auction_region(region, slot)
    if not region or runtime.is_applying(region) then return end
    local claim = runtime.get(region)
    if claim and type(region.GetText) == "function" then
        local ok, text = pcall(region.GetText, region)
        if ok and not runtime.is_secret_value(text)
            and text == claim.translated then return end
        if ok and not runtime.is_secret_value(text)
            and text == claim.source then runtime.invalidate(region) end
    end
    strings.translate_region(region, nil, slot, registry.get("misc"),
        nil, nil, "auction")
end

local function translate_auction_label(region)
    translate_auction_region(region, "ui.text")
end

local function watch_auction_region(region, callback)
    if not region then return end
    callback = callback or translate_auction_label
    hooks.region(region, "SetText", callback)
    hooks.region(region, "SetFormattedText", callback)
    callback(region)
end

local function translate_auction_category_region(region)
    translate_auction_region(region, "auction.category")
end

local function translate_auction_category_button(button)
    local region = button and button.Text
    if not region or runtime.is_applying(region) then return end
    hooks.region(region, "SetText", translate_auction_category_region)
    hooks.region(button, "SetText", translate_auction_category_button)
    translate_auction_category_region(region)
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
        verifiedBuild = 70205,
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
        verifiedBuild = 70205,
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
        verifiedBuild = 70205,
        callback = translate_auction_table_header,
    })
end

local function translate_auction_filter_region(region)
    translate_auction_region(region, "auction.filter")
end

local function translate_auction_filter_dropdown(button)
    local region = button and button.Text
    if not region and button and type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok then region = font_string end
    end
    if region and not runtime.is_applying(region) then
        hooks.region(region, "SetText", translate_auction_filter_region)
        translate_auction_filter_region(region)
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

local function translate_auction_action_button(button)
    if not button then return end
    local region = button.Text
    if not region and type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok then region = font_string end
    end
    if region then
        watch_auction_region(region, function (label)
            translate_auction_region(label, "ui.action")
        end)
    end
end

local function translate_auction_item_name(region, item_id)
    if not region or runtime.is_applying(region)
        or runtime.is_secret_value(item_id)
        or type(region.GetText) ~= "function" then return end
    if type(item_id) ~= "number" then runtime.invalidate(region); return end
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local english = item_db.get_english_name(item_id)
    local translated = item_db.get_name(item_id)
    if type(english) ~= "string" or english == ""
        or type(translated) ~= "string" or translated == "" then
        runtime.invalidate(region)
        return
    end
    local first, last = source:find(english, 1, true)
    if not first then runtime.invalidate(region); return end
    -- Retain the native quality color, item decorations and quantity suffix.
    translated = source:sub(1, first - 1) .. utils.cap(translated)
        .. source:sub(last + 1)
    runtime.apply(region, {
        owner = "auction_ui", slot = "item.name", category = "item",
        section = "auction", source = source, translated = translated,
        option = "translate_item_names", options = { "translate_item" },
        priority = runtime.PRIORITY.DOMAIN, lookup_tier = "domain",
        surface = registry.get("misc"), instance = item_id,
        reapply_cached = true,
    })
end

local function prepare_auction_item_display(display)
    if not display then return end
    local function translate_name()
        if type(display.GetItemID) ~= "function" then return end
        local ok, item_id = pcall(display.GetItemID, display)
        if ok and not runtime.is_secret_value(item_id) then
            if item_id then translate_auction_item_name(display.Name, item_id)
            else runtime.invalidate(display.Name) end
        end
    end
    watch_auction_region(display.Name, translate_name)
    hooks.region(display, "SetItemInternal", translate_name)
    hooks.region(display, "SetItemKey", translate_name)
end

local function prepare_auction_commodities_buy_frame(frame)
    if not frame then return end
    translate_auction_action_button(frame.BackButton)
    local display = frame.BuyDisplay
    if display then
        translate_auction_action_button(display.BuyButton)
        for _, key in ipairs({ "QuantityInput", "UnitPrice", "TotalPrice" }) do
            watch_auction_region(display[key] and display[key].Label)
        end
        prepare_auction_item_display(display.ItemDisplay)
    end
    local refresh = frame.ItemList and frame.ItemList.RefreshFrame
    watch_auction_region(refresh and refresh.TotalQuantity)
end

local function prepare_auction_buy_dialog(dialog)
    if not dialog then return end
    for _, key in ipairs({ "BuyNowButton", "CancelButton", "OkayButton" }) do
        translate_auction_action_button(dialog[key])
    end
    local display = dialog.ItemDisplay
    watch_auction_region(display and display.ItemText, function (region)
        translate_auction_item_name(region, dialog.itemID)
    end)
    watch_auction_region(dialog.Notification and dialog.Notification.Text)
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

auction_ui.prepare = function ()
    declare_auction_hooks()
    local auction_house = _G.AuctionHouseFrame
    local auction_filter = auction_house and auction_house.SearchBar
        and auction_house.SearchBar.FilterButton
    hooks.region(auction_filter, "UpdateText",
        translate_auction_filter_dropdown)
    hooks.region(auction_filter, "SetText", translate_auction_filter_dropdown)
    translate_auction_filter_dropdown(auction_filter)
    prepare_auction_duration_dropdowns(auction_house)
    local commodities_buy_frame = auction_house and auction_house.CommoditiesBuyFrame
    hooks.region_script(commodities_buy_frame, "OnShow",
        prepare_auction_commodities_buy_frame, "auction-commodities-buy")
    hooks.region(commodities_buy_frame, "SetItemIDAndPrice",
        prepare_auction_commodities_buy_frame)
    prepare_auction_commodities_buy_frame(commodities_buy_frame)
    local buy_dialog = auction_house and auction_house.BuyDialog
    hooks.region_script(buy_dialog, "OnShow", prepare_auction_buy_dialog,
        "auction-buy-confirmation")
    hooks.region(buy_dialog, "SetItemID", prepare_auction_buy_dialog)
    hooks.region(buy_dialog, "SetState", prepare_auction_buy_dialog)
    prepare_auction_buy_dialog(buy_dialog)
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
end
