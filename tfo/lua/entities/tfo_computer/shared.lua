ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Computer"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= false
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsOn")
	self:NetworkVar("Bool", 1, "IsDarknetLinked")
end