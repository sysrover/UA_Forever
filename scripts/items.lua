local _, addon_table = ...

local entries = addon_table.use("entries")
local dev_log = addon_table.use("dev_log")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local items = addon_table.use("items")
local utils = addon_table.use("utils")

local hooked = {}
local reward_region_hooks = setmetatable({}, { __mode = "k" })

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

local function refresh_reward_button(button, native_source)
    if not button or button.objectType ~= "item" or not button.type
        or type(button.GetID) ~= "function" then return end
    local shown_ok, shown = pcall(function ()
        return button.IsShown and button:IsShown()
    end)
    if not shown or not shown_ok then return end
    local getter = _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
        and _G.GetQuestLogItemLink or _G.GetQuestItemLink
    if type(getter) ~= "function"
        or not options.can_lookup("translate_item", "translate_quest_item") then return end
    local id_ok, index = pcall(button.GetID, button)
    local link_ok, link
    if id_ok then link_ok, link = pcall(getter, button.type, index) end
    link = link_ok and safe_string(link) or nil
    local id = link and safe_id(utils.item_id_from_link(link))
    if not id then return end
    local source = link:match("%[(.-)%]")
    if not safe_string(source) then return end
    local region = button.Name
    local text_ok, current = pcall(function () return region:GetText() end)
    if not text_ok or not safe_string(current) then return end
    -- A generic legacy hook may have translated the same SetText first.
    -- The native argument and item link identify this specific domain write.
    if native_source and native_source == source and current ~= source then
        runtime.clear(region)
        runtime.restore_source(region, source)
        current = source
    end
    if current ~= source then return end
    local entry = entries.get_entry("item", id)
    dev_log.record_id("items", id, source, entry ~= nil)
    if not entry then
        dev_log.missing_item(id, source)
        return
    end
    local translated = item_name(id)
    if not translated then return end
    runtime.apply(region, {
        owner = "quest-reward", slot = "item:" .. id .. ".name",
        source = source, translated = translated,
        category = "item",
        options = { "translate_item", "translate_quest_item" },
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function hook_reward_region(button)
    local region = button and button.Name
    if not region or reward_region_hooks[region]
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, region, "SetText", function (self, value)
        if runtime.is_applying(self) then return end
        refresh_reward_button(button, safe_string(value))
    end)
    if ok then reward_region_hooks[region] = true end
end

items.refresh_quest_rewards = function ()
    local rewards = _G.QuestInfoFrame and _G.QuestInfoFrame.rewardsFrame
    local buttons = rewards and rewards.RewardButtons
    if type(buttons) ~= "table" then return end
    for _, button in ipairs(buttons) do
        hook_reward_region(button)
        refresh_reward_button(button)
    end
end

local function hook(name, callback)
    if hooked[name] or type(_G[name]) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, name, callback)
    if ok then hooked[name] = true end
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

local function hook_bag_title(owner, key)
    if not owner or hooked[key] or type(owner.UpdateName) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, owner, "UpdateName", bag_title)
    if ok then hooked[key] = true end
end

items.prepare = function ()
    hook("MerchantFrame_UpdateMerchantInfo", merchant_rows)
    hook("MerchantFrame_UpdateBuybackInfo", buyback_rows)
    hook("QuestInfo_ShowRewards", items.refresh_quest_rewards)
    hook_bag_title(_G.ContainerFrameMixin, "ContainerFrameMixin.UpdateName")
    hook_bag_title(_G.ContainerFrameCombinedBagsMixin,
        "ContainerFrameCombinedBagsMixin.UpdateName")
    local combined = _G.ContainerFrameCombinedBags
    hook_bag_title(combined, "ContainerFrameCombinedBags.UpdateName")
    bag_title(combined)
    local count = type(_G.NUM_CONTAINER_FRAMES) == "number"
        and _G.NUM_CONTAINER_FRAMES or 0
    for index = 1, count do
        local frame = _G["ContainerFrame" .. index]
        hook_bag_title(frame, "ContainerFrame" .. index .. ".UpdateName")
        if frame then bag_title(frame) end
    end
end
