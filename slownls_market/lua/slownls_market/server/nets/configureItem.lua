--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent("AddItem",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strNameEntity = tblInfos.nameEntity or ""
    local strClassEntity = tblInfos.classEntity or ""
    local intPriceEntity = tblInfos.priceEntity or 0
    local intTypeEntity = tblInfos.typeEntity or ""
    local strNPCName = tblInfos.npcName or ""
    local intEnergy = tblInfos.energy or ""
    local strModelEntity = tblInfos.modelEntity or ""
    local vecPos = tblInfos.pos or Vector(0,0,0)
    local angPos = tblInfos.ang or Angle(0,0,0)
    local vecConfigPos = tblInfos.configPos or Vector(0,0,0)
    local angConfigAng = tblInfos.configAng or Angle(0,0,0)
    local intScale = tblInfos.scale or 1

    if !tonumber(intPriceEntity) then
        intPriceEntity = 0
    end

    if string.len(strNameEntity) < 2 then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("nameInvalid"))
    end

    if string.len(strClassEntity) < 2 then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("classInvalid"))
    end

    if !SlownLS.Market.Config.Types[intTypeEntity] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("typeInvalid"))
    end

    if !SlownLS.Market.NPCs[strNPCName] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('npc_name_not_exist'))
    end     

    SlownLS.Market.Items = SlownLS.Market.Items or {}

    local intId = table.insert(SlownLS.Market.Items or {},{
        name = strNameEntity,
        model = strModelEntity,
        class = strClassEntity,
        price = intPriceEntity,
        type = intTypeEntity,
        npc = strNPCName,
        energy = intEnergy,
        pos = vecPos,
        configPos = vecConfigPos,
        configAng = angConfigAng,
        ang = angPos,
        scale = intScale
    })

    SlownLS.Market:SpawnItem(intId)
    SlownLS.Market:SaveItems()

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('item_added'))
end)

SlownLS.Market:AddEvent("EditItem",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local strNameEntity = tblInfos.nameEntity or ""
    local strClassEntity = tblInfos.classEntity or ""
    local intPriceEntity = tblInfos.priceEntity or 0
    local intTypeEntity = tblInfos.typeEntity or ""
    local strNPCName = tblInfos.npcName or ""
    local intEnergy = tblInfos.energy or 0
    local ent = tblInfos.ent or nil

    if !IsValid(ent) then return end
    if ent:GetClass() != "slownls_market_item" then return end

    if string.len(strNameEntity) < 2 then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("nameInvalid"))
    end

    if string.len(strClassEntity) < 2 then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("classInvalid"))
    end

    if !SlownLS.Market.Config.Types[intTypeEntity] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage("typeInvalid"))
    end

    if !SlownLS.Market.NPCs[strNPCName] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('npc_name_not_exist'))
    end     

    SlownLS.Market.Items = SlownLS.Market.Items or {}

    local intId = ent:GetItemID()

    SlownLS.Market.Items = SlownLS.Market.Items or {}

    if !SlownLS.Market.Items[intId] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('item_not_exist'))
    end     

    SlownLS.Market.Items[intId].name = strNameEntity
    SlownLS.Market.Items[intId].class = strClassEntity
    SlownLS.Market.Items[intId].price = intPriceEntity
    SlownLS.Market.Items[intId].type = intTypeEntity
    SlownLS.Market.Items[intId].npc = strNPCName
    SlownLS.Market.Items[intId].energy = intEnergy
    SlownLS.Market.Items[intId].pos = tostring(ent:GetPos())
    SlownLS.Market.Items[intId].ang = tostring(ent:GetAngles())

    ent:UpdateInfos()

    SlownLS.Market:SaveItems()

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('item_modified'))
end)

SlownLS.Market:AddEvent("DeleteItem",function(pPlayer,tblInfos)
    if !SlownLS.Market:IsAdmin(pPlayer) then return end
    
    local ent = tblInfos.ent or nil

    if !IsValid(ent) then return end
    if ent:GetClass() != "slownls_market_item" then return end

    local intId = ent:GetItemID()

    SlownLS.Market.Items = SlownLS.Market.Items or {}

    if !SlownLS.Market.Items[intId] then
        return DarkRP.notify(pPlayer,1,5,SlownLS.Market:GetLanguage('item_not_exist'))
    end     

    SlownLS.Market.Items[intId] = nil 

    ent:Remove()

    SlownLS.Market:SaveItems()

    DarkRP.notify(pPlayer,0,5,SlownLS.Market:GetLanguage('item_deleted'))
end)