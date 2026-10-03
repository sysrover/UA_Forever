local _, addon_table = ...

local chat_config_ui = addon_table.use("chat_config_ui")
local strings = addon_table.use("strings")
local combat_log = addon_table.use("combat_log")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local walker = addon_table.use("translation_walker")
local hooks = addon_table.use("translation_hooks").bind("chat-config")
local catalog = assert(addon_table.forever_surface_ui.chat_config)
local surface
local preview_names = {
    "CombatConfigColorsExampleString1", "CombatConfigColorsExampleString2",
    "CombatConfigFormattingExampleString1", "CombatConfigFormattingExampleString2",
}

local function is_open()
    local frame = _G.ChatConfigFrame
    if not frame then return false end
    local ok, shown = pcall(frame.IsShown, frame)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function header_region()
    local frame = _G.ChatConfigFrame
    return frame and frame.Header and frame.Header.Text
end

local function read_source(region)
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string" then return nil end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    return source
end

local function translate_header(region)
    local source = read_source(region)
    if not source then return end
    -- Build 70170 formats CHATCONFIG_HEADER after selecting a chat window.
    -- Keep custom window names intact; only the surrounding UI is localized.
    local name = source and source:match("^(.+) Config$")
    if not name then
        strings.translate_region(region, nil, "ui.title", surface)
        return
    end
    runtime.apply(region, {
        owner = "chat-config", slot = "ui.title", source = source,
        translated = catalog.header(name), option = "translate_string",
        priority = runtime.PRIORITY.CONTEXT, surface = surface,
        catalog_source = "ui.surfaces.chat_config", phase = "direct",
        reapply_cached = true,
    })
end

local function translate_special_label(region)
    local source = read_source(region)
    if not source then return false end
    local translated = catalog.channel(source)
    local slot, option, provenance = "ui.label", "translate_string", "ui.surfaces.chat_config"
    if not translated then
        for _, name in ipairs(preview_names) do
            if region == _G[name] then
                translated = combat_log.translate(source)
                slot, option, provenance = "chat.text", "translate_chat", "chat.system.combat_log"
                break
            end
        end
    end
    if not translated or translated == source then return false end
    runtime.apply(region, {
        owner = "chat-config", slot = slot, source = source,
        translated = translated, option = option, surface = surface,
        priority = runtime.PRIORITY.CONTEXT, catalog_source = provenance,
        phase = "direct", reapply_cached = true,
    })
    return true
end

local function translate_region(region)
    if not region or runtime.is_applying(region) then return end
    if region == header_region() then
        translate_header(region)
    elseif not translate_special_label(region) then
        strings.translate_region(region, nil, "ui.label", surface)
    end
end

local function prepare_region(region)
    if not region then return end
    local ok, kind = pcall(region.GetObjectType, region)
    if not ok or runtime.is_secret_value(kind) or kind ~= "FontString" then return end
    hooks.region(region, "SetText", translate_region)
    hooks.region(region, "SetFormattedText", translate_region)
    translate_region(region)
end

local function skip_frame(frame)
    if strings.is_protected_frame(frame) then return true end
    -- Tabs contain user-selected chat window names. EditBoxes contain filter
    -- names and other editable data, rather than UI vocabulary.
    if frame == _G.ChatConfigFrameChatTabManager then return true end
    local ok, kind = pcall(frame.GetObjectType, frame)
    return not ok or runtime.is_secret_value(kind) or kind == "EditBox"
end

local function prepare_frame(frame)
    if not frame then return end
    walker.walk({ id = "chat-config:labels", surface = "chat-config",
        owner = "chat_config_ui", reason = "REGISTERED_STATIC_SCAN",
        max_nodes = 5000 }, frame, prepare_region, skip_frame, { frames = 0 })
end

local function refresh()
    if is_open() then prepare_frame(_G.ChatConfigFrame) end
end

local function request_refresh()
    if is_open() then registry.refresh("chat-config") end
end

local function declare_global(target, callback)
    registry.declare_hook({ id = "chat-config:" .. target,
        surface = "chat-config", kind = "global", target = target,
        blizzardAddon = "Blizzard_ChatFrame", verifiedBuild = "1.60.1.70205",
        callback = callback })
end

chat_config_ui.prepare = function ()
    surface = registry.register_surface({ id = "chat-config",
        roots = { "ChatConfigFrame" }, domains = { "ui", "chat", "spell", "npc" },
        name_category = "none", slots = { "ui.title", "ui.label", "ui.filter", "chat.text" },
        static = refresh, is_open = is_open })

    -- Constructors can run while the panel is hidden. Attach text hooks to
    -- their labels before later native updates reuse these widgets.
    for _, target in ipairs({ "ChatConfig_CreateCheckboxes",
        "ChatConfig_CreateTieredCheckboxes", "ChatConfig_CreateColorSwatches",
        "ChatConfig_UpdateCheckboxes", "ChatConfig_UpdateSwatches" }) do
        declare_global(target, prepare_frame)
    end
    for _, target in ipairs({ "ChatConfigCategory_OnClick",
        "ChatConfigCategoryFrame_Refresh", "ChatConfig_UpdateChatSettings",
        "ChatConfig_UpdateCombatSettings", "ChatConfig_UpdateCombatTabs",
        "CombatConfig_Settings_Update", "CombatConfig_Colorize_Update",
        "CombatConfig_Formatting_Update" }) do
        declare_global(target, request_refresh)
    end
    declare_global("ChatConfigCombat_InitButton", function (button)
        prepare_region(button and button.NormalText)
    end)
    hooks.region_script(_G.ChatConfigFrame, "OnShow", refresh)
    refresh()
end
