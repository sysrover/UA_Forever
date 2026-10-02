local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local skills = addon_table.use("skills")
local client_db = addon_table.use("spell_client_db")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("skills")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").skills
local hook_mixin = hooks.mixin
local hook_owner = hooks.region
local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return ok and result or false
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
    local ok, value = pcall(frame.IsShown, frame)
    return ok and value or false
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
    local roots = only_frame and { only_frame } or skill_roots()
    for _, frame in ipairs(roots) do
        if shown(frame) then
            local stats = strings.translate_frame(frame, registry.get
                and registry.get("skills") or nil, {
                    id = "skills-refresh", surface = "skills",
                    owner = "skills", reason = "REGISTERED_STATIC_SCAN",
                })
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
                translate_element(child, seen, depth + 1, category, max_depth)
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
        pcall(frame.UpdateTextContainer, frame)
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

local function translate_spellbook(frame)
    local root = _G.PlayerSpellsFrame
    local book = root and root.SpellBookFrame or frame
    if not book then return end

    -- PlayerSpellsFrame is protected in Camelot. Translate only its completed
    -- public SpellBook surface: title, search, headers, items and page text.
    if root and type(root.GetTitleText) == "function" then
        local ok, title = pcall(root.GetTitleText, root)
        if ok then strings.translate_region(title) end
    end
    translate_element(book, nil, 1, "skill")

    if type(book.ForEachDisplayedSpell) == "function" then
        pcall(book.ForEachDisplayedSpell, book, translate_spellbook_item)
    end
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

local function translate_trainer_row(row)
    if not row or type(row.GetRegions) ~= "function" then return end
    local ok, regions = pcall(function () return { row:GetRegions() } end)
    if not ok then return end
    for _, region in ipairs(regions) do
        local type_ok, object_type = pcall(region.GetObjectType, region)
        if type_ok and object_type == "FontString" then
            local is_name = region == row.name
            local category = is_name and "skill" or nil
            local slot = is_name and "skill.name" or nil
            hooks.region(region, "SetText", function (self)
                if not runtime.is_applying(self) then
                    translate_trainer_region(self, category, slot)
                end
            end)
            translate_trainer_region(region, category, slot)
        end
    end
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

local function translate_trainer_requirements(region)
    local source = text_from(region)
    if not source or runtime.is_applying(region) then return end
    local translated = surface_text.trainer_requirements(source, function (body)
        local english = addon_table.client_skill_lines_en
        local ukrainian = addon_table.client_skill_lines_uk
        if not english or not ukrainian or english.sourceBuild ~= ukrainian.sourceBuild then
            return body
        end
        for id, name in pairs(english.rows or {}) do
            local replacement = ukrainian.rows and ukrainian.rows[id]
            if type(name) == "string" and type(replacement) == "string" then
                local first, last = body:find(name, 1, true)
                if first then
                    body = body:sub(1, first - 1) .. utils.cap(replacement)
                        .. body:sub(last + 1)
                end
            end
        end
        return body
    end)
    if translated then
        runtime.apply(region, {
            owner = "skills", slot = "trainer.requirements", source = source,
            translated = translated, priority = runtime.PRIORITY.DOMAIN,
            option = "translate_string", reapply_cached = true,
        })
    end
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

local function translate_trainer_rows()
    translate_trainer_static_region(_G.ClassTrainerFrameSubText)
    translate_trainer_static_region(_G.ClassTrainerFrameSkillStepButtonName)
    local requirements = _G.ClassTrainerFrameSkillStepButtonSubText
    hook_owner(requirements, "SetText", translate_trainer_requirements)
    translate_trainer_requirements(requirements)
    translate_trainer_title()
    local frame = _G.ClassTrainerFrame
    local scroll_box = frame and frame.ScrollBox
    if not scroll_box or type(scroll_box.ForEachFrame) ~= "function" then return end
    pcall(scroll_box.ForEachFrame, scroll_box, translate_trainer_row)
end

skills.prepare = function ()
    local trainer_frame = _G.ClassTrainerFrame
    local trainer_scroll_box = trainer_frame and trainer_frame.ScrollBox
    hooks.global("ClassTrainerFrame_Update", translate_trainer_rows)
    hooks.global("ClassTrainerFrame_InitServiceButton", function (button)
        translate_trainer_row(button)
        if trainer_frame and button == trainer_frame.skillStepButton then
            translate_trainer_static_region(button.name)
            translate_trainer_requirements(button.subText)
        end
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
