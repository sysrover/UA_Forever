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
local comparison_adapter = addon_table.use("tooltip_comparison_adapter")
local npc_adapter = addon_table.use("tooltip_npc_adapter")
local quest_adapter = addon_table.use("tooltip_quest_adapter")
local map_adapter = addon_table.use("tooltip_map_adapter")
local spell_adapter = addon_table.use("tooltip_spell_adapter")
local talent_adapter = addon_table.use("tooltip_talent_adapter")
local tooltip_diagnostics = addon_table.use("tooltip_diagnostics")
local hooks = addon_table.use("translation_hooks").bind("tooltips")
local tooltips = addon_table.use("tooltips")
local utils = addon_table.use("utils")
local tooltip_catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local tooltip_format = tooltip_catalog.format
local tooltip_line
local tooltip_line_region
local visible_tooltip_font_strings
local visible_spell_id
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
    local account = options.account
    if not account or (account.dev_mode ~= true
        and account.auto_scan_diagnostics ~= true) then return end
    local counts = tooltip_events[tooltip] or {}
    counts[event] = (counts[event] or 0) + 1
    tooltip_events[tooltip] = counts
end

local function shift_held()
    return options.account and options.account.shift_original_tooltip ~= false
        and type(_G.IsShiftKeyDown) == "function" and _G.IsShiftKeyDown()
end

local function begin_tooltip(tooltip, key, force)
    local started = tooltip_session.begin(tooltip, key,
        shift_held() or not options.can_translate(), function (region)
        character_stat_line_heights[region] = nil
    end, force)
    if not started then return end
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

local function set_tooltip_translation(tooltip, region, source, translated, slot, category, owner, source_kind, allow_fallback, adjust_layout, after_visibility, visible_matcher, catalog_source, runtime_flags)
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
        local after_apply
        if adjust_layout ~= false and not combat_tooltip_text then
            after_apply = function (applied)
                layout.fit_tooltip_width_to_region(tooltip, applied, source)
                layout.fit_tooltip_height_to_region(tooltip, applied,
                    previous_height, previous_tooltip_height)
                layout.fit_bag_tooltip_width(tooltip, applied, source)
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
            after_apply = after_apply,
            after_visibility = visibility_callback,
            visible_matches = visible_matcher,
            record_runtime = not runtime_flags
                or runtime_flags.record_runtime ~= false,
            verify_after_apply = not runtime_flags
                or runtime_flags.verify_after_apply ~= false,
            reapply_cached = runtime_flags
                and runtime_flags.reapply_cached == true,
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

    local direct_line_access = false
    local getter_ok, getter = pcall(function () return tooltip.GetLeftLine end)
    if getter_ok and type(getter) == "function" then
        direct_line_access = true
    elseif type(tooltip.GetName) == "function" then
        local name_ok, name = pcall(tooltip.GetName, tooltip)
        direct_line_access = name_ok and safe_string(name) ~= nil
    end
    local before
    if not direct_line_access then
        before = {}
        for _, existing in ipairs(visible_tooltip_font_strings(tooltip)) do
            before[existing] = true
        end
    end
    local ok = runtime.add_fallback(tooltip, translated, r, g, b)
    if ok then
        tooltip.uaForeverBilingualLines[key] = true
        tooltip_font_strings[tooltip] = nil
        local fallback_region
        local count_ok, count = pcall(tooltip.NumLines, tooltip)
        if count_ok and safe_number(count) then
            local _, found = tooltip_line(tooltip, "Left", count)
            fallback_region = found
        end
        if not fallback_region and before then
            for _, candidate in ipairs(visible_tooltip_font_strings(tooltip)) do
                if not before[candidate] then fallback_region = candidate end
            end
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

local function rewrite_generic_lines(tooltip, line_count, first_index, allow_fallback, adjust_layout, snapshot, only_indexes)
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
    runtime.metric("line_passes", tooltip, tooltip.uaForeverGeneration)

    for index = first_index or 1, line_count do
        if not only_indexes or only_indexes[index] then
            local row = snapshot and snapshot[index]
            local left = row and row.left and row.left.source
            local left_region = row and row.left and row.left.region
            local right = row and row.right and row.right.source
            local right_region = row and row.right and row.right.region
            if not snapshot then
                left, left_region = tooltip_line(tooltip, "Left", index)
                right, right_region = tooltip_line(tooltip, "Right", index)
            end
            local left_stable = runtime.is_stable_claim(left_region, tooltip,
                tooltip.uaForeverGeneration)
            local right_stable = runtime.is_stable_claim(right_region, tooltip,
                tooltip.uaForeverGeneration)
            runtime.metric("stable_claim_hits", tooltip,
                tooltip.uaForeverGeneration,
                (left_stable and 1 or 0) + (right_stable and 1 or 0))
            runtime.metric("tooltip_resolver_calls", tooltip,
                tooltip.uaForeverGeneration,
                (left and not left_stable and 1 or 0)
                    + (right and not right_stable and 1 or 0))
            local translated_left, _, left_kind, _, _, _, left_provenance
            local translated_right, _, right_kind, _, _, _, right_provenance
            if not left_stable then
                translated_left, _, left_kind, _, _, _, left_provenance =
                    strings.find_ui_translation(left, left_region)
            end
            if not right_stable then
                translated_right, _, right_kind, _, _, _, right_provenance =
                    strings.find_ui_translation(right, right_region)
            end
            if translated_left and translated_left ~= left then
                if set_tooltip_translation(tooltip, left_region, left,
                    translated_left, "generic.left:" .. index, nil, "generic",
                    left_kind, allow_fallback, adjust_layout, nil, nil,
                    left_provenance and left_provenance.source) then
                    applied = applied + 1
                end
            end
            if translated_right and translated_right ~= right then
                if set_tooltip_translation(tooltip, right_region, right,
                    translated_right, "generic.right:" .. index, nil, "generic",
                    right_kind, allow_fallback, adjust_layout, nil, nil,
                    right_provenance and right_provenance.source) then
                    applied = applied + 1
                end
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
    line_region = function (...) return tooltip_line_region(...) end,
    translate_static = function (source, region)
        local translated, _, source_kind = strings.find_ui_translation(
            source, region)
        return translated, source_kind
    end,
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
    safe_dimension = layout.safe_dimension,
    finish_layout = function (tooltip, snapshot)
        local in_combat = false
        if type(_G.InCombatLockdown) == "function" then
            local ok, value = pcall(_G.InCombatLockdown)
            in_combat = ok and not is_secret(value) and value == true
        end
        if not in_combat then return layout.fit_tooltip_snapshot(tooltip, snapshot) end
        runtime.defer_layout(tooltip, function (current)
            local retry_snapshot = item_adapter.snapshot(current)
            if retry_snapshot then layout.fit_tooltip_snapshot(current, retry_snapshot) end
        end)
        return false
    end,
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

local function process(tooltip, data, kind, native_rebuild)
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
    elseif kind == "spell" then
        id = safe_number(data.id)
    elseif kind == "aura" then
        -- Camelot exposes secret aura values in combat. Only use a public
        -- numeric spell ID; never compare, format, or cache a secret value.
        id = safe_number(data.spellID)
        if not id then id = visible_spell_id(tooltip) end
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
    begin_tooltip(tooltip, key, native_rebuild == true)
    tooltip.uaForeverKind = kind
    tooltip.uaForeverID = id
    local translated = false
    if kind == "item" then
        local result = item_adapter.add(tooltip, id)
        translated = type(result) == "table" and result.applied == true
            or result == true
    elseif kind == "spell" then
        translated = spell_adapter.add_structured_spell(tooltip, data)
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
    if kind == "spell" then
        scheduler.cancel("tooltip:" .. tostring(tooltip))
        scheduler.cancel("tooltip-late:" .. tostring(tooltip))
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

local function safe_process(tooltip, data, kind, native_rebuild)
    local ok, result = pcall(process, tooltip, data, kind, native_rebuild)
    if not ok then
        dev_log.issue("Forever tooltip " .. tostring(kind), tostring(result))
        return false
    end
    return result == true
end

visible_spell_id = function (tooltip)
    if not tooltip then return nil end
    local tooltip_util = _G.TooltipUtil
    if tooltip_util and type(tooltip_util.GetDisplayedSpell) == "function" then
        local ok, _, id = pcall(tooltip_util.GetDisplayedSpell, tooltip)
        id = ok and safe_number(id) or nil
        if id then return id end
    end
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
    if cached then
        runtime.metric("tooltip_tree_cache_hits", tooltip,
            tooltip.uaForeverGeneration)
        return cached
    end
    runtime.metric("tooltip_tree_cache_misses", tooltip,
        tooltip.uaForeverGeneration)

    local result = {}
    local seen = {}

    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 4 then return end
        seen[frame] = true
        runtime.metric("ui_tree_nodes", tooltip, tooltip.uaForeverGeneration)

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

tooltip_line_region = function (tooltip, side, index)
    local region
    local getter_name = side == "Right" and "GetRightLine" or "GetLeftLine"
    local getter_ok, getter = pcall(function () return tooltip[getter_name] end)
    if getter_ok and type(getter) == "function" then
        local line_ok, candidate = pcall(getter, tooltip, index)
        if line_ok and candidate and not is_secret(candidate) then
            region = candidate
        end
    end
    if not region and tooltip.GetName then
        local ok_name, name = pcall(tooltip.GetName, tooltip)
        name = ok_name and safe_string(name) or nil
        if name then
            region = _G[name .. "Text" .. side .. tostring(index)]
            if region then
                runtime.metric("global_tooltip_line_fallbacks", tooltip,
                    tooltip.uaForeverGeneration)
            end
        end
    end

    return region
end

tooltip_line = function (tooltip, side, index, allow_hidden)
    local region = tooltip_line_region(tooltip, side, index)
    if region then
        runtime.metric("native_tooltip_line_hits", tooltip,
            tooltip.uaForeverGeneration)
    end

    if region and not allow_hidden then
        local method_ok, is_shown = pcall(function () return region.IsShown end)
        if method_ok and type(is_shown) == "function" then
            local shown_ok, shown = pcall(is_shown, region)
            if not shown_ok or is_secret(shown) or shown ~= true then region = nil end
        end
    end

    -- Some Forever/Camelot aura tooltips use anonymous FontStrings instead
    -- of the traditional GameTooltipTextLeftN globals. Resolve those visible
    -- regions by their rendered order so ID-backed translations can still be
    -- written without reading or comparing secret aura text.
    if not region and side == "Left" then
        region = visible_tooltip_font_strings(tooltip)[index]
        if region then
            runtime.metric("tree_tooltip_line_fallbacks", tooltip,
                tooltip.uaForeverGeneration)
        end
    end
    if not region or not region.GetText then return nil, region end
    local ok_text, text = pcall(region.GetText, region)
    if not ok_text then return nil, region end
    runtime.metric("regions_read", tooltip, tooltip.uaForeverGeneration)
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

local comparison = comparison_adapter.install({
    begin_tooltip = begin_tooltip,
    entries = entries,
    hooks = hooks,
    is_secret = is_secret,
    item_name_visible_matches = item_name_visible_matches,
    MAX_TOOLTIP_LINES = MAX_TOOLTIP_LINES,
    options = options,
    rewrite_generic_lines = rewrite_generic_lines,
    runtime = runtime,
    safe_number = safe_number,
    safe_string = safe_string,
    set_tooltip_translation = set_tooltip_translation,
    strings = strings,
    tooltip_catalog = tooltip_catalog,
    tooltip_line = tooltip_line,
    utils = utils,
})
local bootstrap_comparison_translation = comparison.bootstrap
local comparison_manager_owns = comparison.comparison_manager_owns
local each_shopping_tooltip = comparison.each
local translate_comparison_fallback_once = comparison.fallback_once
local install_comparison_text_guards = comparison.install_text_guards
local is_shopping_tooltip = comparison.is_shopping
local prepare_comparison_manager = comparison.prepare_manager
local translate_shopping_tooltip = comparison.translate

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
        if kind == "aura" and public_left_title then
            local title_spell_id = spell_adapter.resolve_aura_id(public_left_title)
            if title_spell_id and title_spell_id ~= spell_id
                and safe_process(tooltip, {
                    spellID = title_spell_id,
                    uaForeverCaptureByTitle = true,
                }, "aura") then
                return
            end
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


local function schedule_tooltip_finalize(tooltip)
    local generation = tooltip.uaForeverGeneration
    if tooltip.uaForeverKind == "item"
        and (tooltip.uaForeverItemStatus == "complete"
            or tooltip.uaForeverItemStatus == "incomplete"
            or tooltip.uaForeverItemStatus == "unchanged") then
        return
    end
    local function finalize()
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if ok and shown then
            if tooltip.uaForeverKind == "spell" then
                capture_generic_tooltip_ui(tooltip)
                return
            end
            if aura_tooltip_context(tooltip) then
                mark_aura_tooltip(tooltip)
                after_aura_tooltip_rendered(tooltip)
                return
            end
            translate_generic_tooltip(tooltip)
            capture_generic_tooltip_ui(tooltip)
        end
    end
    scheduler.request("tooltip:" .. tostring(tooltip), generation,
        finalize, nil, tooltip)
    -- Some aura FontStrings arrive after the first deferred pass without
    -- another OnShow or OnTooltipCleared event. Retry once, for this generation.
    if tooltip.uaForeverKind ~= "item" then
        scheduler.request("tooltip-late:" .. tostring(tooltip), generation,
            finalize, 0.2, tooltip)
    end
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

tooltip_diagnostics.install(tooltips, {
    aura_tooltip_context = aura_tooltip_context,
    visible_spell_id = visible_spell_id,
    tooltip_line = tooltip_line,
    spell_adapter = spell_adapter,
    tooltip_events = tooltip_events,
    safe_string = safe_string,
    safe_number = safe_number,
    runtime = runtime,
    is_secret = is_secret,
    note_tooltip_event = note_tooltip_event,
    mark_aura_tooltip = mark_aura_tooltip,
    after_aura_tooltip_rendered = after_aura_tooltip_rendered,
    each_shopping_tooltip = each_shopping_tooltip,
    public_frame_name = public_frame_name,
    entries = entries,
    visible_tooltip_font_strings = visible_tooltip_font_strings,
    MAX_TOOLTIP_LINES = MAX_TOOLTIP_LINES,
    minimap_tooltip_owner = minimap_tooltip_owner,
    translate_minimap_tooltip = translate_minimap_tooltip,
})

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
        "EmbeddedItemTooltip",
        "BuffFrameTooltip" }) do
        local tooltip = _G[name]
        if tooltip and not seen_tooltips[tooltip] then
            tooltip_frames[#tooltip_frames + 1] = tooltip
            seen_tooltips[tooltip] = true
        end
    end
    each_shopping_tooltip(function (tooltip)
        if not seen_tooltips[tooltip] then
            tooltip_frames[#tooltip_frames + 1] = tooltip
            seen_tooltips[tooltip] = true
        end
    end)
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
                local shopping = is_shopping_tooltip(self)
                if shopping then prepare_comparison_manager() end
                if shopping and not self.uaForeverSessionKey then
                    begin_tooltip(self, "comparison-pending")
                end
                if shopping then self.uaForeverKind = "item" end
                if shopping and comparison_manager_owns(self) then
                    self.uaForeverComparisonManagedPending = true
                    -- Build 70009 calls Show() from ProcessInfo() before
                    -- SetItemTooltip() has appended the comparison deltas.
                    -- The Item post-call installs guarded writes; the manager
                    -- post-hook only discovers newly allocated delta rows.
                    return
                end
                if not self.uaForeverSessionKey then begin_tooltip(self, "generic") end
                if self.uaForeverKind ~= "item" then arm_tooltip_updates(self) end
                if self == _G.GameTooltip and type(self.GetOwner) == "function" then
                    local owner_ok, owner = pcall(self.GetOwner, self)
                    if owner_ok and is_character_stat_owner(owner) then
                        tooltips.translate_character_stat(owner)
                    end
                end
                if shopping then
                    -- Non-manager comparison surfaces (ItemRef/Camelot) use
                    -- this single fallback pass. Manager-owned surfaces return
                    -- above and stay translated through guarded native writes.
                    translate_comparison_fallback_once(self,
                        self.uaForeverGeneration)
                else
                    schedule_tooltip_finalize(self)
                end
            end)
            hooks.region_script(tooltip, "OnTooltipCleared", function (self)
                    if is_shopping_tooltip(self)
                        and self.uaForeverSessionKey then
                        -- Build 70009 clears and rebuilds comparison tooltips
                        -- from a bag-slot OnUpdate. Keep the small claim/cache
                        -- set until the tooltip actually hides; guarded native
                        -- writes update each reused line in place.
                        tooltip_font_strings[self] = nil
                        return
                    end
                    note_tooltip_event(self, "onTooltipCleared")
                    reset_tooltip(self)
                    if self == _G.GameTooltip then
                        arm_minimap_watcher()
                        if minimap_tooltip_candidate(self) then
                            arm_tooltip_updates(self, 3)
                        end
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
    if tooltip.uaForeverKind == "item" or is_shopping_tooltip(tooltip) then
        -- Build 70009 reruns TooltipDataProcessor post-calls after item
        -- rebuilds. Shopping rows additionally use guarded SetText hooks, so
        -- neither surface needs UA Forever's bounded OnUpdate fallback.
        tooltip.uaForeverUpdateBudget = 0
        return
    end
    local budget = tooltip.uaForeverUpdateBudget or 0
    if budget <= 0 then return end
    local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
    local owner_updates = false
    if owner_ok and owner then
        local method_ok, method = pcall(function () return owner.UpdateTooltip end)
        owner_updates = method_ok and type(method) == "function"
    end
    local self_ok, self_update = pcall(function () return tooltip.UpdateTooltip end)
    local refresh_ok, should_refresh = pcall(function ()
        return tooltip.shouldRefreshData
    end)
    local unit_dynamic = false
    if type(tooltip.GetUnit) == "function" then
        local unit_ok, _, unit = pcall(tooltip.GetUnit, tooltip)
        unit_dynamic = unit_ok and safe_string(unit) ~= nil
    end
    local kind = tooltip.uaForeverKind
    local dynamic = kind == "npc" or kind == "player" or kind == "aura"
        or unit_dynamic or minimap_tooltip_candidate(tooltip) or owner_updates
        or self_ok and type(self_update) == "function"
        or refresh_ok and not is_secret(should_refresh) and should_refresh == true
    if not dynamic then
        tooltip.uaForeverUpdateBudget = 0
        return
    end
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
    prepare_comparison_manager()
    hooks.region_script(_G.GameTooltip, "OnUpdate", after_game_tooltip_update,
        "quest-reward")
    hooks.region(_G.GameTooltipTextLeft1, "SetText", function (region)
        if runtime.is_applying(region) then return end
        local tooltip = _G.GameTooltip
        if not tooltip then return end
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if ok and shown then
            if minimap_tooltip_candidate(tooltip) then
                arm_tooltip_updates(tooltip, 3)
                translate_minimap_tooltip(tooltip)
            elseif tooltip.uaForeverKind == "object"
                or world_cursor_owner(tooltip) then
                arm_tooltip_updates(tooltip, 3)
                schedule_tooltip_finalize(tooltip)
            elseif tooltip.uaForeverKind == "npc"
                or tooltip.uaForeverKind == "player" then
                arm_tooltip_updates(tooltip, 3)
            elseif type(tooltip.GetUnit) == "function" then
                local unit_ok, _, unit = pcall(tooltip.GetUnit, tooltip)
                if unit_ok and safe_string(unit) then
                    arm_tooltip_updates(tooltip, 3)
                end
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
    if _G.EventRegistry and type(_G.EventRegistry.RegisterCallback) == "function" then
        _G.EventRegistry:RegisterCallback("TalentDisplay.TooltipCreated",
            talent_adapter.translate, tooltips)
    end
    local types = Enum.TooltipDataType
    if types.Item then
        TooltipDataProcessor.AddTooltipPostCall(types.Item, function (tooltip, data)
            runtime.metric("native_item_post_calls", tooltip,
                tooltip and tooltip.uaForeverGeneration)
            if is_shopping_tooltip(tooltip) then
                prepare_comparison_manager()
                if not tooltip.uaForeverSessionKey then
                    begin_tooltip(tooltip, "comparison-pending")
                end
                tooltip.uaForeverKind = "item"
                local installed = install_comparison_text_guards(tooltip)
                if installed > 0 then
                    tooltip.uaForeverComparisonCompleteGeneration =
                        tooltip.uaForeverGeneration
                end
                -- The SetText guards are installed after ProcessInfo has
                -- already written the first frame. Seed the initial claim from
                -- the completed public rows once per displayed item; never
                -- treat the cache as warm until Ukrainian text is visible.
                bootstrap_comparison_translation(tooltip, data)
                if comparison_manager_owns(tooltip) then
                    tooltip.uaForeverComparisonManagedPending = true
                end
            else
                safe_process(tooltip, data, "item", true)
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
                    safe_process(tooltip, data, "spell", true)
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
            if is_shopping_tooltip(tooltip) then
                if translate_shopping_tooltip(tooltip) then
                    tooltip.uaForeverComparisonManagedPending = nil
                    tooltip.uaForeverComparisonFallbackGeneration =
                        tooltip.uaForeverGeneration
                end
            elseif tooltip.uaForeverKind == "character-stat" then
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
