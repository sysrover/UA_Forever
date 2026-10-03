local _, addon_table = ...
local adapter = addon_table.use("panel_ui_adapter")
local strings = addon_table.use("strings")
local runtime = addon_table.use("translation_runtime")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local entries = addon_table.use("entries")
local item_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")

-- Shared guarded label operations; each panel owns its fields and lifecycle.
adapter.bind = function (id)
    local api = {}
    api.hooks = addon_table.use("translation_hooks").bind(id)
    api.text = function (region)
        if not region or type(region.GetText) ~= "function" then return nil end
        local ok, value = pcall(region.GetText, region)
        return ok and runtime.safe_string_or_nil(value) or nil
    end
    api.label = function (region)
        if not region or runtime.is_applying(region) then return end
        return strings.translate_region(region, nil, "ui.label", api.surface)
    end
    api.watch = function (region, callback)
        if not region then return end
        callback = callback or api.label
        local function written(self)
            if not runtime.is_applying(self) then callback(self) end
        end
        api.hooks.region(region, "SetText", written)
        api.hooks.region(region, "SetFormattedText", written)
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
            priority = runtime.PRIORITY.DOMAIN, phase = "direct", reapply_cached = true })
    end
    api.formatted = function (region, template, ...)
        template = runtime.safe_string_or_nil(template)
        local translated = template and resolver.find_ui(template)
        if not translated then return end
        local ok, text = pcall(string.format, translated, ...)
        if ok then return api.apply(region, text) end
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
            local translated = source and resolver.find_ui(source, region)
            if translated then
                local color, _, reset = source:match("^(|c%x%x%x%x%x%x%x%x)(.-)(|r)$")
                if color and not translated:find("|c", 1, true) then translated = color .. translated .. reset end
                api.apply(region, translated, "ui.tooltip", nil, nil, tooltip)
            end
        end
    end
    api.prepare = function (roots, addon, globals, methods, refresh)
        api.surface = registry.register_surface({ id = id, roots = roots,
            domains = { "ui", "npc", "item" }, name_category = "none",
            slots = { "ui.label", "ui.tooltip", "npc.name", "item.name" },
            static = refresh, is_open = function ()
                for _, name in ipairs(roots) do
                    local frame = _G[name]
                    if frame then
                        local ok, shown = pcall(frame.IsShown, frame)
                        if ok and not runtime.is_secret_value(shown) and shown == true then return true end
                    end
                end
                return false
            end })
        for _, target in ipairs(globals) do
            registry.declare_hook({ id = id .. ":" .. target, surface = id,
                kind = "global", target = target, callback = refresh,
                blizzardAddon = addon, verifiedBuild = "1.60.1.70205" })
        end
        for _, method in ipairs(methods) do
            registry.declare_hook({ id = id .. ":" .. method[1] .. "." .. method[2],
                surface = id, kind = "frame", target = method[1], method = method[2],
                callback = refresh, blizzardAddon = addon, verifiedBuild = "1.60.1.70205" })
        end
        for _, name in ipairs(roots) do api.hooks.region_script(_G[name], "OnShow", refresh) end
        refresh()
    end
    return api
end
