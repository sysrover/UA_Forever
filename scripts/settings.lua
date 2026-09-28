local _, addon_table = ...

local options = addon_table.use("options")
local auto_scan = addon_table.use("auto_scan")
local items = addon_table.use("items")
local settings_ui = addon_table.use("settings_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local tooltips = addon_table.use("tooltips")
local map_labels = addon_table.use("map_labels")
local hooks = addon_table.use("translation_hooks").bind("settings")
local addon_locale = assert(addon_table.addon_locale_uk,
    "UA Forever addon locale is not loaded").settings
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").settings

local tooltip_mode_buttons = {}
local scope_buttons = {}
local name_buttons = {}
local shift_button
local auto_scan_button
local auto_scan_diagnostics_button
local export_window
local form_link_window
local FORM_URL = "https://forms.gle/b2oGGebJGTxZsnfn8"

local function show_form_link()
    if not form_link_window then
        local window = CreateFrame("Frame", "UA_ForeverFormLinkWindow", UIParent,
            "BasicFrameTemplateWithInset")
        window:SetSize(530, 170)
        window:SetPoint("CENTER")
        window:SetFrameStrata("FULLSCREEN_DIALOG")
        if window.TitleText then
            runtime.set_fallback_text(window.TitleText, addon_locale.form_title)
        end

        local help = window:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        help:SetPoint("TOPLEFT", 20, -42)
        help:SetWidth(480)
        help:SetJustifyH("LEFT")
        runtime.set_fallback_text(help, addon_locale.form_help)

        local edit = CreateFrame("EditBox", nil, window, "InputBoxTemplate")
        edit:SetSize(475, 28)
        edit:SetPoint("TOP", 0, -83)
        edit:SetAutoFocus(false)
        edit:SetText(FORM_URL)
        edit:SetScript("OnEscapePressed", function () window:Hide() end)

        local select_button = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        select_button:SetSize(215, 25)
        select_button:SetPoint("BOTTOM", 0, 17)
        runtime.set_fallback_text(select_button, addon_locale.select_for_copy)
        select_button:SetScript("OnClick", function ()
            edit:SetFocus()
            edit:HighlightText()
        end)
        window.edit = edit
        form_link_window = window
    end
    form_link_window:Show()
    form_link_window.edit:SetText(FORM_URL)
    form_link_window.edit:SetFocus()
    form_link_window.edit:HighlightText()
end

local function show_export_window()
    if not export_window then
        local window = CreateFrame("Frame", "UA_ForeverExportWindow", UIParent,
            "BasicFrameTemplateWithInset")
        local full_width, full_height = 690, 510
        local collapsed_width, collapsed_height = 330, 34
        window:SetSize(full_width, full_height)
        window:SetPoint("CENTER")
        window:SetFrameStrata("DIALOG")
        window:EnableMouse(true)
        window:SetMovable(true)
        window:RegisterForDrag("LeftButton")
        window:SetScript("OnDragStart", window.StartMoving)
        window:SetScript("OnDragStop", window.StopMovingOrSizing)
        if window.TitleText then
            runtime.set_fallback_text(window.TitleText, addon_locale.scan_data_title)
        end

        local content_frame = CreateFrame("Frame", nil, window)
        content_frame:SetAllPoints(window)

        local help = content_frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        help:SetPoint("TOPLEFT", 18, -38)
        help:SetWidth(475)
        help:SetJustifyH("LEFT")
        runtime.set_fallback_text(help, addon_locale.export_help)

        local performance_text = content_frame:CreateFontString(nil, "ARTWORK",
            "GameFontHighlightSmall")
        performance_text:SetPoint("TOPLEFT", 20, -63)
        performance_text:SetWidth(640)
        performance_text:SetJustifyH("LEFT")

        local form_button = CreateFrame("Button", nil, content_frame,
            "UIPanelButtonTemplate")
        form_button:SetSize(135, 24)
        form_button:SetPoint("TOPRIGHT", -28, -37)
        runtime.set_fallback_text(form_button, addon_locale.form_address)
        form_button:SetScript("OnClick", show_form_link)

        local scroll = CreateFrame("ScrollFrame", nil, content_frame,
            "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 20, -85)
        scroll:SetPoint("BOTTOMRIGHT", -42, 48)
        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(false)
        edit:SetMaxLetters(0)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(610)
        edit:SetHeight(380)
        edit:SetScript("OnEscapePressed", function () window:Hide() end)
        scroll:SetScrollChild(edit)

        local clear = CreateFrame("Button", nil, content_frame,
            "UIPanelButtonTemplate")
        clear:SetSize(135, 24)
        clear:SetPoint("BOTTOMLEFT", 20, 14)
        runtime.set_fallback_text(clear, addon_locale.clear_data)

        local copy = CreateFrame("Button", nil, content_frame,
            "UIPanelButtonTemplate")
        copy:SetSize(190, 24)
        copy:SetPoint("BOTTOMRIGHT", -20, 14)
        runtime.set_fallback_text(copy, addon_locale.select_for_copy)

        local function performance_summary(snapshot)
            if type(snapshot) ~= "table" or not snapshot.available
                or not snapshot.enabled then
                return addon_locale.performance_unavailable
            end
            local current = snapshot.Current or {}
            local average = snapshot.Average or {}
            local peak = snapshot.Peak or {}
            local function value(row, field)
                return type(row[field]) == "string" and row[field] or "—"
            end
            return string.format(addon_locale.performance_addon,
                value(current, "addonCPU"), value(average, "addonCPU"),
                value(peak, "addonCPU"))
        end

        local function refresh(update_report)
            local snapshot
            if type(auto_scan.performance_snapshot) == "function" then
                snapshot = auto_scan.performance_snapshot()
            end
            runtime.set_fallback_text(performance_text,
                performance_summary(snapshot))
            if update_report == false then return end
            local scan_content = auto_scan.export_text()
            local has_data = scan_content ~= ""
            local content = has_data and scan_content or addon_locale.no_export_data
            edit:SetHeight(math.max(380, math.ceil(#content / 65) * 16))
            edit:SetText(content)
            edit:SetCursorPosition(0)
            clear:SetEnabled(has_data)
            copy:SetEnabled(has_data)
            scroll:SetVerticalScroll(0)
        end
        clear:SetScript("OnClick", function ()
            StaticPopupDialogs["UA_FOREVER_CLEAR_AUTO_SCAN"] = {
                text = addon_locale.clear_confirmation,
                button1 = addon_locale.clear,
                button2 = addon_locale.cancel,
                OnAccept = function ()
                    auto_scan.clear()
                    edit:SetText("")
                    refresh()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
            }
            StaticPopup_Show("UA_FOREVER_CLEAR_AUTO_SCAN")
        end)
        copy:SetScript("OnClick", function ()
            refresh()
            edit:SetFocus()
            edit:HighlightText()
        end)

        local collapse = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        collapse:SetSize(24, 20)
        collapse:SetPoint("TOPRIGHT", -30, -4)

        local function set_collapsed(collapsed)
            local left, top = window:GetLeft(), window:GetTop()
            if left and top then
                window:ClearAllPoints()
                window:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
            end
            window.collapsed = collapsed == true
            if window.collapsed then
                content_frame:Hide()
                window:SetSize(collapsed_width, collapsed_height)
                runtime.set_fallback_text(collapse, "+")
            else
                window:SetSize(full_width, full_height)
                content_frame:Show()
                runtime.set_fallback_text(collapse, "-")
            end
        end
        collapse:SetScript("OnClick", function ()
            set_collapsed(not window.collapsed)
        end)
        collapse:SetScript("OnEnter", function (self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:SetText(window.collapsed and addon_locale.expand
                or addon_locale.collapse)
            GameTooltip:Show()
        end)
        collapse:SetScript("OnLeave", function () GameTooltip:Hide() end)
        set_collapsed(false)

        local performance_elapsed = 0
        window:SetScript("OnUpdate", function (_, elapsed)
            if window.collapsed then return end
            performance_elapsed = performance_elapsed + elapsed
            if performance_elapsed < 1 then return end
            performance_elapsed = 0
            refresh(false)
        end)

        window.refresh = refresh
        export_window = window
    end
    export_window.refresh()
    export_window:Show()
end

settings_ui.show_export_window = show_export_window

local function refresh_open_text()
    runtime.refresh_policy()
    if strings.refresh_combat_text_globals then
        strings.refresh_combat_text_globals()
    end
    if items.refresh_quest_rewards then items.refresh_quest_rewards() end
    registry.refresh_open()
    if tooltips.refresh_active then tooltips.refresh_active() end
end

local function refresh_tooltip_mode_controls()
    local mode = options.account and options.account.tooltip_language_mode or "ukrainian"
    for value, button in pairs(tooltip_mode_buttons) do
        button:SetChecked(value == mode)
    end
    local scope = options.account and options.account.translation_scope or "full"
    for value, button in pairs(scope_buttons) do button:SetChecked(value == scope) end
    for key, button in pairs(name_buttons) do
        button:SetChecked(options.account and options.account[key] ~= false)
        if scope == "custom" then button:Show() else button:Hide() end
    end
    if shift_button then
        shift_button:ClearAllPoints()
        local anchor = scope == "custom" and name_buttons.translate_combat_text
            or scope_buttons.custom
        shift_button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT",
            scope == "custom" and -20 or 0, -24)
        shift_button:SetChecked(options.account and options.account.shift_original_tooltip ~= false)
    end
    if auto_scan_button then
        auto_scan_button:SetChecked(options.account
            and options.account.auto_scan_content == true)
    end
    if auto_scan_diagnostics_button then
        auto_scan_diagnostics_button:SetChecked(options.account
            and options.account.auto_scan_diagnostics == true)
    end
end

local function create_tooltip_mode_button(parent, value, label, relative_to, offset_y)
    local button = CreateFrame("CheckButton", nil, parent, "UIRadioButtonTemplate")
    button:SetPoint("TOPLEFT", relative_to, "BOTTOMLEFT", 2, offset_y)
    button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(button.text, label)
    button:SetScript("OnClick", function ()
        options.account.tooltip_language_mode = value
        refresh_tooltip_mode_controls()
        refresh_open_text()
    end)
    tooltip_mode_buttons[value] = button
    return button
end

local function register_addon_settings()
    if settings_ui.category or not Settings
        or type(Settings.RegisterCanvasLayoutCategory) ~= "function"
        or type(Settings.RegisterAddOnCategory) ~= "function" then return end

    -- ClassicUA owns a large legacy options page. Forever intentionally uses a
    -- small native canvas category because this client ships the modern
    -- Settings API and addon categories receive safe ordering from that API.
    local page = CreateFrame("Frame", "UA_ForeverSettingsPanel")
    page:SetSize(700, 600)

    local title = page:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 20, -20)
    runtime.set_fallback_text(title, "UA Forever")

    local description = page:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
    description:SetWidth(620)
    description:SetJustifyH("LEFT")
    runtime.set_fallback_text(description, addon_locale.description)

    local heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    heading:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -24)
    runtime.set_fallback_text(heading, addon_locale.tooltip_format)

    local ukrainian = create_tooltip_mode_button(page, "ukrainian",
        addon_locale.ukrainian_only, heading, -14)
    create_tooltip_mode_button(page, "bilingual",
        addon_locale.bilingual, ukrainian, -12)

    local scope_heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scope_heading:SetPoint("TOPLEFT", ukrainian, "BOTTOMLEFT", -2, -48)
    runtime.set_fallback_text(scope_heading, addon_locale.translation_scope)

    local function scope_button(value, label, anchor, offset)
        local button = CreateFrame("CheckButton", nil, page, "UIRadioButtonTemplate")
        button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 2, offset)
        button.text:SetFontObject("GameFontHighlight")
        runtime.set_fallback_text(button.text, label)
        button:SetScript("OnClick", function ()
            options.account.translation_scope = value
            refresh_tooltip_mode_controls()
            refresh_open_text()
        end)
        scope_buttons[value] = button
        return button
    end
    local full = scope_button("full", addon_locale.full, scope_heading, -14)
    local custom = scope_button("custom", addon_locale.custom, full, -12)

    local previous = custom
    local first_name_button
    for _, item in ipairs({
        { "translate_item_names", addon_locale.item_names },
        { "translate_quest_names", addon_locale.quest_names },
        { "translate_spell_names", addon_locale.spell_names },
        { "translate_skill_names", addon_locale.skill_names },
        { "translate_zone", addon_locale.zone_names },
        { "translate_combat_text", addon_locale.combat_text },
    }) do
        local button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
        button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT",
            first_name_button and 0 or 20, -8)
        button.text:SetFontObject("GameFontHighlight")
        runtime.set_fallback_text(button.text, item[2])
        local key = item[1]
        button:SetScript("OnClick", function (self)
            options.account[key] = self:GetChecked() == true
            refresh_open_text()
            if key == "translate_zone" and map_labels.refresh then
                map_labels.refresh()
            end
            if key == "translate_combat_text"
                and strings.refresh_combat_text_globals then
                strings.refresh_combat_text_globals()
            end
        end)
        name_buttons[key] = button
        first_name_button = first_name_button or button
        previous = button
    end

    shift_button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    shift_button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", -20, -24)
    shift_button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(shift_button.text, addon_locale.shift_original)
    shift_button:SetScript("OnClick", function (self)
        options.account.shift_original_tooltip = self:GetChecked() == true
        refresh_open_text()
    end)

    local scan_heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scan_heading:SetPoint("TOPLEFT", 365, -112)
    runtime.set_fallback_text(scan_heading, addon_locale.scan_heading)

    auto_scan_button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    auto_scan_button:SetPoint("TOPLEFT", scan_heading, "BOTTOMLEFT", 0, -12)
    auto_scan_button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(auto_scan_button.text, addon_locale.auto_scan)
    auto_scan_button:SetScript("OnClick", function (self)
        options.account.auto_scan_content = self:GetChecked() == true
        if options.account.auto_scan_content then
            options.account.auto_scan_menus = false
        end
    end)

    auto_scan_diagnostics_button = CreateFrame("CheckButton", nil, page,
        "UICheckButtonTemplate")
    auto_scan_diagnostics_button:SetPoint("TOPLEFT", auto_scan_button,
        "BOTTOMLEFT", 20, -6)
    auto_scan_diagnostics_button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(auto_scan_diagnostics_button.text,
        addon_locale.auto_scan_diagnostics)
    auto_scan_diagnostics_button:SetScript("OnClick", function (self)
        options.account.auto_scan_diagnostics = self:GetChecked() == true
        if not options.account.auto_scan_diagnostics
            and type(auto_scan.clear_diagnostics) == "function" then
            auto_scan.clear_diagnostics()
        end
    end)

    local scan_help = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    scan_help:SetPoint("TOPLEFT", auto_scan_diagnostics_button, "BOTTOMLEFT", -18, -10)
    scan_help:SetWidth(270)
    scan_help:SetJustifyH("LEFT")
    runtime.set_fallback_text(scan_help, addon_locale.scan_help)

    local export_button = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
    export_button:SetSize(210, 27)
    export_button:SetPoint("TOPLEFT", scan_help, "BOTTOMLEFT", 0, -15)
    runtime.set_fallback_text(export_button, addon_locale.show_export)
    export_button:SetScript("OnClick", show_export_window)

    local form_button = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
    form_button:SetSize(210, 27)
    form_button:SetPoint("TOPLEFT", export_button, "BOTTOMLEFT", 0, -10)
    runtime.set_fallback_text(form_button, addon_locale.submit_form)
    form_button:SetScript("OnClick", show_form_link)

    page.OnRefresh = refresh_tooltip_mode_controls
    page:SetScript("OnShow", refresh_tooltip_mode_controls)

    local ok, category = pcall(Settings.RegisterCanvasLayoutCategory, page, "UA Forever")
    if not ok or not category then return end
    if not pcall(Settings.RegisterAddOnCategory, category) then return end

    settings_ui.page = page
    settings_ui.category = category
    refresh_tooltip_mode_controls()
end

local settings_generation_sequence = 0

local function settings_surface()
    return registry.get("settings")
end

local function begin_settings_generation(panel)
    local surface = settings_surface()
    if not surface then return nil end
    settings_generation_sequence = settings_generation_sequence + 1
    runtime.begin_generation(surface,
        "settings-category:" .. settings_generation_sequence .. ":" .. tostring(panel))
    return surface
end

local function ensure_settings_generation()
    local surface = settings_surface()
    if surface and runtime.generation(surface) <= 0 then
        runtime.begin_generation(surface, "settings-initial")
    end
    return surface
end

local function translate_region(region, slot, instance)
    if not region then return false end
    local surface = ensure_settings_generation()
    if not surface then return false end
    return strings.translate_region(region, nil, slot or "ui.text", surface,
        "dynamic", tostring(instance or region))
end

local function translate_static_region(region, slot)
    if region then
        strings.translate_region(region, nil, slot or "ui.text",
            registry.get("settings"), "static")
    end
end

local function translate_dropdown(frame, dropdown)
    if not dropdown then return end
    local setting_ok, setting = pcall(function () return frame:GetSetting() end)
    local variable_ok, variable = setting_ok and setting and pcall(function ()
        return setting:GetVariable()
    end)
    local source_ok, source = pcall(function () return dropdown.text end)
    if variable_ok and type(variable) == "string"
        and variable:find("UNIT_NAMEPLATES_", 1, true) == 1
        and source_ok and type(source) == "string"
        and source:find(", ", 1, true) then
        local count = 1
        for _ in source:gmatch(", ") do count = count + 1 end
        local region = dropdown.Text
        if region then
            local surface = ensure_settings_generation()
            runtime.apply(region, {
                owner = "settings-nameplates", slot = "nameplate.selection",
                source = source, translated = surface_text.selected(count),
                surface = surface, phase = "dynamic",
                generation = surface and runtime.generation(surface) or nil,
                instance = tostring(frame),
                priority = runtime.PRIORITY.CONTEXT,
            })
        end
        pcall(dropdown.SetWidth, dropdown, 220)
        return
    end
    translate_region(dropdown.Text, "ui.value", frame)
end

local function translate_row(frame)
    if not frame then return end
    translate_region(frame.Text, "ui.label", frame)
    translate_region(frame.Title, "ui.title", frame)
    local control = frame.Control
    translate_region(control and control.Label, "ui.label", frame)
    local dropdown = control and control.Dropdown
    translate_dropdown(frame, dropdown)
    if dropdown and type(dropdown.GetFontString) == "function" then
        local ok, region = pcall(dropdown.GetFontString, dropdown)
        if ok and region ~= dropdown.Text then
            translate_region(region, "ui.value", frame)
        end
    end
    if dropdown then
        hooks.region(dropdown, "UpdateText", function (self)
            translate_dropdown(frame, self)
        end)
    end
    local button = frame.Button
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate_region(region, "ui.action", frame) end
    end
end

local function translate_category_button(frame)
    translate_region(frame and frame.Label, "ui.category", frame)
end

local function translate_category_header(frame)
    translate_region(frame and frame.Label, "ui.category-header", frame)
end

local function translate_search_category(frame)
    translate_region(frame and frame.Title, "ui.search-category", frame)
end

local function translate_section_header(frame)
    translate_region(frame and frame.Title, "ui.section", frame)
end

local function translate_list_element(frame)
    translate_region(frame and frame.Text, "ui.label", frame)
end

local function translate_expandable_section(frame)
    translate_region(frame and frame.Button and frame.Button.Text,
        "ui.section", frame)
end

local function translate_advanced_quality_section(section)
    if not section then return end
    -- This graphics section is one pooled Settings row with its own XML
    -- controls, so the ordinary SettingsListElement hooks never see its labels.
    local regions_ok, regions = pcall(function () return { section:GetRegions() } end)
    if regions_ok then
        for _, region in ipairs(regions) do
            translate_region(region, "ui.label", section)
        end
    end
    local base_tab = section.BaseTab
    local raid_tab = section.RaidTab
    local base_label = base_tab and base_tab.Text
    if base_label then
        local surface = ensure_settings_generation()
        runtime.apply(base_label, { owner = "settings-graphics",
            slot = "graphics.base-tab", source = "Base",
            translated = surface_text.base_tab,
            surface = surface, phase = "dynamic",
            generation = surface and runtime.generation(surface) or nil,
            instance = tostring(section),
            priority = runtime.PRIORITY.CONTEXT })
    end
    translate_region(raid_tab and raid_tab.Text, "graphics.raid-tab", section)

    for _, controls in ipairs({ section.BaseQualityControls,
        section.RaidQualityControls }) do
        if controls then
            for _, control in ipairs(controls.Controls or {}) do
                translate_region(control and control.Text, "ui.label", control)
                local dropdown = control and control.Control and control.Control.Dropdown
                if dropdown then
                    translate_region(dropdown.Text, "ui.value", control)
                    hooks.region(dropdown, "UpdateText", function (self)
                        translate_region(self.Text, "ui.value", control)
                    end)
                end
            end
        end
    end
end

local function translate_panel_chrome(panel)
    if not panel then return end
    translate_static_region(panel.NineSlice and panel.NineSlice.Text, "ui.title")
    translate_static_region(panel.CloseButton and panel.CloseButton.Text, "ui.action")
    translate_static_region(panel.ApplyButton and panel.ApplyButton.Text, "ui.action")

    local container = panel.Container
    local list = container and container.SettingsList
    local header = list and list.Header
    translate_static_region(header and header.Title, "ui.title")
    translate_static_region(header and header.DefaultsButton
        and header.DefaultsButton.Text, "ui.action")
end

local function translate_visible_settings(panel)
    if not panel then return end
    translate_panel_chrome(panel)
    local list = type(panel.GetSettingsList) == "function"
        and panel:GetSettingsList() or nil
    local scroll_box = list and list.ScrollBox
    if not scroll_box or type(scroll_box.GetFrames) ~= "function" then return end
    local ok, frames = pcall(scroll_box.GetFrames, scroll_box)
    if not ok or type(frames) ~= "table" then return end
    for _, frame in ipairs(frames) do
        if frame.BaseQualityControls then
            translate_advanced_quality_section(frame)
        else
            translate_row(frame)
        end
    end
end

local function schedule_visible_settings(panel)
    if not panel then return end
    scheduler.request("settings-visible-rows", nil, function ()
        local ok, shown = pcall(panel.IsShown, panel)
        if ok and shown then translate_visible_settings(panel) end
    end)
end

local function displayed_category(panel)
    begin_settings_generation(panel)
    translate_panel_chrome(panel)
    schedule_visible_settings(panel)
end

local function declare_settings_hook(id, kind, target, method, callback)
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "settings." .. id,
        surface = "settings",
        kind = kind,
        target = target,
        method = method,
        required = true,
        fallbackEvent = "SettingsPanel.DisplayCategory",
        verifiedBuild = 70009,
        callback = callback,
    })
end

local function declare_settings_hooks()
    local init_hooks = {
        { "category.button", "SettingsCategoryListButtonMixin",
            translate_category_button },
        { "category.header", "SettingsCategoryListHeaderMixin",
            translate_category_header },
        { "search.category", "SettingsListSearchCategoryMixin",
            translate_search_category },
        { "section.header", "SettingsListSectionHeaderMixin",
            translate_section_header },
        { "list.element", "SettingsListElementMixin",
            translate_list_element },
        { "expandable.section", "SettingsExpandableSectionMixin",
            translate_expandable_section },
        { "quality.section", "SettingsAdvancedQualitySectionMixin",
            translate_advanced_quality_section },
        { "checkbox.control", "SettingsCheckboxControlMixin", translate_row },
        { "slider.control", "SettingsSliderControlMixin", translate_row },
        { "dropdown.control", "SettingsDropdownControlMixin", translate_row },
        { "button.control", "SettingsButtonControlMixin", translate_row },
        { "color.control", "SettingsColorSwatchControlMixin", translate_row },
        { "checkbox.button", "SettingsCheckboxWithButtonControlMixin",
            translate_row },
        { "checkbox.slider", "SettingsCheckboxSliderControlMixin",
            translate_row },
        { "checkbox.dropdown", "SettingsCheckboxDropdownControlMixin",
            translate_row },
        { "checkbox.color", "SettingsCheckboxWithColorSwatchControlMixin",
            translate_row },
        { "keybinding", "KeyBindingFrameBindingTemplateMixin", translate_row },
    }
    for _, definition in ipairs(init_hooks) do
        declare_settings_hook(definition[1] .. ".init", "mixin",
            definition[2], "Init", definition[3])
    end
    declare_settings_hook("quality.section.tab", "mixin",
        "SettingsAdvancedQualitySectionMixin", "OnTabSelected",
        translate_advanced_quality_section)
    declare_settings_hook("dropdown.control.init-dropdown", "mixin",
        "SettingsDropdownControlMixin", "InitDropdown", translate_row)
    declare_settings_hook("list.display", "mixin", "SettingsListMixin",
        "Display", function () schedule_visible_settings(_G.SettingsPanel) end)
    declare_settings_hook("panel.show", "frame", "SettingsPanel", "OnShow",
        displayed_category)
    declare_settings_hook("panel.category", "frame", "SettingsPanel",
        "DisplayCategory", displayed_category)
end

settings_ui.prepare = function ()
    register_addon_settings()
    local surface = registry.get("settings")
    if surface then
        surface.static = function ()
            translate_visible_settings(_G.SettingsPanel)
        end
    end
    -- These executable declarations correspond directly to the Camelot
    -- 1.60.1 Settings writers. Unknown addon ownership is handled by the
    -- manifest's safe unscoped ADDON_LOADED retry.
    declare_settings_hooks()
    displayed_category(_G.SettingsPanel)
end
