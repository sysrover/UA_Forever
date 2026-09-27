local _, addonTable = ...

local client_objects = {
    ["Dwarven Brazier"] = "дворфійська жаровня",
    ["Elevator"] = "підіймач",
    ["Fire"] = "вогонь",
    ["Firework, Show, Type 1 White"] = "феєрверк, шоу, тип 1, білий",
    ["Footprint"] = "слід",
    ["Gozwin's Mechanic's Log"] = "журнал механіка Ґозвіна",
    ["Plunger"] = "вантуз",
    ["Poor Copper Vein"] = "бідна мідна жила",
    ["Stunted Silverleaf"] = "низькоросле срібнолистя",
    ["Uther's Gnome Tribute"] = "гном’яча данина Утеру",
    ["Vator"] = "Ватор",
    ["Wilted Peacebloom"] = "зів’ялий мироцвіт",
    ["Wooden Chair"] = "дерев’яний стілець",
    ["Workshop Door"] = "двері майстерні",
}
addonTable.object = addonTable.object or {}
for english, ukrainian in pairs(client_objects) do
    if addonTable.object[english] == nil then addonTable.object[english] = ukrainian end
end
