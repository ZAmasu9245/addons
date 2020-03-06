--[[  
    Addon: Market
    By: SlownLS
]]

-- Intialize data
hook.Add("Initialize","SlownLS:Market:Init",function()
    if !file.IsDir("slownls","DATA") then
        file.CreateDir("slownls")
    end

    if !file.IsDir("slownls/market","DATA") then
        file.CreateDir("slownls/market")
    end

    if !file.IsDir("slownls/market","DATA") then
        file.CreateDir("slownls/market")
    end
    
    if !file.IsDir("slownls/market/" .. string.lower(game.GetMap()),"DATA") then
        file.CreateDir("slownls/market/" .. string.lower(game.GetMap()))
    end

    SlownLS.Market.NPCs = {}
    SlownLS.Market.Zones = {}
    SlownLS.Market.Items = {}

    if file.Exists("slownls/market/" .. string.lower(game.GetMap()) .. "/npcs.txt","DATA") then
        SlownLS.Market.NPCs = util.JSONToTable(file.Read("slownls/market/" .. string.lower(game.GetMap()) .. "/npcs.txt","DATA") or {})
    end

    if file.Exists("slownls/market/" .. string.lower(game.GetMap()) .. "/zones.txt","DATA") then
        SlownLS.Market.Zones = util.JSONToTable(file.Read("slownls/market/" .. string.lower(game.GetMap()) .. "/zones.txt","DATA") or {})
    end

    if file.Exists("slownls/market/" .. string.lower(game.GetMap()) .. "/items.txt","DATA") then
        SlownLS.Market.Items = util.JSONToTable(file.Read("slownls/market/" .. string.lower(game.GetMap()) .. "/items.txt","DATA") or {})
    end
end)

-- NPC Functions
function SlownLS.Market:SaveNPCs()
    file.Write("slownls/market/" .. string.lower(game.GetMap()) .. "/npcs.txt",util.TableToJSON(SlownLS.Market.NPCs or {}))
end

function SlownLS.Market:SpawnNPC(strName)
    if !SlownLS.Market.NPCs[strName] then return end

    local tblInfos = SlownLS.Market.NPCs[strName] 

    local tblPos = string.Explode(" ",tblInfos.pos)
    local tblAng = string.Explode(" ",tblInfos.ang)

    local ent = ents.Create("slownls_market_npc")
        ent:SetModel(tblInfos.model)
        ent:SetPos(Vector(tblPos[1],tblPos[2],tblPos[3]))
        ent:SetAngles(Angle(tblAng[1],tblAng[2],tblAng[3]))
        ent:Spawn()
        ent:Activate()
        ent:SetNPCName(strName)

    return ent
end

function SlownLS.Market:SpawnNPCs()
    for k,v in pairs(SlownLS.Market.NPCs or {}) do
        SlownLS.Market:SpawnNPC(k)
    end
end

-- Zone Functions
function SlownLS.Market:SaveZones()
    file.Write("slownls/market/" .. string.lower(game.GetMap()) .. "/zones.txt",util.TableToJSON(SlownLS.Market.Zones or {}))
end

function SlownLS.Market:SendZones(pPlayer)
    if pPlayer && IsValid(pPlayer) then
        SlownLS.Market:SendEvent("receiveZones",SlownLS.Market.Zones,pPlayer)
        return
    end

    for k,v in pairs(player.GetAll()) do
        if !IsValid(v) then continue end
        SlownLS.Market:SendEvent("receiveZones",SlownLS.Market.Zones,v)
    end
end

-- Item Functions
function SlownLS.Market:SaveItems()
    file.Write("slownls/market/" .. string.lower(game.GetMap()) .. "/items.txt",util.TableToJSON(SlownLS.Market.Items or {}))
end

function SlownLS.Market:SpawnItem(intId)
    if !SlownLS.Market.Items[intId] then return false end

    local tblInfos = SlownLS.Market.Items[intId]
    
    local vecPos = string.Explode(" ",tblInfos.pos)
    local angPos = string.Explode(" ",tblInfos.ang)

    local ent = ents.Create("slownls_market_item")
        ent:SetModel(tblInfos.model)
        ent:SetModelScale(tblInfos.scale)
        ent:SetPos(Vector(vecPos[1],vecPos[2],vecPos[3]))
        ent:SetAngles(Angle(angPos[1],angPos[2],angPos[3]))
        ent:Spawn()
        ent:Activate()
        ent:PhysicsInit(SOLID_VPHYSICS)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
        
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then phys:EnableMotion(false) end
        
        ent:SetItemPreview(true)
        ent:SetItemID(intId)
        ent:UpdateInfos()

    return ent
end

function SlownLS.Market:SpawnItems()
    for k,v in pairs(SlownLS.Market.Items or {}) do
        SlownLS.Market:SpawnItem(k)
    end
end

-- CleanUP
hook.Add("PostCleanupMap","SlownLS:Market:CleanUP",function()
    SlownLS.Market:SpawnNPCs()
    SlownLS.Market:SpawnItems()
end)

-- InitPostEntity
hook.Add("InitPostEntity","SlownLS:Market:CleanUP",function()
    SlownLS.Market:SpawnNPCs()
    SlownLS.Market:SpawnItems()
end)

-- PlayerInitialSpawn
hook.Add("PlayerInitialSpawn","SlownLS:Market:Player:Spawn",function(pPlayer)
    timer.Simple(5,function()
        if !IsValid(pPlayer) then return end
        SlownLS.Market:SendZones(pPlayer)
    end)
end)

-- Gravity Gun Pickup
hook.Add("GravGunPickupAllowed","SlownLS:Market:Player:PickUp",function(pPlayer,ent)
    if ent:GetClass() == "slownls_market_item" && ent:GetItemPreview() then
        return false
    end
end)

-- Pocket Allowed
hook.Add("canPocket","SlownLS:Market:Player:Pocket",function(pPlayer,ent)
    if ent:GetClass() == "slownls_market_item" && ent:GetItemPreview() then
        return false
    end
end)

-- Player Say
hook.Add("PlayerSay","SlownLS:Market:Player:Say",function(pPlayer,strText)
    if strText == SlownLS.Market.Config.ConfigMenu.cmd then
        if !SlownLS.Market:IsAdmin(pPlayer) then return end

        SlownLS.Market:SendEvent('admin_menu',{},pPlayer)
        return ""
    end
end)