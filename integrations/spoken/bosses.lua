local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local runtime = addon_table.use("translation_runtime")
local assets = addon_table.use("assets")
local hooks = addon_table.use("translation_hooks").bind("spoken-bosses")
local profile = addon_table.use("performance_profile").wrap or function (_, callback) return callback end
local names = addon_table.spoken_boss_names_uk
local stories = addon_table.spoken_bosses_uk

local function enabled()
    return spoken.entries_ready and options.can_translate("translate_spoken")
end

local function readable(text)
    return not runtime.is_secret_value(text) and type(text) == "string" and text ~= ""
end

spoken.boss_title = function (map_id, key, source)
    if not enabled() or not options.section_enabled("npc_target") or not readable(source) then return nil end
    if runtime.is_secret_value(map_id) or runtime.is_secret_value(key) then return nil end
    local translated = names[map_id]
    if translated and translated[key] then return translated[key] end

    local creatures = _G.SpokenBossCreatures
    local dungeon = creatures and creatures[map_id]
    local boss = dungeon and dungeon[key]
    local entry = boss and boss.creature and entries.get_entry("npc", boss.creature)
    return entry and readable(entry[1]) and entry[1] or entries.lookup_name("npc", source)
end

spoken.boss_text = function (map_id, key)
    if not enabled() or runtime.is_secret_value(map_id)
        or runtime.is_secret_value(key) then return nil end
    local dungeon = stories[map_id]
    return dungeon and dungeon[key] or nil
end

spoken.prepare_bosses = function ()
    local bosses = _G.SpokenBossesAddon
    if type(bosses) ~= "table" then return end
    hooks.once("story", function ()
        local original = bosses.StoryClip
        if type(original) ~= "function" then return false end
        bosses.StoryClip = profile("spoken-bosses.story", function (self, map_id, key, ...)
            local clip = original(self, map_id, key, ...)
            if not enabled() or not clip or not clip.present then return clip end
            local display = clip.present
            local title = spoken.boss_title(map_id, key, display.label)
            local header = spoken.place_name(display.header)
            local text = spoken.boss_text(map_id, key)
            if title then display.label = title end
            if header then display.header = header end
            if text then
                display.transcript = text
                display.timings = nil
                if clip.textOnly then
                    local _, words = text:gsub("%S+", "")
                    clip.length = math.max(6, words / 2.5)
                end
            end
            if title or header or text then display.font = assets.font_frizqt end
            return clip
        end)
        return true
    end)
end
