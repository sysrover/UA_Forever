local _, addon_table = ...
local panel = addon_table.use("support_ui")
local ui = addon_table.use("panel_ui_adapter").bind("support-ui")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
ui.verified_build = "1.60.1.70862"

local function fit_text(region, width)
    if not region or not runtime.can_write_text(region) or runtime.combat_locked() then return end
    if width then pcall(region.SetWidth, region, width) end
    if type(region.SetWordWrap) == "function" then pcall(region.SetWordWrap, region, true) end
    if type(region.SetMaxLines) == "function" then pcall(region.SetMaxLines, region, 0) end
    local height = layout.safe_dimension(region, "GetStringHeight")
    if height then pcall(region.SetHeight, region, height) end
    return height
end

local function fit_status(frame)
    if not frame or not runtime.can_write_text(frame) or runtime.combat_locked() then return end
    local title = fit_text(frame.TitleText)
    local subtitle = fit_text(frame.SubtitleText)
    local height = layout.safe_dimension(frame, "GetHeight")
    if title and subtitle and height and math.abs(height - title - subtitle - 20) > 0.5 then
        pcall(frame.SetHeight, frame, title + subtitle + 20)
        local manager = _G.StatusTrayManager
        if manager and type(manager.UpdateTrayAndBuffFrameLayout) == "function" then
            pcall(manager.UpdateTrayAndBuffFrameLayout)
        end
    end
end

local function status(frame)
    if not frame or not runtime.can_write_text(frame) then return end
    local function written(region)
        ui.label(region)
        fit_status(frame)
    end
    ui.watch(frame.TitleText, written)
    ui.watch(frame.SubtitleText, written)
end

local function report()
    local frame = _G.ReportCheatingDialog
    if not frame or not runtime.can_write_text(frame) then return end
    ui.watch(_G.ReportCheatingDialogTitle)
    ui.watch(_G.ReportCheatingDialogText1)
    local edit = frame.CommentFrame and frame.CommentFrame.EditBox
    -- The input belongs to the player; only its empty-field hint is UI text.
    ui.watch(edit and edit.InformationText)
    ui.button(frame.reportButton or _G.ReportCheatingDialogReportButton)
    ui.button(_G.ReportCheatingDialogCancelButton)
    if runtime.combat_locked() then return end
    local width = layout.safe_dimension(frame, "GetWidth")
    local title = fit_text(_G.ReportCheatingDialogTitle, width and width - 40)
    local body = fit_text(_G.ReportCheatingDialogText1, width and width - 40)
    if title and body then pcall(frame.SetHeight, frame, math.max(310, title + body + 215)) end
end

local function refresh()
    report()
    status(_G.GMChatStatusFrame)
    status(_G.WowSurveyStatusFrame)
    ui.watch(_G.GMChatTabText)
    local ticket = _G.TicketStatusFrame
    if ticket and runtime.can_write_text(ticket) then
        ui.watch(_G.TicketStatusTitleText)
        local height = fit_text(_G.TicketStatusTitleText)
        if height and not runtime.combat_locked() then pcall(ticket.SetHeight, ticket, height + 20) end
    end
end

panel.prepare = function ()
    ui.prepare({ "ReportCheatingDialog", "TicketStatusFrame", "GMChatStatusFrame",
        "WowSurveyStatusFrame", "GMChatFrame" }, nil,
        { "HelpFrame_ShowReportCheatingDialog", "TicketStatusFrame_OnEvent" }, {}, refresh)
    local edit = _G.ReportCheatingDialog and ReportCheatingDialog.CommentFrame
        and ReportCheatingDialog.CommentFrame.EditBox
    -- The placeholder is shown again when the user clears their comment.
    ui.hooks.region_script(edit, "OnTextChanged", report)
end
