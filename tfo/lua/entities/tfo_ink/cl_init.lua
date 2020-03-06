include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 180)

	local pos2 = pos + ang:Up() * 4.7 + ang:Right() * - 11.2 + ang:Forward() * - 5.4
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2, ang, .1)
		draw.RoundedBox(4, 30, 85, 50, 65, Color(0, 0, 0, 200))
		draw.SimpleText(lang.ink, "Roboto_30", 55, 100, color_white, 1, 1)
		draw.RoundedBox(0, 37, 112, 37, 1, Color(200, 200, 0))
		draw.SimpleText(self:GetTFOAmount() .. "L", "Trebuchet24", 56, 130, color_white, 1, 1)
	cam.End3D2D()
end