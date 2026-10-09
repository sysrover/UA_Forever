local _, addon_table = ...

local options = addon_table.use("options")
local auto_scan = addon_table.use("auto_scan")
local fonts = addon_table.use("fonts")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local walker = addon_table.use("translation_walker")
local layout = addon_table.use("translation_layout")
local scheduler = addon_table.use("translation_scheduler")
local hooks = addon_table.use("translation_hooks").bind("combat-text")
local social_toast_hooks = addon_table.use("translation_hooks").bind("social-toast")
-- These discriminators are local constants in build 70205's BNet.lua.
local social_toast_online, social_toast_offline = 1, 2
local debug_name

local combat_text_globals = assert(addon_table.addon_locale_uk
    and addon_table.addon_locale_uk.combat_text,
    "UA Forever combat text catalog is not loaded")
local combat_text_event_globals = {
    MISS = "COMBAT_TEXT_MISS",
    DODGE = "COMBAT_TEXT_DODGE",
    PARRY = "COMBAT_TEXT_PARRY",
    BLOCK = "COMBAT_TEXT_BLOCK",
    EVADE = "COMBAT_TEXT_EVADE",
    IMMUNE = "COMBAT_TEXT_IMMUNE",
    RESIST = "COMBAT_TEXT_RESIST",
    ABSORB = "COMBAT_TEXT_ABSORB",
    DEFLECT = "COMBAT_TEXT_DEFLECT",
    REFLECT = "COMBAT_TEXT_REFLECT",
}
local combat_text_originals = {}
local combat_text_catalog_sources = {
    [" (%d blocked)"] = true,
    ["%s (Block)"] = true,
    ["Changed Target!"] = true,
}
local combat_text_catalog_globals = {}
-- Display globals read by the build-70205 combat renderer and native threat
-- warnings. Wording stays in the UI catalog, including formatted templates.
local combat_text_catalog_names = {
    COMBAT_THREAT_INCREASE_1 = true, COMBAT_THREAT_INCREASE_3 = true,
    COMBAT_THREAT_DECREASE_0 = true, COMBAT_THREAT_DECREASE_1 = true,
    COMBAT_THREAT_DECREASE_2 = true,
    HEALTH_LOW = true, MANA_LOW = true,
    ENTERING_COMBAT = true, LEAVING_COMBAT = true,
    COMBAT_TEXT_MISFIRE = true, COMBAT_TEXT_HONOR_GAINED = true,
    COMBAT_TEXT_ARENA_POINTS_GAINED = true, COMBAT_TEXT_COMBO_POINTS = true,
    COMBAT_TEXT_RUNE_BLOOD = true, COMBAT_TEXT_RUNE_UNHOLY = true,
    COMBAT_TEXT_RUNE_FROST = true, COMBAT_TEXT_RUNE_DEATH = true,
    COMBAT_TEXT_ABSORB_ADDED = true, COMBAT_TEXT_BLOCK_REDUCED = true,
    COMBAT_TEXT_ABSORB_AMOUNT = true,
    BLOCK_TRAILER = true, ABSORB_TRAILER = true, RESIST_TRAILER = true,
    AURA_END = true,
}

local function discover_combat_text_catalog_globals()
    local catalog = addon_table.forever_ui
    if type(catalog) ~= "table" then return end

    -- Some world combat messages are read directly from unnamed client
    -- globals before a FontString or CombatText_AddMessage callback exists.
    -- Match only known exact source strings so this does not mutate unrelated
    -- display globals or rely on a client-version-specific global name.
    for global_name, source in pairs(_G) do
        if type(global_name) == "string" and type(source) == "string"
            and combat_text_catalog_globals[global_name] == nil then
            local ok, ukrainian = pcall(function ()
                if not combat_text_catalog_names[global_name]
                    and not combat_text_catalog_sources[source] then return nil end
                local value = catalog[source]
                if type(value) ~= "string" or value == "" or value == source then
                    return nil
                end
                return value
            end)
            if ok and ukrainian then
                combat_text_originals[global_name] = source
                combat_text_catalog_globals[global_name] = ukrainian
            end
        end
    end
end

local function refresh_combat_text_global(global_name, ukrainian, translated)
    local current = rawget(_G, global_name)
    if combat_text_originals[global_name] == nil and type(current) == "string" then
        combat_text_originals[global_name] = current
    end
    local original = combat_text_originals[global_name]
    if original then
        _G[global_name] = translated and ukrainian or original
    end
end

strings.refresh_combat_text_globals = function ()
    local translated = options.can_translate("translate_string")
        and options.translate_combat_text()
    discover_combat_text_catalog_globals()
    for global_name, ukrainian in pairs(combat_text_globals) do
        refresh_combat_text_global(global_name, ukrainian, translated)
    end
    for global_name, ukrainian in pairs(combat_text_catalog_globals) do
        refresh_combat_text_global(global_name, ukrainian, translated)
    end
end

strings.capture_combat_text_event = function (kind)
    if not options.account or not options.account.auto_scan_content
        or type(auto_scan.record_combat_text) ~= "function"
        or type(kind) ~= "string" then return end
    local global_name = combat_text_event_globals[kind]
        or combat_text_catalog_names["COMBAT_TEXT_" .. kind]
            and ("COMBAT_TEXT_" .. kind)
        or combat_text_catalog_names[kind] and kind
    if not global_name then return end
    local current = rawget(_G, global_name)
    local source = combat_text_originals[global_name] or current
    auto_scan.record_combat_text(kind, source,
        combat_text_globals[global_name] or combat_text_catalog_globals[global_name],
        global_name, current)
end

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
    if options.work_enabled and not options.work_enabled() then return nil end
    if type(text) ~= "string" or is_secret(text) then return nil end
    return resolver.find_ui(text, region)
end

local function translate_font_string(region, category, slot, surface, phase, instance, section)
    if options.work_enabled and not options.work_enabled(surface and surface.id) then return false end
    if not region then return false end
    local methods_ok, get_text, set_text = pcall(function ()
        return region.GetText, region.SetText
    end)
    if not methods_ok or type(get_text) ~= "function"
        or type(set_text) ~= "function" then return false end

    local ok, text = pcall(get_text, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return false end
    if text == "" then return false end
    -- Escape-menu buttons are rebuilt even during combat. Only their public
    -- label text may be updated then; font and layout work waits until combat ends.
    local text_only = type(surface) == "table" and surface.id == "game-menu"
        and type(runtime.combat_locked) == "function" and runtime.combat_locked()

    -- A cold login can leave already translated button labels on their old
    -- Latin-only font when the addon font was not ready during the first
    -- pass. OnShow and the post-login refresh must be able to repair the font
    -- even though there is no longer an English string to translate.
    if contains_cyrillic(text) then
        if text_only then return true end
        if not options.can_translate("override_system_fonts") then return false end
        return runtime.ensure_font(region)
    end

    local explicit_category = category
        or type(surface) == "table" and surface.name_category ~= "none"
            and surface.name_category or nil
    if options.section_enabled and not (options.capture_enabled and options.capture_enabled()) then
        local spec = {section=section, category=explicit_category, slot=slot or
            (explicit_category and explicit_category .. ".name" or "ui.text"),
            surface=surface, owner="ui"}
        if not options.section_enabled(options.section_for(spec, region)) then return false end
    end
    local translated, _, source_kind, inferred_category, inferred_slot,
        inferred_option, provenance =
        resolver.find_ui(text, region, explicit_category and {
            category = explicit_category,
            slot = slot,
        } or nil)
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
        lookup_tier = source_kind,
        catalog_source = provenance and provenance.source,
        surface = surface, phase = phase, section = section,
        generation = phase == "dynamic" and runtime.generation(surface) or nil,
        instance = instance,
        combat_text_only = text_only == true,
        layout_pending = text_only == true,
        priority = priority, tooltip = is_tooltip(parent) and parent or nil,
        after_apply = function (applied)
            if text_only then return end
            fit_tooltip_width_to_region(parent, applied)
            fit_tooltip_height_to_region(parent, applied,
                previous_height, previous_tooltip_height)
            if not layout.fit_auction_tab(applied, text)
                and parent and is_button(parent) then
                fit_button_to_text(parent, applied)
            end
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
        -- This is a preset/account/character layout name, not UI vocabulary.
        or frame_name:find("EditModeManagerFrame.LayoutDropdown", 1, true)
        or frame_name:find("MainStatusTrackingBar", 1, true)
        or frame_name:find("CharacterLevelText", 1, true)
        or frame_name:find("ItemTextPageText", 1, true)
        -- Auction result rows are dynamic item data, not UI vocabulary.
        -- Keep their names in the client language and out of [UI] reports.
        or (frame_name:find("AuctionHouseFrame", 1, true)
            and frame_name:find(".ItemList.", 1, true))
        or frame_name:find(".FontStringContainer", 1, true)
        or frame_name:find("EditBox", 1, true)
end

local player_name_units = { "player", "target", "focus", "mouseover" }
for index = 1, 4 do player_name_units[#player_name_units + 1] = "party" .. index end
for index = 1, 40 do player_name_units[#player_name_units + 1] = "raid" .. index end
for index = 1, 5 do player_name_units[#player_name_units + 1] = "arena" .. index end

local function is_player_unit_name(text, unit)
    if type(text) ~= "string" or type(_G.UnitIsPlayer) ~= "function"
        or type(_G.UnitName) ~= "function" then return false end
    local player_ok, is_player = pcall(_G.UnitIsPlayer, unit)
    if not player_ok or is_secret(is_player) or is_player ~= true then return false end
    local name_ok, name, realm = pcall(_G.UnitName, unit)
    if not name_ok or is_secret(name) or type(name) ~= "string" then return false end
    if text == name then return true end
    return type(realm) == "string" and realm ~= "" and not is_secret(realm)
        and text == name .. "-" .. realm
end

local function is_known_player_name(text)
    for _, unit in ipairs(player_name_units) do
        if is_player_unit_name(text, unit) then return true end
    end
    return false
end

strings.is_known_player_name = is_known_player_name

local function capture_font_string(region, stats)
    if not region or not region.GetText then return end
    local visible_ok, is_visible = pcall(function () return region.IsVisible end)
    if visible_ok and type(is_visible) == "function" then
        local ok, visible = pcall(is_visible, region)
        if not ok or is_secret(visible) or visible ~= true then return end
    else
        local shown_ok, is_shown = pcall(function () return region.IsShown end)
        if shown_ok and type(is_shown) == "function" then
            local ok, shown = pcall(is_shown, region)
            if not ok or is_secret(shown) or shown ~= true then return end
        end
    end
    local ok, text = pcall(region.GetText, region)
    if not ok or type(text) ~= "string" or is_secret(text) then return end

    local translated, normalized = resolver.find_ui(text, region)
    local frame_name = debug_name(region)
    if translated and translated ~= text then
        if type(auto_scan.record_ui) == "function" then
            auto_scan.record_ui(text, true, frame_name)
        end
        if type(auto_scan.record_ui_observation) == "function" then
            auto_scan.record_ui_observation(text, translated, text,
                frame_name or "ui.text")
        end
        return
    end
    if normalized == "" or normalized == "EN" or normalized == "UA"
        or not normalized:find("[A-Za-z]") then return end

    if is_capture_noise(normalized, frame_name) then return end
    if is_known_player_name(normalized) then
        if type(auto_scan.discard_ui) == "function" then
            auto_scan.discard_ui(normalized)
        end
        return
    end

    if type(auto_scan.record_ui) == "function" then
        auto_scan.record_ui(normalized, false, frame_name)
    end
    stats.sources = stats.sources or {}
    if not stats.sources[normalized] then
        stats.sources[normalized] = true
        stats.new = stats.new + 1
        stats.unique = stats.unique + 1
    end
    stats.captured = stats.captured + 1
end

local function capture_frame(frame, seen, depth, stats, allow_protected)
    walker.walk({ id = "ui-developer-capture", surface = "visible-ui",
        owner = "strings", reason = "DEVELOPER_CAPTURE" },
        frame, function (region) capture_font_string(region, stats) end,
        not allow_protected and is_protected_frame or nil, stats, seen)
end

local function scan_frame(frame, seen, stats, allow_protected, surface, walk_metadata)
    -- Text writes below ObjectiveTrackerFrame can mark its container dirty.
    -- Never start that Blizzard layout chain from addon code while aura data
    -- is secret; PLAYER_REGEN_ENABLED refreshes open surfaces afterwards.
    if frame == _G.ObjectiveTrackerFrame and runtime.combat_locked() then return end
    walker.walk(walk_metadata, frame, function (region)
        local skip = type(surface) == "table" and surface.skip_region
            or type(walk_metadata) == "table" and walk_metadata.skip_region
        local skip_ok, skipped = true, false
        if type(skip) == "function" then
            skip_ok, skipped = pcall(skip, region)
        end
        if skip_ok and not skipped
            and translate_font_string(region, nil, nil, surface, nil, nil,
                walk_metadata and walk_metadata.section) then
            stats.translated = stats.translated + 1
        end
        apply_ukrainian_font(region)
    end, not allow_protected and is_protected_frame or nil, stats, seen)
end

local function refresh_combat_text()
    local capture_enabled = options.account
        and options.account.auto_scan_content == true
    local translate_enabled = options.can_translate("translate_string")
        and options.translate_combat_text()
    if not capture_enabled and not translate_enabled then return false end
    auto_scan.surface_attempt("combat-text", "refresh_combat_text")
    local regions, seen = {}, {}
    local function add_region(region)
        if region and not is_secret(region) and not seen[region]
            and #regions < 100 then
            seen[region] = true
            regions[#regions + 1] = region
        end
    end
    -- Build 70205 pools anonymous FontStrings; CombatText1..N only covers
    -- older clients. Enumerate the live frame after AddMessage has shown them.
    local frame = _G.CombatText
    if frame and type(frame.EnumerateActiveFontStrings) == "function" then
        pcall(function ()
            for _, region in frame:EnumerateActiveFontStrings() do
                add_region(region)
                if #regions >= 100 then break end
            end
        end)
    end
    local line_count = tonumber(_G.NUM_COMBAT_TEXT_LINES) or 20
    for index = 1, math.min(line_count, 100) do
        add_region(_G["CombatText" .. index])
    end
    local saw_visible = false
    for index, region in ipairs(regions) do
        if region then
            local shown_ok, shown = pcall(region.IsShown, region)
            local text_ok, source = pcall(region.GetText, region)
            if shown_ok and shown and not is_secret(shown)
                and text_ok and type(source) == "string" and source ~= ""
                and not is_secret(source) then
                saw_visible = true
                -- A client-global translation may already be Cyrillic before
                -- resolver/runtime sees the line. Repair that pooled font;
                -- runtime.apply handles fonts for actual resolver results.
                if translate_enabled and source:find("[\208\209]")
                    and not runtime.combat_locked() then
                    fonts.apply_to_font_string(region)
                end
                local translated = resolver.find_ui(source, region)
                if capture_enabled
                    and type(auto_scan.record_ui) == "function" then
                    auto_scan.record_ui(source, translated, "CombatText" .. index)
                end
                if translate_enabled and translated and translated ~= source then
                    runtime.apply(region, {
                        owner = "combat-text", slot = "line:" .. index,
                        source = source, translated = translated,
                        option = "translate_string",
                        combat_text_only = runtime.combat_locked(),
                        priority = runtime.PRIORITY.STATIC_UI,
                    })
                end
            end
        end
    end
    return saw_visible
end

strings.refresh_combat_text = function ()
    local capture_enabled = options.account
        and options.account.auto_scan_content == true
    local translate_enabled = options.can_translate("translate_string")
        and options.translate_combat_text()
    if not capture_enabled and not translate_enabled then return end
    scheduler.request({ id = "combat-text-event", task_kind = "combat-text",
        max_retries = 1, retry_delay = 0.05, callback = function ()
            if not refresh_combat_text() then return false end
        end })
end

local function after_social_toast(self)
    if not self or not options.can_translate("translate_string") then return end
    -- Build 70205 writes account/character names to TopLine/MiddleLine and
    -- the status to BottomLine. Broadcasts use the same BottomLine for player
    -- text, so restrict this hook to the two native presence toast types.
    if is_secret(self.toastType) then return end
    local native, status
    if self.toastType == social_toast_online then
        native = _G.BN_TOAST_ONLINE
        status = "online"
    elseif self.toastType == social_toast_offline then
        native = _G.BN_TOAST_OFFLINE
        status = "offline"
    else
        return
    end
    if type(native) ~= "string" or is_secret(native) then return end
    local region = self.BottomLine
    if not region then return end
    local ok, source = pcall(function() return region:GetText() end)
    if not ok or type(source) ~= "string" or is_secret(source) then return end
    local first, last = source:find(native, 1, true)
    if not first then return end
    local translated = addon_table.forever_surface_ui.social_toast[status]
    if type(translated) ~= "string" or translated == native then return end
    -- Online also has an outer gray color wrapper. Preserve it and the
    -- green/red status markup from the catalog rather than stripping colors.
    runtime.apply(region, {
        owner = "ui", slot = "ui.text", source = source,
        surface = "social",
        translated = source:sub(1, first - 1) .. translated .. source:sub(last + 1),
        option = "translate_string", priority = runtime.PRIORITY.CONTEXT,
    })
end

local function after_combat_text_add_message(message, hook_name)
    auto_scan.surface_hook("combat-text", hook_name, true, true)
    if type(message) ~= "string" or is_secret(message) then return end
    local capture_enabled = options.account
        and options.account.auto_scan_content == true
    local translate_enabled = options.can_translate("translate_string")
        and options.translate_combat_text()
    if not capture_enabled and not translate_enabled then return end
    if capture_enabled and type(auto_scan.record_ui) == "function" then
        auto_scan.record_ui(message, resolver.find_ui(message), "CombatText")
    end
    refresh_combat_text()
    strings.refresh_combat_text()
end

local function prepare_social_toast()
    local frame = _G.BNToastFrame
    if not frame then return end
    social_toast_hooks.region(frame, "ShowToast", after_social_toast)
    social_toast_hooks.region_script(frame, "OnShow", after_social_toast)
    -- ShowToast writes BottomLine before assigning the new toastType. Run
    -- after that call completes, including later native rewrites of the text.
    social_toast_hooks.region(frame.BottomLine, "SetText", function (region)
        if runtime.is_applying(region) then return end
        scheduler.request({ id = "social-toast-status", work_scope = "social-toast",
            max_retries = 1, callback = function () after_social_toast(frame) end })
    end)
end

strings.prepare = function ()
    -- ClassicUA can replace selected _G strings early on Era clients, but
    -- Camelot reuses localized labels as semantic keys in several protected
    -- systems (character stats and Settings category ordering among them).
    -- Writing general Blizzard display globals also taints the modern micro menu.
    -- Keep those pristine; only dedicated COMBAT_TEXT_* globals and exact known
    -- combat display strings are replaced because the engine consumes them
    -- before a FontString is exposed.
    strings.refresh_combat_text_globals()
    local hook_name = "CombatText_AddMessage"
    local available = hooks.global(hook_name, function (message)
        after_combat_text_add_message(message, hook_name)
    end)
    auto_scan.surface_hook("combat-text", hook_name, available, false)
    local frame_hook = "CombatText:AddMessage"
    local frame_available = hooks.region(_G.CombatText, "AddMessage",
        function (_, message)
            after_combat_text_add_message(message, frame_hook)
        end)
    auto_scan.surface_hook("combat-text", frame_hook, frame_available, false)
    -- Hook the live frame: XML copies BNToastMixin methods onto BNToastFrame.
    prepare_social_toast()
end

local function visible_safe_roots()
    local roots, seen = {}, {}
    local candidates = {
        "QuestFrame", "GossipFrame", "WorldMapFrame", "CharacterFrame",
        "PlayerSpellsFrame", "MerchantFrame", "GameMenuFrame",
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
        scan_frame(frame, seen, stats, tooltip, nil, {
            id = "manual-visible-ui-translate", surface = "visible-ui",
            owner = "strings", reason = "DEVELOPER_COMMAND",
        })
    end
    return stats
end

local function translation_walk_metadata(surface, fallback)
    if type(surface) == "table" and type(surface.id) == "string"
        and surface.id ~= "" then
        return {
            id = "surface-static:" .. surface.id,
            surface = surface.id,
            owner = "translation-registry",
            reason = "REGISTERED_STATIC_SCAN",
        }
    end
    if type(fallback) == "table" then return fallback end
end

strings.translate_frame = function (frame, surface, fallback)
    local stats = { frames = 0, translated = 0 }
    if not options.can_translate("translate_string") or not frame then return stats end
    local walk_metadata = translation_walk_metadata(surface, fallback)
    if not walk_metadata then return stats, "TRANSLATE_FRAME_SCOPE_REQUIRED" end
    if walk_metadata.section and options.can_lookup_section
        and not options.can_lookup_section(walk_metadata.section) then return stats end
    local tooltip = allows_protected_children(frame)
    scan_frame(frame, {}, stats, tooltip, surface, walk_metadata)
    return stats
end

strings.capture_visible_ui = function ()
    local stats = { frames = 0, captured = 0, new = 0, unique = 0 }
    if not UA_ForeverDB or not UA_ForeverDB.scan then return stats end
    if type(auto_scan.clear_runtime_owner) == "function" then
        auto_scan.clear_runtime_owner("ui-scan")
    end
    local seen = {}
    for _, frame in ipairs(visible_safe_roots()) do
        capture_frame(frame, seen, 1, stats, allows_protected_children(frame))
    end
    stats.sources = nil
    return stats
end

strings.capture_frame = function (frame, allow_protected)
    local stats = { frames = 0, captured = 0, new = 0, unique = 0 }
    if not frame or not UA_ForeverDB or not UA_ForeverDB.scan then return stats end
    capture_frame(frame, {}, 1, stats, allow_protected == true)
    stats.sources = nil
    return stats
end
