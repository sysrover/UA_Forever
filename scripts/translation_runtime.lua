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
local deferred_writes = setmetatable({}, { __mode = "k" })
local deferred_layouts = setmetatable({}, { __mode = "k" })
local claim_surfaces = setmetatable({}, { __mode = "k" })
local deferred_surfaces = setmetatable({}, { __mode = "k" })
local claim_scalar_surfaces = {}
local deferred_scalar_surfaces = {}
local performance_surfaces = setmetatable({}, { __mode = "k" })
local performance_scalar_surfaces = {}
local performance_totals = {}
local verification_surfaces = setmetatable({}, { __mode = "k" })
local verification_scalar_surfaces = {}

local function indexed_bucket(object_index, scalar_index, surface, create)
    if surface == nil then return nil end
    local kind = type(surface)
    local object_surface = kind == "table" or kind == "userdata"
        or kind == "thread" or kind == "function"
    local index = object_surface and object_index or scalar_index
    local key = object_surface and surface or kind .. ":" .. tostring(surface)
    local bucket = index[key]
    if not bucket and create then
        bucket = setmetatable({}, { __mode = "k" })
        index[key] = bucket
    end
    return bucket, index, key
end

local function unindex_region(object_index, scalar_index, surface, region)
    local bucket, index, key = indexed_bucket(object_index, scalar_index,
        surface, false)
    if not bucket then return end
    bucket[region] = nil
    if next(bucket) == nil then index[key] = nil end
end

local function clear_claim(region)
    local claim = claims[region]
    if not claim then return false end
    unindex_region(claim_surfaces, claim_scalar_surfaces,
        claim.surface, region)
    claims[region] = nil
    return true
end

local function put_claim(region, claim)
    clear_claim(region)
    claims[region] = claim
    local bucket = indexed_bucket(claim_surfaces, claim_scalar_surfaces,
        claim.surface, true)
    if bucket then bucket[region] = claim end
end

local function clear_deferred(region)
    local spec = deferred_writes[region]
    if not spec then return false end
    unindex_region(deferred_surfaces, deferred_scalar_surfaces,
        spec.surface, region)
    deferred_writes[region] = nil
    return true
end

local function put_deferred(region, spec)
    clear_deferred(region)
    deferred_writes[region] = spec
    local bucket = indexed_bucket(deferred_surfaces, deferred_scalar_surfaces,
        spec.surface, true)
    if bucket then bucket[region] = spec end
end

local function metrics_enabled()
    local account = options.account
    return account and (account.dev_mode == true
        or account.auto_scan_diagnostics == true)
end

runtime.metric = function (name, surface, generation, amount)
    if not metrics_enabled() or type(name) ~= "string" then return end
    amount = type(amount) == "number" and amount or 1
    performance_totals[name] = (performance_totals[name] or 0) + amount
    if surface == nil then return end
    local bucket = indexed_bucket(performance_surfaces,
        performance_scalar_surfaces, surface, true)
    if not bucket then return end
    local key = type(generation) == "number" and generation or 0
    local row = bucket[key]
    if not row then
        row = {}
        bucket[key] = row
    end
    row[name] = (row[name] or 0) + amount
end

local function add_duration(row, name, value)
    row._durations = row._durations or {}
    local sample = row._durations[name]
    if not sample then
        sample = { values = {}, next_index = 1, count = 0, sum = 0, max = 0 }
        row._durations[name] = sample
    end
    sample.count = sample.count + 1
    sample.sum = sample.sum + value
    sample.max = math.max(sample.max, value)
    sample.values[sample.next_index] = value
    sample.next_index = sample.next_index % 128 + 1
end

runtime.metric_duration = function (name, surface, generation, value)
    if not metrics_enabled() or type(name) ~= "string"
        or type(value) ~= "number" then return end
    add_duration(performance_totals, name, math.max(0, value))
    if surface == nil then return end
    local bucket = indexed_bucket(performance_surfaces,
        performance_scalar_surfaces, surface, true)
    local key = type(generation) == "number" and generation or 0
    local row = bucket[key]
    if not row then row = {}; bucket[key] = row end
    add_duration(row, name, math.max(0, value))
end

runtime.performance_snapshot = function (surface, generation)
    local source = performance_totals
    if surface ~= nil then
        local bucket = indexed_bucket(performance_surfaces,
            performance_scalar_surfaces, surface, false)
        source = bucket and bucket[type(generation) == "number"
            and generation or runtime.generation(surface)] or {}
    end
    local result = {}
    for name, value in pairs(source or {}) do
        if name ~= "_durations" then result[name] = value end
    end
    result.durations = {}
    for name, sample in pairs(source and source._durations or {}) do
        local values = {}
        for _, value in pairs(sample.values) do values[#values + 1] = value end
        table.sort(values)
        local function percentile(fraction)
            if #values == 0 then return 0 end
            return values[math.max(1, math.ceil(#values * fraction))]
        end
        result.durations[name] = {
            count = sample.count, total = sample.sum, max = sample.max,
            p50 = percentile(0.50), p95 = percentile(0.95),
        }
    end
    if type(_G.collectgarbage) == "function" then
        local ok, memory = pcall(_G.collectgarbage, "count")
        if ok and type(memory) == "number" then result.memoryKB = memory end
    end
    local deferred_count = 0
    if surface ~= nil then
        local bucket = indexed_bucket(deferred_surfaces,
            deferred_scalar_surfaces, surface, false)
        for _ in pairs(bucket or {}) do deferred_count = deferred_count + 1 end
        if deferred_layouts[surface] then deferred_count = deferred_count + 1 end
    else
        for _ in pairs(deferred_writes) do deferred_count = deferred_count + 1 end
        for _ in pairs(deferred_layouts) do deferred_count = deferred_count + 1 end
    end
    result.deferred_queue_length = deferred_count
    return result
end

runtime.reset_performance = function ()
    performance_surfaces = setmetatable({}, { __mode = "k" })
    performance_scalar_surfaces = {}
    performance_totals = {}
end

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

runtime.combat_locked = function ()
    if type(_G.InCombatLockdown) ~= "function" then return false end
    local ok, locked = pcall(_G.InCombatLockdown)
    return not ok or is_secret_value(locked) or locked == true
end

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

local function region_is_visible(region)
    if not region then return false end
    local method_ok, is_visible = pcall(function () return region.IsVisible end)
    if not method_ok or type(is_visible) ~= "function" then return true end
    local ok, visible = pcall(is_visible, region)
    if not ok or is_secret_value(visible) then return true end
    return visible == true
end

local function record_runtime_result(region, spec, source, translated, reason, reason_detail)
    if spec.record_runtime == false
        or type(auto_scan.record_runtime_result) ~= "function"
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
    local visible = safe_text(region)
    if reason == nil or reason == "RETAINED_AFTER_APPLY" then
        local expected = translated
        local name_original = safe_string(spec.name_original)
        if name_original and spec.category
            and not options.translate_name(spec.category) then
            expected = name_original
        end
        if visible ~= expected and type(spec.visible_matches) == "function" then
            local match_ok, matches = pcall(spec.visible_matches, visible, expected)
            if match_ok and matches == true then visible = expected end
        end
    end
    local region_key
    local key_ok, key = pcall(tostring, region)
    if key_ok then region_key = safe_string(key) end
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
        reasonDetail = reason_detail,
        regionKey = region_key,
    }, visible, reason)
end

local function visible_matches(claim, visible, display)
    if visible == display then return true end
    if type(claim.visible_matches) ~= "function" then return false end
    local ok, matches = pcall(claim.visible_matches, visible, display)
    return ok and matches == true
end

local function same_options(left, right)
    if left == right then return true end
    if type(left) ~= "table" or type(right) ~= "table" then return false end
    if #left ~= #right then return false end
    for index, value in ipairs(left) do
        if right[index] ~= value then return false end
    end
    return true
end

local protected_state_methods = { "IsForbidden", "IsProtected" }

local function verification_slot(surface, create)
    local kind = type(surface)
    local object_surface = kind == "table" or kind == "userdata"
        or kind == "thread" or kind == "function"
    local index = object_surface and verification_surfaces
        or verification_scalar_surfaces
    local key = object_surface and surface or kind .. ":" .. tostring(surface)
    local value = index[key]
    if not value and create then
        value = { regions = setmetatable({}, { __mode = "k" }) }
        index[key] = value
    end
    return value, index, key
end

local function schedule_post_apply_verification(region, claim, spec, display)
    if spec.verify_after_apply == false
        or not options.account or not options.account.auto_scan_content
        or type(scheduler.request) ~= "function" then return end
    local surface = spec.surface or spec.tooltip or claim.surface or region
    local batch, batch_index, batch_key = verification_slot(surface, true)
    if batch.generation ~= claim.generation then
        batch.generation = claim.generation
        batch.regions = setmetatable({}, { __mode = "k" })
    end
    batch.regions[region] = {
        claim = claim, spec = spec, display = display,
    }
    scheduler.request({
        id = "runtime-post-apply:" .. tostring(surface)
            .. ":" .. tostring(claim.generation),
        generation = claim.generation,
        surface = surface,
        instance = claim.generation,
        task_kind = "post-apply",
        max_retries = 2,
        retry_delay = 0.05,
        callback = function (attempt)
            local retry = false
            for pending_region, row in pairs(batch.regions) do
                local pending_claim = row.claim
                if claims[pending_region] ~= pending_claim then
                    batch.regions[pending_region] = nil
                elseif not region_is_visible(pending_region) then
                    clear_claim(pending_region)
                    batch.regions[pending_region] = nil
                    if type(auto_scan.discard_runtime_result) == "function" then
                        auto_scan.discard_runtime_result(row.spec,
                            pending_claim.source)
                    end
                else
                    local visible = safe_text(pending_region)
                    if not visible_matches(pending_claim, visible, row.display) then
                        if attempt <= 2 then
                            retry = true
                        else
                            clear_claim(pending_region)
                            batch.regions[pending_region] = nil
                            record_runtime_result(pending_region, row.spec,
                                pending_claim.source, pending_claim.translated,
                                "OVERWRITTEN_AFTER_APPLY")
                        end
                    else
                        batch.regions[pending_region] = nil
                        record_runtime_result(pending_region, row.spec,
                            pending_claim.source, pending_claim.translated,
                            "RETAINED_AFTER_APPLY")
                    end
                end
            end
            if retry then return false end
            if batch_index[batch_key] == batch then batch_index[batch_key] = nil end
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

runtime.is_stable_claim = function (region, surface, generation)
    local claim = region and claims[region]
    if not claim or claim.surface ~= surface
        or claim.generation ~= generation or claim.visible_original then
        return false
    end
    if not runtime.allowed(claim) then return false end
    if options.can_translate("override_system_fonts")
        and claim.font_ready ~= true then return false end
    return visible_matches(claim, safe_text(region), display_translation(claim))
end

local function protected_frame_state(region)
    if not region then return nil, "REGION_MISSING" end
    if is_secret_value(region) then
        return nil, "SECRET_REGION"
    end
    local protected = false
    local frame = region
    for _ = 1, 5 do
        if not frame then break end
        for _, method in ipairs(protected_state_methods) do
            local method_ok, callback = pcall(function () return frame[method] end)
            if not method_ok or is_secret_value(callback) then
                return nil, method == "IsForbidden"
                    and "FORBIDDEN_STATE_UNREADABLE" or "PROTECTED_STATE_UNREADABLE"
            end
            if type(callback) == "function" then
                local ok, value = pcall(callback, frame)
                if not ok or is_secret_value(value) then
                    return nil, method == "IsForbidden"
                        and "FORBIDDEN_STATE_UNREADABLE" or "PROTECTED_STATE_UNREADABLE"
                end
                if value == true then
                    if method == "IsForbidden" then
                        return nil, "IS_FORBIDDEN"
                    end
                    protected = true
                end
            end
        end
        local method_ok, get_parent = pcall(function () return frame.GetParent end)
        if not method_ok or is_secret_value(get_parent) then
            return nil, "PARENT_STATE_UNREADABLE"
        end
        if type(get_parent) ~= "function" then break end
        local parent_ok, parent = pcall(get_parent, frame)
        if not parent_ok or is_secret_value(parent) then
            return nil, "PARENT_STATE_UNREADABLE"
        end
        if parent == frame then break end
        frame = parent
    end
    return protected
end

runtime.can_write_text = function (region, combat_text_only)
    local protected, detail = protected_frame_state(region)
    if protected == nil then return false, "PROTECTED_REGION", detail end
    if not protected then return true end
    if type(_G.InCombatLockdown) ~= "function" then return true end
    local combat_ok, in_combat = pcall(_G.InCombatLockdown)
    if not combat_ok then
        return false, "PROTECTED_REGION", "COMBAT_STATE_UNREADABLE"
    end
    if is_secret_value(in_combat) then
        return false, "PROTECTED_REGION", "SECRET_COMBAT_STATE"
    end
    if in_combat == true and combat_text_only == true then
        -- A protected parent prevents structural changes during combat, but
        -- public text can still be written to an existing FontString. Callers
        -- opting into this path must skip font and layout mutations and rely
        -- on the guarded SetText call below as the final authority.
        return true
    end
    if in_combat == true then
        return false, "PROTECTED_REGION", "IN_COMBAT_LOCKDOWN"
    end
    return true
end

runtime.get = function (region)
    return claims[region]
end

runtime.for_each_claim = function (surface, callback)
    if not surface or type(callback) ~= "function" then return 0 end
    local snapshot = {}
    local bucket = indexed_bucket(claim_surfaces, claim_scalar_surfaces,
        surface, false)
    for region, claim in pairs(bucket or {}) do
        runtime.metric("claim_visits", surface, claim.generation)
        snapshot[#snapshot + 1] = { region = region, claim = claim }
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

runtime.begin_generation = function (surface, instance, on_release)
    if not surface or is_secret_value(surface) then return nil end
    runtime.clear_surface(surface, on_release)
    local generation = (generations[surface] or 0) + 1
    generations[surface] = generation
    generation_instances[surface] = stable_instance(instance)
    return generation
end

runtime.clear_surface = function (surface, on_release)
    if not surface or is_secret_value(surface) then return 0 end
    local removed = 0
    local claim_bucket = indexed_bucket(claim_surfaces,
        claim_scalar_surfaces, surface, false)
    local claim_snapshot = {}
    for region, claim in pairs(claim_bucket or {}) do
        claim_snapshot[#claim_snapshot + 1] = { region, claim }
    end
    for _, row in ipairs(claim_snapshot) do
        local region, claim = row[1], row[2]
        if claims[region] == claim then
            if type(on_release) == "function" then pcall(on_release, region, claim) end
            clear_claim(region)
            removed = removed + 1
        end
    end
    local deferred_bucket = indexed_bucket(deferred_surfaces,
        deferred_scalar_surfaces, surface, false)
    local deferred_snapshot = {}
    for region, spec in pairs(deferred_bucket or {}) do
        deferred_snapshot[#deferred_snapshot + 1] = { region, spec }
    end
    for _, row in ipairs(deferred_snapshot) do
        if deferred_writes[row[1]] == row[2] then clear_deferred(row[1]) end
    end
    deferred_layouts[surface] = nil
    local verification, verification_index, verification_key =
        verification_slot(surface, false)
    if verification then verification_index[verification_key] = nil end
    if type(scheduler.cancel_surface) == "function" then
        scheduler.cancel_surface(surface)
    end
    runtime.metric("surface_claims_cleared", surface,
        runtime.generation(surface), removed)
    return removed
end

runtime.defer_layout = function (surface, callback)
    if not surface or type(callback) ~= "function" then return false end
    deferred_layouts[surface] = {
        generation = runtime.generation(surface),
        instance = runtime.generation_instance(surface),
        callback = callback,
    }
    return true
end

runtime.release = function (region, owner, slot)
    local claim = region and claims[region]
    if not claim then
        if region and not owner and not slot and deferred_writes[region] then
            clear_deferred(region)
            return true
        end
        return false
    end
    if owner and claim.owner ~= owner then return false end
    if slot and claim.slot ~= slot then return false end
    clear_claim(region)
    clear_deferred(region)
    return true
end

runtime.invalidate = function (region)
    if not region then return false end
    local existed = claims[region] ~= nil or deferred_writes[region] ~= nil
    clear_claim(region)
    clear_deferred(region)
    return existed
end

-- Compatibility names for adapters migrated in later stages.
runtime.next_generation = runtime.begin_generation
runtime.clear = runtime.invalidate

runtime.allowed = function (spec)
    if not options.can_translate() then return false end
    if options.allows_section and not options.allows_section(spec) then return false end
    if spec and spec.option and not options.can_translate(spec.option) then return false end
    local spec_options = spec and spec.options
    if type(spec_options) == "table" then
        for _, option in ipairs(spec_options) do
            if not options.can_translate(option) then return false end
        end
    end
    if not spec or not spec.category or not spec.slot
        or not spec.slot:match("%.name$") then return true end
    return options.name_enabled and options.name_enabled(spec)
        or not options.name_enabled and options.translate_name(spec.category)
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
    if options.section_for then spec.section = options.section_for(spec, region) end
    local allowed = runtime.allowed(spec)
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
    local cached_native_overwrite = false
    if previous then
        local current = safe_text(region)
        local same_lifecycle = previous.owner == spec.owner
            or previous.surface and previous.surface == spec.surface
        local instance_changed = same_lifecycle and spec.instance ~= nil
            and previous.instance ~= instance
        local owner_generation_changed = previous.owner == spec.owner
            and previous.surface == spec.surface
            and previous.generation ~= generation
        cached_native_overwrite = spec.reapply_cached == true
            and current == previous.source
            and previous.generation == generation
            and previous.owner == spec.owner and previous.slot == spec.slot
            and previous.priority == priority and previous.instance == instance
            and previous.source == source and previous.translated == translated
            and previous.name_original == name_original
            and previous.option == spec.option
            and previous.category == spec.category
            and same_options(previous.options, spec.options)
            and previous.visible_matches == spec.visible_matches
            and not previous.visible_original and not previous.layout_pending
            and (not options.can_translate("override_system_fonts")
                or previous.font_ready == true)
        if not cached_native_overwrite and (instance_changed or owner_generation_changed
            or current and current ~= previous.translated
            and current ~= previous.name_original and current ~= previous.source) then
            previous = nil
            clear_claim(region)
        elseif current and current == previous.source
            and not cached_native_overwrite
            and (previous.generation ~= generation or not previous.visible_original) then
            previous = nil
            clear_claim(region)
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
        runtime.metric("option_disabled", spec.surface, generation)
        if previous then
            runtime.show_original(region, true)
        elseif spec.category and spec.slot and spec.slot:match("%.name$")
            and source then
            runtime.restore_source(region, source)
        end
        return false
    end
    if cached_native_overwrite
        and not (spec.tooltip and spec.tooltip.uaForeverShowOriginal) then
        local method_ok, set_text = pcall(function () return region.SetText end)
        local write_allowed = runtime.can_write_text(region,
            spec.combat_text_only == true)
        if method_ok and type(set_text) == "function" and write_allowed then
            writing[region] = true
            local ok = pcall(set_text, region, display)
            writing[region] = nil
            runtime.metric("set_text_calls", spec.surface, generation)
            runtime.metric("cached_reapply_hits", spec.surface, generation)
            if ok and visible_matches(previous, safe_text(region), display) then
                return true
            end
        end
    end
    if previous and previous.generation == generation
        and previous.owner == spec.owner and previous.slot == spec.slot
        and previous.priority == priority and previous.instance == instance
        and previous.source == source and previous.translated == translated
        and previous.name_original == name_original
        and previous.option == spec.option
        and previous.category == spec.category
        and same_options(previous.options, spec.options)
        and not previous.visible_original
        and (not options.can_translate("override_system_fonts")
            or previous.font_ready == true)
        and not previous.layout_pending
        and visible_matches(previous, safe_text(region), display) then
        runtime.metric("stable_claim_hits", spec.surface, generation)
        return true
    end

    -- Preserve the first readable English source of this tooltip generation.
    if previous and previous.generation == generation
        and previous.owner == spec.owner and previous.slot == spec.slot then
        source = previous.source or source
    end
    if not source and (not spec.allow_unknown_source
        or spec.tooltip and spec.combat_text_only ~= true) then return false end
    if source == display then return false end
    if spec.tooltip and spec.tooltip.uaForeverShowOriginal then return false end

    local method_ok, set_text = pcall(function () return region.SetText end)
    if not method_ok or type(set_text) ~= "function" then
        if allowed then
            record_runtime_result(region, spec, source, translated, "SetText недоступний")
        end
        return false
    end
    local write_allowed, write_reason, write_detail = runtime.can_write_text(region,
        spec.combat_text_only == true)
    if not write_allowed then
        if allowed then
            record_runtime_result(region, spec, source, translated,
                write_reason, write_detail)
            if write_detail == "IN_COMBAT_LOCKDOWN"
                and spec.defer_if_protected ~= false and source then
                local deferred_spec = {}
                for key, value in pairs(spec) do deferred_spec[key] = value end
                deferred_spec.source = source
                deferred_spec.generation = generation
                deferred_spec.instance = instance
                put_deferred(region, deferred_spec)
            else
                clear_deferred(region)
            end
        end
        return false
    end
    clear_deferred(region)

    local font_ready = not options.can_translate("override_system_fonts")
        or spec.combat_text_only == true
    if options.can_translate("override_system_fonts")
        and spec.combat_text_only ~= true then
        local font_ok = runtime.ensure_font(region)
        if not font_ok and display:find("[\208\209]") then
            record_runtime_result(region, spec, source, translated, "шрифт не застосувався")
            return false
        end
        font_ready = font_ok == true
    end
    writing[region] = true
    local ok = pcall(set_text, region, display)
    writing[region] = nil
    runtime.metric("set_text_calls", spec.surface, generation)
    if not ok then
        record_runtime_result(region, spec, source, translated, "SetText завершився помилкою")
        return false
    end
    if not visible_matches(spec, safe_text(region), display) then
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
        section = spec.section,
        option = spec.option,
        options = spec.options,
        lookup_tier = spec.lookup_tier,
        catalog_source = spec.catalog_source,
        after_visibility = spec.after_visibility,
        visible_matches = spec.visible_matches,
        font_ready = font_ready,
        layout_pending = spec.layout_pending == true,
        after_apply = spec.after_apply,
    }
    put_claim(region, claim)
    if spec.after_apply then pcall(spec.after_apply, region, source) end
    if spec.after_visibility then pcall(spec.after_visibility, region) end
    record_runtime_result(region, spec, source, translated)
    schedule_post_apply_verification(region, claim, spec, display)
    return true
end

runtime.retry_deferred = function ()
    local pending = {}
    for region, spec in pairs(deferred_writes) do
        pending[#pending + 1] = { region = region, spec = spec }
    end
    local applied = 0
    for _, entry in ipairs(pending) do
        local region, spec = entry.region, entry.spec
        if deferred_writes[region] == spec then
            clear_deferred(region)
            local current = safe_text(region)
            local current_generation = spec.surface
                and runtime.generation(spec.surface) or spec.generation
            local current_instance = spec.surface
                and runtime.generation_instance(spec.surface) or spec.instance
            local lifecycle_current = (not spec.generation
                    or spec.generation == current_generation)
                and (spec.instance == nil or spec.instance == current_instance)
            local shown = true
            local method_ok, is_shown = pcall(function () return region.IsShown end)
            if method_ok and type(is_shown) == "function" then
                local ok, value = pcall(is_shown, region)
                shown = ok and not is_secret_value(value) and value == true
            end
            if lifecycle_current and shown
                and current and current == safe_string(spec.source)
                and runtime.allowed(spec)
                and runtime.apply(region, spec) then
                applied = applied + 1
            end
        end
    end
    local layouts = {}
    for surface, spec in pairs(deferred_layouts) do
        layouts[#layouts + 1] = { surface = surface, spec = spec }
    end
    for _, entry in ipairs(layouts) do
        local surface, spec = entry.surface, entry.spec
        if deferred_layouts[surface] == spec then
            deferred_layouts[surface] = nil
            local current = spec.generation == runtime.generation(surface)
                and spec.instance == runtime.generation_instance(surface)
            local shown = true
            local method_ok, is_shown = pcall(function () return surface.IsShown end)
            if method_ok and type(is_shown) == "function" then
                local ok, value = pcall(is_shown, surface)
                shown = ok and not is_secret_value(value) and value == true
            end
            if current and shown then pcall(spec.callback, surface) end
        end
    end
    return applied
end

runtime.show_original = function (region, show)
    local claim = claims[region]
    if not claim then return false end
    local write_allowed = runtime.can_write_text(region)
    if not write_allowed then return false end
    local policy_original = not runtime.allowed(claim)
        or claim.option and not options.can_translate(claim.option)
    for _, option in ipairs(claim.options or {}) do
        if not options.can_translate(option) then policy_original = true end
    end
    if claim.category and claim.slot:match("%.name$")
        and not claim.name_original
        and not (options.name_enabled and options.name_enabled(claim)
            or not options.name_enabled and options.translate_name(claim.category)) then
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
                and not (options.name_enabled and options.name_enabled(claim)
                    or not options.name_enabled and options.translate_name(claim.category))
            local option_disabled = claim.option and not options.can_translate(claim.option)
            for _, option in ipairs(claim.options or {}) do
                if not options.can_translate(option) then option_disabled = true end
            end
            runtime.show_original(region, not runtime.allowed(claim) or option_disabled or name_disabled)
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
