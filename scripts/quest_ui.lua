local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local quest_ui = addon_table.use("quest_ui")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").quest
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local strings = addon_table.use("strings")
local translation = addon_table.use("translation")
local quest_switcher = addon_table.use("quest_switcher")
local walker = addon_table.use("translation_walker")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("quest")
local layout = addon_table.use("translation_layout")

local tracker_refresh_pending = false
local log_title_cache = setmetatable({}, { __mode = "k" })
local text_height_cache = setmetatable({}, { __mode = "k" })
local log_header_heights = setmetatable({}, { __mode = "k" })
local tracker_text_layouts = setmetatable({}, { __mode = "k" })

local function cached_text_height(region, identity)
    local cached = text_height_cache[region]
    local signature = layout.text_signature and layout.text_signature(region, cached and cached[1].signature)
    if signature and cached then
        -- Keep at most the native and translated measurements. Alternating
        -- native rewrites must not evict the result needed later in this call.
        for index, entry in ipairs(cached) do
            local matches = entry.identity == identity and #signature == #entry.signature
            if matches and signature ~= entry.signature then
                for cursor = 1, #signature do
                    if signature[cursor] ~= entry.signature[cursor] then matches = false; break end
                end
            end
            if matches then
                if index == 2 then cached[1], cached[2] = cached[2], cached[1] end
                return entry.height
            end
        end
    end
    local height = layout.safe_dimension(region, "GetStringHeight")
    if signature and height then
        text_height_cache[region] = { { identity = identity, signature = signature, height = height },
            cached and cached[1] or nil }
    else
        text_height_cache[region] = nil
    end
    return height
end

local function defer_tracker_in_combat()
    if not runtime.combat_locked() then return false end
    tracker_refresh_pending = true
    return true
end


local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function safe_number(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "number" and value or nil
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

local quest_tags = { ["(Elite)"] = true, ["(Dungeon)"] = true,
    ["(Raid)"] = true, ["(PvP)"] = true }

local function translate_title_tag(source, region)
    if not source or not options.can_translate("translate_string") then return source end
    local prefix, tag, reset = source:match("^(.-)(%b())(|r)$")
    if not tag then prefix, tag = source:match("^(.-)(%b())$") end
    if not quest_tags[tag] then return source end
    local translated = strings.find_ui_translation(tag, region)
    return translated and (prefix .. translated .. (reset or "")) or source
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

local function quest_entry(id, field)
    return type(id) == "number" and entries.get_entry("quest", id, field or 1)
end

local function quest_name_region(region, id, owner)
    if options.can_lookup_section and not options.can_lookup_section("quest_names") then return false end
    local current = safe_text(region)
    local claim = region and runtime.get(region)
    local slot = safe_number(id) and "quest:" .. id .. ".name" or nil
    if not slot then
        if region then runtime.invalidate(region) end
        return false
    end
    local retained = claim and claim.owner == owner and claim.slot == slot
        and (current == claim.translated or current == claim.source)
    if retained and current == claim.translated then
        current = claim.source
    end
    if region and not retained then runtime.invalidate(region) end
    if not options.can_lookup("translate_quest") then return false end
    local english = type(id) == "number" and english_title(id)
    local entry = quest_entry(id)
    local ukrainian = entry and safe_string(entry[1])
    if not current or not english or not ukrainian then return false end
    ukrainian = utils.cap(ukrainian)
    local source = replace_once(current, ukrainian, english) or current
    local display_source = source
    if owner == "quest-static-popup" and options.can_lookup("translate_string")
        and (not options.section_enabled or options.section_enabled("popups")) then
        display_source = strings.find_ui_translation(source, region) or source
    end
    local translated = replace_once(display_source, english, ukrainian)
    if owner == "quest-tracker" then
        translated = translate_title_tag(translated, region)
    end
    if not translated then return false end
    return runtime.apply(region, {
        owner = owner, slot = slot,
        source = source, translated = translated, category = "quest",
        option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
        reapply_cached = true,
    }), true
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
    if claim and (claim.owner == "quest-dialog"
        or (claim.owner == "quest-objective"
            and claim.slot:find(":info-objective:", 1, true))) then
        local english = translation.get_quest_language() == "en"
            or (claim.category == "quest" and not options.translate_name("quest"))
        runtime.show_original(region, english)
    end
end

local function quest_map_rewards_label()
    local map = _G.QuestMapFrame
    local details = map and (map.DetailsFrame
        or (map.QuestsFrame and map.QuestsFrame.DetailsFrame))
    local container = details and details.RewardsFrameContainer
    local rewards = container and container.RewardsFrame
    return rewards and rewards.Label
end

quest_ui.refresh_dialog_language = function ()
    for _, name in ipairs({
        "QuestInfoTitleHeader", "QuestInfoDescriptionText",
        "QuestInfoObjectivesText", "QuestInfoRewardText",
        "QuestProgressTitleText", "QuestProgressText",
    }) do
        apply_dialog_language(_G[name])
    end
    local frame = _G.QuestInfoObjectivesFrame
    for _, row in ipairs(frame and frame.Objectives or {}) do
        apply_dialog_language(row)
    end
    for _, region in pairs({ _G.QuestInfoDescriptionHeader,
        _G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.Header,
        quest_map_rewards_label() }) do
        runtime.show_original(region, translation.get_quest_language() == "en")
    end
end

local function dialog_field(region, id, field, getter, result_index)
    if options.can_lookup_section and not options.can_lookup_section(field == 1 and "quest_names" or "quest_text") then return end
    if not region or not id or not options.can_lookup("translate_quest") then return end
    local current = safe_text(region)
    local slot = "quest:" .. id .. (field == 1 and ".name" or ".description:" .. field)
    local claim = runtime.get(region)
    if claim and claim.owner == "quest-dialog" and claim.slot == slot
        and current == claim.translated then
        apply_dialog_language(region)
        return
    end
    local english = getter and original_value(getter, result_index or 1)
    local entry = quest_entry(id, field)
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
    runtime.invalidate(region)
    local applied = runtime.apply(region, {
        owner = "quest-dialog", slot = slot,
        source = source, translated = translated,
        category = field == 1 and "quest" or nil,
        option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN,
    })
    if applied then apply_dialog_language(region) end
end

local function dialog_quest_id(live_dialog)
    if not live_dialog and _G.QuestInfoFrame and _G.QuestInfoFrame.questLog
        and _G.C_QuestLog and type(_G.C_QuestLog.GetSelectedQuest) == "function" then
        local selected_ok, selected = pcall(_G.C_QuestLog.GetSelectedQuest)
        if selected_ok and type(selected) == "number" and selected > 0 then
            return selected
        end
    end
    local ok, id = pcall(translation.get_current_quest_id)
    if ok and type(id) == "number" then return id end
end

local function translate_progress_dialog()
    -- The progress panel is an NPC dialog, even when QuestInfoFrame still
    -- retains the previous quest-log template's flag and selected quest.
    local id = dialog_quest_id(true)
    dialog_field(_G.QuestProgressTitleText, id, 1, "GetTitleText")
    dialog_field(_G.QuestProgressText, id, 4, "GetProgressText")
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
    hooks.global(name, callback)
end

local function prepare_method_hook(owner, name, callback)
    hooks.region(owner, name, callback)
end

local function prepare_extra_tracker_hooks()
    prepare_method_hook(_G.AutoQuestPopupBlockMixin, "Update",
        function (block, _, id)
            if runtime.combat_locked() then return end
            local contents = block and block.Contents
            quest_name_region(contents and contents.QuestName, id, "auto-quest-popup")
        end)
    local banner = _G.ObjectiveTrackerTopBannerFrame or _G.ObjectiveTrackerTopBannerMixin
    prepare_method_hook(banner, "PlayBanner", function (self)
        if runtime.combat_locked() then return end
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
            local generation = runtime.begin_generation(menu)
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
                    walker.walk({ id = "quest-tracker-context-menu",
                        surface = "quest", owner = "quest-ui",
                        reason = "POOLED_MENU_DISCOVERY" }, menu, function (region)
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

local native_objectives = {}

local function native_quest_objective(quest_id)
    if type(quest_id) ~= "number" then return nil end
    if native_objectives[quest_id] then return native_objectives[quest_id] end
    local get_index = _G.C_QuestLog and _G.C_QuestLog.GetLogIndexForQuestID
    local get_text = translation.original and translation.original["GetQuestLogQuestText"]
        or _G.GetQuestLogQuestText
    if type(get_index) ~= "function" or type(get_text) ~= "function" then return nil end
    local index_ok, index = pcall(get_index, quest_id)
    if not index_ok or type(index) ~= "number" or index < 1 then return nil end
    local text_ok, _, objective = pcall(get_text, index)
    if not text_ok then return nil end
    objective = safe_string(objective)
    if objective then native_objectives[quest_id] = objective end
    return objective
end

local function objective_region(region, slot, after_apply, quest_id, surface)
    if options.can_lookup_section and not options.can_lookup_section("quest_text") then return false end
    local source = safe_text(region)
    if not source then return false end
    local previous = runtime.get(region)
    if previous and previous.slot == slot and source == previous.translated then
        apply_dialog_language(region)
        return true
    end
    if after_apply == nil and previous and previous.owner == "quest-objective" and previous.slot == slot
        and previous.surface == surface and source == previous.source
        and options.can_lookup("translate_quest") then
        local applied = runtime.apply(region, {
            owner = previous.owner, slot = slot, source = source,
            translated = previous.translated, option = "translate_quest",
            priority = runtime.PRIORITY.DOMAIN, surface = surface,
            after_apply = after_apply, reapply_cached = true,
        })
        if applied then apply_dialog_language(region) end
        return applied, true
    end
    runtime.invalidate(region)
    if not options.can_lookup("translate_quest") then return false end
    local native = native_quest_objective(quest_id)
    local ok, translated = pcall(entries.translate_quest_objective_task,
        source, quest_id, native)
    if not ok or not safe_string(translated) or translated == source then return false end
    if surface == "quest-tracker" then
        -- Journal paragraphs need blank lines; the narrow tracker does not.
        translated = translated:gsub("\r\n", "\n"):gsub("\r", "\n")
            :gsub("\n[ \t]*\n[ \t\n]*", "\n")
    end
    local applied = runtime.apply(region, {
        owner = "quest-objective", slot = slot, source = source,
        translated = translated, option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN, after_apply = after_apply,
        surface = surface,
    })
    if applied then apply_dialog_language(region) end
    return applied, true
end

local function grow_quest_log_row(button, delta)
    if not button or not delta or math.abs(delta) < 0.5 then return end
    local ok, height = pcall(button.GetHeight, button)
    height = ok and safe_number(height)
    if height and height + delta > 0 then
        return pcall(button.SetHeight, button, height + delta)
    end
end

local function quest_log_titles(scroll, buttons)
    if not options.can_lookup("translate_quest") then return false end
    local pool = scroll and scroll.titleFramePool
    if not pool or type(pool.EnumerateActive) ~= "function" then return false end
    local changed = false
    for button in pool:EnumerateActive() do
        local id = button.questID
        if buttons and safe_number(id) then buttons[id] = button end
        local region = button.Text
        local tag = button.TagText
        if quest_tags[safe_text(tag)] then
            strings.translate_region(tag)
        end
        local current = safe_text(region)
        local info = button.info
        local english = info and safe_string(info.title)
        local entry = quest_entry(id)
        local ukrainian = entry and safe_string(entry[1])
        if current and english and ukrainian then
            local cached = log_title_cache[region]
            local retained = cached and cached.id == id and cached.english == english
                and cached.ukrainian == ukrainian
                and (current == cached.source or current == cached.translated)
            local source, translated
            if retained then
                source, translated = cached.source, cached.translated
            else
                local name = utils.cap(ukrainian)
                source = replace_once(current, name, english) or current
                translated = replace_once(source, english, name)
                log_title_cache[region] = translated and { id = id, english = english,
                    ukrainian = ukrainian, source = source, translated = translated } or nil
            end
            if translated then
                local old_height = cached_text_height(region, id)
                local previous = runtime.get(region)
                local slot = "quest:" .. id .. ".name"
                if not previous or previous.owner ~= "quest-log" or previous.slot ~= slot
                    or current ~= previous.source and current ~= previous.translated then
                    runtime.invalidate(region)
                end
                local applied = runtime.apply(region, {
                    owner = "quest-log", slot = slot,
                    source = source, translated = translated, category = "quest",
                    option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
                    surface = scroll,
                    reapply_cached = true,
                })
                if applied then
                    if options.can_translate("override_system_fonts") then runtime.ensure_font(region) end
                    local new_height = cached_text_height(region, id)
                    if new_height then
                        local frame_ok, frame_height = pcall(region.GetHeight, region)
                        frame_height = frame_ok and safe_number(frame_height)
                        if frame_height and new_height > frame_height + 0.5 then
                            pcall(region.SetHeight, region, new_height)
                        end
                        if old_height and math.abs(new_height - old_height) >= 0.5 then
                            grow_quest_log_row(button, new_height - old_height)
                            changed = true
                        end
                    end
                end
            end
        elseif region then
            runtime.invalidate(region)
        end
    end
    local header_pool = scroll.headerFramePool
    if header_pool and type(header_pool.EnumerateActive) == "function" then
        for button in header_pool:EnumerateActive() do
            local ok, region = pcall(button.GetFontString, button)
            region = ok and region or nil
            local current = safe_text(region)
            local previous = region and runtime.get(region)
            local slot = "quest-header:" .. tostring(button.questLogIndex) .. ".name"
            local retained = previous and previous.owner == "quest-log" and previous.slot == slot
                and (current == previous.source or current == previous.translated)
            local source = retained and current == previous.translated and previous.source or current
            local translated = retained and previous.translated
                or source and entries.get_glossary_text(source, source)
            local class_forms = not retained and source and addon_table.class
                and addon_table.class[source:lower():gsub(" ", "")]
            if translated == source and class_forms and class_forms["н"] then
                translated = utils.cap(class_forms["н"][1])
            end
            if region and not retained then runtime.invalidate(region) end
            if source and safe_string(translated) and translated ~= source then
                local old_height = cached_text_height(region, slot)
                local applied = runtime.apply(region, {
                    owner = "quest-log", slot = slot,
                    source = source, translated = translated,
                    option = "translate_quest", priority = runtime.PRIORITY.CONTEXT,
                    reapply_cached = true,
                })
                if applied then
                    if options.can_translate("override_system_fonts") then runtime.ensure_font(region) end
                    local new_height = cached_text_height(region, slot)
                    local previous_height = log_header_heights[region]
                    if current ~= translated and (not old_height or not new_height
                        or math.abs(new_height - old_height) >= 0.5)
                        or new_height and previous_height and previous_height.slot == slot
                            and math.abs(new_height - previous_height.height) >= 0.5 then changed = true end
                    log_header_heights[region] = new_height and { slot = slot, height = new_height } or nil
                end
            end
        end
    end
    return changed
end

local function valid_greeting_quest_id(value)
    return type(value) == "number" and value > 0 and value or nil
end

local function greeting_data_quest_id(value)
    if type(value) ~= "table" then return nil end
    local ok, id = pcall(function () return value.questID or value.questId end)
    return ok and valid_greeting_quest_id(id) or nil
end

local function greeting_quest_id(button)
    if not button then return nil end
    local ok, id = pcall(function () return button.questID or button.questId end)
    id = ok and valid_greeting_quest_id(id) or nil
    if id then return id end
    for _, field in ipairs({ "info", "data", "questInfo", "elementData" }) do
        local field_ok, value = pcall(function () return button[field] end)
        id = field_ok and greeting_data_quest_id(value) or nil
        if id then return id end
    end
    for _, method_name in ipairs({ "GetElementData", "GetData" }) do
        local method_ok, method = pcall(function () return button[method_name] end)
        if method_ok and type(method) == "function" then
            local data_ok, value = pcall(method, button)
            id = data_ok and greeting_data_quest_id(value) or nil
            if id then return id end
        end
    end
    local method_ok, method = pcall(function () return button.GetID end)
    if not method_ok or type(method) ~= "function" then return nil end
    local index_ok, index = pcall(method, button)
    if not index_ok or not valid_greeting_quest_id(index) then return nil end
    local active_ok, active = pcall(function () return button.isActive end)
    active = active_ok and active or nil
    if (active == 1 or active == true or active == nil)
        and type(_G.GetActiveQuestID) == "function" then
        local found, value = pcall(_G.GetActiveQuestID, index)
        id = found and valid_greeting_quest_id(value) or nil
        if id then return id end
    end
    if (active == 0 or active == false or active == nil)
        and type(_G.GetAvailableQuestInfo) == "function" then
        local found, _, _, _, _, value = pcall(_G.GetAvailableQuestInfo, index)
        id = found and valid_greeting_quest_id(value) or nil
        if id then return id end
    end
end

local function translate_quest_greeting()
    local greeting = _G.GreetingText
    local source = original_value("GetGreetingText") or safe_text(greeting)
    if greeting then runtime.invalidate(greeting) end
    if source and options.can_lookup("translate_gossip") then
        local id_ok, npc_id = pcall(utils.npc_id_from_unit_id, "npc")
        if not id_ok or type(npc_id) ~= "number" then
            id_ok, npc_id = pcall(utils.npc_id_from_unit_id, "questnpc")
        end
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
        if region then runtime.invalidate(region) end
        local id = greeting_quest_id(button)
        if id and name and options.can_lookup("translate_gossip", "translate_quest") then
            local entry = quest_entry(id)
            local translated = entry and safe_string(entry[1])
                or entries.get_glossary_text(name)
            local source_name = english_title(id) or name
            if safe_string(translated) then
                runtime.apply(region, {
                    owner = "quest-greeting", slot = "quest:" .. id .. ".name",
                    source = source_name, translated = translated, category = "quest",
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
    local entry = quest_entry(id)
    local ukrainian = entry and safe_string(entry[1])
    if not current or not english or not ukrainian then return end
    ukrainian = utils.cap(ukrainian)
    local source = replace_once(current, ukrainian, english) or current
    local translated = replace_once(source, english, ukrainian)
    if not translated then return end
    runtime.invalidate(region)
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
            objective_region(row, "quest:" .. id .. ":info-objective:" .. index,
                nil, id)
        end
    end
end

-- The greeting panel may receive its text one frame after OnShow. Expose the
-- same translation pass so the event layer can retry after the native write.
quest_ui.refresh_greeting = translate_quest_greeting

local quest_map_labels = {
    Back = true, Abandon = true, Share = true, Track = true, Untrack = true,
    ["Show Map"] = true,
    Description = true, DESCRIPTION = true, Rewards = true, REWARDS = true,
}

local function is_quest_log_label(text)
    if text == "Search Quest Log" then return true end
    if type(text) ~= "string" then return false end
    local plain = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return plain:match("^Quests:%s*%d+%s*/%s*%d+$") ~= nil
end

local function translate_quest_log_labels()
    local map = _G.QuestMapFrame
    local scroll = map and map.QuestsFrame and map.QuestsFrame.ScrollFrame
        or _G.QuestScrollFrame
    local search = scroll and scroll.SearchBox and scroll.SearchBox.Instructions
    for _, region in pairs({ search, _G.QuestLogQuestCount }) do
        if is_quest_log_label(safe_text(region)) then
            strings.translate_region(region)
        end
    end
end

local function translate_quest_map_labels()
    local map = _G.QuestMapFrame
    local details = map and (map.DetailsFrame
        or (map.QuestsFrame and map.QuestsFrame.DetailsFrame))
    if not details then return end
    local shown_ok, shown = pcall(details.IsShown, details)
    if shown_ok and not shown then return end
    local back = details.BackFrame and details.BackFrame.BackButton
    for _, button in pairs({ back, details.AbandonButton,
        details.ShareButton, details.TrackButton }) do
        local ok, region = pcall(function () return button:GetFontString() end)
        if ok and quest_map_labels[safe_text(region)] then
            strings.translate_region(region)
        end
    end
    for _, region in pairs({ _G.QuestInfoDescriptionHeader,
        _G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.Header,
        quest_map_rewards_label() }) do
        if quest_map_labels[safe_text(region)] then
            strings.translate_region(region)
        end
        runtime.show_original(region, translation.get_quest_language() == "en")
    end
end

local function translate_quest_popup_labels(popup)
    popup = popup or _G.QuestLogPopupDetailFrame
    if not popup then return end
    local show_map = popup.ShowMapButton and popup.ShowMapButton.Text
    if quest_map_labels[safe_text(show_map)] then
        strings.translate_region(show_map)
    end
    for _, button in ipairs({ popup.AbandonButton, popup.ShareButton,
        popup.TrackButton }) do
        local ok, region = pcall(function () return button:GetFontString() end)
        if ok and quest_map_labels[safe_text(region)] then
            strings.translate_region(region)
        end
    end
end

local function translate_tracking_buttons()
    local map = _G.QuestMapFrame
    local details = map and (map.DetailsFrame
        or (map.QuestsFrame and map.QuestsFrame.DetailsFrame))
    local popup = _G.QuestLogPopupDetailFrame
    for _, button in pairs({ details and details.TrackButton,
        popup and popup.TrackButton }) do
        local ok, region = pcall(function () return button:GetFontString() end)
        if ok and quest_map_labels[safe_text(region)] then
            strings.translate_region(region)
        end
    end
    translate_quest_popup_labels(popup)
end

local function prepare_dialog_hooks()
    -- The client writes Track/Untrack after QuestInfo_Display and again when
    -- the watched quest changes. Translate after that final native write.
    prepare_dialog_hook("QuestMapFrame_UpdateQuestDetailsButtons",
        translate_tracking_buttons)
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
    prepare_dialog_hook("QuestFrameProgressPanel_OnShow", translate_progress_dialog)
    hooks.region_script(_G.QuestFrameProgressPanel, "OnShow", translate_progress_dialog)
    -- XML can retain the original OnShow function. Observe the actual region
    -- writes too, including text populated after the initial panel callback.
    for _, region in pairs({ _G.QuestProgressTitleText, _G.QuestProgressText }) do
        local function written(self)
            if not runtime.is_applying(self) then translate_progress_dialog() end
        end
        hooks.region(region, "SetText", written)
        hooks.region(region, "SetFormattedText", written)
    end
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
        translate_quest_map_labels()
    end)
    prepare_dialog_hook("QuestLogQuests_Update", function ()
        -- Blizzard rewrites the quest-list heading during every list refresh.
        -- Reapply its UI translation after that final native write.
        translate_quest_log_labels()
        translate_quest_map_labels()
        local scroll = _G.QuestScrollFrame
        local pool = scroll and scroll.objectiveFramePool
        if not pool or type(pool.EnumerateActive) ~= "function" then return end
        local buttons = {}
        local counters, changed = {}, quest_log_titles(scroll, buttons)
        for frame in pool:EnumerateActive() do
            local id = frame.questID
            if type(id) == "number" and frame.Text then
                counters[id] = (counters[id] or 0) + 1
                objective_region(frame.Text,
                    "quest:" .. id .. ":log-objective:" .. counters[id],
                    nil, id, scroll)
                local old_ok, old_height = pcall(frame.GetHeight, frame)
                old_height = old_ok and safe_number(old_height)
                local new_height = cached_text_height(frame.Text,
                    "quest:" .. id .. ":log-objective:" .. counters[id])
                local resized = false
                if old_height and new_height and new_height > 0
                    and math.abs(new_height - old_height) >= 0.5 then
                    resized = pcall(frame.SetHeight, frame, new_height)
                    if resized then
                        grow_quest_log_row(buttons[id], new_height - old_height)
                    end
                end
                changed = resized or changed
            end
        end
        if changed and scroll.Contents and type(scroll.Contents.Layout) == "function" then
            pcall(scroll.Contents.Layout, scroll.Contents)
        end
    end)
end

local function translate_header(block, id)
    local region = block.HeaderText
    local source = safe_text(region)
    local claim = region and runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local applied, attempted = quest_name_region(region, id, "quest-tracker")
    if applied then return true end
    if attempted then return false end
    -- Tags also need localization when the quest has no translated name.
    local translated = translate_title_tag(source, region)
    if source and translated ~= source then
        return runtime.apply(region, { owner = "quest-tracker-tag", slot = "ui.quest_tag",
            source = source, translated = translated, option = "translate_string",
            priority = runtime.PRIORITY.CONTEXT })
    end
    return true
end

local function fit_tracker_text(region)
    if not region or runtime.combat_locked() or not safe_text(region) then return end
    local cached = tracker_text_layouts[region]
    local signature = layout.text_signature and layout.text_signature(region, cached and cached.signature)
    local current_height = layout.safe_dimension(region, "GetHeight")
    if signature and cached and signature == cached.signature and current_height
        and math.abs(current_height - cached.fitted_height) <= 0.5 then return cached.height end
    local function set_if_changed(getter, setter, expected)
        local ok, writer, present, current = pcall(function ()
            local writer, reader = region[setter], region[getter]
            if runtime.is_secret_value(writer) or runtime.is_secret_value(reader) then return nil end
            if type(reader) == "function" then return writer, true, reader(region) end
            return writer, false
        end)
        if not ok or runtime.is_secret_value(current) then return false end
        if type(writer) ~= "function" then return writer == nil and present ~= nil end
        if present and current == expected then return true end
        if not runtime.can_write_text(region) then return false end
        return pcall(writer, region, expected)
    end
    -- SetStringText measures immediately after SetText. Release stale caps in
    -- that same call, so Blizzard measures the final font and wrapped text.
    if not set_if_changed("GetMaxLines", "SetMaxLines", 0)
        or not set_if_changed("CanWordWrap", "SetWordWrap", true)
        or not set_if_changed("CanNonSpaceWrap", "SetNonSpaceWrap", true) then return end
    if type(region.SetHeight) == "function" then
        if not runtime.can_write_text(region) or not pcall(region.SetHeight, region, 0) then return end
    end
    local height = cached_text_height(region, "tracker")
    local fitted_height = layout.safe_dimension(region, "GetHeight")
    signature = layout.text_signature and layout.text_signature(region, signature)
    tracker_text_layouts[region] = signature and height and fitted_height
        and { signature = signature, height = height, fitted_height = fitted_height } or nil
    return height
end

local function fit_tracker_block(block)
    if not block or not block.used or runtime.combat_locked()
        or type(block.ForEachUsedLine) ~= "function" then return end
    local top = layout.safe_dimension(block, "GetTop")
    local height = layout.safe_dimension(block, "GetHeight")
    if not top or not height then return end
    local required = math.max(height, fit_tracker_text(block.HeaderText) or 0)
    -- Late journal/combat recovery runs after native LayoutBlock. Resize the
    -- rendered frames only; never taint block.height, contentsHeight or dirty
    -- flags consumed later by the secure tracker/container layout.
    pcall(block.ForEachUsedLine, block, function (line)
        local text_height = line and fit_tracker_text(line.Text)
        local old_height = line and layout.safe_dimension(line, "GetHeight")
        if text_height and text_height > 0 and old_height
            and math.abs(text_height - old_height) >= 0.5
            and type(line.SetHeight) == "function" then
            pcall(line.SetHeight, line, text_height)
        end
    end)
    -- Lines are anchored to each other's bottoms, so measure only after all
    -- line heights have been updated, independently of usedLines table order.
    pcall(block.ForEachUsedLine, block, function (line)
        local bottom = line and layout.safe_dimension(line, "GetBottom")
        if bottom then required = math.max(required, top - bottom) end
    end)
    if required > height + 0.5 and type(block.SetHeight) == "function" then
        pcall(block.SetHeight, block, math.ceil(required))
    end
end

local function fit_tracker_blocks(module)
    if module ~= _G.QuestObjectiveTracker or runtime.combat_locked() then return end
    local blocks = module.usedBlocks and module.usedBlocks[module.blockTemplate]
    if type(blocks) ~= "table" then return end
    for _, block in pairs(blocks) do
        if block and block.used then fit_tracker_block(block) end
    end
    local top = layout.safe_dimension(module, "GetTop")
    local height = layout.safe_dimension(module, "GetHeight")
    if not top or not height then return end
    local required = height
    for _, block in pairs(blocks) do
        local bottom = block and block.used and layout.safe_dimension(block, "GetBottom")
        if bottom then
            required = math.max(required, top - bottom + (safe_number(module.bottomSpacing) or 0))
        end
    end
    if required > height + 0.5 and type(module.SetHeight) == "function" then
        pcall(module.SetHeight, module, math.ceil(required))
    end
end

local function prepare_tracker_line(block, key)
    local line = block.usedLines and block.usedLines[key]
    local region = line and line.Text
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if runtime.is_applying(self) or defer_tracker_in_combat() then return end
        -- Lines are pooled, so resolve their current owner on every write.
        local owner = line.parentBlock
        if not owner or owner.parentModule ~= _G.QuestObjectiveTracker then return end
        local id = safe_number(owner.id)
        if not id then return end
        objective_region(self,
            "quest:" .. id .. ":" .. tostring(line.objectiveKey) .. ".description",
            nil, id, "quest-tracker")
        fit_tracker_text(self)
    end)
end

local function prepare_tracker_block(module, id, template)
    if module ~= _G.QuestObjectiveTracker then return end
    id = safe_number(id)
    if not id then return end
    local blocks = module.usedBlocks and module.usedBlocks[template or module.blockTemplate]
    local block = blocks and blocks[id]
    if not block then return end
    hooks.region(block.HeaderText, "SetText", function (region)
        if runtime.is_applying(region) or defer_tracker_in_combat() then return end
        local current_id = safe_number(block.id)
        if block.parentModule ~= _G.QuestObjectiveTracker or not current_id then return end
        translate_header(block, current_id)
        fit_tracker_text(region)
    end)
    -- GetLine finishes before SetStringText writes and measures the text.
    -- Hook the actual pooled frames rather than their copied mixin methods.
    hooks.region(block, "GetLine", prepare_tracker_line)
    if type(block.ForEachUsedLine) == "function" then
        pcall(block.ForEachUsedLine, block, function (_, key)
            prepare_tracker_line(block, key)
        end)
    end
end

-- Native builds measure the translated text through the synchronous hooks;
-- recovery passes reconcile rendered heights without changing layout state.
local function translate_objectives(block, id)
    if type(block.ForEachUsedLine) ~= "function" then return true end
    local ready = true
    local ok = pcall(block.ForEachUsedLine, block, function (line, key)
        local region = line and line.Text
        local source = safe_text(region)
        if not region then return end
        if not source then ready = false; return end
        local applied, attempted = objective_region(region,
            "quest:" .. id .. ":" .. tostring(key) .. ".description",
            nil, id, "quest-tracker")
        if attempted and not applied then ready = false end
        if not applied and options.can_translate("translate_quest") then
            strings.translate_region(region)
        end
    end)
    return ok and ready
end

-- Some client builds refresh the quest log before repainting a tracked line.
-- Reconcile numeric progress from the live journal, then restore translations
-- on every used block. A native tracker rebuild in combat skips after_update,
-- so headers and unchanged objectives can remain English after combat ends.
quest_ui.refresh_tracker_progress = function ()
    if defer_tracker_in_combat() then return false end
    local names_enabled = not options.can_lookup_section
        or options.can_lookup_section("quest_names")
    local text_enabled = not options.can_lookup_section
        or options.can_lookup_section("quest_text")
    if not names_enabled and not text_enabled then tracker_refresh_pending = false; return true end
    local module = _G.QuestObjectiveTracker
    local blocks = module and module.usedBlocks and module.usedBlocks[module.blockTemplate]
    if type(blocks) ~= "table" then tracker_refresh_pending = true; return false end
    local ready = true
    -- Header recovery must also run with quest text disabled or journal
    -- objective APIs unavailable. Resolve IDs from the current pool contents.
    if names_enabled then
        for id, block in pairs(blocks) do
            if safe_number(id) and block and block.HeaderText then
                if safe_text(block.HeaderText) then
                    if not translate_header(block, id) then ready = false end
                else
                    ready = false
                end
            end
        end
    end
    local get_index = _G.C_QuestLog and _G.C_QuestLog.GetLogIndexForQuestID
    local get_objective = _G.GetQuestLogLeaderBoard
    local journal_available = type(get_index) == "function" and type(get_objective) == "function"
    for id, block in pairs(blocks) do
        if text_enabled and safe_number(id) and block
            and type(block.ForEachUsedLine) == "function" then
            local index_ok, index
            if journal_available then index_ok, index = pcall(get_index, id) end
            if index_ok and safe_number(index) and index > 0 then
                pcall(block.ForEachUsedLine, block, function (line, key)
                    if type(key) ~= "number" or not line then return end
                    local region = line.Text
                    local current = safe_text(region)
                    if not current then return end
                    local text_ok, text = pcall(get_objective, key, index, true)
                    local native = text_ok and safe_string(text)
                    local start_at, end_at, old_progress =
                        current:find("(%d+%s*/%s*%d+)")
                    local new_progress = native and native:match("(%d+%s*/%s*%d+)")
                    if old_progress and new_progress
                        and old_progress ~= new_progress then
                        local translated = current:sub(1, start_at - 1)
                            .. new_progress .. current:sub(end_at + 1)
                        runtime.invalidate(region)
                        runtime.apply(region, {
                            owner = "quest-objective",
                            slot = "quest:" .. id .. ":" .. key .. ".description",
                            source = native, translated = translated,
                            option = "translate_quest",
                            priority = runtime.PRIORITY.DOMAIN,
                        })
                    end
                end)
            end
            -- The journal is only needed for numeric progress. Existing
            -- rendered objectives can be translated even while it is loading.
            if not translate_objectives(block, id) then ready = false end
        end
    end
    fit_tracker_blocks(module)
    tracker_refresh_pending = not ready
    return ready
end

quest_ui.schedule_tracker_refresh = function (delay)
    tracker_refresh_pending = true
    scheduler.request({ id = "quest-tracker-progress", work_scope = "quest",
        delay = delay or 0.2, max_retries = 3, retry_delay = 0.1,
        callback = function ()
            if not tracker_refresh_pending then return true end
            return quest_ui.refresh_tracker_progress()
        end })
end

quest_ui.recover_tracker_after_combat = function ()
    -- A coalesced journal timer may still have its old 0.2-second deadline.
    -- Cancel it and recover synchronously on PLAYER_REGEN_ENABLED instead.
    scheduler.cancel("quest-tracker-progress")
    if quest_ui.refresh_tracker_progress() == false then
        quest_ui.schedule_tracker_refresh(0.1)
    end
    -- Exhausting retries leaves pending set. The next combat-end, tracker
    -- show or journal update retries against the current pool, not old rows.
end

local tracker_labels = { ["All Objectives"] = true, ["Quests"] = true }

local function translate_tracker_labels()
    if runtime.combat_locked() then return end
    local tracker = _G.ObjectiveTrackerFrame
    if not tracker or not options.can_translate("translate_string") then return end
    walker.walk({ id = "objective-tracker-static-labels", surface = "quest",
        owner = "quest-ui", reason = "LEGACY_REGION_DISCOVERY" },
        tracker, function (region)
        if tracker_labels[safe_text(region)] then
            strings.translate_region(region)
        end
    end, nil, { frames = 0 })
end

local function schedule_tracker_labels()
    if type(scheduler.request) ~= "function" then
        translate_tracker_labels()
        return
    end
    scheduler.request("quest-tracker-static-labels", nil,
        translate_tracker_labels)
end

local function after_update(self, quest)
    if defer_tracker_in_combat() then return end
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
    fit_tracker_block(block)
    -- UpdateSingle can run once per changed quest in the same native batch.
    -- Static tracker labels are independent of the quest block, so coalesce
    -- their fallback discovery instead of walking the whole tree Q times.
    schedule_tracker_labels()
end

local timer_text_cache = setmetatable({}, { __mode = "k" })

local function translate_quest_timer(frame)
    if not frame or not options.can_translate("translate_string") then return end
    local header = frame.Header and frame.Header.Text
    local header_text = safe_text(header)
    if header_text and header_text:find("[A-Za-z]") then
        strings.translate_region(header)
    end
    for _, button in ipairs(frame.activeElements or {}) do
        local region = button and button.Name
        local source = safe_text(region)
        if source then
            local cached = timer_text_cache[region]
            local translated = cached and cached.source == source
                and cached.translated or nil
            if not translated then
                translated = source
                for _, unit in ipairs(surface_text.timer_units) do
                    translated = translated:gsub(
                        "(%d+)%s+" .. unit.source .. "%f[%A]",
                        "%1 " .. unit.translated)
                end
                timer_text_cache[region] = {
                    source = source, translated = translated,
                }
            end
            if translated ~= source then
                runtime.apply(region, {
                    owner = "quest-timer", slot = "timer.remaining",
                    source = source, translated = translated,
                    option = "translate_string",
                    priority = runtime.PRIORITY.CONTEXT,
                    surface = frame, reapply_cached = true,
                })
            end
        end
    end
end

-- Camelot can populate the quest regions one frame after QuestInfo_Display.
-- Re-run the domain translation after the native writer has finished so the
-- visible text does not remain in English even though the quest entry exists.
quest_ui.refresh_current_dialog = function ()
    if not options.can_lookup("translate_quest") then return end
    translate_dialog_title()
    quest_info_field(_G.QuestInfoDescriptionText, 2,
        "GetQuestText", "GetQuestLogQuestText", 1)
    quest_info_field(_G.QuestInfoObjectivesText, 3,
        "GetObjectiveText", "GetQuestLogQuestText", 2)
    translate_progress_dialog()
    dialog_field(_G.QuestInfoRewardText, dialog_quest_id(), 5, "GetRewardText")
    translate_info_objectives()
end

quest_ui.prepare = function ()
    prepare_dialog_hooks()
    prepare_extra_tracker_hooks()
    local map = _G.QuestMapFrame
    local details = map and (map.DetailsFrame
        or (map.QuestsFrame and map.QuestsFrame.DetailsFrame))
    hooks.region_script(details, "OnShow", translate_quest_map_labels)
    hooks.region_script(_G.ObjectiveTrackerFrame, "OnShow",
        function ()
            translate_tracker_labels()
            if tracker_refresh_pending then quest_ui.schedule_tracker_refresh(0) end
        end, "quest-labels")
    hooks.region(_G.QuestObjectiveTracker, "GetBlock", prepare_tracker_block)
    hooks.region(_G.QuestObjectiveTracker, "UpdateSingle", after_update)
    hooks.region(_G.QuestObjectiveTracker, "UpdateHeight", fit_tracker_blocks)
    -- The XML-created frame copies mixin methods during construction in client
    -- build 70058, so hooking the mixin afterwards does not reach that frame.
    -- Prefer the live frame and keep the mixin as a late-load fallback.
    if not hooks.region(_G.QuestTimerFrame, "UpdateQuestTimers",
        translate_quest_timer) then
        hooks.mixin("QuestTimerMixin", "UpdateQuestTimers", translate_quest_timer)
    end
end
