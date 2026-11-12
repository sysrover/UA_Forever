local _, addon_table = ...
local collections = addon_table.use("collections_ui")
local ui = addon_table.use("panel_ui_adapter").bind("collections-ui")
ui.verified_build = "1.60.1.70840"
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local entries = addon_table.use("entries")
local items = addon_table.use("item_client_db")
local spells = addon_table.use("spell_client_db")
local utils = addon_table.use("utils")
local tooltips = addon_table.use("tooltips")
local registered_labels = setmetatable({}, { __mode = "k" })

-- 70840 Camelot loads Classic/PetCollection explicitly. Its tab implementation
-- does not call PanelTemplates_SetTab, and scroll rows are reused independently.
local function call(api, method, ...)
    if not api or type(api[method]) ~= "function" then return end
    local ok, a, b, c, d, e, f, g, h, i, j, k = pcall(api[method], ...)
    if ok then return a, b, c, d, e, f, g, h, i, j, k end
end

local function number(value)
    if not runtime.is_secret_value(value) and type(value) == "number" then return value end
end

local function visible(frame)
    if not frame then return false end
    local ok, shown = pcall(function ()
        local method = frame.IsVisible or frame.IsShown
        return type(method) == "function" and method(frame)
    end)
    return ok and not runtime.is_secret_value(shown) and shown == true
end

local function native_text(region)
    local text = ui.text(region)
    local claim = region and runtime.get(region)
    if claim and text == claim.translated then return claim.source end
    return text
end

local function pet_name(region, name, creature_id)
    name = runtime.safe_string_or_nil(name)
    if not region or not name or native_text(region) ~= name then return end
    runtime.invalidate(region)
    local entry = creature_id and entries.get_entry("npc", creature_id)
    local translated = entry and entry.en == name and entry[1]
        or entries.npc_names and entries.npc_names[name]
        or items.get_name_by_english(name)
    if translated then
        ui.apply(region, utils.cap(translated), "npc.name", "translate_npc", "npc")
    end
end

local function pet_row(row, data)
    local index = data and number(data.index) or row and number(row.index)
    if not row or not index then return end
    local _, species, _, custom, _, _, _, name = call(_G.C_PetJournal, "GetPetInfoByIndex", index)
    -- A renamed pet belongs to the player, even when its name matches a catalog.
    if runtime.is_secret_value(custom) or custom then
        runtime.invalidate(row.name)
        return
    end
    species = number(species)
    local _, _, _, creature = call(_G.C_PetJournal, "GetPetInfoBySpeciesID", species)
    pet_name(row.name, name, number(creature))
    ui.label(row.new)
end

local function pet_card(card)
    card = card or _G.PetJournalPetCard
    if not card or not card.PetInfo then return end
    local species, custom, name, creature
    local pet_id = runtime.safe_string_or_nil(card.petID)
    if pet_id then
        local _, level, xp, max_xp, display, favorite, icon, pet_type
        species, custom, level, xp, max_xp, display, favorite, name, icon, pet_type, creature =
            call(_G.C_PetJournal, "GetPetInfoByPetID", pet_id)
    else
        species = number(card.speciesID)
        if not species then ui.label(card.PetInfo.name); return end
        local icon, pet_type
        name, icon, pet_type, creature = call(_G.C_PetJournal, "GetPetInfoBySpeciesID", species)
    end
    if runtime.is_secret_value(custom) then return end
    if custom then runtime.invalidate(card.PetInfo.name) end
    pet_name(custom and card.PetInfo.subName or card.PetInfo.name, name, number(creature))
end

local function mount_name(region, mount_id)
    mount_id = number(mount_id)
    if not mount_id then return end
    local name, spell_id = call(_G.C_MountJournal, "GetMountInfoByID", mount_id)
    name = runtime.safe_string_or_nil(name)
    spell_id = number(spell_id)
    if not name or not spell_id or native_text(region) ~= name then return end
    runtime.invalidate(region)
    local translated = spells.get_english_name(spell_id) == name and spells.get_name(spell_id)
        or spells.get_name_by_english(name)
    if translated then ui.apply(region, utils.cap(translated), "spell.name", "translate_spell", "spell") end
end

local function mount_row(row)
    if row then mount_name(row.name, row.mountID); ui.label(row.new) end
end

local function mount_card()
    local journal = _G.MountJournal
    local display = journal and journal.MountDisplay
    if display and display.InfoButton then
        mount_name(display.InfoButton.Name, journal.selectedMountID)
    end
end

local function item_row(row)
    local id = row and number(row.itemID)
    if id then ui.item(row.name, "|Hitem:" .. id .. ":|h[]|h") end
    if row then ui.label(row.new) end
end

local function each_row(box, callback)
    if box and type(box.ForEachFrame) == "function" then box:ForEachFrame(callback) end
end

local function count_label(counter)
    if not counter or not counter.Label or not counter.Count then return end
    local function fit()
        ui.label(counter.Label)
        if runtime.combat_locked() or not runtime.can_write_text(counter) then return end
        local label_ok, label_width = pcall(counter.Label.GetUnboundedStringWidth, counter.Label)
        local count_ok, count_width = pcall(counter.Count.GetStringWidth, counter.Count)
        label_width = label_ok and number(label_width)
        count_width = count_ok and number(count_width)
        if label_width and count_width then
            pcall(counter.SetWidth, counter, math.max(130, label_width + count_width + 26))
        end
    end
    -- The native 130px counter clips the approved full Ukrainian label.
    ui.watch(counter.Label, fit)
    ui.watch(counter.Count, fit)
end

local function labels(frame)
    if not frame then return end
    count_label(frame.PetCount)
    count_label(frame.MountCount)
    local search = frame.searchBox or frame.SearchBox
    -- Instructions are a FontString; never translate the EditBox's input.
    ui.watch(search and search.Instructions)
    ui.button(frame.SummonButton)
    ui.button(frame.MountButton)
    ui.button(frame.FilterButton)
    ui.button(frame.FilterDropdown)
end

local function skip_region(region)
    if not region or type(region.GetParent) ~= "function" then return true end
    local ok, parent = pcall(region.GetParent, region)
    if not ok then return true end
    -- Species/mount/item names have domain handlers; custom pet and
    -- wardrobe names must never pass through a generic UI lookup.
    if parent and (parent.name == region or parent.subName == region) then return true end
    if parent and type(parent.GetObjectType) == "function" then
        local kind_ok, kind = pcall(parent.GetObjectType, parent)
        return not kind_ok or runtime.is_secret_value(kind) or kind == "EditBox"
    end
    return false
end

local function refresh_pet_list()
    local frame = _G.PetJournal
    if not visible(frame) then return end
    count_label(frame.PetCount)
    each_row(frame.ScrollBox, pet_row)
end

local function refresh_pet_summon()
    local frame = _G.PetJournal
    if visible(frame) then ui.button(frame.SummonButton) end
end

local function refresh_mount_display()
    local frame = _G.MountJournal
    if not visible(frame) then return end
    mount_card()
    ui.button(frame.MountButton)
    local display = frame.MountDisplay
    local info = display and display.InfoButton
    ui.label(info and info.Source)
    ui.label(info and info.Lore)
    ui.label(display and display.NoMounts)
end

local function refresh_toy_rows()
    local frame = _G.ToyBox
    if not visible(frame) then return end
    local toys = frame.iconsFrame
    if not toys then return end
    for index = 1, 100 do
        local row = toys["spellButton" .. index]
        if not row then break end
        item_row(row)
    end
end

local function refresh()
    -- api.prepare publishes the surface before invoking this first refresh.
    if ui.surface then ui.surface.skip_region = skip_region end
    local journal = _G.CollectionsJournal
    if visible(journal) then
        ui.regions(journal)
        for _, tab in ipairs(journal.TabContainer and journal.TabContainer.Tabs or {}) do
            ui.button(tab)
        end
        if type(journal.GetTitleText) == "function" then ui.watch(journal:GetTitleText()) end
    end
    -- IsVisible includes hidden parents. IsShown alone treats the default
    -- child of a still-hidden CollectionsJournal as work for the cold load.
    for _, frame in ipairs({ _G.PetJournal or false, _G.MountJournal or false,
        _G.ToyBox or false, _G.HeirloomsJournal or false,
        _G.WardrobeCollectionFrame or false }) do
        if visible(frame) then
            labels(frame)
            if not registered_labels[frame] then
                ui.watch_frame(frame, skip_region)
                registered_labels[frame] = true
            end
            ui.refresh_labels(frame)
            if frame == _G.PetJournal then
                each_row(frame.ScrollBox, pet_row)
                pet_card()
            elseif frame == _G.MountJournal then
                each_row(frame.ScrollBox, mount_row)
                mount_card()
            elseif frame == _G.ToyBox then
                refresh_toy_rows()
            elseif frame == _G.HeirloomsJournal then
                for _, row in ipairs(frame.heirloomEntryFrames or {}) do item_row(row) end
                each_row(frame.ScrollBox, item_row)
            else
                each_row(frame.ScrollBox, item_row)
            end
        end
    end
end

collections.prepare = function ()
    ui.prepare({ "CollectionsJournal", "PetJournal", "MountJournal", "ToyBox", "HeirloomsJournal", "WardrobeCollectionFrame" },
        "Blizzard_Collections", { "CollectionsJournal_UpdateSelectedTab",
            "PetJournal_UpdateSummonButtonState", "PetJournal_UpdatePetList",
            "MountJournal_UpdateMountDisplay", "ToyBox_UpdateButtons" }, {}, refresh, {
            PetJournal_UpdateSummonButtonState = refresh_pet_summon,
            PetJournal_UpdatePetList = refresh_pet_list,
            MountJournal_UpdateMountDisplay = refresh_mount_display,
            ToyBox_UpdateButtons = refresh_toy_rows,
        })
    -- Register static writers even on hidden tabs; visibility only gates their
    -- display work. Pooled names continue to use the domain Init callbacks.
    for _, name in ipairs({ "PetJournal", "MountJournal", "ToyBox", "HeirloomsJournal", "WardrobeCollectionFrame" }) do
        local frame = _G[name]
        if frame and not registered_labels[frame] then
            ui.watch_frame(frame, skip_region)
            registered_labels[frame] = true
        end
    end
    local journal = _G.CollectionsJournal
    ui.hooks.region(journal, "SetTitle", function ()
        if journal and type(journal.GetTitleText) == "function" then ui.label(journal:GetTitleText()) end
    end)
    ui.hooks.region(_G.HeirloomsJournal, "UpdateButton", function (_, row) item_row(row) end)
    ui.hooks.global("PetJournal_InitPetButton", pet_row)
    ui.hooks.global("PetJournal_UpdatePetCard", pet_card)
    ui.hooks.global("MountJournal_InitMountButton", mount_row)
    ui.hooks.global("ToySpellButton_UpdateButton", item_row)
    ui.hooks.global("HeirloomsJournal_UpdateButton", item_row)
    -- Appearance tooltips are assembled with SetText/AddLine, not SetItem.
    -- Their title is an item name, so resolve its exact English item identity.
    ui.hooks.region(_G.CollectionWardrobeUtil, "SetAppearanceTooltip", function (tooltip)
        if tooltip ~= _G.GameTooltip then return end
        local title = _G.GameTooltipTextLeft1
        local source = native_text(title)
        local id = source and items.get_id_by_english_name(source)
        if id then ui.item(title, "|Hitem:" .. id .. ":|h[]|h", tooltip) end
        if type(tooltips.finalize) == "function" then tooltips.finalize(tooltip) end
    end)
end
