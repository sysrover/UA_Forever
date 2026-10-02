local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local auto_scan = addon_table.use("auto_scan")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("menus_ui")

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

    -- GameMenuFrame is protected in Camelot, so the generic recursive walker
    -- intentionally refuses it. Its public display surface is small and
    -- stable: one header FontString and the FontString of each pooled button.
    -- Touch only those completed display regions and leave button data,
    -- callbacks, ordering, and secure descendants unchanged.
    local header = frame.Header
    strings.translate_region(header and header.Text, nil, "ui.title",
        surface, "dynamic", instance)
    if header and type(header.UpdateWidth) == "function" then
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
                    strings.fit_button_to_text(button, font_string)
                    local width_ok, width = pcall(button.GetWidth, button)
                    if width_ok and type(width) == "number" then
                        widest_button = math.max(widest_button, width)
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
        verifiedBuild = 70058,
        callback = translate_game_menu,
    })
end

local function translate_micro_button_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip.GetOwner or tooltip:GetOwner() ~= button then return end
    if tooltips.finalize then tooltips.finalize(tooltip) end
end

local function is_edit_mode_layout_menu(menu)
    if not menu then return false end
    local manager = _G.EditModeManagerFrame
    local dropdown = manager and manager.LayoutDropdown
    if dropdown and type(menu.GetOwnerRegion) == "function" then
        local ok, owner = pcall(menu.GetOwnerRegion, menu)
        if ok and owner == dropdown then return true end
    end
    if type(menu.ToDebugString) == "function" then
        local ok, tag = pcall(menu.ToDebugString, menu)
        if ok and tag == "MENU_EDIT_MODE_MANAGER" then return true end
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

local function translate_open_menu()
    local function translate()
        local manager = _G.Menu and type(_G.Menu.GetManager) == "function"
            and _G.Menu.GetManager() or nil
        local menu = manager and type(manager.GetOpenMenu) == "function"
            and manager:GetOpenMenu() or nil
        if menu then
            if is_edit_mode_layout_menu(menu) then
                local user_layout_names = edit_mode_user_layout_names()
                local walk = {
                    id = menu_walks.modern.id,
                    surface = menu_walks.modern.surface,
                    owner = menu_walks.modern.owner,
                    reason = menu_walks.modern.reason,
                    skip_region = function (region)
                        if not region or type(region.GetText) ~= "function" then
                            return false
                        end
                        local ok, value = pcall(region.GetText, region)
                        return ok and type(value) == "string"
                            and user_layout_names[value] == true
                    end,
                }
                strings.translate_frame(menu, nil, walk)
                -- Account/character layout names are user data, so rendered
                -- rows from this menu do not belong in the UI text report.
            else
                strings.translate_frame(menu, nil, menu_walks.modern)
                capture_auto_frame(menu)
            end
        end
    end

    scheduler.request("open-menu", nil, translate)
end

local function translate_legacy_dropdown(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    local function translate()
        local frame = _G["DropDownList" .. level]
        if not frame then return end
        strings.translate_frame(frame, nil, menu_walks.legacy)
        capture_auto_frame(frame)
    end

    scheduler.request("legacy-dropdown:" .. level, nil, translate)
end

menus_ui.prepare = function ()
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

    -- Modern dropdowns and context menus are anonymous pooled frames. Hook the
    -- public manager and translate only the completed menu returned as open.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hooks.region(menu_manager, "OpenMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenContextMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenSubmenu", translate_open_menu)

    hooks.global("UIDropDownMenu_AddButton", translate_legacy_dropdown)
    local game_menu_frame = _G.GameMenuFrame
    hooks.region_script(game_menu_frame, "OnShow", translate_game_menu)
    translate_game_menu(game_menu_frame)

    -- Micro buttons are created before third-party addons, so Camelot has
    -- already copied the mixin method onto each instance by this point.
    for _, name in ipairs({
        "CharacterMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton",
        "SpellbookMicroButton", "TalentMicroButton",
        "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton",
        "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton",
        "StoreMicroButton", "MainMenuMicroButton", "HelpMicroButton",
    }) do
        local button = _G[name]
        hooks.region(button, "EvaluateTooltipVisibility",
            translate_micro_button_tooltip)
    end
end
