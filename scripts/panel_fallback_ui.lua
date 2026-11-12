local _, addon_table = ...
local panels = addon_table.use("panel_fallback_ui")
local registry = addon_table.use("translation_registry")
local walker = addon_table.use("translation_walker")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local services = {}

-- Named windows found in the 70840 XML inventory without a dedicated owner.
-- This is a conditional compatibility route, not evidence that every expansion's
-- window is enabled in Camelot. Never walk UIParent, HUD managers or debug tools.
local groups = {
    { "character_ui", { "AccountStoreFrame", "AlliedRacesFrame", "ArchaeologyFrame",
        "ArtifactFrame", "AzeriteEssenceUI", "AzeriteRespecFrame", "ChromieTimeFrame",
        "CovenantPreviewFrame", "CovenantRenownFrame", "CovenantSanctumFrame",
        "DelvesCompanionAbilityListFrame", "DelvesCompanionConfigurationFrame",
        "DelvesDifficultyPickerFrame", "ExpansionLandingPage", "IslandsQueueFrame",
        "OrderHallTalentFrame", "PerksProgramFrame", "RemixArtifactFrame", "SoulbindViewer",
        "TorghastLevelPickerFrame", "TransmogFrame", "WeeklyRewardsFrame",
        "BarberShopFrame", "ModelPreviewFrame", "SideDressUpFrame", "TransmogAndMountDressupFrame",
        "HousingDashboardFrame", "HouseFinderFrame", "HousingModelPreviewFrame" } },
    { "item_details", { "ItemInteractionFrame", "ItemSocketingFrame", "ItemUpgradeFrame",
        "ObliterumForgeFrame", "ScrappingMachineFrame", "RuneforgeFrame", "CurrencyTransferMenu" } },
    { "profession_ui", { "InspectRecipeFrame", "ProfessionsCustomerOrdersFrame" } },
    { "social_ui", { "CalendarCreateEventFrame", "CalendarViewEventFrame",
        "CalendarViewHolidayFrame", "CalendarViewRaidFrame", "CalendarEventPickerFrame",
        "RecruitAFriendRewardsFrame", "RecruitAFriendRecruitmentFrame" } },
    { "game_settings", { "AddonDialog", "ClickBindingFrame", "QuickKeybindFrame",
        "TimeManagerFrame", "StopwatchFrame", "ColorPickerFrame", "ReportFrame", "GuideFrame" } },
    { "lfg", { "PVEFrame", "QuickJoinRoleSelectionFrame", "ChallengesKeystoneFrame",
        "PVPMatchResults", "PVPMatchScoreboard", "PVPReadyDialog", "PetBattleQueueReadyFrame" } },
    { "merchant", { "BlackMarketFrame", "GarrisonCapacitiveDisplayFrame" } },
    { "popups", { "BasicMessageDialog", "ReadyCheckFrame", "DeathRecapFrame",
        "InstanceAbandonFrame", "DeclensionFrame", "SplashFrame", "NPE_TutorialMainFrame_Frame",
        "NPE_TutorialKeyboardMouseFrame_Frame", "NamePlatesTutorial", "PingSystemTutorial" } },
}

local function editable(frame)
    if strings.is_protected_frame(frame) then return true end
    if not frame or type(frame.GetObjectType) ~= "function" then return true end
    local ok, kind = pcall(frame.GetObjectType, frame)
    return not ok or runtime.is_secret_value(kind) or kind == "EditBox"
end

panels.prepare = function ()
    for _, group in ipairs(groups) do
        local section, roots = group[1], group[2]
        local service = services[section]
        if not service then
            local id = "panel-fallback-" .. section
            local ui = addon_table.use("panel_ui_adapter").bind(id)
            local function label(region)
                if not region or runtime.is_applying(region) then return end
                if type(region.GetDebugName) == "function" then
                    local name_ok, name = pcall(region.GetDebugName, region)
                    name = name_ok and runtime.safe_string_or_nil(name)
                    if not name then return end
                    for _, marker in ipairs({ "PlayerName", "MemberName", "FriendName", "Author",
                        "Recipient", "OwnerName", "EditBox" }) do
                        if name:find(marker, 1, true) then return end
                    end
                end
                local ok, kind = pcall(region.GetObjectType, region)
                if ok and not runtime.is_secret_value(kind) and kind == "FontString" then
                    strings.translate_region(region, nil, "ui.label", ui.surface, nil, nil, section)
                end
            end
            local function refresh()
                for _, root in ipairs(roots) do
                    local frame = _G[root]
                    if frame then
                        local owner = registry.find_frame(frame)
                        local ok, shown = pcall(frame.IsShown, frame)
                        if (not owner or owner == ui.surface) and ok
                            and not runtime.is_secret_value(shown) and shown == true then
                            walker.walk({ id = id, surface = id, owner = id,
                                reason = "BUILD_70840_PANEL_FALLBACK", max_nodes = 1000 }, frame,
                                function (region)
                                    local kind_ok, kind = pcall(region.GetObjectType, region)
                                    if kind_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
                                        ui.watch(region, label)
                                    end
                                end, editable, { frames = 0 })
                        end
                    end
                end
            end
            service = { ui = ui, refresh = refresh }
            services[section] = service
        end
        service.ui.prepare(roots, nil, {}, {}, service.refresh)
    end
end
