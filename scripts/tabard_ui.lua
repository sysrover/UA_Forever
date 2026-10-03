local _, addon_table = ...
local adapter = addon_table.use("tabard_ui")
local ui = addon_table.use("panel_ui_adapter").bind("tabard")

local function refresh()
    if not _G.TabardFrame then return end
    ui.watch(_G.TabardFrameGreetingText)
    ui.watch(_G.TabardFrameCostLabel)
    for index = 1, 5 do ui.watch(_G["TabardFrameCustomization" .. index .. "Text"]) end
    ui.button(_G.TabardFrameAcceptButton)
    ui.button(_G.TabardFrameCancelButton)
    ui.npc(_G.TabardFrameNameText, "npc")
end

adapter.prepare = function ()
    ui.prepare({ "TabardFrame" }, "Blizzard_UIPanels_Game",
        { "TabardFrame_Open", "TabardFrame_UpdateButtons" }, {}, refresh)
end
