local _, addon_table = ...

local edit_mode = addon_table.use("edit_mode")
local auto_scan = addon_table.use("auto_scan")
local registry = addon_table.use("translation_registry")
local strings = addon_table.use("strings")

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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
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
        verifiedBuild = 70009,
        callback = translate_help_tip,
    })
end

edit_mode.prepare = function ()
    local surface = registry.get("edit-mode")
    if surface then
        surface.skip_region = function (region)
            return region == selected_layout_region()
        end
    end
    declare_hooks()
    local manager = _G.EditModeManagerFrame
    if manager and manager.IsShown then
        local ok, shown = pcall(manager.IsShown, manager)
        if ok and shown then translate_manager() end
    end
end
