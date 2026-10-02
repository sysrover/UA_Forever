local _, addon_table = ...

local mail_ui = addon_table.use("mail_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local hooks = addon_table.use("translation_hooks").bind("mail_ui")

local original_mail_widths = setmetatable({}, { __mode = "k" })

local function widen_mail_region(region, extra_width)
    if not region or type(region.GetWidth) ~= "function"
        or type(region.SetWidth) ~= "function" then return end
    local width = original_mail_widths[region]
    if not width then
        local ok, measured = pcall(region.GetWidth, region)
        if not ok or type(measured) ~= "number" or measured <= 0 then return end
        width = measured
        original_mail_widths[region] = width
    end
    pcall(region.SetWidth, region, width + extra_width)
end

local function widen_mail_frame()
    local mail = _G.MailFrame
    if not mail or type(mail.GetWidth) ~= "function"
        or type(mail.SetWidth) ~= "function" then return end
    if not original_mail_widths[mail] then
        local ok, width = pcall(mail.GetWidth, mail)
        if not ok or type(width) ~= "number" or width <= 0 then return end
        original_mail_widths[mail] = width
    end
    local original_width = original_mail_widths[mail]
    local extra_width = math.floor(original_width * 1.1 + 0.5) - original_width
    widen_mail_region(mail, extra_width)
    for _, name in ipairs({
        "SendMailScrollFrame", "SendMailScrollChildFrame",
        "SendMailBodyEditBox", "SendStationeryBackgroundLeft",
        "SendMailSubjectEditBox", "SendMailHorizontalBarLeft",
        "SendMailHorizontalBarLeft2", "InboxFrameBg",
    }) do
        widen_mail_region(_G[name], extra_width)
    end
    for index = 1, 7 do
        local row = _G["MailItem" .. index]
        widen_mail_region(row, extra_width)
        if row and type(row.GetRegions) == "function" then
            local ok, _, background, divider = pcall(row.GetRegions, row)
            if ok then
                widen_mail_region(background, extra_width)
                widen_mail_region(divider, extra_width)
            end
        end
        widen_mail_region(_G["MailItem" .. index .. "Subject"], extra_width)
    end
end

local function translate_mail_region(region)
    if not region or runtime.is_applying(region) then return end
    hooks.region(region, "SetText", translate_mail_region)
    if type(region.GetText) ~= "function" then return end
    local ok, source = pcall(region.GetText, region)
    if not ok or runtime.is_secret_value(source) or type(source) ~= "string"
        or source == "" then return end
    local claim = runtime.get(region)
    if claim and source == claim.translated then source = claim.source end
    local translated, _, tier, category, _, option, provenance =
        resolver.find_ui(source, region)
    if not translated then
        -- Already-localized globals still need the shared font policy.
        strings.translate_region(region)
        return
    end
    runtime.apply(region, {
        owner = "menus", slot = "mail.ui:" .. source,
        source = source, translated = translated, category = category,
        option = option or "translate_string",
        priority = runtime.priority_for_source(tier),
        lookup_tier = tier, catalog_source = provenance and provenance.source,
        surface = registry.get("mail"), phase = "direct",
        reapply_cached = true,
    })
end

local function translate_mail_tab(tab)
    local label = tab and tab.Text
    translate_mail_region(label)
    if not label or type(label.GetUnboundedStringWidth) ~= "function"
        or type(label.SetWidth) ~= "function" then return end
    local ok, width = pcall(label.GetUnboundedStringWidth, label)
    if not ok or runtime.is_secret_value(width)
        or type(width) ~= "number" or width <= 0 then return end
    label:SetWidth(math.ceil(width + 4))
end

local function translate_mail_labels(owner, outside_input)
    if not owner or type(owner.GetRegions) ~= "function" then return end
    local ok, regions = pcall(function () return { owner:GetRegions() } end)
    if not ok then return end
    for _, region in ipairs(regions) do
        local type_ok, kind = pcall(region.GetObjectType, region)
        if type_ok and not runtime.is_secret_value(kind) and kind == "FontString" then
            local is_label = not outside_input
            if outside_input and type(region.GetPoint) == "function" then
                -- The 70124 To/Subject labels are outside their EditBox:
                -- RIGHT -> LEFT. Never translate its editable text region.
                local point_ok, point, _, relative_point = pcall(region.GetPoint, region, 1)
                is_label = point_ok and not runtime.is_secret_value(point)
                    and not runtime.is_secret_value(relative_point)
                    and point == "RIGHT" and relative_point == "LEFT"
            end
            if is_label then translate_mail_region(region) end
        end
    end
end

local function update_inbox_controls()
    widen_mail_frame()
    for _, name in ipairs({
        "OpenAllMailText", "MailFrameTitleText", "SendMailMoneyText",
        "MailFrameTrialError", "InboxTooMuchMailText",
        "SendMailSendMoneyButtonText", "SendMailCODButtonText",
        "SendMailCancelButtonText", "SendMailMailButtonText",
    }) do
        translate_mail_region(_G[name])
    end
    for index = 1, 7 do
        translate_mail_region(_G["MailItem" .. index .. "ButtonCOD"])
    end
    for _, denomination in ipairs({ "Gold", "Silver", "Copper" }) do
        local money = _G["SendMailMoney" .. denomination]
        translate_mail_region(money and money.label)
    end
    local inbox = _G.InboxFrame
    translate_mail_labels(inbox and inbox.PrevPageButton)
    translate_mail_labels(inbox and inbox.NextPageButton)
    translate_mail_labels(_G.SendMailNameEditBox, true)
    translate_mail_labels(_G.SendMailSubjectEditBox, true)
    translate_mail_labels(_G.SendMailCostMoneyFrame)
    for index = 1, 2 do
        local tab = _G["MailFrameTab" .. index]
        hooks.region(tab and tab.Text, "SetText", function ()
            translate_mail_tab(tab)
        end)
        translate_mail_tab(tab)
    end
end

local function declare_inbox_hook()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "mail.inbox.update",
        surface = "mail",
        kind = "mixin",
        target = "InboxMixin",
        method = "Update",
        blizzardAddon = "Blizzard_MailFrame",
        required = true,
        fallbackEvent = "MAIL_INBOX_UPDATE",
        verifiedBuild = 70124,
        callback = update_inbox_controls,
    })
end

mail_ui.prepare = function ()
    declare_inbox_hook()
    hooks.region_script(_G.InboxFrame, "OnShow", update_inbox_controls,
        "inbox-controls")
    hooks.region_script(_G.SendMailFrame, "OnShow", update_inbox_controls,
        "mail-controls")
    hooks.global("MailFrameTab_OnClick", update_inbox_controls)
    hooks.global("SendMailFrame_Update", update_inbox_controls)
    update_inbox_controls()
    local mail = registry.get("mail")
    if mail then
        mail.static = function ()
            update_inbox_controls()
        end
    end
end
