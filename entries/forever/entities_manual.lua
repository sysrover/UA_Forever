local _, addonTable = ...

-- Server IDs observed in the in-game scan. Keep these overrides separate
-- from generated item and NPC catalogs.
local npc = {
    [49808] = { "Ґренгільда Темнокіготь", en="Grenhild Darktalon" },
    [10956] = { "нага-сирена", en="Naga Siren" },
    [266025] = { "щур-фамільяр", en="Rat Familiar" },
    [264936] = { "землепровидець Фарсен", en="Earthseer Farsen" },
    [264937] = { "тотем Фарсена", en="Farsen's Totem" },
    [267683] = { "червоний механобіг", en="Red Mechanostrider" },
    [271530] = { "старий вендиго", en="Elder Wendigo" },
    [276003] = { "незначний крижаний елементаль", en="Minor Ice Elemental" },
    [276009] = { "Авала", en="Avala" },
    [276080] = { "горянин Вуглебород", en="Mountaineer Coalbeard" },
    [276082] = { "горянин Сонцемолот", en="Mountaineer Sunhammer" },
    [276083] = { "горянин Кам'янаковадло", en="Mountaineer Stoneanvil" },
    [276734] = { "стрімкий білий механобіг", en="Swift White Mechanostrider" },
    [276735] = { "стрімкий жовтий механобіг", en="Swift Yellow Mechanostrider" },
    [276736] = { "стрімкий зелений механобіг", en="Swift Green Mechanostrider" },
    [271587] = { "Морозне Виття", en="Frosthowl" },
    [274935] = { "захисник Залізогарта", en="Ironforge Protector" },
    [274873] = { "коваль-воїн Ваельґрім", en="Battlesmith Vaelgrim" },
    [230319] = { "Деліана", en="Deliana" },
    [260157] = { "старий сніговий леопард", en="Elder Snow Leopard" },
    [264943] = { "Афадра Данволл", en="Afadra Dunwall" },
    [265003] = { "Том Філч", en="Thom Filch" },
    [274781] = { "залізний королівський вартовий", en="Iron Kingsguard" },
    [258548] = { "Еллі Камнебров", en="Ellie Stonebrow" },
}

addonTable.npc = addonTable.npc or {}
for id, entry in pairs(npc) do addonTable.npc[id] = entry end

addonTable.item = addonTable.item or {}
addonTable.item[286737] = { "перстень Авали", en="Avala's Binding" }
if addonTable.item[2516] then
    addonTable.item[2516].tooltip_lines = {
        ["Projectile"] = "Снаряд",
        ["Bullet"] = "Куля",
    }
end
if addonTable.item[7108] then
    addonTable.item[7108].equip = 21499
end
if addonTable.item[2889] then
    addonTable.item[2889].tooltip_lines = {
        ["Beer Basted Boar Ribs"] = "Реберця кнура в пиві",
        ["Crag Boar Rib, Rhapsody Malt"] = "ребро скельного кнура, солод Рапсодія",
    }
end
if addonTable.item[961] then
    addonTable.item[961].tooltip_lines = {
        ["Use: Restores 58 health over 18 sec. Must remain seated while eating."] =
            "Використання: відновлює 58 здоров'я протягом 18 с. Під час їжі потрібно сидіти.",
    }
end
if addonTable.item[249879] then
    addonTable.item[249879].tooltip_lines = {
        ["Use: Restores 145 mana over 18 sec.  Must remain seated while drinking. If you spend at least 10 seconds eating you will become well fed and gain 2 Healing Power for 15 min. Additionally, experience gained from kills is increased by 5%. (1 Sec Cooldown)"] =
            "Використання: відновлює 145 мани протягом 18 с. Під час пиття потрібно сидіти. Якщо їсти щонайменше 10 с, ви насититеся й отримаєте +2 до сили зцілення на 15 хв. Крім того, досвід за вбивства збільшується на 5%. (Перезарядка: 1 с)",
        ["Use: Teaches you how to cook Peace Tea."] =
            "Використання: навчає готувати чай миру.",
        ["Refreshing Spring Water, Peacebloom (2)"] =
            "Освіжаюча джерельна вода, мироцвіт (2)",
    }
end
