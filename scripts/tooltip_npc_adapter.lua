local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local adapter = addon_table.use("tooltip_npc_adapter")
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip NPC dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip NPC adapter is not configured")
end

adapter.add = function (tooltip, id)
    local contract = deps()
    if not options.can_lookup("translate_npc", "translate_npc_tooltip") then
        return false
    end
    local entry = entries.get_entry("npc", id)
    local name
    if tooltip.GetUnit then
        local ok, value = pcall(tooltip.GetUnit, tooltip)
        if ok then name = value end
    end
    dev_log.record_id("npcs", id, name, entry ~= nil)
    if not entry then
        dev_log.missing_npc(id, name or tostring(id))
        return false
    end
    if not options.can_translate("translate_npc", "translate_npc_tooltip") then
        return false
    end
    tooltip.uaForeverReservedFirst = entry[2] and 3 or 2
    local native_title, title_region = contract.tooltip_line(
        tooltip, "Left", 1)
    local applied = false
    if title_region then
        applied = contract.set_translation(tooltip, title_region,
            native_title, utils.cap(entry[1]), "npc.name", nil,
            "npc-tooltip") or applied
    end
    if entry[2] then
        local native_subtitle, subtitle_region = contract.tooltip_line(
            tooltip, "Left", 2)
        if subtitle_region then
            applied = contract.set_translation(tooltip, subtitle_region,
                native_subtitle, utils.cap(entry[2]), "npc.subtitle", nil,
                "npc-tooltip") or applied
        end
    end
    return contract.rewrite_generic(
        tooltip, nil, tooltip.uaForeverReservedFirst) > 0 or applied
end

adapter.refresh_name = function (tooltip)
    local contract = deps()
    if tooltip.uaForeverShowOriginal
        or not options.can_translate("translate_npc", "translate_npc_tooltip") then
        return false
    end
    local source, region = contract.tooltip_line(tooltip, "Left", 1)
    source = contract.safe_string(source)
    if not region or not source then return false end
    local id = tooltip.uaForeverKind == "npc" and tooltip.uaForeverID or nil
    if not id and (not tooltip.uaForeverKind
        or tooltip.uaForeverKind == "generic")
        and type(tooltip.GetUnit) == "function" then
        local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
        unit = ok and contract.safe_string(unit) or nil
        if unit then id = utils.npc_id_from_unit_id(unit) end
    end
    if not id then return false end
    local entry = entries.get_entry("npc", id)
    if not entry or type(entry[1]) ~= "string" then return false end
    local translated = utils.cap(entry[1])
    if source == translated then return false end
    local claim = runtime.get(region)
    if (type(entry.en) ~= "string" or source:lower() ~= entry.en:lower())
        and not (claim and claim.owner == "npc-tooltip"
        and source == claim.source) then return false end
    if tooltip.uaForeverKind ~= "npc" then
        contract.begin_tooltip(tooltip, "npc:" .. tostring(id))
        tooltip.uaForeverKind = "npc"
        tooltip.uaForeverID = id
        tooltip.uaForeverReservedFirst = entry[2] and 3 or 2
    end
    if tooltip.uaForeverShowOriginal then return false end
    return contract.set_translation(tooltip, region, source, translated,
        "npc.name", nil, "npc-tooltip", nil, false)
end

adapter.refresh_subtitle = function (tooltip)
    local contract = deps()
    if tooltip.uaForeverKind ~= "npc" or not tooltip.uaForeverID
        or tooltip.uaForeverShowOriginal then return false end
    local entry = entries.get_entry("npc", tooltip.uaForeverID)
    if not entry or type(entry[2]) ~= "string" then return false end
    local source, region = contract.tooltip_line(tooltip, "Left", 2)
    local claim = region and runtime.get(region)
    source = contract.safe_string(source)
    if not source or not claim or claim.owner ~= "npc-tooltip"
        or claim.slot ~= "npc.subtitle" or source ~= claim.source then
        return false
    end
    return contract.set_translation(tooltip, region, source,
        utils.cap(entry[2]), "npc.subtitle", nil, "npc-tooltip", nil,
        false, false)
end
