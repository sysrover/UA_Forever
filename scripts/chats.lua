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

local chat_addition_sequence = 0

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
    scheduler.request("chat-bubble:" .. tostring(chat_text), nil, function ()
        local font_string = utils.chat_bubble_font_string_with_text(chat_text)
        if font_string then
            local MAX_CHAT_BUBBLE_WIDTH = 314 -- value observed from default chat bubbles.
            runtime.apply(font_string, { owner = "chat-bubble", slot = "chat.text",
                source = chat_text, translated = chat_text_uk,
                priority = runtime.PRIORITY.DOMAIN,
                after_apply = function (region)
                    region:SetWidth(math_min(region:GetStringWidth(), MAX_CHAT_BUBBLE_WIDTH))
                end })
        end
    end, 0.01)
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

chats.prepare = function()
    for event_name, _ in pairs(known_chat_msg_events) do
        ChatFrame_AddMessageEventFilter(event_name, filter_chat_msg)
    end
end
