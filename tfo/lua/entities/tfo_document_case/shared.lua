ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Document case"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TFOPrice")
	self:NetworkVar("String", 0, "TFOName")
end

function ENT:IsNearSellingPoint()
	for k,v in pairs(TFO.SellPos) do
		if v:Distance(self:GetPos()) <= 256 then return true end
	end
end