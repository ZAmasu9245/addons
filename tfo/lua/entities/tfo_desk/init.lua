AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_interiors/furniture_desk01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)

	self:SetupProps()
end

function ENT:SetupProps()
	if self.computer and IsValid(self.computer) then self.computer:Remove() end
	if self.toggleButton and IsValid(self.toggleButton) then self.toggleButton:Remove() end

	self.computer = ents.Create("tfo_computer")
	self.computer:SetPos(self:GetPos() + self:GetUp() * 20 + self:GetRight() * 0 + self:GetForward() * 2)
	self.computer:SetAngles(self:GetAngles())
	self.computer:Spawn()
	self.computer:Activate()
	self.computer:SetParent(self)
	self:DeleteOnRemove(self.computer)


	self.toggleButton = ents.Create("tfo_button")
	local ang = self:GetAngles()
	self.toggleButton:SetPos(self:GetPos() + self:GetUp() * 20 + self:GetForward() * 11 + self:GetRight() * - 26)
	self.toggleButton:SetAngles(self:GetAngles())
	self.toggleButton:SetModel("models/maxofs2d/button_01.mdl")
	self.toggleButton:SetModelScale(self:GetModelScale() * .4, 0)
	self.toggleButton:Spawn()
	self.toggleButton:Activate()
	self.toggleButton:SetIsToggle(true)
	self:DeleteOnRemove(self.toggleButton)
	self.toggleButton:SetParent(self)
	self.toggleButton.OnPressed = function(ent)
		local ent = ent:GetParent()
		if not ent or not IsValid(ent) or ent ~= self then return end
		ent:SetIsOn( not self:GetIsOn() )

		if IsValid(ent.computer) then
			ent.computer:SetIsOn( self:GetIsOn() )
		end
	end
end