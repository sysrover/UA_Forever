local _, addon_table = ...

local lookup = addon_table.use("item_client_db")

local databases = {
    names_en = addon_table.client_item_names_en,
    names_uk = addon_table.client_item_names_uk,
    descriptions_en = addon_table.client_item_descriptions_en,
    descriptions_uk = addon_table.client_item_descriptions_uk,
    spell_effects = addon_table.client_item_spell_effects,
    spell_reagents = addon_table.client_spell_reagents,
    metadata = addon_table.client_item_metadata,
    skill_lines_en = addon_table.client_skill_lines_en,
    skill_lines_uk = addon_table.client_skill_lines_uk,
}

local required_databases = {
    { name = "names_en", database = databases.names_en },
    { name = "names_uk", database = databases.names_uk },
    { name = "descriptions_en", database = databases.descriptions_en },
    { name = "descriptions_uk", database = databases.descriptions_uk },
}

local source_build
local validation_error

for _, entry in ipairs(required_databases) do
    local name, database = entry.name, entry.database
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

local effects = databases.spell_effects
local effects_error
if type(effects) ~= "table" or type(effects.rows) ~= "table"
    or type(effects.sourceBuild) ~= "string" then
    effects_error = "invalid database: spell_effects"
elseif source_build and effects.sourceBuild ~= source_build then
    effects_error = "sourceBuild mismatch: spell_effects"
end

local reagents = databases.spell_reagents
local reagents_error
if type(reagents) ~= "table" or type(reagents.rows) ~= "table"
    or type(reagents.sourceBuild) ~= "string" then
    reagents_error = "invalid database: spell_reagents"
elseif source_build and reagents.sourceBuild ~= source_build then
    reagents_error = "sourceBuild mismatch: spell_reagents"
end

lookup.source_build = source_build
lookup.validation_error = validation_error
lookup.ready = validation_error == nil
lookup.effects_error = effects_error
lookup.effects_ready = effects_error == nil
lookup.reagents_error = reagents_error
lookup.reagents_ready = reagents_error == nil

local function row(database, item_id)
    if type(database) ~= "table" or type(database.rows) ~= "table"
        or type(item_id) ~= "number" then return nil end
    return database.rows[item_id]
end

-- English text is the only text-based key accepted by the client-build item
-- database. Build this index once at load time; runtime callers never scan the
-- item table and never try to identify an item from translated text.
local item_id_by_english_name = {}
if lookup.ready then
    for item_id, english_name in pairs(databases.names_en.rows) do
        if type(item_id) == "number" and type(english_name) == "string"
            and english_name ~= "" then
            local known_id = item_id_by_english_name[english_name]
            if not known_id or item_id < known_id then
                item_id_by_english_name[english_name] = item_id
            end
        end
    end
end

lookup.get_name = function (item_id)
    return row(databases.names_uk, item_id)
end

lookup.get_english_name = function (item_id)
    return row(databases.names_en, item_id)
end

lookup.get_id_by_english_name = function (english_name)
    if type(english_name) ~= "string" or english_name == "" then return nil end
    return item_id_by_english_name[english_name]
end

lookup.get_name_by_english = function (english_name)
    local item_id = lookup.get_id_by_english_name(english_name)
    return item_id and lookup.get_name(item_id) or nil, item_id
end

lookup.get_english_name_rows = function ()
    return lookup.ready and databases.names_en.rows or nil
end

lookup.get_description = function (item_id)
    return row(databases.descriptions_uk, item_id)
end

lookup.get_english_description = function (item_id)
    return row(databases.descriptions_en, item_id)
end

lookup.get_spell_effects = function (item_id)
    return row(databases.spell_effects, item_id)
end

lookup.get_spell_reagents = function (spell_id)
    if not lookup.reagents_ready then return nil end
    return row(databases.spell_reagents, spell_id)
end

lookup.get_metadata = function (item_id)
    return row(databases.metadata, item_id)
end

lookup.get_skill_line = function (skill_id)
    return row(databases.skill_lines_uk, skill_id)
end

lookup.get_english_skill_line = function (skill_id)
    return row(databases.skill_lines_en, skill_id)
end

lookup.has_translation = function (item_id)
    return lookup.get_name(item_id) ~= nil
        or lookup.get_description(item_id) ~= nil
        or lookup.get_spell_effects(item_id) ~= nil
end
