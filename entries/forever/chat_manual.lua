local _, addonTable = ...

-- Codes are taken from the in-game NPC speech scan and override generated hashes.
local manual = {
    ["Greishan Ironstove"] = {
        [1] = "Ґрейшан Сталежар",
        ["gmwetyaeneadfhlsofbdhe"] = [===[Налітайте, поки свіжі! Свіжі буханці хліба!]===],
    },
    ["Jarven Thunderbrew"] = {
        [1] = "Ярвен Громовар",
        ["hytebmgememgoftraeadoefrmygdfdsw"] = [===[Привіт, Бельме! Налий мені кухоль громузвару, і ще один — моєму доброму другу Соу.]===],
    },
    ["Muren Stormpike"] = {
        [1] = "Мурен Бурешпиль",
        ["fldnadrrwrnrsshsbktohsfe"] = [===[Бувай, {ім'я:к}. І пам'ятай: воїн ніколи не повертається спиною до ворога!#Farewell, <name>.]===],
    },
    ["Ol' Emma"] = {
        [1] = "Стара Емма",
        ["tkimsgtowrrtintepgss"] = [===[Здається, я вже протоптала доріжку в бруківці.]===],
    },
    ["Topper McNabb"] = {
        [1] = "Топпер Мак-Набб",
        ["asfrtepr"] = [===[Милостиню бідному?]===],
        ["cdyesesecn"] = [===[Не знайдеться монетки?]===],
        ["seyrarfrcr"] = [===[Почищу обладунок за мідяк.]===],
    },
    ["Tormus Deepforge"] = {
        [1] = "Тормус Глибококузень",
        ["kgimfd"] = [===[Кеглеґу! Я закінчив!]===],
        ["brimfd"] = [===[Ще більше! Я закінчив!]===],
        ["dnimfd"] = [===[Darrin! Я закінчив!]===],
        ["ofimfd"] = [===[Olof! Я закінчив!]===],
        ["bstowk"] = [===[%s береться до роботи...]===],
    },
    ["Miner Grumnal"] = {
        [1] = "шахтар Ґрумнал",
        ["iltewryagtcnadtwinbetowhitdn"] = [===[Візьму все, що наготуєш! І пляшку чогось, щоб запити!]===],
    },
    ["Ozzie Togglevolt"] = {
        [1] = "Оззі Вольтон",
        ["bktotedgbd"] = [===[Доведеться повернутися до креслень.]===],
        ["psbtmegewldotetk"] = [===[Може, ще трохи мастила — і все запрацює.]===],
    },
    ["Razzle Sprysprocket"] = {
        [1] = "Раззл Жвавоверт",
        ["ltmeiltegcgsadrncsadwlfeupterr"] = [===[Дай мені встановити ці гіромеханічні шестірні та зубці рестабілізації, і ми запустимо Рекомбобулятор.]===],
        ["mtdy"] = [===[Авжеж.]===],
        ["tetoseteeeghrehegsng"] = [===[Час урятувати весь гном'ячий народ. Ну, поїхали!]===],
        ["ttsddotetk"] = [===[Це має спрацювати.]===],
        ["wstgtesetg"] = [===[Я подумав про те саме.]===],
    },
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
        ["hptecnofsdvsoftewradpe"] = [===[Допоможіть дітям Штормовію... жертвам війни та чуми!]===],
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
