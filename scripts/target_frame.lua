local _, addon_table = ...

local target_frame = addon_table.use("target_frame")
local aura_overlay = addon_table.use("target_aura_overlay")
local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("target-frame")
local driver

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

-- Build 1.60.1.70170: Camelot uses Mainline TargetFrame.xml and
-- TargetFrameMixin:CheckDead(), which toggles these static FontStrings.
-- Read only these semantic regions; never walk the protected unit frame.
local function health_status_regions()
    if not _G.TargetFrame then return nil end
    local ok, container = pcall(function ()
        local content = _G.TargetFrame.TargetFrameContent
        local main = content and content.TargetFrameContentMain
        return main and main.HealthBarsContainer
    end)
    if ok and not is_secret(container) then return container end
end

local function translate_status(region, slot)
    if not region or is_secret(region) or runtime.is_applying(region) then return end
    local ok, visible = pcall(function () return region:GetText() end)
    if not ok or is_secret(visible) or type(visible) ~= "string" then return end
    local claim = runtime.get(region)
    local source = claim and claim.owner == "target-frame"
        and visible == claim.translated and claim.source or visible
    if not options.can_translate("translate_string") then
        if claim and claim.owner == "target-frame" and visible == claim.translated then
            runtime.show_original(region, true)
        end
        return
    end
    local translated = strings.find_ui_translation(source, region)
    if type(translated) ~= "string" or is_secret(translated) then return end
    runtime.apply(region, { owner = "target-frame", slot = slot,
        surface = _G.TargetFrame, source = source, translated = translated,
        option = "translate_string", priority = runtime.PRIORITY.STATIC_UI })
end

local function update_status()
    local container = health_status_regions()
    if not container then return end
    for _, key in ipairs({ "DeadText", "UnconsciousText" }) do
        local ok, region = pcall(function () return container[key] end)
        if ok then translate_status(region, "target.status." .. key) end
    end
end

target_frame.refresh = function ()
    if options.work_enabled and not options.work_enabled("target-frame") then return end
    update_target_name()
    update_status()
end

target_frame.prepare = function ()
    hooks.region(_G.TargetFrame, "Update", target_frame.refresh)
    hooks.region(_G.TargetFrame, "CheckDead", update_status)
    -- Preserve the independent, addon-owned aura overlay's lifecycle.
    aura_overlay.prepare()
    if not driver then
        driver = CreateFrame("Frame")
        local function update_activity()
            local active = not options.work_enabled or options.work_enabled("target-frame")
            for _, event in ipairs({ "PLAYER_TARGET_CHANGED", "PLAYER_REGEN_ENABLED" }) do
                if active then driver:RegisterEvent(event) else driver:UnregisterEvent(event) end
            end
        end
        if options.on_activity_change then options.on_activity_change("target-frame-events", update_activity) end
        update_activity()
        driver:SetScript("OnEvent", function (_, event)
            if event == "PLAYER_REGEN_ENABLED" then
                scheduler.request("target-frame-post-combat", nil, target_frame.refresh)
            else
                target_frame.refresh()
            end
        end)
    end
    target_frame.refresh()
end
