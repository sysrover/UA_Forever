local _, addonTable = ...

-- IDs whose existing description has the same parameter count as the
-- current client Spell.db2 description (build 1.60.1.70009).
-- The runtime also requires a matching English hint or exact static source.
addonTable.talent_description_eligible = {
    -- DRUID
    [5570] = true, [16814] = true, [16821] = true, [16833] = true, [16845] = true, [16880] = true, [16896] = true, [16909] = true, [16940] = true, [16942] = true,
    [16958] = true, [16972] = true, [16998] = true, [17002] = true, [17003] = true, [17063] = true, [17069] = true, [17074] = true, [17104] = true, [17106] = true,
    [17111] = true, [17116] = true, [17118] = true, [17245] = true, [24968] = true,
    -- HUNTER
    [19159] = true, [19168] = true, [19239] = true, [19255] = true, [19263] = true, [19290] = true, [19295] = true, [19376] = true, [19426] = true, [19461] = true,
    [19464] = true, [19498] = true, [19503] = true, [19507] = true, [19549] = true, [19559] = true, [19572] = true, [19574] = true, [19577] = true, [19578] = true,
    [19583] = true, [19596] = true, [19598] = true, [19616] = true,
    -- MAGE
    [6057] = true, [11083] = true, [11094] = true, [11100] = true, [11108] = true, [11113] = true, [11115] = true, [11124] = true, [11129] = true, [11151] = true,
    [11160] = true, [11170] = true, [11175] = true, [11189] = true, [11190] = true, [11207] = true, [11210] = true, [11222] = true, [11242] = true, [11247] = true,
    [11426] = true, [11958] = true, [12042] = true, [12472] = true, [16757] = true, [18459] = true, [18462] = true, [28574] = true, [29074] = true, [29438] = true,
    [29441] = true,
    -- PALADIN
    [9452] = true, [9453] = true, [20060] = true, [20066] = true, [20096] = true, [20101] = true, [20111] = true, [20117] = true, [20143] = true, [20189] = true,
    [20196] = true, [20205] = true, [20216] = true, [20224] = true, [20237] = true, [20257] = true, [20262] = true, [20468] = true, [26022] = true,
    -- PRIEST
    [10060] = true, [14520] = true, [14521] = true, [14524] = true, [14748] = true, [14750] = true, [14751] = true, [14889] = true, [14898] = true, [14908] = true,
    [14912] = true, [14913] = true, [15259] = true, [15260] = true, [15275] = true, [15286] = true, [15318] = true, [15407] = true, [15487] = true, [17322] = true,
    [18551] = true, [27789] = true, [27811] = true, [27900] = true,
    -- ROGUE
    [13705] = true, [13712] = true, [13713] = true, [13715] = true, [13732] = true, [13742] = true, [13743] = true, [13750] = true, [13877] = true, [13976] = true,
    [13983] = true, [14057] = true, [14079] = true, [14082] = true, [14128] = true, [14138] = true, [14156] = true, [14158] = true, [14162] = true, [14165] = true,
    [14171] = true, [14174] = true, [14177] = true, [14183] = true, [14185] = true, [14186] = true, [14983] = true, [16513] = true, [18427] = true, [30919] = true,
    -- SHAMAN
    [16035] = true, [16038] = true, [16039] = true, [16040] = true, [16043] = true, [16086] = true, [16089] = true, [16120] = true, [16173] = true, [16178] = true,
    [16181] = true, [16182] = true, [16194] = true, [16252] = true, [16254] = true, [16255] = true, [16258] = true, [16261] = true, [16262] = true, [16266] = true,
    [16578] = true, [17364] = true, [17485] = true, [28996] = true, [29187] = true, [30812] = true,
    -- WARLOCK
    [17778] = true, [17783] = true, [17810] = true, [17917] = true, [17959] = true, [18073] = true, [18119] = true, [18135] = true, [18182] = true, [18223] = true,
    [18265] = true, [18271] = true, [18288] = true, [18705] = true, [18754] = true, [18769] = true, [18827] = true, [23785] = true,
    -- WARRIOR
    [12163] = true, [12286] = true, [12290] = true, [12292] = true, [12294] = true, [12295] = true, [12297] = true, [12298] = true, [12299] = true, [12301] = true,
    [12312] = true, [12320] = true, [12323] = true, [12328] = true, [12329] = true, [12792] = true, [12809] = true, [12962] = true, [16462] = true, [16487] = true,
    [16493] = true, [16538] = true, [20500] = true, [23881] = true, [1225295] = true, [1290261] = true, [1310222] = true, [1310236] = true, [1310315] = true, [1310316] = true,
    [1310317] = true,
}
