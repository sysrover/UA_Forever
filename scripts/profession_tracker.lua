local _, addon_table = ...

local tracker_ui = addon_table.use("profession_tracker")
local registry = addon_table.use("translation_registry")
local runtime = addon_table.use("translation_runtime")
local options = addon_table.use("options")
local spell_db = addon_table.use("spell_client_db")
local item_db = addon_table.use("item_client_db")
local renderer = addon_table.use("spell_template_renderer")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")

local OWNER = "profession-tracker"
local hooks = addon_table.use("translation_hooks").bind(OWNER)
local surface
local refresh_pending = true

local function safe_id(id)
    return type(id) == "number" and not runtime.is_secret_value(id) and id ~= 0 and id or nil
end

local function current_recipe(block)
    local module = _G.ProfessionsRecipeTracker
    if not module or not block or block.parentModule ~= module then return end
    local id = safe_id(block.id)
    local blocks = module.usedBlocks and module.usedBlocks[module.blockTemplate]
    if id and blocks and blocks[id] == block then return id end
end

local function can_translate(section)
    if not options.can_lookup_section(section) then return false end
    if not runtime.combat_locked() then return true end
    refresh_pending = true
    return false
end

local function native_source(region, source, id)
    source = runtime.safe_string_or_nil(source)
    local claim = runtime.get(region)
    if claim and claim.owner == OWNER and (claim.instance ~= id or claim.source ~= source) then
        runtime.release(region, OWNER)
    end
    return source
end

local function translate_header(block, region, source)
    if runtime.is_applying(region) then return end
    local id = current_recipe(block)
    source = native_source(region, source, id)
    if not id or not source or not can_translate("recipes") then return end

    local recipe_id = math.abs(id)
    local english = spell_db.get_english_name(recipe_id)
    local translated = spell_db.get_name(recipe_id)
    if not english or not translated then return end
    translated = utils.cap(translated)
    if id < 0 then
        local template = runtime.safe_string_or_nil(_G.PROFESSIONS_CRAFTING_FORM_RECRAFTING_HEADER)
        if not template or source ~= renderer.format_arguments(template, english) then return end
        translated = renderer.format_arguments(strings.find_ui_translation(template, region) or template, translated)
    elseif source ~= english then
        return
    end
    if translated and translated ~= source then
        runtime.apply(region, { owner = OWNER, surface = surface, instance = id,
            slot = "profession.recipe.name", section = "recipes", option = "translate_spell",
            category = "spell", source = source, translated = translated,
            priority = runtime.PRIORITY.DOMAIN, reapply_cached = true, defer_if_protected = false })
    end
end

local function translate_reagent_name(name, _, argument)
    if argument ~= 2 then return end
    local translated = item_db.get_name_by_english(name)
    if translated then return utils.cap(translated) end
end

local function translate_reagent(line, region, source)
    if runtime.is_applying(region) then return end
    local block = line.parentBlock
    local key = safe_id(line.objectiveKey)
    local id = key and block and block.usedLines and block.usedLines[key] == line
        and current_recipe(block) or nil
    source = native_source(region, source, id)
    if not id or not source or not can_translate("item_names") then return end

    -- The native tracker supplies the formatted progress and an exact name.
    -- Translate only the name capture, preserving counts and quantity ranges.
    local template = runtime.safe_string_or_nil(_G.PROFESSIONS_TRACKER_REAGENT_FORMAT)
    local translated = template and renderer.render_format(template, template, source, translate_reagent_name)
    if translated and translated ~= source then
        runtime.apply(region, { owner = OWNER, surface = surface, instance = id,
            slot = "profession.reagent.name", section = "item_names", option = "translate_item",
            category = "item", source = source, translated = translated,
            priority = runtime.PRIORITY.DOMAIN, reapply_cached = true, defer_if_protected = false })
    end
end

local function prepare_line(block, key)
    if not current_recipe(block) or not safe_id(key) then return end
    local line = block.usedLines and block.usedLines[key]
    if not line then return end
    hooks.region(line.Text, "SetText", function (region, source)
        translate_reagent(line, region, source)
    end, nil, true)
end

local function prepare_block(module, id)
    if module ~= _G.ProfessionsRecipeTracker or not safe_id(id) then return end
    local blocks = module.usedBlocks and module.usedBlocks[module.blockTemplate]
    local block = blocks and blocks[id]
    if not block then return end
    -- GetBlock and GetLine return before the native writer measures its text.
    hooks.region(block.HeaderText, "SetText", function (region, source)
        translate_header(block, region, source)
    end, nil, true)
    hooks.region(block, "GetLine", prepare_line)
    hooks.region(block, "FreeLine", function (_, line)
        runtime.release(line.Text, OWNER)
    end, nil, true)
end

local function visible_tracker()
    local module = _G.ProfessionsRecipeTracker
    local block = module and module.firstBlock
    if not block then return end
    local ok, visible = pcall(function () return block:IsVisible() end)
    if ok and not runtime.is_secret_value(visible) and visible == true then return module end
end

local function refresh()
    if not refresh_pending or runtime.combat_locked() then return end
    local module = visible_tracker()
    local container = module and module.parentContainer
    if not container or not runtime.can_write_text(container) then return end
    local blocks = module.usedBlocks and module.usedBlocks[module.blockTemplate]
    for _, block in pairs(blocks or {}) do
        if block.activeAnim or block.pendingAnim then return end
    end
    -- Let Blizzard rebuild its anchors and heights from the translated text.
    if type(container.Update) == "function" then
        refresh_pending = not pcall(container.Update, container)
    end
end

tracker_ui.prepare = function ()
    surface = registry.register_surface({ id = OWNER, roots = { "ProfessionsRecipeTracker" },
        domains = { "spell", "item" }, slots = { "profession.recipe.name", "profession.reagent.name" },
        static = refresh, is_open = visible_tracker, preserve_claims_on_refresh = true })
    registry.declare_hook({ id = OWNER .. ":GetBlock", surface = OWNER, kind = "frame",
        target = "ProfessionsRecipeTracker", method = "GetBlock", callback = prepare_block,
        blizzardAddon = "Blizzard_ObjectiveTracker", verifiedBuild = "1.60.1.71091" })
    local recipes = options.section_enabled("recipes")
    local reagents = options.section_enabled("item_names")
    options.on_activity_change(OWNER, function ()
        local recipe_state = options.section_enabled("recipes")
        local reagent_state = options.section_enabled("item_names")
        if recipes ~= recipe_state or reagents ~= reagent_state then refresh_pending = true end
        recipes, reagents = recipe_state, reagent_state
    end)
end
