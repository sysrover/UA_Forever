local _, addon_table = ...

local forever_vo_ui = addon_table.use("forever_vo_ui")
local options = addon_table.use("options")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local hooks = addon_table.use("translation_hooks").bind("settings-forever-vo")
local text = addon_table.forever_surface_ui.forever_vo
local wrapped_options = setmetatable({}, { __mode = "k" })

local function call(owner, method, ...)
    if not owner then return nil end
    local method_ok, callback = pcall(function () return owner[method] end)
    if not method_ok or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, owner, ...)
    if ok and not runtime.is_secret_value(value) then return value end
end

local function localize(source)
    if runtime.is_secret_value(source) or type(source) ~= "string" then return nil end
    if not options.can_translate("translate_string")
        or not options.section_enabled("game_settings") then return nil end
    return text.value(source) or resolver.find_ui(source)
end

local function translate(region, source)
    if not region or runtime.is_applying(region) then return end
    source = source or call(region, "GetText")
    if runtime.is_secret_value(source) or type(source) ~= "string" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = localize(source)
    if not translated or translated == source then
        runtime.ensure_font(region)
        return
    end
    local surface = registry.get("settings")
    if not surface then return end
    if runtime.generation(surface) <= 0 then
        runtime.begin_generation(surface, "forever-vo-settings")
    end
    runtime.apply(region, {
        owner = "settings-forever-vo", slot = "forever-vo:" .. source,
        source = source, translated = translated, section = "game_settings",
        option = "translate_string", surface = surface,
        generation = runtime.generation(surface), instance = tostring(region),
        phase = "dynamic", priority = runtime.PRIORITY.CONTEXT,
        reapply_cached = true,
    })
end

local function translate_button(frame, initializer)
    local button = frame.FVOButton
    if not button or not initializer.fvoButton then return end
    local function update(self, source)
        if call(frame, "GetElementData") ~= initializer then return end
        local region = call(self, "GetFontString")
        translate(region, source)
        local width = call(region, "GetStringWidth")
        if type(width) == "number" then self:SetWidth(math.max(160, math.ceil(width) + 40)) end
    end
    hooks.region(button, "SetText", update, "settings")
    update(button)
end

local function translate_frame(initializer, frame)
    if not frame then return end
    translate(frame.Text, call(initializer, "GetName"))
    translate(frame.Title, call(initializer, "GetName"))
    local dropdown = frame.Control and frame.Control.Dropdown
    if dropdown then
        local function update(self)
            if call(frame, "GetElementData") ~= initializer then return end
            translate(self.Text, self.text)
        end
        hooks.region(dropdown, "UpdateText", update, "settings")
        update(dropdown)
    end
    translate_button(frame, initializer)
    local versions = frame.FVOVersions
    if not versions then return end
    local widest = 0
    for index, label in ipairs(versions.labels) do
        if call(label, "IsShown") then
            translate(label)
            translate(versions.values[index])
            widest = math.max(widest, call(label, "GetStringWidth") or 0)
        end
    end
    for _, value in ipairs(versions.values) do
        local _, _, _, _, y = value:GetPoint(1)
        if y then value:SetPoint("TOPLEFT", 37 + math.ceil(widest) + 24, y) end
    end
end

local function prepare_category(category)
    local layout = call(_G.SettingsPanel, "GetLayout", category)
    for _, initializer in ipairs(call(layout, "GetInitializers") or {}) do
        local data = call(initializer, "GetData")
        -- Only display labels/tooltips are copied. Proxy indices and saved
        -- channel/voice identifiers remain exactly as ForeverVO supplied them.
        if data and type(data.options) == "function" and not wrapped_options[initializer] then
            local original = data.options
            data.options = function (...)
                local rows = original(...)
                if type(rows) ~= "table" then return rows end
                local result = {}
                for index, row in ipairs(rows) do
                    local copy = {}
                    for key, value in pairs(row) do copy[key] = value end
                    copy.text = localize(row.text) or row.text
                    copy.label = localize(row.label) or row.label
                    copy.tooltip = localize(row.tooltip) or row.tooltip
                    result[index] = copy
                end
                return result
            end
            wrapped_options[initializer] = true
        end
        -- Custom Versions/ButtonRow InitFrame methods write after frame:Init.
        hooks.region(initializer, "InitFrame", translate_frame, "settings")
    end
    for _, child in ipairs(call(category, "GetSubcategories") or {}) do
        prepare_category(child)
    end
end

forever_vo_ui.prepare = function ()
    -- Also retry before a category is displayed when ForeverVO loaded later.
    hooks.region(_G.SettingsPanel, "SetCurrentCategory", forever_vo_ui.prepare, "settings")
    local voiceover = _G.ForeverVO
    local category = voiceover and voiceover.SettingsPanel and voiceover.SettingsPanel.category
    if not category then return end
    prepare_category(category)
end
