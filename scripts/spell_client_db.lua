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
