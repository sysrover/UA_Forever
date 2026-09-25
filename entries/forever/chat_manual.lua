local _, addonTable = ...

-- Codes are taken from the in-game NPC speech scan and override generated hashes.
local manual = {
    ["Durnan Furcutter"] = {
        [1] = "Дарнан Хутростриг",
        ["oohththtifttwtptsginyrspdtkwwtwl"] = [===[Ой-ой-ой, гаряче! Якщо це не додасть тобі бадьорості, то вже не знаю, що додасть!]===],
        ["tsnglesesgmwoncydnmhdytogttssdrt"] = [===[Немає нічого кращого за гарячий ранковий напій у прохолодний день у Дун-Морозі, щоб добре почати день!]===],
    },
    ["Eric Brighthammer"] = {
        [1] = "Ерік Ясномолот",
        ["alyundtostcpofyronisbccecscngythyuhwtomeoeofte"] = [===[Щоб облаштувати власний табір, тобі потрібне лише звичайне вогнище. Кухарі зазвичай можуть навчити тебе його розпалювати.]===],
        ["goonadhestnrtefeadwecngtsd"] = [===[Сідай біля вогнища, і ми почнемо.]===],
    },
    ["John Turner"] = {
        [1] = "Джон Тернер",
        ["geofyrhsadyrpsgetotecnofsdwohelttrps"] = [===[Не шкодуйте ні сердець, ні гаманців! Допоможіть дітям Штормовію, які втратили батьків.]===],
    },
    ["Rifleman Middlecamp"] = {
        [1] = "стрілець Депривал",
        ["ssfmtehpattebs"] = [===[%s стріляє від стегна по пляшках...]===],
    },
}

addonTable.chat = addonTable.chat or {}
for npcName, entries in pairs(manual) do
    local target = addonTable.chat[npcName] or {}
    for code, translation in pairs(entries) do
        target[code] = translation
    end
    addonTable.chat[npcName] = target
end
