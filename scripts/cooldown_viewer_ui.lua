local _, addon_table = ...
local panel = addon_table.use("cooldown_viewer_ui")
local api = addon_table.use("panel_ui_adapter").bind("cooldown-viewer")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")

-- Forever 1.60.1.70338: translate rendered labels after native updates.
-- Layout names, search/import text, category data and alert payloads stay native.
local function spell_label(region)
    strings.translate_region(region, "spell", "spell.name", api.surface)
end

local function tooltip_button(button)
    api.button(button)
    api.hooks.region_script(button, "OnEnter", api.tooltip)
end

local function refresh_category(category)
    if not category then return end
    api.regions(category.Header)
    api.button(category.Header)
    local pool = category.itemPool
    if pool and type(pool.EnumerateActive) == "function" then
        for item in pool:EnumerateActive() do
            api.watch(item.Bar and item.Bar.Name, spell_label)
            api.hooks.region(item, "RefreshTooltip", api.tooltip)
            api.hooks.region_script(item, "OnEnter", api.tooltip)
        end
    end
end

local function bind_category(category)
    if not category then return end
    api.hooks.region(category, "RefreshLayout", refresh_category)
    refresh_category(category)
end

local function refresh_alert(frame)
    if not frame then return end
    for _, key in ipairs({ "Title", "PrimaryLabel", "EventLabel", "PayloadLabel" }) do
        api.watch(frame[key])
    end
    api.watch(frame.Name, spell_label)
    for _, key in ipairs({ "TypeDropdown", "EventDropdown", "PayloadDropdown", "VisualDropdown" }) do
        local dropdown = frame[key]
        api.watch(dropdown and dropdown.Text)
    end
    tooltip_button(frame.AddButton)
end

local function refresh_dialog(frame)
    if not frame then return end
    for _, key in ipairs({ "Title", "EditBoxLabel", "NameEditBoxLabel" }) do
        api.watch(frame[key])
    end
    api.regions(frame.CharacterSpecificLayoutCheckButton)
    tooltip_button(frame.AcceptButton)
    tooltip_button(frame.CancelButton)
end

local function layout_label(region)
    local frame = _G.CooldownViewerSettings
    local manager = frame and frame:GetLayoutManager()
    -- A selected user layout may have the same name as a dictionary entry.
    local active_id = manager and manager:GetActiveLayoutID()
    local generated_name = manager and active_id == nil
    if manager and active_id and type(_G.CooldownManagerLayout_GetNameExplicit) == "function" then
        for _, info in manager:EnumerateLayouts() do
            if _G.CooldownManagerLayout_GetID(info) == active_id then
                generated_name = _G.CooldownManagerLayout_GetNameExplicit(info) == nil
                break
            end
        end
    end
    if generated_name then
        api.label(region)
    else
        runtime.invalidate(region)
    end
end

panel.user_layout_names = function ()
    local names = {}
    local frame = _G.CooldownViewerSettings
    local manager = frame and frame:GetLayoutManager()
    if manager and type(manager.EnumerateLayouts) == "function"
        and type(_G.CooldownManagerLayout_GetName) == "function" then
        for _, info in manager:EnumerateLayouts() do
            local get_name = _G.CooldownManagerLayout_GetNameExplicit or _G.CooldownManagerLayout_GetName
            local name = runtime.safe_string_or_nil(get_name(info))
            if name then names[name] = true end
        end
    end
    return names
end

local function refresh()
    local frame = _G.CooldownViewerSettings
    if frame then
        api.watch(frame.TitleContainer and frame.TitleContainer.TitleText)
        api.watch(frame.SearchBox and frame.SearchBox.Instructions)
        api.watch(frame.LayoutDropdown and frame.LayoutDropdown.Text, layout_label)
        tooltip_button(frame.UndoButton)
        for _, key in ipairs({ "SpellsTab", "AurasTab", "GroupBuffsTab", "SettingsDropdown" }) do
            tooltip_button(frame[key])
        end
        if frame.categoryPool then
            for category in frame.categoryPool:EnumerateActive() do bind_category(category) end
        end
        local filter = frame.GroupBuffFilter
        if filter then
            bind_category(filter.shownSection)
            bind_category(filter.hiddenSection)
        end
    end
    refresh_alert(_G.CooldownViewerSettingsEditAlert)
    refresh_alert(_G.GroupBuffFilterEditVisualAlert)
    refresh_dialog(_G.CooldownViewerLayoutDialog)
    refresh_dialog(_G.CooldownViewerImportLayoutDialog)
end

panel.prepare = function ()
    api.prepare({ "CooldownViewerSettings", "CooldownViewerSettingsEditAlert",
        "GroupBuffFilterEditVisualAlert", "CooldownViewerLayoutDialog",
        "CooldownViewerImportLayoutDialog" }, "Blizzard_CooldownViewer", {}, {}, refresh)
    local frame = _G.CooldownViewerSettings
    for _, method in ipairs({ "AddCategory", "RefreshLayout", "RefreshVisibleCategories" }) do
        api.hooks.region(frame, method, refresh)
    end
    api.hooks.region(_G.CooldownViewerSettingsEditAlert, "Display", refresh_alert)
    api.hooks.region(_G.GroupBuffFilterEditVisualAlert, "Display", refresh_alert)
    api.hooks.region(_G.CooldownViewerLayoutDialog, "ShowDialog", refresh_dialog)
    api.hooks.region(_G.CooldownViewerImportLayoutDialog, "ShowDialog", refresh_dialog)
end
