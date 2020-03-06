include('shared.lua')

local onColor, offColor =  Color(0, 140, 0), Color(100, 0, 0)
function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Up(), 90)

	local pos2 = pos + ang:Up() * 19.6 + ang:Forward() * 1 + ang:Right() * - 8
	cam.Start3D2D(pos2, ang, .1)
		local isOn = self:GetIsOn()
		draw.RoundedBox(0, 249, 30, 2, 165, isOn and onColor or offColor)
		draw.RoundedBox(0, -50, 30, 300, 2, isOn and onColor or offColor)
	cam.End3D2D()
end