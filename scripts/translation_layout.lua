local _, addon_table = ...
local layout = addon_table.use("translation_layout")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")

local BUTTON_TEXT_PADDING = 24
local AUCTION_TAB_PADDING = 20
local AUCTION_TAB_SIDE_PADDING = 20
local AUCTION_TAB_MIN_WIDTH = 70
local QUEST_BUTTON_TEXT_PADDING = 16
local QUEST_BUTTON_MIN_WIDTH = 64
local BAG_TOOLTIP_TEXT_PADDING = 24
local BAG_TOOLTIP_MAX_WIDTH = 420
local TOOLTIP_TEXT_PADDING = 24
local TOOLTIP_MAX_WIDTH = 300
local TOOLTIP_HINT_MAX_WIDTH = 420
local TOOLTIP_COMPACT_WIDTH = 180
local pending_tooltip_layout = setmetatable({}, { __mode = "k" })
local QUEST_DETAILS_HINT = "<Click to view Quest Details>"
local AUCTION_TAB_SOURCES = {
    Auctions = true, Bid = true, Bids = true, Browse = true, Buy = true,
    Sell = true,
}
local AUCTION_TAB_NAMES = {
    AuctionHouseFrameAuctionsTab = true,
    AuctionHouseFrameBuyTab = true,
    AuctionHouseFrameSellTab = true,
}

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function is_protected_frame(frame)
    return strings.is_protected_frame and strings.is_protected_frame(frame)
end

local function safe_dimension(owner, method)
    if not owner then return nil end
    local method_ok, callback = pcall(function () return owner[method] end)
    if not method_ok or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, owner)
    -- On Camelot, tooltip measurements derived from aura data can themselves
    -- be secret numbers. Checking their Lua type is not sufficient: any
    -- comparison or arithmetic on such a value taints and raises an error.
    if not ok or is_secret(value) or type(value) ~= "number" then return nil end
    if value >= 0 then return value end
end

local function unbounded_text_width(region)
    return safe_dimension(region, "GetUnboundedStringWidth")
        or safe_dimension(region, "GetStringWidth")
end

local function is_button(frame)
    if not frame then return false end
    local method_ok, get_type = pcall(function () return frame.GetObjectType end)
    if not method_ok or type(get_type) ~= "function" then return false end
    local ok, object_type = pcall(get_type, frame)
    return ok and not is_secret(object_type) and object_type == "Button"
end

local function is_tooltip(frame)
    if not frame then return false end
    local method_ok, get_type = pcall(function () return frame.GetObjectType end)
    if not method_ok or type(get_type) ~= "function" then return false end
    local ok, object_type = pcall(get_type, frame)
    return ok and not is_secret(object_type) and object_type == "GameTooltip"
end

local function object_name(owner)
    if not owner then return nil end
    local method_ok, get_name = pcall(function () return owner.GetName end)
    if not method_ok or type(get_name) ~= "function" then return nil end
    local ok, name = pcall(get_name, owner)
    return ok and not is_secret(name) and type(name) == "string" and name or nil
end

local function parent_of(owner)
    if not owner then return nil end
    local method_ok, get_parent = pcall(function () return owner.GetParent end)
    if not method_ok or type(get_parent) ~= "function" then return nil end
    local ok, parent = pcall(get_parent, owner)
    return ok and not is_secret(parent) and parent or nil
end

local function is_descendant_of(owner, root, max_depth)
    if not owner or not root then return false end
    local current = owner
    for _ = 1, max_depth or 12 do
        if current == root then return true end
        local parent = parent_of(current)
        if not parent or parent == current then break end
        current = parent
    end
    return false
end

local function named_auction_tab(button)
    local name = object_name(button)
    if not name then return false end
    return AUCTION_TAB_NAMES[name] == true
        or name:match("^AuctionFrameTab[123]$") ~= nil
        or name:match("^AuctionHouseFrameTab[123]$") ~= nil
        or name:match("^Auction.*Tab[123]$") ~= nil
end

local function find_auction_tab(region, source)
    if source and not AUCTION_TAB_SOURCES[source] then return nil end
    local button
    local owner = region
    for _ = 1, 6 do
        if not owner then break end
        if is_button(owner) and not button then button = owner end
        if button and named_auction_tab(button) then return button end
        local name = object_name(owner)
        if button and (owner == _G.AuctionFrame
            or owner == _G.AuctionHouseFrame
            or name == "AuctionFrame" or name == "AuctionHouseFrame") then
            return button
        end
        local parent = parent_of(owner)
        if parent == owner then break end
        owner = parent
    end
end

local function fit_auction_tab(region, source)
    local button = find_auction_tab(region, source)
    if not button or type(button.SetWidth) ~= "function" then return false end
    local resize = _G.PanelTemplates_TabResize
    if type(resize) == "function" then
        local ok = pcall(resize, button, AUCTION_TAB_PADDING, nil,
            AUCTION_TAB_MIN_WIDTH)
        if ok then return true end
    end
    -- Client build 70009's native resizer first removes the FontString width
    -- constraint, measures the full text, then restores both text and tab
    -- widths. Mirror that sequence only when the native helper is unavailable.
    if region and type(region.SetWidth) == "function" then
        pcall(region.SetWidth, region, 0)
    end
    local text_width = unbounded_text_width(region)
        or safe_dimension(button, "GetTextWidth")
    if not text_width then return false end
    local required_width = math.max(AUCTION_TAB_MIN_WIDTH,
        math.ceil(text_width + AUCTION_TAB_SIDE_PADDING + AUCTION_TAB_PADDING))
    if region and type(region.SetWidth) == "function" then
        pcall(region.SetWidth, region, text_width)
    end
    pcall(button.SetWidth, button, required_width)
    return true
end

local function fit_tooltip_height_to_region(tooltip, region, previous_region_height, previous_tooltip_height)
    if not is_tooltip(tooltip) or not previous_region_height or not previous_tooltip_height then return end
    local current_region_height = safe_dimension(region, "GetStringHeight")
        or safe_dimension(region, "GetHeight")
    if not current_region_height then return end

    local difference = current_region_height - previous_region_height
    local required_height = previous_tooltip_height + difference
    if math.abs(difference) >= 0.5 and required_height > 0
        and type(tooltip.SetHeight) == "function" then
        -- ClassicUA appends separate lines, which the client sizes natively.
        -- Forever's Ukrainian-only mode replaces a rendered FontString, so
        -- only its height delta must be applied; width remains client-owned.
        pcall(tooltip.SetHeight, tooltip, required_height)
    end
end

local function restore_tooltip_width(tooltip)
    local width = tooltip and tooltip.uaForeverOriginalWidth
    if not width or type(tooltip.SetWidth) ~= "function" then return end
    local translated_width = tooltip.uaForeverTranslatedWidth
    local current_width = safe_dimension(tooltip, "GetWidth")
    if translated_width and current_width
        and math.abs(current_width - translated_width) >= 0.5 then
        -- The client already laid out different tooltip content. Forget the
        -- stale snapshot instead of forcing the previous tooltip's width.
        tooltip.uaForeverOriginalWidth = nil
        tooltip.uaForeverTranslatedWidth = nil
        return
    end
    local ok = pcall(tooltip.SetWidth, tooltip, width)
    if ok then
        tooltip.uaForeverOriginalWidth = nil
        tooltip.uaForeverTranslatedWidth = nil
    end
end

local function fit_tooltip_width_to_region(tooltip, region, source)
    if not is_tooltip(tooltip) then return end
    local text_width = unbounded_text_width(region)
    local tooltip_width = safe_dimension(tooltip, "GetWidth")
    if not text_width or not tooltip_width or type(tooltip.SetWidth) ~= "function" then return end

    -- Long aura descriptions are meant to wrap at the client's chosen width.
    -- Compact one-line tooltips and the quest-log details hint need more room
    -- for a longer translation.
    local quest_details_hint = source == QUEST_DETAILS_HINT
    if tooltip_width >= TOOLTIP_COMPACT_WIDTH and not quest_details_hint then return end

    local max_width = quest_details_hint and TOOLTIP_HINT_MAX_WIDTH or TOOLTIP_MAX_WIDTH
    local required_width = math.min(max_width,
        math.ceil(text_width + TOOLTIP_TEXT_PADDING))
    if required_width > tooltip_width then
        if quest_details_hint and not tooltip.uaForeverOriginalWidth then
            tooltip.uaForeverOriginalWidth = tooltip_width
        end
        local ok = pcall(tooltip.SetWidth, tooltip, required_width)
        -- Compact icon-tab tooltips are laid out before UA Forever replaces
        -- their short native label. SetWidth alone does not expand the already
        -- allocated line FontString in build 70009, leaving the Ukrainian text
        -- clipped to a few characters with an ellipsis.
        if ok and region and type(region.SetWidth) == "function" then
            pcall(region.SetWidth, region,
                math.max(1, required_width - TOOLTIP_TEXT_PADDING))
        end
        if ok and quest_details_hint then
            tooltip.uaForeverTranslatedWidth = required_width
        end
    end
end

local function fit_aura_header_width(tooltip, left, right, padding)
    if not is_tooltip(tooltip) or not left or not right then return end
    local left_width = unbounded_text_width(left)
    local right_width = unbounded_text_width(right)
    local tooltip_width = safe_dimension(tooltip, "GetWidth")
    if not left_width or not right_width or not tooltip_width then return end
    local required = math.ceil(left_width + right_width + (padding or 32))
    if required > tooltip_width and required <= 420 then
        pcall(tooltip.SetWidth, tooltip, required)
    end
end

local function fit_bag_tooltip_width(tooltip, region, source)
    if not is_tooltip(tooltip) or type(source) ~= "string"
        or not source:match("^%d+ Empty Slots") then return end

    local text_width = unbounded_text_width(region)
    local tooltip_width = safe_dimension(tooltip, "GetWidth")
    if not text_width or not tooltip_width or type(tooltip.SetWidth) ~= "function" then return end

    local required_width = math.min(BAG_TOOLTIP_MAX_WIDTH,
        math.ceil(text_width + BAG_TOOLTIP_TEXT_PADDING))
    if required_width > tooltip_width then
        pcall(tooltip.SetWidth, tooltip, required_width)
    end
end

local function fit_tooltip_snapshot(tooltip, snapshot)
    if not is_tooltip(tooltip) or type(snapshot) ~= "table" then return false end
    local original_width = snapshot.tooltip_width
        or safe_dimension(tooltip, "GetWidth")
    local original_height = snapshot.tooltip_height
        or safe_dimension(tooltip, "GetHeight")
    if not original_width or not original_height then return false end

    local max_text_width = 0
    for index = 1, snapshot.count or 0 do
        local row = snapshot[index]
        for _, side in ipairs({ row and row.left, row and row.right }) do
            if side and side.region then
                max_text_width = math.max(max_text_width,
                    unbounded_text_width(side.region) or 0)
            end
        end
    end
    local target_width = original_width
    if original_width < TOOLTIP_COMPACT_WIDTH and max_text_width > 0 then
        target_width = math.min(TOOLTIP_MAX_WIDTH,
            math.max(original_width, math.ceil(max_text_width + TOOLTIP_TEXT_PADDING)))
    end
    if target_width > original_width and type(tooltip.SetWidth) == "function" then
        local ok = pcall(tooltip.SetWidth, tooltip, target_width)
        if ok and type(runtime.metric) == "function" then
            runtime.metric("layout_writes", tooltip, tooltip.uaForeverGeneration)
        end
    end

    local height_delta = 0
    for index = 1, snapshot.count or 0 do
        local row = snapshot[index]
        for _, side in ipairs({ row and row.left, row and row.right }) do
            if side and side.region and side.previous_height then
                local current = safe_dimension(side.region, "GetStringHeight")
                    or safe_dimension(side.region, "GetHeight")
                if current then height_delta = height_delta + current - side.previous_height end
            end
        end
    end
    local target_height = original_height + height_delta
    if math.abs(height_delta) >= 0.5 and target_height > 0
        and type(tooltip.SetHeight) == "function" then
        local ok = pcall(tooltip.SetHeight, tooltip, target_height)
        if ok and type(runtime.metric) == "function" then
            runtime.metric("layout_writes", tooltip, tooltip.uaForeverGeneration)
        end
    end
    return true
end

local function is_shown(frame)
    if not frame then return false end
    local method_ok, callback = pcall(function () return frame.IsShown end)
    if not method_ok or type(callback) ~= "function" then return false end
    local ok, value = pcall(callback, frame)
    return ok and not is_secret(value) and value == true
end

-- Direct tooltip writers bypass tooltips.set_translation. Give them the same
-- text/font-to-layout lifecycle, with incremental, repeat-safe height changes.
layout.tooltip_after_text = function (tooltip, region, source, wrap_to_tooltip)
    if not is_tooltip(tooltip) or not region then return nil end
    local previous_height = safe_dimension(region, "GetHeight")
        or safe_dimension(region, "GetStringHeight")
    local generation = tooltip.uaForeverGeneration
    local active_claim
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or is_secret(owner) then return nil end
    local function fit()
        local claim = runtime.get(region)
        local current_owner_ok, current_owner = pcall(tooltip.GetOwner, tooltip)
        if not claim or active_claim and claim ~= active_claim
            or claim.surface ~= tooltip or not is_shown(tooltip)
            or tooltip.uaForeverGeneration ~= generation
            or not current_owner_ok or is_secret(current_owner) or current_owner ~= owner then
            pending_tooltip_layout[region] = nil
            return false
        end
        active_claim = claim
        if runtime.combat_locked() then
            pending_tooltip_layout[region] = fit
            return false
        end
        if not runtime.can_write_text(tooltip) or not runtime.can_write_text(region) then return false end
        pending_tooltip_layout[region] = nil
        local tooltip_height = safe_dimension(tooltip, "GetHeight")
        fit_tooltip_width_to_region(tooltip, region, source)
        if wrap_to_tooltip then
            local width = safe_dimension(tooltip, "GetWidth")
            if not width or width <= TOOLTIP_TEXT_PADDING
                or type(region.SetWidth) ~= "function" then return false end
            if not pcall(region.SetWidth, region, width - TOOLTIP_TEXT_PADDING) then
                return false
            end
        end
        -- Release any native line/height caps before measuring, otherwise the
        -- measurement can describe the clipped text rather than its full body.
        if type(region.SetMaxLines) == "function" then pcall(region.SetMaxLines, region, 0) end
        if type(region.SetWordWrap) == "function" then pcall(region.SetWordWrap, region, true) end
        if type(region.SetNonSpaceWrap) == "function" then pcall(region.SetNonSpaceWrap, region, true) end
        if type(region.SetHeight) == "function" then pcall(region.SetHeight, region, 0) end
        local height = safe_dimension(region, "GetStringHeight")
        if not height or height <= 0 then
            return false
        end
        if height and previous_height and tooltip_height then
            -- Keep the FontString automatically sized. Tooltip rows are pooled:
            -- pinning this measured height leaves gaps when a shorter item line
            -- later reuses the same region after OnTooltipCleared.
            fit_tooltip_height_to_region(tooltip, region, previous_height, tooltip_height)
            previous_height = height
        end
        return true
    end
    return fit
end

-- Fit completed tooltips, including both columns and late native writes.
-- Per-write height deltas are unreliable while Blizzard is building rows.
local function fit_complete_tooltip(tooltip, maximum_width)
    if not is_tooltip(tooltip) or tooltip.uaForeverShowOriginal
        or not is_shown(tooltip) then return false end
    local generation = tooltip.uaForeverGeneration
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or is_secret(owner) then return false end
    if runtime.combat_locked() then
        pending_tooltip_layout[tooltip] = function ()
            pending_tooltip_layout[tooltip] = nil
            local ok, current_owner = pcall(tooltip.GetOwner, tooltip)
            if ok and not is_secret(current_owner) and current_owner == owner
                and tooltip.uaForeverGeneration == generation then
                fit_complete_tooltip(tooltip, maximum_width)
            end
        end
        return false
    end
    pending_tooltip_layout[tooltip] = nil
    if not runtime.can_write_text(tooltip) then return false end
    local name = object_name(tooltip)
    local count = safe_dimension(tooltip, "NumLines")
    local width = safe_dimension(tooltip, "GetWidth")
    if not name or not count or not width then return false end
    local rows, required_width = {}, width
    for index = 1, count do
        local row = {}
        for _, side in ipairs({ "Left", "Right" }) do
            local region = _G[name .. "Text" .. side .. index]
            if region and is_shown(region) then
                local ok, text = pcall(region.GetText, region)
                text = ok and runtime.safe_string_or_nil(text) or nil
                if not text or not runtime.can_write_text(region) then return false end
                row[side] = region
                row[side .. "Width"] = unbounded_text_width(region) or 0
            end
        end
        required_width = math.max(required_width,
            (row.LeftWidth or 0) + (row.RightWidth or 0)
                + TOOLTIP_TEXT_PADDING + (row.Right and 12 or 0))
        rows[#rows + 1] = row
    end
    local screen_width = safe_dimension(_G.UIParent, "GetWidth")
    local maximum = screen_width and math.min(maximum_width, screen_width - 32)
        or maximum_width
    width = math.min(maximum, math.max(width, required_width))
    if width <= TOOLTIP_TEXT_PADDING
        or type(tooltip.SetWidth) ~= "function"
        or not pcall(tooltip.SetWidth, tooltip, width) then return false end
    local available = width - TOOLTIP_TEXT_PADDING
    for _, row in ipairs(rows) do
        local right_width = row.Right and math.min(row.RightWidth, available * 0.45) or 0
        for _, side in ipairs({ "Left", "Right" }) do
            local region = row[side]
            if region then
                local text_width = side == "Right" and right_width
                    or available - right_width - (row.Right and 12 or 0)
                if type(region.SetWidth) == "function" then
                    pcall(region.SetWidth, region, math.max(1, text_width))
                end
                if type(region.SetMaxLines) == "function" then pcall(region.SetMaxLines, region, 0) end
                if type(region.SetWordWrap) == "function" then pcall(region.SetWordWrap, region, true) end
                if type(region.SetNonSpaceWrap) == "function" then pcall(region.SetNonSpaceWrap, region, true) end
                if type(region.SetHeight) == "function" then pcall(region.SetHeight, region, 0) end
                local height = safe_dimension(region, "GetStringHeight")
                if not height or height <= 0 then
                    return false
                end
                -- Leave shared GameTooltip rows at automatic height so later
                -- item/quest tooltips cannot inherit this text's line count.
                row[side .. "Height"] = height
            end
        end
    end
    local top = safe_dimension(tooltip, "GetTop")
    if not top then return false end
    local height = 0
    for _, row in ipairs(rows) do
        for _, side in ipairs({ "Left", "Right" }) do
            if row[side] then
                local row_top = safe_dimension(row[side], "GetTop")
                if not row_top then return false end
                height = math.max(height, top - row_top + row[side .. "Height"])
            end
        end
    end
    if height <= 0 or type(tooltip.SetHeight) ~= "function" then return false end
    return pcall(tooltip.SetHeight, tooltip, math.ceil(height + TOOLTIP_TEXT_PADDING / 2))
end

layout.fit_talent_tooltip = function (tooltip)
    if not tooltip or tooltip.uaForeverKind ~= "talent" then return false end
    return fit_complete_tooltip(tooltip, 360)
end

layout.fit_settings_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.SettingsTooltip then return false end
    return fit_complete_tooltip(tooltip, 420)
end

layout.retry_tooltip_layout = function ()
    if runtime.combat_locked() then return end
    local callbacks = {}
    for _, callback in pairs(pending_tooltip_layout) do callbacks[#callbacks + 1] = callback end
    for _, callback in ipairs(callbacks) do callback() end
end

local function fit_profession_recipe_label(row)
    local label = row and row.Label
    if not label or type(label.SetWidth) ~= "function" then return false end

    -- Mirror ProfessionsRecipeListRecipeMixin:Init from client build 70009.
    -- Blizzard sizes Label to the native English string width; after the text
    -- is translated, Count remains anchored to that stale width and the longer
    -- Ukrainian recipe name is ellipsized.
    local row_width = safe_dimension(row, "GetWidth")
    local skill_up_width = safe_dimension(row.SkillUps, "GetWidth") or 0
    local count_width = is_shown(row.Count)
        and (safe_dimension(row.Count, "GetStringWidth")
            or safe_dimension(row.Count, "GetWidth") or 0) or 0
    local right_width = is_shown(row.LockedIcon)
        and (safe_dimension(row.LockedIcon, "GetWidth") or 0) or 0
    local text_width = unbounded_text_width(label)
    if not row_width or not text_width then return false end

    local available = math.max(0,
        row_width - right_width - count_width - skill_up_width - 10)
    pcall(label.SetWidth, label, math.min(available, text_width))
    return true
end

local function fit_profession_output_text(region, form)
    if not region or type(region.SetWidth) ~= "function"
        or type(region.SetHeight) ~= "function" then return false end

    -- Mirror the local SetTextToFit helper used by
    -- ProfessionsRecipeSchematicFormMixin:UpdateOutputItem in build 70124.
    -- Blizzard runs it for the native item name before UA_Forever replaces
    -- the text, so a longer Ukrainian name otherwise keeps the English width.
    local minimized = false
    local professions_util = _G.ProfessionsUtil
    if professions_util
        and type(professions_util.IsCraftingMinimized) == "function" then
        local ok, value = pcall(professions_util.IsCraftingMinimized)
        minimized = ok and not is_secret(value) and value == true
    end

    local max_width = minimized and 250 or 800
    local text_width = unbounded_text_width(region)
    if form then
        if not runtime.can_write_text(region) or is_protected_frame(form) then
            return false
        end
        local right = safe_dimension(form, "GetRight")
        local left = safe_dimension(region, "GetLeft")
        if not right or not left or right - left <= 24 then return false end
        -- Leave room at the panel edge (including the favorite button).
        max_width = math.min(max_width, right - left - 24)
        if type(region.SetWordWrap) == "function" then
            pcall(region.SetWordWrap, region, true)
        end
        if type(region.SetMaxLines) == "function" then
            pcall(region.SetMaxLines, region, 2)
        end
    end
    pcall(region.SetHeight, region, 200)
    pcall(region.SetWidth, region, max_width)
    if not minimized then
        local fitted_width = form and text_width
            or safe_dimension(region, "GetStringWidth")
        if fitted_width then
            pcall(region.SetWidth, region,
                form and math.min(max_width, fitted_width) or fitted_width)
        end
    end
    local text_height = safe_dimension(region, "GetStringHeight")
    if text_height then pcall(region.SetHeight, region, text_height) end
    return true, form and text_width and text_width > max_width or false
end

local function fit_profession_requirement_text(region)
    if not runtime.can_write_text(region) then return false end
    if type(_G.InCombatLockdown) == "function" then
        local ok, in_combat = pcall(_G.InCombatLockdown)
        if not ok or is_secret(in_combat) or in_combat then return false end
    end
    -- RequiredTools uses the same SetTextToFit helper as the recipe output in
    -- client 70124. Recalculate after translation, not from the native width.
    return fit_profession_output_text(region)
end

local function fit_quest_map_button_group(button)
    local quest_map = _G.QuestMapFrame
    local details = quest_map and (quest_map.DetailsFrame
        or (quest_map.QuestsFrame and quest_map.QuestsFrame.DetailsFrame))
    local group, left_inset, right_inset, bottom_offset
    for _, candidate in ipairs({
        { owner = details, left = 0, right = 0, bottom = -2 },
        { owner = _G.QuestLogPopupDetailFrame,
            left = 4, right = 8, bottom = 5 },
    }) do
        local owner = candidate.owner
        if owner and (button == owner.AbandonButton
            or button == owner.ShareButton or button == owner.TrackButton) then
            group = owner
            left_inset = candidate.left
            right_inset = candidate.right
            bottom_offset = candidate.bottom
            break
        end
    end
    if not group then return false end

    local abandon = group.AbandonButton
    local share = group.ShareButton
    local track = group.TrackButton
    if not abandon or not share or not track then return false end

    -- These three buttons share one fixed-width row. Expanding each button
    -- independently makes the Ukrainian Track label escape the quest panel.
    -- Keep the outside buttons pinned to the panel and let Share fill the gap.
    if type(_G.InCombatLockdown) == "function" and _G.InCombatLockdown()
        and (is_protected_frame(abandon) or is_protected_frame(share)
            or is_protected_frame(track)) then
        return true
    end

    local available_width = safe_dimension(group, "GetWidth")
    if available_width then
        available_width = available_width - left_inset - right_inset
    end
    if not available_width or available_width < QUEST_BUTTON_MIN_WIDTH * 3 then
        return true
    end

    local function desired_width(owner)
        local region = type(owner.GetFontString) == "function" and owner:GetFontString() or nil
        local text_width = unbounded_text_width(region)
        local current_width = safe_dimension(owner, "GetWidth")
        return math.max(QUEST_BUTTON_MIN_WIDTH,
            math.ceil((text_width or current_width or QUEST_BUTTON_MIN_WIDTH)
                + (text_width and QUEST_BUTTON_TEXT_PADDING or 0)))
    end

    local abandon_width = desired_width(abandon)
    local share_width = desired_width(share)
    local track_width = desired_width(track)
    local desired_total = abandon_width + share_width + track_width

    if desired_total > available_width then
        local share_target = math.min(share_width,
            available_width - QUEST_BUTTON_MIN_WIDTH * 2)
        local side_space = available_width - share_target
        local side_total = abandon_width + track_width

        abandon_width = math.floor(side_space * abandon_width / side_total + 0.5)
        abandon_width = math.max(QUEST_BUTTON_MIN_WIDTH,
            math.min(abandon_width, side_space - QUEST_BUTTON_MIN_WIDTH))
        track_width = side_space - abandon_width
    end

    pcall(abandon.SetWidth, abandon, abandon_width)
    pcall(track.SetWidth, track, track_width)

    pcall(abandon.ClearAllPoints, abandon)
    pcall(abandon.SetPoint, abandon, "BOTTOMLEFT", group, "BOTTOMLEFT",
        left_inset, bottom_offset)
    pcall(track.ClearAllPoints, track)
    pcall(track.SetPoint, track, "BOTTOMRIGHT", group, "BOTTOMRIGHT",
        -right_inset, bottom_offset)
    pcall(share.ClearAllPoints, share)
    pcall(share.SetPoint, share, "LEFT", abandon, "RIGHT", 0, 0)
    pcall(share.SetPoint, share, "RIGHT", track, "LEFT", 0, 0)
    return true
end

local function fit_button_to_text(button, region)
    if not is_button(button) or type(button.SetWidth) ~= "function" then return end
    -- Blizzard's Settings controls have fixed build-defined geometry. Their
    -- pooled dropdowns, buttons, steppers, and tabs must never inherit a width
    -- calculated from translated text.
    if is_descendant_of(button, _G.SettingsPanel, 12) then return end
    -- Page labels sit outside these arrow buttons. Widening the buttons to
    -- fit translated labels stretches the arrow artwork.
    if button == _G.MerchantPrevPageButton
        or button == _G.MerchantNextPageButton
        or button == (_G.InboxFrame and _G.InboxFrame.PrevPageButton)
        or button == (_G.InboxFrame and _G.InboxFrame.NextPageButton) then return end
    if fit_quest_map_button_group(button) then return end
    if type(_G.InCombatLockdown) == "function" and _G.InCombatLockdown()
        and is_protected_frame(button) then return end

    region = region or (type(button.GetFontString) == "function" and button:GetFontString())
    if fit_auction_tab(region) then return end
    local text_width = unbounded_text_width(region)
    local button_width = safe_dimension(button, "GetWidth")
    if not text_width or not button_width then return end

    local padding = type(button.fitTextWidthPadding) == "number"
        and button.fitTextWidthPadding or BUTTON_TEXT_PADDING
    local required_width = math.ceil(text_width + padding)
    if required_width > button_width then
        pcall(button.SetWidth, button, required_width)
        local parent = type(button.GetParent) == "function" and button:GetParent() or nil
        if parent and type(parent.MarkDirty) == "function" then
            pcall(parent.MarkDirty, parent)
        end
    end
end

-- The 70170 LFG tooltip only includes names and activities in its native
-- width calculation. Translated alerts, member counts and role columns can
-- extend past that width. Measure the completed display, then its new height.
layout.fit_lfg_tooltip = function (tooltip)
    if not tooltip or is_protected_frame(tooltip)
        or not runtime.can_write_text(tooltip)
        or type(tooltip.SetWidth) ~= "function"
        or type(tooltip.SetHeight) ~= "function" then return false end
    local left = safe_dimension(tooltip, "GetLeft")
    local width = safe_dimension(tooltip, "GetWidth")
    local height = safe_dimension(tooltip, "GetHeight")
    if not left or not width or not height then return false end
    local regions = {}
    local function add(region, wraps)
        if not region or type(region.IsShown) ~= "function" then return end
        local ok, shown = pcall(region.IsShown, region)
        if ok and not is_secret(shown) and shown then
            regions[#regions + 1] = { region = region, wraps = wraps }
        end
    end
    for _, key in ipairs({ "Delisted", "NewPlayerFriendlyIcon",
        "NewPlayerFriendlyText", "LeaderIcon", "MemberCount",
        "CompletedEncounterHeader", "VoiceChat" }) do add(tooltip[key]) end
    add(tooltip.Comment, true)
    local function add_member(member)
        if not member or type(member.IsShown) ~= "function" then return end
        local ok, shown = pcall(member.IsShown, member)
        if not ok or is_secret(shown) or not shown then return end
        add(member.Name)
        add(member.Level)
        for _, role in ipairs(member.Roles or {}) do add(role) end
    end
    add_member(tooltip.Leader)
    for _, key in ipairs({ "memberPool", "activityPool", "completedEncounterPool" }) do
        local pool = tooltip[key]
        if pool and type(pool.EnumerateActive) == "function" then
            for region in pool:EnumerateActive() do
                if key == "memberPool" then add_member(region) else add(region) end
            end
        end
    end
    for _, row in ipairs(regions) do
        if not row.wraps then
            local x = safe_dimension(row.region, "GetLeft")
            local text_width = unbounded_text_width(row.region)
                or safe_dimension(row.region, "GetWidth")
            if x and text_width then width = math.max(width, x - left + text_width + 11) end
        end
    end
    if not pcall(tooltip.SetWidth, tooltip, math.ceil(width)) then return false end
    -- Width can move a clamped tooltip and reflow Comment/anchored labels.
    local top = safe_dimension(tooltip, "GetTop")
    if not top then return false end
    for _, row in ipairs(regions) do
        local y = safe_dimension(row.region, "GetTop")
        local text_height = safe_dimension(row.region, "GetStringHeight")
            or safe_dimension(row.region, "GetHeight")
        if y and text_height then height = math.max(height, top - y + text_height + 11) end
    end
    return pcall(tooltip.SetHeight, tooltip, math.ceil(height))
end

layout.safe_dimension = safe_dimension
layout.is_button = is_button
layout.is_tooltip = is_tooltip
layout.fit_tooltip_height_to_region = fit_tooltip_height_to_region
layout.fit_tooltip_width_to_region = fit_tooltip_width_to_region
layout.restore_tooltip_width = restore_tooltip_width
layout.fit_aura_header_width = fit_aura_header_width
layout.fit_bag_tooltip_width = fit_bag_tooltip_width
layout.fit_tooltip_snapshot = fit_tooltip_snapshot
layout.fit_profession_recipe_label = fit_profession_recipe_label
layout.fit_profession_output_text = fit_profession_output_text
layout.fit_profession_requirement_text = fit_profession_requirement_text
layout.fit_auction_tab = fit_auction_tab
layout.fit_button_to_text = fit_button_to_text
