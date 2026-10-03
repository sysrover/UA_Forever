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
local FRAME_NAMES = { "PlayerCastingBarFrame", "GamepadPlayerCastingBarFrame",
    "OverlayPlayerCastingBarFrame", "CastingBarFrame", "TargetFrameSpellBar",
    "FocusFrameSpellBar", "PetCastingBarFrame" }
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

local function release(state, reason)
    runtime.release(state.region, "cast-bar")
    state.reason = reason
end

local function restore(state, reason)
    local current = safe_string(call(state.region, "GetText"))
    if state.source and state.translated and current == state.translated then
        local allowed, failure, detail = runtime.can_write_text(state.region, true)
        if not allowed then
            state.reason = failure or "RESTORE_FAILED"
            state.lastWrite = { mode = "restore", ok = false, reason = failure, detail = detail }
            return
        end
        state.writing = true
        local ok, error_text = pcall(state.region.SetText, state.region, state.source)
        state.writing = false
        state.lastWrite = { mode = "restore", ok = ok, error = not ok and safe_string(error_text) or nil }
        if not ok then state.reason = "RESTORE_FAILED"; return end
    end
    release(state, reason)
end

local function refresh(state)
    local frame, region = state.frame, state.region
    if state.writing or runtime.is_applying(region) then return end
    if call(frame, "IsForbidden") == true then
        release(state, "FORBIDDEN_FRAME"); return
    end
    local visible = safe_string(call(region, "GetText"))
    if not visible then release(state, "SOURCE_UNREADABLE"); return end
    if not options.can_translate("translate_spell") then
        restore(state, "OPTION_DISABLED"); return
    end
    if call(frame, "IsVisible") ~= true then
        release(state, "FRAME_NOT_VISIBLE"); return
    end
    if call(region, "IsVisible") ~= true then
        release(state, "TEXT_NOT_VISIBLE"); return
    end
    -- The native region now contains our translation. Recover the original
    -- only when it still matches the exact value we last wrote to this bar.
    local source = visible == state.translated and state.source or visible
    local translated, slot = translation(frame, source)
    translated = safe_string(translated)
    if not translated or translated == source then
        release(state, "LOOKUP_FAILED"); return
    end
    if slot == "spell.name" and not (options.name_enabled and options.name_enabled({
        owner = "cast-bar", slot = slot, category = "spell" })
        or not options.name_enabled and options.translate_name("spell")) then
        restore(state, "NAME_OPTION_DISABLED"); return
    end
    translated = utils.cap(translated)
    if visible == translated and runtime.get(region)
        and state.source == source and state.translated == translated then
        state.reason = "TRANSLATION_VISIBLE"
        return
    end
    runtime.release(region, "cast-bar")
    state.source, state.translated, state.slot = source, translated, slot
    state.writing = true
    -- Always use the text-only path: no font, parent, anchor or size writes,
    -- including outside combat. Public text is guarded by the shared runtime.
    local ok, applied, failure = pcall(runtime.apply, region, {
        owner = "cast-bar", slot = slot, source = source,
        translated = translated, option = "translate_spell",
        category = slot == "spell.name" and "spell" or nil,
        priority = runtime.PRIORITY.DOMAIN, combat_text_only = true,
        defer_if_protected = false,
    })
    state.writing = false
    local readback = safe_string(call(region, "GetText"))
    state.lastWrite = { mode = "direct", ok = ok and applied == true,
        source = source, translated = translated, readback = readback,
        error = not ok and safe_string(applied) or nil,
        reason = ok and safe_string(failure) or nil }
    state.reason = not ok and "APPLY_ERROR"
        or not applied and (safe_string(failure) or "APPLY_FAILED")
        or readback == translated and "TRANSLATION_VISIBLE" or "READBACK_MISMATCH"
end

local function register(frame)
    if not frame or states[frame] then return end
    local region = field(frame, "Text")
    if not region or call(frame, "IsForbidden") == true then return end
    local state = { frame = frame, region = region, reason = "REGISTERED" }
    states[frame] = state
    local function update() refresh(state) end
    for _, method in ipairs({ "HandleCastStart", "HandleInterruptOrSpellFailed",
        "HandleCastStop", "FinishSpell", "SimulateCast", "SetLook",
        "SetNameTextShown", "StartReplacingPlayerBarAt",
        "EndReplacingPlayerBar" }) do
        hooks.region(frame, method, update)
    end
    hooks.region_script(frame, "OnShow", update)
    hooks.region_script(frame, "OnHide", function () release(state, "FRAME_NOT_VISIBLE") end)
    -- Direct writers and successive casts are handled in the same call. The
    -- writing guards above prevent recursion when runtime.apply calls SetText.
    hooks.region(region, "SetText", update)
    hooks.region(region, "Show", update)
    hooks.region(region, "Hide", update)
    hooks.region(region, "SetShown", update)
    refresh(state)
end

adapter.prepare = function ()
    for _, name in ipairs(FRAME_NAMES) do register(_G[name]) end
    if driver or not _G.UIParent or type(_G.CreateFrame) ~= "function" then return end
    driver = _G.CreateFrame("Frame", nil, _G.UIParent)
    local elapsed_total = 0
    driver:SetScript("OnUpdate", function (_, elapsed)
        elapsed_total = elapsed_total + elapsed
        if elapsed_total < 0.05 then return end
        elapsed_total = 0
        -- Retry later native writes and react to policy changes. Stable text
        -- does not cause additional SetText calls.
        for _, state in pairs(states) do refresh(state) end
    end)
end

-- Capture public scalar values only. The probe never refreshes or changes UI.
local function probe(owner, key, method)
    local result = {}
    if not owner then result.available = false; return result end
    local ok, value = pcall(function () return owner[key] end)
    if not ok then result.error = safe_string(value); return result end
    if is_secret(value) then result.secret = true; return result end
    if method then
        result.available = type(value) == "function"
        if not result.available then return result end
        ok, value = pcall(value, owner)
    else
        result.available = true
    end
    result.ok = ok
    if not ok then result.error = safe_string(value); return result end
    result.secret = is_secret(value)
    if result.secret then return result end
    local kind = type(value)
    if kind == "string" or kind == "number" or kind == "boolean" then
        result.value = value
    end
    return result
end

local function capture_region(region, frame)
    local result = {}
    for _, method in ipairs({ "GetText", "IsShown", "IsVisible", "GetAlpha",
        "GetEffectiveScale", "IsIgnoringParentAlpha", "GetWidth", "GetHeight",
        "GetLeft", "GetTop" }) do
        result[method] = probe(region, method, true)
    end
    if frame then result.GetEffectiveAlpha = probe(region, "GetEffectiveAlpha", true) end
    return result
end

adapter.capture = function ()
    local report = { version = 2, mode = "direct", frames = {}, visibleCount = 0,
        translatedCount = 0, registeredCount = 0,
        driverReady = driver ~= nil, sourceBuild = client_db.source_build,
        translationEnabled = options.can_translate("translate_spell"),
        spellNamesEnabled = options.translate_name("spell"),
        uiParent = capture_region(_G.UIParent, true) }
    if type(_G.GetTime) == "function" then
        local ok, value = pcall(_G.GetTime)
        if ok and not is_secret(value) and type(value) == "number" then
            report.uptime = value
        end
    end
    if type(_G.time) == "function" then
        local ok, value = pcall(_G.time)
        if ok and not is_secret(value) and type(value) == "number" then
            report.timestamp = value
        end
    end
    if type(_G.GetBuildInfo) == "function" then
        local ok, version, build, date, interface = pcall(_G.GetBuildInfo)
        if ok then
            report.client = { version = safe_string(version), build = safe_string(build),
                date = safe_string(date) }
            if not is_secret(interface) and type(interface) == "number" then
                report.client.interface = interface
            end
        end
    end
    for _, name in ipairs(FRAME_NAMES) do
        local frame = _G[name]
        local state = frame and states[frame]
        local region = field(frame, "Text")
        local row = { name = name, exists = frame ~= nil, registered = state ~= nil,
            frame = capture_region(frame, true), native = capture_region(region),
            spellID = probe(frame, "spellID"), unit = probe(frame, "unit"),
            isTradeSkillShown = probe(frame, "showTradeSkills"),
            forbidden = probe(frame, "IsForbidden", true),
            reason = state and state.reason or "NOT_REGISTERED" }
        if state then
            report.registeredCount = report.registeredCount + 1
            row.source = state.source
            row.lastWrite = state.lastWrite
            row.expectedTranslation = state.translated
            local claim = runtime.get(region)
            if claim then
                row.claim = {}
                for _, key in ipairs({ "owner", "slot", "source", "translated",
                    "category", "priority", "visible_original", "font_ready" }) do
                    row.claim[key] = probe(claim, key)
                end
            end
        end
        local visible = safe_string(row.native.GetText.value)
        local source = state and visible == state.translated and state.source or visible
        if source then
            row.availableTranslation, row.slot = translation(frame, source)
            row.availableTranslation = safe_string(row.availableTranslation)
        end
        if row.frame.IsVisible.value == true then
            report.visibleCount = report.visibleCount + 1
        end
        local alpha = row.frame.GetEffectiveAlpha.value
        local text_alpha = row.native.GetAlpha.value
        row.translationVisible = row.frame.IsVisible.value == true
            and row.native.IsVisible.value == true
            and type(alpha) == "number" and alpha > 0
            and type(text_alpha) == "number" and text_alpha > 0
            and row.availableTranslation ~= nil
            and visible == utils.cap(row.availableTranslation)
        if row.translationVisible then report.translatedCount = report.translatedCount + 1 end
        report.frames[#report.frames + 1] = row
    end
    report.status = report.visibleCount > 0 and "captured" or "no_visible_bars"
    return report
end
