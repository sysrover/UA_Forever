local _, addon_table = ...

local options = addon_table.use("options")
local items = addon_table.use("items")
local scanner = addon_table.use("scanner")
local settings_ui = addon_table.use("settings_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local tooltips = addon_table.use("tooltips")
local hooks = addon_table.use("translation_hooks").bind("settings")

local tooltip_mode_buttons = {}
local scope_buttons = {}
local name_buttons = {}
local shift_button

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
        local anchor = scope == "custom" and name_buttons.translate_skill_names
            or scope_buttons.custom
        shift_button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT",
            scope == "custom" and -20 or 0, -24)
        shift_button:SetChecked(options.account and options.account.shift_original_tooltip ~= false)
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
    for _, item in ipairs({
        { "translate_item_names", "Назви предметів" },
        { "translate_quest_names", "Назви завдань" },
        { "translate_spell_names", "Назви заклять" },
        { "translate_skill_names", "Назви навичок" },
    }) do
        local button = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
        button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 20, -8)
        button.text:SetFontObject("GameFontHighlight")
        runtime.set_fallback_text(button.text, item[2])
        local key = item[1]
        button:SetScript("OnClick", function (self)
            options.account[key] = self:GetChecked() == true
            refresh_open_text()
        end)
        name_buttons[key] = button
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

local function translate_row(frame)
    if not frame then return end
    translate_region(frame.Text)
    translate_region(frame.Title)
    local control = frame.Control
    translate_region(control and control.Label)
    local dropdown = control and control.Dropdown
    translate_region(dropdown and dropdown.Text)
    if dropdown and type(dropdown.GetFontString) == "function" then
        local ok, region = pcall(dropdown.GetFontString, dropdown)
        if ok then translate_region(region) end
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

local function displayed_category(panel, category)
    translate_panel_chrome(panel)
    schedule_visible_settings(panel)

    if not options.account or not options.account.auto_scan_menus or not category then return end
    local id = category.GetID and category:GetID()
    local key = "settings-category:" .. tostring(id or category)
    scanner.schedule_menu_capture(key, nil, panel)
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
