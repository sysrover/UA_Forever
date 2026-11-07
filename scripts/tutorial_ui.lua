local _, addon_table = ...
local adapter = addon_table.use("tutorial_ui")
local ui = addon_table.use("panel_ui_adapter").bind("tutorial")
local runtime = addon_table.use("translation_runtime")
local help_tips = setmetatable({}, { __mode = "k" })

local function prepare_help_tips()
    local pool = _G.HelpTip and HelpTip.framePool
    if not pool or type(pool.EnumerateActive) ~= "function" then return end
    for tip in pool:EnumerateActive() do
        if not help_tips[tip] then
            help_tips[tip] = true
            -- Pool Acquire has finished, but HelpTip:Show has not called Init
            -- yet. Hook the actual instance, including copies made before us.
            ui.hooks.region(tip, "ApplyText", function (frame) ui.label(frame.Text) end)
            if tip.info and not runtime.combat_locked() and runtime.can_write_text(tip) then
                pcall(tip.Layout, tip)
            end
        end
    end
end

local function refresh()
    if not _G.TutorialFrame then return end
    ui.watch(_G.TutorialFrameTitle)
    ui.watch(_G.TutorialFrameText)
    for _, name in ipairs({ "TutorialFrameOkayButton", "TutorialFramePrevButton",
        "TutorialFrameNextButton" }) do
        ui.button(_G[name])
        ui.regions(_G[name])
    end
    -- Run after TutorialFrame_Update: it can restore the native font after SetText.
    ui.label(_G.TutorialFrameText)
    ui.label(_G.TutorialFrameTitle)
end

adapter.prepare = function ()
    -- ApplyText runs inside HelpTip:Layout before the final text height is read.
    -- Translate the region only: info.text is also the native dismissal key.
    ui.hooks.region(_G.HelpTip and HelpTip.framePool, "Acquire", prepare_help_tips)
    prepare_help_tips()
    ui.prepare({ "TutorialFrame" }, "Blizzard_FrameXML",
        { "TutorialFrame_Update", "TutorialFrame_OnShow", "TutorialFrame_CheckNextPrevButtons" }, {}, refresh)
end
