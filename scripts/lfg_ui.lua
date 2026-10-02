local _, addon_table = ...

local lfg_ui = addon_table.use("lfg_ui")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").menus
local entries = addon_table.use("entries")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
local translation = addon_table.use("translation")
local utils = addon_table.use("utils")
local walker = addon_table.use("translation_walker")
local hooks = addon_table.use("translation_hooks").bind("lfg_ui")

local function translate_lfg_frame(frame)
    local root = _G.LFGListFrame
    local entry = root and root.EntryCreation or frame
    if not entry then return end
    local surface = registry.get("lfg")
    if surface and runtime.generation(surface) == 0 then
        runtime.begin_generation(surface, "entry-creation")
    end
    local function translate_static(region)
        if region then strings.translate_region(region, nil, nil, surface, "static") end
    end
    translate_static(entry.Label)
    translate_static(entry.Name and entry.Name.Instructions)
    translate_static(entry.ItemLevel and entry.ItemLevel.EditBox
        and entry.ItemLevel.EditBox.Instructions)
    translate_static(entry.CrossFactionGroup and entry.CrossFactionGroup.Label)
    local button = entry.ListGroupButton
    if button and type(button.GetFontString) == "function" then
        local ok, region = pcall(button.GetFontString, button)
        if ok then translate_static(region) end
    end
    -- Edit mode replaces this placeholder with a quest-specific description.
    -- Keep it dynamic so the quest owner can claim the reused region.
    strings.translate_region(entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions, nil, nil, surface, "dynamic",
        "entry-description")
end

local function translate_lfg_activity_button(button)
    if not button then return end
    if type(button.GetFontString) == "function" then
        local ok, font_string = pcall(button.GetFontString, button)
        if ok and font_string and font_string.GetText then
            local text_ok, source = pcall(font_string.GetText, font_string)
            if text_ok and type(source) == "string" then
                runtime.invalidate(font_string)
                local translated, _, kind, _, _, option =
                    resolver.find_ui(source, font_string)
                if translated then
                    local id_ok, activity_id = pcall(function ()
                        return button.activityID or (button.info and button.info.activityID)
                    end)
                    local secret = false
                    if type(_G.issecretvalue) == "function" then
                        local secret_ok, value = pcall(_G.issecretvalue, activity_id)
                        secret = not secret_ok or value
                    end
                    local slot = id_ok and not secret and type(activity_id) == "number"
                        and "activity:" .. activity_id or "activity.name"
                    local instance = id_ok and not secret and activity_id or source
                    local generation = runtime.begin_generation(font_string, instance)
                    runtime.apply(font_string, { owner = "lfg", slot = slot,
                        source = source, translated = translated,
                        option = option,
                        surface = font_string, generation = generation,
                        instance = instance, phase = "dynamic",
                        priority = kind == "domain" and runtime.PRIORITY.DOMAIN
                            or runtime.PRIORITY.CONTEXT })
                end
            end
        end
    end
end

-- Vanilla-style Group Finder in 1.60.1.70170 has separate roots and native
-- writers. Bind completed display regions, including hidden controls; never
-- walk player names, guilds, comments or the contents of editable fields.
local function lfg_name(source)
    local translated = entries.get_glossary_text(source, source, "zone")
    if translated ~= source then return translated end
    return resolver.find_ui(source) or source
end

local function translate_lfg_display(region, category)
    if not region or runtime.is_applying(region)
        or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string"
        or source == "" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = surface_text.lfg_text(source, lfg_name)
    if category == "npc" then
        translated = entries.lookup_name("npc", source) or translated
    end
    if translated and translated ~= source then
        runtime.apply(region, {
            owner = "lfg", slot = category == "zone" and "activity.name" or "ui.text",
            source = source, translated = translated,
            option = category == "zone" and "translate_zone"
                or category == "npc" and "translate_npc" or "translate_string",
            category = category,
            priority = category == "npc" and runtime.PRIORITY.DOMAIN
                or runtime.PRIORITY.CONTEXT, reapply_cached = true,
        })
    else
        strings.translate_region(region, category, nil, registry.get("lfg"))
    end
end

local function bind_lfg_display(region, category)
    if not region then return end
    hooks.region(region, "SetText", function (self)
        translate_lfg_display(self, category)
    end)
    translate_lfg_display(region, category)
end

local function bind_lfg_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, label = pcall(button.GetFontString, button)
    if ok then bind_lfg_display(label) end
end

local function initialize_lfg_activity_menu_button(button)
    local label = button and button.fontString
    if not label or not runtime.can_write_text(label) then return end
    translate_lfg_display(label, "zone")
    -- The native initializer sizes the label before localization. The menu
    -- measures its compositor after our initializer, including checkbox/arrow.
    local width = layout.safe_dimension(label, "GetUnboundedStringWidth")
        or layout.safe_dimension(label, "GetStringWidth")
    if width and type(label.SetWidth) == "function" then
        pcall(label.SetWidth, label, math.ceil(width))
    end
end

local function prepare_lfg_activity_menu()
    local menu_api, menu_util = _G.Menu, _G.MenuUtil
    if not menu_api or type(menu_api.ModifyMenu) ~= "function"
        or not menu_util or type(menu_util.TraverseMenu) ~= "function" then return end
    hooks.once("MENU_LFG_BROWSE_ACTIVITY", function ()
        return pcall(menu_api.ModifyMenu, "MENU_LFG_BROWSE_ACTIVITY",
            function (_, root_description)
                menu_util.TraverseMenu(root_description, function (description)
                    description:AddInitializer(initialize_lfg_activity_menu_button)
                end)
            end)
    end)
end

local function translate_lfg_vanilla_listing()
    local frame = _G.LFGListingFrame
    if not frame then return end
    bind_lfg_display(frame.TitleContainer and frame.TitleContainer.TitleText)
    bind_lfg_button(frame.BackButton)
    bind_lfg_button(frame.PostButton)
    local roles = frame.GroupRoleButtons
    bind_lfg_button(roles and roles.RolePollButton)
    bind_lfg_display(roles and roles.RoleDropdown and roles.RoleDropdown.Text)
    local view = frame.ActivityView
    bind_lfg_display(view and view.LevelRangesCheckbox and view.LevelRangesCheckbox.Text)
    bind_lfg_display(view and view.PlayStyleDropdown and view.PlayStyleDropdown.Text)
    bind_lfg_display(view and view.Comment and view.Comment.EditBox
        and view.Comment.EditBox.Instructions)
    local locked = frame.LockedView
    bind_lfg_display(locked and locked.ErrorText)
    bind_lfg_display(locked and locked.ActivityText)
end

local function translate_lfg_vanilla_categories(view)
    view = view or _G.LFGListingFrameCategoryView
    if not view or type(view.CategoryButtons) ~= "table" then return end
    for _, button in ipairs(view.CategoryButtons) do bind_lfg_button(button) end
end

local function translate_lfg_vanilla_activity(row)
    if not row then return end
    bind_lfg_display(row.NameButton and row.NameButton.Name, "zone")
    bind_lfg_display(row.Level)
end

local function translate_lfg_vanilla_result(row)
    if not row then return end
    bind_lfg_display(row.CategoryLabel)
    bind_lfg_display(row.ActivityName, "zone")
    bind_lfg_display(row.Level)
    bind_lfg_display(row.PlaystyleLabel)
    local data = row.DataDisplay
    bind_lfg_display(data and data.Solo and data.Solo.RolesText)
end

local function translate_lfg_queue_entry(entry, category)
    if not entry then return end
    -- QueueStatusFrame is a separate pooled tooltip, not GameTooltip. Its
    -- title is user-authored; status and subtitle are completed native UI.
    -- Do not bind SetText here: the pool also serves unrelated queue types.
    translate_lfg_display(entry.Status)
    translate_lfg_display(entry.SubTitle, category)
end

local function translate_lfg_vanilla_who_row(row)
    if not row then return end
    bind_lfg_display(row.Level)
    bind_lfg_display(row.Race)
    bind_lfg_display(row.Class)
    if row.Variable then runtime.invalidate(row.Variable) end
    -- Variable is selected by whoSortValue: area, guild or race.
    if _G.whoSortValue == 1 then translate_lfg_display(row.Variable, "zone") end
    if _G.whoSortValue == 3 then translate_lfg_display(row.Variable) end
end

local function translate_lfg_vanilla_tooltip(frame)
    if not frame then return end
    for _, key in ipairs({ "Delisted", "NewPlayerFriendlyText",
        "CompletedEncounterHeader", "MemberCount" }) do
        bind_lfg_display(frame[key])
    end
    bind_lfg_display(frame.Leader and frame.Leader.Level)
    if frame.memberPool and type(frame.memberPool.EnumerateActive) == "function" then
        for member in frame.memberPool:EnumerateActive() do bind_lfg_display(member.Level) end
    end
    if frame.activityPool and type(frame.activityPool.EnumerateActive) == "function" then
        for label in frame.activityPool:EnumerateActive() do bind_lfg_display(label, "zone") end
    end
    if frame.completedEncounterPool
        and type(frame.completedEncounterPool.EnumerateActive) == "function" then
        for label in frame.completedEncounterPool:EnumerateActive() do
            bind_lfg_display(label, "npc")
        end
    end
    if type(layout.fit_lfg_tooltip) == "function" then layout.fit_lfg_tooltip(frame) end
end

local lfg_scroll_boxes = setmetatable({}, { __mode = "k" })

local function translate_lfg_vanilla()
    local parent = _G.LFGParentFrame
    if parent then
        for index = 1, 3 do
            local tab = parent["Tab" .. index]
            bind_lfg_button(tab)
            if tab and type(_G.PanelTemplates_TabResize) == "function" then
                pcall(_G.PanelTemplates_TabResize, tab, 0)
            end
        end
    end
    translate_lfg_vanilla_listing()
    translate_lfg_vanilla_categories()
    local browse = _G.LFGBrowseFrame
    if browse then
        bind_lfg_display(browse.TitleContainer and browse.TitleContainer.TitleText)
        bind_lfg_display(browse.CategoryDropdown and browse.CategoryDropdown.Text)
        bind_lfg_display(browse.ActivityDropdown and browse.ActivityDropdown.Text, "zone")
        bind_lfg_display(browse.NoResultsFound)
        bind_lfg_display(browse.SearchingSpinner and browse.SearchingSpinner.Label)
        bind_lfg_button(browse.SendMessageButton)
        bind_lfg_button(browse.GroupInviteButton)
    end
    local who = _G.LFGWhoListFrame
    if who then
        bind_lfg_display(who.TitleContainer and who.TitleContainer.TitleText)
        bind_lfg_display(who.EditBox and who.EditBox.Instructions)
        bind_lfg_display(who.FilterDropdown and who.FilterDropdown.Text)
        bind_lfg_display(who.WhoFrameTotals)
    end
end

local function translate_lfg_quest_description(entry)
    local region = entry and entry.Description and entry.Description.EditBox
        and entry.Description.EditBox.Instructions
    local info_getter = _G.C_LFGList and _G.C_LFGList.GetActiveEntryInfo
    if not region or type(info_getter) ~= "function" then return end
    local info_ok, info = pcall(info_getter)
    local id = info_ok and info and info.questID
    if type(id) ~= "number" then return end
    local title_getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or (_G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID)
    if type(title_getter) ~= "function" then return end
    local title_ok, english = pcall(title_getter, id)
    local quest = entries.get_entry("quest", id)
    local ukrainian = quest and quest[1]
    if not title_ok or type(english) ~= "string" or english == ""
        or type(ukrainian) ~= "string" or ukrainian == "" then return end
    local world_ok, is_world = pcall(_G.QuestUtils_IsQuestWorldQuest or function () return false end, id)
    if not world_ok then return end
    local format = is_world and _G.AUTO_GROUP_CREATION_WORLD_QUEST
        or _G.AUTO_GROUP_CREATION_NORMAL_QUEST
    if type(format) ~= "string" then return end
    local translated_format = resolver.find_ui(format)
    if type(translated_format) ~= "string" then return end
    local source_ok, source = pcall(string.format, format, english)
    ukrainian = utils.cap(ukrainian)
    local native_uk_ok, native_uk = pcall(string.format, format, ukrainian)
    local ua_ok, translated = pcall(string.format, translated_format, ukrainian)
    local mixed_ok, name_original = pcall(string.format, translated_format, english)
    if not source_ok or not native_uk_ok or not ua_ok or not mixed_ok then return end
    local text_ok, current = pcall(region.GetText, region)
    if not text_ok or (current ~= source and current ~= native_uk) then return end
    runtime.invalidate(region)
    runtime.apply(region, {
        owner = "lfg-quest", slot = "quest:" .. id .. ".description",
        source = source, translated = translated, name_original = name_original,
        category = "quest", option = "translate_quest",
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function translate_lfg_edit_mode(entry, edit_mode)
    if edit_mode then translate_lfg_quest_description(entry) end
    translate_lfg_frame(entry)
end

local function translate_lfg_legacy_filter(_, level)
    level = tonumber(level) or tonumber(_G.UIDROPDOWNMENU_MENU_LEVEL) or 1
    scheduler.request("legacy-dropdown-lfg-filter:" .. level, nil, function ()
        local frame = _G["DropDownList" .. level]
        if not frame then return end
        local owner = _G.UIDROPDOWNMENU_OPEN_MENU
        local name_ok, name = owner and pcall(owner.GetDebugName, owner)
        if name_ok and type(name) == "string"
            and name:find("LFGWhoListFrame.FilterDropdown", 1, true) then
            walker.walk({ id = "legacy-dropdown-lfg-filter",
                surface = "group-finder", owner = "menus",
                reason = "POOLED_MENU_DISCOVERY" }, frame, function (region)
                strings.translate_region(region)
            end, nil, { frames = 0 })
        end
    end)
end

lfg_ui.prepare = function ()
    local lfg = registry.get("lfg")
    if lfg then
        if not lfg.uaForeverStaticConfigured then
            local generic_static = lfg.static
            lfg.static = function (surface)
                translate_lfg_frame(_G.LFGListFrame)
                translate_lfg_vanilla()
                if generic_static and not _G.LFGParentFrame then generic_static(surface) end
            end
            lfg.uaForeverStaticConfigured = true
        end
        lfg.dynamic_hooks = {
            "LFGListEntryCreationActivityFinder_InitButton",
            "LFGListEntryCreation_SetEditMode", "LFGListEntryCreation_Select",
            "LFGParentFrame.UpdateTabs", "LFGListingFrame.UpdateFrameView",
            "LFGListingCategorySelection_UpdateCategoryButtons",
            "LFGListingActivityView_InitActivityButton",
            "LFGListingActivityView_InitActivityGroupButton",
            "LFGListingLockedView_SetLineContent", "LFGBrowseSearchEntry_Update",
            "LFGBrowseSearchEntryTooltip_UpdateAndShow", "LFGWhoListButtonMixin.InitButton",
            "QueueStatusEntry_SetUpLFGListActiveEntry",
            "QueueStatusEntry_SetUpLFGListApplication",
            "ScrollBox.OnInitializedFrame",
        }
        lfg.slots = { "activity.name", "entry.label", "ui.text", "npc.name" }
        lfg.domains = { "ui", "context", "zone", "npc" }
        lfg.dynamic = function ()
            local root = _G.LFGListFrame
            local entry = root and root.EntryCreation
            if entry then translate_lfg_frame(entry) end
            translate_lfg_vanilla()
        end
    end
    -- The LFG entry-creation page fills pooled activity rows and resets its
    -- labels after the parent panel is already visible. Translate at those
    -- completed writes instead of relying on the initial ShowUIPanel pass.
    hooks.global("LFGListEntryCreationActivityFinder_InitButton",
        translate_lfg_activity_button)
    hooks.global("LFGListEntryCreation_SetEditMode", translate_lfg_edit_mode)
    hooks.global("LFGListEntryCreation_Show", translate_lfg_frame)
    hooks.global("LFGListEntryCreation_Select", translate_lfg_frame)

    -- Hook live instances: XML has already copied their mixin methods.
    for _, name in ipairs({ "LFGParentFrame", "LFGListingFrame",
        "LFGBrowseFrame", "LFGWhoListFrame", "LFGListingFrameActivityView",
        "LFGListingFrameCategoryView", "LFGListingFrameLockedView" }) do
        hooks.region_script(_G[name], "OnShow", translate_lfg_vanilla)
    end
    hooks.region(_G.LFGParentFrame, "UpdateTabs", translate_lfg_vanilla)
    hooks.region(_G.LFGListingFrame, "UpdateFrameView", translate_lfg_vanilla)
    hooks.region(_G.LFGBrowseFrame, "UpdateResults", translate_lfg_vanilla)
    hooks.region(_G.LFGWhoListFrame, "UpdateWhoList", translate_lfg_vanilla)
    for _, name in ipairs({ "LFGListingPostButton_UpdateText",
        "LFGListingBackButton_UpdateText", "LFGListingActivityView_OnShow",
        "LFGListingLockedView_RefreshContent" }) do
        hooks.global(name, translate_lfg_vanilla_listing)
    end
    hooks.global("LFGListingCategorySelection_UpdateCategoryButtons",
        translate_lfg_vanilla_categories)
    hooks.global("LFGListingActivityView_InitActivityButton", translate_lfg_vanilla_activity)
    hooks.global("LFGListingActivityView_InitActivityGroupButton", translate_lfg_vanilla_activity)
    hooks.global("LFGListingLockedView_SetLineContent", function (_, row)
        if row then bind_lfg_display(row.Text, "zone") end
    end)
    hooks.global("LFGBrowseSearchEntry_Update", translate_lfg_vanilla_result)
    prepare_lfg_activity_menu()
    hooks.global("LFGBrowseSearchEntryTooltip_UpdateAndShow", translate_lfg_vanilla_tooltip)
    hooks.global("QueueStatusEntry_SetUpLFGListActiveEntry", function (entry)
        translate_lfg_queue_entry(entry)
    end)
    hooks.global("QueueStatusEntry_SetUpLFGListApplication", function (entry)
        translate_lfg_queue_entry(entry, "zone")
    end)
    hooks.mixin("LFGWhoListButtonMixin", "InitButton", translate_lfg_vanilla_who_row)
    -- Cover rows created before prepare(), and bind the copied InitButton on
    -- those instances as well as the mixin used by later pooled rows.
    local listing = _G.LFGListingFrame
    local browse = _G.LFGBrowseFrame
    local who = _G.LFGWhoListFrame
    local row_views = {
        { listing and listing.ActivityView and listing.ActivityView.ScrollBox,
            translate_lfg_vanilla_activity },
        { browse and browse.ScrollBox, translate_lfg_vanilla_result },
        { who and who.ScrollBox, translate_lfg_vanilla_who_row },
    }
    for _, view in ipairs(row_views) do
        local scroll_box, translate_row = view[1], view[2]
        local function initialize_row(row)
            if translate_row == translate_lfg_vanilla_who_row then
                hooks.region(row, "InitButton", translate_row)
            end
            translate_row(row)
        end
        if scroll_box and type(scroll_box.RegisterCallback) == "function"
            and _G.ScrollBoxListMixin and not lfg_scroll_boxes[scroll_box] then
            scroll_box:RegisterCallback(ScrollBoxListMixin.Event.OnInitializedFrame,
                function (_, row) initialize_row(row) end, lfg_scroll_boxes)
            lfg_scroll_boxes[scroll_box] = true
        end
        if scroll_box and type(scroll_box.ForEachFrame) == "function" then
            scroll_box:ForEachFrame(initialize_row)
        end
    end
    translate_lfg_vanilla()

    hooks.global("UIDropDownMenu_AddButton", translate_lfg_legacy_filter)
end
