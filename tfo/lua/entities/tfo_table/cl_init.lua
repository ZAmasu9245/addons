include('shared.lua')

local color_black100, color_black150, color_money, color_lowgrey = Color(0, 0, 0, 100), Color(0, 0, 0, 150), Color(0, 175, 0), Color(255, 255, 255, 30)
local defaultY = 10
local componentColors = { Color(0, 200, 150), Color(200, 200, 0), Color(255, 100, 0), Color(0, 0, 150) }

function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	self.selectRight = ply:GetEyeTrace().HitPos:Distance(self:GetPos() + ang:Up() * 34.8 + ang:Forward() * 18 + ang:Right() * 16) < 4
	self.selectLeft = ply:GetEyeTrace().HitPos:Distance(self:GetPos() + ang:Up() * 34.8 + ang:Forward() * 18 + ang:Right() * -13.5) < 4
	self.selectCraft = ply:GetEyeTrace().HitPos:Distance(self:GetPos() + ang:Up() * 34.8 + ang:Forward() * 12.4 + ang:Right() * 1) < 5

	ang:RotateAroundAxis(ang:Up(), 90)

	local pos2 = pos + ang:Up() * 35.2
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2, ang, .1)
		draw.RoundedBox(0, 200, -25, 225, 225, color_black100)
		draw.RoundedBox(0, 202, -23, 221, 221, color_black150)

		local statut = self:GetTableStatut()
		if statut == 0 then
			draw.RoundedBox(0, -200, 150, 375, 50, color_black100)
			draw.RoundedBox(0, -198, 152, 371, 46, color_black150)
			if self.selectRight then
				draw.RoundedBox(0, -198, 152, 75, 46, color_black150)
			elseif self.selectLeft then
				draw.RoundedBox(0, 98, 152, 75, 46, color_black150)
			end

			draw.SimpleText("→", "Arial_60", 135, 167, color_white, 1, 1)
			draw.SimpleText("←", "Arial_60", -160, 167, color_white, 1, 1)
			if self:GetSelectedPaper() and TFO.ForgeriesRecipes[self:GetSelectedPaper()] then
				local selectedPaper = TFO.ForgeriesRecipes[self:GetSelectedPaper()]
				draw.SimpleText(selectedPaper.name, "Arial_27", -15, 175, color_white, 1, 1)
			end

			if self:CanMakeIt() then
				draw.RoundedBox(0, -60, 104, 102, 42, Color(0, 0, 0, 200))
				draw.RoundedBox(0, -59, 105, 100, 40, self.selectCraft and Color(0, 125, 0, 150) or Color(0, 125, 0, 100))
				draw.SimpleText(lang.craft, "Arial_27", -10, 125, color_white, 1, 1)
			end
		elseif statut == 1 and self:GetStatutTime() then
			local time = math.Round(self:GetStatutTime() - CurTime())
			draw.RoundedBox(0, -200, 150, 375, 50, color_black100)
			draw.RoundedBox(0, -198, 152, 371, 46, color_black150)
			local timerProgress = math.Clamp((CurTime() - (self:GetStatutTime() - TFO.TableCraftTime)) / (CurTime() + TFO.TableCraftTime - CurTime()), 0, 1)
			draw.RoundedBox(0, -198, 152, 371, 46, Color(200, 125, 0, 150))
			draw.RoundedBox(0, -198, 152, 371 * timerProgress, 46, Color(230, 150, 0, 235))
			draw.SimpleText(string.format(lang.seconds, time), "Arial_27", -15, 175, color_white, 1, 1)
		end

		if self:GetSelectedPaper() and TFO.ForgeriesRecipes[self:GetSelectedPaper()] then
			local selectedPaper = TFO.ForgeriesRecipes[self:GetSelectedPaper()]
			draw.RoundedBox(0, 245, 8, 130, 2, color_white)
			if selectedPaper.components then
				draw.SimpleText(lang.components, "Roboto_30", 310, -5, color_white, 1, 1)
				local n = 0
				for k,v in pairs(selectedPaper.components) do
					n = n + 1
					draw.SimpleText(v .. "x - " .. k, "Trebuchet24", 230, defaultY + (25 * n), componentColors[n], 0, 1)
				end
			end
			draw.RoundedBox(0, 215, 130, 190, 2, color_lowgrey)
			draw.SimpleText(selectedPaper.name, "Trebuchet24", 310, 150, color_white, 1, 1)
			draw.SimpleText("~ " .. DarkRP.formatMoney(selectedPaper.sellingprice[2] - selectedPaper.sellingprice[1]), "Arial_21", 310, 175, color_money, 1, 1)
		end
	cam.End3D2D()
end