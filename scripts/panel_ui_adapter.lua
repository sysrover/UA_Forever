local _, addon_table = ...
local adapter = addon_table.use("panel_ui_adapter")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local entries = addon_table.use("entries")
local item_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")
local layout = addon_table.use("translation_layout")
local walker = addon_table.use("translation_walker")
local profiler = addon_table.use("performance_profile")
local options = addon_table.use("options")

-- Shared guarded label operations; each panel owns its fields and lifecycle.
adapter.bind = function (id)
    local api = {}
    api.section = options.surface_section and options.surface_section(id) or nil
    api.hooks = addon_table.use("translation_hooks").bind(id)
    api.visible = function (frame)
        if not frame then return false end
        local ok, shown = pcall(function () return frame:IsVisible() end)
        return ok and not runtime.is_secret_value(shown) and shown == true
    end
    api.text = function (region)
        if not region or type(region.GetText) ~= "function" then return nil end
        local ok, value = pcall(region.GetText, region)
        return ok and runtime.safe_string_or_nil(value) or nil
    end
    api.label = function (region, template, ...)
        if not region or runtime.is_applying(region) then return end
        if template and strings.translate_formatted_region
            and strings.translate_formatted_region(region, template, api.surface, ...) then return true end
        return strings.translate_region(region, nil, "ui.label", api.surface, nil, nil, api.section)
    end
    -- Custom callbacks opt into template arguments explicitly; their second
    -- argument may already be an owner-specific control flag.
    api.watch = function (region, callback, formatted_callback)
        if not region then return end
        callback = callback or api.label
        formatted_callback = formatted_callback or (callback == api.label and api.label)
        local function written(self)
            if not runtime.is_applying(self) then callback(self) end
        end
        api.hooks.region(region, "SetText", written)
        api.hooks.region(region, "SetFormattedText", function (self, template, ...)
            if runtime.is_applying(self) then return end
            if formatted_callback then return formatted_callback(self, template, ...) end
            return callback(self)
        end)
        written(region)
    end
    api.button = function (button)
        if not button or type(button.GetFontString) ~= "function" then return end
        local ok, region = pcall(button.GetFontString, button)
        if ok then api.watch(region) end
    end
    api.regions = function (owner)
        if not owner or type(owner.GetRegions) ~= "function" then return end
        local ok, regions = pcall(function () return { owner:GetRegions() } end)
        if not ok then return end
        for _, region in ipairs(regions) do
            local kind_ok, kind = pcall(region.GetObjectType, region)
            if kind_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
                api.watch(region)
            end
        end
    end
    local bound_roots = setmetatable({}, { __mode = "k" })
    local root_labels = setmetatable({}, { __mode = "k" })
    api.refresh_labels = function (root)
        local state = root_labels[root]
        if not state or state.seeded or not api.visible(root) then return end
        for _, region in ipairs(state.regions) do state.label(region) end
        state.seeded = true
    end
    api.watch_frame = function (root, skip_region, translate, seen)
        if not root then return end
        local registering = not bound_roots[root]
        if not registering and not api.visible(root) then return end
        bound_roots[root] = true
        local function skip_frame(frame)
            local ok, forbidden = pcall(function () return frame:IsForbidden() end)
            return not ok or runtime.is_secret_value(forbidden) or forbidden == true
                or not registering and not api.visible(frame)
        end
        local function label(region, template, ...)
            if not api.visible(region) then return end
            if skip_region then
                local ok, skipped = pcall(skip_region, region)
                if not ok or runtime.is_secret_value(skipped) or skipped then return end
            end
            if translate then return translate(region) end
            return api.label(region, template, ...)
        end
        local labels = { regions = {}, label = label }
        walker.walk({ id = id .. ":labels", surface = id, owner = id,
            reason = "REGISTERED_STATIC_SCAN", max_nodes = 1000 }, root, function (region)
                local ok, kind = pcall(function () return region:GetObjectType() end)
                if ok and not runtime.is_secret_value(region)
                    and not runtime.is_secret_value(kind) and kind == "FontString" then
                    labels.regions[#labels.regions + 1] = region
                    api.watch(region, label, label)
                end
            end, skip_frame, { frames = 0 }, seen)
        labels.seeded = api.visible(root)
        root_labels[root] = labels
    end
    local scroll_boxes = setmetatable({}, { __mode = "k" })
    api.watch_scroll = function (box, callback)
        if not box then return end
        local event = _G.ScrollBoxListMixin and ScrollBoxListMixin.Event
            and ScrollBoxListMixin.Event.OnInitializedFrame
        if event and not scroll_boxes[box] and type(box.RegisterCallback) == "function" then
            local initialized = function (_, row) callback(row) end
            if profiler.wrap then initialized = profiler.wrap(id .. ".row", initialized) end
            if pcall(box.RegisterCallback, box, event, initialized, scroll_boxes) then
                scroll_boxes[box] = true
            end
        end
        if api.visible(box) and type(box.ForEachFrame) == "function" then
            local ok, has_view = pcall(function () return not box.HasView or box:HasView() end)
            if ok and not runtime.is_secret_value(has_view) and has_view then
                pcall(box.ForEachFrame, box, callback)
            end
        end
    end
    api.apply = function (region, translated, slot, option, category, tooltip)
        translated = runtime.safe_string_or_nil(translated)
        local source = api.text(region)
        if not source or not translated then return end
        local previous = runtime.get(region)
        if previous and source == previous.translated then source = previous.source end
        return runtime.apply(region, { owner = id, slot = slot or "ui.label",
            source = source, translated = translated, option = option or "translate_string",
            options = tooltip and { "translate_other_tooltips" } or nil,
            category = category, surface = tooltip or api.surface, tooltip = tooltip,
            section = not category and not tooltip and api.section or nil,
            priority = runtime.PRIORITY.DOMAIN, phase = "direct", reapply_cached = true,
            after_apply = tooltip and not api.defer_tooltip_layout
                and layout.tooltip_after_text(tooltip, region, source) or nil })
    end
    api.formatted = function (region, template, ...)
        template = runtime.safe_string_or_nil(template)
        local translated = template and resolver.find_ui(template, region)
        if not translated then return end
        local renderer = addon_table.use("spell_template_renderer")
        local text = renderer.format_arguments(translated, ...)
        if text then return api.apply(region, text) end
    end
    api.npc = function (region, unit)
        local ok, npc_id = pcall(utils.npc_id_from_unit_id, unit)
        if not ok or runtime.is_secret_value(npc_id) then return end
        local entry = npc_id and entries.get_entry("npc", npc_id)
        if entry then api.apply(region, utils.cap(entry[1]), "npc.name", "translate_npc", "npc") end
    end
    api.item = function (region, link, tooltip)
        local source = api.text(region)
        local previous = region and runtime.get(region)
        if previous and source == previous.translated then source = previous.source end
        runtime.invalidate(region)
        link = runtime.safe_string_or_nil(link)
        local item_id = link and utils.item_id_from_link(link)
        if not source or source == "" or not item_id then return end
        local entry = entries.get_entry("item", item_id)
        local translated = runtime.safe_string_or_nil(entry and entry[1] or item_db.get_name(item_id))
        if not translated then return end
        translated = utils.cap(translated)
        local color, _, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
        if color then translated = color .. translated .. reset end
        local generation = tooltip and runtime.generation(tooltip)
            or runtime.begin_generation(region, item_id)
        runtime.apply(region, { owner = id, slot = "item:" .. item_id .. ".name",
            source = source, translated = translated, option = "translate_item",
            options = tooltip and { "translate_item_tooltip" } or nil,
            category = "item", priority = runtime.PRIORITY.DOMAIN, surface = tooltip or region,
            tooltip = tooltip, generation = generation, instance = item_id,
            phase = tooltip and "direct" or "dynamic",
            reapply_cached = true })
    end
    api.tooltip = function (owner)
        local tooltip = _G.GameTooltip
        if not tooltip then return end
        local ok, owned = pcall(tooltip.IsOwned, tooltip, owner)
        if not ok or runtime.is_secret_value(owned) or owned ~= true then return end
        local count_ok, count = pcall(tooltip.NumLines, tooltip)
        if not count_ok or runtime.is_secret_value(count) or type(count) ~= "number" then return end
        for index = 1, math.min(count, 40) do
            local region = _G["GameTooltipTextLeft" .. index]
            local source = api.text(region)
            local claim = region and runtime.get(region)
            local retained = claim and claim.surface == tooltip and claim.owner == id
                and (source == claim.source or source == claim.translated)
            local translated = retained and claim.translated or source and resolver.find_ui(source, region)
            if translated then
                local color, _, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
                if color and not translated:find("|c", 1, true) then translated = color .. translated .. reset end
                api.apply(region, translated, "ui.tooltip", nil, nil, tooltip)
            end
        end
    end
    api.prepare = function (roots, addon, globals, methods, refresh, global_callbacks, selected_roots)
        api.surface = registry.register_surface({ id = id, roots = roots,
            domains = { "ui", "npc", "item" }, name_category = "none",
            slots = { "ui.label", "ui.tooltip", "npc.name", "item.name" },
            preserve_claims_on_refresh = true,
            static = refresh, is_open = function ()
                for _, name in ipairs(roots) do
                    local frame = _G[name]
                    if frame then
                        local ok, shown = pcall(function ()
                            local method = frame.IsVisible or frame.IsShown
                            return type(method) == "function" and method(frame)
                        end)
                        if ok and not runtime.is_secret_value(shown) and shown == true then return true end
                    end
                end
                return false
            end })
        for _, target in ipairs(globals) do
            registry.declare_hook({ id = id .. ":" .. target, surface = id,
                kind = "global", target = target,
                callback = global_callbacks and global_callbacks[target] or refresh,
                blizzardAddon = addon, verifiedBuild = api.verified_build or "1.60.1.70205" })
        end
        for _, method in ipairs(methods) do
            registry.declare_hook({ id = id .. ":" .. method[1] .. "." .. method[2],
                surface = id, kind = "frame", target = method[1], method = method[2],
                callback = refresh, blizzardAddon = addon, verifiedBuild = api.verified_build or "1.60.1.70205" })
        end
        for _, name in ipairs(roots) do api.hooks.region_script(_G[name], "OnShow", refresh) end
        refresh(nil, selected_roots)
    end
    return api
end
