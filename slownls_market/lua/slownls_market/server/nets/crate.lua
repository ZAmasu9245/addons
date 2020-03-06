--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market:AddEvent('crate_spawn',function(pPlayer,tblInfos)
    local ent = tblInfos.ent
    local intKey = tblInfos.key

    if !IsValid(ent) then return end
    if ent:GetClass() != "slownls_market_item" then return end
    if ent:GetPos():Distance(pPlayer:GetPos()) > 300 then return end
    if ent:GetItemPreview() then return end

    if !SlownLS.Market.Items[intKey] then return end 

    local tblInfos = SlownLS.Market.Items[intKey]

    if !ent.tblItems[intKey] then return end

    if CurTime() < (ent.SlownLS_Market_LastSpawn or 0) then
        return DarkRP.notify(pPlayer,1,5,"Wait!")
    end

    if tblInfos.type == 1 || tblInfos.type == 3 then
        local entSpawn = ents.Create(tblInfos.class)
        if !IsValid(entSpawn) then return end
        entSpawn:SetModel(tblInfos.model)
        entSpawn:SetPos(ent:GetPos()+ent:GetUp()*50)
        entSpawn:SetAngles(ent:GetAngles())
        entSpawn:Spawn()
        entSpawn:Activate()
        entSpawn:PhysWake()

        if tblInfos.type == 3 && !DarkRP.disabledDefaults["modules"]['hungermod'] then
            entSpawn:Setowning_ent( pPlayer )
            entSpawn.FoodEnergy = tblInfos.energy or 0
            for k,v in pairs( FoodItems ) do
                entSpawn.foodItem = v
            end            
        end

        if entSpawn.CPPISetOwner then
            entSpawn:CPPISetOwner(pPlayer)
        end     

        ent.SlownLS_Market_LastSpawn = CurTime() + 1
    elseif tblInfos.type == 2 then
        pPlayer:Give(tblInfos.class)
    end

    if ent.tblItems[intKey] > 1 then
        ent.tblItems[intKey] = ent.tblItems[intKey] - 1
    else
        ent.tblItems[intKey] = nil
    end

    if table.Count(ent.tblItems or {}) < 1 then
        ent:Remove()
    else
        ent:UpdateItemsCount()
    end
end)