local _, addon_table = ...
local layout = addon_table.use("translation_layout")
local strings = addon_table.use("strings")

local BUTTON_TEXT_PADDING = 24
local QUEST_BUTTON_TEXT_PADDING = 16
local QUEST_BUTTON_MIN_WIDTH = 64
local BAG_TOOLTIP_TEXT_PADDING = 24
local BAG_TOOLTIP_MAX_WIDTH = 420
local TOOLTIP_TEXT_PADDING = 24
local TOOLTIP_MAX_WIDTH = 300
local TOOLTIP_COMPACT_WIDTH = 180

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

local function fit_tooltip_width_to_region(tooltip, region)
    if not is_tooltip(tooltip) then return end
    local text_width = unbounded_text_width(region)
    local tooltip_width = safe_dimension(tooltip, "GetWidth")
    if not text_width or not tooltip_width or type(tooltip.SetWidth) ~= "function" then return end

    -- Long aura descriptions are meant to wrap at the client's chosen width.
    -- Only compact one-line tooltips need more room for a longer translation.
    if tooltip_width >= TOOLTIP_COMPACT_WIDTH then return end

    local required_width = math.min(TOOLTIP_MAX_WIDTH,
        math.ceil(text_width + TOOLTIP_TEXT_PADDING))
    if required_width > tooltip_width then
        pcall(tooltip.SetWidth, tooltip, required_width)
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

local function fit_quest_map_button_group(button)
    local quest_map = _G.QuestMapFrame
    local details = quest_map and (quest_map.DetailsFrame
        or (quest_map.QuestsFrame and quest_map.QuestsFrame.DetailsFrame))
    if not details then return false end

    local abandon = details.AbandonButton
    local share = details.ShareButton
    local track = details.TrackButton
    if not abandon or not share or not track
        or (button ~= abandon and button ~= share and button ~= track) then
        return false
    end

    -- These three buttons share one fixed-width row. Expanding each button
    -- independently makes the Ukrainian Track label escape the quest panel.
    -- Keep the outside buttons pinned to the panel and let Share fill the gap.
    if type(_G.InCombatLockdown) == "function" and _G.InCombatLockdown()
        and (is_protected_frame(abandon) or is_protected_frame(share)
            or is_protected_frame(track)) then
        return true
    end

    local available_width = safe_dimension(details, "GetWidth")
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
    pcall(abandon.SetPoint, abandon, "BOTTOMLEFT", details, "BOTTOMLEFT", 0, -2)
    pcall(track.ClearAllPoints, track)
    pcall(track.SetPoint, track, "BOTTOMRIGHT", details, "BOTTOMRIGHT", 0, -2)
    pcall(share.ClearAllPoints, share)
    pcall(share.SetPoint, share, "LEFT", abandon, "RIGHT", 0, 0)
    pcall(share.SetPoint, share, "RIGHT", track, "LEFT", 0, 0)
    return true
end

local function fit_button_to_text(button, region)
    if not is_button(button) or type(button.SetWidth) ~= "function" then return end
    if fit_quest_map_button_group(button) then return end
    if type(_G.InCombatLockdown) == "function" and _G.InCombatLockdown()
        and is_protected_frame(button) then return end

    region = region or (type(button.GetFontString) == "function" and button:GetFontString())
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

layout.safe_dimension = safe_dimension
layout.is_button = is_button
layout.is_tooltip = is_tooltip
layout.fit_tooltip_height_to_region = fit_tooltip_height_to_region
layout.fit_tooltip_width_to_region = fit_tooltip_width_to_region
layout.fit_aura_header_width = fit_aura_header_width
layout.fit_bag_tooltip_width = fit_bag_tooltip_width
layout.fit_button_to_text = fit_button_to_text
