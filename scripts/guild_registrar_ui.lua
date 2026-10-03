local _, addon_table = ...
local adapter = addon_table.use("guild_registrar_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-registrar")

local function refresh()
    if not _G.GuildRegistrarFrame then return end
    -- The guild-name EditBox is user input; only its surrounding labels belong here.
    for _, name in ipairs({ "GuildRegistrarText", "AvailableServicesText",
        "GuildRegistrarPurchaseText", "GuildRegistrarCostLabel" }) do ui.watch(_G[name]) end
    for _, name in ipairs({ "GuildRegistrarFrameGoodbyeButton", "GuildRegistrarButton1",
        "GuildRegistrarButton2", "GuildRegistrarFrameCancelButton",
        "GuildRegistrarFramePurchaseButton" }) do ui.button(_G[name]) end
    ui.npc(_G.GuildRegistrarFrameNpcNameText, "npc")
end

adapter.prepare = function ()
    ui.prepare({ "GuildRegistrarFrame" }, "Blizzard_UIPanels_Game",
        { "GuildRegistrar_OnShow", "GuildRegistrar_ShowPurchaseFrame" }, {}, refresh)
end
