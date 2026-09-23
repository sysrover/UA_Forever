local _, addon_table = ...

local entries = addon_table.use("entries")
local map_labels = addon_table.use("map_labels")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local translation = addon_table.use("translation")
local walker = addon_table.use("translation_walker")

local provider_hooked
local minimap_hooked
local zone_event_hooked
local subzone_load_hooked
local scenario_hooked
local widget_zone_hooked = {}
local queue_zone_hooked
local queue_menu_hooked
local zone_label_hooked
local adventure_zone_hooked
local worldmap_menu_hooked
local worldmap_nav_hooked
local story_header_hooked
local story_tooltip_hooked
local worldmap_coords_hooked
local hooked_labels = setmetatable({}, { __mode = "k" })

local function safe_string(value)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return type(value) == "string" and value ~= "" and value or nil
end

local function visible_text(region)
    if not region then return nil end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return nil end
    local ok, value = pcall(get_text, region)
    return ok and safe_string(value) or nil
end

local function is_gossip_poi(label, source)
    local poi_type = _G.MAP_AREA_LABEL_TYPE and _G.MAP_AREA_LABEL_TYPE.POI
    local info = poi_type and label.labelInfoByType
        and label.labelInfoByType[poi_type]
    if not info or info.name ~= source then return false end
    local gossip = _G.C_GossipInfo
    if not gossip or type(gossip.GetPoiForUiMapID) ~= "function"
        or type(gossip.GetPoiInfo) ~= "function" then return false end
    local map_ok, map_id = pcall(function ()
        return label.dataProvider:GetMap():GetMapID()
    end)
    if not map_ok or type(map_id) ~= "number" then return false end
    local id_ok, poi_id = pcall(gossip.GetPoiForUiMapID, map_id)
    if not id_ok or type(poi_id) ~= "number" then return false end
    local info_ok, poi_info = pcall(gossip.GetPoiInfo, map_id, poi_id)
    return info_ok and poi_info and safe_string(poi_info.name) == source
end

local function is_area_name(label, source)
    local area_type = _G.MAP_AREA_LABEL_TYPE and _G.MAP_AREA_LABEL_TYPE.AREA_NAME
    local info = area_type and label.labelInfoByType
        and label.labelInfoByType[area_type]
    if not info or info.name ~= source then return false end
    local active_ok, active = pcall(label.GetHighestPriorityLabelInfo, label)
    return active_ok and active == info
end

local function translated_zone_name(source)
    local name, suffix = source:match("^(.-)(|c%x%x%x%x%x%x%x%x.*)$")
    name = name or source
    suffix = suffix or ""
    local translated = entries.get_glossary_text(name, name, "zone")
    if not safe_string(translated) or translated == name then return nil end
    return translated .. suffix
end

local function after_evaluate(label)
    local region = label and label.Name
    local current = visible_text(region)
    if not current then
        if region then runtime.clear(region) end
        return
    end
    local claim = runtime.get(region)
    if claim and (claim.owner == "gossip-map" or claim.owner == "zone-map")
        and current == claim.translated then
        return
    end
    runtime.clear(region)
    if options.can_lookup("translate_gossip") and is_gossip_poi(label, current) then
        local translated = entries.get_glossary_text(current, current)
        if safe_string(translated) and translated ~= current then
            runtime.apply(region, {
                owner = "gossip-map", slot = "gossip.poi",
                source = current, translated = translated,
                option = "translate_gossip", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    elseif options.can_lookup("translate_zone") and is_area_name(label, current) then
        local translated = translated_zone_name(current)
        if translated then
            runtime.apply(region, {
                owner = "zone-map", slot = "zone.name",
                source = current, translated = translated,
                option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    end
end

local function hook_label(label)
    if not label or hooked_labels[label]
        or type(label.EvaluateLabels) ~= "function" then return end
    local ok = pcall(_G.hooksecurefunc, label, "EvaluateLabels", after_evaluate)
    if ok then hooked_labels[label] = true end
end

local function after_minimap_update()
    local region = _G.MinimapZoneText
    local current = visible_text(region)
    local getter = _G.GetMinimapZoneText
    if not current or type(getter) ~= "function" then return end
    local ok, native = pcall(getter)
    if not ok or safe_string(native) ~= current then return end
    runtime.clear(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(current)
    if translated then
        runtime.apply(region, {
            owner = "zone-minimap", slot = "zone.name",
            source = current, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
    end
end

local function native_zone_text(getter_name)
    local getter = _G[getter_name]
    if type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter)
    return ok and safe_string(value) or nil
end

local function apply_native_zone_region(region, native, owner)
    if not native or visible_text(region) ~= native then return end
    runtime.clear(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(native)
    if translated then
        runtime.apply(region, {
            owner = owner, slot = "zone.name", source = native,
            translated = translated, option = "translate_zone",
            priority = runtime.PRIORITY.CONTEXT,
        })
    end
end

local function after_zone_text_event()
    local zone = native_zone_text("GetZoneText")
    local subzone = native_zone_text("GetSubZoneText")
    apply_native_zone_region(_G.ZoneTextString, zone, "zone-announce")
    local shown = visible_text(_G.SubZoneTextString)
    if shown and (shown == subzone or shown == zone) then
        apply_native_zone_region(_G.SubZoneTextString, shown, "subzone-announce")
    end
end

local function after_subzone_load()
    apply_native_zone_region(_G.SubZoneTextString,
        native_zone_text("GetSubZoneText"), "subzone-announce")
end

local function after_scenario_layout(self)
    local region = self and self.Header and self.Header.Text
    local zone = native_zone_text("GetZoneText")
    if not zone or visible_text(region) ~= zone then return end
    if type(_G.ShouldShowMawBuffs) ~= "function"
        or type(_G.IsInJailersTower) ~= "function" then return end
    local context_ok, show_maw, in_tower = pcall(function ()
        return ShouldShowMawBuffs(), IsInJailersTower()
    end)
    if not context_ok or not show_maw or in_tower then return end
    local scenario = _G.C_Scenario
    if not scenario or type(scenario.GetInfo) ~= "function" then return end
    local info_ok, scenario_type = pcall(function ()
        return select(10, scenario.GetInfo())
    end)
    if not info_ok or type(scenario_type) ~= "number"
        or scenario_type == _G.LE_SCENARIO_TYPE_CHALLENGE_MODE
        or scenario_type == _G.LE_SCENARIO_TYPE_PROVING_GROUNDS
        or scenario_type == _G.LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY then return end
    local block = self.ProvingGroundsBlock
    if block and type(block.IsActive) == "function" then
        local block_ok, active = pcall(block.IsActive, block)
        if not block_ok or active then return end
    end
    apply_native_zone_region(region, zone, "zone-scenario")
end

local function after_real_zone_writer(region, owner)
    local getter = translation.original and translation.original.GetRealZoneText
        or _G.GetRealZoneText
    if type(getter) ~= "function" then return end
    local ok, native = pcall(getter)
    native = ok and safe_string(native) or nil
    if not native or not region then return end
    local current = visible_text(region)
    local translated = translated_zone_name(native)
    if not current or not translated
        or (current ~= native and current ~= translated) then return end
    runtime.clear(region)
    runtime.apply(region, {
        owner = owner, slot = "zone.name", source = native,
        translated = translated, option = "translate_zone",
        priority = runtime.PRIORITY.CONTEXT,
    })
end

local function after_widget_zone(self)
    after_real_zone_writer(self and self.Header and self.Header.Text,
        "zone-widget-tracker")
end

local function after_queue_zone(entry)
    after_real_zone_writer(entry and entry.Title, "zone-queue")
end

local function active_menu()
    local menu_api = _G.Menu
    if not menu_api or type(menu_api.GetManager) ~= "function" then return nil end
    local ok, menu = pcall(function ()
        return menu_api.GetManager():GetOpenMenu()
    end)
    return ok and menu or nil
end

local function translate_queue_menu(menu)
    local getter = _G.GetRealZoneText
    if not menu or type(getter) ~= "function"
        or not options.can_lookup("translate_zone") then return end
    local ok, native = pcall(getter)
    native = ok and safe_string(native) or nil
    if not native then return end
    local translated = translated_zone_name(native)
    if not translated then return end
    local title_source = "|cff19ff19" .. native .. "|r"
    local title_translation = "|cff19ff19" .. translated .. "|r"
    local button_source, button_translation
    if type(_G.LEAVE_ZONE) == "string" then
        local source_ok, value = pcall(string.format, _G.LEAVE_ZONE, native)
        if source_ok then button_source = value end
        local translation_ok, translated_value = pcall(string.format,
            _G.LEAVE_ZONE, translated)
        if translation_ok then button_translation = translated_value end
    end
    walker.walk(menu, function (region)
        local current = visible_text(region)
        local previous = region and runtime.get(region)
        local source = current
        if previous and (previous.source == title_source
            or previous.source == button_source) then
            source = previous.source
        end
        local replacement = source == title_source and title_translation
            or button_source and source == button_source and button_translation
        if replacement and replacement ~= source then
            runtime.apply(region, {
                owner = "zone-queue-menu", slot = "zone.name",
                source = source, translated = replacement,
                option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    end, nil, { frames = 0 })
end

local function after_queue_menu()
    local menu = active_menu()
    if not menu then return end
    translate_queue_menu(menu)
    local generation = runtime.next_generation(menu)
    scheduler.request("zone-queue-menu:" .. tostring(menu), generation,
        function ()
            if active_menu() == menu then translate_queue_menu(menu) end
        end, nil, menu)
end

local function after_zone_label_evaluation(self)
    local source = self and self.bestAreaTrigger
        and safe_string(self.bestAreaTrigger.name)
    local region = self and self.ZoneLabel and self.ZoneLabel.Text
    if not source or visible_text(region) ~= source then return end
    runtime.clear(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(source)
    if translated then
        runtime.apply(region, {
            owner = "zone-label", slot = "zone.name",
            source = source, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
    end
end

local function after_adventure_zone_refresh(self)
    if not self or type(self.GetMap) ~= "function"
        or not options.can_lookup("translate_zone") then return end
    pcall(function ()
        local map = self:GetMap()
        for pin in map:EnumeratePinsByTemplate("AdventureMap_ZoneSummaryPinTemplate") do
            local source = pin and safe_string(pin.title)
            local region = pin and pin.Text
            if source and visible_text(region) == source then
                runtime.clear(region)
                local translated = translated_zone_name(source)
                if translated then
                    runtime.apply(region, {
                        owner = "zone-adventure-pin", slot = "zone.name",
                        source = source, translated = translated,
                        option = "translate_zone",
                        priority = runtime.PRIORITY.CONTEXT,
                    })
                end
            end
        end
    end)
end

local function layout_worldmap_nav_button(region)
    local parent_ok, button = pcall(region.GetParent, region)
    if not parent_ok or not button then return end
    local nav_ok, nav = pcall(button.GetParent, button)
    if not nav_ok or not nav or type(button.SetWidth) ~= "function"
        or type(region.GetStringWidth) ~= "function" then return end
    if type(_G.InCombatLockdown) == "function" then
        local ok, combat = pcall(_G.InCombatLockdown)
        if not ok or combat then return end
    end
    local width_ok, width = pcall(region.GetStringWidth, region)
    if not width_ok or type(width) ~= "number" then return end
    local extra = button.listFunc and not nav.oldStyle and 53 or 30
    local set_ok = pcall(button.SetWidth, button, width + extra)
    if set_ok and type(_G.NavBar_CheckLength) == "function" then
        pcall(_G.NavBar_CheckLength, nav)
    end
end

local function after_worldmap_nav_refresh(self)
    if not self or not options.can_lookup("translate_zone") then return end
    if type(_G.InCombatLockdown) == "function" then
        local ok, combat = pcall(_G.InCombatLockdown)
        if not ok or combat then return end
    end
    local map_api = _G.C_Map
    local get_info = map_api and map_api.GetMapInfo
    if type(get_info) ~= "function" then return end
    for _, button in ipairs(self.navList or {}) do
        local id = button and button.data and button.data.id
        local region = button and button.text
        if type(id) == "number" and region then
            local ok, info = pcall(get_info, id)
            local source = ok and info and safe_string(info.name)
            local translated = source and translated_zone_name(source)
            local current = visible_text(region)
            if translated and (current == source or current == translated) then
                runtime.apply(region, {
                    owner = "zone-worldmap-nav", slot = "zone.name",
                    source = source, translated = translated,
                    option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
                    after_visibility = layout_worldmap_nav_button,
                })
            end
        end
    end
end

local function after_worldmap_coords_update(self)
    local map_api = _G.C_Map
    local get_info = map_api and map_api.GetMapInfo
    if not self or not map_api or type(map_api.GetBestMapForUnit) ~= "function"
        or type(get_info) ~= "function"
        or not options.can_lookup("translate_zone") then return end
    local region = self.PlayerCoords and self.PlayerCoords.Label
    local current = visible_text(region)
    if not current then return end
    local id_ok, map_id = pcall(map_api.GetBestMapForUnit, "player")
    if not id_ok or type(map_id) ~= "number" then return end
    local info_ok, info = pcall(get_info, map_id)
    local native = info_ok and info and safe_string(info.name)
    local translated = native and translated_zone_name(native)
    if not translated then return end
    local source = current
    local translated_at, translated_end = source:find(translated, 1, true)
    if translated_at then
        source = source:sub(1, translated_at - 1) .. native
            .. source:sub(translated_end + 1)
    end
    local start_at, end_at = source:find(native, 1, true)
    if not start_at then return end
    local translated_line = source:sub(1, start_at - 1) .. translated
        .. source:sub(end_at + 1)
    runtime.apply(region, {
        owner = "zone-worldmap-coords", slot = "zone.name",
        source = source, translated = translated_line,
        option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
    })
end

local function story_map_name()
    local quest_api = _G.C_QuestLog
    local map_api = _G.C_Map
    local quest_map = _G.QuestMapFrame
    if not quest_api or type(quest_api.GetZoneStoryInfo) ~= "function"
        or not quest_map or not map_api then return nil end
    local get_info = map_api.GetMapInfo
    if type(get_info) ~= "function" then return nil end
    local map_ok, map_id = pcall(function ()
        return quest_map:GetParent():GetMapID()
    end)
    if not map_ok or type(map_id) ~= "number" then return nil end
    local story_ok, achievement_id, story_map_id = pcall(
        quest_api.GetZoneStoryInfo, map_id)
    if not story_ok or type(achievement_id) ~= "number"
        or type(story_map_id) ~= "number" then return nil end
    local info_ok, info = pcall(get_info, story_map_id)
    return info_ok and info and safe_string(info.name) or nil
end

local function claim_story_map(region, owner, after_visibility)
    local source = story_map_name()
    local translated = source and translated_zone_name(source)
    local current = visible_text(region)
    if not translated or (current ~= source and current ~= translated) then return end
    runtime.apply(region, {
        owner = owner, slot = "zone.name",
        source = source, translated = translated,
        option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        after_visibility = after_visibility,
    })
end

local function layout_story_tooltip_title(region)
    local parent_ok, tooltip = pcall(region.GetParent, region)
    if not parent_ok or not tooltip or type(tooltip.SetWidth) ~= "function" then return end
    if type(_G.InCombatLockdown) == "function" then
        local ok, combat = pcall(_G.InCombatLockdown)
        if not ok or combat then return end
    end
    local width = 0
    local function include(part)
        if not part or type(part.GetWidth) ~= "function" then return end
        local ok, value = pcall(part.GetWidth, part)
        if ok and type(value) == "number" then width = math.max(width, value) end
    end
    include(region)
    include(tooltip.ProgressLabel)
    include(tooltip.ProgressCount)
    for _, line in ipairs(tooltip.Lines or {}) do
        local shown_ok, shown = pcall(line.IsShown, line)
        if shown_ok and shown then include(line) end
    end
    pcall(tooltip.SetWidth, tooltip, math.max(240, width + 20))
end

local function after_story_header_update()
    local scroll = _G.QuestScrollFrame
    local header = scroll and scroll.Contents and scroll.Contents.StoryHeader
    if header then claim_story_map(header.Text, "zone-story-header") end
end

local function after_story_tooltip()
    local getter = _G.QuestMapLog_GetStoryTooltip
    if type(getter) ~= "function" then return end
    local ok, tooltip = pcall(getter)
    if ok and tooltip then
        claim_story_map(tooltip.Title, "zone-story-tooltip",
            layout_story_tooltip_title)
    end
end

local function worldmap_nav_button(owner)
    local mixin = _G.WorldMapNavBarButtonMixin
    if not mixin or type(mixin.GetDropdownList) ~= "function" then return nil end
    local function is_nav(button)
        return button and button.listFunc == mixin.GetDropdownList
            and button.data and type(button.data.id) == "number"
    end
    if is_nav(owner) then return owner end
    local ok, parent = pcall(function () return owner:GetParent() end)
    return ok and is_nav(parent) and parent or nil
end

local function translate_worldmap_dropdown(menu, nav)
    if not menu or not nav or not options.can_lookup("translate_zone") then return end
    local map_api = _G.C_Map
    if not map_api then return end
    local get_info = map_api.GetMapInfo
    local get_children = map_api.GetMapChildrenInfo
    if type(get_info) ~= "function" or type(get_children) ~= "function" then return end
    local info_ok, map_info = pcall(get_info, nav.data.id)
    local parent_id = info_ok and map_info and map_info.parentMapID
    if type(parent_id) ~= "number" then return end
    local children_ok, children = pcall(get_children, parent_id)
    if not children_ok or type(children) ~= "table" then return end
    local names = {}
    for _, child in ipairs(children) do
        local source = child and safe_string(child.name)
        if source then
            local translated = translated_zone_name(source)
            if translated then names[source] = translated end
        end
    end
    walker.walk(menu, function (region)
        local current = visible_text(region)
        local previous = region and runtime.get(region)
        local source = previous and names[previous.source]
            and previous.source or current
        local translated = source and names[source]
        if translated then
            runtime.apply(region, {
                owner = "zone-worldmap-dropdown", slot = "zone.name",
                source = source, translated = translated,
                option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    end, nil, { frames = 0 })
end

local function after_worldmap_menu(owner)
    local nav = worldmap_nav_button(owner)
    if not nav then return end
    scheduler.request("zone-worldmap-menu:" .. tostring(owner), nil, function ()
        local menu = active_menu()
        if not menu or type(menu.GetOwnerRegion) ~= "function" then return end
        local owner_ok, active_owner = pcall(menu.GetOwnerRegion, menu)
        if owner_ok and active_owner == owner then
            translate_worldmap_dropdown(menu, nav)
        end
    end)
end

map_labels.prepare = function ()
    if type(_G.hooksecurefunc) ~= "function" then return end
    if not minimap_hooked and type(_G.Minimap_Update) == "function" then
        local ok = pcall(_G.hooksecurefunc, "Minimap_Update", after_minimap_update)
        if ok then minimap_hooked = true end
    end
    if not zone_event_hooked and type(_G.ZoneText_OnEvent) == "function" then
        local ok = pcall(_G.hooksecurefunc, "ZoneText_OnEvent", after_zone_text_event)
        if ok then zone_event_hooked = true end
    end
    if not subzone_load_hooked and type(_G.SubZoneText_OnLoad) == "function" then
        local ok = pcall(_G.hooksecurefunc, "SubZoneText_OnLoad", after_subzone_load)
        if ok then subzone_load_hooked = true end
    end
    local scenario = _G.ScenarioObjectiveTrackerMixin
    if not scenario_hooked and scenario
        and type(scenario.LayoutContents) == "function" then
        local ok = pcall(_G.hooksecurefunc, scenario, "LayoutContents",
            after_scenario_layout)
        if ok then scenario_hooked = true end
    end
    local widget = _G.UIWidgetObjectiveTrackerMixin
    if widget then
        for _, method in ipairs({ "OnEvent", "LayoutContents" }) do
            if not widget_zone_hooked[method]
                and type(widget[method]) == "function" then
                local ok = pcall(_G.hooksecurefunc, widget, method,
                    after_widget_zone)
                if ok then widget_zone_hooked[method] = true end
            end
        end
    end
    if not queue_zone_hooked
        and type(_G.QueueStatusEntry_SetUpActiveWorldPVP) == "function" then
        local ok = pcall(_G.hooksecurefunc,
            "QueueStatusEntry_SetUpActiveWorldPVP", after_queue_zone)
        if ok then queue_zone_hooked = true end
    end
    local queue_button = _G.QueueStatusButtonMixin
    if not queue_menu_hooked and queue_button
        and type(queue_button.ShowContextMenu) == "function" then
        local ok = pcall(_G.hooksecurefunc, queue_button,
            "ShowContextMenu", after_queue_menu)
        if ok then queue_menu_hooked = true end
    end
    local provider = _G.AreaLabelDataProviderMixin
    if not provider_hooked and provider and type(provider.OnAdded) == "function" then
        local ok = pcall(_G.hooksecurefunc, provider, "OnAdded", function (self)
            hook_label(self and self.Label)
        end)
        if ok then provider_hooked = true end
    end
    local zone_label = _G.ZoneLabelDataProviderMixin
    if not zone_label_hooked and zone_label
        and type(zone_label.EvaluateBestAreaTrigger) == "function" then
        local ok = pcall(_G.hooksecurefunc, zone_label,
            "EvaluateBestAreaTrigger", after_zone_label_evaluation)
        if ok then zone_label_hooked = true end
    end
    local adventure = _G.AdventureMap_ZoneSummaryProviderMixin
    if not adventure_zone_hooked and adventure
        and type(adventure.RefreshAllData) == "function" then
        local ok = pcall(_G.hooksecurefunc, adventure,
            "RefreshAllData", after_adventure_zone_refresh)
        if ok then adventure_zone_hooked = true end
    end
    local menu_api = _G.Menu
    if not worldmap_menu_hooked and menu_api
        and type(menu_api.ModifyMenu) == "function" then
        local ok = pcall(menu_api.ModifyMenu, "MENU_MINIMAP_BATTLEFIELD",
            after_worldmap_menu)
        if ok then worldmap_menu_hooked = true end
    end
    local nav = _G.WorldMapNavBarMixin
    if not worldmap_nav_hooked and nav and type(nav.Refresh) == "function" then
        local ok = pcall(_G.hooksecurefunc, nav, "Refresh",
            after_worldmap_nav_refresh)
        if ok then worldmap_nav_hooked = true end
    end
    local coords = _G.WorldMapCoordsPanelMixin
    if not worldmap_coords_hooked and coords
        and type(coords.OnUpdate) == "function" then
        local ok = pcall(_G.hooksecurefunc, coords, "OnUpdate",
            after_worldmap_coords_update)
        if ok then worldmap_coords_hooked = true end
    end
    if not story_header_hooked
        and type(_G.QuestLogQuests_Update) == "function" then
        local ok = pcall(_G.hooksecurefunc, "QuestLogQuests_Update",
            after_story_header_update)
        if ok then story_header_hooked = true end
    end
    local story = _G.StoryHeaderMixin
    if not story_tooltip_hooked and story
        and type(story.ShowTooltip) == "function" then
        local ok = pcall(_G.hooksecurefunc, story, "ShowTooltip",
            after_story_tooltip)
        if ok then story_tooltip_hooked = true end
    end
    for _, name in ipairs({ "WorldMapFrame", "FlightMapFrame" }) do
        local map = _G[name]
        local providers = map and map.dataProviders
        if type(providers) == "table" then
            for active in pairs(providers) do
                hook_label(active and active.Label)
            end
        end
    end
end
