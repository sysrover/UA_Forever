local _, addon_table = ...

local achievements = addon_table.use("achievements")
local registry = addon_table.use("translation_registry")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local database = addon_table.use("achievement_client_db")
local api = addon_table.use("panel_ui_adapter").bind("achievement-ui")

local function translate_criterion(region)
    local source = api.text(region)
    local previous = region and runtime.get(region)
    if previous and source == previous.translated then source = previous.source
    elseif previous then runtime.invalidate(region) end
    if not source then return end
    local prefix, name, suffix = source:match("^(|[cC]%x%x%x%x%x%x%x%x)(.-)(|r)$")
    prefix, name, suffix = prefix or "", name or source, suffix or ""
    if name:sub(1, 2) == "- " then
        prefix, name = prefix .. "- ", name:sub(3)
    end
    local translated = database.get_criteria_text(name)
    if translated then
        api.apply(region, prefix .. translated .. suffix, "achievement.criteria")
    else
        strings.translate_region(region, nil, "ui.label", api.surface)
    end
end

local function prepare_criterion(frame)
    if frame then api.watch(frame.Name, translate_criterion) end
end

local function prepare_objectives(frame)
    for _, row in ipairs(frame and frame.criterias or {}) do prepare_criterion(row) end
end

local function apply(region, text, id, slot, surface_id)
    if not region or type(region.GetText) ~= "function" or not text or text == "" then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and runtime.safe_string_or_nil(source) or nil
    if not source then return end
    return runtime.apply(region, {
        source = source, translated = text, instance = id,
        owner = "achievements", slot = slot, option = "translate_string",
        priority = runtime.PRIORITY.DOMAIN, reapply_cached = true,
        surface = registry.get(surface_id or "achievement-ui"),
    })
end

local function translate_row(frame, id)
    if not frame then return end
    local row = database.get(id)
    if not row then return end
    apply(frame.Label, row.title, id, "achievement.name")
    apply(frame.Description, row.description, id, "achievement.description")
    local hidden_changed = apply(frame.HiddenDescription, row.description, id, "achievement.description")
    apply(frame.Reward, row.reward, id, "achievement.reward")
    if hidden_changed and type(_G.ACHIEVEMENTUI_FONTHEIGHT) == "number"
        and _G.ACHIEVEMENTUI_FONTHEIGHT > 0 then
        frame.numLines = math.ceil(frame.HiddenDescription:GetHeight() / _G.ACHIEVEMENTUI_FONTHEIGHT)
    end
end

local function translate_alert(frame, achievement_id)
    if not frame then return end
    local surface = registry.get("achievement-alert")
    if not surface then return end

    -- Achievement alerts are pooled and Blizzard rewrites both regions on
    -- every setup. Translate only after that write so a reused alert keeps
    -- the title belonging to its current achievement.
    local row = database.get(achievement_id)
    if row then
        apply(frame.Name, row.title, achievement_id, "achievement.name", "achievement-alert")
    end
    strings.translate_region(frame.Unlocked, nil, "ui.title", surface)
end

local function translate_rewards(frame)
    -- Init writes Shield.id and both descriptions before InitRewards, then
    -- calculates the expanded layout. Translate here so it measures Ukrainian.
    translate_row(frame, frame and frame.Shield and frame.Shield.id)
end

local function translate_category(frame)
    if not frame or not frame.Button then return end
    local id = frame.categoryID
    apply(frame.Button.Label, database.get_category_name(id), id, "achievement.category")
end

local function translate_summary()
    local summary = _G.AchievementFrameSummaryAchievements
    if not summary or type(summary.buttons) ~= "table" then return end
    for _, button in ipairs(summary.buttons) do translate_row(button, button.id) end
end

local function translate_comparison(frame)
    if not frame then return end
    translate_row(frame.Player, frame.id)
    translate_row(frame.Friend, frame.id)
end

local function translate_search(_, result)
    if not result then return end
    local row = database.get(result.achievementID)
    if row then apply(result.Name, row.title, result.achievementID, "achievement.name") end
end

local function declare_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "achievement-alert.setup",
        surface = "achievement-alert",
        -- The queue captures the setup function before addon initialization.
        -- Hook its stored callback: a global hook misses this cached reference.
        -- The queue calls it without self, so translate_alert receives the frame.
        kind = "frame",
        target = "AchievementAlertSystem",
        method = "setUpFunction",
        required = true,
        fallbackEvent = "ACHIEVEMENT_EARNED",
        verifiedBuild = 70205,
        callback = translate_alert,
    })
    local function ui_hook(id, kind, target, method, callback, build)
        registry.declare_hook({
            id = "achievement-ui." .. id, surface = "achievement-ui",
            kind = kind, target = target, method = method,
            blizzardAddon = "Blizzard_AchievementUI", required = true,
            verifiedBuild = build or 70205, callback = callback,
        })
    end
    ui_hook("rewards", "mixin", "AchievementTemplateMixin", "InitRewards", translate_rewards)
    ui_hook("category", "mixin", "AchievementCategoryTemplateMixin", "Init", translate_category)
    ui_hook("summary", "global", "AchievementFrameSummary_UpdateAchievements", nil, translate_summary)
    ui_hook("comparison", "mixin", "AchievementComparisonTemplateMixin", "Init", translate_comparison)
    ui_hook("search", "global", "AchievementFrameSearch_InitButton", nil, translate_search)
    ui_hook("criteria-create", "global", "AchievementFrame_LocalizeCriteria", nil, prepare_criterion, 70291)
    ui_hook("criteria-display", "global", "AchievementObjectives_DisplayCriteria", nil, prepare_objectives, 70291)
end

achievements.prepare = function ()
    api.surface = registry.get("achievement-ui")
    declare_hooks()
    prepare_objectives(_G.AchievementFrameAchievementsObjectives)
    prepare_objectives(_G.AchievementFrameAchievementsObjectivesOffScreen)
end
