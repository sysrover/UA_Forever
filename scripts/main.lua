local addon_name, addon_table = ...
local addon_version = "0.19.0"
local panel_probe_text = assert(addon_table.addon_locale_uk,
    "UA Forever addon locale is not loaded").panel_probe
local cast_bar_probe_text = addon_table.addon_locale_uk.cast_bar_probe

local assets = addon_table.use("assets")
local achievements = addon_table.use("achievements")
local auto_scan = addon_table.use("auto_scan")
local book_ui = addon_table.use("book_ui")
local cast_bar_adapter = addon_table.use("cast_bar_adapter")
local loss_of_control_adapter = addon_table.use("loss_of_control_adapter")
local mirror_timer_adapter = addon_table.use("mirror_timer_adapter")
local chats = addon_table.use("chats")
local chat_links = addon_table.use("chat_links")
local chat_config_ui = addon_table.use("chat_config_ui")
local dev_log = addon_table.use("dev_log")
local edit_mode = addon_table.use("edit_mode")
local entries = addon_table.use("entries")
local fonts = addon_table.use("fonts")
local gossip_ui = addon_table.use("gossip_ui")
local items = addon_table.use("items")
local level_up_display = addon_table.use("level_up_display")
local map_labels = addon_table.use("map_labels")
local menus_ui = addon_table.use("menus_ui")
local mail_ui = addon_table.use("mail_ui")
local auction_ui = addon_table.use("auction_ui")
local lfg_ui = addon_table.use("lfg_ui")
local popup_ui = addon_table.use("popup_ui")
local social_ui = addon_table.use("social_ui")
local raid_ui = addon_table.use("raid_ui")
local trade_ui = addon_table.use("trade_ui")
local compact_raid_manager_ui = addon_table.use("compact_raid_manager_ui")
local stack_split_ui = addon_table.use("stack_split_ui")
local guild_registrar_ui = addon_table.use("guild_registrar_ui")
local petition_ui = addon_table.use("petition_ui")
local tabard_ui = addon_table.use("tabard_ui")
local coin_pickup_ui = addon_table.use("coin_pickup_ui")
local role_poll_ui = addon_table.use("role_poll_ui")
local loot_history_ui = addon_table.use("loot_history_ui")
local tutorial_ui = addon_table.use("tutorial_ui")
local options = addon_table.use("options")
local profession_frame_adapter = addon_table.use("profession_frame_adapter")
local profession_recipe_adapter = addon_table.use("profession_recipe_adapter")
local quest_switcher = addon_table.use("quest_switcher")
local quest_ui = addon_table.use("quest_ui")
local scanner = addon_table.use("scanner")
local settings_ui = addon_table.use("settings_ui")
local forever_vo_ui = addon_table.use("forever_vo_ui")
local skills = addon_table.use("skills")
local strings = addon_table.use("strings")
local talent_frame_adapter = addon_table.use("talent_frame_adapter")
local tooltips = addon_table.use("tooltips")
local tooltip_diagnostics = addon_table.use("tooltip_diagnostics")
local target_frame = addon_table.use("target_frame")
local translation = addon_table.use("translation")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local hooks = addon_table.use("translation_hooks").bind("main")
local utils = addon_table.use("utils")

local function prepare_menu_panels()
    forever_vo_ui.prepare()
    addon_table.use("legacy_ui").prepare()
    social_ui.prepare()
    raid_ui.prepare()
    trade_ui.prepare()
    compact_raid_manager_ui.prepare()
    stack_split_ui.prepare()
    guild_registrar_ui.prepare()
    petition_ui.prepare()
    tabard_ui.prepare()
    coin_pickup_ui.prepare()
    role_poll_ui.prepare()
    loot_history_ui.prepare()
    tutorial_ui.prepare()
    mail_ui.prepare()
    auction_ui.prepare()
    menus_ui.prepare()
    lfg_ui.prepare()
    popup_ui.prepare()
end

local function message(text)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(assets.icon_ua_inline .. " |cff55aaffUA Forever:|r " .. text)
    end
end

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

local function safe_unit_name(unit)
    if type(unit) ~= "string" or is_secret(unit) then return nil end
    local ok, name = pcall(UnitName, unit)
    if ok and type(name) == "string" and not is_secret(name) and name ~= "" then
        return name
    end
end

local function translated_npc_name(unit)
    if not options.can_translate("translate_npc") then return nil end
    local id = utils.npc_id_from_unit_id(unit)
    local entry = id and entries.get_entry("npc", id)
    local source = id and safe_unit_name(unit)
    if id then
        dev_log.record_id("npcs", id, source, entry ~= nil)
        if not entry then dev_log.missing_npc(id, source) end
    end
    return entry and utils.cap(entry[1]) or nil, source
end

local function update_quest_npc_name()
    if not options.can_translate("translate_npc") then return end
    local name, source = translated_npc_name("questnpc")
    if not name then name, source = translated_npc_name("npc") end
    if name and source then
        for _, region in pairs({ _G.QuestFrameNpcNameText,
            _G.QuestFrameTitleText }) do
            if region then
                local visible_ok, visible = pcall(function () return region:GetText() end)
                local claim = runtime.get(region)
                if visible_ok and not is_secret(visible)
                    and (visible == source
                        or (claim and claim.source == source
                            and visible == claim.translated)) then
                    runtime.apply(region, { owner = "quest-npc", slot = "npc.name",
                        source = source, translated = name,
                        priority = runtime.PRIORITY.DOMAIN })
                end
            end
        end
    end
end

local dirty_open_panels = {}
local refresh_all_open_panels = false

local function refresh_open_panels()
    local refresh_all = refresh_all_open_panels
    local dirty = dirty_open_panels
    refresh_all_open_panels = false
    dirty_open_panels = {}
    update_quest_npc_name()
    items.refresh_quest_rewards()
    if refresh_all then
        registry.refresh_open()
    else
        for id in pairs(dirty) do registry.refresh(id) end
    end
    quest_switcher.refresh()
    if type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled() then
        if refresh_all then
            strings.capture_visible_ui()
        else
            for id in pairs(dirty) do
                local surface = registry.get(id)
                for _, root_name in ipairs(surface and surface.roots or {}) do
                    local frame = _G[root_name]
                    local shown_ok, shown = frame and pcall(frame.IsShown, frame)
                    if shown_ok and shown then strings.capture_frame(frame) end
                end
            end
        end
    end
end

local function schedule_panel_refresh(surface_ids)
    if type(surface_ids) ~= "table" then
        refresh_all_open_panels = true
    else
        for _, id in ipairs(surface_ids) do dirty_open_panels[id] = true end
    end
    scheduler.request("open-panels", nil, refresh_open_panels)
end

local function refresh_trainer()
    auto_scan.surface_attempt("trainer", "registry.refresh")
    registry.refresh("trainer")
end

local function schedule_trainer_refresh(event)
    if event then auto_scan.surface_event("trainer", event) end
    scheduler.request("trainer-content", nil, refresh_trainer)
end

local function schedule_current_quest_capture(event)
    local expected_id = translation.get_current_quest_id()
    local function capture()
        if expected_id and translation.get_current_quest_id() ~= expected_id then return end
        local ok, err = pcall(scanner.capture_current_quest, event)
        if not ok then
            dev_log.issue("quest capture: " .. tostring(event), tostring(err))
        end
    end

    -- The first pass normally sees the data immediately. The short retry
    -- covers Camelot panels whose text getters are filled one frame later.
    scheduler.request("quest-capture:" .. event .. ":initial", nil, capture)
    if type(quest_ui.refresh_current_dialog) == "function" then
        scheduler.request("quest-refresh:" .. event .. ":retry", nil,
            quest_ui.refresh_current_dialog, 0.2)
    end
    scheduler.request("quest-capture:" .. event .. ":retry", nil, capture, 0.3)
end

local function opened_panel(frame)
    -- Forever's escape menu and Settings panel have dedicated native-mixin
    -- hooks. Running the generic delayed walker as well causes a visible
    -- second replacement pass and can touch protected internal controls.
    if frame ~= _G.GameMenuFrame and frame ~= _G.SettingsPanel then
        -- ShowUIPanel runs after the native initial text writes. The surface
        -- refresh handles static labels; pooled rows have domain post-hooks.
        local surface = registry.find_frame(frame)
        if surface then registry.refresh(surface.id) end
        if type(auto_scan.diagnostics_enabled) == "function"
            and auto_scan.diagnostics_enabled() then
            strings.capture_frame(frame)
        end
    end
end

local function translate_macro_popup(frame)
    local border = frame and frame.BorderBox
    if not border then return end

    local function hook_label(region)
        if not region then return end
        local translating = false
        local function translate_label(self)
            if translating or runtime.is_applying(self) then return end
            translating = true
            local ok, err = pcall(strings.translate_region, self)
            translating = false
            if not ok then dev_log.issue("macro popup translation", tostring(err)) end
        end
        hooks.region(region, "SetText", translate_label)
        -- Selecting an icon also resets the description's font object.
        hooks.region(region, "SetFontObject", translate_label)
        translate_label(region)
    end
    local function hook_button(button)
        if not button or type(button.GetFontString) ~= "function" then return end
        local ok, region = pcall(button.GetFontString, button)
        if ok then hook_label(region) end
    end

    -- Only static UI labels belong here; leave the macro name and body alone.
    hook_label(border.EditBoxHeaderText)
    hook_label(border.IconSelectionText)
    hook_label(border.IconTypeDropdown and border.IconTypeDropdown.Text)
    local selected = border.SelectedIconArea and border.SelectedIconArea.SelectedIconText
    hook_label(selected and selected.SelectedIconHeader)
    hook_label(selected and selected.SelectedIconDescription)
    hook_button(border.CancelButton)
    hook_button(border.OkayButton)
end

local function selected_tab(frame, tab)
    -- PanelTemplates_SetTab runs after Blizzard selects the tab.
    local surface = registry.find_frame(frame)
    if surface then registry.refresh(surface.id) end
    if type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled() then
        strings.capture_frame(frame)
    end
end

local function translate_character_subframe(_, subframe_name)
    local subframe = type(subframe_name) == "string" and _G[subframe_name] or nil
    if subframe then
        strings.translate_frame(subframe, registry.get("character"))
    end
end

local function translate_communities_add_dialog()
    local dialog = _G.CommunitiesAddDialog
    if not dialog then return end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown or is_secret(shown) then return end
    for _, key in ipairs({
        "DialogLabel", "CreateWoWCommunityLabel", "CreateWoWCommunityDescription",
        "CreateBattleNetGroupLabel", "CreateBattleNetGroupDescription",
        "InviteLinkLabel", "InviteLinkDescription",
    }) do
        local ok, region = pcall(function () return dialog[key] end)
        if ok and region then strings.translate_region(region) end
    end
    local description_ok, description = pcall(function ()
        return dialog.CreateBattleNetGroupDescription
    end)
    if description_ok and description then
        local function translate_instructions(container)
            if not container then return end
            local ok, instructions = pcall(function () return container.Instructions end)
            if ok and instructions then strings.translate_region(instructions) end
        end
        translate_instructions(description)
        local edit_ok, edit_box = pcall(function () return description.EditBox end)
        if edit_ok and edit_box then translate_instructions(edit_box) end
        local nested_ok, nested_description = pcall(function ()
            return description.Description
        end)
        if nested_ok and nested_description then
            translate_instructions(nested_description)
            local nested_edit_ok, nested_edit = pcall(function ()
                return nested_description.EditBox
            end)
            if nested_edit_ok and nested_edit then translate_instructions(nested_edit) end
        end
    end
    local ok, label = pcall(function ()
        return dialog.JoinButton and dialog.JoinButton:GetFontString()
    end)
    if ok and label then strings.translate_region(label) end
end

local function schedule_communities_add_dialog()
    scheduler.request("communities-add-dialog", nil, translate_communities_add_dialog)
end

local function translate_character_title(frame)
    if frame and type(frame.GetTitleText) == "function" then
        local ok, region = pcall(frame.GetTitleText, frame)
        if ok then strings.translate_region(region) end
    end
end

local function translate_character_level(region)
    if not region or runtime.is_applying(region)
        or not options.can_translate("translate_string") then return end
    local ok, source = pcall(region.GetText, region)
    if not ok or type(source) ~= "string" or is_secret(source) then return end
    -- Build 70170 formats PLAYER_LEVEL[_NO_SPEC] with a colored class/spec
    -- and can use an effective level such as "20 (30)". Apply once from the
    -- native text so original mode retains the whole Blizzard string.
    local level, color, description = source:match(
        "^Level (.-) (|c%x%x%x%x%x%x%x%x)(.-)|r$")
    local wording = addon_table.forever_surface_ui.character
    if not level or not wording then
        strings.translate_region(region)
        return
    end
    local class_ok, class = pcall(function () return _G.UnitClass("player") end)
    if class_ok and not is_secret(class) and type(class) == "string" and class ~= "" then
        local start_at, end_at = description:find(class, 1, true)
        if start_at and end_at == #description then
            local spec = description:sub(1, start_at - 1):match("^(.-)%s*$")
            local translated_class = strings.find_ui_translation(class) or class
            local translated_spec = spec ~= "" and (strings.find_ui_translation(spec) or spec) or ""
            description = (translated_spec ~= "" and translated_spec .. " " or "") .. translated_class
        end
    end
    runtime.apply(region, { owner = "character-level",
        slot = "character.level_class", source = source,
        translated = wording.level(level, color, description),
        option = "translate_string",
        priority = runtime.PRIORITY.CONTEXT })
end

local function translate_character_stat_region(region)
    if not region or runtime.is_applying(region)
        or not options.can_translate("translate_string") then return end
    strings.translate_region(region, nil, "ui.text", registry.get("character"))
end

local function translate_character_stat_row(row)
    if not row then return end
    for _, key in ipairs({ "Title", "Label", "Value" }) do
        local region = row[key]
        -- Hook actual pooled widgets, not mixins copied before addon load.
        -- Later stat updates can rewrite a row without reopening the panel.
        hooks.region(region, "SetText", translate_character_stat_region)
        hooks.region(region, "SetFormattedText", translate_character_stat_region)
        translate_character_stat_region(region)
    end
end

local function translate_character_pane(frame)
    if frame then strings.translate_frame(frame, registry.get("character")) end
end

local function prepare_reputation_bar(bar)
    local region = bar and bar.Text
    -- Hover swaps the standing for progress; OnLeave writes the cached native
    -- standing again. Translate the display region, retaining both native
    -- cache fields for Blizzard's hover and reputation-update logic.
    hooks.region(region, "SetText", translate_character_stat_region)
    hooks.region(region, "SetFormattedText", translate_character_stat_region)
    translate_character_stat_region(region)
end

local function translate_reputation_row(row)
    if not row then return end
    prepare_reputation_bar(row.Content and row.Content.ReputationBar)
    translate_character_pane(row)
end

local character_scroll_owners = setmetatable({}, { __mode = "k" })
local function prepare_character_scroll_box(pane, stats, row_callback)
    local scroll_box = pane and pane.ScrollBox
    if not scroll_box or type(scroll_box.RegisterCallback) ~= "function"
        or not _G.ScrollUtil
        or type(_G.ScrollUtil.AddInitializedFrameCallback) ~= "function" then return end
    local translate_row = row_callback
        or (stats and translate_character_stat_row or translate_character_pane)
    if not character_scroll_owners[scroll_box] then
        local owner = {}
        local ok = pcall(_G.ScrollUtil.AddInitializedFrameCallback,
            scroll_box, function (_, row) translate_row(row) end, owner, false)
        if ok then character_scroll_owners[scroll_box] = owner end
    end
    if type(scroll_box.ForEachFrame) == "function" then
        pcall(scroll_box.ForEachFrame, scroll_box, translate_row)
    end
end

local function prepare_character_panels()
    for _, name in ipairs({ "CharacterStatsPaneScrollBox", "CharacterStatsPanePetScrollBox" }) do
        prepare_character_scroll_box(_G[name], true)
    end
    prepare_character_scroll_box(_G.ReputationFrame, false, translate_reputation_row)
    for _, name in ipairs({ "TokenFrame", "StatisticsFrame" }) do
        prepare_character_scroll_box(_G[name], false)
    end
    local character = _G.CharacterFrame
    -- Right-hand details use their own row pools and can update independently
    -- of ShowSubFrame (selection, reputation gain, and PvP progress).
    for _, pane in ipairs(character and character.SidePanes or {}) do
        prepare_reputation_bar(pane.StandingBar)
        for _, method in ipairs({ "SetPaneTitle", "SetDescription", "LayoutRows", "SetEmpty" }) do
            hooks.region(pane, method, translate_character_pane)
        end
    end
    hooks.region(_G.PVPRankFrame, "Update", translate_character_pane)
    hooks.region(_G.PVPRankFrame, "UpdateSeasonCountdownTimer", function (frame)
        translate_character_stat_region(frame.SeasonTimerField)
    end)
    hooks.global("PaperDollFrame_SetSidebar", function ()
        translate_character_pane(_G.PaperDollFrame and _G.PaperDollFrame.currentSideBar)
    end)
    hooks.region_script(_G.GearManagerPopupFrame, "OnShow", translate_character_pane)
end

local function quest_greeting_shown()
    update_quest_npc_name()
    if type(quest_ui.refresh_greeting) == "function" then
        local function refresh()
            auto_scan.surface_attempt("quest-greeting", "refresh_greeting")
            quest_ui.refresh_greeting()
        end
        scheduler.request("quest-greeting-refresh-immediate", nil,
            refresh)
        scheduler.request("quest-greeting-refresh", nil,
            refresh, 0.1)
        scheduler.request("quest-greeting-refresh-late", nil,
            refresh, 0.35)
    end
    if options.account.auto_scan_content
        and type(scanner.schedule_quest_greeting_capture) == "function" then
        scanner.schedule_quest_greeting_capture()
    end
end

local function schedule_transient_capture(frame)
    if not frame or type(auto_scan.diagnostics_enabled) ~= "function"
        or not auto_scan.diagnostics_enabled() then return end
    scheduler.request("auto-alert:" .. tostring(frame), nil, function ()
        local shown_ok, shown = pcall(frame.IsShown, frame)
        if shown_ok and shown then
            strings.translate_frame(frame, nil, {
                id = "developer-alert-capture", surface = "alert",
                owner = "main", reason = "DEVELOPER_CAPTURE",
            })
            strings.capture_frame(frame)
        end
    end)
end

local function translate_wardrobe_page(region)
    if not region then return end
    strings.translate_region(region, nil, "ui.text",
        registry.get("collections"))
end

local function prepare_panel_hooks()
    if type(_G.hooksecurefunc) ~= "function" then return end
    hooks.global("ShowUIPanel", opened_panel)
    hooks.global("PanelTemplates_SetTab", selected_tab)
    local trainer_hook = "ClassTrainerFrame_Update"
    local trainer_hook_available = hooks.global(trainer_hook, function ()
        auto_scan.surface_hook("trainer", trainer_hook, true, true)
        schedule_trainer_refresh(trainer_hook)
    end)
    auto_scan.surface_hook("trainer", trainer_hook,
        trainer_hook_available, false)
    hooks.global("QuestFrame_SetPortrait", update_quest_npc_name)
    local greeting_hook = "QuestFrameGreetingPanel_OnShow"
    local greeting_hook_available = hooks.global(greeting_hook, function ()
        auto_scan.surface_hook("quest-greeting", greeting_hook, true, true)
        quest_greeting_shown()
    end)
    auto_scan.surface_hook("quest-greeting", greeting_hook,
        greeting_hook_available, false)
    hooks.global("AlertFrame_ShowNewAlert", schedule_transient_capture)
    hooks.region(_G.AlertContainerMixin, "AddAlertFrame", function (_, frame)
        schedule_transient_capture(frame)
    end)
    -- QuestInfo_Display and ShowRewards have domain post-hooks in quest_ui and
    -- items; refreshing every open surface here would rescan the entire map
    -- for a single quest text update.

    hooks.region_script(_G.ContainerFrameCombinedBags, "OnShow", opened_panel)
    hooks.region_script(_G.ObjectiveTrackerFrame, "OnShow", opened_panel)
    hooks.region_script(_G.QuestTimerFrame, "OnShow", opened_panel)
    -- Blizzard_MacroUI is loaded on demand. ADDON_LOADED calls this function
    -- again, so the hook is installed as soon as MacroFrame becomes available.
    hooks.region_script(_G.MacroFrame, "OnShow", opened_panel)
    -- The name/icon popup calls Show directly, bypassing ShowUIPanel.
    hooks.region_script(_G.MacroPopupFrame, "OnShow", translate_macro_popup)
    translate_macro_popup(_G.MacroPopupFrame)

    local wardrobe = _G.WardrobeCollectionFrame
    local page_text = wardrobe and wardrobe.ItemsCollectionFrame
        and wardrobe.ItemsCollectionFrame.PagingFrame
        and wardrobe.ItemsCollectionFrame.PagingFrame.PageText
    hooks.region(page_text, "SetText", translate_wardrobe_page)
    hooks.region(page_text, "SetFormattedText", translate_wardrobe_page)
    translate_wardrobe_page(page_text)

    hooks.region_script(_G.CommunitiesAddDialog, "OnShow",
        schedule_communities_add_dialog)
    hooks.global("AddCommunitiesFlow_Toggle", schedule_communities_add_dialog)
    schedule_communities_add_dialog()

    -- Camelot's character tabs and the equipment manager are not opened with
    -- ShowUIPanel. Hook their real owners after Blizzard has populated text.
    hooks.region(_G.CharacterFrame, "ShowSubFrame", translate_character_subframe)
    hooks.region(_G.CharacterFrame, "UpdateTitle", translate_character_title)
    translate_character_title(_G.CharacterFrame)
    for _, name in ipairs({ "CharacterLevelText", "HonorLevelText" }) do
        local region = _G[name]
        if region then
            hooks.region(region, "SetText", translate_character_level)
            hooks.region(region, "SetFormattedText", translate_character_level)
            translate_character_level(region)
        end
    end
    hooks.global("PaperDollFrame_SetLevel", function ()
        translate_character_level(_G.CharacterLevelText)
        translate_character_level(_G.HonorLevelText)
    end)
    local paper_doll = _G.PaperDollFrame
    hooks.region_script(paper_doll and paper_doll.EquipmentManagerPane,
        "OnShow", translate_character_pane)
    prepare_character_panels()
end

local function prepare_nameplates()
    hooks.global("CompactUnitFrame_UpdateName", function (frame)
        if not frame or not options.can_translate("translate_npc", "translate_nameplates") then
            return
        end
        local frame_ok, unit, region, is_forbidden = pcall(function ()
            return frame.unit, frame.name or frame.Name, frame.IsForbidden
        end)
        if not frame_ok or type(unit) ~= "string" or is_secret(unit)
            or not unit:match("^nameplate%d+$")
            or not region then return end
        if type(is_forbidden) == "function" then
            local ok, forbidden = pcall(is_forbidden, frame)
            if not ok or is_secret(forbidden) or forbidden then return end
        end
        local source = safe_unit_name(unit)
        if not source then return end
        local text_ok, visible = pcall(function () return region:GetText() end)
        if not text_ok or is_secret(visible) or visible ~= source then return end
        local name = translated_npc_name(unit)
        if name then
            runtime.apply(region, { owner = "npc-nameplate", slot = "npc.name",
                source = source, translated = name,
                priority = runtime.PRIORITY.DOMAIN })
        end
    end)
end

local function missing_count()
    local count = 0
    local groups = UA_ForeverDB and UA_ForeverDB.missing or {}
    for _, values in pairs(groups) do
        if type(values) == "table" then
            for _ in pairs(values) do count = count + 1 end
        end
    end
    return count
end

local function show_status()
    local status = string.format(
        "v%s; WoW %s; Interface %s; переклад %s; автоскан %s; dev %s",
        addon_version,
        tostring(utils.build_version),
        tostring(utils.interface_version),
        options.account.enabled and "увімкнено" or "вимкнено",
        options.account.auto_scan_content and "увімкнено" or "вимкнено",
        options.account.dev_mode and "увімкнено" or "вимкнено"
    )
    if options.account.auto_scan_content then
        status = status .. string.format("; пропусків %d", missing_count())
    end
    message(status)
end

local manual_capture_sequence = 0
local function register_slash_command()
    _G.SLASH_UAFOREVER1 = "/uaf"
    SlashCmdList.UAFOREVER = function (input)
        local command, value = tostring(input or ""):lower():match("^(%S*)%s*(.-)$")
        if command == "on" then
            options.account.enabled = true
            runtime.refresh_policy()
            options.refresh_activity()
            if fonts.refresh_damage_text_font then fonts.refresh_damage_text_font() end
            if strings.refresh_combat_text_globals then
                strings.refresh_combat_text_globals()
            end
            registry.refresh_open()
            if tooltips.refresh_active then tooltips.refresh_active() end
            message("переклад увімкнено")
        elseif command == "off" then
            options.account.enabled = false
            runtime.refresh_policy()
            options.refresh_activity()
            registry.refresh("combat-log")
            if fonts.refresh_damage_text_font then fonts.refresh_damage_text_font() end
            if strings.refresh_combat_text_globals then
                strings.refresh_combat_text_globals()
            end
            if tooltips.refresh_active then tooltips.refresh_active() end
            message("переклад вимкнено")
        elseif command == "dev" and (value == "on" or value == "off") then
            options.account.dev_mode = value == "on"
            options.refresh_activity()
            message("режим розробки " .. (options.account.dev_mode and "увімкнено" or "вимкнено"))
        elseif command == "autoscan" and (value == "on" or value == "off") then
            options.account.auto_scan_content = value == "on"
            options.refresh_activity()
            message("автоскан контенту " .. (options.account.auto_scan_content and "увімкнено" or "вимкнено"))
        elseif command == "menus" then
            message(string.format("автосканом пройдено меню: %d", scanner.menu_count()))
        elseif command == "owner" then
            local function capture_owner()
                if tooltips.capture_mouse_focus then
                    tooltips.capture_mouse_focus()
                end
            end
            local delay = tonumber(value)
            if delay and delay > 0 then
                delay = math.min(delay, 15)
                scheduler.cancel("manual-owner-capture")
                scheduler.request("manual-owner-capture", nil, capture_owner, delay)
            else
                capture_owner()
            end
        elseif command == "tooltip" then
            local write_id, write_delay = value:match("^write%s+(%d+)%s*(%d*)$")
            if write_id then
                local function probe_npc_write()
                    local ok, report = pcall(tooltips.capture_npc_write, tonumber(write_id))
                    if not ok then
                        tooltip_diagnostics.append_report("npcWriteProbe", {
                            version = 1, status = "error", error = tostring(report),
                        })
                    end
                    message("NPC write probe: " .. (ok and tostring(report.status) or "error"))
                    message("/reload; результат: UA_ForeverDB.scan.npcWriteProbe")
                end
                local delay = math.min(tonumber(write_delay) or 3, 30)
                scheduler.cancel("manual-npc-write-probe")
                if delay > 0 then
                    message(string.format("контрольний запис NPC %s через %.1f с — наведіть на цього NPC", write_id, delay))
                    scheduler.request("manual-npc-write-probe", nil, probe_npc_write, delay)
                else
                    probe_npc_write()
                end
                return
            end
            local all_value = value:match("^all%s*(.-)$")
            if all_value ~= nil then
                local function capture_all_tooltips()
                    local ok, report = pcall(tooltips.capture_visible_tooltips)
                    if not ok then
                        tooltip_diagnostics.append_report("tooltipProbe", {
                            version = 1, status = "error",
                            error = tostring(report),
                        })
                        message("захоплення tooltip-ів завершилося помилкою; стан збережено")
                        return
                    end
                    message(string.format("tooltip-звіт: %s; знайдено %d",
                        tostring(report.status), report.count or 0))
                    message("зробіть /reload; результат: UA_ForeverDB.scan.tooltipProbe у SavedVariables/UA_Forever.lua")
                end
                local delay = tonumber(all_value)
                if delay and delay > 0 then
                    delay = math.min(delay, 30)
                    tooltip_diagnostics.append_report("tooltipProbe", {
                        version = 1, status = "waiting", delay = delay,
                    })
                    message(string.format("захоплю всі tooltip-и через %.1f с — наведіть курсор на предмет", delay))
                    scheduler.cancel("manual-tooltip-capture")
                    scheduler.request("manual-tooltip-capture", nil,
                        capture_all_tooltips, delay)
                else
                    capture_all_tooltips()
                end
                return
            end
            local tooltip
            for _, name in ipairs({ "GameTooltip", "ItemRefTooltip",
                "ShoppingTooltip1", "ShoppingTooltip2", "EmbeddedItemTooltip",
                "BuffFrameTooltip" }) do
                local candidate = _G[name]
                if candidate and type(candidate.IsShown) == "function" then
                    local ok, shown = pcall(candidate.IsShown, candidate)
                    if ok and shown then tooltip = candidate break end
                end
            end
            if not tooltip then
                tooltip_diagnostics.append_report("tooltipProbe", {
                    version = 1, status = "no_tooltips", count = 0, tooltips = {},
                })
                message("немає відкритої підказки")
            else
                local function short(text)
                    if type(text) ~= "string" then return "?" end
                    text = text:gsub("%s+", " ")
                    return #text > 55 and text:sub(1, 55) .. "…" or text
                end
                local limit = math.max(1, math.min(tonumber(value) or 12, 20))
                local lines = tooltips.inspect(tooltip, limit)
                tooltip_diagnostics.append_report("tooltipProbe", {
                    version = 1, status = "captured", count = 1,
                    tooltips = { {
                        kind = tooltip.uaForeverKind or "generic", lines = lines,
                    } },
                })
                message(string.format("підказка: %s; рядків %d",
                    tostring(tooltip.uaForeverKind or "generic"), #lines))
                for _, line in ipairs(lines) do
                    local location = line.side .. line.index
                    if line.owner then
                        message(string.format("%s %s/%s: %s → %s", location,
                            tostring(line.owner), tostring(line.slot),
                            short(line.source), short(line.translated)))
                    else
                        message(location .. " без claim: " .. short(line.visible))
                    end
                end
            end
        elseif command == "aura" then
            local status = { state = "waiting", attempts = 0 }
            tooltip_diagnostics.append_report("auraCapture", status)
            local function capture_aura()
                local tooltip = tooltips.visible_aura_window
                    and tooltips.visible_aura_window() or nil
                local shown = tooltip and type(tooltip.IsShown) == "function"
                    and select(2, pcall(tooltip.IsShown, tooltip))
                if not shown then
                    status.state = "no_tooltip"
                    message("підказка аури не відкрита; наведіть курсор і повторіть /uaf aura 5")
                    return false
                end
                local report = tooltips.capture_aura(tooltip)
                if report then
                    status.state = "captured"
                    local before, after = report.before, report.after
                    local data = before.tooltipData or {}
                    local line_types = {}
                    for _, line in ipairs(data.lines or {}) do
                        line_types[#line_types + 1] = tostring(line.type or "?")
                    end
                    message(string.format("скан аури: getter %s, type %s, data.id %s, data.spellID %s, GetSpell %s, типи рядків [%s], переклад %s → %s",
                        tostring(before.getterName or "?"),
                        tostring(data.type or "?"), tostring(data.id or "?"),
                        tostring(data.spellID or "?"),
                        tostring(before.spellID or "?"),
                        table.concat(line_types, ","),
                        before.translated and "так" or "ні",
                        after.translated and "так" or "ні"))
                    message("зробіть /reload; результат: UA_ForeverDB.scan.auraProbe у SavedVariables/UA_Forever.lua")
                    return true
                end
                status.state = "capture_failed"
                return false
            end
            local delay = tonumber(value)
            if delay and delay > 0 then
                delay = math.min(delay, 15)
                message(string.format("шукаю ауру протягом %.1f с — наведіть курсор на її значок", delay))
                scheduler.cancel("manual-aura-capture")
                local max_attempts = math.max(1, math.ceil(delay * 4))
                local function poll()
                    status.attempts = status.attempts + 1
                    if tooltips.visible_aura_window
                        and tooltips.visible_aura_window() then
                        if capture_aura() then return end
                    end
                    if status.attempts >= max_attempts then
                        status.state = "no_matching_tooltip"
                        message("скан не побачив підказки аури; стан записано в SavedVariables")
                    else
                        scheduler.request("manual-aura-capture", nil, poll, 0.25)
                    end
                end
                scheduler.request("manual-aura-capture", nil, poll, 0.25)
            else
                capture_aura()
            end
        elseif command == "fullscan" then
            local function start_full_scan(duration)
                local report = tooltips.scan_all_objects(function (completed)
                    message(string.format("скан %s: %d проходів, %d об'єктів, %d текстів, %d глобальних рядків; зробіть /reload",
                        completed.status, completed.passes or 0, completed.totalObjects or 0, completed.stats.texts or 0,
                        completed.stats.globals or 0))
                end, duration)
                if report.status == "running" then
                    message("скан усіх доступних об'єктів триває; дочекайтеся повідомлення про завершення")
                else
                    message("скан: " .. tostring(report.status))
                end
            end
            local multi_duration = value:match("^multi%s*(%d*)$")
            if multi_duration then
                local duration = math.min(math.max(tonumber(multi_duration) or 15, 1), 60)
                message(string.format("сканую всі доступні UI-об'єкти протягом %d с", duration))
                start_full_scan(duration)
            else
                local delay = tonumber(value)
                if delay and delay > 0 then
                    delay = math.min(delay, 30)
                    message(string.format("повний скан почнеться через %.1f с", delay))
                    scheduler.request("manual-full-object-scan", nil, start_full_scan,
                        delay)
                else
                    start_full_scan()
                end
            end
        elseif command == "window" then
            local function capture_window()
                local ok, report = pcall(tooltips.scan_window)
                if not ok then
                    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
                    UA_ForeverDB.scan.windowProbe = { status = "error",
                        error = tostring(report) }
                    message("скан вікна завершився помилкою; її записано в SavedVariables")
                    return
                end
                message(string.format("скан вікна: %s; об'єктів %d; верхніх вікон %d",
                    report.status, #report.objects, #report.topLevel))
                message("зробіть /reload; результат: UA_ForeverDB.scan.windowProbe")
            end
            local duration = tonumber(value)
            if duration and duration > 0 then
                duration = math.min(duration, 30)
                UA_ForeverDB.scan = UA_ForeverDB.scan or {}
                UA_ForeverDB.scan.windowProbe = { status = "waiting" }
                message(string.format("шукаю відкрите вікно підказки протягом %.1f с", duration))
                scheduler.cancel("manual-window-capture")
                local attempts, max_attempts = 0, math.max(1, math.ceil(duration * 4))
                local function poll()
                    attempts = attempts + 1
                    if tooltips.visible_window() or attempts >= max_attempts then
                        capture_window()
                    else
                        scheduler.request("manual-window-capture", nil, poll, 0.25)
                    end
                end
                scheduler.request("manual-window-capture", nil, poll, 0.25)
            else
                capture_window()
            end
        elseif command == "castbar" then
            local delay_text, duration_text = value:match("^(%S*)%s*(%S*)$")
            local delay = math.max(0, math.min(tonumber(delay_text) or 0, 30))
            local duration = math.max(0, math.min(tonumber(duration_text) or 0, 10))
            scheduler.cancel("manual-cast-bar-capture")
            local report = { version = 1, status = "waiting", delay = delay,
                duration = duration, samples = {} }
            tooltip_diagnostics.append_report("castBarProbe", report)
            local started
            local function capture_cast_bar()
                started = started or GetTime()
                local ok, snapshot = pcall(cast_bar_adapter.capture)
                if not ok then
                    report.status, report.error = "error", tostring(snapshot)
                    message(cast_bar_probe_text.error)
                    return
                end
                snapshot.elapsed = GetTime() - started
                report.samples[#report.samples + 1] = snapshot
                report.status = "capturing"
                if #report.samples == 1 then report.timestamp = snapshot.timestamp end
                if snapshot.elapsed < duration then
                    scheduler.request("manual-cast-bar-capture", nil,
                        capture_cast_bar, 0.1)
                    return
                end
                report.status = "captured"
                local visible, translated = 0, 0
                for _, sample in ipairs(report.samples) do
                    visible = math.max(visible, sample.visibleCount)
                    translated = math.max(translated, sample.translatedCount)
                end
                message(string.format(cast_bar_probe_text.summary,
                    visible, translated, report.sequence))
                local display_sample = snapshot
                if snapshot.visibleCount == 0 then
                    for index = #report.samples, 1, -1 do
                        if report.samples[index].visibleCount > 0 then
                            display_sample = report.samples[index]
                            break
                        end
                    end
                end
                for _, row in ipairs(display_sample.frames) do
                    if row.frame.IsVisible.value == true then
                        message(string.format(cast_bar_probe_text.row, row.name,
                            row.native.GetText.value or "?", row.availableTranslation or "?",
                            tostring(row.translationVisible), row.reason))
                    end
                end
                message(cast_bar_probe_text.saved)
            end
            if delay > 0 or duration > 0 then
                message(string.format(cast_bar_probe_text.delayed, delay, duration))
            end
            if delay > 0 then
                scheduler.request("manual-cast-bar-capture", nil, capture_cast_bar, delay)
            else
                capture_cast_bar()
            end
        elseif command == "combatlog" then
            local text = addon_table.addon_locale_uk.combat_log_probe
            local ok, report = pcall(addon_table.use("combat_log").probe)
            if not ok then
                report = { version = 1, status = "probe_error",
                    error = runtime.safe_string_or_nil(report) }
            end
            tooltip_diagnostics.append_report("combatLogProbe", report)
            if report.status == "probe_disabled" then
                message(text.disabled)
                return
            end
            message(string.format(text.summary, report.status))
            if report.before then message(text.before .. report.before) end
            if report.after then message(text.after .. report.after) end
            if report.error then message(report.error) end
            message(text.saved)
        elseif command == "panel" then
            local function capture_panel()
                local ok, report = pcall(tooltips.capture_panel)
                if not ok then
                    tooltip_diagnostics.append_report("panelProbe", {
                        version = 1, status = "error", error = tostring(report),
                    })
                    message(panel_probe_text.error)
                    return
                end
                message(string.format(panel_probe_text.summary,
                    report.status, #report.objects, report.sequence or 0,
                    report.truncated and panel_probe_text.truncated or ""))
                message(panel_probe_text.saved)
            end
            local delay = tonumber(value)
            scheduler.cancel("manual-panel-capture")
            if delay and delay > 0 then
                delay = math.min(delay, 30)
                message(string.format(panel_probe_text.delayed, delay))
                scheduler.request("manual-panel-capture", nil,
                    capture_panel, delay)
            else
                capture_panel()
            end
        elseif command == "ui" then
            local stats = strings.translate_visible_ui()
            message(string.format("UI: перевірено %d фреймів, перекладено %d написів", stats.frames, stats.translated))
        elseif command == "capture" then
            local function run_capture()
                local stats = strings.capture_visible_ui()
                message(string.format("UI capture: перевірено %d фреймів, знайдено %d написів, нових %d, усього %d",
                    stats.frames, stats.captured, stats.new, stats.unique))
            end
            local delay = tonumber(value)
            if delay and delay > 0 then
                delay = math.min(delay, 30)
                message(string.format("захоплення UI через %.1f с — відкрийте потрібне меню", delay))
                manual_capture_sequence = manual_capture_sequence + 1
                scheduler.request("manual-ui-capture:" .. manual_capture_sequence,
                    nil, run_capture, delay)
            else
                run_capture()
            end
        elseif command == "export" then
            settings_ui.show_export_window()
        elseif command == "scan" then
            message("починаю перевірку API та вибіркове зіставлення даних...")
            local report = scanner.run()
            message(scanner.summary(report))
        elseif command == "report" then
            message(scanner.summary())
        elseif command == "status" or command == "" then
            show_status()
        else
            message("команди: /uaf status, /uaf owner, /uaf tooltip [рядки|all [секунди]|write ID [секунди]], /uaf aura [секунди], /uaf window [секунди], /uaf fullscan [секунди|multi 15], /uaf ui, /uaf capture [секунди], /uaf export, /uaf scan, /uaf report, /uaf menus, /uaf autoscan on|off, /uaf on, /uaf off, /uaf dev on|off" .. panel_probe_text.help .. cast_bar_probe_text.help)
        end
    end
end

local event_frame = CreateFrame("Frame")
event_frame:RegisterEvent("ADDON_LOADED")
event_frame:RegisterEvent("PLAYER_LOGIN")
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
event_frame:RegisterEvent("GOSSIP_SHOW")
event_frame:RegisterEvent("TRAINER_SHOW")
event_frame:RegisterEvent("TRAINER_UPDATE")
event_frame:RegisterEvent("QUEST_DETAIL")
event_frame:RegisterEvent("QUEST_PROGRESS")
event_frame:RegisterEvent("QUEST_COMPLETE")
event_frame:RegisterEvent("QUEST_GREETING")
event_frame:RegisterEvent("QUEST_LOG_UPDATE")
event_frame:RegisterEvent("ITEM_TEXT_BEGIN")
event_frame:RegisterEvent("ITEM_TEXT_READY")
event_frame:RegisterEvent("COMBAT_TEXT_UPDATE")

local event_scopes = {
    PLAYER_REGEN_ENABLED = "main", GOSSIP_SHOW = "gossip", TRAINER_SHOW = "trainer",
    TRAINER_UPDATE = "trainer", QUEST_DETAIL = "quest", QUEST_PROGRESS = "quest",
    QUEST_COMPLETE = "quest", QUEST_GREETING = "quest", QUEST_LOG_UPDATE = "quest",
    ITEM_TEXT_BEGIN = "books", ITEM_TEXT_READY = "books", COMBAT_TEXT_UPDATE = "combat-text",
}
if options.on_activity_change then
    options.on_activity_change("main-events", function ()
        for event, scope in pairs(event_scopes) do
            if options.work_enabled(scope) then event_frame:RegisterEvent(event)
            else event_frame:UnregisterEvent(event) end
        end
    end)
end

event_frame:SetScript("OnEvent", function (self, event, ...)
    local scope = event_scopes[event]
    if scope and options.work_enabled and not options.work_enabled(scope) then return end
    if event == "ADDON_LOADED" then
        local loaded_addon = ...
        if loaded_addon == "ForeverVO" then
            quest_switcher.prepare()
            forever_vo_ui.prepare()
        end
        if loaded_addon ~= addon_name then
            if self.uaForeverLoginReady and type(loaded_addon) == "string"
                and loaded_addon:find("^Blizzard_") then
                strings.prepare()
                quest_switcher.prepare()
                quest_ui.prepare()
                gossip_ui.prepare()
                map_labels.prepare()
                edit_mode.prepare()
                level_up_display.prepare()
                achievements.prepare()
                tooltips.prepare()
                fonts.prepare()
                prepare_panel_hooks()
                settings_ui.prepare()
                prepare_menu_panels()
                items.prepare()
                profession_frame_adapter.prepare()
                profession_recipe_adapter.prepare()
                talent_frame_adapter.prepare()
                skills.prepare()
                addon_table.use("faction_client_db").prepare()
                cast_bar_adapter.prepare()
                loss_of_control_adapter.prepare()
                mirror_timer_adapter.prepare()
                addon_table.use("combat_log").prepare()
                chat_links.prepare()
                chat_config_ui.prepare()
                prepare_nameplates()
                target_frame.prepare()
                registry.prepare_root_hooks()
                registry.install_hooks(loaded_addon)
                schedule_panel_refresh()
            end
            return
        end

        utils.prepare()
        options.prepare()
        dev_log.prepare()
        fonts.prepare()
        strings.prepare()
        register_slash_command()
        self.uaForeverReady = true

        if not utils.is_forever then
            message("непідтримуваний клієнт; очікується WoW Forever Interface 16001")
        end

    elseif event == "PLAYER_LOGIN" then
        local ok, err = pcall(entries.prepare)
        if not ok then
            dev_log.issue("entries.prepare", tostring(err))
            message("помилка підготовки словників: " .. tostring(err))
            return
        end

        translation.prepare()
        resolver.prepare()
        registry.register_defaults(strings.translate_frame)
        registry.prepare_root_hooks()
        tooltips.prepare()
        chats.prepare()
        chat_links.prepare()
        addon_table.use("combat_log").prepare()
        chat_config_ui.prepare()
        prepare_nameplates()
        target_frame.prepare()
        prepare_panel_hooks()
        settings_ui.prepare()
        prepare_menu_panels()
        items.prepare()
        profession_frame_adapter.prepare()
        profession_recipe_adapter.prepare()
        talent_frame_adapter.prepare()
        quest_switcher.prepare()
        quest_ui.prepare()
        gossip_ui.prepare()
        map_labels.prepare()
        edit_mode.prepare()
        level_up_display.prepare()
        achievements.prepare()
        skills.prepare()
        addon_table.use("faction_client_db").prepare()
        cast_bar_adapter.prepare()
        loss_of_control_adapter.prepare()
        mirror_timer_adapter.prepare()
        registry.install_hooks()
        self.uaForeverLoginReady = true
        show_status()

    elseif event == "PLAYER_ENTERING_WORLD" then
        if self.uaForeverInitialWorldRefresh then return end
        self.uaForeverInitialWorldRefresh = true

        local function refresh_after_login()
            fonts.prepare()
            prepare_menu_panels()
            registry.refresh_open()
        end
        scheduler.request("world-surfaces", nil, refresh_after_login)
        scheduler.request("world-font-retry", nil, refresh_after_login, 1)

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Writes to protected regions are intentionally skipped in combat.
        -- Once combat ends, retry only the surfaces that are still visible.
        scheduler.request("post-combat-surfaces", nil, function ()
            if fonts.refresh_damage_text_font then fonts.refresh_damage_text_font() end
            if runtime.retry_deferred then runtime.retry_deferred() end
            registry.refresh_open()
            if tooltips.refresh_active then tooltips.refresh_active() end
            if map_labels.refresh_active then map_labels.refresh_active() end
        end)
        -- Combat tracker updates skip the domain post-hook entirely, so there
        -- may be no deferred text claim for retry_deferred to restore.
        scheduler.request("quest-tracker-progress", nil,
            quest_ui.refresh_tracker_progress, 0.2)
    elseif event == "ITEM_TEXT_BEGIN" then
        scanner.begin_book(...)
    elseif event == "ITEM_TEXT_READY" then
        scanner.note_book(...)
        scheduler.request("book-page-refresh", nil, function ()
            book_ui.refresh()
            scanner.capture_book_page()
        end)
    elseif event == "COMBAT_TEXT_UPDATE" then
        auto_scan.surface_event("combat-text", event)
        if type(strings.capture_combat_text_event) == "function" then
            strings.capture_combat_text_event(...)
        end
        if type(strings.refresh_combat_text) == "function" then
            strings.refresh_combat_text()
        end
    elseif event == "TRAINER_SHOW" or event == "TRAINER_UPDATE" then
        schedule_trainer_refresh(event)
    elseif event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS"
        or event == "QUEST_COMPLETE" or event == "QUEST_GREETING" then
        if event ~= "GOSSIP_SHOW" and event ~= "QUEST_GREETING" then
            schedule_current_quest_capture(event)
        elseif event == "QUEST_GREETING" then
            auto_scan.surface_event("quest-greeting", event)
            quest_greeting_shown()
        end
        schedule_panel_refresh({ "quest-gossip", "items" })
    elseif event == "QUEST_LOG_UPDATE" then
        if options.account.auto_scan_content or options.account.dev_mode then
            scheduler.request("quest-log-capture", nil,
                scanner.capture_quest_log, 0.2)
        end
        scheduler.request("quest-tracker-progress", nil,
            quest_ui.refresh_tracker_progress, 0.2)
    end
end)
