local addon_name, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local spell_client_db = addon_table.use("spell_client_db")
local tooltips = addon_table.use("tooltips")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")
local runtime = addon_table.use("translation_runtime")
local cleared = false
local suppress_developer_capture = false

local function profiler_percent(value)
    if type(value) ~= "number" or value <= 0 then return "0%" end
    if value >= 1 then return string.format("%.0f%%", value) end
    if value >= 0.1 then return string.format("%.1f%%", value) end
    if value >= 0.01 then return string.format("%.2f%%", value) end
    return "0%"
end

auto_scan.performance_snapshot = function ()
    local profiler = _G.C_AddOnProfiler
    local metric_enum = _G.Enum and _G.Enum.AddOnProfilerMetric
    local snapshot = {
        addon = addon_name, available = false, enabled = false,
        translation = type(runtime.performance_snapshot) == "function"
            and runtime.performance_snapshot() or {},
    }
    if type(profiler) ~= "table" or type(metric_enum) ~= "table"
        or type(profiler.IsEnabled) ~= "function" then
        return snapshot
    end

    local enabled_ok, enabled = pcall(profiler.IsEnabled)
    snapshot.available = true
    snapshot.enabled = enabled_ok and enabled == true
    if not enabled_ok or enabled ~= true
        or type(profiler.GetApplicationMetric) ~= "function"
        or type(profiler.GetOverallMetric) ~= "function"
        or type(profiler.GetAddOnMetric) ~= "function" then
        return snapshot
    end

    local metrics = {
        { "Current", metric_enum.RecentAverageTime },
        { "Average", metric_enum.SessionAverageTime },
        { "Peak", metric_enum.PeakTime },
    }
    for _, row in ipairs(metrics) do
        local label, metric = row[1], row[2]
        if metric ~= nil then
            local app_ok, application = pcall(profiler.GetApplicationMetric, metric)
            local overall_ok, overall = pcall(profiler.GetOverallMetric, metric)
            local addon_ok, addon = pcall(profiler.GetAddOnMetric, addon_name, metric)
            if app_ok and overall_ok and addon_ok
                and type(application) == "number" and type(overall) == "number"
                and type(addon) == "number" then
                -- Match Blizzard's AddonList:GetAddonMetricPercent denominator.
                local relative_total = application - overall + addon
                local addon_pct = relative_total > 0
                    and addon / relative_total * 100 or 0
                snapshot[label] = {
                    addonCPU = profiler_percent(addon_pct),
                }
            end
        end
    end
    return snapshot
end

local groups = {
    { "items", "[ITEMS]" }, { "gossips", "[GOSSIPS]" },
    { "npcs", "[NPCS]" }, { "quests", "[QUESTS]" },
    { "books", "[BOOKS]" },
    { "skills", "[SKILLS]" }, { "spells", "[SPELLS]" },
    { "auras", "[AURAS]" }, { "chats", "[CHATS]" },
    { "system_chat", "[SYSTEM_CHAT]" },
    { "combat_text", "[COMBAT_TEXT]" },
    { "zones", "[ZONES]" },
    { "objects", "[OBJECTS]" },
    { "ui", "[UI]" },
    { "observed_ui", "[OBSERVED_UI]" },
    { "runtime", "[RUNTIME]" },
    { "unapplied", "[NOT_APPLIED]" },
    { "lockdowns", "[LOCKDOWNS]" },
    { "unsafe", "[UNSAFE]" },
    { "hooks", "[HOOKS]" },
    { "catalog_conflicts", "[CATALOG_CONFLICTS]" },
    { "compatibility", "[COMPATIBILITY]" },
    { "invalid_candidates", "[INVALID_CANDIDATES]" },
    { "technical_literals", "[TECHNICAL_LITERALS]" },
}

-- The ordinary autoscan is a translation worklist, not a dump of every
-- English string the client can expose. Keep only untranslated narrative and
-- world content in it. Everything else is opt-in technical diagnostics.
local content_groups = {
    gossips = true,
    npcs = true,
    quests = true,
    books = true,
    chats = true,
    objects = true,
}

local diagnostic_groups = {}
for _, descriptor in ipairs(groups) do
    local group = descriptor[1]
    if not content_groups[group] then diagnostic_groups[group] = true end
end

local technical_scan_fields = {
    "ui", "ids", "menus", "mouseProbe", "tooltipProbe", "auraProbe",
    "windowProbe", "fullObjectScan", "mapTextureProbe", "auraCapture",
    "panelProbe", "panelProbeError",
}

local function diagnostics_enabled()
    return options.account and options.account.auto_scan_diagnostics == true
end

auto_scan.diagnostics_enabled = diagnostics_enabled

local function safe_text(value)
    return runtime.safe_string_or_nil(value)
end

local function bucket(group)
    if not options.account or not options.account.auto_scan_content
        or not UA_ForeverDB then return nil end
    if diagnostic_groups[group] and not diagnostics_enabled() then return nil end
    cleared = false
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    UA_ForeverDB.scan.auto = UA_ForeverDB.scan.auto or {}
    local store = UA_ForeverDB.scan.auto
    store[group] = store[group] or {}
    return store[group]
end

local domains = {
    items = "item", npcs = "npc", quests = "quest",
    spells = "spell", auras = "spell",
}

local function translated_name(group, id, name)
    local numeric_id = tonumber(id)
    if group == "spells" then
        return numeric_id
            and spell_client_db.has_spell_translation(numeric_id) or false
    elseif group == "auras" then
        return numeric_id
            and spell_client_db.has_aura_translation(numeric_id) or false
    end
    local domain = domains[group]
    local entry = domain and entries.get_entry and entries.get_entry(domain, id)
    if group == "quests" and entry and type(name) == "string"
        and type(entry.en) == "string" and entry.en ~= name then
        return false
    end
    local source = entry and type(entry.en) == "string" and entry.en or name
    return entry and type(entry[1]) == "string" and entry[1] ~= ""
        and (not source or entry[1] ~= source)
end

local function translated_zone(source)
    if entries.get_glossary_text then
        local ok, value = pcall(entries.get_glossary_text, source, source, "zone")
        if ok and type(value) == "string" and value ~= "" and value ~= source then
            return value
        end
    end
    local value = addon_table.zone and addon_table.zone[source]
    return type(value) == "string" and value ~= "" and value ~= source
        and value or nil
end

local function english_source(text)
    return safe_text(text) and text:find("[A-Za-z]")
        and not text:find("[\208\209]")
end

local function has_english_words(text)
    text = safe_text(text)
    if not text then return false end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|n", "")
    return text:find("[A-Za-z][A-Za-z]+") ~= nil
end

local function domain_owned_ui_slot(slot)
    slot = safe_text(slot)
    if not slot then return false end
    -- Gossip/quest greeting text is owned by the gossip domain adapters and
    -- is reported through [GOSSIPS]. Pooled greeting FontStrings can retain
    -- an English source snapshot even while the active row is translated;
    -- treating those snapshots as generic UI creates false [UI] candidates.
    return slot == "GreetingText" or slot:match("%.GreetingText$") ~= nil
end

local function untranslated_key(owner, slot, source)
    local hash = type(utils.get_text_hash) == "function"
        and utils.get_text_hash(source) or source
    return tostring(owner or "ui") .. ":" .. tostring(slot or "text")
        .. ":" .. tostring(hash)
end

local function record_domain_diagnostic(owner, slot, source, translation,
        visible, surface, reason)
    source = safe_text(source)
    translation = safe_text(translation)
    if not source or not translation or translation == source then return end
    owner = safe_text(owner) or "content"
    slot = safe_text(slot) or "content.text"
    local records = bucket("unapplied")
    if not records then return end
    records[untranslated_key(owner, slot, source)] = {
        owner = owner,
        slot = slot,
        surface = safe_text(surface) or owner,
        text = source,
        translation = translation,
        visible = safe_text(visible),
        reason = safe_text(reason) or "OVERWRITTEN_AFTER_APPLY",
    }
end

local surface_states = {}
local hook_states = {}
local diagnostic_retention = {}

local function bounded_diagnostic_put(group, records, key, value, limit)
    local state = diagnostic_retention[group]
    if not state then
        state = { queue = {}, first = 1, last = 0, tokens = {}, next = 0 }
        diagnostic_retention[group] = state
    end
    state.next = state.next + 1
    local token = state.next
    state.tokens[key] = token
    state.last = state.last + 1
    state.queue[state.last] = { key = key, token = token }
    records[key] = value
    while state.last - state.first + 1 > limit do
        local row = state.queue[state.first]
        state.queue[state.first] = nil
        state.first = state.first + 1
        if row and state.tokens[row.key] == row.token then
            state.tokens[row.key] = nil
            records[row.key] = nil
        end
    end
end

auto_scan.record_unsafe_source = function (context)
    local records = bucket("unsafe")
    context = safe_text(context) or "unknown"
    if not records then return end
    local record = records[context] or { reason = "SOURCE_UNSAFE", count = 0 }
    record.count = record.count + 1
    records[context] = record
end

auto_scan.record_compatibility_fallback = function (reason, context)
    reason = safe_text(reason)
    context = safe_text(context)
    if suppress_developer_capture and reason == "DEVELOPER_CAPTURE" then return end
    local records = bucket("compatibility")
    if not records or not reason or not context then return end
    local key = reason .. ":" .. context
    local record = records[key] or { reason = reason, context = context, count = 0 }
    record.count = record.count + 1
    records[key] = record
end

auto_scan.record_hook_status = function (state)
    if not diagnostics_enabled() or type(state) ~= "table" then return end
    local id = safe_text(state.id)
    if not id then return end
    cleared = false
    hook_states[id] = {
        surface = safe_text(state.surface),
        kind = safe_text(state.kind),
        target = safe_text(state.target),
        method = safe_text(state.method),
        blizzardAddon = safe_text(state.blizzardAddon),
        required = state.required == true,
        fallbackEvent = safe_text(state.fallbackEvent),
        verifiedBuild = type(state.verifiedBuild) == "number"
            and state.verifiedBuild or nil,
        available = state.available == true,
        installed = state.installed == true,
        observed = state.observed == true,
        observedCalls = type(state.observedCalls) == "number"
            and state.observedCalls or 0,
        lastError = safe_text(state.lastError),
    }
end

local function get_surface_state(surface)
    if not diagnostics_enabled() then return nil end
    surface = safe_text(surface)
    if not surface then return nil end
    local state = surface_states[surface]
    if not state then
        state = { attempts = 0, hooks = {}, results = {} }
        surface_states[surface] = state
    end
    return state
end

auto_scan.surface_event = function (surface, event)
    local state = get_surface_state(surface)
    if not state then return end
    state.event = safe_text(event)
    state.handler = nil
    state.attempts = 0
    state.results = {}
    for _, hook in pairs(state.hooks) do hook.observed = false end
end

auto_scan.surface_hook = function (surface, hook_name, available, observed)
    local state = get_surface_state(surface)
    hook_name = safe_text(hook_name)
    if not state or not hook_name then return end
    local hook = state.hooks[hook_name] or {}
    hook.available = available == true
    if observed == true then hook.observed = true
    elseif hook.observed == nil then hook.observed = false end
    state.hooks[hook_name] = hook
end

auto_scan.surface_attempt = function (surface, handler)
    local state = get_surface_state(surface)
    if not state then return end
    state.handler = safe_text(handler) or state.handler
    state.attempts = (state.attempts or 0) + 1
end

local function note_surface_runtime_result(owner, slot, source, visible, reason, reason_detail)
    local state = surface_states[owner]
    if not state then return end
    local key = untranslated_key(owner, slot, source)
    state.results[key] = {
        success = visible ~= source,
        reason = safe_text(reason),
        reasonDetail = safe_text(reason_detail),
    }
end

local function surface_diagnostic(state)
    local names = {}
    for name in pairs(state and state.hooks or {}) do names[#names + 1] = name end
    table.sort(names)
    local name = names[1]
    local hook = name and state.hooks[name]
    return name, hook and hook.available == true or false,
        hook and hook.observed == true or false
end

local function runtime_reason_code(reason)
    if reason == "PROTECTED_REGION" then return reason end
    if reason == "DYNAMIC_CONTRACT_MISSING" then return reason end
    if reason == "APPLY_FAILED" or reason == "OVERWRITTEN_AFTER_APPLY" then
        return reason
    end
    if reason == "CLAIM_CONFLICT" then return reason end
    if reason == "захищений елемент" then return "PROTECTED_REGION" end
    if reason == "інший обробник утримує цей елемент" then
        return "CLAIM_CONFLICT"
    end
    if reason then return "APPLY_FAILED" end
    return "APPLY_FAILED"
end

auto_scan.verify_surface = function (spec)
    if type(spec) ~= "table" then return end
    local records = bucket("unapplied")
    local surface = safe_text(spec.surface) or safe_text(spec.owner) or "ui"
    local owner = safe_text(spec.owner) or surface
    local slot = safe_text(spec.slot) or "ui.text"
    local source = safe_text(spec.source)
    local translated = safe_text(spec.translation)
    local visible = safe_text(spec.visible)
    if not records or not source then return end
    local key = untranslated_key(owner, slot, source)
    if spec.expected ~= true or not translated or translated == source
        or not has_english_words(source) then
        records[key] = nil
        return
    end
    if visible and visible ~= source then
        records[key] = nil
        return
    end

    local state = surface_states[surface]
    local result = state and state.results[key]
    local attempts = state and state.attempts or 0
    local reason
    if attempts == 0 then
        reason = "HANDLER_NOT_TRIGGERED"
    elseif result and result.success then
        reason = "OVERWRITTEN_AFTER_APPLY"
    elseif result and result.reason then
        reason = runtime_reason_code(result.reason)
    else
        reason = "LOOKUP_FAILED"
    end
    local hook_name, hook_available, hook_observed = surface_diagnostic(state)
    records[key] = {
        owner = owner, slot = slot, surface = surface,
        text = source, translation = translated, visible = visible,
        event = state and state.event or nil,
        handler = state and state.handler or nil,
        attempts = attempts,
        hook = hook_name, hookAvailable = hook_name and hook_available or nil,
        hookObserved = hook_name and hook_observed or nil,
        reason = reason,
        reasonDetail = result and (result.reasonDetail or result.reason) or nil,
    }
end

auto_scan.record_runtime_result = function (spec, visible, reason)
    if type(spec) ~= "table" then return end
    local source = safe_text(spec.source)
    local translated = safe_text(spec.translated)
    visible = safe_text(visible)
    if not source or not translated or source == translated
        or not has_english_words(source) then return end
    local owner = safe_text(spec.owner) or "ui"
    local slot = safe_text(spec.slot) or "ui.text"
    local key = untranslated_key(owner, slot, source)
    local surface = safe_text(spec.surface) or owner
    local deferred_outcome = reason == "RETAINED_AFTER_APPLY"
        or reason == "OVERWRITTEN_AFTER_APPLY"
    local current_store = UA_ForeverDB and UA_ForeverDB.scan
        and UA_ForeverDB.scan.auto
    local current_runtime = current_store and current_store.runtime
    if deferred_outcome and (not current_runtime or not current_runtime[key]) then
        -- Clear may run while an old post-apply verification is still queued.
        -- A deferred result may update an existing lifecycle record, but it
        -- must not resurrect a record that the user has just deleted.
        return
    end
    local reason_detail = safe_text(spec.reasonDetail)
    if reason_detail == "IN_COMBAT_LOCKDOWN" then
        if type(auto_scan.discard_runtime_result) == "function" then
            auto_scan.discard_runtime_result(spec, source)
        end
        local lockdown_records = bucket("lockdowns")
        if lockdown_records then
            lockdown_records[key] = {
                owner = owner, slot = slot, surface = surface,
                text = source, translation = translated, visible = visible,
                lookupTier = safe_text(spec.lookupTier),
                catalogSource = safe_text(spec.catalogSource),
                reason = runtime_reason_code(safe_text(reason)),
                reasonDetail = reason_detail,
                regionKey = safe_text(spec.regionKey),
            }
        end
        return
    end
    local records = bucket("unapplied")
    local runtime_records = bucket("runtime")
    if not records and not runtime_records then return end
    note_surface_runtime_result(surface, slot, source, visible, reason, reason_detail)
    if runtime_records then
        local retained = reason == "RETAINED_AFTER_APPLY"
        local applied = visible ~= nil and visible ~= source
            and reason ~= "APPLY_FAILED" and reason ~= "OVERWRITTEN_AFTER_APPLY"
        local lookup_tier = safe_text(spec.lookupTier)
        local catalog_source = safe_text(spec.catalogSource)
        local region_key = safe_text(spec.regionKey)
        local phase = safe_text(spec.phase)
        local generation = type(spec.generation) == "number"
            and spec.generation or nil
        local instance = (type(spec.instance) == "string"
            or type(spec.instance) == "number") and spec.instance or nil
        local outcome = safe_text(reason) or (applied and "APPLIED" or "NOT_APPLIED")
        local current = runtime_records[key]
        if type(current) ~= "table" or current.owner ~= owner
            or current.slot ~= slot or current.surface ~= surface
            or current.text ~= source or current.translation ~= translated
            or current.visible ~= visible or current.lookupTier ~= lookup_tier
            or current.catalogSource ~= catalog_source
            or current.reasonDetail ~= reason_detail
            or current.regionKey ~= region_key or current.phase ~= phase
            or current.generation ~= generation or current.instance ~= instance
            or current.applied ~= applied or current.retained ~= retained
            or current.outcome ~= outcome then
            bounded_diagnostic_put("runtime", runtime_records, key, {
                owner = owner, slot = slot, surface = surface,
                text = source, translation = translated, visible = visible,
                lookupTier = lookup_tier, catalogSource = catalog_source,
                reasonDetail = reason_detail, regionKey = region_key,
                phase = phase, generation = generation, instance = instance,
                applied = applied, retained = retained, outcome = outcome,
            }, 512)
        end
    end
    if not records then return end
    if visible == source or reason == "OVERWRITTEN_AFTER_APPLY" then
        records[key] = {
            owner = owner, slot = slot, surface = surface, text = source,
            translation = translated, visible = visible,
            lookupTier = safe_text(spec.lookupTier),
            catalogSource = safe_text(spec.catalogSource),
            reason = runtime_reason_code(safe_text(reason)),
            reasonDetail = reason_detail or safe_text(reason),
            regionKey = safe_text(spec.regionKey),
        }
    else
        records[key] = nil
        local ui_records = bucket("ui")
        if ui_records then
            local ui_key = type(utils.get_text_hash) == "function"
                and utils.get_text_hash(source) or source
            ui_records[ui_key] = nil
        end
        -- The generic UI scan can run before a domain hook applies its
        -- translation. Once the real owner succeeds, discard that early
        -- snapshot of the same source text as well.
        for candidate_key, candidate in pairs(records) do
            if type(candidate) == "table" and candidate.owner == "ui-scan"
                and candidate.text == source then
                records[candidate_key] = nil
            end
        end
        if runtime_records then
            for candidate_key, candidate in pairs(runtime_records) do
                if type(candidate) == "table" and candidate.owner == "ui-scan"
                    and candidate.text == source then
                    runtime_records[candidate_key] = nil
                end
            end
        end
    end
end

auto_scan.discard_runtime_result = function (spec, observed_source)
    if type(spec) ~= "table" then return end
    local source = safe_text(observed_source) or safe_text(spec.source)
    if not source then return end
    local owner = safe_text(spec.owner) or "ui"
    local slot = safe_text(spec.slot) or "ui.text"
    local key = untranslated_key(owner, slot, source)
    local records = bucket("unapplied")
    if records then records[key] = nil end
    local runtime_records = bucket("runtime")
    if runtime_records then runtime_records[key] = nil end

    local surface = safe_text(spec.surface) or owner
    local state = surface_states[surface]
    if state and state.results then state.results[key] = nil end
end

auto_scan.record_ui_observation = function (source, translated, visible, slot)
    local records = bucket("observed_ui")
    source = safe_text(source)
    translated = safe_text(translated)
    visible = safe_text(visible)
    slot = safe_text(slot) or "ui.text"
    if not records or not source or not translated or translated == source then return end
    local key = untranslated_key("ui-scan", slot, source)
    local resolved_visible = visible or source
    local option_enabled = options.can_translate("translate_string") == true
    local current = records[key]
    if type(current) == "table" and current.owner == "ui-scan"
        and current.slot == slot and current.surface == "ui-scan"
        and current.text == source and current.translation == translated
        and current.visible == resolved_visible
        and current.optionEnabled == option_enabled
        and current.outcome == "OBSERVED_ENGLISH_WITH_TRANSLATION" then return end
    bounded_diagnostic_put("observed_ui", records, key, {
        owner = "ui-scan", slot = slot, surface = "ui-scan",
        text = source, translation = translated, visible = resolved_visible,
        optionEnabled = option_enabled,
        outcome = "OBSERVED_ENGLISH_WITH_TRANSLATION",
    }, 512)
end

auto_scan.clear_runtime_owner = function (owner)
    local records = bucket("unapplied")
    if not records then return end
    for key, record in pairs(records) do
        if type(record) == "table" and record.owner == owner then
            records[key] = nil
        end
    end
end

auto_scan.discard_ui = function (source)
    source = safe_text(source)
    if not source then return end
    local records = bucket("ui")
    if records then
        local key = type(utils.get_text_hash) == "function"
            and utils.get_text_hash(source) or source
        records[key] = nil
    end
end

auto_scan.record_ui = function (source, translated, slot, surface, owner)
    source = safe_text(source)
    slot = safe_text(slot)
    surface = safe_text(surface) or slot and slot:match("^([^.]+)") or "visible-ui"
    owner = safe_text(owner) or "ui-scan"
    if not source or not has_english_words(source)
        or domain_owned_ui_slot(slot) then return end
    local records = bucket("ui")
    if not records then return end
    local key = type(utils.get_text_hash) == "function"
        and utils.get_text_hash(source) or source
    local catalog = addon_table.forever_catalog
    if catalog and type(catalog.lookup_source_literal) == "function" then
        local translation, provenance = catalog.lookup_source_literal(source, source)
        if translation then
            records[key] = nil
            local technical = bucket("technical_literals")
            if technical then
                technical[key] = {
                    text = source,
                    translation = translation,
                    source = provenance and provenance.source,
                    slot = slot,
                    reason = "NON_PLAYER_SOURCE_LITERAL",
                }
            end
            return
        end
    end
    local ui_translation
    if translated == nil and strings.find_ui_translation then
        local ok, value = pcall(strings.find_ui_translation, source)
        if ok then ui_translation = value end
    end
    local translated_success = translated == true
        or type(translated) == "string" and translated ~= "" and translated ~= source
    local has_translation = translated_success
        or type(ui_translation) == "string" and ui_translation ~= source
    if has_translation then
        records[key] = nil
        if type(ui_translation) == "string" and ui_translation ~= source then
            auto_scan.record_runtime_result({
                owner = "ui-scan", slot = slot or "ui.text",
                source = source, translated = ui_translation,
            }, translated_success and ui_translation or source, "видимий UI-текст")
        end
        return
    end
    records[key] = {
        text = source, visible = source,
        owner = owner, slot = slot or "ui.text", surface = surface,
        reason = "MISSING_TRANSLATION",
    }
end

auto_scan.record_book = function (identity, page, source, visible, translated, name)
    local records = bucket("books")
    source = safe_text(source)
    visible = safe_text(visible)
    page = tonumber(page) or 1
    if not records or not identity or not source or not has_english_words(source) then return end
    local key = tostring(identity) .. ":" .. tostring(page)
    local has_translation = type(translated) == "string"
        and translated ~= "" and translated ~= source
    local still_source = visible == source
        or visible and visible:sub(1, #source) == source
    if has_translation then
        records[key] = nil
        if still_source then
            record_domain_diagnostic("book", "book.page", source,
                translated, visible, "ItemTextFrame")
        end
        return
    end
    records[key] = {
        bookID = tonumber(identity), page = page,
        name = safe_text(name), text = source,
    }
end

local function visible_english_tooltip_text(text)
    text = safe_text(text)
    if not text then return false end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("|n", "")
    -- Shortcut letters such as F6 in an otherwise Ukrainian line are not
    -- untranslated English. Keep mixed lines with actual English words.
    return text:find("[A-Za-z][A-Za-z]+") ~= nil
end

local function has_ui_translation(text)
    if not english_source(text) or not strings.find_ui_translation then return false end
    local ok, translated = pcall(strings.find_ui_translation, text)
    return ok and type(translated) == "string" and translated ~= text
end

local function annotate_personalized_gossip(record, text)
    local _, template, personalized, translation_hint, template_code =
        utils.get_gossip_lookup_codes(text)
    record.template = personalized and template or nil
    record.personalized = personalized
    record.personalizationConfidence = personalized == "name" and "exact" or
        personalized and "probable" or nil
    record.translationHint = translation_hint
    record.templateCode = template_code
    return template_code
end

local function gossip_records_for_export(records)
    local prepared = {}
    for key, record in pairs(records or {}) do
        if type(record) == "table" then
            local copy = {}
            for field, value in pairs(record) do copy[field] = value end
            local template_code = type(copy.text) == "string"
                and annotate_personalized_gossip(copy, copy.text) or nil
            local npc_id = copy.npcID or tostring(key):match("^(%d+):")
            local export_key = template_code and npc_id
                and tostring(npc_id) .. ":" .. template_code or key
            prepared[export_key] = copy
        end
    end
    return prepared
end

local function translated_gossip(record)
    if not record.npcID or not record.text
        or type(entries.find_gossip_translation) ~= "function" then return false end
    local translation = entries.find_gossip_translation(record.npcID, record.text, record.reply)
    if type(translation) == "string" and translation ~= record.text then return translation end
    return false
end

auto_scan.record_id = function (group, id, name, translated)
    local records = bucket(group)
    id = tonumber(id)
    if not records or not id or id <= 0 then return end
    if group == "npcs" and not english_source(name) then
        records[id] = nil
        return
    end
    if translated_name(group, id, name) or (group == "skills" and translated == true) then
        if group ~= "quests" or not records[id] or not records[id].fields then
            records[id] = nil
        end
        return
    end
    if translated ~= false and group == "skills" then return end
    local record = records[id] or {}
    record.name = safe_text(name) or record.name
    records[id] = record
end

auto_scan.record_quest = function (id, fields, missing_fields)
    local records = bucket("quests")
    id = tonumber(id)
    if not records or not id or id <= 0 or type(fields) ~= "table"
        or type(missing_fields) ~= "table" then return end
    local record = records[id] or {}
    record.fields = record.fields or {}
    record.unapplied = nil
    record.objectiveSource = safe_text(fields.objective) or record.objectiveSource
    for key, value in pairs(fields) do
        if missing_fields[key] then
            local text = safe_text(value)
            local translated_task
            if text and key:match("^task%d+$")
                and entries.translate_quest_objective_task then
                local ok, result = pcall(entries.translate_quest_objective_task,
                    text, id, record.objectiveSource)
                if ok and type(result) == "string" and result ~= text then
                    translated_task = result
                end
            end
            if text and english_source(text) and not translated_task then
                record.fields[key] = text
            else record.fields[key] = nil end
        else
            record.fields[key] = nil
        end
    end
    if next(record.fields) then
        record.name = missing_fields.title and safe_text(fields.title) or nil
        records[id] = record
    elseif record.name and translated_name("quests", id, record.name) then
        records[id] = nil
    end
end

auto_scan.record_visible_quest_field = function (id, field, source, visible, expected)
    local records = bucket("quests")
    id = tonumber(id)
    field = safe_text(field)
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not id or id <= 0 or not field
        or not source or not visible then return end
    local entry = entries.get_entry and entries.get_entry("quest", id)
    local indices = { title = 1, description = 2, objective = 3,
        progress = 4, reward = 5 }
    local index = indices[field]
    local translation = index and entry and entry[index]
    local translated = type(translation) == "string"
        and translation ~= "" and translation ~= source
    local still_english = english_source(visible) and visible == source
    local record = records[id] or {}
    record.fields = record.fields or {}
    if translated then
        record.fields[field] = nil
        if type(record.unapplied) == "table" then record.unapplied[field] = nil end
        if still_english and expected then
            record_domain_diagnostic("quest:" .. tostring(id),
                "quest." .. field, source, translation, visible,
                "quest-gossip")
        end
    else
        record.fields[field] = still_english and source or nil
    end
    if next(record.fields) then
        if field == "title" then record.name = source end
        records[id] = record
    else
        records[id] = nil
    end
end

auto_scan.record_visible_quest_title = function (id, source, visible, expected)
    auto_scan.record_visible_quest_field(id, "title", source, visible, expected)
end

auto_scan.record_gossip = function (id, code, source, is_reply)
    local records = bucket("gossips")
    local text = safe_text(source)
    if not records or not id or not code or not text
        or not english_source(text) then return end
    local record = {
        npcID = tonumber(id), text = text, reply = is_reply == true,
    }
    local exact_key = tostring(id) .. ":" .. tostring(code)
    local template_code = annotate_personalized_gossip(record, text)
    code = template_code or code
    local key = tostring(id) .. ":" .. tostring(code)
    if translated_gossip(record) then
        records[key] = nil
        if exact_key ~= key then records[exact_key] = nil end
        return
    end
    if exact_key ~= key then records[exact_key] = nil end
    records[key] = record
end

auto_scan.record_visible_gossip = function (id, source, visible, expected)
    local records = bucket("gossips")
    id = tonumber(id)
    source = safe_text(source)
    visible = safe_text(visible)
    if not records or not id or id <= 0 or not source or not visible then return end
    local record = { npcID = id, text = source, reply = false }
    local template_code = annotate_personalized_gossip(record, source)
    local exact_code = utils.get_text_code(source)
    local code = template_code or exact_code
    if not code or code == "" then return end
    local key = tostring(id) .. ":" .. code
    local exact_key = exact_code and tostring(id) .. ":" .. exact_code or key
    local translation = translated_gossip({ npcID = id, text = source })
    local still_english = english_source(visible) and visible == source
    if translation then
        records[key] = nil
        if exact_key ~= key then records[exact_key] = nil end
        if still_english and expected then
            record_domain_diagnostic("gossip:" .. tostring(id),
                "gossip.text", source, translation, visible, "quest-gossip")
        end
    elseif still_english then
        if exact_key ~= key then records[exact_key] = nil end
        records[key] = record
    else
        records[key] = nil
        if exact_key ~= key then records[exact_key] = nil end
    end
end

auto_scan.record_chat = function (name, code, source, language)
    local records = bucket("chats")
    local text = safe_text(source)
    local npc = safe_text(name)
    if not records or not npc or not code or not text
        or not english_source(text) then return end
    local key = npc .. ":" .. tostring(code)
    local ok, _, translation = pcall(entries.get_chat_text, npc, text)
    if ok and type(translation) == "string" and translation ~= text then
        records[key] = nil
        return
    end
    records[key] = {
        npc = npc, text = text, language = safe_text(language),
    }
end

auto_scan.record_system_chat = function (event, source, translated)
    local records = bucket("system_chat")
    local text = safe_text(source)
    if not records or not text or not english_source(text) then return end
    if translated then
        records[text] = nil
    elseif #text <= 500 then
        records[text] = { text = text, event = event }
    end
end

auto_scan.record_combat_text = function (kind, source, translated, global_name, current)
    local records = bucket("combat_text")
    kind = safe_text(kind)
    source = safe_text(source)
    if not records or not kind or not source then return end
    records[kind] = {
        text = source,
        translation = safe_text(translated),
        global = safe_text(global_name),
        current = safe_text(current),
        event = "COMBAT_TEXT_UPDATE",
        capture = "EVENT_ONLY",
    }
end

auto_scan.record_world_tooltip = function (source, visible, context)
    local records = bucket("objects")
    source = safe_text(source)
    visible = safe_text(visible)
    context = type(context) == "table" and context or {}
    if not records or not source then return end
    if visible and visible ~= source then
        records[source] = nil
        return
    end
    local translated = addon_table.translate_object_name
        and addon_table.translate_object_name(source)
        or addon_table.zone and addon_table.zone[source]
    local unapplied = translated and visible == source
    if not english_source(source) then
        records[source] = nil
        return
    end
    if translated then
        records[source] = nil
        if unapplied then
            record_domain_diagnostic("object-tooltip", "object.name",
                source, translated, visible,
                safe_text(context.surface) or "GameTooltip")
        end
        return
    end
    records[source] = {
        name = source, visible = visible,
        owner = safe_text(context.owner) or "object-tooltip",
        slot = safe_text(context.slot) or "object.name",
        surface = safe_text(context.surface) or "GameTooltip",
        reason = "MISSING_TRANSLATION",
    }
end

auto_scan.record_zone_name = function (source, visible, context)
    local records = bucket("zones")
    source = safe_text(source)
    visible = safe_text(visible)
    context = type(context) == "table" and context or {}
    if not records or not source then return end
    if visible and visible ~= source then
        records[source] = nil
        return
    end
    local translated = translated_zone(source)
    local unapplied = translated and visible == source
    if not english_source(source) or translated and not unapplied then
        records[source] = nil
        return
    end
    records[source] = {
        name = source, translation = safe_text(translated), visible = visible,
        owner = safe_text(context.owner) or "zone-label",
        slot = safe_text(context.slot) or "zone.name",
        surface = safe_text(context.surface) or "unknown-zone-surface",
        reason = unapplied and "NOT_APPLIED" or "MISSING_TRANSLATION",
        unapplied = unapplied or nil,
    }
end

auto_scan.capture_tooltip = function (tooltip, kind, id, missing_entry)
    -- Shift intentionally displays the original tooltip. Do not report that
    -- view as a failed translation.
    if tooltip and tooltip.uaForeverShowOriginal then return end
    local group = kind == "item" and "items"
        or ((kind == "spell" or kind == "trainer") and "spells")
        or (kind == "aura" and "auras") or nil
    local records = group and bucket(group)
    if not records or not tooltip then return end
    local ok, rows = pcall(tooltips.inspect, tooltip, 40)
    if not ok or type(rows) ~= "table" or #rows == 0 then return end
    local title = safe_text(rows[1].source) or safe_text(rows[1].visible)
    local key = tonumber(id)
    if not key and kind == "trainer" and title and entries.lookup_id then
        key = entries.lookup_id("spell", title)
            or entries.lookup_id("spell", title:match("^[^:]+: (.+)$") or title)
    end
    local trainer_spell_id = kind == "trainer" and key or nil
    if kind == "trainer" and (key or title) then
        key = "trainer:" .. tostring(key or title)
    end
    if not key then return end

    local record = records[key] or {}
    record.name = title or record.name
    if kind == "trainer" then record.spellID = trainer_spell_id end
    local lines = {}
    for _, row in ipairs(rows) do
        local source = safe_text(row.source) or safe_text(row.visible)
        if visible_english_tooltip_text(row.visible)
            and visible_english_tooltip_text(source) then
            lines[#lines + 1] = {
                index = row.index, side = row.side, text = source,
                unapplied = (row.visible == source
                    and (has_ui_translation(source)
                        or (row.index == 1 and row.side == "Left"
                            and translated_name(group, key, source)))) or nil,
            }
        end
    end
    if #lines == 0 then
        records[key] = nil
    else
        record.lines = lines
        records[key] = record
    end
end

local function field_text(value)
    if type(value) == "string" then return string.format("%q", value) end
    return tostring(value)
end

local NOT_APPLIED = "[NOT_APPLIED]"

local function redundant_export_field(group, key, record, field)
    local value = record[field]
    if field == "name" and tostring(value) == tostring(key) then return true end
    if field == "text" and tostring(value) == tostring(key) then return true end
    if field == "reply" and value == false then return true end
    if field == "npcID" and group == "gossips"
        and tostring(key):match("^" .. tostring(value) .. ":") then return true end
    if field == "name" and type(record.fields) == "table"
        and record.fields.title == value then return true end
    return false
end

local function normalized_export_text(value)
    value = safe_text(value)
    if not value then return nil end
    return value:gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function domain_store_has_text(store, source)
    local normalized_source = normalized_export_text(source)
    local function matches(value)
        return normalized_source ~= nil
            and normalized_export_text(value) == normalized_source
    end
    for group, records in pairs(store) do
        if group ~= "ui" and group ~= "runtime" and group ~= "unapplied"
            and type(records) == "table" then
            for _, record in pairs(records) do
                if type(record) == "table" then
                    if matches(record.name) or matches(record.text) then return true end
                    if type(record.fields) == "table" then
                        for _, value in pairs(record.fields) do
                            if matches(value) then return true end
                        end
                    end
                    if type(record.lines) == "table" then
                        for _, row in ipairs(record.lines) do
                            if type(row) == "table" and matches(row.text) then return true end
                        end
                    end
                end
            end
        end
    end
    return false
end

local function migrate_lockdown_records(store)
    if type(store) ~= "table" then return end
    local lockdowns = store.lockdowns or {}
    for _, group in ipairs({ "runtime", "unapplied" }) do
        local records = store[group]
        if type(records) == "table" then
            for key, record in pairs(records) do
                if type(record) == "table"
                    and record.reasonDetail == "IN_COMBAT_LOCKDOWN" then
                    record.reason = record.reason or record.outcome
                        or "PROTECTED_REGION"
                    lockdowns[key] = record
                    records[key] = nil
                end
            end
        end
    end
    if next(lockdowns) then store.lockdowns = lockdowns end
end

local function migrate_content_unapplied(group, key, record)
    local unapplied = record and record.unapplied
    if not unapplied then return end
    if group == "quests" and type(unapplied) == "table" then
        local entry = entries.get_entry and entries.get_entry("quest", key)
        local indices = { title = 1, description = 2, objective = 3,
            progress = 4, reward = 5 }
        for field in pairs(unapplied) do
            local source = record.fields and record.fields[field]
            local translation = entry and indices[field] and entry[indices[field]]
            record_domain_diagnostic("quest:" .. tostring(key),
                "quest." .. tostring(field), source, translation, source,
                "quest-gossip")
        end
    elseif group == "gossips" then
        record_domain_diagnostic("gossip:" .. tostring(record.npcID or key),
            "gossip.text", record.text, translated_gossip(record), record.text,
            "quest-gossip")
    elseif group == "books" then
        local book = record.bookID and addon_table.book
            and addon_table.book[record.bookID]
        local translation = type(book) == "table" and book[record.page]
        record_domain_diagnostic("book", "book.page", record.text,
            translation, record.text, "ItemTextFrame")
    elseif group == "objects" then
        record_domain_diagnostic(record.owner or "object-tooltip",
            record.slot or "object.name", record.name, record.translation,
            record.visible or record.name, record.surface or "GameTooltip")
    end
    record.unapplied = nil
end

auto_scan.export_text = function ()
    local saved_mouse_probe = UA_ForeverDB and UA_ForeverDB.scan
        and UA_ForeverDB.scan.mouseProbe
    local include_diagnostics = diagnostics_enabled()
    if not include_diagnostics
        and type(auto_scan.clear_diagnostics) == "function" then
        auto_scan.clear_diagnostics()
        saved_mouse_probe = nil
    end
    if cleared and (not include_diagnostics
        or type(saved_mouse_probe) ~= "table") then return "" end
    local parts = {}
    local store = UA_ForeverDB and UA_ForeverDB.scan and UA_ForeverDB.scan.auto or {}
    migrate_lockdown_records(store)
    local catalog_records = {}
    local invalid_candidate_records = {}
    local catalog = addon_table.forever_catalog
    if include_diagnostics then
        local registry = addon_table.use("translation_registry")
        if type(registry.each_hook) == "function" then
            registry.each_hook(auto_scan.record_hook_status)
        end
    end
    if include_diagnostics and catalog
        and type(catalog.get_ui_conflicts) == "function" then
        for _, conflict in ipairs(catalog.get_ui_conflicts(true)) do
            local sources = {}
            for _, candidate in ipairs(conflict.candidates or {}) do
                sources[#sources + 1] = tostring(candidate.source)
                    .. ":" .. tostring(candidate.value)
            end
            catalog_records[conflict.key] = {
                reason = conflict.reason,
                winner = conflict.winner,
                winnerSource = conflict.winnerSource,
                winnerTier = conflict.winnerTier,
                candidates = table.concat(sources, " | "),
            }
        end
    end
    if include_diagnostics then
        for _, candidate in ipairs(addon_table.forever_catalog_invalid_candidates or {}) do
            local key = tostring(candidate.domain) .. ":" .. tostring(candidate.id)
            invalid_candidate_records[key] = candidate
        end
    end
    for _, descriptor in ipairs(groups) do
        local group, label = descriptor[1], descriptor[2]
        local records = {}
        if include_diagnostics or not diagnostic_groups[group] then
            records = group == "hooks" and hook_states
                or group == "catalog_conflicts" and catalog_records
                or group == "invalid_candidates" and invalid_candidate_records
                or group == "gossips" and gossip_records_for_export(store[group])
                or store[group] or {}
        end
        local keys = {}
        for key, record in pairs(records) do
            if type(record) == "table" then
                if content_groups[group] then
                    migrate_content_unapplied(group, key, record)
                end
                local keep = true
                if group == "skills" then
                    keep = english_source(record.name) and not has_ui_translation(record.name)
                        and not entries.get_glossary_text(record.name)
                elseif domains[group] and group ~= "quests" then
                    keep = (group ~= "npcs" or english_source(record.name))
                        and (not translated_name(group, key, record.name)
                            or type(record.lines) == "table")
                elseif group == "gossips" then
                    keep = english_source(record.text)
                        and not translated_gossip(record)
                elseif group == "chats" then
                    local ok, _, translated = pcall(entries.get_chat_text,
                        record.npc, record.text)
                    keep = english_source(record.text) and not (ok and translated)
                elseif group == "system_chat" then
                    keep = english_source(record.text)
                    if keep and type(auto_scan.system_chat_translated) == "function" then
                        local ok, translated = pcall(auto_scan.system_chat_translated,
                            record.event, record.text)
                        keep = not (ok and translated)
                    end
                elseif group == "combat_text" then
                    keep = english_source(record.text)
                elseif group == "objects" then
                    local translated = addon_table.translate_object_name
                        and addon_table.translate_object_name(record.name)
                        or addon_table.zone and addon_table.zone[record.name]
                    keep = english_source(record.name)
                        and (not record.visible or record.visible == record.name)
                        and not translated
                elseif group == "zones" then
                    local translated = translated_zone(record.name)
                    keep = english_source(record.name)
                        and (not record.visible or record.visible == record.name)
                        and (not translated or record.unapplied == true)
                elseif group == "unapplied" then
                    keep = english_source(record.text)
                        and type(record.translation) == "string"
                        and record.translation ~= "" and record.translation ~= record.text
                elseif group == "compatibility" then
                    keep = record.reason ~= "DEVELOPER_CAPTURE"
                        and record.reason ~= "REGISTERED_STATIC_SCAN"
                elseif group == "hooks" then
                    keep = true
                elseif group == "runtime" then
                    keep = record.applied ~= true
                        or record.outcome ~= "APPLIED"
                        and record.outcome ~= "RETAINED_AFTER_APPLY"
                elseif group == "observed_ui" then
                    keep = english_source(record.text)
                elseif group == "books" then
                    local book = record.bookID and addon_table.book
                        and addon_table.book[record.bookID]
                    local translated = type(book) == "table" and book[record.page]
                    keep = english_source(record.text)
                        and not (type(translated) == "string" and translated ~= ""
                            and translated ~= record.text)
                elseif group == "ui" then
                    keep = english_source(record.text)
                        and not domain_owned_ui_slot(record.slot)
                        and not (type(strings.is_known_player_name) == "function"
                            and strings.is_known_player_name(record.text))
                        and not has_ui_translation(record.text)
                        and not domain_store_has_text(store, record.text)
                elseif group == "quests" then
                    local entry = entries.get_entry and entries.get_entry("quest", key)
                    local fields = {}
                    local indices = { title = 1, description = 2, objective = 3,
                        progress = 4, reward = 5 }
                    for field, value in pairs(record.fields or {}) do
                        local index = indices[field]
                        local translation = index and entry and entry[index]
                        if field:match("^task%d+$") and entries.translate_quest_objective_task then
                            local ok, result = pcall(entries.translate_quest_objective_task,
                                value, key, record.objectiveSource)
                            if ok then translation = result end
                        end
                        if english_source(value) and (type(translation) ~= "string"
                            or translation == "" or translation == value) then
                            fields[field] = value
                        end
                    end
                    if not next(fields) and english_source(record.name)
                        and not translated_name(group, key, record.name) then
                        fields.title = record.name
                    end
                    if next(fields) then
                        record.fields = fields
                        if not fields.title then record.name = nil end
                    else keep = false end
                end
                if type(record.lines) == "table" then
                    local lines = {}
                    for _, row in ipairs(record.lines) do
                        local title_translated = row.index == 1 and row.side == "Left"
                            and translated_name(group, key, row.text)
                        local ui_translated = has_ui_translation(row.text)
                        local globally_covered_item_line = group == "items"
                            and ui_translated
                        if visible_english_tooltip_text(row.text)
                            and not globally_covered_item_line
                            and (row.unapplied or (not title_translated
                                and not ui_translated)) then
                            lines[#lines + 1] = row
                        end
                    end
                    record.lines = lines
                    if #lines == 0 then keep = false end
                end
                if keep then
                    keys[#keys + 1] = key
                elseif content_groups[group] then
                    records[key] = nil
                end
            end
        end
        table.sort(keys, function (a, b) return tostring(a) < tostring(b) end)
        local lines = { label .. " | " .. #keys }
        local function add(line)
            lines[#lines + 1] = line
        end
        for _, key in ipairs(keys) do
            local record = records[key]
            if type(record) == "table" then
                add("\n# " .. tostring(key))
                local record_unapplied = record.unapplied == true
                    or group == "unapplied"
                local fields_unapplied = false
                if type(record.unapplied) == "table" then
                    fields_unapplied = next(record.unapplied) ~= nil
                end
                local output_fields
                if group == "unapplied" then
                    output_fields = { "owner", "slot", "surface", "text",
                        "translation", "visible", "event", "handler", "attempts",
                        "hook", "hookAvailable", "hookObserved", "reason",
                        "reasonDetail", "regionKey", "lookupTier", "catalogSource" }
                elseif group == "lockdowns" then
                    output_fields = { "owner", "slot", "surface", "text",
                        "translation", "visible", "reason", "reasonDetail",
                        "regionKey", "lookupTier", "catalogSource" }
                elseif group == "runtime" then
                    output_fields = { "owner", "slot", "surface", "text",
                        "translation", "visible", "lookupTier", "catalogSource",
                        "phase", "generation", "instance", "applied", "retained",
                        "outcome", "reasonDetail", "regionKey" }
                elseif group == "observed_ui" then
                    output_fields = { "owner", "slot", "surface", "text",
                        "translation", "visible", "optionEnabled", "outcome" }
                elseif group == "hooks" then
                    output_fields = { "surface", "kind", "target", "method",
                        "blizzardAddon", "required", "fallbackEvent",
                        "verifiedBuild", "available", "installed", "observed",
                        "observedCalls", "lastError" }
                elseif group == "catalog_conflicts" then
                    output_fields = { "reason", "winner", "winnerSource",
                        "winnerTier", "candidates" }
                elseif group == "compatibility" then
                    output_fields = { "reason", "context", "count" }
                elseif group == "invalid_candidates" then
                    output_fields = { "domain", "id", "source", "english",
                        "reason", "action" }
                elseif group == "technical_literals" then
                    output_fields = { "text", "translation", "source", "slot",
                        "reason" }
                elseif group == "unsafe" then
                    output_fields = { "reason", "count" }
                elseif record_unapplied or fields_unapplied then
                    output_fields = { "spellID", "npcID", "bookID", "page",
                        "translation", "visible", "owner", "slot", "surface",
                        "reason", "template", "personalized",
                        "personalizationConfidence", "translationHint",
                        "templateCode" }
                else
                    output_fields = { "spellID", "npcID", "bookID", "page",
                        "npc", "name", "text", "translation", "visible",
                        "owner", "slot", "surface",
                        "reason", "event", "language", "reply", "global",
                        "current", "capture", "template", "personalized",
                        "personalizationConfidence", "translationHint",
                        "templateCode" }
                end
                for _, field in ipairs(output_fields) do
                    if record[field] ~= nil
                        and not redundant_export_field(group, key, record, field) then
                        add(field .. " = " .. field_text(record[field]))
                    end
                end
                if record_unapplied then add(NOT_APPLIED) end
                if type(record.fields) == "table" then
                    local fields = {}
                    for field in pairs(record.fields) do fields[#fields + 1] = field end
                    table.sort(fields)
                    local tag_added = record_unapplied
                    for _, field in ipairs(fields) do
                        if record.unapplied and record.unapplied[field] then
                            if not tag_added then
                                add(NOT_APPLIED)
                                tag_added = true
                            end
                        else
                            add(field .. " = " .. field_text(record.fields[field]))
                        end
                    end
                end
                for _, row in ipairs(record.lines or {}) do
                    add(tostring(row.index) .. " " .. tostring(row.side) .. " = "
                        .. (row.unapplied and NOT_APPLIED or field_text(row.text)))
                end
            end
        end
        if #lines > 1 then parts[#parts + 1] = table.concat(lines, "\n") end
    end

    local probe = saved_mouse_probe
    if include_diagnostics and type(probe) == "table" then
        local lines = { "[MOUSE_PROBE] | 1", "", "# Aura tooltip probe" }
        local function add(field, value)
            if value ~= nil then
                lines[#lines + 1] = field .. " = " .. field_text(value)
            end
        end
        add("focusCount", probe.count or 0)
        for index, row in ipairs(probe.foci or {}) do
            lines[#lines + 1] = ""
            lines[#lines + 1] = "## focus " .. index
            for _, field in ipairs({ "focus", "depth", "name", "objectType",
                "id", "forbidden", "protected", "hasAuraInstance",
                "hasIcon", "iconTexture", "iconAtlas" }) do
                add(field, row[field])
            end
        end

        local auras = probe.targetAuras or {}
        lines[#lines + 1] = ""
        lines[#lines + 1] = "## TargetFrame.Auras"
        add("status", auras.status)
        add("childCount", auras.count or 0)
        for index, row in ipairs(auras.children or {}) do
            lines[#lines + 1] = ""
            lines[#lines + 1] = "### child " .. index
            for _, field in ipairs({ "depth", "name", "objectType", "id",
                "shown", "mouseOver", "forbidden", "protected",
                "hasGetIcon", "hasGetAuraInstance", "hasShowTooltip",
                "hasPopulateTooltip", "iconTexture", "iconAtlas" }) do
                add(field, row[field])
            end
        end
        for _, group in ipairs(auras.api or {}) do
            lines[#lines + 1] = ""
            lines[#lines + 1] = "## API " .. tostring(group.unit or "target")
                .. " " .. tostring(group.filter)
            add("unit", group.unit or "target")
            add("auraCount", #(group.rows or {}))
            add("secret", group.secret)
            add("failed", group.failed)
            for _, row in ipairs(group.rows or {}) do
                lines[#lines + 1] = ""
                lines[#lines + 1] = "### aura " .. tostring(row.index)
                for _, field in ipairs({ "name", "spellID", "icon",
                    "auraInstanceID" }) do
                    add(field, row[field])
                end
            end
        end
        lines[#lines + 1] = ""
        lines[#lines + 1] = "## EnumerateFrames GameTooltip"
        add("tooltipCount", #(auras.enumeratedTooltips or {}))
        for index, row in ipairs(auras.enumeratedTooltips or {}) do
            lines[#lines + 1] = ""
            lines[#lines + 1] = "### tooltip " .. index
            for _, field in ipairs({ "name", "forbidden", "protected",
                "mouseOver", "parent" }) do
                add(field, row[field])
            end
        end
        parts[#parts + 1] = table.concat(lines, "\n")
    end
    return table.concat(parts, "\n\n")
end

auto_scan.clear_diagnostics = function ()
    local scan = UA_ForeverDB and UA_ForeverDB.scan
    local store = scan and scan.auto
    if type(store) == "table" then
        for group in pairs(diagnostic_groups) do store[group] = nil end
    end
    if type(scan) == "table" then
        for _, field in ipairs(technical_scan_fields) do scan[field] = nil end
    end
    local missing = UA_ForeverDB and UA_ForeverDB.missing
    if type(missing) == "table" then
        for group in pairs(missing) do
            if not content_groups[group] then missing[group] = nil end
        end
    end
    hook_states = {}
    diagnostic_retention = {}
end

auto_scan.clear = function ()
    if UA_ForeverDB and UA_ForeverDB.scan then
        for field in pairs(UA_ForeverDB.scan) do
            UA_ForeverDB.scan[field] = nil
        end
        UA_ForeverDB.scan.auto = {}
    end
    if UA_ForeverDB then UA_ForeverDB.missing = {} end
    surface_states = {}
    hook_states = {}
    diagnostic_retention = {}
    cleared = true
    suppress_developer_capture = true
end
