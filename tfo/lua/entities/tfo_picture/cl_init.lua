include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Up(), 90)

	local model = self:GetPaperModel()
	if model and string.len(model) > 0 and model ~= "models/error.mdl" then
		model = Material("spawnicons/" .. string.gsub(model, ".mdl", ".png"))
	end
	local pos2 = pos
	cam.Start3D2D(pos2 + ang:Up() * .275 + ang:Right() * - 7.5 + ang:Forward() * - 5.25, ang, .1)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(0, 11, 98, 130)
		surface.DrawOutlinedRect(-18, -25, 131, 200)

		if model and type(model) == "IMaterial" then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(model)
			surface.DrawTexturedRect(0, 12.5, 100, 128)
		end

		draw.RoundedBox(4, 0, 11, 98, 130, Color(0, 0, 0, 200))
		local am = self:GetTFOAmount()
		if am then
			if am > 0 then
				local lang = TFO.Languages[TFO.SelectedLanguage]
				draw.SimpleText(lang.picture, "Roboto_30", 50, -7, color_black, 1, 1)

				draw.RoundedBox(0, 12, 5, 77, 1, Color(200, 200, 0))
			end
			draw.SimpleText(am > 0 and am or 1, "Trebuchet24", 50, 155, color_black, 1, 1)
		end
	cam.End3D2D()
end