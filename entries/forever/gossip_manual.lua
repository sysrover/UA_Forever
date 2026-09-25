local _, addonTable = ...

-- Codes copied from the in-game NPC dialogue scan. These codes take
-- precedence over the older numeric hashes in the generated catalog.
local manual = {
    [1355] = {
        ["cgislelgptadsewesetesepn"] = [===[Куховарство — справа всього життя, і я бачу, що ми поділяємо це захоплення!]===],
    },
    [1698] = {
        ["wtdoyhwt"] = [===[Чого тобі треба?]===],
    },
    [264936] = {
        ["erpeseyrftwhme"] = [===[Землепровидцю, поділися зі мною своїм даром далекоглядності.]===],
        ["oncrdyyucnensebkmnfmheisbhbladtgattesete"] = [===[Ясного дня звідси видно навіть Чорну гору. Вона водночас прекрасна й жахлива.]===],
    },
    [1229] = {
        ["tebgwsmtbeorfrnwbtweslhetokporsssp"] = [===[Великі війни поки скінчилися, та ми все одно мусимо відточувати свої навички!]===],
    },
    [1241] = {
        ["hefrtgehjtbnmytgmfbtwdbegdtathyewtcn"] = [===[Прийшов на навчання, га? Я й сам тільки почав учитися, але радо навчу тебе всього, що знаю.]===],
    },
    [1253] = {
        ["wewrtotemypeifyuaewyfmyrtsflfetortadwmyfieadpsifyeseseteyucdatmeinsets"] = [===[Ласкаво просимо, {стать:воїне:воїтелько}, до Імлистої Сосни. Якщо ти втомився з дороги, заходь, відпочинь і зігрійся. А якщо маєш трохи часу, може, допоможеш мені з кількома справами.]===],
    },
    [1694] = {
        ["wetossdt"] = [===[Ласкаво просимо до депо Сталешквара!]===],
    },
    [271546] = {
        ["lnfrtecrjtfwoflewebdctsybeteprsdtewsaenybs"] = [===[Шукаєш гінця? Щойно полетів геть, наче маленька пташка.

Не можу винуватити бідолаху. З цими вендиго кепські справи.]===],
    },
    [7955] = {
        ["emrydtkwyuttwlsymnasanadmrdrryoycnslmymstotepewoaecdedattegsifyueraerdasedtognidbehytoswyuwthetoor"] = [===[Ем... Вибач, але я тебе зовсім не знаю. Як уповноважений продавець механобігів, я можу продавати своїх скакунів лише тим, кого гноми вважають превознесеними. Якщо ти заслужиш превознесення в Гномреґані, я радо покажу тобі свій товар.]===],
    },
    [11028] = {
        ["hdtenwhh60wlbergofteaylesncnbycnmyet"] = [===[Чула, новий «Генвей 6000» скоро зійде з конвеєра. Ледве стримую захват!]===],
    },
    [1243] = {
        ["hrrtatyrse"] = [===[Геґнар Грімостріл до ваших послуг!]===],
    },
    [14724] = {
        ["teesofgnfdosinenmedessbyrglwonchrspsyucnhpusehbgmeeachpsyumthetohpusrhorssbydgtmylbeegtertadttofgseetssgttmyctbywlgschdsbttsbetept"] = [===[Ми, вигнанці Гномреґана, опинилися в ще скрутнішому становищі: запаси тканини добігають кінця! Може, допоможеш нам, га?!

Принеси мені зайві клапті тканини, щоб поповнити наші запаси. За це ти здобудеш повагу й довіру гномів усюди. Такого за гроші не купиш! Хоча тканину купиш... але це вже інша річ...]===],
    },
    [1573] = {
        ["tewrdsmtheftssbtcnteaepkgssdtehtoftegtfetknt"] = [===[У дворфів Дикого Молота, може, й прудкі скакуни, та чи витримають грифони з Орлиного піку жар Великої кузні? Гадаю, що ні!]===],
    },
    [267337] = {
        ["hwcnhpyu"] = [===[Чим можу допомогти?]===],
    },
    [5595] = {
        ["bkofie"] = [===[Банк Залізогарта]===],
        ["tebkohyemntevtnosrpetoseyrvstntevtylfditjtntofteeetoie"] = [===[Банк? А, ви про Сховище! Надійнішого місця для ваших цінностей не знайти. Воно на північний схід від входу до Залізогарта.]===],
        ["wtdoyenddsto"] = [===[Куди вам підказати дорогу?]===],
    },
    [658] = {
        ["ahwlatyusgoepsyucnatmewhtgortontmhhpadheetfrgnasadteortstowyat"] = [===[О, та ти, бачу, міцної статури! Може, допоможеш мені з однією-другою справою? Тут майже нікому допомогти, самі недосвідчені учні, а в них свої клопоти.]===],
    },
    [836] = {
        ["slteftchadlrgbtsseoftevy"] = [===[Я продаю найкращий одяг із тканини та шкіри по цей бік долини!]===],
    },
    [837] = {
        ["seteltwlwr"] = [===[Служи Світлу гідно, {стать:воїне:воїтелько}.]===],
    },
    [912] = {
        ["tebgwsmtbeorfrnwbtweslhetokporsssp"] = [===[Великі війни поки скінчилися, та ми все одно мусимо відточувати свої навички!]===],
    },
}

addonTable.gossip = addonTable.gossip or {}
for npcID, entries in pairs(manual) do
    local target = addonTable.gossip[npcID] or {}
    for code, translation in pairs(entries) do
        target[code] = translation
    end
    addonTable.gossip[npcID] = target
end
