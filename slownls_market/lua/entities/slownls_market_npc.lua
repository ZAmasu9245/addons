--[[  
    Addon: Market
    By: SlownLS
]]

AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "NPC"
ENT.Category = "SlownLS | Market"
ENT.Author = "SlownLS"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String",0,"NPCName")
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("")
        self:SetHullType( HULL_HUMAN )
        self:SetHullSizeNormal()
        self:SetNPCState( NPC_STATE_SCRIPT )
        self:SetSolid( SOLID_BBOX )
        self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
        self:SetUseType( SIMPLE_USE )
        self:DropToFloor()
    end

    function ENT:AcceptInput( strName, _, pCaller )
        if strName == "Use" && IsValid( pCaller ) && pCaller:IsPlayer() then
            SlownLS.Market:SendEvent('npc_menu',{ent=self},pCaller)
        end
    end    
end

if ( CLIENT ) then
    local intW = 300
    local intH = 50

    function ENT:Draw()
        self:DrawModel()

        if LocalPlayer():GetPos():Distance(self:GetPos()) > 300 then return end

        local vecPos = self:GetPos() + self:GetUp() * 80
        local angPos = self:GetAngles()

        angPos:RotateAroundAxis(angPos:Up(),90)
        angPos:RotateAroundAxis(angPos:Forward(),90)

        angPosFollow = Angle(angPos.p,LocalPlayer():EyeAngles().y-90,angPos.r)

        cam.Start3D2D(vecPos,angPosFollow,0.1)
            surface.SetFont("SlownLS:Market:24")
            local intTextW,intTextH = surface.GetTextSize(self:GetNPCName()) 

            local intW = intTextW + 100

            surface.SetDrawColor(Color(0,0,0,200))
            surface.DrawRect(-intW/2,0,intW,intH)

            surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
            surface.DrawOutlinedRect(-intW/2,0,intW,intH)

            draw.SimpleText(self:GetNPCName(),"SlownLS:Market:24",0,intH/2,color_white,1,1)
        cam.End3D2D()
    end
end