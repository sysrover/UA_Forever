local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local skills = addon_table.use("skills")
local strings = addon_table.use("strings")
local tooltips = addon_table.use("tooltips")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("skills")
local hook_mixin = hooks.mixin
local hook_owner = hooks.region

local translate_profession_spell_button
local hook_crafting_requirements
local hook_crafting_description

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
        _G.ProfessionsBookFrame, _G.ProfessionsFrame, _G.TradeSkillFrame,
        _G.CraftFrame,
        _G.ReputationFrame, _G.PVPRankFrame, _G.TokenFrame,
        _G.TokenDetailFrame, _G.StatisticsFrame,
    }
    for index = 1, 13 do
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
            local stats = strings.translate_frame(frame)
            total.frames = total.frames + (stats.frames or 0)
            total.translated = total.translated + (stats.translated or 0)
            record_frame_ids(frame, {}, {}, 1)
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

local function translate_profession_rank(region, profession, profession_info)
    if not region or not options.translate_name("skill") then return end
    local source = text_from(region)
    local name, progress = source and source:match("^(.-)%s+(%d+/%d+)$")
    if profession_info then
        local ok, info_name, level, maximum = pcall(function ()
            return profession_info.professionName,
                profession_info.skillLevel, profession_info.maxSkillLevel
        end)
        if ok and type(info_name) == "string" and not is_secret(info_name)
            and type(level) == "number" and not is_secret(level)
            and type(maximum) == "number" and not is_secret(maximum) then
            name = info_name
            progress = source and source:match("(%d+.-/%d+)%s*$")
                or math.floor(level) .. "/" .. math.floor(maximum)
        end
    end
    name = name or profession and profession.skillName
    local translated = name and (entries.lookup_name("spell", name)
        or strings.find_ui_translation(name)
        or (name:find("[\208\209]") and name))
    if not translated or not progress then return end
    runtime.apply(region, { owner = "skills", slot = "skill.name",
        source = source, translated = utils.cap(translated) .. " " .. progress,
        category = "skill", priority = runtime.PRIORITY.DOMAIN,
        allow_unknown_source = true })
end

local function hook_profession_rank(region, profession)
    if not region then return end
    hook_owner(region, "SetText", function (self)
        if not runtime.is_applying(self) then translate_profession_rank(self, profession) end
    end)
    translate_profession_rank(region, profession)
end

local function translate_updated_profession_bar(bar, profession_info)
    local region = bar and bar.Rank and bar.Rank.Text
    if region then
        translate_profession_rank(region, bar:GetParent(), profession_info)
    end
end

local function translate_professions(frame)
    local professions_frame = _G.ProfessionsFrame
    local book = frame
    if professions_frame and (frame == professions_frame or frame == professions_frame.BookPage) then
        book = professions_frame.BookPage
        if type(professions_frame.GetTitleText) == "function" then
            local ok, title = pcall(professions_frame.GetTitleText, professions_frame)
            if ok then strings.translate_region(title) end
        end
    elseif frame == _G.ProfessionsBookFrame then
        book = frame
        if type(frame.GetTitleText) == "function" then
            local ok, title = pcall(frame.GetTitleText, frame)
            if ok then strings.translate_region(title) end
        end
    end

    -- ProfessionsFrame is protected in Camelot. Do not recursively walk it;
    -- translate only the public FontStrings declared by the Forever XML.
    local content = book and book.ProfessionsContentFrame
    if not content then return end
    for _, key in ipairs({
        "PrimaryProfession1", "PrimaryProfession2",
        "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3",
    }) do
        local profession = content[key]
        if profession then
            if options.translate_name("skill") then
                strings.translate_region(profession.ProfessionName, "skill", "skill.name")
                strings.translate_region(profession.specialization, "skill", "skill.name")
            end
            strings.translate_region(profession.missingHeader)
            strings.translate_region(profession.missingText)
            strings.translate_region(profession.Rank)
            local bar = profession.StatusBar
            hook_profession_rank(bar and bar.Rank and bar.Rank.Text, profession)
            hook_owner(bar, "Update", translate_updated_profession_bar)
            local profession_api = _G.C_TradeSkillUI
            if bar and profession.skillLine and profession_api
                and type(profession_api.GetProfessionInfoBySkillLineID) == "function" then
                local ok, info = pcall(profession_api.GetProfessionInfoBySkillLineID,
                    profession.skillLine)
                if ok and info then translate_updated_profession_bar(bar, info) end
            end
            for _, button in ipairs(profession.spellButtons or {}) do
                if options.translate_name("skill") then
                    strings.translate_region(button.spellString, "skill", "skill.name")
                end
                strings.translate_region(button.subSpellString)
                if translate_profession_spell_button then
                    translate_profession_spell_button(button)
                    hook_owner(button, "UpdateButton", translate_profession_spell_button)
                end
            end
        end
    end
end

local function translate_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, font_string = pcall(button.GetFontString, button)
    if ok then strings.translate_region(font_string) end
end

local translate_tab_label

local function translate_element(frame, seen, depth, category, max_depth, labels,
    labels_only)
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
                    local source = labels and text_from(region)
                    if source and labels[source] and labels_only then
                        translate_tab_label(region)
                    elseif source and labels[source] then
                        runtime.apply(region, { owner = "talents",
                            slot = "ui.text", source = source,
                            translated = labels[source],
                            priority = runtime.PRIORITY.CONTEXT })
                    elseif not labels_only then
                        strings.translate_region(region,
                            is_name and "skill" or nil,
                            is_name and "skill.name" or nil)
                    end
                end
            end
        end
    end
    if labels_only then
        local text_ok, get_text, set_text = pcall(function ()
            return frame.GetText, frame.SetText
        end)
        if text_ok and type(get_text) == "function"
            and type(set_text) == "function" then
            translate_tab_label(frame)
        end
        local ok, font_string = pcall(function ()
            return frame.GetFontString and frame:GetFontString()
        end)
        if ok and font_string then translate_tab_label(font_string) end
    end
    if frame.GetChildren then
        local ok, children = pcall(function () return { frame:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                translate_element(child, seen, depth + 1, category,
                    max_depth, labels, labels_only)
            end
        end
    end
end

local talent_labels = { Primary = "Основна", Secondary = "Додаткова" }

local function translate_named_talent_tab(button, english)
    local region = button and button.Text
    local source = text_from(region)
    if not source or not talent_labels[english] then return end
    local start_at, end_at = source:find(english, 1, true)
    if not start_at then return end
    local translated = source:sub(1, start_at - 1)
        .. talent_labels[english] .. source:sub(end_at + 1)
    runtime.apply(region, { owner = "talents", slot = "ui.text",
        source = source, translated = translated,
        priority = runtime.PRIORITY.CONTEXT })
end

local function translate_talent_tab_buttons(frame)
    if not frame or type(frame.GetTabButton) ~= "function" then return end
    for _, descriptor in ipairs({
        { frame.primarySpecTabID, "Primary" },
        { frame.secondarySpecTabID, "Secondary" },
    }) do
        local tab_id, english = descriptor[1], descriptor[2]
        if tab_id then
            local ok, button = pcall(frame.GetTabButton, frame, tab_id)
            if ok and button then
                hooks.region(button, "UpdateTabText", function (self)
                    translate_named_talent_tab(self, english)
                end)
                translate_named_talent_tab(button, english)
            end
        end
    end
end

translate_tab_label = function (region)
    if not region or runtime.is_applying(region) then return end
    local source = text_from(region)
    local translated = source and talent_labels[source]
    if not translated then return end
    hooks.region(region, "SetText", translate_tab_label)
    runtime.apply(region, { owner = "talents", slot = "ui.text",
        source = source, translated = translated,
        priority = runtime.PRIORITY.CONTEXT })
end

local function talent_frames()
    local root = _G.PlayerSpellsFrame
    local result, seen = {}, {}
    local function add(frame)
        if frame and not seen[frame] then
            result[#result + 1] = frame
            seen[frame] = true
        end
    end
    if root then
        add(root.TalentsFrame)
        add(root.TalentFrame)
        add(root.ClassTalentFrame)
    end
    add(_G.ClassTalentFrame)
    add(_G.PlayerTalentFrame)
    add(_G.TalentFrame)
    if root and root.GetChildren then
        local ok, children = pcall(function () return { root:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do
                local name_ok, name = pcall(function () return child:GetDebugName() end)
                if name_ok and type(name) == "string"
                    and name:find("Talent", 1, true) then add(child) end
            end
        end
    end
    return result
end

local function translate_talents()
    local seen = {}
    for _, frame in ipairs(talent_frames()) do
        local ok, visible = pcall(frame.IsShown, frame)
        if ok and visible then
            translate_talent_tab_buttons(frame)
            translate_element(frame, nil, 1, nil, 10, talent_labels)
            local parent = frame
            for _ = 1, 4 do
                if not parent or parent == _G.UIParent or seen[parent] then break end
                seen[parent] = true
                translate_element(parent, nil, 1, nil, 10,
                    talent_labels, true)
                local parent_ok, next_parent = pcall(function ()
                    return parent.GetParent and parent:GetParent()
                end)
                if not parent_ok or next_parent == parent then break end
                parent = next_parent
            end
        end
    end
    local root = _G.PlayerSpellsFrame
    if root and not seen[root] then
        local ok, visible = pcall(root.IsShown, root)
        if ok and visible then
            translate_element(root, nil, 1, nil, 10, talent_labels, true)
        end
    end
end

local function entry_text(entry, owner, index)
    index = index or 1
    if not entry or type(entry[index]) ~= "string" then return nil end
    if type(entries.make_entry_text) == "function" then
        local ok, text = pcall(entries.make_entry_text, entry[index], owner)
        if ok and type(text) == "string" and not text:find("{%d+}") then
            return utils.cap(text)
        end
    end
    return utils.cap(entry[index])
end

local function translate_spellbook_item(frame)
    local info = frame and frame.spellBookItemInfo
    local spell_id = info and info.spellID
    if type(spell_id) ~= "number" then return end
    local entry = entries.get_entry("spell", spell_id)
    local text = entry_text(entry, frame)
    if text and options.translate_name("skill") then
        apply_skill_text(frame.Name, text, "skill", "skill.name")
    end
    -- Some Camelot-only passive spells do not have a reviewed ClassicUA ID
    -- entry yet, but their visible names are present in the Forever UI table.
    if options.translate_name("skill") then
        strings.translate_region(frame and frame.Name, "skill", "skill.name")
    end
    strings.translate_region(frame and frame.SubName)
    strings.translate_region(frame and frame.RequiredLevel)
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

translate_profession_spell_button = function (frame)
    if not frame or not C_SpellBook or not C_SpellBook.GetSpellBookItemInfo
        or not Enum or not Enum.SpellBookSpellBank then return end
    local parent = frame.GetParent and frame:GetParent()
    local id = frame.GetID and frame:GetID()
    local offset = parent and parent.spellOffset
    if type(id) ~= "number" or type(offset) ~= "number" then return end
    local ok, info = pcall(C_SpellBook.GetSpellBookItemInfo,
        id + offset, Enum.SpellBookSpellBank.Player)
    local spell_id = ok and info and info.spellID
    local entry = type(spell_id) == "number" and entries.get_entry("spell", spell_id)
    local text = entry_text(entry, frame)
    if text and options.translate_name("skill") then
        apply_skill_text(frame.spellString, text, "skill", "skill.name")
    end
    strings.translate_region(frame.subSpellString)
end

local function translate_character_element(frame)
    -- These are Camelot ScrollBox elements. Their native Initialize/Refresh
    -- has finished, so only their visible FontStrings are touched; underlying
    -- faction/currency/stat data remains English and untainted.
    translate_element(frame, nil, 1)
end

local function translate_crafting_row(row)
    if not row then return end
    if type(row.GetTitleRegion) == "function" then
        local ok, title = pcall(row.GetTitleRegion, row)
        if ok and title and type(title.GetText) == "function" then
            local text_ok, source = pcall(title.GetText, title)
            local translated = text_ok and type(source) == "string"
                and strings.find_ui_translation(source, title)
            if translated then
                runtime.apply(title, { owner = "skills", slot = "recipe.category",
                    source = source, translated = translated,
                    priority = runtime.PRIORITY.CONTEXT })
            end
        end
    end
    if options.translate_name("skill") then
        strings.translate_region(row.Label, "skill", "skill.name")
        strings.translate_region(row.Name, "skill", "skill.name")
    end
    strings.translate_region(row.Text)

    local ok, element_data = pcall(function () return row:GetElementData() end)
    local recipe_info = ok and element_data and element_data.data and element_data.data.recipeInfo
    local recipe_id = recipe_info and recipe_info.recipeID
    local entry = type(recipe_id) == "number" and entries.get_entry("spell", recipe_id)
    local text = entry_text(entry, row)
    if text and options.translate_name("skill") then
        apply_skill_text(row.Label or row.Name, text, "skill", "skill.name")
    end
    if recipe_info then
        hook_owner(row, "OnEnter", function (self)
            local tooltip = _G.GameTooltip
            if not tooltip or type(tooltip.GetOwner) ~= "function" then return end
            local owner_ok, owner = pcall(tooltip.GetOwner, tooltip)
            if owner_ok and owner == self.Label then
                local data_ok, current = pcall(self.GetElementData, self)
                local info = data_ok and current and current.data
                    and current.data.recipeInfo
                if info then
                    tooltips.translate_profession_recipe(tooltip, info.name)
                end
            end
        end)
    end
end

local function translate_trainer_row(row)
    if not row or type(row.GetRegions) ~= "function" then return end
    local ok, regions = pcall(function () return { row:GetRegions() } end)
    if not ok then return end
    for _, region in ipairs(regions) do
        local type_ok, object_type = pcall(region.GetObjectType, region)
        if type_ok and object_type == "FontString" then
            hooks.region(region, "SetText", function (self)
                if not runtime.is_applying(self) then
                    strings.translate_region(self)
                end
            end)
            strings.translate_region(region)
        end
    end
end

local function translate_trainer_rows()
    local frame = _G.ClassTrainerFrame
    local scroll_box = frame and frame.ScrollBox
    if not scroll_box or type(scroll_box.ForEachFrame) ~= "function" then return end
    pcall(scroll_box.ForEachFrame, scroll_box, translate_trainer_row)
end

local function translate_reagent_slot(slot)
    if not slot or not slot.Name then return end
    local reagent, schematic
    if type(slot.GetReagent) == "function" then
        local ok, value = pcall(slot.GetReagent, slot)
        if ok then reagent = value end
    end
    if type(slot.GetReagentSlotSchematic) == "function" then
        local ok, value = pcall(slot.GetReagentSlotSchematic, slot)
        if ok then schematic = value end
    end
    if not reagent and schematic and type(schematic.reagents) == "table" then
        reagent = schematic.reagents[1]
    end
    local item_id = reagent and reagent.itemID
    local entry = type(item_id) == "number" and entries.get_entry("item", item_id)
    local translated = entry_text(entry, slot)
    if not translated then
        if options.translate_name("item") then
            strings.translate_region(slot.Name, "item", "item.name")
        end
        return
    end
    if not options.translate_name("item") then return end

    local english = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(item_id)
    if type(english) ~= "string" or english == "" then
        english = entry.en
    end
    local current = text_from(slot.Name)
    if not current or type(english) ~= "string" or english == "" then return end
    local first, last = current:find(english, 1, true)
    if not first then return end
    apply_skill_text(slot.Name,
        current:sub(1, first - 1) .. translated .. current:sub(last + 1),
        "item", "item.name")
end

local function translate_crafting_page()
    local root = _G.ProfessionsFrame
    local page = root and root.CraftingPage
    if not page then return end

    if type(root.GetTitleText) == "function" then
        local ok, title = pcall(root.GetTitleText, root)
        if ok then strings.translate_region(title) end
    end

    local rank = page.RankBar and page.RankBar.Rank
    local rank_text = rank and rank.Text
    if rank_text and type(rank_text.GetText) == "function" then
        local ok, source = pcall(rank_text.GetText, rank_text)
        local profession, progress
        if ok and type(source) == "string" then
            profession, progress = source:match("^(.-) (%d+/%d+)$")
        end
        local translated = profession and entries.lookup_name("spell", profession)
        if translated then
            runtime.apply(rank_text, { owner = "skills", slot = "profession.rank",
                source = source, translated = utils.cap(translated) .. " " .. progress,
                priority = runtime.PRIORITY.CONTEXT })
        end
    end

    local list = page.RecipeList
    if list then
        strings.translate_region(list.NoResultsText)
        strings.translate_region(list.SearchBox and list.SearchBox.Instructions)
        strings.translate_region(list.FilterDropdown and list.FilterDropdown.Text)
        translate_button(list.FilterDropdown)

        local scroll_box = list.ScrollBox
        if scroll_box and type(scroll_box.ForEachFrame) == "function" then
            pcall(scroll_box.ForEachFrame, scroll_box, function (row)
                translate_crafting_row(row)
                if row and type(row.Init) == "function" then
                    hook_owner(row, "Init", translate_crafting_row)
                end
            end)
        end
    end

    local form = page.SchematicForm
    if form then
        hook_crafting_requirements(form)
        hook_crafting_description(form)
        for _, field in ipairs({
            "OutputText", "RecraftingOutputText", "OutputSubText",
            "RequiredTools", "RecraftingRequiredTools", "Description",
            "Cooldown", "MinimizedCooldown", "RecraftingDescription",
        }) do
            if field ~= "OutputText" and field ~= "RecraftingOutputText"
                or options.translate_name("item") then
                local item_name = field == "OutputText"
                    or field == "RecraftingOutputText"
                strings.translate_region(form[field],
                    item_name and "item" or nil,
                    item_name and "item.name" or nil)
            end
        end
        strings.translate_region(form.TrackRecipeCheckbox and
            (form.TrackRecipeCheckbox.Text or form.TrackRecipeCheckbox.Label))
        strings.translate_region(form.AllocateBestQualityCheckbox and
            (form.AllocateBestQualityCheckbox.Text or form.AllocateBestQualityCheckbox.Label))
        strings.translate_region(form.Reagents and form.Reagents.Label)
        strings.translate_region(form.OptionalReagents and form.OptionalReagents.Label)
        strings.translate_region(form.FinishingReagents and form.FinishingReagents.Label)
        strings.translate_region(form.RecipeSourceButton and form.RecipeSourceButton.Text)
        strings.translate_region(form.FirstCraftBonus and form.FirstCraftBonus.Text)

        if type(form.GetSlots) == "function" then
            local ok, slots = pcall(form.GetSlots, form)
            if ok and type(slots) == "table" then
                for _, slot in ipairs(slots) do
                    translate_reagent_slot(slot)
                    hook_owner(slot, "Update", translate_reagent_slot)
                end
            end
        end

        local recipe_info
        if type(form.GetRecipeInfo) == "function" then
            local ok, value = pcall(form.GetRecipeInfo, form)
            if ok then recipe_info = value end
        end
        local recipe_id = recipe_info and recipe_info.recipeID
        if type(recipe_id) == "number" then
            local spell_entry = entries.get_entry("spell", recipe_id)
            local description = entry_text(spell_entry, form, 2)
            if description then
                apply_skill_text(form.Description, description, nil, "spell.description")
            end

            if C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic then
                local ok, schematic = pcall(C_TradeSkillUI.GetRecipeSchematic, recipe_id, false)
                local item_id = ok and schematic and schematic.outputItemID
                local item_entry = type(item_id) == "number" and entries.get_entry("item", item_id)
                local output = entry_text(item_entry, form)
                if output and options.translate_name("item") then
                    apply_skill_text(form.OutputText, output, "item", "item.name")
                end
            end
        end
    end

    translate_button(page.CreateButton)
    translate_button(page.CreateAllButton)
end

local function requirement_name(name)
    if type(name) ~= "string" or is_secret(name) then return nil end
    if name == "Forge" then return "кузня" end
    return entries.lookup_name("item", name)
        or entries.lookup_name("spell", name)
        or strings.find_ui_translation(name)
end

local function requirement_text_from_recipe(form)
    if type(form.GetRecipeInfo) ~= "function"
        or not C_TradeSkillUI or not C_TradeSkillUI.GetRecipeRequirements then return nil end
    local ok_info, recipe_id = pcall(function ()
        local info = form:GetRecipeInfo()
        return info and info.recipeID
    end)
    if not ok_info or is_secret(recipe_id) or type(recipe_id) ~= "number" then return nil end
    local ok, requirements = pcall(C_TradeSkillUI.GetRecipeRequirements, recipe_id)
    if not ok or type(requirements) ~= "table" or is_secret(requirements) then return nil end

    local link_types = Enum and Enum.RecipeRequirementType
    local names = {}
    if link_types then
        if link_types.SpellFocus then names[link_types.SpellFocus] = "SpellFocusRequirement" end
        if link_types.Totem then names[link_types.Totem] = "TotemRequirement" end
        if link_types.Area then names[link_types.Area] = "AreaRequirement" end
    end
    local parts = {}
    for _, requirement in ipairs(requirements) do
        local ok_fields, name, met, kind = pcall(function ()
            return requirement.name, requirement.met, requirement.type
        end)
        if not ok_fields or is_secret(kind) then return nil end
        local translated = requirement_name(name)
        local link_type = names[kind]
        if not translated or not link_type then return nil end
        local part = "|H" .. link_type .. "|h" .. translated .. "|h"
        if not is_secret(met) and met == false then
            part = "|cffff2020" .. part .. "|r"
        end
        parts[#parts + 1] = part
    end
    if #parts == 0 then return nil end
    return "Потрібно: " .. table.concat(parts, ", ")
end

local function translate_crafting_requirement_region(form, region)
    if not region then return end
    if strings.translate_region(region) then return end

    local source = text_from(region)
    local translated
    if source then
        if not source:find("Requires:", 1, true) then return end
        local plain = source:match("^Requires:%s*(.-)%s*$")
        local plain_name = plain and not plain:find("|", 1, true)
            and requirement_name(plain)
        if plain_name then
            translated = "Потрібно: " .. plain_name
        else
            translated = source:gsub("|H([^|]+)|h([^|]+)|h", function (link, name)
                local replacement = requirement_name(name)
                return "|H" .. link .. "|h" .. (replacement or name) .. "|h"
            end)
            translated = translated:gsub("Requires:", "Потрібно:", 1)
        end
        if translated == source then return end
    else
        -- Camelot can mark the rendered text secret while leaving recipe
        -- requirement fields public. Rebuild only fully known requirements.
        translated = requirement_text_from_recipe(form)
        if not translated then return end
    end

    runtime.apply(region, { owner = "skills", slot = "profession.required_tools",
        source = source, translated = translated,
        priority = runtime.PRIORITY.DOMAIN, allow_unknown_source = true })
end

local function translate_crafting_requirements(form)
    if not form then return end
    translate_crafting_requirement_region(form, form.RequiredTools)
    translate_crafting_requirement_region(form, form.RecraftingRequiredTools)
end

hook_crafting_requirements = function (form)
    if not form then return end
    for _, region in pairs({ form.RequiredTools, form.RecraftingRequiredTools }) do
        hooks.region(region, "SetText", function (self)
            if not runtime.is_applying(self) then
                translate_crafting_requirement_region(form, self)
            end
        end)
    end
    translate_crafting_requirements(form)
end

hook_crafting_description = function (form)
    local region = form and form.Description
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if not runtime.is_applying(self) then strings.translate_region(self) end
    end)
    strings.translate_region(region)
end

local function translate_new_recipe_alert(frame, recipe_id)
    if not frame then return end
    strings.translate_region(frame.Title)
    if type(recipe_id) ~= "number" or is_secret(recipe_id)
        or not options.translate_name("spell") then return end

    local entry = entries.get_entry("spell", recipe_id)
    local english = entry and entry.en
    local ukrainian = entry and entry[1]
    local source = text_from(frame.Name)
    if type(english) ~= "string" or type(ukrainian) ~= "string"
        or not source then return end
    local first, last = source:find(english, 1, true)
    if not first then return end
    local translated = source:sub(1, first - 1) .. utils.cap(ukrainian)
        .. source:sub(last + 1)
    runtime.apply(frame.Name, {
        owner = "recipe-alert", slot = "spell.name", source = source,
        translated = translated, category = "spell",
        option = "translate_spell", priority = runtime.PRIORITY.DOMAIN,
    })
end

local function translate_player_cast_bar(frame)
    if not frame or not options.can_lookup("translate_spell") then return end
    local region = frame.Text
    local source = text_from(region)
    if not source then return end
    local translated = entries.lookup_name("spell", source)
    if not translated or translated == source then return end
    runtime.apply(region, {
        owner = "player-cast-bar", slot = "spell.name", source = source,
        translated = utils.cap(translated), category = "spell",
        option = "translate_spell", priority = runtime.PRIORITY.DOMAIN,
    })
end

local function hook_cast_bar(frame)
    if not frame then return end
    hook_owner(frame, "HandleCastStart", translate_player_cast_bar)
    local region = frame.Text
    if region then
        hook_owner(region, "SetText", function(self)
            if not runtime.is_applying(self) then
                translate_player_cast_bar(frame)
            end
        end)
    end
end

skills.prepare = function ()
    local trainer_frame = _G.ClassTrainerFrame
    local trainer_scroll_box = trainer_frame and trainer_frame.ScrollBox
    hooks.global("ClassTrainerFrame_Update", translate_trainer_rows)
    hooks.region_script(trainer_frame, "OnShow", translate_trainer_rows,
        "trainer-rows")
    hook_owner(trainer_scroll_box, "Update", translate_trainer_rows)
    hooks.region_script(trainer_scroll_box, "OnMouseWheel", translate_trainer_rows,
        "trainer-scroll")
    translate_trainer_rows()

    -- The alert system stores a direct reference to its setup function, so
    -- hook that stored field rather than only the global function name.
    hook_owner(_G.NewRecipeLearnedAlertSystem, "setUpFunction",
        translate_new_recipe_alert)
    -- Cast bars can write the spell name directly without HandleCastStart.
    -- Watch the displayed text so each new cast receives its own translation.
    for _, frame in pairs({
        _G.PlayerCastingBarFrame, _G.OverlayPlayerCastingBarFrame,
        _G.CastingBarFrame, _G.TargetFrameSpellBar, _G.FocusFrameSpellBar,
        _G.PetCastingBarFrame,
    }) do
        hook_cast_bar(frame)
    end
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
    hook_mixin("ProfessionSpellButtonMixin", "UpdateButton", translate_profession_spell_button)
    hook_mixin("ProfessionsRankBarMixin", "Update", translate_updated_profession_bar)
    hook_mixin("ProfessionsBookFrameMixin", "Update", translate_professions)
    hook_mixin("ProfessionsMixin", "SelectBookPage", translate_professions)
    hook_mixin("ProfessionsMixin", "Refresh", translate_professions)
    hook_mixin("ProfessionsMixin", "OnShow", translate_professions)
    hook_mixin("ProfessionsCraftingPageMixin", "Refresh", translate_crafting_page)
    hook_mixin("ProfessionsCraftingPageMixin", "Update", translate_crafting_page)
    hook_mixin("ProfessionsCraftingPageMixin", "ValidateControls", translate_crafting_page)
    hook_mixin("ProfessionsCraftingPageMixin", "OnRecipeSelected", translate_crafting_page)
    hook_mixin("ProfessionsRecipeSchematicFormMixin", "Init", translate_crafting_page)
    hook_mixin("ProfessionsRecipeSchematicFormMixin", "Refresh", translate_crafting_page)
    hook_mixin("ProfessionsRecipeSchematicFormMixin", "UpdateOutputItem", translate_crafting_page)
    hook_mixin("ProfessionsRecipeSchematicFormMixin", "UpdateRecipeDescription", translate_crafting_page)
    hook_mixin("ProfessionsRecipeSchematicFormMixin", "Update",
        translate_crafting_requirements)
    hook_mixin("ProfessionsRecipeListCategoryMixin", "Init", translate_crafting_row)
    hook_mixin("ProfessionsRecipeListRecipeMixin", "Init", translate_crafting_row)
    hook_mixin("ProfessionsReagentSlotMixin", "Update", translate_reagent_slot)

    -- ProfessionsFrame and its embedded BookPage are created from XML before
    -- UA_Forever installs hooks. Forever copies mixin methods onto those frame
    -- instances, so hook the actual copied methods as well as future mixins.
    local professions_frame = _G.ProfessionsFrame
    local spellbook = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.SpellBookFrame

    for _, method in ipairs({ "OnShow", "OnPagedSpellsUpdate", "UpdateDisplayedSpells", "SetTab" }) do
        hook_owner(spellbook, method, translate_spellbook)
    end
    hooks.region_script(_G.PlayerSpellsFrame, "OnShow", translate_spellbook,
        "spellbook")
    translate_spellbook(spellbook)

    -- The talent pane is a separate child of the protected PlayerSpellsFrame.
    -- Scan only that pane after it opens or its selected tab changes.
    hooks.region_script(_G.PlayerSpellsFrame, "OnShow", translate_talents,
        "talents")
    for _, frame in ipairs(talent_frames()) do
        hooks.region_script(frame, "OnShow", translate_talents, "talents")
    end
    hooks.global("PanelTemplates_SetTab", function (frame)
        if frame == _G.PlayerSpellsFrame then translate_talents() end
    end)
    for _, method in ipairs({ "Update", "Refresh" }) do
        for _, frame in ipairs(talent_frames()) do
            hook_owner(frame, method, translate_talents)
        end
        hook_mixin("TalentFrameBaseMixin", method, translate_talents)
    end
    translate_talents()

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

    hook_owner(professions_frame, "SelectBookPage", translate_professions)
    hook_owner(professions_frame, "Refresh", translate_professions)
    hook_owner(professions_frame, "OnShow", translate_professions)
    hook_owner(professions_frame and professions_frame.BookPage,
        "Update", translate_professions)
    hook_owner(_G.ProfessionsBookFrame, "Update", translate_professions)

    local crafting_page = professions_frame and professions_frame.CraftingPage
    local schematic_form = crafting_page and crafting_page.SchematicForm
    hook_crafting_requirements(schematic_form)
    hook_crafting_description(schematic_form)
    for _, method in ipairs({ "Refresh", "Update", "ValidateControls", "OnRecipeSelected" }) do
        hook_owner(crafting_page, method, translate_crafting_page)
    end
    for _, method in ipairs({ "Init", "Refresh", "UpdateOutputItem", "UpdateRecipeDescription" }) do
        hook_owner(schematic_form, method, translate_crafting_page)
    end
    hook_owner(schematic_form, "Update", translate_crafting_requirements)
    hooks.region_script(professions_frame, "OnShow", translate_professions,
        "professions")
    hooks.region_script(crafting_page, "OnShow", translate_crafting_page,
        "crafting")
    hooks.region_script(_G.ProfessionsBookFrame, "OnShow", translate_professions,
        "professions")

    for _, frame in ipairs(skill_roots()) do
        hooks.region_script(frame, "OnShow", function (self) skills.refresh(self) end,
            "refresh")
        if shown(frame) then skills.refresh(frame) end
    end
end
