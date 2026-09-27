local _, addonTable = ...

local catalog = addonTable.forever_catalog
if not catalog then return end

local function sorted_keys(values)
    local keys = {}
    for key in pairs(values or {}) do
        if type(key) == "string" then keys[#keys + 1] = key end
    end
    table.sort(keys)
    return keys
end

local function sorted_sources()
    local sources = {}
    for _, source in pairs(catalog.ui_sources or {}) do
        sources[#sources + 1] = source
    end
    table.sort(sources, function (left, right)
        local left_tier = catalog.TIERS[left.tier]
        local right_tier = catalog.TIERS[right.tier]
        if left_tier ~= right_tier then return left_tier < right_tier end
        if left.priority ~= right.priority then return left.priority < right.priority end
        return left.name < right.name
    end)
    return sources
end

catalog.compile_ui = function ()
    local output, provenance, conflicts, candidates = {}, {}, {}, {}
    local source_literals, source_literal_provenance = {}, {}
    local curated, reviewed = {}, {}
    for _, source in ipairs(sorted_sources()) do
        if source.player_visible then
            for _, english in ipairs(sorted_keys(source.values)) do
                local ukrainian = source.values[english]
                if type(ukrainian) == "string" and ukrainian ~= "" then
                    candidates[english] = candidates[english] or {}
                    candidates[english][#candidates[english] + 1] = {
                        value = ukrainian,
                        source = source.name,
                        tier = source.tier,
                        priority = source.priority,
                    }
                    output[english] = ukrainian
                    provenance[english] = {
                        source = source.name,
                        tier = source.tier,
                    }
                    if source.tier == "curated" or source.tier == "manual_override" then
                        curated[english] = ukrainian
                    elseif source.tier == "reviewed_import" then
                        reviewed[english] = ukrainian
                    end
                end
            end
        else
            for _, english in ipairs(sorted_keys(source.values)) do
                local ukrainian = source.values[english]
                if type(ukrainian) == "string" and ukrainian ~= "" then
                    source_literals[english] = ukrainian
                    source_literal_provenance[english] = {
                        source = source.name,
                        tier = source.tier,
                    }
                end
            end
        end
    end
    for _, english in ipairs(sorted_keys(candidates)) do
        local rows, values = candidates[english], {}
        for _, row in ipairs(rows) do values[row.value] = true end
        local value_count = 0
        for _ in pairs(values) do value_count = value_count + 1 end
        if value_count > 1 then
            local winner = provenance[english]
            local top_tier = catalog.TIERS[winner.tier]
            local top_priority
            local top_values = {}
            for _, row in ipairs(rows) do
                if catalog.TIERS[row.tier] == top_tier then
                    if top_priority == nil or row.priority > top_priority then
                        top_priority = row.priority
                        top_values = { [row.value] = true }
                    elseif row.priority == top_priority then
                        top_values[row.value] = true
                    end
                end
            end
            local top_value_count = 0
            for _ in pairs(top_values) do top_value_count = top_value_count + 1 end
            conflicts[#conflicts + 1] = {
                key = english,
                winner = output[english],
                winnerSource = winner.source,
                winnerTier = winner.tier,
                candidates = rows,
                unresolved = top_value_count > 1,
                reason = top_value_count > 1
                    and "SAME_TIER_PRIORITY_CONFLICT" or "TIER_OVERRIDE",
            }
        end
    end
    catalog.ui = output
    catalog.ui_provenance = provenance
    catalog.ui_conflicts = conflicts
    catalog.source_literals = source_literals
    catalog.source_literal_provenance = source_literal_provenance
    addonTable.forever_ui = output
    addonTable.forever_ui_curated = curated
    addonTable.forever_ui_generated_reviewed = reviewed
    return output
end

catalog.get_ui_conflicts = function (unresolved_only)
    if not unresolved_only then return catalog.ui_conflicts or {} end
    local result = {}
    for _, conflict in ipairs(catalog.ui_conflicts or {}) do
        if conflict.unresolved then result[#result + 1] = conflict end
    end
    return result
end

catalog.ui_conflict_for = function (key)
    for _, conflict in ipairs(catalog.ui_conflicts or {}) do
        if conflict.key == key then return conflict end
    end
end

catalog.lookup_ui = function (text, normalized)
    local key = catalog.ui and catalog.ui[text] and text
        or catalog.ui and catalog.ui[normalized] and normalized or nil
    if not key then return nil end
    return catalog.ui[key], catalog.ui_provenance[key], key
end

catalog.lookup_source_literal = function (text, normalized)
    local key = catalog.source_literals and catalog.source_literals[text] and text
        or catalog.source_literals and catalog.source_literals[normalized]
            and normalized or nil
    if not key then return nil end
    return catalog.source_literals[key], catalog.source_literal_provenance[key], key
end

catalog.compile_ui()

catalog.invalid_candidates = addonTable.forever_catalog_invalid_candidates or {}
