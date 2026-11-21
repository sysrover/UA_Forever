local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local assets = addon_table.use("assets")
local hooks = addon_table.use("translation_hooks").bind("spoken-playback")

local function readable(value)
    return not runtime.is_secret_value(value) and type(value) == "string" and value ~= ""
end

local function public_id(value)
    return not runtime.is_secret_value(value) and type(value) == "number" and value > 0
end

local function checked_entry(category, id, title, field, source)
    if not public_id(id) then return nil end
    local entry = entries.get_entry(category, id, field, source)
    if not entry or not readable(entry[field or 1]) then return nil end
    if readable(entry.en) and readable(title)
        and not utils.same_english_name(entry.en, title)
        and not utils.same_english_name(entry[field == nil and 1 or field], title) then return nil end
    return entry[field or 1]
end

local function quest_text(clip, field)
    -- Read and validate the quest title independently of the localized body.
    local title = checked_entry("quest", clip.questID, clip.title, 1)
    if not title then return nil end
    local source = readable(clip.text) and clip.text or (readable(clip.packText) and clip.packText or nil)
    local entry = entries.get_entry("quest", clip.questID, field, source)
    return entry and readable(entry[field]) and entry[field] or nil
end

spoken.prepare_playback = function ()
    local quests = _G.VoiceOver
    if not quests or quests.AddonFolder ~= "Spoken_Quests" then return end
    local sound_event = quests.Enums and quests.Enums.SoundEvent
    if not sound_event or not quests.Utils or type(quests.Utils.ReadIDFromGUID) ~= "function" then return end
    local fields = {
        [sound_event.QuestAccept] = 2,
        [sound_event.QuestProgress] = 4,
        [sound_event.QuestComplete] = 5,
    }
    hooks.region(quests.Player, "Prepare", function (_, clip)
        if not spoken.entries_ready or not options.can_translate("translate_spoken")
            or type(clip) ~= "table" or type(clip.present) ~= "table"
            or runtime.is_secret_value(clip.event) then return end

        local field = fields[clip.event]
        local display = clip.present
        local words, title, name
        local id, kind
        if readable(clip.unitGUID) then id, kind = quests.Utils:ReadIDFromGUID(clip.unitGUID) end
        if field and translation.get_quest_language() ~= "en" then
            if options.section_enabled("quest_text") then words = quest_text(clip, field) end
            if options.name_enabled and options.name_enabled("quest") or
                not options.name_enabled and options.translate_name("quest") then
                title = checked_entry("quest", clip.questID, clip.title, 1)
            end
        elseif (clip.event == sound_event.Gossip or clip.event == sound_event.QuestGreeting)
            and options.section_enabled("gossip") and public_id(id) and readable(clip.text) then
            words = entries.find_gossip_translation(id, clip.text, false)
        end

        local guid = quests.Enums.GUID
        if guid and readable(clip.name) then
            if (kind == guid.Creature or kind == guid.Vehicle) and options.section_enabled("npc_target") then
                name = checked_entry("npc", id, clip.name)
            elseif kind == guid.GameObject and options.section_enabled("objects") then
                name = checked_entry("object", id, clip.name)
            end
        end
        if title then display.label = utils.cap(title) end
        if name then display.header = utils.cap(name) end
        if readable(words) then
            -- Audio resolution has already completed. Spoken estimates caption timing
            -- from the translated words when the recording's word offsets are absent.
            display.transcript = words
            display.timings = nil
        end
        if title or name or readable(words) then display.font = assets.font_frizqt end
    end)
end
