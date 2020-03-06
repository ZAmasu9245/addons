include('shared.lua')

local upColor, offColor = Color(0, 200, 0, 100), Color(200, 0, 0, 100)
local blackBG, blackBG2, greyBG = Color(0, 0, 0, 100), Color(0, 0, 0, 250), Color(0, 0, 0, 200)
local warnColor, warnColor2 = Color(100, 0, 0), Color(255, 0, 0)
function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 48)

	local pos2 = pos + ang:Right() * - 35.4 + ang:Up() * 35.0 + ang:Forward() * 11.8
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2, ang, .025)
		local isUp = self:GetPrinterStatut()
		local x, y = -360, 70
		draw.RoundedBox(2, -490, 0, 270, 165, blackBG2)
		if not isUp then
			local x2, y2 = x - 70, y + 10
			draw.RoundedBox(0, x2, y2, 145, 40, isUp and upColor or offColor)
			draw.RoundedBox(0, x2 + 2, y2 + 2, 141, 36, blackBG)
			draw.SimpleText(isUp and "ON" or "OFF", "Roboto_40", x2 + 70, y2 + 20, color_white, 1, 1)
		else
			draw.SimpleText(lang.menuAccess, "Roboto_27", x, y, color_white, 1, 1)
			local inkStatut = self:GetInkStatut()
			local warning = inkStatut <= 0
			y = y + 55
			draw.RoundedBox(0, x - 100, y, 200, 25, warning and warnColor or color_white)

			draw.RoundedBox(0, x - 98, y + 2, math.Clamp((inkStatut / TFO.MaxPrinterInk), .025, 1) * 196, 21, greyBG)
			draw.SimpleText(lang.ink, "Roboto_22", x - 100, y - 10, warning and warnColor2 or color_white, 0, 1)
			draw.SimpleText(self:GetInkStatut() .. "/" .. TFO.MaxPrinterInk, "Roboto_22", x + 99, y - 10, warning and warnColor2 or color_white, 2, 1)
		end
	cam.End3D2D()
end