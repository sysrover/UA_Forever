local _, addonTable = ...

-- Player-visible translations for Blizzard/system chat. The runtime adapter
-- owns event parsing and link-safe domain lookups; this catalog owns Ukrainian
-- wording, grammar and inflection.
local chat = {
    event_verbs = {
        CHAT_MSG_MONSTER_PARTY = "каже",
        CHAT_MSG_MONSTER_SAY = "каже",
        CHAT_MSG_MONSTER_WHISPER = "шепоче",
        CHAT_MSG_MONSTER_YELL = "вигукує",
        CHAT_MSG_RAID_BOSS_WHISPER = "шепоче",
    },
    observed_item_names = {
        ["Elfire's Shipment"] = "Вантаж Елфайр",
    },
    money_unit_forms = {
        Copper = { "мідна монета", "мідні монети", "мідних монет" },
        Silver = { "срібна монета", "срібні монети", "срібних монет" },
        Gold = { "золота монета", "золоті монети", "золотих монет" },
    },
    loot_choice = {
        Need = "Потреба",
        Greed = "Жадібність",
    },
    channel_names = {
        General = "Загальний",
        LocalDefense = "Місцева оборона",
        Trade = "Торгівля",
        ["Trade (Services)"] = "Торгівля (послуги)",
    },
    loot_quality = { Uncommon = "незвичайні" },
    loot_method = { ["Group Loot"] = "групова здобич" },
    exact = {
        ["You have been disconnected from Blizzard services."] =
            "Вас відключено від сервісів Blizzard.",
        ["You are no longer Away."] = "Ви повернулися.",
        ["You leave the group."] = "Ви полишаєте групу.",
        ["You feel rested."] = "Ви відпочиваєте.",
        ["You are no longer rested."] = "Ви більше не відпочиваєте.",
        ["You are now the group leader."] = "Тепер ви лідер групи.",
        ["Your group has been disbanded."] = "Вашу групу розформовано.",
        ["[You died.]"] = "[Ви загинули.]",
        ["Party converted to Raid"] = "Групу перетворено на рейд.",
    },
}

chat.format = {
    death_link = function (prefix, suffix)
        return prefix .. "[Ви загинули.]" .. suffix
    end,
    conduct_notice = function (link)
        return "Поводьтеся відповідально, захищайте свої особисті дані та повідомляйте про образливу поведінку. Докладніше — у Правилах поведінки в грі: "
            .. link .. "."
    end,
    loot_share = function (amount)
        return "Ваша частка здобичі: " .. amount .. "."
    end,
    loot_money = function (amount) return "Ваша здобич: " .. amount end,
    level_link = function (prefix, level, suffix)
        return "Вітаємо! Ви досягли " .. prefix .. "[" .. level
            .. "-го рівня]" .. suffix .. "!"
    end,
    level_color = function (prefix, level, suffix)
        return "Вітаємо! Ви досягли " .. prefix .. level .. "-го рівня!" .. suffix
    end,
    level_plain = function (level)
        return "Вітаємо! Ви досягли " .. level .. "-го рівня!"
    end,
    appearance = function (item)
        return item .. " додано до вашої колекції виглядів."
    end,
    gained = function (value) return "Отримано: " .. value end,
    currency = function (value) return "Ви отримуєте валюту: " .. value end,
    create_links = function (value) return "Ви створюєте: " .. value end,
    create_name = function (value) return "Ви створюєте " .. value .. "." end,
    learned_recipe = function (value)
        return "Ви навчилися створювати новий предмет: " .. value .. "."
    end,
    loot_link_prefix = function (prefix) return prefix .. "[Здобич]|h: " end,
    loot_plain_prefix = function () return "[Здобич]: " end,
    loot_player_choice = function (prefix, player, choice, item)
        return prefix .. player .. " обирає «" .. choice .. "» для " .. item
    end,
    loot_you_choice = function (prefix, choice, item)
        return prefix .. "Ви обираєте «" .. choice .. "» для " .. item
    end,
    loot_won = function (prefix, player, item)
        return prefix .. (player == "You" and "Ви" or player) .. " виграє " .. item
    end,
    loot_passed = function (prefix, player, item)
        return prefix .. player .. " відмовляється від " .. item
    end,
    loot_roll = function (prefix, choice, score, item, roller)
        return prefix .. "Кидок «" .. choice .. "» — " .. score
            .. " для " .. item .. ", " .. roller
    end,
    crafter_name = function (crafter, item)
        return crafter .. " створює " .. item .. "."
    end,
    crafter_links = function (crafter, items)
        return crafter .. " створює: " .. items .. "."
    end,
    receiver_loot = function (receiver, items)
        return receiver .. " отримує здобич: " .. items .. "."
    end,
    receive_loot = function (items) return "Здобуто: " .. items end,
    receive_item = function (items) return "Отримано предмет: " .. items end,
    duel_fled = function (player, opponent)
        return player .. " втікає з двобою проти " .. opponent .. "."
    end,
    quest_failed_inventory = function (quest)
        return "Провалено завдання «" .. quest .. "»: інвентар заповнений."
    end,
    group_suggested = function (group, inviter)
        return group .. " запропонували " .. inviter
            .. " запросити вас до своєї групи."
    end,
    guild_invite = function (inviter, guild)
        return inviter .. " запрошує вас приєднатися до гільдії " .. guild .. "."
    end,
    raid_joined = function (player) return player .. " приєднується до рейду." end,
    raid_left = function (player) return player .. " залишає рейд." end,
    npc_died = function (name) return name .. " помер." end,
    group_leader = function (name) return "Тепер лідер групи — " .. name .. "." end,
    party_joined = function (name) return name .. " приєднується до групи." end,
    party_left = function (name) return name .. " полишає групу." end,
    group_invite_link = function (link) return link .. " запрошує вас до групи." end,
    group_invite_name = function (name)
        return "[" .. name .. "] запрошує вас до групи."
    end,
    loot_threshold = function (quality) return "Поріг здобичі: " .. quality .. "." end,
    loot_method = function (method)
        return "Спосіб розподілу здобичі: " .. method .. "."
    end,
    quest_accepted = function (quest) return "Завдання прийнято: " .. quest end,
    quest_completed = function (quest) return "Завдання виконано: " .. quest .. "." end,
    received = function (value) return "Отримано " .. value .. "." end,
    discovered = function (zone) return "Відкрито нову територію: " .. zone end,
    kill_xp_group = function (name, xp, bonus)
        return name .. " гине. Ви отримуєте " .. xp
            .. " досвіду. (Бонус групи: +" .. bonus .. ")"
    end,
    kill_xp = function (name, xp)
        return name .. " гине. Ви отримуєте " .. xp .. " досвіду."
    end,
    discovery_xp = function (zone, xp)
        return "Відкрито нову територію: " .. zone
            .. ". Досвіду отримано: " .. xp .. "."
    end,
    experience_gained = function (xp) return "Досвіду отримано: " .. xp .. "." end,
    experience_group = function (xp, bonus)
        return "Ви отримуєте " .. xp .. " досвіду. (Бонус групи: +"
            .. bonus .. ")"
    end,
    experience = function (xp) return "Ви отримуєте " .. xp .. " досвіду." end,
    reputation_increased = function (name, amount)
        return "Репутацію фракції «" .. name .. "» підвищено на " .. amount .. "."
    end,
    reputation_decreased = function (name, amount)
        return "Репутацію фракції «" .. name .. "» знижено на " .. amount .. "."
    end,
    learned_ability = function (spell)
        return "Ви вивчили нову здібність: " .. spell .. "."
    end,
    skill_increased = function (name, rank)
        return "Ваше вміння «" .. name .. "» зросло до " .. rank .. "."
    end,
    skill_gained = function (name) return "Ви здобули вміння «" .. name .. "»." end,
    channel = function (number, channel, zone)
        return number .. channel .. " - " .. zone
    end,
}

addonTable.forever_chat_system = chat
