local _, addon_table = ...
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")

local surfaces = {}

registry.register_surface = function (definition)
    if not definition or type(definition.id) ~= "string" then return end
    local existing = surfaces[definition.id]
    if existing then return existing end
    definition.generation = 0
    surfaces[definition.id] = definition
    return definition
end

registry.get = function (id)
    return surfaces[id]
end

registry.find_frame = function (frame)
    if not frame then return nil end
    for _, surface in pairs(surfaces) do
        for _, root in ipairs(surface.roots or {}) do
            if _G[root] == frame then return surface end
        end
    end
end

registry.prepare_root_hooks = function ()
    local hook_module = addon_table.use("translation_hooks")
    if type(hook_module.bind) ~= "function" then return end
    local hooks = hook_module.bind("registry")
    registry.each(function (surface)
        if type(surface.static) ~= "function" then return end
        for _, name in ipairs(surface.roots or {}) do
            local frame = _G[name]
            hooks.region_script(frame, "OnShow", function ()
                registry.refresh(surface.id)
            end)
        end
    end)
end

registry.register_defaults = function (translate_frame)
    local metadata = {
        ["game-menu"] = { hooks = { "GameMenuFrame.InitButtons",
            "MainMenuBarMicroButtonMixin.EvaluateTooltipVisibility" }, slots = { "ui.text" } },
        settings = { hooks = { "SettingsListElementMixin.Init",
            "SettingsPanelMixin.DisplayCategory" }, slots = { "ui.text" } },
        lfg = { hooks = { "LFGListEntryCreationActivityFinder_InitButton",
            "LFGListEntryCreation_SetEditMode", "LFGListEntryCreation_Select" },
            slots = { "activity.name", "entry.label" } },
        ["quest-gossip"] = { hooks = { "QUEST_DETAIL", "QUEST_PROGRESS",
            "QUEST_COMPLETE", "GOSSIP_SHOW", "QUEST_LOG_UPDATE",
            "QuestObjectiveTracker.UpdateSingle",
            "QuestObjectiveTrackerMixin.OnBlockHeaderClick",
            "WorldMapBountyBoardMixin.RefreshSelectedBounty",
            "StaticPopup_Show(quest confirmation)",
            "QuestInfo_ShowTitle", "QuestInfo_ShowDescriptionText",
            "QuestInfo_ShowObjectivesText", "QuestInfo_ShowRewardText",
            "QuestInfo_ShowObjectives", "QuestFrameProgressPanel_OnShow",
            "QuestFrameGreetingPanel_OnShow",
            "QuestLogQuests_Update",
            "AutoQuestPopupBlockMixin.Update",
            "ObjectiveTrackerTopBannerFrame.PlayBanner",
            "AreaLabelDataProviderMixin.OnAdded",
            "AreaLabelFrameMixin.EvaluateLabels",
            "ZoneLabelDataProviderMixin.EvaluateBestAreaTrigger",
            "AdventureMap_ZoneSummaryProviderMixin.RefreshAllData",
            "WorldMapNavBarMixin.Refresh",
            "WorldMapCoordsPanelMixin.OnUpdate",
            "StoryHeaderMixin.ShowTooltip",
            "Menu.ModifyMenu(MENU_MINIMAP_BATTLEFIELD)",
            "Minimap_Update",
            "ZoneText_OnEvent", "SubZoneText_OnLoad",
            "ScenarioObjectiveTrackerMixin.LayoutContents",
            "UIWidgetObjectiveTrackerMixin.OnEvent",
            "UIWidgetObjectiveTrackerMixin.LayoutContents",
            "QueueStatusEntry_SetUpActiveWorldPVP",
            "QueueStatusButtonMixin.ShowContextMenu",
            "GossipGreetingTextMixin.Setup", "GossipOptionButtonMixin.Setup",
            "GossipFrameSharedMixin.SetGossipTitle",
            "GossipSharedAvailableQuestButtonMixin.Setup",
            "GossipSharedActiveQuestButtonMixin.Setup" },
            slots = { "quest.name", "quest.description", "npc.name",
                "gossip.poi", "zone.name" } },
        character = { hooks = { "CharacterFrame.ShowSubFrame",
            "CharacterFrame.RefreshDisplay" }, slots = { "ui.text" } },
        skills = { hooks = { "SpellBookItemMixin", "ProfessionsCraftingRow.Init",
            "ProfessionsReagentSlot.Update" },
            slots = { "skill.name", "spell.description", "item.name" } },
        trainer = { hooks = { "TRAINER_SHOW", "TRAINER_UPDATE",
            "ClassTrainerFrame_Update" },
            slots = { "npc.name", "spell.name", "skill.name", "ui.text" } },
        items = { hooks = { "MerchantFrame_UpdateMerchantInfo",
            "MerchantFrame_UpdateBuybackInfo", "QuestInfo_ShowRewards",
            "QuestInfoRewardItem.Name.SetText", "ShowUIPanel",
            "LootFrame_Update", "LOOT_OPENED", "LOOT_SLOT_CHANGED",
            "ContainerFrameCombinedBags.OnShow",
            "ContainerFrameMixin.UpdateName",
            "ContainerFrameCombinedBagsMixin.UpdateName" },
            slots = { "item.name", "ui.text" } },
    }
    local groups = {
        { "game-menu", { "GameMenuFrame" }, "none" },
        { "settings", { "SettingsPanel" }, "none" },
        { "lfg", { "GroupFinderFrame", "LFGListFrame" }, "none" },
        { "quest-gossip", { "QuestFrame", "GossipFrame", "WorldMapFrame", "ObjectiveTrackerFrame" }, "quest" },
        { "character", { "CharacterFrame", "ReputationFrame", "PVPUIFrame", "PVPRankFrame" }, "none" },
        { "skills", { "PlayerSpellsFrame", "ProfessionsFrame", "ProfessionsBookFrame", "SkillsFrame", "TradeSkillFrame", "CraftFrame" }, "skill" },
        { "trainer", { "ClassTrainerFrame" }, "skill" },
        { "items", { "MerchantFrame", "BankFrame", "ContainerFrameCombinedBags", "LootFrame" }, "item" },
        { "social", { "FriendsFrame", "GuildFrame", "CommunitiesFrame", "GuildInviteFrame" }, "none" },
        { "collections", { "CollectionsJournal", "EncounterJournal", "AchievementFrame" }, "none" },
        { "misc", { "MacroFrame", "AddonList", "AuctionHouseFrame", "CalendarFrame", "InspectFrame", "HelpFrame", "DressUpFrame", "ItemTextFrame" }, "none" },
    }
    for _, group in ipairs(groups) do
        local roots = group[2]
        local meta = metadata[group[1]] or {}
        registry.register_surface({
            id = group[1], roots = roots, name_category = group[3],
            domains = { "ui", "context" },
            protected = group[1] == "game-menu" or group[1] == "skills",
            static_hooks = { "OnShow", "ShowUIPanel" },
            dynamic_hooks = meta.hooks or { "PanelTemplates_SetTab" },
            slots = meta.slots or { "ui.text" },
            clear_on_reuse = true,
            static = function (surface)
                for _, name in ipairs(roots) do
                    local frame = _G[name]
                    if frame and frame.IsShown then
                        local ok, shown = pcall(frame.IsShown, frame)
                        if ok and shown then
                            translate_frame(frame, surface)
                        end
                    end
                end
            end,
            is_open = function ()
                for _, name in ipairs(roots) do
                    local frame = _G[name]
                    if frame and frame.IsShown then
                        local ok, shown = pcall(frame.IsShown, frame)
                        if ok and shown then return true end
                    end
                end
                return false
            end,
        })
    end
    registry.register_surface({
        id = "tooltip", roots = { "GameTooltip", "ItemRefTooltip",
            "ShoppingTooltip1", "ShoppingTooltip2", "EmbeddedItemTooltip",
            "BuffFrameTooltip" },
        domains = { "npc", "item", "quest", "spell", "zone", "ui" },
        slots = { "npc.name", "npc.subtitle", "item.name", "item.use", "quest.name",
            "spell.name", "skill.name", "zone.name", "spell.description",
            "generic.left", "generic.right" },
        dynamic_hooks = { "TooltipDataProcessor.AddTooltipPostCall",
            "GameTooltip_AddQuest", "QuestMapLogTitleButton_OnEnter",
            "QuestPinMixin.OnMouseEnter",
            "QuestBlobPinMixin.UpdateTooltip",
            "WorldMapBountyBoardMixin.ShowBountyTooltip",
            "WorldMapBountyBoardMixin.ShowLockedByQuestTooltip", "OnTooltipCleared",
            "FlightMap_ZoneSummaryDataProvider.CheckMouse",
            "Minimap_SetTooltip",
            "TaxiNodeOnButtonEnter",
            "ContainerFramePortraitButtonMixin.OnEnter",
            "CommunitiesGuildNewsButton_OnEnter",
            "AdventureMap_ZoneSummaryPinMixin.OnMouseEnter",
            "RecruitActivityButtonMixin.OnEnter",
            "CallingPOI_OnEnter",
            "CovenantCallingQuestMixin.UpdateTooltipQuestActive",
            "TalentFrameBaseMixin.AddConditionsToTooltip",
            "MODIFIER_STATE_CHANGED" },
        protected = true, clear_on_reuse = true,
    })
    registry.register_surface({ id = "npc-world", roots = { "TargetFrame" },
        unit_roots = { "target", "nameplate%d+" }, name_category = "none",
        domains = { "npc" }, slots = { "npc.name" },
        dynamic_hooks = { "PLAYER_TARGET_CHANGED", "CompactUnitFrame_UpdateName" },
        protected = true, clear_on_reuse = true })
    registry.register_surface({ id = "chat-bubble", roots = {},
        domains = { "npc", "chat" }, slots = { "chat.text" },
        dynamic_hooks = { "CHAT_MSG_MONSTER_SAY", "CHAT_MSG_MONSTER_YELL" },
        clear_on_reuse = true })
end

registry.each = function (callback)
    for _, surface in pairs(surfaces) do callback(surface) end
end

registry.refresh = function (id, phase)
    local surface = surfaces[id]
    if not surface then return end
    if phase == "dynamic" then
        local callback = surface.dynamic
        if callback then callback(surface) end
        return
    end
    if surface.refresh_pending then return end
    surface.refresh_pending = true
    surface.generation = surface.generation + 1
    runtime.next_generation(surface)
    local generation = surface.generation
    scheduler.request(id, generation, function ()
        surface.refresh_pending = false
        if type(surface.is_open) == "function" and not surface.is_open() then
            return
        end
        if surface.static then surface.static(surface) end
        if surface.dynamic then surface.dynamic(surface) end
    end)
end

registry.refresh_open = function ()
    registry.each(function (surface)
        if type(surface.is_open) == "function" and surface.is_open() then
            registry.refresh(surface.id)
        end
    end)
end
