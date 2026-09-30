local _, addonTable = ...

-- Player-visible talent-frame text for the Camelot UI in client build 70058.
-- Talent identity and descriptions are resolved separately by entryID/rank and
-- spellID through the generated client databases.
addonTable.talent_ui = {
    spec_tabs = {
        primary = { source = "Primary", translated = "Основна" },
        secondary = { source = "Secondary", translated = "Додаткова" },
    },
    spec_names = {
        ["Affliction"] = "Страждання",
        ["Arcane"] = "Чари",
        ["Arms"] = "Зброя",
        ["Assassination"] = "Ліквідація",
        ["Balance"] = "Рівновага",
        ["Beast Mastery"] = "Володіння звірами",
        ["Combat"] = "Бій",
        ["Demonology"] = "Демонологія",
        ["Destruction"] = "Руйнування",
        ["Discipline"] = "Дисципліна",
        ["Elemental"] = "Стихії",
        ["Enhancement"] = "Покращення",
        ["Feral Combat"] = "Дикий бій",
        ["Fire"] = "Вогонь",
        ["Frost"] = "Крига",
        ["Fury"] = "Шаленство",
        ["Holy"] = "Світло",
        ["Marksmanship"] = "Стрільба",
        ["Protection"] = "Захист",
        ["Restoration"] = "Відновлення",
        ["Retribution"] = "Відплата",
        ["Shadow"] = "Тінь",
        ["Subtlety"] = "Вправність",
        ["Survival"] = "Виживання",
    },
}
