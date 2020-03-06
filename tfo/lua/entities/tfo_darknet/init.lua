AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever01b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:GetClass() == "tfo_desk" and ent:GetIsOn() and not self:GetIsLinked() and IsValid(ent.computer) then
		self:SetIsLinked(true)
		ent.computer:SetIsDarknetLinked(true)
	end
end

function ENT:EndTouch(ent)
	if self:GetIsLinked() then
		self:SetIsLinked(false)
		if IsValid(ent) and IsValid(ent.computer) then
			ent.computer:SetIsDarknetLinked(false)
		end
	end
end