ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Misc"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "TFOName")
	self:NetworkVar("Bool", 0, "TFOQuality")
	self:NetworkVar("Int", 0, "TFOAmount")
end