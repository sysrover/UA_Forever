local _, addon_table = ...

local assets    = addon_table.use("assets") ---@class assets_class
local chats     = addon_table.use("chats") ---@class chats_class
local dev_log   = addon_table.use("dev_log") ---@class dev_log_class
local entries   = addon_table.use("entries") ---@class entries_class
local options   = addon_table.use("options") ---@class options_class
local runtime   = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local utils     = addon_table.use("utils") ---@class utils_class

local math_min          = _G.math.min
local string_format     = _G.string.format
local UnitName          = _G.UnitName

local known_chat_msg_events = {
    CHAT_MSG_MONSTER_EMOTE      = { info=ChatTypeInfo.MONSTER_EMOTE,        verb=false },
    CHAT_MSG_MONSTER_PARTY      = { info=ChatTypeInfo.MONSTER_PARTY,        verb="каже" },
    CHAT_MSG_MONSTER_SAY        = { info=ChatTypeInfo.MONSTER_SAY,          verb="каже" },
    CHAT_MSG_MONSTER_WHISPER    = { info=ChatTypeInfo.MONSTER_WHISPER,      verb="шепоче" },
    CHAT_MSG_MONSTER_YELL       = { info=ChatTypeInfo.MONSTER_YELL,         verb="вигукує" },
    CHAT_MSG_RAID_BOSS_EMOTE    = { info=ChatTypeInfo.RAID_BOSS_EMOTE,      verb=false },
    CHAT_MSG_RAID_BOSS_WHISPER  = { info=ChatTypeInfo.RAID_BOSS_WHISPER,    verb="шепоче" },
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

-- Some server items are visible in chat before their IDs reach the client catalog.
local observed_item_names = {
    ["Elfire's Shipment"] = "Вантаж Елфайр",
}

local chat_addition_sequence = 0
local chat_bubble_sequence = 0
local direct_event_messages = setmetatable({}, { __mode = "k" })
local wrapped_chat_frames = setmetatable({}, { __mode = "k" })

chats.styles = {
    { key = "replacement", label = "Заміна" },      -- hand our text to the game and let it print the line as usual
    { key = "addition",    label = "Доповнення" },  -- let the game print the original, then add ours underneath
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
    local attempts = 0
    local function find_bubble()
        if not options.can_translate("translate_chat_bubble") then return end
        attempts = attempts + 1
        local font_string = utils.chat_bubble_font_string_with_text(chat_text)
        if font_string then
            local MAX_CHAT_BUBBLE_WIDTH = 314 -- value observed from default chat bubbles.
            if runtime.apply(font_string, { owner = "chat-bubble", slot = "chat.text",
                source = chat_text, translated = chat_text_uk,
                priority = runtime.PRIORITY.DOMAIN,
                after_apply = function (region)
                    region:SetWidth(math_min(region:GetStringWidth(), MAX_CHAT_BUBBLE_WIDTH))
                end }) then return end
        end
        if attempts < 3 then
            scheduler.request(key, nil, find_bubble, attempts == 1 and 0.05 or 0.15)
        end
    end
    scheduler.request(key, nil, find_bubble, 0.01)
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
    local entry = item_id and entries.get_entry("item", item_id)
    return entry and entry[1]
        or entries.lookup_name("item", name)
        or observed_item_names[name]
        or name
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

local money_unit_forms = {
    Copper = { "мідна монета", "мідні монети", "мідних монет" },
    Silver = { "срібна монета", "срібні монети", "срібних монет" },
    Gold = { "золота монета", "золоті монети", "золотих монет" },
}

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
    if message == "You are no longer Away." then return "Ви повернулися." end
    local looted_money = message:match("^You loot (.+)$")
    if looted_money then
        return "Ваша здобич: " .. translate_money_amount(looted_money)
    end
    local link_prefix, link_level, label_level, link_suffix = message:match(
        "^Congratulations, you have reached (|c%x%x%x%x%x%x%x%x|Hlevelup:(%d+):LEVEL_UP_TYPE_CHARACTER|h)%[Level (%d+)%](|h|r)!$")
    if link_prefix and link_level == label_level then
        return "Вітаємо! Ви досягли " .. link_prefix .. "[" .. label_level
            .. "-го рівня]" .. link_suffix .. "!"
    end
    local color_prefix, colored_level, color_suffix = message:match(
        "^Congratulations, you have reached (|c%x%x%x%x%x%x%x%x)Level (%d+)!(|r)$")
    if color_prefix then
        return "Вітаємо! Ви досягли " .. color_prefix .. colored_level
            .. "-го рівня!" .. color_suffix
    end
    local level = message:match(
        "^Congratulations, you have reached [Ll]evel (%d+)!$")
    if level then return "Вітаємо! Ви досягли " .. level .. "-го рівня!" end
    local appearance = message:match(
        "^(.+) has been added to your appearance collection%.$")
    if appearance then
        return translate_item_links(appearance) ..
            " додано до вашої колекції виглядів."
    end
    local gained = message:match("^You gained: (.+)$")
    if gained then return "Отримано: " .. gained end
    local created = message:match("^You create: (.+)$")
    if created then return "Ви створюєте: " .. translate_item_links(created) end
    local recipe = message:match("^You have learned how to create a new item: (.+)%.$")
    if recipe then
        local name = recipe:find("|Hitem:", 1, true) and translate_item_links(recipe)
            or translate_item_name(recipe)
        return "Ви навчилися створювати новий предмет: " ..
            name .. "."
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

    if event == "CHAT_MSG_LOOT" or event == "CHAT_MSG_SYSTEM" then
        local loot = message:match("^You receive loot: (.+)$")
        if loot then return "Здобуто: " .. translate_item_links(loot) end
        local item = message:match("^You receive item: (.+)$")
        if item then return "Отримано предмет: " .. translate_item_links(item) end
    end

    if event == "CHAT_MSG_SYSTEM" then
        local accepted = message:match("^Quest accepted: (.+)$")
        if accepted then
            return "Завдання прийнято: " ..
                (entries.lookup_name("quest", accepted) or accepted)
        end
        local completed = message:match("^(.+) completed%.$")
        local quest_name = completed and entries.lookup_name("quest", completed)
        if quest_name then return "Завдання виконано: " .. quest_name .. "." end
        local reward = message:match("^Received (.+)%.$")
        if reward then return "Отримано " .. reward .. "." end
        local zone = message:match("^Discovered: (.+)$")
        if zone then
            return "Відкрито нову територію: " ..
                (options.can_translate("translate_zone")
                    and addon_table.zone and addon_table.zone[zone] or zone)
        end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_XP_GAIN" then
        local zone, discovery_xp = message:match(
            "^Discovered (.-): ([%d,]+) experience gained%.?$")
        if zone then
            local translated_zone = zone
            if options.can_translate("translate_zone") then
                translated_zone = addon_table.zone and addon_table.zone[zone]
                    or entries.get_glossary_text(zone, zone, "zone")
            end
            return "Відкрито нову територію: " .. translated_zone ..
                ". Досвіду отримано: " .. discovery_xp .. "."
        end
        local experience = message:match("^Experience gained: ([%d,]+)%.$")
        if experience then return "Досвіду отримано: " .. experience .. "." end
        experience = message:match("^You gain ([%d,]+) experience%.$")
        if experience then return "Ви отримуєте " .. experience .. " досвіду." end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
        local faction, amount = message:match("^Reputation with (.-) increased by ([%d,]+)%.$")
        if not faction then
            faction, amount = message:match("^Your (.-) reputation has increased by ([%d,]+)%.$")
        end
        if faction then
            local name = addon_table.forever_ui and addon_table.forever_ui[faction]
                or entries.get_glossary_text(faction, faction)
            return "Репутацію фракції «" .. name .. "» підвищено на " .. amount .. "."
        end
        faction, amount = message:match("^Reputation with (.-) decreased by ([%d,]+)%.$")
        if not faction then
            faction, amount = message:match("^Your (.-) reputation has decreased by ([%d,]+)%.$")
        end
        if faction then
            local name = addon_table.forever_ui and addon_table.forever_ui[faction]
                or entries.get_glossary_text(faction, faction)
            return "Репутацію фракції «" .. name .. "» знижено на " .. amount .. "."
        end
    end

    if event == "CHAT_MSG_SYSTEM" or event == "CHAT_MSG_SKILL" then
        local learned = message:match("^You have learned a new ability: (.+)%.$")
        if learned then
            return "Ви вивчили нову здібність: " ..
                translate_spell_links(learned) .. "."
        end
        local skill, rank = message:match("^Your skill in (.-) has increased to (%d+)%.$")
        if skill then
            local name = translate_skill_name(skill)
            return "Ваше вміння «" .. name .. "» зросло до " .. rank .. "."
        end
        skill = message:match("^You have gained the (.-) skill%.$")
        if skill then
            local name = translate_skill_name(skill)
            return "Ви здобули вміння «" .. name .. "»."
        end
    end
end

-- Some client notices are written straight to a ChatFrame without a CHAT_MSG_*
-- event. Change only those exact notices in the frame history after insertion.
local function after_chat_add_message(self, message)
    if wrapped_chat_frames[self] then return end
    if not options.can_lookup("translate_chat")
        or not options.can_translate("translate_chat")
        or (_G.issecretvalue and _G.issecretvalue(message)) then return end
    if direct_event_messages[self] == message then
        direct_event_messages[self] = nil
        return
    end
    local translated = translate_direct_chat_text(message)
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
        frame.AddMessage = function(self, message, ...)
            if not options.can_lookup("translate_chat")
                or not options.can_translate("translate_chat")
                or (_G.issecretvalue and _G.issecretvalue(message)) then
                return original_add_message(self, message, ...)
            end
            if direct_event_messages[self] == message then
                direct_event_messages[self] = nil
                return original_add_message(self, message, ...)
            end
            local translated = translate_direct_chat_text(message)
            if not translated then return original_add_message(self, message, ...) end
            if options.account.chat_style == "addition" then
                original_add_message(self, message, ...)
                return original_add_message(self,
                    assets.icon_ua_inline .. " " .. translated, ...)
            end
            return original_add_message(self, translated, ...)
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
    if not system_chat_events[event] or not options.can_lookup("translate_chat")
        or not options.can_translate("translate_chat") then
        return nil, message, ...
    end
    local translated = translate_system_text(event, message)
    if not translated or translated == message then return nil, message, ... end
    if options.account.chat_style == "addition" then
        if translate_direct_chat_text(message) then
            direct_event_messages[self] = message
        end
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
    if _G.ChatFrameMixin and type(_G.ChatFrameMixin.AddMessage) == "function"
        and type(_G.hooksecurefunc) == "function" then
        _G.hooksecurefunc(_G.ChatFrameMixin, "AddMessage", after_chat_add_message)
    end
    wrap_chat_frames()
    if type(_G.FCF_OpenNewWindow) == "function"
        and type(_G.hooksecurefunc) == "function" then
        _G.hooksecurefunc("FCF_OpenNewWindow", wrap_chat_frames)
    end
end
