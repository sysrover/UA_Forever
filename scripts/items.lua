local _, addon_table = ...

local entries = addon_table.use("entries")
local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local items = addon_table.use("items")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("items")
local registry = addon_table.use("translation_registry")


local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function safe_id(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "number" and value > 0 and value or nil
end

local function item_name(id)
    if type(id) ~= "number" then return nil end
    local entry = entries.get_entry("item", id)
    if not entry or not safe_string(entry[1]) then return nil end
    local ok, value = pcall(entries.make_entry_text, entry[1])
    if not ok or not safe_string(value) or value:find("{%d+}") then return nil end
    return utils.cap(value)
end

local function apply_row(region, id)
    if not region then return end
    runtime.clear(region)
    id = safe_id(id)
    if not id then return end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return end
    local ok, source = pcall(get_text, region)
    source = ok and safe_string(source) or nil
    if not source then
        return
    end
    -- Blizzard has just written this pooled row. Its old ID claim is stale
    -- even when the new item's English name happens to be identical.
    if not options.can_lookup("translate_item") then return end
    local translated = item_name(id)
    if not translated then return end
    runtime.apply(region, {
        owner = "merchant", slot = "item:" .. id .. ".name",
        source = source, translated = translated, category = "item",
        option = "translate_item",
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function item_id_from_link(getter, index)
    if type(getter) ~= "function" then return nil end
    local ok, link = pcall(getter, index)
    if not ok or not safe_string(link) then return nil end
    return utils.item_id_from_link(link)
end

local function merchant_rows()
    local page_region = _G.MerchantPageText
    if page_region and type(page_region.GetText) == "function" then
        local ok, source = pcall(page_region.GetText, page_region)
        local current, total
        if ok and type(source) == "string" then
            current, total = source:match("^Page (%d+) of (%d+)$")
        end
        if current and total then
            runtime.apply(page_region, {
                owner = "merchant", slot = "page.count", source = source,
                translated = "Сторінка " .. current .. " з " .. total,
                priority = runtime.PRIORITY.CONTEXT,
            })
        end
    end
    local count = type(_G.MERCHANT_ITEMS_PER_PAGE) == "number"
        and _G.MERCHANT_ITEMS_PER_PAGE or 0
    local page = _G.MerchantFrame and _G.MerchantFrame.page or 1
    if type(page) ~= "number" then page = 1 end
    for row = 1, count do
        local index = (page - 1) * count + row
        local id
        if type(_G.GetMerchantItemID) == "function" then
            local ok, value = pcall(_G.GetMerchantItemID, index)
            if ok then id = safe_id(value) end
        end
        id = id or item_id_from_link(_G.GetMerchantItemLink, index)
        apply_row(_G["MerchantItem" .. row .. "Name"], id)
    end
    local buyback_count = 0
    if type(_G.GetNumBuybackItems) == "function" then
        local ok, value = pcall(_G.GetNumBuybackItems)
        if ok and type(value) == "number" then buyback_count = value end
    end
    local id = item_id_from_link(_G.GetBuybackItemLink, buyback_count)
    apply_row(_G.MerchantBuyBackItemName, id)
end

local function buyback_rows()
    local count = type(_G.BUYBACK_ITEMS_PER_PAGE) == "number"
        and _G.BUYBACK_ITEMS_PER_PAGE or 0
    for row = 1, count do
        local id = item_id_from_link(_G.GetBuybackItemLink, row)
        apply_row(_G["MerchantItem" .. row .. "Name"], id)
    end
end

local function refresh_reward_button(button)
    if not button or button.objectType ~= "item" or not button.type
        or type(button.GetID) ~= "function" then return end
    local shown_ok, shown = pcall(function ()
        return button.IsShown and button:IsShown()
    end)
    if not shown or not shown_ok then return end
    local getter = _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
        and _G.GetQuestLogItemLink or _G.GetQuestItemLink
    if not options.can_lookup("translate_item", "translate_quest_item") then return end
    local region = button.Name
    local text_ok, current = pcall(function () return region:GetText() end)
    if not text_ok or not safe_string(current) then return end
    local id_ok, index = pcall(button.GetID, button)
    local link_ok, link
    if id_ok and type(getter) == "function" then
        link_ok, link = pcall(getter, button.type, index)
    end
    link = link_ok and safe_string(link) or nil
    local id = link and safe_id(utils.item_id_from_link(link))
    local entry = id and entries.get_entry("item", id)
    local translated
    if entry and entry.en == current then translated = item_name(id) end
    if not translated then
        translated = entries.lookup_name("item", current)
        if translated then translated = utils.cap(translated) end
    end
    if id then dev_log.record_id("items", id, current, entry ~= nil) end
    if not translated then return end
    runtime.apply(region, {
        owner = "quest-reward", slot = "item:" .. tostring(id or current) .. ".name",
        source = current, translated = translated,
        category = "item",
        options = { "translate_item", "translate_quest_item" },
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function hook_reward_region(button)
    local region = button and button.Name
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if runtime.is_applying(self) then return end
        refresh_reward_button(button)
    end)
    hooks.region(button, "OnEnter", function (self)
        tooltips.refresh_quest_reward(_G.GameTooltip, self, true)
    end)
end

items.refresh_quest_rewards = function ()
    local rewards = _G.QuestInfoFrame and _G.QuestInfoFrame.rewardsFrame
    local buttons = rewards and rewards.RewardButtons
    if type(buttons) ~= "table" then return end
    for _, region in ipairs({ rewards.Header, rewards.ItemChooseText,
        rewards.ItemReceiveText, rewards.PlayerTitleText,
        rewards.XPFrame and rewards.XPFrame.ReceiveText }) do
        strings.translate_region(region)
    end
    for _, button in ipairs(buttons) do
        hook_reward_region(button)
        refresh_reward_button(button)
    end
end

local function bag_title(frame)
    if not frame then return end
    local region = frame.TitleText
    if type(frame.GetTitleText) == "function" then
        local ok, title = pcall(frame.GetTitleText, frame)
        if ok and title then region = title end
    end
    if region then strings.translate_region(region) end
end

items.prepare = function ()
    hooks.global("MerchantFrame_UpdateMerchantInfo", merchant_rows)
    hooks.global("MerchantFrame_UpdateBuybackInfo", buyback_rows)
    hooks.global("QuestInfo_ShowRewards", items.refresh_quest_rewards)
    -- QuestInfo templates retain the original reward writer as a function
    -- reference, bypassing a hook on its global name. Display always runs
    -- after the selected template has populated its reward frame.
    hooks.global("QuestInfo_Display", items.refresh_quest_rewards)
    hooks.global("LootFrame_Update", function () registry.refresh("items") end)
    hooks.once("loot-events", function ()
        if type(_G.CreateFrame) ~= "function" then return false end
        local frame = _G.CreateFrame("Frame")
        local opened = pcall(frame.RegisterEvent, frame, "LOOT_OPENED")
        pcall(frame.RegisterEvent, frame, "LOOT_SLOT_CHANGED")
        if not opened then return false end
        frame:SetScript("OnEvent", function () registry.refresh("items") end)
        return true
    end)
    hooks.region(_G.ContainerFrameMixin, "UpdateName", bag_title)
    hooks.region(_G.ContainerFrameCombinedBagsMixin, "UpdateName", bag_title)
    local combined = _G.ContainerFrameCombinedBags
    hooks.region(combined, "UpdateName", bag_title)
    bag_title(combined)
    local count = type(_G.NUM_CONTAINER_FRAMES) == "number"
        and _G.NUM_CONTAINER_FRAMES or 0
    for index = 1, count do
        local frame = _G["ContainerFrame" .. index]
        hooks.region(frame, "UpdateName", bag_title)
        if frame then bag_title(frame) end
    end
end
