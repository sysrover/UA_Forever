local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local auto_scan = addon_table.use("auto_scan")
local dev_log = addon_table.use("dev_log")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local map_adapter = addon_table.use("tooltip_map_adapter")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local options = addon_table.use("options")
local hooks = addon_table.use("translation_hooks").bind("menus_ui")
local layout = addon_table.use("translation_layout")
local profiler = addon_table.use("performance_profile")
local prepared_menus = setmetatable({}, { __mode = "k" })
local prepared_descriptions = setmetatable({}, { __mode = "k" })
local unit_popup_descriptions = setmetatable({}, { __mode = "k" })
local deferred_unit_labels = setmetatable({}, { __mode = "k" })
local unit_popup_labels_by_tag = {
    MENU_UNIT_PLAYER = {
        ["Whisper"] = true, ["Inspect"] = true, ["View Talents"] = true,
        ["Trade"] = true, ["Follow"] = true, ["Duel"] = true, ["Other Options"] = true,
    },
    MENU_UNIT_COMMUNITIES_GUILD_MEMBER = {
        ["Invite"] = true, ["Whisper"] = true, ["Ignore"] = true,
        ["Other Options"] = true, ["Report Player"] = true, ["Copy Character Name"] = true,
    },
}
local early_labels = setmetatable({}, { __mode = "k" })
local prepared_legends = setmetatable({}, { __mode = "k" })
local micro_button_names = {
    "CharacterMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton",
    "SpellbookMicroButton", "SpellBookMicroButton", "TalentMicroButton",
    "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton",
    "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton",
    "StoreMicroButton", "MainMenuMicroButton", "HelpMicroButton",
}

tooltips.is_micro_button_tooltip = function (tooltip, known_owner)
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return false end
    if runtime.is_secret_value(known_owner) then return false end
    local ok, owner = true, known_owner
    if owner == nil then ok, owner = pcall(tooltip.GetOwner, tooltip) end
    if not ok or runtime.is_secret_value(owner) or not owner then return false end
    for _, name in ipairs(micro_button_names) do
        if owner == _G[name] then return true end
    end
    return false
end

local menu_walks = {
    modern = { id = "modern-open-menu", surface = "menus",
        owner = "menus", reason = "POOLED_MENU_DISCOVERY" },
    legacy = { id = "legacy-dropdown", surface = "menus",
        owner = "menus", reason = "POOLED_MENU_DISCOVERY" },
}

local function capture_auto_frame(frame)
    if frame and type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled()
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(frame)
    end
end

local function translate_game_menu(frame)
    if not frame then return end
    local surface = registry.get("game-menu")
    if not surface then return end
    local instance = "game-menu:" .. tostring(frame)
    runtime.begin_generation(surface, instance)
    local text_only = type(runtime.combat_locked) == "function"
        and runtime.combat_locked()

    -- GameMenuFrame is protected in Camelot, so the generic recursive walker
    -- intentionally refuses it. Its public display surface is small and
    -- stable: one header FontString and the FontString of each pooled button.
    -- Touch only those completed display regions and leave button data,
    -- callbacks, ordering, and secure descendants unchanged.
    local header = frame.Header
    strings.translate_region(header and header.Text, nil, "ui.title",
        surface, "dynamic", instance)
    if not text_only and header and type(header.UpdateWidth) == "function" then
        pcall(header.UpdateWidth, header)
    end

    if type(frame.buttons) == "table" then
        local widest_button = 0
        for _, button in ipairs(frame.buttons) do
            if button and type(button.GetFontString) == "function" then
                local ok, font_string = pcall(button.GetFontString, button)
                if ok then
                    strings.translate_region(font_string, nil, "ui.action",
                        surface, "dynamic", instance)
                    if not text_only then
                        strings.fit_button_to_text(button, font_string)
                        local width_ok, width = pcall(button.GetWidth, button)
                        if width_ok and type(width) == "number" then
                            widest_button = math.max(widest_button, width)
                        end
                    end
                end
            end
        end
        if widest_button > 0 then
            for _, button in ipairs(frame.buttons) do
                if button and type(button.SetWidth) == "function" then
                    pcall(button.SetWidth, button, widest_button)
                end
            end
            if type(frame.MarkDirty) == "function" then pcall(frame.MarkDirty, frame) end
        end
    end
end

local function declare_game_menu_hook()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "game-menu.buttons.init",
        surface = "game-menu",
        kind = "frame",
        target = "GameMenuFrame",
        method = "InitButtons",
        required = true,
        fallbackEvent = "GameMenuFrame.OnShow",
        verifiedBuild = 70205,
        callback = translate_game_menu,
    })
end

local function translate_micro_button_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip.GetOwner or tooltip:GetOwner() ~= button then return end
    if tooltips.complete_owned_ui and tooltips.complete_owned_ui(tooltip) then return end
    if tooltips.finalize then
        tooltip.uaForeverKind = "micro-button"
        tooltips.finalize(tooltip)
    end
end

local function is_edit_mode_layout_menu(menu)
    if not menu then return false end
    local manager = _G.EditModeManagerFrame
    local dropdown = manager and manager.LayoutDropdown
    if dropdown and type(menu.GetOwnerRegion) == "function" then
        local ok, owner = pcall(menu.GetOwnerRegion, menu)
        if ok and not runtime.is_secret_value(owner) and owner == dropdown then return true end
    end
    if type(menu.ToDebugString) == "function" then
        local ok, tag = pcall(menu.ToDebugString, menu)
        if ok and not runtime.is_secret_value(tag) and tag == "MENU_EDIT_MODE_MANAGER" then return true end
    end
    return false
end

local function edit_mode_user_layout_names()
    local names = {}
    local manager = _G.EditModeManagerFrame
    local layout_info = manager and manager.layoutInfo
    local layouts = layout_info and layout_info.layouts
    local types = _G.Enum and _G.Enum.EditModeLayoutType
    if type(layouts) ~= "table" or type(types) ~= "table" then return names end
    for _, info in ipairs(layouts) do
        local layout_type = info and info.layoutType
        if layout_type == types.Account or layout_type == types.Character then
            local name = info.layoutName
            if type(name) == "string" and name ~= "" then names[name] = true end
        end
    end
    return names
end

local function menu_policy(menu, owner)
    local section, names = "game_menu", {}
    local ok, tag = pcall(function () return menu:ToDebugString() end)
    tag = ok and runtime.safe_string_or_nil(tag) or nil
    if tag == "MENU_MINIMAP_TRACKING" then return nil end
    local guild = addon_table.use("guild_menus_ui")
    if tag and guild.owns and guild.owns(tag) then return nil end
    if is_edit_mode_layout_menu(menu) then
        section, names = "edit_mode", edit_mode_user_layout_names()
    elseif tag then
        if tag:match("^MENU_UNIT_") or tag:match("^MENU_SOCIAL_UI_") then
            section = "social_ui"
        elseif tag:match("^MENU_COOLDOWN_SETTINGS_") or tag:match("^COOLDOWN_VIEWER_")
            or tag:match("^GROUP_BUFF_FILTER_") or tag:match("^MENU_GROUP_BUFF_FILTER_")
            or tag:match("^MENU_DAMAGE_METER_") then
            section = "game_settings"
            if tag == "MENU_COOLDOWN_SETTINGS_LAYOUTS" then
                names = addon_table.use("cooldown_viewer_ui").user_layout_names()
            end
        end
    end
    local barber = addon_table.use("barber_ui")
    if not owner and menu then
        local owner_ok, value = pcall(function () return menu:GetOwnerRegion() end)
        if owner_ok and not runtime.is_secret_value(value) then owner = value end
    end
    if barber.is_owner and barber.is_owner(owner) then section = "character_ui" end
    return { id = "menus", name_category = "none", section = section,
        names = names, tag = tag or "", defer_if_protected = false }
end

local function fit_menu_label(region)
    if runtime.combat_locked() then return end
    local state = early_labels[region]
    if state and state.policy.settings_menu then
        -- Native Settings highlight radios use Text with maxLines=1. Fit the
        -- complete translated option before Menu measures its attached regions.
        local width = layout.safe_dimension(region, "GetUnboundedStringWidth")
            or layout.safe_dimension(region, "GetStringWidth")
        if not width or width <= 0 then return end
        local screen = layout.safe_dimension(_G.UIParent, "GetWidth")
        local limit = math.min(520, screen and screen > 80 and screen - 80 or 520)
        width = math.ceil(math.min(width, limit))
        local function dimension(owner, getter, setter, value)
            local current = layout.safe_dimension(owner, getter)
            if current and layout.dimensions_match(current, value) then return true end
            if not runtime.can_write_text(owner) then return false end
            return pcall(function () owner[setter](owner, value) end)
        end
        local function policy(getter, setter, value)
            local ok, current = pcall(function () return region[getter](region) end)
            if not ok or runtime.is_secret_value(current) then return false end
            if current == value then return true end
            if not runtime.can_write_text(region) then return false end
            return pcall(function () region[setter](region, value) end)
        end
        if not policy("GetMaxLines", "SetMaxLines", 0)
            or not policy("CanWordWrap", "SetWordWrap", true)
            or not policy("CanNonSpaceWrap", "SetNonSpaceWrap", false)
            or not dimension(region, "GetWidth", "SetWidth", width) then return end
        local height = layout.safe_dimension(region, "GetStringHeight")
        if not height or height <= 0 then return end
        dimension(region, "GetHeight", "SetHeight", height)
        local frame = state.references.frame
        if frame then
            dimension(frame, "GetWidth", "SetWidth", width + 48)
            dimension(frame, "GetHeight", "SetHeight", math.max(20, math.ceil(height + 6)))
        end
        return
    end
    local width = layout.safe_dimension(region, "GetUnboundedStringWidth")
        or layout.safe_dimension(region, "GetStringWidth")
    local current = layout.safe_dimension(region, "GetWidth")
    if width and current and not layout.dimensions_match(current, math.ceil(width))
        and runtime.can_write_text(region) then
        pcall(region.SetWidth, region, math.ceil(width))
    end
    local height = layout.safe_dimension(region, "GetStringHeight")
    current = layout.safe_dimension(region, "GetHeight")
    -- Standard menu labels reserve a native minimum height (20 in 70888).
    if height and current and height > current
        and not layout.dimensions_match(current, math.ceil(height))
        and runtime.can_write_text(region) then
        pcall(region.SetHeight, region, math.ceil(height))
    end
end

local function prepare_deferred_unit_label(description, util, labels)
    if deferred_unit_labels[description] then return end
    local ok, source = pcall(util.GetElementText, description)
    source = ok and runtime.safe_string_or_nil(source) or nil
    if not source then return end
    local translated
    if labels then
        if labels[source] then translated = strings.find_ui_translation(source) end
    else
        translated = addon_table.forever_surface_ui.social.friend_menu(source)
    end
    if not translated or translated == source then return end

    local function initialize(frame, _, menu)
        if runtime.is_secret_value(frame) or runtime.is_secret_value(menu) or not frame or not menu
            or options.can_lookup_section and not options.can_lookup_section("social_ui") then return end
        local ok, region = pcall(function () return frame.fontString end)
        if not ok or runtime.is_secret_value(region) or not region then return end

        -- Native enable checks still run after this initializer. Apply the
        -- display text once those checks and the current layout have finished.
        scheduler.request({ id = "unit-popup-label:" .. tostring(region), work_scope = "menus_ui",
            callback = function ()
                local readable, visible = pcall(function ()
                    local menu_shown, frame_shown = menu:IsVisible(), frame:IsVisible()
                    if runtime.is_secret_value(menu_shown) or runtime.is_secret_value(frame_shown)
                        or not menu_shown or not frame_shown then return end
                    local current_description, current_label = frame:GetElementDescription(), frame.fontString
                    if runtime.is_secret_value(current_description) or runtime.is_secret_value(current_label)
                        or current_description ~= description or current_label ~= region then return end
                    return region:GetText()
                end)
                if readable and runtime.safe_string_or_nil(visible) == source then
                    runtime.apply(region, {
                        owner = "ui", slot = "ui.text", source = source,
                        translated = translated, priority = runtime.PRIORITY.CONTEXT,
                        section = "social_ui", option = "translate_string",
                        defer_if_protected = false, after_apply = fit_menu_label,
                    })
                end
            end,
        })
    end
    if profiler.wrap then initialize = profiler.wrap("menus.unit-popup-label", initialize) end
    if pcall(description.AddInitializer, description, initialize) then
        deferred_unit_labels[description] = true
    end
end

local function reset_menu_label(frame)
    local ok, region = pcall(function () return frame.fontString or frame.Text end)
    if not ok or runtime.is_secret_value(region) or not region then return end
    early_labels[region] = nil
    runtime.invalidate(region)
end
if profiler.wrap then reset_menu_label = profiler.wrap("menus.label.reset", reset_menu_label) end

local function translate_menu_label(region)
    local state = early_labels[region]
    if not state or runtime.is_applying(region) then return end
    local references = state.references
    local frame, expected = references.frame, references.description
    if not frame or not expected then return end
    local policy = state.definition.policy
    local ok_binding, current, description, parent, shown, configuration = pcall(function ()
        return frame.fontString or policy.settings_menu and frame.Text,
            frame:GetElementDescription(), region:GetParent(), region:IsShown(), getmetatable(region)
    end)
    -- ReinitializeAll releases the attachments without calling the row resetter.
    -- The compositor installs a new metatable each time it attaches a label.
    if not ok_binding or runtime.is_secret_value(current) or runtime.is_secret_value(description)
        or runtime.is_secret_value(parent) or runtime.is_secret_value(shown)
        or current ~= region or description ~= expected or parent ~= frame or not shown
        or configuration ~= references.configuration then return end
    if state.policy ~= policy then
        runtime.invalidate(region)
        state.policy = policy
    end
    if options.can_lookup_section and not options.can_lookup_section(policy.section) then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and runtime.safe_string_or_nil(source) or nil
    if not source then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then
        fit_menu_label(region)
        return
    end
    if source ~= state.definition.source and not policy.settings_menu then return end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if policy.names[plain] then return end
    -- Highlight radios may already have a truncated display caption. Resolve
    -- the complete option label retained by their current native description.
    local translated = policy.settings_menu and strings.translate_formatted_region
        and strings.translate_formatted_region(region, state.definition.source, policy)
    if not translated then
        strings.translate_region(region, nil, "ui.action", policy, nil, nil, policy.section)
    end
    claim = runtime.get(region)
    local visible_ok, visible = pcall(region.GetText, region)
    if claim and visible_ok and runtime.safe_string_or_nil(visible) == claim.translated then
        fit_menu_label(region)
    end
end

local function has_custom_menu_regions(frame, label)
    if type(frame.GetRegions) == "function" then
        local ok, regions = pcall(function () return { frame:GetRegions() } end)
        if not ok then return true end
        for _, region in ipairs(regions) do
            if runtime.is_secret_value(region) then return true end
            if region ~= label then
                local kind_ok, kind = pcall(function () return region:GetObjectType() end)
                if not kind_ok or runtime.is_secret_value(kind) or kind == "FontString" then return true end
            end
        end
    end
    if type(frame.GetChildren) == "function" then
        local ok, count = pcall(function () return select("#", frame:GetChildren()) end)
        if not ok or runtime.is_secret_value(count) or count > 0 then return true end
    end
    return false
end

local function prepare_menu_description(_, owner, root)
    if map_adapter.is_minimap_frame(owner) then return end
    local util = _G.MenuUtil
    if not root or not util or type(util.TraverseMenu) ~= "function"
        or type(util.GetElementText) ~= "function" then return end
    local policy = menu_policy(root, owner)
    if not policy then return end
    local parent = owner
    for _ = 1, 12 do
        if not parent or runtime.is_secret_value(parent) then break end
        if parent == _G.SettingsPanel then
            policy.settings_menu, policy.section = true, "game_settings"
            break
        end
        local ok, next_parent = pcall(function () return parent:GetParent() end)
        if not ok or runtime.is_secret_value(next_parent) or next_parent == parent then break end
        parent = next_parent
    end
    local guild = addon_table.use("guild_menus_ui")
    if guild.preserves_owner and guild.preserves_owner(owner) then return end
    local tag_ok, _, context = pcall(function () return root:GetTag() end)
    if tag_ok and not runtime.is_secret_value(context) and type(context) == "table" then
        for _, key in ipairs({ "name", "fullName", "accountName", "battleTag" }) do
            local value_ok, value = pcall(function () return context[key] end)
            value = value_ok and runtime.safe_string_or_nil(value) or nil
            if value then policy.names[value] = true end
        end
    end
    if policy.tag:match("^MENU_UNIT_") then
        -- SELF and PET include protected raid-marker actions. Keep their native
        -- descriptions intact and translate visible labels after the menu opens.
        dev_log.mark_restricted_path("unit-menu", "description-ready "
            .. (policy.tag:match("^MENU_UNIT_[A-Z0-9_]+$") or "MENU_UNIT"))
        local bnet_friend = policy.tag == "MENU_UNIT_BN_FRIEND"
            or policy.tag == "MENU_UNIT_BN_FRIEND_OFFLINE"
        local labels = unit_popup_labels_by_tag[policy.tag]
        util.TraverseMenu(root, function (description)
            unit_popup_descriptions[description] = policy
            if bnet_friend or labels then
                prepare_deferred_unit_label(description, util, labels)
            end
        end)
        return
    end
    util.TraverseMenu(root, function (description)
        local state = prepared_descriptions[description]
        if not state then
            state = {}
            local function initialize(frame, _, menu)
                if not menu or runtime.is_secret_value(menu) then return end
                local coverage = prepared_menus[menu]
                if not coverage or coverage.policy ~= state.policy then
                    coverage = { policy = state.policy }
                    prepared_menus[menu] = coverage
                end
                local ok, region = pcall(function ()
                    return frame and (frame.fontString or state.policy.settings_menu and frame.Text)
                end)
                if not ok or runtime.is_secret_value(region) or not region then
                    -- Dividers and spacers have no labels to translate.
                    if not ok or state.source or not frame
                        or has_custom_menu_regions(frame, nil) then coverage.fallback = true end
                    return
                end
                if has_custom_menu_regions(frame, region) then coverage.fallback = true end
                if not state.source then
                    early_labels[region] = nil
                    coverage.fallback = true
                    return
                end
                local text_ok, native = pcall(region.GetText, region)
                native = text_ok and runtime.safe_string_or_nil(native) or nil
                local claim = runtime.get(region)
                if not state.policy.settings_menu and state.source and native ~= state.source
                    and not (claim and native == claim.translated and claim.source == state.source) then
                    early_labels[region] = nil
                    coverage.fallback = true
                    return
                end
                local previous = early_labels[region]
                local configuration = getmetatable(region)
                if not previous or previous.references.description ~= description
                    or previous.references.configuration ~= configuration
                    or previous.policy ~= state.policy then
                    runtime.invalidate(region)
                end
                early_labels[region] = { policy = state.policy,
                    definition = state,
                    references = setmetatable({ frame = frame, description = description,
                        menu = menu, configuration = configuration }, { __mode = "v" }) }
                hooks.region(region, "SetText", translate_menu_label)
                hooks.region(region, "SetTextToFit", translate_menu_label)
                translate_menu_label(region)
            end
            if profiler.wrap then initialize = profiler.wrap("menus.label.initialize", initialize) end
            if not pcall(description.AddInitializer, description, initialize) then return end
            pcall(description.AddResetter, description, reset_menu_label)
            prepared_descriptions[description] = state
        end
        state.policy = policy
        local source_ok, source = pcall(util.GetElementText, description)
        state.source = source_ok and runtime.safe_string_or_nil(source) or nil
        if policy.settings_menu then
            local ok, label = pcall(function () return description:GetData().label end)
            state.source = ok and runtime.safe_string_or_nil(label) or state.source
        end
    end)
end

local function get_unit_popup_policy(menu)
    local policy
    local ok = pcall(function ()
        menu:EnumerateElementDescriptions(function (_, description)
            if not runtime.is_secret_value(description) then
                policy = policy or unit_popup_descriptions[description]
            end
        end)
    end)
    return ok and policy or nil
end

local function is_unit_popup_label(region, policy)
    local frame = region:GetParent()
    if not frame or runtime.is_secret_value(frame) or frame.fontString ~= region then return false end
    local description = frame:GetElementDescription()
    if runtime.is_secret_value(description) or unit_popup_descriptions[description] ~= policy
        or deferred_unit_labels[description] then
        return false
    end
    local source = runtime.safe_string_or_nil(_G.MenuUtil.GetElementText(description))
    local visible = runtime.safe_string_or_nil(region:GetText())
    if source and visible then
        local claim = runtime.get(region)
        return source == visible or claim and claim.source == source and claim.translated == visible
    end
    return false
end

local function translate_open_menu(_, menu)
    if not menu or runtime.is_secret_value(menu)
        or options.work_enabled and not options.work_enabled("menus_ui") then return end
    local prepared = prepared_menus[menu]
    if prepared and not prepared.fallback then return end
    local function translate()
        local visible_ok, visible = pcall(function () return menu:IsVisible() end)
        if visible_ok and not runtime.is_secret_value(visible) and visible then
            local owner_ok, owner = pcall(function ()
                local direct_owner = menu:GetOwnerRegion()
                if runtime.is_secret_value(direct_owner) or direct_owner then return direct_owner end
                -- Blizzard does not assign the root owner to a submenu.
                local root = _G.Menu.GetManager():GetOpenMenu()
                if not runtime.is_secret_value(root) and root and root ~= menu then
                    return root:GetOwnerRegion()
                end
            end)
            if not owner_ok or runtime.is_secret_value(owner) or map_adapter.is_minimap_frame(owner)
                or addon_table.use("guild_menus_ui").preserves_owner(owner) then return end
            local coverage = prepared_menus[menu]
            if coverage and not coverage.fallback then return end
            local unit_policy = get_unit_popup_policy(menu)
            local policy = unit_policy or coverage and coverage.policy or menu_policy(menu, owner)
            if not policy then return end
            local section = policy.section
            if options.can_lookup_section and not options.can_lookup_section(section) then return end
            if unit_policy or next(policy.names) or coverage then
                local user_layout_names = policy.names
                local walk = {
                    id = menu_walks.modern.id,
                    surface = menu_walks.modern.surface,
                    owner = menu_walks.modern.owner,
                    reason = menu_walks.modern.reason,
                    section = section,
                    skip_font_for_skipped_regions = unit_policy
                        and (unit_policy.tag == "MENU_UNIT_SELF" or unit_policy.tag == "MENU_UNIT_PET"),
                    skip_region = function (region)
                        if unit_policy and not is_unit_popup_label(region, unit_policy) then return true end
                        local state = early_labels[region]
                        if state and state.references.menu == menu then return true end
                        if not region or type(region.GetText) ~= "function" then
                            return false
                        end
                        if policy.settings_menu then
                            local shown = region:IsShown()
                            if runtime.is_secret_value(shown) or not shown then return true end
                        end
                        local ok, value = pcall(region.GetText, region)
                        value = ok and runtime.safe_string_or_nil(value) or nil
                        return value and user_layout_names[value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")] == true
                    end,
                }
                if unit_policy then dev_log.mark_restricted_path("unit-menu", "labels-begin") end
                strings.translate_frame(menu, nil, walk)
                if unit_policy then dev_log.mark_restricted_path("unit-menu", "labels-end") end
                -- Account/character layout names are user data, so rendered
                -- rows from this menu do not belong in the UI text report.
            else
                strings.translate_frame(menu, nil, {
                    id = menu_walks.modern.id, surface = menu_walks.modern.surface,
                    owner = menu_walks.modern.owner, reason = menu_walks.modern.reason,
                    section = section,
                })
                capture_auto_frame(menu)
            end
        end
    end

    scheduler.request({ id = "open-menu:" .. tostring(menu), work_scope = "menus_ui",
        callback = translate })
end

local function clear_closed_menu(_, menu)
    if not menu or runtime.is_secret_value(menu) then return end
    -- Blizzard returns this proxy to the pool after closing the current menu.
    prepared_menus[menu] = nil
    scheduler.cancel("open-menu:" .. tostring(menu))
end

local function register_menu_event(event, handler)
    hooks.once("event:" .. event, function ()
        local events = _G.EventRegistry
        if not events or type(events.RegisterCallback) ~= "function" then return false end
        local callback = profiler.wrap and profiler.wrap("event:" .. event, handler) or handler
        return pcall(events.RegisterCallback, events, event, callback, menus_ui)
    end)
end

local function translate_legacy_dropdown(_, level)
    if options.can_lookup_section and not options.can_lookup_section("game_menu") then return end
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    local function translate()
        local frame = _G["DropDownList" .. level]
        if not frame then return end
        strings.translate_frame(frame, nil, {
            id = menu_walks.legacy.id, surface = menu_walks.legacy.surface,
            owner = menu_walks.legacy.owner, reason = menu_walks.legacy.reason,
            section = "game_menu",
        })
        capture_auto_frame(frame)
    end

    scheduler.request("legacy-dropdown:" .. level, nil, translate)
end

local function translate_gamepad_prompt(prompt)
    local control = prompt and prompt.ControlDescText
    local label = control and control.FontString
    if not label or runtime.is_applying(label) then return end
    if not strings.translate_region(label, nil, "ui.action") then return end
    local width = addon_table.use("translation_layout").safe_dimension(label, "GetStringWidth")
    if width and type(control.SetWidth) == "function" then
        local current = layout.safe_dimension(control, "GetWidth")
        if current and layout.dimensions_match(current, width) then return end
        if runtime.combat_locked() or not runtime.can_write_text(prompt) then return end
        pcall(control.SetWidth, control, width)
        if type(prompt.RefreshInputPromptSize) == "function" then
            pcall(prompt.RefreshInputPromptSize, prompt)
        end
    end
end

local function bind_gamepad_legend(legend)
    if not legend or prepared_legends[legend] then return end
    local ok, prompts, refresh = pcall(function () return legend.promptFrames, legend.RefreshWithPromptedBindings end)
    if not ok or runtime.is_secret_value(prompts) or runtime.is_secret_value(refresh)
        or type(prompts) ~= "table" or type(refresh) ~= "function" then return end
    local function bind_prompts(self)
        local valid, current = pcall(function () return self.promptFrames end)
        if not valid or runtime.is_secret_value(current) or type(current) ~= "table" then return end
        for _, prompt in pairs(current) do
            hooks.region(prompt, "SetPromptText", translate_gamepad_prompt)
            translate_gamepad_prompt(prompt)
        end
    end
    -- Bind newly pooled prompts before RefreshWithPromptedBindings writes
    -- their labels and measures the legend, including the new hold icons.
    prepared_legends[legend] = hooks.region(legend, "GetOrCreatePromptFrameUsingTemplateAndInputs", bind_prompts) == true
    bind_prompts(legend)
    if not runtime.combat_locked() and runtime.can_write_text(legend)
        and type(legend.ApplyDefaultPromptPositioning) == "function" then
        pcall(legend.ApplyDefaultPromptPositioning, legend)
    end
end

local function prepare_gamepad_prompts(roots)
    hooks.region(_G.InputPromptLegends, "CreateInputLegend", function (parent, key)
        bind_gamepad_legend(parent and parent[key])
    end)
    -- These panels can create their footer before UA_Forever loads.
    for _, name in ipairs(roots or { "GameMenuFrame", "WorldMapFrame",
        "ContainerFrameCombinedBags", "ProfessionsFrame", "PlayerSpellsFrame",
        "LegacySystemFrame", "CatalogShopFrame" }) do
        local root = _G[name]
        if root and type(root.GetChildren) == "function" then
            local ok, children = pcall(function () return { root:GetChildren() } end)
            if ok then
                for _, child in ipairs(children) do bind_gamepad_legend(child) end
            end
        end
    end
end

menus_ui.prepare = function (roots)
    prepare_gamepad_prompts(roots)
    declare_game_menu_hook()
    local game_menu = registry.get("game-menu")
    if game_menu then
        game_menu.static = function ()
            translate_game_menu(_G.GameMenuFrame)
        end
    end
    -- Forever 1.60.1 creates the escape menu in GameMenuFrameMixin:InitButtons and
    -- micro-button titles in EvaluateTooltipVisibility. Post-hooks translate
    -- only completed FontStrings; button data and tooltipText stay English.
    -- XML mixins are copied onto frames when the frame is created. The
    -- executable frame-kind declaration therefore hooks the already-created
    -- GameMenuFrame instance; the mixin table is not a second owner.
    hooks.mixin("MainMenuBarMicroButtonMixin", "EvaluateTooltipVisibility", translate_micro_button_tooltip)
    -- MainMenuMicroButton rebuilds the performance tooltip through this
    -- function from OnUpdate, bypassing EvaluateTooltipVisibility entirely.
    hooks.global("MainMenuBarPerformanceBarFrame_OnEnter", translate_micro_button_tooltip)

    -- Observe the completed menu through its event, including untagged
    -- context menus and submenus, without wrapping the native open methods.
    register_menu_event("MenuProxy.OnShow", translate_open_menu)
    register_menu_event("MenuProxy.OnClose", clear_closed_menu)
    hooks.region(_G.Menu, "PopulateDescription", prepare_menu_description)

    hooks.global("UIDropDownMenu_AddButton", translate_legacy_dropdown)
    local game_menu_frame = _G.GameMenuFrame
    hooks.region_script(game_menu_frame, "OnShow", translate_game_menu)
    if roots == nil then
        local ok, visible = pcall(function () return game_menu_frame:IsVisible() end)
        if ok and not runtime.is_secret_value(visible) and visible then translate_game_menu(game_menu_frame) end
    end

    -- Micro buttons are created before third-party addons, so Camelot has
    -- already copied the mixin method onto each instance by this point.
    for _, name in ipairs(micro_button_names) do
        local button = _G[name]
        hooks.region(button, "EvaluateTooltipVisibility",
            translate_micro_button_tooltip)
    end
end
