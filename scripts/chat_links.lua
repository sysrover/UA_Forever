local _, addon_table = ...

local chat_links = addon_table.use("chat_links")
local chats = addon_table.use("chats")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local hooks = addon_table.use("translation_hooks").bind("chat-links")
local callbacks = setmetatable({}, { __mode = "k" })
local surface

local function restore_region(region, source)
    if not runtime.can_write_text(region, true) then return end
    runtime.release(region, "chat-links")
    pcall(region.SetText, region, source)
end

local function translate_region(region)
    if not region or runtime.is_applying(region) then return end
    local ok, text = pcall(region.GetText, region)
    text = ok and runtime.safe_string_or_nil(text)
    if not text then runtime.release(region, "chat-links"); return end
    local claim = runtime.get(region)
    if claim and claim.owner == "chat-links"
        and text ~= claim.translated and text ~= claim.source then
        runtime.release(region, "chat-links")
        claim = nil
    end
    local source = claim and claim.owner == "chat-links"
        and text == claim.translated and claim.source or text
    if not options.can_translate("translate_chat")
        or options.account.chat_style ~= "replacement" then
        if text ~= source then restore_region(region, source) end
        return
    end
    if not source:find("|H", 1, true) then return end
    local translated = chats.translate_links(source)
    if translated == source then
        if text ~= source then restore_region(region, source) end
        return
    end
    -- Only public text on the rendered FontString is changed. The native
    -- message buffer, secret sender IDs and hyperlinks remain untouched.
    runtime.apply(region, {
        owner = "chat-links", slot = "chat.text", source = source,
        translated = translated, option = "translate_chat", surface = surface,
        priority = runtime.PRIORITY.DOMAIN, phase = "direct",
        catalog_source = "chat.domain-links", combat_text_only = true,
        defer_if_protected = false, verify_after_apply = false,
        reapply_cached = true,
    })
end

local function refresh_frame(frame)
    if not frame or frame == _G.COMBATLOG or frame == _G.ChatFrame2 then return end
    local ok, container = pcall(function () return frame.FontStringContainer end)
    if not ok or not container then return end
    local regions_ok, regions = pcall(function () return { container:GetRegions() } end)
    if not regions_ok then return end
    for _, region in ipairs(regions) do
        local type_ok, kind = pcall(region.GetObjectType, region)
        local shown_ok, shown = pcall(region.IsShown, region)
        if type_ok and not runtime.is_secret_value(kind) and kind == "FontString"
            and shown_ok and not runtime.is_secret_value(shown) and shown == true then
            hooks.region(region, "SetText", translate_region)
            hooks.region(region, "SetFormattedText", translate_region)
            hooks.region(region, "ClearText", function (self)
                runtime.release(self, "chat-links")
            end)
            translate_region(region)
        end
    end
end

local function prepare_frame(frame)
    if not frame or frame == _G.COMBATLOG or frame == _G.ChatFrame2 then return end
    if not callbacks[frame] then
        -- Build 70170 invokes these callbacks after rebuilding visible lines.
        local ok = pcall(function ()
            frame:AddOnDisplayRefreshedCallback(function () refresh_frame(frame) end)
        end)
        if ok then callbacks[frame] = true end
    end
    hooks.region_script(frame, "OnShow", function () refresh_frame(frame) end)
    refresh_frame(frame)
end

local function refresh()
    prepare_frame(_G.DEFAULT_CHAT_FRAME)
    for index = 1, (_G.NUM_CHAT_WINDOWS or 10) do
        prepare_frame(_G["ChatFrame" .. index])
    end
end

chat_links.prepare = function ()
    surface = registry.register_surface({ id = "chat-links", roots = {},
        domains = { "item", "spell", "quest", "ui" }, name_category = "none",
        slots = { "chat.text" }, static = refresh,
        is_open = function () return _G.DEFAULT_CHAT_FRAME ~= nil end })
    registry.declare_hook({ id = "chat-links:new-window", surface = "chat-links",
        kind = "global", target = "FCF_OpenNewWindow", callback = refresh,
        blizzardAddon = "Blizzard_ChatFrameBase", verifiedBuild = "1.60.1.70205" })
    refresh()
end
