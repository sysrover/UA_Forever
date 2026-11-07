local _, addon_table = ...
local panel = addon_table.use("battlefield_map_ui")
local ui = addon_table.use("panel_ui_adapter").bind("battlefield-map")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
ui.verified_build = "1.60.1.70862"

local function refresh()
    local tab = _G.BattlefieldMapTab
    if tab and runtime.can_write_text(tab) then
        ui.watch(tab.Text)
        if not runtime.combat_locked() and type(_G.PanelTemplates_TabResize) == "function" then
            pcall(PanelTemplates_TabResize, tab, 0)
        end
    end
    -- OpacityFrame is a separate UIParent dialog in both family variants.
    local frame, label = _G.OpacityFrame, _G.OpacityFrameSliderText
    if frame and runtime.can_write_text(frame) then
        ui.watch(label)
        if label and not runtime.combat_locked() then
            local text_width = layout.safe_dimension(label, "GetUnboundedStringWidth")
            local frame_width = layout.safe_dimension(frame, "GetWidth")
            if text_width and frame_width and text_width + 24 > frame_width then
                pcall(frame.SetWidth, frame, text_width + 24)
            end
        end
    end
end

panel.prepare = function ()
    ui.prepare({ "BattlefieldMapTab", "BattlefieldMapFrame", "OpacityFrame" },
        "Blizzard_BattlefieldMap", {}, {}, refresh)
end
