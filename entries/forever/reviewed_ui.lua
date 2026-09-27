local _, addonTable = ...

-- Small, explicitly reviewed bridge for generated UI entries. New reviewed
-- imports belong here instead of being merged into the generated fallback.
local reviewed = {
    ["0.0 Sec"] = "0,0 сек",
    ["1.5 Sec"] = "1,5 секунди",
    ["120 FPS"] = "120 кадрів на секунду",
    ["1920x1080"] = "1920×1080",
    ["1920x1080 (100%)"] = "1920×1080 (100 %)",
    ["30 FPS"] = "30 кадрів на секунду",
    ["60 FPS"] = "60 кадрів на секунду",
    ["Action Bar 8"] = "Панель дій 8",
    ["Bloom Intensity"] = "Інтенсивність світіння",
    ["Debuff Deadly Sting"] = "Дебаф «Смертельний укус»",
    ["Diminishing Returns (|cnRED_FONT_COLOR:Work in Progress)"] = "Зменшення прибутковості (|cnRED_FONT_COLOR:У процесі розробки)",
    ["Enable Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Functionality"] = "Увімкнути Discord |A:UI-ChatIcon-Discord:0:0:0:0|a Функціональність",
    ["Enemy Buffs, Personal Debuffs, Big Debuff"] = "Посилення ворогів, особисті ослаблення, сильне ослаблення",
    ["English Voice 1 (Masculine)"] = "Англійський голос 1 (чоловічий)",
    ["For more information see our |HurlIndex:15|hPrivacy Policy|h"] = "Докладнішу інформацію дивіться на нашому |HurlIndex:15|hPrivacy Policy|h",
    ["Large (128MB)"] = "Великий (128 МБ)",
    ["Microsoft Zira Desktop - English (United States)"] = "Microsoft Zira Desktop — англійська (США)",
    ["Mob Buffs, Personal Debuffs, Shared CC"] = "Підсилення істот, особисті послаблення та спільні ефекти контролю",
    ["Personal Buffs, Enemy Debuffs"] = "Особисті підсилення та послаблення ворогів",
    ["Rage 20"] = "Лють: 20",
    ["Say Your Rage"] = "Озвучувати запас люті",
    ["Spell Name, Spell Icon, Highlight Important Casts, Flash When Targeted By Enemy"] = "Назва заклинання, іконка заклинання, виділення важливих заклинань, миготіння, коли на вас націлюється ворог",
    ["Target casting Fireball"] = "Ціль — запуск «Вогняної кулі»",
    ["Toggle Sound"] = "Увімкнути або вимкнути звук",
    ["Triple Buffering"] = "Потрійна буферизація",
    ["Voice Chat Volume"] = "Гучність голосового чату",
}

if addonTable.forever_catalog then
    addonTable.forever_catalog.register_ui_source(
        "reviewed_ui", "reviewed_import", reviewed, 100)
else
    addonTable.forever_ui_generated_reviewed = reviewed
end
