local _, addon_table = ...

local quest_switcher = addon_table.use("quest_switcher")
local quest_ui = addon_table.use("quest_ui")
local translation = addon_table.use("translation")
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")

local function update_button()
    local language = translation.get_quest_language()
    for _, button in pairs({ quest_switcher.button, quest_switcher.map_button }) do
        if button then
            runtime.set_fallback_text(button, language == "uk" and "EN" or "UA")
            button.tooltipText = language == "uk"
                and "Показати оригінальний англійський текст"
                or "Показати український переклад"
        end
    end
end

local function refresh_quest_text()
    quest_ui.refresh_dialog_language()
    update_button()
end

local function on_click()
    local language = translation.get_quest_language()
    translation.set_quest_language(language == "uk" and "en" or "uk")
    refresh_quest_text()
    scheduler.request("quest-switcher", nil, refresh_quest_text)
end

local function on_enter(self)
    if not GameTooltip then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    runtime.set_fallback_text(GameTooltip, self.tooltipText or "")
    GameTooltip:Show()
end

local function on_leave()
    if GameTooltip then GameTooltip:Hide() end
end

quest_switcher.prepare = function ()
    if not quest_switcher.button and _G.QuestFrame then
        local button = CreateFrame("Button", "UA_ForeverQuestLanguageButton",
            _G.QuestFrame, "UIPanelButtonTemplate")
        button:SetSize(34, 20)
        button:SetPoint("TOPRIGHT", _G.QuestFrame, "TOPRIGHT", -32, -28)
        button:SetFrameLevel((_G.QuestFrame:GetFrameLevel() or 1) + 10)
        button:SetScript("OnClick", on_click)
        button:SetScript("OnEnter", on_enter)
        button:SetScript("OnLeave", on_leave)
        button:SetScript("OnShow", update_button)
        quest_switcher.button = button
    end
    local details = _G.QuestMapFrame and _G.QuestMapFrame.DetailsFrame
    local back = details and details.BackFrame and details.BackFrame.BackButton
    if not quest_switcher.map_button and back then
        local button = CreateFrame("Button", "UA_ForeverQuestMapLanguageButton",
            details.BackFrame, "UIPanelButtonTemplate")
        button:SetSize(34, 20)
        button:SetPoint("LEFT", back, "RIGHT", 8, 0)
        button:SetFrameLevel((details.BackFrame:GetFrameLevel() or 1) + 1)
        button:SetScript("OnClick", on_click)
        button:SetScript("OnEnter", on_enter)
        button:SetScript("OnLeave", on_leave)
        button:SetScript("OnShow", update_button)
        quest_switcher.map_button = button
    end
    update_button()
end

quest_switcher.refresh = function ()
    quest_switcher.prepare()
    update_button()
end
