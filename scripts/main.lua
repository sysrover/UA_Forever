local addon_name, addon_table = ...

local assets = addon_table.use("assets")
local chats = addon_table.use("chats")
local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local fonts = addon_table.use("fonts")
local menus_ui = addon_table.use("menus_ui")
local options = addon_table.use("options")
local quest_switcher = addon_table.use("quest_switcher")
local scanner = addon_table.use("scanner")
local settings_ui = addon_table.use("settings_ui")
local skills = addon_table.use("skills")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")

local function message(text)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(assets.icon_ua_inline .. " |cff55aaffUA Forever:|r " .. text)
    end
end

local function translated_npc_name(unit)
    if not options.can_translate("translate_npc") then return nil end
    local id = utils.npc_id_from_unit_id(unit)
    local entry = id and entries.get_entry("npc", id)
    if id then
        dev_log.record_id("npcs", id, UnitName(unit), entry ~= nil)
        if not entry then dev_log.missing_npc(id, UnitName(unit)) end
    end
    return entry and utils.cap(entry[1]) or nil
end

local function target_name_region()
    if not TargetFrame then return nil end
    if TargetFrame.name then return TargetFrame.name end

    local content = TargetFrame.TargetFrameContent
    local main = content and content.TargetFrameContentMain
    return main and (main.Name or main.name) or nil
end

local function update_target_name()
    if type(_G.issecretvalue) == "function" then return end
    if not options.can_lookup("translate_npc", "translate_npc_target_frame") then return end
    local id = utils.npc_id_from_unit_id("target")
    if not id then return end

    local entry = entries.get_entry("npc", id)
    dev_log.record_id("npcs", id, UnitName("target"), entry ~= nil)
    if not entry then
        dev_log.missing_npc(id, UnitName("target"))
        return
    end

    local region = target_name_region()
    if region and region.SetText and options.can_translate("translate_npc", "translate_npc_target_frame") then
        region:SetText(utils.cap(entry[1]))
    end
end

local function update_quest_npc_name()
    if not options.can_translate("translate_npc") then return end
    local name = translated_npc_name("questnpc") or translated_npc_name("npc")
    if name and QuestFrameNpcNameText and QuestFrameNpcNameText.SetText then
        QuestFrameNpcNameText:SetText(name)
    end
end

local function update_gossip_npc_name()
    if not options.can_translate("translate_npc") then return end
    local name = translated_npc_name("npc")
    if name and GossipFrame and type(GossipFrame.SetGossipTitle) == "function" then
        GossipFrame:SetGossipTitle(name)
    end
end

local function set_quest_item_name(font_string, item_link)
    if not font_string or not font_string.SetText or type(item_link) ~= "string" then return end
    local id = utils.item_id_from_link(item_link)
    local entry = id and entries.get_entry("item", id)
    if id then
        dev_log.record_id("items", id, item_link:match("%[(.-)%]"), entry ~= nil)
    end
    if entry and entry[1] then
        local ukrainian = utils.cap(entry[1])
        local english = item_link:match("%[(.-)%]")
        if options.is_bilingual_tooltip() and english and english ~= ukrainian then
            font_string:SetText(english .. " / " .. ukrainian)
        else
            font_string:SetText(ukrainian)
        end
    elseif id then
        dev_log.missing_item(id, item_link:match("%[(.-)%]") or item_link)
    end
end

local function update_quest_reward_names()
    if not options.can_translate("translate_item", "translate_quest_item") then return end
    local rewards = QuestInfoFrame and QuestInfoFrame.rewardsFrame
    local buttons = rewards and rewards.RewardButtons
    local get_item_link = QuestInfoFrame and QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink
    if type(buttons) ~= "table" or type(get_item_link) ~= "function" then return end

    for _, button in ipairs(buttons) do
        if button.IsShown and button:IsShown() and button.objectType == "item" and button.type and button.GetID then
            local ok, item_link = pcall(get_item_link, button.type, button:GetID())
            if ok then set_quest_item_name(button.Name, item_link) end
        end
    end
end

local function refresh_open_panels()
    update_quest_npc_name()
    update_gossip_npc_name()
    update_quest_reward_names()
    strings.translate_visible_ui()
    quest_switcher.refresh()
end

local function schedule_panel_refresh()
    if not C_Timer then
        refresh_open_panels()
        return
    end
    C_Timer.After(0, refresh_open_panels)
end

local function schedule_current_quest_capture(event)
    local function capture()
        local ok, err = pcall(scanner.capture_current_quest, event)
        if not ok then
            dev_log.issue("quest capture: " .. tostring(event), tostring(err))
        end
    end

    if not C_Timer or type(C_Timer.After) ~= "function" then
        capture()
        return
    end

    -- The first pass normally sees the data immediately. The short retry
    -- covers Camelot panels whose text getters are filled one frame later.
    C_Timer.After(0, capture)
    C_Timer.After(0.2, capture)
end

local function schedule_menu_scan(key)
    if not options.account or not options.account.auto_scan_menus then return end
    scanner.schedule_menu_capture(key, function (captured_key, stats)
        message(string.format("автоскан: %s; нових рядків %d; меню пройдено %d",
            captured_key, stats.new or 0, scanner.menu_count()))
    end)
end

local function opened_panel(frame)
    -- Forever's escape menu and Settings panel have dedicated native-mixin
    -- hooks. Running the generic delayed walker as well causes a visible
    -- second replacement pass and can touch protected internal controls.
    if frame ~= _G.GameMenuFrame and frame ~= _G.SettingsPanel then
        -- ShowUIPanel is post-hooked, so all native SetText calls for the
        -- initial view have completed. Bind visible safe FontStrings now;
        -- future pooled-row refreshes are translated synchronously by their
        -- own SetText calls rather than by a visible delayed second pass.
        strings.translate_frame(frame)
    end
    schedule_menu_scan(scanner.frame_key(frame))
end

local function selected_tab(frame, tab)
    -- PanelTemplates_SetTab is post-hooked: translate the selected panel in
    -- the same call instead of scheduling a second visible replacement pass.
    strings.translate_frame(frame)
    local frame_key = scanner.frame_key(frame)
    if frame_key then
        schedule_menu_scan(scanner.menu_key(frame_key .. ":tab", tab, frame))
    end
end

local panel_hooks = {}

local function hook_global_once(name, callback)
    if panel_hooks[name] or type(_G[name]) ~= "function" then return end
    hooksecurefunc(name, callback)
    panel_hooks[name] = true
end

local function hook_frame_on_show_once(key, frame)
    if panel_hooks[key] or not frame or not frame.HookScript then return end
    frame:HookScript("OnShow", opened_panel)
    panel_hooks[key] = true
end

local function hook_owner_once(key, owner, method, callback)
    if panel_hooks[key] or not owner or type(owner[method]) ~= "function" then return end
    local ok = pcall(hooksecurefunc, owner, method, callback)
    if ok then panel_hooks[key] = true end
end

local function translate_character_frame(frame, subframe_name)
    local subframe = type(subframe_name) == "string" and _G[subframe_name] or nil
    if subframe then strings.translate_frame(subframe) end
    strings.translate_frame(frame or _G.CharacterFrame)
end

local function prepare_panel_hooks()
    if type(_G.hooksecurefunc) ~= "function" then return end
    hook_global_once("ShowUIPanel", opened_panel)
    hook_global_once("PanelTemplates_SetTab", selected_tab)
    hook_global_once("QuestFrame_SetPortrait", update_quest_npc_name)
    hook_global_once("QuestInfo_ShowRewards", schedule_panel_refresh)
    hook_global_once("QuestInfo_Display", schedule_panel_refresh)

    hook_frame_on_show_once("ContainerFrameCombinedBags.OnShow", _G.ContainerFrameCombinedBags)
    hook_frame_on_show_once("ObjectiveTrackerFrame.OnShow", _G.ObjectiveTrackerFrame)
    -- Blizzard_MacroUI is loaded on demand. ADDON_LOADED calls this function
    -- again, so the hook is installed as soon as MacroFrame becomes available.
    hook_frame_on_show_once("MacroFrame.OnShow", _G.MacroFrame)

    -- Camelot's character tabs and the equipment manager are not opened with
    -- ShowUIPanel. Hook their real owners after Blizzard has populated text.
    hook_owner_once("CharacterFrame.ShowSubFrame", _G.CharacterFrame,
        "ShowSubFrame", translate_character_frame)
    hook_owner_once("CharacterFrame.RefreshDisplay", _G.CharacterFrame,
        "RefreshDisplay", translate_character_frame)
    local paper_doll = _G.PaperDollFrame
    hook_frame_on_show_once("PaperDollFrame.EquipmentManagerPane.OnShow",
        paper_doll and paper_doll.EquipmentManagerPane)
end

local function prepare_nameplates()
    if type(_G.issecretvalue) == "function" then return end
    if type(_G.CompactUnitFrame_UpdateName) ~= "function" or type(_G.hooksecurefunc) ~= "function" then
        return
    end

    hooksecurefunc("CompactUnitFrame_UpdateName", function (frame)
        if not frame or not frame.unit or not options.can_translate("translate_npc", "translate_nameplates") then
            return
        end
        if frame.IsForbidden and frame:IsForbidden() then return end

        local name = translated_npc_name(frame.unit)
        local region = frame.name or frame.Name
        if name and region and region.SetText then
            region:SetText(name)
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
    message(string.format(
        "v%s; WoW %s; Interface %s; переклад %s; автоскан %s (%d меню); dev %s; пропусків %d",
        tostring(utils.addon_version()),
        tostring(utils.build_version),
        tostring(utils.interface_version),
        options.account.enabled and "увімкнено" or "вимкнено",
        options.account.auto_scan_menus and "увімкнено" or "вимкнено",
        scanner.menu_count(),
        options.account.dev_mode and "увімкнено" or "вимкнено",
        missing_count()
    ))
end

local function register_slash_command()
    _G.SLASH_UAFOREVER1 = "/uaf"
    SlashCmdList.UAFOREVER = function (input)
        local command, value = tostring(input or ""):lower():match("^(%S*)%s*(.-)$")
        if command == "on" then
            options.account.enabled = true
            message("переклад увімкнено; для повного оновлення виконайте /reload")
        elseif command == "off" then
            options.account.enabled = false
            message("переклад вимкнено; для повного оновлення виконайте /reload")
        elseif command == "dev" and (value == "on" or value == "off") then
            options.account.dev_mode = value == "on"
            message("режим розробки " .. (options.account.dev_mode and "увімкнено" or "вимкнено"))
        elseif command == "autoscan" and (value == "on" or value == "off") then
            options.account.auto_scan_menus = value == "on"
            message("автоскан меню " .. (options.account.auto_scan_menus and "увімкнено" or "вимкнено"))
        elseif command == "menus" then
            message(string.format("автосканом пройдено меню: %d", scanner.menu_count()))
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
            if delay and delay > 0 and C_Timer then
                delay = math.min(delay, 30)
                message(string.format("захоплення UI через %.1f с — відкрийте потрібне меню", delay))
                C_Timer.After(delay, run_capture)
            else
                run_capture()
            end
        elseif command == "scan" then
            message("починаю перевірку API та вибіркове зіставлення даних...")
            local report = scanner.run()
            message(scanner.summary(report))
        elseif command == "report" then
            message(scanner.summary())
        elseif command == "status" or command == "" then
            show_status()
        else
            message("команди: /uaf status, /uaf ui, /uaf capture [секунди], /uaf scan, /uaf report, /uaf menus, /uaf autoscan on|off, /uaf on, /uaf off, /uaf dev on|off")
        end
    end
end

local event_frame = CreateFrame("Frame")
event_frame:RegisterEvent("ADDON_LOADED")
event_frame:RegisterEvent("PLAYER_LOGIN")
event_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
event_frame:RegisterEvent("GOSSIP_SHOW")
event_frame:RegisterEvent("QUEST_DETAIL")
event_frame:RegisterEvent("QUEST_PROGRESS")
event_frame:RegisterEvent("QUEST_COMPLETE")
event_frame:RegisterEvent("QUEST_GREETING")
event_frame:RegisterEvent("QUEST_LOG_UPDATE")

event_frame:SetScript("OnEvent", function (self, event, ...)
    if event == "ADDON_LOADED" then
        local loaded_addon = ...
        if loaded_addon ~= addon_name then
            if self.uaForeverReady and type(loaded_addon) == "string" and loaded_addon:find("^Blizzard_") then
                quest_switcher.prepare()
                fonts.prepare()
                prepare_panel_hooks()
                settings_ui.prepare()
                menus_ui.prepare()
                skills.prepare()
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
        tooltips.prepare()
        chats.prepare()
        prepare_nameplates()
        prepare_panel_hooks()
        settings_ui.prepare()
        menus_ui.prepare()
        quest_switcher.prepare()
        skills.prepare()
        update_target_name()
        if C_Timer then
            C_Timer.After(0, strings.translate_visible_ui)
            C_Timer.After(2, function ()
                local ok, report = pcall(scanner.run)
                if ok then
                    message("перевірка сумісності: " .. scanner.summary(report))
                else
                    dev_log.issue("scanner.run", tostring(report))
                    message("сканер сумісності завершився помилкою; увімкніть /uaf dev on")
                end
            end)
        end
        show_status()

    elseif event == "PLAYER_TARGET_CHANGED" then
        update_target_name()
    elseif event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS"
        or event == "QUEST_COMPLETE" or event == "QUEST_GREETING" then
        if event ~= "GOSSIP_SHOW" and event ~= "QUEST_GREETING" then
            schedule_current_quest_capture(event)
        end
        schedule_panel_refresh()
    elseif event == "QUEST_LOG_UPDATE" then
        if C_Timer and type(C_Timer.After) == "function" then
            C_Timer.After(0.2, scanner.capture_quest_log)
        else
            scanner.capture_quest_log()
        end
    end
end)
