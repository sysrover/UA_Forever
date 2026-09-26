local _, addon_table = ...

local fonts = addon_table.use("fonts")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")

runtime.PRIORITY = { GENERATED = 10, STATIC_UI = 20, CONTEXT = 30, DOMAIN = 40 }

runtime.priority_for_source = function (kind)
    if kind == "domain" then return runtime.PRIORITY.DOMAIN end
    if kind == "context" then return runtime.PRIORITY.CONTEXT end
    if kind == "generated" or kind == "reviewed" then
        return runtime.PRIORITY.GENERATED
    end
    return runtime.PRIORITY.STATIC_UI
end

local claims = setmetatable({}, { __mode = "k" })
local generations = setmetatable({}, { __mode = "k" })
local writing = setmetatable({}, { __mode = "k" })

local function is_secret_value(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

runtime.is_applying = function (region)
    return writing[region] == true
end

local function safe_string(value)
    if is_secret_value(value) then return nil end
    if type(value) == "string" and value ~= "" then return value end
end

local function safe_text(region)
    if not region then return nil end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return nil end
    local ok, value = pcall(get_text, region)
    if ok then return safe_string(value) end
end

local function display_translation(claim)
    if claim.name_original and claim.category
        and not options.translate_name(claim.category) then
        return claim.name_original
    end
    return claim.translated
end

local function protected_in_combat(region)
    if type(_G.InCombatLockdown) ~= "function" then return false end
    local combat_ok, in_combat = pcall(_G.InCombatLockdown)
    if not combat_ok or is_secret_value(in_combat) then return true end
    if not in_combat then return false end
    local frame = region
    for _ = 1, 5 do
        if not frame then break end
        for _, method in ipairs({ "IsForbidden", "IsProtected" }) do
            local method_ok, callback = pcall(function () return frame[method] end)
            if method_ok and type(callback) == "function" then
                local ok, value = pcall(callback, frame)
                if not ok or is_secret_value(value) or value then return true end
            end
        end
        local parent_ok, parent = pcall(function ()
            return type(frame.GetParent) == "function" and frame:GetParent() or nil
        end)
        if not parent_ok or is_secret_value(parent) or parent == frame then break end
        frame = parent
    end
    return false
end

runtime.get = function (region)
    return claims[region]
end

runtime.generation = function (surface)
    return generations[surface] or 0
end

runtime.next_generation = function (surface)
    if not surface then return nil end
    local generation = (generations[surface] or 0) + 1
    generations[surface] = generation
    return generation
end

runtime.clear = function (region)
    claims[region] = nil
end

runtime.clear_surface = function (surface)
    if surface then runtime.next_generation(surface) end
end

runtime.allowed = function (spec)
    if not options.can_translate() then return false end
    if spec and spec.option and not options.can_translate(spec.option) then return false end
    for _, option in ipairs(spec and spec.options or {}) do
        if not options.can_translate(option) then return false end
    end
    if not spec or not spec.category or not spec.slot
        or not spec.slot:match("%.name$") then return true end
    return options.translate_name(spec.category)
end

runtime.ensure_font = function (region)
    if not region or protected_in_combat(region) then return false end
    return fonts.apply_to_font_string(region)
end

runtime.apply = function (region, spec)
    if not region or not spec then return false end
    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then return false end
    local combat_protected = protected_in_combat(region)
    -- A unit tooltip's rendered FontStrings may still accept SetText while
    -- their protected parent cannot be resized or have its font changed.
    -- Limit this attempt to known tooltip and cast-bar text paths; pcall
    -- below handles clients that also reject SetText on the region itself.
    if combat_protected and not (spec.combat_tooltip_text
        or spec.combat_cast_bar_text) then return false end
    local translated = safe_string(spec.translated)
    if not translated then return false end
    local name_original = safe_string(spec.name_original)
    local display = name_original and spec.category
        and not options.translate_name(spec.category)
        and name_original or translated
    local source = safe_string(spec.source) or safe_text(region)
    local previous = claims[region]
    local generation = spec.generation or (spec.surface and runtime.generation(spec.surface)) or 0
    local priority = spec.priority or runtime.PRIORITY.STATIC_UI
    local phase = spec.phase or "dynamic"

    -- A new Blizzard write to a pooled region begins a new claim. A lower
    -- priority pass cannot replace a still visible domain/context claim.
    if previous then
        local current = safe_text(region)
        if current and current ~= previous.translated
            and current ~= previous.name_original and current ~= previous.source then
            previous = nil
            claims[region] = nil
        elseif current and current == previous.source
            and (previous.generation ~= generation or not previous.visible_original) then
            previous = nil
            claims[region] = nil
        end
    end
    if previous
        and (previous.phase == "static" and phase ~= "static"
            or previous.priority > priority
            or (previous.generation == generation
                and previous.owner == spec.owner and previous.slot ~= spec.slot)
            or (previous.priority == priority and previous.owner ~= spec.owner)) then
        return false
    end
    if not runtime.allowed(spec) then
        if previous then
            runtime.show_original(region, true)
        elseif spec.category and spec.slot and spec.slot:match("%.name$")
            and source then
            runtime.restore_source(region, source)
        end
        return false
    end
    if previous and previous.generation == generation
        and previous.owner == spec.owner and previous.slot == spec.slot
        and previous.source == source and previous.translated == translated
        and previous.name_original == name_original
        and not previous.visible_original and safe_text(region) == display then
        return true
    end

    -- Preserve the first readable English source of this tooltip generation.
    if previous and previous.generation == generation
        and previous.owner == spec.owner and previous.slot == spec.slot then
        source = previous.source or source
    end
    if not source and (spec.tooltip or not spec.allow_unknown_source) then return false end
    if source == display then return false end
    if spec.tooltip and spec.tooltip.uaForeverShowOriginal then return false end

    if options.can_translate("override_system_fonts") and not combat_protected then
        local font_ok = runtime.ensure_font(region)
        if not font_ok and display:find("[\208\209]") then return false end
    end
    writing[region] = true
    local ok = pcall(set_text, region, display)
    writing[region] = nil
    if not ok then return false end
    claims[region] = {
        owner = spec.owner or "ui", slot = spec.slot or "ui.text",
        priority = priority, source = source, translated = translated,
        name_original = name_original,
        generation = generation, surface = spec.surface, phase = phase,
        category = spec.category,
        option = spec.option,
        options = spec.options,
        after_visibility = spec.after_visibility,
    }
    if spec.after_apply then pcall(spec.after_apply, region, source) end
    if spec.after_visibility then pcall(spec.after_visibility, region) end
    return true
end

runtime.show_original = function (region, show)
    local claim = claims[region]
    if not claim then return false end
    if protected_in_combat(region) then return false end
    local policy_original = not options.can_translate()
        or claim.option and not options.can_translate(claim.option)
    for _, option in ipairs(claim.options or {}) do
        if not options.can_translate(option) then policy_original = true end
    end
    if claim.category and claim.slot:match("%.name$")
        and not claim.name_original
        and not options.translate_name(claim.category) then
        policy_original = true
    end
    local visible_original = show == true or policy_original == true
    local text = visible_original and claim.source or display_translation(claim)
    if not safe_string(text) then return false end
    if claim.visible_original == visible_original and safe_text(region) == text then
        return true
    end
    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then return false end
    writing[region] = true
    local ok = pcall(set_text, region, text)
    writing[region] = nil
    if ok then
        claim.visible_original = visible_original
        if claim.after_visibility then pcall(claim.after_visibility, region) end
    end
    return ok
end

runtime.refresh_policy = function ()
    for region, claim in pairs(claims) do
        local shown = true
        local method_ok, is_shown = pcall(function () return region.IsShown end)
        if method_ok and type(is_shown) == "function" then
            local ok, value = pcall(is_shown, region)
            shown = ok and not is_secret_value(value) and value == true
        end
        if shown then
            local name_disabled = claim.category and claim.slot:match("%.name$")
                and not options.translate_name(claim.category)
            local option_disabled = claim.option and not options.can_translate(claim.option)
            for _, option in ipairs(claim.options or {}) do
                if not options.can_translate(option) then option_disabled = true end
            end
            runtime.show_original(region, not options.can_translate() or option_disabled or name_disabled)
        end
    end
end

runtime.add_fallback = function (tooltip, translated, r, g, b)
    if not tooltip or not safe_string(translated) then return false end
    local method_ok, add_line = pcall(function () return tooltip.AddLine end)
    if not method_ok or type(add_line) ~= "function" then return false end
    if protected_in_combat(tooltip) then return false end
    return pcall(add_line, tooltip, translated, r or 1, g or 1, b or 1, true)
end

runtime.set_fallback_text = function (region, text)
    if not region or type(text) ~= "string" then return false end
    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then return false end
    if protected_in_combat(region) then return false end
    writing[region] = true
    local ok = pcall(set_text, region, text)
    writing[region] = nil
    return ok
end

runtime.restore_source = function (region, source)
    if not safe_string(source) or not region then return false end
    local current = safe_text(region)
    if not current then return false end
    if current == source then return true end
    return runtime.set_fallback_text(region, source)
end
