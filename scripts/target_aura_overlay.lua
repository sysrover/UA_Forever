local _, addon_table = ...

local overlay = addon_table.use("target_aura_overlay")
local client_db = addon_table.use("spell_client_db")
local options = addon_table.use("options")
local scheduler = addon_table.use("translation_scheduler")
local renderer = addon_table.use("spell_template_renderer")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")

local SMALL_AURA_SIZE = 17
local LARGE_AURA_SIZE = 21
local ELEMENT_SPACING = 3
local LINE_SPACING = 3
local LINE_WIDTH = 122
local CONSTRAINED_LINE_WIDTH = 101
local MAX_BUFFS = 32
local MAX_DEBUFFS = 16
local TOOLTIP_MAX_WIDTH = 300
local TOOLTIP_PADDING = 12

local root
local tooltip
local buttons = {}
local tooltip_lines = {}
local aura_filters = setmetatable({}, { __mode = "k" })
local prepared = false
local dirty = false
local tooltip_button
local tooltip_elapsed = 0

local is_secret = runtime.is_secret_value
local safe_string = runtime.safe_string_or_nil

local function safe_number(value)
    if value == nil or is_secret(value) then return nil end
    if type(value) == "number" then return value end
    if type(value) == "string" then return tonumber(value) end
    return nil
end

local function safe_field(value, key)
    if not value or is_secret(value) then return nil end
    local ok, result = pcall(function () return value[key] end)
    if not ok or is_secret(result) then return nil end
    return result
end

local function safe_call(callback, ...)
    if type(callback) ~= "function" then return nil end
    local ok, result = pcall(callback, ...)
    if not ok or is_secret(result) then return nil end
    return result
end

local function color_components(color)
    if not color or is_secret(color) then return nil end
    local red = safe_number(safe_field(color, "r"))
    local green = safe_number(safe_field(color, "g"))
    local blue = safe_number(safe_field(color, "b"))
    local alpha = safe_number(safe_field(color, "a")) or 1
    if red and green and blue then return red, green, blue, alpha end
    local getter = safe_field(color, "GetRGBA")
    if type(getter) ~= "function" then return nil end
    local ok, r, g, b, a = pcall(getter, color)
    if not ok or is_secret(r) or is_secret(g) or is_secret(b)
        or is_secret(a) then return nil end
    return safe_number(r), safe_number(g), safe_number(b), safe_number(a) or 1
end

local function line_record(text, source)
    local record = { text = text }
    if source then
        record.line_type = safe_number(safe_field(source, "type"))
        local r, g, b, a = color_components(safe_field(source, "leftColor"))
        if r and g and b then record.color = { r, g, b, a } end
    end
    return record
end

local function shift_original()
    return options.account
        and options.account.shift_original_tooltip ~= false
        and type(IsShiftKeyDown) == "function"
        and safe_call(IsShiftKeyDown) == true
end

local function hide_tooltip()
    tooltip_button = nil
    if tooltip then tooltip:Hide() end
end

local function translate_service_segment(source)
    local visible = source
        :gsub("|[cC]%x%x%x%x%x%x%x%x", "")
        :gsub("|[rR]", "")
        :gsub("\194\160", " ")
        :gsub("\226\128\175", " ")
        :match("^%s*(.-)%s*$")
    local amount, unit = visible:match(
        "([%d%.,]+)%s+([A-Za-z]+)%s+remaining%f[%A]")
    local formatter = addon_table.forever_tooltip_ui
        and addon_table.forever_tooltip_ui.format
        and addon_table.forever_tooltip_ui.format.aura_time_remaining
    if amount and unit and type(formatter) == "function" then
        local translated = formatter(amount, unit)
        if translated then return translated end
    end
    return source
end

local function translate_service_line(source)
    local changed = false
    local translated = source:gsub("[^\r\n]+", function (segment)
        local result = translate_service_segment(segment)
        if result ~= segment then changed = true end
        return result
    end)
    if changed then return translated end
    return strings.find_ui_translation(source) or source
end

local function format_remaining_duration(aura)
    local expiration = safe_number(safe_field(aura, "expirationTime"))
    if not expiration or expiration <= 0 or type(GetTime) ~= "function" then
        return nil
    end
    local remaining = expiration - (safe_call(GetTime) or expiration)
    local time_mod = safe_number(safe_field(aura, "timeMod"))
    if time_mod and time_mod > 0 then remaining = remaining / time_mod end
    remaining = math.max(0, remaining)

    local amount, unit
    if remaining >= 129600 then
        amount, unit = math.floor(remaining / 86400), "days"
    elseif remaining >= 5400 then
        amount, unit = math.floor(remaining / 3600), "hours"
    elseif remaining >= 90 then
        amount, unit = math.floor(remaining / 60), "minutes"
    else
        amount, unit = math.floor(remaining), "seconds"
    end

    local formatter = addon_table.forever_tooltip_ui
        and addon_table.forever_tooltip_ui.format
        and addon_table.forever_tooltip_ui.format.aura_time_remaining
    return type(formatter) == "function"
        and formatter(tostring(amount), unit) or nil
end

local function tooltip_data(aura)
    if not C_TooltipInfo
        or type(C_TooltipInfo.GetUnitAuraByAuraInstanceID) ~= "function" then
        return nil
    end
    local aura_instance_id = safe_number(safe_field(aura, "auraInstanceID"))
    if not aura_instance_id then return nil end
    return safe_call(C_TooltipInfo.GetUnitAuraByAuraInstanceID,
        "target", aura_instance_id, aura_filters[aura])
end

local function collect_native_lines(aura)
    local data = tooltip_data(aura)
    local lines = data and safe_field(data, "lines")
    local result = {}
    if type(lines) == "table" and not is_secret(lines) then
        local count = safe_call(function () return #lines end) or 0
        for index = 1, count do
            local line = safe_field(lines, index)
            local source = line and safe_string(safe_field(line, "leftText"))
            if source and source ~= "" then
                result[#result + 1] = line_record(source, line)
            end
        end
    end
    if #result == 0 then
        local name = safe_string(safe_field(aura, "name"))
        if name then result[1] = line_record(name) end
    end
    return result
end

local function translated_lines(aura)
    local native = collect_native_lines(aura)
    if #native == 0 then return native end
    if shift_original() or not options.can_translate("translate_spell")
        or options.section_enabled and not options.section_enabled("auras") then
        return native
    end

    local spell_id = safe_number(safe_field(aura, "spellId"))
        or safe_number(safe_field(aura, "spellID"))
    if not spell_id then return native end

    local result = {}
    local translated_name = client_db.get_name(spell_id)
    result[1] = line_record((options.name_enabled and options.name_enabled({
        slot = "aura.name", category = "spell" })
        or not options.name_enabled and options.translate_name("spell"))
        and translated_name or native[1].text)
    result[1].color = native[1].color
    result[1].line_type = native[1].line_type

    local english_raw = client_db.get_english_aura_description(spell_id)
    local ukrainian_raw = client_db.get_aura_description(spell_id)
    local spell_description_type = Enum and Enum.TooltipDataLineType
        and Enum.TooltipDataLineType.SpellDescription
    local aura_caster_type = Enum and Enum.TooltipDataLineType
        and Enum.TooltipDataLineType.AuraCaster
    local duration_index
    for index = #native, 2, -1 do
        local entry = native[index]
        if entry.line_type ~= aura_caster_type
            and (index > 2 or entry.line_type ~= spell_description_type)
            and entry.text:find("%d") then
            duration_index = index
            break
        end
    end
    local translated_duration = duration_index
        and format_remaining_duration(aura) or nil
    for index = 2, #native do
        local source = native[index].text
        local translated
        if index == duration_index and translated_duration then
            translated = translated_duration
        elseif index == 2 and english_raw and ukrainian_raw then
            translated = renderer.render(
                spell_id, "aura", english_raw, ukrainian_raw, source)
        end
        local record = line_record(translate_service_line(translated or source))
        record.color = native[index].color
        record.line_type = native[index].line_type
        result[#result + 1] = record
    end

    if #native == 1 and ukrainian_raw
        and not ukrainian_raw:find("$", 1, true) then
        result[2] = line_record(ukrainian_raw)
    end

    if options.is_bilingual_tooltip() then
        result[#result + 1] = line_record(" ")
        for index = 1, #native do result[#result + 1] = native[index] end
    end
    return result
end

local function get_tooltip_line(index)
    if tooltip_lines[index] then return tooltip_lines[index] end
    local line = tooltip:CreateFontString(nil, "OVERLAY",
        index == 1 and "GameTooltipHeaderText" or "GameTooltipText")
    line:SetJustifyH("LEFT")
    line:SetJustifyV("TOP")
    line:SetWordWrap(true)
    tooltip_lines[index] = line
    return line
end

local function show_tooltip(button)
    local aura = button.uaForeverAura
    if not aura then return end
    local lines = translated_lines(aura)
    if #lines == 0 then return end
    tooltip_button = button

    tooltip:ClearAllPoints()
    local button_x = safe_call(button.GetCenter, button)
    local screen_x = safe_call(UIParent.GetCenter, UIParent)
    if button_x and screen_x and button_x > screen_x then
        tooltip:SetPoint("TOPRIGHT", button, "BOTTOMLEFT", -8, -4)
    else
        tooltip:SetPoint("TOPLEFT", button, "BOTTOMRIGHT", 8, -4)
    end

    local content_width = 1
    for index, value in ipairs(lines) do
        local line = get_tooltip_line(index)
        line:SetText(value.text)
        local color = value.color
        local r, g, b, a
        if color then
            r, g, b, a = color[1], color[2], color[3], color[4]
        else
            r, g, b, a = color_components(
                index == 1 and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR)
        end
        line:SetTextColor(r or 1, g or 1, b or 1, a or 1)
        line:Show()
        local natural_width = safe_call(line.GetUnboundedStringWidth, line)
            or safe_call(line.GetStringWidth, line) or 1
        content_width = math.max(content_width, natural_width)
    end
    content_width = math.min(content_width,
        TOOLTIP_MAX_WIDTH - TOOLTIP_PADDING * 2)

    local previous
    local height = TOOLTIP_PADDING * 2
    for index in ipairs(lines) do
        local line = get_tooltip_line(index)
        line:ClearAllPoints()
        line:SetWidth(content_width)
        if previous then
            line:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -2)
            height = height + 2
        else
            line:SetPoint("TOPLEFT", tooltip, "TOPLEFT",
                TOOLTIP_PADDING, -TOOLTIP_PADDING)
        end
        height = height + line:GetStringHeight()
        previous = line
    end
    for index = #lines + 1, #tooltip_lines do tooltip_lines[index]:Hide() end
    tooltip:SetSize(content_width + TOOLTIP_PADDING * 2, math.max(44, height))
    tooltip:Show()
end

local function create_button(index)
    local button = CreateFrame("Button", nil, root)
    button:SetFrameLevel(root:GetFrameLevel() + 1)
    button:EnableMouse(true)

    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetAllPoints()
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    button.cooldown = CreateFrame("Cooldown", nil, button,
        "CooldownFrameTemplate")
    button.cooldown:SetAllPoints()
    button.cooldown:SetDrawEdge(false)
    button.cooldown:SetHideCountdownNumbers(true)

    button.count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    button.count:SetPoint("BOTTOMRIGHT", 1, 0)

    button:SetScript("OnEnter", show_tooltip)
    button:SetScript("OnLeave", hide_tooltip)
    buttons[index] = button
    return button
end

local function is_player_aura(aura)
    local source = safe_string(safe_field(aura, "sourceUnit"))
    if not source then return false end
    local player_units = { "player", "vehicle", "pet" }
    for _, token in ipairs(player_units) do
        if safe_call(UnitIsUnit, source, token) == true
            or safe_call(UnitIsOwnerOrControllerOfUnit, token, source) == true then
            return true
        end
    end
    return false
end

local function include_buff(aura)
    if safe_field(aura, "isHelpful") ~= true then return false end
    if safe_field(aura, "isNameplateOnly") == true then return false end
    if C_GameRules and Enum and Enum.GameRule
        and Enum.GameRule.TargetFrameBuffsDisabled
        and safe_call(C_GameRules.IsGameRuleActive,
            Enum.GameRule.TargetFrameBuffsDisabled) == true then
        return false
    end
    return true
end

local function include_debuff(aura, friendly)
    if safe_field(aura, "isHarmful") ~= true then return false end
    if type(GetCVarBool) == "function"
        and safe_call(GetCVarBool, "noBuffDebuffFilterOnTarget") == true then
        return true
    end
    if safe_field(aura, "nameplateShowAll") == true then return true end
    if is_player_aura(aura) then return true end
    if safe_call(UnitIsUnit, "player", "target") == true then return true end
    local target_is_player = safe_call(UnitIsPlayer, "target") == true
    local target_is_pet = type(UnitIsOtherPlayersPet) == "function"
        and safe_call(UnitIsOtherPlayersPet, "target") == true
    if not target_is_player and not target_is_pet and not friendly
        and safe_field(aura, "isFromPlayerOrPlayerPet") == true then
        return false
    end
    return true
end

local function get_auras(filter, limit, predicate, friendly)
    if not C_UnitAuras or type(C_UnitAuras.GetUnitAuras) ~= "function" then
        return nil
    end
    local list = safe_call(C_UnitAuras.GetUnitAuras,
        "target", filter, limit)
    if type(list) ~= "table" or is_secret(list) then return nil end
    local count = safe_call(function () return #list end)
    if not count then return nil end
    local result = {}
    for index = 1, count do
        local aura = safe_field(list, index)
        local aura_instance_id = aura
            and safe_number(safe_field(aura, "auraInstanceID"))
        local spell_id = aura and (safe_number(safe_field(aura, "spellId"))
            or safe_number(safe_field(aura, "spellID")))
        local icon = aura and safe_field(aura, "icon")
        -- Never place a transparent mouse catcher over a native aura when the
        -- client has restricted any field required to reproduce that button.
        if aura and (not aura_instance_id or not spell_id or icon == nil) then
            return nil
        end
        if aura and predicate(aura, friendly) then
            aura_filters[aura] = filter
            result[#result + 1] = aura
        end
    end
    return result
end

local function set_button_aura(button, aura, size)
    button.uaForeverAura = aura
    button:SetSize(size, size)
    button.icon:SetTexture(safe_field(aura, "icon"))
    local applications = safe_number(safe_field(aura, "applications")) or 0
    button.count:SetText(applications > 1 and applications or "")

    local duration = safe_number(safe_field(aura, "duration"))
    local expiration = safe_number(safe_field(aura, "expirationTime"))
    if duration and expiration and duration > 0 and expiration > 0 then
        button.cooldown:SetCooldown(expiration - duration, duration)
        button.cooldown:Show()
    else
        button.cooldown:Hide()
    end
    button:Show()
end

local function target_of_target_shown()
    local target_frame = _G.TargetFrame
    if not target_frame then return false end
    if type(target_frame.IsTargetOfTargetShown) == "function" then
        return safe_call(target_frame.IsTargetOfTargetShown, target_frame) == true
    end
    local tot = safe_field(target_frame, "totFrame")
    return tot and safe_call(tot.IsShown, tot) == true or false
end

local function layout_group(auras, state)
    if #auras == 0 then return end
    if state.has_group then
        state.x = 0
        state.y = state.y + state.row_height + LINE_SPACING
        state.row_height = 0
        state.line = state.line + 1
    end
    state.has_group = true

    for _, aura in ipairs(auras) do
        local size = is_player_aura(aura) and LARGE_AURA_SIZE or SMALL_AURA_SIZE
        local width = state.line <= state.constrained_lines
            and CONSTRAINED_LINE_WIDTH or LINE_WIDTH
        if state.x > 0 and state.x + size > width then
            state.x = 0
            state.y = state.y + state.row_height + LINE_SPACING
            state.row_height = 0
            state.line = state.line + 1
        end

        state.button_index = state.button_index + 1
        local button = buttons[state.button_index]
            or create_button(state.button_index)
        button:ClearAllPoints()
        if state.mirrored then
            button:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT",
                state.x, state.y)
        else
            button:SetPoint("TOPLEFT", root, "TOPLEFT",
                state.x, -state.y)
        end
        set_button_aura(button, aura, size)
        state.x = state.x + size + ELEMENT_SPACING
        state.row_height = math.max(state.row_height, size)
    end
end

local function anchor_root()
    local target_frame = _G.TargetFrame
    if not target_frame then return false end
    local container = safe_field(target_frame, "TargetFrameContainer")
    local texture = container and safe_field(container, "FrameTexture")
    local anchor = texture or target_frame
    local mirrored = safe_field(target_frame, "buffsOnTop") == true
    root:ClearAllPoints()
    if mirrored then
        root:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 5, -6)
    else
        root:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 5, 9)
    end
    return mirrored
end

local function refresh()
    dirty = false
    hide_tooltip()
    if not root or (options.work_enabled and not options.work_enabled("target-auras"))
        or not options.can_translate("translate_spell")
        or safe_call(UnitExists, "target") ~= true
        or not _G.TargetFrame or safe_call(_G.TargetFrame.IsShown,
            _G.TargetFrame) ~= true then
        if root then root:Hide() end
        return
    end

    local friendly = safe_call(UnitIsFriend, "player", "target") == true
    local buffs = get_auras("HELPFUL", MAX_BUFFS, include_buff, friendly)
    local debuffs = get_auras("HARMFUL|INCLUDE_NAME_PLATE_ONLY",
        MAX_DEBUFFS, include_debuff, friendly)
    if not buffs or not debuffs then
        root:Hide()
        return
    end

    local mirrored = anchor_root()
    if mirrored == false and not _G.TargetFrame then return end
    root:Show()
    local state = {
        x = 0, y = 0, row_height = 0, line = 1,
        button_index = 0, has_group = false, mirrored = mirrored,
        constrained_lines = target_of_target_shown() and 2 or 0,
    }
    if friendly then
        layout_group(buffs, state)
        layout_group(debuffs, state)
    else
        layout_group(debuffs, state)
        layout_group(buffs, state)
    end
    for index = state.button_index + 1, #buttons do
        buttons[index].uaForeverAura = nil
        buttons[index]:Hide()
    end
end

local function mark_dirty()
    if options.work_enabled and not options.work_enabled("target-auras") then return end
    if dirty then return end
    dirty = true
    scheduler.request("target-auras", nil, refresh)
end

overlay.prepare = function ()
    if prepared then
        mark_dirty()
        return
    end
    prepared = true

    -- Target aura buttons and AuraButtonTooltip are forbidden in build 70058.
    -- Addon-owned buttons above them prevent the secure OnEnter from firing,
    -- while leaving Blizzard's protected frames completely untouched.
    root = CreateFrame("Frame", nil, UIParent)
    root:SetSize(150, 150)
    root:SetFrameStrata("HIGH")
    root:SetFrameLevel(900)
    root:Hide()

    tooltip = CreateFrame("Frame", nil, UIParent, "TooltipBackdropTemplate")
    tooltip:SetFrameStrata("TOOLTIP")
    tooltip:SetFrameLevel(2000)
    tooltip:SetClampedToScreen(true)
    tooltip:SetScript("OnUpdate", function (_, elapsed)
        tooltip_elapsed = tooltip_elapsed + elapsed
        if tooltip_elapsed < 0.2 then return end
        tooltip_elapsed = 0
        if tooltip_button and tooltip_button:IsMouseOver() then
            show_tooltip(tooltip_button)
        else
            hide_tooltip()
        end
    end)
    tooltip:Hide()

    local event_frame = CreateFrame("Frame")
    event_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    event_frame:RegisterEvent("UNIT_AURA")
    event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    event_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    event_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    event_frame:RegisterEvent("CVAR_UPDATE")
    event_frame:RegisterEvent("MODIFIER_STATE_CHANGED")
    event_frame:SetScript("OnEvent", function (_, event, unit)
        if event == "UNIT_AURA" and unit ~= "target" then return end
        if event == "MODIFIER_STATE_CHANGED" then
            if tooltip:IsShown() then
                for _, button in ipairs(buttons) do
                    if button:IsMouseOver() then show_tooltip(button) break end
                end
            end
            return
        end
        mark_dirty()
    end)
    local events = { "PLAYER_TARGET_CHANGED", "UNIT_AURA", "PLAYER_ENTERING_WORLD",
        "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "CVAR_UPDATE", "MODIFIER_STATE_CHANGED" }
    local function update_activity()
        local active = not options.work_enabled or options.work_enabled("target-auras")
        for _, event in ipairs(events) do
            if active then event_frame:RegisterEvent(event)
            else event_frame:UnregisterEvent(event) end
        end
        if active then mark_dirty()
        else dirty = false; hide_tooltip(); root:Hide() end
    end
    if options.on_activity_change then
        options.on_activity_change("target-aura-events", update_activity)
    end
    update_activity()
end
