local _, addon_table = ...
local panel = addon_table.use("player_choice_ui")
local ui = addon_table.use("panel_ui_adapter").bind("player-choice")
local runtime = addon_table.use("translation_runtime")
local walker = addon_table.use("translation_walker")
ui.verified_build = "1.60.1.70862"

local function skip(frame)
    if not runtime.can_write_text(frame) then return true end
    local ok, kind = pcall(frame.GetObjectType, frame)
    return not ok or runtime.is_secret_value(kind) or kind == "EditBox"
end

local function labels(frame)
    if not frame or skip(frame) then return end
    walker.walk({ id = "player-choice-labels", surface = "player-choice",
        owner = "player-choice", reason = "PLAYER_CHOICE_RENDERED_LABELS", max_nodes = 400 }, frame,
        function (region)
            local ok, kind = pcall(region.GetObjectType, region)
            if ok and not runtime.is_secret_value(kind) and kind == "FontString" then
                ui.watch(region)
                -- These writers can reset fitting after the inner SetText.
                ui.hooks.region(region, "SetTextToFit", ui.label)
            end
        end, skip, { frames = 0 })
end

local function refresh()
    local frame = _G.PlayerChoiceFrame
    if not frame or not runtime.can_write_text(frame) then return end
    labels(frame)
    local pools, template = frame.optionPools, frame.optionFrameTemplate
    if pools and type(pools.EnumerateActiveByTemplate) == "function" and type(template) == "string" then
        for row in pools:EnumerateActiveByTemplate(template) do
            ui.hooks.region(row, "Setup", labels)
            labels(row)
        end
    end
end

panel.prepare = function ()
    ui.prepare({ "PlayerChoiceFrame" }, "Blizzard_PlayerChoice", {}, {
        { "PlayerChoiceFrame", "TryShow" },
        { "PlayerChoiceFrame", "SetupOptions" },
        { "PlayerChoiceFrame", "SetupOptionsAsGrid" },
        { "PlayerChoiceFrame", "OnPageChanged" },
    }, refresh)
end
