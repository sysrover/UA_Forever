local _, addon_table = ...

local auction_ui = addon_table.use("auction_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("auction_ui")

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

auction_ui.prepare = function ()
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
end
