local _, addon_table = ...
local calendar = addon_table.use("calendar_ui")
local ui = addon_table.use("panel_ui_adapter").bind("calendar-ui")
ui.verified_build = "1.60.1.70840"
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local layout = addon_table.use("translation_layout")
local options = addon_table.use("options")
local words = assert(addon_table.forever_calendar_ui)
local day_heights, week_heights = {}, {}
local pending_days = {}
local native_day_heights = setmetatable({}, { __mode = "k" })
local native_frame_height

local function number(value)
    if not runtime.is_secret_value(value) and type(value) == "number" then return value end
end

local function call(method, ...)
    local api = _G.C_Calendar
    if not api or type(api[method]) ~= "function" then return end
    local ok, value = pcall(api[method], ...)
    if ok and not runtime.is_secret_value(value) then return value end
end

local function native_text(region)
    local text = ui.text(region)
    local claim = region and runtime.get(region)
    if claim and text == claim.translated then return claim.source end
    return text
end

local function public_event(event)
    if type(event) ~= "table" then return false end
    local kind = runtime.safe_string_or_nil(event.calendarType)
    return kind == "HOLIDAY" or kind == "SYSTEM" or kind == "RAID_LOCKOUT" or kind == "RAID_RESET"
end

local function event_title(event)
    local title = runtime.safe_string_or_nil(event and event.title)
    if not title then return end
    return runtime.safe_string_or_nil(_G[title]) or title
end

local function translated_event(source, event, tooltip)
    if not source or not public_event(event) then return end
    local title = event_title(event)
    local translated = title and resolver.find_ui(title)
    if not translated then return resolver.find_ui(source) end
    if source == title then return translated end
    local kind, sequence = event.calendarType, event.sequenceType
    local key = kind == "RAID_LOCKOUT" and "CALENDAR_EVENTNAME_FORMAT_RAID_LOCKOUT"
        or kind == "RAID_RESET" and "CALENDAR_EVENTNAME_FORMAT_RAID_RESET"
        or tooltip and sequence == "START" and "CALENDAR_EVENTNAME_FORMAT_START"
        or tooltip and sequence == "END" and "CALENDAR_EVENTNAME_FORMAT_END"
    local template = key and runtime.safe_string_or_nil(_G[key])
    if template then
        local ok, native = pcall(string.format, template, title)
        if ok and native == source then
            local formatted, result = pcall(string.format, resolver.find_ui(template) or template, translated)
            if formatted then return result end
        end
    end
    return resolver.find_ui(source)
end

local function fit_week(index)
    local frame = _G.CalendarFrame
    if not frame or runtime.combat_locked() or not runtime.can_write_text(frame) then return end
    native_frame_height = native_frame_height or layout.safe_dimension(frame, "GetHeight")
    if not native_frame_height then return end
    local week = math.floor((index - 1) / 7) + 1
    local first, height = (week - 1) * 7 + 1, 0
    for day_index = first, first + 6 do
        local day = _G["CalendarDayButton" .. day_index]
        if day then
            native_day_heights[day] = native_day_heights[day] or layout.safe_dimension(day, "GetHeight")
            height = math.max(height, native_day_heights[day] or 0, day_heights[day_index] or 0)
        end
    end
    week_heights[week] = height
    for day_index = first, first + 6 do
        local day = _G["CalendarDayButton" .. day_index]
        local current = day and layout.safe_dimension(day, "GetHeight")
        if current and math.abs(current - height) > 0.5 and runtime.can_write_text(day) then
            pcall(day.SetHeight, day, height)
        end
        local background = _G["CalendarDayButton" .. day_index .. "EventBackgroundTexture"]
        local first_event = day and day.firstEventButton
        local top = day and layout.safe_dimension(day, "GetTop")
        local event_top = first_event and layout.safe_dimension(first_event, "GetTop")
        if background and top and event_top and runtime.can_write_text(background) then
            -- The native 40px caption backdrop can cross the top of a cell
            -- once its caption wraps. Keep it within the same day's border.
            pcall(background.SetPoint, background, "TOP", first_event, "TOP", 0,
                math.max(0, math.min(40, top - event_top)))
        end
    end
    local extra = 0
    for row, row_height in pairs(week_heights) do
        local day = _G["CalendarDayButton" .. ((row - 1) * 7 + 1)]
        extra = extra + row_height - (native_day_heights[day] or row_height)
    end
    local target = native_frame_height + extra
    local current = layout.safe_dimension(frame, "GetHeight")
    if current and math.abs(current - target) > 0.5 then pcall(frame.SetHeight, frame, target) end
end

local function fit_day(index)
    if runtime.combat_locked() then pending_days[index] = true; return end
    if not options.section_enabled("social_ui") then return end
    pending_days[index] = nil
    local needed = 24 -- Keep event captions below the day number.
    for slot = 1, 4 do
        local name = "CalendarDayButton" .. index .. "EventButton" .. slot
        local button, label, time = _G[name], _G[name .. "Text1"], _G[name .. "Text2"]
        local ok, shown = false, false
        if button then ok, shown = pcall(button.IsShown, button) end
        if ok and not runtime.is_secret_value(shown) and shown and label
            and runtime.can_write_text(button) and runtime.can_write_text(label) then
            local width = layout.safe_dimension(button, "GetWidth")
            local time_ok, time_shown = false, false
            if time then time_ok, time_shown = pcall(time.IsShown, time) end
            local has_time = time_ok and not runtime.is_secret_value(time_shown) and time_shown
            local align_ok, align = false, nil
            if time then align_ok, align = pcall(time.GetJustifyH, time) end
            align = align_ok and runtime.safe_string_or_nil(align)
            local inline = has_time and align == "RIGHT"
            local time_width = has_time and layout.safe_dimension(time, "GetStringWidth") or 0
            if width and width > 8 and (not time or runtime.can_write_text(time)) then
                local available = width - (inline and time_width + 4 or 0)
                pcall(label.ClearAllPoints, label)
                pcall(label.SetPoint, label, "TOPLEFT", button, "TOPLEFT", 0, 0)
                pcall(label.SetWidth, label, math.max(1, available))
                pcall(label.SetMaxLines, label, 0)
                pcall(label.SetWordWrap, label, true)
                pcall(label.SetNonSpaceWrap, label, true)
                pcall(label.SetHeight, label, 0)
                local height = layout.safe_dimension(label, "GetStringHeight")
                if height then
                    if has_time then
                        pcall(time.ClearAllPoints, time)
                        pcall(time.SetPoint, time, inline and "TOPRIGHT" or "BOTTOMLEFT",
                            button, inline and "TOPRIGHT" or "BOTTOMLEFT", 0, 0)
                        pcall(time.SetWidth, time, time_width)
                        local time_height = layout.safe_dimension(time, "GetStringHeight") or 0
                        height = inline and math.max(height, time_height) or height + time_height + 2
                    end
                    height = math.max(12, math.ceil(height + 2))
                    pcall(button.SetHeight, button, height)
                    needed = needed + height + 2
                end
            end
        end
    end
    day_heights[index] = needed
    fit_week(index)
end

local function day_events(index)
    index = number(index)
    local day = index and _G["CalendarDayButton" .. index]
    if not day or not number(day.day) or not number(day.monthOffset) then return end
    -- The exact build creates four pooled event buttons for each of 42 days.
    for slot = 1, 4 do
        local name = "CalendarDayButton" .. index .. "EventButton" .. slot
        local button = _G[name]
        local event_index = button and number(button.eventIndex)
        local event = event_index and call("GetDayEvent", day.monthOffset, day.day, event_index)
        if public_event(event) then
            local label = _G[name .. "Text1"]
            local source = native_text(label)
            local translated = translated_event(source, event, false)
            if translated then ui.apply(label, translated, "calendar.event") end
        elseif button then
            runtime.invalidate(_G[name .. "Text1"])
        end
        local time = _G[name .. "Text2"]
        local source = native_text(time)
        local translated = source and words.time(source)
        if translated then ui.apply(time, translated, "calendar.time") end
    end
    fit_day(index)
end

local function refresh()
    ui.watch(_G.CalendarMonthName)
    for index = 1, 7 do ui.watch(_G["CalendarWeekday" .. index .. "Name"]) end
    local frame = _G.CalendarFrame
    ui.button(frame and frame.FilterButton)
    -- DropdownTextMixin owns Text; this frame has no Button:GetFontString().
    ui.watch(frame and frame.FilterButton and frame.FilterButton.Text)
    if frame and not runtime.combat_locked() then
        local ok, shown = pcall(frame.IsShown, frame)
        if ok and not runtime.is_secret_value(shown) and shown then
            for index in pairs(pending_days) do fit_day(index) end
        end
    end
end

-- Own these tooltips before the generic UI pass: player-created event names
-- must not be translated even when their text happens to match a UI key.
calendar.translate_tooltip = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip or type(tooltip.GetOwner) ~= "function" then return false end
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not ok or runtime.is_secret_value(owner) or not owner then return false end
    if owner == _G.GameTimeFrame then
        if options.work_enabled("calendar-ui") then
            ui.tooltip(owner)
            layout.fit_calendar_tooltip(tooltip)
        end
        return true
    end
    local name_ok, name = pcall(owner.GetName, owner)
    name = name_ok and runtime.safe_string_or_nil(name)
    if not name or not name:match("^CalendarDayButton%d+$") then return false end
    if not options.work_enabled("calendar-ui") or tooltip.uaForeverShowOriginal then return true end
    local day, offset = number(owner.day), number(owner.monthOffset)
    if not day or not offset then return true end
    local month = call("GetMonthInfo", offset)
    if type(month) == "table" and number(month.firstWeekday) and number(month.month) and number(month.year) then
        local weekday = (month.firstWeekday + day - 2) % 7 + 1
        local date = words.date(weekday, month.month, day, month.year)
        if date then ui.apply(_G.GameTooltipTextLeft1, date, "calendar.date", nil, nil, tooltip) end
    end
    local events, player_titles = {}, {}
    local count = number(call("GetNumDayEvents", offset, day)) or 0
    for index = 1, math.min(count, 100) do
        local event = call("GetDayEvent", offset, day, index)
        if type(event) == "table" then
            if public_event(event) then events[#events + 1] = event
            else
                local title = event_title(event)
                if title then player_titles[title] = true end
            end
        end
    end
    local lines_ok, lines = pcall(tooltip.NumLines, tooltip)
    lines = lines_ok and number(lines) or 0
    for index = 2, math.min(lines, 100) do
        local left = _G["GameTooltipTextLeft" .. index]
        local source = native_text(left)
        if source and not player_titles[source] then
            local translated
            for _, event in ipairs(events) do
                translated = translated_event(source, event, true)
                if translated then break end
            end
            translated = translated or resolver.find_ui(source, left)
            if translated then ui.apply(left, translated, "calendar.event", nil, nil, tooltip) end
        end
        local right = _G["GameTooltipTextRight" .. index]
        source = native_text(right)
        local translated = source and words.time(source)
        if translated then ui.apply(right, translated, "calendar.time", nil, nil, tooltip) end
    end
    layout.fit_calendar_tooltip(tooltip)
    return true
end

calendar.prepare = function ()
    ui.prepare({ "CalendarFrame" }, "Blizzard_Calendar",
        { "CalendarFrame_Update", "CalendarFrame_UpdateTitle" }, {}, refresh)
    ui.hooks.global("CalendarFrame_UpdateDayEvents", day_events)
    ui.hooks.global("CalendarDayButton_OnEnter", function () calendar.translate_tooltip(_G.GameTooltip) end)
    -- GameTime's native OnUpdate clears/rebuilds its tooltip every frame.
    ui.hooks.region_script(_G.GameTimeFrame, "OnUpdate", function () calendar.translate_tooltip(_G.GameTooltip) end)
    local frame = _G.CalendarFrame
    if frame then
        local ok, shown = pcall(frame.IsShown, frame)
        if ok and not runtime.is_secret_value(shown) and shown then
            for index = 1, 42 do day_events(index) end
        end
    end
end
