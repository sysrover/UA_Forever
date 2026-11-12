local _, addon_table = ...
local layout = addon_table.use("translation_layout")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local profiler = addon_table.use("performance_profile")
local profile_counts = {}
for _, name in ipairs({ "measure", "reapply", "success", "failure", "exception",
    "cache.empty", "cache.policy", "cache.signature", "cache.unreadable",
    "pass.skip", "build", "combat.defer", "write.attempt", "write.success", "write.failure",
    "read.string-width", "read.string-height" }) do
    profile_counts[name] = profiler.counter and profiler.counter("layout." .. name) or function () end
end

local count_layout_write = profiler.write_counter and profiler.write_counter("layout.write")
local function finish_layout_write(ok, ...)
    if count_layout_write then count_layout_write(ok)
    else profile_counts[ok and "write.success" or "write.failure"]() end
    return ok, ...
end

-- Count native setter attempts and successes without changing the protected
-- call, its return arity, or the existing layout boundaries.
local layout_write = pcall
local function profile_layout_write(callback, ...)
    if not count_layout_write then profile_counts["write.attempt"]() end
    return finish_layout_write(pcall(callback, ...))
end
if profiler.on_capture then
    profiler.on_capture("layout-writes", function (active)
        layout_write = active and profile_layout_write or pcall
    end)
end

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
local ITEM_LAYOUT_EPSILON = 0.5
local ITEM_RIGHT_TEXT_PADDING = 2
local TOOLTIP_SIDES = { "Left", "Right" }
local TOOLTIP_FRAME_READS = { "GetEffectiveScale" }
local TEXT_ROW_READS = { { "GetText", 1 }, { "GetFont", 3 }, { "GetWidth", 1 },
    { "GetEffectiveScale", 1 }, { "GetSpacing", 1, true },
    { "CanWordWrap", 1, true }, { "CanNonSpaceWrap", 1, true }, { "GetMaxLines", 1, true } }
local pending_tooltip_layout = setmetatable({}, { __mode = "k" })
local tooltip_row_anchors = setmetatable({}, { __mode = "k" })
local tooltip_row_content = setmetatable({}, { __mode = "k" })
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

-- Private callers supply dimensions already checked by safe_dimension or
-- the guarded point/getter reads below. Native anchoring rounds these floats.
local function same_dimension(first, second)
    return type(first) == "number" and type(second) == "number"
        and math.abs(first - second) <= ITEM_LAYOUT_EPSILON
end

layout.dimensions_match = function (first, second)
    if is_secret(first) or is_secret(second) then return false end
    return same_dimension(first, second)
end

local function is_protected_frame(frame)
    return strings.is_protected_frame and strings.is_protected_frame(frame)
end

-- Protect the member read and the getter in one pcall. A missing optional
-- method is distinct from an unreadable method or a getter returning nil.
local function read_method(object, method, guard_callback)
    local callback = object[method]
    if guard_callback and is_secret(callback) then return nil end
    if type(callback) ~= "function" then return false end
    return true, callback(object)
end

local function read_dimension(owner, method)
    if not owner then return nil end
    local ok, present, value = pcall(read_method, owner, method)
    -- On Camelot, tooltip measurements derived from aura data can themselves
    -- be secret numbers. Checking their Lua type is not sufficient: any
    -- comparison or arithmetic on such a value taints and raises an error.
    if not ok or not present or is_secret(value) or type(value) ~= "number" then return nil end
    if value >= 0 then return value end
end
local safe_dimension = read_dimension
local function profile_dimension(owner, method)
    if not profiler.active then return read_dimension(owner, method) end
    if owner then
        if method == "GetStringHeight" then profile_counts["read.string-height"]()
        elseif method == "GetUnboundedStringWidth" or method == "GetStringWidth" then
            profile_counts["read.string-width"]()
        end
    end
    return read_dimension(owner, method)
end
if profiler.on_capture then
    profiler.on_capture("layout-reads", function (active)
        local replacement = active and profile_dimension or read_dimension
        if layout.safe_dimension == safe_dimension then layout.safe_dimension = replacement end
        safe_dimension = replacement
    end)
end

local function unbounded_text_width(region)
    return safe_dimension(region, "GetUnboundedStringWidth")
        or safe_dimension(region, "GetStringWidth")
end

local function is_button(frame)
    if not frame then return false end
    local ok, present, object_type = pcall(read_method, frame, "GetObjectType")
    return ok and present and not is_secret(object_type) and object_type == "Button"
end

local function is_tooltip(frame)
    if not frame then return false end
    local ok, present, object_type = pcall(read_method, frame, "GetObjectType")
    return ok and present and not is_secret(object_type) and object_type == "GameTooltip"
end

local function object_name(owner)
    if not owner then return nil end
    local ok, present, name = pcall(read_method, owner, "GetName")
    return ok and present and not is_secret(name) and type(name) == "string" and name or nil
end

-- A reporter may retain its native row for scanning while showing a separate
-- translated label over it. Measure that visible label, not the hidden text.
layout.set_tooltip_row_content = function (tooltip, region, content)
    tooltip_row_content[region] = content and { tooltip = tooltip, content = content,
        generation = tooltip.uaForeverGeneration, instance = tooltip.uaForeverSessionKey } or nil
end

local function parent_of(owner)
    if not owner then return nil end
    local ok, present, parent = pcall(read_method, owner, "GetParent")
    return ok and present and not is_secret(parent) and parent or nil
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
    local ok, present, value = pcall(read_method, frame, "IsShown")
    return ok and present and not is_secret(value) and value == true
end

local function row_content(tooltip, region)
    local entry = tooltip_row_content[region]
    if entry and entry.tooltip == tooltip and entry.generation == tooltip.uaForeverGeneration
        and entry.instance == tooltip.uaForeverSessionKey and is_shown(entry.content) then
        return entry.content
    end
    return region
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
local fit_complete_tooltip
local function measure_complete_tooltip(tooltip, maximum_width, arrange_rows, prose_width, single_line_right)
    if not is_tooltip(tooltip) or not is_shown(tooltip) then return false, "tooltip.hidden-or-invalid" end
    local original = tooltip.uaForeverShowOriginal == true
    if original and not tooltip.uaForeverSessionKey then return false, "tooltip.session" end
    single_line_right = single_line_right or prose_width ~= nil
    if runtime.combat_locked() or not runtime.can_write_text(tooltip) then return false, "tooltip.not-writable" end
    local name = object_name(tooltip)
    local count = safe_dimension(tooltip, "NumLines")
    local width = safe_dimension(tooltip, "GetWidth")
    if not name or not count or not width then return false, "tooltip.metadata" end
    local rows, required_width, minimum_right_width = {}, width, 0
    for index = 1, count do
        local row = {}
        for _, side in ipairs(TOOLTIP_SIDES) do
            local region = _G[name .. "Text" .. side .. index]
            if region and is_shown(region) then
                local ok, text = pcall(region.GetText, region)
                if not ok or is_secret(text) then return false, "region.text-read" end
                local empty_text = text == nil or text == ""
                text = runtime.safe_string_or_nil(text)
                if empty_text then text = "" end
                -- Pooled right FontStrings may stay shown without text. They
                -- must not turn a prose row into a two-column layout or abort it.
                local empty_right = single_line_right and side == "Right"
                    and (not text or text:match("^%s*$") ~= nil)
                if not empty_right then
                    if not text or not runtime.can_write_text(region) then return false, "region.text-or-writable" end
                    row[side] = region
                    row[side .. "Content"] = row_content(tooltip, region)
                    row[side .. "Empty"] = text:match("^%s*$") ~= nil
                    if single_line_right and side == "Right" then
                        -- A pooled right label may already be squeezed/wrapped
                        -- by native layout. Measure it as one complete line,
                        -- then anchor its full width to the same right edge.
                        if type(region.SetWordWrap) == "function" then layout_write(region.SetWordWrap, region, false) end
                        if type(region.SetNonSpaceWrap) == "function" then layout_write(region.SetNonSpaceWrap, region, false) end
                        if type(region.SetWidth) == "function" then layout_write(region.SetWidth, region, 0) end
                    end
                end
            end
        end
        -- Once the frame is wide enough for the prose cap, another capped
        -- single-column row cannot increase its width. Only the title and
        -- paired columns still need an unbounded string-width measurement.
        if row.Left and (row.Right or not prose_width or index == 1
            or required_width < prose_width + TOOLTIP_TEXT_PADDING) then
            row.LeftWidth = unbounded_text_width(row.LeftContent) or 0
        end
        if row.Right then
            row.RightWidth = unbounded_text_width(row.RightContent) or 0
            if single_line_right then
                if row.RightWidth <= 0 then return false, "region.right-width" end
                row.RightWidth = math.ceil(row.RightWidth) + ITEM_RIGHT_TEXT_PADDING
                minimum_right_width = math.max(minimum_right_width,
                    row.RightWidth + TOOLTIP_TEXT_PADDING
                        + (row.Left and 12 + math.min(row.LeftWidth or 0, TOOLTIP_COMPACT_WIDTH) or 0))
            end
        end
        local left_width = row.LeftWidth or 0
        if prose_width and index > 1 and not row.Right then
            left_width = math.min(left_width, prose_width)
        end
        required_width = math.max(required_width,
            left_width + (row.RightWidth or 0)
                + TOOLTIP_TEXT_PADDING + (row.Right and 12 or 0))
        rows[#rows + 1] = row
    end
    local screen_width = safe_dimension(_G.UIParent, "GetWidth")
    local maximum = screen_width and math.min(maximum_width, screen_width - 32)
        or maximum_width
    if single_line_right and screen_width then
        maximum = math.min(screen_width - 32, math.max(maximum, minimum_right_width))
    end
    width = math.min(maximum, math.max(width, required_width))
    if width <= TOOLTIP_TEXT_PADDING
        or type(tooltip.SetWidth) ~= "function"
        or not layout_write(tooltip.SetWidth, tooltip, width) then return false, "tooltip.width" end
    local available = width - TOOLTIP_TEXT_PADDING
    for index, row in ipairs(rows) do
        local right_limit = single_line_right and math.max(1, available - (row.Left and 13 or 0))
            or available * 0.45
        local right_width = row.Right and math.min(row.RightWidth, right_limit) or 0
        for _, side in ipairs(TOOLTIP_SIDES) do
            local region = row[side]
            if region and row[side .. "Empty"] then
                -- Blank spacer rows have no string height. Preserve their
                -- native height instead of aborting the completed layout.
                row[side .. "Height"] = safe_dimension(region, "GetHeight") or 0
            elseif region then
                local text_width = side == "Right" and right_width
                    or available - right_width - (row.Right and 12 or 0)
                if prose_width and index > 1 and side == "Left" and not row.Right then
                    text_width = math.min(text_width, prose_width)
                end
                row[side .. "TargetWidth"] = math.max(1, text_width)
                local wraps = not (single_line_right and side == "Right"
                    and row.RightWidth <= right_limit)
                row[side .. "Wrap"] = wraps
                if type(region.SetWidth) == "function" then
                    layout_write(region.SetWidth, region, math.max(1, text_width))
                end
                if type(region.SetMaxLines) == "function" then layout_write(region.SetMaxLines, region, 0) end
                if type(region.SetWordWrap) == "function" then layout_write(region.SetWordWrap, region, wraps) end
                if type(region.SetNonSpaceWrap) == "function" then layout_write(region.SetNonSpaceWrap, region, wraps) end
                if type(region.SetHeight) == "function" then layout_write(region.SetHeight, region, 0) end
                local content = row[side .. "Content"]
                local height = safe_dimension(content, "GetStringHeight")
                if not height or height <= 0 then
                    return false, "region.string-height"
                end
                if content ~= region and not layout_write(region.SetHeight, region, height) then return false, "region.height-write" end
                -- Leave shared GameTooltip rows at automatic height so later
                -- item/quest tooltips cannot inherit this text's line count.
                row[side .. "Height"] = height
            end
        end
    end
    if arrange_rows then
        local originals = tooltip_row_anchors[tooltip]
        if not originals then originals = {}; tooltip_row_anchors[tooltip] = originals end
        local offset = TOOLTIP_TEXT_PADDING / 2
        for _, row in ipairs(rows) do
            row.Offset = offset
            local row_height = math.max(row.LeftHeight or 0, row.RightHeight or 0)
            for _, side in ipairs(TOOLTIP_SIDES) do
                local region = row[side]
                if region then
                    if not originals[region] then
                        local points = {}
                        local count = safe_dimension(region, "GetNumPoints")
                        if not count then return false, "region.points-count" end
                        for index = 1, count do
                            local ok, point, relative, relative_point, x, y = pcall(region.GetPoint, region, index)
                            if not ok or is_secret(point) or is_secret(relative) or is_secret(relative_point)
                                or is_secret(x) or is_secret(y) then return false, "region.point-read" end
                            points[#points + 1] = { point, relative, relative_point, x, y }
                        end
                        originals[region] = points
                    end
                    if not layout_write(region.ClearAllPoints, region) then return false, "region.point-clear" end
                    local point = side == "Right" and "TOPRIGHT" or "TOPLEFT"
                    local x = side == "Right" and -TOOLTIP_TEXT_PADDING / 2 or TOOLTIP_TEXT_PADDING / 2
                    if not layout_write(region.SetPoint, region, point, tooltip, point, x, -offset) then return false, "region.point-write" end
                end
            end
            offset = offset + row_height + 2
        end
        local height = math.ceil(offset + TOOLTIP_TEXT_PADDING / 2)
        local ok = layout_write(tooltip.SetHeight, tooltip, height)
        if not ok then return false, "tooltip.height" end
        if ok then
            for _, row in ipairs(rows) do
                for _, side in ipairs(TOOLTIP_SIDES) do
                    if row[side] then
                        row[side .. "FittedHeight"] = safe_dimension(row[side], "GetHeight")
                            or row[side .. "Height"]
                    end
                end
            end
        end
        return ok, { width = width, height = height, rows = rows }
    end
    local top = safe_dimension(tooltip, "GetTop")
    if not top then return false, "tooltip.top" end
    local height = 0
    for _, row in ipairs(rows) do
        for _, side in ipairs(TOOLTIP_SIDES) do
            if row[side] then
                local row_top = safe_dimension(row[side], "GetTop")
                if not row_top then return false, "region.top" end
                height = math.max(height, top - row_top + row[side .. "Height"])
            end
        end
    end
    if height <= 0 or type(tooltip.SetHeight) ~= "function" then return false, "tooltip.height" end
    height = math.ceil(height + TOOLTIP_TEXT_PADDING / 2)
    local ok = layout_write(tooltip.SetHeight, tooltip, height)
    if not ok then return false, "tooltip.height" end
    if ok then
        for _, row in ipairs(rows) do
            for _, side in ipairs(TOOLTIP_SIDES) do
                if row[side] then
                    row[side .. "FittedHeight"] = safe_dimension(row[side], "GetHeight")
                        or row[side .. "Height"]
                end
            end
        end
    end
    return ok, { width = width, height = height, rows = rows, arrange_rows = false }
end

layout.fit_talent_tooltip = function (tooltip)
    if not tooltip or tooltip.uaForeverKind ~= "talent" then return false end
    return fit_complete_tooltip(tooltip, 360, true)
end

-- Call only after an integration has established ownership of this tooltip.
layout.fit_addon_tooltip = function (tooltip)
    return fit_complete_tooltip(tooltip, 460, true, nil, true)
end

layout.fit_settings_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.SettingsTooltip then return false end
    return fit_complete_tooltip(tooltip, 420, true)
end

layout.restore_tooltip_rows = function (tooltip)
    tooltip.uaForeverItemLayout = nil
    tooltip.uaForeverOriginalItemLayout = nil
    tooltip.uaForeverTooltipLayout = nil
    tooltip.uaForeverOriginalTooltipLayout = nil
    tooltip.uaForeverTooltipLayoutPolicy = nil
    tooltip.uaForeverItemLayoutPass = nil
    tooltip.uaForeverItemBuildEpoch = nil
    pending_tooltip_layout[tooltip] = nil
    local originals = tooltip_row_anchors[tooltip]
    tooltip_row_anchors[tooltip] = nil
    if not originals or runtime.combat_locked() then return end
    for region, points in pairs(originals) do
        if runtime.can_write_text(region) then
            pcall(region.ClearAllPoints, region)
            for _, point in ipairs(points) do
                pcall(region.SetPoint, region, point[1], point[2], point[3], point[4], point[5])
            end
        end
    end
end

local function has_current_translation(tooltip, slot_prefix)
    if type(runtime.has_visible_translation) == "function" then
        return runtime.has_visible_translation(tooltip, tooltip.uaForeverGeneration, slot_prefix)
    end
    local translated = false
    runtime.for_each_claim(tooltip, function (region, claim)
        if claim.generation == tooltip.uaForeverGeneration and is_shown(region)
            and (not slot_prefix or type(claim.slot) == "string"
                and claim.slot:sub(1, #slot_prefix) == slot_prefix) then
            local ok, text = pcall(region.GetText, region)
            text = ok and runtime.safe_string_or_nil(text)
            if text and text ~= "" and text == claim.translated and text ~= claim.source then translated = true end
        end
    end)
    return translated
end

layout.fit_crafted_item_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip or tooltip.uaForeverKind ~= "spell"
        or not tooltip.uaForeverShowOriginal
            and not has_current_translation(tooltip, "item.crafted-effect:") then return false end
    return fit_complete_tooltip(tooltip, 420, true)
end

-- Cache measurements by content, not by the geometry Blizzard resets on every
-- native rebuild. Reapply the measured plan synchronously at the render boundary.
local missing_layout_value = {}
local function snapshot_value(snapshot, cursor, value, compare)
    value = value == nil and missing_layout_value or value
    if compare then
        if snapshot[cursor] == value then return snapshot, cursor + 1, true end
        -- Fork only on the first changed value. The matched prefix is already
        -- known; copy it without calling the native getters a second time.
        local previous = snapshot
        snapshot = {}
        for index = 1, cursor - 1 do snapshot[index] = previous[index] end
        compare = false
    end
    snapshot[cursor] = value
    return snapshot, cursor + 1, compare
end

local function snapshot_values(snapshot, cursor, object, method, count, optional, compare)
    -- These getters return one value, or the three GetFont values. Protect
    -- lookup + invocation together and keep the results in locals.
    local ok, present, first, second, third = pcall(read_method, object, method, true)
    if not ok or present == nil then return nil end
    if not present then
        if not optional then return nil end
        for _ = 1, count do
            snapshot, cursor, compare = snapshot_value(snapshot, cursor, nil, compare)
        end
        return snapshot, cursor, compare
    end
    if is_secret(first) then return nil end
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, first, compare)
    if count == 3 then
        if is_secret(second) or is_secret(third) then return nil end
        snapshot, cursor, compare = snapshot_value(snapshot, cursor, second, compare)
        snapshot, cursor, compare = snapshot_value(snapshot, cursor, third, compare)
    end
    return snapshot, cursor, compare
end

-- A read-only signature for ordinary UI rows. Reuse the previous table on a
-- hit; unreadable/secret inputs never enter a cache. Height is deliberately
-- checked by the owner separately, so a native size reset can replay the plan.
layout.text_signature = function (region, previous)
    if not region or is_secret(region) then return nil end
    local snapshot, cursor, compare = previous or {}, 1, previous ~= nil
    for _, read in ipairs(TEXT_ROW_READS) do
        snapshot, cursor, compare = snapshot_values(snapshot, cursor, region,
            read[1], read[2], read[3] == true, compare)
        if not snapshot then return nil end
    end
    return snapshot
end

local function tooltip_layout_snapshot(tooltip, previous, owner)
    local name = object_name(tooltip)
    local count = safe_dimension(tooltip, "NumLines")
    if not name or not count then return nil end
    local snapshot = previous or {}
    local compare = previous ~= nil
    local cursor
    snapshot, cursor, compare = snapshot_value(snapshot, 1, tooltip.uaForeverGeneration, compare)
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, tooltip.uaForeverSessionKey, compare)
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, tooltip.uaForeverKind, compare)
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, tooltip.uaForeverShowOriginal == true, compare)
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, count, compare)
    snapshot, cursor, compare = snapshot_value(snapshot, cursor, owner, compare)
    for _, method in ipairs(TOOLTIP_FRAME_READS) do
        snapshot, cursor, compare = snapshot_values(snapshot, cursor, tooltip, method, 1, false, compare)
        if not snapshot then return nil end
    end
    if _G.UIParent then
        snapshot, cursor, compare = snapshot_values(snapshot, cursor, _G.UIParent, "GetWidth", 1, false, compare)
        if not snapshot then return nil end
    end
    for index = 1, count do
        for _, side in ipairs(TOOLTIP_SIDES) do
            local region = _G[name .. "Text" .. side .. index]
            snapshot, cursor, compare = snapshot_value(snapshot, cursor, region, compare)
            if region then
                local shown_cursor = cursor
                snapshot, cursor, compare = snapshot_values(snapshot, cursor, region, "IsShown", 1, false, compare)
                if not snapshot then return nil end
                if snapshot[shown_cursor] == true then
                    snapshot, cursor, compare = snapshot_values(snapshot, cursor, region, "GetText", 1, false, compare)
                    if not snapshot then return nil end
                    snapshot, cursor, compare = snapshot_values(snapshot, cursor, region, "GetFont", 3, false, compare)
                    if not snapshot then return nil end
                    snapshot, cursor, compare = snapshot_values(snapshot, cursor, region, "GetSpacing", 1, true, compare)
                    if not snapshot then return nil end
                    local content = row_content(tooltip, region)
                    snapshot, cursor, compare = snapshot_value(snapshot, cursor, content, compare)
                    if content ~= region then
                        for _, read in ipairs({ { "GetText", 1 }, { "GetFont", 3 }, { "GetSpacing", 1 } }) do
                            snapshot, cursor, compare = snapshot_values(snapshot, cursor, content,
                                read[1], read[2], read[1] == "GetSpacing", compare)
                            if not snapshot then return nil end
                        end
                    end
                end
            end
        end
    end
    if compare and cursor - 1 ~= #previous then
        local trimmed = {}
        for index = 1, cursor - 1 do trimmed[index] = snapshot[index] end
        return trimmed
    end
    return snapshot
end

local function tooltip_layout_current(tooltip, generation, instance, owner, original, kind)
    if tooltip.uaForeverKind ~= kind or (tooltip.uaForeverShowOriginal == true) ~= original
        or tooltip.uaForeverGeneration ~= generation
        or tooltip.uaForeverSessionKey ~= instance or not is_shown(tooltip) then return false end
    local ok, current_owner = pcall(tooltip.GetOwner, tooltip)
    return ok and not is_secret(current_owner) and current_owner == owner
end

local function note_layout_write(counts, setter)
    if counts then counts[setter] = (counts[setter] or 0) + 1 end
end

local function set_layout_value(object, getter, setter, expected, writable, counts)
    local callback = object[getter]
    if type(callback) == "function" then
        local ok, current = pcall(callback, object)
        if not ok or is_secret(current) then return false, writable end
        if current == expected or same_dimension(current, expected) then return true, writable end
    end
    if writable == nil then writable = runtime.can_write_text(object) end
    if not writable then return false, writable end
    local callback = object[setter]
    if type(callback) ~= "function" then return true, writable end
    note_layout_write(counts, setter)
    local ok = layout_write(callback, object, expected)
    return ok, writable
end

local function apply_item_layout_impl(tooltip, plan, counts)
    local ok, tooltip_writable = set_layout_value(tooltip, "GetWidth", "SetWidth", plan.width, nil, counts)
    if not ok then return false, "tooltip.width" end
    for _, row in ipairs(plan.rows) do
        for _, side in ipairs(TOOLTIP_SIDES) do
            local region = row[side]
            if region then
                -- As in the full layout pass, check this region once for this
                -- synchronous batch, rather than walking its parents per setter.
                local writable
                local width = row[side .. "TargetWidth"]
                if width then
                    ok, writable = set_layout_value(region, "GetWidth", "SetWidth", width, writable, counts)
                    if not ok then return false, "region.width" end
                    ok, writable = set_layout_value(region, "GetMaxLines", "SetMaxLines", 0, writable, counts)
                    if not ok then return false, "region.max-lines" end
                    local wraps = row[side .. "Wrap"] ~= false
                    ok, writable = set_layout_value(region, "CanWordWrap", "SetWordWrap", wraps, writable, counts)
                    if not ok then return false, "region.word-wrap" end
                    ok, writable = set_layout_value(region, "CanNonSpaceWrap", "SetNonSpaceWrap", wraps, writable, counts)
                    if not ok then return false, "region.non-space-wrap" end
                    local height = safe_dimension(region, "GetHeight")
                    if not height then return false, "region.height-read" end
                    if not same_dimension(height, row[side .. "FittedHeight"]) then
                        if writable == nil then writable = runtime.can_write_text(region) end
                        local height = row[side .. "Content"] ~= region and row[side .. "Height"] or 0
                        if not writable then return false, "region.height-write" end
                        note_layout_write(counts, "SetHeight")
                        if not layout_write(region.SetHeight, region, height) then return false, "region.height-write" end
                    end
                end
                if plan.arrange_rows ~= false then
                    local expected_point = side == "Right" and "TOPRIGHT" or "TOPLEFT"
                    local expected_x = side == "Right" and -TOOLTIP_TEXT_PADDING / 2 or TOOLTIP_TEXT_PADDING / 2
                    local count = safe_dimension(region, "GetNumPoints")
                    if not count then return false, "region.points-count" end
                    local matches = false
                    if count == 1 then
                        local ok, point, relative, relative_point, x, y = pcall(region.GetPoint, region, 1)
                        if not ok or is_secret(point) or is_secret(relative) or is_secret(relative_point)
                            or is_secret(x) or is_secret(y) then return false, "region.point-read" end
                        matches = point == expected_point and relative == tooltip
                            and relative_point == expected_point
                            and same_dimension(x, expected_x) and same_dimension(y, -row.Offset)
                    end
                    if not matches then
                        if writable == nil then writable = runtime.can_write_text(region) end
                        if not writable then return false, "region.point-write" end
                        note_layout_write(counts, "ClearAllPoints")
                        if not layout_write(region.ClearAllPoints, region) then return false, "region.point-write" end
                        note_layout_write(counts, "SetPoint")
                        if not layout_write(region.SetPoint, region, expected_point, tooltip,
                            expected_point, expected_x, -row.Offset) then return false, "region.point-write" end
                    end
                end
            end
        end
    end
    ok = set_layout_value(tooltip, "GetHeight", "SetHeight", plan.height, tooltip_writable, counts)
    if not ok then return false, "tooltip.height" end
    return true
end

local function apply_item_layout(tooltip, plan)
    local counts = profiler.active and profiler.record_layout_writes and {} or nil
    local ok, detail = apply_item_layout_impl(tooltip, plan, counts)
    if counts then profiler.record_layout_writes(tooltip, counts) end
    return ok, detail
end

fit_complete_tooltip = function (tooltip, maximum_width, arrange_rows, prose_width, single_line_right)
    if not tooltip or tooltip.uaForeverItemLayoutApplying
        or not is_shown(tooltip) then return false end
    local original = tooltip.uaForeverShowOriginal == true
    if original and not tooltip.uaForeverSessionKey then return false end
    -- Every short right-hand field grows left from its native right edge.
    -- Original mode must never inherit a narrow translated column.
    single_line_right = single_line_right ~= false
    local generation, instance, kind = tooltip.uaForeverGeneration,
        tooltip.uaForeverSessionKey, tooltip.uaForeverKind
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or is_secret(owner) then return false end
    local policy = tooltip.uaForeverTooltipLayoutPolicy
    if not policy or policy.generation ~= generation or policy.instance ~= instance
        or policy.owner ~= owner or policy.kind ~= kind
        or policy.maximum_width ~= maximum_width or policy.arrange_rows ~= arrange_rows
        or policy.prose_width ~= prose_width or policy.single_line_right ~= single_line_right then
        policy = { generation = generation, instance = instance, owner = owner, kind = kind,
            maximum_width = maximum_width, arrange_rows = arrange_rows,
            prose_width = prose_width, single_line_right = single_line_right }
        tooltip.uaForeverTooltipLayoutPolicy = policy
    end
    if runtime.combat_locked() then
        if profiler.active then
            profile_counts["combat.defer"]()
            profiler.record_layout(tooltip, "defer", nil, "combat")
        end
        pending_tooltip_layout[tooltip] = function ()
            pending_tooltip_layout[tooltip] = nil
            if tooltip.uaForeverTooltipLayoutPolicy == policy
                and tooltip_layout_current(tooltip, generation, instance, owner, original, kind) then
                fit_complete_tooltip(tooltip, maximum_width, arrange_rows, prose_width, single_line_right)
            end
        end
        return false
    end
    pending_tooltip_layout[tooltip] = nil
    local profile_started = runtime.tooltip_profile_active and runtime.tooltip_profile_begin()
    local cache_key = kind == "item"
        and (original and "uaForeverOriginalItemLayout" or "uaForeverItemLayout")
        or (original and "uaForeverOriginalTooltipLayout" or "uaForeverTooltipLayout")
    local cached = tooltip[cache_key]
    local signature = tooltip_layout_snapshot(tooltip, cached and cached.signature, owner)
    local cache_valid = cached and signature ~= nil and signature == cached.signature
        and cached.policy == policy
    if profile_started then runtime.tooltip_profile_end("layout.cache", profile_started, tooltip) end
    tooltip.uaForeverItemLayoutApplying = true
    local ok, fitted, detail, cache_reason
    local stage_started, stage_overhead, text_writes_before, layout_writes_before
    if profiler.active then
        stage_started, stage_overhead, text_writes_before, layout_writes_before = profiler.begin_span()
    end
    profile_started = runtime.tooltip_profile_active and runtime.tooltip_profile_begin()
    if cache_valid then
        if profiler.active then profile_counts.reapply() end
        ok, fitted, detail = pcall(apply_item_layout, tooltip, cached.plan)
    else
        if profiler.active then
            profile_counts.measure()
            cache_reason = not signature and "cache.unreadable"
                or not cached and "cache.empty" or cached.policy ~= policy and "cache.policy"
                or "cache.signature"
            profile_counts[cache_reason]()
        end
        tooltip[cache_key] = nil
        local plan
        ok, fitted, plan = pcall(measure_complete_tooltip, tooltip,
            maximum_width, arrange_rows, prose_width, single_line_right)
        if ok and not fitted then detail = plan end
        if ok and fitted and signature and type(plan) == "table" then
            tooltip[cache_key] = { signature = signature, plan = plan, policy = policy }
        end
    end
    if profiler.active then
        profiler.record_layout(tooltip, cache_valid and "reapply" or "measure", ok and fitted == true,
            not ok and "exception" or not fitted and (detail or "incomplete-measurement") or cache_reason,
            profiler.elapsed_span(stage_started, stage_overhead), layout_writes_before)
        profile_counts[ok and fitted == true and "success" or "failure"]()
        if not ok then profile_counts.exception() end
    end
    if profile_started then
        local failure = not ok and runtime.safe_string_or_nil(fitted)
            or not fitted and (detail or "incomplete-measurement") or nil
        runtime.tooltip_profile_end(cache_valid and "layout.reapply" or "layout.measure",
            profile_started, tooltip, ok and fitted == true, failure)
    end
    tooltip.uaForeverItemLayoutApplying = nil
    return ok and fitted
end

layout.fit_item_tooltip = function (tooltip)
    if not tooltip or tooltip.uaForeverKind ~= "item"
        or tooltip.uaForeverItemLayoutApplying or not is_shown(tooltip) then return false end
    if not tooltip.uaForeverShowOriginal and not has_current_translation(tooltip) then return false end
    return fit_complete_tooltip(tooltip, 420, true, TOOLTIP_MAX_WIDTH)
end

layout.begin_item_build = function (tooltip)
    if profiler.active then
        profile_counts.build()
        profiler.record_layout(tooltip, "build")
    end
    tooltip.uaForeverItemBuildEpoch = (tooltip.uaForeverItemBuildEpoch or 0) + 1
    tooltip.uaForeverItemLayoutPass = nil
end

layout.invalidate_item_pass = function (tooltip)
    if tooltip then tooltip.uaForeverItemLayoutPass = nil end
end

-- Native setters, comparison anchoring and outer entry points can all report
-- the same completed build. Only the first needs content/font/row processing.
layout.fit_item_tooltip_once = function (tooltip, before_fit)
    if not tooltip or tooltip.uaForeverKind ~= "item"
        or not is_shown(tooltip) then return false end
    local original = tooltip.uaForeverShowOriginal == true
    if original and not tooltip.uaForeverSessionKey then return false end
    local count = safe_dimension(tooltip, "NumLines")
    local width = safe_dimension(tooltip, "GetWidth")
    local height = safe_dimension(tooltip, "GetHeight")
    local scale = safe_dimension(tooltip, "GetEffectiveScale")
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or is_secret(owner) then return false end
    local epoch = tooltip.uaForeverItemBuildEpoch or 0
    local previous = tooltip.uaForeverItemLayoutPass
    if previous and count and width and height and scale and previous.epoch == epoch
        and previous.generation == tooltip.uaForeverGeneration
        and previous.instance == tooltip.uaForeverSessionKey and previous.owner == owner
        and previous.original == original
        and previous.count == count and same_dimension(previous.width, width)
        and same_dimension(previous.height, height) and previous.scale == scale then
        if profiler.active then profile_counts["pass.skip"]() end
        if profiler.active then profiler.record_layout(tooltip, "skip", true, "same-pass") end
        return true
    end
    if runtime.tooltip_profile_active then
        local reason = not previous and "no-stamp"
            or previous.epoch ~= epoch and "build"
            or previous.generation ~= tooltip.uaForeverGeneration and "generation"
            or previous.instance ~= tooltip.uaForeverSessionKey and "session"
            or previous.owner ~= owner and "owner"
            or previous.original ~= original and "language"
            or previous.count ~= count and "lines"
            or not same_dimension(previous.width, width) and "width"
            or not same_dimension(previous.height, height) and "height"
            or previous.scale ~= scale and "scale" or "unknown"
        runtime.tooltip_profile_end("layout.pass." .. reason,
            runtime.tooltip_profile_begin(), tooltip, nil, {
                width = width, height = height, scale = scale, lines = count,
                previousWidth = previous and previous.width,
                previousHeight = previous and previous.height,
                previousScale = previous and previous.scale,
                previousLines = previous and previous.count,
            })
    end
    if before_fit and not original then before_fit(tooltip) end
    local fitted = layout.fit_item_tooltip(tooltip)
    if fitted and count and width and height and scale then
        width = safe_dimension(tooltip, "GetWidth")
        height = safe_dimension(tooltip, "GetHeight")
        if width and height then
            tooltip.uaForeverItemLayoutPass = {
                epoch = epoch, generation = tooltip.uaForeverGeneration,
                instance = tooltip.uaForeverSessionKey, owner = owner, count = count,
                original = original,
                width = width, height = height, scale = scale,
            }
        end
    end
    return fitted
end

layout.fit_quest_pin_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip or tooltip.uaForeverKind ~= "quest"
        or not tooltip.uaForeverShowOriginal and not has_current_translation(tooltip) then return false end
    -- Map pins rebuild native geometry while retaining their translated claims.
    -- Measure all current rows instead of reusing the first build's line deltas.
    return fit_complete_tooltip(tooltip, 460, true)
end

layout.fit_calendar_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip
        or not tooltip.uaForeverShowOriginal and not has_current_translation(tooltip) then return false end
    return fit_complete_tooltip(tooltip, 460, true)
end

layout.fit_micro_button_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip or tooltip.uaForeverKind ~= "micro-button"
        or not tooltip.uaForeverShowOriginal and not has_current_translation(tooltip) then return false end
    return fit_complete_tooltip(tooltip, 420, true)
end

-- Both native Show and a manual Shift refresh end at this same boundary.
-- Text mode chooses a bounded measurement plan; it never disables geometry.
layout.fit_current_tooltip = function (tooltip)
    if not tooltip or not tooltip.uaForeverSessionKey then return false end
    local kind = tooltip.uaForeverKind
    if tooltip.uaForeverAuraTooltip == true and kind ~= "aura" then return false end
    if kind == "item" then return layout.fit_item_tooltip(tooltip) end
    if not tooltip.uaForeverShowOriginal and not has_current_translation(tooltip) then return false end
    local policy = tooltip.uaForeverTooltipLayoutPolicy
    if policy and policy.generation == tooltip.uaForeverGeneration
        and policy.instance == tooltip.uaForeverSessionKey and policy.kind == kind then
        local ok, owner = pcall(tooltip.GetOwner, tooltip)
        if not ok or is_secret(owner) then return false end
        if owner == policy.owner then
            return fit_complete_tooltip(tooltip, policy.maximum_width, policy.arrange_rows,
                policy.prose_width, policy.single_line_right)
        end
    end
    if kind == "quest" and tooltip.uaForeverQuestPinOwner then
        return layout.fit_quest_pin_tooltip(tooltip)
    end
    if kind == "talent" then return layout.fit_talent_tooltip(tooltip) end
    return fit_complete_tooltip(tooltip, 420, true)
end

layout.fit_translated_tooltip = function (tooltip)
    if tooltip ~= _G.GameTooltip then return false end
    return layout.fit_current_tooltip(tooltip)
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
