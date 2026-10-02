local _, addon_table = ...

local assets    = addon_table.use("assets") ---@class assets_class
local auto_scan = addon_table.use("auto_scan")
local chats     = addon_table.use("chats") ---@class chats_class
local dev_log   = addon_table.use("dev_log") ---@class dev_log_class
local entries   = addon_table.use("entries") ---@class entries_class
local item_client_db = addon_table.use("item_client_db")
local options   = addon_table.use("options") ---@class options_class
local runtime   = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local utils     = addon_table.use("utils") ---@class utils_class
local hooks     = addon_table.use("translation_hooks").bind("chats")

local math_min          = _G.math.min
local string_format     = _G.string.format
local UnitName          = _G.UnitName
local chat_catalog      = assert(addon_table.forever_chat_system,
    "UA Forever system chat catalog is not loaded")
local chat_format       = chat_catalog.format
local addon_locale      = assert(addon_table.addon_locale_uk,
    "UA Forever addon locale is not loaded")

local known_chat_msg_events = {
    CHAT_MSG_MONSTER_EMOTE      = { info=ChatTypeInfo.MONSTER_EMOTE,        verb=false },
    CHAT_MSG_MONSTER_PARTY      = { info=ChatTypeInfo.MONSTER_PARTY,
        verb=chat_catalog.event_verbs.CHAT_MSG_MONSTER_PARTY },
    CHAT_MSG_MONSTER_SAY        = { info=ChatTypeInfo.MONSTER_SAY,
        verb=chat_catalog.event_verbs.CHAT_MSG_MONSTER_SAY },
    CHAT_MSG_MONSTER_WHISPER    = { info=ChatTypeInfo.MONSTER_WHISPER,
        verb=chat_catalog.event_verbs.CHAT_MSG_MONSTER_WHISPER },
    CHAT_MSG_MONSTER_YELL       = { info=ChatTypeInfo.MONSTER_YELL,
        verb=chat_catalog.event_verbs.CHAT_MSG_MONSTER_YELL },
    CHAT_MSG_RAID_BOSS_EMOTE    = { info=ChatTypeInfo.RAID_BOSS_EMOTE,      verb=false },
    CHAT_MSG_RAID_BOSS_WHISPER  = { info=ChatTypeInfo.RAID_BOSS_WHISPER,
        verb=chat_catalog.event_verbs.CHAT_MSG_RAID_BOSS_WHISPER },
}

local system_chat_events = {
    CHAT_MSG_SYSTEM = true,
    CHAT_MSG_LOOT = true,
    CHAT_MSG_MONEY = true,
    CHAT_MSG_CURRENCY = true,
    CHAT_MSG_COMBAT_XP_GAIN = true,
    CHAT_MSG_COMBAT_FACTION_CHANGE = true,
    CHAT_MSG_SKILL = true,
    CHAT_MSG_TRADESKILLS = true,
}

local chat_addition_sequence = 0
local chat_bubble_sequence = 0
local direct_event_messages = setmetatable({}, { __mode = "k" })
local wrapped_chat_frames = setmetatable({}, { __mode = "k" })

chats.styles = {
    { key = "replacement", label = addon_locale.chat_style_replacement },
    { key = "addition", label = addon_locale.chat_style_addition },
}

local function resolve_npc_name(npc_name, npc_name_uk)
    if npc_name_uk then
        return npc_name_uk
    end

    return utils.cap(entries.get_glossary_text(npc_name, npc_name))
end

local function translate_chat_bubble(chat_text, chat_text_uk)
    if not options.can_translate("translate_chat_bubble") then
        return
    end

    -- chat bubble is not spawned just yet, so we wait a moment
    chat_bubble_sequence = chat_bubble_sequence + 1
    local key = "chat-bubble:" .. chat_bubble_sequence
    local function find_bubble()
        if not options.can_translate("translate_chat_bubble") then return end
        local font_string = utils.chat_bubble_font_string_with_text(chat_text)
        if font_string then
            local combat_text_only = runtime.combat_locked()
            local after_apply
            if not combat_text_only then
                after_apply = function (region)
                    local MAX_CHAT_BUBBLE_WIDTH = 314 -- value observed from default chat bubbles.
                    region:SetWidth(math_min(region:GetStringWidth(), MAX_CHAT_BUBBLE_WIDTH))
                end
            end
            -- In combat, only replace public text on the existing region.
            -- A short-lived bubble must not be queued for post-combat writes.
            if runtime.apply(font_string, { owner = "chat-bubble", slot = "chat.text",
                source = chat_text, translated = chat_text_uk,
                priority = runtime.PRIORITY.DOMAIN,
                combat_text_only = combat_text_only,
                defer_if_protected = false,
                after_apply = after_apply }) then return end
        end
        return false
    end
    scheduler.request({ id=key, surface=chats, instance=key,
        callback=find_bubble, delay=0.01, retry_delay=0.1, max_retries=2 })
end

local function resolve_lang_name(chat_frame, lang_name)
    if lang_name == "" or lang_name == chat_frame.defaultLanguage then
        return lang_name
    end

    return entries.get_language_text(lang_name)
end

local function filter_chat_msg(self, event, chat_text, npc_name, lang_name, ...)
    local known_event = known_chat_msg_events[event]
    if not known_event or not options.can_lookup("translate_chat") then
        return nil, chat_text, npc_name, lang_name, ...
    end

    local npc_name_key = npc_name
    if npc_name == UnitName("player") then
        npc_name_key = "!player"
    end

    local npc_name_uk, chat_text_uk, chat_text_code = entries.get_chat_text(npc_name_key, chat_text)

    if not chat_text_uk and chat_text_code then
        dev_log.missing_chat_text(npc_name_key, chat_text_code, chat_text, lang_name)
    end

    if not options.can_translate("translate_chat") then
        return nil, chat_text, npc_name, lang_name, ...
    end

    local is_replacement = options.account.chat_style == "replacement"

    if not chat_text_uk then
        if is_replacement then
            return nil, chat_text, resolve_npc_name(npc_name, npc_name_uk), resolve_lang_name(self, lang_name), ...
        end
        return nil, chat_text, npc_name, lang_name, ...
    end

    if type(chat_text_uk) == 'string' and chat_text_uk:match("%%s") then
        chat_text_uk = string_format(chat_text_uk, npc_name_uk)
    end

    if known_event.verb then
        translate_chat_bubble(chat_text, chat_text_uk)
    end

    if is_replacement then
        if known_event.verb and self and type(self.AddMessage) == "function" then
            local info = known_event.info
            self:AddMessage(string_format("%s %s: %s",
                resolve_npc_name(npc_name, npc_name_uk),
                known_event.verb, chat_text_uk), info.r, info.g, info.b)
            return true
        end
        return nil, chat_text_uk, npc_name_uk, resolve_lang_name(self, lang_name), ...
    end

    if options.account.chat_style == "addition" then
        local chat_message = assets.icon_ua_inline .. " " .. (known_event.verb
            and string_format("%s %s: %s", npc_name_uk, known_event.verb, chat_text_uk)
            or chat_text_uk) -- emote
        local info = known_event.info

        chat_addition_sequence = chat_addition_sequence + 1
        scheduler.request("chat-addition:" .. chat_addition_sequence, nil, function ()
            self:AddMessage(chat_message, info.r, info.g, info.b)
        end)
    end

    return nil, chat_text, npc_name, lang_name, ...
end

local function translate_item_name(name, item_id)
    local translated = item_id and item_client_db.get_name(item_id)
        or item_client_db.get_name_by_english(name)
    return translated or name
end

local function translate_item_links(text)
    -- Replace only the visible label; retain item ID, bonuses, color and link markup.
    text = text:gsub("(|Hitem:(%d+)[^|]*|h)%[([^%]]+)%](|h)",
        function(prefix, item_id, name, suffix)
            return prefix .. "[" .. translate_item_name(name, tonumber(item_id)) .. "]" .. suffix
        end)
    return text:gsub("%[([^%]]+)%]", function(name)
        return "[" .. translate_item_name(name) .. "]"
    end)
end

local function translate_spell_links(text)
    -- The link target remains untouched so the translated spell stays clickable.
    text = text:gsub("(|Hspell:(%d+)[^|]*|h)%[([^%]]+)%](|h)",
        function(prefix, spell_id, name, suffix)
            local entry = entries.get_entry("spell", tonumber(spell_id))
            local translated = entry and entry[1]
                or entries.lookup_name("spell", name) or name
            return prefix .. "[" .. translated .. "]" .. suffix
        end)
    return text:gsub("%[([^%]]+)%]", function(name)
        return "[" .. (entries.lookup_name("spell", name) or name) .. "]"
    end)
end

local function translate_skill_name(name)
    return addon_table.forever_ui_curated
        and addon_table.forever_ui_curated[name]
        or entries.lookup_name("spell", name)
        or name
end

local money_unit_forms = chat_catalog.money_unit_forms

local function translate_money_amount(amount)
    for english, forms in pairs(money_unit_forms) do
        amount = amount:gsub("(%d+)%s+" .. english .. "%f[^%a]", function(digits)
            local value = tonumber(digits)
            local last_two, last_one = value % 100, value % 10
            local form = last_two >= 11 and last_two <= 14 and 3
                or last_one == 1 and 1
                or last_one >= 2 and last_one <= 4 and 2 or 3
            return digits .. " " .. forms[form]
        end)
    end
    return amount
end

local function translate_direct_chat_text(message)
    if type(message) ~= "string" then return nil end
    local exact = chat_catalog.exact[message]
    if exact then return exact end
    local death_link = message:gsub("(|Hdeath:[^|]+|h)%[You died%.%](|h)",
        chat_format.death_link)
    if death_link ~= message then return death_link end
    local notice_prefix, notice_link, notice_suffix = message:match(
        "^(Remember to act responsibly, protect your personal information, and report anything offensive%. View our In%-Game Code of Conduct on )(.-)( for more information%.)$")
    if notice_prefix then
        return chat_format.conduct_notice(notice_link)
    end
    local share = message:match("^Your share of the loot is (.+)%.$")
    if share then
        return chat_format.loot_share(translate_money_amount(share))
    end
    local looted_money = message:match("^You loot (.+)$")
    if looted_money then
        return chat_format.loot_money(translate_money_amount(looted_money))
    end
    local link_prefix, link_level, label_level, link_suffix = message:match(
        "^Congratulations, you have reached (|c%x%x%x%x%x%x%x%x|Hlevelup:(%d+):LEVEL_UP_TYPE_CHARACTER|h)%[Level (%d+)%](|h|r)!$")
    if link_prefix and link_level == label_level then
        return chat_format.level_link(link_prefix, label_level, link_suffix)
    end
    local color_prefix, colored_level, color_suffix = message:match(
        "^Congratulations, you have reached (|c%x%x%x%x%x%x%x%x)Level (%d+)!(|r)$")
    if color_prefix then
        return chat_format.level_color(color_prefix, colored_level, color_suffix)
    end
    local level = message:match(
        "^Congratulations, you have reached [Ll]evel (%d+)!$")
    if level then return chat_format.level_plain(level) end
    local appearance = message:match(
        "^(.+) has been added to your appearance collection%.$")
    if appearance then
        return chat_format.appearance(translate_item_links(appearance))
    end
    local tipsy_name, tipsy_item = message:match(
        "^(.+) seems a little tipsy from the (.+)%.$")
    if tipsy_name then
        return chat_format.tipsy(tipsy_name, translate_item_links(tipsy_item))
    end
    local sobering_name = message:match("^(.+) seems to be sobering up%.$")
    if sobering_name then return chat_format.sobering(sobering_name) end
    local gained = message:match("^You gained: (.+)$")
    if gained then return chat_format.gained(translate_money_amount(gained)) end
    local currency = message:match("^You receive currency: (.+)$")
    if currency then
        currency = currency:gsub("%[([^%]]+)%]", function(name)
            local translated = addon_table.forever_ui_curated
                and addon_table.forever_ui_curated[name]
                or addon_table.forever_ui and addon_table.forever_ui[name]
                or name
            return "[" .. translated .. "]"
        end)
        return chat_format.currency(currency)
    end
    local created = message:match("^You create: (.+)$")
    if created then return chat_format.create_links(translate_item_links(created)) end
    created = message:match("^You create (.+)%.$")
    if created then return chat_format.create_name(translate_item_name(created)) end
    local recipe = message:match("^You have learned how to create a new item: (.+)%.$")
    if recipe then
        local name = recipe:find("|Hitem:", 1, true) and translate_item_links(recipe)
            or translate_item_name(recipe)
        return chat_format.learned_recipe(name)
    end
    local auction_item = message:match("^You won an auction for (.+)%.$")
        or message:match("^You won an auction for (.+)$")
    if auction_item then
        return chat_format.auction_won(translate_item_name(auction_item))
    end
end

local loot_choice = chat_catalog.loot_choice

local function translate_group_loot(message)
    local prefix, body = message:match("^(|HlootHistory:[^|]+|h)%[Loot%]|h: (.+)$")
    if prefix then
        prefix = chat_format.loot_link_prefix(prefix)
    else
        body = message:match("^%[Loot%]: (.+)$")
        if not body then return nil end
        prefix = chat_format.loot_plain_prefix()
    end

    local player, choice, item = body:match("^(.+) has selected (Need) for: (.+)$")
    if not player then
        player, choice, item = body:match("^(.+) has selected (Greed) for: (.+)$")
    end
    if player then
        return chat_format.loot_player_choice(prefix, player, loot_choice[choice],
            translate_item_links(item))
    end
    choice, item = body:match("^You have selected (Need) for: (.+)$")
    if not choice then
        choice, item = body:match("^You have selected (Greed) for: (.+)$")
    end
    if choice then
        return chat_format.loot_you_choice(prefix, loot_choice[choice],
            translate_item_links(item))
    end
    player, item = body:match("^(.+) won: (.+)$")
    if player then
        return chat_format.loot_won(prefix, player, translate_item_links(item))
    end
    player, item = body:match("^(.+) passed on: (.+)$")
    if player then
        return chat_format.loot_passed(prefix, player, translate_item_links(item))
    end
    local roll, score, rolled_item, roller = body:match("^(Need) Roll %- (%d+) for (.+) by (.+)$")
    if not roll then
        roll, score, rolled_item, roller = body:match("^(Greed) Roll %- (%d+) for (.+) by (.+)$")
    end
    if roll then
        return chat_format.loot_roll(prefix, loot_choice[roll], score,
            translate_item_links(rolled_item), roller)
    end
    if body:match("^%[[^%]]+%]$") or body:find("|Hitem:", 1, true) then
        return prefix .. translate_item_links(body)
    end
end

local function translate_system_text(event, message)
    if type(message) ~= "string" then return nil end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_LOOT"
        or event == "CHAT_MSG_MONEY"
        or event == "CHAT_MSG_CURRENCY" or event == "CHAT_MSG_TRADESKILLS" then
        local direct = translate_direct_chat_text(message)
        if direct then return direct end
    end

    if event == "CHAT_MSG_TRADESKILLS" then
        local crafter, item = message:match("^(.+) creates (.+)%.$")
        if crafter and item then
            return chat_format.crafter_name(crafter, translate_item_name(item))
        end
    end

    if event == "CHAT_MSG_LOOT" or event == "CHAT_MSG_SYSTEM" then
        local group_loot = translate_group_loot(message)
        if group_loot then return group_loot end
        if event == "CHAT_MSG_LOOT" then
            local crafter, created = message:match("^(.+) creates: (.+)%.$")
            if crafter and created then
                return chat_format.crafter_links(crafter,
                    translate_item_links(created))
            end
        end
        local receiver, received = message:match("^(.+) receives loot: (.+)%.$")
        if receiver then
            return chat_format.receiver_loot(receiver,
                translate_item_links(received))
        end
        local loot = message:match("^You receive loot: (.+)$")
        if loot then return chat_format.receive_loot(translate_item_links(loot)) end
        local item = message:match("^You receive item: (.+)$")
        if item then return chat_format.receive_item(translate_item_links(item)) end
    end

    if event == "CHAT_MSG_SYSTEM" then
        local away = message:match("^You are now Away: (.+)$")
        if away then return chat_format.away(away) end
        local sharer, shared_quest = message:match(
            "^(.-)'s attempt to share quest \"(.+)\" failed%. You are already on that quest%.$")
        if sharer then
            local quest = entries.lookup_name("quest", shared_quest) or shared_quest
            return chat_format.quest_share_already(sharer, quest)
        end
        local busy_inviter = message:match(
            "^%[(.+)%] invited you to a group, but you could not accept because you are already in a group%.$")
        if busy_inviter then return chat_format.group_invite_busy(busy_inviter) end
        local standing, standing_faction = message:match(
            "^You are now (.+) with (.+)%.$")
        if standing and chat_catalog.reputation_standings[standing] then
            local faction = addon_table.forever_ui_curated
                and addon_table.forever_ui_curated[standing_faction]
                or addon_table.forever_ui and addon_table.forever_ui[standing_faction]
                or entries.get_glossary_text(standing_faction, standing_faction)
            return chat_format.reputation_standing(
                chat_catalog.reputation_standings[standing], faction)
        end
        local deserter, opponent = message:match("^(.+) has fled from (.+) in a duel$")
        if deserter then
            return chat_format.duel_fled(deserter, opponent)
        end
        local failed_quest = message:match("^(.+) failed: Inventory is full%.$")
        if failed_quest then
            local quest = entries.lookup_name("quest", failed_quest) or failed_quest
            return chat_format.quest_failed_inventory(quest)
        end
        local group, inviter = message:match(
            "^(.+) suggested that (.+) invite you to their group%.$")
        if group then
            return chat_format.group_suggested(group, inviter)
        end
        local inviter, guild = message:match("^(.+) invites you to join (.+)%.$")
        if inviter and guild then
            return chat_format.guild_invite(inviter, guild)
        end
        local raid_member = message:match("^(.+) has joined the raid group%.$")
        if raid_member then return chat_format.raid_joined(raid_member) end
        raid_member = message:match("^(.+) has left the raid group%.$")
        if raid_member then return chat_format.raid_left(raid_member) end
        local fallen_npc = message:match("^(.+) has died%.$")
        if fallen_npc then
            return chat_format.npc_died(
                entries.get_glossary_text(fallen_npc, fallen_npc))
        end
        local leader = message:match("^(.+) is now the group leader%.$")
        if leader then return chat_format.group_leader(leader) end
        local joined = message:match("^(.+) joins the party%.$")
        if joined then return chat_format.party_joined(joined) end
        local left = message:match("^(.+) leaves the party%.$")
        if left then return chat_format.party_left(left) end
        local invited_link = message:match(
            "^(|Hplayer:[^|]+|h%[[^%]]+%]|h) has invited you to join a group%.$")
        if invited_link then return chat_format.group_invite_link(invited_link) end
        local invited = message:match("^%[(.+)%] has invited you to join a group%.$")
        if invited then return chat_format.group_invite_name(invited) end
        local threshold = message:match("^Loot threshold set to (.+)%.$")
        if threshold then
            local quality = chat_catalog.loot_quality[threshold] or threshold
            return chat_format.loot_threshold(quality)
        end
        local looting = message:match("^Looting set to (.+)%.$")
        if looting then
            local method = chat_catalog.loot_method[looting] or looting
            return chat_format.loot_method(method)
        end
        local accepted = message:match("^Quest accepted: (.+)$")
        if accepted then
            return chat_format.quest_accepted(
                entries.lookup_name("quest", accepted) or accepted)
        end
        local completed = message:match("^(.+) completed%.$")
        local quest_name = completed and entries.lookup_name("quest", completed)
        if quest_name then return chat_format.quest_completed(quest_name) end
        local reward = message:match("^Received (.+)%.$")
        if reward then return chat_format.received(translate_money_amount(reward)) end
        local zone = message:match("^Discovered: (.+)$")
        if zone then
            return chat_format.discovered(options.can_translate("translate_zone")
                and addon_table.zone and addon_table.zone[zone] or zone)
        end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_XP_GAIN" then
        local fallen_group, kill_xp_group, bonus = message:match(
            "^(.+) dies, you gain ([%d,]+) experience%. %(%+([%d,]+) group bonus%)$")
        if fallen_group then
            return chat_format.kill_xp_group(
                entries.get_glossary_text(fallen_group, fallen_group),
                kill_xp_group, bonus)
        end
        local fallen, kill_xp = message:match(
            "^(.+) dies, you gain ([%d,]+) experience%.$")
        if fallen then
            return chat_format.kill_xp(
                entries.get_glossary_text(fallen, fallen), kill_xp)
        end
        local zone, discovery_xp = message:match(
            "^Discovered (.-): ([%d,]+) experience gained%.?$")
        if zone then
            local translated_zone = zone
            if options.can_translate("translate_zone") then
                translated_zone = addon_table.zone and addon_table.zone[zone]
                    or entries.get_glossary_text(zone, zone, "zone")
            end
            return chat_format.discovery_xp(translated_zone, discovery_xp)
        end
        local experience = message:match("^Experience gained: ([%d,]+)%.$")
        if experience then return chat_format.experience_gained(experience) end
        local grouped_experience, group_bonus = message:match(
            "^You gain ([%d,]+) experience%. %(%+([%d,]+) group bonus%)$")
        if grouped_experience then
            return chat_format.experience_group(grouped_experience, group_bonus)
        end
        experience = message:match("^You gain ([%d,]+) experience%.$")
        if experience then return chat_format.experience(experience) end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
        local faction, amount = message:match("^Reputation with (.-) increased by ([%d,]+)%.$")
        if not faction then
            faction, amount = message:match("^Your (.-) reputation has increased by ([%d,]+)%.$")
        end
        if faction then
            local name = addon_table.forever_ui and addon_table.forever_ui[faction]
                or entries.get_glossary_text(faction, faction)
            return chat_format.reputation_increased(name, amount)
        end
        faction, amount = message:match("^Reputation with (.-) decreased by ([%d,]+)%.$")
        if not faction then
            faction, amount = message:match("^Your (.-) reputation has decreased by ([%d,]+)%.$")
        end
        if faction then
            local name = addon_table.forever_ui and addon_table.forever_ui[faction]
                or entries.get_glossary_text(faction, faction)
            return chat_format.reputation_decreased(name, amount)
        end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_SKILL" then
        local passive = message:match("^You have learned a new passive effect: (.+)%.$")
        if passive then
            return chat_format.learned_passive(translate_spell_links(passive))
        end
        local learned = message:match("^You have learned a new ability: (.+)%.$")
        if learned then
            return chat_format.learned_ability(translate_spell_links(learned))
        end
        local skill, rank = message:match("^Your skill in (.-) has increased to (%d+)%.$")
        if skill then
            local name = translate_skill_name(skill)
            return chat_format.skill_increased(name, rank)
        end
        skill = message:match("^You have gained the (.-) skill%.$")
        if skill then
            local name = translate_skill_name(skill)
            return chat_format.skill_gained(name)
        end
    end
end

local function record_direct_system_chat(message, r, g, b, translated)
    if type(message) ~= "string" or not ChatTypeInfo then return end
    if message:match("^%[[^%]]+%] says: ")
        or message:find("|Hplayer:", 1, true) then return end
    for _, kind in ipairs({ "SYSTEM", "LOOT", "MONEY", "CURRENCY", "SKILL", "TRADESKILLS" }) do
        local info = ChatTypeInfo[kind]
        if info and r == info.r and g == info.g and b == info.b then
            auto_scan.record_system_chat("ChatFrame.AddMessage", message, translated)
            return
        end
    end
end

local function translated_channel_label(label)
    local number, channel, zone = label:match("^(%d+%. )([^%-]+) %- (.+)$")
    if number and channel and zone then
        local channel_name = chat_catalog.channel_names[channel]
        if channel_name and (channel == "Trade" or channel == "Trade (Services)") then
            local language = addon_table.forever_ui_curated
                and addon_table.forever_ui_curated[zone]
                or addon_table.forever_ui and addon_table.forever_ui[zone]
                or entries.get_language_text(zone)
            return chat_format.channel(number, channel_name, language)
        end
        local zone_name = addon_table.zone and addon_table.zone[zone]
        if channel_name and zone_name then
            return chat_format.channel(number, channel_name, zone_name)
        end
    end
    return addon_table.forever_ui_curated
        and addon_table.forever_ui_curated[label]
        or addon_table.forever_ui and addon_table.forever_ui[label]
end

local function translate_chat_channel_header(message)
    if type(message) ~= "string" then return nil end
    local changed = false
    local result = message:gsub("(|Hchannel:[^|]+|h)%[([^%]]+)%](|h)",
        function(prefix, label, suffix)
            local translated = translated_channel_label(label)
            auto_scan.record_system_chat("ChatFrame.ChannelHeader", label,
                type(translated) == "string" and translated ~= label)
            if type(translated) == "string" and translated ~= label then
                changed = true
                return prefix .. "[" .. translated .. "]" .. suffix
            end
        end)
    return changed and result or nil
end

auto_scan.system_chat_translated = function(event, message)
    if event == "ChatFrame.AddMessage" and (message:match("^%[[^%]]+%] says: ")
        or message:find("|Hplayer:", 1, true)) then return true end
    if event == "ChatFrame.ChannelHeader" then
        local translated = translated_channel_label(message)
        return type(translated) == "string" and translated ~= message
    end
    local translated = event == "ChatFrame.AddMessage"
        and translate_direct_chat_text(message)
        or translate_system_text(event, message)
    return type(translated) == "string" and translated ~= message
end

-- Some client notices are written straight to a ChatFrame without a CHAT_MSG_*
-- event. Change only those exact notices in the frame history after insertion.
local function after_chat_add_message(self, message, r, g, b)
    if wrapped_chat_frames[self] then return end
    if not options.can_lookup("translate_chat")
        or not options.can_translate("translate_chat")
        or (_G.issecretvalue and _G.issecretvalue(message)) then return end
    if direct_event_messages[self] == message then
        direct_event_messages[self] = nil
        return
    end
    local translated = translate_direct_chat_text(message)
        or translate_chat_channel_header(message)
    record_direct_system_chat(message, r, g, b, translated ~= nil)
    if not translated or type(self.TransformMessages) ~= "function" then return end
    if options.account.chat_style == "addition" then
        self:AddMessage(assets.icon_ua_inline .. " " .. translated)
        return
    end
    self:TransformMessages(function(text)
        return not (_G.issecretvalue and _G.issecretvalue(text))
            and text == message
    end, function(_, r, g, b, ...)
        return translated, r, g, b, ...
    end)
end

local function wrap_chat_frame(frame)
    if not frame or wrapped_chat_frames[frame]
        or type(frame.AddMessage) ~= "function" then return end
    local original_add_message = frame.AddMessage
    local ok = pcall(function()
        frame.AddMessage = function(self, message, r, g, b, ...)
            if not options.can_lookup("translate_chat")
                or not options.can_translate("translate_chat")
                or (_G.issecretvalue and _G.issecretvalue(message)) then
                return original_add_message(self, message, r, g, b, ...)
            end
            if direct_event_messages[self] == message then
                direct_event_messages[self] = nil
                return original_add_message(self, message, r, g, b, ...)
            end
            local translated = translate_direct_chat_text(message)
                or translate_chat_channel_header(message)
            record_direct_system_chat(message, r, g, b, translated ~= nil)
            if not translated then return original_add_message(self, message, r, g, b, ...) end
            if options.account.chat_style == "addition" then
                original_add_message(self, message, r, g, b, ...)
                return original_add_message(self,
                    assets.icon_ua_inline .. " " .. translated, r, g, b, ...)
            end
            return original_add_message(self, translated, r, g, b, ...)
        end
    end)
    if ok then wrapped_chat_frames[frame] = true end
end

local function wrap_chat_frames()
    wrap_chat_frame(_G.DEFAULT_CHAT_FRAME)
    for i = 1, (_G.NUM_CHAT_WINDOWS or 10) do
        wrap_chat_frame(_G["ChatFrame" .. i])
    end
end

local function filter_system_msg(self, event, message, ...)
    if not system_chat_events[event] or not options.can_lookup("translate_chat") then
        return nil, message, ...
    end
    local translated = translate_system_text(event, message)
    auto_scan.record_system_chat(event, message, translated ~= nil and translated ~= message)
    if not options.can_translate("translate_chat") then return nil, message, ... end
    if not translated or translated == message then
        direct_event_messages[self] = message
        return nil, message, ...
    end
    if options.account.chat_style == "addition" then
        direct_event_messages[self] = message
        local info = ChatTypeInfo[event:sub(10)] or ChatTypeInfo.SYSTEM
        chat_addition_sequence = chat_addition_sequence + 1
        scheduler.request("chat-addition:" .. chat_addition_sequence, nil, function()
            self:AddMessage(assets.icon_ua_inline .. " " .. translated,
                info and info.r, info and info.g, info and info.b)
        end)
        return nil, message, ...
    end
    return nil, translated, ...
end

chats.prepare = function()
    for event_name, _ in pairs(known_chat_msg_events) do
        ChatFrame_AddMessageEventFilter(event_name, filter_chat_msg)
    end
    for event_name in pairs(system_chat_events) do
        ChatFrame_AddMessageEventFilter(event_name, filter_system_msg)
    end
    hooks.region(_G.ChatFrameMixin, "AddMessage", after_chat_add_message)
    wrap_chat_frames()
    hooks.global("FCF_OpenNewWindow", wrap_chat_frames)
end
