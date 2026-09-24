local addon_name, addon_table = ...

local assets = addon_table.use("assets")
local chats = addon_table.use("chats")
local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local fonts = addon_table.use("fonts")
local gossip_ui = addon_table.use("gossip_ui")
local items = addon_table.use("items")
local map_labels = addon_table.use("map_labels")
local menus_ui = addon_table.use("menus_ui")
local options = addon_table.use("options")
local quest_switcher = addon_table.use("quest_switcher")
local quest_ui = addon_table.use("quest_ui")
local scanner = addon_table.use("scanner")
local settings_ui = addon_table.use("settings_ui")
local skills = addon_table.use("skills")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local translation = addon_table.use("translation")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local hooks = addon_table.use("translation_hooks").bind("main")
local utils = addon_table.use("utils")

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

local function target_name_region()
    if not TargetFrame then return nil end
    local ok, region = pcall(function ()
        if TargetFrame.name then return TargetFrame.name end
        local content = TargetFrame.TargetFrameContent
        local main = content and content.TargetFrameContentMain
        return main and (main.Name or main.name) or nil
    end)
    return ok and region or nil
end

local function update_target_name()
    if not options.can_lookup("translate_npc", "translate_npc_target_frame") then return end
    local id = utils.npc_id_from_unit_id("target")
    if not id then return end

    local entry = entries.get_entry("npc", id)
    local source = safe_unit_name("target")
    dev_log.record_id("npcs", id, source, entry ~= nil)
    if not entry then
        dev_log.missing_npc(id, source)
        return
    end

    local region = target_name_region()
    if source and region
        and options.can_translate("translate_npc", "translate_npc_target_frame") then
        local visible_ok, visible = pcall(function () return region:GetText() end)
        local claim = runtime.get(region)
        if not visible_ok or is_secret(visible)
            or (visible ~= source
                and not (claim and claim.source == source
                    and visible == claim.translated)) then return end
        runtime.apply(region, { owner = "npc-target", slot = "npc.name",
            source = source, translated = utils.cap(entry[1]),
            priority = runtime.PRIORITY.DOMAIN })
    end
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

local function refresh_open_panels()
    update_quest_npc_name()
    items.refresh_quest_rewards()
    registry.refresh_open()
    quest_switcher.refresh()
end

local function schedule_panel_refresh()
    scheduler.request("open-panels", nil, refresh_open_panels)
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
    scheduler.request("quest-capture:" .. event .. ":retry", nil, capture, 0.2)
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
        -- ShowUIPanel runs after the native initial text writes. The surface
        -- refresh handles static labels; pooled rows have domain post-hooks.
        local surface = registry.find_frame(frame)
        if surface then registry.refresh(surface.id) else strings.translate_frame(frame) end
    end
    schedule_menu_scan(scanner.frame_key(frame))
end

local function selected_tab(frame, tab)
    -- PanelTemplates_SetTab runs after Blizzard selects the tab.
    local surface = registry.find_frame(frame)
    if surface then registry.refresh(surface.id) else strings.translate_frame(frame) end
    local frame_key = scanner.frame_key(frame)
    if frame_key then
        schedule_menu_scan(scanner.menu_key(frame_key .. ":tab", tab, frame))
    end
end

local function translate_character_subframe(_, subframe_name)
    local subframe = type(subframe_name) == "string" and _G[subframe_name] or nil
    if subframe then strings.translate_frame(subframe) end
end

local function translate_character_title(frame)
    if frame and type(frame.GetTitleText) == "function" then
        local ok, region = pcall(frame.GetTitleText, frame)
        if ok then strings.translate_region(region) end
    end
end

local function translate_character_level(region)
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region)
    local ok, source = pcall(region.GetText, region)
    if not ok or type(source) ~= "string" or is_secret(source) then return end
    local class = type(_G.UnitClass) == "function" and _G.UnitClass("player")
    if type(class) ~= "string" or class == "" or is_secret(class) then return end
    local translated = strings.find_ui_translation(class)
    if not translated then return end
    local start_at, end_at = source:find(class, 1, true)
    if not start_at then return end
    runtime.apply(region, { owner = "character-level",
        slot = "character.level_class", source = source,
        translated = source:sub(1, start_at - 1) .. translated
            .. source:sub(end_at + 1),
        priority = runtime.PRIORITY.CONTEXT })
end

local function prepare_panel_hooks()
    if type(_G.hooksecurefunc) ~= "function" then return end
    hooks.global("ShowUIPanel", opened_panel)
    hooks.global("PanelTemplates_SetTab", selected_tab)
    hooks.global("QuestFrame_SetPortrait", update_quest_npc_name)
    hooks.global("QuestFrameGreetingPanel_OnShow", update_quest_npc_name)
    -- QuestInfo_Display and ShowRewards have domain post-hooks in quest_ui and
    -- items; refreshing every open surface here would rescan the entire map
    -- for a single quest text update.

    hooks.region_script(_G.ContainerFrameCombinedBags, "OnShow", opened_panel)
    hooks.region_script(_G.ObjectiveTrackerFrame, "OnShow", opened_panel)
    -- Blizzard_MacroUI is loaded on demand. ADDON_LOADED calls this function
    -- again, so the hook is installed as soon as MacroFrame becomes available.
    hooks.region_script(_G.MacroFrame, "OnShow", opened_panel)

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
        "OnShow", opened_panel)
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

local function prepare_target_frame()
    hooks.region(_G.TargetFrame, "Update", update_target_name)
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

local manual_capture_sequence = 0
local function register_slash_command()
    _G.SLASH_UAFOREVER1 = "/uaf"
    SlashCmdList.UAFOREVER = function (input)
        local command, value = tostring(input or ""):lower():match("^(%S*)%s*(.-)$")
        if command == "on" then
            options.account.enabled = true
            runtime.refresh_policy()
            registry.refresh_open()
            if tooltips.refresh_active then tooltips.refresh_active() end
            message("переклад увімкнено")
        elseif command == "off" then
            options.account.enabled = false
            runtime.refresh_policy()
            if tooltips.refresh_active then tooltips.refresh_active() end
            message("переклад вимкнено")
        elseif command == "dev" and (value == "on" or value == "off") then
            options.account.dev_mode = value == "on"
            message("режим розробки " .. (options.account.dev_mode and "увімкнено" or "вимкнено"))
        elseif command == "autoscan" and (value == "on" or value == "off") then
            options.account.auto_scan_menus = value == "on"
            message("автоскан меню " .. (options.account.auto_scan_menus and "увімкнено" or "вимкнено"))
        elseif command == "menus" then
            message(string.format("автосканом пройдено меню: %d", scanner.menu_count()))
        elseif command == "owner" then
            local frame = type(_G.GetMouseFocus) == "function" and _G.GetMouseFocus() or nil
            if not frame and type(_G.GetMouseFoci) == "function" then
                local ok, foci = pcall(_G.GetMouseFoci)
                if ok and type(foci) == "table" then frame = foci[1] end
            end
            local region = frame
            if frame and type(frame.GetFontString) == "function" then
                local ok, value = pcall(frame.GetFontString, frame)
                if ok and value then region = value end
            end
            local claim = region and runtime.get(region)
            if claim then
                message(string.format("owner=%s; slot=%s; source=%s; translation=%s; generation=%s",
                    tostring(claim.owner), tostring(claim.slot), tostring(claim.source),
                    tostring(claim.translated), tostring(claim.generation)))
            else
                message("для елемента під курсором немає translation claim")
            end
        elseif command == "tooltip" then
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
                message("немає відкритої підказки")
            else
                local function short(text)
                    if type(text) ~= "string" then return "?" end
                    text = text:gsub("%s+", " ")
                    return #text > 55 and text:sub(1, 55) .. "…" or text
                end
                local limit = math.max(1, math.min(tonumber(value) or 12, 20))
                local lines = tooltips.inspect(tooltip, limit)
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
            UA_ForeverDB.scan = UA_ForeverDB.scan or {}
            local status = { state = "waiting", attempts = 0 }
            UA_ForeverDB.scan.auraCapture = status
            local function capture_aura()
                local tooltip = _G.GameTooltip
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
                    message(string.format("скан аури: ID %s, ID за назвою %s, рядків %s, переклад %s → %s",
                        tostring(before.spellID or before.id or "?"),
                        tostring(before.titleID or "?"), tostring(before.numLines or "?"),
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
                    if tooltips.aura_probe_candidate(_G.GameTooltip) then
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
        elseif command == "scan" then
            message("починаю перевірку API та вибіркове зіставлення даних...")
            local report = scanner.run()
            message(scanner.summary(report))
        elseif command == "report" then
            message(scanner.summary())
        elseif command == "status" or command == "" then
            show_status()
        else
            message("команди: /uaf status, /uaf owner, /uaf tooltip [рядки], /uaf aura [секунди], /uaf window [секунди], /uaf ui, /uaf capture [секунди], /uaf scan, /uaf report, /uaf menus, /uaf autoscan on|off, /uaf on, /uaf off, /uaf dev on|off")
        end
    end
end

local event_frame = CreateFrame("Frame")
event_frame:RegisterEvent("ADDON_LOADED")
event_frame:RegisterEvent("PLAYER_LOGIN")
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
            if self.uaForeverLoginReady and type(loaded_addon) == "string"
                and loaded_addon:find("^Blizzard_") then
                quest_switcher.prepare()
                quest_ui.prepare()
                gossip_ui.prepare()
                map_labels.prepare()
                tooltips.prepare()
                fonts.prepare()
                prepare_panel_hooks()
                settings_ui.prepare()
                menus_ui.prepare()
                items.prepare()
                skills.prepare()
                prepare_nameplates()
                prepare_target_frame()
                registry.prepare_root_hooks()
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
        prepare_nameplates()
        prepare_target_frame()
        prepare_panel_hooks()
        settings_ui.prepare()
        menus_ui.prepare()
        items.prepare()
        quest_switcher.prepare()
        quest_ui.prepare()
        gossip_ui.prepare()
        map_labels.prepare()
        skills.prepare()
        update_target_name()
        scheduler.request("compatibility-scan", nil, function ()
            local ok, report = pcall(scanner.run)
            if ok then
                message("перевірка сумісності: " .. scanner.summary(report))
            else
                dev_log.issue("scanner.run", tostring(report))
                message("сканер сумісності завершився помилкою; увімкніть /uaf dev on")
            end
        end, 2)
        self.uaForeverLoginReady = true
        show_status()

    elseif event == "PLAYER_ENTERING_WORLD" then
        if self.uaForeverInitialWorldRefresh then return end
        self.uaForeverInitialWorldRefresh = true

        local function refresh_after_login()
            fonts.prepare()
            menus_ui.prepare()
            registry.refresh_open()
        end
        scheduler.request("world-surfaces", nil, refresh_after_login)
        scheduler.request("world-font-retry", nil, refresh_after_login, 1)

    elseif event == "PLAYER_TARGET_CHANGED" then
        update_target_name()
    elseif event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS"
        or event == "QUEST_COMPLETE" or event == "QUEST_GREETING" then
        if event ~= "GOSSIP_SHOW" and event ~= "QUEST_GREETING" then
            schedule_current_quest_capture(event)
        end
        schedule_panel_refresh()
    elseif event == "QUEST_LOG_UPDATE" then
        scheduler.request("quest-log-capture", nil,
            scanner.capture_quest_log, 0.2)
    end
end)
