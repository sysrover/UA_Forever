local _, addon_table = ...

local dev_log   = addon_table.use("dev_log") ---@class dev_log_class
local entries   = addon_table.use("entries") ---@class entries_class
local options   = addon_table.use("options") ---@class options_class
local utils     = addon_table.use("utils") ---@class utils_class
local gossip_hashed = addon_table.use("gossip_hashed")
local chat_hashed = addon_table.use("chat_hashed")
local function chat_lookup()
    if type(chat_hashed.find) ~= "function" then
        gossip_hashed.create("chat_hashed", function(scope)
            return type(scope) == "string" and scope or nil
        end, chat_hashed, true)
    end
    return chat_hashed
end

local pcall         = _G.pcall
local string_format = _G.string.format
local string_gmatch = _G.string.gmatch
local string_split  = _G.string.split
local string_trim   = _G.string.trim
local UnitName      = _G.UnitName
local UnitSex       = _G.UnitSex

local function prepare_quests(is_alliance)
    local at = addon_table
    -- init faction quests reference
    at.quest_faction = is_alliance and at.quest_alliance or at.quest_horde
    -- drop opposite faction quests
    at[ is_alliance and "quest_horde" or "quest_alliance" ] = nil
end

-- pushes codes "xxx", "Xxx", "XXX" to given table
-- all string args are expected to be lowercased; case_key is optional
local push_code_group_to_table = function (tbl, name_key, case_key, text)
    if case_key then
        tbl["{"             .. name_key  .. ":" .. case_key .. "}"] = text              -- {клас:о} = "магом"
        tbl["{" ..   utils.cap(name_key) .. ":" .. case_key .. "}"] = utils.cap(text)   -- {Клас:о} = "Магом"
        tbl["{" .. utils.upper(name_key) .. ":" .. case_key .. "}"] = utils.upper(text) -- {КЛАС:о} = "МАГОМ"
    else
        tbl["{"             .. name_key  ..                    "}"] = text              -- {клас} = "маг"
        tbl["{" ..   utils.cap(name_key) ..                    "}"] = utils.cap(text)   -- {Клас} = "Маг"
        tbl["{" .. utils.upper(name_key) ..                    "}"] = utils.upper(text) -- {КЛАС} = "МАГ"
    end
end

local function prepare_codes(name, name_cases, race, class, is_male)
    local at = addon_table
    local sex = is_male and 1 or 2
    local cases = { "н", "р", "д", "з", "о", "м", "к" }
    local codes = {}

    -- name

    for _, c in ipairs(cases) do
        local t = name_cases[c] or ""
        if t == "" then
            t = name_cases["н"] or ""
            if t == "" then
                t = name
            end
        end

        push_code_group_to_table(codes, "ім'я", c, t)
        if c == "н" then
            push_code_group_to_table(codes, "ім'я", nil, t)
        end
    end

    -- race

    local race_key = race:lower()
    if not at.race[race_key] then
        -- use some default value in case race is unknown/unsupported
        race_key = "human"
    end

    for c, race_case in pairs(at.race[race_key]) do
        local t = race_case[sex]
        push_code_group_to_table(codes, "раса", c, t)
        if c == "н" then
            push_code_group_to_table(codes, "раса", nil, t)
        end
    end

    -- class

    local class_key = class:lower()
    if not at.class[class_key] then
        -- use some default value in case class is unknown/unsupported
        class_key = "warrior"
    end

    for c, class_case in pairs(at.class[class_key]) do
        local t = class_case[sex]
        push_code_group_to_table(codes, "клас", c, t)
        if c == "н" then
            push_code_group_to_table(codes, "клас", nil, t)
        end
    end

    -- sex

    -- only "стать" is needed, but we make possible to use any letter casing
    -- (even if it has nothing to do with the letter case of the result, as text gets shown as is)
    codes["{стать:(.-):(.-)}"] = function (a, b) return is_male and a or b end
    codes["{Стать:(.-):(.-)}"] = function (a, b) return is_male and a or b end
    codes["{СТАТЬ:(.-):(.-)}"] = function (a, b) return is_male and a or b end

    at.codes = codes
end

local function prepare_glossary()
    local at = addon_table
    local glossary = {}

    -- collect text-key entries: misc, string, object, zone
    for _, entry_type in ipairs({ "misc", "string", "object", "zone" }) do
        for entry_key, entry_value in pairs(at[entry_type]) do
            local glossary_key = string_trim(entry_key:lower())
            if not glossary[glossary_key] then
                glossary[glossary_key] = entry_value
            end

            -- if key starts with "the " part, add key without it
            if glossary_key:find("^the ") and #glossary_key > 8 then
                local glossary_key_no_the = glossary_key:sub(5)
                if not glossary[glossary_key_no_the] then
                    glossary[glossary_key_no_the] = entry_value
                end
            else
                -- if key doesn't start with "the ", add key that does
                local glossary_key_with_the = "the " .. glossary_key
                if not glossary[glossary_key_with_the] then
                    glossary[glossary_key_with_the] = entry_value
                end
            end
        end
    end

    -- collect id-key entries: spell, npc, quest. Item names are owned by the
    -- build-validated item_client_db and must not enter the generic glossary.
    for _, entry_type in ipairs({ "spell", "npc", "quest_faction", "quest_both" }) do
        for _, entry_value in pairs(at[entry_type]) do
            if entry_value.en then
                local glossary_key = string_trim(entry_value.en:lower())
                if not glossary[glossary_key] then
                    glossary[glossary_key] = entry_value[1]
                end
            end
        end
    end

    at.glossary = glossary
end

local function prepare_name_lookup()
    local at = addon_table
    local names = { quest = {}, spell = {} }
    local name_ids = { quest = {}, spell = {} }
    local quest_title_ids = {}
    local quest_task_names = {}
    for _, group in ipairs({
        { "spell", at.spell },
        { "quest", at.quest_faction }, { "quest", at.quest_both },
    }) do
        for id, entry in pairs(group[2] or {}) do
            if type(entry) == "table" and type(entry.en) == "string"
                and type(entry[1]) == "string" and names[group[1]][entry.en] == nil then
                names[group[1]][entry.en] = entry[1]
                name_ids[group[1]][entry.en] = id
            end
            if group[1] == "quest" and type(entry) == "table" then
                for source, translated in pairs(entry.tasks or {}) do
                    if type(source) == "string" and type(translated) == "string"
                        and translated ~= "" then
                        local known = quest_task_names[source]
                        if known == nil then
                            quest_task_names[source] = translated
                        elseif known ~= translated then
                            -- UI_INFO_MESSAGE has no quest ID. Never choose an
                            -- arbitrary quest when the same task has different wording.
                            quest_task_names[source] = false
                        end
                    end
                end
                local titles = { entry.en, entry[1] }
                for index = 1, 2 do
                    local title = titles[index]
                    if type(title) == "string" and title ~= ""
                        and (index == 1 or title ~= entry.en) then
                        quest_title_ids[title] = quest_title_ids[title] or {}
                        quest_title_ids[title][#quest_title_ids[title] + 1] = id
                    end
                end
            end
        end
    end
    entries.names = names
    entries.name_ids = name_ids
    entries.quest_title_ids = quest_title_ids
    entries.quest_task_names = quest_task_names
end

entries.prepare = function ()
    if entries.prepared then return end
    -- todo: handle faction update when panda-player chooses faction (mop+)
    -- note: if we expect to update faction at runtime then prepare_quests() needs rework

    local name          = UnitName("player")
    local sex           = UnitSex("player")
    local is_male       = sex == 2
    local race          = select(2, UnitRace("player"))
    local class         = select(2, UnitClass("player"))
    local faction       = UnitFactionGroup("player")
    local is_alliance   = faction == "Alliance"

    prepare_quests(is_alliance)
    prepare_codes(name, options.character.name_cases, race, class, is_male)
    prepare_glossary()
    prepare_name_lookup()
    if type(gossip_hashed.prepare) == "function" then gossip_hashed.prepare() end
    entries.prepared = true
end

entries.lookup_name = function (category, english)
    local names = entries.names and entries.names[category]
    local translated = names and names[english] or nil
    if translated and not translated:find("{%d+}")
        and not translated:find("#", 1, true) then return translated end
end

entries.lookup_id = function (category, english)
    local ids = entries.name_ids and entries.name_ids[category]
    return ids and ids[english] or nil
end

entries.lookup_quest_id_for_task = function (title, task)
    local ids = entries.quest_title_ids and entries.quest_title_ids[title]
    if not ids then return nil end
    if type(task) == "string" then
        for _, id in ipairs(ids) do
            local quest = addon_table.quest_faction[id] or addon_table.quest_both[id]
            if quest and quest.tasks and quest.tasks[task] then return id end
        end
    end
    return #ids == 1 and ids[1] or nil
end

local function make_text(text)
    if not text then
        return
    end

    for k, v in pairs(addon_table.codes) do
        text = text:gsub(k, v)
    end

    return text
end

local function make_text_array(array)
    if not array then
        return
    end

    local result = {}
    -- Quest records are sparse: progress [4] can be absent while completion
    -- [5] is present.  The length operator is undefined for tables with holes
    -- and can therefore truncate the completion text.
    for key, value in pairs(array) do
        if type(key) == "number" and type(value) == "string" then
            result[key] = make_text(value)
        end
    end

    return result
end

local function make_chat_text(original, translation, source_template)
    local known_templates = { name=true, race=true, class=true, target=true }
    local at = addon_table
    local sex = UnitSex("player") == 2 and 1 or 2
    local player_name = UnitName("player")

    if not translation then
        return nil
    end

    local translation_split = { string_split("#", translation) }
    local template_matches = {}
    if source_template then
        local kinds = {}
        local expression = utils.esc(source_template):gsub("<([%a]+)>", function(kind)
            if known_templates[kind] then
                kinds[#kinds + 1] = kind
                return "(.-)"
            end
            return "<" .. kind .. ">"
        end)
        local captures = { original:match("^" .. expression .. "$") }
        for i, kind in ipairs(kinds) do template_matches[kind] = captures[i] end
    end
    if #translation_split > 1 then
        local text_templates = {}
        for i = 2, #translation_split do
            local template = translation_split[i]
            local template_type = template:match("<(.+)>")
            if known_templates[template_type] then
                text_templates[template_type] = template
            elseif template_type:match("/") then
                local match_male, match_female = template_type:match("^(.+)/(.+)$")
                if original:match(utils.esc(template:gsub("<"..utils.esc(template_type)..">", match_male))) then
                    sex = 1
                elseif original:match(utils.esc(template:gsub("<"..utils.esc(template_type)..">", match_female))) then
                    sex = 2
                else
                    error("Error. Unknown sex.")
                end
            else
                error("Error. Unknown template type: " .. tostring(template_type))
            end
        end

        for template_type, template in pairs(text_templates) do
            local template_expression = utils.esc(template):gsub("<" .. template_type .. ">", "(.-)")
            local match = original:match(template_expression)
            template_matches[template_type] = match
        end
    end

    translation = translation_split[1]

    for pattern_uk in translation:gmatch("{(.-)}") do
        local pattern_uk_split = { string_split(":", pattern_uk) }
        local pattern_uk_type = pattern_uk_split[1]
        local case = pattern_uk_split[2] or "н"
        pattern_uk = "{" .. utils.esc(pattern_uk) .. "}"

        if utils.lower(pattern_uk_type) == "ім'я" then
            local name_en = template_matches["name"]
            local name_uk
            if name_en == player_name then
                name_uk = options.character.name_cases and options.character.name_cases[case] or name_en
            else
                name_uk = name_en
            end
            name_uk = name_uk and pattern_uk_type == "Ім'я" and utils.cap(name_uk) or name_uk
            name_uk = name_uk and pattern_uk_type == "ІМ'Я" and utils.upper(name_uk) or name_uk
            translation = translation:gsub(pattern_uk, name_uk)
        end

        if pattern_uk_type:lower() == "раса" then
            local race_en = template_matches["race"]
            local race_key = race_en:lower():gsub(" ", "")
            local race_uk = at.race[race_key] and at.race[race_key][case][sex]
            race_uk = race_uk and pattern_uk_type == "Раса" and utils.cap(race_uk) or race_uk
            race_uk = race_uk and pattern_uk_type == "РАСА" and utils.upper(race_uk) or race_uk
            translation = translation:gsub(pattern_uk, race_uk or race_en)
        end

        if pattern_uk_type:lower() == "клас" then
            local class_en = template_matches["class"]
            local class_key = class_en:lower():gsub(" ", "")
            local class_uk = at.class[class_key] and at.class[class_key][case][sex]
            class_uk = class_uk and pattern_uk_type == "Клас" and utils.cap(class_uk) or class_uk
            class_uk = class_uk and pattern_uk_type == "КЛАС" and utils.upper(class_uk) or class_uk
            translation = translation:gsub(pattern_uk, class_uk or class_en)
        end

        if utils.lower(pattern_uk_type) == "ціль" then
            local target_en = template_matches["target"]
            local target_uk
            if target_en == player_name then
                target_uk = options.character.name_cases and options.character.name_cases[case]
            elseif at.class[target_en:lower():gsub(" ", "")] then
                target_uk = at.class[target_en:lower():gsub(" ", "")][case][sex]
            elseif at.race[target_en:lower():gsub(" ", "")] then
                local race_key = target_en:lower():gsub(" ", "")
                target_uk = at.race[race_key][case][sex]
            elseif at.glossary[target_en:lower()] then
                target_uk = at.glossary[target_en:lower()]
            end
            target_uk = target_uk and pattern_uk_type == "Ціль" and utils.cap(target_uk) or target_uk
            target_uk = target_uk and pattern_uk_type == "ЦІЛЬ" and utils.upper(target_uk) or target_uk
            translation = translation:gsub(pattern_uk, target_uk or target_en)
        end

        if pattern_uk_type:lower() == "стать" then
            translation = translation:gsub(pattern_uk, pattern_uk_split[sex+1])
        end

    end

    return translation
end

local function safe_make_chat_text(original, translation, source_template)
    local success, result = pcall(make_chat_text, original, translation, source_template)

    if success then
        return result
    else
        dev_log.issue("Помилка перекладу чату \"" .. tostring(original) .. "\"", tostring(result))
        return nil
    end
end

local function resolve_entry_with_possible_ref(entry_type, entry_id, depth)
    depth = depth or 1
    if depth > 4 then
        if options.account.dev_mode then
            dev_log.issue_entry(entry_type, entry_id, "переповнення глибини пошуку ref")
        end
        return
    end

    if not entry_type or not entry_id then
        return
    end

    local at = addon_table

    if not at[entry_type] then
        if options.account.dev_mode then
            dev_log.issue_entry(entry_type, entry_id, "невірний тип запису \"" .. entry_type .. "\"")
        end
        return
    end

    local entry = at[entry_type][entry_id]

    if entry and entry.ref then
        if entry_type == "spell" or entry_type == "item" then
            local entry_ref = resolve_entry_with_possible_ref(entry_type, entry.ref, depth + 1)
            if entry_ref then
                return utils.copy_table(utils.copy_table({}, entry_ref), entry)
            elseif options.account.dev_mode then
                dev_log.issue_entry(entry_type, entry_id, "невірне значення ref для " .. entry_type .. '#' .. tostring(entry_ref))
                return utils.copy_table({ entry_type .. "#" .. entry_id .. "=>#" .. entry.ref }, entry)
            end
        elseif options.account.dev_mode then
            dev_log.issue_entry(entry_type, entry_id, "невірне використання ref; дозволено лише для типів запису spell та item")
        end
    end

    return entry
end

local function get_book_entry(book_id, book_name)
    local at = addon_table
    local numeric_id = tonumber(book_id)
    local book = numeric_id and at.book[numeric_id] or nil
    local identity = book and numeric_id or nil

    if not book and type(book_name) == "string" and book_name ~= "" then
        book = at.book[book_name]
        identity = book and book_name or nil
    end

    return book, identity
end

entries.get_book_page = function (book_id, book_name, page)
    local book, identity = get_book_entry(book_id, book_name)
    page = tonumber(page) or 1
    local text = book and book[page]
    return type(text) == "string" and make_text(text) or nil, identity
end

entries.get_book_title = function (book_name)
    if type(book_name) ~= "string" or book_name == "" then return nil end
    local translated = addon_table.translate_object_name
        and addon_table.translate_object_name(book_name)
    if type(translated) ~= "string" or translated == "" then return nil end
    return make_text(utils.cap(translated))
end

entries.get_entry = function (entry_type, entry_id, field)
    if not entry_type or not entry_id then
        return
    end

    local at = addon_table
    if entry_type == "book" then
        local book = get_book_entry(entry_id)

        if book then
            return make_text_array(book)
        elseif options.account.dev_mode and entry_id ~= 8383 then -- #8383 is a saved letter inventory item
            dev_log.missing_book_page(entry_id, ItemTextGetPage(), ItemTextGetText())
        end

        return
    end

    entry_id = tonumber(entry_id)
    if entry_id == 0 then
        return
    end

    if entry_type == "quest" then
        local quest = nil

        if at.quest_faction[entry_id] then
            quest = at.quest_faction[entry_id]
        elseif at.quest_both[entry_id] then
            quest = at.quest_both[entry_id]
        end

        if quest then
            -- A title/detail region needs one field, not substitutions over
            -- every paragraph of the quest. Keep substitutions live because
            -- player/target codes can change without reloading the catalog.
            if type(field) == "number" then
                return { [field] = make_text(quest[field]) }
            end
            return make_text_array(quest)
        elseif options.account.dev_mode then
            dev_log.missing_quest(entry_id)
        end

        return
    end

    return resolve_entry_with_possible_ref(entry_type, entry_id)
end

local function resolve_optional_entry_text(text, tt_lines, tooltip_matches_to_skip)
    return text:gsub("%[(.-)#(.-)%]", function(translation, condition)
        local values = {}
        local conditions = { string_split("#", condition) }
        for i = 1, #conditions do
            local pattern = utils.esc(conditions[i]):gsub("{(%d+)}", function () return "([%d,.]*%d)" end)
            local match_number = 0
            for j = 1, #tt_lines do
                local matches = { tt_lines[j]:match(pattern) }
                if #matches > 0 then
                    match_number = match_number + 1
                    if match_number > tooltip_matches_to_skip then
                        if #matches > 0 and not (matches[1] == pattern) then
                            for k = 1, #matches do
                                values[#values + 1] = utils.fix_float_number(matches[k])
                            end
                        end
                        break
                    end
                end
            end
            if match_number <= tooltip_matches_to_skip then
                return ""
            end
        end
        return translation:gsub("{(%d+)}", function (a) return values[tonumber(a)] end)
    end)
end

entries.make_entry_text = function (text, tooltip, tooltip_matches_to_skip, source_line)
    if not text then
        return
    end
    if not text:find("#") or not tooltip then
        return text
    end

    if not tooltip_matches_to_skip then
        tooltip_matches_to_skip = 0
    end
    local tt_lines = source_line and { source_line } or utils.tooltip_lines(tooltip)

    text = resolve_optional_entry_text(text, tt_lines, tooltip_matches_to_skip)
    text = { string_split("#", text) }

    local values = {}
    for i = 2, #text do
        local pattern = utils.esc(text[i]:lower()):gsub("{(%d+)}", function () return "([%d,.]*%d)" end)
        local pattern_numbers = {}
        for pattern_number in text[i]:lower():gmatch("{(%d+)}") do
            pattern_numbers[#pattern_numbers + 1] = tonumber(pattern_number)
        end
        local match_number = 0
        for j = 1, #tt_lines do
            local matches = { tt_lines[j]:lower():match(pattern) }
            if #matches > 0 and #matches == #pattern_numbers then
                match_number = match_number + 1
                if match_number > tooltip_matches_to_skip then
                    for k = 1, #matches do
                        values[pattern_numbers[k]] = utils.fix_float_number(matches[k])
                    end
                    break
                end
            end
        end
    end

    local result = text[1]:gsub("{(%d+)}", function (a) return values[tonumber(a)] end)

    --if result:match("{%d}") and options.account.dev_mode and #tt_lines > 0 then
    --    dev_log.issue("незаповнені значення шаблону [" .. tt_lines[1] .. "] " .. text[1])
    --end

    result = string_trim(result)

    return result
end

entries.get_language_text = function (language_name)
    local at = addon_table

    if type(at.language) ~= "table" then
        return language_name
    end

    return at.language[language_name] or language_name
end

entries.get_glossary_text = function (entry_key, fallback, hint_type)
    local at = addon_table

    if type(entry_key) ~= "string" or type(at.glossary) ~= "table" then
        return fallback
    end

    local original_entry_key = entry_key

    local faction_text = addon_table.use("faction_client_db").get_text(
        utils.strip_color_codes(entry_key):match("^%s*(.-)%s*$"))
    if faction_text then return faction_text end

    -- prepare entry_key
    entry_key = utils.strip_color_codes(entry_key)
    entry_key = utils.first_line_only(entry_key)
    entry_key = string_trim(entry_key)
    entry_key = entry_key:lower()

    -- check directly
    if at.glossary[entry_key] then
        return utils.cap(at.glossary[entry_key])
    end

    local key, key1, key2

    -- check using Questie' quest format: [57+] Feathermoon Stronghold
    key = string_gmatch(entry_key, "%[.+%] (.*)")()
    if key then
        if at.glossary[key] then
            return utils.cap(at.glossary[key])
        end
    end

    -- check using Questie' quest format: [57+] Feathermoon Stronghold (12345)
    key = string_gmatch(entry_key, "%[.+%] (.*) %((.*)%)")()
    if key then
        if at.glossary[key] then
            return utils.cap(at.glossary[key])
        end
    end

    -- check using Questie' npc format: John Smith (Wind Rider Master)
    key1, key2 = string_gmatch(entry_key, "(.*) %((.*)%)")()
    if key1 and key2 then
        if at.glossary[key1] then
            if at.glossary[key2] then
                return utils.cap(at.glossary[key1]) .. " (" .. utils.cap(at.glossary[key2]) .. ")"
            else
                return utils.cap(at.glossary[key1])
            end
        end
    end

    if options.account.dev_mode and hint_type then
        if hint_type == "zone" then
            dev_log.missing_zone(original_entry_key)
        else
            dev_log.issue("непідтримуваний тип даних в get_glossary_text()", { hint_type, original_entry_key })
        end
    end

    return fallback
end

local function get_gossip_text(npc_id, gossip_text, role)
    if type(gossip_hashed.find) == "function" then
        local translated = gossip_hashed.find(npc_id, gossip_text, role)
        if translated then return translated, nil end
    end
    if type(gossip_text) ~= "string" then return nil end
    local codes, _, _, _, template_code = utils.get_gossip_lookup_codes(gossip_text)
    return nil, template_code or codes[1]
end

-- Shared read-only lookup for autoscan; never records another missing entry.
entries.find_gossip_translation = function (npc_id, text, is_reply)
    return get_gossip_text(npc_id, text, is_reply and "reply" or "greeting")
end

entries.get_gossip_text_for_npc_talk = function (npc_id, gossip_text)
    if not npc_id or type(gossip_text) ~= "string" then
        return
    end

    local text_uk, gossip_code = get_gossip_text(npc_id, gossip_text, "greeting")
    if text_uk then
        return text_uk
    end

    if (options.account.dev_mode or options.account.auto_scan_content) and gossip_code then
        dev_log.missing_gossip(npc_id, gossip_code, gossip_text, false)
    end
end

entries.get_gossip_text_for_player_reply = function (npc_id, gossip_text)
    if not npc_id or type(gossip_text) ~= "string" then
        return
    end

    local new_text = gossip_hashed.find(npc_id, gossip_text, "reply")
    if new_text then
        return new_text
    end

    local match_list = utils.get_match_list_of_equal_meaning_english_texts_for_phrase(gossip_text)
    for _, text_en in pairs(match_list) do
        local text_uk = get_gossip_text(npc_id, text_en, "reply")
        if text_uk then
            return text_uk
        end
    end

    -- replies are generally short, and also it can be class name, battleground name, dungeon name etc.
    local found_text = entries.get_glossary_text(gossip_text)
    if found_text then
        return found_text
    end

    if options.account.dev_mode or options.account.auto_scan_content then
        local gossip_code = utils.get_text_code(gossip_text)
        if gossip_code then
            dev_log.missing_gossip(npc_id, gossip_code, gossip_text, true)
        end
    end
end

entries.get_chat_text = function (npc_name, chat_text)
    local at = addon_table

    if not npc_name or type(chat_text) ~= "string" then
        return
    end

    local text, _, source_template = chat_lookup().find(npc_name, chat_text, nil, true)
    if text then
        -- Stored templates resolve the person addressed, including other players;
        -- old translations can also retain their own # fragments.
        local npc_strings = at.chat and at.chat[npc_name]
        local npc_name_uk = npc_strings and npc_strings[1] or entries.get_glossary_text(npc_name, npc_name)
        local translated = safe_make_chat_text(chat_text, text, source_template)
        if translated then return utils.cap(npc_name_uk), translated, nil end
    end

    -- Only entries without a recovered English source remain in this table.
    local chat_code = utils.get_text_code(chat_text)
    if type(at.chat) ~= "table" then return nil, nil, chat_code end
    if chat_code and #chat_code > 0 then
        for _, npc_key in ipairs({ npc_name, '!common' }) do
            local npc_strings = at.chat[npc_key]
            if npc_strings and npc_strings[chat_code] then
                local npc_name_uk = npc_strings[1]
                    or entries.get_glossary_text(npc_name, npc_name)
                local chat_text_uk = safe_make_chat_text(chat_text, npc_strings[chat_code])
                return utils.cap(npc_name_uk), chat_text_uk, chat_code
            end
        end
    end

    -- check text hash hit

    local chat_hash = utils.get_text_hash(chat_text)
    for _, npc_key in ipairs({ npc_name, '!common' }) do
        local npc_strings = at.chat[npc_key]
        if npc_strings and npc_strings[chat_hash] then
            local npc_name_uk = at.chat[npc_key][1]
            if not npc_name_uk then
                npc_name_uk = entries.get_glossary_text(npc_name, npc_name)
            end
            local chat_text_uk = safe_make_chat_text(chat_text, at.chat[npc_key][chat_hash])
            return utils.cap(npc_name_uk), chat_text_uk, nil
        end
    end

    -- check text code hit

    if chat_code and #chat_code > 0 then
        for _, npc_key in ipairs({ npc_name, '!common' }) do
            local npc_strings = at.chat[npc_key]
            if npc_strings and npc_strings['!code'] then
                local known_chat_keys = utils.table_string_keys(npc_strings['!code'])
                local chat_key = utils.match_text_code(chat_code, known_chat_keys)
                if chat_key then
                    local npc_name_uk = npc_strings[1]
                    if not npc_name_uk then
                        npc_name_uk = entries.get_glossary_text(npc_name, npc_name)
                    end
                    local hash = npc_strings['!code'][chat_key]
                    local chat_text_uk = safe_make_chat_text(chat_text, npc_strings[hash])
                    return utils.cap(npc_name_uk), chat_text_uk, chat_code
                end
            end
        end
    end

    return nil, nil, chat_code
end

entries.translate_quest_objective_task = function (text, quest_id, objective_source)
    -- Camelot's quest tracker gets its visible objective strings from the
    -- legacy GetQuestLogLeaderBoard API. Keep the live C_QuestLog objective
    -- table pristine and translate only the text after its dynamic N/N prefix.
    local quest_surface = addon_table.forever_surface_ui
        and addon_table.forever_surface_ui.quest or {}
    local complete_suffix = ""
    local without_complete = text:match("^(.-)%s+%(Complete%)$")
    if without_complete then
        text = without_complete
        complete_suffix = quest_surface.complete_suffix or " (Complete)"
    end
    local function finish(value)
        return value .. complete_suffix
    end

    if text == "Objective Complete." then
        return finish(quest_surface.objective_complete or text)
    end
    -- Prefer the exact quest wording before decomposing client templates.
    local quest = quest_id and (addon_table.quest_faction[tonumber(quest_id)]
        or addon_table.quest_both[tonumber(quest_id)])
    local task = quest and quest.tasks and quest.tasks[text]
    if type(task) == "string" then return finish(make_text(task)) end
    if not quest_id then
        local shared_task = entries.quest_task_names and entries.quest_task_names[text]
        if type(shared_task) == "string" then
            return finish(utils.cap(make_text(shared_task)))
        end
    end
    if text == "Players slain" then
        return finish(quest_surface.player_kills or text)
    end
    if text == "Players defeated in pet battle" then
        return finish(quest_surface.pet_battle_victories or text)
    end

    local status_prefix = text:match("^(%-%s*)Ready for turn%-in$")
    if status_prefix then
        return finish(status_prefix
            .. (quest_surface.ready_for_turn_in or "Ready for turn-in"))
    end
    if text == "Ready for turn-in" then
        return finish(quest_surface.ready_for_turn_in or text)
    end
    local progress_prefix, objective_text = text:match("^(%d[%d%.,]*%s*/%s*%d[%d%.,]*%s+)(.+)$")
    if progress_prefix and objective_text then
        return finish(progress_prefix .. entries.translate_quest_objective_task(
            objective_text, quest_id, objective_source))
    end

    -- QUEST_FACTION_NEEDED uses %s for both progress values. They can be
    -- formatted numbers rather than plain %d, so identify the objective by
    -- its translation and retain the entire client-supplied progress prefix.
    local faction_prefix, faction_tail = text:match("^(.+%s+/%s+)(.+)$")
    if faction_prefix then
        local start_at = 1
        for _ = 1, 20 do
            local first, last = faction_tail:find("%s+", start_at)
            if not first then break end
            local source = faction_tail:sub(last + 1)
            local translated = entries.translate_quest_objective_task(
                source, quest_id, objective_source)
            if translated ~= source then
                return finish(faction_prefix .. faction_tail:sub(1, last) .. translated)
            end
            start_at = last + 1
        end
    end

    -- Quest-link requirements can include a leading dash independently of
    -- QUEST_DASH. Keep that dash, quantity and native spacing unchanged.
    local quantity_prefix, required_item = text:match("^(%s*%-?%s*%d+%s+x%s+)(.+)$")
    if quantity_prefix and required_item then
        return finish(quantity_prefix .. entries.translate_quest_objective_task(
            required_item, quest_id, objective_source))
    end

    -- UIErrorsFrame receives "Task: N/N" without a quest ID. Resolve the
    -- complete task first (it can itself contain a colon), retaining counters
    -- and spacing exactly as the client supplied them.
    local progress_task, progress_suffix = text:match("^(.-)(:%s*%d[%d%.,]*%s*/%s*%d[%d%.,]*%s*)$")
    if progress_task and progress_task ~= "" then
        return finish(entries.translate_quest_objective_task(
            progress_task, quest_id, objective_source) .. progress_suffix)
    end

    -- ERR_QUEST_ADD_KILL_SII and QUEST_MONSTERS_KILLED share this suffix.
    -- A catalog task including "slain" already won above; otherwise resolve
    -- its target through the same task/item/NPC glossary route.
    local player_target = text:match("^(.+)%s+Players slain$")
    if player_target and type(quest_surface.player_kills_named) == "string" then
        return finish(string_format(quest_surface.player_kills_named,
            entries.translate_quest_objective_task(player_target, quest_id, objective_source)))
    end
    local slain_target = text:match("^(.+)%s+slain$")
    if slain_target and type(quest_surface.slain) == "string" then
        return finish(string_format(quest_surface.slain,
            entries.translate_quest_objective_task(slain_target, quest_id, objective_source)))
    end
    if type(objective_source) == "string"
        and text:lower() == objective_source:lower() then
        local objective = quest and quest[3]
        if type(objective) == "string" and objective ~= "" and objective ~= text then
            return finish(objective)
        end
    end

    -- Item names intentionally do not belong to the generic glossary. Use
    -- the build-local name index for item objectives on every quest surface.
    local item_db = addon_table.use("item_client_db")
    local item_name = item_db.ready and item_db.get_name_by_english(text)
    if type(item_name) == "string" and item_name ~= "" and item_name ~= text then
        return finish(utils.cap(item_name))
    end

    -- try parse "LEFT: RIGHT"
    local parts = { string_split(":", text, 2) }
    if #parts == 2 and #parts[1] > 0 then
        local found_left = entries.get_glossary_text(parts[1])
        if found_left then
            parts[1] = found_left
        elseif #parts[1] > 1 and parts[1]:sub(#parts[1], #parts[1]) == "s" then
            -- try plural => singular, e.g. "Kobold Workers" => "Kobold Worker"
            local found_singular = entries.get_glossary_text(parts[1]:sub(1, #parts[1] - 1))
            if found_singular then
                parts[1] = found_singular
            end
        end

        local found_right = entries.get_glossary_text(parts[2])
        if found_right then
            parts[2] = " " .. found_right
        end

        text = parts[1] .. ":" .. parts[2]
    else
        text = entries.get_glossary_text(text, text)
    end

    return finish(text)
end

-- Formats verified in GlobalStrings for the active Forever client. Keep this
-- gate shared with UIErrorsFrame so unrelated messages do not become quests.
entries.is_quest_progress_message = function (text)
    return text == "Objective Complete."
        or text:match("%s+%(Complete%)$") ~= nil
        or text:match("^.-:%s*%d[%d%.,]*%s*/%s*%d[%d%.,]*%s*$") ~= nil
        or text:match("^%d[%d%.,]*%s*/%s*%d[%d%.,]*%s+.+$") ~= nil
        or text:match("^.+%s+/%s+.+%s+.+$") ~= nil
end

entries.translate_taxi_node_name = function (text)
    -- try parse: "NAME1, NAME2"
    local key1, key2 = string_gmatch(text, "(.*), (.*)")()
    if key1 and key2 then
        local key1_text = entries.get_glossary_text(key1, key1, "zone")
        local key2_text = entries.get_glossary_text(key2, key2, "zone")
        text = string_format("%s, %s", key1_text, key2_text)
    else
        text = entries.get_glossary_text(text, text, "zone")
    end

    return text
end
