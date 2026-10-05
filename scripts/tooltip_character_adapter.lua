local _, addon_table = ...

local adapter = addon_table.use("tooltip_character_adapter")
local renderer = addon_table.use("spell_template_renderer")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local hooks = addon_table.use("translation_hooks").bind("character")
local catalog = addon_table.forever_tooltip_ui
local labels = setmetatable({}, { __mode = "k" })
local primary_templates = setmetatable({}, { __mode = "k" })
local plans, plan_dictionary

-- Native references from build 70205's Camelot PaperDollFrame/Stats. The
-- live client owns their English formats, precision, colors and arguments.
local template_names = {
    "DEFAULT_STRENGTH_TOOLTIP", "DEFAULT_AGILITY_TOOLTIP",
    "DEFAULT_STAMINA_TOOLTIP", "DEFAULT_INTELLECT_TOOLTIP", "DEFAULT_SPIRIT_TOOLTIP",
    "DEFAULT_STATDEFENSE_TOOLTIP", "STAT_HEALTH_TOOLTIP", "STAT_HEALTH_PET_TOOLTIP",
    "STAT_MANA_TOOLTIP", "STAT_ARMOR_TOOLTIP", "STAT_ARMOR_PET_TOOLTIP",
    "STAT_ARMOR_TARGET_TOOLTIP", "ARMOR_MAX_EFFECTIVENESS_TOOLTIP",
    "ARMOR_PENETRATION_TOOLTIP", "RESISTANCE_TOOLTIP_SUBTEXT",
    "MELEE_ATTACK_POWER_TOOLTIP", "RANGED_ATTACK_POWER_TOOLTIP",
    "MELEE_ATTACK_POWER_SPELL_POWER_TOOLTIP", "STAT_BLOCK_VALUE_FLAT_TOOLTIP",
    "CR_DODGE_BASE_STAT_TOOLTIP", "CR_PARRY_BASE_STAT_TOOLTIP",
    "CR_HIT_MELEE_TOOLTIP", "CR_HIT_RANGED_TOOLTIP", "CR_HIT_SPELL_TOOLTIP",
    "CR_DEFAULT_HIT_CAP_TOOLTIP", "CR_HASTE_MELEE_TOOLTIP",
    "CR_HASTE_RANGED_TOOLTIP", "CR_HASTE_SPELL_TOOLTIP",
    "STAT_CRIT_MELEE", "STAT_CRIT_RANGED", "STAT_CRIT_SPELL", "STAT_CRIT_BONUS",
    "CR_EXPERTISE_TOOLTIP", "CR_RANGED_EXPERTISE_TOOLTIP",
    "STAT_SPELLPOWER_TOOLTIP", "STAT_SPELLPOWER_PET_TOOLTIP", "STAT_SPELLHEALING_TOOLTIP",
    "SPELL_PENETRATION_TOOLTIP", "PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG",
    "PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_FIRE", "PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_SHADOW",
    "STAT_MOVEMENT_GROUND_TOOLTIP", "STAT_MOVEMENT_FLIGHT_TOOLTIP",
    "STAT_MOVEMENT_SWIM_TOOLTIP", "CR_SPEED_TOOLTIP", "STAT_ATTACK_SPEED_BASE_TOOLTIP",
    "MANA_REGEN_TOOLTIP", "STAT_ENERGY_REGEN_TOOLTIP", "STAT_FOCUS_REGEN_TOOLTIP",
    "STAT_RUNE_REGEN_TOOLTIP", "SPIRIT_STANDING_WARNING",
}

local title_names = {
    "HEALTH", "MANA", "RAGE", "ENERGY", "FOCUS", "STAT_MOVEMENT_SPEED",
    "SPELL_STAT1_NAME", "SPELL_STAT2_NAME", "SPELL_STAT3_NAME",
    "SPELL_STAT4_NAME", "SPELL_STAT5_NAME", "DEFENSE", "ARMOR",
    "MELEE_ATTACK_POWER", "RANGED_ATTACK_POWER", "STAT_CRITICAL_STRIKE",
    "STAT_HASTE", "STAT_HIT_CHANCE", "STAT_ARMOR_PENETRATION",
    "STAT_SPELLPOWER", "STAT_SPELLHEALING", "STAT_SPELL_PENETRATION",
    "DODGE_CHANCE", "BLOCK_CHANCE", "PARRY_CHANCE", "STAT_ATTACKER_LEVEL",
    "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONMAINHAND_PET", "INVTYPE_WEAPONOFFHAND",
    "INVTYPE_RANGED", "ATTACK_SPEED", "WEAPON_SPEED", "DAMAGE",
}

local function text(value)
    value = runtime.safe_string_or_nil(value)
    if not value then return nil end
    return value:gsub("\\r", ""):gsub("\\n", "\n"):gsub("\r", "")
end

local function match_text(value)
    value = text(value)
    if not value then return nil end
    return value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function wording(original)
    local dictionary = addon_table.forever_ui
    local value = dictionary and (dictionary[original]
        or dictionary[original:gsub("\r", "\\r"):gsub("\n", "\\n")])
    value = text(value)
    return value ~= text(original) and value or nil
end

local function rebuild_plans()
    plans, plan_dictionary = {}, addon_table.forever_ui
    local keys, classes = {}, {}
    for _, name in ipairs(template_names) do keys[name] = true end
    for class in pairs(_G.LOCALIZED_CLASS_NAMES_MALE or {}) do classes[class] = true end
    if type(_G.UnitClass) == "function" then
        local ok, _, class = pcall(_G.UnitClass, "player")
        class = ok and runtime.safe_string_or_nil(class)
        if class then classes[class] = true end
    end
    for class in pairs(classes) do
        for _, stat in ipairs({ "STRENGTH", "AGILITY", "STAMINA", "INTELLECT", "SPIRIT", "MELEE_ATTACK_POWER" }) do
            keys[class .. "_" .. stat .. "_TOOLTIP"] = true
        end
        keys["CR_" .. class .. "_HIT_CAP_TOOLTIP"] = true
        keys["STAT_" .. class .. "_CRIT_BONUS"] = true
        keys["MELEE_ATTACK_POWER_PET_" .. class .. "_TOOLTIP"] = true
        keys["STAT_" .. class .. "_PET_CRIT_BONUS"] = true
    end
    local warning = runtime.safe_string_or_nil(_G.SPIRIT_STANDING_WARNING)
    local translated_warning = warning and wording(warning)
    for name in pairs(keys) do
        local original = runtime.safe_string_or_nil(_G[name])
        local translated = original and wording(original)
        if translated then
            plans[#plans + 1] = { name = name, english = match_text(original), ukrainian = translated }
            -- The native stat builder appends this warning after formatting
            -- the class-specific Spirit template. Retain that composition.
            if name:match("_SPIRIT_TOOLTIP$") and translated_warning then
                local literal_warning = text(warning):gsub("%%%%", "%%"):gsub("%%", "%%%%")
                local literal_translation = translated_warning:gsub("%%%%", "%%"):gsub("%%", "%%%%")
                plans[#plans + 1] = { name = name,
                    english = match_text(text(original) .. "\n\n" .. literal_warning),
                    ukrainian = translated .. "\n\n" .. literal_translation }
            end
        end
    end
    table.sort(plans, function (a, b)
        if #a.english ~= #b.english then return #a.english > #b.english end
        return a.name < b.name
    end)
end

adapter.render_description = function (source, frame)
    source = match_text(source)
    if not source then return nil end
    if not plans or plan_dictionary ~= addon_table.forever_ui then rebuild_plans() end
    local preferred = frame and primary_templates[frame]
    local function render(plan)
        -- Some native constants are displayed directly rather than passed
        -- through format (the Spirit warning contains a literal 33%).
        if source == plan.english:gsub("%%%%", "%%") then
            return (plan.ukrainian:gsub("%%%%", "%%"))
        end
        return renderer.render_format(plan.english, plan.ukrainian, source,
            plan.name == "RESISTANCE_TOOLTIP_SUBTEXT" and function (value, kind)
                return kind == "s" and catalog.resistance_schools[value:lower()] or value
            end or nil)
    end
    if preferred then
        for _, plan in ipairs(plans) do
            if plan.name == preferred then
                local translated = render(plan)
                if translated then return translated end
            end
        end
    end
    for _, plan in ipairs(plans) do
        local translated = render(plan)
        if translated then return translated end
    end
end

adapter.render_label = function (source, frame, region)
    source = runtime.safe_string_or_nil(source)
    if not source then return nil end
    local color = source:match("^(|c%x%x%x%x%x%x%x%x)") or ""
    local visible = source:sub(#color + 1)
    local format = runtime.safe_string_or_nil(_G.PAPERDOLLFRAME_TOOLTIP_FORMAT)
    local function replace(label)
        label = runtime.safe_string_or_nil(label)
        if not label or not format then return nil end
        local translated = strings.find_ui_translation(label, region)
        if not translated or translated == label then return nil end
        local ok, native_label = pcall(string.format, format, label)
        if not ok or visible:sub(1, #native_label) ~= native_label then return nil end
        local suffix = visible:sub(#native_label + 1)
        if suffix ~= "" and suffix:sub(1, 1) ~= " " and suffix:sub(1, 2) ~= "|r" then return nil end
        local translated_ok, translated_label = pcall(string.format, format, translated)
        if translated_ok then return color .. translated_label .. suffix end
    end
    local label = frame and labels[frame]
    if not label and frame and frame.Label and type(frame.Label.GetText) == "function" then
        local ok, visible_label = pcall(frame.Label.GetText, frame.Label)
        visible_label = ok and runtime.safe_string_or_nil(visible_label)
        local claim = runtime.get(frame.Label)
        if claim and visible_label == claim.translated then visible_label = claim.source end
        local label_format = runtime.safe_string_or_nil(_G.STAT_FORMAT)
        if visible_label and label_format then
            label = renderer.render_format(label_format, "%s", visible_label)
        end
    end
    local translated = replace(label)
    if translated then return translated end
    for _, name in ipairs(title_names) do
        translated = replace(_G[name])
        if translated then return translated end
    end
    for index = 1, 7 do
        translated = replace(_G["RESISTANCE_TYPE" .. index])
            or replace(_G["DAMAGE_SCHOOL" .. index])
        if translated then return translated end
    end
    local field_format = runtime.safe_string_or_nil(_G.STAT_FORMAT)
    if field_format then
        local field = renderer.render_format(field_format, field_format, visible,
            function (value) return strings.find_ui_translation(value, region) or value end)
        if field and field ~= visible then return color .. field end
    end
    return strings.find_ui_translation(source, region)
end

adapter.prepare = function ()
    plans = nil
    hooks.global("PaperDollFrame_SetLabelAndText", function (frame, label)
        if frame then labels[frame] = runtime.safe_string_or_nil(label) end
    end)
    hooks.global("PaperDollFrame_SetStatTooltip2", function (frame, _, stat_index)
        if not frame then return end
        primary_templates[frame] = nil
        if runtime.is_secret_value(stat_index) then return end
        -- Same selection as the native builder; all amounts still come from
        -- its rendered output, so no stat calculations are duplicated here.
        local categories = _G.PAPERDOLL_STATCATEGORIES
        local category = categories and categories[_G.PRIMARY_ATTRIBUTE_CATEGORY]
        local stat = category and category.stats and category.stats[stat_index]
        local key = stat and runtime.safe_string_or_nil(stat.stat)
        if not key or type(_G.UnitClass) ~= "function" then return end
        local ok, _, class = pcall(_G.UnitClass, "player")
        class = ok and runtime.safe_string_or_nil(class)
        if not class then return end
        local name = class:upper() .. "_" .. key:upper() .. "_TOOLTIP"
        if not runtime.safe_string_or_nil(_G[name]) then name = "DEFAULT_" .. key:upper() .. "_TOOLTIP" end
        primary_templates[frame] = name
    end)
end
