local _, addon_table = ...

local trade_ui = addon_table.use("trade_ui")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local entries = addon_table.use("entries")
local item_client_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("trade-ui")
local layout = addon_table.use("translation_layout")
local surface
local original_width

local function layout_buttons()
    local frame = _G.TradeFrame
    local trade = _G.TradeFrameTradeButton
    local cancel = _G.TradeFrameCancelButton
    if not frame or not trade or not cancel or runtime.combat_locked()
        or not runtime.can_write_text(frame) then return end
    local width = layout.safe_dimension(frame, "GetWidth")
    if not width then return end
    original_width = original_width or width
    strings.fit_button_to_text(trade)
    strings.fit_button_to_text(cancel)
    local trade_width = layout.safe_dimension(trade, "GetWidth")
    local cancel_width = layout.safe_dimension(cancel, "GetWidth")
    if not trade_width or not cancel_width then return end
    local required_width = math.max(original_width,
        math.ceil(trade_width + cancel_width + 3 + 12))
    pcall(frame.SetWidth, frame, required_width)
    -- Native -85 assumed a 77px Cancel button. Anchor from the actual right
    -- edge so translated widths cannot push Cancel outside the panel.
    pcall(cancel.ClearAllPoints, cancel)
    pcall(cancel.SetPoint, cancel, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)
    pcall(trade.ClearAllPoints, trade)
    pcall(trade.SetPoint, trade, "RIGHT", cancel, "LEFT", -3, 0)
end

local function is_open()
    local frame = _G.TradeFrame
    if not frame then return false end
    local ok, shown = pcall(frame.IsShown, frame)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function read_text(region)
    if not region or type(region.GetText) ~= "function" then return nil end
    local ok, text = pcall(region.GetText, region)
    return ok and runtime.safe_string_or_nil(text) or nil
end

local function translate_label(region)
    if not region or runtime.is_applying(region) then return end
    local changed = strings.translate_region(region, nil, "ui.label", surface)
    layout_buttons()
    return changed
end

local function prepare_label(region)
    if not region then return end
    hooks.region(region, "SetText", translate_label)
    hooks.region(region, "SetFormattedText", translate_label)
    translate_label(region)
end

local function prepare_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then prepare_label(region) end
end

local function translate_item(index, recipient, native_write)
    if runtime.is_secret_value(index) or type(index) ~= "number"
        or index < 1 or index > 7 or index % 1 ~= 0 then return end
    local prefix = recipient and "TradeRecipientItem" or "TradePlayerItem"
    local region = _G[prefix .. index .. "Name"]
    if not region then return end
    local source = read_text(region)
    local previous = runtime.get(region)
    if not native_write and previous and source == previous.translated then
        source = previous.source
    end
    -- These rows are reused after every offer change, including empty slots.
    -- Discard the old item identity only after the native callback has written.
    runtime.invalidate(region)
    if not source or source == "" then return end
    if index == 7 then
        -- Build 70170 writes an enchantment label (or NOT_MODIFIED) here,
        -- rather than the item's name. Preserve native color markup.
        local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        local label = plain == _G.TRADEFRAME_NOT_MODIFIED_TEXT
        local context = not label and { category = "spell", slot = "spell.name" } or nil
        local translated, _, tier, category, slot, option, provenance =
            resolver.find_ui(source, region, context)
        translated = runtime.safe_string_or_nil(translated)
        if not translated then return end
        local color, _, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
        if color and not translated:find("|c", 1, true) then
            translated = color .. translated .. reset
        end
        runtime.apply(region, {
            owner = "trade-ui", slot = slot or "ui.label", category = category,
            source = source, translated = translated,
            option = option or (category == "spell" and "translate_spell" or "translate_string"),
            lookup_tier = tier, catalog_source = provenance and provenance.source,
            priority = runtime.priority_for_source(tier), surface = surface,
            phase = "direct", reapply_cached = true,
        })
        return
    end
    local getter = recipient and _G.GetTradeTargetItemLink or _G.GetTradePlayerItemLink
    if type(getter) ~= "function" then return end
    local ok, link = pcall(getter, index)
    link = ok and runtime.safe_string_or_nil(link) or nil
    local id = link and utils.item_id_from_link(link)
    if runtime.is_secret_value(id) or type(id) ~= "number" or id <= 0 then return end
    local entry = entries.get_entry("item", id)
    local translated = entry and entry[1] or item_client_db.get_name(id)
    translated = runtime.safe_string_or_nil(translated)
    if not translated then return end
    local generation = runtime.begin_generation(region, id)
    runtime.apply(region, {
        owner = "trade-ui", slot = "item:" .. id .. ".name",
        source = source, translated = utils.cap(translated), category = "item",
        option = "translate_item", priority = runtime.PRIORITY.DOMAIN,
        surface = region, generation = generation, instance = id,
        phase = "dynamic", reapply_cached = true,
    })
end

local function refresh()
    if not is_open() then return end
    -- Explicit labels only: the player names and forbidden money input frame
    -- are native data, and must never enter a generic translation walk.
    prepare_label(_G.TradeFramePlayerEnchantText)
    prepare_label(_G.TradeFrameRecipientEnchantText)
    prepare_button(_G.TradeFrameTradeButton)
    prepare_button(_G.TradeFrameCancelButton)
    layout_buttons()
    for index = 1, 7 do
        translate_item(index, false)
        translate_item(index, true)
    end
end

local function translate_warning(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not button or type(tooltip.IsOwned) ~= "function" then return end
    local owned_ok, owned = pcall(tooltip.IsOwned, tooltip, button)
    if not owned_ok or runtime.is_secret_value(owned) or owned ~= true then return end
    local source = runtime.safe_string_or_nil(button.warningTooltip)
    if not source then return end
    -- The exact 70170 template is formatted with a player's name. Resolve its
    -- existing catalog entry, keeping the captured name and native field intact.
    local name = source:match("^(.-) has changed their trade offer%. Please ensure you are receiving the correct items and gold%.$")
    local template = runtime.safe_string_or_nil(_G.TRADE_WARNING_CHANGED_OFFER)
    local translated = template and resolver.find_ui(template)
    if not name or not translated then return end
    local format_ok, text = pcall(string.format, translated, name)
    if not format_ok then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    if not count_ok or runtime.is_secret_value(count) or type(count) ~= "number" then return end
    for index = 1, math.min(count, 30) do
        local region = _G["GameTooltipTextLeft" .. index]
        if read_text(region) == source then
            runtime.apply(region, {
                owner = "trade-ui", slot = "ui.warning", source = source,
                translated = text, option = "translate_string",
                surface = surface, priority = runtime.PRIORITY.CONTEXT,
                phase = "direct", reapply_cached = true,
            })
        end
    end
end

trade_ui.prepare = function ()
    surface = registry.register_surface({ id = "trade-ui", roots = { "TradeFrame" },
        domains = { "ui", "item", "spell" }, name_category = "none",
        slots = { "ui.label", "ui.warning", "item.name", "spell.name" },
        static = refresh, is_open = is_open, clear_on_reuse = true })
    local function declare(target, callback)
        registry.declare_hook({ id = "trade-ui:" .. target,
            surface = "trade-ui", kind = "global",
            target = target, callback = callback,
            blizzardAddon = "Blizzard_UIPanels_Game", verifiedBuild = "1.60.1.70170" })
    end
    declare("TradeFrame_OnShow", refresh)
    declare("TradeFrame_Update", refresh)
    declare("TradeFrame_UpdatePlayerItem", function (index)
        translate_item(index, false, true)
    end)
    declare("TradeFrame_UpdateTargetItem", function (index)
        translate_item(index, true, true)
    end)
    -- The XML binds the instance's OnEnter script when the button is created;
    -- a late hook on the mixin table alone does not cover that existing script.
    hooks.region_script(_G.TradeFrameTradeButton, "OnEnter", translate_warning)
    hooks.region_script(_G.TradeFrame, "OnShow", refresh)
    hooks.region_script(_G.TradeFrame, "OnHide", function ()
        for index = 1, 7 do
            runtime.invalidate(_G["TradePlayerItem" .. index .. "Name"])
            runtime.invalidate(_G["TradeRecipientItem" .. index .. "Name"])
        end
    end)
    refresh()
end
