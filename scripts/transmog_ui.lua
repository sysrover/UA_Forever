local _, addon_table = ...
local transmog = addon_table.use("transmog_ui")
local ui = addon_table.use("panel_ui_adapter").bind("transmog-ui")
local runtime = addon_table.use("translation_runtime")

-- Field paths are from the 70938 Transmog XML/Lua. The active 70959 build
-- has no extracted Transmog source yet; all optional owners are guarded.
-- Never walk the model scene, appearance grid or player-named outfit rows.
local function skip_region(region)
    local ok, skip = pcall(function ()
        local parent = region:GetParent()
        if not parent then return false end
        if parent.Name == region or parent.name == region then return true end
        return parent:GetObjectType() == "EditBox" and parent.Instructions ~= region
    end)
    return not ok or runtime.is_secret_value(skip) or skip == true
end

local function label(region, template, ...)
    if ui.visible(region) and not skip_region(region) then
        return ui.label(region, template, ...)
    end
end

local function watch(region)
    ui.watch(region, label, label)
end

local function widget_written(frame)
    if not ui.visible(frame) then return end
    local ok, regions = pcall(function () return { frame:GetRegions() } end)
    if ok then
        for _, region in ipairs(regions) do
            local kind_ok, kind = pcall(function () return region:GetObjectType() end)
            if kind_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
                watch(region)
            end
        end
    end
    if type(frame.GetFontString) == "function" then
        local font_ok, region = pcall(frame.GetFontString, frame)
        if font_ok then watch(region) end
    end
end

local function widget(frame, seen)
    if not frame then return end
    -- watch_frame registers writers on hidden controls, but its label callback
    -- uses IsVisible before translation. Protected text uses runtime's guarded
    -- write path instead of excluding the entire Transmog tree from discovery.
    ui.watch_frame(frame, skip_region, nil, seen)
    local ok, kind = pcall(function () return frame:GetObjectType() end)
    if ok and not runtime.is_secret_value(kind) and kind ~= "EditBox" then
        ui.hooks.region(frame, "SetText", widget_written)
        ui.hooks.region(frame, "SetDefaultText", widget_written)
    end
end

local function title(frame)
    if not frame or type(frame.GetTitleText) ~= "function" then return end
    local ok, region = pcall(frame.GetTitleText, frame)
    if ok then watch(region) end
end

local function common_collection(frame, seen)
    if not frame then return end
    widget(frame.FilterButton, seen)
    widget(frame.SearchBox, seen)
    local content = frame.PagedContent
    widget(content and content.PagingControls, seen)
    local empty = content and content.ContentFrame
    watch(empty and empty.NoEntriesText)
end

local function items(frame, seen)
    if not frame then return end
    common_collection(frame, seen)
    watch(frame.ActiveSlotTitle)
    widget(frame.DisplayTypes, seen)
    widget(frame.WeaponDropdown, seen)
    widget(frame.WeaponSheatheDropdown, seen)
    widget(frame.SecondaryAppearanceToggle, seen)
end

local function situations(frame, seen)
    if frame then widget(frame, seen) end
end

local function popup(frame)
    if not frame then return end
    title(frame)
    local border = frame.BorderBox
    if not border then return end
    local seen = {}
    widget(border.OkayButton, seen)
    widget(border.CancelButton, seen)
    widget(border.SelectedIconArea, seen)
    watch(border.IconSelectorEditBox and border.IconSelectorEditBox.Instructions)
end

local function refresh_wardrobe(wardrobe)
    if not wardrobe then return end
    local seen = {}
    widget(wardrobe.TabHeaders, seen)
    local content = wardrobe.TabContent
    if not content then return end
    -- Register hidden tab writers once; refresh only the visible tab thereafter.
    -- The callbacks themselves also check ancestor visibility on every write.
    for _, name in ipairs({ "ItemsFrame", "SetsFrame", "CustomSetsFrame", "SituationsFrame" }) do
        local frame = content[name]
        if frame and ui.visible(frame) then
            if name == "ItemsFrame" then items(frame, seen)
            elseif name == "SituationsFrame" then situations(frame, seen)
            else
                common_collection(frame, seen)
                widget(frame.NewCustomSetButton, seen)
            end
        end
    end
end

local function refresh()
    local frame = _G.TransmogFrame
    if not frame or not ui.visible(frame) then return end
    title(frame)
    local seen = {}
    local collection = frame.OutfitCollection
    if collection then
        widget(collection.ShowEquippedGearSpellFrame, seen)
        widget(collection.PurchaseOutfitButton, seen)
        widget(collection.SaveOutfitButton, seen)
        watch(collection.UsableDiscountText)
    end
    widget(frame.CharacterPreview and frame.CharacterPreview.ToggleOptions, seen)
    refresh_wardrobe(frame.WardrobeCollection)
    if ui.visible(frame.OutfitPopup) then popup(frame.OutfitPopup) end
end

local function situation_row(frame)
    -- Situation rows are pooled and created by Init after the tab is opened.
    local seen = {}
    watch(frame and frame.Title)
    widget(frame and frame.Dropdown, seen)
end

transmog.prepare = function ()
    ui.prepare({ "TransmogFrame" }, "Blizzard_Transmog", {}, {}, refresh)
    local frame = _G.TransmogFrame
    if not frame then return end
    ui.hooks.region(frame, "SetTitle", title)
    local seen = {}
    title(frame)
    local collection = frame.OutfitCollection
    if collection then
        widget(collection.ShowEquippedGearSpellFrame, seen)
        widget(collection.PurchaseOutfitButton, seen)
        widget(collection.SaveOutfitButton, seen)
        watch(collection.UsableDiscountText)
    end
    widget(frame.CharacterPreview and frame.CharacterPreview.ToggleOptions, seen)
    local wardrobe = frame.WardrobeCollection
    if wardrobe then
        widget(wardrobe.TabHeaders, seen)
        local content = wardrobe.TabContent
        if content then
            items(content.ItemsFrame, seen)
            common_collection(content.SetsFrame, seen)
            common_collection(content.CustomSetsFrame, seen)
            widget(content.CustomSetsFrame and content.CustomSetsFrame.NewCustomSetButton, seen)
            situations(content.SituationsFrame, seen)
            for _, name in ipairs({ "ItemsFrame", "SetsFrame", "CustomSetsFrame", "SituationsFrame" }) do
                ui.hooks.region_script(content[name], "OnShow", function () refresh_wardrobe(wardrobe) end)
            end
        end
    end
    popup(frame.OutfitPopup)
    ui.hooks.region_script(frame.OutfitPopup, "OnShow", popup)
    ui.hooks.mixin("TransmogSituationMixin", "Init", situation_row)
end
