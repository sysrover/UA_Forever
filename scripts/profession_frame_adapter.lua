local _, addon_table = ...

local adapter = addon_table.use("profession_frame_adapter")
local entries = addon_table.use("entries")
local hooks = addon_table.use("translation_hooks").bind("profession-frame")
local options = addon_table.use("options")
local runtime = addon_table.use("translation_runtime")
local spell_db = addon_table.use("spell_client_db")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")

local OWNER = "profession-frame"

local function is_secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(_G.issecretvalue, value)
    return not ok or secret == true
end

local function hook_text_region(region)
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if not runtime.is_applying(self) then strings.translate_region(self) end
    end)
    strings.translate_region(region)
end

local function hook_button(button, fit)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, font_string = pcall(button.GetFontString, button)
    if not ok or not font_string then return end
    local function translate(self)
        if runtime.is_applying(self) then return end
        strings.translate_region(self)
        if fit then strings.fit_button_to_text(button, self) end
    end
    hooks.region(font_string, "SetText", translate)
    translate(font_string)
end

local function text_from(region)
    if not region or type(region.GetText) ~= "function" then return nil end
    local ok, value = pcall(region.GetText, region)
    return ok and type(value) == "string" and not is_secret(value)
        and value or nil
end

local function apply(region, translated, slot, option, category)
    local source = text_from(region)
    if not source or type(translated) ~= "string" or translated == ""
        or translated == source then return false end
    return runtime.apply(region, {
        owner = OWNER, slot = slot, source = source,
        translated = translated, option = option, category = category,
        priority = runtime.PRIORITY.DOMAIN, reapply_cached = true,
    })
end

local function profession_name(name, region)
    if type(name) ~= "string" or is_secret(name) then return nil end
    return entries.lookup_name("spell", name)
        or strings.find_ui_translation(name, region)
        or (name:find("[\208\209]") and name)
end

local function translate_title(frame)
    if not frame or type(frame.GetTitleText) ~= "function" then return end
    local ok, region = pcall(frame.GetTitleText, frame)
    if not ok or not region then return end
    local source = text_from(region)
    if not source then return end
    local name, suffix = source:match("^(.-)( %b[])$")
    name = name or source
    suffix = suffix or ""
    local translated = profession_name(name, region)
    if translated then
        apply(region, utils.cap(translated) .. suffix,
            "profession.title.name", nil, "skill")
    end
end

local function hook_profession_name_region(region, slot)
    if not region then return end
    local function translate(self)
        if runtime.is_applying(self) then return end
        local source = text_from(self)
        local translated = profession_name(source, self)
        if translated then
            apply(self, utils.cap(translated), slot,
                nil, "skill")
        end
    end
    hooks.region(region, "SetText", translate)
    translate(region)
end

local function translate_rank(region, profession, profession_info)
    if not region then return end
    local source = text_from(region)
    local name, progress = source and source:match("^(.-)%s+(%d+/%d+)$")
    if profession_info then
        local ok, info_name, level, maximum = pcall(function ()
            return profession_info.professionName,
                profession_info.skillLevel, profession_info.maxSkillLevel
        end)
        if ok and type(info_name) == "string" and not is_secret(info_name)
            and type(level) == "number" and not is_secret(level)
            and type(maximum) == "number" and not is_secret(maximum) then
            name = info_name
            progress = source and source:match("(%d+.-/%d+)%s*$")
                or math.floor(level) .. "/" .. math.floor(maximum)
        end
    end
    name = name or profession and profession.skillName
    local translated = profession_name(name, region)
    if translated and progress then
        apply(region, utils.cap(translated) .. " " .. progress,
            "profession.rank.name", nil, "skill")
    end
end

local function translate_rank_bar(bar, profession_info)
    local region = bar and bar.Rank and bar.Rank.Text
    if not region then return end
    hooks.region(region, "SetText", function (self)
        if not runtime.is_applying(self) then
            translate_rank(self, bar:GetParent())
        end
    end)
    translate_rank(region, bar:GetParent(), profession_info)
end

local function spellbook_item_spell_id(info)
    if type(info) ~= "table" then return nil end
    local spell_id = info.spellID
    if type(spell_id) == "number" and not is_secret(spell_id) then
        return spell_id
    end
    local action_id = info.actionID
    local pet_action = Enum and Enum.SpellBookItemType
        and info.itemType == Enum.SpellBookItemType.PetAction
    if not pet_action or type(action_id) ~= "number" or is_secret(action_id)
        or not C_PetInfo
        or type(C_PetInfo.GetSpellForPetAction) ~= "function" then return nil end
    local ok, resolved_id = pcall(C_PetInfo.GetSpellForPetAction, action_id)
    return ok and type(resolved_id) == "number" and not is_secret(resolved_id)
        and resolved_id or nil
end

local function translate_profession_spell_button(button)
    if not button or not C_SpellBook or not C_SpellBook.GetSpellBookItemInfo
        or not Enum or not Enum.SpellBookSpellBank then return end
    local parent = button.GetParent and button:GetParent()
    local id = button.GetID and button:GetID()
    local offset = parent and parent.spellOffset
    if type(id) ~= "number" or type(offset) ~= "number" then return end
    local ok, info = pcall(C_SpellBook.GetSpellBookItemInfo,
        id + offset, Enum.SpellBookSpellBank.Player)
    local spell_id = ok and spellbook_item_spell_id(info)
    local translated = spell_id and spell_db.get_name(spell_id)
    if translated then
        apply(button.spellString, utils.cap(translated),
            "profession.book-spell.name", nil, "skill")
    end
    hook_text_region(button.subSpellString)
end

local function translate_book(book)
    translate_title(book)
    local content = book and book.ProfessionsContentFrame
    if not content then return end
    for _, key in ipairs({
        "PrimaryProfession1", "PrimaryProfession2",
        "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3",
    }) do
        local profession = content[key]
        if profession then
            hook_profession_name_region(profession.ProfessionName,
                "profession.book.name")
            hook_profession_name_region(profession.specialization,
                "profession.book.specialization.name")
            hook_text_region(profession.missingHeader)
            hook_text_region(profession.missingText)
            hook_text_region(profession.Rank)
            local bar = profession.StatusBar
            local info
            if bar and profession.skillLine and C_TradeSkillUI
                and type(C_TradeSkillUI.GetProfessionInfoBySkillLineID)
                    == "function" then
                local ok, value = pcall(
                    C_TradeSkillUI.GetProfessionInfoBySkillLineID,
                    profession.skillLine)
                if ok then info = value end
            end
            translate_rank_bar(bar, info)
            hooks.region(bar, "Update", translate_rank_bar)
            for _, button in ipairs(profession.spellButtons or {}) do
                translate_profession_spell_button(button)
                hooks.region(button, "UpdateButton",
                    translate_profession_spell_button)
            end
        end
    end
end

local function translate_right_tab_tooltip(tab)
    local tooltip = _G.GameTooltip
    if not tab or not tooltip or type(tooltip.GetOwner) ~= "function" then return end
    local ok, owner = pcall(tooltip.GetOwner, tooltip)
    if not ok or owner ~= tab then return end
    local region = _G.GameTooltipTextLeft1
    local source = text_from(region)
    local translated = profession_name(source, region)
    if translated then
        apply(region, utils.cap(translated), "profession.tab-tooltip.name",
            nil, "skill")
        if type(tooltip.Show) == "function" then pcall(tooltip.Show, tooltip) end
    end
end

local function hook_right_tab(tab)
    hooks.region_script(tab, "OnEnter", translate_right_tab_tooltip,
        "profession-tab-tooltip")
end

local function sync_button_style(source, overlay)
    if not source or not overlay or type(source.GetTextColor) ~= "function"
        or type(overlay.GetTextColor) ~= "function"
        or type(overlay.SetTextColor) ~= "function" then return end
    local source_ok, r, g, b = pcall(source.GetTextColor, source)
    local overlay_ok, old_r, old_g, old_b, old_a = pcall(
        overlay.GetTextColor, overlay)
    if not source_ok or not overlay_ok or is_secret(r) or is_secret(g)
        or is_secret(b) then return end
    if r ~= old_r or g ~= old_g or b ~= old_b or old_a ~= 1 then
        pcall(overlay.SetTextColor, overlay, r, g, b, 1)
    end
    if type(overlay.SetAlpha) == "function" then
        pcall(overlay.SetAlpha, overlay, 1)
    end
end

local function hide_native_button_text(font_string)
    if font_string and type(font_string.SetAlpha) == "function" then
        pcall(font_string.SetAlpha, font_string, 0)
    end
end

local function clear_native_button_text(button, font_string)
    if not button or not font_string or button.uaForeverClearingNativeText
        or type(font_string.SetText) ~= "function" then return end
    button.uaForeverClearingNativeText = true
    pcall(font_string.SetText, font_string, "")
    button.uaForeverClearingNativeText = nil
end

local function button_overlay(button, font_string)
    local overlay = button and button.uaForeverTextOverlay
    if overlay then return overlay end
    if not button or not font_string
        or type(button.CreateFontString) ~= "function" then return nil end

    local ok, created = pcall(button.CreateFontString, button, nil, "OVERLAY")
    if not ok or not created then return nil end
    overlay = created
    button.uaForeverTextOverlay = overlay

    if type(font_string.GetFontObject) == "function"
        and type(overlay.SetFontObject) == "function" then
        local font_ok, font = pcall(font_string.GetFontObject, font_string)
        if font_ok and font then pcall(overlay.SetFontObject, overlay, font) end
    end
    if type(overlay.SetAllPoints) == "function" then
        pcall(overlay.SetAllPoints, overlay, button)
    end
    if type(overlay.SetJustifyH) == "function" then
        pcall(overlay.SetJustifyH, overlay, "CENTER")
    end
    if type(overlay.SetJustifyV) == "function" then
        pcall(overlay.SetJustifyV, overlay, "MIDDLE")
    end
    if type(overlay.SetWordWrap) == "function" then
        pcall(overlay.SetWordWrap, overlay, false)
    end
    hide_native_button_text(font_string)
    runtime.ensure_font(overlay)

    local function sync_style()
        sync_button_style(font_string, overlay)
        -- SharedButtonSmallTemplate changes the native FontObject from its
        -- OnEnable/OnDisable/hover handlers. That restores the FontString's
        -- opacity, so hide it again after every state transition.
        hide_native_button_text(font_string)
    end
    for _, script in ipairs({
        "OnEnable", "OnDisable", "OnEnter", "OnLeave",
        "OnMouseDown", "OnMouseUp", "OnShow",
    }) do
        hooks.region_script(button, script, sync_style,
            "profession-create-button-style")
    end
    sync_style()
    return overlay
end

local function translate_create_button(button, font_string, overlay)
    if not button or not font_string or not overlay
        or button.uaForeverClearingNativeText
        or type(font_string.GetText) ~= "function"
        or type(overlay.GetText) ~= "function"
        or type(overlay.SetText) ~= "function" then return false end
    local ok, source = pcall(font_string.GetText, font_string)
    if not ok or type(source) ~= "string" or source == ""
        or is_secret(source) then return false end

    hide_native_button_text(font_string)

    local translated = strings.find_ui_translation(source, font_string)
    local display = options.can_translate("translate_string")
        and translated and translated ~= source and translated or source
    -- The button template swaps Normal/Highlight/Disabled font objects in
    -- native code. Keeping the captured source in the original FontString can
    -- therefore make it visible again during rapid hover transitions. The
    -- build never reads these two button labels back for gameplay logic, so
    -- leave the native region empty after copying its final text to our layer.
    clear_native_button_text(button, font_string)
    local current_ok, current = pcall(overlay.GetText, overlay)
    if current_ok and current == display then return true end
    if not runtime.can_write_text(overlay) then return false end
    if display:find("[\208\209]") then runtime.ensure_font(overlay) end
    local applied = pcall(overlay.SetText, overlay, display)
    if applied then strings.fit_button_to_text(button, overlay) end
    return applied
end

local function hook_create_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, font_string = pcall(button.GetFontString, button)
    if not ok or not font_string then return end
    local overlay = button_overlay(button, font_string)
    if not overlay then return end

    -- ValidateControls rewrites these labels every 0.75 seconds. The visible
    -- addon-owned layer follows the final native value without changing the
    -- protected button or its click behavior.
    hooks.region(font_string, "SetText", function (self)
        if not runtime.is_applying(self) then
            translate_create_button(button, self, overlay)
        end
    end)
    translate_create_button(button, font_string, overlay)
end

local function translate_create_controls(page)
    if not page then return end
    hook_create_button(page.CreateButton)
    hook_create_button(page.CreateAllButton)
end

local function translate_form_chrome(form)
    if not form then return end
    for _, region in pairs({
        form.OutputSubText,
        form.Cooldown,
        form.MinimizedCooldown,
        form.RecraftingDescription,
        form.TrackRecipeCheckbox and
            (form.TrackRecipeCheckbox.Text or form.TrackRecipeCheckbox.Label),
        form.AllocateBestQualityCheckbox and
            (form.AllocateBestQualityCheckbox.Text
                or form.AllocateBestQualityCheckbox.Label),
        form.Reagents and (form.Reagents.Label or form.Reagents.Text),
        form.OptionalReagents and
            (form.OptionalReagents.Label or form.OptionalReagents.Text),
        form.FinishingReagents and
            (form.FinishingReagents.Label or form.FinishingReagents.Text),
        form.RecipeSourceButton and form.RecipeSourceButton.Text,
        form.FirstCraftBonus and form.FirstCraftBonus.Text,
        form.RecipeLevelDropdown and form.RecipeLevelDropdown.Text,
    }) do
        hook_text_region(region)
    end
end

local function translate_search_chrome(page)
    local list = page and page.RecipeList
    if list then
        hook_text_region(list.NoResultsText)
        hook_text_region(list.SearchBox and list.SearchBox.Instructions)
        hook_text_region(list.FilterDropdown and list.FilterDropdown.Text)
        hook_button(list.FilterDropdown)
    end

    local search = page and page.MinimizedSearchBox
    if search then
        hook_text_region(search.Instructions)
        if type(search.GetAllResultsButton) == "function" then
            local ok, button = pcall(search.GetAllResultsButton, search)
            if ok and button then
                hook_text_region(button.text or button.Text)
                hook_button(button)
            end
        end
    end

    local results = page and page.MinimizedSearchResults
    if results and type(results.GetTitleText) == "function" then
        local ok, title = pcall(results.GetTitleText, results)
        if ok then hook_text_region(title) end
    end
end

local function translate_page(page)
    page = page or (_G.ProfessionsFrame and _G.ProfessionsFrame.CraftingPage)
    if not page then return end

    translate_title(_G.ProfessionsFrame)
    translate_rank_bar(page.RankBar)
    translate_search_chrome(page)
    translate_form_chrome(page.SchematicForm)
    hook_text_region(page.GamepadCreateMultiple and page.GamepadCreateMultiple.Text)
    hook_button(page.ViewGuildCraftersButton, true)
    translate_create_controls(page)
end

local function translate_frame(frame)
    frame = frame or _G.ProfessionsFrame
    if not frame then return end
    translate_title(frame)
    translate_page(frame.CraftingPage)
    translate_book(frame.BookPage)
    hook_right_tab(frame.ProfessionsOverviewTab)
    for _, tab in ipairs(frame.rightProfessionTabs or {}) do
        hook_right_tab(tab)
    end
end

local function after_refresh_right_tab(_, tab)
    hook_right_tab(tab)
end

local function hook_instances()
    local frame = _G.ProfessionsFrame
    local page = frame and frame.CraftingPage
    local form = page and page.SchematicForm
    hooks.region(page, "Refresh", translate_page)
    hooks.region(page, "UpdateSearchPreview", translate_page)
    hooks.region(page, "ValidateControls", translate_create_controls)
    hooks.region(form, "Init", translate_form_chrome)
    hooks.region(form, "Refresh", translate_form_chrome)
    hooks.region(form, "Update", translate_form_chrome)
    hooks.region(frame, "Refresh", translate_frame)
    hooks.region(frame, "SelectBookPage", translate_frame)
    hooks.region(frame, "RefreshRightTab", after_refresh_right_tab)
    hooks.region(frame and frame.BookPage, "Update", translate_book)
    hooks.region(_G.ProfessionsBookFrame, "Update", translate_book)
    hooks.region_script(frame, "OnShow", translate_frame,
        "profession-frame")
    hooks.region_script(page, "OnShow", translate_page, "profession-frame")
    hooks.region_script(_G.ProfessionsBookFrame, "OnShow", translate_book,
        "profession-frame")
end

adapter.prepare = function ()
    hooks.mixin("ProfessionsCraftingPageMixin", "Refresh", translate_page)
    hooks.mixin("ProfessionsCraftingPageMixin", "UpdateSearchPreview", translate_page)
    hooks.mixin("ProfessionsCraftingPageMixin", "ValidateControls",
        translate_create_controls)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Init",
        translate_form_chrome)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Refresh",
        translate_form_chrome)
    hooks.mixin("ProfessionsRecipeSchematicFormMixin", "Update",
        translate_form_chrome)
    hooks.mixin("ProfessionsRankBarMixin", "Update", translate_rank_bar)
    hooks.mixin("ProfessionSpellButtonMixin", "UpdateButton",
        translate_profession_spell_button)
    hooks.mixin("ProfessionsBookFrameMixin", "Update", translate_book)
    hooks.mixin("ProfessionsMixin", "Refresh", translate_frame)
    hooks.mixin("ProfessionsMixin", "SelectBookPage", translate_frame)
    hooks.mixin("ProfessionsMixin", "RefreshRightTab", after_refresh_right_tab)
    hook_instances()
    translate_frame()
    translate_book(_G.ProfessionsBookFrame)
end
