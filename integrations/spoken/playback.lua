local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local assets = addon_table.use("assets")
local hooks = addon_table.use("translation_hooks").bind("spoken-playback")

-- Spoken files these repeatable hand-ins under Accept. UA_Forever keeps
-- the same dialogue under Progress, as supplied by the game.
local accept_uses_progress = {
    [7795] = true, [7800] = true, [7805] = true, [7811] = true,
    [7818] = true, [7823] = true, [7824] = true, [7836] = true,
    [78149] = true, [97065] = true, [98888] = true, [98896] = true,
    [99191] = true, [99196] = true,
}

local talismans_offer = "Твоя допомога в тіснині Пісні Війни вже дала плоди. Продовжуй допомагати нам і принеси мені ще талісманів заслуг. Так ти здобудеш іще більше нашої довіри."
local marks_offer = "Твоя допомога в тіснині Пісні Війни вже дала плоди. І далі бийся з Вартовими Срібного Крила! Принеси мені ще відзнак честі!"
local repeatable_offers = {
    [7886] = talismans_offer, [7887] = talismans_offer, [7888] = talismans_offer, [7921] = talismans_offer,
    [7922] = marks_offer, [7923] = marks_offer, [7924] = marks_offer, [7925] = marks_offer,
}

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

spoken.quest_text = function (id, field, source)
    if not public_id(id) then return nil end
    local entry = entries.get_entry("quest", id, field, source)
    if entry and readable(entry[field]) then return entry[field] end
    if field ~= 2 then return nil end

    if accept_uses_progress[id] then
        local progress = entries.get_entry("quest", id, 4, source)
        return progress and readable(progress[4]) and progress[4] or nil
    end
    return repeatable_offers[id]
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
                if options.section_enabled("quest_text") then
                    local source = readable(clip.text) and clip.text or (readable(clip.packText) and clip.packText or nil)
                    words = spoken.quest_text(clip.questID, field, source)
                end
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
        if readable(title) then display.label = title end
        if readable(name) then display.header = name end
        if readable(words) then
            -- Audio resolution has already completed. Spoken estimates caption timing
            -- from the translated words when the recording's word offsets are absent.
            display.transcript = words
            display.timings = nil
        end
        if readable(title) or readable(name) or readable(words) then display.font = assets.font_frizqt end
    end)
end
