local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
local session = addon_table.use("tooltip_session")
local hooks = addon_table.use("translation_hooks").bind("spoken-interface")
local profile = addon_table.use("performance_profile").wrap or function (_, callback) return callback end
local locale = addon_table.spoken_locale_uk
local localized_tables = setmetatable({}, { __mode = "k" })
local localized_pages = setmetatable({}, { __mode = "k" })
local default_label = "Типові"
local display_strings = { Defaults = default_label }
local interface_enabled

local addon_names = {
    Spoken = true,
    Spoken_Quests = true,
    Spoken_Places = true,
    Spoken_Readables = true,
    Spoken_Bosses = true,
}

local source_keys = { "quests", "gossip", "chatter", "places", "readables", "bosses" }

spoken.handles_addon = function (name)
    return type(name) == "string" and addon_names[name] == true
end

spoken.available = function ()
    if type(_G.Spoken) == "table" then return true end
    local addons = _G.C_AddOns
    if not addons then return false end
    if type(addons.DoesAddOnExist) == "function" then return addons.DoesAddOnExist("Spoken") end
    return type(addons.GetAddOnInfo) == "function" and addons.GetAddOnInfo("Spoken") == "Spoken"
end

local function readable(value)
    return not runtime.is_secret_value(value) and type(value) == "string" and value ~= ""
end

local function lookup(source)
    if readable(source) then return display_strings[source] end
end

local function overlay(native, translated)
    if type(native) ~= "table" or localized_tables[native] then return end
    for key, text in pairs(translated) do
        local source = native[key]
        if readable(source) and source ~= text then
            local previous = display_strings[source]
            display_strings[source] = (previous == nil or previous == text) and text or false
        end
        native[key] = text
    end
    localized_tables[native] = true
end

local function visible_text(region)
    local ok, source = pcall(function () return region:GetText() end)
    if ok and readable(source) then return source end
end

local function update_region(region)
    local source = visible_text(region)
    local translated = lookup(source)
    if not translated then return false end
    runtime.ensure_font(region)
    return runtime.set_fallback_text(region, translated)
end

local function setting_tooltip(owner)
    if not options.can_translate("translate_spoken") or not options.section_enabled("game_settings")
        or runtime.combat_locked() then return end
    local tooltip = _G.GameTooltip
    if not tooltip or not tooltip:IsShown() then return end
    local actual_owner = tooltip:GetOwner()
    if runtime.is_secret_value(actual_owner) or actual_owner ~= owner then return end
    local original = options.original_tooltip_held()
    if original ~= false then return end
    local count = tooltip:NumLines()
    if runtime.is_secret_value(count) or type(count) ~= "number" then return end
    local started
    for index = 1, count do
        local region = _G["GameTooltipTextLeft" .. index]
        local source = visible_text(region)
        local existing = region and runtime.get(region)
        if existing and source == existing.translated then source = existing.source end
        local translated = lookup(source)
        if translated then
            if not started then
                session.begin(tooltip, "spoken-settings:" .. tostring(owner), false, nil, true)
                tooltip.uaForeverKind = "generic"
                started = true
            end
            runtime.apply(region, {
                owner = "spoken-settings", slot = "spoken-settings:" .. index,
                option = "translate_spoken", section = "game_settings",
                source = source, translated = translated,
                surface = tooltip, tooltip = tooltip, priority = runtime.PRIORITY.CONTEXT,
                generation = tooltip.uaForeverGeneration, instance = tooltip.uaForeverSessionKey,
                reapply_cached = true,
            })
        end
    end
    if started then layout.fit_current_tooltip(tooltip) end
end

local function visit_region(region)
    if region and type(region.GetText) == "function"
        and type(region.GetObjectType) == "function" and region:GetObjectType() == "FontString" then
        return update_region(region)
    end
end

local function visit_settings_frame(frame)
    local changed = false
    for _, region in ipairs({ frame:GetRegions() }) do changed = visit_region(region) or changed end
    for _, child in ipairs({ frame:GetChildren() }) do changed = visit_settings_frame(child) or changed end
    return changed
end

local function localize_greeting_choices(control)
    local dropdown = control.Dropdown or control
    if type(dropdown.SetupMenu) ~= "function" or type(control.layoutValues) ~= "table"
        or type(control.layoutChoose) ~= "function" or type(control.layoutRead) ~= "function" then return end
    -- GossipSettingsPanel captured these labels before UA Forever loaded.
    local labels = {
        Always = locale.Quests.OPT_GREETING_LABEL_ALWAYS,
        OncePerQuestNPC = locale.Quests.OPT_GREETING_LABEL_ONCE_QUEST,
        OncePerNPC = locale.Quests.OPT_GREETING_LABEL_ONCE_NPC,
        Never = locale.Quests.OPT_GREETING_LABEL_NEVER,
    }
    dropdown:SetupMenu(function (_, root)
        for _, value in ipairs(control.layoutValues) do
            root:CreateRadio(labels[value] or value, function ()
                return control.layoutRead() == value
            end, function ()
                control.layoutChoose(value)
            end, value)
        end
    end)
end

local function prepare_existing_page(page)
    if not page.frame or localized_pages[page] then return end
    local name = lookup(page.name)
    if name then
        page.name = name
        if page.category and type(page.category.SetName) == "function" then
            page.category:SetName(name)
        end
    end
    local page_layout = page.layout
    if page_layout then
        for _, entry in ipairs(page_layout.entries or {}) do
            entry.label = lookup(entry.label) or entry.label
            entry.tooltip = lookup(entry.tooltip) or entry.tooltip
            entry.section = lookup(entry.section) or entry.section
            if page.order == 2 and entry.label == locale.Quests.OPT_PANEL_GREETINGS then
                localize_greeting_choices(entry.frame)
            end
            for _, condition in ipairs(entry.frame.layoutConditions or {}) do
                condition.reason = lookup(condition.reason) or condition.reason
            end
            hooks.region_script(entry.frame, "OnEnter", setting_tooltip)
            hooks.region_script(entry.frame.layoutHit, "OnEnter", setting_tooltip)
        end
    end
    local function refresh(frame)
        if visit_settings_frame(frame) and page_layout then page_layout:Reflow() end
    end
    hooks.region_script(page.frame, "OnShow", refresh)
    if page.frame:IsVisible() then refresh(page.frame) end
    localized_pages[page] = true
end

local function prepare_defaults(menu)
    local native_layout = _G.SpokenLayout
    if native_layout then
        hooks.once("settings-defaults", function ()
            local original = native_layout.Defaults
            if type(original) ~= "function" then return false end
            native_layout.Defaults = profile("spoken-interface.defaults", function (self, action, label, tooltip, ...)
                local button = original(self, action, label or default_label, tooltip, ...)
                if not label and button and type(button.GetFontString) == "function" then
                    runtime.ensure_font(button:GetFontString())
                end
                return button
            end)
            return true
        end)
    end
    if not menu or type(menu.Pages) ~= "function" then return end
    for _, page in ipairs(menu:Pages()) do
        local button = page.layout and page.layout.defaults
        local label = button and type(button.GetFontString) == "function" and button:GetFontString()
        if label and update_region(label) then
            hooks.region_script(button, "OnEnter", setting_tooltip)
        end
    end
end

local function update_ace_options(node)
    if type(node) ~= "table" then return end
    node.name = lookup(node.name) or node.name
    node.desc = lookup(node.desc) or node.desc
    if type(node.values) == "table" then
        for key, value in pairs(node.values) do node.values[key] = lookup(value) or value end
    end
    if type(node.args) == "table" then
        for _, child in pairs(node.args) do update_ace_options(child) end
    end
end

local function apply_quests()
    local quests = _G.VoiceOver
    if not quests or quests.AddonFolder ~= "Spoken_Quests" or type(quests.L) ~= "table" then return end
    local first = not localized_tables[quests.L]
    overlay(quests.L, locale.Quests)
    if not first then return end
    if quests.Options then update_ace_options(quests.Options.table) end
end

local function prepare_registered_labels(env)
    local api = _G.Spoken
    local minimap_entries = env.Minimap and env.Minimap.entries or {}
    local compendium = _G.SpokenCompendium
    -- These registrations copy display strings when a module loads.
    for _, key in ipairs(source_keys) do
        local source = api and type(api.GetSource) == "function" and api:GetSource(key)
        if source then
            source.title = lookup(source.title) or source.title
            source.about = lookup(source.about) or source.about
        end
        for _, entry in ipairs(minimap_entries[key] or {}) do
            entry.text = lookup(entry.text) or entry.text
        end
        local tab = compendium and type(compendium.Tab) == "function" and compendium:Tab(key)
        if tab then tab.label = lookup(tab.label) or tab.label end
    end
end

spoken.prepare_interface = function ()
    if interface_enabled == nil and options.account then
        interface_enabled = options.can_translate("translate_spoken")
    end
    if not interface_enabled then return end
    local env = _G.SpokenEnv
    if not env or env.AddonFolder ~= "Spoken" then return end
    local first = env.L and not localized_tables[env.L]
    overlay(env.L, locale.Spoken)
    local menu = env.Options
    prepare_defaults(menu)
    if first and menu and type(menu.NameBindings) == "function" then menu:NameBindings() end

    apply_quests()
    local places, bosses, readables = _G.SpokenPlaces, _G.SpokenBossesAddon, _G.SpokenReadables
    if places and places.Strings and places.Strings.enUS then overlay(places.L, locale.Places) end
    if bosses then overlay(bosses.L, locale.Bosses) end
    if readables then overlay(readables.L, locale.Readables) end
    prepare_registered_labels(env)
    if env.Actions then
        for _, action in ipairs(env.Actions.optional or {}) do
            action.label = lookup(action.label) or action.label
        end
    end

    -- Quests builds three pages in OnInitialize, before UA Forever may be
    -- loaded. The other pages read the locale in their normal builders.
    if menu then
        for _, page in ipairs(menu.pages or {}) do
            if page.order == 1 or page.order == 2 or page.order == 5.5 then prepare_existing_page(page) end
        end
    end
end
