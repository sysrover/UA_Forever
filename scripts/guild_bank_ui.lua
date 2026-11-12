local _, addon_table = ...
local bank = addon_table.use("guild_bank_ui")
local ui = addon_table.use("panel_ui_adapter").bind("guild-bank")
local runtime = addon_table.use("translation_runtime")
local text = addon_table.use("guild_ui_text")
local fonts = addon_table.use("fonts")
local resolver = addon_table.use("translation_resolver")
ui.verified_build = "1.60.1.70888"

local function skip(region)
    local parent = region:GetParent()
    if not parent then return true end
    if parent:GetObjectType() == "EditBox" then
        return region ~= parent.Instructions and region ~= parent.PromptText
    end
    -- The frame title is the guild name; tab titles and descriptions are editable.
    local frame = _G.GuildBankFrame
    return parent.TabTitle == region or parent.TitleText == region
        or frame and frame.TitleContainer == parent
end

local formats = { "NUM_GUILDBANK_TABS_PURCHASED", "GUILDBANK_REMAINING_MONEY" }
local function label(region)
    if not ui.visible(region) or runtime.is_applying(region) or skip(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated = text.format(source, formats, function (value)
        return text.format(value, { "STACKS" }) or resolver.find_ui(value) or value
    end)
    if translated then ui.apply(region, translated) else ui.label(region) end
end

local function tab_title(region)
    if not ui.visible(region) or runtime.is_applying(region) then return end
    local source = ui.text(region)
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local frame = _G.GuildBankFrame
    if not frame or not source then return end
    if frame.mode == "moneylog" or source == _G.BUY_GUILDBANK_TAB then
        local translated = resolver.find_ui(source)
        if translated then ui.apply(region, translated, "guild.bank.title") end
        return
    end
    local base, access = source, ""
    for _, key in ipairs({ "GUILDBANK_TAB_LOCKED", "GUILDBANK_TAB_WITHDRAW_ONLY",
        "GUILDBANK_TAB_DEPOSIT_ONLY", "GUILDBANK_TAB_FULL_ACCESS" }) do
        local value = runtime.safe_string_or_nil(_G[key])
        if value and source:sub(-#value - 2) == "  " .. value then
            base = source:sub(1, -#value - 3)
            access = "  " .. (resolver.find_ui(value) or value)
            break
        end
    end
    local translated = base
    if frame.mode == "log" or frame.mode == "tabinfo" then
        translated = text.format(base, { frame.mode == "log"
            and "GUILDBANK_LOG_TITLE_FORMAT" or "GUILDBANK_INFO_TITLE_FORMAT" }) or base
    end
    if translated .. access ~= source then
        ui.apply(region, translated .. access, "guild.bank.title")
    else runtime.invalidate(region) end
end

local function panel(frame)
    if not frame then return end
    ui.watch(frame.TabTitle, tab_title)
    ui.watch_frame(frame, skip, label)
    ui.hooks.region_script(frame, "OnShow", panel)
end

local function log()
    local frame = _G.GuildBankMessageFrame
    if not ui.visible(frame) or not runtime.can_write_text(frame)
        or type(frame.TransformMessages) ~= "function" then return end
    -- Transform the completed native log in place, preserving ordering, scroll,
    -- hyperlink payloads, colors and every trailing native metadata argument.
    local translated = {}
    local function matches(source)
        source = runtime.safe_string_or_nil(source)
        if not source then return false end
        local value = text.log_line(source)
        if value ~= source then translated[source] = value; return true end
        return false
    end
    local function replace(source, ...)
        return translated[source] or source, ...
    end
    fonts.apply_to_font_string(frame)
    pcall(frame.TransformMessages, frame, matches, replace)
end

local function refresh()
    if ui.surface then ui.surface.skip_region = skip end
    panel(_G.GuildBankFrame)
    panel(_G.GuildBankPopupFrame)
end

bank.prepare = function ()
    ui.prepare({ "GuildBankFrame", "GuildBankPopupFrame" }, "Blizzard_GuildBankUI", {}, {}, refresh)
    local frame = _G.GuildBankFrame
    ui.hooks.region(frame, "Update", panel)
    ui.hooks.region(_G.GuildBankPopupFrame, "Update", panel)
    ui.hooks.global("GuildBankFrame_UpdateLog", log)
    ui.hooks.global("GuildBankFrame_UpdateMoneyLog", log)
end
