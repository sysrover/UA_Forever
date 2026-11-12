local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local auto_scan = addon_table.use("auto_scan")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local options = addon_table.use("options")
local hooks = addon_table.use("translation_hooks").bind("menus_ui")
local layout = addon_table.use("translation_layout")
local profiler = addon_table.use("performance_profile")
local prepared_menus = setmetatable({}, { __mode = "k" })
local prepared_descriptions = setmetatable({}, { __mode = "k" })
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

local function menu_policy(menu)
    local section, names = "game_menu", {}
    local ok, tag = pcall(function () return menu:ToDebugString() end)
    tag = ok and runtime.safe_string_or_nil(tag) or nil
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
    return { id = "menus", name_category = "none", section = section,
        names = names, tag = tag or "", defer_if_protected = false }
end

local function fit_menu_label(region)
    if runtime.combat_locked() then return end
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

local function translate_menu_label(region)
    local state = early_labels[region]
    if not state or state.preserve or runtime.is_applying(region) then return end
    local frame, expected = state.references.frame, state.references.description
    if not frame or not expected then return end
    if type(frame.GetElementDescription) == "function" then
        local ok, description = pcall(frame.GetElementDescription, frame)
        if not ok or runtime.is_secret_value(description) or description ~= expected then return end
    end
    local policy = state.definition.policy
    if state.policy ~= policy then
        runtime.invalidate(region)
        state.policy = policy
    end
    if options.can_lookup_section and not options.can_lookup_section(policy.section) then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and runtime.safe_string_or_nil(source) or nil
    local claim = runtime.get(region)
    if claim and source == claim.translated then
        fit_menu_label(region)
        return
    end
    if source ~= state.definition.source then return end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if policy.names[plain] then return end
    strings.translate_region(region, nil, "ui.action", policy, nil, nil, policy.section)
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
    local util = _G.MenuUtil
    if not root or not util or type(util.TraverseMenu) ~= "function"
        or type(util.GetElementText) ~= "function" then return end
    local policy = menu_policy(root)
    if not policy then return end
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
                local ok, region = pcall(function () return frame and frame.fontString end)
                if not ok or runtime.is_secret_value(region) or not region then
                    -- Dividers and spacers have no labels to translate.
                    if not ok or state.source or not frame
                        or has_custom_menu_regions(frame, nil) then coverage.fallback = true end
                    return
                end
                if has_custom_menu_regions(frame, region) then coverage.fallback = true end
                local preserve = not state.source and state.policy.tag:match("^MENU_UNIT_") ~= nil
                if not state.source and not preserve then
                    early_labels[region] = nil
                    coverage.fallback = true
                    return
                end
                local text_ok, native = pcall(region.GetText, region)
                native = text_ok and runtime.safe_string_or_nil(native) or nil
                local claim = runtime.get(region)
                if state.source and native ~= state.source
                    and not (claim and native == claim.translated and claim.source == state.source) then
                    early_labels[region] = nil
                    coverage.fallback = true
                    return
                end
                local previous = early_labels[region]
                if not previous or previous.references.description ~= description or previous.policy ~= state.policy then
                    runtime.invalidate(region)
                end
                early_labels[region] = { policy = state.policy,
                    definition = state, preserve = preserve,
                    references = setmetatable({ frame = frame, description = description,
                        menu = menu }, { __mode = "v" }) }
                hooks.region(region, "SetText", translate_menu_label)
                hooks.region(region, "SetTextToFit", translate_menu_label)
                translate_menu_label(region)
            end
            if profiler.wrap then initialize = profiler.wrap("menus.label.initialize", initialize) end
            if not pcall(description.AddInitializer, description, initialize) then return end
            prepared_descriptions[description] = state
        end
        state.policy = policy
        local source_ok, source = pcall(util.GetElementText, description)
        state.source = source_ok and runtime.safe_string_or_nil(source) or nil
    end)
end

local function open_menu()
    local manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    return manager and type(manager.GetOpenMenu) == "function"
        and manager:GetOpenMenu() or nil
end

local function translate_open_menu()
    local current = open_menu()
    local prepared = current and prepared_menus[current]
    if prepared and not prepared.fallback then return end
    local function translate()
        local menu = open_menu()
        if menu then
            if type(menu.GetOwnerRegion) == "function" then
                local ok, owner = pcall(menu.GetOwnerRegion, menu)
                if ok and not runtime.is_secret_value(owner)
                    and addon_table.use("guild_menus_ui").preserves_owner(owner) then return end
            end
            local policy = menu_policy(menu)
            if not policy then return end
            local section = policy.section
            if options.can_lookup_section and not options.can_lookup_section(section) then return end
            local coverage = prepared_menus[menu]
            if coverage and not coverage.fallback then return end
            if next(policy.names) or coverage then
                local user_layout_names = policy.names
                local walk = {
                    id = menu_walks.modern.id,
                    surface = menu_walks.modern.surface,
                    owner = menu_walks.modern.owner,
                    reason = menu_walks.modern.reason,
                    section = section,
                    skip_region = function (region)
                        local state = early_labels[region]
                        if state and state.references.menu == menu then return true end
                        if not region or type(region.GetText) ~= "function" then
                            return false
                        end
                        local ok, value = pcall(region.GetText, region)
                        value = ok and runtime.safe_string_or_nil(value) or nil
                        return value and user_layout_names[value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")] == true
                    end,
                }
                strings.translate_frame(menu, nil, walk)
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

    scheduler.request("open-menu", nil, translate)
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

    -- Append display initializers before native extent measurement. Keep the
    -- manager fallback for custom controls outside the standard menu labels.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hooks.region(menu_manager, "OpenMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenContextMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenSubmenu", translate_open_menu)
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
