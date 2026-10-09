-- Canonical translations, consolidated with the existing winning values.
local _, addonTable = ...

-- Context-dependent Blizzard surface output that is not an exact source-key
-- lookup. Surface adapters provide captures; this module owns localized text.
local function channel_name(name)
    local aliases = { Services = "Послуги", TradeLocal = "Місцева торгівля" }
    return addonTable.forever_chat_system.channel_names[name] or aliases[name]
end

addonTable.forever_surface_ui = {
    channel_panel = {
        name = function (source)
            local color, plain, reset = source:match("^(|[cC]%x%x%x%x%x%x%x%x)(.-)(|[rR])$")
            plain = plain or source
            local prefix, name, trailing = plain:match("^(%d+%.%s*)(.-)(%s*)$")
            if not name then prefix, name, trailing = "", plain, "" end
            local translated = channel_name(name)
            return translated and ((color or "") .. prefix .. translated
                .. trailing .. (reset or "")) or nil
        end,
    },
    inspect = {
        detail = function (source, lookup)
            local count = source:match("^Lifetime: (.+)$")
            if count then return "За весь час: " .. count end
            count = source:match("^Today: (.+)$")
            if count then return "Сьогодні: " .. count end
            count = source:match("^(%d+) Guild Members$")
            if count then return "Учасників гільдії: " .. count end
            local faction = source:match("^(Alliance) Guild$")
                or source:match("^(Horde) Guild$")
            if faction then return "Гільдія: " .. (lookup(faction) or faction) end
        end,
    },
    mail = {
        -- Observed delivery headers; reuse the approved item-name catalog.
        item_deliveries = {
            ["Datto Glowspindle"] = { ["Expert Cookbook"] = 16072 },
        },
    },
    forever_vo = {
        queue_label = function (title, name, color)
            title = title or ""
            if not name then return title end
            return title ~= "" and (title .. "  " .. color .. name .. "|r") or name
        end,
        value = function (source)
            local queued = source:match("^(%d+) more queued$")
            if queued then return "Ще в черзі: " .. queued end
            local more = source:match("^and (%d+) more$")
            if more then return "і ще " .. more end
            local channels = { Master = "Загальна гучність", Dialog = "Діалоги",
                SFX = "Звукові ефекти", Music = "Музика", Ambience = "Звуки оточення" }
            if channels[source] then return channels[source] end
            local count = source:match("^Send (%d+) Quests? to Project$")
            if count then return "Надіслати квести до проєкту: " .. count end
            local race, gender = source:match("^(.+) (male)$")
            if not race then race, gender = source:match("^(.+) (female)$") end
            local races = { Human = "Людина", Dwarf = "Дворф", ["Night elf"] = "Нічний ельф",
                Orc = "Орк", Troll = "Троль", Tauren = "Таурен", Gnome = "Гном",
                Goblin = "Гоблін", ["Blood elf"] = "Кривавий ельф", Undead = "Невмерлий",
                Skyborne = "Небонароджений", Draenei = "Дреней" }
            if races[race] then
                return races[race] .. (gender == "female" and " — жіночий голос" or " — чоловічий голос")
            end
        end,
    },
    social_toast = {
        online = "тепер |cff00ff00у мережі|r.",
        offline = "тепер |cffff0000поза мережею|r.",
    },
    stack_split = {
        count = function (source)
            local stacks = source:match("^(%d+) |4Stack:Stacks;$")
                or source:match("^(%d+) Stacks?$")
            if stacks then return "Стоси: " .. stacks end
            local total = source:match("^(%d+) Total$")
            return total and ("Усього: " .. total) or nil
        end,
    },
    chat_config = {
        channel = function (source)
            local prefix, name = source:match("^(%d+%.%s*)(.+)$")
            if not name then return nil end
            local translated = channel_name(name)
            return translated and (prefix .. translated) or nil
        end,
        header = function (name)
            local defaults = { ["General"] = "Загальний", ["Combat Log"] = "Журнал бою" }
            return "Налаштування чату «" .. (defaults[name] or name) .. "»"
        end,
    },
    character = {
        pet_level = function (source, lookup)
            local level, description = source:match("^Level (%d+) (.+)$")
            if not level then return nil end
            local family, color, loyalty = description:match(
                "^(.-)%s+(|c%x%x%x%x%x%x%x%x)%((.-)%)|r$")
            family = family or description
            local suffix = ""
            if loyalty then
                local translated_loyalty = lookup(loyalty)
                    or loyalty:gsub("Loyalty: (%d+)", "Лояльність: %1")
                suffix = " " .. color .. "(" .. translated_loyalty .. ")|r"
            end
            return "Рівень " .. level .. ": " .. (lookup(family) or family) .. suffix
        end,
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
        lfg_text = function (source, translate_name)
            local voice_mode = source:match("^Voice Chat: |cnHIGHLIGHT_FONT_COLOR:(.-)|r$")
            if voice_mode then
                return "Голосовий чат: |cnHIGHLIGHT_FONT_COLOR:"
                    .. translate_name(voice_mode) .. "|r"
            end
            local applicants = source:match("^(%d+) Pending Applicant[s]?$")
                or source:match("^(%d+) |4Pending Applicant:Pending Applicants;$")
            if applicants then return "Заявок на розгляді: " .. applicants end
            local count = source:match("^(%d+) activit[yi]e?s? selected$")
                or source:match("^(%d+) |4activity:activities; selected$")
            if count then return "Вибрано активностей: " .. count end
            count = source:match("^(%d+) matching activit[yi]e?s?$")
                or source:match("^(%d+) matching |4activity:activities;$")
            if count then return "Відповідних активностей: " .. count end
            count = source:match("^(%d+) activit[yi]e?s?$")
                or source:match("^(%d+) |4activity:activities;$")
            if count then return "Активностей: " .. count end
            local shown
            count, shown = source:match("^(%d+) %a+ Found%s*%((%d+) displayed%)$")
            if not count then
                count, shown = source:match(
                    "^(%d+) |4Person:People; Found%s*%((%d+) displayed%)$")
            end
            if count then
                return "Знайдено гравців: " .. count .. " (показано: " .. shown .. ")"
            end
            count = source:match("^(%d+) %a+ Found%s*$")
                or source:match("^(%d+) |4Person:People; Found%s*$")
            if count then return "Знайдено гравців: " .. count end
            local members, tank, healer, damage = source:match(
                "^Members: |cffffffff(%d+) %((%d+)/(%d+)/(%d+)%)|r$")
            if members then
                return "Учасники: |cffffffff" .. members .. " (" .. tank
                    .. "/" .. healer .. "/" .. damage .. ")|r"
            end
            members = source:match("^Members: |cffffffff(%d+)|r$")
            if members then return "Учасники: |cffffffff" .. members .. "|r" end
            count = source:match("^Lvl (%d+)$")
            if count then return "Рів. " .. count end
            -- Native activity groups append a colored activity counter.
            local name, color, amount = source:match(
                "^(.-) (|c%x%x%x%x%x%x%x%x)%((%d+) activit[yi]e?s?%)|r$")
            if not name then
                name, color, amount = source:match(
                    "^(.-) (|c%x%x%x%x%x%x%x%x)%((%d+) |4activity:activities;%)|r$")
            end
            if name then
                return translate_name(name) .. " " .. color
                    .. "(активностей: " .. amount .. ")|r"
            end
            local indent, body = source:match("^(%s+)(%S.-)$")
            if indent then
                local translated = translate_name(body)
                if translated ~= body then return indent .. translated end
            end
        end,
        quit_countdown = function (count)
            return "До виходу залишилося " .. count .. " с"
        end,
        death_release_countdown = function (count, unit)
            local forms
            if unit == "Minute" or unit == "Minutes" then
                forms = { "хвилина", "хвилини", "хвилин" }
            elseif unit == "Second" or unit == "Seconds" then
                forms = { "секунда", "секунди", "секунд" }
            else
                return nil
            end
            local amount = tonumber(count)
            if not amount then return nil end
            local last, last_two = amount % 10, amount % 100
            local form = last_two >= 11 and last_two <= 14 and 3
                or last == 1 and 1 or last >= 2 and last <= 4 and 2 or 3
            return count .. " " .. forms[form] .. " до звільнення духу"
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

