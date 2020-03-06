AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box004a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetTFOAmount(1)
	timer.Simple(.1, function()
		if not TFO.Ingredients[self:GetTFOName()] and not IsValid(self:GetParent()) then self:Remove() end
	end)
end