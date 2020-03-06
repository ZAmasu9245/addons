AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetTFOAmount(2)
end

function ENT:Touch(ent)
	if not IsValid(ent) or ent:GetClass() ~= "tfo_printer" or not ent.GetInkStatut or ent:GetInkStatut() >= TFO.MaxPrinterInk or IsValid(self:GetParent()) then return end

	local am = ent:GetInkStatut() + self:GetTFOAmount()
	local max = TFO.MaxPrinterInk or 10

	self:SetTFOAmount(am > max and (am - max) or 0)
	ent:SetInkStatut(am > max and max or am)

	if self:GetTFOAmount() <= 0 then
		self:Remove()
	end
end