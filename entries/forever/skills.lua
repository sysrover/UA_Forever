local _, addonTable = ...

-- Display-only translations for Camelot's Skills pane. Skill names are kept
-- here instead of replacing Blizzard globals because some UI code uses the
-- English values as internal lookup keys.
local skills = {
    ["Skills"] = "Навички",
    ["Weapon Skills"] = "Навички володіння зброєю",
    ["Armor Proficiencies"] = "Володіння обладунками",
    ["Languages"] = "Мови",

    ["Axes"] = "Сокири",
    ["One-Handed Axes"] = "Одноручні сокири",
    ["Two-Handed Axes"] = "Дворучні сокири",
    ["Maces"] = "Булави",
    ["One-Handed Maces"] = "Одноручні булави",
    ["Two-Handed Maces"] = "Дворучні булави",
    ["Swords"] = "Мечі",
    ["One-Handed Swords"] = "Одноручні мечі",
    ["Two-Handed Swords"] = "Дворучні мечі",
    ["Daggers"] = "Кинджали",
    ["Staves"] = "Посохи",
    ["Polearms"] = "Держакова зброя",
    ["Bows"] = "Луки",
    ["Guns"] = "Рушниці",
    ["Crossbows"] = "Арбалети",
    ["Thrown"] = "Метальна зброя",
    ["Wands"] = "Жезли",
    ["Fist Weapons"] = "Кистьова зброя",
    ["Dual Wield"] = "Бій з двох рук",
    ["Unarmed"] = "Без зброї",
    ["Defense"] = "Захист",

    ["Cloth"] = "Тканина",
    ["Leather"] = "Шкіра",
    ["Plate Mail"] = "Лати",
    ["Shield"] = "Щит",
    ["Mining"] = "Гірництво",

    ["Common"] = "Спільна",
    ["Dwarven"] = "Дворфійська",
    ["Gnomish"] = "Гномська",
    ["Orcish"] = "Орча",
    ["Darnassian"] = "Дарнаська",
    ["Taurahe"] = "Таурахе",
    ["Gutterspeak"] = "Наріччя Нетрів",
    ["Troll"] = "Трольська",

    ["Higher weapon skill increases your chance to hit."] =
        "Вища навичка володіння зброєю збільшує ймовірність влучити.",
    ["Allows for the use of fist weapons.  Chance to hit is determined by the Unarmed skill."] =
        "Дозволяє використовувати кистьову зброю. Ймовірність влучення визначається навичкою бою без зброї.",
    ["Allows the use of shields."] = "Дозволяє використовувати щити.",
    ["Allows the wearing of cloth armor."] = "Дозволяє носити тканинні обладунки.",
    ["Allows the wearing of leather armor."] = "Дозволяє носити шкіряні обладунки.",
    ["Allows the wearing of mail armor."] = "Дозволяє носити кольчужні обладунки.",
    ["Allows the wearing of plate armor."] = "Дозволяє носити лати.",
    ["Higher alchemy skill allows you to learn higher level alchemy recipes.  Alchemy recipes can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка алхімії дає змогу вивчати рецепти вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Higher cooking skill allows you to learn higher level cooking recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] =
        "Вища навичка кулінарії дає змогу вивчати рецепти вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або як здобич із чудовиськ.",
    ["Higher defense makes you harder to hit and makes monsters less likely to land a crushing blow."] =
        "Вища навичка захисту зменшує ймовірність влучення по вас і завдання чудовиськами нищівного удару.",
    ["Higher enchanting skill allows you to learn more powerful formulae.  Formulae can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка зачарування дає змогу вивчати потужніші формули. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Higher engineering skill allows you to learn higher level engineering schematics.  Schematics can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка інженерії дає змогу вивчати креслення вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Higher engraving skill allows you to learn higher level runes and apply them to your armor and weapons.  Runes can be found hidden throughout the world."] =
        "Вища навичка гравіювання дає змогу вивчати руни вищого рівня та наносити їх на обладунки й зброю. Руни сховані по всьому світу.",
    ["Higher first aid skill allows you to learn higher level first aid abilities.  First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."] =
        "Вища навичка першої допомоги дає змогу вивчати здібності вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або як здобич із чудовиськ.",
    ["Higher fishing skill increases your chance of catching fish in bodies of water around the world.  If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."] =
        "Вища навичка рибальства збільшує ймовірність упіймати рибу у водоймах по всьому світу. Якщо в певній місцевості риба не ловиться, перейдіть до місцевості нижчого рівня або придбайте наживку й спробуйте знову.",
    ["Higher herbalism skill allows you to harvest more difficult herbs around the world.  If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."] =
        "Вища навичка травництва дає змогу збирати складніші трави по всьому світу. Якщо не вдається зібрати певну траву, підвищуйте навичку, збираючи простіші трави в місцевостях нижчого рівня.",
    ["Higher leatherworking skill allows you to learn higher level leatherworking patterns.  Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка шкірництва дає змогу вивчати викрійки вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Higher mining skill allows you to harvest more difficult minerals nodes around the world.  If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."] =
        "Вища навичка гірництва дає змогу видобувати руду зі складніших покладів по всьому світу. Якщо не вдається розробити певний поклад, підвищуйте навичку на простіших покладах у місцевостях нижчого рівня.",
    ["Higher riding skill allows you to ride faster and more exotic beasts."] =
        "Вища навичка верхової їзди дає змогу їздити швидше та верхи на екзотичніших істотах.",
    ["Higher skill allows you to learn higher level recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] =
        "Вища навичка дає змогу вивчати рецепти вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або як здобич із чудовиськ.",
    ["Higher skill increases your chance to hit."] =
        "Вища навичка збільшує ймовірність влучити.",
    ["Higher skinning skill allows you to skin hides from higher level monsters around the world.    Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."] =
        "Вища навичка зняття шкур дає змогу знімати шкури з чудовиськ вищого рівня. Коли навичка перевищить 100, поділіть її значення на 5, щоб визначити найвищий рівень чудовиська, з якого можна зняти шкуру.",
    ["Higher smithing skill allows you to learn higher level smithing plans.  Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка ковальства дає змогу вивчати креслення вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Higher tailoring skill allows you to learn higher level tailoring patterns.  Tailoring patterns can be found on trainers around the world as well as from quests and monsters."] =
        "Вища навичка кравецтва дає змогу вивчати викрійки вищого рівня. Їх можна отримати від учителів у всьому світі, із завдань або з чудовиськ.",
    ["Misc specialization handling spells go here."] =
        "Тут розміщуються різні закляття спеціалізацій.",
    ["Your companions."] = "Ваші супутники.",
    ["Your mounts."] = "Ваші верхові тварини.",
    ["Equal-Level Enemy"] = "Ворог вашого рівня",
    ["Against Raid Bosses"] = "Проти рейдових босів",
}

addonTable.forever_ui = addonTable.forever_ui or {}
for english, ukrainian in pairs(skills) do
    if addonTable.forever_ui[english] == nil then
        addonTable.forever_ui[english] = ukrainian
    end
    -- SkillLine descriptions in DB2 contain inconsistent runs of spaces;
    -- visible FontStrings may expose either the original or normalized form.
    local normalized = english:gsub("%s+", " ")
    if addonTable.forever_ui[normalized] == nil then
        addonTable.forever_ui[normalized] = ukrainian
    end
end

addonTable.forever_ui_context = addonTable.forever_ui_context or {}
addonTable.forever_ui_context[#addonTable.forever_ui_context + 1] = {
    text = "Mail",
    frame = "CharacterFrame",
    translation = "Кольчуга",
}
addonTable.forever_ui_context[#addonTable.forever_ui_context + 1] = {
    text = "Mail",
    frame = "SkillsFrame",
    translation = "Кольчуга",
}

addonTable.forever_ui_patterns = addonTable.forever_ui_patterns or {}
local patterns = {
    {
        pattern = "^Chance to Hit, and to avoid being Dodged or Parried:%s*(.+)$",
        replace = function (value)
            return "Ймовірність влучити й уникнути ухилення або парирування: " .. value
        end,
    },
    {
        pattern = "^Chance to Critically Hit:%s*(.+)$",
        replace = function (value)
            return "Ймовірність критичного удару: " .. value
        end,
    },
    {
        pattern = "^Glancing Blows occur (.+) of the time and deal (.+) less damage$",
        replace = function (frequency, damage)
            return "Ковзні удари трапляються у " .. frequency
                .. " випадків і завдають на " .. damage .. " менше шкоди"
        end,
    },
    {
        pattern = "^Language:%s*(.+)$",
        replace = function (language)
            local translated = skills[language] or language
            return "Мова: " .. translated
        end,
    },
}

for _, pattern in ipairs(patterns) do
    addonTable.forever_ui_patterns[#addonTable.forever_ui_patterns + 1] = pattern
end

-- Everything loaded before the generated client dictionaries is curated.
addonTable.forever_ui_curated = {}
for english, ukrainian in pairs(addonTable.forever_ui) do
    addonTable.forever_ui_curated[english] = ukrainian
end
