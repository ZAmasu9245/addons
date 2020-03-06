include('shared.lua')

local upColor, offColor = Color(0, 120, 0, 50), Color(100, 0, 0, 200)
function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	ang:RotateAroundAxis(ang:Up(), 0)

	local pos2 = pos + ang:Right() * - 2.55 + ang:Forward() * - 6.45 + ang:Up() *  6.4
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2, ang, .1)
		local isLinked = self:GetIsLinked()
		draw.RoundedBox(0, 0, 0, 52, 50, isLinked and upColor or offColor)
		draw.SimpleText(isLinked and lang.linked or "OFF", "Roboto_20", 25, 25, color_white, 1, 1)
	cam.End3D2D()
end