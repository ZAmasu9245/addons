include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local pos2 = pos
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2 + ang:Up() * 6.5 + ang:Right() * - 4.5 + ang:Forward() * - 5.25, ang, .1)
		local am = self:GetTFOAmount()
		if am and am > 0 then
			draw.RoundedBox(4, 12.5, 11, 75, 65, Color(0, 0, 0, 200))
			draw.SimpleText(lang.paper, "Roboto_30", 50, 30, color_white, 1, 1)
			draw.RoundedBox(0, 20, 43, 60, 1, Color(200, 200, 0))
			draw.SimpleText(self:GetTFOAmount(), "Trebuchet24", 50, 60, color_white, 1, 1)
		end
	cam.End3D2D()
end