local _, addonTable = ...

-- Forever/Camelot UI strings that are not present in the Classic Era table.
-- These are display-only replacements; global Blizzard string constants are
-- intentionally left untouched because Camelot also uses some as lookup keys.
addonTable.forever_ui = {
    -- Chat channels use WoW group and guild terminology, not the literal
    -- meanings of "party", "officer", or "say" from the generated catalog.
    ["Say"] = "Сказати",
    ["Emote"] = "Емоції",
    ["Officer Chat"] = "Чат офіцерів",
    ["Blizzard Whispers"] = "Приватні повідомлення Battle.net",
    ["Party"] = "Група",
    ["Party Leader"] = "Лідер групи",
    ["Raid Leader"] = "Лідер рейду",
    ["Raid Warning"] = "Попередження рейду",
    ["Instance"] = "Група підземелля",
    ["Instance Leader"] = "Лідер групи підземелля",
    ["Guild Config"] = "Налаштування чату гільдії",
    ["Main Hand"] = "Основна рука",
    ["Off Hand"] = "Друга рука",
    ["Ranged"] = "Дальній бій",
    ["Attack Speed (seconds)"] = "Швидкість атаки (с)",
    ["Damage:"] = "Шкода:",
    ["DPS:"] = "Шкода/с:",
    ["Instantly removes and grants immunity to all Bleed, Poison, and Disease effects, and reduces all Physical damage taken by 10% for 8 sec."] = "Миттєво знімає всі ефекти кровотечі, отрути та хвороб і дає до них невразливість, а також зменшує всю отримувану фізичну шкоду на 10% протягом 8 с.",
    ["Increases chance to |cFFFFFFFFBlock|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFFFFFFFBlock Value %d|r\\nIncreased by |cFFFFFFFFStrength|r\\n\\n|cFFBCBCBCBlocking reduces the attack's damage by your Block Value|r\\n\\n|cFFBCBCBCOnly Melee and Ranged attacks from the front may be Blocked|r"] = "Збільшує шанс |cFFFFFFFFблокування|r на %.2f%%\\n\\nЗалежить від |cFFFFFFFFзахисту|r\\n\\n|cFFFFFFFFВеличина блокування: %d|r\\nЗалежить від |cFFFFFFFFсили|r\\n\\n|cFFBCBCBCБлокування зменшує отриману шкоду на величину блокування|r\\n\\n|cFFBCBCBCБлокувати можна лише атаки ближнього й дальнього бою спереду|r",
    ["Increases chance to |cFFFFFFFFDodge|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFAgility|r and |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCDodging nullifies the attack|r\\n\\n|cFFBCBCBCFor Players, only Melee attacks from the front may be Dodged\\n\\nFor Creatures, Melee attacks may be Dodged from any direction|r"] = "Збільшує шанс |cFFFFFFFFухилення|r на %.2f%%\\n\\nЗалежить від |cFFFFFFFFспритності|r та |cFFFFFFFFзахисту|r\\n\\n|cFFBCBCBCУхилення зводить шкоду від атаки нанівець|r\\n\\n|cFFBCBCBCГравці можуть ухилятися від атак ближнього бою лише спереду.\\n\\nІстоти можуть ухилятися від них із будь-якого боку.|r",
    ["Increases chance to |cFFFFFFFFParry|r by %.2f%%\\n\\nIncreased by |cFFFFFFFFDefense|r\\n\\n|cFFBCBCBCParrying nullifies the attack and reduces the time until the defender's next Melee attack by 40%%|r\\n\\n|cFFBCBCBCOnly Melee attacks from the front may be Parried|r"] = "Збільшує шанс |cFFFFFFFFпарирування|r на %.2f%%\\n\\nЗалежить від |cFFFFFFFFзахисту|r\\n\\n|cFFBCBCBCПарирування зводить шкоду від атаки нанівець і скорочує час до наступної атаки ближнього бою на 40%%|r\\n\\n|cFFBCBCBCПарирувати можна лише атаки ближнього бою спереду|r",
    -- WoW formatting-only values are intentionally preserved verbatim.
    ["|c%s%s|r"] = "|c%s%s|r",
    ["|n|n"] = "|n|n",
    ["Map & Quest Log"] = "Мапа та журнал завдань",
    ["World"] = "Світ",
    ["Zone"] = "Зона",
    ["Search Quest Log"] = "Пошук у журналі завдань",
    ["No quests available"] = "Немає доступних завдань",
    ["Accept quests by talking to characters with a ! above their head."] = "Приймайте завдання у персонажів зі знаком ! над головою.",
    ["Quest Objectives"] = "Доручення",
    ["QUEST OBJECTIVES"] = "ДОРУЧЕННЯ",
    ["Rewards"] = "Винагороди",
    ["REWARDS"] = "ВИНАГОРОДИ",
    ["You will be able to choose one of these rewards:"] = "Ви зможете обрати одну з цих винагород:",
    ["Choose your reward:"] = "Оберіть собі винагороду:",
    ["You will receive:"] = "Ви отримаєте:",
    ["You will also receive:"] = "Ви також отримаєте:",
    ["You will receive"] = "Ви отримаєте",
    ["You will also receive"] = "Ви також отримаєте",
    ["Accept"] = "Прийняти",
    ["Decline"] = "Відхилити",
    ["Continue"] = "Продовжити",
    ["Complete Quest"] = "Завершити завдання",
    ["Cancel"] = "Скасувати",
    ["Close"] = "Закрити",
    ["Description"] = "Опис",
    ["DESCRIPTION"] = "ОПИС",
    ["Required Items:"] = "Потрібні предмети:",
    ["Quest Log"] = "Журнал завдань",
    ["Quests"] = "Завдання",
    ["Game Menu"] = "Меню гри",
    ["Account Collections"] = "Колекції облікового запису",
    ["Spellbook & Professions"] = "Книга заклять і професії",
    ["Talents"] = "Таланти",
    ["Achievements"] = "Досягнення",
    ["Legacy"] = "Спадщина",
    ["Housing Dashboard"] = "Панель житла",
    ["Guild Finder"] = "Пошук гільдії",
    ["Dungeon Journal"] = "Журнал підземель",
    ["Adventure Guide"] = "Путівник пригод",
    ["Shop"] = "Крамниця",
    ["General"] = "Загальні",
    ["General Tab"] = "Загальна вкладка",
    ["<Right click for Tab Settings>"] = "<ПКМ: налаштування вкладки>",
    ["Languages"] = "Мови",
    ["Return to Game"] = "Повернутися до гри",
    ["Options"] = "Налаштування",
    ["Edit Mode"] = "Режим редагування",
    ["Macros"] = "Макроси",
    ["AddOns"] = "Аддони",
    ["Support"] = "Підтримка",
    ["Log Out"] = "Вийти з обл. запису",
    ["Exit Game"] = "Вийти з гри",
    ["Issue Reporter"] = "Звітувати про проблему",
    ["Primary Attributes"] = "Основні характеристики",
    ["Weapons"] = "Зброя",
    ["Health:"] = "Здоров'я:",
    ["Rage:"] = "Лють:",
    ["Agility:"] = "Спритність:",
    ["Stamina:"] = "Витривалість:",
    ["Intellect:"] = "Інтелект:",
    ["Spirit:"] = "Дух:",
    ["Movement Speed:"] = "Швидкість руху:",
    ["Increases |cFFFFFFFFAttack Power|r by %d\\nIncreases |cFFFFFFFFBlock Value|r by %d"] =
        "Збільшує |cFFFFFFFFсилу атаки|r на %d\nЗбільшує |cFFFFFFFFвеличину блокування|r на %d",
    ["Increases |cFFFFFFFFWeapon Skill|r improvement rate"] =
        "Прискорює розвиток |cFFFFFFFFвміння володіння зброєю|r",
    ["|cFFBCBCBCBase Speeds (In Yards Per Second):\\n7.0 yd/s Running\\n4.7 yd/s Swimming\\n4.5 yd/s Backpedaling\\n2.5 yd/s Walking|r"] =
        "|cFFBCBCBCБазова швидкість (ярдів за секунду):\n7,0 — біг\n4,7 — плавання\n4,5 — рух назад\n2,5 — ходьба|r",
    ["Attack Power:"] = "Сила атаки:",
    ["Ranged Attack Power:"] = "Сила атаки дальнього бою:",
    ["Main Hand:"] = "Основна рука:",
    ["Modifiers"] = "Модифікатори",
    ["Critical Strike:"] = "Критичний удар:",
    ["Increases |cFFFFFFFFMelee|r critical chance by %.2f%%"] =
        "Збільшує шанс критичного удару |cFFFFFFFFу ближньому бою|r на %.2f%%",
    ["Increases |cFFFFFFFFRanged|r critical chance by %.2f%%"] =
        "Збільшує шанс критичного удару |cFFFFFFFFзброєю дальнього бою|r на %.2f%%",
    ["Increases |cFFFFFFFFSpell|r critical chance by %.2f%%"] =
        "Збільшує шанс критичного удару |cFFFFFFFFзакляттями|r на %.2f%%",
    ["Increased by |cFFFFFFFFAgility|r for Attacks\\r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"] =
        "Залежить від |cFFFFFFFFспритності|r для атак\n\n"
        .. "|cFFBCBCBCКритичні удари ближнього й дальнього бою завдають на 100% більше шкоди.\n\n"
        .. "Критичні удари заклять і зцілення на 50% ефективніші.\n\n"
        .. "Більшість періодичних ефектів можуть завдати критичного удару.|r",
    ["Increased by |cFFFFFFFFAgility|r for Attacks|r\\n\\n|cFFBCBCBCMelee and Ranged critical strikes deal 100%% increased damage\\n\\nSpell and Healing critical strikes are 50%% more effective\\n\\nMost periodic effects can critically strike|r"] =
        "Залежить від |cFFFFFFFFспритності|r для атак\n\n"
        .. "|cFFBCBCBCКритичні удари ближнього й дальнього бою завдають на 100% більше шкоди.\n\n"
        .. "Критичні удари заклять і зцілення на 50% ефективніші.\n\n"
        .. "Більшість періодичних ефектів можуть завдати критичного удару.|r",
    ["Defense:"] = "Захист:",
    ["Dodge:"] = "Ухилення:",
    ["Parry:"] = "Парирування:",
    ["Block:"] = "Блокування:",
    ["Armor:"] = "Броня:",
    ["Resistances"] = "Опори",
    ["Arcane:"] = "Аркана:",
    ["Fire:"] = "Вогонь:",
    ["Nature:"] = "Природа:",
    ["Frost:"] = "Крига:",
    ["Shadow:"] = "Тінь:",
    ["Combat Log"] = "Журнал бою",
    ["Say:"] = "Сказати:",
    ["Warrior"] = "Воїн",
    ["Warlock"] = "Чорнокнижник",
    ["Equipped"] = "Споряджено",
    ["Cannot change equip status while in combat"] =
        "Не можна змінювати спорядження під час бою",
    ["Soulbound"] = "Прив’язано до душі",
    ["One-Hand"] = "Одноручна",
    ["Shield"] = "Щит",
    ["Mace"] = "Булава",
    ["Axe"] = "Сокира",
    ["Free Trial level cap reached."] = "Досягнуто максимального рівня пробної версії.",
    ["This feature becomes available when your first character reaches level 25."] = "Доступно після 25-го рівня першого персонажа.",
    ["<Right click for Frame Settings>"] = "<Клацніть правою кнопкою для налаштувань рамки>",
    ["Dead"] = "Мертвий",
    ["Unconscious"] = "Непритомний",
    ["Join or Create Community"] = "Приєднатися до спільноти або створити її",
    ["Fishing"] = "Рибальство",
    ["First Aid"] = "Перша допомога",
    ["Magic"] = "Магія",
    ["Cooking"] = "Кулінарія",
    ["New Recipe Learned!"] = "Вивчено новий рецепт!",
    ["AddOn Usage"] = "Використання аддонів",
    ["Filter"] = "Фільтр",
    ["Load out of date AddOns"] = "Завантажувати застарілі аддони",
    ["Boss Frames"] = "Рамки босів",
    ["Completing this quest while in Party Sync may reward:"] = "За виконання цього завдання в синхронізованій групі можна отримати:",
    ["AddOn List"] = "Список аддонів",
    ["Find Treasure"] = "Пошук скарбів",
    ["Enable All"] = "Увімкнути всі",
    ["Disable All"] = "Вимкнути всі",
    ["First Profession"] = "Перша професія",
    ["Second Profession"] = "Друга професія",
    ["Snap to Elements"] = "Прив'язувати до елементів",
    ["Show Grid"] = "Показувати сітку",
    ["All Objectives"] = "Усі цілі",
    ["Show:"] = "Показувати:",
    ["Show Quest Levels"] = "Показувати рівні завдань",
    ["Quest Difficulty Color"] = "Колір складності завдань",
    ["Instance Entrances"] = "Входи до підземель",
    ["Low-Level Quests"] = "Завдання низького рівня",
    ["Tracked Items"] = "Відстежувані предмети",
    ["Items"] = "Предмети",
    ["Buffs and Debuffs"] = "Підсилення та послаблення",
    ["Guild"] = "Гільдія",
    ["Party Frames"] = "Рамки групи",
    ["Passive"] = "Пасивна",
    ["Cast Bar"] = "Смуга застосування",
    ["View all the appearance sets you can collect for your class here."] = "Тут можна переглянути всі комплекти вигляду, доступні для вашого класу.",
    ["Appearances"] = "Вигляд",
    ["Guild & Communities"] = "Гільдія та спільноти",
    ["Friendly"] = "Дружелюбність",
    ["Darnassus"] = "Дарнас",
    ["Gnomeregan Exiles"] = "Вигнанці Гномреґана",
    ["Ironforge"] = "Залізогарт",
    ["Stormwind"] = "Штормовій",
    ["At War"] = "У стані війни",
    ["Move to Inactive"] = "Перемістити до неактивних",
    ["Show as Experience Bar"] = "Показувати як смугу досвіду",
    ["Select a faction to view its details."] = "Виберіть фракцію, щоб переглянути подробиці.",
    ["The Alliance capital is populated by Night Elves and is located in the island of Teldrassil. Ruled by the Priestess of the Moon, Tyrande Whisperwind."] = "Столицю Альянсу населяють нічні ельфи. Вона розташована на острові Тельдрассіл і перебуває під владою жриці Місяця Тіранди Шелест Вітру.",
    ["Civilian"] = "Цивільний",
    ["Faction Tabard"] = "Фракційна накидка",
    ["Rewards may be purchased at the Champion's Hall in Stormwind."] = "Нагороди можна придбати в залі Героїв у Штормовії.",
    ["Each week, the Rank Points cap is increased, up to a maximum of |cnHIGHLIGHT_FONT_COLOR:24750 for |cnHIGHLIGHT_FONT_COLOR:Rank 14."] = "Щотижня ліміт очок рангу збільшується до максимуму |cnHIGHLIGHT_FONT_COLOR:24750 для |cnHIGHLIGHT_FONT_COLOR:14-го рангу.",
    ["Player vs. Player"] = "Гравець проти гравця",
    ["Dungeons & Raids"] = "Підземелля та рейди",
    ["Classic"] = "Класика",
    ["Select a currency to view its details."] = "Виберіть валюту, щоб переглянути подробиці.",
    ["No results found"] = "Нічого не знайдено",
    ["Target and Focus"] = "Ціль і фокус",
    ["Mace Specialization"] = "Спеціалізація на булавах",
    ["Dodge"] = "Ухилення",
    ["Requires Reload"] = "Потрібне перезавантаження",
    ["Racial Passive"] = "Расова пасивна здібність",
    ["Big Game Hunter"] = "Мисливець на велику дичину",
    ["Damage dealt versus Beasts increased by 5%."] = "Шкоду звірам збільшено на 5%.",
    ["Gives a chance to block enemy melee and ranged attacks."] = "Надає шанс блокувати ворожі атаки ближнього та дальнього бою.",
    ["Sell Price:"] = "Ціна продажу:",
    ["Press F6 to submit an issue for this Spell"] = "F6: повідомити про помилку",
    ["Press F6 to submit an issue for this Item"] = "F6: повідомити про помилку",
    ["Customer Support"] = "Підтримка користувачів",
    ["Armor Proficiency"] = "Володіння обладунками",
    ["Druid"] = "Друїд",
    ["Hunter"] = "Мисливець",
    ["Mage"] = "Маг",
    ["Paladin"] = "Паладин",
    ["Priest"] = "Жрець",
    ["Rogue"] = "Розбійник",
    ["Shaman"] = "Шаман",
    ["Save"] = "Зберегти",
    ["Equip"] = "Спорядити",
    ["New Set"] = "Новий комплект",
    ["General Macros"] = "Загальні макроси",
    ["Change Name/Icon"] = "Змінити назву/іконку",
    ["Enter Macro Commands:"] = "Введіть команди макросу:",
    ["Delete"] = "Видалити",
    ["New"] = "Створити",
    ["Exit"] = "Закрити",
    ["Layout:"] = "Макет:",
    ["Stoneform"] = "Кам'яна форма",
    ["Racial"] = "Расова",
    ["Click To Edit"] = "Клацніть, щоб редагувати",
    ["Block"] = "Блокування",
    ["HUD Edit Mode"] = "Режим редагування інтерфейсу",
    ["Search abilities, keywords"] = "Пошук здібностей і ключових слів",
    ["Spellbook"] = "Книга заклять",
    ["Revert All Changes"] = "Скасувати всі зміни",
    ["Professions"] = "Професії",
    ["Secondary Skills"] = "Другорядні навички",
    ["Group Finder"] = "Пошук групи",
    ["Smelting"] = "Переплавлення",
    ["Smelted Bars"] = "Виплавлені злитки",
    ["Everyday Meals"] = "Повсякденні страви",
    ["Stamina Food"] = "Їжа для витривалості",
    ["Strength Food"] = "Їжа для сили",
    ["Craft a Basic Campfire."] = "Створіть звичайне вогнище.",
    ["Smelt Copper"] = "Виплавити мідь",
    ["Weapon Stones"] = "Точильні камені",
    ["Mail Chestguards"] = "Кольчужні нагрудники",
    ["Mail Bracers"] = "Кольчужні наручі",
    ["Mail Legguards"] = "Кольчужні поножі",
    ["Inert Enchanting Rods"] = "Заготовки чарівних жезлів",
    ["Copper Bar"] = "Мідний злиток",
    ["Copper Ore"] = "Мідна руда",
    ["Forge"] = "Кузня",
    ["Requires: Forge"] = "Потрібно: кузня",
    ["This recipe requires you to be near a special crafting station. These can often be found in dungeons or in the open world."] = "Для цього рецепта потрібно перебувати біля спеціального ремісничого місця. Такі місця часто трапляються у підземеллях або у відкритому світі.",
    ["Reagents:"] = "Реагенти:",
    ["Track Recipe"] = "Відстежувати рецепт",
    ["Create All"] = "Створити все",
    ["Create"] = "Створити",
    ["Allows the miner to smelt a chunk of copper ore into a copper bar. Smelting copper requires a forge."] = "Дозволяє гірникові переплавити шматок мідної руди на мідний злиток. Для виплавки міді потрібна кузня.",
    ["Goodbye"] = "До побачення",
    ["Attack"] = "Атака",
    ["Coldridge Valley"] = "Морозна долина",
    ["Backpack"] = "Рюкзак",
    ["Bag Slots:"] = "Сумки:",
    ["<Click for Bag Settings>"] = "<Клацніть, щоб відкрити налаштування сумок>",
    ["Buyback"] = "Викуп",
    ["Combined Backpack"] = "Об'єднаний рюкзак",
    ["Merchant"] = "Торговець",
    ["Guild Master"] = "Розпорядник гільдії",
    ["Innkeeper"] = "Корчмар",
    ["Stable Master"] = "Доглядач стайні",
    ["The Ashbringer"] = "Спопелитель",
    ["Trade Goods"] = "Товари для ремесел",
    ["Next"] = "Далі",
    ["Prev"] = "Назад",
    ["Back"] = "Назад",
    ["Abandon"] = "Відмовитися",
    ["Share"] = "Поділитися",
    ["Track"] = "Відстежувати",
    ["Untrack"] = "Не відстежувати",
    ["Ah, well aren't you a sturdy-looking one? Perhaps you can assist me with a thing or two. Not much help around here except for green apprentices, and they've other things to worry about."] = "О, а ти міцний на вигляд, еге ж? Можливо, допоможеш мені з дечим. Тут небагато помічників, окрім зелених учнів, та й у них є про що турбуватися.",
    ["Visit a trainer to learn first aid. First aid lets you turn cloth into bandages for healing yourself and others."] = "Відвідайте вчителя, щоб опанувати першу допомогу. Вона дає змогу робити з тканини бинти для лікування себе та інших.",
    ["Visit a trainer to learn cooking. Cooking lets you learn recipes to create food that heals you out of combat and grants you temporary buffs."] = "Відвідайте вчителя, щоб опанувати кулінарію. Вона дає змогу готувати за рецептами їжу, яка відновлює здоров'я поза боєм і надає тимчасові підсилення.",
    ["Visit a trainer to learn fishing. Fishing lets you catch fish and other strange things from water. Fish can be cooked into delicious meals with the Cooking skill."] = "Відвідайте вчителя, щоб опанувати рибальство. Воно дає змогу ловити у воді рибу та інші дивні речі. За допомогою кулінарії з риби можна приготувати смачні страви.",
    ["Visit a profession trainer in a major city to learn a new profession. You may have two professions. You may have any combination of gathering and production professions."] = "Відвідайте вчителя професій у великому місті, щоб опанувати нову професію. Можна мати дві професії в будь-якому поєднанні збиральних і виробничих професій.",
    ["A guild is a tight-knit group of players who want to enjoy the game together. By joining a guild, you'll gain access to many benefits, including a shared guild bank and a guild chat channel.|n|nConsider forming a guild of your own if you have friends who also play World of Warcraft. To create a guild, talk to a Guild Master in a major city."] = "Гільдія — це згуртована спільнота гравців, які хочуть насолоджуватися грою разом. Приєднавшись до гільдії, ви отримаєте доступ до спільного банку гільдії, каналу гільдійного чату та інших переваг.|n|nЯкщо у вас є друзі, які також грають у World of Warcraft, можете створити власну гільдію. Для цього поговоріть із розпорядником гільдій у великому місті.",
    ["No quests available|n|nAccept quests by talking to characters with a |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t above their head."] = "Немає доступних завдань|n|nПриймайте завдання у персонажів зі знаком |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t над головою.",
}

local warrior_stances = {
    ["Battle Stance"] = "бойова стійка",
    ["Defensive Stance"] = "захисна стійка",
    ["Berserker Stance"] = "стійка берсерка",
}

local function translate_requirement(requirement)
    local skill, rank = requirement:match("^(.-) %((%d+)%)$")
    local name = skill or requirement
    local level = name:match("^Level (%d+)$")
    if level then return "Необхідний рівень " .. level end

    local translated = addonTable.forever_ui and addonTable.forever_ui[name]
        or addonTable.string and addonTable.string[name]
    if not translated then
        local entries = addonTable.use("entries")
        translated = entries.lookup_name("spell", name)
            or entries.lookup_name("item", name)
    end
    if not translated then return nil end
    return "Потрібно: " .. translated .. (rank and " (" .. rank .. ")" or "")
end

addonTable.forever_ui_patterns = {
    {
        pattern = "^Requires (.- Stance), (.- Stance)$",
        replace = function (first, second)
            if warrior_stances[first] and warrior_stances[second] then
                return "Потрібна одна зі стійок: " .. warrior_stances[first]
                    .. " або " .. warrior_stances[second]
            end
        end,
    },
    {
        pattern = "^Requires (.- Stance)$",
        replace = function (stance)
            if warrior_stances[stance] then
                return "Потрібна " .. warrior_stances[stance]
            end
        end,
    },
    {
        -- Blizzard has already formatted Requires %s (%d) before the tooltip
        -- is rendered. Resolve its visible skill/item name separately.
        pattern = "^Requires (.+)$",
        replace = translate_requirement,
    },
    {
        -- RequiredTools contains a clickable hyperlink around the station
        -- name. Translate only visible text and keep the link payload intact.
        pattern = "^Requires: (.-)Forge(.-)$",
        replace = function (before, after)
            return "Потрібно: " .. before .. "кузня" .. after
        end,
    },
    {
        pattern = "^Requires: (.+)$",
        replace = translate_requirement,
    },
    {
        pattern = "^Mining (%d+)/(%d+)$",
        replace = function (current, maximum)
            return "Гірництво " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^Create All %[(%d+)%]$",
        replace = function (count)
            return "Створити все [" .. count .. "]"
        end,
    },
    {
        pattern = "^Use: Restores ([%d,]+) mana over ([%d,]+) sec%. Must remain seated while drinking%.$",
        replace = function (mana, seconds)
            return "Використання: Відновлює " .. mana .. " мани протягом " .. seconds
                .. " с. Потрібно сидіти під час пиття."
        end,
    },
    {
        pattern = "^([%+%-]?%d+) Armor$",
        replace = function (value)
            return value .. " броні"
        end,
    },
    {
        pattern = "^(%d+) Block$",
        replace = function (value)
            return value .. " блокування"
        end,
    },
    {
        pattern = "^([%d%.]+) %- ([%d%.]+) Damage$",
        replace = function (minimum, maximum)
            return minimum .. "–" .. maximum .. " шкоди"
        end,
    },
    {
        pattern = "^Speed ([%d%.]+)$",
        replace = function (value)
            return "Швидкість " .. value
        end,
    },
    {
        pattern = "^%(([%d%.]+) damage per second%)$",
        replace = function (value)
            return "(" .. value .. " шкоди за секунду)"
        end,
    },
    {
        pattern = "^([%+%-]?[%d%.]+) damage per second$",
        replace = function (value)
            return value .. " шкоди за секунду"
        end,
    },
    {
        pattern = "^Durability (%d+) / (%d+)$",
        replace = function (current, maximum)
            return "Міцність " .. current .. " / " .. maximum
        end,
    },
    {
        -- The issue reporter includes an inline colour prefix in the actual
        -- FontString, so preserve that markup while translating its template.
        pattern = "^(.-)Press (.-) to submit an issue for this ([A-Za-z]+)(.-)$",
        replace = function (prefix, shortcut, issue_type, suffix)
            if issue_type ~= "Item" and issue_type ~= "Quest"
                and issue_type ~= "Spell" then
                return prefix .. "Press " .. shortcut .. " to submit an issue for this "
                    .. issue_type .. suffix
            end
            return prefix .. shortcut .. ": повідомити про помилку" .. suffix
        end,
    },
    {
        -- Preserve the client's coin textures and amounts after the label.
        pattern = "^Sell Price: (.+)$",
        replace = function (price)
            return "Ціна продажу: " .. price
        end,
    },
    {
        -- The character name is player data and must remain unchanged.
        pattern = "^(.+) Specific Macros$",
        replace = function (character)
            return "Макроси: " .. character
        end,
    },
    {
        pattern = "^(%d+)/(%d+) Characters Used$",
        replace = function (current, maximum)
            return "Використано символів: " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^Quests: (%d+)/(%d+)$",
        replace = function (current, maximum)
            return "Завдання: " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^XP: ([%d,]+)/([%d,]+)$",
        replace = function (current, maximum)
            return "Досвід: " .. current .. "/" .. maximum
        end,
    },
    {
        -- FRIENDS_LEVEL_TEMPLATE / UNIT_TYPE_LEVEL_TEMPLATE are formatted by
        -- Blizzard before the FontString is updated, so the exact client
        -- string "Level %d %s" can never match the visible value.
        pattern = "^Level (%d+) (.+)$",
        replace = function (level, class)
            local translated_class = addonTable.forever_ui[class] or class
            return "Рівень " .. level .. ": " .. translated_class
        end,
    },
    {
        -- Blizzard formats the level before the FontString is updated, so the
        -- exact client string with "%d" cannot match the visible tooltip.
        pattern = "^This feature becomes available at level (%d+)%.$",
        replace = function (level)
            return "Ця функція стає доступною на " .. level .. "-му рівні."
        end,
    },
    {
        pattern = "^Page (%d+)%s*/%s*(%d+)$",
        replace = function (current, maximum)
            return "Сторінка " .. current .. "/" .. maximum
        end,
    },
    {
        pattern = "^(%d+) seconds? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "секунд"
                or last == 1 and "секунда"
                or last >= 2 and last <= 4 and "секунди" or "секунд"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^(%d+) minutes? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "хвилин"
                or last == 1 and "хвилина"
                or last >= 2 and last <= 4 and "хвилини" or "хвилин"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^(%d+) hours? remaining$",
        replace = function (value)
            local number = tonumber(value) or 0
            local last_two, last = number % 100, number % 10
            local unit = last_two >= 11 and last_two <= 14 and "годин"
                or last == 1 and "година"
                or last >= 2 and last <= 4 and "години" or "годин"
            return "Залишилося " .. value .. " " .. unit
        end,
    },
    {
        pattern = "^Next Rewards at Rank (%d+)$",
        replace = function (rank) return "Наступні нагороди на " .. rank .. "-му ранзі" end,
    },
    {
        pattern = "^Rank Points: (.+)$",
        replace = function (value) return "Очки рангу: " .. value end,
    },
    {
        pattern = "^Season (%d+)$",
        replace = function (season) return "Сезон " .. season end,
    },
    {
        pattern = "^Season ends in: (.+)$",
        replace = function (remaining) return "До завершення сезону: " .. remaining end,
    },
    {
        pattern = "^Current CPU: (.+)$",
        replace = function (value) return "Поточне використання ЦП: " .. value end,
    },
    {
        pattern = "^Average CPU: (.+)$",
        replace = function (value) return "Середнє використання ЦП: " .. value end,
    },
    {
        pattern = "^Peak CPU: (.+)$",
        replace = function (value) return "Пікове використання ЦП: " .. value end,
    },
    {
        pattern = "^Collapse options (.+)$",
        replace = function (suffix) return "Згорнути параметри " .. suffix end,
    },
    {
        pattern = "^Player: ([%d%.]+), ([%d%.]+)$",
        replace = function (x, y) return "Гравець: " .. x .. ", " .. y end,
    },
    {
        pattern = "^Backpack %((.-)%)$",
        replace = function (binding) return "Рюкзак (" .. binding .. ")" end,
    },
    {
        pattern = "^(%d+) Empty Slots %(Total%)$",
        replace = function (count)
            local number = tonumber(count) or 0
            local last_two, last = number % 100, number % 10
            local slots = "вільних комірок"
            if last_two < 11 or last_two > 14 then
                if last == 1 then slots = "вільна комірка"
                elseif last >= 2 and last <= 4 then slots = "вільні комірки" end
            end
            return count .. " " .. slots .. " (усього)"
        end,
    },
    {
        pattern = "^(%d+) Empty Slots$",
        replace = function (count)
            local number = tonumber(count) or 0
            local last_two, last = number % 100, number % 10
            local slots = "вільних комірок"
            if last_two < 11 or last_two > 14 then
                if last == 1 then slots = "вільна комірка"
                elseif last >= 2 and last <= 4 then slots = "вільні комірки" end
            end
            return count .. " " .. slots
        end,
    },
    {
        -- Forever appends the current key binding to micro-menu tooltip titles,
        -- while ClassicUA stores the untranslated base label (for example,
        -- CHARACTER_INFO = "Character Info"). Translate the base and preserve
        -- whichever binding the player currently uses.
        pattern = "^(.-) %((.-)%)$",
        replace = function (label, binding)
            local translated = addonTable.string and addonTable.string[label]
                or addonTable.forever_ui and addonTable.forever_ui[label]
            if translated then return translated .. " (" .. binding .. ")" end
        end,
    },
}
