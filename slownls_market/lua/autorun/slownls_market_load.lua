--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS = SlownLS or {}
SlownLS.Market = SlownLS.Market or {}

function SlownLS.Market:AddFile(strPath,boolInclude)
	local files, folders = file.Find(strPath.."*","LUA")
    
	for _,v in pairs(files or {}) do
		if boolInclude then
			include(strPath..v)
		else
			AddCSLuaFile(strPath..v)
		end
	end

	for _,v in pairs(folders or {}) do
		self:AddFile(strPath..v.."/",boolInclude)
	end
end

function SlownLS.Market:Load()
	if SERVER then
		-- Load Shared Files
		self:AddFile("slownls_market/shared/",true)
		self:AddFile("slownls_market/shared/",false)

		-- Load Server Files
		self:AddFile("slownls_market/server/",true)

		-- Load Client Files
		self:AddFile("slownls_market/client/",false)

		-- Load Languages Files
		self:AddFile("slownls_market/languages/",true)
		self:AddFile("slownls_market/languages/",false)

		return
	end

	-- Load Shared Files
	self:AddFile("slownls_market/shared/",true)

	-- Load Client Files
	self:AddFile("slownls_market/client/",true)

	-- Load Languages Files
	self:AddFile("slownls_market/languages/",true)
end

SlownLS.Market:Load()

print('SlownLS Market loaded!')