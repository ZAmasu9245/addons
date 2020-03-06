include('shared.lua')

function ENT:IsIDCompatible()
	for k,v in pairs(TFO.ForgeriesRecipes) do
		if v.name == self:GetTFOName() and v.identity then return true end
	end
end

function ENT:Think()
	self.isNearSelling = self:IsNearSellingPoint()
	self.isID = self:IsIDCompatible()
	self:NextThink(CurTime() + 2)
	return true
end

local greenText, blackSlow, yellowBG = Color(0, 140, 0), Color(0, 0, 0, 200), Color(200, 200, 0)
function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Up(), 90)

	local pos2 = pos
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2 + ang:Up() * 7.8 + ang:Right() * - 5 + ang:Forward() * - 5.25, ang, .1)
		draw.RoundedBox(4, -12.5, 11, 130, 65, blackSlow)
		draw.SimpleText(self:GetTFOName(), "Roboto_26", 52.5, 30, color_white, 1, 1)
		draw.RoundedBox(0, 17.5, 43, 70, 1, yellowBG)
		draw.SimpleText(DarkRP.formatMoney(self:GetTFOPrice()), "Trebuchet24", 50, 60, color_white, 1, 1)

		if self.isNearSelling then
			draw.RoundedBox(4, -55, 105, 215, 23, blackSlow)
			draw.SimpleText(lang.sellingIns, "Roboto_20", 52.5, 115, color_white, 1, 1)
		elseif self.isID then
			draw.RoundedBox(4, -55, 105, 215, 23, blackSlow)
			draw.SimpleText(lang.useIns, "Roboto_20", 52.5, 115, color_white, 1, 1)			
		end
	cam.End3D2D()
end