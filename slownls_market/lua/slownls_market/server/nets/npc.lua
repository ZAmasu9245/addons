--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent('npc_add',function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strName = tblInfos.name
    local strModel = tblInfos.model
    local strPos = tblInfos.pos
    local strAng = tblInfos.ang

    if SlownLS.Market.NPCs[strName] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('nameAlreadyTaken'))
    end

    local tblVec = string.Explode(" ",strPos)
    local tblAng = string.Explode(" ",strAng)

    SlownLS.Market.NPCs[strName] = {
        model = strModel,
        pos = strPos,
        ang = strAng
    }

    SlownLS.Market:SaveNPCs()

    SlownLS.Market:SpawnNPC(strName,strModel,Vector(tblVec[1],tblVec[2],tblVec[3]),Angle(tblAng[1],tblAng[2],tblAng[3]))    

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('npc_added'))
end)

SlownLS.Market:AddEvent('npc_delete',function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end

    local ent = pPlayer:GetEyeTrace().Entity 
    local boolValid = true

    if !IsValid(ent) then boolValid = false end
    if ent:GetClass() != "slownls_market_npc" then boolValid = false end

    if !boolValid then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('dontLookNPC'))
    end

    local strName = ent:GetNPCName()

    if !SlownLS.Market.NPCs[strName] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('nameInvalid'))
    end   

    SlownLS.Market.NPCs[strName] = nil     

    SlownLS.Market:SaveNPCs()

    ent:Remove()

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('npc_removed'))
end)

SlownLS.Market:AddEvent('npc_edit',function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end

    local ent = tblInfos.ent
    local strName = tblInfos.name
    local strModel = tblInfos.model

    if !IsValid(ent) then boolValid = false end
    if ent:GetClass() != "slownls_market_npc" then boolValid = false end

    local strNameOld = ent:GetNPCName()

    if SlownLS.Market.NPCs[strName] && strNameOld != strName then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('nameAlreadyTaken'))
    end   

    if strNameOld != strName then
        for k,v in pairs(SlownLS.Market.Zones or {}) do
            if v.npc == strNameOld then
                SlownLS.Market.Zones[k].npc = strName
            end
        end

        for k,v in pairs(SlownLS.Market.Items or {}) do
            if v.npc == strNameOld then
                SlownLS.Market.Items[k].npc = strName
            end
        end

        for k,v in pairs(ents.GetAll()) do
            if !IsValid(v) then continue end
            if v:GetClass() != "slownls_market_item" then continue end
            if !v:GetItemPreview() then continue end

            v:UpdateInfos()
        end

        SlownLS.Market:SaveZones()
        SlownLS.Market:SendZones()        
    end

    SlownLS.Market.NPCs[strNameOld] = nil

    SlownLS.Market.NPCs[strName] = {
        model = strModel,
        pos = tostring(ent:GetPos()) ,
        ang = tostring(ent:GetAngles()) 
    }

    SlownLS.Market:SaveNPCs()

    ent:SetNPCName(strName)
    ent:SetModel(strModel)

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('npc_modified'))
end)

SlownLS.Market:AddEvent('npc_buy',function(pPlayer,tblInfos)
    local ent = tblInfos.ent
    local tblCart = tblInfos.cart

    if !IsValid(ent) then return end
    if ent:GetClass() != "slownls_market_npc" then return end
    if ent:GetPos():Distance(pPlayer:GetPos()) > 300 then return end

    local strZone = SlownLS.Market:IsInZone(pPlayer)

    if !strZone then return end
    if !SlownLS.Market.Zones[strZone] then return end
    if ent:GetNPCName() != SlownLS.Market.Zones[strZone].npc then return end

    local tblNewCart = {}

    for k,v in SortedPairs(tblCart or {}) do
        local tbl = SlownLS.Market.Items[k]

        if !tbl then continue end
        if tbl.npc != ent:GetNPCName() then continue end
        
        tblNewCart[k] = v.amount or 0
    end

    local intPrice = 0

    for k,v in pairs(tblNewCart or {}) do
        local tbl = SlownLS.Market.Items[k]
        if !tbl then continue end

        intPrice = intPrice + (tbl.price * v)
    end

    tblCart = tblNewCart

    if table.Count(tblCart or {}) < 1 then return end

    if !pPlayer:canAfford(intPrice) then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('not_enough_money'))
    end

    pPlayer:addMoney(-intPrice)

    local entCrate = ents.Create("slownls_market_item")
    if !IsValid(entCrate) then return end
    entCrate:SetModel(SlownLS.Market.Config.CrateModel)
    entCrate:SetPos(ent:GetPos()+ent:GetForward()*50+ent:GetUp()*80)
    entCrate:SetAngles(ent:GetAngles())
    entCrate:Spawn()
    entCrate:Activate()
    entCrate:SetItemPreview(false)
    entCrate:PhysWake()
    entCrate:SetCollisionGroup(COLLISION_GROUP_WORLD)

    timer.Simple(2,function()
        if !IsValid(entCrate) then return end
        entCrate:SetCollisionGroup(0)
    end)

    entCrate.tblItems = tblCart
    entCrate:UpdateItemsCount()

    SlownLS.Market:SendEvent('npc_clear',{},pPlayer)

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('purchase_made'))
end)