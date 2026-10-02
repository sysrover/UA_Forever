local _, addonTable = ...

-- Player-visible wording used by tooltip adapters. Runtime code owns safe
-- reads, semantic slots and Blizzard lifecycle; this catalog owns Ukrainian
-- labels, grammar and dynamic formatters.
local tooltip = {
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
}

local item_stat_names = {
    Strength = "сили", Stamina = "витривалості",
    Agility = "спритності", Intellect = "інтелекту", Spirit = "духу",
    ["Spell Power"] = "сили заклинань",
}

local item_resistance_names = {
    Arcane = "таємної магії", Fire = "вогню", Frost = "криги",
    Nature = "природи", Shadow = "тіні", Holy = "світла",
}

-- Rendered SpellItemEnchantment names in 1.60.1.70124. The client can
-- emit these without an enchantment ID, including on inspected equipment.
-- Recognition is whole-name only; this is not a substring/glossary search.
local item_modification_names = {
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
}

local function modification_stat_name(stat)
    local name = item_stat_names[stat] or item_modification_stats[stat]
    if name then return name end
    local school = stat:match("^([A-Za-z]+) Resistance$")
    if school and item_resistance_names[school] then
        return "опору " .. item_resistance_names[school]
    end
    school = stat:match("^([A-Za-z]+) Spell Damage$")
    if school and item_resistance_names[school] then
        return "шкоди заклинань " .. item_resistance_names[school]
    end
end

local function translate_modification_part(source)
    local translated = item_modification_names[source]
    if translated then return translated end
    local name, sign, amount, percent = source:match(
        "^([A-Za-z '%-]+) ([%+%-])(%d+)(%%?)$")
    if not name then
        sign, amount, percent, name = source:match(
            "^([%+%-])(%d+)(%%?) ([A-Za-z '%-]+)$")
    end
    if name then
        translated = item_modification_names[name]
        if translated then
            return translated .. " " .. sign .. amount .. percent
        end
        translated = modification_stat_name(name)
        return translated and (sign .. amount .. percent .. " до " .. translated)
            or nil
    end
    local rank
    name, rank = source:match("^([A-Za-z '%-]+) (%d+)$")
    if not name then name, rank = source:match("^([A-Za-z '%-]+) ([IVX]+)$") end
    translated = name and item_modification_names[name]
    if translated then return translated .. " " .. rank end
    amount = source:match("^Scope %(%+(%d+) Damage%)$")
    if amount then return "Приціл (+" .. amount .. " до шкоди)" end
    amount = source:match("^Absorption %((%d+)%)$")
    if amount then return "Поглинання (" .. amount .. ")" end
    amount = source:match("^Poison %((%d+) Dmg%)$")
    if amount then return "Отрута (" .. amount .. " шкоди)" end
    amount = source:match("^Poison %(Instant (%d+)%)$")
    if amount then return "Отрута (миттєво " .. amount .. ")" end
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
    local enchanted = body:match("^Enchanted: (.+)$")
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
            and not body:find(" & ", 1, true) then return nil end
        -- Bounded, all-or-nothing compound bonuses. Never drop an unknown
        -- component, reinterpret client tokens or manufacture numeric values.
        local parts = body:gsub(" / ", " and "):gsub(" & ", " and ")
        local result = {}
        local start = 1
        while #result < 3 do
            local boundary = parts:find(" and ", start, true)
            local part = parts:sub(start, boundary and boundary - 1 or #parts)
            local value = translate_modification_part(part)
            if not value then return nil end
            result[#result + 1] = value
            if not boundary then
                translated = table.concat(result, " та ")
                break
            end
            start = boundary + 5
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

tooltip.item_line_patterns = {
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
    { "^(%d+) Slot Bag$", function (slots)
        return "Сумка на " .. slots .. " комірок"
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
            local name = item_stat_names[stat]
            return name and (sign .. amount .. " до " .. name) or nil
        end },
    { "^Equip: Increases damage and healing done by magical spells and effects by up to (%d+)%.$",
        function (amount)
            return "Екіпірування: збільшує шкоду та зцілення від магічних заклять і ефектів на "
                .. amount .. "."
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

function tooltip.translate_spell_reagents(source, translate_names)
    local body = source:match("^Reagents:(.+)$")
    if not body then return nil end
    return "Реагенти:" .. translate_names(body)
end

local function translate_plain_item_line(source)
    if type(source) ~= "string" or source == "" then return nil end
    local translated = tooltip.item_line_exact[source]
        or tooltip.comparison_item_labels[source]
    if translated then return translated end
    translated = tooltip.translate_item_modification(source)
    if translated then return translated end
    for _, rule in ipairs(tooltip.item_line_patterns) do
        local captures = { source:match(rule[1]) }
        if #captures > 0 then return rule[2](unpack(captures)) end
    end
    return nil
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
