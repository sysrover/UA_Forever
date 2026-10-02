local _, addon_table = ...

local adapter = addon_table.use("loss_of_control_adapter")
local strings = addon_table.use("strings")
local options = addon_table.use("options")
local auto_scan = addon_table.use("auto_scan")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("loss-of-control")

local states = setmetatable({}, { __mode = "k" })
local safe_string = runtime.safe_string_or_nil

local function field(owner, key)
    if owner == nil or runtime.is_secret_value(owner) then return nil end
    local ok, value = pcall(function () return owner[key] end)
    if ok and not runtime.is_secret_value(value) then return value end
end

local function call(owner, method)
    local callback = field(owner, method)
    if type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, owner)
    if ok and not runtime.is_secret_value(value) then return value end
end

local function translate(source, region)
    local translated = strings.find_ui_translation(source, region)
    if translated then return translated end
    -- Build 70170 formats school lockouts before writing AbilityName. Resolve
    -- the client template and its school independently, without changing API
    -- data or assuming that the rendered string is a spell name.
    local template = safe_string(_G.LOSS_OF_CONTROL_DISPLAY_INTERRUPT_SCHOOL)
    if not template then return nil end
    local prefix, suffix = template:match("^(.-)%%s(.-)$")
    if not prefix or #source <= #prefix + #suffix
        or source:sub(1, #prefix) ~= prefix
        or (#suffix > 0 and source:sub(-#suffix) ~= suffix) then return nil end
    local school = source:sub(#prefix + 1, #source - #suffix)
    local translated_template = strings.find_ui_translation(template, region)
    if not translated_template then return nil end
    local translated_school = strings.find_ui_translation(school, region) or school
    local ok, result = pcall(string.format, translated_template, translated_school)
    if ok then return safe_string(result) end
end

local function update_seconds_width(state)
    if state.slot ~= "control.seconds" then return end
    local time_left = field(state.frame, "TimeLeft")
    local width = call(state.region, "GetStringWidth")
    if time_left and type(width) == "number" then
        -- SetUpDisplay uses this cached width to align the icon and timer.
        pcall(function () time_left.secondsWidth = width end)
    end
end

local function refresh(state)
    local region = state.region
    if state.writing or runtime.is_applying(region) then return end
    if call(state.frame, "IsForbidden") == true then return end
    local visible = safe_string(call(region, "GetText"))
    if not visible then
        runtime.release(region, "loss-of-control")
        return
    end
    local source = visible == state.translated and state.source or visible
    local enabled = options.can_translate("translate_string")
    if not enabled then
        if visible == state.translated and state.source then
            local allowed = runtime.can_write_text(region, true)
            if not allowed then return end
            state.writing = true
            local ok = pcall(region.SetText, region, state.source)
            state.writing = false
            if not ok then return end
            update_seconds_width(state)
        end
        runtime.release(region, "loss-of-control")
        return
    end
    if visible == state.translated and runtime.get(region) then
        -- Fonts can only be prepared outside combat. The native frame scales
        -- these same FontStrings, so keep its animation and numeric timer.
        if not state.font_ready and not runtime.combat_locked() then
            state.font_ready = runtime.ensure_font(region)
            update_seconds_width(state)
        end
        return
    end
    local translated = safe_string(translate(source, region))
    if options.account and options.account.auto_scan_content
        and state.scanned_source ~= source and type(auto_scan.record_ui) == "function" then
        auto_scan.record_ui(source, translated ~= nil and translated ~= source,
            "LossOfControlFrame." .. state.slot, "loss-of-control", "loss-of-control")
        state.scanned_source = source
    end
    if not translated or translated == source then
        runtime.release(region, "loss-of-control")
        return
    end
    runtime.release(region, "loss-of-control")
    state.source, state.translated = source, translated
    state.writing = true
    pcall(runtime.apply, region, {
        owner = "loss-of-control", slot = state.slot,
        source = source, translated = translated, option = "translate_string",
        priority = runtime.PRIORITY.CONTEXT,
        combat_text_only = runtime.combat_locked(), defer_if_protected = false,
    })
    state.writing = false
    update_seconds_width(state)
end

local function register_region(frame, region, slot)
    if not region or states[region] then return end
    local state = { frame = frame, region = region, slot = slot }
    states[region] = state
    local function update() refresh(state) end
    hooks.region(region, "SetText", update)
    hooks.region(region, "SetFormattedText", update)
    -- Prepare Cyrillic fonts even while the native frame is hidden, before
    -- its first crowd-control effect occurs in combat.
    if not runtime.combat_locked() then state.font_ready = runtime.ensure_font(region) end
    refresh(state)
end

local function refresh_frame(frame)
    register_region(frame, field(frame, "AbilityName"), "control.status")
    register_region(frame, field(field(frame, "TimeLeft"), "SecondsText"), "control.seconds")
    for _, state in pairs(states) do
        if state.frame == frame then refresh(state) end
    end
end

adapter.prepare = function ()
    local frame = _G.LossOfControlFrame
    if not frame or call(frame, "IsForbidden") == true then return end
    refresh_frame(frame)
    hooks.region(frame, "SetUpDisplay", refresh_frame)
    hooks.region(frame, "UpdateDisplay", refresh_frame)
    hooks.region_script(frame, "OnShow", refresh_frame)
    -- Covers policy changes while the same effect remains on screen; this
    -- also works if this build exposes no mixin methods on the live frame.
    hooks.region_script(frame, "OnUpdate", refresh_frame)
    hooks.region_script(frame, "OnHide", function ()
        for _, state in pairs(states) do
            if state.frame == frame then runtime.release(state.region, "loss-of-control") end
        end
    end)
end
