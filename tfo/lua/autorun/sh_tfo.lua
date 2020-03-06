TFO = {}
TFO.Languages = {}

if CLIENT then
	local files = file.Find( "tfo/*", "LUA" )
	for _,v in pairs(files) do
		if string.StartWith(v,"cl_") then
			include("tfo/" .. v)
			if TFO.Debug then
				MsgC(Color(0,255,0), "[TFO] Client files: " .. v .. " \n")
			end
		elseif string.StartWith(v,"sh_") then
			include("tfo/" .. v)
			if TFO.Debug then
				MsgC(Color(0,255,0), "[TFO] Client shared: " .. v .. " \n")
			end
		end
	end	
	local files = file.Find( "tfo/lang/*", "LUA" )
	for _,v in pairs(files) do
		include("tfo/lang/" .. v)
		if TFO.Debug then
			MsgC(Color(0,255,0), "[TFO] Language shared: " .. v .. " \n")
		end
	end
end

if SERVER then
	local files = file.Find( "tfo/*", "LUA" )
	PrintTable(files)
	for _,v in pairs(files) do
		if string.StartWith(v,"cl_") then
			AddCSLuaFile("tfo/" .. v)
			if TFO.Debug then
				MsgC(Color(0,255,0), "[TFO] Server client files: " .. v .. " \n")
			end
		elseif string.StartWith(v,"sh_") then
			AddCSLuaFile("tfo/" .. v)
			include("tfo/" .. v)
			if TFO.Debug then
				MsgC(Color(0,255,0), "[TFO] Server shared files: " .. v .. " \n")
			end
		elseif string.StartWith(v,"sv_") then
			include("tfo/" .. v)
			if TFO.Debug then
				MsgC(Color(0,255,0), "[TFO] Server files: " .. v .. " \n")
			end
		end
	end
	local files = file.Find( "tfo/lang/*", "LUA" )
	for _,v in pairs(files) do
		AddCSLuaFile("tfo/lang/" .. v)
		include("tfo/lang/" .. v)
		if TFO.Debug then
			MsgC(Color(0,255,0), "[TFO] Server languages: " .. v .. " \n")
		end
	end
end