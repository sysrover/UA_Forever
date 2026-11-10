local _, addon_table = ...

local grammar = addon_table.use("ukrainian_grammar")
local UTF8_LETTER = "[%z\1-\127\194-\244][\128-\191]*"
local lowercase, uppercase = {}, {}
local case_rules

local function prepare_alphabet(rules)
    if case_rules == rules then return end
    lowercase, uppercase = {}, {}
    local lower_letters = {}
    for letter in rules.alphabet.lower:gmatch(UTF8_LETTER) do
        lower_letters[#lower_letters + 1] = letter
    end
    local index = 0
    for letter in rules.alphabet.upper:gmatch(UTF8_LETTER) do
        index = index + 1
        local lower = lower_letters[index]
        lowercase[letter], lowercase[lower] = lower, lower
        uppercase[letter], uppercase[lower] = letter, letter
    end
    case_rules = rules
end

local function lower(word)
    return (word:gsub(UTF8_LETTER, function (letter) return lowercase[letter] end))
end

local function upper(word)
    return (word:gsub(UTF8_LETTER, function (letter) return uppercase[letter] end))
end

local function replace_ending(word, ending, replacement)
    if word == upper(word) then replacement = upper(replacement) end
    return word:sub(1, #word - #ending) .. replacement
end

local function restore_case(word, form)
    if word == upper(word) then return upper(form) end
    if word:sub(1, 2) == upper(word:sub(1, 2)) then
        return upper(form:sub(1, 2)) .. form:sub(3)
    end
    return form
end

local function known_noun(word, rules)
    local entry = rules.nouns[lower(word)]
    if entry then return restore_case(word, entry[1]), entry[2] end
end

local function noun_genitive(word, rules)
    local form, gender = known_noun(word, rules)
    if form then return form, gender end
    local lower_word = lower(word)
    for _, rule in ipairs(rules.noun_endings) do
        local ending = rule[1]
        if #word > #ending and lower_word:sub(-#ending) == ending then
            return replace_ending(word, ending, rule[2]), rule[3]
        end
    end
    local last = lower_word:sub(-2)
    if rules.hard_consonants[last] then return replace_ending(word, "", "а"), "m" end
    -- A soft sign, plural ending or foreign vowel alone cannot reliably
    -- identify the declension. Let the caller choose a grammatical fallback.
end

local function adjective_genitive(word, gender, rules)
    local lower_word = lower(word)
    local endings = rules.adjective_endings[gender]
    for _, rule in ipairs(endings or {}) do
        if #word > #rule[1] and lower_word:sub(-#rule[1]) == rule[1] then
            return replace_ending(word, rule[1], rule[2])
        end
    end
end

-- Only nominative -> genitive place names. Other cases, personal names and
-- arbitrary prose require their own grammatical information.
-- Return nil rather than partially declining an unrecognized construction.
grammar.location_genitive = function (name)
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, name)
        if not ok or secret then return nil end
    end
    local rules = addon_table.zone_grammar
    if type(name) ~= "string" or name == "" or not rules then return nil end
    prepare_alphabet(rules)
    local explicit = rules.forms[name]
    if explicit then return explicit end

    local words = {}
    for word in name:gmatch("%S+") do
        -- Lua patterns operate on bytes. Validate UTF-8 letters individually;
        -- Cyrillic byte ranges in [...] would also match unrelated characters.
        for letter in word:gmatch(UTF8_LETTER) do
            if not lowercase[letter] and not rules.apostrophes[letter] then return nil end
        end
        words[#words + 1] = word
    end
    if #words == 0 then return nil end

    -- The first known head noun owns the phrase. Its following words are
    -- dependent names/genitives: "Бухта Наживи", "Каплиця Надії Світла".
    local head, genitive, gender
    for index, word in ipairs(words) do
        genitive, gender = known_noun(word, rules)
        if genitive then
            head = index
            break
        end
    end
    if not head then
        head = #words
        if head == 1 then
            local lower_name = lower(words[1])
            for _, rule in ipairs(rules.standalone_adjective_endings) do
                if #words[1] > #rule[1] and lower_name:sub(-#rule[1]) == rule[1] then
                    return replace_ending(words[1], rule[1], rule[2])
                end
            end
        end
        genitive, gender = noun_genitive(words[head], rules)
    end
    if not genitive then return nil end
    for index = 1, head - 1 do
        local adjective = adjective_genitive(words[index], gender, rules)
        if not adjective then return nil end
        words[index] = adjective
    end
    words[head] = genitive
    return table.concat(words, " ")
end
