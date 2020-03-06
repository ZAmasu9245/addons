--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent('crate_menu',function(tbl)
    local ent = tbl.ent
    local tblItems = tbl.items

    if !IsValid(ent) then return end

    local frame = vgui.Create("SlownLS:Market:Crate_Menu")
        frame:SetHeader(SlownLS.Market:GetLanguage('crate'),60,true)
        frame:SetEntity(ent)
        frame:Load(tblItems)
end)
