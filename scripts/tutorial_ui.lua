local _, addon_table = ...
local adapter = addon_table.use("tutorial_ui")
local ui = addon_table.use("panel_ui_adapter").bind("tutorial")

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
    ui.prepare({ "TutorialFrame" }, "Blizzard_FrameXML",
        { "TutorialFrame_Update", "TutorialFrame_OnShow", "TutorialFrame_CheckNextPrevButtons" }, {}, refresh)
end
