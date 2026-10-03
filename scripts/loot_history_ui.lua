local _, addon_table = ...
local adapter = addon_table.use("loot_history_ui")
local ui = addon_table.use("panel_ui_adapter").bind("loot-history")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local registered_scroll_boxes = setmetatable({}, { __mode = "k" })

local function pending(row)
    local info = row.dropInfo
    local region = row.PendingRollInfo and row.PendingRollInfo.CurrentWinnerText
    local previous = region and runtime.get(region)
    if previous and ui.text(region) ~= previous.translated then runtime.invalidate(region) end
    if not info or not region or not info.isTied or not info.currentLeader then return end
    local tie = runtime.safe_string_or_nil(_G.LOOT_HISTORY_ROLL_TIE)
    local translated = tie and resolver.find_ui(tie)
    local roll = info.currentLeader.roll
    if translated and not runtime.is_secret_value(roll) and type(roll) == "number" then
        ui.formatted(region, _G.LOOT_HISTORY_CURRENT_WINNER, translated, roll)
    end
end

local function tooltip(row)
    local info = row.dropInfo
    if not info then return end
    local frame = _G.GameTooltip
    if not frame then return end
    local owned_ok, owned = pcall(frame.IsOwned, frame, row)
    if not owned_ok or runtime.is_secret_value(owned) or owned ~= true then return end
    ui.item(_G.GameTooltipTextLeft1, info.itemHyperlink, frame)
    ui.tooltip(row)
    -- The tooltip embeds pooled roll frames, not ordinary TextLeft rows.
    local ok, children = pcall(function () return { frame:GetChildren() } end)
    if ok then
        for _, child in ipairs(children) do
            local region = child.PlayerName
            local source = ui.text(region)
            if source then
                local name = source:match("^(.-) |cnDISABLED_FONT_COLOR:%(Off%-Spec%)|r$")
                if name then
                    local template = runtime.safe_string_or_nil(_G.LOOT_HISTORY_OFF_SPEC_FMT)
                    local translated = template and resolver.find_ui(template)
                    if translated then
                        local format_ok, text = pcall(string.format, translated, name)
                        if format_ok then ui.apply(region, text, "ui.tooltip", nil, nil, frame) end
                    end
                elseif resolver.normalize(source) == _G.LOOT_HISTORY_ALL_PASSED then
                    local translated = resolver.find_ui(source, region)
                    local color, _, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
                    if translated then
                        ui.apply(region, color and (color .. translated .. reset) or translated,
                            "ui.tooltip", nil, nil, frame)
                    end
                end
            end
        end
    end
    local count_ok, count = pcall(frame.NumLines, frame)
    local prefix = runtime.safe_string_or_nil(_G.LOOT_HISTORY_WAITING_ON)
    local translated_prefix = prefix and resolver.find_ui(prefix)
    if count_ok and not runtime.is_secret_value(count) and type(count) == "number"
        and prefix and translated_prefix then
        for index = 1, math.min(count, 40) do
            local region = _G["GameTooltipTextLeft" .. index]
            local source = ui.text(region)
            if source and source:sub(1, #prefix) == prefix then
                ui.apply(region, translated_prefix .. source:sub(#prefix + 1),
                    "ui.tooltip", nil, nil, frame)
            end
        end
    end
end

local function prepare_row(row)
    if not row then return end
    if not row.ItemName then
        ui.regions(row) -- The anonymous Passed section header, not a player row.
        return
    end
    ui.watch(row.ItemName, function (region)
        local info = row.dropInfo
        ui.item(region, info and info.itemHyperlink)
    end)
    ui.watch(row.AllPassedInfo and row.AllPassedInfo.AllPassedText)
    if row.PendingRollInfo then
        ui.watch(row.PendingRollInfo.CurrentWinnerText, function () pending(row) end)
    end
    -- XML copies these mixins onto recycled rows. Hook the live instances.
    ui.hooks.region(row, "Init", prepare_row)
    ui.hooks.region(row, "SetTooltip", tooltip)
    ui.hooks.region_script(row, "OnHide", function ()
        runtime.invalidate(row.ItemName)
        runtime.invalidate(row.PendingRollInfo and row.PendingRollInfo.CurrentWinnerText)
    end)
    -- WinningRoll contains a colored player name and remains native.
end

local function refresh()
    local frame = _G.GroupLootHistoryFrame
    if not frame then return end
    ui.watch(frame.TitleContainer and frame.TitleContainer.TitleText)
    ui.watch(frame.NoInfoString)
    ui.watch(frame.EncounterDropdown and frame.EncounterDropdown.Text)
    local scroll_box = frame.ScrollBox
    if scroll_box and type(scroll_box.RegisterCallback) == "function"
        and _G.ScrollBoxListMixin and not registered_scroll_boxes[scroll_box] then
        scroll_box:RegisterCallback(ScrollBoxListMixin.Event.OnInitializedFrame,
            function (_, row) prepare_row(row) end, registered_scroll_boxes)
        registered_scroll_boxes[scroll_box] = true
    end
    if scroll_box and type(scroll_box.ForEachFrame) == "function" then
        pcall(scroll_box.ForEachFrame, scroll_box, prepare_row)
    end
end

adapter.prepare = function ()
    -- Camelot replaces ShouldAutoOpen; the other frame/row writers are mainline.
    ui.prepare({ "GroupLootHistoryFrame" }, "Blizzard_FrameXML", {}, {
        { "GroupLootHistoryFrame", "InitRegions" },
        { "GroupLootHistoryFrame", "DoFullRefresh" },
        { "GroupLootHistoryFrame", "OpenToEncounter" },
    }, refresh)
end
