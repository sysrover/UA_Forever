local _, addon_table = ...

local auto_scan = addon_table.use("auto_scan")
local entries = addon_table.use("entries")
local runtime = addon_table.use("translation_runtime")
local utils = addon_table.use("utils")
local book_ui = addon_table.use("book_ui")

local current_book_id
local current_book_name
local page_overlay

local function call_method(object, name, ...)
    if not object then return false end
    local method_ok, method = pcall(function () return object[name] end)
    if not method_ok or type(method) ~= "function" then return false end
    return pcall(method, object, ...)
end

local function restore_original(region)
    if page_overlay then call_method(page_overlay, "Hide") end
    if region then
        call_method(region, "SetAlpha", 1)
        call_method(region, "Show")
    end
end

local function hide_original(region)
    if not call_method(region, "Hide") then
        call_method(region, "SetAlpha", 0)
    end
end

local function copy_page_layout(source, overlay)
    call_method(overlay, "ClearAllPoints")
    call_method(overlay, "SetPoint", "TOPLEFT", source, "TOPLEFT", 0, 0)

    local width_ok, width = call_method(source, "GetWidth")
    if width_ok and type(width) == "number" and width > 0 then
        call_method(overlay, "SetWidth", width)
    end
    local height_ok, height = call_method(source, "GetHeight")
    if height_ok and type(height) == "number" and height > 0 then
        call_method(overlay, "SetHeight", height)
    end

    call_method(overlay, "SetJustifyH", "LEFT")
    call_method(overlay, "SetJustifyV", "TOP")
    call_method(overlay, "SetWordWrap", true)
    local color_ok, r, g, b, a = call_method(source, "GetTextColor", "P")
    if color_ok and type(r) == "number" and type(g) == "number"
        and type(b) == "number" then
        call_method(overlay, "SetTextColor", r, g, b,
            type(a) == "number" and a or 1)
    end
end

local function ensure_page_overlay(region)
    if page_overlay then
        copy_page_layout(region, page_overlay)
        return page_overlay
    end

    local parent_ok, parent = call_method(region, "GetParent")
    if not parent_ok or not parent then return nil end
    local created, overlay = call_method(parent, "CreateFontString",
        nil, "OVERLAY", "QuestFont")
    if not created or not overlay then return nil end
    page_overlay = overlay
    copy_page_layout(region, overlay)
    return overlay
end

local function finish_overlay_layout(region, overlay)
    local base_ok, base_height = call_method(region, "GetHeight")
    local content_ok, content_height = call_method(overlay, "GetStringHeight")
    if content_ok and type(content_height) == "number" and content_height > 0 then
        local height = base_ok and type(base_height) == "number"
            and math.max(base_height, content_height) or content_height
        call_method(overlay, "SetHeight", height)
    end
    utils.update_item_text_scrollbar()
end

local function read_overlay_text(overlay)
    local text_ok, text = call_method(overlay, "GetText")
    if not text_ok or runtime.is_secret_value(text) then return nil end
    return type(text) == "string" and text ~= "" and text or nil
end

local function overlay_matches(overlay, visible, display)
    if visible == display then return true end
    return read_overlay_text(overlay) == display
end

local function note_unsafe(context, value)
    if not runtime.is_secret_value(value) then return false end
    if type(auto_scan.record_unsafe_source) == "function" then
        auto_scan.record_unsafe_source("book-ui:" .. context)
    end
    return true
end

local function safe_number(value, context)
    if note_unsafe(context or "number", value) then return nil end
    return type(value) == "number" and value > 0 and value or nil
end

local function safe_string(value, context)
    if note_unsafe(context or "text", value) then return nil end
    return runtime.safe_string_or_nil(value)
end

local function title_region()
    local global = _G.ItemTextFrameTitleText
    if global and not runtime.is_secret_value(global) then return global end

    local frame = _G.ItemTextFrame
    if not frame or runtime.is_secret_value(frame) then return nil end
    local ok, region = pcall(function ()
        local container = frame.TitleContainer
        return container and (container.TitleText or container.ItemTextTitleText)
    end)
    if not ok or runtime.is_secret_value(region) then return nil end
    return region
end

book_ui.note = function (...)
    for index = 1, select("#", ...) do
        local value = select(index, ...)
        local identity = safe_number(value, "book-id")
        if identity then
            current_book_id = identity
            break
        end
    end

    if type(_G.ItemTextGetItem) == "function" then
        local ok, name, identity = pcall(_G.ItemTextGetItem)
        if ok then
            current_book_name = safe_string(name, "book-name") or current_book_name
            current_book_id = safe_number(identity, "book-id") or current_book_id
        end
    end

    if not current_book_id and current_book_name and entries.lookup_id then
        current_book_id = entries.lookup_id("item", current_book_name)
    end

    local legacy_id = utils.get_currently_viewed_book_id
        and utils.get_currently_viewed_book_id() or 0
    current_book_id = safe_number(legacy_id, "legacy-book-id") or current_book_id
end

book_ui.begin = function (...)
    current_book_id = nil
    current_book_name = nil
    book_ui.note(...)
end

book_ui.snapshot = function ()
    book_ui.note()
    if type(_G.ItemTextGetText) ~= "function" then return nil end

    local text_ok, source = pcall(_G.ItemTextGetText)
    source = text_ok and safe_string(source, "book-page") or nil
    if not source then return nil end

    local page = 1
    if type(_G.ItemTextGetPage) == "function" then
        local page_ok, value = pcall(_G.ItemTextGetPage)
        page = page_ok and safe_number(value, "book-page-number") or page
    end

    local translated, identity = entries.get_book_page(
        current_book_id, current_book_name, page)
    local translated_title = entries.get_book_title
        and entries.get_book_title(current_book_name) or nil
    local region = _G.ItemTextPageText
    local visible
    if page_overlay then
        local shown_ok, shown = call_method(page_overlay, "IsShown")
        if shown_ok and shown == true then
            visible = read_overlay_text(page_overlay)
        end
    end
    if not visible and region and type(region.GetText) == "function" then
        local visible_ok, value = pcall(region.GetText, region)
        visible = visible_ok and safe_string(value, "book-visible") or nil
    end

    return {
        id = current_book_id,
        name = current_book_name,
        identity = identity or current_book_id or current_book_name,
        page = page,
        source = source,
        translated = translated,
        title_source = current_book_name,
        translated_title = translated_title,
        title_region = title_region(),
        region = region,
        visible = visible or source,
    }
end

book_ui.refresh = function ()
    local page = book_ui.snapshot()
    if not page or not page.region then return false end

    local surface = _G.ItemTextFrame or page.region
    local instance = tostring(page.identity or "unknown") .. ":" .. tostring(page.page)
    local generation = runtime.begin_generation(surface, instance)
    local title_applied = false
    if page.title_region and type(page.translated_title) == "string"
        and page.translated_title ~= "" then
        title_applied = runtime.apply(page.title_region, {
            owner = "book-title",
            slot = "book.title",
            source = page.title_source,
            translated = page.translated_title,
            option = "translate_book",
            priority = runtime.PRIORITY.DOMAIN,
            surface = surface,
            generation = generation,
            instance = instance,
        }) == true
    end
    if type(page.translated) ~= "string" or page.translated == "" then
        restore_original(page.region)
        return title_applied
    end

    local overlay = ensure_page_overlay(page.region)
    if not overlay then
        restore_original(page.region)
        return title_applied
    end
    call_method(overlay, "Show")

    local applied = runtime.apply(overlay, {
        owner = "book-page",
        slot = "book.page",
        source = page.source,
        translated = page.translated,
        option = "translate_book",
        priority = runtime.PRIORITY.DOMAIN,
        surface = surface,
        generation = generation,
        instance = instance,
        visible_matches = function (visible, display)
            return overlay_matches(overlay, visible, display)
        end,
        after_apply = function ()
            finish_overlay_layout(page.region, overlay)
        end,
        after_visibility = function ()
            finish_overlay_layout(page.region, overlay)
        end,
    })
    if applied then
        hide_original(page.region)
        finish_overlay_layout(page.region, overlay)
    else
        restore_original(page.region)
    end
    return applied or title_applied
end
