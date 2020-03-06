--[[  
    Addon: Market
    By: SlownLS
]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item"
ENT.Category = "SlownLS | Market"
ENT.Author = "SlownLS"
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true 

function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"ItemPreview")
    self:NetworkVar("Int",0,"ItemID")
    self:NetworkVar("Int",1,"ItemPrice")
    self:NetworkVar("Int",2,"ItemType")
    self:NetworkVar("Int",3,"ItemEnergy")
    self:NetworkVar("Int",4,"ItemCount")
    self:NetworkVar("String",0,"ItemName")
    self:NetworkVar("String",1,"ItemClass")
    self:NetworkVar("String",2,"ItemNPC")
    self:NetworkVar("Vector",0,"ItemPos")
    self:NetworkVar("Angle",0,"ItemAng")
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetRenderMode(0)
        self:SetItemPreview(true)
    end

    function ENT:AcceptInput( strName, _, pCaller )
        if strName == "Use" && IsValid( pCaller ) && pCaller:IsPlayer() then
            if self:GetItemPreview() then return end

            local tblToSend = {}

            for k,v in pairs(self.tblItems or {}) do
                local tbl = SlownLS.Market.Items[k]
                if !tbl then continue end

                tblToSend[k] = {
                    name = tbl.name,
                    model = tbl.model,
                    amount = v,
                }
            end

            SlownLS.Market:SendEvent('crate_menu',{ent=self,items=tblToSend or {}},pCaller)
        end
    end        

    function ENT:UpdateInfos()
        local intId = self:GetItemID() 

        if !SlownLS.Market.Items[intId] then return end

        local tblInfos = SlownLS.Market.Items[intId]
        local vecConfigPos = string.Explode(" ",tblInfos.configPos or tostring(Vector(0,0,0)))
        local angConfigPos = string.Explode(" ",tblInfos.configAng or tostring(Angle(0,0,0)))

        self:SetItemPrice(tblInfos.price or 0)
        self:SetItemName(tblInfos.name)
        self:SetItemClass(tblInfos.class)
        self:SetItemNPC(tblInfos.npc)
        self:SetItemType(tblInfos.type)
        self:SetItemEnergy(tblInfos.energy or 0)
        self:SetItemPos(Vector(vecConfigPos[1],vecConfigPos[2],vecConfigPos[3]))
        self:SetItemAng(Angle(angConfigPos[1],angConfigPos[2],angConfigPos[3]))
    end

    function ENT:UpdateItemsCount()
        local intCount = 0
        
        for k,v in pairs(self.tblItems or {}) do
            intCount = intCount + v
        end

        self:SetItemCount(intCount)
    end
end

if ( CLIENT ) then
    local intW = 300
    local intH = 90

    function ENT:Draw()
        self:DrawModel()
        if LocalPlayer():GetPos():Distance(self:GetPos()) > 300 then return end

        if self:GetItemPreview() then 
            SlownLS.Market:PreviewModel(self)
            return 
        end

        local vecPos = self:GetPos() + self:GetUp() * (self:GetModelRadius()*1.5)
        local angPos = Angle(0,LocalPlayer():EyeAngles().y-90,90)

        cam.Start3D2D(vecPos,angPos,0.05)
            surface.SetDrawColor(Color(0,0,0,200))
            surface.DrawRect(-intW/2,-intH,intW,intH)

            surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
            surface.DrawOutlinedRect(-intW/2,-intH,intW,intH)

            draw.SimpleText(SlownLS.Market:GetLanguage('crate') .. ": " .. self:GetItemCount(),"SlownLS:Market:32",0,-intH/2,color_white,1,1)
        cam.End3D2D()
    end
end