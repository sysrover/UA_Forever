local _, addon_table = ...

local adapter = addon_table.use("talent_frame_adapter")
local hooks = addon_table.use("translation_hooks").bind("talent-frame")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local catalog = assert(addon_table.talent_ui,
    "UA Forever talent UI catalog is not loaded")

local OWNER = "talent-frame"

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
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

local function hook_region(region)
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if not runtime.is_applying(self) then strings.translate_region(self) end
    end)
    strings.translate_region(region)
end

local function hook_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then hook_region(region) end
end

local function translate_named_tab(button, descriptor, slot)
    local region = button and button.Text
    local source = text_from(region)
    local english = descriptor and descriptor.source
    local ukrainian = descriptor and descriptor.translated
    if not source or not english or not ukrainian then return end
    local first, last = source:find(english, 1, true)
    if not first then return end
    apply(region, source, source:sub(1, first - 1) .. ukrainian
        .. source:sub(last + 1), slot)
end

local function hook_named_tab(frame, tab_id, descriptor, slot)
    if not frame or not tab_id or type(frame.GetTabButton) ~= "function" then
        return
    end
    local ok, button = pcall(frame.GetTabButton, frame, tab_id)
    if not ok or not button then return end
    hooks.region(button, "UpdateTabText", function (self)
        translate_named_tab(self, descriptor, slot)
    end)
    local region = button.Text
    hooks.region(region, "SetText", function ()
        if not runtime.is_applying(region) then
            translate_named_tab(button, descriptor, slot)
        end
    end)
    translate_named_tab(button, descriptor, slot)
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
    for _, header in ipairs(frame and frame.treeHeaders or {}) do
        translate_tree_header(header)
    end
end

local function translate_main_frame(root)
    root = root or _G.PlayerSpellsFrame
    if not root then return end
    if type(root.GetTitleText) == "function" then
        local ok, title = pcall(root.GetTitleText, root)
        if ok then hook_region(title) end
    end
    if root.talentTabID and type(root.GetTabButton) == "function" then
        local ok, tab = pcall(root.GetTabButton, root, root.talentTabID)
        if ok then hook_button(tab) end
    end
end

local function translate_frame(frame)
    frame = frame or (_G.PlayerSpellsFrame
        and _G.PlayerSpellsFrame.TalentsFrame)
    if not frame then return end

    hook_named_tab(frame, frame.primarySpecTabID,
        catalog.spec_tabs.primary, "talent.spec-tab.primary")
    hook_named_tab(frame, frame.secondarySpecTabID,
        catalog.spec_tabs.secondary, "talent.spec-tab.secondary")

    hook_button(frame.ApplyButton)
    hook_button(frame.InspectCopyButton)
    hook_region(frame.SearchBox and frame.SearchBox.Instructions)
    hook_region(frame.SearchOptionsDropdown and frame.SearchOptionsDropdown.Text)
    hook_region(frame.ClassCurrencyDisplay and frame.ClassCurrencyDisplay.UnspentLabel)

    local active = frame.ActiveSpec
    hook_region(active and active.ActiveLabel)
    hook_button(active and active.ActivateButton)

    translate_tree_headers(frame)
    local parent
    if type(frame.GetParent) == "function" then
        local ok, value = pcall(frame.GetParent, frame)
        if ok then parent = value end
    end
    translate_main_frame(parent)
end

local function hook_instances()
    local root = _G.PlayerSpellsFrame
    local frame = root and root.TalentsFrame
    hooks.region_script(root, "OnShow", translate_main_frame,
        "talent-frame-root")
    hooks.region_script(frame, "OnShow", translate_frame,
        "talent-frame")
    hooks.region(frame, "RefreshTreeHeaders", translate_frame)
    hooks.region(frame, "UpdateTabs", translate_frame)
    hooks.region(frame, "InitializeTabSystem", translate_frame)
    hooks.region(frame and frame.ActiveSpec, "Refresh", function ()
        translate_frame(frame)
    end)
end

adapter.prepare = function ()
    hooks.mixin("ClassTalentsFrameMixin", "OnShow", translate_frame)
    hooks.mixin("ClassTalentsFrameMixin", "RefreshTreeHeaders", translate_frame)
    hooks.mixin("ClassTalentsFrameMixin", "UpdateTabs", translate_frame)
    hooks.mixin("ClassTalentsFrameMixin", "InitializeTabSystem", translate_frame)
    hooks.mixin("ClassTalentTreeHeaderMixin", "Setup", translate_tree_header)
    hooks.mixin("ClassTalentActiveSpecMixin", "Refresh", function (active)
        local frame
        if active and type(active.GetParent) == "function" then
            local ok, value = pcall(active.GetParent, active)
            if ok then frame = value end
        end
        translate_frame(frame)
    end)
    hooks.mixin("PlayerSpellsFrameMixin", "UpdateFrameTitle",
        translate_main_frame)
    hooks.mixin("PlayerSpellsFrameMixin", "UpdateTabs", translate_main_frame)
    hook_instances()
    translate_frame()
end
