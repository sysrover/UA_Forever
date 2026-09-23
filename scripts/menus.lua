local _, addon_table = ...

local menus_ui = addon_table.use("menus_ui")
local strings = addon_table.use("strings")

local hooked = {}
local legacy_dropdown_pending = {}

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
    strings.translate_frame(tooltip)
end

local function translate_open_menu()
    local function translate()
        local manager = _G.Menu and type(_G.Menu.GetManager) == "function"
            and _G.Menu.GetManager() or nil
        local menu = manager and type(manager.GetOpenMenu) == "function"
            and manager:GetOpenMenu() or nil
        if menu then strings.translate_frame(menu) end
    end

    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, translate)
    else
        translate()
    end
end

local function translate_legacy_dropdown(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    if legacy_dropdown_pending[level] then return end
    legacy_dropdown_pending[level] = true
    local function translate()
        legacy_dropdown_pending[level] = nil
        local frame = _G["DropDownList" .. level]
        if frame then strings.translate_frame(frame) end
    end

    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, translate)
    else
        translate()
    end
end

menus_ui.prepare = function ()
    -- Forever 1.60.1 creates the escape menu in GameMenuFrameMixin:InitButtons and
    -- micro-button titles in EvaluateTooltipVisibility. Post-hooks translate
    -- only completed FontStrings; button data and tooltipText stay English.
    -- XML mixins are copied onto frames when the frame is created. By the
    -- time UA_Forever loads, GameMenuFrame already owns its original method,
    -- so hooking only GameMenuFrameMixin would not observe real calls.
    hook_owner(_G.GameMenuFrame, "GameMenuFrame.InitButtons", "InitButtons", translate_game_menu)
    hook_mixin("GameMenuFrameMixin", "InitButtons", translate_game_menu)
    hook_mixin("MainMenuBarMicroButtonMixin", "EvaluateTooltipVisibility", translate_micro_button_tooltip)

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
