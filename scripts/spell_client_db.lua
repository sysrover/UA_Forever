local _, addon_table = ...

local lookup = addon_table.use("spell_client_db")

local databases = {
    spell_names_en = addon_table.client_spell_names_en,
    spell_names_uk = addon_table.client_spell_names_uk,
    spell_descriptions_en = addon_table.client_spell_descriptions_en,
    spell_descriptions_uk = addon_table.client_spell_descriptions_uk,
    aura_descriptions_en = addon_table.client_aura_descriptions_en,
    aura_descriptions_uk = addon_table.client_aura_descriptions_uk,
}

local source_build
local validation_error

for name, database in pairs(databases) do
    if type(database) ~= "table" or type(database.rows) ~= "table"
        or type(database.sourceBuild) ~= "string" then
        validation_error = "invalid database: " .. name
        break
    end
    if source_build and database.sourceBuild ~= source_build then
        validation_error = "sourceBuild mismatch: " .. name
        break
    end
    source_build = database.sourceBuild
end

lookup.source_build = source_build
lookup.validation_error = validation_error
lookup.ready = validation_error == nil

local function get_row(database, spell_id)
    if not lookup.ready or type(spell_id) ~= "number" then return nil end
    return database.rows[spell_id]
end

lookup.get_name = function (spell_id)
    return get_row(databases.spell_names_uk, spell_id)
end

lookup.get_english_name = function (spell_id)
    return get_row(databases.spell_names_en, spell_id)
end

lookup.get_description = function (spell_id)
    return get_row(databases.spell_descriptions_uk, spell_id)
end

lookup.get_aura_description = function (spell_id)
    return get_row(databases.aura_descriptions_uk, spell_id)
end

lookup.get_english_description = function (spell_id)
    return get_row(databases.spell_descriptions_en, spell_id)
end

lookup.get_english_aura_description = function (spell_id)
    return get_row(databases.aura_descriptions_en, spell_id)
end

local details = addon_table.client_spell_details
lookup.details_ready = type(details) == "table" and type(details.rows) == "table"
    and details.sourceBuild == source_build and lookup.ready

local function resolved_details(spell_id, seen, depth)
    if not lookup.details_ready then return nil end
    if (depth or 0) >= 16 or seen and seen[spell_id] then return nil end
    local row = details.rows[spell_id]
    if type(row) ~= "table" then return nil end
    seen = seen or {}
    seen[spell_id] = true
    local result = {}
    local inherited = row.ref and resolved_details(row.ref, seen, (depth or 0) + 1)
    for key, value in pairs(inherited or {}) do result[key] = value end
    for key, value in pairs(row) do result[key] = value end
    seen[spell_id] = nil
    return result
end

lookup.get_details = function (spell_id)
    return resolved_details(spell_id)
end

-- Compatibility consumers receive the same record shape, owned by client DBs.
-- The inherited detail record must never supply a second spell-name source.
lookup.get_entry = function (spell_id)
    if not lookup.ready then return nil end
    local result = resolved_details(spell_id) or {}
    result[1] = lookup.get_name(spell_id)
    result.en = lookup.get_english_name(spell_id)
    result[2] = lookup.get_description(spell_id) or result[2]
    result[3] = lookup.get_aura_description(spell_id) or result[3]
    if next(result) then return result end
end

local function safe_number(value)
    if type(value) ~= "number" then return nil end
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return value
end

local function comparable_name(value)
    if type(value) ~= "string" then return nil end
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, value)
        if not ok or secret then return nil end
    end
    return value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$"):lower()
end

-- Pet spellbook rows mix real spell IDs with service IDs used by commands and
-- stances. Accept a candidate only when the English name from the client spell
-- database matches the native row/tooltip name. This keeps real pet abilities
-- on the ID-backed spell pipeline without treating service values such as
-- 1, 3 and 4 as unrelated SpellName.db2 records.
lookup.resolve_spellbook_item_id = function (info, expected_name)
    if type(info) ~= "table" then return nil, false end
    local item_type = safe_number(info.itemType)
    local pet_action_type = Enum and Enum.SpellBookItemType
        and Enum.SpellBookItemType.PetAction
    local is_pet_action = item_type and pet_action_type
        and item_type == pet_action_type or false
    if not is_pet_action then return safe_number(info.spellID), false end

    local native_name = comparable_name(expected_name)
        or comparable_name(info.name)
    if not native_name then return nil, true end

    local candidates, seen = {}, {}
    local function add_candidate(value)
        value = safe_number(value)
        if value and not seen[value] then
            candidates[#candidates + 1] = value
            seen[value] = true
        end
    end

    add_candidate(info.spellID)
    local action_id = safe_number(info.actionID)
    if action_id and _G.C_PetInfo
        and type(_G.C_PetInfo.GetSpellForPetAction) == "function" then
        local ok, spell_id = pcall(_G.C_PetInfo.GetSpellForPetAction, action_id)
        if ok then add_candidate(spell_id) end
    end

    for _, spell_id in ipairs(candidates) do
        if comparable_name(lookup.get_english_name(spell_id)) == native_name then
            return spell_id, true
        end
    end
    return nil, true
end

lookup.has_spell_translation = function (spell_id)
    return lookup.get_name(spell_id) ~= nil
        or lookup.get_description(spell_id) ~= nil
end

lookup.has_aura_translation = function (spell_id)
    return lookup.get_name(spell_id) ~= nil
        or lookup.get_aura_description(spell_id) ~= nil
end

lookup.get_english_name_rows = function ()
    return lookup.ready and databases.spell_names_en.rows or nil
end

-- Exact build-owned names only. Deterministic ID ordering matches the item
-- name lookup; no substring replacement or translated-text recognition.
local spell_id_by_english_name
lookup.get_id_by_english_name = function (english_name)
    if not lookup.ready or type(english_name) ~= "string" then return nil end
    if not spell_id_by_english_name then
        spell_id_by_english_name = {}
        for id, name in pairs(databases.spell_names_en.rows) do
            local translated = lookup.get_name(id)
            if type(name) == "string" and translated and translated ~= name then
                local known = spell_id_by_english_name[name]
                if not known or id < known then spell_id_by_english_name[name] = id end
            end
        end
    end
    return spell_id_by_english_name[english_name]
end

lookup.get_name_by_english = function (english_name)
    local id = lookup.get_id_by_english_name(english_name)
    return id and lookup.get_name(id) or nil
end
