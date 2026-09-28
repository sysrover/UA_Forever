local _, addon_table = ...

local achievements = addon_table.use("achievements")
local registry = addon_table.use("translation_registry")
local strings = addon_table.use("strings")

local function translate_alert(frame)
    if not frame then return end
    local surface = registry.get("achievement-alert")
    if not surface then return end

    -- Achievement alerts are pooled and Blizzard rewrites both regions on
    -- every setup. Translate only after that write so a reused alert keeps
    -- the title belonging to its current achievement.
    strings.translate_region(frame.Name, nil, "achievement.name", surface)
    strings.translate_region(frame.Unlocked, nil, "ui.title", surface)
end

local function declare_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "achievement-alert.setup",
        surface = "achievement-alert",
        kind = "global",
        target = "AchievementAlertFrame_SetUp",
        required = true,
        fallbackEvent = "ACHIEVEMENT_EARNED",
        verifiedBuild = 70009,
        callback = translate_alert,
    })
end

achievements.prepare = function ()
    declare_hooks()
end
