local _, addon_table = ...

local comparison_adapter = addon_table.use("tooltip_comparison_adapter")

comparison_adapter.install = function (api)
    local begin_tooltip = api.begin_tooltip
    local hooks = api.hooks
    local is_secret = api.is_secret
    local item_name_visible_matches = api.item_name_visible_matches
    local item_adapter = api.item_adapter
    local MAX_TOOLTIP_LINES = api.MAX_TOOLTIP_LINES
    local options = api.options
    local runtime = api.runtime
    local safe_number = api.safe_number
    local safe_string = api.safe_string
    local set_tooltip_translation = api.set_tooltip_translation
    local strings = api.strings
    local tooltip_catalog = api.tooltip_catalog
    local tooltip_line = api.tooltip_line

    local function is_shopping_tooltip(tooltip)
        local manager = _G.TooltipComparisonManager
        local owner = manager and manager.tooltip
        local managed = owner and owner.shoppingTooltips
        if type(managed) == "table" then
            for _, comparison in ipairs(managed) do
                if comparison == tooltip then return true end
            end
        end
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
    local comparison_condition_translation
    
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
    
    local function comparison_name_translation(tooltip, source)
        local item_id = tooltip and tooltip.uaForeverItemID
        return item_id and item_adapter.get_translated_name(item_id, source)
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
    
    local function comparison_reference_item_id(reference)
        if not reference or is_secret(reference) then return nil end
        local ok, item_id, item_info = pcall(function ()
            return reference.id or reference.itemID,
                reference.guid or reference.hyperlink
        end)
        item_id = ok and safe_number(item_id) or nil
        if item_id then return item_id end
        if not ok or is_secret(item_info) or not item_info
            or not _G.C_Item
            or type(_G.C_Item.GetItemIDForItemInfo) ~= "function" then return nil end
        local found_ok, found = pcall(_G.C_Item.GetItemIDForItemInfo, item_info)
        return found_ok and safe_number(found) or nil
    end

    comparison_condition_translation = function (source)
        if type(source) ~= "string" then return nil end
        if not source:match("^%(With .+ equipped in your .+%-hand%)$") then
            return nil
        end
        local manager = _G.TooltipComparisonManager
        local comparisons = manager and manager.tooltip
            and manager.tooltip.shoppingTooltips
        if type(comparisons) ~= "table" then return nil end
        local item_ids = {}
        for _, related in ipairs(comparisons) do
            local related_id = related and related.uaForeverItemID
            if related_id then item_ids[#item_ids + 1] = related_id end
        end
        local info = manager and manager.compareInfo
        local references = info and { info.item } or {}
        for _, reference in ipairs(info and info.additionalItems or {}) do
            references[#references + 1] = reference
        end
        for _, reference in ipairs(references) do
            local reference_id = comparison_reference_item_id(reference)
            if reference_id then item_ids[#item_ids + 1] = reference_id end
        end
        for _, related_id in ipairs(item_ids) do
            local with_name = item_adapter.replace_known_name(related_id, source)
            if with_name then
                local name = with_name:match(
                    "^%(With (.-) equipped in your off%-hand%)$")
                if name then
                    return "(З " .. name .. ", спорядженим у лівій руці)"
                end
                name = with_name:match(
                    "^%(With (.-) equipped in your main%-hand%)$")
                if name then
                    return "(З " .. name .. ", спорядженим у правій руці)"
                end
            end
        end
    end

    local function translate_comparison_conditions(tooltip, snapshot)
        local applied = false
        for index = 2, snapshot.count do
            local cell = snapshot[index] and snapshot[index].left
            local source = cell and safe_string(cell.source)
            local region = cell and cell.region
            if source and region then
                local translated = comparison_condition_translation(source)
                if translated then
                    applied = set_tooltip_translation(
                        tooltip, region, source, translated,
                        "comparison.condition:" .. index, nil,
                        "item-tooltip", nil, false, false
                    ) or applied
                end
            end
        end
        return applied
    end

    local function restore_comparison_markup(source, translated)
        return tooltip_catalog.restore_item_markup(source, translated)
    end

    local function translate_comparison_region(tooltip, region, source, side,
        index)
        if not comparison_manager_owns(tooltip)
            or tooltip.uaForeverShowOriginal then return false end
        source = safe_string(source)
        if not source or not region then return false end

        -- Comparison rows are pooled FontStrings. Cache against the concrete
        -- region instead of retaining every numeric delta ever displayed.
        local cached = comparison_translation_cache[region]
        if cached and cached.source ~= source then cached = nil end
        local translated, source_kind, catalog_source, owner
        if cached then
            translated = cached.translated or nil
            source_kind = cached.source_kind
            catalog_source = cached.catalog_source
            owner = cached.owner
        else
            translated = comparison_condition_translation(source)
            if not translated then
                local clean_source = source:gsub("|c%x%x%x%x%x%x%x%x", "")
                    :gsub("|r", "")
                translated = item_adapter.translate_line(clean_source)
            end
            owner = translated and "item-tooltip" or nil
            translated = restore_comparison_markup(source, translated)
            cached = {
                source = source,
                translated = translated or false,
                source_kind = source_kind,
                catalog_source = catalog_source,
                owner = owner,
            }
            comparison_translation_cache[region] = cached
        end
        if not translated then return false end
        return apply_comparison_claim(tooltip, region, cached, source,
            translated, "comparison.appended:" .. side .. ":" .. index,
            nil, owner, source_kind, nil, catalog_source)
    end

    local function guard_comparison_region(tooltip, region, side, index)
        if not region or comparison_guarded_regions[region] then return false end
        local installed = hooks.region(region, "SetText", function (written, native)
            if runtime.is_applying(written)
                or not tooltip.uaForeverComparisonWriteReady then return end
            translate_comparison_region(tooltip, written, native, side, index)
        end)
        if installed then comparison_guarded_regions[region] = true end
        return installed == true
    end

    local function install_comparison_text_guards(tooltip)
        if not tooltip then return false end
        if not comparison_guard_swept_tooltips[tooltip] then
            -- FontStrings are pooled by the client. Guard every region that
            -- already exists once; rows created later are guarded by AddLine.
            for index = 1, MAX_TOOLTIP_LINES do
                for _, side in ipairs({ "Left", "Right" }) do
                    local _, region = tooltip_line(tooltip, side, index, true)
                    guard_comparison_region(tooltip, region, side, index)
                end
            end
            comparison_guard_swept_tooltips[tooltip] = true
        end
        hooks.region(tooltip, "ClearLines", function (self)
            self.uaForeverComparisonWriteReady = false
        end)
        hooks.region(tooltip, "AddLine", function (self, native)
            if not self.uaForeverComparisonWriteReady then return end
            local count_ok, count = pcall(self.NumLines, self)
            count = count_ok and safe_number(count) or nil
            if not count or count < 1 then return end
            local visible, region = tooltip_line(self, "Left", count, true)
            if not region then return end
            guard_comparison_region(self, region, "Left", count)
            if safe_string(visible) == safe_string(native) then
                translate_comparison_region(self, region, native, "Left", count)
            end
        end)
        return true
    end

    local function translate_shopping_tooltip(tooltip)
        if not tooltip or tooltip.uaForeverShowOriginal then return false end
        local structured = tooltip.uaForeverComparisonData
        local item_id = tooltip.uaForeverItemID
        if structured and item_id then
            item_adapter.add(tooltip, structured, item_id)
        end
        local snapshot = comparison_snapshot(tooltip)
        local title = snapshot[1] and snapshot[1].left
        local visible, region = title and title.source, title and title.region
        local claim = region and runtime.get(region)
        local source = claim and claim.owner == "item-tooltip" and claim.source or visible
        source = safe_string(source)
        if source then
            local translated = comparison_name_translation(tooltip, source)
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
    
        translate_comparison_conditions(tooltip, snapshot)
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
    
    local function collect_comparison_claims(tooltip, reset)
        if reset then comparison_claim_regions[tooltip] = nil end
        runtime.for_each_claim(tooltip, function (region, claim)
            if claim and claim.surface == tooltip then
                remember_comparison_claim(tooltip, region)
            end
        end)
    end
    
    local function reapply_comparison_claims(tooltip)
        local state = comparison_claim_regions[tooltip]
        if not state then return false end
        local rows = {}
        for _, region in ipairs(state.regions) do
            local claim = runtime.get(region)
            if claim and claim.surface == tooltip then
                local ok, current = pcall(region.GetText, region)
                current = ok and safe_string(current) or nil
                -- Build 70058 clears every row before ProcessInfo(), then
                -- appends comparison deltas afterwards. A cached delta region
                -- can therefore be empty at this exact point; its writer hook
                -- will restore the translation when Blizzard appends it.
                if current then
                    if current ~= claim.source
                        and current ~= claim.translated
                        and current ~= claim.name_original then return false end
                    rows[#rows + 1] = { region = region, claim = claim }
                end
            end
        end
        if #rows == 0 then return false end
        for _, row in ipairs(rows) do
            local claim = row.claim
            local disabled = claim.option
                and not options.can_translate(claim.option)
            for _, option in ipairs(claim.options or {}) do
                if not options.can_translate(option) then disabled = true end
            end
            runtime.show_original(row.region,
                tooltip.uaForeverShowOriginal == true or disabled
                    or options.is_bilingual_tooltip())
        end
        return comparison_title_claim_is_visible(tooltip)
    end

    local function bootstrap_comparison_translation(tooltip, data)
        local item_id
        if type(data) == "table" and not is_secret(data) then
            local ok, value = pcall(function ()
                return data.id or data.itemID
            end)
            item_id = ok and safe_number(value) or nil
            if item_id then tooltip.uaForeverItemID = item_id end
        end
        local key = comparison_item_key(tooltip, data)
        if key then
            local session_key = "comparison:" .. key
            if begin_tooltip(tooltip, session_key) then
                comparison_claim_regions[tooltip] = nil
                tooltip.uaForeverKind = "item"
                tooltip.uaForeverComparisonData = data
                if item_id then tooltip.uaForeverItemID = item_id end
            end
        end
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

    local function mark_managed_item(tooltip, data)
        if not tooltip then return end
        tooltip.uaForeverKind = "item"
        tooltip.uaForeverComparisonManagedPending = true
        tooltip.uaForeverComparisonData = data
        if type(data) == "table" and not is_secret(data) then
            local ok, value = pcall(function () return data.id or data.itemID end)
            local item_id = ok and safe_number(value) or nil
            if item_id then tooltip.uaForeverItemID = item_id end
        end
    end

    prepare_comparison_manager = function ()
        comparison_manager_hooked = _G.TooltipComparisonManager ~= nil
        return comparison_manager_hooked
    end

    return {
        bootstrap = bootstrap_comparison_translation,
        comparison_manager_owns = comparison_manager_owns,
        each = each_shopping_tooltip,
        fallback_once = translate_comparison_fallback_once,
        install_text_guards = install_comparison_text_guards,
        is_shopping = is_shopping_tooltip,
        mark_managed = mark_managed_item,
        prepare_manager = prepare_comparison_manager,
        reapply = reapply_comparison_claims,
        translate = translate_shopping_tooltip,
    }
end
