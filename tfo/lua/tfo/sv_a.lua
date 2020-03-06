--
util.AddNetworkString("TFO_ServerAct")
util.AddNetworkString("TFO_OpenMenu")
util.AddNetworkString("TFO_LaunchFabricator")
util.AddNetworkString("TFO_Darknet")
util.AddNetworkString("TFO_AddMarker")
util.AddNetworkString("TFO_FakePapers")
util.AddNetworkString("TFO_EjectInk")

net.Receive("TFO_ServerAct", function(l, ply)
	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
	local id = net.ReadInt(4)
	local lang = TFO.Languages[TFO.SelectedLanguage]
	if id == 1 or id == 2 then
		local data = net.ReadTable()
		if not data or not data.row or not data.t then return end

		local closestCamTbl, row, tbl = {}, data.row, data.t
		local camEnt
		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 256)) do
			if IsValid(v) and v:GetClass() == "tfo_cam" and v.dataPictures then closestCamTbl = v.dataPictures camEnt = v break end
		end

		if not IsValid(camEnt) or not camEnt.dataPictures or not closestCamTbl or table.Count(closestCamTbl) <= 0 or not closestCamTbl[row] or closestCamTbl[row].name ~= tbl.name or closestCamTbl[row].sid ~= tbl.sid or closestCamTbl[row].date ~= tbl.date then
			DarkRP.notify(ply, 1, 5, lang.camError)
			return
		end

		if id == 1 then
			table.remove(camEnt.dataPictures, row)
			DarkRP.notify(ply, 3, 5, string.format(lang.deletePic, row))
		else
			local printerEnt
			for k,v in pairs(ents.FindInSphere(ply:GetPos(), 256)) do
				if IsValid(v) and v:GetClass() == "tfo_printer" and (not printerEnt or v:GetPos():Distance(ply:GetPos()) >= printerEnt:GetPos():Distance(ply:GetPos())) then printerEnt = v break end
			end
			if not IsValid(printerEnt) or printerEnt:GetClass() ~= "tfo_printer" then return end
			if printerEnt:GetInkStatut() <= 0 then DarkRP.notify(ply, 1, 5, lang.printerEmpty) return end
			if printerEnt.page and IsValid(printerEnt.page) then DarkRP.notify(ply, 1, 5, lang.printerAct) return end
			table.remove(camEnt.dataPictures, row)
			printerEnt:LaunchPrinting(tbl, ply)
		end
	elseif id == 3 then
		local result
		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 128)) do
			if IsValid(v) and v:GetClass() == "tfo_printer" and v.GetPrinterStatut and v:GetPrinterStatut() then result = v break end
		end

		if not result then DarkRP.notify(ply, 1, 5, "You must be close to an activated printer, with enough ink.") return end
		if not result.GetInkStatut or result:GetInkStatut() <= 0 then DarkRP.notify(ply, 1, 5, "Il n'y a plus d'encre!") return end

		local amount = result:GetInkStatut()
		result:SetInkStatut(0)

		local inkPot = ents.Create("tfo_ink")
		inkPot:SetPos(result:GetPos() + result:GetUp() * 50 + result:GetRight() * 50)
		inkPot:SetAngles(result:GetAngles())
		inkPot:Spawn()
		inkPot:Activate()
		inkPot:SetTFOAmount(amount)
		inkPot:GetPhysicsObject():Wake()

		DarkRP.notify(ply, 0, 5, "The printer just dropped " .. amount .. "L of ink.")
	end
end)

local function getClosestDarknet(pl)
	local result
	for k,v in pairs(ents.FindInSphere(pl:GetPos(), 256)) do
		if IsValid(v) and v:GetClass() == "tfo_desk" and v:GetPos():Distance(pl:GetPos()) <= 256 and v:GetIsOn() and IsValid(v.computer) and v.computer:GetIsDarknetLinked() then result = v end
	end
	return result
end

net.Receive("TFO_Darknet", function(l, ply)
	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
	local isBuy, intTbl = net.ReadBool(), net.ReadInt(4)
	local itemTbl = isBuy and TFO.DarknetBuy[intTbl] or TFO.ForgeriesRecipes[intTbl]
	if not itemTbl then return end
	local ent = getClosestDarknet(ply)
	if not ent or not IsValid(ent) then return end

	local lang = TFO.Languages[TFO.SelectedLanguage]
	local ranPos = isBuy and TFO.SupplierPos[math.random(1, #TFO.SupplierPos)] or TFO.SellPos[math.random(1, #TFO.SellPos)]
	if isBuy then
		if not itemTbl.price or not ply:canAfford(itemTbl.price) then DarkRP.notify(ply, 1, 5, string.format(lang.cantAfford, DarkRP.formatMoney(itemTbl.price))) return end
		DarkRP.notify(ply, 3, 5, string.format(lang.payNotif, DarkRP.formatMoney(itemTbl.price), itemTbl.name))
		DarkRP.notify(ply, 0, 5, lang.sendNotif)
		ply:addMoney(-itemTbl.price)

		net.Start("TFO_AddMarker")
		net.WriteVector(ranPos.pos)
		net.WriteBool(isBuy)
		net.Send(ply)

		timer.Simple(60, function()
			if not IsValid(ply) or not ply:IsPlayer() then return end
			local itBuy = ents.Create(itemTbl.baseclass)
			itBuy:SetPos(ranPos.pos)
			itBuy:SetAngles(ranPos.ang)
			if itemTbl.model then itBuy:SetModel(itemTbl.model) end
			itBuy:Spawn()
			itBuy:Activate()
			itBuy:GetPhysicsObject():Wake()
			itBuy:SetTFOName(itemTbl.name)
		end)
	else
		DarkRP.notify(ply, 0, 5, lang.sellNotif)

		net.Start("TFO_AddMarker")
		net.WriteVector(ranPos)
		net.WriteBool(isBuy)
		net.Send(ply)
	end
end)

net.Receive("TFO_LaunchFabricator", function(l, ply)
	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
	local id = net.ReadInt(4)
	local ent = net.ReadEntity()
	if not ent or not IsValid(ent) or ent:GetClass() ~= "tfo_fabricator" or ent:GetPos():Distance(ply:GetPos()) > 256 or not TFO.FabricatorItems[id] or not ent.CanMakeIt or ent:GetFabricatorStatut() ~= 1 then return end
	local recipe = TFO.FabricatorItems[id]
	local lang = TFO.Languages[TFO.SelectedLanguage]
	if not ent:CanMakeIt(recipe) then DarkRP.notify(ply, 1, 5, lang.fabRes) return end
	ent:LaunchCrafting(id)
end)

net.Receive("TFO_FakePapers", function(l, ply)
	if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
	local name = net.ReadString()

	local lang = TFO.Languages[TFO.SelectedLanguage]
	if not name or string.len(name) == 0 then return end
	local sp_name = string.Split(name, " ")
	if not name or type(name) ~= "string" or string.len(name) < 4 or string.len(name) > 25 or string.len(sp_name[1]) < 3 or string.len(sp_name[2]) < 3 or ply:Name() == name or not string.match(name, "^[a-zA-ZЀ-џ0-9 ]+$") then
		DarkRP.notify(ply, 1, 5, lang.wrongName)
		return
	end

	if ply:getDarkRPVar("fakename") then DarkRP.notify(ply, 1, 5, lang.alreadyName) return end

	local result
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 256)) do
		if IsValid(v) and v:GetClass() == "tfo_document_case" and v.GetTFOName and v:GetTFOName() then result = v break end
	end
	for k,v in pairs(TFO.ForgeriesRecipes) do
		if v.name == result:GetTFOName() and v.identity then isID = v.identity break end
	end
	if not IsValid(result) or not isID then DarkRP.notify(ply, 1, 5, lang.errorNear) return end
	DarkRP.retrieveRPNames(name, function(taken)
        if taken then
            DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
            return
        end
		result:Remove()
		DarkRP.notify(ply, 3, 5, DarkRP.getPhrase("you_set_x_name", ply:Name(), name))
		ply:setDarkRPVar("fakename", name)
	end)
end)

hook.Add("GravGunPickupAllowed", "TFO_PreventGravgun", function(ply, ent)
	if IsValid(ent) and (ent:GetClass() == "tfo_picture" or ent:GetClass() == "tfo_printer") and ent.PreventGravGun then return false end
end)

local function PlayerPickup( ply, ent )
	if ( ply:IsAdmin() and ent:GetClass():lower() == "player" ) then
		return true
	end
end
hook.Add( "PhysgunPickup", "Allow Player Pickup", function(ply, ent)	
	if IsValid(ent) and (ent:GetClass() == "tfo_picture" or ent:GetClass() == "tfo_printer") and ent.PreventGravGun then return false end
end)

local physgunEntities = {"tfo_printer", "tfo_desk", "tfo_table", "tfo_fabricator"}
hook.Add("playerBoughtCustomEntity", "TFO_playerBoughtCustomEntity", function(ply, entityTable, ent, price)
	if IsValid(ply) and IsValid(ent) then
		if table.HasValue(physgunEntities, ent:GetClass()) then
			ent:CPPISetOwner(ply)
		end
	end
end)

--[[hook.Add("PlayerDeath", "changePlayerNameOnDeath", function(victim, inflicator, attacker)
	if not IsValid(victim) or not ply:getDarkRPVar("fakename") then return end

	ply:setDarkRPVar("fakename", ply:getDarkRPVar("rpname"))
end)]]--