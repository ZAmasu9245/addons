include('shared.lua')

function ENT:GetComponentString(components)
	local str = "("
	local it = self:GetItemsTable()
	if not it or it == "" then it = "{}" end
	it = util.JSONToTable(it)
	for k,v in pairs(components) do
		local am = 0
		if TFO.Ingredients[k] and it[TFO.Ingredients[k].class] and type(it[TFO.Ingredients[k].class]) == "number" then am = it[TFO.Ingredients[k].class] end
		str = str .. k .. ": " .. am .. "/" .. v .. ", "
	end
	str = string.gsub(str, "$*,", ")")
	return str
end

local upColor, offColor = Color(0, 200, 0, 100), Color(200, 0, 0, 100)
local blackBG, greyBG = Color(0, 0, 0, 100), Color(255, 255, 255, 50)
local redCant = Color(190, 0, 0)
function ENT:Draw()
	self:DrawModel()

	local ply, pos, ang = LocalPlayer(), self:GetPos(), self:GetAngles()
	local plyDist = ply:GetPos():Distance(self:GetPos())

	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or plyDist >= 256 then return end

	ang:RotateAroundAxis(ang:Forward(), 135)
	ang:RotateAroundAxis(ang:Right(), 180)

	local pos2 = pos + ang:Up() * 18.9 + ang:Forward() * 0 + ang:Right() * - 15.75
	local lang = TFO.Languages[TFO.SelectedLanguage]
	cam.Start3D2D(pos2, ang, .1)
		local isUp = self:GetFabricatorStatut()
		draw.RoundedBox(0, 0, 0, 320, 250, color_black)
		if isUp == 0 then
			draw.RoundedBox(0, 22.5, 80, 275, 40, offColor)
			draw.RoundedBox(0, 24.5, 82, 271, 36, blackBG)

			draw.SimpleText("OFF", "Roboto_40", 160, 100, color_white, 1, 1)
		elseif isUp == 1 then
			draw.SimpleText(lang.waitMat, "saxMono_23", 160, 25, color_white, 1, 1)
			draw.RoundedBox(0, 25, 37, 275, 2, greyBG)
			local n = 0
			for k,v in pairs(TFO.FabricatorItems) do
				surface.SetFont("Roboto_21")
				local txt = "⊞ " .. v.item .. " "  .. self:GetComponentString(v.components)
				local w, _ = surface.GetTextSize(txt)
				draw.DrawNonParsedText(DarkRP.textWrap(txt, "Roboto_21", 280), "Roboto_21", 25, 35 + (22.5 * k) + n * 22.5, not self:CanMakeIt(v) and redCant or color_white, 0, 1)
				for i=1,4 do
					if w > 280 * i then n = n + 1 else break end
				end
			end
		elseif isUp == 2 and TFO.FabricatorItems[self:GetSelectedCraft()] then
			local cin, craftTime = (math.sin(CurTime()) + 0.75) / 2, TFO.FabricatorItems[self:GetSelectedCraft()].time or 60
			local time = math.Clamp(math.Round(self:GetFabricatorTime() - CurTime()), 0, craftTime)
			local timerProgress, customColor = math.Clamp((CurTime() - (self:GetFabricatorTime() - craftTime)) / (CurTime() + craftTime - CurTime()), 0, 1), Color(0, cin * 255, 255 - (cin * 255))

			draw.RoundedBox(0, 0, 0, 319, 250, customColor)
			draw.RoundedBox(0, 2, 2, 315, 212, color_black)

			draw.RoundedBox(0, 22.5, 80, 275, 40, customColor)
			draw.RoundedBox(0, 24.5, 82, 271, 36, color_black)
			draw.RoundedBox(0, 22.5, 80, 275 * timerProgress, 40, customColor)
			draw.RoundedBox(0, 24.5, 82, 271, 36, blackBG)

			draw.SimpleText( string.format(lang.seconds, time), "Roboto_27", 160, 100, color_white, 1, 1)
			draw.SimpleText(lang.fabing, "saxMono_23", 160, 25, color_white, 1, 1)
			local name = TFO.FabricatorItems[self:GetSelectedCraft()].item
			draw.SimpleText(name, "Roboto_40", 160, 155, color_white, 1, 1)
		end
	cam.End3D2D()
end

function ENT:RunCrafting(n)
	if not TFO.FabricatorItems[n] then return end
	local selectedFab = TFO.FabricatorItems[n]
	if not self:CanMakeIt(selectedFab) then return end

	net.Start("TFO_LaunchFabricator")
	net.WriteInt(n, 4)
	net.WriteEntity(self)
	net.SendToServer()
end