local _, addon_table = ...
local barber = addon_table.use("barber_ui")
local ui = addon_table.use("panel_ui_adapter").bind("barber-ui")
local runtime = addon_table.use("translation_runtime")
local options = addon_table.use("options")
local resolver = addon_table.use("translation_resolver")
local layout = addon_table.use("translation_layout")
local sessions = addon_table.use("tooltip_session")
local catalog = addon_table.forever_surface_ui and addon_table.forever_surface_ui.barber
local dependencies
local sequence = 0
local tooltip_states = setmetatable({}, { __mode = "k" })

-- The active 70959 inventory lacks these sources. Paths and lifecycle were
-- inspected in 70938's Camelot CharacterCustomize and shared CustomizationUI.
local function read(object, method)
    if not object or runtime.is_secret_value(object) then return end
    local ok, value = pcall(function ()
        local callback = object[method]
        if type(callback) == "function" then return callback(object) end
    end)
    if ok and not runtime.is_secret_value(value) then return value end
end

barber.is_owner = function (frame)
    local shop, customize = _G.BarberShopFrame, _G.CharCustomizeFrame
    if not shop or not ui.visible(shop) then return false end
    for _ = 1, 20 do
        if not frame or runtime.is_secret_value(frame) then return false end
        if frame == shop then return true end
        if frame == customize then
            local ok, parent = pcall(function () return customize.parentFrame end)
            return ok and not runtime.is_secret_value(parent) and parent == shop
        end
        local owner = read(frame, "GetCustomizationFrame")
        if owner and owner ~= frame then frame = owner
        else frame = read(frame, "GetOwnerRegion") or read(frame, "GetParent") end
    end
    return false
end

local function skip_region(region)
    local parent = read(region, "GetParent")
    return read(parent, "GetObjectType") == "EditBox"
end

local function attached_customize()
    local customize, shop = _G.CharCustomizeFrame, _G.BarberShopFrame
    if not customize or not shop then return end
    local ok, parent = pcall(function () return customize.parentFrame end)
    if ok and not runtime.is_secret_value(parent) and parent == shop then return customize end
end

local function bind_labels(frame, seen)
    if frame then ui.watch_frame(frame, skip_region, nil, seen) end
end

local function option_ready(frame)
    if not barber.is_owner(frame) then return end
    bind_labels(frame)
    -- Instances copy mixins, so observe their actual writer rather than only
    -- the mixin table. New choices never modify optionData/choiceData names.
    ui.hooks.region(frame, "SetupOption", option_ready)
end

local function refresh_options()
    local customize = attached_customize()
    if not customize then return end
    local container = customize.CustomizeOptionsContainerFrame
    local box = customize.OptionsScrollBox or container and container.OptionsScrollBox
    local root = customize.Options or box and box.Options
    if not root then return end
    local ok, children = pcall(function () return { root:GetChildren() } end)
    if not ok then return end
    local seen = {}
    for _, frame in ipairs(children) do
        ui.hooks.region(frame, "SetupOption", option_ready)
        if ui.visible(frame) then bind_labels(frame, seen) end
    end
end

local function refresh_forms()
    local customize = attached_customize()
    if not customize then return end
    local seen = {}
    local container = customize.CustomizeOptionsContainerFrame
    bind_labels(customize.Categories or container and container.Categories, seen)
    bind_labels(customize.FormsDropdown, seen)
    bind_labels(customize.AlteredForms, seen)
end

local function refresh()
    local shop = _G.BarberShopFrame
    if not shop then return end
    local seen = {}
    for _, key in ipairs({ "AcceptButton", "CancelButton", "ResetButton", "SDToggleButton" }) do
        bind_labels(shop[key], seen)
    end
    refresh_forms()
    refresh_options()
end

local function tooltip_owner(tooltip)
    if tooltip ~= _G.CustomizationNoHeaderTooltip then return end
    local owner = read(tooltip, "GetOwner")
    if owner and barber.is_owner(owner) then return owner end
end

local function snapshot(tooltip)
    if not dependencies then return end
    local count = read(tooltip, "NumLines")
    if type(count) ~= "number" or count < 1 or count > 40 then return end
    local rows = {}
    for index = 1, count do
        for _, side in ipairs({ "Left", "Right" }) do
            local source, region = dependencies.line(tooltip, side, index)
            source = runtime.safe_string_or_nil(source)
            if region and source and source ~= "" then
                local claim = runtime.get(region)
                if claim and claim.owner == "barber-ui" and claim.surface == tooltip
                    and claim.generation == tooltip.uaForeverGeneration
                    and (source == claim.translated or source == claim.source) then
                    source = claim.source
                end
                rows[#rows + 1] = { region = region, source = source,
                    slot = "ui.tooltip:" .. side .. ":" .. index }
            end
        end
    end
    return rows
end

local function same_rows(left, right)
    if not left or not right or #left ~= #right then return false end
    for index, row in ipairs(left) do
        local other = right[index]
        if row.region ~= other.region or row.source ~= other.source then return false end
    end
    return true
end

local function render(tooltip, state)
    local original = options.original_tooltip_held() == true
        or not options.can_translate("translate_string")
        or not options.section_enabled("character_ui")
    tooltip.uaForeverShowOriginal = original
    for _, row in ipairs(state.rows) do
        if original then
            local claim = runtime.get(row.region)
            if claim and claim.owner == "barber-ui" then runtime.show_original(row.region, true) end
        else
            if not row.looked_up then
                row.translated = runtime.safe_string_or_nil(resolver.find_ui(row.source, row.region))
                if (not row.translated or row.translated == row.source) and catalog then
                    row.translated = runtime.safe_string_or_nil(catalog.tooltip_line(row.source,
                        function (text) return resolver.find_ui(text, row.region) end))
                end
                row.looked_up = true
            end
            if row.translated and row.translated ~= row.source then
                runtime.apply(row.region, { owner = "barber-ui", slot = row.slot,
                    source = row.source, translated = row.translated,
                    section = "character_ui", option = "translate_string",
                    surface = tooltip, tooltip = tooltip, phase = "dynamic",
                    generation = state.generation, instance = state.key,
                    priority = runtime.PRIORITY.DOMAIN })
            end
        end
    end
    -- Show is the native completion boundary. No line writer measures layout;
    -- this same finalizer handles both Ukrainian and Shift/original mode.
    layout.fit_current_tooltip(tooltip)
end

barber.complete_tooltip = function (tooltip)
    local owner = tooltip_owner(tooltip)
    if not owner or not ui.visible(tooltip) or not dependencies then return end
    dependencies.clear_line_cache(tooltip)
    local rows = snapshot(tooltip)
    if not rows then return end
    local state = tooltip_states[tooltip]
    if not state or state.owner ~= owner or state.generation ~= tooltip.uaForeverGeneration
        or not same_rows(state.rows, rows) then
        sequence = sequence + 1
        state = { owner = owner, key = "barber:" .. sequence, rows = rows }
        sessions.begin(tooltip, state.key, options.original_tooltip_held() == true)
        state.generation = tooltip.uaForeverGeneration
        tooltip.uaForeverKind = "barber"
        tooltip_states[tooltip] = state
    end
    render(tooltip, state)
end

barber.owns_tooltip = function (tooltip)
    local state = tooltip and tooltip_states[tooltip]
    return state ~= nil and state.generation == tooltip.uaForeverGeneration
        and ui.visible(tooltip) and tooltip_owner(tooltip) == state.owner
end

barber.refresh_tooltip = function (tooltip)
    if not barber.owns_tooltip(tooltip) then return end
    local state = tooltip_states[tooltip]
    -- A delayed settings/modifier refresh cannot write to reused native rows.
    if not same_rows(state.rows, snapshot(tooltip)) then return end
    render(tooltip, state)
end

local function reset_tooltip(tooltip)
    if not tooltip_states[tooltip] then return end
    tooltip_states[tooltip] = nil
    sessions.reset(tooltip)
end

barber.configure = function (value) dependencies = value end

barber.prepare = function ()
    ui.prepare({ "BarberShopFrame" }, "Blizzard_BarberShopUI", {}, {}, refresh)
    local customize = _G.CharCustomizeFrame
    ui.hooks.region(customize, "UpdateOptionButtons", refresh_options)
    ui.hooks.region(customize, "UpdateAlteredForms", refresh_forms)
    ui.hooks.region_script(customize, "OnShow", refresh)
    local tooltip = _G.CustomizationNoHeaderTooltip
    ui.hooks.region(tooltip, "Show", barber.complete_tooltip)
    ui.hooks.region_script(tooltip, "OnTooltipCleared", reset_tooltip)
    ui.hooks.region_script(tooltip, "OnHide", reset_tooltip)
end
