local _, addon_table = ...

local fonts = addon_table.use("fonts")
local options = addon_table.use("options")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")
local auto_scan = addon_table.use("auto_scan")

runtime.PRIORITY = { GENERATED = 10, STATIC_UI = 20, CONTEXT = 30, DOMAIN = 40 }

runtime.priority_for_source = function (kind)
    if kind == "domain" then return runtime.PRIORITY.DOMAIN end
    if kind == "context" then return runtime.PRIORITY.CONTEXT end
    if kind == "generated" or kind == "generated_fallback" then
        return runtime.PRIORITY.GENERATED
    end
    return runtime.PRIORITY.STATIC_UI
end

local claims = setmetatable({}, { __mode = "k" })
local generations = setmetatable({}, { __mode = "k" })
local generation_instances = setmetatable({}, { __mode = "k" })
local writing = setmetatable({}, { __mode = "k" })

runtime.is_secret_value = function (value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

runtime.safe_string_or_nil = function (value)
    if runtime.is_secret_value(value) then return nil end
    if type(value) ~= "string" or value == "" then return nil end
    return value
end

local is_secret_value = runtime.is_secret_value

runtime.is_applying = function (region)
    return writing[region] == true
end

local safe_string = runtime.safe_string_or_nil

local function safe_text(region)
    if not region then return nil end
    local method_ok, get_text = pcall(function () return region.GetText end)
    if not method_ok or type(get_text) ~= "function" then return nil end
    local ok, value = pcall(get_text, region)
    if ok then return safe_string(value) end
end

local function record_runtime_result(region, spec, source, translated, reason)
    if type(auto_scan.record_runtime_result) ~= "function"
        or not options.account or not options.account.auto_scan_content then return end
    local surface_id
    if type(spec.surface) == "string" then
        surface_id = safe_string(spec.surface)
    elseif type(spec.surface) == "table" then
        local ok, id = pcall(function () return spec.surface.id end)
        if ok then surface_id = safe_string(id) end
    end
    local instance = spec.instance
    if type(instance) ~= "string" and type(instance) ~= "number" then
        instance = nil
    end
    auto_scan.record_runtime_result({
        owner = spec.owner, slot = spec.slot,
        source = source, translated = translated,
        surface = surface_id,
        generation = type(spec.generation) == "number" and spec.generation or nil,
        instance = instance,
        phase = spec.phase,
        lookupTier = spec.lookup_tier or spec.source_kind
            or (spec.category and "domain") or "adapter",
        catalogSource = spec.catalog_source,
    }, safe_text(region), reason)
end

local function schedule_post_apply_verification(region, claim, spec, display)
    if not options.account or not options.account.auto_scan_content
        or type(scheduler.request) ~= "function" then return end
    scheduler.request({
        id = "runtime-post-apply:" .. tostring(region),
        generation = claim.generation,
        surface = spec.surface or spec.tooltip,
        instance = region,
        callback = function ()
            if claims[region] ~= claim then return end
            local visible = safe_text(region)
            if visible ~= display then
                claims[region] = nil
                record_runtime_result(region, spec, claim.source,
                    claim.translated, "OVERWRITTEN_AFTER_APPLY")
            else
                record_runtime_result(region, spec, claim.source,
                    claim.translated, "RETAINED_AFTER_APPLY")
            end
        end,
    })
end

local function display_translation(claim)
    if claim.name_original and claim.category
        and not options.translate_name(claim.category) then
        return claim.name_original
    end
    return claim.translated
end

local function protected_frame_state(region)
    if not region or is_secret_value(region) then
        return nil, "PROTECTED_REGION"
    end
    local protected = false
    local frame = region
    for _ = 1, 5 do
        if not frame then break end
        for _, method in ipairs({ "IsForbidden", "IsProtected" }) do
            local method_ok, callback = pcall(function () return frame[method] end)
            if not method_ok or is_secret_value(callback) then
                return nil, "PROTECTED_REGION"
            end
            if type(callback) == "function" then
                local ok, value = pcall(callback, frame)
                if not ok or is_secret_value(value) then
                    return nil, "PROTECTED_REGION"
                end
                if value == true then
                    if method == "IsForbidden" then
                        return nil, "PROTECTED_REGION"
                    end
                    protected = true
                end
            end
        end
        local method_ok, get_parent = pcall(function () return frame.GetParent end)
        if not method_ok or is_secret_value(get_parent) then
            return nil, "PROTECTED_REGION"
        end
        if type(get_parent) ~= "function" then break end
        local parent_ok, parent = pcall(get_parent, frame)
        if not parent_ok or is_secret_value(parent) then
            return nil, "PROTECTED_REGION"
        end
        if parent == frame then break end
        frame = parent
    end
    return protected
end

runtime.can_write_text = function (region)
    local protected, reason = protected_frame_state(region)
    if protected == nil then return false, reason end
    if not protected then return true end
    if type(_G.InCombatLockdown) ~= "function" then return true end
    local combat_ok, in_combat = pcall(_G.InCombatLockdown)
    if not combat_ok or is_secret_value(in_combat) then
        return false, "PROTECTED_REGION"
    end
    if in_combat == true then return false, "PROTECTED_REGION" end
    return true
end

runtime.get = function (region)
    return claims[region]
end

runtime.for_each_claim = function (surface, callback)
    if not surface or type(callback) ~= "function" then return 0 end
    local snapshot = {}
    for region, claim in pairs(claims) do
        if claim.surface == surface then
            snapshot[#snapshot + 1] = { region = region, claim = claim }
        end
    end
    local count = 0
    for _, row in ipairs(snapshot) do
        if claims[row.region] == row.claim then
            callback(row.region, row.claim)
            count = count + 1
        end
    end
    return count
end

runtime.generation = function (surface)
    return generations[surface] or 0
end

runtime.generation_instance = function (surface)
    return generation_instances[surface]
end

local function stable_instance(value)
    if value == nil or is_secret_value(value) then return nil end
    local kind = type(value)
    if kind == "string" or kind == "number" or kind == "boolean" then
        return value
    end
end

runtime.begin_generation = function (surface, instance)
    if not surface or is_secret_value(surface) then return nil end
    local generation = (generations[surface] or 0) + 1
    generations[surface] = generation
    generation_instances[surface] = stable_instance(instance)
    for region, claim in pairs(claims) do
        if claim.surface == surface then claims[region] = nil end
    end
    return generation
end

runtime.release = function (region, owner, slot)
    local claim = region and claims[region]
    if not claim then return false end
    if owner and claim.owner ~= owner then return false end
    if slot and claim.slot ~= slot then return false end
    claims[region] = nil
    return true
end

runtime.invalidate = function (region)
    if not region or not claims[region] then return false end
    claims[region] = nil
    return true
end

-- Compatibility names for adapters migrated in later stages.
runtime.next_generation = runtime.begin_generation
runtime.clear = runtime.invalidate
runtime.clear_surface = runtime.begin_generation

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
    local allowed = runtime.can_write_text(region)
    if not allowed then return false end
    return fonts.apply_to_font_string(region)
end

runtime.apply = function (region, spec)
    if not region or not spec then return false end
    local translated = safe_string(spec.translated)
    if not translated then return false end
    local source_unsafe = spec.source_unsafe == true
        or is_secret_value(spec.source)
    if source_unsafe and type(auto_scan.record_unsafe_source) == "function" then
        auto_scan.record_unsafe_source(safe_string(spec.unsafe_context)
            or safe_string(spec.owner) or "translation-runtime")
    end
    local source = safe_string(spec.source) or safe_text(region)
    local allowed = runtime.allowed(spec)
    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then
        if allowed then
            record_runtime_result(region, spec, source, translated, "SetText недоступний")
        end
        return false
    end
    local write_allowed, write_reason = runtime.can_write_text(region)
    if not write_allowed then
        if allowed then
            record_runtime_result(region, spec, source, translated, write_reason)
        end
        return false
    end
    local name_original = safe_string(spec.name_original)
    local display = name_original and spec.category
        and not options.translate_name(spec.category)
        and name_original or translated
    local previous = claims[region]
    local generation = spec.generation or (spec.surface and runtime.generation(spec.surface)) or 0
    local instance = stable_instance(spec.instance)
        or (spec.surface and runtime.generation_instance(spec.surface))
    local priority = spec.priority or runtime.PRIORITY.STATIC_UI
    local phase = spec.phase or "direct"
    if phase == "dynamic" and (not spec.surface
        or type(generation) ~= "number" or generation <= 0
        or instance == nil) then
        if allowed then
            record_runtime_result(region, spec, source, translated,
                "DYNAMIC_CONTRACT_MISSING")
        end
        return false
    end

    -- A new Blizzard write to a pooled region begins a new claim. A lower
    -- priority pass cannot replace a still visible domain/context claim.
    if previous then
        local current = safe_text(region)
        local same_lifecycle = previous.owner == spec.owner
            or previous.surface and previous.surface == spec.surface
        local instance_changed = same_lifecycle and spec.instance ~= nil
            and previous.instance ~= instance
        local owner_generation_changed = previous.owner == spec.owner
            and previous.surface == spec.surface
            and previous.generation ~= generation
        if instance_changed or owner_generation_changed
            or current and current ~= previous.translated
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
        and (previous.priority > priority
            or (previous.generation == generation
                and previous.owner == spec.owner and previous.slot ~= spec.slot)
            or (previous.priority == priority and previous.owner ~= spec.owner)) then
        record_runtime_result(region, spec, source, translated, "CLAIM_CONFLICT")
        return false, "CLAIM_CONFLICT"
    end
    if not allowed then
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
        record_runtime_result(region, spec, source, translated)
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

    if options.can_translate("override_system_fonts") then
        local font_ok = runtime.ensure_font(region)
        if not font_ok and display:find("[\208\209]") then
            record_runtime_result(region, spec, source, translated, "шрифт не застосувався")
            return false
        end
    end
    writing[region] = true
    local ok = pcall(set_text, region, display)
    writing[region] = nil
    if not ok then
        record_runtime_result(region, spec, source, translated, "SetText завершився помилкою")
        return false
    end
    if safe_text(region) ~= display then
        record_runtime_result(region, spec, source, translated, "APPLY_FAILED")
        return false
    end
    local claim = {
        owner = spec.owner or "ui", slot = spec.slot or "ui.text",
        priority = priority, source = source, translated = translated,
        name_original = name_original,
        generation = generation, instance = instance,
        surface = spec.surface, phase = phase,
        category = spec.category,
        option = spec.option,
        options = spec.options,
        lookup_tier = spec.lookup_tier,
        catalog_source = spec.catalog_source,
        after_visibility = spec.after_visibility,
    }
    claims[region] = claim
    if spec.after_apply then pcall(spec.after_apply, region, source) end
    if spec.after_visibility then pcall(spec.after_visibility, region) end
    record_runtime_result(region, spec, source, translated)
    schedule_post_apply_verification(region, claim, spec, display)
    return true
end

runtime.show_original = function (region, show)
    local claim = claims[region]
    if not claim then return false end
    local write_allowed = runtime.can_write_text(region)
    if not write_allowed then return false end
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
    local write_allowed = runtime.can_write_text(tooltip)
    if not write_allowed then return false end
    local method_ok, add_line = pcall(function () return tooltip.AddLine end)
    if not method_ok or type(add_line) ~= "function" then return false end
    return pcall(add_line, tooltip, translated, r or 1, g or 1, b or 1, true)
end

runtime.set_fallback_text = function (region, text)
    if not region or type(text) ~= "string" then return false end
    local write_allowed = runtime.can_write_text(region)
    if not write_allowed then return false end
    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then return false end
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
