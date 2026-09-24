local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local entries = addon_table.use("entries")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("menus")

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
        if menu then strings.translate_frame(menu) end
    end

    scheduler.request("open-menu", nil, translate)
end

local function translate_legacy_dropdown(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    local function translate()
        local frame = _G["DropDownList" .. level]
        if frame then strings.translate_frame(frame) end
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
                local translated, _, kind = resolver.find_ui(source, font_string)
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
                        priority = kind == "domain" and runtime.PRIORITY.DOMAIN
                            or runtime.PRIORITY.CONTEXT })
                end
            end
        end
    end
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
    if not dialog or type(dialog.GetTextFontString) ~= "function" then return nil end
    local ok, region = pcall(dialog.GetTextFontString, dialog)
    return ok and region or nil
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
    if not dialog or type(dialog[getter]) ~= "function" then return end
    local ok, button = pcall(dialog[getter], dialog)
    if not ok or not button or type(button.GetFontString) ~= "function" then return end
    local text_ok, region = pcall(button.GetFontString, button)
    if text_ok then strings.translate_region(region) end
end

local function after_static_popup_show(which, _, _, data)
    if which ~= "GENERIC_CONFIRMATION" and which ~= "QUIT" then return end
    local find = _G.StaticPopup_FindVisible
    if type(find) ~= "function" then return end
    local ok, dialog = pcall(find, which, data)
    if not ok or not dialog then return end
    local region = popup_text_region(dialog)
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
end

menus_ui.prepare = function ()
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

    -- Modern dropdowns and context menus are anonymous pooled frames. Hook the
    -- public manager and translate only the completed menu returned as open.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hooks.region(menu_manager, "OpenMenu", translate_open_menu)
    hooks.region(menu_manager, "OpenContextMenu", translate_open_menu)

    hooks.global("UIDropDownMenu_AddButton", translate_legacy_dropdown)
    hooks.global("StaticPopup_Show", after_static_popup_show)
    hooks.global("StaticPopup_OnUpdate", after_static_popup_update)

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
