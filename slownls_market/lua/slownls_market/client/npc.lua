--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent('npc_menu',function(tbl)
    local ent = tbl.ent

    if !IsValid(ent) then return end

    local frame = vgui.Create("SlownLS:Market:NPC_Menu")
        frame:SetHeader(ent:GetNPCName(),60,true)
        frame:SetEntity(ent)
        frame:Load()
end)

SlownLS.Market:AddEvent('npc_clear',function(tbl)
    SlownLS.Market.Cart = {}
end)

