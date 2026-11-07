local _, addon_table = ...
local shop = addon_table.use("shop_ui")
local ui = addon_table.use("panel_ui_adapter").bind("shop-ui")
local runtime = addon_table.use("translation_runtime")
ui.verified_build = "1.60.1.70840"

local function refresh()
    local frame = _G.CatalogShopFrame
    if not frame or not runtime.can_write_text(frame) then return end
    if type(frame.GetTitleText) == "function" then ui.watch(frame:GetTitleText()) end
    ui.hooks.region(frame, "SetTitle", function (self)
        if runtime.can_write_text(self) and type(self.GetTitleText) == "function" then ui.label(self:GetTitleText()) end
    end)
    local loading = frame.CatalogShopLoadingScreenFrame
    if loading and type(loading.GetChildren) == "function" then
        -- Loading's Text belongs to an anonymous direct child in 70840 XML.
        -- Visit only this static loading surface, not product names or prices.
        local ok, children = pcall(function () return { loading:GetChildren() } end)
        if ok then
            for _, child in ipairs(children) do ui.watch(child.Text) end
        end
        ui.hooks.region_script(loading, "OnShow", refresh)
    end
end

shop.prepare = function ()
    ui.prepare({ "CatalogShopFrame" }, "Blizzard_CatalogShop", {},
        { { "CatalogShopFrame", "ShowLoadingScreen" } }, refresh)
end
