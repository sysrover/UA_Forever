local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")
local walker = addon_table.use("translation_walker")
local hooks = addon_table.use("translation_hooks").bind("menus")

local function capture_auto_frame(frame)
    if frame and options.account and options.account.auto_scan_content
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(frame)
    end
end

local function translate_and_capture_frame(frame)
    if not frame then return end
    if type(strings.translate_frame) == "function" then strings.translate_frame(frame) end
    capture_auto_frame(frame)
end

local function translate_game_menu(frame)
    if not frame then return end

    -- GameMenuFrame is protected in Camelot, so the generic recursive walker
    -- intentionally refuses it. Its public display surface is small and
    -- stable: one header FontString and the FontString of each pooled button.
    -- Touch only those completed display regions and leave button data,
    -- callbacks, ordering, and secure descendants unchanged.
    local header = frame.Header
    strings.translate_region(header and header.Text, nil, nil,
        registry.get("game-menu"), "static")
    if header and type(header.UpdateWidth) == "function" then
        pcall(header.UpdateWidth, header)
    end

    if type(frame.buttons) == "table" then
        local widest_button = 0
        for _, button in ipairs(frame.buttons) do
            if button and type(button.GetFontString) == "function" then
                local ok, font_string = pcall(button.GetFontString, button)
                if ok then
                    strings.translate_region(font_string, nil, nil,
                        registry.get("game-menu"), "static")
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

local original_mail_widths = setmetatable({}, { __mode = "k" })

local function widen_mail_region(region, extra_width)
    if not region or type(region.GetWidth) ~= "function"
        or type(region.SetWidth) ~= "function" then return end
    local width = original_mail_widths[region]
    if not width then
        local ok, measured = pcall(region.GetWidth, region)
        if not ok or type(measured) ~= "number" or measured <= 0 then return end
        width = measured
        original_mail_widths[region] = width
    end
    pcall(region.SetWidth, region, width + extra_width)
end

local function widen_mail_frame()
    local mail = _G.MailFrame
    if not mail or type(mail.GetWidth) ~= "function"
        or type(mail.SetWidth) ~= "function" then return end
    if not original_mail_widths[mail] then
        local ok, width = pcall(mail.GetWidth, mail)
        if not ok or type(width) ~= "number" or width <= 0 then return end
        original_mail_widths[mail] = width
    end
    local original_width = original_mail_widths[mail]
    local extra_width = math.floor(original_width * 1.1 + 0.5) - original_width
    widen_mail_region(mail, extra_width)
    for _, name in ipairs({
        "SendMailScrollFrame", "SendMailScrollChildFrame",
        "SendMailBodyEditBox", "SendStationeryBackgroundLeft",
        "SendMailSubjectEditBox", "SendMailHorizontalBarLeft",
        "SendMailHorizontalBarLeft2", "InboxFrameBg",
    }) do
        widen_mail_region(_G[name], extra_width)
    end
    for index = 1, 7 do
        local row = _G["MailItem" .. index]
        widen_mail_region(row, extra_width)
        if row and type(row.GetRegions) == "function" then
            local ok, _, background, divider = pcall(row.GetRegions, row)
            if ok then
                widen_mail_region(background, extra_width)
                widen_mail_region(divider, extra_width)
            end
        end
        widen_mail_region(_G["MailItem" .. index .. "Subject"], extra_width)
    end
end

local function translate_mail_region(region)
    if region and not runtime.is_applying(region) then
        strings.translate_region(region)
    end
end

local function translate_mail_tab()
    local tab = _G.MailFrameTab2
    local label = tab and tab.Text
    translate_mail_region(label)
    if not label or type(label.GetUnboundedStringWidth) ~= "function"
        or type(label.SetWidth) ~= "function" then return end
    local ok, width = pcall(label.GetUnboundedStringWidth, label)
    if not ok or type(width) ~= "number" or width <= 0 then return end
    label:SetWidth(math.ceil(width + 4))
end

local function update_inbox_controls()
    widen_mail_frame()
    strings.translate_region(_G.OpenAllMailText)
    translate_mail_region(_G.MailFrameTitleText)
    translate_mail_region(_G.SendMailMoneyText)
    translate_mail_tab()
end

local function translate_micro_button_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip.GetOwner or tooltip:GetOwner() ~= button then return end
    if tooltips.finalize then tooltips.finalize(tooltip) end
end

local function translate_open_menu()
    local function translate()
        local manager = _G.Menu and type(_G.Menu.GetManager) == "function"
            and _G.Menu.GetManager() or nil
        local menu = manager and type(manager.GetOpenMenu) == "function"
            and manager:GetOpenMenu() or nil
        if menu then
            strings.translate_frame(menu)
            capture_auto_frame(menu)
        end
    end

    scheduler.request("open-menu", nil, translate)
end

local function translate_legacy_dropdown(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    local function translate()
        local frame = _G["DropDownList" .. level]
        if not frame then return end
        strings.translate_frame(frame)
        capture_auto_frame(frame)
        local owner = _G.UIDROPDOWNMENU_OPEN_MENU
        local name_ok, name = owner and pcall(owner.GetDebugName, owner)
        if name_ok and type(name) == "string"
            and name:find("LFGWhoListFrame.FilterDropdown", 1, true) then
            walker.walk(frame, function (region)
                strings.translate_region(region)
            end, nil, { frames = 0 })
        end
    end

    scheduler.request("legacy-dropdown:" .. level, nil, translate)
end

local function translate_lfg_frame(frame)
    local root = _G.LFGListFrame
    local entry = root and root.EntryCreation or frame
    if not entry then return end
    local surface = registry.get("lfg")
    local function translate_static(region)
        if region then strings.translate_region(region, nil, nil, surface, "static") end
    end
    translate_static(entry.Label)
    translate_static(entry.Name and entry.Name.Instructions)
    translate_static(entry.ItemLevel and entry.ItemLevel.EditBox
        and entry.ItemLevel.EditBox.Instructions)
    translate_static(entry.CrossFactionGroup and entry.CrossFactionGroup.Label)
    local button = entry.ListGroupButton
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate_static(region) end
    end
    -- Edit mode replaces this placeholder with a quest-specific description.
    -- Keep it dynamic so the quest owner can claim the reused region.
    strings.translate_region(entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions, nil, nil, surface, "dynamic")
end

local function translate_lfg_activity_button(button)
    if not button then return end
    if type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok and font_string and font_string.GetText then
            local text_ok, source = pcall(font_string.GetText, font_string)
            if text_ok and type(source) == "string" then
                runtime.clear(font_string)
                local translated, _, kind, _, _, option =
                    resolver.find_ui(source, font_string)
                if translated then
                    local id_ok, activity_id = pcall(function ()
                        return button.activityID or (button.info and button.info.activityID)
                    end)
                    local secret = false
                    if type(_G.issecretvalue) == "function" then
                        local secret_ok, value = pcall(_G.issecretvalue, activity_id)
                        secret = not secret_ok or value
                    end
                    local slot = id_ok and not secret and type(activity_id) == "number"
                        and "activity:" .. activity_id or "activity.name"
                    runtime.apply(font_string, { owner = "lfg", slot = slot,
                        source = source, translated = translated,
                        option = option,
                        priority = kind == "domain" and runtime.PRIORITY.DOMAIN
                            or runtime.PRIORITY.CONTEXT })
                end
            end
        end
    end
end

local function translate_lfg_listing_zone(region)
    if not region or runtime.is_applying(region) then return end
    local name_ok, name = pcall(region.GetDebugName, region)
    if not name_ok or type(name) ~= "string"
        or not name:find("LFGListingFrameActivityViewScrollBoxNameButtonName", 1, true) then
        return
    end
    local text_ok, source = pcall(region.GetText, region)
    if not text_ok or type(source) ~= "string" or source == "" then return end
    if type(_G.issecretvalue) == "function" then
        local secret_ok, secret = pcall(_G.issecretvalue, source)
        if not secret_ok or secret then return end
    end
    local translated = entries.get_glossary_text(source, source, "zone")
    local is_zone = translated ~= source
    if not is_zone then translated = resolver.find_ui(source, region) end
    if type(translated) ~= "string" or translated == source then return end
    runtime.apply(region, {
        owner = "lfg-listing", slot = is_zone and "zone.name" or "ui.text",
        source = source, translated = translated,
        option = is_zone and "translate_zone" or "translate_string",
        priority = is_zone and runtime.PRIORITY.DOMAIN or runtime.PRIORITY.CONTEXT,
    })
end

local function translate_lfg_listing_rows()
    local listing_view = _G.LFGListingFrameActivityView
    if not listing_view then return end
    walker.walk(listing_view, function (region)
        local name_ok, name = pcall(region.GetDebugName, region)
        if not name_ok or type(name) ~= "string" then return end
        if name:find("LFGListingFrameActivityViewScrollBoxNameButtonName", 1, true) then
            hooks.region(region, "SetText", translate_lfg_listing_zone)
            translate_lfg_listing_zone(region)
        elseif name == "LFGListingFrameActivityView.LevelRangesCheckbox.Text" then
            hooks.region(region, "SetText", function (self)
                if not runtime.is_applying(self) then strings.translate_region(self) end
            end)
            strings.translate_region(region)
        end
    end, nil, { frames = 0 })
end

local function schedule_lfg_listing_rows()
    scheduler.request("lfg-listing-rows", nil, translate_lfg_listing_rows)
end

local function translate_lfg_category_label(region)
    if not region or runtime.is_applying(region) then return end
    local text_ok, source = pcall(region.GetText, region)
    if not text_ok or type(source) ~= "string" or source == "" then return end
    local translated, _, kind = resolver.find_ui(source, region)
    if type(translated) ~= "string" or translated == source then return end
    runtime.apply(region, {
        owner = "lfg-category", slot = "ui.text",
        source = source, translated = translated, option = "translate_string",
        priority = runtime.priority_for_source(kind),
    })
end

local function translate_lfg_categories()
    local category_view = _G.LFGListingFrameCategoryView
    if not category_view then return end
    walker.walk(category_view, function (region)
        local name_ok, name = pcall(region.GetDebugName, region)
        if name_ok and type(name) == "string"
            and name:find("LFGListingFrameCategoryView.", 1, true)
            and name:sub(-6) == ".Label" then
            hooks.region(region, "SetText", translate_lfg_category_label)
            translate_lfg_category_label(region)
        end
    end, nil, { frames = 0 })
end

local function schedule_lfg_categories()
    scheduler.request("lfg-categories", nil, translate_lfg_categories)
end

local lfg_browse_labels = {
    ["LFGBrowseFrameCategoryDropdown.Text"] = true,
    ["LFGBrowseFrameActivityDropdown.Text"] = true,
    ["LFGBrowseFrame.NoResultsFound"] = true,
    ["LFGBrowseFrameGroupInviteButtonText"] = true,
}

local function translate_lfg_browse_label(region)
    if not runtime.is_applying(region) then strings.translate_region(region) end
end

local function translate_lfg_browse()
    local frame = _G.LFGBrowseFrame
    if not frame then return end
    walker.walk(frame, function (region)
        local name_ok, name = pcall(region.GetDebugName, region)
        if name_ok and lfg_browse_labels[name] then
            hooks.region(region, "SetText", translate_lfg_browse_label)
            translate_lfg_browse_label(region)
        end
    end, nil, { frames = 0 })
end

local function schedule_lfg_browse()
    scheduler.request("lfg-browse", nil, translate_lfg_browse)
end

local lfg_who_labels = {
    ["LFGWhoListFrameTitleText"] = true,
    ["WhoFrameEditBox.Instructions"] = true,
    ["LFGWhoListFrame.FilterDropdown.Text"] = true,
}

local function translate_lfg_who_label(region)
    if not runtime.is_applying(region) then strings.translate_region(region) end
end

local function translate_lfg_who()
    local frame = _G.LFGWhoListFrame
    if not frame then return end
    walker.walk(frame, function (region)
        local name_ok, name = pcall(region.GetDebugName, region)
        if name_ok and lfg_who_labels[name] then
            hooks.region(region, "SetText", translate_lfg_who_label)
            translate_lfg_who_label(region)
        end
    end, nil, { frames = 0 })
end

local function schedule_lfg_who()
    scheduler.request("lfg-who", nil, translate_lfg_who)
end

local function translate_lfg_quest_description(entry)
    local region = entry and entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions
    local info_getter = _G.C_LFGList and _G.C_LFGList.GetActiveEntryInfo
    if not region or type(info_getter) ~= "function" then return end
    local info_ok, info = pcall(info_getter)
    local id = info_ok and info and info.questID
    if type(id) ~= "number" then return end
    local title_getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(title_getter) ~= "function" then return end
    local title_ok, english = pcall(title_getter, id)
    local quest = entries.get_entry("quest", id)
    local ukrainian = quest and quest[1]
    if not title_ok or type(english) ~= "string" or english == ""
        or type(ukrainian) ~= "string" or ukrainian == "" then return end
    local world_ok, is_world = pcall(_G.QuestUtils_IsQuestWorldQuest or function () return false end, id)
    if not world_ok then return end
    local format = is_world and _G.AUTO_GROUP_CREATION_WORLD_QUEST
        or _G.AUTO_GROUP_CREATION_NORMAL_QUEST
    if type(format) ~= "string" then return end
    local translated_format = resolver.find_ui(format)
    if type(translated_format) ~= "string" then return end
    local source_ok, source = pcall(string.format, format, english)
    ukrainian = utils.cap(ukrainian)
    local native_uk_ok, native_uk = pcall(string.format, format, ukrainian)
    local ua_ok, translated = pcall(string.format, translated_format, ukrainian)
    local mixed_ok, name_original = pcall(string.format, translated_format, english)
    if not source_ok or not native_uk_ok or not ua_ok or not mixed_ok then return end
    local text_ok, current = pcall(region.GetText, region)
    if not text_ok or (current ~= source and current ~= native_uk) then return end
    runtime.clear(region)
    runtime.apply(region, {
        owner = "lfg-quest", slot = "quest:" .. id .. ".description",
        source = source, translated = translated, name_original = name_original,
        category = "quest", option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function translate_lfg_edit_mode(entry, edit_mode)
    if edit_mode then translate_lfg_quest_description(entry) end
    translate_lfg_frame(entry)
end

local function popup_text_region(dialog)
    if not dialog then return nil end
    if type(dialog.GetTextFontString) == "function" then
        local ok, region = pcall(dialog.GetTextFontString, dialog)
        if ok and region then return region end
    end
    local name
    if type(dialog.GetName) == "function" then
        local ok, value = pcall(dialog.GetName, dialog)
        if ok and type(value) == "string" then name = value end
    end
    return dialog.text or dialog.Text or name and _G[name .. "Text"]
end

local function translate_quit_countdown(dialog)
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    local count = ok and type(source) == "string"
        and source:match("^(%d+) Seconds until exit$")
    if not count then return end
    local applied = runtime.apply(region, {
        owner = "popup", slot = "quit.countdown", source = source,
        translated = "До виходу залишилося " .. count .. " с",
        priority = runtime.PRIORITY.CONTEXT,
    })
    if applied and type(dialog.Resize) == "function" then
        pcall(dialog.Resize, dialog)
    end
end

local function translate_popup_button(dialog, getter)
    if not dialog then return end
    local button
    if type(dialog[getter]) == "function" then
        local ok, value = pcall(dialog[getter], dialog)
        if ok then button = value end
    end
    if not button then
        local number = getter:match("(%d+)$")
        local name
        if type(dialog.GetName) == "function" then
            local ok, value = pcall(dialog.GetName, dialog)
            if ok and type(value) == "string" then name = value end
        end
        button = dialog["button" .. number]
            or name and _G[name .. "Button" .. number]
    end
    if not button or type(button.GetFontString) ~= "function" then return end
    local text_ok, region = pcall(button.GetFontString, button)
    if text_ok then strings.translate_region(region) end
end

local function translate_home_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    local text_ok, source
    if region then text_ok, source = pcall(region.GetText, region) end
    if not text_ok or type(source) ~= "string"
        or source:gsub("%s+", " "):match("^%s*(.-)%s*$") ~=
            "Do you want to make Thunderbrew Distillery your new home?" then
        return false
    end
    if strings.translate_region(region) and type(dialog.Resize) == "function" then
        pcall(dialog.Resize, dialog)
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function translate_resurrection_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return false end
    local text_ok, source = pcall(region.GetText, region)
    if not text_ok or type(source) ~= "string" then return false end
    local normalized = source:gsub("%s+", " ")
    local name, seconds = normalized:match(
        "^(.-) wants to resurrect you and will be able to in (%d+) seconds?$")
    local sickness
    if not name then
        name, seconds = normalized:match(
            "^(.-) wants to resurrect you and will be able to in (%d+) seconds?%. You will be afflicted with resurrection sickness%.$")
        sickness = name ~= nil
    end
    if not name then
        name = normalized:match("^(.-) wants to resurrect you$")
        if not name then
            name = normalized:match(
                "^(.-) wants to resurrect you%. You will be afflicted with resurrection sickness%.$")
            sickness = name ~= nil
        end
    end
    if not name then return false end
    local translated = name .. " хоче воскресити вас"
    if seconds then translated = translated .. " і зможе це зробити через " .. seconds .. " с" end
    if sickness then translated = translated .. ". Після воскресіння ви матимете слабкість воскресіння" end
    translated = translated .. "."
    local applied = runtime.apply(region, {
        owner = "popup", slot = "resurrection.message", source = source,
        translated = translated, priority = runtime.PRIORITY.CONTEXT,
    })
    if applied and type(dialog.Resize) == "function" then
        pcall(dialog.Resize, dialog)
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and (translate_home_popup(dialog)
            or translate_resurrection_popup(dialog)) then return end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        if translate_home_popup(dialog) or translate_resurrection_popup(dialog) then
            return
        end
    end
end

local function refresh_and_scan_popups(which, data)
    refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and dialog then
            translate_and_capture_frame(dialog)
            return
        end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        local shown_ok, shown = dialog and pcall(dialog.IsShown, dialog)
        if shown_ok and shown then
            translate_and_capture_frame(dialog)
        end
    end
end

local function after_static_popup_show(which, _, _, data)
    -- The bind-point text and buttons can be assigned after StaticPopup_Show
    -- returns, so inspect the rendered popup on the next frame as well.
    scheduler.request("home-popup:immediate", nil, function()
        refresh_and_scan_popups(which, data)
    end)
    scheduler.request("home-popup:retry", nil, function()
        refresh_and_scan_popups(which, data)
    end, 0.1)
    local find = _G.StaticPopup_FindVisible
    if type(find) ~= "function" then return end
    local ok, dialog = pcall(find, which, data)
    if not ok or not dialog then return end
    local region = popup_text_region(dialog)
    if which ~= "GENERIC_CONFIRMATION" and which ~= "QUIT"
        and not translate_home_popup(dialog)
        and not translate_resurrection_popup(dialog) then return end
    if which == "QUIT" then
        translate_quit_countdown(dialog)
    elseif data and data.text == _G.SELL_ALL_JUNK_ITEMS_POPUP then
        if strings.translate_region(region) and type(dialog.Resize) == "function" then
            pcall(dialog.Resize, dialog)
        end
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
end

local function after_static_popup_update(dialog)
    if dialog and dialog.which == "QUIT" then
        translate_quit_countdown(dialog)
    end
    translate_home_popup(dialog)
    translate_resurrection_popup(dialog)
end

menus_ui.prepare = function ()
    hooks.region_script(_G.MailFrame, "OnShow", update_inbox_controls,
        "inbox-controls")
    hooks.region_script(_G.InboxFrame, "OnShow", update_inbox_controls,
        "inbox-controls")
    hooks.region_script(_G.SendMailFrame, "OnShow", widen_mail_frame,
        "mail-width")
    hooks.global("InboxFrame_Update", update_inbox_controls)
    hooks.region(_G.OpenAllMailText, "SetText", function (region)
        if not runtime.is_applying(region) then strings.translate_region(region) end
    end)
    hooks.region(_G.MailFrameTitleText, "SetText", translate_mail_region)
    hooks.region(_G.SendMailMoneyText, "SetText", translate_mail_region)
    hooks.region(_G.MailFrameTab2 and _G.MailFrameTab2.Text,
        "SetText", translate_mail_tab)
    update_inbox_controls()
    local game_menu = registry.get("game-menu")
    if game_menu then
        game_menu.static = function ()
            translate_game_menu(_G.GameMenuFrame)
        end
    end
    local lfg = registry.get("lfg")
    if lfg then
        if not lfg.uaForeverStaticConfigured then
            local generic_static = lfg.static
            lfg.static = function (surface)
                translate_lfg_frame(_G.LFGListFrame)
                if generic_static then generic_static(surface) end
            end
            lfg.uaForeverStaticConfigured = true
        end
        lfg.dynamic_hooks = {
            "LFGListEntryCreationActivityFinder_InitButton",
            "LFGListEntryCreation_SetEditMode", "LFGListEntryCreation_Select",
        }
        lfg.slots = { "activity.name", "entry.label" }
        lfg.domains = { "ui", "context", "zone" }
        lfg.dynamic = function ()
            local root = _G.LFGListFrame
            local entry = root and root.EntryCreation
            if entry then translate_lfg_frame(entry) end
        end
    end
    -- Forever 1.60.1 creates the escape menu in GameMenuFrameMixin:InitButtons and
    -- micro-button titles in EvaluateTooltipVisibility. Post-hooks translate
    -- only completed FontStrings; button data and tooltipText stay English.
    -- XML mixins are copied onto frames when the frame is created. By the
    -- time UA_Forever loads, GameMenuFrame already owns its original method,
    -- so hooking only GameMenuFrameMixin would not observe real calls.
    hooks.region(_G.GameMenuFrame, "InitButtons", translate_game_menu)
    hooks.mixin("GameMenuFrameMixin", "InitButtons", translate_game_menu)
    hooks.mixin("MainMenuBarMicroButtonMixin", "EvaluateTooltipVisibility", translate_micro_button_tooltip)

    -- The LFG entry-creation page fills pooled activity rows and resets its
    -- labels after the parent panel is already visible. Translate at those
    -- completed writes instead of relying on the initial ShowUIPanel pass.
    hooks.global("LFGListEntryCreationActivityFinder_InitButton",
        translate_lfg_activity_button)
    hooks.global("LFGListEntryCreation_SetEditMode", translate_lfg_edit_mode)
    hooks.global("LFGListEntryCreation_Show", translate_lfg_frame)
    hooks.global("LFGListEntryCreation_Select", translate_lfg_frame)

    -- The Forever listing view uses a separate ScrollBox from EntryCreation.
    -- Its pooled zone labels are rewritten when rows are built or recycled.
    local listing_view = _G.LFGListingFrameActivityView
    local listing_scroll_box = _G.LFGListingFrameActivityViewScrollBox
    hooks.region_script(listing_view, "OnShow", schedule_lfg_listing_rows)
    hooks.region_script(listing_scroll_box, "OnShow", schedule_lfg_listing_rows)
    hooks.region_script(listing_scroll_box, "OnMouseWheel", schedule_lfg_listing_rows)
    hooks.region(listing_scroll_box, "Update", schedule_lfg_listing_rows)
    hooks.region(listing_scroll_box, "SetDataProvider", schedule_lfg_listing_rows)
    schedule_lfg_listing_rows()
    hooks.region_script(_G.LFGListingFrameCategoryView, "OnShow", schedule_lfg_categories)
    schedule_lfg_categories()
    hooks.region_script(_G.LFGBrowseFrame, "OnShow", schedule_lfg_browse)
    schedule_lfg_browse()
    hooks.region_script(_G.LFGWhoListFrame, "OnShow", schedule_lfg_who)
    schedule_lfg_who()

    -- Modern dropdowns and context menus are anonymous pooled frames. Hook the
    -- public manager and translate only the completed menu returned as open.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hooks.region(menu_manager, "OpenMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenContextMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenSubmenu", translate_open_menu)

    hooks.global("UIDropDownMenu_AddButton", translate_legacy_dropdown)
    hooks.global("StaticPopup_Show", after_static_popup_show)
    hooks.global("StaticPopup_OnUpdate", after_static_popup_update)
    for index = 1, 4 do
        hooks.region_script(_G["StaticPopup" .. index], "OnShow", function()
            scheduler.request("home-popup:on-show", nil, refresh_and_scan_popups)
        end)
    end

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
