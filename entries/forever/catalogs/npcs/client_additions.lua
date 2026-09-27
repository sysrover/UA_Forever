local _, addonTable = ...

local client_npcs = {
    [2756] = { "Ґрунд Дрокда", en="Grund Drokda" },
    [6046] = { "Ґозвін Півшестерні", en="Gozwin Halfsprocket" },
    [41938] = { "тотем тремтіння", en="Tremor Totem" },
    [257446] = { "Тео Молотобур", "тренер шаманів", en="Teo Hammerstorm" },
    [263398] = { "табірний намет", en="Camp Tent" },
    [267279] = { "Кадок Зимосерд", "помічник горянина", en="Cadoc Winterheart" },
    [267336] = { "Бріґід Бурешкура", "молодший тренер шкуродерства", en="Brighid Stormflayer" },
    [267337] = { "Саллі Швидкоключ", "молодший тренер гірництва", en="Sally Swiftwrench" },
    [267338] = { "Емріс Кремнебород", "молодший тренер травництва", en="Emrys Flintbeard" },
    [271486] = { "шаман-вендиго", en="Wendigo Shaman" },
}
addonTable.npc = addonTable.npc or {}
for id, entry in pairs(client_npcs) do
    local curated = addonTable.npc[id]
    if type(curated) == "table" then
        for field, value in pairs(entry) do
            if curated[field] == nil then curated[field] = value end
        end
    elseif curated == nil then
        addonTable.npc[id] = entry
    end
end

