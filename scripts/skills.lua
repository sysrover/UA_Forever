local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local skills = addon_table.use("skills")
local client_db = addon_table.use("spell_client_db")
local strings = addon_table.use("strings")
local resolver = addon_table.use("translation_resolver")
local renderer = addon_table.use("spell_template_renderer")
local tooltips = addon_table.use("tooltips")
local runtime = addon_table.use("translation_runtime")
local layout = addon_table.use("translation_layout")
local registry = addon_table.use("translation_registry")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("skills")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").skills
local hook_mixin = hooks.mixin
local hook_owner = hooks.region
local book_chrome = setmetatable({}, { __mode = "k" })
local book_seeded = setmetatable({}, { __mode = "k" })
local book_row_layouts = setmetatable({}, { __mode = "k" })
local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function visible(frame)
    if not frame then return false end
    local ok, value = pcall(function ()
        local method = frame.IsVisible or frame.IsShown
        return type(method) ~= "function" or method(frame)
    end)
    return ok and not is_secret(value) and value == true
end

local function shown(frame)
    if not frame or not frame.IsShown then return false end
    for _, method in ipairs({ "IsForbidden", "IsProtected" }) do
        local ok_method, callback = pcall(function () return frame[method] end)
        if ok_method and type(callback) == "function" then
            local ok, result = pcall(callback, frame)
            if ok and result then return false end
        end
    end
    return visible(frame)
end

local function skill_roots()
    local result, seen = {}, {}
    local candidates = {
        _G.CharacterFrame, _G.SkillFrame, _G.SkillsFrame, _G.PlayerSpellsFrame,
        _G.ReputationFrame, _G.PVPRankFrame, _G.TokenFrame,
        _G.TokenDetailFrame, _G.StatisticsFrame,
    }
    for index = 1, 9 do
        local frame = candidates[index]
        if frame and not seen[frame] then
            result[#result + 1] = frame
            seen[frame] = true
        end
    end
    return result
end

local function text_from(value)
    if type(value) == "string" and not is_secret(value) then return value end
    if not value then return nil end
    local ok_method, getter = pcall(function () return value.GetText end)
    if not ok_method or type(getter) ~= "function" then return nil end
    local ok, text = pcall(getter, value)
    if ok and type(text) == "string" and not is_secret(text) then return text end
end

local function apply_skill_text(region, translated, category, slot)
    if not region or type(translated) ~= "string" then return false end
    return runtime.apply(region, {
        owner = "skills", slot = slot, source = text_from(region),
        translated = translated, category = category,
        priority = runtime.PRIORITY.DOMAIN,
    })
end

local function frame_label(frame)
    for _, field in ipairs({ "Name", "name", "Label", "label", "Text", "text", "Title", "title" }) do
        local ok, value = pcall(function () return frame[field] end)
        local text = ok and text_from(value)
        if text and text ~= "" then return text end
    end
end

local function numeric_field(owner, field)
    if not owner then return nil end
    local ok, value = pcall(function () return owner[field] end)
    if ok and type(value) == "number" and not is_secret(value) and value > 0 then return value end
end

local function record_frame_ids(frame, seen_frames, seen_ids, depth)
    if not frame or seen_frames[frame] or depth > 20 then return end
    seen_frames[frame] = true

    local name = frame_label(frame)
    local data_owners = { frame }
    for _, field in ipairs({ "data", "info", "skillInfo", "skillLineInfo" }) do
        local ok, value = pcall(function () return frame[field] end)
        if ok and type(value) == "table" then data_owners[#data_owners + 1] = value end
    end

    for _, owner in ipairs(data_owners) do
        for _, descriptor in ipairs({
            { field = "spellID", group = "spells", entry = "spell" },
            { field = "skillLineID", group = "skills" },
            { field = "skillID", group = "skills" },
            { field = "abilityID", group = "skills" },
        }) do
            local id = numeric_field(owner, descriptor.field)
            local key = id and (descriptor.group .. ":" .. id)
            if id and not seen_ids[key] then
                local translated = false
                if descriptor.entry then
                    local ok, entry = pcall(entries.get_entry, descriptor.entry, id)
                    translated = ok and entry ~= nil
                elseif name then
                    local glossary = entries.get_glossary_text(name)
                    local ui = strings.find_ui_translation(name)
                    translated = glossary ~= nil and glossary ~= name
                        or ui ~= nil and ui ~= name
                end
                dev_log.record_id(descriptor.group, id, name, translated)
                seen_ids[key] = true
            end
        end
    end

    if frame.GetChildren then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                if shown(child) then record_frame_ids(child, seen_frames, seen_ids, depth + 1) end
            end
        end
    end
end

skills.refresh = function (only_frame)
    local total = { frames = 0, translated = 0 }
    local seen = {}
    local roots = only_frame and { only_frame } or skill_roots()
    for _, frame in ipairs(roots) do
        if shown(frame) then
            local stats = strings.translate_frame(frame, registry.get
                and registry.get("skills") or nil, {
                    id = "skills-refresh", surface = "skills",
                    owner = "skills", reason = "REGISTERED_STATIC_SCAN",
                }, seen)
            total.frames = total.frames + (stats.frames or 0)
            total.translated = total.translated + (stats.translated or 0)
            if options.account and (options.account.auto_scan_content
                or options.account.dev_mode) then
                record_frame_ids(frame, {}, {}, 1)
            end
        end
    end
    return total
end

local function translate_character_category(frame)
    strings.translate_region(frame and frame.Title)
end

local function translate_character_stat(frame)
    strings.translate_region(frame and frame.Label)
    strings.translate_region(frame and frame.Value)
    hooks.region_script(frame, "OnEnter", function (self)
        tooltips.translate_character_stat(self)
    end, "character-stat-tooltip")
end

local function translate_element(frame, seen, depth, category, max_depth)
    if not frame or depth > (max_depth or 4) then return end
    seen = seen or {}
    if seen[frame] then return end
    seen[frame] = true

    if frame.GetRegions then
        local ok, regions = pcall(function () return { frame:GetRegions() } end)
        if ok then
            for _, region in ipairs(regions) do
                local is_name = category == "skill"
                    and (region == frame.Name or region == frame.spellString)
                if not is_name or options.translate_name(category) then
                    strings.translate_region(region,
                        is_name and "skill" or nil,
                        is_name and "skill.name" or nil)
                end
            end
        end
    end
    if frame.GetChildren then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                if visible(child) then
                    translate_element(child, seen, depth + 1, category, max_depth)
                end
            end
        end
    end
end

local function spellbook_item_spell_id(info)
    local spell_id = client_db.resolve_spellbook_item_id(info,
        type(info) == "table" and info.name or nil)
    return spell_id
end

local function spellbook_item_is_pet_action(info)
    return type(info) == "table" and Enum and Enum.SpellBookItemType
        and info.itemType == Enum.SpellBookItemType.PetAction
end

local function update_spellbook_item_layout(frame)
    if frame and type(frame.UpdateTextContainer) == "function" then
        local cached = book_row_layouts[frame]
        local name = layout.text_signature and layout.text_signature(frame.Name, cached and cached.name)
        local sub = layout.text_signature and layout.text_signature(frame.SubName, cached and cached.sub)
        local level = layout.text_signature and layout.text_signature(frame.RequiredLevel, cached and cached.level)
        local height = layout.safe_dimension and layout.safe_dimension(frame, "GetHeight")
        if cached and name and sub and level and name == cached.name and sub == cached.sub
            and level == cached.level and height and cached.height == height then return end
        if runtime.combat_locked() then
            local info = frame.spellBookItemInfo
            local id = not is_secret(info) and spellbook_item_spell_id(info)
            local native_name = type(info) == "table" and text_from(info.name)
            if id and not is_secret(id) and native_name and runtime.defer_layout then
                runtime.defer_layout(frame, function ()
                    local current = frame.spellBookItemInfo
                    if visible(frame) and not is_secret(current)
                        and spellbook_item_spell_id(current) == id
                        and type(current) == "table" and text_from(current.name) == native_name then
                        update_spellbook_item_layout(frame)
                    end
                end)
            end
            return
        end
        if not runtime.can_write_text(frame) then return end
        if pcall(frame.UpdateTextContainer, frame) and name and sub and level then
            book_row_layouts[frame] = {
                name = layout.text_signature(frame.Name, name),
                sub = layout.text_signature(frame.SubName, sub),
                level = layout.text_signature(frame.RequiredLevel, level),
                height = layout.safe_dimension(frame, "GetHeight") }
        end
    end
end

local function translate_spellbook_item(frame)
    local info = frame and frame.spellBookItemInfo
    local native_name = type(info) == "table" and info.name or nil
    local known_pet_action = spellbook_item_is_pet_action(info)
        and type(native_name) == "string" and not is_secret(native_name)
        and surface_text.pet_actions[native_name] or nil
    local text = known_pet_action
    if not text then
        local spell_id = spellbook_item_spell_id(info)
        text = spell_id and client_db.get_name(spell_id)
    end
    if text and options.translate_name("skill") then
        apply_skill_text(frame.Name, text, "skill", "skill.name")
    end
    local sub_name = type(info) == "table" and info.subName or nil
    local pet_sub_name = spellbook_item_is_pet_action(info)
        and type(sub_name) == "string" and not is_secret(sub_name)
        and surface_text.pet_actions[sub_name] or nil
    if pet_sub_name then
        apply_skill_text(frame.SubName, pet_sub_name, nil,
            "pet-action.subtext")
    else
        strings.translate_region(frame and frame.SubName)
    end
    strings.translate_region(frame and frame.RequiredLevel)
    -- Blizzard sizes the text container before UA Forever replaces the native
    -- name. Recalculate it from the database-backed Ukrainian text so the
    -- existing three-line spell-name allowance is used before truncating.
    update_spellbook_item_layout(frame)
end

local function register_spellbook_chrome(frame, depth)
    if not frame or (depth or 1) > 4 then return end
    if is_secret(frame) then return end
    local ok, forbidden = pcall(function () return frame.IsForbidden and frame:IsForbidden() end)
    if not ok or is_secret(forbidden) or forbidden == true then return end
    local previous = book_chrome[frame]
    if previous then
        if not previous.seeded and visible(frame) then
            for _, region in ipairs(previous.labels) do
                if visible(region) then previous.label(region) end
            end
            previous.seeded = true
            for _, child in ipairs(previous.children) do register_spellbook_chrome(child, (depth or 1) + 1) end
        end
        return
    end
    -- Spell rows have exact database owners. Do not run a generic lookup over
    -- their names after Init/UpdateVisuals has already translated them.
    if frame.spellBookItemInfo or frame.Name and type(frame.UpdateTextContainer) == "function" then return end
    local state = { labels = {}, children = {}, seeded = visible(frame) }
    book_chrome[frame] = state
    local function label(region)
        if not runtime.is_applying(region) then
            strings.translate_region(region, nil, "ui.label", nil, nil, nil, "spell_ui")
        end
    end
    state.label = label
    hooks.region_script(frame, "OnShow", function () register_spellbook_chrome(frame, depth) end, "spellbook-chrome")
    if type(frame.GetRegions) == "function" then
        local ok, regions = pcall(function () return { frame:GetRegions() } end)
        if ok then for _, region in ipairs(regions) do
            local valid, kind = pcall(function () return region:GetObjectType() end)
            if valid and not is_secret(kind) and kind == "FontString" then
                state.labels[#state.labels + 1] = region
                hooks.region(region, "SetText", label)
                hooks.region(region, "SetFormattedText", strings.formatted_callback
                    and strings.formatted_callback(label, nil, "ui.label", nil, "spell_ui") or label)
                if visible(region) then label(region) end
            end
        end end
    end
    if type(frame.GetChildren) == "function" then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                if not is_secret(child) then
                    state.children[#state.children + 1] = child
                    register_spellbook_chrome(child, (depth or 1) + 1)
                end
            end
        end
    end
end

local function translate_spellbook(frame)
    local root = _G.PlayerSpellsFrame
    local book = root and root.SpellBookFrame or frame
    register_spellbook_chrome(book)
    if not visible(book) then return end

    -- PlayerSpellsFrame is protected in Camelot. Translate only its completed
    -- public SpellBook surface: title, search, headers, items and page text.
    if root and type(root.GetTitleText) == "function" then
        local ok, title = pcall(root.GetTitleText, root)
        if ok then strings.translate_region(title, nil, "ui.title", nil, nil, nil, "spell_ui") end
    end
    -- Native writers and row Init/UpdateVisuals own subsequent updates. The
    -- top-level SetTab/OnShow/OnPagedSpellsUpdate hooks only reconcile chrome.
end

local function translate_character_element(frame)
    -- These are Camelot ScrollBox elements. Their native Initialize/Refresh
    -- has finished, so only their visible FontStrings are touched; underlying
    -- faction/currency/stat data remains English and untainted.
    translate_element(frame, nil, 1)
end

local function translate_trainer_region(region, category, slot)
    if not region or runtime.is_applying(region) then return end
    local source = text_from(region)
    local claim = runtime.get(region)
    if source and claim and source == claim.source then
        -- Selecting a service reinitializes both old and new buttons. Restore
        -- only the claim for this exact native text, retaining its policy and
        -- lifecycle rather than looking up a different pooled row's name.
        return runtime.apply(region, {
            owner = claim.owner, slot = claim.slot, source = source,
            translated = claim.translated, category = claim.category,
            option = claim.option, options = claim.options,
            priority = claim.priority, surface = claim.surface,
            generation = claim.generation, instance = claim.instance,
            phase = claim.phase, name_original = claim.name_original,
            reapply_cached = true,
        })
    end
    if source and claim and source ~= claim.translated then
        runtime.invalidate(region)
    end
    return strings.translate_region(region, category, slot)
end

local translate_trainer_requirements
local trainer_rows = setmetatable({}, { __mode = "k" })
local trainer_skill_index, trainer_skill_english, trainer_skill_ukrainian
local trainer_skill_build

local function trainer_requirement_name(name, skill)
    if not options.translate_name(skill and "skill" or "spell") then return name end
    if skill then
        local english, ukrainian = addon_table.client_skill_lines_en, addon_table.client_skill_lines_uk
        if english and ukrainian and english.sourceBuild == ukrainian.sourceBuild then
            if trainer_skill_english ~= english or trainer_skill_ukrainian ~= ukrainian
                or trainer_skill_build ~= english.sourceBuild then
                trainer_skill_index = {}
                for id, source in pairs(english.rows or {}) do
                    local translated = ukrainian.rows and ukrainian.rows[id]
                    if type(source) == "string" and type(translated) == "string" then
                        local previous = trainer_skill_index[source]
                        trainer_skill_index[source] = previous == nil and translated
                            or previous == translated and translated or false
                    end
                end
                trainer_skill_english, trainer_skill_ukrainian = english, ukrainian
                trainer_skill_build = english.sourceBuild
            end
            local translated = trainer_skill_index[name]
            if translated then return utils.cap(translated) end
        end
    end
    local translated = entries.lookup_name("spell", name)
    return translated and utils.cap(translated) or name
end

local function trainer_api(name, ...)
    local api = _G[name]
    if type(api) ~= "function" then return nil end
    local function public_results(ok, ...)
        if not ok then return nil end
        for index = 1, select("#", ...) do
            if is_secret(select(index, ...)) then return nil end
        end
        return { ... }
    end
    return public_results(pcall(api, ...))
end

local function trainer_api_requirements(region, context)
    if not context or not _G.Enum or not Enum.TrainerType then return nil end
    local info = trainer_api("GetTrainerServiceInfo", context.index)
    if not info or type(info[2]) ~= "string" then return nil end
    if info[2] == "used" then
        local native = runtime.safe_string_or_nil(_G.ITEM_SPELL_KNOWN)
        return native, native and resolver.find_ui(native, region)
    end
    local skill = trainer_api("GetTrainerServiceSkillReq", context.index)
    local count = trainer_api("GetTrainerServiceNumAbilityReq", context.index)
    if not skill or not count
        or type(count[1]) ~= "number" or count[1] < 0 or count[1] % 1 ~= 0 then return nil end
    local native, translated, separator = {}, {}, ""
    local delimiter = runtime.safe_string_or_nil(_G.PLAYER_LIST_DELIMITER)
    if not delimiter then return nil end
    local function append(key, values, translated_values)
        local template = runtime.safe_string_or_nil(_G[key])
        if not template then return false end
        local english = renderer.format_arguments(template, unpack(values))
        local ukrainian_template = resolver.find_ui(template, region) or template
        local ukrainian = renderer.format_arguments(ukrainian_template, unpack(translated_values or values))
        if not english or not ukrainian then return false end
        native[#native + 1], translated[#translated + 1] = separator .. english, separator .. ukrainian
        return true
    end
    local level = info[4]
    if level ~= nil and type(level) ~= "number" then return nil end
    if level and level > 1 then
        local unit = context.trainer_type == Enum.TrainerType.Pet and "pet" or "player"
        local player_level = trainer_api("UnitLevel", unit)
        if not player_level or type(player_level[1]) ~= "number" then return nil end
        if not append(player_level[1] >= level and "TRAINER_REQ_LEVEL" or "TRAINER_REQ_LEVEL_RED", { level }) then return nil end
        separator = delimiter
    end
    if skill[1] then
        if type(skill[1]) ~= "string" or type(skill[2]) ~= "number" then return nil end
        if not append(skill[3] and "TRAINER_REQ_SKILL_RANK" or "TRAINER_REQ_SKILL_RANK_RED",
            { skill[1], skill[2] }, { trainer_requirement_name(skill[1], true), skill[2] }) then return nil end
        separator = delimiter
    end
    for index = 1, count[1] do
        local ability = trainer_api("GetTrainerServiceAbilityReq", context.index, index)
        if not ability then return nil end
        if ability[1] then
            if type(ability[1]) ~= "string" then return nil end
            if not append(ability[2] and "TRAINER_REQ_ABILITY" or "TRAINER_REQ_ABILITY_RED",
                { ability[1] }, { trainer_requirement_name(ability[1]) }) then return nil end
        end
        -- Match 70888 exactly: its ability loop retains the existing separator.
    end
    if #native == 0 then return "", "" end
    local prefix = runtime.safe_string_or_nil(_G.REQUIRES_LABEL)
    if not prefix then return nil end
    return prefix .. " " .. table.concat(native),
        (resolver.find_ui(prefix, region) or prefix) .. " " .. table.concat(translated)
end

local function translate_trainer_row(row, element_data)
    if not row or is_secret(row) then return end
    if is_secret(element_data) then
        trainer_rows[row] = nil
        return
    end
    if type(element_data) ~= "table" and type(row.GetElementData) == "function" then
        local ok, value = pcall(row.GetElementData, row)
        if ok and not is_secret(value) then element_data = value
        else trainer_rows[row] = nil end
    end
    if not is_secret(element_data) and type(element_data) == "table" then
        local ok, nested = pcall(function () return element_data.data end)
        if ok and not is_secret(nested) and type(nested) == "table" then element_data = nested end
        local data_ok, index, trainer_type = pcall(function () return element_data.skillIndex, element_data.trainerType end)
        if ok and not is_secret(nested) and data_ok and not is_secret(index) and type(index) == "number" and index > 0
            and index % 1 == 0 and not is_secret(trainer_type) and type(trainer_type) == "number" then
            trainer_rows[row] = { index = index, trainer_type = trainer_type }
        else trainer_rows[row] = nil end
    end
    for _, key in ipairs({ "name", "nameSubText", "alternateCost" }) do
        local region = row[key]
        local category = key == "name" and "skill" or nil
        local slot = key == "name" and "skill.name" or nil
        local function translate(current)
            if not runtime.is_applying(current) then translate_trainer_region(current, category, slot) end
        end
        hooks.region(region, "SetText", translate)
        if region then translate(region) end
    end
    -- The native initializer writes this field before its post-hook receives
    -- the new elementData. Never query the preceding pooled service in SetText.
    hooks.region(row.subText, "SetText", function (region)
        if runtime.is_applying(region) then return end
        local claim = runtime.get(region)
        local source = text_from(region)
        if claim and source ~= claim.translated and source ~= claim.source then runtime.invalidate(region) end
    end)
    translate_trainer_requirements(row.subText, trainer_rows[row])
end

local function translate_trainer_static_region(region)
    if not region then return end
    local function translate(current)
        return translate_trainer_region(current,
            current == _G.ClassTrainerFrameSkillStepButtonName and "skill" or nil,
            current == _G.ClassTrainerFrameSkillStepButtonName and "skill.name" or nil)
    end
    hook_owner(region, "SetText", function (current)
        if runtime.is_applying(current) then return end
        auto_scan.surface_attempt("trainer", "trainer-region.SetText")
        translate(current)
    end)
    if not runtime.is_applying(region) then translate(region) end
end

translate_trainer_requirements = function (region, context)
    local source = text_from(region)
    if not source or runtime.is_applying(region) then return end
    local claim = runtime.get(region)
    local identity = context and tostring(context.trainer_type) .. ":" .. tostring(context.index) or "legacy"
    local instance = identity .. ":" .. tostring(options.translate_name("skill"))
        .. ":" .. tostring(options.translate_name("spell"))
    if claim and claim.owner == "skills" and claim.slot == "trainer.requirements" and claim.instance == instance
        and (source == claim.translated or source == claim.source) then
        return runtime.apply(region, { owner = "skills", slot = claim.slot,
            source = claim.source, translated = claim.translated, option = claim.option,
            section = "trainer", surface = claim.surface, instance = instance,
            priority = claim.priority, reapply_cached = true })
    end
    if claim and claim.owner == "skills" and claim.slot == "trainer.requirements"
        and source == claim.translated and type(claim.instance) == "string"
        and claim.instance:sub(1, #identity + 1) == identity .. ":" then source = claim.source end
    local expected, translated = trainer_api_requirements(region, context)
    if expected ~= source then translated = nil end
    if not translated then
        translated = surface_text.trainer_requirements(source, function (name)
            return trainer_requirement_name(name, true)
        end)
    end
    if translated then
        return runtime.apply(region, {
            owner = "skills", slot = "trainer.requirements", source = source,
            translated = translated, priority = runtime.PRIORITY.DOMAIN,
            option = "translate_string", section = "trainer",
            surface = registry.get("trainer"), instance = instance, reapply_cached = true,
        })
    end
    return strings.translate_region(region)
end

local function translate_trainer_title()
    local frame = _G.ClassTrainerFrame
    if not frame or not options.translate_name("npc") then return end
    -- Pet trainers display the player's pet name, not an NPC catalog entry.
    if C_Trainer and type(C_Trainer.GetTrainerType) == "function"
        and Enum and Enum.TrainerType then
        local type_ok, trainer_type = pcall(C_Trainer.GetTrainerType)
        if not type_ok or is_secret(trainer_type)
            or trainer_type == Enum.TrainerType.Pet then return end
    end
    local ok, id = pcall(utils.npc_id_from_unit_id, "npc")
    if not ok or is_secret(id) then return end
    local entry = ok and id and addon_table.npc and addon_table.npc[id]
    local region = frame.GetTitleText and frame:GetTitleText()
        or _G.ClassTrainerFrameTitleText
    local source = text_from(region)
    if entry and type(entry[1]) == "string" and source
        and (source == entry.en or source == entry[1]) then
        runtime.apply(region, {
            owner = "skills", slot = "trainer.npc.name", source = entry.en,
            translated = utils.cap(entry[1]), category = "npc",
            option = "translate_npc",
            instance = id, priority = runtime.PRIORITY.DOMAIN,
            reapply_cached = true,
        })
    end
end

local original_trainer_widths = setmetatable({}, { __mode = "k" })

local function widen_trainer_region(region)
    if not region or type(region.GetWidth) ~= "function"
        or type(region.SetWidth) ~= "function" then return end
    local ok, width = pcall(region.GetWidth, region)
    if not ok or is_secret(width) or type(width) ~= "number" or width <= 0 then return end
    local original_width = original_trainer_widths[region]
    if not original_width then
        original_width = width
        original_trainer_widths[region] = width
    end
    local target_width = original_width + 60
    if width ~= target_width then
        pcall(region.SetWidth, region, target_width)
    end
end

local function widen_trainer_frame()
    local frame = _G.ClassTrainerFrame
    if not frame then return end
    -- The status bar stays fixed; the right-anchored filter moves with the
    -- wider frame. The native ScrollBox view stretches its pooled rows.
    widen_trainer_region(frame)
    widen_trainer_region(frame.ScrollBox)
    widen_trainer_region(frame.skillStepButton)
end

local function translate_trainer_rows()
    widen_trainer_frame()
    translate_trainer_static_region(_G.ClassTrainerFrameSubText)
    translate_trainer_static_region(_G.ClassTrainerFrameSkillStepButtonName)
    local requirements = _G.ClassTrainerFrameSkillStepButtonSubText
    local frame = _G.ClassTrainerFrame
    if frame and frame.skillStepButton then translate_trainer_row(frame.skillStepButton)
    else translate_trainer_requirements(requirements) end
    translate_trainer_title()
    local dropdown = frame and frame.FilterDropdown
    local function translate_filter()
        translate_trainer_region(dropdown and dropdown.Text)
    end
    -- The dropdown retains its native label and rewrites Text on UpdateText.
    -- Translate the completed display without changing its menu data.
    hook_owner(dropdown, "UpdateText", translate_filter)
    hook_owner(dropdown and dropdown.Text, "SetText", translate_filter)
    translate_filter()
    local scroll_box = frame and frame.ScrollBox
    if not scroll_box or type(scroll_box.ForEachFrame) ~= "function" then return end
    pcall(scroll_box.ForEachFrame, scroll_box, translate_trainer_row)
end

skills.prepare = function ()
    local trainer_frame = _G.ClassTrainerFrame
    local trainer_scroll_box = trainer_frame and trainer_frame.ScrollBox
    hooks.global("ClassTrainerFrame_Update", translate_trainer_rows)
    hooks.global("ClassTrainerFrame_InitServiceButton", function (button, element_data)
        translate_trainer_row(button, element_data)
    end)
    hook_owner(trainer_frame, "SetTitle", translate_trainer_title)
    hooks.region_script(trainer_frame, "OnShow", translate_trainer_rows,
        "trainer-rows")
    hook_owner(trainer_scroll_box, "Update", translate_trainer_rows)
    hooks.region_script(trainer_scroll_box, "OnMouseWheel", translate_trainer_rows,
        "trainer-scroll")
    translate_trainer_rows()

    -- Cast-bar translation overlays are disabled: keep native cast text.
    -- Forever uses pooled ScrollBox rows for character statistics. Translate
    -- each row in its native Init callback so recycled rows never spend a
    -- rendered frame in English. ClassicUA's older static-frame lifecycle is
    -- not compatible with this Camelot implementation.
    hook_mixin("CharacterStatFrameCategoryScrollBoxElementMixin", "Init", translate_character_category)
    hook_mixin("CharacterStatFrameScrollBoxBaseElementMixin", "Init", translate_character_stat)
    hook_mixin("CharacterStatFrameMixin", "OnEnter",
        tooltips.translate_character_stat)
    hook_mixin("CharacterStatFrameScrollBoxBaseElementMixin", "OnEnter",
        tooltips.translate_character_stat)
    hook_mixin("ReputationHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("ReputationEntryMixin", "Initialize", translate_character_element)
    hook_mixin("ReputationSubHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("ReputationDetailFrameMixin", "Refresh", translate_character_element)
    hook_mixin("PVPRankFrameMixin", "Update", translate_character_element)
    hook_mixin("PVPRankDetailFrameMixin", "Refresh", translate_character_element)
    hook_mixin("TokenHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("TokenEntryMixin", "Initialize", translate_character_element)
    hook_mixin("TokenSubHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("TokenDetailFrameMixin", "Refresh", translate_character_element)
    hook_mixin("StatisticsHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("StatisticsEntryMixin", "Initialize", translate_character_element)
    hook_mixin("StatisticsSubHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("SkillsHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("SkillsEntryMixin", "Initialize", translate_character_element)
    hook_mixin("SkillsSubHeaderMixin", "Initialize", translate_character_element)
    hook_mixin("SkillDetailFrameMixin", "Refresh", translate_character_element)
    hook_mixin("SpellBookHeaderMixin", "Init", translate_character_element)
    hook_mixin("SpellBookItemMixin", "Init", translate_spellbook_item)
    hook_mixin("SpellBookItemMixin", "UpdateVisuals", translate_spellbook_item)
    hook_mixin("SpellBookFrameMixin", "OnShow", translate_spellbook)
    hook_mixin("SpellBookFrameMixin", "OnPagedSpellsUpdate", translate_spellbook)
    hook_mixin("SpellBookFrameMixin", "UpdateDisplayedSpells", translate_spellbook)
    hook_mixin("SpellBookFrameMixin", "SetTab", translate_spellbook)
    local spellbook = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.SpellBookFrame

    for _, method in ipairs({ "OnShow", "OnPagedSpellsUpdate", "UpdateDisplayedSpells", "SetTab" }) do
        hook_owner(spellbook, method, translate_spellbook)
    end
    hooks.region_script(_G.PlayerSpellsFrame, "OnShow", translate_spellbook,
        "spellbook")
    translate_spellbook(spellbook)
    if spellbook and not book_seeded[spellbook] and visible(spellbook)
        and type(spellbook.ForEachDisplayedSpell) == "function" then
        pcall(spellbook.ForEachDisplayedSpell, spellbook, translate_spellbook_item)
        book_seeded[spellbook] = true
    end

    -- Several base Camelot frames already exist before UA_Forever loads and
    -- therefore own copied mixin functions. Hook those concrete owners too.
    for _, descriptor in ipairs({
        { _G.ReputationFrame, "Update" },
        { _G.ReputationFrame and _G.ReputationFrame.DetailFrame,
            "Refresh" },
        { _G.PVPRankFrame, "Update" },
        { _G.PVPRankFrame and _G.PVPRankFrame.DetailFrame,
            "Refresh" },
        { _G.TokenFrame, "Update" },
        { _G.TokenFrame and _G.TokenFrame.DetailFrame,
            "Refresh" },
        { _G.StatisticsFrame, "Update" },
        { _G.SkillsFrame, "Update" },
        { _G.SkillsFrame and _G.SkillsFrame.DetailFrame,
            "Refresh" },
    }) do
        hook_owner(descriptor[1], descriptor[2], translate_character_element)
    end

    for _, frame in ipairs(skill_roots()) do
        hooks.region_script(frame, "OnShow", function (self) skills.refresh(self) end,
            "refresh")
        if shown(frame) then skills.refresh(frame) end
    end
end
