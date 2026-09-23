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

local hooked = {}

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

local function hook_global(name, callback)
    if hooked[name] or type(_G[name]) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(hooksecurefunc, name, callback)
    if ok then hooked[name] = true end
end

local function translate_game_menu(frame)
    if not frame then return end

    -- GameMenuFrame is protected in Camelot, so the generic recursive walker
    -- intentionally refuses it. Its public display surface is small and
    -- stable: one header FontString and the FontString of each pooled button.
    -- Touch only those completed display regions and leave button data,
    -- callbacks, ordering, and secure descendants unchanged.
    local header = frame.Header
    strings.translate_region(header and header.Text)
    if header and type(header.UpdateWidth) == "function" then
        pcall(header.UpdateWidth, header)
    end

    if type(frame.buttons) == "table" then
        local widest_button = 0
        for _, button in ipairs(frame.buttons) do
            if button and type(button.GetFontString) == "function" then
                local ok, font_string = pcall(button.GetFontString, button)
                if ok then
                    strings.translate_region(font_string)
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
    local function translate(region)
        if region then strings.translate_region(region) end
    end
    translate(entry.Label)
    translate(entry.Name and entry.Name.Instructions)
    translate(entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions)
    translate(entry.ItemLevel and entry.ItemLevel.EditBox
        and entry.ItemLevel.EditBox.Instructions)
    translate(entry.CrossFactionGroup and entry.CrossFactionGroup.Label)
    local button = entry.ListGroupButton
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate(region) end
    end
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

menus_ui.prepare = function ()
    local lfg = registry.get("lfg")
    if lfg then
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
    hook_owner(_G.GameMenuFrame, "GameMenuFrame.InitButtons", "InitButtons", translate_game_menu)
    hook_mixin("GameMenuFrameMixin", "InitButtons", translate_game_menu)
    hook_mixin("MainMenuBarMicroButtonMixin", "EvaluateTooltipVisibility", translate_micro_button_tooltip)

    -- The LFG entry-creation page fills pooled activity rows and resets its
    -- labels after the parent panel is already visible. Translate at those
    -- completed writes instead of relying on the initial ShowUIPanel pass.
    hook_global("LFGListEntryCreationActivityFinder_InitButton",
        translate_lfg_activity_button)
    hook_global("LFGListEntryCreation_SetEditMode", translate_lfg_edit_mode)
    hook_global("LFGListEntryCreation_Show", translate_lfg_frame)
    hook_global("LFGListEntryCreation_Select", translate_lfg_frame)

    -- Modern dropdowns and context menus are anonymous pooled frames. Hook the
    -- public manager and translate only the completed menu returned as open.
    local menu_manager = _G.Menu and type(_G.Menu.GetManager) == "function"
        and _G.Menu.GetManager() or nil
    hook_owner(menu_manager, "MenuManager.OpenMenu", "OpenMenu", translate_open_menu)
    hook_owner(menu_manager, "MenuManager.OpenContextMenu", "OpenContextMenu", translate_open_menu)

    if not hooked["UIDropDownMenu_AddButton"]
        and type(_G.UIDropDownMenu_AddButton) == "function"
        and type(_G.hooksecurefunc) == "function" then
        local ok = pcall(hooksecurefunc, "UIDropDownMenu_AddButton", translate_legacy_dropdown)
        if ok then hooked["UIDropDownMenu_AddButton"] = true end
    end

    local game_menu = _G.GameMenuFrame
    if game_menu and game_menu.HookScript and not hooked["GameMenuFrame.Script.OnShow"] then
        local ok = pcall(game_menu.HookScript, game_menu, "OnShow", translate_game_menu)
        if ok then hooked["GameMenuFrame.Script.OnShow"] = true end
    end
    translate_game_menu(game_menu)

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
        hook_owner(button, name .. ".EvaluateTooltipVisibility",
            "EvaluateTooltipVisibility", translate_micro_button_tooltip)
    end
end
