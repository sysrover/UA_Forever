local _, addon_table = ...

local options = addon_table.use("options")
local scanner = addon_table.use("scanner")
local settings_ui = addon_table.use("settings_ui")
local strings = addon_table.use("strings")

local hooked = {}
local tooltip_mode_buttons = {}

local function refresh_tooltip_mode_controls()
    local mode = options.account and options.account.tooltip_language_mode or "ukrainian"
    for value, button in pairs(tooltip_mode_buttons) do
        button:SetChecked(value == mode)
    end
end

local function create_tooltip_mode_button(parent, value, label, relative_to, offset_y)
    local button = CreateFrame("CheckButton", nil, parent, "UIRadioButtonTemplate")
    button:SetPoint("TOPLEFT", relative_to, "BOTTOMLEFT", 2, offset_y)
    button.text:SetFontObject("GameFontHighlight")
    button.text:SetText(label)
    button:SetScript("OnClick", function ()
        options.account.tooltip_language_mode = value
        refresh_tooltip_mode_controls()
        if GameTooltip and GameTooltip:IsShown() then GameTooltip:Hide() end
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
    title:SetText("UA Forever")

    local description = page:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
    description:SetWidth(620)
    description:SetJustifyH("LEFT")
    description:SetText("Виберіть спосіб відображення назв предметів і тексту у підказках.")

    local heading = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    heading:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -24)
    heading:SetText("Назви предметів і підказки")

    local ukrainian = create_tooltip_mode_button(page, "ukrainian",
        "Лише українська", heading, -14)
    create_tooltip_mode_button(page, "bilingual",
        "Англійська + українська", ukrainian, -12)

    local note = page:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    note:SetPoint("TOPLEFT", ukrainian, "BOTTOMLEFT", 0, -42)
    note:SetWidth(620)
    note:SetJustifyH("LEFT")
    note:SetText("Зміна застосовується до нових підказок одразу, без перезавантаження інтерфейсу.")

    page.OnRefresh = refresh_tooltip_mode_controls
    page:SetScript("OnShow", refresh_tooltip_mode_controls)

    local ok, category = pcall(Settings.RegisterCanvasLayoutCategory, page, "UA Forever")
    if not ok or not category then return end
    if not pcall(Settings.RegisterAddOnCategory, category) then return end

    settings_ui.page = page
    settings_ui.category = category
    refresh_tooltip_mode_controls()
end

local function hook_owner(owner, key, method, callback)
    local owner_type = type(owner)
    if hooked[key] or (owner_type ~= "table" and owner_type ~= "userdata")
        or type(owner[method]) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end

    local ok = pcall(hooksecurefunc, owner, method, callback)
    if ok then hooked[key] = true end
end

local function hook_mixin(name, method, callback)
    hook_owner(_G[name], name .. "." .. method, method, callback)
end

local function translate_region(region)
    if region then strings.translate_region(region) end
end

local function translate_row(frame)
    if frame then strings.translate_frame(frame) end
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

local function translate_panel_chrome(panel)
    if not panel then return end
    translate_region(panel.NineSlice and panel.NineSlice.Text)
    translate_region(panel.CloseButton and panel.CloseButton.Text)
    translate_region(panel.ApplyButton and panel.ApplyButton.Text)

    local container = panel.Container
    local list = container and container.SettingsList
    local header = list and list.Header
    translate_region(header and header.Title)
    translate_region(header and header.DefaultsButton and header.DefaultsButton.Text)
end

local function displayed_category(panel, category)
    translate_panel_chrome(panel)

    if not options.account or not options.account.auto_scan_menus or not category then return end
    local id = category.GetID and category:GetID()
    local key = "settings-category:" .. tostring(id or category)
    scanner.schedule_menu_capture(key, nil, panel)
end

settings_ui.prepare = function ()
    register_addon_settings()
    -- These hooks correspond directly to the Camelot 1.60.1 Settings mixins.
    -- Blizzard keeps its English category/setting data unchanged; translation
    -- happens only after each recycled row writes its visible FontString.
    hook_mixin("SettingsCategoryListButtonMixin", "Init", translate_category_button)
    hook_mixin("SettingsCategoryListHeaderMixin", "Init", translate_category_header)
    hook_mixin("SettingsListSearchCategoryMixin", "Init", translate_search_category)
    hook_mixin("SettingsListSectionHeaderMixin", "Init", translate_section_header)
    hook_mixin("SettingsListElementMixin", "Init", translate_list_element)
    hook_mixin("SettingsExpandableSectionMixin", "Init", translate_expandable_section)

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
        hook_mixin(name, "Init", translate_row)
    end

    hook_mixin("SettingsPanelMixin", "OnShow", translate_panel_chrome)
    hook_mixin("SettingsPanelMixin", "DisplayCategory", displayed_category)
    hook_owner(_G.SettingsPanel, "SettingsPanel.OnShow", "OnShow", translate_panel_chrome)
    hook_owner(_G.SettingsPanel, "SettingsPanel.DisplayCategory", "DisplayCategory", displayed_category)
    translate_panel_chrome(_G.SettingsPanel)
end
