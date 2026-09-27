local _, addon_table = ...
local entries = addon_table.use("entries")
local resolver = addon_table.use("translation_resolver")
local compiled

resolver.prepare = function ()
    if compiled then return end
    local catalog = addon_table.forever_catalog
    if catalog and catalog.ui then
        compiled = {
            catalog = catalog,
            context = addon_table.forever_ui_context or {},
            patterns = addon_table.forever_ui_patterns or {},
        }
    else
        compiled = {
            curated = addon_table.forever_ui_curated or {},
            classic = addon_table.string or {},
            reviewed = addon_table.forever_ui_generated_reviewed or {},
            generated = addon_table.forever_ui or {},
            context = addon_table.forever_ui_context or {},
            patterns = addon_table.forever_ui_patterns or {},
        }
    end
end

resolver.ui_provenance = function (text)
    resolver.prepare()
    return compiled.catalog and compiled.catalog.ui_provenance[text] or nil
end

resolver.find_source_literal = function (text)
    if type(text) ~= "string" or text == "" then return nil end
    resolver.prepare()
    if not compiled.catalog or type(compiled.catalog.lookup_source_literal) ~= "function" then
        return nil
    end
    local normalized = resolver.normalize(text)
    return compiled.catalog.lookup_source_literal(text, normalized)
end

local function safe_name(region)
    if not region or type(region.GetDebugName) ~= "function" then return "" end
    local ok, value = pcall(region.GetDebugName, region)
    if type(_G.issecretvalue) == "function" then
        local secret_ok, secret = pcall(_G.issecretvalue, value)
        if not secret_ok or secret then return "" end
    end
    return ok and type(value) == "string" and value or ""
end

local function explicit_domain_name(text, normalized, context)
    if type(context) ~= "table" then return nil end
    local categories = {}
    if context.category == "skill" then
        categories = { { "spell", "skill" }, { "item", "item" } }
    elseif context.category == "item" or context.category == "spell"
        or context.category == "quest" then
        categories = { { context.category, context.category } }
    elseif context.category == "zone" then
        local zones = addon_table.zone or {}
        local translated = zones[text] or zones[normalized]
        if translated then
            return translated, "zone", context.slot or "zone.name", "translate_zone"
        end
    end
    for _, pair in ipairs(categories) do
        local translated = entries.lookup_name(pair[1], text)
            or entries.lookup_name(pair[1], normalized)
        if translated then
            return translated, pair[2], context.slot or pair[2] .. ".name",
                context.option
        end
    end
end

resolver.normalize = function (text)
    return text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function translate_reagents(text)
    local prefix, reagents = text:match("^(Reagents:%s*|n)(.+)$")
    if not prefix then
        prefix, reagents = text:match("^(Reagents:%s*\n)(.+)$")
    end
    if not prefix then return nil end

    local translated = reagents:gsub("[^,]+", function (part)
        local leading, value, trailing = part:match("^(%s*)(.-)(%s*)$")
        local color, name, reset = value:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
        name = name or value
        local item, count = name:match("^(.-)%s+(%(%d+%))$")
        local replacement = entries.lookup_name("item", item or name)
        if not replacement then return part end
        return leading .. (color or "") .. replacement
            .. (count and " " .. count or "") .. (reset or "") .. trailing
    end)
    return "Реагенти:" .. prefix:sub(#"Reagents:" + 1) .. translated
end

local function translate_recipe_title(text)
    local profession, recipe = text:match("^([^:]+): (.+)$")
    if not profession then return nil end
    local translated_profession = entries.lookup_name("spell", profession)
    local translated_recipe = entries.lookup_name("spell", recipe)
        or entries.lookup_name("item", recipe)
    if translated_profession and translated_recipe then
        return translated_profession .. ": " .. translated_recipe
    end
end

local function translate_recipe_output(text)
    local name = text:match("^\n([^\n]+)$")
    local translated = name and entries.lookup_name("item", name)
    return translated and "\n" .. translated or nil
end

resolver.find_ui = function (text, region, context)
    if type(text) ~= "string" or text == "" then return nil end
    if type(_G.issecretvalue) == "function" then
        local ok, secret = pcall(_G.issecretvalue, text)
        if not ok or secret then return nil end
    end
    local normalized = resolver.normalize(text)
    local frame_name = safe_name(region)
    resolver.prepare()
    local name, category, slot, domain_option =
        explicit_domain_name(text, normalized, context)
    if name then
        return name, normalized, "domain", category, slot, domain_option
    end
    for _, rule in ipairs(compiled.context) do
        if rule.text == normalized and frame_name:find(rule.frame, 1, true) then
            return rule.translation, normalized, "context"
        end
    end
    local translated
    if compiled.catalog then
        local provenance
        translated, provenance = compiled.catalog.lookup_ui(text, normalized)
        if translated then
            return translated, normalized, provenance.tier, nil, nil, nil, provenance
        end
    else
        translated = compiled.curated[text] or compiled.curated[normalized]
        if translated then return translated, normalized, "curated" end
        translated = compiled.classic[text] or compiled.classic[normalized]
        if translated then return translated, normalized, "validated_legacy" end
        translated = compiled.reviewed[text] or compiled.reviewed[normalized]
        if translated then return translated, normalized, "reviewed_import" end
        translated = compiled.generated[text] or compiled.generated[normalized]
        if translated then return translated, normalized, "generated_fallback" end
    end
    translated = translate_reagents(text)
    if translated then return translated, normalized, "domain" end
    translated = translate_recipe_title(text)
    if translated then return translated, normalized, "domain", "skill", "skill.name" end
    translated = translate_recipe_output(text)
    if translated then return translated, normalized, "domain", "item", "item.name" end
    for _, pattern in ipairs(compiled.patterns) do
        local captures = { text:match(pattern.pattern) }
        if #captures == 0 and normalized ~= text then
            captures = { normalized:match(pattern.pattern) }
        end
        if #captures > 0 then
            return pattern.replace(unpack(captures)), normalized, "pattern"
        end
    end
    return nil, normalized
end
