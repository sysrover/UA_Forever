local _, addon_table = ...

local adapter = addon_table.use("talent_frame_adapter")
local hooks = addon_table.use("translation_hooks").bind("talent-frame")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local options = addon_table.use("options")
local catalog = assert(addon_table.talent_ui,
    "UA Forever talent UI catalog is not loaded")

local OWNER = "talent-frame"
local label_states = setmetatable({}, { __mode = "k" })
local frame_states = setmetatable({}, { __mode = "k" })

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function visible(region)
    if not region or is_secret(region) then return false end
    local ok, value = pcall(function () return region:IsVisible() end)
    return ok and not is_secret(value) and value == true
end

local function text_from(region)
    if not region or type(region.GetText) ~= "function" then return nil end
    local ok, value = pcall(region.GetText, region)
    return ok and type(value) == "string" and not is_secret(value)
        and value or nil
end

local function apply(region, source, translated, slot)
    if not region or not source or type(translated) ~= "string"
        or translated == "" or translated == source then return false end
    return runtime.apply(region, {
        owner = OWNER,
        slot = slot,
        source = source,
        translated = translated,
        priority = runtime.PRIORITY.DOMAIN,
        reapply_cached = true,
    })
end

local function flush_region(region)
    local state = region and label_states[region]
    if not state or not state.pending or state.applying
        or runtime.is_applying(region) or not visible(region) then return end
    state.applying = true
    local ok, result = pcall(state.translate, region)
    state.applying = nil
    -- A rejected write (combat, protected text, disabled section) must remain
    -- eligible on the next show/refresh. Never cache write permissions.
    if ok and result then state.pending = nil end
    if not ok then error(result, 0) end
end

local function translate_label(region)
    return strings.translate_region(region, nil, "ui.label", nil, nil, nil, "spell_ui")
end

local function register_region(region, translate)
    if not region or is_secret(region) or label_states[region] then return end
    local state = { pending = true, translate = translate or translate_label }
    label_states[region] = state
    local function written(self)
        if state.applying or runtime.is_applying(self) then return end
        state.pending = true
        flush_region(self)
    end
    hooks.region(region, "SetText", written)
    hooks.region(region, "SetFormattedText", written)
    -- Native font resets need the same repair even if the text did not change.
    hooks.region(region, "SetFont", written)
    hooks.region(region, "SetFontObject", written)
    hooks.region(region, "Show", flush_region)
end

local function button_region(button)
    if not button or is_secret(button) then return nil end
    local ok, region = pcall(function () return button:GetFontString() end)
    return ok and not is_secret(region) and region or nil
end

local function translate_named_tab(button, descriptor, slot)
    local region = button and button.Text
    local source = text_from(region)
    local english = descriptor and descriptor.source
    local ukrainian = descriptor and descriptor.translated
    if not source or not english or not ukrainian then return false end
    local first, last = source:find(english, 1, true)
    if not first then
        return source:find(ukrainian, 1, true) ~= nil and runtime.ensure_font(region)
    end
    return apply(region, source, source:sub(1, first - 1) .. ukrainian
        .. source:sub(last + 1), slot)
end

local function register_named_tab(frame, tab_id, descriptor, slot)
    if not frame or not tab_id or type(frame.GetTabButton) ~= "function" then
        return
    end
    local ok, button = pcall(frame.GetTabButton, frame, tab_id)
    if not ok or not button then return end
    local region = button.Text
    register_region(region, function ()
        return translate_named_tab(button, descriptor, slot)
    end)
    return region
end

local function update_tabs(frame)
    if not frame then return end
    -- UpdateTabText writes Text:SetText itself. Observe that write once rather
    -- than translating again at both UpdateTabText and UpdateTabs boundaries.
    local primary = register_named_tab(frame, frame.primarySpecTabID,
        catalog.spec_tabs.primary, "talent.spec-tab.primary")
    local secondary = register_named_tab(frame, frame.secondarySpecTabID,
        catalog.spec_tabs.secondary, "talent.spec-tab.secondary")
    if not visible(frame) then return end
    flush_region(primary)
    flush_region(secondary)
end

local function translate_tree_header(header, display_info)
    if not header then return end
    display_info = display_info or header.displayInfo
    local source = display_info and display_info.displayName
        or text_from(header.Name)
    if type(source) ~= "string" or is_secret(source) then return end
    local translated = catalog.spec_names[source]
    if translated then
        apply(header.Name, text_from(header.Name) or source, translated,
            "talent.tree-header.name")
    end
end

local function translate_tree_headers(frame)
    if not visible(frame) then return end
    for _, header in ipairs(frame and frame.treeHeaders or {}) do
        translate_tree_header(header)
    end
    local state = frame_states[frame]
    if state then state.headers_seeded = true end
end

local function visit_main_labels(root, visit)
    root = root or _G.PlayerSpellsFrame
    if not root then return end
    if type(root.GetTitleText) == "function" then
        local ok, title = pcall(root.GetTitleText, root)
        if ok then visit(title) end
    end
    if root.talentTabID and type(root.GetTabButton) == "function" then
        local ok, tab = pcall(root.GetTabButton, root, root.talentTabID)
        if ok then visit(button_region(tab)) end
    end
end

local function visit_active_labels(active, visit)
    if not active then return end
    visit(active.ActiveLabel)
    visit(button_region(active.ActivateButton))
end

local function visit_frame_labels(frame, visit)
    visit(button_region(frame.ApplyButton))
    visit(button_region(frame.InspectCopyButton))
    visit(frame.SearchBox and frame.SearchBox.Instructions)
    visit(frame.SearchOptionsDropdown and frame.SearchOptionsDropdown.Text)
    visit(frame.ClassCurrencyDisplay and frame.ClassCurrencyDisplay.UnspentLabel)
    visit_active_labels(frame.ActiveSpec, visit)
end

local function translate_main_frame(root)
    root = root or _G.PlayerSpellsFrame
    if not root then return end
    visit_main_labels(root, register_region)
    if visible(root) then visit_main_labels(root, flush_region) end
end

local function translate_active_spec(active)
    visit_active_labels(active, register_region)
    if visible(active) then visit_active_labels(active, flush_region) end
end

local function translate_frame(frame)
    if not frame then return end
    visit_frame_labels(frame, register_region)
    update_tabs(frame)
    if not visible(frame) then return end
    visit_frame_labels(frame, flush_region)
    -- Native refreshOnShow rebuilds the headers before our OnShow script.
    -- Only seed headers that predate registration; subsequent native rebuilds
    -- have exactly one finalizer, RefreshTreeHeaders.
    local state = frame_states[frame]
    if state and not state.headers_seeded then translate_tree_headers(frame) end
end

local function install_frame(frame)
    if not frame or is_secret(frame) then return end
    if not frame_states[frame] then frame_states[frame] = {} end
    hooks.region_script(frame, "OnShow", translate_frame, "talent-frame")
    hooks.region(frame, "RefreshTreeHeaders", translate_tree_headers)
    hooks.region(frame, "UpdateTabs", update_tabs)
    -- InitializeTabSystem ends in UpdateTabs; a second hook would repeat it.
    local active = frame.ActiveSpec
    hooks.region(active, "Refresh", translate_active_spec)
    translate_frame(frame)
end

local function install_main_frame(root)
    if not root or is_secret(root) then return end
    hooks.region_script(root, "OnShow", translate_main_frame,
        "talent-frame-root")
    hooks.region(root, "UpdateFrameTitle", translate_main_frame)
    -- Talent buttons can appear late, including after TabSystem reinitializes.
    hooks.region(root, "UpdateTabs", function (self)
        visit_main_labels(self, register_region)
    end)
    translate_main_frame(root)
end

adapter.prepare = function ()
    -- Concrete owners have copied mixin methods by ADDON_LOADED. Hook them
    -- directly; OnLoad covers owners created after an earlier prepare call.
    hooks.mixin("ClassTalentsFrameMixin", "OnLoad", install_frame)
    hooks.mixin("PlayerSpellsFrameMixin", "OnLoad", install_main_frame)
    local root = _G.PlayerSpellsFrame
    install_main_frame(root)
    install_frame(root and root.TalentsFrame)
end

if options.on_activity_change then
    options.on_activity_change(OWNER, function ()
        for _, state in pairs(label_states) do state.pending = true end
        adapter.prepare()
    end)
end
