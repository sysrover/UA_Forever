local _, addon_table = ...

local level_up_display = addon_table.use("level_up_display")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local hooks = addon_table.use("translation_hooks").bind("level-up-display")

local function visible_text(region)
    if not region or type(region.GetText) ~= "function" then return nil end
    local ok, value = pcall(region.GetText, region)
    if not ok or type(value) ~= "string" then return nil end
    if type(_G.issecretvalue) == "function" then
        local secret_ok, secret = pcall(_G.issecretvalue, value)
        if not secret_ok or secret then return nil end
    end
    return value
end

local function after_start_display(frame)
    if not frame then return end
    if frame.type ~= _G.LEVEL_UP_TYPE_CHARACTER
        or not options.can_lookup("translate_string") then
        if options.account and options.account.auto_scan_content
            and type(strings.capture_frame) == "function" then
            strings.capture_frame(frame)
        end
        return
    end
    local level_frame = frame.levelFrame
    local translations = addon_table.forever_ui
    if not level_frame or not translations then return end

    local reached = level_frame.reachedText
    local reached_source = visible_text(reached)
    local reached_translation = translations[reached_source]
    if reached_source == "You've Reached" and reached_translation then
        runtime.apply(reached, {
            owner = "level-up-display", slot = "ui.text",
            source = reached_source, translated = reached_translation,
            option = "translate_string", priority = runtime.PRIORITY.CONTEXT,
        })
    end

    local level_text = level_frame.levelText
    local source = visible_text(level_text)
    local level = source and source:match("^Level (%d+)$")
    local template = translations["Level %d"]
    if level and template and tonumber(level) == frame.level then
        local ok, translated = pcall(string.format, template, tonumber(level))
        if ok then
            runtime.apply(level_text, {
                owner = "level-up-display", slot = "ui.text",
                source = source, translated = translated,
                option = "translate_string", priority = runtime.PRIORITY.CONTEXT,
            })
        end
    end
    if options.account and options.account.auto_scan_content
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(frame)
    end
end

level_up_display.prepare = function ()
    hooks.global("LevelUpDisplay_StartDisplay", after_start_display)
end
