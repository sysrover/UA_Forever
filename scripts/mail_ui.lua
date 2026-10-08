local _, addon_table = ...

local mail_ui = addon_table.use("mail_ui")
local strings = addon_table.use("strings")
local registry = addon_table.use("translation_registry")
local resolver = addon_table.use("translation_resolver")
local runtime = addon_table.use("translation_runtime")
local tooltips = addon_table.use("tooltips")
local item_db = addon_table.use("item_client_db")
local utils = addon_table.use("utils")
local delivery_headers = addon_table.forever_surface_ui.mail.item_deliveries
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
    hooks.region(region, "SetFormattedText", translate_mail_region)
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
        owner = "mail_ui", slot = "mail.ui:" .. source, section = "mail",
        source = source, translated = translated, category = category,
        option = option or "translate_string",
        priority = runtime.priority_for_source(tier),
        lookup_tier = tier, catalog_source = provenance and provenance.source,
        surface = registry.get("mail"), phase = "direct",
        reapply_cached = true,
    })
end

local open_mail_labels = {
    "OpenMailFrameTitleText", "OpenMailAttachmentText",
    "OpenMailSenderLabel", "OpenMailSubjectLabel",
    "OpenMailInvoiceItemLabel", "OpenMailInvoicePurchaser",
    "OpenMailInvoiceSalePrice", "OpenMailInvoiceDeposit",
    "OpenMailInvoiceHouseCut", "OpenMailInvoiceAmountReceived",
    "OpenMailInvoiceNotYetSent", "OpenMailInvoiceMoneyDelay",
}
local open_mail_buttons = {
    "OpenMailCancelButton", "OpenMailDeleteButton",
    "OpenMailReplyButton", "OpenMailReportSpamButton",
}

local function translate_open_mail_button(button)
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then translate_mail_region(region) end
end

local function translate_delivery_subject(mail_id, region)
    if not region or type(_G.GetInboxHeaderInfo) ~= "function" then return false end
    local ok, _, _, sender, subject = pcall(_G.GetInboxHeaderInfo, mail_id)
    if not ok or runtime.is_secret_value(sender) or runtime.is_secret_value(subject)
        or type(sender) ~= "string" or type(subject) ~= "string" then return false end
    local deliveries = delivery_headers[sender]
    local item_id = deliveries and deliveries[subject]
    if not item_id then return false end
    local translated = item_db.get_name(item_id)
    if type(translated) ~= "string" or translated == "" then return false end
    return runtime.apply(region, {
        owner = "mail-delivery", slot = "mail.subject", section = "mail",
        source = subject, translated = utils.cap(translated),
        option = "translate_string", priority = runtime.PRIORITY.DOMAIN,
        surface = registry.get("mail"), reapply_cached = true,
    })
end

local function update_inbox_row(index)
    local prefix = "MailItem" .. index
    local expire = _G[prefix .. "ExpireTime"]
    hooks.region(expire, "SetText", translate_open_mail_button)
    hooks.region(expire, "SetFormattedText", translate_open_mail_button)
    translate_open_mail_button(expire)

    -- Native Update has finished assigning the row's current mail index.
    -- Auction invoices and known deliveries own translatable header text. Do not
    -- retain SetText hooks when this row is reused for a player's letter.
    local button = _G[prefix .. "Button"]
    local mail_id = button and button.index
    if runtime.is_secret_value(mail_id) or type(mail_id) ~= "number" then return end
    if translate_delivery_subject(mail_id, _G[prefix .. "Subject"]) then return end
    if type(_G.GetInboxInvoiceInfo) ~= "function" then return end
    -- GetInboxText marks letters read. Retry missing invoice data on Update.
    local ok, invoice_type = pcall(_G.GetInboxInvoiceInfo, mail_id)
    if not ok or runtime.is_secret_value(invoice_type)
        or (invoice_type ~= "buyer" and invoice_type ~= "seller"
            and invoice_type ~= "seller_temp_invoice") then return end
    strings.translate_region(_G[prefix .. "Subject"], nil, "mail.subject",
        registry.get("mail"), nil, nil, "mail")
    strings.translate_region(_G[prefix .. "Sender"], nil, "mail.sender",
        registry.get("mail"), nil, nil, "mail")
end

local function update_open_mail_controls()
    for _, name in ipairs(open_mail_labels) do
        translate_mail_region(_G[name])
    end
    for _, name in ipairs(open_mail_buttons) do
        local button = _G[name]
        hooks.region(button, "SetText", translate_open_mail_button)
        hooks.region(button, "SetFormattedText", translate_open_mail_button)
        translate_open_mail_button(button)
    end
    -- Recognize known deliveries by headers; ordinary player text stays native.
    -- Auction sender/subject translation runs after native rendering below.
    local id = _G.InboxFrame and _G.InboxFrame.openMailID
    if id and not runtime.is_secret_value(id) and type(id) == "number"
        and translate_delivery_subject(id, _G.OpenMailSubject) then return end
    if not id or type(_G.GetInboxText) ~= "function" then return end
    local ok, _, _, _, _, invoice = pcall(_G.GetInboxText, id)
    if not ok or runtime.is_secret_value(invoice) or invoice ~= true then return end
    -- No persistent SetText hooks on these two fields: a reused mail frame
    -- can switch from an auction invoice to a player's letter.
    strings.translate_region(_G.OpenMailSubject, nil, "mail.subject",
        registry.get("mail"), nil, nil, "mail")
    local sender = _G.OpenMailSender and _G.OpenMailSender.Name
    strings.translate_region(sender, nil, "mail.sender",
        registry.get("mail"), nil, nil, "mail")
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

local function translate_open_all_button(button)
    button = button or (_G.InboxFrame and _G.InboxFrame.OpenAllMail) or _G.OpenAllMail
    if not button or type(button.GetFontString) ~= "function" then return end
    local ok, region = pcall(button.GetFontString, button)
    if ok then translate_mail_region(region) end
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
    local open_all = (_G.InboxFrame and _G.InboxFrame.OpenAllMail) or _G.OpenAllMail
    -- 70170 StartOpening/StopOpening write through Button:SetText. Native
    -- button writes need their own post-hook, even when FontString is hooked.
    hooks.region(open_all, "SetText", translate_open_all_button)
    hooks.region(open_all, "SetFormattedText", translate_open_all_button)
    translate_open_all_button(open_all)
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
        update_inbox_row(index)
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

local function translate_attachment_tooltip(owner)
    local tooltip = _G.GameTooltip
    if not owner or not tooltip or type(tooltip.IsOwned) ~= "function"
        or type(tooltips.finalize) ~= "function" then return end
    local ok, owned = pcall(tooltip.IsOwned, tooltip, owner)
    if not ok or runtime.is_secret_value(owned) or not owned then return end
    -- SendMailAttachment_OnEnter can also run through owner.UpdateTooltip.
    -- InboxFrameItem_OnEnter appends money/COD rows after item processing.
    -- Finish only after the native handler has written all of its lines.
    -- The shared finalizer preserves item ownership and original-text mode.
    tooltips.finalize(tooltip)
end

local function declare_mail_hooks()
    if type(registry.declare_hook) ~= "function" then return end
    registry.declare_hook({
        id = "mail.inbox.update",
        surface = "mail",
        kind = "frame",
        target = "InboxFrame",
        method = "Update",
        blizzardAddon = "Blizzard_MailFrame",
        required = true,
        fallbackEvent = "MAIL_INBOX_UPDATE",
        verifiedBuild = "1.60.1.70205",
        callback = update_inbox_controls,
    })
    registry.declare_hook({
        id = "mail.inbox.attachment-tooltip",
        surface = "mail",
        kind = "global",
        target = "InboxFrameItem_OnEnter",
        blizzardAddon = "Blizzard_MailFrame",
        required = true,
        verifiedBuild = "1.60.1.70205",
        callback = translate_attachment_tooltip,
    })
    registry.declare_hook({
        id = "mail.send.attachment-tooltip",
        surface = "mail",
        kind = "global",
        target = "SendMailAttachment_OnEnter",
        blizzardAddon = "Blizzard_MailFrame",
        required = true,
        verifiedBuild = "1.60.1.70205",
        callback = translate_attachment_tooltip,
    })
end

mail_ui.prepare = function ()
    declare_mail_hooks()
    hooks.region(_G.OpenMailFrame, "Update", update_open_mail_controls)
    hooks.region_script(_G.OpenMailFrame, "OnShow", update_open_mail_controls,
        "open-mail-controls")
    hooks.region_script(_G.InboxFrame, "OnShow", update_inbox_controls,
        "inbox-controls")
    hooks.region_script(_G.SendMailFrame, "OnShow", update_inbox_controls,
        "mail-controls")
    hooks.global("MailFrameTab_OnClick", update_inbox_controls)
    hooks.global("SendMailFrame_Update", update_inbox_controls)
    update_inbox_controls()
    update_open_mail_controls()
    local mail = registry.get("mail")
    if mail then
        mail.static = function ()
            update_inbox_controls()
            update_open_mail_controls()
        end
    end
end
