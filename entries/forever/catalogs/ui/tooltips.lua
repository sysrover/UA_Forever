local _, addonTable = ...

-- Player-visible wording used by tooltip adapters. Runtime code owns safe
-- reads, semantic slots and Blizzard lifecycle; this catalog owns Ukrainian
-- labels, grammar and dynamic formatters.
local tooltip = {
    -- AuraUtil's dispel categories in build 1.60.1.70170. Display labels only.
    aura_dispel_names = {
        Magic = "Магія",
        Curse = "Прокляття",
        Disease = "Хвороба",
        Poison = "Отрута",
        Bleed = "Кровотеча",
    },
    dynamic_value_words = {
        sec = "с", secs = "с", second = "с", seconds = "с",
        min = "хв", mins = "хв", minute = "хв", minutes = "хв",
        hr = "год", hrs = "год", hour = "год", hours = "год",
        day = "дн", days = "дн",
    },
    requirement_names = {
        Shield = "щит",
        Shields = "щит",
    },
    power_resources = {
        Rage = "люті",
        Mana = "мани",
        Energy = "енергії",
        Focus = "концентрації",
    },
    item_effect_prefix = {
        learn = "Навчає:",
        use = "Використання:",
        equip = "Екіпірування:",
        hit = "При влучанні:",
    },
    translated_cast_markers = {
        ["Миттєво"] = true,
    },
    comparison_item_labels = {
        ["Critical Strike Chance"] = "ймовірність критичного удару",
        Cloth = "Тканина", Leather = "Шкіра", Mail = "Кольчуга",
        Plate = "Лати", Head = "Голова", Neck = "Шия",
        Shoulder = "Плечі", Shoulders = "Плечі", Back = "Спина",
        Chest = "Груди", Wrist = "Зап'ястя", Hands = "Кисті",
        Waist = "Пояс", Legs = "Ноги", Feet = "Ступні",
        Finger = "Палець", Trinket = "Аксесуар",
        Shirt = "Сорочка", Tabard = "Накидка",
        Sword = "Меч", Dagger = "Кинджал", Staff = "Посох",
        Polearm = "Древкова зброя", Gun = "Рушниця",
        Bow = "Лук", Crossbow = "Арбалет", Wand = "Жезл",
    },
    -- Item tooltip vocabulary emitted by GlobalStrings/TooltipData in client
    -- build 1.60.1.70058. These keys are English client output, never
    -- translated text used for recognition.
    item_line_exact = {
        ["Use: Teaches you how to summon this mount."] =
            "Використання: навчає викликати цю їздову тварину.",
        ["Scarce"] = "Дефіцитний",
        ["|cFF87ABFFScarce|r"] = "|cFF87ABFFДефіцитний|r",
        ["Soulbound"] = "Прив’язано до персонажа",
        ["Binds when picked up"] = "Прив’язується при отриманні",
        ["Binds when equipped"] = "Прив’язується при спорядженні",
        ["Binds when used"] = "Прив’язується при використанні",
        ["Binds to account"] = "Прив’язується до облікового запису",
        ["Quest Item"] = "Предмет завдання",
        ["Unique"] = "Унікальний",
        ["Unique-Equipped"] = "Унікальний споряджений",
        ["<Right Click to Read>"] =
            "<Клацніть правою кнопкою щоб прочитати>",
        ["One-Hand"] = "Одноручна",
        ["Two-Hand"] = "Дворучна",
        ["Main Hand"] = "Основна рука",
        ["Off Hand"] = "Друга рука",
        ["Held In Off-hand"] = "Тримається в другій руці",
        ["Ranged"] = "Дальній бій",
        ["Shield"] = "Щит",
        ["Cloth"] = "Тканина",
        ["Leather"] = "Шкіра",
        ["Mail"] = "Кольчуга",
        ["Plate"] = "Лати",
        ["Axe"] = "Сокира",
        ["Mace"] = "Булава",
        ["Sword"] = "Меч",
        ["Dagger"] = "Кинджал",
        ["Staff"] = "Посох",
        ["Polearm"] = "Древкова зброя",
        ["Bow"] = "Лук",
        ["Crossbow"] = "Арбалет",
        ["Gun"] = "Рушниця",
        ["Wand"] = "Жезл",
        ["Thrown"] = "Метальна зброя",
        ["Already Known"] = "Уже відомо",
        ["Sell Price:"] = "Ціна продажу:",
        ["Press F6 to submit an issue for this Item"] =
            "F6: повідомити про помилку",
        ["If you replace this item, the following stat changes will occur:"] =
            "Заміна цього предмета призведе до зміни таких характеристик:",
    },
    -- Class/subclass IDs from ItemClass.db2 and ItemSubClass.db2 in build
    -- 1.60.1.70058. Runtime verifies the visible English label against the
    -- corresponding build row before using these translations.
    item_class_names = {
        [6] = "Снаряд",
    },
    item_subclass_names = {
        [6] = {
            [2] = "Стріла",
            [3] = "Куля",
        },
    },
    resistance_schools = {
        arcane = "таємної магії", fire = "вогню", frost = "криги",
        nature = "природи", shadow = "тіні", holy = "світла",
    },
}

tooltip.format = {
    item_set_name = function (name, equipped, total)
        return name .. " (" .. equipped .. "/" .. total .. ")"
    end,
    item_set_bonus = function (count, description)
        return "(" .. count .. ") Комплект: " .. description
    end,
    dynamic_value_range = function (value)
        return (value:gsub("([%d%.,]+)%s+to%s+([%d%.,]+)", "%1–%2"))
    end,
    aura_time_remaining = function (amount, unit)
        local translated_unit = tooltip.dynamic_value_words[unit:lower()]
        if not translated_unit then return nil end
        return "Залишилося " .. amount .. " " .. translated_unit
    end,
    item_use = function (description, cooldown, unit)
        local result = "Використання: " .. description
        if cooldown then
            result = result .. " (Перезарядка: " .. cooldown
                .. (unit == "min" and " хв.)" or " с)")
        end
        return result
    end,
    item_cooldown = function (amount, unit)
        local translated_unit = tooltip.dynamic_value_words[unit:lower()]
        if not translated_unit then return nil end
        return " (Перезарядка: " .. amount .. " " .. translated_unit .. ")"
    end,
    item_skill_requirement = function (skill, rank)
        return "Необхідно: " .. skill .. " (" .. rank .. ")"
    end,
    player_identity = function (level, race)
        return "Рівень " .. level .. ": " .. race .. " (Гравець)"
    end,
    talent_points = function (count, form, tree)
        return "Вкладіть ще " .. count .. " " .. form
            .. " у гілку талантів «" .. tree .. "»."
    end,
    resistance = function (school, level, average)
        return "Підвищує опір атакам, заклинанням і здібностям школи "
            .. school .. ".\n\nСередній опір проти ворога " .. level
            .. "-го рівня: |cffffffff" .. average .. "%|r"
    end,
}

-- Names verified against GlobalStrings and ChrTitles in 1.60.1.70170;
-- wording is retained from factions-taxi-titles/titles_uk.json.
tooltip.pvp_rank_names = {
    Private = "Рядовий", Corporal = "Капрал", Sergeant = "Сержант",
    ["Master Sergeant"] = "Майстер-сержант", ["Sergeant Major"] = "Сержант-майор",
    Knight = "Лицар", ["Knight-Lieutenant"] = "Лицар-лейтенант",
    ["Knight-Captain"] = "Лицар-капітан", ["Knight-Champion"] = "Лицар-чемпіон",
    ["Lieutenant Commander"] = "Лейтенант-командир", Commander = "Командир",
    Marshal = "Маршал", ["Field Marshal"] = "Фельдмаршал",
    ["Grand Marshal"] = "Великий маршал", Scout = "Розвідник", Grunt = "Рубака",
    ["Senior Sergeant"] = "Старший сержант", ["First Sergeant"] = "Перший сержант",
    ["Stone Guard"] = "Кам'яний вартовий", ["Blood Guard"] = "Кривавий вартовий",
    Legionnaire = "Легіонер", Centurion = "Центуріон", Champion = "Чемпіон",
    ["Lieutenant General"] = "Генерал-лейтенант", General = "Генерал",
    Warlord = "Воєвода", ["High Warlord"] = "Верховний воєвода",
}

tooltip.item_set_names = {
    ["Lieutenant Commander's Battlegear"] = "Бойове спорядження лейтенант-командира",
    ["Rotmender's Raiment"] = "Шати гнилоцілителя",
}

-- Observed inspect-tooltip names that differ from ItemSparse in 70170.
-- Keep aliases scoped to their set; translate through the approved item ID.
tooltip.item_set_member_aliases = {
    [2133] = { ["Rotmender's Garb"] = 286978 },
}

tooltip.item_transmog_header = "Transmogrified to:"

local item_stat_names = {
    Strength = "сили", Stamina = "витривалості",
    Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
    ["Spell Power"] = "сили заклинань",
    ["Attack Power"] = "сили атаки",
    ["ranged Attack Power"] = "сили дальньої атаки",
    ["Ranged Attack Power"] = "сили дальньої атаки",
    Armor = "броні", ["Weapon Damage"] = "шкоди зброї",
    ["All Resistances"] = "всіх видів опору",
}

local item_resistance_names = {
    Arcane = "таємної магії", Fire = "вогню", Frost = "криги",
    Nature = "природи", Shadow = "тіні", Holy = "світла",
}

-- Numeric equip effects from Spell.db2:Description_lang in 1.60.1.70170.
-- Match the complete stat label, including school and creature restrictions.
local item_attack_power_targets = {
    Demons = "демонів", Undead = "нежиті", Beasts = "звірів",
    Giants = "велетнів", Dragonkin = "драконідів",
    Elementals = "елементалів", ["Mechanical units"] = "механізмів",
    Humanoids = "гуманоїдів",
}

local function item_stat_name(stat)
    local name = item_stat_names[stat]
    if name then return name end
    local school = stat:match("^([A-Za-z]+) Resistance$")
    name = school and item_resistance_names[school]
    if name then return "опору " .. name end
    local target = stat:match("^Attack Power against (.+)$")
    name = target and item_attack_power_targets[target]
    return name and ("сили атаки проти " .. name) or nil
end

-- Rendered SpellItemEnchantment names in 1.60.1.70124. The client can
-- emit these without an enchantment ID, including on inspected equipment.
-- Recognition is whole-name only; this is not a substring/glossary search.
local item_modification_names = {
    ["Poultry Precision Scope"] = "Приціл пташиної точності",
    ["Abyssal Essence"] = "Сутність безодні",
    ["Aftershock"] = "Післяшок",
    ["Agonizing Torcher"] = "Мучитель вогнем",
    ["Alpha Tamer"] = "Приборкувач ватажків",
    ["Alternator"] = "Перемикач",
    ["Altruist"] = "Альтруїст",
    ["Amplification"] = "Підсилення",
    ["Ancestral Invigoration"] = "Бадьорість предків",
    ["Ancestral Warden"] = "Вартовий предків",
    ["Animalistic Expertise"] = "Звіряча майстерність",
    ["Annhilator"] = "Винищувач",
    ["Arbiter"] = "Арбітр",
    ["Arcane Specialization"] = "Спеціалізація на таємній магії",
    ["Arcanist"] = "чародій потаємних знань",
    ["Archbishop"] = "Архієпископ",
    ["Ardent Defender"] = "Палкий захисник",
    ["Arsonist"] = "Палій",
    ["Ascendant"] = "Вознесений",
    ["Astral Ascendant"] = "Астральний вознесений",
    ["Astral Shift"] = "Астральний зсув",
    ["Atonement"] = "Спокута",
    ["Augmented Seals"] = "Посилені печатки",
    ["Avoidant"] = "Спритний ухильник",
    ["Barbaric"] = "Варварський",
    ["Battle Forecaster"] = "Провісник бою",
    ["Beast Tender"] = "Доглядач звірів",
    ["Beastly"] = "Звірячий",
    ["Benevolent Seer"] = "Милосердний провидець",
    ["Black Belt"] = "Чорний пояс",
    ["Black Powder"] = "Чорний порох",
    ["Black and White"] = "Чорне та біле",
    ["Bloodseeker"] = "Шукач крові",
    ["Body and Soul"] = "Тіло та душа",
    ["Bounty Hunter"] = "Мисливець за головами",
    ["Breakthrough"] = "Прорив",
    ["Butcher"] = "Різник",
    ["Cannonball Barrage"] = "Гарматний обстріл",
    ["Celebrant"] = "Служитель обрядів",
    ["Chaos Harbinger"] = "Провісник хаосу",
    ["Chieftain"] = "вождь",
    ["Chillknife"] = "Крижаний ніж",
    ["Chronohealer"] = "Хронозцілювач",
    ["Clarity of Pain"] = "Ясність болю",
    ["Cometcaller"] = "Закликач комет",
    ["Contemnor"] = "Зневажник",
    ["Crimson Vial"] = "Багряна ампула",
    ["Cryomancer"] = "Кріомант",
    ["Damaged Rune"] = "Пошкоджена руна",
    ["Deadly Striker"] = "Смертоносний ударник",
    ["Death Strike"] = "Удар смерті",
    ["Deathbound"] = "Скутий смертю",
    ["Deathdealer"] = "Сівач смерті",
    ["Decimator"] = "Спустошувач",
    ["Deflective Tendencies"] = "Схильність до відбиття",
    ["Demonic Circle"] = "Демонічне коло",
    ["Demonic Exorcist"] = "Вигнач демонів",
    ["Demonlord"] = "Повелитель демонів",
    ["Demonslaying"] = "Винищення демонів",
    ["Destroyer"] = "Руйнівник",
    ["Devotee"] = "Відданий",
    ["Divine Illumination"] = "Божественне осяяння",
    ["Divine Plea"] = "Божественне благання",
    ["Dominus"] = "Володар",
    ["Drill Master"] = "Майстер муштри",
    ["Echoing Strikes"] = "Лункі удари",
    ["Efficient Striking"] = "Ефективні удари",
    ["Elder"] = "Старійшина",
    ["Elemental Master"] = "Володар стихій",
    ["Elemental Seer"] = "Провидець стихій",
    ["Elementalist"] = "Маг стихій",
    ["Empowered Flames"] = "Посилене полум’я",
    ["Empowered Frostbolt"] = "Посилена крижана стріла",
    ["Equilibrist"] = "Еквілібрист",
    ["Eternal Caretaker"] = "Вічний доглядач",
    ["Eternium Line"] = "Етернієва волосінь",
    ["Excommunicator"] = "Відлучувач",
    ["Executioner"] = "Кат",
    ["Exemplar"] = "Взірець",
    ["Exile"] = "Вигнанець",
    ["Exsanguinator"] = "Знекровлювач",
    ["Faded Rune"] = "Згасла руна",
    ["Faithful"] = "Вірний",
    ["Feathered Sage"] = "Пернатий мудрець",
    ["Fencer"] = "Фехтувальник",
    ["Ferocious Focus"] = "Люта зосередженість",
    ["Fiery Convergence"] = "Вогняне злиття",
    ["Flagellant's Whip"] = "Батіг бичувальника",
    ["Flamebringer"] = "Носій полум’я",
    ["Flamewraith"] = "Привид полум’я",
    ["Fleet Footed"] = "Прудконогий",
    ["Fleshfeaster"] = "Пожирач плоті",
    ["Font of Life"] = "Джерело життя",
    ["Forbidden Knowledge"] = "Заборонене знання",
    ["Frenetic"] = "Шалений",
    ["Frozen Power"] = "Крижана сила",
    ["Furious"] = "Лютий",
    ["Furycharged"] = "Сповнений люті",
    ["Gentle Paw"] = "Лагідна лапа",
    ["Ghost World"] = "Примарний світ",
    ["Gladiator"] = "Гладіатор",
    ["Graceful"] = "Граційний",
    ["Grant Life"] = "Дарування життя",
    ["Grove Defender"] = "Захисник гаю",
    ["Grove Tender"] = "Доглядач гаю",
    ["Harpoon"] = "Гарпун",
    ["Harvest of Souls"] = "Жнива душ",
    ["Hastened Healer"] = "Стрімкий цілитель",
    ["Hazard Harrier"] = "Переслідувач небезпек",
    ["Heir of the Elements"] = "Спадкоємець стихій",
    ["Heroic Leap"] = "Героїчний стрибок",
    ["Heroic Throw"] = "Героїчний кидок",
    ["Horn of Winter"] = "Ріг зими",
    ["Hound Master"] = "Повелитель гончаків",
    ["Huntsman"] = "Ловець",
    ["Icy Weapon"] = "Крижана зброя",
    ["Igniter"] = "Запалювач",
    ["Illuminator"] = "Осяювач",
    ["Incessant Attacker"] = "Невпинний нападник",
    ["Increased Stealth"] = "Посилена непомітність",
    ["Infernal Shepherd"] = "Пекельний пастир",
    ["Innervator"] = "Натхненник",
    ["Inquisitor"] = "Інквізитор",
    ["Ironclad"] = "Залізний панцир",
    ["Judicator"] = "Суддя",
    ["Justicar"] = "Юстиціар",
    ["Keeper of the Grove"] = "Хранитель гаю",
    ["Kindler"] = "Розпалювач",
    ["Kineticist"] = "Кінетик",
    ["Knife Juggler"] = "Жонглер ножами",
    ["Lacerator"] = "Роздирач",
    ["Lava Sage"] = "Мудрець лави",
    ["Lavawalker"] = "Лавоходець",
    ["Leeching Poisons"] = "Висмоктувальні отрути",
    ["Lethal Lasher"] = "Смертоносний бичувальник",
    ["Lifestealing"] = "Викрадення життя",
    ["Lifeweaver"] = "Ткач життя",
    ["Lightbringer"] = "Світлоносець",
    ["Lightwarden"] = "Вартовий світла",
    ["Long Reach"] = "Довга досяжність",
    ["Longbowman"] = "Стрілець із довгим луком",
    ["Lunatic"] = "Лунатик",
    ["Maelstrombringer"] = "Носій виру",
    ["Magical Armaments"] = "Магічне озброєння",
    ["Malevolent"] = "Зловмисний",
    ["Mangler"] = "Калічник",
    ["Master of the Elements"] = "Володар стихій",
    ["Mastermind"] = "Натхненник задумів",
    ["Melt"] = "Розплавлення",
    ["Mercy of the Claw"] = "Милість пазура",
    ["Mind Breaker"] = "Руйнівник розуму",
    ["Minor Mount Speed Increase"] = "Незначне збільшення швидкості їзди",
    ["Minor Speed Increase"] = "Незначне збільшення швидкості",
    ["Misdirection"] = "Перенаправлення",
    ["Misleader"] = "Обманщик",
    ["Night"] = "Ніч",
    ["Nullification"] = "Зведення нанівець",
    ["Nurturer"] = "Опікун",
    ["Nurturing Instinct"] = "Інстинкт турботи",
    ["Opportunist"] = "Ловець нагоди",
    ["Pain Siphon"] = "Висмоктування болю",
    ["Pain Spreader"] = "Поширювач болю",
    ["Paw and Claw"] = "Лапа та пазур",
    ["Peacekeeper"] = "Миротворець",
    ["Penitent"] = "Покутник",
    ["Perpetual Blaze"] = "Невгасний вогонь",
    ["Phantom"] = "Фантом",
    ["Pillar of Enmity"] = "Стовп ворожнечі",
    ["Plaguebringer"] = "Носій чуми",
    ["Poised Brawler"] = "Зібраний забіяка",
    ["Power Bargain"] = "Угода про силу",
    ["Power Corrupt"] = "Зіпсована сила",
    ["Precognition"] = "Передбачення",
    ["Predatory Swiftness"] = "Хижа стрімкість",
    ["Preyseeker"] = "Шукач здобичі",
    ["Prideful"] = "Гордовитий",
    ["Pristine Blocker"] = "Бездоганний блокувальник",
    ["Pyromaniac"] = "Піроман",
    ["Radiant Defender"] = "Сяйний захисник",
    ["Raging Flame"] = "Люте полум’я",
    ["Rapture"] = "Захват",
    ["Reckoner"] = "Вершитель відплати",
    ["Recuperate"] = "Відновлення сил",
    ["Refined Spells"] = "Витончені закляття",
    ["Resilient Earth"] = "Непохитна земля",
    ["Resonant"] = "Резонансний",
    ["Retaliator"] = "Месник",
    ["Retributor"] = "Каратель",
    ["Return to the Shadows"] = "Повернення в тіні",
    ["Reverberant"] = "Відлунний",
    ["Rip and Tear"] = "Рви та шматуй",
    ["Ritualist"] = "Ритуаліст",
    ["Rotbringer"] = "Носій гнилі",
    ["Run and Gun"] = "Біг і стрільба",
    ["Sanguinist"] = "Кривавий адепт",
    ["Savage"] = "Лютий дикун",
    ["Scoundrel"] = "Негідник",
    ["Sealbearer"] = "Носій печаток",
    ["Seed of Corruption"] = "Зерно скверни",
    ["Seismic Smasher"] = "Сейсмічний громила",
    ["Sentinel"] = "Вартовий",
    ["Serendipitous"] = "Осяяний удачею",
    ["Shadow Master"] = "Повелитель тіней",
    ["Shadow and Light"] = "Тінь і світло",
    ["Shadowmancer"] = "Тінемант",
    ["Sharpshooter"] = "Влучний стрілець",
    ["Sheath of Light"] = "Піхви Світла",
    ["Shield Master"] = "Майстер щита",
    ["Shieldbearer"] = "Щитоносець",
    ["Shiv Savant"] = "Майстер підступного удару",
    ["Shock-Absorber"] = "Поглинач ударів",
    ["Soul Leech"] = "Висмоктування душі",
    ["Soul Sacrifice"] = "Жертвування душею",
    ["Soul Warder"] = "Вартовий душ",
    ["Southpaw"] = "Лівша",
    ["Sovereign"] = "Суверен",
    ["Spellbider"] = "Очікувач заклять",
    ["Spellfrost Orb"] = "Сфера чарокриги",
    ["Spirit Font"] = "Джерело духу",
    ["Spirit Guide"] = "Провідник духів",
    ["Spirithealer"] = "Цілитель духу",
    ["Spiritual Bulwark"] = "Духовний бастіон",
    ["Spiritweaver"] = "Ткач духів",
    ["Starcaller"] = "Закликач зірок",
    ["Stormbreaker"] = "Руйнівник бурі",
    ["Stormtender"] = "Приборкувач бурі",
    ["Strategist"] = "Стратег",
    ["Swashbuckler"] = "Відчайдушний дуелянт",
    ["Swift Kick"] = "Стрімкий стусан",
    ["Swift Revenge"] = "Стрімка помста",
    ["Swipe (Cat)"] = "Розмах (кіт)",
    ["Temporal Echoes"] = "Часові відлуння",
    ["Temporal Longing"] = "Часова туга",
    ["Territorial"] = "Територіальний",
    ["Thornkeeper"] = "Хранитель шипів",
    ["Thrill Seeker"] = "Шукач гострих відчуттів",
    ["Thunderbringer"] = "Носій грому",
    ["Thunderstorm"] = "Гроза",
    ["Titan"] = "титан",
    ["Titan's Grip"] = "Хватка титана",
    ["Totemic Protector"] = "Тотемний захисник",
    ["Totemkeeper"] = "Хранитель тотемів",
    ["Toxicologist"] = "Токсиколог",
    ["Toxinologist"] = "Знавець токсинів",
    ["Tranquil"] = "Спокійний",
    ["Transfusionist"] = "Майстер переливання",
    ["Tribesman"] = "Одноплемінник",
    ["Trick Shooter"] = "Майстер хитрих пострілів",
    ["Tricks of the Trade"] = "Хитрощі ремесла",
    ["True Alpha"] = "Справжній ватажок",
    ["Twilight Walker"] = "Сутінковий мандрівник",
    ["Two-Handed Specialist"] = "Фахівець дворучної зброї",
    ["Umbral Blade"] = "Тіньовий клинок",
    ["Unholy Weapon"] = "Нечестива зброя",
    ["Unwavering Defiler"] = "Непохитний осквернитель",
    ["Vitalist"] = "Життєдавець",
    ["Voidborne"] = "Народжений порожнечею",
    ["Volcano"] = "Вулкан",
    ["War Veteran"] = "Ветеран війни",
    ["Wardshaper"] = "Творець захисних чарів",
    ["Waterwalker"] = "Водоходець",
    ["Weapon Chain - Immune Disarm"] = "Ланцюг для зброї — захист від роззброєння",
    ["Windwalker"] = "Вітроходець",
    ["Winter's Grasp"] = "Хватка зими",
    ["Wrath of the Forest"] = "Гнів лісу",
    ["Wrathful"] = "Гнівний",
    ["Zealot"] = "Ревнитель",
    Sharpened = "Загострення", Weighted = "Обтяження",
    Beastslaying = "Винищення звірів",
    ["Fishing Lure"] = "Рибальська приманка",
    Rockbiter = "Каменолом", Frostbrand = "Крижане тавро",
    Flametongue = "Язик полум'я", Windfury = "Буревій",
    ["Flametongue Totem"] = "Тотем язика полум'я",
    ["Windfury Totem"] = "Тотем буревію",
    Windwrath = "Гнів вітру", Feedback = "Відгомін",
    Firestone = "Камінь вогню", Spellstone = "Камінь чарів",
    ["Earthliving Weapon"] = "Зброя життя землі",
    ["Deadly Poison"] = "Смертельна отрута",
    ["Instant Poison"] = "Миттєва отрута",
    ["Crippling Poison"] = "Травматична отрута",
    ["Wound Poison"] = "Агонічна отрута",
    ["Mind Numbing Poison"] = "Задурлива отрута",
    ["Mind-numbing Poison"] = "Задурлива отрута",
    ["Mind-Numbing Poison"] = "Задурлива отрута",
    ["Numbing Poison"] = "Онімлива отрута",
    ["Atrophic Poison"] = "Атрофічна отрута",
    ["Occult Poison"] = "Окультна отрута",
    ["Sebacious Poison"] = "Сальна отрута",
    ["Venomhide Poison"] = "Отрута отрутошкіра",
    ["Shadow Oil"] = "Тіньова олія", ["Frost Oil"] = "Крижана олія",
    ["Wizard Oil"] = "Чарівна олія",
    ["Minor Wizard Oil"] = "Слабка чарівна олія",
    ["Lesser Wizard Oil"] = "Проста чарівна олія",
    ["Brilliant Wizard Oil"] = "Блискуча чарівна олія",
    ["Minor Mana Oil"] = "Слабка олія мани",
    ["Lesser Mana Oil"] = "Проста олія мани",
    ["Brilliant Mana Oil"] = "Блискуча олія мани",
    ["Blackfathom Mana Oil"] = "Олія мани Чорноводдя",
    ["Conductive Shield Coating"] = "Провідне покриття щита",
    ["Enchanted Repellent"] = "Зачарований відлякувач",
    ["Magnificent Trollshine"] = "Чудовий тролячий блиск",
    ["Omen of Clarity"] = "Знамення ясності",
    ["Wild Strikes"] = "Дикі удари",
    Accuracy = "Влучність", Precision = "Точність",
    Quickening = "Прискорення", Striking = "Удар",
    Sundered = "Розколювання", Cleaned = "Очищення",
    Flame = "Полум'я", ["Lesser Flame"] = "Слабке полум'я",
    ["Greater Flame"] = "Велике полум'я",
    Frost = "Крига", ["Greater Frost"] = "Велика крига",
    Spark = "Іскра", Baleflame = "Зловісне полум'я",
    Balefrost = "Зловісна крига", Iceknife = "Крижаний ніж",
    Manablade = "Лезо мани",
}

local item_modification_stats = {
    Armor = "броні", Damage = "шкоди", HP = "здоров'я",
    ["Attack Power"] = "сили атаки", ["Spell Damage"] = "шкоди заклинань",
    ["Healing Power"] = "сили зцілення", ["All Resistances"] = "всіх опорів",
    ["Defense Skill"] = "навички захисту", Defense = "захисту",
    Critical = "критичного удару", ["Critical Strike"] = "критичного удару",
    Hit = "влучності", Dodge = "ухилення", Block = "блокування",
    Haste = "швидкості",
    Mana = "мани", Health = "здоров’я", ["All Stats"] = "всіх характеристик",
    ["to all attributes"] = "всіх характеристик",
    ["Healing Spells"] = "зцілення закляттями", Healing = "зцілення",
    ["Damage Spells"] = "шкоди закляттями",
    ["Healing and Spell Damage"] = "зцілення та шкоди закляттями",
    ["Spell Damage and Healing"] = "шкоди та зцілення закляттями",
    ["Damage and Healing Spells"] = "шкоди та зцілення закляттями",
    ["Critical Hit"] = "ймовірності критичного удару", Crit = "ймовірності критичного удару",
    ["Critical Strike Chance"] = "ймовірності критичного удару",
    ["Spell Critical Strike"] = "ймовірності критичного удару закляттями",
    ["Spell Hit"] = "влучності закляттями", ["Attack Speed"] = "швидкості атаки",
    ["Block Chance"] = "ймовірності блокування", Blocking = "ймовірності блокування",
    ["Block Value"] = "обсягу блокування", Stealth = "непомітності",
    Threat = "загрози", Thorns = "шкоди від шипів",
    Mining = "гірництва", Herbalism = "травництва", Skinning = "шкуродерства",
    Fishing = "рибальства", ["Mana Regen"] = "відновлення мани",
    ["Sword Skill"] = "навички мечів", ["Two-Handed Sword Skill"] = "навички дворучних мечів",
    ["Axe Skill"] = "навички сокир", ["Ase Skill"] = "навички сокир",
    ["Two-Handed Axe Skill"] = "навички дворучних сокир",
    ["Mace Skill"] = "навички булав", ["Two-Handed Mace Skill"] = "навички дворучних булав",
    ["Dagger Skill"] = "навички кинджалів", ["Gun Skill"] = "навички рушниць",
    ["Bow Skill"] = "навички луків", ["Beast Slaying"] = "сили атаки проти звірів",
    ["Elemental Slayer"] = "сили атаки проти елементалів",
}

local function modification_stat_name(stat)
    local name = item_stat_name(stat) or item_modification_stats[stat]
    if name then return name end
    local school = stat:match("^([A-Za-z]+) Resistance$")
    if school and item_resistance_names[school] then
        return "опору " .. item_resistance_names[school]
    end
    school = stat:match("^([A-Za-z]+) Spell Damage$")
    if school and item_resistance_names[school] then
        return "шкоди заклинань " .. item_resistance_names[school]
    end
    school = stat:match("^Weapon ([A-Za-z]+) Damage$")
    if school and item_resistance_names[school] then return "шкоди зброї від " .. item_resistance_names[school] end
    school = stat:match("^([A-Za-z]+) Damage$")
    if school and item_resistance_names[school] then return "шкоди від " .. item_resistance_names[school] end
    school = stat:match("^Resist ([A-Za-z]+)$")
    if school and item_resistance_names[school] then return "опору " .. item_resistance_names[school] end
    local kind, target = stat:match("^(.-) vs (.+)$")
    if target and item_attack_power_targets[target] then
        name = item_stat_names[kind] or item_modification_stats[kind]
        return name and (name .. " проти " .. item_attack_power_targets[target]) or nil
    end
end

local function modification_name(source)
    return item_modification_names[source]
        or addonTable.use("entries").lookup_name("spell", source)
        or addonTable.use("spell_client_db").get_name_by_english(source)
end

local function translate_modification_part(source)
    local translated = modification_name(source)
    if translated then return translated end
    local name, sign, amount, percent = source:match(
        "^([A-Za-z '%-]+) ([%+%-])([%d%.,%$A-Za-z]+)(%%?)$")
    if not name then
        sign, amount, percent, name = source:match(
            "^([%+%-])([%d%.,%$A-Za-z]+)(%%?) ([A-Za-z '%-]+)$")
    end
    if name and (amount:match("^[%d%.,]+$") or amount:match("^%$%d*[A-Za-z]%d*$")) then
        translated = modification_name(name)
        if translated then
            return translated .. " " .. sign .. amount .. percent
        end
        translated = modification_stat_name(name)
        if translated then return sign .. amount .. percent .. " до " .. translated end
    end
    local rank
    name, rank = source:match("^([A-Za-z '%-]+) (%d+)$")
    if not name then name, rank = source:match("^([A-Za-z '%-]+) ([IVX]+)$") end
    translated = name and modification_name(name)
    if translated then return translated .. " " .. rank end
    amount = source:match("^Scope %(%+(%d+) Damage%)$")
    if amount then return "Приціл (+" .. amount .. " до шкоди)" end
    amount = source:match("^Absorption %((%d+)%)$")
    if amount then return "Поглинання (" .. amount .. ")" end
    amount = source:match("^Poison %((%d+) Dmg%)$")
    if amount then return "Отрута (" .. amount .. " шкоди)" end
    amount = source:match("^Poison %(Instant (%d+)%)$")
    if amount then return "Отрута (миттєво " .. amount .. ")" end
    local resource, interval
    amount, resource, interval = source:match("^%+([%d%$A-Za-z]+) (health) every (%d+) sec%.$")
    if not amount then amount, resource, interval = source:match("^%+([%d%$A-Za-z]+) (mana) every (%d+) sec%.$") end
    if amount then return "+" .. amount .. " " .. (resource == "mana" and "мани" or "здоров’я") .. " кожні " .. interval .. " с." end
    amount, interval = source:match("^Mana Regen (%d+) per (%d+) sec%.$")
    if not amount then amount, interval = source:match("^%+?([%d%$A-Za-z]+) mana per (%d+) sec%.$") end
    if amount then return "Відновлення " .. amount .. " мани кожні " .. interval .. " с." end
    local effect, value = source:match("^Increases? (.-) %+([%d%.,]+)$")
    if effect then
        local stat = effect == "Healing" and "Healing Spells" or effect:gsub(" Effects$", " Spell Damage")
        translated = modification_stat_name(stat)
        return translated and ("+" .. value .. " до " .. translated) or nil
    end
    amount = source:match("^Block Level (%d+)$")
    if amount then return "Рівень блокування " .. amount end
    amount = source:match("^Counterweight %+(%d+)%% Attack Speed$")
    if amount then return "Противага: +" .. amount .. "% до швидкості атаки" end
    local metal, low, high = source:match("^([A-Za-z]+) Spike %((%d+)%-(%d+)%)$")
    local metals = { Iron = "Залізний", Mithril = "Мітриловий", Thorium = "Торієвий" }
    if metal and metals[metal] then return metals[metal] .. " шип (" .. low .. "–" .. high .. ")" end
    local chance, damage = source:match("^(%d+)%% On Get Hit: Shadow Bolt %((%d+) Damage%)$")
    if chance then return chance .. "% при отриманні удару: Стріла тіні (" .. damage .. " шкоди)" end
    local scope, bonus, stat = source:match("^(.- Scope) %(%+(%d+%%?) ([A-Za-z]+)%)$")
    if scope then
        local scope_name = addonTable.use("item_client_db").get_name_by_english(scope)
            or modification_name(scope)
        local stat_name = modification_stat_name(stat)
        if scope_name and stat_name then return scope_name .. " (+" .. bonus .. " до " .. stat_name .. ")" end
    end
    local codes, amounts = source:match("^([A-Z/]+) %+([%d/]+)$")
    if codes then
        local labels = { AC = "броні", FR = "опору вогню", HP = "здоров’я", MANA = "мани",
            STR = "сили", STA = "витривалості", AGI = "спритності", INT = "інтелекту", SPI = "духу" }
        local values, result = {}, {}
        for value in amounts:gmatch("%d+") do values[#values + 1] = value end
        for code in codes:gmatch("[^/]+") do
            if not labels[code] or not values[#result + 1] then return nil end
            result[#result + 1] = "+" .. values[#result + 1] .. " до " .. labels[code]
        end
        if #result == #values then return table.concat(result, " / ") end
    end
    amount = source:match("^MHTest(%d+)$")
    if amount then return "Тест основної руки " .. amount end
    amount = source:match("^REUSE Random %- (%d+) Spells All$")
    if amount then return "Повторне використання: " .. amount .. " випадкових заклять" end
end

local function translate_modification_duration(source)
    local remaining = source
    local result = {}
    -- Native duration only, including compound day/hour/minute/second text.
    -- Preserve displayed values; never calculate time from an effect's DB row.
    for _ = 1, 4 do
        local amount, unit, tail = remaining:match(
            "^([%d%.,]+)%s+([A-Za-z]+)(.*)$")
        local translated_unit = unit
            and tooltip.dynamic_value_words[unit:lower()]
        if not translated_unit then return nil end
        result[#result + 1] = amount .. " " .. translated_unit
        if tail == "" then return table.concat(result, " ") end
        remaining = tail:match("^,?%s+(.+)$")
        if not remaining then return nil end
    end
    return nil
end

function tooltip.translate_item_modification(source)
    if type(source) ~= "string" or source == "" then return nil end
    local color, body = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)|r$")
    body = body or source
    local enchanted = body:match("^Enchanted: (.+)$") or body:match("^Enchant: (.+)$")
    body = enchanted or body
    local duration
    if body:sub(-1) == ")" then
        local name, native_duration = body:match("^(.+) %(([^()]*)%)$")
        duration = native_duration
            and translate_modification_duration(native_duration)
        if duration then body = name end
    end
    local translated = translate_modification_part(body)
    if not translated then
        if not body:find(" and ", 1, true)
            and not body:find(" / ", 1, true)
            and not body:find("/", 1, true)
            and not body:find(", ", 1, true)
            and not body:find(" & ", 1, true) then return nil end
        -- Bounded, all-or-nothing compound bonuses. Never drop an unknown
        -- component, reinterpret client tokens or manufacture numeric values.
        local parts = body:gsub("%s*/%s*", "\031"):gsub(" & ", "\031")
            :gsub(", ", "\031"):gsub("([%d%%]) and ", "%1\031")
            :gsub("(%$%w+%%?) and ", "%1\031")
        local result = {}
        local start = 1
        while #result < 4 do
            local boundary = parts:find("\031", start, true)
            local part = parts:sub(start, boundary and boundary - 1 or #parts)
            local value = translate_modification_part(part)
            if not value then return nil end
            result[#result + 1] = value
            if not boundary then
                translated = table.concat(result, " та ")
                break
            end
            start = boundary + 1
        end
        if not translated then return nil end
    end
    if enchanted then translated = "Зачарування: " .. translated end
    if duration then translated = translated .. " (" .. duration .. ")" end
    if color then translated = color .. translated .. "|r" end
    return translated
end

-- BAG_FILTER_* values used by ContainerFrameSettingsManager in build
-- 1.60.1.70058. Genitive forms fit BAG_FILTER_ASSIGNED_TO directly.
local bag_filter_names = {
    Equipment = "спорядження",
    Consumables = "витратних предметів",
    ["Profession Goods"] = "ремісничих товарів",
    Junk = "мотлоху",
    ["Quest Items"] = "предметів завдань",
    Reagents = "реагентів",
}

local function translate_bag_filter_list(source)
    local translated = {}
    for part in source:gmatch("[^,]+") do
        local name = part:match("^%s*(.-)%s*$")
        local value = bag_filter_names[name]
        if not value then return nil end
        translated[#translated + 1] = value
    end
    if #translated == 0 then return nil end
    return table.concat(translated, ", ")
end

-- CONTAINER_SLOTS (%d Slot %s) and current ItemSubClass labels in
-- build 1.60.1.70205, classes 1 (containers) and 11 (quivers).
local container_names = {
    Bag = "Сумка",
    Quiver = "Сагайдак",
    ["Ammo Pouch"] = "Сумка для набоїв",
    ["Soul Bag"] = "Сумка душ",
    ["Herb Bag"] = "Сумка для трав",
    ["Enchanting Bag"] = "Сумка для зачарування",
    ["Engineering Bag"] = "Інженерна сумка",
    ["Mining Bag"] = "Сумка для гірництва",
    ["Leatherworking Bag"] = "Сумка для шкірництва",
    ["Tackle Box"] = "Скринька для рибальського приладдя",
    ["Cooking Bag"] = "Кулінарна сумка",
    ["Reagent Bag"] = "Сумка для реагентів",
    ["Trinket Bag"] = "Сумка для аксесуарів",
}

tooltip.item_line_patterns = {
    { "^DURA (%d+)$", function (amount) return "МІЦН " .. amount end },
    { "^(%d+) Ranks:$", function (amount)
        local n = tonumber(amount)
        local form = n % 10 == 1 and n % 100 ~= 11 and "ранг"
            or n % 10 >= 2 and n % 10 <= 4 and (n % 100 < 12 or n % 100 > 14)
                and "ранги" or "рангів"
        return amount .. " " .. form .. ":"
    end },
    { "^(%d+) [Cc]harges?$", function (amount)
        local n = tonumber(amount)
        local form = n % 10 == 1 and n % 100 ~= 11 and "заряд"
            or n % 10 >= 2 and n % 10 <= 4 and (n % 100 < 12 or n % 100 > 14)
                and "заряди" or "зарядів"
        return amount .. " " .. form
    end },
    { "^Duration: (.+)$", function (duration)
        local value = translate_modification_duration(duration)
        return value and ("Тривалість: " .. value) or nil
    end },
    { "^Socket Bonus: (.+)$", function (bonus)
        local value = tooltip.translate_item_modification(bonus)
        return value and ("Бонус гнізд: " .. value) or nil
    end },
    { "^Equip: ([%+%-])([%d%.,]+) ([A-Za-z ]+)%.$",
        function (sign, amount, stat)
            local name = item_stat_name(stat)
            return name and (tooltip.item_effect_prefix.equip .. " "
                .. sign .. amount .. " до " .. name .. ".") or nil
        end },
    -- GlobalStrings:BIND_TRADE_TIME_REMAINING in 1.60.1.70170;
    -- %s contains one or more rendered INT_*_DURATION components.
    { "^You may trade this item with players that were also eligible to loot this item for the next (.+) %(including time offline%)%.$",
        function (remaining)
            local known = true
            remaining = remaining:gsub("([A-Za-z]+)", function (word)
                local translated = tooltip.dynamic_value_words[word:lower()]
                if not translated then known = false end
                return translated or word
            end)
            if not known then return nil end
            return "Протягом наступних " .. remaining
                .. " цей предмет можна передати гравцям, які також мали право на нього"
                .. " (час поза грою також враховується)."
        end },
    { "^Requires (.-)%s*%(%s*Rank%s+(%d+)%s*%)$", function (names, rank)
        local translated = {}
        for name in names:gmatch("[^/]+") do
            name = name:match("^%s*(.-)%s*$")
            local value = tooltip.pvp_rank_names[name]
            if not value then return nil end
            translated[#translated + 1] = value
        end
        if #translated == 0 then return nil end
        return "Необхідно: " .. table.concat(translated, " / ")
            .. " (ранг " .. rank .. ")"
    end },
    { "^Equip: Improves your chance to get a critical strike by ([%d%.,]+)%%%.$",
        function (value)
            return "Екіпірування: збільшує ймовірність критичного удару на " .. value .. "%."
        end },
    { "^([%+%-]?[%d%.,]+)%% Critical Strike Chance$", function (value)
        return value .. "% до ймовірності критичного удару"
    end },
    { "^([%+%-]?%d+) Armor$", function (value)
        return value .. " броні"
    end },
    { "^(%d+) Block$", function (value)
        return value .. " блокування"
    end },
    { "^([%d%.,]+) %- ([%d%.,]+) Damage$", function (minimum, maximum)
        return minimum .. "–" .. maximum .. " шкоди"
    end },
    { "^Speed ([%d%.,]+)$", function (value)
        return "Швидкість " .. value
    end },
    { "^%(([%d%.,]+) damage per second%)$", function (value)
        return "(" .. value .. " шкоди за секунду)"
    end },
    { "^([%+%-]?[%d%.,]+) damage per second$", function (value)
        return value .. " шкоди за секунду"
    end },
    { "^Adds ([%d%.,]+) damage per second$", function (value)
        return "Додає " .. value .. " шкоди за секунду"
    end },
    { "^Adds ([%d%.,]+) ([A-Za-z]+) damage per second$",
        function (value, school)
            local name = item_resistance_names[school]
            return name and ("Додає " .. value .. " шкоди від "
                .. name .. " за секунду") or nil
        end },
    { "^Durability (%d+) / (%d+)$", function (current, maximum)
        return "Міцність " .. current .. " / " .. maximum
    end },
    { "^Requires Level (%d+)$", function (level)
        return "Необхідний рівень " .. level
    end },
    { "^Item Level (%d+)$", function (level)
        return "Рівень предмета " .. level
    end },
    { "^(%d+) Slot (.+)$", function (slots, kind)
        local name = container_names[kind]
        return name and (name .. " на " .. slots .. " комірок") or nil
    end },
    { "^Assigned to: |cffffffff(.-)|r$", function (filters)
        local translated = translate_bag_filter_list(filters)
        return translated and ("Призначено для: |cffffffff"
            .. translated .. "|r") or nil
    end },
    { "^<Made by (.+)>$", function (name)
        return "<Виготовлено: " .. name .. ">"
    end },
    { "^Sell Price: (.+)$", function (price)
        return "Ціна продажу: " .. price
    end },
    { "^Cooldown remaining: (.+)$", function (remaining)
        remaining = remaining:gsub("([A-Za-z]+)", function (word)
            return tooltip.dynamic_value_words[word:lower()] or word
        end)
        return "Залишилося до відновлення: " .. remaining
    end },
    { "^([%+%-])(%d+) ([A-Za-z ]+)$",
        function (sign, amount, stat)
            local name = item_stat_name(stat)
            return name and (sign .. amount .. " до " .. name) or nil
        end },
    -- TOOLTIP_ITEM_STAT_RANGE_FORMAT; accept only known stat labels.
    { "^([%+%-])([%d,.]+)%-([%d,.]+) (.+)$",
        function (sign, minimum, maximum, stat)
            local name = item_stat_name(stat)
            return name and (sign .. minimum .. "–" .. maximum .. " до " .. name) or nil
        end },
    { "^Equip: Increases damage and healing done by magical spells and effects by up to (%d+)%.$",
        function (amount)
            return "Екіпірування: збільшує шкоду та зцілення від магічних заклять і ефектів на "
                .. amount .. "."
        end },
    { "^Equip: Increases damage done by ([A-Za-z]+) spells and effects by up to (%d+)%.$",
        function (school, amount)
            local name = item_resistance_names[school]
            return name and ("Екіпірування: збільшує шкоду від заклять та ефектів "
                .. name .. " на " .. amount .. ".") or nil
        end },
    { "^Equip: Decreases damage done by ([A-Za-z]+) spells and effects by up to (%d+)%.$",
        function (school, amount)
            local name = item_resistance_names[school]
            return name and ("Екіпірування: зменшує шкоду від заклять та ефектів "
                .. name .. " на " .. amount .. ".") or nil
        end },
    { "^Equip: Increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects%.$",
        function (healing, damage)
            return "Екіпірування: збільшує зцілення від усіх магічних заклять та ефектів на "
                .. healing .. ", а шкоду — на " .. damage .. "."
        end },
    { "^Use: Teaches you how to craft (.+)%.$", function (name)
        local translated = addonTable.use("item_client_db").get_name_by_english(name)
            or addonTable.use("entries").lookup_name("item", name)
        if not translated then return nil end
        return "Використання: навчає виготовляти «" .. translated .. "»."
    end },
    { "^%+(%d+) ([A-Za-z]+) Resistance$",
        function (amount, school)
            local name = item_resistance_names[school]
            return name and ("+" .. amount .. " до опору " .. name) or nil
        end },
}

function tooltip.translate_spell_requirements(source, translate_names)
    local label, body = source:match("^(%a+):(.*)$")
    local labels = { Tools = "Інструменти:", Reagents = "Реагенти:" }
    if not labels[label] then return nil end
    return labels[label] .. translate_names(body)
end

-- Exact GlobalStrings formats from 1.60.1.70170. Ukrainian wording is resolved
-- from the existing UI catalogs; rendered numbers are never dictionary keys.
local item_client_formats = {
    { "ITEM_CLASSES_ALLOWED", "Classes: %s" },
    { "ITEM_COOLDOWN_TIME_MIN", "Cooldown remaining: %d min" },
    { "ITEM_LEVEL", "Item Level %d" },
    { "ITEM_MIN_SKILL", "Requires %s (%d)" },
    { "ITEM_MOD_MANA", "%c%s Mana" },
    { "ITEM_MOD_HEALTH", "%c%s Health" },
    { "ITEM_MOD_AGILITY", "%c%s Agility" },
    { "ITEM_MOD_STRENGTH", "%c%s Strength" },
    { "ITEM_MOD_SPIRIT", "%c%s Spirit" },
    { "ITEM_MOD_STAMINA", "%c%s Stamina" },
    { "ITEM_PROPOSED_ENCHANT", "Will receive %s." },
    { "ITEM_REQ_SKILL", "Requires %s" },
    { "ITEM_RESIST_ALL", "%c%d to All Resistances" },
    { "ITEM_RESIST_SINGLE", "%c%d %s Resistance" },
    { "ITEM_SPELL_CHARGES", "%d |4Charge:Charges;" },
    { "ITEM_UNIQUE_MULTIPLE", "Unique (%d)" },
    { "ITEM_LEVEL_AND_MIN", "Level %d (min %d)" },
    { "ITEM_CREATED_BY", "|cff00ff00<Made by %s>|r" },
    { "ITEM_DURATION_MIN", "Duration: %d min" },
    { "ITEM_DURATION_SEC", "Duration: %d sec" },
    { "ITEM_RACES_ALLOWED", "Races: %s" },
    { "ITEM_SPELL_EFFECT", "Effect: %s" },
    { "BIND_KEY_TO_COMMAND", "Press Key to Bind to Command -> %s" },
    { "ITEM_SUFFIX_TEMPLATE", "%s %s" },
    { "ITEM_MIN_LEVEL", "Requires Level %d" },
    { "ITEM_WRAPPED_BY", "|cff00ff00<Gift from %s>|r" },
    { "BIND_ZONE_DISPLAY", "You are bound in %s." },
    { "ITEM_MOD_INTELLECT", "%c%s Intellect" },
    { "ITEM_WRITTEN_BY", "Written by %s" },
    { "ITEM_COOLDOWN_TIME_SEC", "Cooldown remaining: %d sec" },
    { "ITEM_ENCHANT_TIME_LEFT_MIN", "%s (%d min)" },
    { "DURABILITY_TEMPLATE", "Durability %d / %d" },
    { "ITEM_ENCHANT_TIME_LEFT_HOURS", "%s (%d |4hour:hours;)" },
    { "ITEM_ENCHANT_TIME_LEFT_DAYS", "%s (%d |4day:days;)" },
    { "ITEM_COOLDOWN_TIME_HOURS", "Cooldown remaining: %d |4hour:hours;" },
    { "ITEM_COOLDOWN_TIME_DAYS", "Cooldown remaining: %d |4day:days;" },
    { "ITEM_DURATION_HOURS", "Duration: %d |4hour:hrs;" },
    { "ITEM_DURATION_DAYS", "Duration: %d |4day:days;" },
    { "ITEM_SET_BONUS", "Set: %s" },
    { "ITEM_ENCHANT_TIME_LEFT_SEC", "%s (%d sec)" },
    { "ITEM_SET_NAME", "%s (%d/%d)" },
    { "DURABILITYDAMAGE_DEATH", "Your equipped items suffer a %d%% durability loss." },
    { "ITEM_REQ_REPUTATION", "Requires %s - %s" },
    { "ITEM_SET_BONUS_GRAY", "(%d) Set: %s" },
    { "ITEM_MOD_DEFENSE_SKILL_RATING", "Increases defense skill by %s." },
    { "ITEM_MOD_DODGE_RATING", "Increases your dodge by %s." },
    { "ITEM_MOD_PARRY_RATING", "Increases your parry by %s." },
    { "ITEM_MOD_BLOCK_RATING", "Increases your shield block by %s." },
    { "ITEM_MOD_HIT_MELEE_RATING", "Improves melee hit by %s." },
    { "ITEM_MOD_HIT_RANGED_RATING", "Improves ranged hit by %s." },
    { "ITEM_MOD_HIT_SPELL_RATING", "Improves spell hit by %s." },
    { "ITEM_MOD_CRIT_MELEE_RATING", "Improves melee critical strike by %s." },
    { "ITEM_MOD_CRIT_RANGED_RATING", "Improves ranged critical strike by %s." },
    { "ITEM_MOD_CRIT_SPELL_RATING", "Improves spell critical strike by %s." },
    { "ITEM_MOD_HIT_TAKEN_MELEE_RATING", "Improves melee hit avoidance by %s." },
    { "ITEM_MOD_HIT_TAKEN_RANGED_RATING", "Improves ranged hit avoidance by %s." },
    { "ITEM_MOD_HIT_TAKEN_SPELL_RATING", "Improves spell hit avoidance by %s." },
    { "ITEM_MOD_CRIT_TAKEN_MELEE_RATING", "Improves melee critical avoidance by %s." },
    { "ITEM_MOD_CRIT_TAKEN_RANGED_RATING", "Improves ranged critical avoidance by %s." },
    { "ITEM_MOD_CRIT_TAKEN_SPELL_RATING", "Improves spell critical avoidance by %s." },
    { "ITEM_MOD_HIT_RATING", "Increases your hit by %s." },
    { "ITEM_MOD_CRIT_RATING", "Increases your critical strike by %s." },
    { "ITEM_MOD_HIT_TAKEN_RATING", "Improves hit avoidance by %s." },
    { "ITEM_MOD_CRIT_TAKEN_RATING", "Improves critical avoidance by %s." },
    { "ITEM_MOD_RESILIENCE_RATING", "Increases your PvP resilience by %s." },
    { "ITEM_MOD_HASTE_RATING", "Increases your haste by %s." },
    { "ITEM_SOCKET_BONUS", "Socket Bonus: %s" },
    { "ITEM_DISENCHANT_MIN_SKILL", "Disenchanting requires %s (%d)" },
    { "ITEM_MOD_EXPERTISE_RATING", "Increases your expertise by %s." },
    { "ITEM_REQ_ARENA_RATING", "Requires personal arena rating of %d" },
    { "ITEM_COOLDOWN_TOTAL_DAYS", "(%d |4Day:Days; Cooldown)" },
    { "ITEM_COOLDOWN_TOTAL_HOURS", "(%d |4Hour:Hours; Cooldown)" },
    { "ITEM_COOLDOWN_TOTAL_MIN", "(%d Min Cooldown)" },
    { "ITEM_COOLDOWN_TOTAL_SEC", "(%d Sec Cooldown)" },
    { "ITEM_COOLDOWN_TIME", "Cooldown remaining: %s" },
    { "ITEM_COOLDOWN_TOTAL", "(%s Cooldown)" },
    { "ITEM_QUANTITY_TEMPLATE", "%1$d %2$s" },
    { "ITEM_LIMIT_CATEGORY_MULTIPLE", "Unique-Equipped: %s (%d)" },
    { "ITEM_LIMIT_CATEGORY", "Unique: %s (%d)" },
    { "ITEM_MOD_SPELL_HEALING_DONE", "Increases healing done by magical spells and effects by up to %s." },
    { "ITEM_MOD_SPELL_DAMAGE_DONE", "Increases damage done by magical spells and effects by up to %s." },
    { "ITEM_MOD_ATTACK_POWER", "Increases attack power by %s." },
    { "ITEM_MOD_RANGED_ATTACK_POWER", "Increases ranged attack power by %s." },
    { "ITEM_MOD_MANA_REGENERATION", "Restores %s mana per 5 sec." },
    { "ITEM_MOD_FERAL_ATTACK_POWER", "Increases attack power by %s in Cat, Bear, Dire Bear, and Moonkin forms only." },
    { "ITEM_LEVEL_RANGE", "Requires level %d to %d" },
    { "ITEM_MOD_ARMOR_PENETRATION_RATING", "Increases your armor piercing by %s." },
    { "ITEM_MOD_SPELL_POWER", "Increases spell power by %s." },
    { "ITEM_LEVEL_RANGE_CURRENT", "Requires level %d to %d (%d)" },
    { "SOCKET_ITEM_MIN_SKILL", "Socket Requires %s (%d)" },
    { "SOCKET_ITEM_REQ_SKILL", "Socket Requires %s" },
    { "SOCKET_ITEM_REQ_LEVEL", "Socket Requires Level %d" },
    { "REFUND_TIME_REMAINING", "You may sell this item to a vendor within %s (including time offline) for a full refund." },
    { "ITEM_MOD_HEALTH_REGENERATION", "Restores %s health per 5 sec." },
    { "ITEM_MOD_SPELL_PENETRATION", "Increases spell piercing by %s." },
    { "ITEM_MOD_BLOCK_VALUE", "Increases the block value of your shield by %s." },
    { "BIND_TRADE_TIME_REMAINING", "You may trade this item with players that were also eligible to loot this item for the next %s (including time offline)." },
    { "ITEM_REQ_ARENA_RATING_3V3", "Requires personal arena rating of %d|nin the 3v3 bracket." },
    { "ITEM_REQ_ARENA_RATING_5V5", "Requires personal arena rating of %d|nin 5v5 brackets" },
    { "ITEM_SLOTS_IGNORED", "%d |4slot:slots; ignored" },
    { "ITEM_MOD_HEALTH_REGEN", "Restores %s health per 5 sec." },
    { "ITEM_MISSING", "%s missing" },
    { "ITEM_MOD_MASTERY_RATING", "Increases your mastery by %s." },
    { "ITEM_REQ_PURCHASE_GUILD_LEVEL", "Requires guild level %d" },
    { "ITEM_REQ_PURCHASE_ACHIEVEMENT", "Requires achievement: %s" },
    { "ITEM_MOD_MASTERY_RATING_SPELL", "(%s)" },
    { "ITEM_MOD_MASTERY_RATING_TWO_SPELLS", "(%s/%s)" },
    { "ITEM_REQ_ARENA_RATING_3V3_BG", "Requires battleground rating of %d or|npersonal arena rating of %d|nin the 3v3  bracket." },
    { "ITEM_REQ_ARENA_RATING_BG", "Requires battleground rating of %d or|npersonal arena rating of %d" },
    { "ITEM_REQ_AMOUNT_EARNED", "Requires earning a total of %1$d\\n%2$s for the season." },
    { "ITEM_MOD_PVP_POWER", "Increases your PvP power by %s." },
    { "ITEM_LEVEL_ALT", "Item Level %d (%d)" },
    { "ITEM_PET_KNOWN", "Collected (%d/%d)" },
    { "ITEM_UPGRADE_TOOLTIP_FORMAT", "Upgrade Level: %d/%d" },
    { "ITEM_CHARGEUP_TOTAL", "(Requires %s)" },
    { "ITEM_CHARGEUP_TOTAL_DAYS", "(Requires %d |4Day:Days;)" },
    { "ITEM_CHARGEUP_TOTAL_HOURS", "(Requires %d |4Hour:Hours;)" },
    { "ITEM_CHARGEUP_TOTAL_MIN", "(Requires %d Min)" },
    { "ITEM_CHARGEUP_TOTAL_SEC", "(Requires %d Sec)" },
    { "ITEM_UPGRADE_BONUS_FORMAT", "(+%d) " },
    { "ITEM_MOD_EXTRA_ARMOR", "Increases your armor by %s." },
    { "ITEM_DELTA_DUAL_WIELD_COMPARISON_OFFHAND_DESCRIPTION", "(With |c%s%s|r equipped in your off-hand)" },
    { "ITEM_DELTA_DUAL_WIELD_COMPARISON_MAINHAND_DESCRIPTION", "(With |c%s%s|r equipped in your main-hand)" },
    { "ITEM_COMPARISON_SWAP_ITEM_OFFHAND_DESCRIPTION", "Press %s to cycle through your off-hand items." },
    { "ITEM_COMPARISON_SWAP_ITEM_MAINHAND_DESCRIPTION", "Press %s to cycle through your main-hand items." },
    { "ITEM_REQ_SPECIALIZATION", "Requires: %s" },
    { "ITEM_SPELL_MAX_USABLE_LEVEL", " (Requires level %d or below)" },
    { "DURABILITY_LCD", "DURA %d" },
    { "ITEM_COMPARISON_RELIC_BONUS_RANKS", "%d |4Rank:Ranks;:" },
    { "ITEM_LEVEL_PLUS", "Item Level %d+" },
    { "ITEM_CREATE_LOOT_SPEC_ITEM", "Use: Create a soulbound item appropriate for your loot specialization (%s)." },
    { "ITEM_CORRUPTION_BONUS_STAT", "+%d Corruption" },
    { "ITEM_UPGRADE_FRAME_CURRENT_UPGRADE_FORMAT", "Upgrade Level: %s/%s" },
    { "ITEM_UPGRADE_BONUS_STAT_FORMAT", "|cff20ff20%1$d (+%2$d)|r %3$s" },
    { "ITEM_UPGRADE_STAT_FORMAT", "%1$d %2$s" },
    { "ITEM_UPGRADE_BONUS_DAMAGE_TEMPLATE", "|cff20ff20%1$s - %2$s|r Damage" },
    { "ITEM_UPGRADE_DROPDOWN_LEVEL_FORMAT", "Level %d/%d" },
    { "ITEM_UPGRADE_ITEM_LEVEL_BONUS_STAT_FORMAT", "Item Level |cff20ff20%1$d (+%2$d)|r" },
    { "ITEM_UPGRADE_ITEM_LEVEL_STAT_FORMAT", "Item Level %d" },
    { "ITEM_UPGRADE_INACTIVE_BONUS_STAT_FORMAT", "|cff7f7f7f%1$d (+%2$d) %3$s|r" },
    { "ITEM_UPGRADE_INACTIVE_STAT_FORMAT", "|cff7f7f7f%1$d %2$s|r" },
    { "ITEM_UPGRADE_PVP_ITEM_LEVEL_STAT_FORMAT", "PvP Item Level %d" },
    { "ITEM_UPGRADE_PVP_ITEM_LEVEL_BONUS_STAT_FORMAT", "PvP Item Level |cff20ff20%1$d (+%2$d)|r" },
    { "ITEM_UPGRADE_BONUS_FORMAT_COLORIZED", "|cff20ff20%s (+%d)|r" },
    { "ITEM_UPGRADE_TOOLTIP_FORMAT_STRING", "Upgrade Level: %s %d/%d" },
    { "ITEM_UPGRADE_DROPDOWN_LEVEL_FORMAT_STRING", "%s %d/%d" },
    { "ITEM_UPGRADE_FRAME_CURRENT_UPGRADE_FORMAT_STRING", "Upgrade Level: %s %s/%s" },
    { "ITEM_UPGRADE_PROGRESS_LEVEL_FORMAT", "Level %d/%d  %d |cnDISABLED_FONT_COLOR:(%d-%d)|r" },
    { "ITEM_UPGRADE_PROGRESS_LEVEL_FORMAT_STRING", "%s %d/%d  %d |cnDISABLED_FONT_COLOR:(%d-%d)|r" },
    { "ITEM_UPGRADE_PROGRESS_ITEM_LEVEL_FORMAT", "%d |cnDISABLED_FONT_COLOR:(%d-%d)|r" },
    { "ITEM_UPGRADE_ERROR_NOT_ENOUGH_CURRENCY", "Not enough %s." },
    { "ITEM_UPGRADE_ERROR_NOT_ENOUGH_CURRENCY_TWO", "Not enough %s and %s." },
    { "ITEM_LEVEL_UPGRADE_MAX", "Item Level %d" },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_CURRENT_CHARACTER", "This upgrade costs fewer %s because you have already acquired an item with higher item level (%d) in this slot." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_OTHER_CHARACTER", "This upgrade costs fewer %s because a character on your Account has already acquired an item with higher item level (%d) in this slot." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_TWO_SLOT_CURRENT_CHARACTER", "This upgrade costs fewer %s because you have already acquired two %s with higher item level (%d)." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_TWO_SLOT_OTHER_CHARACTER", "This upgrade costs fewer %s because a character on your Account has already acquired two %s with higher item level (%d)." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_PARTIAL_TWO_HAND_CURRENT_CHARACTER", "This upgrade costs fewer %s because you have already acquired a weapon set with higher item level (%d)." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_PARTIAL_TWO_HAND_OTHER_CHARACTER", "This upgrade costs fewer %s because a character on your Account has already acquired a weapon set with higher item level (%d)." },
    { "ITEM_UPGRADE_DISCOUNT_TOOLTIP_TITLE", "%s Discount" },
    { "ITEM_UPGRADE_FRAGMENTS_TOTAL", "Fragments Earned: |c%s%s/%s|r" },
    { "ITEM_MOD_PHYSICAL_DAMAGE_DONE", "Increases physical damage done by up to %s." },
    { "ITEM_MOD_HOLY_DAMAGE_DONE", "Increases holy damage done by up to %s." },
    { "ITEM_MOD_FIRE_DAMAGE_DONE", "Increases fire damage done by up to %s." },
    { "ITEM_MOD_NATURE_DAMAGE_DONE", "Increases nature damage done by up to %s." },
    { "ITEM_MOD_FROST_DAMAGE_DONE", "Increases frost damage done by up to %s." },
    { "ITEM_MOD_SHADOW_DAMAGE_DONE", "Increases shadow damage done by up to %s." },
    { "ITEM_MOD_ARCANE_DAMAGE_DONE", "Increases arcane damage done by up to %s." },
    { "ITEM_MOD_TWOHANDED_AXES", "Increases two-handed axes skill by %s." },
    { "ITEM_MOD_TWOHANDED_MACES", "Increases two-handed maces skill by %s." },
    { "ITEM_MOD_TWOHANDED_SWORDS", "Increases two-handed swords skill by %s." },
    { "ITEM_MOD_AXES", "Increases axes skill by %s." },
    { "ITEM_MOD_BOWS", "Increases bows skill by %s." },
    { "ITEM_MOD_CROSSBOWS", "Increases crossbows skill by %s." },
    { "ITEM_MOD_DAGGERS", "Increases daggers skill by %s." },
    { "ITEM_MOD_DUAL_WIELD", "Increases dual wield skill by %s." },
    { "ITEM_MOD_FIST_WEAPONS", "Increases fist weapons skill by %s." },
    { "ITEM_MOD_GUNS", "Increases guns skill by %s." },
    { "ITEM_MOD_MACES", "Increases maces skill by %s." },
    { "ITEM_MOD_POLEARMS", "Increases polearms skill by %s." },
    { "ITEM_MOD_STAVES", "Increases staves skill by %s." },
    { "ITEM_MOD_SWORDS", "Increases swords skill by %s." },
    { "ITEM_MOD_THROWN", "Increases thrown skill by %s." },
    { "ITEM_MOD_WANDS", "Increases wands skill by %s." },
    { "ITEM_MOD_ALCHEMY", "Increases alchemy skill by %s." },
    { "ITEM_MOD_BLACKSMITHING", "Increases blacksmithing skill by %s." },
    { "ITEM_MOD_ENCHANTING", "Increases enchanting skill by %s." },
    { "ITEM_MOD_ENGINEERING", "Increases engineering skill by %s." },
    { "ITEM_MOD_JEWELCRAFTING", "Increases jewelcrafting skill by %s." },
    { "ITEM_MOD_LEATHERWORKING", "Increases leatherworking skill by %s." },
    { "ITEM_MOD_HERBALISM", "Increases herbalism skill by %s." },
    { "ITEM_MOD_MINING", "Increases mining skill by %s." },
    { "ITEM_MOD_SKINNING", "Increases skinning skill by %s." },
    { "ITEM_MOD_COOKING", "Increases cooking skill by %s." },
    { "ITEM_MOD_FIRST_AID", "Increases first aid skill by %s." },
    { "ITEM_MOD_FISHING", "Increases fishing skill by %s." },
    { "ITEM_MOD_TAILORING", "Increases tailoring skill by %s." },
    { "ITEM_MOD_FIRE_PENETRATION", "Increases fire piercing by %s." },
    { "ITEM_MOD_NATURE_PENETRATION", "Increases nature piercing by %s." },
    { "ITEM_MOD_FROST_PENETRATION", "Increases frost piercing by %s." },
    { "ITEM_MOD_SHADOW_PENETRATION", "Increases shadow piercing by %s." },
    { "ITEM_MOD_ARCANE_PENETRATION", "Increases arcane piercing by %s." },
    { "ITEM_MOD_SPELL_RESISTANCE_ALL_SCHOOLS", "Increases spell resistance by %s." },
    -- Numeric item-stat descriptions, including decreases, from 70170.
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_INCREASE", "Equip: Increases healing done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_DECREASE", "Equip: Decreases healing done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_POWER_INCREASE", "Equip: Increases damage and healing done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_POWER_DECREASE", "Equip: Decreases damage and healing done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_DAMAGE_INCREASE", "Equip: Increases damage done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_DAMAGE_DECREASE", "Equip: Decreases damage done by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_HOLY_DAMAGE_INCREASE", "Equip: Increases damage done by Holy spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_HOLY_DAMAGE_DECREASE", "Equip: Decreases damage done by Holy spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_FIRE_DAMAGE_INCREASE", "Equip: Increases damage done by Fire spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_FIRE_DAMAGE_DECREASE", "Equip: Decreases damage done by Fire spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_NATURE_DAMAGE_INCREASE", "Equip: Increases damage done by Nature spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_NATURE_DAMAGE_DECREASE", "Equip: Decreases damage done by Nature spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_FROST_DAMAGE_INCREASE", "Equip: Increases damage done by Frost spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_FROST_DAMAGE_DECREASE", "Equip: Decreases damage done by Frost spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_ARCANE_DAMAGE_INCREASE", "Equip: Increases damage done by Arcane spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_ARCANE_DAMAGE_DECREASE", "Equip: Decreases damage done by Arcane spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SHADOW_DAMAGE_INCREASE", "Equip: Increases damage done by Shadow spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SHADOW_DAMAGE_DECREASE", "Equip: Decreases damage done by Shadow spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_WEAPON_DAMAGE_INCREASE", "Equip: +%1$d Weapon Damage." },
    { "TOOLTIP_ITEM_STAT_HIT_PERCENT_INCREASE", "Equip: Improves your chance to hit by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_HIT_PERCENT_DECREASE", "Equip: Decreases your chance to hit by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_CRIT_PERCENT_INCREASE", "Equip: Improves your chance to get a critical strike by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_CRIT_PERCENT_DECREASE", "Equip: Decreases your chance to get a critical strike by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_MANA_REGEN_INCREASE", "Equip: Restores %1$d Mana per 5 sec." },
    { "TOOLTIP_ITEM_STAT_MANA_REGEN_DECREASE", "Equip: Reduces Mana Regen by %1$d Mana per 5 sec." },
    { "TOOLTIP_ITEM_STAT_HEALTH_REGEN_INCREASE", "Equip: Restores %1$d Health per 5 sec." },
    { "TOOLTIP_ITEM_STAT_HEALTH_REGEN_DECREASE", "Equip: Reduces Health Regen by %1$d Health per 5 sec." },
    { "TOOLTIP_ITEM_STAT_DEFENSE_INCREASE", "Equip: Increased Defense +%1$d." },
    { "TOOLTIP_ITEM_STAT_DEFENSE_DECREASE", "Equip: Decreased Defense -%1$d." },
    { "TOOLTIP_ITEM_STAT_WEAPON_DAMAGE_DECREASE", "Equip: -%1$d Weapon Damage." },
    { "TOOLTIP_ITEM_STAT_BLOCK_VALUE_INCREASE", "Equip: Increases the Block Value of your shield by %1$d." },
    { "TOOLTIP_ITEM_STAT_BLOCK_VALUE_DECREASE", "Equip: Decreases the Block Value of your shield by %1$d." },
    { "TOOLTIP_ITEM_STAT_BLOCK_CHANCE_INCREASE", "Equip: Increases your chance to Block attacks with a shield by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_BLOCK_CHANCE_DECREASE", "Equip: Decreases your chance to Block attacks with a shield by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_SPELL_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Magical Resistance." },
    { "TOOLTIP_ITEM_STAT_SPELL_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Magical Resistance." },
    { "TOOLTIP_ITEM_STAT_FIRE_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Fire Resistance." },
    { "TOOLTIP_ITEM_STAT_FIRE_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Fire Resistance." },
    { "TOOLTIP_ITEM_STAT_NATURE_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Nature Resistance." },
    { "TOOLTIP_ITEM_STAT_NATURE_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Nature Resistance." },
    { "TOOLTIP_ITEM_STAT_FROST_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Frost Resistance." },
    { "TOOLTIP_ITEM_STAT_FROST_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Frost Resistance." },
    { "TOOLTIP_ITEM_STAT_ARCANE_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Arcane Resistance." },
    { "TOOLTIP_ITEM_STAT_ARCANE_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Arcane Resistance." },
    { "TOOLTIP_ITEM_STAT_SHADOW_PENETRATION_INCREASE", "Equip: Your spells pierce %1$d Shadow Resistance." },
    { "TOOLTIP_ITEM_STAT_SHADOW_PENETRATION_DECREASE", "Equip: Your spells pierce %1$d less Shadow Resistance." },
    { "TOOLTIP_ITEM_STAT_ARMOR_PENETRATION_INCREASE", "Equip: Your attacks pierce up to %1$d Armor." },
    { "TOOLTIP_ITEM_STAT_ARMOR_PENETRATION_DECREASE", "Equip: Your attacks pierce up to %1$d less Armor." },
    { "TOOLTIP_ITEM_STAT_ATTACK_POWER_INCREASE", "Equip: +%1$d Attack Power." },
    { "TOOLTIP_ITEM_STAT_ATTACK_POWER_DECREASE", "Equip: -%1$d Attack Power." },
    { "TOOLTIP_ITEM_STAT_RANGED_ATTACK_POWER_INCREASE", "Equip: +%1$d Ranged Attack Power." },
    { "TOOLTIP_ITEM_STAT_RANGED_ATTACK_POWER_DECREASE", "Equip: -%1$d Ranged Attack Power." },
    { "TOOLTIP_ITEM_STAT_EXPERTISE_PCT_INCREASE", "Equip: Reduces chance to be Dodged or Parried by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_EXPERTISE_PCT_DECREASE", "Equip: Increases chance to be Dodged or Parried by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_HASTE_PCT_INCREASE", "Equip: Increases your attack speed and casting speed by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_HASTE_PCT_DECREASE", "Equip: Decreases your attack speed and casting speed by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_ARMOR_INCREASE", "+%1$d Armor" },
    { "TOOLTIP_ITEM_STAT_ARMOR_DECREASE", "-%1$d Armor" },
    { "TOOLTIP_ITEM_STAT_DODGE_PCT_INCREASE", "Equip: Increases your chance to Dodge an attack by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_DODGE_PCT_DECREASE", "Equip: Decreases your chance to Dodge an attack by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_PARRY_PCT_INCREASE", "Equip: Increases your chance to Parry an attack by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_PARRY_PCT_DECREASE", "Equip: Decreases your chance to Parry an attack by %1$.1f%%." },
    { "TOOLTIP_ITEM_STAT_SKILL_SWORDS_INCREASE", "Equip: Increased Swords +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_SWORDS_DECREASE", "Equip: Decreased Swords -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_MACES_INCREASE", "Equip: Increased Maces +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_MACES_DECREASE", "Equip: Decreased Maces -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_AXES_INCREASE", "Equip: Increased Axes +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_AXES_DECREASE", "Equip: Decreased Axes -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FIST_WEAPONS_INCREASE", "Equip: Increased Fist Weapons +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FIST_WEAPONS_DECREASE", "Equip: Decreased Fist Weapons -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_DAGGERS_INCREASE", "Equip: Increased Daggers +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_DAGGERS_DECREASE", "Equip: Decreased Daggers -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_STAVES_INCREASE", "Equip: Increased Staves +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_STAVES_DECREASE", "Equip: Decreased Staves -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_SWORDS_INCREASE", "Equip: Increased Two-Handed Swords +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_SWORDS_DECREASE", "Equip: Decreased Two-Handed Swords -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_MACES_INCREASE", "Equip: Increased Two-Handed Maces +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_MACES_DECREASE", "Equip: Decreased Two-Handed Maces -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_AXES_INCREASE", "Equip: Increased Two-Handed Axes +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TWO-HANDED_AXES_DECREASE", "Equip: Decreased Two-Handed Axes -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_POLEARMS_INCREASE", "Equip: Increased Polearms +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_POLEARMS_DECREASE", "Equip: Decreased Polearms -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_BOWS_INCREASE", "Equip: Increased Bows +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_BOWS_DECREASE", "Equip: Decreased Bows -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_CROSSBOWS_INCREASE", "Equip: Increased Crossbows +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_CROSSBOWS_DECREASE", "Equip: Decreased Crossbows -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_GUNS_INCREASE", "Equip: Increased Guns +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_GUNS_DECREASE", "Equip: Decreased Guns -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_WANDS_INCREASE", "Equip: Increased Wands +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_WANDS_DECREASE", "Equip: Decreased Wands -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_THROWN_WEAPONS_INCREASE", "Equip: Increased Thrown Weapons +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_THROWN_WEAPONS_DECREASE", "Equip: Decreased Thrown Weapons -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ALCHEMY_INCREASE", "Equip: Increased Alchemy +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ALCHEMY_DECREASE", "Equip: Decreased Alchemy -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_DUAL_WIELDING_INCREASE", "Equip: Increased Dual Wielding +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_DUAL_WIELDING_DECREASE", "Equip: Decreased Dual Wielding -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_JEWELCRAFTING_INCREASE", "Equip: Increased Jewelcrafting +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_JEWELCRAFTING_DECREASE", "Equip: Decreased Jewelcrafting -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_BLACKSMITHING_INCREASE", "Equip: Increased Blacksmithing +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_BLACKSMITHING_DECREASE", "Equip: Decreased Blacksmithing -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ENCHANTING_INCREASE", "Equip: Increased Enchanting +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ENCHANTING_DECREASE", "Equip: Decreased Enchanting -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ENGINEERING_INCREASE", "Equip: Increased Engineering +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_ENGINEERING_DECREASE", "Equip: Decreased Engineering -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_LEATHERWORKING_INCREASE", "Equip: Increased Leatherworking +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_LEATHERWORKING_DECREASE", "Equip: Decreased Leatherworking -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_HERBALISM_INCREASE", "Equip: Increased Herbalism +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_HERBALISM_DECREASE", "Equip: Decreased Herbalism -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_MINING_INCREASE", "Equip: Increased Mining +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_MINING_DECREASE", "Equip: Decreased Mining -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_SKINNING_INCREASE", "Equip: Increased Skinning +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_SKINNING_DECREASE", "Equip: Decreased Skinning -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_COOKING_INCREASE", "Equip: Increased Cooking +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_COOKING_DECREASE", "Equip: Decreased Cooking -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FIRST_AID_INCREASE", "Equip: Increased First Aid +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FIRST_AID_DECREASE", "Equip: Decreased First Aid -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FISHING_INCREASE", "Equip: Increased Fishing +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_FISHING_DECREASE", "Equip: Decreased Fishing -%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TAILORING_INCREASE", "Equip: Increased Tailoring +%1$d." },
    { "TOOLTIP_ITEM_STAT_SKILL_TAILORING_DECREASE", "Equip: Decreased Tailoring -%1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_RESISTANCE_ALL_SCHOOLS_INCREASE", "+%1$d to All Resistances" },
    { "TOOLTIP_ITEM_STAT_SPELL_RESISTANCE_ALL_SCHOOLS_DECREASE", "-%1$d to All Resistances" },
    { "TOOLTIP_ITEM_STAT_AP_VS_HUMANOID_INCREASE", "Equip: +%1$d Attack Power against Humanoids." },
    { "TOOLTIP_ITEM_STAT_AP_VS_HUMANOID_DECREASE", "Equip: -%1$d Attack Power against Humanoids." },
    { "TOOLTIP_ITEM_STAT_AP_VS_ELEMENTAL_INCREASE", "Equip: +%1$d Attack Power against Elementals." },
    { "TOOLTIP_ITEM_STAT_AP_VS_ELEMENTAL_DECREASE", "Equip: -%1$d Attack Power against Elementals." },
    { "TOOLTIP_ITEM_STAT_AP_VS_DEMON_INCREASE", "Equip: +%1$d Attack Power against Demons." },
    { "TOOLTIP_ITEM_STAT_AP_VS_DEMON_DECREASE", "Equip: -%1$d Attack Power against Demons." },
    { "TOOLTIP_ITEM_STAT_AP_VS_UNDEAD_INCREASE", "Equip: +%1$d Attack Power against Undead." },
    { "TOOLTIP_ITEM_STAT_AP_VS_UNDEAD_DECREASE", "Equip: -%1$d Attack Power against Undead." },
    { "TOOLTIP_ITEM_STAT_AP_VS_DRAGONKIN_INCREASE", "Equip: +%1$d Attack Power against Dragonkin." },
    { "TOOLTIP_ITEM_STAT_AP_VS_DRAGONKIN_DECREASE", "Equip: -%1$d Attack Power against Dragonkin." },
    { "TOOLTIP_ITEM_STAT_AP_VS_GIANT_INCREASE", "Equip: +%1$d Attack Power against Giants." },
    { "TOOLTIP_ITEM_STAT_AP_VS_GIANT_DECREASE", "Equip: -%1$d Attack Power against Giants." },
    { "TOOLTIP_ITEM_STAT_AP_VS_BEAST_INCREASE", "Equip: +%1$d Attack Power against Beasts." },
    { "TOOLTIP_ITEM_STAT_AP_VS_BEAST_DECREASE", "Equip: -%1$d Attack Power against Beasts." },
    { "TOOLTIP_ITEM_STAT_AP_VS_MECHANICAL_INCREASE", "Equip: +%1$d Attack Power against Mechanical units." },
    { "TOOLTIP_ITEM_STAT_AP_VS_MECHANICAL_DECREASE", "Equip: -%1$d Attack Power against Mechanical units." },
    { "TOOLTIP_ITEM_STAT_SD_VS_HUMANOID_INCREASE", "Equip: Increases damage done to Humanoids by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_HUMANOID_DECREASE", "Equip: Decreases damage done to Humanoids by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_ELEMENTAL_INCREASE", "Equip: Increases damage done to Elementals by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_ELEMENTAL_DECREASE", "Equip: Decreases damage done to Elementals by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_DEMON_INCREASE", "Equip: Increases damage done to Demons by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_DEMON_DECREASE", "Equip: Decreases damage done to Demons by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_UNDEAD_INCREASE", "Equip: Increases damage done to Undead by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_UNDEAD_DECREASE", "Equip: Decreases damage done to Undead by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_DRAGONKIN_INCREASE", "Equip: Increases damage done to Dragonkin by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_DRAGONKIN_DECREASE", "Equip: Decreases damage done to Dragonkin by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_GIANT_DECREASE", "Equip: Decreases damage done to Giants by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_GIANT_INCREASE", "Equip: Increases damage done to Giants by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_BEAST_INCREASE", "Equip: Increases damage done to Beasts by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_BEAST_DECREASE", "Equip: Decreases damage done to Beasts by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_MECHANICAL_INCREASE", "Equip: Increases damage done to Mechanical units by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SD_VS_MECHANICAL_DECREASE", "Equip: Decreases damage done to Mechanical units by magical spells and effects by up to %1$d." },
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_INCREASE_DAMAGE_INCREASE", "Equip: Increases healing done by up to %1$d and damage done by up to %2$d for all magical spells and effects." },
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_INCREASE_DAMAGE_DECREASE", "Equip: Increases healing done by up to %1$d and decreases damage done by up to %2$d for all magical spells and effects." },
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_DECREASE_DAMAGE_INCREASE", "Equip: Decreases healing done by up to %1$d and increases damage done by up to %2$d for all magical spells and effects." },
    { "TOOLTIP_ITEM_STAT_SPELL_HEALING_DECREASE_DAMAGE_DECREASE", "Equip: Decreases healing done by up to %1$d and damage done by up to %2$d for all magical spells and effects." },
}

local item_format_cache, item_format_cache_count = {}, 0
local function translate_format_capture(value, kind)
    if kind ~= "s" then return value end
    local clean = value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local strings = addonTable.use("strings")
    local name = tooltip.translate_item_modification(clean)
        or addonTable.use("item_client_db").get_name_by_english(clean)
        or addonTable.use("faction_client_db").get_name(clean)
        or strings.find_ui_translation(clean)
    if not name then
        if clean:find(",", 1, true) then
            local names, complete = {}, true
            for part in clean:gmatch("[^,]+") do
                local label = part:match("^%s*(.-)%s*$")
                local translated = strings.find_ui_translation(label)
                if not translated then complete = false; break end
                names[#names + 1] = translated
            end
            if complete and #names > 0 then name = table.concat(names, ", ") end
        end
        local known = true
        local duration = clean:gsub("([A-Za-z]+)", function (word)
            local unit = tooltip.dynamic_value_words[word:lower()]
            if not unit then known = false end
            return unit or word
        end)
        if not name and known and duration ~= clean then name = duration end
    end
    return name and tooltip.restore_item_markup(value, name) or value
end

local function translate_client_item_format(source)
    local cached = item_format_cache[source]
    if cached ~= nil then return cached ~= false and cached or nil end
    local strings = addonTable.use("strings")
    local renderer = addonTable.use("spell_template_renderer")
    local translated
    for _, format in ipairs(item_client_formats) do
        -- All-placeholder formats have no semantic identity. Item names,
        -- set names and stat arguments have dedicated domain handlers.
        if format[1] ~= "ITEM_SUFFIX_TEMPLATE" and format[1] ~= "ITEM_SET_NAME"
            and format[1] ~= "ITEM_QUANTITY_TEMPLATE" and format[1] ~= "ITEM_CLASSES_ALLOWED" then
            local ukrainian = strings.find_ui_translation(format[2])
            if ukrainian then
                local preserve = format[1] == "ITEM_CREATED_BY"
                    or format[1] == "ITEM_WRAPPED_BY" or format[1] == "ITEM_WRITTEN_BY"
                local candidate = renderer.render_format(format[2], ukrainian, source,
                    not preserve and translate_format_capture or nil)
                if candidate and candidate ~= source then translated = candidate; break end
            end
        end
    end
    if item_format_cache_count >= 512 then item_format_cache, item_format_cache_count = {}, 0 end
    item_format_cache[source] = translated or false
    item_format_cache_count = item_format_cache_count + 1
    return translated
end

local function translate_plain_item_line(source)
    if type(source) ~= "string" or source == "" then return nil end
    local translated = tooltip.item_line_exact[source]
        or tooltip.comparison_item_labels[source]
    if translated then return translated end
    local reference = tonumber(source:match("^%$@spelldesc(%d+)$"))
    if reference then return addonTable.use("spell_client_db").get_description(reference) end
    translated = tooltip.translate_item_modification(source)
    if translated then return translated end
    local spell_db = addonTable.use("spell_client_db")
    local renderer = addonTable.use("spell_template_renderer")
    -- Engineering enchantments refer to descriptions instead of short names.
    for _, id in ipairs({ 1225951, 1225982, 1226001 }) do
        local english, ukrainian = spell_db.get_english_description(id), spell_db.get_description(id)
        if english and ukrainian then
            translated = renderer.render(id, "spell", english, ukrainian, source)
            if translated then return translated end
        end
    end
    for _, rule in ipairs(tooltip.item_line_patterns) do
        local captures = { source:match(rule[1]) }
        if #captures > 0 then
            translated = rule[2](unpack(captures))
            if translated then return translated end
        end
    end
    return translate_client_item_format(source)
end

function tooltip.restore_item_markup(source, translated)
    if type(source) ~= "string" or type(translated) ~= "string" then return translated end
    local color, body, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
    if color and not body:find("|r", 1, true) then
        if translated:sub(1, #color) == color then return translated end
        return color .. translated .. reset
    end
    for prefix, payload, suffix in source:gmatch("(|c%x%x%x%x%x%x%x%x)(.-)(|r)") do
        local token = payload
        if token == "" or not translated:find(token, 1, true) then
            token = tooltip.pvp_rank_names[payload]
                or tooltip.item_line_exact[payload]
                or tooltip.comparison_item_labels[payload]
                or payload:match("([%+%-]?%d[%d%.,]*%%?)")
        end
        if token and token ~= "" and not translated:find(prefix .. token .. suffix, 1, true) then
            local first, last = translated:find(token, 1, true)
            if first then
                translated = translated:sub(1, first - 1) .. prefix .. token .. suffix
                    .. translated:sub(last + 1)
            end
        end
    end
    return translated
end

function tooltip.translate_item_line(source)
    if type(source) ~= "string" or source == "" then return nil end
    local translated = translate_plain_item_line(source)
    if not translated then
        local clean = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        if clean ~= source then translated = translate_plain_item_line(clean) end
    end
    return tooltip.restore_item_markup(source, translated)
end

tooltip.talent_description_overrides = {
    [12298] = {
        pattern = "^Increases your chance to Block attacks with your shield by ([%d,.]+)%% and grants you a ([%d,.]+)%% chance to generate ([%d,.]+) Rage when you Block%.$",
        replace = function (block, chance, rage)
            return "Збільшує ймовірність блокування атак щитом на " .. block
                .. "% і дає " .. chance .. "% ймовірності отримати " .. rage
                .. " од. люті під час блокування."
        end,
    },
    [12321] = {
        pattern = "^Increases the radius of your Battle Shout and Demoralizing Shout abilities by ([%d,.]+)%%%.$",
        replace = function (radius)
            return "Збільшує радіус дії «Бойового кличу» та «Деморалізуючого кличу» на "
                .. radius .. "%."
        end,
    },
}

function tooltip.points_form(amount)
    local last_two, last = amount % 100, amount % 10
    if last_two < 11 or last_two > 14 then
        if last == 1 then return "очко" end
        if last >= 2 and last <= 4 then return "очки" end
    end
    return "очок"
end

addonTable.forever_tooltip_ui = tooltip
