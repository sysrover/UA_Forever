local _, addon_table = ...

local spoken = addon_table.use("spoken")
local options = addon_table.use("options")
local entries = addon_table.use("entries")
local items = addon_table.use("item_client_db")
local runtime = addon_table.use("translation_runtime")
local assets = addon_table.use("assets")
local hooks = addon_table.use("translation_hooks").bind("spoken-readables")
local profile = addon_table.use("performance_profile").wrap or function (_, callback) return callback end
local indexed_data
local catalog_ids

local function enabled()
    return spoken.entries_ready and options.can_translate("translate_spoken") and options.section_enabled("books")
end

local function readable(text)
    return not runtime.is_secret_value(text) and type(text) == "string" and text ~= ""
end

local function owner_ids(data)
    if indexed_data == data then return catalog_ids end
    local ids = {}
    local catalog = addon_table.book or {}
    local owners = data.owners or {}
    for _, kind in ipairs({ "item", "object" }) do
        for owner, book in pairs(owners[kind] or {}) do
            if catalog[owner] then
                local previous = ids[book]
                if previous == nil then
                    ids[book] = owner
                elseif previous and catalog[previous] ~= catalog[owner] then
                    ids[book] = false
                end
            end
        end
    end
    indexed_data, catalog_ids = data, ids
    return ids
end

local function translated_page(data, book_id, number)
    if type(number) ~= "number" or number < 1 then return nil end
    local book = data.books and data.books[book_id]
    if not book or not book.pages then return nil end
    local id = owner_ids(data)[book_id]
    if id == nil and type(items.get_id_by_english_name) == "function" then
        id = items.get_id_by_english_name(book.title)
    end
    local catalog = addon_table.book or {}
    local pages = (id and catalog[id]) or catalog[book.title]
    -- The Spoken corpus can include pages absent from this client's edition.
    -- Do not apply a later page's translation to a preceding missing page.
    if not pages or #pages ~= #book.pages then return nil end
    local text = entries.get_book_page(id or nil, book.title, number)
    return readable(text) and text or nil
end

spoken.readable_title = function (source)
    if not enabled() or not readable(source) then return nil end
    local title, suffix = source:match("^(.-)( %(%d+%))$")
    title = title or source
    local translated = type(addon_table.translate_object_name) == "function"
        and addon_table.translate_object_name(title)
    if not readable(translated) and type(items.get_name_by_english) == "function" then
        translated = items.get_name_by_english(title)
    end
    return readable(translated) and translated .. (suffix or "") or nil
end

spoken.readable_text = function (book_id)
    local readables = _G.SpokenReadables
    if not enabled() or not readables or type(readables.Data) ~= "function" then return nil end
    local data = readables:Data()
    local book = data and data.books and data.books[book_id]
    if not book or not book.pages then return nil end
    local pages = {}
    local changed = false
    for _, page_id in ipairs(book.pages) do
        local page = data.pages and data.pages[page_id]
        local words = page and translated_page(data, book_id, page.number)
        if words then
            changed = true
        else
            words = readables:PackPageText(page_id, readables:GetTextLanguage())
                or readables:TextLanguagePageText(page_id) or (page and page.text)
            if readable(words) then words = readables:FillPlayerTokens(words) end
        end
        if readable(words) then pages[#pages + 1] = words end
    end
    return changed and table.concat(pages, "\n\n") or nil
end

spoken.prepare_readables = function ()
    local readables = _G.SpokenReadables
    if type(readables) ~= "table" or type(readables.Data) ~= "function" then return end
    hooks.once("captions", function ()
        local original = readables.ClipFor
        if type(original) ~= "function" then return false end
        readables.ClipFor = profile("spoken-readables.audio", function (self, page_id, ...)
            local clip = original(self, page_id, ...)
            if not enabled() or not clip or not clip.present then return clip end
            local data = self:Data()
            local page = data and data.pages and data.pages[page_id]
            local display = clip.present
            local title_field = self:OneLine() and "label" or "header"
            local title = spoken.readable_title(display[title_field])
            local text = page and translated_page(data, page.book, page.number)
            if title then display[title_field] = title end
            if text then
                display.transcript = text
                display.timings = nil
            end
            if title or text then display.font = assets.font_frizqt end
            return clip
        end)
        return true
    end)
end
