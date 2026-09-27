local _, addonTable = ...

-- Context-dependent Blizzard surface output that is not an exact source-key
-- lookup. Surface adapters provide captures; this module owns localized text.
addonTable.forever_surface_ui = {
    settings = {
        base_tab = "Основні",
        selected = function (count) return "Вибрано: " .. count end,
    },
    skills = {
        talent_labels = {
            Primary = "Основна",
            Secondary = "Додаткова",
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
