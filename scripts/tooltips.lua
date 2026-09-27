local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local auto_scan = addon_table.use("auto_scan")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local strings = addon_table.use("strings")
local layout = addon_table.use("translation_layout")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local scheduler = addon_table.use("translation_scheduler")
local tooltip_session = addon_table.use("tooltip_session")
local item_adapter = addon_table.use("tooltip_item_adapter")
local npc_adapter = addon_table.use("tooltip_npc_adapter")
local quest_adapter = addon_table.use("tooltip_quest_adapter")
local map_adapter = addon_table.use("tooltip_map_adapter")
local spell_adapter = addon_table.use("tooltip_spell_adapter")
local talent_adapter = addon_table.use("tooltip_talent_adapter")
local hooks = addon_table.use("translation_hooks").bind("tooltips")
local tooltips = addon_table.use("tooltips")
local utils = addon_table.use("utils")
local tooltip_catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local tooltip_format = tooltip_catalog.format
local tooltip_line
local visible_tooltip_font_strings
local visible_spell_id
local player_aura_spell_id
local translate_object_tooltip_title
local after_aura_tooltip_rendered
local MAX_TOOLTIP_LINES = 40
local tooltip_font_strings = setmetatable({}, { __mode = "k" })
local character_stat_line_heights = setmetatable({}, { __mode = "k" })
local active_tooltips = tooltip_session.active
local tooltip_events = setmetatable({}, { __mode = "k" })
local DEFAULT_UPDATE_BUDGET = 12
local arm_minimap_watcher = function () end

local function arm_tooltip_updates(tooltip, budget)
    if not tooltip then return end
    local requested = budget or DEFAULT_UPDATE_BUDGET
    tooltip.uaForeverUpdateBudget = math.max(
        tooltip.uaForeverUpdateBudget or 0, requested)
end

local function note_tooltip_event(tooltip, event)
    local counts = tooltip_events[tooltip] or {}
    counts[event] = (counts[event] or 0) + 1
    tooltip_events[tooltip] = counts
end

local function shift_held()
    return options.account and options.account.shift_original_tooltip ~= false
        and type(_G.IsShiftKeyDown) == "function" and _G.IsShiftKeyDown()
end

local function begin_tooltip(tooltip, key)
    local started = tooltip_session.begin(tooltip, key,
        shift_held() or not options.can_translate(), function (region)
        character_stat_line_heights[region] = nil
    end)
    if not started then return end
    arm_tooltip_updates(tooltip)
    tooltip_font_strings[tooltip] = nil
end

local is_secret = runtime.is_secret_value
local safe_string = runtime.safe_string_or_nil

local function safe_number(value)
    if is_secret(value) or value == nil then return nil end
    local ok, result = pcall(tonumber, value)
    if ok then return result end
end

local function first_template_part(text)
    if type(text) ~= "string" then return text end
    return text:match("^(.-)#") or text
end

local function resolve_item_placeholders(text)
    if type(text) ~= "string" or not text:find("{bindLocation}", 1, true) then
        return text
    end
    if type(_G.GetBindLocation) ~= "function" then return text end

    local ok, bind_location = pcall(_G.GetBindLocation)
    bind_location = ok and safe_string(bind_location) or nil
    if not bind_location then return text end

    local translated_location = addon_table.zone
        and addon_table.zone[bind_location] or bind_location
    return text:gsub("{bindLocation}", function () return translated_location end)
end

local function make_text(text, tooltip, source_line)
    if type(text) ~= "string" then
        return nil
    end

    local ok, result = pcall(entries.make_entry_text, text, tooltip, nil, source_line)
    result = ok and result or first_template_part(text)
    result = resolve_item_placeholders(result)
    if type(result) ~= "string" or result:find("{%d+}") then
        return nil
    end
    return utils.cap(result)
end

local function normalized_tooltip_text(text)
    text = safe_string(text)
    if not text then return nil end
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function item_name_visible_matches(visible, expected)
    if visible == expected then return true end
    if type(visible) ~= "string" or type(expected) ~= "string"
        or visible:sub(1, #expected) ~= expected then return false end
    return visible:sub(#expected + 1):match("^ %([^()]+%)$") ~= nil
end

local function set_tooltip_translation(tooltip, region, source, translated, slot, category, owner, source_kind, allow_fallback, adjust_layout, after_visibility, visible_matcher, catalog_source)
    local source_unsafe = is_secret(source)
    translated = safe_string(translated)
    source = safe_string(source)
    if not tooltip or not translated then return false end
    if source and translated == source then return false end
    if not options.can_translate() then return false end
    slot = slot or "generic.text"
    local name_enabled = not category or not slot:match("%.name$")
        or options.translate_name(category)
    if not name_enabled then
        if region then
            if runtime.get(region) then
                runtime.show_original(region, true)
            else
                runtime.restore_source(region, source)
            end
        end
        return false
    end
    local priority = owner == "generic" and runtime.priority_for_source(source_kind)
        or runtime.PRIORITY.DOMAIN
    local option = owner == "item-tooltip" and "translate_item"
        or owner == "spell-tooltip" and "translate_spell"
        or owner == "quest-tooltip" and "translate_quest"
        or owner == "object-tooltip" and "translate_other_tooltips"
        or owner == "cursor-tooltip" and "translate_other_tooltips"
        or owner == "zone-tooltip" and "translate_zone" or nil
    local domain_options = owner == "npc-tooltip"
        and { "translate_npc", "translate_npc_tooltip" } or nil
    local combat_tooltip_text = false
    if (tooltip.uaForeverKind == "npc" or tooltip.uaForeverKind == "player"
            or tooltip.uaForeverKind == "item" or tooltip.uaForeverKind == "spell")
        and type(_G.InCombatLockdown) == "function" then
        local ok, in_combat = pcall(_G.InCombatLockdown)
        combat_tooltip_text = ok and not is_secret(in_combat)
            and in_combat == true
    end
    if region and not options.is_bilingual_tooltip() then
        local previous_height, previous_tooltip_height
        if adjust_layout ~= false and not combat_tooltip_text then
            previous_height = layout.safe_dimension(region, "GetStringHeight")
                or layout.safe_dimension(region, "GetHeight")
            previous_tooltip_height = previous_height
                and layout.safe_dimension(tooltip, "GetHeight") or nil
        end
        local visibility_callback = after_visibility
        if source == "<Click to view Quest Details>" then
            visibility_callback = function (visible_region)
                if tooltip.uaForeverShowOriginal then
                    layout.restore_tooltip_width(tooltip)
                else
                    layout.fit_tooltip_width_to_region(tooltip, visible_region, source)
                end
                if after_visibility then pcall(after_visibility, visible_region) end
            end
        end
        local ok = runtime.apply(region, {
            owner = owner or "tooltip", slot = slot, source = source,
            translated = translated, priority = priority, category = category,
            option = option, options = domain_options,
            generation = tooltip.uaForeverGeneration, tooltip = tooltip,
            surface = tooltip, instance = tooltip.uaForeverSessionKey,
            phase = "dynamic",
            lookup_tier = source_kind or (category and "domain")
                or "tooltip-adapter",
            catalog_source = catalog_source,
            allow_unknown_source = true,
            source_unsafe = source_unsafe,
            unsafe_context = "tooltip:" .. (owner or "generic"),
            combat_tooltip_text = combat_tooltip_text,
            after_apply = function (applied)
                if adjust_layout ~= false and not combat_tooltip_text then
                    layout.fit_tooltip_width_to_region(tooltip, applied, source)
                    layout.fit_tooltip_height_to_region(tooltip, applied,
                        previous_height, previous_tooltip_height)
                    layout.fit_bag_tooltip_width(tooltip, applied, source)
                end
            end,
            after_visibility = visibility_callback,
            visible_matches = visible_matcher,
        })
        if ok then
            local fallback = tooltip.uaForeverFallback and tooltip.uaForeverFallback[slot]
            if fallback and fallback.region then
                runtime.set_fallback_text(fallback.region, "")
            end
            return true
        end
    end

    if allow_fallback == false then return false end

    -- A rejected generic write must not reappear as an addon-owned line when
    -- a domain or context handler already owns this FontString.
    local existing = region and runtime.get(region)
    if existing and (existing.priority > priority
        or existing.priority == priority and existing.owner ~= (owner or "tooltip")) then
        return false
    end

    if tooltip.uaForeverShowOriginal or not name_enabled then return false end
    if region and options.is_bilingual_tooltip() then
        runtime.show_original(region, true)
    end

    -- Aura FontStrings can be protected even when the tooltip exposes a
    -- public spell ID. If in-place replacement is rejected, append an
    -- addon-owned line so the Ukrainian translation remains visible. A
    -- secret source is deliberately neither compared nor included in the key.
    local key = slot
    tooltip.uaForeverBilingualLines = tooltip.uaForeverBilingualLines or {}
    if tooltip.uaForeverBilingualLines[key] then
        local fallback = tooltip.uaForeverFallback[key]
        if fallback and fallback.region then
            runtime.set_fallback_text(fallback.region, translated)
        end
        return true
    end

    local r, g, b = 1, 1, 1
    if region and type(region.GetTextColor) == "function" then
        local ok_color, red, green, blue = pcall(region.GetTextColor, region)
        if ok_color and not is_secret(red) and not is_secret(green) and not is_secret(blue)
            and type(red) == "number" and type(green) == "number" and type(blue) == "number" then
            r, g, b = red, green, blue
        end
    end

    local before = {}
    for _, existing in ipairs(visible_tooltip_font_strings(tooltip)) do
        before[existing] = true
    end
    local ok = runtime.add_fallback(tooltip, translated, r, g, b)
    if ok then
        tooltip.uaForeverBilingualLines[key] = true
        tooltip_font_strings[tooltip] = nil
        local fallback_region
        for _, candidate in ipairs(visible_tooltip_font_strings(tooltip)) do
            if not before[candidate] then fallback_region = candidate end
        end
        local count_ok, count = pcall(tooltip.NumLines, tooltip)
        if not fallback_region and count_ok and safe_number(count) then
            local _, found = tooltip_line(tooltip, "Left", count)
            fallback_region = found
        end
        tooltip.uaForeverFallback[key] = {
            region = fallback_region, translated = translated,
            category = category, slot = slot,
            option = option, options = domain_options,
            force = not options.is_bilingual_tooltip(),
        }
    end
    return ok
end

tooltips.translate_profession_recipe = function (tooltip, english)
    english = safe_string(english)
    if not tooltip or not english then return end
    local source, region = tooltip_line(tooltip, "Left", 1)
    if not region or source ~= english then return end
    local translated = entries.lookup_name("spell", english)
        or entries.lookup_name("item", english)
    if not translated then return end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    tooltip.uaForeverReservedFirst = 2
    set_tooltip_translation(tooltip, region, source, utils.cap(translated),
        "skill.name", "skill", "spell-tooltip")
end

local function rewrite_generic_lines(tooltip, line_count, first_index, allow_fallback, adjust_layout)
    line_count = safe_number(line_count)
    if not line_count then
        local ok_count, value = pcall(tooltip.NumLines, tooltip)
        line_count = ok_count and safe_number(value) or nil
    end
    -- Forever can mark NumLines() as secret even when individual rendered
    -- FontStrings remain readable. A fixed upper bound avoids comparing or
    -- iterating with the protected value while still reaching those regions.
    line_count = line_count or MAX_TOOLTIP_LINES
    local applied = 0

    for index = first_index or 1, line_count do
        local left, left_region = tooltip_line(tooltip, "Left", index)
        local right, right_region = tooltip_line(tooltip, "Right", index)
        local translated_left, _, left_kind, _, _, _, left_provenance =
            strings.find_ui_translation(left, left_region)
        local translated_right, _, right_kind, _, _, _, right_provenance =
            strings.find_ui_translation(right, right_region)
        if translated_left and translated_left ~= left then
            if set_tooltip_translation(tooltip, left_region, left, translated_left,
                "generic.left:" .. index, nil, "generic", left_kind,
                allow_fallback, adjust_layout, nil, nil,
                left_provenance and left_provenance.source) then
                applied = applied + 1
            end
        end
        if translated_right and translated_right ~= right then
            if set_tooltip_translation(tooltip, right_region, right, translated_right,
                "generic.right:" .. index, nil, "generic", right_kind,
                allow_fallback, adjust_layout, nil, nil,
                right_provenance and right_provenance.source) then
                applied = applied + 1
            end
        end
    end
    return applied
end

spell_adapter.configure({
    safe_number = safe_number,
    safe_string = safe_string,
    normalized_text = normalized_tooltip_text,
    make_text = make_text,
    tooltip_line = function (...) return tooltip_line(...) end,
    visible_font_strings = function (...)
        return visible_tooltip_font_strings(...)
    end,
    set_translation = set_tooltip_translation,
    rewrite_generic = rewrite_generic_lines,
    max_lines = MAX_TOOLTIP_LINES,
})

item_adapter.configure({
    safe_number = safe_number,
    normalized_text = normalized_tooltip_text,
    make_text = make_text,
    tooltip_line = function (...) return tooltip_line(...) end,
    set_translation = set_tooltip_translation,
    item_name_visible_matches = item_name_visible_matches,
    rewrite_generic = rewrite_generic_lines,
    max_lines = MAX_TOOLTIP_LINES,
})

npc_adapter.configure({
    safe_string = safe_string,
    tooltip_line = function (...) return tooltip_line(...) end,
    begin_tooltip = begin_tooltip,
    set_translation = set_tooltip_translation,
    rewrite_generic = rewrite_generic_lines,
})

local function id_from_guid(guid, allow_object)
    guid = safe_string(guid)
    if not guid then return nil end
    local kind, _, _, _, _, id = strsplit("-", guid)
    if kind == "Creature" or kind == "Vehicle" or (allow_object and kind == "GameObject") then
        return tonumber(id)
    end
end

local function tooltip_key(kind, id)
    return kind .. ":" .. tostring(id)
end

local player_race_keys = {
    Human = "human", Dwarf = "dwarf", NightElf = "nightelf",
    Gnome = "gnome", Orc = "orc", Troll = "troll",
    Scourge = "scourge", Undead = "undead", Tauren = "tauren",
}

local function translate_player_tooltip_identity(tooltip)
    if not tooltip or tooltip.uaForeverShowOriginal then return false end
    local source, region, level, native_race, line_index
    for index = 2, 6 do
        local visible, candidate = tooltip_line(tooltip, "Left", index)
        visible = candidate and safe_string(visible) or nil
        if candidate and visible then
            local claim = runtime.get(candidate)
            local candidate_source = claim and claim.source or visible
            local normalized = normalized_tooltip_text(candidate_source)
            local found_level, found_race
            if normalized then
                found_level, found_race = normalized:match(
                    "^Level ([^ ]+) (.-) %(Player%)$")
            end
            if found_level and found_race then
                source, region = candidate_source, candidate
                level, native_race, line_index = found_level, found_race, index
                break
            end
        end
    end
    if not level or not native_race then return false end
    tooltip.uaForeverReservedFirst = line_index

    local unit
    if type(tooltip.GetUnit) == "function" then
        local unit_ok, _, value = pcall(tooltip.GetUnit, tooltip)
        unit = unit_ok and safe_string(value) or nil
    end

    local race_key
    if unit and type(_G.UnitRace) == "function" then
        local race_ok, _, race_file = pcall(_G.UnitRace, unit)
        race_file = race_ok and safe_string(race_file) or nil
        if race_file then
            race_key = player_race_keys[race_file]
                or race_file:lower():gsub(" ", "")
        end
    end
    if not race_key then
        race_key = player_race_keys[native_race]
            or native_race:lower():gsub(" ", "")
    end

    local sex = 1
    if unit and type(_G.UnitSex) == "function" then
        local sex_ok, value = pcall(_G.UnitSex, unit)
        if sex_ok and not is_secret(value) and value == 3 then sex = 2 end
    end
    local forms = addon_table.race and addon_table.race[race_key]
    local nominative = forms and forms["н"]
    local translated_race = nominative
        and (nominative.neutral_singular or nominative[sex] or nominative[1])
    if type(translated_race) ~= "string" then return false, line_index end

    return set_tooltip_translation(tooltip, region, source,
        tooltip_format.player_identity(level, utils.cap(translated_race)),
        "player.identity:" .. line_index, nil, "player-tooltip", nil, false), line_index
end

local function translate_player_unit_tooltip(tooltip)
    if not tooltip or type(tooltip.GetUnit) ~= "function"
        or type(_G.UnitIsPlayer) ~= "function" then return false end
    local unit_ok, unit_name, unit = pcall(tooltip.GetUnit, tooltip)
    unit = unit_ok and safe_string(unit) or nil
    if not unit then return false end
    local player_ok, is_player = pcall(_G.UnitIsPlayer, unit)
    if not player_ok or is_secret(is_player) or is_player ~= true then return false end

    local session_name = safe_string(unit_name) or unit
    local key = "player-unit:" .. unit .. ":" .. session_name
    begin_tooltip(tooltip, key)
    tooltip.uaForeverKind = "player"
    local translated, identity_line = translate_player_tooltip_identity(tooltip)
    translated = rewrite_generic_lines(tooltip, nil, identity_line or 2) > 0
        or translated
    if translated then tooltip.uaForeverKey = key end
    return translated
end

local function process(tooltip, data, kind)
    if not tooltip or is_secret(data) or not data then return end

    local id
    if kind == "npc" then
        id = safe_number(data.uaForeverID) or id_from_guid(data.guid)
        if not id and tooltip.GetUnit then
            local unit_ok, _, unit = pcall(tooltip.GetUnit, tooltip)
            unit = unit_ok and safe_string(unit) or nil
            id = unit and utils.npc_id_from_unit_id(unit)
        end
    elseif kind == "object" then
        id = safe_number(data.uaForeverID) or id_from_guid(data.guid, true) or safe_number(data.id)
    elseif kind == "aura" then
        -- Camelot exposes secret aura values in combat. Only use a public
        -- numeric spell ID; never compare, format, or cache a secret value.
        id = safe_number(data.spellID)
        if not id then id = visible_spell_id(tooltip) end
        if not id then id = player_aura_spell_id(tooltip) end
        -- Some builds expose the spell directly as data.id; keep that as the
        -- last fallback because other builds use id for the aura instance.
        if not id then id = safe_number(data.id) end
    else
        id = safe_number(data.id) or safe_number(data.itemID)
            or safe_number(data.spellID) or safe_number(data.questID)
    end
    -- Player GUIDs have no NPC entry. Translate their rendered unit tooltip
    -- during the Unit post-call so a frequently refreshed player frame does
    -- not alternate between native and deferred translated text.
    local public_guid = safe_string(data.guid)
    if kind == "npc" and not id and public_guid
        and public_guid:match("^Player%-") then
        begin_tooltip(tooltip, "player:" .. public_guid)
        tooltip.uaForeverKind = "player"
        local translated, identity_line = translate_player_tooltip_identity(tooltip)
        translated = rewrite_generic_lines(tooltip, nil, identity_line or 2) > 0
            or translated
        if translated then tooltip.uaForeverKey = "player:" .. public_guid end
        return translated
    end
    if not id then
        if kind == "object" then
            if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
            tooltip.uaForeverKind = "object"
            return translate_object_tooltip_title(tooltip)
        end
        return
    end

    local key = tooltip_key(kind, id)
    begin_tooltip(tooltip, key)
    tooltip.uaForeverKind = kind
    tooltip.uaForeverID = id
    local translated = false
    if kind == "item" then
        translated = item_adapter.add(tooltip, id)
    elseif kind == "spell" then
        translated = spell_adapter.add(tooltip, id, false)
    elseif kind == "aura" then
        translated = spell_adapter.add(tooltip, id, true)
    elseif kind == "npc" then
        translated = npc_adapter.add(tooltip, id)
        translated = quest_adapter.translate_embedded(tooltip) or translated
    elseif kind == "quest" then
        local entry = entries.get_entry("quest", id)
        dev_log.record_id("quests", id, data.title, entry ~= nil)
        translated = quest_adapter.add(tooltip, id, data.uaForeverSkipTitle)
    elseif kind == "object" then
        dev_log.record_id("objects", id, data.name, false)
        translated = translate_object_tooltip_title(tooltip)
    end
    if translated then tooltip.uaForeverKey = key end
    if options.account and options.account.auto_scan_content
        and (kind == "item" or kind == "spell" or kind == "aura") then
        local missing_entry = not entries.get_entry(
            kind == "item" and "item" or "spell", id)
        local capture_id = id
        if kind == "aura" and data.uaForeverCaptureByTitle == true then
            capture_id = nil
        end
        if missing_entry or kind == "aura" then
            auto_scan.capture_tooltip(tooltip, kind, capture_id, missing_entry)
        end
        local generation = tooltip.uaForeverGeneration
        scheduler.request("auto-tooltip:" .. tostring(tooltip), generation, function ()
            local ok, shown = pcall(tooltip.IsShown, tooltip)
            if ok and shown and tooltip.uaForeverGeneration == generation then
                auto_scan.capture_tooltip(tooltip, kind, capture_id, missing_entry)
            end
        end, 0.15, tooltip)
    end
    return translated
end

local function safe_process(tooltip, data, kind)
    local ok, result = pcall(process, tooltip, data, kind)
    if not ok then
        dev_log.issue("Forever tooltip " .. tostring(kind), tostring(result))
        return false
    end
    return result == true
end

visible_spell_id = function (tooltip)
    if not tooltip then return nil end
    if type(tooltip.GetSpell) == "function" then
        local ok, _, second, third = pcall(tooltip.GetSpell, tooltip)
        if ok then
            local id = safe_number(third) or safe_number(second)
            if id then return id end
        end
    end
    if type(tooltip.GetHyperlink) == "function" then
        local ok, link = pcall(tooltip.GetHyperlink, tooltip)
        link = ok and safe_string(link) or nil
        local id = link and (link:match("^spell:(%d+)")
            or link:match("^enchant:(%d+)"))
        id = safe_number(id)
        if id then return id end
    end
    return nil
end

quest_adapter.configure({
    safe_number = safe_number,
    safe_string = safe_string,
    normalized_text = normalized_tooltip_text,
    make_text = make_text,
    tooltip_line = function (...) return tooltip_line(...) end,
    set_translation = set_tooltip_translation,
    rewrite_generic = rewrite_generic_lines,
    process = safe_process,
    max_lines = MAX_TOOLTIP_LINES,
})

tooltips.refresh_quest_reward = function (tooltip, button, force)
    if not tooltip or not button or button.objectType ~= "item"
        or type(button.GetID) ~= "function" then return end
    local quest_frame = _G.QuestInfoFrame
    local getter = quest_frame and quest_frame.questLog
        and _G.GetQuestLogItemLink or _G.GetQuestItemLink
    if type(getter) ~= "function" then return end
    local index_ok, index = pcall(button.GetID, button)
    if not index_ok or not safe_number(index) then return end
    local link_ok, link = pcall(getter, button.type, index)
    link = link_ok and safe_string(link) or nil
    if not link then return end
    local id = safe_number(utils.item_id_from_link(link))
    local entry = id and entries.get_entry("item", id)
    if not entry then return end
    local source = tooltip_line(tooltip, "Left", 1)
    if not force and source ~= entry.en then return end
    safe_process(tooltip, { itemID = id }, "item")
end

talent_adapter.configure({
    safe_number = safe_number,
    safe_string = safe_string,
    normalized_text = normalized_tooltip_text,
    make_text = make_text,
    tooltip_line = function (...) return tooltip_line(...) end,
    begin_tooltip = begin_tooltip,
    set_translation = set_tooltip_translation,
    rewrite_generic = rewrite_generic_lines,
    max_lines = MAX_TOOLTIP_LINES,
})

map_adapter.configure({
    safe_string = safe_string,
    is_secret = is_secret,
    make_text = make_text,
    tooltip_line = function (...) return tooltip_line(...) end,
    begin_tooltip = begin_tooltip,
    set_translation = set_tooltip_translation,
})

local function frame_under_minimap(owner)
    for _ = 1, 8 do
        if not owner then break end
        if owner == _G.Minimap or owner == _G.MinimapCluster then return true end
        local parent_ok, parent = pcall(function ()
            return type(owner.GetParent) == "function" and owner:GetParent() or nil
        end)
        if not parent_ok or parent == owner then break end
        owner = parent
    end
    return false
end

local function minimap_tooltip_owner(tooltip)
    if tooltip ~= _G.GameTooltip then return false end
    if type(tooltip.GetOwner) == "function" then
        local ok, owner = pcall(tooltip.GetOwner, tooltip)
        if ok and not is_secret(owner) and frame_under_minimap(owner) then
            return true
        end
    end
    local focus
    if type(_G.GetMouseFocus) == "function" then
        local ok, value = pcall(_G.GetMouseFocus)
        if ok and not is_secret(value) then focus = value end
    end
    if not focus and type(_G.GetMouseFoci) == "function" then
        local ok, values = pcall(_G.GetMouseFoci)
        if ok and not is_secret(values) and type(values) == "table"
            and not is_secret(values[1]) then
            focus = values[1]
        end
    end
    return frame_under_minimap(focus)
end

local function tooltip_title_parts(source)
    local prefix, title = "", source
    while type(title) == "string" do
        local texture = title:match("^(|T.-|t)")
        if not texture then break end
        prefix = prefix .. texture
        title = title:sub(#texture + 1)
    end
    return prefix, title
end

local function world_cursor_owner(tooltip)
    if not tooltip or type(tooltip.GetOwner) ~= "function" then return false end
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    return ok and not is_secret(owner)
        and (owner == _G.UIParent or owner == _G.WorldFrame)
end

local function public_frame_name(frame)
    if not frame or is_secret(frame) then return nil end
    for _, method in ipairs({ "GetDebugName", "GetName" }) do
        local ok_method, callback = pcall(function () return frame[method] end)
        if ok_method and type(callback) == "function" then
            local ok, value = pcall(callback, frame)
            value = ok and safe_string(value) or nil
            if value then return value end
        end
    end
end

-- Aura tooltips are also reported as TooltipDataType.Spell. The rendered
-- owner is the stable discriminator: player buffs are buttons below
-- BuffFrame.AuraContainer, while unit-frame auras live below an Auras
-- container. Keep this classification for the complete tooltip generation so
-- deferred generic passes cannot demote the aura back to an ordinary spell.
local function aura_tooltip_context(tooltip)
    if not tooltip or is_secret(tooltip) then return nil end
    local marked = tooltip.uaForeverAuraTooltip == true
    local marked_unit = marked and tooltip.uaForeverAuraUnit or nil
    if marked_unit and marked_unit ~= "unknown" then
        return marked_unit
    end
    if type(tooltip.GetOwner) ~= "function" then
        return marked and "unknown" or nil
    end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or not owner or is_secret(owner) then
        return marked and "unknown" or nil
    end
    for _ = 1, 10 do
        local name = public_frame_name(owner)
        if owner == _G.BuffFrame or owner == _G.DebuffFrame
            or name and (name:find("BuffFrame", 1, true)
                or name:find("DebuffFrame", 1, true)) then
            return "player"
        end
        if name and (name:find(".AuraContainer", 1, true)
            or name:find(".Auras", 1, true)) then
            return "unit"
        end
        if type(owner.GetParent) ~= "function" then break end
        local parent_ok, parent = pcall(owner.GetParent, owner)
        if not parent_ok or not parent or parent == owner or is_secret(parent) then
            break
        end
        owner = parent
    end
    return marked and "unknown" or nil
end

local function mark_aura_tooltip(tooltip)
    local context = aura_tooltip_context(tooltip) or "unknown"
    tooltip.uaForeverAuraTooltip = true
    tooltip.uaForeverAuraUnit = context
    return context
end

player_aura_spell_id = function (tooltip)
    if aura_tooltip_context(tooltip) ~= "player" then return nil end
    local title, region = tooltip_line(tooltip, "Left", 1)
    local claim = region and runtime.get(region)
    title = normalized_tooltip_text(claim and claim.source or title)
    if not title then return nil end

    local unit_auras = _G.C_UnitAuras
    local get_by_index = unit_auras and unit_auras.GetAuraDataByIndex
    if type(get_by_index) ~= "function" then return nil end
    local matched_id
    for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
        for index = 1, 40 do
            local aura_ok, aura = pcall(get_by_index, "player", index, filter)
            if not aura_ok or not aura or is_secret(aura) then break end
            local fields_ok, name, spell_id = pcall(function ()
                return aura.name, aura.spellId
            end)
            name = fields_ok and normalized_tooltip_text(name) or nil
            spell_id = fields_ok and safe_number(spell_id) or nil
            if name == title and spell_id then
                if matched_id and matched_id ~= spell_id then return nil end
                matched_id = spell_id
            end
        end
    end
    return matched_id
end

local function capture_world_tooltip(tooltip, line_count)
    if tooltip ~= _G.GameTooltip or not options.account
        or not options.account.auto_scan_content then return end
    if tooltip.uaForeverKind ~= "object" then
        if line_count ~= 1 or minimap_tooltip_owner(tooltip)
            or not world_cursor_owner(tooltip) then return end
    end
    local visible, region = tooltip_line(tooltip, "Left", 1)
    local claim = region and runtime.get(region)
    if claim and claim.owner ~= "object-tooltip"
        and claim.owner ~= "zone-tooltip" then return end
    local source = claim and claim.source or visible
    source = safe_string(source)
    visible = safe_string(visible)
    if not source or not visible then return end
    local _, title = tooltip_title_parts(source)
    local _, shown_title = tooltip_title_parts(visible)
    auto_scan.record_world_tooltip(title, shown_title, {
        owner = claim and claim.owner or "object-tooltip",
        slot = claim and claim.slot or "object.name",
        surface = "GameTooltip",
    })
end

translate_object_tooltip_title = function (tooltip)
    if not tooltip or tooltip.uaForeverShowOriginal then return false end
    if tooltip.uaForeverKind ~= "object" and not minimap_tooltip_owner(tooltip) then
        return false
    end
    local source, region = tooltip_line(tooltip, "Left", 1)
    source = safe_string(source)
    if not region or not source then return false end
    local prefix, title = tooltip_title_parts(source)
    local translated = addon_table.translate_object_name
        and addon_table.translate_object_name(title)
    local slot, owner = "object.name", "object-tooltip"
    if translated then
        if not options.can_translate("translate_other_tooltips") then return false end
    else
        translated = addon_table.zone and addon_table.zone[title]
        if not translated or not options.can_translate("translate_zone") then
            return false
        end
        slot, owner = "zone.name", "zone-tooltip"
    end
    if type(translated) ~= "string" or translated == source then return false end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    local applied = set_tooltip_translation(tooltip, region, source,
        prefix .. utils.cap(translated), slot, nil, owner)
    if applied then tooltip.uaForeverReservedFirst = 2 end
    return applied
end

local function prepare_quest_map_hook()
    hooks.global("GameTooltip_AddQuest", function (self)
            local id = self and self.questID
            if type(id) == "number" then
                safe_process(_G.GameTooltip, { id = id }, "quest")
            end
        end)
    hooks.global("QuestMapLogTitleButton_OnEnter",
        quest_adapter.translate_map_button)
    hooks.region(_G.QuestPinMixin, "OnMouseEnter", function (self)
            local get_id = self and self.GetQuestID
            if type(get_id) ~= "function" then return end
            local id_ok, id = pcall(get_id, self)
            id = id_ok and safe_number(id) or nil
            if id then
                safe_process(_G.GameTooltip, { id = id }, "quest")
            end
        end)
    hooks.region(_G.QuestBlobPinMixin, "UpdateTooltip", function (self)
            local tooltip = _G.GameTooltip
            if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
            local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
            if not owner_ok or owner ~= self then return end
            local shown_title = tooltip_line(tooltip, "Left", 1)
            shown_title = safe_string(shown_title)
            if not shown_title then return end
            local current_getter = _G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID
            if type(current_getter) ~= "function" then return end
            local original_getter = translation.original
                and translation.original["C_QuestLog.GetTitleForQuestID"]
            local candidates = {}
            local function add_candidate(id)
                if not is_secret(id) and type(id) == "number" and id > 0 then
                    candidates[#candidates + 1] = id
                end
            end
            add_candidate(self.questID)
            add_candidate(self.focusedQuestID)
            add_candidate(self.highlightedQuestID)
            add_candidate(self.highlightedQuestPOI)
            local highlight = _G.POIButtonHighlightManager
            if highlight and type(highlight.GetQuestID) == "function" then
                local id_ok, id = pcall(highlight.GetQuestID, highlight)
                if id_ok then add_candidate(id) end
            end
            local seen = {}
            for _, id in ipairs(candidates) do
                if not seen[id] then
                    seen[id] = true
                    local title_ok, title = pcall(current_getter, id)
                    local original_ok, original
                    if type(original_getter) == "function" then
                        original_ok, original = pcall(original_getter, id)
                    end
                    title = title_ok and safe_string(title) or nil
                    original = original_ok and safe_string(original) or nil
                    if title == shown_title or original == shown_title then
                        safe_process(tooltip, { id = id }, "quest")
                        return
                    end
                end
            end
        end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowBountyTooltip",
        function (self, index)
                local data = self.bounties and self.bounties[index]
                local id = data and data.questID
                if type(id) == "number" then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.WorldMapBountyBoardMixin, "ShowLockedByQuestTooltip",
        function (self)
                local id = self.lockedQuestID
                if type(id) == "number" then
                    safe_process(_G.GameTooltip,
                        { id = id, uaForeverSkipTitle = true }, "quest")
                end
        end)
    hooks.region(_G.FlightMap_ZoneSummaryDataProvider, "CheckMouse",
        map_adapter.translate_flight_map)
    hooks.global("Minimap_SetTooltip", map_adapter.translate_minimap_zone)
    hooks.global("TaxiNodeOnButtonEnter", map_adapter.translate_taxi_node)
    hooks.region(_G.ContainerFramePortraitButtonMixin, "OnEnter",
        map_adapter.translate_bag_portrait)
    hooks.global("CommunitiesGuildNewsButton_OnEnter",
        map_adapter.translate_guild_news)
    hooks.region(_G.AdventureMap_ZoneSummaryPinMixin, "OnMouseEnter",
        map_adapter.translate_adventure_pin)
    hooks.region(_G.RecruitActivityButtonMixin, "OnEnter",
        function (self)
                local id = self and self.activityInfo
                    and self.activityInfo.rewardQuestID
                local tooltip = _G.EmbeddedItemTooltip
                if is_secret(id) or type(id) ~= "number" or not tooltip
                    or type(tooltip.GetOwner) ~= "function" then return end
                local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
                if owner_ok and owner == self
                    and quest_adapter.visible_title_matches(
                        tooltip, id, self.questName) then
                    safe_process(tooltip, { id = id }, "quest")
                end
        end)
    hooks.global("CallingPOI_OnEnter", function (pin)
                local id = pin and pin.questID
                if not is_secret(id) and type(id) == "number" and _G.GameTooltip
                    and quest_adapter.visible_title_matches(
                        _G.GameTooltip, id) then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.CovenantCallingQuestMixin, "UpdateTooltipQuestActive",
        function (self)
                local id = self and self.calling and self.calling.questID
                if not is_secret(id) and type(id) == "number" and _G.GameTooltip
                    and quest_adapter.visible_title_matches(
                        _G.GameTooltip, id) then
                    safe_process(_G.GameTooltip, { id = id }, "quest")
                end
        end)
    hooks.region(_G.TalentFrameBaseMixin, "AddConditionsToTooltip",
        talent_adapter.translate_quest_conditions)
end

local function reset_tooltip(self)
    tooltip_session.reset(self, function (region)
        character_stat_line_heights[region] = nil
    end)
    tooltip_font_strings[self] = nil
end

local function object_is_font_string(region)
    if not region or type(region.GetObjectType) ~= "function" then return false end
    local ok, object_type = pcall(region.GetObjectType, region)
    return ok and object_type == "FontString"
end

visible_tooltip_font_strings = function (tooltip)
    local cached = tooltip_font_strings[tooltip]
    if cached then return cached end

    local result = {}
    local seen = {}

    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 4 then return end
        seen[frame] = true

        if frame.GetRegions then
            local ok_regions, regions = pcall(function () return { frame:GetRegions() } end)
            if ok_regions then
                for _, region in ipairs(regions) do
                    if object_is_font_string(region) then
                        local shown_ok, shown = pcall(region.IsShown, region)
                        if shown_ok and shown then result[#result + 1] = region end
                    end
                end
            end
        end

        if frame.GetChildren then
            local ok_children, children = pcall(function () return { frame:GetChildren() } end)
            if ok_children then
                for _, child in ipairs(children) do
                    local shown_ok, shown = pcall(child.IsShown, child)
                    if shown_ok and shown then visit(child, depth + 1) end
                end
            end
        end
    end

    visit(tooltip, 1)
    tooltip_font_strings[tooltip] = result
    return result
end

tooltip_line = function (tooltip, side, index, allow_hidden)
    local region
    if tooltip.GetName then
        local ok_name, name = pcall(tooltip.GetName, tooltip)
        name = ok_name and safe_string(name) or nil
        if name then
            region = _G[name .. "Text" .. side .. tostring(index)]
            if region and region.IsShown and not allow_hidden then
                local shown_ok, shown = pcall(region.IsShown, region)
                if not shown_ok or not shown then region = nil end
            end
        end
    end

    -- Some Forever/Camelot aura tooltips use anonymous FontStrings instead
    -- of the traditional GameTooltipTextLeftN globals. Resolve those visible
    -- regions by their rendered order so ID-backed translations can still be
    -- written without reading or comparing secret aura text.
    if not region and side == "Left" then
        region = visible_tooltip_font_strings(tooltip)[index]
    end
    if not region or not region.GetText then return nil, region end
    local ok_text, text = pcall(region.GetText, region)
    if not ok_text then return nil, region end
    return text, region
end

tooltips.inspect = function (tooltip, limit)
    if not tooltip then return {} end
    local ok_count, count = pcall(tooltip.NumLines, tooltip)
    count = ok_count and safe_number(count) or nil
    count = math.min(count or MAX_TOOLTIP_LINES, safe_number(limit) or 12,
        MAX_TOOLTIP_LINES)
    local result = {}
    for index = 1, count do
        for _, side in ipairs({ "Left", "Right" }) do
            local visible, region = tooltip_line(tooltip, side, index)
            local claim = region and runtime.get(region)
            if is_secret(visible) then visible = nil end
            if type(visible) == "string" and visible ~= "" or claim then
                result[#result + 1] = {
                    index = index, side = side,
                    visible = type(visible) == "string" and visible or nil,
                    owner = claim and claim.owner or nil,
                    slot = claim and claim.slot or nil,
                    source = claim and not is_secret(claim.source)
                        and claim.source or nil,
                    translated = claim and not is_secret(claim.translated)
                        and claim.translated or nil,
                }
            end
        end
    end
    return result
end

local function is_shopping_tooltip(tooltip)
    if tooltip == _G.ShoppingTooltip1 or tooltip == _G.ShoppingTooltip2
        or tooltip == _G.ItemRefShoppingTooltip1
        or tooltip == _G.ItemRefShoppingTooltip2 then return true end
    if not tooltip or type(tooltip.GetName) ~= "function" then return false end
    local ok, name = pcall(tooltip.GetName, tooltip)
    name = ok and safe_string(name) or nil
    return name and name:match("ShoppingTooltip%d+$") ~= nil or false
end

local comparison_item_labels = tooltip_catalog.comparison_item_labels

local function translate_shopping_tooltip(tooltip)
    if not tooltip or tooltip.uaForeverShowOriginal then return end
    local visible, region = tooltip_line(tooltip, "Left", 1)
    local claim = region and runtime.get(region)
    local source = claim and claim.owner == "item-tooltip" and claim.source or visible
    source = safe_string(source)
    if source then
        local translated = entries.lookup_name("item", source)
        if not translated then
            local base, suffix = source:match("^(.-) (of .-)$")
            local translated_base = base and entries.lookup_name("item", base)
            local translated_suffix = suffix and entries.get_item_suffix(source)
            if translated_base and translated_suffix then
                translated = translated_base .. " " .. translated_suffix
            end
        end
        if translated and visible ~= utils.cap(translated) then
            set_tooltip_translation(tooltip, region, source, utils.cap(translated),
                "item.name", "item", "item-tooltip", nil, false, false, nil,
                item_name_visible_matches)
        end
    end

    local header = tooltip.CompareHeader
    local label = header and header.Label
    if label and type(label.GetText) == "function" then
        local ok, current = pcall(label.GetText, label)
        current = ok and safe_string(current) or nil
        if current then
            local translated, _, source_kind, _, _, _, provenance =
                strings.find_ui_translation(current, label)
            if translated and translated ~= current then
                set_tooltip_translation(tooltip, label, current, translated,
                    "comparison.header", nil, "generic", source_kind, false,
                    false, nil, nil, provenance and provenance.source)
            end
        end
    end

    rewrite_generic_lines(tooltip, nil, 2, false, false)
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    if count_ok and safe_number(count) then
        for index = 2, math.min(count, MAX_TOOLTIP_LINES) do
            for _, side in ipairs({ "Left", "Right" }) do
                local text, label_region = tooltip_line(tooltip, side, index)
                local translated_label
                text = safe_string(text)
                if text then translated_label = comparison_item_labels[text] end
                if translated_label and label_region then
                    set_tooltip_translation(tooltip, label_region, text, translated_label,
                        "comparison.label:" .. side .. index, nil,
                        "item-tooltip", nil, false, false)
                end
            end
        end
    end
end

local function minimap_line_parts(line)
    local prefix, suffix = "", ""
    while true do
        local tag = line:match("^(|T.-|t)")
            or line:match("^(|c%x%x%x%x%x%x%x%x)")
            or line:match("^(|r)")
        if not tag then break end
        prefix, line = prefix .. tag, line:sub(#tag + 1)
    end
    while true do
        local tag = line:match("(|r)$")
            or line:match("(|c%x%x%x%x%x%x%x%x)$")
        if not tag then break end
        suffix, line = tag .. suffix, line:sub(1, #line - #tag)
    end
    local leading, core, trailing = line:match("^(%s*)(.-)(%s*)$")
    return prefix .. leading, core, trailing .. suffix
end

local function minimap_tooltip_candidate(tooltip)
    if tooltip ~= _G.GameTooltip then return false end
    if minimap_tooltip_owner(tooltip) then return true end
    local first = tooltip_line(tooltip, "Left", 1)
    first = safe_string(first)
    if not first then return false end
    -- Tracking markers can leave GameTooltip owned by UIParent while the
    -- cursor focus changes. Their composite text still identifies the shape.
    if first:find("\n", 1, true) then return true end
    local _, title = tooltip_title_parts(first)
    return addon_table.translate_object_name
        and addon_table.translate_object_name(title) ~= nil or false
end

local function translate_minimap_line(core, quest_id, tooltip, region)
    if core == "" then return nil, quest_id end
    local found_quest = entries.lookup_id and entries.lookup_id("quest", core)
    if found_quest then
        local quest = entries.get_entry("quest", found_quest)
        local title = quest and options.can_translate("translate_quest")
            and make_text(quest[1], tooltip)
        return title, found_quest
    end
    local dash, objective = core:match("^(%-%s*)(%d+%s*/%s*%d+%s+.+)$")
    if quest_id and dash and options.can_translate("translate_quest") then
        local ok, translated = pcall(entries.translate_quest_objective_task,
            objective, quest_id)
        if ok and type(translated) == "string" and translated ~= objective then
            return dash .. translated, quest_id
        end
    end
    local object = addon_table.translate_object_name
        and addon_table.translate_object_name(core)
    if object then
        return options.can_translate("translate_other_tooltips")
            and utils.cap(object) or nil, quest_id
    end
    local zone = addon_table.zone and addon_table.zone[core]
    if zone then
        return options.can_translate("translate_zone")
            and utils.cap(zone) or nil, quest_id
    end
    if type(entries.lookup_name) == "function" then
        for _, category in ipairs({ "item", "spell" }) do
            local name = entries.lookup_name(category, core)
            if name then
                return options.can_translate("translate_" .. category)
                    and utils.cap(name) or nil, quest_id
            end
        end
    end
    if options.can_translate("translate_other_tooltips") then
        local ui = strings.find_ui_translation(core, region)
        if type(ui) == "string" and ui ~= core then return ui, quest_id end
        local glossary = entries.get_glossary_text(core, core)
        if type(glossary) == "string" and glossary ~= core then
            return glossary, quest_id
        end
    end
    return nil, quest_id
end

local function translate_minimap_text(tooltip, native, region, quest_id)
    if not minimap_tooltip_candidate(tooltip) then return false end
    local lines = {}
    for line in (native .. "\n"):gmatch("(.-)\n") do
        local prefix, core, suffix = minimap_line_parts(line)
        local translated
        translated, quest_id = translate_minimap_line(core, quest_id, tooltip, region)
        lines[#lines + 1] = prefix .. (translated or core) .. suffix
    end
    local result = table.concat(lines, "\n")
    if result == native then return false, quest_id end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    local applied = set_tooltip_translation(tooltip, region, native, result,
        "minimap.text", nil, "generic", "generated")
    return applied, quest_id
end

local function translate_minimap_tooltip(tooltip)
    if not minimap_tooltip_candidate(tooltip) then return false end
    local ok, count = pcall(tooltip.NumLines, tooltip)
    count = ok and safe_number(count) or 1
    local applied, quest_id = false, nil
    for index = 1, math.min(count, MAX_TOOLTIP_LINES) do
        for _, side in ipairs({ "Left", "Right" }) do
            local source, region = tooltip_line(tooltip, side, index)
            source = safe_string(source)
            if region and source then
                local claim = runtime.get(region)
                local original = claim and claim.owner == "generic"
                    and claim.slot == "minimap.text" and source == claim.translated
                    and claim.source or source
                local changed
                changed, quest_id = translate_minimap_text(tooltip, original,
                    region, quest_id)
                applied = changed or applied
            end
        end
    end
    return applied
end

local function translate_cursor_tooltip_title(tooltip, native)
    native = safe_string(native)
    if tooltip ~= _G.GameTooltip or not native or tooltip.uaForeverKind
        and tooltip.uaForeverKind ~= "object" then return false end
    local source, region = tooltip_line(tooltip, "Left", 1)
    if source ~= native or not region then return false end
    if minimap_tooltip_candidate(tooltip) then
        return translate_minimap_text(tooltip, native, region)
    end
    local line_count_ok, line_count = pcall(tooltip.NumLines, tooltip)
    if not line_count_ok or safe_number(line_count) ~= 1 then return false end
    if native:find("\n", 1, true) then return false end
    local prefix, title = tooltip_title_parts(native)

    local translated, slot, category, owner
    if addon_table.zone and addon_table.zone[title] then
        if not options.can_translate("translate_zone") then return false end
        translated = addon_table.zone[title]
        slot, owner = "zone.name", "zone-tooltip"
    elseif addon_table.translate_object_name
        and addon_table.translate_object_name(title) then
        if not options.can_translate("translate_other_tooltips") then return false end
        translated = addon_table.translate_object_name(title)
        slot, owner = "object.name", "object-tooltip"
    else
        for _, kind in ipairs({ "item", "spell", "quest" }) do
            translated = entries.lookup_name(kind, title)
            if translated then
                slot, category, owner = kind .. ".name", kind,
                    kind .. "-tooltip"
                break
            end
        end
        if not translated and options.can_translate("translate_other_tooltips") then
            translated = entries.get_glossary_text(title)
            slot, owner = "cursor.name", "cursor-tooltip"
        end
    end
    if type(translated) ~= "string" or translated == native then return false end
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    return set_tooltip_translation(tooltip, region, native,
        prefix .. utils.cap(translated),
        slot, category, owner)
end

-- Forever uses one display style for every tooltip: replace known visible
-- FontStrings in place. Domain post-calls run after Blizzard has populated the
-- tooltip, while this generic pass covers ordinary SetText tooltips.
local function translate_generic_tooltip(tooltip)
    if not tooltip then return end
    note_tooltip_event(tooltip, "finalize")
    if not tooltip.uaForeverSessionKey then begin_tooltip(tooltip, "generic") end
    if tooltip.uaForeverShowOriginal then return end
    translate_minimap_tooltip(tooltip)

    if is_shopping_tooltip(tooltip) then
        translate_shopping_tooltip(tooltip)
        return
    end

    -- Empty equipment slots are translated synchronously when ItemUtil has
    -- finished rebuilding their tooltip. A deferred generic pass can otherwise
    -- rewrite the one-line tooltip again after it has been shown.
    if tooltip.uaForeverKind == "empty-bag-slot"
        or tooltip.uaForeverKind == "equipment-slot"
        or tooltip.uaForeverKind == "character-stat" then return end

    -- Settings uses its own GameTooltip frame with UI text, not item or aura
    -- data. Resolve every rendered line directly through the UI dictionary.
    if tooltip == _G.SettingsTooltip then
        rewrite_generic_lines(tooltip)
        return
    end

    if tooltip.uaForeverKind == "trainer" then
        rewrite_generic_lines(tooltip)
        return
    end

    if tooltip.uaForeverKind == "item" or tooltip.uaForeverKind == "spell"
        or tooltip.uaForeverKind == "npc"
        or tooltip.uaForeverKind == "quest" then
        rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst or 2)
        if tooltip.uaForeverKind == "npc" then
            quest_adapter.translate_embedded(tooltip)
        end
        return
    end
    if tooltip.uaForeverKind == "player" then
        local _, identity_line = translate_player_tooltip_identity(tooltip)
        rewrite_generic_lines(tooltip, nil, identity_line
            or tooltip.uaForeverReservedFirst or 2)
        return
    end

    local left_title = tooltip_line(tooltip, "Left", 1)
    local cast_spell = false
    for index = 2, 6 do
        local line = tooltip_line(tooltip, "Left", index)
        local visible = normalized_tooltip_text(line)
        if visible and (visible:match("^%d+ Rage$")
            or visible:match("^%d+ Mana$")
            or visible:match("^%d+ Energy$")
            or visible:match("^%d+ Focus$")
            or visible:match("^Requires .+ Stance")
            or visible == "Melee Range" or visible == "Instant"
            or tooltip_catalog.translated_cast_markers[visible]) then
            cast_spell = true
            break
        end
    end

    -- Prefer the public spell ID from the already-built tooltip. Some player
    -- aura tooltips expose no public ID, so fall back to the rendered title
    -- and the addon's own spell dictionary without querying protected auras.
    local spell_id
    if type(tooltip.GetSpell) == "function" then
        local ok_spell, _, tooltip_spell_id = pcall(tooltip.GetSpell, tooltip)
        spell_id = ok_spell and safe_number(tooltip_spell_id) or nil
    end
    local public_left_title = safe_string(left_title)
    if cast_spell and (not spell_id or not entries.get_entry("spell", spell_id))
        and public_left_title
        and C_Spell and type(C_Spell.GetSpellInfo) == "function" then
        local ok_info, info = pcall(C_Spell.GetSpellInfo, public_left_title)
        local resolved = ok_info and info and safe_number(info.spellID) or nil
        if resolved and entries.get_entry("spell", resolved) then spell_id = resolved end
    end
    local aura_id_inferred = false
    if not spell_id then
        spell_id = spell_adapter.resolve_aura_id(left_title)
        aura_id_inferred = spell_id ~= nil
    end
    if spell_id then
        local kind = cast_spell and "spell" or "aura"
        if safe_process(tooltip, {
            spellID = spell_id,
            uaForeverCaptureByTitle = kind == "aura" and aura_id_inferred,
        }, kind) then
            if cast_spell then return end
            local retry_key = tooltip_key("aura", spell_id)
            if tooltip.uaForeverAuraRetryKey ~= retry_key then
                tooltip.uaForeverAuraRetryKey = retry_key
                local generation = tooltip.uaForeverGeneration
                scheduler.request("tooltip-aura:" .. tostring(tooltip), generation, function ()
                    local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
                    if shown_ok and shown then
                        tooltip_font_strings[tooltip] = nil
                        safe_process(tooltip, {
                            spellID = spell_id,
                            uaForeverCaptureByTitle = aura_id_inferred,
                        }, "aura")
                    end
                end, nil, tooltip)
            end
            return
        end
    end

    left_title = public_left_title
    if not left_title then return end

    -- Quest blob tooltips can be built without a public quest ID on the pin.
    -- Resolve their visible English title from the prepared quest catalog.
    local quest_id = entries.lookup_id and entries.lookup_id("quest", left_title)
    if quest_id and safe_process(tooltip, { id = quest_id }, "quest") then return end

    local ok_count, line_count = pcall(tooltip.NumLines, tooltip)
    line_count = ok_count and safe_number(line_count) or nil
    if not line_count or line_count < 1 then return end

    translate_cursor_tooltip_title(tooltip, left_title)
    translate_object_tooltip_title(tooltip)
    if minimap_tooltip_owner(tooltip) then
        quest_adapter.translate_embedded(tooltip)
    end
    rewrite_generic_lines(tooltip, line_count, tooltip.uaForeverReservedFirst)
    capture_world_tooltip(tooltip, line_count)
end

tooltips.finalize = translate_generic_tooltip

local function translate_unit_aura_tooltip(tooltip, data)
    if not tooltip then return false end
    mark_aura_tooltip(tooltip)
    local observed_spell_id = type(data) == "table"
        and safe_number(data.spellID) or nil
    observed_spell_id = observed_spell_id or visible_spell_id(tooltip)
        or player_aura_spell_id(tooltip)
    if not observed_spell_id and type(data) == "table" then
        observed_spell_id = safe_number(data.id)
    end
    local spell_id = observed_spell_id
    local inferred_by_title = false
    if not spell_id then
        spell_id = spell_adapter.resolve_aura_id(
            tooltip_line(tooltip, "Left", 1))
        inferred_by_title = spell_id ~= nil
    end
    if not spell_id or not entries.get_entry("spell", spell_id) then
        translate_generic_tooltip(tooltip)
        return false, observed_spell_id, inferred_by_title
    end

    local aura_key = tooltip_key("aura", spell_id)
    if tooltip.uaForeverKind == "spell" and tooltip.uaForeverID == spell_id then
        -- Unit-aura tooltips also emit TooltipDataType.Spell before the
        -- SetUnitBuff/SetUnitDebuff post-hook. Promote that same session to an
        -- aura without discarding its English-source claims.
        tooltip.uaForeverSessionKey = aura_key
        tooltip.uaForeverKind = "aura"
    end
    return safe_process(tooltip, {
        spellID = spell_id,
        uaForeverCaptureByTitle = inferred_by_title,
    }, "aura"), observed_spell_id, inferred_by_title
end

local target_aura_overlay = {
    markers = {},
    auras = {},
    dirty = true,
    elapsed = 0,
    layoutElapsed = 0,
    refreshElapsed = 0,
}

local function overlay_object_value(object, method)
    if not object then return nil end
    local method_ok, callback = pcall(function () return object[method] end)
    if not method_ok or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, object)
    if ok and not is_secret(value) then return value end
end

local function overlay_aura_field(aura, key)
    if not aura or is_secret(aura) then return nil end
    local ok, value = pcall(function () return aura[key] end)
    if not ok or is_secret(value) then return nil end
    return value
end

local function overlay_aura_is_large(aura)
    local source = safe_string(overlay_aura_field(aura, "sourceUnit"))
    if not source then return false end
    for _, unit in ipairs({ "player", "vehicle", "pet" }) do
        local same_ok, same = pcall(_G.UnitIsUnit, source, unit)
        if same_ok and not is_secret(same) and same == true then return true end
        if type(_G.UnitIsOwnerOrControllerOfUnit) == "function" then
            local owner_ok, owner = pcall(
                _G.UnitIsOwnerOrControllerOfUnit, unit, source)
            if owner_ok and not is_secret(owner) and owner == true then return true end
        end
    end
    return false
end

local function overlay_collect_auras(filter, maximum, helpful)
    local result = {}
    local unit_auras = _G.C_UnitAuras
    local getter = unit_auras and unit_auras.GetAuraDataByIndex
    if type(getter) ~= "function" then return result end
    for index = 1, maximum do
        local ok, aura = pcall(getter, "target", index, filter)
        if not ok or aura == nil or is_secret(aura) then break end
        local instance_id = safe_number(
            overlay_aura_field(aura, "auraInstanceID"))
        local spell_id = safe_number(overlay_aura_field(aura, "spellId"))
        local nameplate_only = overlay_aura_field(aura, "isNameplateOnly") == true
        if instance_id and spell_id and (not helpful or not nameplate_only) then
            result[#result + 1] = {
                auraInstanceID = instance_id,
                spellID = spell_id,
                size = overlay_aura_is_large(aura) and 21 or 17,
            }
        end
    end
    return result
end

local function overlay_marker(index)
    local marker = target_aura_overlay.markers[index]
    if marker then return marker end
    marker = CreateFrame("Frame", nil, UIParent)
    marker:EnableMouse(false)
    marker:SetAlpha(0)
    marker:Show()
    target_aura_overlay.markers[index] = marker
    return marker
end

local function overlay_target_is_other_player()
    if type(_G.UnitExists) ~= "function" or type(_G.UnitIsPlayer) ~= "function"
        or type(_G.UnitIsUnit) ~= "function" then return false end
    local exists_ok, exists = pcall(_G.UnitExists, "target")
    local player_ok, player = pcall(_G.UnitIsPlayer, "target")
    local self_ok, is_self = pcall(_G.UnitIsUnit, "target", "player")
    return exists_ok and exists == true and player_ok and player == true
        and self_ok and is_self ~= true
end

local function overlay_target_container()
    local ok, container = pcall(function ()
        return _G.TargetFrame
            and _G.TargetFrame.TargetFrameContent
            and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual
            and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual.Auras
    end)
    return ok and container or nil
end

local function rebuild_target_aura_overlay_layout()
    target_aura_overlay.dirty = false
    target_aura_overlay.auras = {}
    for _, marker in ipairs(target_aura_overlay.markers) do marker:Hide() end
    if not overlay_target_is_other_player() then return end

    local container = overlay_target_container()
    if not container then return end
    local shown_ok, shown = pcall(container.IsShown, container)
    if not shown_ok or shown ~= true then return end
    local anchor_reference_ok, anchor_reference = pcall(function ()
        return _G.TargetFrame
            and _G.TargetFrame.TargetFrameContainer
            and _G.TargetFrame.TargetFrameContainer.FrameTexture
    end)
    if not anchor_reference_ok or not anchor_reference then return end

    local buff_filter, debuff_filter = "HELPFUL", "HARMFUL"
    local buff_ok, value = pcall(container.GetBuffFilterString, container)
    if buff_ok then buff_filter = safe_string(value) or buff_filter end
    local debuff_ok
    debuff_ok, value = pcall(container.GetDebuffFilterString, container)
    if debuff_ok then debuff_filter = safe_string(value) or debuff_filter end

    local buffs = overlay_collect_auras(buff_filter, 32, true)
    local debuffs = overlay_collect_auras(debuff_filter, 16, false)
    local friendly_ok, friendly = pcall(_G.UnitIsFriend, "player", "target")
    friendly = friendly_ok and not is_secret(friendly) and friendly == true
    local groups = friendly and { buffs, debuffs } or { debuffs, buffs }

    local mirrored = _G.TargetFrame and _G.TargetFrame.buffsOnTop == true
    local anchor = mirrored and "BOTTOMLEFT" or "TOPLEFT"
    local relative_anchor = mirrored and "TOPLEFT" or "BOTTOMLEFT"
    local base_x, base_y = 5, mirrored and -6 or 9
    local vertical_direction = mirrored and 1 or -1
    local target_scale = overlay_object_value(_G.TargetFrame, "GetEffectiveScale")
    local ui_scale = overlay_object_value(_G.UIParent, "GetEffectiveScale")
    local marker_scale = type(target_scale) == "number" and type(ui_scale) == "number"
        and ui_scale > 0 and target_scale / ui_scale or 1

    local constrained_width = 122
    local constrained_lines = 0
    local tot = _G.TargetFrame and _G.TargetFrame.totFrame
    if overlay_object_value(tot, "IsShown") == true then
        constrained_width = safe_number(_G.TargetFrame.TOT_AURA_ROW_WIDTH) or 101
        constrained_lines = 2
    end

    local cursor_x, cursor_y = 0, 0
    local line_index, line_size, line_height = 1, 0, 0
    local placed = false
    local marker_index = 0
    local function advance_line(gap)
        cursor_x = 0
        cursor_y = cursor_y + (line_height + gap) * vertical_direction
        line_index = line_index + 1
        line_size, line_height = 0, 0
    end
    for _, group in ipairs(groups) do
        if placed and #group > 0 then advance_line(3) end
        for _, aura in ipairs(group) do
            local maximum = line_index <= constrained_lines
                and constrained_width or 122
            local next_size = line_size > 0 and line_size + aura.size or aura.size
            if line_size > 0 and next_size > maximum then
                advance_line(3)
                next_size = aura.size
            end

            marker_index = marker_index + 1
            local marker = overlay_marker(marker_index)
            marker:ClearAllPoints()
            marker:SetScale(marker_scale)
            marker:SetSize(aura.size, aura.size)
            marker:SetPoint(anchor, anchor_reference, relative_anchor,
                base_x + cursor_x, base_y + cursor_y)
            marker:Show()
            aura.marker = marker
            target_aura_overlay.auras[#target_aura_overlay.auras + 1] = aura

            cursor_x = cursor_x + aura.size + 3
            line_size = next_size + 3
            line_height = math.max(line_height, aura.size)
            placed = true
        end
    end
end

local function cursor_over_overlay_marker(marker)
    if not marker or type(_G.GetCursorPosition) ~= "function" then return false end
    local shown_ok, shown = pcall(marker.IsShown, marker)
    if not shown_ok or shown ~= true then return false end
    local ok, left, bottom, width, height = pcall(marker.GetRect, marker)
    if not ok or not left or not bottom or not width or not height then return false end
    local scale = overlay_object_value(marker, "GetEffectiveScale")
    if type(scale) ~= "number" or scale <= 0 then return false end
    local cursor_ok, x, y = pcall(_G.GetCursorPosition)
    if not cursor_ok or is_secret(x) or is_secret(y) then return false end
    x, y = x / scale, y / scale
    return x >= left and x <= left + width and y >= bottom and y <= bottom + height
end

local function hide_target_aura_overlay()
    local tooltip = target_aura_overlay.tooltip
    if tooltip and tooltip:IsShown() then tooltip:Hide() end
    target_aura_overlay.currentAuraInstanceID = nil
end

local function show_target_aura_overlay(aura)
    local tooltip = target_aura_overlay.tooltip
    if not tooltip then return end
    tooltip_session.reset(tooltip, function (region)
        character_stat_line_heights[region] = nil
    end)
    if type(tooltip.SetMinimumWidth) == "function" then
        tooltip:SetMinimumWidth(0)
    end
    tooltip:SetOwner(aura.marker, "ANCHOR_BOTTOMLEFT")
    tooltip.uaForeverTargetAuraMeasuring = true
    local ok, applied = pcall(tooltip.SetUnitAuraByAuraInstanceID,
        tooltip, "target", aura.auraInstanceID)
    tooltip.uaForeverTargetAuraMeasuring = nil
    if not ok or applied == false then
        tooltip:Hide()
        return
    end
    tooltip:Show()
    local native_width = overlay_object_value(tooltip, "GetWidth") or 0
    local native_height = overlay_object_value(tooltip, "GetHeight") or 0
    local translated = translate_unit_aura_tooltip(tooltip, {
        spellID = aura.spellID,
    })
    if not translated then
        tooltip:Hide()
        return
    end
    tooltip:Show()
    local translated_width = overlay_object_value(tooltip, "GetWidth") or 0
    local translated_height = overlay_object_value(tooltip, "GetHeight") or 0
    local width = math.max(native_width, translated_width) + 20
    local height = math.max(native_height, translated_height) + 4
    if type(tooltip.SetMinimumWidth) == "function" then
        tooltip:SetMinimumWidth(width)
    end
    tooltip:SetWidth(width)
    tooltip:SetHeight(height)
    tooltip:SetFrameStrata("TOOLTIP")
    tooltip:SetFrameLevel(10000)
    target_aura_overlay.currentAuraInstanceID = aura.auraInstanceID
end

local function prepare_target_aura_overlay()
    if target_aura_overlay.watcher or type(_G.CreateFrame) ~= "function" then return end
    local tooltip = CreateFrame("GameTooltip", "UAForeverTargetAuraTooltip",
        UIParent, "GameTooltipTemplate")
    tooltip:SetClampedToScreen(true)
    tooltip:EnableMouse(false)
    local opaque_background = tooltip:CreateTexture(nil, "BACKGROUND", nil, -8)
    opaque_background:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 4, -4)
    opaque_background:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -4, 4)
    opaque_background:SetColorTexture(0.015, 0.015, 0.02, 1)
    tooltip.uaForeverOpaqueBackground = opaque_background
    tooltip:Hide()
    target_aura_overlay.tooltip = tooltip

    local watcher = CreateFrame("Frame")
    watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    watcher:RegisterEvent("PLAYER_TARGET_CHANGED")
    watcher:RegisterUnitEvent("UNIT_AURA", "target")
    watcher:RegisterUnitEvent("UNIT_TARGET", "target")
    watcher:SetScript("OnEvent", function ()
        target_aura_overlay.dirty = true
    end)
    watcher:SetScript("OnUpdate", function (_, elapsed)
        target_aura_overlay.elapsed = target_aura_overlay.elapsed + elapsed
        target_aura_overlay.layoutElapsed = target_aura_overlay.layoutElapsed + elapsed
        target_aura_overlay.refreshElapsed = target_aura_overlay.refreshElapsed + elapsed
        if target_aura_overlay.elapsed < 0.03 then return end
        target_aura_overlay.elapsed = 0

        if not options.can_translate("translate_spell")
            or not overlay_target_is_other_player() then
            hide_target_aura_overlay()
            return
        end
        if target_aura_overlay.dirty or target_aura_overlay.layoutElapsed >= 0.5 then
            target_aura_overlay.layoutElapsed = 0
            rebuild_target_aura_overlay_layout()
        end

        local hovered
        for _, aura in ipairs(target_aura_overlay.auras) do
            if cursor_over_overlay_marker(aura.marker) then
                hovered = aura
                break
            end
        end
        if not hovered then
            hide_target_aura_overlay()
            return
        end
        if target_aura_overlay.currentAuraInstanceID ~= hovered.auraInstanceID
            or target_aura_overlay.refreshElapsed >= 0.25 then
            target_aura_overlay.refreshElapsed = 0
            show_target_aura_overlay(hovered)
        end
    end)
    target_aura_overlay.watcher = watcher
end

local function capture_generic_tooltip_ui(tooltip)
    if not tooltip or not options.account or not options.account.auto_scan_content then return end
    local kind = tooltip.uaForeverKind
    if kind == "item" or kind == "spell" or kind == "aura"
        or kind == "trainer" or kind == "npc" or kind == "quest"
        or kind == "object" or kind == "player" then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and safe_number(count) or nil
    if tooltip == _G.GameTooltip and count == 1
        and (world_cursor_owner(tooltip) or minimap_tooltip_owner(tooltip)) then return end
    if type(strings.capture_frame) == "function" then
        strings.capture_frame(tooltip, true)
    end
end

local stat_tooltip_formats
local function character_stat_format_text(value)
    value = safe_string(value)
    if not value then return nil end
    return normalized_tooltip_text(value:gsub("\\r", " "):gsub("\\n", " "))
end

local resistance_schools = tooltip_catalog.resistance_schools

local function resistance_stat_description(source)
    local visible = character_stat_format_text(source)
    if not visible then return nil end
    local school, level, average = visible:match(
        "^Improves resistance to ([%a]+)%-based attacks, spells, and abilities Average resistance versus a level ([%d,]+) enemy: ([%d.,]+)%%$")
    local school_name = school and resistance_schools[school:lower()]
    if not school_name then return nil end
    return tooltip_format.resistance(school_name, level, average)
end

local function stat_tooltip_pattern(format_text)
    local parts, conversions = { "^" }, {}
    local index = 1
    while index <= #format_text do
        local char = format_text:sub(index, index)
        if char == "%" and format_text:sub(index + 1, index + 1) == "%" then
            parts[#parts + 1] = "%%"
            index = index + 2
        elseif char == "%" then
            local token, conversion = format_text:sub(index):match(
                "^(%%[%d$%.%+%-]*([cdeEfgGiosuxX]))")
            if token then
                parts[#parts + 1] = conversion == "s" and "(.-)"
                    or "([%+%-]?[%d.,]+)"
                conversions[#conversions + 1] = conversion
                index = index + #token
            else
                parts[#parts + 1] = "%%"
                index = index + 1
            end
        else
            parts[#parts + 1] = char:match("[%^%$%(%)%.%[%]%*%+%-%?]")
                and "%" .. char or char
            index = index + 1
        end
    end
    parts[#parts + 1] = "$"
    return table.concat(parts), conversions
end

local function formatted_character_stat_description(source)
    source = safe_string(source)
    if not source then return nil end
    local normalized_source = character_stat_format_text(source)
    if not stat_tooltip_formats then
        stat_tooltip_formats = {}
        for key, original in pairs(_G) do
            if type(key) == "string" and type(original) == "string"
                and (key:match("^STAT_.*TOOLTIP")
                    or key:match("^CR_.*TOOLTIP")
                    or key:match("^STAT_CRIT_")
                    or key:match("^STAT_.*_CRIT_BONUS$")
                    or key:match("^DEFAULT_.*TOOLTIP")
                    or key:match("^%u+_STRENGTH_TOOLTIP$")
                    or key:match("^%u+_AGILITY_TOOLTIP$")
                    or key:match("^%u+_STAMINA_TOOLTIP$")
                    or key:match("^%u+_INTELLECT_TOOLTIP$")
                    or key:match("^%u+_SPIRIT_TOOLTIP$")
                    or key:match("^%u+_ATTACK_POWER_TOOLTIP$")
                    or key == "SPELL_PENETRATION_TOOLTIP"
                    or key == "MANA_REGEN_TOOLTIP"
                    or key == "RESILIENCE_TOOLTIP") then
                local dictionary = addon_table.forever_ui
                local translated = dictionary and dictionary[original]
                if not translated and dictionary then
                    translated = dictionary[original:gsub("\r", "\\r")
                        :gsub("\n", "\\n")]
                end
                if type(translated) == "string" and translated ~= original then
                    local normalized_original = character_stat_format_text(original)
                    local pattern, conversions = stat_tooltip_pattern(normalized_original)
                    if pattern then
                        stat_tooltip_formats[#stat_tooltip_formats + 1] = {
                            pattern = pattern, source = normalized_original,
                            conversions = conversions,
                            translated = translated:gsub("\\r", "")
                                :gsub("\\n", "\n"),
                        }
                    end
                end
            end
        end
    end
    for _, entry in ipairs(stat_tooltip_formats) do
        if #entry.conversions == 0 and normalized_source:match(entry.pattern) then
            return entry.translated
        end
        local captures = { normalized_source:match(entry.pattern) }
        if #captures > 0 and #captures == #entry.conversions then
            local args = {}
            for index, value in ipairs(captures) do
                local conversion = entry.conversions[index]
                local numeric_value = value:gsub(",", "")
                args[index] = conversion == "s" and value
                    or tonumber(numeric_value)
            end
            local ok, translated = pcall(string.format, entry.translated,
                unpack(args))
            if ok and type(translated) == "string" then return translated end
        end
    end
end

local function character_stat_visibility(tooltip, region)
    local previous_height = character_stat_line_heights[region]
    local current_height = layout.safe_dimension(region, "GetStringHeight")
        or layout.safe_dimension(region, "GetHeight")
    if previous_height and current_height then
        layout.fit_tooltip_height_to_region(tooltip, region,
            previous_height, layout.safe_dimension(tooltip, "GetHeight"))
    end
    character_stat_line_heights[region] = current_height
end

local function set_character_stat_translation(tooltip, region, source,
    translated, slot)
    local color_ok, red, green, blue, alpha = false, nil, nil, nil, nil
    if type(region.GetTextColor) == "function" then
        color_ok, red, green, blue, alpha = pcall(region.GetTextColor, region)
    end
    local applied = set_tooltip_translation(tooltip, region, source, translated,
        slot, nil, "character-stat", nil, false, true,
        function (visible_region)
            character_stat_visibility(tooltip, visible_region)
        end)
    if applied and color_ok and type(region.SetTextColor) == "function"
        and safe_number(red) and safe_number(green) and safe_number(blue) then
        pcall(region.SetTextColor, region, red, green, blue,
            safe_number(alpha) or 1)
    end
    return applied
end

tooltips.translate_character_stat = function (frame)
    local tooltip = _G.GameTooltip
    if not tooltip or not frame or type(tooltip.GetOwner) ~= "function" then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not owner_ok or owner ~= frame then return end
    begin_tooltip(tooltip, "character-stat:" .. tostring(frame))
    tooltip.uaForeverKind = "character-stat"
    local label
    if frame.Label and type(frame.Label.GetText) == "function" then
        local label_ok, value = pcall(frame.Label.GetText, frame.Label)
        if label_ok then label = normalized_tooltip_text(value) end
    end
    if label then label = strings.find_ui_translation(label, frame.Label) or label end
    local title, title_region = tooltip_line(tooltip, "Left", 1)
    local visible_title = normalized_tooltip_text(title)
    local value = visible_title and visible_title:match("([%d][%d.,%%%- ]*)$")
    if title_region then
        local school = visible_title and visible_title:match("^([%a]+) [%d.,]+$")
        local school_label = school and resistance_schools[school:lower()]
            and strings.find_ui_translation(school .. ":", title_region)
        local translated = school_label and value
            and school_label:gsub(":$", "") .. " " .. value
            or label and value
            and label:gsub(":$", "") .. " " .. value
            or strings.find_ui_translation(title, title_region)
        if translated then
            title = safe_string(title)
            local title_color = title
                and title:match("^(|c%x%x%x%x%x%x%x%x).-|r$")
            if title_color and not translated:find("|c", 1, true) then
                translated = title_color .. translated .. "|r"
            end
            set_character_stat_translation(tooltip, title_region, title,
                translated, "character.stat.title")
        end
    end
    local ok_count, count = pcall(tooltip.NumLines, tooltip)
    count = ok_count and safe_number(count) or MAX_TOOLTIP_LINES
    local width = layout.safe_dimension(tooltip, "GetWidth")
    local screen_width = layout.safe_dimension(_G.UIParent, "GetWidth")
    local target_width = screen_width and math.min(360, screen_width - 32) or 360
    if width and width < target_width and type(tooltip.SetWidth) == "function" then
        pcall(tooltip.SetWidth, tooltip, target_width)
        width = target_width
    end
    for index = 2, math.min(count, MAX_TOOLTIP_LINES) do
        local source, region = tooltip_line(tooltip, "Left", index)
        local right, right_region = tooltip_line(tooltip, "Right", index)
        if region and width then
            local previous_height = layout.safe_dimension(region, "GetStringHeight")
                or layout.safe_dimension(region, "GetHeight")
            local previous_tooltip_height = previous_height
                and layout.safe_dimension(tooltip, "GetHeight")
            if type(region.SetWordWrap) == "function" then
                pcall(region.SetWordWrap, region, true)
            end
            if type(region.SetWidth) == "function" then
                right = safe_string(right)
                local right_width = right and right_region
                    and layout.safe_dimension(right_region, "GetStringWidth") or 0
                pcall(region.SetWidth, region,
                    math.max(1, width - right_width - 24))
            end
            layout.fit_tooltip_height_to_region(tooltip, region,
                previous_height, previous_tooltip_height)
        end
        if not tooltip.uaForeverShowOriginal then
            local translated = resistance_stat_description(source)
                or formatted_character_stat_description(source)
                or strings.find_ui_translation(source, region)
            if not translated then
                local visible = normalized_tooltip_text(source)
                local field, suffix
                if visible then
                    field, suffix = visible:match("^([^:\n]+):%s*(.-)%s*$")
                end
                if field and (suffix == ""
                    or suffix:match("^[%d%.,/%%+%-%s]+$")) then
                    local field_translation = strings.find_ui_translation(field,
                        region)
                    if field_translation and field_translation ~= field then
                        translated = field_translation .. ":"
                            .. (suffix ~= "" and " " .. suffix or "")
                    end
                end
            end
            if translated and region then
                set_character_stat_translation(tooltip, region, source,
                    translated, "character.stat:" .. index)
            end
        end
    end
end

local function is_character_stat_owner(owner)
    return owner and owner.Label and owner.Value
        and (type(owner.UpdateTooltip) == "function"
            or type(owner.onEnterFunc) == "function"
            or type(owner.tooltip) == "string")
end

local refreshing_comparison = false
local function after_comparison_refresh(manager)
    if refreshing_comparison or not manager or not manager.tooltip then return end
    refreshing_comparison = true
    local ok_refresh, refresh_error = pcall(function ()
        for _, comparison in ipairs(manager.tooltip.shoppingTooltips or {}) do
            local ok, shown = pcall(comparison.IsShown, comparison)
            if ok and shown then
                if not comparison.uaForeverSessionKey then
                    begin_tooltip(comparison, "generic")
                end
                -- The comparison manager has finished every native write,
                -- including delta lines. Replace them in this same frame only.
                translate_shopping_tooltip(comparison)
            end
        end
    end)
    refreshing_comparison = false
    if not ok_refresh then
        dev_log.issue("Forever comparison tooltip", tostring(refresh_error))
    end
end

tooltips.aura_probe_candidate = function (tooltip)
    if not tooltip or type(tooltip.IsShown) ~= "function" then return false end
    local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
    if not ok_shown or shown ~= true then return false end
    if aura_tooltip_context(tooltip) then return true end
    if visible_spell_id(tooltip) then return true end
    local title = tooltip_line(tooltip, "Left", 1)
    return spell_adapter.resolve_aura_id(title) ~= nil
end

-- Explicit, bounded capture for aura tooltips. Values marked secret are never
-- formatted or stored; the player can save this through /uaf aura while hovering.
tooltips.capture_aura = function (tooltip)
    if not tooltip then return nil end
    local function snapshot()
        local result = {
            prepared = tooltips.prepared == true,
            events = {}, lines = {},
        }
        for event, count in pairs(tooltip_events[tooltip] or {}) do
            result.events[event] = count
        end
        local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
        result.shown = ok_shown and shown == true
        local kind = safe_string(tooltip.uaForeverKind)
        if kind then result.kind = kind end
        result.id = safe_number(tooltip.uaForeverID)
        result.translated = tooltip.uaForeverKey ~= nil
        result.original = tooltip.uaForeverShowOriginal == true
        result.getSpell = type(tooltip.GetSpell) == "function"
        if result.getSpell then
            local ok_spell, name, spell_id = pcall(tooltip.GetSpell, tooltip)
            result.getSpellOK = ok_spell
            if ok_spell then
                result.spellID = safe_number(spell_id)
                result.spellName = safe_string(name)
            end
        end
        local ok_count, count = pcall(tooltip.NumLines, tooltip)
        result.numLines = ok_count and safe_number(count) or nil
        for index = 1, math.min(result.numLines or 20, 20) do
            for _, side in ipairs({ "Left", "Right" }) do
                local value, region = tooltip_line(tooltip, side, index)
                if region then
                    local claim = runtime.get(region)
                    local secret = is_secret(value)
                    local row = { index = index, side = side, secret = secret }
                    if not secret and type(value) == "string" then row.text = value end
                    if claim then
                        row.owner = safe_string(claim.owner)
                        row.slot = safe_string(claim.slot)
                    end
                    result.lines[#result.lines + 1] = row
                end
            end
        end
        local first = result.lines[1]
        if first and first.side == "Left" and first.text then
            result.titleID = spell_adapter.resolve_aura_id(first.text)
        end
        return result
    end
    local report = { before = snapshot() }
    mark_aura_tooltip(tooltip)
    after_aura_tooltip_rendered(tooltip)
    report.after = snapshot()
    if UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.auraProbe = report
    end
    return report
end

local function public_object_value(object, method)
    if not object then return nil end
    local ok_method, callback = pcall(function () return object[method] end)
    if not ok_method or type(callback) ~= "function" then return nil end
    local ok, value = pcall(callback, object)
    if ok and not is_secret(value) then return value end
end

local function object_label(object)
    local debug_name = public_object_value(object, "GetDebugName")
    if type(debug_name) == "string" then return debug_name end
    local name = public_object_value(object, "GetName")
    return type(name) == "string" and name or "<anonymous>"
end

local function object_list(object, method)
    if not object then return {} end
    local ok_method, callback = pcall(function () return object[method] end)
    if not ok_method or type(callback) ~= "function" then return {} end
    local ok, result = pcall(function () return { callback(object) } end)
    return ok and result or {}
end

local diagnostic_tooltip_names = {
    "GameTooltip", "SettingsTooltip", "ItemRefTooltip",
    "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefShoppingTooltip1",
    "ItemRefShoppingTooltip2", "EmbeddedItemTooltip", "BuffFrameTooltip",
}

local function visible_tooltip_windows()
    local result, seen = {}, {}
    local function add(candidate, global_name, known_tooltip)
        if not candidate or seen[candidate]
            or public_object_value(candidate, "IsShown") ~= true then return end
        local kind = public_object_value(candidate, "GetObjectType")
        local name = object_label(candidate)
        if not known_tooltip and kind ~= "GameTooltip"
            and not (type(name) == "string"
                and name:find("Tooltip", 1, true)) then return end
        seen[candidate] = true
        result[#result + 1] = { frame = candidate, globalName = global_name }
    end
    for _, name in ipairs(diagnostic_tooltip_names) do
        add(_G[name], name, true)
    end
    for _, candidate in ipairs(object_list(_G.UIParent, "GetChildren")) do
        add(candidate)
    end
    return result
end

local function visible_tooltip_window()
    local visible = visible_tooltip_windows()
    return visible[1] and visible[1].frame or nil
end

tooltips.visible_window = visible_tooltip_window

tooltips.visible_aura_window = function ()
    for _, descriptor in ipairs(visible_tooltip_windows()) do
        local tooltip = descriptor.frame
        if aura_tooltip_context(tooltip)
            or tooltips.aura_probe_candidate(tooltip) then
            return tooltip
        end
    end
end

local function diagnostic_scalar(value)
    if value == nil or is_secret(value) then return nil end
    local kind = type(value)
    if kind == "string" then return safe_string(value) end
    if kind == "number" or kind == "boolean" then return value end
end

local function diagnostic_field(object, key)
    if not object or is_secret(object) then return nil end
    local ok, value = pcall(function () return object[key] end)
    return ok and diagnostic_scalar(value) or nil
end

local diagnostic_catalog_paths = {
    classic_string = "entries/string.lua",
    ui = "entries/forever/catalogs/ui/core.lua",
    settings = "entries/forever/catalogs/ui/settings.lua",
    skills = "entries/forever/catalogs/ui/skills.lua",
    client_domains_skills = "entries/forever/catalogs/ui/client_skills.lua",
    client_verified_ui = "entries/forever/catalogs/ui/client_verified.lua",
    client_global_strings = "entries/forever/catalogs/ui/client_global.lua",
}

local function diagnostic_edit_target(claim)
    local catalog_source = safe_string(claim.catalog_source)
    if catalog_source and diagnostic_catalog_paths[catalog_source] then
        return diagnostic_catalog_paths[catalog_source]
    end
    local slot = safe_string(claim.slot) or ""
    local category = safe_string(claim.category)
    local owner = safe_string(claim.owner)
    if slot:find("comparison.label:", 1, true) == 1 then
        return "entries/forever/catalogs/ui/tooltips.lua"
    end
    if category == "item" or owner == "item-tooltip" then
        return "entries/forever/catalogs/items/catalog.lua"
    end
    if category == "spell" or owner == "spell-tooltip" then
        return "entries/forever/catalogs/spells/"
    end
    if category == "npc" or owner == "npc-tooltip" then
        return "entries/forever/catalogs/npcs/catalog.lua"
    end
    if category == "object" or owner == "object-tooltip" then
        return "entries/forever/catalogs/objects/catalog.lua"
    end
    if owner == "generic" or slot:find("generic.", 1, true) == 1
        or slot == "comparison.header" then
        return "entries/forever/catalogs/ui/core.lua"
    end
end

local function diagnostic_lookup(region, visible)
    if not visible then return nil end
    local ok, translated, normalized, tier, category, slot, option, provenance =
        pcall(strings.find_ui_translation, visible, region)
    translated = ok and safe_string(translated) or nil
    if not translated then return nil end
    local catalog_source = type(provenance) == "table"
        and safe_string(provenance.source) or nil
    local result = {
        translated = translated,
        normalized = safe_string(normalized),
        lookupTier = safe_string(tier),
        category = safe_string(category),
        slot = safe_string(slot),
        option = safe_string(option),
        catalogSource = catalog_source,
    }
    result.editTarget = diagnostic_edit_target({
        owner = "generic", slot = result.slot or "generic.text",
        category = result.category, catalog_source = catalog_source,
    })
    return result
end

local function diagnostic_claim(claim, visible)
    if not claim then return nil end
    local result = {
        owner = safe_string(claim.owner),
        slot = safe_string(claim.slot),
        source = safe_string(claim.source),
        translated = safe_string(claim.translated),
        priority = safe_number(claim.priority),
        generation = safe_number(claim.generation),
        instance = diagnostic_scalar(claim.instance),
        phase = safe_string(claim.phase),
        category = safe_string(claim.category),
        lookupTier = safe_string(claim.lookup_tier),
        catalogSource = safe_string(claim.catalog_source),
    }
    result.editTarget = diagnostic_edit_target(claim)
    result.visibleMatchesSource = visible ~= nil and visible == result.source
    result.visibleMatchesTranslation = visible ~= nil
        and visible == result.translated
    if not result.visibleMatchesTranslation
        and type(claim.visible_matches) == "function" then
        local ok, matches = pcall(claim.visible_matches,
            visible, result.translated)
        result.visibleMatchesTranslation = ok and matches == true
    end
    if visible == nil then
        result.state = "text_unreadable"
    elseif result.visibleMatchesTranslation then
        result.state = "translation_visible"
    elseif result.visibleMatchesSource then
        result.state = "source_visible"
    else
        result.state = "claim_overwritten"
    end
    return result
end

local function diagnostic_region(region, location, index, side)
    if not region then return nil end
    local ok, value = pcall(function () return region:GetText() end)
    local secret = not ok or is_secret(value)
    local visible = not secret and safe_string(value) or nil
    return {
        location = location,
        index = index,
        side = side,
        region = object_label(region),
        shown = public_object_value(region, "IsShown") == true,
        secret = secret,
        visible = visible,
        claim = diagnostic_claim(runtime.get(region), visible),
        availableTranslation = diagnostic_lookup(region, visible),
    }
end

local function diagnostic_method(tooltip, method, fields)
    local ok_method, callback = pcall(function () return tooltip[method] end)
    if not ok_method or type(callback) ~= "function" then return nil end
    local ok, values = pcall(function () return { callback(tooltip) } end)
    local result = { ok = ok }
    if not ok then return result end
    for index, field in ipairs(fields) do
        result[field] = diagnostic_scalar(values[index])
    end
    return result
end

local function diagnostic_has_method(object, method)
    local ok, value = pcall(function () return object and object[method] end)
    return ok and type(value) == "function"
end

local function diagnostic_target_aura_children()
    local result = { children = {}, api = {}, enumeratedTooltips = {} }
    local ok, container = pcall(function ()
        return _G.TargetFrame
            and _G.TargetFrame.TargetFrameContent
            and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual
            and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual.Auras
    end)
    if not ok or not container then
        result.status = ok and "missing" or "inaccessible"
        return result
    end

    result.status = "found"
    result.container = {
        name = object_label(container),
        objectType = public_object_value(container, "GetObjectType"),
        shown = public_object_value(container, "IsShown") == true,
        mouseOver = public_object_value(container, "IsMouseOver") == true,
        forbidden = public_object_value(container, "IsForbidden") == true,
        protected = public_object_value(container, "IsProtected") == true,
    }

    local queue = {}
    for _, child in ipairs(object_list(container, "GetChildren")) do
        queue[#queue + 1] = { object = child, depth = 1 }
    end
    local seen = { [container] = true }
    local cursor = 1
    while cursor <= #queue and #result.children < 128 do
        local entry = queue[cursor]
        cursor = cursor + 1
        local child = entry.object
        if child and not seen[child] then
            seen[child] = true
            local icon = diagnostic_has_method(child, "GetIcon")
                and public_object_value(child, "GetIcon") or nil
            local row = {
                depth = entry.depth,
                name = object_label(child),
                objectType = public_object_value(child, "GetObjectType"),
                id = diagnostic_scalar(public_object_value(child, "GetID")),
                shown = public_object_value(child, "IsShown") == true,
                mouseOver = public_object_value(child, "IsMouseOver") == true,
                forbidden = public_object_value(child, "IsForbidden") == true,
                protected = public_object_value(child, "IsProtected") == true,
                hasGetIcon = diagnostic_has_method(child, "GetIcon"),
                hasGetAuraInstance = diagnostic_has_method(child, "GetAuraInstance"),
                hasShowTooltip = diagnostic_has_method(child, "ShowTooltip"),
                hasPopulateTooltip = diagnostic_has_method(child, "PopulateTooltip"),
                iconTexture = icon and diagnostic_scalar(
                    public_object_value(icon, "GetTexture")) or nil,
                iconAtlas = icon and diagnostic_scalar(
                    public_object_value(icon, "GetAtlas")) or nil,
            }
            result.children[#result.children + 1] = row
            if entry.depth < 5 then
                for _, descendant in ipairs(object_list(child, "GetChildren")) do
                    queue[#queue + 1] = {
                        object = descendant,
                        depth = entry.depth + 1,
                    }
                end
            end
        end
    end
    result.count = #result.children

    local unit_auras = _G.C_UnitAuras
    local get_by_index = unit_auras and unit_auras.GetAuraDataByIndex
    if type(get_by_index) == "function" then
        for _, unit in ipairs({ "player", "target" }) do
            for _, filter in ipairs({ "HELPFUL", "HARMFUL" }) do
                local group = { unit = unit, filter = filter, rows = {}, calls = 0,
                    secret = false, failed = false }
                for index = 1, 40 do
                    local aura_ok, aura = pcall(get_by_index, unit, index, filter)
                    group.calls = group.calls + 1
                    if not aura_ok then
                        group.failed = true
                        break
                    end
                    if aura == nil then break end
                    if is_secret(aura) then
                        group.secret = true
                        break
                    end
                    local fields_ok, name, spell_id, icon, instance_id = pcall(function ()
                        return aura.name, aura.spellId, aura.icon, aura.auraInstanceID
                    end)
                    if not fields_ok then
                        group.secret = true
                        break
                    end
                    group.rows[#group.rows + 1] = {
                        index = index,
                        name = diagnostic_scalar(name),
                        spellID = diagnostic_scalar(spell_id),
                        icon = diagnostic_scalar(icon),
                        auraInstanceID = diagnostic_scalar(instance_id),
                    }
                end
                result.api[#result.api + 1] = group
            end
        end
    else
        result.apiStatus = "missing"
    end

    if type(_G.EnumerateFrames) == "function" then
        local current
        for _ = 1, 10000 do
            local frame_ok, frame = pcall(_G.EnumerateFrames, current)
            if not frame_ok or not frame then break end
            current = frame
            if public_object_value(frame, "IsShown") == true
                and public_object_value(frame, "GetObjectType") == "GameTooltip" then
                result.enumeratedTooltips[#result.enumeratedTooltips + 1] = {
                    name = object_label(frame),
                    forbidden = public_object_value(frame, "IsForbidden") == true,
                    protected = public_object_value(frame, "IsProtected") == true,
                    mouseOver = public_object_value(frame, "IsMouseOver") == true,
                    parent = object_label(public_object_value(frame, "GetParent")),
                }
            end
        end
    end
    return result
end

tooltips.capture_mouse_focus = function ()
    local report = { foci = {}, targetAuras = diagnostic_target_aura_children() }
    local candidates = {}
    if type(_G.GetMouseFoci) == "function" then
        local ok, values = pcall(_G.GetMouseFoci)
        if ok and type(values) == "table" then
            for _, value in ipairs(values) do candidates[#candidates + 1] = value end
        end
    end
    if #candidates == 0 and type(_G.GetMouseFocus) == "function" then
        local ok, value = pcall(_G.GetMouseFocus)
        if ok and value then candidates[1] = value end
    end

    local seen = {}
    for focus_index, candidate in ipairs(candidates) do
        local current, depth = candidate, 0
        while current and not seen[current] and depth < 10 do
            seen[current] = true
            depth = depth + 1
            local icon = diagnostic_has_method(current, "GetIcon")
                and public_object_value(current, "GetIcon") or nil
            report.foci[#report.foci + 1] = {
                focus = focus_index,
                depth = depth,
                name = object_label(current),
                objectType = public_object_value(current, "GetObjectType"),
                id = diagnostic_scalar(public_object_value(current, "GetID")),
                forbidden = public_object_value(current, "IsForbidden") == true,
                protected = public_object_value(current, "IsProtected") == true,
                hasAuraInstance = diagnostic_has_method(current, "GetAuraInstance"),
                hasIcon = icon ~= nil,
                iconTexture = icon and diagnostic_scalar(
                    public_object_value(icon, "GetTexture")) or nil,
                iconAtlas = icon and diagnostic_scalar(
                    public_object_value(icon, "GetAtlas")) or nil,
            }
            current = public_object_value(current, "GetParent")
        end
    end
    report.count = #report.foci
    if UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.mouseProbe = report
    end
    return report
end

local function tooltip_diagnostic_snapshot(entry)
    local tooltip = entry.frame
    local result = {
        name = object_label(tooltip),
        globalName = entry.globalName,
        objectType = public_object_value(tooltip, "GetObjectType"),
        shown = public_object_value(tooltip, "IsShown") == true,
        visible = public_object_value(tooltip, "IsVisible") == true,
        owner = object_label(public_object_value(tooltip, "GetOwner")),
        parent = object_label(public_object_value(tooltip, "GetParent")),
        kind = safe_string(tooltip.uaForeverKind),
        id = safe_number(tooltip.uaForeverID),
        generation = safe_number(tooltip.uaForeverGeneration),
        sessionKey = diagnostic_scalar(tooltip.uaForeverSessionKey),
        translated = tooltip.uaForeverKey ~= nil,
        showOriginal = tooltip.uaForeverShowOriginal == true,
        hasSession = tooltip.uaForeverSessionKey ~= nil,
        events = {}, lines = {}, extraRegions = {},
    }
    if is_shopping_tooltip(tooltip) then
        result.role = "item_comparison"
    elseif tooltip == _G.GameTooltip then
        result.role = "primary"
    elseif tooltip == _G.ItemRefTooltip then
        result.role = "item_reference"
    else
        result.role = "tooltip"
    end
    if result.owner == "<anonymous>" then result.owner = nil end
    if result.parent == "<anonymous>" then result.parent = nil end
    for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
        result[measure] = safe_number(public_object_value(tooltip, measure))
    end
    for event, count in pairs(tooltip_events[tooltip] or {}) do
        result.events[event] = safe_number(count)
    end

    result.numLines = safe_number(public_object_value(tooltip, "NumLines"))
    result.item = diagnostic_method(tooltip, "GetItem", { "name", "link" })
    if result.item and result.item.link then
        result.item.id = safe_number(result.item.link:match("item:(%d+)"))
    end
    result.spell = diagnostic_method(tooltip, "GetSpell",
        { "name", "second", "third" })
    if result.spell then
        if safe_number(result.spell.third) then
            result.spell.id = safe_number(result.spell.third)
            result.spell.rank = safe_string(result.spell.second)
        elseif safe_number(result.spell.second) then
            result.spell.id = safe_number(result.spell.second)
        else
            result.spell.rank = safe_string(result.spell.second)
        end
    end
    result.unit = diagnostic_method(tooltip, "GetUnit", { "name", "token" })
    result.hyperlink = diagnostic_method(tooltip, "GetHyperlink", { "value" })

    local ok_data_method, get_tooltip_data = pcall(function ()
        return tooltip.GetTooltipData
    end)
    local ok_data, data = false, nil
    if ok_data_method and type(get_tooltip_data) == "function" then
        ok_data, data = pcall(get_tooltip_data, tooltip)
    end
    if type(data) == "table" and ok_data and not is_secret(data) then
        result.tooltipData = {
            type = diagnostic_field(data, "type"),
            id = diagnostic_field(data, "id"),
            guid = diagnostic_field(data, "guid"),
            hyperlink = diagnostic_field(data, "hyperlink"),
        }
    elseif ok_data_method and type(get_tooltip_data) == "function" then
        result.tooltipData = { ok = ok_data }
    end

    if result.item then
        if not result.item.id and result.kind == "item"
            and result.tooltipData then
            result.item.id = safe_number(result.tooltipData.id)
        end
        local item_entry = result.item.id
            and entries.get_entry("item", result.item.id) or nil
        local translated_name = item_entry and safe_string(item_entry[1])
            or result.item.name and safe_string(
                entries.lookup_name("item", result.item.name)) or nil
        result.item.catalogFound = item_entry ~= nil
            or translated_name ~= nil
        result.item.catalogName = translated_name
        result.item.editTarget =
            "entries/forever/catalogs/items/catalog.lua"
    end
    if result.spell then
        if not result.spell.id and result.kind == "spell"
            and result.tooltipData then
            result.spell.id = safe_number(result.tooltipData.id)
        end
        local spell_entry = result.spell.id
            and entries.get_entry("spell", result.spell.id) or nil
        local translated_name = spell_entry and safe_string(spell_entry[1])
            or result.spell.name and safe_string(
                entries.lookup_name("spell", result.spell.name)) or nil
        result.spell.catalogFound = spell_entry ~= nil
            or translated_name ~= nil
        result.spell.catalogName = translated_name
        result.spell.editTarget =
            "entries/forever/catalogs/spells/"
    end

    local seen_regions = {}
    local count = math.min(result.numLines or MAX_TOOLTIP_LINES,
        MAX_TOOLTIP_LINES)
    for index = 1, count do
        for _, side in ipairs({ "Left", "Right" }) do
            local _, region = tooltip_line(tooltip, side, index, true)
            if region then
                seen_regions[region] = true
                result.lines[#result.lines + 1] = diagnostic_region(region,
                    side .. tostring(index), index, side)
            end
        end
    end

    local ok_header, header = pcall(function () return tooltip.CompareHeader end)
    local ok_label, label = pcall(function () return header and header.Label end)
    if ok_header and ok_label and label then
        seen_regions[label] = true
        result.compareHeader = diagnostic_region(label,
            "CompareHeader.Label")
    end

    for index, region in ipairs(visible_tooltip_font_strings(tooltip)) do
        if not seen_regions[region] then
            result.extraRegions[#result.extraRegions + 1] = diagnostic_region(
                region, "FontString" .. tostring(index))
        end
    end
    return result
end

-- Capture every visible tooltip as plain SavedVariables-safe data. This is
-- intentionally explicit rather than exhaustive: it records the identity,
-- native tooltip data, rendered regions and translation claims needed to
-- decide whether a catalog entry is missing or a later Blizzard write won.
tooltips.capture_visible_tooltips = function (save)
    local visible = visible_tooltip_windows()
    local report = {
        version = 1,
        status = #visible > 0 and "captured" or "no_tooltip",
        count = #visible,
        tooltips = {},
    }
    if type(_G.time) == "function" then
        local ok, timestamp = pcall(_G.time)
        report.timestamp = ok and safe_number(timestamp) or nil
    end
    if type(_G.GetBuildInfo) == "function" then
        local ok, version, build, date, interface = pcall(_G.GetBuildInfo)
        if ok then
            report.client = { version = safe_string(version),
                build = safe_string(build), date = safe_string(date),
                interface = safe_number(interface) }
        end
    end
    local focus
    if type(_G.GetMouseFocus) == "function" then
        local ok, value = pcall(_G.GetMouseFocus)
        if ok and not is_secret(value) then focus = value end
    end
    if not focus and type(_G.GetMouseFoci) == "function" then
        local ok, values = pcall(_G.GetMouseFoci)
        if ok and type(values) == "table" and not is_secret(values)
            and not is_secret(values[1]) then focus = values[1] end
    end
    if focus then report.mouseFocus = object_label(focus) end
    for _, entry in ipairs(visible) do
        report.tooltips[#report.tooltips + 1] =
            tooltip_diagnostic_snapshot(entry)
    end
    if save ~= false and UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.tooltipProbe = report
    end
    return report
end

-- One-shot diagnostic of every object under the visible tooltip window.
-- It never formats protected values and records only a marker for secret text.
tooltips.scan_window = function (save)
    local root = visible_tooltip_window()
    local report = { status = root and "captured" or "no_tooltip",
        root = root and object_label(root) or nil, objects = {}, topLevel = {} }
    for _, frame in ipairs(object_list(_G.UIParent, "GetChildren")) do
        if public_object_value(frame, "IsShown") == true then
            report.topLevel[#report.topLevel + 1] = {
                name = object_label(frame),
                kind = public_object_value(frame, "GetObjectType"),
            }
        end
    end
    local focus
    if type(_G.GetMouseFocus) == "function" then
        local ok, value = pcall(_G.GetMouseFocus)
        if ok and not is_secret(value) then focus = value end
    end
    if not focus and type(_G.GetMouseFoci) == "function" then
        local ok, values = pcall(_G.GetMouseFoci)
        if ok and not is_secret(values) and type(values) == "table"
            and not is_secret(values[1]) then focus = values[1] end
    end
    if focus then report.mouseFocus = object_label(focus) end
    if root then
        local count = public_object_value(root, "NumLines")
        report.tooltip = {
            numLines = safe_number(count),
            kind = safe_string(root.uaForeverKind),
            id = safe_number(root.uaForeverID),
            showOriginal = root.uaForeverShowOriginal == true,
            hasSession = root.uaForeverSessionKey ~= nil,
            translated = root.uaForeverKey ~= nil,
            lines = tooltips.inspect(root, 12),
        }
        for event, event_count in pairs(tooltip_events[root] or {}) do
            report.tooltip[event] = event_count
        end
        if root == _G.GameTooltip then
            report.tooltip.minimapHandler = "linewise-v1"
            local before = tooltip_line(root, "Left", 1)
            before = safe_string(before)
            if before and minimap_tooltip_owner(root) then
                local ok, applied = pcall(translate_minimap_tooltip, root)
                local after, region = tooltip_line(root, "Left", 1)
                local claim = region and runtime.get(region)
                report.tooltip.probe = {
                    ok = ok, applied = ok and applied == true,
                    before = before,
                    after = safe_string(after),
                    claim = claim and claim.slot or nil,
                }
            end
        end
        local owner = public_object_value(root, "GetOwner")
        if owner then report.owner = object_label(owner) end
        local seen = {}
        local function visit(object, path, depth)
            if not object or seen[object] or #report.objects >= 3000 then return end
            seen[object] = true
            local row = {
                path = path, name = object_label(object),
                kind = public_object_value(object, "GetObjectType"),
                shown = public_object_value(object, "IsShown") == true,
            }
            for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
                row[measure] = safe_number(public_object_value(object, measure))
            end
            local ok_text, value = pcall(function ()
                return type(object.GetText) == "function" and object:GetText() or nil
            end)
            if ok_text then
                if is_secret(value) then
                    row.secretText = true
                elseif type(value) == "string" then
                    row.text = value:sub(1, 1000)
                    if #value > 1000 then row.textTruncated = true end
                end
            end
            report.objects[#report.objects + 1] = row
            if depth >= 20 then return end
            for index, region in ipairs(object_list(object, "GetRegions")) do
                visit(region, path .. "/region:" .. index, depth + 1)
            end
            for index, child in ipairs(object_list(object, "GetChildren")) do
                visit(child, path .. "/child:" .. index, depth + 1)
            end
        end
        visit(root, "root", 0)
        report.truncated = #report.objects >= 3000
    end
    if save ~= false and UA_ForeverDB then
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        UA_ForeverDB.scan.windowProbe = report
    end
    return report
end

-- Exhaustive walk of the UI object graph available to addon Lua. The walk is
-- spread across frames so thousands of hidden objects do not freeze the UI.
tooltips.multiline_tooltip_visible = function ()
    local tooltip = _G.GameTooltip
    if not tooltip then return false end
    local ok, shown = pcall(tooltip.IsShown, tooltip)
    if not ok or not shown then return false end
    local source = tooltip_line(tooltip, "Left", 1)
    source = safe_string(source)
    return source and source:find("\n", 1, true) ~= nil
        and source:find("|TInterface\\Minimap\\", 1, true) ~= nil
        or false
end

tooltips.scan_all_objects = function (on_complete, duration_seconds)
    if tooltips.fullScan and tooltips.fullScan.status == "running" then
        return tooltips.fullScan
    end
    if not UA_ForeverDB then return { status = "no_saved_variables" } end
    UA_ForeverDB.scan = UA_ForeverDB.scan or {}
    local duration = type(duration_seconds) == "number" and duration_seconds > 0
        and duration_seconds or 0
    local report = {
        status = "running", objects = {}, globalStrings = {},
        duration = duration, passes = 0,
        stats = { frames = 0, regions = 0, texts = 0, secretTexts = 0,
            globals = 0, errors = 0, textVariants = 0 },
    }
    if type(_G.GetMouseFocus) == "function" then
        local ok, focus = pcall(_G.GetMouseFocus)
        if ok and focus and not is_secret(focus) then
            report.focus = object_label(focus)
        end
    end
    local tooltip = _G.GameTooltip
    if tooltip then
        local source = tooltip_line(tooltip, "Left", 1)
        local ok, lines = pcall(tooltip.NumLines, tooltip)
        report.tooltipAtStart = {
            text = safe_string(source),
            numLines = ok and safe_number(lines) or nil,
            height = safe_number(public_object_value(tooltip, "GetHeight")),
        }
    end
    UA_ForeverDB.scan.fullObjectScan = report
    tooltips.fullScan = report

    local seen, queued_pass, counted = {}, {}, {}
    local queue, head, pass_number, elapsed_total = {}, 1, 1, 0
    local enumerator, enumerated, previous_frame = _G.EnumerateFrames, false, nil
    local global_key, globals_done = nil, false
    local function enqueue(object, global_name)
        if is_secret(object) then return nil end
        local object_type = type(object)
        if object_type ~= "table" and object_type ~= "userdata" then return nil end
        local old = seen[object]
        if old then
            if global_name and #old.globalNames < 12 then
                local known = false
                for _, name in ipairs(old.globalNames) do
                    if name == global_name then known = true; break end
                end
                if not known then old.globalNames[#old.globalNames + 1] = global_name end
            end
            if queued_pass[object] ~= pass_number then
                queue[#queue + 1] = object
                queued_pass[object] = pass_number
            end
            return old.id
        end
        local ok, getter = pcall(function () return object.GetObjectType end)
        if not ok or type(getter) ~= "function" then return nil end
        local row = { id = #report.objects + 1, globalNames = {},
            children = {}, regions = {} }
        if global_name then row.globalNames[1] = global_name end
        report.objects[row.id] = row
        seen[object] = row
        queue[#queue + 1] = object
        queued_pass[object] = pass_number
        return row.id
    end
    for _, root in ipairs({ _G.UIParent, _G.WorldFrame, _G.GameTooltip,
        _G.Minimap }) do
        enqueue(root)
    end

    local function members(object, method, output)
        local ok_get, getter = pcall(function () return object[method] end)
        if not ok_get or type(getter) ~= "function" then return end
        local ok, values = pcall(function () return { getter(object) } end)
        if not ok then
            report.stats.errors = report.stats.errors + 1
            return
        end
        for _, value in ipairs(values) do
            local id = enqueue(value)
            if id then output[#output + 1] = id end
        end
    end

    local function process(object)
        local row = seen[object]
        row.children, row.regions = {}, {}
        row.name = object_label(object)
        row.kind = public_object_value(object, "GetObjectType") or "unknown"
        row.shown = public_object_value(object, "IsShown") == true
        row.visible = public_object_value(object, "IsVisible") == true
        row.parent = enqueue(public_object_value(object, "GetParent"))
        for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
            row[measure] = safe_number(public_object_value(object, measure))
        end
        for _, getter_name in ipairs({ "GetText", "GetTitle", "GetLabel",
            "GetDescription", "GetHyperlink" }) do
            local ok_get, getter = pcall(function () return object[getter_name] end)
            if ok_get and type(getter) == "function" then
                local ok, value = pcall(getter, object)
                if not ok then
                    report.stats.errors = report.stats.errors + 1
                elseif is_secret(value) then
                    row.secretTexts = row.secretTexts or {}
                    row.secretTexts[#row.secretTexts + 1] = getter_name
                    report.stats.secretTexts = report.stats.secretTexts + 1
                elseif type(value) == "string" then
                    row.texts = row.texts or {}
                    row.texts[getter_name] = value
                    report.stats.texts = report.stats.texts + 1
                    row.textVariants = row.textVariants or {}
                    local variants = row.textVariants[getter_name]
                    if not variants then
                        variants = {}
                        row.textVariants[getter_name] = variants
                    end
                    local known = false
                    for _, previous in ipairs(variants) do
                        if previous == value then known = true; break end
                    end
                    if not known then
                        variants[#variants + 1] = value
                        report.stats.textVariants = report.stats.textVariants + 1
                    end
                end
            end
        end
        members(object, "GetRegions", row.regions)
        members(object, "GetChildren", row.children)
        if not counted[object] then
            counted[object] = true
            if row.kind == "FontString" or row.kind == "Texture" then
                report.stats.regions = report.stats.regions + 1
            else
                report.stats.frames = report.stats.frames + 1
            end
        end
    end

    local worker = CreateFrame("Frame")
    tooltips.fullScanWorker = worker
    worker:SetScript("OnUpdate", function (_, elapsed)
        elapsed_total = elapsed_total + (type(elapsed) == "number" and elapsed or 0)
        if not enumerated then
            if type(enumerator) == "function" then
                for _ = 1, 500 do
                    local ok, frame = pcall(enumerator, previous_frame)
                    if not ok then
                        report.stats.errors = report.stats.errors + 1
                        report.frameEnumerationError = true
                        enumerated = true
                        break
                    end
                    if not frame then enumerated = true; break end
                    if frame == previous_frame then
                        report.stats.errors = report.stats.errors + 1
                        report.frameEnumerationError = true
                        enumerated = true
                        break
                    end
                    previous_frame = frame
                    enqueue(frame)
                end
            else
                enumerated = true
                report.enumerateFramesUnavailable = true
            end
        end
        if not globals_done then
            for _ = 1, 500 do
                local ok, key, value = pcall(next, _G, global_key)
                if not ok then
                    report.stats.errors = report.stats.errors + 1
                    report.globalEnumerationError = true
                    globals_done = true
                    break
                end
                if key == nil then globals_done = true; break end
                global_key = key
                if not is_secret(key) and type(key) == "string" then
                    if not is_secret(value) and type(value) == "string" then
                        if report.globalStrings[key] == nil then
                            report.stats.globals = report.stats.globals + 1
                        end
                        report.globalStrings[key] = value
                    else
                        enqueue(value, key)
                    end
                end
            end
        end
        for _ = 1, 500 do
            local object = queue[head]
            if not object then break end
            queue[head] = false
            head = head + 1
            process(object)
        end
        if enumerated and globals_done and head > #queue then
            report.passes = pass_number
            report.totalObjects = #report.objects
            if duration > 0 and elapsed_total < duration then
                pass_number = pass_number + 1
                queue, head = {}, 1
                previous_frame, enumerated = nil, false
                global_key, globals_done = nil, false
                for _, root in ipairs({ _G.UIParent, _G.WorldFrame,
                    _G.GameTooltip, _G.Minimap }) do
                    enqueue(root)
                end
            else
                report.status = (report.frameEnumerationError
                    or report.globalEnumerationError or report.enumerateFramesUnavailable)
                    and "partial" or "complete"
                worker:SetScript("OnUpdate", nil)
                tooltips.fullScanWorker = nil
                if type(on_complete) == "function" then pcall(on_complete, report) end
            end
        end
    end)
    return report
end

local function schedule_tooltip_finalize(tooltip)
    local generation = tooltip.uaForeverGeneration
    local function finalize()
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if ok and shown then
            if aura_tooltip_context(tooltip) then
                mark_aura_tooltip(tooltip)
                after_aura_tooltip_rendered(tooltip)
                return
            end
            local spell_id = visible_spell_id(tooltip)
            if spell_id and entries.get_entry("spell", spell_id) then
                safe_process(tooltip, { id = spell_id, spellID = spell_id }, "spell")
            else
                translate_generic_tooltip(tooltip)
            end
            capture_generic_tooltip_ui(tooltip)
        end
    end
    scheduler.request("tooltip:" .. tostring(tooltip), generation,
        finalize, nil, tooltip)
    -- Some aura FontStrings arrive after the first deferred pass without
    -- another OnShow or OnTooltipCleared event. Retry once, for this generation.
    scheduler.request("tooltip-late:" .. tostring(tooltip), generation,
        finalize, 0.2, tooltip)
end

after_aura_tooltip_rendered = function (tooltip)
    if not tooltip or is_secret(tooltip) then return end
    mark_aura_tooltip(tooltip)
    note_tooltip_event(tooltip, "auraMethod")
    local aura_ok, _, observed_spell_id, inferred_by_title =
        pcall(translate_unit_aura_tooltip, tooltip)
    observed_spell_id = aura_ok and safe_number(observed_spell_id) or nil
    inferred_by_title = aura_ok and inferred_by_title == true
    local metadata_ok, tooltip_id, kind, key = pcall(function ()
        return tooltip.uaForeverID, tooltip.uaForeverKind, tooltip.uaForeverKey
    end)
    if options.account and options.account.auto_scan_content and metadata_ok then
        local capture_id = observed_spell_id
            or not inferred_by_title and safe_number(tooltip_id) or nil
        local missing_entry = capture_id
            and not entries.get_entry("spell", capture_id) or nil
        pcall(auto_scan.capture_tooltip, tooltip, "aura",
            capture_id, missing_entry)
    end
    if metadata_ok and kind == "aura" and key then
        scheduler.cancel("tooltip:" .. tostring(tooltip))
        scheduler.cancel("tooltip-late:" .. tostring(tooltip))
    end
end

local function prepare_tooltip_frames()
    -- Bag buttons copy their mixin methods when the frames are created, so a
    -- later hook on BaseBagSlotButtonMixin does not reach those buttons.
    -- GameTooltip_SetTitle runs after ClearLines/AddLine but before Show.
    hooks.global("GameTooltip_SetTitle", function (tooltip, native)
        native = safe_string(native)
        if tooltip ~= _G.GameTooltip or not native
            or type(tooltip.GetOwner) ~= "function"
            or (native ~= _G.EQUIP_CONTAINER
                and native ~= _G.EQUIP_CONTAINER_REAGENT) then return end
        local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
        if not owner_ok or not owner or type(owner.GetBagID) ~= "function"
            or type(owner.GetID) ~= "function" then return end
        local source, region = tooltip_line(tooltip, "Left", 1, true)
        if source ~= native or not region then return end
        local translated = strings.find_ui_translation(native, region)
        if not translated or translated == native then return end
        begin_tooltip(tooltip, "empty-bag-slot:" .. tostring(owner))
        local applied = set_tooltip_translation(tooltip, region, native,
            translated, "bag.slot", nil, "bag-slot", nil, false, false)
        if applied then tooltip.uaForeverKind = "empty-bag-slot" end
    end)
    local item_util = _G.ItemUtil
    if item_util and type(item_util.GetEmptyEquipSlotTooltip) == "function" then
        hooks.region(item_util, "DisplayEquipSlotTooltip",
            function (frame, tooltip, equip_slot)
                if not frame or not tooltip or type(tooltip.GetOwner) ~= "function" then
                    return
                end
                local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
                if not owner_ok or owner ~= frame then return end
                local text_ok, native = pcall(item_util.GetEmptyEquipSlotTooltip,
                    equip_slot)
                native = text_ok and safe_string(native) or nil
                if not native then return end
                local source, region = tooltip_line(tooltip, "Left", 1)
                if source ~= native or not region then return end
                local translated = strings.find_ui_translation(native, region)
                if not translated or translated == native then return end
                begin_tooltip(tooltip, "empty-equip:" .. tostring(frame))
                local applied = set_tooltip_translation(tooltip, region, native, translated,
                    "equipment.slot", nil, "equipment-slot", nil, false, true)
                if applied then tooltip.uaForeverKind = "equipment-slot" end
            end)
    end
    local tooltip_frames, seen_tooltips = {}, {}
    for _, name in ipairs({ "GameTooltip", "SettingsTooltip", "ItemRefTooltip",
        "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefShoppingTooltip1",
        "ItemRefShoppingTooltip2", "EmbeddedItemTooltip",
        "BuffFrameTooltip" }) do
        local tooltip = _G[name]
        if tooltip and not seen_tooltips[tooltip] then
            tooltip_frames[#tooltip_frames + 1] = tooltip
            seen_tooltips[tooltip] = true
        end
    end
    for _, tooltip in ipairs(tooltip_frames) do
        if tooltip then
            if tooltip == _G.GameTooltip then
                hooks.region(tooltip, "SetUnit", function (self)
                    note_tooltip_event(self, "unitMethod")
                    translate_player_unit_tooltip(self)
                end)
                hooks.region(tooltip, "SetTrainerService", function (self, index)
                    if is_secret(index) then return end
                    begin_tooltip(self, "trainer:" .. tostring(index))
                    self.uaForeverKind = "trainer"
                    rewrite_generic_lines(self)
                    auto_scan.capture_tooltip(self, "trainer")
                    local generation = self.uaForeverGeneration
                    scheduler.request("tooltip-trainer:" .. tostring(self), generation,
                        function ()
                            local ok, shown = pcall(self.IsShown, self)
                            if ok and shown and self.uaForeverKind == "trainer" then
                                rewrite_generic_lines(self)
                                auto_scan.capture_tooltip(self, "trainer")
                            end
                        end, nil, self)
                    scheduler.request("auto-tooltip-trainer:" .. tostring(self),
                        generation, function ()
                            local ok, shown = pcall(self.IsShown, self)
                            if ok and shown and self.uaForeverKind == "trainer" then
                                auto_scan.capture_tooltip(self, "trainer")
                            end
                        end, 0.15, self)
                end)
                hooks.region(tooltip, "SetText", function (self, native)
                    translate_cursor_tooltip_title(self, native)
                    translate_object_tooltip_title(self)
                end)
            end
            hooks.region_script(tooltip, "OnShow", function (self)
                note_tooltip_event(self, "onShow")
                if not self.uaForeverSessionKey then begin_tooltip(self, "generic") end
                arm_tooltip_updates(self)
                if self == _G.GameTooltip and type(self.GetOwner) == "function" then
                    local owner_ok, owner = pcall(self.GetOwner, self)
                    if owner_ok and is_character_stat_owner(owner) then
                        tooltips.translate_character_stat(owner)
                    end
                end
                if is_shopping_tooltip(self) then
                    -- Comparison frames are rebuilt by RefreshItems. A delayed
                    -- pass can resize them after the native layout is visible.
                    translate_shopping_tooltip(self)
                    local generation = self.uaForeverGeneration
                    scheduler.request("tooltip-comparison:" .. tostring(self),
                        generation, function ()
                            local ok, shown = pcall(self.IsShown, self)
                            if ok and shown then translate_shopping_tooltip(self) end
                        end, nil, self)
                else
                    schedule_tooltip_finalize(self)
                end
            end)
            hooks.region_script(tooltip, "OnTooltipCleared", function (self)
                    note_tooltip_event(self, "onTooltipCleared")
                    reset_tooltip(self)
                    arm_tooltip_updates(self, 3)
                    if self == _G.GameTooltip then arm_minimap_watcher() end
                    if not is_shopping_tooltip(self) then
                        schedule_tooltip_finalize(self)
                    end
                end)
            hooks.region_script(tooltip, "OnHide", reset_tooltip)
            -- Camelot target-frame aura buttons use ShowAuraTooltip and hide
            -- their owner from GetOwner(). Ignore its potentially secret
            -- arguments and translate only the tooltip that Blizzard rendered.
            hooks.region(tooltip, "ShowAuraTooltip", function (self)
                mark_aura_tooltip(self)
                after_aura_tooltip_rendered(self)
            end)
            -- Setter callbacks ignore their potentially secret aura arguments.
            for _, method in ipairs({ "SetUnitAuraByAuraInstanceID",
                "SetUnitBuffByAuraInstanceID", "SetUnitDebuffByAuraInstanceID", "SetUnitAura",
                "SetUnitBuff", "SetUnitDebuff" }) do
                hooks.region(tooltip, method, function (self)
                    -- These setters normally finish before GameTooltip is
                    -- shown. The old IsShown guard dropped player-buff auras
                    -- at exactly this point and the later generic pass then
                    -- classified them as ordinary spells.
                    mark_aura_tooltip(self)
                    after_aura_tooltip_rendered(self)
                end)
            end
        end
    end
end

local function after_game_tooltip_update(tooltip)
    if tooltip ~= _G.GameTooltip or type(tooltip.GetOwner) ~= "function" then return end
    local budget = tooltip.uaForeverUpdateBudget or 0
    if budget <= 0 then return end
    tooltip.uaForeverUpdateBudget = budget - 1
    -- Unit tooltips can be rewritten in place as threat and unit details change.
    -- The Unit post-call does not always run for those subsequent name writes.
    npc_adapter.refresh_name(tooltip)
    if tooltip.uaForeverKind == "player" then
        translate_player_tooltip_identity(tooltip)
    end
    local combat_ok, in_combat = false, false
    if type(_G.InCombatLockdown) == "function" then
        combat_ok, in_combat = pcall(_G.InCombatLockdown)
    end
    if combat_ok and not is_secret(in_combat) and in_combat == true
        and (tooltip.uaForeverKind == "npc" or tooltip.uaForeverKind == "player") then
        npc_adapter.refresh_subtitle(tooltip)
        local time_ok, now = pcall(_G.GetTime)
        now = time_ok and safe_number(now) or nil
        if now and now >= (tooltip.uaForeverUnitRefreshAt or 0) then
            tooltip.uaForeverUnitRefreshAt = now + 0.1
            rewrite_generic_lines(tooltip, nil, tooltip.uaForeverReservedFirst or 2,
                false, false)
            if tooltip.uaForeverKind == "npc" then
                quest_adapter.translate_embedded(tooltip)
            end
        end
    end
    -- Minimap tracking blips can rewrite the visible title without calling
    -- SetText or starting a new tooltip session. Check that rendered line too.
    local current_title = tooltip_line(tooltip, "Left", 1)
    current_title = safe_string(current_title)
    if current_title then
        translate_cursor_tooltip_title(tooltip, current_title)
        translate_object_tooltip_title(tooltip)
    end
    translate_minimap_tooltip(tooltip)
    if minimap_tooltip_owner(tooltip) then
        quest_adapter.translate_embedded(tooltip)
    end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    if owner_ok and owner and _G.Minimap then
        local current = owner
        for _ = 1, 8 do
            if current == _G.Minimap or current == _G.MinimapCluster then
                local title = tooltip_line(tooltip, "Left", 1)
                title = safe_string(title)
                if title and type(entries.lookup_id) == "function" then
                    local id = entries.lookup_id("quest", title)
                    local entry = id and entries.get_entry("quest", id)
                    if entry and entry.en == title then
                        safe_process(tooltip, { id = id }, "quest")
                    end
                end
                break
            end
            local parent_ok, parent = pcall(function ()
                return type(current.GetParent) == "function"
                    and current:GetParent() or nil
            end)
            if not parent_ok or not parent or parent == current then break end
            current = parent
        end
    end
    if owner_ok and is_character_stat_owner(owner) then
        local title, region = tooltip_line(tooltip, "Left", 1)
        local claim = region and runtime.get(region)
        if not claim or title ~= claim.translated then
            tooltips.translate_character_stat(owner)
        end
    end
    if owner_ok and owner and owner.objectType == "item"
        and owner.questID then
        tooltips.refresh_quest_reward(tooltip, owner)
    end
end

tooltips.prepare = function ()
    prepare_quest_map_hook()
    prepare_tooltip_frames()
    hooks.region(_G.TooltipComparisonManager, "RefreshItems",
        after_comparison_refresh)
    hooks.region_script(_G.GameTooltip, "OnUpdate", after_game_tooltip_update,
        "quest-reward")
    arm_tooltip_updates(_G.GameTooltip)
    hooks.region(_G.GameTooltipTextLeft1, "SetText", function (region)
        if runtime.is_applying(region) then return end
        local tooltip = _G.GameTooltip
        if not tooltip then return end
        arm_tooltip_updates(tooltip, 3)
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if ok and shown then
            if minimap_tooltip_candidate(tooltip) then
                translate_minimap_tooltip(tooltip)
            elseif tooltip.uaForeverKind == "object"
                or world_cursor_owner(tooltip) then
                schedule_tooltip_finalize(tooltip)
            end
        end
    end)
    -- Minimap blips can be rebuilt after OnTooltipCleared. Arm a short watcher
    -- only around that lifecycle edge; it removes its OnUpdate after 3 passes.
    if not tooltips.minimapWatcher and type(_G.CreateFrame) == "function" then
        local watcher = CreateFrame("Frame")
        local function update_minimap(self)
            self = self or watcher
            local tooltip = _G.GameTooltip
            if tooltip and minimap_tooltip_candidate(tooltip) then
                local ok, shown = pcall(tooltip.IsShown, tooltip)
                if ok and shown then translate_minimap_tooltip(tooltip) end
            end
            self.uaForeverPasses = (self.uaForeverPasses or 1) - 1
            if self.uaForeverPasses <= 0 then
                self:SetScript("OnUpdate", nil)
            end
        end
        tooltips.minimapWatcherCallback = update_minimap
        tooltips.minimapWatcher = watcher
        arm_minimap_watcher = function ()
            watcher.uaForeverPasses = 3
            watcher:SetScript("OnUpdate", update_minimap)
        end
    end
    if tooltips.prepared then return end

    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType then
        dev_log.issue("TooltipDataProcessor недоступний")
        return
    end
    tooltips.prepared = true
    prepare_target_aura_overlay()

    if _G.EventRegistry and type(_G.EventRegistry.RegisterCallback) == "function" then
        _G.EventRegistry:RegisterCallback("TalentDisplay.TooltipCreated",
            talent_adapter.translate, tooltips)
    end
    local types = Enum.TooltipDataType
    if types.Item then
        TooltipDataProcessor.AddTooltipPostCall(types.Item, function (tooltip, data)
            if is_shopping_tooltip(tooltip) then
                if not tooltip.uaForeverSessionKey then
                    begin_tooltip(tooltip, "comparison")
                end
                translate_shopping_tooltip(tooltip)
            else
                safe_process(tooltip, data, "item")
            end
        end)
    end
    if types.Spell then
        TooltipDataProcessor.AddTooltipPostCall(types.Spell, function (tooltip, data)
            if not tooltip.uaForeverTargetAuraMeasuring then
                if aura_tooltip_context(tooltip) then
                    mark_aura_tooltip(tooltip)
                    safe_process(tooltip, data, "aura")
                else
                    safe_process(tooltip, data, "spell")
                end
            end
        end)
    end
    if types.Unit then
        TooltipDataProcessor.AddTooltipPostCall(types.Unit, function (tooltip, data)
            safe_process(tooltip, data, "npc")
        end)
    end
    if types.Quest then
        TooltipDataProcessor.AddTooltipPostCall(types.Quest, function (tooltip, data)
            safe_process(tooltip, data, "quest")
        end)
    end
    if types.Object then
        TooltipDataProcessor.AddTooltipPostCall(types.Object, function (tooltip, data)
            safe_process(tooltip, data, "object")
        end)
    end
    if types.MinimapMouseover then
        TooltipDataProcessor.AddTooltipPostCall(types.MinimapMouseover,
            function (tooltip)
                if tooltip ~= _G.GameTooltip then return end
                translate_minimap_tooltip(tooltip)
                quest_adapter.translate_embedded(tooltip)
            end)
    end

    local shift_frame = CreateFrame("Frame")
    shift_frame:RegisterEvent("MODIFIER_STATE_CHANGED")
    shift_frame:SetScript("OnEvent", function (_, _, key)
        if key ~= "LSHIFT" and key ~= "RSHIFT" then return end
        tooltips.refresh_active()
    end)
end

tooltips.refresh_active = function ()
    local show = shift_held() or not options.can_translate()
    for tooltip in pairs(active_tooltips) do
        tooltip.uaForeverShowOriginal = show
        runtime.for_each_claim(tooltip, function (region, claim)
            local disabled = claim and claim.option
                and not options.can_translate(claim.option)
            for _, option in ipairs(claim and claim.options or {}) do
                if not options.can_translate(option) then disabled = true end
            end
            runtime.show_original(region,
                show or disabled or options.is_bilingual_tooltip())
        end)
        tooltip_font_strings[tooltip] = nil
        local used = {}
        for _, fallback in pairs(tooltip.uaForeverFallback or {}) do
            if fallback.region then used[fallback.region] = true end
        end
        for _, fallback in pairs(tooltip.uaForeverFallback or {}) do
            if not fallback.region then
                for _, candidate in ipairs(visible_tooltip_font_strings(tooltip)) do
                    if not used[candidate] and not runtime.get(candidate)
                        and type(candidate.GetText) == "function" then
                        local ok, value = pcall(candidate.GetText, candidate)
                        if ok and not is_secret(value)
                            and value == fallback.translated then
                            fallback.region = candidate
                            used[candidate] = true
                            break
                        end
                    end
                end
            end
            if fallback.region and fallback.region.SetText then
                local name_disabled = fallback.category
                    and fallback.slot:match("%.name$")
                    and not options.translate_name(fallback.category)
                local domain_disabled = fallback.option
                    and not options.can_translate(fallback.option)
                for _, option in ipairs(fallback.options or {}) do
                    if not options.can_translate(option) then domain_disabled = true end
                end
                runtime.set_fallback_text(fallback.region,
                    (show or name_disabled or domain_disabled
                        or (not fallback.force and not options.is_bilingual_tooltip()))
                        and "" or fallback.translated)
            end
        end
        if not show then
            if tooltip.uaForeverKind == "character-stat" then
                local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
                if owner_ok and owner then tooltips.translate_character_stat(owner) end
            elseif tooltip.uaForeverKind and tooltip.uaForeverID then
                safe_process(tooltip, { uaForeverID = tooltip.uaForeverID,
                    id = tooltip.uaForeverID, spellID = tooltip.uaForeverID },
                    tooltip.uaForeverKind)
            else
                translate_generic_tooltip(tooltip)
            end
        end
    end
end
