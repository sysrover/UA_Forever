local _, addon_table = ...
local combat_log = addon_table.use("combat_log")
local catalog = assert(addon_table.forever_chat_system.combat_log)
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local scheduler = addon_table.use("translation_scheduler")
local strings = addon_table.use("strings")
local hooks = addon_table.use("translation_hooks").bind("combat-log")
local templates, terms, term_heads, event_templates = {}, {}, {}, {}
local line_sources = setmetatable({}, { __mode = "k" })
local quick_buttons = setmetatable({}, { __mode = "k" })
local display_callbacks = setmetatable({}, { __mode = "k" })
local surface

local function enabled()
    return options.can_translate("translate_chat")
end

-- Native formatter calls from addon code produced recurring Lua errors in
-- build 70170. Keep the diagnostic command inert; never enter that bridge.
combat_log.probe = function()
    return { version = 2, status = "probe_disabled" }
end

local function normalize(text)
    return (text:gsub("%s+", " "):gsub(" ([.,])", "%1")
        :gsub("^[ .,]+", ""):gsub("%s+$", ""))
end

local function escape(text)
    return (text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

-- The processor uses positional printf arguments 1..11. Compile only the
-- ACTION_*_FULL_TEXT globals whose literal pieces belong to this build's
-- catalog. We never write globals in the processor's secure environment.
local function compile_template(source)
    local parts, indices, target, position, next_index = {}, {}, {}, 1, 1
    source = normalize(source)
    while position <= #source do
        local first, last, explicit, kind = source:find("%%(%d+)%$([sd])", position)
        if not first then first, last, kind = source:find("%%([sd])", position) end
        local literal = source:sub(position, first and first - 1 or #source)
        local translated = catalog.full_text_literals[literal]
        if literal:find("%a") and not translated then return end
        parts[#parts + 1] = escape(literal)
        -- Actor/ability pairs use a colon rather than inflecting player names.
        if literal == " " and #indices > 0 and explicit then
            local previous, current = indices[#indices], tonumber(explicit)
            if (previous == 1 or previous == 4) and (current == 2 or current == 5) then
                translated = catalog.actor_separator
            end
        end
        target[#target + 1] = { text = translated or literal }
        if not first then break end
        local index = tonumber(explicit) or next_index
        if not explicit then next_index = next_index + 1 end
        indices[#indices + 1] = index
        target[#target + 1] = { index = index }
        parts[#parts + 1] = "(.-)"
        position = last + 1
    end
    return { pattern = "^" .. table.concat(parts) .. "$", indices = indices,
        target = target, weight = #source:gsub("%%%d+%$s", "") }
end

local function prepare_vocabulary()
    templates, terms, term_heads, event_templates = {}, {}, {}, {}
    local seen = {}
    for tag, value in pairs(_G) do
        if type(tag) == "string" and tag:match("^ACTION_.+_FULL_TEXT") then
            local source = runtime.safe_string_or_nil(value)
            if source then
                local compiled = seen[source]
                if compiled == nil then
                    compiled = compile_template(source)
                    seen[source] = compiled or false
                    if compiled then compiled.events = {}; templates[#templates + 1] = compiled end
                end
                if compiled then
                    compiled.events[tag:match("^ACTION_(.-)_FULL_TEXT")] = true
                end
            end
        end
    end
    table.sort(templates, function(a, b)
        if a.weight == b.weight then return a.pattern < b.pattern end
        return a.weight > b.weight
    end)
    for source, translated in pairs(catalog.terms) do
        terms[#terms + 1] = { source = source, translated = translated }
    end
    -- Resource wording already belongs to the existing UI catalog.
    for _, value in pairs(_G.COMBAT_LOG_POWER_TYPE_STRINGS or {}) do
        local source = runtime.safe_string_or_nil(value)
        local translated = source and resolver.find_ui(source)
        if translated and translated ~= source and not catalog.terms[source] then
            terms[#terms + 1] = { source = source, translated = translated }
        end
    end
    table.sort(terms, function(a, b) return #a.source > #b.source end)
    for _, term in ipairs(terms) do
        local head = term.source:sub(1, 1)
        term_heads[head] = term_heads[head] or {}
        table.insert(term_heads[head], term)
    end
end

local function translate_terms(text)
    -- Replace in one pass so an English word inside a translated value cannot
    -- be fed into another rule. Names and spell labels are protected links.
    local out, position = {}, 1
    while position <= #text do
        local matched
        for _, term in ipairs(term_heads[text:sub(position, position)] or {}) do
            local last = position + #term.source - 1
            if text:sub(position, last) == term.source
                and not text:sub(position - 1, position - 1):match("[%a_]")
                and not text:sub(last + 1, last + 1):match("[%a_]") then
                out[#out + 1] = term.translated
                position, matched = last + 1, true
                break
            end
        end
        if not matched then
            out[#out + 1] = text:sub(position, position)
            position = position + 1
        end
    end
    return table.concat(out)
end

-- Walk readable label runs while preserving color codes, braces and textures.
local function map_label(label, callback)
    local out, position = {}, 1
    while position <= #label do
        local first = label:find("|", position, true)
        if not first then out[#out + 1] = callback(label:sub(position)); break end
        if first > position then out[#out + 1] = callback(label:sub(position, first - 1)) end
        local token = label:sub(first):match("^|c%x%x%x%x%x%x%x%x")
            or label:sub(first):match("^|[r]")
            or label:sub(first):match("^|T.-|t")
            or label:sub(first):match("^|A.-|a")
            or label:sub(first, first)
        out[#out + 1] = token
        position = first + #token
    end
    return table.concat(out)
end

local function translate_link(kind, payload, label)
    local id = tonumber(payload:match("^(%d+)"))
    local entry, category
    if kind == "spell" and options.can_translate("translate_spell")
        and options.translate_name("spell") then
        category = "spell"
        entry = id and entries.get_entry(category, id)
    elseif kind == "item" and options.can_translate("translate_item")
        and options.translate_name("item") then
        category = "item"
        entry = id and entries.get_entry(category, id)
    elseif kind == "unit" and (payload:match("^Creature%-") or payload:match("^Vehicle%-"))
        and options.can_translate("translate_npc") then
        category = "npc"
        id = tonumber(payload:match("^[^-]+%-[^-]*%-[^-]*%-[^-]*%-[^-]*%-(%d+)%-"))
        entry = id and entries.get_entry(category, id)
    end
    return map_label(label, function(text)
        local left, name, right = text:match("^(%[?)(.-)(%]?)$")
        if kind == "unit" then name = name:gsub("'s$", "") end
        if name == "" then return left .. right end
        local translated = entry and entry[1]
            or category and entries.lookup_name(category, name)
        if kind == "action" then translated = catalog.terms[name]
        elseif kind == "unit" then
            -- Player GUIDs never use the NPC/name glossary.
            local original_name = payload:match("^[^:]+:(.*)$")
            translated = (name == "You" or name == "Your") and name ~= original_name
                and catalog.terms[name] or translated
        elseif kind ~= "spell" and kind ~= "item" and kind ~= "icon" then
            translated = resolver.find_ui(name)
        end
        if type(translated) ~= "string" or translated == "" then translated = name end
        return left .. translated .. right
    end)
end

combat_log.translate = function(message)
    if not enabled() or not runtime.safe_string_or_nil(message) then return message end
    if message:find("|Hplayer:", 1, true) then return message end
    local outer_color, inner, outer_reset = message:match("^(|c%x%x%x%x%x%x%x%x)(.*)(|r)$")
    if outer_color then
        return outer_color .. combat_log.translate(inner) .. outer_reset
    end
    local atoms = {}
    local function store_atom(text)
        text = text:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end)
        atoms[#atoms + 1] = text
        return "\001" .. #atoms .. "\002"
    end
    local masked = message:gsub("(|H([^:|]+):([^|]*)|h)(.-)(|h)",
        function(prefix, kind, payload, label, suffix)
            return store_atom(prefix .. translate_link(kind, payload, label) .. suffix)
        end)
    -- A colored number/school is one argument even if its label has spaces.
    masked = masked:gsub("(|c%x%x%x%x%x%x%x%x)(.-)(|r)", function(color, text, reset)
        -- Only mask argument-sized spans. An outer color can surround a
        -- whole sentence; hiding that span would hide its English template.
        if text:match("^\001%d+\002$") or text:match("^[-+%d,%.]+$")
            or catalog.terms[text] or resolver.find_ui(text) then
            return store_atom(color .. translate_terms(text) .. reset)
        end
        return color .. text .. reset
    end)
    local timestamp, body = masked:match("^(%d+:%d+:%d+>%s*)(.*)$")
    body = normalize(body or masked)
    local event = message:match("|Haction:([^|]+)|h")
        or message:match("|Hspell:%d+:[^:|]*:([^|]+)|h")
    local candidates = event and event_templates[event] or templates
    if event and not candidates then
        candidates = {}
        for _, template in ipairs(templates) do
            for family in pairs(template.events) do
                if family == event or family:sub(1, #event + 1) == event .. "_" then
                    candidates[#candidates + 1] = template
                    break
                end
            end
        end
        event_templates[event] = candidates
    end
    for _, template in ipairs(candidates) do
        local captures = { body:match(template.pattern) }
        if #captures > 0 then
            local values, valid = {}, true
            for i, index in ipairs(template.indices) do
                local value = captures[i]
                if values[index] and values[index] ~= value then
                    -- Repeated actors are different masked occurrences of the
                    -- same link. Compare their restored bytes, not atom IDs.
                    local function restore(s)
                        return (s:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end))
                    end
                    if restore(values[index]) ~= restore(value) then valid = false end
                end
                values[index] = value
            end
            if valid then
                local out = {}
                for _, part in ipairs(template.target) do
                    out[#out + 1] = part.text or values[part.index] or ""
                end
                body = table.concat(out)
                break
            end
        end
    end
    body = translate_terms(body)
    body = body:gsub("\001(%d+)\002", function(n) return atoms[tonumber(n)] end)
    return (timestamp or "") .. body
end

local function translate_line(region, native, native_write)
    if not region or runtime.is_applying(region) then return end
    local ok, text = pcall(region.GetText, region)
    text = ok and runtime.safe_string_or_nil(text)
    local source
    if native_write then
        source = runtime.safe_string_or_nil(native)
    else
        source = text
    end
    local previous = line_sources[region]
    if not source then
        line_sources[region] = nil
        runtime.release(region, "combat-log")
        return
    end
    if not native_write and previous and text == previous.display then source = previous.source end
    if native_write then runtime.release(region, "combat-log") end
    local translated = combat_log.translate(source)
    line_sources[region] = { source = source, display = translated }
    if translated == text then return end
    -- Use the enemy-tooltip path even out of combat: public SetText only,
    -- no SetFont/SetFontObject, resizing, buffer writes or deferred stale text.
    runtime.apply(region, {
        owner = "combat-log", slot = "chat.text", source = source,
        translated = translated, option = "translate_chat",
        priority = runtime.PRIORITY.DOMAIN, surface = surface,
        instance = tostring(region), phase = "static",
        lookup_tier = "combat-log-adapter", catalog_source = "chat",
        combat_text_only = true, defer_if_protected = false,
        verify_after_apply = false,
    })
    -- A disabled option rejects apply(), so restore this readable native text
    -- through the same text-only gate rather than show_original's combat gate.
    if not enabled() and text ~= source and runtime.can_write_text(region, true) then
        runtime.release(region, "combat-log")
        pcall(region.SetText, region, source)
    end
end

local function prepare_line(region)
    if not region then return end
    hooks.region(region, "SetText", function(self, native)
        translate_line(self, native, true)
    end)
    hooks.region(region, "ClearText", function(self)
        line_sources[self] = nil
        runtime.release(self, "combat-log")
    end)
    translate_line(region)
end

local function translate_display(frame)
    if not frame then return end
    -- The secure intrinsic owns visibleLines and calls its own RefreshDisplay.
    -- Enumerate the public font-string container after its display callback;
    -- post-hooks on the insecure copy of those methods need not run.
    local ok, container = pcall(function() return frame.FontStringContainer end)
    if not ok or not container then return end
    local regions_ok, regions = pcall(function() return { container:GetRegions() } end)
    if not regions_ok then return end
    for _, region in ipairs(regions) do
        local type_ok, kind = pcall(region.GetObjectType, region)
        local shown_ok, shown = pcall(region.IsShown, region)
        if type_ok and kind == "FontString" and shown_ok
            and not runtime.is_secret_value(shown) and shown == true then
            prepare_line(region)
        end
    end
end

local function prepare_display(frame)
    if not frame then return end
    if not display_callbacks[frame] then
        local ok = pcall(function()
            frame:AddOnDisplayRefreshedCallback(function()
                translate_display(frame)
            end)
        end)
        if ok then display_callbacks[frame] = true end
    end
    translate_display(frame)
end

local function prepare_quick_buttons()
    local added
    for i = 1, 100 do
        local button = _G["CombatLogQuickButtonFrameButton" .. i]
        if not button then break end
        if not quick_buttons[button] then
            quick_buttons[button] = hooks.region(button, "SetText", function(self)
                strings.translate_region(self:GetFontString(), nil, "ui.filter", surface)
            end)
            added = quick_buttons[button] or added
        end
        strings.translate_region(button:GetFontString(), nil, "ui.filter", surface)
    end
    if added and not runtime.combat_locked() then
        -- The next native pass measures translated text before deciding which
        -- filters fit on the bar. SetText hooks are installed before that pass.
        scheduler.request("combat-log:quick-layout", nil, function()
            if not runtime.combat_locked() and type(_G.Blizzard_CombatLog_Update_QuickButtons) == "function" then
                _G.Blizzard_CombatLog_Update_QuickButtons()
            end
        end)
    end
end

local function translate_config()
    local frame = _G.ChatConfigFrame
    if not frame or type(frame.IsShown) ~= "function" then return end
    local ok, shown = pcall(frame.IsShown, frame)
    if ok and shown then strings.translate_frame(frame, surface) end
end

local function refresh()
    local frame = _G.COMBATLOG
    if not frame then return end
    prepare_display(frame)
    prepare_quick_buttons()
    translate_config()
end

combat_log.prepare = function()
    prepare_vocabulary()
    surface = registry.register_surface({ id = "combat-log",
        roots = { "ChatFrame2", "CombatLogQuickButtonFrame_Custom", "ChatConfigFrame" },
        domains = { "chat", "spell", "npc", "ui" }, name_category = "none",
        slots = { "chat.text", "ui.filter" }, static = refresh,
        is_open = function() return _G.COMBATLOG ~= nil end,
        skip_region = function(region)
            local ok, parent = pcall(region.GetParent, region)
            if not ok or not parent then return false end
            local type_ok, kind = pcall(parent.GetObjectType, parent)
            return type_ok and kind == "EditBox"
        end,
    })
    registry.declare_hook({ id = "combat-log:quick-buttons", surface = "combat-log",
        kind = "global", target = "Blizzard_CombatLog_Update_QuickButtons",
        blizzardAddon = "Blizzard_CombatLog", verifiedBuild = "1.60.1.70170",
        callback = prepare_quick_buttons })
    registry.declare_hook({ id = "combat-log:filter-row", surface = "combat-log",
        kind = "global", target = "ChatConfigCombat_InitButton",
        blizzardAddon = "Blizzard_ChatFrame", verifiedBuild = "1.60.1.70170",
        callback = function(button)
            strings.translate_region(button and button.NormalText, nil, "ui.filter", surface)
        end })
    registry.declare_hook({ id = "combat-log:config-update", surface = "combat-log",
        kind = "global", target = "ChatConfig_UpdateCombatSettings",
        blizzardAddon = "Blizzard_ChatFrame", verifiedBuild = "1.60.1.70170",
        callback = translate_config })
    hooks.region_script(_G.COMBATLOG, "OnShow", function() registry.refresh("combat-log") end)
    hooks.region_script(_G.ChatConfigFrame, "OnShow", function() registry.refresh("combat-log") end)
    refresh()
    scheduler.request("combat-log:initial-display", nil, function()
        prepare_display(_G.COMBATLOG)
    end)
end
