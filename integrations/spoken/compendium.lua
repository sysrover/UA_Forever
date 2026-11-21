local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local assets = addon_table.use("assets")
local resolver = addon_table.use("translation_resolver")
local hooks = addon_table.use("translation_hooks").bind("spoken-compendium")
local profile = addon_table.use("performance_profile").wrap or function (_, callback) return callback end
local locale = addon_table.spoken_locale_uk.Quests
local readables_locale = addon_table.spoken_locale_uk.Readables
local bosses_locale = addon_table.spoken_locale_uk.Bosses
local selected_rows = setmetatable({}, { __mode = "k" })
local wrapped_tabs = setmetatable({}, { __mode = "k" })
local wrapped_pages = setmetatable({}, { __mode = "k" })

local part_fields = { accept = 2, complete = 5 }
local part_labels = { accept = locale.QUEST_PART_ACCEPT, complete = locale.QUEST_PART_COMPLETE }

local function readable(text)
    return not runtime.is_secret_value(text) and type(text) == "string" and text ~= ""
end

local function enabled()
    return spoken.entries_ready and options.can_translate("translate_spoken")
end

local function quest_enabled(section)
    return options.section_enabled(section) and translation.get_quest_language() ~= "en"
end

local function quest_entry(id, title)
    if runtime.is_secret_value(id) or type(id) ~= "number" or id <= 0 then return nil end
    local entry = entries.get_entry("quest", id, 1)
    if not entry then return nil end
    if readable(entry.en) and readable(title)
        and not utils.same_english_name(entry.en, title)
        and not utils.same_english_name(entry[1], title) then return nil end
    return entry
end

local function copy(source)
    local result = {}
    for key, value in pairs(source) do result[key] = value end
    return result
end

local function place_or_ui(source)
    if not readable(source) then return nil end
    return spoken.place_name(source) or resolver.find_ui(source)
end

local function zone_line(source, format, more_format)
    if not readable(source) then return source end
    local prefix = format:match("^(.-)%%1%$s$")
    if not prefix or source:sub(1, #prefix) ~= prefix then return source end
    local body = source:sub(#prefix + 1)
    local tail_at = body:find(" · ", 1, true)
    local more_marker = more_format and more_format:match("^(.-)%%1%$d")
    local more_at = more_marker and more_marker ~= "" and body:find(more_marker, 1, true)
    if more_at then tail_at = math.min(tail_at or more_at, more_at) end
    local names = tail_at and body:sub(1, tail_at - 1) or body
    local result = {}
    for name in names:gmatch("[^,]+") do
        local trimmed = name:match("^%s*(.-)%s*$")
        result[#result + 1] = spoken.place_name(trimmed) or trimmed
    end
    return prefix .. table.concat(result, ", ") .. (tail_at and body:sub(tail_at) or "")
end

local function chain_name(source)
    if not readable(source) then return nil end
    local label, suffix = source:match("^(.-)( %(%d+%))$")
    local translated = entries.lookup_name("quest", label or source)
    return translated and (translated .. (suffix or "")) or nil
end

local function list_label(row, key)
    if key == "places" then return spoken.place_name(row.label) end
    if key == "readables" and row.kind == "readable" then return spoken.readable_title(row.label) end
    if key == "bosses" and row.kind == "boss" then return spoken.boss_title(row.map, row.key, row.label) end
    if key == "quests" and row.kind == "quest" then
        local entry = quest_enabled("quest_names") and quest_entry(row.quest, row.label)
        return entry and entry[1] or nil
    elseif key == "quests" and row.kind == "chain" then
        return quest_enabled("quest_names") and chain_name(row.label)
    end
    return place_or_ui(row.label)
end

local function set_face(region, file)
    if not region or not runtime.can_write_text(region) then return end
    local current, size, flags = region:GetFont()
    if current and current ~= file and size then region:SetFont(file, size, flags) end
end

local function prepare_list(list, panel, key)
    local definition = list and list.opts
    if not definition or type(definition.build) ~= "function" then return end
    local build = definition.build
    definition.build = profile("spoken-compendium.rows", function (...)
        local rows = build(...)
        selected_rows[panel] = nil
        if not enabled() then return rows end
        for _, row in ipairs(rows) do
            if key == "quests" and definition.isSelected and definition.isSelected(row) then
                selected_rows[panel] = row
            end
            local label = list_label(row, key)
            if readable(label) then row.label = label end
        end
        return rows
    end)
    hooks.region(list, "Render", function (self)
        if not enabled() then return end
        for index = 1, #(self.items or {}) do
            local row = self.rows[index]
            if row then
                set_face(row.label, assets.font_frizqt)
                set_face(row.count, assets.font_frizqt)
            end
        end
    end)
end

local function part_context(part)
    for _, button in ipairs(part.buttons or {}) do
        if part_fields[button.moment] and type(button.questID) == "number" then
            return button.questID, button.moment
        end
    end
    local label = part.caption or part.heading
    if not readable(label) then return nil end
    if label == _G.QUEST_DESCRIPTION or label == locale.QUEST_PART_ACCEPT or label == "Description" then
        return nil, "accept"
    end
    if label == locale.QUEST_PART_COMPLETE or label == "Completion" then return nil, "complete" end
end

local function part_text(id, moment, source)
    local field = part_fields[moment]
    if not id or not field or not quest_enabled("quest_text") then return nil end
    local entry = entries.get_entry("quest", id, field, source)
    return entry and readable(entry[field]) and entry[field] or nil
end

local function translate_part(part, id, moment)
    local display = copy(part)
    display.text = part_text(id, moment, part.text) or part.text
    if part.caption then
        display.caption = part_labels[moment] or part.caption
        if readable(part.heading) and options.section_enabled("npc_target") then
            display.heading = entries.lookup_name("npc", part.heading) or part.heading
        end
    else
        display.heading = part_labels[moment] or part.heading
    end
    return display
end

local function translate_quest_page(entry, row, panel)
    local id = row and row.quest
    if not id then
        for _, part in ipairs(entry.parts or {}) do
            id = part_context(part)
            if id then break end
        end
    end
    local display = copy(entry)
    display.subtitle = zone_line(entry.subtitle, locale.QUESTS_IN_FMT, locale.QUESTS_MORE_FMT)
    local quest = id and quest_entry(id, entry.title)
    if quest and quest_enabled("quest_names") and readable(quest[1]) then
        display.title = quest[1]
    elseif not id then
        display.title = (row and row.kind == "chain" and chain_name(entry.title))
            or place_or_ui(entry.title) or entry.title
    end
    if quest and entry.parts then
        display.parts = {}
        for index, part in ipairs(entry.parts) do
            local _, moment = part_context(part)
            display.parts[index] = translate_part(part, id, moment)
        end
    elseif quest and entry.unwritten and not entry.text then
        local description = part_text(id, "accept")
        local unlock = panel.tab and panel.tab.unlock
        local completion = ((row and row.done) or (unlock and unlock.get and unlock.get()))
            and part_text(id, "complete")
        if description or completion then
            display.parts, display.unwritten = {}, nil
            if description then display.parts[1] = { heading = part_labels.accept, text = description } end
            if completion then
                display.parts[#display.parts + 1] = { heading = part_labels.complete, text = completion }
            end
        end
    end
    return display
end

local function translate_readable_page(entry)
    local display = copy(entry)
    display.title = spoken.readable_title(entry.title) or place_or_ui(entry.title) or entry.title
    display.subtitle = zone_line(entry.subtitle, readables_locale.READABLES_IN_FMT, readables_locale.READABLES_MORE_FMT)
    local text = entry.target and spoken.readable_text(entry.target)
    if text then display.text, display.unwritten = text, nil end
    return display
end

local function translate_boss_page(entry)
    local display = copy(entry)
    local target = entry.target or {}
    display.title = spoken.boss_title(target[1], target[2], entry.title) or place_or_ui(entry.title) or entry.title
    display.subtitle = zone_line(entry.subtitle, bosses_locale.BOSS_IN_FMT)
    if readable(display.subtitle) then
        local first, second = display.subtitle:match("^(.-) · (.+)$")
        local name = second and spoken.place_name(second)
        if name then display.subtitle = first .. " · " .. name end
    end
    local text = spoken.boss_text(target[1], target[2])
    if text then display.text, display.unwritten = text, nil end
    return display
end

local page_translators = {
    quests = translate_quest_page,
    readables = translate_readable_page,
    bosses = translate_boss_page,
}

local function prepare_page(panel, key)
    local page = panel and panel.page
    if not page or wrapped_pages[page] or type(page.Show) ~= "function" or not page.body then return end
    local original = page.Show
    local owner = page.body.owner
    local ukrainian_body = false
    page.body.owner = {
        FontFor = function (_, font_object)
            if ukrainian_body then
                return _G.QuestTitleFont and font_object == _G.QuestTitleFont
                    and assets.font_morpheus or assets.font_frizqt
            end
            if owner and type(owner.FontFor) == "function" then return owner:FontFor(font_object) end
        end,
    }
    page.Show = profile("spoken-compendium." .. key .. "-page", function (self, entry)
        ukrainian_body = false
        if not enabled() then return original(self, entry) end
        local display = page_translators[key](entry, selected_rows[panel], panel)
        ukrainian_body = key == "quests" or display.text ~= entry.text
            or readable(display.text) and display.text:find("[\208\209]") ~= nil
        set_face(self.title, assets.font_morpheus)
        set_face(self.sub and self.sub.text, assets.font_frizqt)
        return original(self, display)
    end)
    wrapped_pages[page] = true
end

local function prepare_tab(tab, key)
    if not page_translators[key] or not tab or wrapped_tabs[tab] or type(tab.build) ~= "function" then return end
    local build = tab.build
    tab.build = profile("spoken-compendium." .. key .. "-tab", function (panel, ...)
        build(panel, ...)
        prepare_page(panel, key)
    end)
    if tab.panel then prepare_page(tab.panel, key) end
    wrapped_tabs[tab] = true
end

local list_keys = { "quests", "places", "readables", "bosses" }

spoken.prepare_compendium = function ()
    local compendium = _G.SpokenCompendium
    if not compendium or type(compendium.Tab) ~= "function" then return end
    hooks.once("lists", function ()
        local native = compendium.NewList
        if type(native) ~= "function" then return false end
        compendium.NewList = profile("spoken-compendium.create-list", function (panel, ...)
            local list = native(panel, ...)
            local tab = panel and panel.tab
            if tab then
                for _, key in ipairs(list_keys) do
                    if tab == compendium:Tab(key) then
                        prepare_list(list, panel, key)
                        break
                    end
                end
            end
            return list
        end)
        return true
    end)
    hooks.region(compendium, "Register", function (self, key)
        prepare_tab(self:Tab(key), key)
    end)
    for key in pairs(page_translators) do prepare_tab(compendium:Tab(key), key) end
end
