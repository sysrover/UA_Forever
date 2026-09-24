-- Generated from cached Forever quest tasks, QuestieDB candidates, and UA_Forever terminology.
-- Re-run tools/wowhead_forever_quests.py --stage tasks-render after reviewing new data.
local _, addonTable = ...
local questTasks = {
    [2] = {
        ["Sharptalon's Claw"] = "кіготь Гостропазура",
        ["Sharptalon's Claw (Provided)"] = "кіготь Гостропазура (видано)",
    },
    [6] = {
        ["Garrick's Head"] = "голова Ґарріка",
    },
    [7] = {
        ["Kobold Vermin slain"] = "кобольд-шкідник: убито",
    },
    [8] = {
        ["Nondescript Letter"] = "непідписаний лист",
        ["Nondescript Letter (Provided)"] = "непідписаний лист (видано)",
    },
    [9] = {
        ["Harvest Watcher slain"] = "жнивальний доглядач: убито",
    },
    [10] = {
        ["Scrimshank's Surveying Gear"] = "землемірне спорядження Полотноміра",
    },
    [11] = {
        ["Painted Gnoll Armband"] = "розфарбований браслет гнола",
    },
    [12] = {
        ["Defias Smuggler slain"] = "контрабандист Непокірних: убито",
        ["Defias Trapper slain"] = "капканник Непокірних: убито",
    },
    [13] = {
        ["Defias Looter slain"] = "здобичник Непокірних: убито",
        ["Defias Pillager slain"] = "грабіжник Непокірних: убито",
    },
    [14] = {
        ["Defias Highwayman slain"] = "нальотник Непокірних: убито",
        ["Defias Knuckleduster slain"] = "кастетник Непокірних: убито",
        ["Defias Pathstalker slain"] = "вистежувач Непокірних: убито",
    },
    [15] = {
        ["Kobold Worker slain"] = "кобольд-робітник: убито",
    },
    [16] = {
        ["Refreshing Spring Water"] = "освіжаюча джерельна вода",
    },
    [17] = {
        ["Magenta Fungus Cap"] = "гриб-малиновик",
    },
    [18] = {
        ["Red Burlap Bandana"] = "червона бандана з мішковини",
    },
    [19] = {
        ["Tharil'zun's Head"] = "голова Таріл'зуна",
    },
    [20] = {
        ["Battleworn Axe"] = "зношена сокира",
    },
    [21] = {
        ["Kobold Laborer slain"] = "кобольд-різнороб: убито",
    },
    [22] = {
        ["Goretusk Liver"] = "печінка іклоштрика",
    },
    [23] = {
        ["Ursangous's Paw"] = "лапа Урсанґо",
        ["Ursangous's Paw (Provided)"] = "лапа Урсанґо (видано)",
    },
    [24] = {
        ["Shadumbra's Head"] = "голова Шадумбри",
        ["Shadumbra's Head (Provided)"] = "голова Шадумбри (видано)",
    },
    [25] = {
        ["Befouled Water Elemental slain"] = "забруднений елементаль води: убито",
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Scout the gazebo on Mystral Lake that overlooks the nearby Alliance outpost."] = "Огляньте альтанку біля озера Містраль, звідки видно форпост Альянсу.",
    },
    [28] = {
        ["Complete the Trial of the Lake."] = "Пройдіть випробування озера.",
        ["Shrine Bauble"] = "прикраса вівтаря",
    },
    [29] = {
        ["Complete the Trial of the Lake."] = "Пройдіть випробування озера.",
        ["Shrine Bauble"] = "прикраса вівтаря",
    },
    [30] = {
        ["Half Pendant of Aquatic Agility"] = "половинка підвіски водної спритності",
        ["Half Pendant of Aquatic Endurance"] = "половинка підвіски водної витривалості",
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
    },
    [31] = {
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
        ["Pendant of the Sea Lion (Provided)"] = "підвіска Морського Лева (видано)",
    },
    [32] = {
        ["Insect Analysis Report"] = "звіт про дослідження комах",
        ["Insect Analysis Report (Provided)"] = "звіт про дослідження комах (видано)",
    },
    [33] = {
        ["Tough Wolf Meat"] = "жорстке вовче м'ясо",
    },
    [34] = {
        ["Bellygrub's Tusk"] = "ікло Грубопуза",
    },
    [36] = {
        ["Verna's Westfall Stew Recipe"] = "рецепт гуляшу по-західнокрайськи від Верни",
        ["Verna's Westfall Stew Recipe (Provided)"] = "рецепт гуляшу по-західнокрайськи від Верни (видано)",
    },
    [38] = {
        ["Goretusk Snout"] = "рило іклоштрика",
        ["Murloc Eye"] = "око мурлока",
        ["Okra"] = "окра",
        ["Stringy Vulture Meat"] = "жилаве м'ясо грифа",
    },
    [46] = {
        ["Torn Murloc Fin"] = "порваний плавник мурлока",
    },
    [47] = {
        ["Gold Dust"] = "золотий пил",
    },
    [48] = {
        ["Holy Spring Water"] = "вода святого джерела",
    },
    [49] = {
        ["Sack of Barley"] = "мішок ячменю",
        ["Sack of Corn"] = "мішок кукурудзи",
        ["Sack of Rye"] = "мішок жита",
    },
    [50] = {
        ["Truesilver Bar"] = "злиток ясносрібла",
    },
    [51] = {
        ["A Sycamore Branch"] = "гілка платану",
    },
    [52] = {
        ["Prowler slain"] = "бродячий хижак: убито",
        ["Young Forest Bear slain"] = "молодий лісовий ведмідь: убито",
    },
    [53] = {
        ["Bundle of Charred Oak"] = "зв'язка обвугленого дуба",
    },
    [54] = {
        ["Marshal McBride's Documents"] = "документи маршала Макбрайда",
        ["Marshal McBride's Documents (Provided)"] = "документи маршала Макбрайда (видано)",
    },
    [55] = {
        ["Morbent Fel slain"] = "Морбент Скверн: убито",
        ["Morbent's Bane"] = "прокляття Морбента",
        ["Morbent's Bane (Provided)"] = "прокляття Морбента (видано)",
    },
    [56] = {
        ["Skeletal Mage slain"] = "скелетний маг: убито",
        ["Skeletal Warrior slain"] = "скелетний воїн: убито",
    },
    [57] = {
        ["Skeletal Fiend slain"] = "скелетний марник: убито",
        ["Skeletal Horror slain"] = "скелетне страховище: убито",
    },
    [58] = {
        ["Plague Spreader slain"] = "розповсюдник чуми: убито",
    },
    [59] = {
        ["Stormwind Armor Marker"] = "знак броні Штормовію",
        ["Stormwind Armor Marker (Provided)"] = "знак броні Штормовію (видано)",
    },
    [60] = {
        ["Large Candle"] = "велика свічка",
    },
    [61] = {
        ["William's Shipment"] = "пакунок від Вільяма",
        ["William's Shipment (Provided)"] = "пакунок від Вільяма (видано)",
    },
    [62] = {
        ["Scout through the Fargodeep Mine"] = "Дослідіть Бездонну копальню",
    },
    [63] = {
        ["Corrupt Manifestation's Bracers"] = "наручі зіпсованого прояву",
        ["Remaining Drops of Purest Water"] = "залишки крапель найчистішої води",
        ["Remaining Drops of Purest Water (Provided)"] = "залишки крапель найчистішої води (видано)",
    },
    [64] = {
        ["Furlbrow's Pocket Watch"] = "кишеньковий годинник Хмуроброва",
    },
    [68] = {
        ["A Dusty Unsent Letter"] = "вкритий пилом невідправлений лист",
        ["A Dusty Unsent Letter (Provided)"] = "вкритий пилом невідправлений лист (видано)",
    },
    [70] = {
        ["An Undelivered Letter"] = "недоставлений лист",
    },
    [71] = {
        ["Rolf and Malakai's Medallions"] = "медальйони Рольфа і Малакая",
        ["Rolf and Malakai's Medallions (Provided)"] = "медальйони Рольфа і Малакая (видано)",
    },
    [74] = {
        ["A Torn Journal Page"] = "вирвана сторінка щоденника",
        ["A Torn Journal Page (Provided)"] = "вирвана сторінка щоденника (видано)",
    },
    [75] = {
        ["A Faded Journal Page"] = "вицвіла сторінка щоденника",
    },
    [76] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Scout through the Jasperlode Mine"] = "Дослідіть Яшмову шахту",
    },
    [77] = {
        ["Hinterlands Honey Ripple"] = "медова шипучка Внутрішніх земель",
    },
    [78] = {
        ["A Faded Journal Page"] = "вицвіла сторінка щоденника",
        ["A Faded Journal Page (Provided)"] = "вицвіла сторінка щоденника (видано)",
    },
    [79] = {
        ["Muddy Journal Pages"] = "брудні сторінки щоденника",
        ["Muddy Journal Pages (Provided)"] = "брудні сторінки щоденника (видано)",
    },
    [80] = {
        ["A Bloodstained Journal Page"] = "закривавлена сторінка щоденника",
        ["A Bloodstained Journal Page (Provided)"] = "закривавлена сторінка щоденника (видано)",
    },
    [81] = {
        ["Dran's Ripple Delivery"] = "вантаж шипучки для Драна",
        ["Dran's Ripple Delivery (Provided)"] = "вантаж шипучки для Драна (видано)",
    },
    [82] = {
        ["Centipaar Insect Parts"] = "частини тіл комах Сентіпаар",
    },
    [83] = {
        ["Red Linen Bandana"] = "червона лляна бандана",
    },
    [84] = {
        ["Pork Belly Pie"] = "пиріг зі свинячої підчеревини",
        ["Pork Belly Pie (Provided)"] = "пиріг зі свинячої підчеревини (видано)",
    },
    [86] = {
        ["Chunk of Boar Meat"] = "шматок м'яса кнура",
    },
    [87] = {
        ["Bernice's Necklace"] = "намисто Берніс",
    },
    [88] = {
        ["Brass Collar"] = "латунний нашийник",
    },
    [89] = {
        ["Iron Pike"] = "залізна піка",
        ["Iron Rivet"] = "залізна заклепка",
    },
    [90] = {
        ["Lean Wolf Flank"] = "пісний вовчий бік",
    },
    [91] = {
        ["Shadowhide Pendant"] = "підвіска Тінешкурих",
    },
    [92] = {
        ["Crisp Spider Meat"] = "хрумке павуче м'ясо",
        ["Great Goretusk Snout"] = "рило великого іклоштрика",
        ["Tough Condor Meat"] = "жорстке м'ясо кондора",
    },
    [93] = {
        ["Gooey Spider Leg"] = "липка павуча лапка",
    },
    [94] = {
        ["Glyph of Azora"] = "гліф Азори",
        ["Glyph of Azora (Provided)"] = "гліф Азори (видано)",
    },
    [96] = {
        ["Shard of Water"] = "осколок води",
        ["Shard of Water (Provided)"] = "осколок води (видано)",
    },
    [98] = {
        ["Mistmantle Family Ring"] = "сімейний перстень Імлокривів",
    },
    [99] = {
        ["Pyrewood Shackle"] = "кайдани з Поховальних Вогнищ",
    },
    [101] = {
        ["Ghoul Fang"] = "ікло гуля",
        ["Skeleton Finger"] = "палець скелета",
        ["Vial of Spider Venom"] = "флакон павучої отрути",
    },
    [102] = {
        ["Gnoll Paw"] = "лапа гнола",
    },
    [103] = {
        ["Flask of Oil"] = "фляга з мастилом",
    },
    [104] = {
        ["Scale of Old Murk-Eye"] = "луска старого Мутноока",
    },
    [105] = {
        ["Araj's Phylactery Shard"] = "уламок філактерії Аража",
    },
    [106] = {
        ["Maybell's Love Letter"] = "любовний лист Мейбелл",
        ["Maybell's Love Letter (Provided)"] = "любовний лист Мейбелл (видано)",
    },
    [107] = {
        ["Gramma Stonefield's Note"] = "записка бабці Кам'янопільської",
        ["Gramma Stonefield's Note (Provided)"] = "записка бабці Кам'янопільської (видано)",
    },
    [112] = {
        ["Crystal Kelp Frond"] = "стебло кришталевої водорості",
    },
    [113] = {
        ["Insect Analysis Report"] = "звіт про дослідження комах",
        ["Insect Analysis Report (Provided)"] = "звіт про дослідження комах (видано)",
    },
    [114] = {
        ["Invisibility Liquor"] = "відвар невидимості",
        ["Invisibility Liquor (Provided)"] = "відвар невидимості (видано)",
    },
    [115] = {
        ["Midnight Orb"] = "опівнічна сфера",
    },
    [116] = {
        ["Bottle of Moonshine"] = "пляшка сивухи",
        ["Cask of Merlot"] = "барильце Мерло",
        ["Keg of Thunderbrew"] = "бочечка громузвару",
        ["Skin of Sweet Rum"] = "бурдюк солодкого рому",
    },
    [117] = {
        ["Hops"] = "хміль",
    },
    [118] = {
        ["Verner's Note"] = "записка Вернера",
        ["Verner's Note (Provided)"] = "записка Вернера (видано)",
    },
    [119] = {
        ["Crate of Horseshoes"] = "ящик з підковами",
        ["Crate of Horseshoes (Provided)"] = "ящик з підковами (видано)",
    },
    [120] = {
        ["The State of Lakeshire"] = "звіт Приозер'я",
        ["The State of Lakeshire (Provided)"] = "звіт Приозер'я (видано)",
    },
    [121] = {
        ["The General's Response"] = "відповідь генерала",
        ["The General's Response (Provided)"] = "відповідь генерала (видано)",
    },
    [122] = {
        ["Underbelly Whelp Scale"] = "підчеревна луска дракончика",
    },
    [123] = {
        ["The Collector's Schedule"] = "розклад Збирача",
        ["The Collector's Schedule (Provided)"] = "розклад Збирача (видано)",
    },
    [124] = {
        ["Redridge Brute slain"] = "багрянокряжовий моцак: убито",
        ["Redridge Mystic slain"] = "багрянокряжовий містик: убито",
    },
    [125] = {
        ["Oslow's Toolbox"] = "інструменти Ослоу",
    },
    [126] = {
        ["Yowler's Paw"] = "лапа Скавчала",
    },
    [127] = {
        ["Spotted Sunfish"] = "плямиста сонцериба",
    },
    [128] = {
        ["Blackrock Champion slain"] = "чемпіон Чорнокаменю: убито",
    },
    [129] = {
        ["Parker's Lunch"] = "обід Паркера",
        ["Parker's Lunch (Provided)"] = "обід Паркера (видано)",
    },
    [131] = {
        ["Daffodil Bouquet"] = "букет нарцисів",
        ["Daffodil Bouquet (Provided)"] = "букет нарцисів (видано)",
    },
    [132] = {
        ["Wiley's Note"] = "записка Вайлі",
        ["Wiley's Note (Provided)"] = "записка Вайлі (видано)",
    },
    [133] = {
        ["Ghoul Rib"] = "ребро гуля",
    },
    [134] = {
        ["Abercrombie's Crate"] = "ящик Абекромбі",
    },
    [135] = {
        ["Wiley's Note"] = "записка Вайлі",
        ["Wiley's Note (Provided)"] = "записка Вайлі (видано)",
    },
    [137] = {
        ["Commendation - Elwynn Forest"] = "Подяка — Ельвиннський ліс",
    },
    [138] = {
        ["A Clue to Sander's Treasure"] = "підказка до скарбів Сандерса",
    },
    [139] = {
        ["Another Clue to Sander's Treasure"] = "ще одна підказка до скарбів Сандерса",
    },
    [140] = {
        ["Final Clue to Sander's Treasure"] = "остання підказка до скарбів Сандерса",
    },
    [141] = {
        ["Shaw's Report"] = "звіт Гича",
        ["Shaw's Report (Provided)"] = "звіт Гича (видано)",
    },
    [142] = {
        ["A Mysterious Message"] = "таємниче повідомлення",
    },
    [143] = {
        ["Solomon's Plea to Westfall"] = "прохання Соломона до Західного краю",
        ["Solomon's Plea to Westfall (Provided)"] = "прохання Соломона до Західного краю (видано)",
    },
    [144] = {
        ["Stoutmantle's Response to Solomon"] = "відповідь Міцнокрива Соломону",
        ["Stoutmantle's Response to Solomon (Provided)"] = "відповідь Міцнокрива Соломону (видано)",
    },
    [145] = {
        ["Solomon's Plea to Darkshire"] = "прохання Соломона до Темнодолу",
        ["Solomon's Plea to Darkshire (Provided)"] = "прохання Соломона до Темнодолу (видано)",
    },
    [146] = {
        ["Ebonlocke's Response to Solomon"] = "відповідь Чорнобривого Соломону",
        ["Ebonlocke's Response to Solomon (Provided)"] = "відповідь Чорнобривого Соломону (видано)",
    },
    [147] = {
        ["The Collector's Ring"] = "перстень Збирача",
    },
    [149] = {
        ["Spectral Comb"] = "примарний гребінець",
        ["Spectral Comb (Provided)"] = "примарний гребінець (видано)",
    },
    [150] = {
        ["Murloc Fin"] = "плавець мурлока",
    },
    [151] = {
        ["Handful of Oats"] = "жменя вівса",
    },
    [152] = {
        ["Murloc Coastrunner slain"] = "мурлок-берегобігун: убито",
        ["Murloc Oracle slain"] = "мурлок-оракул: убито",
        ["Murloc Tidehunter slain"] = "мурлок-хвилелов: убито",
        ["Murloc Warrior slain"] = "мурлок-воїн: убито",
    },
    [153] = {
        ["Red Leather Bandana"] = "червона шкіряна бандана",
    },
    [154] = {
        ["Ghost Hair Comb"] = "гребінець з волоссям привида",
        ["Ghost Hair Comb (Provided)"] = "гребінець з волоссям привида (видано)",
    },
    [155] = {
        ["Escort The Defias Traitor to discover where VanCleef is hiding"] = "Супроводіть зрадника Непокірних, щоб знайти схованку Ван-Кліфа",
    },
    [156] = {
        ["Rot Blossom"] = "гнилоцвіт",
    },
    [157] = {
        ["Ghost Hair Thread"] = "нитка з волосся привида",
        ["Ghost Hair Thread (Provided)"] = "нитка з волосся привида (видано)",
    },
    [159] = {
        ["Bottle of Zombie Juice"] = "пляшка соку зомбі",
        ["Bottle of Zombie Juice (Provided)"] = "пляшка соку зомбі (видано)",
    },
    [160] = {
        ["Letter to Ello"] = "лист до Елло",
        ["Letter to Ello (Provided)"] = "лист до Елло (видано)",
    },
    [161] = {
        ["Strange Smelling Powder"] = "порошок з дивним запахом",
        ["Strange Smelling Powder (Provided)"] = "порошок з дивним запахом (видано)",
    },
    [162] = {
        ["Insect Analysis Report"] = "звіт про дослідження комах",
        ["Insect Analysis Report (Provided)"] = "звіт про дослідження комах (видано)",
    },
    [164] = {
        ["Supplies for Sven"] = "припаси для Свена",
        ["Supplies for Sven (Provided)"] = "припаси для Свена (видано)",
    },
    [166] = {
        ["Head of VanCleef"] = "голова Ван-Кліфа",
    },
    [167] = {
        ["Thistlenettle's Badge"] = "значок Лютополоха",
    },
    [168] = {
        ["Miners' Union Card"] = "картка спілки шахтарів",
    },
    [169] = {
        ["Head of Gath'Ilzogg"] = "голова Ґат'Ільзоґґа",
    },
    [170] = {
        ["Burly Rockjaw Trogg slain"] = "кремезний кам'янощелепий трог: убито",
        ["Rockjaw Trogg slain"] = "кам'янощелепий трог: убито",
    },
    [171] = {
        ["Human Orphan Whistle"] = "свисток сироти",
    },
    [172] = {
        ["Orcish Orphan Whistle"] = "свисток орка-сироти",
    },
    [173] = {
        ["Nightbane Shadow Weaver slain"] = "тіньовий ткач Ночегибелі: убито",
    },
    [174] = {
        ["Bronze Tube"] = "бронзова трубка",
    },
    [176] = {
        ["Huge Gnoll Claw"] = "величезна лапа гнола",
    },
    [177] = {
        ["Mary's Looking Glass"] = "дзеркальце Мері",
    },
    [178] = {
        ["Faded Shadowhide Pendant"] = "тьмяна підвіска Тінешкурих",
        ["Faded Shadowhide Pendant (Provided)"] = "тьмяна підвіска Тінешкурих (видано)",
    },
    [179] = {
        ["Tough Wolf Meat"] = "жорстке вовче м'ясо",
    },
    [180] = {
        ["Fangore's Paw"] = "лапа Тельбухожбура",
    },
    [181] = {
        ["Ogre's Monocle"] = "монокль огра",
    },
    [182] = {
        ["Frostmane Troll Whelp slain"] = "морозогривий молодий троль: убито",
    },
    [183] = {
        ["Small Crag Boar slain"] = "малий скельний кнур: убито",
    },
    [184] = {
        ["Furlbrow's Deed"] = "документ Хмуроброва",
        ["Furlbrow's Deed (Provided)"] = "документ Хмуроброва (видано)",
    },
    [185] = {
        ["Young Stranglethorn Tiger slain"] = "молодий тернистодільний тигр: убито",
    },
    [186] = {
        ["Stranglethorn Tiger slain"] = "тернистодільний тигр: убито",
    },
    [187] = {
        ["Elder Stranglethorn Tiger slain"] = "старий тернистодільний тигр: убито",
    },
    [188] = {
        ["Paw of Sin'Dall"] = "лапа Сін'Далла",
    },
    [189] = {
        ["Bloodscalp Ear"] = "вухо Кровоскальпого",
    },
    [190] = {
        ["Young Panther slain"] = "молода пантера: убито",
    },
    [191] = {
        ["Panther slain"] = "пантера: убито",
    },
    [192] = {
        ["Shadowmaw Panther slain"] = "тінепаща пантера: убито",
    },
    [193] = {
        ["Fang of Bhag'thera"] = "ікло Баґ'тіри",
    },
    [194] = {
        ["Stranglethorn Raptor slain"] = "тернистодільний раптор: убито",
    },
    [195] = {
        ["Lashtail Raptor slain"] = "хлястохвостий раптор: убито",
    },
    [196] = {
        ["Jungle Stalker slain"] = "ловець джунглів: убито",
    },
    [197] = {
        ["Talon of Tethis"] = "кіготь Тетіса",
    },
    [198] = {
        ["Miscellaneous Goblin Supplies"] = "різні гоблінські припаси",
        ["Miscellaneous Goblin Supplies (Provided)"] = "різні гоблінські припаси (видано)",
    },
    [199] = {
        ["Strange Smelling Powder"] = "порошок з дивним запахом",
        ["Strange Smelling Powder (Provided)"] = "порошок з дивним запахом (видано)",
    },
    [201] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Locate the hunters' camp"] = "Знайдіть табір мисливців",
    },
    [202] = {
        ["Kurzen Elite slain"] = "елітний боєць Курцена: убито",
        ["Kurzen Subchief slain"] = "заступник Курцена: убито",
        ["Kurzen's Head"] = "голова Курцена",
    },
    [203] = {
        ["Kurzen Jungle Fighter slain"] = "лісовий боєць Курцена: убито",
    },
    [204] = {
        ["Jungle Remedy"] = "зілля з джунглів",
        ["Venom Fern Extract"] = "екстракт отруйної папороті",
    },
    [205] = {
        ["Skullsplitter Fetish"] = "фетиш Черепотрощителів",
    },
    [206] = {
        ["Mind's Eye"] = "Око Розуму",
    },
    [207] = {
        ["The First Troll Legend"] = "перша легенда тролів",
        ["The Fourth Troll Legend"] = "четверта легенда тролів",
        ["The Second Troll Legend"] = "друга легенда тролів",
        ["The Third Troll Legend"] = "третя легенда тролів",
    },
    [208] = {
        ["Head of Bangalash"] = "голова Банґалаша",
    },
    [209] = {
        ["Skullsplitter Tusk"] = "ікло Черепотрощителя",
    },
    [210] = {
        ["Krazek's Crock Pot"] = "зламаний горщик Кронжека",
        ["Krazek's Crock Pot (Provided)"] = "зламаний горщик Кронжека (видано)",
    },
    [211] = {
        ["Araj's Phylactery Shard"] = "уламок філактерії Аража",
    },
    [212] = {
        ["Chilled Basilisk Haunch"] = "охолоджена гомілка василіска",
    },
    [213] = {
        ["Tumbled Crystal"] = "галтований кристал",
    },
    [214] = {
        ["Red Silk Bandana"] = "червона шовкова бандана",
    },
    [216] = {
        ["Thistlefur Avenger slain"] = "колючохутрий месник: убито",
        ["Thistlefur Shaman slain"] = "колючохутрий шаман: убито",
    },
    [217] = {
        ["Brawler slain"] = "Булдига: убито",
        ["Gnasher slain"] = "Скрегатель: убито",
        ["Grawmug slain"] = "Ґромаґ: убито",
    },
    [218] = {
        ["Grelin Whitebeard's Journal"] = "щоденник Ґреліна Білоборода",
    },
    [219] = {
        ["Escort Corporal Keeshan back to Redridge"] = "Супроводіть капрала Кішана до Багрянокряжжя",
    },
    [220] = {
        ["Vial of Purest Water"] = "фіал найчистішої води",
        ["Vial of Purest Water (Provided)"] = "фіал найчистішої води (видано)",
    },
    [221] = {
        ["Nightbane Dark Runner slain"] = "темний вісник Ночегибелі: убито",
    },
    [222] = {
        ["Nightbane Tainted One slain"] = "плюгавець Ночегибелі: убито",
        ["Nightbane Vile Fang slain"] = "злобне ікло Ночегибелі: убито",
    },
    [223] = {
        ["Calor's Note"] = "записка Калора",
        ["Calor's Note (Provided)"] = "записка Калора (видано)",
    },
    [224] = {
        ["Stonesplinter Scout slain"] = "розвідник Каменедробів: убито",
        ["Stonesplinter Trogg slain"] = "трог Каменедробів: убито",
    },
    [226] = {
        ["Rabid Dire Wolf slain"] = "скажений зловісний вовк: убито",
        ["Starving Dire Wolf slain"] = "голодний зловісний вовк: убито",
    },
    [228] = {
        ["Mor'Ladim's Skull"] = "череп Мор'Ладіма",
    },
    [230] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [231] = {
        ["Sarah's Ring"] = "каблучка Сари",
        ["Sarah's Ring (Provided)"] = "каблучка Сари (видано)",
    },
    [232] = {
        ["Zinge's Purchase Order"] = "список покупок Зінґе",
        ["Zinge's Purchase Order (Provided)"] = "список покупок Зінґе (видано)",
    },
    [233] = {
        ["A Stack of Letters"] = "стіс листів",
        ["A Stack of Letters (Provided)"] = "стіс листів (видано)",
    },
    [234] = {
        ["A Letter to Grelin Whitebeard"] = "лист до Ґреліна Білоборода",
        ["A Letter to Grelin Whitebeard (Provided)"] = "лист до Ґреліна Білоборода (видано)",
    },
    [237] = {
        ["Stonesplinter Seer slain"] = "провидець Каменедробів: убито",
        ["Stonesplinter Skullthumper slain"] = "череполом Каменедробів: убито",
    },
    [238] = {
        ["Field Testing Kit"] = "набір для польових досліджень",
        ["Field Testing Kit (Provided)"] = "набір для польових досліджень (видано)",
    },
    [240] = {
        ["Dusky Crab Cakes"] = "темні крабові пиріжки",
        ["Dusky Crab Cakes (Provided)"] = "темні крабові пиріжки (видано)",
    },
    [242] = {
        ["Dragonmaw Battlemaster slain"] = "воєначальник Драконової Пащі: убито",
        ["Dragonmaw Bonewarder slain"] = "кісткостраж Драконової Пащі: убито",
        ["Dragonmaw Raider slain"] = "рейдер Драконової Пащі: убито",
    },
    [243] = {
        ["Field Testing Kit"] = "набір для польових досліджень",
    },
    [245] = {
        ["Pygmy Venom Web Spider slain"] = "карликовий отруйний колопряд: убито",
    },
    [246] = {
        ["Redridge Mongrel slain"] = "багрянокряжова дворняга: убито",
        ["Redridge Poacher slain"] = "багрянокряжовий браконьєр: убито",
    },
    [248] = {
        ["Glyph of Azora"] = "гліф Азори",
        ["Glyph of Azora (Provided)"] = "гліф Азори (видано)",
    },
    [249] = {
        ["Pendant of Shadow"] = "кулон тіні",
    },
    [251] = {
        ["Letter to Ello"] = "лист до Елло",
        ["Letter to Ello (Provided)"] = "лист до Елло (видано)",
    },
    [252] = {
        ["Translated Letter"] = "перекладений лист",
        ["Translated Letter (Provided)"] = "перекладений лист (видано)",
    },
    [253] = {
        ["The Embalmer's Heart"] = "серце Бальзамувальника",
    },
    [255] = {
        ["Mo'grosh Brute slain"] = "моцак Мо'ґрош: убито",
        ["Mo'grosh Enforcer slain"] = "громило Мо'ґрош: убито",
        ["Mo'grosh Ogre slain"] = "огр Мо'ґрош: убито",
    },
    [256] = {
        ["Chok'sul's Head"] = "голова Чок'сула",
    },
    [257] = {
        ["Mountain Buzzard slain"] = "гірський канюк: убито",
    },
    [258] = {
        ["Elder Mountain Boar slain"] = "старий гірський кнур: убито",
    },
    [261] = {
        ["Undead Ravager slain"] = "невмерлий спустошник: убито",
    },
    [262] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [263] = {
        ["Stonesplinter Bonesnapper slain"] = "кісткохруст Каменедробів: убито",
        ["Stonesplinter Shaman slain"] = "шаман Каменедробів: убито",
    },
    [264] = {
        ["Clarice's Pendant"] = "кулон Клариси",
        ["Clarice's Pendant (Provided)"] = "кулон Клариси (видано)",
    },
    [265] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [266] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [267] = {
        ["Trogg Stone Tooth"] = "кам'яний зуб трога",
    },
    [268] = {
        ["Jitters' Completed Journal"] = "заповнений щоденник Тремтінія",
        ["Jitters' Completed Journal (Provided)"] = "заповнений щоденник Тремтінія (видано)",
    },
    [269] = {
        ["Jitters' Completed Journal"] = "заповнений щоденник Тремтінія",
        ["Jitters' Completed Journal (Provided)"] = "заповнений щоденник Тремтінія (видано)",
    },
    [271] = {
        ["Ol' Sooty's Head"] = "голова старого Чорниша",
    },
    [272] = {
        ["Half Pendant of Aquatic Agility"] = "половинка підвіски водної спритності",
        ["Half Pendant of Aquatic Endurance"] = "половинка підвіски водної витривалості",
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
    },
    [273] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Find Huldar, Miran, and Saean"] = "Знайдіть Гулдара, Мірана та Саяна",
    },
    [274] = {
        ["Disarming Colloid"] = "нейтралізуючий колоїд",
        ["Disarming Colloid (Provided)"] = "нейтралізуючий колоїд (видано)",
    },
    [275] = {
        ["Fen Creeper slain"] = "драговинний плазун: убито",
    },
    [276] = {
        ["Mosshide Gnoll slain"] = "мохошкурий гнол: убито",
        ["Mosshide Mongrel slain"] = "мохошкура дворняга: убито",
    },
    [277] = {
        ["Crude Flint"] = "грубий кремінь",
    },
    [278] = {
        ["Crocolisk Tear"] = "сльоза кроколіска",
        ["Lurker Venom"] = "павуча отрута",
        ["Mo'grosh Crystal"] = "кристал Мо'ґрош",
    },
    [279] = {
        ["Bluegill Murloc slain"] = "синьожабрий мурлок: убито",
        ["Gobbler's Head"] = "голова Жеруна",
    },
    [280] = {
        ["Disarming Mixture"] = "нейтралізуюча суміш",
        ["Disarming Mixture (Provided)"] = "нейтралізуюча суміш (видано)",
    },
    [282] = {
        ["Grelin's Report"] = "звіт Ґреліна",
        ["Grelin's Report (Provided)"] = "звіт Ґреліна (видано)",
    },
    [286] = {
        ["Menethil Statuette"] = "статуетка Менетіла",
        ["Menethil Statuette (Provided)"] = "статуетка Менетіла (видано)",
    },
    [287] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Frostmane Headhunter slain"] = "морозогривий мисливець за головами: убито",
        ["Fully explore Frostmane Hold"] = "Повністю дослідіть поселення Морозогривих",
    },
    [288] = {
        ["Flagon of Dwarven Honeymead"] = "кружка дворфійської медовухи",
    },
    [289] = {
        ["Cursed Marine slain"] = "проклятий морський піхотинець: убито",
        ["Cursed Sailor slain"] = "проклятий моряк: убито",
        ["Snellig's Snuffbox"] = "табакерка Снелліґа",
    },
    [290] = {
        ["Intrepid Strongbox Key"] = "ключ від сейфа на \"Відважному\"",
    },
    [291] = {
        ["Senir's Report"] = "звіт Сеніра",
        ["Senir's Report (Provided)"] = "звіт Сеніра (видано)",
    },
    [292] = {
        ["Cursed Eye of Paleth"] = "прокляте око Палета",
        ["Cursed Eye of Paleth (Provided)"] = "прокляте око Палета (видано)",
    },
    [293] = {
        ["Cursed Eye of Paleth"] = "прокляте око Палета",
        ["Cursed Eye of Paleth (Provided)"] = "прокляте око Палета (видано)",
    },
    [294] = {
        ["Mottled Raptor slain"] = "строкатий раптор: убито",
        ["Mottled Screecher slain"] = "строкатий верескун: убито",
    },
    [295] = {
        ["Mottled Razormaw slain"] = "строкатий бритвозуб: убито",
        ["Mottled Scytheclaw slain"] = "строкатий серпопазур: убито",
    },
    [296] = {
        ["Sarltooth's Talon"] = "пазур Сарлозуба",
    },
    [297] = {
        ["Carved Stone Idol"] = "різьблений кам'яний ідол",
    },
    [298] = {
        ["Ironband's Progress Report"] = "звіт Залізоплета",
        ["Ironband's Progress Report (Provided)"] = "звіт Залізоплета (видано)",
    },
    [299] = {
        ["Ados Fragment"] = "фрагмент Адос",
        ["Golm Fragment"] = "фрагмент Ґолм",
        ["Modr Fragment"] = "фрагмент Модр",
        ["Neru Fragment"] = "фрагмент Неру",
    },
    [301] = {
        ["Ironband's Progress Report"] = "звіт Залізоплета",
        ["Ironband's Progress Report (Provided)"] = "звіт Залізоплета (видано)",
    },
    [303] = {
        ["Dark Iron Demolitionist slain"] = "підривник Темного Заліза: убито",
        ["Dark Iron Dwarf slain"] = "дворф Темного Заліза: убито",
        ["Dark Iron Saboteur slain"] = "диверсант Темного Заліза: убито",
        ["Dark Iron Tunneler slain"] = "прохідник Темного Заліза: убито",
    },
    [304] = {
        ["Ear of Balgaras"] = "вухо Балґараса",
    },
    [306] = {
        ["Merrin's Letter"] = "записка Меррін",
        ["Merrin's Letter (Provided)"] = "записка Меррін (видано)",
    },
    [307] = {
        ["Miners' Gear"] = "шахтарське спорядження",
    },
    [308] = {
        ["Thunder Ale"] = "громузвар",
    },
    [309] = {
        ["Escort Miran to the excavation site"] = "Супроводіть Мірана до місця розкопок",
    },
    [310] = {
        ["Barrel of Barleybrew Scalder"] = "барильце Ячміноварового Пекучого",
        ["Barrel of Barleybrew Scalder (Provided)"] = "барильце Ячміноварового Пекучого (видано)",
    },
    [311] = {
        ["Barrel of Thunder Ale"] = "барильце громузвару",
        ["Barrel of Thunder Ale (Provided)"] = "барильце громузвару (видано)",
    },
    [312] = {
        ["MacGrann's Dried Meats"] = "в'ялене м'ясо Мак-Ґранна",
    },
    [313] = {
        ["Wendigo Mane"] = "грива вендиго",
    },
    [314] = {
        ["Fang of Vagash"] = "ікло Ваґаша",
    },
    [315] = {
        ["Shimmerweed"] = "блискоквіт",
    },
    [316] = {
        ["Squirrel Nut"] = "білчаний горіх",
    },
    [317] = {
        ["Chunk of Boar Meat"] = "шматок м'яса кнура",
        ["Thick Bear Fur"] = "товста шкура ведмедя",
    },
    [319] = {
        ["Elder Crag Boar slain"] = "старий скельний кнур: убито",
        ["Ice Claw Bear slain"] = "льодолапий ведмідь: убито",
        ["Snow Leopard slain"] = "сніжний леопард: убито",
    },
    [320] = {
        ["Cask of Evershine"] = "барильце Вічногону",
        ["Cask of Evershine (Provided)"] = "барильце Вічногону (видано)",
    },
    [322] = {
        ["Crate of Lightforge Ingots"] = "скринька зі злитками світлосталі",
        ["Crate of Lightforge Ingots (Provided)"] = "скринька зі злитками світлосталі (видано)",
    },
    [323] = {
        ["Skeletal Healer slain"] = "скелетний цілитель: убито",
        ["Skeletal Raider slain"] = "скелетний нальотник: убито",
        ["Skeletal Warder slain"] = "скелетний чатовий: убито",
    },
    [324] = {
        ["Lightforge Ingot"] = "злиток світлосталі",
    },
    [325] = {
        ["Morbent's Bane"] = "прокляття Морбента",
        ["Morbent's Bane (Provided)"] = "прокляття Морбента (видано)",
    },
    [328] = {
        ["Small Brass Key"] = "маленький латунний ключ",
        ["Small Brass Key (Provided)"] = "маленький латунний ключ (видано)",
    },
    [329] = {
        ["Muddy Note"] = "брудна записка",
        ["Muddy Note (Provided)"] = "брудна записка (видано)",
    },
    [332] = {
        ["Wine Ticket"] = "винний квиток",
        ["Wine Ticket (Provided)"] = "винний квиток (видано)",
    },
    [333] = {
        ["Cloth Request"] = "запит на тканину",
        ["Cloth Request (Provided)"] = "запит на тканину (видано)",
    },
    [334] = {
        ["Thurman's Sewing Kit"] = "швацький набір Турмана",
        ["Thurman's Sewing Kit (Provided)"] = "швацький набір Турмана (видано)",
    },
    [335] = {
        ["Musquash Root"] = "мускусний корінь",
        ["Tear of Tilloa"] = "сльоза Тіллої",
    },
    [336] = {
        ["Black Claw Stout"] = "\"Чорний Кіготь\"",
        ["Black Claw Stout (Provided)"] = "\"Чорний Кіготь\" (видано)",
    },
    [337] = {
        ["An Old History Book"] = "стара історична книга",
        ["An Old History Book (Provided)"] = "стара історична книга (видано)",
    },
    [338] = {
        ["Green Hills of Stranglethorn - Chapter I"] = "Зелені пагорби Тернистої долини — Розділ I",
        ["Green Hills of Stranglethorn - Chapter II"] = "Зелені пагорби Тернистої долини — Розділ II",
        ["Green Hills of Stranglethorn - Chapter III"] = "Зелені пагорби Тернистої долини — Розділ III",
        ["Green Hills of Stranglethorn - Chapter IV"] = "Зелені пагорби Тернистої долини — Розділ IV",
    },
    [339] = {
        ["Green Hills of Stranglethorn - Page 1"] = "Зелені пагорби Тернистої долини — Сторінка 1",
        ["Green Hills of Stranglethorn - Page 4"] = "Зелені пагорби Тернистої долини — Сторінка 4",
        ["Green Hills of Stranglethorn - Page 6"] = "Зелені пагорби Тернистої долини — Сторінка 6",
        ["Green Hills of Stranglethorn - Page 8"] = "Зелені пагорби Тернистої долини — Сторінка 8",
    },
    [340] = {
        ["Green Hills of Stranglethorn - Page 10"] = "Зелені пагорби Тернистої долини — Сторінка 10",
        ["Green Hills of Stranglethorn - Page 11"] = "Зелені пагорби Тернистої долини — Сторінка 11",
        ["Green Hills of Stranglethorn - Page 14"] = "Зелені пагорби Тернистої долини — Сторінка 14",
        ["Green Hills of Stranglethorn - Page 16"] = "Зелені пагорби Тернистої долини — Сторінка 16",
    },
    [341] = {
        ["Green Hills of Stranglethorn - Page 18"] = "Зелені пагорби Тернистої долини — Сторінка 18",
        ["Green Hills of Stranglethorn - Page 20"] = "Зелені пагорби Тернистої долини — Сторінка 20",
        ["Green Hills of Stranglethorn - Page 21"] = "Зелені пагорби Тернистої долини — Сторінка 21",
        ["Green Hills of Stranglethorn - Page 24"] = "Зелені пагорби Тернистої долини — Сторінка 24",
    },
    [342] = {
        ["Green Hills of Stranglethorn - Page 25"] = "Зелені пагорби Тернистої долини — Сторінка 25",
        ["Green Hills of Stranglethorn - Page 26"] = "Зелені пагорби Тернистої долини — Сторінка 26",
        ["Green Hills of Stranglethorn - Page 27"] = "Зелені пагорби Тернистої долини — Сторінка 27",
    },
    [346] = {
        ["Book: Stresses of Iron"] = "книга \"Гартування заліза\"",
        ["Book: Stresses of Iron (Provided)"] = "книга \"Гартування заліза\" (видано)",
    },
    [347] = {
        ["Rethban Ore"] = "ретбанська руда",
    },
    [348] = {
        ["Heart of Mokk"] = "серце Мокка",
    },
    [349] = {
        ["Gorilla Fang"] = "ікло горили",
    },
    [351] = {
        ["OOX-17/TN Distress Beacon"] = "аварійний маяк OOX-17/ТН",
        ["OOX-17/TN Distress Beacon (Provided)"] = "аварійний маяк OOX-17/ТН (видано)",
    },
    [353] = {
        ["Package for Stormpike"] = "пакунок для Бурешпиля",
        ["Package for Stormpike (Provided)"] = "пакунок для Бурешпиля (видано)",
    },
    [354] = {
        ["Gregor's Remains"] = "рештки Ґреґора",
        ["Nissa's Remains"] = "рештки Нісси",
        ["Thurman's Remains"] = "рештки Турмана",
    },
    [356] = {
        ["Bleeding Horror slain"] = "криваве страховище: убито",
        ["Wandering Spirit slain"] = "блукаючий дух: убито",
    },
    [357] = {
        ["The Lich's Spellbook"] = "фоліант ліча",
    },
    [358] = {
        ["Embalming Ichor"] = "бальзамувальна сукровиця",
        ["Rot Hide Graverobber slain"] = "гнилошкурий розкрадач могил: убито",
        ["Rot Hide Mongrel slain"] = "гнилошкура дворняга: убито",
    },
    [361] = {
        ["Thurman's Letter"] = "лист Турмана",
        ["Thurman's Letter (Provided)"] = "лист Турмана (видано)",
    },
    [362] = {
        ["Devlin's Remains"] = "рештки Девліна",
    },
    [364] = {
        ["Mindless Zombie slain"] = "безтямний зомбі: убито",
        ["Wretched Zombie slain"] = "жалюгідний зомбі: убито",
    },
    [365] = {
        ["Tirisfal Pumpkin"] = "тірісфальський гарбуз",
    },
    [366] = {
        ["Gunther's Spellbook"] = "фоліант Ґюнтера",
        ["Gunther's Spellbook (Provided)"] = "фоліант Ґюнтера (видано)",
    },
    [367] = {
        ["Darkhound Blood"] = "кров темногончої",
    },
    [368] = {
        ["Vile Fin Scale"] = "луска Злобного Плавника",
    },
    [369] = {
        ["Vicious Night Web Spider Venom"] = "отрута злого нічного колопряда",
    },
    [370] = {
        ["Captain Perrine slain"] = "капітан Перрін: убито",
        ["Scarlet Missionary slain"] = "місіонер Багряного Походу: убито",
        ["Scarlet Zealot slain"] = "ревнитель Багряного Походу: убито",
    },
    [371] = {
        ["Captain Vachon slain"] = "капітан Вачон: убито",
        ["Scarlet Friar slain"] = "ченець Багряного Походу: убито",
    },
    [372] = {
        ["Captain Melrache slain"] = "капітан Мелрач: убито",
        ["Scarlet Bodyguard slain"] = "тілоохоронець Багряного Походу: убито",
    },
    [373] = {
        ["An Unsent Letter"] = "ненадісланий лист",
        ["An Unsent Letter (Provided)"] = "ненадісланий лист (видано)",
    },
    [374] = {
        ["Scarlet Insignia Ring"] = "перстень-відзнака Багряного Походу",
    },
    [375] = {
        ["Coarse Thread"] = "груба нитка",
        ["Duskbat Pelt"] = "шкура сутінкового кажана",
    },
    [376] = {
        ["Duskbat Wing"] = "крило сутінкового кажана",
        ["Scavenger Paw"] = "лапа падальника",
    },
    [377] = {
        ["Hand of Dextren Ward"] = "рука Декстрена Ворда",
    },
    [378] = {
        ["Head of Deepfury"] = "голова Темнолюта",
    },
    [379] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
    },
    [380] = {
        ["Night Web Spider slain"] = "нічний колопряд: убито",
        ["Young Night Web Spider slain"] = "молодий нічний колопряд: убито",
    },
    [381] = {
        ["Scarlet Armband"] = "багряна пов'язка",
    },
    [382] = {
        ["Scarlet Crusade Documents"] = "документи Багряного Походу",
    },
    [383] = {
        ["Scarlet Crusade Documents"] = "документи Багряного Походу",
        ["Scarlet Crusade Documents (Provided)"] = "документи Багряного Походу (видано)",
    },
    [384] = {
        ["Crag Boar Rib"] = "ребро скельного кнура",
        ["Rhapsody Malt"] = "солод Рапсодія",
    },
    [385] = {
        ["Crocolisk Meat"] = "м'ясо кроколіска",
        ["Crocolisk Skin"] = "шкура кроколіска",
    },
    [386] = {
        ["Head of Targorr"] = "голова Тарґорра",
    },
    [387] = {
        ["Defias Convict slain"] = "каторжник Непокірних: убито",
        ["Defias Insurgent slain"] = "заколотник Непокірних: убито",
        ["Defias Prisoner slain"] = "в'язень Непокірних: убито",
    },
    [388] = {
        ["Red Wool Bandana"] = "червона вовняна бандана",
    },
    [391] = {
        ["Head of Bazil Thredd"] = "голова Базіла Тредда",
    },
    [392] = {
        ["Sealed Description of Thredd's Visitor"] = "запечатаний опис відвідувача Тредда",
        ["Sealed Description of Thredd's Visitor (Provided)"] = "запечатаний опис відвідувача Тредда (видано)",
    },
    [393] = {
        ["Sealed Description of Thredd's Visitor"] = "запечатаний опис відвідувача Тредда",
        ["Sealed Description of Thredd's Visitor (Provided)"] = "запечатаний опис відвідувача Тредда (видано)",
    },
    [396] = {
        ["Report on the Defias Brotherhood"] = "доповідь про Братство Непокірних",
        ["Report on the Defias Brotherhood (Provided)"] = "доповідь про Братство Непокірних (видано)",
    },
    [398] = {
        ["Maggot Eye's Paw"] = "лапа Червивого Ока",
    },
    [399] = {
        ["A Simple Compass"] = "звичайний компас",
    },
    [400] = {
        ["Steelgrill's Tools"] = "інструменти Сталешквара",
        ["Steelgrill's Tools (Provided)"] = "інструменти Сталешквара (видано)",
    },
    [404] = {
        ["Putrid Claw"] = "смердючий пазур",
    },
    [405] = {
        ["Sevren's Orders"] = "накази Севрена",
        ["Sevren's Orders (Provided)"] = "накази Севрена (видано)",
    },
    [407] = {
        ["Laced Pumpkin"] = "оброблений гарбуз",
        ["Laced Pumpkin (Provided)"] = "оброблений гарбуз (видано)",
    },
    [408] = {
        ["Dargol's Skull"] = "череп Дарґола",
        ["Rotting Ancestor slain"] = "гниючий предок: убито",
        ["Wailing Ancestor slain"] = "тужливий предок: убито",
    },
    [409] = {
        ["Lillith Nefara slain"] = "Лілліт Нефара: убито",
    },
    [410] = {
        ["Candle of Beckoning"] = "свічка поклику",
    },
    [411] = {
        ["Nether Gem"] = "самоцвіт Підсвіття",
        ["Nether Gem (Provided)"] = "самоцвіт Підсвіття (видано)",
    },
    [412] = {
        ["Gyromechanic Gear"] = "гіромеханічна шестірня",
        ["Restabilization Cog"] = "зубець рестабілізації",
    },
    [413] = {
        ["Barrel of Shimmer Stout"] = "барильце \"Мерехтливого стаута\"",
        ["Barrel of Shimmer Stout (Provided)"] = "барильце \"Мерехтливого стаута\" (видано)",
    },
    [414] = {
        ["Cask of Shimmer Stout"] = "барильце Мерехтливого стаута",
        ["Cask of Shimmer Stout (Provided)"] = "барильце Мерехтливого стаута (видано)",
    },
    [416] = {
        ["Tunnel Rat Ear"] = "вухо тунельного щура",
    },
    [417] = {
        ["Hildelve's Journal"] = "щоденник Гілдельва",
        ["Hildelve's Journal (Provided)"] = "щоденник Гілдельва (видано)",
        ["Mangy Claw"] = "зчесаний кіготь",
    },
    [418] = {
        ["Bear Meat"] = "м'ясо ведмедя",
        ["Boar Intestines"] = "кишки кнура",
        ["Spider Ichor"] = "лімфа павука",
    },
    [420] = {
        ["Grelin's Report"] = "звіт Ґреліна",
        ["Grelin's Report (Provided)"] = "звіт Ґреліна (видано)",
    },
    [421] = {
        ["Moonrage Whitescalp slain"] = "білоскальп Місяцесказу: убито",
    },
    [422] = {
        ["Remedy of Arugal"] = "\"Засіб Аруґала\"",
    },
    [423] = {
        ["Darksoul Shackle"] = "кайдани темнодуха",
        ["Glutton Shackle"] = "кайдани ненажери",
    },
    [424] = {
        ["Head of Grimson"] = "голова Ґрімсона",
    },
    [425] = {
        ["Ivar's Head"] = "голова Айвара",
    },
    [426] = {
        ["Blackened Skull"] = "почорнілий череп",
        ["Notched Rib"] = "надщерблене ребро",
    },
    [427] = {
        ["Scarlet Warrior slain"] = "воїн Багряного Походу: убито",
    },
    [429] = {
        ["Discolored Worg Heart"] = "знебарвлене серце ворга",
    },
    [430] = {
        ["Minor Quinn's Potion"] = "мале Квіннове зілля",
        ["Minor Quinn's Potion (Provided)"] = "мале Квіннове зілля (видано)",
    },
    [432] = {
        ["Rockjaw Skullthumper slain"] = "кам'янощелепий череполом: убито",
    },
    [433] = {
        ["Rockjaw Bonesnapper slain"] = "кам'янощелепий кісткохруст: убито",
    },
    [434] = {
        ["Lord Gregor Lescovar slain"] = "лорд Грегор Лесковар: убито",
        ["Marzon the Silent Blade slain"] = "Марзон Тихе Лезо: убито",
        ["Overhear Lescovar and Marzon's Conversation"] = "Підслухайте розмову Лесковара й Марзона",
    },
    [435] = {
        ["Erland must reach Rane Yorick"] = "Ерланд має дістатися Рейни Йорік",
    },
    [437] = {
        ["Enter the Dead Fields"] = "Увійдіть на Мертві поля",
        ["Essence of Nightlash"] = "сутність Нічнохльостки",
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [439] = {
        ["Deliah's Ring"] = "перстень Делії",
        ["Deliah's Ring (Provided)"] = "перстень Делії (видано)",
    },
    [440] = {
        ["Deliah's Ring"] = "перстень Делії",
        ["Deliah's Ring (Provided)"] = "перстень Делії (видано)",
    },
    [441] = {
        ["Deliah's Ring"] = "перстень Делії",
        ["Deliah's Ring (Provided)"] = "перстень Делії (видано)",
    },
    [442] = {
        ["Thule's Head"] = "голова Тула",
    },
    [443] = {
        ["Rot Hide Ichor"] = "пасока Гнилошкурих",
    },
    [444] = {
        ["Sample Ichor"] = "зразок пасоки",
        ["Sample Ichor (Provided)"] = "зразок пасоки (видано)",
    },
    [445] = {
        ["Johaan's Findings"] = "дослідження Йогаана",
        ["Johaan's Findings (Provided)"] = "дослідження Йогаана (видано)",
    },
    [446] = {
        ["Bethor's Scroll"] = "сувій Бетора",
        ["Bethor's Scroll (Provided)"] = "сувій Бетора (видано)",
    },
    [447] = {
        ["Grizzled Bear Heart"] = "серце посивілого ведмедя",
        ["Skittering Blood"] = "дріботлива кров",
    },
    [449] = {
        ["Deathstalker Report"] = "звіт смертоловів",
        ["Deathstalker Report (Provided)"] = "звіт смертоловів (видано)",
    },
    [450] = {
        ["Berard's Journal"] = "щоденник Берарда",
    },
    [451] = {
        ["Hardened Tumor"] = "затверділа пухлина",
        ["Lake Creeper Moss"] = "мох озерного підкрадача",
        ["Lake Skulker Moss"] = "мох озерного тайноходця",
    },
    [452] = {
        ["Aid Faerleia in killing the Pyrewood Council"] = "Допоможіть Фарлеї вбити раду Поховальних Вогнищ",
    },
    [453] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [455] = {
        ["Dragonmaw Grunt slain"] = "бугай Драконової Пащі: убито",
        ["Dragonmaw Scout slain"] = "розвідник Драконової Пащі: убито",
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Traverse Dun Algaz"] = "Пройдіть через Дун-Альґаз",
    },
    [456] = {
        ["Young Nightsaber slain"] = "молодий ночезуб: убито",
        ["Young Thistle Boar slain"] = "молодий татарний кнур: убито",
    },
    [457] = {
        ["Mangy Nightsaber slain"] = "коростяний ночезуб: убито",
        ["Thistle Boar slain"] = "татарний кнур: убито",
    },
    [459] = {
        ["Fel Moss"] = "мох скверни",
    },
    [460] = {
        ["A Talking Head"] = "балакуча голова",
        ["A Talking Head (Provided)"] = "балакуча голова (видано)",
    },
    [461] = {
        ["Alaric's Remains"] = "останки Аларіка",
        ["Alaric's Remains (Provided)"] = "останки Аларіка (видано)",
    },
    [462] = {
        ["Ma'ruk Wyrmscale slain"] = "Ма'рук Змієлуска: убито",
    },
    [464] = {
        ["Dragonmaw War Banner"] = "бойове знамено Драконової Пащі",
    },
    [465] = {
        ["Dwarven Tinder"] = "дворфійський трут",
        ["Dwarven Tinder (Provided)"] = "дворфійський трут (видано)",
    },
    [466] = {
        ["Incendicite Ore"] = "спалахітова руда",
    },
    [469] = {
        ["Bundle of Crocolisk Skins"] = "оберемок кроколіскових шкір",
        ["Bundle of Crocolisk Skins (Provided)"] = "оберемок кроколіскових шкір (видано)",
    },
    [470] = {
        ["Sida's Bag"] = "сумка Сіди",
    },
    [471] = {
        ["Giant Crocolisk Skin"] = "шкура гігантського кроколіска",
    },
    [474] = {
        ["Nek'rosh's Head"] = "голова Нек'роша",
    },
    [478] = {
        ["Rune-inscribed Pendant"] = "покритий рунами кулон",
        ["Rune-inscribed Pendant (Provided)"] = "покритий рунами кулон (видано)",
    },
    [479] = {
        ["Dalaran Pendant"] = "даларанський кулон",
    },
    [480] = {
        ["Ataeric's Staff"] = "посох Атеріка",
    },
    [481] = {
        ["Rune-inscribed Pendant"] = "покритий рунами кулон",
        ["Rune-inscribed Pendant (Provided)"] = "покритий рунами кулон (видано)",
    },
    [483] = {
        ["Black Feather Quill"] = "чорне перо",
        ["Raven Claw Talisman"] = "талісман Воронячого Пазура",
        ["Rune of Nesting"] = "руна Гніздування",
        ["Sapphire of Sky"] = "сапфір небес",
    },
    [484] = {
        ["Young Crocolisk Skin"] = "шкура молодого кроколіска",
    },
    [485] = {
        ["OOX-09/HL Distress Beacon"] = "аварійний маяк OOX-09/ВЗ",
        ["OOX-09/HL Distress Beacon (Provided)"] = "аварійний маяк OOX-09/ВЗ (видано)",
    },
    [486] = {
        ["Ursal the Mauler slain"] = "Урсал Молотобій: убито",
    },
    [487] = {
        ["Gnarlpine Ambusher slain"] = "душитель Кривої Сосни: убито",
    },
    [488] = {
        ["Nightsaber Fang"] = "ікло ночезуба",
        ["Strigid Owl Feather"] = "пір'їна сови",
        ["Webwood Spider Silk"] = "павутиннолісий шовк",
    },
    [489] = {
        ["Fel Cone"] = "осквернена шишка",
    },
    [490] = {
        ["Gnarlpine Fang"] = "ікло хутропуза Кривої Сосни",
    },
    [491] = {
        ["Woven Wand"] = "сплетений жезл",
        ["Woven Wand (Provided)"] = "сплетений жезл (видано)",
    },
    [492] = {
        ["Johaan's Special Drink"] = "особливий напій Йогаана",
        ["Johaan's Special Drink (Provided)"] = "особливий напій Йогаана (видано)",
    },
    [493] = {
        ["Renferrel's Findings"] = "дані досліджень Ренферрела",
        ["Renferrel's Findings (Provided)"] = "дані досліджень Ренферрела (видано)",
    },
    [496] = {
        ["Creeper Ichor"] = "пасока підкрадача",
        ["Gray Bear Tongue"] = "язик сірого ведмедя",
    },
    [498] = {
        ["Burnished Gold Key"] = "полірований золотий ключ",
        ["Dull Iron Key"] = "тьмяний залізний ключ",
        ["Rescue Drull"] = "Звільніть Друлла",
        ["Rescue Tog'thar"] = "Звільніть Тоґ'тара",
    },
    [499] = {
        ["Elixir of Suffering"] = "еліксир страждання",
        ["Elixir of Suffering (Provided)"] = "еліксир страждання (видано)",
    },
    [500] = {
        ["Dirty Knucklebones"] = "брудні паці",
    },
    [501] = {
        ["Mountain Lion Blood"] = "кров гірського лева",
    },
    [502] = {
        ["Elixir of Pain"] = "еліксир болю",
        ["Elixir of Pain (Provided)"] = "еліксир болю (видано)",
    },
    [503] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Find where Gol'dir is being held"] = "Знайдіть місце ув'язнення Ґол'діра",
        ["Rusted Iron Key"] = "іржавий залізний ключ",
    },
    [504] = {
        ["Crushridge Warmonger slain"] = "скелеламський войовник: убито",
    },
    [505] = {
        ["Syndicate Footpad slain"] = "харциз Синдикату: убито",
        ["Syndicate Thief slain"] = "злодій Синдикату: убито",
    },
    [507] = {
        ["Lord Aliden Perenolde slain"] = "лорд Аліден Перенольд: убито",
    },
    [508] = {
        ["Taretha's Necklace"] = "намисто Тарети",
        ["Taretha's Necklace (Provided)"] = "намисто Тарети (видано)",
    },
    [509] = {
        ["Mudsnout Blossoms"] = "квітка Брудномордих",
    },
    [510] = {
        ["Foreboding Plans"] = "лиховісні плани",
        ["Foreboding Plans (Provided)"] = "лиховісні плани (видано)",
    },
    [511] = {
        ["Cleverly Encrypted Letter"] = "кмітливо зашифрований лист",
        ["Cleverly Encrypted Letter (Provided)"] = "кмітливо зашифрований лист (видано)",
    },
    [512] = {
        ["Alterac Signet Ring"] = "альтерацька печатка",
    },
    [513] = {
        ["Mudsnout Composite"] = "суміш Брудномордих",
        ["Mudsnout Composite (Provided)"] = "суміш Брудномордих (видано)",
    },
    [514] = {
        ["Cleverly Encrypted Letter"] = "кмітливо зашифрований лист",
        ["Cleverly Encrypted Letter (Provided)"] = "кмітливо зашифрований лист (видано)",
    },
    [515] = {
        ["Daggerspine Scale"] = "луска клинкоспинної наги",
        ["Lesser Troll's Blood Elixir"] = "малий еліксир крові троля",
        ["Mudsnout Mixture"] = "розчин Брудномордих",
        ["Mudsnout Mixture (Provided)"] = "розчин Брудномордих (видано)",
        ["Torn Fin Eye"] = "око мурлока Розірваного Плавника",
    },
    [516] = {
        ["Ravenclaw Drudger slain"] = "чорнороб Воронокігтя: убито",
        ["Ravenclaw Guardian slain"] = "вартовий Воронокігтя: убито",
    },
    [517] = {
        ["Keg of Shindigger Stout"] = "барильце \"Землекопського міцного\"",
    },
    [518] = {
        ["Crushridge Mauler slain"] = "скелеламський молотобій: убито",
    },
    [519] = {
        ["Glommus's Head"] = "голова Ґломмуса",
        ["Muckrake's Head"] = "голова Брудня",
        ["Targ's Head"] = "голова Тарґа",
    },
    [520] = {
        ["Crown of Will"] = "корона Волі",
        ["Mug'thol's Head"] = "голова Муґ'Тола",
    },
    [521] = {
        ["Crown of Will"] = "корона Волі",
        ["Crown of Will (Provided)"] = "корона Волі (видано)",
    },
    [522] = {
        ["Assassin's Contract"] = "контракт вбивці",
        ["Assassin's Contract (Provided)"] = "контракт вбивці (видано)",
    },
    [523] = {
        ["Head of Baron Vardus"] = "голова барона Вардуса",
    },
    [524] = {
        ["Tainted Keg"] = "зіпсоване барильце",
        ["Tainted Keg (Provided)"] = "зіпсоване барильце (видано)",
    },
    [525] = {
        ["Decrypted Letter"] = "розшифрований лист",
        ["Decrypted Letter (Provided)"] = "розшифрований лист (видано)",
    },
    [526] = {
        ["Lightforge Ingot"] = "злиток світлосталі",
    },
    [527] = {
        ["Farmer Getz slain"] = "фермер Ґетц: убито",
        ["Farmer Ray slain"] = "фермер Рей: убито",
        ["Hillsbrad Farmer slain"] = "гіллзбрадський фермер: убито",
        ["Hillsbrad Farmhand slain"] = "гіллзбрадський робітник: убито",
    },
    [528] = {
        ["Hillsbrad Peasant slain"] = "гіллзбрадський селянин: убито",
    },
    [529] = {
        ["Blacksmith Verringtan slain"] = "коваль Веррінґтан: убито",
        ["Hillsbrad Apprentice Blacksmith slain"] = "гіллзбрадський учень коваля: убито",
        ["Shipment of Iron"] = "партія заліза",
    },
    [530] = {
        ["Valdred's Hands"] = "руки Валдреда",
    },
    [531] = {
        ["Ol' Sooty's Head"] = "голова старого Чорниша",
        ["Ol' Sooty's Head (Provided)"] = "голова старого Чорниша (видано)",
    },
    [532] = {
        ["Hillsbrad Councilman slain"] = "гіллзбрадський радник: убито",
        ["Hillsbrad Proclamation destroyed"] = "прокламацію Гіллзбраду знищено",
        ["Hillsbrad Town Registry"] = "реєстр Гіллзбраду",
        ["Magistrate Burnside slain"] = "війт Шкваростін: убито",
    },
    [533] = {
        ["Syndicate Missive"] = "послання Синдикату",
    },
    [535] = {
        ["Southshore Stout"] = "південнобережне міцне",
    },
    [536] = {
        ["Torn Fin Oracle slain"] = "оракул Розірваного Плавника: убито",
        ["Torn Fin Tidehunter slain"] = "хвилелов Розірваного Плавника: убито",
    },
    [537] = {
        ["Argus Shadow Mage slain"] = "арґуський тіньовий маг: убито",
        ["Head of Nagaz"] = "голова Наґаза",
    },
    [539] = {
        ["Foreman Bonds slain"] = "десятник Бондс: убито",
        ["Hillsbrad Miner slain"] = "гіллзбрадський шахтар: убито",
    },
    [540] = {
        ["Recovered Tome"] = "врятований том",
        ["Worn Leather Book"] = "потерта шкіряна книга",
    },
    [541] = {
        ["Captain Ironhill slain"] = "капітан Залізопагорб: убито",
        ["Dun Garok Mountaineer slain"] = "дун-ґароцький горянин: убито",
        ["Dun Garok Priest slain"] = "дун-ґароцький жрець: убито",
        ["Dun Garok Rifleman slain"] = "дун-ґароцький стрілець: убито",
    },
    [542] = {
        ["Tomes of Alterac"] = "альтерацькі томи",
        ["Tomes of Alterac (Provided)"] = "альтерацькі томи (видано)",
    },
    [543] = {
        ["Perenolde Tiara"] = "тіара Перенольдів",
    },
    [544] = {
        ["Bloodstone Marble"] = "кулька з кривавого каменю",
        ["Bloodstone Oval"] = "овал з кривавого каменю",
        ["Bloodstone Shard"] = "осколок з кривавого каменю",
        ["Bloodstone Wedge"] = "клин з кривавого каменю",
    },
    [545] = {
        ["Dalaran Summoner slain"] = "даларанський закликач: убито",
        ["Elemental Slave slain"] = "елементаль-невільник: убито",
    },
    [546] = {
        ["Hillsbrad Human Skull"] = "людський череп з Гіллзбраду",
    },
    [547] = {
        ["Humbert's Sword"] = "меч Гумберта",
    },
    [549] = {
        ["Syndicate Rogue slain"] = "пройдисвіт Синдикату: убито",
        ["Syndicate Watchman slain"] = "вартовий Синдикату: убито",
    },
    [550] = {
        ["Darthalia's Sealed Commendation"] = "запечатана грамота Дарталії",
        ["Darthalia's Sealed Commendation (Provided)"] = "запечатана грамота Дарталії (видано)",
    },
    [551] = {
        ["Ensorcelled Parchment"] = "зачаклований пергамент",
        ["Ensorcelled Parchment (Provided)"] = "зачаклований пергамент (видано)",
    },
    [552] = {
        ["Helcular's Rod"] = "жезл Гелькулара",
    },
    [553] = {
        ["Flame of Azel charged"] = "полум'я Азеля заряджено",
        ["Flame of Uzel charged"] = "полум'я Узеля заряджено",
        ["Flame of Veraz charged"] = "полум'я Вераза заряджено",
        ["Rod of Helcular"] = "жезл Гелькулара",
        ["Rod of Helcular (Provided)"] = "жезл Гелькулара (видано)",
    },
    [554] = {
        ["Ensorcelled Parchment"] = "зачаклований пергамент",
        ["Ensorcelled Parchment (Provided)"] = "зачаклований пергамент (видано)",
    },
    [555] = {
        ["Soothing Spices"] = "духмяні спеції",
        ["Turtle Meat"] = "черепашаче м'ясо",
    },
    [556] = {
        ["Worn Stone Token"] = "потертий кам'яний талісман",
    },
    [557] = {
        ["Bracers of Earth Binding"] = "зв'язувальні браслети землі",
    },
    [558] = {
        ["Jaina's Autograph"] = "автограф Джайни",
    },
    [559] = {
        ["Murloc Head"] = "голова мурлока",
    },
    [560] = {
        ["Sack of Murloc Heads"] = "мішок голів мурлоків",
        ["Sack of Murloc Heads (Provided)"] = "мішок голів мурлоків (видано)",
    },
    [562] = {
        ["Daggerspine Shorehunter slain"] = "береговий мисливець Клинкоспинів: убито",
        ["Daggerspine Siren slain"] = "сирена Клинкоспинів: убито",
    },
    [563] = {
        ["Farren's Report"] = "звіт Фаррена",
        ["Farren's Report (Provided)"] = "звіт Фаррена (видано)",
    },
    [564] = {
        ["Hulking Mountain Lion slain"] = "масивний гірський лев: убито",
        ["Mountain Lion slain"] = "гірський лев: убито",
    },
    [565] = {
        ["Bolt of Woolen Cloth"] = "рулон вовняної тканини",
        ["Fine Thread"] = "тонка нитка",
        ["Hillman's Cloak"] = "накидка жителя пагорбів",
        ["Yeti Fur"] = "хутро єті",
    },
    [566] = {
        ["Head of Baron Vardus"] = "голова барона Вардуса",
    },
    [567] = {
        ["Citizen Wilkes slain"] = "містянин Вілкс: убито",
        ["Clerk Horrace Whitesteed slain"] = "писар Горацій Білокінь: убито",
        ["Farmer Kalaba slain"] = "фермерка Калаба: убито",
        ["Miner Hackett slain"] = "шахтар Гаккет: убито",
    },
    [568] = {
        ["Lashtail Raptor slain"] = "хлястохвостий раптор: убито",
    },
    [569] = {
        ["Mosh'Ogg Brute slain"] = "мош'оґґський моцак: убито",
        ["Mosh'Ogg Witch Doctor slain"] = "мош'оґґський знахар: убито",
    },
    [570] = {
        ["Pristine Tigress Fang"] = "бездоганне ікло тигриці",
        ["Shadowmaw Claw"] = "пазур тінепащої пантери",
    },
    [571] = {
        ["Aged Gorilla Sinew"] = "сухожилля старої горили",
    },
    [572] = {
        ["Jungle Stalker Feather"] = "перо ловця джунглів",
    },
    [573] = {
        ["Holy Spring Water"] = "вода святого джерела",
        ["Naga Explorer slain"] = "нага-дослідник: убито",
    },
    [574] = {
        ["Kurzen Commando slain"] = "командос Курцена: убито",
        ["Kurzen Headshrinker slain"] = "головодав Курцена: убито",
    },
    [575] = {
        ["Large River Crocolisk Skin"] = "велика шкура річкового кроколіска",
    },
    [576] = {
        ["Dizzy's Eye"] = "око Запаморока",
    },
    [577] = {
        ["Snapjaw Crocolisk Skin"] = "шкура кроколіска-тріскощелепа",
    },
    [578] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Locate the haunted island"] = "Знайдіть острів з духами",
    },
    [579] = {
        ["Library Scrip"] = "бібліотечний сувій",
    },
    [580] = {
        ["Pupellyverbos Port"] = "портвейн \"Пупеллівербос\"",
    },
    [581] = {
        ["Bloodscalp Tusk"] = "ікло Кровоскальпого",
    },
    [582] = {
        ["Shrunken Head"] = "сушена голова",
    },
    [584] = {
        ["Gan'zulah's Head"] = "голова Ґан'зули",
        ["Nezzliok's Head"] = "голова Неззліока",
    },
    [585] = {
        ["Balia'mah Trophy"] = "трофей з Баліа'ма",
        ["Ziata'jai Trophy"] = "трофей з Зіата'джай",
        ["Zul'Mamwe Trophy"] = "трофей з Зул'Мамве",
    },
    [586] = {
        ["Broken Armor of Ana'thek"] = "розтрощені обладунки Ана'тека",
        ["Skullsplitter Berserker slain"] = "берсерк Черепотрощителів: убито",
        ["Skullsplitter Headhunter slain"] = "мисливець за головами Черепотрощителів: убито",
        ["Skullsplitter Hunter slain"] = "мисливець Черепотрощителів: убито",
    },
    [587] = {
        ["Snuff"] = "понюшка тютюну",
    },
    [589] = {
        ["Pulsing Blue Shard"] = "пульсуючий блакитний осколок",
    },
    [590] = {
        ["Defeat Calvin Montague"] = "Здолайте Кальвіна Монтеґ'ю",
    },
    [591] = {
        ["Mind's Eye"] = "Око Розуму",
    },
    [592] = {
        ["Filled Soul Gem"] = "наповнений камінь душі",
    },
    [593] = {
        ["Soul Gem"] = "камінь душі",
    },
    [596] = {
        ["Bloody Bone Necklace"] = "намисто з кривавих кісток",
    },
    [598] = {
        ["Split Bone Necklace"] = "намисто з розщеплених кісток",
    },
    [600] = {
        ["Singing Blue Crystal"] = "співочий блакитний кристал",
    },
    [601] = {
        ["Water Elemental Bracers"] = "браслет водяного елементаля",
    },
    [602] = {
        ["Bag of Water Elemental Bracers"] = "мішок з браслетами водяних елементалів",
        ["Bag of Water Elemental Bracers (Provided)"] = "мішок з браслетами водяних елементалів (видано)",
    },
    [604] = {
        ["Bloodsail Charts"] = "карти Кривавого Вітрила",
        ["Bloodsail Orders"] = "накази Кривавого Вітрила",
        ["Bloodsail Swashbuckler slain"] = "шибайголова Кривавого Вітрила: убито",
    },
    [605] = {
        ["Singing Crystal Shard"] = "осколок співочого кристала",
    },
    [606] = {
        ["Mistvale Giblets"] = "потрухи туманодільної горили",
    },
    [607] = {
        ["Shaky's Payment"] = "борг Полохуна",
        ["Shaky's Payment (Provided)"] = "борг Полохуна (видано)",
    },
    [608] = {
        ["Captain Keelhaul slain"] = "капітан Кілетяг: убито",
        ["Captain Stillwater slain"] = "капітан Море-по-коліно: убито",
        ["Fleet Master Firallon slain"] = "командувач флоту Фіраллон: убито",
    },
    [609] = {
        ["Chucky's Huge Ring"] = "величезний перстень Чакі",
        ["Jon-Jon's Golden Spyglass"] = "золота підзорна труба Джон-Джона",
        ["Maury's Clubbed Foot"] = "дерев'яна нога Морі",
    },
    [610] = {
        ["Catelyn's Blade"] = "кинджал Кателіни",
    },
    [611] = {
        ["Catelyn's Blade"] = "кинджал Кателіни",
        ["Catelyn's Blade (Provided)"] = "кинджал Кателіни (видано)",
        ["Stone of the Tides"] = "камінь припливів",
    },
    [613] = {
        ["Maury's Key"] = "ключ Морі",
    },
    [614] = {
        ["Smotts' Chest"] = "скриня Смоттса",
    },
    [617] = {
        ["Akiris Reed"] = "стебло акіріса",
    },
    [618] = {
        ["Smotts' Cutlass"] = "шабля Смоттса",
    },
    [619] = {
        ["Barbecued Buzzard Wing"] = "смажене крильце канюка",
        ["Junglevine Wine"] = "вино з джунглів",
    },
    [620] = {
        ["Monogrammed Sash"] = "пояс з монограмою",
        ["Monogrammed Sash (Provided)"] = "пояс з монограмою (видано)",
    },
    [621] = {
        ["Zanzil's Mixture"] = "суміш Занзіла",
    },
    [622] = {
        ["Krazek's Fixed Pot"] = "відремонтований горщик Кронжека",
        ["Krazek's Fixed Pot (Provided)"] = "відремонтований горщик Кронжека (видано)",
    },
    [623] = {
        ["Bundle of Akiris Reeds"] = "в'язка стеблин акіріса",
        ["Bundle of Akiris Reeds (Provided)"] = "в'язка стеблин акіріса (видано)",
    },
    [627] = {
        ["Lesser Bloodstone Ore"] = "мала руда кривавого каменю",
    },
    [628] = {
        ["Elder Crocolisk Skin"] = "шкура старого кроколіска",
    },
    [629] = {
        ["Tablet Shard"] = "уламок скрижалі",
    },
    [630] = {
        ["Shackle Key"] = "ключ від кайданів",
    },
    [632] = {
        ["Deepfury's Orders"] = "накази Темнолюта",
        ["Deepfury's Orders (Provided)"] = "накази Темнолюта (видано)",
    },
    [633] = {
        ["Cache of Explosives Destroyed"] = "сховок з вибухівкою знищено",
    },
    [635] = {
        ["Pendant of Myzrael"] = "кулон Мізраель",
    },
    [637] = {
        ["Sully Balloo's Letter"] = "лист Саллі Баллу",
        ["Sully Balloo's Letter (Provided)"] = "лист Саллі Баллу (видано)",
    },
    [639] = {
        ["Sigil of Strom"] = "сигіла Строма",
        ["Sigil of Strom (Provided)"] = "сигіла Строма (видано)",
    },
    [640] = {
        ["Sigil Fragment"] = "фрагмент сигіли",
        ["Sigil Fragment (Provided)"] = "фрагмент сигіли (видано)",
    },
    [641] = {
        ["Sigil of Thoradin"] = "сигіла Торадіна",
        ["Sigil of Thoradin (Provided)"] = "сигіла Торадіна (видано)",
    },
    [642] = {
        ["Mote of Myzrael"] = "порошинка Мізраель",
        ["Mote of Myzrael (Provided)"] = "порошинка Мізраель (видано)",
    },
    [643] = {
        ["Sigil of Arathor"] = "сигіла Аратора",
        ["Sigil of Arathor (Provided)"] = "сигіла Аратора (видано)",
    },
    [644] = {
        ["Sigil of Trollbane"] = "сигіла Тролебоя",
        ["Sigil of Trollbane (Provided)"] = "сигіла Тролебоя (видано)",
    },
    [645] = {
        ["Sigil of Ignaeus"] = "сигіла Іґная",
        ["Sigil of Ignaeus (Provided)"] = "сигіла Іґная (видано)",
    },
    [646] = {
        ["Sheathed Trol'kalar"] = "Трол'Калар в піхвах",
        ["Sheathed Trol'kalar (Provided)"] = "Трол'Калар в піхвах (видано)",
    },
    [647] = {
        ["MacKreel's Moonshine"] = "самогон Мак-Кріла",
        ["MacKreel's Moonshine (Provided)"] = "самогон Мак-Кріла (видано)",
    },
    [651] = {
        ["Burning Key"] = "палаючий ключ",
        ["Burning Key (Provided)"] = "палаючий ключ (видано)",
        ["Cresting Key"] = "бурунистий ключ",
        ["Cresting Key (Provided)"] = "бурунистий ключ (видано)",
        ["Thundering Key"] = "буревійний ключ",
        ["Thundering Key (Provided)"] = "буревійний ключ (видано)",
    },
    [652] = {
        ["Rod of Order"] = "скіпетр порядку",
        ["Rod of Order (Provided)"] = "скіпетр порядку (видано)",
    },
    [654] = {
        ["Acceptable Basilisk Sample"] = "прийнятний зразок василіска",
        ["Acceptable Basilisk Sample (Provided)"] = "прийнятний зразок василіска (видано)",
        ["Acceptable Hyena Sample"] = "прийнятний зразок гієни",
        ["Acceptable Hyena Sample (Provided)"] = "прийнятний зразок гієни (видано)",
        ["Acceptable Scorpid Sample"] = "прийнятний зразок скорпіда",
        ["Acceptable Scorpid Sample (Provided)"] = "прийнятний зразок скорпіда (видано)",
        ["Field Testing Kit"] = "набір для польових досліджень",
        ["Field Testing Kit (Provided)"] = "набір для польових досліджень (видано)",
    },
    [656] = {
        ["Eldritch Shackles"] = "таємничі кайдани",
        ["Eldritch Shackles (Provided)"] = "таємничі кайдани (видано)",
    },
    [658] = {
        ["Sealed Folder"] = "запечатана тека",
        ["Sealed Folder (Provided)"] = "запечатана тека (видано)",
    },
    [662] = {
        ["Maiden's Folly Charts"] = "карта з \"Дівочої примхи\"",
        ["Maiden's Folly Charts (Provided)"] = "карта з \"Дівочої примхи\" (видано)",
        ["Maiden's Folly Log"] = "журнал \"Дівочої примхи\"",
        ["Maiden's Folly Log (Provided)"] = "журнал \"Дівочої примхи\" (видано)",
        ["Spirit of Silverpine Charts"] = "карта з \"Духу Срібнохвою\"",
        ["Spirit of Silverpine Charts (Provided)"] = "карта з \"Духу Срібнохвою\" (видано)",
        ["Spirit of Silverpine Log"] = "журнал \"Духу Срібнохвою\"",
        ["Spirit of Silverpine Log (Provided)"] = "журнал \"Духу Срібнохвою\" (видано)",
    },
    [664] = {
        ["Daggerspine Raider"] = "рейдер Клинкоспинів",
        ["Daggerspine Raider slain"] = "рейдер Клинкоспинів: убито",
        ["Daggerspine Sorceress"] = "чарівниця Клинкоспинів",
        ["Daggerspine Sorceress slain"] = "чарівниця Клинкоспинів: убито",
    },
    [666] = {
        ["Elven Gem"] = "ельфійський самоцвіт",
        ["Elven Gem (Provided)"] = "ельфійський самоцвіт (видано)",
        ["Goggles of Gem Hunting"] = "окуляри для пошуку самоцвітів",
        ["Goggles of Gem Hunting (Provided)"] = "окуляри для пошуку самоцвітів (видано)",
    },
    [668] = {
        ["Elven Gems"] = "ельфійські самоцвіти",
        ["Elven Gems (Provided)"] = "ельфійські самоцвіти (видано)",
    },
    [669] = {
        ["Sample Elven Gem"] = "зразок ельфійського самоцвіту",
        ["Sample Elven Gem (Provided)"] = "зразок ельфійського самоцвіту (видано)",
    },
    [670] = {
        ["Seahorn's Sealed Letter"] = "запечатаний лист Морського Рога",
        ["Seahorn's Sealed Letter (Provided)"] = "запечатаний лист Морського Рога (видано)",
    },
    [671] = {
        ["Bloodstone Amulet"] = "амулет з кривавого каменю",
        ["Bloodstone Amulet (Provided)"] = "амулет з кривавого каменю (видано)",
    },
    [672] = {
        ["Highland Raptor Eye"] = "око плоскогірного раптора",
        ["Highland Raptor Eye (Provided)"] = "око плоскогірного раптора (видано)",
    },
    [673] = {
        ["Befouled Bloodstone Orb"] = "мерзенна сфера з кривавого каменю",
        ["Befouled Bloodstone Orb (Provided)"] = "мерзенна сфера з кривавого каменю (видано)",
    },
    [674] = {
        ["Raptor Talon Amulet"] = "амулет із пазура раптора",
        ["Raptor Talon Amulet (Provided)"] = "амулет із пазура раптора (видано)",
    },
    [676] = {
        ["Boulderfist Enforcer"] = "брилорукий громило",
        ["Boulderfist Enforcer slain"] = "брилорукий громило: убито",
        ["Boulderfist Ogre"] = "брилорукий огр",
        ["Boulderfist Ogre slain"] = "брилорукий огр: убито",
    },
    [677] = {
        ["Witherbark Axe Thrower"] = "сокирожбур Зів'ялої Кори",
        ["Witherbark Axe Thrower slain"] = "сокирожбур Зів'ялої Кори: убито",
        ["Witherbark Headhunter"] = "мисливець за головами Зів'ялої Кори",
        ["Witherbark Headhunter slain"] = "мисливець за головами Зів'ялої Кори: убито",
        ["Witherbark Witch Doctor"] = "знахар Зів'ялої Кори",
        ["Witherbark Witch Doctor slain"] = "знахар Зів'ялої Кори: убито",
    },
    [678] = {
        ["Boulderfist Brute"] = "брилорукий моцак",
        ["Boulderfist Brute slain"] = "брилорукий моцак: убито",
        ["Boulderfist Magus"] = "брилорукий чаклун",
        ["Boulderfist Magus slain"] = "брилорукий чаклун: убито",
    },
    [679] = {
        ["Boulderfist Lord"] = "брилорукий лорд",
        ["Boulderfist Lord slain"] = "брилорукий лорд: убито",
        ["Boulderfist Shaman"] = "брилорукий шаман",
        ["Boulderfist Shaman slain"] = "брилорукий шаман: убито",
    },
    [680] = {
        ["Or'Kalar's Head"] = "голова Ор'Калара",
        ["Or'Kalar's Head (Provided)"] = "голова Ор'Калара (видано)",
    },
    [681] = {
        ["Syndicate Highwayman"] = "нальотник Синдикату",
        ["Syndicate Highwayman slain"] = "нальотник Синдикату: убито",
        ["Syndicate Mercenary"] = "найманець Синдикату",
        ["Syndicate Mercenary slain"] = "найманець Синдикату: убито",
    },
    [682] = {
        ["Stromgarde Badge"] = "cтромвартський значок",
        ["Stromgarde Badge (Provided)"] = "cтромвартський значок (видано)",
    },
    [683] = {
        ["Sara Balloo's Plea"] = "прохання Сари Баллу",
        ["Sara Balloo's Plea (Provided)"] = "прохання Сари Баллу (видано)",
    },
    [684] = {
        ["Marez's Head"] = "голова Марез",
        ["Marez's Head (Provided)"] = "голова Марез (видано)",
    },
    [685] = {
        ["Falconcrest's Head"] = "голова Соколохресного",
        ["Falconcrest's Head (Provided)"] = "голова Соколохресного (видано)",
        ["Otto's Head"] = "голова Отто",
        ["Otto's Head (Provided)"] = "голова Отто (видано)",
    },
    [689] = {
        ["Alterac Granite"] = "альтерацький граніт",
        ["Alterac Granite (Provided)"] = "альтерацький граніт (видано)",
    },
    [691] = {
        ["Shadow Hunter Knife"] = "ніж темного мисливця",
        ["Shadow Hunter Knife (Provided)"] = "ніж темного мисливця (видано)",
        ["Witherbark Medicine Pouch"] = "мішечок з травами Зів'ялої Кори",
        ["Witherbark Medicine Pouch (Provided)"] = "мішечок з травами Зів'ялої Кори (видано)",
        ["Witherbark Tusk"] = "ікло троля Зів'ялої Кори",
        ["Witherbark Tusk (Provided)"] = "ікло троля Зів'ялої Кори (видано)",
    },
    [692] = {
        ["Crumpled Scroll Fragment"] = "м'ятий фрагмент сувою",
        ["Crumpled Scroll Fragment (Provided)"] = "м'ятий фрагмент сувою (видано)",
        ["Singed Scroll Fragment"] = "обпалений фрагмент сувою",
        ["Singed Scroll Fragment (Provided)"] = "обпалений фрагмент сувою (видано)",
        ["Torn Scroll Fragment"] = "рваний фрагмент сувою",
        ["Torn Scroll Fragment (Provided)"] = "рваний фрагмент сувою (видано)",
    },
    [693] = {
        ["Trelane's Wand of Invocation"] = "жезл Трелейна для виклику",
        ["Trelane's Wand of Invocation (Provided)"] = "жезл Трелейна для виклику (видано)",
    },
    [694] = {
        ["Azure Agate"] = "лазурний агат",
        ["Azure Agate (Provided)"] = "лазурний агат (видано)",
    },
    [696] = {
        ["Trelane's Ember Agate"] = "червоний агат Трелейна",
        ["Trelane's Ember Agate (Provided)"] = "червоний агат Трелейна (видано)",
        ["Trelane's Orb"] = "сфера Трелейна",
        ["Trelane's Orb (Provided)"] = "сфера Трелейна (видано)",
        ["Trelane's Phylactery"] = "філактерія Трелейна",
        ["Trelane's Phylactery (Provided)"] = "філактерія Трелейна (видано)",
    },
    [697] = {
        ["Sealed Letter to Archmage Malin"] = "запечатаний лист до архімага Маліна",
        ["Sealed Letter to Archmage Malin (Provided)"] = "запечатаний лист до архімага Маліна (видано)",
    },
    [698] = {
        ["Unprepared Sawtooth Flank"] = "сира вирізка пилкозуба",
        ["Unprepared Sawtooth Flank (Provided)"] = "сира вирізка пилкозуба (видано)",
    },
    [699] = {
        ["Sawtooth Snapper Claw"] = "пазур пилкозубого кусача",
        ["Sawtooth Snapper Claw (Provided)"] = "пазур пилкозубого кусача (видано)",
    },
    [701] = {
        ["Raptor Heart"] = "серце раптора",
        ["Raptor Heart (Provided)"] = "серце раптора (видано)",
    },
    [702] = {
        ["Tor'gan's Orb"] = "сфера Тор'ґана",
        ["Tor'gan's Orb (Provided)"] = "сфера Тор'ґана (видано)",
    },
    [703] = {
        ["Buzzard Wing"] = "крило канюка",
        ["Buzzard Wing (Provided)"] = "крило канюка (видано)",
    },
    [704] = {
        ["Carved Stone Urn"] = "різьблена кам'яна урна",
        ["Carved Stone Urn (Provided)"] = "різьблена кам'яна урна (видано)",
    },
    [705] = {
        ["Blue Pearl"] = "синя перлина",
        ["Blue Pearl (Provided)"] = "синя перлина (видано)",
    },
    [706] = {
        ["Black Drake's Heart"] = "серце чорного дракончика",
        ["Black Drake's Heart (Provided)"] = "серце чорного дракончика (видано)",
    },
    [708] = {
        ["Corroded Black Box"] = "заіржавілий чорний ящик",
        ["Corroded Black Box (Provided)"] = "заіржавілий чорний ящик (видано)",
    },
    [709] = {
        ["Tablet of Ryun'eh"] = "скрижаль Р'юн'еха",
        ["Tablet of Ryun'eh (Provided)"] = "скрижаль Р'юн'еха (видано)",
    },
    [710] = {
        ["Small Stone Shard"] = "маленький кам'яний осколок",
        ["Small Stone Shard (Provided)"] = "маленький кам'яний осколок (видано)",
    },
    [711] = {
        ["Large Stone Slab"] = "велика кам'яна брила",
        ["Large Stone Slab (Provided)"] = "велика кам'яна брила (видано)",
    },
    [712] = {
        ["Bracers of Rock Binding"] = "поручі зв'язування каменю",
        ["Bracers of Rock Binding (Provided)"] = "поручі зв'язування каменю (видано)",
    },
    [713] = {
        ["Frost Oil"] = "крижана олія",
        ["Frost Oil (Provided)"] = "крижана олія (видано)",
    },
    [714] = {
        ["Gyrochronatom"] = "гірохронатом",
        ["Gyrochronatom (Provided)"] = "гірохронатом (видано)",
    },
    [715] = {
        ["Healing Potion"] = "зілля лікування",
        ["Healing Potion (Provided)"] = "зілля лікування (видано)",
        ["Lesser Invisibility Potion"] = "зілля малої невидимості",
        ["Lesser Invisibility Potion (Provided)"] = "зілля малої невидимості (видано)",
    },
    [716] = {
        ["Patterned Bronze Bracers"] = "візерунчасті бронзові поручі",
        ["Patterned Bronze Bracers (Provided)"] = "візерунчасті бронзові поручі (видано)",
    },
    [717] = {
        ["Blacklash's Bindings"] = "наручники Чорнохлиста",
        ["Blacklash's Bindings (Provided)"] = "наручники Чорнохлиста (видано)",
        ["Chains of Hematus"] = "ланцюги Гемата",
        ["Chains of Hematus (Provided)"] = "ланцюги Гемата (видано)",
        ["Sign of the Earth"] = "знак Землі",
        ["Sign of the Earth (Provided)"] = "знак Землі (видано)",
    },
    [718] = {
        ["Supply Crate"] = "ящик з припасами",
        ["Supply Crate (Provided)"] = "ящик з припасами (видано)",
    },
    [719] = {
        ["Ryedol's Lucky Pick"] = "щасливе кайло Житника",
        ["Ryedol's Lucky Pick (Provided)"] = "щасливе кайло Житника (видано)",
    },
    [722] = {
        ["Hammertoe's Amulet"] = "амулет Молотопалого",
        ["Hammertoe's Amulet (Provided)"] = "амулет Молотопалого (видано)",
    },
    [723] = {
        ["Hammertoe's Amulet"] = "амулет Молотопалого",
        ["Hammertoe's Amulet (Provided)"] = "амулет Молотопалого (видано)",
    },
    [724] = {
        ["Hammertoe's Amulet"] = "амулет Молотопалого",
        ["Hammertoe's Amulet (Provided)"] = "амулет Молотопалого (видано)",
    },
    [725] = {
        ["Sealed Note to Advisor Belgrum"] = "записка для радника Белґрама",
        ["Sealed Note to Advisor Belgrum (Provided)"] = "записка для радника Белґрама (видано)",
    },
    [727] = {
        ["Sigil of the Hammer"] = "сигіла Молота",
        ["Sigil of the Hammer (Provided)"] = "сигіла Молота (видано)",
    },
    [728] = {
        ["Sigil of the Hammer"] = "сигіла Молота",
        ["Sigil of the Hammer (Provided)"] = "сигіла Молота (видано)",
    },
    [732] = {
        ["Sign of the Earth"] = "знак Землі",
        ["Sign of the Earth (Provided)"] = "знак Землі (видано)",
    },
    [733] = {
        ["Scrap Metal"] = "брухт",
        ["Scrap Metal (Provided)"] = "брухт (видано)",
    },
    [735] = {
        ["Hand of Dagun"] = "рука Даґуна",
        ["Hand of Dagun (Provided)"] = "рука Даґуна (видано)",
        ["Star of Xil'yeh"] = "зірка Ксіл'єх",
        ["Star of Xil'yeh (Provided)"] = "зірка Ксіл'єх (видано)",
        ["The Legacy Heart"] = "серце спадку",
        ["The Legacy Heart (Provided)"] = "серце спадку (видано)",
    },
    [736] = {
        ["Hand of Dagun"] = "рука Даґуна",
        ["Hand of Dagun (Provided)"] = "рука Даґуна (видано)",
        ["Star of Xil'yeh"] = "зірка Ксіл'єх",
        ["Star of Xil'yeh (Provided)"] = "зірка Ксіл'єх (видано)",
        ["The Legacy Heart"] = "серце спадку",
        ["The Legacy Heart (Provided)"] = "серце спадку (видано)",
    },
    [737] = {
        ["Yagyin's Digest"] = "збірник Яґіна",
        ["Yagyin's Digest (Provided)"] = "збірник Яґіна (видано)",
    },
    [739] = {
        ["Murdaloc"] = "Мурдалок",
        ["Murdaloc slain"] = "Мурдалок: убито",
        ["Stonevault Bonesnapper"] = "каменесклепий кісткохруст",
        ["Stonevault Bonesnapper slain"] = "каменесклепий кісткохруст: убито",
    },
    [741] = {
        ["Mysterious Fossil"] = "таємнича скам'янілість",
        ["Mysterious Fossil (Provided)"] = "таємнича скам'янілість (видано)",
    },
    [743] = {
        ["Windfury Talon"] = "кіготь Вітролютих",
        ["Windfury Talon (Provided)"] = "кіготь Вітролютих (видано)",
    },
    [744] = {
        ["Azure Feather"] = "лазурова пір'їна",
        ["Azure Feather (Provided)"] = "лазурова пір'їна (видано)",
        ["Bronze Feather"] = "бронзова пір'їна",
        ["Bronze Feather (Provided)"] = "бронзова пір'їна (видано)",
    },
    [745] = {
        ["Palemane Skinner"] = "бляклогривий шкуродер",
        ["Palemane Skinner slain"] = "бляклогривий шкуродер: убито",
        ["Palemane Tanner"] = "бляклогривий кожум'яка",
        ["Palemane Tanner slain"] = "бляклогривий кожум'яка: убито",
    },
    [746] = {
        ["Broken Tools"] = "зламані інструменти",
        ["Broken Tools (Provided)"] = "зламані інструменти (видано)",
    },
    [747] = {
        ["Plainstrider Feather"] = "пір'я рівнинобіга",
        ["Plainstrider Meat"] = "м'ясо рівнинобіга",
    },
    [748] = {
        ["Plainstrider Talon"] = "кіготь рівнинобіга",
        ["Prairie Wolf Paw"] = "лапа степового вовка",
    },
    [750] = {
        ["Mountain Cougar Pelt"] = "шкура гірської пуми",
    },
    [753] = {
        ["Water Pitcher"] = "глечик води",
    },
    [756] = {
        ["Cougar Claws"] = "пазурі пуми",
        ["Stalker Claws"] = "пазурі ловця",
    },
    [757] = {
        ["Bristleback Belt"] = "пояс Щетиношкурих",
    },
    [759] = {
        ["Prairie Alpha Tooth"] = "зуб степового альфи",
    },
    [761] = {
        ["Trophy Swoop Quill"] = "трофейна пір'їна хапуна",
    },
    [762] = {
        ["Ambassador Infernus' Bracer"] = "браслет посла Інферна",
    },
    [764] = {
        ["Venture Co. Supervisor slain"] = "керівник ТзНБ \"Авантюра\": убито",
        ["Venture Co. Worker slain"] = "робітник ТзНБ \"Авантюра\": убито",
    },
    [765] = {
        ["Fizsprocket's Clipboard"] = "записник Шуморакети",
    },
    [766] = {
        ["Flatland Cougar Femur"] = "стегнова кістка рівнинної пуми",
        ["Plainstrider Scale"] = "луска рівнинобіга",
        ["Prairie Wolf Heart"] = "серце степового вовка",
        ["Swoop Gizzard"] = "шлунок хапуна",
    },
    [768] = {
        ["Light Leather"] = "легка шкіра",
    },
    [769] = {
        ["Coarse Thread"] = "груба нитка",
        ["Light Leather"] = "легка шкіра",
    },
    [771] = {
        ["Ambercorn"] = "бурштинова насінина",
        ["Well Stone"] = "колодязний камінь",
    },
    [776] = {
        ["Horn of Arra'chea"] = "ріг Арра'чі",
    },
    [778] = {
        ["Lotwil's Shackles of Elemental Binding"] = "кайдани зв'язування стихій Лотвіля",
    },
    [779] = {
        ["Amethyst Runestone"] = "аметистовий рунічний камінь",
        ["Diamond Runestone"] = "діамантовий рунічний камінь",
        ["Opal Runestone"] = "опаловий рунічний камінь",
    },
    [780] = {
        ["Battleboar Flank"] = "вирізка бойового кнура",
        ["Battleboar Snout"] = "рило бойового кнура",
    },
    [782] = {
        ["Sign of the Earth"] = "знак Землі",
    },
    [784] = {
        ["Kul Tiras Marine slain"] = "кул-тіраський морський піхотинець: убито",
        ["Kul Tiras Sailor slain"] = "кул-тіраський моряк: убито",
        ["Lieutenant Benedict slain"] = "лейтенант Бенедикт: убито",
    },
    [788] = {
        ["Mottled Boar slain"] = "крапчастий кнур: убито",
    },
    [789] = {
        ["Scorpid Worker Tail"] = "хвіст скорпіда-робітника",
    },
    [790] = {
        ["Sarkoth's Mangled Claw"] = "понівечена клешня Саркота",
    },
    [791] = {
        ["Canvas Scraps"] = "уривки полотна",
    },
    [792] = {
        ["Vile Familiar slain"] = "паскудний фамільяр: убито",
    },
    [793] = {
        ["Blacklash's Bindings"] = "наручники Чорнохлиста",
        ["Chains of Hematus"] = "ланцюги Гемата",
    },
    [794] = {
        ["Burning Blade Medallion"] = "медальйон Палаючого Леза",
    },
    [795] = {
        ["Amethyst Runestone"] = "аметистовий рунічний камінь",
        ["Diamond Runestone"] = "діамантовий рунічний камінь",
        ["Opal Runestone"] = "опаловий рунічний камінь",
    },
    [806] = {
        ["Fizzle's Claw"] = "кіготь Фіззла",
    },
    [808] = {
        ["Minshina's Skull"] = "череп Міншини",
    },
    [812] = {
        ["Venomtail Antidote"] = "протиотрута з отрутохвоста",
    },
    [813] = {
        ["Venomtail Poison Sac"] = "отруйна залоза отрутохвоста",
    },
    [815] = {
        ["Taillasher Egg"] = "яйце хвостохляста",
    },
    [816] = {
        ["Kron's Amulet"] = "амулет Крона",
    },
    [817] = {
        ["Durotar Tiger Fur"] = "хутро дуротарського тигра",
    },
    [818] = {
        ["Crawler Mucus"] = "слиз повзуна",
        ["Intact Makrura Eye"] = "неушкоджене око макрури",
    },
    [821] = {
        ["Plainstrider Kidney"] = "нирка рівнинобіга",
        ["Savannah Lion Tusk"] = "ікло лева савани",
        ["Thunder Lizard Horn"] = "ріг громоящера",
    },
    [822] = {
        ["Kodo Liver"] = "печінка кодо",
        ["Lightning Gland"] = "громозалоза",
        ["Thunderhawk Saliva Gland"] = "слинна залоза громояструба",
    },
    [825] = {
        ["Gnomish Tools"] = "інструменти гномів",
    },
    [826] = {
        ["Hexed Troll slain"] = "зачарований троль: убито",
        ["Voodoo Troll slain"] = "троль вуду: убито",
        ["Zalazane's Head"] = "голова Залазейна",
    },
    [827] = {
        ["Searing Collar"] = "опалюючий нашийник",
    },
    [833] = {
        ["Bristleback Interloper slain"] = "щетиношкурий встрягач: убито",
    },
    [834] = {
        ["Sack of Supplies"] = "мішок з припасами",
    },
    [835] = {
        ["Dustwind Savage slain"] = "пиловійна дикунка: убито",
        ["Dustwind Storm Witch slain"] = "пиловійна штормовідьма: убито",
    },
    [837] = {
        ["Razormane Battleguard slain"] = "бритвогривий боєстраж: убито",
        ["Razormane Dustrunner slain"] = "бритвогривий пилобіг: убито",
        ["Razormane Quilboar slain"] = "бритвогривий свинобраз: убито",
        ["Razormane Scout slain"] = "бритвогривий розвідник: убито",
    },
    [841] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
    },
    [843] = {
        ["Bael'dun Excavator slain"] = "бель'дунський копач: убито",
        ["Bael'dun Foreman slain"] = "бель'дунський бригадир: убито",
        ["Khazgorm's Journal"] = "журнал Хазґорма",
    },
    [844] = {
        ["Plainstrider Beak"] = "дзьоб рівнинобіга",
    },
    [845] = {
        ["Zhevra Hooves"] = "копита жеври",
    },
    [846] = {
        ["Nitroglycerin"] = "нітрогліцерин",
        ["Sodium Nitrate"] = "нітрат натрію",
        ["Wood Pulp"] = "целюлоза",
    },
    [848] = {
        ["Fungal Spores"] = "спори грибів",
    },
    [850] = {
        ["Kodobane's Head"] = "голова Барака",
    },
    [851] = {
        ["Verog's Head"] = "голова Вероґа",
    },
    [852] = {
        ["Hezrul's Head"] = "голова Герзула",
    },
    [855] = {
        ["Centaur Bracers"] = "наручі кентаврів",
    },
    [857] = {
        ["Tear of the Moons"] = "Сльоза Місяця",
    },
    [858] = {
        ["Ignition Key"] = "ключ запалювання",
    },
    [861] = {
        ["Flatland Prowler Claw"] = "пазур рівнинного скрадача",
    },
    [862] = {
        ["Dig Rat"] = "печерний щур",
    },
    [865] = {
        ["Intact Raptor Horn"] = "неушкоджений ріг раптора",
    },
    [866] = {
        ["Root Sample"] = "зразок кореня",
    },
    [867] = {
        ["Witchwing Talon"] = "кіготь чарокрилої",
    },
    [868] = {
        ["Silithid Egg"] = "яйце силітида",
    },
    [869] = {
        ["Raptor Head"] = "голова раптора",
    },
    [871] = {
        ["Razormane Hunter slain"] = "бритвогривий мисливець: убито",
        ["Razormane Thornweaver slain"] = "бритвогривий терноткач: убито",
        ["Razormane Water Seeker slain"] = "бритвогривий водошукач: убито",
    },
    [872] = {
        ["Kreenig Snarlsnout's Tusk"] = "ікло Крініга Рилоскала",
        ["Razormane Defender slain"] = "бритвогривий захисник: убито",
        ["Razormane Geomancer slain"] = "бритвогривий геомант: убито",
    },
    [873] = {
        ["Heart of Isha Awak"] = "серце Іши Авака",
    },
    [875] = {
        ["Harpy Lieutenant Ring"] = "лейтенантський перстень гарпії",
    },
    [876] = {
        ["Serena's Head"] = "голова Серени",
    },
    [878] = {
        ["Bristleback Geomancer slain"] = "щетиношкурий геомант: убито",
        ["Bristleback Thornweaver slain"] = "щетиношкурий терноткач: убито",
        ["Bristleback Water Seeker slain"] = "щетиношкурий водошукач: убито",
    },
    [879] = {
        ["Kuz's Skull"] = "череп Каза",
        ["Lok's Skull"] = "череп Лока",
        ["Nak's Skull"] = "череп Нака",
    },
    [880] = {
        ["Altered Snapjaw Shell"] = "панцир видозміненого тріскощелепа",
    },
    [881] = {
        ["Echeyakee's Hide"] = "шкура Ечеякі",
    },
    [882] = {
        ["Ishamuhale's Fang"] = "ікло Ішамугала",
    },
    [887] = {
        ["Southsea Brigand slain"] = "грабіжник Південних морів: убито",
        ["Southsea Cannoneer slain"] = "канонір Південних морів: убито",
    },
    [888] = {
        ["Shipment of Boots"] = "партія черевиків",
        ["Telescopic Lens"] = "лінза для телескопа",
    },
    [889] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [891] = {
        ["Cannoneer Smythe slain"] = "канонір Смайт: убито",
        ["Cannoneer Whessan slain"] = "канонір Вессан: убито",
        ["Captain Fairmount slain"] = "капітан Честостанна: убито",
        ["Theramore Medal"] = "медаль Терамору",
    },
    [893] = {
        ["Charred Razormane Wand"] = "обгоріла паличка Бритвогривих",
        ["Razormane Backstabber"] = "стилет Бритвогривих",
        ["Razormane War Shield"] = "бойовий щит Бритвогривих",
    },
    [895] = {
        ["Baron Longshore's Head"] = "голова барона Довгоберега",
    },
    [896] = {
        ["Cats Eye Emerald"] = "смарагд «Котяче око»",
    },
    [899] = {
        ["Bristleback Quilboar Tusk"] = "ікло щетиношкурого свинобраза",
    },
    [901] = {
        ["Console Key"] = "ключ від панелі",
    },
    [903] = {
        ["Prowler Claws"] = "пазурі скрадача",
    },
    [907] = {
        ["Thunder Lizard Blood"] = "кров громоящера",
    },
    [908] = {
        ["Fathom Core"] = "ядро глибин",
    },
    [909] = {
        ["Strange Water Globe"] = "дивна водяна куля",
        ["Strange Water Globe (Provided)"] = "дивна водяна куля (видано)",
    },
    [913] = {
        ["Thunderhawk Wings"] = "крила громояструба",
    },
    [914] = {
        ["Gem of Anacondra"] = "самоцвіт Анакондри",
        ["Gem of Cobrahn"] = "самоцвіт Кобрана",
        ["Gem of Pythas"] = "самоцвіт Пітонаса",
        ["Gem of Serpentis"] = "самоцвіт Серпентіса",
    },
    [915] = {
        ["Tigule's Strawberry Ice Cream"] = "полуничне морозиво Тіґуля",
    },
    [916] = {
        ["Webwood Venom Sac"] = "отруйна залоза павутиннолісих",
    },
    [917] = {
        ["Webwood Egg"] = "яйце павутиннолісих",
    },
    [918] = {
        ["Timberling Seed"] = "насіння деревника",
    },
    [919] = {
        ["Timberling Sprout"] = "паросток деревника",
    },
    [921] = {
        ["Filled Crystal Phial"] = "наповнений кришталевий фіал",
    },
    [923] = {
        ["Mossy Tumor"] = "вкрита мохом пухлина",
    },
    [925] = {
        ["Cairne's Hoofprint"] = "відбиток копита Керна",
    },
    [929] = {
        ["Filled Jade Phial"] = "наповнений нефритовий фіал",
    },
    [932] = {
        ["Melenas' Head"] = "голова Меленаса",
    },
    [933] = {
        ["Filled Tourmaline Phial"] = "наповнений турмаліновий фіал",
    },
    [934] = {
        ["Vial of Blessed Water"] = "флакон з благословенною водою",
    },
    [937] = {
        ["Bloodfeather Belt"] = "пояс Кривавоперих",
    },
    [939] = {
        ["Jadefire Felbind"] = "нефритожарі пута скверни",
    },
    [943] = {
        ["Flagongut's Fossil"] = "скам'янілість Флягопуза",
        ["Stone of Relu"] = "камінь Релу",
    },
    [947] = {
        ["Death Cap"] = "мертвошляпка",
        ["Scaber Stalk"] = "лусконіжка",
    },
    [951] = {
        ["Mathystra Relic"] = "реліквія Матистри",
    },
    [955] = {
        ["Grell Earring"] = "сережка грела",
    },
    [956] = {
        ["Ancient Moonstone Seal"] = "древня печатка місячного каменю",
    },
    [958] = {
        ["Highborne Relic"] = "реліквія високородних",
    },
    [959] = {
        ["99-Year-Old Port"] = "99-річний портвейн",
    },
    [962] = {
        ["Serpentbloom"] = "змієквіт",
    },
    [963] = {
        ["Anaya's Pendant"] = "кулон Анайї",
    },
    [964] = {
        ["Skeletal Fragments"] = "фрагменти скелетів",
    },
    [966] = {
        ["Worn Parchment"] = "потертий пергамент",
    },
    [969] = {
        ["Frostmaul Shards"] = "уламки кригобоїв",
    },
    [970] = {
        ["Glowing Soul Gem"] = "сяючий камінь душі",
    },
    [971] = {
        ["Lorgalis Manuscript"] = "манускрипт Лорґаліса",
    },
    [973] = {
        ["Ilkrud Magthrull's Tome"] = "фоліант Ілкруда Маґтрулла",
    },
    [977] = {
        ["Pristine Yeti Horn"] = "бездоганний ріг єті",
    },
    [978] = {
        ["Moontouched Feather"] = "осяяне місяцем перо",
    },
    [982] = {
        ["Mist Veil's Lockbox"] = "скринька \"Туманного Серпанку\"",
        ["Silver Dawning's Lockbox"] = "скринька \"Сріблястої Зорі\"",
    },
    [983] = {
        ["Crawler Leg"] = "нога повзуна",
    },
    [985] = {
        ["Blackwood Pathfinder slain"] = "чорнолісний слідопит: убито",
        ["Blackwood Windtalker slain"] = "чорнолісний вітробай: убито",
    },
    [986] = {
        ["Fine Moonstalker Pelt"] = "чудова шкура місяцескрада",
    },
    [992] = {
        ["Tapped Dowsing Widget"] = "використаний пристрій для пошуку води",
    },
    [996] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [998] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [1001] = {
        ["Thresher Eye"] = "око молотника",
    },
    [1002] = {
        ["Moonstalker Fang"] = "ікло місяцескрада",
    },
    [1003] = {
        ["Grizzled Scalp"] = "посивілий скальп",
    },
    [1007] = {
        ["Ancient Statuette"] = "стародавня статуетка",
    },
    [1008] = {
        ["Wrathtail Head"] = "голова гнівохвостої наги",
    },
    [1009] = {
        ["Ring of Zoram"] = "зорамський перстень",
    },
    [1010] = {
        ["Bathran's Hair"] = "батранове волосся",
    },
    [1011] = {
        ["Bottle of Disease"] = "пляшка пошесті",
    },
    [1012] = {
        ["Mavoris Cloudsbreak slain"] = "Маворіс Хмаролом: убито",
        ["Taneel Darkwood slain"] = "Таніл Темноліс: убито",
        ["Uthil Mooncall slain"] = "Утіл Місяцезов: убито",
    },
    [1013] = {
        ["The Book of Ur"] = "книга Ура",
    },
    [1014] = {
        ["Head of Arugal"] = "голова Аруґала",
    },
    [1016] = {
        ["Divined Scroll"] = "сувій з провіщенням",
    },
    [1017] = {
        ["Sarilus Foulborne's Head"] = "голова Сарілуса Гидкородного",
    },
    [1023] = {
        ["Glowing Gem"] = "сяючий самоцвіт",
    },
    [1025] = {
        ["Foulweald Den Watcher slain"] = "гидколісний наглядач лігва: убито",
        ["Foulweald Totemic slain"] = "гидколісний тотеміст: убито",
        ["Foulweald Ursa slain"] = "гидколісний урса: убито",
        ["Foulweald Warrior slain"] = "гидколісний воїн: убито",
    },
    [1026] = {
        ["Iron Shaft"] = "залізне руків'я",
    },
    [1027] = {
        ["Iron Pommel"] = "залізне навершя",
    },
    [1031] = {
        ["Branch of Cenarius"] = "гілка Кенарія",
    },
    [1032] = {
        ["Satyr Horns"] = "роги сатира",
    },
    [1033] = {
        ["Elune's Tear"] = "сльоза Елуни",
    },
    [1034] = {
        ["Handful of Stardust"] = "жменя зорепилу",
    },
    [1035] = {
        ["Fallen Moonstone"] = "впалий місячний камінь",
    },
    [1038] = {
        ["Velinde's Journal"] = "щоденник Велінди",
    },
    [1045] = {
        ["Bloodtooth Guard slain"] = "кривавозубий вартовий: убито",
        ["Ran Bloodtooth slain"] = "Ран Кривавозубий: убито",
    },
    [1046] = {
        ["Dartol's Rod of Transformation"] = "жезл трансформації Дартола",
    },
    [1048] = {
        ["Houndmaster Loksey slain"] = "псар Локсі: убито",
        ["Scarlet Commander Mograine slain"] = "командир Багряного Походу Моґрейн: убито",
    },
    [1049] = {
        ["Compendium of the Fallen"] = "Компендіум полеглих",
    },
    [1050] = {
        ["Mythology of the Titans"] = "Мітологія титанів",
    },
    [1051] = {
        ["Vorrel's Wedding Ring"] = "обручка Воррела",
    },
    [1053] = {
        ["Houndmaster Loksey slain"] = "псар Локсі: убито",
        ["Scarlet Commander Mograine slain"] = "командир Багряного Походу Моґрейн: убито",
    },
    [1054] = {
        ["Dal Bloodclaw's Skull"] = "череп Дала Кровопазура",
    },
    [1057] = {
        ["Bloodfury Ambusher slain"] = "криваволюта душителька: убито",
        ["Bloodfury Harpy slain"] = "криваволюта гарпія: убито",
        ["Bloodfury Roguefeather slain"] = "криваволюта оперена пройдисвітка: убито",
        ["Bloodfury Slayer slain"] = "криваволюта вбивця: убито",
    },
    [1058] = {
        ["Courser Eye"] = "око оленя",
        ["Fey Dragon Scale"] = "луска чародракончика",
        ["Stonetalon Sap"] = "каміннопазуриста живиця",
        ["Twilight Whisker"] = "сутінковий вус",
    },
    [1062] = {
        ["Venture Co. Logger slain"] = "лісоруб ТзНБ \"Авантюра\": убито",
    },
    [1066] = {
        ["Vial of Innocent Blood"] = "флакон крові невинних",
    },
    [1068] = {
        ["XT:4 slain"] = "ХТ:4: убито",
        ["XT:9 slain"] = "ХТ:9: убито",
    },
    [1069] = {
        ["Deepmoss Egg"] = "яйце мохового павука",
    },
    [1071] = {
        ["Venture Co. Deforester slain"] = "лісозаготівельник ТзНБ \"Авантюра\": убито",
        ["Venture Co. Logger slain"] = "лісоруб ТзНБ \"Авантюра\": убито",
    },
    [1073] = {
        ["Elixir of Minor Fortitude"] = "крихітний еліксир стійкості",
        ["Minor Mana Potion"] = "крихітне зілля мани",
    },
    [1076] = {
        ["Dust Devil Debris"] = "уламки пилового дідька",
    },
    [1078] = {
        ["Crystalized Scales"] = "кристалічна луска",
    },
    [1079] = {
        ["Venture Co. Engineering Plans"] = "інженерні креслення ТзНБ \"Авантюра\"",
    },
    [1080] = {
        ["Venture Co. Letters"] = "документи ТзНБ \"Авантюра\"",
    },
    [1083] = {
        ["Smoldering Embers"] = "тліюча вуглинка",
    },
    [1084] = {
        ["Corroded Shrapnel"] = "іржава шрапнель",
    },
    [1087] = {
        ["Cenarion Botanist slain"] = "кенарійський ботанік: убито",
    },
    [1088] = {
        ["Ordanus' Head"] = "голова Ордана",
    },
    [1089] = {
        ["Barrow Key"] = "ключ прихистку",
        ["Claw Key"] = "ключ пазура",
        ["Sleepers' Key"] = "ключ сплячих",
    },
    [1093] = {
        ["Super Reaper 6000 Blueprints"] = "креслення Супер дереворуба 6000",
    },
    [1096] = {
        ["Gerenzo's Mechanical Arm"] = "механічна рука Ґерензо",
    },
    [1101] = {
        ["Razorflank's Medallion"] = "медальйон Бритвобокої",
    },
    [1102] = {
        ["Razorflank's Heart"] = "серце Бритвобокої",
    },
    [1103] = {
        ["Water Sapta"] = "сапта води",
    },
    [1104] = {
        ["Salty Scorpid Venom"] = "солона отрута скорпіда",
    },
    [1105] = {
        ["Hardened Tortoise Shell"] = "міцний черепашачий панцир",
    },
    [1107] = {
        ["Encrusted Tail Fin"] = "вкритий сіллю хвостовий плавник",
    },
    [1108] = {
        ["Indurium Flake"] = "шматок індурію",
    },
    [1109] = {
        ["Kraul Guano"] = "гуано краальського кажана",
    },
    [1110] = {
        ["Rocket Car Parts"] = "деталі боліда",
    },
    [1113] = {
        ["Heart of Zeal"] = "ревнісне серце",
    },
    [1116] = {
        ["Speck of Dream Dust"] = "дрібка пудри блаженства",
    },
    [1125] = {
        ["Tortured Druid slain"] = "закатований друїд: убито",
        ["Tortured Sentinel slain"] = "закатована вартова: убито",
    },
    [1126] = {
        ["Encrusted Silithid Object"] = "вкрита хітином річ",
    },
    [1127] = {
        ["Zanzil's Mixture"] = "суміш Занзіла",
    },
    [1131] = {
        ["Steelsnap's Rib"] = "ребро Сталекуса",
    },
    [1134] = {
        ["Pridewing Venom Sac"] = "отруйна залоза гордокрила",
    },
    [1135] = {
        ["Highperch Venom Sac"] = "отруйна залоза Високого Сідала",
    },
    [1136] = {
        ["Frostmaw's Mane"] = "грива Кригопащі",
    },
    [1138] = {
        ["Fine Crab Chunks"] = "чудове крабове м'ясо",
    },
    [1139] = {
        ["Tablet of Will"] = "скрижаль волі",
    },
    [1141] = {
        ["Darkshore Grouper"] = "окунь Темнобережжя",
    },
    [1142] = {
        ["Treshala's Pendant"] = "кулон Трешали",
    },
    [1143] = {
        ["Athrikus Narassin's Head"] = "голова Атріка Нарассіна",
    },
    [1147] = {
        ["Silithid Hive Drone slain"] = "силітид-трутень: убито",
        ["Silithid Invader slain"] = "силітид-загарбник: убито",
        ["Silithid Searcher slain"] = "силітид-шукач: убито",
    },
    [1148] = {
        ["Intact Silithid Carapace"] = "неушкоджений панцир силітида",
        ["Silithid Heart"] = "серце силітида",
        ["Silithid Talon"] = "кіготь силітида",
    },
    [1150] = {
        ["Grenka's Claw"] = "кіготь Ґренки",
    },
    [1151] = {
        ["Fragments of Rok'Alim"] = "фрагменти Рок'аліма",
    },
    [1153] = {
        ["Unrefined Ore Sample"] = "неочищений зразок руди",
    },
    [1154] = {
        ["Legacy of the Aspects"] = "Спадщина Аспектів",
    },
    [1160] = {
        ["Beginnings of the Undead Threat"] = "Джерела загрози невмерлих",
    },
    [1164] = {
        ["Fardel's Head"] = "голова Фардела",
        ["Kenata's Head"] = "голова Кенати",
        ["Marcel's Head"] = "голова Марселя",
    },
    [1166] = {
        ["Mok'Morokk's Grog"] = "грог Мок'Морокка",
        ["Mok'Morokk's Snuff"] = "тютюн Мок'Морокка",
        ["Mok'Morokk's Strongbox"] = "сейф Мок'Морокка",
    },
    [1168] = {
        ["Firemane Ash Tail slain"] = "вогнегрива попелехвостка: убито",
        ["Firemane Scalebane slain"] = "вогнегривий лускоклят: убито",
        ["Firemane Scout slain"] = "вогнегривий розвідник: убито",
    },
    [1169] = {
        ["Searing Heart"] = "палюче серце",
        ["Searing Tongue"] = "палючий язик",
    },
    [1175] = {
        ["Saltstone Basilisk slain"] = "соляний василіск: убито",
        ["Saltstone Crystalhide slain"] = "соляний кришталешкур: убито",
        ["Saltstone Gazer slain"] = "соляний камнегляд: убито",
    },
    [1176] = {
        ["Hollow Vulture Bone"] = "порожниста кістка стерв'ятника",
    },
    [1177] = {
        ["Mirefin Head"] = "голова моквоплавникового мурлока",
    },
    [1182] = {
        ["Fuel Regulator Blueprints"] = "креслення паливного регулятора",
    },
    [1187] = {
        ["Seaforium Booster"] = "сифорієвий прискорювач",
    },
    [1192] = {
        ["Indurium Ore"] = "індурієва руда",
    },
    [1193] = {
        ["Frost Oil"] = "крижана олія",
        ["Thorium Widget"] = "торієвий пристрій",
    },
    [1195] = {
        ["Filled Etched Phial"] = "наповнений гравійований фіал",
    },
    [1197] = {
        ["Cloven Hoof"] = "роздвоєне копито",
    },
    [1199] = {
        ["Twilight Pendant"] = "сутінкова підвіска",
    },
    [1200] = {
        ["Head of Kelris"] = "голова Келріса",
    },
    [1201] = {
        ["Theramore Infiltrator slain"] = "тераморський шпигун: убито",
    },
    [1202] = {
        ["Captain's Documents"] = "документи капітана",
    },
    [1203] = {
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
    },
    [1204] = {
        ["Forked Mudrock Tongue"] = "роздвоєний язик болотяної черепахи",
    },
    [1205] = {
        ["Deadmire's Tooth"] = "зуб Сипуна",
    },
    [1206] = {
        ["Unpopped Darkmist Eye"] = "ціле око імлистого павука",
    },
    [1218] = {
        ["Soothing Spices"] = "духмяні спеції",
    },
    [1221] = {
        ["Blueleaf Tuber"] = "бульба синьолиста",
        ["Crate With Holes"] = "ящик з отворами",
        ["Snufflenose Command Stick"] = "палиця керування шморгоносом",
        ["Snufflenose Owner's Manual"] = "посібник власника шморгоноса",
    },
    [1244] = {
        ["Defias Docket"] = "плани Непокірних",
    },
    [1258] = {
        ["Pristine Crawler Leg"] = "бездоганна лапа повзуна",
    },
    [1261] = {
        ["Jeweled Pendant"] = "кулон з самоцвітами",
    },
    [1275] = {
        ["Corrupted Brain Stem"] = "заражений мозковий стовбур",
    },
    [1318] = {
        ["Gauntlet of Gordok Might"] = "рукавичка могутності Ґордока",
    },
    [1322] = {
        ["Acidic Venom Sac"] = "їдка отруйна залоза",
    },
    [1360] = {
        ["Krom Stoutarm's Treasure"] = "скарб Крома Міцнорука",
    },
    [1364] = {
        ["Khadgar's Essays on Dimensional Convergence"] = "дослідження просторової конвергенції Кадґара",
    },
    [1365] = {
        ["Khan Dez'hepah's Head"] = "голова хана Дез'гепа",
    },
    [1366] = {
        ["Centaur Ear"] = "вухо кентавра",
    },
    [1369] = {
        ["Broken Tears"] = "розбиті сльози",
    },
    [1370] = {
        ["Crudely Dried Meat"] = "грубо в'ялене м'ясо",
    },
    [1371] = {
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
    },
    [1373] = {
        ["Draenethyst Shard"] = "уламок дренетиста",
    },
    [1374] = {
        ["Khan Jehn's Head"] = "голова хана Джена",
    },
    [1375] = {
        ["Khan Shaka's Head"] = "голова хана Шаки",
    },
    [1380] = {
        ["Maraudine Key Fragment"] = "мародінський фрагмент ключа",
    },
    [1381] = {
        ["Maraudine Key Fragment"] = "мародінський фрагмент ключа",
    },
    [1383] = {
        ["Deepstrider Tumor"] = "пухлина глибокохода",
        ["Mire Lord Fungus"] = "гриб повелителя болота",
        ["Shadow Panther Heart"] = "серце тіньової пантери",
    },
    [1384] = {
        ["Crude Charm"] = "грубий оберіг",
    },
    [1386] = {
        ["Kolkar Centaur slain"] = "колкарський кентавр: убито",
        ["Kolkar Mauler slain"] = "колкарський молотобій: убито",
        ["Kolkar Scout slain"] = "колкарський розвідник: убито",
    },
    [1387] = {
        ["Centaur Ear"] = "вухо кентавра",
    },
    [1389] = {
        ["Draenethyst Crystal"] = "кристал дренетисту",
    },
    [1396] = {
        ["Sorrow Spinner slain"] = "ткач скорботи: убито",
        ["Swamp Jaguar slain"] = "болотний ягуар: убито",
        ["Young Sawtooth Crocolisk slain"] = "молодий пилкозубий кроколіск: убито",
    },
    [1398] = {
        ["Sundried Driftwood"] = "сухий плавник",
    },
    [1419] = {
        ["Coyote Jawbone"] = "щелепа койота",
    },
    [1421] = {
        ["Wizards' Reagents"] = "реактиви чарівників",
    },
    [1424] = {
        ["Atal'ai Artifact"] = "артефакт Атал'ай",
    },
    [1426] = {
        ["Marsh Flesheater slain"] = "трясовинний живоїд: убито",
        ["Marsh Inkspewer slain"] = "трясовинний чорнильник: убито",
        ["Marsh Murloc slain"] = "трясовинний мурлок: убито",
    },
    [1428] = {
        ["Marsh Flesheater slain"] = "трясовинний живоїд: убито",
        ["Marsh Inkspewer slain"] = "трясовинний чорнильник: убито",
        ["Marsh Oracle slain"] = "трясовинний оракул: убито",
    },
    [1430] = {
        ["Monstrous Crawler Leg"] = "нога жахливого повзуна",
    },
    [1434] = {
        ["Hatefury Betrayer slain"] = "скаженолютий зрадник: убито",
        ["Hatefury Felsworn slain"] = "скаженолютий скверноклят: убито",
        ["Hatefury Hellcaller slain"] = "скаженолютий пеклоклик: убито",
        ["Hatefury Rogue slain"] = "скаженолютий пройдисвіт: убито",
    },
    [1435] = {
        ["Infused Burning Gem"] = "наповнений палаючий самоцвіт",
    },
    [1439] = {
        ["Tyranis' Pendant"] = "кулон Тіраніса",
    },
    [1442] = {
        ["Corrupted Kor Gem"] = "осквернений самоцвіт Кора",
    },
    [1445] = {
        ["Fetish of Hakkar"] = "фетиш Гаккара",
    },
    [1446] = {
        ["Head of Jammal'an"] = "голова Джаммал'ана",
    },
    [1452] = {
        ["Groddoc Liver"] = "печінка гроддокської мавпи",
        ["Ironfur Liver"] = "печінка залізохутрого ведмедя",
        ["Roc Gizzard"] = "шлунок руха",
    },
    [1456] = {
        ["Karnitol's Satchel"] = "торба Карнітола",
    },
    [1458] = {
        ["Hatefury Claw"] = "кіготь скаженолютого сатира",
        ["Hatefury Horn"] = "ріг скаженолютого сатира",
    },
    [1459] = {
        ["Aged Kodo Hide"] = "шкура старого кодо",
        ["Scorpashi Venom"] = "отрута скорпаші",
    },
    [1466] = {
        ["Doomwarder Blood"] = "кров стража приречення",
        ["Felhound Brain"] = "мозок скверногончої",
        ["Nether Wing"] = "підсвітне крило",
    },
    [1470] = {
        ["Rattlecage Skull"] = "череп брязкокісткового скелета",
    },
    [1471] = {
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1473] = {
        ["Egalin's Grimoire"] = "гримуар Еґаліна",
    },
    [1474] = {
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1475] = {
        ["Atal'ai Tablet"] = "скрижаль Атал'ай",
    },
    [1476] = {
        ["Comar's Heart"] = "серце Комара",
        ["Dalin's Heart"] = "серце Даліна",
    },
    [1481] = {
        ["Shadowstalker Scalp"] = "скальп тінелова",
    },
    [1482] = {
        ["Oracle Crystal"] = "кристал оракула",
    },
    [1485] = {
        ["Vile Familiar Head"] = "голова паскудного фамільяра",
    },
    [1486] = {
        ["Deviate Hide"] = "спотворена шкура",
    },
    [1487] = {
        ["Deviate Dreadfang slain"] = "спотворений жахоклик: убито",
        ["Deviate Ravager slain"] = "спотворений спустошник: убито",
        ["Deviate Shambler slain"] = "спотворений шаркун: убито",
        ["Deviate Viper slain"] = "спотворена гадюка: убито",
    },
    [1488] = {
        ["Jugkar Grim'rod slain"] = "Жуґар Ґрім'род: убито",
        ["Lord Azrethoc slain"] = "лорд Азреток: убито",
    },
    [1491] = {
        ["Wailing Essence"] = "плачуча сутність",
    },
    [1498] = {
        ["Singed Scale"] = "припалена луска",
    },
    [1501] = {
        ["Tablet of Verga"] = "скрижаль Верґи",
    },
    [1503] = {
        ["Forged Steel Bars"] = "бруски кованої сталі",
    },
    [1504] = {
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1513] = {
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1514] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [1516] = {
        ["Felstalker Hoof"] = "копито сквернолова",
    },
    [1519] = {
        ["Ritual Salve"] = "ритуальна мазь",
    },
    [1525] = {
        ["Fire Tar"] = "вогняна смола",
        ["Reagent Pouch"] = "мішечок з реагентами",
    },
    [1526] = {
        ["Glowing Ember"] = "розжарена вуглинка",
    },
    [1534] = {
        ["Filled Blue Waterskin"] = "наповнений блакитний бурдюк",
    },
    [1535] = {
        ["Filled Brown Waterskin"] = "наповнений коричневий бурдюк",
    },
    [1536] = {
        ["Filled Red Waterskin"] = "наповнений червоний бурдюк",
    },
    [1578] = {
        ["Copper Axe"] = "мідна сокира",
        ["Copper Chain Belt"] = "мідний плетений пояс",
    },
    [1579] = {
        ["Gaffer Jack"] = "світлоштепсель",
    },
    [1580] = {
        ["Electropeller"] = "електропелер",
    },
    [1581] = {
        ["Elixir of Lion's Strength"] = "еліксир сили лева",
        ["Elixir of Minor Defense"] = "еліксир слабкого захисту",
    },
    [1582] = {
        ["Embossed Leather Boots"] = "тиснені шкіряні чоботи",
        ["Embossed Leather Cloak"] = "тиснений шкіряний плащ",
        ["Embossed Leather Gloves"] = "тиснені шкіряні рукавички",
    },
    [1598] = {
        ["Powers of the Void"] = "Сили Порожнечі",
    },
    [1599] = {
        ["Feather Charm"] = "оберіг з пір'я",
    },
    [1618] = {
        ["Heavy Copper Maul"] = "важкий мідний молот",
        ["Runed Copper Belt"] = "рунічний мідний пояс",
    },
    [1644] = {
        ["Linen Cloth"] = "лляна тканина",
    },
    [1648] = {
        ["Linen Cloth"] = "лляна тканина",
    },
    [1654] = {
        ["Jordan's Refined Ore Shipment"] = "партія очищеної руди Джордана",
        ["Jordan's Smithing Hammer"] = "ковальський молоток Джордана",
        ["Purified Kor Gem"] = "очищений самоцвіт Кора",
        ["Whitestone Oak Lumber"] = "деревина білокам'яного дуба",
    },
    [1655] = {
        ["Jordan's Ore Shipment"] = "партія руди Джордана",
    },
    [1667] = {
        ["Marshal Haggard's Badge"] = "значок маршала Знесилія",
    },
    [1678] = {
        ["Vejrek's Head"] = "голова Веджріка",
    },
    [1681] = {
        ["Umbral Ore"] = "смеркова руда",
    },
    [1683] = {
        ["Horn of Vorlus"] = "ріг Ворла",
    },
    [1686] = {
        ["Elunite Ore"] = "елунітова руда",
        ["Elura's Medallion"] = "медальйон Елури",
    },
    [1688] = {
        ["Surena's Choker"] = "кольє Сурени",
    },
    [1689] = {
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1690] = {
        ["Wastewander Bandit slain"] = "бандит Пустелебродів: убито",
        ["Wastewander Thief slain"] = "злодій Пустелебродів: убито",
    },
    [1691] = {
        ["Wastewander Assassin slain"] = "душогуб Пустелебродів: убито",
        ["Wastewander Rogue slain"] = "пройдисвіт Пустелебродів: убито",
        ["Wastewander Shadow Mage slain"] = "тіньовий маг Пустелебродів: убито",
    },
    [1701] = {
        ["Charred Horn"] = "обвуглений ріг",
        ["Galvanized Horn"] = "гальванізований ріг",
        ["Scorched Spider Fang"] = "обпалене павуче ікло",
        ["Vial of Phlogiston"] = "фіал флогістону",
    },
    [1705] = {
        ["Burning Blood"] = "палаюча кров",
        ["Burning Rock"] = "палаючий камінь",
    },
    [1707] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
    },
    [1708] = {
        ["Searing Coral"] = "обпалюючий корал",
    },
    [1710] = {
        ["Sunscorched Shell"] = "випалена сонцем шкаралупа",
    },
    [1712] = {
        ["Bloodscalp Tusk"] = "ікло Кровоскальпого",
        ["Essence of the Exile"] = "сутність вигнанця",
        ["Liferoot"] = "життєкорінь",
    },
    [1713] = {
        ["Whirlwind Heart"] = "серце вихору",
    },
    [1714] = {
        ["Burning Charm"] = "палаючий оберіг",
        ["Cresting Charm"] = "бурунистий оберіг",
        ["Thundering Charm"] = "буревійний оберіг",
    },
    [1719] = {
        ["Big Will slain"] = "здоровань Вілл: убито",
    },
    [1738] = {
        ["Heartswood"] = "серцедерево",
    },
    [1739] = {
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1740] = {
        ["Large Soran'ruk Fragment"] = "великий фрагмент Соран'рука",
        ["Soran'ruk Fragment"] = "фрагмент Соран'рука",
    },
    [1783] = {
        ["Narm Faulk slain"] = "Нарм Фок: убито",
    },
    [1784] = {
        ["Dark Iron Script"] = "накази Темного Заліза",
    },
    [1786] = {
        ["Henze Faulk slain"] = "Гензе Фок: убито",
    },
    [1787] = {
        ["Defias Script"] = "накази Непокірних",
    },
    [1795] = {
        ["Summoned Felhunter slain"] = "викликана скверногонча: убито",
    },
    [1796] = {
        ["Robes of Arcana"] = "мантія аркани",
    },
    [1799] = {
        ["Infernal Orb"] = "сфера пекельника",
    },
    [1802] = {
        ["Moldy Tome"] = "запліснявілий фоліант",
        ["Tattered Manuscript"] = "пошарпаний манускрипт",
    },
    [1803] = {
        ["Moldy Tome"] = "запліснявілий фоліант",
        ["Tattered Manuscript"] = "пошарпаний манускрипт",
    },
    [1804] = {
        ["Rod of Channeling"] = "жезл виклику",
    },
    [1805] = {
        ["Rod of Channeling"] = "жезл виклику",
    },
    [1819] = {
        ["Ulag the Cleaver slain"] = "Улаґ-Колун: убито",
    },
    [1821] = {
        ["Agamand Family Axe"] = "родова сокира Аґамандів",
        ["Agamand Family Dagger"] = "родовий кинджал Аґамандів",
        ["Agamand Family Mace"] = "родова булава Аґамандів",
        ["Agamand Family Sword"] = "родовий меч Аґамандів",
    },
    [1824] = {
        ["Twitching Antenna"] = "судомний вусик",
    },
    [1838] = {
        ["Iron Bar"] = "злиток заліза",
        ["Powdered Azurite"] = "молотий азурит",
        ["Smoky Iron Ingot"] = "злиток димчастого заліза",
        ["Vial of Phlogiston"] = "фіал флогістону",
    },
    [1842] = {
        ["Uncloven Satyr Hoof"] = "нероздвоєне копито сатира",
    },
    [1844] = {
        ["Galvanized Horn"] = "гальванізований ріг",
    },
    [1846] = {
        ["Sturdy Dragonmaw Shinbone"] = "міцна гомілкова кістка Драконової Пащі",
    },
    [1858] = {
        ["Tazan's Logbook"] = "щоденник Тазана",
    },
    [1861] = {
        ["Mirror Lake Water Sample"] = "зразок води Дзеркального озера",
    },
    [1878] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
    },
    [1880] = {
        ["Mage-tastic Gizmonitor"] = "маг-тастичний гізмонітор",
    },
    [1882] = {
        ["Balnir Snapdragons"] = "ротики Бальнірів",
    },
    [1886] = {
        ["Astor's Letter of Introduction"] = "рекомендаційний лист Астора",
    },
    [1899] = {
        ["Andron's Ledger"] = "гросбух Андрона",
    },
    [1920] = {
        ["Cantation of Manifestation"] = "закляття прояву",
        ["Chest of Containment Coffers"] = "ящик зі скринями стримування",
        ["Filled Containment Coffer"] = "заповнена скриня стримування",
    },
    [1921] = {
        ["Charged Rift Gem"] = "заряджений камінь розлому",
        ["Linen Cloth"] = "лляна тканина",
    },
    [1938] = {
        ["Ur's Treatise on Shadow Magic"] = "трактат Ура про темну магію",
    },
    [1940] = {
        ["Pristine Spider Silk"] = "бездоганне павутиння",
    },
    [1944] = {
        ["Xavian Water Sample"] = "зразок води Завіана",
    },
    [1945] = {
        ["Laughing Sister's Hair"] = "волосина сміхотливої сестри",
    },
    [1948] = {
        ["Bolt Charged Bramble"] = "заряджена блискавкою тростина",
        ["Jade"] = "нефрит",
    },
    [1951] = {
        ["Rituals of Power"] = "\"Ритуали сили\"",
    },
    [1954] = {
        ["Infernal Orb"] = "сфера пекельника",
    },
    [1955] = {
        ["Demon of the Orb slain"] = "демон сфери: убито",
    },
    [1956] = {
        ["Obsidian Power Source"] = "обсидіанове джерело сили",
    },
    [1957] = {
        ["Mana Surge slain"] = "манасплеск: убито",
    },
    [1960] = {
        ["Cantation of Manifestation"] = "закляття прояву",
        ["Chest of Containment Coffers"] = "ящик зі скринями стримування",
        ["Filled Containment Coffer"] = "заповнена скриня стримування",
    },
    [1961] = {
        ["Dalaran Mana Gem"] = "даларанський самоцвіт мани",
        ["Linen Cloth"] = "лляна тканина",
    },
    [1963] = {
        ["Tazan's Satchel"] = "ранець Тазана",
    },
    [1998] = {
        ["Fenwick's Head"] = "голова Фенвіка",
    },
    [1999] = {
        ["Dalaran Status Report"] = "звіт про ситуацію в Даларані",
    },
    [2038] = {
        ["Bingles' Blastencapper"] = "болтозрив Бінґлса",
        ["Bingles' Hammer"] = "молоток Бінґлса",
        ["Bingles' Screwdriver"] = "викрутка Бінґлса",
        ["Bingles' Wrench"] = "гайковий ключ Бінґлса",
    },
    [2040] = {
        ["Gnoam Sprecklesprocket"] = "гномський шпрековерт",
    },
    [2098] = {
        ["Bottom of Gelkak's Key"] = "нижня частина ключа Ґелкака",
        ["Middle of Gelkak's Key"] = "середня частина ключа Ґелкака",
        ["Top of Gelkak's Key"] = "верхня частина ключа Ґелкака",
    },
    [2138] = {
        ["Rabid Thistle Bear slain"] = "скажений татарний ведмідь: убито",
    },
    [2139] = {
        ["Den Mother slain"] = "Мати лігва: убито",
    },
    [2178] = {
        ["Strider Meat"] = "м'ясо бігуна",
    },
    [2199] = {
        ["Silver Bar"] = "злиток срібла",
    },
    [2201] = {
        ["Shattered Necklace Ruby"] = "рубін пошкодженого намиста",
        ["Shattered Necklace Sapphire"] = "сапфір пошкодженого намиста",
        ["Shattered Necklace Topaz"] = "топаз пошкодженого намиста",
    },
    [2202] = {
        ["Magenta Fungus Cap"] = "гриб-малиновик",
    },
    [2203] = {
        ["Vessel of Dragon's Blood"] = "флакон з кров'ю дракона",
    },
    [2204] = {
        ["Shattered Necklace Power Source"] = "джерело сили пошкодженого намиста",
    },
    [2206] = {
        ["Defias Shipping Schedule"] = "розклад постачань Непокірних",
    },
    [2242] = {
        ["Sethir's Journal"] = "щоденник Сетіра",
    },
    [2258] = {
        ["Buzzard Gizzard"] = "шлунок канюка",
        ["Crag Coyote Fang"] = "ікло скельного койота",
        ["Rock Elemental Shard"] = "уламок кам'яного елементаля",
    },
    [2282] = {
        ["Token of Thievery"] = "жетон розбійництва",
    },
    [2283] = {
        ["Shattered Necklace"] = "пошкоджене намисто",
    },
    [2339] = {
        ["Shattered Necklace Power Source"] = "джерело сили пошкодженого намиста",
        ["Shattered Necklace Ruby"] = "рубін пошкодженого намиста",
        ["Shattered Necklace Sapphire"] = "сапфір пошкодженого намиста",
        ["Shattered Necklace Topaz"] = "топаз пошкодженого намиста",
    },
    [2342] = {
        ["Garrett Family Treasure"] = "родинний скарб Ґарретів",
    },
    [2358] = {
        ["Horns of Nez'ra"] = "роги Нез'ри",
        ["Horns of Nez'ra (Provided)"] = "роги Нез'ри (видано)",
    },
    [2359] = {
        ["Defias Tower Key"] = "ключ від вежі Непокірних",
        ["Klaven Mortwake's Journal"] = "щоденник Клейвена Мортвейка",
    },
    [2381] = {
        ["Southsea Treasure"] = "скарб Південних морів",
    },
    [2418] = {
        ["An'Alleum Power Stone"] = "камінь сили Ан'Аллеума",
        ["Dentrium Power Stone"] = "дентрієвий камінь сили",
    },
    [2438] = {
        ["Emerald Dreamcatcher"] = "смарагдовий ловець снів",
    },
    [2459] = {
        ["Gnarlpine Mystic slain"] = "містик Кривої Сосни: убито",
        ["Tallonkai's Jewel"] = "самоцвіт Таллонкая",
    },
    [2478] = {
        ["Cache of Zanzil's Altered Mixture"] = "запас зміненої суміші Занзіла",
        ["Gallywix's Head"] = "голова Ґаллівікса",
        ["Mutated Venture Co. Drone slain"] = "мутований мрець ТзНБ \"Авантюра\": убито",
        ["Silixiz's Tower Key"] = "ключ від вежі Силіксиза",
        ["Venture Co. Lookout slain"] = "спостерігач ТзНБ \"Авантюра\": убито",
        ["Venture Co. Patroller slain"] = "патрульний ТзНБ \"Авантюра\": убито",
    },
    [2499] = {
        ["Gargantuan Tumor"] = "велетенська пухлина",
    },
    [2500] = {
        ["Buzzard Gizzard"] = "шлунок канюка",
        ["Crag Coyote Fang"] = "ікло скельного койота",
        ["Rock Elemental Shard"] = "уламок кам'яного елементаля",
    },
    [2501] = {
        ["Vessel of Dragon's Blood"] = "флакон з кров'ю дракона",
    },
    [2518] = {
        ["Silvery Spinnerets"] = "сріблопавутинні залози",
    },
    [2521] = {
        ["Flawless Draenethyst Sphere"] = "бездоганна сфера з дренетисту",
    },
    [2522] = {
        ["Flawless Draenethyst Sphere"] = "бездоганна сфера з дренетисту",
    },
    [2523] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [2541] = {
        ["Shaman Voodoo Charm"] = "шаманський оберіг вуду",
    },
    [2561] = {
        ["Rageclaw slain"] = "Лютопазур: убито",
    },
    [2581] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Snickerfang Jowl"] = "щелепа хихотуна",
    },
    [2582] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Snickerfang Jowl"] = "щелепа хихотуна",
    },
    [2583] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
    },
    [2584] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
    },
    [2585] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2586] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2601] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2602] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2603] = {
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2604] = {
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
    },
    [2605] = {
        ["Laden Dew Gland"] = "насичена росяна залоза",
    },
    [2609] = {
        ["Bronze Tube"] = "бронзова трубка",
        ["Leaded Vial"] = "свинцевий фіал",
        ["Simple Wildflowers"] = "прості польові квіти",
        ["Spool of Light Chartreuse Silk Thread"] = "котушка світло-оливкових шовкових ниток",
    },
    [2623] = {
        ["Warchief's Orders"] = "накази воєвождя",
    },
    [2641] = {
        ["Violet Tragan"] = "фіалковий траган",
    },
    [2741] = {
        ["Hippogryph Egg"] = "яйце гіпогрифа",
    },
    [2746] = {
        ["Clara's Fresh Apple"] = "свіже яблуко Клари",
        ["Silk Cloth"] = "шовкове полотно",
    },
    [2747] = {
        ["Extraordinary Egg"] = "незвичайне яйце",
    },
    [2748] = {
        ["Fine Egg"] = "чудове яйце",
    },
    [2749] = {
        ["Ordinary Egg"] = "звичайне яйце",
    },
    [2750] = {
        ["Bad Egg"] = "погане яйце",
    },
    [2751] = {
        ["Bronze Greatsword"] = "довгий бронзовий меч",
        ["Patterned Bronze Bracers"] = "візерунчасті бронзові поручі",
        ["Sharp Claw"] = "гострий кіготь",
    },
    [2752] = {
        ["Bronze Battle Axe"] = "бронзова бойова сокира",
        ["Bronze Warhammer"] = "бронзовий бойовий молот",
    },
    [2753] = {
        ["Green Iron Bracers"] = "зелені залізні браслети",
        ["Green Iron Helm"] = "зелений залізний шолом",
        ["Green Iron Leggings"] = "зелені залізні поножі",
    },
    [2754] = {
        ["Silvered Bronze Boots"] = "посріблені бронзові чоботи",
        ["Silvered Bronze Gauntlets"] = "посріблені бронзові рукавиці",
        ["Solid Iron Maul"] = "міцний залізний молот",
    },
    [2756] = {
        ["Steel Breastplate"] = "сталева кіраса",
        ["Steel Plate Helm"] = "сталевий шолом",
    },
    [2758] = {
        ["Golden Scale Bracers"] = "золоті лускаті браслети",
    },
    [2761] = {
        ["Iron Bar"] = "злиток заліза",
        ["Mithril Bar"] = "злиток мітрилу",
    },
    [2762] = {
        ["Mithril Bar"] = "злиток мітрилу",
        ["Truesilver Bar"] = "злиток ясносрібла",
    },
    [2763] = {
        ["Citrine"] = "цитрин",
        ["Mithril Bar"] = "злиток мітрилу",
    },
    [2768] = {
        ["Divino-matic Rod"] = "водоматичний стрижень",
    },
    [2770] = {
        ["Gahz'rilla's Electrified Scale"] = "наелектризована луска Ґаз'рілли",
    },
    [2771] = {
        ["Mithril Coif"] = "мітриловий капюшон",
        ["Ornate Mithril Shoulder"] = "вишукані мітрилові наплічники",
    },
    [2772] = {
        ["Heavy Mithril Boots"] = "важкі мітрилові чоботи",
        ["Ornate Mithril Pants"] = "вишукані мітрилові штани",
    },
    [2773] = {
        ["Heavy Mithril Breastplate"] = "важка мітрилова кіраса",
        ["Ornate Mithril Gloves"] = "вишукані мітрилові рукавиці",
    },
    [2781] = {
        ["Caliph Scorpidsting's Head"] = "голова Халіфа Скорпідожала",
    },
    [2821] = {
        ["Thick Yeti Hide"] = "товста шкура єті",
    },
    [2822] = {
        ["Thick Yeti Hide"] = "товста шкура єті",
    },
    [2841] = {
        ["Rig Blueprints"] = "креслення машини",
        ["Thermaplugg's Safe Combination"] = "код від сейфа Термоштепселя",
    },
    [2845] = {
        ["Shay's Bell"] = "дзвіночок Шей",
    },
    [2846] = {
        ["Tiara of the Deep"] = "тіара Глибин",
    },
    [2847] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [2848] = {
        ["Thick Armor Kit"] = "накладки з товстої шкіри",
        ["Wildvine"] = "диколоззя",
    },
    [2849] = {
        ["Turtle Scale Breastplate"] = "кіраса з черепашачої луски",
        ["Turtle Scale Gloves"] = "рукавиці з черепашачої луски",
        ["Wildvine"] = "диколоззя",
    },
    [2850] = {
        ["Nightscape Headband"] = "пов'язка нічного краєвиду",
        ["Nightscape Tunic"] = "мундир нічного краєвиду",
        ["Wildvine"] = "диколоззя",
    },
    [2851] = {
        ["Nightscape Boots"] = "чоботи нічного краєвиду",
        ["Nightscape Pants"] = "штани нічного краєвиду",
        ["Wildvine"] = "диколоззя",
    },
    [2852] = {
        ["Turtle Scale Bracers"] = "браслети з черепашачої луски",
        ["Turtle Scale Helm"] = "шолом з черепашачої луски",
        ["Wildvine"] = "диколоззя",
    },
    [2854] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [2855] = {
        ["Thick Armor Kit"] = "накладки з товстої шкіри",
        ["Wildvine"] = "диколоззя",
    },
    [2856] = {
        ["Turtle Scale Breastplate"] = "кіраса з черепашачої луски",
        ["Turtle Scale Gloves"] = "рукавиці з черепашачої луски",
        ["Wildvine"] = "диколоззя",
    },
    [2857] = {
        ["Nightscape Headband"] = "пов'язка нічного краєвиду",
        ["Nightscape Tunic"] = "мундир нічного краєвиду",
        ["Wildvine"] = "диколоззя",
    },
    [2858] = {
        ["Nightscape Boots"] = "чоботи нічного краєвиду",
        ["Nightscape Pants"] = "штани нічного краєвиду",
        ["Wildvine"] = "диколоззя",
    },
    [2859] = {
        ["Turtle Scale Bracers"] = "браслети з черепашачої луски",
        ["Turtle Scale Helm"] = "шолом з черепашачої луски",
        ["Wildvine"] = "диколоззя",
    },
    [2862] = {
        ["Woodpaw Gnoll Mane"] = "грива дереволапого гнола",
    },
    [2863] = {
        ["Woodpaw Alpha slain"] = "дереволапий альфа: убито",
    },
    [2865] = {
        ["Uncracked Scarab Shell"] = "цілий панцир скарабея",
    },
    [2869] = {
        ["Hatecrest Naga Scale"] = "луска наги Гребеня Ненависті",
    },
    [2870] = {
        ["Mysterious Relic"] = "таємнича реліквія",
    },
    [2873] = {
        ["Stoley's Shipment"] = "вантаж Стоулі",
    },
    [2875] = {
        ["Firebeard's Head"] = "голова Вогнебородого",
    },
    [2877] = {
        ["Green Sludge slain"] = "зелений шлам: убито",
        ["Jade Ooze slain"] = "нефритовий слизень: убито",
    },
    [2878] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [2879] = {
        ["Stave of Equinex"] = "посох рівнодення",
    },
    [2880] = {
        ["Troll Tribal Necklace"] = "племінне намисто тролів",
    },
    [2881] = {
        ["Troll Tribal Necklace"] = "племінне намисто тролів",
    },
    [2882] = {
        ["Cuergo's Key"] = "ключ Куерґо",
    },
    [2922] = {
        ["Techbot's Memory Core"] = "ядро пам'яті Техбота",
    },
    [2924] = {
        ["Essential Artificial"] = "базовий штучень",
    },
    [2926] = {
        ["Full Leaden Collection Phial"] = "наповнений свинцевий фіал для зразків",
    },
    [2928] = {
        ["Robo-mechanical Guts"] = "робо-механічні нутрощі",
    },
    [2930] = {
        ["Prismatic Punch Card"] = "призматична перфокарта",
    },
    [2934] = {
        ["Undamaged Venom Sac"] = "неушкоджена отруйна залоза",
    },
    [2937] = {
        ["Shadra's Venom"] = "отрута Шадри",
    },
    [2942] = {
        ["A Sparkling Stone"] = "іскристий камінь",
    },
    [2944] = {
        ["Snapshot of Gammerita"] = "знімок Ґаммеріти",
    },
    [2948] = {
        ["Moss Agate"] = "моховий агат",
        ["Silver Bar"] = "злиток срібла",
    },
    [2950] = {
        ["Moss Agate"] = "моховий агат",
        ["Silver Bar"] = "злиток срібла",
    },
    [2951] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [2953] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [2962] = {
        ["High Potency Radioactive Fallout"] = "високорадіоактивний осад",
    },
    [2970] = {
        ["Grimtotem Naturalist slain"] = "натураліст Зловісного Тотема: убито",
        ["Grimtotem Raider slain"] = "рейдер Зловісного Тотема: убито",
        ["Grimtotem Shaman slain"] = "шаман Зловісного Тотема: убито",
    },
    [2973] = {
        ["Iridescent Sprite Darter Wing"] = "переливчасте крило райдужного хамелеона",
    },
    [2974] = {
        ["Grimtotem Horn"] = "ріг Зловісного Тотема",
    },
    [2975] = {
        ["Gordunni Brute slain"] = "моцак Ґордунні: убито",
        ["Gordunni Ogre Mage slain"] = "огр-маг Ґордунні: убито",
        ["Gordunni Ogre slain"] = "огр Ґордунні: убито",
    },
    [2979] = {
        ["Gordunni Orb"] = "сфера Ґордунні",
    },
    [2980] = {
        ["Gordunni Mauler slain"] = "молотобій Ґордунні: убито",
        ["Gordunni Shaman slain"] = "шаман Ґордунні: убито",
        ["Gordunni Warlock slain"] = "чорнокнижник Ґордунні: убито",
    },
    [2982] = {
        ["Gordunni Brute slain"] = "моцак Ґордунні: убито",
        ["Gordunni Shaman slain"] = "шаман Ґордунні: убито",
        ["Gordunni Warlock slain"] = "чорнокнижник Ґордунні: убито",
    },
    [2987] = {
        ["Gordunni Cobalt"] = "кобальт Ґордунні",
    },
    [2991] = {
        ["Nekrum's Medallion"] = "медальйон Некрума",
    },
    [3042] = {
        ["Troll Temper"] = "трольське місиво",
    },
    [3062] = {
        ["Edana's Dark Heart"] = "темне серце Едани",
    },
    [3063] = {
        ["Northspring Harpy slain"] = "північноджерельна гарпія: убито",
        ["Northspring Roguefeather slain"] = "північноджерельна оперена пройдисвітка: убито",
        ["Northspring Slayer slain"] = "північноджерельна вбивця: убито",
        ["Northspring Windcaller slain"] = "північноджерельна вітрозовка: убито",
    },
    [3123] = {
        ["Wildkin Muisek"] = "зменшений совозвір",
    },
    [3124] = {
        ["Hippogryph Muisek"] = "зменшений гіпогриф",
    },
    [3125] = {
        ["Faerie Dragon Muisek"] = "зменшений чарівний дракончик",
    },
    [3126] = {
        ["Treant Muisek"] = "зменшений деревань",
    },
    [3127] = {
        ["Mountain Giant Muisek"] = "зменшений гірський велетень",
    },
    [3128] = {
        ["Encrusted Minerals"] = "вкритий кіркою мінерал",
        ["Metallic Fragments"] = "металеві фрагменти",
        ["Resilient Sinew"] = "еластичне сухожилля",
        ["Splintered Log"] = "розколота колода",
    },
    [3161] = {
        ["Gahz'ridian Ornament"] = "ґаз'ридіанська прикраса",
    },
    [3281] = {
        ["Stolen Silver"] = "вкрадене срібло",
    },
    [3341] = {
        ["Skull of the Coldbringer"] = "череп Стужевія",
    },
    [3361] = {
        ["Felix's Box"] = "коробка Фелікса",
        ["Felix's Bucket of Bolts"] = "відро з болтами Фелікса",
        ["Felix's Chest"] = "скриня Фелікса",
    },
    [3362] = {
        ["Gnarled Thistleshrub slain"] = "чортополоховий шкарбун: убито",
        ["Thistleshrub Rootshaper slain"] = "чортополоховий коренепліт: убито",
    },
    [3363] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [3372] = {
        ["Mysterious Artifact"] = "загадковий артефакт",
    },
    [3374] = {
        ["Chained Essence of Eranikus"] = "скута сутність Ераніка",
    },
    [3375] = {
        ["Coal"] = "вугілля",
        ["Mana Potion"] = "зілля мани",
        ["Sweet Nectar"] = "солодкий нектар",
    },
    [3376] = {
        ["Chief Sharptusk Thornmantle's Head"] = "голова вождя Гостроікла Колючкошкура",
    },
    [3378] = {
        ["Prayer to Elune"] = "молитва Елуні",
    },
    [3379] = {
        ["Shadowsilk Poacher slain"] = "браконьєр тінешовку: убито",
    },
    [3385] = {
        ["Clunk slain"] = "Брязк: убито",
        ["Trade Master Kovic slain"] = "майстер-торговець Ковіц: убито",
        ["Trader's Satchel"] = "торба торговця",
    },
    [3442] = {
        ["Golem Oil"] = "мастило голема",
        ["Heart of Flame"] = "серце полум'я",
    },
    [3443] = {
        ["Thorium Plated Dagger"] = "вкритий торієм кинджал",
    },
    [3444] = {
        ["Stone Circle"] = "круглий камінь",
    },
    [3449] = {
        ["Rubbing: Rune of Beth'Amara"] = "замальовка: руна Бет'Амара",
        ["Rubbing: Rune of Jin'yael"] = "замальовка: руна Джин'яель",
        ["Rubbing: Rune of Markri"] = "замальовка: руна Маркрі",
        ["Rubbing: Rune of Sael'hai"] = "замальовка: руна Сель'гай",
    },
    [3452] = {
        ["Symbol of Ragnaros"] = "знак Раґнароса",
    },
    [3501] = {
        ["Imperfect Draenethyst Fragment"] = "недосконалий фрагмент дренетисту",
    },
    [3502] = {
        ["Imperfect Draenethyst Fragment"] = "недосконалий фрагмент дренетисту",
    },
    [3505] = {
        ["Blood Elf Reclaimer slain"] = "ельф крові-відновник: убито",
        ["Blood Elf Surveyor slain"] = "ельф крові-землемір: убито",
    },
    [3506] = {
        ["Head of Magus Rimtori"] = "голова чаклунки Рімторі",
    },
    [3510] = {
        ["Hetaera's Beaten Head"] = "побита голова Гетаєри",
        ["Hetaera's Bloodied Head"] = "закривавлена голова Гетаєри",
        ["Hetaera's Bruised Head"] = "розбита голова Гетаєри",
    },
    [3514] = {
        ["Rynthariel the Keymaster slain"] = "ключниця Ринтаріель: убито",
    },
    [3517] = {
        ["Tablet of Beth'Amara"] = "скрижаль Бет'Амари",
        ["Tablet of Jin'yael"] = "скрижаль Джін'яеля",
        ["Tablet of Markri"] = "скрижаль Маркрі",
        ["Tablet of Sael'hai"] = "скрижаль Саель'гай",
    },
    [3521] = {
        ["Hyacinth Mushroom"] = "гіацинтовий гриб",
        ["Moonpetal Lily"] = "місяцепелюсткова лілея",
        ["Webwood Ichor"] = "сукровиця павутиннолісих",
    },
    [3524] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
    },
    [3527] = {
        ["First Mosh'aru Tablet"] = "перша скрижаль Мош'ару",
        ["Second Mosh'aru Tablet"] = "друга скрижаль Мош'ару",
    },
    [3528] = {
        ["Filled Egg of Hakkar"] = "наповнене яйце Гаккара",
    },
    [3566] = {
        ["Head of Lathoric the Black"] = "голова Латорика Чорного",
        ["Heart of Obsidion"] = "серце Обсидіона",
    },
    [3568] = {
        ["Filled Vial Labeled #1"] = "наповнений фіал №1",
        ["Filled Vial Labeled #2"] = "наповнений фіал №2",
        ["Filled Vial Labeled #3"] = "наповнений фіал №3",
        ["Filled Vial Labeled #4"] = "наповнений фіал №4",
    },
    [3601] = {
        ["Kim'Jael's Compass"] = "компас Кім'джаєля",
        ["Kim'Jael's Scope"] = "приціл Кім'джаєля",
        ["Kim'Jael's Stuffed Chicken"] = "плюшеве курча Кім'джаєля",
        ["Kim'Jael's Wizzlegoober"] = "відцентровий розтягувач Кім'джаєля",
    },
    [3602] = {
        ["Crystallized Azsharite"] = "кристалізований азшарит",
    },
    [3627] = {
        ["Amulet of Allistarj"] = "амулет Аллістаржа",
        ["Amulet of Grol"] = "амулет Ґрола",
        ["Amulet of Sevine"] = "амулет Севіни",
    },
    [3628] = {
        ["Severed Horn of the Defiler"] = "відрубаний ріг Губителя",
    },
    [3636] = {
        ["Amnennar the Coldbringer slain"] = "Амненнар Стужевій: убито",
    },
    [3638] = {
        ["Nixx's Signed Pledge"] = "підписана угода Нікса",
    },
    [3639] = {
        ["Big Iron Bomb"] = "велика залізна бомба",
        ["Explosive Sheep"] = "вибухова вівця",
        ["Solid Dynamite"] = "твердий динаміт",
    },
    [3640] = {
        ["Overspark's Signed Pledge"] = "підписана угода Надспалаха",
    },
    [3641] = {
        ["Accurate Scope"] = "точний приціл",
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Mithril Tube"] = "мітрилова трубка",
    },
    [3642] = {
        ["Oglethorpe's Signed Pledge"] = "підписана угода Оґлторпа",
    },
    [3643] = {
        ["Accurate Scope"] = "точний приціл",
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Mithril Tube"] = "мітрилова трубка",
    },
    [3661] = {
        ["Wildkin Feather"] = "перо дикого совуха",
    },
    [3741] = {
        ["Hilary's Necklace"] = "намисто Гіларі",
    },
    [3761] = {
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
    },
    [3764] = {
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
    },
    [3783] = {
        ["Thick Yeti Fur"] = "густе хутро єті",
    },
    [3785] = {
        ["Morrowgrain"] = "світанка",
    },
    [3786] = {
        ["Morrowgrain"] = "світанка",
    },
    [3791] = {
        ["Morrowgrain"] = "світанка",
    },
    [3792] = {
        ["Morrowgrain"] = "світанка",
    },
    [3802] = {
        ["Ironfel"] = "Залізоскверн",
    },
    [3803] = {
        ["Morrowgrain"] = "світанка",
    },
    [3804] = {
        ["Morrowgrain"] = "світанка",
    },
    [3822] = {
        ["Sha'ni's Nose-Ring"] = "обручка Ша'ні",
    },
    [3823] = {
        ["Firegut Brute slain"] = "вогнечеревий моцак: убито",
        ["Firegut Ogre Mage slain"] = "вогнечеревий огр-маг: убито",
        ["Firegut Ogre slain"] = "вогнечеревий огр: убито",
    },
    [3824] = {
        ["Gor'tesh's Lopped Off Head"] = "відрубана голова Ґор'теша",
    },
    [3842] = {
        ["Elixir of Fortitude"] = "еліксир стійкості",
    },
    [3845] = {
        ["Curled Map Parchment"] = "скручений пергамент з мапою",
        ["Large Compass"] = "великий компас",
        ["Lion-headed Key"] = "ключ з головою лева",
    },
    [3861] = {
        ["Special Chicken Feed"] = "спеціальний курячий корм",
    },
    [3881] = {
        ["Crate of Foodstuffs"] = "ящик з провізією",
        ["Research Equipment"] = "дослідницьке обладнання",
    },
    [3882] = {
        ["Dinosaur Bone"] = "кістка динозавра",
    },
    [3883] = {
        ["Hive Wall Sample"] = "зразок стіни вулика",
    },
    [3901] = {
        ["Rattlecage Skeleton slain"] = "брязкокістковий скелет: убито",
    },
    [3902] = {
        ["Scavenged Goods"] = "віднайдені припаси",
    },
    [3904] = {
        ["Milly's Harvest"] = "урожай Міллі",
    },
    [3906] = {
        ["Overmaster Pyron slain"] = "повелитель Пірон: убито",
    },
    [3907] = {
        ["Lord Incendius slain"] = "лорд Спалахій: убито",
        ["Tablet of Kurniya"] = "скрижаль Курнії",
    },
    [3909] = {
        ["Videre Elixir"] = "еліксир Відере",
    },
    [3922] = {
        ["Nugget Slug"] = "заготовка для деталі",
    },
    [3924] = {
        ["Samophlange Manual"] = "посібник з експлуатації самофланжу",
    },
    [3962] = {
        ["Blazerunner slain"] = "Жаропломінь: убито",
        ["Golden Flame"] = "золоте полум'я",
    },
    [4005] = {
        ["Silver Totem of Aquementas"] = "срібний тотем Акваментаса",
    },
    [4021] = {
        ["Piece of Krom'zar's Banner"] = "клаптик стягу Кром'зара",
    },
    [4022] = {
        ["Black Dragonflight Molt"] = "скинута шкіра чорного дракона",
    },
    [4023] = {
        ["Black Dragonflight Molt"] = "скинута шкіра чорного дракона",
    },
    [4024] = {
        ["Encased Fiery Essence"] = "захоплена вогняна сутність",
    },
    [4041] = {
        ["Evoroot"] = "духокорінь",
    },
    [4061] = {
        ["Fractured Elemental Shard"] = "тріснутий уламок елементаля",
    },
    [4063] = {
        ["Head of Argelmach"] = "голова Арґельмаха",
        ["Intact Elemental Core"] = "неушкоджене ядро елементаля",
    },
    [4081] = {
        ["Anvilrage Footman slain"] = "піхотинець Лютого Ковадла: убито",
        ["Anvilrage Guardsman slain"] = "гвардієць Лютого Ковадла: убито",
        ["Anvilrage Warden slain"] = "вартовий Лютого Ковадла: убито",
    },
    [4082] = {
        ["Anvilrage Medic slain"] = "медик Лютого Ковадла: убито",
        ["Anvilrage Officer slain"] = "офіцер Лютого Ковадла: убито",
        ["Anvilrage Soldier slain"] = "солдат Лютого Ковадла: убито",
    },
    [4083] = {
        ["Gold Bar"] = "злиток золота",
        ["Star Ruby"] = "зоряний рубін",
        ["Truesilver Bar"] = "злиток ясносрібла",
    },
    [4084] = {
        ["Irontree Heart"] = "залізодеревне серце",
        ["Silvery Claws"] = "сріблясті пазурі",
    },
    [4101] = {
        ["Blood Amber"] = "кривавий бурштин",
    },
    [4102] = {
        ["Blood Amber"] = "кривавий бурштин",
    },
    [4103] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
    },
    [4104] = {
        ["Tainted Vitriol"] = "уражений купорос",
    },
    [4105] = {
        ["Fel Creep"] = "залишок скверни",
    },
    [4106] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
    },
    [4107] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
    },
    [4108] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
    },
    [4109] = {
        ["Tainted Vitriol"] = "уражений купорос",
    },
    [4110] = {
        ["Fel Creep"] = "залишок скверни",
    },
    [4111] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
    },
    [4112] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
    },
    [4113] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4114] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4115] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4116] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4117] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4118] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4119] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4120] = {
        ["Angerclaw Grizzly slain"] = "гризлі-лютопазур: убито",
        ["Felpaw Ravager slain"] = "сквернолапий спустошник: убито",
    },
    [4121] = {
        ["Thorium Shackles"] = "торієві кайдани",
    },
    [4123] = {
        ["The Heart of the Mountain"] = "Серце гори",
    },
    [4126] = {
        ["Lost Thunderbrew Recipe"] = "втрачений рецепт Громоварів",
    },
    [4132] = {
        ["General Angerforge slain"] = "генерал Кузня Гніву: убито",
    },
    [4134] = {
        ["Lost Thunderbrew Recipe"] = "втрачений рецепт Громоварів",
    },
    [4136] = {
        ["Ribbly's Head"] = "голова Рібблі",
    },
    [4141] = {
        ["Bloodpetal"] = "кровоцвіт",
    },
    [4143] = {
        ["Atal'ai Haze"] = "туман Атал'ай",
    },
    [4144] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
    },
    [4145] = {
        ["Bloodpetal Flayer slain"] = "кровоцвіт-потрошитель: убито",
        ["Bloodpetal Lasher slain"] = "кровоцвіт-хляскун: убито",
        ["Bloodpetal Thresher slain"] = "кровоцвіт-молотник: убито",
        ["Bloodpetal Trapper slain"] = "кровоцвіт-капканник: убито",
    },
    [4146] = {
        ["Atal'ai Haze"] = "туман Атал'ай",
    },
    [4148] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
    },
    [4161] = {
        ["Small Spider Leg"] = "мала павуча лапка",
    },
    [4182] = {
        ["Black Broodling slain"] = "чорне драконеня: убито",
        ["Black Dragonspawn slain"] = "чорний драконід: убито",
        ["Black Drake slain"] = "чорний дракончик: убито",
        ["Black Wyrmkin slain"] = "чорна драконіда: убито",
    },
    [4201] = {
        ["Giant Silver Vein"] = "величезна срібна жила",
        ["Gromsblood"] = "ґромокров",
        ["Nagmara's Filled Vial"] = "наповнений флакон Наґмари",
    },
    [4221] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4222] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4244] = {
        ["Mithril Casing"] = "мітрилова обшивка",
    },
    [4262] = {
        ["Overmaster Pyron slain"] = "повелитель Пірон: убито",
    },
    [4263] = {
        ["Lord Incendius slain"] = "лорд Спалахій: убито",
    },
    [4282] = {
        ["Marshal Windsor's Lost Information"] = "втрачена інформація маршала Віндзора",
    },
    [4283] = {
        ["Blackrock Medallion"] = "медальйон Чорнокаменю",
    },
    [4284] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
    },
    [4286] = {
        ["Dark Iron Fanny Pack"] = "поясна сумка Темного Заліза",
    },
    [4289] = {
        ["Un'Goro Gorilla Pelt"] = "шкура ун'ґорської горили",
        ["Un'Goro Stomper Pelt"] = "шкура ун'ґорського топотуна",
        ["Un'Goro Thunderer Pelt"] = "шкура ун'ґорського рокотуна",
    },
    [4290] = {
        ["Piece of Threshadon Carcass"] = "шматок туші молотодона",
    },
    [4291] = {
        ["Ravasaur Pheromone Gland"] = "феромонна залоза равазавра",
    },
    [4292] = {
        ["Lar'korwi's Head"] = "голова Лар'корві",
    },
    [4293] = {
        ["Corrupted Felwood Sample"] = "забруднений сквернолісний зразок",
    },
    [4294] = {
        ["Pure Un'Goro Sample"] = "чистий ун'ґорський зразок",
    },
    [4295] = {
        ["Dark Iron Ale Mug"] = "кухоль елю Темного Заліза",
    },
    [4296] = {
        ["Tablet Transcript"] = "текст зі скрижалі",
    },
    [4297] = {
        ["Silvermane Stalker Flank"] = "вирізка срібногривого ловця",
    },
    [4300] = {
        ["White Ravasaur Claw"] = "білий кіготь равазавра",
    },
    [4301] = {
        ["U'cha's Pelt"] = "шкура У'чі",
    },
    [4343] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4381] = {
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
    },
    [4382] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Green Power Crystal"] = "зелений кристал сили",
    },
    [4383] = {
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Red Power Crystal"] = "червоний кристал сили",
    },
    [4384] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Red Power Crystal"] = "червоний кристал сили",
    },
    [4385] = {
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
    },
    [4386] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
    },
    [4401] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4402] = {
        ["Cactus Apple"] = "кактусове яблуко",
    },
    [4403] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4421] = {
        ["Jadefire Felsworn slain"] = "нефритожарий скверноклят: убито",
        ["Jadefire Rogue slain"] = "нефритожарий пройдисвіт: убито",
        ["Jadefire Shadowstalker slain"] = "нефритожарий тінелов: убито",
        ["Xavathras slain"] = "Заватрас: убито",
    },
    [4441] = {
        ["Vial of Blessed Water"] = "флакон з благословенною водою",
    },
    [4443] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4444] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4445] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4446] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4447] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4448] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4449] = {
        ["Dark Iron Geologist slain"] = "геолог Темного Заліза: убито",
        ["Silk Cloth"] = "шовкове полотно",
    },
    [4450] = {
        ["Goodsteel Ledger"] = "гросбух Файносталя",
        ["Goodsteel's Balanced Flameberge"] = "збалансований фламберг Файносталя",
        ["Overdue Package"] = "затриманий пакунок",
        ["Solid Crystal Leg Shaft"] = "міцна кришталева лапа",
    },
    [4461] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4462] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4463] = {
        ["Black Blood of the Tormented"] = "чорна кров закатованих",
        ["Black Diamond"] = "чорний діамант",
        ["Gizzard Gum"] = "шлункова жуйка",
        ["Libram of Rumination"] = "манускрипт роздумів",
    },
    [4464] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4465] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4466] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4467] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
    },
    [4481] = {
        ["Black Diamond"] = "чорний діамант",
        ["Libram of Constitution"] = "манускрипт статури",
        ["Lung Juice Cocktail"] = "легеневий коктейль",
        ["Night Dragon's Breath"] = "подих нічного дракона",
    },
    [4482] = {
        ["Black Diamond"] = "чорний діамант",
        ["Crystal Ward"] = "кристалічний захист",
        ["Eye of Kajal"] = "око Каджала",
        ["Libram of Tenacity"] = "манускрипт наполегливості",
    },
    [4483] = {
        ["Black Diamond"] = "чорний діамант",
        ["Burning Essence"] = "палаюча сутність",
        ["Crystal Spire"] = "кристалічне вістря",
        ["Libram of Resilience"] = "манускрипт стійкості",
    },
    [4484] = {
        ["Black Diamond"] = "чорний діамант",
        ["Crystal Force"] = "кристалічна сила",
        ["Libram of Voracity"] = "манускрипт жадібності",
        ["Whipper Root Tuber"] = "плід кнутокореня",
    },
    [4496] = {
        ["Gorishi Scent Gland"] = "пахуча залоза Ґоріші",
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
    },
    [4501] = {
        ["Frenzied Pterrordax slain"] = "навіжений жаходактиль: убито",
        ["Pterrordax slain"] = "жаходактиль: убито",
    },
    [4502] = {
        ["Un'Goro Ash"] = "попіл Ун'Ґоро",
    },
    [4503] = {
        ["Webbed Diemetradon Scale"] = "перетинчаста луска деметродона",
        ["Webbed Pterrordax Scale"] = "перетинчаста луска жаходактиля",
    },
    [4504] = {
        ["Super Sticky Tar"] = "надлипка смола",
    },
    [4505] = {
        ["Filled Flasket"] = "наповнена колба",
    },
    [4507] = {
        ["Gorishi Queen Brain"] = "мозок королеви Ґоріші",
    },
    [4512] = {
        ["Filled Cursed Ooze Jar"] = "наповнена проклятим слизом банка",
        ["Filled Tainted Ooze Jar"] = "наповнена забрудненим слизом банка",
    },
    [4513] = {
        ["Filled Pure Sample Jar"] = "наповнена чистим слизом банка",
    },
    [4521] = {
        ["Ragged Owlbeast slain"] = "обдертий совозвір: убито",
        ["Raging Owlbeast slain"] = "лютий совозвір: убито",
    },
    [4561] = {
        ["Un'Goro Slime Sample"] = "зразок ун'ґорського слизу",
    },
    [4601] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [4602] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [4603] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [4604] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
    },
    [4621] = {
        ["Baron Revilgaz slain"] = "барон Ревілґаз: убито",
        ["Fleet Master Seahorn slain"] = "командувач флоту Морський Ріг: убито",
    },
    [4642] = {
        ["Merged Ooze Sample"] = "об'єднаний зразок слизу",
    },
    [4661] = {
        ["Felwood Slime Sample"] = "зразок сквернолісного слизу",
    },
    [4681] = {
        ["Sea Turtle Remains"] = "рештки морської черепахи",
    },
    [4701] = {
        ["Halycon slain"] = "Галікон: убито",
    },
    [4721] = {
        ["Berserk Owlbeast slain"] = "совозвір-берсерк: убито",
    },
    [4724] = {
        ["Halycon slain"] = "Галікон: убито",
    },
    [4726] = {
        ["Broodling Essence"] = "сутність малечі",
    },
    [4729] = {
        ["Caged Worg Pup"] = "клітка з цуценям ворга",
    },
    [4735] = {
        ["Collected Dragon Egg"] = "зібране яйце дракона",
    },
    [4740] = {
        ["Murkdeep slain"] = "Глибоморок: убито",
    },
    [4741] = {
        ["Moontouched Owlbeast slain"] = "осяяний місяцем совозвір: убито",
    },
    [4742] = {
        ["Gemstone of Bloodaxe"] = "самоцвіт Кривавої Сокири",
        ["Gemstone of Smolderthorn"] = "самоцвіт Зотлілого Терену",
        ["Gemstone of Spirestone"] = "самоцвіт Кам'яного Шпиля",
        ["Unadorned Seal of Ascension"] = "неприкрашена печатка Вознесіння",
    },
    [4743] = {
        ["Forged Seal of Ascension"] = "викувана печатка Вознесіння",
    },
    [4762] = {
        ["Cliffspring River Sample"] = "зразок води зі Скельноджерельної річки",
    },
    [4763] = {
        ["Talisman of Corruption"] = "талісман порчі",
    },
    [4764] = {
        ["Doomrigger's Clasp"] = "доленосна застібка",
    },
    [4767] = {
        ["Highperch Wyvern Egg"] = "яйце виверни з Високого Сідала",
    },
    [4768] = {
        ["Darkstone Tablet"] = "скрижаль Темнокаменя",
    },
    [4771] = {
        ["Vectus slain"] = "Вектус: убито",
    },
    [4781] = {
        ["Gold Bar"] = "злиток золота",
    },
    [4783] = {
        ["Lesser Infernal Stone"] = "камінь молодшого пекельника",
        ["Vial of Hatefury Blood"] = "флакон крові скаженолютого сатира",
    },
    [4784] = {
        ["Fine Gold Thread"] = "тонка золота нитка",
        ["Smoldering Coal"] = "жаристе вугілля",
        ["Soul Shard"] = "уламок душі",
    },
    [4787] = {
        ["Ancient Egg"] = "древнє яйце",
    },
    [4788] = {
        ["Fifth Mosh'aru Tablet"] = "п'ята скрижаль Мош'ару",
        ["Sixth Mosh'aru Tablet"] = "шоста скрижаль Мош'ару",
    },
    [4801] = {
        ["Frostsaber E'ko"] = "е'ко кригозубів",
    },
    [4802] = {
        ["Winterfall E'ko"] = "е'ко зимокрайових",
    },
    [4803] = {
        ["Shardtooth E'ko"] = "е'ко щербозубів",
    },
    [4804] = {
        ["Chillwind E'ko"] = "е'ко студовіїв",
    },
    [4805] = {
        ["Ice Thistle E'ko"] = "е'ко льодореп'яхових",
    },
    [4806] = {
        ["Frostmaul E'ko"] = "е'ко кригобоїв",
    },
    [4807] = {
        ["Wildkin E'ko"] = "е'ко диких совухів",
    },
    [4809] = {
        ["Uncracked Chillwind Horn"] = "неушкоджений ріг студовія",
    },
    [4812] = {
        ["Moonwell Water Tube"] = "посудина з водою місячного колодязя",
    },
    [4821] = {
        ["Alien Egg"] = "чужоземне яйце",
    },
    [4822] = {
        ["Tigule's Strawberry Ice Cream"] = "полуничне морозиво Тіґуля",
    },
    [4841] = {
        ["Galak Scout slain"] = "розвідник племені Ґалак: убито",
        ["Galak Windchaser slain"] = "вітроловка племені Ґалак: убито",
        ["Galak Wrangler slain"] = "чередник племені Ґалак: убито",
    },
    [4862] = {
        ["Spire Spider Egg"] = "яйце шпильного павука",
    },
    [4864] = {
        ["Blue-feathered Amulet"] = "амулет з синього пір'я",
        ["Jaron's Supplies"] = "припаси Жарона",
    },
    [4867] = {
        ["Warosh's Mojo"] = "талісман Вароша",
    },
    [4903] = {
        ["Highlord Omokk slain"] = "верховний повелитель Омокк: убито",
        ["Important Blackrock Documents"] = "важливі папери Чорнокаменю",
        ["War Master Voone slain"] = "воєначальник Вун: убито",
    },
    [4906] = {
        ["Jadefire Betrayer slain"] = "нефритожарий зрадник: убито",
        ["Jadefire Hellcaller slain"] = "нефритожарий пеклоклик: убито",
        ["Jadefire Trickster slain"] = "нефритожарий ошуст: убито",
        ["Xavaric slain"] = "Заварік: убито",
    },
    [4961] = {
        ["Demon of the Orb slain"] = "демон сфери: убито",
    },
    [4962] = {
        ["Imprisoned Felhound Spirit"] = "ув'язнений дух сквернопса",
    },
    [4963] = {
        ["Imprisoned Infernal Spirit"] = "ув'язнений дух пекельника",
    },
    [4970] = {
        ["Chillwind Meat"] = "м'ясо студовія",
        ["Shardtooth Meat"] = "м'ясо щербозуба",
    },
    [4971] = {
        ["Temporal Parasite slain"] = "часовий паразит: убито",
    },
    [4972] = {
        ["Andorhal Watch"] = "годинник Андорала",
    },
    [4973] = {
        ["Andorhal Watch"] = "годинник Андорала",
    },
    [4974] = {
        ["Head of Rend Blackhand"] = "голова Ренда Чорнорука",
    },
    [4982] = {
        ["Bijou's Belongings"] = "речі Блискітки",
    },
    [4984] = {
        ["Diseased Wolf slain"] = "хворий вовк: убито",
    },
    [4985] = {
        ["Diseased Grizzly slain"] = "хворий гризлі: убито",
    },
    [5001] = {
        ["Bijou's Belongings"] = "речі Блискітки",
    },
    [5041] = {
        ["Crossroads' Supply Crates"] = "ящики з припасами для Перехрестя",
    },
    [5042] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5043] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5044] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5045] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5046] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5051] = {
        ["Good Luck Charm"] = "оберіг доброї вдачі",
    },
    [5052] = {
        ["Blood Shard"] = "кривавий скалок",
    },
    [5054] = {
        ["Ursius slain"] = "Урсій: убито",
    },
    [5055] = {
        ["Brumeran slain"] = "Брумеран: убито",
    },
    [5056] = {
        ["Shy-Rotam slain"] = "Ши-Ротам: убито",
    },
    [5059] = {
        ["Dalson Outhouse Key"] = "ключ від вбиральні Дальсона",
    },
    [5060] = {
        ["Dalson Cabinet Key"] = "ключ від шафи Дальсона",
    },
    [5062] = {
        ["Incendia Agave"] = "вогниста агава",
    },
    [5063] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Enchanted Scarlet Thread"] = "зачарована багряна нитка",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
    },
    [5064] = {
        ["Secret Note #1"] = "таємна записка №1",
        ["Secret Note #2"] = "таємна записка №2",
        ["Secret Note #3"] = "таємна записка №3",
    },
    [5065] = {
        ["Fourth Mosh'aru Tablet"] = "четверта скрижаль Мош'ару",
        ["Third Mosh'aru Tablet"] = "третя скрижаль Мош'ару",
    },
    [5067] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frostwhisper's Embalming Fluid"] = "бальзамувальна рідина Кригошепта",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
    },
    [5068] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
        ["Skin of Shadow"] = "шкіра тіні",
    },
    [5081] = {
        ["Highlord Omokk slain"] = "верховний повелитель Омокк: убито",
        ["War Master Voone slain"] = "воєначальник Вун: убито",
    },
    [5082] = {
        ["Winterfall Den Watcher slain"] = "зимокрайовий наглядач лігва: убито",
        ["Winterfall Pathfinder slain"] = "зимокрайовий слідопит: убито",
        ["Winterfall Totemic slain"] = "зимокрайовий тотеміст: убито",
    },
    [5086] = {
        ["Toxic Horror Droplet"] = "крапля токсичного страховища",
    },
    [5087] = {
        ["Winterfall Crate"] = "ящик Зимокрайових",
    },
    [5088] = {
        ["Arikara Serpent Skin"] = "зміїна шкіра Арікари",
    },
    [5092] = {
        ["Skeletal Flayer slain"] = "скелетний потрошитель: убито",
        ["Slavering Ghoul slain"] = "слинявий гуль: убито",
    },
    [5121] = {
        ["High Chief Winterfall slain"] = "верховний вождь Зимокрай: убито",
    },
    [5122] = {
        ["Medallion of Faith"] = "медальйон віри",
    },
    [5124] = {
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Essence of Fire"] = "сутність вогню",
        ["Star Ruby"] = "зоряний рубін",
        ["Unfired Plate Gauntlets"] = "неопалені латні рукавиці",
    },
    [5127] = {
        ["Soul Stained Pike"] = "наповнена душею піка",
        ["Unforged Rune Covered Breastplate"] = "прототип рунічного нагрудника",
    },
    [5141] = {
        ["Tough Scorpid Breastplate"] = "міцна кіраса з луски скорпіда",
        ["Tough Scorpid Gloves"] = "міцні рукавиці з луски скорпіда",
        ["Worn Dragonscale"] = "зношена драконяча луска",
    },
    [5143] = {
        ["Wild Leather Helmet"] = "шолом з дикої шкіри",
        ["Wild Leather Vest"] = "жилет з дикої шкіри",
    },
    [5144] = {
        ["Breath of Wind"] = "подих вітру",
        ["Core of Earth"] = "ядро землі",
        ["Globe of Water"] = "куля води",
        ["Heart of Fire"] = "серце вогню",
    },
    [5145] = {
        ["Tough Scorpid Breastplate"] = "міцна кіраса з луски скорпіда",
        ["Tough Scorpid Gloves"] = "міцні рукавиці з луски скорпіда",
        ["Worn Dragonscale"] = "зношена драконяча луска",
    },
    [5146] = {
        ["Breath of Wind"] = "подих вітру",
        ["Core of Earth"] = "ядро землі",
        ["Globe of Water"] = "куля води",
        ["Heart of Fire"] = "серце вогню",
    },
    [5147] = {
        ["Arnak's Hoof"] = "копито Арнака",
    },
    [5148] = {
        ["Wild Leather Helmet"] = "шолом з дикої шкіри",
        ["Wild Leather Vest"] = "жилет з дикої шкіри",
    },
    [5149] = {
        ["Pamela's Doll"] = "лялька Памели",
    },
    [5150] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
    },
    [5151] = {
        ["Hypercapacitor Gizmo"] = "гіперконденсатор",
    },
    [5153] = {
        ["Joseph's Wedding Ring"] = "обручка Джозефа",
    },
    [5154] = {
        ["Annals of Darrowshire"] = "літопис Дарроушира",
    },
    [5155] = {
        ["Jaedenar Adept slain"] = "джеденарський адепт: убито",
        ["Jaedenar Cultist slain"] = "джеденарський культист: убито",
        ["Jaedenar Guardian slain"] = "джеденарський вартовий: убито",
        ["Jaedenar Hound slain"] = "джеденарська гонча: убито",
    },
    [5156] = {
        ["Entropic Beast slain"] = "ентропічний звір: убито",
        ["Entropic Horror slain"] = "ентропічний жах: убито",
    },
    [5157] = {
        ["Corrupt Moonwell Water"] = "заражена вода місячного колодязя",
    },
    [5166] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Brilliant Chromatic Scale"] = "блискуча хроматична луска",
        ["Chromatic Carapace"] = "хроматичний панцир",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
    },
    [5167] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Brilliant Chromatic Scale"] = "блискуча хроматична луска",
        ["Chromatic Carapace"] = "хроматичний панцир",
        ["Skin of Shadow"] = "шкіра тіні",
    },
    [5168] = {
        ["Davil's Libram"] = "манускрипт Дейвіла",
        ["Redpath's Shield"] = "щит Редпата",
    },
    [5181] = {
        ["Shattered Sword of Marduk"] = "розбитий меч Мардука",
        ["Skull of Horgus"] = "череп Горґуса",
    },
    [5201] = {
        ["Winterfall Shaman slain"] = "зимокрайовий шаман: убито",
        ["Winterfall Ursa slain"] = "зимокрайовий урса: убито",
    },
    [5204] = {
        ["Rakaiah slain"] = "Ракайя: убито",
    },
    [5206] = {
        ["Resonating Skull"] = "резонівний череп",
    },
    [5212] = {
        ["Plagued Flesh Sample"] = "зразок зачумленої плоті",
    },
    [5213] = {
        ["Scourge Data"] = "дані про Скару",
    },
    [5214] = {
        ["Grimm's Premium Tobacco"] = "преміальний тютюн Ґрімма",
    },
    [5216] = {
        ["Felstone Field Cauldron Key"] = "ключ від котла Сквернокам'яного поля",
    },
    [5218] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Osseous Agitator"] = "кістяний каталізатор",
        ["Runecloth"] = "рунічне полотно",
    },
    [5219] = {
        ["Dalson's Tears Cauldron Key"] = "ключ від котла Сліз Дальсона",
    },
    [5221] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Runecloth"] = "рунічне полотно",
        ["Somatic Intensifier"] = "соматичний підсилювач",
    },
    [5222] = {
        ["Writhing Haunt Cauldron Key"] = "ключ від котла Крученого Привида",
    },
    [5224] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Runecloth"] = "рунічне полотно",
        ["Somatic Intensifier"] = "соматичний підсилювач",
    },
    [5225] = {
        ["Gahrron's Withering Cauldron Key"] = "ключ від котла Посухи Ґаррона",
    },
    [5227] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Ectoplasmic Resonator"] = "ектоплазматичний резонатор",
        ["Runecloth"] = "рунічне полотно",
    },
    [5229] = {
        ["Felstone Field Cauldron Key"] = "ключ від котла Сквернокам'яного поля",
    },
    [5231] = {
        ["Dalson's Tears Cauldron Key"] = "ключ від котла Сліз Дальсона",
    },
    [5233] = {
        ["Writhing Haunt Cauldron Key"] = "ключ від котла Крученого Привида",
    },
    [5235] = {
        ["Gahrron's Withering Cauldron Key"] = "ключ від котла Посухи Ґаррона",
    },
    [5242] = {
        ["Moora slain"] = "Мура: убито",
        ["Salia slain"] = "Салія: убито",
        ["Shadow Lord Fel'dan's Head"] = "голова лорда тіней Фел'дана",
    },
    [5243] = {
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
    },
    [5245] = {
        ["First Relic Fragment"] = "перший фрагмент реліквії",
        ["Fourth Relic Fragment"] = "четвертий фрагмент реліквії",
        ["Second Relic Fragment"] = "другий фрагмент реліквії",
        ["Third Relic Fragment"] = "третій фрагмент реліквії",
    },
    [5246] = {
        ["Sacred Highborne Writings"] = "священні писання високородних",
    },
    [5247] = {
        ["Crystal Restore"] = "кристалічне відновлення",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Vial of Dire Water"] = "флакон зі зловісною водою",
    },
    [5251] = {
        ["Archivist Galford slain"] = "архіваріус Ґалфорд: убито",
    },
    [5263] = {
        ["Head of Baron Rivendare"] = "голова барона Рівендера",
    },
    [5283] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Breastplate"] = "вишукана мітрилова кіраса",
        ["Ornate Mithril Helm"] = "вишуканий мітриловий шолом",
    },
    [5284] = {
        ["Big Black Mace"] = "велика чорна булава",
        ["Heavy Mithril Axe"] = "важка мітрилова сокира",
        ["Massive Iron Axe"] = "масивна залізна сокира",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
    },
    [5301] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Breastplate"] = "вишукана мітрилова кіраса",
        ["Ornate Mithril Helm"] = "вишуканий мітриловий шолом",
    },
    [5302] = {
        ["Big Black Mace"] = "велика чорна булава",
        ["Heavy Mithril Axe"] = "важка мітрилова сокира",
        ["Massive Iron Axe"] = "масивна залізна сокира",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
    },
    [5305] = {
        ["Crimson Hammersmith's Apron"] = "фартух багряного коваля молотів",
    },
    [5306] = {
        ["Vosh'gajin's Snakestone"] = "змієкамінь Вош'ґаджин",
    },
    [5307] = {
        ["Insignia of the Black Guard"] = "знак Чорної Варти",
    },
    [5321] = {
        ["Horn of Awakening"] = "ріг пробудження",
    },
    [5341] = {
        ["The Deed to Brill"] = "документи на Брілль",
        ["The Deed to Caer Darrow"] = "документи на Тверджу Дарроу",
        ["The Deed to Southshore"] = "документи на Південнобережжя",
        ["The Deed to Tarren Mill"] = "документи на Тарренський Млин",
    },
    [5342] = {
        ["Head of Weldon Barov"] = "голова Велдона Барова",
    },
    [5343] = {
        ["The Deed to Brill"] = "документи на Брілль",
        ["The Deed to Caer Darrow"] = "документи на Тверджу Дарроу",
        ["The Deed to Southshore"] = "документи на Південнобережжя",
        ["The Deed to Tarren Mill"] = "документи на Тарренський Млин",
    },
    [5344] = {
        ["Head of Alexi Barov"] = "голова Алексія Барова",
    },
    [5381] = {
        ["Demon Box"] = "демонічна скриня",
    },
    [5382] = {
        ["Doctor Theolen Krastinov slain"] = "доктор Теолен Крастінов: убито",
    },
    [5384] = {
        ["Kirtonos the Herald slain"] = "Вісник Кіртонос: убито",
    },
    [5386] = {
        ["Bloodbelly Fish"] = "кровочеревка",
    },
    [5402] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
    },
    [5403] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
    },
    [5404] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
    },
    [5406] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
    },
    [5407] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
    },
    [5408] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
    },
    [5421] = {
        ["Shellfish"] = "молюск",
    },
    [5461] = {
        ["Keepsake of Remembrance"] = "спогад про людяність",
    },
    [5466] = {
        ["Human Head of Ras Frostwhisper"] = "людська голова Раса Кригошепта",
    },
    [5481] = {
        ["Gloom Weed"] = "бур'ян мороку",
    },
    [5482] = {
        ["Doom Weed"] = "бур'ян приречення",
    },
    [5501] = {
        ["Kodo Bone"] = "кістка кодо",
    },
    [5502] = {
        ["Orcish Orphan Whistle"] = "свисток орка-сироти",
    },
    [5504] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5507] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5508] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
    },
    [5509] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
    },
    [5510] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
    },
    [5513] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5515] = {
        ["Krastinov's Bag of Horrors"] = "мішок жахів Крастінова",
    },
    [5517] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5518] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Ogre Tannin"] = "огрська дубильна рідина",
        ["Rugged Leather"] = "міцна шкіра",
        ["Rune Thread"] = "рунічна нитка",
    },
    [5519] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Ogre Tannin"] = "огрська дубильна рідина",
        ["Rugged Leather"] = "міцна шкіра",
        ["Rune Thread"] = "рунічна нитка",
    },
    [5521] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5524] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [5525] = {
        ["Gordok Shackle Key"] = "ключ від кайданів Ґордока",
    },
    [5526] = {
        ["Sealed Reliquary of Purity"] = "запечатаний релікварій чистоти",
    },
    [5527] = {
        ["Reliquary of Purity"] = "релікварій чистоти",
    },
    [5529] = {
        ["Plagued Hatchling slain"] = "зачумлене дитинча дракона: убито",
    },
    [5534] = {
        ["Some Rune"] = "якась руна",
    },
    [5535] = {
        ["Highborne Apparition slain"] = "високородна примара: убито",
        ["Highborne Lichling slain"] = "високородна тінь: убито",
    },
    [5536] = {
        ["Haldarr Felsworn slain"] = "гальдаррсьский скверноклят: убито",
        ["Haldarr Satyr slain"] = "гальдаррсьский сатир: убито",
        ["Haldarr Trickster slain"] = "гальдаррсьский ошуст: убито",
    },
    [5537] = {
        ["Skeletal Fragments"] = "фрагменти скелетів",
    },
    [5541] = {
        ["Rumbleshot's Ammo"] = "набої Грімостріла",
    },
    [5542] = {
        ["Frenzied Plaguehound slain"] = "навіжена чумна гонча: убито",
        ["Plaguehound Runt slain"] = "карликова чумна гонча: убито",
        ["Plaguehound slain"] = "чумна гонча: убито",
    },
    [5543] = {
        ["Plaguebat slain"] = "чумний кажан: убито",
    },
    [5544] = {
        ["Slab of Carrion Worm Meat"] = "шматок м'яса трупного черв'яка",
    },
    [5545] = {
        ["Bundle of Wood"] = "зв'язка деревини",
    },
    [5723] = {
        ["Ragefire Shaman slain"] = "шаман Лютого Полум'я: убито",
        ["Ragefire Trogg slain"] = "трог Лютого Полум'я: убито",
    },
    [5725] = {
        ["Incantations from the Nether"] = "Чаклунство з Підсвіття",
        ["Spells of Shadow"] = "Закляття Темряви",
    },
    [5726] = {
        ["Lieutenant's Insignia"] = "знак розрізнення лейтенанта",
    },
    [5728] = {
        ["Bazzalan slain"] = "Баззалан: убито",
        ["Jergosh the Invoker slain"] = "Єргош-Заклинатель: убито",
    },
    [5741] = {
        ["Sceptre of Light"] = "скіпетр світла",
    },
    [5761] = {
        ["Taragaman the Hungerer's Heart"] = "серце Тараґамана Ненажерливого",
    },
    [5781] = {
        ["Taelan's Hammer"] = "молот Телана",
    },
    [5801] = {
        ["Unfinished Skeleton Key"] = "незавершений скелетний ключ",
    },
    [5802] = {
        ["Unfinished Skeleton Key"] = "незавершений скелетний ключ",
    },
    [5803] = {
        ["Araj's Scarab"] = "скарабей Аража",
    },
    [5804] = {
        ["Araj's Scarab"] = "скарабей Аража",
    },
    [5845] = {
        ["Symbol of Lost Honor"] = "символ втраченої честі",
    },
    [5848] = {
        ["Of Love and Family"] = "Сімейна любов",
    },
    [5863] = {
        ["Dunemaul Brute slain"] = "моцак Піщаного Молота: убито",
        ["Dunemaul Enforcer slain"] = "громило Піщаного Молота: убито",
        ["Gor'marok the Ravager slain"] = "Ґор'марок-Руйнівник: убито",
    },
    [5882] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
    },
    [5883] = {
        ["Tainted Vitriol"] = "уражений купорос",
    },
    [5884] = {
        ["Fel Creep"] = "залишок скверни",
    },
    [5885] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
    },
    [5886] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
    },
    [5887] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
    },
    [5888] = {
        ["Tainted Vitriol"] = "уражений купорос",
    },
    [5889] = {
        ["Fel Creep"] = "залишок скверни",
    },
    [5890] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
    },
    [5891] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
    },
    [5892] = {
        ["Irondeep Supplies"] = "припаси Залізодонних",
    },
    [5893] = {
        ["Coldtooth Supplies"] = "припаси Кригозубих",
    },
    [5901] = {
        ["Plagueland Termites"] = "терміти Зачумлених земель",
    },
    [5903] = {
        ["Plagueland Termites"] = "терміти Зачумлених земель",
    },
    [5981] = {
        ["Frostmaul Giant slain"] = "велетень-кригобій: убито",
        ["Frostmaul Preserver slain"] = "хранитель-кригобій: убито",
    },
    [6004] = {
        ["Scarlet Hunter slain"] = "мисливець Багряного Походу: убито",
        ["Scarlet Knight slain"] = "лицар Багряного Походу: убито",
        ["Scarlet Mage slain"] = "маг Багряного Походу: убито",
        ["Scarlet Medic slain"] = "медик Багряного Походу: убито",
    },
    [6021] = {
        ["Zaeldarr's Head"] = "голова Зельдарра",
    },
    [6022] = {
        ["Coagulated Rot"] = "згущена гниль",
    },
    [6023] = {
        ["Cavalier Durgen slain"] = "кавалерист Дарґен: убито",
        ["Huntsman Radley slain"] = "мисливиця Радлі: убито",
    },
    [6024] = {
        ["Hameya's Key"] = "ключ Гамеї",
    },
    [6026] = {
        ["Golden Rod"] = "золотий жезл",
        ["Hi-Explosive Bomb"] = "фугасна бомба",
        ["Thorium Bar"] = "злиток торію",
        ["Unstable Trigger"] = "нестабільний пусковий пристрій",
    },
    [6027] = {
        ["Book of the Ancients"] = "книга Древніх",
    },
    [6031] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [6032] = {
        ["Mooncloth"] = "місячне полотно",
    },
    [6042] = {
        ["Monstrous Plaguebat slain"] = "жахливий чумний кажан: убито",
        ["Noxious Plaguebat slain"] = "згубний чумний кажан: убито",
    },
    [6122] = {
        ["Filled Cliffspring Falls Sampler"] = "наповнений флакон Скельноджерельних водоспадів",
    },
    [6123] = {
        ["Earthroot"] = "землекорінь",
        ["Lunar Fungus"] = "місячний гриб",
    },
    [6127] = {
        ["Filled Dreadmist Peak Sampler"] = "наповнений флакон вершини Зловісного Туману",
    },
    [6128] = {
        ["Earthroot"] = "землекорінь",
        ["Kodo Horn"] = "ріг кодо",
    },
    [6133] = {
        ["Pathstrider slain"] = "розвідниця: убито",
        ["Quel'Thalas Registry"] = "реєстр Квел'Таласа",
        ["Ranger slain"] = "слідопит: убито",
        ["Woodsman slain"] = "лісник: убито",
    },
    [6134] = {
        ["Ghost-o-plasm"] = "ектоплазма",
    },
    [6135] = {
        ["Patch of Duskwing's Fur"] = "жмут хутра Смеркокрила",
    },
    [6136] = {
        ["Borelgore slain"] = "Гидкослиз: убито",
    },
    [6142] = {
        ["Soft-shelled Clam Meat"] = "м'ясо м'якопанцирного молюска",
    },
    [6143] = {
        ["Slitherblade Myrmidon slain"] = "слизькорізий мірмідон: убито",
        ["Slitherblade Naga slain"] = "слизькоріза нага: убито",
        ["Slitherblade Sorceress slain"] = "слизькоріза чаклунка: убито",
    },
    [6145] = {
        ["The Grand Crusader's Command"] = "наказ верховного лицаря",
    },
    [6146] = {
        ["The Grand Crusader's Command"] = "наказ верховного лицаря",
    },
    [6148] = {
        ["Demetria slain"] = "Деметрія: убито",
    },
    [6161] = {
        ["Rackmore's Golden Key"] = "золотий ключ Ракмора",
        ["Rackmore's Silver Key"] = "срібний ключ Ракмора",
    },
    [6162] = {
        ["Overlord Ror's Claw"] = "кіготь властителя Рора",
    },
    [6163] = {
        ["Head of Ramstein the Gorger"] = "голова Рамштайна-Ненажери",
    },
    [6164] = {
        ["Augustus' Receipt Book"] = "чекова книжка Августа",
    },
    [6185] = {
        ["SI:7 Insignia (Fredo)"] = "жетон ШУР (Фредо)",
        ["SI:7 Insignia (Rutger)"] = "жетон ШУР (Рутґер)",
        ["SI:7 Insignia (Turyen)"] = "жетон ШУР (Тур'єн)",
    },
    [6282] = {
        ["Bloodfury Ambusher slain"] = "криваволюта душителька: убито",
        ["Bloodfury Harpy slain"] = "криваволюта гарпія: убито",
        ["Bloodfury Roguefeather slain"] = "криваволюта оперена пройдисвітка: убито",
        ["Bloodfury Slayer slain"] = "криваволюта вбивця: убито",
    },
    [6283] = {
        ["Bloodfury Ripper's Remains"] = "рештки криваволютої різниці",
    },
    [6284] = {
        ["Besseleth's Fang"] = "ікло Бесселет",
    },
    [6301] = {
        ["Gaea Seed"] = "насіння Ґеї",
    },
    [6393] = {
        ["Incendrites"] = "спалахтит",
    },
    [6394] = {
        ["Thazz'ril's Pick"] = "кайло Тазз'ріла",
    },
    [6421] = {
        ["Resonite Crystal"] = "кристал резоніту",
    },
    [6441] = {
        ["Satyr Horns"] = "роги сатира",
    },
    [6442] = {
        ["Wrathtail Head"] = "голова гнівохвостої наги",
    },
    [6461] = {
        ["Deepmoss Creeper slain"] = "густомоховий підкрадач: убито",
        ["Deepmoss Venomspitter slain"] = "густомоховий ядоплюй: убито",
    },
    [6462] = {
        ["Troll Charm"] = "трольський оберіг",
    },
    [6481] = {
        ["Goggeroc slain"] = "Ґоґґерок: убито",
    },
    [6502] = {
        ["Blood of the Black Dragon Champion"] = "кров чемпіона чорних драконів",
    },
    [6503] = {
        ["Ashenvale Outrunner slain"] = "вісниця Ясенедолу: убито",
    },
    [6504] = {
        ["Shredder Operating Manual - Chapter 1"] = "інструкція з експлуатації подрібнювача — розділ 1",
        ["Shredder Operating Manual - Chapter 2"] = "інструкція з експлуатації подрібнювача — розділ 2",
        ["Shredder Operating Manual - Chapter 3"] = "інструкція з експлуатації подрібнювача — розділ 3",
    },
    [6521] = {
        ["Ambassador Malcin's Head"] = "голова посла Малкіна",
    },
    [6543] = {
        ["Warsong Outrider Update"] = "звіт вершниці Пісні Війни",
        ["Warsong Runner Update"] = "звіт гінця Пісні Війни",
        ["Warsong Scout Update"] = "звіт розвідниці Пісні Війни",
    },
    [6545] = {
        ["Warsong Report"] = "наказ Пісні Війни",
    },
    [6546] = {
        ["Warsong Report"] = "наказ Пісні Війни",
    },
    [6547] = {
        ["Warsong Report"] = "наказ Пісні Війни",
    },
    [6548] = {
        ["Grimtotem Mercenary slain"] = "найманець Зловісного Тотема: убито",
        ["Grimtotem Ruffian slain"] = "розбійник Зловісного Тотема: убито",
    },
    [6561] = {
        ["Head of Kelris"] = "голова Келріса",
    },
    [6563] = {
        ["Sapphire of Aku'Mai"] = "сапфір Аку'Май",
    },
    [6565] = {
        ["Lorgus Jett slain"] = "Лорґус Джетт: убито",
    },
    [6569] = {
        ["Black Dragonspawn Eye"] = "око чорного драконіда",
    },
    [6571] = {
        ["Logging Rope"] = "лісозаготівельна мотузка",
        ["Warsong Axe Shipment"] = "вантаж сокир Пісні Війни",
        ["Warsong Oil"] = "мастило Пісні Війни",
        ["Warsong Saw Blades"] = "пиляльні леза Пісні Війни",
    },
    [6581] = {
        ["Deadly Blunderbuss"] = "смертоносний мушкетон",
    },
    [6582] = {
        ["The Skull of Scryer"] = "череп Провидця",
    },
    [6583] = {
        ["The Skull of Somnus"] = "череп Сомнуса",
    },
    [6584] = {
        ["The Skull of Chronalis"] = "череп Хроналіса",
    },
    [6585] = {
        ["The Skull of Axtroz"] = "череп Акстроза",
    },
    [6602] = {
        ["Blood of the Black Dragon Champion"] = "кров чемпіона чорних драконів",
    },
    [6607] = {
        ["Feralas Ahi"] = "фераласька ахі",
        ["Misty Reed Mahi Mahi"] = "махі-махі Туманного Очерету",
        ["Sar'theris Striker"] = "сар'теріський мілинник",
        ["Savage Coast Blue Sailfin"] = "синій вітрильник Дикого узбережжя",
    },
    [6610] = {
        ["Alterac Swiss"] = "альтерацький сир",
        ["Giant Egg"] = "гігантське яйце",
        ["Zesty Clam Meat"] = "пікантне м'ясо молюска",
    },
    [6621] = {
        ["Murgut's Totem"] = "тотем Мурґута",
    },
    [6626] = {
        ["Death's Head Cultist slain"] = "мертвоголова культистка: убито",
        ["Razorfen Battleguard slain"] = "бривоболотий боєстраж: убито",
        ["Razorfen Thornweaver slain"] = "бривоболотий терноткач: убито",
    },
    [6629] = {
        ["Grimtotem Brute slain"] = "моцак Зловісного Тотема: убито",
        ["Grundig Darkcloud slain"] = "Ґрандіґ Темна Хмара: убито",
    },
    [6642] = {
        ["Dark Iron Ore"] = "руда темного заліза",
    },
    [6643] = {
        ["Fiery Core"] = "вогняне ядро",
    },
    [6644] = {
        ["Lava Core"] = "лавове ядро",
    },
    [6645] = {
        ["Core Leather"] = "шкіра ядра",
    },
    [6646] = {
        ["Blood of the Mountain"] = "кров гори",
    },
    [6701] = {
        ["Syndicate Emblem"] = "емблема Синдикату",
    },
    [6741] = {
        ["Armor Scraps"] = "уламки броні",
    },
    [6781] = {
        ["Armor Scraps"] = "уламки броні",
    },
    [6801] = {
        ["Stormpike Soldier's Blood"] = "кров солдата Бурешпиля",
    },
    [6804] = {
        ["Discordant Bracers"] = "браслет збожеволілого сплеска",
    },
    [6805] = {
        ["Desert Rumbler slain"] = "пустельний гуркотун: убито",
        ["Dust Stormer slain"] = "пустельний буревісник: убито",
    },
    [6821] = {
        ["Eye of the Emberseer"] = "око Вуглегляда",
    },
    [6822] = {
        ["Ancient Core Hound slain"] = "древній гончак ядра: убито",
        ["Firelord slain"] = "лорд вогню: убито",
        ["Lava Surger slain"] = "лавовий сплеск: убито",
        ["Molten Giant slain"] = "розплавлений велетень: убито",
    },
    [6824] = {
        ["Hand of Gehennas"] = "рука Геєнаса",
        ["Hand of Lucifron"] = "рука Люцифрона",
        ["Hand of Shazzrah"] = "рука Шаззраха",
        ["Hand of Sulfuron"] = "рука Сульфурона",
    },
    [6825] = {
        ["Stormpike Soldier's Flesh"] = "плоть солдата Бурешпиля",
    },
    [6826] = {
        ["Stormpike Lieutenant's Flesh"] = "плоть лейтенанта Бурешпиля",
    },
    [6827] = {
        ["Stormpike Commander's Flesh"] = "плоть командира Бурешпиля",
    },
    [6846] = {
        ["Stormpike Assault Orders"] = "наказ Бурешпиля про атаку",
    },
    [6861] = {
        ["Iron Bar"] = "злиток заліза",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Steamsaw"] = "парова пилка",
        ["Thorium Bar"] = "злиток торію",
    },
    [6862] = {
        ["Iron Bar"] = "злиток заліза",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Steamsaw"] = "парова пилка",
        ["Thorium Bar"] = "злиток торію",
    },
    [6881] = {
        ["Storm Crystal"] = "кристал шторму",
    },
    [6901] = {
        ["Frostwolf Assault Orders"] = "наказ Морозних Вовків про атаку",
    },
    [6921] = {
        ["Fathom Core"] = "ядро глибин",
    },
    [6941] = {
        ["Frostwolf Lieutenant's Medal"] = "медаль лейтенанта Морозних Вовків",
    },
    [6942] = {
        ["Frostwolf Soldier's Medal"] = "медаль солдата Морозних Вовків",
    },
    [6943] = {
        ["Frostwolf Commander's Medal"] = "медаль командира Морозних Вовків",
    },
    [6962] = {
        ["Gingerbread Cookie"] = "імбирне печиво",
        ["Ice Cold Milk"] = "крижане молоко",
    },
    [6982] = {
        ["Coldtooth Supplies"] = "припаси Кригозубих",
    },
    [6983] = {
        ["Stolen Treats"] = "викрадені ласощі",
    },
    [6985] = {
        ["Irondeep Supplies"] = "припаси Залізодонних",
    },
    [7002] = {
        ["Alterac Ram Hide"] = "шкура альтерацького барана",
    },
    [7003] = {
        ["Miniaturization Residue"] = "залишок мініатюризації",
    },
    [7025] = {
        ["Gingerbread Cookie"] = "імбирне печиво",
        ["Ice Cold Milk"] = "крижане молоко",
    },
    [7026] = {
        ["Frostwolf Hide"] = "шкура морозного вовка",
    },
    [7028] = {
        ["Theradric Crystal Carving"] = "терадричний кришталевий орнамент",
    },
    [7029] = {
        ["Filled Cerulean Vial"] = "наповнений лазуровий флакон",
    },
    [7041] = {
        ["Filled Cerulean Vial"] = "наповнений лазуровий флакон",
    },
    [7043] = {
        ["Stolen Treats"] = "викрадені ласощі",
    },
    [7044] = {
        ["Celebrian Diamond"] = "діамант Келебраса",
        ["Celebrian Rod"] = "жезл Келебраса",
    },
    [7067] = {
        ["Amulet of Union"] = "амулет Єднання",
    },
    [7068] = {
        ["Shadowshard Fragment"] = "фрагмент тінекаменю",
    },
    [7070] = {
        ["Shadowshard Fragment"] = "фрагмент тінекаменю",
    },
    [7161] = {
        ["Frostwolf Banner"] = "знамено Морозних Вовків",
    },
    [7162] = {
        ["Stormpike Banner"] = "знамено Бурешпилів",
    },
    [7163] = {
        ["Frostwolf Insignia Rank 1"] = "відзнака Морозних Вовків, ранг 1",
    },
    [7164] = {
        ["Frostwolf Insignia Rank 2"] = "відзнака Морозних Вовків, ранг 2",
    },
    [7165] = {
        ["Frostwolf Insignia Rank 3"] = "відзнака Морозних Вовків, ранг 3",
    },
    [7166] = {
        ["Frostwolf Insignia Rank 4"] = "відзнака Морозних Вовків, ранг 4",
    },
    [7167] = {
        ["Frostwolf Insignia Rank 5"] = "відзнака Морозних Вовків, ранг 5",
    },
    [7168] = {
        ["Stormpike Insignia Rank 1"] = "відзнака Бурешпилів, ранг 1",
    },
    [7169] = {
        ["Stormpike Insignia Rank 2"] = "відзнака Бурешпилів, ранг 2",
    },
    [7170] = {
        ["Stormpike Insignia Rank 3"] = "відзнака Бурешпилів, ранг 3",
    },
    [7171] = {
        ["Stormpike Insignia Rank 4"] = "відзнака Бурешпилів, ранг 4",
    },
    [7172] = {
        ["Stormpike Insignia Rank 5"] = "відзнака Бурешпилів, ранг 5",
    },
    [7181] = {
        ["Korrak the Bloodrager slain"] = "Коррак Кроволютий: убито",
    },
    [7201] = {
        ["Essence of the Elements"] = "сутність стихій",
    },
    [7202] = {
        ["Korrak the Bloodrager slain"] = "Коррак Кроволютий: убито",
    },
    [7223] = {
        ["Armor Scraps"] = "уламки броні",
    },
    [7224] = {
        ["Armor Scraps"] = "уламки броні",
    },
    [7281] = {
        ["Commander Karl Philips slain"] = "командир Карл Філіпс: убито",
    },
    [7282] = {
        ["Commander Louis Philips slain"] = "командир Луї Філіпс: убито",
    },
    [7321] = {
        ["Soothing Spices"] = "духмяні спеції",
        ["Turtle Meat"] = "черепашаче м'ясо",
    },
    [7341] = {
        ["Thorium Shells"] = "торієві патрони",
    },
    [7342] = {
        ["Thorium Shells"] = "торієві патрони",
    },
    [7367] = {
        ["Frostwolf Explosives Expert slain"] = "експерт з вибухівки Морозних Вовків: убито",
    },
    [7368] = {
        ["Stormpike Explosives Expert slain"] = "експерт з вибухівки Бурешпиля: убито",
    },
    [7383] = {
        ["Filled Amethyst Phial"] = "наповнений аметистовий фіал",
    },
    [7385] = {
        ["Stormpike Soldier's Blood"] = "кров солдата Бурешпиля",
    },
    [7386] = {
        ["Storm Crystal"] = "кристал шторму",
    },
    [7429] = {
        ["Gordok Shackle Key"] = "ключ від кайданів Ґордока",
    },
    [7441] = {
        ["Book of Incantations"] = "книга замовлянь",
    },
    [7461] = {
        ["Immol'thar slain"] = "Безсмер'тер: убито",
        ["Prince Tortheldrin slain"] = "принц Тортельдрін: убито",
    },
    [7463] = {
        ["Hydrospawn Essence"] = "сутність Гідроподоби",
    },
    [7483] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Libram of Rapidity"] = "манускрипт прудкості",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
    },
    [7484] = {
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Libram of Focus"] = "манускрипт зосередження",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Skin of Shadow"] = "шкіра тіні",
    },
    [7485] = {
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Libram of Protection"] = "манускрипт захисту",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
    },
    [7488] = {
        ["Lethtendris's Web"] = "тенета Лестендріс",
    },
    [7489] = {
        ["Lethtendris's Web"] = "тенета Лестендріс",
    },
    [7509] = {
        ["Treated Ancient Blade"] = "загартований древній клинок",
    },
    [7563] = {
        ["Raging Beast's Blood"] = "кров лютого звіра",
    },
    [7581] = {
        ["Satyr Blood"] = "кров сатира",
    },
    [7582] = {
        ["Tears of the Hederine"] = "сльози Гедеріни",
    },
    [7583] = {
        ["Imprisoned Doomguard"] = "ув'язнений вартовий приречення",
    },
    [7602] = {
        ["Flawless Fel Essence (Azshara)"] = "бездоганна есенція скверни (Азшара)",
        ["Flawless Fel Essence (Dark Portal)"] = "бездоганна есенція скверни (Темний Портал)",
        ["Flawless Fel Essence (Jaedenar)"] = "бездоганна есенція скверни (Джеденар)",
    },
    [7603] = {
        ["Kroshius slain"] = "Крошій: убито",
        ["Kroshius' Infernal Core"] = "ядро Крошія",
    },
    [7604] = {
        ["Sulfuron Ingot"] = "злиток сульфурону",
    },
    [7624] = {
        ["The Traitor's Heart"] = "серце зрадника",
    },
    [7625] = {
        ["Xorothian Stardust"] = "зоротський зоряний пил",
    },
    [7626] = {
        ["Elixir of Shadow Power"] = "еліксир сили тіні",
    },
    [7627] = {
        ["Dark Iron Ore"] = "руда темного заліза",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [7628] = {
        ["Black Dragonscale"] = "луска чорного дракона",
    },
    [7630] = {
        ["Arcanite Bar"] = "злиток арканіту",
    },
    [7631] = {
        ["Xorothian Dreadsteed slain"] = "зоротський жахожеребець: убито",
    },
    [7634] = {
        ["Mature Blue Dragon Sinew"] = "сухожилля дорослого синього дракона",
    },
    [7635] = {
        ["Mature Black Dragon Sinew"] = "сухожилля дорослого чорного дракона",
    },
    [7636] = {
        ["Artorius's Head"] = "голова Арторія",
        ["Klinfran's Head"] = "голова Клінфрана",
        ["Simone's Head"] = "голова Симони",
        ["Solenor's Head"] = "голова Соленора",
    },
    [7640] = {
        ["Terrordale Spirit slain"] = "дух Страходолу: убито",
    },
    [7642] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arthas' Tears"] = "сльози Артаса",
        ["Runecloth"] = "рунічне полотно",
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
    },
    [7643] = {
        ["Manna-Enriched Horse Feed"] = "збагачений маною корм для коней",
    },
    [7645] = {
        ["Enriched Manna Biscuit"] = "збагачене маною печиво",
    },
    [7646] = {
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
    },
    [7647] = {
        ["Blessed Arcanite Barding"] = "благословенний арканітовий бард",
        ["Charger's Redeemed Soul"] = "спасенна душа коня",
    },
    [7653] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7654] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7655] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7656] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7657] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7658] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7659] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [7660] = {
        ["Horn of the Arctic Wolf"] = "ріг арктичного вовка",
    },
    [7661] = {
        ["Horn of the Red Wolf"] = "ріг рудого вовка",
    },
    [7662] = {
        ["Teal Kodo"] = "бірюзовий кодо",
    },
    [7663] = {
        ["Green Kodo"] = "зелений кодо",
    },
    [7664] = {
        ["Whistle of the Ivory Raptor"] = "свисток кремового раптора",
    },
    [7665] = {
        ["Whistle of the Mottled Red Raptor"] = "свисток строкатого червоного раптора",
    },
    [7667] = {
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
    },
    [7671] = {
        ["Reins of the Frostsaber"] = "поводи кригозуба",
    },
    [7672] = {
        ["Reins of the Nightsaber"] = "поводи ночезуба",
    },
    [7673] = {
        ["Frost Ram"] = "морозний баран",
    },
    [7674] = {
        ["Black Ram"] = "чорний баран",
    },
    [7675] = {
        ["Icy Blue Mechanostrider Mod A"] = "крижано-блакитний механобіг, модель А",
    },
    [7676] = {
        ["White Mechanostrider Mod A"] = "білий механобіг, модель А",
    },
    [7677] = {
        ["White Stallion Bridle"] = "вузда білого жеребця",
    },
    [7678] = {
        ["Palomino Bridle"] = "вузда солового коня",
    },
    [7701] = {
        ["Head of Overseer Maltorius"] = "голова розпорядника Мальторія",
    },
    [7703] = {
        ["Gauntlet of Gordok Might"] = "рукавичка могутності Ґордока",
    },
    [7721] = {
        ["Water Elemental Core"] = "ядро водяного елементаля",
    },
    [7722] = {
        ["Secret Plans: Fiery Flux"] = "секретний рецепт: вогненний флюс",
    },
    [7723] = {
        ["Heavy War Golem slain"] = "важкий бойовий голем: убито",
    },
    [7724] = {
        ["Greater Lava Spider slain"] = "великий лавовий павук: убито",
    },
    [7725] = {
        ["Miniaturization Residue"] = "залишок мініатюризації",
    },
    [7726] = {
        ["Water Elemental Core"] = "ядро водяного елементаля",
    },
    [7727] = {
        ["Incendosaur slain"] = "вогнезавр: убито",
    },
    [7728] = {
        ["Lookout's Spyglass"] = "підзорна труба спостерігача",
        ["Smithing Tuyere"] = "ковальська фурма",
    },
    [7729] = {
        ["Dark Iron Slaver slain"] = "поневолювач Темного Заліза: убито",
        ["Dark Iron Taskmaster slain"] = "орудар Темного Заліза: убито",
    },
    [7730] = {
        ["Zukk'ash Carapace"] = "панцир Зукк'аш",
    },
    [7731] = {
        ["Stinglasher's Glands"] = "залоза Жалохвоста",
    },
    [7733] = {
        ["Rage Scar Yeti Hide"] = "шкура лютошрамного єті",
    },
    [7734] = {
        ["Rage Scar Yeti Hide"] = "шкура лютошрамного єті",
    },
    [7736] = {
        ["Coal"] = "вугілля",
        ["Incendosaur Scale"] = "луска вогнезавра",
        ["Kingsblood"] = "королекров",
    },
    [7737] = {
        ["Dark Iron Residue"] = "ожарина темного заліза",
    },
    [7786] = {
        ["Bindings of the Windseeker"] = "кайдани Шукача Вітру",
        ["Elementium Bar"] = "злиток елементію",
        ["Essence of the Firelord"] = "сутність Володара Вогню",
    },
    [7788] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7789] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7791] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7792] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7793] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7794] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7795] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7796] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7798] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7799] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7800] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7801] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7802] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7803] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7804] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7805] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7806] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7807] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7808] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7809] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7811] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7812] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7813] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7814] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7815] = {
        ["Saltwater Snapjaw slain"] = "морський тріскощелеп: убито",
    },
    [7816] = {
        ["Katoom's Best Lure"] = "найкраща приманка Катума",
    },
    [7817] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7818] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7819] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7820] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7821] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7822] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7823] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7824] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7825] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7826] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7827] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7828] = {
        ["Silvermane Howler slain"] = "срібногривий ревун: убито",
        ["Silvermane Stalker slain"] = "срібногривий ловець: убито",
    },
    [7829] = {
        ["Savage Owlbeast slain"] = "дикий совозвір: убито",
    },
    [7830] = {
        ["Skylord Plume"] = "перо володаря неба",
    },
    [7831] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7832] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7833] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [7834] = {
        ["Silk Cloth"] = "шовкове полотно",
    },
    [7835] = {
        ["Mageweave Cloth"] = "маготкане полотно",
    },
    [7836] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7837] = {
        ["Runecloth"] = "рунічне полотно",
    },
    [7838] = {
        ["Arena Master"] = "знак майстра арени",
    },
    [7839] = {
        ["Slagtree's Lost Tools"] = "загублені інструменти Вуглепала",
    },
    [7840] = {
        ["Lard's Lunch"] = "обід Ларда",
    },
    [7841] = {
        ["Highvale Marksman slain"] = "високодільний стрілець: убито",
        ["Highvale Outrunner slain"] = "високодільний вістовий: убито",
        ["Highvale Ranger slain"] = "високодільний слідопит: убито",
        ["Highvale Scout slain"] = "високодільний розвідник: убито",
    },
    [7842] = {
        ["Long Elegant Feather"] = "довге елегантне перо",
    },
    [7844] = {
        ["Vilebranch Scalper slain"] = "скальпоріз Миршавого Гілля: убито",
        ["Vilebranch Soothsayer slain"] = "віщун Миршавого Гілля: убито",
    },
    [7846] = {
        ["Shackle Key"] = "ключ від кайданів",
    },
    [7848] = {
        ["Core Fragment"] = "фрагмент ядра",
    },
    [7849] = {
        ["Huntsman Malkhor's Bones"] = "кістки мисливця Малкгора",
        ["Huntsman Malkhor's Skull"] = "череп мисливця Малкгора",
    },
    [7850] = {
        ["Vessel of Tainted Blood"] = "посудина із забрудненою кров'ю",
    },
    [7861] = {
        ["Vile Priestess Hexx slain"] = "підступна жриця Гекс: убито",
        ["Vilebranch Aman'zasi Guard slain"] = "вартовий-аман'сазі Миршавого Гілля: убито",
    },
    [7862] = {
        ["Vilebranch Berserker slain"] = "берсерк Миршавого Гілля: убито",
        ["Vilebranch Blood Drinker slain"] = "кровопивця Миршавого Гілля: убито",
        ["Vilebranch Shadow Hunter slain"] = "темний мисливець Миршавого Гілля: убито",
        ["Vilebranch Soul Eater slain"] = "пожирач душ Миршавого Гілля: убито",
    },
    [7871] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7872] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7873] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7874] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7875] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7876] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [7881] = {
        ["Embossed Leather Boots"] = "тиснені шкіряні чоботи",
    },
    [7882] = {
        ["Toughened Leather Armor"] = "укріплений шкіряний обладунок",
    },
    [7883] = {
        ["Barbaric Harness"] = "варварська портупея",
    },
    [7884] = {
        ["Turtle Scale Leggings"] = "поножі з черепашачої луски",
    },
    [7885] = {
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
    },
    [7889] = {
        ["Coarse Weightstone"] = "шорстке грузило",
    },
    [7890] = {
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
    },
    [7891] = {
        ["Green Iron Bracers"] = "зелені залізні браслети",
    },
    [7892] = {
        ["Big Black Mace"] = "велика чорна булава",
    },
    [7893] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
    },
    [7894] = {
        ["Copper Modulator"] = "мідний модулятор",
    },
    [7895] = {
        ["Whirring Bronze Gizmo"] = "бронзова тріщалка",
    },
    [7896] = {
        ["Green Firework"] = "зелений феєрверк",
    },
    [7897] = {
        ["Mechanical Repair Kit"] = "механічний ремкомплект",
    },
    [7898] = {
        ["Thorium Widget"] = "торієвий пристрій",
    },
    [7899] = {
        ["Small Furry Paw"] = "маленька пухнаста лапка",
    },
    [7900] = {
        ["Torn Bear Pelt"] = "рвана ведмежа шкура",
    },
    [7901] = {
        ["Soft Bushy Tail"] = "м'який пухнастий хвіст",
    },
    [7902] = {
        ["Vibrant Plume"] = "яскраве перо",
    },
    [7903] = {
        ["Evil Bat Eye"] = "око злого кажана",
    },
    [7907] = {
        ["Beasts Deck"] = "колода звірів",
    },
    [7927] = {
        ["Portals Deck"] = "колода порталів",
    },
    [7928] = {
        ["Warlords Deck"] = "колода воєвод",
    },
    [7929] = {
        ["Elementals Deck"] = "колода елементалів",
    },
    [7930] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7931] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7932] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7933] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7934] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7935] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7936] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7939] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
    },
    [7940] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [7941] = {
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
    },
    [7942] = {
        ["Thorium Widget"] = "торієвий пристрій",
    },
    [7943] = {
        ["Evil Bat Eye"] = "око злого кажана",
    },
    [7946] = {
        ["Dark Iron Ale Mug"] = "кухоль елю Темного Заліза",
    },
    [7981] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
    },
    [8042] = {
        ["Strength of Mugamba"] = "сила Муґамби",
    },
    [8043] = {
        ["Strength of Mugamba"] = "сила Муґамби",
    },
    [8044] = {
        ["Strength of Mugamba"] = "сила Муґамби",
    },
    [8046] = {
        ["Heathen's Brand"] = "тавро язичника",
    },
    [8047] = {
        ["Heathen's Brand"] = "тавро язичника",
    },
    [8048] = {
        ["Heathen's Brand"] = "тавро язичника",
    },
    [8050] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
    },
    [8051] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
    },
    [8052] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
    },
    [8053] = {
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
    },
    [8054] = {
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
    },
    [8055] = {
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
    },
    [8056] = {
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
    },
    [8057] = {
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
    },
    [8058] = {
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
    },
    [8059] = {
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
    },
    [8060] = {
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
    },
    [8061] = {
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
    },
    [8062] = {
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
    },
    [8063] = {
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
    },
    [8064] = {
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
    },
    [8065] = {
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
    },
    [8066] = {
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
    },
    [8067] = {
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
    },
    [8068] = {
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
    },
    [8069] = {
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
    },
    [8070] = {
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
    },
    [8071] = {
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
    },
    [8072] = {
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
    },
    [8073] = {
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
    },
    [8074] = {
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
    },
    [8075] = {
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
    },
    [8076] = {
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
    },
    [8077] = {
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
    },
    [8078] = {
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
    },
    [8079] = {
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
    },
    [8080] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8102] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
    },
    [8103] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
    },
    [8104] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
    },
    [8107] = {
        ["Kezan's Taint"] = "пошесть Кезана",
    },
    [8108] = {
        ["Kezan's Taint"] = "пошесть Кезана",
    },
    [8109] = {
        ["Kezan's Taint"] = "пошесть Кезана",
    },
    [8111] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
    },
    [8112] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
    },
    [8113] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
    },
    [8117] = {
        ["Vision of Voodress"] = "видіння Вудрії",
    },
    [8118] = {
        ["Vision of Voodress"] = "видіння Вудрії",
    },
    [8119] = {
        ["Vision of Voodress"] = "видіння Вудрії",
    },
    [8123] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8142] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
    },
    [8143] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
    },
    [8144] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
    },
    [8146] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
    },
    [8147] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
    },
    [8148] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
    },
    [8153] = {
        ["Perfect Courser Antler"] = "ідеальні роги самця оленя",
    },
    [8154] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8155] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8156] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8160] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8161] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8162] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8184] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8185] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8186] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8187] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8188] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8189] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8190] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8191] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8192] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
    },
    [8193] = {
        ["Speckled Tastyfish"] = "плямиста смачнориба",
    },
    [8194] = {
        ["Speckled Tastyfish"] = "плямиста смачнориба",
    },
    [8195] = {
        ["Hakkari Coin"] = "монета Гаккарі",
        ["Razzashi Coin"] = "монета Раззаші",
        ["Zulian Coin"] = "монета Зуліан",
    },
    [8196] = {
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
    },
    [8201] = {
        ["Gurubashi Head Collection"] = "колекція голів Ґурубаші",
    },
    [8221] = {
        ["Keefer's Angelfish"] = "риба-ангел Кіфера",
    },
    [8222] = {
        ["Glowing Scorpid Blood"] = "сяюча кров скорпіда",
    },
    [8223] = {
        ["Glowing Scorpid Blood"] = "сяюча кров скорпіда",
    },
    [8224] = {
        ["Dezian Queenfish"] = "дезійська ставрида",
    },
    [8225] = {
        ["Brownell's Blue Striped Racer"] = "синій смугастик Браунелла",
    },
    [8231] = {
        ["Wavethrasher Scales"] = "луска хвилешльопа",
    },
    [8232] = {
        ["Tooth of Morphaz"] = "зуб Морфаза",
    },
    [8234] = {
        ["Sealed Azure Bag"] = "запечатана лазурна сумка",
    },
    [8235] = {
        ["Encoded Fragment"] = "зашифрований фрагмент",
    },
    [8236] = {
        ["Azure Key"] = "лазурний ключ",
    },
    [8238] = {
        ["Gurubashi Coin"] = "монета Ґурубаші",
        ["Vilebranch Coin"] = "монета Миршавого Гілля",
        ["Witherbark Coin"] = "монета Зів'ялої Кори",
    },
    [8239] = {
        ["Bloodscalp Coin"] = "монета Кровоскальпих",
        ["Sandfury Coin"] = "монета Піщанолютих",
        ["Skullsplitter Coin"] = "монета Черепотрощителів",
    },
    [8241] = {
        ["Coal"] = "вугілля",
        ["Incendosaur Scale"] = "луска вогнезавра",
        ["Iron Bar"] = "злиток заліза",
    },
    [8242] = {
        ["Coal"] = "вугілля",
        ["Heavy Leather"] = "важка шкіра",
        ["Incendosaur Scale"] = "луска вогнезавра",
    },
    [8243] = {
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
    },
    [8246] = {
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
    },
    [8249] = {
        ["Heavy Junkbox"] = "важка скринька",
    },
    [8251] = {
        ["Glittering Dust"] = "блискучий пил",
    },
    [8252] = {
        ["Enchanted Coral"] = "зачарований корал",
    },
    [8253] = {
        ["Arcane Shard"] = "арканічний уламок",
    },
    [8255] = {
        ["Healthy Courser Gland"] = "залоза здорового оленя",
    },
    [8256] = {
        ["Ichor of Undeath"] = "пасока невмерлих",
    },
    [8257] = {
        ["Blood of Morphaz"] = "кров Морфаза",
    },
    [8258] = {
        ["Darkreaver's Head"] = "голова Тінегубителя",
    },
    [8266] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
    },
    [8268] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
    },
    [8277] = {
        ["Sand Skitterer Fang"] = "ікло піщаного швидколапа",
        ["Stonelash Scorpid Stinger"] = "жало камнехвостого скорпіда",
    },
    [8278] = {
        ["Rock Stalker Fang"] = "ікло скельного ловця",
        ["Stonelash Flayer Stinger"] = "жало камнехвостого потрошителя",
        ["Stonelash Pincer Stinger"] = "жало камнехвостого щипача",
    },
    [8279] = {
        ["Twilight Lexicon - Chapter 1"] = "Сутінковий словник - розділ 1",
        ["Twilight Lexicon - Chapter 2"] = "Сутінковий словник - розділ 2",
        ["Twilight Lexicon - Chapter 3"] = "Сутінковий словник - розділ 3",
    },
    [8280] = {
        ["Dredge Striker slain"] = "землечерп: убито",
    },
    [8281] = {
        ["Dredge Crusher slain"] = "землечерп-дробар: убито",
    },
    [8282] = {
        ["Noggle's Satchel"] = "рюкзак Ноґґла",
    },
    [8283] = {
        ["Deathclasp's Pincer"] = "клешня Смертехвата",
    },
    [8284] = {
        ["Twilight Tablet Fragment"] = "фрагмент сутінкової скрижалі",
    },
    [8288] = {
        ["Head of the Broodlord Lashlayer"] = "голова володаря роду Хлиста Бича",
    },
    [8289] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [8290] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8291] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8294] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8295] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8296] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [8297] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8299] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8301] = {
        ["Silithid Carapace Fragment"] = "фрагмент панцира силітида",
    },
    [8302] = {
        ["Silithid Carapace Fragment"] = "фрагмент панцира силітида",
    },
    [8309] = {
        ["Hive'Ashi Rubbing"] = "відтиск кристала Вул'Аші",
        ["Hive'Regal Rubbing"] = "відтиск кристала Вул'Регаля",
        ["Hive'Zora Rubbing"] = "відтиск кристала Вул'Зори",
    },
    [8310] = {
        ["Hive'Ashi Silithid Brain"] = "мозок силітида Вул'Аші",
        ["Hive'Regal Silithid Brain"] = "мозок силітида Вул'Регаля",
        ["Hive'Zora Silithid Brain"] = "мозок силітида Вул'Зори",
    },
    [8311] = {
        ["Darnassus Marzipan"] = "марципан Дарнасу",
        ["Gnomeregan Gumdrop"] = "мармелад Гномреґана",
        ["Ironforge Mint"] = "м'ятна цукерка Залізогарта",
        ["Stormwind Nougat"] = "нуга Штормовію",
    },
    [8312] = {
        ["Darkspear Gumdrop"] = "мармелад Темного Списа",
        ["Orgrimmar Nougat"] = "нуга Орґріммара",
        ["Thunder Bluff Marzipan"] = "марципан Громового Бескиду",
        ["Undercity Mint"] = "м'ятна цукерка Підмістя",
    },
    [8315] = {
        ["Crystal Unlocking Mechanism"] = "механізм відкривання кристалів",
    },
    [8317] = {
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
    },
    [8318] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
    },
    [8319] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
    },
    [8320] = {
        ["Twilight Geolord slain"] = "сутінковий геолорд: убито",
    },
    [8321] = {
        ["Vyral's Signet Ring"] = "перстень-печатка Вірала",
    },
    [8323] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
    },
    [8324] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
    },
    [8332] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [8333] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [8341] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [8342] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [8348] = {
        ["Abyssal Signet"] = "перстень безодні",
    },
    [8352] = {
        ["Abyssal Scepter"] = "скіпетр безодні",
    },
    [8361] = {
        ["Abyssal Crest"] = "талісман безодні",
    },
    [8362] = {
        ["Abyssal Crest"] = "талісман безодні",
    },
    [8363] = {
        ["Abyssal Signet"] = "перстень безодні",
    },
    [8364] = {
        ["Abyssal Scepter"] = "скіпетр безодні",
    },
    [8365] = {
        ["Southsea Pirate Hat"] = "капелюх пірата Південних морів",
    },
    [8366] = {
        ["Southsea Dock Worker slain"] = "портовий робітник Південних морів: убито",
        ["Southsea Freebooter slain"] = "флібустьєр Південних морів: убито",
        ["Southsea Pirate slain"] = "пірат Південних морів: убито",
        ["Southsea Swashbuckler slain"] = "шибайголова Південних морів: убито",
    },
    [8367] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8368] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8369] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
    },
    [8370] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8371] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8372] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8374] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8375] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
    },
    [8383] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
    },
    [8384] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8385] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8386] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8387] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
    },
    [8388] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8389] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8390] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8391] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8392] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8393] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8394] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8395] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8396] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8397] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8398] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8399] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8400] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8401] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8402] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8403] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8404] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8405] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8406] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8407] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8408] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8410] = {
        ["Elemental Air"] = "первородне повітря",
        ["Elemental Earth"] = "первородна земля",
        ["Elemental Fire"] = "первородний вогонь",
        ["Elemental Water"] = "первородна вода",
    },
    [8411] = {
        ["Elemental Air"] = "первородне повітря",
        ["Elemental Earth"] = "первородна земля",
        ["Elemental Fire"] = "первородний вогонь",
        ["Elemental Water"] = "первородна вода",
    },
    [8412] = {
        ["Bloodshot Spider Eye"] = "налите кров'ю павуче око",
        ["Thick Black Claw"] = "товстий чорний кіготь",
    },
    [8413] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
    },
    [8414] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
    },
    [8418] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
    },
    [8419] = {
        ["Felcloth"] = "сквернотканина",
    },
    [8420] = {
        ["Felcloth"] = "сквернотканина",
    },
    [8421] = {
        ["Bloodvenom Essence"] = "кровотруйна есенція",
        ["Rotting Wood"] = "гнила деревина",
    },
    [8422] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
    },
    [8423] = {
        ["Helboar slain"] = "пеклокнур: убито",
    },
    [8424] = {
        ["Shadowsworn Adept slain"] = "адепт тінеклятів: убито",
        ["Shadowsworn Cultist slain"] = "культист тінеклятів: убито",
        ["Shadowsworn Thug slain"] = "розбіяка тінеклятів: убито",
    },
    [8425] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
    },
    [8426] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8427] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8428] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8429] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8430] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8431] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8432] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8433] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8434] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8435] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
    },
    [8436] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8437] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8438] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8439] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8440] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8441] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8442] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8443] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
    },
    [8460] = {
        ["Deadwood Gardener slain"] = "мертволісий садівник: убито",
        ["Deadwood Pathfinder slain"] = "мертволісий слідопит: убито",
        ["Deadwood Warrior slain"] = "мертволісий воїн: убито",
    },
    [8461] = {
        ["Deadwood Avenger slain"] = "мертволісий месник: убито",
        ["Deadwood Den Watcher slain"] = "мертволісий наглядач лігва: убито",
        ["Deadwood Shaman slain"] = "мертволісий шаман: убито",
    },
    [8464] = {
        ["Winterfall Den Watcher slain"] = "зимокрайовий наглядач лігва: убито",
        ["Winterfall Shaman slain"] = "зимокрайовий шаман: убито",
        ["Winterfall Ursa slain"] = "зимокрайовий урса: убито",
    },
    [8466] = {
        ["Deadwood Headdress Feather"] = "перо з головного убору Мертволісих",
    },
    [8467] = {
        ["Deadwood Headdress Feather"] = "перо з головного убору Мертволісих",
    },
    [8469] = {
        ["Winterfall Spirit Beads"] = "духовне намисто Зимокрайових",
    },
    [8481] = {
        ["Essence of Xandivious"] = "сутність Зандівія",
    },
    [8492] = {
        ["Copper Bar"] = "злиток міді",
    },
    [8493] = {
        ["Copper Bar"] = "злиток міді",
    },
    [8494] = {
        ["Iron Bar"] = "злиток заліза",
    },
    [8495] = {
        ["Iron Bar"] = "злиток заліза",
    },
    [8496] = {
        ["Heavy Mageweave Bandage"] = "щільний маготканий бинт",
        ["Heavy Runecloth Bandage"] = "щільний рунічний бинт",
        ["Heavy Silk Bandage"] = "щільний шовковий бинт",
    },
    [8497] = {
        ["Globe of Water"] = "куля води",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
    },
    [8498] = {
        ["Twilight Battle Orders"] = "бойові накази Сутінкового Молота",
    },
    [8499] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [8500] = {
        ["Thorium Bar"] = "злиток торію",
    },
    [8501] = {
        ["Hive'Ashi Stinger slain"] = "жалоносець Вул'Аші: убито",
    },
    [8502] = {
        ["Hive'Ashi Worker slain"] = "робітник Вул'Аші: убито",
    },
    [8503] = {
        ["Stranglekelp"] = "душирість",
    },
    [8504] = {
        ["Stranglekelp"] = "душирість",
    },
    [8505] = {
        ["Purple Lotus"] = "пурпуровий лотос",
    },
    [8506] = {
        ["Purple Lotus"] = "пурпуровий лотос",
    },
    [8507] = {
        ["Signed Field Duty Papers"] = "підписані документи про польову службу",
    },
    [8508] = {
        ["Prepared Field Duty Papers"] = "підготовлені документи про польову службу",
    },
    [8509] = {
        ["Arthas' Tears"] = "сльози Артаса",
    },
    [8510] = {
        ["Arthas' Tears"] = "сльози Артаса",
    },
    [8511] = {
        ["Light Leather"] = "легка шкіра",
    },
    [8512] = {
        ["Light Leather"] = "легка шкіра",
    },
    [8513] = {
        ["Medium Leather"] = "середня шкіра",
    },
    [8514] = {
        ["Medium Leather"] = "середня шкіра",
    },
    [8515] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [8516] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [8517] = {
        ["Linen Bandage"] = "лляний бинт",
    },
    [8518] = {
        ["Linen Bandage"] = "лляний бинт",
    },
    [8520] = {
        ["Silk Bandage"] = "шовковий бинт",
    },
    [8521] = {
        ["Silk Bandage"] = "шовковий бинт",
    },
    [8522] = {
        ["Runecloth Bandage"] = "рунічний бинт",
    },
    [8523] = {
        ["Runecloth Bandage"] = "рунічний бинт",
    },
    [8524] = {
        ["Rainbow Fin Albacore"] = "веселковий тунець",
    },
    [8525] = {
        ["Rainbow Fin Albacore"] = "веселковий тунець",
    },
    [8526] = {
        ["Roast Raptor"] = "смажений раптор",
    },
    [8527] = {
        ["Roast Raptor"] = "смажений раптор",
    },
    [8528] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
    },
    [8529] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
    },
    [8532] = {
        ["Copper Bar"] = "злиток міді",
    },
    [8533] = {
        ["Copper Bar"] = "злиток міді",
    },
    [8534] = {
        ["Hive'Zora Scout Report"] = "звіт розвідниці Вул'Зори",
    },
    [8535] = {
        ["Hoary Templar slain"] = "сивий храмовник: убито",
    },
    [8536] = {
        ["Earthen Templar slain"] = "земляний храмовник: убито",
    },
    [8537] = {
        ["Crimson Templar slain"] = "багряний храмовник: убито",
    },
    [8538] = {
        ["The Duke of Cynders slain"] = "герцог попелу: убито",
        ["The Duke of Fathoms slain"] = "герцог глибин: убито",
        ["The Duke of Shards slain"] = "герцог осколків: убито",
        ["The Duke of Zephyrs slain"] = "герцог вітрів: убито",
    },
    [8539] = {
        ["Hive'Zora Hive Sister slain"] = "сестра рою Вул'Зори: убито",
    },
    [8540] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
    },
    [8541] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
        ["Solid Grinding Stone"] = "твердий шліфувальний камінь",
    },
    [8542] = {
        ["Tin Bar"] = "злиток олова",
    },
    [8543] = {
        ["Tin Bar"] = "злиток олова",
    },
    [8544] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Idol of Night"] = "ідол ночі",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8545] = {
        ["Mithril Bar"] = "злиток мітрилу",
    },
    [8546] = {
        ["Mithril Bar"] = "злиток мітрилу",
    },
    [8548] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
    },
    [8549] = {
        ["Peacebloom"] = "мироквіт",
    },
    [8550] = {
        ["Peacebloom"] = "мироквіт",
    },
    [8551] = {
        ["Smotts' Chest"] = "скриня Смоттса",
    },
    [8554] = {
        ["Smotts' Cutlass"] = "шабля Смоттса",
    },
    [8556] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
    },
    [8557] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8558] = {
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8559] = {
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of War"] = "ідол війни",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
    },
    [8560] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Death"] = "ідол смерті",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
    },
    [8561] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of the Sun"] = "ідол сонця",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
    },
    [8562] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Idol of War"] = "ідол війни",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8565] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
    },
    [8566] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
    },
    [8567] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
    },
    [8568] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
    },
    [8569] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
    },
    [8570] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
    },
    [8572] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
    },
    [8573] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Mark of Cenarius"] = "знак Кенарія",
    },
    [8574] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Mark of Remulos"] = "знак Ремула",
    },
    [8578] = {
        ["Narain's Scrying Goggles"] = "окуляри провидіння Нараіна",
    },
    [8579] = {
        ["Qiraji Lord's Insignia"] = "відзнака кіразького володаря",
    },
    [8580] = {
        ["Firebloom"] = "вогнеквіт",
    },
    [8581] = {
        ["Firebloom"] = "вогнеквіт",
    },
    [8582] = {
        ["Purple Lotus"] = "пурпуровий лотос",
    },
    [8583] = {
        ["Purple Lotus"] = "пурпуровий лотос",
    },
    [8585] = {
        ["Chimaerok Tenderloin"] = "вирізка химерини",
        ["Lakmaeran's Carcass"] = "туша Лакмеран",
    },
    [8586] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
        ["Goblin Rocket Fuel"] = "гоблінське ракетне паливо",
    },
    [8588] = {
        ["Heavy Leather"] = "важка шкіра",
    },
    [8589] = {
        ["Heavy Leather"] = "важка шкіра",
    },
    [8590] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [8591] = {
        ["Thick Leather"] = "товста шкіра",
    },
    [8592] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Silver Scarab"] = "срібний скарабей",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
    },
    [8593] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Life"] = "ідол життя",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
    },
    [8594] = {
        ["Idol of Rebirth"] = "ідол відродження",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8595] = {
        ["Qiraji Lord's Insignia"] = "відзнака кіразького володаря",
    },
    [8596] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Death"] = "ідол смерті",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
    },
    [8600] = {
        ["Rugged Leather"] = "міцна шкіра",
    },
    [8601] = {
        ["Rugged Leather"] = "міцна шкіра",
    },
    [8602] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Life"] = "ідол життя",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8603] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Idol of Death"] = "ідол смерті",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8604] = {
        ["Wool Bandage"] = "вовняний бинт",
    },
    [8605] = {
        ["Wool Bandage"] = "вовняний бинт",
    },
    [8607] = {
        ["Mageweave Bandage"] = "маготканий бинт",
    },
    [8608] = {
        ["Mageweave Bandage"] = "маготканий бинт",
    },
    [8609] = {
        ["Runecloth Bandage"] = "рунічний бинт",
    },
    [8610] = {
        ["Runecloth Bandage"] = "рунічний бинт",
    },
    [8611] = {
        ["Lean Wolf Steak"] = "пісний вовчий стейк",
    },
    [8612] = {
        ["Lean Wolf Steak"] = "пісний вовчий стейк",
    },
    [8613] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
    },
    [8614] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
    },
    [8615] = {
        ["Baked Salmon"] = "запечений лосось",
    },
    [8616] = {
        ["Baked Salmon"] = "запечений лосось",
    },
    [8620] = {
        ["Draconic For Dummies: Volume II"] = "Мова драконів для початківців: Том ІІ",
    },
    [8621] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8622] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8623] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
    },
    [8624] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Strife"] = "ідол боротьби",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
    },
    [8625] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Death"] = "ідол смерті",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8626] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Idol of Life"] = "ідол життя",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8627] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8628] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
    },
    [8629] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Strife"] = "ідол боротьби",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
    },
    [8630] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Life"] = "ідол життя",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8631] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8632] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Night"] = "ідол ночі",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
    },
    [8633] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Idol of the Sun"] = "ідол сонця",
    },
    [8634] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of the Sun"] = "ідол сонця",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8637] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of Strife"] = "ідол боротьби",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
    },
    [8638] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Idol of Strife"] = "ідол боротьби",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
    },
    [8639] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of War"] = "ідол війни",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
    },
    [8640] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of Night"] = "ідол ночі",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8641] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Idol of the Sun"] = "ідол сонця",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8655] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8656] = {
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Life"] = "ідол життя",
    },
    [8657] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of Strife"] = "ідол боротьби",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
    },
    [8658] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Idol of the Sun"] = "ідол сонця",
        ["Silver Scarab"] = "срібний скарабей",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
    },
    [8659] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of War"] = "ідол війни",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
    },
    [8660] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Idol of Night"] = "ідол ночі",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8661] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Idol of Night"] = "ідол ночі",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8662] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Idol of Death"] = "ідол смерті",
        ["Silver Scarab"] = "срібний скарабей",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
    },
    [8663] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
    },
    [8664] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8665] = {
        ["Idol of Rebirth"] = "ідол відродження",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Silver Scarab"] = "срібний скарабей",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8666] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
    },
    [8667] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Life"] = "ідол життя",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
    },
    [8668] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Idol of War"] = "ідол війни",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8669] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Idol of Strife"] = "ідол боротьби",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
    },
    [8687] = {
        ["Hive'Zora Tunneler slain"] = "прохідник Вул'Зори: убито",
    },
    [8689] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
    },
    [8690] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
    },
    [8691] = {
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8692] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Silver Scarab"] = "срібний скарабей",
        ["Vermillion Idol"] = "багряний ідол",
    },
    [8693] = {
        ["Azure Idol"] = "лазуровий ідол",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
    },
    [8694] = {
        ["Amber Idol"] = "бурштиновий ідол",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
    },
    [8695] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
    },
    [8696] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8697] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8698] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Silver Scarab"] = "срібний скарабей",
        ["Vermillion Idol"] = "багряний ідол",
    },
    [8699] = {
        ["Azure Idol"] = "лазуровий ідол",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
    },
    [8700] = {
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
    },
    [8701] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8702] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8703] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Silver Scarab"] = "срібний скарабей",
        ["Vermillion Idol"] = "багряний ідол",
    },
    [8704] = {
        ["Amber Idol"] = "бурштиновий ідол",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
    },
    [8705] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
    },
    [8706] = {
        ["Amber Idol"] = "бурштиновий ідол",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
    },
    [8707] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8708] = {
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8709] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Vermillion Idol"] = "багряний ідол",
    },
    [8710] = {
        ["Clay Scarab"] = "глиняний скарабей",
        ["Gold Scarab"] = "золотий скарабей",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
    },
    [8711] = {
        ["Amber Idol"] = "бурштиновий ідол",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
    },
    [8712] = {
        ["Azure Idol"] = "лазуровий ідол",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Silver Scarab"] = "срібний скарабей",
    },
    [8728] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Blue Sapphire"] = "синій сапфір",
        ["Elementium Ore"] = "елементієва руда",
    },
    [8729] = {
        ["Blue Scepter Shard"] = "синій уламок скіпетра",
    },
    [8730] = {
        ["Red Scepter Shard"] = "червоний уламок скіпетра",
    },
    [8731] = {
        ["Signed Field Duty Papers"] = "підписані документи про польову службу",
    },
    [8732] = {
        ["Prepared Field Duty Papers"] = "підготовлені документи про польову службу",
    },
    [8735] = {
        ["Fragment of the Nightmare's Corruption"] = "фрагмент зараження Жаху",
    },
    [8737] = {
        ["Azure Templar slain"] = "лазурний храмовник: убито",
    },
    [8738] = {
        ["Hive'Regal Scout Report"] = "звіт розвідника Вул'Регаля",
    },
    [8739] = {
        ["Hive'Ashi Scout Report"] = "звіт розвідниці Вул'Аші",
    },
    [8740] = {
        ["Twilight Marauder Morna slain"] = "сутінковий мародер Морна: убито",
        ["Twilight Marauder slain"] = "сутінковий мародер: убито",
    },
    [8743] = {
        ["The Scepter of the Shifting Sands"] = "скіпетр Мінливих Пісків",
    },
    [8746] = {
        ["Pouch of Reindeer Dust"] = "мішечок з оленячим пилом",
    },
    [8748] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8749] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8750] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8751] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8753] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8754] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8755] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8756] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8758] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8759] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8760] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8761] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8762] = {
        ["Pouch of Reindeer Dust"] = "мішечок з оленячим пилом",
    },
    [8763] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
    },
    [8764] = {
        ["Gold Scarab"] = "золотий скарабей",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Silver Scarab"] = "срібний скарабей",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8765] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
    },
    [8766] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Stone Scarab"] = "кам'яний скарабей",
    },
    [8770] = {
        ["Hive'Ashi Defender slain"] = "захисник Вул'Аші: убито",
    },
    [8771] = {
        ["Hive'Ashi Sandstalker slain"] = "піщаний ловець Вул'Аші: убито",
    },
    [8772] = {
        ["Hive'Zora Waywatcher slain"] = "шляхостраж Вул'Зори: убито",
    },
    [8773] = {
        ["Hive'Zora Reaver slain"] = "розоритель Вул'Зори: убито",
    },
    [8774] = {
        ["Hive'Regal Ambusher slain"] = "душитель Вул'Регаля: убито",
    },
    [8775] = {
        ["Hive'Regal Spitfire slain"] = "вогнеплюй Вул'Регаля: убито",
    },
    [8776] = {
        ["Hive'Regal Slavemaker slain"] = "поневолювач Вул'Регаля: убито",
    },
    [8777] = {
        ["Hive'Regal Burrower slain"] = "землерий Вул'Регаля: убито",
    },
    [8778] = {
        ["Dense Blasting Powder"] = "масивний вибуховий порошок",
        ["Goblin Rocket Fuel"] = "гоблінське ракетне паливо",
        ["Oil of Immolation"] = "олія жертвоприношення",
    },
    [8779] = {
        ["Huge Emerald"] = "величезний смарагд",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Radiant Shard"] = "великий променистий осколок",
    },
    [8780] = {
        ["Heavy Armor Kit"] = "накладки з важкої шкіри",
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
    },
    [8781] = {
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
    },
    [8782] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Mooncloth"] = "місячне полотно",
    },
    [8783] = {
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
    },
    [8785] = {
        ["Flask of Big Mojo"] = "фляга великого моджо",
        ["Oil of Immolation"] = "олія жертвоприношення",
        ["Powerful Mojo"] = "потужне моджо",
    },
    [8786] = {
        ["Massive Iron Axe"] = "масивна залізна сокира",
    },
    [8787] = {
        ["Heavy Armor Kit"] = "накладки з важкої шкіри",
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
    },
    [8789] = {
        ["Elementium Ore"] = "елементієва руда",
        ["Imperial Qiraji Armaments"] = "кіразька імператорська зброя",
    },
    [8790] = {
        ["Elementium Ore"] = "елементієва руда",
        ["Imperial Qiraji Regalia"] = "кіразькі імператорські регалії",
    },
    [8799] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
    },
    [8804] = {
        ["Globe of Water"] = "куля води",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
    },
    [8805] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
    },
    [8806] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
        ["Solid Grinding Stone"] = "твердий шліфувальний камінь",
    },
    [8807] = {
        ["Huge Emerald"] = "величезний смарагд",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Radiant Shard"] = "великий променистий осколок",
    },
    [8808] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Mooncloth"] = "місячне полотно",
    },
    [8809] = {
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
    },
    [8810] = {
        ["Heavy Mageweave Bandage"] = "щільний маготканий бинт",
        ["Heavy Runecloth Bandage"] = "щільний рунічний бинт",
        ["Heavy Silk Bandage"] = "щільний шовковий бинт",
    },
    [8811] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8812] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8813] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8814] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8815] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8816] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8817] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8818] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8819] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8820] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8821] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8822] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8823] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8824] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8825] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8826] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8829] = {
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Skin of Shadow"] = "шкіра тіні",
        ["Twilight Cultist Robe"] = "сутінкова мантія культиста",
    },
    [8830] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8831] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8832] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8833] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8834] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8835] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8836] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8837] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8838] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8839] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8840] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8841] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8842] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8843] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8844] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8845] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8846] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8847] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8848] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8849] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8850] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
    },
    [8851] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8852] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8853] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8854] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8855] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
    },
    [8856] = {
        ["Globe of Water"] = "куля води",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
    },
    [8862] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8863] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8864] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8865] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8869] = {
        ["Crimson Hammersmith's Apron"] = "фартух багряного коваля молотів",
    },
    [8876] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8877] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8878] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8879] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8880] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8881] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8882] = {
        ["Coin of Ancestry"] = "монета предків",
    },
    [8893] = {
        ["Hippogryph Egg"] = "яйце гіпогрифа",
    },
    [8903] = {
        ["Stormwind Guard's Card"] = "листівка вартового Штормовію",
    },
    [8904] = {
        ["Guardian's Moldy Card"] = "запліснявіла листівка вартового",
    },
    [8905] = {
        ["Wildheart Bracers"] = "браслети дикого серця",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8906] = {
        ["Beaststalker's Bindings"] = "браслети ловця звірів",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8907] = {
        ["Magister's Bindings"] = "браслети магістра",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8908] = {
        ["Lightforge Bracers"] = "світлоковані браслети",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8909] = {
        ["Devout Bracers"] = "браслети відданості",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8910] = {
        ["Shadowcraft Bracers"] = "браслети тіньового ремесла",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8911] = {
        ["Dreadmist Bracers"] = "браслети імли жаху",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8912] = {
        ["Bracers of Valor"] = "браслети доблесті",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
    },
    [8913] = {
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Wildheart Bracers"] = "браслети дикого серця",
    },
    [8914] = {
        ["Beaststalker's Bindings"] = "браслети ловця звірів",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8915] = {
        ["Magister's Bindings"] = "браслети магістра",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8916] = {
        ["Devout Bracers"] = "браслети відданості",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8917] = {
        ["Shadowcraft Bracers"] = "браслети тіньового ремесла",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8918] = {
        ["Bindings of Elements"] = "браслети стихій",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8919] = {
        ["Dreadmist Bracers"] = "браслети імли жаху",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8920] = {
        ["Bracers of Valor"] = "браслети доблесті",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
    },
    [8921] = {
        ["Delicate Arcanite Converter"] = "чутливий арканітовий перетворювач",
        ["Greater Eternal Essence"] = "велика вічна субстанція",
        ["Stonescale Oil"] = "олія камнелуского вугра",
        ["Volcanic Ash"] = "вулканічний попіл",
    },
    [8924] = {
        ["Frozen Ectoplasm"] = "заморожена ектоплазма",
        ["Scorched Ectoplasm"] = "обпалена ектоплазма",
        ["Stable Ectoplasm"] = "стабільна ектоплазма",
    },
    [8925] = {
        ["Magma Core"] = "магматичне ядро",
    },
    [8926] = {
        ["Wildheart Belt"] = "пояс дикого серця",
        ["Wildheart Gloves"] = "рукавички дикого серця",
    },
    [8927] = {
        ["Wildheart Belt"] = "пояс дикого серця",
        ["Wildheart Gloves"] = "рукавички дикого серця",
    },
    [8928] = {
        ["Fel Elemental Rod"] = "скверно-стихійний стрижень",
    },
    [8931] = {
        ["Beaststalker's Belt"] = "пояс ловця звірів",
        ["Beaststalker's Gloves"] = "рукавички ловця звірів",
    },
    [8932] = {
        ["Magister's Belt"] = "пояс магістра",
        ["Magister's Gloves"] = "рукавички магістра",
    },
    [8933] = {
        ["Lightforge Belt"] = "світлокований пояс",
        ["Lightforge Gauntlets"] = "світлоковані рукавиці",
    },
    [8934] = {
        ["Devout Belt"] = "пояс відданості",
        ["Devout Gloves"] = "рукавички відданості",
    },
    [8935] = {
        ["Shadowcraft Belt"] = "пояс тіньового ремесла",
        ["Shadowcraft Gloves"] = "рукавиці тіньового ремесла",
    },
    [8936] = {
        ["Dreadmist Belt"] = "пояс імли жаху",
        ["Dreadmist Wraps"] = "обмотки імли жаху",
    },
    [8937] = {
        ["Belt of Valor"] = "пояс доблесті",
        ["Gauntlets of Valor"] = "рукавиці доблесті",
    },
    [8938] = {
        ["Beaststalker's Belt"] = "пояс ловця звірів",
        ["Beaststalker's Gloves"] = "рукавички ловця звірів",
    },
    [8939] = {
        ["Magister's Belt"] = "пояс магістра",
        ["Magister's Gloves"] = "рукавички магістра",
    },
    [8940] = {
        ["Devout Belt"] = "пояс відданості",
        ["Devout Gloves"] = "рукавички відданості",
    },
    [8941] = {
        ["Shadowcraft Belt"] = "пояс тіньового ремесла",
        ["Shadowcraft Gloves"] = "рукавиці тіньового ремесла",
    },
    [8942] = {
        ["Cord of Elements"] = "ремінь стихій",
        ["Gauntlets of Elements"] = "рукавиці стихій",
    },
    [8943] = {
        ["Dreadmist Belt"] = "пояс імли жаху",
        ["Dreadmist Wraps"] = "обмотки імли жаху",
    },
    [8944] = {
        ["Belt of Valor"] = "пояс доблесті",
        ["Gauntlets of Valor"] = "рукавиці доблесті",
    },
    [8947] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Dark Iron Bar"] = "злиток темного заліза",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Mooncloth"] = "місячне полотно",
    },
    [8949] = {
        ["Ogre Warbeads"] = "бойове намисто огрів",
    },
    [8950] = {
        ["Dark Rune"] = "темна руна",
        ["Jeering Spectre's Essence"] = "сутність глузливого привида",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
    },
    [8951] = {
        ["Wildheart Boots"] = "чоботи дикого серця",
        ["Wildheart Kilt"] = "кілт дикого серця",
        ["Wildheart Spaulders"] = "наплічники дикого серця",
    },
    [8952] = {
        ["Beaststalker's Boots"] = "чоботи ловця звірів",
        ["Beaststalker's Mantle"] = "напліччя ловця звірів",
        ["Beaststalker's Pants"] = "штани ловця звірів",
    },
    [8953] = {
        ["Magister's Boots"] = "чоботи магістра",
        ["Magister's Leggings"] = "поножі магістра",
        ["Magister's Mantle"] = "напліччя магістра",
    },
    [8954] = {
        ["Lightforge Boots"] = "світлоковані чоботи",
        ["Lightforge Legplates"] = "світлоковані поножі",
        ["Lightforge Spaulders"] = "світлоковані наплічники",
    },
    [8955] = {
        ["Devout Mantle"] = "напліччя відданості",
        ["Devout Sandals"] = "сандалі відданості",
        ["Devout Skirt"] = "спідниця відданості",
    },
    [8956] = {
        ["Shadowcraft Boots"] = "чоботи тіньового ремесла",
        ["Shadowcraft Pants"] = "штани тіньового ремесла",
        ["Shadowcraft Spaulders"] = "наплічники тіньового ремесла",
    },
    [8957] = {
        ["Boots of Elements"] = "чоботи стихій",
        ["Kilt of Elements"] = "кілт стихій",
        ["Pauldrons of Elements"] = "напліччя стихій",
    },
    [8958] = {
        ["Dreadmist Leggings"] = "поножі імли жаху",
        ["Dreadmist Mantle"] = "напліччя імли жаху",
        ["Dreadmist Sandals"] = "сандалі імли жаху",
    },
    [8959] = {
        ["Boots of Valor"] = "чоботи доблесті",
        ["Legplates of Valor"] = "поножі доблесті",
        ["Spaulders of Valor"] = "наплічники доблесті",
    },
    [8961] = {
        ["Cinder of Cynders"] = "попіл герцога попелу",
        ["Ember of Emberseer"] = "вуглинка Вуглегляда",
        ["Hallowed Brazier"] = "освячена жаровня",
        ["Incendicite of Incendius"] = "спалахіт Спалахія",
    },
    [8962] = {
        ["Druidical Remains"] = "друїдські останки",
    },
    [8963] = {
        ["Starbreeze Village Relic"] = "реліквія Зоряного Бризу",
    },
    [8964] = {
        ["Brilliant Sword of Zealotry"] = "блискучий меч фанатизму",
    },
    [8965] = {
        ["Soul Ashes of the Banished"] = "попіл душі вигнанця",
    },
    [8966] = {
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Mor Grayhoof slain"] = "Мор Сиве Копито: убито",
    },
    [8967] = {
        ["Isalien slain"] = "Ізалієн: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
    },
    [8968] = {
        ["Jarien slain"] = "Ярієн: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Sothos slain"] = "Сотос: убито",
    },
    [8969] = {
        ["Kormok slain"] = "Кормок: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
    },
    [8970] = {
        ["Bloodkelp"] = "кров'яниця",
    },
    [8979] = {
        ["Cologne Bottle"] = "флакон одеколону",
        ["Perfume Bottle"] = "флакон парфуму",
    },
    [8981] = {
        ["Horde Gift Collection"] = "колекція дарів Орди",
    },
    [8985] = {
        ["Starbreeze Village Relic"] = "реліквія Зоряного Бризу",
    },
    [8986] = {
        ["Druidical Remains"] = "друїдські останки",
    },
    [8987] = {
        ["Brilliant Sword of Zealotry"] = "блискучий меч фанатизму",
    },
    [8988] = {
        ["Soul Ashes of the Banished"] = "попіл душі вигнанця",
    },
    [8989] = {
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Mor Grayhoof slain"] = "Мор Сиве Копито: убито",
    },
    [8990] = {
        ["Isalien slain"] = "Ізалієн: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
    },
    [8991] = {
        ["Jarien slain"] = "Ярієн: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Sothos slain"] = "Сотос: убито",
    },
    [8992] = {
        ["Kormok slain"] = "Кормок: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
    },
    [8993] = {
        ["Alliance Gift Collection"] = "колекція дарів Альянсу",
    },
    [8994] = {
        ["Blackrock Bracer"] = "поручі Чорнокаменю",
        ["Flask of Supreme Power"] = "настій великої сили",
    },
    [8995] = {
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
    },
    [8996] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
    },
    [8999] = {
        ["Wildheart Cowl"] = "капюшон дикого серця",
        ["Wildheart Vest"] = "жилет дикого серця",
    },
    [9000] = {
        ["Beaststalker's Cap"] = "шапка ловця звірів",
        ["Beaststalker's Tunic"] = "мундир ловця звірів",
    },
    [9001] = {
        ["Magister's Crown"] = "корона магістра",
        ["Magister's Robes"] = "мантія магістра",
    },
    [9002] = {
        ["Lightforge Breastplate"] = "світлокована кіраса",
        ["Lightforge Helm"] = "світлокований шолом",
    },
    [9003] = {
        ["Devout Crown"] = "корона відданості",
        ["Devout Robe"] = "мантія відданості",
    },
    [9004] = {
        ["Shadowcraft Cap"] = "шапка тіньового ремесла",
        ["Shadowcraft Tunic"] = "мундир тіньового ремесла",
    },
    [9005] = {
        ["Dreadmist Mask"] = "маска імли жаху",
        ["Dreadmist Robe"] = "мантія імли жаху",
    },
    [9006] = {
        ["Breastplate of Valor"] = "нагрудник доблесті",
        ["Helm of Valor"] = "шолом доблесті",
    },
    [9007] = {
        ["Wildheart Cowl"] = "капюшон дикого серця",
        ["Wildheart Vest"] = "жилет дикого серця",
    },
    [9008] = {
        ["Beaststalker's Cap"] = "шапка ловця звірів",
        ["Beaststalker's Tunic"] = "мундир ловця звірів",
    },
    [9009] = {
        ["Devout Crown"] = "корона відданості",
        ["Devout Robe"] = "мантія відданості",
    },
    [9010] = {
        ["Shadowcraft Cap"] = "шапка тіньового ремесла",
        ["Shadowcraft Tunic"] = "мундир тіньового ремесла",
    },
    [9011] = {
        ["Coif of Elements"] = "койф стихій",
        ["Vest of Elements"] = "жилет стихій",
    },
    [9012] = {
        ["Dreadmist Mask"] = "маска імли жаху",
        ["Dreadmist Robe"] = "мантія імли жаху",
    },
    [9013] = {
        ["Breastplate of Valor"] = "нагрудник доблесті",
        ["Helm of Valor"] = "шолом доблесті",
    },
    [9014] = {
        ["Magister's Crown"] = "корона магістра",
        ["Magister's Robes"] = "мантія магістра",
    },
    [9015] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [9016] = {
        ["Wildheart Boots"] = "чоботи дикого серця",
        ["Wildheart Kilt"] = "кілт дикого серця",
        ["Wildheart Spaulders"] = "наплічники дикого серця",
    },
    [9017] = {
        ["Beaststalker's Boots"] = "чоботи ловця звірів",
        ["Beaststalker's Mantle"] = "напліччя ловця звірів",
        ["Beaststalker's Pants"] = "штани ловця звірів",
    },
    [9018] = {
        ["Magister's Boots"] = "чоботи магістра",
        ["Magister's Leggings"] = "поножі магістра",
        ["Magister's Mantle"] = "напліччя магістра",
    },
    [9019] = {
        ["Devout Mantle"] = "напліччя відданості",
        ["Devout Sandals"] = "сандалі відданості",
        ["Devout Skirt"] = "спідниця відданості",
    },
    [9020] = {
        ["Shadowcraft Boots"] = "чоботи тіньового ремесла",
        ["Shadowcraft Pants"] = "штани тіньового ремесла",
        ["Shadowcraft Spaulders"] = "наплічники тіньового ремесла",
    },
    [9021] = {
        ["Dreadmist Leggings"] = "поножі імли жаху",
        ["Dreadmist Mantle"] = "напліччя імли жаху",
        ["Dreadmist Sandals"] = "сандалі імли жаху",
    },
    [9022] = {
        ["Boots of Valor"] = "чоботи доблесті",
        ["Legplates of Valor"] = "поножі доблесті",
        ["Spaulders of Valor"] = "наплічники доблесті",
    },
    [9023] = {
        ["Kurinnaxx's Venom Sac"] = "отруйна залоза Куріннакса",
        ["Venoxis's Venom Sac"] = "отруйна залоза Веноксіса",
    },
    [9024] = {
        ["Cologne Bottle"] = "флакон одеколону",
        ["Perfume Bottle"] = "флакон парфуму",
    },
    [9033] = {
        ["Deathknight Captain slain"] = "капітан лицарів смерті: убито",
        ["Living Monstrosity slain"] = "ходяче чудовисько: убито",
        ["Stoneskin Gargoyle slain"] = "каменешкірий гаргуйль: убито",
        ["Venom Stalker slain"] = "отруйний ловець: убито",
    },
    [9034] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Breastplate"] = "осквернена кіраса",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9036] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Legplates"] = "осквернені ножні лати",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9037] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Helmet"] = "осквернений шолом",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9038] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Pauldrons"] = "осквернене напліччя",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9039] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Sabatons"] = "осквернені сабатони",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9040] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Gauntlets"] = "осквернені рукавиці",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9041] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Waistguard"] = "осквернений ремінь",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9042] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Bracers"] = "осквернені поручі",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9043] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9044] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9045] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9046] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9047] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9048] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9049] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9050] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
    },
    [9052] = {
        ["Bloodcap"] = "кровошляп",
        ["Gorishi Sting"] = "жало Ґоріші",
    },
    [9053] = {
        ["Putrid Vine"] = "гнила лоза",
    },
    [9054] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9055] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9056] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9057] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9058] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9059] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9060] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9061] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9068] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9069] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9070] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9071] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9072] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9073] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9074] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9075] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
    },
    [9077] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Breastplate"] = "осквернена кіраса",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9078] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Legplates"] = "осквернені ножні лати",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9079] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Helmet"] = "осквернений шолом",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9080] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Pauldrons"] = "осквернене напліччя",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9081] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Sabatons"] = "осквернені сабатони",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9082] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Gauntlets"] = "осквернені рукавиці",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9083] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Waistguard"] = "осквернений ремінь",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9084] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Bracers"] = "осквернені поручі",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9085] = {
        ["Shadow of Doom slain"] = "тінь приречення: убито",
    },
    [9086] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9087] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9088] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9089] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9090] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9091] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9092] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9093] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
    },
    [9094] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9095] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9096] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9097] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9098] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9099] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9100] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9101] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9102] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9103] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9104] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9105] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9106] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9107] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9108] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9109] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9110] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9111] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9112] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9113] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Mooncloth"] = "місячне полотно",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9114] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9115] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9116] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9117] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Mooncloth"] = "місячне полотно",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9118] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
    },
    [9121] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Righteous Orb"] = "сфера праведності",
    },
    [9122] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Nexus Crystal"] = "кристал сплетіння",
    },
    [9124] = {
        ["Crypt Fiend Parts"] = "частини тіл склепної нечисті",
    },
    [9125] = {
        ["Crypt Fiend Parts"] = "частини тіл склепної нечисті",
    },
    [9126] = {
        ["Bone Fragments"] = "фрагменти кісток",
    },
    [9127] = {
        ["Bone Fragments"] = "фрагменти кісток",
    },
    [9128] = {
        ["Core of Elements"] = "ядро стихій",
    },
    [9129] = {
        ["Core of Elements"] = "ядро стихій",
    },
    [9131] = {
        ["Dark Iron Scraps"] = "брухт темного заліза",
    },
    [9132] = {
        ["Dark Iron Scraps"] = "брухт темного заліза",
    },
    [9136] = {
        ["Savage Frond"] = "дикий пагін",
    },
    [9137] = {
        ["Savage Frond"] = "дикий пагін",
    },
    [9141] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [9142] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
    },
    [9153] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9178] = {
        ["Dense Weightstone"] = "масивне грузило",
    },
    [9179] = {
        ["Imperial Plate Chest"] = "імперська латна кіраса",
    },
    [9181] = {
        ["Volcanic Hammer"] = "вулканічний молот",
    },
    [9182] = {
        ["Huge Thorium Battleaxe"] = "величезна торієва бойова сокира",
    },
    [9183] = {
        ["Radiant Circlet"] = "променистий вінець",
    },
    [9184] = {
        ["Wicked Leather Headband"] = "лиха шкіряна бандана",
    },
    [9185] = {
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
    },
    [9186] = {
        ["Wicked Leather Belt"] = "лихий шкіряний пояс",
    },
    [9187] = {
        ["Runic Leather Pants"] = "рунічні шкіряні штани",
    },
    [9188] = {
        ["Brightcloth Pants"] = "сяйнополотняні штани",
    },
    [9190] = {
        ["Runecloth Boots"] = "чоботи з рунічного полотна",
    },
    [9191] = {
        ["Runecloth Bag"] = "сумка з рунічного полотна",
    },
    [9194] = {
        ["Runecloth Robe"] = "вбрання з рунічного полотна",
    },
    [9195] = {
        ["Goblin Sapper Charge"] = "гоблінський саперний заряд",
    },
    [9196] = {
        ["Thorium Grenade"] = "торієва граната",
    },
    [9197] = {
        ["Gnomish Battle Chicken"] = "гномське бойове курча",
    },
    [9198] = {
        ["Thorium Tube"] = "торієва трубка",
    },
    [9200] = {
        ["Major Mana Potion"] = "величезне зілля мани",
    },
    [9201] = {
        ["Greater Arcane Protection Potion"] = "велике зілля арканічного захисту",
    },
    [9202] = {
        ["Major Healing Potion"] = "величезне зілля лікування",
    },
    [9203] = {
        ["Flask of Petrification"] = "настій скам'яніння",
    },
    [9204] = {
        ["Stonescale Eel"] = "камнелуский вугор",
    },
    [9205] = {
        ["Plated Armorfish"] = "риба-броненосець",
    },
    [9206] = {
        ["Lightning Eel"] = "блискавковий вугор",
    },
    [9208] = {
        ["Arcanum of Protection"] = "магічний камінь захисту",
    },
    [9209] = {
        ["Arcanum of Rapidity"] = "магічний камінь прудкості",
    },
    [9210] = {
        ["Arcanum of Focus"] = "магічний камінь зосередження",
    },
    [9211] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
    },
    [9213] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
    },
    [9221] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9222] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9223] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9224] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9225] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9226] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9227] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9228] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Dawn"] = "відзнака Світанку",
    },
    [9229] = {
        ["Fate of Ramaladni"] = "доля Рамаладні",
    },
    [9230] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Blue Sapphire"] = "синій сапфір",
        ["Frozen Rune"] = "морозна руна",
    },
    [9232] = {
        ["Blue Sapphire"] = "синій сапфір",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
    },
    [9234] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Thorium Bar"] = "злиток торію",
    },
    [9235] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Thorium Bar"] = "злиток торію",
    },
    [9236] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Thorium Bar"] = "злиток торію",
    },
    [9237] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
    },
    [9238] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
    },
    [9239] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
    },
    [9240] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
    },
    [9241] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
    },
    [9242] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
    },
    [9243] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
    },
    [9244] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
    },
    [9245] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
    },
    [9246] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Essence of Water"] = "сутність води",
        ["Frozen Rune"] = "морозна руна",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
    },
    [9248] = {
        ["Abyssal Scepter"] = "скіпетр безодні",
    },
    [9251] = {
        ["Base of Atiesh"] = "основа Атієша",
        ["Staff Head of Atiesh"] = "верхів'я Атієша",
    },
    [9259] = {
        ["Red Dye"] = "червоний барвник",
        ["Silk Cloth"] = "шовкове полотно",
    },
    [9260] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9261] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9262] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9263] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9264] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9265] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
    },
    [9266] = {
        ["Coal"] = "вугілля",
        ["Runecloth"] = "рунічне полотно",
    },
    [9267] = {
        ["Empty Vial"] = "порожній фіал",
        ["Linen Cloth"] = "лляна тканина",
    },
    [9268] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Strong Flux"] = "сильний флюс",
    },
    [9317] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9318] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9320] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9321] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9333] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9334] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9335] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9336] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9337] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9338] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
    },
    [9341] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9343] = {
        ["Necrotic Rune"] = "некротична руна",
    },
    [9362] = {
        ["Prismatic Shell"] = "призматична мушля",
    },
    [9364] = {
        ["Polymorph Clone slain"] = "поліморфний клон: убито",
    },
    [9378] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Argent Dawn",
    },
    [79091] = {
        ["Archmage Antonidas: The Unabridged Autobiography"] = "Архімаг Антонідас: Нескорочена автобіографія",
        ["Archmage Antonidas: The Unabridged Autobiography (Provided)"] = "Архімаг Антонідас: Нескорочена автобіографія (видано)",
        ["Archmage Antonidas: The Unabridged Autobiography slain"] = "Архімаг Антонідас: Нескорочена автобіографія: убито",
    },
    [79093] = {
        ["Rumi of Gnomeregan: The Collected Works"] = "Румі з Гномрегану: Зібрання творів",
        ["Rumi of Gnomeregan: The Collected Works (Provided)"] = "Румі з Гномрегану: Зібрання творів (видано)",
        ["Rumi of Gnomeregan: The Collected Works slain"] = "Румі з Гномрегану: Зібрання творів: убито",
    },
    [86667] = {
        ["Jar of Snow"] = "Банка зі снігом",
        ["Jar of Snow (Provided)"] = "Банка зі снігом (видано)",
        ["Jar of Snow slain"] = "Банка зі снігом: убито",
    },
    [91723] = {
        ["Kobold Geomancer"] = "кобольд-геомант",
        ["Kobold Geomancer slain"] = "кобольд-геомант: убито",
    },
    [91724] = {
        ["Defias Rogue Wizard"] = "чарівник-пройдисвіт Непокірних",
        ["Defias Rogue Wizard slain"] = "чарівник-пройдисвіт Непокірних: убито",
    },
    [91725] = {
        ["Stolen Enchanting Supplies"] = "Вкрадені приналежності для зачарування",
        ["Stolen Enchanting Supplies (Provided)"] = "Вкрадені приналежності для зачарування (видано)",
        ["Stolen Enchanting Supplies slain"] = "Вкрадені приналежності для зачарування: убито",
    },
    [91732] = {
        ["Mining Tools"] = "Інструменти для видобутку корисних копалин",
        ["Mining Tools (Provided)"] = "Інструменти для видобутку корисних копалин (видано)",
        ["Mining Tools slain"] = "Інструменти для видобутку корисних копалин: убито",
    },
    [91733] = {
        ["Waterlogged Axe"] = "Замокла сокира",
        ["Waterlogged Axe (Provided)"] = "Замокла сокира (видано)",
        ["Waterlogged Axe slain"] = "Замокла сокира: убито",
        ["Waterlogged Saw"] = "Заболочена пила",
        ["Waterlogged Saw (Provided)"] = "Заболочена пила (видано)",
        ["Waterlogged Saw slain"] = "Заболочена пила: убито",
        ["Waterlogged Toolbox"] = "Заболочений інструментарій",
        ["Waterlogged Toolbox (Provided)"] = "Заболочений інструментарій (видано)",
        ["Waterlogged Toolbox slain"] = "Заболочений інструментарій: убито",
    },
    [91741] = {
        ["Nibbled-On Book"] = "Обгризена книга",
        ["Nibbled-On Book (Provided)"] = "Обгризена книга (видано)",
        ["Nibbled-On Book slain"] = "Обгризена книга: убито",
    },
    [91743] = {
        ["Stolen Book"] = "Вкрадена книга",
        ["Stolen Book (Provided)"] = "Вкрадена книга (видано)",
        ["Stolen Book slain"] = "Вкрадена книга: убито",
    },
    [91751] = {
        ["Rough Wolf Pelt"] = "Шорстка вовча шкура",
        ["Rough Wolf Pelt (Provided)"] = "Шорстка вовча шкура (видано)",
        ["Rough Wolf Pelt slain"] = "Шорстка вовча шкура: убито",
    },
    [91752] = {
        ["Sack of \"Picture\" Books"] = "Мішок книжок з картинками",
        ["Sack of \"Picture\" Books (Provided)"] = "Мішок книжок з картинками (видано)",
        ["Sack of \"Picture\" Books slain"] = "Мішок книжок з картинками: убито",
    },
    [91772] = {
        ["Followed Kobold Tracks"] = "Слідував слідами кобольдів",
        ["Followed Kobold Tracks (Provided)"] = "Слідував слідами кобольдів (видано)",
        ["Followed Kobold Tracks slain"] = "Слідував слідами кобольдів: убито",
        ["Kobold Tracking Kit"] = "Комплект для відстеження Kobold",
        ["Kobold Tracking Kit (Provided)"] = "Комплект для відстеження Kobold (видано)",
        ["Kobold Tracking Kit slain"] = "Комплект для відстеження Kobold: убито",
    },
    [91775] = {
        ["Lost Book"] = "Загублена книга",
        ["Lost Book (Provided)"] = "Загублена книга (видано)",
        ["Lost Book slain"] = "Загублена книга: убито",
        ["Picture Book: Fun with Elementals"] = "Книжка з картинками: Розваги з елементалями",
        ["Picture Book: Fun with Elementals (Provided)"] = "Книжка з картинками: Розваги з елементалями (видано)",
        ["Picture Book: Fun with Elementals slain"] = "Книжка з картинками: Розваги з елементалями: убито",
    },
    [91777] = {
        ["Arcane Explainer: Magical Stuff in Simple Words"] = "Пояснювач таємниць: магічні речі простими словами",
        ["Arcane Explainer: Magical Stuff in Simple Words (Provided)"] = "Пояснювач таємниць: магічні речі простими словами (видано)",
        ["Arcane Explainer: Magical Stuff in Simple Words slain"] = "Пояснювач таємниць: магічні речі простими словами: убито",
        ["Geomancy for Curious Young Wizards"] = "Геомантія для допитливих юних чарівників",
        ["Geomancy for Curious Young Wizards (Provided)"] = "Геомантія для допитливих юних чарівників (видано)",
        ["Geomancy for Curious Young Wizards slain"] = "Геомантія для допитливих юних чарівників: убито",
    },
    [92421] = {
        ["Intact Limbs"] = "Неушкоджені кінцівки",
        ["Intact Limbs (Provided)"] = "Неушкоджені кінцівки (видано)",
        ["Intact Limbs slain"] = "Неушкоджені кінцівки: убито",
    },
    [92461] = {
        ["Juvenile Vuldren"] = "Ювенільний Вульдрен",
        ["Juvenile Vuldren (Provided)"] = "Ювенільний Вульдрен (видано)",
        ["Juvenile Vuldren slain"] = "Ювенільний Вульдрен: убито",
    },
    [92462] = {
        ["Pesky Cirrusfly"] = "Набридлива периста муха",
        ["Pesky Cirrusfly (Provided)"] = "Набридлива периста муха (видано)",
        ["Pesky Cirrusfly slain"] = "Набридлива периста муха: убито",
    },
    [92463] = {
        ["Cirrusfly Queen"] = "Королева перистих мух",
        ["Cirrusfly Queen (Provided)"] = "Королева перистих мух (видано)",
        ["Cirrusfly Queen slain"] = "Королева перистих мух: убито",
    },
    [92465] = {
        ["Al'Aketh Convert"] = "Аль-Акет Конвертувати",
        ["Al'Aketh Convert (Provided)"] = "Аль-Акет Конвертувати (видано)",
        ["Al'Aketh Convert slain"] = "Аль-Акет Конвертувати: убито",
        ["Roiling Winds destroyed"] = "Зруйновані бурхливі вітри",
    },
    [92466] = {
        ["Signet of Akir"] = "Печатка Акіра",
        ["Signet of Akir (Provided)"] = "Печатка Акіра (видано)",
        ["Signet of Akir slain"] = "Печатка Акіра: убито",
    },
    [92470] = {
        ["Head of Urs'anah"] = "Голова Урсани",
        ["Head of Urs'anah (Provided)"] = "Голова Урсани (видано)",
        ["Head of Urs'anah slain"] = "Голова Урсани: убито",
        ["Ursera Scavenger"] = "Ведмедиця-сміттярка",
        ["Ursera Scavenger (Provided)"] = "Ведмедиця-сміттярка (видано)",
        ["Ursera Scavenger slain"] = "Ведмедиця-сміттярка: убито",
    },
    [92473] = {
        ["Scrawny Ursera Claw"] = "Кіготь худорлявої ведмедиці",
        ["Scrawny Ursera Claw (Provided)"] = "Кіготь худорлявої ведмедиці (видано)",
        ["Scrawny Ursera Claw slain"] = "Кіготь худорлявої ведмедиці: убито",
    },
    [92474] = {
        ["Use Walk on Air"] = "Використовуйте функцію «Прогулянка в прямому ефірі»",
    },
    [92481] = {
        ["Glowing Recall Crystal"] = "Сяючий кристал відкликання",
        ["Glowing Recall Crystal (Provided)"] = "Сяючий кристал відкликання (видано)",
        ["Glowing Recall Crystal slain"] = "Сяючий кристал відкликання: убито",
    },
    [92482] = {
        ["Scribbled Note"] = "Накреслена нотатка",
        ["Scribbled Note (Provided)"] = "Накреслена нотатка (видано)",
        ["Scribbled Note slain"] = "Накреслена нотатка: убито",
    },
    [92514] = {
        ["Speak with Illaya Amberwind"] = "Поговоріть з Іллайєю Амбервінд",
        ["Speak with the Innkeeper"] = "Поговоріть з господарем готелю",
    },
    [92515] = {
        ["Prideclaw Pelt"] = "Шкура Гордого Кігтя",
        ["Prideclaw Pelt (Provided)"] = "Шкура Гордого Кігтя (видано)",
        ["Prideclaw Pelt slain"] = "Шкура Гордого Кігтя: убито",
    },
    [92516] = {
        ["Hippogryph Matriarch"] = "Гіпогриф-матріарх",
        ["Hippogryph Matriarch (Provided)"] = "Гіпогриф-матріарх (видано)",
        ["Hippogryph Matriarch slain"] = "Гіпогриф-матріарх: убито",
        ["Hippogryph Protector"] = "Гіпогриф-захисник",
        ["Hippogryph Protector (Provided)"] = "Гіпогриф-захисник (видано)",
        ["Hippogryph Protector slain"] = "Гіпогриф-захисник: убито",
        ["Hippogryph Youth"] = "Гіпогриф Юність",
        ["Hippogryph Youth (Provided)"] = "Гіпогриф Юність (видано)",
        ["Hippogryph Youth slain"] = "Гіпогриф Юність: убито",
    },
    [92517] = {
        ["\"Badwind\" Bennic"] = "«Поганий вітер» Беннік",
        ["\"Badwind\" Bennic (Provided)"] = "«Поганий вітер» Беннік (видано)",
        ["\"Badwind\" Bennic slain"] = "«Поганий вітер» Беннік: убито",
        ["Highlands Bandit"] = "Хайлендський бандит",
        ["Highlands Bandit (Provided)"] = "Хайлендський бандит (видано)",
        ["Highlands Bandit slain"] = "Хайлендський бандит: убито",
    },
    [92528] = {
        ["Learn about the cultists' plans"] = "Дізнайтеся про плани культистів",
    },
    [92532] = {
        ["Crumpled Note"] = "зім'ята записка",
        ["Crumpled Note (Provided)"] = "зім'ята записка (видано)",
    },
    [92544] = {
        ["Al'Aketh Brute"] = "Аль'Акет Брут",
        ["Al'Aketh Brute (Provided)"] = "Аль'Акет Брут (видано)",
        ["Al'Aketh Brute slain"] = "Аль'Акет Брут: убито",
        ["Al'Aketh Neophyte"] = "Аль'Акет Неофіт",
        ["Al'Aketh Neophyte (Provided)"] = "Аль'Акет Неофіт (видано)",
        ["Al'Aketh Neophyte slain"] = "Аль'Акет Неофіт: убито",
        ["Malduko Cloudcrush"] = "Мальдуко Хмарний Краш",
        ["Malduko Cloudcrush (Provided)"] = "Мальдуко Хмарний Краш (видано)",
        ["Malduko Cloudcrush slain"] = "Мальдуко Хмарний Краш: убито",
    },
    [92550] = {
        ["Al'Aketh Stormcaller"] = "Ал'Акет, Заклинатель Бурі",
        ["Al'Aketh Stormcaller (Provided)"] = "Ал'Акет, Заклинатель Бурі (видано)",
        ["Al'Aketh Stormcaller slain"] = "Ал'Акет, Заклинатель Бурі: убито",
        ["Commander Cyclas's Head"] = "Голова командира Сайкласа",
        ["Commander Cyclas's Head (Provided)"] = "Голова командира Сайкласа (видано)",
        ["Commander Cyclas's Head slain"] = "Голова командира Сайкласа: убито",
        ["Living Lightning"] = "Жива блискавка",
        ["Living Lightning (Provided)"] = "Жива блискавка (видано)",
        ["Living Lightning slain"] = "Жива блискавка: убито",
    },
    [92551] = {
        ["Stolen Shen'dar Supplies"] = "Викрадені припаси Шен'дара",
        ["Stolen Shen'dar Supplies (Provided)"] = "Викрадені припаси Шен'дара (видано)",
        ["Stolen Shen'dar Supplies slain"] = "Викрадені припаси Шен'дара: убито",
    },
    [92553] = {
        ["Small Egg"] = "маленьке яйце",
        ["Small Egg (Provided)"] = "маленьке яйце (видано)",
        ["Strider Meat"] = "м'ясо бігуна",
        ["Strider Meat (Provided)"] = "м'ясо бігуна (видано)",
    },
    [92579] = {
        ["Aonda's Written Report"] = "Письмовий звіт Аонди",
        ["Aonda's Written Report (Provided)"] = "Письмовий звіт Аонди (видано)",
        ["Aonda's Written Report slain"] = "Письмовий звіт Аонди: убито",
    },
    [92595] = {
        ["Listen to Illaya"] = "Слухайте Іллаю",
    },
    [92596] = {
        ["Listen to Rathiril Sunlance"] = "Слухайте Ратхіріла Санленса",
    },
    [92597] = {
        ["Use your Read Ley Line ability near the Thendal Grove Ley Line"] = "Використайте свою здатність «Читати лей-лінію» поблизу лей-лінії Тендал Гроув.",
    },
    [92598] = {
        ["Use Skysight near the Elemental Convergence"] = "Використовуйте Skysight поблизу Elemental Convergence",
    },
    [92640] = {
        ["Recruit the High Order"] = "Завербуйте вищий орден",
        ["Recruit the High Order (Provided)"] = "Завербуйте вищий орден (видано)",
        ["Recruit the High Order slain"] = "Завербуйте вищий орден: убито",
        ["Recruit the Windshapers"] = "Завербуйте вітроутворювачів",
        ["Recruit the Windshapers (Provided)"] = "Завербуйте вітроутворювачів (видано)",
        ["Recruit the Windshapers slain"] = "Завербуйте вітроутворювачів: убито",
        ["Speak with Valennia Stormfist"] = "Поговоріть з Валенією Буревісник",
    },
    [92642] = {
        ["Al'Aketh Brawler"] = "Аль'Акетський бешкетник",
        ["Al'Aketh Brawler (Provided)"] = "Аль'Акетський бешкетник (видано)",
        ["Al'Aketh Brawler slain"] = "Аль'Акетський бешкетник: убито",
        ["Al'Aketh Healer"] = "Цілитель Аль'Акет",
        ["Al'Aketh Healer (Provided)"] = "Цілитель Аль'Акет (видано)",
        ["Al'Aketh Healer slain"] = "Цілитель Аль'Акет: убито",
    },
    [92643] = {
        ["Find the Al'Aketh Turncoat"] = "Знайдіть перебіжчика Ал'Акета",
        ["Find the secluded house in Shen'dar Highlands"] = "Знайдіть відокремлений будинок у Шен'дарському нагір'ї",
    },
    [92644] = {
        ["Glowing Crystal"] = "Сяючий кристал",
        ["Glowing Crystal (Provided)"] = "Сяючий кристал (видано)",
        ["Glowing Crystal slain"] = "Сяючий кристал: убито",
    },
    [92645] = {
        ["Commander Belguilos"] = "Командир Белгілос",
        ["Commander Belguilos (Provided)"] = "Командир Белгілос (видано)",
        ["Commander Belguilos slain"] = "Командир Белгілос: убито",
    },
    [92646] = {
        ["Confront Lorthuna"] = "Протистояти Лортуні",
    },
    [92679] = {
        ["Find Aamelia Windfield"] = "Знайдіть Амелію Віндфілд",
        ["Listen to Alvarion Windfield's Story"] = "Послухайте історію Алваріона Віндфілда",
    },
    [92682] = {
        ["Hungry Bandit"] = "Голодний бандит",
        ["Hungry Bandit (Provided)"] = "Голодний бандит (видано)",
        ["Hungry Bandit slain"] = "Голодний бандит: убито",
        ["Ripe Stormapple"] = "Стиглий штормовий яблуко",
        ["Ripe Stormapple (Provided)"] = "Стиглий штормовий яблуко (видано)",
        ["Ripe Stormapple slain"] = "Стиглий штормовий яблуко: убито",
    },
    [92683] = {
        ["Flutterfly Dust"] = "Пил від пурхаючої мухи",
        ["Flutterfly Dust (Provided)"] = "Пил від пурхаючої мухи (видано)",
        ["Flutterfly Dust slain"] = "Пил від пурхаючої мухи: убито",
        ["Flutterfly Swatter"] = "Мухобойка для пурхатих мух",
        ["Flutterfly Swatter (Provided)"] = "Мухобойка для пурхатих мух (видано)",
        ["Flutterfly Swatter slain"] = "Мухобойка для пурхатих мух: убито",
    },
    [92684] = {
        ["Lowlands Galestrider Tenderloin"] = "Вирізка низинного в'юнного в'юнка",
        ["Lowlands Galestrider Tenderloin (Provided)"] = "Вирізка низинного в'юнного в'юнка (видано)",
        ["Lowlands Galestrider Tenderloin slain"] = "Вирізка низинного в'юнного в'юнка: убито",
    },
    [92685] = {
        ["Blood-Stained Bandit Mask"] = "Маска бандита, заплямована кров'ю",
        ["Blood-Stained Bandit Mask (Provided)"] = "Маска бандита, заплямована кров'ю (видано)",
        ["Blood-Stained Bandit Mask slain"] = "Маска бандита, заплямована кров'ю: убито",
    },
    [92693] = {
        ["Follow Aamelia and make your final stand"] = "Слідкуйте за Аамелією та зробіть свій останній крок",
        ["Speak with Aamelia Windfield"] = "Поговоріть з Амелією Віндфілд",
    },
    [92708] = {
        ["Listen to Ayessa"] = "Слухайте Айєсу.",
    },
    [92744] = {
        ["Longshore Murloc Gill"] = "Лонгшор Мерлок Гілл",
        ["Longshore Murloc Gill (Provided)"] = "Лонгшор Мерлок Гілл (видано)",
        ["Longshore Murloc Gill slain"] = "Лонгшор Мерлок Гілл: убито",
    },
    [92947] = {
        ["Al'Aketh Blademaster"] = "Майстер клинка Ал'Акет",
        ["Al'Aketh Blademaster (Provided)"] = "Майстер клинка Ал'Акет (видано)",
        ["Al'Aketh Blademaster slain"] = "Майстер клинка Ал'Акет: убито",
        ["Al'Aketh Guardian"] = "Аль'Акет Гардіан",
        ["Al'Aketh Guardian (Provided)"] = "Аль'Акет Гардіан (видано)",
        ["Al'Aketh Guardian slain"] = "Аль'Акет Гардіан: убито",
        ["Al'Aketh Spiritcaller"] = "Ал'Акет, заклинатель духів",
        ["Al'Aketh Spiritcaller (Provided)"] = "Ал'Акет, заклинатель духів (видано)",
        ["Al'Aketh Spiritcaller slain"] = "Ал'Акет, заклинатель духів: убито",
        ["Report to Hyusaa Quickbreeze"] = "Звітувати до Х'юсаа Квікбріз",
    },
    [93065] = {
        ["Find Valennia on the Road"] = "Знайдіть Валенію на дорозі",
    },
    [93159] = {
        ["Learn more about the Strange Hermit"] = "Дізнайтеся більше про Дивного Відлюдника",
    },
    [93165] = {
        ["Al'Alketh Cultist's Ear"] = "Вухо культиста Ал'Алкета",
        ["Al'Alketh Cultist's Ear (Provided)"] = "Вухо культиста Ал'Алкета (видано)",
        ["Al'Alketh Cultist's Ear slain"] = "Вухо культиста Ал'Алкета: убито",
    },
    [93317] = {
        ["Windsong Crawler Meat"] = "М'ясо повзуна Вітропісні",
        ["Windsong Crawler Meat (Provided)"] = "М'ясо повзуна Вітропісні (видано)",
        ["Windsong Crawler Meat slain"] = "М'ясо повзуна Вітропісні: убито",
    },
    [93318] = {
        ["Vulgara's Head"] = "Голова Вульгари",
        ["Vulgara's Head (Provided)"] = "Голова Вульгари (видано)",
        ["Vulgara's Head slain"] = "Голова Вульгари: убито",
    },
    [93319] = {
        ["Pilfered Windstone"] = "Вкрадений вітряний камінь",
        ["Pilfered Windstone (Provided)"] = "Вкрадений вітряний камінь (видано)",
        ["Pilfered Windstone slain"] = "Вкрадений вітряний камінь: убито",
    },
    [93459] = {
        ["Al'Alketh Cultist's Ear"] = "Вухо культиста Ал'Алкета",
        ["Al'Alketh Cultist's Ear (Provided)"] = "Вухо культиста Ал'Алкета (видано)",
        ["Al'Alketh Cultist's Ear slain"] = "Вухо культиста Ал'Алкета: убито",
    },
    [93461] = {
        ["Speak with Rathiril Sunlance"] = "Поговоріть з Ратхірілом Санланс",
        ["Speak with the Innkeeper"] = "Поговоріть з господарем готелю",
    },
    [93552] = {
        ["Windstone Cluster"] = "Скупчення Вітряного каменю",
        ["Windstone Cluster (Provided)"] = "Скупчення Вітряного каменю (видано)",
        ["Windstone Cluster slain"] = "Скупчення Вітряного каменю: убито",
    },
    [93736] = {
        ["Wind Hollow Essence"] = "Сутність Вітряної Ущелини",
        ["Wind Hollow Essence (Provided)"] = "Сутність Вітряної Ущелини (видано)",
        ["Wind Hollow Essence slain"] = "Сутність Вітряної Ущелини: убито",
    },
    [93737] = {
        ["Air Construct Core"] = "Повітряний конструкційний ядро",
        ["Air Construct Core (Provided)"] = "Повітряний конструкційний ядро (видано)",
        ["Air Construct Core slain"] = "Повітряний конструкційний ядро: убито",
        ["Crystallized Lightning"] = "Кристалізована блискавка",
        ["Crystallized Lightning (Provided)"] = "Кристалізована блискавка (видано)",
        ["Crystallized Lightning slain"] = "Кристалізована блискавка: убито",
        ["Enchanted Gyrozephyr"] = "Зачарований Гірозефір",
        ["Enchanted Gyrozephyr (Provided)"] = "Зачарований Гірозефір (видано)",
        ["Enchanted Gyrozephyr slain"] = "Зачарований Гірозефір: убито",
        ["Listen to what Riaani Nightwind has to say"] = "Послухайте, що каже Ріані Найтвінд",
    },
    [93739] = {
        ["Obtain Instructions from Nazgrel"] = "Отримати інструкції від Назгрела",
        ["Speak with Cairne Bloodhoof"] = "Поговоріть з Керном Кривавим Копитом",
        ["Speak with Lady Sylvanas Windrunner"] = "Поговоріть з леді Сільваною Віндраннер",
        ["Speak with Vol'jin"] = "Поговори з Вол'джином",
    },
    [93740] = {
        ["Al'Aketh Windstone Charm"] = "Оберіг з вітряного каменю Аль'Акет",
        ["Al'Aketh Windstone Charm (Provided)"] = "Оберіг з вітряного каменю Аль'Акет (видано)",
        ["Al'Aketh Windstone Charm slain"] = "Оберіг з вітряного каменю Аль'Акет: убито",
    },
    [93746] = {
        ["Confront Belathaan Brightwish"] = "Протистояти Белатаану Брайтвішу",
        ["Defeat the Living Storms"] = "Переможіть Живі Бурі",
    },
    [93836] = {
        ["Speak with Talaanis Shadowsong"] = "Поговоріть з Талаанісом Тіньоспівом",
    },
    [93926] = {
        ["Check in on the Western Watchtower in the Shen'dar Highlands"] = "Завітайте до Західної сторожової вежі у Шен'дарському нагір'ї",
    },
    [93927] = {
        ["Collect and read the note"] = "Зберіть та прочитайте записку",
        ["Raani's Favorite Feather"] = "Улюблене перо Раані",
        ["Raani's Favorite Feather (Provided)"] = "Улюблене перо Раані (видано)",
        ["Raani's Favorite Feather slain"] = "Улюблене перо Раані: убито",
        ["Shadowsong Family Signet"] = "Сімейна печатка Тіньопісні",
        ["Shadowsong Family Signet (Provided)"] = "Сімейна печатка Тіньопісні (видано)",
        ["Shadowsong Family Signet slain"] = "Сімейна печатка Тіньопісні: убито",
        ["Skypriest Aanders"] = "Небесний жрець Аандерс",
        ["Skypriest Aanders (Provided)"] = "Небесний жрець Аандерс (видано)",
        ["Skypriest Aanders slain"] = "Небесний жрець Аандерс: убито",
    },
    [93948] = {
        ["Shadowsong Family Signet"] = "Сімейна печатка Тіньопісні",
        ["Shadowsong Family Signet (Provided)"] = "Сімейна печатка Тіньопісні (видано)",
        ["Shadowsong Family Signet slain"] = "Сімейна печатка Тіньопісні: убито",
    },
    [93949] = {
        ["Enchanted Skyhopper Exterminated"] = "Зачарований Скайхопер знищений",
    },
    [93951] = {
        ["Hippogryph Down"] = "Гіпогриф вниз",
        ["Hippogryph Down (Provided)"] = "Гіпогриф вниз (видано)",
        ["Hippogryph Down slain"] = "Гіпогриф вниз: убито",
    },
    [94013] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94373] = {
        ["Iceclaw Bear Pendant"] = "Кулон «Ведмідь Крижаний Кіготь»",
        ["Iceclaw Bear Pendant (Provided)"] = "Кулон «Ведмідь Крижаний Кіготь» (видано)",
        ["Iceclaw Bear Pendant slain"] = "Кулон «Ведмідь Крижаний Кіготь»: убито",
    },
    [94375] = {
        ["Rough Quartz"] = "грубий кварц",
        ["Rough Quartz (Provided)"] = "грубий кварц (видано)",
    },
    [94411] = {
        ["High Order Apprentice defeated"] = "Учень Вищого Ордена переможений",
    },
    [94413] = {
        ["Windshaper Novice Seer defeated"] = "Початківець-провидець Творця вітру переможений",
    },
    [94414] = {
        ["View the Anchor Pylon"] = "Переглянути анкерний пілон",
    },
    [94485] = {
        ["Lady's Tear Moss"] = "Ледінська сльоза",
        ["Lady's Tear Moss (Provided)"] = "Ледінська сльоза (видано)",
        ["Lady's Tear Moss slain"] = "Ледінська сльоза: убито",
    },
    [94486] = {
        ["Pristine Shriekling Feathers"] = "Незаймане верещаче пір'я",
        ["Pristine Shriekling Feathers (Provided)"] = "Незаймане верещаче пір'я (видано)",
        ["Pristine Shriekling Feathers slain"] = "Незаймане верещаче пір'я: убито",
    },
    [94487] = {
        ["Bloody Heirloom"] = "Кривава реліквія",
        ["Bloody Heirloom (Provided)"] = "Кривава реліквія (видано)",
        ["Bloody Heirloom slain"] = "Кривава реліквія: убито",
    },
    [94488] = {
        ["Commander Haalien's Severed Head"] = "Відрубана голова командира Хааліена",
        ["Commander Haalien's Severed Head (Provided)"] = "Відрубана голова командира Хааліена (видано)",
        ["Commander Haalien's Severed Head slain"] = "Відрубана голова командира Хааліена: убито",
    },
    [94489] = {
        ["Baeo Sharpstrike"] = "Гострий удар Бео",
        ["Baeo Sharpstrike (Provided)"] = "Гострий удар Бео (видано)",
        ["Baeo Sharpstrike slain"] = "Гострий удар Бео: убито",
        ["Bryaes Galechaser"] = "Бріас Гейлчейзер",
        ["Bryaes Galechaser (Provided)"] = "Бріас Гейлчейзер (видано)",
        ["Bryaes Galechaser slain"] = "Бріас Гейлчейзер: убито",
        ["Find Jorel Windsinger"] = "Знайдіть Джорела Віндсінгера",
        ["Injured Druids healed"] = "Поранені друїди зцілені",
        ["Injured Druids healed (Provided)"] = "Поранені друїди зцілені (видано)",
        ["Injured Druids healed slain"] = "Поранені друїди зцілені: убито",
        ["Mithraless Sterngale"] = "Мітралес Стернгейл",
        ["Mithraless Sterngale (Provided)"] = "Мітралес Стернгейл (видано)",
        ["Mithraless Sterngale slain"] = "Мітралес Стернгейл: убито",
        ["Naaleos Leafwhisper"] = "Наалеос Листяний Шепіт",
        ["Naaleos Leafwhisper (Provided)"] = "Наалеос Листяний Шепіт (видано)",
        ["Naaleos Leafwhisper slain"] = "Наалеос Листяний Шепіт: убито",
        ["Nayeela Snarlfang"] = "Найїла Снарлфанг",
        ["Nayeela Snarlfang (Provided)"] = "Найїла Снарлфанг (видано)",
        ["Nayeela Snarlfang slain"] = "Найїла Снарлфанг: убито",
        ["Neyasteel Mossmender"] = "Неястил Моссмендер",
        ["Neyasteel Mossmender (Provided)"] = "Неястил Моссмендер (видано)",
        ["Neyasteel Mossmender slain"] = "Неястил Моссмендер: убито",
        ["Telenos \nLeafwhisper × 1"] = "Теленос \nШепіт листя × 1",
        ["Telenos \nLeafwhisper × 1 (Provided)"] = "Теленос \nШепіт листя × 1 (видано)",
        ["Telenos \nLeafwhisper × 1 slain"] = "Теленос \nШепіт листя × 1: убито",
    },
    [94568] = {
        ["Learn what you can from the crystal"] = "Дізнайтеся, що ви можете, з кристала",
    },
    [94896] = {
        ["Abandoned Belongings"] = "Покинуті речі",
        ["Abandoned Belongings (Provided)"] = "Покинуті речі (видано)",
        ["Abandoned Belongings slain"] = "Покинуті речі: убито",
    },
    [94897] = {
        ["Resaan's Heirloom"] = "Реліквія Ресаана",
        ["Resaan's Heirloom (Provided)"] = "Реліквія Ресаана (видано)",
        ["Resaan's Heirloom slain"] = "Реліквія Ресаана: убито",
    },
    [94978] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94979] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [95041] = {
        ["Gnomeregan Archival Data"] = "Архівні дані Гномерегану",
        ["Gnomeregan Archival Data (Provided)"] = "Архівні дані Гномерегану (видано)",
        ["Gnomeregan Archival Data slain"] = "Архівні дані Гномерегану: убито",
    },
    [95065] = {
        ["Nightcrawlers"] = "опариші",
        ["Nightcrawlers (Provided)"] = "опариші (видано)",
        ["Shiny Bauble"] = "блискуча блешня",
        ["Shiny Bauble (Provided)"] = "блискуча блешня (видано)",
    },
    [95212] = {
        ["Pristine Leopard Pelt"] = "Незаймана леопардова шкура",
        ["Pristine Leopard Pelt (Provided)"] = "Незаймана леопардова шкура (видано)",
        ["Pristine Leopard Pelt slain"] = "Незаймана леопардова шкура: убито",
    },
    [95216] = {
        ["Highly Toxic Strain"] = "Високотоксичний штам",
        ["Highly Toxic Strain (Provided)"] = "Високотоксичний штам (видано)",
        ["Highly Toxic Strain slain"] = "Високотоксичний штам: убито",
    },
    [95998] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96031] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [96044] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [96047] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [96050] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [96055] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [96056] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [96057] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [96059] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [96101] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96390] = {
        ["Dark Iron Spy"] = "шпигун Темного Заліза",
        ["Dark Iron Spy slain"] = "шпигун Темного Заліза: убито",
    },
    [96391] = {
        ["Dark Iron Map"] = "Карта Темного Заліза",
        ["Dark Iron Map (Provided)"] = "Карта Темного Заліза (видано)",
        ["Dark Iron Map slain"] = "Карта Темного Заліза: убито",
    },
    [96392] = {
        ["Use Farsen's Farsight"] = "Використайте далекоглядність Фарсена",
    },
    [96393] = {
        ["Durgen Dirgehammer's Head"] = "Голова Дургена Діргехаммера",
        ["Durgen Dirgehammer's Head (Provided)"] = "Голова Дургена Діргехаммера (видано)",
        ["Durgen Dirgehammer's Head slain"] = "Голова Дургена Діргехаммера: убито",
    },
    [96394] = {
        ["Enraged Apparition"] = "Розлючена привид",
        ["Enraged Apparition (Provided)"] = "Розлючена привид (видано)",
        ["Enraged Apparition slain"] = "Розлючена привид: убито",
        ["Tormented Soul"] = "Змучена душа",
        ["Tormented Soul (Provided)"] = "Змучена душа (видано)",
        ["Tormented Soul slain"] = "Змучена душа: убито",
    },
    [96403] = {
        ["Dwarven Heirloom"] = "Гномська реліквія",
        ["Dwarven Heirloom (Provided)"] = "Гномська реліквія (видано)",
        ["Dwarven Heirloom slain"] = "Гномська реліквія: убито",
    },
    [96626] = {
        ["Learn cooking from Tomas in Goldshire"] = "Навчіться готувати у Томаса в Голдширі",
    },
    [96646] = {
        ["Learn cooking from Zerril Softbreeze in Shen'dar Village"] = "Навчіться готувати у Зерріл Софтбріз у селі Шен'дар",
    },
    [97279] = {
        ["Abandoned Training Weapon"] = "Покинута навчальна зброя",
        ["Abandoned Training Weapon (Provided)"] = "Покинута навчальна зброя (видано)",
        ["Abandoned Training Weapon slain"] = "Покинута навчальна зброя: убито",
    },
    [97891] = {
        ["Speak to Doctor Martin Felben"] = "Поговоріть з доктором Мартіном Фельбеном",
    },
    [97916] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97918] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [97919] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97920] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97921] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97923] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97925] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97965] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [99158] = {
        ["Bring the crate of candles to Father Gavin."] = "Віднести ящик свічок отцю Ґевіну",
    },
}
for questID, translations in pairs(questTasks) do
    for _, quests in ipairs({ addonTable.quest_alliance, addonTable.quest_both, addonTable.quest_horde }) do
        local quest = quests and quests[questID]
        if quest then
            quest.tasks = quest.tasks or {}
            for source, translated in pairs(translations) do
                if quest.tasks[source] == nil then quest.tasks[source] = translated end
            end
        end
    end
end
