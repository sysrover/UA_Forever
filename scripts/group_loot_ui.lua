local _, addon_table = ...
local panel = addon_table.use("group_loot_ui")
local ui = addon_table.use("panel_ui_adapter").bind("group-loot")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
ui.verified_build = "1.60.1.70862"

local function item_name(row)
    if not row or not runtime.can_write_text(row) then return end
    local roll_id = row.rollID
    if runtime.is_secret_value(roll_id) or type(roll_id) ~= "number"
        or type(_G.GetLootRollItemLink) ~= "function" then
        runtime.invalidate(row.Name)
        return
    end
    -- A native rewrite can arrive while a card is being reused. Resolve the
    -- current roll's source before claiming its label for an item ID.
    local source = ui.text(row.Name)
    local claim = row.Name and runtime.get(row.Name)
    if claim and source == claim.translated then source = claim.source end
    if type(_G.GetLootRollItemInfo) ~= "function" then return end
    local info_ok, _, name = pcall(GetLootRollItemInfo, roll_id)
    name = info_ok and runtime.safe_string_or_nil(name) or nil
    if not name or source ~= name then runtime.invalidate(row.Name); return end
    local ok, link = pcall(GetLootRollItemLink, roll_id)
    ui.item(row.Name, ok and runtime.safe_string_or_nil(link) or nil)
end

local function prepare_roll(row)
    if not row or not runtime.can_write_text(row) then return end
    ui.watch(row.Name, function () item_name(row) end)
    ui.hooks.region_script(row, "OnHide", function () runtime.invalidate(row.Name) end)
end

local function refresh()
    for index = 1, 4 do prepare_roll(_G["GroupLootFrame" .. index]) end
    local gamepad = _G.GamepadGroupLootRollFrame
    if gamepad and runtime.can_write_text(gamepad) then
        ui.watch(gamepad.TitleContainer and gamepad.TitleContainer.TitleText)
        local box = gamepad.ScrollBox
        if box and type(box.ForEachFrame) == "function" then
            pcall(box.ForEachFrame, box, prepare_roll)
        end
    end
    local assign = _G.MasterLooterFrame
    if assign and runtime.can_write_text(assign) then
        ui.watch(assign.TitleContainer and assign.TitleContainer.TitleText)
    end
end

panel.prepare = function ()
    ui.prepare({ "GroupLootFrame1", "GroupLootFrame2", "GroupLootFrame3", "GroupLootFrame4",
        "GamepadGroupLootRollFrame", "MasterLooterFrame" }, "Blizzard_UIPanels_Game", {}, {
        { "GamepadGroupLootRollFrame", "InitRegions" },
        { "GamepadGroupLootRollFrame", "DoFullRefresh" },
    }, refresh)
    -- Both keyboard cards and pooled gamepad rows call this writer after
    -- assigning rollID. A tooltip hook alone cannot translate the card name.
    registry.declare_hook({ id = "group-loot:item-display", surface = ui.surface.id,
        kind = "global", target = "GroupLootFrame_SetupItemDisplay", callback = prepare_roll,
        blizzardAddon = "Blizzard_UIPanels_Game", verifiedBuild = ui.verified_build })
end
