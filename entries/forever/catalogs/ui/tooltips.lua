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
