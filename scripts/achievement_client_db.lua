local _, addon_table = ...

local lookup = addon_table.use("achievement_client_db")
local database = addon_table.client_achievements_uk

lookup.ready = type(database) == "table"
    and type(database.sourceBuild) == "string"
    and type(database.rows) == "table"
    and type(database.categories) == "table"
lookup.source_build = lookup.ready and database.sourceBuild or nil
lookup.validation_error = not lookup.ready and "invalid achievement translation database" or nil

local function valid_id(id)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, id)
        if not ok or secret then return false end
    end
    return type(id) == "number" and id > 0 and id % 1 == 0
end

lookup.get = function (id)
    if not lookup.ready or not valid_id(id) then return nil end
    return database.rows[id]
end

lookup.get_category_name = function (id)
    if not lookup.ready or not valid_id(id) then return nil end
    return database.categories[id]
end
