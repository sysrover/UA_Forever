local _, addon_table = ...

local options = addon_table.use("options")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local walker = addon_table.use("translation_walker")
local layout = addon_table.use("translation_layout")
local debug_name

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function is_protected_frame(frame)
    if not frame then return false end
    for _, method in ipairs({ "IsForbidden", "IsProtected" }) do
        local ok_method, callback = pcall(function () return frame[method] end)
        if not ok_method then return true end
        if ok_method and type(callback) == "function" then
            local ok, result = pcall(callback, frame)
            if not ok or is_secret(result) or result then return true end
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

strings.is_protected_frame = is_protected_frame

local function contains_cyrillic(text)
    return type(text) == "string"
        and (text:find("\208", 1, true) or text:find("\209", 1, true)) ~= nil
end

local safe_dimension = layout.safe_dimension
local is_button = layout.is_button
local is_tooltip = layout.is_tooltip
local fit_tooltip_height_to_region = layout.fit_tooltip_height_to_region
local fit_tooltip_width_to_region = layout.fit_tooltip_width_to_region
local fit_bag_tooltip_width = layout.fit_bag_tooltip_width
local fit_button_to_text = layout.fit_button_to_text
strings.fit_button_to_text = fit_button_to_text

strings.find_ui_translation = function (text, region)
    if type(text) ~= "string" or is_secret(text) then return nil end
    return resolver.find_ui(text, region)
end

local function translate_font_string(region, category, slot, surface, phase)
    if not region then return false end
    local methods_ok, get_text, set_text = pcall(function ()
        return region.GetText, region.SetText
    end)
    if not methods_ok or type(get_text) ~= "function"
        or type(set_text) ~= "function" then return false end

    local ok, text = pcall(get_text, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return false end
    if text == "" then return false end

    -- A cold login can leave already translated button labels on their old
    -- Latin-only font when the addon font was not ready during the first
    -- pass. OnShow and the post-login refresh must be able to repair the font
    -- even though there is no longer an English string to translate.
    if contains_cyrillic(text) then
        if not options.can_translate("override_system_fonts") then return false end
        return runtime.ensure_font(region)
    end

    local translated, _, source_kind, inferred_category, inferred_slot, inferred_option =
        resolver.find_ui(text, region)
    if not translated or translated == text then return false end
    category = category or inferred_category
    slot = slot or inferred_slot

    local parent
    local parent_method_ok, get_parent = pcall(function () return region.GetParent end)
    if parent_method_ok and type(get_parent) == "function" then
        local ok_parent, value = pcall(get_parent, region)
        if ok_parent then parent = value end
    end
    if parent and is_tooltip(parent) then return false end

    local previous_height = parent and is_tooltip(parent)
        and (safe_dimension(region, "GetStringHeight") or safe_dimension(region, "GetHeight")) or nil
    local previous_tooltip_height = previous_height and safe_dimension(parent, "GetHeight") or nil
    local priority = runtime.priority_for_source(source_kind)
    local set_ok = runtime.apply(region, {
        owner = "ui", slot = slot or "ui.text", source = text,
        translated = translated, category = category,
        option = inferred_option,
        surface = surface, phase = phase,
        priority = priority, tooltip = is_tooltip(parent) and parent or nil,
        after_apply = function (applied)
            fit_tooltip_width_to_region(parent, applied)
            fit_tooltip_height_to_region(parent, applied,
                previous_height, previous_tooltip_height)
            if parent and is_button(parent) then fit_button_to_text(parent, applied) end
        end,
    })
    return set_ok
end

strings.translate_region = translate_font_string

strings.set_region_text = function (region, text, tooltip, source, category, slot)
    if not region or type(text) ~= "string" or is_secret(text) then
        return false
    end
    -- Protected aura tooltip regions can reject SetFont even though SetText
    -- remains available. Do not apply the cold-login button safeguard here:
    -- the caller can fall back to an addon-owned tooltip line if SetText is
    -- also rejected.
    local previous_height = tooltip and is_tooltip(tooltip)
        and (safe_dimension(region, "GetStringHeight") or safe_dimension(region, "GetHeight")) or nil
    local previous_tooltip_height = previous_height and safe_dimension(tooltip, "GetHeight") or nil
    local ok = runtime.apply(region, {
        owner = "legacy-domain", slot = slot or "domain.text", source = source,
        translated = text, priority = runtime.PRIORITY.DOMAIN,
        tooltip = tooltip, category = category, allow_unknown_source = true,
        after_apply = function (applied)
            fit_tooltip_width_to_region(tooltip, applied)
            fit_tooltip_height_to_region(tooltip, applied,
                previous_height, previous_tooltip_height)
            fit_bag_tooltip_width(tooltip, applied, source)
        end,
    })
    return ok
end

local function apply_ukrainian_font(region)
    if not region then return end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return end
    local ok, text = pcall(get_text, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return end
    if contains_cyrillic(text) then
        runtime.ensure_font(region)
    end
end

debug_name = function (region)
    local name_method_ok, get_name = pcall(function () return region.GetDebugName end)
    if name_method_ok and type(get_name) == "function" then
        local ok, name = pcall(get_name, region)
        if ok and type(name) == "string" and not is_secret(name) and name ~= "" then return name end
    end
    local parent_method_ok, get_parent = pcall(function () return region.GetParent end)
    if parent_method_ok and type(get_parent) == "function" then
        local ok, parent = pcall(get_parent, region)
        local parent_name_ok, parent_get_name = parent and pcall(function ()
            return parent.GetDebugName
        end)
        if ok and parent_name_ok and type(parent_get_name) == "function" then
            local name_ok, name = pcall(parent_get_name, parent)
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

    local translated, normalized = resolver.find_ui(text, region)
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
    walker.walk(frame, function (region) capture_font_string(region, stats) end,
        not allow_protected and is_protected_frame or nil, stats, seen)
end

local function scan_frame(frame, seen, stats, allow_protected, surface)
    walker.walk(frame, function (region)
        if translate_font_string(region, nil, nil, surface) then
            stats.translated = stats.translated + 1
        end
        apply_ukrainian_font(region)
    end, not allow_protected and is_protected_frame or nil, stats, seen)
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
        "ItemTextFrame", "FriendsFrame", "GuildFrame", "GuildInviteFrame", "CollectionsJournal",
        "ContainerFrameCombinedBags", "MacroFrame", "ReputationFrame",
        "PVPRankFrame", "TokenFrame", "TokenDetailFrame", "StatisticsFrame",
        "SkillsFrame", "AddonList", "AuctionHouseFrame", "BankFrame",
        "CalendarFrame", "CommunitiesFrame", "GroupFinderFrame", "LFGListFrame",
        "InspectFrame", "PVPUIFrame", "StableFrame", "ClassTrainerFrame",
        "HelpFrame", "DressUpFrame", "EncounterJournal", "AchievementFrame",
        "ObjectiveTrackerFrame", "QuestTimerFrame",
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
        or frame == _G.EmbeddedItemTooltip
        or frame == _G.BuffFrameTooltip
end

strings.translate_visible_ui = function ()
    local stats = { frames = 0, translated = 0 }
    if not options.can_translate("translate_string") then
        return stats
    end

    local seen = {}
    for _, frame in ipairs(visible_safe_roots()) do
        local tooltip = allows_protected_children(frame)
        scan_frame(frame, seen, stats, tooltip)
    end
    return stats
end

strings.translate_frame = function (frame, surface)
    local stats = { frames = 0, translated = 0 }
    if not options.can_translate("translate_string") or not frame then return stats end
    local tooltip = allows_protected_children(frame)
    scan_frame(frame, {}, stats, tooltip, surface)
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
        local translated, normalized = resolver.find_ui(text)
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
