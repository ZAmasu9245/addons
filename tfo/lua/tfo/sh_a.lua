hook.Add("DarkRPFinishedLoading", "TFO_DarkRPFinishedLoading", function()
	local plyMeta = FindMetaTable("Player")

	DarkRP.registerDarkRPVar("fakename", net.WriteString, net.ReadString)

	plyMeta.SteamName = plyMeta.SteamName or plyMeta.Name
	function plyMeta:Name()
	    if not self:IsValid() then DarkRP.error("Attempt to call Name/Nick/GetName on a non-existing player!", SERVER and 1 or 2) end
	    return self:getDarkRPVar("fakename") or GAMEMODE.Config.allowrpnames and self:getDarkRPVar("rpname") or self:SteamName()
	end
	plyMeta.GetName = plyMeta.Name
	plyMeta.Nick = plyMeta.Name

	DarkRP.declareChatCommand {
		command = "getrpname",
		description = "Get RP Name (if the player uses a fake name)",
		delay = 1.5
	}

	
	if SERVER then
		local function TFO_getrpname(ply, args)
			local args = string.Split(args, " ")
			if not args[2] or string.len(args[2]) < 2 or string.len(args[2]) > 30 then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), "<2/>30"))
				return ""
			end

			local lang = TFO.Languages[TFO.SelectedLanguage]
			local name = table.concat(args, " ", 2)
			local target = DarkRP.findPlayer(args[1])

			if not target then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", args[1]))
				return ""
			end

			if not target:getDarkRPVar("fakename") then DarkRP.notify(ply, 1, 4, lang.cmdError) return end
			DarkRP.notify(ply, 0, 4, string.format(lang.trueName, target:Name(), ply:getDarkRPVar("rpname")))
			return ""
		end
		DarkRP.defineChatCommand("getrpname", TFO_getrpname)
	end
end)