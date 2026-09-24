local addon_name, addon_table = ...

local utils = addon_table.use("utils") ---@class utils_class

local math_floor            = _G.math.floor
local math_fmod             = _G.math.fmod
local string_byte           = _G.string.byte
local string_gmatch         = _G.string.gmatch
local string_split          = _G.string.split
local string_sub            = _G.string.sub
local string_trim           = _G.string.trim
local table_concat          = _G.table.concat
local C_ChatBubbles         = _G.C_ChatBubbles
local GetMouseFoci          = _G.GetMouseFoci
local GetMouseFocus         = _G.GetMouseFocus
local GetQuestID            = _G.GetQuestID
local GetQuestLogSelectedID = _G.GetQuestLogSelectedID
local UnitGUID              = _G.UnitGUID

utils.prepare = function ()
    local build_version, _, _, interface_version = GetBuildInfo()

    -- Forever uses a 1.60.x version number but the modern Mainline UI/API.
    -- Never infer Classic compatibility from the first version digit here.
    utils.is_forever = interface_version and interface_version >= 16000 and interface_version < 17000
    utils.is_classic = false
    utils.is_classic_sod = false
    utils.is_tbc = false
    utils.is_wrath = false
    utils.is_cata = false
    utils.is_mists = false
    utils.expansion_key = utils.is_forever and "forever" or "unsupported"
    utils.build_version = build_version
    utils.interface_version = interface_version
end

utils.addon_version = function ()
    local get_metadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    return get_metadata and get_metadata(addon_name, "Version") or "???"
end

-- implicitly does UpdateAddOnMemoryUsage() and returns value in kilobytes
utils.addon_mem_usage = function ()
    if UpdateAddOnMemoryUsage then UpdateAddOnMemoryUsage() end
    local get_mem_usage = C_AddOns and C_AddOns.GetAddOnMemoryUsage or GetAddOnMemoryUsage
    return get_mem_usage and get_mem_usage(addon_name) or 0
end

utils.dump = function (value)
    if type(_G.DevTools_Dump) == "function" then
        _G.DevTools_Dump(value)
    else
        print("[dump]", value)
    end
end

utils.copy_table = function (target, source)
    for k, v in pairs(source) do target[k] = v end
    return target
end

utils.copy_table_deep = function (target, source)
    for k, v in pairs(source) do
        target[k] = type(v) == "table" and utils.copy_table_deep({}, v) or v
    end
    return target
end

utils.table_string_keys = function (tbl)
    local result = {}
    for k, _ in pairs(tbl) do
        if type(k) == "string" then
            result[#result + 1] = k
        end
    end
    return result
end

utils.table_keys_count = function (tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

utils.table_sync_keys = function (target_table, blueprint_table)
    -- clean up unknown/deprecated keys
    for k, _ in pairs(target_table) do
        if blueprint_table[k] == nil then
            target_table[k] = nil
        end
    end

    -- add brand new keys with default values; a table default is copied, or the blueprint
    -- would end up sharing it with the saved variables
    for k, v in pairs(blueprint_table) do
        if target_table[k] == nil then
            target_table[k] = type(v) == "table" and utils.copy_table_deep({}, v) or v
        end
    end
end

utils.cap = function (text)
    local b1 = string_byte(text, 1)
    if not b1 then
        return text
    end

    if b1 >= 208 and b1 <= 210 then -- this is utf8 character, 2 bytes long
        local b2 = string_byte(text, 2)
        if b1 == 209 and b2 == 148 then
            return 'Є' .. text:sub(3)
        elseif b1 == 209 and b2 == 150 then
            return 'І' .. text:sub(3)
        elseif b1 == 209 and b2 == 151 then
            return 'Ї' .. text:sub(3)
        elseif b1 == 210 and b2 == 145 then
            return 'Ґ' .. text:sub(3)
        else -- run out of special cases -- let default upper() handle it
            return text:sub(1, 2):upper() .. text:sub(3)
        end
    else
        return text:sub(1, 1):upper() .. text:sub(2)
    end
end

utils.upper = function (str)
    return (str:upper():gsub("ї", "Ї"):gsub("є", "Є"):gsub("і", "І"):gsub("ґ", "Ґ"))
end

utils.lower = function (str)
    return (str:lower():gsub("Ї", "ї"):gsub("Є", "є"):gsub("І", "і"):gsub("Ґ", "ґ"))
end

utils.esc = function (x) -- https://stackoverflow.com/questions/9790688/escaping-strings-for-gsub
    return (x:gsub('%%', '%%%%')
             :gsub('^%^', '%%^')
             :gsub('%$$', '%%$')
             :gsub('%(', '%%(')
             :gsub('%)', '%%)')
             :gsub('%.', '%%.')
             :gsub('%[', '%%[')
             :gsub('%]', '%%]')
             :gsub('%*', '%%*')
             :gsub('%+', '%%+')
             :gsub('%-', '%%-')
             :gsub('%?', '%%?'))
end

-- [!] Any changes made to string_hash() func must be kept in sync with Python impl
utils.string_hash = function (text) -- https://wowwiki-archive.fandom.com/wiki/USERAPI_StringHash
    if type(text) ~= "string" or text == "" then
        return 0
    end

    local counter = 1
    local len = #text
    for i = 1, len, 3 do
        counter = math_fmod(counter * 8161, 4294967279) +
            (string_byte(text, i) * 16776193) +
            ((string_byte(text, i+1) or (len - i + 256)) * 8372226) +
            ((string_byte(text, i+2) or (len - i + 256)) * 3932164)
    end

    return math_fmod(counter, 4294967291)
end

utils.fix_float_number = function (value)
    local result = value:gsub(",", "")
    -- fix floating-point number without leading "0", e.g. ",2"
    if #result > 1 and result:sub(1, 1) == "," then
        result = "0" .. result
    end
    return result
end

utils.strip_color_codes = function (text)
    if type(text) == "string" then
        text = text:gsub("|c%x%x%x%x%x%x%x%x", "")
        text = text:gsub("|c%x%x%x%x%x%x %x", "")
        text = text:gsub("|r", "")
    end
    return text
end

utils.first_line_only = function (text)
    if type(text) == "string" then
        local lines = { string_split("\n\r", text) }
        local esc_nl_pos = lines[1]:find("|n")
        if esc_nl_pos then
            return lines[1]:sub(1, esc_nl_pos - 1)
        else
            return lines[1]
        end
    else
        return text
    end
end

utils.tooltip_lines = function (tooltip, is_right)
    local lines = {}
    if not tooltip then return lines end
    local count_ok, count = pcall(function () return tooltip:NumLines() end)
    local name_ok, name = pcall(function () return tooltip:GetName() end)
    local function secret(value)
        if type(_G.issecretvalue) ~= "function" then return false end
        local ok, result = pcall(_G.issecretvalue, value)
        return not ok or result == true
    end
    if not count_ok or secret(count) or type(count) ~= "number"
        or not name_ok or secret(name) or type(name) ~= "string" then
        return lines
    end
    for j = 1, math.min(math.floor(count), 100) do
        local region = _G[name .. (is_right and "TextRight" or "TextLeft") .. j]
        if region then
            local ok, value = pcall(function () return region:GetText() end)
            if ok and not secret(value) and type(value) == "string" then
                lines[#lines + 1] = value
            end
        end
    end
    return lines
end

utils.tooltip_title_line = function (tooltip)
    local num_lines = tooltip:NumLines()
    if num_lines == 0 then
        return ""
    end

    local text = _G[tooltip:GetName() .. "TextLeft1"]:GetText()

    -- check special case for item tooltip when showing currently equipped
    if text == CURRENTLY_EQUIPPED and num_lines > 1 then
        text = _G[tooltip:GetName() .. "TextLeft2"]:GetText()
    end

    return text
end

utils.item_id_from_link = function (item_link)
    if type(item_link) == "string" then
        local _, _, item_id = item_link:find("Hitem:(%d+):")
        if item_id then
            return tonumber(item_id)
        end
    end
end

utils.tooltip_item_id = function (tooltip)
    local _, item_link = tooltip:GetItem()
    return utils.item_id_from_link(item_link)
end

utils.tooltip_item_suffix_id = function (tooltip)
    local _, item_link = tooltip:GetItem()
    if item_link then
        local suffix_id = select(8, string_split(":", item_link))
        if suffix_id then
            return tonumber(suffix_id)
        end
    end
end

utils.chat_bubble_font_string_with_text = function (text)
    local function secret(value)
        if type(_G.issecretvalue) ~= "function" then return false end
        local ok, result = pcall(_G.issecretvalue, value)
        return not ok or result == true
    end
    if secret(text) or type(text) ~= "string" then return nil end
    local bubbles_api = _G.C_ChatBubbles
    if not bubbles_api or type(bubbles_api.GetAllChatBubbles) ~= "function" then
        return nil
    end
    local bubbles_ok, bubbles = pcall(bubbles_api.GetAllChatBubbles)
    if not bubbles_ok or secret(bubbles) or type(bubbles) ~= "table" then return nil end
    for _, bubble in pairs(bubbles) do
        local forbidden_ok, forbidden = pcall(function ()
            return bubble:IsForbidden()
        end)
        if forbidden_ok and not secret(forbidden) and not forbidden then
            local frame_ok, frame = pcall(function ()
                return bubble:GetChildren()
            end)
            if frame_ok and frame and not secret(frame) then
                local count_ok, count = pcall(function ()
                    return frame:GetNumRegions()
                end)
                if count_ok and not secret(count) and type(count) == "number" then
                    for i = 1, math.min(math.floor(count), 100) do
                        local region_ok, region = pcall(function ()
                            return select(i, frame:GetRegions())
                        end)
                        if region_ok and region and not secret(region) then
                            local kind_ok, kind = pcall(function ()
                                return region:GetObjectType()
                            end)
                            if kind_ok and not secret(kind) and kind == "FontString" then
                                local text_ok, current = pcall(function ()
                                    return region:GetText()
                                end)
                                if text_ok and not secret(current) and current == text then
                                    return region
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- unit_id is one of https://warcraft.wiki.gg/wiki/UnitId
utils.npc_id_from_unit_id = function (unit_id)
    local function secret(value)
        if type(_G.issecretvalue) ~= "function" then return false end
        local ok, result = pcall(_G.issecretvalue, value)
        return not ok or result == true
    end
    if type(unit_id) ~= "string" or secret(unit_id)
        or type(UnitGUID) ~= "function" then return nil end
    local ok, guid = pcall(UnitGUID, unit_id)
    if not ok or secret(guid) or type(guid) ~= "string" then return nil end
    local kind, _, _, _, _, id = string_split("-", guid)
    if id and not secret(id) and (kind == "Creature" or kind == "Vehicle") then
        return tonumber(id)
    end
end

-- returns 0 in case no quest (no npc quest and quest log is empty)
utils.get_currently_viewed_quest_id = function ()
    local npc_quest_id = GetQuestID()
    if npc_quest_id and npc_quest_id > 0 then
        return npc_quest_id
    end

    local questlog_quest_id = GetQuestLogSelectedID()
    if questlog_quest_id and questlog_quest_id > 0 then
        return questlog_quest_id
    end

    return 0
end

-- returns 0 in case no book (item text) is opened at the moment
utils.get_currently_viewed_book_id = function ()
    local meta = ItemTextFrame and ItemTextFrame.classicua or {}
    return meta.entry_type == "item" and meta.entry_id or 0
end

utils.mouse_hover_frame = function ()
    if GetMouseFocus then
        return GetMouseFocus()
    elseif GetMouseFoci then
        return GetMouseFoci()[1]
    end
end

utils.update_item_text_scrollbar = function ()
    local sf, sb = ItemTextScrollFrame, ItemTextScrollFrameScrollBar
    if not sf or not sb then return end

    sf.scrollBarHideable = false
    sf:GetScrollChild():SetHeight(1)
    sf:UpdateScrollChildRect()
    if math_floor(sf:GetVerticalScrollRange()) > 0 then
        sf:GetScrollChild():SetHeight(sf:GetHeight() + sf:GetVerticalScrollRange() + 30)
    end

    sb:SetValue(0)
end

utils.get_match_list_of_equal_meaning_english_texts_for_phrase = function (phrase)
    if type(phrase) ~= "string" or phrase == "" then
        return {}
    end

    -- input: "Bank" or "The bank" or "A bank." etc., all such cases will same output
    -- output: "bank", "a bank", "an bank", "the bank", "bank.", "a bank.", "an bank.", "the bank."
    -- note: "an bank" and "an bank." are incorrect, but will be returned (keep in mind)

    local phrase_lower = string_trim(phrase:lower())
    local phrase_lower_clean = phrase_lower

    -- remove ending "." if needed
    if phrase_lower_clean:find("%.$") then
        phrase_lower_clean = phrase_lower_clean:sub(1, #phrase_lower_clean - 1)
    end

    local known_prefixes = { "the ", "a ", "an " }

    -- extract "bank"
    for _, p in ipairs(known_prefixes) do
        if phrase_lower:find("^" .. p) then
            phrase_lower_clean = phrase_lower:sub(#p + 1)
            break
        end
    end

    -- generate all combinations
    local result = { phrase_lower_clean, phrase_lower_clean .. "." }
    for _, p in ipairs(known_prefixes) do
        result[#result + 1] = p .. phrase_lower_clean
        result[#result + 1] = p .. phrase_lower_clean .. "."
    end

    return result
end

-- [!] Any changes made to get_text_hash() func must be kept in sync with Python impl
utils.get_text_hash = function (text)
    if type(text) ~= "string" then
        return 0
    end
    -- Replacing multiple NBSPs and spaces with single space
    text = string_trim(utils.lower(text:gsub("\194\160", " "):gsub(" +", " ")))
    return utils.string_hash(text)
end

-- [!] Must be kept in sync with values in utils.py
local known_gossip_dynamic_seq_with_multiple_words_for_get_text_code = {
    {"night elf", "nightelf"},
    -- These exist as creature/NPC names in the base-world data; they are not
    -- declarations of playable expansion races/classes.
    {"blood elf", "bloodelf"},
    {"death knight", "deathknight"},
}
local MAX_TEXT_CODE_LENGTH = 42

-- [!] Any changes made to get_text_code() func must be kept in sync with Python impl in utils.py
utils.get_text_code = function (text)
    local text_low_case = text:lower()
    local seq_pairs = known_gossip_dynamic_seq_with_multiple_words_for_get_text_code
    for i = 1, #seq_pairs do
        text_low_case = text_low_case:gsub(seq_pairs[i][1], seq_pairs[i][2])
    end
    local result = {}
    for word in string_gmatch(text_low_case, [===[%w[%w%-']*%w]===]) do
        if #word > 0 then
            result[#result+1] = word:sub(1, 1)
            result[#result+1] = word:sub(-1)
        end
    end

    return table_concat(result)
end

utils.match_text_code = function (code, candidates)
    for _, candidate in ipairs(candidates) do
        -- If #code == MAX_TEXT_CODE_LENGTH - we do prefix match, as code may have been stripped
        -- If #code < MAX_TEXT_CODE_LENGTH  - we do exact match, as code is full
        if #candidate == MAX_TEXT_CODE_LENGTH and code:match('^' .. candidate .. '.*$') then
            return candidate
        else
            if #candidate < MAX_TEXT_CODE_LENGTH and code:match('^' .. candidate .. '$') then
                return candidate
            end
        end
    end
    return false
end
