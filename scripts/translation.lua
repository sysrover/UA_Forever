local _, addon_table = ...

local translation = addon_table.use("translation")

translation.original = {}
translation.preferred_quest_language = "uk"

local function current_quest_id()
    if type(_G.GetQuestID) == "function" then
        local id = GetQuestID()
        if id and id > 0 then
            return id
        end
    end
    if C_QuestLog and type(C_QuestLog.GetSelectedQuest) == "function" then
        local id = C_QuestLog.GetSelectedQuest()
        if id and id > 0 then
            return id
        end
    end
end

translation.get_current_quest_id = current_quest_id

translation.get_quest_language = function ()
    return translation.preferred_quest_language
end

translation.set_quest_language = function (language)
    if language == "uk" or language == "en" then
        translation.preferred_quest_language = language
    end
end

translation.prepare = function ()
    if translation.prepared then
        return
    end
    translation.prepared = true
end
