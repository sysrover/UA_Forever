local _, addon_table = ...
local legacy = addon_table.use("legacy_ui")
local api = addon_table.use("panel_ui_adapter").bind("legacy-ui")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local achievements = addon_table.use("achievement_client_db")
local spells = addon_table.use("spell_client_db")
local talents = addon_table.use("tooltip_talent_adapter")
local items = addon_table.use("item_client_db")
local entries = addon_table.use("entries")
local resolver = addon_table.use("translation_resolver")
local strings = addon_table.use("strings")
local tooltip_catalog = assert(addon_table.forever_tooltip_ui)
local layout = addon_table.use("translation_layout")
local descriptions = {}
local scroll_boxes = setmetatable({}, { __mode = "k" })

local function ui_section(region)
    if region and type(region.GetDebugName) == "function" then
        local ok, name = pcall(region.GetDebugName, region)
        name = ok and runtime.safe_string_or_nil(name) or nil
        if name and name:find("LegacySystemFrame.TreePage", 1, true) then return "talents" end
    end
    local root = _G.LegacySystemFrame
    if root and region == (root.TitleText or _G.LegacySystemFrameTitleText)
        and root.currentPage == 3 then return "talents" end
    return "achievements"
end

api.label = function (region)
    if region and not runtime.is_applying(region) then
        strings.translate_region(region, nil, "ui.label", api.surface, nil, nil, ui_section(region))
    end
end

-- Build 70235 owns three independent pages. Never translate their API data,
-- search input, player identity or numeric counters through a recursive scan.
local function apply(region, text, id, slot, option, category, tooltip)
    if not region or runtime.is_applying(region) then return end
    local source = api.text(region)
    text = runtime.safe_string_or_nil(text)
    if not source or source == "" or not text or text == "" then return end
    local previous = runtime.get(region)
    if previous and source == previous.translated then source = previous.source end
    return runtime.apply(region, { owner = "legacy-ui", source = source,
        translated = text, instance = id, slot = slot, option = option or "translate_string",
        category = category, surface = tooltip or api.surface, tooltip = tooltip,
        section = slot == "talent.name" and "talents"
            or (not category and not tooltip and not slot:match("^achievement%.") and ui_section(region)) or nil,
        options = tooltip and { "translate_other_tooltips" } or nil,
        priority = runtime.PRIORITY.DOMAIN, reapply_cached = true,
        after_apply = tooltip and layout.tooltip_after_text(tooltip, region, source) or nil })
end

local function formatted(region, template, ...)
    local translated = template and resolver.find_ui(template)
    if not translated then return end
    local ok, text = pcall(string.format, translated, ...)
    if ok then apply(region, text, nil, "ui.label") end
end

local function point_tooltip(owner)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip:IsOwned(owner) then return end
    api.tooltip(owner)
    local count = tooltip:NumLines()
    if runtime.is_secret_value(count) or type(count) ~= "number" then return end
    for index = 1, math.min(count, 40) do
        local region = _G["GameTooltipTextLeft" .. index]
        local source = api.text(region)
        local amount = source and source:match("^You can spend up to your current seasonal cap of (%d+) Legacy Points in total%.$")
        local template = amount and resolver.find_ui(_G.LEGACY_POINTS_SEASONAL_CAP)
        if template then
            local ok, text = pcall(string.format, template, tonumber(amount))
            if ok then apply(region, text, nil, "ui.tooltip", nil, nil, tooltip) end
        end
    end
end

local function watch(region, callback)
    api.watch(region, function (written)
        local previous = runtime.get(written)
        if previous and api.text(written) ~= previous.translated then runtime.invalidate(written) end
        (callback or api.label)(written)
    end)
end

local function challenge_id(row)
    return row and row.id or row and row.Shield and row.Shield.id
end

local function translate_challenge(row)
    if not row then return end
    local id = challenge_id(row)
    local data = achievements.get(id)
    if not data then return end
    apply(row.Label, data.title, id, "achievement.name")
    apply(row.Description, data.description, id, "achievement.description")
    apply(row.HiddenDescription, data.description, id, "achievement.description")
    -- Legacy uses SystemFont_Shadow_Med1, not ACHIEVEMENTUI_FONTHEIGHT.
    if row.HiddenDescription and type(row.HiddenDescription.GetFont) == "function" then
        local _, height = row.HiddenDescription:GetFont()
        if type(height) == "number" and height > 0 then
            row.numLines = math.ceil(row.HiddenDescription:GetHeight() / height)
        end
    end
end

local function prepare_challenge(row)
    for _, key in ipairs({ "Label", "Description", "HiddenDescription" }) do
        watch(row[key], function () translate_challenge(row) end)
    end
    watch(row.Tracked and row.Tracked.Text)
    -- Native InitRewards is a Legacy no-op, but occurs before Expand and the
    -- final row layout. Instance hooks also cover templates copied before us.
    api.hooks.region(row, "InitRewards", translate_challenge)
    api.hooks.region(row, "Init", translate_challenge)
    translate_challenge(row)
end

local function translate_category(row)
    local node = row.node
    local data = node and node:GetData()
    local info = data and data.categoryInfo
    local region = row.ButtonText
    local name = info and achievements.get_category_name(info.id)
    if name then apply(region, name, info.id, "achievement.category")
    else api.label(region) end
end

local function prepare_category(row)
    watch(row.ButtonText, function () translate_category(row) end)
    api.hooks.region(row, "Init", translate_category)
    translate_category(row)
end

local function prepare_scroll(box, callback)
    if not box then return end
    local event = _G.ScrollBoxListMixin and ScrollBoxListMixin.Event
        and ScrollBoxListMixin.Event.OnInitializedFrame
    if event and type(box.RegisterCallback) == "function" and not scroll_boxes[box] then
        box:RegisterCallback(event, function (_, row) callback(row) end, scroll_boxes)
        scroll_boxes[box] = true
    end
    if type(box.ForEachFrame) == "function" then box:ForEachFrame(callback) end
end

local function reward_translation(reward)
    if type(reward) ~= "table" then return end
    local id = reward.itemID
    if not id and reward.transmogID and _G.C_Transmog then
        id = C_Transmog.GetItemIDForSource(reward.transmogID)
    end
    if id then
        local entry = entries.get_entry("item", id)
        return entry and entry[1] or items.get_name(id), id, "item.name", "translate_item", "item"
    end
    id = reward.spellID
    if not id and reward.mountID and _G.C_MountJournal then
        local _, spell_id = C_MountJournal.GetMountInfoByID(reward.mountID)
        id = spell_id
    end
    if id then return spells.get_name(id), id, "spell.name", "translate_spell", "spell" end
end

local function translate_reward(row)
    local reward = row.info and row.info.rewardInfo and row.info.rewardInfo[1]
    local text, id, slot, option, category = reward_translation(reward)
    apply(row.RewardName, text, id, slot, option, category)
end

local function translate_reward_tooltip(row)
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip:IsOwned(row) then return end
    api.tooltip(row)
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    if count_ok and not runtime.is_secret_value(count) and type(count) == "number" then
        for index = 1, math.min(count, 40) do
            local region = _G["GameTooltipTextLeft" .. index]
            local source = api.text(region)
            local translated = source and tooltip_catalog.legacy_reward_description(source)
            if translated and translated ~= source then
                apply(region, translated, nil, "achievement.reward.description", nil, nil, tooltip)
            end
        end
    end
    local rewards = row.info and row.info.rewardInfo
    if type(rewards) ~= "table" or row.isCapstone then return end
    for _, reward in ipairs(rewards) do
        local text, id, slot, option, category = reward_translation(reward)
        local util = _G.RenownRewardUtil
        local native
        if util then local _; _, native = util.GetRenownRewardInfo(reward) end
        native = runtime.safe_string_or_nil(native)
        if text and native then
            for index = 1, math.min(tooltip:NumLines(), 40) do
                local region = _G["GameTooltipTextLeft" .. index]
                local source = api.text(region)
                local at, ending
                if source then at, ending = source:find(native, 1, true) end
                if at then
                    apply(region, source:sub(1, at - 1) .. text .. source:sub(ending + 1),
                        id, slot, option, category, tooltip)
                end
            end
        end
    end
end

local function prepare_reward(row)
    watch(row.RewardName, function () translate_reward(row) end)
    api.hooks.region(row, "SetRewardName", translate_reward)
    api.hooks.region(row, "SetInfo", translate_reward)
    api.hooks.region(row, "RefreshTooltip", translate_reward_tooltip)
    translate_reward(row)
end

local function prepare_preview(row)
    local function translate()
        local result = row.resultInfo
        local id = result and talents.get_spell_id_for_entry(result.resultID)
        if id and id > 0 then
            apply(row.Name or row.Text, spells.get_name(id), result.resultID,
                "talent.name", "translate_spell", "spell")
        end
    end
    watch(row.Name or row.Text, translate)
    api.hooks.region(row, "Init", translate)
    translate()
end

local function translate_criterion(region)
    local source = api.text(region)
    local previous = region and runtime.get(region)
    if previous and source == previous.translated then source = previous.source end
    if not source then return end
    local translated = achievements.get_criteria_text(source)
    if translated then
        apply(region, translated, nil, "achievement.criteria")
    else
        api.label(region)
    end
end

local function prepare_criterion(row)
    watch(row.Name, translate_criterion)
end

local function prepare_objectives(frame)
    local pool = frame and frame.criteriaPool
    if pool and type(pool.EnumerateActive) == "function" then
        for row in pool:EnumerateActive() do prepare_criterion(row) end
    end
end

local function refresh()
    local root = _G.LegacySystemFrame
    if not root then return end
    watch(root.TitleText or _G.LegacySystemFrameTitleText)
    for _, tab in ipairs(root.Tabs or {}) do
        api.hooks.region_script(tab, "OnEnter", api.tooltip)
    end
    local track = root.RewardTrackPage
    if track then
        watch(track.PointsLabel)
        local progress = track.LegacyRewardProgressFrame
        local rows = progress and progress:GetElements()
        for _, row in ipairs(rows or {}) do prepare_reward(row) end
    end
    local page = root.ChallengesPage
    if page then
        local list = page.CategoryList
        if list then
            watch(list.SearchBox and list.SearchBox.Instructions)
            watch(list.FilterDropdown and list.FilterDropdown.Text)
            prepare_scroll(list.ScrollBox, prepare_category)
        end
        prepare_scroll(page.DetailPane and page.DetailPane.ScrollBox, prepare_challenge)
        prepare_objectives(_G.LegacyChallengeObjectives)
        api.hooks.region(_G.LegacyChallengeObjectives, "Display", prepare_objectives)
        local summary = page.LegacyChallengePointSummary
        watch(summary and summary.PointsBar and summary.PointsBar.Text, function (region)
            local source = api.text(region)
            local current, maximum
            if source then current, maximum = source:match("^Legacy Points (%d+) / (%d+)$") end
            if current then formatted(region, _G.LEGACY_POINTS_CURR_MAX,
                tonumber(current), tonumber(maximum)) end
        end)
    end
    local tree = root.TreePage
    local panel = tree and tree.LegacyTreeTraitPanel
    if panel then
        watch(panel.SelectedTreeIcon and panel.SelectedTreeIcon.SelectedTreeLabel)
        watch(panel.SearchBox and panel.SearchBox.Instructions)
        api.button(panel.ApplyButton)
        for _, key in ipairs({ "ResetButton", "UndoButton" }) do
            api.hooks.region_script(panel[key], "OnEnter", api.tooltip)
        end
        local preview = panel.SearchPreviewContainer
        prepare_scroll(preview and preview.ScrollBox, prepare_preview)
        watch(preview and preview.OverflowCount and preview.OverflowCount.Text)
    end
    local summary = tree and tree.LegacyTreePointSummary
    watch(summary and summary.AvailablePointsLabel, function (region)
        local source = api.text(region)
        local amount = source and source:match("^Available points: (.+)$")
        if amount then formatted(region, _G.LEGACY_POINTS_AVAILABLE, amount) end
    end)
    api.hooks.region_script(summary, "OnEnter", point_tooltip)
    local selection = tree and tree.LegacyTreeSelectionPanel
    for _, button in ipairs(selection and selection.treeButtons or {}) do
        api.hooks.region_script(button, "OnEnter", api.tooltip)
    end
end

local function remember_descriptions(pane, info)
    local system = _G.LegacySystem
    if not info or not system or type(system.GetChallengeIndices) ~= "function" then return end
    local start, count = system.GetChallengeIndices(info.id)
    for index = start + 1, start + count do
        local id, _, _, _, _, _, _, source = GetAchievementInfo(info.id, index)
        local row = achievements.get(id)
        if row and runtime.safe_string_or_nil(source) then descriptions[source] = { id, row.description } end
    end
    local placeholder = _G.AchievementFrame and AchievementFrame.PlaceholderHiddenDescription
    watch(placeholder, function (region)
        if not _G.LegacySystemFrame or not LegacySystemFrame:IsShown()
            or not LegacySystemFrame.ChallengesPage:IsShown() then return end
        local row = descriptions[api.text(region)]
        if row then apply(region, row[2], row[1], "achievement.description") end
    end)
    refresh()
end

legacy.prepare = function ()
    api.surface = registry.register_surface({ id = "legacy-ui", roots = { "LegacySystemFrame" },
        domains = { "ui", "achievement", "item", "spell" }, name_category = "none",
        static = refresh, is_open = function ()
            return _G.LegacySystemFrame and LegacySystemFrame:IsShown() or false
        end })
    local function declare(target, method, callback)
        registry.declare_hook({ id = "legacy-ui:" .. target .. "." .. method,
            surface = "legacy-ui", kind = "mixin", target = target, method = method,
            callback = callback, blizzardAddon = "Blizzard_LegacySystem", verifiedBuild = 70235 })
    end
    declare("LegacyChallengeTemplateMixin", "InitRewards", translate_challenge)
    declare("LegacyChallengeTemplateMixin", "Init", prepare_challenge)
    declare("LegacyChallengeCategoryMixin", "Init", prepare_category)
    declare("LegacyChallengeCriteriaMixin", "Init", prepare_criterion)
    declare("LegacyChallengeObjectivesMixin", "Display", prepare_objectives)
    declare("LegacyChallengeDetailPaneMixin", "GenerateDataProvider", remember_descriptions)
    for _, pair in ipairs({ { "LegacySystemFrameMixin", "SelectPage" },
        { "LegacyRewardTrackPageMixin", "SetupRewardTrack" },
        { "LegacyTreeTraitPanelMixin", "SelectTree" },
        { "LegacyTreeSelectionPanelMixin", "RefreshTreeButtons" } }) do
        declare(pair[1], pair[2], refresh)
    end
    api.hooks.region_script(_G.LegacySystemFrame, "OnShow", refresh)
    local root = _G.LegacySystemFrame
    api.hooks.region(root, "SelectPage", refresh)
    if root then
        api.hooks.region(root.RewardTrackPage, "SetupRewardTrack", refresh)
        local pane = root.ChallengesPage and root.ChallengesPage.DetailPane
        api.hooks.region(pane, "GenerateDataProvider", remember_descriptions)
        if pane and pane.info then remember_descriptions(pane, pane.info) end
        local tree = root.TreePage
        api.hooks.region(tree and tree.LegacyTreeTraitPanel, "SelectTree", refresh)
        api.hooks.region(tree and tree.LegacyTreeSelectionPanel, "RefreshTreeButtons", refresh)
    end
    refresh()
end
