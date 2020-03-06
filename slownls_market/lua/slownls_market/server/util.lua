--[[  
    Addon: Market
    By: SlownLS
]]

function SlownLS.Market:GetNPCZone(strName)
    if !SlownLS.Market.Zones[strName] then return false end
    if !SlownLS.Market.Zones[strName].npc then return false end
    
    local strNPC = SlownLS.Market.Zones[strName].npc

    if !SlownLS.Market.NPCs[strNPC] then return false end

    return SlownLS.Market.NPCs[strNPC]
end


function SlownLS.Market:IsInZone(pPlayer)
    local bool = false 

    for k,v in pairs(SlownLS.Market.Zones or {}) do
        if SlownLS.Market:InsideZone(v.points,pPlayer:GetPos()) then
            bool = k
        end
    end

    return bool
end