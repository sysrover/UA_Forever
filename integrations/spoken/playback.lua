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

local function matched_name_entry(category, id, title)
    if not public_id(id) or runtime.is_secret_value(title) then return nil end
    local entry = entries.get_entry(category, id, 1)
    if not entry then return nil end
    if readable(entry.en) and readable(title)
        and not utils.same_english_name(entry.en, title)
        and not (readable(entry[1]) and utils.same_english_name(entry[1], title)) then return nil end
    return entry
end

local function quest_text(clip, field)
    local source = readable(clip.text) and clip.text or (readable(clip.packText) and clip.packText or nil)
    local entry = entries.get_entry("quest", clip.questID, field, source)
    return entry and readable(entry[field]) and entry[field] or nil
end

spoken.prepare_playback = function ()
    local quests = _G.VoiceOver
    if not quests or quests.AddonFolder ~= "Spoken_Quests" then return end
    local sound_event = quests.Enums and quests.Enums.SoundEvent
    local guid = quests.Enums and quests.Enums.GUID
    if not sound_event or not sound_event.QuestAccept or not sound_event.QuestProgress
        or not sound_event.QuestComplete or not guid or type(guid.IsCreature) ~= "function" or not quests.Utils
        or type(quests.Utils.ReadIDFromGUID) ~= "function" then return end
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
            local quest = matched_name_entry("quest", clip.questID, clip.title)
            if quest then
                if options.section_enabled("quest_text") then words = quest_text(clip, field) end
                if options.section_enabled("quest_names") and options.translate_name("quest") then
                    title = quest[1]
                end
            end
        elseif (clip.event == sound_event.Gossip or clip.event == sound_event.QuestGreeting)
            and guid:IsCreature(kind) and options.section_enabled("gossip")
            and public_id(id) and readable(clip.text) then
            words = entries.find_gossip_translation(id, clip.text, false)
        end

        if readable(clip.name) then
            local npc
            if (kind == guid.Creature or kind == guid.Vehicle) and options.section_enabled("npc_target") then
                npc = matched_name_entry("npc", id, clip.name)
            elseif kind == guid.GameObject and options.section_enabled("objects") then
                npc = matched_name_entry("object", id, clip.name)
            end
            name = npc and npc[1]
        end
        if readable(title) then display.label = utils.cap(title) end
        if readable(name) then display.header = utils.cap(name) end
        if readable(words) then
            -- Audio resolution has already completed. Spoken estimates caption timing
            -- from the translated words when the recording's word offsets are absent.
            display.transcript = words
            display.timings = nil
        end
        if readable(title) or readable(name) or readable(words) then display.font = assets.font_frizqt end
    end)
end
