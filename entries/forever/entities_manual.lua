local _, addonTable = ...

-- Server IDs observed in the in-game scan. Keep these overrides separate
-- from generated item and NPC catalogs.
local npc = {
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
}

addonTable.npc = addonTable.npc or {}
for id, entry in pairs(npc) do addonTable.npc[id] = entry end

addonTable.item = addonTable.item or {}
addonTable.item[286737] = { "перстень Авали", en="Avala's Binding" }
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
