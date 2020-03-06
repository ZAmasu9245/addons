--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent("AddZone",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strNameZone = tblInfos.nameZone or ""
    local strNameNPC = tblInfos.nameNPC or ""
    local tblPoints = tblInfos.tblPoints or {}

    if string.len(strNameZone) < 1 then return end

    SlownLS.Market.Zones = SlownLS.Market.Zones or {}
    SlownLS.Market.NPCs = SlownLS.Market.NPCs or {}

    if SlownLS.Market.Zones[strNameZone] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('zone_name_already_taken'))
    end

    if !SlownLS.Market.NPCs[strNameNPC] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('npc_name_not_exist'))
    end

    SlownLS.Market.Zones[strNameZone] = {
        npc = strNameNPC,
        points = tblPoints
    }

    SlownLS.Market:SaveZones()
    SlownLS.Market:SendZones()
    
    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('zone_added'))
end)

SlownLS.Market:AddEvent("EditZone",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strKey = tblInfos.key
    local strName = tblInfos.name
    local strNPC = tblInfos.npc

    if !SlownLS.Market.Zones[strKey] then return end

    if string.len(strName) < 1 then return end

    if !SlownLS.Market.NPCs[strNPC] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('npc_name_not_exist'))
    end    

    if SlownLS.Market.Zones[strName] && strKey != strName then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('zone_name_already_taken'))
    end   

    SlownLS.Market.Zones[strName] = {
        npc = strNPC,
        points = SlownLS.Market.Zones[strKey].points
    }    

    if strKey != strName then
        SlownLS.Market.Zones[strKey] = nil
    end

    SlownLS.Market:SaveZones()
    SlownLS.Market:SendZones()
    
    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('zone_modified'))    
end)

SlownLS.Market:AddEvent("DeleteZone",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strKey = tblInfos.key or ""

    SlownLS.Market.Zones[strKey] = nil

    SlownLS.Market:SaveZones()
    SlownLS.Market:SendZones()
    
    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('zone_removed'))
end)