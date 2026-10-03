local _, addon_table = ...
local adapter = addon_table.use("role_poll_ui")
local ui = addon_table.use("panel_ui_adapter").bind("role-poll")

local function refresh()
    local frame = _G.RolePollPopup
    if not frame then return end
    ui.regions(frame) -- The XML title is an anonymous direct FontString.
    ui.button(frame.acceptButton)
    for _, name in ipairs({ "RolePollPopupRoleButtonTank", "RolePollPopupRoleButtonHealer",
        "RolePollPopupRoleButtonDPS" }) do
        ui.hooks.region_script(_G[name], "OnEnter", ui.tooltip)
    end
end

adapter.prepare = function ()
    ui.prepare({ "RolePollPopup" }, "Blizzard_FrameXML",
        { "RolePollPopup_Show" }, {}, refresh)
end
