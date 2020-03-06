ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Table"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ItemsTable")
	self:NetworkVar("Int", 0, "SelectedPaper")
	self:NetworkVar("Int", 1, "TableStatut")
	self:NetworkVar("Int", 2, "StatutTime")
end

function ENT:CanMakeIt()
	local itemSelected = self:GetSelectedPaper()
	local data, selfData = TFO.ForgeriesRecipes[self:GetSelectedPaper()], self:GetItemsTable()
	selfData = util.JSONToTable(selfData)

	for k,v in pairs(data.components) do
		local class = TFO.Ingredients[k] and (TFO.Ingredients[k].class == "tfo_misc" and k or TFO.Ingredients[k].class) or nil
		if not selfData or not TFO.Ingredients[k] or not class or not selfData[class] or selfData[class] < v then return false end
	end
	return true
end