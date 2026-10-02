local _, addon_table = ...
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")

local surfaces = {}
local hook_declarations = {}
local hook_order = {}

local function hook_snapshot(state)
    return {
        id = state.id,
        surface = state.surface,
        kind = state.kind,
        target = state.target,
        method = state.method,
        blizzardAddon = state.blizzardAddon,
        required = state.required,
        fallbackEvent = state.fallbackEvent,
        verifiedBuild = state.verifiedBuild,
        available = state.available == true,
        installed = state.installed == true,
        observed = state.observed == true,
        observedCalls = state.observedCalls or 0,
        lastError = state.lastError,
    }
end

local function publish_hook_state(state)
    local auto_scan = addon_table.use("auto_scan")
    if type(auto_scan.diagnostics_enabled) == "function"
        and not auto_scan.diagnostics_enabled() then return end
    local changed = state._published ~= true
        or state._publishedAvailable ~= state.available
        or state._publishedInstalled ~= state.installed
        or state._publishedObserved ~= state.observed
        or state._publishedError ~= state.lastError
    if not changed then return end
    if type(auto_scan.record_hook_status) == "function" then
        auto_scan.record_hook_status(hook_snapshot(state))
        state._published = true
        state._publishedAvailable = state.available
        state._publishedInstalled = state.installed
        state._publishedObserved = state.observed
        state._publishedError = state.lastError
    end
end

local function addon_loaded(name)
    if type(name) ~= "string" or name == "" then return true end
    local addons = _G.C_AddOns
    if addons and type(addons.IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(addons.IsAddOnLoaded, name)
        if ok then return loaded == true end
    end
    if type(_G.IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(_G.IsAddOnLoaded, name)
        if ok then return loaded == true end
    end
    return false
end

local function hook_target_available(state)
    if state.kind == "global" then
        return type(_G[state.target]) == "function"
    end
    if state.kind == "mixin" or state.kind == "frame" then
        local target = _G[state.target]
        local target_type = type(target)
        if target_type ~= "table" and target_type ~= "userdata" then return false end
        local ok, method = pcall(function () return target[state.method] end)
        return ok and type(method) == "function"
    end
    return false
end

registry.declare_hook = function (definition)
    if type(definition) ~= "table" or type(definition.id) ~= "string"
        or definition.id == "" or type(definition.surface) ~= "string"
        or type(definition.target) ~= "string"
        or (definition.kind ~= "global" and definition.kind ~= "mixin"
            and definition.kind ~= "frame")
        or ((definition.kind == "mixin" or definition.kind == "frame")
            and type(definition.method) ~= "string")
        or type(definition.callback) ~= "function" then
        return nil, "INVALID_DECLARATION"
    end
    local existing = hook_declarations[definition.id]
    if existing then
        if existing.kind ~= definition.kind or existing.target ~= definition.target
            or existing.method ~= definition.method
            or existing.surface ~= definition.surface then
            existing.lastError = "DECLARATION_CONFLICT"
            publish_hook_state(existing)
            return nil, existing.lastError
        end
        registry.install_hook(definition.id)
        return hook_snapshot(existing)
    end
    local state = {
        id = definition.id,
        surface = definition.surface,
        kind = definition.kind,
        target = definition.target,
        method = definition.method,
        blizzardAddon = definition.blizzardAddon,
        required = definition.required ~= false,
        fallbackEvent = definition.fallbackEvent,
        verifiedBuild = definition.verifiedBuild,
        callback = definition.callback,
        available = false,
        installed = false,
        observed = false,
        observedCalls = 0,
    }
    hook_declarations[state.id] = state
    hook_order[#hook_order + 1] = state.id
    registry.install_hook(state.id)
    return hook_snapshot(state)
end

registry.install_hook = function (id)
    local state = hook_declarations[id]
    if not state then return false, "UNDECLARED_HOOK" end
    state.available = hook_target_available(state)
    if state.installed then
        publish_hook_state(state)
        return true
    end
    if not state.available then
        if state.blizzardAddon and not addon_loaded(state.blizzardAddon) then
            state.lastError = "ADDON_NOT_LOADED"
        else
            state.lastError = "TARGET_UNAVAILABLE"
        end
        publish_hook_state(state)
        return false, state.lastError
    end

    local hook_module = addon_table.use("translation_hooks")
    if type(hook_module.bind) ~= "function" then
        state.lastError = "HOOKS_UNAVAILABLE"
        publish_hook_state(state)
        return false, state.lastError
    end
    local hooks = hook_module.bind("manifest")
    local function observed_callback(...)
        state.observed = true
        state.observedCalls = (state.observedCalls or 0) + 1
        publish_hook_state(state)
        return state.callback(...)
    end
    local installed
    if state.kind == "global" then
        installed = hooks.global(state.target, observed_callback)
    elseif state.kind == "frame" then
        installed = hooks.region(_G[state.target], state.method,
            observed_callback)
    else
        installed = hooks.mixin(state.target, state.method, observed_callback)
    end
    if not installed then
        state.lastError = "INSTALL_FAILED"
        publish_hook_state(state)
        return false, state.lastError
    end
    state.installed = true
    state.lastError = nil
    publish_hook_state(state)
    return true
end

registry.install_hooks = function (loaded_addon)
    local installed = 0
    for _, id in ipairs(hook_order) do
        local state = hook_declarations[id]
        -- Declarations without a known addon owner are retried on every
        -- ADDON_LOADED. This preserves late-load support without guessing a
        -- Blizzard addon name that current compatibility evidence does not
        -- prove.
        if not loaded_addon or not state.blizzardAddon
            or state.blizzardAddon == loaded_addon then
            local ok = registry.install_hook(id)
            if ok then installed = installed + 1 end
        end
    end
    return installed
end

registry.hook_state = function (id)
    local state = hook_declarations[id]
    return state and hook_snapshot(state) or nil
end

registry.each_hook = function (callback)
    if type(callback) ~= "function" then return end
    for _, id in ipairs(hook_order) do
        callback(hook_snapshot(hook_declarations[id]))
    end
end

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
            "SettingsCategoryListButtonMixin.UpdateStateInternal",
            "SettingsCheckboxWithButtonControlMixin.EvaluateState",
            "AutoLootDropdownControlMixin.UpdateLabel",
            "SettingsListMixin.Display", "SettingsPanel.OnShow",
            "SettingsPanel.SetCurrentCategory", "SettingsPanel.DisplayCategory",
            "SettingsPanel.SetOutputText" },
            slots = { "ui.title", "ui.category", "ui.category-header",
                "ui.search-category", "ui.section", "ui.label", "ui.value",
                "ui.action", "ui.tab", "ui.search-placeholder", "ui.status",
                "nameplate.selection", "graphics.base-tab", "graphics.raid-tab" } },
        ["edit-mode"] = { hooks = { "EditModeManagerFrame.OnShow",
            "EditModeAccountSettingsMixin.SetExpandedState",
            "EditModeManagerFrameMixin.UpdateDropdownOptions",
            "EditModeSystemSettingsDialogMixin.UpdateDialog",
            "EditModeLayoutDialogMixin.SetupControlsForMode",
            "EditModeImportLayoutDialogMixin.SetupControlsForMode",
            "EditModeUnsavedChangesDialogMixin.ShowDialog",
            "EditModeSystemSelectionMixin.UpdateLabelVisibility",
            "EditModeSystemSelectionDoubleLabelMixin.UpdateLabelVisibility",
            "HelpTipTemplateMixin.ApplyText" },
            slots = { "ui.title", "ui.label", "ui.action", "ui.description",
                "ui.value" } },
        ["level-up"] = { hooks = {
            "EventToastManagerFrameMixin.DisplayToast",
            "EventToastManagerSideDisplayMixin.DisplayToastAtIndex" },
            slots = { "ui.title", "ui.subtitle", "ui.description",
                "ui.instruction" } },
        mail = { hooks = { "InboxMixin.Update", "MAIL_INBOX_UPDATE" },
            slots = { "ui.title", "ui.action", "ui.text" } },
        lfg = { hooks = { "LFGListEntryCreationActivityFinder_InitButton",
            "LFGListEntryCreation_SetEditMode", "LFGListEntryCreation_Select" },
            slots = { "activity.name", "entry.label" } },
        ["quest-gossip"] = { hooks = { "QUEST_DETAIL", "QUEST_PROGRESS",
            "QUEST_COMPLETE", "GOSSIP_SHOW", "QUEST_LOG_UPDATE",
            "QuestObjectiveTracker.UpdateSingle",
            "QuestObjectiveTrackerMixin.OnBlockHeaderClick",
            "WorldMapBountyBoardMixin.RefreshSelectedBounty",
            "StaticPopup_Show(quest confirmation)",
            "QuestInfo_Display", "QuestMapFrame_UpdateQuestDetailsButtons",
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
            "CharacterFrame.UpdateTitle", "ScrollBox.OnInitializedFrame",
            "CharacterStatRow.Label.SetText", "CharacterStatRow.Value.SetText",
            "CharacterFrameSidePane.LayoutRows", "PVPRankFrame.Update",
            "PaperDollFrame_SetSidebar" }, slots = { "ui.text", "character.level_class" } },
        skills = { hooks = { "SpellBookItemMixin.Init" },
            slots = { "skill.name", "spell.description", "item.name" } },
        professions = { hooks = { "ProfessionsMixin.Refresh",
            "ProfessionsCraftingPageMixin.Refresh",
            "ProfessionsRecipeListCategoryMixin.Init",
            "ProfessionsRecipeListRecipeMixin.Init",
            "ProfessionsReagentSlotMixin.Update" },
            slots = { "skill.name", "spell.description", "item.name",
                "ui.text" } },
        trainer = { hooks = { "TRAINER_SHOW", "TRAINER_UPDATE",
            "ClassTrainerFrame_Update" },
            slots = { "npc.name", "spell.name", "skill.name", "ui.text" } },
        items = { hooks = { "MerchantFrame_UpdateMerchantInfo",
            "MerchantFrame_UpdateBuybackInfo", "QuestInfo_ShowRewards",
            "QuestInfoRewardItem.Name.SetText", "ShowUIPanel",
            "LootFrameMixin.Open", "LootFrameElementMixin.Init",
            "LOOT_OPENED", "LOOT_SLOT_CHANGED",
            "ContainerFrameCombinedBags.OnShow",
            "ContainerFrameMixin.UpdateName",
            "ContainerFrameCombinedBagsMixin.UpdateName" },
            slots = { "item.name", "ui.text" } },
    }
    local groups = {
        { "game-menu", { "GameMenuFrame" }, "none" },
        { "settings", { "SettingsPanel" }, "none" },
        { "edit-mode", { "EditModeManagerFrame", "EditModeLayoutDialog",
            "EditModeImportLayoutDialog", "EditModeImportLayoutLinkDialog",
            "EditModeUnsavedChangesDialog", "EditModeSystemSettingsDialog" }, "none" },
        { "level-up", { "EventToastManagerFrame",
            "EventToastManagerSideDisplay" }, "none" },
        { "mail", { "MailFrame" }, "none" },
        { "lfg", { "GroupFinderFrame", "LFGListFrame" }, "none" },
        { "quest-gossip", { "QuestFrame", "GossipFrame", "WorldMapFrame", "ObjectiveTrackerFrame" }, "quest" },
        { "character", { "CharacterFrame", "ReputationFrame", "PVPUIFrame", "PVPRankFrame",
            "TokenFrame", "TokenDetailFrame", "StatisticsFrame", "GearManagerPopupFrame" }, "none" },
        { "skills", { "PlayerSpellsFrame", "SkillsFrame" }, "skill" },
        { "professions", { "ProfessionsFrame", "ProfessionsBookFrame" }, "skill" },
        { "trainer", { "ClassTrainerFrame" }, "skill" },
        { "items", { "MerchantFrame", "BankFrame", "ContainerFrameCombinedBags", "LootFrame" }, "item" },
        { "social", { "FriendsFrame", "GuildFrame", "CommunitiesFrame", "GuildInviteFrame" }, "none" },
        { "collections", { "CollectionsJournal", "WardrobeCollectionFrame",
            "EncounterJournal", "AchievementFrame" }, "none" },
        { "misc", { "MacroFrame", "AddonList", "AuctionHouseFrame", "CalendarFrame", "InspectFrame", "HelpFrame", "DressUpFrame", "ItemTextFrame", "TaxiFrame" }, "none" },
    }
    for _, group in ipairs(groups) do
        local roots = group[2]
        local meta = metadata[group[1]] or {}
        registry.register_surface({
            id = group[1], roots = roots, name_category = group[3],
            domains = { "ui", "context" },
            protected = group[1] == "game-menu" or group[1] == "skills"
                or group[1] == "professions",
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
        slots = { "npc.name", "npc.subtitle", "item.name", "item.description",
            "item.effect", "item.line", "item.right", "quest.name",
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
        domains = { "npc", "spell", "ui" },
        slots = { "npc.name", "player.identity", "spell.name",
            "spell.description", "generic.left", "generic.right" },
        dynamic_hooks = { "PLAYER_TARGET_CHANGED", "CompactUnitFrame_UpdateName",
            "GameTooltip.SetUnit", "GameTooltip.ShowAuraTooltip" },
        protected = true, clear_on_reuse = true })
    registry.register_surface({ id = "chat-bubble", roots = {},
        domains = { "npc", "chat" }, slots = { "chat.text" },
        dynamic_hooks = { "CHAT_MSG_MONSTER_SAY", "CHAT_MSG_MONSTER_YELL" },
        clear_on_reuse = true })
    registry.register_surface({ id = "achievement-alert", roots = {},
        domains = { "ui" }, slots = { "achievement.name", "ui.title" },
        dynamic_hooks = { "AchievementAlertFrame_SetUp" },
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
    local generation = runtime.begin_generation(surface, surface.generation + 1)
    surface.generation = generation
    scheduler.request({ id=id, surface=surface, instance="refresh",
        generation=generation, callback=function ()
            surface.refresh_pending = false
            if type(surface.is_open) == "function" and not surface.is_open() then
                return
            end
            if surface.static then surface.static(surface) end
            if surface.dynamic then surface.dynamic(surface) end
        end })
end

registry.refresh_open = function ()
    registry.each(function (surface)
        if type(surface.is_open) == "function" and surface.is_open() then
            registry.refresh(surface.id)
        end
    end)
end
