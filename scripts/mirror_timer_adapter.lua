local _, addon_table = ...

local adapter = addon_table.use("mirror_timer_adapter")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("mirror-timer")

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

local function refresh(state)
    local frame, region = state.frame, state.region
    if runtime.is_applying(region) then return end
    if call(frame, "IsForbidden") == true then return end
    local visible = safe_string(call(region, "GetText"))
    if not visible then
        runtime.release(region, "mirror-timer")
        return
    end
    -- The three native frames are reused for different timer types. Recover
    -- our source only while the text still matches this region's last result.
    local source = visible == state.translated and state.source or visible
    local translated = safe_string(strings.find_ui_translation(source, region))
    if not translated or translated == source then
        runtime.release(region, "mirror-timer")
        return
    end
    state.source, state.translated = source, translated
    -- Keep the claim when translation is disabled so refresh_policy can
    -- restore the original and re-enable it while the same bar remains open.
    runtime.apply(region, {
        owner = "mirror-timer", slot = "timer.label",
        source = source, translated = translated, option = "translate_string",
        priority = runtime.PRIORITY.CONTEXT, reapply_cached = true,
        combat_text_only = runtime.combat_locked(), defer_if_protected = false,
    })
end

local function register(frame)
    if not frame or call(frame, "IsForbidden") == true then return end
    local region = field(frame, "Text")
    if not region then return end
    local state = states[region]
    if not state then
        state = { frame = frame, region = region }
        states[region] = state
        local function update() refresh(state) end
        -- Build 70170 copies mixin methods onto anonymous XML frames. Hook
        -- their live methods and Text, rather than only the mixin table.
        hooks.region(frame, "Setup", update)
        hooks.region(region, "SetText", update)
        hooks.region_script(frame, "OnShow", update)
        hooks.region_script(frame, "OnUpdate", update)
        hooks.region_script(frame, "OnHide", function ()
            runtime.release(region, "mirror-timer")
        end)
    end
    -- Prepare hidden labels before the first underwater timer starts in combat.
    if not runtime.combat_locked() then runtime.ensure_font(region) end
    refresh(state)
end

adapter.prepare = function ()
    local container = _G.MirrorTimerContainer
    if not container or call(container, "IsForbidden") == true then return end
    local timers = field(container, "mirrorTimers")
    if type(timers) ~= "table" then return end
    for _, frame in ipairs(timers) do register(frame) end
end
