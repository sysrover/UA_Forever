local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local quest_ui = addon_table.use("quest_ui")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local strings = addon_table.use("strings")
local translation = addon_table.use("translation")
local quest_switcher = addon_table.use("quest_switcher")
local walker = addon_table.use("translation_walker")
local utils = addon_table.use("utils")

local hooked
local dialog_hooks = {}
local method_hooks = setmetatable({}, { __mode = "k" })

local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function safe_text(region)
    if not region then return nil end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return nil end
    local ok, value = pcall(get_text, region)
    return ok and safe_string(value) or nil
end

local function replace_once(text, source, replacement)
    if not text or not source or not replacement then return nil end
    local first, last = text:find(source, 1, true)
    if not first then return nil end
    return text:sub(1, first - 1) .. replacement .. text:sub(last + 1)
end

local function english_title(id)
    local original = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(original) == "function" then
        local ok, value = pcall(original, id)
        if ok and safe_string(value) then return value end
    end
    local raw = addon_table.quest_faction and addon_table.quest_faction[id]
        or addon_table.quest_both and addon_table.quest_both[id]
    return raw and safe_string(raw.en) or nil
end

local function quest_name_region(region, id, owner)
    local current = safe_text(region)
    if region then runtime.clear(region) end
    if not options.can_lookup("translate_quest") then return false end
    local english = type(id) == "number" and english_title(id)
    local entry = english and entries.get_entry("quest", id)
    local ukrainian = entry and safe_string(entry[1])
    if not current or not english or not ukrainian then return false end
    ukrainian = utils.cap(ukrainian)
    local source = replace_once(current, ukrainian, english) or current
    local translated = replace_once(source, english, ukrainian)
    if not translated then return false end
    return runtime.apply(region, {
        owner = owner, slot = "quest:" .. id .. ".name",
        source = source, translated = translated, category = "quest",
        option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
    })
end

local function original_value(name, result_index, ...)
    local getter = translation.original and translation.original[name] or _G[name]
    if type(getter) ~= "function" then return nil end
    local ok, first, second = pcall(getter, ...)
    if not ok then return nil end
    return safe_string(result_index == 2 and second or first)
end

local function apply_dialog_language(region)
    local claim = region and runtime.get(region)
    if claim and claim.owner == "quest-dialog" then
        local english = translation.get_quest_language() == "en"
            or (claim.category == "quest" and not options.translate_name("quest"))
        runtime.show_original(region, english)
    end
end

quest_ui.refresh_dialog_language = function ()
    for _, name in ipairs({
        "QuestInfoTitleHeader", "QuestInfoDescriptionText",
        "QuestInfoObjectivesText", "QuestInfoRewardText",
        "QuestProgressTitleText", "QuestProgressText",
    }) do
        apply_dialog_language(_G[name])
    end
end

local function dialog_field(region, id, field, getter, result_index)
    if not region or not id or not options.can_lookup("translate_quest") then return end
    local current = safe_text(region)
    local slot = "quest:" .. id .. (field == 1 and ".name" or ".description:" .. field)
    local claim = runtime.get(region)
    if claim and claim.owner == "quest-dialog" and claim.slot == slot
        and current == claim.translated then
        apply_dialog_language(region)
        return
    end
    local entry = entries.get_entry("quest", id)
    local english = getter and original_value(getter, result_index or 1)
    local ukrainian = entry and safe_string(entry[field])
    if not current or not english or not ukrainian then return end
    if field == 1 then
        ukrainian = utils.cap(ukrainian)
    end
    local source, translated
    if field == 1 then
        source = replace_once(current, ukrainian, english) or current
        translated = replace_once(source, english, ukrainian)
    elseif current == english or current == ukrainian then
        source, translated = english, ukrainian
    end
    if not translated then return end
    runtime.clear(region)
    local applied = runtime.apply(region, {
        owner = "quest-dialog", slot = slot,
        source = source, translated = translated,
        category = field == 1 and "quest" or nil,
        option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN,
    })
    if applied then apply_dialog_language(region) end
end

local function dialog_quest_id()
    if _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
        and _G.C_QuestLog and type(_G.C_QuestLog.GetSelectedQuest) == "function" then
        local selected_ok, selected = pcall(_G.C_QuestLog.GetSelectedQuest)
        if selected_ok and type(selected) == "number" and selected > 0 then
            return selected
        end
    end
    local ok, id = pcall(translation.get_current_quest_id)
    if ok and type(id) == "number" then return id end
end

local function quest_info_field(region, field, live_getter, log_getter, log_result)
    local id = dialog_quest_id()
    local is_log = _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
    if is_log then
        dialog_field(region, id, field, log_getter, log_result)
    else
        dialog_field(region, id, field, live_getter)
    end
end

local function prepare_dialog_hook(name, callback)
    if dialog_hooks[name] or type(_G[name]) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, name, callback)
    if ok then dialog_hooks[name] = true end
end

local function prepare_method_hook(owner, name, callback)
    if not owner or type(owner[name]) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local hooked_names = method_hooks[owner]
    if hooked_names and hooked_names[name] then return end
    local ok = pcall(_G.hooksecurefunc, owner, name, callback)
    if ok then
        hooked_names = hooked_names or {}
        method_hooks[owner] = hooked_names
        hooked_names[name] = true
    end
end

local function prepare_extra_tracker_hooks()
    prepare_method_hook(_G.AutoQuestPopupBlockMixin, "Update",
        function (block, _, id)
            local contents = block and block.Contents
            quest_name_region(contents and contents.QuestName, id, "auto-quest-popup")
        end)
    local banner = _G.ObjectiveTrackerTopBannerFrame or _G.ObjectiveTrackerTopBannerMixin
    prepare_method_hook(banner, "PlayBanner", function (self)
        quest_name_region(self and self.Title, self and self.questID, "quest-banner")
    end)
    prepare_method_hook(_G.QuestObjectiveTrackerMixin, "OnBlockHeaderClick",
        function (self, block, mouse_button)
            if mouse_button ~= "RightButton" or not block
                or type(block.id) ~= "number" then return end
            local menu_api = _G.Menu
            if not menu_api or type(menu_api.GetManager) ~= "function" then return end
            local function active_menu()
                local ok, menu = pcall(function ()
                    return menu_api.GetManager():GetOpenMenu()
                end)
                return ok and menu or nil
            end
            local menu = active_menu()
            if not menu then return end
            local id = block.id
            local generation = runtime.next_generation(menu)
            scheduler.request("quest-tracker-menu:" .. tostring(menu), generation,
                function ()
                    if active_menu() ~= menu then return end
                    local owner_ok, expected_owner = pcall(self.GetContextMenuParent, self)
                    local menu_ok, actual_owner = pcall(menu.GetOwnerRegion, menu)
                    if not owner_ok or not menu_ok
                        or actual_owner ~= expected_owner then return end
                    local native = english_title(id)
                    if not native then return end
                    local matched = false
                    walker.walk(menu, function (region)
                        if matched or safe_text(region) ~= native then return end
                        matched = true
                        quest_name_region(region, id, "quest-tracker-menu")
                    end, nil, { frames = 0 })
                end, nil, menu)
        end)
    prepare_method_hook(_G.WorldMapBountyBoardMixin, "RefreshSelectedBounty",
        function (self)
            local index = self and self.selectedBountyIndex
            local bounty = index and self.bounties and self.bounties[index]
            local id = bounty and bounty.questID
            if type(id) == "number" then
                quest_name_region(self.BountyName, id, "quest-bounty-title")
            end
        end)
end

local function objective_region(region, slot, after_apply)
    local source = safe_text(region)
    if not source then return false end
    local previous = runtime.get(region)
    if previous and previous.slot == slot and source == previous.translated then
        return true
    end
    runtime.clear(region)
    if not options.can_lookup("translate_quest") then return false end
    local ok, translated = pcall(entries.translate_quest_objective_task, source)
    if not ok or not safe_string(translated) or translated == source then return false end
    return runtime.apply(region, {
        owner = "quest-objective", slot = slot, source = source,
        translated = translated, option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN, after_apply = after_apply,
    })
end

local function quest_log_titles(scroll)
    if not options.can_lookup("translate_quest") then return false end
    local pool = scroll and scroll.titleFramePool
    if not pool or type(pool.EnumerateActive) ~= "function" then return false end
    local changed = false
    for button in pool:EnumerateActive() do
        local id = button.questID
        local region = button.Text
        local current = safe_text(region)
        local info = button.info
        local english = info and safe_string(info.title)
        local entry = type(id) == "number" and entries.get_entry("quest", id)
        local ukrainian = entry and safe_string(entry[1])
        if current and english and ukrainian then
            ukrainian = utils.cap(ukrainian)
            local source = replace_once(current, ukrainian, english) or current
            local translated = replace_once(source, english, ukrainian)
            if translated then
                runtime.clear(region)
                changed = runtime.apply(region, {
                    owner = "quest-log", slot = "quest:" .. id .. ".name",
                    source = source, translated = translated, category = "quest",
                    option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
                }) or changed
            end
        elseif region then
            runtime.clear(region)
        end
    end
    local header_pool = scroll.headerFramePool
    if header_pool and type(header_pool.EnumerateActive) == "function" then
        for button in header_pool:EnumerateActive() do
            local ok, region = pcall(button.GetFontString, button)
            region = ok and region or nil
            local source = safe_text(region)
            local translated = source and entries.get_glossary_text(source, source)
            if region then runtime.clear(region) end
            if source and safe_string(translated) and translated ~= source then
                changed = runtime.apply(region, {
                    owner = "quest-log", slot = "quest-header:" .. tostring(button.questLogIndex) .. ".name",
                    source = source, translated = translated,
                    option = "translate_quest", priority = runtime.PRIORITY.CONTEXT,
                }) or changed
            end
        end
    end
    return changed
end

local function greeting_quest_id(button)
    local id_ok, index = pcall(button.GetID, button)
    if not id_ok or type(index) ~= "number" then return nil end
    if button.isActive == 1 and type(_G.GetActiveQuestID) == "function" then
        local ok, id = pcall(_G.GetActiveQuestID, index)
        return ok and type(id) == "number" and id or nil
    end
    if button.isActive == 0 and type(_G.GetAvailableQuestInfo) == "function" then
        local ok, _, _, _, _, id = pcall(_G.GetAvailableQuestInfo, index)
        return ok and type(id) == "number" and id or nil
    end
end

local function translate_quest_greeting()
    local greeting = _G.GreetingText
    local source = safe_text(greeting)
    if greeting then runtime.clear(greeting) end
    if source and options.can_lookup("translate_gossip") then
        local id_ok, npc_id = pcall(utils.npc_id_from_unit_id, "npc")
        if id_ok and type(npc_id) == "number" then
            local translated = entries.get_gossip_text_for_npc_talk(npc_id, source)
            if safe_string(translated) then
                runtime.apply(greeting, {
                    owner = "quest-greeting", slot = "npc:" .. npc_id .. ".greeting",
                    source = source, translated = translated,
                    option = "translate_gossip", priority = runtime.PRIORITY.DOMAIN,
                })
            end
        end
    end

    local panel = _G.QuestFrameGreetingPanel
    local pool = panel and panel.titleButtonPool
    if not pool or type(pool.EnumerateActive) ~= "function" then return end
    for button in pool:EnumerateActive() do
        local region_ok, region = pcall(button.GetFontString, button)
        region = region_ok and region or nil
        local name = safe_text(region)
        if region then runtime.clear(region) end
        local id = greeting_quest_id(button)
        if id and name and options.can_lookup("translate_gossip", "translate_quest") then
            local entry = entries.get_entry("quest", id)
            local translated = entry and safe_string(entry[1])
                or entries.get_glossary_text(name)
            if safe_string(translated) then
                runtime.apply(region, {
                    owner = "quest-greeting", slot = "quest:" .. id .. ".name",
                    source = name, translated = translated, category = "quest",
                    options = { "translate_gossip", "translate_quest" },
                    priority = runtime.PRIORITY.DOMAIN,
                    after_apply = function ()
                        local text_ok, height = pcall(button.GetTextHeight, button)
                        local icon = button.Icon
                        local icon_ok, icon_height
                        if icon and type(icon.GetHeight) == "function" then
                            icon_ok, icon_height = pcall(icon.GetHeight, icon)
                        end
                        if text_ok and icon_ok and type(height) == "number"
                            and type(icon_height) == "number" then
                            pcall(button.SetHeight, button, math.max(height + 2, icon_height))
                        end
                    end,
                })
            end
        end
    end
end

local function translate_dialog_title()
    local id = dialog_quest_id()
    local is_log = _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
    if not is_log then
        dialog_field(_G.QuestInfoTitleHeader, id, 1, "GetTitleText")
        return
    end
    local english = id and english_title(id)
    local region = _G.QuestInfoTitleHeader
    local current = safe_text(region)
    local slot = id and "quest:" .. id .. ".name"
    local claim = runtime.get(region)
    if claim and claim.owner == "quest-dialog" and claim.slot == slot
        and current == claim.translated then
        apply_dialog_language(region)
        return
    end
    local entry = id and entries.get_entry("quest", id)
    local ukrainian = entry and safe_string(entry[1])
    if not current or not english or not ukrainian then return end
    ukrainian = utils.cap(ukrainian)
    local source = replace_once(current, ukrainian, english) or current
    local translated = replace_once(source, english, ukrainian)
    if not translated then return end
    runtime.clear(region)
    local applied = runtime.apply(region, {
        owner = "quest-dialog", slot = slot,
        source = source, translated = translated, category = "quest",
        option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
    })
    if applied then apply_dialog_language(region) end
end

local function translate_info_objectives()
    local frame = _G.QuestInfoObjectivesFrame
    local rows = frame and frame.Objectives
    local id = dialog_quest_id()
    if not rows or not id then return end
    for index, row in ipairs(rows) do
        local shown_ok, shown = pcall(row.IsShown, row)
        if shown_ok and shown then
            objective_region(row, "quest:" .. id .. ":info-objective:" .. index)
        end
    end
end

local function prepare_dialog_hooks()
    prepare_dialog_hook("StaticPopup_Show", function (which, _, _, data)
        if which ~= "PREMADE_GROUP_INSECURE_SEARCH"
            and which ~= "ABANDON_QUEST"
            and which ~= "ABANDON_QUEST_WITH_ITEMS" then return end
        local id = data
        if which ~= "PREMADE_GROUP_INSECURE_SEARCH" then
            local getter = _G.C_QuestLog and _G.C_QuestLog.GetAbandonQuest
            local ok, value = pcall(getter or function () end)
            id = ok and value or nil
        end
        if type(id) ~= "number"
            or type(_G.StaticPopup_FindVisible) ~= "function" then return end
        local dialog_ok, dialog = pcall(_G.StaticPopup_FindVisible, which, data)
        if not dialog or not dialog_ok
            or type(dialog.GetTextFontString) ~= "function" then return end
        local region_ok, region = pcall(dialog.GetTextFontString, dialog)
        if region_ok then quest_name_region(region, id, "quest-static-popup") end
    end)
    prepare_dialog_hook("QuestInfo_ShowTitle", translate_dialog_title)
    prepare_dialog_hook("QuestInfo_ShowDescriptionText", function ()
        quest_info_field(_G.QuestInfoDescriptionText, 2, "GetQuestText", "GetQuestLogQuestText", 1)
    end)
    prepare_dialog_hook("QuestInfo_ShowObjectivesText", function ()
        quest_info_field(_G.QuestInfoObjectivesText, 3, "GetObjectiveText", "GetQuestLogQuestText", 2)
    end)
    prepare_dialog_hook("QuestInfo_ShowRewardText", function ()
        dialog_field(_G.QuestInfoRewardText, dialog_quest_id(), 5, "GetRewardText")
    end)
    prepare_dialog_hook("QuestFrameProgressPanel_OnShow", function ()
        local id = dialog_quest_id()
        dialog_field(_G.QuestProgressTitleText, id, 1, "GetTitleText")
        dialog_field(_G.QuestProgressText, id, 4, "GetProgressText")
    end)
    prepare_dialog_hook("QuestFrameGreetingPanel_OnShow", translate_quest_greeting)
    prepare_dialog_hook("QuestInfo_ShowObjectives", translate_info_objectives)
    -- QuestInfo templates store the original writer functions in their
    -- elements tables. A hook on a writer's global name does not observe calls
    -- through those stored references, so translate after the full display.
    prepare_dialog_hook("QuestInfo_Display", function (template)
        if template == _G.QUEST_TEMPLATE_MAP_DETAILS
            or template == _G.QUEST_TEMPLATE_LOG
            or template == _G.QUEST_TEMPLATE_DETAIL then
            if template == _G.QUEST_TEMPLATE_MAP_DETAILS
                and type(quest_switcher.prepare) == "function" then
                quest_switcher.prepare()
            end
            translate_dialog_title()
            quest_info_field(_G.QuestInfoObjectivesText, 3,
                "GetObjectiveText", "GetQuestLogQuestText", 2)
            quest_info_field(_G.QuestInfoDescriptionText, 2,
                "GetQuestText", "GetQuestLogQuestText", 1)
            translate_info_objectives()
        elseif template == _G.QUEST_TEMPLATE_REWARD then
            translate_dialog_title()
            dialog_field(_G.QuestInfoRewardText,
                dialog_quest_id(), 5, "GetRewardText")
        end
    end)
    prepare_dialog_hook("QuestLogQuests_Update", function ()
        local scroll = _G.QuestScrollFrame
        local pool = scroll and scroll.objectiveFramePool
        if not pool or type(pool.EnumerateActive) ~= "function" then return end
        local counters, changed = {}, quest_log_titles(scroll)
        for frame in pool:EnumerateActive() do
            local id = frame.questID
            if type(id) == "number" and frame.Text then
                counters[id] = (counters[id] or 0) + 1
                local applied = objective_region(frame.Text,
                    "quest:" .. id .. ":log-objective:" .. counters[id],
                    function (region)
                        local height_ok, height = pcall(region.GetStringHeight, region)
                        if height_ok and type(height) == "number" then
                            pcall(frame.SetHeight, frame, height)
                        end
                    end)
                changed = applied or changed
            end
        end
        if changed and scroll.Contents and type(scroll.Contents.Layout) == "function" then
            pcall(scroll.Contents.Layout, scroll.Contents)
        end
    end)
end

local function translate_header(block, id)
    quest_name_region(block.HeaderText, id, "quest-tracker")
end

local function translate_objectives(block, id)
    if type(block.ForEachUsedLine) ~= "function" then return end
    pcall(block.ForEachUsedLine, block, function (line, key)
        local region = line and line.Text
        local source = safe_text(region)
        if not source then return end
        local applied = objective_region(region,
            "quest:" .. id .. ":" .. tostring(key) .. ".description")
        if not applied and options.can_translate("translate_quest") then
            strings.translate_region(region)
        end
    end)
end

local function after_update(self, quest)
    if not self or not quest then return end
    local method_ok, get_id = pcall(function () return quest.GetID end)
    if not method_ok or type(get_id) ~= "function" then return end
    local ok, id = pcall(get_id, quest)
    if type(_G.issecretvalue) == "function" then
        local secret_ok, secret = pcall(_G.issecretvalue, id)
        if not secret_ok or secret then return end
    end
    if not ok or type(id) ~= "number" then return end
    local block_ok, block = pcall(function ()
        local blocks = self.usedBlocks and self.usedBlocks[self.blockTemplate]
        return blocks and blocks[id]
    end)
    if not block_ok or not block then return end
    translate_header(block, id)
    translate_objectives(block, id)
end

quest_ui.prepare = function ()
    prepare_dialog_hooks()
    prepare_extra_tracker_hooks()
    local tracker = _G.QuestObjectiveTracker
    if hooked or not tracker or type(tracker.UpdateSingle) ~= "function"
        or type(_G.hooksecurefunc) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, tracker, "UpdateSingle", after_update)
    if ok then hooked = true end
end
