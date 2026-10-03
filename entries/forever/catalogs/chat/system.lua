local _, addonTable = ...

-- Player-visible translations for Blizzard/system chat. The runtime adapter
-- owns event parsing and link-safe domain lookups; this catalog owns Ukrainian
-- wording, grammar and inflection.
local chat = {
    -- Presence notices can include a Battle.net icon, account link and a
    -- character link. Preserve that entire identity prefix verbatim.
    presence_patterns = {
        { pattern = "^(.+) has come online%.(.*)$", replace = function (identity, suffix)
            if suffix:gsub("|r", "") ~= "" then return nil end
            return identity .. " з'явився в мережі." .. suffix
        end },
        { pattern = "^(.+) has gone offline%.(.*)$", replace = function (identity, suffix)
            if suffix:gsub("|r", "") ~= "" then return nil end
            return identity .. " вийшов з мережі." .. suffix
        end },
    },
    -- Display-only combat-log vocabulary for Forever 1.60.1.70170. The
    -- processor's printf arguments and hyperlinks retain their identities.
    combat_log = {
        actor_separator = ": ",
        full_text_literals = {
            [" $extraSpell to "] = " $extraSpell — ціль: ",
            [" $extraSpell."] = " $extraSpell.",
            [" Health from "] = " здоров'я завдяки ",
            [" at "] = " — ціль: ",
            [" at empower level "] = " на рівні посилення ",
            [" attack failed. "] = ": атака не вдалася. ",
            [" attack misfired on "] = ": атака дала збій — ціль: ",
            [" attack misses "] = ": атака не влучає — ціль: ",
            [" attack was absorbed by "] = ": атаку поглинуто — ціль: ",
            [" attack was blocked by "] = ": атаку заблоковано — ціль: ",
            [" attack was deflected by "] = ": атаку відбито — ціль: ",
            [" attack was dodged by "] = ": ціль ухилилася від атаки: ",
            [" attack was evaded by "] = ": ціль уникнула атаки: ",
            [" attack was fully resisted by "] = ": повний опір атаці — ціль: ",
            [" attack was parried by "] = ": атаку парировано — ціль: ",
            [" began empowering "] = " починає посилювати ",
            [" begins casting "] = " починає застосовувати ",
            [" broke "] = " перериває ефект ",
            [" cast "] = " застосовує ",
            [" casts "] = " застосовує ",
            [" causes "] = " завдає ",
            [" cleansed by "] = " — очищено за допомогою ",
            [" collapses."] = ": непритомність.",
            [" creates a "] = " створює ",
            [" damage from "] = " шкоди від ",
            [" damage to "] = " шкоди — ціль: ",
            [" damage was absorbed by "] = ": шкоду поглинуто — ціль: ",
            [" damages "] = " пошкоджує ",
            [" died."] = ": смерть.",
            [" dissipates from "] = " розсіюється — ціль: ",
            [" dissipates."] = ": розсіювання.",
            [" does not affect "] = " не діє — ціль: ",
            [" drains "] = " висмоктує ",
            [" extra attacks granted by "] = " додаткових атак завдяки ",
            [" extra attacks through "] = " додаткових атак завдяки ",
            [" fades from "] = " згасає — ціль: ",
            [" failed."] = ": невдача.",
            [" failed. "] = ": невдача. ",
            [" fails to dispel "] = " не вдається розвіяти ",
            [" falls and loses "] = ": падіння, втрачено ",
            [" fire damage."] = " шкоди від вогню.",
            [" for "] = " на ",
            [" for a moment."] = " під час цього спрацювання.",
            [" from "] = " від ",
            [" gains "] = " отримує ",
            [" has knocked out "] = " позбавляє свідомості — ціль: ",
            [" has slain "] = " вбиває — ціль: ",
            [" heals "] = " зцілює ",
            [" health for swimming in slime. "] = " здоров'я через плавання у слизу. ",
            [" health from "] = " здоров'я завдяки ",
            [" health from environmental damage."] = " здоров'я через шкоду від довкілля.",
            [" health from swimming in lava. "] = " здоров'я через плавання в лаві. ",
            [" health."] = " здоров'я.",
            [" hits "] = " влучає — ціль: ",
            [" instantly kills "] = " миттєво вбиває — ціль: ",
            [" interrupts "] = " перериває ",
            [" is afflicted by "] = " зазнає дії ",
            [" is cleansed by "] = " — очищено за допомогою ",
            [" is dispelled by "] = " — розвіяно за допомогою ",
            [" is drowning and loses "] = ": утоплення, втрачено ",
            [" is exhausted and loses "] = ": виснаження, втрачено ",
            [" is refreshed on "] = " поновлюється — ціль: ",
            [" knocks out "] = " позбавляє свідомості — ціль: ",
            [" loses "] = " втрачає ",
            [" melee swing hits "] = ": удар у ближньому бою — ціль: ",
            [" misfired on "] = " дає збій — ціль: ",
            [" missed "] = " не влучає — ціль: ",
            [" misses "] = " не влучає — ціль: ",
            [" on "] = " — ціль: ",
            [" ranged shot hit "] = ": постріл — ціль: ",
            [" reflects "] = " відбиває ",
            [" released "] = " вивільняє ",
            [" repairs "] = " ремонтує ",
            [" resisted."] = ": опір.",
            [" resurrects "] = " воскрешає — ціль: ",
            [" shot failed. "] = ": постріл не вдався. ",
            [" shot misfired on "] = ": постріл дав збій — ціль: ",
            [" shot misses "] = ": постріл не влучає — ціль: ",
            [" shot was absorbed by "] = ": постріл поглинуто — ціль: ",
            [" shot was blocked by "] = ": постріл заблоковано — ціль: ",
            [" shot was deflected by "] = ": постріл відбито — ціль: ",
            [" shot was dodged by "] = ": ціль ухилилася від пострілу: ",
            [" shot was evaded by "] = ": ціль уникнула пострілу: ",
            [" shot was fully resisted by "] = ": повний опір пострілу — ціль: ",
            [" shot was parried by "] = ": постріл парировано — ціль: ",
            [" steals "] = " викрадає ",
            [" strike "] = " вражає — ціль: ",
            [" strikes "] = " вражає — ціль: ",
            [" suffers "] = " зазнає ",
            [" summons "] = " прикликає ",
            [" transfers "] = " переносить ",
            [" was absorbed by "] = " поглинуто — ціль: ",
            [" was blocked by "] = " заблоковано — ціль: ",
            [" was broken by someone."] = ": ефект перервано.",
            [" was deflected by "] = " відбито — ціль: ",
            [" was destroyed."] = ": знищення.",
            [" was dodged by "] = ": ціль ухилилася: ",
            [" was evaded by "] = ": ціль уникнула: ",
            [" was fully resisted by "] = ": повний опір — ціль: ",
            [" was immune to "] = ": несприйнятливість до ",
            [" was immune."] = ": несприйнятливість.",
            [" was interrupted at empower level "] = " перервано на рівні посилення ",
            [" was parried by "] = " парировано — ціль: ",
            [" was reflected by "] = " віддзеркалено — ціль: ",
            [" was removed from "] = " знято — ціль: ",
            ["'s "] = ": ",
            [") diminishes."] = "): кількість зарядів зменшується.",
            [") subsides."] = "): кількість зарядів зменшується.",
            [": $item damaged."] = ": предмет $item пошкоджено.",
            [": all items damaged."] = ": усі предмети пошкоджено.",
            ["A melee swing hit "] = "Удар у ближньому бою — ціль: ",
            ["A ranged shot hit "] = "Постріл — ціль: ",
            ["Something begins casting "] = "Невідоме джерело починає застосовувати ",
            ["Something cast "] = "Невідоме джерело застосовує ",
        },
        terms = {
            ["Melee"] = "Ближній бій", ["Shot"] = "Постріл",
            ["hit"] = "влучання", ["damages"] = "шкода", ["damaged"] = "шкода",
            ["drained"] = "висмоктування", ["energized"] = "відновлення ресурсу",
            ["healed"] = "зцілення", ["applied"] = "накладення",
            ["afflicted"] = "шкідливий ефект", ["stacked"] = "додано заряд",
            ["removed"] = "зняття", ["faded"] = "згасання", ["dissipated"] = "розсіювання",
            ["reduced"] = "зменшення", ["diminished"] = "зменшення",
            ["dispelled"] = "розвіювання", ["cleansed"] = "очищення", ["stole"] = "викрадення",
            ["missed"] = "промах", ["resisted"] = "опір", ["reflected"] = "віддзеркалення",
            ["began to cast"] = "початок застосування", ["cast"] = "застосування",
            ["failed"] = "невдача", ["granted extra attacks"] = "додаткові атаки",
            ["interrupted"] = "переривання", ["killed"] = "вбивство", ["died"] = "смерть",
            ["destroyed"] = "знищення", ["shared damage"] = "розподілена шкода",
            ["durability loss"] = "втрата міцності", ["full durability loss"] = "втрата міцності всіх предметів",
            ["dispel failed"] = "невдале розвіювання", ["enchanted"] = "накладення чарів",
            ["enchant faded"] = "згасання чарів", ["summoned"] = "прикликання",
            ["created"] = "створення", ["broke"] = "переривання ефекту",
            ["refreshed"] = "поновлення", ["resurrected"] = "воскресіння",
            ["strikes"] = "удар", ["repaired"] = "ремонт", ["dissipates"] = "розсіювання",
            ["knocked out"] = "непритомність", ["collapses"] = "непритомність",
            ["began empowering"] = "початок посилення", ["released"] = "вивільнення",
            ["Missed"] = "Промах", ["Absorbed"] = "Поглинуто", ["Blocked"] = "Заблоковано",
            ["Deflected"] = "Відбито", ["Dodged"] = "Ухилення", ["Evaded"] = "Уникнення",
            ["Immune"] = "Несприйнятливість", ["Parried"] = "Парировано",
            ["Reflected"] = "Віддзеркалено", ["Resisted"] = "Опір", ["Misfired"] = "Збій",
            ["Critical"] = "Критичний удар", ["Glancing"] = "Ковзний удар",
            ["Crushing"] = "Нищівний удар", ["Multistrike"] = "Багаторазовий удар",
            ["Tick Resisted"] = "Опір спрацюванню", ["Tick Missed"] = "Промах спрацювання",
            ["Tick Blocked"] = "Спрацювання заблоковано", ["Tick Deflected"] = "Спрацювання відбито",
            ["Tick Dodged"] = "Ухилення від спрацювання", ["Tick Evaded"] = "Спрацювання уникнуто",
            ["Tick Parried"] = "Спрацювання парировано",
            ["Overhealed"] = "Надлишкове зцілення", ["Overkill"] = "Надлишкова шкода",
            ["Overenergized"] = "Надлишкове відновлення", ["Remaining"] = "Залишок",
            ["Vulnerability Damage"] = "Шкода від вразливості", ["Gained"] = "Отримано",
            ["Physical"] = "Фізична", ["Holy"] = "Світло", ["Fire"] = "Вогонь",
            ["Nature"] = "Природа", ["Frost"] = "Крига", ["Shadow"] = "Тінь", ["Arcane"] = "Аркана",
            ["Holystrike"] = "Світло й фізична", ["Flamestrike"] = "Вогонь і фізична",
            ["Holyfire"] = "Світло й вогонь", ["Stormstrike"] = "Природа й фізична",
            ["Holystorm"] = "Світло й природа", ["Firestorm"] = "Вогонь і природа",
            ["Froststrike"] = "Крига й фізична", ["Holyfrost"] = "Світло й крига",
            ["Frostfire"] = "Крига й вогонь", ["Froststorm"] = "Крига й природа",
            ["Shadowstrike"] = "Тінь і фізична", ["Twilight"] = "Тінь і світло",
            ["Shadowflame"] = "Тінь і вогонь", ["Plague"] = "Тінь і природа",
            ["Shadowfrost"] = "Тінь і крига", ["Spellstrike"] = "Аркана й фізична",
            ["Divine"] = "Аркана й світло", ["Spellfire"] = "Аркана й вогонь",
            ["Astral"] = "Аркана й природа", ["Spellfrost"] = "Аркана й крига",
            ["Spellshadow"] = "Аркана й тінь", ["Elemental"] = "Стихійна",
            ["Chromatic"] = "Хроматична", ["Magic"] = "Магічна", ["Magical"] = "Магічна",
            ["Chaos"] = "Хаос", ["Cosmic"] = "Космічна", ["Radiant"] = "Сяйво", ["Volcanic"] = "Вулканічна",
            ["Drowning"] = "Утоплення", ["Fatigue"] = "Виснаження", ["Falling"] = "Падіння",
            ["Lava"] = "Лава", ["Slime"] = "Слиз",
            ["You"] = "Ви", ["Your"] = "Ви", ["Unknown"] = "Невідомо", ["Something"] = "Невідоме джерело",
        },
    },
    event_verbs = {
        CHAT_MSG_MONSTER_PARTY = "каже",
        CHAT_MSG_MONSTER_SAY = "каже",
        CHAT_MSG_MONSTER_WHISPER = "шепоче",
        CHAT_MSG_MONSTER_YELL = "вигукує",
        CHAT_MSG_RAID_BOSS_WHISPER = "шепоче",
    },
    -- Social/system GlobalStrings present in Forever 1.60.1.70170.
    -- Wording comes from the existing UI catalog; these tags select chat templates.
    template_tags = {
        "BN_INLINE_TOAST_ALERT",
        "BN_INLINE_TOAST_BATTLETAG_FRIEND_ADDED",
        "BN_INLINE_TOAST_BATTLETAG_FRIEND_REMOVED",
        "BN_INLINE_TOAST_BROADCAST",
        "BN_INLINE_TOAST_BROADCAST_INFORM",
        "BN_INLINE_TOAST_CONVERSATION",
        "BN_INLINE_TOAST_FRIEND_ADDED",
        "BN_INLINE_TOAST_FRIEND_OFFLINE",
        "BN_INLINE_TOAST_FRIEND_ONLINE",
        "BN_INLINE_TOAST_FRIEND_PENDING",
        "BN_INLINE_TOAST_FRIEND_REMOVED",
        "BN_INLINE_TOAST_FRIEND_REQUEST",
        "BN_INLINE_TOAST_TITLE_FRIEND_ADDED",
        "CHAT_ANNOUNCEMENTS_OFF_NOTICE",
        "CHAT_ANNOUNCEMENTS_OFF_NOTICE_BN",
        "CHAT_ANNOUNCEMENTS_ON_NOTICE",
        "CHAT_ANNOUNCEMENTS_ON_NOTICE_BN",
        "CHAT_BANNED_NOTICE",
        "CHAT_CHANNEL_OWNER_NOTICE",
        "CHAT_CHANNEL_OWNER_NOTICE_BN",
        "CHAT_CONVERSATION_CONVERSATION_CONVERTED_TO_WHISPER_NOTICE",
        "CHAT_CONVERSATION_MEMBER_JOINED_NOTICE",
        "CHAT_CONVERSATION_MEMBER_LEFT_NOTICE",
        "CHAT_CONVERSATION_YOU_JOINED_CONVERSATION_NOTICE",
        "CHAT_CONVERSATION_YOU_LEFT_CONVERSATION_NOTICE",
        "CHAT_INVALID_NAME_NOTICE",
        "CHAT_INVITE_NOTICE",
        "CHAT_INVITE_NOTICE_POPUP",
        "CHAT_INVITE_WRONG_FACTION_NOTICE",
        "CHAT_LEAVE_CHANNEL_PREVENTED",
        "CHAT_MODERATION_OFF_NOTICE",
        "CHAT_MODERATION_OFF_NOTICE_BN",
        "CHAT_MODERATION_ON_NOTICE",
        "CHAT_MODERATION_ON_NOTICE_BN",
        "CHAT_MUTED_NOTICE",
        "CHAT_MUTED_NOTICE_BN",
        "CHAT_NOT_ALLOWED_IN_CHANNEL_NOTICE",
        "CHAT_NOT_IN_AREA_NOTICE",
        "CHAT_NOT_MEMBER_NOTICE",
        "CHAT_NOT_MODERATED_NOTICE",
        "CHAT_NOT_MODERATOR_NOTICE",
        "CHAT_NOT_MODERATOR_NOTICE_BN",
        "CHAT_NOT_OWNER_NOTICE",
        "CHAT_NOT_OWNER_NOTICE_BN",
        "CHAT_OWNER_CHANGED_NOTICE",
        "CHAT_OWNER_CHANGED_NOTICE_BN",
        "CHAT_PASSWORD_CHANGED_NOTICE",
        "CHAT_PASSWORD_CHANGED_NOTICE_BN",
        "CHAT_PASSWORD_NOTICE_POPUP",
        "CHAT_PLAYER_ALREADY_MEMBER_NOTICE",
        "CHAT_PLAYER_ALREADY_MEMBER_NOTICE_BN",
        "CHAT_PLAYER_BANNED_NOTICE",
        "CHAT_PLAYER_BANNED_NOTICE_BN",
        "CHAT_PLAYER_INVITED_NOTICE",
        "CHAT_PLAYER_INVITED_NOTICE_BN",
        "CHAT_PLAYER_INVITE_BANNED_NOTICE",
        "CHAT_PLAYER_INVITE_BANNED_NOTICE_BN",
        "CHAT_PLAYER_KICKED_NOTICE",
        "CHAT_PLAYER_KICKED_NOTICE_BN",
        "CHAT_PLAYER_NOT_BANNED_NOTICE",
        "CHAT_PLAYER_NOT_BANNED_NOTICE_BN",
        "CHAT_PLAYER_NOT_FOUND_NOTICE",
        "CHAT_PLAYER_NOT_FOUND_NOTICE_BN",
        "CHAT_PLAYER_UNBANNED_NOTICE",
        "CHAT_PLAYER_UNBANNED_NOTICE_BN",
        "CHAT_SET_MODERATOR_NOTICE",
        "CHAT_SET_MODERATOR_NOTICE_BN",
        "CHAT_SET_SPEAK_NOTICE",
        "CHAT_SET_SPEAK_NOTICE_BN",
        "CHAT_SET_VOICE_NOTICE",
        "CHAT_SET_VOICE_NOTICE_BN",
        "CHAT_SUSPENDED_NOTICE",
        "CHAT_SUSPENDED_NOTICE_BN",
        "CHAT_THROTTLED_NOTICE",
        "CHAT_THROTTLED_NOTICE_BN",
        "CHAT_TRIAL_RESTRICTED_NOTICE",
        "CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL",
        "CHAT_UNSET_MODERATOR_NOTICE",
        "CHAT_UNSET_MODERATOR_NOTICE_BN",
        "CHAT_UNSET_SPEAK_NOTICE",
        "CHAT_UNSET_SPEAK_NOTICE_BN",
        "CHAT_UNSET_VOICE_NOTICE",
        "CHAT_UNSET_VOICE_NOTICE_BN",
        "CHAT_VOICE_OFF_NOTICE",
        "CHAT_VOICE_OFF_NOTICE_BN",
        "CHAT_VOICE_ON_NOTICE",
        "CHAT_VOICE_ON_NOTICE_BN",
        "CHAT_WRONG_FACTION_NOTICE",
        "CHAT_WRONG_PASSWORD_NOTICE",
        "CHAT_YOU_CHANGED_NOTICE",
        "CHAT_YOU_CHANGED_NOTICE_BN",
        "CHAT_YOU_JOINED_NOTICE",
        "CHAT_YOU_JOINED_NOTICE_BN",
        "CHAT_YOU_LEFT_NOTICE",
        "CHAT_YOU_LEFT_NOTICE_BN",
        "CLEARED_AFK",
        "CLEARED_DND",
        "ERR_ALREADY_IN_GROUP_S",
        "ERR_BN_FRIEND_ALREADY",
        "ERR_BN_FRIEND_BLOCKED",
        "ERR_BN_FRIEND_LIST_FULL",
        "ERR_BN_FRIEND_REQUEST_SENT",
        "ERR_BN_FRIEND_SELF",
        "ERR_BN_TARGET_OFFLINE",
        "ERR_DECLINE_GROUP_REQUEST_S",
        "ERR_DECLINE_GROUP_S",
        "ERR_FRIEND_ADDED_S",
        "ERR_FRIEND_ALREADY_S",
        "ERR_FRIEND_DB_ERROR",
        "ERR_FRIEND_DELETED",
        "ERR_FRIEND_ERROR",
        "ERR_FRIEND_LIST_FULL",
        "ERR_FRIEND_NOT_FOUND",
        "ERR_FRIEND_OFFLINE_S",
        "ERR_FRIEND_ONLINE_SS",
        "ERR_FRIEND_REMOVED_S",
        "ERR_FRIEND_SELF",
        "ERR_FRIEND_WRONG_FACTION",
        "ERR_GROUP_DISBANDED",
        "ERR_GROUP_FULL",
        "ERR_GUILD_ACCEPT",
        "ERR_GUILD_CREATE_S",
        "ERR_GUILD_DECLINE_AUTO_S",
        "ERR_GUILD_DECLINE_S",
        "ERR_GUILD_DEMOTE_SS",
        "ERR_GUILD_DEMOTE_SSS",
        "ERR_GUILD_DISBANDED",
        "ERR_GUILD_DISBAND_S",
        "ERR_GUILD_DISBAND_SELF",
        "ERR_GUILD_FOUNDER_S",
        "ERR_GUILD_INTERNAL",
        "ERR_GUILD_INVITE_S",
        "ERR_GUILD_INVITE_SELF",
        "ERR_GUILD_JOIN_S",
        "ERR_GUILD_LEADER_CHANGED_SS",
        "ERR_GUILD_LEADER_IS_S",
        "ERR_GUILD_LEADER_LEAVE",
        "ERR_GUILD_LEADER_REPLACED",
        "ERR_GUILD_LEADER_S",
        "ERR_GUILD_LEADER_SELF",
        "ERR_GUILD_LEAVE_RESULT",
        "ERR_GUILD_LEAVE_S",
        "ERR_GUILD_NAME_EXISTS_S",
        "ERR_GUILD_NAME_INVALID",
        "ERR_GUILD_NEW_LEADER_NOT_ALLIED",
        "ERR_GUILD_NEW_LEADER_WRONG_REALM",
        "ERR_GUILD_NOT_ALLIED",
        "ERR_GUILD_PERMISSIONS",
        "ERR_GUILD_PLAYER_NOT_FOUND_S",
        "ERR_GUILD_PLAYER_NOT_IN_GUILD",
        "ERR_GUILD_PLAYER_NOT_IN_GUILD_S",
        "ERR_GUILD_PROMOTE_SSS",
        "ERR_GUILD_QUIT_S",
        "ERR_GUILD_RANKS_LOCKED",
        "ERR_GUILD_RANK_IN_USE",
        "ERR_GUILD_RANK_TOO_HIGH_S",
        "ERR_GUILD_RANK_TOO_LOW_S",
        "ERR_GUILD_REMOVE_SELF",
        "ERR_GUILD_REMOVE_SS",
        "ERR_GUILD_WITHDRAW_LIMIT",
        "ERR_IGNORE_ADDED_S",
        "ERR_IGNORE_ALREADY_S",
        "ERR_IGNORE_AMBIGUOUS",
        "ERR_IGNORE_DELETED",
        "ERR_IGNORE_FULL",
        "ERR_IGNORE_NOT_FOUND",
        "ERR_IGNORE_REMOVED_S",
        "ERR_IGNORE_SELF",
        "ERR_INVITED_TO_GROUP_SS",
        "ERR_INVITE_PLAYER_S",
        "ERR_NOT_IN_GROUP",
        "ERR_PARTY_CONVERTED_TO_RAID",
        "ERR_RAID_CONVERTED_TO_PARTY",
        "ERR_RAID_LEADER_READY_CHECK_START_S",
        "ERR_RAID_MEMBER_ADDED_S",
        "ERR_RAID_MEMBER_REMOVED_S",
        "ERR_RAID_YOU_JOINED",
        "ERR_RAID_YOU_LEFT",
        "ERR_UNINVITE_YOU",
        "MARKED_AFK",
        "MARKED_AFK_MESSAGE",
        "MARKED_DND",
    },
    notice_types = {
        "SYSTEM", "CHANNEL_NOTICE", "CHANNEL_NOTICE_USER", "CHANNEL_JOIN",
        "CHANNEL_LEAVE", "BN_INLINE_TOAST_ALERT", "BN_INLINE_TOAST_BROADCAST",
        "BN_INLINE_TOAST_BROADCAST_INFORM", "BN_WHISPER_PLAYER_OFFLINE",
    },
    rank_arguments = {
        ERR_GUILD_PROMOTE_SSS = 3, ERR_GUILD_DEMOTE_SSS = 3,
        ERR_GUILD_PROMOTE_SS = 2, ERR_GUILD_DEMOTE_SS = 2,
    },
    template_text = {
        ["You are now Away."] = "Ви тепер відсутні.",
        ["You are now Away: %s"] = "Ви тепер відсутні: %s",
        ["You are now Busy: %s"] = "Ви тепер зайняті: %s",
        ["You are no longer marked Busy."] = "Ви більше не зайняті.",
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
    reputation_standings = {
        Neutral = "нейтральне", Honored = "шанобливе",
    },
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

-- GlobalStrings in build 1.60.1.70205. Quest marks the printf argument
-- containing a quest title; other arguments retain player identities.
chat.quest_templates = {
    { source = "%s has declined your quest.", target = "%s відхиляє ваше завдання." },
    { source = "Sharing quest with %s...", target = "Ділимося завданням із %s..." },
    { source = "%s is not eligible for that quest.", target = "%s не відповідає умовам цього завдання." },
    { source = "%s's quest log is full.", target = "Журнал завдань гравця %s заповнений." },
    { source = "%s has accepted your quest.", target = "%s приймає ваше завдання." },
    { source = "%s is busy.", target = "%s зараз зайнятий." },
    { source = "%s is already on that quest.", target = "%s вже виконує це завдання." },
    { source = "%s has completed that quest.", target = "%s вже завершив це завдання." },
    { source = "That quest cannot be shared today.", target = "Сьогодні цим завданням не можна поділитися." },
    { source = "Quest sharing timer has expired.", target = "Час на поширення завдання минув." },
    { source = "You are not in a party.", target = "Ви не перебуваєте в групі." },
    { source = "%s is not eligible for that quest today.", target = "%s сьогодні не відповідає умовам цього завдання." },
    { source = "%s is dead.", target = "%s мертвий." },
    { source = "That quest cannot be shared.", target = "Цим завданням не можна поділитися." },
    { source = "%s is too far away to accept that quest.", target = "%s надто далеко, щоб прийняти це завдання." },
    { source = "%s hasn't completed all of the prerequisite quests required for that quest.", target = "%s ще не завершив усі попередні завдання, необхідні для цього завдання." },
    { source = "%s is too low level for that quest.", target = "Рівень гравця %s надто низький для цього завдання." },
    { source = "%s is too high level for that quest.", target = "Рівень гравця %s надто високий для цього завдання." },
    { source = "%s is the wrong class for that quest.", target = "Клас гравця %s не підходить для цього завдання." },
    { source = "%s is the wrong race for that quest.", target = "Раса гравця %s не підходить для цього завдання." },
    { source = "%s's reputation is too low for that quest.", target = "Репутація гравця %s надто низька для цього завдання." },
    { source = "%s doesn't own the required expansion for that quest.", target = "%s не має доповнення, необхідного для цього завдання." },
    { source = "%s must own a garrison to accept that quest.", target = "%s повинен мати гарнізон, щоб прийняти це завдання." },
    { source = "%s is in the wrong covenant for that quest.", target = "Ковенант гравця %s не підходить для цього завдання." },
    { source = "%s must complete Exile's Reach to accept that quest.", target = "%s повинен завершити «Досяжність Вигнанців», щоб прийняти це завдання." },
    { source = "%s is the wrong faction for that quest.", target = "Фракція гравця %s не підходить для цього завдання." },
    { source = "Quests can't be shared in cross-faction groups.", target = "У міжфракційних групах не можна ділитися завданнями." },
    { source = "%s's reputation is too high for that quest.", target = "Репутація гравця %s надто висока для цього завдання." },
    { source = "Quest accepted: %s", target = "Прийнято завдання «%s»", quest = 1 },
    { source = "%s completed.", target = "Завершено завдання «%s».", quest = 1 },
    { source = "%s failed.", target = "Провалено завдання «%s».", quest = 1 },
    { source = "%s failed: Inventory is full.", target = "Провалено завдання «%s»: інвентар заповнений.", quest = 1 },
    { source = "The quest %s has been removed from your quest log.", target = "Завдання «%s» видалено з вашого журналу завдань.", quest = 1 },
    { source = "Turn in for \"%s\" failed. This quest's unique reward already exists in your inventory. Remove it to complete this quest.", target = "Не вдалося здати завдання «%s». Його унікальна нагорода вже є у вашому інвентарі. Приберіть її, щоб завершити це завдання.", quest = 1 },
    { source = "That quest is not available to your race.", target = "Це завдання недоступне для вашої раси." },
    { source = "You must choose a reward.", target = "Ви повинні обрати нагороду." },
    { source = "Your quest log is full.", target = "Ваш журнал завдань заповнений." },
    { source = "You are not high enough level for that quest.", target = "Ваш рівень надто низький для цього завдання." },
    { source = "You don't have the required items with you.  Check storage.", target = "У вас із собою немає необхідних предметів. Перевірте сховище." },
    { source = "You can only be on one timed quest at a time", target = "Одночасно можна виконувати лише одне завдання з обмеженням часу" },
    { source = "You don't meet the requirements for that quest.", target = "Ви не відповідаєте вимогам цього завдання." },
    { source = "You are already on that quest.", target = "Ви вже виконуєте це завдання." },
    { source = "You don't have enough money for that quest.", target = "У вас недостатньо грошей для цього завдання." },
    { source = "This quest requires an expansion enabled account.", target = "Для цього завдання обліковий запис повинен мати відповідне доповнення." },
    { source = "You have already completed %d daily quests today", target = "Сьогодні ви вже виконали %d щоденних завдань" },
    { source = "You have completed that quest.", target = "Ви вже завершили це завдання." },
    { source = "You cannot complete quests once you have reached tired time", target = "Ви не можете завершувати завдання після досягнення часу втоми" },
    { source = "You have completed that daily quest today.", target = "Сьогодні ви вже виконали це щоденне завдання." },
    { source = "You haven't learned the required spell.", target = "Ви ще не вивчили необхідне закляття." },
    { source = "Progress Bar objective not completed", target = "Ціль зі шкалою прогресу ще не виконана" },
    { source = "Quest Ignored", target = "Завдання ігнорується" },
    { source = "Quest Unignored", target = "Завдання більше не ігнорується" },
}

-- All eighteen ERR_QUEST_PUSH_*_TO_RECIPIENT_S reasons share this prefix.
local quest_share_recipient_reasons = {
    { "You must complete all of the prerequisite quests first.", "спершу завершіть усі необхідні попередні завдання." },
    { "You are not eligible for that quest.", "ви не відповідаєте умовам цього завдання." },
    { "You are dead.", "ви мертві." },
    { "Your quest log is full.", "ваш журнал завдань заповнений." },
    { "You are already on that quest.", "ви вже виконуєте це завдання." },
    { "You have completed that quest.", "ви вже завершили це завдання." },
    { "You are not eligible for that quest today.", "сьогодні ви не відповідаєте умовам цього завдання." },
    { "You are too low level for that quest.", "ваш рівень надто низький для цього завдання." },
    { "You are too high level for that quest.", "ваш рівень надто високий для цього завдання." },
    { "You are the wrong class for that quest.", "ваш клас не підходить для цього завдання." },
    { "You are the wrong race for that quest.", "ваша раса не підходить для цього завдання." },
    { "Your reputation is too low for that quest.", "ваша репутація надто низька для цього завдання." },
    { "You do not own the required expansion for that quest.", "ви не маєте необхідного для цього завдання доповнення." },
    { "You must own a garrison to accept that quest.", "ви повинні мати гарнізон, щоб прийняти це завдання." },
    { "You are in the wrong covenant for that quest.", "ваш ковенант не підходить для цього завдання." },
    { "You must complete Exile's Reach to accept that quest.", "ви повинні завершити «Досяжність Вигнанців», щоб прийняти це завдання." },
    { "You are the wrong faction for that quest.", "ваша фракція не підходить для цього завдання." },
    { "Your reputation is too high for that quest.", "ваша репутація надто висока для цього завдання." },
}
for _, reason in ipairs(quest_share_recipient_reasons) do
    chat.quest_templates[#chat.quest_templates + 1] = {
        source = "%s's attempt to share quest \"%s\" failed. " .. reason[1],
        target = "Гравцю %s не вдалося поділитися завданням «%s»: " .. reason[2],
        quest = 2,
    }
end

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
    tipsy = function (name, item)
        return name .. " здається, трохи напідпитку від " .. item .. "."
    end,
    sobering = function (name)
        return name .. " здається, він протверезіє."
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
    learned_passive = function (spell)
        return "Ви отримали новий пасивний ефект: " .. spell .. "."
    end,
    reputation_standing = function (standing, faction)
        return "Ваше ставлення до фракції «" .. faction .. "» тепер "
            .. standing .. "."
    end,
    quest_share_already = function (player, quest)
        return player .. " не вдалося поділитися завданням «" .. quest
            .. "»: ви вже виконуєте це завдання."
    end,
    group_invite_busy = function (player)
        return "[" .. player .. "] запрошує вас до групи, але ви вже перебуваєте в групі."
    end,
    auction_won = function (item)
        return "Ви виграли аукціон: " .. item
    end,
    away = function (reason) return "Тепер ви відійшли: " .. reason end,
    skill_increased = function (name, rank)
        return "Ваше вміння «" .. name .. "» зросло до " .. rank .. "."
    end,
    skill_gained = function (name) return "Ви здобули вміння «" .. name .. "»." end,
    channel = function (number, channel, zone)
        return number .. channel .. " - " .. zone
    end,
}

addonTable.forever_chat_system = chat
