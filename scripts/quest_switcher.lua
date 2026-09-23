local _, addon_table = ...

local quest_switcher = addon_table.use("quest_switcher")
local translation = addon_table.use("translation")

local function update_button()
    local button = quest_switcher.button
    if not button then return end

    local language = translation.get_quest_language()
    button:SetText(language == "uk" and "EN" or "UA")
    button.tooltipText = language == "uk"
        and "Показати оригінальний англійський текст"
        or "Показати український переклад"
end

local function refresh_quest_text()
    if QuestFrame then translation.refresh_quest_frame(QuestFrame) end
    update_button()
end

local function on_click()
    local language = translation.get_quest_language()
    translation.set_quest_language(language == "uk" and "en" or "uk")
    refresh_quest_text()
    if C_Timer then C_Timer.After(0, refresh_quest_text) end
end

local function on_enter(self)
    if not GameTooltip then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self.tooltipText or "")
    GameTooltip:Show()
end

local function on_leave()
    if GameTooltip then GameTooltip:Hide() end
end

quest_switcher.prepare = function ()
    if quest_switcher.button or not QuestFrame then return end

    local button = CreateFrame("Button", "UA_ForeverQuestLanguageButton", QuestFrame, "UIPanelButtonTemplate")
    button:SetSize(34, 20)
    button:SetPoint("TOPRIGHT", QuestFrame, "TOPRIGHT", -32, -28)
    button:SetFrameLevel((QuestFrame:GetFrameLevel() or 1) + 10)
    button:SetScript("OnClick", on_click)
    button:SetScript("OnEnter", on_enter)
    button:SetScript("OnLeave", on_leave)
    button:SetScript("OnShow", update_button)

    quest_switcher.button = button
    update_button()
end

quest_switcher.refresh = function ()
    quest_switcher.prepare()
    update_button()
end
