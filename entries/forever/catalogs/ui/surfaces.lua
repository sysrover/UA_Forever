local _, addonTable = ...

-- Context-dependent Blizzard surface output that is not an exact source-key
-- lookup. Surface adapters provide captures; this module owns localized text.
addonTable.forever_surface_ui = {
    character = {
        level = function (level, color, description)
            return "Рівень " .. level .. ": " .. color .. description .. "|r"
        end,
    },
    settings = {
        base_tab = "Основні",
        selected = function (count) return "Вибрано: " .. count end,
    },
    skills = {
        pet_actions = {
            ["Attack"] = "Атака",
            ["Stay"] = "Залишатися",
            ["Move To"] = "Перейти до",
            ["Follow"] = "Слідувати",
            ["Passive"] = "Пасивна",
            ["Defensive"] = "Оборонний",
            ["Aggressive"] = "Агресивний",
            ["Assist"] = "Допомога",
            ["Pet Command"] = "Команди для домашніх тварин",
            ["Pet Stance"] = "Ставлення до домашніх тварин",
            ["Orders your pet to attack your current target."] =
                "Наказує вашому вихованцеві атакувати вашу поточну ціль.",
            ["Orders your pet to follow you."] =
                "Наказує вашому улюбленцю йти за вами.",
            ["Orders your pet to move to a target location."] =
                "Наказує вашому улюбленцю переміститися до вказаного місця.",
            ["Orders your pet to stay at its current location."] =
                "Наказує вашому улюбленцю залишатися на місці.",
            ["Your pet will assist you."] =
                "Ваш улюбленець допомагатиме вам у бою.",
            ["Your pet will attack any nearby enemies."] =
                "Ваш улюбленець атакуватиме всіх ворогів поблизу.",
            ["Your pet will only attack enemies that attack you or your pet."] =
                "Ваш улюбленець атакуватиме лише ворогів, які нападуть на вас або на нього.",
            ["Your pet won't attack until ordered to do so."] =
                "Ваш улюбленець не атакуватиме без наказу.",
        },
        armor_category_types = {
            Cloth = "Тканинні", Leather = "Шкіряні",
            Mail = "Кольчужні", Plate = "Латні",
        },
        armor_category_slots = {
            Armor = "обладунки", Belts = "пояси", Boots = "чоботи",
            Bracers = "наручі", Chestguards = "нагрудники",
            Cloaks = "плащі", Gauntlets = "рукавиці",
            Gloves = "рукавички", Helms = "шоломи",
            Helmets = "шоломи", Legguards = "поножі",
            Pants = "штани", Robes = "мантії",
            Shoulders = "наплічники", Vests = "жилети",
        },
        enchant_category = function (target)
            return "Чари: " .. target
        end,
        crafted_recipe = function (name)
            return "Створює «" .. name .. "»."
        end,
        requirement_names = {
            Forge = "кузня",
        },
        required_prefix = "Потрібно:",
        requirements = function (value) return "Потрібно: " .. value end,
        trainer_requirements = function (source, translate_name)
            local body = source:match("^Requires: (.+)$")
            if not body then return nil end
            local parts = {}
            for part in body:gmatch("[^,]+") do
                part = part:match("^%s*(.-)%s*$")
                local color, inner, reset = part:match(
                    "^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
                local value = inner or part
                if value:match("^Level ") then
                    value = value:gsub("^Level ", "Рівень ")
                else
                    local name, rank = value:match("^(.-) %(Rank (%d+)%)$")
                    if name then
                        value = translate_name(name) .. " (Ранг " .. rank .. ")"
                    else
                        local suffix
                        name, suffix = value:match("^(.-)( %(%d+%))$")
                        if not name then
                            name, suffix = value:match(
                                "^(.-)( %(|c%x%x%x%x%x%x%x%x%d+|r%))$")
                        end
                        value = translate_name(name or value) .. (suffix or "")
                    end
                end
                parts[#parts + 1] = (color or "") .. value .. (reset or "")
            end
            return "Потрібно: " .. table.concat(parts, ", ")
        end,
    },
    menus = {
        quit_countdown = function (count)
            return "До виходу залишилося " .. count .. " с"
        end,
        resurrection = function (name, seconds, sickness)
            local result = name .. " хоче воскресити вас"
            if seconds then
                result = result .. " і зможе це зробити через " .. seconds .. " с"
            end
            if sickness then
                result = result
                    .. ". Після воскресіння ви матимете слабкість воскресіння"
            end
            return result .. "."
        end,
    },
    quest = {
        ABANDON_QUEST_CONFIRM = "Відмовитися від завдання «%s»?",
        ABANDON_QUEST_CONFIRM_WITH_ITEMS =
            "Відмовитися від завдання «%s», знищивши %s?",
        ready_for_turn_in = "Можна здати",
        complete_suffix = " (виконано)",
        objective_complete = "Завдання виконано.",
        slain = "%s: убито",
        player_kills = "Вбиті гравці",
        player_kills_named = "%s: вбиті гравці",
        pet_battle_victories = "Гравці, яких було переможено в битві вихованців",
        timer_units = {
            { source = "Day", translated = "дн" },
            { source = "Hr", translated = "год" },
            { source = "Min", translated = "хв" },
            { source = "Sec", translated = "с" },
        },
    },
    items = {
        merchant_page = function (current, total)
            return "Сторінка " .. current .. " з " .. total
        end,
    },
    map_labels = {
        discovered = function (zone)
            return "Відкрито нову територію: " .. zone
        end,
        faction_territory = function (faction)
            local territories = {
                ["Альянс"] = "Територія Альянсу",
                ["Орда"] = "Територія Орди",
            }
            return territories[faction]
        end,
    },
}
