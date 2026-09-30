local _, addon_table = ...

local lookup = addon_table.use("profession_client_db")
local database = addon_table.client_profession_recipes
local category_names_uk = addon_table.client_profession_category_names_uk

local validation_error
if type(database) ~= "table" or type(database.sourceBuild) ~= "string"
    or type(database.recipes) ~= "table"
    or type(database.categories) ~= "table" then
    validation_error = "invalid profession recipe database"
elseif type(category_names_uk) ~= "table"
    or type(category_names_uk.rows) ~= "table"
    or category_names_uk.sourceBuild ~= database.sourceBuild then
    validation_error = "invalid profession category translation database"
end

lookup.source_build = database and database.sourceBuild or nil
lookup.validation_error = validation_error
lookup.ready = validation_error == nil

local category_cache = {}

local function decode_recipe(row)
    if type(row) ~= "table" or type(row[1]) ~= "number" then return nil end
    return {
        skillLineID = row[1], categoryID = row[2], minRank = row[3],
        acquireMethod = row[4], abilityID = row[5],
    }
end

lookup.get_recipe = function (recipe_id, skill_line_id, category_id)
    if not lookup.ready or type(recipe_id) ~= "number" then return nil end
    local row = database.recipes[recipe_id]
    if type(row) ~= "table" then return nil end
    local variants = row.variants
    if type(variants) ~= "table" then return decode_recipe(row) end

    local fallback
    for _, candidate in ipairs(variants) do
        local decoded = decode_recipe(candidate)
        fallback = fallback or decoded
        if decoded and (type(category_id) ~= "number"
                or decoded.categoryID == category_id)
            and (type(skill_line_id) ~= "number"
                or decoded.skillLineID == skill_line_id) then
            return decoded
        end
    end
    return fallback
end

lookup.get_category = function (category_id)
    if not lookup.ready or type(category_id) ~= "number" then return nil end
    if category_cache[category_id] then return category_cache[category_id] end
    local row = database.categories[category_id]
    if type(row) ~= "table" then return nil end
    local decoded = {
        categoryID = category_id, skillLineID = row[1], parentID = row[2],
        orderIndex = row[3], flags = row[4], name = row[5], hordeName = row[6],
    }
    category_cache[category_id] = decoded
    return decoded
end

lookup.get_category_name = function (category_id)
    local category = lookup.get_category(category_id)
    return category and category.name or nil
end

lookup.get_category_name_uk = function (category_id)
    if not lookup.ready or type(category_id) ~= "number" then return nil end
    return category_names_uk.rows[category_id]
end
