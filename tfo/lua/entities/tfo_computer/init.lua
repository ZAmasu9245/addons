AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
end

function ENT:AcceptInput(it, act, cal)
	if it ~= "Use" or not IsValid(act) or not act:IsPlayer() or not act:Alive() or act:GetPos():Distance(self:GetPos()) > 100 or not self:GetIsOn() or not self:GetIsDarknetLinked() then return end
	local desk = self:GetParent()
	if not IsValid(desk) then return end

	net.Start("TFO_OpenMenu")
	net.WriteInt(2, 4)

	local dataDesk = desk.stock
	dataDesk = dataDesk or {}

	net.WriteTable(dataDesk)
	net.Send(act)
end