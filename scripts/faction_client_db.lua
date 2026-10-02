local _, addon_table = ...
local lookup = addon_table.use("faction_client_db")
local database = addon_table.client_factions_uk
local names, texts, player_names = {}, {}, {}

lookup.ready = type(database) == "table" and type(database.rows) == "table"
lookup.source_build = lookup.ready and database.sourceBuild or nil

local function safe(value)
    if type(_G.issecretvalue) ~= "function" then return true end
    local ok, secret = pcall(_G.issecretvalue, value)
    return ok and not secret
end

if lookup.ready then
    for _, row in pairs(database.rows) do
        names[row.en], texts[row.en] = row.name, row.name
        if row.en_description ~= "" and row.description ~= "" then
            texts[row.en_description] = row.description
        end
        local native = row.en:match("^PLAYER,%s*(.-)%s*$")
        local translated = row.name:match("^[^,]+,%s*(.-)%s*$")
        if native and translated then player_names[native] = translated end
    end
end

lookup.get = function (id)
    if not lookup.ready or not safe(id) or type(id) ~= "number" then return nil end
    return database.rows[id]
end

lookup.get_name = function (value)
    if not safe(value) then return nil end
    if type(value) == "number" then
        local row = lookup.get(value)
        return row and row.name
    end
    return type(value) == "string" and names[value] or nil
end

lookup.get_text = function (source)
    if not safe(source) or type(source) ~= "string" then return nil end
    return texts[source]
end

lookup.get_player_name = function (source)
    if not safe(source) or type(source) ~= "string" then return nil end
    return player_names[source:match("^%s*(.-)%s*$")]
end

lookup.prepare = function ()
    local hooks = addon_table.use("translation_hooks").bind("factions")
    local runtime = addon_table.use("translation_runtime")
    local strings = addon_table.use("strings")
    local function translate(region)
        if region and not runtime.is_applying(region) then
            strings.translate_region(region, nil, "faction.progress")
        end
    end
    local function prepare_bars()
        local manager, info = _G.StatusTrackingBarManager, _G.StatusTrackingBarInfo
        local index = info and info.BarsEnum and info.BarsEnum.Reputation
        if not manager or not index or type(manager.barContainers) ~= "table" then return end
        for _, container in ipairs(manager.barContainers) do
            local bar = container.bars and container.bars[index]
            local region = bar and bar.OverlayFrame and bar.OverlayFrame.Text
            hooks.region(region, "SetText", translate)
            hooks.region(region, "SetFormattedText", translate)
            translate(region)
        end
    end
    hooks.region(_G.StatusTrackingBarManager, "UpdateBarsShown", prepare_bars)
    prepare_bars()
end
