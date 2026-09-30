local _, addon_table = ...

local level_up_display = addon_table.use("level_up_display")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")

local toast_region_slots = {
    Title = "ui.title",
    SubTitle = "ui.subtitle",
    Description = "ui.description",
    InstructionalText = "ui.instruction",
}

local function translate_toast_regions(container, surface, instance)
    if not container then return end
    for key, slot in pairs(toast_region_slots) do
        strings.translate_region(container[key], nil, slot, surface,
            "dynamic", instance)
    end
end

local function translate_toast(toast)
    if not toast then return end
    local surface = registry.get("level-up")
    if not surface then return end
    local instance = tostring(toast)
    runtime.begin_generation(surface, instance)
    translate_toast_regions(toast, surface, instance)
    translate_toast_regions(toast.Contents, surface, instance)
    if type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled()
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(toast)
    end
end

local function after_main_toast(manager)
    translate_toast(manager and manager.currentDisplayingToast)
end

local function after_side_toast(manager)
    translate_toast(manager and manager.lastToastFrame)
end

local function declare_toast_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "level-up.toast.display",
        surface = "level-up",
        kind = "mixin",
        target = "EventToastManagerFrameMixin",
        method = "DisplayToast",
        required = true,
        fallbackEvent = "DISPLAY_EVENT_TOASTS",
        verifiedBuild = 70009,
        callback = after_main_toast,
    })
    registry.declare_hook({
        id = "level-up.side-display.toast",
        surface = "level-up",
        kind = "mixin",
        target = "EventToastManagerSideDisplayMixin",
        method = "DisplayToastAtIndex",
        required = true,
        fallbackEvent = "levelup hyperlink",
        verifiedBuild = 70009,
        callback = after_side_toast,
    })
end

level_up_display.prepare = function ()
    local surface = registry.get("level-up")
    if surface then
        surface.static = function ()
            after_main_toast(_G.EventToastManagerFrame)
            after_side_toast(_G.EventToastManagerSideDisplay)
        end
    end
    declare_toast_hooks()
end
