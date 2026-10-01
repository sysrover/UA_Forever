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

function tooltip.translate_item_modification(source)
    if type(source) ~= "string" or source == "" then return nil end
    local color, body = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)|r$")
    body = body or source
    local enchanted = body:match("^Enchanted: (.+)$")
    body = enchanted or body
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
    { "^%+(%d+) ([A-Za-z]+) Resistance$",
        function (amount, school)
            local name = item_resistance_names[school]
            return name and ("+" .. amount .. " до опору " .. name) or nil
        end },
}

function tooltip.translate_item_line(source)
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
