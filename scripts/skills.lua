local _, addon_table = ...

local dev_log = addon_table.use("dev_log")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local scanner = addon_table.use("scanner")
local skills = addon_table.use("skills")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")

local hooked_frames = {}
local hooked_mixins = {}
local translate_profession_spell_button

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

            local key = scanner.frame_text_key("skills", frame)
            if key then scanner.schedule_menu_capture(key) end
        end
    end
    return total
end

local function hook_owner(owner, key, method, callback)
    local owner_type = type(owner)
    if hooked_mixins[key] or (owner_type ~= "table" and owner_type ~= "userdata")
        or type(owner[method]) ~= "function" or type(_G.hooksecurefunc) ~= "function" then
        return
    end

    local ok = pcall(hooksecurefunc, owner, method, callback)
    if ok then hooked_mixins[key] = true end
end

local function hook_mixin(name, method, callback)
    hook_owner(_G[name], name .. "." .. method, method, callback)
end

local function translate_character_category(frame)
    strings.translate_region(frame and frame.Title)
end

local function translate_character_stat(frame)
    strings.translate_region(frame and frame.Label)
    strings.translate_region(frame and frame.Value)
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
            strings.translate_region(profession.StatusBar and profession.StatusBar.rankText)
            for _, button in ipairs(profession.spellButtons or {}) do
                if options.translate_name("skill") then
                    strings.translate_region(button.spellString, "skill", "skill.name")
                end
                strings.translate_region(button.subSpellString)
                if translate_profession_spell_button then
                    translate_profession_spell_button(button)
                    hook_owner(button, "ProfessionSpellButton." .. tostring(button) .. ".UpdateButton",
                        "UpdateButton", translate_profession_spell_button)
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

local function translate_element(frame, seen, depth, category)
    if not frame or depth > 4 then return end
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
                translate_element(child, seen, depth + 1, category)
            end
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
    if type(row.GetTitleText) == "function" then
        local ok, title = pcall(row.GetTitleText, row)
        if ok then strings.translate_region(title) end
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
    local ok, current = pcall(slot.Name.GetText, slot.Name)
    if ok and type(current) == "string" and type(english) == "string" then
        local first, last = current:find(english, 1, true)
        if first then
            apply_skill_text(slot.Name,
                current:sub(1, first - 1) .. translated .. current:sub(last + 1),
                "item", "item.name")
            return
        end
    end
    apply_skill_text(slot.Name, translated, "item", "item.name")
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
    strings.translate_region(rank and rank.Text)

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
                    hook_owner(row, "ProfessionsCraftingRow." .. tostring(row) .. ".Init",
                        "Init", translate_crafting_row)
                end
            end)
        end
    end

    local form = page.SchematicForm
    if form then
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
                    hook_owner(slot, "ProfessionsReagentSlot." .. tostring(slot) .. ".Update",
                        "Update", translate_reagent_slot)
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

skills.prepare = function ()
    -- Forever uses pooled ScrollBox rows for character statistics. Translate
    -- each row in its native Init callback so recycled rows never spend a
    -- rendered frame in English. ClassicUA's older static-frame lifecycle is
    -- not compatible with this Camelot implementation.
    hook_mixin("CharacterStatFrameCategoryScrollBoxElementMixin", "Init", translate_character_category)
    hook_mixin("CharacterStatFrameScrollBoxBaseElementMixin", "Init", translate_character_stat)
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
    hook_mixin("ProfessionsRecipeListCategoryMixin", "Init", translate_crafting_row)
    hook_mixin("ProfessionsRecipeListRecipeMixin", "Init", translate_crafting_row)
    hook_mixin("ProfessionsReagentSlotMixin", "Update", translate_reagent_slot)

    -- ProfessionsFrame and its embedded BookPage are created from XML before
    -- UA_Forever installs hooks. Forever copies mixin methods onto those frame
    -- instances, so hook the actual copied methods as well as future mixins.
    local professions_frame = _G.ProfessionsFrame
    local spellbook = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.SpellBookFrame

    for _, method in ipairs({ "OnShow", "OnPagedSpellsUpdate", "UpdateDisplayedSpells", "SetTab" }) do
        hook_owner(spellbook, "PlayerSpellsFrame.SpellBookFrame." .. method,
            method, translate_spellbook)
    end
    if _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.HookScript
        and not hooked_mixins["PlayerSpellsFrame.Script.OnShow"] then
        local ok = pcall(_G.PlayerSpellsFrame.HookScript, _G.PlayerSpellsFrame,
            "OnShow", translate_spellbook)
        if ok then hooked_mixins["PlayerSpellsFrame.Script.OnShow"] = true end
    end
    translate_spellbook(spellbook)

    -- Several base Camelot frames already exist before UA_Forever loads and
    -- therefore own copied mixin functions. Hook those concrete owners too.
    for _, descriptor in ipairs({
        { _G.ReputationFrame, "ReputationFrame.Update", "Update" },
        { _G.ReputationFrame and _G.ReputationFrame.DetailFrame,
            "ReputationFrame.DetailFrame.Refresh", "Refresh" },
        { _G.PVPRankFrame, "PVPRankFrame.Update", "Update" },
        { _G.PVPRankFrame and _G.PVPRankFrame.DetailFrame,
            "PVPRankFrame.DetailFrame.Refresh", "Refresh" },
        { _G.TokenFrame, "TokenFrame.Update", "Update" },
        { _G.TokenFrame and _G.TokenFrame.DetailFrame,
            "TokenFrame.DetailFrame.Refresh", "Refresh" },
        { _G.StatisticsFrame, "StatisticsFrame.Update", "Update" },
        { _G.SkillsFrame, "SkillsFrame.Update", "Update" },
        { _G.SkillsFrame and _G.SkillsFrame.DetailFrame,
            "SkillsFrame.DetailFrame.Refresh", "Refresh" },
    }) do
        hook_owner(descriptor[1], descriptor[2], descriptor[3], translate_character_element)
    end

    hook_owner(professions_frame, "ProfessionsFrame.SelectBookPage", "SelectBookPage", translate_professions)
    hook_owner(professions_frame, "ProfessionsFrame.Refresh", "Refresh", translate_professions)
    hook_owner(professions_frame, "ProfessionsFrame.OnShow", "OnShow", translate_professions)
    hook_owner(professions_frame and professions_frame.BookPage,
        "ProfessionsFrame.BookPage.Update", "Update", translate_professions)
    hook_owner(_G.ProfessionsBookFrame,
        "ProfessionsBookFrame.Update", "Update", translate_professions)

    local crafting_page = professions_frame and professions_frame.CraftingPage
    local schematic_form = crafting_page and crafting_page.SchematicForm
    for _, method in ipairs({ "Refresh", "Update", "ValidateControls", "OnRecipeSelected" }) do
        hook_owner(crafting_page, "ProfessionsFrame.CraftingPage." .. method,
            method, translate_crafting_page)
    end
    for _, method in ipairs({ "Init", "Refresh", "UpdateOutputItem", "UpdateRecipeDescription" }) do
        hook_owner(schematic_form, "ProfessionsFrame.CraftingPage.SchematicForm." .. method,
            method, translate_crafting_page)
    end
    if professions_frame and professions_frame.HookScript
        and not hooked_mixins["ProfessionsFrame.Script.OnShow"] then
        local ok = pcall(professions_frame.HookScript, professions_frame, "OnShow", translate_professions)
        if ok then hooked_mixins["ProfessionsFrame.Script.OnShow"] = true end
    end
    if crafting_page and crafting_page.HookScript
        and not hooked_mixins["ProfessionsFrame.CraftingPage.Script.OnShow"] then
        local ok = pcall(crafting_page.HookScript, crafting_page, "OnShow", translate_crafting_page)
        if ok then hooked_mixins["ProfessionsFrame.CraftingPage.Script.OnShow"] = true end
    end
    if _G.ProfessionsBookFrame and _G.ProfessionsBookFrame.HookScript
        and not hooked_mixins["ProfessionsBookFrame.Script.OnShow"] then
        local ok = pcall(_G.ProfessionsBookFrame.HookScript, _G.ProfessionsBookFrame,
            "OnShow", translate_professions)
        if ok then hooked_mixins["ProfessionsBookFrame.Script.OnShow"] = true end
    end

    for _, frame in ipairs(skill_roots()) do
        if not hooked_frames[frame] and frame.HookScript then
            frame:HookScript("OnShow", function (self) skills.refresh(self) end)
            hooked_frames[frame] = true
        end
        if shown(frame) then skills.refresh(frame) end
    end
end
