if SERVER then resource.AddWorkshop("1172466475") end
--[[-------------------------------------------------------------------------
The Forgery Office
Configuration file
---------------------------------------------------------------------------]]
-- Selected languages in tfo/lang
TFO.SelectedLanguage = "en"
-- Allow pictures from the photographer
TFO.AllowCamSelfy = false
-- Max Ink in the printer
TFO.MaxPrinterInk = 10
-- Crafting time in the table
TFO.TableCraftTime = 180
-- Quality color for fabricator's products
TFO.QualityColor = Color(0, 150, 0)
-- Darknet buying delivery pos, Use the TFO admin weapon to set up these pos (with any props)
TFO.SupplierPos = { -- example point (on gm_construct)
	{ pos = Vector(-7728.6166992188, -3150.7202148438, 8.3196392059326), ang = Angle(0, -88.2, -0.2) }
}
-- Sellpoint (where smuggling has to be send) Use the TFO admin weapon to set up these pos (with any props) :: but only keep the Vector
TFO.SellPos = {
	Vector(-7928.51953125, 643.83905029297, 0.35821229219437),
}
-- Camera limits
TFO.PhotoLimits = 10
--[[-------------------------------------------------------------------------
DarkRP Configuration
---------------------------------------------------------------------------]]
-- in darkrp_modules/tfo/sh_tfo_darkrp.lua
--[[-------------------------------------------------------------------------
Expert configuration (need knowledge)
---------------------------------------------------------------------------]]
-- All ingredients available 
TFO.Ingredients = {
	["Profile picture"] = {
		class = "tfo_picture", -- entity class
		success = function(ent) return true or ent:GetPaperModel() and string.len(ent:GetPaperModel()) > 0 end, -- success to be in the table
		quality = function(ent) end, -- in another update with quality
		decor = function(ent, decor) return decor:SetPaperModel(ent:GetPaperModel()) end, -- custom decor function for the table
	},
	["Ink"] = {
		class = "tfo_ink",
		base = true, -- prevent using on the craft table
	},
	["Paper"] = {
		class = "tfo_paper",
		base = true, -- prevent using on the craft table
	},
	["Quality Ink"] = {
		class = "tfo_ink",
		success = function(ent) return ent:GetTFOQuality() end,
		decor = function(ent, decor) return decor:SetColor(TFO.QualityColor) end,
	},
	["Quality Paper"] = {
		class = "tfo_paper",
		success = function(ent) return ent:GetTFOQuality() end,
		decor = function(ent, decor) return decor:SetColor(TFO.QualityColor) end,
	},
	["Harvard's seal"] = {
		class = "tfo_misc",
		base = true, -- prevent using on the craft table
		success = function(ent) return ent:GetTFOName() == "Harvard's seal" end,
	},
	["TR Harvard's seal"] = {
		class = "tfo_misc",
		success = function(ent) return ent:GetTFOName() == "TR Harvard's seal" and ent:GetTFOQuality() end,
		decor = function(ent, decor) return decor:SetColor(TFO.QualityColor) end,
	},
}
-- Smuggling recipes, papers availables
TFO.ForgeriesRecipes = {
	{
		name = "Harvard Degree", -- Item's name
		model = "models/props_lab/corkboard002.mdl", -- Model
		sellingprice = { 10000, 30000 }, -- selling price (random between 30k and 10k), work as { min, max } or sellingprice = 10000 if you want
		components = { -- ingredients
			["Profile picture"] = 1,
			["Quality Ink"] = 2,
			["Quality Paper"] = 2,
			["TR Harvard's seal"] = 1,
		}
	},
	{
		name = "Identity Card",
		model = "models/props_junk/cardboard_box003b_gib01.mdl",
		sellingprice = { 5000, 15000 },
		components = {
			["Profile picture"] = 1,
			["Quality Ink"] = 1,
			["Quality Paper"] = 1,
		},
		identity = true, -- does this entity can be used to change player's identity
	},
	{
		name = "Driver license",
		model = "models/props_junk/cardboard_box003b_gib01.mdl",
		sellingprice = { 4000, 9000 },
		components = {
			["Profile picture"] = 1,
			["Quality Ink"] = 1,
			["Quality Paper"] = 1,
		}
	},
	{
		name = "Passport",
		model = "models/props_junk/cardboard_box003b_gib01.mdl",
		sellingprice = { 12500, 17500 },
		components = {
			["Profile picture"] = 1,
			["Quality Ink"] = 1,
			["Quality Paper"] = 1,
		},
		identity = true,
	},
}
-- Fabricator items
TFO.FabricatorItems = {
	{
		item = "Quality Ink", -- "new name"
		time = 60, -- time to craft
		baseclass = "tfo_ink", -- item class
		components = {
			["Ink"] = 2
		},
	},
	{
		item = "Quality Paper",
		time = 60,
		baseclass = "tfo_paper",
		components = {
			["Paper"] = 2,
		},
	},
	{
		item = "TR Harvard's seal",
		time = 60,
		baseclass = "tfo_misc",
		components = {
			["Harvard's seal"] = 1,
		},
	},
}
-- Darknet products
TFO.DarknetBuy = {
	{
		name = "Harvard's seal", -- item name
		baseclass = "tfo_misc", -- class
		price = 10000, -- item price
	},
}