local _, addon_table = ...

local adapter = addon_table.use("profession_recipe_adapter")
local auto_scan = addon_table.use("auto_scan")
local hooks = addon_table.use("translation_hooks").bind("profession-recipes")
local item_db = addon_table.use("item_client_db")
local layout = addon_table.use("translation_layout")
local profession_db = addon_table.use("profession_client_db")
local runtime = addon_table.use("translation_runtime")
local spell_db = addon_table.use("spell_client_db")
local spell_renderer = addon_table.use("spell_template_renderer")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")
local surface_text = assert(addon_table.forever_surface_ui,
    "UA Forever surface UI catalog is not loaded").skills

local OWNER = "profession-recipes"

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

local function number(value)
    return type(value) == "number" and not is_secret(value) and value > 0
        and value or nil
end

local function text_from(region)
    if not region then return nil end
    local ok_method, getter = pcall(function () return region.GetText end)
    if not ok_method or type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter, region)
    return ok and type(value) == "string" and not is_secret(value)
        and value or nil
end

local function apply(region, translated, slot, option, category)
    local source = text_from(region)
    if not source or type(translated) ~= "string" or translated == ""
        or translated == source then return false end
    return runtime.apply(region, {
        owner = OWNER, slot = slot, source = source,
        translated = translated, option = option, category = category,
        priority = runtime.PRIORITY.DOMAIN, reapply_cached = true,
    })
end

local function element_data(row)
    if not row or type(row.GetElementData) ~= "function" then return nil end
    local ok, value = pcall(row.GetElementData, row)
    if not ok or type(value) ~= "table" then return nil end
    return type(value.data) == "table" and value.data or value
end

local function category_translation(category_id, region)
    local source = profession_db.get_category_name(category_id)
    if type(source) ~= "string" or source == "" then return nil end
    local translated = profession_db.get_category_name_uk(category_id)
        or strings.find_ui_translation(source, region)
    if not translated then
        local armor_type, slot = source:match("^(%a+) (.+)$")
        local prefix = armor_type and surface_text.armor_category_types[armor_type]
        local noun = slot and surface_text.armor_category_slots[slot]
        if prefix and noun then translated = prefix .. " " .. noun end
    end
    if not translated then
        local target = source:match("^(.-) Enchants$")
        local translated_target = target and strings.find_ui_translation(target)
        if translated_target then
            translated = surface_text.enchant_category(utils.cap(translated_target))
        end
    end
    if not translated and type(auto_scan.record_ui) == "function" then
        auto_scan.record_ui(source, false, "profession.category:" .. category_id,
            "professions", OWNER)
    end
    return translated, source
end

local function translate_category(row)
    local data = element_data(row)
    local info = data and (data.categoryInfo or data.categoryData or data)
    local category_id = info and number(info.categoryID)
    if not category_id then return end
    local title
    if type(row.GetTitleRegion) == "function" then
        local ok, value = pcall(row.GetTitleRegion, row)
        if ok then title = value end
    end
    local translated = category_translation(category_id, title)
    if translated then
        apply(title, translated, "profession.category:" .. category_id)
    end
end

local function recipe_info(row)
    local data = element_data(row)
    return data and (data.recipeInfo or (number(data.recipeID) and data)) or nil
end

local function translate_recipe_tooltip(row)
    local info = recipe_info(row)
    local recipe_id = info and number(info.recipeID)
    local translated = recipe_id and spell_db.get_name(recipe_id)
    if not translated or not _G.GameTooltip
        or type(GameTooltip.GetOwner) ~= "function" then return end
    local ok, owner = pcall(GameTooltip.GetOwner, GameTooltip)
    if not ok or owner ~= row.Label then return end
    apply(_G.GameTooltipTextLeft1, utils.cap(translated),
        "profession.recipe-tooltip.name", "translate_spell", "spell")
end

local function translate_recipe_row(row)
    local info = recipe_info(row)
    local recipe_id = info and number(info.recipeID)
    if not recipe_id then return end
    local category_id = number(info.categoryID)
    local metadata = profession_db.get_recipe(recipe_id, nil, category_id)
    local translated = spell_db.get_name(recipe_id)
    if translated then
        apply(row.Label or row.Name, utils.cap(translated),
            metadata and "profession.recipe:" .. metadata.categoryID .. ".name"
                or "profession.recipe.name",
            "translate_spell", "spell")
        layout.fit_profession_recipe_label(row)
    elseif type(auto_scan.record_id) == "function" then
        auto_scan.record_id("spells", recipe_id, info.name, false)
    end
end

local function translate_search_result(button, supplied_info)
    local info = type(supplied_info) == "table" and supplied_info
        or (button and button.recipeInfo)
    local recipe_id = info and number(info.recipeID)
    local translated = recipe_id and spell_db.get_name(recipe_id)
    if translated then
        apply(button and (button.Name or button.Label), utils.cap(translated),
            "profession.search-result.name", "translate_spell", "spell")
    elseif recipe_id and type(auto_scan.record_id) == "function" then
        auto_scan.record_id("spells", recipe_id, info.name, false)
    end
end

local function translate_search_preview(page)
    local search = page and page.MinimizedSearchBox
    if not search or type(search.GetButtons) ~= "function" then return end
    local ok, buttons = pcall(search.GetButtons, search)
    if not ok or type(buttons) ~= "table" then return end
    for _, button in ipairs(buttons) do translate_search_result(button) end
end

local function form_recipe_info(form)
    if not form or type(form.GetRecipeInfo) ~= "function" then return nil end
    local ok, info = pcall(form.GetRecipeInfo, form)
    return ok and type(info) == "table" and info or nil
end

local function output_item_id(form)
    local schematic = form and form.recipeSchematic
    local item_id = schematic and number(schematic.outputItemID)
    if item_id then return item_id end
    local transaction = form and form.transaction
    if not transaction or not C_TradeSkillUI
        or type(C_TradeSkillUI.GetRecipeOutputItemData) ~= "function"
        or type(transaction.GetRecipeID) ~= "function" then return nil end
    local ok, output = pcall(function ()
        local reagents = type(transaction.CreateCraftingReagentInfoTbl) == "function"
            and transaction:CreateCraftingReagentInfoTbl() or nil
        local allocation = type(transaction.GetAllocationItemGUID) == "function"
            and transaction:GetAllocationItemGUID() or nil
        return C_TradeSkillUI.GetRecipeOutputItemData(
            transaction:GetRecipeID(), reagents, allocation)
    end)
    if not ok or type(output) ~= "table" or is_secret(output.hyperlink) then return nil end
    return type(output.hyperlink) == "string"
        and tonumber(output.hyperlink:match("|Hitem:(%d+)")) or nil
end

local function replace_id_name(source, english, ukrainian)
    if type(source) ~= "string" or type(ukrainian) ~= "string" then return nil end
    if type(english) == "string" and english ~= "" then
        local first, last = source:find(english, 1, true)
        if first then
            return source:sub(1, first - 1) .. ukrainian .. source:sub(last + 1)
        end
    end
    local prefix, inner, suffix = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
    if prefix and inner and suffix then return prefix .. ukrainian .. suffix end
end

local function translate_new_recipe_alert(frame, recipe_id)
    if not frame then return end
    strings.translate_region(frame.Title)
    if not number(recipe_id) then return end
    local english = spell_db.get_english_name(recipe_id)
    local ukrainian = spell_db.get_name(recipe_id)
    local source = text_from(frame.Name)
    local replacement = replace_id_name(source, english,
        ukrainian and utils.cap(ukrainian))
    if replacement then
        apply(frame.Name, replacement, "profession.new-recipe.name",
            "translate_spell", "spell")
    end
end

local function translated_output_name(form)
    local item_id = output_item_id(form)
    local translated = item_id and item_db.get_name(item_id)
    if translated then
        return utils.cap(translated), item_id,
            item_db.get_english_name(item_id), "translate_item", "item"
    end
    local info = form_recipe_info(form)
    local recipe_id = info and number(info.recipeID)
    translated = recipe_id and spell_db.get_name(recipe_id)
    return translated and utils.cap(translated) or nil, nil,
        recipe_id and spell_db.get_english_name(recipe_id) or nil,
        "translate_spell", "spell"
end

local function translate_output_region(form, region, exact_name)
    if not region then return end
    local translated, item_id, english, option, category =
        translated_output_name(form)
    if not translated then return end
    local source = text_from(region)
    local replacement = replace_id_name(source, english, translated)
    if not replacement and exact_name then replacement = translated end
    if replacement then
        apply(region, replacement, "profession.output.name",
            option, category)
        layout.fit_profession_output_text(region)
    end
end

local function translate_description(form)
    local info = form_recipe_info(form)
    local recipe_id = info and number(info.recipeID)
    local region = form and form.Description
    local native = text_from(region)
    if not recipe_id or not native then return end
    local translated = spell_renderer.render(
        recipe_id, "spell", spell_db.get_english_description(recipe_id),
        spell_db.get_description(recipe_id), native)
    if not translated then
        local english_raw = spell_db.get_english_description(recipe_id)
        local output = type(english_raw) == "string"
            and english_raw:match("^Craft an? .+%.$")
            and translated_output_name(form) or nil
        if output then translated = surface_text.crafted_recipe(output) end
    end
    if translated then
        apply(region, translated, "profession.recipe.description", "translate_spell")
        if type(region.SetWidth) == "function" and type(form.GetDescriptionWidth) == "function" then
            local ok, width = pcall(form.GetDescriptionWidth, form)
            if ok and type(width) == "number" then pcall(region.SetWidth, region, width) end
        end
        if type(region.SetHeight) == "function" and type(region.GetStringHeight) == "function" then
            local ok, height = pcall(region.GetStringHeight, region)
            if ok and type(height) == "number" then pcall(region.SetHeight, region, height + 1) end
        end
    end
end

local function reagent_item_id(slot)
    if type(slot.GetReagent) == "function" then
        local ok, reagent = pcall(slot.GetReagent, slot)
        local item_id = ok and type(reagent) == "table" and number(reagent.itemID)
        if item_id then return item_id end
    end
    if type(slot.GetReagentSlotSchematic) ~= "function" then return nil end
    local ok, schematic = pcall(slot.GetReagentSlotSchematic, slot)
    local reagent = ok and type(schematic) == "table"
        and type(schematic.reagents) == "table" and schematic.reagents[1]
    return type(reagent) == "table" and number(reagent.itemID) or nil
end

local function translate_reagent(slot)
    local item_id = slot and reagent_item_id(slot)
    local region = slot and slot.Name
    local source = text_from(region)
    local translated = item_id and item_db.get_name(item_id)
    local english = item_id and item_db.get_english_name(item_id)
    local replacement = replace_id_name(source, english,
        translated and utils.cap(translated))
    if replacement then
        apply(region, replacement, "profession.reagent.name",
            "translate_item", "item")
    end
end

local function translate_enchant_slot(slot)
    local region = slot and slot.Name
    local source = text_from(region)
    if not source then return end
    local translated = strings.find_ui_translation(source, region)
    if translated then
        apply(region, translated, "profession.enchant-slot")
    elseif source:find("[A-Za-z]") and type(auto_scan.record_ui) == "function" then
        auto_scan.record_ui(source, false, "profession.enchant_slot",
            "professions", OWNER)
    end
end

local function requirement_name(name)
    if type(name) ~= "string" or is_secret(name) then return nil end
    return surface_text.requirement_names[name]
        or strings.find_ui_translation(name)
end

local function translate_requirements(form)
    local info = form_recipe_info(form)
    local recipe_id = info and number(info.recipeID)
    if not recipe_id or not C_TradeSkillUI
        or type(C_TradeSkillUI.GetRecipeRequirements) ~= "function" then return end
    local ok, requirements = pcall(C_TradeSkillUI.GetRecipeRequirements, recipe_id)
    if not ok or type(requirements) ~= "table" or is_secret(requirements) then return end
    local link_types = Enum and Enum.RecipeRequirementType
    local names = {}
    if link_types then
        if link_types.SpellFocus then names[link_types.SpellFocus] = "SpellFocusRequirement" end
        if link_types.Totem then names[link_types.Totem] = "TotemRequirement" end
        if link_types.Area then names[link_types.Area] = "AreaRequirement" end
    end
    local parts = {}
    for _, requirement in ipairs(requirements) do
        local fields_ok, name, requirement_type, met = pcall(function ()
            return requirement.name, requirement.type, requirement.met
        end)
        if not fields_ok or is_secret(requirement_type) then return end
        local translated = requirement_name(name)
        local link_type = names[requirement_type]
        if not translated or not link_type then return end
        local part = "|H" .. link_type .. "|h" .. translated .. "|h"
        if not is_secret(met) and met == false then
            part = "|cffff2020" .. part .. "|r"
        end
        parts[#parts + 1] = part
    end
    if #parts == 0 then return end
    local region = form.isRecraft and form.RecraftingRequiredTools or form.RequiredTools
    apply(region, surface_text.requirements(table.concat(parts, ", ")),
        "profession.required-tools")
end

local function translate_form(form)
    if not form_recipe_info(form) then return end
    translate_output_region(form, form.OutputText, true)
    translate_output_region(form, form.RecraftingOutputText, false)
    translate_description(form)
    translate_requirements(form)
    if type(form.GetSlots) == "function" then
        local ok, slots = pcall(form.GetSlots, form)
        if ok and type(slots) == "table" then
            for _, slot in ipairs(slots) do translate_reagent(slot) end
        end
    end
end

local function translate_form_output(form)
    translate_output_region(form, form and form.OutputText, true)
    translate_output_region(form, form and form.RecraftingOutputText, false)
end

local function translate_visible_rows()
    local page = _G.ProfessionsFrame and _G.ProfessionsFrame.CraftingPage
    local scroll_box = page and page.RecipeList and page.RecipeList.ScrollBox
    if scroll_box and type(scroll_box.ForEachFrame) == "function" then
        pcall(scroll_box.ForEachFrame, scroll_box, function (row)
            if type(row.GetTitleRegion) == "function" then
                translate_category(row)
            else
                translate_recipe_row(row)
            end
        end)
    end
    translate_form(page and page.SchematicForm)
end

local function hook_instances()
    local frame = _G.ProfessionsFrame
    local page = frame and frame.CraftingPage
    local form = page and page.SchematicForm
    hooks.region(form, "Init", translate_form)
    hooks.region(form, "Refresh", translate_form)
    hooks.region(form, "UpdateOutputItem", translate_form_output)
    hooks.region(form, "UpdateRecipeDescription", translate_description)
    hooks.region(form, "Update", translate_requirements)
    hooks.region(page, "Refresh", translate_search_preview)
    hooks.region(page, "UpdateSearchPreview", translate_search_preview)
    hooks.region(form and form.enchantSlot, "SetNameText",
        translate_enchant_slot)
    hooks.region(form and form.enchantSlot, "Update", translate_enchant_slot)
    hooks.region_script(frame, "OnShow", translate_visible_rows, "refresh")
    hooks.region_script(page, "OnShow", translate_visible_rows, "refresh")
end

adapter.prepare = function ()
    hooks.region(_G.NewRecipeLearnedAlertSystem, "setUpFunction",
        translate_new_recipe_alert)
    hooks.mixin("ProfessionsRecipeListCategoryMixin", "Init", translate_category)
    hooks.mixin("ProfessionsRecipeListRecipeMixin", "Init", translate_recipe_row)
    hooks.mixin("ProfessionsRecipeListRecipeMixin", "OnEnter", translate_recipe_tooltip)
    hooks.mixin("ProfessionsReagentSlotMixin", "Update", translate_reagent)
    hooks.mixin("ProfessionsEnchantSlotMixin", "SetNameText",
        translate_enchant_slot)
    hooks.mixin("ProfessionsEnchantSlotMixin", "Update", translate_enchant_slot)
    hooks.mixin("CraftingSearchLGMixin", "Init", translate_search_result)
    hooks.mixin("ProfessionsCraftingPageMixin", "Refresh",
        translate_search_preview)
    hooks.mixin("ProfessionsCraftingPageMixin", "UpdateSearchPreview",
        translate_search_preview)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Init", translate_form)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Refresh", translate_form)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "UpdateOutputItem",
        translate_form_output)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "UpdateRecipeDescription",
        translate_description)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Update",
        translate_requirements)
    hook_instances()
    translate_visible_rows()
end

adapter.refresh = translate_visible_rows
