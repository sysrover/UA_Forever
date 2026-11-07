local _, addon_table = ...
local stable = addon_table.use("stable_ui")
local ui = addon_table.use("panel_ui_adapter").bind("stable-ui")
ui.verified_build = "1.60.1.70840"
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")

local function selected_pet(frame)
    if not frame or not _G.C_StableInfo or type(C_StableInfo.GetStablePetInfo) ~= "function" then return end
    local index = frame.selectedPet
    if runtime.is_secret_value(index) or type(index) ~= "number" then return end
    local ok, info = pcall(C_StableInfo.GetStablePetInfo, index)
    if not ok or type(info) ~= "table" then return end
    local name = runtime.safe_string_or_nil(info.name)
    local family = runtime.safe_string_or_nil(info.familyName)
    local level = info.level
    if name and family and not runtime.is_secret_value(level) and type(level) == "number" then
        local template = resolver.find_ui(_G.UNIT_LEVEL_TEMPLATE)
        local translated_family = resolver.find_ui(family) or family
        if template then
            local formatted, text = pcall(string.format, template, level)
            if formatted then
                -- Keep the hunter's chosen name exactly as supplied by the API.
                text = (name ~= family and name .. " " or "") .. text .. " " .. translated_family
                ui.apply(_G.PetStableLevelText, text)
            end
        end
    end
    local loyalty = runtime.safe_string_or_nil(info.loyaltyName)
    local rank = info.loyaltyLevel
    if loyalty and not runtime.is_secret_value(rank) and type(rank) == "number" then
        ui.formatted(_G.PetStableLoyaltyText, _G.PET_LOYALTY_TEMPLATE,
            resolver.find_ui(loyalty) or loyalty, rank)
    end
end

local function refresh()
    local frame = _G.PetStableFrame
    if not frame then return end
    ui.regions(frame)
    for _, name in ipairs({ "PetStableSlotText", "PetStableCostLabel" }) do ui.watch(_G[name]) end
    ui.watch(_G.PetStableCurrentPet and PetStableCurrentPet.Text)
    ui.watch(_G.PetStableStabledPet1 and PetStableStabledPet1.Text)
    ui.watch(frame.GamepadSlotCostText)
    ui.button(frame.purchaseButton)
    if type(frame.GetTitleText) == "function" then ui.watch(frame:GetTitleText()) end
    ui.hooks.region(frame, "SelectPet", selected_pet)
    selected_pet(frame)
end

stable.prepare = function ()
    ui.prepare({ "PetStableFrame" }, "Blizzard_StableUI", {},
        { { "PetStableFrame", "OnShow" }, { "PetStableFrame", "Update" } }, refresh)
end
