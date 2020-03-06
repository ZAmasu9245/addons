include('shared.lua')

local upColor, offColor = Color(0, 200, 0, 100), Color(200, 0, 0, 100)
local slowBlack = Color(0, 0, 0, 100)

function ENT:Think()
	if self:GetCamStatut() then
		local target = self:GetEntInSight()
		self.targetName = target and IsValid(target) and target:IsPlayer() and target:Alive() and target:Name()
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Up(), 60)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local pos2 = pos + ang:Right() * - 61.25 + ang:Up() * 5.5 + ang:Forward() * - .35

	local isUp = self:GetCamStatut()
	cam.Start3D2D(pos2, ang, .025)
		draw.RoundedBox(0, 0, 0, 160, 150, color_black)
		if isUp then
			local lang = TFO.Languages[TFO.SelectedLanguage]
			draw.DrawNonParsedText(DarkRP.textWrap(self.targetName and string.len(self.targetName) > 0 and self.targetName or lang.notarget, "Roboto_20", 155), "Roboto_20", 80, 40, color_white, 1, 1)
		end
	cam.End3D2D()

	ang:RotateAroundAxis(ang:Forward(), -35)

	pos2 = pos2 + ang:Right() * - 1.35 + ang:Up() * .3
	cam.Start3D2D(pos2, ang, .025)
		draw.RoundedBox(0, 0, 0, 160, 40, isUp and upColor or offColor)
		draw.RoundedBox(0, 2, 2, 156, 36, slowBlack)
		draw.SimpleText(isUp and "ON" or "OFF", "Roboto_40", 80, 20, color_white, 1, 1)
	cam.End3D2D()
end