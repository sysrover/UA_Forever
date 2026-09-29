local _, addon_table = ...

local comparison_adapter = addon_table.use("tooltip_comparison_adapter")

comparison_adapter.install = function (api)
    local begin_tooltip = api.begin_tooltip
    local entries = api.entries
    local hooks = api.hooks
    local is_secret = api.is_secret
    local item_name_visible_matches = api.item_name_visible_matches
    local MAX_TOOLTIP_LINES = api.MAX_TOOLTIP_LINES
    local options = api.options
    local rewrite_generic_lines = api.rewrite_generic_lines
    local runtime = api.runtime
    local safe_number = api.safe_number
    local safe_string = api.safe_string
    local set_tooltip_translation = api.set_tooltip_translation
    local strings = api.strings
    local tooltip_catalog = api.tooltip_catalog
    local tooltip_line = api.tooltip_line
    local utils = api.utils

    local function is_shopping_tooltip(tooltip)
        if tooltip == _G.ShoppingTooltip1 or tooltip == _G.ShoppingTooltip2
            or tooltip == _G.ItemRefShoppingTooltip1
            or tooltip == _G.ItemRefShoppingTooltip2 then return true end
        if not tooltip or type(tooltip.GetName) ~= "function" then return false end
        local ok, name = pcall(tooltip.GetName, tooltip)
        name = ok and safe_string(name) or nil
        return name and name:match("ShoppingTooltip%d+$") ~= nil or false
    end
    
    local comparison_manager_hooked = false
    local prepare_comparison_manager = function () return false end
    local function comparison_manager_owns(tooltip)
        if not comparison_manager_hooked then return false end
        local manager = _G.TooltipComparisonManager
        local primary = manager and manager.tooltip
        for _, comparison in ipairs(primary and primary.shoppingTooltips or {}) do
            if comparison == tooltip then return true end
        end
        return false
    end
    
    local legacy_shopping_tooltip_names = {
        "ShoppingTooltip1", "ShoppingTooltip2",
        "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2",
    }
    
    local function each_shopping_tooltip(callback)
        if type(callback) ~= "function" then return end
        local seen = {}
        local function visit_owner(owner)
            if not owner then return end
            local ok, collection = pcall(function () return owner.shoppingTooltips end)
            if not ok or is_secret(collection) or type(collection) ~= "table" then return end
            for _, comparison in ipairs(collection) do
                if comparison and not is_secret(comparison) and not seen[comparison] then
                    seen[comparison] = true
                    callback(comparison)
                end
            end
        end
        visit_owner(_G.GameTooltip)
        visit_owner(_G.ItemRefTooltip)
        local manager = _G.TooltipComparisonManager
        local ok, primary = pcall(function () return manager and manager.tooltip end)
        if ok and not is_secret(primary) then visit_owner(primary) end
        for _, name in ipairs(legacy_shopping_tooltip_names) do
            local comparison = _G[name]
            if comparison and not is_secret(comparison) and not seen[comparison] then
                seen[comparison] = true
                callback(comparison)
            end
        end
    end
    
    local comparison_item_labels = tooltip_catalog.comparison_item_labels
    local comparison_guarded_regions = setmetatable({}, { __mode = "k" })
    local comparison_guard_swept_tooltips = setmetatable({}, { __mode = "k" })
    local comparison_translation_cache = setmetatable({}, { __mode = "k" })
    local comparison_bootstrap_keys = setmetatable({}, { __mode = "k" })
    local comparison_claim_regions = setmetatable({}, { __mode = "k" })
    
    local function remember_comparison_claim(tooltip, region)
        if not tooltip or not region then return end
        local state = comparison_claim_regions[tooltip]
        if not state then
            state = { regions = {}, seen = setmetatable({}, { __mode = "k" }) }
            comparison_claim_regions[tooltip] = state
        end
        if state.seen[region] then return end
        state.seen[region] = true
        state.regions[#state.regions + 1] = region
    end
    
    local function comparison_name_translation(source)
        local translated = entries.lookup_name("item", source)
        if translated then return utils.cap(translated) end
        local base, suffix = source:match("^(.-) (of .-)$")
        local translated_base = base and entries.lookup_name("item", base)
        local translated_suffix = suffix and entries.get_item_suffix(source)
        if translated_base and translated_suffix then
            return utils.cap(translated_base .. " " .. translated_suffix)
        end
    end
    
    local function apply_comparison_claim(tooltip, region, cached, source,
        translated, slot, category, owner, source_kind, matcher, catalog_source)
        if not translated or translated == source
            or options.is_bilingual_tooltip() then return false end
        local generation = tooltip.uaForeverGeneration
        local instance = tooltip.uaForeverSessionKey
        local spec = cached.runtime_spec
        if not spec or spec.generation ~= generation or spec.instance ~= instance then
            spec = {
                owner = owner, slot = slot, source = source,
                translated = translated,
                priority = owner == "generic"
                    and runtime.priority_for_source(source_kind)
                    or runtime.PRIORITY.DOMAIN,
                category = category,
                option = owner == "item-tooltip" and "translate_item" or nil,
                generation = generation, tooltip = tooltip,
                surface = tooltip, instance = instance, phase = "dynamic",
                lookup_tier = source_kind or (category and "domain")
                    or "tooltip-adapter",
                catalog_source = catalog_source,
                allow_unknown_source = true,
                visible_matches = matcher,
                record_runtime = false,
                verify_after_apply = false,
                reapply_cached = true,
            }
            cached.runtime_spec = spec
        end
        local applied = runtime.apply(region, spec)
        if applied then remember_comparison_claim(tooltip, region) end
        return applied
    end
    
    local function apply_comparison_region_write(tooltip, written, native, side, index)
        if runtime.is_applying(written) or tooltip.uaForeverShowOriginal then return end
        native = safe_string(native)
        if not native then return end
        if not tooltip.uaForeverSessionKey then
            begin_tooltip(tooltip, "comparison-write")
            tooltip.uaForeverKind = "item"
        end
        local cached = comparison_translation_cache[written]
        local translated, category, slot, source_kind, matcher
        if cached and cached.source == native then
            translated = cached.translated or nil
            category, slot = cached.category, cached.slot
            source_kind, matcher = cached.source_kind, cached.matcher
        else
            if side == "Left" and index == 1 then
                translated = comparison_name_translation(native)
                category = "item"
                slot = "item.name"
                matcher = item_name_visible_matches
            else
                translated = comparison_item_labels[native]
                if not translated then
                    translated, _, source_kind = strings.find_ui_translation(
                        native, written)
                end
                slot = "comparison.write:" .. side .. index
            end
            cached = {
                source = native, translated = translated or false,
                category = category, slot = slot,
                source_kind = source_kind, matcher = matcher,
            }
            comparison_translation_cache[written] = cached
        end
        apply_comparison_claim(tooltip, written, cached, native, translated,
            slot, category, "item-tooltip", source_kind, matcher)
    end
    
    local function guard_comparison_region(tooltip, region, side, index)
        if not region or comparison_guarded_regions[region] then return false end
        local installed = hooks.region(region, "SetText", function (written, native)
            apply_comparison_region_write(tooltip, written, native, side, index)
        end)
        if installed then comparison_guarded_regions[region] = true end
        return installed == true
    end
    
    local function apply_comparison_header_write(tooltip, written, native)
        if runtime.is_applying(written) or tooltip.uaForeverShowOriginal then return end
        native = safe_string(native)
        if not native then return end
        local cached = comparison_translation_cache[written]
        local translated, source_kind, catalog_source
        if cached and cached.source == native then
            translated = cached.translated or nil
            source_kind = cached.source_kind
            catalog_source = cached.catalog_source
        else
            local provenance
            translated, _, source_kind, _, _, _, provenance =
                strings.find_ui_translation(native, written)
            catalog_source = provenance and provenance.source
            cached = {
                source = native, translated = translated or false,
                source_kind = source_kind, catalog_source = catalog_source,
            }
            comparison_translation_cache[written] = cached
        end
        apply_comparison_claim(tooltip, written, cached, native, translated,
            "comparison.header", nil, "generic", source_kind, nil,
            catalog_source)
    end
    
    local function guard_comparison_header(tooltip, label)
        if not label or comparison_guarded_regions[label] then return false end
        local installed = hooks.region(label, "SetText", function (written, native)
            apply_comparison_header_write(tooltip, written, native)
        end)
        if installed then comparison_guarded_regions[label] = true end
        return installed == true
    end

    local function comparison_snapshot(tooltip)
        local ok_count, count = pcall(tooltip.NumLines, tooltip)
        count = ok_count and safe_number(count) or nil
        count = math.max(1, math.min(count or MAX_TOOLTIP_LINES,
            MAX_TOOLTIP_LINES))
        local snapshot = { count = count }
        for index = 1, count do
            local left, left_region = tooltip_line(tooltip, "Left", index,
                index == 1)
            local right, right_region = tooltip_line(tooltip, "Right", index,
                index == 1)
            snapshot[index] = {
                left = { source = left, region = left_region },
                right = { source = right, region = right_region },
            }
        end
        return snapshot
    end
    
    local function install_comparison_text_guards(tooltip)
        if not tooltip then return 0 end
        local ok_count, count = pcall(tooltip.NumLines, tooltip)
        count = ok_count and safe_number(count) or 0
        count = math.max(0, math.min(count or 0, MAX_TOOLTIP_LINES))
        local previous_count = tooltip.uaForeverComparisonGuardLineCount or 0
        local installed = 0
        local first_sweep = not comparison_guard_swept_tooltips[tooltip]
        local first_index = first_sweep and 1 or previous_count + 1
        local last_index = first_sweep and MAX_TOOLTIP_LINES or count
        if first_sweep or count > previous_count then
            -- Build 70009 appends comparison deltas after the Item post-call.
            -- Guard every already-created hidden row once, then only inspect rows
            -- beyond the previous visible count on later rebuilds.
            for index = first_index, last_index do
                for _, side in ipairs({ "Left", "Right" }) do
                    local visible, region = tooltip_line(tooltip, side, index, true)
                    if guard_comparison_region(tooltip, region, side, index) then
                        installed = installed + 1
                        apply_comparison_region_write(tooltip, region, visible,
                            side, index)
                    end
                end
            end
            comparison_guard_swept_tooltips[tooltip] = true
            tooltip.uaForeverComparisonGuardLineCount = math.max(previous_count, count)
        end
        local label = tooltip.CompareHeader and tooltip.CompareHeader.Label
        if guard_comparison_header(tooltip, label) then
            installed = installed + 1
            local ok, visible = pcall(label.GetText, label)
            if ok then apply_comparison_header_write(tooltip, label, visible) end
        end
        return installed
    end
    
    local function translate_shopping_tooltip(tooltip)
        if not tooltip or tooltip.uaForeverShowOriginal then return false end
        local snapshot = comparison_snapshot(tooltip)
        local title = snapshot[1] and snapshot[1].left
        local visible, region = title and title.source, title and title.region
        local claim = region and runtime.get(region)
        local source = claim and claim.owner == "item-tooltip" and claim.source or visible
        source = safe_string(source)
        if source then
            local translated = comparison_name_translation(source)
            if translated and visible ~= translated then
                set_tooltip_translation(tooltip, region, source, translated,
                    "item.name", "item", "item-tooltip", nil, false, false, nil,
                    item_name_visible_matches)
            end
        end
    
        local header = tooltip.CompareHeader
        local label = header and header.Label
        if label and type(label.GetText) == "function" then
            local ok, current = pcall(label.GetText, label)
            current = ok and safe_string(current) or nil
            if current then
                local translated, _, source_kind, _, _, _, provenance =
                    strings.find_ui_translation(current, label)
                if translated and translated ~= current then
                    set_tooltip_translation(tooltip, label, current, translated,
                        "comparison.header", nil, "generic", source_kind, false,
                        false, nil, nil, provenance and provenance.source)
                end
            end
        end
    
        rewrite_generic_lines(tooltip, snapshot.count, 2, false, false,
            snapshot)
        if snapshot.count > 1 then
            for index = 2, snapshot.count do
                for _, side in ipairs({ "Left", "Right" }) do
                    local row = snapshot[index]
                    local cell = row and row[side == "Left" and "left" or "right"]
                    local text = cell and cell.source
                    local label_region = cell and cell.region
                    local translated_label
                    text = safe_string(text)
                    if text then translated_label = comparison_item_labels[text] end
                    if translated_label and label_region then
                        set_tooltip_translation(tooltip, label_region, text, translated_label,
                            "comparison.label:" .. side .. index, nil,
                            "item-tooltip", nil, false, false)
                    end
                end
            end
        end
        return true
    end
    
    local function comparison_identity_key(data)
        if not data or is_secret(data) then return nil end
        local ok, guid, hyperlink, id = pcall(function ()
            return data.guid, data.hyperlink, data.id or data.itemID
        end)
        if not ok then return nil end
        guid = safe_string(guid)
        if guid then return "guid:" .. guid end
        hyperlink = safe_string(hyperlink)
        if hyperlink then return "link:" .. hyperlink end
        id = safe_number(id)
        if id then return "id:" .. tostring(id) end
    end
    
    local function comparison_item_key(tooltip, data)
        local key = comparison_identity_key(data)
        if key then return key end
        local manager = _G.TooltipComparisonManager
        local ok, displayed = pcall(function ()
            local info = manager and manager.compareInfo
            local shopping = manager and manager.tooltip
                and manager.tooltip.shoppingTooltips
            if not info or type(shopping) ~= "table" then return nil end
            if shopping[1] == tooltip then return info.item end
            if shopping[2] == tooltip then
                local additional = info.additionalItems
                return type(additional) == "table"
                    and additional[manager.comparisonIndex or 1] or nil
            end
        end)
        if not ok then return nil end
        return comparison_identity_key(displayed)
    end
    
    local function comparison_title_claim_is_visible(tooltip)
        local visible, region = tooltip_line(tooltip, "Left", 1)
        local claim = region and runtime.get(region)
        return claim and claim.owner == "item-tooltip"
            and safe_string(visible) == claim.translated
    end
    
    local function collect_comparison_claims(tooltip)
        runtime.for_each_claim(tooltip, function (region, claim)
            if claim and (claim.owner == "item-tooltip"
                or claim.slot == "comparison.header") then
                remember_comparison_claim(tooltip, region)
            end
        end)
    end
    
    local function reapply_comparison_claims(tooltip)
        local state = comparison_claim_regions[tooltip]
        if not state then return false end
        for _, region in ipairs(state.regions) do
            local claim = runtime.get(region)
            if claim and claim.surface == tooltip then
                runtime.show_original(region, false)
            end
        end
        return comparison_title_claim_is_visible(tooltip)
    end
    
    local function bootstrap_comparison_translation(tooltip, data)
        local key = comparison_item_key(tooltip, data)
        if key and comparison_bootstrap_keys[tooltip] == key then
            if comparison_title_claim_is_visible(tooltip) then return false end
            if reapply_comparison_claims(tooltip) then return false end
        end
        translate_shopping_tooltip(tooltip)
        if key and comparison_title_claim_is_visible(tooltip) then
            comparison_bootstrap_keys[tooltip] = key
            collect_comparison_claims(tooltip)
        end
        return true
    end
    
    local function translate_comparison_fallback_once(tooltip, generation, allow_hidden)
        if not tooltip or tooltip.uaForeverGeneration ~= generation
            or tooltip.uaForeverComparisonFallbackGeneration == generation then
            return false
        end
        if not allow_hidden then
            local shown_ok, shown = pcall(tooltip.IsShown, tooltip)
            if not shown_ok or shown ~= true then return false end
        end
        if not translate_shopping_tooltip(tooltip) then return false end
        tooltip.uaForeverComparisonManagedPending = nil
        tooltip.uaForeverComparisonCompleteGeneration = generation
        tooltip.uaForeverComparisonFallbackGeneration = generation
        return true
    end

    local function after_comparison_item(manager, is_primary)
        if not manager or not manager.tooltip or is_secret(is_primary) then return end
        local comparisons = manager.tooltip.shoppingTooltips
        local comparison = comparisons and comparisons[is_primary and 1 or 2]
        if not comparison then return end
        if not comparison.uaForeverComparisonManagedPending
            or not comparison.uaForeverGeneration then
            begin_tooltip(comparison, "comparison-item")
            comparison.uaForeverKind = "item"
            comparison.uaForeverComparisonManagedPending = true
        end
        local installed = install_comparison_text_guards(comparison)
        if installed > 0 then
            runtime.metric("comparison_guard_installs", comparison,
                comparison.uaForeverGeneration, installed)
        end
    end
    
    prepare_comparison_manager = function ()
        if comparison_manager_hooked then return true end
        local manager = _G.TooltipComparisonManager
        if not manager then return false end
        local item_hooked = hooks.region(manager,
            "SetItemTooltip", after_comparison_item) == true
        -- The build-70009 Item post-call installs guards before delta rows are
        -- appended. This manager post-call is retained only to discover newly
        -- allocated rows once; it does no work on steady-state rebuilds.
        comparison_manager_hooked = item_hooked
        return comparison_manager_hooked
    end

    return {
        bootstrap = bootstrap_comparison_translation,
        comparison_manager_owns = comparison_manager_owns,
        each = each_shopping_tooltip,
        fallback_once = translate_comparison_fallback_once,
        install_text_guards = install_comparison_text_guards,
        is_shopping = is_shopping_tooltip,
        prepare_manager = prepare_comparison_manager,
        translate = translate_shopping_tooltip,
    }
end
