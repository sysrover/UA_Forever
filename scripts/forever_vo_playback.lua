local _, addon_table = ...
local playback = addon_table.use("forever_vo_playback")
local entries = addon_table.use("entries")
local options = addon_table.use("options")
local translation = addon_table.use("translation")
local runtime = addon_table.use("translation_runtime")
local strings = addon_table.use("strings")
local utils = addon_table.use("utils")
local hooks = addon_table.use("translation_hooks").bind("forever-vo-playback")
local wording = addon_table.forever_surface_ui.forever_vo
local display_items = setmetatable({}, { __mode = "k" })
local head_sessions = setmetatable({}, { __mode = "k" })
local queue_items = setmetatable({}, { __mode = "k" })
local quest_fields = { accept = 2, progress = 4, complete = 5 }

local function readable(value)
    return not runtime.is_secret_value(value) and type(value) == "string" and value ~= ""
end

local function enabled(option, section)
    return options.can_translate(option) and options.section_enabled(section)
end

local function quest_entry(item)
    if item.kind ~= "quest" or runtime.is_secret_value(item.questID)
        or type(item.questID) ~= "number" then return end
    local entry = entries.get_entry("quest", item.questID)
    if entry and (not readable(entry.en) or utils.same_english_name(entry.en, item.title)) then return entry end
end

local function title_for(item)
    if item.kind == "gossip" and readable(item.title)
        and enabled("translate_gossip", "gossip") then
        local source = item.title:match('^"(.*)"$')
        if source then
            local translated = entries.find_gossip_translation(item.speakerKey, source, true)
            if readable(translated) then return '"' .. translated .. '"' end
        end
        return item.title
    end
    if translation.get_quest_language() == "en"
        or not enabled("translate_quest", "quest_names")
        or not options.translate_name("quest") then return item.title end
    local entry = quest_entry(item)
    return entry and readable(entry[1]) and utils.cap(entry[1]) or item.title
end

local function name_for(item)
    if not enabled("translate_npc", "npc_target")
        or not options.translate_name("npc") then return item.name end
    local id = item.speakerKey
    if runtime.is_secret_value(id) or type(id) ~= "number" or id == 0 then return item.name end
    local entry = entries.get_entry(id > 0 and "npc" or "object", math.abs(id))
    if entry and readable(entry[1])
        and (not readable(entry.en) or utils.same_english_name(entry.en, item.name)) then return utils.cap(entry[1]) end
    return item.name
end

local function text_for(item)
    if item.kind == "quest" and enabled("translate_quest", "quest_text")
        and translation.get_quest_language() ~= "en" then
        local entry = quest_entry(item)
        local field = quest_fields[item.event]
        if entry and field and readable(entry[field]) then return entry[field] end
    elseif item.kind == "gossip" and enabled("translate_gossip", "gossip")
        and type(item.speakerKey) == "number" and item.speakerKey > 0 then
        local text = entries.find_gossip_translation(item.speakerKey, item.text, false)
        if readable(text) then return text end
    end
    return item.text
end

local function apply(region, source, translated, slot, option, category, section, surface)
    if not region or runtime.is_applying(region) then return end
    runtime.ensure_font(region)
    if not readable(source) or not readable(translated) then return end
    if translated == source then
        local claim = runtime.get(region)
        if claim and claim.owner == "forever-vo-playback" then runtime.invalidate(region) end
        return
    end
    runtime.apply(region, {
        owner = "forever-vo-playback", slot = slot, source = source, translated = translated,
        option = option, category = category,
        section = section or (category == "npc" and "npc_target" or "game_settings"),
        surface = surface,
        generation = surface and runtime.generation(surface) or nil,
        instance = surface and runtime.generation_instance(surface) or nil,
        priority = runtime.PRIORITY.DOMAIN,
        reapply_cached = true,
    })
end

local function head_generation(head)
    local item, frame = head.displayed, head.frame
    if not item or not frame then return end
    local language = translation.get_quest_language()
    local session = head_sessions[head]
    if not session or session.item ~= item or session.language ~= language then
        runtime.begin_generation(frame, tostring(item))
        head_sessions[head] = { item = item, language = language }
    end
end

local function ui_region(region)
    if not region then return end
    strings.translate_region(region, nil, "forever-vo.ui", nil, nil, nil, "game_settings")
    local source = region:GetText()
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    if readable(source) and enabled("translate_string", "game_settings") then
        apply(region, source, wording.value(source), "forever-vo.ui", "translate_string")
    end
    runtime.ensure_font(region)
end

local function update_quest_button(button)
    local region = button and button:GetFontString()
    if not region or runtime.is_applying(region) then return end
    strings.translate_region(region, nil, "forever-vo.quest-play", nil, nil, nil, "game_settings")
end

local function prepare_quest_log(quest_log)
    local button = quest_log and quest_log.detailsButton
    if not button then return end
    hooks.region(button, "SetText", update_quest_button)
    hooks.region_script(button, "OnShow", update_quest_button)
    update_quest_button(button)
end

local function update_control_tooltip(button)
    local tooltip = _G.GameTooltip
    if not tooltip or tooltip:GetOwner() ~= button then return end
    local region = _G.GameTooltipTextLeft1
    if not region then return end
    local source = region:GetText()
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    if not readable(source) then return end
    local display = source
    if enabled("translate_string", "game_settings") then
        display = wording.value(source) or strings.find_ui_translation(source, region) or source
    end
    local r, g, b, a = region:GetTextColor()
    runtime.ensure_font(region)
    -- Updating a tooltip FontString alone leaves the original English box size.
    -- Rebuild the single-line control tooltip with wrapping and normal layout.
    tooltip:SetText(display, r, g, b, a, true)
    tooltip:SetClampedToScreen(true)
    tooltip:Show()
end

local function prepare_head(head)
    local frame = head.frame
    if not frame then return end
    for _, field in ipairs({ "Name", "Title" }) do
        local region = frame[field]
        local function update(self, source)
            local item = head.displayed
            if not item or runtime.is_applying(self) then return end
            local original = field == "Name" and item.name or item.title
            local translated = field == "Name" and name_for(item) or title_for(item)
            if source ~= original and source ~= translated then return end
            head_generation(head)
            local is_name = field == "Name"
            apply(self, original, translated,
                "forever-vo:" .. tostring(is_name and item.speakerKey or item.questID) .. ".name",
                is_name and "translate_npc" or (item.kind == "gossip" and "translate_gossip" or "translate_quest"),
                is_name and "npc" or (item.kind == "quest" and "quest" or nil),
                is_name and "npc_target" or (item.kind == "gossip" and "gossip" or "quest_names"),
                frame)
        end
        hooks.region(region, "SetText", update)
        if region then
            runtime.ensure_font(region)
            update(region, region:GetText())
        end
    end
    runtime.ensure_font(frame.Text)
    runtime.ensure_font(frame.Measure)
    hooks.region(frame.QueueText, "SetText", function(self)
        if not runtime.is_applying(self) then ui_region(self) end
    end)
    ui_region(frame.QueueText)
    for _, field in ipairs({ "PauseButton", "SkipButton", "QueueButton" }) do
        hooks.region_script(frame[field], "OnEnter", update_control_tooltip)
    end
end

local function update_queue(list)
    local frame = list.frame
    if not frame then return end
    for _, region in pairs({ frame.Header, frame.Empty, frame.More,
        frame.ClearButton and frame.ClearButton:GetFontString() }) do ui_region(region) end
    if frame.ClearButton then frame.ClearButton:SetWidth(100) end
    if not list.rowPool or type(list.rowPool.EnumerateActive) ~= "function" then return end
    for row in list.rowPool:EnumerateActive() do
        local item = row.item
        if item then
            if queue_items[row] ~= item then
                runtime.begin_generation(row, tostring(item))
                queue_items[row] = item
            end
            local label = wording.queue_label(title_for(item), name_for(item), _G.GRAY_FONT_COLOR_CODE or "")
            apply(row.Text, row.Text:GetText(), label, "forever-vo.queue", "translate_string",
                nil, nil, row)
            hooks.region_script(row, "OnEnter", function(self)
                local current = self.item
                if not current or not _G.GameTooltip then return end
                apply(_G.GameTooltipTextLeft1, current.title or current.name,
                    title_for(current) or name_for(current), "forever-vo.queue.title", "translate_string")
                if current.title and current.name then
                    apply(_G.GameTooltipTextLeft2, current.name, name_for(current),
                        "forever-vo.queue.name", "translate_npc", "npc", "npc_target")
                end
            end)
        end
    end
end

local function refresh_playback()
    local ui = _G.ForeverVO and _G.ForeverVO.UI
    local head = ui and ui.TalkingHead
    local item, frame = head and head.displayed, head and head.frame
    if item and frame then
        -- These setters use the native queue record, so the same refresh also
        -- restores English when a language or translation setting is disabled.
        if frame.Name then runtime.restore_source(frame.Name, item.name or "") end
        if frame.Title then runtime.restore_source(frame.Title, item.title or "") end
        prepare_head(head)
        if type(head.Repaginate) == "function" then head:Repaginate() end
    end
    if ui and ui.QueueList and type(ui.QueueList.Update) == "function" then
        ui.QueueList:Update()
    end
end

playback.prepare = function ()
    local voiceover = _G.ForeverVO
    local ui = voiceover and voiceover.UI
    local quest_log = ui and ui.QuestLog
    -- ForeverVO creates the quest Play button lazily when details are opened.
    hooks.region(quest_log, "UpdateDetailsButton", function ()
        prepare_quest_log(quest_log)
    end)
    prepare_quest_log(quest_log)
    local head = ui and ui.TalkingHead
    if not head then return end
    -- Paginate a display-only proxy, then restore the actual queue identity.
    -- Present/RenderPage, pause, skip, reports and capture keep the original item.
    hooks.once("paginate", function ()
        if type(head.Paginate) ~= "function" then return false end
        local original = head.Paginate
        head.Paginate = function(self, item)
            runtime.ensure_font(self.frame and self.frame.Text)
            runtime.ensure_font(self.frame and self.frame.Measure)
            local text = text_for(item)
            if text == item.text then return original(self, item) end
            local proxy = display_items[item]
            if not proxy then
                proxy = setmetatable({}, { __index = item })
                display_items[item] = proxy
            end
            proxy.text = text
            local previous = self.pageItem
            if previous == item then self.pageItem = proxy end
            local ok, err = pcall(original, self, proxy)
            self.pageItem = ok and item or previous
            if not ok then error(err, 0) end
        end
        return true
    end)
    hooks.region(head, "CreateText", prepare_head)
    hooks.region(head, "CreateControls", prepare_head)
    hooks.region(head, "Present", prepare_head)
    prepare_head(head)
    hooks.region(head, "CloseFrame", function(self)
        if not self.displayed and self.frame then
            runtime.clear_surface(self.frame)
            head_sessions[self] = nil
        end
    end)
    hooks.region(addon_table.use("quest_ui"), "refresh_dialog_language", refresh_playback)
    if type(options.on_activity_change) == "function" then
        options.on_activity_change("forever-vo-playback", refresh_playback)
    end
    local list = ui.QueueList
    hooks.region(list, "Update", update_queue)
    if list then update_queue(list) end
end
