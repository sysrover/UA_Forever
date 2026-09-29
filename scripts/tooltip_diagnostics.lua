local _, addon_table = ...

local diagnostics = addon_table.use("tooltip_diagnostics")

diagnostics.install_full_scan = function (tooltips, api)
    local is_secret = api.is_secret
    local safe_number = api.safe_number
    local safe_string = api.safe_string
    local tooltip_line = api.tooltip_line
    local object_label = api.object_label
    local public_object_value = api.public_object_value

    tooltips.multiline_tooltip_visible = function ()
        local tooltip = _G.GameTooltip
        if not tooltip then return false end
        local ok, shown = pcall(tooltip.IsShown, tooltip)
        if not ok or not shown then return false end
        local source = tooltip_line(tooltip, "Left", 1)
        source = safe_string(source)
        return source and source:find("\n", 1, true) ~= nil
            and source:find("|TInterface\\Minimap\\", 1, true) ~= nil
            or false
    end

    tooltips.scan_all_objects = function (on_complete, duration_seconds)
        if tooltips.fullScan and tooltips.fullScan.status == "running" then
            return tooltips.fullScan
        end
        if not UA_ForeverDB then return { status = "no_saved_variables" } end
        UA_ForeverDB.scan = UA_ForeverDB.scan or {}
        local duration = type(duration_seconds) == "number" and duration_seconds > 0
            and duration_seconds or 0
        local report = {
            status = "running", objects = {}, globalStrings = {},
            duration = duration, passes = 0,
            stats = { frames = 0, regions = 0, texts = 0, secretTexts = 0,
                globals = 0, errors = 0, textVariants = 0 },
        }
        if type(_G.GetMouseFocus) == "function" then
            local ok, focus = pcall(_G.GetMouseFocus)
            if ok and focus and not is_secret(focus) then
                report.focus = object_label(focus)
            end
        end
        local tooltip = _G.GameTooltip
        if tooltip then
            local source = tooltip_line(tooltip, "Left", 1)
            local ok, lines = pcall(tooltip.NumLines, tooltip)
            report.tooltipAtStart = {
                text = safe_string(source),
                numLines = ok and safe_number(lines) or nil,
                height = safe_number(public_object_value(tooltip, "GetHeight")),
            }
        end
        UA_ForeverDB.scan.fullObjectScan = report
        tooltips.fullScan = report

        local seen, queued_pass, counted = {}, {}, {}
        local queue, head, pass_number, elapsed_total = {}, 1, 1, 0
        local enumerator, enumerated, previous_frame = _G.EnumerateFrames, false, nil
        local global_key, globals_done = nil, false
        local function enqueue(object, global_name)
            if is_secret(object) then return nil end
            local object_type = type(object)
            if object_type ~= "table" and object_type ~= "userdata" then return nil end
            local old = seen[object]
            if old then
                if global_name and #old.globalNames < 12 then
                    local known = false
                    for _, name in ipairs(old.globalNames) do
                        if name == global_name then known = true; break end
                    end
                    if not known then old.globalNames[#old.globalNames + 1] = global_name end
                end
                if queued_pass[object] ~= pass_number then
                    queue[#queue + 1] = object
                    queued_pass[object] = pass_number
                end
                return old.id
            end
            local ok, getter = pcall(function () return object.GetObjectType end)
            if not ok or type(getter) ~= "function" then return nil end
            local row = { id = #report.objects + 1, globalNames = {},
                children = {}, regions = {} }
            if global_name then row.globalNames[1] = global_name end
            report.objects[row.id] = row
            seen[object] = row
            queue[#queue + 1] = object
            queued_pass[object] = pass_number
            return row.id
        end
        for _, root in ipairs({ _G.UIParent, _G.WorldFrame, _G.GameTooltip,
            _G.Minimap }) do
            enqueue(root)
        end

        local function members(object, method, output)
            local ok_get, getter = pcall(function () return object[method] end)
            if not ok_get or type(getter) ~= "function" then return end
            local ok, values = pcall(function () return { getter(object) } end)
            if not ok then
                report.stats.errors = report.stats.errors + 1
                return
            end
            for _, value in ipairs(values) do
                local id = enqueue(value)
                if id then output[#output + 1] = id end
            end
        end

        local function process(object)
            local row = seen[object]
            row.children, row.regions = {}, {}
            row.name = object_label(object)
            row.kind = public_object_value(object, "GetObjectType") or "unknown"
            row.shown = public_object_value(object, "IsShown") == true
            row.visible = public_object_value(object, "IsVisible") == true
            row.parent = enqueue(public_object_value(object, "GetParent"))
            for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
                row[measure] = safe_number(public_object_value(object, measure))
            end
            for _, getter_name in ipairs({ "GetText", "GetTitle", "GetLabel",
                "GetDescription", "GetHyperlink" }) do
                local ok_get, getter = pcall(function () return object[getter_name] end)
                if ok_get and type(getter) == "function" then
                    local ok, value = pcall(getter, object)
                    if not ok then
                        report.stats.errors = report.stats.errors + 1
                    elseif is_secret(value) then
                        row.secretTexts = row.secretTexts or {}
                        row.secretTexts[#row.secretTexts + 1] = getter_name
                        report.stats.secretTexts = report.stats.secretTexts + 1
                    elseif type(value) == "string" then
                        row.texts = row.texts or {}
                        row.texts[getter_name] = value
                        report.stats.texts = report.stats.texts + 1
                        row.textVariants = row.textVariants or {}
                        local variants = row.textVariants[getter_name]
                        if not variants then
                            variants = {}
                            row.textVariants[getter_name] = variants
                        end
                        local known = false
                        for _, previous in ipairs(variants) do
                            if previous == value then known = true; break end
                        end
                        if not known then
                            variants[#variants + 1] = value
                            report.stats.textVariants = report.stats.textVariants + 1
                        end
                    end
                end
            end
            members(object, "GetRegions", row.regions)
            members(object, "GetChildren", row.children)
            if not counted[object] then
                counted[object] = true
                if row.kind == "FontString" or row.kind == "Texture" then
                    report.stats.regions = report.stats.regions + 1
                else
                    report.stats.frames = report.stats.frames + 1
                end
            end
        end

        local worker = CreateFrame("Frame")
        tooltips.fullScanWorker = worker
        worker:SetScript("OnUpdate", function (_, elapsed)
            elapsed_total = elapsed_total + (type(elapsed) == "number" and elapsed or 0)
            if not enumerated then
                if type(enumerator) == "function" then
                    for _ = 1, 500 do
                        local ok, frame = pcall(enumerator, previous_frame)
                        if not ok then
                            report.stats.errors = report.stats.errors + 1
                            report.frameEnumerationError = true
                            enumerated = true
                            break
                        end
                        if not frame then enumerated = true; break end
                        if frame == previous_frame then
                            report.stats.errors = report.stats.errors + 1
                            report.frameEnumerationError = true
                            enumerated = true
                            break
                        end
                        previous_frame = frame
                        enqueue(frame)
                    end
                else
                    enumerated = true
                    report.enumerateFramesUnavailable = true
                end
            end
            if not globals_done then
                for _ = 1, 500 do
                    local ok, key, value = pcall(next, _G, global_key)
                    if not ok then
                        report.stats.errors = report.stats.errors + 1
                        report.globalEnumerationError = true
                        globals_done = true
                        break
                    end
                    if key == nil then globals_done = true; break end
                    global_key = key
                    if not is_secret(key) and type(key) == "string" then
                        if not is_secret(value) and type(value) == "string" then
                            if report.globalStrings[key] == nil then
                                report.stats.globals = report.stats.globals + 1
                            end
                            report.globalStrings[key] = value
                        else
                            enqueue(value, key)
                        end
                    end
                end
            end
            for _ = 1, 500 do
                local object = queue[head]
                if not object then break end
                queue[head] = false
                head = head + 1
                process(object)
            end
            if enumerated and globals_done and head > #queue then
                report.passes = pass_number
                report.totalObjects = #report.objects
                if duration > 0 and elapsed_total < duration then
                    pass_number = pass_number + 1
                    queue, head = {}, 1
                    previous_frame, enumerated = nil, false
                    global_key, globals_done = nil, false
                    for _, root in ipairs({ _G.UIParent, _G.WorldFrame,
                        _G.GameTooltip, _G.Minimap }) do
                        enqueue(root)
                    end
                else
                    report.status = (report.frameEnumerationError
                        or report.globalEnumerationError or report.enumerateFramesUnavailable)
                        and "partial" or "complete"
                    worker:SetScript("OnUpdate", nil)
                    tooltips.fullScanWorker = nil
                    if type(on_complete) == "function" then pcall(on_complete, report) end
                end
            end
        end)
        return report
    end
end


diagnostics.install = function (tooltips, api)
    local aura_tooltip_context = api.aura_tooltip_context
    local tooltip_line = api.tooltip_line
    local tooltip_events = api.tooltip_events
    local safe_string = api.safe_string
    local safe_number = api.safe_number
    local runtime = api.runtime
    local strings = api.strings
    local is_secret = api.is_secret
    local note_tooltip_event = api.note_tooltip_event
    local mark_aura_tooltip = api.mark_aura_tooltip
    local after_aura_tooltip_rendered = api.after_aura_tooltip_rendered
    local each_shopping_tooltip = api.each_shopping_tooltip
    local is_shopping_tooltip = api.is_shopping_tooltip
    local public_frame_name = api.public_frame_name
    local entries = api.entries
    local visible_tooltip_font_strings = api.visible_tooltip_font_strings
    local MAX_TOOLTIP_LINES = api.MAX_TOOLTIP_LINES
    local minimap_tooltip_owner = api.minimap_tooltip_owner
    local translate_minimap_tooltip = api.translate_minimap_tooltip

    tooltips.aura_probe_candidate = function (tooltip)
        if not tooltip or type(tooltip.IsShown) ~= "function" then return false end
        local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
        if not ok_shown or shown ~= true then return false end
        if aura_tooltip_context(tooltip) then return true end
        return tooltip.uaForeverKind == "aura"
    end
    
    -- Explicit, bounded capture for aura tooltips. Values marked secret are never
    -- formatted or stored; the player can save this through /uaf aura while hovering.
    tooltips.capture_aura = function (tooltip)
        if not tooltip then return nil end
        local function snapshot()
            local result = {
                prepared = tooltips.prepared == true,
                events = {}, lines = {},
            }
            for event, count in pairs(tooltip_events[tooltip] or {}) do
                result.events[event] = count
            end
            local ok_shown, shown = pcall(tooltip.IsShown, tooltip)
            result.shown = ok_shown and shown == true
            local kind = safe_string(tooltip.uaForeverKind)
            if kind then result.kind = kind end
            result.id = safe_number(tooltip.uaForeverID)
            result.translated = tooltip.uaForeverKey ~= nil
            result.original = tooltip.uaForeverShowOriginal == true
            result.getSpell = type(tooltip.GetSpell) == "function"
            if result.getSpell then
                local ok_spell, name, spell_id = pcall(tooltip.GetSpell, tooltip)
                result.getSpellOK = ok_spell
                if ok_spell then
                    result.spellID = safe_number(spell_id)
                    result.spellName = safe_string(name)
                end
            end
            if type(tooltip.GetPrimaryTooltipInfo) == "function" then
                local ok_info, info = pcall(
                    tooltip.GetPrimaryTooltipInfo, tooltip)
                if ok_info and not is_secret(info) and type(info) == "table" then
                    result.getterName = safe_string(info.getterName)
                end
            end
            if type(tooltip.GetPrimaryTooltipData) == "function" then
                local ok_data, data = pcall(
                    tooltip.GetPrimaryTooltipData, tooltip)
                if ok_data and not is_secret(data) and type(data) == "table" then
                    local tooltip_data = {
                        type = safe_number(data.type),
                        id = safe_number(data.id),
                        spellID = safe_number(data.spellID),
                        dataInstanceID = safe_number(data.dataInstanceID),
                        lines = {},
                    }
                    for _, line_data in ipairs(data.lines or {}) do
                        if type(line_data) == "table" and not is_secret(line_data) then
                            tooltip_data.lines[#tooltip_data.lines + 1] = {
                                type = safe_number(line_data.type),
                                lineIndex = safe_number(line_data.lineIndex),
                                leftText = safe_string(line_data.leftText),
                                rightText = safe_string(line_data.rightText),
                            }
                        end
                    end
                    result.tooltipData = tooltip_data
                end
            end
            local ok_count, count = pcall(tooltip.NumLines, tooltip)
            result.numLines = ok_count and safe_number(count) or nil
            for index = 1, math.min(result.numLines or 20, 20) do
                for _, side in ipairs({ "Left", "Right" }) do
                    local value, region = tooltip_line(tooltip, side, index)
                    if region then
                        local claim = runtime.get(region)
                        local secret = is_secret(value)
                        local row = { index = index, side = side, secret = secret }
                        if not secret and type(value) == "string" then row.text = value end
                        if claim then
                            row.owner = safe_string(claim.owner)
                            row.slot = safe_string(claim.slot)
                        end
                        result.lines[#result.lines + 1] = row
                    end
                end
            end
            return result
        end
        local report = { before = snapshot() }
        note_tooltip_event(tooltip, "finalize")
        mark_aura_tooltip(tooltip)
        after_aura_tooltip_rendered(tooltip)
        report.after = snapshot()
        if UA_ForeverDB then
            UA_ForeverDB.scan = UA_ForeverDB.scan or {}
            UA_ForeverDB.scan.auraProbe = report
        end
        return report
    end
    
    local function public_object_value(object, method)
        if not object then return nil end
        local ok_method, callback = pcall(function () return object[method] end)
        if not ok_method or type(callback) ~= "function" then return nil end
        local ok, value = pcall(callback, object)
        if ok and not is_secret(value) then return value end
    end
    
    local function object_label(object)
        local debug_name = public_object_value(object, "GetDebugName")
        if type(debug_name) == "string" then return debug_name end
        local name = public_object_value(object, "GetName")
        return type(name) == "string" and name or "<anonymous>"
    end
    
    local function object_list(object, method)
        if not object then return {} end
        local ok_method, callback = pcall(function () return object[method] end)
        if not ok_method or type(callback) ~= "function" then return {} end
        local ok, result = pcall(function () return { callback(object) } end)
        return ok and result or {}
    end
    
    local diagnostic_tooltip_names = {
        "GameTooltip", "SettingsTooltip", "ItemRefTooltip",
        "EmbeddedItemTooltip", "BuffFrameTooltip",
    }
    
    local function visible_tooltip_windows()
        local result, seen = {}, {}
        local function add(candidate, global_name, known_tooltip)
            if not candidate or seen[candidate]
                or public_object_value(candidate, "IsShown") ~= true then return end
            local kind = public_object_value(candidate, "GetObjectType")
            local name = object_label(candidate)
            if not known_tooltip and kind ~= "GameTooltip"
                and not (type(name) == "string"
                    and name:find("Tooltip", 1, true)) then return end
            seen[candidate] = true
            result[#result + 1] = { frame = candidate, globalName = global_name }
        end
        for _, name in ipairs(diagnostic_tooltip_names) do
            add(_G[name], name, true)
        end
        each_shopping_tooltip(function (candidate)
            add(candidate, object_label(candidate), true)
        end)
        for _, candidate in ipairs(object_list(_G.UIParent, "GetChildren")) do
            add(candidate)
        end
        return result
    end
    
    local function visible_tooltip_window()
        local visible = visible_tooltip_windows()
        return visible[1] and visible[1].frame or nil
    end
    
    tooltips.visible_window = visible_tooltip_window
    
    tooltips.visible_aura_window = function ()
        for _, descriptor in ipairs(visible_tooltip_windows()) do
            local tooltip = descriptor.frame
            if aura_tooltip_context(tooltip)
                or tooltips.aura_probe_candidate(tooltip) then
                return tooltip
            end
        end
    end
    
    local function diagnostic_scalar(value)
        if value == nil or is_secret(value) then return nil end
        local kind = type(value)
        if kind == "string" then return safe_string(value) end
        if kind == "number" or kind == "boolean" then return value end
    end
    
    local function diagnostic_field(object, key)
        if not object or is_secret(object) then return nil end
        local ok, value = pcall(function () return object[key] end)
        return ok and diagnostic_scalar(value) or nil
    end
    
    local diagnostic_catalog_paths = {
        classic_string = "entries/string.lua",
        ui = "entries/forever/catalogs/ui/core.lua",
        settings = "entries/forever/catalogs/ui/settings.lua",
        skills = "entries/forever/catalogs/ui/skills.lua",
        client_domains_skills = "entries/forever/catalogs/ui/client_skills.lua",
        client_verified_ui = "entries/forever/catalogs/ui/client_verified.lua",
        client_global_strings = "entries/forever/catalogs/ui/client_global.lua",
    }
    
    local function diagnostic_edit_target(claim)
        local catalog_source = safe_string(claim.catalog_source)
        if catalog_source and diagnostic_catalog_paths[catalog_source] then
            return diagnostic_catalog_paths[catalog_source]
        end
        local slot = safe_string(claim.slot) or ""
        local category = safe_string(claim.category)
        local owner = safe_string(claim.owner)
        if slot:find("comparison.label:", 1, true) == 1 then
            return "entries/forever/catalogs/ui/tooltips.lua"
        end
        if category == "item" or owner == "item-tooltip" then
            return "entries/forever/catalogs/items/catalog.lua"
        end
        if category == "spell" or owner == "spell-tooltip" then
            return "entries/forever/catalogs/spells/"
        end
        if category == "npc" or owner == "npc-tooltip" then
            return "entries/forever/catalogs/npcs/catalog.lua"
        end
        if category == "object" or owner == "object-tooltip" then
            return "entries/forever/catalogs/objects/catalog.lua"
        end
        if owner == "generic" or slot:find("generic.", 1, true) == 1
            or slot == "comparison.header" then
            return "entries/forever/catalogs/ui/core.lua"
        end
    end
    
    local function diagnostic_lookup(region, visible)
        if not visible then return nil end
        local ok, translated, normalized, tier, category, slot, option, provenance =
            pcall(strings.find_ui_translation, visible, region)
        translated = ok and safe_string(translated) or nil
        if not translated then return nil end
        local catalog_source = type(provenance) == "table"
            and safe_string(provenance.source) or nil
        local result = {
            translated = translated,
            normalized = safe_string(normalized),
            lookupTier = safe_string(tier),
            category = safe_string(category),
            slot = safe_string(slot),
            option = safe_string(option),
            catalogSource = catalog_source,
        }
        result.editTarget = diagnostic_edit_target({
            owner = "generic", slot = result.slot or "generic.text",
            category = result.category, catalog_source = catalog_source,
        })
        return result
    end
    
    local function diagnostic_claim(claim, visible)
        if not claim then return nil end
        local result = {
            owner = safe_string(claim.owner),
            slot = safe_string(claim.slot),
            source = safe_string(claim.source),
            translated = safe_string(claim.translated),
            priority = safe_number(claim.priority),
            generation = safe_number(claim.generation),
            instance = diagnostic_scalar(claim.instance),
            phase = safe_string(claim.phase),
            category = safe_string(claim.category),
            lookupTier = safe_string(claim.lookup_tier),
            catalogSource = safe_string(claim.catalog_source),
        }
        result.editTarget = diagnostic_edit_target(claim)
        result.visibleMatchesSource = visible ~= nil and visible == result.source
        result.visibleMatchesTranslation = visible ~= nil
            and visible == result.translated
        if not result.visibleMatchesTranslation
            and type(claim.visible_matches) == "function" then
            local ok, matches = pcall(claim.visible_matches,
                visible, result.translated)
            result.visibleMatchesTranslation = ok and matches == true
        end
        if visible == nil then
            result.state = "text_unreadable"
        elseif result.visibleMatchesTranslation then
            result.state = "translation_visible"
        elseif result.visibleMatchesSource then
            result.state = "source_visible"
        else
            result.state = "claim_overwritten"
        end
        return result
    end
    
    local function diagnostic_region(region, location, index, side)
        if not region then return nil end
        local ok, value = pcall(function () return region:GetText() end)
        local secret = not ok or is_secret(value)
        local visible = not secret and safe_string(value) or nil
        return {
            location = location,
            index = index,
            side = side,
            region = object_label(region),
            shown = public_object_value(region, "IsShown") == true,
            secret = secret,
            visible = visible,
            claim = diagnostic_claim(runtime.get(region), visible),
            availableTranslation = diagnostic_lookup(region, visible),
        }
    end
    
    local function diagnostic_method(tooltip, method, fields)
        local ok_method, callback = pcall(function () return tooltip[method] end)
        if not ok_method or type(callback) ~= "function" then return nil end
        local ok, values = pcall(function () return { callback(tooltip) } end)
        local result = { ok = ok }
        if not ok then return result end
        for index, field in ipairs(fields) do
            result[field] = diagnostic_scalar(values[index])
        end
        return result
    end
    
    local function diagnostic_has_method(object, method)
        local ok, value = pcall(function () return object and object[method] end)
        return ok and type(value) == "function"
    end
    
    local function diagnostic_target_aura_children()
        local result = { children = {}, api = {}, enumeratedTooltips = {} }
        local ok, container = pcall(function ()
            return _G.TargetFrame
                and _G.TargetFrame.TargetFrameContent
                and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual
                and _G.TargetFrame.TargetFrameContent.TargetFrameContentContextual.Auras
        end)
        if not ok or not container then
            result.status = ok and "missing" or "inaccessible"
            return result
        end
    
        result.status = "found"
        result.container = {
            name = object_label(container),
            objectType = public_object_value(container, "GetObjectType"),
            shown = public_object_value(container, "IsShown") == true,
            mouseOver = public_object_value(container, "IsMouseOver") == true,
            forbidden = public_object_value(container, "IsForbidden") == true,
            protected = public_object_value(container, "IsProtected") == true,
        }
    
        local queue = {}
        for _, child in ipairs(object_list(container, "GetChildren")) do
            queue[#queue + 1] = { object = child, depth = 1 }
        end
        local seen = { [container] = true }
        local cursor = 1
        while cursor <= #queue and #result.children < 128 do
            local entry = queue[cursor]
            cursor = cursor + 1
            local child = entry.object
            if child and not seen[child] then
                seen[child] = true
                local icon = diagnostic_has_method(child, "GetIcon")
                    and public_object_value(child, "GetIcon") or nil
                local row = {
                    depth = entry.depth,
                    name = object_label(child),
                    objectType = public_object_value(child, "GetObjectType"),
                    id = diagnostic_scalar(public_object_value(child, "GetID")),
                    shown = public_object_value(child, "IsShown") == true,
                    mouseOver = public_object_value(child, "IsMouseOver") == true,
                    forbidden = public_object_value(child, "IsForbidden") == true,
                    protected = public_object_value(child, "IsProtected") == true,
                    hasGetIcon = diagnostic_has_method(child, "GetIcon"),
                    hasGetAuraInstance = diagnostic_has_method(child, "GetAuraInstance"),
                    hasShowTooltip = diagnostic_has_method(child, "ShowTooltip"),
                    hasPopulateTooltip = diagnostic_has_method(child, "PopulateTooltip"),
                    iconTexture = icon and diagnostic_scalar(
                        public_object_value(icon, "GetTexture")) or nil,
                    iconAtlas = icon and diagnostic_scalar(
                        public_object_value(icon, "GetAtlas")) or nil,
                }
                result.children[#result.children + 1] = row
                if entry.depth < 5 then
                    for _, descendant in ipairs(object_list(child, "GetChildren")) do
                        queue[#queue + 1] = {
                            object = descendant,
                            depth = entry.depth + 1,
                        }
                    end
                end
            end
        end
        result.count = #result.children
    
        -- Unit-aura enumeration is restricted in current clients and can taint
        -- protected Blizzard code even when wrapped in pcall. Diagnostics must not
        -- probe C_UnitAuras.GetAuraDataByIndex.
        result.apiStatus = "restricted"
    
        if type(_G.EnumerateFrames) == "function" then
            local current
            for _ = 1, 10000 do
                local frame_ok, frame = pcall(_G.EnumerateFrames, current)
                if not frame_ok or not frame then break end
                current = frame
                if public_object_value(frame, "IsShown") == true
                    and public_object_value(frame, "GetObjectType") == "GameTooltip" then
                    result.enumeratedTooltips[#result.enumeratedTooltips + 1] = {
                        name = object_label(frame),
                        forbidden = public_object_value(frame, "IsForbidden") == true,
                        protected = public_object_value(frame, "IsProtected") == true,
                        mouseOver = public_object_value(frame, "IsMouseOver") == true,
                        parent = object_label(public_object_value(frame, "GetParent")),
                    }
                end
            end
        end
        return result
    end
    
    tooltips.capture_mouse_focus = function ()
        local report = { foci = {}, targetAuras = diagnostic_target_aura_children() }
        local candidates = {}
        if type(_G.GetMouseFoci) == "function" then
            local ok, values = pcall(_G.GetMouseFoci)
            if ok and type(values) == "table" then
                for _, value in ipairs(values) do candidates[#candidates + 1] = value end
            end
        end
        if #candidates == 0 and type(_G.GetMouseFocus) == "function" then
            local ok, value = pcall(_G.GetMouseFocus)
            if ok and value then candidates[1] = value end
        end
    
        local seen = {}
        for focus_index, candidate in ipairs(candidates) do
            local current, depth = candidate, 0
            while current and not seen[current] and depth < 10 do
                seen[current] = true
                depth = depth + 1
                local icon = diagnostic_has_method(current, "GetIcon")
                    and public_object_value(current, "GetIcon") or nil
                report.foci[#report.foci + 1] = {
                    focus = focus_index,
                    depth = depth,
                    name = object_label(current),
                    objectType = public_object_value(current, "GetObjectType"),
                    id = diagnostic_scalar(public_object_value(current, "GetID")),
                    forbidden = public_object_value(current, "IsForbidden") == true,
                    protected = public_object_value(current, "IsProtected") == true,
                    hasAuraInstance = diagnostic_has_method(current, "GetAuraInstance"),
                    hasIcon = icon ~= nil,
                    iconTexture = icon and diagnostic_scalar(
                        public_object_value(icon, "GetTexture")) or nil,
                    iconAtlas = icon and diagnostic_scalar(
                        public_object_value(icon, "GetAtlas")) or nil,
                }
                current = public_object_value(current, "GetParent")
            end
        end
        report.count = #report.foci
        if UA_ForeverDB then
            UA_ForeverDB.scan = UA_ForeverDB.scan or {}
            UA_ForeverDB.scan.mouseProbe = report
        end
        return report
    end
    
    local function tooltip_diagnostic_snapshot(entry)
        local tooltip = entry.frame
        local result = {
            name = object_label(tooltip),
            globalName = entry.globalName,
            objectType = public_object_value(tooltip, "GetObjectType"),
            shown = public_object_value(tooltip, "IsShown") == true,
            visible = public_object_value(tooltip, "IsVisible") == true,
            owner = object_label(public_object_value(tooltip, "GetOwner")),
            parent = object_label(public_object_value(tooltip, "GetParent")),
            kind = safe_string(tooltip.uaForeverKind),
            id = safe_number(tooltip.uaForeverID),
            generation = safe_number(tooltip.uaForeverGeneration),
            sessionKey = diagnostic_scalar(tooltip.uaForeverSessionKey),
            translated = tooltip.uaForeverKey ~= nil,
            showOriginal = tooltip.uaForeverShowOriginal == true,
            hasSession = tooltip.uaForeverSessionKey ~= nil,
            events = {}, lines = {}, extraRegions = {},
        }
        if is_shopping_tooltip(tooltip) then
            result.role = "item_comparison"
        elseif tooltip == _G.GameTooltip then
            result.role = "primary"
        elseif tooltip == _G.ItemRefTooltip then
            result.role = "item_reference"
        else
            result.role = "tooltip"
        end
        if result.owner == "<anonymous>" then result.owner = nil end
        if result.parent == "<anonymous>" then result.parent = nil end
        for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
            result[measure] = safe_number(public_object_value(tooltip, measure))
        end
        for event, count in pairs(tooltip_events[tooltip] or {}) do
            result.events[event] = safe_number(count)
        end
    
        result.numLines = safe_number(public_object_value(tooltip, "NumLines"))
        result.item = diagnostic_method(tooltip, "GetItem", { "name", "link" })
        if result.item and result.item.link then
            result.item.id = safe_number(result.item.link:match("item:(%d+)"))
        end
        result.spell = diagnostic_method(tooltip, "GetSpell",
            { "name", "second", "third" })
        if result.spell then
            if safe_number(result.spell.third) then
                result.spell.id = safe_number(result.spell.third)
                result.spell.rank = safe_string(result.spell.second)
            elseif safe_number(result.spell.second) then
                result.spell.id = safe_number(result.spell.second)
            else
                result.spell.rank = safe_string(result.spell.second)
            end
        end
        result.unit = diagnostic_method(tooltip, "GetUnit", { "name", "token" })
        result.hyperlink = diagnostic_method(tooltip, "GetHyperlink", { "value" })
    
        local ok_data_method, get_tooltip_data = pcall(function ()
            return tooltip.GetTooltipData
        end)
        local ok_data, data = false, nil
        if ok_data_method and type(get_tooltip_data) == "function" then
            ok_data, data = pcall(get_tooltip_data, tooltip)
        end
        if type(data) == "table" and ok_data and not is_secret(data) then
            result.tooltipData = {
                type = diagnostic_field(data, "type"),
                id = diagnostic_field(data, "id"),
                guid = diagnostic_field(data, "guid"),
                hyperlink = diagnostic_field(data, "hyperlink"),
                lines = {},
            }
            local ok_lines, data_lines = pcall(function () return data.lines end)
            local ok_count, line_count = false, 0
            if ok_lines and type(data_lines) == "table"
                and not is_secret(data_lines) then
                ok_count, line_count = pcall(function () return #data_lines end)
            end
            if ok_count then
                for index = 1, math.min(line_count, MAX_TOOLTIP_LINES) do
                    local ok_line, line = pcall(function ()
                        return data_lines[index]
                    end)
                    if ok_line and type(line) == "table" and not is_secret(line) then
                        result.tooltipData.lines[#result.tooltipData.lines + 1] = {
                            index = index,
                            type = diagnostic_field(line, "type"),
                            leftText = diagnostic_field(line, "leftText"),
                            rightText = diagnostic_field(line, "rightText"),
                        }
                    end
                end
            end
        elseif ok_data_method and type(get_tooltip_data) == "function" then
            result.tooltipData = { ok = ok_data }
        end
    
        if result.item then
            if not result.item.id and result.kind == "item"
                and result.tooltipData then
                result.item.id = safe_number(result.tooltipData.id)
            end
            local item_entry = result.item.id
                and entries.get_entry("item", result.item.id) or nil
            local translated_name = item_entry and safe_string(item_entry[1])
                or result.item.name and safe_string(
                    entries.lookup_name("item", result.item.name)) or nil
            result.item.catalogFound = item_entry ~= nil
                or translated_name ~= nil
            result.item.catalogName = translated_name
            result.item.editTarget =
                "entries/forever/catalogs/items/catalog.lua"
        end
        if result.spell then
            if not result.spell.id and result.kind == "spell"
                and result.tooltipData then
                result.spell.id = safe_number(result.tooltipData.id)
            end
            local spell_entry = result.spell.id
                and entries.get_entry("spell", result.spell.id) or nil
            local translated_name = spell_entry and safe_string(spell_entry[1])
                or result.spell.name and safe_string(
                    entries.lookup_name("spell", result.spell.name)) or nil
            result.spell.catalogFound = spell_entry ~= nil
                or translated_name ~= nil
            result.spell.catalogName = translated_name
            result.spell.editTarget =
                "entries/forever/catalogs/spells/"
        end
    
        local seen_regions = {}
        local count = math.min(result.numLines or MAX_TOOLTIP_LINES,
            MAX_TOOLTIP_LINES)
        for index = 1, count do
            for _, side in ipairs({ "Left", "Right" }) do
                local _, region = tooltip_line(tooltip, side, index, true)
                if region then
                    seen_regions[region] = true
                    result.lines[#result.lines + 1] = diagnostic_region(region,
                        side .. tostring(index), index, side)
                end
            end
        end
    
        local ok_header, header = pcall(function () return tooltip.CompareHeader end)
        local ok_label, label = pcall(function () return header and header.Label end)
        if ok_header and ok_label and label then
            seen_regions[label] = true
            result.compareHeader = diagnostic_region(label,
                "CompareHeader.Label")
        end
    
        for index, region in ipairs(visible_tooltip_font_strings(tooltip)) do
            if not seen_regions[region] then
                result.extraRegions[#result.extraRegions + 1] = diagnostic_region(
                    region, "FontString" .. tostring(index))
            end
        end
        return result
    end
    
    -- Capture every visible tooltip as plain SavedVariables-safe data. This is
    -- intentionally explicit rather than exhaustive: it records the identity,
    -- native tooltip data, rendered regions and translation claims needed to
    -- decide whether a catalog entry is missing or a later Blizzard write won.
    tooltips.capture_visible_tooltips = function (save)
        local visible = visible_tooltip_windows()
        local report = {
            version = 1,
            status = #visible > 0 and "captured" or "no_tooltip",
            count = #visible,
            tooltips = {},
        }
        if type(_G.time) == "function" then
            local ok, timestamp = pcall(_G.time)
            report.timestamp = ok and safe_number(timestamp) or nil
        end
        if type(_G.GetBuildInfo) == "function" then
            local ok, version, build, date, interface = pcall(_G.GetBuildInfo)
            if ok then
                report.client = { version = safe_string(version),
                    build = safe_string(build), date = safe_string(date),
                    interface = safe_number(interface) }
            end
        end
        local focus
        if type(_G.GetMouseFocus) == "function" then
            local ok, value = pcall(_G.GetMouseFocus)
            if ok and not is_secret(value) then focus = value end
        end
        if not focus and type(_G.GetMouseFoci) == "function" then
            local ok, values = pcall(_G.GetMouseFoci)
            if ok and type(values) == "table" and not is_secret(values)
                and not is_secret(values[1]) then focus = values[1] end
        end
        if focus then report.mouseFocus = object_label(focus) end
        for _, entry in ipairs(visible) do
            report.tooltips[#report.tooltips + 1] =
                tooltip_diagnostic_snapshot(entry)
        end
        if save ~= false and UA_ForeverDB then
            UA_ForeverDB.scan = UA_ForeverDB.scan or {}
            UA_ForeverDB.scan.tooltipProbe = report
        end
        return report
    end
    
    -- One-shot diagnostic of every object under the visible tooltip window.
    -- It never formats protected values and records only a marker for secret text.
    tooltips.scan_window = function (save)
        local root = visible_tooltip_window()
        local report = { status = root and "captured" or "no_tooltip",
            root = root and object_label(root) or nil, objects = {}, topLevel = {} }
        for _, frame in ipairs(object_list(_G.UIParent, "GetChildren")) do
            if public_object_value(frame, "IsShown") == true then
                report.topLevel[#report.topLevel + 1] = {
                    name = object_label(frame),
                    kind = public_object_value(frame, "GetObjectType"),
                }
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
                and not is_secret(values[1]) then focus = values[1] end
        end
        if focus then report.mouseFocus = object_label(focus) end
        if root then
            local count = public_object_value(root, "NumLines")
            report.tooltip = {
                numLines = safe_number(count),
                kind = safe_string(root.uaForeverKind),
                id = safe_number(root.uaForeverID),
                showOriginal = root.uaForeverShowOriginal == true,
                hasSession = root.uaForeverSessionKey ~= nil,
                translated = root.uaForeverKey ~= nil,
                lines = tooltips.inspect(root, 12),
            }
            for event, event_count in pairs(tooltip_events[root] or {}) do
                report.tooltip[event] = event_count
            end
            if root == _G.GameTooltip then
                report.tooltip.minimapHandler = "linewise-v1"
                local before = tooltip_line(root, "Left", 1)
                before = safe_string(before)
                if before and minimap_tooltip_owner(root) then
                    local ok, applied = pcall(translate_minimap_tooltip, root)
                    local after, region = tooltip_line(root, "Left", 1)
                    local claim = region and runtime.get(region)
                    report.tooltip.probe = {
                        ok = ok, applied = ok and applied == true,
                        before = before,
                        after = safe_string(after),
                        claim = claim and claim.slot or nil,
                    }
                end
            end
            local owner = public_object_value(root, "GetOwner")
            if owner then report.owner = object_label(owner) end
            local seen = {}
            local function visit(object, path, depth)
                if not object or seen[object] or #report.objects >= 3000 then return end
                seen[object] = true
                local row = {
                    path = path, name = object_label(object),
                    kind = public_object_value(object, "GetObjectType"),
                    shown = public_object_value(object, "IsShown") == true,
                }
                for _, measure in ipairs({ "GetLeft", "GetTop", "GetWidth", "GetHeight" }) do
                    row[measure] = safe_number(public_object_value(object, measure))
                end
                local ok_text, value = pcall(function ()
                    return type(object.GetText) == "function" and object:GetText() or nil
                end)
                if ok_text then
                    if is_secret(value) then
                        row.secretText = true
                    elseif type(value) == "string" then
                        row.text = value:sub(1, 1000)
                        if #value > 1000 then row.textTruncated = true end
                    end
                end
                report.objects[#report.objects + 1] = row
                if depth >= 20 then return end
                for index, region in ipairs(object_list(object, "GetRegions")) do
                    visit(region, path .. "/region:" .. index, depth + 1)
                end
                for index, child in ipairs(object_list(object, "GetChildren")) do
                    visit(child, path .. "/child:" .. index, depth + 1)
                end
            end
            visit(root, "root", 0)
            report.truncated = #report.objects >= 3000
        end
        if save ~= false and UA_ForeverDB then
            UA_ForeverDB.scan = UA_ForeverDB.scan or {}
            UA_ForeverDB.scan.windowProbe = report
        end
        return report
    end

    api.object_label = object_label
    api.public_object_value = public_object_value
    diagnostics.install_full_scan(tooltips, api)
end
