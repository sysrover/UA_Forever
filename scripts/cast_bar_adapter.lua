local _, addon_table = ...

local adapter = addon_table.use("cast_bar_adapter")
local entries = addon_table.use("entries")
local client_db = addon_table.use("spell_client_db")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("cast-bar")

local states = {}
local driver
local is_secret = runtime.is_secret_value
local safe_string = runtime.safe_string_or_nil

local function field(owner, key)
    if is_secret(owner) or owner == nil then return nil end
    local ok, value = pcall(function () return owner[key] end)
    if ok and not is_secret(value) then return value end
end

local function call(owner, method)
    local callback = field(owner, method)
    if type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, owner)
    if ok and not is_secret(value) then return value end
end

local function hide(state)
    state.overlay:Hide()
    runtime.release(state.overlay.Text, "cast-bar")
    state.source = nil
end

local function translation(frame, source)
    -- Prefer approved domain names over the client compatibility database.
    local translated = entries.lookup_name("spell", source)
    if translated then return translated, "spell.name" end
    translated = strings.find_ui_translation(source, field(frame, "Text"))
    if translated then return translated, "cast.status" end
    local id = field(frame, "spellID")
    if type(id) == "number" and id > 0
        and client_db.get_english_name(id) == source then
        return client_db.get_name(id), "spell.name"
    end
end

local function sync_layout(state, region)
    local overlay = state.overlay
    local font_getter = field(region, "GetFont")
    if type(font_getter) == "function" then
        local ok, font, size, flags = pcall(font_getter, region)
        if ok and safe_string(font) and not is_secret(size)
            and type(size) == "number" and not is_secret(flags) then
            -- All font/layout writes belong to our own unprotected frame.
            overlay.Text:SetFont(font, size, flags or "")
            runtime.ensure_font(overlay.Text)
        end
    end
    local scale = call(region, "GetEffectiveScale")
    local parent_scale = call(_G.UIParent, "GetEffectiveScale")
    if type(scale) == "number" and type(parent_scale) == "number"
        and parent_scale > 0 then
        overlay:SetScale(scale / parent_scale)
    end
    local native_width = call(region, "GetStringWidth")
    local width = overlay.Text:GetStringWidth()
    local height = overlay.Text:GetStringHeight()
    overlay:SetSize(math.max(width, type(native_width) == "number"
        and native_width or 0, 1) + 8, math.max(height, 14) + 2)
    local strata = safe_string(call(state.frame, "GetFrameStrata"))
    if strata then overlay:SetFrameStrata(strata) end
    local level = call(state.frame, "GetFrameLevel")
    if type(level) == "number" then overlay:SetFrameLevel(level + 5) end
    local alpha = call(region, "GetEffectiveAlpha")
    if type(alpha) ~= "number" then return false end
    overlay:SetAlpha(alpha)
    return true
end

local function refresh(state)
    local frame = state.frame
    local region = field(frame, "Text")
    if not options.can_translate("translate_spell")
        or call(frame, "IsForbidden") == true
        or call(frame, "IsVisible") ~= true
        or call(region, "IsVisible") ~= true then
        hide(state)
        return
    end
    local source = safe_string(call(region, "GetText"))
    if not source then hide(state); return end
    local translated, slot = translation(frame, source)
    translated = safe_string(translated)
    if not translated or translated == source then hide(state); return end
    if slot == "spell.name" and not options.translate_name("spell") then
        hide(state)
        return
    end
    translated = utils.cap(translated)
    if state.source ~= source or state.translated ~= translated
        or not runtime.get(state.overlay.Text)
        or call(state.overlay.Text, "GetText") ~= translated then
        runtime.release(state.overlay.Text, "cast-bar")
        if not runtime.apply(state.overlay.Text, {
            owner = "cast-bar", slot = slot, source = source,
            translated = translated, option = "translate_spell",
            category = slot == "spell.name" and "spell" or nil,
            priority = runtime.PRIORITY.DOMAIN,
        }) then hide(state); return end
        state.source, state.translated = source, translated
    end
    if not sync_layout(state, region) then hide(state); return end
    state.overlay:Show()
end

local function register(frame)
    if not frame or states[frame] then return end
    local region = field(frame, "Text")
    if not region or call(frame, "IsForbidden") == true then return end
    -- Never write native cast text or parent an addon frame to PlayerFrame:
    -- native cast bars can be part of protected frame chains in combat.
    local overlay = _G.CreateFrame("Frame", nil, _G.UIParent)
    overlay:SetPoint("CENTER", region, "CENTER")
    overlay:SetSize(1, 1)
    overlay:EnableMouse(false)
    overlay.Background = overlay:CreateTexture(nil, "BACKGROUND")
    overlay.Background:SetAllPoints()
    overlay.Background:SetColorTexture(0, 0, 0, 1)
    overlay.Text = overlay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    overlay.Text:SetPoint("CENTER")
    overlay.Text:SetJustifyH("CENTER")
    overlay.Text:SetWordWrap(false)
    overlay:Hide()
    local state = { frame = frame, overlay = overlay }
    states[frame] = state
    local function update() refresh(state) end
    -- Post-hooks see the final spellID, display text and visibility state.
    for _, method in ipairs({ "HandleCastStart", "HandleInterruptOrSpellFailed",
        "HandleCastStop", "FinishSpell", "SimulateCast", "SetLook",
        "SetNameTextShown", "StartReplacingPlayerBarAt",
        "EndReplacingPlayerBar" }) do
        hooks.region(frame, method, update)
    end
    hooks.region_script(frame, "OnShow", update)
    hooks.region_script(frame, "OnHide", function () hide(state) end)
    -- Direct display writes also occur outside HandleCastStart. The ID lookup
    -- above accepts an ID only when its English name matches this exact text.
    hooks.region(region, "SetText", update)
    hooks.region(region, "Show", update)
    hooks.region(region, "Hide", update)
    hooks.region(region, "SetShown", update)
    refresh(state)
end

adapter.prepare = function ()
    if not _G.UIParent or type(_G.CreateFrame) ~= "function" then return end
    for _, name in ipairs({ "PlayerCastingBarFrame", "GamepadPlayerCastingBarFrame",
        "OverlayPlayerCastingBarFrame", "CastingBarFrame", "TargetFrameSpellBar",
        "FocusFrameSpellBar", "PetCastingBarFrame" }) do
        register(_G[name])
    end
    if driver then return end
    driver = _G.CreateFrame("Frame", nil, _G.UIParent)
    local elapsed_total = 0
    driver:SetScript("OnUpdate", function (_, elapsed)
        elapsed_total = elapsed_total + elapsed
        if elapsed_total < 0.05 then return end
        elapsed_total = 0
        -- Follow native fading, parent visibility and option changes without
        -- reading cast timing, protected cast flags or secret spell data.
        for _, state in pairs(states) do refresh(state) end
    end)
end
