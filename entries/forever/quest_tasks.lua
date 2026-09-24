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
        ["Garrick's Head (Provided)"] = "голова Ґарріка (видано)",
    },
    [7] = {
        ["Kobold Vermin"] = "кобольд-шкідник",
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
        ["Scrimshank's Surveying Gear (Provided)"] = "землемірне спорядження Полотноміра (видано)",
    },
    [11] = {
        ["Painted Gnoll Armband"] = "розфарбований браслет гнола",
        ["Painted Gnoll Armband (Provided)"] = "розфарбований браслет гнола (видано)",
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
        ["Defias Highwayman"] = "нальотник Непокірних",
        ["Defias Highwayman slain"] = "нальотник Непокірних: убито",
        ["Defias Knuckleduster"] = "кастетник Непокірних",
        ["Defias Knuckleduster slain"] = "кастетник Непокірних: убито",
        ["Defias Pathstalker"] = "вистежувач Непокірних",
        ["Defias Pathstalker slain"] = "вистежувач Непокірних: убито",
    },
    [15] = {
        ["Kobold Worker"] = "кобольд-робітник",
        ["Kobold Worker slain"] = "кобольд-робітник: убито",
    },
    [16] = {
        ["Refreshing Spring Water"] = "освіжаюча джерельна вода",
        ["Refreshing Spring Water (Provided)"] = "освіжаюча джерельна вода (видано)",
    },
    [17] = {
        ["Magenta Fungus Cap"] = "гриб-малиновик",
        ["Magenta Fungus Cap (Provided)"] = "гриб-малиновик (видано)",
    },
    [18] = {
        ["Red Burlap Bandana"] = "червона бандана з мішковини",
        ["Red Burlap Bandana (Provided)"] = "червона бандана з мішковини (видано)",
    },
    [19] = {
        ["Tharil'zun's Head"] = "голова Таріл'зуна",
        ["Tharil'zun's Head (Provided)"] = "голова Таріл'зуна (видано)",
    },
    [20] = {
        ["Battleworn Axe"] = "зношена сокира",
        ["Battleworn Axe (Provided)"] = "зношена сокира (видано)",
    },
    [21] = {
        ["Kobold Laborer"] = "кобольд-різнороб",
        ["Kobold Laborer slain"] = "кобольд-різнороб: убито",
    },
    [22] = {
        ["Goretusk Liver"] = "печінка іклоштрика",
        ["Goretusk Liver (Provided)"] = "печінка іклоштрика (видано)",
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
        ["Befouled Water Elemental"] = "забруднений елементаль води",
        ["Befouled Water Elemental slain"] = "забруднений елементаль води: убито",
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
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
        ["Pendant of the Sea Lion (Provided)"] = "підвіска Морського Лева (видано)",
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
        ["Tough Wolf Meat (Provided)"] = "жорстке вовче м'ясо (видано)",
    },
    [34] = {
        ["Bellygrub's Tusk"] = "ікло Грубопуза",
        ["Bellygrub's Tusk (Provided)"] = "ікло Грубопуза (видано)",
    },
    [36] = {
        ["Verna's Westfall Stew Recipe"] = "рецепт гуляшу по-західнокрайськи від Верни",
        ["Verna's Westfall Stew Recipe (Provided)"] = "рецепт гуляшу по-західнокрайськи від Верни (видано)",
    },
    [38] = {
        ["Goretusk Snout"] = "рило іклоштрика",
        ["Goretusk Snout (Provided)"] = "рило іклоштрика (видано)",
        ["Murloc Eye"] = "око мурлока",
        ["Murloc Eye (Provided)"] = "око мурлока (видано)",
        ["Okra"] = "окра",
        ["Okra (Provided)"] = "окра (видано)",
        ["Stringy Vulture Meat"] = "жилаве м'ясо грифа",
        ["Stringy Vulture Meat (Provided)"] = "жилаве м'ясо грифа (видано)",
    },
    [46] = {
        ["Torn Murloc Fin"] = "порваний плавник мурлока",
        ["Torn Murloc Fin (Provided)"] = "порваний плавник мурлока (видано)",
    },
    [47] = {
        ["Gold Dust"] = "золотий пил",
        ["Gold Dust (Provided)"] = "золотий пил (видано)",
    },
    [48] = {
        ["Holy Spring Water"] = "вода святого джерела",
        ["Holy Spring Water (Provided)"] = "вода святого джерела (видано)",
    },
    [49] = {
        ["Sack of Barley"] = "мішок ячменю",
        ["Sack of Barley (Provided)"] = "мішок ячменю (видано)",
        ["Sack of Corn"] = "мішок кукурудзи",
        ["Sack of Corn (Provided)"] = "мішок кукурудзи (видано)",
        ["Sack of Rye"] = "мішок жита",
        ["Sack of Rye (Provided)"] = "мішок жита (видано)",
    },
    [50] = {
        ["Truesilver Bar"] = "злиток ясносрібла",
        ["Truesilver Bar (Provided)"] = "злиток ясносрібла (видано)",
    },
    [51] = {
        ["A Sycamore Branch"] = "гілка платану",
        ["A Sycamore Branch (Provided)"] = "гілка платану (видано)",
    },
    [52] = {
        ["Prowler"] = "бродячий хижак",
        ["Prowler slain"] = "бродячий хижак: убито",
        ["Young Forest Bear"] = "молодий лісовий ведмідь",
        ["Young Forest Bear slain"] = "молодий лісовий ведмідь: убито",
    },
    [53] = {
        ["Bundle of Charred Oak"] = "зв'язка обвугленого дуба",
        ["Bundle of Charred Oak (Provided)"] = "зв'язка обвугленого дуба (видано)",
    },
    [54] = {
        ["Marshal McBride's Documents"] = "документи маршала Макбрайда",
        ["Marshal McBride's Documents (Provided)"] = "документи маршала Макбрайда (видано)",
    },
    [55] = {
        ["Morbent Fel"] = "Морбент Скверн",
        ["Morbent Fel slain"] = "Морбент Скверн: убито",
        ["Morbent's Bane"] = "прокляття Морбента",
        ["Morbent's Bane (Provided)"] = "прокляття Морбента (видано)",
    },
    [56] = {
        ["Skeletal Mage"] = "скелетний маг",
        ["Skeletal Mage slain"] = "скелетний маг: убито",
        ["Skeletal Warrior"] = "скелетний воїн",
        ["Skeletal Warrior slain"] = "скелетний воїн: убито",
    },
    [57] = {
        ["Skeletal Fiend"] = "скелетний марник",
        ["Skeletal Fiend slain"] = "скелетний марник: убито",
        ["Skeletal Horror"] = "скелетне страховище",
        ["Skeletal Horror slain"] = "скелетне страховище: убито",
    },
    [58] = {
        ["Plague Spreader"] = "розповсюдник чуми",
        ["Plague Spreader slain"] = "розповсюдник чуми: убито",
    },
    [59] = {
        ["Stormwind Armor Marker"] = "знак броні Штормовію",
        ["Stormwind Armor Marker (Provided)"] = "знак броні Штормовію (видано)",
    },
    [60] = {
        ["Large Candle"] = "велика свічка",
        ["Large Candle (Provided)"] = "велика свічка (видано)",
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
        ["Corrupt Manifestation's Bracers (Provided)"] = "наручі зіпсованого прояву (видано)",
        ["Remaining Drops of Purest Water"] = "залишки крапель найчистішої води",
        ["Remaining Drops of Purest Water (Provided)"] = "залишки крапель найчистішої води (видано)",
    },
    [64] = {
        ["Furlbrow's Pocket Watch"] = "кишеньковий годинник Хмуроброва",
        ["Furlbrow's Pocket Watch (Provided)"] = "кишеньковий годинник Хмуроброва (видано)",
    },
    [68] = {
        ["A Dusty Unsent Letter"] = "вкритий пилом невідправлений лист",
        ["A Dusty Unsent Letter (Provided)"] = "вкритий пилом невідправлений лист (видано)",
    },
    [70] = {
        ["An Undelivered Letter"] = "недоставлений лист",
        ["An Undelivered Letter (Provided)"] = "недоставлений лист (видано)",
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
        ["A Faded Journal Page (Provided)"] = "вицвіла сторінка щоденника (видано)",
    },
    [76] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Scout through the Jasperlode Mine"] = "Дослідіть Яшмову шахту",
    },
    [77] = {
        ["Hinterlands Honey Ripple"] = "медова шипучка Внутрішніх земель",
        ["Hinterlands Honey Ripple (Provided)"] = "медова шипучка Внутрішніх земель (видано)",
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
        ["Centipaar Insect Parts (Provided)"] = "частини тіл комах Сентіпаар (видано)",
    },
    [83] = {
        ["Red Linen Bandana"] = "червона лляна бандана",
        ["Red Linen Bandana (Provided)"] = "червона лляна бандана (видано)",
    },
    [84] = {
        ["Pork Belly Pie"] = "пиріг зі свинячої підчеревини",
        ["Pork Belly Pie (Provided)"] = "пиріг зі свинячої підчеревини (видано)",
    },
    [86] = {
        ["Chunk of Boar Meat"] = "шматок м'яса кнура",
        ["Chunk of Boar Meat (Provided)"] = "шматок м'яса кнура (видано)",
    },
    [87] = {
        ["Bernice's Necklace"] = "намисто Берніс",
        ["Bernice's Necklace (Provided)"] = "намисто Берніс (видано)",
    },
    [88] = {
        ["Brass Collar"] = "латунний нашийник",
        ["Brass Collar (Provided)"] = "латунний нашийник (видано)",
    },
    [89] = {
        ["Iron Pike"] = "залізна піка",
        ["Iron Pike (Provided)"] = "залізна піка (видано)",
        ["Iron Rivet"] = "залізна заклепка",
        ["Iron Rivet (Provided)"] = "залізна заклепка (видано)",
    },
    [90] = {
        ["Lean Wolf Flank"] = "пісний вовчий бік",
        ["Lean Wolf Flank (Provided)"] = "пісний вовчий бік (видано)",
        ["Stormwind Seasoning Herbs"] = "штормовійська приправа",
        ["Stormwind Seasoning Herbs (Provided)"] = "штормовійська приправа (видано)",
    },
    [91] = {
        ["Shadowhide Pendant"] = "підвіска Тінешкурих",
        ["Shadowhide Pendant (Provided)"] = "підвіска Тінешкурих (видано)",
    },
    [92] = {
        ["Crisp Spider Meat"] = "хрумке павуче м'ясо",
        ["Crisp Spider Meat (Provided)"] = "хрумке павуче м'ясо (видано)",
        ["Great Goretusk Snout"] = "рило великого іклоштрика",
        ["Great Goretusk Snout (Provided)"] = "рило великого іклоштрика (видано)",
        ["Tough Condor Meat"] = "жорстке м'ясо кондора",
        ["Tough Condor Meat (Provided)"] = "жорстке м'ясо кондора (видано)",
    },
    [93] = {
        ["Gooey Spider Leg"] = "липка павуча лапка",
        ["Gooey Spider Leg (Provided)"] = "липка павуча лапка (видано)",
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
        ["Mistmantle Family Ring (Provided)"] = "сімейний перстень Імлокривів (видано)",
    },
    [99] = {
        ["Pyrewood Shackle"] = "кайдани з Поховальних Вогнищ",
        ["Pyrewood Shackle (Provided)"] = "кайдани з Поховальних Вогнищ (видано)",
    },
    [101] = {
        ["Ghoul Fang"] = "ікло гуля",
        ["Ghoul Fang (Provided)"] = "ікло гуля (видано)",
        ["Skeleton Finger"] = "палець скелета",
        ["Skeleton Finger (Provided)"] = "палець скелета (видано)",
        ["Vial of Spider Venom"] = "флакон павучої отрути",
        ["Vial of Spider Venom (Provided)"] = "флакон павучої отрути (видано)",
    },
    [102] = {
        ["Gnoll Paw"] = "лапа гнола",
        ["Gnoll Paw (Provided)"] = "лапа гнола (видано)",
    },
    [103] = {
        ["Flask of Oil"] = "фляга з мастилом",
        ["Flask of Oil (Provided)"] = "фляга з мастилом (видано)",
    },
    [104] = {
        ["Scale of Old Murk-Eye"] = "луска старого Мутноока",
        ["Scale of Old Murk-Eye (Provided)"] = "луска старого Мутноока (видано)",
    },
    [105] = {
        ["Araj's Phylactery Shard"] = "уламок філактерії Аража",
        ["Araj's Phylactery Shard (Provided)"] = "уламок філактерії Аража (видано)",
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
        ["Crystal Kelp Frond (Provided)"] = "стебло кришталевої водорості (видано)",
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
        ["Midnight Orb (Provided)"] = "опівнічна сфера (видано)",
    },
    [116] = {
        ["Bottle of Moonshine"] = "пляшка сивухи",
        ["Bottle of Moonshine (Provided)"] = "пляшка сивухи (видано)",
        ["Cask of Merlot"] = "барильце Мерло",
        ["Cask of Merlot (Provided)"] = "барильце Мерло (видано)",
        ["Keg of Thunderbrew Lager"] = "Кег лагеру Thunderbrew",
        ["Keg of Thunderbrew Lager (Provided)"] = "Кег лагеру Thunderbrew (видано)",
        ["Keg of Thunderbrew Lager slain"] = "Кег лагеру Thunderbrew: убито",
        ["Skin of Sweet Rum"] = "бурдюк солодкого рому",
        ["Skin of Sweet Rum (Provided)"] = "бурдюк солодкого рому (видано)",
    },
    [117] = {
        ["Hops"] = "хміль",
        ["Hops (Provided)"] = "хміль (видано)",
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
        ["Underbelly Whelp Scale (Provided)"] = "підчеревна луска дракончика (видано)",
    },
    [123] = {
        ["The Collector's Schedule"] = "розклад Збирача",
        ["The Collector's Schedule (Provided)"] = "розклад Збирача (видано)",
    },
    [124] = {
        ["Redridge Brute"] = "багрянокряжовий моцак",
        ["Redridge Brute slain"] = "багрянокряжовий моцак: убито",
        ["Redridge Mystic"] = "багрянокряжовий містик",
        ["Redridge Mystic slain"] = "багрянокряжовий містик: убито",
    },
    [125] = {
        ["Oslow's Toolbox"] = "інструменти Ослоу",
        ["Oslow's Toolbox (Provided)"] = "інструменти Ослоу (видано)",
    },
    [126] = {
        ["Yowler's Paw"] = "лапа Скавчала",
        ["Yowler's Paw (Provided)"] = "лапа Скавчала (видано)",
    },
    [127] = {
        ["Spotted Sunfish"] = "плямиста сонцериба",
        ["Spotted Sunfish (Provided)"] = "плямиста сонцериба (видано)",
    },
    [128] = {
        ["Blackrock Champion"] = "чемпіон Чорнокаменю",
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
        ["Ghoul Rib (Provided)"] = "ребро гуля (видано)",
    },
    [134] = {
        ["Abercrombie's Crate"] = "ящик Абекромбі",
        ["Abercrombie's Crate (Provided)"] = "ящик Абекромбі (видано)",
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
        ["A Mysterious Message (Provided)"] = "таємниче повідомлення (видано)",
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
        ["The Collector's Ring (Provided)"] = "перстень Збирача (видано)",
    },
    [149] = {
        ["Spectral Comb"] = "примарний гребінець",
        ["Spectral Comb (Provided)"] = "примарний гребінець (видано)",
    },
    [150] = {
        ["Murloc Fin"] = "плавець мурлока",
        ["Murloc Fin (Provided)"] = "плавець мурлока (видано)",
    },
    [151] = {
        ["Handful of Oats"] = "жменя вівса",
        ["Handful of Oats (Provided)"] = "жменя вівса (видано)",
    },
    [152] = {
        ["Murloc Coastrunner"] = "мурлок-берегобігун",
        ["Murloc Coastrunner slain"] = "мурлок-берегобігун: убито",
        ["Murloc Oracle"] = "мурлок-оракул",
        ["Murloc Oracle slain"] = "мурлок-оракул: убито",
        ["Murloc Tidehunter"] = "мурлок-хвилелов",
        ["Murloc Tidehunter slain"] = "мурлок-хвилелов: убито",
        ["Murloc Warrior"] = "мурлок-воїн",
        ["Murloc Warrior slain"] = "мурлок-воїн: убито",
    },
    [153] = {
        ["Red Leather Bandana"] = "червона шкіряна бандана",
        ["Red Leather Bandana (Provided)"] = "червона шкіряна бандана (видано)",
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
        ["Rot Blossom (Provided)"] = "гнилоцвіт (видано)",
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
        ["Head of VanCleef (Provided)"] = "голова Ван-Кліфа (видано)",
    },
    [167] = {
        ["Thistlenettle's Badge"] = "значок Лютополоха",
        ["Thistlenettle's Badge (Provided)"] = "значок Лютополоха (видано)",
    },
    [168] = {
        ["Miners' Union Card"] = "картка спілки шахтарів",
        ["Miners' Union Card (Provided)"] = "картка спілки шахтарів (видано)",
    },
    [169] = {
        ["Head of Gath'Ilzogg"] = "голова Ґат'Ільзоґґа",
        ["Head of Gath'Ilzogg (Provided)"] = "голова Ґат'Ільзоґґа (видано)",
    },
    [170] = {
        ["Burly Rockjaw Trogg"] = "кремезний кам'янощелепий трог",
        ["Burly Rockjaw Trogg slain"] = "кремезний кам'янощелепий трог: убито",
        ["Rockjaw Trogg"] = "кам'янощелепий трог",
        ["Rockjaw Trogg slain"] = "кам'янощелепий трог: убито",
    },
    [171] = {
        ["Human Orphan Whistle"] = "свисток сироти",
        ["Human Orphan Whistle (Provided)"] = "свисток сироти (видано)",
    },
    [172] = {
        ["Orcish Orphan Whistle"] = "свисток орка-сироти",
    },
    [173] = {
        ["Nightbane Shadow Weaver"] = "тіньовий ткач Ночегибелі",
        ["Nightbane Shadow Weaver slain"] = "тіньовий ткач Ночегибелі: убито",
    },
    [174] = {
        ["Bronze Tube"] = "бронзова трубка",
        ["Bronze Tube (Provided)"] = "бронзова трубка (видано)",
    },
    [176] = {
        ["Huge Gnoll Claw"] = "величезна лапа гнола",
        ["Huge Gnoll Claw (Provided)"] = "величезна лапа гнола (видано)",
    },
    [177] = {
        ["Mary's Looking Glass"] = "дзеркальце Мері",
        ["Mary's Looking Glass (Provided)"] = "дзеркальце Мері (видано)",
    },
    [178] = {
        ["Faded Shadowhide Pendant"] = "тьмяна підвіска Тінешкурих",
        ["Faded Shadowhide Pendant (Provided)"] = "тьмяна підвіска Тінешкурих (видано)",
    },
    [179] = {
        ["Tough Wolf Meat"] = "жорстке вовче м'ясо",
        ["Tough Wolf Meat (Provided)"] = "жорстке вовче м'ясо (видано)",
    },
    [180] = {
        ["Fangore's Paw"] = "лапа Тельбухожбура",
        ["Fangore's Paw (Provided)"] = "лапа Тельбухожбура (видано)",
    },
    [181] = {
        ["Ogre's Monocle"] = "монокль огра",
        ["Ogre's Monocle (Provided)"] = "монокль огра (видано)",
    },
    [182] = {
        ["Frostmane Troll Whelp"] = "морозогривий молодий троль",
        ["Frostmane Troll Whelp slain"] = "морозогривий молодий троль: убито",
    },
    [183] = {
        ["Small Crag Boar"] = "малий скельний кнур",
        ["Small Crag Boar slain"] = "малий скельний кнур: убито",
    },
    [184] = {
        ["Furlbrow's Deed"] = "документ Хмуроброва",
        ["Furlbrow's Deed (Provided)"] = "документ Хмуроброва (видано)",
    },
    [185] = {
        ["Young Stranglethorn Tiger"] = "молодий тернистодільний тигр",
        ["Young Stranglethorn Tiger slain"] = "молодий тернистодільний тигр: убито",
    },
    [186] = {
        ["Stranglethorn Tiger"] = "тернистодільний тигр",
        ["Stranglethorn Tiger slain"] = "тернистодільний тигр: убито",
    },
    [187] = {
        ["Elder Stranglethorn Tiger"] = "старий тернистодільний тигр",
        ["Elder Stranglethorn Tiger slain"] = "старий тернистодільний тигр: убито",
    },
    [188] = {
        ["Paw of Sin'Dall"] = "лапа Сін'Далла",
        ["Paw of Sin'Dall (Provided)"] = "лапа Сін'Далла (видано)",
    },
    [189] = {
        ["Bloodscalp Ear"] = "вухо Кровоскальпого",
        ["Bloodscalp Ear (Provided)"] = "вухо Кровоскальпого (видано)",
    },
    [190] = {
        ["Young Panther"] = "молода пантера",
        ["Young Panther slain"] = "молода пантера: убито",
    },
    [191] = {
        ["Panther"] = "пантера",
        ["Panther slain"] = "пантера: убито",
    },
    [192] = {
        ["Shadowmaw Panther"] = "тінепаща пантера",
        ["Shadowmaw Panther slain"] = "тінепаща пантера: убито",
    },
    [193] = {
        ["Fang of Bhag'thera"] = "ікло Баґ'тіри",
        ["Fang of Bhag'thera (Provided)"] = "ікло Баґ'тіри (видано)",
    },
    [194] = {
        ["Stranglethorn Raptor"] = "тернистодільний раптор",
        ["Stranglethorn Raptor slain"] = "тернистодільний раптор: убито",
    },
    [195] = {
        ["Lashtail Raptor"] = "хлястохвостий раптор",
        ["Lashtail Raptor slain"] = "хлястохвостий раптор: убито",
    },
    [196] = {
        ["Jungle Stalker"] = "ловець джунглів",
        ["Jungle Stalker slain"] = "ловець джунглів: убито",
    },
    [197] = {
        ["Talon of Tethis"] = "кіготь Тетіса",
        ["Talon of Tethis (Provided)"] = "кіготь Тетіса (видано)",
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
        ["Kurzen Elite"] = "елітний боєць Курцена",
        ["Kurzen Elite slain"] = "елітний боєць Курцена: убито",
        ["Kurzen Subchief"] = "заступник Курцена",
        ["Kurzen Subchief slain"] = "заступник Курцена: убито",
        ["Kurzen's Head"] = "голова Курцена",
        ["Kurzen's Head (Provided)"] = "голова Курцена (видано)",
    },
    [203] = {
        ["Kurzen Jungle Fighter"] = "лісовий боєць Курцена",
        ["Kurzen Jungle Fighter slain"] = "лісовий боєць Курцена: убито",
    },
    [204] = {
        ["Jungle Remedy"] = "зілля з джунглів",
        ["Jungle Remedy (Provided)"] = "зілля з джунглів (видано)",
        ["Venom Fern Extract"] = "екстракт отруйної папороті",
        ["Venom Fern Extract (Provided)"] = "екстракт отруйної папороті (видано)",
    },
    [205] = {
        ["Skullsplitter Fetish"] = "фетиш Черепотрощителів",
        ["Skullsplitter Fetish (Provided)"] = "фетиш Черепотрощителів (видано)",
    },
    [206] = {
        ["Mind's Eye"] = "Око Розуму",
        ["Mind's Eye (Provided)"] = "Око Розуму (видано)",
    },
    [207] = {
        ["The First Troll Legend"] = "перша легенда тролів",
        ["The First Troll Legend (Provided)"] = "перша легенда тролів (видано)",
        ["The Fourth Troll Legend"] = "четверта легенда тролів",
        ["The Fourth Troll Legend (Provided)"] = "четверта легенда тролів (видано)",
        ["The Second Troll Legend"] = "друга легенда тролів",
        ["The Second Troll Legend (Provided)"] = "друга легенда тролів (видано)",
        ["The Third Troll Legend"] = "третя легенда тролів",
        ["The Third Troll Legend (Provided)"] = "третя легенда тролів (видано)",
    },
    [208] = {
        ["Head of Bangalash"] = "голова Банґалаша",
        ["Head of Bangalash (Provided)"] = "голова Банґалаша (видано)",
    },
    [209] = {
        ["Skullsplitter Tusk"] = "ікло Черепотрощителя",
        ["Skullsplitter Tusk (Provided)"] = "ікло Черепотрощителя (видано)",
    },
    [210] = {
        ["Krazek's Crock Pot"] = "зламаний горщик Кронжека",
        ["Krazek's Crock Pot (Provided)"] = "зламаний горщик Кронжека (видано)",
    },
    [211] = {
        ["Araj's Phylactery Shard"] = "уламок філактерії Аража",
        ["Araj's Phylactery Shard (Provided)"] = "уламок філактерії Аража (видано)",
    },
    [212] = {
        ["Chilled Basilisk Haunch"] = "охолоджена гомілка василіска",
        ["Chilled Basilisk Haunch (Provided)"] = "охолоджена гомілка василіска (видано)",
    },
    [213] = {
        ["Tumbled Crystal"] = "галтований кристал",
        ["Tumbled Crystal (Provided)"] = "галтований кристал (видано)",
    },
    [214] = {
        ["Red Silk Bandana"] = "червона шовкова бандана",
        ["Red Silk Bandana (Provided)"] = "червона шовкова бандана (видано)",
    },
    [216] = {
        ["Thistlefur Avenger"] = "колючохутрий месник",
        ["Thistlefur Avenger slain"] = "колючохутрий месник: убито",
        ["Thistlefur Shaman"] = "колючохутрий шаман",
        ["Thistlefur Shaman slain"] = "колючохутрий шаман: убито",
    },
    [217] = {
        ["Brawler"] = "Булдига",
        ["Brawler slain"] = "Булдига: убито",
        ["Gnasher"] = "Скрегатель",
        ["Gnasher slain"] = "Скрегатель: убито",
        ["Grawmug"] = "Ґромаґ",
        ["Grawmug slain"] = "Ґромаґ: убито",
    },
    [218] = {
        ["Grelin Whitebeard's Journal"] = "щоденник Ґреліна Білоборода",
        ["Grelin Whitebeard's Journal (Provided)"] = "щоденник Ґреліна Білоборода (видано)",
    },
    [219] = {
        ["Escort Corporal Keeshan back to Redridge"] = "Супроводіть капрала Кішана до Багрянокряжжя",
    },
    [220] = {
        ["Vial of Purest Water"] = "фіал найчистішої води",
        ["Vial of Purest Water (Provided)"] = "фіал найчистішої води (видано)",
    },
    [221] = {
        ["Nightbane Dark Runner"] = "темний вісник Ночегибелі",
        ["Nightbane Dark Runner slain"] = "темний вісник Ночегибелі: убито",
    },
    [222] = {
        ["Nightbane Tainted One"] = "плюгавець Ночегибелі",
        ["Nightbane Tainted One slain"] = "плюгавець Ночегибелі: убито",
        ["Nightbane Vile Fang"] = "злобне ікло Ночегибелі",
        ["Nightbane Vile Fang slain"] = "злобне ікло Ночегибелі: убито",
    },
    [223] = {
        ["Calor's Note"] = "записка Калора",
        ["Calor's Note (Provided)"] = "записка Калора (видано)",
    },
    [224] = {
        ["Stonesplinter Scout"] = "розвідник Каменедробів",
        ["Stonesplinter Scout slain"] = "розвідник Каменедробів: убито",
        ["Stonesplinter Trogg"] = "трог Каменедробів",
        ["Stonesplinter Trogg slain"] = "трог Каменедробів: убито",
    },
    [226] = {
        ["Rabid Dire Wolf"] = "скажений зловісний вовк",
        ["Rabid Dire Wolf slain"] = "скажений зловісний вовк: убито",
        ["Starving Dire Wolf"] = "голодний зловісний вовк",
        ["Starving Dire Wolf slain"] = "голодний зловісний вовк: убито",
    },
    [228] = {
        ["Mor'Ladim's Skull"] = "череп Мор'Ладіма",
        ["Mor'Ladim's Skull (Provided)"] = "череп Мор'Ладіма (видано)",
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
        ["Stonesplinter Seer"] = "провидець Каменедробів",
        ["Stonesplinter Seer slain"] = "провидець Каменедробів: убито",
        ["Stonesplinter Skullthumper"] = "череполом Каменедробів",
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
        ["Pygmy Venom Web Spider"] = "карликовий отруйний колопряд",
        ["Pygmy Venom Web Spider slain"] = "карликовий отруйний колопряд: убито",
    },
    [246] = {
        ["Redridge Mongrel"] = "багрянокряжова дворняга",
        ["Redridge Mongrel slain"] = "багрянокряжова дворняга: убито",
        ["Redridge Poacher"] = "багрянокряжовий браконьєр",
        ["Redridge Poacher slain"] = "багрянокряжовий браконьєр: убито",
    },
    [248] = {
        ["Glyph of Azora"] = "гліф Азори",
        ["Glyph of Azora (Provided)"] = "гліф Азори (видано)",
    },
    [249] = {
        ["Pendant of Shadow"] = "кулон тіні",
        ["Pendant of Shadow (Provided)"] = "кулон тіні (видано)",
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
        ["The Embalmer's Heart (Provided)"] = "серце Бальзамувальника (видано)",
    },
    [255] = {
        ["Mo'grosh Brute"] = "моцак Мо'ґрош",
        ["Mo'grosh Brute slain"] = "моцак Мо'ґрош: убито",
        ["Mo'grosh Enforcer"] = "громило Мо'ґрош",
        ["Mo'grosh Enforcer slain"] = "громило Мо'ґрош: убито",
        ["Mo'grosh Ogre"] = "огр Мо'ґрош",
        ["Mo'grosh Ogre slain"] = "огр Мо'ґрош: убито",
    },
    [256] = {
        ["Chok'sul's Head"] = "голова Чок'сула",
        ["Chok'sul's Head (Provided)"] = "голова Чок'сула (видано)",
    },
    [257] = {
        ["Mountain Buzzard"] = "гірський канюк",
        ["Mountain Buzzard slain"] = "гірський канюк: убито",
    },
    [258] = {
        ["Elder Mountain Boar"] = "старий гірський кнур",
        ["Elder Mountain Boar slain"] = "старий гірський кнур: убито",
    },
    [261] = {
        ["Undead Ravager"] = "невмерлий спустошник",
        ["Undead Ravager slain"] = "невмерлий спустошник: убито",
    },
    [262] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [263] = {
        ["Stonesplinter Bonesnapper"] = "кісткохруст Каменедробів",
        ["Stonesplinter Bonesnapper slain"] = "кісткохруст Каменедробів: убито",
        ["Stonesplinter Shaman"] = "шаман Каменедробів",
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
        ["Trogg Stone Tooth (Provided)"] = "кам'яний зуб трога (видано)",
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
        ["Ol' Sooty's Head (Provided)"] = "голова старого Чорниша (видано)",
    },
    [272] = {
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
        ["Pendant of the Sea Lion (Provided)"] = "підвіска Морського Лева (видано)",
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
        ["Fen Creeper"] = "драговинний плазун",
        ["Fen Creeper slain"] = "драговинний плазун: убито",
    },
    [276] = {
        ["Mosshide Gnoll"] = "мохошкурий гнол",
        ["Mosshide Gnoll slain"] = "мохошкурий гнол: убито",
        ["Mosshide Mongrel"] = "мохошкура дворняга",
        ["Mosshide Mongrel slain"] = "мохошкура дворняга: убито",
    },
    [277] = {
        ["Crude Flint"] = "грубий кремінь",
        ["Crude Flint (Provided)"] = "грубий кремінь (видано)",
    },
    [278] = {
        ["Crocolisk Tear"] = "сльоза кроколіска",
        ["Crocolisk Tear (Provided)"] = "сльоза кроколіска (видано)",
        ["Lurker Venom"] = "павуча отрута",
        ["Lurker Venom (Provided)"] = "павуча отрута (видано)",
        ["Mo'grosh Crystal"] = "кристал Мо'ґрош",
        ["Mo'grosh Crystal (Provided)"] = "кристал Мо'ґрош (видано)",
    },
    [279] = {
        ["Bluegill Murloc"] = "синьожабрий мурлок",
        ["Bluegill Murloc slain"] = "синьожабрий мурлок: убито",
        ["Gobbler's Head"] = "голова Жеруна",
        ["Gobbler's Head (Provided)"] = "голова Жеруна (видано)",
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
        ["Frostmane Headhunter"] = "морозогривий мисливець за головами",
        ["Frostmane Headhunter slain"] = "морозогривий мисливець за головами: убито",
        ["Fully explore Frostmane Hold"] = "Повністю дослідіть поселення Морозогривих",
    },
    [288] = {
        ["Flagon of Mead"] = "Глегін з медом",
        ["Flagon of Mead (Provided)"] = "Глегін з медом (видано)",
        ["Flagon of Mead slain"] = "Глегін з медом: убито",
    },
    [289] = {
        ["Cursed Marine"] = "проклятий морський піхотинець",
        ["Cursed Marine slain"] = "проклятий морський піхотинець: убито",
        ["Cursed Sailor"] = "проклятий моряк",
        ["Cursed Sailor slain"] = "проклятий моряк: убито",
        ["Snellig's Snuffbox"] = "табакерка Снелліґа",
        ["Snellig's Snuffbox (Provided)"] = "табакерка Снелліґа (видано)",
    },
    [290] = {
        ["Intrepid Strongbox Key"] = "ключ від сейфа на \"Відважному\"",
        ["Intrepid Strongbox Key (Provided)"] = "ключ від сейфа на \"Відважному\" (видано)",
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
        ["Mottled Raptor"] = "строкатий раптор",
        ["Mottled Raptor slain"] = "строкатий раптор: убито",
        ["Mottled Screecher"] = "строкатий верескун",
        ["Mottled Screecher slain"] = "строкатий верескун: убито",
    },
    [295] = {
        ["Mottled Razormaw"] = "строкатий бритвозуб",
        ["Mottled Razormaw slain"] = "строкатий бритвозуб: убито",
        ["Mottled Scytheclaw"] = "строкатий серпопазур",
        ["Mottled Scytheclaw slain"] = "строкатий серпопазур: убито",
    },
    [296] = {
        ["Sarltooth's Talon"] = "пазур Сарлозуба",
        ["Sarltooth's Talon (Provided)"] = "пазур Сарлозуба (видано)",
    },
    [297] = {
        ["Carved Stone Idol"] = "різьблений кам'яний ідол",
        ["Carved Stone Idol (Provided)"] = "різьблений кам'яний ідол (видано)",
    },
    [298] = {
        ["Ironband's Progress Report"] = "звіт Залізоплета",
        ["Ironband's Progress Report (Provided)"] = "звіт Залізоплета (видано)",
    },
    [299] = {
        ["Ados Fragment"] = "фрагмент Адос",
        ["Ados Fragment (Provided)"] = "фрагмент Адос (видано)",
        ["Golm Fragment"] = "фрагмент Ґолм",
        ["Golm Fragment (Provided)"] = "фрагмент Ґолм (видано)",
        ["Modr Fragment"] = "фрагмент Модр",
        ["Modr Fragment (Provided)"] = "фрагмент Модр (видано)",
        ["Neru Fragment"] = "фрагмент Неру",
        ["Neru Fragment (Provided)"] = "фрагмент Неру (видано)",
    },
    [301] = {
        ["Ironband's Progress Report"] = "звіт Залізоплета",
        ["Ironband's Progress Report (Provided)"] = "звіт Залізоплета (видано)",
    },
    [303] = {
        ["Dark Iron Demolitionist"] = "підривник Темного Заліза",
        ["Dark Iron Demolitionist slain"] = "підривник Темного Заліза: убито",
        ["Dark Iron Dwarf"] = "дворф Темного Заліза",
        ["Dark Iron Dwarf slain"] = "дворф Темного Заліза: убито",
        ["Dark Iron Saboteur"] = "диверсант Темного Заліза",
        ["Dark Iron Saboteur slain"] = "диверсант Темного Заліза: убито",
        ["Dark Iron Tunneler"] = "прохідник Темного Заліза",
        ["Dark Iron Tunneler slain"] = "прохідник Темного Заліза: убито",
    },
    [304] = {
        ["Ear of Balgaras"] = "вухо Балґараса",
        ["Ear of Balgaras (Provided)"] = "вухо Балґараса (видано)",
    },
    [306] = {
        ["Merrin's Letter"] = "записка Меррін",
        ["Merrin's Letter (Provided)"] = "записка Меррін (видано)",
    },
    [307] = {
        ["Miners' Gear"] = "шахтарське спорядження",
        ["Miners' Gear (Provided)"] = "шахтарське спорядження (видано)",
    },
    [308] = {
        ["Thunder Ale"] = "громузвар",
        ["Thunder Ale (Provided)"] = "громузвар (видано)",
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
        ["MacGrann's Dried Meats (Provided)"] = "в'ялене м'ясо Мак-Ґранна (видано)",
    },
    [313] = {
        ["Wendigo Mane"] = "грива вендиго",
        ["Wendigo Mane (Provided)"] = "грива вендиго (видано)",
    },
    [314] = {
        ["Fang of Vagash"] = "ікло Ваґаша",
        ["Fang of Vagash (Provided)"] = "ікло Ваґаша (видано)",
    },
    [315] = {
        ["Shimmerweed"] = "блискоквіт",
        ["Shimmerweed (Provided)"] = "блискоквіт (видано)",
    },
    [316] = {
        ["Squirrel Nut"] = "білчаний горіх",
    },
    [317] = {
        ["Chunk of Boar Meat"] = "шматок м'яса кнура",
        ["Chunk of Boar Meat (Provided)"] = "шматок м'яса кнура (видано)",
        ["Thick Bear Fur"] = "товста шкура ведмедя",
        ["Thick Bear Fur (Provided)"] = "товста шкура ведмедя (видано)",
    },
    [319] = {
        ["Elder Crag Boar"] = "старий скельний кнур",
        ["Elder Crag Boar slain"] = "старий скельний кнур: убито",
        ["Ice Claw Bear"] = "льодолапий ведмідь",
        ["Ice Claw Bear slain"] = "льодолапий ведмідь: убито",
        ["Snow Leopard"] = "сніжний леопард",
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
        ["Skeletal Healer"] = "скелетний цілитель",
        ["Skeletal Healer slain"] = "скелетний цілитель: убито",
        ["Skeletal Raider"] = "скелетний нальотник",
        ["Skeletal Raider slain"] = "скелетний нальотник: убито",
        ["Skeletal Warder"] = "скелетний чатовий",
        ["Skeletal Warder slain"] = "скелетний чатовий: убито",
    },
    [324] = {
        ["Lightforge Ingot"] = "злиток світлосталі",
        ["Lightforge Ingot (Provided)"] = "злиток світлосталі (видано)",
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
        ["Musquash Root (Provided)"] = "мускусний корінь (видано)",
        ["Tear of Tilloa"] = "сльоза Тіллої",
        ["Tear of Tilloa (Provided)"] = "сльоза Тіллої (видано)",
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
        ["Green Hills of Stranglethorn - Chapter I (Provided)"] = "Зелені пагорби Тернистої долини — Розділ I (видано)",
        ["Green Hills of Stranglethorn - Chapter II"] = "Зелені пагорби Тернистої долини — Розділ II",
        ["Green Hills of Stranglethorn - Chapter II (Provided)"] = "Зелені пагорби Тернистої долини — Розділ II (видано)",
        ["Green Hills of Stranglethorn - Chapter III"] = "Зелені пагорби Тернистої долини — Розділ III",
        ["Green Hills of Stranglethorn - Chapter III (Provided)"] = "Зелені пагорби Тернистої долини — Розділ III (видано)",
        ["Green Hills of Stranglethorn - Chapter IV"] = "Зелені пагорби Тернистої долини — Розділ IV",
        ["Green Hills of Stranglethorn - Chapter IV (Provided)"] = "Зелені пагорби Тернистої долини — Розділ IV (видано)",
    },
    [339] = {
        ["Green Hills of Stranglethorn - Page 1"] = "Зелені пагорби Тернистої долини — Сторінка 1",
        ["Green Hills of Stranglethorn - Page 1 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 1 (видано)",
        ["Green Hills of Stranglethorn - Page 4"] = "Зелені пагорби Тернистої долини — Сторінка 4",
        ["Green Hills of Stranglethorn - Page 4 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 4 (видано)",
        ["Green Hills of Stranglethorn - Page 6"] = "Зелені пагорби Тернистої долини — Сторінка 6",
        ["Green Hills of Stranglethorn - Page 6 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 6 (видано)",
        ["Green Hills of Stranglethorn - Page 8"] = "Зелені пагорби Тернистої долини — Сторінка 8",
        ["Green Hills of Stranglethorn - Page 8 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 8 (видано)",
    },
    [340] = {
        ["Green Hills of Stranglethorn - Page 10"] = "Зелені пагорби Тернистої долини — Сторінка 10",
        ["Green Hills of Stranglethorn - Page 10 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 10 (видано)",
        ["Green Hills of Stranglethorn - Page 11"] = "Зелені пагорби Тернистої долини — Сторінка 11",
        ["Green Hills of Stranglethorn - Page 11 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 11 (видано)",
        ["Green Hills of Stranglethorn - Page 14"] = "Зелені пагорби Тернистої долини — Сторінка 14",
        ["Green Hills of Stranglethorn - Page 14 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 14 (видано)",
        ["Green Hills of Stranglethorn - Page 16"] = "Зелені пагорби Тернистої долини — Сторінка 16",
        ["Green Hills of Stranglethorn - Page 16 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 16 (видано)",
    },
    [341] = {
        ["Green Hills of Stranglethorn - Page 18"] = "Зелені пагорби Тернистої долини — Сторінка 18",
        ["Green Hills of Stranglethorn - Page 18 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 18 (видано)",
        ["Green Hills of Stranglethorn - Page 20"] = "Зелені пагорби Тернистої долини — Сторінка 20",
        ["Green Hills of Stranglethorn - Page 20 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 20 (видано)",
        ["Green Hills of Stranglethorn - Page 21"] = "Зелені пагорби Тернистої долини — Сторінка 21",
        ["Green Hills of Stranglethorn - Page 21 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 21 (видано)",
        ["Green Hills of Stranglethorn - Page 24"] = "Зелені пагорби Тернистої долини — Сторінка 24",
        ["Green Hills of Stranglethorn - Page 24 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 24 (видано)",
    },
    [342] = {
        ["Green Hills of Stranglethorn - Page 25"] = "Зелені пагорби Тернистої долини — Сторінка 25",
        ["Green Hills of Stranglethorn - Page 25 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 25 (видано)",
        ["Green Hills of Stranglethorn - Page 26"] = "Зелені пагорби Тернистої долини — Сторінка 26",
        ["Green Hills of Stranglethorn - Page 26 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 26 (видано)",
        ["Green Hills of Stranglethorn - Page 27"] = "Зелені пагорби Тернистої долини — Сторінка 27",
        ["Green Hills of Stranglethorn - Page 27 (Provided)"] = "Зелені пагорби Тернистої долини — Сторінка 27 (видано)",
    },
    [346] = {
        ["Book: Stresses of Iron"] = "книга \"Гартування заліза\"",
        ["Book: Stresses of Iron (Provided)"] = "книга \"Гартування заліза\" (видано)",
    },
    [347] = {
        ["Rethban Ore"] = "ретбанська руда",
        ["Rethban Ore (Provided)"] = "ретбанська руда (видано)",
    },
    [348] = {
        ["Heart of Mokk"] = "серце Мокка",
        ["Heart of Mokk (Provided)"] = "серце Мокка (видано)",
    },
    [349] = {
        ["Gorilla Fang"] = "ікло горили",
        ["Gorilla Fang (Provided)"] = "ікло горили (видано)",
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
        ["Gregor's Remains (Provided)"] = "рештки Ґреґора (видано)",
        ["Nissa's Remains"] = "рештки Нісси",
        ["Nissa's Remains (Provided)"] = "рештки Нісси (видано)",
        ["Thurman's Remains"] = "рештки Турмана",
        ["Thurman's Remains (Provided)"] = "рештки Турмана (видано)",
    },
    [356] = {
        ["Bleeding Horror"] = "криваве страховище",
        ["Bleeding Horror slain"] = "криваве страховище: убито",
        ["Wandering Spirit"] = "блукаючий дух",
        ["Wandering Spirit slain"] = "блукаючий дух: убито",
    },
    [357] = {
        ["The Lich's Spellbook"] = "фоліант ліча",
        ["The Lich's Spellbook (Provided)"] = "фоліант ліча (видано)",
    },
    [358] = {
        ["Embalming Ichor"] = "бальзамувальна сукровиця",
        ["Embalming Ichor (Provided)"] = "бальзамувальна сукровиця (видано)",
        ["Rot Hide Graverobber"] = "гнилошкурий розкрадач могил",
        ["Rot Hide Graverobber slain"] = "гнилошкурий розкрадач могил: убито",
        ["Rot Hide Mongrel"] = "гнилошкура дворняга",
        ["Rot Hide Mongrel slain"] = "гнилошкура дворняга: убито",
    },
    [361] = {
        ["Thurman's Letter"] = "лист Турмана",
        ["Thurman's Letter (Provided)"] = "лист Турмана (видано)",
    },
    [362] = {
        ["Devlin's Remains"] = "рештки Девліна",
        ["Devlin's Remains (Provided)"] = "рештки Девліна (видано)",
    },
    [364] = {
        ["Mindless Zombie"] = "безтямний зомбі",
        ["Mindless Zombie slain"] = "безтямний зомбі: убито",
        ["Wretched Zombie"] = "жалюгідний зомбі",
        ["Wretched Zombie slain"] = "жалюгідний зомбі: убито",
    },
    [365] = {
        ["Tirisfal Pumpkin"] = "тірісфальський гарбуз",
        ["Tirisfal Pumpkin (Provided)"] = "тірісфальський гарбуз (видано)",
    },
    [366] = {
        ["Gunther's Spellbook"] = "фоліант Ґюнтера",
        ["Gunther's Spellbook (Provided)"] = "фоліант Ґюнтера (видано)",
    },
    [367] = {
        ["Darkhound Blood"] = "кров темногончої",
        ["Darkhound Blood (Provided)"] = "кров темногончої (видано)",
    },
    [368] = {
        ["Vile Fin Scale"] = "луска Злобного Плавника",
        ["Vile Fin Scale (Provided)"] = "луска Злобного Плавника (видано)",
    },
    [369] = {
        ["Vicious Night Web Spider Venom"] = "отрута злого нічного колопряда",
        ["Vicious Night Web Spider Venom (Provided)"] = "отрута злого нічного колопряда (видано)",
    },
    [370] = {
        ["Captain Perrine"] = "капітан Перрін",
        ["Captain Perrine slain"] = "капітан Перрін: убито",
        ["Scarlet Missionary"] = "місіонер Багряного Походу",
        ["Scarlet Missionary slain"] = "місіонер Багряного Походу: убито",
        ["Scarlet Zealot"] = "ревнитель Багряного Походу",
        ["Scarlet Zealot slain"] = "ревнитель Багряного Походу: убито",
    },
    [371] = {
        ["Captain Vachon"] = "капітан Вачон",
        ["Captain Vachon slain"] = "капітан Вачон: убито",
        ["Scarlet Friar"] = "ченець Багряного Походу",
        ["Scarlet Friar slain"] = "ченець Багряного Походу: убито",
    },
    [372] = {
        ["Captain Melrache"] = "капітан Мелрач",
        ["Captain Melrache slain"] = "капітан Мелрач: убито",
        ["Scarlet Bodyguard"] = "тілоохоронець Багряного Походу",
        ["Scarlet Bodyguard slain"] = "тілоохоронець Багряного Походу: убито",
    },
    [373] = {
        ["An Unsent Letter"] = "ненадісланий лист",
        ["An Unsent Letter (Provided)"] = "ненадісланий лист (видано)",
    },
    [374] = {
        ["Scarlet Insignia Ring"] = "перстень-відзнака Багряного Походу",
        ["Scarlet Insignia Ring (Provided)"] = "перстень-відзнака Багряного Походу (видано)",
    },
    [375] = {
        ["Coarse Thread"] = "груба нитка",
        ["Coarse Thread (Provided)"] = "груба нитка (видано)",
        ["Duskbat Pelt"] = "шкура сутінкового кажана",
        ["Duskbat Pelt (Provided)"] = "шкура сутінкового кажана (видано)",
    },
    [376] = {
        ["Duskbat Wing"] = "крило сутінкового кажана",
        ["Duskbat Wing (Provided)"] = "крило сутінкового кажана (видано)",
        ["Scavenger Paw"] = "лапа падальника",
        ["Scavenger Paw (Provided)"] = "лапа падальника (видано)",
    },
    [377] = {
        ["Hand of Dextren Ward"] = "рука Декстрена Ворда",
        ["Hand of Dextren Ward (Provided)"] = "рука Декстрена Ворда (видано)",
    },
    [378] = {
        ["Head of Deepfury"] = "голова Темнолюта",
        ["Head of Deepfury (Provided)"] = "голова Темнолюта (видано)",
    },
    [379] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
        ["Wastewander Water Pouch (Provided)"] = "бурдюк з водою Пустелебродів (видано)",
    },
    [380] = {
        ["Night Web Spider"] = "нічний колопряд",
        ["Night Web Spider slain"] = "нічний колопряд: убито",
        ["Young Night Web Spider"] = "молодий нічний колопряд",
        ["Young Night Web Spider slain"] = "молодий нічний колопряд: убито",
    },
    [381] = {
        ["Scarlet Armband"] = "багряна пов'язка",
        ["Scarlet Armband (Provided)"] = "багряна пов'язка (видано)",
    },
    [382] = {
        ["Scarlet Crusade Documents"] = "документи Багряного Походу",
        ["Scarlet Crusade Documents (Provided)"] = "документи Багряного Походу (видано)",
    },
    [383] = {
        ["Scarlet Crusade Documents"] = "документи Багряного Походу",
        ["Scarlet Crusade Documents (Provided)"] = "документи Багряного Походу (видано)",
    },
    [384] = {
        ["Crag Boar Rib"] = "ребро скельного кнура",
        ["Crag Boar Rib (Provided)"] = "ребро скельного кнура (видано)",
        ["Rhapsody Malt"] = "солод Рапсодія",
        ["Rhapsody Malt (Provided)"] = "солод Рапсодія (видано)",
    },
    [385] = {
        ["Crocolisk Meat"] = "м'ясо кроколіска",
        ["Crocolisk Meat (Provided)"] = "м'ясо кроколіска (видано)",
        ["Crocolisk Skin"] = "шкура кроколіска",
        ["Crocolisk Skin (Provided)"] = "шкура кроколіска (видано)",
    },
    [386] = {
        ["Head of Targorr"] = "голова Тарґорра",
        ["Head of Targorr (Provided)"] = "голова Тарґорра (видано)",
    },
    [387] = {
        ["Defias Convict"] = "каторжник Непокірних",
        ["Defias Convict slain"] = "каторжник Непокірних: убито",
        ["Defias Insurgent"] = "заколотник Непокірних",
        ["Defias Insurgent slain"] = "заколотник Непокірних: убито",
        ["Defias Prisoner"] = "в'язень Непокірних",
        ["Defias Prisoner slain"] = "в'язень Непокірних: убито",
    },
    [388] = {
        ["Red Wool Bandana"] = "червона вовняна бандана",
        ["Red Wool Bandana (Provided)"] = "червона вовняна бандана (видано)",
    },
    [391] = {
        ["Head of Bazil Thredd"] = "голова Базіла Тредда",
        ["Head of Bazil Thredd (Provided)"] = "голова Базіла Тредда (видано)",
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
    },
    [398] = {
        ["Maggot Eye's Paw"] = "лапа Червивого Ока",
        ["Maggot Eye's Paw (Provided)"] = "лапа Червивого Ока (видано)",
    },
    [399] = {
        ["A Simple Compass"] = "звичайний компас",
        ["A Simple Compass (Provided)"] = "звичайний компас (видано)",
    },
    [400] = {
        ["Steelgrill's Tools"] = "інструменти Сталешквара",
        ["Steelgrill's Tools (Provided)"] = "інструменти Сталешквара (видано)",
    },
    [404] = {
        ["Putrid Claw"] = "смердючий пазур",
        ["Putrid Claw (Provided)"] = "смердючий пазур (видано)",
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
        ["Dargol's Skull (Provided)"] = "череп Дарґола (видано)",
        ["Rotting Ancestor"] = "гниючий предок",
        ["Rotting Ancestor slain"] = "гниючий предок: убито",
        ["Wailing Ancestor"] = "тужливий предок",
        ["Wailing Ancestor slain"] = "тужливий предок: убито",
    },
    [409] = {
        ["Lillith Nefara"] = "Лілліт Нефара",
        ["Lillith Nefara slain"] = "Лілліт Нефара: убито",
    },
    [410] = {
        ["Candle of Beckoning"] = "свічка поклику",
        ["Candle of Beckoning (Provided)"] = "свічка поклику (видано)",
    },
    [411] = {
        ["Nether Gem"] = "самоцвіт Підсвіття",
        ["Nether Gem (Provided)"] = "самоцвіт Підсвіття (видано)",
    },
    [412] = {
        ["Gyromechanic Gear"] = "гіромеханічна шестірня",
        ["Gyromechanic Gear (Provided)"] = "гіромеханічна шестірня (видано)",
        ["Restabilization Cog"] = "зубець рестабілізації",
        ["Restabilization Cog (Provided)"] = "зубець рестабілізації (видано)",
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
        ["Tunnel Rat Ear (Provided)"] = "вухо тунельного щура (видано)",
    },
    [417] = {
        ["Hildelve's Journal"] = "щоденник Гілдельва",
        ["Hildelve's Journal (Provided)"] = "щоденник Гілдельва (видано)",
        ["Mangy Claw"] = "зчесаний кіготь",
        ["Mangy Claw (Provided)"] = "зчесаний кіготь (видано)",
    },
    [418] = {
        ["Bear Meat"] = "м'ясо ведмедя",
        ["Bear Meat (Provided)"] = "м'ясо ведмедя (видано)",
        ["Boar Intestines"] = "кишки кнура",
        ["Boar Intestines (Provided)"] = "кишки кнура (видано)",
        ["Spider Ichor"] = "лімфа павука",
        ["Spider Ichor (Provided)"] = "лімфа павука (видано)",
    },
    [420] = {
        ["Grelin's Report"] = "звіт Ґреліна",
        ["Grelin's Report (Provided)"] = "звіт Ґреліна (видано)",
    },
    [421] = {
        ["Moonrage Whitescalp"] = "білоскальп Місяцесказу",
        ["Moonrage Whitescalp slain"] = "білоскальп Місяцесказу: убито",
    },
    [422] = {
        ["Remedy of Arugal"] = "\"Засіб Аруґала\"",
        ["Remedy of Arugal (Provided)"] = "\"Засіб Аруґала\" (видано)",
    },
    [423] = {
        ["Darksoul Shackle"] = "кайдани темнодуха",
        ["Darksoul Shackle (Provided)"] = "кайдани темнодуха (видано)",
        ["Glutton Shackle"] = "кайдани ненажери",
        ["Glutton Shackle (Provided)"] = "кайдани ненажери (видано)",
    },
    [424] = {
        ["Head of Grimson"] = "голова Ґрімсона",
        ["Head of Grimson (Provided)"] = "голова Ґрімсона (видано)",
    },
    [425] = {
        ["Ivar's Head"] = "голова Айвара",
        ["Ivar's Head (Provided)"] = "голова Айвара (видано)",
    },
    [426] = {
        ["Blackened Skull"] = "почорнілий череп",
        ["Blackened Skull (Provided)"] = "почорнілий череп (видано)",
        ["Notched Rib"] = "надщерблене ребро",
        ["Notched Rib (Provided)"] = "надщерблене ребро (видано)",
    },
    [427] = {
        ["Scarlet Warrior"] = "воїн Багряного Походу",
        ["Scarlet Warrior slain"] = "воїн Багряного Походу: убито",
    },
    [429] = {
        ["Discolored Worg Heart"] = "знебарвлене серце ворга",
        ["Discolored Worg Heart (Provided)"] = "знебарвлене серце ворга (видано)",
    },
    [430] = {
        ["Quinn's Potion"] = "Квіннове зілля",
        ["Quinn's Potion (Provided)"] = "Квіннове зілля (видано)",
    },
    [432] = {
        ["Rockjaw Skullthumper"] = "кам'янощелепий череполом",
        ["Rockjaw Skullthumper slain"] = "кам'янощелепий череполом: убито",
    },
    [433] = {
        ["Rockjaw Bonesnapper"] = "кам'янощелепий кісткохруст",
        ["Rockjaw Bonesnapper slain"] = "кам'янощелепий кісткохруст: убито",
    },
    [434] = {
        ["Lord Gregor Lescovar"] = "Лорд Грегор Лесковар",
        ["Lord Gregor Lescovar (Provided)"] = "Лорд Грегор Лесковар (видано)",
        ["Lord Gregor Lescovar slain"] = "лорд Грегор Лесковар: убито",
        ["Marzon the Silent Blade"] = "Марзон Тихе Лезо",
        ["Marzon the Silent Blade slain"] = "Марзон Тихе Лезо: убито",
    },
    [435] = {
        ["Erland must reach Rane Yorick"] = "Ерланд має дістатися Рейни Йорік",
    },
    [437] = {
        ["Essence of Nightlash"] = "сутність Нічнохльостки",
        ["Essence of Nightlash (Provided)"] = "сутність Нічнохльостки (видано)",
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
        ["Thule's Head (Provided)"] = "голова Тула (видано)",
    },
    [443] = {
        ["Rot Hide Ichor"] = "пасока Гнилошкурих",
        ["Rot Hide Ichor (Provided)"] = "пасока Гнилошкурих (видано)",
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
        ["Grizzled Bear Heart (Provided)"] = "серце посивілого ведмедя (видано)",
        ["Skittering Blood"] = "дріботлива кров",
        ["Skittering Blood (Provided)"] = "дріботлива кров (видано)",
    },
    [449] = {
        ["Deathstalker Report"] = "звіт смертоловів",
        ["Deathstalker Report (Provided)"] = "звіт смертоловів (видано)",
    },
    [450] = {
        ["Berard's Journal"] = "щоденник Берарда",
        ["Berard's Journal (Provided)"] = "щоденник Берарда (видано)",
    },
    [451] = {
        ["Hardened Tumor"] = "затверділа пухлина",
        ["Hardened Tumor (Provided)"] = "затверділа пухлина (видано)",
        ["Lake Creeper Moss"] = "мох озерного підкрадача",
        ["Lake Creeper Moss (Provided)"] = "мох озерного підкрадача (видано)",
        ["Lake Skulker Moss"] = "мох озерного тайноходця",
        ["Lake Skulker Moss (Provided)"] = "мох озерного тайноходця (видано)",
    },
    [452] = {
        ["Aid Faerleia in killing the Pyrewood Council"] = "Допоможіть Фарлеї вбити раду Поховальних Вогнищ",
    },
    [453] = {
        ["Book from Sven's Farm"] = "книга з ферми Свена",
        ["Book from Sven's Farm (Provided)"] = "книга з ферми Свена (видано)",
    },
    [455] = {
        ["Dragonmaw Grunt"] = "бугай Драконової Пащі",
        ["Dragonmaw Grunt slain"] = "бугай Драконової Пащі: убито",
        ["Dragonmaw Scout"] = "розвідник Драконової Пащі",
        ["Dragonmaw Scout slain"] = "розвідник Драконової Пащі: убито",
    },
    [456] = {
        ["Young Nightsaber"] = "молодий ночезуб",
        ["Young Nightsaber slain"] = "молодий ночезуб: убито",
        ["Young Thistle Boar"] = "молодий татарний кнур",
        ["Young Thistle Boar slain"] = "молодий татарний кнур: убито",
    },
    [457] = {
        ["Mangy Nightsaber"] = "коростяний ночезуб",
        ["Mangy Nightsaber slain"] = "коростяний ночезуб: убито",
        ["Thistle Boar"] = "татарний кнур",
        ["Thistle Boar slain"] = "татарний кнур: убито",
    },
    [459] = {
        ["Fel Moss"] = "мох скверни",
        ["Fel Moss (Provided)"] = "мох скверни (видано)",
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
        ["Dragonmaw War Banner (Provided)"] = "бойове знамено Драконової Пащі (видано)",
    },
    [465] = {
        ["Dwarven Tinder"] = "дворфійський трут",
        ["Dwarven Tinder (Provided)"] = "дворфійський трут (видано)",
    },
    [466] = {
        ["Incendicite Ore"] = "спалахітова руда",
        ["Incendicite Ore (Provided)"] = "спалахітова руда (видано)",
    },
    [469] = {
        ["Bundle of Crocolisk Skins"] = "оберемок кроколіскових шкір",
        ["Bundle of Crocolisk Skins (Provided)"] = "оберемок кроколіскових шкір (видано)",
    },
    [470] = {
        ["Sida's Bag"] = "сумка Сіди",
        ["Sida's Bag (Provided)"] = "сумка Сіди (видано)",
    },
    [471] = {
        ["Giant Crocolisk Skin"] = "шкура гігантського кроколіска",
        ["Giant Crocolisk Skin (Provided)"] = "шкура гігантського кроколіска (видано)",
    },
    [474] = {
        ["Nek'rosh's Head"] = "голова Нек'роша",
        ["Nek'rosh's Head (Provided)"] = "голова Нек'роша (видано)",
    },
    [478] = {
        ["Rune-inscribed Pendant"] = "покритий рунами кулон",
        ["Rune-inscribed Pendant (Provided)"] = "покритий рунами кулон (видано)",
    },
    [479] = {
        ["Dalaran Pendant"] = "даларанський кулон",
        ["Dalaran Pendant (Provided)"] = "даларанський кулон (видано)",
    },
    [480] = {
        ["Ataeric's Staff"] = "посох Атеріка",
        ["Ataeric's Staff (Provided)"] = "посох Атеріка (видано)",
    },
    [481] = {
        ["Rune-inscribed Pendant"] = "покритий рунами кулон",
        ["Rune-inscribed Pendant (Provided)"] = "покритий рунами кулон (видано)",
    },
    [483] = {
        ["Black Feather Quill"] = "чорне перо",
        ["Black Feather Quill (Provided)"] = "чорне перо (видано)",
        ["Raven Claw Talisman"] = "талісман Воронячого Пазура",
        ["Raven Claw Talisman (Provided)"] = "талісман Воронячого Пазура (видано)",
        ["Rune of Nesting"] = "руна Гніздування",
        ["Rune of Nesting (Provided)"] = "руна Гніздування (видано)",
        ["Sapphire of Sky"] = "сапфір небес",
        ["Sapphire of Sky (Provided)"] = "сапфір небес (видано)",
    },
    [484] = {
        ["Young Crocolisk Skin"] = "шкура молодого кроколіска",
        ["Young Crocolisk Skin (Provided)"] = "шкура молодого кроколіска (видано)",
    },
    [485] = {
        ["OOX-09/HL Distress Beacon"] = "аварійний маяк OOX-09/ВЗ",
        ["OOX-09/HL Distress Beacon (Provided)"] = "аварійний маяк OOX-09/ВЗ (видано)",
    },
    [486] = {
        ["Ursal the Mauler"] = "Урсал Молотобій",
        ["Ursal the Mauler slain"] = "Урсал Молотобій: убито",
    },
    [487] = {
        ["Gnarlpine Ambusher"] = "душитель Кривої Сосни",
        ["Gnarlpine Ambusher slain"] = "душитель Кривої Сосни: убито",
    },
    [488] = {
        ["Nightsaber Fang"] = "ікло ночезуба",
        ["Nightsaber Fang (Provided)"] = "ікло ночезуба (видано)",
        ["Strigid Owl Feather"] = "пір'їна сови",
        ["Strigid Owl Feather (Provided)"] = "пір'їна сови (видано)",
        ["Webwood Spider Silk"] = "павутиннолісий шовк",
        ["Webwood Spider Silk (Provided)"] = "павутиннолісий шовк (видано)",
    },
    [489] = {
        ["Fel Cone"] = "осквернена шишка",
        ["Fel Cone (Provided)"] = "осквернена шишка (видано)",
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
        ["Creeper Ichor (Provided)"] = "пасока підкрадача (видано)",
        ["Gray Bear Tongue"] = "язик сірого ведмедя",
        ["Gray Bear Tongue (Provided)"] = "язик сірого ведмедя (видано)",
    },
    [498] = {
        ["Rescue Drull"] = "Звільніть Друлла",
        ["Rescue Tog'thar"] = "Звільніть Тоґ'тара",
    },
    [499] = {
        ["Elixir of Suffering"] = "еліксир страждання",
        ["Elixir of Suffering (Provided)"] = "еліксир страждання (видано)",
    },
    [500] = {
        ["Dirty Knucklebones"] = "брудні паці",
        ["Dirty Knucklebones (Provided)"] = "брудні паці (видано)",
    },
    [501] = {
        ["Mountain Lion Blood"] = "кров гірського лева",
        ["Mountain Lion Blood (Provided)"] = "кров гірського лева (видано)",
    },
    [502] = {
        ["Elixir of Pain"] = "еліксир болю",
        ["Elixir of Pain (Provided)"] = "еліксир болю (видано)",
    },
    [503] = {
        ["Rusted Iron Key"] = "іржавий залізний ключ",
        ["Rusted Iron Key (Provided)"] = "іржавий залізний ключ (видано)",
    },
    [504] = {
        ["Crushridge Warmonger"] = "скелеламський войовник",
        ["Crushridge Warmonger slain"] = "скелеламський войовник: убито",
    },
    [505] = {
        ["Syndicate Footpad"] = "харциз Синдикату",
        ["Syndicate Footpad slain"] = "харциз Синдикату: убито",
        ["Syndicate Thief"] = "злодій Синдикату",
        ["Syndicate Thief slain"] = "злодій Синдикату: убито",
    },
    [507] = {
        ["Lord Aliden Perenolde"] = "Лорд Аліден Перенольд",
        ["Lord Aliden Perenolde (Provided)"] = "Лорд Аліден Перенольд (видано)",
        ["Lord Aliden Perenolde slain"] = "лорд Аліден Перенольд: убито",
    },
    [508] = {
        ["Taretha's Necklace"] = "намисто Тарети",
        ["Taretha's Necklace (Provided)"] = "намисто Тарети (видано)",
    },
    [509] = {
        ["Mudsnout Blossoms"] = "квітка Брудномордих",
        ["Mudsnout Blossoms (Provided)"] = "квітка Брудномордих (видано)",
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
        ["Alterac Signet Ring (Provided)"] = "альтерацька печатка (видано)",
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
        ["Daggerspine Scale (Provided)"] = "луска клинкоспинної наги (видано)",
        ["Mudsnout Mixture"] = "розчин Брудномордих",
        ["Mudsnout Mixture (Provided)"] = "розчин Брудномордих (видано)",
        ["Strong Troll's Blood Potion"] = "міцне зілля крові троля",
        ["Strong Troll's Blood Potion (Provided)"] = "міцне зілля крові троля (видано)",
        ["Torn Fin Eye"] = "око мурлока Розірваного Плавника",
        ["Torn Fin Eye (Provided)"] = "око мурлока Розірваного Плавника (видано)",
    },
    [516] = {
        ["Ravenclaw Drudger"] = "чорнороб Воронокігтя",
        ["Ravenclaw Drudger slain"] = "чорнороб Воронокігтя: убито",
        ["Ravenclaw Guardian"] = "вартовий Воронокігтя",
        ["Ravenclaw Guardian slain"] = "вартовий Воронокігтя: убито",
    },
    [517] = {
        ["Keg of Shindigger Stout"] = "барильце \"Землекопського міцного\"",
        ["Keg of Shindigger Stout (Provided)"] = "барильце \"Землекопського міцного\" (видано)",
    },
    [518] = {
        ["Crushridge Mauler"] = "скелеламський молотобій",
        ["Crushridge Mauler slain"] = "скелеламський молотобій: убито",
    },
    [519] = {
        ["Glommus's Head"] = "голова Ґломмуса",
        ["Glommus's Head (Provided)"] = "голова Ґломмуса (видано)",
        ["Muckrake's Head"] = "голова Брудня",
        ["Muckrake's Head (Provided)"] = "голова Брудня (видано)",
        ["Targ's Head"] = "голова Тарґа",
        ["Targ's Head (Provided)"] = "голова Тарґа (видано)",
    },
    [520] = {
        ["Crown of Will"] = "корона Волі",
        ["Crown of Will (Provided)"] = "корона Волі (видано)",
        ["Mug'thol's Head"] = "голова Муґ'Тола",
        ["Mug'thol's Head (Provided)"] = "голова Муґ'Тола (видано)",
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
        ["Head of Baron Vardus (Provided)"] = "голова барона Вардуса (видано)",
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
        ["Lightforge Ingot (Provided)"] = "злиток світлосталі (видано)",
    },
    [527] = {
        ["Farmer Getz"] = "фермер Ґетц",
        ["Farmer Getz slain"] = "фермер Ґетц: убито",
        ["Farmer Ray"] = "фермер Рей",
        ["Farmer Ray slain"] = "фермер Рей: убито",
        ["Hillsbrad Farmer"] = "гіллзбрадський фермер",
        ["Hillsbrad Farmer slain"] = "гіллзбрадський фермер: убито",
        ["Hillsbrad Farmhand"] = "гіллзбрадський робітник",
        ["Hillsbrad Farmhand slain"] = "гіллзбрадський робітник: убито",
    },
    [528] = {
        ["Hillsbrad Peasant"] = "гіллзбрадський селянин",
        ["Hillsbrad Peasant slain"] = "гіллзбрадський селянин: убито",
    },
    [529] = {
        ["Blacksmith Verringtan"] = "Коваль Веррінгтан",
        ["Blacksmith Verringtan (Provided)"] = "Коваль Веррінгтан (видано)",
        ["Blacksmith Verringtan slain"] = "коваль Веррінґтан: убито",
        ["Hillsbrad Apprentice Blacksmith"] = "гіллзбрадський учень коваля",
        ["Hillsbrad Apprentice Blacksmith slain"] = "гіллзбрадський учень коваля: убито",
        ["Shipment of Iron"] = "партія заліза",
        ["Shipment of Iron (Provided)"] = "партія заліза (видано)",
    },
    [530] = {
        ["Valdred's Hands"] = "руки Валдреда",
        ["Valdred's Hands (Provided)"] = "руки Валдреда (видано)",
    },
    [531] = {
        ["Ol' Sooty's Head"] = "голова старого Чорниша",
        ["Ol' Sooty's Head (Provided)"] = "голова старого Чорниша (видано)",
    },
    [532] = {
        ["Hillsbrad Councilman"] = "гіллзбрадський радник",
        ["Hillsbrad Councilman slain"] = "гіллзбрадський радник: убито",
        ["Hillsbrad Proclamation destroyed"] = "прокламацію Гіллзбраду знищено",
        ["Hillsbrad Town Registry"] = "реєстр Гіллзбраду",
        ["Hillsbrad Town Registry (Provided)"] = "реєстр Гіллзбраду (видано)",
        ["Magistrate Burnside"] = "війт Шкваростін",
        ["Magistrate Burnside slain"] = "війт Шкваростін: убито",
    },
    [533] = {
        ["Syndicate Missive"] = "послання Синдикату",
        ["Syndicate Missive (Provided)"] = "послання Синдикату (видано)",
    },
    [535] = {
        ["Southshore Stout"] = "південнобережне міцне",
        ["Southshore Stout (Provided)"] = "південнобережне міцне (видано)",
    },
    [536] = {
        ["Torn Fin Oracle"] = "оракул Розірваного Плавника",
        ["Torn Fin Oracle slain"] = "оракул Розірваного Плавника: убито",
        ["Torn Fin Tidehunter"] = "хвилелов Розірваного Плавника",
        ["Torn Fin Tidehunter slain"] = "хвилелов Розірваного Плавника: убито",
    },
    [537] = {
        ["Argus Shadow Mage"] = "арґуський тіньовий маг",
        ["Argus Shadow Mage slain"] = "арґуський тіньовий маг: убито",
        ["Head of Nagaz"] = "голова Наґаза",
        ["Head of Nagaz (Provided)"] = "голова Наґаза (видано)",
    },
    [539] = {
        ["Foreman Bonds"] = "десятник Бондс",
        ["Foreman Bonds slain"] = "десятник Бондс: убито",
        ["Hillsbrad Miner"] = "гіллзбрадський шахтар",
        ["Hillsbrad Miner slain"] = "гіллзбрадський шахтар: убито",
    },
    [540] = {
        ["Recovered Tome"] = "врятований том",
        ["Recovered Tome (Provided)"] = "врятований том (видано)",
        ["Worn Leather Book"] = "потерта шкіряна книга",
        ["Worn Leather Book (Provided)"] = "потерта шкіряна книга (видано)",
    },
    [541] = {
        ["Captain Ironhill"] = "капітан Залізопагорб",
        ["Captain Ironhill slain"] = "капітан Залізопагорб: убито",
        ["Dun Garok Mountaineer"] = "дун-ґароцький горянин",
        ["Dun Garok Mountaineer slain"] = "дун-ґароцький горянин: убито",
        ["Dun Garok Priest"] = "дун-ґароцький жрець",
        ["Dun Garok Priest slain"] = "дун-ґароцький жрець: убито",
        ["Dun Garok Rifleman"] = "дун-ґароцький стрілець",
        ["Dun Garok Rifleman slain"] = "дун-ґароцький стрілець: убито",
    },
    [542] = {
        ["Tomes of Alterac"] = "альтерацькі томи",
        ["Tomes of Alterac (Provided)"] = "альтерацькі томи (видано)",
    },
    [543] = {
        ["Perenolde Tiara"] = "тіара Перенольдів",
        ["Perenolde Tiara (Provided)"] = "тіара Перенольдів (видано)",
    },
    [544] = {
        ["Bloodstone Marble"] = "кулька з кривавого каменю",
        ["Bloodstone Marble (Provided)"] = "кулька з кривавого каменю (видано)",
        ["Bloodstone Oval"] = "овал з кривавого каменю",
        ["Bloodstone Oval (Provided)"] = "овал з кривавого каменю (видано)",
        ["Bloodstone Shard"] = "осколок з кривавого каменю",
        ["Bloodstone Shard (Provided)"] = "осколок з кривавого каменю (видано)",
        ["Bloodstone Wedge"] = "клин з кривавого каменю",
        ["Bloodstone Wedge (Provided)"] = "клин з кривавого каменю (видано)",
    },
    [545] = {
        ["Dalaran Summoner"] = "даларанський закликач",
        ["Dalaran Summoner slain"] = "даларанський закликач: убито",
        ["Elemental Slave"] = "елементаль-невільник",
        ["Elemental Slave slain"] = "елементаль-невільник: убито",
    },
    [546] = {
        ["Hillsbrad Human Skull"] = "людський череп з Гіллзбраду",
        ["Hillsbrad Human Skull (Provided)"] = "людський череп з Гіллзбраду (видано)",
    },
    [547] = {
        ["Humbert's Sword"] = "меч Гумберта",
        ["Humbert's Sword (Provided)"] = "меч Гумберта (видано)",
    },
    [549] = {
        ["Syndicate Rogue"] = "пройдисвіт Синдикату",
        ["Syndicate Rogue slain"] = "пройдисвіт Синдикату: убито",
        ["Syndicate Watchman"] = "вартовий Синдикату",
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
        ["Helcular's Rod (Provided)"] = "жезл Гелькулара (видано)",
    },
    [553] = {
        ["Flame of Azel charged"] = "полум'я Азеля заряджено",
        ["Flame of Azel charged (Provided)"] = "полум'я Азеля заряджено (видано)",
        ["Flame of Azel charged slain"] = "полум'я Азеля заряджено: убито",
        ["Flame of Uzel charged"] = "полум'я Узеля заряджено",
        ["Flame of Uzel charged (Provided)"] = "полум'я Узеля заряджено (видано)",
        ["Flame of Uzel charged slain"] = "полум'я Узеля заряджено: убито",
        ["Flame of Veraz charged"] = "полум'я Вераза заряджено",
        ["Flame of Veraz charged (Provided)"] = "полум'я Вераза заряджено (видано)",
        ["Flame of Veraz charged slain"] = "полум'я Вераза заряджено: убито",
        ["Rod of Helcular"] = "жезл Гелькулара",
        ["Rod of Helcular (Provided)"] = "жезл Гелькулара (видано)",
    },
    [554] = {
        ["Ensorcelled Parchment"] = "зачаклований пергамент",
        ["Ensorcelled Parchment (Provided)"] = "зачаклований пергамент (видано)",
    },
    [555] = {
        ["Soothing Spices"] = "духмяні спеції",
        ["Soothing Spices (Provided)"] = "духмяні спеції (видано)",
        ["Turtle Meat"] = "черепашаче м'ясо",
        ["Turtle Meat (Provided)"] = "черепашаче м'ясо (видано)",
    },
    [556] = {
        ["Worn Stone Token"] = "потертий кам'яний талісман",
        ["Worn Stone Token (Provided)"] = "потертий кам'яний талісман (видано)",
    },
    [557] = {
        ["Bracers of Earth Binding"] = "зв'язувальні браслети землі",
        ["Bracers of Earth Binding (Provided)"] = "зв'язувальні браслети землі (видано)",
    },
    [558] = {
        ["Jaina's Autograph"] = "автограф Джайни",
        ["Jaina's Autograph (Provided)"] = "автограф Джайни (видано)",
    },
    [559] = {
        ["Murloc Head"] = "голова мурлока",
        ["Murloc Head (Provided)"] = "голова мурлока (видано)",
    },
    [560] = {
        ["Sack of Murloc Heads"] = "мішок голів мурлоків",
        ["Sack of Murloc Heads (Provided)"] = "мішок голів мурлоків (видано)",
    },
    [562] = {
        ["Daggerspine Shorehunter"] = "береговий мисливець Клинкоспинів",
        ["Daggerspine Shorehunter slain"] = "береговий мисливець Клинкоспинів: убито",
        ["Daggerspine Siren"] = "сирена Клинкоспинів",
        ["Daggerspine Siren slain"] = "сирена Клинкоспинів: убито",
    },
    [563] = {
        ["Farren's Report"] = "звіт Фаррена",
        ["Farren's Report (Provided)"] = "звіт Фаррена (видано)",
    },
    [564] = {
        ["Hulking Mountain Lion"] = "масивний гірський лев",
        ["Hulking Mountain Lion slain"] = "масивний гірський лев: убито",
        ["Mountain Lion"] = "гірський лев",
        ["Mountain Lion slain"] = "гірський лев: убито",
    },
    [565] = {
        ["Bolt of Woolen Cloth"] = "рулон вовняної тканини",
        ["Bolt of Woolen Cloth (Provided)"] = "рулон вовняної тканини (видано)",
        ["Fine Thread"] = "тонка нитка",
        ["Fine Thread (Provided)"] = "тонка нитка (видано)",
        ["Hillman's Cloak"] = "накидка жителя пагорбів",
        ["Hillman's Cloak (Provided)"] = "накидка жителя пагорбів (видано)",
        ["Yeti Fur"] = "хутро єті",
        ["Yeti Fur (Provided)"] = "хутро єті (видано)",
    },
    [566] = {
        ["Head of Baron Vardus"] = "голова барона Вардуса",
        ["Head of Baron Vardus (Provided)"] = "голова барона Вардуса (видано)",
    },
    [567] = {
        ["Citizen Wilkes"] = "містянин Вілкс",
        ["Citizen Wilkes slain"] = "містянин Вілкс: убито",
        ["Clerk Horrace Whitesteed"] = "Клерк Горрас Вайтстід",
        ["Clerk Horrace Whitesteed (Provided)"] = "Клерк Горрас Вайтстід (видано)",
        ["Clerk Horrace Whitesteed slain"] = "писар Горацій Білокінь: убито",
        ["Farmer Kalaba"] = "фермерка Калаба",
        ["Farmer Kalaba slain"] = "фермерка Калаба: убито",
        ["Miner Hackett"] = "шахтар Гаккет",
        ["Miner Hackett slain"] = "шахтар Гаккет: убито",
    },
    [568] = {
        ["Lashtail Raptor"] = "хлястохвостий раптор",
        ["Lashtail Raptor slain"] = "хлястохвостий раптор: убито",
    },
    [569] = {
        ["Mosh'Ogg Brute"] = "мош'оґґський моцак",
        ["Mosh'Ogg Brute slain"] = "мош'оґґський моцак: убито",
        ["Mosh'Ogg Witch Doctor"] = "мош'оґґський знахар",
        ["Mosh'Ogg Witch Doctor slain"] = "мош'оґґський знахар: убито",
    },
    [570] = {
        ["Pristine Tigress Fang"] = "бездоганне ікло тигриці",
        ["Pristine Tigress Fang (Provided)"] = "бездоганне ікло тигриці (видано)",
        ["Shadowmaw Claw"] = "пазур тінепащої пантери",
        ["Shadowmaw Claw (Provided)"] = "пазур тінепащої пантери (видано)",
    },
    [571] = {
        ["Aged Gorilla Sinew"] = "сухожилля старої горили",
        ["Aged Gorilla Sinew (Provided)"] = "сухожилля старої горили (видано)",
    },
    [572] = {
        ["Jungle Stalker Feather"] = "перо ловця джунглів",
        ["Jungle Stalker Feather (Provided)"] = "перо ловця джунглів (видано)",
    },
    [573] = {
        ["Holy Spring Water"] = "вода святого джерела",
        ["Holy Spring Water (Provided)"] = "вода святого джерела (видано)",
        ["Naga Explorer"] = "нага-дослідник",
        ["Naga Explorer slain"] = "нага-дослідник: убито",
    },
    [574] = {
        ["Kurzen Commando"] = "командос Курцена",
        ["Kurzen Commando slain"] = "командос Курцена: убито",
        ["Kurzen Headshrinker"] = "головодав Курцена",
        ["Kurzen Headshrinker slain"] = "головодав Курцена: убито",
    },
    [575] = {
        ["Large River Crocolisk Skin"] = "велика шкура річкового кроколіска",
        ["Large River Crocolisk Skin (Provided)"] = "велика шкура річкового кроколіска (видано)",
    },
    [576] = {
        ["Dizzy's Eye"] = "око Запаморока",
        ["Dizzy's Eye (Provided)"] = "око Запаморока (видано)",
    },
    [577] = {
        ["Snapjaw Crocolisk Skin"] = "шкура кроколіска-тріскощелепа",
        ["Snapjaw Crocolisk Skin (Provided)"] = "шкура кроколіска-тріскощелепа (видано)",
    },
    [578] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Locate the haunted island"] = "Знайдіть острів з духами",
    },
    [579] = {
        ["Library Scrip"] = "бібліотечний сувій",
        ["Library Scrip (Provided)"] = "бібліотечний сувій (видано)",
    },
    [580] = {
        ["Pupellyverbos Port"] = "портвейн \"Пупеллівербос\"",
        ["Pupellyverbos Port (Provided)"] = "портвейн \"Пупеллівербос\" (видано)",
    },
    [581] = {
        ["Bloodscalp Tusk"] = "ікло Кровоскальпого",
        ["Bloodscalp Tusk (Provided)"] = "ікло Кровоскальпого (видано)",
    },
    [582] = {
        ["Shrunken Head"] = "сушена голова",
        ["Shrunken Head (Provided)"] = "сушена голова (видано)",
    },
    [584] = {
        ["Gan'zulah's Head"] = "голова Ґан'зули",
        ["Gan'zulah's Head (Provided)"] = "голова Ґан'зули (видано)",
        ["Nezzliok's Head"] = "голова Неззліока",
        ["Nezzliok's Head (Provided)"] = "голова Неззліока (видано)",
    },
    [585] = {
        ["Balia'mah Trophy"] = "трофей з Баліа'ма",
        ["Balia'mah Trophy (Provided)"] = "трофей з Баліа'ма (видано)",
        ["Ziata'jai Trophy"] = "трофей з Зіата'джай",
        ["Ziata'jai Trophy (Provided)"] = "трофей з Зіата'джай (видано)",
        ["Zul'Mamwe Trophy"] = "трофей з Зул'Мамве",
        ["Zul'Mamwe Trophy (Provided)"] = "трофей з Зул'Мамве (видано)",
    },
    [586] = {
        ["Broken Armor of Ana'thek"] = "розтрощені обладунки Ана'тека",
        ["Broken Armor of Ana'thek (Provided)"] = "розтрощені обладунки Ана'тека (видано)",
        ["Skullsplitter Berserker"] = "берсерк Черепотрощителів",
        ["Skullsplitter Berserker slain"] = "берсерк Черепотрощителів: убито",
        ["Skullsplitter Headhunter"] = "мисливець за головами Черепотрощителів",
        ["Skullsplitter Headhunter slain"] = "мисливець за головами Черепотрощителів: убито",
        ["Skullsplitter Hunter"] = "мисливець Черепотрощителів",
        ["Skullsplitter Hunter slain"] = "мисливець Черепотрощителів: убито",
    },
    [587] = {
        ["Snuff"] = "понюшка тютюну",
        ["Snuff (Provided)"] = "понюшка тютюну (видано)",
    },
    [589] = {
        ["Pulsing Blue Shard"] = "пульсуючий блакитний осколок",
        ["Pulsing Blue Shard (Provided)"] = "пульсуючий блакитний осколок (видано)",
    },
    [590] = {
        ["Defeat Calvin Montague"] = "Здолайте Кальвіна Монтеґ'ю",
    },
    [591] = {
        ["Mind's Eye"] = "Око Розуму",
        ["Mind's Eye (Provided)"] = "Око Розуму (видано)",
    },
    [592] = {
        ["Filled Soul Gem"] = "наповнений камінь душі",
        ["Filled Soul Gem (Provided)"] = "наповнений камінь душі (видано)",
    },
    [593] = {
        ["Soul Gem"] = "камінь душі",
        ["Soul Gem (Provided)"] = "камінь душі (видано)",
    },
    [596] = {
        ["Bloody Bone Necklace"] = "намисто з кривавих кісток",
        ["Bloody Bone Necklace (Provided)"] = "намисто з кривавих кісток (видано)",
    },
    [598] = {
        ["Split Bone Necklace"] = "намисто з розщеплених кісток",
        ["Split Bone Necklace (Provided)"] = "намисто з розщеплених кісток (видано)",
    },
    [600] = {
        ["Singing Blue Crystal"] = "співочий блакитний кристал",
        ["Singing Blue Crystal (Provided)"] = "співочий блакитний кристал (видано)",
    },
    [601] = {
        ["Water Elemental Bracers"] = "браслет водяного елементаля",
        ["Water Elemental Bracers (Provided)"] = "браслет водяного елементаля (видано)",
    },
    [602] = {
        ["Bag of Water Elemental Bracers"] = "мішок з браслетами водяних елементалів",
        ["Bag of Water Elemental Bracers (Provided)"] = "мішок з браслетами водяних елементалів (видано)",
    },
    [604] = {
        ["Bloodsail Charts"] = "карти Кривавого Вітрила",
        ["Bloodsail Charts (Provided)"] = "карти Кривавого Вітрила (видано)",
        ["Bloodsail Orders"] = "накази Кривавого Вітрила",
        ["Bloodsail Orders (Provided)"] = "накази Кривавого Вітрила (видано)",
        ["Bloodsail Swashbuckler"] = "шибайголова Кривавого Вітрила",
        ["Bloodsail Swashbuckler slain"] = "шибайголова Кривавого Вітрила: убито",
    },
    [605] = {
        ["Singing Crystal Shard"] = "осколок співочого кристала",
        ["Singing Crystal Shard (Provided)"] = "осколок співочого кристала (видано)",
    },
    [606] = {
        ["Mistvale Giblets"] = "потрухи туманодільної горили",
        ["Mistvale Giblets (Provided)"] = "потрухи туманодільної горили (видано)",
    },
    [607] = {
        ["Shaky's Payment"] = "борг Полохуна",
        ["Shaky's Payment (Provided)"] = "борг Полохуна (видано)",
    },
    [608] = {
        ["Captain Keelhaul"] = "капітан Кілетяг",
        ["Captain Keelhaul slain"] = "капітан Кілетяг: убито",
        ["Captain Stillwater"] = "капітан Море-по-коліно",
        ["Captain Stillwater slain"] = "капітан Море-по-коліно: убито",
        ["Fleet Master Firallon"] = "командувач флоту Фіраллон",
        ["Fleet Master Firallon slain"] = "командувач флоту Фіраллон: убито",
    },
    [609] = {
        ["Chucky's Huge Ring"] = "величезний перстень Чакі",
        ["Chucky's Huge Ring (Provided)"] = "величезний перстень Чакі (видано)",
        ["Jon-Jon's Golden Spyglass"] = "золота підзорна труба Джон-Джона",
        ["Jon-Jon's Golden Spyglass (Provided)"] = "золота підзорна труба Джон-Джона (видано)",
        ["Maury's Clubbed Foot"] = "дерев'яна нога Морі",
        ["Maury's Clubbed Foot (Provided)"] = "дерев'яна нога Морі (видано)",
    },
    [610] = {
        ["Catelyn's Blade"] = "кинджал Кателіни",
        ["Catelyn's Blade (Provided)"] = "кинджал Кателіни (видано)",
    },
    [611] = {
        ["Catelyn's Blade"] = "кинджал Кателіни",
        ["Catelyn's Blade (Provided)"] = "кинджал Кателіни (видано)",
        ["Stone of the Tides"] = "камінь припливів",
        ["Stone of the Tides (Provided)"] = "камінь припливів (видано)",
    },
    [613] = {
        ["Maury's Key"] = "ключ Морі",
        ["Maury's Key (Provided)"] = "ключ Морі (видано)",
    },
    [614] = {
        ["Smotts' Chest"] = "скриня Смоттса",
        ["Smotts' Chest (Provided)"] = "скриня Смоттса (видано)",
    },
    [617] = {
        ["Akiris Reed"] = "стебло акіріса",
        ["Akiris Reed (Provided)"] = "стебло акіріса (видано)",
    },
    [618] = {
        ["Smotts' Cutlass"] = "шабля Смоттса",
        ["Smotts' Cutlass (Provided)"] = "шабля Смоттса (видано)",
    },
    [619] = {
        ["Barbecued Buzzard Wing"] = "смажене крильце канюка",
        ["Barbecued Buzzard Wing (Provided)"] = "смажене крильце канюка (видано)",
        ["Junglevine Wine"] = "вино з джунглів",
        ["Junglevine Wine (Provided)"] = "вино з джунглів (видано)",
    },
    [620] = {
        ["Monogrammed Sash"] = "пояс з монограмою",
        ["Monogrammed Sash (Provided)"] = "пояс з монограмою (видано)",
    },
    [621] = {
        ["Zanzil's Mixture"] = "суміш Занзіла",
        ["Zanzil's Mixture (Provided)"] = "суміш Занзіла (видано)",
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
        ["Lesser Bloodstone Ore (Provided)"] = "мала руда кривавого каменю (видано)",
    },
    [628] = {
        ["Elder Crocolisk Skin"] = "шкура старого кроколіска",
        ["Elder Crocolisk Skin (Provided)"] = "шкура старого кроколіска (видано)",
    },
    [629] = {
        ["Tablet Shard"] = "уламок скрижалі",
        ["Tablet Shard (Provided)"] = "уламок скрижалі (видано)",
    },
    [630] = {
        ["Shackle Key"] = "ключ від кайданів",
        ["Shackle Key (Provided)"] = "ключ від кайданів (видано)",
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
    [648] = {
        ["Escort OOX-17/TN to Steamwheedle Port"] = "Супровід OOX-17/TN до порту Стімвілдл",
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
    [660] = {
        ["Protect Kinelory"] = "Захистіть Кінелорію",
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
    [665] = {
        ["Defend Professor Phizzlethorpe"] = "Захистіть професора Фізлторпа",
    },
    [666] = {
        ["Elven Gem"] = "ельфійський самоцвіт",
        ["Elven Gem (Provided)"] = "ельфійський самоцвіт (видано)",
        ["Goggles of Gem Hunting"] = "окуляри для пошуку самоцвітів",
        ["Goggles of Gem Hunting (Provided)"] = "окуляри для пошуку самоцвітів (видано)",
    },
    [667] = {
        ["Defend Shakes O'Breen"] = "Захистіть Шейкса О'Бріна",
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
    [695] = {
        ["Enchanted Agate"] = "зачарований агат",
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
    [731] = {
        ["Escort Prospector Remtravel"] = "Ескорт-шукач Remtravel",
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
        ["Plainstrider Feather (Provided)"] = "пір'я рівнинобіга (видано)",
        ["Plainstrider Meat"] = "м'ясо рівнинобіга",
        ["Plainstrider Meat (Provided)"] = "м'ясо рівнинобіга (видано)",
    },
    [748] = {
        ["Plainstrider Talon"] = "кіготь рівнинобіга",
        ["Plainstrider Talon (Provided)"] = "кіготь рівнинобіга (видано)",
        ["Prairie Wolf Paw"] = "лапа степового вовка",
        ["Prairie Wolf Paw (Provided)"] = "лапа степового вовка (видано)",
    },
    [750] = {
        ["Mountain Cougar Pelt"] = "шкура гірської пуми",
        ["Mountain Cougar Pelt (Provided)"] = "шкура гірської пуми (видано)",
    },
    [751] = {
        ["Venture Co. Documents"] = "документи ТзНБ \"Авантюра\"",
        ["Venture Co. Documents (Provided)"] = "документи ТзНБ \"Авантюра\" (видано)",
    },
    [753] = {
        ["Water Pitcher"] = "глечик води",
        ["Water Pitcher (Provided)"] = "глечик води (видано)",
    },
    [754] = {
        ["Cleanse the Winterhoof Water Well"] = "Очистіть криницю Зимового Копита",
    },
    [756] = {
        ["Cougar Claws"] = "пазурі пуми",
        ["Cougar Claws (Provided)"] = "пазурі пуми (видано)",
        ["Stalker Claws"] = "пазурі ловця",
        ["Stalker Claws (Provided)"] = "пазурі ловця (видано)",
    },
    [757] = {
        ["Bristleback Belt"] = "пояс Щетиношкурих",
        ["Bristleback Belt (Provided)"] = "пояс Щетиношкурих (видано)",
    },
    [758] = {
        ["Cleanse the Thunderhorn Water Well"] = "Очистіть водяну криницю Громового рога",
    },
    [759] = {
        ["Prairie Alpha Tooth"] = "зуб степового альфи",
        ["Prairie Alpha Tooth (Provided)"] = "зуб степового альфи (видано)",
    },
    [760] = {
        ["Cleanse the Wildmane Well"] = "Очистіть криницю Дикої Гриви",
    },
    [761] = {
        ["Trophy Swoop Quill"] = "трофейна пір'їна хапуна",
        ["Trophy Swoop Quill (Provided)"] = "трофейна пір'їна хапуна (видано)",
    },
    [762] = {
        ["Ambassador Infernus' Bracer"] = "браслет посла Інферна",
        ["Ambassador Infernus' Bracer (Provided)"] = "браслет посла Інферна (видано)",
    },
    [763] = {
        ["Totem of Hawkwind"] = "тотем Соколиного Вітру",
        ["Totem of Hawkwind (Provided)"] = "тотем Соколиного Вітру (видано)",
    },
    [764] = {
        ["Venture Co. Supervisor"] = "керівник ТзНБ \"Авантюра\"",
        ["Venture Co. Supervisor slain"] = "керівник ТзНБ \"Авантюра\": убито",
        ["Venture Co. Worker"] = "робітник ТзНБ \"Авантюра\"",
        ["Venture Co. Worker slain"] = "робітник ТзНБ \"Авантюра\": убито",
    },
    [765] = {
        ["Fizsprocket's Clipboard"] = "записник Шуморакети",
        ["Fizsprocket's Clipboard (Provided)"] = "записник Шуморакети (видано)",
    },
    [766] = {
        ["Flatland Cougar Femur"] = "стегнова кістка рівнинної пуми",
        ["Flatland Cougar Femur (Provided)"] = "стегнова кістка рівнинної пуми (видано)",
        ["Plainstrider Scale"] = "луска рівнинобіга",
        ["Plainstrider Scale (Provided)"] = "луска рівнинобіга (видано)",
        ["Prairie Wolf Heart"] = "серце степового вовка",
        ["Prairie Wolf Heart (Provided)"] = "серце степового вовка (видано)",
        ["Swoop Gizzard"] = "шлунок хапуна",
        ["Swoop Gizzard (Provided)"] = "шлунок хапуна (видано)",
    },
    [768] = {
        ["Light Leather"] = "легка шкіра",
        ["Light Leather (Provided)"] = "легка шкіра (видано)",
    },
    [769] = {
        ["Coarse Thread"] = "груба нитка",
        ["Coarse Thread (Provided)"] = "груба нитка (видано)",
        ["Light Leather"] = "легка шкіра",
        ["Light Leather (Provided)"] = "легка шкіра (видано)",
    },
    [770] = {
        ["Demon Scarred Cloak"] = "пошматований демонами плащ",
    },
    [771] = {
        ["Ambercorn"] = "бурштинова насінина",
        ["Ambercorn (Provided)"] = "бурштинова насінина (видано)",
        ["Well Stone"] = "колодязний камінь",
        ["Well Stone (Provided)"] = "колодязний камінь (видано)",
    },
    [772] = {
        ["Water of the Seers"] = "вода провидців",
    },
    [776] = {
        ["Horn of Arra'chea"] = "ріг Арра'чі",
        ["Horn of Arra'chea (Provided)"] = "ріг Арра'чі (видано)",
    },
    [777] = {
        ["Cog #5"] = "зубець #5",
        ["Cog #5 (Provided)"] = "зубець #5 (видано)",
    },
    [778] = {
        ["Lotwil's Shackles of Elemental Binding"] = "кайдани зв'язування стихій Лотвіля",
        ["Lotwil's Shackles of Elemental Binding (Provided)"] = "кайдани зв'язування стихій Лотвіля (видано)",
    },
    [779] = {
        ["Amethyst Runestone"] = "аметистовий рунічний камінь",
        ["Amethyst Runestone (Provided)"] = "аметистовий рунічний камінь (видано)",
        ["Diamond Runestone"] = "діамантовий рунічний камінь",
        ["Diamond Runestone (Provided)"] = "діамантовий рунічний камінь (видано)",
        ["Opal Runestone"] = "опаловий рунічний камінь",
        ["Opal Runestone (Provided)"] = "опаловий рунічний камінь (видано)",
    },
    [780] = {
        ["Battleboar Flank"] = "вирізка бойового кнура",
        ["Battleboar Flank (Provided)"] = "вирізка бойового кнура (видано)",
        ["Battleboar Snout"] = "рило бойового кнура",
        ["Battleboar Snout (Provided)"] = "рило бойового кнура (видано)",
    },
    [781] = {
        ["Bristleback Attack Plans"] = "плани нападу Щетиношкурих",
        ["Bristleback Attack Plans (Provided)"] = "плани нападу Щетиношкурих (видано)",
    },
    [782] = {
        ["Sign of the Earth"] = "знак Землі",
        ["Sign of the Earth (Provided)"] = "знак Землі (видано)",
    },
    [784] = {
        ["Kul Tiras Marine"] = "кул-тіраський морський піхотинець",
        ["Kul Tiras Marine slain"] = "кул-тіраський морський піхотинець: убито",
        ["Kul Tiras Sailor"] = "кул-тіраський моряк",
        ["Kul Tiras Sailor slain"] = "кул-тіраський моряк: убито",
        ["Lieutenant Benedict"] = "лейтенант Бенедикт",
        ["Lieutenant Benedict slain"] = "лейтенант Бенедикт: убито",
    },
    [786] = {
        ["Attack Plan: Orgrimmar destroyed"] = "План атаки: знищення Орґріммара",
        ["Attack Plan: Sen'jin Village destroyed"] = "План атаки: знищено село Сен'джін",
        ["Attack Plan: Valley of Trials destroyed"] = "План атаки: Долина випробувань знищена",
    },
    [788] = {
        ["Mottled Boar"] = "крапчастий кнур",
        ["Mottled Boar slain"] = "крапчастий кнур: убито",
    },
    [789] = {
        ["Scorpid Worker Tail"] = "хвіст скорпіда-робітника",
        ["Scorpid Worker Tail (Provided)"] = "хвіст скорпіда-робітника (видано)",
    },
    [790] = {
        ["Sarkoth's Mangled Claw"] = "понівечена клешня Саркота",
        ["Sarkoth's Mangled Claw (Provided)"] = "понівечена клешня Саркота (видано)",
    },
    [791] = {
        ["Canvas Scraps"] = "уривки полотна",
        ["Canvas Scraps (Provided)"] = "уривки полотна (видано)",
    },
    [792] = {
        ["Vile Familiar"] = "паскудний фамільяр",
        ["Vile Familiar slain"] = "паскудний фамільяр: убито",
    },
    [793] = {
        ["Blacklash's Bindings"] = "наручники Чорнохлиста",
        ["Blacklash's Bindings (Provided)"] = "наручники Чорнохлиста (видано)",
        ["Chains of Hematus"] = "ланцюги Гемата",
        ["Chains of Hematus (Provided)"] = "ланцюги Гемата (видано)",
        ["Sign of the Earth"] = "знак Землі",
        ["Sign of the Earth (Provided)"] = "знак Землі (видано)",
    },
    [794] = {
        ["Burning Blade Medallion"] = "медальйон Палаючого Леза",
        ["Burning Blade Medallion (Provided)"] = "медальйон Палаючого Леза (видано)",
    },
    [795] = {
        ["Amethyst Runestone"] = "аметистовий рунічний камінь",
        ["Amethyst Runestone (Provided)"] = "аметистовий рунічний камінь (видано)",
        ["Diamond Runestone"] = "діамантовий рунічний камінь",
        ["Diamond Runestone (Provided)"] = "діамантовий рунічний камінь (видано)",
        ["Opal Runestone"] = "опаловий рунічний камінь",
        ["Opal Runestone (Provided)"] = "опаловий рунічний камінь (видано)",
    },
    [806] = {
        ["Fizzle's Claw"] = "кіготь Фіззла",
        ["Fizzle's Claw (Provided)"] = "кіготь Фіззла (видано)",
    },
    [808] = {
        ["Minshina's Skull"] = "череп Міншини",
        ["Minshina's Skull (Provided)"] = "череп Міншини (видано)",
    },
    [809] = {
        ["Destroy the Demon Seed"] = "Знищити Насіння Демона",
    },
    [812] = {
        ["Venomtail Antidote"] = "протиотрута з отрутохвоста",
        ["Venomtail Antidote (Provided)"] = "протиотрута з отрутохвоста (видано)",
    },
    [813] = {
        ["Venomtail Poison Sac"] = "отруйна залоза отрутохвоста",
        ["Venomtail Poison Sac (Provided)"] = "отруйна залоза отрутохвоста (видано)",
    },
    [815] = {
        ["Taillasher Egg"] = "яйце хвостохляста",
        ["Taillasher Egg (Provided)"] = "яйце хвостохляста (видано)",
    },
    [816] = {
        ["Kron's Amulet"] = "амулет Крона",
        ["Kron's Amulet (Provided)"] = "амулет Крона (видано)",
    },
    [817] = {
        ["Durotar Tiger Fur"] = "хутро дуротарського тигра",
        ["Durotar Tiger Fur (Provided)"] = "хутро дуротарського тигра (видано)",
    },
    [818] = {
        ["Crawler Mucus"] = "слиз повзуна",
        ["Crawler Mucus (Provided)"] = "слиз повзуна (видано)",
        ["Intact Makrura Eye"] = "неушкоджене око макрури",
        ["Intact Makrura Eye (Provided)"] = "неушкоджене око макрури (видано)",
    },
    [819] = {
        ["Chen's Empty Keg"] = "порожня діжка Ченя",
        ["Chen's Empty Keg (Provided)"] = "порожня діжка Ченя (видано)",
    },
    [821] = {
        ["Plainstrider Kidney"] = "нирка рівнинобіга",
        ["Plainstrider Kidney (Provided)"] = "нирка рівнинобіга (видано)",
        ["Savannah Lion Tusk"] = "ікло лева савани",
        ["Savannah Lion Tusk (Provided)"] = "ікло лева савани (видано)",
        ["Thunder Lizard Horn"] = "ріг громоящера",
        ["Thunder Lizard Horn (Provided)"] = "ріг громоящера (видано)",
    },
    [822] = {
        ["Kodo Liver"] = "печінка кодо",
        ["Kodo Liver (Provided)"] = "печінка кодо (видано)",
        ["Lightning Gland"] = "громозалоза",
        ["Lightning Gland (Provided)"] = "громозалоза (видано)",
        ["Thunderhawk Saliva Gland"] = "слинна залоза громояструба",
        ["Thunderhawk Saliva Gland (Provided)"] = "слинна залоза громояструба (видано)",
    },
    [824] = {
        ["Befouled Water Globe"] = "забруднена водяна куля",
        ["Befouled Water Globe (Provided)"] = "забруднена водяна куля (видано)",
    },
    [825] = {
        ["Gnomish Tools"] = "інструменти гномів",
        ["Gnomish Tools (Provided)"] = "інструменти гномів (видано)",
    },
    [826] = {
        ["Hexed Troll"] = "зачарований троль",
        ["Hexed Troll slain"] = "зачарований троль: убито",
        ["Voodoo Troll"] = "троль вуду",
        ["Voodoo Troll slain"] = "троль вуду: убито",
        ["Zalazane's Head"] = "голова Залазейна",
        ["Zalazane's Head (Provided)"] = "голова Залазейна (видано)",
    },
    [827] = {
        ["Searing Collar"] = "опалюючий нашийник",
        ["Searing Collar (Provided)"] = "опалюючий нашийник (видано)",
    },
    [829] = {
        ["Example Collar"] = "зразок ошийника",
        ["Example Collar (Provided)"] = "зразок ошийника (видано)",
    },
    [830] = {
        ["Admiral Proudmoore's Orders"] = "накази адмірала Праудмура",
        ["Admiral Proudmoore's Orders (Provided)"] = "накази адмірала Праудмура (видано)",
    },
    [831] = {
        ["Admiral Proudmoore's Orders"] = "накази адмірала Праудмура",
        ["Admiral Proudmoore's Orders (Provided)"] = "накази адмірала Праудмура (видано)",
    },
    [832] = {
        ["Eye of Burning Shadow"] = "око палаючої тіні",
        ["Eye of Burning Shadow (Provided)"] = "око палаючої тіні (видано)",
    },
    [833] = {
        ["Bristleback Interloper"] = "щетиношкурий встрягач",
        ["Bristleback Interloper slain"] = "щетиношкурий встрягач: убито",
    },
    [834] = {
        ["Sack of Supplies"] = "мішок з припасами",
        ["Sack of Supplies (Provided)"] = "мішок з припасами (видано)",
    },
    [835] = {
        ["Dustwind Savage"] = "пиловійна дикунка",
        ["Dustwind Savage slain"] = "пиловійна дикунка: убито",
        ["Dustwind Storm Witch"] = "пиловійна штормовідьма",
        ["Dustwind Storm Witch slain"] = "пиловійна штормовідьма: убито",
    },
    [836] = {
        ["Escort OOX-09/HL to the shoreline beyond Overlook Cliff"] = "Супровід OOX-09/HL до берегової лінії за скелею Оверлук",
    },
    [837] = {
        ["Razormane Battleguard"] = "бритвогривий боєстраж",
        ["Razormane Battleguard slain"] = "бритвогривий боєстраж: убито",
        ["Razormane Dustrunner"] = "бритвогривий пилобіг",
        ["Razormane Dustrunner slain"] = "бритвогривий пилобіг: убито",
        ["Razormane Quilboar"] = "бритвогривий свинобраз",
        ["Razormane Quilboar slain"] = "бритвогривий свинобраз: убито",
        ["Razormane Scout"] = "бритвогривий розвідник",
        ["Razormane Scout slain"] = "бритвогривий розвідник: убито",
    },
    [840] = {
        ["Recruitment Letter"] = "вербувальний лист",
        ["Recruitment Letter (Provided)"] = "вербувальний лист (видано)",
    },
    [841] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
        ["Wastewander Water Pouch (Provided)"] = "бурдюк з водою Пустелебродів (видано)",
    },
    [842] = {
        ["Signed Recruitment Letter"] = "підписаний вербувальний лист",
        ["Signed Recruitment Letter (Provided)"] = "підписаний вербувальний лист (видано)",
    },
    [843] = {
        ["Bael'dun Excavator"] = "бель'дунський копач",
        ["Bael'dun Excavator slain"] = "бель'дунський копач: убито",
        ["Bael'dun Foreman"] = "бель'дунський бригадир",
        ["Bael'dun Foreman slain"] = "бель'дунський бригадир: убито",
        ["Khazgorm's Journal"] = "журнал Хазґорма",
        ["Khazgorm's Journal (Provided)"] = "журнал Хазґорма (видано)",
    },
    [844] = {
        ["Plainstrider Beak"] = "дзьоб рівнинобіга",
        ["Plainstrider Beak (Provided)"] = "дзьоб рівнинобіга (видано)",
    },
    [845] = {
        ["Zhevra Hooves"] = "копита жеври",
        ["Zhevra Hooves (Provided)"] = "копита жеври (видано)",
    },
    [846] = {
        ["Nitroglycerin"] = "нітрогліцерин",
        ["Nitroglycerin (Provided)"] = "нітрогліцерин (видано)",
        ["Sodium Nitrate"] = "нітрат натрію",
        ["Sodium Nitrate (Provided)"] = "нітрат натрію (видано)",
        ["Wood Pulp"] = "целюлоза",
        ["Wood Pulp (Provided)"] = "целюлоза (видано)",
    },
    [848] = {
        ["Fungal Spores"] = "спори грибів",
        ["Fungal Spores (Provided)"] = "спори грибів (видано)",
    },
    [849] = {
        ["Bael Modan Flying Machine destroyed"] = "Літальний апарат Баель Модан знищено",
    },
    [850] = {
        ["Barak's Head"] = "Голова Барака",
        ["Barak's Head (Provided)"] = "Голова Барака (видано)",
        ["Barak's Head slain"] = "Голова Барака: убито",
    },
    [851] = {
        ["Verog's Head"] = "голова Вероґа",
        ["Verog's Head (Provided)"] = "голова Вероґа (видано)",
    },
    [852] = {
        ["Hezrul's Head"] = "голова Герзула",
        ["Hezrul's Head (Provided)"] = "голова Герзула (видано)",
    },
    [853] = {
        ["Rendered Spores"] = "оброблені спори",
        ["Rendered Spores (Provided)"] = "оброблені спори (видано)",
    },
    [855] = {
        ["Centaur Bracers"] = "наручі кентаврів",
        ["Centaur Bracers (Provided)"] = "наручі кентаврів (видано)",
    },
    [857] = {
        ["Tear of the Moons"] = "Сльоза Місяця",
        ["Tear of the Moons (Provided)"] = "Сльоза Місяця (видано)",
    },
    [858] = {
        ["Ignition Key"] = "ключ запалювання",
        ["Ignition Key (Provided)"] = "ключ запалювання (видано)",
    },
    [861] = {
        ["Flatland Prowler Claw"] = "пазур рівнинного скрадача",
        ["Flatland Prowler Claw (Provided)"] = "пазур рівнинного скрадача (видано)",
    },
    [862] = {
        ["Dig Rat"] = "печерний щур",
        ["Dig Rat (Provided)"] = "печерний щур (видано)",
        ["Dig Rat slain"] = "печерний щур: убито",
    },
    [863] = {
        ["Escort Wizzlecrank out of the Venture Co. drill site"] = "Супроводжуйте Візлкранка з бурового майданчика ТзНБ \"Авантюра\"",
    },
    [864] = {
        ["Sealed Field Testing Kit"] = "запечатаний набір для польових досліджень",
        ["Sealed Field Testing Kit (Provided)"] = "запечатаний набір для польових досліджень (видано)",
    },
    [865] = {
        ["Intact Raptor Horn"] = "неушкоджений ріг раптора",
        ["Intact Raptor Horn (Provided)"] = "неушкоджений ріг раптора (видано)",
    },
    [866] = {
        ["Root Sample"] = "зразок кореня",
        ["Root Sample (Provided)"] = "зразок кореня (видано)",
    },
    [867] = {
        ["Witchwing Talon"] = "кіготь чарокрилої",
        ["Witchwing Talon (Provided)"] = "кіготь чарокрилої (видано)",
    },
    [868] = {
        ["Digging Claw"] = "рийний кіготь",
        ["Digging Claw (Provided)"] = "рийний кіготь (видано)",
        ["Silithid Egg"] = "яйце силітида",
        ["Silithid Egg (Provided)"] = "яйце силітида (видано)",
    },
    [869] = {
        ["Raptor Head"] = "голова раптора",
        ["Raptor Head (Provided)"] = "голова раптора (видано)",
    },
    [870] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Explore the waters of the Forgotten Pools"] = "Дослідіть води Забутих Пул",
    },
    [871] = {
        ["Razormane Hunter"] = "бритвогривий мисливець",
        ["Razormane Hunter slain"] = "бритвогривий мисливець: убито",
        ["Razormane Thornweaver"] = "бритвогривий терноткач",
        ["Razormane Thornweaver slain"] = "бритвогривий терноткач: убито",
        ["Razormane Water Seeker"] = "бритвогривий водошукач",
        ["Razormane Water Seeker slain"] = "бритвогривий водошукач: убито",
    },
    [872] = {
        ["Kreenig Snarlsnout's Tusk"] = "ікло Крініга Рилоскала",
        ["Kreenig Snarlsnout's Tusk (Provided)"] = "ікло Крініга Рилоскала (видано)",
        ["Razormane Defender"] = "бритвогривий захисник",
        ["Razormane Defender slain"] = "бритвогривий захисник: убито",
        ["Razormane Geomancer"] = "бритвогривий геомант",
        ["Razormane Geomancer slain"] = "бритвогривий геомант: убито",
    },
    [873] = {
        ["Heart of Isha Awak"] = "серце Іши Авака",
        ["Heart of Isha Awak (Provided)"] = "серце Іши Авака (видано)",
    },
    [875] = {
        ["Harpy Lieutenant Ring"] = "лейтенантський перстень гарпії",
        ["Harpy Lieutenant Ring (Provided)"] = "лейтенантський перстень гарпії (видано)",
    },
    [876] = {
        ["Serena's Head"] = "голова Серени",
        ["Serena's Head (Provided)"] = "голова Серени (видано)",
    },
    [877] = {
        ["Test the Dried Seeds"] = "Перевірте сушене насіння",
        ["Test the Dried Seeds (Provided)"] = "Перевірте сушене насіння (видано)",
        ["Test the Dried Seeds slain"] = "Перевірте сушене насіння: убито",
    },
    [878] = {
        ["Bristleback Geomancer"] = "щетиношкурий геомант",
        ["Bristleback Geomancer slain"] = "щетиношкурий геомант: убито",
        ["Bristleback Thornweaver"] = "щетиношкурий терноткач",
        ["Bristleback Thornweaver slain"] = "щетиношкурий терноткач: убито",
        ["Bristleback Water Seeker"] = "щетиношкурий водошукач",
        ["Bristleback Water Seeker slain"] = "щетиношкурий водошукач: убито",
    },
    [879] = {
        ["Kuz's Skull"] = "череп Каза",
        ["Kuz's Skull (Provided)"] = "череп Каза (видано)",
        ["Lok's Skull"] = "череп Лока",
        ["Lok's Skull (Provided)"] = "череп Лока (видано)",
        ["Nak's Skull"] = "череп Нака",
        ["Nak's Skull (Provided)"] = "череп Нака (видано)",
    },
    [880] = {
        ["Altered Snapjaw Shell"] = "панцир видозміненого тріскощелепа",
        ["Altered Snapjaw Shell (Provided)"] = "панцир видозміненого тріскощелепа (видано)",
    },
    [881] = {
        ["Echeyakee's Hide"] = "шкура Ечеякі",
        ["Echeyakee's Hide (Provided)"] = "шкура Ечеякі (видано)",
    },
    [882] = {
        ["Ishamuhale's Fang"] = "ікло Ішамугала",
        ["Ishamuhale's Fang (Provided)"] = "ікло Ішамугала (видано)",
    },
    [883] = {
        ["Hoof of Lakota'mani"] = "копито Лакота'мані",
        ["Hoof of Lakota'mani (Provided)"] = "копито Лакота'мані (видано)",
    },
    [884] = {
        ["Owatanka's Tailspike"] = "хвостовий шип Оватанки",
        ["Owatanka's Tailspike (Provided)"] = "хвостовий шип Оватанки (видано)",
    },
    [885] = {
        ["Washte Pawne's Feather"] = "перо Ваште Пауні",
        ["Washte Pawne's Feather (Provided)"] = "перо Ваште Пауні (видано)",
    },
    [887] = {
        ["Southsea Brigand"] = "грабіжник Південних морів",
        ["Southsea Brigand slain"] = "грабіжник Південних морів: убито",
        ["Southsea Cannoneer"] = "канонір Південних морів",
        ["Southsea Cannoneer slain"] = "канонір Південних морів: убито",
    },
    [888] = {
        ["Shipment of Boots"] = "партія черевиків",
        ["Shipment of Boots (Provided)"] = "партія черевиків (видано)",
        ["Telescopic Lens"] = "лінза для телескопа",
        ["Telescopic Lens (Provided)"] = "лінза для телескопа (видано)",
    },
    [889] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [890] = {
        ["Gazlowe's Ledger"] = "гросбух Ґазлоу",
        ["Gazlowe's Ledger (Provided)"] = "гросбух Ґазлоу (видано)",
    },
    [891] = {
        ["Theramore Medal"] = "медаль Терамору",
        ["Theramore Medal (Provided)"] = "медаль Терамору (видано)",
    },
    [892] = {
        ["Gazlowe's Ledger"] = "гросбух Ґазлоу",
        ["Gazlowe's Ledger (Provided)"] = "гросбух Ґазлоу (видано)",
    },
    [893] = {
        ["Charred Razormane Wand"] = "обгоріла паличка Бритвогривих",
        ["Charred Razormane Wand (Provided)"] = "обгоріла паличка Бритвогривих (видано)",
        ["Razormane Backstabber"] = "стилет Бритвогривих",
        ["Razormane Backstabber (Provided)"] = "стилет Бритвогривих (видано)",
        ["Razormane War Shield"] = "бойовий щит Бритвогривих",
        ["Razormane War Shield (Provided)"] = "бойовий щит Бритвогривих (видано)",
    },
    [894] = {
        ["Control Console Operating Manual"] = "інструкція з експлуатації панелі управління",
    },
    [895] = {
        ["Baron Longshore's Head"] = "голова барона Довгоберега",
        ["Baron Longshore's Head (Provided)"] = "голова барона Довгоберега (видано)",
    },
    [896] = {
        ["Cats Eye Emerald"] = "смарагд «Котяче око»",
        ["Cats Eye Emerald (Provided)"] = "смарагд «Котяче око» (видано)",
    },
    [897] = {
        ["Harvester's Head"] = "голова женця",
        ["Harvester's Head (Provided)"] = "голова женця (видано)",
    },
    [898] = {
        ["Escort Gilthares Firebough back to Ratchet"] = "Супровід Гілтереса Фаєрбауа назад до Ретчета",
    },
    [899] = {
        ["Bristleback Quilboar Tusk"] = "ікло щетиношкурого свинобраза",
        ["Bristleback Quilboar Tusk (Provided)"] = "ікло щетиношкурого свинобраза (видано)",
    },
    [900] = {
        ["Shut off Fuel Control Valve"] = "Вимкніть клапан регулювання палива",
        ["Shut off Fuel Control Valve (Provided)"] = "Вимкніть клапан регулювання палива (видано)",
        ["Shut off Fuel Control Valve slain"] = "Вимкніть клапан регулювання палива: убито",
        ["Shut off Main Control Valve"] = "Закрийте головний регулювальний клапан",
        ["Shut off Main Control Valve (Provided)"] = "Закрийте головний регулювальний клапан (видано)",
        ["Shut off Main Control Valve slain"] = "Закрийте головний регулювальний клапан: убито",
        ["Shut off Regulator Valve"] = "Запірний регуляторний клапан",
        ["Shut off Regulator Valve (Provided)"] = "Запірний регуляторний клапан (видано)",
        ["Shut off Regulator Valve slain"] = "Запірний регуляторний клапан: убито",
    },
    [901] = {
        ["Console Key"] = "ключ від панелі",
        ["Console Key (Provided)"] = "ключ від панелі (видано)",
    },
    [902] = {
        ["Samophlange"] = "самофланж",
        ["Samophlange (Provided)"] = "самофланж (видано)",
    },
    [903] = {
        ["Prowler Claws"] = "пазурі скрадача",
        ["Prowler Claws (Provided)"] = "пазурі скрадача (видано)",
    },
    [905] = {
        ["Visit Blue Raptor Nest"] = "Відвідайте гніздо блакитного хижака",
        ["Visit Blue Raptor Nest (Provided)"] = "Відвідайте гніздо блакитного хижака (видано)",
        ["Visit Blue Raptor Nest slain"] = "Відвідайте гніздо блакитного хижака: убито",
        ["Visit Red Raptor Nest"] = "Відвідайте гніздо червоного хижака",
        ["Visit Red Raptor Nest (Provided)"] = "Відвідайте гніздо червоного хижака (видано)",
        ["Visit Red Raptor Nest slain"] = "Відвідайте гніздо червоного хижака: убито",
        ["Visit Yellow Raptor Nest"] = "Відвідайте гніздо жовтого хижака",
        ["Visit Yellow Raptor Nest (Provided)"] = "Відвідайте гніздо жовтого хижака (видано)",
        ["Visit Yellow Raptor Nest slain"] = "Відвідайте гніздо жовтого хижака: убито",
    },
    [906] = {
        ["Lok's Skull"] = "череп Лока",
        ["Lok's Skull (Provided)"] = "череп Лока (видано)",
    },
    [907] = {
        ["Thunder Lizard Blood"] = "кров громоящера",
        ["Thunder Lizard Blood (Provided)"] = "кров громоящера (видано)",
    },
    [908] = {
        ["Fathom Core"] = "ядро глибин",
    },
    [909] = {
        ["Strange Water Globe"] = "дивна водяна куля",
        ["Strange Water Globe (Provided)"] = "дивна водяна куля (видано)",
    },
    [910] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the docks of Ratchet in the Barrens."] = "Ідіть до доків Ретчета в Степах.",
    },
    [911] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the Mor'shan Rampart in the Barrens."] = "Ідіть до валу Мор'шана в Степах.",
    },
    [913] = {
        ["Thunderhawk Wings"] = "крила громояструба",
        ["Thunderhawk Wings (Provided)"] = "крила громояструба (видано)",
    },
    [914] = {
        ["Gem of Anacondra"] = "самоцвіт Анакондри",
        ["Gem of Anacondra (Provided)"] = "самоцвіт Анакондри (видано)",
        ["Gem of Cobrahn"] = "самоцвіт Кобрана",
        ["Gem of Cobrahn (Provided)"] = "самоцвіт Кобрана (видано)",
        ["Gem of Pythas"] = "самоцвіт Пітонаса",
        ["Gem of Pythas (Provided)"] = "самоцвіт Пітонаса (видано)",
        ["Gem of Serpentis"] = "самоцвіт Серпентіса",
        ["Gem of Serpentis (Provided)"] = "самоцвіт Серпентіса (видано)",
    },
    [915] = {
        ["Tigule and Foror's Strawberry Ice Cream"] = "Полуничне морозиво від Тігуле та Форора",
        ["Tigule and Foror's Strawberry Ice Cream (Provided)"] = "Полуничне морозиво від Тігуле та Форора (видано)",
        ["Tigule and Foror's Strawberry Ice Cream slain"] = "Полуничне морозиво від Тігуле та Форора: убито",
    },
    [916] = {
        ["Webwood Venom Sac"] = "отруйна залоза павутиннолісих",
        ["Webwood Venom Sac (Provided)"] = "отруйна залоза павутиннолісих (видано)",
    },
    [917] = {
        ["Webwood Egg"] = "яйце павутиннолісих",
        ["Webwood Egg (Provided)"] = "яйце павутиннолісих (видано)",
    },
    [918] = {
        ["Timberling Seed"] = "насіння деревника",
        ["Timberling Seed (Provided)"] = "насіння деревника (видано)",
    },
    [919] = {
        ["Timberling Sprout"] = "паросток деревника",
        ["Timberling Sprout (Provided)"] = "паросток деревника (видано)",
    },
    [921] = {
        ["Filled Crystal Phial"] = "наповнений кришталевий фіал",
        ["Filled Crystal Phial (Provided)"] = "наповнений кришталевий фіал (видано)",
    },
    [922] = {
        ["Timberling Seed"] = "насіння деревника",
        ["Timberling Seed (Provided)"] = "насіння деревника (видано)",
    },
    [923] = {
        ["Mossy Tumor"] = "вкрита мохом пухлина",
        ["Mossy Tumor (Provided)"] = "вкрита мохом пухлина (видано)",
    },
    [924] = {
        ["Destroy the Demon Seed"] = "Знищити Насіння Демона",
        ["Destroy the Demon Seed (Provided)"] = "Знищити Насіння Демона (видано)",
        ["Destroy the Demon Seed slain"] = "Знищити Насіння Демона: убито",
    },
    [925] = {
        ["Cairne's Hoofprint"] = "відбиток копита Керна",
        ["Cairne's Hoofprint (Provided)"] = "відбиток копита Керна (видано)",
    },
    [927] = {
        ["Moss-twined Heart"] = "вкрите мохом серце",
        ["Moss-twined Heart (Provided)"] = "вкрите мохом серце (видано)",
    },
    [928] = {
        ["Partially Filled Vessel"] = "частково наповнена ємність",
        ["Partially Filled Vessel (Provided)"] = "частково наповнена ємність (видано)",
    },
    [929] = {
        ["Filled Jade Phial"] = "наповнений нефритовий фіал",
        ["Filled Jade Phial (Provided)"] = "наповнений нефритовий фіал (видано)",
    },
    [930] = {
        ["Glowing Fruit"] = "сяючий плід",
        ["Glowing Fruit (Provided)"] = "сяючий плід (видано)",
    },
    [931] = {
        ["Shimmering Frond"] = "мерехтливий паросток",
        ["Shimmering Frond (Provided)"] = "мерехтливий паросток (видано)",
    },
    [932] = {
        ["Melenas' Head"] = "голова Меленаса",
        ["Melenas' Head (Provided)"] = "голова Меленаса (видано)",
    },
    [933] = {
        ["Filled Tourmaline Phial"] = "наповнений турмаліновий фіал",
        ["Filled Tourmaline Phial (Provided)"] = "наповнений турмаліновий фіал (видано)",
    },
    [934] = {
        ["Vial of Blessed Water"] = "флакон з благословенною водою",
        ["Vial of Blessed Water (Provided)"] = "флакон з благословенною водою (видано)",
    },
    [935] = {
        ["Filled Vessel"] = "наповнений флакон",
        ["Filled Vessel (Provided)"] = "наповнений флакон (видано)",
    },
    [937] = {
        ["Bloodfeather Belt"] = "пояс Кривавоперих",
        ["Bloodfeather Belt (Provided)"] = "пояс Кривавоперих (видано)",
    },
    [938] = {
        ["Lead Mist safely to Sentinel Arynia Cloudsbreak"] = "Безпечно проведіть Туман до Вартової Аринії",
    },
    [939] = {
        ["Flute of Xavaric"] = "флейта Заваріка",
        ["Flute of Xavaric (Provided)"] = "флейта Заваріка (видано)",
        ["Jadefire Felbind"] = "нефритожарі пута скверни",
        ["Jadefire Felbind (Provided)"] = "нефритожарі пута скверни (видано)",
    },
    [940] = {
        ["Inscribed Bark"] = "вкрита написами кора",
        ["Inscribed Bark (Provided)"] = "вкрита написами кора (видано)",
    },
    [941] = {
        ["Tainted Heart"] = "заражене серце",
        ["Tainted Heart (Provided)"] = "заражене серце (видано)",
    },
    [942] = {
        ["Mysterious Fossil"] = "таємнича скам'янілість",
        ["Mysterious Fossil (Provided)"] = "таємнича скам'янілість (видано)",
    },
    [943] = {
        ["Flagongut's Fossil"] = "скам'янілість Флягопуза",
        ["Flagongut's Fossil (Provided)"] = "скам'янілість Флягопуза (видано)",
        ["Stone of Relu"] = "камінь Релу",
        ["Stone of Relu (Provided)"] = "камінь Релу (видано)",
    },
    [944] = {
        ["Enter the Master's Glaive"] = "Входить Глефа Майстра",
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [945] = {
        ["Escort Therylune away from the Master's Glaive"] = "Супроводьте Терілуну подалі від Глефи Майстра",
    },
    [947] = {
        ["Death Cap"] = "мертвошляпка",
        ["Death Cap (Provided)"] = "мертвошляпка (видано)",
        ["Scaber Stalk"] = "лусконіжка",
        ["Scaber Stalk (Provided)"] = "лусконіжка (видано)",
    },
    [950] = {
        ["Insane Scribbles"] = "божевільні письмена",
        ["Insane Scribbles (Provided)"] = "божевільні письмена (видано)",
    },
    [951] = {
        ["Mathystra Relic"] = "реліквія Матистри",
        ["Mathystra Relic (Provided)"] = "реліквія Матистри (видано)",
    },
    [952] = {
        ["Fandral's Message"] = "повідомлення Фендрала",
        ["Fandral's Message (Provided)"] = "повідомлення Фендрала (видано)",
    },
    [953] = {
        ["Read the Fall of Ameth'Aran"] = "Прочитайте «Падіння Амет'Арана»",
        ["Read the Fall of Ameth'Aran (Provided)"] = "Прочитайте «Падіння Амет'Арана» (видано)",
        ["Read the Fall of Ameth'Aran slain"] = "Прочитайте «Падіння Амет'Арана»: убито",
        ["Read the Lay of Ameth'Aran"] = "Прочитайте «Песню про Амет'Аран»",
        ["Read the Lay of Ameth'Aran (Provided)"] = "Прочитайте «Песню про Амет'Аран» (видано)",
        ["Read the Lay of Ameth'Aran slain"] = "Прочитайте «Песню про Амет'Аран»: убито",
    },
    [955] = {
        ["Grell Earring"] = "сережка грела",
        ["Grell Earring (Provided)"] = "сережка грела (видано)",
    },
    [956] = {
        ["Ancient Moonstone Seal"] = "древня печатка місячного каменю",
        ["Ancient Moonstone Seal (Provided)"] = "древня печатка місячного каменю (видано)",
    },
    [957] = {
        ["Destroy the seal at the ancient flame"] = "Знищи печатку біля стародавнього полум'я",
        ["Destroy the seal at the ancient flame (Provided)"] = "Знищи печатку біля стародавнього полум'я (видано)",
        ["Destroy the seal at the ancient flame slain"] = "Знищи печатку біля стародавнього полум'я: убито",
    },
    [958] = {
        ["Highborne Relic"] = "реліквія високородних",
        ["Highborne Relic (Provided)"] = "реліквія високородних (видано)",
    },
    [959] = {
        ["99-Year-Old Port"] = "99-річний портвейн",
        ["99-Year-Old Port (Provided)"] = "99-річний портвейн (видано)",
    },
    [962] = {
        ["Serpentbloom"] = "змієквіт",
        ["Serpentbloom (Provided)"] = "змієквіт (видано)",
    },
    [963] = {
        ["Anaya's Pendant"] = "кулон Анайї",
        ["Anaya's Pendant (Provided)"] = "кулон Анайї (видано)",
    },
    [964] = {
        ["Skeletal Fragments"] = "фрагменти скелетів",
        ["Skeletal Fragments (Provided)"] = "фрагменти скелетів (видано)",
    },
    [966] = {
        ["Worn Parchment"] = "потертий пергамент",
        ["Worn Parchment (Provided)"] = "потертий пергамент (видано)",
    },
    [967] = {
        ["Letter to Delgren"] = "лист до Дельґрена",
        ["Letter to Delgren (Provided)"] = "лист до Дельґрена (видано)",
    },
    [968] = {
        ["Book: The Powers Below"] = "книга \"Сили підземні\"",
        ["Book: The Powers Below (Provided)"] = "книга \"Сили підземні\" (видано)",
    },
    [969] = {
        ["Frostmaul Shards"] = "уламки кригобоїв",
        ["Frostmaul Shards (Provided)"] = "уламки кригобоїв (видано)",
    },
    [970] = {
        ["Glowing Soul Gem"] = "сяючий камінь душі",
        ["Glowing Soul Gem (Provided)"] = "сяючий камінь душі (видано)",
    },
    [971] = {
        ["Lorgalis Manuscript"] = "манускрипт Лорґаліса",
        ["Lorgalis Manuscript (Provided)"] = "манускрипт Лорґаліса (видано)",
    },
    [973] = {
        ["Ilkrud Magthrull's Tome"] = "фоліант Ілкруда Маґтрулла",
        ["Ilkrud Magthrull's Tome (Provided)"] = "фоліант Ілкруда Маґтрулла (видано)",
    },
    [974] = {
        ["Find the hottest area of Fire Plume Ridge"] = "Знайдіть найгарячіший район Фаєр-Плюм-Рідж",
        ["Krakle's Thermometer"] = "термометр Кракла",
        ["Krakle's Thermometer (Provided)"] = "термометр Кракла (видано)",
    },
    [976] = {
        ["Protect Feero Ironhand"] = "Захистіть Фіеро Залізну Руку",
    },
    [977] = {
        ["Pristine Yeti Horn"] = "бездоганний ріг єті",
        ["Pristine Yeti Horn (Provided)"] = "бездоганний ріг єті (видано)",
    },
    [978] = {
        ["Moontouched Feather"] = "осяяне місяцем перо",
        ["Moontouched Feather (Provided)"] = "осяяне місяцем перо (видано)",
    },
    [982] = {
        ["Mist Veil's Lockbox"] = "скринька \"Туманного Серпанку\"",
        ["Mist Veil's Lockbox (Provided)"] = "скринька \"Туманного Серпанку\" (видано)",
        ["Silver Dawning's Lockbox"] = "скринька \"Сріблястої Зорі\"",
        ["Silver Dawning's Lockbox (Provided)"] = "скринька \"Сріблястої Зорі\" (видано)",
    },
    [983] = {
        ["Crawler Leg"] = "нога повзуна",
        ["Crawler Leg (Provided)"] = "нога повзуна (видано)",
    },
    [984] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Find a corrupt furbolg camp"] = "Знайдіть корумпований табір фурболгів",
    },
    [985] = {
        ["Blackwood Pathfinder"] = "чорнолісний слідопит",
        ["Blackwood Pathfinder slain"] = "чорнолісний слідопит: убито",
        ["Blackwood Windtalker"] = "чорнолісний вітробай",
        ["Blackwood Windtalker slain"] = "чорнолісний вітробай: убито",
    },
    [986] = {
        ["Fine Moonstalker Pelt"] = "чудова шкура місяцескрада",
        ["Fine Moonstalker Pelt (Provided)"] = "чудова шкура місяцескрада (видано)",
    },
    [992] = {
        ["Tapped Dowsing Widget"] = "використаний пристрій для пошуку води",
        ["Tapped Dowsing Widget (Provided)"] = "використаний пристрій для пошуку води (видано)",
    },
    [993] = {
        ["Enchanted Moonstalker Cloak"] = "зачарований плащ місяцескрада",
        ["Enchanted Moonstalker Cloak (Provided)"] = "зачарований плащ місяцескрада (видано)",
    },
    [994] = {
        ["Help Volcor to the road"] = "Допоможіть Волкору в дорогу",
    },
    [995] = {
        ["Help Volcor escape the cave"] = "Допоможіть Волкору вибратися з печери",
    },
    [996] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [997] = {
        ["Rare Earth"] = "рідкісна земля",
        ["Rare Earth (Provided)"] = "рідкісна земля (видано)",
    },
    [998] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [1001] = {
        ["Thresher Eye"] = "око молотника",
        ["Thresher Eye (Provided)"] = "око молотника (видано)",
    },
    [1002] = {
        ["Moonstalker Fang"] = "ікло місяцескрада",
        ["Moonstalker Fang (Provided)"] = "ікло місяцескрада (видано)",
    },
    [1003] = {
        ["Grizzled Scalp"] = "посивілий скальп",
        ["Grizzled Scalp (Provided)"] = "посивілий скальп (видано)",
    },
    [1007] = {
        ["Ancient Statuette"] = "стародавня статуетка",
        ["Ancient Statuette (Provided)"] = "стародавня статуетка (видано)",
    },
    [1008] = {
        ["Wrathtail Head"] = "голова гнівохвостої наги",
        ["Wrathtail Head (Provided)"] = "голова гнівохвостої наги (видано)",
    },
    [1009] = {
        ["Ring of Zoram"] = "зорамський перстень",
        ["Ring of Zoram (Provided)"] = "зорамський перстень (видано)",
    },
    [1010] = {
        ["Bathran's Hair"] = "батранове волосся",
        ["Bathran's Hair (Provided)"] = "батранове волосся (видано)",
    },
    [1011] = {
        ["Bottle of Disease"] = "пляшка пошесті",
        ["Bottle of Disease (Provided)"] = "пляшка пошесті (видано)",
    },
    [1012] = {
        ["Mavoris Cloudsbreak"] = "Маворіс Хмаролом",
        ["Mavoris Cloudsbreak slain"] = "Маворіс Хмаролом: убито",
        ["Taneel Darkwood"] = "Таніл Темноліс",
        ["Taneel Darkwood slain"] = "Таніл Темноліс: убито",
        ["Uthil Mooncall"] = "Утіл Місяцезов",
        ["Uthil Mooncall slain"] = "Утіл Місяцезов: убито",
    },
    [1013] = {
        ["The Book of Ur"] = "книга Ура",
        ["The Book of Ur (Provided)"] = "книга Ура (видано)",
    },
    [1014] = {
        ["Head of Arugal"] = "голова Аруґала",
        ["Head of Arugal (Provided)"] = "голова Аруґала (видано)",
    },
    [1016] = {
        ["Divined Scroll"] = "сувій з провіщенням",
        ["Divined Scroll (Provided)"] = "сувій з провіщенням (видано)",
    },
    [1017] = {
        ["Sarilus Foulborne's Head"] = "голова Сарілуса Гидкородного",
        ["Sarilus Foulborne's Head (Provided)"] = "голова Сарілуса Гидкородного (видано)",
    },
    [1020] = {
        ["Orendil's Cure"] = "ліки Оренділа",
        ["Orendil's Cure (Provided)"] = "ліки Оренділа (видано)",
    },
    [1022] = {
        ["View the Tome of Mel'Thandris"] = "Перегляньте фоліант Мел'Тандріса",
    },
    [1023] = {
        ["Glowing Gem"] = "сяючий самоцвіт",
        ["Glowing Gem (Provided)"] = "сяючий самоцвіт (видано)",
    },
    [1024] = {
        ["Glowing Gem"] = "сяючий самоцвіт",
        ["Glowing Gem (Provided)"] = "сяючий самоцвіт (видано)",
    },
    [1025] = {
        ["Foulweald Den Watcher"] = "гидколісний наглядач лігва",
        ["Foulweald Den Watcher slain"] = "гидколісний наглядач лігва: убито",
        ["Foulweald Totemic"] = "гидколісний тотеміст",
        ["Foulweald Totemic slain"] = "гидколісний тотеміст: убито",
        ["Foulweald Ursa"] = "гидколісний урса",
        ["Foulweald Ursa slain"] = "гидколісний урса: убито",
        ["Foulweald Warrior"] = "гидколісний воїн",
        ["Foulweald Warrior slain"] = "гидколісний воїн: убито",
    },
    [1026] = {
        ["Iron Shaft"] = "залізне руків'я",
        ["Iron Shaft (Provided)"] = "залізне руків'я (видано)",
    },
    [1027] = {
        ["Iron Pommel"] = "залізне навершя",
        ["Iron Pommel (Provided)"] = "залізне навершя (видано)",
    },
    [1028] = {
        ["Reconstructed Rod"] = "відтворений жезл",
        ["Reconstructed Rod (Provided)"] = "відтворений жезл (видано)",
    },
    [1029] = {
        ["Dartol's Rod of Transformation"] = "жезл трансформації Дартола",
    },
    [1030] = {
        ["Dartol's Rod of Transformation"] = "жезл трансформації Дартола",
    },
    [1031] = {
        ["Branch of Cenarius"] = "гілка Кенарія",
        ["Branch of Cenarius (Provided)"] = "гілка Кенарія (видано)",
    },
    [1032] = {
        ["Satyr Horns"] = "роги сатира",
        ["Satyr Horns (Provided)"] = "роги сатира (видано)",
    },
    [1033] = {
        ["Elune's Tear"] = "сльоза Елуни",
        ["Elune's Tear (Provided)"] = "сльоза Елуни (видано)",
    },
    [1034] = {
        ["Handful of Stardust"] = "жменя зорепилу",
        ["Handful of Stardust (Provided)"] = "жменя зорепилу (видано)",
    },
    [1035] = {
        ["Fallen Moonstone"] = "впалий місячний камінь",
        ["Fallen Moonstone (Provided)"] = "впалий місячний камінь (видано)",
    },
    [1036] = {
        ["3000 reputation with Bloodsail Buccaneers"] = "3000 репутації у Піратів Кривавого Парусу",
    },
    [1038] = {
        ["Velinde's Journal"] = "щоденник Велінди",
        ["Velinde's Journal (Provided)"] = "щоденник Велінди (видано)",
        ["Velinde's Key"] = "ключ Велінди",
        ["Velinde's Key (Provided)"] = "ключ Велінди (видано)",
    },
    [1043] = {
        ["Find evidence of the Scythe of Elune"] = "Знайдіть докази існування Коси Елуни",
    },
    [1045] = {
        ["Bloodtooth Guard"] = "кривавозубий вартовий",
        ["Bloodtooth Guard slain"] = "кривавозубий вартовий: убито",
        ["Ran Bloodtooth"] = "Ран Кривавозубий",
        ["Ran Bloodtooth slain"] = "Ран Кривавозубий: убито",
    },
    [1046] = {
        ["Dartol's Rod of Transformation"] = "жезл трансформації Дартола",
        ["Dartol's Rod of Transformation (Provided)"] = "жезл трансформації Дартола (видано)",
        ["Ran Bloodtooth's Skull"] = "череп Рана Кривавозубого",
        ["Ran Bloodtooth's Skull (Provided)"] = "череп Рана Кривавозубого (видано)",
    },
    [1048] = {
        ["Herod"] = "Ірод",
        ["Herod (Provided)"] = "Ірод (видано)",
        ["Herod slain"] = "Ірод: убито",
        ["High Inquisitor Whitemane"] = "Верховний інквізитор Вайтмейн",
        ["High Inquisitor Whitemane (Provided)"] = "Верховний інквізитор Вайтмейн (видано)",
        ["High Inquisitor Whitemane slain"] = "Верховний інквізитор Вайтмейн: убито",
        ["Houndmaster Loksey"] = "псар Локсі",
        ["Houndmaster Loksey slain"] = "псар Локсі: убито",
        ["Scarlet Commander Mograine"] = "командир Багряного Походу Моґрейн",
        ["Scarlet Commander Mograine slain"] = "командир Багряного Походу Моґрейн: убито",
    },
    [1049] = {
        ["Compendium of the Fallen"] = "Компендіум полеглих",
        ["Compendium of the Fallen (Provided)"] = "Компендіум полеглих (видано)",
    },
    [1050] = {
        ["Mythology of the Titans"] = "Мітологія титанів",
        ["Mythology of the Titans (Provided)"] = "Мітологія титанів (видано)",
    },
    [1051] = {
        ["Vorrel's Wedding Ring"] = "обручка Воррела",
        ["Vorrel's Wedding Ring (Provided)"] = "обручка Воррела (видано)",
    },
    [1052] = {
        ["Letter of Commendation"] = "рекомендаційний лист",
        ["Letter of Commendation (Provided)"] = "рекомендаційний лист (видано)",
    },
    [1053] = {
        ["Herod"] = "Ірод",
        ["Herod (Provided)"] = "Ірод (видано)",
        ["Herod slain"] = "Ірод: убито",
        ["High Inquisitor Whitemane"] = "Верховний інквізитор Вайтмейн",
        ["High Inquisitor Whitemane (Provided)"] = "Верховний інквізитор Вайтмейн (видано)",
        ["High Inquisitor Whitemane slain"] = "Верховний інквізитор Вайтмейн: убито",
        ["Houndmaster Loksey"] = "псар Локсі",
        ["Houndmaster Loksey slain"] = "псар Локсі: убито",
        ["Scarlet Commander Mograine"] = "командир Багряного Походу Моґрейн",
        ["Scarlet Commander Mograine slain"] = "командир Багряного Походу Моґрейн: убито",
    },
    [1054] = {
        ["Dal Bloodclaw's Skull"] = "череп Дала Кровопазура",
        ["Dal Bloodclaw's Skull (Provided)"] = "череп Дала Кровопазура (видано)",
    },
    [1057] = {
        ["Bloodfury Ambusher"] = "криваволюта душителька",
        ["Bloodfury Ambusher slain"] = "криваволюта душителька: убито",
        ["Bloodfury Harpy"] = "криваволюта гарпія",
        ["Bloodfury Harpy slain"] = "криваволюта гарпія: убито",
        ["Bloodfury Roguefeather"] = "криваволюта оперена пройдисвітка",
        ["Bloodfury Roguefeather slain"] = "криваволюта оперена пройдисвітка: убито",
        ["Bloodfury Slayer"] = "криваволюта вбивця",
        ["Bloodfury Slayer slain"] = "криваволюта вбивця: убито",
    },
    [1058] = {
        ["Courser Eye"] = "око оленя",
        ["Courser Eye (Provided)"] = "око оленя (видано)",
        ["Fey Dragon Scale"] = "луска чародракончика",
        ["Fey Dragon Scale (Provided)"] = "луска чародракончика (видано)",
        ["Stonetalon Sap"] = "каміннопазуриста живиця",
        ["Stonetalon Sap (Provided)"] = "каміннопазуриста живиця (видано)",
        ["Twilight Whisker"] = "сутінковий вус",
        ["Twilight Whisker (Provided)"] = "сутінковий вус (видано)",
    },
    [1060] = {
        ["Letter to Jin'Zil"] = "лист для Джин'Зіла",
        ["Letter to Jin'Zil (Provided)"] = "лист для Джин'Зіла (видано)",
    },
    [1062] = {
        ["Venture Co. Logger"] = "лісоруб ТзНБ \"Авантюра\"",
        ["Venture Co. Logger slain"] = "лісоруб ТзНБ \"Авантюра\": убито",
    },
    [1065] = {
        ["Zamah's Note"] = "записка Зами",
        ["Zamah's Note (Provided)"] = "записка Зами (видано)",
    },
    [1066] = {
        ["Vial of Innocent Blood"] = "флакон крові невинних",
        ["Vial of Innocent Blood (Provided)"] = "флакон крові невинних (видано)",
    },
    [1067] = {
        ["Lydon's Toxin"] = "токсин Лідона",
        ["Lydon's Toxin (Provided)"] = "токсин Лідона (видано)",
    },
    [1068] = {
        ["XT:4"] = "ХТ:4",
        ["XT:4 slain"] = "ХТ:4: убито",
        ["XT:9"] = "ХТ:9",
        ["XT:9 slain"] = "ХТ:9: убито",
    },
    [1069] = {
        ["Deepmoss Egg"] = "яйце мохового павука",
        ["Deepmoss Egg (Provided)"] = "яйце мохового павука (видано)",
    },
    [1071] = {
        ["Venture Co. Deforester"] = "лісозаготівельник ТзНБ \"Авантюра\"",
        ["Venture Co. Deforester slain"] = "лісозаготівельник ТзНБ \"Авантюра\": убито",
        ["Venture Co. Logger"] = "лісоруб ТзНБ \"Авантюра\"",
        ["Venture Co. Logger slain"] = "лісоруб ТзНБ \"Авантюра\": убито",
    },
    [1073] = {
        ["Elixir of Minor Fortitude"] = "крихітний еліксир стійкості",
        ["Elixir of Minor Fortitude (Provided)"] = "крихітний еліксир стійкості (видано)",
        ["Minor Mana Potion"] = "крихітне зілля мани",
        ["Minor Mana Potion (Provided)"] = "крихітне зілля мани (видано)",
    },
    [1074] = {
        ["NG-5"] = "НГ-5",
        ["NG-5 (Provided)"] = "НГ-5 (видано)",
    },
    [1076] = {
        ["Dust Devil Debris"] = "уламки пилового дідька",
        ["Dust Devil Debris (Provided)"] = "уламки пилового дідька (видано)",
    },
    [1077] = {
        ["Scroll of Messaging"] = "сувій повідомлення",
        ["Scroll of Messaging (Provided)"] = "сувій повідомлення (видано)",
    },
    [1078] = {
        ["Crystalized Scales"] = "кристалічна луска",
        ["Crystalized Scales (Provided)"] = "кристалічна луска (видано)",
    },
    [1079] = {
        ["Venture Co. Engineering Plans"] = "інженерні креслення ТзНБ \"Авантюра\"",
        ["Venture Co. Engineering Plans (Provided)"] = "інженерні креслення ТзНБ \"Авантюра\" (видано)",
    },
    [1080] = {
        ["Venture Co. Letters"] = "документи ТзНБ \"Авантюра\"",
        ["Venture Co. Letters (Provided)"] = "документи ТзНБ \"Авантюра\" (видано)",
    },
    [1083] = {
        ["Smoldering Embers"] = "тліюча вуглинка",
        ["Smoldering Embers (Provided)"] = "тліюча вуглинка (видано)",
    },
    [1084] = {
        ["Corroded Shrapnel"] = "іржава шрапнель",
        ["Corroded Shrapnel (Provided)"] = "іржава шрапнель (видано)",
    },
    [1086] = {
        ["Place the Toxic Fogger"] = "Розмістіть токсичний фумігатор",
    },
    [1087] = {
        ["Cenarion Botanist"] = "кенарійський ботанік",
        ["Cenarion Botanist slain"] = "кенарійський ботанік: убито",
        ["Daughter of Cenarius"] = "Дочка Кенарія",
        ["Daughter of Cenarius (Provided)"] = "Дочка Кенарія (видано)",
        ["Daughter of Cenarius slain"] = "Дочка Кенарія: убито",
        ["Son of Cenarius"] = "Син Кенарія",
        ["Son of Cenarius (Provided)"] = "Син Кенарія (видано)",
        ["Son of Cenarius slain"] = "Син Кенарія: убито",
    },
    [1088] = {
        ["Ordanus' Head"] = "голова Ордана",
        ["Ordanus' Head (Provided)"] = "голова Ордана (видано)",
    },
    [1089] = {
        ["Barrow Key"] = "ключ прихистку",
        ["Barrow Key (Provided)"] = "ключ прихистку (видано)",
        ["Claw Key"] = "ключ пазура",
        ["Claw Key (Provided)"] = "ключ пазура (видано)",
        ["Sleepers' Key"] = "ключ сплячих",
        ["Sleepers' Key (Provided)"] = "ключ сплячих (видано)",
    },
    [1090] = {
        ["Keep Piznik safe while he mines the mysterious ore"] = "Захистіть Пізніка, поки він видобуває таємничу руду.",
    },
    [1091] = {
        ["Venture Co. Letters"] = "документи ТзНБ \"Авантюра\"",
        ["Venture Co. Letters (Provided)"] = "документи ТзНБ \"Авантюра\" (видано)",
    },
    [1092] = {
        ["Unidentified Ore"] = "невідома руда",
        ["Unidentified Ore (Provided)"] = "невідома руда (видано)",
    },
    [1093] = {
        ["Super Reaper 6000 Blueprints"] = "креслення Супер дереворуба 6000",
        ["Super Reaper 6000 Blueprints (Provided)"] = "креслення Супер дереворуба 6000 (видано)",
    },
    [1094] = {
        ["Sealed Envelope"] = "запечатаний конверт",
        ["Sealed Envelope (Provided)"] = "запечатаний конверт (видано)",
    },
    [1096] = {
        ["Gerenzo's Mechanical Arm"] = "механічна рука Ґерензо",
        ["Gerenzo's Mechanical Arm (Provided)"] = "механічна рука Ґерензо (видано)",
    },
    [1099] = {
        ["Goblin Race Ticket"] = "квиток на перегони гоблінів",
    },
    [1100] = {
        ["Lonebrow's Journal"] = "щоденник Однобрового",
        ["Lonebrow's Journal (Provided)"] = "щоденник Однобрового (видано)",
    },
    [1101] = {
        ["Razorflank's Medallion"] = "медальйон Бритвобокої",
        ["Razorflank's Medallion (Provided)"] = "медальйон Бритвобокої (видано)",
    },
    [1102] = {
        ["Razorflank's Heart"] = "серце Бритвобокої",
        ["Razorflank's Heart (Provided)"] = "серце Бритвобокої (видано)",
    },
    [1103] = {
        ["Water Sapta"] = "сапта води",
        ["Water Sapta (Provided)"] = "сапта води (видано)",
    },
    [1104] = {
        ["Salty Scorpid Venom"] = "солона отрута скорпіда",
        ["Salty Scorpid Venom (Provided)"] = "солона отрута скорпіда (видано)",
    },
    [1105] = {
        ["Hardened Tortoise Shell"] = "міцний черепашачий панцир",
        ["Hardened Tortoise Shell (Provided)"] = "міцний черепашачий панцир (видано)",
    },
    [1106] = {
        ["Fizzle Brassbolts' Letter"] = "лист Фіззла Латуноболта",
        ["Fizzle Brassbolts' Letter (Provided)"] = "лист Фіззла Латуноболта (видано)",
    },
    [1107] = {
        ["Encrusted Tail Fin"] = "вкритий сіллю хвостовий плавник",
        ["Encrusted Tail Fin (Provided)"] = "вкритий сіллю хвостовий плавник (видано)",
    },
    [1108] = {
        ["Indurium Flake"] = "шматок індурію",
        ["Indurium Flake (Provided)"] = "шматок індурію (видано)",
    },
    [1109] = {
        ["Kraul Guano"] = "гуано краальського кажана",
        ["Kraul Guano (Provided)"] = "гуано краальського кажана (видано)",
    },
    [1110] = {
        ["Rocket Car Parts"] = "деталі боліда",
        ["Rocket Car Parts (Provided)"] = "деталі боліда (видано)",
    },
    [1111] = {
        ["Kravel's Parts Order"] = "замовлення запчастин Крейвела",
        ["Kravel's Parts Order (Provided)"] = "замовлення запчастин Крейвела (видано)",
    },
    [1112] = {
        ["Kravel's Parts"] = "запчастини Крейвела",
        ["Kravel's Parts (Provided)"] = "запчастини Крейвела (видано)",
    },
    [1113] = {
        ["Heart of Zeal"] = "ревнісне серце",
        ["Heart of Zeal (Provided)"] = "ревнісне серце (видано)",
    },
    [1114] = {
        ["Delicate Car Parts"] = "крихкі запчастини для машини",
        ["Delicate Car Parts (Provided)"] = "крихкі запчастини для машини (видано)",
    },
    [1116] = {
        ["Speck of Dream Dust"] = "дрібка пудри блаженства",
        ["Speck of Dream Dust (Provided)"] = "дрібка пудри блаженства (видано)",
    },
    [1117] = {
        ["Goblin Rumors"] = "гоблінські чутки",
        ["Goblin Rumors (Provided)"] = "гоблінські чутки (видано)",
    },
    [1118] = {
        ["Kravel's Scheme"] = "план Крейвела",
        ["Kravel's Scheme (Provided)"] = "план Крейвела (видано)",
    },
    [1119] = {
        ["Fool's Stout"] = "Йолопиво",
        ["Fool's Stout (Provided)"] = "Йолопиво (видано)",
    },
    [1120] = {
        ["Fool's Stout"] = "Йолопиво",
        ["Fool's Stout (Provided)"] = "Йолопиво (видано)",
    },
    [1121] = {
        ["Fool's Stout"] = "Йолопиво",
        ["Fool's Stout (Provided)"] = "Йолопиво (видано)",
    },
    [1122] = {
        ["Fool's Stout Report"] = "звіт про \"Йолопиво\"",
        ["Fool's Stout Report (Provided)"] = "звіт про \"Йолопиво\" (видано)",
    },
    [1124] = {
        ["Rabine's Letter"] = "лист Рабіна",
        ["Rabine's Letter (Provided)"] = "лист Рабіна (видано)",
    },
    [1125] = {
        ["Tortured Druid"] = "закатований друїд",
        ["Tortured Druid slain"] = "закатований друїд: убито",
        ["Tortured Sentinel"] = "закатована вартова",
        ["Tortured Sentinel slain"] = "закатована вартова: убито",
    },
    [1126] = {
        ["Encrusted Silithid Object"] = "вкрита хітином річ",
        ["Encrusted Silithid Object (Provided)"] = "вкрита хітином річ (видано)",
    },
    [1127] = {
        ["Zanzil's Mixture"] = "суміш Занзіла",
        ["Zanzil's Mixture (Provided)"] = "суміш Занзіла (видано)",
    },
    [1131] = {
        ["Steelsnap's Rib"] = "ребро Сталекуса",
        ["Steelsnap's Rib (Provided)"] = "ребро Сталекуса (видано)",
    },
    [1134] = {
        ["Pridewing Venom Sac"] = "отруйна залоза гордокрила",
        ["Pridewing Venom Sac (Provided)"] = "отруйна залоза гордокрила (видано)",
    },
    [1135] = {
        ["Highperch Venom Sac"] = "отруйна залоза Високого Сідала",
        ["Highperch Venom Sac (Provided)"] = "отруйна залоза Високого Сідала (видано)",
    },
    [1136] = {
        ["Frostmaw's Mane"] = "грива Кригопащі",
        ["Frostmaw's Mane (Provided)"] = "грива Кригопащі (видано)",
    },
    [1138] = {
        ["Fine Crab Chunks"] = "чудове крабове м'ясо",
        ["Fine Crab Chunks (Provided)"] = "чудове крабове м'ясо (видано)",
    },
    [1139] = {
        ["Tablet of Will"] = "скрижаль волі",
        ["Tablet of Will (Provided)"] = "скрижаль волі (видано)",
    },
    [1140] = {
        ["Free the Highborne soul in Night Run"] = "Звільніть душу Високонароджених у Нічному забігу",
        ["Free the Highborne soul in Night Run (Provided)"] = "Звільніть душу Високонароджених у Нічному забігу (видано)",
        ["Free the Highborne soul in Night Run slain"] = "Звільніть душу Високонароджених у Нічному забігу: убито",
        ["Free the Highborne soul in Satyrnaar"] = "Звільніть душу Високонароджених у Сатирнаарі",
        ["Free the Highborne soul in Satyrnaar (Provided)"] = "Звільніть душу Високонароджених у Сатирнаарі (видано)",
        ["Free the Highborne soul in Satyrnaar slain"] = "Звільніть душу Високонароджених у Сатирнаарі: убито",
    },
    [1141] = {
        ["Darkshore Grouper"] = "окунь Темнобережжя",
        ["Darkshore Grouper (Provided)"] = "окунь Темнобережжя (видано)",
    },
    [1142] = {
        ["Treshala's Pendant"] = "кулон Трешали",
        ["Treshala's Pendant (Provided)"] = "кулон Трешали (видано)",
    },
    [1143] = {
        ["Athrikus Narassin's Head"] = "голова Атріка Нарассіна",
        ["Athrikus Narassin's Head (Provided)"] = "голова Атріка Нарассіна (видано)",
    },
    [1144] = {
        ["Help Willix the Importer escape from Razorfen Kraul"] = "Допоможіть Вілліксу-імпортеру втекти з Краула Розорфена",
    },
    [1145] = {
        ["Korran's Sealed Note"] = "запечатана записка Коррана",
        ["Korran's Sealed Note (Provided)"] = "запечатана записка Коррана (видано)",
    },
    [1146] = {
        ["Belgrom's Sealed Note"] = "запечатана записка Белґрома",
        ["Belgrom's Sealed Note (Provided)"] = "запечатана записка Белґрома (видано)",
    },
    [1147] = {
        ["Silithid Hive Drone"] = "силітид-трутень",
        ["Silithid Hive Drone slain"] = "силітид-трутень: убито",
        ["Silithid Invader"] = "силітид-загарбник",
        ["Silithid Invader slain"] = "силітид-загарбник: убито",
        ["Silithid Searcher"] = "силітид-шукач",
        ["Silithid Searcher slain"] = "силітид-шукач: убито",
    },
    [1148] = {
        ["Intact Silithid Carapace"] = "неушкоджений панцир силітида",
        ["Intact Silithid Carapace (Provided)"] = "неушкоджений панцир силітида (видано)",
        ["Silithid Heart"] = "серце силітида",
        ["Silithid Heart (Provided)"] = "серце силітида (видано)",
        ["Silithid Talon"] = "кіготь силітида",
        ["Silithid Talon (Provided)"] = "кіготь силітида (видано)",
    },
    [1149] = {
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [1150] = {
        ["Grenka's Claw"] = "кіготь Ґренки",
        ["Grenka's Claw (Provided)"] = "кіготь Ґренки (видано)",
    },
    [1151] = {
        ["Fragments of Rok'Alim"] = "фрагменти Рок'аліма",
        ["Fragments of Rok'Alim (Provided)"] = "фрагменти Рок'аліма (видано)",
    },
    [1153] = {
        ["Unrefined Ore Sample"] = "неочищений зразок руди",
        ["Unrefined Ore Sample (Provided)"] = "неочищений зразок руди (видано)",
    },
    [1154] = {
        ["Legacy of the Aspects"] = "Спадщина Аспектів",
        ["Legacy of the Aspects (Provided)"] = "Спадщина Аспектів (видано)",
    },
    [1160] = {
        ["Beginnings of the Undead Threat"] = "Джерела загрози невмерлих",
        ["Beginnings of the Undead Threat (Provided)"] = "Джерела загрози невмерлих (видано)",
    },
    [1164] = {
        ["Fardel's Head"] = "голова Фардела",
        ["Fardel's Head (Provided)"] = "голова Фардела (видано)",
        ["Kenata's Head"] = "голова Кенати",
        ["Kenata's Head (Provided)"] = "голова Кенати (видано)",
        ["Marcel's Head"] = "голова Марселя",
        ["Marcel's Head (Provided)"] = "голова Марселя (видано)",
    },
    [1166] = {
        ["Mok'Morokk's Grog"] = "грог Мок'Морокка",
        ["Mok'Morokk's Grog (Provided)"] = "грог Мок'Морокка (видано)",
        ["Mok'Morokk's Snuff"] = "тютюн Мок'Морокка",
        ["Mok'Morokk's Snuff (Provided)"] = "тютюн Мок'Морокка (видано)",
        ["Mok'Morokk's Strongbox"] = "сейф Мок'Морокка",
        ["Mok'Morokk's Strongbox (Provided)"] = "сейф Мок'Морокка (видано)",
    },
    [1168] = {
        ["Firemane Ash Tail"] = "вогнегрива попелехвостка",
        ["Firemane Ash Tail slain"] = "вогнегрива попелехвостка: убито",
        ["Firemane Scalebane"] = "вогнегривий лускоклят",
        ["Firemane Scalebane slain"] = "вогнегривий лускоклят: убито",
        ["Firemane Scout"] = "вогнегривий розвідник",
        ["Firemane Scout slain"] = "вогнегривий розвідник: убито",
    },
    [1169] = {
        ["Searing Heart"] = "палюче серце",
        ["Searing Heart (Provided)"] = "палюче серце (видано)",
        ["Searing Tongue"] = "палючий язик",
        ["Searing Tongue (Provided)"] = "палючий язик (видано)",
    },
    [1172] = {
        ["Egg of Onyxia destroyed"] = "Яйце Оніксії знищено",
    },
    [1173] = {
        ["Drive Overlord Mok'Morokk from Brackenwall Village"] = "Виженіть Повелителя Мок'Морокка з села Брекенволл",
    },
    [1174] = {
        ["Gnome Race Ticket"] = "квиток на перегони гномів",
    },
    [1175] = {
        ["Saltstone Basilisk"] = "соляний василіск",
        ["Saltstone Basilisk slain"] = "соляний василіск: убито",
        ["Saltstone Crystalhide"] = "соляний кришталешкур",
        ["Saltstone Crystalhide slain"] = "соляний кришталешкур: убито",
        ["Saltstone Gazer"] = "соляний камнегляд",
        ["Saltstone Gazer slain"] = "соляний камнегляд: убито",
    },
    [1176] = {
        ["Hollow Vulture Bone"] = "порожниста кістка стерв'ятника",
        ["Hollow Vulture Bone (Provided)"] = "порожниста кістка стерв'ятника (видано)",
    },
    [1177] = {
        ["Mirefin Head"] = "голова моквоплавникового мурлока",
        ["Mirefin Head (Provided)"] = "голова моквоплавникового мурлока (видано)",
    },
    [1179] = {
        ["Crate of Crash Helmets"] = "ящик захисних шоломів",
        ["Crate of Crash Helmets (Provided)"] = "ящик захисних шоломів (видано)",
    },
    [1182] = {
        ["Fuel Regulator Blueprints"] = "креслення паливного регулятора",
        ["Fuel Regulator Blueprints (Provided)"] = "креслення паливного регулятора (видано)",
    },
    [1183] = {
        ["Fuel Regulator Blueprints"] = "креслення паливного регулятора",
        ["Fuel Regulator Blueprints (Provided)"] = "креслення паливного регулятора (видано)",
    },
    [1187] = {
        ["Seaforium Booster"] = "сифорієвий прискорювач",
        ["Seaforium Booster (Provided)"] = "сифорієвий прискорювач (видано)",
    },
    [1188] = {
        ["Seaforium Booster"] = "сифорієвий прискорювач",
        ["Seaforium Booster (Provided)"] = "сифорієвий прискорювач (видано)",
    },
    [1189] = {
        ["Modified Seaforium Booster"] = "модифікований сифорієвий прискорювач",
        ["Modified Seaforium Booster (Provided)"] = "модифікований сифорієвий прискорювач (видано)",
    },
    [1192] = {
        ["Indurium Ore"] = "індурієва руда",
        ["Indurium Ore (Provided)"] = "індурієва руда (видано)",
    },
    [1193] = {
        ["Frost Oil"] = "крижана олія",
        ["Frost Oil (Provided)"] = "крижана олія (видано)",
        ["Thorium Widget"] = "торієвий пристрій",
        ["Thorium Widget (Provided)"] = "торієвий пристрій (видано)",
    },
    [1194] = {
        ["Sample of Indurium Ore"] = "зразок індурієвої руди",
    },
    [1195] = {
        ["Filled Etched Phial"] = "наповнений гравійований фіал",
        ["Filled Etched Phial (Provided)"] = "наповнений гравійований фіал (видано)",
    },
    [1196] = {
        ["Filled Etched Phial"] = "наповнений гравійований фіал",
        ["Filled Etched Phial (Provided)"] = "наповнений гравійований фіал (видано)",
    },
    [1197] = {
        ["Cloven Hoof"] = "роздвоєне копито",
        ["Cloven Hoof (Provided)"] = "роздвоєне копито (видано)",
    },
    [1199] = {
        ["Twilight Pendant"] = "сутінкова підвіска",
        ["Twilight Pendant (Provided)"] = "сутінкова підвіска (видано)",
    },
    [1200] = {
        ["Head of Kelris"] = "голова Келріса",
        ["Head of Kelris (Provided)"] = "голова Келріса (видано)",
    },
    [1201] = {
        ["Theramore Infiltrator"] = "тераморський шпигун",
        ["Theramore Infiltrator slain"] = "тераморський шпигун: убито",
    },
    [1202] = {
        ["Captain's Documents"] = "документи капітана",
        ["Captain's Documents (Provided)"] = "документи капітана (видано)",
    },
    [1203] = {
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
        ["Moonsteel Broadsword (Provided)"] = "палаш з місяцесталі (видано)",
    },
    [1204] = {
        ["Forked Mudrock Tongue"] = "роздвоєний язик болотяної черепахи",
        ["Forked Mudrock Tongue (Provided)"] = "роздвоєний язик болотяної черепахи (видано)",
    },
    [1205] = {
        ["Deadmire's Tooth"] = "зуб Сипуна",
        ["Deadmire's Tooth (Provided)"] = "зуб Сипуна (видано)",
    },
    [1206] = {
        ["Unpopped Darkmist Eye"] = "ціле око імлистого павука",
        ["Unpopped Darkmist Eye (Provided)"] = "ціле око імлистого павука (видано)",
    },
    [1218] = {
        ["Soothing Spices"] = "духмяні спеції",
        ["Soothing Spices (Provided)"] = "духмяні спеції (видано)",
    },
    [1219] = {
        ["Spy's Report"] = "звіт шпигуна",
        ["Spy's Report (Provided)"] = "звіт шпигуна (видано)",
    },
    [1220] = {
        ["Spy's Report"] = "звіт шпигуна",
        ["Spy's Report (Provided)"] = "звіт шпигуна (видано)",
    },
    [1221] = {
        ["Blueleaf Tuber"] = "бульба синьолиста",
        ["Blueleaf Tuber (Provided)"] = "бульба синьолиста (видано)",
        ["Crate With Holes"] = "ящик з отворами",
        ["Crate With Holes (Provided)"] = "ящик з отворами (видано)",
        ["Snufflenose Command Stick"] = "палиця керування шморгоносом",
        ["Snufflenose Command Stick (Provided)"] = "палиця керування шморгоносом (видано)",
        ["Snufflenose Owner's Manual"] = "посібник власника шморгоноса",
        ["Snufflenose Owner's Manual (Provided)"] = "посібник власника шморгоноса (видано)",
    },
    [1222] = {
        ["Help Stinky find Bogbean Leaves"] = "Допоможіть Смердючому знайти Листя Богобана",
    },
    [1238] = {
        ["Spy's Report"] = "звіт шпигуна",
        ["Spy's Report (Provided)"] = "звіт шпигуна (видано)",
    },
    [1239] = {
        ["Defiant Orc Head"] = "голова зухвалого орка",
        ["Defiant Orc Head (Provided)"] = "голова зухвалого орка (видано)",
    },
    [1240] = {
        ["Defiant Orc Head"] = "голова зухвалого орка",
        ["Defiant Orc Head (Provided)"] = "голова зухвалого орка (видано)",
    },
    [1241] = {
        ["Letter to Jorgen"] = "лист до Йорґена",
        ["Letter to Jorgen (Provided)"] = "лист до Йорґена (видано)",
    },
    [1242] = {
        ["Sealed Note to Elling"] = "запечатана записка для Еллінга",
        ["Sealed Note to Elling (Provided)"] = "запечатана записка для Еллінга (видано)",
    },
    [1243] = {
        ["Sealed Note to Watcher Backus"] = "запечатана записка для наглядача Бакуса",
        ["Sealed Note to Watcher Backus (Provided)"] = "запечатана записка для наглядача Бакуса (видано)",
    },
    [1244] = {
        ["Defias Docket"] = "плани Непокірних",
        ["Defias Docket (Provided)"] = "плани Непокірних (видано)",
    },
    [1245] = {
        ["Defias Docket"] = "плани Непокірних",
        ["Defias Docket (Provided)"] = "плани Непокірних (видано)",
    },
    [1249] = {
        ["Defeat Tapoke Jahn"] = "Перемога над Тапоке Джаном",
    },
    [1251] = {
        ["Blackened Iron Shield"] = "почорнілий залізний щит",
        ["Blackened Iron Shield (Provided)"] = "почорнілий залізний щит (видано)",
    },
    [1252] = {
        ["Reethe's Badge"] = "жетон Ріта",
        ["Reethe's Badge (Provided)"] = "жетон Ріта (видано)",
    },
    [1253] = {
        ["Blackened Iron Shield"] = "почорнілий залізний щит",
        ["Blackened Iron Shield (Provided)"] = "почорнілий залізний щит (видано)",
    },
    [1258] = {
        ["Pristine Crawler Leg"] = "бездоганна лапа повзуна",
        ["Pristine Crawler Leg (Provided)"] = "бездоганна лапа повзуна (видано)",
    },
    [1261] = {
        ["Jeweled Pendant"] = "кулон з самоцвітами",
        ["Jeweled Pendant (Provided)"] = "кулон з самоцвітами (видано)",
    },
    [1262] = {
        ["Jeweled Pendant"] = "кулон з самоцвітами",
        ["Jeweled Pendant (Provided)"] = "кулон з самоцвітами (видано)",
    },
    [1265] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Sentry Point explored"] = "Досліджено Сентрі-Пойнт",
    },
    [1269] = {
        ["Reethe's Badge"] = "жетон Ріта",
        ["Reethe's Badge (Provided)"] = "жетон Ріта (видано)",
    },
    [1270] = {
        ["Help Stinky find Bogbean Leaves"] = "Допоможіть Смердючому знайти Листя Богобана",
    },
    [1273] = {
        ["Question Reethe with Ogron"] = "Розпитайте Ріта про Огрона",
    },
    [1275] = {
        ["Corrupted Brain Stem"] = "заражений мозковий стовбур",
        ["Corrupted Brain Stem (Provided)"] = "заражений мозковий стовбур (видано)",
    },
    [1276] = {
        ["Blackened Iron Shield"] = "почорнілий залізний щит",
        ["Blackened Iron Shield (Provided)"] = "почорнілий залізний щит (видано)",
    },
    [1288] = {
        ["Vimes's Report"] = "звіт Ваймса",
        ["Vimes's Report (Provided)"] = "звіт Ваймса (видано)",
    },
    [1318] = {
        ["Gauntlet of Gordok Might"] = "рукавичка могутності Ґордока",
        ["Gauntlet of Gordok Might (Provided)"] = "рукавичка могутності Ґордока (видано)",
    },
    [1319] = {
        ["Blackened Iron Shield"] = "почорнілий залізний щит",
        ["Blackened Iron Shield (Provided)"] = "почорнілий залізний щит (видано)",
    },
    [1321] = {
        ["Blackened Iron Shield"] = "почорнілий залізний щит",
        ["Blackened Iron Shield (Provided)"] = "почорнілий залізний щит (видано)",
    },
    [1322] = {
        ["Acidic Venom Sac"] = "їдка отруйна залоза",
        ["Acidic Venom Sac (Provided)"] = "їдка отруйна залоза (видано)",
    },
    [1324] = {
        ["Subdue Private Hendel"] = "Приборкати рядового Генделя",
    },
    [1338] = {
        ["Stormpike's Request"] = "замовлення Бурешпиля",
        ["Stormpike's Request (Provided)"] = "замовлення Бурешпиля (видано)",
    },
    [1358] = {
        ["Wolf Heart Sample"] = "зразок вовчого серця",
        ["Wolf Heart Sample (Provided)"] = "зразок вовчого серця (видано)",
    },
    [1359] = {
        ["Wolf Heart Samples"] = "зразки вовчих сердець",
        ["Wolf Heart Samples (Provided)"] = "зразки вовчих сердець (видано)",
    },
    [1360] = {
        ["Krom Stoutarm's Treasure"] = "скарб Крома Міцнорука",
        ["Krom Stoutarm's Treasure (Provided)"] = "скарб Крома Міцнорука (видано)",
    },
    [1364] = {
        ["Khadgar's Essays on Dimensional Convergence"] = "дослідження просторової конвергенції Кадґара",
        ["Khadgar's Essays on Dimensional Convergence (Provided)"] = "дослідження просторової конвергенції Кадґара (видано)",
    },
    [1365] = {
        ["Khan Dez'hepah's Head"] = "голова хана Дез'гепа",
        ["Khan Dez'hepah's Head (Provided)"] = "голова хана Дез'гепа (видано)",
    },
    [1366] = {
        ["Centaur Ear"] = "вухо кентавра",
        ["Centaur Ear (Provided)"] = "вухо кентавра (видано)",
    },
    [1367] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
    },
    [1368] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
    },
    [1369] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
        ["Broken Tears"] = "розбиті сльози",
        ["Broken Tears (Provided)"] = "розбиті сльози (видано)",
        ["Tears Destroyed"] = "Знищені сльози",
    },
    [1370] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
        ["Crudely Dried Meat"] = "грубо в'ялене м'ясо",
        ["Crudely Dried Meat (Provided)"] = "грубо в'ялене м'ясо (видано)",
    },
    [1371] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Advanced Target Dummy (Provided)"] = "вдосконалений манекен-мішень (видано)",
        ["Advanced Target Dummy slain"] = "вдосконалений манекен-мішень: убито",
    },
    [1373] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
        ["Draenethyst Shard"] = "уламок дренетиста",
        ["Draenethyst Shard (Provided)"] = "уламок дренетиста (видано)",
    },
    [1374] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
        ["Khan Jehn's Head"] = "голова хана Джена",
        ["Khan Jehn's Head (Provided)"] = "голова хана Джена (видано)",
    },
    [1375] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
        ["Khan Shaka's Head"] = "голова хана Шаки",
        ["Khan Shaka's Head (Provided)"] = "голова хана Шаки (видано)",
    },
    [1380] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
        ["Maraudine Key Fragment"] = "мародінський фрагмент ключа",
        ["Maraudine Key Fragment (Provided)"] = "мародінський фрагмент ключа (видано)",
    },
    [1381] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
        ["Maraudine Key Fragment"] = "мародінський фрагмент ключа",
        ["Maraudine Key Fragment (Provided)"] = "мародінський фрагмент ключа (видано)",
    },
    [1382] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
    },
    [1383] = {
        ["Deepstrider Tumor"] = "пухлина глибокохода",
        ["Deepstrider Tumor (Provided)"] = "пухлина глибокохода (видано)",
        ["Mire Lord Fungus"] = "гриб повелителя болота",
        ["Mire Lord Fungus (Provided)"] = "гриб повелителя болота (видано)",
        ["Shadow Panther Heart"] = "серце тіньової пантери",
        ["Shadow Panther Heart (Provided)"] = "серце тіньової пантери (видано)",
    },
    [1384] = {
        ["3000 reputation with Gelkis Clan Centaur"] = "3000 репутації у кентавра клану Гелкіс",
        ["Crude Charm"] = "грубий оберіг",
        ["Crude Charm (Provided)"] = "грубий оберіг (видано)",
    },
    [1385] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
    },
    [1386] = {
        ["3000 reputation with Magram Clan Centaur"] = "3000 репутації у кланового кентавра Маграм",
        ["Kolkar Centaur"] = "колкарський кентавр",
        ["Kolkar Centaur slain"] = "колкарський кентавр: убито",
        ["Kolkar Mauler"] = "колкарський молотобій",
        ["Kolkar Mauler slain"] = "колкарський молотобій: убито",
        ["Kolkar Scout"] = "колкарський розвідник",
        ["Kolkar Scout slain"] = "колкарський розвідник: убито",
    },
    [1387] = {
        ["Centaur Ear"] = "вухо кентавра",
        ["Centaur Ear (Provided)"] = "вухо кентавра (видано)",
    },
    [1388] = {
        ["Faustin's Truth Serum"] = "сироватка правди Фаустіна",
        ["Faustin's Truth Serum (Provided)"] = "сироватка правди Фаустіна (видано)",
    },
    [1389] = {
        ["Draenethyst Crystal"] = "кристал дренетисту",
        ["Draenethyst Crystal (Provided)"] = "кристал дренетисту (видано)",
    },
    [1391] = {
        ["Zraedus's Brew"] = "вариво Зредуса",
        ["Zraedus's Brew (Provided)"] = "вариво Зредуса (видано)",
    },
    [1392] = {
        ["Noboru's Cudgel"] = "дубина Нобору",
        ["Noboru's Cudgel (Provided)"] = "дубина Нобору (видано)",
    },
    [1393] = {
        ["Escort Galen out of the Fallow Sanctuary."] = "Виведіть Галена з Непарного святилища.",
    },
    [1395] = {
        ["Crate of Power Stones"] = "ящик з камінням сили",
        ["Crate of Power Stones (Provided)"] = "ящик з камінням сили (видано)",
    },
    [1396] = {
        ["Sorrow Spinner"] = "ткач скорботи",
        ["Sorrow Spinner slain"] = "ткач скорботи: убито",
        ["Swamp Jaguar"] = "болотний ягуар",
        ["Swamp Jaguar slain"] = "болотний ягуар: убито",
        ["Young Sawtooth Crocolisk"] = "молодий пилкозубий кроколіск",
        ["Young Sawtooth Crocolisk slain"] = "молодий пилкозубий кроколіск: убито",
    },
    [1398] = {
        ["Sundried Driftwood"] = "сухий плавник",
        ["Sundried Driftwood (Provided)"] = "сухий плавник (видано)",
    },
    [1419] = {
        ["Coyote Jawbone"] = "щелепа койота",
        ["Coyote Jawbone (Provided)"] = "щелепа койота (видано)",
    },
    [1420] = {
        ["Neeka's Report"] = "доповідь Ніки",
        ["Neeka's Report (Provided)"] = "доповідь Ніки (видано)",
    },
    [1421] = {
        ["Wizards' Reagents"] = "реактиви чарівників",
        ["Wizards' Reagents (Provided)"] = "реактиви чарівників (видано)",
    },
    [1423] = {
        ["Lost Supplies"] = "втрачені припаси",
        ["Lost Supplies (Provided)"] = "втрачені припаси (видано)",
    },
    [1424] = {
        ["Atal'ai Artifact"] = "артефакт Атал'ай",
        ["Atal'ai Artifact (Provided)"] = "артефакт Атал'ай (видано)",
    },
    [1425] = {
        ["Shipment to Nethergarde"] = "вантаж для Підсвітньої Варти",
        ["Shipment to Nethergarde (Provided)"] = "вантаж для Підсвітньої Варти (видано)",
    },
    [1426] = {
        ["Marsh Flesheater"] = "трясовинний живоїд",
        ["Marsh Flesheater slain"] = "трясовинний живоїд: убито",
        ["Marsh Inkspewer"] = "трясовинний чорнильник",
        ["Marsh Inkspewer slain"] = "трясовинний чорнильник: убито",
        ["Marsh Murloc"] = "трясовинний мурлок",
        ["Marsh Murloc slain"] = "трясовинний мурлок: убито",
    },
    [1428] = {
        ["Marsh Flesheater"] = "трясовинний живоїд",
        ["Marsh Flesheater slain"] = "трясовинний живоїд: убито",
        ["Marsh Inkspewer"] = "трясовинний чорнильник",
        ["Marsh Inkspewer slain"] = "трясовинний чорнильник: убито",
        ["Marsh Oracle"] = "трясовинний оракул",
        ["Marsh Oracle slain"] = "трясовинний оракул: убито",
    },
    [1429] = {
        ["Bundle of Atal'ai Artifacts"] = "пакунок з артефактами Атал'ай",
        ["Bundle of Atal'ai Artifacts (Provided)"] = "пакунок з артефактами Атал'ай (видано)",
    },
    [1430] = {
        ["Monstrous Crawler Leg"] = "нога жахливого повзуна",
        ["Monstrous Crawler Leg (Provided)"] = "нога жахливого повзуна (видано)",
    },
    [1434] = {
        ["Hatefury Betrayer"] = "скаженолютий зрадник",
        ["Hatefury Betrayer slain"] = "скаженолютий зрадник: убито",
        ["Hatefury Felsworn"] = "скаженолютий скверноклят",
        ["Hatefury Felsworn slain"] = "скаженолютий скверноклят: убито",
        ["Hatefury Hellcaller"] = "скаженолютий пеклоклик",
        ["Hatefury Hellcaller slain"] = "скаженолютий пеклоклик: убито",
        ["Hatefury Rogue"] = "скаженолютий пройдисвіт",
        ["Hatefury Rogue slain"] = "скаженолютий пройдисвіт: убито",
    },
    [1435] = {
        ["Burning Gem"] = "палаючий самоцвіт",
        ["Burning Gem (Provided)"] = "палаючий самоцвіт (видано)",
        ["Infused Burning Gem"] = "наповнений палаючий самоцвіт",
        ["Infused Burning Gem (Provided)"] = "наповнений палаючий самоцвіт (видано)",
    },
    [1439] = {
        ["Tyranis' Pendant"] = "кулон Тіраніса",
        ["Tyranis' Pendant (Provided)"] = "кулон Тіраніса (видано)",
    },
    [1440] = {
        ["Rescue Dalinda Malem"] = "Врятуйте Далінду Малем",
    },
    [1442] = {
        ["Corrupted Kor Gem"] = "осквернений самоцвіт Кора",
        ["Corrupted Kor Gem (Provided)"] = "осквернений самоцвіт Кора (видано)",
    },
    [1445] = {
        ["Fetish of Hakkar"] = "фетиш Гаккара",
        ["Fetish of Hakkar (Provided)"] = "фетиш Гаккара (видано)",
    },
    [1446] = {
        ["Head of Jammal'an"] = "голова Джаммал'ана",
        ["Head of Jammal'an (Provided)"] = "голова Джаммал'ана (видано)",
    },
    [1447] = {
        ["Defeat Dashel Stonefist"] = "Перемогти Дашеля Кам'яного Кулака",
    },
    [1448] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Search for the Temple of Atal'Hakkar"] = "Пошук храму Атал'Хаккара",
    },
    [1452] = {
        ["Groddoc Liver"] = "печінка гроддокської мавпи",
        ["Groddoc Liver (Provided)"] = "печінка гроддокської мавпи (видано)",
        ["Ironfur Liver"] = "печінка залізохутрого ведмедя",
        ["Ironfur Liver (Provided)"] = "печінка залізохутрого ведмедя (видано)",
        ["Roc Gizzard"] = "шлунок руха",
        ["Roc Gizzard (Provided)"] = "шлунок руха (видано)",
    },
    [1456] = {
        ["Karnitol's Satchel"] = "торба Карнітола",
        ["Karnitol's Satchel (Provided)"] = "торба Карнітола (видано)",
    },
    [1457] = {
        ["Karnitol's Satchel"] = "торба Карнітола",
        ["Karnitol's Satchel (Provided)"] = "торба Карнітола (видано)",
    },
    [1458] = {
        ["Hatefury Claw"] = "кіготь скаженолютого сатира",
        ["Hatefury Claw (Provided)"] = "кіготь скаженолютого сатира (видано)",
        ["Hatefury Horn"] = "ріг скаженолютого сатира",
        ["Hatefury Horn (Provided)"] = "ріг скаженолютого сатира (видано)",
    },
    [1459] = {
        ["Aged Kodo Hide"] = "шкура старого кодо",
        ["Aged Kodo Hide (Provided)"] = "шкура старого кодо (видано)",
        ["Scorpashi Venom"] = "отрута скорпаші",
        ["Scorpashi Venom (Provided)"] = "отрута скорпаші (видано)",
    },
    [1465] = {
        ["Malem Pendant"] = "кулон Малемів",
        ["Malem Pendant (Provided)"] = "кулон Малемів (видано)",
    },
    [1466] = {
        ["Doomwarder Blood"] = "кров стража приречення",
        ["Doomwarder Blood (Provided)"] = "кров стража приречення (видано)",
        ["Felhound Brain"] = "мозок скверногончої",
        ["Felhound Brain (Provided)"] = "мозок скверногончої (видано)",
        ["Nether Wing"] = "підсвітне крило",
        ["Nether Wing (Provided)"] = "підсвітне крило (видано)",
    },
    [1467] = {
        ["Leftwitch's Package"] = "пакунок Лівшиці",
        ["Leftwitch's Package (Provided)"] = "пакунок Лівшиці (видано)",
    },
    [1468] = {
        ["Human Orphan Whistle"] = "свисток сироти",
    },
    [1469] = {
        ["Atal'ai Tablet Fragment"] = "уламок таблички Атал'ай",
        ["Atal'ai Tablet Fragment (Provided)"] = "уламок таблички Атал'ай (видано)",
    },
    [1470] = {
        ["Rattlecage Skull"] = "череп брязкокісткового скелета",
        ["Rattlecage Skull (Provided)"] = "череп брязкокісткового скелета (видано)",
    },
    [1471] = {
        ["Summoned Voidwalker"] = "викликаний пустотник",
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1473] = {
        ["Egalin's Grimoire"] = "гримуар Еґаліна",
        ["Egalin's Grimoire (Provided)"] = "гримуар Еґаліна (видано)",
    },
    [1474] = {
        ["Summoned Succubus"] = "викликаний сукуб",
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1475] = {
        ["Atal'ai Tablet"] = "скрижаль Атал'ай",
        ["Atal'ai Tablet (Provided)"] = "скрижаль Атал'ай (видано)",
    },
    [1476] = {
        ["Comar's Heart"] = "серце Комара",
        ["Comar's Heart (Provided)"] = "серце Комара (видано)",
        ["Dalin's Heart"] = "серце Даліна",
        ["Dalin's Heart (Provided)"] = "серце Даліна (видано)",
    },
    [1479] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the bank in Darnassus, otherwise known as the Bough of the Eternals."] = "Сходіть до банку в Дарнасі, також відомого як Гілка Вічних.",
    },
    [1480] = {
        ["Flayed Demon Skin"] = "обдерта шкіра демона",
        ["Flayed Demon Skin (Provided)"] = "обдерта шкіра демона (видано)",
    },
    [1481] = {
        ["Shadowstalker Scalp"] = "скальп тінелова",
        ["Shadowstalker Scalp (Provided)"] = "скальп тінелова (видано)",
    },
    [1482] = {
        ["Oracle Crystal"] = "кристал оракула",
        ["Oracle Crystal (Provided)"] = "кристал оракула (видано)",
    },
    [1485] = {
        ["Vile Familiar Head"] = "голова паскудного фамільяра",
        ["Vile Familiar Head (Provided)"] = "голова паскудного фамільяра (видано)",
    },
    [1486] = {
        ["Deviate Hide"] = "спотворена шкура",
        ["Deviate Hide (Provided)"] = "спотворена шкура (видано)",
    },
    [1487] = {
        ["Deviate Dreadfang"] = "спотворений жахоклик",
        ["Deviate Dreadfang slain"] = "спотворений жахоклик: убито",
        ["Deviate Ravager"] = "спотворений спустошник",
        ["Deviate Ravager slain"] = "спотворений спустошник: убито",
        ["Deviate Shambler"] = "спотворений шаркун",
        ["Deviate Shambler slain"] = "спотворений шаркун: убито",
        ["Deviate Viper"] = "спотворена гадюка",
        ["Deviate Viper slain"] = "спотворена гадюка: убито",
    },
    [1488] = {
        ["Jugkar Grim'rod"] = "Жуґар Ґрім'род",
        ["Jugkar Grim'rod slain"] = "Жуґар Ґрім'род: убито",
        ["Lord Azrethoc"] = "лорд Азреток",
        ["Lord Azrethoc slain"] = "лорд Азреток: убито",
    },
    [1491] = {
        ["Wailing Essence"] = "плачуча сутність",
        ["Wailing Essence (Provided)"] = "плачуча сутність (видано)",
    },
    [1492] = {
        ["Secure Crate"] = "запечатаний ящик",
        ["Secure Crate (Provided)"] = "запечатаний ящик (видано)",
    },
    [1498] = {
        ["Singed Scale"] = "припалена луска",
        ["Singed Scale (Provided)"] = "припалена луска (видано)",
    },
    [1501] = {
        ["Tablet of Verga"] = "скрижаль Верґи",
        ["Tablet of Verga (Provided)"] = "скрижаль Верґи (видано)",
    },
    [1503] = {
        ["Forged Steel Bars"] = "бруски кованої сталі",
        ["Forged Steel Bars (Provided)"] = "бруски кованої сталі (видано)",
    },
    [1504] = {
        ["Summoned Voidwalker"] = "викликаний пустотник",
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1511] = {
        ["Ken'zigla's Draught"] = "настій Кен'зіґли",
        ["Ken'zigla's Draught (Provided)"] = "настій Кен'зіґли (видано)",
    },
    [1512] = {
        ["Dirt-caked Pendant"] = "вкритий брудом кулон",
        ["Dirt-caked Pendant (Provided)"] = "вкритий брудом кулон (видано)",
    },
    [1513] = {
        ["Summoned Succubus"] = "викликаний сукуб",
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1514] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [1515] = {
        ["Ken'zigla's Draught"] = "настій Кен'зіґли",
        ["Ken'zigla's Draught (Provided)"] = "настій Кен'зіґли (видано)",
    },
    [1516] = {
        ["Felstalker Hoof"] = "копито сквернолова",
        ["Felstalker Hoof (Provided)"] = "копито сквернолова (видано)",
    },
    [1517] = {
        ["Earth Sapta"] = "сапта землі",
    },
    [1518] = {
        ["Rough Quartz"] = "грубий кварц",
        ["Rough Quartz (Provided)"] = "грубий кварц (видано)",
    },
    [1519] = {
        ["Ritual Salve"] = "ритуальна мазь",
        ["Ritual Salve (Provided)"] = "ритуальна мазь (видано)",
    },
    [1520] = {
        ["Earth Sapta"] = "сапта землі",
    },
    [1521] = {
        ["Rough Quartz"] = "грубий кварц",
        ["Rough Quartz (Provided)"] = "грубий кварц (видано)",
    },
    [1524] = {
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
        ["Torch of the Dormant Flame (Provided)"] = "смолоскип дрімаючого полум'я (видано)",
    },
    [1525] = {
        ["Fire Tar"] = "вогняна смола",
        ["Fire Tar (Provided)"] = "вогняна смола (видано)",
        ["Reagent Pouch"] = "мішечок з реагентами",
        ["Reagent Pouch (Provided)"] = "мішечок з реагентами (видано)",
    },
    [1526] = {
        ["Glowing Ember"] = "розжарена вуглинка",
        ["Glowing Ember (Provided)"] = "розжарена вуглинка (видано)",
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
        ["Torch of the Dormant Flame (Provided)"] = "смолоскип дрімаючого полум'я (видано)",
    },
    [1527] = {
        ["Torch of the Eternal Flame"] = "смолоскип вічного полум'я",
        ["Torch of the Eternal Flame (Provided)"] = "смолоскип вічного полум'я (видано)",
    },
    [1534] = {
        ["Filled Blue Waterskin"] = "наповнений блакитний бурдюк",
        ["Filled Blue Waterskin (Provided)"] = "наповнений блакитний бурдюк (видано)",
    },
    [1535] = {
        ["Filled Brown Waterskin"] = "наповнений коричневий бурдюк",
        ["Filled Brown Waterskin (Provided)"] = "наповнений коричневий бурдюк (видано)",
    },
    [1536] = {
        ["Filled Red Waterskin"] = "наповнений червоний бурдюк",
        ["Filled Red Waterskin (Provided)"] = "наповнений червоний бурдюк (видано)",
    },
    [1558] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the top of the Stonewrought Dam in Loch Modan."] = "Підніміться на вершину дамби Stonewrought у озері Лох-Модан.",
    },
    [1560] = {
        ["Lead Tooga to Torta"] = "Ведіть Тугу до Торти",
    },
    [1578] = {
        ["Copper Axe"] = "мідна сокира",
        ["Copper Axe (Provided)"] = "мідна сокира (видано)",
        ["Copper Chain Belt"] = "мідний плетений пояс",
        ["Copper Chain Belt (Provided)"] = "мідний плетений пояс (видано)",
    },
    [1579] = {
        ["Gaffer Jack"] = "світлоштепсель",
        ["Gaffer Jack (Provided)"] = "світлоштепсель (видано)",
    },
    [1580] = {
        ["Electropeller"] = "електропелер",
        ["Electropeller (Provided)"] = "електропелер (видано)",
    },
    [1581] = {
        ["Elixir of Lion's Strength"] = "еліксир сили лева",
        ["Elixir of Lion's Strength (Provided)"] = "еліксир сили лева (видано)",
        ["Elixir of Minor Defense"] = "еліксир слабкого захисту",
        ["Elixir of Minor Defense (Provided)"] = "еліксир слабкого захисту (видано)",
    },
    [1582] = {
        ["Embossed Leather Boots"] = "тиснені шкіряні чоботи",
        ["Embossed Leather Boots (Provided)"] = "тиснені шкіряні чоботи (видано)",
        ["Embossed Leather Cloak"] = "тиснений шкіряний плащ",
        ["Embossed Leather Cloak (Provided)"] = "тиснений шкіряний плащ (видано)",
        ["Embossed Leather Gloves"] = "тиснені шкіряні рукавички",
        ["Embossed Leather Gloves (Provided)"] = "тиснені шкіряні рукавички (видано)",
    },
    [1598] = {
        ["Powers of the Void"] = "Сили Порожнечі",
        ["Powers of the Void (Provided)"] = "Сили Порожнечі (видано)",
    },
    [1599] = {
        ["Feather Charm"] = "оберіг з пір'я",
        ["Feather Charm (Provided)"] = "оберіг з пір'я (видано)",
    },
    [1618] = {
        ["Heavy Copper Maul"] = "важкий мідний молот",
        ["Heavy Copper Maul (Provided)"] = "важкий мідний молот (видано)",
        ["Runed Copper Belt"] = "рунічний мідний пояс",
        ["Runed Copper Belt (Provided)"] = "рунічний мідний пояс (видано)",
    },
    [1640] = {
        ["Beat Bartleby"] = "Біт Бартлбі",
    },
    [1644] = {
        ["Linen Cloth"] = "лляна тканина",
        ["Linen Cloth (Provided)"] = "лляна тканина (видано)",
    },
    [1648] = {
        ["Linen Cloth"] = "лляна тканина",
        ["Linen Cloth (Provided)"] = "лляна тканина (видано)",
    },
    [1651] = {
        ["Protect Daphne Stilwell"] = "Захистіть Дафну Стілвелл",
    },
    [1654] = {
        ["Jordan's Refined Ore Shipment"] = "партія очищеної руди Джордана",
        ["Jordan's Refined Ore Shipment (Provided)"] = "партія очищеної руди Джордана (видано)",
        ["Jordan's Smithing Hammer"] = "ковальський молоток Джордана",
        ["Jordan's Smithing Hammer (Provided)"] = "ковальський молоток Джордана (видано)",
        ["Purified Kor Gem"] = "очищений самоцвіт Кора",
        ["Purified Kor Gem (Provided)"] = "очищений самоцвіт Кора (видано)",
        ["Whitestone Oak Lumber"] = "деревина білокам'яного дуба",
        ["Whitestone Oak Lumber (Provided)"] = "деревина білокам'яного дуба (видано)",
    },
    [1655] = {
        ["Jordan's Ore Shipment"] = "партія руди Джордана",
        ["Jordan's Ore Shipment (Provided)"] = "партія руди Джордана (видано)",
    },
    [1656] = {
        ["Bundle of Furs"] = "зв'язка хутра",
        ["Bundle of Furs (Provided)"] = "зв'язка хутра (видано)",
    },
    [1657] = {
        ["Toss Stink Bomb into Southshore"] = "Киньте смердючу бомбу в Південний берег",
        ["Toss Stink Bomb into Southshore (Provided)"] = "Киньте смердючу бомбу в Південний берег (видано)",
        ["Toss Stink Bomb into Southshore slain"] = "Киньте смердючу бомбу в Південний берег: убито",
    },
    [1658] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Scout out the Forsaken's Wickerman Festival."] = "Розвідайте фестиваль плетених людей Від'їханих.",
    },
    [1665] = {
        ["Bartleby's Mug"] = "кружка Бартлбі",
        ["Bartleby's Mug (Provided)"] = "кружка Бартлбі (видано)",
    },
    [1667] = {
        ["Marshal Haggard's Badge"] = "значок маршала Знесилія",
        ["Marshal Haggard's Badge (Provided)"] = "значок маршала Знесилія (видано)",
    },
    [1678] = {
        ["Vejrek's Head"] = "голова Веджріка",
        ["Vejrek's Head (Provided)"] = "голова Веджріка (видано)",
    },
    [1681] = {
        ["Umbral Ore"] = "смеркова руда",
        ["Umbral Ore (Provided)"] = "смеркова руда (видано)",
    },
    [1683] = {
        ["Horn of Vorlus"] = "ріг Ворла",
        ["Horn of Vorlus (Provided)"] = "ріг Ворла (видано)",
    },
    [1686] = {
        ["Elunite Ore"] = "елунітова руда",
        ["Elunite Ore (Provided)"] = "елунітова руда (видано)",
        ["Elura's Medallion"] = "медальйон Елури",
        ["Elura's Medallion (Provided)"] = "медальйон Елури (видано)",
    },
    [1687] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the Westfall Lighthouse."] = "Ідіть до маяка Вестфолл.",
    },
    [1688] = {
        ["Surena's Choker"] = "кольє Сурени",
        ["Surena's Choker (Provided)"] = "кольє Сурени (видано)",
    },
    [1689] = {
        ["Bloodstone Choker"] = "кольє з кривавого каменю",
        ["Bloodstone Choker (Provided)"] = "кольє з кривавого каменю (видано)",
        ["Summoned Voidwalker"] = "викликаний пустотник",
        ["Summoned Voidwalker slain"] = "викликаний пустотник: убито",
    },
    [1690] = {
        ["Wastewander Bandit"] = "бандит Пустелебродів",
        ["Wastewander Bandit slain"] = "бандит Пустелебродів: убито",
        ["Wastewander Thief"] = "злодій Пустелебродів",
        ["Wastewander Thief slain"] = "злодій Пустелебродів: убито",
    },
    [1691] = {
        ["Wastewander Assassin"] = "душогуб Пустелебродів",
        ["Wastewander Assassin slain"] = "душогуб Пустелебродів: убито",
        ["Wastewander Rogue"] = "пройдисвіт Пустелебродів",
        ["Wastewander Rogue slain"] = "пройдисвіт Пустелебродів: убито",
        ["Wastewander Shadow Mage"] = "тіньовий маг Пустелебродів",
        ["Wastewander Shadow Mage slain"] = "тіньовий маг Пустелебродів: убито",
    },
    [1692] = {
        ["Case of Elunite"] = "ящик елуніту",
        ["Case of Elunite (Provided)"] = "ящик елуніту (видано)",
    },
    [1699] = {
        ["Enter the Rethban Caverns"] = "Увійдіть до печер Ретбан",
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [1700] = {
        ["Furen's Notes"] = "записи Фьюрена",
        ["Furen's Notes (Provided)"] = "записи Фьюрена (видано)",
    },
    [1701] = {
        ["Charred Horn"] = "обвуглений ріг",
        ["Charred Horn (Provided)"] = "обвуглений ріг (видано)",
        ["Galvanized Horn"] = "гальванізований ріг",
        ["Galvanized Horn (Provided)"] = "гальванізований ріг (видано)",
        ["Scorched Spider Fang"] = "обпалене павуче ікло",
        ["Scorched Spider Fang (Provided)"] = "обпалене павуче ікло (видано)",
        ["Vial of Phlogiston"] = "фіал флогістону",
        ["Vial of Phlogiston (Provided)"] = "фіал флогістону (видано)",
    },
    [1702] = {
        ["Cask of Scalder"] = "барильце пекучої бражки",
        ["Cask of Scalder (Provided)"] = "барильце пекучої бражки (видано)",
    },
    [1703] = {
        ["Furen's Notes"] = "записи Фьюрена",
        ["Furen's Notes (Provided)"] = "записи Фьюрена (видано)",
    },
    [1704] = {
        ["Furen's Notes"] = "записи Фьюрена",
        ["Furen's Notes (Provided)"] = "записи Фьюрена (видано)",
    },
    [1705] = {
        ["Burning Blood"] = "палаюча кров",
        ["Burning Blood (Provided)"] = "палаюча кров (видано)",
        ["Burning Rock"] = "палаючий камінь",
        ["Burning Rock (Provided)"] = "палаючий камінь (видано)",
    },
    [1707] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
        ["Wastewander Water Pouch (Provided)"] = "бурдюк з водою Пустелебродів (видано)",
    },
    [1708] = {
        ["Searing Coral"] = "обпалюючий корал",
        ["Searing Coral (Provided)"] = "обпалюючий корал (видано)",
    },
    [1710] = {
        ["Sunscorched Shell"] = "випалена сонцем шкаралупа",
        ["Sunscorched Shell (Provided)"] = "випалена сонцем шкаралупа (видано)",
    },
    [1712] = {
        ["Bloodscalp Tusk"] = "ікло Кровоскальпого",
        ["Bloodscalp Tusk (Provided)"] = "ікло Кровоскальпого (видано)",
        ["Essence of the Exile"] = "сутність вигнанця",
        ["Essence of the Exile (Provided)"] = "сутність вигнанця (видано)",
        ["Liferoot"] = "життєкорінь",
        ["Liferoot (Provided)"] = "життєкорінь (видано)",
    },
    [1713] = {
        ["Whirlwind Heart"] = "серце вихору",
        ["Whirlwind Heart (Provided)"] = "серце вихору (видано)",
    },
    [1714] = {
        ["Burning Charm"] = "палаючий оберіг",
        ["Burning Charm (Provided)"] = "палаючий оберіг (видано)",
        ["Cresting Charm"] = "бурунистий оберіг",
        ["Cresting Charm (Provided)"] = "бурунистий оберіг (видано)",
        ["Thundering Charm"] = "буревійний оберіг",
        ["Thundering Charm (Provided)"] = "буревійний оберіг (видано)",
    },
    [1719] = {
        ["Big Will"] = "здоровань Вілл",
        ["Big Will slain"] = "здоровань Вілл: убито",
    },
    [1738] = {
        ["Heartswood"] = "серцедерево",
        ["Heartswood (Provided)"] = "серцедерево (видано)",
    },
    [1739] = {
        ["Summoned Succubus"] = "викликаний сукуб",
        ["Summoned Succubus slain"] = "викликаний сукуб: убито",
    },
    [1740] = {
        ["Large Soran'ruk Fragment"] = "великий фрагмент Соран'рука",
        ["Large Soran'ruk Fragment (Provided)"] = "великий фрагмент Соран'рука (видано)",
        ["Soran'ruk Fragment"] = "фрагмент Соран'рука",
        ["Soran'ruk Fragment (Provided)"] = "фрагмент Соран'рука (видано)",
    },
    [1779] = {
        ["Symbol of Life"] = "знак життя",
    },
    [1781] = {
        ["Symbol of Life"] = "знак життя",
    },
    [1783] = {
        ["Narm Faulk"] = "Нарм Фок",
        ["Narm Faulk slain"] = "Нарм Фок: убито",
    },
    [1784] = {
        ["Dark Iron Script"] = "накази Темного Заліза",
        ["Dark Iron Script (Provided)"] = "накази Темного Заліза (видано)",
    },
    [1786] = {
        ["Henze Faulk"] = "Гензе Фок",
        ["Henze Faulk slain"] = "Гензе Фок: убито",
    },
    [1787] = {
        ["Defias Script"] = "накази Непокірних",
        ["Defias Script (Provided)"] = "накази Непокірних (видано)",
    },
    [1795] = {
        ["Summoned Felhunter"] = "викликана скверногонча",
        ["Summoned Felhunter slain"] = "викликана скверногонча: убито",
        ["Tome of the Cabal"] = "Фоліант Змови",
        ["Tome of the Cabal (Provided)"] = "Фоліант Змови (видано)",
    },
    [1796] = {
        ["Robes of Arcana"] = "мантія аркани",
        ["Robes of Arcana (Provided)"] = "мантія аркани (видано)",
    },
    [1799] = {
        ["Infernal Orb"] = "сфера пекельника",
        ["Infernal Orb (Provided)"] = "сфера пекельника (видано)",
    },
    [1800] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Go to the old Lordaeron Throne Room that lies just before descending into the Undercity."] = "Ідіть до старої Тронної зали Лордерона, яка знаходиться безпосередньо перед спуском у Підмісто.",
    },
    [1802] = {
        ["Moldy Tome"] = "запліснявілий фоліант",
        ["Moldy Tome (Provided)"] = "запліснявілий фоліант (видано)",
        ["Tattered Manuscript"] = "пошарпаний манускрипт",
        ["Tattered Manuscript (Provided)"] = "пошарпаний манускрипт (видано)",
    },
    [1803] = {
        ["Moldy Tome"] = "запліснявілий фоліант",
        ["Moldy Tome (Provided)"] = "запліснявілий фоліант (видано)",
        ["Tattered Manuscript"] = "пошарпаний манускрипт",
        ["Tattered Manuscript (Provided)"] = "пошарпаний манускрипт (видано)",
    },
    [1804] = {
        ["Reconstructed Tome"] = "відновлений фоліант",
        ["Reconstructed Tome (Provided)"] = "відновлений фоліант (видано)",
        ["Rod of Channeling"] = "жезл виклику",
        ["Rod of Channeling (Provided)"] = "жезл виклику (видано)",
    },
    [1805] = {
        ["Reconstructed Tome"] = "відновлений фоліант",
        ["Reconstructed Tome (Provided)"] = "відновлений фоліант (видано)",
        ["Rod of Channeling"] = "жезл виклику",
        ["Rod of Channeling (Provided)"] = "жезл виклику (видано)",
    },
    [1819] = {
        ["Ulag the Cleaver"] = "Улаґ-Колун",
        ["Ulag the Cleaver slain"] = "Улаґ-Колун: убито",
    },
    [1821] = {
        ["Agamand Family Axe"] = "родова сокира Аґамандів",
        ["Agamand Family Axe (Provided)"] = "родова сокира Аґамандів (видано)",
        ["Agamand Family Dagger"] = "родовий кинджал Аґамандів",
        ["Agamand Family Dagger (Provided)"] = "родовий кинджал Аґамандів (видано)",
        ["Agamand Family Mace"] = "родова булава Аґамандів",
        ["Agamand Family Mace (Provided)"] = "родова булава Аґамандів (видано)",
        ["Agamand Family Sword"] = "родовий меч Аґамандів",
        ["Agamand Family Sword (Provided)"] = "родовий меч Аґамандів (видано)",
    },
    [1824] = {
        ["Twitching Antenna"] = "судомний вусик",
        ["Twitching Antenna (Provided)"] = "судомний вусик (видано)",
    },
    [1838] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
        ["Powdered Azurite"] = "молотий азурит",
        ["Powdered Azurite (Provided)"] = "молотий азурит (видано)",
        ["Smoky Iron Ingot"] = "злиток димчастого заліза",
        ["Smoky Iron Ingot (Provided)"] = "злиток димчастого заліза (видано)",
        ["Vial of Phlogiston"] = "фіал флогістону",
        ["Vial of Phlogiston (Provided)"] = "фіал флогістону (видано)",
    },
    [1842] = {
        ["Uncloven Satyr Hoof"] = "нероздвоєне копито сатира",
        ["Uncloven Satyr Hoof (Provided)"] = "нероздвоєне копито сатира (видано)",
    },
    [1844] = {
        ["Galvanized Horn"] = "гальванізований ріг",
        ["Galvanized Horn (Provided)"] = "гальванізований ріг (видано)",
    },
    [1846] = {
        ["Sturdy Dragonmaw Shinbone"] = "міцна гомілкова кістка Драконової Пащі",
        ["Sturdy Dragonmaw Shinbone (Provided)"] = "міцна гомілкова кістка Драконової Пащі (видано)",
    },
    [1858] = {
        ["Tazan's Logbook"] = "щоденник Тазана",
        ["Tazan's Logbook (Provided)"] = "щоденник Тазана (видано)",
    },
    [1861] = {
        ["Mirror Lake Water Sample"] = "зразок води Дзеркального озера",
        ["Mirror Lake Water Sample (Provided)"] = "зразок води Дзеркального озера (видано)",
    },
    [1878] = {
        ["Wastewander Water Pouch"] = "бурдюк з водою Пустелебродів",
        ["Wastewander Water Pouch (Provided)"] = "бурдюк з водою Пустелебродів (видано)",
    },
    [1880] = {
        ["Mage-tastic Gizmonitor"] = "маг-тастичний гізмонітор",
        ["Mage-tastic Gizmonitor (Provided)"] = "маг-тастичний гізмонітор (видано)",
    },
    [1882] = {
        ["Balnir Snapdragons"] = "ротики Бальнірів",
        ["Balnir Snapdragons (Provided)"] = "ротики Бальнірів (видано)",
    },
    [1884] = {
        ["Ju-Ju Heaps Destroyed"] = "Знищені купи джу-джу",
    },
    [1886] = {
        ["Astor's Letter of Introduction"] = "рекомендаційний лист Астора",
        ["Astor's Letter of Introduction (Provided)"] = "рекомендаційний лист Астора (видано)",
    },
    [1898] = {
        ["Astor's Letter of Introduction"] = "рекомендаційний лист Астора",
        ["Astor's Letter of Introduction (Provided)"] = "рекомендаційний лист Астора (видано)",
    },
    [1899] = {
        ["Andron's Ledger"] = "гросбух Андрона",
        ["Andron's Ledger (Provided)"] = "гросбух Андрона (видано)",
    },
    [1918] = {
        ["Befouled Water Globe"] = "забруднена водяна куля",
        ["Befouled Water Globe (Provided)"] = "забруднена водяна куля (видано)",
    },
    [1920] = {
        ["Cantation of Manifestation"] = "закляття прояву",
        ["Cantation of Manifestation (Provided)"] = "закляття прояву (видано)",
        ["Chest of Containment Coffers"] = "ящик зі скринями стримування",
        ["Chest of Containment Coffers (Provided)"] = "ящик зі скринями стримування (видано)",
        ["Filled Containment Coffer"] = "заповнена скриня стримування",
        ["Filled Containment Coffer (Provided)"] = "заповнена скриня стримування (видано)",
    },
    [1921] = {
        ["Charged Rift Gem"] = "заряджений камінь розлому",
        ["Charged Rift Gem (Provided)"] = "заряджений камінь розлому (видано)",
        ["Linen Cloth"] = "лляна тканина",
        ["Linen Cloth (Provided)"] = "лляна тканина (видано)",
    },
    [1938] = {
        ["Ur's Treatise on Shadow Magic"] = "трактат Ура про темну магію",
        ["Ur's Treatise on Shadow Magic (Provided)"] = "трактат Ура про темну магію (видано)",
    },
    [1940] = {
        ["Pristine Spider Silk"] = "бездоганне павутиння",
        ["Pristine Spider Silk (Provided)"] = "бездоганне павутиння (видано)",
    },
    [1944] = {
        ["Xavian Water Sample"] = "зразок води Завіана",
        ["Xavian Water Sample (Provided)"] = "зразок води Завіана (видано)",
    },
    [1945] = {
        ["Laughing Sister's Hair"] = "волосина сміхотливої сестри",
        ["Laughing Sister's Hair (Provided)"] = "волосина сміхотливої сестри (видано)",
    },
    [1948] = {
        ["Bolt Charged Bramble"] = "заряджена блискавкою тростина",
        ["Bolt Charged Bramble (Provided)"] = "заряджена блискавкою тростина (видано)",
        ["Jade"] = "нефрит",
        ["Jade (Provided)"] = "нефрит (видано)",
        ["Jade slain"] = "Нефрит: убито",
    },
    [1950] = {
        ["Secret phrase found"] = "Знайдена секретна фраза",
    },
    [1951] = {
        ["Rituals of Power"] = "\"Ритуали сили\"",
        ["Rituals of Power (Provided)"] = "\"Ритуали сили\" (видано)",
    },
    [1954] = {
        ["Infernal Orb"] = "сфера пекельника",
        ["Infernal Orb (Provided)"] = "сфера пекельника (видано)",
    },
    [1955] = {
        ["Demon of the Orb"] = "демон сфери",
        ["Demon of the Orb slain"] = "демон сфери: убито",
    },
    [1956] = {
        ["Obsidian Power Source"] = "обсидіанове джерело сили",
        ["Obsidian Power Source (Provided)"] = "обсидіанове джерело сили (видано)",
    },
    [1957] = {
        ["Mana Surge"] = "манасплеск",
        ["Mana Surge slain"] = "манасплеск: убито",
    },
    [1960] = {
        ["Cantation of Manifestation"] = "закляття прояву",
        ["Cantation of Manifestation (Provided)"] = "закляття прояву (видано)",
        ["Chest of Containment Coffers"] = "ящик зі скринями стримування",
        ["Chest of Containment Coffers (Provided)"] = "ящик зі скринями стримування (видано)",
        ["Filled Containment Coffer"] = "заповнена скриня стримування",
        ["Filled Containment Coffer (Provided)"] = "заповнена скриня стримування (видано)",
    },
    [1961] = {
        ["Dalaran Mana Gem"] = "даларанський самоцвіт мани",
        ["Dalaran Mana Gem (Provided)"] = "даларанський самоцвіт мани (видано)",
        ["Linen Cloth"] = "лляна тканина",
        ["Linen Cloth (Provided)"] = "лляна тканина (видано)",
    },
    [1963] = {
        ["Tazan's Satchel"] = "ранець Тазана",
        ["Tazan's Satchel (Provided)"] = "ранець Тазана (видано)",
    },
    [1978] = {
        ["Andron's Ledger"] = "гросбух Андрона",
        ["Andron's Ledger (Provided)"] = "гросбух Андрона (видано)",
    },
    [1998] = {
        ["Fenwick's Head"] = "голова Фенвіка",
        ["Fenwick's Head (Provided)"] = "голова Фенвіка (видано)",
    },
    [1999] = {
        ["Dalaran Status Report"] = "звіт про ситуацію в Даларані",
        ["Dalaran Status Report (Provided)"] = "звіт про ситуацію в Даларані (видано)",
    },
    [2038] = {
        ["Bingles' Blastencapper"] = "болтозрив Бінґлса",
        ["Bingles' Blastencapper (Provided)"] = "болтозрив Бінґлса (видано)",
        ["Bingles' Hammer"] = "молоток Бінґлса",
        ["Bingles' Hammer (Provided)"] = "молоток Бінґлса (видано)",
        ["Bingles' Screwdriver"] = "викрутка Бінґлса",
        ["Bingles' Screwdriver (Provided)"] = "викрутка Бінґлса (видано)",
        ["Bingles' Wrench"] = "гайковий ключ Бінґлса",
        ["Bingles' Wrench (Provided)"] = "гайковий ключ Бінґлса (видано)",
    },
    [2040] = {
        ["Gnoam Sprecklesprocket"] = "гномський шпрековерт",
        ["Gnoam Sprecklesprocket (Provided)"] = "гномський шпрековерт (видано)",
    },
    [2078] = {
        ["Gelkak's First Mate"] = "Перший помічник Гелкака",
        ["Gelkak's First Mate (Provided)"] = "Перший помічник Гелкака (видано)",
        ["Gelkak's First Mate slain"] = "Перший помічник Гелкака: убито",
    },
    [2098] = {
        ["Bottom of Gelkak's Key"] = "нижня частина ключа Ґелкака",
        ["Bottom of Gelkak's Key (Provided)"] = "нижня частина ключа Ґелкака (видано)",
        ["Middle of Gelkak's Key"] = "середня частина ключа Ґелкака",
        ["Middle of Gelkak's Key (Provided)"] = "середня частина ключа Ґелкака (видано)",
        ["Top of Gelkak's Key"] = "верхня частина ключа Ґелкака",
        ["Top of Gelkak's Key (Provided)"] = "верхня частина ключа Ґелкака (видано)",
    },
    [2118] = {
        ["Rabid Thistle Bear Captured"] = "Скаженого ведмедя-будькуха спіймали",
        ["Rabid Thistle Bear Captured (Provided)"] = "Скаженого ведмедя-будькуха спіймали (видано)",
        ["Rabid Thistle Bear Captured slain"] = "Скаженого ведмедя-будькуха спіймали: убито",
    },
    [2138] = {
        ["Rabid Thistle Bear"] = "скажений татарний ведмідь",
        ["Rabid Thistle Bear slain"] = "скажений татарний ведмідь: убито",
    },
    [2139] = {
        ["Den Mother"] = "Мати лігва",
        ["Den Mother slain"] = "Мати лігва: убито",
    },
    [2159] = {
        ["Dolanaar Delivery"] = "посилка в Доланаар",
        ["Dolanaar Delivery (Provided)"] = "посилка в Доланаар (видано)",
    },
    [2160] = {
        ["Crate of Inn Supplies"] = "ящик припасів для корчми",
        ["Crate of Inn Supplies (Provided)"] = "ящик припасів для корчми (видано)",
    },
    [2161] = {
        ["Ukor's Burden"] = "ноша Укора",
        ["Ukor's Burden (Provided)"] = "ноша Укора (видано)",
    },
    [2178] = {
        ["Strider Meat"] = "м'ясо бігуна",
        ["Strider Meat (Provided)"] = "м'ясо бігуна (видано)",
    },
    [2198] = {
        ["Shattered Necklace"] = "пошкоджене намисто",
        ["Shattered Necklace (Provided)"] = "пошкоджене намисто (видано)",
    },
    [2199] = {
        ["Silver Bar"] = "злиток срібла",
        ["Silver Bar (Provided)"] = "злиток срібла (видано)",
    },
    [2200] = {
        ["Talvash's Phial of Scrying"] = "фіал провидіння Талваша",
    },
    [2201] = {
        ["Shattered Necklace Ruby"] = "рубін пошкодженого намиста",
        ["Shattered Necklace Ruby (Provided)"] = "рубін пошкодженого намиста (видано)",
        ["Shattered Necklace Sapphire"] = "сапфір пошкодженого намиста",
        ["Shattered Necklace Sapphire (Provided)"] = "сапфір пошкодженого намиста (видано)",
        ["Shattered Necklace Topaz"] = "топаз пошкодженого намиста",
        ["Shattered Necklace Topaz (Provided)"] = "топаз пошкодженого намиста (видано)",
    },
    [2202] = {
        ["Magenta Fungus Cap"] = "гриб-малиновик",
        ["Magenta Fungus Cap (Provided)"] = "гриб-малиновик (видано)",
    },
    [2203] = {
        ["Vessel of Dragon's Blood"] = "флакон з кров'ю дракона",
        ["Vessel of Dragon's Blood (Provided)"] = "флакон з кров'ю дракона (видано)",
    },
    [2204] = {
        ["Shattered Necklace Power Source"] = "джерело сили пошкодженого намиста",
        ["Shattered Necklace Power Source (Provided)"] = "джерело сили пошкодженого намиста (видано)",
    },
    [2205] = {
        ["Delivery to Mathias"] = "пакунок для Матіаса",
        ["Delivery to Mathias (Provided)"] = "пакунок для Матіаса (видано)",
    },
    [2206] = {
        ["Defias Shipping Schedule"] = "розклад постачань Непокірних",
        ["Defias Shipping Schedule (Provided)"] = "розклад постачань Непокірних (видано)",
    },
    [2239] = {
        ["Onin's Report"] = "звіт Оніна",
        ["Onin's Report (Provided)"] = "звіт Оніна (видано)",
    },
    [2240] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Explore the Hidden Chamber"] = "Дослідіть Приховану кімнату",
    },
    [2241] = {
        ["Jannok's Rose"] = "троянда Яннока",
        ["Jannok's Rose (Provided)"] = "троянда Яннока (видано)",
    },
    [2242] = {
        ["Sethir's Journal"] = "щоденник Сетіра",
        ["Sethir's Journal (Provided)"] = "щоденник Сетіра (видано)",
    },
    [2258] = {
        ["Buzzard Gizzard"] = "шлунок канюка",
        ["Buzzard Gizzard (Provided)"] = "шлунок канюка (видано)",
        ["Crag Coyote Fang"] = "ікло скельного койота",
        ["Crag Coyote Fang (Provided)"] = "ікло скельного койота (видано)",
        ["Rock Elemental Shard"] = "уламок кам'яного елементаля",
        ["Rock Elemental Shard (Provided)"] = "уламок кам'яного елементаля (видано)",
    },
    [2278] = {
        ["Learn what lore that the stone watcher has to offer"] = "Дізнайтеся, які знання може запропонувати спостерігач за каменем",
    },
    [2279] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2280] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2282] = {
        ["Token of Thievery"] = "жетон розбійництва",
        ["Token of Thievery (Provided)"] = "жетон розбійництва (видано)",
    },
    [2283] = {
        ["Shattered Necklace"] = "пошкоджене намисто",
        ["Shattered Necklace (Provided)"] = "пошкоджене намисто (видано)",
    },
    [2318] = {
        ["Untranslated Journal"] = "неперекладений щоденник",
    },
    [2338] = {
        ["Untranslated Journal"] = "неперекладений щоденник",
        ["Untranslated Journal (Provided)"] = "неперекладений щоденник (видано)",
    },
    [2339] = {
        ["Shattered Necklace Power Source"] = "джерело сили пошкодженого намиста",
        ["Shattered Necklace Power Source (Provided)"] = "джерело сили пошкодженого намиста (видано)",
        ["Shattered Necklace Ruby"] = "рубін пошкодженого намиста",
        ["Shattered Necklace Ruby (Provided)"] = "рубін пошкодженого намиста (видано)",
        ["Shattered Necklace Sapphire"] = "сапфір пошкодженого намиста",
        ["Shattered Necklace Sapphire (Provided)"] = "сапфір пошкодженого намиста (видано)",
        ["Shattered Necklace Topaz"] = "топаз пошкодженого намиста",
        ["Shattered Necklace Topaz (Provided)"] = "топаз пошкодженого намиста (видано)",
    },
    [2340] = {
        ["Necklace and Gem Salvage"] = "намисто і самоцвіти",
        ["Necklace and Gem Salvage (Provided)"] = "намисто і самоцвіти (видано)",
    },
    [2342] = {
        ["Garrett Family Treasure"] = "родинний скарб Ґарретів",
        ["Garrett Family Treasure (Provided)"] = "родинний скарб Ґарретів (видано)",
    },
    [2358] = {
        ["Horns of Nez'ra"] = "роги Нез'ри",
        ["Horns of Nez'ra (Provided)"] = "роги Нез'ри (видано)",
    },
    [2359] = {
        ["Defias Tower Key"] = "ключ від вежі Непокірних",
        ["Defias Tower Key (Provided)"] = "ключ від вежі Непокірних (видано)",
        ["Klaven Mortwake's Journal"] = "щоденник Клейвена Мортвейка",
        ["Klaven Mortwake's Journal (Provided)"] = "щоденник Клейвена Мортвейка (видано)",
    },
    [2381] = {
        ["Southsea Treasure"] = "скарб Південних морів",
        ["Southsea Treasure (Provided)"] = "скарб Південних морів (видано)",
    },
    [2383] = {
        ["Simple Parchment"] = "простий пергамент",
        ["Simple Parchment (Provided)"] = "простий пергамент (видано)",
    },
    [2418] = {
        ["An'Alleum Power Stone"] = "камінь сили Ан'Аллеума",
        ["An'Alleum Power Stone (Provided)"] = "камінь сили Ан'Аллеума (видано)",
        ["Dentrium Power Stone"] = "дентрієвий камінь сили",
        ["Dentrium Power Stone (Provided)"] = "дентрієвий камінь сили (видано)",
    },
    [2438] = {
        ["Emerald Dreamcatcher"] = "смарагдовий ловець снів",
        ["Emerald Dreamcatcher (Provided)"] = "смарагдовий ловець снів (видано)",
    },
    [2439] = {
        ["Reward Voucher"] = "талон на винагороду",
        ["Reward Voucher (Provided)"] = "талон на винагороду (видано)",
    },
    [2440] = {
        ["Reward Voucher"] = "талон на винагороду",
        ["Reward Voucher (Provided)"] = "талон на винагороду (видано)",
    },
    [2458] = {
        ["Flare Gun"] = "сигнальний пістолет",
    },
    [2459] = {
        ["Gnarlpine Mystic"] = "містик Кривої Сосни",
        ["Gnarlpine Mystic slain"] = "містик Кривої Сосни: убито",
        ["Tallonkai's Jewel"] = "самоцвіт Таллонкая",
        ["Tallonkai's Jewel (Provided)"] = "самоцвіт Таллонкая (видано)",
    },
    [2460] = {
        ["Shattered Salute Performed"] = "Виконано «Розбитий салют»",
    },
    [2478] = {
        ["Cache of Zanzil's Altered Mixture"] = "запас зміненої суміші Занзіла",
        ["Cache of Zanzil's Altered Mixture (Provided)"] = "запас зміненої суміші Занзіла (видано)",
        ["Gallywix's Head"] = "голова Ґаллівікса",
        ["Gallywix's Head (Provided)"] = "голова Ґаллівікса (видано)",
        ["Mutated Venture Co. Drone"] = "мутований мрець ТзНБ \"Авантюра\"",
        ["Mutated Venture Co. Drone slain"] = "мутований мрець ТзНБ \"Авантюра\": убито",
        ["Silixiz's Tower Key"] = "ключ від вежі Силіксиза",
        ["Silixiz's Tower Key (Provided)"] = "ключ від вежі Силіксиза (видано)",
        ["Venture Co. Lookout"] = "спостерігач ТзНБ \"Авантюра\"",
        ["Venture Co. Lookout slain"] = "спостерігач ТзНБ \"Авантюра\": убито",
        ["Venture Co. Patroller"] = "патрульний ТзНБ \"Авантюра\"",
        ["Venture Co. Patroller slain"] = "патрульний ТзНБ \"Авантюра\": убито",
    },
    [2479] = {
        ["Sample of Zanzil's Altered Mixture"] = "зразок зміненої суміші Занзіла",
        ["Sample of Zanzil's Altered Mixture (Provided)"] = "зразок зміненої суміші Занзіла (видано)",
    },
    [2480] = {
        ["Cure Completed"] = "Лікування завершено",
    },
    [2499] = {
        ["Gargantuan Tumor"] = "велетенська пухлина",
        ["Gargantuan Tumor (Provided)"] = "велетенська пухлина (видано)",
    },
    [2500] = {
        ["Buzzard Gizzard"] = "шлунок канюка",
        ["Buzzard Gizzard (Provided)"] = "шлунок канюка (видано)",
        ["Crag Coyote Fang"] = "ікло скельного койота",
        ["Crag Coyote Fang (Provided)"] = "ікло скельного койота (видано)",
        ["Rock Elemental Shard"] = "уламок кам'яного елементаля",
        ["Rock Elemental Shard (Provided)"] = "уламок кам'яного елементаля (видано)",
    },
    [2501] = {
        ["Vessel of Dragon's Blood"] = "флакон з кров'ю дракона",
        ["Vessel of Dragon's Blood (Provided)"] = "флакон з кров'ю дракона (видано)",
    },
    [2518] = {
        ["Silvery Spinnerets"] = "сріблопавутинні залози",
        ["Silvery Spinnerets (Provided)"] = "сріблопавутинні залози (видано)",
    },
    [2520] = {
        ["Offer the sacrifice at the fountain"] = "Принесіть жертву біля джерела",
    },
    [2521] = {
        ["Flawless Draenethyst Sphere"] = "бездоганна сфера з дренетисту",
        ["Flawless Draenethyst Sphere (Provided)"] = "бездоганна сфера з дренетисту (видано)",
    },
    [2522] = {
        ["Flawless Draenethyst Sphere"] = "бездоганна сфера з дренетисту",
        ["Flawless Draenethyst Sphere (Provided)"] = "бездоганна сфера з дренетисту (видано)",
    },
    [2523] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [2541] = {
        ["Shaman Voodoo Charm"] = "шаманський оберіг вуду",
        ["Shaman Voodoo Charm (Provided)"] = "шаманський оберіг вуду (видано)",
    },
    [2561] = {
        ["Rageclaw"] = "Лютопазур",
        ["Rageclaw slain"] = "Лютопазур: убито",
    },
    [2581] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Snickerfang Jowl (Provided)"] = "щелепа хихотуна (видано)",
    },
    [2582] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Snickerfang Jowl (Provided)"] = "щелепа хихотуна (видано)",
    },
    [2583] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Basilisk Brain (Provided)"] = "мозок василіска (видано)",
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
    },
    [2584] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Basilisk Brain (Provided)"] = "мозок василіска (видано)",
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
    },
    [2585] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2586] = {
        ["Blasted Boar Lung"] = "легеня пеклокнура",
        ["Blasted Boar Lung (Provided)"] = "легеня пеклокнура (видано)",
        ["Scorpok Pincer"] = "клешня скорпока",
        ["Scorpok Pincer (Provided)"] = "клешня скорпока (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2601] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Basilisk Brain (Provided)"] = "мозок василіска (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2602] = {
        ["Basilisk Brain"] = "мозок василіска",
        ["Basilisk Brain (Provided)"] = "мозок василіска (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2603] = {
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Snickerfang Jowl (Provided)"] = "щелепа хихотуна (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2604] = {
        ["Snickerfang Jowl"] = "щелепа хихотуна",
        ["Snickerfang Jowl (Provided)"] = "щелепа хихотуна (видано)",
        ["Vulture Gizzard"] = "шлунок стерв'ятника",
        ["Vulture Gizzard (Provided)"] = "шлунок стерв'ятника (видано)",
    },
    [2605] = {
        ["Laden Dew Gland"] = "насичена росяна залоза",
        ["Laden Dew Gland (Provided)"] = "насичена росяна залоза (видано)",
    },
    [2606] = {
        ["Thistleshrub Dew"] = "чортополохова роса",
        ["Thistleshrub Dew (Provided)"] = "чортополохова роса (видано)",
    },
    [2608] = {
        ["Diagnosis Complete"] = "Діагностика завершена",
    },
    [2609] = {
        ["Bronze Tube"] = "бронзова трубка",
        ["Bronze Tube (Provided)"] = "бронзова трубка (видано)",
        ["Leaded Vial"] = "свинцевий фіал",
        ["Leaded Vial (Provided)"] = "свинцевий фіал (видано)",
        ["Simple Wildflowers"] = "прості польові квіти",
        ["Simple Wildflowers (Provided)"] = "прості польові квіти (видано)",
        ["Spool of Light Chartreuse Silk Thread"] = "котушка світло-оливкових шовкових ниток",
        ["Spool of Light Chartreuse Silk Thread (Provided)"] = "котушка світло-оливкових шовкових ниток (видано)",
    },
    [2623] = {
        ["Warchief's Orders"] = "накази воєвождя",
        ["Warchief's Orders (Provided)"] = "накази воєвождя (видано)",
    },
    [2641] = {
        ["Violet Tragan"] = "фіалковий траган",
        ["Violet Tragan (Provided)"] = "фіалковий траган (видано)",
    },
    [2661] = {
        ["Violet Powder"] = "фіалковий порошок",
        ["Violet Powder (Provided)"] = "фіалковий порошок (видано)",
    },
    [2681] = {
        ["Servants of Allistarj Freed"] = "Звільнені слуги Алістарджа",
        ["Servants of Allistarj Freed (Provided)"] = "Звільнені слуги Алістарджа (видано)",
        ["Servants of Allistarj Freed slain"] = "Звільнені слуги Алістарджа: убито",
        ["Servants of Grol Freed"] = "Слуги Грола Фріда",
        ["Servants of Grol Freed (Provided)"] = "Слуги Грола Фріда (видано)",
        ["Servants of Grol Freed slain"] = "Слуги Грола Фріда: убито",
        ["Servants of Razelikh Freed"] = "Слуги Разеліха Фріда",
        ["Servants of Razelikh Freed (Provided)"] = "Слуги Разеліха Фріда (видано)",
        ["Servants of Razelikh Freed slain"] = "Слуги Разеліха Фріда: убито",
        ["Servants of Sevine Freed"] = "Слуги Севін Фрід",
        ["Servants of Sevine Freed (Provided)"] = "Слуги Севін Фрід (видано)",
        ["Servants of Sevine Freed slain"] = "Слуги Севін Фрід: убито",
    },
    [2741] = {
        ["Hippogryph Egg"] = "яйце гіпогрифа",
        ["Hippogryph Egg (Provided)"] = "яйце гіпогрифа (видано)",
    },
    [2742] = {
        ["Escort Rin'ji to safety"] = "Супроводьте Рінджі у безпечне місце",
    },
    [2744] = {
        ["Conversation with Loramus"] = "Розмова з Лорамом",
    },
    [2746] = {
        ["Clara's Fresh Apple"] = "свіже яблуко Клари",
        ["Clara's Fresh Apple (Provided)"] = "свіже яблуко Клари (видано)",
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [2747] = {
        ["Extraordinary Egg"] = "незвичайне яйце",
        ["Extraordinary Egg (Provided)"] = "незвичайне яйце (видано)",
    },
    [2748] = {
        ["Fine Egg"] = "чудове яйце",
        ["Fine Egg (Provided)"] = "чудове яйце (видано)",
    },
    [2749] = {
        ["Ordinary Egg"] = "звичайне яйце",
        ["Ordinary Egg (Provided)"] = "звичайне яйце (видано)",
    },
    [2750] = {
        ["Bad Egg"] = "погане яйце",
        ["Bad Egg (Provided)"] = "погане яйце (видано)",
    },
    [2751] = {
        ["Bronze Greatsword"] = "довгий бронзовий меч",
        ["Bronze Greatsword (Provided)"] = "довгий бронзовий меч (видано)",
        ["Patterned Bronze Bracers"] = "візерунчасті бронзові поручі",
        ["Patterned Bronze Bracers (Provided)"] = "візерунчасті бронзові поручі (видано)",
        ["Sharp Claw"] = "гострий кіготь",
        ["Sharp Claw (Provided)"] = "гострий кіготь (видано)",
    },
    [2752] = {
        ["Bronze Battle Axe"] = "бронзова бойова сокира",
        ["Bronze Battle Axe (Provided)"] = "бронзова бойова сокира (видано)",
        ["Bronze Warhammer"] = "бронзовий бойовий молот",
        ["Bronze Warhammer (Provided)"] = "бронзовий бойовий молот (видано)",
    },
    [2753] = {
        ["Green Iron Bracers"] = "зелені залізні браслети",
        ["Green Iron Bracers (Provided)"] = "зелені залізні браслети (видано)",
        ["Green Iron Helm"] = "зелений залізний шолом",
        ["Green Iron Helm (Provided)"] = "зелений залізний шолом (видано)",
        ["Green Iron Leggings"] = "зелені залізні поножі",
        ["Green Iron Leggings (Provided)"] = "зелені залізні поножі (видано)",
    },
    [2754] = {
        ["Silvered Bronze Boots"] = "посріблені бронзові чоботи",
        ["Silvered Bronze Boots (Provided)"] = "посріблені бронзові чоботи (видано)",
        ["Silvered Bronze Gauntlets"] = "посріблені бронзові рукавиці",
        ["Silvered Bronze Gauntlets (Provided)"] = "посріблені бронзові рукавиці (видано)",
        ["Solid Iron Maul"] = "міцний залізний молот",
        ["Solid Iron Maul (Provided)"] = "міцний залізний молот (видано)",
    },
    [2755] = {
        ["Omosh Dance of Joy Learned"] = "Омош Танець радості вивчений",
    },
    [2756] = {
        ["Steel Breastplate"] = "сталева кіраса",
        ["Steel Breastplate (Provided)"] = "сталева кіраса (видано)",
        ["Steel Plate Helm"] = "сталевий шолом",
        ["Steel Plate Helm (Provided)"] = "сталевий шолом (видано)",
    },
    [2757] = {
        ["Mithril Insignia"] = "мітрилова печатка",
        ["Mithril Insignia (Provided)"] = "мітрилова печатка (видано)",
    },
    [2758] = {
        ["Golden Scale Bracers"] = "золоті лускаті браслети",
        ["Golden Scale Bracers (Provided)"] = "золоті лускаті браслети (видано)",
    },
    [2759] = {
        ["Mithril Insignia"] = "мітрилова печатка",
        ["Mithril Insignia (Provided)"] = "мітрилова печатка (видано)",
    },
    [2760] = {
        ["Mithril Pendant"] = "мітрилова підвіска",
        ["Mithril Pendant (Provided)"] = "мітрилова підвіска (видано)",
    },
    [2761] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
    },
    [2762] = {
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
        ["Truesilver Bar"] = "злиток ясносрібла",
        ["Truesilver Bar (Provided)"] = "злиток ясносрібла (видано)",
    },
    [2763] = {
        ["Citrine"] = "цитрин",
        ["Citrine (Provided)"] = "цитрин (видано)",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
    },
    [2765] = {
        ["You Are The Big Winner"] = "Ти — головний переможець",
    },
    [2766] = {
        ["OOX-22/FE Distress Beacon"] = "аварійний маяк OOX-22/ФЕ",
        ["OOX-22/FE Distress Beacon (Provided)"] = "аварійний маяк OOX-22/ФЕ (видано)",
    },
    [2767] = {
        ["Escort OOX-22/FE to the dock along the Forgotten Coast"] = "Супровід OOX-22/FE до доку вздовж Забутого узбережжя",
    },
    [2768] = {
        ["Divino-matic Rod"] = "водоматичний стрижень",
        ["Divino-matic Rod (Provided)"] = "водоматичний стрижень (видано)",
    },
    [2770] = {
        ["Gahz'rilla's Electrified Scale"] = "наелектризована луска Ґаз'рілли",
        ["Gahz'rilla's Electrified Scale (Provided)"] = "наелектризована луска Ґаз'рілли (видано)",
    },
    [2771] = {
        ["Mithril Coif"] = "мітриловий капюшон",
        ["Mithril Coif (Provided)"] = "мітриловий капюшон (видано)",
        ["Ornate Mithril Shoulder"] = "вишукані мітрилові наплічники",
        ["Ornate Mithril Shoulder (Provided)"] = "вишукані мітрилові наплічники (видано)",
    },
    [2772] = {
        ["Heavy Mithril Boots"] = "важкі мітрилові чоботи",
        ["Heavy Mithril Boots (Provided)"] = "важкі мітрилові чоботи (видано)",
        ["Ornate Mithril Pants"] = "вишукані мітрилові штани",
        ["Ornate Mithril Pants (Provided)"] = "вишукані мітрилові штани (видано)",
    },
    [2773] = {
        ["Heavy Mithril Breastplate"] = "важка мітрилова кіраса",
        ["Heavy Mithril Breastplate (Provided)"] = "важка мітрилова кіраса (видано)",
        ["Ornate Mithril Gloves"] = "вишукані мітрилові рукавиці",
        ["Ornate Mithril Gloves (Provided)"] = "вишукані мітрилові рукавиці (видано)",
    },
    [2781] = {
        ["Caliph Scorpidsting's Head"] = "голова Халіфа Скорпідожала",
        ["Caliph Scorpidsting's Head (Provided)"] = "голова Халіфа Скорпідожала (видано)",
    },
    [2782] = {
        ["Rin'ji's Secret"] = "таємничка Рін'джі",
        ["Rin'ji's Secret (Provided)"] = "таємничка Рін'джі (видано)",
    },
    [2784] = {
        ["The Tale of Sorrow"] = "Казка про печаль",
    },
    [2801] = {
        ["A Tale of Sorrow"] = "Оповідь про горе",
    },
    [2821] = {
        ["Thick Yeti Hide"] = "товста шкура єті",
        ["Thick Yeti Hide (Provided)"] = "товста шкура єті (видано)",
    },
    [2822] = {
        ["Thick Yeti Hide"] = "товста шкура єті",
        ["Thick Yeti Hide (Provided)"] = "товста шкура єті (видано)",
    },
    [2841] = {
        ["Rig Blueprints"] = "креслення машини",
        ["Rig Blueprints (Provided)"] = "креслення машини (видано)",
        ["Thermaplugg's Safe Combination"] = "код від сейфа Термоштепселя",
        ["Thermaplugg's Safe Combination (Provided)"] = "код від сейфа Термоштепселя (видано)",
    },
    [2843] = {
        ["Goblin Transponder"] = "гоблінський транспондер",
    },
    [2845] = {
        ["Shay's Bell"] = "дзвіночок Шей",
        ["Shay's Bell (Provided)"] = "дзвіночок Шей (видано)",
    },
    [2846] = {
        ["Tiara of the Deep"] = "тіара Глибин",
        ["Tiara of the Deep (Provided)"] = "тіара Глибин (видано)",
    },
    [2847] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [2848] = {
        ["Thick Armor Kit"] = "накладки з товстої шкіри",
        ["Thick Armor Kit (Provided)"] = "накладки з товстої шкіри (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2849] = {
        ["Turtle Scale Breastplate"] = "кіраса з черепашачої луски",
        ["Turtle Scale Breastplate (Provided)"] = "кіраса з черепашачої луски (видано)",
        ["Turtle Scale Gloves"] = "рукавиці з черепашачої луски",
        ["Turtle Scale Gloves (Provided)"] = "рукавиці з черепашачої луски (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2850] = {
        ["Nightscape Headband"] = "пов'язка нічного краєвиду",
        ["Nightscape Headband (Provided)"] = "пов'язка нічного краєвиду (видано)",
        ["Nightscape Tunic"] = "мундир нічного краєвиду",
        ["Nightscape Tunic (Provided)"] = "мундир нічного краєвиду (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2851] = {
        ["Nightscape Boots"] = "чоботи нічного краєвиду",
        ["Nightscape Boots (Provided)"] = "чоботи нічного краєвиду (видано)",
        ["Nightscape Pants"] = "штани нічного краєвиду",
        ["Nightscape Pants (Provided)"] = "штани нічного краєвиду (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2852] = {
        ["Turtle Scale Bracers"] = "браслети з черепашачої луски",
        ["Turtle Scale Bracers (Provided)"] = "браслети з черепашачої луски (видано)",
        ["Turtle Scale Helm"] = "шолом з черепашачої луски",
        ["Turtle Scale Helm (Provided)"] = "шолом з черепашачої луски (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2853] = {
        ["Pratt's Letter"] = "лист Пратта",
        ["Pratt's Letter (Provided)"] = "лист Пратта (видано)",
    },
    [2854] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [2855] = {
        ["Thick Armor Kit"] = "накладки з товстої шкіри",
        ["Thick Armor Kit (Provided)"] = "накладки з товстої шкіри (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2856] = {
        ["Turtle Scale Breastplate"] = "кіраса з черепашачої луски",
        ["Turtle Scale Breastplate (Provided)"] = "кіраса з черепашачої луски (видано)",
        ["Turtle Scale Gloves"] = "рукавиці з черепашачої луски",
        ["Turtle Scale Gloves (Provided)"] = "рукавиці з черепашачої луски (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2857] = {
        ["Nightscape Headband"] = "пов'язка нічного краєвиду",
        ["Nightscape Headband (Provided)"] = "пов'язка нічного краєвиду (видано)",
        ["Nightscape Tunic"] = "мундир нічного краєвиду",
        ["Nightscape Tunic (Provided)"] = "мундир нічного краєвиду (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2858] = {
        ["Nightscape Boots"] = "чоботи нічного краєвиду",
        ["Nightscape Boots (Provided)"] = "чоботи нічного краєвиду (видано)",
        ["Nightscape Pants"] = "штани нічного краєвиду",
        ["Nightscape Pants (Provided)"] = "штани нічного краєвиду (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2859] = {
        ["Turtle Scale Bracers"] = "браслети з черепашачої луски",
        ["Turtle Scale Bracers (Provided)"] = "браслети з черепашачої луски (видано)",
        ["Turtle Scale Helm"] = "шолом з черепашачої луски",
        ["Turtle Scale Helm (Provided)"] = "шолом з черепашачої луски (видано)",
        ["Wildvine"] = "диколоззя",
        ["Wildvine (Provided)"] = "диколоззя (видано)",
    },
    [2860] = {
        ["Jangdor's Letter"] = "лист Джанґдора",
        ["Jangdor's Letter (Provided)"] = "лист Джанґдора (видано)",
    },
    [2862] = {
        ["Woodpaw Gnoll Mane"] = "грива дереволапого гнола",
        ["Woodpaw Gnoll Mane (Provided)"] = "грива дереволапого гнола (видано)",
    },
    [2863] = {
        ["Woodpaw Alpha"] = "дереволапий альфа",
        ["Woodpaw Alpha slain"] = "дереволапий альфа: убито",
    },
    [2865] = {
        ["Uncracked Scarab Shell"] = "цілий панцир скарабея",
        ["Uncracked Scarab Shell (Provided)"] = "цілий панцир скарабея (видано)",
    },
    [2868] = {
        ["Item #9243"] = "Товар №9243",
        ["Item #9243 (Provided)"] = "Товар №9243 (видано)",
    },
    [2869] = {
        ["Hatecrest Naga Scale"] = "луска наги Гребеня Ненависті",
        ["Hatecrest Naga Scale (Provided)"] = "луска наги Гребеня Ненависті (видано)",
    },
    [2870] = {
        ["Mysterious Relic"] = "таємнича реліквія",
        ["Mysterious Relic (Provided)"] = "таємнича реліквія (видано)",
    },
    [2871] = {
        ["Mysterious Relic"] = "таємнича реліквія",
        ["Mysterious Relic (Provided)"] = "таємнича реліквія (видано)",
    },
    [2873] = {
        ["Stoley's Shipment"] = "вантаж Стоулі",
        ["Stoley's Shipment (Provided)"] = "вантаж Стоулі (видано)",
    },
    [2874] = {
        ["Stoley's Bottle"] = "пляшка Стоулі",
        ["Stoley's Bottle (Provided)"] = "пляшка Стоулі (видано)",
    },
    [2875] = {
        ["Firebeard's Head"] = "голова Вогнебородого",
        ["Firebeard's Head (Provided)"] = "голова Вогнебородого (видано)",
    },
    [2876] = {
        ["Ship Schedule"] = "розклад кораблів",
        ["Ship Schedule (Provided)"] = "розклад кораблів (видано)",
    },
    [2877] = {
        ["Green Sludge"] = "зелений шлам",
        ["Green Sludge slain"] = "зелений шлам: убито",
        ["Jade Ooze"] = "нефритовий слизень",
        ["Jade Ooze slain"] = "нефритовий слизень: убито",
    },
    [2878] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [2879] = {
        ["Stave of Equinex"] = "посох рівнодення",
        ["Stave of Equinex (Provided)"] = "посох рівнодення (видано)",
    },
    [2880] = {
        ["Troll Tribal Necklace"] = "племінне намисто тролів",
        ["Troll Tribal Necklace (Provided)"] = "племінне намисто тролів (видано)",
    },
    [2881] = {
        ["Troll Tribal Necklace"] = "племінне намисто тролів",
        ["Troll Tribal Necklace (Provided)"] = "племінне намисто тролів (видано)",
    },
    [2882] = {
        ["Cuergo's Key"] = "ключ Куерґо",
        ["Cuergo's Key (Provided)"] = "ключ Куерґо (видано)",
    },
    [2903] = {
        ["Woodpaw Battle Plans"] = "бойові плани Дереволапих",
        ["Woodpaw Battle Plans (Provided)"] = "бойові плани Дереволапих (видано)",
    },
    [2904] = {
        ["Kernobee Rescue"] = "Рятувальний майданчик Кернобі",
    },
    [2922] = {
        ["Techbot's Memory Core"] = "ядро пам'яті Техбота",
        ["Techbot's Memory Core (Provided)"] = "ядро пам'яті Техбота (видано)",
    },
    [2924] = {
        ["Essential Artificial"] = "базовий штучень",
        ["Essential Artificial (Provided)"] = "базовий штучень (видано)",
    },
    [2926] = {
        ["Full Leaden Collection Phial"] = "наповнений свинцевий фіал для зразків",
        ["Full Leaden Collection Phial (Provided)"] = "наповнений свинцевий фіал для зразків (видано)",
    },
    [2928] = {
        ["Robo-mechanical Guts"] = "робо-механічні нутрощі",
        ["Robo-mechanical Guts (Provided)"] = "робо-механічні нутрощі (видано)",
    },
    [2929] = {
        ["Mekgineer Thermaplugg"] = "Термоштекер Mekgineer",
        ["Mekgineer Thermaplugg (Provided)"] = "Термоштекер Mekgineer (видано)",
        ["Mekgineer Thermaplugg slain"] = "Термоштекер Mekgineer: убито",
    },
    [2930] = {
        ["Prismatic Punch Card"] = "призматична перфокарта",
        ["Prismatic Punch Card (Provided)"] = "призматична перфокарта (видано)",
    },
    [2932] = {
        ["Place the grim message."] = "Розмістіть похмуре повідомлення.",
        ["Witherbark Skull"] = "череп троля Зів'ялої Кори",
    },
    [2933] = {
        ["Venom Bottle"] = "пляшка з отрутою",
        ["Venom Bottle (Provided)"] = "пляшка з отрутою (видано)",
    },
    [2934] = {
        ["Undamaged Venom Sac"] = "неушкоджена отруйна залоза",
        ["Undamaged Venom Sac (Provided)"] = "неушкоджена отруйна залоза (видано)",
    },
    [2936] = {
        ["Find the Spider God's Name"] = "Знайдіть ім'я бога-павука",
    },
    [2937] = {
        ["Shadra's Venom"] = "отрута Шадри",
        ["Shadra's Venom (Provided)"] = "отрута Шадри (видано)",
    },
    [2938] = {
        ["Faranell's Parcel"] = "пакунок Фаранелла",
        ["Faranell's Parcel (Provided)"] = "пакунок Фаранелла (видано)",
    },
    [2941] = {
        ["A Short Note"] = "коротка записка",
        ["A Short Note (Provided)"] = "коротка записка (видано)",
    },
    [2942] = {
        ["A Sparkling Stone"] = "іскристий камінь",
        ["A Sparkling Stone (Provided)"] = "іскристий камінь (видано)",
        ["Stave of Equinex"] = "посох рівнодення",
        ["Stave of Equinex (Provided)"] = "посох рівнодення (видано)",
    },
    [2943] = {
        ["Feralas: A History"] = "Історія Фераласа",
        ["Feralas: A History (Provided)"] = "Історія Фераласа (видано)",
    },
    [2944] = {
        ["Snapshot of Gammerita"] = "знімок Ґаммеріти",
        ["Snapshot of Gammerita (Provided)"] = "знімок Ґаммеріти (видано)",
        ["Super Snapper FX"] = "Суперзахоплювач ФХ",
        ["Super Snapper FX (Provided)"] = "Суперзахоплювач ФХ (видано)",
    },
    [2945] = {
        ["Grime-Encrusted Ring"] = "вкритий брудом перстень",
        ["Grime-Encrusted Ring (Provided)"] = "вкритий брудом перстень (видано)",
    },
    [2946] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2947] = {
        ["Brilliant Gold Ring"] = "блискучий золотий перстень",
        ["Brilliant Gold Ring (Provided)"] = "блискучий золотий перстень (видано)",
    },
    [2948] = {
        ["Brilliant Gold Ring"] = "блискучий золотий перстень",
        ["Brilliant Gold Ring (Provided)"] = "блискучий золотий перстень (видано)",
        ["Moss Agate"] = "моховий агат",
        ["Moss Agate (Provided)"] = "моховий агат (видано)",
        ["Silver Bar"] = "злиток срібла",
        ["Silver Bar (Provided)"] = "злиток срібла (видано)",
    },
    [2949] = {
        ["Brilliant Gold Ring"] = "блискучий золотий перстень",
        ["Brilliant Gold Ring (Provided)"] = "блискучий золотий перстень (видано)",
    },
    [2950] = {
        ["Brilliant Gold Ring"] = "блискучий золотий перстень",
        ["Brilliant Gold Ring (Provided)"] = "блискучий золотий перстень (видано)",
        ["Moss Agate"] = "моховий агат",
        ["Moss Agate (Provided)"] = "моховий агат (видано)",
        ["Silver Bar"] = "злиток срібла",
        ["Silver Bar (Provided)"] = "злиток срібла (видано)",
    },
    [2951] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [2953] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [2954] = {
        ["Learn the purpose of the Stone Watcher of Norgannon"] = "Дізнайтеся про призначення Кам'яного Вартового з Норганнона",
    },
    [2962] = {
        ["Heavy Leaden Collection Phial"] = "важкий свинцевий фіал для зразків",
        ["Heavy Leaden Collection Phial (Provided)"] = "важкий свинцевий фіал для зразків (видано)",
        ["High Potency Radioactive Fallout"] = "високорадіоактивний осад",
        ["High Potency Radioactive Fallout (Provided)"] = "високорадіоактивний осад (видано)",
    },
    [2966] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2967] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2969] = {
        ["Save at least 6 Sprite Darters from capture"] = "Врятуйте щонайменше 6 Спрайт Дартерів від захоплення",
    },
    [2970] = {
        ["Grimtotem Naturalist"] = "натураліст Зловісного Тотема",
        ["Grimtotem Naturalist slain"] = "натураліст Зловісного Тотема: убито",
        ["Grimtotem Raider"] = "рейдер Зловісного Тотема",
        ["Grimtotem Raider slain"] = "рейдер Зловісного Тотема: убито",
        ["Grimtotem Shaman"] = "шаман Зловісного Тотема",
        ["Grimtotem Shaman slain"] = "шаман Зловісного Тотема: убито",
    },
    [2971] = {
        ["[PH] Log Bullet Entry"] = "[PH] Запис у журналі",
    },
    [2972] = {
        ["Jer'kai's Signet Ring"] = "перстень-печатка Джер'кай",
        ["Jer'kai's Signet Ring (Provided)"] = "перстень-печатка Джер'кай (видано)",
    },
    [2973] = {
        ["Iridescent Sprite Darter Wing"] = "переливчасте крило райдужного хамелеона",
        ["Iridescent Sprite Darter Wing (Provided)"] = "переливчасте крило райдужного хамелеона (видано)",
    },
    [2974] = {
        ["Grimtotem Horn"] = "ріг Зловісного Тотема",
        ["Grimtotem Horn (Provided)"] = "ріг Зловісного Тотема (видано)",
    },
    [2975] = {
        ["Gordunni Brute"] = "моцак Ґордунні",
        ["Gordunni Brute slain"] = "моцак Ґордунні: убито",
        ["Gordunni Ogre"] = "огр Ґордунні",
        ["Gordunni Ogre Mage"] = "огр-маг Ґордунні",
        ["Gordunni Ogre Mage slain"] = "огр-маг Ґордунні: убито",
        ["Gordunni Ogre slain"] = "огр Ґордунні: убито",
    },
    [2976] = {
        ["Crate of Grimtotem Horns"] = "ящик з рогами Зловісного Тотема",
        ["Crate of Grimtotem Horns (Provided)"] = "ящик з рогами Зловісного Тотема (видано)",
    },
    [2977] = {
        ["Miniature Platinum Discs"] = "мініатюрні платинові диски",
        ["Miniature Platinum Discs (Provided)"] = "мініатюрні платинові диски (видано)",
    },
    [2978] = {
        ["Gordunni Scroll"] = "сувій Ґордунні",
        ["Gordunni Scroll (Provided)"] = "сувій Ґордунні (видано)",
    },
    [2979] = {
        ["Gordunni Orb"] = "сфера Ґордунні",
        ["Gordunni Orb (Provided)"] = "сфера Ґордунні (видано)",
    },
    [2980] = {
        ["Gordunni Mauler"] = "молотобій Ґордунні",
        ["Gordunni Mauler slain"] = "молотобій Ґордунні: убито",
        ["Gordunni Shaman"] = "шаман Ґордунні",
        ["Gordunni Shaman slain"] = "шаман Ґордунні: убито",
        ["Gordunni Warlock"] = "чорнокнижник Ґордунні",
        ["Gordunni Warlock slain"] = "чорнокнижник Ґордунні: убито",
    },
    [2982] = {
        ["Gordunni Brute"] = "моцак Ґордунні",
        ["Gordunni Brute slain"] = "моцак Ґордунні: убито",
        ["Gordunni Shaman"] = "шаман Ґордунні",
        ["Gordunni Shaman slain"] = "шаман Ґордунні: убито",
        ["Gordunni Warlock"] = "чорнокнижник Ґордунні",
        ["Gordunni Warlock slain"] = "чорнокнижник Ґордунні: убито",
    },
    [2987] = {
        ["Gordunni Cobalt"] = "кобальт Ґордунні",
        ["Gordunni Cobalt (Provided)"] = "кобальт Ґордунні (видано)",
        ["Orwin's Shovel"] = "лопата Орвіна",
        ["Orwin's Shovel (Provided)"] = "лопата Орвіна (видано)",
    },
    [2988] = {
        ["Check First Cage"] = "Перевірте першу клітку",
        ["Check Second Cage"] = "Перевірте другу клітку",
        ["Check Third Cage"] = "Перевірте третю клітку",
    },
    [2989] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Search the Altar of Zul"] = "Обшукайте вівтар Зула",
    },
    [2990] = {
        ["Sharpbeak's Feather"] = "перо Гостродзьоба",
        ["Sharpbeak's Feather (Provided)"] = "перо Гостродзьоба (видано)",
    },
    [2991] = {
        ["Nekrum's Medallion"] = "медальйон Некрума",
        ["Nekrum's Medallion (Provided)"] = "медальйон Некрума (видано)",
    },
    [2992] = {
        ["Wait for Grimshade to finish"] = "Зачекайте, поки Грімшейд закінчить",
    },
    [2994] = {
        ["Open Sharpbeak's Cage"] = "Відкрийте клітку Гостроклюва",
        ["Open Sharpbeak's Cage (Provided)"] = "Відкрийте клітку Гостроклюва (видано)",
        ["Open Sharpbeak's Cage slain"] = "Відкрийте клітку Гостроклюва: убито",
    },
    [2995] = {
        ["Burn the Highvale Notes"] = "Спаліть нотатки Хайвейла",
        ["Burn the Highvale Notes (Provided)"] = "Спаліть нотатки Хайвейла (видано)",
        ["Burn the Highvale Notes slain"] = "Спаліть нотатки Хайвейла: убито",
        ["Burn the Highvale Records"] = "Спаліть записи Хайвейла",
        ["Burn the Highvale Records (Provided)"] = "Спаліть записи Хайвейла (видано)",
        ["Burn the Highvale Records slain"] = "Спаліть записи Хайвейла: убито",
        ["Burn the Highvale Report"] = "Спаліть звіт Хайвейл",
        ["Burn the Highvale Report (Provided)"] = "Спаліть звіт Хайвейл (видано)",
        ["Burn the Highvale Report slain"] = "Спаліть звіт Хайвейл: убито",
    },
    [3002] = {
        ["Gordunni Orb"] = "сфера Ґордунні",
        ["Gordunni Orb (Provided)"] = "сфера Ґордунні (видано)",
    },
    [3022] = {
        ["A Carefully-packed Crate"] = "дбайливо запакований ящик",
        ["A Carefully-packed Crate (Provided)"] = "дбайливо запакований ящик (видано)",
    },
    [3042] = {
        ["Troll Temper"] = "трольське місиво",
        ["Troll Temper (Provided)"] = "трольське місиво (видано)",
    },
    [3062] = {
        ["Edana's Dark Heart"] = "темне серце Едани",
        ["Edana's Dark Heart (Provided)"] = "темне серце Едани (видано)",
    },
    [3063] = {
        ["Northspring Harpy"] = "північноджерельна гарпія",
        ["Northspring Harpy slain"] = "північноджерельна гарпія: убито",
        ["Northspring Roguefeather"] = "північноджерельна оперена пройдисвітка",
        ["Northspring Roguefeather slain"] = "північноджерельна оперена пройдисвітка: убито",
        ["Northspring Slayer"] = "північноджерельна вбивця",
        ["Northspring Slayer slain"] = "північноджерельна вбивця: убито",
        ["Northspring Windcaller"] = "північноджерельна вітрозовка",
        ["Northspring Windcaller slain"] = "північноджерельна вітрозовка: убито",
    },
    [3065] = {
        ["Simple Tablet"] = "проста скрижаль",
        ["Simple Tablet (Provided)"] = "проста скрижаль (видано)",
    },
    [3082] = {
        ["Etched Tablet"] = "гравійована скрижаль",
        ["Etched Tablet (Provided)"] = "гравійована скрижаль (видано)",
    },
    [3083] = {
        ["Encrypted Tablet"] = "зашифрована скрижаль",
        ["Encrypted Tablet (Provided)"] = "зашифрована скрижаль (видано)",
    },
    [3084] = {
        ["Rune-Inscribed Tablet"] = "рунічна скрижаль",
        ["Rune-Inscribed Tablet (Provided)"] = "рунічна скрижаль (видано)",
    },
    [3085] = {
        ["Hallowed Tablet"] = "священна скрижаль",
        ["Hallowed Tablet (Provided)"] = "священна скрижаль (видано)",
    },
    [3086] = {
        ["Glyphic Tablet"] = "гліфічна скрижаль",
        ["Glyphic Tablet (Provided)"] = "гліфічна скрижаль (видано)",
    },
    [3087] = {
        ["Etched Parchment"] = "гравійований пергамент",
        ["Etched Parchment (Provided)"] = "гравійований пергамент (видано)",
    },
    [3088] = {
        ["Encrypted Parchment"] = "зашифрований пергамент",
        ["Encrypted Parchment (Provided)"] = "зашифрований пергамент (видано)",
    },
    [3089] = {
        ["Rune-Inscribed Parchment"] = "рунічний пергамент",
        ["Rune-Inscribed Parchment (Provided)"] = "рунічний пергамент (видано)",
    },
    [3090] = {
        ["Tainted Parchment"] = "заплямований пергамент",
        ["Tainted Parchment (Provided)"] = "заплямований пергамент (видано)",
    },
    [3091] = {
        ["Simple Note"] = "проста записка",
        ["Simple Note (Provided)"] = "проста записка (видано)",
    },
    [3092] = {
        ["Etched Note"] = "гравійована записка",
        ["Etched Note (Provided)"] = "гравійована записка (видано)",
    },
    [3093] = {
        ["Rune-Inscribed Note"] = "рунічна записка",
        ["Rune-Inscribed Note (Provided)"] = "рунічна записка (видано)",
    },
    [3094] = {
        ["Verdant Note"] = "вкрита мохом записка",
        ["Verdant Note (Provided)"] = "вкрита мохом записка (видано)",
    },
    [3095] = {
        ["Simple Scroll"] = "простий сувій",
        ["Simple Scroll (Provided)"] = "простий сувій (видано)",
    },
    [3096] = {
        ["Encrypted Scroll"] = "зашифрований сувій",
        ["Encrypted Scroll (Provided)"] = "зашифрований сувій (видано)",
    },
    [3097] = {
        ["Hallowed Scroll"] = "священний сувій",
        ["Hallowed Scroll (Provided)"] = "священний сувій (видано)",
    },
    [3098] = {
        ["Glyphic Scroll"] = "гліфічний сувій",
        ["Glyphic Scroll (Provided)"] = "гліфічний сувій (видано)",
    },
    [3099] = {
        ["Tainted Scroll"] = "заплямований сувій",
        ["Tainted Scroll (Provided)"] = "заплямований сувій (видано)",
    },
    [3100] = {
        ["Simple Letter"] = "простий лист",
        ["Simple Letter (Provided)"] = "простий лист (видано)",
    },
    [3101] = {
        ["Consecrated Letter"] = "освячений лист",
        ["Consecrated Letter (Provided)"] = "освячений лист (видано)",
    },
    [3102] = {
        ["Encrypted Letter"] = "зашифрований лист",
        ["Encrypted Letter (Provided)"] = "зашифрований лист (видано)",
    },
    [3103] = {
        ["Hallowed Letter"] = "священний лист",
        ["Hallowed Letter (Provided)"] = "священний лист (видано)",
    },
    [3104] = {
        ["Glyphic Letter"] = "гліфічний лист",
        ["Glyphic Letter (Provided)"] = "гліфічний лист (видано)",
    },
    [3105] = {
        ["Tainted Letter"] = "заплямований лист",
        ["Tainted Letter (Provided)"] = "заплямований лист (видано)",
    },
    [3106] = {
        ["Simple Rune"] = "проста руна",
        ["Simple Rune (Provided)"] = "проста руна (видано)",
    },
    [3107] = {
        ["Consecrated Rune"] = "освячена руна",
        ["Consecrated Rune (Provided)"] = "освячена руна (видано)",
    },
    [3108] = {
        ["Etched Rune"] = "гравійована руна",
        ["Etched Rune (Provided)"] = "гравійована руна (видано)",
    },
    [3109] = {
        ["Encrypted Rune"] = "зашифрована руна",
        ["Encrypted Rune (Provided)"] = "зашифрована руна (видано)",
    },
    [3110] = {
        ["Hallowed Rune"] = "священна руна",
        ["Hallowed Rune (Provided)"] = "священна руна (видано)",
    },
    [3112] = {
        ["Simple Memorandum"] = "проста директива",
        ["Simple Memorandum (Provided)"] = "проста директива (видано)",
    },
    [3113] = {
        ["Encrypted Memorandum"] = "зашифрована директива",
        ["Encrypted Memorandum (Provided)"] = "зашифрована директива (видано)",
    },
    [3114] = {
        ["Glyphic Memorandum"] = "гліфічна директива",
        ["Glyphic Memorandum (Provided)"] = "гліфічна директива (видано)",
    },
    [3115] = {
        ["Tainted Memorandum"] = "заплямована директива",
        ["Tainted Memorandum (Provided)"] = "заплямована директива (видано)",
    },
    [3116] = {
        ["Simple Sigil"] = "проста сигіла",
        ["Simple Sigil (Provided)"] = "проста сигіла (видано)",
    },
    [3117] = {
        ["Etched Sigil"] = "гравійована сигіла",
        ["Etched Sigil (Provided)"] = "гравійована сигіла (видано)",
    },
    [3118] = {
        ["Encrypted Sigil"] = "зашифрована сигіла",
        ["Encrypted Sigil (Provided)"] = "зашифрована сигіла (видано)",
    },
    [3119] = {
        ["Hallowed Sigil"] = "священна сигіла",
        ["Hallowed Sigil (Provided)"] = "священна сигіла (видано)",
    },
    [3120] = {
        ["Verdant Sigil"] = "вкрита мохом сигіла",
        ["Verdant Sigil (Provided)"] = "вкрита мохом сигіла (видано)",
    },
    [3121] = {
        ["A Shrunken Head"] = "всохла голова",
        ["A Shrunken Head (Provided)"] = "всохла голова (видано)",
    },
    [3122] = {
        ["Neeru's Herb Pouch"] = "мішечок трав Нііру",
        ["Neeru's Herb Pouch (Provided)"] = "мішечок трав Нііру (видано)",
    },
    [3123] = {
        ["Wildkin Muisek"] = "зменшений совозвір",
        ["Wildkin Muisek (Provided)"] = "зменшений совозвір (видано)",
        ["Wildkin Muisek Vessel"] = "посудина зменшення совозвірів",
        ["Wildkin Muisek Vessel (Provided)"] = "посудина зменшення совозвірів (видано)",
    },
    [3124] = {
        ["Hippogryph Muisek"] = "зменшений гіпогриф",
        ["Hippogryph Muisek (Provided)"] = "зменшений гіпогриф (видано)",
        ["Hippogryph Muisek Vessel"] = "посудина зменшення гіпогрифів",
        ["Hippogryph Muisek Vessel (Provided)"] = "посудина зменшення гіпогрифів (видано)",
    },
    [3125] = {
        ["Faerie Dragon Muisek"] = "зменшений чарівний дракончик",
        ["Faerie Dragon Muisek (Provided)"] = "зменшений чарівний дракончик (видано)",
        ["Faerie Dragon Muisek Vessel"] = "посудина зменшення чарівних дракончиків",
        ["Faerie Dragon Muisek Vessel (Provided)"] = "посудина зменшення чарівних дракончиків (видано)",
    },
    [3126] = {
        ["Treant Muisek"] = "зменшений деревань",
        ["Treant Muisek (Provided)"] = "зменшений деревань (видано)",
        ["Treant Muisek Vessel"] = "посудина зменшення дереванів",
        ["Treant Muisek Vessel (Provided)"] = "посудина зменшення дереванів (видано)",
    },
    [3127] = {
        ["Mountain Giant Muisek"] = "зменшений гірський велетень",
        ["Mountain Giant Muisek (Provided)"] = "зменшений гірський велетень (видано)",
        ["Mountain Giant Muisek Vessel"] = "посудина зменшення гірських велетнів",
        ["Mountain Giant Muisek Vessel (Provided)"] = "посудина зменшення гірських велетнів (видано)",
    },
    [3128] = {
        ["Encrusted Minerals"] = "вкритий кіркою мінерал",
        ["Encrusted Minerals (Provided)"] = "вкритий кіркою мінерал (видано)",
        ["Metallic Fragments"] = "металеві фрагменти",
        ["Metallic Fragments (Provided)"] = "металеві фрагменти (видано)",
        ["Resilient Sinew"] = "еластичне сухожилля",
        ["Resilient Sinew (Provided)"] = "еластичне сухожилля (видано)",
        ["Splintered Log"] = "розколота колода",
        ["Splintered Log (Provided)"] = "розколота колода (видано)",
    },
    [3141] = {
        ["Loramus' Story"] = "Історія Лорамуса",
    },
    [3161] = {
        ["Gahz'ridian Detector"] = "ґаз'ридіанський детектор",
        ["Gahz'ridian Detector (Provided)"] = "ґаз'ридіанський детектор (видано)",
        ["Gahz'ridian Ornament"] = "ґаз'ридіанська прикраса",
        ["Gahz'ridian Ornament (Provided)"] = "ґаз'ридіанська прикраса (видано)",
    },
    [3181] = {
        ["Margol's Gigantic Horn"] = "гігантський ріг Марґол",
        ["Margol's Gigantic Horn (Provided)"] = "гігантський ріг Марґол (видано)",
    },
    [3182] = {
        ["Margol's Gigantic Horn"] = "гігантський ріг Марґол",
        ["Margol's Gigantic Horn (Provided)"] = "гігантський ріг Марґол (видано)",
    },
    [3201] = {
        ["Proof of Deed"] = "доказ правоти",
        ["Proof of Deed (Provided)"] = "доказ правоти (видано)",
    },
    [3281] = {
        ["Stolen Silver"] = "вкрадене срібло",
        ["Stolen Silver (Provided)"] = "вкрадене срібло (видано)",
    },
    [3301] = {
        ["Sample Snapjaw Shell"] = "зразок панцира тріскощелепа",
        ["Sample Snapjaw Shell (Provided)"] = "зразок панцира тріскощелепа (видано)",
    },
    [3321] = {
        ["Watch Trenton Work"] = "Дивіться роботу Трентона",
    },
    [3341] = {
        ["Skull of the Coldbringer"] = "череп Стужевія",
        ["Skull of the Coldbringer (Provided)"] = "череп Стужевія (видано)",
    },
    [3361] = {
        ["Felix's Box"] = "коробка Фелікса",
        ["Felix's Box (Provided)"] = "коробка Фелікса (видано)",
        ["Felix's Bucket of Bolts"] = "відро з болтами Фелікса",
        ["Felix's Bucket of Bolts (Provided)"] = "відро з болтами Фелікса (видано)",
        ["Felix's Chest"] = "скриня Фелікса",
        ["Felix's Chest (Provided)"] = "скриня Фелікса (видано)",
    },
    [3362] = {
        ["Gnarled Thistleshrub"] = "чортополоховий шкарбун",
        ["Gnarled Thistleshrub slain"] = "чортополоховий шкарбун: убито",
        ["Thistleshrub Rootshaper"] = "чортополоховий коренепліт",
        ["Thistleshrub Rootshaper slain"] = "чортополоховий коренепліт: убито",
    },
    [3363] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [3364] = {
        ["Durnan's Scalding Mornbrew"] = "пекуча ранкображка Дарнана",
        ["Durnan's Scalding Mornbrew (Provided)"] = "пекуча ранкображка Дарнана (видано)",
    },
    [3365] = {
        ["Nori's Mug"] = "Норів кухоль",
        ["Nori's Mug (Provided)"] = "Норів кухоль (видано)",
    },
    [3366] = {
        ["Glowing Shard"] = "сяючий уламок",
        ["Glowing Shard (Provided)"] = "сяючий уламок (видано)",
        ["Speak with someone about the Nightmare Shard"] = "Поговоріть з кимось про Уламок Кошмару",
    },
    [3367] = {
        ["Dorius Escort"] = "Ескорт Доріуса",
    },
    [3368] = {
        ["Singed Letter"] = "обпалений лист",
        ["Singed Letter (Provided)"] = "обпалений лист (видано)",
    },
    [3369] = {
        ["Nightmare Shard"] = "уламок кошмару",
        ["Nightmare Shard (Provided)"] = "уламок кошмару (видано)",
    },
    [3370] = {
        ["Nightmare Shard"] = "уламок кошмару",
        ["Nightmare Shard (Provided)"] = "уламок кошмару (видано)",
    },
    [3372] = {
        ["Mysterious Artifact"] = "загадковий артефакт",
        ["Mysterious Artifact (Provided)"] = "загадковий артефакт (видано)",
    },
    [3373] = {
        ["Essence of Eranikus"] = "сутність Ераніка",
        ["Essence of Eranikus (Provided)"] = "сутність Ераніка (видано)",
    },
    [3374] = {
        ["Chained Essence of Eranikus"] = "скута сутність Ераніка",
        ["Chained Essence of Eranikus (Provided)"] = "скута сутність Ераніка (видано)",
        ["Oathstone of Ysera's Dragonflight"] = "клятвокамінь драконів Ізери",
        ["Oathstone of Ysera's Dragonflight (Provided)"] = "клятвокамінь драконів Ізери (видано)",
    },
    [3375] = {
        ["Coal"] = "вугілля",
        ["Coal (Provided)"] = "вугілля (видано)",
        ["Mana Potion"] = "зілля мани",
        ["Mana Potion (Provided)"] = "зілля мани (видано)",
        ["Sweet Nectar"] = "солодкий нектар",
        ["Sweet Nectar (Provided)"] = "солодкий нектар (видано)",
    },
    [3376] = {
        ["Chief Sharptusk Thornmantle's Head"] = "голова вождя Гостроікла Колючкошкура",
        ["Chief Sharptusk Thornmantle's Head (Provided)"] = "голова вождя Гостроікла Колючкошкура (видано)",
    },
    [3377] = {
        ["Zamael Story"] = "Історія Замаеля",
    },
    [3378] = {
        ["Prayer to Elune"] = "молитва Елуні",
        ["Prayer to Elune (Provided)"] = "молитва Елуні (видано)",
    },
    [3379] = {
        ["Shadowsilk Poacher"] = "браконьєр тінешовку",
        ["Shadowsilk Poacher slain"] = "браконьєр тінешовку: убито",
    },
    [3381] = {
        ["Undamaged Hippogryph Feather"] = "неушкоджена пір'їна гіпогрифа",
    },
    [3382] = {
        ["Protect Captain Vanessa Beltis from the naga attack"] = "Захистіть капітана Ванесу Белтіс від нападу нагів",
    },
    [3383] = {
        ["Horizon Scout Cook slain"] = "Кухар-скаут Horizon: убито",
        ["Horizon Scout Engineer slain"] = "Інженер-розвідник Horizon: убито",
        ["Horizon Scout First Mate slain"] = "Перший помічник розвідника Horizon: убито",
        ["Roland Geardabbler slain"] = "Роланд Гірдаблер: убито",
    },
    [3384] = {
        ["Roland's Mana Gem"] = "Самоцвіт Мани Роланда",
    },
    [3385] = {
        ["Clunk"] = "Брязк",
        ["Clunk slain"] = "Брязк: убито",
        ["Trade Master Kovic"] = "майстер-торговець Ковіц",
        ["Trade Master Kovic slain"] = "майстер-торговець Ковіц: убито",
        ["Trader's Satchel"] = "торба торговця",
        ["Trader's Satchel (Provided)"] = "торба торговця (видано)",
    },
    [3441] = {
        ["Velarok Story"] = "Історія Веларока",
    },
    [3442] = {
        ["Golem Oil"] = "мастило голема",
        ["Golem Oil (Provided)"] = "мастило голема (видано)",
        ["Heart of Flame"] = "серце полум'я",
        ["Heart of Flame (Provided)"] = "серце полум'я (видано)",
    },
    [3443] = {
        ["Thorium Plated Dagger"] = "вкритий торієм кинджал",
        ["Thorium Plated Dagger (Provided)"] = "вкритий торієм кинджал (видано)",
    },
    [3444] = {
        ["Stone Circle"] = "круглий камінь",
        ["Stone Circle (Provided)"] = "круглий камінь (видано)",
    },
    [3446] = {
        ["Atal'ai Stone Circle"] = "круглий камінь Атал'ай",
        ["Atal'ai Stone Circle (Provided)"] = "круглий камінь Атал'ай (видано)",
    },
    [3449] = {
        ["Rubbing: Rune of Beth'Amara"] = "замальовка: руна Бет'Амара",
        ["Rubbing: Rune of Beth'Amara (Provided)"] = "замальовка: руна Бет'Амара (видано)",
        ["Rubbing: Rune of Jin'yael"] = "замальовка: руна Джин'яель",
        ["Rubbing: Rune of Jin'yael (Provided)"] = "замальовка: руна Джин'яель (видано)",
        ["Rubbing: Rune of Markri"] = "замальовка: руна Маркрі",
        ["Rubbing: Rune of Markri (Provided)"] = "замальовка: руна Маркрі (видано)",
        ["Rubbing: Rune of Sael'hai"] = "замальовка: руна Сель'гай",
        ["Rubbing: Rune of Sael'hai (Provided)"] = "замальовка: руна Сель'гай (видано)",
    },
    [3452] = {
        ["Symbol of Ragnaros"] = "знак Раґнароса",
        ["Symbol of Ragnaros (Provided)"] = "знак Раґнароса (видано)",
    },
    [3453] = {
        ["Torch Creation"] = "Створення факела",
    },
    [3461] = {
        ["Drawing Kit"] = "набір для малювання",
        ["Drawing Kit (Provided)"] = "набір для малювання (видано)",
    },
    [3463] = {
        ["Eastern Tower Ablaze"] = "Східна вежа у палаючому стані",
        ["Eastern Tower Ablaze (Provided)"] = "Східна вежа у палаючому стані (видано)",
        ["Eastern Tower Ablaze slain"] = "Східна вежа у палаючому стані: убито",
        ["Northern Tower Ablaze"] = "Північна вежа у палаючому стані",
        ["Northern Tower Ablaze (Provided)"] = "Північна вежа у палаючому стані (видано)",
        ["Northern Tower Ablaze slain"] = "Північна вежа у палаючому стані: убито",
        ["Southern Tower Ablaze"] = "Південна вежа в палаючому стані",
        ["Southern Tower Ablaze (Provided)"] = "Південна вежа в палаючому стані (видано)",
        ["Southern Tower Ablaze slain"] = "Південна вежа в палаючому стані: убито",
        ["Western Tower Ablaze"] = "Західна вежа у палаючому стані",
        ["Western Tower Ablaze (Provided)"] = "Західна вежа у палаючому стані (видано)",
        ["Western Tower Ablaze slain"] = "Західна вежа у палаючому стані: убито",
    },
    [3482] = {
        ["Pocked Black Box"] = "Кишенькова чорна скринька",
        ["Pocked Black Box (Provided)"] = "Кишенькова чорна скринька (видано)",
    },
    [3501] = {
        ["Imperfect Draenethyst Fragment"] = "недосконалий фрагмент дренетисту",
        ["Imperfect Draenethyst Fragment (Provided)"] = "недосконалий фрагмент дренетисту (видано)",
    },
    [3502] = {
        ["Imperfect Draenethyst Fragment"] = "недосконалий фрагмент дренетисту",
        ["Imperfect Draenethyst Fragment (Provided)"] = "недосконалий фрагмент дренетисту (видано)",
    },
    [3504] = {
        ["Sealed Letter to Ag'tor"] = "запечатаний лист до Аґ'тора",
        ["Sealed Letter to Ag'tor (Provided)"] = "запечатаний лист до Аґ'тора (видано)",
    },
    [3505] = {
        ["Blood Elf Reclaimer"] = "ельф крові-відновник",
        ["Blood Elf Reclaimer slain"] = "ельф крові-відновник: убито",
        ["Blood Elf Surveyor"] = "ельф крові-землемір",
        ["Blood Elf Surveyor slain"] = "ельф крові-землемір: убито",
    },
    [3506] = {
        ["Head of Magus Rimtori"] = "голова чаклунки Рімторі",
        ["Head of Magus Rimtori (Provided)"] = "голова чаклунки Рімторі (видано)",
    },
    [3507] = {
        ["Head of Magus Rimtori"] = "голова чаклунки Рімторі",
        ["Head of Magus Rimtori (Provided)"] = "голова чаклунки Рімторі (видано)",
    },
    [3510] = {
        ["Hetaera's Beaten Head"] = "побита голова Гетаєри",
        ["Hetaera's Beaten Head (Provided)"] = "побита голова Гетаєри (видано)",
        ["Hetaera's Bloodied Head"] = "закривавлена голова Гетаєри",
        ["Hetaera's Bloodied Head (Provided)"] = "закривавлена голова Гетаєри (видано)",
        ["Hetaera's Bruised Head"] = "розбита голова Гетаєри",
        ["Hetaera's Bruised Head (Provided)"] = "розбита голова Гетаєри (видано)",
    },
    [3511] = {
        ["Hetaera's Blood"] = "кров Гетаєри",
        ["Hetaera's Blood (Provided)"] = "кров Гетаєри (видано)",
    },
    [3513] = {
        ["Runed Scroll"] = "сувій з рунами",
        ["Runed Scroll (Provided)"] = "сувій з рунами (видано)",
    },
    [3514] = {
        ["Rynthariel the Keymaster"] = "ключниця Ринтаріель",
        ["Rynthariel the Keymaster slain"] = "ключниця Ринтаріель: убито",
    },
    [3517] = {
        ["Tablet of Beth'Amara"] = "скрижаль Бет'Амари",
        ["Tablet of Beth'Amara (Provided)"] = "скрижаль Бет'Амари (видано)",
        ["Tablet of Jin'yael"] = "скрижаль Джін'яеля",
        ["Tablet of Jin'yael (Provided)"] = "скрижаль Джін'яеля (видано)",
        ["Tablet of Markri"] = "скрижаль Маркрі",
        ["Tablet of Markri (Provided)"] = "скрижаль Маркрі (видано)",
        ["Tablet of Sael'hai"] = "скрижаль Саель'гай",
        ["Tablet of Sael'hai (Provided)"] = "скрижаль Саель'гай (видано)",
    },
    [3518] = {
        ["Tablet of Beth'Amara"] = "скрижаль Бет'Амари",
        ["Tablet of Beth'Amara (Provided)"] = "скрижаль Бет'Амари (видано)",
    },
    [3520] = {
        ["Screecher Spirits Collected"] = "Зібрані духи-крикуни",
        ["Screecher Spirits Collected (Provided)"] = "Зібрані духи-крикуни (видано)",
        ["Screecher Spirits Collected slain"] = "Зібрані духи-крикуни: убито",
        ["Yeh'kinya's Bramble"] = "жезл Є'кіньї",
        ["Yeh'kinya's Bramble (Provided)"] = "жезл Є'кіньї (видано)",
    },
    [3521] = {
        ["Hyacinth Mushroom"] = "гіацинтовий гриб",
        ["Hyacinth Mushroom (Provided)"] = "гіацинтовий гриб (видано)",
        ["Moonpetal Lily"] = "місяцепелюсткова лілея",
        ["Moonpetal Lily (Provided)"] = "місяцепелюсткова лілея (видано)",
        ["Webwood Ichor"] = "сукровиця павутиннолісих",
        ["Webwood Ichor (Provided)"] = "сукровиця павутиннолісих (видано)",
    },
    [3522] = {
        ["Iverron's Antidote"] = "Іверронова протиотрута",
        ["Iverron's Antidote (Provided)"] = "Іверронова протиотрута (видано)",
    },
    [3523] = {
        ["Belnistrasz's Oathstone"] = "клятвокамінь Белністраза",
        ["Belnistrasz's Oathstone (Provided)"] = "клятвокамінь Белністраза (видано)",
    },
    [3524] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
        ["Sea Creature Bones (Provided)"] = "кістки морської істоти (видано)",
    },
    [3525] = {
        ["Protect Belnistrasz while he performs the ritual to shut down the idol"] = "Захистіть Белністраза, поки він виконує ритуал вимкнення ідола",
    },
    [3526] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3527] = {
        ["First Mosh'aru Tablet"] = "перша скрижаль Мош'ару",
        ["First Mosh'aru Tablet (Provided)"] = "перша скрижаль Мош'ару (видано)",
        ["Second Mosh'aru Tablet"] = "друга скрижаль Мош'ару",
        ["Second Mosh'aru Tablet (Provided)"] = "друга скрижаль Мош'ару (видано)",
    },
    [3528] = {
        ["Filled Egg of Hakkar"] = "наповнене яйце Гаккара",
        ["Filled Egg of Hakkar (Provided)"] = "наповнене яйце Гаккара (видано)",
    },
    [3541] = {
        ["Tablet of Jin'yael"] = "скрижаль Джін'яеля",
        ["Tablet of Jin'yael (Provided)"] = "скрижаль Джін'яеля (видано)",
    },
    [3542] = {
        ["Tablet of Markri"] = "скрижаль Маркрі",
        ["Tablet of Markri (Provided)"] = "скрижаль Маркрі (видано)",
    },
    [3561] = {
        ["Tablet of Sael'hai"] = "скрижаль Саель'гай",
        ["Tablet of Sael'hai (Provided)"] = "скрижаль Саель'гай (видано)",
    },
    [3562] = {
        ["Magatha's Note"] = "записка Маґати",
        ["Magatha's Note (Provided)"] = "записка Маґати (видано)",
    },
    [3563] = {
        ["Jes'rimon's Note"] = "записка Джес'рімона",
        ["Jes'rimon's Note (Provided)"] = "записка Джес'рімона (видано)",
    },
    [3564] = {
        ["Andron's Note"] = "записка Андрона",
        ["Andron's Note (Provided)"] = "записка Андрона (видано)",
    },
    [3565] = {
        ["Xylem's Note"] = "записка Зілема",
        ["Xylem's Note (Provided)"] = "записка Зілема (видано)",
    },
    [3566] = {
        ["Head of Lathoric the Black"] = "голова Латорика Чорного",
        ["Head of Lathoric the Black (Provided)"] = "голова Латорика Чорного (видано)",
        ["Heart of Obsidion"] = "серце Обсидіона",
        ["Heart of Obsidion (Provided)"] = "серце Обсидіона (видано)",
    },
    [3568] = {
        ["Filled Vial Labeled #1"] = "наповнений фіал №1",
        ["Filled Vial Labeled #1 (Provided)"] = "наповнений фіал №1 (видано)",
        ["Filled Vial Labeled #2"] = "наповнений фіал №2",
        ["Filled Vial Labeled #2 (Provided)"] = "наповнений фіал №2 (видано)",
        ["Filled Vial Labeled #3"] = "наповнений фіал №3",
        ["Filled Vial Labeled #3 (Provided)"] = "наповнений фіал №3 (видано)",
        ["Filled Vial Labeled #4"] = "наповнений фіал №4",
        ["Filled Vial Labeled #4 (Provided)"] = "наповнений фіал №4 (видано)",
    },
    [3569] = {
        ["Cuely's Elixir"] = "еліксир К'юлі",
        ["Cuely's Elixir (Provided)"] = "еліксир К'юлі (видано)",
    },
    [3601] = {
        ["Kim'Jael's Compass"] = "компас Кім'джаєля",
        ["Kim'Jael's Compass (Provided)"] = "компас Кім'джаєля (видано)",
        ["Kim'Jael's Scope"] = "приціл Кім'джаєля",
        ["Kim'Jael's Scope (Provided)"] = "приціл Кім'джаєля (видано)",
        ["Kim'Jael's Stuffed Chicken"] = "плюшеве курча Кім'джаєля",
        ["Kim'Jael's Stuffed Chicken (Provided)"] = "плюшеве курча Кім'джаєля (видано)",
        ["Kim'Jael's Wizzlegoober"] = "відцентровий розтягувач Кім'джаєля",
        ["Kim'Jael's Wizzlegoober (Provided)"] = "відцентровий розтягувач Кім'джаєля (видано)",
    },
    [3602] = {
        ["Crystallized Azsharite"] = "кристалізований азшарит",
        ["Crystallized Azsharite (Provided)"] = "кристалізований азшарит (видано)",
    },
    [3621] = {
        ["Shipment to Galvan"] = "вантаж для Гальвана",
        ["Shipment to Galvan (Provided)"] = "вантаж для Гальвана (видано)",
    },
    [3625] = {
        ["Weaponry Creation"] = "Створення зброї",
    },
    [3627] = {
        ["Amulet of Allistarj"] = "амулет Аллістаржа",
        ["Amulet of Allistarj (Provided)"] = "амулет Аллістаржа (видано)",
        ["Amulet of Grol"] = "амулет Ґрола",
        ["Amulet of Grol (Provided)"] = "амулет Ґрола (видано)",
        ["Amulet of Sevine"] = "амулет Севіни",
        ["Amulet of Sevine (Provided)"] = "амулет Севіни (видано)",
    },
    [3628] = {
        ["Severed Horn of the Defiler"] = "відрубаний ріг Губителя",
        ["Severed Horn of the Defiler (Provided)"] = "відрубаний ріг Губителя (видано)",
        ["Ward of the Defiler"] = "оберіг Губителя",
        ["Ward of the Defiler (Provided)"] = "оберіг Губителя (видано)",
    },
    [3629] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3630] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3632] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3633] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3634] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3635] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3636] = {
        ["Amnennar the Coldbringer"] = "Амненнар Стужевій",
        ["Amnennar the Coldbringer slain"] = "Амненнар Стужевій: убито",
    },
    [3637] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [3638] = {
        ["Nixx's Signed Pledge"] = "підписана угода Нікса",
        ["Nixx's Signed Pledge (Provided)"] = "підписана угода Нікса (видано)",
    },
    [3639] = {
        ["Big Iron Bomb"] = "велика залізна бомба",
        ["Big Iron Bomb (Provided)"] = "велика залізна бомба (видано)",
        ["Explosive Sheep"] = "вибухова вівця",
        ["Explosive Sheep (Provided)"] = "вибухова вівця (видано)",
        ["Explosive Sheep slain"] = "вибухова вівця: убито",
        ["Solid Dynamite"] = "твердий динаміт",
        ["Solid Dynamite (Provided)"] = "твердий динаміт (видано)",
    },
    [3640] = {
        ["Overspark's Signed Pledge"] = "підписана угода Надспалаха",
        ["Overspark's Signed Pledge (Provided)"] = "підписана угода Надспалаха (видано)",
    },
    [3641] = {
        ["Accurate Scope"] = "точний приціл",
        ["Accurate Scope (Provided)"] = "точний приціл (видано)",
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Advanced Target Dummy (Provided)"] = "вдосконалений манекен-мішень (видано)",
        ["Advanced Target Dummy slain"] = "вдосконалений манекен-мішень: убито",
        ["Mithril Tube"] = "мітрилова трубка",
        ["Mithril Tube (Provided)"] = "мітрилова трубка (видано)",
    },
    [3642] = {
        ["Oglethorpe's Signed Pledge"] = "підписана угода Оґлторпа",
        ["Oglethorpe's Signed Pledge (Provided)"] = "підписана угода Оґлторпа (видано)",
    },
    [3643] = {
        ["Accurate Scope"] = "точний приціл",
        ["Accurate Scope (Provided)"] = "точний приціл (видано)",
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Advanced Target Dummy (Provided)"] = "вдосконалений манекен-мішень (видано)",
        ["Advanced Target Dummy slain"] = "вдосконалений манекен-мішень: убито",
        ["Mithril Tube"] = "мітрилова трубка",
        ["Mithril Tube (Provided)"] = "мітрилова трубка (видано)",
    },
    [3644] = {
        ["Required money: 2"] = "Необхідні гроші: 2",
    },
    [3645] = {
        ["Required money: 2"] = "Необхідні гроші: 2",
    },
    [3646] = {
        ["Required money: 2"] = "Необхідні гроші: 2",
    },
    [3647] = {
        ["Required money: 2"] = "Необхідні гроші: 2",
    },
    [3661] = {
        ["Wildkin Feather"] = "перо дикого совуха",
        ["Wildkin Feather (Provided)"] = "перо дикого совуха (видано)",
    },
    [3701] = {
        ["Information Recovered"] = "Відновлена інформація",
        ["Information Recovered (Provided)"] = "Відновлена інформація (видано)",
        ["Information Recovered slain"] = "Відновлена інформація: убито",
    },
    [3702] = {
        ["Story of Thaurissan"] = "Історія Тауріссана",
    },
    [3741] = {
        ["Hilary's Necklace"] = "намисто Гіларі",
        ["Hilary's Necklace (Provided)"] = "намисто Гіларі (видано)",
    },
    [3761] = {
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
        ["Un'Goro Soil (Provided)"] = "ґрунт Ун'Ґоро (видано)",
    },
    [3764] = {
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
        ["Un'Goro Soil (Provided)"] = "ґрунт Ун'Ґоро (видано)",
    },
    [3781] = {
        ["Seed Voucher"] = "розписка про видачу насіння",
        ["Seed Voucher (Provided)"] = "розписка про видачу насіння (видано)",
    },
    [3782] = {
        ["Seed Voucher"] = "розписка про видачу насіння",
        ["Seed Voucher (Provided)"] = "розписка про видачу насіння (видано)",
    },
    [3783] = {
        ["Thick Yeti Fur"] = "густе хутро єті",
        ["Thick Yeti Fur (Provided)"] = "густе хутро єті (видано)",
    },
    [3785] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3786] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3791] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3792] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3802] = {
        ["Ironfel"] = "Залізоскверн",
        ["Ironfel (Provided)"] = "Залізоскверн (видано)",
    },
    [3803] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3804] = {
        ["Morrowgrain"] = "світанка",
        ["Morrowgrain (Provided)"] = "світанка (видано)",
    },
    [3822] = {
        ["Sha'ni's Nose-Ring"] = "обручка Ша'ні",
        ["Sha'ni's Nose-Ring (Provided)"] = "обручка Ша'ні (видано)",
    },
    [3823] = {
        ["Firegut Brute"] = "вогнечеревий моцак",
        ["Firegut Brute slain"] = "вогнечеревий моцак: убито",
        ["Firegut Ogre"] = "вогнечеревий огр",
        ["Firegut Ogre Mage"] = "вогнечеревий огр-маг",
        ["Firegut Ogre Mage slain"] = "вогнечеревий огр-маг: убито",
        ["Firegut Ogre slain"] = "вогнечеревий огр: убито",
    },
    [3824] = {
        ["Gor'tesh's Lopped Off Head"] = "відрубана голова Ґор'теша",
        ["Gor'tesh's Lopped Off Head (Provided)"] = "відрубана голова Ґор'теша (видано)",
    },
    [3825] = {
        ["Gor'tesh Head Planted"] = "Голова Гор'теша посаджена",
        ["Gor'tesh Head Planted (Provided)"] = "Голова Гор'теша посаджена (видано)",
        ["Gor'tesh Head Planted slain"] = "Голова Гор'теша посаджена: убито",
    },
    [3841] = {
        ["Unhatched Sprite Darter Egg"] = "невилуплене яйце райдужного хамелеона",
        ["Unhatched Sprite Darter Egg (Provided)"] = "невилуплене яйце райдужного хамелеона (видано)",
    },
    [3842] = {
        ["Elixir of Fortitude"] = "еліксир стійкості",
        ["Elixir of Fortitude (Provided)"] = "еліксир стійкості (видано)",
    },
    [3843] = {
        ["Fragile Sprite Darter Egg"] = "крихке яйце райдужного хамелеона",
        ["Fragile Sprite Darter Egg (Provided)"] = "крихке яйце райдужного хамелеона (видано)",
    },
    [3845] = {
        ["Curled Map Parchment"] = "скручений пергамент з мапою",
        ["Curled Map Parchment (Provided)"] = "скручений пергамент з мапою (видано)",
        ["Large Compass"] = "великий компас",
        ["Large Compass (Provided)"] = "великий компас (видано)",
        ["Lion-headed Key"] = "ключ з головою лева",
        ["Lion-headed Key (Provided)"] = "ключ з головою лева (видано)",
    },
    [3861] = {
        ["Special Chicken Feed"] = "спеціальний курячий корм",
        ["Special Chicken Feed (Provided)"] = "спеціальний курячий корм (видано)",
    },
    [3881] = {
        ["Crate of Foodstuffs"] = "ящик з провізією",
        ["Crate of Foodstuffs (Provided)"] = "ящик з провізією (видано)",
        ["Research Equipment"] = "дослідницьке обладнання",
        ["Research Equipment (Provided)"] = "дослідницьке обладнання (видано)",
    },
    [3882] = {
        ["Dinosaur Bone"] = "кістка динозавра",
        ["Dinosaur Bone (Provided)"] = "кістка динозавра (видано)",
    },
    [3883] = {
        ["Hive Wall Sample"] = "зразок стіни вулика",
        ["Hive Wall Sample (Provided)"] = "зразок стіни вулика (видано)",
    },
    [3884] = {
        ["A Mangled Journal"] = "подертий щоденник",
        ["A Mangled Journal (Provided)"] = "подертий щоденник (видано)",
    },
    [3885] = {
        ["Escort Petra and Dadanga!"] = "Ескорт Петри та Даданги!",
    },
    [3901] = {
        ["Rattlecage Skeleton"] = "брязкокістковий скелет",
        ["Rattlecage Skeleton slain"] = "брязкокістковий скелет: убито",
    },
    [3902] = {
        ["Scavenged Goods"] = "віднайдені припаси",
        ["Scavenged Goods (Provided)"] = "віднайдені припаси (видано)",
    },
    [3904] = {
        ["Milly's Harvest"] = "урожай Міллі",
        ["Milly's Harvest (Provided)"] = "урожай Міллі (видано)",
    },
    [3905] = {
        ["Grape Manifest"] = "повідомлення про постачання винограду",
        ["Grape Manifest (Provided)"] = "повідомлення про постачання винограду (видано)",
    },
    [3906] = {
        ["Overmaster Pyron"] = "повелитель Пірон",
        ["Overmaster Pyron slain"] = "повелитель Пірон: убито",
    },
    [3907] = {
        ["Lord Incendius"] = "лорд Спалахій",
        ["Lord Incendius slain"] = "лорд Спалахій: убито",
        ["Tablet of Kurniya"] = "скрижаль Курнії",
        ["Tablet of Kurniya (Provided)"] = "скрижаль Курнії (видано)",
    },
    [3908] = {
        ["Linken's Training Sword"] = "тренувальний меч Лінкена",
        ["Linken's Training Sword (Provided)"] = "тренувальний меч Лінкена (видано)",
    },
    [3909] = {
        ["Videre Elixir"] = "еліксир Відере",
        ["Videre Elixir (Provided)"] = "еліксир Відере (видано)",
    },
    [3911] = {
        ["Essence of the Elements"] = "сутність стихій",
    },
    [3912] = {
        ["Linken's Tempered Sword"] = "загартований меч Лінкена",
    },
    [3913] = {
        ["Linken's Tempered Sword"] = "загартований меч Лінкена",
        ["Linken's Tempered Sword (Provided)"] = "загартований меч Лінкена (видано)",
    },
    [3914] = {
        ["Linken's Superior Sword"] = "покращений меч Лінкена",
        ["Linken's Superior Sword (Provided)"] = "покращений меч Лінкена (видано)",
    },
    [3921] = {
        ["Broken Samophlange"] = "зламаний самофланж",
        ["Broken Samophlange (Provided)"] = "зламаний самофланж (видано)",
    },
    [3922] = {
        ["Nugget Slug"] = "заготовка для деталі",
        ["Nugget Slug (Provided)"] = "заготовка для деталі (видано)",
    },
    [3923] = {
        ["Broken and Battered Samophlange"] = "зламаний та пошарпаний самофланж",
        ["Broken and Battered Samophlange (Provided)"] = "зламаний та пошарпаний самофланж (видано)",
    },
    [3924] = {
        ["Samophlange Manual"] = "посібник з експлуатації самофланжу",
        ["Samophlange Manual (Provided)"] = "посібник з експлуатації самофланжу (видано)",
    },
    [3961] = {
        ["Silver Totem of Aquementas"] = "срібний тотем Акваментаса",
        ["Silver Totem of Aquementas (Provided)"] = "срібний тотем Акваментаса (видано)",
    },
    [3962] = {
        ["Blazerunner"] = "Жаропломінь",
        ["Blazerunner slain"] = "Жаропломінь: убито",
        ["Golden Flame"] = "золоте полум'я",
        ["Golden Flame (Provided)"] = "золоте полум'я (видано)",
        ["Silver Totem of Aquementas"] = "срібний тотем Акваментаса",
        ["Silver Totem of Aquementas (Provided)"] = "срібний тотем Акваментаса (видано)",
    },
    [3982] = {
        ["Survive the Onslaught"] = "Пережити натиск",
    },
    [4001] = {
        ["Information Gathered from Kharan"] = "Інформація, зібрана з Харана",
    },
    [4003] = {
        ["Emperor Dagran Thaurissan"] = "Імператор Дагран Таурісан",
        ["Emperor Dagran Thaurissan (Provided)"] = "Імператор Дагран Таурісан (видано)",
        ["Emperor Dagran Thaurissan slain"] = "Імператор Дагран Таурісан: убито",
    },
    [4005] = {
        ["Silver Totem of Aquementas"] = "срібний тотем Акваментаса",
        ["Silver Totem of Aquementas (Provided)"] = "срібний тотем Акваментаса (видано)",
    },
    [4021] = {
        ["Piece of Krom'zar's Banner"] = "клаптик стягу Кром'зара",
        ["Piece of Krom'zar's Banner (Provided)"] = "клаптик стягу Кром'зара (видано)",
    },
    [4022] = {
        ["Black Dragonflight Molt"] = "скинута шкіра чорного дракона",
        ["Black Dragonflight Molt (Provided)"] = "скинута шкіра чорного дракона (видано)",
    },
    [4023] = {
        ["Black Dragonflight Molt"] = "скинута шкіра чорного дракона",
        ["Black Dragonflight Molt (Provided)"] = "скинута шкіра чорного дракона (видано)",
    },
    [4024] = {
        ["Encased Fiery Essence"] = "захоплена вогняна сутність",
        ["Encased Fiery Essence (Provided)"] = "захоплена вогняна сутність (видано)",
    },
    [4041] = {
        ["Evoroot"] = "духокорінь",
        ["Evoroot (Provided)"] = "духокорінь (видано)",
    },
    [4061] = {
        ["Fractured Elemental Shard"] = "тріснутий уламок елементаля",
        ["Fractured Elemental Shard (Provided)"] = "тріснутий уламок елементаля (видано)",
    },
    [4062] = {
        ["Elemental Shard Sample"] = "зразок уламка елементаля",
        ["Elemental Shard Sample (Provided)"] = "зразок уламка елементаля (видано)",
    },
    [4063] = {
        ["Head of Argelmach"] = "голова Арґельмаха",
        ["Head of Argelmach (Provided)"] = "голова Арґельмаха (видано)",
        ["Intact Elemental Core"] = "неушкоджене ядро елементаля",
        ["Intact Elemental Core (Provided)"] = "неушкоджене ядро елементаля (видано)",
    },
    [4081] = {
        ["Anvilrage Footman"] = "піхотинець Лютого Ковадла",
        ["Anvilrage Footman slain"] = "піхотинець Лютого Ковадла: убито",
        ["Anvilrage Guardsman"] = "гвардієць Лютого Ковадла",
        ["Anvilrage Guardsman slain"] = "гвардієць Лютого Ковадла: убито",
        ["Anvilrage Warden"] = "вартовий Лютого Ковадла",
        ["Anvilrage Warden slain"] = "вартовий Лютого Ковадла: убито",
    },
    [4082] = {
        ["Anvilrage Medic"] = "медик Лютого Ковадла",
        ["Anvilrage Medic slain"] = "медик Лютого Ковадла: убито",
        ["Anvilrage Officer"] = "офіцер Лютого Ковадла",
        ["Anvilrage Officer slain"] = "офіцер Лютого Ковадла: убито",
        ["Anvilrage Soldier"] = "солдат Лютого Ковадла",
        ["Anvilrage Soldier slain"] = "солдат Лютого Ковадла: убито",
    },
    [4083] = {
        ["Gold Bar"] = "злиток золота",
        ["Gold Bar (Provided)"] = "злиток золота (видано)",
        ["Star Ruby"] = "зоряний рубін",
        ["Star Ruby (Provided)"] = "зоряний рубін (видано)",
        ["Truesilver Bar"] = "злиток ясносрібла",
        ["Truesilver Bar (Provided)"] = "злиток ясносрібла (видано)",
    },
    [4084] = {
        ["Irontree Heart"] = "залізодеревне серце",
        ["Irontree Heart (Provided)"] = "залізодеревне серце (видано)",
        ["Silvery Claws"] = "сріблясті пазурі",
        ["Silvery Claws (Provided)"] = "сріблясті пазурі (видано)",
    },
    [4101] = {
        ["Blood Amber"] = "кривавий бурштин",
        ["Blood Amber (Provided)"] = "кривавий бурштин (видано)",
    },
    [4102] = {
        ["Blood Amber"] = "кривавий бурштин",
        ["Blood Amber (Provided)"] = "кривавий бурштин (видано)",
    },
    [4103] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
        ["Corrupted Soul Shard (Provided)"] = "уламок оскверненої душі (видано)",
    },
    [4104] = {
        ["Tainted Vitriol"] = "уражений купорос",
        ["Tainted Vitriol (Provided)"] = "уражений купорос (видано)",
    },
    [4105] = {
        ["Fel Creep"] = "залишок скверни",
        ["Fel Creep (Provided)"] = "залишок скверни (видано)",
    },
    [4106] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
        ["Patch of Tainted Skin (Provided)"] = "клапоть ураженої шкіри (видано)",
    },
    [4107] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
        ["Lesser Nether Essence (Provided)"] = "мала підсвітня субстанція (видано)",
    },
    [4108] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
        ["Corrupted Soul Shard (Provided)"] = "уламок оскверненої душі (видано)",
    },
    [4109] = {
        ["Tainted Vitriol"] = "уражений купорос",
        ["Tainted Vitriol (Provided)"] = "уражений купорос (видано)",
    },
    [4110] = {
        ["Fel Creep"] = "залишок скверни",
        ["Fel Creep (Provided)"] = "залишок скверни (видано)",
    },
    [4111] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
        ["Patch of Tainted Skin (Provided)"] = "клапоть ураженої шкіри (видано)",
    },
    [4112] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
        ["Lesser Nether Essence (Provided)"] = "мала підсвітня субстанція (видано)",
    },
    [4113] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4114] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4115] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4116] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4117] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4118] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4119] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4120] = {
        ["Angerclaw Grizzly"] = "гризлі-лютопазур",
        ["Angerclaw Grizzly slain"] = "гризлі-лютопазур: убито",
        ["Felpaw Ravager"] = "сквернолапий спустошник",
        ["Felpaw Ravager slain"] = "сквернолапий спустошник: убито",
    },
    [4121] = {
        ["Thorium Shackles"] = "торієві кайдани",
        ["Thorium Shackles (Provided)"] = "торієві кайдани (видано)",
    },
    [4122] = {
        ["Thorium Shackles"] = "торієві кайдани",
    },
    [4123] = {
        ["The Heart of the Mountain"] = "Серце гори",
        ["The Heart of the Mountain (Provided)"] = "Серце гори (видано)",
    },
    [4126] = {
        ["Lost Thunderbrew Recipe"] = "втрачений рецепт Громоварів",
        ["Lost Thunderbrew Recipe (Provided)"] = "втрачений рецепт Громоварів (видано)",
    },
    [4127] = {
        ["Discarded Knife"] = "викинутий ніж",
        ["Discarded Knife (Provided)"] = "викинутий ніж (видано)",
    },
    [4129] = {
        ["Discarded Knife"] = "викинутий ніж",
        ["Discarded Knife (Provided)"] = "викинутий ніж (видано)",
    },
    [4132] = {
        ["General Angerforge"] = "генерал Кузня Гніву",
        ["General Angerforge slain"] = "генерал Кузня Гніву: убито",
    },
    [4134] = {
        ["Lost Thunderbrew Recipe"] = "втрачений рецепт Громоварів",
        ["Lost Thunderbrew Recipe (Provided)"] = "втрачений рецепт Громоварів (видано)",
    },
    [4135] = {
        ["Undelivered Parcel"] = "недоставлений пакунок",
    },
    [4136] = {
        ["Ribbly's Head"] = "голова Рібблі",
        ["Ribbly's Head (Provided)"] = "голова Рібблі (видано)",
    },
    [4141] = {
        ["Bloodpetal"] = "кровоцвіт",
        ["Bloodpetal (Provided)"] = "кровоцвіт (видано)",
    },
    [4142] = {
        ["Bloodpetal"] = "кровоцвіт",
        ["Bloodpetal (Provided)"] = "кровоцвіт (видано)",
    },
    [4143] = {
        ["Atal'ai Haze"] = "туман Атал'ай",
        ["Atal'ai Haze (Provided)"] = "туман Атал'ай (видано)",
    },
    [4144] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
        ["Bloodpetal Sprout (Provided)"] = "паросток кровоцвіту (видано)",
    },
    [4145] = {
        ["Bloodpetal Flayer"] = "кровоцвіт-потрошитель",
        ["Bloodpetal Flayer slain"] = "кровоцвіт-потрошитель: убито",
        ["Bloodpetal Lasher"] = "кровоцвіт-хляскун",
        ["Bloodpetal Lasher slain"] = "кровоцвіт-хляскун: убито",
        ["Bloodpetal Thresher"] = "кровоцвіт-молотник",
        ["Bloodpetal Thresher slain"] = "кровоцвіт-молотник: убито",
        ["Bloodpetal Trapper"] = "кровоцвіт-капканник",
        ["Bloodpetal Trapper slain"] = "кровоцвіт-капканник: убито",
    },
    [4146] = {
        ["Atal'ai Haze"] = "туман Атал'ай",
        ["Atal'ai Haze (Provided)"] = "туман Атал'ай (видано)",
        ["Unloaded Zapper"] = "розряджений знищувач",
        ["Unloaded Zapper (Provided)"] = "розряджений знищувач (видано)",
    },
    [4148] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
        ["Bloodpetal Sprout (Provided)"] = "паросток кровоцвіту (видано)",
    },
    [4161] = {
        ["Small Spider Leg"] = "мала павуча лапка",
        ["Small Spider Leg (Provided)"] = "мала павуча лапка (видано)",
    },
    [4181] = {
        ["Manual of Engineering Disciplines"] = "посібник з інженерних дисциплін",
        ["Manual of Engineering Disciplines (Provided)"] = "посібник з інженерних дисциплін (видано)",
    },
    [4182] = {
        ["Black Broodling"] = "чорне драконеня",
        ["Black Broodling slain"] = "чорне драконеня: убито",
        ["Black Dragonspawn"] = "чорний драконід",
        ["Black Dragonspawn slain"] = "чорний драконід: убито",
        ["Black Drake"] = "чорний дракончик",
        ["Black Drake slain"] = "чорний дракончик: убито",
        ["Black Wyrmkin"] = "чорна драконіда",
        ["Black Wyrmkin slain"] = "чорна драконіда: убито",
    },
    [4183] = {
        ["Helendis Riverhorn's Letter"] = "лист Гелендіса Річкорога",
        ["Helendis Riverhorn's Letter (Provided)"] = "лист Гелендіса Річкорога (видано)",
    },
    [4184] = {
        ["Solomon's Plea to Bolvar"] = "прошення Соломона до Болвара",
        ["Solomon's Plea to Bolvar (Provided)"] = "прошення Соломона до Болвара (видано)",
    },
    [4185] = {
        ["Advice from Lady Prestor"] = "Поради від леді Престор",
    },
    [4186] = {
        ["Bolvar's Decree"] = "указ Болвара",
        ["Bolvar's Decree (Provided)"] = "указ Болвара (видано)",
    },
    [4201] = {
        ["Giant Silver Vein"] = "величезна срібна жила",
        ["Giant Silver Vein (Provided)"] = "величезна срібна жила (видано)",
        ["Gromsblood"] = "ґромокров",
        ["Gromsblood (Provided)"] = "ґромокров (видано)",
        ["Nagmara's Filled Vial"] = "наповнений флакон Наґмари",
        ["Nagmara's Filled Vial (Provided)"] = "наповнений флакон Наґмари (видано)",
    },
    [4221] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4222] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4224] = {
        ["Ragged John's Story"] = "Історія Обірваного Джона",
    },
    [4244] = {
        ["Mithril Casing"] = "мітрилова обшивка",
        ["Mithril Casing (Provided)"] = "мітрилова обшивка (видано)",
    },
    [4245] = {
        ["Protect A-Me 01 until you reach Karna Remtravel"] = "Захищайте A-Me 01, поки не досягнете Карни.",
    },
    [4261] = {
        ["Help Arei get to Safety"] = "Допоможіть Арею дістатися до безпечного місця",
    },
    [4262] = {
        ["Overmaster Pyron"] = "повелитель Пірон",
        ["Overmaster Pyron slain"] = "повелитель Пірон: убито",
    },
    [4263] = {
        ["Lord Incendius"] = "лорд Спалахій",
        ["Lord Incendius slain"] = "лорд Спалахій: убито",
    },
    [4264] = {
        ["A Crumpled Up Note"] = "зім'ята записка",
        ["A Crumpled Up Note (Provided)"] = "зім'ята записка (видано)",
    },
    [4265] = {
        ["Free Raschal."] = "Вільний Раскал.",
    },
    [4267] = {
        ["Raschal's Report"] = "звіт Раскала",
        ["Raschal's Report (Provided)"] = "звіт Раскала (видано)",
    },
    [4281] = {
        ["Undelivered Parcel"] = "недоставлений пакунок",
        ["Undelivered Parcel (Provided)"] = "недоставлений пакунок (видано)",
    },
    [4282] = {
        ["Marshal Windsor's Lost Information"] = "втрачена інформація маршала Віндзора",
        ["Marshal Windsor's Lost Information (Provided)"] = "втрачена інформація маршала Віндзора (видано)",
    },
    [4283] = {
        ["Blackrock Medallion"] = "медальйон Чорнокаменю",
        ["Blackrock Medallion (Provided)"] = "медальйон Чорнокаменю (видано)",
    },
    [4284] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Blue Power Crystal (Provided)"] = "синій кристал сили (видано)",
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Green Power Crystal (Provided)"] = "зелений кристал сили (видано)",
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Red Power Crystal (Provided)"] = "червоний кристал сили (видано)",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
        ["Yellow Power Crystal (Provided)"] = "жовтий кристал сили (видано)",
    },
    [4285] = {
        ["Discover and examine the Northern Crystal Pylon"] = "Відкрийте та огляньте Північний кришталевий пілон",
    },
    [4286] = {
        ["Dark Iron Fanny Pack"] = "поясна сумка Темного Заліза",
        ["Dark Iron Fanny Pack (Provided)"] = "поясна сумка Темного Заліза (видано)",
    },
    [4287] = {
        ["Discover and examine the Eastern Crystal Pylon"] = "Відкрийте та огляньте Східний кришталевий пілон",
    },
    [4288] = {
        ["Discover and examine the Western Crystal Pylon"] = "Відкрийте та огляньте Західний кришталевий пілон",
    },
    [4289] = {
        ["Un'Goro Gorilla Pelt"] = "шкура ун'ґорської горили",
        ["Un'Goro Gorilla Pelt (Provided)"] = "шкура ун'ґорської горили (видано)",
        ["Un'Goro Stomper Pelt"] = "шкура ун'ґорського топотуна",
        ["Un'Goro Stomper Pelt (Provided)"] = "шкура ун'ґорського топотуна (видано)",
        ["Un'Goro Thunderer Pelt"] = "шкура ун'ґорського рокотуна",
        ["Un'Goro Thunderer Pelt (Provided)"] = "шкура ун'ґорського рокотуна (видано)",
    },
    [4290] = {
        ["Piece of Threshadon Carcass"] = "шматок туші молотодона",
        ["Piece of Threshadon Carcass (Provided)"] = "шматок туші молотодона (видано)",
    },
    [4291] = {
        ["Ravasaur Pheromone Gland"] = "феромонна залоза равазавра",
        ["Ravasaur Pheromone Gland (Provided)"] = "феромонна залоза равазавра (видано)",
    },
    [4292] = {
        ["Lar'korwi's Head"] = "голова Лар'корві",
        ["Lar'korwi's Head (Provided)"] = "голова Лар'корві (видано)",
    },
    [4293] = {
        ["Corrupted Felwood Sample"] = "забруднений сквернолісний зразок",
        ["Corrupted Felwood Sample (Provided)"] = "забруднений сквернолісний зразок (видано)",
    },
    [4294] = {
        ["Pure Un'Goro Sample"] = "чистий ун'ґорський зразок",
        ["Pure Un'Goro Sample (Provided)"] = "чистий ун'ґорський зразок (видано)",
    },
    [4295] = {
        ["Dark Iron Ale Mug"] = "кухоль елю Темного Заліза",
        ["Dark Iron Ale Mug (Provided)"] = "кухоль елю Темного Заліза (видано)",
    },
    [4296] = {
        ["Tablet Transcript"] = "текст зі скрижалі",
        ["Tablet Transcript (Provided)"] = "текст зі скрижалі (видано)",
    },
    [4297] = {
        ["Silvermane Stalker Flank"] = "вирізка срібногривого ловця",
        ["Silvermane Stalker Flank (Provided)"] = "вирізка срібногривого ловця (видано)",
    },
    [4299] = {
        ["Place the PX83-Enigmatron"] = "Розмістіть PX83-Енігматрон",
    },
    [4300] = {
        ["White Ravasaur Claw"] = "білий кіготь равазавра",
        ["White Ravasaur Claw (Provided)"] = "білий кіготь равазавра (видано)",
    },
    [4301] = {
        ["U'cha's Pelt"] = "шкура У'чі",
        ["U'cha's Pelt (Provided)"] = "шкура У'чі (видано)",
    },
    [4322] = {
        ["Jail Break!"] = "Втеча з в'язниці!",
    },
    [4323] = {
        ["Spotted Hyena Pelt"] = "шкура плямистої гієни",
    },
    [4342] = {
        ["Kharan's Tale"] = "Оповідь Харана",
    },
    [4343] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4362] = {
        ["Emperor Dagran Thaurissan"] = "Імператор Дагран Таурісан",
        ["Emperor Dagran Thaurissan (Provided)"] = "Імператор Дагран Таурісан (видано)",
        ["Emperor Dagran Thaurissan slain"] = "Імператор Дагран Таурісан: убито",
    },
    [4381] = {
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Green Power Crystal (Provided)"] = "зелений кристал сили (видано)",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
        ["Yellow Power Crystal (Provided)"] = "жовтий кристал сили (видано)",
    },
    [4382] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Blue Power Crystal (Provided)"] = "синій кристал сили (видано)",
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Green Power Crystal (Provided)"] = "зелений кристал сили (видано)",
    },
    [4383] = {
        ["Green Power Crystal"] = "зелений кристал сили",
        ["Green Power Crystal (Provided)"] = "зелений кристал сили (видано)",
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Red Power Crystal (Provided)"] = "червоний кристал сили (видано)",
    },
    [4384] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Blue Power Crystal (Provided)"] = "синій кристал сили (видано)",
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Red Power Crystal (Provided)"] = "червоний кристал сили (видано)",
    },
    [4385] = {
        ["Red Power Crystal"] = "червоний кристал сили",
        ["Red Power Crystal (Provided)"] = "червоний кристал сили (видано)",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
        ["Yellow Power Crystal (Provided)"] = "жовтий кристал сили (видано)",
    },
    [4386] = {
        ["Blue Power Crystal"] = "синій кристал сили",
        ["Blue Power Crystal (Provided)"] = "синій кристал сили (видано)",
        ["Yellow Power Crystal"] = "жовтий кристал сили",
        ["Yellow Power Crystal (Provided)"] = "жовтий кристал сили (видано)",
    },
    [4401] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4402] = {
        ["Cactus Apple"] = "кактусове яблуко",
        ["Cactus Apple (Provided)"] = "кактусове яблуко (видано)",
    },
    [4403] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4421] = {
        ["Jadefire Felsworn"] = "нефритожарий скверноклят",
        ["Jadefire Felsworn slain"] = "нефритожарий скверноклят: убито",
        ["Jadefire Rogue"] = "нефритожарий пройдисвіт",
        ["Jadefire Rogue slain"] = "нефритожарий пройдисвіт: убито",
        ["Jadefire Shadowstalker"] = "нефритожарий тінелов",
        ["Jadefire Shadowstalker slain"] = "нефритожарий тінелов: убито",
        ["Xavathras"] = "Заватрас",
        ["Xavathras slain"] = "Заватрас: убито",
    },
    [4441] = {
        ["Vial of Blessed Water"] = "флакон з благословенною водою",
        ["Vial of Blessed Water (Provided)"] = "флакон з благословенною водою (видано)",
    },
    [4443] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4444] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4445] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4446] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4447] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4448] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4449] = {
        ["Dark Iron Geologist"] = "геолог Темного Заліза",
        ["Dark Iron Geologist slain"] = "геолог Темного Заліза: убито",
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [4450] = {
        ["Goodsteel Ledger"] = "гросбух Файносталя",
        ["Goodsteel Ledger (Provided)"] = "гросбух Файносталя (видано)",
        ["Goodsteel's Balanced Flameberge"] = "збалансований фламберг Файносталя",
        ["Goodsteel's Balanced Flameberge (Provided)"] = "збалансований фламберг Файносталя (видано)",
        ["Overdue Package"] = "затриманий пакунок",
        ["Overdue Package (Provided)"] = "затриманий пакунок (видано)",
        ["Solid Crystal Leg Shaft"] = "міцна кришталева лапа",
        ["Solid Crystal Leg Shaft (Provided)"] = "міцна кришталева лапа (видано)",
    },
    [4451] = {
        ["Grimesilt Outhouse Key"] = "ключ від вбиральні Смердюха",
        ["Grimesilt Outhouse Key (Provided)"] = "ключ від вбиральні Смердюха (видано)",
    },
    [4461] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4462] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4463] = {
        ["Black Blood of the Tormented"] = "чорна кров закатованих",
        ["Black Blood of the Tormented (Provided)"] = "чорна кров закатованих (видано)",
        ["Black Diamond"] = "чорний діамант",
        ["Black Diamond (Provided)"] = "чорний діамант (видано)",
        ["Gizzard Gum"] = "шлункова жуйка",
        ["Gizzard Gum (Provided)"] = "шлункова жуйка (видано)",
        ["Libram of Rumination"] = "манускрипт роздумів",
        ["Libram of Rumination (Provided)"] = "манускрипт роздумів (видано)",
    },
    [4464] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4465] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4466] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4467] = {
        ["Cenarion Plant Salve"] = "кенарійський бальзам зцілення рослин",
        ["Cenarion Plant Salve (Provided)"] = "кенарійський бальзам зцілення рослин (видано)",
    },
    [4481] = {
        ["Black Diamond"] = "чорний діамант",
        ["Black Diamond (Provided)"] = "чорний діамант (видано)",
        ["Libram of Constitution"] = "манускрипт статури",
        ["Libram of Constitution (Provided)"] = "манускрипт статури (видано)",
        ["Lung Juice Cocktail"] = "легеневий коктейль",
        ["Lung Juice Cocktail (Provided)"] = "легеневий коктейль (видано)",
        ["Night Dragon's Breath"] = "подих нічного дракона",
        ["Night Dragon's Breath (Provided)"] = "подих нічного дракона (видано)",
    },
    [4482] = {
        ["Black Diamond"] = "чорний діамант",
        ["Black Diamond (Provided)"] = "чорний діамант (видано)",
        ["Crystal Ward"] = "кристалічний захист",
        ["Crystal Ward (Provided)"] = "кристалічний захист (видано)",
        ["Eye of Kajal"] = "око Каджала",
        ["Eye of Kajal (Provided)"] = "око Каджала (видано)",
        ["Libram of Tenacity"] = "манускрипт наполегливості",
        ["Libram of Tenacity (Provided)"] = "манускрипт наполегливості (видано)",
    },
    [4483] = {
        ["Black Diamond"] = "чорний діамант",
        ["Black Diamond (Provided)"] = "чорний діамант (видано)",
        ["Burning Essence"] = "палаюча сутність",
        ["Burning Essence (Provided)"] = "палаюча сутність (видано)",
        ["Crystal Spire"] = "кристалічне вістря",
        ["Crystal Spire (Provided)"] = "кристалічне вістря (видано)",
        ["Libram of Resilience"] = "манускрипт стійкості",
        ["Libram of Resilience (Provided)"] = "манускрипт стійкості (видано)",
    },
    [4484] = {
        ["Black Diamond"] = "чорний діамант",
        ["Black Diamond (Provided)"] = "чорний діамант (видано)",
        ["Crystal Force"] = "кристалічна сила",
        ["Crystal Force (Provided)"] = "кристалічна сила (видано)",
        ["Libram of Voracity"] = "манускрипт жадібності",
        ["Libram of Voracity (Provided)"] = "манускрипт жадібності (видано)",
        ["Whipper Root Tuber"] = "плід кнутокореня",
        ["Whipper Root Tuber (Provided)"] = "плід кнутокореня (видано)",
    },
    [4491] = {
        ["Escort Ringo to Spraggle Frock at Marshal's Refuge"] = "Супровід Рінго до Спрагл Фрок у притулку Маршала",
    },
    [4492] = {
        ["Spraggle's Canteen"] = "фляга Сулиці",
        ["Spraggle's Canteen (Provided)"] = "фляга Сулиці (видано)",
    },
    [4496] = {
        ["Gorishi Scent Gland"] = "пахуча залоза Ґоріші",
        ["Gorishi Scent Gland (Provided)"] = "пахуча залоза Ґоріші (видано)",
        ["Un'Goro Soil"] = "ґрунт Ун'Ґоро",
        ["Un'Goro Soil (Provided)"] = "ґрунт Ун'Ґоро (видано)",
    },
    [4501] = {
        ["Frenzied Pterrordax"] = "навіжений жаходактиль",
        ["Frenzied Pterrordax slain"] = "навіжений жаходактиль: убито",
        ["Pterrordax"] = "жаходактиль",
        ["Pterrordax slain"] = "жаходактиль: убито",
    },
    [4502] = {
        ["Un'Goro Ash"] = "попіл Ун'Ґоро",
        ["Un'Goro Ash (Provided)"] = "попіл Ун'Ґоро (видано)",
    },
    [4503] = {
        ["Webbed Diemetradon Scale"] = "перетинчаста луска деметродона",
        ["Webbed Diemetradon Scale (Provided)"] = "перетинчаста луска деметродона (видано)",
        ["Webbed Pterrordax Scale"] = "перетинчаста луска жаходактиля",
        ["Webbed Pterrordax Scale (Provided)"] = "перетинчаста луска жаходактиля (видано)",
    },
    [4504] = {
        ["Super Sticky Tar"] = "надлипка смола",
        ["Super Sticky Tar (Provided)"] = "надлипка смола (видано)",
    },
    [4505] = {
        ["Filled Flasket"] = "наповнена колба",
        ["Filled Flasket (Provided)"] = "наповнена колба (видано)",
    },
    [4506] = {
        ["Return the corrupted cat to Winna Hazzard"] = "Поверніть зіпсованого кота Вінні Хаззард",
    },
    [4507] = {
        ["Gorishi Queen Brain"] = "мозок королеви Ґоріші",
        ["Gorishi Queen Brain (Provided)"] = "мозок королеви Ґоріші (видано)",
    },
    [4508] = {
        ["Pestlezugg's Un'Goro Report"] = "звіт Товкачера по ситуації в Ун'Ґоро",
        ["Pestlezugg's Un'Goro Report (Provided)"] = "звіт Товкачера по ситуації в Ун'Ґоро (видано)",
    },
    [4509] = {
        ["Pestlezugg's Un'Goro Report"] = "звіт Товкачера по ситуації в Ун'Ґоро",
        ["Pestlezugg's Un'Goro Report (Provided)"] = "звіт Товкачера по ситуації в Ун'Ґоро (видано)",
    },
    [4510] = {
        ["Bank Voucher"] = "банківська розписка",
        ["Bank Voucher (Provided)"] = "банківська розписка (видано)",
    },
    [4511] = {
        ["Bank Voucher"] = "банківська розписка",
        ["Bank Voucher (Provided)"] = "банківська розписка (видано)",
    },
    [4512] = {
        ["Filled Cursed Ooze Jar"] = "наповнена проклятим слизом банка",
        ["Filled Cursed Ooze Jar (Provided)"] = "наповнена проклятим слизом банка (видано)",
        ["Filled Tainted Ooze Jar"] = "наповнена забрудненим слизом банка",
        ["Filled Tainted Ooze Jar (Provided)"] = "наповнена забрудненим слизом банка (видано)",
    },
    [4513] = {
        ["Filled Pure Sample Jar"] = "наповнена чистим слизом банка",
        ["Filled Pure Sample Jar (Provided)"] = "наповнена чистим слизом банка (видано)",
    },
    [4521] = {
        ["Ragged Owlbeast"] = "обдертий совозвір",
        ["Ragged Owlbeast slain"] = "обдертий совозвір: убито",
        ["Raging Owlbeast"] = "лютий совозвір",
        ["Raging Owlbeast slain"] = "лютий совозвір: убито",
    },
    [4542] = {
        ["Urgent Message"] = "термінове повідомлення",
        ["Urgent Message (Provided)"] = "термінове повідомлення (видано)",
    },
    [4561] = {
        ["Un'Goro Slime Sample"] = "зразок ун'ґорського слизу",
        ["Un'Goro Slime Sample (Provided)"] = "зразок ун'ґорського слизу (видано)",
    },
    [4581] = {
        ["Shindrell's Note"] = "лист від Шиндрел",
        ["Shindrell's Note (Provided)"] = "лист від Шиндрел (видано)",
    },
    [4601] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [4602] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [4603] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [4604] = {
        ["Grime-Encrusted Object"] = "вкритий брудом предмет",
        ["Grime-Encrusted Object (Provided)"] = "вкритий брудом предмет (видано)",
    },
    [4621] = {
        ["3000 reputation with Bloodsail Buccaneers"] = "3000 репутації у Піратів Кривавого Парусу",
        ["Baron Revilgaz"] = "барон Ревілґаз",
        ["Baron Revilgaz slain"] = "барон Ревілґаз: убито",
        ["Fleet Master Seahorn"] = "командувач флоту Морський Ріг",
        ["Fleet Master Seahorn slain"] = "командувач флоту Морський Ріг: убито",
    },
    [4642] = {
        ["Merged Ooze Sample"] = "об'єднаний зразок слизу",
        ["Merged Ooze Sample (Provided)"] = "об'єднаний зразок слизу (видано)",
    },
    [4661] = {
        ["Felwood Slime Sample"] = "зразок сквернолісного слизу",
        ["Felwood Slime Sample (Provided)"] = "зразок сквернолісного слизу (видано)",
    },
    [4681] = {
        ["Sea Turtle Remains"] = "рештки морської черепахи",
        ["Sea Turtle Remains (Provided)"] = "рештки морської черепахи (видано)",
    },
    [4701] = {
        ["Halycon"] = "Галікон",
        ["Halycon slain"] = "Галікон: убито",
    },
    [4721] = {
        ["Berserk Owlbeast"] = "совозвір-берсерк",
        ["Berserk Owlbeast slain"] = "совозвір-берсерк: убито",
    },
    [4722] = {
        ["Sea Turtle Remains"] = "рештки морської черепахи",
        ["Sea Turtle Remains (Provided)"] = "рештки морської черепахи (видано)",
    },
    [4723] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
        ["Sea Creature Bones (Provided)"] = "кістки морської істоти (видано)",
    },
    [4724] = {
        ["Halycon"] = "Галікон",
        ["Halycon slain"] = "Галікон: убито",
    },
    [4725] = {
        ["Strangely Marked Box"] = "коробка з дивним маркуванням",
        ["Strangely Marked Box (Provided)"] = "коробка з дивним маркуванням (видано)",
    },
    [4726] = {
        ["Broodling Essence"] = "сутність малечі",
        ["Broodling Essence (Provided)"] = "сутність малечі (видано)",
        ["Draco-Incarcinatrix 900"] = "драко-в'язник 900",
        ["Draco-Incarcinatrix 900 (Provided)"] = "драко-в'язник 900 (видано)",
    },
    [4727] = {
        ["Sea Turtle Remains"] = "рештки морської черепахи",
        ["Sea Turtle Remains (Provided)"] = "рештки морської черепахи (видано)",
    },
    [4728] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
        ["Sea Creature Bones (Provided)"] = "кістки морської істоти (видано)",
    },
    [4729] = {
        ["Caged Worg Pup"] = "клітка з цуценям ворга",
        ["Caged Worg Pup (Provided)"] = "клітка з цуценям ворга (видано)",
    },
    [4730] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
        ["Sea Creature Bones (Provided)"] = "кістки морської істоти (видано)",
    },
    [4731] = {
        ["Strangely Marked Box"] = "коробка з дивним маркуванням",
        ["Strangely Marked Box (Provided)"] = "коробка з дивним маркуванням (видано)",
    },
    [4732] = {
        ["Sea Turtle Remains"] = "рештки морської черепахи",
        ["Sea Turtle Remains (Provided)"] = "рештки морської черепахи (видано)",
    },
    [4733] = {
        ["Sea Creature Bones"] = "кістки морської істоти",
        ["Sea Creature Bones (Provided)"] = "кістки морської істоти (видано)",
    },
    [4734] = {
        ["Eggscilloscope Prototype"] = "прототип яйцеморозкопа",
        ["Eggscilloscope Prototype (Provided)"] = "прототип яйцеморозкопа (видано)",
    },
    [4735] = {
        ["Collected Dragon Egg"] = "зібране яйце дракона",
        ["Collected Dragon Egg (Provided)"] = "зібране яйце дракона (видано)",
        ["Collectronic Module"] = "яйцезбиральний пристрій",
        ["Collectronic Module (Provided)"] = "яйцезбиральний пристрій (видано)",
    },
    [4740] = {
        ["Murkdeep"] = "Глибоморок",
        ["Murkdeep slain"] = "Глибоморок: убито",
    },
    [4741] = {
        ["Moontouched Owlbeast"] = "осяяний місяцем совозвір",
        ["Moontouched Owlbeast slain"] = "осяяний місяцем совозвір: убито",
    },
    [4742] = {
        ["Gemstone of Bloodaxe"] = "самоцвіт Кривавої Сокири",
        ["Gemstone of Bloodaxe (Provided)"] = "самоцвіт Кривавої Сокири (видано)",
        ["Gemstone of Smolderthorn"] = "самоцвіт Зотлілого Терену",
        ["Gemstone of Smolderthorn (Provided)"] = "самоцвіт Зотлілого Терену (видано)",
        ["Gemstone of Spirestone"] = "самоцвіт Кам'яного Шпиля",
        ["Gemstone of Spirestone (Provided)"] = "самоцвіт Кам'яного Шпиля (видано)",
        ["Unadorned Seal of Ascension"] = "неприкрашена печатка Вознесіння",
        ["Unadorned Seal of Ascension (Provided)"] = "неприкрашена печатка Вознесіння (видано)",
    },
    [4743] = {
        ["Forged Seal of Ascension"] = "викувана печатка Вознесіння",
        ["Forged Seal of Ascension (Provided)"] = "викувана печатка Вознесіння (видано)",
    },
    [4762] = {
        ["Cliffspring River Sample"] = "зразок води зі Скельноджерельної річки",
        ["Cliffspring River Sample (Provided)"] = "зразок води зі Скельноджерельної річки (видано)",
    },
    [4763] = {
        ["Talisman of Corruption"] = "талісман порчі",
        ["Talisman of Corruption (Provided)"] = "талісман порчі (видано)",
    },
    [4764] = {
        ["Doomrigger's Clasp"] = "доленосна застібка",
        ["Doomrigger's Clasp (Provided)"] = "доленосна застібка (видано)",
    },
    [4765] = {
        ["Ridgewell's Crate"] = "ящик Скеледужа",
        ["Ridgewell's Crate (Provided)"] = "ящик Скеледужа (видано)",
    },
    [4767] = {
        ["Highperch Wyvern Egg"] = "яйце виверни з Високого Сідала",
        ["Highperch Wyvern Egg (Provided)"] = "яйце виверни з Високого Сідала (видано)",
    },
    [4768] = {
        ["Darkstone Tablet"] = "скрижаль Темнокаменя",
        ["Darkstone Tablet (Provided)"] = "скрижаль Темнокаменя (видано)",
    },
    [4770] = {
        ["Escort Pao'ka from Highperch"] = "Ескорт Пао'ки з Хайперча",
    },
    [4771] = {
        ["Vectus"] = "Вектус",
        ["Vectus slain"] = "Вектус: убито",
    },
    [4781] = {
        ["Gold Bar"] = "злиток золота",
        ["Gold Bar (Provided)"] = "злиток золота (видано)",
    },
    [4783] = {
        ["Lesser Infernal Stone"] = "камінь молодшого пекельника",
        ["Lesser Infernal Stone (Provided)"] = "камінь молодшого пекельника (видано)",
        ["Vial of Hatefury Blood"] = "флакон крові скаженолютого сатира",
        ["Vial of Hatefury Blood (Provided)"] = "флакон крові скаженолютого сатира (видано)",
    },
    [4784] = {
        ["Fine Gold Thread"] = "тонка золота нитка",
        ["Fine Gold Thread (Provided)"] = "тонка золота нитка (видано)",
        ["Smoldering Coal"] = "жаристе вугілля",
        ["Smoldering Coal (Provided)"] = "жаристе вугілля (видано)",
        ["Soul Shard"] = "уламок душі",
        ["Soul Shard (Provided)"] = "уламок душі (видано)",
    },
    [4786] = {
        ["Wait for Menara Voidrender to complete your item"] = "Зачекайте, поки Менара Розбійниця Порожнечі завершить ваш предмет.",
    },
    [4787] = {
        ["Ancient Egg"] = "древнє яйце",
        ["Ancient Egg (Provided)"] = "древнє яйце (видано)",
    },
    [4788] = {
        ["Fifth Mosh'aru Tablet"] = "п'ята скрижаль Мош'ару",
        ["Fifth Mosh'aru Tablet (Provided)"] = "п'ята скрижаль Мош'ару (видано)",
        ["Sixth Mosh'aru Tablet"] = "шоста скрижаль Мош'ару",
        ["Sixth Mosh'aru Tablet (Provided)"] = "шоста скрижаль Мош'ару (видано)",
    },
    [4801] = {
        ["Frostsaber E'ko"] = "е'ко кригозубів",
        ["Frostsaber E'ko (Provided)"] = "е'ко кригозубів (видано)",
    },
    [4802] = {
        ["Winterfall E'ko"] = "е'ко зимокрайових",
        ["Winterfall E'ko (Provided)"] = "е'ко зимокрайових (видано)",
    },
    [4803] = {
        ["Shardtooth E'ko"] = "е'ко щербозубів",
        ["Shardtooth E'ko (Provided)"] = "е'ко щербозубів (видано)",
    },
    [4804] = {
        ["Chillwind E'ko"] = "е'ко студовіїв",
        ["Chillwind E'ko (Provided)"] = "е'ко студовіїв (видано)",
    },
    [4805] = {
        ["Ice Thistle E'ko"] = "е'ко льодореп'яхових",
        ["Ice Thistle E'ko (Provided)"] = "е'ко льодореп'яхових (видано)",
    },
    [4806] = {
        ["Frostmaul E'ko"] = "е'ко кригобоїв",
        ["Frostmaul E'ko (Provided)"] = "е'ко кригобоїв (видано)",
    },
    [4807] = {
        ["Wildkin E'ko"] = "е'ко диких совухів",
        ["Wildkin E'ko (Provided)"] = "е'ко диких совухів (видано)",
    },
    [4808] = {
        ["Tinkee's Letter"] = "лист Тінкі",
        ["Tinkee's Letter (Provided)"] = "лист Тінкі (видано)",
    },
    [4809] = {
        ["Uncracked Chillwind Horn"] = "неушкоджений ріг студовія",
        ["Uncracked Chillwind Horn (Provided)"] = "неушкоджений ріг студовія (видано)",
    },
    [4810] = {
        ["Felnok's Package"] = "пакунок Фелнока",
        ["Felnok's Package (Provided)"] = "пакунок Фелнока (видано)",
    },
    [4811] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Locate the large, red crystal on Darkshore's eastern mountain range"] = "Знайдіть великий червоний кристал на східному гірському хребті Темного Берега",
    },
    [4812] = {
        ["Moonwell Water Tube"] = "посудина з водою місячного колодязя",
        ["Moonwell Water Tube (Provided)"] = "посудина з водою місячного колодязя (видано)",
    },
    [4821] = {
        ["Alien Egg"] = "чужоземне яйце",
        ["Alien Egg (Provided)"] = "чужоземне яйце (видано)",
    },
    [4822] = {
        ["Tigule and Foror's Strawberry Ice Cream"] = "Полуничне морозиво від Тігуле та Форора",
        ["Tigule and Foror's Strawberry Ice Cream (Provided)"] = "Полуничне морозиво від Тігуле та Форора (видано)",
        ["Tigule and Foror's Strawberry Ice Cream slain"] = "Полуничне морозиво від Тігуле та Форора: убито",
    },
    [4841] = {
        ["Galak Scout"] = "розвідник племені Ґалак",
        ["Galak Scout slain"] = "розвідник племені Ґалак: убито",
        ["Galak Windchaser"] = "вітроловка племені Ґалак",
        ["Galak Windchaser slain"] = "вітроловка племені Ґалак: убито",
        ["Galak Wrangler"] = "чередник племені Ґалак",
        ["Galak Wrangler slain"] = "чередник племені Ґалак: убито",
    },
    [4842] = {
        ["Discover Darkwhisper Gorge"] = "Відкрийте для себе ущелину Темний Шепіт",
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [4862] = {
        ["Spire Spider Egg"] = "яйце шпильного павука",
        ["Spire Spider Egg (Provided)"] = "яйце шпильного павука (видано)",
    },
    [4864] = {
        ["Blue-feathered Amulet"] = "амулет з синього пір'я",
        ["Blue-feathered Amulet (Provided)"] = "амулет з синього пір'я (видано)",
        ["Jaron's Supplies"] = "припаси Жарона",
        ["Jaron's Supplies (Provided)"] = "припаси Жарона (видано)",
    },
    [4866] = {
        ["Milked"] = "Доїли",
    },
    [4867] = {
        ["Warosh's Mojo"] = "талісман Вароша",
        ["Warosh's Mojo (Provided)"] = "талісман Вароша (видано)",
    },
    [4882] = {
        ["Blue-feathered Necklace"] = "намисто з синього пір'я",
        ["Blue-feathered Necklace (Provided)"] = "намисто з синього пір'я (видано)",
    },
    [4883] = {
        ["Blue-feathered Necklace"] = "намисто з синього пір'я",
        ["Blue-feathered Necklace (Provided)"] = "намисто з синього пір'я (видано)",
    },
    [4901] = {
        ["Discover the secret of the Altar of Elune"] = "Розкрийте таємницю Вівтаря Елуни",
    },
    [4903] = {
        ["Highlord Omokk"] = "верховний повелитель Омокк",
        ["Highlord Omokk slain"] = "верховний повелитель Омокк: убито",
        ["Important Blackrock Documents"] = "важливі папери Чорнокаменю",
        ["Important Blackrock Documents (Provided)"] = "важливі папери Чорнокаменю (видано)",
        ["Overlord Wyrmthalak"] = "Повелитель Змій",
        ["Overlord Wyrmthalak (Provided)"] = "Повелитель Змій (видано)",
        ["Overlord Wyrmthalak slain"] = "Повелитель Змій: убито",
        ["War Master Voone"] = "воєначальник Вун",
        ["War Master Voone slain"] = "воєначальник Вун: убито",
    },
    [4904] = {
        ["Escort Lakota Windsong from the Darkcloud Pinnacle."] = "Супровід Лакота Пісні Вітру з Вершини Темної Хмари.",
    },
    [4906] = {
        ["Jadefire Betrayer"] = "нефритожарий зрадник",
        ["Jadefire Betrayer slain"] = "нефритожарий зрадник: убито",
        ["Jadefire Hellcaller"] = "нефритожарий пеклоклик",
        ["Jadefire Hellcaller slain"] = "нефритожарий пеклоклик: убито",
        ["Jadefire Trickster"] = "нефритожарий ошуст",
        ["Jadefire Trickster slain"] = "нефритожарий ошуст: убито",
        ["Xavaric"] = "Заварік",
        ["Xavaric slain"] = "Заварік: убито",
    },
    [4921] = {
        ["Find Mankrik's Wife"] = "Знайти дружину Манкрика",
    },
    [4941] = {
        ["Council with Eitrigg."] = "Рада з Ейтріґґом.",
    },
    [4961] = {
        ["Demon of the Orb"] = "демон сфери",
        ["Demon of the Orb slain"] = "демон сфери: убито",
    },
    [4962] = {
        ["Felhas Ruby"] = "рубін сквернолова",
        ["Felhas Ruby (Provided)"] = "рубін сквернолова (видано)",
        ["Imprisoned Felhound Spirit"] = "ув'язнений дух сквернопса",
        ["Imprisoned Felhound Spirit (Provided)"] = "ув'язнений дух сквернопса (видано)",
    },
    [4963] = {
        ["Imprisoned Infernal Spirit"] = "ув'язнений дух пекельника",
        ["Imprisoned Infernal Spirit (Provided)"] = "ув'язнений дух пекельника (видано)",
        ["Infus Emerald"] = "пекельний смарагд",
        ["Infus Emerald (Provided)"] = "пекельний смарагд (видано)",
    },
    [4964] = {
        ["Wait for Menara Voidrender to complete your item"] = "Зачекайте, поки Менара Розбійниця Порожнечі завершить ваш предмет.",
    },
    [4966] = {
        ["Protect Kanati Greycloud"] = "Захистіть Канаті Грейхлауд",
    },
    [4970] = {
        ["Chillwind Meat"] = "м'ясо студовія",
        ["Chillwind Meat (Provided)"] = "м'ясо студовія (видано)",
        ["Shardtooth Meat"] = "м'ясо щербозуба",
        ["Shardtooth Meat (Provided)"] = "м'ясо щербозуба (видано)",
    },
    [4971] = {
        ["Temporal Displacer"] = "часовий переміщувач",
        ["Temporal Displacer (Provided)"] = "часовий переміщувач (видано)",
        ["Temporal Parasite"] = "часовий паразит",
        ["Temporal Parasite slain"] = "часовий паразит: убито",
    },
    [4972] = {
        ["Andorhal Watch"] = "годинник Андорала",
        ["Andorhal Watch (Provided)"] = "годинник Андорала (видано)",
    },
    [4973] = {
        ["Andorhal Watch"] = "годинник Андорала",
        ["Andorhal Watch (Provided)"] = "годинник Андорала (видано)",
    },
    [4974] = {
        ["Head of Rend Blackhand"] = "голова Ренда Чорнорука",
        ["Head of Rend Blackhand (Provided)"] = "голова Ренда Чорнорука (видано)",
    },
    [4975] = {
        ["Wait for Menara Voidrender to complete your item"] = "Зачекайте, поки Менара Розбійниця Порожнечі завершить ваш предмет.",
    },
    [4976] = {
        ["Cleansed Infernal Orb"] = "очищена сфера пекельника",
        ["Cleansed Infernal Orb (Provided)"] = "очищена сфера пекельника (видано)",
    },
    [4982] = {
        ["Bijou's Belongings"] = "речі Блискітки",
        ["Bijou's Belongings (Provided)"] = "речі Блискітки (видано)",
    },
    [4983] = {
        ["Bijou's Reconnaissance Report"] = "розвіддані Блискітки",
        ["Bijou's Reconnaissance Report (Provided)"] = "розвіддані Блискітки (видано)",
    },
    [4984] = {
        ["Diseased Wolf"] = "хворий вовк",
        ["Diseased Wolf slain"] = "хворий вовк: убито",
    },
    [4985] = {
        ["Diseased Grizzly"] = "хворий гризлі",
        ["Diseased Grizzly slain"] = "хворий гризлі: убито",
    },
    [4986] = {
        ["Glyphed Oaken Branch"] = "покрита письменами дубова гілка",
        ["Glyphed Oaken Branch (Provided)"] = "покрита письменами дубова гілка (видано)",
    },
    [4987] = {
        ["Glyphed Oaken Branch"] = "покрита письменами дубова гілка",
        ["Glyphed Oaken Branch (Provided)"] = "покрита письменами дубова гілка (видано)",
    },
    [5001] = {
        ["Bijou's Belongings"] = "речі Блискітки",
        ["Bijou's Belongings (Provided)"] = "речі Блискітки (видано)",
    },
    [5002] = {
        ["Bijou's Information"] = "інформація Блискітки",
        ["Bijou's Information (Provided)"] = "інформація Блискітки (видано)",
    },
    [5022] = {
        ["Janice's Parcel"] = "пакунок Дженіс",
        ["Janice's Parcel (Provided)"] = "пакунок Дженіс (видано)",
    },
    [5023] = {
        ["Janice's Parcel"] = "пакунок Дженіс",
        ["Janice's Parcel (Provided)"] = "пакунок Дженіс (видано)",
    },
    [5041] = {
        ["Crossroads' Supply Crates"] = "ящики з припасами для Перехрестя",
        ["Crossroads' Supply Crates (Provided)"] = "ящики з припасами для Перехрестя (видано)",
    },
    [5042] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5043] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5044] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5045] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5046] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5047] = {
        ["Glowing Hunk of the Beast's Flesh"] = "сяючий шматок плоті Звіра",
        ["Glowing Hunk of the Beast's Flesh (Provided)"] = "сяючий шматок плоті Звіра (видано)",
    },
    [5048] = {
        ["Janice's Parcel"] = "пакунок Дженіс",
        ["Janice's Parcel (Provided)"] = "пакунок Дженіс (видано)",
    },
    [5049] = {
        ["Janice's Parcel"] = "пакунок Дженіс",
        ["Janice's Parcel (Provided)"] = "пакунок Дженіс (видано)",
    },
    [5050] = {
        ["Good Luck Half-Charm"] = "половина оберега доброї вдачі",
        ["Good Luck Half-Charm (Provided)"] = "половина оберега доброї вдачі (видано)",
    },
    [5051] = {
        ["Good Luck Charm"] = "оберіг доброї вдачі",
        ["Good Luck Charm (Provided)"] = "оберіг доброї вдачі (видано)",
    },
    [5052] = {
        ["Blood Shard"] = "кривавий скалок",
        ["Blood Shard (Provided)"] = "кривавий скалок (видано)",
    },
    [5054] = {
        ["Ursius"] = "Урсій",
        ["Ursius slain"] = "Урсій: убито",
    },
    [5055] = {
        ["Brumeran"] = "Брумеран",
        ["Brumeran slain"] = "Брумеран: убито",
    },
    [5056] = {
        ["Shy-Rotam"] = "Ши-Ротам",
        ["Shy-Rotam slain"] = "Ши-Ротам: убито",
    },
    [5059] = {
        ["Dalson Outhouse Key"] = "ключ від вбиральні Дальсона",
        ["Dalson Outhouse Key (Provided)"] = "ключ від вбиральні Дальсона (видано)",
    },
    [5060] = {
        ["Dalson Cabinet Key"] = "ключ від шафи Дальсона",
        ["Dalson Cabinet Key (Provided)"] = "ключ від шафи Дальсона (видано)",
    },
    [5061] = {
        ["Pendant of the Sea Lion"] = "підвіска Морського Лева",
        ["Pendant of the Sea Lion (Provided)"] = "підвіска Морського Лева (видано)",
    },
    [5062] = {
        ["Incendia Agave"] = "вогниста агава",
        ["Incendia Agave (Provided)"] = "вогниста агава (видано)",
    },
    [5063] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Enchanted Scarlet Thread"] = "зачарована багряна нитка",
        ["Enchanted Scarlet Thread (Provided)"] = "зачарована багряна нитка (видано)",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
        ["Pristine Hide of the Beast (Provided)"] = "бездоганна шкура Звіра (видано)",
    },
    [5064] = {
        ["Secret Note #1"] = "таємна записка №1",
        ["Secret Note #1 (Provided)"] = "таємна записка №1 (видано)",
        ["Secret Note #2"] = "таємна записка №2",
        ["Secret Note #2 (Provided)"] = "таємна записка №2 (видано)",
        ["Secret Note #3"] = "таємна записка №3",
        ["Secret Note #3 (Provided)"] = "таємна записка №3 (видано)",
    },
    [5065] = {
        ["Fourth Mosh'aru Tablet"] = "четверта скрижаль Мош'ару",
        ["Fourth Mosh'aru Tablet (Provided)"] = "четверта скрижаль Мош'ару (видано)",
        ["Third Mosh'aru Tablet"] = "третя скрижаль Мош'ару",
        ["Third Mosh'aru Tablet (Provided)"] = "третя скрижаль Мош'ару (видано)",
    },
    [5067] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
        ["Frostwhisper's Embalming Fluid"] = "бальзамувальна рідина Кригошепта",
        ["Frostwhisper's Embalming Fluid (Provided)"] = "бальзамувальна рідина Кригошепта (видано)",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
        ["Pristine Hide of the Beast (Provided)"] = "бездоганна шкура Звіра (видано)",
    },
    [5068] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
        ["Pristine Hide of the Beast"] = "бездоганна шкура Звіра",
        ["Pristine Hide of the Beast (Provided)"] = "бездоганна шкура Звіра (видано)",
        ["Skin of Shadow"] = "шкіра тіні",
        ["Skin of Shadow (Provided)"] = "шкіра тіні (видано)",
    },
    [5081] = {
        ["Highlord Omokk"] = "верховний повелитель Омокк",
        ["Highlord Omokk slain"] = "верховний повелитель Омокк: убито",
        ["Overlord Wyrmthalak"] = "Повелитель Змій",
        ["Overlord Wyrmthalak (Provided)"] = "Повелитель Змій (видано)",
        ["Overlord Wyrmthalak slain"] = "Повелитель Змій: убито",
        ["War Master Voone"] = "воєначальник Вун",
        ["War Master Voone slain"] = "воєначальник Вун: убито",
    },
    [5082] = {
        ["Winterfall Den Watcher"] = "зимокрайовий наглядач лігва",
        ["Winterfall Den Watcher slain"] = "зимокрайовий наглядач лігва: убито",
        ["Winterfall Pathfinder"] = "зимокрайовий слідопит",
        ["Winterfall Pathfinder slain"] = "зимокрайовий слідопит: убито",
        ["Winterfall Totemic"] = "зимокрайовий тотеміст",
        ["Winterfall Totemic slain"] = "зимокрайовий тотеміст: убито",
    },
    [5083] = {
        ["Empty Firewater Flask"] = "порожня фляжка з-під огневиці",
        ["Empty Firewater Flask (Provided)"] = "порожня фляжка з-під огневиці (видано)",
    },
    [5085] = {
        ["Flask of Mystery Goo"] = "фляжка таємничого слизу",
        ["Flask of Mystery Goo (Provided)"] = "фляжка таємничого слизу (видано)",
    },
    [5086] = {
        ["Toxic Horror Droplet"] = "крапля токсичного страховища",
        ["Toxic Horror Droplet (Provided)"] = "крапля токсичного страховища (видано)",
    },
    [5087] = {
        ["Winterfall Crate"] = "ящик Зимокрайових",
        ["Winterfall Crate (Provided)"] = "ящик Зимокрайових (видано)",
    },
    [5088] = {
        ["Arikara Serpent Skin"] = "зміїна шкіра Арікари",
        ["Arikara Serpent Skin (Provided)"] = "зміїна шкіра Арікари (видано)",
        ["Incendia Powder"] = "вогнистий порошок",
        ["Incendia Powder (Provided)"] = "вогнистий порошок (видано)",
    },
    [5089] = {
        ["General Drakkisath's Command"] = "наказ генерала Драккісата",
        ["General Drakkisath's Command (Provided)"] = "наказ генерала Драккісата (видано)",
    },
    [5092] = {
        ["Skeletal Flayer"] = "скелетний потрошитель",
        ["Skeletal Flayer slain"] = "скелетний потрошитель: убито",
        ["Slavering Ghoul"] = "слинявий гуль",
        ["Slavering Ghoul slain"] = "слинявий гуль: убито",
    },
    [5096] = {
        ["Destroy the command tent and plant the Scourge banner in the camp"] = "Знищити командний намет і встановити прапор Бичі в таборі",
        ["Flame in a Bottle"] = "пляшка з полум'ям",
    },
    [5097] = {
        ["Tower Four marked"] = "Вежа чотири позначена",
        ["Tower Four marked (Provided)"] = "Вежа чотири позначена (видано)",
        ["Tower Four marked slain"] = "Вежа чотири позначена: убито",
        ["Tower One marked"] = "Вежа Один позначена",
        ["Tower One marked (Provided)"] = "Вежа Один позначена (видано)",
        ["Tower One marked slain"] = "Вежа Один позначена: убито",
        ["Tower Three marked"] = "Вежа Три позначена",
        ["Tower Three marked (Provided)"] = "Вежа Три позначена (видано)",
        ["Tower Three marked slain"] = "Вежа Три позначена: убито",
        ["Tower Two marked"] = "Вежа два позначена",
        ["Tower Two marked (Provided)"] = "Вежа два позначена (видано)",
        ["Tower Two marked slain"] = "Вежа два позначена: убито",
    },
    [5098] = {
        ["Tower Four marked"] = "Вежа чотири позначена",
        ["Tower Four marked (Provided)"] = "Вежа чотири позначена (видано)",
        ["Tower Four marked slain"] = "Вежа чотири позначена: убито",
        ["Tower One marked"] = "Вежа Один позначена",
        ["Tower One marked (Provided)"] = "Вежа Один позначена (видано)",
        ["Tower One marked slain"] = "Вежа Один позначена: убито",
        ["Tower Three marked"] = "Вежа Три позначена",
        ["Tower Three marked (Provided)"] = "Вежа Три позначена (видано)",
        ["Tower Three marked slain"] = "Вежа Три позначена: убито",
        ["Tower Two marked"] = "Вежа два позначена",
        ["Tower Two marked (Provided)"] = "Вежа два позначена (видано)",
        ["Tower Two marked slain"] = "Вежа два позначена: убито",
    },
    [5101] = {
        ["Sheep slain"] = "вівця: убито",
    },
    [5102] = {
        ["General Drakkisath"] = "Генерал Драккісат",
        ["General Drakkisath (Provided)"] = "Генерал Драккісат (видано)",
        ["General Drakkisath slain"] = "Генерал Драккісат: убито",
    },
    [5121] = {
        ["High Chief Winterfall"] = "верховний вождь Зимокрай",
        ["High Chief Winterfall slain"] = "верховний вождь Зимокрай: убито",
    },
    [5122] = {
        ["Medallion of Faith"] = "медальйон віри",
        ["Medallion of Faith (Provided)"] = "медальйон віри (видано)",
    },
    [5123] = {
        ["Crudely-written Log"] = "грубо написаний журнал",
        ["Crudely-written Log (Provided)"] = "грубо написаний журнал (видано)",
    },
    [5124] = {
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Enchanted Thorium Bar (Provided)"] = "зачарований злиток торію (видано)",
        ["Essence of Fire"] = "сутність вогню",
        ["Essence of Fire (Provided)"] = "сутність вогню (видано)",
        ["Star Ruby"] = "зоряний рубін",
        ["Star Ruby (Provided)"] = "зоряний рубін (видано)",
        ["Unfired Plate Gauntlets"] = "неопалені латні рукавиці",
        ["Unfired Plate Gauntlets (Provided)"] = "неопалені латні рукавиці (видано)",
    },
    [5126] = {
        ["Listen to Lorax's Tale"] = "Послухайте казку Лоракса",
    },
    [5127] = {
        ["Soul Stained Pike"] = "наповнена душею піка",
        ["Soul Stained Pike (Provided)"] = "наповнена душею піка (видано)",
        ["Unforged Rune Covered Breastplate"] = "прототип рунічного нагрудника",
        ["Unforged Rune Covered Breastplate (Provided)"] = "прототип рунічного нагрудника (видано)",
    },
    [5128] = {
        ["Crudely-written Log"] = "грубо написаний журнал",
        ["Crudely-written Log (Provided)"] = "грубо написаний журнал (видано)",
    },
    [5141] = {
        ["Tough Scorpid Breastplate"] = "міцна кіраса з луски скорпіда",
        ["Tough Scorpid Breastplate (Provided)"] = "міцна кіраса з луски скорпіда (видано)",
        ["Tough Scorpid Gloves"] = "міцні рукавиці з луски скорпіда",
        ["Tough Scorpid Gloves (Provided)"] = "міцні рукавиці з луски скорпіда (видано)",
        ["Worn Dragonscale"] = "зношена драконяча луска",
        ["Worn Dragonscale (Provided)"] = "зношена драконяча луска (видано)",
    },
    [5143] = {
        ["Wild Leather Helmet"] = "шолом з дикої шкіри",
        ["Wild Leather Helmet (Provided)"] = "шолом з дикої шкіри (видано)",
        ["Wild Leather Vest"] = "жилет з дикої шкіри",
        ["Wild Leather Vest (Provided)"] = "жилет з дикої шкіри (видано)",
    },
    [5144] = {
        ["Breath of Wind"] = "подих вітру",
        ["Breath of Wind (Provided)"] = "подих вітру (видано)",
        ["Core of Earth"] = "ядро землі",
        ["Core of Earth (Provided)"] = "ядро землі (видано)",
        ["Globe of Water"] = "куля води",
        ["Globe of Water (Provided)"] = "куля води (видано)",
        ["Heart of Fire"] = "серце вогню",
        ["Heart of Fire (Provided)"] = "серце вогню (видано)",
    },
    [5145] = {
        ["Tough Scorpid Breastplate"] = "міцна кіраса з луски скорпіда",
        ["Tough Scorpid Breastplate (Provided)"] = "міцна кіраса з луски скорпіда (видано)",
        ["Tough Scorpid Gloves"] = "міцні рукавиці з луски скорпіда",
        ["Tough Scorpid Gloves (Provided)"] = "міцні рукавиці з луски скорпіда (видано)",
        ["Worn Dragonscale"] = "зношена драконяча луска",
        ["Worn Dragonscale (Provided)"] = "зношена драконяча луска (видано)",
    },
    [5146] = {
        ["Breath of Wind"] = "подих вітру",
        ["Breath of Wind (Provided)"] = "подих вітру (видано)",
        ["Core of Earth"] = "ядро землі",
        ["Core of Earth (Provided)"] = "ядро землі (видано)",
        ["Globe of Water"] = "куля води",
        ["Globe of Water (Provided)"] = "куля води (видано)",
        ["Heart of Fire"] = "серце вогню",
        ["Heart of Fire (Provided)"] = "серце вогню (видано)",
    },
    [5147] = {
        ["Arnak's Hoof"] = "копито Арнака",
        ["Arnak's Hoof (Provided)"] = "копито Арнака (видано)",
    },
    [5148] = {
        ["Wild Leather Helmet"] = "шолом з дикої шкіри",
        ["Wild Leather Helmet (Provided)"] = "шолом з дикої шкіри (видано)",
        ["Wild Leather Vest"] = "жилет з дикої шкіри",
        ["Wild Leather Vest (Provided)"] = "жилет з дикої шкіри (видано)",
    },
    [5149] = {
        ["Pamela's Doll"] = "лялька Памели",
        ["Pamela's Doll (Provided)"] = "лялька Памели (видано)",
    },
    [5150] = {
        ["Bloodpetal Sprout"] = "паросток кровоцвіту",
        ["Bloodpetal Sprout (Provided)"] = "паросток кровоцвіту (видано)",
    },
    [5151] = {
        ["Hypercapacitor Gizmo"] = "гіперконденсатор",
        ["Hypercapacitor Gizmo (Provided)"] = "гіперконденсатор (видано)",
        ["Panther Cage Key"] = "ключ від клітки пантери",
        ["Panther Cage Key (Provided)"] = "ключ від клітки пантери (видано)",
    },
    [5153] = {
        ["Joseph's Wedding Ring"] = "обручка Джозефа",
        ["Joseph's Wedding Ring (Provided)"] = "обручка Джозефа (видано)",
    },
    [5154] = {
        ["Annals of Darrowshire"] = "літопис Дарроушира",
        ["Annals of Darrowshire (Provided)"] = "літопис Дарроушира (видано)",
    },
    [5155] = {
        ["Jaedenar Adept"] = "джеденарський адепт",
        ["Jaedenar Adept slain"] = "джеденарський адепт: убито",
        ["Jaedenar Cultist"] = "джеденарський культист",
        ["Jaedenar Cultist slain"] = "джеденарський культист: убито",
        ["Jaedenar Guardian"] = "джеденарський вартовий",
        ["Jaedenar Guardian slain"] = "джеденарський вартовий: убито",
        ["Jaedenar Hound"] = "джеденарська гонча",
        ["Jaedenar Hound slain"] = "джеденарська гонча: убито",
    },
    [5156] = {
        ["Entropic Beast"] = "ентропічний звір",
        ["Entropic Beast slain"] = "ентропічний звір: убито",
        ["Entropic Horror"] = "ентропічний жах",
        ["Entropic Horror slain"] = "ентропічний жах: убито",
    },
    [5157] = {
        ["Corrupt Moonwell Water"] = "заражена вода місячного колодязя",
        ["Corrupt Moonwell Water (Provided)"] = "заражена вода місячного колодязя (видано)",
    },
    [5158] = {
        ["Corrupt Moonwell Water"] = "заражена вода місячного колодязя",
        ["Corrupt Moonwell Water (Provided)"] = "заражена вода місячного колодязя (видано)",
    },
    [5159] = {
        ["Purified Moonwell Water"] = "очищена вода місячного колодязя",
        ["Purified Moonwell Water (Provided)"] = "очищена вода місячного колодязя (видано)",
    },
    [5160] = {
        ["Awbee's Scale"] = "луска Авбі",
        ["Awbee's Scale (Provided)"] = "луска Авбі (видано)",
    },
    [5163] = {
        ["Scare Legacki"] = "Скар Легацький",
        ["Scare Legacki (Provided)"] = "Скар Легацький (видано)",
        ["Scare Legacki slain"] = "Скар Легацький: убито",
        ["Scare Quixxil"] = "Налякати Квіксіла",
        ["Scare Quixxil (Provided)"] = "Налякати Квіксіла (видано)",
        ["Scare Quixxil slain"] = "Налякати Квіксіла: убито",
        ["Scare Sprinkle"] = "Налякати посипання",
        ["Scare Sprinkle (Provided)"] = "Налякати посипання (видано)",
        ["Scare Sprinkle slain"] = "Налякати посипання: убито",
        ["Umi's Mechanical Yeti"] = "механічний єті Умі",
        ["Umi's Mechanical Yeti (Provided)"] = "механічний єті Умі (видано)",
    },
    [5165] = {
        ["Extinguish the Brazier of Hatred"] = "Загасіть жаровню ненависті",
        ["Extinguish the Brazier of Hatred (Provided)"] = "Загасіть жаровню ненависті (видано)",
        ["Extinguish the Brazier of Hatred slain"] = "Загасіть жаровню ненависті: убито",
        ["Extinguish the Brazier of Malice"] = "Загасіть жаровню злоби",
        ["Extinguish the Brazier of Malice (Provided)"] = "Загасіть жаровню злоби (видано)",
        ["Extinguish the Brazier of Malice slain"] = "Загасіть жаровню злоби: убито",
        ["Extinguish the Brazier of Pain"] = "Загасіть жаровню болю",
        ["Extinguish the Brazier of Pain (Provided)"] = "Загасіть жаровню болю (видано)",
        ["Extinguish the Brazier of Pain slain"] = "Загасіть жаровню болю: убито",
        ["Extinguish the Brazier of Suffering"] = "Загасіть жаровню страждань",
        ["Extinguish the Brazier of Suffering (Provided)"] = "Загасіть жаровню страждань (видано)",
        ["Extinguish the Brazier of Suffering slain"] = "Загасіть жаровню страждань: убито",
    },
    [5166] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Blood of Heroes (Provided)"] = "кров героїв (видано)",
        ["Brilliant Chromatic Scale"] = "блискуча хроматична луска",
        ["Brilliant Chromatic Scale (Provided)"] = "блискуча хроматична луска (видано)",
        ["Chromatic Carapace"] = "хроматичний панцир",
        ["Chromatic Carapace (Provided)"] = "хроматичний панцир (видано)",
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
    },
    [5167] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Blood of Heroes (Provided)"] = "кров героїв (видано)",
        ["Brilliant Chromatic Scale"] = "блискуча хроматична луска",
        ["Brilliant Chromatic Scale (Provided)"] = "блискуча хроматична луска (видано)",
        ["Chromatic Carapace"] = "хроматичний панцир",
        ["Chromatic Carapace (Provided)"] = "хроматичний панцир (видано)",
        ["Skin of Shadow"] = "шкіра тіні",
        ["Skin of Shadow (Provided)"] = "шкіра тіні (видано)",
    },
    [5168] = {
        ["Davil's Libram"] = "манускрипт Дейвіла",
        ["Davil's Libram (Provided)"] = "манускрипт Дейвіла (видано)",
        ["Redpath's Shield"] = "щит Редпата",
        ["Redpath's Shield (Provided)"] = "щит Редпата (видано)",
    },
    [5181] = {
        ["Shattered Sword of Marduk"] = "розбитий меч Мардука",
        ["Shattered Sword of Marduk (Provided)"] = "розбитий меч Мардука (видано)",
        ["Skull of Horgus"] = "череп Горґуса",
        ["Skull of Horgus (Provided)"] = "череп Горґуса (видано)",
    },
    [5201] = {
        ["Winterfall Shaman"] = "зимокрайовий шаман",
        ["Winterfall Shaman slain"] = "зимокрайовий шаман: убито",
        ["Winterfall Ursa"] = "зимокрайовий урса",
        ["Winterfall Ursa slain"] = "зимокрайовий урса: убито",
    },
    [5202] = {
        ["Blood Red Key"] = "криваво-червоний ключ",
        ["Blood Red Key (Provided)"] = "криваво-червоний ключ (видано)",
    },
    [5203] = {
        ["Protect Arko'narin out of Shadow Hold"] = "Захистіть Арко'нарін від Тіньової фортеці",
    },
    [5204] = {
        ["Rakaiah"] = "Ракайя",
        ["Rakaiah slain"] = "Ракайя: убито",
    },
    [5206] = {
        ["Mystic Crystal"] = "загадковий кристал",
        ["Mystic Crystal (Provided)"] = "загадковий кристал (видано)",
        ["Resonating Skull"] = "резонівний череп",
        ["Resonating Skull (Provided)"] = "резонівний череп (видано)",
    },
    [5210] = {
        ["Extended Annals of Darrowshire"] = "доповнений літопис Дарроушира",
        ["Extended Annals of Darrowshire (Provided)"] = "доповнений літопис Дарроушира (видано)",
    },
    [5211] = {
        ["Darrowshire Spirits Freed"] = "Звільнені духи Дарроуширу",
        ["Darrowshire Spirits Freed (Provided)"] = "Звільнені духи Дарроуширу (видано)",
        ["Darrowshire Spirits Freed slain"] = "Звільнені духи Дарроуширу: убито",
    },
    [5212] = {
        ["Plagued Flesh Sample"] = "зразок зачумленої плоті",
        ["Plagued Flesh Sample (Provided)"] = "зразок зачумленої плоті (видано)",
    },
    [5213] = {
        ["Scourge Data"] = "дані про Скару",
        ["Scourge Data (Provided)"] = "дані про Скару (видано)",
    },
    [5214] = {
        ["Siabi's Premium Tobacco"] = "Преміальний тютюн Siabi",
        ["Siabi's Premium Tobacco (Provided)"] = "Преміальний тютюн Siabi (видано)",
        ["Siabi's Premium Tobacco slain"] = "Преміальний тютюн Siabi: убито",
    },
    [5216] = {
        ["Empty Felstone Field Bottle"] = "порожня пляшка для зразків зі Сквернокам'яного поля",
        ["Empty Felstone Field Bottle (Provided)"] = "порожня пляшка для зразків зі Сквернокам'яного поля (видано)",
        ["Felstone Field Cauldron Key"] = "ключ від котла Сквернокам'яного поля",
        ["Felstone Field Cauldron Key (Provided)"] = "ключ від котла Сквернокам'яного поля (видано)",
    },
    [5217] = {
        ["Filled Felstone Field Bottle"] = "пляшка зразків зі Сквернокам'яного поля",
        ["Filled Felstone Field Bottle (Provided)"] = "пляшка зразків зі Сквернокам'яного поля (видано)",
    },
    [5218] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Arcane Quickener (Provided)"] = "арканічний прискорювач (видано)",
        ["Osseous Agitator"] = "кістяний каталізатор",
        ["Osseous Agitator (Provided)"] = "кістяний каталізатор (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [5219] = {
        ["Dalson's Tears Cauldron Key"] = "ключ від котла Сліз Дальсона",
        ["Dalson's Tears Cauldron Key (Provided)"] = "ключ від котла Сліз Дальсона (видано)",
        ["Empty Dalson's Tears Bottle"] = "порожня пляшка для зразків зі Сліз Дальсона",
        ["Empty Dalson's Tears Bottle (Provided)"] = "порожня пляшка для зразків зі Сліз Дальсона (видано)",
    },
    [5220] = {
        ["Filled Dalson's Tears Bottle"] = "пляшка зразків зі Сліз Дальсона",
        ["Filled Dalson's Tears Bottle (Provided)"] = "пляшка зразків зі Сліз Дальсона (видано)",
    },
    [5221] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Arcane Quickener (Provided)"] = "арканічний прискорювач (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
        ["Somatic Intensifier"] = "соматичний підсилювач",
        ["Somatic Intensifier (Provided)"] = "соматичний підсилювач (видано)",
    },
    [5222] = {
        ["Empty Writhing Haunt Bottle"] = "порожня пляшка для зразків з Крученого Привида",
        ["Empty Writhing Haunt Bottle (Provided)"] = "порожня пляшка для зразків з Крученого Привида (видано)",
        ["Writhing Haunt Cauldron Key"] = "ключ від котла Крученого Привида",
        ["Writhing Haunt Cauldron Key (Provided)"] = "ключ від котла Крученого Привида (видано)",
    },
    [5223] = {
        ["Filled Writhing Haunt Bottle"] = "пляшка зразків з Крученого Привида",
        ["Filled Writhing Haunt Bottle (Provided)"] = "пляшка зразків з Крученого Привида (видано)",
    },
    [5224] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Arcane Quickener (Provided)"] = "арканічний прискорювач (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
        ["Somatic Intensifier"] = "соматичний підсилювач",
        ["Somatic Intensifier (Provided)"] = "соматичний підсилювач (видано)",
    },
    [5225] = {
        ["Empty Gahrron's Withering Bottle"] = "порожня пляшка для зразків з Посухи Ґаррона",
        ["Empty Gahrron's Withering Bottle (Provided)"] = "порожня пляшка для зразків з Посухи Ґаррона (видано)",
        ["Gahrron's Withering Cauldron Key"] = "ключ від котла Посухи Ґаррона",
        ["Gahrron's Withering Cauldron Key (Provided)"] = "ключ від котла Посухи Ґаррона (видано)",
    },
    [5226] = {
        ["Filled Gahrron's Withering Bottle"] = "пляшка зразків з Посухи Ґаррона",
        ["Filled Gahrron's Withering Bottle (Provided)"] = "пляшка зразків з Посухи Ґаррона (видано)",
    },
    [5227] = {
        ["Arcane Quickener"] = "арканічний прискорювач",
        ["Arcane Quickener (Provided)"] = "арканічний прискорювач (видано)",
        ["Ectoplasmic Resonator"] = "ектоплазматичний резонатор",
        ["Ectoplasmic Resonator (Provided)"] = "ектоплазматичний резонатор (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [5229] = {
        ["Empty Felstone Field Bottle"] = "порожня пляшка для зразків зі Сквернокам'яного поля",
        ["Empty Felstone Field Bottle (Provided)"] = "порожня пляшка для зразків зі Сквернокам'яного поля (видано)",
        ["Felstone Field Cauldron Key"] = "ключ від котла Сквернокам'яного поля",
        ["Felstone Field Cauldron Key (Provided)"] = "ключ від котла Сквернокам'яного поля (видано)",
    },
    [5230] = {
        ["Filled Felstone Field Bottle"] = "пляшка зразків зі Сквернокам'яного поля",
        ["Filled Felstone Field Bottle (Provided)"] = "пляшка зразків зі Сквернокам'яного поля (видано)",
    },
    [5231] = {
        ["Dalson's Tears Cauldron Key"] = "ключ від котла Сліз Дальсона",
        ["Dalson's Tears Cauldron Key (Provided)"] = "ключ від котла Сліз Дальсона (видано)",
        ["Empty Dalson's Tears Bottle"] = "порожня пляшка для зразків зі Сліз Дальсона",
        ["Empty Dalson's Tears Bottle (Provided)"] = "порожня пляшка для зразків зі Сліз Дальсона (видано)",
    },
    [5232] = {
        ["Filled Dalson's Tears Bottle"] = "пляшка зразків зі Сліз Дальсона",
        ["Filled Dalson's Tears Bottle (Provided)"] = "пляшка зразків зі Сліз Дальсона (видано)",
    },
    [5233] = {
        ["Empty Writhing Haunt Bottle"] = "порожня пляшка для зразків з Крученого Привида",
        ["Empty Writhing Haunt Bottle (Provided)"] = "порожня пляшка для зразків з Крученого Привида (видано)",
        ["Writhing Haunt Cauldron Key"] = "ключ від котла Крученого Привида",
        ["Writhing Haunt Cauldron Key (Provided)"] = "ключ від котла Крученого Привида (видано)",
    },
    [5234] = {
        ["Filled Writhing Haunt Bottle"] = "пляшка зразків з Крученого Привида",
        ["Filled Writhing Haunt Bottle (Provided)"] = "пляшка зразків з Крученого Привида (видано)",
    },
    [5235] = {
        ["Empty Gahrron's Withering Bottle"] = "порожня пляшка для зразків з Посухи Ґаррона",
        ["Empty Gahrron's Withering Bottle (Provided)"] = "порожня пляшка для зразків з Посухи Ґаррона (видано)",
        ["Gahrron's Withering Cauldron Key"] = "ключ від котла Посухи Ґаррона",
        ["Gahrron's Withering Cauldron Key (Provided)"] = "ключ від котла Посухи Ґаррона (видано)",
    },
    [5236] = {
        ["Filled Gahrron's Withering Bottle"] = "пляшка зразків з Посухи Ґаррона",
        ["Filled Gahrron's Withering Bottle (Provided)"] = "пляшка зразків з Посухи Ґаррона (видано)",
    },
    [5242] = {
        ["Moora"] = "Мура",
        ["Moora slain"] = "Мура: убито",
        ["Salia"] = "Салія",
        ["Salia slain"] = "Салія: убито",
        ["Shadow Lord Fel'dan's Head"] = "голова лорда тіней Фел'дана",
        ["Shadow Lord Fel'dan's Head (Provided)"] = "голова лорда тіней Фел'дана (видано)",
    },
    [5243] = {
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
        ["Stratholme Holy Water (Provided)"] = "стратгольмська свята вода (видано)",
    },
    [5245] = {
        ["First Relic Fragment"] = "перший фрагмент реліквії",
        ["First Relic Fragment (Provided)"] = "перший фрагмент реліквії (видано)",
        ["Fourth Relic Fragment"] = "четвертий фрагмент реліквії",
        ["Fourth Relic Fragment (Provided)"] = "четвертий фрагмент реліквії (видано)",
        ["Second Relic Fragment"] = "другий фрагмент реліквії",
        ["Second Relic Fragment (Provided)"] = "другий фрагмент реліквії (видано)",
        ["Third Relic Fragment"] = "третій фрагмент реліквії",
        ["Third Relic Fragment (Provided)"] = "третій фрагмент реліквії (видано)",
    },
    [5246] = {
        ["Sacred Highborne Writings"] = "священні писання високородних",
        ["Sacred Highborne Writings (Provided)"] = "священні писання високородних (видано)",
    },
    [5247] = {
        ["Crystal Restore"] = "кристалічне відновлення",
        ["Crystal Restore (Provided)"] = "кристалічне відновлення (видано)",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Enchanted Thorium Bar (Provided)"] = "зачарований злиток торію (видано)",
        ["Vial of Dire Water"] = "флакон зі зловісною водою",
        ["Vial of Dire Water (Provided)"] = "флакон зі зловісною водою (видано)",
    },
    [5248] = {
        ["Crystal of Zin-Malor"] = "кристал Зін-Малора",
        ["Crystal of Zin-Malor (Provided)"] = "кристал Зін-Малора (видано)",
    },
    [5251] = {
        ["Archive Burned"] = "Архів спалено",
        ["Archive Burned (Provided)"] = "Архів спалено (видано)",
        ["Archive Burned slain"] = "Архів спалено: убито",
        ["Archivist Galford"] = "архіваріус Ґалфорд",
        ["Archivist Galford slain"] = "архіваріус Ґалфорд: убито",
    },
    [5252] = {
        ["Crystal of Zin-Malor"] = "кристал Зін-Малора",
        ["Crystal of Zin-Malor (Provided)"] = "кристал Зін-Малора (видано)",
    },
    [5253] = {
        ["Crystal of Zin-Malor"] = "кристал Зін-Малора",
        ["Crystal of Zin-Malor (Provided)"] = "кристал Зін-Малора (видано)",
    },
    [5262] = {
        ["Head of Balnazzar"] = "голова Бальназара",
        ["Head of Balnazzar (Provided)"] = "голова Бальназара (видано)",
    },
    [5263] = {
        ["Head of Baron Rivendare"] = "голова барона Рівендера",
        ["Head of Baron Rivendare (Provided)"] = "голова барона Рівендера (видано)",
    },
    [5282] = {
        ["Souls Freed"] = "Звільнені душі",
        ["Souls Freed (Provided)"] = "Звільнені душі (видано)",
        ["Souls Freed slain"] = "Звільнені душі: убито",
    },
    [5283] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Boots (Provided)"] = "вишукані мітрилові чоботи (видано)",
        ["Ornate Mithril Breastplate"] = "вишукана мітрилова кіраса",
        ["Ornate Mithril Breastplate (Provided)"] = "вишукана мітрилова кіраса (видано)",
        ["Ornate Mithril Helm"] = "вишуканий мітриловий шолом",
        ["Ornate Mithril Helm (Provided)"] = "вишуканий мітриловий шолом (видано)",
    },
    [5284] = {
        ["Big Black Mace"] = "велика чорна булава",
        ["Big Black Mace (Provided)"] = "велика чорна булава (видано)",
        ["Heavy Mithril Axe"] = "важка мітрилова сокира",
        ["Heavy Mithril Axe (Provided)"] = "важка мітрилова сокира (видано)",
        ["Massive Iron Axe"] = "масивна залізна сокира",
        ["Massive Iron Axe (Provided)"] = "масивна залізна сокира (видано)",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
        ["Moonsteel Broadsword (Provided)"] = "палаш з місяцесталі (видано)",
    },
    [5301] = {
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Boots (Provided)"] = "вишукані мітрилові чоботи (видано)",
        ["Ornate Mithril Breastplate"] = "вишукана мітрилова кіраса",
        ["Ornate Mithril Breastplate (Provided)"] = "вишукана мітрилова кіраса (видано)",
        ["Ornate Mithril Helm"] = "вишуканий мітриловий шолом",
        ["Ornate Mithril Helm (Provided)"] = "вишуканий мітриловий шолом (видано)",
    },
    [5302] = {
        ["Big Black Mace"] = "велика чорна булава",
        ["Big Black Mace (Provided)"] = "велика чорна булава (видано)",
        ["Heavy Mithril Axe"] = "важка мітрилова сокира",
        ["Heavy Mithril Axe (Provided)"] = "важка мітрилова сокира (видано)",
        ["Massive Iron Axe"] = "масивна залізна сокира",
        ["Massive Iron Axe (Provided)"] = "масивна залізна сокира (видано)",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
        ["Moonsteel Broadsword (Provided)"] = "палаш з місяцесталі (видано)",
    },
    [5305] = {
        ["Crimson Hammersmith's Apron"] = "фартух багряного коваля молотів",
        ["Crimson Hammersmith's Apron (Provided)"] = "фартух багряного коваля молотів (видано)",
    },
    [5306] = {
        ["Vosh'gajin's Snakestone"] = "змієкамінь Вош'ґаджин",
        ["Vosh'gajin's Snakestone (Provided)"] = "змієкамінь Вош'ґаджин (видано)",
    },
    [5307] = {
        ["Insignia of the Black Guard"] = "знак Чорної Варти",
        ["Insignia of the Black Guard (Provided)"] = "знак Чорної Варти (видано)",
    },
    [5321] = {
        ["Horn of Awakening"] = "ріг пробудження",
        ["Horn of Awakening (Provided)"] = "ріг пробудження (видано)",
    },
    [5341] = {
        ["The Deed to Brill"] = "документи на Брілль",
        ["The Deed to Brill (Provided)"] = "документи на Брілль (видано)",
        ["The Deed to Caer Darrow"] = "документи на Тверджу Дарроу",
        ["The Deed to Caer Darrow (Provided)"] = "документи на Тверджу Дарроу (видано)",
        ["The Deed to Southshore"] = "документи на Південнобережжя",
        ["The Deed to Southshore (Provided)"] = "документи на Південнобережжя (видано)",
        ["The Deed to Tarren Mill"] = "документи на Тарренський Млин",
        ["The Deed to Tarren Mill (Provided)"] = "документи на Тарренський Млин (видано)",
    },
    [5342] = {
        ["Head of Weldon Barov"] = "голова Велдона Барова",
        ["Head of Weldon Barov (Provided)"] = "голова Велдона Барова (видано)",
    },
    [5343] = {
        ["The Deed to Brill"] = "документи на Брілль",
        ["The Deed to Brill (Provided)"] = "документи на Брілль (видано)",
        ["The Deed to Caer Darrow"] = "документи на Тверджу Дарроу",
        ["The Deed to Caer Darrow (Provided)"] = "документи на Тверджу Дарроу (видано)",
        ["The Deed to Southshore"] = "документи на Південнобережжя",
        ["The Deed to Southshore (Provided)"] = "документи на Південнобережжя (видано)",
        ["The Deed to Tarren Mill"] = "документи на Тарренський Млин",
        ["The Deed to Tarren Mill (Provided)"] = "документи на Тарренський Млин (видано)",
    },
    [5344] = {
        ["Head of Alexi Barov"] = "голова Алексія Барова",
        ["Head of Alexi Barov (Provided)"] = "голова Алексія Барова (видано)",
    },
    [5361] = {
        ["Cliffwatcher Longhorn Report"] = "звіт спостерігача скель Довгорогого",
        ["Cliffwatcher Longhorn Report (Provided)"] = "звіт спостерігача скель Довгорогого (видано)",
    },
    [5381] = {
        ["Demon Box"] = "демонічна скриня",
        ["Demon Box (Provided)"] = "демонічна скриня (видано)",
        ["Demon Pick"] = "демонічна кирка",
        ["Demon Pick (Provided)"] = "демонічна кирка (видано)",
    },
    [5382] = {
        ["Doctor Theolen Krastinov"] = "доктор Теолен Крастінов",
        ["Doctor Theolen Krastinov slain"] = "доктор Теолен Крастінов: убито",
        ["Remains of Eva Sarkhoff Burned"] = "Спалені останки Єви Саркгофф",
        ["Remains of Eva Sarkhoff Burned (Provided)"] = "Спалені останки Єви Саркгофф (видано)",
        ["Remains of Eva Sarkhoff Burned slain"] = "Спалені останки Єви Саркгофф: убито",
        ["Remains of Lucien Sarkhoff Burned"] = "Спалені останки Люсьєна Саркгофа",
        ["Remains of Lucien Sarkhoff Burned (Provided)"] = "Спалені останки Люсьєна Саркгофа (видано)",
        ["Remains of Lucien Sarkhoff Burned slain"] = "Спалені останки Люсьєна Саркгофа: убито",
    },
    [5384] = {
        ["Kirtonos the Herald"] = "Вісник Кіртонос",
        ["Kirtonos the Herald slain"] = "Вісник Кіртонос: убито",
    },
    [5385] = {
        ["Remains of Trey Lightforge"] = "останки Трея Світлогарта",
        ["Remains of Trey Lightforge (Provided)"] = "останки Трея Світлогарта (видано)",
    },
    [5386] = {
        ["Bloodbelly Fish"] = "кровочеревка",
        ["Bloodbelly Fish (Provided)"] = "кровочеревка (видано)",
    },
    [5402] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
        ["Minion's Scourgestone (Provided)"] = "камінь посіпаки Скари (видано)",
    },
    [5403] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
        ["Invader's Scourgestone (Provided)"] = "камінь загарбника Скари (видано)",
    },
    [5404] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
        ["Corruptor's Scourgestone (Provided)"] = "камінь осквернителя Скари (видано)",
    },
    [5406] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
        ["Corruptor's Scourgestone (Provided)"] = "камінь осквернителя Скари (видано)",
    },
    [5407] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
        ["Invader's Scourgestone (Provided)"] = "камінь загарбника Скари (видано)",
    },
    [5408] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
        ["Minion's Scourgestone (Provided)"] = "камінь посіпаки Скари (видано)",
    },
    [5421] = {
        ["Shellfish"] = "молюск",
        ["Shellfish (Provided)"] = "молюск (видано)",
    },
    [5441] = {
        ["Foreman's Blackjack"] = "кийок десятника",
        ["Foreman's Blackjack (Provided)"] = "кийок десятника (видано)",
        ["Peons Awoken"] = "Пробуджені пеони",
        ["Peons Awoken (Provided)"] = "Пробуджені пеони (видано)",
        ["Peons Awoken slain"] = "Пробуджені пеони: убито",
    },
    [5461] = {
        ["Keepsake of Remembrance"] = "спогад про людяність",
        ["Keepsake of Remembrance (Provided)"] = "спогад про людяність (видано)",
    },
    [5462] = {
        ["Keepsake of Remembrance"] = "спогад про людяність",
        ["Keepsake of Remembrance (Provided)"] = "спогад про людяність (видано)",
    },
    [5463] = {
        ["Keepsake of Remembrance"] = "спогад про людяність",
        ["Keepsake of Remembrance (Provided)"] = "спогад про людяність (видано)",
    },
    [5464] = {
        ["Soulbound Keepsake"] = "спогад душі",
        ["Soulbound Keepsake (Provided)"] = "спогад душі (видано)",
    },
    [5465] = {
        ["Soulbound Keepsake"] = "спогад душі",
        ["Soulbound Keepsake (Provided)"] = "спогад душі (видано)",
    },
    [5466] = {
        ["Human Head of Ras Frostwhisper"] = "людська голова Раса Кригошепта",
        ["Human Head of Ras Frostwhisper (Provided)"] = "людська голова Раса Кригошепта (видано)",
    },
    [5481] = {
        ["Gloom Weed"] = "бур'ян мороку",
        ["Gloom Weed (Provided)"] = "бур'ян мороку (видано)",
    },
    [5482] = {
        ["Doom Weed"] = "бур'ян приречення",
        ["Doom Weed (Provided)"] = "бур'ян приречення (видано)",
    },
    [5501] = {
        ["Kodo Bone"] = "кістка кодо",
        ["Kodo Bone (Provided)"] = "кістка кодо (видано)",
    },
    [5502] = {
        ["Orcish Orphan Whistle"] = "свисток орка-сироти",
        ["Orcish Orphan Whistle (Provided)"] = "свисток орка-сироти (видано)",
    },
    [5504] = {
        ["21000 reputation with Argent Dawn"] = "21000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5507] = {
        ["21000 reputation with Argent Dawn"] = "21000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5508] = {
        ["Corruptor's Scourgestone"] = "камінь осквернителя Скари",
        ["Corruptor's Scourgestone (Provided)"] = "камінь осквернителя Скари (видано)",
    },
    [5509] = {
        ["Invader's Scourgestone"] = "камінь загарбника Скари",
        ["Invader's Scourgestone (Provided)"] = "камінь загарбника Скари (видано)",
    },
    [5510] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
        ["Minion's Scourgestone (Provided)"] = "камінь посіпаки Скари (видано)",
    },
    [5513] = {
        ["21000 reputation with Argent Dawn"] = "21000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5514] = {
        ["Imbued Skeletal Fragments"] = "загартовані фрагменти скелетів",
        ["Imbued Skeletal Fragments (Provided)"] = "загартовані фрагменти скелетів (видано)",
    },
    [5515] = {
        ["Krastinov's Bag of Horrors"] = "мішок жахів Крастінова",
        ["Krastinov's Bag of Horrors (Provided)"] = "мішок жахів Крастінова (видано)",
    },
    [5517] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5518] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Ogre Tannin"] = "огрська дубильна рідина",
        ["Ogre Tannin (Provided)"] = "огрська дубильна рідина (видано)",
        ["Rugged Leather"] = "міцна шкіра",
        ["Rugged Leather (Provided)"] = "міцна шкіра (видано)",
        ["Rune Thread"] = "рунічна нитка",
        ["Rune Thread (Provided)"] = "рунічна нитка (видано)",
    },
    [5519] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Ogre Tannin"] = "огрська дубильна рідина",
        ["Ogre Tannin (Provided)"] = "огрська дубильна рідина (видано)",
        ["Rugged Leather"] = "міцна шкіра",
        ["Rugged Leather (Provided)"] = "міцна шкіра (видано)",
        ["Rune Thread"] = "рунічна нитка",
        ["Rune Thread (Provided)"] = "рунічна нитка (видано)",
    },
    [5521] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5522] = {
        ["Frozen Eggs"] = "заморожені яйця",
        ["Frozen Eggs (Provided)"] = "заморожені яйця (видано)",
    },
    [5524] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [5525] = {
        ["Gordok Shackle Key"] = "ключ від кайданів Ґордока",
        ["Gordok Shackle Key (Provided)"] = "ключ від кайданів Ґордока (видано)",
    },
    [5526] = {
        ["Sealed Reliquary of Purity"] = "запечатаний релікварій чистоти",
        ["Sealed Reliquary of Purity (Provided)"] = "запечатаний релікварій чистоти (видано)",
    },
    [5527] = {
        ["Reliquary of Purity"] = "релікварій чистоти",
        ["Reliquary of Purity (Provided)"] = "релікварій чистоти (видано)",
    },
    [5529] = {
        ["Plagued Hatchling"] = "зачумлене дитинча дракона",
        ["Plagued Hatchling slain"] = "зачумлене дитинча дракона: убито",
    },
    [5531] = {
        ["Frozen Eggs"] = "заморожені яйця",
        ["Frozen Eggs (Provided)"] = "заморожені яйця (видано)",
    },
    [5532] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Required money: 20"] = "Необхідна сума: 20",
    },
    [5534] = {
        ["Some Rune"] = "якась руна",
        ["Some Rune (Provided)"] = "якась руна (видано)",
    },
    [5535] = {
        ["Highborne Apparition"] = "високородна примара",
        ["Highborne Apparition slain"] = "високородна примара: убито",
        ["Highborne Lichling"] = "високородна тінь",
        ["Highborne Lichling slain"] = "високородна тінь: убито",
    },
    [5536] = {
        ["Haldarr Felsworn"] = "гальдаррсьский скверноклят",
        ["Haldarr Felsworn slain"] = "гальдаррсьский скверноклят: убито",
        ["Haldarr Satyr"] = "гальдаррсьский сатир",
        ["Haldarr Satyr slain"] = "гальдаррсьский сатир: убито",
        ["Haldarr Trickster"] = "гальдаррсьский ошуст",
        ["Haldarr Trickster slain"] = "гальдаррсьский ошуст: убито",
    },
    [5537] = {
        ["Skeletal Fragments"] = "фрагменти скелетів",
        ["Skeletal Fragments (Provided)"] = "фрагменти скелетів (видано)",
    },
    [5538] = {
        ["Imbued Skeletal Fragments"] = "загартовані фрагменти скелетів",
        ["Imbued Skeletal Fragments (Provided)"] = "загартовані фрагменти скелетів (видано)",
    },
    [5541] = {
        ["Rumbleshot's Ammo"] = "набої Грімостріла",
        ["Rumbleshot's Ammo (Provided)"] = "набої Грімостріла (видано)",
    },
    [5542] = {
        ["Frenzied Plaguehound"] = "навіжена чумна гонча",
        ["Frenzied Plaguehound slain"] = "навіжена чумна гонча: убито",
        ["Plaguehound"] = "чумна гонча",
        ["Plaguehound Runt"] = "карликова чумна гонча",
        ["Plaguehound Runt slain"] = "карликова чумна гонча: убито",
        ["Plaguehound slain"] = "чумна гонча: убито",
    },
    [5543] = {
        ["Plaguebat"] = "чумний кажан",
        ["Plaguebat slain"] = "чумний кажан: убито",
    },
    [5544] = {
        ["Slab of Carrion Worm Meat"] = "шматок м'яса трупного черв'яка",
        ["Slab of Carrion Worm Meat (Provided)"] = "шматок м'яса трупного черв'яка (видано)",
    },
    [5545] = {
        ["Bundle of Wood"] = "зв'язка деревини",
        ["Bundle of Wood (Provided)"] = "зв'язка деревини (видано)",
    },
    [5561] = {
        ["Kodo Kombobulator"] = "комбобулятор кодо",
        ["Kodo Kombobulator (Provided)"] = "комбобулятор кодо (видано)",
        ["Kodos Tamed"] = "Приручений Кодос",
        ["Kodos Tamed (Provided)"] = "Приручений Кодос (видано)",
        ["Kodos Tamed slain"] = "Приручений Кодос: убито",
    },
    [5581] = {
        ["Hand of Iruxos"] = "рука Ірукзуса",
        ["Hand of Iruxos (Provided)"] = "рука Ірукзуса (видано)",
        ["Portals Banished"] = "Вигнані портали",
        ["Portals Banished (Provided)"] = "Вигнані портали (видано)",
        ["Portals Banished slain"] = "Вигнані портали: убито",
    },
    [5582] = {
        ["Healthy Dragon Scale"] = "здорова луска дракона",
        ["Healthy Dragon Scale (Provided)"] = "здорова луска дракона (видано)",
    },
    [5621] = {
        ["Heal and fortify Sentinel Shaya"] = "Зцілити та зміцнити Вартову Шайю",
        ["Heal and fortify Sentinel Shaya (Provided)"] = "Зцілити та зміцнити Вартову Шайю (видано)",
        ["Heal and fortify Sentinel Shaya slain"] = "Зцілити та зміцнити Вартову Шайю: убито",
    },
    [5624] = {
        ["Heal and fortify Guard Roberts"] = "Зцілити та зміцнити охоронця Робертса",
        ["Heal and fortify Guard Roberts (Provided)"] = "Зцілити та зміцнити охоронця Робертса (видано)",
        ["Heal and fortify Guard Roberts slain"] = "Зцілити та зміцнити охоронця Робертса: убито",
    },
    [5625] = {
        ["Heal and fortify Mountaineer Dolf"] = "Зцілити та зміцнити альпініста Дольфа",
        ["Heal and fortify Mountaineer Dolf (Provided)"] = "Зцілити та зміцнити альпініста Дольфа (видано)",
        ["Heal and fortify Mountaineer Dolf slain"] = "Зцілити та зміцнити альпініста Дольфа: убито",
    },
    [5648] = {
        ["Heal and fortify Grunt Kor'ja"] = "Зцілити та зміцнити Грунта Кор'джу",
        ["Heal and fortify Grunt Kor'ja (Provided)"] = "Зцілити та зміцнити Грунта Кор'джу (видано)",
        ["Heal and fortify Grunt Kor'ja slain"] = "Зцілити та зміцнити Грунта Кор'джу: убито",
    },
    [5650] = {
        ["Heal and fortify Deathguard Kel"] = "Зціліть та зміцніть Кела, Вартового Смерті",
        ["Heal and fortify Deathguard Kel (Provided)"] = "Зціліть та зміцніть Кела, Вартового Смерті (видано)",
        ["Heal and fortify Deathguard Kel slain"] = "Зціліть та зміцніть Кела, Вартового Смерті: убито",
    },
    [5713] = {
        ["Protect Aynasha"] = "Захисти Айнашу",
    },
    [5721] = {
        ["Accept Redpath's Forgiveness"] = "Прийміть прощення Редпата",
        ["Accept Redpath's Forgiveness (Provided)"] = "Прийміть прощення Редпата (видано)",
        ["Accept Redpath's Forgiveness slain"] = "Прийміть прощення Редпата: убито",
    },
    [5723] = {
        ["Ragefire Shaman"] = "шаман Лютого Полум'я",
        ["Ragefire Shaman slain"] = "шаман Лютого Полум'я: убито",
        ["Ragefire Trogg"] = "трог Лютого Полум'я",
        ["Ragefire Trogg slain"] = "трог Лютого Полум'я: убито",
    },
    [5724] = {
        ["Grimtotem Satchel"] = "сумка Зловісного Тотема",
        ["Grimtotem Satchel (Provided)"] = "сумка Зловісного Тотема (видано)",
    },
    [5725] = {
        ["Incantations from the Nether"] = "Чаклунство з Підсвіття",
        ["Incantations from the Nether (Provided)"] = "Чаклунство з Підсвіття (видано)",
        ["Spells of Shadow"] = "Закляття Темряви",
        ["Spells of Shadow (Provided)"] = "Закляття Темряви (видано)",
    },
    [5726] = {
        ["Lieutenant's Insignia"] = "знак розрізнення лейтенанта",
        ["Lieutenant's Insignia (Provided)"] = "знак розрізнення лейтенанта (видано)",
    },
    [5727] = {
        ["Gauge Neeru Fireblade's reaction to you being a member of the Burning Blade"] = "Реакція Гейджа Ніру Вогняного Клинка на те, що ти є членом Палаючого Клинка",
    },
    [5728] = {
        ["Bazzalan"] = "Баззалан",
        ["Bazzalan slain"] = "Баззалан: убито",
        ["Jergosh the Invoker"] = "Єргош-Заклинатель",
        ["Jergosh the Invoker slain"] = "Єргош-Заклинатель: убито",
    },
    [5741] = {
        ["Sceptre of Light"] = "скіпетр світла",
        ["Sceptre of Light (Provided)"] = "скіпетр світла (видано)",
    },
    [5742] = {
        ["Tirion's Tale"] = "Оповідь Тіріона",
    },
    [5761] = {
        ["Taragaman the Hungerer's Heart"] = "серце Тараґамана Ненажерливого",
        ["Taragaman the Hungerer's Heart (Provided)"] = "серце Тараґамана Ненажерливого (видано)",
    },
    [5762] = {
        ["Kravel's Crate"] = "ящик Крейвела",
        ["Kravel's Crate (Provided)"] = "ящик Крейвела (видано)",
    },
    [5763] = {
        ["Roon's Kodo Horn"] = "Рууновий ріг кодо",
        ["Roon's Kodo Horn (Provided)"] = "Рууновий ріг кодо (видано)",
    },
    [5781] = {
        ["Taelan's Hammer"] = "молот Телана",
        ["Taelan's Hammer (Provided)"] = "молот Телана (видано)",
    },
    [5801] = {
        ["Unfinished Skeleton Key"] = "незавершений скелетний ключ",
        ["Unfinished Skeleton Key (Provided)"] = "незавершений скелетний ключ (видано)",
    },
    [5802] = {
        ["Unfinished Skeleton Key"] = "незавершений скелетний ключ",
        ["Unfinished Skeleton Key (Provided)"] = "незавершений скелетний ключ (видано)",
    },
    [5803] = {
        ["Araj's Scarab"] = "скарабей Аража",
        ["Araj's Scarab (Provided)"] = "скарабей Аража (видано)",
    },
    [5804] = {
        ["Araj's Scarab"] = "скарабей Аража",
        ["Araj's Scarab (Provided)"] = "скарабей Аража (видано)",
    },
    [5805] = {
        ["Northshire Gift Voucher"] = "подарунковий сертифікат Північнокраю",
        ["Northshire Gift Voucher (Provided)"] = "подарунковий сертифікат Північнокраю (видано)",
    },
    [5821] = {
        ["Escort Gizelton Caravan past Kolkar Centaur Village"] = "Супровід каравану Gizelton повз село кентаврів Колкар",
    },
    [5841] = {
        ["Coldridge Valley Gift Voucher"] = "подарунковий сертифікат Морозної долини",
        ["Coldridge Valley Gift Voucher (Provided)"] = "подарунковий сертифікат Морозної долини (видано)",
    },
    [5842] = {
        ["Shadowglen Gift Voucher"] = "подарунковий сертифікат Тінистої долини",
        ["Shadowglen Gift Voucher (Provided)"] = "подарунковий сертифікат Тінистої долини (видано)",
    },
    [5843] = {
        ["Valley of Trials Gift Voucher"] = "подарунковий сертифікат долини Випробувань",
        ["Valley of Trials Gift Voucher (Provided)"] = "подарунковий сертифікат долини Випробувань (видано)",
    },
    [5844] = {
        ["Camp Narache Gift Voucher"] = "подарунковий сертифікат табору Нараче",
        ["Camp Narache Gift Voucher (Provided)"] = "подарунковий сертифікат табору Нараче (видано)",
    },
    [5845] = {
        ["Symbol of Lost Honor"] = "символ втраченої честі",
        ["Symbol of Lost Honor (Provided)"] = "символ втраченої честі (видано)",
    },
    [5847] = {
        ["Deathknell Gift Voucher"] = "подарунковий сертифікат Смертедзвону",
        ["Deathknell Gift Voucher (Provided)"] = "подарунковий сертифікат Смертедзвону (видано)",
    },
    [5848] = {
        ["Of Love and Family"] = "Сімейна любов",
        ["Of Love and Family (Provided)"] = "Сімейна любов (видано)",
    },
    [5861] = {
        ["Tirion's Gift"] = "подарунок Тіріона",
        ["Tirion's Gift (Provided)"] = "подарунок Тіріона (видано)",
    },
    [5862] = {
        ["Tirion's Gift"] = "подарунок Тіріона",
        ["Tirion's Gift (Provided)"] = "подарунок Тіріона (видано)",
    },
    [5863] = {
        ["Dunemaul Brute"] = "моцак Піщаного Молота",
        ["Dunemaul Brute slain"] = "моцак Піщаного Молота: убито",
        ["Dunemaul Enforcer"] = "громило Піщаного Молота",
        ["Dunemaul Enforcer slain"] = "громило Піщаного Молота: убито",
        ["Gor'marok the Ravager"] = "Ґор'марок-Руйнівник",
        ["Gor'marok the Ravager slain"] = "Ґор'марок-Руйнівник: убито",
    },
    [5881] = {
        ["Maggran's Reserve Letter"] = "лист Маґґрана",
        ["Maggran's Reserve Letter (Provided)"] = "лист Маґґрана (видано)",
    },
    [5882] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
        ["Corrupted Soul Shard (Provided)"] = "уламок оскверненої душі (видано)",
    },
    [5883] = {
        ["Tainted Vitriol"] = "уражений купорос",
        ["Tainted Vitriol (Provided)"] = "уражений купорос (видано)",
    },
    [5884] = {
        ["Fel Creep"] = "залишок скверни",
        ["Fel Creep (Provided)"] = "залишок скверни (видано)",
    },
    [5885] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
        ["Patch of Tainted Skin (Provided)"] = "клапоть ураженої шкіри (видано)",
    },
    [5886] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
        ["Lesser Nether Essence (Provided)"] = "мала підсвітня субстанція (видано)",
    },
    [5887] = {
        ["Corrupted Soul Shard"] = "уламок оскверненої душі",
        ["Corrupted Soul Shard (Provided)"] = "уламок оскверненої душі (видано)",
    },
    [5888] = {
        ["Tainted Vitriol"] = "уражений купорос",
        ["Tainted Vitriol (Provided)"] = "уражений купорос (видано)",
    },
    [5889] = {
        ["Fel Creep"] = "залишок скверни",
        ["Fel Creep (Provided)"] = "залишок скверни (видано)",
    },
    [5890] = {
        ["Patch of Tainted Skin"] = "клапоть ураженої шкіри",
        ["Patch of Tainted Skin (Provided)"] = "клапоть ураженої шкіри (видано)",
    },
    [5891] = {
        ["Lesser Nether Essence"] = "мала підсвітня субстанція",
        ["Lesser Nether Essence (Provided)"] = "мала підсвітня субстанція (видано)",
    },
    [5892] = {
        ["Irondeep Supplies"] = "припаси Залізодонних",
        ["Irondeep Supplies (Provided)"] = "припаси Залізодонних (видано)",
    },
    [5893] = {
        ["Coldtooth Supplies"] = "припаси Кригозубих",
        ["Coldtooth Supplies (Provided)"] = "припаси Кригозубих (видано)",
    },
    [5901] = {
        ["Empty Termite Jar"] = "порожня банка для термітів",
        ["Empty Termite Jar (Provided)"] = "порожня банка для термітів (видано)",
        ["Plagueland Termites"] = "терміти Зачумлених земель",
        ["Plagueland Termites (Provided)"] = "терміти Зачумлених земель (видано)",
    },
    [5902] = {
        ["Barrel of Plagueland Termites"] = "бочка з термітами Зачумлених земель",
    },
    [5903] = {
        ["Empty Termite Jar"] = "порожня банка для термітів",
        ["Empty Termite Jar (Provided)"] = "порожня банка для термітів (видано)",
        ["Plagueland Termites"] = "терміти Зачумлених земель",
        ["Plagueland Termites (Provided)"] = "терміти Зачумлених земель (видано)",
    },
    [5904] = {
        ["Barrel of Plagueland Termites"] = "бочка з термітами Зачумлених земель",
    },
    [5929] = {
        ["Seek out the Great Bear Spirit and learn what it has to share with you about the nature of the bear."] = "Шукайте Великого Ведмедя-Духа та дізнайтеся, що він може вам розповісти про природу ведмедя.",
    },
    [5930] = {
        ["Seek out the Great Bear Spirit and learn what it has to share with you about the nature of the bear."] = "Шукайте Великого Ведмедя-Духа та дізнайтеся, що він може вам розповісти про природу ведмедя.",
    },
    [5941] = {
        ["Bundle of Relics"] = "набір реліквій",
        ["Bundle of Relics (Provided)"] = "набір реліквій (видано)",
    },
    [5942] = {
        ["Joseph's Key"] = "ключ Джозефа",
        ["Joseph's Key (Provided)"] = "ключ Джозефа (видано)",
    },
    [5943] = {
        ["Escort Gizelton Caravan past Mannoroc Coven"] = "Проведіть Караван Гізелтона повз Маннорок Ковен",
    },
    [5944] = {
        ["Redemption?"] = "Викуплення?",
    },
    [5981] = {
        ["Frostmaul Giant"] = "велетень-кригобій",
        ["Frostmaul Giant slain"] = "велетень-кригобій: убито",
        ["Frostmaul Preserver"] = "хранитель-кригобій",
        ["Frostmaul Preserver slain"] = "хранитель-кригобій: убито",
    },
    [6001] = {
        ["Face Lunaclaw and earn the strength of body and heart it possesses."] = "Зіткніться з Лунаклогом і здобудьте силу тіла та серця, якою він володіє.",
    },
    [6002] = {
        ["Face Lunaclaw and earn the strength of body and heart it possesses."] = "Зіткніться з Лунаклогом і здобудьте силу тіла та серця, якою він володіє.",
    },
    [6004] = {
        ["Scarlet Hunter"] = "мисливець Багряного Походу",
        ["Scarlet Hunter slain"] = "мисливець Багряного Походу: убито",
        ["Scarlet Knight"] = "лицар Багряного Походу",
        ["Scarlet Knight slain"] = "лицар Багряного Походу: убито",
        ["Scarlet Mage"] = "маг Багряного Походу",
        ["Scarlet Mage slain"] = "маг Багряного Походу: убито",
        ["Scarlet Medic"] = "медик Багряного Походу",
        ["Scarlet Medic slain"] = "медик Багряного Походу: убито",
    },
    [6021] = {
        ["Zaeldarr's Head"] = "голова Зельдарра",
        ["Zaeldarr's Head (Provided)"] = "голова Зельдарра (видано)",
    },
    [6022] = {
        ["Coagulated Rot"] = "згущена гниль",
        ["Coagulated Rot (Provided)"] = "згущена гниль (видано)",
    },
    [6023] = {
        ["Cavalier Durgen"] = "кавалерист Дарґен",
        ["Cavalier Durgen slain"] = "кавалерист Дарґен: убито",
        ["Huntsman Radley"] = "мисливиця Радлі",
        ["Huntsman Radley slain"] = "мисливиця Радлі: убито",
    },
    [6024] = {
        ["Hameya's Key"] = "ключ Гамеї",
        ["Hameya's Key (Provided)"] = "ключ Гамеї (видано)",
    },
    [6025] = {
        ["Explore Zone"] = "Дослідіть місцевість",
        ["Overlook Hearthglen from a high vantage point"] = "Огляньте Хартглен з високої точки огляду",
    },
    [6026] = {
        ["Golden Rod"] = "золотий жезл",
        ["Golden Rod (Provided)"] = "золотий жезл (видано)",
        ["Hi-Explosive Bomb"] = "фугасна бомба",
        ["Hi-Explosive Bomb (Provided)"] = "фугасна бомба (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
        ["Unstable Trigger"] = "нестабільний пусковий пристрій",
        ["Unstable Trigger (Provided)"] = "нестабільний пусковий пристрій (видано)",
    },
    [6027] = {
        ["Book of the Ancients"] = "книга Древніх",
        ["Book of the Ancients (Provided)"] = "книга Древніх (видано)",
        ["Gem of the Serpent"] = "самоцвіт змії",
        ["Gem of the Serpent (Provided)"] = "самоцвіт змії (видано)",
    },
    [6028] = {
        ["Everlook Report"] = "доповідь з Завшегляду",
        ["Everlook Report (Provided)"] = "доповідь з Завшегляду (видано)",
    },
    [6029] = {
        ["Everlook Report"] = "доповідь з Завшегляду",
        ["Everlook Report (Provided)"] = "доповідь з Завшегляду (видано)",
    },
    [6030] = {
        ["Studies in Spirit Speaking"] = "Дослідження мови духів",
        ["Studies in Spirit Speaking (Provided)"] = "Дослідження мови духів (видано)",
    },
    [6031] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [6032] = {
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
    },
    [6041] = {
        ["Scourge Structures Destroyed"] = "Зруйновані споруди Бичі",
    },
    [6042] = {
        ["Monstrous Plaguebat"] = "жахливий чумний кажан",
        ["Monstrous Plaguebat slain"] = "жахливий чумний кажан: убито",
        ["Noxious Plaguebat"] = "згубний чумний кажан",
        ["Noxious Plaguebat slain"] = "згубний чумний кажан: убито",
    },
    [6061] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6062] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6063] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6064] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6082] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6083] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6084] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6085] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6087] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6088] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6101] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6102] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [6122] = {
        ["Filled Cliffspring Falls Sampler"] = "наповнений флакон Скельноджерельних водоспадів",
        ["Filled Cliffspring Falls Sampler (Provided)"] = "наповнений флакон Скельноджерельних водоспадів (видано)",
    },
    [6123] = {
        ["Earthroot"] = "землекорінь",
        ["Earthroot (Provided)"] = "землекорінь (видано)",
        ["Lunar Fungus"] = "місячний гриб",
        ["Lunar Fungus (Provided)"] = "місячний гриб (видано)",
    },
    [6124] = {
        ["Sickly Deer cured"] = "Хворий олень вилікуваний",
        ["Sickly Deer cured (Provided)"] = "Хворий олень вилікуваний (видано)",
        ["Sickly Deer cured slain"] = "Хворий олень вилікуваний: убито",
    },
    [6127] = {
        ["Filled Dreadmist Peak Sampler"] = "наповнений флакон вершини Зловісного Туману",
        ["Filled Dreadmist Peak Sampler (Provided)"] = "наповнений флакон вершини Зловісного Туману (видано)",
    },
    [6128] = {
        ["Earthroot"] = "землекорінь",
        ["Earthroot (Provided)"] = "землекорінь (видано)",
        ["Kodo Horn"] = "ріг кодо",
        ["Kodo Horn (Provided)"] = "ріг кодо (видано)",
    },
    [6129] = {
        ["Sickly Gazelle cured"] = "Хвора Газель вилікувалась",
        ["Sickly Gazelle cured (Provided)"] = "Хвора Газель вилікувалась (видано)",
        ["Sickly Gazelle cured slain"] = "Хвора Газель вилікувалась: убито",
    },
    [6131] = {
        ["Deadwood Gardener slain"] = "мертволісий садівник: убито",
        ["Deadwood Pathfinder slain"] = "мертволісий слідопит: убито",
        ["Deadwood Warrior slain"] = "мертволісий воїн: убито",
    },
    [6133] = {
        ["Pathstrider"] = "розвідниця",
        ["Pathstrider slain"] = "розвідниця: убито",
        ["Quel'Thalas Registry"] = "реєстр Квел'Таласа",
        ["Quel'Thalas Registry (Provided)"] = "реєстр Квел'Таласа (видано)",
        ["Ranger"] = "слідопит",
        ["Ranger slain"] = "слідопит: убито",
        ["Woodsman"] = "лісник",
        ["Woodsman slain"] = "лісник: убито",
    },
    [6134] = {
        ["Crate of Ghost Magnets"] = "ящик примарних магнітів",
        ["Crate of Ghost Magnets (Provided)"] = "ящик примарних магнітів (видано)",
        ["Ghost-o-plasm"] = "ектоплазма",
        ["Ghost-o-plasm (Provided)"] = "ектоплазма (видано)",
    },
    [6135] = {
        ["Patch of Duskwing's Fur"] = "жмут хутра Смеркокрила",
        ["Patch of Duskwing's Fur (Provided)"] = "жмут хутра Смеркокрила (видано)",
    },
    [6136] = {
        ["Borelgore"] = "Гидкослиз",
        ["Borelgore slain"] = "Гидкослиз: убито",
    },
    [6142] = {
        ["Soft-shelled Clam Meat"] = "м'ясо м'якопанцирного молюска",
        ["Soft-shelled Clam Meat (Provided)"] = "м'ясо м'якопанцирного молюска (видано)",
    },
    [6143] = {
        ["Slitherblade Myrmidon"] = "слизькорізий мірмідон",
        ["Slitherblade Myrmidon slain"] = "слизькорізий мірмідон: убито",
        ["Slitherblade Naga"] = "слизькоріза нага",
        ["Slitherblade Naga slain"] = "слизькоріза нага: убито",
        ["Slitherblade Sorceress"] = "слизькоріза чаклунка",
        ["Slitherblade Sorceress slain"] = "слизькоріза чаклунка: убито",
    },
    [6145] = {
        ["The Grand Crusader's Command"] = "наказ верховного лицаря",
        ["The Grand Crusader's Command (Provided)"] = "наказ верховного лицаря (видано)",
    },
    [6146] = {
        ["The Grand Crusader's Command"] = "наказ верховного лицаря",
        ["The Grand Crusader's Command (Provided)"] = "наказ верховного лицаря (видано)",
    },
    [6148] = {
        ["Demetria"] = "Деметрія",
        ["Demetria slain"] = "Деметрія: убито",
    },
    [6161] = {
        ["Rackmore's Golden Key"] = "золотий ключ Ракмора",
        ["Rackmore's Golden Key (Provided)"] = "золотий ключ Ракмора (видано)",
        ["Rackmore's Silver Key"] = "срібний ключ Ракмора",
        ["Rackmore's Silver Key (Provided)"] = "срібний ключ Ракмора (видано)",
    },
    [6162] = {
        ["Overlord Ror's Claw"] = "кіготь властителя Рора",
        ["Overlord Ror's Claw (Provided)"] = "кіготь властителя Рора (видано)",
    },
    [6163] = {
        ["Head of Ramstein the Gorger"] = "голова Рамштайна-Ненажери",
        ["Head of Ramstein the Gorger (Provided)"] = "голова Рамштайна-Ненажери (видано)",
    },
    [6164] = {
        ["Augustus' Receipt Book"] = "чекова книжка Августа",
        ["Augustus' Receipt Book (Provided)"] = "чекова книжка Августа (видано)",
    },
    [6181] = {
        ["Lewis' Note"] = "записка Льюїса",
        ["Lewis' Note (Provided)"] = "записка Льюїса (видано)",
    },
    [6185] = {
        ["SI:7 Insignia (Fredo)"] = "жетон ШУР (Фредо)",
        ["SI:7 Insignia (Fredo) (Provided)"] = "жетон ШУР (Фредо) (видано)",
        ["SI:7 Insignia (Rutger)"] = "жетон ШУР (Рутґер)",
        ["SI:7 Insignia (Rutger) (Provided)"] = "жетон ШУР (Рутґер) (видано)",
        ["SI:7 Insignia (Turyen)"] = "жетон ШУР (Тур'єн)",
        ["SI:7 Insignia (Turyen) (Provided)"] = "жетон ШУР (Тур'єн) (видано)",
    },
    [6187] = {
        ["Nathanos Blightcaller"] = "Натанос Заклинач Гниття",
        ["Nathanos Blightcaller (Provided)"] = "Натанос Заклинач Гниття (видано)",
        ["Nathanos Blightcaller slain"] = "Натанос Заклинач Гниття: убито",
    },
    [6201] = {
        ["Darnassian Bleu"] = "дарнаський блю",
        ["Refreshing Spring Water"] = "освіжаюча джерельна вода",
    },
    [6261] = {
        ["Osric's Crate"] = "ящик Озріка",
        ["Osric's Crate (Provided)"] = "ящик Озріка (видано)",
    },
    [6281] = {
        ["Lewis' Note"] = "записка Льюїса",
        ["Lewis' Note (Provided)"] = "записка Льюїса (видано)",
    },
    [6282] = {
        ["Bloodfury Ambusher"] = "криваволюта душителька",
        ["Bloodfury Ambusher slain"] = "криваволюта душителька: убито",
        ["Bloodfury Harpy"] = "криваволюта гарпія",
        ["Bloodfury Harpy slain"] = "криваволюта гарпія: убито",
        ["Bloodfury Roguefeather"] = "криваволюта оперена пройдисвітка",
        ["Bloodfury Roguefeather slain"] = "криваволюта оперена пройдисвітка: убито",
        ["Bloodfury Slayer"] = "криваволюта вбивця",
        ["Bloodfury Slayer slain"] = "криваволюта вбивця: убито",
    },
    [6283] = {
        ["Bloodfury Ripper's Remains"] = "рештки криваволютої різниці",
        ["Bloodfury Ripper's Remains (Provided)"] = "рештки криваволютої різниці (видано)",
    },
    [6284] = {
        ["Besseleth's Fang"] = "ікло Бесселет",
        ["Besseleth's Fang (Provided)"] = "ікло Бесселет (видано)",
    },
    [6285] = {
        ["Osric's Crate"] = "ящик Озріка",
        ["Osric's Crate (Provided)"] = "ящик Озріка (видано)",
    },
    [6301] = {
        ["Gaea Seed"] = "насіння Ґеї",
        ["Gaea Seed (Provided)"] = "насіння Ґеї (видано)",
    },
    [6321] = {
        ["Podrig's Order"] = "замовлення Подріґа",
        ["Podrig's Order (Provided)"] = "замовлення Подріґа (видано)",
    },
    [6322] = {
        ["Gordon's Crate"] = "ящик Гордона",
        ["Gordon's Crate (Provided)"] = "ящик Гордона (видано)",
    },
    [6323] = {
        ["Podrig's Order"] = "замовлення Подріґа",
        ["Podrig's Order (Provided)"] = "замовлення Подріґа (видано)",
    },
    [6324] = {
        ["Gordon's Crate"] = "ящик Гордона",
        ["Gordon's Crate (Provided)"] = "ящик Гордона (видано)",
    },
    [6341] = {
        ["Nessa's Collection"] = "колекція Несси",
        ["Nessa's Collection (Provided)"] = "колекція Несси (видано)",
    },
    [6342] = {
        ["Nessa's Collection"] = "колекція Несси",
        ["Nessa's Collection (Provided)"] = "колекція Несси (видано)",
    },
    [6343] = {
        ["Laird's Response"] = "відповідь Лейрда",
        ["Laird's Response (Provided)"] = "відповідь Лейрда (видано)",
    },
    [6361] = {
        ["Bundle of Hides"] = "оберемок шкур",
        ["Bundle of Hides (Provided)"] = "оберемок шкур (видано)",
    },
    [6362] = {
        ["Bundle of Hides"] = "оберемок шкур",
        ["Bundle of Hides (Provided)"] = "оберемок шкур (видано)",
    },
    [6363] = {
        ["Ahanu's Leather Goods"] = "шкіргалантерея Агану",
        ["Ahanu's Leather Goods (Provided)"] = "шкіргалантерея Агану (видано)",
    },
    [6364] = {
        ["Ahanu's Leather Goods"] = "шкіргалантерея Агану",
        ["Ahanu's Leather Goods (Provided)"] = "шкіргалантерея Агану (видано)",
    },
    [6365] = {
        ["Zargh's Meats"] = "м'ясо від Зарґа",
        ["Zargh's Meats (Provided)"] = "м'ясо від Зарґа (видано)",
    },
    [6381] = {
        ["Enchanted Gaea Seeds"] = "зачароване насіння Ґеї",
        ["Enchanted Gaea Seeds (Provided)"] = "зачароване насіння Ґеї (видано)",
        ["Gaea seed planted"] = "Насіння Геї посаджене",
        ["Gaea seed planted (Provided)"] = "Насіння Геї посаджене (видано)",
        ["Gaea seed planted slain"] = "Насіння Геї посаджене: убито",
    },
    [6384] = {
        ["Zargh's Meats"] = "м'ясо від Зарґа",
        ["Zargh's Meats (Provided)"] = "м'ясо від Зарґа (видано)",
    },
    [6385] = {
        ["Gryshka's Letter"] = "лист Гришки",
        ["Gryshka's Letter (Provided)"] = "лист Гришки (видано)",
    },
    [6386] = {
        ["Gryshka's Letter"] = "лист Гришки",
        ["Gryshka's Letter (Provided)"] = "лист Гришки (видано)",
    },
    [6387] = {
        ["Brock's List"] = "список Брока",
        ["Brock's List (Provided)"] = "список Брока (видано)",
    },
    [6388] = {
        ["Honorary Picks"] = "почесні кирки",
        ["Honorary Picks (Provided)"] = "почесні кирки (видано)",
    },
    [6389] = {
        ["Barrel of Plagueland Termites"] = "бочка з термітами Зачумлених земель",
        ["Barrel of Plagueland Termites (Provided)"] = "бочка з термітами Зачумлених земель (видано)",
    },
    [6390] = {
        ["Barrel of Plagueland Termites"] = "бочка з термітами Зачумлених земель",
        ["Barrel of Plagueland Termites (Provided)"] = "бочка з термітами Зачумлених земель (видано)",
    },
    [6391] = {
        ["Brock's List"] = "список Брока",
        ["Brock's List (Provided)"] = "список Брока (видано)",
    },
    [6392] = {
        ["Honorary Picks"] = "почесні кирки",
        ["Honorary Picks (Provided)"] = "почесні кирки (видано)",
    },
    [6393] = {
        ["Incendrites"] = "спалахтит",
        ["Incendrites (Provided)"] = "спалахтит (видано)",
    },
    [6394] = {
        ["Thazz'ril's Pick"] = "кайло Тазз'ріла",
        ["Thazz'ril's Pick (Provided)"] = "кайло Тазз'ріла (видано)",
    },
    [6395] = {
        ["Samuel's Remains Buried"] = "Останки Самуїла поховані",
        ["Samuel's Remains Buried (Provided)"] = "Останки Самуїла поховані (видано)",
        ["Samuel's Remains Buried slain"] = "Останки Самуїла поховані: убито",
    },
    [6403] = {
        ["Reginald's March"] = "Марш Реджинальда",
    },
    [6421] = {
        ["Resonite Crystal"] = "кристал резоніту",
        ["Resonite Crystal (Provided)"] = "кристал резоніту (видано)",
    },
    [6441] = {
        ["Satyr Horns"] = "роги сатира",
        ["Satyr Horns (Provided)"] = "роги сатира (видано)",
    },
    [6442] = {
        ["Wrathtail Head"] = "голова гнівохвостої наги",
        ["Wrathtail Head (Provided)"] = "голова гнівохвостої наги (видано)",
    },
    [6461] = {
        ["Deepmoss Creeper"] = "густомоховий підкрадач",
        ["Deepmoss Creeper slain"] = "густомоховий підкрадач: убито",
        ["Deepmoss Venomspitter"] = "густомоховий ядоплюй",
        ["Deepmoss Venomspitter slain"] = "густомоховий ядоплюй: убито",
    },
    [6462] = {
        ["Troll Charm"] = "трольський оберіг",
        ["Troll Charm (Provided)"] = "трольський оберіг (видано)",
    },
    [6481] = {
        ["Enchanted Resonite Crystal"] = "зачарований кристал резоніту",
        ["Enchanted Resonite Crystal (Provided)"] = "зачарований кристал резоніту (видано)",
        ["Goggeroc"] = "Ґоґґерок",
        ["Goggeroc slain"] = "Ґоґґерок: убито",
    },
    [6482] = {
        ["Escort Ruul from the Thistlefurs."] = "Ескорт Руула з Будячих Хутрянок.",
    },
    [6501] = {
        ["Fragment of the Dragon's Eye"] = "фрагмент Ока Дракона",
        ["Fragment of the Dragon's Eye (Provided)"] = "фрагмент Ока Дракона (видано)",
    },
    [6502] = {
        ["Blood of the Black Dragon Champion"] = "кров чемпіона чорних драконів",
        ["Blood of the Black Dragon Champion (Provided)"] = "кров чемпіона чорних драконів (видано)",
    },
    [6503] = {
        ["Ashenvale Outrunner"] = "вісниця Ясенедолу",
        ["Ashenvale Outrunner slain"] = "вісниця Ясенедолу: убито",
    },
    [6504] = {
        ["Shredder Operating Manual - Chapter 1"] = "інструкція з експлуатації подрібнювача — розділ 1",
        ["Shredder Operating Manual - Chapter 1 (Provided)"] = "інструкція з експлуатації подрібнювача — розділ 1 (видано)",
        ["Shredder Operating Manual - Chapter 2"] = "інструкція з експлуатації подрібнювача — розділ 2",
        ["Shredder Operating Manual - Chapter 2 (Provided)"] = "інструкція з експлуатації подрібнювача — розділ 2 (видано)",
        ["Shredder Operating Manual - Chapter 3"] = "інструкція з експлуатації подрібнювача — розділ 3",
        ["Shredder Operating Manual - Chapter 3 (Provided)"] = "інструкція з експлуатації подрібнювача — розділ 3 (видано)",
    },
    [6521] = {
        ["Ambassador Malcin's Head"] = "голова посла Малкіна",
        ["Ambassador Malcin's Head (Provided)"] = "голова посла Малкіна (видано)",
    },
    [6522] = {
        ["Small Scroll"] = "маленький сувій",
        ["Small Scroll (Provided)"] = "маленький сувій (видано)",
    },
    [6523] = {
        ["Kaya Escorted to Camp Aparaje"] = "Каю супроводжують до табору Апараже",
    },
    [6543] = {
        ["Warsong Outrider Update"] = "звіт вершниці Пісні Війни",
        ["Warsong Outrider Update (Provided)"] = "звіт вершниці Пісні Війни (видано)",
        ["Warsong Runner Update"] = "звіт гінця Пісні Війни",
        ["Warsong Runner Update (Provided)"] = "звіт гінця Пісні Війни (видано)",
        ["Warsong Scout Update"] = "звіт розвідниці Пісні Війни",
        ["Warsong Scout Update (Provided)"] = "звіт розвідниці Пісні Війни (видано)",
    },
    [6544] = {
        ["Take Silverwing Outpost."] = "Займіть форпост Срібнокрилих.",
    },
    [6545] = {
        ["Warsong Report"] = "наказ Пісні Війни",
        ["Warsong Report (Provided)"] = "наказ Пісні Війни (видано)",
    },
    [6546] = {
        ["Warsong Report"] = "наказ Пісні Війни",
        ["Warsong Report (Provided)"] = "наказ Пісні Війни (видано)",
    },
    [6547] = {
        ["Warsong Report"] = "наказ Пісні Війни",
        ["Warsong Report (Provided)"] = "наказ Пісні Війни (видано)",
    },
    [6548] = {
        ["Grimtotem Mercenary"] = "найманець Зловісного Тотема",
        ["Grimtotem Mercenary slain"] = "найманець Зловісного Тотема: убито",
        ["Grimtotem Ruffian"] = "розбійник Зловісного Тотема",
        ["Grimtotem Ruffian slain"] = "розбійник Зловісного Тотема: убито",
    },
    [6561] = {
        ["Head of Kelris"] = "голова Келріса",
        ["Head of Kelris (Provided)"] = "голова Келріса (видано)",
    },
    [6563] = {
        ["Sapphire of Aku'Mai"] = "сапфір Аку'Май",
        ["Sapphire of Aku'Mai (Provided)"] = "сапфір Аку'Май (видано)",
    },
    [6564] = {
        ["Damp Note"] = "розмокла записка",
        ["Damp Note (Provided)"] = "розмокла записка (видано)",
    },
    [6565] = {
        ["Lorgus Jett"] = "Лорґус Джетт",
        ["Lorgus Jett slain"] = "Лорґус Джетт: убито",
    },
    [6566] = {
        ["Thrall's Tale"] = "Оповідь Тралла",
    },
    [6568] = {
        ["Rexxar's Testament"] = "завіт Рексара",
        ["Rexxar's Testament (Provided)"] = "завіт Рексара (видано)",
    },
    [6569] = {
        ["Black Dragonspawn Eye"] = "око чорного драконіда",
        ["Black Dragonspawn Eye (Provided)"] = "око чорного драконіда (видано)",
    },
    [6570] = {
        ["Amulet of Draconic Subversion"] = "амулет обману драконів",
    },
    [6571] = {
        ["Logging Rope"] = "лісозаготівельна мотузка",
        ["Logging Rope (Provided)"] = "лісозаготівельна мотузка (видано)",
        ["Warsong Axe Shipment"] = "вантаж сокир Пісні Війни",
        ["Warsong Axe Shipment (Provided)"] = "вантаж сокир Пісні Війни (видано)",
        ["Warsong Oil"] = "мастило Пісні Війни",
        ["Warsong Oil (Provided)"] = "мастило Пісні Війни (видано)",
        ["Warsong Saw Blades"] = "пиляльні леза Пісні Війни",
        ["Warsong Saw Blades (Provided)"] = "пиляльні леза Пісні Війни (видано)",
    },
    [6581] = {
        ["Deadly Blunderbuss"] = "смертоносний мушкетон",
        ["Deadly Blunderbuss (Provided)"] = "смертоносний мушкетон (видано)",
    },
    [6582] = {
        ["The Skull of Scryer"] = "череп Провидця",
        ["The Skull of Scryer (Provided)"] = "череп Провидця (видано)",
    },
    [6583] = {
        ["The Skull of Somnus"] = "череп Сомнуса",
        ["The Skull of Somnus (Provided)"] = "череп Сомнуса (видано)",
    },
    [6584] = {
        ["The Skull of Chronalis"] = "череп Хроналіса",
        ["The Skull of Chronalis (Provided)"] = "череп Хроналіса (видано)",
    },
    [6585] = {
        ["The Skull of Axtroz"] = "череп Акстроза",
        ["The Skull of Axtroz (Provided)"] = "череп Акстроза (видано)",
    },
    [6601] = {
        ["Dull Drakefire Amulet"] = "згаслий амулет полум'я дракона",
        ["Dull Drakefire Amulet (Provided)"] = "згаслий амулет полум'я дракона (видано)",
    },
    [6602] = {
        ["Blood of the Black Dragon Champion"] = "кров чемпіона чорних драконів",
        ["Blood of the Black Dragon Champion (Provided)"] = "кров чемпіона чорних драконів (видано)",
    },
    [6607] = {
        ["Feralas Ahi"] = "фераласька ахі",
        ["Feralas Ahi (Provided)"] = "фераласька ахі (видано)",
        ["Misty Reed Mahi Mahi"] = "махі-махі Туманного Очерету",
        ["Misty Reed Mahi Mahi (Provided)"] = "махі-махі Туманного Очерету (видано)",
        ["Sar'theris Striker"] = "сар'теріський мілинник",
        ["Sar'theris Striker (Provided)"] = "сар'теріський мілинник (видано)",
        ["Savage Coast Blue Sailfin"] = "синій вітрильник Дикого узбережжя",
        ["Savage Coast Blue Sailfin (Provided)"] = "синій вітрильник Дикого узбережжя (видано)",
    },
    [6610] = {
        ["Alterac Swiss"] = "альтерацький сир",
        ["Alterac Swiss (Provided)"] = "альтерацький сир (видано)",
        ["Giant Egg"] = "гігантське яйце",
        ["Giant Egg (Provided)"] = "гігантське яйце (видано)",
        ["Zesty Clam Meat"] = "пікантне м'ясо молюска",
        ["Zesty Clam Meat (Provided)"] = "пікантне м'ясо молюска (видано)",
    },
    [6621] = {
        ["Murgut's Totem"] = "тотем Мурґута",
        ["Murgut's Totem (Provided)"] = "тотем Мурґута (видано)",
    },
    [6622] = {
        ["15 Patients Saved!"] = "15 пацієнтів врятовано!",
    },
    [6624] = {
        ["15 Patients Saved!"] = "15 пацієнтів врятовано!",
    },
    [6626] = {
        ["Death's Head Cultist"] = "мертвоголова культистка",
        ["Death's Head Cultist slain"] = "мертвоголова культистка: убито",
        ["Razorfen Battleguard"] = "бривоболотий боєстраж",
        ["Razorfen Battleguard slain"] = "бривоболотий боєстраж: убито",
        ["Razorfen Thornweaver"] = "бривоболотий терноткач",
        ["Razorfen Thornweaver slain"] = "бривоболотий терноткач: убито",
    },
    [6627] = {
        ["Answer Braug Dimspirit's question correctly"] = "Дайте правильну відповідь на запитання Брауга Дімспіріта",
    },
    [6628] = {
        ["Answer Parqual Fintallas' question correctly"] = "Правильно дайте відповідь на запитання Паркуала Фінталласа",
    },
    [6629] = {
        ["Grimtotem Brute"] = "моцак Зловісного Тотема",
        ["Grimtotem Brute slain"] = "моцак Зловісного Тотема: убито",
        ["Grundig Darkcloud"] = "Ґрандіґ Темна Хмара",
        ["Grundig Darkcloud slain"] = "Ґрандіґ Темна Хмара: убито",
    },
    [6641] = {
        ["Defeat Vorsha the Lasher"] = "Переможіть Воршу Батога",
    },
    [6642] = {
        ["Dark Iron Ore"] = "руда темного заліза",
        ["Dark Iron Ore (Provided)"] = "руда темного заліза (видано)",
    },
    [6643] = {
        ["Fiery Core"] = "вогняне ядро",
        ["Fiery Core (Provided)"] = "вогняне ядро (видано)",
    },
    [6644] = {
        ["Lava Core"] = "лавове ядро",
        ["Lava Core (Provided)"] = "лавове ядро (видано)",
    },
    [6645] = {
        ["Core Leather"] = "шкіра ядра",
        ["Core Leather (Provided)"] = "шкіра ядра (видано)",
    },
    [6646] = {
        ["Blood of the Mountain"] = "кров гори",
        ["Blood of the Mountain (Provided)"] = "кров гори (видано)",
    },
    [6661] = {
        ["Rat Catcher's Flute"] = "флейта щуролова",
        ["Rat Catcher's Flute (Provided)"] = "флейта щуролова (видано)",
        ["Rats Captured"] = "Спіймані щури",
        ["Rats Captured (Provided)"] = "Спіймані щури (видано)",
        ["Rats Captured slain"] = "Спіймані щури: убито",
    },
    [6662] = {
        ["Carton of Mystery Meat"] = "коробка загадкового м'яса",
        ["Carton of Mystery Meat (Provided)"] = "коробка загадкового м'яса (видано)",
    },
    [6681] = {
        ["Rite of Cunning"] = "Обряд хитрості",
        ["Rite of Cunning (Provided)"] = "Обряд хитрості (видано)",
        ["Rite of Cunning slain"] = "Обряд хитрості: убито",
        ["Seal of Ravenholdt"] = "печатка Рейвенхольдта",
        ["Seal of Ravenholdt (Provided)"] = "печатка Рейвенхольдта (видано)",
    },
    [6701] = {
        ["Syndicate Emblem"] = "емблема Синдикату",
        ["Syndicate Emblem (Provided)"] = "емблема Синдикату (видано)",
    },
    [6741] = {
        ["Armor Scraps"] = "уламки броні",
        ["Armor Scraps (Provided)"] = "уламки броні (видано)",
    },
    [6781] = {
        ["Armor Scraps"] = "уламки броні",
        ["Armor Scraps (Provided)"] = "уламки броні (видано)",
    },
    [6801] = {
        ["Stormpike Soldier's Blood"] = "кров солдата Бурешпиля",
        ["Stormpike Soldier's Blood (Provided)"] = "кров солдата Бурешпиля (видано)",
    },
    [6804] = {
        ["Aspect of Neptulon"] = "аспект Нептулона",
        ["Aspect of Neptulon (Provided)"] = "аспект Нептулона (видано)",
        ["Discordant Bracers"] = "браслет збожеволілого сплеска",
        ["Discordant Bracers (Provided)"] = "браслет збожеволілого сплеска (видано)",
    },
    [6805] = {
        ["Desert Rumbler"] = "пустельний гуркотун",
        ["Desert Rumbler slain"] = "пустельний гуркотун: убито",
        ["Dust Stormer"] = "пустельний буревісник",
        ["Dust Stormer slain"] = "пустельний буревісник: убито",
    },
    [6821] = {
        ["Eye of the Emberseer"] = "око Вуглегляда",
        ["Eye of the Emberseer (Provided)"] = "око Вуглегляда (видано)",
    },
    [6822] = {
        ["Ancient Core Hound"] = "древній гончак ядра",
        ["Ancient Core Hound slain"] = "древній гончак ядра: убито",
        ["Firelord"] = "лорд вогню",
        ["Firelord slain"] = "лорд вогню: убито",
        ["Lava Surger"] = "лавовий сплеск",
        ["Lava Surger slain"] = "лавовий сплеск: убито",
        ["Molten Giant"] = "розплавлений велетень",
        ["Molten Giant slain"] = "розплавлений велетень: убито",
    },
    [6823] = {
        ["9000 reputation with Hydraxian Waterlords"] = "9000 репутації у Гідраксійських Водоловів",
    },
    [6824] = {
        ["Hand of Gehennas"] = "рука Геєнаса",
        ["Hand of Gehennas (Provided)"] = "рука Геєнаса (видано)",
        ["Hand of Lucifron"] = "рука Люцифрона",
        ["Hand of Lucifron (Provided)"] = "рука Люцифрона (видано)",
        ["Hand of Shazzrah"] = "рука Шаззраха",
        ["Hand of Shazzrah (Provided)"] = "рука Шаззраха (видано)",
        ["Hand of Sulfuron"] = "рука Сульфурона",
        ["Hand of Sulfuron (Provided)"] = "рука Сульфурона (видано)",
    },
    [6825] = {
        ["Stormpike Soldier's Flesh"] = "плоть солдата Бурешпиля",
        ["Stormpike Soldier's Flesh (Provided)"] = "плоть солдата Бурешпиля (видано)",
    },
    [6826] = {
        ["Stormpike Lieutenant's Flesh"] = "плоть лейтенанта Бурешпиля",
        ["Stormpike Lieutenant's Flesh (Provided)"] = "плоть лейтенанта Бурешпиля (видано)",
    },
    [6827] = {
        ["Stormpike Commander's Flesh"] = "плоть командира Бурешпиля",
        ["Stormpike Commander's Flesh (Provided)"] = "плоть командира Бурешпиля (видано)",
    },
    [6844] = {
        ["Encrusted Silithid Object"] = "вкрита хітином річ",
        ["Encrusted Silithid Object (Provided)"] = "вкрита хітином річ (видано)",
    },
    [6846] = {
        ["Stormpike Assault Orders"] = "наказ Бурешпиля про атаку",
        ["Stormpike Assault Orders (Provided)"] = "наказ Бурешпиля про атаку (видано)",
    },
    [6847] = {
        ["Master Ryson's All Seeing Eye Recovered"] = "Всевидюче око майстра Райсона знайдено",
    },
    [6848] = {
        ["Master Ryson's All Seeing Eye Recovered"] = "Всевидюче око майстра Райсона знайдено",
    },
    [6861] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
        ["Steamsaw"] = "парова пилка",
        ["Steamsaw (Provided)"] = "парова пилка (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [6862] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
        ["Steamsaw"] = "парова пилка",
        ["Steamsaw (Provided)"] = "парова пилка (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [6881] = {
        ["Storm Crystal"] = "кристал шторму",
        ["Storm Crystal (Provided)"] = "кристал шторму (видано)",
    },
    [6901] = {
        ["Frostwolf Assault Orders"] = "наказ Морозних Вовків про атаку",
        ["Frostwolf Assault Orders (Provided)"] = "наказ Морозних Вовків про атаку (видано)",
    },
    [6921] = {
        ["Fathom Core"] = "ядро глибин",
        ["Fathom Core (Provided)"] = "ядро глибин (видано)",
    },
    [6922] = {
        ["Strange Water Globe"] = "дивна водяна куля",
        ["Strange Water Globe (Provided)"] = "дивна водяна куля (видано)",
    },
    [6941] = {
        ["Frostwolf Lieutenant's Medal"] = "медаль лейтенанта Морозних Вовків",
        ["Frostwolf Lieutenant's Medal (Provided)"] = "медаль лейтенанта Морозних Вовків (видано)",
    },
    [6942] = {
        ["Frostwolf Soldier's Medal"] = "медаль солдата Морозних Вовків",
        ["Frostwolf Soldier's Medal (Provided)"] = "медаль солдата Морозних Вовків (видано)",
    },
    [6943] = {
        ["Frostwolf Commander's Medal"] = "медаль командира Морозних Вовків",
        ["Frostwolf Commander's Medal (Provided)"] = "медаль командира Морозних Вовків (видано)",
    },
    [6962] = {
        ["Gingerbread Cookie"] = "імбирне печиво",
        ["Gingerbread Cookie (Provided)"] = "імбирне печиво (видано)",
        ["Ice Cold Milk"] = "крижане молоко",
        ["Ice Cold Milk (Provided)"] = "крижане молоко (видано)",
    },
    [6981] = {
        ["Glowing Shard"] = "сяючий уламок",
        ["Glowing Shard (Provided)"] = "сяючий уламок (видано)",
    },
    [6982] = {
        ["Coldtooth Supplies"] = "припаси Кригозубих",
        ["Coldtooth Supplies (Provided)"] = "припаси Кригозубих (видано)",
    },
    [6983] = {
        ["Stolen Treats"] = "викрадені ласощі",
        ["Stolen Treats (Provided)"] = "викрадені ласощі (видано)",
    },
    [6985] = {
        ["Irondeep Supplies"] = "припаси Залізодонних",
        ["Irondeep Supplies (Provided)"] = "припаси Залізодонних (видано)",
    },
    [7001] = {
        ["Frostwolf Muzzled and Returned"] = "Морозний Вовк закуваний у намордник і повернувся",
    },
    [7002] = {
        ["Alterac Ram Hide"] = "шкура альтерацького барана",
        ["Alterac Ram Hide (Provided)"] = "шкура альтерацького барана (видано)",
    },
    [7003] = {
        ["Miniaturization Residue"] = "залишок мініатюризації",
        ["Miniaturization Residue (Provided)"] = "залишок мініатюризації (видано)",
    },
    [7025] = {
        ["Gingerbread Cookie"] = "імбирне печиво",
        ["Gingerbread Cookie (Provided)"] = "імбирне печиво (видано)",
        ["Ice Cold Milk"] = "крижане молоко",
        ["Ice Cold Milk (Provided)"] = "крижане молоко (видано)",
    },
    [7026] = {
        ["Frostwolf Hide"] = "шкура морозного вовка",
        ["Frostwolf Hide (Provided)"] = "шкура морозного вовка (видано)",
    },
    [7027] = {
        ["Ram Collared and Returned"] = "Овена спіймали на нашийник і повернули",
    },
    [7028] = {
        ["Theradric Crystal Carving"] = "терадричний кришталевий орнамент",
        ["Theradric Crystal Carving (Provided)"] = "терадричний кришталевий орнамент (видано)",
    },
    [7029] = {
        ["Filled Cerulean Vial"] = "наповнений лазуровий флакон",
        ["Filled Cerulean Vial (Provided)"] = "наповнений лазуровий флакон (видано)",
        ["Vylestem Vines healed"] = "Вилестемські лози зцілилися",
        ["Vylestem Vines healed (Provided)"] = "Вилестемські лози зцілилися (видано)",
        ["Vylestem Vines healed slain"] = "Вилестемські лози зцілилися: убито",
    },
    [7041] = {
        ["Filled Cerulean Vial"] = "наповнений лазуровий флакон",
        ["Filled Cerulean Vial (Provided)"] = "наповнений лазуровий флакон (видано)",
        ["Vylestem Vines healed"] = "Вилестемські лози зцілилися",
        ["Vylestem Vines healed (Provided)"] = "Вилестемські лози зцілилися (видано)",
        ["Vylestem Vines healed slain"] = "Вилестемські лози зцілилися: убито",
    },
    [7043] = {
        ["Stolen Treats"] = "викрадені ласощі",
        ["Stolen Treats (Provided)"] = "викрадені ласощі (видано)",
    },
    [7044] = {
        ["Celebrian Diamond"] = "діамант Келебраса",
        ["Celebrian Diamond (Provided)"] = "діамант Келебраса (видано)",
        ["Celebrian Rod"] = "жезл Келебраса",
        ["Celebrian Rod (Provided)"] = "жезл Келебраса (видано)",
    },
    [7046] = {
        ["Create the Scepter of Celebras"] = "Створіть Скіпетр Целебраса",
    },
    [7061] = {
        ["The Feast of Winter Veil"] = "Свято Зимової Покрови",
        ["The Feast of Winter Veil (Provided)"] = "Свято Зимової Покрови (видано)",
    },
    [7063] = {
        ["The Feast of Winter Veil"] = "Свято Зимової Покрови",
        ["The Feast of Winter Veil (Provided)"] = "Свято Зимової Покрови (видано)",
    },
    [7064] = {
        ["Princess Theradras"] = "Принцеса Терадрас",
        ["Princess Theradras (Provided)"] = "Принцеса Терадрас (видано)",
        ["Princess Theradras slain"] = "Принцеса Терадрас: убито",
    },
    [7065] = {
        ["Princess Theradras"] = "Принцеса Терадрас",
        ["Princess Theradras (Provided)"] = "Принцеса Терадрас (видано)",
        ["Princess Theradras slain"] = "Принцеса Терадрас: убито",
    },
    [7066] = {
        ["Seed of Life"] = "насіння життя",
        ["Seed of Life (Provided)"] = "насіння життя (видано)",
    },
    [7067] = {
        ["Amulet of Union"] = "амулет Єднання",
        ["Amulet of Union (Provided)"] = "амулет Єднання (видано)",
    },
    [7068] = {
        ["Shadowshard Fragment"] = "фрагмент тінекаменю",
        ["Shadowshard Fragment (Provided)"] = "фрагмент тінекаменю (видано)",
    },
    [7070] = {
        ["Shadowshard Fragment"] = "фрагмент тінекаменю",
        ["Shadowshard Fragment (Provided)"] = "фрагмент тінекаменю (видано)",
    },
    [7081] = {
        ["Graveyard Assaulted"] = "Напад на цвинтар",
        ["Graveyard Assaulted (Provided)"] = "Напад на цвинтар (видано)",
        ["Graveyard Assaulted slain"] = "Напад на цвинтар: убито",
    },
    [7082] = {
        ["Graveyard Assaulted"] = "Напад на цвинтар",
        ["Graveyard Assaulted (Provided)"] = "Напад на цвинтар (видано)",
        ["Graveyard Assaulted slain"] = "Напад на цвинтар: убито",
    },
    [7101] = {
        ["Tower Captured"] = "Вежа захоплена",
        ["Tower Captured (Provided)"] = "Вежа захоплена (видано)",
        ["Tower Captured slain"] = "Вежа захоплена: убито",
    },
    [7102] = {
        ["Banner Destroyed"] = "Банер знищено",
    },
    [7122] = {
        ["Mine Captured"] = "Шахта захоплена",
        ["Mine Captured (Provided)"] = "Шахта захоплена (видано)",
        ["Mine Captured slain"] = "Шахта захоплена: убито",
    },
    [7124] = {
        ["Mine Captured"] = "Шахта захоплена",
        ["Mine Captured (Provided)"] = "Шахта захоплена (видано)",
        ["Mine Captured slain"] = "Шахта захоплена: убито",
    },
    [7141] = {
        ["Defeat Drek'thar."] = "Перемогти Дрек'тара.",
    },
    [7142] = {
        ["Defeat Vanndar Stormpike."] = "Перемогти Ванндара Буревісника.",
    },
    [7161] = {
        ["Frostwolf Banner"] = "знамено Морозних Вовків",
        ["Frostwolf Banner (Provided)"] = "знамено Морозних Вовків (видано)",
    },
    [7162] = {
        ["Stormpike Banner"] = "знамено Бурешпилів",
        ["Stormpike Banner (Provided)"] = "знамено Бурешпилів (видано)",
    },
    [7163] = {
        ["Frostwolf Insignia Rank 1"] = "відзнака Морозних Вовків, ранг 1",
        ["Frostwolf Insignia Rank 1 (Provided)"] = "відзнака Морозних Вовків, ранг 1 (видано)",
    },
    [7164] = {
        ["Frostwolf Insignia Rank 2"] = "відзнака Морозних Вовків, ранг 2",
        ["Frostwolf Insignia Rank 2 (Provided)"] = "відзнака Морозних Вовків, ранг 2 (видано)",
    },
    [7165] = {
        ["Frostwolf Insignia Rank 3"] = "відзнака Морозних Вовків, ранг 3",
        ["Frostwolf Insignia Rank 3 (Provided)"] = "відзнака Морозних Вовків, ранг 3 (видано)",
    },
    [7166] = {
        ["Frostwolf Insignia Rank 4"] = "відзнака Морозних Вовків, ранг 4",
        ["Frostwolf Insignia Rank 4 (Provided)"] = "відзнака Морозних Вовків, ранг 4 (видано)",
    },
    [7167] = {
        ["Frostwolf Insignia Rank 5"] = "відзнака Морозних Вовків, ранг 5",
        ["Frostwolf Insignia Rank 5 (Provided)"] = "відзнака Морозних Вовків, ранг 5 (видано)",
    },
    [7168] = {
        ["Stormpike Insignia Rank 1"] = "відзнака Бурешпилів, ранг 1",
        ["Stormpike Insignia Rank 1 (Provided)"] = "відзнака Бурешпилів, ранг 1 (видано)",
    },
    [7169] = {
        ["Stormpike Insignia Rank 2"] = "відзнака Бурешпилів, ранг 2",
        ["Stormpike Insignia Rank 2 (Provided)"] = "відзнака Бурешпилів, ранг 2 (видано)",
    },
    [7170] = {
        ["Stormpike Insignia Rank 3"] = "відзнака Бурешпилів, ранг 3",
        ["Stormpike Insignia Rank 3 (Provided)"] = "відзнака Бурешпилів, ранг 3 (видано)",
    },
    [7171] = {
        ["Stormpike Insignia Rank 4"] = "відзнака Бурешпилів, ранг 4",
        ["Stormpike Insignia Rank 4 (Provided)"] = "відзнака Бурешпилів, ранг 4 (видано)",
    },
    [7172] = {
        ["Stormpike Insignia Rank 5"] = "відзнака Бурешпилів, ранг 5",
        ["Stormpike Insignia Rank 5 (Provided)"] = "відзнака Бурешпилів, ранг 5 (видано)",
    },
    [7181] = {
        ["Korrak the Bloodrager"] = "Коррак Кроволютий",
        ["Korrak the Bloodrager slain"] = "Коррак Кроволютий: убито",
    },
    [7201] = {
        ["Essence of the Elements"] = "сутність стихій",
        ["Essence of the Elements (Provided)"] = "сутність стихій (видано)",
    },
    [7202] = {
        ["Korrak the Bloodrager"] = "Коррак Кроволютий",
        ["Korrak the Bloodrager slain"] = "Коррак Кроволютий: убито",
    },
    [7223] = {
        ["Armor Scraps"] = "уламки броні",
        ["Armor Scraps (Provided)"] = "уламки броні (видано)",
    },
    [7224] = {
        ["Armor Scraps"] = "уламки броні",
        ["Armor Scraps (Provided)"] = "уламки броні (видано)",
    },
    [7281] = {
        ["Commander Karl Philips"] = "командир Карл Філіпс",
        ["Commander Karl Philips slain"] = "командир Карл Філіпс: убито",
    },
    [7282] = {
        ["Commander Louis Philips"] = "командир Луї Філіпс",
        ["Commander Louis Philips slain"] = "командир Луї Філіпс: убито",
    },
    [7301] = {
        ["Ichman's Location Discovered"] = "Розташування Ічмана виявлено",
        ["Ichman's Location Discovered (Provided)"] = "Розташування Ічмана виявлено (видано)",
        ["Ichman's Location Discovered slain"] = "Розташування Ічмана виявлено: убито",
        ["Slidore's Location Discovered"] = "Місцезнаходження Слайдора виявлено",
        ["Slidore's Location Discovered (Provided)"] = "Місцезнаходження Слайдора виявлено (видано)",
        ["Slidore's Location Discovered slain"] = "Місцезнаходження Слайдора виявлено: убито",
        ["Vipore's Location Discovered"] = "Розташування Віпор виявлено",
        ["Vipore's Location Discovered (Provided)"] = "Розташування Віпор виявлено (видано)",
        ["Vipore's Location Discovered slain"] = "Розташування Віпор виявлено: убито",
    },
    [7302] = {
        ["Guse's Location Discovered"] = "Місцезнаходження Гусе виявлено",
        ["Guse's Location Discovered (Provided)"] = "Місцезнаходження Гусе виявлено (видано)",
        ["Guse's Location Discovered slain"] = "Місцезнаходження Гусе виявлено: убито",
        ["Jeztor's Location Discovered"] = "Розкрито місцезнаходження Джезтора",
        ["Jeztor's Location Discovered (Provided)"] = "Розкрито місцезнаходження Джезтора (видано)",
        ["Jeztor's Location Discovered slain"] = "Розкрито місцезнаходження Джезтора: убито",
        ["Mulverick's Location Discovered"] = "Розташування Малверіка виявлено",
        ["Mulverick's Location Discovered (Provided)"] = "Розташування Малверіка виявлено (видано)",
        ["Mulverick's Location Discovered slain"] = "Розташування Малверіка виявлено: убито",
    },
    [7321] = {
        ["Soothing Spices"] = "духмяні спеції",
        ["Soothing Spices (Provided)"] = "духмяні спеції (видано)",
        ["Turtle Meat"] = "черепашаче м'ясо",
        ["Turtle Meat (Provided)"] = "черепашаче м'ясо (видано)",
    },
    [7341] = {
        ["Thorium Shells"] = "торієві патрони",
        ["Thorium Shells (Provided)"] = "торієві патрони (видано)",
    },
    [7342] = {
        ["Thorium Shells"] = "торієві патрони",
        ["Thorium Shells (Provided)"] = "торієві патрони (видано)",
    },
    [7361] = {
        ["Severed Night Elf Head"] = "відрубана голова нічного ельфа",
        ["Severed Night Elf Head (Provided)"] = "відрубана голова нічного ельфа (видано)",
    },
    [7362] = {
        ["Tuft of Gnome Hair"] = "пучок волосся гнома",
        ["Tuft of Gnome Hair (Provided)"] = "пучок волосся гнома (видано)",
    },
    [7363] = {
        ["Human Bone Chip"] = "уламок людської кістки",
        ["Human Bone Chip (Provided)"] = "уламок людської кістки (видано)",
    },
    [7364] = {
        ["Tauren Hoof"] = "копито таурена",
        ["Tauren Hoof (Provided)"] = "копито таурена (видано)",
    },
    [7365] = {
        ["Darkspear Troll Mojo"] = "моджо троля Темного Списа",
        ["Darkspear Troll Mojo (Provided)"] = "моджо троля Темного Списа (видано)",
    },
    [7366] = {
        ["Forsaken Heart"] = "серце відреченого",
        ["Forsaken Heart (Provided)"] = "серце відреченого (видано)",
    },
    [7367] = {
        ["Frostwolf Explosives Expert"] = "експерт з вибухівки Морозних Вовків",
        ["Frostwolf Explosives Expert slain"] = "експерт з вибухівки Морозних Вовків: убито",
    },
    [7368] = {
        ["Stormpike Explosives Expert"] = "експерт з вибухівки Бурешпиля",
        ["Stormpike Explosives Expert slain"] = "експерт з вибухівки Бурешпиля: убито",
    },
    [7381] = {
        ["Skull of Korrak"] = "череп Коррака",
        ["Skull of Korrak (Provided)"] = "череп Коррака (видано)",
    },
    [7382] = {
        ["Skull of Korrak"] = "череп Коррака",
        ["Skull of Korrak (Provided)"] = "череп Коррака (видано)",
    },
    [7383] = {
        ["Filled Amethyst Phial"] = "наповнений аметистовий фіал",
        ["Filled Amethyst Phial (Provided)"] = "наповнений аметистовий фіал (видано)",
    },
    [7385] = {
        ["Stormpike Soldier's Blood"] = "кров солдата Бурешпиля",
        ["Stormpike Soldier's Blood (Provided)"] = "кров солдата Бурешпиля (видано)",
    },
    [7386] = {
        ["Storm Crystal"] = "кристал шторму",
        ["Storm Crystal (Provided)"] = "кристал шторму (видано)",
    },
    [7401] = {
        ["Dwarf Spine"] = "хребет дворфа",
        ["Dwarf Spine (Provided)"] = "хребет дворфа (видано)",
    },
    [7402] = {
        ["Orc Tooth"] = "зуб орка",
        ["Orc Tooth (Provided)"] = "зуб орка (видано)",
    },
    [7421] = {
        ["Severed Night Elf Head"] = "відрубана голова нічного ельфа",
        ["Severed Night Elf Head (Provided)"] = "відрубана голова нічного ельфа (видано)",
    },
    [7422] = {
        ["Tuft of Gnome Hair"] = "пучок волосся гнома",
        ["Tuft of Gnome Hair (Provided)"] = "пучок волосся гнома (видано)",
    },
    [7423] = {
        ["Human Bone Chip"] = "уламок людської кістки",
        ["Human Bone Chip (Provided)"] = "уламок людської кістки (видано)",
    },
    [7424] = {
        ["Tauren Hoof"] = "копито таурена",
        ["Tauren Hoof (Provided)"] = "копито таурена (видано)",
    },
    [7425] = {
        ["Darkspear Troll Mojo"] = "моджо троля Темного Списа",
        ["Darkspear Troll Mojo (Provided)"] = "моджо троля Темного Списа (видано)",
    },
    [7426] = {
        ["Forsaken Heart"] = "серце відреченого",
        ["Forsaken Heart (Provided)"] = "серце відреченого (видано)",
    },
    [7427] = {
        ["Dwarf Spine"] = "хребет дворфа",
        ["Dwarf Spine (Provided)"] = "хребет дворфа (видано)",
    },
    [7428] = {
        ["Orc Tooth"] = "зуб орка",
        ["Orc Tooth (Provided)"] = "зуб орка (видано)",
    },
    [7429] = {
        ["Gordok Shackle Key"] = "ключ від кайданів Ґордока",
        ["Gordok Shackle Key (Provided)"] = "ключ від кайданів Ґордока (видано)",
    },
    [7441] = {
        ["Book of Incantations"] = "книга замовлянь",
        ["Book of Incantations (Provided)"] = "книга замовлянь (видано)",
    },
    [7461] = {
        ["Immol'thar"] = "Безсмер'тер",
        ["Immol'thar slain"] = "Безсмер'тер: убито",
        ["Prince Tortheldrin"] = "принц Тортельдрін",
        ["Prince Tortheldrin slain"] = "принц Тортельдрін: убито",
    },
    [7463] = {
        ["Hydrospawn Essence"] = "сутність Гідроподоби",
        ["Hydrospawn Essence (Provided)"] = "сутність Гідроподоби (видано)",
    },
    [7481] = {
        ["Master Telmius Dreamseeker Found"] = "Знайдено майстра Тельміуса, шукача снів",
    },
    [7482] = {
        ["Master Telmius Dreamseeker Found"] = "Знайдено майстра Тельміуса, шукача снів",
    },
    [7483] = {
        ["Blood of Heroes"] = "кров героїв",
        ["Blood of Heroes (Provided)"] = "кров героїв (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
        ["Libram of Rapidity"] = "манускрипт прудкості",
        ["Libram of Rapidity (Provided)"] = "манускрипт прудкості (видано)",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Pristine Black Diamond (Provided)"] = "чистий чорний діамант (видано)",
    },
    [7484] = {
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
        ["Libram of Focus"] = "манускрипт зосередження",
        ["Libram of Focus (Provided)"] = "манускрипт зосередження (видано)",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Pristine Black Diamond (Provided)"] = "чистий чорний діамант (видано)",
        ["Skin of Shadow"] = "шкіра тіні",
        ["Skin of Shadow (Provided)"] = "шкіра тіні (видано)",
    },
    [7485] = {
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
        ["Libram of Protection"] = "манускрипт захисту",
        ["Libram of Protection (Provided)"] = "манускрипт захисту (видано)",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Pristine Black Diamond (Provided)"] = "чистий чорний діамант (видано)",
    },
    [7487] = {
        ["Core Fragment"] = "фрагмент ядра",
    },
    [7488] = {
        ["Lethtendris's Web"] = "тенета Лестендріс",
        ["Lethtendris's Web (Provided)"] = "тенета Лестендріс (видано)",
    },
    [7489] = {
        ["Lethtendris's Web"] = "тенета Лестендріс",
        ["Lethtendris's Web (Provided)"] = "тенета Лестендріс (видано)",
    },
    [7490] = {
        ["Head of Onyxia"] = "голова Оніксії",
        ["Head of Onyxia (Provided)"] = "голова Оніксії (видано)",
    },
    [7495] = {
        ["Head of Onyxia"] = "голова Оніксії",
        ["Head of Onyxia (Provided)"] = "голова Оніксії (видано)",
    },
    [7498] = {
        ["Garona: A Study on Stealth and Treachery"] = "Ґарона: дослідження непомітності та зради",
        ["Garona: A Study on Stealth and Treachery (Provided)"] = "Ґарона: дослідження непомітності та зради (видано)",
    },
    [7499] = {
        ["Codex of Defense"] = "Кодекс захисту",
        ["Codex of Defense (Provided)"] = "Кодекс захисту (видано)",
    },
    [7500] = {
        ["The Arcanist's Cookbook"] = "Кулінарна книга арканіста",
        ["The Arcanist's Cookbook (Provided)"] = "Кулінарна книга арканіста (видано)",
    },
    [7501] = {
        ["The Light and How to Swing It"] = "Світло і як ним керувати",
        ["The Light and How to Swing It (Provided)"] = "Світло і як ним керувати (видано)",
    },
    [7502] = {
        ["Harnessing Shadows"] = "Приборкання тіней",
        ["Harnessing Shadows (Provided)"] = "Приборкання тіней (видано)",
    },
    [7503] = {
        ["The Greatest Race of Hunters"] = "Найвеличніші змагання мисливців",
        ["The Greatest Race of Hunters (Provided)"] = "Найвеличніші змагання мисливців (видано)",
    },
    [7504] = {
        ["Holy Bologna: What the Light Won't Tell You"] = "Святе лицемірство: про що мовчить світло",
        ["Holy Bologna: What the Light Won't Tell You (Provided)"] = "Святе лицемірство: про що мовчить світло (видано)",
    },
    [7505] = {
        ["Frost Shock and You"] = "Крижаний шок і ви",
        ["Frost Shock and You (Provided)"] = "Крижаний шок і ви (видано)",
    },
    [7506] = {
        ["The Emerald Dream"] = "Смарагдовий Сон",
        ["The Emerald Dream (Provided)"] = "Смарагдовий Сон (видано)",
    },
    [7507] = {
        ["Foror's Compendium of Dragon Slaying"] = "Форорівський компендіум вбивства драконів",
        ["Foror's Compendium of Dragon Slaying (Provided)"] = "Форорівський компендіум вбивства драконів (видано)",
        ["Foror's Compendium of Dragon Slaying slain"] = "Форорівський компендіум вбивства драконів: убито",
    },
    [7508] = {
        ["A Dull and Flat Elven Blade"] = "тупий і плаский ельфійський клинок",
        ["A Dull and Flat Elven Blade (Provided)"] = "тупий і плаский ельфійський клинок (видано)",
    },
    [7509] = {
        ["Treated Ancient Blade"] = "загартований древній клинок",
        ["Treated Ancient Blade (Provided)"] = "загартований древній клинок (видано)",
    },
    [7563] = {
        ["Raging Beast's Blood"] = "кров лютого звіра",
        ["Raging Beast's Blood (Provided)"] = "кров лютого звіра (видано)",
    },
    [7564] = {
        ["Case of Blood"] = "скриня з кров'ю",
        ["Case of Blood (Provided)"] = "скриня з кров'ю (видано)",
    },
    [7581] = {
        ["Satyr Blood"] = "кров сатира",
        ["Satyr Blood (Provided)"] = "кров сатира (видано)",
    },
    [7582] = {
        ["Tears of the Hederine"] = "сльози Гедеріни",
        ["Tears of the Hederine (Provided)"] = "сльози Гедеріни (видано)",
    },
    [7583] = {
        ["Glowing Crystal Prison"] = "сяючий кристал ув'язнення",
        ["Glowing Crystal Prison (Provided)"] = "сяючий кристал ув'язнення (видано)",
        ["Imprisoned Doomguard"] = "ув'язнений вартовий приречення",
        ["Imprisoned Doomguard (Provided)"] = "ув'язнений вартовий приречення (видано)",
    },
    [7602] = {
        ["Flawless Fel Essence (Azshara)"] = "бездоганна есенція скверни (Азшара)",
        ["Flawless Fel Essence (Azshara) (Provided)"] = "бездоганна есенція скверни (Азшара) (видано)",
        ["Flawless Fel Essence (Dark Portal)"] = "бездоганна есенція скверни (Темний Портал)",
        ["Flawless Fel Essence (Dark Portal) (Provided)"] = "бездоганна есенція скверни (Темний Портал) (видано)",
        ["Flawless Fel Essence (Jaedenar)"] = "бездоганна есенція скверни (Джеденар)",
        ["Flawless Fel Essence (Jaedenar) (Provided)"] = "бездоганна есенція скверни (Джеденар) (видано)",
    },
    [7603] = {
        ["Kroshius"] = "Крошій",
        ["Kroshius slain"] = "Крошій: убито",
        ["Kroshius' Infernal Core"] = "ядро Крошія",
        ["Kroshius' Infernal Core (Provided)"] = "ядро Крошія (видано)",
    },
    [7604] = {
        ["Sulfuron Ingot"] = "злиток сульфурону",
        ["Sulfuron Ingot (Provided)"] = "злиток сульфурону (видано)",
        ["Thorium Brotherhood Contract"] = "договір Торієвого братства",
        ["Thorium Brotherhood Contract (Provided)"] = "договір Торієвого братства (видано)",
    },
    [7622] = {
        ["The Balance of Light and Shadow"] = "Баланс світла і тіні",
    },
    [7624] = {
        ["The Traitor's Heart"] = "серце зрадника",
        ["The Traitor's Heart (Provided)"] = "серце зрадника (видано)",
    },
    [7625] = {
        ["Xorothian Stardust"] = "зоротський зоряний пил",
        ["Xorothian Stardust (Provided)"] = "зоротський зоряний пил (видано)",
    },
    [7626] = {
        ["Elixir of Shadow Power"] = "еліксир сили тіні",
        ["Elixir of Shadow Power (Provided)"] = "еліксир сили тіні (видано)",
    },
    [7627] = {
        ["Dark Iron Ore"] = "руда темного заліза",
        ["Dark Iron Ore (Provided)"] = "руда темного заліза (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [7628] = {
        ["Black Dragonscale"] = "луска чорного дракона",
        ["Black Dragonscale (Provided)"] = "луска чорного дракона (видано)",
    },
    [7629] = {
        ["Imp in a Jar"] = "біс у банці",
        ["Imp in a Jar (Provided)"] = "біс у банці (видано)",
        ["Parchment Created"] = "Пергамент створено",
        ["Parchment Created (Provided)"] = "Пергамент створено (видано)",
        ["Parchment Created slain"] = "Пергамент створено: убито",
    },
    [7630] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
    },
    [7631] = {
        ["Xorothian Dreadsteed"] = "зоротський жахожеребець",
        ["Xorothian Dreadsteed slain"] = "зоротський жахожеребець: убито",
    },
    [7632] = {
        ["Ancient Petrified Leaf"] = "древній скам'янілий листок",
        ["Ancient Petrified Leaf (Provided)"] = "древній скам'янілий листок (видано)",
    },
    [7634] = {
        ["Mature Blue Dragon Sinew"] = "сухожилля дорослого синього дракона",
        ["Mature Blue Dragon Sinew (Provided)"] = "сухожилля дорослого синього дракона (видано)",
    },
    [7635] = {
        ["Mature Black Dragon Sinew"] = "сухожилля дорослого чорного дракона",
        ["Mature Black Dragon Sinew (Provided)"] = "сухожилля дорослого чорного дракона (видано)",
    },
    [7636] = {
        ["Artorius's Head"] = "голова Арторія",
        ["Artorius's Head (Provided)"] = "голова Арторія (видано)",
        ["Klinfran's Head"] = "голова Клінфрана",
        ["Klinfran's Head (Provided)"] = "голова Клінфрана (видано)",
        ["Simone's Head"] = "голова Симони",
        ["Simone's Head (Provided)"] = "голова Симони (видано)",
        ["Solenor's Head"] = "голова Соленора",
        ["Solenor's Head (Provided)"] = "голова Соленора (видано)",
    },
    [7637] = {
        ["Required money: 150"] = "Необхідна сума: 150",
    },
    [7639] = {
        ["Rohan's Exorcism Censer"] = "кадильниця екзорцизму Рогана",
        ["Rohan's Exorcism Censer (Provided)"] = "кадильниця екзорцизму Рогана (видано)",
    },
    [7640] = {
        ["Exorcism Censer"] = "кадильниця екзорцизму",
        ["Exorcism Censer (Provided)"] = "кадильниця екзорцизму (видано)",
        ["Terrordale Spirit"] = "дух Страходолу",
        ["Terrordale Spirit slain"] = "дух Страходолу: убито",
    },
    [7642] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Arthas' Tears"] = "сльози Артаса",
        ["Arthas' Tears (Provided)"] = "сльози Артаса (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
        ["Stratholme Holy Water (Provided)"] = "стратгольмська свята вода (видано)",
    },
    [7643] = {
        ["Arcanite Barding"] = "арканітовий бард",
        ["Arcanite Barding (Provided)"] = "арканітовий бард (видано)",
        ["Manna-Enriched Horse Feed"] = "збагачений маною корм для коней",
        ["Manna-Enriched Horse Feed (Provided)"] = "збагачений маною корм для коней (видано)",
    },
    [7644] = {
        ["Blessed Arcanite Barding"] = "благословенний арканітовий бард",
        ["Blessed Arcanite Barding (Provided)"] = "благословенний арканітовий бард (видано)",
    },
    [7645] = {
        ["Enriched Manna Biscuit"] = "збагачене маною печиво",
        ["Enriched Manna Biscuit (Provided)"] = "збагачене маною печиво (видано)",
    },
    [7646] = {
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Azerothian Diamond (Provided)"] = "азеротський діамант (видано)",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Pristine Black Diamond (Provided)"] = "чистий чорний діамант (видано)",
    },
    [7647] = {
        ["Blessed Arcanite Barding"] = "благословенний арканітовий бард",
        ["Blessed Arcanite Barding (Provided)"] = "благословенний арканітовий бард (видано)",
        ["Charger's Redeemed Soul"] = "спасенна душа коня",
        ["Charger's Redeemed Soul (Provided)"] = "спасенна душа коня (видано)",
    },
    [7648] = {
        ["Arcanite Barding"] = "арканітовий бард",
        ["Arcanite Barding (Provided)"] = "арканітовий бард (видано)",
    },
    [7649] = {
        ["Enchanted Thorium Platemail"] = "Зачаровані торієві обладунки",
        ["Enchanted Thorium Platemail (Provided)"] = "Зачаровані торієві обладунки (видано)",
    },
    [7650] = {
        ["Enchanted Thorium Platemail"] = "Зачаровані торієві обладунки",
        ["Enchanted Thorium Platemail (Provided)"] = "Зачаровані торієві обладунки (видано)",
    },
    [7651] = {
        ["Enchanted Thorium Platemail"] = "Зачаровані торієві обладунки",
        ["Enchanted Thorium Platemail (Provided)"] = "Зачаровані торієві обладунки (видано)",
    },
    [7653] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7654] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7655] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7656] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7657] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7658] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7659] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [7660] = {
        ["Horn of the Arctic Wolf"] = "ріг арктичного вовка",
        ["Horn of the Arctic Wolf (Provided)"] = "ріг арктичного вовка (видано)",
    },
    [7661] = {
        ["Horn of the Red Wolf"] = "ріг рудого вовка",
        ["Horn of the Red Wolf (Provided)"] = "ріг рудого вовка (видано)",
    },
    [7662] = {
        ["Teal Kodo"] = "бірюзовий кодо",
        ["Teal Kodo (Provided)"] = "бірюзовий кодо (видано)",
    },
    [7663] = {
        ["Green Kodo"] = "зелений кодо",
        ["Green Kodo (Provided)"] = "зелений кодо (видано)",
    },
    [7664] = {
        ["Whistle of the Ivory Raptor"] = "свисток кремового раптора",
        ["Whistle of the Ivory Raptor (Provided)"] = "свисток кремового раптора (видано)",
    },
    [7665] = {
        ["Whistle of the Mottled Red Raptor"] = "свисток строкатого червоного раптора",
        ["Whistle of the Mottled Red Raptor (Provided)"] = "свисток строкатого червоного раптора (видано)",
    },
    [7667] = {
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Azerothian Diamond (Provided)"] = "азеротський діамант (видано)",
        ["Pristine Black Diamond"] = "чистий чорний діамант",
        ["Pristine Black Diamond (Provided)"] = "чистий чорний діамант (видано)",
    },
    [7668] = {
        ["Darkreaver's Head"] = "голова Тінегубителя",
    },
    [7671] = {
        ["Reins of the Frostsaber"] = "поводи кригозуба",
        ["Reins of the Frostsaber (Provided)"] = "поводи кригозуба (видано)",
    },
    [7672] = {
        ["Reins of the Nightsaber"] = "поводи ночезуба",
        ["Reins of the Nightsaber (Provided)"] = "поводи ночезуба (видано)",
    },
    [7673] = {
        ["Frost Ram"] = "морозний баран",
        ["Frost Ram (Provided)"] = "морозний баран (видано)",
        ["Frost Ram slain"] = "морозний баран: убито",
    },
    [7674] = {
        ["Black Ram"] = "чорний баран",
        ["Black Ram (Provided)"] = "чорний баран (видано)",
        ["Black Ram slain"] = "чорний баран: убито",
    },
    [7675] = {
        ["Icy Blue Mechanostrider Mod A"] = "крижано-блакитний механобіг, модель А",
        ["Icy Blue Mechanostrider Mod A (Provided)"] = "крижано-блакитний механобіг, модель А (видано)",
        ["Icy Blue Mechanostrider Mod A slain"] = "крижано-блакитний механобіг, модель А: убито",
    },
    [7676] = {
        ["White Mechanostrider Mod A"] = "білий механобіг, модель А",
        ["White Mechanostrider Mod A (Provided)"] = "білий механобіг, модель А (видано)",
        ["White Mechanostrider Mod A slain"] = "білий механобіг, модель А: убито",
    },
    [7677] = {
        ["White Stallion Bridle"] = "вузда білого жеребця",
        ["White Stallion Bridle (Provided)"] = "вузда білого жеребця (видано)",
    },
    [7678] = {
        ["Palomino Bridle"] = "вузда солового коня",
        ["Palomino Bridle (Provided)"] = "вузда солового коня (видано)",
    },
    [7701] = {
        ["Head of Overseer Maltorius"] = "голова розпорядника Мальторія",
        ["Head of Overseer Maltorius (Provided)"] = "голова розпорядника Мальторія (видано)",
    },
    [7703] = {
        ["Gauntlet of Gordok Might"] = "рукавичка могутності Ґордока",
        ["Gauntlet of Gordok Might (Provided)"] = "рукавичка могутності Ґордока (видано)",
    },
    [7704] = {
        ["Chambermaid Pillaclencher's Pillow"] = "подушка покоївки Ніжностиск",
        ["Chambermaid Pillaclencher's Pillow (Provided)"] = "подушка покоївки Ніжностиск (видано)",
    },
    [7721] = {
        ["Water Elemental Core"] = "ядро водяного елементаля",
        ["Water Elemental Core (Provided)"] = "ядро водяного елементаля (видано)",
    },
    [7722] = {
        ["Secret Plans: Fiery Flux"] = "секретний рецепт: вогненний флюс",
        ["Secret Plans: Fiery Flux (Provided)"] = "секретний рецепт: вогненний флюс (видано)",
    },
    [7723] = {
        ["Heavy War Golem"] = "важкий бойовий голем",
        ["Heavy War Golem slain"] = "важкий бойовий голем: убито",
    },
    [7724] = {
        ["Greater Lava Spider"] = "великий лавовий павук",
        ["Greater Lava Spider slain"] = "великий лавовий павук: убито",
    },
    [7725] = {
        ["Miniaturization Residue"] = "залишок мініатюризації",
        ["Miniaturization Residue (Provided)"] = "залишок мініатюризації (видано)",
    },
    [7726] = {
        ["Water Elemental Core"] = "ядро водяного елементаля",
        ["Water Elemental Core (Provided)"] = "ядро водяного елементаля (видано)",
    },
    [7727] = {
        ["Incendosaur"] = "вогнезавр",
        ["Incendosaur slain"] = "вогнезавр: убито",
    },
    [7728] = {
        ["Lookout's Spyglass"] = "підзорна труба спостерігача",
        ["Lookout's Spyglass (Provided)"] = "підзорна труба спостерігача (видано)",
        ["Smithing Tuyere"] = "ковальська фурма",
        ["Smithing Tuyere (Provided)"] = "ковальська фурма (видано)",
    },
    [7729] = {
        ["Dark Iron Slaver"] = "поневолювач Темного Заліза",
        ["Dark Iron Slaver slain"] = "поневолювач Темного Заліза: убито",
        ["Dark Iron Taskmaster"] = "орудар Темного Заліза",
        ["Dark Iron Taskmaster slain"] = "орудар Темного Заліза: убито",
    },
    [7730] = {
        ["Zukk'ash Carapace"] = "панцир Зукк'аш",
        ["Zukk'ash Carapace (Provided)"] = "панцир Зукк'аш (видано)",
    },
    [7731] = {
        ["Stinglasher's Glands"] = "залоза Жалохвоста",
        ["Stinglasher's Glands (Provided)"] = "залоза Жалохвоста (видано)",
    },
    [7732] = {
        ["Camp Mojache Zukk'ash Report"] = "звіт про комах Зукк'аш з табору Мохаче",
        ["Camp Mojache Zukk'ash Report (Provided)"] = "звіт про комах Зукк'аш з табору Мохаче (видано)",
    },
    [7733] = {
        ["Rage Scar Yeti Hide"] = "шкура лютошрамного єті",
        ["Rage Scar Yeti Hide (Provided)"] = "шкура лютошрамного єті (видано)",
    },
    [7734] = {
        ["Rage Scar Yeti Hide"] = "шкура лютошрамного єті",
        ["Rage Scar Yeti Hide (Provided)"] = "шкура лютошрамного єті (видано)",
    },
    [7735] = {
        ["Pristine Yeti Hide"] = "бездоганна шкура єті",
        ["Pristine Yeti Hide (Provided)"] = "бездоганна шкура єті (видано)",
    },
    [7736] = {
        ["Coal"] = "вугілля",
        ["Coal (Provided)"] = "вугілля (видано)",
        ["Incendosaur Scale"] = "луска вогнезавра",
        ["Incendosaur Scale (Provided)"] = "луска вогнезавра (видано)",
        ["Kingsblood"] = "королекров",
        ["Kingsblood (Provided)"] = "королекров (видано)",
    },
    [7737] = {
        ["Dark Iron Residue"] = "ожарина темного заліза",
        ["Dark Iron Residue (Provided)"] = "ожарина темного заліза (видано)",
    },
    [7738] = {
        ["Perfect Yeti Hide"] = "ідеальна шкура єті",
        ["Perfect Yeti Hide (Provided)"] = "ідеальна шкура єті (видано)",
    },
    [7781] = {
        ["Head of Nefarian"] = "голова Нефаріана",
        ["Head of Nefarian (Provided)"] = "голова Нефаріана (видано)",
    },
    [7783] = {
        ["Head of Nefarian"] = "голова Нефаріана",
        ["Head of Nefarian (Provided)"] = "голова Нефаріана (видано)",
    },
    [7785] = {
        ["Vessel of Rebirth"] = "посудина відродження",
        ["Vessel of Rebirth (Provided)"] = "посудина відродження (видано)",
    },
    [7786] = {
        ["Bindings of the Windseeker"] = "кайдани Шукача Вітру",
        ["Bindings of the Windseeker (Provided)"] = "кайдани Шукача Вітру (видано)",
        ["Elementium Bar"] = "злиток елементію",
        ["Elementium Bar (Provided)"] = "злиток елементію (видано)",
        ["Essence of the Firelord"] = "сутність Володара Вогню",
        ["Essence of the Firelord (Provided)"] = "сутність Володара Вогню (видано)",
    },
    [7787] = {
        ["Dormant Wind Kissed Blade"] = "сплячий поцілований вітром клинок",
        ["Dormant Wind Kissed Blade (Provided)"] = "сплячий поцілований вітром клинок (видано)",
    },
    [7788] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7789] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7790] = {
        ["Defeat Warsong Mill"] = "Перемогти Млин Пісні Війни",
    },
    [7791] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7792] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7793] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7794] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7795] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7796] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7798] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7799] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7800] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7801] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7802] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7803] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7804] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7805] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7806] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7807] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7808] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7809] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7810] = {
        ["Arena Master"] = "знак майстра арени",
    },
    [7811] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7812] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7813] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7814] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7815] = {
        ["Saltwater Snapjaw"] = "морський тріскощелеп",
        ["Saltwater Snapjaw slain"] = "морський тріскощелеп: убито",
    },
    [7816] = {
        ["Katoom's Best Lure"] = "найкраща приманка Катума",
        ["Katoom's Best Lure (Provided)"] = "найкраща приманка Катума (видано)",
    },
    [7817] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7818] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7819] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7820] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7821] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7822] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7823] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7824] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7825] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7826] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7827] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7828] = {
        ["Silvermane Howler"] = "срібногривий ревун",
        ["Silvermane Howler slain"] = "срібногривий ревун: убито",
        ["Silvermane Stalker"] = "срібногривий ловець",
        ["Silvermane Stalker slain"] = "срібногривий ловець: убито",
    },
    [7829] = {
        ["Savage Owlbeast"] = "дикий совозвір",
        ["Savage Owlbeast slain"] = "дикий совозвір: убито",
    },
    [7830] = {
        ["Skylord Plume"] = "перо володаря неба",
        ["Skylord Plume (Provided)"] = "перо володаря неба (видано)",
    },
    [7831] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7832] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7833] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
    },
    [7834] = {
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [7835] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
    },
    [7836] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7837] = {
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [7838] = {
        ["Arena Master"] = "знак майстра арени",
        ["Arena Master (Provided)"] = "знак майстра арени (видано)",
    },
    [7839] = {
        ["Slagtree's Lost Tools"] = "загублені інструменти Вуглепала",
        ["Slagtree's Lost Tools (Provided)"] = "загублені інструменти Вуглепала (видано)",
    },
    [7840] = {
        ["Lard's Lunch"] = "обід Ларда",
        ["Lard's Lunch (Provided)"] = "обід Ларда (видано)",
    },
    [7841] = {
        ["Highvale Marksman"] = "високодільний стрілець",
        ["Highvale Marksman slain"] = "високодільний стрілець: убито",
        ["Highvale Outrunner"] = "високодільний вістовий",
        ["Highvale Outrunner slain"] = "високодільний вістовий: убито",
        ["Highvale Ranger"] = "високодільний слідопит",
        ["Highvale Ranger slain"] = "високодільний слідопит: убито",
        ["Highvale Scout"] = "високодільний розвідник",
        ["Highvale Scout slain"] = "високодільний розвідник: убито",
    },
    [7842] = {
        ["Long Elegant Feather"] = "довге елегантне перо",
        ["Long Elegant Feather (Provided)"] = "довге елегантне перо (видано)",
    },
    [7843] = {
        ["Message to the Wildhammer Delivered"] = "Послання до Дикого Молота доставлено",
    },
    [7844] = {
        ["Vilebranch Scalper"] = "скальпоріз Миршавого Гілля",
        ["Vilebranch Scalper slain"] = "скальпоріз Миршавого Гілля: убито",
        ["Vilebranch Soothsayer"] = "віщун Миршавого Гілля",
        ["Vilebranch Soothsayer slain"] = "віщун Миршавого Гілля: убито",
    },
    [7846] = {
        ["Shackle Key"] = "ключ від кайданів",
        ["Shackle Key (Provided)"] = "ключ від кайданів (видано)",
    },
    [7848] = {
        ["Core Fragment"] = "фрагмент ядра",
        ["Core Fragment (Provided)"] = "фрагмент ядра (видано)",
    },
    [7849] = {
        ["Huntsman Malkhor's Bones"] = "кістки мисливця Малкгора",
        ["Huntsman Malkhor's Bones (Provided)"] = "кістки мисливця Малкгора (видано)",
        ["Huntsman Malkhor's Skull"] = "череп мисливця Малкгора",
        ["Huntsman Malkhor's Skull (Provided)"] = "череп мисливця Малкгора (видано)",
    },
    [7850] = {
        ["Vessel of Tainted Blood"] = "посудина із забрудненою кров'ю",
        ["Vessel of Tainted Blood (Provided)"] = "посудина із забрудненою кров'ю (видано)",
    },
    [7861] = {
        ["Vile Priestess Hexx"] = "підступна жриця Гекс",
        ["Vile Priestess Hexx slain"] = "підступна жриця Гекс: убито",
        ["Vilebranch Aman'zasi Guard"] = "вартовий-аман'сазі Миршавого Гілля",
        ["Vilebranch Aman'zasi Guard slain"] = "вартовий-аман'сазі Миршавого Гілля: убито",
    },
    [7862] = {
        ["Vilebranch Berserker"] = "берсерк Миршавого Гілля",
        ["Vilebranch Berserker slain"] = "берсерк Миршавого Гілля: убито",
        ["Vilebranch Blood Drinker"] = "кровопивця Миршавого Гілля",
        ["Vilebranch Blood Drinker slain"] = "кровопивця Миршавого Гілля: убито",
        ["Vilebranch Shadow Hunter"] = "темний мисливець Миршавого Гілля",
        ["Vilebranch Shadow Hunter slain"] = "темний мисливець Миршавого Гілля: убито",
        ["Vilebranch Soul Eater"] = "пожирач душ Миршавого Гілля",
        ["Vilebranch Soul Eater slain"] = "пожирач душ Миршавого Гілля: убито",
    },
    [7871] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7872] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7873] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7874] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7875] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7876] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [7881] = {
        ["Embossed Leather Boots"] = "тиснені шкіряні чоботи",
        ["Embossed Leather Boots (Provided)"] = "тиснені шкіряні чоботи (видано)",
    },
    [7882] = {
        ["Toughened Leather Armor"] = "укріплений шкіряний обладунок",
        ["Toughened Leather Armor (Provided)"] = "укріплений шкіряний обладунок (видано)",
    },
    [7883] = {
        ["Barbaric Harness"] = "варварська портупея",
        ["Barbaric Harness (Provided)"] = "варварська портупея (видано)",
    },
    [7884] = {
        ["Turtle Scale Leggings"] = "поножі з черепашачої луски",
        ["Turtle Scale Leggings (Provided)"] = "поножі з черепашачої луски (видано)",
    },
    [7885] = {
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
        ["Rugged Armor Kit (Provided)"] = "накладки з міцної шкіри (видано)",
    },
    [7886] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [7887] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [7888] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [7889] = {
        ["Coarse Weightstone"] = "шорстке грузило",
        ["Coarse Weightstone (Provided)"] = "шорстке грузило (видано)",
    },
    [7890] = {
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
        ["Heavy Grinding Stone (Provided)"] = "важкий шліфувальний камінь (видано)",
    },
    [7891] = {
        ["Green Iron Bracers"] = "зелені залізні браслети",
        ["Green Iron Bracers (Provided)"] = "зелені залізні браслети (видано)",
    },
    [7892] = {
        ["Big Black Mace"] = "велика чорна булава",
        ["Big Black Mace (Provided)"] = "велика чорна булава (видано)",
    },
    [7893] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Dense Grinding Stone (Provided)"] = "масивний шліфувальний камінь (видано)",
    },
    [7894] = {
        ["Copper Modulator"] = "мідний модулятор",
        ["Copper Modulator (Provided)"] = "мідний модулятор (видано)",
    },
    [7895] = {
        ["Whirring Bronze Gizmo"] = "бронзова тріщалка",
        ["Whirring Bronze Gizmo (Provided)"] = "бронзова тріщалка (видано)",
    },
    [7896] = {
        ["Green Firework"] = "зелений феєрверк",
        ["Green Firework (Provided)"] = "зелений феєрверк (видано)",
    },
    [7897] = {
        ["Mechanical Repair Kit"] = "механічний ремкомплект",
        ["Mechanical Repair Kit (Provided)"] = "механічний ремкомплект (видано)",
    },
    [7898] = {
        ["Thorium Widget"] = "торієвий пристрій",
        ["Thorium Widget (Provided)"] = "торієвий пристрій (видано)",
    },
    [7899] = {
        ["Small Furry Paw"] = "маленька пухнаста лапка",
        ["Small Furry Paw (Provided)"] = "маленька пухнаста лапка (видано)",
    },
    [7900] = {
        ["Torn Bear Pelt"] = "рвана ведмежа шкура",
        ["Torn Bear Pelt (Provided)"] = "рвана ведмежа шкура (видано)",
    },
    [7901] = {
        ["Soft Bushy Tail"] = "м'який пухнастий хвіст",
        ["Soft Bushy Tail (Provided)"] = "м'який пухнастий хвіст (видано)",
    },
    [7902] = {
        ["Vibrant Plume"] = "яскраве перо",
        ["Vibrant Plume (Provided)"] = "яскраве перо (видано)",
    },
    [7903] = {
        ["Evil Bat Eye"] = "око злого кажана",
        ["Evil Bat Eye (Provided)"] = "око злого кажана (видано)",
    },
    [7904] = {
        ["Item #19182"] = "Товар №19182",
    },
    [7905] = {
        ["Free Ticket Voucher"] = "ваучер на призовий купон",
        ["Free Ticket Voucher (Provided)"] = "ваучер на призовий купон (видано)",
    },
    [7906] = {
        ["Beasts Deck"] = "колода звірів",
    },
    [7907] = {
        ["Beasts Deck"] = "колода звірів",
        ["Beasts Deck (Provided)"] = "колода звірів (видано)",
    },
    [7908] = {
        ["Arena Master"] = "знак майстра арени",
    },
    [7921] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [7922] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [7923] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [7924] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [7925] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [7926] = {
        ["Free Ticket Voucher"] = "ваучер на призовий купон",
        ["Free Ticket Voucher (Provided)"] = "ваучер на призовий купон (видано)",
    },
    [7927] = {
        ["Portals Deck"] = "колода порталів",
        ["Portals Deck (Provided)"] = "колода порталів (видано)",
    },
    [7928] = {
        ["Warlords Deck"] = "колода воєвод",
        ["Warlords Deck (Provided)"] = "колода воєвод (видано)",
    },
    [7929] = {
        ["Elementals Deck"] = "колода елементалів",
        ["Elementals Deck (Provided)"] = "колода елементалів (видано)",
    },
    [7930] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7931] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7932] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7933] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7934] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7935] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7936] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7937] = {
        ["Sayge's Fortune #23"] = "пророцтво Вщуна #23",
        ["Sayge's Fortune #23 (Provided)"] = "пророцтво Вщуна #23 (видано)",
    },
    [7938] = {
        ["Sayge's Fortune #24"] = "пророцтво Вщуна #24",
        ["Sayge's Fortune #24 (Provided)"] = "пророцтво Вщуна #24 (видано)",
    },
    [7939] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Dense Grinding Stone (Provided)"] = "масивний шліфувальний камінь (видано)",
    },
    [7940] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [7941] = {
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
        ["Rugged Armor Kit (Provided)"] = "накладки з міцної шкіри (видано)",
    },
    [7942] = {
        ["Thorium Widget"] = "торієвий пристрій",
        ["Thorium Widget (Provided)"] = "торієвий пристрій (видано)",
    },
    [7943] = {
        ["Evil Bat Eye"] = "око злого кажана",
        ["Evil Bat Eye (Provided)"] = "око злого кажана (видано)",
    },
    [7944] = {
        ["Sayge's Fortune #25"] = "пророцтво Вщуна #25",
        ["Sayge's Fortune #25 (Provided)"] = "пророцтво Вщуна #25 (видано)",
    },
    [7945] = {
        ["Sayge's Fortune #27"] = "пророцтво Вщуна #27",
        ["Sayge's Fortune #27 (Provided)"] = "пророцтво Вщуна #27 (видано)",
    },
    [7946] = {
        ["Dark Iron Ale Mug"] = "кухоль елю Темного Заліза",
        ["Dark Iron Ale Mug (Provided)"] = "кухоль елю Темного Заліза (видано)",
    },
    [7961] = {
        ["Polymorph Clone slain"] = "поліморфний клон: убито",
        ["The Good Rabbit slain"] = "Добрий кролик: убито",
        ["Zap a Polymorphed Chicken"] = "Збийте поліморфну курку",
    },
    [7962] = {
        ["LeCraft Rabbit Pelt"] = "кроляча шкурка ЛеКрафта",
    },
    [7981] = {
        ["Darkmoon Faire Prize Ticket"] = "призовий купон ярмарку Темного місяця",
        ["Darkmoon Faire Prize Ticket (Provided)"] = "призовий купон ярмарку Темного місяця (видано)",
    },
    [8021] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8022] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8023] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8024] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8025] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8026] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [8042] = {
        ["Strength of Mugamba"] = "сила Муґамби",
        ["Strength of Mugamba (Provided)"] = "сила Муґамби (видано)",
    },
    [8043] = {
        ["Strength of Mugamba"] = "сила Муґамби",
        ["Strength of Mugamba (Provided)"] = "сила Муґамби (видано)",
    },
    [8044] = {
        ["Strength of Mugamba"] = "сила Муґамби",
        ["Strength of Mugamba (Provided)"] = "сила Муґамби (видано)",
    },
    [8046] = {
        ["Heathen's Brand"] = "тавро язичника",
        ["Heathen's Brand (Provided)"] = "тавро язичника (видано)",
    },
    [8047] = {
        ["Heathen's Brand"] = "тавро язичника",
        ["Heathen's Brand (Provided)"] = "тавро язичника (видано)",
    },
    [8048] = {
        ["Heathen's Brand"] = "тавро язичника",
        ["Heathen's Brand (Provided)"] = "тавро язичника (видано)",
    },
    [8050] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
        ["The Eye of Zuldazar (Provided)"] = "око Зулдазара (видано)",
    },
    [8051] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
        ["The Eye of Zuldazar (Provided)"] = "око Зулдазара (видано)",
    },
    [8052] = {
        ["The Eye of Zuldazar"] = "око Зулдазара",
        ["The Eye of Zuldazar (Provided)"] = "око Зулдазара (видано)",
    },
    [8053] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
        ["Primal Hakkari Bindings (Provided)"] = "первісні браслети Гаккарі (видано)",
    },
    [8054] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
        ["Primal Hakkari Shawl (Provided)"] = "первісна шаль Гаккарі (видано)",
    },
    [8055] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
        ["Primal Hakkari Tabard (Provided)"] = "первісна накидка Гаккарі (видано)",
    },
    [8056] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
        ["Primal Hakkari Armsplint (Provided)"] = "первісний наруч Гаккарі (видано)",
    },
    [8057] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
        ["Primal Hakkari Stanchion (Provided)"] = "первісний поруч Гаккарі (видано)",
    },
    [8058] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
        ["Primal Hakkari Armsplint (Provided)"] = "первісний наруч Гаккарі (видано)",
    },
    [8059] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
        ["Primal Hakkari Stanchion (Provided)"] = "первісний поруч Гаккарі (видано)",
    },
    [8060] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
        ["Primal Hakkari Bindings (Provided)"] = "первісні браслети Гаккарі (видано)",
    },
    [8061] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Stanchion"] = "первісний поруч Гаккарі",
        ["Primal Hakkari Stanchion (Provided)"] = "первісний поруч Гаккарі (видано)",
    },
    [8062] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
        ["Primal Hakkari Bindings (Provided)"] = "первісні браслети Гаккарі (видано)",
    },
    [8063] = {
        ["3000 reputation with Zandalar Tribe"] = "3000 репутації у племені Зандалар",
        ["Primal Hakkari Armsplint"] = "первісний наруч Гаккарі",
        ["Primal Hakkari Armsplint (Provided)"] = "первісний наруч Гаккарі (видано)",
    },
    [8064] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
        ["Primal Hakkari Sash (Provided)"] = "первісний пояс Гаккарі (видано)",
    },
    [8065] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
        ["Primal Hakkari Tabard (Provided)"] = "первісна накидка Гаккарі (видано)",
    },
    [8066] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
        ["Primal Hakkari Shawl (Provided)"] = "первісна шаль Гаккарі (видано)",
    },
    [8067] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
        ["Primal Hakkari Aegis (Provided)"] = "первісна егіда Гаккарі (видано)",
    },
    [8068] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Shawl"] = "первісна шаль Гаккарі",
        ["Primal Hakkari Shawl (Provided)"] = "первісна шаль Гаккарі (видано)",
    },
    [8069] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
        ["Primal Hakkari Kossack (Provided)"] = "первісний каптан Гаккарі (видано)",
    },
    [8070] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
        ["Primal Hakkari Sash (Provided)"] = "первісний пояс Гаккарі (видано)",
    },
    [8071] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
        ["Primal Hakkari Aegis (Provided)"] = "первісна егіда Гаккарі (видано)",
    },
    [8072] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
        ["Primal Hakkari Girdle (Provided)"] = "первісний пасок Гаккарі (видано)",
    },
    [8073] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Aegis"] = "первісна егіда Гаккарі",
        ["Primal Hakkari Aegis (Provided)"] = "первісна егіда Гаккарі (видано)",
    },
    [8074] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
        ["Primal Hakkari Girdle (Provided)"] = "первісний пасок Гаккарі (видано)",
    },
    [8075] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Tabard"] = "первісна накидка Гаккарі",
        ["Primal Hakkari Tabard (Provided)"] = "первісна накидка Гаккарі (видано)",
    },
    [8076] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Sash"] = "первісний пояс Гаккарі",
        ["Primal Hakkari Sash (Provided)"] = "первісний пояс Гаккарі (видано)",
    },
    [8077] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
        ["Primal Hakkari Kossack (Provided)"] = "первісний каптан Гаккарі (видано)",
    },
    [8078] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Primal Hakkari Girdle"] = "первісний пасок Гаккарі",
        ["Primal Hakkari Girdle (Provided)"] = "первісний пасок Гаккарі (видано)",
    },
    [8079] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Primal Hakkari Kossack"] = "первісний каптан Гаккарі",
        ["Primal Hakkari Kossack (Provided)"] = "первісний каптан Гаккарі (видано)",
    },
    [8080] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8081] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8102] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
        ["Pebble of Kajaro (Provided)"] = "камінчик Каджаро (видано)",
    },
    [8103] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
        ["Pebble of Kajaro (Provided)"] = "камінчик Каджаро (видано)",
    },
    [8104] = {
        ["Pebble of Kajaro"] = "камінчик Каджаро",
        ["Pebble of Kajaro (Provided)"] = "камінчик Каджаро (видано)",
    },
    [8105] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Farm Assaulted"] = "Напад на ферму",
        ["Farm Assaulted (Provided)"] = "Напад на ферму (видано)",
        ["Farm Assaulted slain"] = "Напад на ферму: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
    },
    [8107] = {
        ["Kezan's Taint"] = "пошесть Кезана",
        ["Kezan's Taint (Provided)"] = "пошесть Кезана (видано)",
    },
    [8108] = {
        ["Kezan's Taint"] = "пошесть Кезана",
        ["Kezan's Taint (Provided)"] = "пошесть Кезана (видано)",
    },
    [8109] = {
        ["Kezan's Taint"] = "пошесть Кезана",
        ["Kezan's Taint (Provided)"] = "пошесть Кезана (видано)",
    },
    [8111] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
        ["Enchanted South Seas Kelp (Provided)"] = "зачаровані водорості Південних морів (видано)",
    },
    [8112] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
        ["Enchanted South Seas Kelp (Provided)"] = "зачаровані водорості Південних морів (видано)",
    },
    [8113] = {
        ["Enchanted South Seas Kelp"] = "зачаровані водорості Південних морів",
        ["Enchanted South Seas Kelp (Provided)"] = "зачаровані водорості Південних морів (видано)",
    },
    [8114] = {
        ["Control Four Bases."] = "Контролюйте чотири бази.",
    },
    [8115] = {
        ["Take Five Bases."] = "Візьміть п'ять баз.",
    },
    [8117] = {
        ["Vision of Voodress"] = "видіння Вудрії",
        ["Vision of Voodress (Provided)"] = "видіння Вудрії (видано)",
    },
    [8118] = {
        ["Vision of Voodress"] = "видіння Вудрії",
        ["Vision of Voodress (Provided)"] = "видіння Вудрії (видано)",
    },
    [8119] = {
        ["Vision of Voodress"] = "видіння Вудрії",
        ["Vision of Voodress (Provided)"] = "видіння Вудрії (видано)",
    },
    [8120] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
        ["Stable Assaulted"] = "Стайня піддалася нападу",
        ["Stable Assaulted (Provided)"] = "Стайня піддалася нападу (видано)",
        ["Stable Assaulted slain"] = "Стайня піддалася нападу: убито",
    },
    [8121] = {
        ["Hold Four Bases."] = "Утримуйте чотири бази.",
    },
    [8122] = {
        ["Hold Five Bases."] = "Утримуйте п'ять баз.",
    },
    [8123] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8124] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8142] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
        ["Zandalarian Shadow Talisman (Provided)"] = "зандаларський талісман тіні (видано)",
    },
    [8143] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
        ["Zandalarian Shadow Talisman (Provided)"] = "зандаларський талісман тіні (видано)",
    },
    [8144] = {
        ["Zandalarian Shadow Talisman"] = "зандаларський талісман тіні",
        ["Zandalarian Shadow Talisman (Provided)"] = "зандаларський талісман тіні (видано)",
    },
    [8146] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
        ["Maelstrom's Tendril (Provided)"] = "вус Водоверті (видано)",
    },
    [8147] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
        ["Maelstrom's Tendril (Provided)"] = "вус Водоверті (видано)",
    },
    [8148] = {
        ["Maelstrom's Tendril"] = "вус Водоверті",
        ["Maelstrom's Tendril (Provided)"] = "вус Водоверті (видано)",
    },
    [8149] = {
        ["Uther's Tribute"] = "підношення Утеру",
    },
    [8150] = {
        ["Grom's Tribute"] = "підношення Ґрому",
    },
    [8153] = {
        ["Perfect Courser Antler"] = "ідеальні роги самця оленя",
        ["Perfect Courser Antler (Provided)"] = "ідеальні роги самця оленя (видано)",
    },
    [8154] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8155] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8156] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8157] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8158] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8159] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8160] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8161] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8162] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8163] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8164] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8165] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8166] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Farm Assaulted"] = "Напад на ферму",
        ["Farm Assaulted (Provided)"] = "Напад на ферму (видано)",
        ["Farm Assaulted slain"] = "Напад на ферму: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
    },
    [8167] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Farm Assaulted"] = "Напад на ферму",
        ["Farm Assaulted (Provided)"] = "Напад на ферму (видано)",
        ["Farm Assaulted slain"] = "Напад на ферму: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
    },
    [8168] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Farm Assaulted"] = "Напад на ферму",
        ["Farm Assaulted (Provided)"] = "Напад на ферму (видано)",
        ["Farm Assaulted slain"] = "Напад на ферму: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
    },
    [8169] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
        ["Stable Assaulted"] = "Стайня піддалася нападу",
        ["Stable Assaulted (Provided)"] = "Стайня піддалася нападу (видано)",
        ["Stable Assaulted slain"] = "Стайня піддалася нападу: убито",
    },
    [8170] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
        ["Stable Assaulted"] = "Стайня піддалася нападу",
        ["Stable Assaulted (Provided)"] = "Стайня піддалася нападу (видано)",
        ["Stable Assaulted slain"] = "Стайня піддалася нападу: убито",
    },
    [8171] = {
        ["Blacksmith Assaulted"] = "Напад на коваля",
        ["Blacksmith Assaulted (Provided)"] = "Напад на коваля (видано)",
        ["Blacksmith Assaulted slain"] = "Напад на коваля: убито",
        ["Lumber Mill Assaulted"] = "Напад на лісопильний завод",
        ["Lumber Mill Assaulted (Provided)"] = "Напад на лісопильний завод (видано)",
        ["Lumber Mill Assaulted slain"] = "Напад на лісопильний завод: убито",
        ["Mine Assaulted"] = "Шахта піддана нападу",
        ["Mine Assaulted (Provided)"] = "Шахта піддана нападу (видано)",
        ["Mine Assaulted slain"] = "Шахта піддана нападу: убито",
        ["Stable Assaulted"] = "Стайня піддалася нападу",
        ["Stable Assaulted (Provided)"] = "Стайня піддалася нападу (видано)",
        ["Stable Assaulted slain"] = "Стайня піддалася нападу: убито",
    },
    [8183] = {
        ["Heart of Hakkar"] = "серце Гаккара",
        ["Heart of Hakkar (Provided)"] = "серце Гаккара (видано)",
    },
    [8184] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8185] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8186] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8187] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8188] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8189] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8190] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8191] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8192] = {
        ["Primal Hakkari Idol"] = "первісний ідол Гаккарі",
        ["Primal Hakkari Idol (Provided)"] = "первісний ідол Гаккарі (видано)",
        ["Punctured Voodoo Doll"] = "проколота лялька вуду",
        ["Punctured Voodoo Doll (Provided)"] = "проколота лялька вуду (видано)",
    },
    [8193] = {
        ["Speckled Tastyfish"] = "плямиста смачнориба",
        ["Speckled Tastyfish (Provided)"] = "плямиста смачнориба (видано)",
    },
    [8194] = {
        ["Speckled Tastyfish"] = "плямиста смачнориба",
        ["Speckled Tastyfish (Provided)"] = "плямиста смачнориба (видано)",
    },
    [8195] = {
        ["Hakkari Coin"] = "монета Гаккарі",
        ["Hakkari Coin (Provided)"] = "монета Гаккарі (видано)",
        ["Razzashi Coin"] = "монета Раззаші",
        ["Razzashi Coin (Provided)"] = "монета Раззаші (видано)",
        ["Zulian Coin"] = "монета Зуліан",
        ["Zulian Coin (Provided)"] = "монета Зуліан (видано)",
    },
    [8196] = {
        ["9000 reputation with Zandalar Tribe"] = "9000 репутації у племені Зандалар",
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
        ["Zandalar Honor Token (Provided)"] = "знак пошани Зандаларів (видано)",
    },
    [8201] = {
        ["Gurubashi Head Collection"] = "колекція голів Ґурубаші",
        ["Gurubashi Head Collection (Provided)"] = "колекція голів Ґурубаші (видано)",
    },
    [8221] = {
        ["Keefer's Angelfish"] = "риба-ангел Кіфера",
        ["Keefer's Angelfish (Provided)"] = "риба-ангел Кіфера (видано)",
    },
    [8222] = {
        ["Glowing Scorpid Blood"] = "сяюча кров скорпіда",
        ["Glowing Scorpid Blood (Provided)"] = "сяюча кров скорпіда (видано)",
    },
    [8223] = {
        ["Glowing Scorpid Blood"] = "сяюча кров скорпіда",
        ["Glowing Scorpid Blood (Provided)"] = "сяюча кров скорпіда (видано)",
    },
    [8224] = {
        ["Dezian Queenfish"] = "дезійська ставрида",
        ["Dezian Queenfish (Provided)"] = "дезійська ставрида (видано)",
    },
    [8225] = {
        ["Brownell's Blue Striped Racer"] = "синій смугастик Браунелла",
        ["Brownell's Blue Striped Racer (Provided)"] = "синій смугастик Браунелла (видано)",
    },
    [8227] = {
        ["Nat's Measuring Tape"] = "вимірювальна стрічка Нета",
        ["Nat's Measuring Tape (Provided)"] = "вимірювальна стрічка Нета (видано)",
    },
    [8231] = {
        ["Wavethrasher Scales"] = "луска хвилешльопа",
        ["Wavethrasher Scales (Provided)"] = "луска хвилешльопа (видано)",
    },
    [8232] = {
        ["Tooth of Morphaz"] = "зуб Морфаза",
        ["Tooth of Morphaz (Provided)"] = "зуб Морфаза (видано)",
    },
    [8234] = {
        ["Sealed Azure Bag"] = "запечатана лазурна сумка",
        ["Sealed Azure Bag (Provided)"] = "запечатана лазурна сумка (видано)",
    },
    [8235] = {
        ["Encoded Fragment"] = "зашифрований фрагмент",
        ["Encoded Fragment (Provided)"] = "зашифрований фрагмент (видано)",
    },
    [8236] = {
        ["Azure Key"] = "лазурний ключ",
        ["Azure Key (Provided)"] = "лазурний ключ (видано)",
    },
    [8238] = {
        ["Gurubashi Coin"] = "монета Ґурубаші",
        ["Gurubashi Coin (Provided)"] = "монета Ґурубаші (видано)",
        ["Vilebranch Coin"] = "монета Миршавого Гілля",
        ["Vilebranch Coin (Provided)"] = "монета Миршавого Гілля (видано)",
        ["Witherbark Coin"] = "монета Зів'ялої Кори",
        ["Witherbark Coin (Provided)"] = "монета Зів'ялої Кори (видано)",
    },
    [8239] = {
        ["Bloodscalp Coin"] = "монета Кровоскальпих",
        ["Bloodscalp Coin (Provided)"] = "монета Кровоскальпих (видано)",
        ["Sandfury Coin"] = "монета Піщанолютих",
        ["Sandfury Coin (Provided)"] = "монета Піщанолютих (видано)",
        ["Skullsplitter Coin"] = "монета Черепотрощителів",
        ["Skullsplitter Coin (Provided)"] = "монета Черепотрощителів (видано)",
    },
    [8241] = {
        ["Coal"] = "вугілля",
        ["Coal (Provided)"] = "вугілля (видано)",
        ["Incendosaur Scale"] = "луска вогнезавра",
        ["Incendosaur Scale (Provided)"] = "луска вогнезавра (видано)",
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
    },
    [8242] = {
        ["Coal"] = "вугілля",
        ["Coal (Provided)"] = "вугілля (видано)",
        ["Heavy Leather"] = "важка шкіра",
        ["Heavy Leather (Provided)"] = "важка шкіра (видано)",
        ["Incendosaur Scale"] = "луска вогнезавра",
        ["Incendosaur Scale (Provided)"] = "луска вогнезавра (видано)",
    },
    [8243] = {
        ["21000 reputation with Zandalar Tribe"] = "21000 репутації у племені Зандалар",
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
        ["Zandalar Honor Token (Provided)"] = "знак пошани Зандаларів (видано)",
    },
    [8246] = {
        ["42000 reputation with Zandalar Tribe"] = "42000 репутації у племені Зандалар",
        ["Zandalar Honor Token"] = "знак пошани Зандаларів",
        ["Zandalar Honor Token (Provided)"] = "знак пошани Зандаларів (видано)",
    },
    [8249] = {
        ["Heavy Junkbox"] = "важка скринька",
        ["Heavy Junkbox (Provided)"] = "важка скринька (видано)",
    },
    [8251] = {
        ["Glittering Dust"] = "блискучий пил",
        ["Glittering Dust (Provided)"] = "блискучий пил (видано)",
    },
    [8252] = {
        ["Enchanted Coral"] = "зачарований корал",
        ["Enchanted Coral (Provided)"] = "зачарований корал (видано)",
    },
    [8253] = {
        ["Arcane Shard"] = "арканічний уламок",
        ["Arcane Shard (Provided)"] = "арканічний уламок (видано)",
    },
    [8255] = {
        ["Healthy Courser Gland"] = "залоза здорового оленя",
        ["Healthy Courser Gland (Provided)"] = "залоза здорового оленя (видано)",
    },
    [8256] = {
        ["Ichor of Undeath"] = "пасока невмерлих",
        ["Ichor of Undeath (Provided)"] = "пасока невмерлих (видано)",
    },
    [8257] = {
        ["Blood of Morphaz"] = "кров Морфаза",
        ["Blood of Morphaz (Provided)"] = "кров Морфаза (видано)",
    },
    [8258] = {
        ["Darkreaver's Head"] = "голова Тінегубителя",
        ["Darkreaver's Head (Provided)"] = "голова Тінегубителя (видано)",
    },
    [8260] = {
        ["The League of Arathor"] = "Ліга Аратора",
    },
    [8261] = {
        ["The League of Arathor"] = "Ліга Аратора",
    },
    [8263] = {
        ["The Defilers"] = "Осквернителі",
    },
    [8264] = {
        ["The Defilers"] = "Осквернителі",
    },
    [8265] = {
        ["The Defilers"] = "Осквернителі",
    },
    [8266] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8267] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8268] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8269] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8274] = {
        ["Murloc Coastrunner slain"] = "мурлок-берегобігун: убито",
    },
    [8277] = {
        ["Sand Skitterer Fang"] = "ікло піщаного швидколапа",
        ["Sand Skitterer Fang (Provided)"] = "ікло піщаного швидколапа (видано)",
        ["Stonelash Scorpid Stinger"] = "жало камнехвостого скорпіда",
        ["Stonelash Scorpid Stinger (Provided)"] = "жало камнехвостого скорпіда (видано)",
    },
    [8278] = {
        ["Rock Stalker Fang"] = "ікло скельного ловця",
        ["Rock Stalker Fang (Provided)"] = "ікло скельного ловця (видано)",
        ["Stonelash Flayer Stinger"] = "жало камнехвостого потрошителя",
        ["Stonelash Flayer Stinger (Provided)"] = "жало камнехвостого потрошителя (видано)",
        ["Stonelash Pincer Stinger"] = "жало камнехвостого щипача",
        ["Stonelash Pincer Stinger (Provided)"] = "жало камнехвостого щипача (видано)",
    },
    [8279] = {
        ["Twilight Lexicon - Chapter 1"] = "Сутінковий словник - розділ 1",
        ["Twilight Lexicon - Chapter 1 (Provided)"] = "Сутінковий словник - розділ 1 (видано)",
        ["Twilight Lexicon - Chapter 2"] = "Сутінковий словник - розділ 2",
        ["Twilight Lexicon - Chapter 2 (Provided)"] = "Сутінковий словник - розділ 2 (видано)",
        ["Twilight Lexicon - Chapter 3"] = "Сутінковий словник - розділ 3",
        ["Twilight Lexicon - Chapter 3 (Provided)"] = "Сутінковий словник - розділ 3 (видано)",
    },
    [8280] = {
        ["Dredge Striker"] = "землечерп",
        ["Dredge Striker slain"] = "землечерп: убито",
    },
    [8281] = {
        ["Dredge Crusher"] = "землечерп-дробар",
        ["Dredge Crusher slain"] = "землечерп-дробар: убито",
    },
    [8282] = {
        ["Noggle's Satchel"] = "рюкзак Ноґґла",
        ["Noggle's Satchel (Provided)"] = "рюкзак Ноґґла (видано)",
    },
    [8283] = {
        ["Deathclasp's Pincer"] = "клешня Смертехвата",
        ["Deathclasp's Pincer (Provided)"] = "клешня Смертехвата (видано)",
    },
    [8284] = {
        ["Twilight Tablet Fragment"] = "фрагмент сутінкової скрижалі",
        ["Twilight Tablet Fragment (Provided)"] = "фрагмент сутінкової скрижалі (видано)",
    },
    [8285] = {
        ["Restored Twilight Tablet"] = "відновлена сутінкова скрижаль",
        ["Restored Twilight Tablet (Provided)"] = "відновлена сутінкова скрижаль (видано)",
    },
    [8286] = {
        ["Discover the Brood of Nozdormu."] = "Відкрийте для себе Виводок Ноздорму.",
        ["Explore Zone"] = "Дослідіть місцевість",
    },
    [8287] = {
        ["Decoded Tablet Transcription"] = "розшифрований текст скрижалі",
        ["Decoded Tablet Transcription (Provided)"] = "розшифрований текст скрижалі (видано)",
    },
    [8288] = {
        ["Head of the Broodlord Lashlayer"] = "голова володаря роду Хлиста Бича",
        ["Head of the Broodlord Lashlayer (Provided)"] = "голова володаря роду Хлиста Бича (видано)",
    },
    [8289] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [8290] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8291] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8292] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [8293] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [8294] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8295] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8296] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [8297] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8298] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8299] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8300] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8301] = {
        ["Silithid Carapace Fragment"] = "фрагмент панцира силітида",
        ["Silithid Carapace Fragment (Provided)"] = "фрагмент панцира силітида (видано)",
    },
    [8302] = {
        ["Silithid Carapace Fragment"] = "фрагмент панцира силітида",
        ["Silithid Carapace Fragment (Provided)"] = "фрагмент панцира силітида (видано)",
    },
    [8303] = {
        ["The War of the Shifting Sands"] = "Війна Мінливих Пісків",
    },
    [8304] = {
        ["Frankal Questioned"] = "Франкала допитали",
        ["Frankal Questioned (Provided)"] = "Франкала допитали (видано)",
        ["Frankal Questioned slain"] = "Франкала допитали: убито",
        ["Rutgar Questioned"] = "Рутгара допитали",
        ["Rutgar Questioned (Provided)"] = "Рутгара допитали (видано)",
        ["Rutgar Questioned slain"] = "Рутгара допитали: убито",
    },
    [8306] = {
        ["The Fate of Mistress Natalia Mar'alith"] = "Доля пані Наталії Мар'аліт",
        ["The Fate of Mistress Natalia Mar'alith (Provided)"] = "Доля пані Наталії Мар'аліт (видано)",
        ["The Fate of Mistress Natalia Mar'alith slain"] = "Доля пані Наталії Мар'аліт: убито",
    },
    [8308] = {
        ["Brann Bronzebeard's Lost Letter"] = "загублений лист Бранна Бронзобородого",
        ["Brann Bronzebeard's Lost Letter (Provided)"] = "загублений лист Бранна Бронзобородого (видано)",
    },
    [8309] = {
        ["Geologist's Transcription Kit"] = "копіювальний набір геолога",
        ["Geologist's Transcription Kit (Provided)"] = "копіювальний набір геолога (видано)",
        ["Hive'Ashi Rubbing"] = "відтиск кристала Вул'Аші",
        ["Hive'Ashi Rubbing (Provided)"] = "відтиск кристала Вул'Аші (видано)",
        ["Hive'Regal Rubbing"] = "відтиск кристала Вул'Регаля",
        ["Hive'Regal Rubbing (Provided)"] = "відтиск кристала Вул'Регаля (видано)",
        ["Hive'Zora Rubbing"] = "відтиск кристала Вул'Зори",
        ["Hive'Zora Rubbing (Provided)"] = "відтиск кристала Вул'Зори (видано)",
    },
    [8310] = {
        ["Hive'Ashi Silithid Brain"] = "мозок силітида Вул'Аші",
        ["Hive'Ashi Silithid Brain (Provided)"] = "мозок силітида Вул'Аші (видано)",
        ["Hive'Regal Silithid Brain"] = "мозок силітида Вул'Регаля",
        ["Hive'Regal Silithid Brain (Provided)"] = "мозок силітида Вул'Регаля (видано)",
        ["Hive'Zora Silithid Brain"] = "мозок силітида Вул'Зори",
        ["Hive'Zora Silithid Brain (Provided)"] = "мозок силітида Вул'Зори (видано)",
    },
    [8311] = {
        ["Darnassus Marzipan"] = "марципан Дарнасу",
        ["Darnassus Marzipan (Provided)"] = "марципан Дарнасу (видано)",
        ["Gnomeregan Gumdrop"] = "мармелад Гномреґана",
        ["Gnomeregan Gumdrop (Provided)"] = "мармелад Гномреґана (видано)",
        ["Ironforge Mint"] = "м'ятна цукерка Залізогарта",
        ["Ironforge Mint (Provided)"] = "м'ятна цукерка Залізогарта (видано)",
        ["Stormwind Nougat"] = "нуга Штормовію",
        ["Stormwind Nougat (Provided)"] = "нуга Штормовію (видано)",
    },
    [8312] = {
        ["Darkspear Gumdrop"] = "мармелад Темного Списа",
        ["Darkspear Gumdrop (Provided)"] = "мармелад Темного Списа (видано)",
        ["Orgrimmar Nougat"] = "нуга Орґріммара",
        ["Orgrimmar Nougat (Provided)"] = "нуга Орґріммара (видано)",
        ["Thunder Bluff Marzipan"] = "марципан Громового Бескиду",
        ["Thunder Bluff Marzipan (Provided)"] = "марципан Громового Бескиду (видано)",
        ["Undercity Mint"] = "м'ятна цукерка Підмістя",
        ["Undercity Mint (Provided)"] = "м'ятна цукерка Підмістя (видано)",
    },
    [8313] = {
        ["Torn Recipe Page"] = "вирвана сторінка з рецептом",
        ["Torn Recipe Page (Provided)"] = "вирвана сторінка з рецептом (видано)",
    },
    [8314] = {
        ["Glyphed Crystal Prism"] = "вкрита гліфами кристалічна призма",
        ["Glyphed Crystal Prism (Provided)"] = "вкрита гліфами кристалічна призма (видано)",
    },
    [8315] = {
        ["Crystal Unlocking Mechanism"] = "механізм відкривання кристалів",
        ["Crystal Unlocking Mechanism (Provided)"] = "механізм відкривання кристалів (видано)",
    },
    [8317] = {
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
        ["Smoked Desert Dumplings (Provided)"] = "копчені пустельні пельмені (видано)",
    },
    [8318] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
        ["Encrypted Twilight Text (Provided)"] = "зашифрований текст Сутінкового Молота (видано)",
    },
    [8319] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
        ["Encrypted Twilight Text (Provided)"] = "зашифрований текст Сутінкового Молота (видано)",
    },
    [8320] = {
        ["Twilight Geolord"] = "сутінковий геолорд",
        ["Twilight Geolord slain"] = "сутінковий геолорд: убито",
    },
    [8321] = {
        ["Vyral's Signet Ring"] = "перстень-печатка Вірала",
        ["Vyral's Signet Ring (Provided)"] = "перстень-печатка Вірала (видано)",
    },
    [8322] = {
        ["Rotten Eggs"] = "зіпсовані яйця",
        ["Rotten Eggs (Provided)"] = "зіпсовані яйця (видано)",
    },
    [8323] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
        ["Encrypted Twilight Text (Provided)"] = "зашифрований текст Сутінкового Молота (видано)",
    },
    [8324] = {
        ["Encrypted Twilight Text"] = "зашифрований текст Сутінкового Молота",
        ["Encrypted Twilight Text (Provided)"] = "зашифрований текст Сутінкового Молота (видано)",
    },
    [8332] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Abyssal Crest (Provided)"] = "талісман безодні (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [8333] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Abyssal Crest (Provided)"] = "талісман безодні (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [8341] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Abyssal Signet (Provided)"] = "перстень безодні (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [8342] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Abyssal Signet (Provided)"] = "перстень безодні (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [8348] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Abyssal Signet (Provided)"] = "перстень безодні (видано)",
    },
    [8352] = {
        ["Abyssal Scepter"] = "скіпетр безодні",
        ["Abyssal Scepter (Provided)"] = "скіпетр безодні (видано)",
    },
    [8353] = {
        ["Cluck like a chicken for Innkeeper Firebrew"] = "Кудакни, як курка, для вогняного пива шинкаря",
    },
    [8354] = {
        ["Cluck like a chicken for Innkeeper Norman"] = "Кудакни, як курка, для шинкаря Нормана",
    },
    [8355] = {
        ["Do the \"train\" for Talvash"] = "Здійсніть \"поїзд\" до Талваша",
    },
    [8356] = {
        ["Flex for Innkeeper Allison"] = "Гнучкий для шинкарки Еллісон",
    },
    [8357] = {
        ["Dance for Innkeeper Saelienne"] = "Танець для шинкарки Саеліенн",
    },
    [8358] = {
        ["Do the \"train\" for Kali Remik"] = "Зробіть \"поїзд\" для Калі Ремік",
    },
    [8359] = {
        ["Flex for Innkeeper Gryshka"] = "Флекс для шинкаря Гришки",
    },
    [8360] = {
        ["Dance for Innkeeper Pala"] = "Танець для шинкаря Пали",
    },
    [8361] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Abyssal Crest (Provided)"] = "талісман безодні (видано)",
    },
    [8362] = {
        ["Abyssal Crest"] = "талісман безодні",
        ["Abyssal Crest (Provided)"] = "талісман безодні (видано)",
    },
    [8363] = {
        ["Abyssal Signet"] = "перстень безодні",
        ["Abyssal Signet (Provided)"] = "перстень безодні (видано)",
    },
    [8364] = {
        ["Abyssal Scepter"] = "скіпетр безодні",
        ["Abyssal Scepter (Provided)"] = "скіпетр безодні (видано)",
    },
    [8365] = {
        ["Southsea Pirate Hat"] = "капелюх пірата Південних морів",
        ["Southsea Pirate Hat (Provided)"] = "капелюх пірата Південних морів (видано)",
    },
    [8366] = {
        ["Southsea Dock Worker"] = "портовий робітник Південних морів",
        ["Southsea Dock Worker slain"] = "портовий робітник Південних морів: убито",
        ["Southsea Freebooter"] = "флібустьєр Південних морів",
        ["Southsea Freebooter slain"] = "флібустьєр Південних морів: убито",
        ["Southsea Pirate"] = "пірат Південних морів",
        ["Southsea Pirate slain"] = "пірат Південних морів: убито",
        ["Southsea Swashbuckler"] = "шибайголова Південних морів",
        ["Southsea Swashbuckler slain"] = "шибайголова Південних морів: убито",
    },
    [8367] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8368] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8369] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
    },
    [8370] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8371] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8372] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8373] = {
        ["Clean up a stink bomb that's been dropped on Southshore!"] = "Приберіть смердючу бомбу, яку скинули на Саутберег!",
    },
    [8374] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8375] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
    },
    [8383] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
    },
    [8384] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8385] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8386] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8387] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
    },
    [8388] = {
        ["Alterac Valley Mark of Honor"] = "відзнака честі Альтерацької долини",
        ["Alterac Valley Mark of Honor (Provided)"] = "відзнака честі Альтерацької долини (видано)",
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8389] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8390] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8391] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8392] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8393] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8394] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8395] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8396] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8397] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8398] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8399] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8400] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8401] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8402] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8403] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8404] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8405] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8406] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8407] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8408] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8410] = {
        ["Elemental Air"] = "первородне повітря",
        ["Elemental Air (Provided)"] = "первородне повітря (видано)",
        ["Elemental Earth"] = "первородна земля",
        ["Elemental Earth (Provided)"] = "первородна земля (видано)",
        ["Elemental Fire"] = "первородний вогонь",
        ["Elemental Fire (Provided)"] = "первородний вогонь (видано)",
        ["Elemental Water"] = "первородна вода",
        ["Elemental Water (Provided)"] = "первородна вода (видано)",
    },
    [8411] = {
        ["Elemental Air"] = "первородне повітря",
        ["Elemental Air (Provided)"] = "первородне повітря (видано)",
        ["Elemental Earth"] = "первородна земля",
        ["Elemental Earth (Provided)"] = "первородна земля (видано)",
        ["Elemental Fire"] = "первородний вогонь",
        ["Elemental Fire (Provided)"] = "первородний вогонь (видано)",
        ["Elemental Water"] = "первородна вода",
        ["Elemental Water (Provided)"] = "первородна вода (видано)",
    },
    [8412] = {
        ["Bloodshot Spider Eye"] = "налите кров'ю павуче око",
        ["Bloodshot Spider Eye (Provided)"] = "налите кров'ю павуче око (видано)",
        ["Thick Black Claw"] = "товстий чорний кіготь",
        ["Thick Black Claw (Provided)"] = "товстий чорний кіготь (видано)",
    },
    [8413] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Amber Voodoo Feather (Provided)"] = "бурштинове пір'я вуду (видано)",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Blue Voodoo Feather (Provided)"] = "блакитне пір'я вуду (видано)",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
        ["Green Voodoo Feather (Provided)"] = "зелене пір'я вуду (видано)",
    },
    [8414] = {
        ["Minion's Scourgestone"] = "камінь посіпаки Скари",
        ["Minion's Scourgestone (Provided)"] = "камінь посіпаки Скари (видано)",
    },
    [8416] = {
        ["Inert Scourgestone"] = "інертний камінь Скари",
        ["Inert Scourgestone (Provided)"] = "інертний камінь Скари (видано)",
    },
    [8418] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Amber Voodoo Feather (Provided)"] = "бурштинове пір'я вуду (видано)",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Blue Voodoo Feather (Provided)"] = "блакитне пір'я вуду (видано)",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
        ["Green Voodoo Feather (Provided)"] = "зелене пір'я вуду (видано)",
    },
    [8419] = {
        ["Felcloth"] = "сквернотканина",
        ["Felcloth (Provided)"] = "сквернотканина (видано)",
    },
    [8420] = {
        ["Felcloth"] = "сквернотканина",
        ["Felcloth (Provided)"] = "сквернотканина (видано)",
    },
    [8421] = {
        ["Bloodvenom Essence"] = "кровотруйна есенція",
        ["Bloodvenom Essence (Provided)"] = "кровотруйна есенція (видано)",
        ["Rotting Wood"] = "гнила деревина",
        ["Rotting Wood (Provided)"] = "гнила деревина (видано)",
    },
    [8422] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Amber Voodoo Feather (Provided)"] = "бурштинове пір'я вуду (видано)",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Blue Voodoo Feather (Provided)"] = "блакитне пір'я вуду (видано)",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
        ["Green Voodoo Feather (Provided)"] = "зелене пір'я вуду (видано)",
    },
    [8423] = {
        ["Helboar"] = "пеклокнур",
        ["Helboar slain"] = "пеклокнур: убито",
    },
    [8424] = {
        ["Shadowsworn Adept"] = "адепт тінеклятів",
        ["Shadowsworn Adept slain"] = "адепт тінеклятів: убито",
        ["Shadowsworn Cultist"] = "культист тінеклятів",
        ["Shadowsworn Cultist slain"] = "культист тінеклятів: убито",
        ["Shadowsworn Thug"] = "розбіяка тінеклятів",
        ["Shadowsworn Thug slain"] = "розбіяка тінеклятів: убито",
    },
    [8425] = {
        ["Amber Voodoo Feather"] = "бурштинове пір'я вуду",
        ["Amber Voodoo Feather (Provided)"] = "бурштинове пір'я вуду (видано)",
        ["Blue Voodoo Feather"] = "блакитне пір'я вуду",
        ["Blue Voodoo Feather (Provided)"] = "блакитне пір'я вуду (видано)",
        ["Green Voodoo Feather"] = "зелене пір'я вуду",
        ["Green Voodoo Feather (Provided)"] = "зелене пір'я вуду (видано)",
    },
    [8426] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8427] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8428] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8429] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8430] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8431] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8432] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8433] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8434] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8435] = {
        ["Warsong Gulch Mark of Honor"] = "відзнака честі тіснини Пісні Війни",
        ["Warsong Gulch Mark of Honor (Provided)"] = "відзнака честі тіснини Пісні Війни (видано)",
    },
    [8436] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8437] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8438] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8439] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8440] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8441] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8442] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8443] = {
        ["Arathi Basin Mark of Honor"] = "відзнака честі низини Араті",
        ["Arathi Basin Mark of Honor (Provided)"] = "відзнака честі низини Араті (видано)",
    },
    [8446] = {
        ["Nightmare Engulfed Object"] = "поглинений кошмаром предмет",
        ["Nightmare Engulfed Object (Provided)"] = "поглинений кошмаром предмет (видано)",
    },
    [8447] = {
        ["Waking Legends."] = "Пробудження легенд.",
    },
    [8460] = {
        ["Deadwood Gardener"] = "мертволісий садівник",
        ["Deadwood Gardener slain"] = "мертволісий садівник: убито",
        ["Deadwood Pathfinder"] = "мертволісий слідопит",
        ["Deadwood Pathfinder slain"] = "мертволісий слідопит: убито",
        ["Deadwood Warrior"] = "мертволісий воїн",
        ["Deadwood Warrior slain"] = "мертволісий воїн: убито",
    },
    [8461] = {
        ["Deadwood Avenger"] = "мертволісий месник",
        ["Deadwood Avenger slain"] = "мертволісий месник: убито",
        ["Deadwood Den Watcher"] = "мертволісий наглядач лігва",
        ["Deadwood Den Watcher slain"] = "мертволісий наглядач лігва: убито",
        ["Deadwood Shaman"] = "мертволісий шаман",
        ["Deadwood Shaman slain"] = "мертволісий шаман: убито",
    },
    [8464] = {
        ["Winterfall Den Watcher"] = "зимокрайовий наглядач лігва",
        ["Winterfall Den Watcher slain"] = "зимокрайовий наглядач лігва: убито",
        ["Winterfall Shaman"] = "зимокрайовий шаман",
        ["Winterfall Shaman slain"] = "зимокрайовий шаман: убито",
        ["Winterfall Ursa"] = "зимокрайовий урса",
        ["Winterfall Ursa slain"] = "зимокрайовий урса: убито",
    },
    [8466] = {
        ["Deadwood Headdress Feather"] = "перо з головного убору Мертволісих",
        ["Deadwood Headdress Feather (Provided)"] = "перо з головного убору Мертволісих (видано)",
    },
    [8467] = {
        ["Deadwood Headdress Feather"] = "перо з головного убору Мертволісих",
        ["Deadwood Headdress Feather (Provided)"] = "перо з головного убору Мертволісих (видано)",
    },
    [8469] = {
        ["Winterfall Spirit Beads"] = "духовне намисто Зимокрайових",
        ["Winterfall Spirit Beads (Provided)"] = "духовне намисто Зимокрайових (видано)",
    },
    [8470] = {
        ["0 reputation with Timbermaw Hold"] = "0 репутації у фортеці Тимбермау",
        ["Deadwood Ritual Totem"] = "ритуальний тотем Мертволісих",
        ["Deadwood Ritual Totem (Provided)"] = "ритуальний тотем Мертволісих (видано)",
    },
    [8471] = {
        ["0 reputation with Timbermaw Hold"] = "0 репутації у фортеці Тимбермау",
        ["Winterfall Ritual Totem"] = "ритуальний тотем Зимокрайових",
        ["Winterfall Ritual Totem (Provided)"] = "ритуальний тотем Зимокрайових (видано)",
    },
    [8481] = {
        ["42000 reputation with Timbermaw Hold"] = "42000 репутації у фортеці Тимбермау",
        ["Demon Summoning Torch"] = "факел виклику демона",
        ["Demon Summoning Torch (Provided)"] = "факел виклику демона (видано)",
        ["Essence of Xandivious"] = "сутність Зандівія",
        ["Essence of Xandivious (Provided)"] = "сутність Зандівія (видано)",
    },
    [8484] = {
        ["42000 reputation with Timbermaw Hold"] = "42000 репутації у фортеці Тимбермау",
        ["Timbermaw Offering of Peace"] = "дар Деревопузих",
        ["Timbermaw Offering of Peace (Provided)"] = "дар Деревопузих (видано)",
    },
    [8485] = {
        ["42000 reputation with Timbermaw Hold"] = "42000 репутації у фортеці Тимбермау",
        ["Timbermaw Offering of Peace"] = "дар Деревопузих",
        ["Timbermaw Offering of Peace (Provided)"] = "дар Деревопузих (видано)",
    },
    [8492] = {
        ["Copper Bar"] = "злиток міді",
        ["Copper Bar (Provided)"] = "злиток міді (видано)",
    },
    [8493] = {
        ["Copper Bar"] = "злиток міді",
        ["Copper Bar (Provided)"] = "злиток міді (видано)",
    },
    [8494] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
    },
    [8495] = {
        ["Iron Bar"] = "злиток заліза",
        ["Iron Bar (Provided)"] = "злиток заліза (видано)",
    },
    [8496] = {
        ["Heavy Mageweave Bandage"] = "щільний маготканий бинт",
        ["Heavy Mageweave Bandage (Provided)"] = "щільний маготканий бинт (видано)",
        ["Heavy Runecloth Bandage"] = "щільний рунічний бинт",
        ["Heavy Runecloth Bandage (Provided)"] = "щільний рунічний бинт (видано)",
        ["Heavy Silk Bandage"] = "щільний шовковий бинт",
        ["Heavy Silk Bandage (Provided)"] = "щільний шовковий бинт (видано)",
        ["Logistics Task Briefing X"] = "план логістичного завдання X",
        ["Logistics Task Briefing X (Provided)"] = "план логістичного завдання X (видано)",
    },
    [8497] = {
        ["Globe of Water"] = "куля води",
        ["Globe of Water (Provided)"] = "куля води (видано)",
        ["Logistics Task Briefing I"] = "план логістичного завдання I",
        ["Logistics Task Briefing I (Provided)"] = "план логістичного завдання I (видано)",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Powerful Anti-Venom (Provided)"] = "потужна протиотрута (видано)",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
        ["Smoked Desert Dumplings (Provided)"] = "копчені пустельні пельмені (видано)",
    },
    [8498] = {
        ["Tactical Task Briefing X"] = "план тактичного завдання X",
        ["Tactical Task Briefing X (Provided)"] = "план тактичного завдання X (видано)",
        ["Twilight Battle Orders"] = "бойові накази Сутінкового Молота",
        ["Twilight Battle Orders (Provided)"] = "бойові накази Сутінкового Молота (видано)",
    },
    [8499] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [8500] = {
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [8501] = {
        ["Combat Task Briefing XII"] = "план бойового завдання XII",
        ["Combat Task Briefing XII (Provided)"] = "план бойового завдання XII (видано)",
        ["Hive'Ashi Stinger"] = "жалоносець Вул'Аші",
        ["Hive'Ashi Stinger slain"] = "жалоносець Вул'Аші: убито",
    },
    [8502] = {
        ["Combat Task Briefing III"] = "план бойового завдання III",
        ["Combat Task Briefing III (Provided)"] = "план бойового завдання III (видано)",
        ["Hive'Ashi Worker"] = "робітник Вул'Аші",
        ["Hive'Ashi Worker slain"] = "робітник Вул'Аші: убито",
    },
    [8503] = {
        ["Stranglekelp"] = "душирість",
        ["Stranglekelp (Provided)"] = "душирість (видано)",
    },
    [8504] = {
        ["Stranglekelp"] = "душирість",
        ["Stranglekelp (Provided)"] = "душирість (видано)",
    },
    [8505] = {
        ["Purple Lotus"] = "пурпуровий лотос",
        ["Purple Lotus (Provided)"] = "пурпуровий лотос (видано)",
    },
    [8506] = {
        ["Purple Lotus"] = "пурпуровий лотос",
        ["Purple Lotus (Provided)"] = "пурпуровий лотос (видано)",
    },
    [8507] = {
        ["Signed Field Duty Papers"] = "підписані документи про польову службу",
        ["Signed Field Duty Papers (Provided)"] = "підписані документи про польову службу (видано)",
    },
    [8508] = {
        ["Prepared Field Duty Papers"] = "підготовлені документи про польову службу",
        ["Prepared Field Duty Papers (Provided)"] = "підготовлені документи про польову службу (видано)",
    },
    [8509] = {
        ["Arthas' Tears"] = "сльози Артаса",
        ["Arthas' Tears (Provided)"] = "сльози Артаса (видано)",
    },
    [8510] = {
        ["Arthas' Tears"] = "сльози Артаса",
        ["Arthas' Tears (Provided)"] = "сльози Артаса (видано)",
    },
    [8511] = {
        ["Light Leather"] = "легка шкіра",
        ["Light Leather (Provided)"] = "легка шкіра (видано)",
    },
    [8512] = {
        ["Light Leather"] = "легка шкіра",
        ["Light Leather (Provided)"] = "легка шкіра (видано)",
    },
    [8513] = {
        ["Medium Leather"] = "середня шкіра",
        ["Medium Leather (Provided)"] = "середня шкіра (видано)",
    },
    [8514] = {
        ["Medium Leather"] = "середня шкіра",
        ["Medium Leather (Provided)"] = "середня шкіра (видано)",
    },
    [8515] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [8516] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [8517] = {
        ["Linen Bandage"] = "лляний бинт",
        ["Linen Bandage (Provided)"] = "лляний бинт (видано)",
    },
    [8518] = {
        ["Linen Bandage"] = "лляний бинт",
        ["Linen Bandage (Provided)"] = "лляний бинт (видано)",
    },
    [8519] = {
        ["The War of the Shifting Sands"] = "Війна Мінливих Пісків",
    },
    [8520] = {
        ["Silk Bandage"] = "шовковий бинт",
        ["Silk Bandage (Provided)"] = "шовковий бинт (видано)",
    },
    [8521] = {
        ["Silk Bandage"] = "шовковий бинт",
        ["Silk Bandage (Provided)"] = "шовковий бинт (видано)",
    },
    [8522] = {
        ["Runecloth Bandage"] = "рунічний бинт",
        ["Runecloth Bandage (Provided)"] = "рунічний бинт (видано)",
    },
    [8523] = {
        ["Runecloth Bandage"] = "рунічний бинт",
        ["Runecloth Bandage (Provided)"] = "рунічний бинт (видано)",
    },
    [8524] = {
        ["Rainbow Fin Albacore"] = "веселковий тунець",
        ["Rainbow Fin Albacore (Provided)"] = "веселковий тунець (видано)",
    },
    [8525] = {
        ["Rainbow Fin Albacore"] = "веселковий тунець",
        ["Rainbow Fin Albacore (Provided)"] = "веселковий тунець (видано)",
    },
    [8526] = {
        ["Roast Raptor"] = "смажений раптор",
        ["Roast Raptor (Provided)"] = "смажений раптор (видано)",
    },
    [8527] = {
        ["Roast Raptor"] = "смажений раптор",
        ["Roast Raptor (Provided)"] = "смажений раптор (видано)",
    },
    [8528] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
        ["Spotted Yellowtail (Provided)"] = "плямистий жовтохвіст (видано)",
    },
    [8529] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
        ["Spotted Yellowtail (Provided)"] = "плямистий жовтохвіст (видано)",
    },
    [8530] = {
        ["Singed Corestone"] = "обпалений вулканічний камінь",
    },
    [8532] = {
        ["Copper Bar"] = "злиток міді",
        ["Copper Bar (Provided)"] = "злиток міді (видано)",
    },
    [8533] = {
        ["Copper Bar"] = "злиток міді",
        ["Copper Bar (Provided)"] = "злиток міді (видано)",
    },
    [8534] = {
        ["Hive'Zora Scout Report"] = "звіт розвідниці Вул'Зори",
        ["Hive'Zora Scout Report (Provided)"] = "звіт розвідниці Вул'Зори (видано)",
        ["Tactical Task Briefing VI"] = "план тактичного завдання VI",
        ["Tactical Task Briefing VI (Provided)"] = "план тактичного завдання VI (видано)",
    },
    [8535] = {
        ["Hoary Templar"] = "сивий храмовник",
        ["Hoary Templar slain"] = "сивий храмовник: убито",
        ["Tactical Task Briefing IV"] = "план тактичного завдання IV",
        ["Tactical Task Briefing IV (Provided)"] = "план тактичного завдання IV (видано)",
    },
    [8536] = {
        ["Earthen Templar"] = "земляний храмовник",
        ["Earthen Templar slain"] = "земляний храмовник: убито",
        ["Tactical Task Briefing III"] = "план тактичного завдання III",
        ["Tactical Task Briefing III (Provided)"] = "план тактичного завдання III (видано)",
    },
    [8537] = {
        ["Crimson Templar"] = "багряний храмовник",
        ["Crimson Templar slain"] = "багряний храмовник: убито",
        ["Tactical Task Briefing II"] = "план тактичного завдання II",
        ["Tactical Task Briefing II (Provided)"] = "план тактичного завдання II (видано)",
    },
    [8538] = {
        ["Tactical Task Briefing V"] = "план тактичного завдання V",
        ["Tactical Task Briefing V (Provided)"] = "план тактичного завдання V (видано)",
        ["The Duke of Cynders"] = "герцог попелу",
        ["The Duke of Cynders slain"] = "герцог попелу: убито",
        ["The Duke of Fathoms"] = "герцог глибин",
        ["The Duke of Fathoms slain"] = "герцог глибин: убито",
        ["The Duke of Shards"] = "герцог осколків",
        ["The Duke of Shards slain"] = "герцог осколків: убито",
        ["The Duke of Zephyrs"] = "герцог вітрів",
        ["The Duke of Zephyrs slain"] = "герцог вітрів: убито",
    },
    [8539] = {
        ["Combat Task Briefing V"] = "план бойового завдання V",
        ["Combat Task Briefing V (Provided)"] = "план бойового завдання V (видано)",
        ["Hive'Zora Hive Sister"] = "сестра рою Вул'Зори",
        ["Hive'Zora Hive Sister slain"] = "сестра рою Вул'Зори: убито",
    },
    [8540] = {
        ["Logistics Task Briefing II"] = "план логістичного завдання II",
        ["Logistics Task Briefing II (Provided)"] = "план логістичного завдання II (видано)",
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Boots (Provided)"] = "вишукані мітрилові чоботи (видано)",
    },
    [8541] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Dense Grinding Stone (Provided)"] = "масивний шліфувальний камінь (видано)",
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
        ["Heavy Grinding Stone (Provided)"] = "важкий шліфувальний камінь (видано)",
        ["Logistics Task Briefing III"] = "план логістичного завдання III",
        ["Logistics Task Briefing III (Provided)"] = "план логістичного завдання III (видано)",
        ["Solid Grinding Stone"] = "твердий шліфувальний камінь",
        ["Solid Grinding Stone (Provided)"] = "твердий шліфувальний камінь (видано)",
    },
    [8542] = {
        ["Tin Bar"] = "злиток олова",
        ["Tin Bar (Provided)"] = "злиток олова (видано)",
    },
    [8543] = {
        ["Tin Bar"] = "злиток олова",
        ["Tin Bar (Provided)"] = "злиток олова (видано)",
    },
    [8544] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Idol of Night"] = "ідол ночі",
        ["Idol of Night (Provided)"] = "ідол ночі (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8545] = {
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
    },
    [8546] = {
        ["Mithril Bar"] = "злиток мітрилу",
        ["Mithril Bar (Provided)"] = "злиток мітрилу (видано)",
    },
    [8548] = {
        ["3000 reputation with Cenarion Circle"] = "3000 репутації у Колі Кенаріона",
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Combat Badge (Provided)"] = "кенарійська бойова відзнака (видано)",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Logistics Badge (Provided)"] = "кенарійська логістична відзнака (видано)",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Cenarion Tactical Badge (Provided)"] = "кенарійська тактична відзнака (видано)",
    },
    [8549] = {
        ["Peacebloom"] = "мироквіт",
        ["Peacebloom (Provided)"] = "мироквіт (видано)",
    },
    [8550] = {
        ["Peacebloom"] = "мироквіт",
        ["Peacebloom (Provided)"] = "мироквіт (видано)",
    },
    [8551] = {
        ["Smotts' Chest"] = "скриня Смоттса",
        ["Smotts' Chest (Provided)"] = "скриня Смоттса (видано)",
    },
    [8552] = {
        ["Monogrammed Sash"] = "пояс з монограмою",
        ["Monogrammed Sash (Provided)"] = "пояс з монограмою (видано)",
    },
    [8554] = {
        ["Smotts' Cutlass"] = "шабля Смоттса",
        ["Smotts' Cutlass (Provided)"] = "шабля Смоттса (видано)",
    },
    [8556] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Lambent Idol (Provided)"] = "сяйнистий ідол (видано)",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Qiraji Magisterial Ring (Provided)"] = "кіразький магістерський перстень (видано)",
    },
    [8557] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Onyx Idol (Provided)"] = "оніксовий ідол (видано)",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Qiraji Martial Drape (Provided)"] = "кіразька бойова пелерина (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8558] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Alabaster Idol (Provided)"] = "алебастровий ідол (видано)",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Qiraji Spiked Hilt (Provided)"] = "кіразьке шиповане руків'я (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8559] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of War"] = "ідол війни",
        ["Idol of War (Provided)"] = "ідол війни (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
    },
    [8560] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Death"] = "ідол смерті",
        ["Idol of Death (Provided)"] = "ідол смерті (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Ouro's Intact Hide (Provided)"] = "неушкоджена шкура Оуро (видано)",
    },
    [8561] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of the Sun"] = "ідол сонця",
        ["Idol of the Sun (Provided)"] = "ідол сонця (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
        ["Vek'nilash's Circlet (Provided)"] = "вінець Век'нілаша (видано)",
    },
    [8562] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Carapace of the Old God (Provided)"] = "панцир Старого Бога (видано)",
        ["Idol of War"] = "ідол війни",
        ["Idol of War (Provided)"] = "ідол війни (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8565] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8566] = {
        ["Arathi Resource Crate"] = "ящик з ресурсами Араті",
        ["Arathi Resource Crate (Provided)"] = "ящик з ресурсами Араті (видано)",
    },
    [8567] = {
        ["Silverwing Talisman of Merit"] = "талісман заслуги Срібнокрилих",
        ["Silverwing Talisman of Merit (Provided)"] = "талісман заслуги Срібнокрилих (видано)",
    },
    [8568] = {
        ["Warsong Mark of Honor"] = "відзнака честі Пісні Війни",
        ["Warsong Mark of Honor (Provided)"] = "відзнака честі Пісні Війни (видано)",
    },
    [8569] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8570] = {
        ["Warsong Gulch Ribbon of Sacrifice"] = "жертовна стрічка Пісні Війни",
        ["Warsong Gulch Ribbon of Sacrifice (Provided)"] = "жертовна стрічка Пісні Війни (видано)",
    },
    [8572] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Combat Badge (Provided)"] = "кенарійська бойова відзнака (видано)",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Logistics Badge (Provided)"] = "кенарійська логістична відзнака (видано)",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Cenarion Tactical Badge (Provided)"] = "кенарійська тактична відзнака (видано)",
    },
    [8573] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Combat Badge (Provided)"] = "кенарійська бойова відзнака (видано)",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Logistics Badge (Provided)"] = "кенарійська логістична відзнака (видано)",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Cenarion Tactical Badge (Provided)"] = "кенарійська тактична відзнака (видано)",
        ["Mark of Cenarius"] = "знак Кенарія",
        ["Mark of Cenarius (Provided)"] = "знак Кенарія (видано)",
    },
    [8574] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Combat Badge (Provided)"] = "кенарійська бойова відзнака (видано)",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Logistics Badge (Provided)"] = "кенарійська логістична відзнака (видано)",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Cenarion Tactical Badge (Provided)"] = "кенарійська тактична відзнака (видано)",
        ["Mark of Remulos"] = "знак Ремула",
        ["Mark of Remulos (Provided)"] = "знак Ремула (видано)",
    },
    [8575] = {
        ["Magical Ledger"] = "магічне писання",
        ["Magical Ledger (Provided)"] = "магічне писання (видано)",
    },
    [8578] = {
        ["Narain's Scrying Goggles"] = "окуляри провидіння Нараіна",
        ["Narain's Scrying Goggles (Provided)"] = "окуляри провидіння Нараіна (видано)",
    },
    [8579] = {
        ["Qiraji Lord's Insignia"] = "відзнака кіразького володаря",
        ["Qiraji Lord's Insignia (Provided)"] = "відзнака кіразького володаря (видано)",
    },
    [8580] = {
        ["Firebloom"] = "вогнеквіт",
        ["Firebloom (Provided)"] = "вогнеквіт (видано)",
    },
    [8581] = {
        ["Firebloom"] = "вогнеквіт",
        ["Firebloom (Provided)"] = "вогнеквіт (видано)",
    },
    [8582] = {
        ["Purple Lotus"] = "пурпуровий лотос",
        ["Purple Lotus (Provided)"] = "пурпуровий лотос (видано)",
    },
    [8583] = {
        ["Purple Lotus"] = "пурпуровий лотос",
        ["Purple Lotus (Provided)"] = "пурпуровий лотос (видано)",
    },
    [8585] = {
        ["Chimaerok Tenderloin"] = "вирізка химерини",
        ["Chimaerok Tenderloin (Provided)"] = "вирізка химерини (видано)",
        ["Lakmaeran's Carcass"] = "туша Лакмеран",
        ["Lakmaeran's Carcass (Provided)"] = "туша Лакмеран (видано)",
    },
    [8586] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
        ["Deeprock Salt (Provided)"] = "глибокоскельна сіль (видано)",
        ["Goblin Rocket Fuel"] = "гоблінське ракетне паливо",
        ["Goblin Rocket Fuel (Provided)"] = "гоблінське ракетне паливо (видано)",
    },
    [8587] = {
        ["500 Pound Chicken"] = "500-фунтова курка",
        ["500 Pound Chicken (Provided)"] = "500-фунтова курка (видано)",
    },
    [8588] = {
        ["Heavy Leather"] = "важка шкіра",
        ["Heavy Leather (Provided)"] = "важка шкіра (видано)",
    },
    [8589] = {
        ["Heavy Leather"] = "важка шкіра",
        ["Heavy Leather (Provided)"] = "важка шкіра (видано)",
    },
    [8590] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [8591] = {
        ["Thick Leather"] = "товста шкіра",
        ["Thick Leather (Provided)"] = "товста шкіра (видано)",
    },
    [8592] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
        ["Vek'nilash's Circlet (Provided)"] = "вінець Век'нілаша (видано)",
    },
    [8593] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Ouro's Intact Hide (Provided)"] = "неушкоджена шкура Оуро (видано)",
    },
    [8594] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8595] = {
        ["Qiraji Lord's Insignia"] = "відзнака кіразького володаря",
        ["Qiraji Lord's Insignia (Provided)"] = "відзнака кіразького володаря (видано)",
    },
    [8596] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Death"] = "ідол смерті",
        ["Idol of Death (Provided)"] = "ідол смерті (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
    },
    [8598] = {
        ["Ransom Letter"] = "лист з вимогою викупу",
        ["Ransom Letter (Provided)"] = "лист з вимогою викупу (видано)",
    },
    [8599] = {
        ["Meridith's Love Letter"] = "любовний лист Меридіт",
        ["Meridith's Love Letter (Provided)"] = "любовний лист Меридіт (видано)",
    },
    [8600] = {
        ["Rugged Leather"] = "міцна шкіра",
        ["Rugged Leather (Provided)"] = "міцна шкіра (видано)",
    },
    [8601] = {
        ["Rugged Leather"] = "міцна шкіра",
        ["Rugged Leather (Provided)"] = "міцна шкіра (видано)",
    },
    [8602] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8603] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Husk of the Old God (Provided)"] = "оболонка Старого Бога (видано)",
        ["Idol of Death"] = "ідол смерті",
        ["Idol of Death (Provided)"] = "ідол смерті (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8604] = {
        ["Wool Bandage"] = "вовняний бинт",
        ["Wool Bandage (Provided)"] = "вовняний бинт (видано)",
    },
    [8605] = {
        ["Wool Bandage"] = "вовняний бинт",
        ["Wool Bandage (Provided)"] = "вовняний бинт (видано)",
    },
    [8606] = {
        ["Who Does Number Two Work For?"] = "Для кого працює Номер Два?",
        ["Who Does Number Two Work For? (Provided)"] = "Для кого працює Номер Два? (видано)",
        ["Who Does Number Two Work For? slain"] = "Для кого працює Номер Два?: убито",
    },
    [8607] = {
        ["Mageweave Bandage"] = "маготканий бинт",
        ["Mageweave Bandage (Provided)"] = "маготканий бинт (видано)",
    },
    [8608] = {
        ["Mageweave Bandage"] = "маготканий бинт",
        ["Mageweave Bandage (Provided)"] = "маготканий бинт (видано)",
    },
    [8609] = {
        ["Runecloth Bandage"] = "рунічний бинт",
        ["Runecloth Bandage (Provided)"] = "рунічний бинт (видано)",
    },
    [8610] = {
        ["Runecloth Bandage"] = "рунічний бинт",
        ["Runecloth Bandage (Provided)"] = "рунічний бинт (видано)",
    },
    [8611] = {
        ["Lean Wolf Steak"] = "пісний вовчий стейк",
        ["Lean Wolf Steak (Provided)"] = "пісний вовчий стейк (видано)",
    },
    [8612] = {
        ["Lean Wolf Steak"] = "пісний вовчий стейк",
        ["Lean Wolf Steak (Provided)"] = "пісний вовчий стейк (видано)",
    },
    [8613] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
        ["Spotted Yellowtail (Provided)"] = "плямистий жовтохвіст (видано)",
    },
    [8614] = {
        ["Spotted Yellowtail"] = "плямистий жовтохвіст",
        ["Spotted Yellowtail (Provided)"] = "плямистий жовтохвіст (видано)",
    },
    [8615] = {
        ["Baked Salmon"] = "запечений лосось",
        ["Baked Salmon (Provided)"] = "запечений лосось (видано)",
    },
    [8616] = {
        ["Baked Salmon"] = "запечений лосось",
        ["Baked Salmon (Provided)"] = "запечений лосось (видано)",
    },
    [8617] = {
        ["Singed Corestone"] = "обпалений вулканічний камінь",
    },
    [8620] = {
        ["Draconic For Dummies: Volume II"] = "Мова драконів для початківців: Том ІІ",
        ["Draconic For Dummies: Volume II (Provided)"] = "Мова драконів для початківців: Том ІІ (видано)",
    },
    [8621] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8622] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Carapace of the Old God (Provided)"] = "панцир Старого Бога (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8623] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
        ["Vek'lor's Diadem (Provided)"] = "діадема Век'лора (видано)",
    },
    [8624] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Skin of the Great Sandworm (Provided)"] = "шкіра гігантського піщаного черв'яка (видано)",
    },
    [8625] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Death"] = "ідол смерті",
        ["Idol of Death (Provided)"] = "ідол смерті (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8626] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8627] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Carapace of the Old God (Provided)"] = "панцир Старого Бога (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8628] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
        ["Vek'lor's Diadem (Provided)"] = "діадема Век'лора (видано)",
    },
    [8629] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Skin of the Great Sandworm (Provided)"] = "шкіра гігантського піщаного черв'яка (видано)",
    },
    [8630] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8631] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Ouro's Intact Hide (Provided)"] = "неушкоджена шкура Оуро (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8632] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Night"] = "ідол ночі",
        ["Idol of Night (Provided)"] = "ідол ночі (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
        ["Vek'nilash's Circlet (Provided)"] = "вінець Век'нілаша (видано)",
    },
    [8633] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Husk of the Old God (Provided)"] = "оболонка Старого Бога (видано)",
        ["Idol of the Sun"] = "ідол сонця",
        ["Idol of the Sun (Provided)"] = "ідол сонця (видано)",
    },
    [8634] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of the Sun"] = "ідол сонця",
        ["Idol of the Sun (Provided)"] = "ідол сонця (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8637] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
    },
    [8638] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Carapace of the Old God (Provided)"] = "панцир Старого Бога (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
    },
    [8639] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of War"] = "ідол війни",
        ["Idol of War (Provided)"] = "ідол війни (видано)",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
        ["Vek'lor's Diadem (Provided)"] = "діадема Век'лора (видано)",
    },
    [8640] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of Night"] = "ідол ночі",
        ["Idol of Night (Provided)"] = "ідол ночі (видано)",
        ["Ouro's Intact Hide"] = "неушкоджена шкура Оуро",
        ["Ouro's Intact Hide (Provided)"] = "неушкоджена шкура Оуро (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8641] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Idol of the Sun"] = "ідол сонця",
        ["Idol of the Sun (Provided)"] = "ідол сонця (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8655] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8656] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Carapace of the Old God"] = "панцир Старого Бога",
        ["Carapace of the Old God (Provided)"] = "панцир Старого Бога (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
    },
    [8657] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
        ["Vek'lor's Diadem (Provided)"] = "діадема Век'лора (видано)",
    },
    [8658] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Idol of the Sun"] = "ідол сонця",
        ["Idol of the Sun (Provided)"] = "ідол сонця (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Skin of the Great Sandworm (Provided)"] = "шкіра гігантського піщаного черв'яка (видано)",
    },
    [8659] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of War"] = "ідол війни",
        ["Idol of War (Provided)"] = "ідол війни (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Bindings of Command"] = "кіразькі наручі командування",
        ["Qiraji Bindings of Command (Provided)"] = "кіразькі наручі командування (видано)",
    },
    [8660] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Idol of Night"] = "ідол ночі",
        ["Idol of Night (Provided)"] = "ідол ночі (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8661] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Husk of the Old God (Provided)"] = "оболонка Старого Бога (видано)",
        ["Idol of Night"] = "ідол ночі",
        ["Idol of Night (Provided)"] = "ідол ночі (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8662] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Idol of Death"] = "ідол смерті",
        ["Idol of Death (Provided)"] = "ідол смерті (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Vek'nilash's Circlet"] = "вінець Век'нілаша",
        ["Vek'nilash's Circlet (Provided)"] = "вінець Век'нілаша (видано)",
    },
    [8663] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Skin of the Great Sandworm (Provided)"] = "шкіра гігантського піщаного черв'яка (видано)",
    },
    [8664] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Idol of the Sage"] = "ідол мудреця",
        ["Idol of the Sage (Provided)"] = "ідол мудреця (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8665] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8666] = {
        ["9000 reputation with Brood of Nozdormu"] = "9000 репутації у Виводка Ноздорму",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Husk of the Old God"] = "оболонка Старого Бога",
        ["Husk of the Old God (Provided)"] = "оболонка Старого Бога (видано)",
        ["Idol of Rebirth"] = "ідол відродження",
        ["Idol of Rebirth (Provided)"] = "ідол відродження (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
    },
    [8667] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Life"] = "ідол життя",
        ["Idol of Life (Provided)"] = "ідол життя (видано)",
        ["Vek'lor's Diadem"] = "діадема Век'лора",
        ["Vek'lor's Diadem (Provided)"] = "діадема Век'лора (видано)",
    },
    [8668] = {
        ["3000 reputation with Brood of Nozdormu"] = "3000 репутації у Виводка Ноздорму",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Idol of War"] = "ідол війни",
        ["Idol of War (Provided)"] = "ідол війни (видано)",
        ["Skin of the Great Sandworm"] = "шкіра гігантського піщаного черв'яка",
        ["Skin of the Great Sandworm (Provided)"] = "шкіра гігантського піщаного черв'яка (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8669] = {
        ["0 reputation with Brood of Nozdormu"] = "0 репутації у Виводка Ноздорму",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Idol of Strife"] = "ідол боротьби",
        ["Idol of Strife (Provided)"] = "ідол боротьби (видано)",
        ["Qiraji Bindings of Dominance"] = "кіразькі наручі домінування",
        ["Qiraji Bindings of Dominance (Provided)"] = "кіразькі наручі домінування (видано)",
    },
    [8687] = {
        ["Combat Task Briefing VII"] = "план бойового завдання VII",
        ["Combat Task Briefing VII (Provided)"] = "план бойового завдання VII (видано)",
        ["Hive'Zora Tunneler"] = "прохідник Вул'Зори",
        ["Hive'Zora Tunneler slain"] = "прохідник Вул'Зори: убито",
    },
    [8689] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Jasper Idol (Provided)"] = "яшмовий ідол (видано)",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Qiraji Martial Drape (Provided)"] = "кіразька бойова пелерина (видано)",
    },
    [8690] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Obsidian Idol (Provided)"] = "обсидіановий ідол (видано)",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Qiraji Regal Drape (Provided)"] = "кіразька королівська пелерина (видано)",
    },
    [8691] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Alabaster Idol (Provided)"] = "алебастровий ідол (видано)",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Qiraji Martial Drape (Provided)"] = "кіразька бойова пелерина (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8692] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Qiraji Regal Drape (Provided)"] = "кіразька королівська пелерина (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Vermillion Idol"] = "багряний ідол",
        ["Vermillion Idol (Provided)"] = "багряний ідол (видано)",
    },
    [8693] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Azure Idol"] = "лазуровий ідол",
        ["Azure Idol (Provided)"] = "лазуровий ідол (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Martial Drape"] = "кіразька бойова пелерина",
        ["Qiraji Martial Drape (Provided)"] = "кіразька бойова пелерина (видано)",
    },
    [8694] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Amber Idol"] = "бурштиновий ідол",
        ["Amber Idol (Provided)"] = "бурштиновий ідол (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Qiraji Regal Drape (Provided)"] = "кіразька королівська пелерина (видано)",
    },
    [8695] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Obsidian Idol (Provided)"] = "обсидіановий ідол (видано)",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Qiraji Regal Drape (Provided)"] = "кіразька королівська пелерина (видано)",
    },
    [8696] = {
        ["21000 reputation with Cenarion Circle"] = "21000 репутації у Колі Кенаріона",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Lambent Idol (Provided)"] = "сяйнистий ідол (видано)",
        ["Qiraji Regal Drape"] = "кіразька королівська пелерина",
        ["Qiraji Regal Drape (Provided)"] = "кіразька королівська пелерина (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8697] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Obsidian Idol (Provided)"] = "обсидіановий ідол (видано)",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Qiraji Ceremonial Ring (Provided)"] = "кіразький церемоніальний перстень (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8698] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Qiraji Magisterial Ring (Provided)"] = "кіразький магістерський перстень (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Vermillion Idol"] = "багряний ідол",
        ["Vermillion Idol (Provided)"] = "багряний ідол (видано)",
    },
    [8699] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Azure Idol"] = "лазуровий ідол",
        ["Azure Idol (Provided)"] = "лазуровий ідол (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Qiraji Magisterial Ring (Provided)"] = "кіразький магістерський перстень (видано)",
    },
    [8700] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Alabaster Idol"] = "алебастровий ідол",
        ["Alabaster Idol (Provided)"] = "алебастровий ідол (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Qiraji Magisterial Ring (Provided)"] = "кіразький магістерський перстень (видано)",
    },
    [8701] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Onyx Idol (Provided)"] = "оніксовий ідол (видано)",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Qiraji Ceremonial Ring (Provided)"] = "кіразький церемоніальний перстень (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8702] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Jasper Idol (Provided)"] = "яшмовий ідол (видано)",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Qiraji Ceremonial Ring (Provided)"] = "кіразький церемоніальний перстень (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8703] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Qiraji Magisterial Ring"] = "кіразький магістерський перстень",
        ["Qiraji Magisterial Ring (Provided)"] = "кіразький магістерський перстень (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Vermillion Idol"] = "багряний ідол",
        ["Vermillion Idol (Provided)"] = "багряний ідол (видано)",
    },
    [8704] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Amber Idol"] = "бурштиновий ідол",
        ["Amber Idol (Provided)"] = "бурштиновий ідол (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Qiraji Ceremonial Ring"] = "кіразький церемоніальний перстень",
        ["Qiraji Ceremonial Ring (Provided)"] = "кіразький церемоніальний перстень (видано)",
    },
    [8705] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Lambent Idol"] = "сяйнистий ідол",
        ["Lambent Idol (Provided)"] = "сяйнистий ідол (видано)",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Qiraji Ornate Hilt (Provided)"] = "кіразьке вишукане руків'я (видано)",
    },
    [8706] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Amber Idol"] = "бурштиновий ідол",
        ["Amber Idol (Provided)"] = "бурштиновий ідол (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Qiraji Spiked Hilt (Provided)"] = "кіразьке шиповане руків'я (видано)",
    },
    [8707] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Obsidian Idol"] = "обсидіановий ідол",
        ["Obsidian Idol (Provided)"] = "обсидіановий ідол (видано)",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Qiraji Ornate Hilt (Provided)"] = "кіразьке вишукане руків'я (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8708] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Jasper Idol"] = "яшмовий ідол",
        ["Jasper Idol (Provided)"] = "яшмовий ідол (видано)",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Qiraji Ornate Hilt (Provided)"] = "кіразьке вишукане руків'я (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8709] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Qiraji Spiked Hilt (Provided)"] = "кіразьке шиповане руків'я (видано)",
        ["Vermillion Idol"] = "багряний ідол",
        ["Vermillion Idol (Provided)"] = "багряний ідол (видано)",
    },
    [8710] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Onyx Idol"] = "оніксовий ідол",
        ["Onyx Idol (Provided)"] = "оніксовий ідол (видано)",
        ["Qiraji Ornate Hilt"] = "кіразьке вишукане руків'я",
        ["Qiraji Ornate Hilt (Provided)"] = "кіразьке вишукане руків'я (видано)",
    },
    [8711] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Amber Idol"] = "бурштиновий ідол",
        ["Amber Idol (Provided)"] = "бурштиновий ідол (видано)",
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Qiraji Spiked Hilt (Provided)"] = "кіразьке шиповане руків'я (видано)",
    },
    [8712] = {
        ["42000 reputation with Cenarion Circle"] = "42000 репутації у Колі Кенаріона",
        ["Azure Idol"] = "лазуровий ідол",
        ["Azure Idol (Provided)"] = "лазуровий ідол (видано)",
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Qiraji Spiked Hilt"] = "кіразьке шиповане руків'я",
        ["Qiraji Spiked Hilt (Provided)"] = "кіразьке шиповане руків'я (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
    },
    [8728] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Azerothian Diamond"] = "азеротський діамант",
        ["Azerothian Diamond (Provided)"] = "азеротський діамант (видано)",
        ["Blue Sapphire"] = "синій сапфір",
        ["Blue Sapphire (Provided)"] = "синій сапфір (видано)",
        ["Elementium Ore"] = "елементієва руда",
        ["Elementium Ore (Provided)"] = "елементієва руда (видано)",
    },
    [8729] = {
        ["Blue Scepter Shard"] = "синій уламок скіпетра",
        ["Blue Scepter Shard (Provided)"] = "синій уламок скіпетра (видано)",
    },
    [8730] = {
        ["Red Scepter Shard"] = "червоний уламок скіпетра",
        ["Red Scepter Shard (Provided)"] = "червоний уламок скіпетра (видано)",
    },
    [8731] = {
        ["Signed Field Duty Papers"] = "підписані документи про польову службу",
        ["Signed Field Duty Papers (Provided)"] = "підписані документи про польову службу (видано)",
    },
    [8732] = {
        ["Prepared Field Duty Papers"] = "підготовлені документи про польову службу",
        ["Prepared Field Duty Papers (Provided)"] = "підготовлені документи про польову службу (видано)",
    },
    [8735] = {
        ["Fragment of the Nightmare's Corruption"] = "фрагмент зараження Жаху",
        ["Fragment of the Nightmare's Corruption (Provided)"] = "фрагмент зараження Жаху (видано)",
    },
    [8736] = {
        ["The Redemption of Eranikus"] = "Викуплення Еранікуса",
    },
    [8737] = {
        ["Azure Templar"] = "лазурний храмовник",
        ["Azure Templar slain"] = "лазурний храмовник: убито",
        ["Tactical Task Briefing I"] = "план тактичного завдання I",
        ["Tactical Task Briefing I (Provided)"] = "план тактичного завдання I (видано)",
    },
    [8738] = {
        ["Hive'Regal Scout Report"] = "звіт розвідника Вул'Регаля",
        ["Hive'Regal Scout Report (Provided)"] = "звіт розвідника Вул'Регаля (видано)",
        ["Tactical Task Briefing VII"] = "план тактичного завдання VII",
        ["Tactical Task Briefing VII (Provided)"] = "план тактичного завдання VII (видано)",
    },
    [8739] = {
        ["Hive'Ashi Scout Report"] = "звіт розвідниці Вул'Аші",
        ["Hive'Ashi Scout Report (Provided)"] = "звіт розвідниці Вул'Аші (видано)",
        ["Tactical Task Briefing VIII"] = "план тактичного завдання VIII",
        ["Tactical Task Briefing VIII (Provided)"] = "план тактичного завдання VIII (видано)",
    },
    [8740] = {
        ["Tactical Task Briefing IX"] = "план тактичного завдання IX",
        ["Tactical Task Briefing IX (Provided)"] = "план тактичного завдання IX (видано)",
        ["Twilight Marauder"] = "сутінковий мародер",
        ["Twilight Marauder Morna"] = "сутінковий мародер Морна",
        ["Twilight Marauder Morna slain"] = "сутінковий мародер Морна: убито",
        ["Twilight Marauder slain"] = "сутінковий мародер: убито",
    },
    [8741] = {
        ["Green Scepter Shard"] = "зелений уламок скіпетра",
        ["Green Scepter Shard (Provided)"] = "зелений уламок скіпетра (видано)",
    },
    [8743] = {
        ["The Scepter of the Shifting Sands"] = "скіпетр Мінливих Пісків",
        ["The Scepter of the Shifting Sands (Provided)"] = "скіпетр Мінливих Пісків (видано)",
    },
    [8746] = {
        ["Find Metzen the Reindeer and rescue him"] = "Знайдіть оленя Метцена та врятуйте його",
        ["Pouch of Reindeer Dust"] = "мішечок з оленячим пилом",
        ["Pouch of Reindeer Dust (Provided)"] = "мішечок з оленячим пилом (видано)",
    },
    [8748] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8749] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8750] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8751] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8753] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8754] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8755] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8756] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8758] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8759] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8760] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8761] = {
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8762] = {
        ["Find Metzen the Reindeer and rescue him"] = "Знайдіть оленя Метцена та врятуйте його",
        ["Pouch of Reindeer Dust"] = "мішечок з оленячим пилом",
        ["Pouch of Reindeer Dust (Provided)"] = "мішечок з оленячим пилом (видано)",
    },
    [8763] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
        ["Deeprock Salt (Provided)"] = "глибокоскельна сіль (видано)",
    },
    [8764] = {
        ["Gold Scarab"] = "золотий скарабей",
        ["Gold Scarab (Provided)"] = "золотий скарабей (видано)",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
        ["Silver Scarab"] = "срібний скарабей",
        ["Silver Scarab (Provided)"] = "срібний скарабей (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8765] = {
        ["Bronze Scarab"] = "бронзовий скарабей",
        ["Bronze Scarab (Provided)"] = "бронзовий скарабей (видано)",
        ["Clay Scarab"] = "глиняний скарабей",
        ["Clay Scarab (Provided)"] = "глиняний скарабей (видано)",
        ["Crystal Scarab"] = "кришталевий скарабей",
        ["Crystal Scarab (Provided)"] = "кришталевий скарабей (видано)",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
    },
    [8766] = {
        ["Bone Scarab"] = "кістяний скарабей",
        ["Bone Scarab (Provided)"] = "кістяний скарабей (видано)",
        ["Ivory Scarab"] = "скарабей зі слонової кістки",
        ["Ivory Scarab (Provided)"] = "скарабей зі слонової кістки (видано)",
        ["Signet Ring of the Bronze Dragonflight"] = "перстень-печатка бронзових драконів",
        ["Signet Ring of the Bronze Dragonflight (Provided)"] = "перстень-печатка бронзових драконів (видано)",
        ["Stone Scarab"] = "кам'яний скарабей",
        ["Stone Scarab (Provided)"] = "кам'яний скарабей (видано)",
    },
    [8770] = {
        ["Combat Task Briefing I"] = "план бойового завдання I",
        ["Combat Task Briefing I (Provided)"] = "план бойового завдання I (видано)",
        ["Hive'Ashi Defender"] = "захисник Вул'Аші",
        ["Hive'Ashi Defender slain"] = "захисник Вул'Аші: убито",
    },
    [8771] = {
        ["Combat Task Briefing II"] = "план бойового завдання II",
        ["Combat Task Briefing II (Provided)"] = "план бойового завдання II (видано)",
        ["Hive'Ashi Sandstalker"] = "піщаний ловець Вул'Аші",
        ["Hive'Ashi Sandstalker slain"] = "піщаний ловець Вул'Аші: убито",
    },
    [8772] = {
        ["Combat Task Briefing VI"] = "план бойового завдання VI",
        ["Combat Task Briefing VI (Provided)"] = "план бойового завдання VI (видано)",
        ["Hive'Zora Waywatcher"] = "шляхостраж Вул'Зори",
        ["Hive'Zora Waywatcher slain"] = "шляхостраж Вул'Зори: убито",
    },
    [8773] = {
        ["Combat Task Briefing IV"] = "план бойового завдання IV",
        ["Combat Task Briefing IV (Provided)"] = "план бойового завдання IV (видано)",
        ["Hive'Zora Reaver"] = "розоритель Вул'Зори",
        ["Hive'Zora Reaver slain"] = "розоритель Вул'Зори: убито",
    },
    [8774] = {
        ["Combat Task Briefing VIII"] = "план бойового завдання VIII",
        ["Combat Task Briefing VIII (Provided)"] = "план бойового завдання VIII (видано)",
        ["Hive'Regal Ambusher"] = "душитель Вул'Регаля",
        ["Hive'Regal Ambusher slain"] = "душитель Вул'Регаля: убито",
    },
    [8775] = {
        ["Combat Task Briefing IX"] = "план бойового завдання IX",
        ["Combat Task Briefing IX (Provided)"] = "план бойового завдання IX (видано)",
        ["Hive'Regal Spitfire"] = "вогнеплюй Вул'Регаля",
        ["Hive'Regal Spitfire slain"] = "вогнеплюй Вул'Регаля: убито",
    },
    [8776] = {
        ["Combat Task Briefing X"] = "план бойового завдання X",
        ["Combat Task Briefing X (Provided)"] = "план бойового завдання X (видано)",
        ["Hive'Regal Slavemaker"] = "поневолювач Вул'Регаля",
        ["Hive'Regal Slavemaker slain"] = "поневолювач Вул'Регаля: убито",
    },
    [8777] = {
        ["Combat Task Briefing XI"] = "план бойового завдання XI",
        ["Combat Task Briefing XI (Provided)"] = "план бойового завдання XI (видано)",
        ["Hive'Regal Burrower"] = "землерий Вул'Регаля",
        ["Hive'Regal Burrower slain"] = "землерий Вул'Регаля: убито",
    },
    [8778] = {
        ["Dense Blasting Powder"] = "масивний вибуховий порошок",
        ["Dense Blasting Powder (Provided)"] = "масивний вибуховий порошок (видано)",
        ["Goblin Rocket Fuel"] = "гоблінське ракетне паливо",
        ["Goblin Rocket Fuel (Provided)"] = "гоблінське ракетне паливо (видано)",
        ["Logistics Task Briefing IV"] = "план логістичного завдання IV",
        ["Logistics Task Briefing IV (Provided)"] = "план логістичного завдання IV (видано)",
        ["Oil of Immolation"] = "олія жертвоприношення",
        ["Oil of Immolation (Provided)"] = "олія жертвоприношення (видано)",
    },
    [8779] = {
        ["Huge Emerald"] = "величезний смарагд",
        ["Huge Emerald (Provided)"] = "величезний смарагд (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
        ["Large Radiant Shard"] = "великий променистий осколок",
        ["Large Radiant Shard (Provided)"] = "великий променистий осколок (видано)",
        ["Logistics Task Briefing V"] = "план логістичного завдання V",
        ["Logistics Task Briefing V (Provided)"] = "план логістичного завдання V (видано)",
    },
    [8780] = {
        ["Heavy Armor Kit"] = "накладки з важкої шкіри",
        ["Heavy Armor Kit (Provided)"] = "накладки з важкої шкіри (видано)",
        ["Logistics Task Briefing VII"] = "план логістичного завдання VII",
        ["Logistics Task Briefing VII (Provided)"] = "план логістичного завдання VII (видано)",
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
        ["Rugged Armor Kit (Provided)"] = "накладки з міцної шкіри (видано)",
    },
    [8781] = {
        ["Logistics Task Briefing VI"] = "план логістичного завдання VI",
        ["Logistics Task Briefing VI (Provided)"] = "план логістичного завдання VI (видано)",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
        ["Moonsteel Broadsword (Provided)"] = "палаш з місяцесталі (видано)",
    },
    [8782] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
        ["Logistics Task Briefing VIII"] = "план логістичного завдання VIII",
        ["Logistics Task Briefing VIII (Provided)"] = "план логістичного завдання VIII (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
    },
    [8783] = {
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Enchanted Thorium Bar (Provided)"] = "зачарований злиток торію (видано)",
        ["Logistics Task Briefing IX"] = "план логістичного завдання IX",
        ["Logistics Task Briefing IX (Provided)"] = "план логістичного завдання IX (видано)",
    },
    [8784] = {
        ["Ancient Qiraji Artifact"] = "древній кіразький артефакт",
        ["Ancient Qiraji Artifact (Provided)"] = "древній кіразький артефакт (видано)",
    },
    [8785] = {
        ["Flask of Big Mojo"] = "фляга великого моджо",
        ["Flask of Big Mojo (Provided)"] = "фляга великого моджо (видано)",
        ["Logistics Task Briefing IV"] = "план логістичного завдання IV",
        ["Logistics Task Briefing IV (Provided)"] = "план логістичного завдання IV (видано)",
        ["Oil of Immolation"] = "олія жертвоприношення",
        ["Oil of Immolation (Provided)"] = "олія жертвоприношення (видано)",
        ["Powerful Mojo"] = "потужне моджо",
        ["Powerful Mojo (Provided)"] = "потужне моджо (видано)",
    },
    [8786] = {
        ["Logistics Task Briefing VI"] = "план логістичного завдання VI",
        ["Logistics Task Briefing VI (Provided)"] = "план логістичного завдання VI (видано)",
        ["Massive Iron Axe"] = "масивна залізна сокира",
        ["Massive Iron Axe (Provided)"] = "масивна залізна сокира (видано)",
    },
    [8787] = {
        ["Heavy Armor Kit"] = "накладки з важкої шкіри",
        ["Heavy Armor Kit (Provided)"] = "накладки з важкої шкіри (видано)",
        ["Logistics Task Briefing VII"] = "план логістичного завдання VII",
        ["Logistics Task Briefing VII (Provided)"] = "план логістичного завдання VII (видано)",
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
        ["Rugged Armor Kit (Provided)"] = "накладки з міцної шкіри (видано)",
    },
    [8789] = {
        ["Elementium Ore"] = "елементієва руда",
        ["Elementium Ore (Provided)"] = "елементієва руда (видано)",
        ["Imperial Qiraji Armaments"] = "кіразька імператорська зброя",
        ["Imperial Qiraji Armaments (Provided)"] = "кіразька імператорська зброя (видано)",
    },
    [8790] = {
        ["Elementium Ore"] = "елементієва руда",
        ["Elementium Ore (Provided)"] = "елементієва руда (видано)",
        ["Imperial Qiraji Regalia"] = "кіразькі імператорські регалії",
        ["Imperial Qiraji Regalia (Provided)"] = "кіразькі імператорські регалії (видано)",
    },
    [8791] = {
        ["Head of Ossirian the Unscarred"] = "голова Оссіріана Невразливого",
        ["Head of Ossirian the Unscarred (Provided)"] = "голова Оссіріана Невразливого (видано)",
    },
    [8799] = {
        ["Deeprock Salt"] = "глибокоскельна сіль",
        ["Deeprock Salt (Provided)"] = "глибокоскельна сіль (видано)",
    },
    [8801] = {
        ["Eye of C'Thun"] = "око К'Туна",
        ["Eye of C'Thun (Provided)"] = "око К'Туна (видано)",
    },
    [8802] = {
        ["Eye of C'Thun"] = "око К'Туна",
        ["Eye of C'Thun (Provided)"] = "око К'Туна (видано)",
    },
    [8804] = {
        ["Globe of Water"] = "куля води",
        ["Globe of Water (Provided)"] = "куля води (видано)",
        ["Logistics Task Briefing I"] = "план логістичного завдання I",
        ["Logistics Task Briefing I (Provided)"] = "план логістичного завдання I (видано)",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Powerful Anti-Venom (Provided)"] = "потужна протиотрута (видано)",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
        ["Smoked Desert Dumplings (Provided)"] = "копчені пустельні пельмені (видано)",
    },
    [8805] = {
        ["Logistics Task Briefing II"] = "план логістичного завдання II",
        ["Logistics Task Briefing II (Provided)"] = "план логістичного завдання II (видано)",
        ["Ornate Mithril Boots"] = "вишукані мітрилові чоботи",
        ["Ornate Mithril Boots (Provided)"] = "вишукані мітрилові чоботи (видано)",
    },
    [8806] = {
        ["Dense Grinding Stone"] = "масивний шліфувальний камінь",
        ["Dense Grinding Stone (Provided)"] = "масивний шліфувальний камінь (видано)",
        ["Heavy Grinding Stone"] = "важкий шліфувальний камінь",
        ["Heavy Grinding Stone (Provided)"] = "важкий шліфувальний камінь (видано)",
        ["Logistics Task Briefing III"] = "план логістичного завдання III",
        ["Logistics Task Briefing III (Provided)"] = "план логістичного завдання III (видано)",
        ["Solid Grinding Stone"] = "твердий шліфувальний камінь",
        ["Solid Grinding Stone (Provided)"] = "твердий шліфувальний камінь (видано)",
    },
    [8807] = {
        ["Huge Emerald"] = "величезний смарагд",
        ["Huge Emerald (Provided)"] = "величезний смарагд (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
        ["Large Radiant Shard"] = "великий променистий осколок",
        ["Large Radiant Shard (Provided)"] = "великий променистий осколок (видано)",
        ["Logistics Task Briefing V"] = "план логістичного завдання V",
        ["Logistics Task Briefing V (Provided)"] = "план логістичного завдання V (видано)",
    },
    [8808] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
        ["Logistics Task Briefing VIII"] = "план логістичного завдання VIII",
        ["Logistics Task Briefing VIII (Provided)"] = "план логістичного завдання VIII (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
    },
    [8809] = {
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Enchanted Thorium Bar"] = "зачарований злиток торію",
        ["Enchanted Thorium Bar (Provided)"] = "зачарований злиток торію (видано)",
        ["Logistics Task Briefing IX"] = "план логістичного завдання IX",
        ["Logistics Task Briefing IX (Provided)"] = "план логістичного завдання IX (видано)",
    },
    [8810] = {
        ["Heavy Mageweave Bandage"] = "щільний маготканий бинт",
        ["Heavy Mageweave Bandage (Provided)"] = "щільний маготканий бинт (видано)",
        ["Heavy Runecloth Bandage"] = "щільний рунічний бинт",
        ["Heavy Runecloth Bandage (Provided)"] = "щільний рунічний бинт (видано)",
        ["Heavy Silk Bandage"] = "щільний шовковий бинт",
        ["Heavy Silk Bandage (Provided)"] = "щільний шовковий бинт (видано)",
        ["Logistics Task Briefing X"] = "план логістичного завдання X",
        ["Logistics Task Briefing X (Provided)"] = "план логістичного завдання X (видано)",
    },
    [8811] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8812] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8813] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8814] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8815] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8816] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8817] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8818] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8819] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8820] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8821] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8822] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8823] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8824] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8825] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8826] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8829] = {
        ["Frayed Abomination Stitching"] = "зотлілий стібок потвори",
        ["Frayed Abomination Stitching (Provided)"] = "зотлілий стібок потвори (видано)",
        ["Logistics Task Briefing XI"] = "план логістичного завдання XI",
        ["Logistics Task Briefing XI (Provided)"] = "план логістичного завдання XI (видано)",
        ["Skin of Shadow"] = "шкіра тіні",
        ["Skin of Shadow (Provided)"] = "шкіра тіні (видано)",
        ["Twilight Cultist Robe"] = "сутінкова мантія культиста",
        ["Twilight Cultist Robe (Provided)"] = "сутінкова мантія культиста (видано)",
    },
    [8830] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8831] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8832] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8833] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8834] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8835] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8836] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8837] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8838] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8839] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8840] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8841] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8842] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8843] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8844] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8845] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8846] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8847] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8848] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8849] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8850] = {
        ["Alliance Commendation Signet"] = "відзнака подяки Альянсу",
        ["Alliance Commendation Signet (Provided)"] = "відзнака подяки Альянсу (видано)",
    },
    [8851] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8852] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8853] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8854] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8855] = {
        ["Horde Commendation Signet"] = "відзнака подяки Орди",
        ["Horde Commendation Signet (Provided)"] = "відзнака подяки Орди (видано)",
    },
    [8856] = {
        ["Globe of Water"] = "куля води",
        ["Globe of Water (Provided)"] = "куля води (видано)",
        ["Logistics Task Briefing I"] = "план логістичного завдання I",
        ["Logistics Task Briefing I (Provided)"] = "план логістичного завдання I (видано)",
        ["Powerful Anti-Venom"] = "потужна протиотрута",
        ["Powerful Anti-Venom (Provided)"] = "потужна протиотрута (видано)",
        ["Smoked Desert Dumplings"] = "копчені пустельні пельмені",
        ["Smoked Desert Dumplings (Provided)"] = "копчені пустельні пельмені (видано)",
    },
    [8857] = {
        ["Colossus of Ashi's Husk"] = "зразок панцира колоса Аші",
        ["Colossus of Ashi's Husk (Provided)"] = "зразок панцира колоса Аші (видано)",
    },
    [8858] = {
        ["Colossus of Regal's Husk"] = "зразок панцира колоса Регаля",
        ["Colossus of Regal's Husk (Provided)"] = "зразок панцира колоса Регаля (видано)",
    },
    [8859] = {
        ["Colossus of Zora's Husk"] = "зразок панцира колоса Зори",
        ["Colossus of Zora's Husk (Provided)"] = "зразок панцира колоса Зори (видано)",
    },
    [8860] = {
        ["Smokywood Supplies"] = "припаси Димного Лісу",
        ["Smokywood Supplies (Provided)"] = "припаси Димного Лісу (видано)",
    },
    [8861] = {
        ["Smokywood Supplies"] = "припаси Димного Лісу",
        ["Smokywood Supplies (Provided)"] = "припаси Димного Лісу (видано)",
    },
    [8862] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8863] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8864] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8865] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8867] = {
        ["Lunar Fireworks Cluster Fired"] = "Місячний феєрверк у скупченні запущено",
        ["Lunar Fireworks Cluster Fired (Provided)"] = "Місячний феєрверк у скупченні запущено (видано)",
        ["Lunar Fireworks Cluster Fired slain"] = "Місячний феєрверк у скупченні запущено: убито",
        ["Lunar Fireworks Fired"] = "Місячний феєрверк запущено",
        ["Lunar Fireworks Fired (Provided)"] = "Місячний феєрверк запущено (видано)",
        ["Lunar Fireworks Fired slain"] = "Місячний феєрверк запущено: убито",
    },
    [8868] = {
        ["Receive Elune's Blessing."] = "Отримайте благословення Елуни.",
    },
    [8869] = {
        ["Crimson Hammersmith's Apron"] = "фартух багряного коваля молотів",
        ["Crimson Hammersmith's Apron (Provided)"] = "фартух багряного коваля молотів (видано)",
    },
    [8876] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8877] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8878] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8879] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8880] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8881] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8882] = {
        ["Coin of Ancestry"] = "монета предків",
        ["Coin of Ancestry (Provided)"] = "монета предків (видано)",
    },
    [8893] = {
        ["Hippogryph Egg"] = "яйце гіпогрифа",
        ["Hippogryph Egg (Provided)"] = "яйце гіпогрифа (видано)",
    },
    [8897] = {
        ["Carefully Penned Note"] = "ретельно продумана записка",
        ["Carefully Penned Note (Provided)"] = "ретельно продумана записка (видано)",
    },
    [8898] = {
        ["Creased Letter"] = "пом'ятий лист",
        ["Creased Letter (Provided)"] = "пом'ятий лист (видано)",
    },
    [8899] = {
        ["Immaculate Letter"] = "бездоганний лист",
        ["Immaculate Letter (Provided)"] = "бездоганний лист (видано)",
    },
    [8900] = {
        ["Slightly Creased Note"] = "злегка пом'ята записка",
        ["Slightly Creased Note (Provided)"] = "злегка пом'ята записка (видано)",
    },
    [8901] = {
        ["Carefully Written Letter"] = "ретельно написаний лист",
        ["Carefully Written Letter (Provided)"] = "ретельно написаний лист (видано)",
    },
    [8902] = {
        ["Lovingly Composed Letter"] = "лист, написаний з любов'ю",
        ["Lovingly Composed Letter (Provided)"] = "лист, написаний з любов'ю (видано)",
    },
    [8903] = {
        ["Stormwind Guard's Card"] = "листівка вартового Штормовію",
        ["Stormwind Guard's Card (Provided)"] = "листівка вартового Штормовію (видано)",
    },
    [8904] = {
        ["Guardian's Moldy Card"] = "запліснявіла листівка вартового",
        ["Guardian's Moldy Card (Provided)"] = "запліснявіла листівка вартового (видано)",
    },
    [8905] = {
        ["Wildheart Bracers"] = "браслети дикого серця",
        ["Wildheart Bracers (Provided)"] = "браслети дикого серця (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8906] = {
        ["Beaststalker's Bindings"] = "браслети ловця звірів",
        ["Beaststalker's Bindings (Provided)"] = "браслети ловця звірів (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8907] = {
        ["Magister's Bindings"] = "браслети магістра",
        ["Magister's Bindings (Provided)"] = "браслети магістра (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8908] = {
        ["Lightforge Bracers"] = "світлоковані браслети",
        ["Lightforge Bracers (Provided)"] = "світлоковані браслети (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8909] = {
        ["Devout Bracers"] = "браслети відданості",
        ["Devout Bracers (Provided)"] = "браслети відданості (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8910] = {
        ["Shadowcraft Bracers"] = "браслети тіньового ремесла",
        ["Shadowcraft Bracers (Provided)"] = "браслети тіньового ремесла (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8911] = {
        ["Dreadmist Bracers"] = "браслети імли жаху",
        ["Dreadmist Bracers (Provided)"] = "браслети імли жаху (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8912] = {
        ["Bracers of Valor"] = "браслети доблесті",
        ["Bracers of Valor (Provided)"] = "браслети доблесті (видано)",
        ["Winterspring Blood Sample"] = "зразок крові із Зимоключа",
        ["Winterspring Blood Sample (Provided)"] = "зразок крові із Зимоключа (видано)",
    },
    [8913] = {
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
        ["Wildheart Bracers"] = "браслети дикого серця",
        ["Wildheart Bracers (Provided)"] = "браслети дикого серця (видано)",
    },
    [8914] = {
        ["Beaststalker's Bindings"] = "браслети ловця звірів",
        ["Beaststalker's Bindings (Provided)"] = "браслети ловця звірів (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8915] = {
        ["Magister's Bindings"] = "браслети магістра",
        ["Magister's Bindings (Provided)"] = "браслети магістра (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8916] = {
        ["Devout Bracers"] = "браслети відданості",
        ["Devout Bracers (Provided)"] = "браслети відданості (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8917] = {
        ["Shadowcraft Bracers"] = "браслети тіньового ремесла",
        ["Shadowcraft Bracers (Provided)"] = "браслети тіньового ремесла (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8918] = {
        ["Bindings of Elements"] = "браслети стихій",
        ["Bindings of Elements (Provided)"] = "браслети стихій (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8919] = {
        ["Dreadmist Bracers"] = "браслети імли жаху",
        ["Dreadmist Bracers (Provided)"] = "браслети імли жаху (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8920] = {
        ["Bracers of Valor"] = "браслети доблесті",
        ["Bracers of Valor (Provided)"] = "браслети доблесті (видано)",
        ["Silithus Venom Sample"] = "зразок отрути з Силітуса",
        ["Silithus Venom Sample (Provided)"] = "зразок отрути з Силітуса (видано)",
    },
    [8921] = {
        ["Delicate Arcanite Converter"] = "чутливий арканітовий перетворювач",
        ["Delicate Arcanite Converter (Provided)"] = "чутливий арканітовий перетворювач (видано)",
        ["Greater Eternal Essence"] = "велика вічна субстанція",
        ["Greater Eternal Essence (Provided)"] = "велика вічна субстанція (видано)",
        ["Stonescale Oil"] = "олія камнелуского вугра",
        ["Stonescale Oil (Provided)"] = "олія камнелуского вугра (видано)",
        ["Volcanic Ash"] = "вулканічний попіл",
        ["Volcanic Ash (Provided)"] = "вулканічний попіл (видано)",
    },
    [8922] = {
        ["Sealed Blood Container"] = "запечатаний контейнер з кров'ю",
        ["Sealed Blood Container (Provided)"] = "запечатаний контейнер з кров'ю (видано)",
    },
    [8923] = {
        ["Sealed Venom Container"] = "запечатаний контейнер з отрутою",
        ["Sealed Venom Container (Provided)"] = "запечатаний контейнер з отрутою (видано)",
    },
    [8924] = {
        ["Ectoplasmic Distiller"] = "ектоплазматичний дистилятор",
        ["Ectoplasmic Distiller (Provided)"] = "ектоплазматичний дистилятор (видано)",
        ["Frozen Ectoplasm"] = "заморожена ектоплазма",
        ["Frozen Ectoplasm (Provided)"] = "заморожена ектоплазма (видано)",
        ["Scorched Ectoplasm"] = "обпалена ектоплазма",
        ["Scorched Ectoplasm (Provided)"] = "обпалена ектоплазма (видано)",
        ["Stable Ectoplasm"] = "стабільна ектоплазма",
        ["Stable Ectoplasm (Provided)"] = "стабільна ектоплазма (видано)",
    },
    [8925] = {
        ["Magma Core"] = "магматичне ядро",
        ["Magma Core (Provided)"] = "магматичне ядро (видано)",
    },
    [8926] = {
        ["Wildheart Belt"] = "пояс дикого серця",
        ["Wildheart Belt (Provided)"] = "пояс дикого серця (видано)",
        ["Wildheart Gloves"] = "рукавички дикого серця",
        ["Wildheart Gloves (Provided)"] = "рукавички дикого серця (видано)",
    },
    [8927] = {
        ["Wildheart Belt"] = "пояс дикого серця",
        ["Wildheart Belt (Provided)"] = "пояс дикого серця (видано)",
        ["Wildheart Gloves"] = "рукавички дикого серця",
        ["Wildheart Gloves (Provided)"] = "рукавички дикого серця (видано)",
    },
    [8928] = {
        ["Fel Elemental Rod"] = "скверно-стихійний стрижень",
        ["Fel Elemental Rod (Provided)"] = "скверно-стихійний стрижень (видано)",
    },
    [8929] = {
        ["Extra-Dimensional Ghost Revealer"] = "міжвимірний шукач привидів",
    },
    [8930] = {
        ["Extra-Dimensional Ghost Revealer"] = "міжвимірний шукач привидів",
    },
    [8931] = {
        ["Beaststalker's Belt"] = "пояс ловця звірів",
        ["Beaststalker's Belt (Provided)"] = "пояс ловця звірів (видано)",
        ["Beaststalker's Gloves"] = "рукавички ловця звірів",
        ["Beaststalker's Gloves (Provided)"] = "рукавички ловця звірів (видано)",
    },
    [8932] = {
        ["Magister's Belt"] = "пояс магістра",
        ["Magister's Belt (Provided)"] = "пояс магістра (видано)",
        ["Magister's Gloves"] = "рукавички магістра",
        ["Magister's Gloves (Provided)"] = "рукавички магістра (видано)",
    },
    [8933] = {
        ["Lightforge Belt"] = "світлокований пояс",
        ["Lightforge Belt (Provided)"] = "світлокований пояс (видано)",
        ["Lightforge Gauntlets"] = "світлоковані рукавиці",
        ["Lightforge Gauntlets (Provided)"] = "світлоковані рукавиці (видано)",
    },
    [8934] = {
        ["Devout Belt"] = "пояс відданості",
        ["Devout Belt (Provided)"] = "пояс відданості (видано)",
        ["Devout Gloves"] = "рукавички відданості",
        ["Devout Gloves (Provided)"] = "рукавички відданості (видано)",
    },
    [8935] = {
        ["Shadowcraft Belt"] = "пояс тіньового ремесла",
        ["Shadowcraft Belt (Provided)"] = "пояс тіньового ремесла (видано)",
        ["Shadowcraft Gloves"] = "рукавиці тіньового ремесла",
        ["Shadowcraft Gloves (Provided)"] = "рукавиці тіньового ремесла (видано)",
    },
    [8936] = {
        ["Dreadmist Belt"] = "пояс імли жаху",
        ["Dreadmist Belt (Provided)"] = "пояс імли жаху (видано)",
        ["Dreadmist Wraps"] = "обмотки імли жаху",
        ["Dreadmist Wraps (Provided)"] = "обмотки імли жаху (видано)",
    },
    [8937] = {
        ["Belt of Valor"] = "пояс доблесті",
        ["Belt of Valor (Provided)"] = "пояс доблесті (видано)",
        ["Gauntlets of Valor"] = "рукавиці доблесті",
        ["Gauntlets of Valor (Provided)"] = "рукавиці доблесті (видано)",
    },
    [8938] = {
        ["Beaststalker's Belt"] = "пояс ловця звірів",
        ["Beaststalker's Belt (Provided)"] = "пояс ловця звірів (видано)",
        ["Beaststalker's Gloves"] = "рукавички ловця звірів",
        ["Beaststalker's Gloves (Provided)"] = "рукавички ловця звірів (видано)",
    },
    [8939] = {
        ["Magister's Belt"] = "пояс магістра",
        ["Magister's Belt (Provided)"] = "пояс магістра (видано)",
        ["Magister's Gloves"] = "рукавички магістра",
        ["Magister's Gloves (Provided)"] = "рукавички магістра (видано)",
    },
    [8940] = {
        ["Devout Belt"] = "пояс відданості",
        ["Devout Belt (Provided)"] = "пояс відданості (видано)",
        ["Devout Gloves"] = "рукавички відданості",
        ["Devout Gloves (Provided)"] = "рукавички відданості (видано)",
    },
    [8941] = {
        ["Shadowcraft Belt"] = "пояс тіньового ремесла",
        ["Shadowcraft Belt (Provided)"] = "пояс тіньового ремесла (видано)",
        ["Shadowcraft Gloves"] = "рукавиці тіньового ремесла",
        ["Shadowcraft Gloves (Provided)"] = "рукавиці тіньового ремесла (видано)",
    },
    [8942] = {
        ["Cord of Elements"] = "ремінь стихій",
        ["Cord of Elements (Provided)"] = "ремінь стихій (видано)",
        ["Gauntlets of Elements"] = "рукавиці стихій",
        ["Gauntlets of Elements (Provided)"] = "рукавиці стихій (видано)",
    },
    [8943] = {
        ["Dreadmist Belt"] = "пояс імли жаху",
        ["Dreadmist Belt (Provided)"] = "пояс імли жаху (видано)",
        ["Dreadmist Wraps"] = "обмотки імли жаху",
        ["Dreadmist Wraps (Provided)"] = "обмотки імли жаху (видано)",
    },
    [8944] = {
        ["Belt of Valor"] = "пояс доблесті",
        ["Belt of Valor (Provided)"] = "пояс доблесті (видано)",
        ["Gauntlets of Valor"] = "рукавиці доблесті",
        ["Gauntlets of Valor (Provided)"] = "рукавиці доблесті (видано)",
    },
    [8945] = {
        ["Ysida Freed"] = "Ісіда Фрід",
        ["Ysida Freed (Provided)"] = "Ісіда Фрід (видано)",
        ["Ysida Freed slain"] = "Ісіда Фрід: убито",
    },
    [8946] = {
        ["Ysida's Locket"] = "медальйон Ісіди",
        ["Ysida's Locket (Provided)"] = "медальйон Ісіди (видано)",
    },
    [8947] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Dark Iron Bar"] = "злиток темного заліза",
        ["Dark Iron Bar (Provided)"] = "злиток темного заліза (видано)",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
    },
    [8948] = {
        ["Incomplete Banner of Provocation"] = "незавершений стяг виклику",
        ["Incomplete Banner of Provocation (Provided)"] = "незавершений стяг виклику (видано)",
    },
    [8949] = {
        ["Ogre Warbeads"] = "бойове намисто огрів",
        ["Ogre Warbeads (Provided)"] = "бойове намисто огрів (видано)",
    },
    [8950] = {
        ["Dark Rune"] = "темна руна",
        ["Dark Rune (Provided)"] = "темна руна (видано)",
        ["Jeering Spectre's Essence"] = "сутність глузливого привида",
        ["Jeering Spectre's Essence (Provided)"] = "сутність глузливого привида (видано)",
        ["Large Brilliant Shard"] = "великий блискучий осколок",
        ["Large Brilliant Shard (Provided)"] = "великий блискучий осколок (видано)",
    },
    [8951] = {
        ["Wildheart Boots"] = "чоботи дикого серця",
        ["Wildheart Boots (Provided)"] = "чоботи дикого серця (видано)",
        ["Wildheart Kilt"] = "кілт дикого серця",
        ["Wildheart Kilt (Provided)"] = "кілт дикого серця (видано)",
        ["Wildheart Spaulders"] = "наплічники дикого серця",
        ["Wildheart Spaulders (Provided)"] = "наплічники дикого серця (видано)",
    },
    [8952] = {
        ["Beaststalker's Boots"] = "чоботи ловця звірів",
        ["Beaststalker's Boots (Provided)"] = "чоботи ловця звірів (видано)",
        ["Beaststalker's Mantle"] = "напліччя ловця звірів",
        ["Beaststalker's Mantle (Provided)"] = "напліччя ловця звірів (видано)",
        ["Beaststalker's Pants"] = "штани ловця звірів",
        ["Beaststalker's Pants (Provided)"] = "штани ловця звірів (видано)",
    },
    [8953] = {
        ["Magister's Boots"] = "чоботи магістра",
        ["Magister's Boots (Provided)"] = "чоботи магістра (видано)",
        ["Magister's Leggings"] = "поножі магістра",
        ["Magister's Leggings (Provided)"] = "поножі магістра (видано)",
        ["Magister's Mantle"] = "напліччя магістра",
        ["Magister's Mantle (Provided)"] = "напліччя магістра (видано)",
    },
    [8954] = {
        ["Lightforge Boots"] = "світлоковані чоботи",
        ["Lightforge Boots (Provided)"] = "світлоковані чоботи (видано)",
        ["Lightforge Legplates"] = "світлоковані поножі",
        ["Lightforge Legplates (Provided)"] = "світлоковані поножі (видано)",
        ["Lightforge Spaulders"] = "світлоковані наплічники",
        ["Lightforge Spaulders (Provided)"] = "світлоковані наплічники (видано)",
    },
    [8955] = {
        ["Devout Mantle"] = "напліччя відданості",
        ["Devout Mantle (Provided)"] = "напліччя відданості (видано)",
        ["Devout Sandals"] = "сандалі відданості",
        ["Devout Sandals (Provided)"] = "сандалі відданості (видано)",
        ["Devout Skirt"] = "спідниця відданості",
        ["Devout Skirt (Provided)"] = "спідниця відданості (видано)",
    },
    [8956] = {
        ["Shadowcraft Boots"] = "чоботи тіньового ремесла",
        ["Shadowcraft Boots (Provided)"] = "чоботи тіньового ремесла (видано)",
        ["Shadowcraft Pants"] = "штани тіньового ремесла",
        ["Shadowcraft Pants (Provided)"] = "штани тіньового ремесла (видано)",
        ["Shadowcraft Spaulders"] = "наплічники тіньового ремесла",
        ["Shadowcraft Spaulders (Provided)"] = "наплічники тіньового ремесла (видано)",
    },
    [8957] = {
        ["Boots of Elements"] = "чоботи стихій",
        ["Boots of Elements (Provided)"] = "чоботи стихій (видано)",
        ["Kilt of Elements"] = "кілт стихій",
        ["Kilt of Elements (Provided)"] = "кілт стихій (видано)",
        ["Pauldrons of Elements"] = "напліччя стихій",
        ["Pauldrons of Elements (Provided)"] = "напліччя стихій (видано)",
    },
    [8958] = {
        ["Dreadmist Leggings"] = "поножі імли жаху",
        ["Dreadmist Leggings (Provided)"] = "поножі імли жаху (видано)",
        ["Dreadmist Mantle"] = "напліччя імли жаху",
        ["Dreadmist Mantle (Provided)"] = "напліччя імли жаху (видано)",
        ["Dreadmist Sandals"] = "сандалі імли жаху",
        ["Dreadmist Sandals (Provided)"] = "сандалі імли жаху (видано)",
    },
    [8959] = {
        ["Boots of Valor"] = "чоботи доблесті",
        ["Boots of Valor (Provided)"] = "чоботи доблесті (видано)",
        ["Legplates of Valor"] = "поножі доблесті",
        ["Legplates of Valor (Provided)"] = "поножі доблесті (видано)",
        ["Spaulders of Valor"] = "наплічники доблесті",
        ["Spaulders of Valor (Provided)"] = "наплічники доблесті (видано)",
    },
    [8961] = {
        ["Cinder of Cynders"] = "попіл герцога попелу",
        ["Cinder of Cynders (Provided)"] = "попіл герцога попелу (видано)",
        ["Ember of Emberseer"] = "вуглинка Вуглегляда",
        ["Ember of Emberseer (Provided)"] = "вуглинка Вуглегляда (видано)",
        ["Hallowed Brazier"] = "освячена жаровня",
        ["Hallowed Brazier (Provided)"] = "освячена жаровня (видано)",
        ["Incendicite of Incendius"] = "спалахіт Спалахія",
        ["Incendicite of Incendius (Provided)"] = "спалахіт Спалахія (видано)",
    },
    [8962] = {
        ["Druidical Remains"] = "друїдські останки",
        ["Druidical Remains (Provided)"] = "друїдські останки (видано)",
    },
    [8963] = {
        ["Starbreeze Village Relic"] = "реліквія Зоряного Бризу",
        ["Starbreeze Village Relic (Provided)"] = "реліквія Зоряного Бризу (видано)",
    },
    [8964] = {
        ["Brilliant Sword of Zealotry"] = "блискучий меч фанатизму",
        ["Brilliant Sword of Zealotry (Provided)"] = "блискучий меч фанатизму (видано)",
    },
    [8965] = {
        ["Soul Ashes of the Banished"] = "попіл душі вигнанця",
        ["Soul Ashes of the Banished (Provided)"] = "попіл душі вигнанця (видано)",
    },
    [8966] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Left Piece of Lord Valthalak's Amulet (Provided)"] = "ліва частина амулета лорда Вальталака (видано)",
        ["Mor Grayhoof"] = "Мор Сиве Копито",
        ["Mor Grayhoof slain"] = "Мор Сиве Копито: убито",
    },
    [8967] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Isalien"] = "Ізалієн",
        ["Isalien slain"] = "Ізалієн: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Left Piece of Lord Valthalak's Amulet (Provided)"] = "ліва частина амулета лорда Вальталака (видано)",
    },
    [8968] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Jarien"] = "Ярієн",
        ["Jarien slain"] = "Ярієн: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Left Piece of Lord Valthalak's Amulet (Provided)"] = "ліва частина амулета лорда Вальталака (видано)",
        ["Sothos"] = "Сотос",
        ["Sothos slain"] = "Сотос: убито",
    },
    [8969] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Kormok"] = "Кормок",
        ["Kormok slain"] = "Кормок: убито",
        ["Left Piece of Lord Valthalak's Amulet"] = "ліва частина амулета лорда Вальталака",
        ["Left Piece of Lord Valthalak's Amulet (Provided)"] = "ліва частина амулета лорда Вальталака (видано)",
    },
    [8970] = {
        ["Bloodkelp"] = "кров'яниця",
        ["Bloodkelp (Provided)"] = "кров'яниця (видано)",
    },
    [8971] = {
        ["Homemade Bread"] = "домашній хліб",
        ["Pledge of Loyalty: Stormwind"] = "обітниця вірності зі Штормовію",
        ["Stormwind Guard's Card"] = "листівка вартового Штормовію",
    },
    [8972] = {
        ["Freshly Baked Pie"] = "свіжовипечений пиріг",
        ["Grunt's Card"] = "листівка бугая",
        ["Pledge of Loyalty: Orgrimmar"] = "обітниця вірності з Орґріммара",
    },
    [8973] = {
        ["Handmade Woodcraft"] = "дерев'яний виріб ручної роботи",
        ["Pledge of Loyalty: Darnassus"] = "обітниця вірності з Дарнаса",
        ["Sentinel's Card"] = "листівка стражниці",
    },
    [8974] = {
        ["Guardian's Moldy Card"] = "запліснявіла листівка вартового",
        ["Pledge of Loyalty: Undercity"] = "обітниця вірності з Підмістя",
        ["Romantic Poem"] = "романтичний вірш",
    },
    [8975] = {
        ["Bluffwatcher's Card"] = "листівка вартового бескиду",
        ["Freshly Picked Flowers"] = "свіжозібрані квіти",
        ["Pledge of Loyalty: Thunder Bluff"] = "обітниця вірності з Громового Бескиду",
    },
    [8976] = {
        ["Dwarven Homebrew"] = "дворфійське домашнє пиво",
        ["Ironforge Guard's Card"] = "листівка вартового Залізогарта",
        ["Pledge of Loyalty: Ironforge"] = "обітниця вірності з Залізогарта",
    },
    [8977] = {
        ["Extra-Dimensional Ghost Revealer"] = "міжвимірний шукач привидів",
        ["Extra-Dimensional Ghost Revealer (Provided)"] = "міжвимірний шукач привидів (видано)",
    },
    [8978] = {
        ["Extra-Dimensional Ghost Revealer"] = "міжвимірний шукач привидів",
        ["Extra-Dimensional Ghost Revealer (Provided)"] = "міжвимірний шукач привидів (видано)",
    },
    [8979] = {
        ["Cologne Bottle"] = "флакон одеколону",
        ["Cologne Bottle (Provided)"] = "флакон одеколону (видано)",
        ["Perfume Bottle"] = "флакон парфуму",
        ["Perfume Bottle (Provided)"] = "флакон парфуму (видано)",
    },
    [8981] = {
        ["Horde Gift Collection"] = "колекція дарів Орди",
        ["Horde Gift Collection (Provided)"] = "колекція дарів Орди (видано)",
    },
    [8985] = {
        ["Starbreeze Village Relic"] = "реліквія Зоряного Бризу",
        ["Starbreeze Village Relic (Provided)"] = "реліквія Зоряного Бризу (видано)",
    },
    [8986] = {
        ["Druidical Remains"] = "друїдські останки",
        ["Druidical Remains (Provided)"] = "друїдські останки (видано)",
    },
    [8987] = {
        ["Brilliant Sword of Zealotry"] = "блискучий меч фанатизму",
        ["Brilliant Sword of Zealotry (Provided)"] = "блискучий меч фанатизму (видано)",
    },
    [8988] = {
        ["Soul Ashes of the Banished"] = "попіл душі вигнанця",
        ["Soul Ashes of the Banished (Provided)"] = "попіл душі вигнанця (видано)",
    },
    [8989] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Lord Valthalak's Amulet (Provided)"] = "амулет лорда Вальталака (видано)",
        ["Mor Grayhoof"] = "Мор Сиве Копито",
        ["Mor Grayhoof slain"] = "Мор Сиве Копито: убито",
    },
    [8990] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Isalien"] = "Ізалієн",
        ["Isalien slain"] = "Ізалієн: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Lord Valthalak's Amulet (Provided)"] = "амулет лорда Вальталака (видано)",
    },
    [8991] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Jarien"] = "Ярієн",
        ["Jarien slain"] = "Ярієн: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Lord Valthalak's Amulet (Provided)"] = "амулет лорда Вальталака (видано)",
        ["Sothos"] = "Сотос",
        ["Sothos slain"] = "Сотос: убито",
    },
    [8992] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
        ["Kormok"] = "Кормок",
        ["Kormok slain"] = "Кормок: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Lord Valthalak's Amulet (Provided)"] = "амулет лорда Вальталака (видано)",
    },
    [8993] = {
        ["Alliance Gift Collection"] = "колекція дарів Альянсу",
        ["Alliance Gift Collection (Provided)"] = "колекція дарів Альянсу (видано)",
    },
    [8994] = {
        ["Blackrock Bracer"] = "поручі Чорнокаменю",
        ["Blackrock Bracer (Provided)"] = "поручі Чорнокаменю (видано)",
        ["Flask of Supreme Power"] = "настій великої сили",
        ["Flask of Supreme Power (Provided)"] = "настій великої сили (видано)",
    },
    [8995] = {
        ["Lord Valthalak"] = "Лорд Валталак",
        ["Lord Valthalak (Provided)"] = "Лорд Валталак (видано)",
        ["Lord Valthalak slain"] = "Лорд Валталак: убито",
        ["Lord Valthalak's Amulet"] = "амулет лорда Вальталака",
        ["Lord Valthalak's Amulet (Provided)"] = "амулет лорда Вальталака (видано)",
    },
    [8996] = {
        ["Brazier of Beckoning"] = "жаровня поклику",
        ["Brazier of Beckoning (Provided)"] = "жаровня поклику (видано)",
    },
    [8999] = {
        ["Wildheart Cowl"] = "капюшон дикого серця",
        ["Wildheart Cowl (Provided)"] = "капюшон дикого серця (видано)",
        ["Wildheart Vest"] = "жилет дикого серця",
        ["Wildheart Vest (Provided)"] = "жилет дикого серця (видано)",
    },
    [9000] = {
        ["Beaststalker's Cap"] = "шапка ловця звірів",
        ["Beaststalker's Cap (Provided)"] = "шапка ловця звірів (видано)",
        ["Beaststalker's Tunic"] = "мундир ловця звірів",
        ["Beaststalker's Tunic (Provided)"] = "мундир ловця звірів (видано)",
    },
    [9001] = {
        ["Magister's Crown"] = "корона магістра",
        ["Magister's Crown (Provided)"] = "корона магістра (видано)",
        ["Magister's Robes"] = "мантія магістра",
        ["Magister's Robes (Provided)"] = "мантія магістра (видано)",
    },
    [9002] = {
        ["Lightforge Breastplate"] = "світлокована кіраса",
        ["Lightforge Breastplate (Provided)"] = "світлокована кіраса (видано)",
        ["Lightforge Helm"] = "світлокований шолом",
        ["Lightforge Helm (Provided)"] = "світлокований шолом (видано)",
    },
    [9003] = {
        ["Devout Crown"] = "корона відданості",
        ["Devout Crown (Provided)"] = "корона відданості (видано)",
        ["Devout Robe"] = "мантія відданості",
        ["Devout Robe (Provided)"] = "мантія відданості (видано)",
    },
    [9004] = {
        ["Shadowcraft Cap"] = "шапка тіньового ремесла",
        ["Shadowcraft Cap (Provided)"] = "шапка тіньового ремесла (видано)",
        ["Shadowcraft Tunic"] = "мундир тіньового ремесла",
        ["Shadowcraft Tunic (Provided)"] = "мундир тіньового ремесла (видано)",
    },
    [9005] = {
        ["Dreadmist Mask"] = "маска імли жаху",
        ["Dreadmist Mask (Provided)"] = "маска імли жаху (видано)",
        ["Dreadmist Robe"] = "мантія імли жаху",
        ["Dreadmist Robe (Provided)"] = "мантія імли жаху (видано)",
    },
    [9006] = {
        ["Breastplate of Valor"] = "нагрудник доблесті",
        ["Breastplate of Valor (Provided)"] = "нагрудник доблесті (видано)",
        ["Helm of Valor"] = "шолом доблесті",
        ["Helm of Valor (Provided)"] = "шолом доблесті (видано)",
    },
    [9007] = {
        ["Wildheart Cowl"] = "капюшон дикого серця",
        ["Wildheart Cowl (Provided)"] = "капюшон дикого серця (видано)",
        ["Wildheart Vest"] = "жилет дикого серця",
        ["Wildheart Vest (Provided)"] = "жилет дикого серця (видано)",
    },
    [9008] = {
        ["Beaststalker's Cap"] = "шапка ловця звірів",
        ["Beaststalker's Cap (Provided)"] = "шапка ловця звірів (видано)",
        ["Beaststalker's Tunic"] = "мундир ловця звірів",
        ["Beaststalker's Tunic (Provided)"] = "мундир ловця звірів (видано)",
    },
    [9009] = {
        ["Devout Crown"] = "корона відданості",
        ["Devout Crown (Provided)"] = "корона відданості (видано)",
        ["Devout Robe"] = "мантія відданості",
        ["Devout Robe (Provided)"] = "мантія відданості (видано)",
    },
    [9010] = {
        ["Shadowcraft Cap"] = "шапка тіньового ремесла",
        ["Shadowcraft Cap (Provided)"] = "шапка тіньового ремесла (видано)",
        ["Shadowcraft Tunic"] = "мундир тіньового ремесла",
        ["Shadowcraft Tunic (Provided)"] = "мундир тіньового ремесла (видано)",
    },
    [9011] = {
        ["Coif of Elements"] = "койф стихій",
        ["Coif of Elements (Provided)"] = "койф стихій (видано)",
        ["Vest of Elements"] = "жилет стихій",
        ["Vest of Elements (Provided)"] = "жилет стихій (видано)",
    },
    [9012] = {
        ["Dreadmist Mask"] = "маска імли жаху",
        ["Dreadmist Mask (Provided)"] = "маска імли жаху (видано)",
        ["Dreadmist Robe"] = "мантія імли жаху",
        ["Dreadmist Robe (Provided)"] = "мантія імли жаху (видано)",
    },
    [9013] = {
        ["Breastplate of Valor"] = "нагрудник доблесті",
        ["Breastplate of Valor (Provided)"] = "нагрудник доблесті (видано)",
        ["Helm of Valor"] = "шолом доблесті",
        ["Helm of Valor (Provided)"] = "шолом доблесті (видано)",
    },
    [9014] = {
        ["Magister's Crown"] = "корона магістра",
        ["Magister's Crown (Provided)"] = "корона магістра (видано)",
        ["Magister's Robes"] = "мантія магістра",
        ["Magister's Robes (Provided)"] = "мантія магістра (видано)",
    },
    [9015] = {
        ["Theldren's Team Defeated"] = "Команда Телдрена зазнала поразки",
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
        ["Top Piece of Lord Valthalak's Amulet (Provided)"] = "верхня частина амулету лорда Вальталака (видано)",
    },
    [9016] = {
        ["Wildheart Boots"] = "чоботи дикого серця",
        ["Wildheart Boots (Provided)"] = "чоботи дикого серця (видано)",
        ["Wildheart Kilt"] = "кілт дикого серця",
        ["Wildheart Kilt (Provided)"] = "кілт дикого серця (видано)",
        ["Wildheart Spaulders"] = "наплічники дикого серця",
        ["Wildheart Spaulders (Provided)"] = "наплічники дикого серця (видано)",
    },
    [9017] = {
        ["Beaststalker's Boots"] = "чоботи ловця звірів",
        ["Beaststalker's Boots (Provided)"] = "чоботи ловця звірів (видано)",
        ["Beaststalker's Mantle"] = "напліччя ловця звірів",
        ["Beaststalker's Mantle (Provided)"] = "напліччя ловця звірів (видано)",
        ["Beaststalker's Pants"] = "штани ловця звірів",
        ["Beaststalker's Pants (Provided)"] = "штани ловця звірів (видано)",
    },
    [9018] = {
        ["Magister's Boots"] = "чоботи магістра",
        ["Magister's Boots (Provided)"] = "чоботи магістра (видано)",
        ["Magister's Leggings"] = "поножі магістра",
        ["Magister's Leggings (Provided)"] = "поножі магістра (видано)",
        ["Magister's Mantle"] = "напліччя магістра",
        ["Magister's Mantle (Provided)"] = "напліччя магістра (видано)",
    },
    [9019] = {
        ["Devout Mantle"] = "напліччя відданості",
        ["Devout Mantle (Provided)"] = "напліччя відданості (видано)",
        ["Devout Sandals"] = "сандалі відданості",
        ["Devout Sandals (Provided)"] = "сандалі відданості (видано)",
        ["Devout Skirt"] = "спідниця відданості",
        ["Devout Skirt (Provided)"] = "спідниця відданості (видано)",
    },
    [9020] = {
        ["Shadowcraft Boots"] = "чоботи тіньового ремесла",
        ["Shadowcraft Boots (Provided)"] = "чоботи тіньового ремесла (видано)",
        ["Shadowcraft Pants"] = "штани тіньового ремесла",
        ["Shadowcraft Pants (Provided)"] = "штани тіньового ремесла (видано)",
        ["Shadowcraft Spaulders"] = "наплічники тіньового ремесла",
        ["Shadowcraft Spaulders (Provided)"] = "наплічники тіньового ремесла (видано)",
    },
    [9021] = {
        ["Dreadmist Leggings"] = "поножі імли жаху",
        ["Dreadmist Leggings (Provided)"] = "поножі імли жаху (видано)",
        ["Dreadmist Mantle"] = "напліччя імли жаху",
        ["Dreadmist Mantle (Provided)"] = "напліччя імли жаху (видано)",
        ["Dreadmist Sandals"] = "сандалі імли жаху",
        ["Dreadmist Sandals (Provided)"] = "сандалі імли жаху (видано)",
    },
    [9022] = {
        ["Boots of Valor"] = "чоботи доблесті",
        ["Boots of Valor (Provided)"] = "чоботи доблесті (видано)",
        ["Legplates of Valor"] = "поножі доблесті",
        ["Legplates of Valor (Provided)"] = "поножі доблесті (видано)",
        ["Spaulders of Valor"] = "наплічники доблесті",
        ["Spaulders of Valor (Provided)"] = "наплічники доблесті (видано)",
    },
    [9023] = {
        ["Kurinnaxx's Venom Sac"] = "отруйна залоза Куріннакса",
        ["Kurinnaxx's Venom Sac (Provided)"] = "отруйна залоза Куріннакса (видано)",
        ["Venoxis's Venom Sac"] = "отруйна залоза Веноксіса",
        ["Venoxis's Venom Sac (Provided)"] = "отруйна залоза Веноксіса (видано)",
    },
    [9024] = {
        ["Cologne Bottle"] = "флакон одеколону",
        ["Cologne Bottle (Provided)"] = "флакон одеколону (видано)",
        ["Perfume Bottle"] = "флакон парфуму",
        ["Perfume Bottle (Provided)"] = "флакон парфуму (видано)",
    },
    [9033] = {
        ["Deathknight Captain"] = "капітан лицарів смерті",
        ["Deathknight Captain slain"] = "капітан лицарів смерті: убито",
        ["Living Monstrosity"] = "ходяче чудовисько",
        ["Living Monstrosity slain"] = "ходяче чудовисько: убито",
        ["Stoneskin Gargoyle"] = "каменешкірий гаргуйль",
        ["Stoneskin Gargoyle slain"] = "каменешкірий гаргуйль: убито",
        ["Venom Stalker"] = "отруйний ловець",
        ["Venom Stalker slain"] = "отруйний ловець: убито",
    },
    [9034] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Breastplate"] = "осквернена кіраса",
        ["Desecrated Breastplate (Provided)"] = "осквернена кіраса (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9036] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Legplates"] = "осквернені ножні лати",
        ["Desecrated Legplates (Provided)"] = "осквернені ножні лати (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9037] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Helmet"] = "осквернений шолом",
        ["Desecrated Helmet (Provided)"] = "осквернений шолом (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9038] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Pauldrons"] = "осквернене напліччя",
        ["Desecrated Pauldrons (Provided)"] = "осквернене напліччя (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9039] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Sabatons"] = "осквернені сабатони",
        ["Desecrated Sabatons (Provided)"] = "осквернені сабатони (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9040] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Gauntlets"] = "осквернені рукавиці",
        ["Desecrated Gauntlets (Provided)"] = "осквернені рукавиці (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9041] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Waistguard"] = "осквернений ремінь",
        ["Desecrated Waistguard (Provided)"] = "осквернений ремінь (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9042] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Bracers"] = "осквернені поручі",
        ["Desecrated Bracers (Provided)"] = "осквернені поручі (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9043] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Desecrated Tunic (Provided)"] = "осквернений мундир (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9044] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Desecrated Legguards (Provided)"] = "осквернені поножі (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9045] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Desecrated Headpiece (Provided)"] = "осквернений головний убір (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9046] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Desecrated Spaulders (Provided)"] = "осквернені наплечі (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9047] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Desecrated Boots (Provided)"] = "осквернені чоботи (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9048] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Desecrated Handguards (Provided)"] = "осквернені бойові рукавиці (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9049] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Desecrated Girdle (Provided)"] = "осквернений пасок (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9050] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Desecrated Wristguards (Provided)"] = "осквернені наручі (видано)",
        ["Wartorn Plate Scrap"] = "понівечений обрізок лат",
        ["Wartorn Plate Scrap (Provided)"] = "понівечений обрізок лат (видано)",
    },
    [9051] = {
        ["Devilsaur stabbed with barb"] = "Дияволзавра вдарили колючою головкою",
    },
    [9052] = {
        ["Bloodcap"] = "кровошляп",
        ["Bloodcap (Provided)"] = "кровошляп (видано)",
        ["Gorishi Sting"] = "жало Ґоріші",
        ["Gorishi Sting (Provided)"] = "жало Ґоріші (видано)",
    },
    [9053] = {
        ["Putrid Vine"] = "гнила лоза",
        ["Putrid Vine (Provided)"] = "гнила лоза (видано)",
    },
    [9054] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Desecrated Tunic (Provided)"] = "осквернений мундир (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9055] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Desecrated Legguards (Provided)"] = "осквернені поножі (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9056] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Desecrated Headpiece (Provided)"] = "осквернений головний убір (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9057] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Desecrated Spaulders (Provided)"] = "осквернені наплечі (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9058] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Desecrated Boots (Provided)"] = "осквернені чоботи (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9059] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Desecrated Handguards (Provided)"] = "осквернені бойові рукавиці (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9060] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Desecrated Girdle (Provided)"] = "осквернений пасок (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9061] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Desecrated Wristguards (Provided)"] = "осквернені наручі (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9068] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Desecrated Tunic (Provided)"] = "осквернений мундир (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9069] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Desecrated Legguards (Provided)"] = "осквернені поножі (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9070] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Desecrated Headpiece (Provided)"] = "осквернений головний убір (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9071] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Desecrated Spaulders (Provided)"] = "осквернені наплечі (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9072] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Desecrated Boots (Provided)"] = "осквернені чоботи (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9073] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Desecrated Handguards (Provided)"] = "осквернені бойові рукавиці (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9074] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Desecrated Girdle (Provided)"] = "осквернений пасок (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9075] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Desecrated Wristguards (Provided)"] = "осквернені наручі (видано)",
        ["Wartorn Chain Scrap"] = "понівечений обрізок кольчуги",
        ["Wartorn Chain Scrap (Provided)"] = "понівечений обрізок кольчуги (видано)",
    },
    [9077] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Breastplate"] = "осквернена кіраса",
        ["Desecrated Breastplate (Provided)"] = "осквернена кіраса (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9078] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Legplates"] = "осквернені ножні лати",
        ["Desecrated Legplates (Provided)"] = "осквернені ножні лати (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9079] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Helmet"] = "осквернений шолом",
        ["Desecrated Helmet (Provided)"] = "осквернений шолом (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9080] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Pauldrons"] = "осквернене напліччя",
        ["Desecrated Pauldrons (Provided)"] = "осквернене напліччя (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9081] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Sabatons"] = "осквернені сабатони",
        ["Desecrated Sabatons (Provided)"] = "осквернені сабатони (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9082] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Gauntlets"] = "осквернені рукавиці",
        ["Desecrated Gauntlets (Provided)"] = "осквернені рукавиці (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9083] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Waistguard"] = "осквернений ремінь",
        ["Desecrated Waistguard (Provided)"] = "осквернений ремінь (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9084] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Bracers"] = "осквернені поручі",
        ["Desecrated Bracers (Provided)"] = "осквернені поручі (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9085] = {
        ["Shadow of Doom"] = "тінь приречення",
        ["Shadow of Doom slain"] = "тінь приречення: убито",
    },
    [9086] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Tunic"] = "осквернений мундир",
        ["Desecrated Tunic (Provided)"] = "осквернений мундир (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9087] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Legguards"] = "осквернені поножі",
        ["Desecrated Legguards (Provided)"] = "осквернені поножі (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9088] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Headpiece"] = "осквернений головний убір",
        ["Desecrated Headpiece (Provided)"] = "осквернений головний убір (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9089] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Spaulders"] = "осквернені наплечі",
        ["Desecrated Spaulders (Provided)"] = "осквернені наплечі (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9090] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Boots"] = "осквернені чоботи",
        ["Desecrated Boots (Provided)"] = "осквернені чоботи (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9091] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Handguards"] = "осквернені бойові рукавиці",
        ["Desecrated Handguards (Provided)"] = "осквернені бойові рукавиці (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9092] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Girdle"] = "осквернений пасок",
        ["Desecrated Girdle (Provided)"] = "осквернений пасок (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9093] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Wristguards"] = "осквернені наручі",
        ["Desecrated Wristguards (Provided)"] = "осквернені наручі (видано)",
        ["Wartorn Leather Scrap"] = "понівечений обрізок шкіри",
        ["Wartorn Leather Scrap (Provided)"] = "понівечений обрізок шкіри (видано)",
    },
    [9094] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9095] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Desecrated Robe (Provided)"] = "осквернена мантія (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9096] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Desecrated Leggings (Provided)"] = "осквернені штани (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9097] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Desecrated Circlet (Provided)"] = "осквернений вінець (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9098] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Desecrated Shoulderpads (Provided)"] = "осквернені наплічники (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9099] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Desecrated Sandals (Provided)"] = "осквернені сандалі (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9100] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Desecrated Gloves (Provided)"] = "осквернені рукавички (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9101] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Desecrated Belt (Provided)"] = "осквернений пояс (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9102] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Desecrated Bindings (Provided)"] = "осквернені браслети (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9103] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Desecrated Robe (Provided)"] = "осквернена мантія (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9104] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Desecrated Leggings (Provided)"] = "осквернені штани (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9105] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Desecrated Circlet (Provided)"] = "осквернений вінець (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9106] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Desecrated Shoulderpads (Provided)"] = "осквернені наплічники (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9107] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Desecrated Sandals (Provided)"] = "осквернені сандалі (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9108] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Desecrated Gloves (Provided)"] = "осквернені рукавички (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9109] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Desecrated Belt (Provided)"] = "осквернений пояс (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9110] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Desecrated Bindings (Provided)"] = "осквернені браслети (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9111] = {
        ["Desecrated Robe"] = "осквернена мантія",
        ["Desecrated Robe (Provided)"] = "осквернена мантія (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9112] = {
        ["Desecrated Leggings"] = "осквернені штани",
        ["Desecrated Leggings (Provided)"] = "осквернені штани (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9113] = {
        ["Desecrated Circlet"] = "осквернений вінець",
        ["Desecrated Circlet (Provided)"] = "осквернений вінець (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9114] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Shoulderpads"] = "осквернені наплічники",
        ["Desecrated Shoulderpads (Provided)"] = "осквернені наплічники (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9115] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Desecrated Sandals"] = "осквернені сандалі",
        ["Desecrated Sandals (Provided)"] = "осквернені сандалі (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9116] = {
        ["Desecrated Gloves"] = "осквернені рукавички",
        ["Desecrated Gloves (Provided)"] = "осквернені рукавички (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9117] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Belt"] = "осквернений пояс",
        ["Desecrated Belt (Provided)"] = "осквернений пояс (видано)",
        ["Mooncloth"] = "місячне полотно",
        ["Mooncloth (Provided)"] = "місячне полотно (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9118] = {
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Desecrated Bindings"] = "осквернені браслети",
        ["Desecrated Bindings (Provided)"] = "осквернені браслети (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Wartorn Cloth Scrap"] = "понівечений обрізок тканини",
        ["Wartorn Cloth Scrap (Provided)"] = "понівечений обрізок тканини (видано)",
    },
    [9120] = {
        ["The Phylactery of Kel'Thuzad"] = "філактерія Кел'Тузада",
        ["The Phylactery of Kel'Thuzad (Provided)"] = "філактерія Кел'Тузада (видано)",
    },
    [9121] = {
        ["9000 reputation with Argent Dawn"] = "9000 репутації у Сріблястого Світанку",
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
        ["Righteous Orb"] = "сфера праведності",
        ["Righteous Orb (Provided)"] = "сфера праведності (видано)",
    },
    [9122] = {
        ["21000 reputation with Argent Dawn"] = "21000 репутації у Сріблястого Світанку",
        ["Arcane Crystal"] = "арканічний кристал",
        ["Arcane Crystal (Provided)"] = "арканічний кристал (видано)",
        ["Nexus Crystal"] = "кристал сплетіння",
        ["Nexus Crystal (Provided)"] = "кристал сплетіння (видано)",
    },
    [9123] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
    },
    [9124] = {
        ["Crypt Fiend Parts"] = "частини тіл склепної нечисті",
        ["Crypt Fiend Parts (Provided)"] = "частини тіл склепної нечисті (видано)",
    },
    [9125] = {
        ["Crypt Fiend Parts"] = "частини тіл склепної нечисті",
        ["Crypt Fiend Parts (Provided)"] = "частини тіл склепної нечисті (видано)",
    },
    [9126] = {
        ["Bone Fragments"] = "фрагменти кісток",
        ["Bone Fragments (Provided)"] = "фрагменти кісток (видано)",
    },
    [9127] = {
        ["Bone Fragments"] = "фрагменти кісток",
        ["Bone Fragments (Provided)"] = "фрагменти кісток (видано)",
    },
    [9128] = {
        ["Core of Elements"] = "ядро стихій",
        ["Core of Elements (Provided)"] = "ядро стихій (видано)",
    },
    [9129] = {
        ["Core of Elements"] = "ядро стихій",
        ["Core of Elements (Provided)"] = "ядро стихій (видано)",
    },
    [9131] = {
        ["Dark Iron Scraps"] = "брухт темного заліза",
        ["Dark Iron Scraps (Provided)"] = "брухт темного заліза (видано)",
    },
    [9132] = {
        ["Dark Iron Scraps"] = "брухт темного заліза",
        ["Dark Iron Scraps (Provided)"] = "брухт темного заліза (видано)",
    },
    [9136] = {
        ["Savage Frond"] = "дикий пагін",
        ["Savage Frond (Provided)"] = "дикий пагін (видано)",
    },
    [9137] = {
        ["Savage Frond"] = "дикий пагін",
        ["Savage Frond (Provided)"] = "дикий пагін (видано)",
    },
    [9141] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [9142] = {
        ["Argent Dawn Valor Token"] = "знак доблесті Сріблястого Світанку",
        ["Argent Dawn Valor Token (Provided)"] = "знак доблесті Сріблястого Світанку (видано)",
    },
    [9153] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9154] = {
        ["Call to Arms Announcement"] = "оголошення про заклик до зброї",
        ["Call to Arms Announcement (Provided)"] = "оголошення про заклик до зброї (видано)",
    },
    [9165] = {
        ["Writ of Safe Passage"] = "подяка за супровід",
        ["Writ of Safe Passage (Provided)"] = "подяка за супровід (видано)",
        ["Writ of Safe Passage Signed"] = "Підписано ордер на безпечний прохід",
        ["Writ of Safe Passage Signed (Provided)"] = "Підписано ордер на безпечний прохід (видано)",
        ["Writ of Safe Passage Signed slain"] = "Підписано ордер на безпечний прохід: убито",
    },
    [9178] = {
        ["Craftsman's Writ - Dense Weightstone"] = "замовлення майстра — масивне грузило",
        ["Craftsman's Writ - Dense Weightstone (Provided)"] = "замовлення майстра — масивне грузило (видано)",
        ["Dense Weightstone"] = "масивне грузило",
        ["Dense Weightstone (Provided)"] = "масивне грузило (видано)",
    },
    [9179] = {
        ["Craftsman's Writ - Imperial Plate Chest"] = "замовлення майстра — імперська латна кіраса",
        ["Craftsman's Writ - Imperial Plate Chest (Provided)"] = "замовлення майстра — імперська латна кіраса (видано)",
        ["Imperial Plate Chest"] = "імперська латна кіраса",
        ["Imperial Plate Chest (Provided)"] = "імперська латна кіраса (видано)",
    },
    [9181] = {
        ["Craftsman's Writ - Volcanic Hammer"] = "замовлення майстра — вулканічний молот",
        ["Craftsman's Writ - Volcanic Hammer (Provided)"] = "замовлення майстра — вулканічний молот (видано)",
        ["Volcanic Hammer"] = "вулканічний молот",
        ["Volcanic Hammer (Provided)"] = "вулканічний молот (видано)",
    },
    [9182] = {
        ["Craftsman's Writ - Huge Thorium Battleaxe"] = "замовлення майстра — величезна торієва бойова сокира",
        ["Craftsman's Writ - Huge Thorium Battleaxe (Provided)"] = "замовлення майстра — величезна торієва бойова сокира (видано)",
        ["Huge Thorium Battleaxe"] = "величезна торієва бойова сокира",
        ["Huge Thorium Battleaxe (Provided)"] = "величезна торієва бойова сокира (видано)",
    },
    [9183] = {
        ["Craftsman's Writ - Radiant Circlet"] = "замовлення майстра — променистий вінець",
        ["Craftsman's Writ - Radiant Circlet (Provided)"] = "замовлення майстра — променистий вінець (видано)",
        ["Radiant Circlet"] = "променистий вінець",
        ["Radiant Circlet (Provided)"] = "променистий вінець (видано)",
    },
    [9184] = {
        ["Craftsman's Writ - Wicked Leather Headband"] = "замовлення майстра — лиха шкіряна бандана",
        ["Craftsman's Writ - Wicked Leather Headband (Provided)"] = "замовлення майстра — лиха шкіряна бандана (видано)",
        ["Wicked Leather Headband"] = "лиха шкіряна бандана",
        ["Wicked Leather Headband (Provided)"] = "лиха шкіряна бандана (видано)",
    },
    [9185] = {
        ["Craftsman's Writ - Rugged Armor Kit"] = "замовлення майстра — накладки з міцної шкіри",
        ["Craftsman's Writ - Rugged Armor Kit (Provided)"] = "замовлення майстра — накладки з міцної шкіри (видано)",
        ["Rugged Armor Kit"] = "накладки з міцної шкіри",
        ["Rugged Armor Kit (Provided)"] = "накладки з міцної шкіри (видано)",
    },
    [9186] = {
        ["Craftsman's Writ - Wicked Leather Belt"] = "замовлення майстра — лихий шкіряний пояс",
        ["Craftsman's Writ - Wicked Leather Belt (Provided)"] = "замовлення майстра — лихий шкіряний пояс (видано)",
        ["Wicked Leather Belt"] = "лихий шкіряний пояс",
        ["Wicked Leather Belt (Provided)"] = "лихий шкіряний пояс (видано)",
    },
    [9187] = {
        ["Craftsman's Writ - Runic Leather Pants"] = "замовлення майстра — рунічні шкіряні штани",
        ["Craftsman's Writ - Runic Leather Pants (Provided)"] = "замовлення майстра — рунічні шкіряні штани (видано)",
        ["Runic Leather Pants"] = "рунічні шкіряні штани",
        ["Runic Leather Pants (Provided)"] = "рунічні шкіряні штани (видано)",
    },
    [9188] = {
        ["Brightcloth Pants"] = "сяйнополотняні штани",
        ["Brightcloth Pants (Provided)"] = "сяйнополотняні штани (видано)",
        ["Craftsman's Writ - Brightcloth Pants"] = "замовлення майстра — сяйнополотняні штани",
        ["Craftsman's Writ - Brightcloth Pants (Provided)"] = "замовлення майстра — сяйнополотняні штани (видано)",
    },
    [9190] = {
        ["Craftsman's Writ - Runecloth Boots"] = "замовлення майстра — сумка з рунічного полотна",
        ["Craftsman's Writ - Runecloth Boots (Provided)"] = "замовлення майстра — сумка з рунічного полотна (видано)",
        ["Runecloth Boots"] = "чоботи з рунічного полотна",
        ["Runecloth Boots (Provided)"] = "чоботи з рунічного полотна (видано)",
    },
    [9191] = {
        ["Craftsman's Writ - Runecloth Bag"] = "замовлення майстра — сумка з рунічного полотна",
        ["Craftsman's Writ - Runecloth Bag (Provided)"] = "замовлення майстра — сумка з рунічного полотна (видано)",
        ["Runecloth Bag"] = "сумка з рунічного полотна",
        ["Runecloth Bag (Provided)"] = "сумка з рунічного полотна (видано)",
    },
    [9194] = {
        ["Craftsman's Writ - Runecloth Robe"] = "замовлення майстра — вбрання з рунічного полотна",
        ["Craftsman's Writ - Runecloth Robe (Provided)"] = "замовлення майстра — вбрання з рунічного полотна (видано)",
        ["Runecloth Robe"] = "вбрання з рунічного полотна",
        ["Runecloth Robe (Provided)"] = "вбрання з рунічного полотна (видано)",
    },
    [9195] = {
        ["Craftsman's Writ - Goblin Sapper Charge"] = "замовлення майстра — гоблінський саперний заряд",
        ["Craftsman's Writ - Goblin Sapper Charge (Provided)"] = "замовлення майстра — гоблінський саперний заряд (видано)",
        ["Goblin Sapper Charge"] = "гоблінський саперний заряд",
        ["Goblin Sapper Charge (Provided)"] = "гоблінський саперний заряд (видано)",
    },
    [9196] = {
        ["Craftsman's Writ - Thorium Grenade"] = "замовлення майстра — торієва граната",
        ["Craftsman's Writ - Thorium Grenade (Provided)"] = "замовлення майстра — торієва граната (видано)",
        ["Thorium Grenade"] = "торієва граната",
        ["Thorium Grenade (Provided)"] = "торієва граната (видано)",
    },
    [9197] = {
        ["Craftsman's Writ - Gnomish Battle Chicken"] = "замовлення майстра — гномське бойове курча",
        ["Craftsman's Writ - Gnomish Battle Chicken (Provided)"] = "замовлення майстра — гномське бойове курча (видано)",
        ["Gnomish Battle Chicken"] = "гномське бойове курча",
        ["Gnomish Battle Chicken (Provided)"] = "гномське бойове курча (видано)",
    },
    [9198] = {
        ["Craftsman's Writ - Thorium Tube"] = "замовлення майстра — торієва трубка",
        ["Craftsman's Writ - Thorium Tube (Provided)"] = "замовлення майстра — торієва трубка (видано)",
        ["Thorium Tube"] = "торієва трубка",
        ["Thorium Tube (Provided)"] = "торієва трубка (видано)",
    },
    [9200] = {
        ["Craftsman's Writ - Major Mana Potion"] = "замовлення майстра — величезне зілля мани",
        ["Craftsman's Writ - Major Mana Potion (Provided)"] = "замовлення майстра — величезне зілля мани (видано)",
        ["Major Mana Potion"] = "величезне зілля мани",
        ["Major Mana Potion (Provided)"] = "величезне зілля мани (видано)",
    },
    [9201] = {
        ["Craftsman's Writ - Greater Arcane Protection Potion"] = "замовлення майстра — велике зілля арканічного захисту",
        ["Craftsman's Writ - Greater Arcane Protection Potion (Provided)"] = "замовлення майстра — велике зілля арканічного захисту (видано)",
        ["Greater Arcane Protection Potion"] = "велике зілля арканічного захисту",
        ["Greater Arcane Protection Potion (Provided)"] = "велике зілля арканічного захисту (видано)",
    },
    [9202] = {
        ["Craftsman's Writ - Major Healing Potion"] = "замовлення майстра — величезне зілля лікування",
        ["Craftsman's Writ - Major Healing Potion (Provided)"] = "замовлення майстра — величезне зілля лікування (видано)",
        ["Major Healing Potion"] = "величезне зілля лікування",
        ["Major Healing Potion (Provided)"] = "величезне зілля лікування (видано)",
    },
    [9203] = {
        ["Craftsman's Writ - Flask of Petrification"] = "замовлення майстра — настій скам'яніння",
        ["Craftsman's Writ - Flask of Petrification (Provided)"] = "замовлення майстра — настій скам'яніння (видано)",
        ["Flask of Petrification"] = "настій скам'яніння",
        ["Flask of Petrification (Provided)"] = "настій скам'яніння (видано)",
    },
    [9204] = {
        ["Craftsman's Writ - Stonescale Eel"] = "замовлення майстра — камнелуский вугор",
        ["Craftsman's Writ - Stonescale Eel (Provided)"] = "замовлення майстра — камнелуский вугор (видано)",
        ["Stonescale Eel"] = "камнелуский вугор",
        ["Stonescale Eel (Provided)"] = "камнелуский вугор (видано)",
    },
    [9205] = {
        ["Craftsman's Writ - Plated Armorfish"] = "замовлення майстра — риба-броненосець",
        ["Craftsman's Writ - Plated Armorfish (Provided)"] = "замовлення майстра — риба-броненосець (видано)",
        ["Plated Armorfish"] = "риба-броненосець",
        ["Plated Armorfish (Provided)"] = "риба-броненосець (видано)",
    },
    [9206] = {
        ["Craftsman's Writ - Lightning Eel"] = "замовлення майстра — блискавковий вугор",
        ["Craftsman's Writ - Lightning Eel (Provided)"] = "замовлення майстра — блискавковий вугор (видано)",
        ["Lightning Eel"] = "блискавковий вугор",
        ["Lightning Eel (Provided)"] = "блискавковий вугор (видано)",
    },
    [9208] = {
        ["Arcanum of Protection"] = "магічний камінь захисту",
        ["Arcanum of Protection (Provided)"] = "магічний камінь захисту (видано)",
    },
    [9209] = {
        ["Arcanum of Rapidity"] = "магічний камінь прудкості",
        ["Arcanum of Rapidity (Provided)"] = "магічний камінь прудкості (видано)",
    },
    [9210] = {
        ["Arcanum of Focus"] = "магічний камінь зосередження",
        ["Arcanum of Focus (Provided)"] = "магічний камінь зосередження (видано)",
    },
    [9211] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
    },
    [9213] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
    },
    [9221] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9222] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9223] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9224] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9225] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9226] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9227] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9228] = {
        ["Insignia of the Crusade"] = "відзнака Багряного Походу",
        ["Insignia of the Crusade (Provided)"] = "відзнака Багряного Походу (видано)",
        ["Insignia of the Dawn"] = "відзнака Світанку",
        ["Insignia of the Dawn (Provided)"] = "відзнака Світанку (видано)",
    },
    [9229] = {
        ["Fate of Ramaladni"] = "доля Рамаладні",
        ["Fate of Ramaladni (Provided)"] = "доля Рамаладні (видано)",
    },
    [9230] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Blue Sapphire"] = "синій сапфір",
        ["Blue Sapphire (Provided)"] = "синій сапфір (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
    },
    [9232] = {
        ["Blue Sapphire"] = "синій сапфір",
        ["Blue Sapphire (Provided)"] = "синій сапфір (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
    },
    [9233] = {
        ["Omarion's Handbook"] = "довідник Омаріона",
        ["Omarion's Handbook (Provided)"] = "довідник Омаріона (видано)",
    },
    [9234] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [9235] = {
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [9236] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Arcanite Bar"] = "злиток арканіту",
        ["Arcanite Bar (Provided)"] = "злиток арканіту (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Thorium Bar"] = "злиток торію",
        ["Thorium Bar (Provided)"] = "злиток торію (видано)",
    },
    [9237] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
    },
    [9238] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
    },
    [9239] = {
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
    },
    [9240] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Bolt of Runecloth"] = "рулон рунічної тканини",
        ["Bolt of Runecloth (Provided)"] = "рулон рунічної тканини (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Ironweb Spider Silk"] = "залізошовкова павутина",
        ["Ironweb Spider Silk (Provided)"] = "залізошовкова павутина (видано)",
    },
    [9241] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
    },
    [9242] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
    },
    [9243] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Enchanted Leather"] = "зачарована шкіра",
        ["Enchanted Leather (Provided)"] = "зачарована шкіра (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
    },
    [9244] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
        ["Heavy Scorpid Scale (Provided)"] = "важка луска скорпіда (видано)",
    },
    [9245] = {
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
        ["Heavy Scorpid Scale (Provided)"] = "важка луска скорпіда (видано)",
    },
    [9246] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
        ["Cured Rugged Hide"] = "оброблена міцна шкура",
        ["Cured Rugged Hide (Provided)"] = "оброблена міцна шкура (видано)",
        ["Essence of Water"] = "сутність води",
        ["Essence of Water (Provided)"] = "сутність води (видано)",
        ["Frozen Rune"] = "морозна руна",
        ["Frozen Rune (Provided)"] = "морозна руна (видано)",
        ["Heavy Scorpid Scale"] = "важка луска скорпіда",
        ["Heavy Scorpid Scale (Provided)"] = "важка луска скорпіда (видано)",
    },
    [9247] = {
        ["A Letter from the Keeper of the Rolls"] = "лист від Архіваріуса",
        ["A Letter from the Keeper of the Rolls (Provided)"] = "лист від Архіваріуса (видано)",
    },
    [9248] = {
        ["9000 reputation with Cenarion Circle"] = "9000 репутації у Колі Кенаріона",
        ["Abyssal Scepter"] = "скіпетр безодні",
        ["Abyssal Scepter (Provided)"] = "скіпетр безодні (видано)",
    },
    [9249] = {
        ["Item #19182"] = "Товар №19182",
    },
    [9250] = {
        ["Frame of Atiesh"] = "каркас Атієша",
        ["Frame of Atiesh (Provided)"] = "каркас Атієша (видано)",
    },
    [9251] = {
        ["Base of Atiesh"] = "основа Атієша",
        ["Base of Atiesh (Provided)"] = "основа Атієша (видано)",
        ["Staff Head of Atiesh"] = "верхів'я Атієша",
        ["Staff Head of Atiesh (Provided)"] = "верхів'я Атієша (видано)",
    },
    [9257] = {
        ["Atiesh Cleansed"] = "Атієш Очищений",
        ["Atiesh Cleansed (Provided)"] = "Атієш Очищений (видано)",
        ["Atiesh Cleansed slain"] = "Атієш Очищений: убито",
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
        ["Atiesh, Greatstaff of the Guardian (Provided)"] = "Атієш, великий посох Вартівника (видано)",
    },
    [9259] = {
        ["Red Dye"] = "червоний барвник",
        ["Red Dye (Provided)"] = "червоний барвник (видано)",
        ["Silk Cloth"] = "шовкове полотно",
        ["Silk Cloth (Provided)"] = "шовкове полотно (видано)",
    },
    [9260] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9261] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9262] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9263] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9264] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9265] = {
        ["Dim Necrotic Stone"] = "тьмяний некротичний камінь",
        ["Dim Necrotic Stone (Provided)"] = "тьмяний некротичний камінь (видано)",
    },
    [9266] = {
        ["Coal"] = "вугілля",
        ["Coal (Provided)"] = "вугілля (видано)",
        ["Runecloth"] = "рунічне полотно",
        ["Runecloth (Provided)"] = "рунічне полотно (видано)",
    },
    [9267] = {
        ["Empty Vial"] = "порожній фіал",
        ["Empty Vial (Provided)"] = "порожній фіал (видано)",
        ["Linen Cloth"] = "лляна тканина",
        ["Linen Cloth (Provided)"] = "лляна тканина (видано)",
    },
    [9268] = {
        ["Mageweave Cloth"] = "маготкане полотно",
        ["Mageweave Cloth (Provided)"] = "маготкане полотно (видано)",
        ["Strong Flux"] = "сильний флюс",
        ["Strong Flux (Provided)"] = "сильний флюс (видано)",
    },
    [9269] = {
        ["Atiesh Cleansed"] = "Атієш Очищений",
        ["Atiesh Cleansed (Provided)"] = "Атієш Очищений (видано)",
        ["Atiesh Cleansed slain"] = "Атієш Очищений: убито",
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
        ["Atiesh, Greatstaff of the Guardian (Provided)"] = "Атієш, великий посох Вартівника (видано)",
    },
    [9270] = {
        ["Atiesh Cleansed"] = "Атієш Очищений",
        ["Atiesh Cleansed (Provided)"] = "Атієш Очищений (видано)",
        ["Atiesh Cleansed slain"] = "Атієш Очищений: убито",
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
        ["Atiesh, Greatstaff of the Guardian (Provided)"] = "Атієш, великий посох Вартівника (видано)",
    },
    [9271] = {
        ["Atiesh Cleansed"] = "Атієш Очищений",
        ["Atiesh Cleansed (Provided)"] = "Атієш Очищений (видано)",
        ["Atiesh Cleansed slain"] = "Атієш Очищений: убито",
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
        ["Atiesh, Greatstaff of the Guardian (Provided)"] = "Атієш, великий посох Вартівника (видано)",
    },
    [9273] = {
        ["iCoke Prize Voucher"] = "Призовий ваучер iCoke",
    },
    [9292] = {
        ["Cracked Necrotic Crystal"] = "тріснутий некротичний кристал",
        ["Cracked Necrotic Crystal (Provided)"] = "тріснутий некротичний кристал (видано)",
    },
    [9295] = {
        ["A Torn Letter"] = "порваний лист",
        ["A Torn Letter (Provided)"] = "порваний лист (видано)",
    },
    [9296] = {
        ["Cracked Necrotic Crystal"] = "тріснутий некротичний кристал",
        ["Cracked Necrotic Crystal (Provided)"] = "тріснутий некротичний кристал (видано)",
    },
    [9297] = {
        ["Cracked Necrotic Crystal"] = "тріснутий некротичний кристал",
        ["Cracked Necrotic Crystal (Provided)"] = "тріснутий некротичний кристал (видано)",
    },
    [9298] = {
        ["Cracked Necrotic Crystal"] = "тріснутий некротичний кристал",
        ["Cracked Necrotic Crystal (Provided)"] = "тріснутий некротичний кристал (видано)",
    },
    [9299] = {
        ["A Careworn Note"] = "потерта записка",
        ["A Careworn Note (Provided)"] = "потерта записка (видано)",
    },
    [9300] = {
        ["A Ragged Page"] = "пошарпана сторінка",
        ["A Ragged Page (Provided)"] = "пошарпана сторінка (видано)",
    },
    [9301] = {
        ["A Bloodstained Envelope"] = "закривавлений конверт",
        ["A Bloodstained Envelope (Provided)"] = "закривавлений конверт (видано)",
    },
    [9302] = {
        ["A Crumpled Missive"] = "зім'яте послання",
        ["A Crumpled Missive (Provided)"] = "зім'яте послання (видано)",
    },
    [9304] = {
        ["A Smudged Document"] = "вкритий брудом документ",
        ["A Smudged Document (Provided)"] = "вкритий брудом документ (видано)",
    },
    [9310] = {
        ["Faint Necrotic Crystal"] = "тьмяний некротичний кристал",
        ["Faint Necrotic Crystal (Provided)"] = "тьмяний некротичний кристал (видано)",
        ["Faint Necrotic Crystal slain"] = "тьмяний некротичний кристал: убито",
    },
    [9317] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9318] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9319] = {
        ["Flame of Blackrock Spire"] = "Полум'я Шпиля Чорної Скелі",
        ["Flame of Blackrock Spire (Provided)"] = "Полум'я Шпиля Чорної Скелі (видано)",
        ["Flame of Blackrock Spire slain"] = "Полум'я Шпиля Чорної Скелі: убито",
        ["Flame of Dire Maul"] = "Полум'я Запеклого Молота",
        ["Flame of Dire Maul (Provided)"] = "Полум'я Запеклого Молота (видано)",
        ["Flame of Dire Maul slain"] = "Полум'я Запеклого Молота: убито",
        ["Flame of Stratholme"] = "Полум'я Стратгольма",
        ["Flame of Stratholme (Provided)"] = "Полум'я Стратгольма (видано)",
        ["Flame of Stratholme slain"] = "Полум'я Стратгольма: убито",
        ["Flame of the Scholomance"] = "Полум'я Несхольності",
        ["Flame of the Scholomance (Provided)"] = "Полум'я Несхольності (видано)",
        ["Flame of the Scholomance slain"] = "Полум'я Несхольності: убито",
    },
    [9320] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9321] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9322] = {
        ["Flame of Azshara"] = "Полум'я Азшари",
        ["Flame of Azshara (Provided)"] = "Полум'я Азшари (видано)",
        ["Flame of Azshara slain"] = "Полум'я Азшари: убито",
        ["Flame of Silithus"] = "Полум'я Силітуса",
        ["Flame of Silithus (Provided)"] = "Полум'я Силітуса (видано)",
        ["Flame of Silithus slain"] = "Полум'я Силітуса: убито",
        ["Flame of Un'Goro"] = "Полум'я Ун'Горо",
        ["Flame of Un'Goro (Provided)"] = "Полум'я Ун'Горо (видано)",
        ["Flame of Un'Goro slain"] = "Полум'я Ун'Горо: убито",
        ["Flame of Winterspring"] = "Полум'я Зимоключа",
        ["Flame of Winterspring (Provided)"] = "Полум'я Зимоключа (видано)",
        ["Flame of Winterspring slain"] = "Полум'я Зимоключа: убито",
    },
    [9323] = {
        ["Flame of Searing Gorge"] = "Полум'я Палаючої Ущелини",
        ["Flame of Searing Gorge (Provided)"] = "Полум'я Палаючої Ущелини (видано)",
        ["Flame of Searing Gorge slain"] = "Полум'я Палаючої Ущелини: убито",
        ["Flame of the Blasted Lands"] = "Полум'я вируйнованої землі",
        ["Flame of the Blasted Lands (Provided)"] = "Полум'я вируйнованої землі (видано)",
        ["Flame of the Blasted Lands slain"] = "Полум'я вируйнованої землі: убито",
        ["Flame of the Hinterlands"] = "Полум'я глибинок",
        ["Flame of the Hinterlands (Provided)"] = "Полум'я глибинок (видано)",
        ["Flame of the Hinterlands slain"] = "Полум'я глибинок: убито",
        ["Flame of the Plaguelands"] = "Полум'я Чумних земель",
        ["Flame of the Plaguelands (Provided)"] = "Полум'я Чумних земель (видано)",
        ["Flame of the Plaguelands slain"] = "Полум'я Чумних земель: убито",
    },
    [9324] = {
        ["Flame of Orgrimmar"] = "полум'я Орґріммара",
        ["Flame of Orgrimmar (Provided)"] = "полум'я Орґріммара (видано)",
    },
    [9325] = {
        ["Flame of Thunder Bluff"] = "полум'я Громового Бескиду",
        ["Flame of Thunder Bluff (Provided)"] = "полум'я Громового Бескиду (видано)",
    },
    [9326] = {
        ["Flame of the Undercity"] = "полум'я Підмістя",
        ["Flame of the Undercity (Provided)"] = "полум'я Підмістя (видано)",
    },
    [9330] = {
        ["Flame of Stormwind"] = "полум'я Штормовію",
        ["Flame of Stormwind (Provided)"] = "полум'я Штормовію (видано)",
    },
    [9331] = {
        ["Flame of Ironforge"] = "полум'я Залізогарта",
        ["Flame of Ironforge (Provided)"] = "полум'я Залізогарта (видано)",
    },
    [9332] = {
        ["Flame of Darnassus"] = "полум'я Дарнаса",
        ["Flame of Darnassus (Provided)"] = "полум'я Дарнаса (видано)",
    },
    [9333] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9334] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9335] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9336] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9337] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9338] = {
        ["Cenarion Combat Badge"] = "кенарійська бойова відзнака",
        ["Cenarion Combat Badge (Provided)"] = "кенарійська бойова відзнака (видано)",
        ["Cenarion Logistics Badge"] = "кенарійська логістична відзнака",
        ["Cenarion Logistics Badge (Provided)"] = "кенарійська логістична відзнака (видано)",
        ["Cenarion Tactical Badge"] = "кенарійська тактична відзнака",
        ["Cenarion Tactical Badge (Provided)"] = "кенарійська тактична відзнака (видано)",
    },
    [9341] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9343] = {
        ["Necrotic Rune"] = "некротична руна",
        ["Necrotic Rune (Provided)"] = "некротична руна (видано)",
    },
    [9353] = {
        ["iCoke Gift Box Voucher"] = "Подарунковий ваучер iCole",
    },
    [9362] = {
        ["Prismatic Shell"] = "призматична мушля",
        ["Prismatic Shell (Provided)"] = "призматична мушля (видано)",
    },
    [9364] = {
        ["Polymorph Clone"] = "поліморфний клон",
        ["Polymorph Clone slain"] = "поліморфний клон: убито",
        ["Prismatic Shell"] = "призматична мушля",
        ["Prismatic Shell (Provided)"] = "призматична мушля (видано)",
    },
    [9367] = {
        ["Flame of Darnassus"] = "полум'я Дарнаса",
        ["Flame of Darnassus (Provided)"] = "полум'я Дарнаса (видано)",
        ["Flame of Ironforge"] = "полум'я Залізогарта",
        ["Flame of Ironforge (Provided)"] = "полум'я Залізогарта (видано)",
        ["Flame of Stormwind"] = "полум'я Штормовію",
        ["Flame of Stormwind (Provided)"] = "полум'я Штормовію (видано)",
    },
    [9368] = {
        ["Flame of Orgrimmar"] = "полум'я Орґріммара",
        ["Flame of Orgrimmar (Provided)"] = "полум'я Орґріммара (видано)",
        ["Flame of Thunder Bluff"] = "полум'я Громового Бескиду",
        ["Flame of Thunder Bluff (Provided)"] = "полум'я Громового Бескиду (видано)",
        ["Flame of the Undercity"] = "полум'я Підмістя",
        ["Flame of the Undercity (Provided)"] = "полум'я Підмістя (видано)",
    },
    [9378] = {
        ["42000 reputation with Argent Dawn"] = "42000 репутації у Сріблястого Світанку",
    },
    [9386] = {
        ["Flame of Blackrock Spire"] = "Полум'я Шпиля Чорної Скелі",
        ["Flame of Blackrock Spire (Provided)"] = "Полум'я Шпиля Чорної Скелі (видано)",
        ["Flame of Blackrock Spire slain"] = "Полум'я Шпиля Чорної Скелі: убито",
        ["Flame of Dire Maul"] = "Полум'я Запеклого Молота",
        ["Flame of Dire Maul (Provided)"] = "Полум'я Запеклого Молота (видано)",
        ["Flame of Dire Maul slain"] = "Полум'я Запеклого Молота: убито",
        ["Flame of Stratholme"] = "Полум'я Стратгольма",
        ["Flame of Stratholme (Provided)"] = "Полум'я Стратгольма (видано)",
        ["Flame of Stratholme slain"] = "Полум'я Стратгольма: убито",
        ["Flame of the Scholomance"] = "Полум'я Несхольності",
        ["Flame of the Scholomance (Provided)"] = "Полум'я Несхольності (видано)",
        ["Flame of the Scholomance slain"] = "Полум'я Несхольності: убито",
    },
    [9388] = {
        ["Flame of Ashenvale"] = "Полум'я Ясенеділу",
        ["Flame of Ashenvale (Provided)"] = "Полум'я Ясенеділу (видано)",
        ["Flame of Ashenvale slain"] = "Полум'я Ясенеділу: убито",
        ["Flame of Darkshore"] = "Полум'я Темних берегів",
        ["Flame of Darkshore (Provided)"] = "Полум'я Темних берегів (видано)",
        ["Flame of Darkshore slain"] = "Полум'я Темних берегів: убито",
        ["Flame of Stonetalon"] = "Полум'я Кам'яного Кігтя",
        ["Flame of Stonetalon (Provided)"] = "Полум'я Кам'яного Кігтя (видано)",
        ["Flame of Stonetalon slain"] = "Полум'я Кам'яного Кігтя: убито",
        ["Flame of the Barrens"] = "Полум'я пустелі",
        ["Flame of the Barrens (Provided)"] = "Полум'я пустелі (видано)",
        ["Flame of the Barrens slain"] = "Полум'я пустелі: убито",
    },
    [9389] = {
        ["Flame of Hillsbrad"] = "Полум'я Гіллсбрада",
        ["Flame of Hillsbrad (Provided)"] = "Полум'я Гіллсбрада (видано)",
        ["Flame of Hillsbrad slain"] = "Полум'я Гіллсбрада: убито",
        ["Flame of Silverpine"] = "Полум'я срібної сосни",
        ["Flame of Silverpine (Provided)"] = "Полум'я срібної сосни (видано)",
        ["Flame of Silverpine slain"] = "Полум'я срібної сосни: убито",
        ["Flame of Westfall"] = "Полум'я Вестфоллу",
        ["Flame of Westfall (Provided)"] = "Полум'я Вестфоллу (видано)",
        ["Flame of Westfall slain"] = "Полум'я Вестфоллу: убито",
        ["Flame of the Wetlands"] = "Полум'я водно-болотних угідь",
        ["Flame of the Wetlands (Provided)"] = "Полум'я водно-болотних угідь (видано)",
        ["Flame of the Wetlands slain"] = "Полум'я водно-болотних угідь: убито",
    },
    [9411] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9412] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9413] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9414] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9419] = {
        ["Return Silithyst"] = "Повернення Силітиста",
        ["Return Silithyst (Provided)"] = "Повернення Силітиста (видано)",
        ["Return Silithyst slain"] = "Повернення Силітиста: убито",
    },
    [9422] = {
        ["Deliver Silithyst"] = "Доставити Силітист",
    },
    [9458] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9459] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9477] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9478] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9479] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9480] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9481] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9482] = {
        ["[PH] Silithus PvP Dust [DEP]"] = "[PH] PvP-пил Силітуса [DEP]",
    },
    [9556] = {
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
    },
    [9664] = {
        ["Capture Crown Guard Tower"] = "Захоплення вежі Коронної варти",
        ["Capture Crown Guard Tower (Provided)"] = "Захоплення вежі Коронної варти (видано)",
        ["Capture Crown Guard Tower slain"] = "Захоплення вежі Коронної варти: убито",
        ["Capture Eastwall Tower"] = "Захоплення вежі Істволл",
        ["Capture Eastwall Tower (Provided)"] = "Захоплення вежі Істволл (видано)",
        ["Capture Eastwall Tower slain"] = "Захоплення вежі Істволл: убито",
        ["Capture Northpass Tower"] = "Захоплення вежі Нортпасс",
        ["Capture Northpass Tower (Provided)"] = "Захоплення вежі Нортпасс (видано)",
        ["Capture Northpass Tower slain"] = "Захоплення вежі Нортпасс: убито",
        ["Capture Plaguewood Tower"] = "Захоплення вежі Чумного лісу",
        ["Capture Plaguewood Tower (Provided)"] = "Захоплення вежі Чумного лісу (видано)",
        ["Capture Plaguewood Tower slain"] = "Захоплення вежі Чумного лісу: убито",
    },
    [9665] = {
        ["Capture Crown Guard Tower"] = "Захоплення вежі Коронної варти",
        ["Capture Crown Guard Tower (Provided)"] = "Захоплення вежі Коронної варти (видано)",
        ["Capture Crown Guard Tower slain"] = "Захоплення вежі Коронної варти: убито",
        ["Capture Eastwall Tower"] = "Захоплення вежі Істволл",
        ["Capture Eastwall Tower (Provided)"] = "Захоплення вежі Істволл (видано)",
        ["Capture Eastwall Tower slain"] = "Захоплення вежі Істволл: убито",
        ["Capture Northpass Tower"] = "Захоплення вежі Нортпасс",
        ["Capture Northpass Tower (Provided)"] = "Захоплення вежі Нортпасс (видано)",
        ["Capture Northpass Tower slain"] = "Захоплення вежі Нортпасс: убито",
        ["Capture Plaguewood Tower"] = "Захоплення вежі Чумного лісу",
        ["Capture Plaguewood Tower (Provided)"] = "Захоплення вежі Чумного лісу (видано)",
        ["Capture Plaguewood Tower slain"] = "Захоплення вежі Чумного лісу: убито",
    },
    [65593] = {
        ["Avelina's Heart"] = "серце Авеліни",
        ["Isaac's Heart"] = "серце Айзека",
    },
    [65597] = {
        ["Lovers' Hearts"] = "серця закоханих",
        ["Lovers' Hearts (Provided)"] = "серця закоханих (видано)",
        ["Summoned Incubus slain"] = "викликаний інкуб: убито",
    },
    [65602] = {
        ["Wooden Figurine"] = "дерев'яна статуетка",
    },
    [65603] = {
        ["Summoned Incubus slain"] = "викликаний інкуб: убито",
        ["Wooden Figurine"] = "дерев'яна статуетка",
        ["Wooden Figurine (Provided)"] = "дерев'яна статуетка (видано)",
    },
    [65604] = {
        ["Summoned Incubus slain"] = "викликаний інкуб: убито",
        ["Withered Scarf"] = "вицвіла хустка",
        ["Withered Scarf (Provided)"] = "вицвіла хустка (видано)",
    },
    [65610] = {
        ["Withered Scarf"] = "вицвіла хустка",
    },
    [76156] = {
        ["Seaforium Mining Charge"] = "Плата за видобуток Seaforium",
        ["Venture Co Disguise"] = "Маскування Venture Co",
        ["Venture Co Disguise (Provided)"] = "Маскування Venture Co (видано)",
    },
    [76160] = {
        ["Pine Salve"] = "Соснова мазь",
        ["Windfury Cone"] = "Конус люті вітру",
    },
    [76240] = {
        ["Fish Chunks"] = "Шматочки риби",
    },
    [77574] = {
        ["Memory of a Troubled Acolyte"] = "Пам'ять проблемного аколіта",
    },
    [77585] = {
        ["Learn: Engrave Chest - Overload"] = "Дізнайтеся: Гравірування скрині - Перевантаження",
    },
    [77620] = {
        ["Comprehension Primer"] = "Посібник з розуміння",
    },
    [77642] = {
        ["Memory of a Troubled Acolyte"] = "Пам'ять проблемного аколіта",
    },
    [77643] = {
        ["Comprehension Primer"] = "Посібник з розуміння",
        ["Comprehension Primer (Provided)"] = "Посібник з розуміння (видано)",
        ["Learn: Engrave Gloves - Ice Lance"] = "Дізнайтеся: Гравірування рукавичок - Крижане спис",
    },
    [77652] = {
        ["Learn: Engrave Chest - Overload"] = "Дізнайтеся: Гравірування скрині - Перевантаження",
    },
    [77667] = {
        ["Comprehension Primer"] = "Посібник з розуміння",
    },
    [77670] = {
        ["Memory of a Troubled Acolyte"] = "Пам'ять проблемного аколіта",
    },
    [77671] = {
        ["Comprehension Primer"] = "Посібник з розуміння",
    },
    [77672] = {
        ["Learn: Engrave Gloves - Haunt"] = "Дізнайтеся: Гравірування рукавичок - Привид",
    },
    [78089] = {
        ["Althalaxx Orb"] = "Сфера Альталакс",
    },
    [78090] = {
        ["Althalaxx Orb"] = "Сфера Альталакс",
    },
    [78092] = {
        ["Althalaxx Orb"] = "Сфера Альталакс",
    },
    [78093] = {
        ["Orb Fragments"] = "Фрагменти сфери",
    },
    [78124] = {
        ["Nar'thalas Almanac, Vol. 74"] = "Альманах Нар'таласа, том 74",
    },
    [78127] = {
        ["The Dalaran Digest, Vol. 23"] = "Даларанський дайджест, том 23",
    },
    [78132] = {
        ["Dragonslayer's Helm"] = "Шолом Драконівбивці",
    },
    [78133] = {
        ["Dragonslayer's Shield"] = "Щит Драконівбивці",
    },
    [78134] = {
        ["Dragonslayer's Lance"] = "Спис Драконівбивці",
    },
    [78142] = {
        ["Bewitchments and Glamours"] = "Чари та чари",
    },
    [78143] = {
        ["Secrets of the Dreamers"] = "Таємниці мрійників",
    },
    [78145] = {
        ["Arcanic Systems Manual"] = "Посібник з арканічних систем",
    },
    [78146] = {
        ["Goaz Scrolls"] = "Сувої Гоаза",
    },
    [78147] = {
        ["Crimes Against Anatomy"] = "Злочини проти анатомії",
    },
    [78148] = {
        ["Runes of the Sorcerer-Kings"] = "Руни Королів-Чаклунів",
    },
    [78149] = {
        ["Fury of the Land"] = "Гнів Країни",
    },
    [78197] = {
        ["Tincture of Waking Death"] = "Настоянка смерті наяву",
    },
    [78199] = {
        ["Voodoo Offering"] = "Підношення вуду",
    },
    [78261] = {
        ["Horn of Xelthos"] = "Ріг Кселтоса",
    },
    [78270] = {
        ["Venture Co. Work Order"] = "Замовлення на виконання робіт від ТзНБ \"Авантюра\"",
    },
    [78287] = {
        ["Arms Shipment"] = "Поставка зброї",
    },
    [78288] = {
        ["Arms Shipment"] = "Поставка зброї",
    },
    [78561] = {
        ["Elixir of Insight"] = "Еліксир Прозріння",
    },
    [78612] = {
        ["Supply Shipment"] = "Відвантаження постачання",
    },
    [78830] = {
        ["Empty Bait Cage"] = "Порожня клітка для приманки",
    },
    [78916] = {
        ["Item #209693"] = "Товар №209693",
    },
    [78917] = {
        ["Item #211452"] = "Товар №211452",
        ["Item #211452 (Provided)"] = "Товар №211452 (видано)",
    },
    [78920] = {
        ["Item #211454"] = "Товар №211454",
        ["Item #211454 (Provided)"] = "Товар №211454 (видано)",
    },
    [78927] = {
        ["Lorgus Jett slain"] = "Лорґус Джетт: убито",
    },
    [78994] = {
        ["Invisibility Potion"] = "зілля невидимості",
    },
    [79090] = {
        ["Warsong Outrider Mark"] = "Знак аутсайдера Пісні Війни",
        ["Warsong Outrider Mark (Provided)"] = "Знак аутсайдера Пісні Війни (видано)",
    },
    [79091] = {
        ["Archmage Antonidas: The Unabridged Autobiography"] = "Архімаг Антонідас: Нескорочена автобіографія",
        ["Archmage Antonidas: The Unabridged Autobiography (Provided)"] = "Архімаг Антонідас: Нескорочена автобіографія (видано)",
        ["Archmage Antonidas: The Unabridged Autobiography slain"] = "Архімаг Антонідас: Нескорочена автобіографія: убито",
    },
    [79092] = {
        ["Archmage Theocritus' Research Journal"] = "Дослідницький журнал архімага Теокрита",
    },
    [79093] = {
        ["Rumi of Gnomeregan: The Collected Works"] = "Румі з Гномреґану: Зібрання творів",
        ["Rumi of Gnomeregan: The Collected Works (Provided)"] = "Румі з Гномреґану: Зібрання творів (видано)",
        ["Rumi of Gnomeregan: The Collected Works slain"] = "Румі з Гномреґану: Зібрання творів: убито",
    },
    [79094] = {
        ["The Lessons of Ta'zo"] = "Уроки Та'зо",
    },
    [79095] = {
        ["The Apothecary's Metaphysical Primer"] = "Метафізичний посібник аптекаря",
    },
    [79096] = {
        ["Ataeric: On Arcane Curiosities"] = "Атерік: Про таємні курйози",
    },
    [79097] = {
        ["Baxtan: On Destructive Magics"] = "Бакстан: Про руйнівну магію",
    },
    [79098] = {
        ["Silverwing Sentinel Charm"] = "Оберіг Срібнокрилого Вартового",
    },
    [79102] = {
        ["Supply Shipment"] = "Відвантаження постачання",
    },
    [79362] = {
        ["Grant's Mace"] = "Булава Гранта",
        ["Grant's Shield"] = "Щит Гранта",
    },
    [79363] = {
        ["Defias Enchanter slain"] = "чародій Непокірних: убито",
        ["Defias Night Blade slain"] = "нічне лезо Непокірних: убито",
        ["Silvia's Sword"] = "Меч Сільвії",
    },
    [79365] = {
        ["Item #212982"] = "Товар №212982",
    },
    [79366] = {
        ["Item #212982"] = "Товар №212982",
    },
    [79377] = {
        ["Item #213036"] = "Артикул №213036",
    },
    [79442] = {
        ["Eye of the Tempest"] = "Око Бурі",
    },
    [79535] = {
        ["Basilisks: Should Petrification be Feared?"] = "Василіски: чи варто боятися скам'яніння?",
    },
    [79731] = {
        ["Learn: Solve the riddle"] = "Навчіться: Розгадайте загадку",
    },
    [79939] = {
        ["Broken Hammer"] = "Зламаний молоток",
    },
    [79945] = {
        ["Orders from the Grand Crusader"] = "Накази від Великого хрестоносця",
    },
    [79947] = {
        ["Geomancy: The Stone-Cold Truth"] = "Геомантія: Холодна правда",
    },
    [79948] = {
        ["Defensive Magics 101"] = "Захисна магія 101",
    },
    [79949] = {
        ["A Web of Lies: Debunking Myths and Legends"] = "Павутиння брехні: розвінчування міфів та легенд",
    },
    [79950] = {
        ["Demons and You"] = "Демони та ти",
    },
    [79951] = {
        ["Mummies: A Guide to the Unsavory Undead"] = "Мумії: Путівник по неприємним немертвим",
    },
    [79952] = {
        ["RwlRwlRwlRwl!"] = "РвлРвлРвлРвл!",
    },
    [79953] = {
        ["A Luddite's Guide to Caring for Your Demonic Pet"] = "Посібник луддита з догляду за вашим демонічним домашнім улюбленцем",
    },
    [79981] = {
        ["Corroded G-7 C.O.R.E. Processor"] = "Кородований процесор G-7 C.O.R.E.",
    },
    [79985] = {
        ["Kernobee Rescue"] = "Рятувальний майданчик Кернобі",
    },
    [79986] = {
        ["Item #216661"] = "Товар №216661",
    },
    [79987] = {
        ["Item #216662"] = "Товар №216662",
    },
    [80001] = {
        ["Flint and Tinder"] = "кремінь і трут",
        ["Simple Wood"] = "проста деревина",
    },
    [80131] = {
        ["Item #216662"] = "Товар №216662",
    },
    [80134] = {
        ["Goblin Transponder"] = "гоблінський транспондер",
    },
    [80139] = {
        ["Empty Leaden Collection Phial"] = "порожній свинцевий фіал для зразків",
    },
    [80140] = {
        ["Item #216662"] = "Товар №216662",
    },
    [80182] = {
        ["Heavy Leaden Collection Phial"] = "важкий свинцевий фіал для зразків",
    },
    [80324] = {
        ["Item #217350"] = "Товар №217350",
    },
    [80325] = {
        ["Item #217351"] = "Товар №217351",
    },
    [80453] = {
        ["Talisman of Kazdor"] = "Талісман Каздора",
    },
    [80454] = {
        ["Modified Talisman"] = "Модифікований Талісман",
    },
    [81766] = {
        ["Bloody Missive"] = "Криваве послання",
    },
    [81776] = {
        ["Dream-Touched Dragon Egg"] = "Яйце Дракона, Доторкнутого Сном",
    },
    [81790] = {
        ["Item #220170"] = "Артикул №220170",
    },
    [81919] = {
        ["Infernal Lasso"] = "Пекельне ласо",
    },
    [81947] = {
        ["Sanguine Sorcery"] = "Сангвінічне чаклунство",
    },
    [81949] = {
        ["Legends of the Tidesages"] = "Легенди про мудреців припливів",
    },
    [81951] = {
        ["The Liminal and the Arcane"] = "Лімінальний та Арканний",
    },
    [81952] = {
        ["Everyday Etiquette"] = "Повсякденний етикет",
    },
    [81953] = {
        ["Stonewrought Design"] = "Дизайн з каменю",
    },
    [81954] = {
        ["Venomous Journeys"] = "Отруйні подорожі",
    },
    [81955] = {
        ["A Mind of Metal"] = "Розум з металу",
    },
    [81956] = {
        ["Conjurer's Codex"] = "Кодекс фокусника",
    },
    [81960] = {
        ["Murky Air Sapta"] = "Каламутне повітря Сапта",
    },
    [81968] = {
        ["Fragment of Air"] = "Фрагмент повітря",
    },
    [81974] = {
        ["Item #220526"] = "Товар №220526",
    },
    [81977] = {
        ["Item #220531"] = "Товар №220531",
    },
    [82055] = {
        ["Dunes Deck"] = "Палуба Дюн",
    },
    [82056] = {
        ["Nightmares Deck"] = "Колода кошмарів",
    },
    [82057] = {
        ["Plagues Deck"] = "Колода «Чума»",
    },
    [82071] = {
        ["Murky Fire Sapta"] = "Каламутний вогонь Сапта",
    },
    [82072] = {
        ["Murky Earth Sapta"] = "Каламутна Земля Сапта",
    },
    [82073] = {
        ["Murky Water Sapta"] = "Каламутна вода Сапта",
    },
    [82074] = {
        ["Fragment of Fire"] = "Фрагмент вогню",
    },
    [82075] = {
        ["Fragment of Earth"] = "Фрагмент Землі",
    },
    [82076] = {
        ["Fragment of Water"] = "Фрагмент води",
    },
    [82081] = {
        ["Item #221346"] = "Товар №221346",
    },
    [82083] = {
        ["Item #221363"] = "Товар №221363",
    },
    [82095] = {
        ["Egg of Hakkar"] = "яйце Гаккара",
    },
    [82096] = {
        ["Atal'ai Stone Circle"] = "круглий камінь Атал'ай",
    },
    [82102] = {
        ["Item #221475"] = "Товар №221475",
    },
    [82135] = {
        ["Mannoroc Orb"] = "Сфера Маннорока",
    },
    [84126] = {
        ["Modified Shadow Scalpel"] = "Модифікований тіньовий скальпель",
    },
    [84137] = {
        ["Guided Buoyancy Accelerant"] = "Прискорювач плавучості, що керується",
    },
    [84180] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84181] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84182] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84183] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84184] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84185] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84186] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84187] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84188] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84189] = {
        ["Banner of Provocation"] = "стяг виклику",
    },
    [84190] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84192] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84193] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84194] = {
        ["Top Piece of Lord Valthalak's Amulet"] = "верхня частина амулету лорда Вальталака",
    },
    [84211] = {
        ["Vertically Composited Patch Hampler"] = "Вертикально складений патч-гамплер",
    },
    [84212] = {
        ["Fantastic Inventions"] = "Фантастичні винаходи",
    },
    [84318] = {
        ["Orthas' Favorite Gold Tooth"] = "Улюблений золотий зуб Ортаса",
    },
    [84323] = {
        ["Puzzle Box"] = "Коробка-головоломка",
    },
    [84324] = {
        ["Giant Egg"] = "гігантське яйце",
        ["Heavy Runecloth Bandage"] = "щільний рунічний бинт",
        ["Major Healing Potion"] = "величезне зілля лікування",
        ["Stratholme Holy Water"] = "стратгольмська свята вода",
    },
    [84325] = {
        ["Shard of Light"] = "Уламок світла",
    },
    [84338] = {
        ["Thorium Brotherhood Contract"] = "договір Торієвого братства",
    },
    [84377] = {
        ["Head of Rend Blackhand"] = "голова Ренда Чорнорука",
    },
    [84395] = {
        ["Undead Potatoes"] = "Картопля нежиті",
    },
    [84396] = {
        ["Magma or Lava?"] = "Магма чи лава?",
    },
    [84397] = {
        ["Northern Kalimdor - A Comprehensive Guide"] = "Північний Калімдор - Вичерпний путівник",
    },
    [84398] = {
        ["A Study of the Light"] = "Дослідження світла",
    },
    [84399] = {
        ["Ka-Boom!"] = "Ка-Бум!",
    },
    [84400] = {
        ["The Knight and the Lady"] = "Лицар і леді",
    },
    [84401] = {
        ["Scourge: Undead Menace or Misunderstood?"] = "Бич: Загроза нежиті чи неправильне розуміння?",
    },
    [84402] = {
        ["Necromancy 101"] = "Некромантія 101",
    },
    [84407] = {
        ["Puzzle Box"] = "Коробка-головоломка",
    },
    [84410] = {
        ["Shard of Light"] = "Уламок світла",
    },
    [84546] = {
        ["Petrified Bark"] = "скам'яніла кора",
    },
    [84548] = {
        ["Item #228691"] = "Товар №228691",
    },
    [84549] = {
        ["Item #228693"] = "Товар №228693",
    },
    [84550] = {
        ["Item #228692"] = "Товар №228692",
    },
    [84551] = {
        ["Item #228690"] = "Товар №228690",
    },
    [84555] = {
        ["Item #228680"] = "Товар №228680",
    },
    [84556] = {
        ["A Dull and Flat Elven Blade"] = "тупий і плаский ельфійський клинок",
    },
    [84590] = {
        ["The Balance of Light and Shadow"] = "Баланс світла і тіні",
    },
    [84950] = {
        ["Survival Supplies"] = "Приладдя для виживання",
    },
    [85064] = {
        ["Empty Reliquary"] = "Порожній релікварій",
    },
    [85087] = {
        ["Tarnished Horn"] = "Потьмянілий ріг",
    },
    [85090] = {
        ["Truthbearer"] = "Носій правди",
    },
    [85091] = {
        ["Blood of the Lightbringer"] = "Кров Світлоносця",
    },
    [85442] = {
        ["Vessel of Rebirth"] = "посудина відродження",
    },
    [85443] = {
        ["Item #232018"] = "Товар №232018",
    },
    [85447] = {
        ["Item #231385"] = "Товар №231385",
    },
    [85455] = {
        ["Item #231452"] = "Товар №231452",
    },
    [85457] = {
        ["Blood of the Lightbringer"] = "Кров Світлоносця",
    },
    [85458] = {
        ["Blood of the Lightbringer"] = "Кров Світлоносця",
    },
    [85525] = {
        ["Survival Supplies"] = "Приладдя для виживання",
    },
    [85555] = {
        ["Item #231995"] = "Товар №231995",
    },
    [85556] = {
        ["Item #231995"] = "Товар №231995",
    },
    [85638] = {
        ["Primal Hakkari Bindings"] = "первісні браслети Гаккарі",
        ["Zandalar Tribe"] = "Плем'я Зандалар",
    },
    [85798] = {
        ["Logistics Task Briefing VI"] = "план логістичного завдання VI",
    },
    [86443] = {
        ["The Redemption of Eranikus"] = "Викуплення Еранікуса",
    },
    [86574] = {
        ["Stonetalon Supply Bundle"] = "Комплект постачання Кам'яного Кігтя",
        ["Stonetalon Supply Satchel"] = "Сумка з припасами Кам'яного Кігтя",
        ["Stonetalon Supply Satchel (Provided)"] = "Сумка з припасами Кам'яного Кігтя (видано)",
    },
    [86576] = {
        ["Glittering Sunstone"] = "Блискучий сонячний камінь",
    },
    [86585] = {
        ["Banner of Ironforge"] = "Прапор Айронгорна",
        ["Banner of Ironforge (Provided)"] = "Прапор Айронгорна (видано)",
        ["Headsplitter slain"] = "Роздільник голов: убито",
    },
    [86613] = {
        ["Excavation Tools"] = "Інструменти для земляних робіт",
        ["Excavation Tools (Provided)"] = "Інструменти для земляних робіт (видано)",
    },
    [86614] = {
        ["Monogrammed Silver Hair Clip"] = "Срібна заколка для волосся з монограмою",
        ["Monogrammed Silver Hair Clip (Provided)"] = "Срібна заколка для волосся з монограмою (видано)",
    },
    [86667] = {
        ["Jar of Snow"] = "Банка зі снігом",
        ["Jar of Snow (Provided)"] = "Банка зі снігом (видано)",
        ["Jar of Snow slain"] = "Банка зі снігом: убито",
    },
    [86670] = {
        ["Eye of C'Thun"] = "око К'Туна",
    },
    [86679] = {
        ["Item #235049"] = "Товар №235049",
    },
    [86758] = {
        ["Marek's Croc-Hunting Knife"] = "Ніж Марека для полювання на крокодилів",
    },
    [86760] = {
        ["Beasts Deck"] = "колода звірів",
    },
    [86761] = {
        ["Warlords Deck"] = "колода воєвод",
    },
    [86762] = {
        ["Elementals Deck"] = "колода елементалів",
    },
    [86776] = {
        ["Bronze Bar"] = "злиток бронзи",
    },
    [86784] = {
        ["Dry Branch"] = "Суха гілка",
    },
    [86969] = {
        ["List of Components"] = "Список компонентів",
    },
    [86970] = {
        ["Enchanted Firebrand"] = "Зачарований Вогняний Головоріз",
    },
    [87283] = {
        ["Violet Satchel"] = "Вайолет Сатчел",
    },
    [87288] = {
        ["Soft Nightsaber Pelt"] = "М'яка шкура нічного меча",
    },
    [87361] = {
        ["Item #236750"] = "Товар №236750",
    },
    [87441] = {
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
    },
    [87443] = {
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
    },
    [87444] = {
        ["Atiesh, Greatstaff of the Guardian"] = "Атієш, великий посох Вартівника",
    },
    [87760] = {
        ["Rod of Deep Dominion"] = "Жезл Глибокого Панування",
    },
    [89256] = {
        ["Quartermaster's Crate"] = "Ящик квартирмейстера",
    },
    [89300] = {
        ["Item #239010"] = "Артикул №239010",
    },
    [89301] = {
        ["Item #240936"] = "Товар №240936",
    },
    [89329] = {
        ["Crypt Fiend slain"] = "склепний марник: убито",
        ["Crypt Walker slain"] = "склепний блукач: убито",
    },
    [89442] = {
        ["Item #239197"] = "Товар №239197",
    },
    [89443] = {
        ["Item #239219"] = "Товар №239219",
    },
    [89444] = {
        ["Item #239215"] = "Товар №239215",
    },
    [89445] = {
        ["Item #239196"] = "Товар №239196",
    },
    [89446] = {
        ["Item #243230"] = "Товар №243230",
    },
    [89471] = {
        ["Fizzlefuse's Shopping List"] = "Список покупок Fizzlefuse",
    },
    [89485] = {
        ["Pile of Portiporters"] = "Купа портипортерів",
    },
    [89491] = {
        ["Triangulation Samophlange"] = "Тріангуляція Самофланж",
    },
    [90510] = {
        ["Item #237020"] = "Артикул №237020",
    },
    [90559] = {
        ["Item #241654"] = "Товар №241654",
    },
    [90566] = {
        ["Basket of Hearts"] = "Кошик із сердечками",
    },
    [90625] = {
        ["Item #242365"] = "Товар №242365",
    },
    [90627] = {
        ["Item #242364"] = "Товар №242364",
    },
    [90902] = {
        ["Injured Deathguard healed"] = "Поранений Смертельний Гвардієць зцілений",
    },
    [91208] = {
        ["Offer aid to the Frightened Paladin"] = "Запропонуйте допомогу переляканому паладину",
    },
    [91209] = {
        ["Report to Shari Stilwell in Brill"] = "Звітувати Шарі Стілвелл у Бріллі",
    },
    [91285] = {
        ["Vile Fin Attacker slain"] = "Злочинний нападник на плавниках: убито",
        ["Vile Fin Seer slain"] = "Мерзенний провидець плавців: убито",
    },
    [91294] = {
        ["Speak with Ander Solliden"] = "Поговоріть з Андером Солліденом",
        ["Speak with Danitha Morr"] = "Поговоріть з Данітою Морр",
        ["Speak with Hilda the Breaker"] = "Поговоріть з Гільдою Руйнівницею",
        ["Speak with Jorin Croge"] = "Поговоріть з Йоріном Кроге",
    },
    [91316] = {
        ["Sturdy Lumber"] = "Міцна деревина",
    },
    [91317] = {
        ["Rudolph Gelhardt's Head"] = "Голова Рудольфа Гельхардта",
        ["Tarnished Drudge slain"] = "Заплямований трудяга: убито",
        ["Tarnished Zealot slain"] = "Заплямований фанатик: убито",
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
    [91736] = {
        ["Shiny Red Apple"] = "соковите червоне яблуко",
    },
    [91738] = {
        ["Thunder Applejack"] = "Громовий яблуневий джек",
    },
    [91740] = {
        ["Croaky's Head"] = "Голова Крокі",
        ["Croaky's Head (Provided)"] = "Голова Крокі (видано)",
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
    [91746] = {
        ["Elmpaw's Head"] = "Голова Елмпау",
        ["Elmpaw's Head (Provided)"] = "Голова Елмпау (видано)",
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
    [91753] = {
        ["Luminous Residue"] = "Світловий залишок",
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
    [91862] = {
        ["Fenris Isle Key"] = "Ключ до острова Фенріс",
    },
    [91899] = {
        ["Sealed Apprentice Crate"] = "Запечатаний ящик учня",
    },
    [91900] = {
        ["Sealed Journeyman Crate"] = "Запечатаний ящик підмайстра",
    },
    [91901] = {
        ["Sealed Expert Crate"] = "Запечатаний ящик експерта",
    },
    [91904] = {
        ["Sealed Apprentice Crate"] = "Запечатаний ящик учня",
    },
    [91905] = {
        ["Sealed Journeyman Crate"] = "Запечатаний ящик підмайстра",
    },
    [91920] = {
        ["Murloc Eye"] = "око мурлока",
    },
    [91921] = {
        ["Quinn's Potion"] = "Квіннове зілля",
        ["Quinn's Potion (Provided)"] = "Квіннове зілля (видано)",
    },
    [92109] = {
        ["Empty Vial"] = "порожній фіал",
        ["Peacebloom"] = "мироквіт",
        ["Silverleaf"] = "срібнолист",
    },
    [92110] = {
        ["Murloc Eye"] = "око мурлока",
    },
    [92401] = {
        ["Investigate the disappearance of Edward Heartweaver in the Ruins of Lordaeron."] = "Розслідуйте зникнення Едварда Хартвівера в руїнах Лордерона.",
    },
    [92415] = {
        ["Blood-Stained Letter"] = "Лист, заплямований кров’ю",
        ["Blood-Stained Letter (Provided)"] = "Лист, заплямований кров’ю (видано)",
    },
    [92421] = {
        ["Intact Limbs"] = "Неушкоджені кінцівки",
        ["Intact Limbs (Provided)"] = "Неушкоджені кінцівки (видано)",
        ["Intact Limbs slain"] = "Неушкоджені кінцівки: убито",
    },
    [92422] = {
        ["Rath'mael slain"] = "Рат'маель: убито",
    },
    [92454] = {
        ["Thendal Grove Gift Voucher"] = "Подарунковий сертифікат Thendal Grove",
        ["Thendal Grove Gift Voucher (Provided)"] = "Подарунковий сертифікат Thendal Grove (видано)",
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
    [92464] = {
        ["Learn more about the agitated winds."] = "Дізнайтеся більше про бурхливі вітри.",
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
    [92467] = {
        ["Earth Sapta"] = "сапта землі",
    },
    [92468] = {
        ["Rough Quartz"] = "грубий кварц",
        ["Rough Quartz (Provided)"] = "грубий кварц (видано)",
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
    [92479] = {
        ["Scribbled Letter"] = "Намальований лист",
        ["Scribbled Letter (Provided)"] = "Намальований лист (видано)",
    },
    [92480] = {
        ["Item #251942"] = "Товар №251942",
        ["Item #251942 (Provided)"] = "Товар №251942 (видано)",
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
    [92483] = {
        ["Simple Note"] = "проста записка",
        ["Simple Note (Provided)"] = "проста записка (видано)",
    },
    [92484] = {
        ["Humming Recall Crystal"] = "Гудіння нагадування про кристал",
        ["Humming Recall Crystal (Provided)"] = "Гудіння нагадування про кристал (видано)",
    },
    [92485] = {
        ["Folded Parchment"] = "Складений пергамент",
        ["Folded Parchment (Provided)"] = "Складений пергамент (видано)",
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
    [92529] = {
        ["Speak with Missionary Jasaan at the entrance to Falaath Village"] = "Поговоріть з місіонером Джасааном біля входу до села Фалаат",
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
    [92701] = {
        ["Aonda's Written Report"] = "Письмовий звіт Аонди",
        ["Aonda's Written Report (Provided)"] = "Письмовий звіт Аонди (видано)",
    },
    [92706] = {
        ["Bruuz's Dorsal Fin"] = "Спинний плавець Брууза",
    },
    [92708] = {
        ["Listen to Ayessa"] = "Слухайте Айєсу.",
    },
    [92709] = {
        ["Listen to Elaadrin"] = "Слухайте Елаадрін",
    },
    [92741] = {
        ["Shriekling Talons"] = "Верескітні кігті",
    },
    [92742] = {
        ["Jansen Stead Water Sample"] = "Зразок води Jansen Stead",
        ["Molsen Farm Water Sample"] = "Зразок води з ферми Молсен",
        ["Well Water Sample Kit"] = "Набір для аналізу води зі свердловин",
        ["Well Water Sample Kit (Provided)"] = "Набір для аналізу води зі свердловин (видано)",
    },
    [92744] = {
        ["Longshore Murloc Gill"] = "Лонгшор Мерлок Гілл",
        ["Longshore Murloc Gill (Provided)"] = "Лонгшор Мерлок Гілл (видано)",
        ["Longshore Murloc Gill slain"] = "Лонгшор Мерлок Гілл: убито",
    },
    [92745] = {
        ["Kobold Digger slain"] = "кобольд-землекоп: убито",
        ["Riverpaw Miner slain"] = "річколапий шахтар: убито",
    },
    [92747] = {
        ["Suspicious Industrial Supplies"] = "Підозрілі промислові товари",
    },
    [92749] = {
        ["Coarse Dynamite"] = "шорсткий динаміт",
    },
    [92751] = {
        ["Remote Detonator Kit"] = "Комплект дистанційного детонатора",
        ["Remote Detonator Kit (Provided)"] = "Комплект дистанційного детонатора (видано)",
    },
    [92752] = {
        ["Extra-Destructive Explosives"] = "Надруйнівні вибухові речовини",
        ["Extra-Destructive Explosives (Provided)"] = "Надруйнівні вибухові речовини (видано)",
    },
    [92753] = {
        ["Explosives placed"] = "Розміщено вибухівку",
        ["Extra-Destructive Explosives"] = "Надруйнівні вибухові речовини",
        ["Extra-Destructive Explosives (Provided)"] = "Надруйнівні вибухові речовини (видано)",
    },
    [92819] = {
        ["Detonator used"] = "Використаний детонатор",
    },
    [92834] = {
        ["Al'Aketh Windstone Charm"] = "Оберіг з вітряного каменю Аль'Акет",
    },
    [92840] = {
        ["Index Esoteria"] = "Індекс Езотерія",
        ["Index Esoteria (Provided)"] = "Індекс Езотерія (видано)",
        ["Protect the Index"] = "Захистіть індекс",
    },
    [92849] = {
        ["Carry Fillion Flamebreeze to safety while avoiding enemies"] = "Донесіть Філліона Полум'яного Бризу до безпечного місця, уникаючи ворогів.",
        ["Find Fillion Flamebreeze"] = "Знайдіть Філліона Полум'яного Бриза",
    },
    [92850] = {
        ["Shriekling Matriarch's Head"] = "Голова верескучої матріархи",
    },
    [92909] = {
        ["Golem Isospring"] = "Ізопружина Голема",
        ["Harvester Gyrostabilizer"] = "Гіростабілізатор комбайна",
    },
    [92910] = {
        ["Precessive Autocognition Assembly"] = "Прецесивна збірка автопізнання",
        ["Precessive Autocognition Assembly (Provided)"] = "Прецесивна збірка автопізнання (видано)",
    },
    [92911] = {
        ["Copper Modulator"] = "мідний модулятор",
        ["Crude Scope"] = "кустарний приціл",
        ["Golem Isospring"] = "Ізопружина Голема",
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
    [93160] = {
        ["Zephyrseed"] = "Зефірне насіння",
    },
    [93165] = {
        ["Al'Alketh Cultist's Ear"] = "Вухо культиста Ал'Алкета",
        ["Al'Alketh Cultist's Ear (Provided)"] = "Вухо культиста Ал'Алкета (видано)",
        ["Al'Alketh Cultist's Ear slain"] = "Вухо культиста Ал'Алкета: убито",
    },
    [93172] = {
        ["Wind Hollow freed"] = "Звільнена Вітряна Долина",
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
    [93797] = {
        ["Wind-Infused Bough"] = "Гілка, настояна на вітрі",
    },
    [93835] = {
        ["Confront Lorthuna"] = "Протистояти Лортуні",
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
    [93963] = {
        ["Recieve Instructions from Randal Emerson"] = "Отримати інструкції від Рендала Емерсона",
        ["Speak with High Tinker Mekkatorque"] = "Поговоріть з Верховним Мітником Меккаторкве",
        ["Speak with King Magni Bronzbeard"] = "Поговоріть з королем Магні Бронзбердом",
        ["Speak with Tyrande Whisperwind"] = "Поговоріть з Тірандою Шепіт Вітру",
    },
    [94003] = {
        ["Skybreaker Bulwark"] = "Оплот «Скайбрейкер»",
    },
    [94004] = {
        ["Craftsman's Writ: Elixir of Ogre's Strength"] = "Письмо ремісника: Еліксир сили огра",
        ["Elixir of Ogre Strength"] = "Еліксир сили огра",
    },
    [94013] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94212] = {
        ["Craftsman's Writ: Elixir of Wisdom"] = "Письмо ремісника: Еліксир мудрості",
        ["Elixir of Wisdom"] = "еліксир мудрості",
    },
    [94213] = {
        ["Craftsman's Writ: Lesser Mana Potion"] = "Письмо ремісника: Зілля меншої мани",
        ["Lesser Mana Potion"] = "невелике зілля мани",
    },
    [94214] = {
        ["Craftsman's Writ: Shadow Protection Potion"] = "Письмо ремісника: Зілля захисту від тіні",
        ["Shadow Protection Potion"] = "зілля тіньового захисту",
    },
    [94215] = {
        ["Craftsman's Writ: Free Action Potion"] = "Письмо ремісника: Зілля вільної дії",
        ["Free Action Potion"] = "зілля невпинності",
    },
    [94216] = {
        ["Craftsman's Writ: Elixir of Lesser Agility"] = "Письмо ремісника: Еліксир меншої спритності",
        ["Elixir of Lesser Agility"] = "еліксир малої спритності",
    },
    [94217] = {
        ["Craftsman's Writ: Lesser Troll's Blood Elixir"] = "Письмо ремісника: Еліксир крові меншого троля",
        ["Lesser Troll's Blood Elixir"] = "малий еліксир крові троля",
    },
    [94218] = {
        ["Craftsman's Writ: Elixir of Defense"] = "Письмо ремісника: Еліксир захисту",
        ["Elixir of Defense"] = "еліксир захисту",
    },
    [94219] = {
        ["Craftsman's Writ: Draught of Water Breathing"] = "Письмо ремісника: Дихання ковтком води",
        ["Draught of Water Breathing"] = "Дихання ковтком води",
    },
    [94220] = {
        ["Craftsman's Writ: Pearl-Handled Dagger"] = "Письмо майстра: Кинджал з перловою ручкою",
        ["Pearl-handled Dagger"] = "прикрашений перлами кинджал",
    },
    [94221] = {
        ["Craftsman's Writ: Golden Rod"] = "Письмо ремісника: Золотий стрижень",
        ["Golden Rod"] = "золотий жезл",
    },
    [94222] = {
        ["Craftsman's Writ: Iridescent Hammer"] = "Письмо майстра: Райдужний молоток",
        ["Iridescent Hammer"] = "райдужний молот",
    },
    [94223] = {
        ["Craftsman's Writ: Silver Skeleton Key"] = "Письмо ремісника: Срібний скелетний ключ",
        ["Silver Skeleton Key"] = "срібний ключ-відмичка",
    },
    [94224] = {
        ["Craftsman's Writ: Heavy Bronze Mace"] = "Письмо ремісника: Важка бронзова булава",
        ["Heavy Bronze Mace"] = "важка бронзова булава",
    },
    [94225] = {
        ["Craftsman's Writ: Rough Bronze Leggings"] = "Письмо ремісника: Грубі бронзові поножі",
        ["Rough Bronze Leggings"] = "грубі бронзові поножі",
    },
    [94226] = {
        ["Craftsman's Writ: Green Iron Gauntlets"] = "Письмо ремісника: Зелені залізні рукавиці",
        ["Green Iron Gauntlets"] = "зелені залізні рукавиці",
    },
    [94227] = {
        ["Big Bronze Knife"] = "великий бронзовий ніж",
        ["Craftsman's Writ: Big Bronze Knife"] = "Письмо ремісника: Великий бронзовий ніж",
    },
    [94228] = {
        ["Craftsman's Writ: Green Iron Boots"] = "Письмо ремісника: Зелені залізні чоботи",
        ["Green Iron Boots"] = "зелені залізні чоботи",
    },
    [94229] = {
        ["Craftsman's Writ: Ornate Spyglass"] = "Письмо майстра: Вишуканий телескоп",
        ["Ornate Spyglass"] = "вишукана підзорна труба",
    },
    [94230] = {
        ["Craftsman's Writ: Explosive Sheep"] = "Письмо ремісника: Вибухові вівці",
        ["Explosive Sheep"] = "вибухова вівця",
    },
    [94231] = {
        ["Craftsman's Writ: Moonsight Rifle"] = "Письмо майстра: Гвинтівка Місячного погляду",
        ["Moonsight Rifle"] = "місячна гвинтівка",
    },
    [94232] = {
        ["Craftsman's Writ: Minor Recombobulator"] = "Ремісничий лист: Незначний рекомбобулятор",
        ["Minor Recombobulator"] = "малий рекомбобулятор",
    },
    [94233] = {
        ["Craftsman's Writ: Practice Lock"] = "Наказ майстра: Практичний замок",
        ["Practice Lock"] = "навчальний замок",
    },
    [94234] = {
        ["Craftsman's Writ: Shadow Goggles"] = "Письмо майстра: Тіньові окуляри",
        ["Shadow Goggles"] = "тіньові окуляри",
    },
    [94235] = {
        ["Craftsman's Writ: Gnomish Universal Remote"] = "Письмо майстра: універсальний пульт дистанційного керування Gnomish",
        ["Gnomish Universal Remote"] = "гномський універсальний пульт",
    },
    [94236] = {
        ["Big Bronze Bomb"] = "велика бронзова бомба",
        ["Craftsman's Writ: Big Bronze Bomb"] = "Письмо ремісника: Велика бронзова бомба",
    },
    [94237] = {
        ["Crafted Solid Shot"] = "майстерно виготовлена тверда куля",
        ["Craftsman's Writ: Crafted Solid Shot"] = "Письмо майстра: Виготовлений міцний постріл",
    },
    [94238] = {
        ["Craftsman's Writ: Heavy Leather Ball"] = "Письмо майстра: Важка шкіряна куля",
        ["Heavy Leather Ball"] = "м'яч з важкої шкіри",
    },
    [94239] = {
        ["Craftsman's Writ: Fine Leather Pants"] = "Письмо майстра: Вишукані шкіряні штани",
        ["Fine Leather Pants"] = "тонкі шкіряні штани",
    },
    [94240] = {
        ["Craftsman's Writ: Herbalist's Gloves"] = "Письмо ремісника: Рукавички травника",
        ["Herbalist's Gloves"] = "рукавиці травника",
    },
    [94241] = {
        ["Craftsman's Writ: Dark Leather Tunic"] = "Напис майстра: Темна шкіряна туніка",
        ["Dark Leather Tunic"] = "темний шкіряний мундир",
    },
    [94242] = {
        ["Craftsman's Writ: Pilferer's Gloves"] = "Письмо ремісника: Рукавички злодія",
        ["Pilferer's Gloves"] = "рукавиці злодія",
    },
    [94243] = {
        ["Craftsman's Writ: Heavy Quiver"] = "Письмо ремісника: Важкий сагайдак",
        ["Heavy Quiver"] = "важкий сагайдак",
    },
    [94244] = {
        ["Craftsman's Writ: Dark Leather Shoulders"] = "Письмо майстра: Темні шкіряні плечі",
        ["Dark Leather Shoulders"] = "темні шкіряні наплечі",
    },
    [94245] = {
        ["Barbaric Gloves"] = "варварські рукавиці",
        ["Craftsman's Writ: Barbaric Gloves"] = "Письмо ремісника: Варварські рукавички",
    },
    [94246] = {
        ["Craftsman's Writ: Red Whelp Gloves"] = "Письмо ремісника: Рукавички з червоним цуценятком",
        ["Red Whelp Gloves"] = "рукавиці з червоного дракончика",
    },
    [94247] = {
        ["Craftsman's Writ: Lesser Wizard's Robe"] = "Письмо ремісника: Мантія меншого чарівника",
        ["Lesser Wizard's Robe"] = "мантія молодшого чарівника",
    },
    [94248] = {
        ["Blue Overalls"] = "синій комбінезон",
        ["Craftsman's Writ: Blue Overalls"] = "Напис майстра: Синій комбінезон",
    },
    [94249] = {
        ["Azure Silk Hood"] = "лазуровий шовковий капюшон",
        ["Craftsman's Writ: Azure Silk Hood"] = "Письмо майстра: Блакитний шовковий капюшон",
    },
    [94250] = {
        ["Craftsman's Writ: Small Silk Pack"] = "Письмо майстра: Маленький шовковий пакет",
        ["Small Silk Pack"] = "маленька шовкова сумка",
    },
    [94251] = {
        ["Craftsman's Writ: Phoenix Pants"] = "Письмо майстра: Штани Фенікса",
        ["Phoenix Pants"] = "штани фенікса",
    },
    [94252] = {
        ["Craftsman's Writ: Red Woolen Boots"] = "Письмо ремісника: Червоні вовняні чоботи",
        ["Red Woolen Boots"] = "червоні вовняні черевики",
    },
    [94253] = {
        ["Colorful Kilt"] = "барвистий кілт",
        ["Craftsman's Writ: Colorful Kilt"] = "Письмо майстра: Барвистий кілт",
    },
    [94254] = {
        ["Craftsman's Writ: Greater Adept's Robe"] = "Письмо ремісника: Мантія Великого Адепта",
        ["Greater Adept's Robe"] = "мантія старшого адепта",
    },
    [94255] = {
        ["Craftsman's Writ: Spider Silk Slippers"] = "Письмо майстра: Павутино-шовкові капці",
        ["Spider Silk Slippers"] = "павутинні черевики",
    },
    [94256] = {
        ["Craftsman's Writ: Frost Protection Potion"] = "Письмо ремісника: Зілля захисту від морозу",
        ["Frost Protection Potion"] = "зілля крижаного захисту",
    },
    [94257] = {
        ["Craftsman's Writ: Lesser Invisibility Potion"] = "Письмо ремісника: Менше зілля невидимості",
        ["Lesser Invisibility Potion"] = "зілля малої невидимості",
    },
    [94258] = {
        ["Craftsman's Writ: Lesser Stoneshield Potion"] = "Письмо ремісника: Зілля малого кам'яного щита",
        ["Lesser Stoneshield Potion"] = "мале зілля каменещита",
    },
    [94259] = {
        ["Craftsman's Writ: Nature Protection Potion"] = "Письмо ремісника: Зілля захисту природи",
        ["Nature Protection Potion"] = "зілля природного захисту",
    },
    [94260] = {
        ["Catseye Draught"] = "Осадний крем \"котяче око\"",
        ["Craftsman's Writ: Catseye Draught"] = "Письмо майстра: Осад з котячого ока",
    },
    [94261] = {
        ["Craftsman's Writ: Great Rage Potion"] = "Письмо ремісника: Зілля великої люті",
        ["Great Rage Potion"] = "велике зілля люті",
    },
    [94262] = {
        ["Craftsman's Writ: Mana Potion"] = "Письмо ремісника: Зілля мани",
        ["Mana Potion"] = "зілля мани",
    },
    [94263] = {
        ["Craftsman's Writ: Fire Protection Potion"] = "Письмо ремісника: Зілля вогнезахисного захисту",
        ["Fire Protection Potion"] = "зілля вогняного захисту",
    },
    [94264] = {
        ["Craftsman's Writ: Shadow Oil"] = "Письмо майстра: Тіньова олія",
        ["Shadow Oil"] = "тіньова олія",
    },
    [94265] = {
        ["Craftsman's Writ: Goblin Rocket Fuel"] = "Письмо майстра: Ракетне паливо для гоблінів",
        ["Goblin Rocket Fuel"] = "гоблінське ракетне паливо",
    },
    [94266] = {
        ["Craftsman's Writ: Elixir of Agility"] = "Письмо ремісника: Еліксир спритності",
        ["Elixir of Agility"] = "еліксир спритності",
    },
    [94267] = {
        ["Craftsman's Writ: Wildvine Potion"] = "Письмо ремісника: Зілля дикорослої лози",
        ["Wildvine Potion"] = "зілля диколоззя",
    },
    [94268] = {
        ["Craftsman's Writ: Steel Plate Helm"] = "Письмо ремісника: Шолом зі сталевих пластин",
        ["Steel Plate Helm"] = "сталевий шолом",
    },
    [94269] = {
        ["Craftsman's Writ: Inlaid Mithril Cylinder"] = "Письмо майстра: Інкрустований міфриловий циліндр",
        ["Inlaid Mithril Cylinder"] = "інкрустований мітриловий циліндр",
    },
    [94270] = {
        ["Craftsman's Writ: Steel Weapon Chain"] = "Письмо ремісника: сталевий ланцюг для зброї",
        ["Steel Weapon Chain"] = "сталевий ланцюг для зброї",
    },
    [94271] = {
        ["Craftsman's Writ: Ornate Mithril Shoulders"] = "Письмо ремісника: Вишукані міфрилові плечі",
        ["Ornate Mithril Shoulders"] = "Вишукані міфрилові плечі",
    },
    [94272] = {
        ["Blue Glittering Axe"] = "блакитна блискуча сокира",
        ["Craftsman's Writ: Blue Glittering Axe"] = "Письмо ремісника: Синя блискуча сокира",
    },
    [94273] = {
        ["Craftsman's Writ: Moonsteel Broadsword"] = "Письмо майстра: Палаш з місячної сталі",
        ["Moonsteel Broadsword"] = "палаш з місяцесталі",
    },
    [94274] = {
        ["Craftsman's Writ: Golden Scale Coif"] = "Письмо ремісника: Золотий черевик із луски",
        ["Golden Scale Coif"] = "золотий лускатий койф",
    },
    [94275] = {
        ["Craftsman's Writ: Solid Sharpening Stone"] = "Письмо майстра: твердий точильний камінь",
        ["Solid Sharpening Stone"] = "твердий точильний камінь",
    },
    [94276] = {
        ["Craftsman's Writ: Wicked Mithril Blade"] = "Письмо ремісника: Злий міфриловий клинок",
        ["Wicked Mithril Blade"] = "лихий мітриловий клинок",
    },
    [94277] = {
        ["Craftsman's Writ: Truesilver Rod"] = "Письмо майстра: Справжній срібний стрижень",
        ["Truesilver Rod"] = "ясносрібний жезл",
    },
    [94278] = {
        ["Craftsman's Writ: Golden Scale Gauntlets"] = "Письмо ремісника: Золоті лускаті рукавиці",
        ["Golden Scale Gauntlets"] = "золоті лускаті рукавиці",
    },
    [94279] = {
        ["Craftsman's Writ: Heavy Mithril Axe"] = "Письмо ремісника: Важка міфрилова сокира",
        ["Heavy Mithril Axe"] = "важка мітрилова сокира",
    },
    [94280] = {
        ["Craftsman's Writ: Mechanical Dragonling"] = "Письмо ремісника: Механічний дракон",
        ["Mechanical Dragonling"] = "механічне драконеня",
    },
    [94281] = {
        ["Advanced Target Dummy"] = "вдосконалений манекен-мішень",
        ["Craftsman's Writ: Advanced Target Dummy"] = "Письмо майстра: Розширений манекен-мішень",
    },
    [94282] = {
        ["Craftsman's Monocle"] = "монокль ремісника",
        ["Craftsman's Writ: Craftsman's Monocle"] = "Письмо ремісника: Монокль ремісника",
    },
    [94283] = {
        ["Craftsman's Writ: Goblin Land Mine"] = "Письмо ремісника: Гоблінська міна",
        ["Goblin Land Mine"] = "гоблінська міна",
    },
    [94284] = {
        ["Catseye Ultra Goggles"] = "ультраокуляри котячого ока",
        ["Craftsman's Writ: Catseye Ultra Goggles"] = "Письмо майстра: Ультразахисні окуляри котячого ока",
    },
    [94285] = {
        ["Craftsman's Writ: Unstable Trigger"] = "Напис майстра: Нестабільний тригер",
        ["Unstable Trigger"] = "нестабільний пусковий пристрій",
    },
    [94286] = {
        ["Craftsman's Writ: Flash Bomb"] = "Письмо ремісника: Спалахова бомба",
        ["Flash Bomb"] = "світлова бомба",
    },
    [94287] = {
        ["Craftsman's Writ: Fire Goggles"] = "Наказ майстра: Захисні окуляри",
        ["Fire Goggles"] = "вогняні окуляри",
    },
    [94288] = {
        ["Craftsman's Writ: Mithril Frag Bomb"] = "Письмо ремісника: Міфрилова осколкова бомба",
        ["Mithril Frag Bomb"] = "мітрилова осколкова бомба",
    },
    [94289] = {
        ["Craftsman's Writ: Gyromatic Micro-Adjuster"] = "Письмо майстра: Гіроматичний мікрорегулятор",
        ["Gyromatic Micro-Adjustor"] = "гіроматичний мікрорегулятор",
    },
    [94290] = {
        ["Craftsman's Writ: Mechanical Repair Kit"] = "Напис майстра: Комплект для механічного ремонту",
        ["Mechanical Repair Kit"] = "механічний ремкомплект",
    },
    [94291] = {
        ["Craftsman's Writ: Dark Iron Bomb"] = "Письмо ремісника: Темна залізна бомба",
        ["Dark Iron Bomb"] = "бомба з темного заліза",
    },
    [94292] = {
        ["Comfortable Leather Hat"] = "зручний шкіряний капелюх",
        ["Craftsman's Writ: Comfortable Leather Hat"] = "Письмо майстра: Зручний шкіряний капелюх",
    },
    [94293] = {
        ["Craftsman's Writ: Guardian Cloak"] = "Письмо ремісника: Плащ охоронця",
        ["Guardian Cloak"] = "плащ вартового",
    },
    [94294] = {
        ["Craftsman's Writ: Dusky Bracers"] = "Письмо ремісника: Сутінкові наручі",
        ["Dusky Bracers"] = "темні браслети",
    },
    [94295] = {
        ["Craftsman's Writ: Wild Leather Helmet"] = "Письмо ремісника: Шолом дикого шкіри",
        ["Wild Leather Helmet"] = "шолом з дикої шкіри",
    },
    [94296] = {
        ["Craftsman's Writ: Wild Leather Shoulders"] = "Письмо майстра: Дикі шкіряні плечі",
        ["Wild Leather Shoulders"] = "наплічники з дикої шкіри",
    },
    [94297] = {
        ["Craftsman's Writ: Quickdraw Quiver"] = "Письмо ремісника: Сагайдак для швидкого витягування",
        ["Quickdraw Quiver"] = "сагайдак хуткостріла",
    },
    [94298] = {
        ["Craftsman's Writ: Swift Boots"] = "Письмо ремісника: Швидкі чоботи",
        ["Swift Boots"] = "швидкі чоботи",
    },
    [94299] = {
        ["Craftsman's Writ: Nightscape Shoulders"] = "Письмо майстра: Плечі нічного пейзажу",
        ["Nightscape Shoulders"] = "наплечі нічного краєвиду",
    },
    [94300] = {
        ["Big Voodoo Mask"] = "маска потужного вуду",
        ["Craftsman's Writ: Big Voodoo Mask"] = "Письмо майстра: Велика маска вуду",
    },
    [94301] = {
        ["Big Voodoo Robe"] = "мантія потужного вуду",
        ["Craftsman's Writ: Big Voodoo Robe"] = "Письмо ремісника: Великий халат вуду",
    },
    [94302] = {
        ["Craftsman's Writ: Turtle Scale Breastplate"] = "Письмо ремісника: Нагрудник з луски черепахи",
        ["Turtle Scale Breastplate"] = "кіраса з черепашачої луски",
    },
    [94303] = {
        ["Craftsman's Writ: Thick Leather Ammo Pouch"] = "Письмо майстра: Товстий шкіряний підсумок для боєприпасів",
        ["Thick Leather Ammo Pouch"] = "гаман для набоїв з товстої шкіри",
    },
    [94304] = {
        ["Craftsman's Writ: Mageweave Bag"] = "Письмо майстра: Сумка з магічного плетіння",
        ["Mageweave Bag"] = "маготкана сумка",
    },
    [94305] = {
        ["Craftsman's Writ: Shadoweave Gloves"] = "Письмо ремісника: Рукавички з тіньової тканини",
        ["Shadoweave Gloves"] = "тінеткані рукавички",
    },
    [94306] = {
        ["Craftsman's Writ: Crimson Silk Robe"] = "Письмо ремісника: Багряний шовковий халат",
        ["Crimson Silk Robe"] = "багряна шовкова мантія",
    },
    [94307] = {
        ["Craftsman's Writ: Shadoweave Robe"] = "Письмо ремісника: Мантія з тіньотканої тканини",
        ["Shadoweave Robe"] = "тінеткана мантія",
    },
    [94308] = {
        ["Craftsman's Writ: Enchanted Mageweave Pouch"] = "Письмо ремісника: Зачарований мішечок з магічного плетіння",
        ["Enchanted Mageweave Pouch"] = "зачарована маготкана сумка",
    },
    [94309] = {
        ["Craftsman's Writ: Star Belt"] = "Письмо ремісника: Зоряний пояс",
        ["Star Belt"] = "зоряний пояс",
    },
    [94310] = {
        ["Black Mageweave Vest"] = "чорний маготканий жилет",
        ["Craftsman's Writ: Black Mageweave Vest"] = "Письмо ремісника: Чорний жилет з магічного ткацтва",
    },
    [94311] = {
        ["Craftsman's Writ: Red Mageweave Pants"] = "Письмо ремісника: Червоні штани з магічної тканини",
        ["Red Mageweave Pants"] = "червоні маготкані штани",
    },
    [94312] = {
        ["Craftsman's Writ: Orange Martial Shirt"] = "Напис майстра: Помаранчева бойова сорочка",
        ["Orange Martial Shirt"] = "помаранчева бойова сорочка",
    },
    [94313] = {
        ["Craftsman's Writ: White Bandit Mask"] = "Письмо ремісника: Маска білого бандита",
        ["White Bandit Mask"] = "біла бандитська маска",
    },
    [94314] = {
        ["Cindercloth Robe"] = "попеляста мантія",
        ["Craftsman's Writ: Cindercloth Robe"] = "Письмо ремісника: Халат із шлакової тканини",
    },
    [94315] = {
        ["Craftsman's Writ: Earthen Silk Belt"] = "Письмо ремісника: пояс із земляного шовку",
        ["Earthen Silk Belt"] = "шовковий пояс землі",
    },
    [94316] = {
        ["Craftsman's Writ: Potion of Demonslaying"] = "Письмо ремісника: Зілля вбивства демонів",
        ["Potion of Demonslaying"] = "Зілля знищення демонів",
    },
    [94317] = {
        ["Craftsman's Writ: Dreamless Sleep Potion"] = "Письмо ремісника: Зілля сну без сновидінь",
        ["Dreamless Sleep Potion"] = "зілля сну без сновидінь",
    },
    [94318] = {
        ["Craftsman's Writ: Greater Fire Protection Potion"] = "Письмо ремісника: Зілля кращого вогневого захисту",
        ["Greater Fire Protection Potion"] = "велике зілля вогняного захисту",
    },
    [94319] = {
        ["Craftsman's Writ: Draught of Detect Demon"] = "Напис ремісника: Ковток виявлення демона",
        ["Draught of Detect Demon"] = "Ковток виявлення демона",
    },
    [94320] = {
        ["Craftsman's Writ: Gift of Arthas"] = "Письмо ремісника: Дар Артаса",
        ["Gift of Arthas"] = "дар Артаса",
    },
    [94321] = {
        ["Craftsman's Writ: Flask of Chromatic Resistance"] = "Письмо ремісника: Колба хроматичного опору",
        ["Flask of Chromatic Resistance"] = "настій хроматичного опору",
    },
    [94322] = {
        ["Craftsman's Writ: Limited Invulnerability Potion"] = "Письмо ремісника: Зілля обмеженої невразливості",
        ["Limited Invulnerability Potion"] = "зілля обмеженої невразливості",
    },
    [94323] = {
        ["Craftsman's Writ: Major Rejuvenation Potion"] = "Письмо ремісника: Зілля великого омолодження",
        ["Major Rejuvenation Potion"] = "величезне зілля омолодження",
    },
    [94324] = {
        ["Craftsman's Writ: Distilled Firewater"] = "Письмо ремісника: Дистильована вогняна вода",
        ["Distilled Firewater"] = "Дистильована вогняна вода",
    },
    [94325] = {
        ["Craftsman's Writ: Radiant Circlet"] = "Письмо майстра: Сяюче кільце",
        ["Radiant Circlet"] = "променистий вінець",
    },
    [94326] = {
        ["Craftsman's Writ: Radiant Belt"] = "Письмо ремісника: Сяючий пояс",
        ["Radiant Belt"] = "променистий пояс",
    },
    [94327] = {
        ["Craftsman's Writ: Orcish War Leggings"] = "Запис ремісника: бойові поножі орків",
        ["Orcish War Leggings"] = "орчі бойові поножі",
    },
    [94328] = {
        ["Craftsman's Writ: Mithril Spurs"] = "Письмо ремісника: Міфрилові шпори",
        ["Mithril Spurs"] = "мітрилові шпори",
    },
    [94329] = {
        ["Craftsman's Writ: Imperial Plate Chest"] = "Письмо ремісника: Імператорська скриня з латами",
        ["Imperial Plate Chest"] = "імперська латна кіраса",
    },
    [94330] = {
        ["Craftsman's Writ: Darkrune Gauntlets"] = "Письмо ремісника: Рукавиці Темної Руни",
        ["Darkrune Gauntlets"] = "темнорунні рукавиці",
    },
    [94331] = {
        ["Craftsman's Writ: Huge Thorium Battleaxe"] = "Письмо ремісника: Величезна бойова сокира з торію",
        ["Huge Thorium Battleaxe"] = "величезна торієва бойова сокира",
    },
    [94332] = {
        ["Arcanite Skeleton Key"] = "арканітовий ключ-відмичка",
        ["Craftsman's Writ: Arcanite Skeleton Key"] = "Письмо ремісника: Арканітовий скелетний ключ",
    },
    [94333] = {
        ["Craftsman's Writ: Ebon Shiv"] = "Письмо ремісника: Ебон Шив",
        ["Ebon Shiv"] = "ебенова заточка",
    },
    [94334] = {
        ["Craftsman's Writ: Masterwork Target Dummy"] = "Письмо майстра: шедевр-мішень-манекен",
        ["Masterwork Target Dummy"] = "майстерний манекен-мішень",
    },
    [94335] = {
        ["Craftsman's Writ: Green Lens"] = "Письмо майстра: Зелена лінза",
        ["Green Lens"] = "зелена лінза",
    },
    [94336] = {
        ["Craftsman's Writ: Lifelike Mechanical Toad"] = "Письмо майстра: Реалістична механічна жаба",
        ["Lifelike Mechanical Toad"] = "механічна жаба",
    },
    [94337] = {
        ["Craftsman's Writ: Gnomish Alarm-O-Bot"] = "Письмо майстра: Гномський сигналізатор",
        ["Gnomish Alarm-O-Bot"] = "гномський тривого-бот",
    },
    [94338] = {
        ["Craftsman's Writ: Goblin Jumper Cables XL"] = "Письмо майстра: Кабелі для перемички гоблінський XL",
        ["Goblin Jumper Cables XL"] = "гоблінський кабельний дефібрилятор Макс-Про",
    },
    [94339] = {
        ["Craftsman's Writ: Field Repair Bot 74A"] = "Напис майстра: Польовий ремонтний бот 74A",
        ["Field Repair Bot 74A"] = "польовий ремонтний робот 74A",
    },
    [94340] = {
        ["Craftsman's Writ: Truesilver Transformer"] = "Письмо майстра: Трансформатор ясносрібний",
        ["Truesilver Transformer"] = "ясносрібний перетворювач",
    },
    [94341] = {
        ["Craftsman's Writ: Sniper Scope"] = "Письмо майстра: Снайперський приціл",
        ["Sniper Scope"] = "снайперський приціл",
    },
    [94342] = {
        ["Craftsman's Writ: Tranquil Mechanical Yeti"] = "Письмо майстра: Спокійний механічний єті",
        ["Tranquil Mechanical Yeti"] = "спокійний механічний єті",
    },
    [94343] = {
        ["Craftsman's Writ: Wicked Leather Pants"] = "Письмо майстра: Злі шкіряні штани",
        ["Wicked Leather Pants"] = "лихі шкіряні штани",
    },
    [94344] = {
        ["Craftsman's Writ: Gordok Ogre Suit"] = "Письмо ремісника: Костюм огра Гордока",
        ["Gordok Ogre Suit"] = "костюм ґордоцького огра",
    },
    [94345] = {
        ["Craftsman's Writ: Volcanic Breastplate"] = "Письмо ремісника: Вулканічний нагрудник",
        ["Volcanic Breastplate"] = "вулканічна кіраса",
    },
    [94346] = {
        ["Craftsman's Writ: Runic Leather Headband"] = "Письмо ремісника: Рунічна шкіряна пов'язка на голову",
        ["Runic Leather Headband"] = "рунічна шкіряна пов'язка",
    },
    [94347] = {
        ["Craftsman's Writ: Wicked Leather Bracers"] = "Письмо майстра: Злі шкіряні наручі",
        ["Wicked Leather Bracers"] = "лихі шкіряні браслети",
    },
    [94348] = {
        ["Chimeric Vest"] = "химеричний жилет",
        ["Craftsman's Writ: Chimeric Vest"] = "Письмо ремісника: Химерний жилет",
    },
    [94349] = {
        ["Craftsman's Writ: Heavy Scorpid Helm"] = "Письмо ремісника: Важкий шолом скорпіда",
        ["Heavy Scorpid Helm"] = "важкий шолом з луски скорпіда",
    },
    [94350] = {
        ["Craftsman's Writ: Runic Leather Bracers"] = "Письмо майстра: Рунічні шкіряні наручі",
        ["Runic Leather Bracers"] = "рунічні шкіряні браслети",
    },
    [94351] = {
        ["Craftsman's Writ: Frostsaber Boots"] = "Письмо ремісника: Чоботи морозного меча",
        ["Frostsaber Boots"] = "чоботи кригозуба",
    },
    [94352] = {
        ["Craftsman's Writ: Wizardweave Turban"] = "Письмо майстра: Чарівний тюрбан",
        ["Wizardweave Turban"] = "чароплетений тюрбан",
    },
    [94353] = {
        ["Craftsman's Writ: Runecloth Bag"] = "Письмо ремісника: Сумка з рунічної тканини",
        ["Runecloth Bag"] = "сумка з рунічного полотна",
    },
    [94354] = {
        ["Craftsman's Writ: Runecloth Boots"] = "Письмо ремісника: Чоботи з рунічної тканини",
        ["Runecloth Boots"] = "чоботи з рунічного полотна",
    },
    [94355] = {
        ["Craftsman's Writ: Tuxedo Jacket"] = "Письмо майстра: Смокінг-піджак",
        ["Tuxedo Jacket"] = "вишуканий жакет",
    },
    [94356] = {
        ["Craftsman's Writ: Felcloth Boots"] = "Письмо ремісника: Чоботи з тканини Скверни",
        ["Felcloth Boots"] = "сквернополотняні черевики",
    },
    [94357] = {
        ["Cenarion Herb Bag"] = "кенарійська сумка для трав",
        ["Craftsman's Writ: Cenarion Herb Bag"] = "Письмо ремісника: Мішечок з травами Кенаріона",
    },
    [94358] = {
        ["Craftsman's Writ: Shadoweave Mask"] = "Письмо ремісника: Маска Тіньової Шерсті",
        ["Shadoweave Mask"] = "тінеткана маска",
    },
    [94359] = {
        ["Craftsman's Writ: Ghostweave Vest"] = "Письмо ремісника: Жилет з привидового ткацтва",
        ["Ghostweave Vest"] = "жилет з примарного полотна",
    },
    [94360] = {
        ["Craftsman's Writ: Soul Pouch"] = "Письмо ремісника: Мішечок душі",
        ["Soul Pouch"] = "мішечок душ",
    },
    [94369] = {
        ["Speak with Talaanis Shadowsong"] = "Поговоріть з Талаанісом Тіньоспівом",
    },
    [94373] = {
        ["Iceclaw Bear Pendant"] = "Кулон «Ведмідь Крижаний Кіготь»",
        ["Iceclaw Bear Pendant (Provided)"] = "Кулон «Ведмідь Крижаний Кіготь» (видано)",
        ["Iceclaw Bear Pendant slain"] = "Кулон «Ведмідь Крижаний Кіготь»: убито",
    },
    [94374] = {
        ["Earth Sapta"] = "сапта землі",
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
    [94434] = {
        ["Linen Cloth"] = "лляна тканина",
    },
    [94436] = {
        ["Speak with Deathguard Billmuth at Tyr's Watch."] = "Поговоріть зі Смертельним Вартом Біллмутом у Варті Тіра.",
    },
    [94438] = {
        ["Take the Symbol of Life and use it to resurrect Deathguard Falgan at Venomweb Vale."] = "Візьміть Символ Життя та використовуйте його, щоб воскресити Стража Смерті Фалгана у Веномвеб-Великій Долині.",
    },
    [94440] = {
        ["Scarlet Crusade Attack Plans"] = "Плани атаки Червоного хрестового походу",
    },
    [94465] = {
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
        ["Torch of the Dormant Flame (Provided)"] = "смолоскип дрімаючого полум'я (видано)",
    },
    [94466] = {
        ["Fire Tar"] = "вогняна смола",
        ["Reagent Pouch"] = "мішечок з реагентами",
    },
    [94467] = {
        ["Glowing Ember"] = "розжарена вуглинка",
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
        ["Torch of the Dormant Flame (Provided)"] = "смолоскип дрімаючого полум'я (видано)",
    },
    [94468] = {
        ["Torch of the Eternal Flame"] = "смолоскип вічного полум'я",
        ["Torch of the Eternal Flame (Provided)"] = "смолоскип вічного полум'я (видано)",
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
    [94490] = {
        ["Ripped Missive"] = "Розірваний лист",
    },
    [94491] = {
        ["Mysterious Orders"] = "Таємничі ордени",
    },
    [94497] = {
        ["Full Brown Waterskin"] = "Повний коричневий бурдюк",
    },
    [94499] = {
        ["Full Red Waterskin"] = "Повний червоний бурдюк",
    },
    [94500] = {
        ["Full Blue Waterskin"] = "Повний синій бурдюк для води",
    },
    [94501] = {
        ["Vial of Purest Water"] = "фіал найчистішої води",
        ["Vial of Purest Water (Provided)"] = "фіал найчистішої води (видано)",
    },
    [94502] = {
        ["Corrupt Manifestation's Bracers"] = "наручі зіпсованого прояву",
        ["Remaining Drops of Purest Water"] = "залишки крапель найчистішої води",
        ["Remaining Drops of Purest Water (Provided)"] = "залишки крапель найчистішої води (видано)",
    },
    [94505] = {
        ["Shard of Water"] = "осколок води",
        ["Shard of Water (Provided)"] = "осколок води (видано)",
    },
    [94559] = {
        ["Find the Al'Aketh Turncoat"] = "Знайдіть перебіжчика Ал'Акета",
    },
    [94568] = {
        ["Learn what you can from the crystal"] = "Дізнайтеся, що ви можете, з кристала",
    },
    [94638] = {
        ["Ur'endra slain"] = "Ур'ендра: убито",
    },
    [94792] = {
        ["Tame a Rockhide Boar"] = "Приручити кам'яного кабана",
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94863] = {
        ["Tame a Gray Forest Wolf"] = "Приручити сірого лісового вовка",
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94864] = {
        ["Tame a Young Forest Bear"] = "Приручіть молодого лісового ведмедя",
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
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
    [94898] = {
        ["Wind Hollow slain"] = "Вітрова западина: убито",
    },
    [94947] = {
        ["Take the Skyborne Portal to Stormwind"] = "Віднесіть Небесний портал до Штормграда",
    },
    [94978] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [94979] = {
        ["Taming Rod"] = "жезл приборкання",
        ["Taming Rod (Provided)"] = "жезл приборкання (видано)",
    },
    [95034] = {
        ["Speak with Lumina Windsinger"] = "Поговоріть з Люміною Віндсінгер",
    },
    [95036] = {
        ["Enchanted Silver Ingot"] = "Зачарований срібний злиток",
        ["Purified Kor Gem"] = "очищений самоцвіт Кора",
        ["Trevan's Weapon Notes"] = "Нотатки Тревана про зброю",
        ["Whitestone Oak Lumber"] = "деревина білокам'яного дуба",
    },
    [95041] = {
        ["Gnomeregan Archival Data"] = "Архівні дані Гномерегану",
        ["Gnomeregan Archival Data (Provided)"] = "Архівні дані Гномерегану (видано)",
        ["Gnomeregan Archival Data slain"] = "Архівні дані Гномерегану: убито",
    },
    [95042] = {
        ["Corrupted Kor Gem"] = "осквернений самоцвіт Кора",
    },
    [95065] = {
        ["Nightcrawlers"] = "опариші",
        ["Nightcrawlers (Provided)"] = "опариші (видано)",
        ["Shiny Bauble"] = "блискуча блешня",
        ["Shiny Bauble (Provided)"] = "блискуча блешня (видано)",
    },
    [95111] = {
        ["Bundle of Blacksmithing Materials"] = "Набір ковальських матеріалів",
        ["Bundle of Blacksmithing Materials (Provided)"] = "Набір ковальських матеріалів (видано)",
    },
    [95125] = {
        ["Watch Ott craft the blade"] = "Дивіться, як Отт виготовляє клинок",
    },
    [95126] = {
        ["Ott's Masterwork"] = "Шедевр Отта",
        ["Ott's Masterwork (Provided)"] = "Шедевр Отта (видано)",
    },
    [95140] = {
        ["Moonsilver Blade"] = "Клинок Місячно-срібного кольору",
        ["Old Fire-Eye slain"] = "Старий Вогняний Око: убито",
    },
    [95161] = {
        ["Blood-Stained Letter"] = "Лист, заплямований кров’ю",
        ["Blood-Stained Letter (Provided)"] = "Лист, заплямований кров’ю (видано)",
    },
    [95189] = {
        ["Crest of Lordaeron"] = "Герб Лордерона",
        ["Crest of Lordaeron (Provided)"] = "Герб Лордерона (видано)",
    },
    [95195] = {
        ["Bloodied Insignia"] = "Закривавлені знаки розрізнення",
        ["Bloodied Insignia (Provided)"] = "Закривавлені знаки розрізнення (видано)",
    },
    [95204] = {
        ["Crest of Lordaeron"] = "Герб Лордерона",
        ["Crest of Lordaeron (Provided)"] = "Герб Лордерона (видано)",
    },
    [95212] = {
        ["Pristine Leopard Pelt"] = "Незаймана леопардова шкура",
        ["Pristine Leopard Pelt (Provided)"] = "Незаймана леопардова шкура (видано)",
        ["Pristine Leopard Pelt slain"] = "Незаймана леопардова шкура: убито",
    },
    [95213] = {
        ["Empty Powder Keg"] = "Порожня порохова бочка",
    },
    [95214] = {
        ["Stolen Blasting Powder"] = "Вкрадений вибуховий порошок",
    },
    [95216] = {
        ["Highly Toxic Strain"] = "Високотоксичний штам",
        ["Highly Toxic Strain (Provided)"] = "Високотоксичний штам (видано)",
        ["Highly Toxic Strain slain"] = "Високотоксичний штам: убито",
    },
    [95217] = {
        ["Copper Bar"] = "злиток міді",
        ["Toughened Boar Hide"] = "Загартована кабаняча шкура",
    },
    [95250] = {
        ["Head of the Baron"] = "Голова барона",
    },
    [95314] = {
        ["Bottle of Whispering Elixir"] = "Пляшка еліксиру шепоту",
    },
    [95328] = {
        ["Whispering Horror Residue"] = "Шепіт жахливого залишку",
    },
    [95494] = {
        ["Savannah Lion Hide"] = "Шкура лева савани",
    },
    [95495] = {
        ["Bundle of Hides"] = "оберемок шкур",
        ["Bundle of Hides (Provided)"] = "оберемок шкур (видано)",
    },
    [95507] = {
        ["Trapped Game"] = "Гра в пастці",
    },
    [95508] = {
        ["Assist Walton"] = "Асист Волтона",
    },
    [95621] = {
        ["Benedict's Orders"] = "Ордени Бенедикта",
    },
    [95771] = {
        ["Scout through the Fargodeep Mine"] = "Дослідіть Бездонну копальню",
    },
    [95774] = {
        ["Olgra's Adornments"] = "Прикраси Ольгри",
    },
    [95803] = {
        ["Rudolph Gelhardt's Head"] = "Голова Рудольфа Гельхардта",
        ["Rudolph Gelhardt's Head (Provided)"] = "Голова Рудольфа Гельхардта (видано)",
    },
    [95805] = {
        ["Pouch of Smoldering Incense"] = "Мішечок тліючого ладану",
        ["Pouch of Smoldering Incense (Provided)"] = "Мішечок тліючого ладану (видано)",
    },
    [95816] = {
        ["Advertising License Application"] = "Заява на ліцензію на рекламу",
        ["Massive Pile of Completed Forms"] = "Величезна купа заповнених форм",
    },
    [95819] = {
        ["Advertising License Application"] = "Заява на ліцензію на рекламу",
        ["Massive Pile of Completed Forms"] = "Величезна купа заповнених форм",
    },
    [95883] = {
        ["Tortured Soul"] = "Закатована душа",
    },
    [95884] = {
        ["Note Scrap"] = "Записка",
    },
    [95885] = {
        ["Release Tortured Soul"] = "Звільніть змучену душу",
        ["Tortured Soul slain"] = "закатована душа: убито",
        ["Willingly offer blood"] = "Охоче пропонувати кров",
    },
    [95981] = {
        ["Dalaran Watcher slain"] = "даларанський наглядач: убито",
        ["Dalaran Wizard slain"] = "даларанський чарівник: убито",
    },
    [95998] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [95999] = {
        ["Broken Staff of Incinerator Gar'im"] = "Зламаний посох сміттєспалювача Гар'їм",
    },
    [96031] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [96044] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [96045] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [96046] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
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
    [96058] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [96059] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [96101] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96102] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [96130] = {
        ["Chakuyak's Pelt"] = "Шкура Чакуяка",
    },
    [96137] = {
        ["Black Ravager slain"] = "чорний спустошник: убито",
        ["Ira's Dagger"] = "Кинджал Іри",
        ["Ira's Dagger (Provided)"] = "Кинджал Іри (видано)",
        ["Young Black Ravager slain"] = "молодий чорний спустошник: убито",
    },
    [96138] = {
        ["Merrick's Bow"] = "Лук Мерріка",
        ["Merrick's Bow (Provided)"] = "Лук Мерріка (видано)",
        ["Splinter Fist Taskmaster slain"] = "орудар Сколотого Кулака: убито",
        ["Splinter Fist Warrior slain"] = "воїн Сколотого Кулака: убито",
    },
    [96139] = {
        ["Raven Hill Tome"] = "Том Рейвен Гілл",
    },
    [96204] = {
        ["Escort Lumina Windsinger to safety"] = "Супровід Луміни Віндсінгер у безпечне місце",
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
    [96395] = {
        ["Faldrim Anvilmar slain"] = "Фалдрім Анвілмар: убито",
    },
    [96403] = {
        ["Dwarven Heirloom"] = "Гномська реліквія",
        ["Dwarven Heirloom (Provided)"] = "Гномська реліквія (видано)",
        ["Dwarven Heirloom slain"] = "Гномська реліквія: убито",
    },
    [96604] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96605] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96606] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96607] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96608] = {
        ["Gain the Boosted Rest buff"] = "Отримайте бафф «Посилений відпочинок»",
        ["Use the /sit emote near the campfire"] = "Використайте емодзі /сидіти біля багаття",
    },
    [96626] = {
        ["Learn cooking from Tomas in Goldshire"] = "Навчіться готувати у Томаса в Голдширі",
    },
    [96628] = {
        ["Supply Bundle"] = "пакунок з припасами",
        ["Supply Bundle (Provided)"] = "пакунок з припасами (видано)",
    },
    [96629] = {
        ["Learn cooking from Gremlock Pilsnor in Kharanos"] = "Навчіться готувати у Гремлока Пілснора в Хараносі",
    },
    [96630] = {
        ["Lost Journal"] = "Втрачений щоденник",
        ["Lost Journal (Provided)"] = "Втрачений щоденник (видано)",
    },
    [96634] = {
        ["Learn cooking from Zarrin in Dolanaar"] = "Навчіться готувати у Зарріна в Доланаарі",
    },
    [96646] = {
        ["Learn cooking from Zerril Softbreeze in Shen'dar Village"] = "Навчіться готувати у Зерріл Софтбріз у селі Шен'дар",
    },
    [96652] = {
        ["Lost Journal"] = "Втрачений щоденник",
        ["Lost Journal (Provided)"] = "Втрачений щоденник (видано)",
    },
    [96655] = {
        ["Learn cooking from Cook Torka in Razor Hill"] = "Навчіться готувати у кухаря Торки в Рейзор-Гілл",
    },
    [96658] = {
        ["Learn cooking from William Pickman in Brill"] = "Навчіться кулінарії у Вільяма Пікмана в Бріллі",
    },
    [96659] = {
        ["Supply Bundle"] = "пакунок з припасами",
        ["Supply Bundle (Provided)"] = "пакунок з припасами (видано)",
    },
    [96661] = {
        ["Learn cooking from Pyall Silentstride in Bloodhoof Village"] = "Навчіться готувати у Пайалла Безмовної Стриби в селі Криваве Копито",
    },
    [96821] = {
        ["Ridgeshade Creeper slain"] = "Ріджшейд-Кріпер: убито",
        ["Ridgeshade Lurker slain"] = "Прихований Ріджшейд: убито",
    },
    [96822] = {
        ["Raider's Battleaxe"] = "Бойова сокира рейдера",
        ["Raider's Bow"] = "Лук рейдера",
        ["Raider's Shield"] = "щит рейдера",
    },
    [96825] = {
        ["Prickly Pear Fruit"] = "Плід опунції",
    },
    [96873] = {
        ["Luminous Residue"] = "Світловий залишок",
    },
    [96874] = {
        ["Rough Grinding Stone"] = "грубий шліфувальний камінь",
        ["Weathered Spine"] = "Вивітрюваний хребет",
    },
    [96875] = {
        ["Cured Light Hide"] = "оброблена легка шкура",
        ["Rough Lizard Hide"] = "Шорстка шкура ящірки",
    },
    [96876] = {
        ["Ukor's Lost Pack"] = "Загублений пакет Укора",
        ["Ukor's Lost Pack (Provided)"] = "Загублений пакет Укора (видано)",
    },
    [96877] = {
        ["Halikor's Hoof"] = "Копито Халікора",
        ["Halikor's Hoof (Provided)"] = "Копито Халікора (видано)",
    },
    [96897] = {
        ["Dark Enforcer slain"] = "Темний Виконавець: убито",
        ["Dark Neophyte slain"] = "Темний неофіт: убито",
    },
    [96898] = {
        ["Necrotic Crystal Fragment"] = "Фрагмент некротичного кристала",
    },
    [97003] = {
        ["Chol'aruk's Head"] = "Голова Чол'арука",
    },
    [97005] = {
        ["Chol'aruk's Head"] = "Голова Чол'арука",
    },
    [97065] = {
        ["Keefer's Angelfish"] = "риба-ангел Кіфера",
    },
    [97066] = {
        ["Brownell's Blue Striped Racer"] = "синій смугастик Браунелла",
    },
    [97067] = {
        ["Dezian Queenfish"] = "дезійська ставрида",
    },
    [97220] = {
        ["Gatehouse Shipment"] = "Відвантаження на сторожку",
        ["Gatehouse Shipment (Provided)"] = "Відвантаження на сторожку (видано)",
    },
    [97222] = {
        ["Gatehouse Shipment delivered"] = "Доставка на сторожку",
    },
    [97223] = {
        ["Bloodtalon Martriarch Eggs"] = "Яйця Кров'яного Кігтя-Жертволомця",
    },
    [97225] = {
        ["Forgotten Loa Idol"] = "Забутий ідол Лоа",
    },
    [97234] = {
        ["Wrapped Reading Material"] = "Матеріали для читання в упаковці",
        ["Wrapped Reading Material (Provided)"] = "Матеріали для читання в упаковці (видано)",
    },
    [97237] = {
        ["Cycles of Morality"] = "Цикли моралі",
        ["Field Accounts of Horde Razings"] = "Польові звіти про розгром Орди",
        ["The Forsaken Ally"] = "Покинутий союзник",
        ["Trollbane Conquests"] = "Завоювання Тролльбейна",
    },
    [97242] = {
        ["Handful of Cattails"] = "Жменя рогозу",
        ["Speargrass Cuttings"] = "Живці коприволистої трави",
    },
    [97243] = {
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
        ["Torch of the Dormant Flame (Provided)"] = "смолоскип дрімаючого полум'я (видано)",
    },
    [97244] = {
        ["Faladiel's Heart"] = "Серце Фаладіеля",
    },
    [97245] = {
        ["Kuramaa's Mask"] = "Маска Курамаа",
    },
    [97249] = {
        ["Migi's Lunch"] = "Обід у Мігі",
        ["Migi's Lunch (Provided)"] = "Обід у Мігі (видано)",
    },
    [97250] = {
        ["Encroaching Soldier slain"] = "Зазіхаючий солдат: убито",
        ["Outraged Pillager slain"] = "Обурений грабіжник: убито",
    },
    [97253] = {
        ["Handful of Complicated Parts"] = "Кілька складних деталей",
    },
    [97257] = {
        ["Complete the Ritual with Olariaan"] = "Завершіть ритуал з Оларіаном",
        ["Light the Brazier of Eternal Flame"] = "Запаліть жаровню Вічного вогню",
        ["Torch of Eternal Flame"] = "Факел Вічного Вогню",
        ["Torch of Eternal Flame (Provided)"] = "Факел Вічного Вогню (видано)",
    },
    [97263] = {
        ["Misplaced Package"] = "Загублений пакет",
        ["Misplaced Package (Provided)"] = "Загублений пакет (видано)",
    },
    [97275] = {
        ["Yelmak's Potion"] = "Зілля Єлмака",
        ["Yelmak's Potion (Provided)"] = "Зілля Єлмака (видано)",
    },
    [97277] = {
        ["Gozwin's Mechanic's Log"] = "журнал механіка Ґозвіна",
        ["Gozwin's Mechanic's Log (Provided)"] = "журнал механіка Ґозвіна (видано)",
        ["Snow Leopard Prowler"] = "сніжний леопард-скрадач",
        ["Snow Leopard Prowler slain"] = "сніжний леопард-скрадач: убито",
    },
    [97279] = {
        ["Abandoned Training Weapon"] = "Покинута навчальна зброя",
        ["Abandoned Training Weapon (Provided)"] = "Покинута навчальна зброя (видано)",
        ["Abandoned Training Weapon slain"] = "Покинута навчальна зброя: убито",
    },
    [97282] = {
        ["Charged Thunder Lizard Organ"] = "Орган зарядженої грімової ящірки",
    },
    [97288] = {
        ["Abominable Head"] = "Огидна Голова",
        ["Abominable Head (Provided)"] = "Огидна Голова (видано)",
        ["Deliver the Abominable Head to someone within the Undercity."] = "Доставте Гидку Голову комусь у Підмісті.",
    },
    [97289] = {
        ["Head of the Baron"] = "Голова барона",
        ["Head of the Baron (Provided)"] = "Голова барона (видано)",
    },
    [97291] = {
        ["Blisterweed"] = "Пухирник",
        ["Essence of Agony"] = "сутність агонії",
        ["Toxic Skullcap"] = "Токсичний черепок",
    },
    [97292] = {
        ["Hissing Serum"] = "Шипляча сироватка",
        ["Hissing Serum (Provided)"] = "Шипляча сироватка (видано)",
        ["Hissing Serum administered"] = "Введена шипляча сироватка",
    },
    [97326] = {
        ["Smooth Boulder"] = "Гладкий валун",
    },
    [97485] = {
        ["Prepared Incense"] = "Підготовлений пахощ",
        ["Spread incense"] = "Розпорошити пахощі",
    },
    [97538] = {
        ["Mirkweed Pods"] = "Стручки лихоцвіту",
    },
    [97558] = {
        ["Darkhound Hide"] = "Шкура Темного Пса",
        ["Duskbat Wing Membrane"] = "Мембрана крила Сутінкового Кажана",
        ["Vile Fin Murloc Skin"] = "Скін Мерзенного Плавця Мурлока",
    },
    [97583] = {
        ["Nutritious Slime Sludge"] = "Поживний слизовий мул",
    },
    [97891] = {
        ["Speak to Doctor Martin Felben"] = "Поговоріть з доктором Мартіном Фельбеном",
    },
    [97894] = {
        ["Take the boat to Auberdine and find Gorbold Steelhand."] = "Сядь на човен до Обердіна та знайди Горбольда Сталерукого.",
    },
    [97899] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97900] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97901] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [97902] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [97903] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97904] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97905] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97906] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97907] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97908] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97914] = {
        ["Thundris' Letter"] = "Лист Тундріса",
        ["Thundris' Letter (Provided)"] = "Лист Тундріса (видано)",
    },
    [97915] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97916] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97917] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
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
    [97922] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97923] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97924] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97925] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97926] = {
        ["Alexston's Reply"] = "Відповідь Алексстона",
        ["Alexston's Reply (Provided)"] = "Відповідь Алексстона (видано)",
    },
    [97927] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97928] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97929] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [97930] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [97931] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97932] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97933] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97934] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97935] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97936] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97937] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97938] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97939] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97940] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [97941] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [97942] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97943] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97944] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97946] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97948] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97949] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97950] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97951] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97952] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97953] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [97954] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [97955] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97956] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97957] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97958] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97959] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97960] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97961] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97963] = {
        ["Raise your alchemy skill to 20"] = "Підвищте свою навичку алхімії до 20",
    },
    [97964] = {
        ["Raise your blacksmithing skill to 20"] = "Підвищіть навичку ковальства до 20",
    },
    [97965] = {
        ["Raise your first aid skill to 20"] = "Підвищіть навичку першої допомоги до 20",
    },
    [97967] = {
        ["Raise your fishing skill to 20"] = "Підвищте свій рівень риболовлі до 20",
    },
    [97968] = {
        ["Raise your herbalism skill to 20"] = "Підвищте свій рівень навичок травництва до 20",
    },
    [97969] = {
        ["Raise your leatherworking skill to 20"] = "Підвищте свою майстерність обробки шкіри до 20",
    },
    [97970] = {
        ["Raise your mining skill to 20"] = "Підвищте свій рівень майнінгу до 20",
    },
    [97971] = {
        ["Raise your skinning skill to 20"] = "Підвищте свою навичку зняття шкури до 20",
    },
    [97972] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97973] = {
        ["Raise your tailoring skill to 20"] = "Підвищте свою кравецьку майстерність до 20",
    },
    [97977] = {
        ["Gnarlpine Totem"] = "Тотем Гнарлсосни",
    },
    [97979] = {
        ["Elune's Light cast"] = "Акторський склад «Світла Елуни»",
        ["Shadowmeld cast"] = "Акторський склад Shadowmeld",
    },
    [98013] = {
        ["Stormscale Myrmidon slain"] = "штормолуский мірмідон: убито",
        ["Stormscale Sorceress slain"] = "штормолуска чаклунка: убито",
        ["Stormscale Warrior slain"] = "штормолуский воїн: убито",
    },
    [98025] = {
        ["Feather of Jai'vhanel"] = "Перо Джайвханеля",
    },
    [98028] = {
        ["Clouded Water Globe"] = "Замутнена водна куля",
        ["Clouded Water Globe (Provided)"] = "Замутнена водна куля (видано)",
    },
    [98042] = {
        ["Peerless Eye"] = "Незрівнянне Око",
    },
    [98046] = {
        ["Drained Vessel"] = "Осушене судно",
        ["Drained Vessel (Provided)"] = "Осушене судно (видано)",
    },
    [98065] = {
        ["Moonwell Remnants"] = "Залишки Місячної Колодязі",
        ["Moonwell Remnants (Provided)"] = "Залишки Місячної Колодязі (видано)",
    },
    [98067] = {
        ["Cenarion Hold depths entrance"] = "Вхід до глибин фортеці Кенаріона",
        ["Cenarion Hold depths entrance (Provided)"] = "Вхід до глибин фортеці Кенаріона (видано)",
        ["Cenarion Hold depths entrance slain"] = "Вхід до глибин фортеці Кенаріона: убито",
        ["City Gate"] = "Міська брама",
        ["City Gate (Provided)"] = "Міська брама (видано)",
        ["City Gate slain"] = "Міська брама: убито",
        ["Craftsman's Terrace Inn"] = "Готель «Craftsman's Terrace Inn»",
        ["Craftsman's Terrace Inn (Provided)"] = "Готель «Craftsman's Terrace Inn» (видано)",
        ["Craftsman's Terrace Inn slain"] = "Готель «Craftsman's Terrace Inn»: убито",
        ["Darnassus Bank"] = "Банк Дарнас",
        ["Darnassus Bank (Provided)"] = "Банк Дарнас (видано)",
        ["Darnassus Bank slain"] = "Банк Дарнас: убито",
    },
    [98072] = {
        ["Pristine Crimson Scale"] = "Незаймана багряна луска",
    },
    [98093] = {
        ["Hecklefang Stalker slain"] = "бісозубий ловець: убито",
        ["Stormhide slain"] = "бурешкур: убито",
    },
    [98094] = {
        ["Darthalia's Orders"] = "Накази Дарталії",
        ["Darthalia's Orders (Provided)"] = "Накази Дарталії (видано)",
    },
    [98095] = {
        ["Northern vial placed"] = "Північна флакон розміщено",
        ["Southern vial placed"] = "Південний флакон розміщено",
        ["Western vial placed"] = "Західний флакон розміщено",
    },
    [98189] = {
        ["Menethil Statuette"] = "статуетка Менетіла",
        ["Menethil Statuette (Provided)"] = "статуетка Менетіла (видано)",
    },
    [98190] = {
        ["Menethil Statuette"] = "статуетка Менетіла",
        ["Menethil Statuette (Provided)"] = "статуетка Менетіла (видано)",
    },
    [98191] = {
        ["Menethil Statuette"] = "статуетка Менетіла",
        ["Menethil Statuette (Provided)"] = "статуетка Менетіла (видано)",
    },
    [98197] = {
        ["Khaz Modan Iron"] = "Хаз Модан Айрон",
        ["Khaz Modan Timber"] = "Тимбер Хаз Модан",
    },
    [98208] = {
        ["Nord'el"] = "Норд'ел",
    },
    [98240] = {
        ["Crimson Crate"] = "Багряний ящик",
        ["Crimson Crate (Provided)"] = "Багряний ящик (видано)",
    },
    [98245] = {
        ["Razormaw Incisor"] = "Різець бритвогубий",
    },
    [98246] = {
        ["Perfect Razormaw Egg"] = "Ідеальне яйце бритвогуба",
    },
    [98247] = {
        ["Shipping Label"] = "Етикетка доставки",
    },
    [98248] = {
        ["Shipping Label"] = "Етикетка доставки",
    },
    [98251] = {
        ["Ashenvale Bear slain"] = "ясенедільський ведмідь: убито",
        ["Shadowhorn Stag slain"] = "тінерогий олень: убито",
    },
    [98252] = {
        ["Eye of Kilrogg guided to the road"] = "Око Кілрогга, спрямоване на дорогу",
    },
    [98282] = {
        ["Unruptured Stalker Gland"] = "Нерозривна залоза сталкера",
    },
    [98284] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [98285] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [98286] = {
        ["Raise your enchanting skill to 20"] = "Підвищте свою майстерність зачарування до 20",
    },
    [98287] = {
        ["Raise your engineering skill to 20"] = "Підвищте свій інженерний рівень до 20",
    },
    [98293] = {
        ["Dragonmaw Armaments"] = "Озброєння Драконячої Пащі",
    },
    [98298] = {
        ["Worgen Bits"] = "Біти Воргена",
    },
    [98299] = {
        ["Haggard Refugee slain"] = "змучений біженець: убито",
        ["Sickly Refugee slain"] = "кволий біженець: убито",
    },
    [98319] = {
        ["Mountaineer Cornelius found"] = "Альпініст Корнеліус знайшов",
        ["Mountaineer Cornelius found (Provided)"] = "Альпініст Корнеліус знайшов (видано)",
        ["Mountaineer Cornelius found slain"] = "Альпініст Корнеліус знайшов: убито",
    },
    [98321] = {
        ["Flintfire's Shipment"] = "вантаж Кресала",
        ["Flintfire's Shipment (Provided)"] = "вантаж Кресала (видано)",
    },
    [98323] = {
        ["Mountaineer Gretchen's Report"] = "Звіт альпіністки Гретхен",
        ["Mountaineer Gretchen's Report (Provided)"] = "Звіт альпіністки Гретхен (видано)",
        ["Mountaineer Gretchen's Report slain"] = "Звіт альпіністки Гретхен: убито",
    },
    [98326] = {
        ["Sack of Fish"] = "Мішок риби",
        ["Sack of Fish (Provided)"] = "Мішок риби (видано)",
        ["Sack of Fish slain"] = "Мішок риби: убито",
    },
    [98342] = {
        ["Relic of the Claw"] = "Реліквія Кігтя",
        ["Relic of the Fang"] = "Реліквія Ікла",
        ["Relic of the Silent Shadow"] = "Реліквія Мовчазної Тіні",
    },
    [98386] = {
        ["Greater Tarantula"] = "Великий тарантул",
        ["Greater Tarantula slain (12) Greater Tarantula"] = "Вбито великого тарантула (12) Великий тарантул",
    },
    [98387] = {
        ["Stolen Supplies"] = "Крадені припаси",
        ["Stolen Weapon"] = "Викрадена зброя",
    },
    [98389] = {
        ["Webbed Forsaken freed"] = "Звільнений Павутинний Відрек",
    },
    [98392] = {
        ["Hatescreech's Amulet"] = "Амулет Ненависного Крику",
        ["Windmistress Gaedress' Amulet"] = "Амулет Господині Вітрів Гедри",
        ["Witchmother Arysa's Amulet"] = "Амулет Відьми-Матері Ариси",
    },
    [98396] = {
        ["Relic of the Claw"] = "Реліквія Кігтя",
        ["Relic of the Fang"] = "Реліквія Ікла",
        ["Relic of the Silent Shadow"] = "Реліквія Мовчазної Тіні",
    },
    [98403] = {
        ["Befouled Webwood slain"] = "Забруднений Павутин: убито",
        ["Mature Fel Moss"] = "Зрілий мох Скверни",
    },
    [98404] = {
        ["Relic of the Claw"] = "Реліквія Кігтя",
        ["Relic of the Fang"] = "Реліквія Ікла",
        ["Relic of the Silent Shadow"] = "Реліквія Мовчазної Тіні",
    },
    [98407] = {
        ["Spiked Collar"] = "шипастий нашийник",
    },
    [98423] = {
        ["Treaty of Understanding"] = "Договір про взаєморозуміння",
        ["Treaty of Understanding (Provided)"] = "Договір про взаєморозуміння (видано)",
    },
    [98424] = {
        ["Barrens Operations Best Practices"] = "Найкращі практики операцій у степах",
        ["Mulgore Expansion Plans"] = "Плани розширення Мулгора",
        ["One \"Gerenzo\", of Stonetalon"] = "Один «Геренцо» з Стоунталона",
        ["Shredder Operation Instructions"] = "Інструкції з експлуатації шредера",
    },
    [98427] = {
        ["Clearcutter Key"] = "Ключ для рубки",
    },
    [98430] = {
        ["Escort Perith Stormhoof out of Palemane Rock"] = "Супровід Періта Буреногого з Палевої Скелі",
    },
    [98435] = {
        ["Cleanse the Wildmane Well"] = "Очистіть криницю Дикої Гриви",
    },
    [98447] = {
        ["Raven Hill investigated"] = "Рейвен Гілл розслідував",
    },
    [98459] = {
        ["Tom's Gift"] = "Подарунок Тома",
        ["Tom's Gift (Provided)"] = "Подарунок Тома (видано)",
    },
    [98461] = {
        ["Hollee's Note"] = "Записка Холлі",
        ["Hollee's Note (Provided)"] = "Записка Холлі (видано)",
    },
    [98512] = {
        ["Al'Aketh Assassin"] = "Асасин Аль'Акет",
        ["Al'Aketh Assassin (Provided)"] = "Асасин Аль'Акет (видано)",
        ["Al'Aketh Assassin slain"] = "Асасин Аль'Акет: убито",
    },
    [98517] = {
        ["Torch of the Dormant Flame"] = "смолоскип дрімаючого полум'я",
    },
    [98545] = {
        ["Sealed Letter"] = "Запечатаний лист",
        ["Sealed Letter (Provided)"] = "Запечатаний лист (видано)",
    },
    [98574] = {
        ["Hallowed Memorandum"] = "Священний Меморандум",
        ["Hallowed Memorandum (Provided)"] = "Священний Меморандум (видано)",
        ["Hallowed Memorandum slain"] = "Священний Меморандум: убито",
    },
    [98575] = {
        ["Tainted Tablet"] = "Заплямовану таблетку",
        ["Tainted Tablet (Provided)"] = "Заплямовану таблетку (видано)",
    },
    [98576] = {
        ["Glyphic Parchment"] = "Гліфічний пергамент",
        ["Glyphic Parchment (Provided)"] = "Гліфічний пергамент (видано)",
    },
    [98581] = {
        ["Archaic Rune"] = "Архаїчна руна",
        ["Archaic Rune (Provided)"] = "Архаїчна руна (видано)",
        ["Archaic Rune slain"] = "Архаїчна руна: убито",
    },
    [98601] = {
        ["Consecrated Scroll"] = "Освячений сувій",
        ["Consecrated Scroll (Provided)"] = "Освячений сувій (видано)",
    },
    [99049] = {
        ["Banner Scrap"] = "Брухт банера",
        ["Broken Bone Trident"] = "Тризуб зламана кістка",
        ["Orcish Dagger"] = "Орчий кинджал",
    },
    [99050] = {
        ["Dewy Lasher Frond"] = "Росястий візерунок",
        ["Empty Vial"] = "порожній фіал",
        ["Refreshing Spring Water"] = "освіжаюча джерельна вода",
    },
    [99051] = {
        ["Naga Spinefin"] = "Нага Колючий плавник",
    },
    [99052] = {
        ["Aggor's Belt"] = "Пояс Аггора",
    },
    [99053] = {
        ["Escort Lynessa Duskblossom out of Ban'ethil"] = "Виведіть Лінессу Сутінкову квітку з Бан'етилу",
    },
    [99073] = {
        ["Lashwater Salve"] = "Бальзам для вій",
        ["Lashwater Salve (Provided)"] = "Бальзам для вій (видано)",
    },
    [99080] = {
        ["Galak Centaur slain"] = "кентавр племені Ґалак: убито",
        ["Galak Outrunner slain"] = "вістовий племені Ґалак: убито",
        ["Herak's Head"] = "Голова Герака",
    },
    [99081] = {
        ["Longwalker Malah's Report"] = "Звіт Лонгвокера Малаха",
    },
    [99101] = {
        ["Longwalker Malah's Report"] = "Звіт Лонгвокера Малаха",
        ["Longwalker Malah's Report (Provided)"] = "Звіт Лонгвокера Малаха (видано)",
    },
    [99108] = {
        ["Player Duels won or Novice Warriors defeated"] = "Виграні дуелі гравців або перемога над воїнами-новачками",
    },
    [99123] = {
        ["Escort Pal'juh out of Kolkar Crag."] = "Супроводьте Пал'джуха зі скелі Колкар.",
    },
    [99127] = {
        ["Half-Eaten Fish"] = "Напівз'їдена риба",
        ["Half-Eaten Fish (Provided)"] = "Напівз'їдена риба (видано)",
        ["Half-Eaten Fish slain"] = "Напівз'їдена риба: убито",
    },
    [99128] = {
        ["Murloc"] = "мурлок",
        ["Murloc Streamrunner"] = "мурлок-річковий бігун",
        ["Murloc Streamrunner slain"] = "мурлок-річковий бігун: убито",
        ["Murloc slain"] = "мурлок: убито",
    },
    [99130] = {
        ["Duskweed Petal"] = "Пелюстка сутінкової трави",
        ["Duskweed Petal (Provided)"] = "Пелюстка сутінкової трави (видано)",
        ["Duskweed Petal slain"] = "Пелюстка сутінкової трави: убито",
        ["Vial of Animal Blood"] = "Флакон з тваринною кров'ю",
        ["Vial of Animal Blood (Provided)"] = "Флакон з тваринною кров'ю (видано)",
        ["Vial of Animal Blood slain"] = "Флакон з тваринною кров'ю: убито",
    },
    [99134] = {
        ["Deathguard Abraham"] = "Страж Смерті Абрахам",
        ["Deathguard Billmuth"] = "Страж Смерті Біллмут",
        ["Deathguard Gavin"] = "Страж смерті Гевін",
        ["Deathguard Lawrence"] = "Страж Смерті Лоуренс",
        ["Deathguard Phillip"] = "Філіп, страж смерті",
        ["Deathguards motivated (5) Deathguard Linnea"] = "Мотивовані Вартові Смерті (5) Вартові Смерті Ліннея",
    },
    [99141] = {
        ["Dillinger's Report"] = "Звіт Діллінджера",
        ["Gordo's Report"] = "Звіт Гордо",
        ["Kristof's Report"] = "Звіт Крістофа",
    },
    [99142] = {
        ["Tomb Weed"] = "Гробничий бур'ян",
    },
    [99143] = {
        ["Shiny Junk"] = "Блискучий сміття",
        ["Shiny Junk (Provided)"] = "Блискучий сміття (видано)",
        ["Shiny Junk slain"] = "Блискучий сміття: убито",
    },
    [99144] = {
        ["Escort Bareth Dawnstone out of Crusader's Outpost"] = "Супроводьте Барета Донстоун з форпосту хрестоносців",
    },
    [99152] = {
        ["Faintly Glowing Bone"] = "Слабо світиться кістка",
    },
    [99153] = {
        ["Glowing Crystal Fragment"] = "Фрагмент сяючого кристала",
    },
    [99156] = {
        ["Riptear's Heart"] = "Серце Ріптіара",
    },
    [99158] = {
        ["Bring the crate of candles to Father Gavin."] = "Віднести ящик свічок отцю Ґевіну",
        ["Crate of Candles"] = "ящик свічок",
        ["Crate of Candles (Provided)"] = "ящик свічок (видано)",
    },
    [99159] = {
        ["Mostly Dry Firewood"] = "Переважно сухі дрова",
        ["Mostly Dry Firewood (Provided)"] = "Переважно сухі дрова (видано)",
        ["Mostly Dry Firewood slain"] = "Переважно сухі дрова: убито",
    },
    [99160] = {
        ["Minor Ice Elemental"] = "Незначний крижаний елементаль",
        ["Minor Ice Elemental (Provided)"] = "Незначний крижаний елементаль (видано)",
        ["Minor Ice Elemental slain"] = "Незначний крижаний елементаль: убито",
    },
    [99161] = {
        ["Avala's Core"] = "Ядро Авали",
        ["Avala's Core (Provided)"] = "Ядро Авали (видано)",
        ["Avala's Core slain"] = "Ядро Авали: убито",
    },
    [99162] = {
        ["Coalbeard's Rifle"] = "Гвинтівка Вугільної Бороди",
        ["Coalbeard's Rifle (Provided)"] = "Гвинтівка Вугільної Бороди (видано)",
        ["Coalbeard's Rifle slain"] = "Гвинтівка Вугільної Бороди: убито",
        ["Stoneanvil's Rifle"] = "Гвинтівка Кам'яної Ковадла",
        ["Stoneanvil's Rifle (Provided)"] = "Гвинтівка Кам'яної Ковадла (видано)",
        ["Stoneanvil's Rifle slain"] = "Гвинтівка Кам'яної Ковадла: убито",
        ["Sunhammer's Rifle"] = "Гвинтівка Сонячного Молота",
        ["Sunhammer's Rifle (Provided)"] = "Гвинтівка Сонячного Молота (видано)",
        ["Sunhammer's Rifle slain"] = "Гвинтівка Сонячного Молота: убито",
    },
    [99191] = {
        ["Wool Cloth"] = "вовняне полотно",
    },
    [99196] = {
        ["Wool Cloth"] = "вовняне полотно",
        ["Wool Cloth (Provided)"] = "вовняне полотно (видано)",
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
