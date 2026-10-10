local _, addon_table = ...

local popup_ui = addon_table.use("popup_ui")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").menus
local auto_scan = addon_table.use("auto_scan")
local strings = addon_table.use("strings")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local hooks = addon_table.use("translation_hooks").bind("popup_ui")

local dynamic_dialogs = {
    DEATH = true,
    XP_LOSS = true, VOICE_CHAT_JOIN_GROUP = true,
    GROUP_INVITE_CONFIRMATION = true, PARTY_INVITE = true,
    DUEL_REQUESTED = true, DUEL_TO_THE_DEATH_REQUESTED = true,
    PET_BATTLE_PVP_DUEL_REQUESTED = true, TRADE = true,
    CHAT_CHANNEL_INVITE = true, CONFIRM_SUMMON = true,
    CONFIRM_SUMMON_STARTING_AREA = true, CONFIRM_SUMMON_SCENARIO = true,
}

local group_invite_dialogs = {
    GROUP_INVITE_CONFIRMATION = true, PARTY_INVITE = true,
}

local menu_walks = {
    popup = { id = "rendered-static-popup", surface = "popup",
        owner = "menus", reason = "ANONYMOUS_POPUP_LAYOUT" },
}

local function capture_auto_frame(frame)
    if frame and type(auto_scan.diagnostics_enabled) == "function"
        and auto_scan.diagnostics_enabled()
        and type(strings.capture_frame) == "function" then
        strings.capture_frame(frame)
    end
end

local function translate_and_capture_frame(frame)
    if not frame then return end
    if type(strings.translate_frame) == "function" then
        strings.translate_frame(frame, nil, menu_walks.popup)
    end
    capture_auto_frame(frame)
end

local function popup_text_region(dialog)
    if not dialog then return nil end
    if type(dialog.GetTextFontString) == "function" then
        local ok, region = pcall(dialog.GetTextFontString, dialog)
        if ok and region then return region end
    end
    local name
    if type(dialog.GetName) == "function" then
        local ok, value = pcall(dialog.GetName, dialog)
        if ok and type(value) == "string" then name = value end
    end
    return dialog.text or dialog.Text or name and _G[name .. "Text"]
end

local function resize_popup_for_text(dialog, text)
    if not dialog or type(text) ~= "string" or type(dialog.Resize) ~= "function"
        or dialog.uaForeverLayoutText == text then return end
    dialog.uaForeverLayoutText = text
    pcall(dialog.Resize, dialog)
end

local function translate_dynamic_popup(dialog)
    if not dialog or not dynamic_dialogs[dialog.which] then return end
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    source = ok and runtime.safe_string_or_nil(source) or nil
    if not source then return end
    -- A player's name or a destination may already be Ukrainian while the
    -- surrounding client template is still English. Resolve the whole message.
    local translated = resolver.find_ui(source, region)
    if not translated or translated == source then return end
    if runtime.apply(region, {
        owner = "popup", slot = "dynamic.message", source = source,
        translated = translated, option = "translate_string",
        priority = runtime.PRIORITY.CONTEXT,
    }) then
        resize_popup_for_text(dialog, translated)
    end
end

local function translate_exit_countdown(dialog)
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    local count = ok and type(source) == "string"
        and (source:match("^(%d+) Seconds until exit$")
            or source:match("^(%d+) Seconds until logout$"))
    if not count then return end
    local applied = runtime.apply(region, {
        owner = "popup", slot = dialog.which == "CAMP"
            and "logout.countdown" or "quit.countdown", source = source,
        translated = surface_text.quit_countdown(count),
        priority = runtime.PRIORITY.CONTEXT,
    })
    if applied then resize_popup_for_text(dialog, surface_text.quit_countdown(count)) end
end

local function popup_button(dialog, getter)
    if not dialog then return end
    local button
    if type(dialog[getter]) == "function" then
        local ok, value = pcall(dialog[getter], dialog)
        if ok then button = value end
    end
    if not button then
        local number = getter:match("(%d+)$")
        local name
        if type(dialog.GetName) == "function" then
            local ok, value = pcall(dialog.GetName, dialog)
            if ok and type(value) == "string" then name = value end
        end
        button = dialog["button" .. number]
            or name and _G[name .. "Button" .. number]
    end
    return button
end

local function translate_popup_button(dialog, getter)
    local button = popup_button(dialog, getter)
    if not button or type(button.GetFontString) ~= "function" then return end
    local text_ok, region = pcall(button.GetFontString, button)
    if text_ok then strings.translate_region(region) end
end

local function prepare_group_invite_buttons(dialog)
    if not dialog or not group_invite_dialogs[dialog.which] then return end
    for _, getter in ipairs({ "GetButton1", "GetButton2" }) do
        local button = popup_button(dialog, getter)
        if button and type(button.GetFontString) == "function" then
            local text_ok, region = pcall(button.GetFontString, button)
            if text_ok and region then
                local function refresh(written)
                    -- The dialog and its buttons are pooled. A stored hook
                    -- must only translate the current visible invitation.
                    if not group_invite_dialogs[dialog.which]
                        or popup_button(dialog, getter) ~= button then return end
                    local shown_ok, shown = pcall(dialog.IsShown, dialog)
                    if not shown_ok or runtime.is_secret_value(shown)
                        or shown ~= true then return end
                    local current_ok, current = pcall(button.GetFontString, button)
                    if not current_ok or not current
                        or (written and written ~= button and written ~= current)
                        or runtime.is_applying(current) then return end
                    -- Keep the shared runtime's protected/secret-value and
                    -- combat guards; only the existing label is translated.
                    strings.translate_region(current)
                end
                -- Native code can write through either the Button or its
                -- FontString after the initial popup translation pass.
                hooks.region(button, "SetText", refresh)
                hooks.region(button, "SetFormattedText", refresh)
                hooks.region(region, "SetText", refresh)
                hooks.region(region, "SetFormattedText", refresh)
                refresh()
            end
        end
    end
end

local function translate_home_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    local text_ok, source
    if region then text_ok, source = pcall(region.GetText, region) end
    if not text_ok or type(source) ~= "string"
        or source:gsub("%s+", " "):match("^%s*(.-)%s*$") ~=
            "Do you want to make Thunderbrew Distillery your new home?" then
        return false
    end
    if strings.translate_region(region) and type(dialog.Resize) == "function" then
        pcall(dialog.Resize, dialog)
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function translate_resurrection_popup(dialog)
    if not dialog then return false end
    local shown_ok, shown = pcall(dialog.IsShown, dialog)
    if not shown_ok or not shown then return false end
    local region = popup_text_region(dialog)
    if not region or type(region.GetText) ~= "function" then return false end
    local text_ok, source = pcall(region.GetText, region)
    if not text_ok or type(source) ~= "string" then return false end
    local normalized = source:gsub("%s+", " ")
    local name, seconds = normalized:match(
        "^(.-) wants to resurrect you and will be able to in (%d+) seconds?$")
    local sickness
    if not name then
        name, seconds = normalized:match(
            "^(.-) wants to resurrect you and will be able to in (%d+) seconds?%. You will be afflicted with resurrection sickness%.$")
        sickness = name ~= nil
    end
    if not name then
        name = normalized:match("^(.-) wants to resurrect you$")
        if not name then
            name = normalized:match(
                "^(.-) wants to resurrect you%. You will be afflicted with resurrection sickness%.$")
            sickness = name ~= nil
        end
    end
    if not name then return false end
    local translated = surface_text.resurrection(name, seconds, sickness)
    local applied = runtime.apply(region, {
        owner = "popup", slot = "resurrection.message", source = source,
        translated = translated, priority = runtime.PRIORITY.CONTEXT,
    })
    if applied then resize_popup_for_text(dialog, translated) end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
    return true
end

local function refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and (translate_home_popup(dialog)
            or translate_resurrection_popup(dialog)) then return end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        if translate_home_popup(dialog) or translate_resurrection_popup(dialog) then
            return
        end
    end
end

local function refresh_and_scan_popups(which, data)
    refresh_home_popups(which, data)
    local find = _G.StaticPopup_FindVisible
    if type(find) == "function" and which then
        local ok, dialog = pcall(find, which, data)
        if ok and dialog then
            prepare_group_invite_buttons(dialog)
            translate_dynamic_popup(dialog)
            translate_and_capture_frame(dialog)
            return
        end
    end
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        local shown_ok, shown = dialog and pcall(dialog.IsShown, dialog)
        if shown_ok and shown then
            prepare_group_invite_buttons(dialog)
            translate_dynamic_popup(dialog)
            translate_and_capture_frame(dialog)
        end
    end
end

local function after_static_popup_show(which, _, _, data)
    -- The bind-point text and buttons can be assigned after StaticPopup_Show
    -- returns, so inspect the rendered popup on the next frame as well.
    scheduler.request("home-popup:immediate", nil, function()
        refresh_and_scan_popups(which, data)
    end)
    scheduler.request("home-popup:retry", nil, function()
        refresh_and_scan_popups(which, data)
    end, 0.1)
    local find = _G.StaticPopup_FindVisible
    if type(find) ~= "function" then return end
    local ok, dialog = pcall(find, which, data)
    if not ok or not dialog then return end
    -- StaticPopup frames are pooled. A new show may reset native dimensions
    -- even when its translated countdown/message equals the previous show.
    dialog.uaForeverLayoutText = nil
    local region = popup_text_region(dialog)
    if dynamic_dialogs[which] then
        prepare_group_invite_buttons(dialog)
        translate_dynamic_popup(dialog)
        translate_popup_button(dialog, "GetButton1")
        translate_popup_button(dialog, "GetButton2")
        if which == "DEATH" then translate_popup_button(dialog, "GetButton4") end
        return
    end
    if which ~= "GENERIC_CONFIRMATION" and which ~= "QUIT" and which ~= "CAMP"
        and not translate_home_popup(dialog)
        and not translate_resurrection_popup(dialog) then return end
    if which == "QUIT" or which == "CAMP" then
        translate_exit_countdown(dialog)
    elseif data and data.text == _G.SELL_ALL_JUNK_ITEMS_POPUP then
        if strings.translate_region(region) and type(dialog.Resize) == "function" then
            pcall(dialog.Resize, dialog)
        end
    end
    translate_popup_button(dialog, "GetButton1")
    translate_popup_button(dialog, "GetButton2")
end

local function after_static_popup_update(dialog)
    if not dialog then return end
    local which = dialog.which
    if which == "QUIT" or which == "CAMP" then
        translate_exit_countdown(dialog)
    elseif which == "DEATH" then
        -- The expiration formatter and DEATH.OnUpdate rewrite the message and
        -- release button every frame. Translate after both native callbacks.
        -- Native Resize also ran with English text, so refit the final message.
        dialog.uaForeverLayoutText = nil
        translate_dynamic_popup(dialog)
        translate_popup_button(dialog, "GetButton1")
        translate_popup_button(dialog, "GetButton4")
    elseif which == "RESURRECT" or which == "RESURRECT_NO_SICKNESS" then
        translate_resurrection_popup(dialog)
    elseif which == "XP_LOSS" or which == "CONFIRM_SUMMON" or which == "CONFIRM_SUMMON_STARTING_AREA"
        or which == "CONFIRM_SUMMON_SCENARIO" then
        -- GetExpirationText rewrites the native message as timeleft changes.
        translate_dynamic_popup(dialog)
    end
end

local function translate_cinematic_close_dialog(dialog)
    if not dialog then return end
    strings.translate_region(popup_text_region(dialog), nil,
        "cinematic.message", nil, nil, nil, "popups")
    for _, suffix in ipairs({ "ConfirmButton", "ResumeButton" }) do
        local button = _G["CinematicFrameCloseDialog" .. suffix]
        if button and type(button.GetFontString) == "function" then
            local ok, region = pcall(button.GetFontString, button)
            if ok then
                strings.translate_region(region, nil,
                    "cinematic." .. suffix, nil, nil, nil, "popups")
            end
        end
    end
end

popup_ui.prepare = function ()
    hooks.global("StaticPopup_Show", after_static_popup_show)
    hooks.global("StaticPopup_OnUpdate", after_static_popup_update)
    for index = 1, 4 do
        local dialog = _G["StaticPopup" .. index]
        hooks.region_script(dialog, "OnShow", function()
            prepare_group_invite_buttons(dialog)
            scheduler.request("home-popup:on-show", nil, refresh_and_scan_popups)
        end)
        prepare_group_invite_buttons(dialog)
    end

    -- This XML-owned confirmation bypasses StaticPopup_Show in build 70205.
    local cinematic = _G.CinematicFrame
    local dialog = cinematic and cinematic.closeDialog
        or _G.CinematicFrameCloseDialog
    hooks.region_script(dialog, "OnShow", translate_cinematic_close_dialog,
        "cinematic-close")
    translate_cinematic_close_dialog(dialog)
end
