ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Picture"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PaperModel")
	self:NetworkVar("Int", 0, "TFOAmount")
end