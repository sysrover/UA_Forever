local _, addon_table = ...
local text = addon_table.use("guild_ui_text")
local runtime = addon_table.use("translation_runtime")
local resolver = addon_table.use("translation_resolver")
local renderer = addon_table.use("spell_template_renderer")

-- Only native UI templates enter this renderer. Captures are player data unless
-- the caller explicitly identifies a native enum or a numeric duration.
text.time = function (value)
    if type(value) ~= "string" then return value end
    local duration = addon_table.forever_surface_ui.guild.duration
    return duration and duration(value) or value
end

text.rank = function (value)
    return addon_table.forever_surface_ui.guild.rank_names[value] or value
end

text.format = function (source, keys, translate_capture)
    source = runtime.safe_string_or_nil(source)
    if not source then return nil end
    for _, key in ipairs(keys) do
        local template = runtime.safe_string_or_nil(_G[key])
        if template and renderer.matches_format(template, source) then
            local translated = resolver.find_ui(template)
            if translated and translated ~= template then
                return renderer.render_format(template, translated, source, translate_capture)
            end
        end
    end
end

text.lines = function (source)
    source = runtime.safe_string_or_nil(source)
    if not source then return nil end
    -- Officer permission lists are joined with |n by the native UI.
    local translated = (source .. "|n"):gsub("(.-)|n", function (line)
        return (resolver.find_ui(line) or line) .. "|n"
    end)
    return translated:sub(1, -3)
end

-- Guild event and bank messages append the same timestamp. Match complete
-- messages against this small source-owned set; never search all UI formats.
local log_keys = {
    "GUILDEVENT_TYPE_INVITE", "GUILDEVENT_TYPE_JOIN", "GUILDEVENT_TYPE_PROMOTE",
    "GUILDEVENT_TYPE_DEMOTE", "GUILDEVENT_TYPE_REMOVE", "GUILDEVENT_TYPE_QUIT",
    "GUILDBANK_DEPOSIT_FORMAT", "GUILDBANK_WITHDRAW_FORMAT", "GUILDBANK_MOVE_FORMAT",
    "GUILDBANK_DEPOSIT_MONEY_FORMAT", "GUILDBANK_WITHDRAW_MONEY_FORMAT",
    "GUILDBANK_REPAIR_MONEY_FORMAT", "GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT",
    "GUILDBANK_BUYTAB_MONEY_FORMAT", "GUILDBANK_UNLOCKTAB_FORMAT",
    "GUILDBANK_AWARD_MONEY_SUMMARY_FORMAT", "GUILDBANK_GUILD_RENAME_PURCHASE",
    "GUILDBANK_GUILD_RENAME_REFUND",
}

text.log_line = function (source)
    local suffix = runtime.safe_string_or_nil(_G.GUILD_BANK_LOG_TIME)
    if not suffix then return source end
    for _, key in ipairs(log_keys) do
        local template = runtime.safe_string_or_nil(_G[key])
        if template then
            for variant = 1, 2 do
                local quantity = variant == 2 and (key == "GUILDBANK_DEPOSIT_FORMAT"
                    or key == "GUILDBANK_WITHDRAW_FORMAT") and _G.GUILDBANK_LOG_QUANTITY or ""
                if variant == 1 or quantity ~= "" then
                    local english = template .. quantity .. suffix
                    if renderer.matches_format(english, source) then
                        local translated = resolver.find_ui(template) or template
                        local count = quantity ~= "" and (resolver.find_ui(quantity) or quantity) or ""
                        local time = resolver.find_ui(suffix) or suffix
                        -- The final printf argument is the native timestamp.
                        -- Preserve all preceding arguments, including custom rank names.
                        local _, total = english:gsub("%%[%d$%.%-+ #]*[sdif]", "")
                        return renderer.render_format(english, translated .. count .. time, source,
                            function (value, _, argument)
                                if argument == total then return text.time(value) end
                                if argument == 3 and (key == "GUILDEVENT_TYPE_PROMOTE"
                                    or key == "GUILDEVENT_TYPE_DEMOTE") then return text.rank(value) end
                                return value
                            end) or source
                    end
                end
            end
        end
    end
    return source
end

text.log = function (source)
    source = runtime.safe_string_or_nil(source)
    if not source then return nil end
    local translated = (source .. "|n"):gsub("(.-)|n", function (line)
        return text.log_line(line) .. "|n"
    end)
    return translated:sub(1, -3)
end
