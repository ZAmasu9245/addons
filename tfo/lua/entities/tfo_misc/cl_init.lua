include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Forward(), 90)

	local pos2 = pos
	cam.Start3D2D(pos2 + ang:Up() * 5.45 + ang:Right() * - 3.35 + ang:Forward() * - 4.3, ang, .1)
		draw.RoundedBox(4, -12.5, 11, 110, 45, Color(0, 0, 0, 200))
		draw.SimpleText(self:GetTFOName(), "Lato_20", 42.5, 30, color_white, 1, 1)
		draw.RoundedBox(0, 10, 43, 70, 1, Color(200, 200, 0))
	cam.End3D2D()
end