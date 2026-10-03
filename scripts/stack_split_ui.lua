local _, addon_table = ...

local adapter = addon_table.use("stack_split_ui")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local hooks = addon_table.use("translation_hooks").bind("stack-split")
local layout = addon_table.use("translation_layout")
local catalog = assert(addon_table.forever_surface_ui.stack_split)
local surface

local function layout_buttons()
    local frame = _G.StackSplitFrame
    local okay = frame and frame.OkayButton
    local cancel = frame and frame.CancelButton
    if not okay or not cancel or runtime.combat_locked()
        or not runtime.can_write_text(frame) then return end
    strings.fit_button_to_text(okay)
    strings.fit_button_to_text(cancel)
    local okay_width = layout.safe_dimension(okay, "GetWidth")
    local cancel_width = layout.safe_dimension(cancel, "GetWidth")
    if not okay_width or not cancel_width then return end
    local group_width = okay_width + 8 + cancel_width
    local width = math.max(188, math.ceil(group_width + 40))
    local multi = frame.isMultiStack == true
    -- ChooseFrameType restores the build's 172px width and center anchors.
    -- Recompute the whole row after that native method, including its artwork.
    pcall(frame.SetWidth, frame, width)
    for _, key in ipairs({ "SingleItemSplitBackground", "MultiItemSplitBackground" }) do
        local background = frame[key]
        if background then
            pcall(background.ClearAllPoints, background)
            pcall(background.SetAllPoints, background, frame)
        end
    end
    pcall(okay.ClearAllPoints, okay)
    pcall(okay.SetPoint, okay, "BOTTOMLEFT", frame, "BOTTOMLEFT",
        (width - group_width) / 2, multi and 28 or 20)
    pcall(cancel.ClearAllPoints, cancel)
    pcall(cancel.SetPoint, cancel, "LEFT", okay, "RIGHT", 8, 0)
    if not multi and frame.StackSplitText then
        -- Keep the number between the arrows, which are anchored to CENTER.
        pcall(frame.StackSplitText.ClearAllPoints, frame.StackSplitText)
        pcall(frame.StackSplitText.SetPoint, frame.StackSplitText,
            "RIGHT", frame, "CENTER", 36, 18)
    end
end

local function is_open()
    local frame = _G.StackSplitFrame
    if not frame then return false end
    local ok, shown = pcall(frame.IsShown, frame)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function translate(region)
    if not region or runtime.is_applying(region) then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and runtime.safe_string_or_nil(source) or nil
    if not source then return end
    local previous = runtime.get(region)
    if previous and source ~= previous.translated then
        -- Switching back to a numeric count must release the old multistack
        -- claim, so an option refresh cannot replay its translated label.
        runtime.invalidate(region)
    end
    local translated = catalog.count(source)
    if translated then
        runtime.apply(region, { owner = "stack-split", slot = "ui.count",
            source = source, translated = translated, option = "translate_string",
            surface = surface, priority = runtime.PRIORITY.CONTEXT,
            catalog_source = "ui.surfaces.stack_split", phase = "direct",
            reapply_cached = true })
    else
        strings.translate_region(region, nil, "ui.label", surface)
    end
    layout_buttons()
end

local function prepare_region(region)
    if not region then return end
    hooks.region(region, "SetText", translate)
    hooks.region(region, "SetFormattedText", translate)
    translate(region)
end

local function refresh()
    local frame = _G.StackSplitFrame
    if not frame then return end
    for _, key in ipairs({ "OkayButton", "CancelButton" }) do
        local button = frame[key]
        if button and type(button.GetFontString) == "function" then
            local ok, region = pcall(button.GetFontString, button)
            if ok then prepare_region(region) end
        end
    end
    -- Pure numeric text in the single-stack mode remains untouched.
    prepare_region(frame.StackSplitText)
    prepare_region(frame.StackItemCountText)
    layout_buttons()
end

adapter.prepare = function ()
    surface = registry.register_surface({ id = "stack-split", roots = { "StackSplitFrame" },
        domains = { "ui" }, name_category = "none", slots = { "ui.label", "ui.count" },
        static = refresh, is_open = is_open })
    -- The 70170 Camelot XML uses StackSplitMixin, copied onto the live frame.
    -- Hook instance methods as well as OnShow, rather than a late mixin hook.
    for _, method in ipairs({ "OpenStackSplitFrame", "ChooseFrameType",
        "UpdateStackSplitFrame", "UpdateStackText" }) do
        registry.declare_hook({ id = "stack-split:" .. method, surface = "stack-split",
            kind = "frame", target = "StackSplitFrame", method = method,
            callback = refresh, blizzardAddon = "Blizzard_FrameXML",
            verifiedBuild = "1.60.1.70170" })
    end
    hooks.region_script(_G.StackSplitFrame, "OnShow", refresh)
    refresh()
end
