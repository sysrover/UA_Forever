local _, addonTable = ...

-- Forever/Camelot UI strings that are not present in the Classic Era table.
-- These are display-only replacements; global Blizzard string constants are
-- intentionally left untouched because Camelot also uses some as lookup keys.
local ui = {
    ["Fought Together"] = "Билися разом",
    ["A self-found character cannot do the following:\r\n- Trade with other players\r\n- Send mail to other players, or receive player mail\r\n- Buy or sell from the auction house\r\nThese restrictions can be removed at any time by talking to an in-game character, but it can never be applied outside of character creation."] = "Персонаж у режимі самостійного пошуку не може:\r\n- Торгувати з іншими гравцями\r\n- Надсилати листи іншим гравцям або отримувати листи від гравців\r\n- Купувати або продавати на аукціоні\r\nЦі обмеження можна зняти будь-коли, поговоривши з персонажем у грі, але ввімкнути їх можна лише під час створення персонажа.",
    ["Battle.net"] = "Battle.net",
    ["Played World of Warcraft before?"] = "Уже грали у World of Warcraft?",
    ["Skip Tutorial"] = "Пропустити навчання",
    ["Place %s back on your Action Bar to use it again."] = "Поверніть %s на панель команд, щоб знову ним користуватися.",
    ["Use |cFF00FFFFchat|r to ask questions. Find players to join you on quests, and get help from the community."] = "Використовуйте |cFF00FFFFчат|r, щоб ставити запитання. Знаходьте гравців для спільного виконання завдань і отримуйте допомогу від спільноти.",
    ["Right-click an enemy to |cFFFFD200target|r it."] = "Клацніть правою кнопкою миші по ворогу, щоб |cFFFFD200взяти його за ціль|r.",
    ["Press|cFF00FFFF %s|r to %s"] = "Натисніть|cFF00FFFF %s|r, щоб %s",
    ["Stable Slot Cost:"] = "Вартість комірки стайні:",
    ["You are currently in a Timewalking Campaign. Speak to Chromie to exit."] = "Зараз ви перебуваєте в кампанії «Мандрівка в часі». Поговоріть із Хромі, щоб вийти.",
    ["PvP Ranks are currently unavailable."] = "Наразі рейтинги PvP недоступні.",
    ["Your |cFFFFFFFFAttacks|r ignore %d of your enemies' |cFFFFFFFFArmor|r when attacking. Reducing an enemy's armor below 0 will increase your damage against them."] = "Ваші |cFFFFFFFFатаки|r ігнорують %d од. |cFFFFFFFFброні|r ворога. Зниження броні ворога нижче 0 збільшує завдану йому шкоду.",
    ["World refresh in %s %s"] = "Оновлення світу через %s %s",
    ["The world around you will refresh in %s %s. Make sure you are out of combat and in a safe area, or click here to refresh now."] = "Екран оновиться через %s %s. Переконайтеся, що ви не перебуваєте в бою і знаходитесь у безпечній зоні, або натисніть «Оновити зараз».",
    ["Please enter a full character name."] = "Будь ласка, введіть повне ім’я персонажа.",
    ["No valid channels to link. Make sure you have Manage Channels permission on the server."] = "Немає доступних каналів для підключення. Переконайтеся, що у вас є право «Керування каналами» на сервері.",
    ["This wick is still soulbound to its finder. Try again in a moment."] = "Цей гніт досі пов’язаний з тим, хто його знайшов. Спробуйте ще раз через хвилину.",
    ["When the stance action bar is displayed, the selected action bar will be temporarily replaced with it."] = "Коли з’являється панель дій «Поза», вона тимчасово замінить вибрану панель дій.",
    ["When the possess action bar is displayed, the selected action bar will be temporarily replaced with it."] = "Коли з’явиться панель дій «Possess», вона тимчасово замінить вибрану панель дій.",
    ["Reticle Aiming: While the Targeting Modifier is active, move the HUD reticle in the center of the screen over a unit to target it.\\n\\nAnalog Stick Aiming: While the Targeting Modifier is active, tilt the Right Stick toward a unit to target it."] = "Прицілювання за допомогою перехрестя: Поки активний модифікатор прицілювання, наведіть перехрестя на екрані в центрі екрана на одиницю, щоб вибрати її як ціль.\\n\\nНаведення за допомогою аналогового джойстика: коли модифікатор наведення активний, нахиліть правий джойстик у бік юніта, щоб навести на нього приціл.",
    ["Wait, don't pull"] = "Зачекай, не тягни",
    ["Purchase has failed: insufficient funds."] = "Покупка не вдалася, недостатньо коштів.",
    ["Says when a debuff is applied to you"] = "Повідомляє, коли на вас накладається дебаф",
    ["Combat Audio Alert Say Target's Casts Voice set to %s"] = "Повідомлення Combat Audio Alert: «Цілі передають голос», налаштовано на %s",
    ["Combat Audio Alerts are currently disabled. To enable them, type /<spell>tts</spell>combat"] = "Бойові звукові сповіщення наразі вимкнені. Щоб увімкнути їх, введіть  /<spell>tts</spell>бойові дії",
    ["No avoidable damage has been dealt. Avoidable damage tracking may not be available in all content."] = "Уникної шкоди не завдано. Відстеження уникної шкоди може бути доступне не в усьому контенті.",
    ["Increase your pet's loyalty and level to gain Training Points."] = "Підвищуйте відданість та рівень своїх улюбленців, щоб отримувати очки тренування.",
    ["This spell can only be cast in raid instances."] = "Це заклинання можна застосувати лише в рейдових інстансах.",
    ["For thousands of years, a band of high elven exiles has remained safe and hidden upon their flying sanctuary of Zephras Isle. These 'Skyborne', as they call themselves, shared a bond with air elementals who kept their island aloft in the realm of Skywall. But in recent years, the elementals vanished without a trace - disrupting the delicate magic that kept them safe in their haven amongst the clouds. Now, a new generation of Skyborne elves face a time of unprecedented change and must seek new allies and sources of magic - to protect their hidden home and secure their future..."] = "Протягом тисячоліть група вигнанців з числа високих ельфів перебувала в безпеці та укритті на своєму літаючому притулку — острові Зефрас. Ці «Небесні», як вони себе називають, були пов’язані узами з повітряними елементалями, які утримували їхній острів у повітрі в царстві Небесної стіни. Однак останніми роками елементалі зникли безслідно, порушивши тендітну магію, яка забезпечувала їм безпеку в їхньому притулку серед хмар. Тепер нове покоління ельфів «Небесних» стикається з періодом безпрецедентних змін і мусить шукати нових союзників та джерел магії, щоб захистити свою приховану батьківщину та забезпечити своє майбутнє...",
    ["|Hplayer:%s|h[%s]|h has been slain in a duel by %s in %s! They were level %d"] = "|Hplayer:%s|h[%s]|h був убитий на дуелі %s в %sВони були на одному рівні! %d",
    ["Welcome to WoW Classic Hardcore Realms. Any character that dies on a Hardcore realm can never resurrect on that realm for ANY reason. Customer Support cannot resurrect a dead Hardcore character.|n|nBy agreeing to play on these realms, you accept that your character's death is permanent for whatever reason. This includes disconnections, lag, server outages, gameplay bugs, or any other reason. Dying due to consensual PvP activity--such as a Duel to the Death or deliberately PvP flagging--is part of the game.|n|n"] = "Ласкаво просимо до серверів WoW Classic у режимі «Хардкор». Будь-який персонаж, який загине на сервері в режимі «Хардкор», ніколи не зможе бути відроджений на цьому сервері з ЖОДНОЇ причини. Служба підтримки не може відродити загиблого персонажа в режимі «Хардкор».|n|nПогоджуючись грати на цих серверах, ви визнаєте, що смерть вашого персонажа є остаточною незалежно від причини. Сюди входять розриви з’єднання, затримки, збої сервера, ігрові помилки або будь-які інші причини. Смерть внаслідок взаємної PvP-активності — наприклад, у «Дуелі на смерть» або при навмисному ввімкненні PvP-режиму — є частиною гри.|n|n",
    ["|cffffffffDeath is permanent|r|n|n|cffffd200Hold, adventurer. The realm you are selecting is a HARDCORE realm. If you choose to play on this realm, character death is permanent.|r|n|n|cffffffffCustomer Support will not restore fallen hardcore characters for any reason."] = "|cffffffffСмерть є постійною|r|n|n|cffffd200Зачекай, шукачу пригод. Вибраний тобою світ — це ХАРДКОР. Якщо ти вирішиш грати на цьому світі, смерть персонажа буде остаточною.|r|n|n|cffffffffСлужба підтримки клієнтів не відновлюватиме втрачених хардкорних персонажів з жодної причини.",
    ["Increases the healing of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Healing|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Healing\\n\\nSpell ranks far below your current level benefit less from Spell Healing and trigger class abilities less often|r"] = "Збільшує зцілення ваших |cFFFFFFFFзаклять|r до %d.\n\nЗбільшується від |cFFFFFFFFзцілення закляттями|r і |cFFFFFFFFсили заклять|r.\n\n|cffBCBCBCЗакляття з довшим часом вимовляння зазвичай отримують більшу користь від зцілення закляттями.\n\nРанги заклять, значно нижчі за ваш поточний рівень, отримують меншу користь від зцілення закляттями й рідше запускають класові здібності|r",
    ["Increases the damage of your |cFFFFFFFFSpells|r by up to %d\\n\\nIncreased by |cFFFFFFFFSpell Damage|r and |cFFFFFFFFSpell Power|r\\n\\n|cffBCBCBCLonger cast times typically benefit more from Spell Damage\\n\\nSpell ranks far below your current level benefit less from Spell Damage and trigger class abilities less often|r"] = "Збільшує шкоду ваших |cFFFFFFFFзаклять|r до %d.\n\nЗбільшується від |cFFFFFFFFшкоди від заклять|r і |cFFFFFFFFсили заклять|r.\n\n|cffBCBCBCЗакляття з довшим часом вимовляння зазвичай отримують більшу користь від шкоди від заклять.\n\nРанги заклять, значно нижчі за ваш поточний рівень, отримують меншу користь від шкоди від заклять і рідше запускають класові здібності|r",
    -- Chat channels use WoW group and guild terminology, not the literal
    -- meanings of "party", "officer", or "say" from the generated catalog.
    ["Say"] = "Сказати",
    ["Emote"] = "Емоції",
    ["Officer Chat"] = "Чат офіцерів",
    ["Blizzard Whispers"] = "Приватні повідомлення Battle.net",
    ["Party"] = "Група",
    ["Party Leader"] = "Лідер групи",
    ["Follow"] = "Слідувати",
    ["Raid Leader"] = "Лідер рейду",
    ["Raid Warning"] = "Попередження рейду",
    ["Instance"] = "Група підземелля",
    ["Instance Leader"] = "Лідер групи підземелля",
    ["Guild Config"] = "Налаштування чату гільдії",
    ["Main Hand"] = "Основна рука",
    ["Off Hand"] = "Друга рука",
    ["Ranged"] = "Дальній бій",
    ["Ranged:"] = "Дальній бій:",
    ["Honor Points"] = "очки честі",
    ["Attack Speed (seconds)"] = "Швидкість атаки (с)",
    ["Channeling"] = "Підтримування",
    ["Damage:"] = "Шкода:",
    ["DPS:"] = "Шкода/с:",
    ["Instantly removes and grants immunity to all Bleed, Poison, and Disease effects, and reduces all Physical damage taken by 10% for 8 sec."] = "Миттєво знімає всі ефекти кровотечі, отрути та хвороб і дає до них невразливість, а також зменшує всю отримувану фізичну шкоду на 10% протягом 8 с.",
    ["Allows the dwarf to sense nearby treasure, making it appear on the minimap.  Lasts until canceled."] = "Дозволяє дворфу відчувати скарби поблизу й бачити їх на мінімапі. Триває до скасування.",
    ["Blasts nearby enemies, increasing the time between their attacks by 20% for 10 sec and doing 10 damage to them. Will affect up to 4 targets."] = "Вражає ворогів поблизу, збільшуючи інтервал між їхніми атаками на 20% протягом 10 с і завдаючи їм 10 шкоди. Діє не більше ніж на 4 цілі.",
    ["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 10.  Lasts 3 min."] = "Воїн вигукує бойовий клич, збільшуючи силу атаки ближнього бою всіх учасників групи в межах 20 м на 10. Триває 3 хв.",
    ["Wounds the target causing them to bleed for 15 damage over 9 sec."] = "Ранить ціль, завдаючи їй 15 шкоди від кровотечі протягом 9 с.",
    ["A strong attack that increases melee damage by 11 and causes a high amount of threat."] = "Сильна атака, що збільшує шкоду ближнього бою на 11 і створює багато загрози.",
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
    ["Find Huldar, Miran, and Saean (Complete)"] = "Знайдіть Хульдара, Мірана та Саеана (виконано)",
    ["<Click to view Quest Details>"] = "<Натисніть, щоб переглянути деталі завдання>",
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
    ["Do you want to make Thunderbrew Distillery your new home?"] = "Хочете зробити винокурню Громовара своїм новим домом?",
    ["By disabling transmogrification you will no longer see any appearances applied to other players' gear via transmogrification. You will only see the equipment other players actually have equipped. Are you sure you wish to disable transmogrification? You may re-enable this at any time by speaking with me again."] =
        "Після вимкнення трансмогрифікації ви більше не бачитимете вигляди, застосовані до спорядження інших гравців. Ви бачитимете лише спорядження, яке вони насправді носять.\n\nВи впевнені, що хочете вимкнути трансмогрифікацію?\n\nВи можете будь-коли ввімкнути її знову, поговоривши зі мною.",
    ["Close"] = "Закрити",
    ["Description"] = "Опис",
    ["DESCRIPTION"] = "ОПИС",
    ["Required Items:"] = "Потрібні предмети:",
    ["Quest Log"] = "Журнал завдань",
    ["Quest Timers"] = "Таймери завдань",
    ["Quests"] = "Завдання",
    ["Stormwind Auction House"] = "Аукціонний дім Штормовію",
    ["Alliance Auction House"] = "Аукціонний дім Альянсу",
    ["Soul Bag"] = "Сумка душ",
    ["(Elite)"] = "(Еліта)",
    ["Craft a Reagent Bot."] = "Створює реагентного бота.",
    ["Use: Summons a Reagent Bot that allows you and others nearby to purchase reagents. Requires a Campfire nearby. All camping features share a cooldown of 1 hour."] =
        "Використання: викликає реагентного бота, у якого ви та інші гравці поблизу можете придбати реагенти. Потрібне багаття поруч. Усі можливості таборування мають спільну перезарядку тривалістю 1 год.",
    ["Game Menu"] = "Меню гри",
    ["Open All"] = "Відкрити все",
    ["Account Collections"] = "Колекції облікового запису",
    ["Spellbook & Professions"] = "Книга заклять і професії",
    ["Talents"] = "Таланти",
    ["Arms"] = "Зброя",
    ["Fury"] = "Шаленство",
    ["Protection"] = "Захист",
    ["Unspent Talents"] = "Вільні очки",
    ["Apply Changes"] = "Застосувати зміни",
    ["Achievements"] = "Досягнення",
    ["Explore Dun Morogh"] = "Дослідіти Дун-Морог",
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
    -- Character statistics: progression and wealth.
    ["Talent tree respecs"] = "Зміни спеціалізації талантів",
    ["Wealth"] = "Статки",
    ["Total gold acquired"] = "Усього отримано золота",
    ["Average gold earned per day"] = "Середній заробіток за день",
    ["Gold looted"] = "Золото зі здобичі",
    ["Gold from quest rewards"] = "Золото за завдання",
    ["Gold earned from auctions"] = "Золото з аукціонів",
    ["Auctions posted"] = "Виставлено на аукціон",
    ["Auction purchases"] = "Покупки на аукціоні",
    ["Most expensive bid on auction"] = "Найвища ставка на аукціоні",
    ["Most expensive auction sold"] = "Найдорожчий продаж на аукціоні",
    ["Gold from vendors"] = "Золото від торговців",
    ["Gold spent on travel"] = "Витрачено на подорожі",
    ["Gold spent at barber shops"] = "Витрачено в перукарнях",
    ["Most gold ever owned"] = "Найбільше золота у власності",
    ["Gold spent on postage"] = "Витрачено на пошту",
    ["Gold spent on talent tree respecs"] = "Витрачено на зміну талантів",

    -- Statistics: quests, deaths, combat, and character progression.
    ["Quests abandoned"] = "Покинуто завдань",
    ["Average quests completed per day"] = "Середня кількість завдань за день",
    ["Quests completed"] = "Виконано завдань",
    ["Total deaths"] = "Усього смертей",
    ["Deaths in Warsong Gulch"] = "Смертей у Тіснині Пісні Війни",
    ["Deaths in Alterac Valley"] = "Смертей в Альтерацькій долині",
    ["Deaths from Drek'Thar"] = "Смертей від Дрек'Тара",
    ["Deaths in Arathi Basin"] = "Смертей у низині Араті",
    ["Deaths from Vanndar Stormpike"] = "Смертей від Вандара Громового Списа",
    ["Deaths from Hogger"] = "Смертей від Хоггера",
    ["Deaths from drowning"] = "Смертей від утоплення",
    ["Deaths from fatigue"] = "Смертей від виснаження",
    ["Deaths from falling"] = "Смертей від падіння",
    ["Deaths from fire and lava"] = "Смертей від вогню й лави",
    ["Total deaths from opposite faction"] = "Смертей від ворожої фракції",
    ["Total deaths from other players"] = "Смертей від інших гравців",
    ["Total raid and dungeon deaths"] = "Смертей у рейдах і підземеллях",
    ["Total deaths in 5-player dungeons"] = "Смертей у підземеллях на 5 гравців",
    ["Total deaths in 10-player raids"] = "Смертей у рейдах на 10 гравців",
    ["Total deaths in 20-player raids"] = "Смертей у рейдах на 20 гравців",
    ["Total deaths in 40-player raids"] = "Смертей у рейдах на 40 гравців",
    ["Deaths in Darkspear Islands"] = "Смертей на островах Темного Списа",
    ["Largest heal cast"] = "Найбільше застосоване зцілення",
    ["Largest heal received"] = "Найбільше отримане зцілення",
    ["Largest hit dealt"] = "Найсильніший завданий удар",
    ["Largest hit received"] = "Найсильніший отриманий удар",
    ["Total damage done"] = "Усього завдано шкоди",
    ["Total damage received"] = "Усього отримано шкоди",
    ["Total healing done"] = "Усього зцілено",
    ["Total healing received"] = "Усього отримано зцілення",
    ["Total kills"] = "Усього вбивств",
    ["Total kills that grant experience or honor"] = "Вбивств із досвідом або честю",
    ["Creatures killed"] = "Вбито істот",
    ["Critters killed"] = "Вбито дрібних звірят",
    ["Creature type killed the most"] = "Найчастіше вбитий тип істот",
    ["Different creature types killed"] = "Вбито різних типів істот",
    ["Professions learned"] = "Вивчено професій",
    ["Professions at maximum skill"] = "Професій із максимальною навичкою",
    ["Secondary skills at maximum skill"] = "Другорядних навичок на максимумі",
    ["Weapon skills at maximum skill"] = "Збройових навичок на максимумі",

    -- Statistics: equipment, consumables, travel, and social actions.
    ["Legendary items acquired"] = "Отримано легендарних предметів",
    ["Vanity pets owned"] = "Колекційних улюбленців",
    ["Mounts owned"] = "Верхових тварин",
    ["Epic items looted"] = "Здобуто епічних предметів",
    ["Epic items acquired"] = "Отримано епічних предметів",
    ["Equipped epic items in item slots"] = "Споряджено епічних предметів",
    ["Extra bank slots purchased"] = "Придбано комірок банку",
    ["Greed rolls made on loot"] = "Кидків «Не відмовлюся» за здобич",
    ["Need rolls made on loot"] = "Кидків «Потрібно» за здобич",
    ["Bandages used"] = "Використано бинтів",
    ["Bandage used most"] = "Найчастіше використаний бинт",
    ["Health potions consumed"] = "Випито зіль здоров'я",
    ["Mana potions consumed"] = "Випито зіль мани",
    ["Beverages consumed"] = "Випито напоїв",
    ["Food eaten"] = "З'їдено їжі",
    ["Flasks consumed"] = "Випито настоїв",
    ["Elixirs consumed"] = "Випито еліксирів",
    ["Healthstones used"] = "Використано каменів здоров'я",
    ["Flight paths taken"] = "Польотів повітряними шляхами",
    ["Mage Portals taken"] = "Подорожей порталами магів",
    ["Mage portal taken most"] = "Найчастіше використаний портал",
    ["Number of times hearthed"] = "Використано камінь повернення",
    ["Summons accepted"] = "Прийнято закликів",
    ["Total 5-player dungeons entered"] = "Відвідано підземель на 5 гравців",
    ["Total 10-player raids entered"] = "Відвідано рейдів на 10 гравців",
    ["Total 20-player raids entered"] = "Відвідано рейдів на 20 гравців",
    ["Total 40-player raids entered"] = "Відвідано рейдів на 40 гравців",
    ["Number of hugs"] = "Усього обіймів",
    ["Total cheers"] = "Усього вигуків підтримки",
    ["Total facepalms"] = "Усього жестів «Рука до обличчя»",
    ["Total waves"] = "Усього привітань рукою",
    ["Total times LOL'd"] = "Усього сміху вголос",
    ["Total times playing world's smallest violin"] = "Виконань на найменшій скрипці",

    -- Statistics: reputation, resurrection, and player-versus-player combat.
    ["Most factions at Exalted"] = "Найбільше фракцій із піднесенням",
    ["Most factions at Revered or higher"] = "Найбільше фракцій із шаною чи вище",
    ["Most factions at Honored or higher"] = "Найбільше фракцій із повагою чи вище",
    ["Most Horde factions at Exalted"] = "Найбільше фракцій Орди з піднесенням",
    ["Most Alliance factions at Exalted"] = "Найбільше фракцій Альянсу з піднесенням",
    ["Total factions encountered"] = "Усього зустрінуто фракцій",
    ["Resurrected by priests"] = "Воскрешено жерцями",
    ["Rebirthed by druids"] = "Відроджено друїдами",
    ["Revived by druids"] = "Оживлено друїдами",
    ["Spirit returned to body by shamans"] = "Дух повернено шаманами",
    ["Redeemed by paladins"] = "Воскрешено паладинами",
    ["Resurrected by soulstones"] = "Воскрешено каменями душі",
    ["Duels won"] = "Перемог у двобоях",
    ["Duels lost"] = "Поразок у двобоях",
    ["Alterac Valley victories"] = "Перемог в Альтерацькій долині",
    ["Arathi Basin victories"] = "Перемог у низині Араті",
    ["Warsong Gulch victories"] = "Перемог у Тіснині Пісні Війни",
    ["Darkspear Island victories"] = "Перемог на островах Темного Списа",
    ["Warsong Gulch battles"] = "Боїв у Тіснині Пісні Війни",
    ["Alterac Valley battles"] = "Боїв в Альтерацькій долині",
    ["Arathi Basin battles"] = "Боїв у низині Араті",
    ["Darkspear Islands battles"] = "Боїв на островах Темного Списа",
    ["Battlegrounds played"] = "Зіграно боїв на полях бою",
    ["Battlegrounds won"] = "Перемог на полях бою",
    ["Battleground played the most"] = "Найчастіше поле бою",
    ["Battleground won the most"] = "Найбільше перемог на полі бою",
    ["Alterac Valley towers defended"] = "Захищено веж в Альтерацькій долині",
    ["Alterac Valley towers captured"] = "Захоплено веж в Альтерацькій долині",
    ["Warsong Gulch flags captured"] = "Захоплено прапорів у Тіснині Пісні Війни",
    ["Warsong Gulch flags returned"] = "Повернено прапорів у Тіснині Пісні Війни",
    ["Total Honorable Kills"] = "Усього почесних убивств",
    ["World Honorable Kills"] = "Почесних убивств у світі",
    ["Battleground Honorable Kills"] = "Почесних убивств на полях бою",
    ["Alterac Valley Honorable Kills"] = "Почесних убивств в Альтерацькій долині",
    ["Arathi Basin Honorable Kills"] = "Почесних убивств у низині Араті",
    ["Warsong Gulch Honorable Kills"] = "Почесних убивств у Тіснині Пісні Війни",
    ["Darkspear Islands Honorable Kills"] = "Почесних убивств на островах Темного Списа",
    ["Continent with the most Honorable Kills"] = "Континент із найбільшою кількістю почесних убивств",
    ["Battleground with the most Honorable Kills"] = "Поле бою з найбільшою кількістю почесних убивств",
    ["Total Killing Blows"] = "Усього добивань",
    ["World Killing Blows"] = "Добивань у світі",
    ["Battleground Killing Blows"] = "Добивань на полях бою",
    ["Alterac Valley Killing Blows"] = "Добивань в Альтерацькій долині",
    ["Arathi Basin Killing Blows"] = "Добивань у низині Араті",
    ["Warsong Gulch Killing Blows"] = "Добивань у Тіснині Пісні Війни",
    ["Darkspear Island Killing Blows"] = "Добивань на островах Темного Списа",
    ["Continent with the most Killing Blows"] = "Континент із найбільшою кількістю добивань",
    ["Battleground with the most Killing Blows"] = "Поле бою з найбільшою кількістю добивань",

    -- Statistics: professions and secondary skills.
    ["Highest Alchemy skill"] = "Найвища навичка алхімії",
    ["Highest Blacksmithing skill"] = "Найвища навичка ковальства",
    ["Highest Enchanting skill"] = "Найвища навичка зачарування",
    ["Highest Leatherworking skill"] = "Найвища навичка шкірництва",
    ["Highest Mining skill"] = "Найвища навичка гірництва",
    ["Highest Herbalism skill"] = "Найвища навичка травництва",
    ["Highest Inscription skill"] = "Найвища навичка гравіювання",
    ["Highest Skinning skill"] = "Найвища навичка зняття шкур",
    ["Highest Tailoring skill"] = "Найвища навичка кравецтва",
    ["Highest Engineering skill"] = "Найвища навичка інженерії",
    ["Enchanting formulae learned"] = "Вивчено формул зачарування",
    ["Items disenchanted"] = "Розчаровано предметів",
    ["Materials produced from disenchanting"] = "Отримано матеріалів розчаруванням",
    ["Alchemy Recipes learned"] = "Вивчено рецептів алхімії",
    ["Blacksmithing Plans learned"] = "Вивчено ковальських креслень",
    ["Engineering Schematics learned"] = "Вивчено інженерних схем",
    ["Inscriptions learned"] = "Вивчено написів",
    ["Leatherworking Patterns learned"] = "Вивчено шкірницьких викрійок",
    ["Tailoring Patterns learned"] = "Вивчено кравецьких викрійок",
    ["Smelting Recipes learned"] = "Вивчено рецептів переплавлення",
    ["First Aid skill"] = "Навичка першої допомоги",
    ["Fishing skill"] = "Навичка рибальства",
    ["Cooking skill"] = "Навичка кулінарії",
    ["Fish caught"] = "Виловлено риби",
    ["Fish and other things caught"] = "Виловлено риби та інших речей",
    ["Cooking daily quests completed"] = "Виконано щоденних завдань кулінарії",
    ["Fishing daily quests completed"] = "Виконано щоденних завдань рибальства",
    ["Cooking Recipes known"] = "Відомо рецептів кулінарії",
    ["First Aid Manuals learned"] = "Вивчено посібників із першої допомоги",
    ["Dalaran Cooking Awards gained"] = "Отримано кулінарних нагород Даларана",

    -- Statistics category headings.
    ["Boss Kills"] = "Убивства босів",
    ["Dungeons and Raids"] = "Підземелля та рейди",
    ["Gear"] = "Спорядження",
    ["Creatures"] = "Істоти",
    ["Resurrection"] = "Воскресіння",

    -- Statistics: boss kill counters, using the addon NPC name forms.
    ["Archmage Arugal kills (Shadowfang Keep)"] = "Убивств архімага Аруґала (Фортеця Тіньового Ікла)",
    ["Scarlet Commander Mograine kills (Scarlet Monastery)"] = "Убивств командира Багряного Походу Моґрейна (Багряний монастир)",
    ["Chief Ukorz Sandscalp kills (Zul'Farrak)"] = "Убивств вождя Укорза Піщаного Скальпа (Зул'Фаррак)",
    ["Emperor Dagran Thaurissan kills (Blackrock Depths)"] = "Убивств імператора Даґрана Тауріссана (Чорноскельні надра)",
    ["General Drakkisath kills (Upper Blackrock Spire)"] = "Убивств генерала Драккісата (Верхня частина Чорноскельного шпиля)",
    ["Baron Rivendare kills (Stratholme)"] = "Убивств барона Рівендера (Стратгольм)",
    ["Onyxia kills (Onyxia's Lair)"] = "Убивств Оніксії (Лігво Оніксії)",
    ["Aku'mai kills (Blackfathom Deeps)"] = "Убивств Аку'май (Чорноводні глибини)",
    ["Charlga Razorflank kills (Razorfen Kraul)"] = "Убивств Чарлґи Бритвобокої (крааль Бритвоболотих)",
    ["Mekgineer Thermaplugg kills (Gnomeregan)"] = "Убивств механженера Термоплуґа (Гномреґан)",
    ["Amnennar the Coldbringer kills (Razorfen Downs)"] = "Убивств Амненнара Стужевія (нори Бритвоболотих)",
    ["Archaedas kills (Uldaman)"] = "Убивств Аркедаса (Ульдаман)",
    ["Princess Theradras kills (Maraudon)"] = "Убивств принцеси Терадрас (Мародон)",
    ["Shade of Eranikus kills (Sunken Temple)"] = "Убивств тіні Еранікуса (Затонулий храм)",
    ["Overlord Wyrmthalak kills (Lower Blackrock Spire)"] = "Убивств повелителя Вірмталака (Нижня частина Чорноскельного шпиля)",
    ["King Gordok kills (Dire Maul)"] = "Убивств короля Ґордока (Грізний Молот)",
    ["High Inquisitor Whitemane kills (Scarlet Monastery)"] = "Убивств верховної інквізиторки Білогривої (Багряний монастир)",
    ["Bazzalan kills (Ragefire Chasm)"] = "Убивств Баззалана (прірва Лютого Полум'я)",
    ["Mutanus the Devourer kills (Wailing Caverns)"] = "Убивств Мутануса-Пожирача (Плачучі печери)",
    ["Bazil Thredd kills (Stormwind Stockade)"] = "Убивств Базіла Тредда (Штормовійська в'язниця)",
    ["Darkmaster Gandling kills (Scholomance)"] = "Убивств темного магістра Ґандлінґа (Некроситет)",
    ["Edwin Vancleef Kills (Deadmines)"] = "Убивств Едвіна ван Кліфа (Мертві копальні)",
    ["Rath'mael Kills (Ruins of Lordaeron)"] = "Убивств Рат'маеля (Руїни Лордерона)",
    ["Shade of the Archmage Kills (City of Dalaran)"] = "Убивств тіні архімага (місто Даларан)",
    ["Durgen Dirgehammer Kills (Hall of Thanes)"] = "Убивств Дурґена Жалобомолота (Зала Танів)",
    ["Nanaya Kills (Shaper's Terrace)"] = "Убивств Нанаї (Тераса Творця)",
    ["Blazeroar Kills (Alcaz Prison)"] = "Убивств Полум'яного Ревуна (В'язниця Алькац)",
    ["The Wild King kills (Hyjal Summit)"] = "Убивств Дикого Короля (Вершина Гіджалу)",
    ["Sonya Darkhallow Kills (Barrow Deeps)"] = "Убивств Соні Темнолощинної (Курганні глибини)",
    ["Lyn the Ignored Kills (City of Dalaran)"] = "Убивств Лін Знехтуваної (місто Даларан)",
    ["Cinder Kills (Shaper's Terrace)"] = "Убивств Попелу (Тераса Творця)",
    ["Bolt Kills (Shaper's Terrace)"] = "Убивств Блискавки (Тераса Творця)",
    ["Snowtalon Kills (Shaper's Terrace)"] = "Убивств Снігокігтя (Тераса Творця)",
    ["Primary Attributes"] = "Основні характеристики",
    ["Weapons"] = "Зброя",
    ["Gun"] = "Рушниця",
    ["Health:"] = "Здоров'я:",
    ["Rage:"] = "Лють:",
    ["Energy:"] = "Енергія:",
    ["Focus:"] = "Зосередження:",
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
    ["Off Hand:"] = "Друга рука:",
    ["Modifiers"] = "Модифікатори",
    ["Hit Chance:"] = "Шанс влучання:",
    ["Haste:"] = "Швидкість:",
    ["Expertise:"] = "Вправність:",
    ["Armor Piercing:"] = "Пробивання броні:",
    ["Spell Damage:"] = "Шкода від заклять:",
    ["Spell Healing:"] = "Зцілення закляттями:",
    ["Spell Piercing:"] = "Проникнення заклять:",
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
    ["Parry"] = "Парирування",
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
    ["Soulbound"] = "Прив’язано до персонажа",
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
    -- Add Community is a separate secure dialog with text outside CommunitiesFrame.
    ["Add Community"] = "Додати спільноту",
    ["Create World of Warcraft Community (Alliance or Cross-Faction)"] =
        "Створити спільноту World of Warcraft (Альянс або міжфракційну)",
    ["Create World of Warcraft Community (Horde or Cross-Faction)"] =
        "Створити спільноту World of Warcraft (Орда або міжфракційну)",
    ["Create World of Warcraft Community"] = "Створити спільноту World of Warcraft",
    ["- Great for in-game friends|n- Invite characters from any realm|n- Calendar and Quick Join support"] =
        "- Для друзів у грі|n- Запрошуйте персонажів із будь-якого ігрового світу|n- Підтримка календаря та швидкого приєднання",
    ["- Great for in-game friends\n- Invite characters from any realm\n- Calendar and Quick Join support"] =
        "- Для друзів у грі\n- Запрошуйте персонажів із будь-якого ігрового світу\n- Підтримка календаря та швидкого приєднання",
    ["Create Blizzard Group"] = "Створити групу Blizzard",
    ["- Great for cross-game friends|n- Invite any player (members join as their BattleTag)"] =
        "- Для друзів із різних ігор|n- Запрошуйте будь-яких гравців (учасники приєднуються за BattleTag)",
    ["- Great for cross-game friends\n- Invite any player (members join as their BattleTag)"] =
        "- Для друзів із різних ігор\n- Запрошуйте будь-яких гравців (учасники приєднуються за BattleTag)",
    ["Join Community"] = "Приєднатися до спільноти",
    ["Enter a community's invitation link or code:"] =
        "Введіть посилання або код запрошення до спільноти:",
    ["Join"] = "Приєднатися",
    ["Fishing"] = "Рибальство",
    ["First Aid"] = "Перша допомога",
    ["Bandages"] = "Бинти",
    ["Healing Potions"] = "Лікувальні зілля",
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
    ["Miss"] = "Промах",
    ["Evade"] = "Уникнення",
    ["Immune"] = "Несприйнятливість",
    ["Resist"] = "Опір",
    ["Absorb"] = "Поглинання",
    ["Deflect"] = "Відбиття",
    ["Reflect"] = "Віддзеркалення",
    ["Requires Reload"] = "Потрібне перезавантаження",
    ["Racial Passive"] = "Расова пасивна здібність",
    ["Big Game Hunter"] = "Мисливець на велику дичину",
    ["Damage dealt versus Beasts increased by 5%."] = "Шкоду звірам збільшено на 5%.",
    ["Gives a chance to block enemy melee and ranged attacks."] = "Надає шанс блокувати ворожі атаки ближнього та дальнього бою.",
    ["Sell Price:"] = "Ціна продажу:",
    ["Materials"] = "Матеріали",
    ["Materials:"] = "Матеріали:",
    ["Mining pick"] = "Шахтарське кайло",
    ["Mining Pick"] = "Шахтарське кайло",
    ["Press F6 to submit an issue for this Spell"] = "F6: повідомити про помилку",
    ["You retain up to 10 Rage when you change Stances."] = "Ви зберігаєте до 10 люті при зміні стійки.",
    ["Slams the opponent, causing weapon damage plus 16."] = "Трощить ворога, завдаючи шкоди зброєю плюс 16.",
    ["Next melee"] = "Наступна атака ближнього бою",
    ["Tools: Mining Pick"] = "Інструменти: шахтарське кайло",
    ["Tools: Blacksmith Hammer"] = "Інструменти: ковальський молот",
    ["Reagents:\nCopper Bar (4)"] = "Реагенти:\nМідний злиток (4)",
    ["Reagents:\nCopper Bar (6), Weak Flux, Linen Cloth (2)"] = "Реагенти:\nМідний злиток (6), слабкий флюс, лляна тканина (2)",
    ["+1 Stamina"] = "+1 до витривалості",
    ["+1 Frost Resistance"] = "+1 до опору кризі",
    ["17 Health"] = "17 здоров'я",
    ["Bow"] = "Лук",
    ["Sword"] = "Меч",
    ["Quest Item"] = "Предмет завдання",
    ["+1 Shadow Resistance"] = "+1 до опору тіні",
    ["A strong attack that increases melee damage by 21 and causes a high amount of threat."] = "Сильна атака, що збільшує шкоду ближнього бою на 21 і створює багато загрози.",
    ["The warrior shouts, increasing the melee attack power of all party members within 20 yards by 11.  Lasts 3 min."] = "Воїн вигукує бойовий клич, збільшуючи силу атаки ближнього бою всіх учасників групи в межах 20 м на 11. Триває 3 хв.",
    ["You haven't added this to your action bars"] = "Ви ще не додали цю здібність на панелі дій",
    ["You are no longer rested."] = "Ви більше не відпочиваєте.",
    ["Rested"] = "Відпочинок",
    ["200% of normal experience gained from monsters."] = "200% звичайного досвіду за вбивство монстрів.",
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
    ["Search Name, Guilds, Levels"] = "Ім'я, гільдія, рівень",
    ["Quests & Zones"] = "Завдання та зони",
    ["Show All Level Ranges"] = "Показувати всі рівні",
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
    ["Mail Gauntlets"] = "Кольчужні рукавиці",
    ["Mail Belts"] = "Кольчужні пояси",
    ["Mail Boots"] = "Кольчужні чоботи",
    ["Inert Enchanting Rods"] = "Заготовки чарівних жезлів",
    ["Copper Bar"] = "Мідний злиток",
    ["Copper Ore"] = "Мідна руда",
    ["Forge"] = "Кузня",
    ["Requires: Forge"] = "Потрібно: кузня",
    ["This recipe requires you to be near a special crafting station. These can often be found in dungeons or in the open world."] = "Для цього рецепта потрібно перебувати біля спеціального ремісничого місця. Такі місця часто трапляються у підземеллях або у відкритому світі.",
    ["Reagents:"] = "Реагенти:",
    ["Reagents:\nWhite Spider Meat (2)"] = "Реагенти:\nБіле м'ясо павука (2)",
    ["Reagents:\nStringy Wolf Meat, Mild Spices"] = "Реагенти:\nЖилаве м'ясо вовка, лагідні спеції",
    ["Reagents:\nCrawler Meat, Mild Spices"] = "Реагенти:\nМ'ясо повзуна, лагідні спеції",
    ["\nSpider Sausage"] = "\nПавуча сосиска",
    ["\nSpiced Wolf Meat"] = "\nВовчатина з прянощами",
    ["Spiced Wolf Meat"] = "Вовчатина з прянощами",
    ["\nCrab Cake"] = "\nКрабовий пиріжок",
    ["Use: Restores 58 health over 18 sec.  Must remain seated while eating. (1 Sec Cooldown)"] = "Використання: Відновлює 58 здоров'я протягом 18 с. Під час їжі потрібно сидіти. (Відновлення: 1 с)",
    ["Use: Restores 530 health over 24 sec.  Must remain seated while eating.  If you spend at least 10 seconds eating you will become well fed and gain 6 Stamina and Spirit for 15 min. (1 Sec Cooldown)"] = "Використання: Відновлює 530 здоров'я протягом 24 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +6 до витривалості та духу на 15 хв. (Відновлення: 1 с)",
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Strength for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = "Використання: Відновлює 234 здоров'я протягом 21 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +3 до сили на 15 хв. Крім того, досвід за вбивства збільшиться на 5%. (Відновлення: 1 с)",
    ["Use: Restores 1,338 health over 30 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 15 Stamina for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = "Використання: Відновлює 1,338 здоров'я протягом 30 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +15 до витривалості на 15 хв. Крім того, досвід за вбивства збільшиться на 5%. (Відновлення: 1 с)",
    ["Use: Restores 58 health over 18 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 1 Agility for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = "Використання: Відновлює 58 здоров'я протягом 18 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +1 до спритності на 15 хв. Крім того, досвід за вбивства збільшиться на 5%. (Відновлення: 1 с)",
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Agility for 15 min. Additionally, experience gained from kills is increased by 5%."] = "Використання: Відновлює 234 здоров'я протягом 21 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +3 до спритності на 15 хв. Крім того, досвід за вбивства збільшиться на 5%.",
    ["Use: Restores 234 health over 21 sec.  Must remain seated while eating. If you spend at least 10 seconds eating you will become well fed and gain 3 Intellect for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] = "Використання: Відновлює 234 здоров'я протягом 21 с. Під час їжі потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +3 до інтелекту на 15 хв. Крім того, досвід за вбивства збільшиться на 5%. (Відновлення: 1 с)",
    ["Craft a First Aid Kit."] = "Виготовляє аптечку першої допомоги.",
    ["Creates a Simple Poultice."] = "Виготовляє простий припар.",
    ["Creates 3 Vials of Anti-Venom."] = "Виготовляє 3 флакони протиотрути.",
    ["Use: Heals 161 damage over 7 sec."] = "Використання: відновлює 161 здоров'я протягом 7 с.",
    ["Use: Heals 114 damage over 6 sec."] = "Використання: відновлює 114 здоров'я протягом 6 с.",
    ["Use: Restores 70 to 90 health."] = "Використання: відновлює 70–90 здоров'я.",
    ["Use: Restores 140 to 180 health."] = "Використання: відновлює 140–180 здоров'я.",
    ["Use: Target is cured of poisons up to level 25. (1 Min Cooldown)"] = "Використання: зцілює ціль від отрут до 25-го рівня. (Перезарядка: 1 хв.)",
    ["<Shift click to buy a different amount>"] = "<Shift + клацання: змінити кількість покупки>",
    ["Dagger"] = "Кинджал",
    ["Track Recipe"] = "Відстежувати рецепт",
    ["Create All"] = "Створити все",
    ["Create"] = "Створити",
    ["Set Amount"] = "Встановити кількість",
    ["Allows the miner to smelt a chunk of copper ore into a copper bar. Smelting copper requires a forge."] = "Дозволяє гірникові переплавити шматок мідної руди на мідний злиток. Для виплавки міді потрібна кузня.",
    ["Mining: Thorium Bar"] = "Гірництво: торієвий злиток",
    ["Корюшка Truesilver"] = "Виплавити істинне срібло",
    ["Корюшка Міфрилу"] = "Виплавити мітрил",
    ["Allows the miner to smelt a chunk of thorium ore into a thorium bar.  Smelting thorium requires a forge."] = "Дозволяє гірникові виплавити шматок торієвої руди в торієвий злиток. Для виплавлення торію потрібна кузня.",
    ["Allows the miner to smelt a tin bar and a copper bar together into two bronze bars.  Smelting bronze requires a forge."] = "Дозволяє гірникові виплавити з олов'яного й мідного злитків два бронзові злитки. Для виплавлення бронзи потрібна кузня.",
    ["Allows the miner to smelt a chunk of iron ore and a lump of coal together into a steel bar.  Smelting steel requires a forge."] = "Дозволяє гірникові виплавити із залізної руди й вугілля сталевий злиток. Для виплавлення сталі потрібна кузня.",
    ["Allows the miner to smelt a chunk of iron ore into an iron bar.  Smelting iron requires a forge."] = "Дозволяє гірникові виплавити шматок залізної руди в залізний злиток. Для виплавлення заліза потрібна кузня.",
    ["Allows the miner to smelt a chunk of gold ore into a gold bar.  Smelting gold requires a forge."] = "Дозволяє гірникові виплавити шматок золотої руди в золотий злиток. Для виплавлення золота потрібна кузня.",
    ["Allows the miner to smelt a chunk of silver ore into a silver bar.  Smelting silver requires a forge."] = "Дозволяє гірникові виплавити шматок срібної руди в срібний злиток. Для виплавлення срібла потрібна кузня.",
    ["Allows the miner to smelt a chunk of truesilver ore into a truesilver bar.  Smelting truesilver requires a forge."] = "Дозволяє гірникові виплавити шматок руди істинного срібла в злиток істинного срібла. Для цього потрібна кузня.",
    ["Allows the miner to smelt a chunk of mithril ore into a mithril bar.  Smelting mithril requires a forge."] = "Дозволяє гірникові виплавити шматок мітрилової руди в мітриловий злиток. Для виплавлення мітрилу потрібна кузня.",
    ["Allows the miner to smelt a chunk of tin ore into a tin bar.  Smelting tin requires a forge."] = "Дозволяє гірникові виплавити шматок олов'яної руди в олов'яний злиток. Для виплавлення олова потрібна кузня.",
    ["Equip: Increases damage and healing done by magical spells and effects by up to 5."] = "Екіпірування: збільшує шкоду та зцілення від магічних заклять і ефектів на 5.",
    ["Use: Increase the damage of a blunt weapon by 3 for 30 minutes. (1 Sec Cooldown)"] = "Використання: збільшує шкоду дробильної зброї на 3 протягом 30 хв. (Перезарядка: 1 с)",
    ["Use: Increase sharp weapon damage by 3 for 30 minutes. (1 Sec Cooldown)"] = "Використання: збільшує шкоду гострої зброї на 3 протягом 30 хв. (Перезарядка: 1 с)",
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
    ["Can't attack while incapacitated."] = "Не можна атакувати, поки ви недієздатні.",
    ["Can't do that while incapacitated"] = "Не можна це зробити, поки ви недієздатні.",
    ["Fill yer tankard and pull up a chair. We've stories to tell and kegs to empty."] =
        "Наповнюй кухоль і влаштовуйся зручніше. Маємо історії до розповіді й барила до спорожнення.",
    ["0.0 Sec"] = "0,0 сек",
    ["1.5 Sec"] = "1,5 секунди",
    ["120 FPS"] = "120 кадрів на секунду",
    ["1920x1080"] = "1920×1080",
    ["1920x1080 (100%)"] = "1920×1080 (100 %)",
    ["30 FPS"] = "30 кадрів на секунду",
    ["60 FPS"] = "60 кадрів на секунду",
    ["Action Bar 8"] = "Панель дій 8",
    ["Bloom Intensity"] = "Інтенсивність світіння",
    ["Debuff Deadly Sting"] = "Дебаф «Смертельний укус»",
    ["Diminishing Returns (|cnRED_FONT_COLOR:Work in Progress)"] = "Зменшення прибутковості (|cnRED_FONT_COLOR:У процесі розробки)",
    ["Enable Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Functionality"] = "Увімкнути Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Функціональність",
    ["Enemy Buffs, Personal Debuffs, Big Debuff"] = "Посилення ворогів, особисті ослаблення, сильне ослаблення",
    ["English Voice 1 (Masculine)"] = "Англійський голос 1 (чоловічий)",
    ["For more information see our |HurlIndex:15|hPrivacy Policy|h"] = "Докладнішу інформацію дивіться на нашому |HurlIndex:15|hPrivacy Policy|h",
    ["Large (128MB)"] = "Великий (128 МБ)",
    ["Microsoft Zira Desktop - English (United States)"] = "Microsoft Zira Desktop — англійська (США)",
    ["Mob Buffs, Personal Debuffs, Shared CC"] = "Підсилення істот, особисті послаблення та спільні ефекти контролю",
    ["Personal Buffs, Enemy Debuffs"] = "Особисті підсилення та послаблення ворогів",
    ["Rage 20"] = "Лють: 20",
    ["Say Your Rage"] = "Озвучувати запас люті",
    ["Spell Name, Spell Icon, Highlight Important Casts, Flash When Targeted By Enemy"] = "Назва заклинання, іконка заклинання, виділення важливих заклинань, миготіння, коли на вас націлюється ворог",
    ["Target casting Fireball"] = "Ціль — запуск «Вогняної кулі»",
    ["Toggle Sound"] = "Увімкнути або вимкнути звук",
    ["Triple Buffering"] = "Потрійна буферизація",
    ["Voice Chat Volume"] = "Гучність голосового чату",
    ["Must have a Shield equipped"] = "Потрібно спорядити щит",
    ["Escort Miran to the excavation site (Complete)"] = "Супроводіть Мірана до місця розкопок (виконано)",
    ["Must be in Defensive Stance"] = "Потрібно перебувати в захисній стійці",
    ["6 Minutes until release"] = "6 хвилин до звільнення духу",
    ["Tools: Runed Silver Rod"] = "Інструменти: рунічний срібний жезл",
    ["Tools: Runed Golden Rod"] = "Інструменти: рунічний золотий жезл",
    ["By enabling transmogrification you will see any custom appearances applied to your own and other players' equipment via transmogrification. Are you sure you wish to enable transmogrification? You may disable transmogrification at any time by speaking with me again."] = "Увімкнувши трансмогрифікацію, ви бачитимете всі змінені вигляди, застосовані до вашого спорядження та спорядження інших гравців за допомогою трансмогрифікації. Ви справді бажаєте увімкнути трансмогрифікацію? Ви можете вимкнути її будь-коли, знову поговоривши зі мною.",
    ["Must be in Battle Stance"] = "Потрібно перебувати в бойовій стійці",
    ["Only Herbs can be placed in that."] = "Сюди можна покласти лише трави.",
    ["Oh goodness Datto, this town is not well suited for the likes of me. There are as many nasty creatures here as there were in Gnomeregan before the accident! Do you have my belongings? If you don't, then who knows what the trolls have done with them now..."] = "Ой лишенько, Датто, це містечко зовсім не для таких, як я. Тут стільки ж мерзенних створінь, скільки було в Гномреґані до аварії! Мої речі в тебе? Якщо ні, то хтозна, що тролі вже з ними зробили...",
    ["Requires Herbalism 15"] = "Потрібне травництво 15",
    ["Hail! Have a care, Datto, the tunnel to Dun Morogh is infested with troggs and is not safe for travel. If you haven't any pressing business in Dun Morogh, I'll have to ask you to remain in Anvilmar until the tunnel is safer."] = "Вітаю! Обережніше, Датто: тунель до Дун-Морога кишить троґами, тож подорожувати ним небезпечно. Якщо в тебе немає нагальних справ у Дун-Морозі, мушу попросити тебе залишитися в Ковадлі, доки тунель не стане безпечнішим.",
    ["Hm? You look a little young to be a siege engine pilot. But no matter...do you need something fixed? Well take a number and get comfortable. I'm working on a couple engines right now and won't have time for another job for at least a few days. Or, were you here for something else...?"] = "Гм? Ти наче замолодий, щоб керувати облоговою машиною. Та байдуже... треба щось полагодити? Тоді бери номерок і влаштовуйся зручніше. Я зараз працюю над кількома машинами й не матиму часу на нову роботу щонайменше кілька днів. Чи ти прийшов з іншої справи...?",
    ["Diceman Jr"] = "Дайсмен-молодший",
    ["Raise your herbalism skill to 20: 1/1"] = "Підвищте навичку травництва до 20: 1/1",
    ["(Tier 1)"] = "(Ранг 1)",
    ["Stranglethorn Fishing Extravaganza"] = "Рибальська феєрія Тернистої долини",
    ["Call to Arms: Arathi Basin"] = "До зброї: Низина Араті",
    ["Call to Arms: Darkspear Islands"] = "До зброї: Острови Чорного Списа",
    ["Call to Arms: Warsong Gulch"] = "До зброї: Ущелина Пісні Війни",
    ["Harvest Festival"] = "Свято врожаю",
}

if addonTable.forever_catalog then
    addonTable.forever_catalog.register_ui_source("ui", "curated", ui, 300)
else
    addonTable.forever_ui = ui
end

local warrior_stances = {
    ["Battle Stance"] = "бойова стійка",
    ["Defensive Stance"] = "захисна стійка",
    ["Berserker Stance"] = "стійка берсерка",
}
local tooltip_catalog = addonTable.forever_tooltip_ui or {}
local requirement_names = tooltip_catalog.requirement_names or {}
local power_resources = tooltip_catalog.power_resources or {}

local function translate_requirement_part(requirement)
    requirement = requirement:match("^%s*(.-)%s*$")
    local skill, color, rank, reset = requirement:match(
        "^(.-) %((|c%x%x%x%x%x%x%x%x)(%d+)(|r)%)$")
    local explicit_rank = false
    if not skill then
        skill, rank = requirement:match("^(.-) %((%d+)%)$")
    end
    if not skill then
        skill, rank = requirement:match("^(.-) %(Rank (%d+)%)$")
        explicit_rank = skill ~= nil
    end
    local name = skill or requirement
    local level = name:match("^Level (%d+)$")
    if level then return "рівень " .. level, true end

    local translated = addonTable.use("faction_client_db").get_name(name)
        or warrior_stances[name] or requirement_names[name] or ui[name]
        or addonTable.string and addonTable.string[name]
    if not translated then
        local entries = addonTable.use("entries")
        translated = entries.lookup_name("spell", name)
            or addonTable.use("item_client_db").get_name_by_english(name)
    end
    if not translated then return nil end
    if rank then
        translated = translated .. " (" .. (explicit_rank and "ранг " or "")
            .. (color or "") .. rank .. (reset or "") .. ")"
    end
    return translated, false
end

local function translate_requirement(requirement)
    local parts, only_level = {}, true
    for part in requirement:gmatch("[^,]+") do
        local translated, is_level = translate_requirement_part(part)
        if not translated then return nil end
        parts[#parts + 1] = translated
        only_level = only_level and is_level == true
    end
    if #parts == 0 then return nil end
    if #parts == 1 and only_level then
        return "Необхідний " .. parts[1]
    end
    return "Потрібно: " .. table.concat(parts, ", ")
end

local function translate_quest_timer_value(first_count, first_unit,
        second_count, second_unit)
    local units = addonTable.forever_surface_ui
        and addonTable.forever_surface_ui.quest
        and addonTable.forever_surface_ui.quest.timer_units
    if type(units) ~= "table" then return nil end
    local translated_units = {}
    for _, unit in ipairs(units) do
        translated_units[unit.source] = unit.translated
    end
    local dynamic_value_words = tooltip_catalog.dynamic_value_words or {}
    local first = translated_units[first_unit]
        or dynamic_value_words[first_unit:lower()]
    if not first then return nil end
    local result = first_count .. " " .. first
    if second_count ~= "" or second_unit ~= "" then
        local second = translated_units[second_unit]
            or dynamic_value_words[second_unit:lower()]
        if second_count == "" or not second then return nil end
        result = result .. " " .. second_count .. " " .. second
    end
    return result
end

local social_time_units = {
    second = "с", seconds = "с", minute = "хв", minutes = "хв",
    hour = "год", hours = "год", day = "дн.", days = "дн.",
    month = "міс.", months = "міс.", year = "р.", years = "р.",
}

local function social_label(source)
    return addonTable.forever_ui and addonTable.forever_ui[source]
        or addonTable.string and addonTable.string[source] or ui[source]
end

local function translate_social_time(value)
    if value == "< a minute" then return "менше хвилини" end
    local valid, count = true, 0
    local translated = value:gsub("(%d+)%s+([A-Za-z]+)", function (number, unit)
        local label = social_time_units[unit:lower()]
        if not label then valid = false; return end
        count = count + 1
        return number .. " " .. label
    end)
    if valid and count > 0 and not translated:find("[A-Za-z]") then
        return translated
    end
end

addonTable.forever_ui_patterns = {
    {
        pattern = "^(.+) ([%d,]+)%s*/%s*([%d,]+)$",
        replace = function (faction, current, maximum)
            local name = addonTable.use("faction_client_db").get_name(faction)
            return name and (name .. " " .. current .. " / " .. maximum) or nil
        end,
    },
    {
        pattern = "^(.+) %- (.+)$",
        replace = function (faction, standing)
            local name = addonTable.use("faction_client_db").get_name(faction)
            local status = social_label(standing)
            return name and status and (name .. " — " .. status) or nil
        end,
    },
    -- Contacts formats these values before writing its pooled FontStrings.
    {
        pattern = "^Social (|c%x%x%x%x%x%x%x%x)(%b())(|r)$",
        replace = function (color, binding, reset)
            local translated = social_label("Social")
            return translated and (translated .. " " .. color .. binding .. reset) or nil
        end,
    },
    {
        pattern = "^Level (%d+)%s+(|A:charactercreate%-customize%-dropdown%-linemouseover%-middle:[^|]+|a)%s+(.+)$",
        replace = function (level, divider, race)
            local key = race:lower():gsub("%s+", "")
            local record = addonTable.race and addonTable.race[key]
            local forms = record and record["н"]
            local name = addonTable.use("faction_client_db").get_player_name(race)
                or forms and (forms.neutral_singular or forms[1])
                or social_label(race) or race
            return "Рівень " .. level .. "  " .. divider .. "  " .. name
        end,
    },
    {
        pattern = "^Fought Together %- (.+)$",
        replace = function (zone)
            local name = addonTable.zone and addonTable.zone[zone] or zone
            return ui["Fought Together"] .. " — " .. name
        end,
    },
    {
        pattern = "^(.+), Level (%d+) (.+)$",
        replace = function (name, level, class)
            return name .. ", Рівень " .. level .. " " .. (social_label(class) or class)
        end,
    },
    {
        pattern = "^Friend Requests %((%d+)%)$",
        replace = function (count) return "Запрошення в друзі (" .. count .. ")" end,
    },
    {
        pattern = "^Quick Join %((%d+)%)$",
        replace = function (count)
            return (social_label("Quick Join") or "Швидке приєднання") .. " (" .. count .. ")"
        end,
    },
    {
        pattern = "^Legacy Friends (%d+)/(%d+)$",
        replace = function (count, maximum) return "Давні друзі " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^Pinned (%d+)/(%d+)$",
        replace = function (count, maximum) return "Закріплені " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^Recent Allies (%d+)/(%d+)$",
        replace = function (count, maximum) return "Недавні союзники " .. count .. "/" .. maximum end,
    },
    {
        pattern = "^last online (.+) ago$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("Востаннє в мережі: " .. translated .. " тому") or nil
        end,
    },
    {
        pattern = "^%((.+) ago%)$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("(" .. translated .. " тому)") or nil
        end,
    },
    {
        pattern = "^(.+) ago$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and (translated .. " тому") or nil
        end,
    },
    {
        pattern = "^Pinned Ally %(Expires in (.+)%)$",
        replace = function (time)
            local translated = translate_social_time(time)
            return translated and ("Закріплений союзник (ще " .. translated .. ")") or nil
        end,
    },
    {
        pattern = "^Status: (|c%x%x%x%x%x%x%x%x)(.-)(|r)$",
        replace = function (color, status, reset)
            local translated = social_label(status)
            return translated and ("Статус: " .. color .. translated .. reset) or nil
        end,
    },
    {
        pattern = "^(|T.-|t) (.+)$",
        replace = function (icon, status)
            if status ~= "Available" and status ~= "Away" and status ~= "Busy" then return nil end
            local translated = social_label(status)
            return translated and (icon .. " " .. translated) or nil
        end,
    },
    {
        pattern = "^Tier (%d+)$",
        replace = function (tier) return "Рівень " .. tier end,
    },
    {
        pattern = "^Use: Restores ([%d%.,]+) to ([%d%.,]+) health%.$",
        replace = function (minimum, maximum)
            return "Використання: відновлює " .. minimum .. "–" .. maximum
                .. " здоров'я."
        end,
    },
    {
        pattern = '^Abandon "(.*)", destroying (.+)%?$',
        replace = function (name, items)
            return string.format(addonTable.forever_surface_ui.quest
                .ABANDON_QUEST_CONFIRM_WITH_ITEMS, name, items)
        end,
    },
    {
        pattern = '^Abandon "(.*)"%?$',
        replace = function (name)
            return string.format(addonTable.forever_surface_ui.quest
                .ABANDON_QUEST_CONFIRM, name)
        end,
    },
    {
        -- SecondsToTime() emits at most two abbreviated units for quest timers.
        pattern = "^([%d%.,]+)%s+(%a+)%s*([%d%.,]*)%s*(%a*)$",
        replace = translate_quest_timer_value,
    },
    {
        pattern = "^Pass on Loot: (.+)$",
        replace = function (value)
            local translated = ({ Yes = "Так", No = "Ні" })[value] or value
            return "Відмова від здобичі: " .. translated
        end,
    },
    {
        pattern = "^(.+) slain: (%d+)/(%d+)$",
        replace = function (name, current, total)
            local entries = addonTable.use("entries")
            local translated = entries.lookup_name("npc", name) or name
            return translated .. ": " .. current .. "/" .. total .. " вбито"
        end,
    },
    {
        pattern = "^(.+) invites you to a group%.$",
        replace = function (name)
            return name .. " запрошує вас до групи."
        end,
    },
    {
        pattern = "^Do you want to destroy (.+)%?$",
        replace = function (name)
            local translated = addonTable.use("item_client_db")
                .get_name_by_english(name) or name
            return "Ви хочете знищити " .. translated .. "?"
        end,
    },
    {
        pattern = "^(%d+)%% Threat$",
        replace = function (percent) return "Загроза: " .. percent .. "%" end,
    },
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
        pattern = "^Rank (%d+)$",
        replace = function (rank) return "Ранг " .. rank end,
    },
    {
        pattern = "^Rank (%d+)/(%d+)$",
        replace = function (rank, maximum)
            return "Ранг " .. rank .. "/" .. maximum
        end,
    },
    {
        pattern = "^Increases the radius of your Battle Shout and Demoralizing Shout abilities by (%d+)%%%.$",
        replace = function (amount)
            return "Збільшує радіус дії «Бойового кличу» та «Деморалізуючого кличу» на "
                .. amount .. "%."
        end,
    },
    {
        pattern = "^([%+%-]?[%d%.,]+) ([A-Za-z]+)$",
        replace = function (amount, resource)
            local translated = power_resources[resource]
            return translated and amount .. " " .. translated or nil
        end,
    },
    {
        pattern = "^(%d+)%-(%d+) yd range$",
        replace = function (minimum, maximum)
            return "Дальність " .. minimum .. "–" .. maximum .. " м"
        end,
    },
    {
        pattern = "^(%d+) yd range$",
        replace = function (range) return "Дальність " .. range .. " м" end,
    },
    {
        pattern = "^([%d%.]+) sec cast$",
        replace = function (seconds) return "Час застосування: " .. seconds .. " с" end,
    },
    {
        pattern = "^([%d%.]+) sec cooldown$",
        replace = function (seconds) return "Відновлення: " .. seconds .. " с" end,
    },
    {
        pattern = "^([%d%.]+) min cooldown$",
        replace = function (minutes) return "Відновлення: " .. minutes .. " хв" end,
    },
    {
        pattern = "^Cooldown remaining: ([%d%.]+) sec$",
        replace = function (seconds) return "До відновлення: " .. seconds .. " с" end,
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
        pattern = "^(%d+) Health$",
        replace = function (amount)
            return amount .. " здоров'я"
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
        pattern = "^Quantity: (%d+)$",
        replace = function (count)
            return "Кількість: " .. count
        end,
    },
    {
        pattern = "^Total: (.+)$",
        replace = function (total)
            return "Разом: " .. total
        end,
    },
    {
        pattern = "^Requires Level (%d+)$",
        replace = function (level)
            return "Необхідний рівень " .. level
        end,
    },
    {
        pattern = "^<Made by (.+)>$",
        replace = function (name)
            return "<Виготовлено: " .. name .. ">"
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
                and issue_type ~= "Spell" and issue_type ~= "Creature" then
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
        -- Camelot build 70058 colors both values in QUEST_LOG_COUNT_TEMPLATE.
        -- Preserve those codes so an over-capacity count stays red.
        pattern = "^Quests: (|c%x%x%x%x%x%x%x%x)(%d+)|r(|c%x%x%x%x%x%x%x%x)/(%d+)|r$",
        replace = function (current_color, current, maximum_color, maximum)
            return "Завдання: " .. current_color .. current .. "|r"
                .. maximum_color .. "/" .. maximum .. "|r"
        end,
    },
    {
        pattern = "^Quests:%s*(%d+)%s*/%s*(%d+)$",
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
            local translated_class = ui[class] or class
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
        pattern = "^Cursor: ([%d%.]+), ([%d%.]+)$",
        replace = function (x, y) return "Курсор: " .. x .. ", " .. y end,
    },
    {
        pattern = "^Player: ([%d%.]+), ([%d%.]+)$",
        replace = function (x, y) return "Гравець: " .. x .. ", " .. y end,
    },
    {
        pattern = "^Player: ([%d%.]+), ([%d%.]+) %((.+)%)$",
        replace = function (x, y, zone)
            local translated = addonTable.zone and addonTable.zone[zone] or zone
            return "Гравець: " .. x .. ", " .. y .. " (" .. translated .. ")"
        end,
    },
    {
        pattern = "^Lvl (%d+)$",
        replace = function (level) return "Рів. " .. level end,
    },
    {
        pattern = "^%((Rank %d+)%)$",
        replace = function (rank)
            return "(" .. rank:gsub("Rank", "Ранг") .. ")"
        end,
    },
    {
        pattern = "^Item Purchased: (.+)$",
        replace = function (item)
            return "Придбано: " .. (addonTable.use("item_client_db")
                .get_name_by_english(item) or item)
        end,
    },
    {
        pattern = "^Auction won: (.+)$",
        replace = function (item)
            return "Виграно на аукціоні: "
                .. (addonTable.use("item_client_db")
                    .get_name_by_english(item) or item)
        end,
    },
    {
        pattern = "^Sold By: (.+)$",
        replace = function (seller) return "Продавець: " .. seller end,
    },
    {
        pattern = "^Requires Body of (.+)$",
        replace = function (name)
            local entries = addonTable.use("entries")
            return "Потрібне тіло: "
                .. (entries.lookup_name("npc", name) or name)
        end,
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
            local translated = social_label(label)
            if translated then return translated .. " (" .. binding .. ")" end
        end,
    },
    {
        pattern = "^Equip: Your spells pierce ([%d,]+) Magical Resistance%.$",
        replace = function (amount)
            return "Екіпірування: Ваші заклинання долають " .. amount
                .. " од. магічного опору."
        end,
    },
    {
        pattern = "^Classes: (.+)$",
        replace = function (classes)
            local names = {
                Druid = "друїд", Hunter = "мисливець", Mage = "маг",
                Paladin = "паладин", Priest = "жрець", Rogue = "розбійник",
                Shaman = "шаман", Warlock = "чаклун", Warrior = "воїн",
            }
            local translated = {}
            for class in classes:gmatch("[^,]+") do
                class = class:match("^%s*(.-)%s*$")
                local name = names[class]
                if not name then return nil end
                translated[#translated + 1] = name
            end
            local label = #translated == 1 and "Клас: " or "Класи: "
            return label .. table.concat(translated, ", ")
        end,
    },
    {
        pattern = "^(Непрочитані листи від: )(.+)$",
        replace = function (prefix, location)
            local translated = ui[location]
            return translated and (prefix .. translated) or nil
        end,
    },
    {
        pattern = "^([%+%-])(%d+) (.+)$",
        replace = function (sign, amount, stat)
            local names = {
                Strength = "сили", Stamina = "витривалості",
                Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
            }
            local name = names[stat]
            return name and (sign .. amount .. " до " .. name) or nil
        end,
    },
    {
        pattern = "^%+(%d+) (.+)$",
        replace = function (amount, stat)
            local names = {
                Strength = "сили", Stamina = "витривалості",
                Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
            }
            local name = names[stat]
            return name and ("+" .. amount .. " до " .. name) or nil
        end,
    },
    {
        pattern = "^Level (%d+)$",
        replace = function (level)
            return "Рівень " .. level
        end,
    },
}
