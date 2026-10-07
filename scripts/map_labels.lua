local _, addon_table = ...

local entries = addon_table.use("entries")
local auto_scan = addon_table.use("auto_scan")
local map_labels = addon_table.use("map_labels")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").map_labels
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local strings = addon_table.use("strings")
local translation = addon_table.use("translation")
local walker = addon_table.use("translation_walker")
local hooks = addon_table.use("translation_hooks").bind("map-labels")

local ironforge_map_tile_ids = { [271410] = true, [8061347] = true }
local ironforge_map_tile = "Interface\\AddOns\\UA_Forever\\assets\\map\\ironforge1.png"
local original_map_tiles = setmetatable({}, { __mode = "k" })
local map_detail_tiles = {}
local map_detail_paths = {}
local function register_map_detail_tiles(map_name, ids)
    for index, id in ipairs(ids) do
        local name = map_name .. index
        local replacement = "Interface\\AddOns\\UA_Forever\\assets\\map\\"
            .. map_name .. "\\" .. name .. ".png"
        map_detail_tiles[id] = replacement
        map_detail_paths["interface/worldmap/" .. map_name .. "/" .. name] = replacement
    end
end
register_map_detail_tiles("ironforge_c60", {
    8062942, 8062946, 8062947, 8062948, 8062949, 8062950,
    8062951, 8062952, 8062953, 8062943, 8062944, 8062945,
})
register_map_detail_tiles("stormwindcity_c60", {
    8038833, 8038837, 8038838, 8038839, 8038840, 8038841,
    8038842, 8038843, 8038844, 8038834, 8038835, 8038836,
})
register_map_detail_tiles("orgrimmar_c60", {
    8093509, 8093513, 8093514, 8093515, 8093516, 8093517,
    8093518, 8093519, 8093520, 8093510, 8093511, 8093512,
})
register_map_detail_tiles("undercity_c60", {
    8067697, 8067701, 8067702, 8067703, 8067704, 8067705,
    8067706, 8067707, 8067708, 8067698, 8067699, 8067700,
})
register_map_detail_tiles("thunderbluff_c60", {
    8096388, 8096392, 8096393, 8096394, 8096395, 8096396,
    8096397, 8096398, 8096399, 8096389, 8096390, 8096391,
})
register_map_detail_tiles("darnassus_c60", {
    8085593, 8085597, 8085598, 8085599, 8085600, 8085601,
    8085602, 8085603, 8085604, 8085594, 8085595, 8085596,
})
register_map_detail_tiles("world_c60", {
    8025428, 8025432, 8025433, 8025434, 8025435, 8025436,
    8025437, 8025438, 8025439, 8025429, 8025430, 8025431,
})
register_map_detail_tiles("kalimdor_c60", {
    8025526, 8025566, 8025567, 8025572, 8025573, 8025574,
    8025575, 8025576, 8025577, 8025527, 8025548, 8025561,
})
register_map_detail_tiles("easternkingdoms_c60", {
    8023297, 8023301, 8023302, 8023303, 8023304, 8023305,
    8023306, 8023307, 8023308, 8023298, 8023299, 8023300,
})
local original_detail_tiles = setmetatable({}, { __mode = "k" })
local wrapped_ui_error_frames = setmetatable({}, { __mode = "k" })
local coordinate_templates = setmetatable({}, { __mode = "k" })
local coordinate_results = setmetatable({}, { __mode = "k" })
local coordinate_zone_results = setmetatable({}, { __mode = "k" })
local coordinate_rules
local translated_map_names = {}
local unpack_values = unpack or table.unpack

local function prepare_coordinate_rules()
    if coordinate_rules then return coordinate_rules end
    coordinate_rules = { cursor = {}, player = {} }
    for _, rule in ipairs(addon_table.forever_ui_patterns or {}) do
        if rule.pattern == "^Cursor: ([%d%.]+), ([%d%.]+)$" then
            coordinate_rules.cursor[#coordinate_rules.cursor + 1] = rule
        elseif rule.pattern == "^Player: ([%d%.]+), ([%d%.]+)$"
            or rule.pattern == "^Player: ([%d%.]+), ([%d%.]+) %((.+)%)$" then
            coordinate_rules.player[#coordinate_rules.player + 1] = rule
        end
    end
    return coordinate_rules
end

local function apply_coordinate_rule(rule, source)
    local captures = { source:match(rule.pattern) }
    if #captures == 0 then return nil end
    return rule.replace(unpack_values(captures))
end

local function texture_path(texture)
    return type(texture) == "string"
        and texture:lower():gsub("\\", "/") or texture
end

local function same_texture(left, right)
    return texture_path(left) == texture_path(right)
end

local function restore_map_textures()
    if options.can_translate("translate_map_images") then return end
    -- Settings can hide the map and release its active pools. Restore all
    -- owned textures, including inactive ones, without touching reused tiles.
    for tile, original in pairs(original_map_tiles) do
        if same_texture(tile:GetTexture(), ironforge_map_tile) then
            tile:SetTexture(original, nil, nil, "TRILINEAR")
        end
        original_map_tiles[tile] = nil
    end
    for tile, original in pairs(original_detail_tiles) do
        if same_texture(tile:GetTexture(), original.replacement) then
            tile:SetTexture(original.texture, nil, nil, "TRILINEAR")
        end
        original_detail_tiles[tile] = nil
    end
end

local function replace_ironforge_map_tile(pin)
    if not pin or not pin.overlayTexturePool then return end
    local enabled = options.can_translate("translate_map_images")
    local probe
    if options.account.auto_scan_content and _G.UA_ForeverDB then
        local ok, map_id = pcall(function () return pin:GetMap():GetMapID() end)
        probe = { mapID = ok and map_id or nil, textures = {}, replaced = 0 }
    end
    for tile in pin.overlayTexturePool:EnumerateActive() do
        local texture = tile:GetTexture()
        if original_map_tiles[tile] and not same_texture(texture, ironforge_map_tile) then
            original_map_tiles[tile] = nil
        end
        if not enabled and original_map_tiles[tile] then
            tile:SetTexture(original_map_tiles[tile], nil, nil, "TRILINEAR")
            original_map_tiles[tile] = nil
            texture = tile:GetTexture()
        end
        if probe and (type(texture) == "number" or type(texture) == "string") then
            probe.textures[#probe.textures + 1] = texture
        end
        local path = type(texture) == "string"
            and texture:lower():gsub("\\", "/"):gsub("%.blp$", "")
        if enabled and (ironforge_map_tile_ids[texture]
            or path == "interface/worldmap/dunmorogh/ironforge1"
            or path == "interface/worldmap/dunmorogh_c60/ironforge1") then
            original_map_tiles[tile] = texture
            tile:SetTexture(ironforge_map_tile, nil, nil, "TRILINEAR")
            if probe then probe.replaced = probe.replaced + 1 end
        end
    end
    if probe then
        _G.UA_ForeverDB.scan = _G.UA_ForeverDB.scan or {}
        _G.UA_ForeverDB.scan.mapTextureProbe = probe
    end
end

local function prepare_ironforge_map_pins(world_map)
    if not world_map or type(world_map.EnumeratePinsByTemplate) ~= "function" then return end
    for pin in world_map:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
        -- Existing pins copy mixin methods when they are created.
        hooks.region(pin, "RefreshOverlays", replace_ironforge_map_tile)
        replace_ironforge_map_tile(pin)
    end
end

local function replace_map_detail_tiles(layer)
    if not layer or not layer.detailTilePool then return end
    local enabled = options.can_translate("translate_map_images")
    for tile in layer.detailTilePool:EnumerateActive() do
        local texture = tile:GetTexture()
        local original = original_detail_tiles[tile]
        -- A pooled texture may already have been reused for another map.
        if original and not same_texture(texture, original.replacement) then
            original_detail_tiles[tile] = nil
            original = nil
        end
        if original and not enabled then
            tile:SetTexture(original.texture, nil, nil, "TRILINEAR")
            original_detail_tiles[tile] = nil
        elseif enabled and not original then
            local path = type(texture) == "string"
                and texture:lower():gsub("\\", "/"):gsub("%.blp$", "")
            local replacement = map_detail_tiles[texture]
                or (path and map_detail_paths[path])
            if replacement then
                original_detail_tiles[tile] = { texture = texture, replacement = replacement }
                tile:SetTexture(replacement, nil, nil, "TRILINEAR")
            end
        end
    end
end

local function prepare_map_detail_layers(world_map)
    if not world_map or not world_map.detailLayerPool then return end
    for layer in world_map.detailLayerPool:EnumerateActive() do
        hooks.region(layer, "RefreshDetailTiles", replace_map_detail_tiles)
        replace_map_detail_tiles(layer)
    end
end

map_labels.refresh = function ()
    restore_map_textures()
    prepare_ironforge_map_pins(_G.WorldMapFrame)
    prepare_map_detail_layers(_G.WorldMapFrame)
end

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

local function zone_poi_translation(label, source)
    local poi_type = _G.MAP_AREA_LABEL_TYPE and _G.MAP_AREA_LABEL_TYPE.POI
    local info = poi_type and label.labelInfoByType
        and label.labelInfoByType[poi_type]
    if not info or safe_string(info.name) ~= source then return nil end
    local active_ok, active = pcall(label.GetHighestPriorityLabelInfo, label)
    if not active_ok or active ~= info then return nil end
    -- Only known zone names belong to this route; use their domain catalog
    -- directly so an object with the same name cannot override a capital.
    local translated = addon_table.zone and safe_string(addon_table.zone[source])
    return translated and translated ~= source and translated or nil
end

local function translated_zone_name(source)
    local name, suffix = source:match("^(.-)(|c%x%x%x%x%x%x%x%x.*)$")
    name = name or source
    suffix = suffix or ""
    local translated = entries.get_glossary_text(name, name, "zone")
    if not safe_string(translated) or translated == name then return nil end
    return translated .. suffix
end

local function translated_zone_discovery_message(message)
    local zone = message:match("^Discovered:? (.+)$")
    if not zone then return nil end
    local translated = translated_zone_name(zone)
    if not translated then return nil end
    return surface_text.discovered(translated)
end

local function after_evaluate(label)
    local region = label and label.Name
    local current = visible_text(region)
    if not current then
        if region then runtime.invalidate(region) end
        return
    end
    local claim = runtime.get(region)
    if claim and (claim.owner == "gossip-map" or claim.owner == "zone-map")
        and current == claim.translated then
        runtime.show_original(region, not runtime.allowed(claim))
        return
    end
    runtime.invalidate(region)
    local gossip_poi = is_gossip_poi(label, current)
    local poi_translation = not gossip_poi and zone_poi_translation(label, current)
    if options.can_lookup("translate_gossip") and gossip_poi then
        local translated = entries.get_glossary_text(current, current)
        if safe_string(translated) and translated ~= current then
            runtime.apply(region, {
                owner = "gossip-map", slot = "gossip.poi",
                source = current, translated = translated,
                option = "translate_gossip", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    elseif options.can_lookup("translate_zone")
        and (is_area_name(label, current) or poi_translation) then
        local translated = poi_translation or translated_zone_name(current)
        if translated then
            runtime.apply(region, {
                owner = "zone-map", slot = "zone.name",
                source = current, translated = translated,
                option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
            })
        end
        auto_scan.record_zone_name(current, visible_text(region), {
            owner = "zone-map", slot = "zone.name", surface = "WorldMapFrame",
        })
    end
end

local function hook_label(label)
    hooks.region(label, "EvaluateLabels", after_evaluate)
end

local function after_minimap_update()
    local region = _G.MinimapZoneText
    if region and runtime.is_applying(region) then return end
    local current = visible_text(region)
    local getter = _G.GetMinimapZoneText
    if not current or type(getter) ~= "function" then return end
    local ok, native = pcall(getter)
    if not ok or safe_string(native) ~= current then return end
    runtime.invalidate(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(current)
    if translated then
        runtime.apply(region, {
            owner = "zone-minimap", slot = "zone.name",
            source = current, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
    end
    auto_scan.record_zone_name(current, visible_text(region), {
        owner = "zone-minimap", slot = "zone.name", surface = "Minimap",
    })
end

local function native_zone_text(getter_name)
    local getter = _G[getter_name]
    if type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter)
    return ok and safe_string(value) or nil
end

local function apply_native_zone_region(region, native, owner)
    if not native or visible_text(region) ~= native then return end
    runtime.invalidate(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(native)
    if translated then
        runtime.apply(region, {
            owner = owner, slot = "zone.name", source = native,
            translated = translated, option = "translate_zone",
            priority = runtime.PRIORITY.CONTEXT,
        })
    end
    auto_scan.record_zone_name(native, visible_text(region), {
        owner = owner, slot = "zone.name", surface = owner,
    })
end

local function after_zone_announcement_write(region, native, owner)
    if not region or runtime.is_applying(region) then return end
    if type(native) == "string" and native == "" then
        runtime.invalidate(region)
        return
    end
    native = safe_string(native)
    if not native or not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(native)
    if not translated then return end
    runtime.apply(region, {
        owner = owner, slot = "zone.name", source = native,
        translated = translated, option = "translate_zone",
        priority = runtime.PRIORITY.CONTEXT,
        record_runtime = false, verify_after_apply = false,
    })
end

local function translated_zone_status(source)
    local faction = source:match("^%((.-) Territory%)$")
        or source:match("^(.-) Territory$")
    if faction then
        local translated_faction = strings.find_ui_translation(faction)
        if safe_string(translated_faction) and translated_faction ~= faction then
            return surface_text.faction_territory(translated_faction)
        end
    end
    local translated = strings.find_ui_translation(source)
    return safe_string(translated) and translated ~= source and translated or nil
end

local function apply_zone_status_region(region, source)
    if not source or visible_text(region) ~= source then return end
    runtime.invalidate(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_status(source)
    if translated then
        runtime.apply(region, {
            owner = "zone-announce-status", slot = "zone.status",
            source = source, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
    end
end

local function apply_zone_status_regions()
    for _, name in ipairs({ "PVPInfoTextString", "PVPArenaTextString" }) do
        local region = _G[name]
        apply_zone_status_region(region, visible_text(region))
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
    apply_zone_status_regions()
end

local syncing_zone_announcement_pair = false
local function after_zone_text_frame_event()
    after_zone_text_event()
    if syncing_zone_announcement_pair then return end
    local zone = native_zone_text("GetZoneText")
    local subzone = native_zone_text("GetSubZoneText")
    if not zone then return end
    local toast_manager = _G.EventToastManagerFrame
    if toast_manager and type(toast_manager.IsCurrentlyToasting) == "function" then
        local ok, toasting = pcall(toast_manager.IsCurrentlyToasting,
            toast_manager)
        if not ok or toasting == true then return end
    end
    if type(_G.FadingFrame_Show) ~= "function" then return end
    syncing_zone_announcement_pair = true
    if not subzone or subzone == zone then
        if _G.SubZoneTextString then
            pcall(_G.SubZoneTextString.SetText, _G.SubZoneTextString, "")
        end
        if _G.SubZoneTextFrame and type(_G.SubZoneTextFrame.Hide) == "function" then
            pcall(_G.SubZoneTextFrame.Hide, _G.SubZoneTextFrame)
        end
        pcall(_G.FadingFrame_Show, _G.ZoneTextFrame)
        syncing_zone_announcement_pair = false
        return
    end
    pcall(_G.FadingFrame_Show, _G.ZoneTextFrame)
    pcall(_G.FadingFrame_Show, _G.SubZoneTextFrame)
    syncing_zone_announcement_pair = false
end

local function after_subzone_load()
    local region = _G.SubZoneTextString
    local shown = visible_text(region)
    local subzone = native_zone_text("GetSubZoneText")
    if shown == subzone then
        apply_native_zone_region(region, subzone, "subzone-announce")
    end
    apply_zone_status_regions()
end

local function ui_message_region(frame, message, message_id)
    if not frame then return nil end
    if type(message_id) == "number"
        and type(frame.GetFontStringByID) == "function" then
        local ok, region = pcall(frame.GetFontStringByID, frame, message_id)
        if ok and visible_text(region) == message then return region end
    end
    if type(frame.GetRegions) ~= "function" then return nil end
    local ok, regions = pcall(function () return { frame:GetRegions() } end)
    if not ok then return nil end
    for index = 1, math.min(#regions, 80) do
        local region = regions[index]
        if visible_text(region) == message then return region end
    end
end

local function translate_quest_progress_message(message)
    if not entries.is_quest_progress_message(message) then return nil end
    local translated = entries.translate_quest_objective_task(message)
    return translated ~= message and translated or nil
end

local function translate_ui_message(self, message, message_id)
    message = safe_string(message)
    if not message then return end
    local region = ui_message_region(self, message, message_id)
    if not region then return end
    if entries.is_quest_progress_message(message) then
        if not options.can_translate("translate_quest") then return end
        local translated = translate_quest_progress_message(message)
        if translated then
            runtime.apply(region, {
                owner = "quest-progress-message", slot = "quest.progress",
                source = message, translated = translated,
                option = "translate_quest", priority = runtime.PRIORITY.DOMAIN,
            })
        end
        return
    end
    if message == "You are no longer rested." then
        if not options.can_lookup("translate_string") then return end
        runtime.apply(region, {
            owner = "ui-message", slot = "rested", source = message,
            translated = addon_table.forever_ui[message],
            option = "translate_string", priority = runtime.PRIORITY.CONTEXT,
        })
        return
    end
    local translated, _, source_kind, category, slot, option =
        strings.find_ui_translation(message, region)
    if translated and translated ~= message then
        option = option or "translate_string"
        if not options.can_lookup(option) or not options.can_translate(option) then return end
        runtime.apply(region, {
            owner = "ui-message", slot = slot or "ui.message",
            source = message, translated = translated, category = category,
            option = option, priority = runtime.priority_for_source(source_kind),
        })
        return
    end
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_discovery_message(message)
    if not translated then return end
    runtime.apply(region, {
        owner = "zone-discovery", slot = "zone.name", source = message,
        translated = translated,
        option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
    })
end

local function after_ui_message(self, event, message_id, message)
    if event == "UI_INFO_MESSAGE" or event == "UI_ERROR_MESSAGE" then
        translate_ui_message(self, message, message_id)
    end
end

local function after_ui_add_message(self, message, _, _, _, _, message_id)
    translate_ui_message(self, message, message_id)
end

local function wrap_ui_error_add_message(frame)
    if not frame or wrapped_ui_error_frames[frame]
        or type(frame.AddMessage) ~= "function" then return end
    local original_add_message = frame.AddMessage
    local ok = pcall(function ()
        frame.AddMessage = function (self, message, ...)
            local source = safe_string(message)
            if source and entries.is_quest_progress_message(source) then
                if options.can_translate("translate_quest") then
                    message = translate_quest_progress_message(source) or source
                end
                if type(auto_scan.record_ui) == "function" then
                    auto_scan.record_ui(source, message ~= source, "UIErrorsFrame")
                end
                return original_add_message(self, message, ...)
            end
            if source and options.can_translate("translate_zone") then
                local translated = translated_zone_discovery_message(source)
                if translated then message = translated end
            end
            if source and message == source and options.can_translate("translate_string") then
                local translated = strings.find_ui_translation(source)
                if type(translated) == "string" and translated ~= source then
                    message = translated
                end
            end
            if source and type(auto_scan.record_ui) == "function" then
                auto_scan.record_ui(source, message ~= source, "UIErrorsFrame")
            end
            return original_add_message(self, message, ...)
        end
    end)
    if ok then wrapped_ui_error_frames[frame] = true end
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
    runtime.invalidate(region)
    runtime.apply(region, {
        owner = owner, slot = "zone.name", source = native,
        translated = translated, option = "translate_zone",
        priority = runtime.PRIORITY.CONTEXT,
    })
end

local function after_widget_zone(self)
    -- Changing an Objective Tracker FontString can synchronously dirty the
    -- whole container. In combat that makes build 70058 re-enter the Scenario
    -- module from addon code, where its Maw aura query is forbidden as tainted.
    if runtime.combat_locked() then return end
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
    walker.walk({ id = "queue-status-zone-menu", surface = "map",
        owner = "map-labels", reason = "POOLED_MENU_DISCOVERY" },
        menu, function (region)
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
    local generation = runtime.begin_generation(menu)
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
    runtime.invalidate(region)
    if not options.can_lookup("translate_zone") then return end
    local translated = translated_zone_name(source)
    if translated then
        runtime.apply(region, {
            owner = "zone-label", slot = "zone.name",
            source = source, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
    end
    auto_scan.record_zone_name(source, visible_text(region), {
        owner = "zone-label", slot = "zone.name", surface = "AdventureMap",
    })
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
                runtime.invalidate(region)
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

local function coordinate_label(container)
    if not container then return nil end
    local ok, visible = pcall(function ()
        if container.IsVisible then return container:IsVisible() end
        if container.IsShown then return container:IsShown() end
        return true
    end)
    if not ok or visible == false then return nil end
    return container.Label
end

local function translate_coordinate(region, slot)
    local source = visible_text(region)
    if not source then return false end
    local cached = coordinate_results[region]
    if cached and cached.slot == slot and cached.source == source then
        return cached.spec and runtime.apply(region, cached.spec) or false
    end
    if cached and cached.slot == slot and cached.spec
        and source == cached.spec.translated then
        return runtime.apply(region, cached.spec)
    end
    local kind = slot == "coords.cursor" and "cursor" or "player"
    local rule = coordinate_templates[region]
    local translated = rule and apply_coordinate_rule(rule, source)
    if not translated then
        for _, candidate in ipairs(prepare_coordinate_rules()[kind]) do
            translated = apply_coordinate_rule(candidate, source)
            if translated then
                coordinate_templates[region] = candidate
                break
            end
        end
    end
    local spec
    if translated and translated ~= source then
        spec = {
            owner = "worldmap-coords", slot = slot,
            source = source, translated = translated,
            option = "translate_string", lookup_tier = "pattern",
            surface = "worldmap-coords", priority = runtime.PRIORITY.CONTEXT,
            record_runtime = false, verify_after_apply = false,
            reapply_cached = true,
        }
    end
    coordinate_results[region] = { source = source, slot = slot, spec = spec }
    return spec and runtime.apply(region, spec) or false
end

local function after_worldmap_coords_update(self)
    if not self then return end
    local ui_enabled = options.can_translate("translate_string")
        and (not options.section_enabled or options.section_enabled("map_ui"))
    local zone_enabled = options.can_translate("translate_zone")
    if not ui_enabled and not zone_enabled then return end
    auto_scan.surface_hook("worldmap-coords", "WorldMapCoordsPanel.OnUpdate",
        true, true)
    auto_scan.surface_attempt("worldmap-coords", "after_worldmap_coords_update")

    -- Blizzard rewrites visible labels every frame, even at unchanged rounded
    -- coordinates. Reapply the cached claim without formatting/font setup.
    local region = coordinate_label(self.PlayerCoords)
    if ui_enabled then
        translate_coordinate(coordinate_label(self.CursorCoords), "coords.cursor")
        if translate_coordinate(region, "coords.player") then return end
    end
    if not zone_enabled or not region then return end

    -- The full UI pattern normally translates the player coordinates and
    -- zone in one write. Keep this domain-only fallback for custom settings
    -- where generic UI translation is disabled but zone translation remains
    -- enabled, or for a client format not covered by the UI pattern.
    local map_api = _G.C_Map
    local get_info = map_api and map_api.GetMapInfo
    if not map_api or type(map_api.GetBestMapForUnit) ~= "function"
        or type(get_info) ~= "function"
        then return end
    local current = visible_text(region)
    if not current then return end
    local cached_result = coordinate_zone_results[region]
    if cached_result and cached_result.slot == "zone.name"
        and (cached_result.source == current or cached_result.spec
            and cached_result.spec.translated == current) then
        if cached_result.spec then runtime.apply(region, cached_result.spec) end
        return
    end
    -- Negative results also avoid repeating map API calls at unchanged text.
    local result = { source = current, slot = "zone.name" }
    local id_ok, map_id = pcall(map_api.GetBestMapForUnit, "player")
    if not id_ok or type(map_id) ~= "number" then return end
    local info_ok, info = pcall(get_info, map_id)
    local native = info_ok and info and safe_string(info.name)
    if not native then return end
    coordinate_zone_results[region] = result
    local cached = translated_map_names[map_id]
    local translated
    if cached and cached.source == native then
        translated = cached.translated
    else
        translated = native and translated_zone_name(native)
        if native and translated then
            translated_map_names[map_id] = {
                source = native, translated = translated,
            }
        end
    end
    if not translated then return end
    local start_at, end_at = current:find(native, 1, true)
    if not start_at then return end
    local translated_line = current:sub(1, start_at - 1) .. translated
        .. current:sub(end_at + 1)
    result.spec = {
        owner = "zone-worldmap-coords", slot = "zone.name",
        source = current, translated = translated_line,
        option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        record_runtime = false, verify_after_apply = false,
        reapply_cached = true,
    }
    runtime.apply(region, result.spec)
end

local function find_worldmap_coords_panel(root)
    local seen, inspected = {}, 0
    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 12 or inspected >= 250 then return nil end
        seen[frame] = true
        inspected = inspected + 1
        local fields_ok, cursor, player = pcall(function ()
            return frame.CursorCoords, frame.PlayerCoords
        end)
        if fields_ok and cursor and player then return frame end
        local method_ok, get_children = pcall(function () return frame.GetChildren end)
        if not method_ok or type(get_children) ~= "function" then return nil end
        local children_ok, children = pcall(function () return { frame:GetChildren() } end)
        if not children_ok then return nil end
        for _, child in ipairs(children) do
            local found = visit(child, depth + 1)
            if found then return found end
        end
    end
    return visit(root, 1)
end

local function hook_worldmap_coords_panel()
    local panel = find_worldmap_coords_panel(_G.WorldMapFrame)
    if not panel then return false end
    local installed = hooks.region_script(panel, "OnUpdate",
        after_worldmap_coords_update, "worldmap-coords-instance")
    auto_scan.surface_hook("worldmap-coords", "WorldMapCoordsPanel.OnUpdate",
        installed, false)
    if installed then after_worldmap_coords_update(panel) end
    return installed
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
    walker.walk({ id = "world-map-navigation-menu", surface = "map",
        owner = "map-labels", reason = "POOLED_MENU_DISCOVERY" },
        menu, function (region)
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

map_labels.refresh_active = function ()
    restore_map_textures()
    prepare_ironforge_map_pins(_G.WorldMapFrame)
    prepare_map_detail_layers(_G.WorldMapFrame)
    after_minimap_update()
    after_zone_text_event()
    hook_worldmap_coords_panel()
end

map_labels.prepare = function ()
    hooks.region(_G.MapExplorationPinMixin, "RefreshOverlays",
        replace_ironforge_map_tile)
    local world_map = _G.WorldMapFrame
    hooks.region(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles",
        replace_map_detail_tiles)
    hooks.region(world_map, "RefreshDetailLayers", prepare_map_detail_layers)
    hooks.region_script(world_map, "OnShow", prepare_map_detail_layers,
        "map-detail-art")
    hooks.region_script(world_map, "OnShow", prepare_ironforge_map_pins,
        "map-art")
    hooks.region_script(world_map, "OnShow", function ()
        auto_scan.surface_event("worldmap-coords", "WorldMapFrame.OnShow")
        scheduler.request("worldmap-coords-instance", nil,
            hook_worldmap_coords_panel)
    end, "worldmap-coords-instance")
    prepare_ironforge_map_pins(world_map)
    prepare_map_detail_layers(world_map)
    hook_worldmap_coords_panel()
    hooks.global("Minimap_Update", after_minimap_update)
    hooks.region(_G.MinimapZoneText, "SetText", after_minimap_update)
    after_minimap_update()
    hooks.region(_G.ZoneTextString, "SetText", function (region, native)
        after_zone_announcement_write(region, native, "zone-announce")
    end)
    hooks.region(_G.SubZoneTextString, "SetText", function (region, native)
        after_zone_announcement_write(region, native, "subzone-announce")
    end)
    hooks.global("ZoneText_OnEvent", after_zone_text_event)
    hooks.global("SubZoneText_OnLoad", after_subzone_load)
    -- ZoneTextFrame's XML script keeps its own function reference. Hook the
    -- frame event as well so each newly written area name is translated.
    hooks.region_script(_G.ZoneTextFrame, "OnEvent", after_zone_text_frame_event,
        "zone-announcement")
    hooks.region_script(_G.ZoneTextFrame, "OnShow", after_zone_text_event,
        "zone-announcement")
    hooks.region_script(_G.SubZoneTextFrame, "OnShow", after_zone_text_event,
        "subzone-announcement")
    wrap_ui_error_add_message(_G.UIErrorsFrame)
    hooks.region_script(_G.UIErrorsFrame, "OnEvent", after_ui_message,
        "ui-message")
    hooks.region(_G.UIErrorsFrame, "AddMessage", after_ui_add_message)
    hooks.region(_G.UIErrorsFrame, "AddExternalErrorMessage", function (_, message)
        if type(auto_scan.record_ui) == "function" then
            auto_scan.record_ui(message, false, "UIErrorsFrame")
        end
    end)
    local widget = _G.UIWidgetObjectiveTrackerMixin
    for _, method in ipairs({ "OnEvent", "LayoutContents" }) do
        hooks.region(widget, method, after_widget_zone)
    end
    hooks.global("QueueStatusEntry_SetUpActiveWorldPVP", after_queue_zone)
    hooks.region(_G.QueueStatusButtonMixin, "ShowContextMenu", after_queue_menu)
    hooks.region(_G.AreaLabelDataProviderMixin, "OnAdded", function (self)
        hook_label(self and self.Label)
    end)
    hooks.region(_G.ZoneLabelDataProviderMixin, "EvaluateBestAreaTrigger",
        after_zone_label_evaluation)
    hooks.region(_G.AdventureMap_ZoneSummaryProviderMixin, "RefreshAllData",
        after_adventure_zone_refresh)
    local menu_api = _G.Menu
    if menu_api and type(menu_api.ModifyMenu) == "function" then
        hooks.once("MENU_MINIMAP_BATTLEFIELD", function ()
            return pcall(menu_api.ModifyMenu, "MENU_MINIMAP_BATTLEFIELD",
                after_worldmap_menu)
        end)
    end
    -- XML mixes Refresh into the already-created nav frame. The mixin hook
    -- only covers instances created after this point.
    local world_map = _G.WorldMapFrame
    hooks.region(world_map and world_map.NavBar, "Refresh",
        after_worldmap_nav_refresh)
    hooks.region(_G.WorldMapNavBarMixin, "Refresh", after_worldmap_nav_refresh)
    hooks.region(_G.WorldMapCoordsPanelMixin, "OnUpdate", after_worldmap_coords_update)
    hooks.global("QuestLogQuests_Update", after_story_header_update)
    hooks.region(_G.StoryHeaderMixin, "ShowTooltip", after_story_tooltip)
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
