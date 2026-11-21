local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
local session = addon_table.use("tooltip_session")
local hooks = addon_table.use("translation_hooks").bind("spoken-interface")
local locale = addon_table.spoken_locale_uk
local localized_tables = setmetatable({}, { __mode = "k" })
local localized_pages = setmetatable({}, { __mode = "k" })
local display_strings = {}
local interface_enabled

local addon_names = {
    Spoken = true,
    Spoken_Quests = true,
    Spoken_Places = true,
    Spoken_Readables = true,
    Spoken_Bosses = true,
}

spoken.handles_addon = function (name)
    return type(name) == "string" and addon_names[name] == true
end

spoken.available = function ()
    if type(_G.Spoken) == "table" then return true end
    local addons = _G.C_AddOns
    return addons and type(addons.DoesAddOnExist) == "function"
        and addons.DoesAddOnExist("Spoken") or false
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
    if not translated then return end
    runtime.ensure_font(region)
    runtime.set_fallback_text(region, translated)
end

local function setting_tooltip(owner)
    if not options.can_translate("translate_spoken") or runtime.combat_locked() then return end
    local tooltip = _G.GameTooltip
    if not tooltip or tooltip:GetOwner() ~= owner or not tooltip:IsShown() then return end
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
        update_region(region)
    end
end

local function visit_settings_frame(frame)
    for _, region in ipairs({ frame:GetRegions() }) do visit_region(region) end
    for _, child in ipairs({ frame:GetChildren() }) do visit_settings_frame(child) end
end

local function prepare_existing_page(page)
    if not page.frame or localized_pages[page] then return end
    page.name = lookup(page.name) or page.name
    local page_layout = page.layout
    if page_layout then
        for _, entry in ipairs(page_layout.entries) do
            entry.label = lookup(entry.label) or entry.label
            entry.tooltip = lookup(entry.tooltip) or entry.tooltip
            entry.section = lookup(entry.section) or entry.section
            hooks.region_script(entry.frame, "OnEnter", setting_tooltip)
            hooks.region_script(entry.frame.layoutHit, "OnEnter", setting_tooltip)
        end
    end
    local function refresh(frame)
        visit_settings_frame(frame)
        if page_layout then page_layout:Reflow() end
    end
    hooks.region_script(page.frame, "OnShow", refresh)
    if page.frame:IsVisible() then refresh(page.frame) end
    localized_pages[page] = true
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
    if first and quests.Options then update_ace_options(quests.Options.table) end
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
    if first and menu and type(menu.NameBindings) == "function" then menu:NameBindings() end

    apply_quests()
    local places, bosses, readables = _G.SpokenPlaces, _G.SpokenBossesAddon, _G.SpokenReadables
    if places and places.Strings and places.Strings.enUS then overlay(places.L, locale.Places) end
    if bosses then overlay(bosses.L, locale.Bosses) end
    if readables then overlay(readables.L, locale.Readables) end

    -- Quests builds three pages in OnInitialize, before UA Forever may be
    -- loaded. The other pages read the locale in their normal builders.
    if menu then
        for _, page in ipairs(menu.pages or {}) do
            if page.order == 1 or page.order == 2 or page.order == 5.5 then prepare_existing_page(page) end
        end
    end
end
