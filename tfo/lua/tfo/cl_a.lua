--[[-------------------------------------------------------------------------
Font
---------------------------------------------------------------------------]]
surface.CreateFont("Roboto_40", { size = 40, weight = 500, font = "Roboto"})
surface.CreateFont("Roboto_30", { size = 30, weight = 500, font = "Roboto"})
surface.CreateFont("Roboto_27", { size = 27, weight = 300, antialias = true, font = "Roboto"})
surface.CreateFont("Roboto_26", { size = 26, weight = 300, antialias = true, font = "Roboto"})
surface.CreateFont("Roboto_22", { size = 22, weight = 500, font = "Roboto"})
surface.CreateFont("Roboto_21", { size = 21, weight = 300, antialias = true, font = "Roboto"})
surface.CreateFont("Roboto_20", { size = 20, weight = 500, font = "Roboto"})
surface.CreateFont("Roboto_18", { size = 18, weight = 500, font = "Roboto"})

surface.CreateFont("Lato_20", { size = 20, weight = 500, font = "Lato"})
surface.CreateFont("Lato_16", { size = 16, weight = 500, font = "Lato"})

surface.CreateFont("saxMono_23", { size = 23, weight = 300, antialias = true, font = "saxMono"})
surface.CreateFont("saxMono_35", { size = 35, weight = 300, antialias = true, font = "saxMono"})
surface.CreateFont("saxMono_55", { size = 55, weight = 500, antialias = true, font = "saxMono"})

surface.CreateFont("Arial_60", { size = 60, weight = 500, antialias = true, font = "Arial"})
surface.CreateFont("Arial_27", { size = 27, weight = 500, antialias = true, font = "Arial"})
surface.CreateFont("Arial_21", { size = 21, weight = 500, antialias = true, font = "Arial"})
--[[-------------------------------------------------------------------------
Local var
---------------------------------------------------------------------------]]
local blackBG, blackBG2 = Color(100, 100, 100), Color(40, 40, 40)
local redBG, slowBG = Color(150, 0, 0), Color(50, 50, 50, 100)
local blueBG1, blueBG2 = Color(50, 90, 100, 125), Color(60, 100, 50, 125)
local greenBG1, greenBG2 = Color(50, 90, 100, 75), Color(60, 100, 50, 75)
local whiteLow, slowGrey2 = Color(180, 180, 180), Color(120, 120, 120)
local fabricatorUI, printerUI = Material("pichot/tfo/fabricator_ui"), Material("pichot/tfo/printer_wallpaper.png")
local whiteBGLow = Color(255, 255, 255, 100)
local craftCol, hoveredCol = Color(140, 0, 0), Color(175, 175, 175)
local warnColor, warnColor2, greyBG = Color(120, 0, 0), Color(255, 0, 0), Color(0, 0, 0, 225)
local colorp1, colorp2, colorp3 = Color(130, 130, 130), Color(140, 140, 140), Color(75, 75, 75)
local niceBlue, bBlue01, bBlue02 = Color(0, 100, 255), Color(0, 60, 225), Color(0, 80, 200)
--[[-------------------------------------------------------------------------
End
---------------------------------------------------------------------------]]
local function TFO_ComputerMenu(data)
	data = data or {}

	local lang = TFO.Languages[TFO.SelectedLanguage]
	local baseFrame = vgui.Create("DFrame")
	baseFrame:SetSize(600, 600)
	baseFrame:Center()
	baseFrame:SetTitle("")
	baseFrame:MakePopup()
	baseFrame.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		draw.RoundedBox(8, 0, 0, w, h, blackBG)
		draw.RoundedBox(8, 20, 20, w - 40, h - 40, color_black)
		draw.SimpleText("Darknet", "saxMono_55", 40, 47, color_white, 0, 1)
	end

	local checkboxBuy = vgui.Create("DCheckBoxLabel", baseFrame)
	checkboxBuy:SetPos(baseFrame:GetWide() - 90, baseFrame:GetTall() - 45)
	checkboxBuy:SetText(lang.buyingButton)
	checkboxBuy:SetValue(1)
	checkboxBuy:SizeToContents()

	local checkboxSell = vgui.Create("DCheckBoxLabel", baseFrame)
	checkboxSell:SetPos(baseFrame:GetWide() - 160, baseFrame:GetTall() - 45)
	checkboxSell:SetText(lang.sellingButton)
	checkboxSell:SetValue(0)
	checkboxSell:SizeToContents()

	local closeButton = vgui.Create("DButton", baseFrame)
	closeButton:SetSize(40, 40)
	closeButton:SetPos(baseFrame:GetWide() - closeButton:GetWide() - 30, closeButton:GetTall() - 10)
	closeButton:SetText("")
	closeButton.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, redBG)
		draw.SimpleText("x", "saxMono_55", w/2, h/2 - 7, color_white, 1, 1)
	end
	closeButton.DoClick = function()
		if IsValid(baseFrame) then baseFrame:Remove() end
	end

	local listPanel = vgui.Create("DScrollPanel", baseFrame)
	listPanel:SetSize(baseFrame:GetWide() - 70, baseFrame:GetTall() - 135)
	listPanel:SetPos(35, 80)
	listPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, slowBG)
	end

	local layoutPanel = vgui.Create("DIconLayout", listPanel)
	layoutPanel:SetSize(listPanel:GetWide(), listPanel:GetTall())
	layoutPanel:SetPos(4, 4)
	layoutPanel:SetSpaceX(4)
	layoutPanel:SetSpaceY(4)
	layoutPanel.makeCard = function(self, k, col)
		local v = col and TFO.DarknetBuy[k] or TFO.ForgeriesRecipes[k]
		local panelBase = layoutPanel:Add("DButton")
		panelBase:SetSize(panelBase:GetParent():GetWide() / 2 - 6, 65)
		panelBase:SetText("")
		local price = col and DarkRP.formatMoney(v.price) or "~" .. DarkRP.formatMoney(v.sellingprice[2] - v.sellingprice[1])
		panelBase.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, self.Hovered and (col and blueBG1 or blueBG2) or (col and greenBG1 or greenBG2))
			draw.SimpleText(v.name, "Lato_20", 60, h/2, color_white, 0, 1)
			draw.SimpleText(price, "Lato_16", w - 10, h/2, color_white, 2, 1)
		end
		panelBase.DoClick = function()
			net.Start("TFO_Darknet")
			net.WriteBool(col)
			net.WriteInt(k, 4)
			net.SendToServer()
			baseFrame:Remove()
		end

		local spawnIconBase = vgui.Create("SpawnIcon", panelBase)
		spawnIconBase:SetPos(4, 8)
		spawnIconBase:SetSize(spawnIconBase:GetParent():GetTall() - 16, spawnIconBase:GetParent():GetTall() - 16)
		spawnIconBase:SetModel(v.model or "models/props_junk/cardboard_box004a.mdl")
		spawnIconBase:SetToolTip("")
		spawnIconBase:SetMouseInputEnabled(false)
	end
	layoutPanel.fill = function()
		layoutPanel:Clear()
		if checkboxSell:GetChecked() then
			for k,v in pairs(TFO.ForgeriesRecipes) do
				layoutPanel.makeCard(layoutPanel, k, false)
			end
		end
		if checkboxBuy:GetChecked() then
			for k,v in pairs(TFO.DarknetBuy) do
				layoutPanel.makeCard(layoutPanel, k, true)
			end
		end
	end
	layoutPanel.fill()

	baseFrame:ShowCloseButton(false)

	checkboxSell.OnChange = function() layoutPanel.fill() end
	checkboxBuy.OnChange = function() layoutPanel.fill() end
end

local function TFO_PrinterMenu(data)
	local printer = LocalPlayer():GetEyeTrace().Entity
	if not printer or not IsValid(printer) or printer:GetClass() ~= "tfo_printer" then return end

	local inkStatut, inkMax = printer:GetInkStatut(), TFO.MaxPrinterInk
	data = data or {}

	local lang = TFO.Languages[TFO.SelectedLanguage]
	local baseFrame = vgui.Create("DFrame")
	baseFrame:SetSize(800, 600)
	baseFrame:Center()
	baseFrame:SetTitle("")
	baseFrame:MakePopup()
	baseFrame.Think = function()
		if not IsValid(printer) or printer:GetClass() ~= "tfo_printer" or not printer:GetPrinterStatut() then baseFrame:Remove() return end
		inkStatut = printer:GetInkStatut()
	end
	baseFrame.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, colorp3)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, blackBG2)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(printerUI)
		surface.DrawTexturedRect(20, 20, w - 40, h - 40)

		draw.RoundedBox(1, 40, h - 115, w - 80, 75, color_white)
		draw.RoundedBox(1, 40, h - 135, w - 80, 20, niceBlue)
		draw.SimpleText("► TOOLS AND INFORMATION", "Lato_16", 45, h - 125, color_white, 0, 1)

		local warning = inkStatut <= 0
		draw.SimpleText("Ink", "Roboto_20", 255, h - 83, warning and warnColor or color_black, 0, 1)
		draw.SimpleText(inkStatut .. "/" .. inkMax, "Roboto_20", w - 50, h - 83, warning and warnColor or color_black, 2, 1)
		draw.RoundedBox(0, 255, h - 73, 495, 26, warning and warnColor or colorp2)
		draw.RoundedBox(0, 257, h - 71, math.Clamp((inkStatut / inkMax), .015, 1) * 495, 22, greyBG)
	end

	local theButton = vgui.Create("DButton", baseFrame)
	theButton:SetSize(200, 30)
	theButton:SetPos(45, baseFrame:GetTall() - 110)
	theButton:SetText("")
	theButton.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, self.Hovered and bBlue01 or bBlue02)
		draw.SimpleText("Eject Ink", "Roboto_18", w/2, h/2, color_white, 1, 1)
	end
	theButton.DoClick = function()
		if IsValid(baseFrame) then baseFrame:Remove() end
		net.Start("TFO_ServerAct")
		net.WriteInt(3, 4)
		net.SendToServer()
	end

	local theButton = vgui.Create("DButton", baseFrame)
	theButton:SetSize(200, 30)
	theButton:SetPos(45, baseFrame:GetTall() - 75)
	theButton:SetText("")
	theButton.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, self.Hovered and bBlue01 or bBlue02)
		draw.SimpleText("Disconnect", "Roboto_18", w/2, h/2, color_white, 1, 1)
	end
	theButton.DoClick = function()
		if IsValid(baseFrame) then baseFrame:Remove() end
	end

	local printPanel = vgui.Create("DPanel", baseFrame)
	printPanel:SetSize(baseFrame:GetWide() - 80, 415)
	printPanel:SetPos(40, 35)
	printPanel.Paint = function(self, w, h)
		draw.RoundedBox(1, 0, 0, w, h, color_white)
		draw.RoundedBox(1, 0, 0, w, 20, niceBlue)
		draw.SimpleText("► PRINTER", "Lato_16", 5, 10, color_white, 0, 1)
	end

	local listPictures = vgui.Create("DListView", printPanel)
	listPictures:SetSize(printPanel:GetWide() - 20, printPanel:GetTall() - 40)
	listPictures:SetPos(10, 30)
	listPictures:SetMultiSelect(false)
	listPictures:AddColumn(lang.modelName)
	listPictures:AddColumn(lang.date)
	for k,v in pairs(data) do
		if v.name and v.date then
			listPictures:AddLine(v.name, os.date("%d/%m - %H:%M", v.date), v.date, v.modelData)
		end
	end

	if table.Count(data) <= 0 then
		listPictures.PaintOver = function(self, w, h)
			draw.SimpleText(lang.noPics, "Trebuchet24", w/2, h/2, color_black, 1, 1)
		end
	end

	listPictures.OnRowRightClick = function(self, row)
		local menu = DermaMenu()
		local tbl = { name = listPictures:GetLine(row):GetValue(1), date = listPictures:GetLine(row):GetValue(3), modelData = listPictures:GetLine(row):GetValue(4) }
		menu:AddOption(lang.printt, function() net.Start("TFO_ServerAct") net.WriteInt(2, 4) net.WriteTable({ row = row, t = tbl }) net.SendToServer() if IsValid(baseFrame) then baseFrame:Remove() end end):SetIcon("icon16/printer.png")
		menu:AddOption(lang.delete, function() net.Start("TFO_ServerAct") net.WriteInt(1, 4) net.WriteTable({ row = row, t = tbl }) net.SendToServer() if IsValid(baseFrame) then baseFrame:Remove() end end):SetIcon("icon16/cross.png")
		menu:Open()
	end
	baseFrame:ShowCloseButton(false)
end

local function niceScrollbar(panel, diff)
	diff = diff or 0
	panel.VBar.btnUp.Paint = function(self,w,h)
		draw.RoundedBox(0, w*.5-(w/3.5/2) + 5 - diff, 0, w/3.5, h, blackBG)
	end
	panel.VBar.btnDown.Paint = function(self,w,h)
		draw.RoundedBox(0, w*.5-(w/3.5/2) + 5 - diff, 0, w/3.5, h, blackBG)
	end
	panel.VBar.btnGrip.Paint = function(self,w,h)
		draw.RoundedBox(0, w*.5-(w/3.5/2) + 5 - diff, 0, w/3.5, h, whiteLow)
	end
	panel.VBar.Paint = function(self,w,h)
		draw.RoundedBox(0, w*.5-(w/3.5/2) + 5 - diff, 16, w/3.5, h-32, blackBG)
	end
end

local baseFrame
local function TFO_Fabricator(ent)
	if IsValid(baseFrame) then baseFrame:Remove() end
	if not ent or not IsValid(ent) or ent:GetClass() ~= "tfo_fabricator" or not ent.GetComponentString then return end

	local lang = TFO.Languages[TFO.SelectedLanguage]

	LocalPlayer():ScreenFade( SCREENFADE.IN, Color(0, 0, 0, 225), 1, 0 )
	baseFrame = vgui.Create("DFrame")
	baseFrame:SetSize(ScrW(), ScrH())
	baseFrame:SetPos(-ScrW(), 0)
	baseFrame:SetTitle("")
	baseFrame:MakePopup()
	baseFrame.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )

		surface.SetDrawColor(color_white)
		surface.SetMaterial(fabricatorUI)
		surface.DrawTexturedRect(0, 0, w + 179, h)
	end
	baseFrame:MoveTo(0, 0, .3, 0, -1, function()
		if IsValid(baseFrame) then baseFrame:Center() end
	end)

	local x, y = baseFrame:GetWide(), baseFrame:GetTall()
	local panelBase = vgui.Create("DPanel", baseFrame)
	panelBase:SetSize(x * .465, y * .57)
	panelBase:SetPos(x/2 - panelBase:GetWide()/2, 50)
	panelBase.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_black)
		draw.SimpleText(lang.waitMat, "saxMono_55", w/2, 30, color_white, 1, 1)
		draw.RoundedBox(0, w/2 - ((w * .8)/2), 55, w * .8, 2, whiteBGLow)
	end

	local closeButton = vgui.Create("DButton", panelBase)
	closeButton:SetSize(40, 40)
	closeButton:SetPos(panelBase:GetWide() - closeButton:GetWide() - 10, closeButton:GetTall() - 30)
	closeButton:SetText("")
	closeButton.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, redBG)
		draw.SimpleText("x", "saxMono_55", w/2, h/2 - 7, color_white, 1, 1)
	end
	closeButton.DoClick = function()
		local posX, posY = baseFrame:GetPos()
		baseFrame:MoveTo(-ScrW(), 0, .3, 0, -1, function()
			LocalPlayer():ScreenFade( SCREENFADE.IN, Color(0, 0, 0, 225), 1, 0 )
			if IsValid(baseFrame) then baseFrame:Remove() end
		end)
	end

	local helpList = vgui.Create("DPanelList", panelBase)
	helpList:SetSize(panelBase:GetWide() - 20, panelBase:GetTall() - 125)
	helpList:SetPos(40, 75)
	helpList:EnableVerticalScrollbar(true)
	niceScrollbar(helpList, 5)
	for k,v in pairs(TFO.FabricatorItems) do
		local canCraft = ent:CanMakeIt(v)
		local text = "⊞ " .. v.item .. " "  .. ent:GetComponentString(v.components)
		local button = vgui.Create("DButton", helpList)
		button:SetSize(panelBase:GetWide(), 50)
		button:SetText("")
		button:SetDisabled(not canCraft)
		button.Paint = function(self, w, h)
			local font = "Roboto_40"
			surface.SetFont(font)
			local w, h = surface.GetTextSize(text)
			if w > panelBase:GetWide() then
				font = "Roboto_30"
			end
			draw.SimpleText(text, font, 5, h/2, not canCraft and craftCol or self.Hovered and hoveredCol or color_white, 0, 1)
		end
		button.DoClick = function()
			if not canCraft then return end
			ent:RunCrafting(k)
			baseFrame:Remove()
		end
		helpList:AddItem(button)
	end
	baseFrame.Think = function() if not IsValid(ent) or not ent.GetFabricatorStatut or ent:GetFabricatorStatut() == 0 then baseFrame:Remove() end end
	baseFrame:ShowCloseButton(false)
end

local function TFO_IDCard()
	local lang = TFO.Languages[TFO.SelectedLanguage]

	local baseID = vgui.Create("DFrame")
	baseID:SetSize(400, 175)
	baseID:Center()
	baseID:SetTitle(lang.fakeTitle)
	baseID:MakePopup()
	baseID:SetBackgroundBlur(true)
	baseID.PaintOver = function(self, w, h)
		draw.DrawNonParsedText(DarkRP.textWrap(lang.textFake, "DermaDefaultBold", 385), "DermaDefaultBold", 10, 30, color_white, 0, 0)		
	end

	local entryName = vgui.Create("DTextEntry", baseID)
	entryName:SetPos(10, 100)
	entryName:SetSize(380, 30)
	entryName:SetText("John Doe")

	local buttonValid = vgui.Create("DButton", baseID)
	buttonValid:SetText(lang.send)
	buttonValid:SetPos(10, 135)
	buttonValid:SetSize(187.5, 30)
	buttonValid.DoClick = function()
		local text = entryName:GetValue()
		if not text or string.len(text) == 0 then return end
		if IsValid(baseID) then baseID:Remove() end
		net.Start("TFO_FakePapers")
		net.WriteString(text)
		net.SendToServer()
	end

	local buttonCancel = vgui.Create("DButton", baseID)
	buttonCancel:SetText(lang.cancel)
	buttonCancel:SetPos(202.5, 135)
	buttonCancel:SetSize(187.5, 30)
	buttonCancel.DoClick = function() if IsValid(baseID) then baseID:Remove() end end
end

local funcTbl = {
	[1] = function(t) TFO_PrinterMenu(t) end,
	[2] = function(t) TFO_ComputerMenu(t) end,
	[3] = function(t) TFO_Fabricator(t) end,
	[4] = function() TFO_IDCard() end,
}

net.Receive("TFO_OpenMenu", function()
	local id, data = net.ReadInt(4)
	if not funcTbl[id] or type(funcTbl[id]) ~= "function" then return end
	if id == 1 then
		data = net.ReadTable()
		data = data or {}
	elseif id == 3 then
		data = net.ReadEntity()
	end

	funcTbl[id](data)
end)

local activeBlips = {}
local matBuy, matSell = Material("icon16/cart_put.png"), Material("icon16/box.png")
net.Receive("TFO_AddMarker", function()
	local ranPos = net.ReadVector()
	local isBuy = net.ReadBool()
	table.insert(activeBlips, { pos = ranPos, icon = isBuy and matBuy or matSell, created = CurTime() })
	timer.Simple(120, function() if activeBlips[1] and CurTime() - activeBlips[1].created > 110 then table.remove(activeBlips, 1) end end)
end)

hook.Add( "HUDPaint", "TFO_HUDMarkers", function()
	local ply = LocalPlayer()
	if IsValid(ply) and ply:Alive() then
		for k,v in pairs(activeBlips) do
			local gpos = v.pos + Vector(0, 0, 50)
			local dist = math.Round(ply:GetPos():Distance(gpos))
			if dist <= 128 then table.remove(activeBlips, k) break end

			local vpos = gpos:ToScreen()
			surface.SetDrawColor(color_white)
			surface.SetMaterial(v.icon)
			surface.DrawTexturedRect( vpos.x + 2.5, vpos.y, 28, 28 )

			draw.SimpleText((dist - 50) .. "m", "Lato_16", vpos.x + 15, vpos.y + 30, color_white, 1)
		end
	end
end )