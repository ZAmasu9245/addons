include('shared.lua')

local initTime = 1
function ENT:Draw()
	self:DrawModel()
	if self:GetIsOn() then
		local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
		local plyDist = ply:GetPos():Distance(self:GetPos())

		if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 270)
		ang:RotateAroundAxis(ang:Up(), 0)

		if not self.initialized and not self.runInit then
			self.runInit = CurTime() + initTime
		end

		local pos2 = pos + ang:Right() * - 25 + ang:Forward() * - 11 + ang:Up() * 0.3
		local lang = TFO.Languages[TFO.SelectedLanguage]
		cam.Start3D2D(pos2, ang, .1)
			draw.RoundedBox(0, 0, 0, 210, 165, Color(0, 0, 0))

			if self.runInit then
				draw.SimpleText(lang.initText, "Roboto_20", 105, 50, color_white, 1, 1)

				draw.RoundedBox(0, 25, 120, 160, 20, color_white)
				local start_time = self.runInit - initTime
				local intTimer = math.Clamp( (CurTime() - start_time) / initTime, 0, 1)
				draw.RoundedBox(0, 26, 121, 158 * intTimer, 18, Color(0, 0, 0, 200))
			elseif not self:GetIsDarknetLinked() then
				draw.SimpleText(lang.waitDnet, "Roboto_20", 105, 50, color_white, 1, 1)
			elseif self:GetIsDarknetLinked() then
				draw.SimpleText(lang.dLink, "Roboto_20", 105, 60, color_white, 1, 1)
				draw.SimpleText(lang.network, "Roboto_20", 105, 75, Color(0, 200, 0), 1, 1)
				draw.SimpleText(lang.instructionC, "Roboto_20", 105, 125, color_white, 1, 1)
			end
		cam.End3D2D()
	end
end

-- only graphics stuff
function ENT:Think()
	if self:GetIsOn() then
		if not self.initialized and self.runInit then
			if self.runInit - CurTime() <= 0 then
				self.initialized = true
				self.runInit = nil
			end
		end
	elseif self.initialized or self.runInit then
		self.initialized = false
		self.runInit = nil
	end
	return true
end