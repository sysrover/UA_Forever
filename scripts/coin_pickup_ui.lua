local _, addon_table = ...
local adapter = addon_table.use("coin_pickup_ui")
local ui = addon_table.use("panel_ui_adapter").bind("coin-pickup")

local function refresh()
    if not _G.CoinPickupFrame then return end
    -- CoinPickupText/Label encode native numeric amounts and denomination symbols.
    ui.button(_G.CoinPickupOkayButton)
    ui.button(_G.CoinPickupCancelButton)
end

adapter.prepare = function ()
    ui.prepare({ "CoinPickupFrame" }, "Blizzard_FrameXML",
        { "OpenCoinPickupFrame", "UpdateCoinPickupFrame" }, {}, refresh)
end
