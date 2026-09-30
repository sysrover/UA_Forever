local _, addon_table = ...

local options = addon_table.use("options")
local auto_scan = addon_table.use("auto_scan")
local items = addon_table.use("items")
local settings_ui = addon_table.use("settings_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
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
local SETTINGS_DROPDOWN_WIDTH = 220
local SETTINGS_BUTTON_WIDTH = 200
local SETTINGS_CHROME_BUTTON_WIDTH = 96
local MINIMAL_TAB_PADDING = 40

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

local function safe_method(owner, method, ...)
    if not owner then return nil end
    local ok_method, callback = pcall(function () return owner[method] end)
    if not ok_method or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, owner, ...)
    local secret = type(runtime.is_secret_value) == "function"
        and runtime.is_secret_value(value)
    if ok and not secret then return value end
end

local function safe_source(value)
    if type(runtime.safe_string_or_nil) == "function" then
        return runtime.safe_string_or_nil(value)
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function frame_initializer(frame, supplied)
    local supplied_type = type(supplied)
    if supplied_type == "table" or supplied_type == "userdata" then
        return supplied
    end
    return safe_method(frame, "GetElementData")
end

local function initializer_data(initializer)
    local data = safe_method(initializer, "GetData")
    if data ~= nil then return data end
    local ok, direct = pcall(function () return initializer and initializer.data end)
    return ok and direct or nil
end

local function initializer_name(frame, supplied)
    return safe_method(frame_initializer(frame, supplied), "GetName")
end

local function translate_source_region(region, source, slot, instance, override)
    if not region then return false end
    source = safe_source(source)
    if not source then return translate_region(region, slot, instance) end

    local translated, _, source_kind, category, inferred_slot,
        inferred_option, provenance
    if type(override) == "string" and override ~= "" then
        translated = override
        source_kind = "context"
    elseif type(resolver.find_ui) ~= "function" then
        return translate_region(region, slot, instance)
    else
        translated, _, source_kind, category, inferred_slot,
            inferred_option, provenance = resolver.find_ui(source, region, {
                slot = slot or "ui.text",
            })
    end
    if not translated or translated == source then
        return translate_region(region, slot, instance)
    end

    local surface = ensure_settings_generation()
    return runtime.apply(region, {
        owner = "settings", slot = slot or inferred_slot or "ui.text",
        source = source, translated = translated,
        category = category, option = inferred_option,
        lookup_tier = source_kind,
        catalog_source = provenance and provenance.source,
        surface = surface, phase = "dynamic",
        generation = surface and runtime.generation(surface) or nil,
        instance = tostring(instance or region),
        priority = type(runtime.priority_for_source) == "function"
            and runtime.priority_for_source(source_kind)
            or runtime.PRIORITY.STATIC_UI or runtime.PRIORITY.CONTEXT,
    })
end

local function set_width(frame, width)
    if frame and type(frame.SetWidth) == "function" then
        pcall(frame.SetWidth, frame, width)
    end
end

local function hook_native_region(region, slot, instance)
    if not region then return end
    hooks.region(region, "SetText", function (self, source)
        if type(runtime.is_applying) == "function"
            and runtime.is_applying(self) then return end
        translate_source_region(self, source, slot, instance)
    end)
end

local function translate_dropdown(frame, dropdown)
    if not dropdown then return end
    set_width(dropdown, SETTINGS_DROPDOWN_WIDTH)
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
        return
    end
    translate_source_region(dropdown.Text,
        source_ok and source or nil, "ui.value", frame)
    hook_native_region(dropdown.Text, "ui.value", frame)
end

local function translate_row(frame, supplied_initializer)
    if not frame then return end
    local initializer = frame_initializer(frame, supplied_initializer)
    translate_source_region(frame.Text,
        initializer_name(frame, initializer), "ui.label", frame)
    translate_region(frame.Title, "ui.title", frame)
    translate_region(frame.Label, "ui.label", frame)
    translate_region(frame.text, "ui.text", frame)
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
        if ok and region then
            set_width(button, SETTINGS_BUTTON_WIDTH)
            local source = safe_method(frame, "EvaluateName")
            translate_source_region(region, source, "ui.action", frame)
            hook_native_region(region, "ui.action", frame)
            hooks.region(button, "SetText", function (self, native_source)
                local font_string = safe_method(self, "GetFontString")
                translate_source_region(font_string, native_source,
                    "ui.action", frame)
            end)
        end
    end

    local sub_text = frame.SubTextContainer and frame.SubTextContainer.SubText
    translate_region(sub_text, "ui.text", frame)
    translate_region(frame.PreviewFontString, "ui.label", frame)
    translate_region(frame.PreviewFrame and frame.PreviewFrame.PreviewFontString,
        "ui.label", frame)
    for _, color_frame in ipairs(frame.colorOverrideFrames or {}) do
        translate_region(color_frame and color_frame.Text, "ui.label", color_frame)
    end
end

local function translate_category_button(frame, supplied_initializer)
    if not frame then return end
    local initializer = frame_initializer(frame, supplied_initializer)
    local data = initializer_data(initializer)
    local category = data and data.category
    translate_source_region(frame.Label, safe_method(category, "GetName"),
        "ui.category", frame)
    if type(runtime.ensure_font) == "function" then
        runtime.ensure_font(frame.Label)
    end
end

local function translate_category_header(frame, supplied_initializer)
    if not frame then return end
    local data = initializer_data(frame_initializer(frame, supplied_initializer))
    translate_source_region(frame.Label, data and data.label,
        "ui.category-header", frame)
end

local function translate_search_category(frame, supplied_initializer)
    if not frame then return end
    local data = initializer_data(frame_initializer(frame, supplied_initializer))
    translate_source_region(frame.Title,
        safe_method(data and data.category, "GetQualifiedName"),
        "ui.search-category", frame)
end

local function translate_section_header(frame, supplied_initializer)
    if not frame then return end
    translate_source_region(frame.Title,
        initializer_name(frame, supplied_initializer), "ui.section", frame)
    if frame.Title and type(frame.Title.SetTextToFit) == "function" then
        local text = safe_method(frame.Title, "GetText")
        if text then pcall(frame.Title.SetTextToFit, frame.Title, text) end
    end
end

local function translate_list_element(frame, supplied_initializer)
    if not frame then return end
    translate_source_region(frame.Text,
        initializer_name(frame, supplied_initializer), "ui.label", frame)
end

local function translate_expandable_section(frame, supplied_initializer)
    if not frame then return end
    translate_source_region(frame.Button and frame.Button.Text,
        initializer_name(frame, supplied_initializer), "ui.section", frame)
end

local function translate_keybinding(frame, supplied_initializer)
    if not frame then return end
    local initializer = frame_initializer(frame, supplied_initializer)
    local data = initializer_data(initializer)
    local source
    if data and type(data.bindingIndex) == "number"
        and type(_G.GetBinding) == "function"
        and type(_G.GetBindingName) == "function" then
        local ok, action = pcall(_G.GetBinding, data.bindingIndex)
        if ok and action then
            local name_ok, name = pcall(_G.GetBindingName, action)
            if name_ok then source = name end
        end
    end
    translate_source_region(frame.Label, source, "ui.label", frame)
end

local function translate_keybinding_preface(frame, source_key)
    if not frame then return end
    local source = type(source_key) == "string" and _G[source_key] or nil
    translate_source_region(frame.text, source, "ui.text", frame)
end

local function translate_minimal_tab(tab, slot, instance, override, source_override)
    if not tab then return end
    local region = tab.Text
    translate_source_region(region, source_override or tab.tabText,
        slot, instance or tab, override)
    if region then
        if type(runtime.ensure_font) == "function" then runtime.ensure_font(region) end
        local width = safe_method(region, "GetStringWidth")
        if type(width) == "number" then set_width(tab, width + MINIMAL_TAB_PADDING) end
    end
    for _, method in ipairs({ "OnSelected", "OnEnter", "OnLeave" }) do
        hooks.region(tab, method, function (self)
            translate_minimal_tab(self, slot, instance or self,
                override, source_override)
        end)
    end
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
    translate_minimal_tab(base_tab, "graphics.base-tab", section,
        surface_text.base_tab, "Base")
    translate_minimal_tab(raid_tab, "graphics.raid-tab", section)

    for _, controls in ipairs({ section.BaseQualityControls,
        section.RaidQualityControls }) do
        if controls then
            for _, control in ipairs(controls.Controls or {}) do
                translate_region(control and control.Text, "ui.label", control)
                local dropdown = control and control.Control and control.Control.Dropdown
                if dropdown then
                    set_width(dropdown, SETTINGS_DROPDOWN_WIDTH)
                    translate_source_region(dropdown.Text, dropdown.text,
                        "ui.value", control)
                    hooks.region(dropdown, "UpdateText", function (self)
                        set_width(self, SETTINGS_DROPDOWN_WIDTH)
                        translate_source_region(self.Text, self.text,
                            "ui.value", control)
                    end)
                end
            end
        end
    end
end

local function translate_panel_chrome(panel)
    if not panel then return end
    translate_source_region(panel.NineSlice and panel.NineSlice.Text,
        _G.SETTINGS_TITLE, "ui.title", panel)
    set_width(panel.CloseButton, SETTINGS_CHROME_BUTTON_WIDTH)
    set_width(panel.ApplyButton, SETTINGS_CHROME_BUTTON_WIDTH)
    translate_source_region(panel.CloseButton and panel.CloseButton.Text,
        _G.SETTINGS_CLOSE, "ui.action", panel)
    translate_source_region(panel.ApplyButton and panel.ApplyButton.Text,
        _G.SETTINGS_APPLY, "ui.action", panel)
    translate_minimal_tab(panel.GameTab, "ui.tab", panel)
    translate_minimal_tab(panel.AddOnsTab, "ui.tab", panel)
    local instructions = panel.SearchBox and panel.SearchBox.Instructions
    translate_source_region(instructions,
        panel.SearchBox and panel.SearchBox.instructionText,
        "ui.search-placeholder", panel)

    local container = panel.Container
    local list = container and container.SettingsList
    local header = list and list.Header
    translate_region(header and header.Title, "ui.title", panel)
    hook_native_region(header and header.Title, "ui.title", panel)
    local defaults = header and header.DefaultsButton
    set_width(defaults, SETTINGS_CHROME_BUTTON_WIDTH)
    translate_source_region(defaults and defaults.Text,
        _G.SETTINGS_DEFAULTS, "ui.action", panel)
end

local function translate_visible_categories(panel)
    local category_list = panel and panel.CategoryList
    local scroll_box = category_list and category_list.ScrollBox
    local frames = safe_method(scroll_box, "GetFrames")
    if type(frames) ~= "table" then return end
    for _, frame in ipairs(frames) do
        local initializer = frame_initializer(frame)
        local data = initializer_data(initializer)
        if data and data.category then
            translate_category_button(frame, initializer)
        elseif data and data.label then
            translate_category_header(frame, initializer)
        end
    end
end

local function translate_visible_settings(panel)
    if not panel then return end
    translate_panel_chrome(panel)
    translate_visible_categories(panel)
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
        verifiedBuild = 70058,
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
        { "keybinding", "KeyBindingFrameBindingTemplateMixin",
            translate_keybinding },
        { "keybinding.preface", "SettingsKeybindingPrefaceMixin",
            translate_keybinding_preface },
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
    declare_settings_hook("category.button.state", "mixin",
        "SettingsCategoryListButtonMixin", "UpdateStateInternal",
        translate_category_button)
    declare_settings_hook("checkbox.button.state", "mixin",
        "SettingsCheckboxWithButtonControlMixin", "EvaluateState", translate_row)
    declare_settings_hook("auto-loot.label", "mixin",
        "AutoLootDropdownControlMixin", "UpdateLabel", translate_row)
    declare_settings_hook("list.display", "mixin", "SettingsListMixin",
        "Display", function () schedule_visible_settings(_G.SettingsPanel) end)
    declare_settings_hook("panel.current-category", "frame", "SettingsPanel",
        "SetCurrentCategory", function (panel)
            begin_settings_generation(panel)
        end)
    declare_settings_hook("panel.output", "frame", "SettingsPanel",
        "SetOutputText", function (panel, source)
            translate_source_region(panel.OutputText, source,
                "ui.status", panel)
        end)
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
