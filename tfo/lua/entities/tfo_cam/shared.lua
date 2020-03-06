ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Camera"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "CamStatut")
end

function ENT:GetEntInSight()
	local vPos = self:GetPos() + self:GetUp() * 59 + self:GetRight() * - 5 + self:GetForward() * - 5
	local trace = {}
	trace.start = vPos
	trace.endpos = vPos + self:GetRight() * - 135 + self:GetForward() * - 220
	trace.filter = self

	local tr = util.TraceLine( trace )
	if IsValid(tr.Entity) then
		return tr.Entity
	end
end