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

local tooltip_mode_buttons = {}
local scope_buttons = {}
local name_buttons = {}
local shift_button
local auto_scan_button
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
            runtime.set_fallback_text(window.TitleText, "Форма для надсилання даних")
        end

        local help = window:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        help:SetPoint("TOPLEFT", 20, -42)
        help:SetWidth(480)
        help:SetJustifyH("LEFT")
        runtime.set_fallback_text(help,
            "Скопіюйте адресу, відкрийте її в браузері та вставте зібрані дані у форму.")

        local edit = CreateFrame("EditBox", nil, window, "InputBoxTemplate")
        edit:SetSize(475, 28)
        edit:SetPoint("TOP", 0, -83)
        edit:SetAutoFocus(false)
        edit:SetText(FORM_URL)
        edit:SetScript("OnEscapePressed", function () window:Hide() end)

        local select_button = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        select_button:SetSize(215, 25)
        select_button:SetPoint("BOTTOM", 0, 17)
        runtime.set_fallback_text(select_button, "Виділити для Ctrl+C")
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
        window:SetSize(690, 510)
        window:SetPoint("CENTER")
        window:SetFrameStrata("DIALOG")
        window:EnableMouse(true)
        window:SetMovable(true)
        window:RegisterForDrag("LeftButton")
        window:SetScript("OnDragStart", window.StartMoving)
        window:SetScript("OnDragStop", window.StopMovingOrSizing)
        if window.TitleText then
            runtime.set_fallback_text(window.TitleText, "UA Forever: дані автоскана")
        end

        local help = window:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        help:SetPoint("TOPLEFT", 18, -38)
        help:SetWidth(475)
        help:SetJustifyH("LEFT")
        runtime.set_fallback_text(help,
            "Виділіть дані, натисніть Ctrl+C і вставте текст у форму.")

        local form_button = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        form_button:SetSize(135, 24)
        form_button:SetPoint("TOPRIGHT", -28, -37)
        runtime.set_fallback_text(form_button, "Адреса форми")
        form_button:SetScript("OnClick", show_form_link)

        local scroll = CreateFrame("ScrollFrame", nil, window,
            "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 20, -75)
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

        local clear = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        clear:SetSize(135, 24)
        clear:SetPoint("BOTTOMLEFT", 20, 14)
        runtime.set_fallback_text(clear, "Очистити дані")

        local copy = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
        copy:SetSize(190, 24)
        copy:SetPoint("BOTTOMRIGHT", -20, 14)
        runtime.set_fallback_text(copy, "Виділити для Ctrl+C")

        local function refresh()
            local content = auto_scan.export_text()
            local has_data = content ~= ""
            if not has_data then content = "Даних для експорту поки немає." end
            edit:SetHeight(math.max(380, math.ceil(#content / 65) * 16))
            edit:SetText(content)
            edit:SetCursorPosition(0)
            clear:SetEnabled(has_data)
            copy:SetEnabled(has_data)
            scroll:SetVerticalScroll(0)
        end
        clear:SetScript("OnClick", function ()
            StaticPopupDialogs["UA_FOREVER_CLEAR_AUTO_SCAN"] = {
                text = "Очистити всі зібрані дані автоскана? Переконайтеся, що ви вже скопіювали їх.",
                button1 = "Очистити",
                button2 = "Скасувати",
                OnAccept = function ()
                    auto_scan.clear()
                    refresh()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
            }
            StaticPopup_Show("UA_FOREVER_CLEAR_AUTO_SCAN")
        end)
        copy:SetScript("OnClick", function ()
            edit:SetFocus()
            edit:HighlightText()
        end)
        window.refresh = refresh
        export_window = window
    end
    export_window.refresh()
    export_window:Show()
end

local function refresh_open_text()
    runtime.refresh_policy()
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
        local anchor = scope == "custom" and name_buttons.translate_zone
            or scope_buttons.custom
        shift_button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT",
            scope == "custom" and -20 or 0, -24)
        shift_button:SetChecked(options.account and options.account.shift_original_tooltip ~= false)
    end
    if auto_scan_button then
        auto_scan_button:SetChecked(options.account
            and options.account.auto_scan_content == true)
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
    runtime.set_fallback_text(description, "Налаштуйте переклад назв і формат підказок.")

    local heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    heading:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -24)
    runtime.set_fallback_text(heading, "Формат підказки")

    local ukrainian = create_tooltip_mode_button(page, "ukrainian",
        "Лише українська", heading, -14)
    create_tooltip_mode_button(page, "bilingual",
        "Англійська + українська", ukrainian, -12)

    local scope_heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scope_heading:SetPoint("TOPLEFT", ukrainian, "BOTTOMLEFT", -2, -48)
    runtime.set_fallback_text(scope_heading, "Обсяг перекладу")

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
    local full = scope_button("full", "Повний", scope_heading, -14)
    local custom = scope_button("custom", "Налаштовуваний", full, -12)

    local previous = custom
    local first_name_button
    for _, item in ipairs({
        { "translate_item_names", "Назви предметів" },
        { "translate_quest_names", "Назви завдань" },
        { "translate_spell_names", "Назви заклять" },
        { "translate_skill_names", "Назви навичок" },
        { "translate_zone", "Назви локацій" },
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
        end)
        name_buttons[key] = button
        first_name_button = first_name_button or button
        previous = button
    end

    shift_button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    shift_button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", -20, -24)
    shift_button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(shift_button.text,
        "Показувати оригінал підказки під час утримання Shift")
    shift_button:SetScript("OnClick", function (self)
        options.account.shift_original_tooltip = self:GetChecked() == true
        refresh_open_text()
    end)

    local scan_heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scan_heading:SetPoint("TOPLEFT", 365, -112)
    runtime.set_fallback_text(scan_heading, "Збір неперекладених даних")

    auto_scan_button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    auto_scan_button:SetPoint("TOPLEFT", scan_heading, "BOTTOMLEFT", 0, -12)
    auto_scan_button.text:SetFontObject("GameFontHighlight")
    runtime.set_fallback_text(auto_scan_button.text, "Автоскан")
    auto_scan_button:SetScript("OnClick", function (self)
        options.account.auto_scan_content = self:GetChecked() == true
        if options.account.auto_scan_content then
            options.account.auto_scan_menus = false
        end
    end)

    local scan_help = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    scan_help:SetPoint("TOPLEFT", auto_scan_button, "BOTTOMLEFT", 2, -10)
    scan_help:SetWidth(270)
    scan_help:SetJustifyH("LEFT")
    runtime.set_fallback_text(scan_help,
        "Предмети, діалоги та імена NPC, квести, навички, закляття, аури й вислови NPC.")

    local export_button = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
    export_button:SetSize(210, 27)
    export_button:SetPoint("TOPLEFT", scan_help, "BOTTOMLEFT", 0, -15)
    runtime.set_fallback_text(export_button, "Показати зібрані дані")
    export_button:SetScript("OnClick", show_export_window)

    local form_button = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
    form_button:SetSize(210, 27)
    form_button:SetPoint("TOPLEFT", export_button, "BOTTOMLEFT", 0, -10)
    runtime.set_fallback_text(form_button, "Форма для надсилання")
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

local function translate_region(region)
    if region then strings.translate_region(region) end
end

local function translate_static_region(region)
    if region then
        strings.translate_region(region, nil, nil,
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
            runtime.apply(region, {
                owner = "settings-nameplates", slot = "nameplate.selection",
                source = source, translated = "Вибрано: " .. count,
                priority = runtime.PRIORITY.CONTEXT,
            })
        end
        pcall(dropdown.SetWidth, dropdown, 220)
        return
    end
    translate_region(dropdown.Text)
end

local function translate_row(frame)
    if not frame then return end
    translate_region(frame.Text)
    translate_region(frame.Title)
    local control = frame.Control
    translate_region(control and control.Label)
    local dropdown = control and control.Dropdown
    translate_dropdown(frame, dropdown)
    if dropdown and type(dropdown.GetFontString) == "function" then
        local ok, region = pcall(dropdown.GetFontString, dropdown)
        if ok and region ~= dropdown.Text then translate_region(region) end
    end
    if dropdown then
        hooks.region(dropdown, "UpdateText", function (self)
            translate_dropdown(frame, self)
        end)
    end
    local button = frame.Button
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate_region(region) end
    end
end

local function translate_category_button(frame)
    translate_region(frame and frame.Label)
end

local function translate_category_header(frame)
    translate_region(frame and frame.Label)
end

local function translate_search_category(frame)
    translate_region(frame and frame.Title)
end

local function translate_section_header(frame)
    translate_region(frame and frame.Title)
end

local function translate_list_element(frame)
    translate_region(frame and frame.Text)
end

local function translate_expandable_section(frame)
    translate_region(frame and frame.Button and frame.Button.Text)
end

local function translate_advanced_quality_section(section)
    if not section then return end
    -- This graphics section is one pooled Settings row with its own XML
    -- controls, so the ordinary SettingsListElement hooks never see its labels.
    local regions_ok, regions = pcall(function () return { section:GetRegions() } end)
    if regions_ok then
        for _, region in ipairs(regions) do translate_region(region) end
    end
    local base_tab = section.BaseTab
    local raid_tab = section.RaidTab
    local base_label = base_tab and base_tab.Text
    if base_label then
        runtime.apply(base_label, { owner = "settings-graphics",
            slot = "graphics.base-tab", source = "Base", translated = "Основні",
            priority = runtime.PRIORITY.CONTEXT })
    end
    translate_region(raid_tab and raid_tab.Text)

    for _, controls in ipairs({ section.BaseQualityControls,
        section.RaidQualityControls }) do
        if controls then
            for _, control in ipairs(controls.Controls or {}) do
                translate_region(control and control.Text)
                local dropdown = control and control.Control and control.Control.Dropdown
                if dropdown then
                    translate_region(dropdown.Text)
                    hooks.region(dropdown, "UpdateText", function (self)
                        translate_region(self.Text)
                    end)
                end
            end
        end
    end
end

local function translate_panel_chrome(panel)
    if not panel then return end
    translate_static_region(panel.NineSlice and panel.NineSlice.Text)
    translate_static_region(panel.CloseButton and panel.CloseButton.Text)
    translate_static_region(panel.ApplyButton and panel.ApplyButton.Text)

    local container = panel.Container
    local list = container and container.SettingsList
    local header = list and list.Header
    translate_static_region(header and header.Title)
    translate_static_region(header and header.DefaultsButton and header.DefaultsButton.Text)
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
            hooks.region(frame, "Init", translate_advanced_quality_section)
            hooks.region(frame, "OnTabSelected", translate_advanced_quality_section)
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
    translate_panel_chrome(panel)
    schedule_visible_settings(panel)
end

settings_ui.prepare = function ()
    register_addon_settings()
    local surface = registry.get("settings")
    if surface then
        surface.static = function ()
            translate_visible_settings(_G.SettingsPanel)
        end
    end
    -- These hooks correspond directly to the Camelot 1.60.1 Settings mixins.
    -- Blizzard keeps its English category/setting data unchanged; translation
    -- happens only after each recycled row writes its visible FontString.
    hooks.mixin("SettingsCategoryListButtonMixin", "Init", translate_category_button)
    hooks.mixin("SettingsCategoryListHeaderMixin", "Init", translate_category_header)
    hooks.mixin("SettingsListSearchCategoryMixin", "Init", translate_search_category)
    hooks.mixin("SettingsListSectionHeaderMixin", "Init", translate_section_header)
    hooks.mixin("SettingsListElementMixin", "Init", translate_list_element)
    hooks.mixin("SettingsExpandableSectionMixin", "Init", translate_expandable_section)
    hooks.mixin("SettingsAdvancedQualitySectionMixin", "Init",
        translate_advanced_quality_section)
    hooks.mixin("SettingsAdvancedQualitySectionMixin", "OnTabSelected",
        translate_advanced_quality_section)

    for _, name in ipairs({
        "SettingsCheckboxControlMixin",
        "SettingsSliderControlMixin",
        "SettingsDropdownControlMixin",
        "SettingsButtonControlMixin",
        "SettingsColorSwatchControlMixin",
        "SettingsCheckboxWithButtonControlMixin",
        "SettingsCheckboxSliderControlMixin",
        "SettingsCheckboxDropdownControlMixin",
        "SettingsCheckboxWithColorSwatchControlMixin",
        "KeyBindingFrameBindingTemplateMixin",
    }) do
        hooks.mixin(name, "Init", translate_row)
    end
    hooks.mixin("SettingsDropdownControlMixin", "InitDropdown", translate_row)

    hooks.mixin("SettingsPanelMixin", "OnShow", translate_panel_chrome)
    hooks.mixin("SettingsPanelMixin", "DisplayCategory", displayed_category)
    hooks.mixin("SettingsListMixin", "Display", function ()
        schedule_visible_settings(_G.SettingsPanel)
    end)
    hooks.region(_G.SettingsPanel, "OnShow", translate_panel_chrome)
    hooks.region(_G.SettingsPanel, "DisplayCategory", displayed_category)
    schedule_visible_settings(_G.SettingsPanel)
    translate_panel_chrome(_G.SettingsPanel)
end
