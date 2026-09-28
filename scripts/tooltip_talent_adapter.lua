local _, addon_table = ...

local entries = addon_table.use("entries")
local options = addon_table.use("options")
local translation = addon_table.use("translation")
local adapter = addon_table.use("tooltip_talent_adapter")
local catalog = assert(addon_table.forever_tooltip_ui,
    "UA Forever tooltip catalog is not loaded")
local format = catalog.format
local dependencies

adapter.configure = function (value)
    assert(type(value) == "table", "tooltip talent dependencies are required")
    dependencies = value
end

local function deps()
    return assert(dependencies, "tooltip talent adapter is not configured")
end

adapter.translate_quest_conditions = function (self, tooltip, condition_ids,
    _, group_ids)
    local contract = deps()
    if not self or not tooltip or type(condition_ids) ~= "table"
        or type(self.GetAndCacheCondInfo) ~= "function"
        or type(tooltip.NumLines) ~= "function"
        or not options.can_lookup("translate_quest") then return end
    local getter = translation.original
        and translation.original["C_QuestLog.GetTitleForQuestID"]
        or _G.C_QuestLog and _G.C_QuestLog.GetTitleForQuestID
    if type(getter) ~= "function" then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    if not count then return end
    local tree_name
    if type(self.GetTalentTreeID) == "function"
        and type(self.GetTraitTreeName) == "function" then
        local tree_ok, tree_id = pcall(self.GetTalentTreeID, self)
        if tree_ok then
            local name_ok, value = pcall(self.GetTraitTreeName,
                self, tree_id, group_ids)
            if name_ok then tree_name = value end
        end
    end
    for _, condition_id in ipairs(condition_ids) do
        local info_ok, info = pcall(self.GetAndCacheCondInfo,
            self, condition_id, false, tree_name)
        local id = info_ok and info and contract.safe_number(info.questID)
        if id then
            local title_ok, native = pcall(getter, id)
            native = title_ok and contract.safe_string(native) or nil
            local entry = title_ok and entries.get_entry("quest", id)
            local translated = entry and contract.make_text(entry[1], tooltip)
            if native and translated and native ~= translated then
                for index = 1, math.min(count, contract.max_lines) do
                    local current, region = contract.tooltip_line(
                        tooltip, "Left", index)
                    current = contract.safe_string(current)
                    if current and region then
                        local source = current
                        local translated_at, translated_end = source:find(
                            translated, 1, true)
                        if translated_at then
                            source = source:sub(1, translated_at - 1) .. native
                                .. source:sub(translated_end + 1)
                        end
                        local at, ending = source:find(native, 1, true)
                        if at then
                            local translated_line = source:sub(1, at - 1)
                                .. translated .. source:sub(ending + 1)
                            if not tooltip.uaForeverSessionKey then
                                contract.begin_tooltip(tooltip, "generic")
                            end
                            contract.set_translation(tooltip, region, source,
                                translated_line, "quest.name", "quest",
                                "quest-tooltip")
                            break
                        end
                    end
                end
            end
        end
    end
end

local function current_description(visible, record)
    if type(record) ~= "table" or type(record[1]) ~= "string"
        or type(record[2]) ~= "table" then return nil end
    local numbers = {}
    for value in visible:gmatch("%d[%d,%.]*") do
        numbers[#numbers + 1] = value:gsub("[%.,]+$", "")
    end
    local sequence = record[2]
    if #numbers ~= #sequence then return nil end
    local values = {}
    for index, expected in ipairs(sequence) do
        if type(expected) == "string" then
            if numbers[index] ~= expected then return nil end
        else
            values[expected] = numbers[index]
        end
    end
    local result = record[1]:gsub("{(%d+)}", function (index)
        return values[tonumber(index)] or "{" .. index .. "}"
    end)
    if result:find("{%d+}") then return nil end
    return result
end

local function points_requirement(source)
    local visible = deps().normalized_text(source)
    if not visible then return nil end
    local count, tree = visible:match(
        "^Spend ([%d,]+) more points? in (.-) Talents$")
    local names = addon_table.talent_spec_names
    local translated_tree = tree and names and names[tree]
    if not count or not translated_tree then return nil end
    local digits = count:gsub(",", "")
    local amount = tonumber(digits)
    if not amount then return nil end
    local translated = format.talent_points(count,
        catalog.points_form(amount), translated_tree)
    local color = source:match("^(|[cC]%x%x%x%x%x%x%x%x)")
    if color then
        translated = color .. translated
        if source:sub(-2) == "|r" or source:sub(-2) == "|R" then
            translated = translated .. source:sub(-2)
        end
    end
    return translated
end

adapter.translate = function (_, button, tooltip)
    local contract = deps()
    local talent_frame = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.TalentsFrame
    if not talent_frame or not button or not tooltip
        or type(button.GetTalentFrame) ~= "function"
        or type(button.GetSpellID) ~= "function" then return end
    local frame_ok, owner = pcall(button.GetTalentFrame, button)
    if not frame_ok or owner ~= talent_frame then return end
    local id_ok, id = pcall(button.GetSpellID, button)
    id = id_ok and contract.safe_number(id) or nil
    local entry = id and entries.get_entry("spell", id)
    local record = id and addon_table.talent_descriptions
        and addon_table.talent_descriptions[id]
    if not entry and not record then return end
    if not options.can_lookup("translate_spell")
        or not options.can_translate("translate_spell") then return end
    local count_ok, count = pcall(tooltip.NumLines, tooltip)
    count = count_ok and contract.safe_number(count) or nil
    if not count then return end
    local native
    if _G.C_Spell and type(_G.C_Spell.GetSpellDescription) == "function" then
        local ok, value = pcall(_G.C_Spell.GetSpellDescription, id)
        if ok then native = contract.normalized_text(value) end
    end
    local override = catalog.talent_description_overrides[id]
    contract.begin_tooltip(tooltip, "talent:" .. id)
    for index = 2, math.min(count, contract.max_lines) do
        local source, region = contract.tooltip_line(tooltip, "Left", index)
        local visible = contract.normalized_text(source)
        if region and visible and visible ~= "" then
            local translated = points_requirement(source)
            if record and ((native and visible == native)
                or (type(record[3]) == "string" and record[3] ~= ""
                    and visible:lower():find(record[3]:lower(), 1, true))) then
                translated = current_description(visible, record)
            end
            if override then
                local captures = { visible:match(override.pattern) }
                if #captures > 0 then
                    translated = override.replace(unpack(captures))
                end
            end
            if not translated and addon_table.talent_description_eligible
                and addon_table.talent_description_eligible[id]
                and entry
                and type(entry[2]) == "string"
                and entry[2]:sub(1, 1) ~= "[" then
                if entry[2]:find("#", 1, true) then
                    translated = contract.make_text(entry[2], tooltip, source)
                elseif native and visible == native then
                    translated = contract.make_text(entry[2], tooltip)
                end
            end
            if translated and translated ~= source
                and not translated:find("{%d+}")
                and not translated:find("#", 1, true) then
                contract.set_translation(tooltip, region, source,
                    translated, "spell.description:" .. index, nil,
                    "spell-tooltip")
            end
        end
    end
    contract.rewrite_generic(tooltip, count, 2)
end
