local _, addon_table = ...

local entries = addon_table.use("entries")
local fonts = addon_table.use("fonts")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local debug_name
local rebound_regions = setmetatable({}, { __mode = "k" })
local rebound_writes = setmetatable({}, { __mode = "k" })

local BUTTON_TEXT_PADDING = 24
local QUEST_BUTTON_TEXT_PADDING = 16
local QUEST_BUTTON_MIN_WIDTH = 64
local BAG_TOOLTIP_TEXT_PADDING = 24
local BAG_TOOLTIP_MAX_WIDTH = 420

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
end

local function is_protected_frame(frame)
    if not frame then return false end
    for _, method in ipairs({ "IsForbidden", "IsProtected" }) do
        local ok_method, callback = pcall(function () return frame[method] end)
        if ok_method and type(callback) == "function" then
            local ok, result = pcall(callback, frame)
            if ok and result then return true end
        end
    end

    local name = debug_name and debug_name(frame) or ""
    for _, marker in ipairs({
        "PlayerFrame", "TargetFrame", "FocusFrame", "PetFrame", "PartyFrame",
        "Compact", "NamePlate", "BossFrame", "Arena", "RaidFrame",
        "BuffFrame", "DebuffFrame", "AuraFrame",
    }) do
        if name:find(marker, 1, true) then return true end
    end
    return false
end

local function normalize_text(text)
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function safe_dimension(owner, method)
    if not owner or type(owner[method]) ~= "function" then return nil end
    local ok, value = pcall(owner[method], owner)
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
    if not frame or type(frame.GetObjectType) ~= "function" then return false end
    local ok, object_type = pcall(frame.GetObjectType, frame)
    return ok and object_type == "Button"
end

local function is_tooltip(frame)
    if not frame or type(frame.GetObjectType) ~= "function" then return false end
    local ok, object_type = pcall(frame.GetObjectType, frame)
    return ok and object_type == "GameTooltip"
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

strings.fit_button_to_text = fit_button_to_text

local function find_context_translation(normalized, region)
    if not region or not addon_table.forever_ui_context then return nil end
    local frame_name = debug_name(region)
    for _, rule in ipairs(addon_table.forever_ui_context) do
        if rule.text == normalized and frame_name:find(rule.frame, 1, true) then
            return rule.translation
        end
    end
end

local function find_domain_translation(normalized, region)
    if not region or type(entries.get_glossary_text) ~= "function" then return nil end
    local frame_name = debug_name(region)
    for _, marker in ipairs({
        "Merchant", "QuestInfoItem", "QuestInfoRewards",
        "Professions", "TradeSkill", "CraftFrame",
    }) do
        if frame_name:find(marker, 1, true) then
            return entries.get_glossary_text(normalized, nil)
        end
    end
end

local function find_translation(text, region)
    local normalized = normalize_text(text)
    local translated = find_context_translation(normalized, region)
    if not translated and addon_table.string then
        translated = addon_table.string[text] or addon_table.string[normalized]
    end
    if not translated and addon_table.forever_ui then
        translated = addon_table.forever_ui[text] or addon_table.forever_ui[normalized]
    end
    if not translated then
        for _, item in ipairs(addon_table.forever_ui_patterns or {}) do
            -- Try the original value first so a replacement can retain WoW
            -- hyperlinks and colour codes. Plain patterns still fall back to
            -- the normalized text used by scanned UI strings.
            local captures = { text:match(item.pattern) }
            if #captures == 0 and normalized ~= text then
                captures = { normalized:match(item.pattern) }
            end
            if #captures > 0 then
                translated = item.replace(unpack(captures))
                break
            end
        end
    end
    if not translated then translated = find_domain_translation(normalized, region) end
    return translated, normalized
end

strings.find_ui_translation = function (text, region)
    if type(text) ~= "string" or is_secret(text) then return nil end
    return find_translation(text, region)
end

local function translate_font_string(region)
    if not region or not region.GetText or not region.SetText then return false end

    local ok, text = pcall(region.GetText, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return false end
    if text == "" then return false end

    local translated = find_translation(text, region)
    if not translated or translated == text then return false end

    local parent
    if type(region.GetParent) == "function" then
        local ok_parent, value = pcall(region.GetParent, region)
        if ok_parent then parent = value end
    end
    if parent and is_tooltip(parent) and options.is_bilingual_tooltip() then
        local key = text .. "\031" .. translated
        parent.uaForeverBilingualLines = parent.uaForeverBilingualLines or {}
        if parent.uaForeverBilingualLines[key] then return true end

        local r, g, b = 1, 1, 1
        if type(region.GetTextColor) == "function" then
            local ok_color, red, green, blue = pcall(region.GetTextColor, region)
            if ok_color and not is_secret(red) and not is_secret(green) and not is_secret(blue)
                and type(red) == "number" and type(green) == "number" and type(blue) == "number" then
                r, g, b = red, green, blue
            end
        end
        local add_ok = pcall(parent.AddLine, parent, translated, r, g, b, true)
        if add_ok then parent.uaForeverBilingualLines[key] = true end
        return add_ok
    end

    -- Apply the Cyrillic font while the English text can still report its
    -- actual rendered height (GameMenuFrame otherwise becomes blank).
    fonts.apply_to_font_string(region)
    local previous_height = parent and is_tooltip(parent)
        and (safe_dimension(region, "GetStringHeight") or safe_dimension(region, "GetHeight")) or nil
    local previous_tooltip_height = previous_height and safe_dimension(parent, "GetHeight") or nil
    local set_ok = pcall(region.SetText, region, translated)
    if set_ok then
        fit_tooltip_height_to_region(parent, region, previous_height, previous_tooltip_height)
    end
    if set_ok and parent and is_button(parent) then
        fit_button_to_text(parent, region)
    end
    return set_ok
end

strings.translate_region = translate_font_string

strings.set_region_text = function (region, text, tooltip, source)
    if not region or not region.SetText or type(text) ~= "string" or is_secret(text) then
        return false
    end
    fonts.apply_to_font_string(region)
    local previous_height = tooltip and is_tooltip(tooltip)
        and (safe_dimension(region, "GetStringHeight") or safe_dimension(region, "GetHeight")) or nil
    local previous_tooltip_height = previous_height and safe_dimension(tooltip, "GetHeight") or nil
    rebound_writes[region] = true
    local ok = pcall(region.SetText, region, text)
    rebound_writes[region] = nil
    if ok then
        fit_tooltip_height_to_region(tooltip, region, previous_height, previous_tooltip_height)
        fit_bag_tooltip_width(tooltip, region, source)
    end
    return ok
end

local function apply_ukrainian_font(region)
    if not region or not region.GetText then return end
    local ok, text = pcall(region.GetText, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return end
    if text:find("\208", 1, true) or text:find("\209", 1, true) then
        fonts.apply_to_font_string(region)
    end
end

debug_name = function (region)
    if region.GetDebugName then
        local ok, name = pcall(region.GetDebugName, region)
        if ok and type(name) == "string" and not is_secret(name) and name ~= "" then return name end
    end
    if region.GetParent then
        local ok, parent = pcall(region.GetParent, region)
        if ok and parent and parent.GetDebugName then
            local name_ok, name = pcall(parent.GetDebugName, parent)
            if name_ok and type(name) == "string" and not is_secret(name) and name ~= "" then
                return name .. "::<FontString>"
            end
        end
    end
    return "<anonymous FontString>"
end

local function is_capture_noise(normalized, frame_name)
    return normalized:find("^/uaf")
        or normalized:find("UA Forever:", 1, true)
        or frame_name:find("GameTooltip", 1, true)
        or frame_name:find("PlayerName", 1, true)
        or frame_name:find("CharacterFrameTitleText", 1, true)
        or frame_name:find("MainStatusTrackingBar", 1, true)
        or frame_name:find("CharacterLevelText", 1, true)
        or frame_name:find(".FontStringContainer", 1, true)
        or frame_name:find("EditBox", 1, true)
end

local function capture_font_string(region, stats)
    if not region or not region.GetText then return end
    local ok, text = pcall(region.GetText, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return end

    local translated, normalized = find_translation(text, region)
    if translated or normalized == "" or normalized == "EN" or normalized == "UA"
        or not normalized:find("[A-Za-z]") then return end

    local frame_name = debug_name(region)
    if is_capture_noise(normalized, frame_name) then return end

    if #normalized > 1000 then normalized = normalized:sub(1, 1000) end
    local scan = UA_ForeverDB and UA_ForeverDB.scan
    if not scan then return end
    scan.ui = scan.ui or {}

    local record = scan.ui[normalized]
    if not record then
        record = { count = 0, frames = {} }
        scan.ui[normalized] = record
        stats.new = stats.new + 1
    end
    record.count = (record.count or 0) + 1
    record.frames = record.frames or {}
    if #record.frames < 8 then
        local exists = false
        for _, value in ipairs(record.frames) do
            if value == frame_name then exists = true break end
        end
        if not exists then record.frames[#record.frames + 1] = frame_name end
    end
    stats.captured = stats.captured + 1
end

local function capture_frame(frame, seen, depth, stats, allow_protected)
    if not frame or seen[frame] or depth > 20
        or (not allow_protected and is_protected_frame(frame)) then return end
    seen[frame] = true
    stats.frames = stats.frames + 1

    if frame.GetRegions then
        local ok, regions = pcall(function () return { frame:GetRegions() } end)
        if ok then
            for _, region in ipairs(regions) do capture_font_string(region, stats) end
        end
    end
    if frame.GetChildren then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                local shown_ok, shown = pcall(child.IsShown, child)
                if shown_ok and shown then
                    capture_frame(child, seen, depth + 1, stats, allow_protected)
                end
            end
        end
    end
end

local function bind_font_string(region)
    if rebound_regions[region] or not region or type(_G.hooksecurefunc) ~= "function"
        or not region.GetText or not region.SetText or is_protected_frame(region) then return end

    local ok = pcall(hooksecurefunc, region, "SetText", function (self)
        if rebound_writes[self] then return end
        rebound_writes[self] = true
        translate_font_string(self)
        rebound_writes[self] = nil
    end)
    if ok then rebound_regions[region] = true end
end

local function scan_frame(frame, seen, depth, stats, allow_protected, bind_regions)
    if not frame or seen[frame] or depth > 20
        or (not allow_protected and is_protected_frame(frame)) then return end
    seen[frame] = true
    stats.frames = stats.frames + 1

    if frame.GetRegions then
        local ok, regions = pcall(function () return { frame:GetRegions() } end)
        if ok then
            for _, region in ipairs(regions) do
                if translate_font_string(region) then
                    stats.translated = stats.translated + 1
                end
                apply_ukrainian_font(region)
                if bind_regions then bind_font_string(region) end
            end
        end
    end

    if frame.GetChildren then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                local shown_ok, shown = pcall(child.IsShown, child)
                if shown_ok and shown then
                    scan_frame(child, seen, depth + 1, stats, allow_protected, bind_regions)
                end
            end
        end
    end
end

strings.prepare = function ()
    -- ClassicUA can replace selected _G strings early on Era clients, but
    -- Camelot reuses localized labels as semantic keys in several protected
    -- systems (character stats and Settings category ordering among them).
    -- Writing any Blizzard display global also taints the modern micro menu.
    -- Keep globals pristine and translate only concrete FontString regions.
end

local function visible_safe_roots()
    local roots, seen = {}, {}
    local candidates = {
        "QuestFrame", "GossipFrame", "WorldMapFrame", "CharacterFrame",
        "PlayerSpellsFrame", "ProfessionsFrame", "ProfessionsBookFrame",
        "TradeSkillFrame", "CraftFrame", "MerchantFrame", "GameMenuFrame",
        "ItemTextFrame", "FriendsFrame", "GuildFrame", "CollectionsJournal",
        "ContainerFrameCombinedBags", "MacroFrame", "ReputationFrame",
        "PVPRankFrame", "TokenFrame", "TokenDetailFrame", "StatisticsFrame",
        "SkillsFrame", "AddonList", "AuctionHouseFrame", "BankFrame",
        "CalendarFrame", "CommunitiesFrame", "GroupFinderFrame", "LFGListFrame",
        "InspectFrame", "PVPUIFrame", "StableFrame", "ClassTrainerFrame",
        "HelpFrame", "DressUpFrame", "EncounterJournal", "AchievementFrame",
        "ObjectiveTrackerFrame",
    }
    for _, name in ipairs(candidates) do
        local frame = _G[name]
        if frame and not seen[frame] and not is_protected_frame(frame) then
            local ok, shown = pcall(frame.IsShown, frame)
            if ok and shown then
                roots[#roots + 1] = frame
                seen[frame] = true
            end
        end
    end
    return roots
end

local function allows_protected_children(frame)
    return frame == _G.GameTooltip
        or frame == _G.ItemRefTooltip
        or frame == _G.ShoppingTooltip1
        or frame == _G.ShoppingTooltip2
end

strings.translate_visible_ui = function ()
    local stats = { frames = 0, translated = 0 }
    if not options.can_translate("translate_string") then
        return stats
    end

    local seen = {}
    for _, frame in ipairs(visible_safe_roots()) do
        local tooltip = allows_protected_children(frame)
        scan_frame(frame, seen, 1, stats, tooltip, not tooltip)
    end
    return stats
end

strings.translate_frame = function (frame)
    local stats = { frames = 0, translated = 0 }
    if not options.can_translate("translate_string") or not frame then return stats end
    local tooltip = allows_protected_children(frame)
    scan_frame(frame, {}, 1, stats, tooltip, not tooltip)
    return stats
end

strings.capture_visible_ui = function ()
    local stats = { frames = 0, captured = 0, new = 0, unique = 0 }
    if not UA_ForeverDB or not UA_ForeverDB.scan then return stats end
    local seen = {}
    for _, frame in ipairs(visible_safe_roots()) do
        capture_frame(frame, seen, 1, stats, allows_protected_children(frame))
    end
    for text, record in pairs(UA_ForeverDB.scan.ui or {}) do
        local translated, normalized = find_translation(text)
        local eligible = not translated and normalized ~= "" and normalized:find("[A-Za-z]") ~= nil
        if eligible then
            local frames = type(record) == "table" and record.frames or nil
            if type(frames) ~= "table" or #frames == 0 then
                stats.unique = stats.unique + 1
            else
                for _, frame_name in ipairs(frames) do
                    if not is_capture_noise(normalized, frame_name) then
                        stats.unique = stats.unique + 1
                        break
                    end
                end
            end
        end
    end
    return stats
end

strings.capture_frame = function (frame, allow_protected)
    local stats = { frames = 0, captured = 0, new = 0, unique = 0 }
    if not frame or not UA_ForeverDB or not UA_ForeverDB.scan then return stats end
    capture_frame(frame, {}, 1, stats, allow_protected == true)
    return stats
end
