local _, addon_table = ...

local edit_mode = addon_table.use("edit_mode")
local auto_scan = addon_table.use("auto_scan")
local registry = addon_table.use("translation_registry")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("edit-mode")
local option_titles = { "FramesTitle", "CombatTitle", "MiscTitle" }

local function read_region_method(region, method)
    local ok, value = pcall(function () return region[method](region) end)
    if ok and not runtime.is_secret_value(value) then return value end
end

local function translate_option_label(check_button, surface)
    if read_region_method(check_button, "IsVisible") ~= true then return end
    local label = check_button.Label
    if not label then return end
    strings.translate_region(label, nil, nil, surface)

    local claim = runtime.get(label)
    if claim and claim.surface == surface and not claim.visible_original
        and read_region_method(label, "GetText") == claim.translated
        and read_region_method(label, "CanWordWrap") == false
        and read_region_method(label, "IsTruncated") == true
        and not runtime.combat_locked() and runtime.can_write_text(label) then
        -- Use the second line within the native row; the column width stays fixed.
        pcall(function () label:SetWordWrap(true) end)
    end
end

local function translate_account_options(settings)
    local surface = registry.get("edit-mode")
    local container = settings and settings.SettingsContainer
    if not surface or not container or read_region_method(container, "IsVisible") ~= true then return end

    -- LayoutSettings reparents these controls into the scroll child's grids.
    -- Some debug names also match unit-frame exclusions in the generic walker.
    for _, check_button in pairs(settings.settingsCheckButtons or {}) do
        translate_option_label(check_button, surface)
    end

    local advanced = container.ScrollChild and container.ScrollChild.AdvancedOptionsContainer
    if advanced and read_region_method(advanced, "IsVisible") == true then
        for _, key in ipairs(option_titles) do
            local heading = advanced[key]
            if heading then strings.translate_region(heading.Title, nil, nil, surface) end
        end
    end
end

local function refresh_manager_options(_, roots)
    if roots and not roots.EditModeManagerFrame then return end
    local manager = _G.EditModeManagerFrame
    translate_account_options(manager and manager.AccountSettings)
end

local function translate_frame(frame)
    local surface = registry.get("edit-mode")
    if not frame or not surface then return end
    strings.translate_frame(frame, surface)
end

local function discard_user_layout_names()
    if type(auto_scan.discard_ui) ~= "function" then return end
    local manager = _G.EditModeManagerFrame
    local layout_info = manager and manager.layoutInfo
    local layouts = layout_info and layout_info.layouts
    local types = _G.Enum and _G.Enum.EditModeLayoutType
    if type(layouts) ~= "table" or type(types) ~= "table" then return end
    for _, info in ipairs(layouts) do
        local layout_type = info and info.layoutType
        if layout_type == types.Account or layout_type == types.Character then
            local name = info.layoutName
            if type(name) == "string" and name ~= "" then
                auto_scan.discard_ui(name)
            end
        end
    end
end

local function translate_manager()
    discard_user_layout_names()
    translate_frame(_G.EditModeManagerFrame)
end

local function translate_settings_dialog(dialog)
    translate_frame(dialog or _G.EditModeSystemSettingsDialog)
end

local function translate_layout_dialog(dialog)
    translate_frame(dialog)
end

local function translate_system_selection(selection)
    local surface = registry.get("edit-mode")
    if not selection or not surface then return end
    strings.translate_region(selection.Label, nil, "ui.label", surface)
    strings.translate_region(selection.HorizontalLabel, nil, "ui.label", surface)
    strings.translate_region(selection.VerticalLabel, nil, "ui.label", surface)
end

local function translate_help_tip(frame)
    local info = frame and frame.info
    if info and info.system == "EditMode" then translate_frame(frame) end
end

local function selected_layout_region()
    local manager = _G.EditModeManagerFrame
    local dropdown = manager and manager.LayoutDropdown
    if not dropdown then return nil end
    if dropdown.Text then return dropdown.Text end
    if type(dropdown.GetFontString) == "function" then
        local ok, region = pcall(dropdown.GetFontString, dropdown)
        if ok then return region end
    end
end

local function declare_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "edit-mode.manager.expanded-state",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeAccountSettingsMixin",
        method = "SetExpandedState",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeManagerFrame.OnShow",
        verifiedBuild = 70205,
        callback = translate_manager,
    })
    registry.declare_hook({
        id = "edit-mode.manager.dropdown-options",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeManagerFrameMixin",
        method = "UpdateDropdownOptions",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeManagerFrame.OnShow",
        verifiedBuild = 70205,
        callback = translate_manager,
    })
    registry.declare_hook({
        id = "edit-mode.system-settings.update",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeSystemSettingsDialogMixin",
        method = "UpdateDialog",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeSystemSettingsDialog.OnShow",
        verifiedBuild = 70205,
        callback = translate_settings_dialog,
    })
    registry.declare_hook({
        id = "edit-mode.layout-dialog.setup",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeLayoutDialogMixin",
        method = "SetupControlsForMode",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeLayoutDialog.OnShow",
        verifiedBuild = 70205,
        callback = translate_layout_dialog,
    })
    registry.declare_hook({
        id = "edit-mode.import-dialog.setup",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeImportLayoutDialogMixin",
        method = "SetupControlsForMode",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeImportLayoutDialog.OnShow",
        verifiedBuild = 70205,
        callback = translate_layout_dialog,
    })
    registry.declare_hook({
        id = "edit-mode.unsaved-dialog.show",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeUnsavedChangesDialogMixin",
        method = "ShowDialog",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeUnsavedChangesDialog.OnShow",
        verifiedBuild = 70205,
        callback = translate_layout_dialog,
    })
    registry.declare_hook({
        id = "edit-mode.system-selection.label",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeSystemSelectionMixin",
        method = "UpdateLabelVisibility",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeManagerFrame.OnShow",
        verifiedBuild = 70205,
        callback = translate_system_selection,
    })
    registry.declare_hook({
        id = "edit-mode.system-selection.double-label",
        surface = "edit-mode",
        kind = "mixin",
        target = "EditModeSystemSelectionDoubleLabelMixin",
        method = "UpdateLabelVisibility",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeManagerFrame.OnShow",
        verifiedBuild = 70205,
        callback = translate_system_selection,
    })
    registry.declare_hook({
        id = "edit-mode.help-tip.apply-text",
        surface = "edit-mode",
        kind = "mixin",
        target = "HelpTipTemplateMixin",
        method = "ApplyText",
        blizzardAddon = "Blizzard_EditMode",
        required = true,
        fallbackEvent = "EditModeManagerTutorialMixin.ShowHelpTip",
        verifiedBuild = 70205,
        callback = translate_help_tip,
    })
end

edit_mode.prepare = function ()
    local surface = registry.get("edit-mode")
    if surface then
        surface.skip_region = function (region)
            return region == selected_layout_region()
        end
        surface.dynamic = refresh_manager_options
    end
    declare_hooks()
    local manager = _G.EditModeManagerFrame
    local settings = manager and manager.AccountSettings
    -- XML has already copied the mixins onto these frames. Observe the live
    -- writers as well, including the new gamepad action-bar selection.
    hooks.region(manager, "UpdateDropdownOptions", translate_manager)
    hooks.region(settings, "SetExpandedState", translate_manager)
    hooks.region(settings, "LayoutSettings", translate_account_options)
    hooks.region_script(manager, "OnShow", refresh_manager_options)
    local function translate_live_option(check_button)
        local current_surface = registry.get("edit-mode")
        if current_surface then translate_option_label(check_button, current_surface) end
    end
    local check_buttons = settings and settings.settingsCheckButtons
    for _, check_button in pairs(check_buttons or {}) do
        -- The native display update replaces the label's font on show and after Shift-click.
        hooks.region(check_button, "UpdateDisplay", translate_live_option)
    end
    hooks.region(check_buttons and check_buttons.StatusTrackingBar2, "SetLabelText", translate_live_option)
    hooks.region(_G.EditModeSystemSettingsDialog, "UpdateDialog", translate_settings_dialog)
    hooks.region(_G.EditModeLayoutDialog, "SetupControlsForMode", translate_layout_dialog)
    hooks.region(_G.EditModeImportLayoutDialog, "SetupControlsForMode", translate_layout_dialog)
    hooks.region(_G.EditModeUnsavedChangesDialog, "ShowDialog", translate_layout_dialog)
    local function bind_system(_, system)
        local selection = system and system.Selection
        hooks.region(selection, "UpdateLabelVisibility", translate_system_selection)
        translate_system_selection(selection)
    end
    hooks.region(manager, "RegisterSystemFrame", bind_system)
    for _, system in ipairs(manager and manager.registeredSystemFrames or {}) do
        bind_system(manager, system)
    end
    if manager and manager.IsShown then
        local ok, shown = pcall(manager.IsShown, manager)
        if ok and shown then
            translate_manager()
            translate_account_options(settings)
        end
    end
end
