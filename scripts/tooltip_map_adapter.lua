local _, addon_table = ...

local entries = addon_table.use("entries")
local item_client_db = addon_table.use("item_client_db")
local layout = addon_table.use("translation_layout")
local map_labels = addon_table.use("map_labels")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")
local adapter = addon_table.use("tooltip_map_adapter")
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip map dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip map adapter is not configured")
end

local function set_native_zone_line(tooltip, index, native, slot)
    local contract = deps()
    native = contract.safe_string(native)
    if not native then return end
    local current, region = contract.tooltip_line(tooltip, "Left", index)
    current = contract.safe_string(current)
    if not region or current ~= native then return end
    local previous = runtime.get(region)
    if previous and previous.owner == "zone-tooltip"
        and previous.source ~= current then
        runtime.invalidate(region)
    end
    if not options.can_lookup("translate_zone") then return end
    local translated = entries.get_glossary_text(current, current, "zone")
    if type(translated) == "string" and translated ~= current then
        contract.set_translation(tooltip, region, current, translated,
            slot, nil, "zone-tooltip")
    end
end

adapter.is_minimap_frame = function (frame)
    local minimap, cluster = _G.Minimap, _G.MinimapCluster
    if runtime.is_secret_value(minimap) then minimap = nil end
    if runtime.is_secret_value(cluster) then cluster = nil end
    for _ = 1, 8 do
        if runtime.is_secret_value(frame) or not frame
            or frame == _G.UIParent or frame == _G.WorldFrame then return false end
        if frame == minimap or frame == cluster then return true end
        local ok, parent = pcall(function () return frame:GetParent() end)
        if not ok or runtime.is_secret_value(parent) or parent == frame then return false end
        frame = parent
    end
    return false
end

local function minimap_buttons()
    local cluster = _G.MinimapCluster
    if runtime.is_secret_value(cluster) or not cluster then return end
    local ok, zone, tracking = pcall(function ()
        local tracking_frame = cluster.Tracking
        return cluster.ZoneTextButton, not runtime.is_secret_value(tracking_frame)
            and tracking_frame and tracking_frame.Button or nil
    end)
    if not ok then return end
    if runtime.is_secret_value(zone) then zone = nil end
    if runtime.is_secret_value(tracking) then tracking = nil end
    return zone, tracking
end

local function is_visible_owner(tooltip, button)
    if runtime.is_secret_value(tooltip) or not tooltip or not button then return false end
    local ok, owner, shown = pcall(function () return tooltip:GetOwner(), tooltip:IsShown() end)
    return ok and not runtime.is_secret_value(owner) and not runtime.is_secret_value(shown)
        and owner == button and shown == true
end

adapter.current_minimap_button = function (tooltip)
    if not tooltip or tooltip ~= _G.GameTooltip then return end
    local zone, tracking = minimap_buttons()
    local button = tracking
    if tooltip.uaForeverSessionKey == "minimap-zone-button" then
        button = zone
    elseif tooltip.uaForeverSessionKey ~= "minimap-tracking-button" then
        return
    end
    if is_visible_owner(tooltip, button) then return button end
end

local function get_native_zone(getter)
    if type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter)
    return ok and deps().safe_string(value) or nil
end

local function translate_world_map_shortcut(source, region)
    local title = deps().safe_string(_G.WORLDMAP_BUTTON)
    if not title or source:sub(1, #title) ~= title then return nil end
    local translated = strings.find_ui_translation(title, region)
    if translated then return translated .. source:sub(#title + 1) end
end

adapter.translate_minimap_button_lines = function (tooltip, button)
    if tooltip.uaForeverShowOriginal then return end
    local contract = deps()
    local is_zone = tooltip.uaForeverSessionKey == "minimap-zone-button"
    local ok, count = pcall(function () return tooltip:NumLines() end)
    if not ok or contract.is_secret(count) or type(count) ~= "number" then return end
    local zone, subzone, shortcut
    if is_zone then
        zone = get_native_zone(_G.GetZoneText)
        subzone = get_native_zone(_G.GetSubZoneText)
        local shortcut_ok, value = pcall(function () return button.tooltipText end)
        shortcut = shortcut_ok and contract.safe_string(value) or nil
    end
    local bilingual = options.is_bilingual_tooltip()
    for index = 1, math.min(count, is_zone and 4 or 2) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        source = contract.safe_string(source)
        if source and region and not runtime.is_stable_claim(region, tooltip, tooltip.uaForeverGeneration) then
            local translated, owner
            if not is_zone then
                translated = strings.find_ui_translation(source, region)
            elseif source == shortcut then
                translated = translate_world_map_shortcut(source, region)
            else
                owner = "zone-tooltip"
                if source == zone or source == subzone then
                    translated = entries.get_glossary_text(source, source, "zone")
                elseif index == 2 or index == 3 then
                    translated = map_labels.translate_zone_status(source)
                end
            end
            if translated then
                contract.set_translation(tooltip, region, source, translated,
                    (owner and "zone.minimap:" or "minimap.button:") .. index,
                    nil, owner or "generic", nil, bilingual, false)
            end
        end
    end
end

local function finish_minimap_button(button, key)
    local tooltip = _G.GameTooltip
    if not is_visible_owner(tooltip, button) or not options.can_translate() then return end
    deps().begin_tooltip(tooltip, key, true)
    tooltip.uaForeverKind = "minimap-button"
    adapter.translate_minimap_button_lines(tooltip, button)
    layout.fit_current_tooltip(tooltip)
end

local function finish_minimap_zone_button(button)
    finish_minimap_button(button, "minimap-zone-button")
end

adapter.prepare_minimap_buttons = function (hooks)
    local zone, tracking = minimap_buttons()
    -- The zone button shows intermediate rows before appending the map shortcut.
    hooks.region_script(zone, "OnEnter", finish_minimap_zone_button, "minimap-zone-button")
    hooks.region_script(tracking, "OnEnter", function (button)
        finish_minimap_button(button, "minimap-tracking-button")
    end, "minimap-tracking-button")
    hooks.global("Minimap_Update", function ()
        local zone_button = minimap_buttons()
        finish_minimap_zone_button(zone_button)
    end)
end

adapter.translate_taxi_node = function (button)
    local contract = deps()
    local tooltip, getter = _G.GameTooltip, _G.TaxiNodeName
    if not tooltip or not button or type(getter) ~= "function"
        or type(button.GetID) ~= "function"
        or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    local id_ok, index = pcall(button.GetID, button)
    if not owner_ok or owner ~= button or not id_ok
        or contract.is_secret(index) then return end
    local name_ok, native = pcall(getter, index)
    native = name_ok and contract.safe_string(native) or nil
    if not native then return end
    local current, region = contract.tooltip_line(tooltip, "Left", 1)
    current = contract.safe_string(current)
    if not region or current ~= native then return end
    if not tooltip.uaForeverSessionKey then
        contract.begin_tooltip(tooltip, "generic")
    end
    local previous = runtime.get(region)
    if previous and previous.owner == "zone-tooltip"
        and previous.source ~= native then
        runtime.invalidate(region)
    end
    tooltip.uaForeverReservedFirst = 2
    if not options.can_lookup("translate_zone") then return end
    local translated = entries.translate_taxi_node_name(native)
    if type(translated) == "string" and translated ~= native then
        contract.set_translation(tooltip, region, native, translated,
            "zone.name", nil, "zone-tooltip")
    end
end

adapter.translate_bag_portrait = function (button)
    local contract = deps()
    local tooltip = _G.GameTooltip
    if not tooltip or not button or type(button.GetParent) ~= "function"
        or type(tooltip.GetOwner) ~= "function"
        or not options.can_lookup("translate_item") then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= button then return end
    local parent_ok, parent = pcall(button.GetParent, button)
    if not parent_ok or not parent or type(parent.GetBagID) ~= "function" then
        return
    end
    local bag_ok, bag_id = pcall(parent.GetBagID, parent)
    local container = _G.C_Container
    if not bag_ok or contract.is_secret(bag_id) or not container
        or type(container.ContainerIDToInventoryID) ~= "function"
        or type(_G.GetInventoryItemLink) ~= "function" then return end
    local slot_ok, slot = pcall(container.ContainerIDToInventoryID, bag_id)
    if not slot_ok or contract.is_secret(slot) then return end
    local link_ok, link = pcall(_G.GetInventoryItemLink, "player", slot)
    link = link_ok and contract.safe_string(link) or nil
    if not link then return end
    local id = utils.item_id_from_link(link)
    local translated = id and item_client_db.get_name(id)
    if not translated then return end
    local item_api = _G.C_Item
    if not item_api or type(item_api.GetItemInfo) ~= "function" then return end
    local name_ok, native = pcall(item_api.GetItemInfo, link)
    native = name_ok and contract.safe_string(native) or nil
    if not native then return end
    local current, region = contract.tooltip_line(tooltip, "Left", 1)
    current = contract.safe_string(current)
    if not region or not current or current:sub(1, #native) ~= native then
        return
    end
    translated = utils.cap(translated)
    if translated == native then return end
    if not tooltip.uaForeverSessionKey then
        contract.begin_tooltip(tooltip, "generic")
    end
    tooltip.uaForeverReservedFirst = 2
    contract.set_translation(tooltip, region, current,
        translated .. current:sub(#native + 1),
        "item.name", "item", "item-tooltip")
end

adapter.translate_guild_news = function (button)
    local contract = deps()
    local news = button and button.newsInfo
    local data = news and news.data
    if not data or news.newsType ~= _G.NEWS_DUNGEON_ENCOUNTER
        or not options.can_lookup("translate_zone") then return end
    local getter = translation.original and translation.original.GetRealZoneText
        or _G.GetRealZoneText
    if type(getter) ~= "function" then return end
    local ok, native = pcall(getter, data[1])
    native = ok and contract.safe_string(native) or nil
    if not native then return end
    local translated = entries.get_glossary_text(native, native, "zone")
    if type(translated) ~= "string" or translated == native then return end
    if not contract.is_secret(data[2]) and type(data[2]) == "number"
        and data[2] > 0 then
        local frame_ok, frame = pcall(function ()
            return button:GetParent():GetParent():GetParent()
        end)
        local model = frame_ok and frame and frame.BossModel
        local region = model and model.TextFrame
            and model.TextFrame.BossLocationText
        if not region or type(region.GetText) ~= "function" then return end
        local text_ok, current = pcall(region.GetText, region)
        current = text_ok and contract.safe_string(current) or nil
        if not current or (current ~= native and current ~= translated) then
            return
        end
        runtime.invalidate(region)
        runtime.apply(region, {
            owner = "zone-guild-news", slot = "zone.name",
            source = native, translated = translated,
            option = "translate_zone", priority = runtime.PRIORITY.CONTEXT,
        })
        return
    end
    local tooltip = _G.GameTooltip
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= button then return end
    local current, region = contract.tooltip_line(tooltip, "Left", 2)
    current = contract.safe_string(current)
    if not region or not current
        or (current ~= native and current ~= translated) then return end
    if not tooltip.uaForeverSessionKey then
        contract.begin_tooltip(tooltip, "generic")
    end
    contract.set_translation(tooltip, region, native, translated,
        "zone.name", nil, "zone-tooltip")
end

adapter.translate_adventure_pin = function (pin)
    local contract = deps()
    local tooltip = _G.GameTooltip
    local native = contract.safe_string(pin and pin.title)
    if not tooltip or not native
        or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= pin then return end
    if not tooltip.uaForeverSessionKey then
        contract.begin_tooltip(tooltip, "generic")
    end
    set_native_zone_line(tooltip, 1, native, "zone.name")
end

adapter.translate_flight_map = function (self)
    local contract = deps()
    local tooltip = _G.GameTooltip
    if not tooltip or not self or type(self.GetMap) ~= "function" then return end
    local map_ok, map = pcall(self.GetMap, self)
    if not map or not map_ok or type(tooltip.GetOwner) ~= "function" then
        return
    end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= map then return end
    local id_ok, map_id = pcall(map.GetMapID, map)
    local pos_ok, x, y = pcall(map.GetNormalizedCursorPosition, map)
    if not id_ok or not pos_ok or contract.is_secret(map_id)
        or contract.is_secret(x) or contract.is_secret(y)
        or type(map_id) ~= "number" then return end
    local api = _G.C_Map
    if not api or type(api.GetMapInfoAtPosition) ~= "function" then return end
    local info_ok, info = pcall(api.GetMapInfoAtPosition, map_id, x, y)
    if not info_ok or not info or contract.is_secret(info) then return end
    local name_ok, sub_map_id, native_name = pcall(function ()
        return info.mapID, info.name
    end)
    native_name = name_ok and contract.safe_string(native_name) or nil
    if not name_ok or contract.is_secret(sub_map_id)
        or sub_map_id == map_id or not native_name then return end
    local current, region = contract.tooltip_line(tooltip, "Left", 1)
    current = contract.safe_string(current)
    if not region or current ~= native_name then return end
    if not tooltip.uaForeverSessionKey then
        contract.begin_tooltip(tooltip, "generic")
    end
    tooltip.uaForeverReservedFirst = 2
    set_native_zone_line(tooltip, 1, native_name, "zone.name")
end
