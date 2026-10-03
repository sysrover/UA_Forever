local _, addon_table = ...
local adapter = addon_table.use("petition_ui")
local ui = addon_table.use("panel_ui_adapter").bind("petition")
local runtime = addon_table.use("translation_runtime")

local function title(region)
    local frame = _G.PetitionFrame
    if frame and frame.petitionType == "guild" then
        local name = ui.text(_G.PetitionFrameCharterName)
        if name then ui.formatted(region, _G.GUILD_CHARTER_TEMPLATE, name) end
    else
        ui.label(region)
    end
end

local function unsigned(region)
    local source = ui.text(region)
    local previous = runtime.get(region)
    if source == _G.NOT_YET_SIGNED or previous and source == previous.translated then
        ui.label(region)
    else
        -- This recycled slot now contains a player's actual signature.
        runtime.invalidate(region)
    end
end

local function refresh()
    if not _G.PetitionFrame then return end
    for _, name in ipairs({ "PetitionFrameCharterTitle", "PetitionFrameMasterTitle",
        "PetitionFrameMemberTitle", "PetitionFrameInstructions" }) do ui.watch(_G[name]) end
    for _, name in ipairs({ "PetitionFrameCancelButton", "PetitionFrameSignButton",
        "PetitionFrameRequestButton", "PetitionFrameRenameButton" }) do ui.button(_G[name]) end
    ui.watch(_G.PetitionFrameNpcNameText, title)
    for index = 1, 9 do ui.watch(_G["PetitionFrameMemberName" .. index], unsigned) end
    -- CharterName and MasterName are guild/player data, never generic UI text.
end

adapter.prepare = function ()
    ui.prepare({ "PetitionFrame" }, "Blizzard_UIPanels_Game",
        { "PetitionFrame_Update" }, {}, refresh)
end
