ENT.Base 			= "base_anim"
ENT.Type 			= "anim"

ENT.PrintName		= "TFO Fabricator"
ENT.Author			= "PichotM"
ENT.Category		= "The Forgery Office"

ENT.Spawnable 		= true
ENT.AdminOnly 		= false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "FabricatorStatut")
	self:NetworkVar("String", 0, "ItemsTable")
	self:NetworkVar("Int", 1, "FabricatorTime")
	self:NetworkVar("Int", 2, "SelectedCraft")
end

function ENT:CanMakeIt(data)
	if not data or type(data) ~= "table" or not data.components then return end
	local it = self:GetItemsTable()
	if not it or it == "" then it = "{}" end
	it = util.JSONToTable(it)

	for k,v in pairs(data.components) do
		if not TFO.Ingredients[k] or not it[TFO.Ingredients[k].class] or type(it[TFO.Ingredients[k].class]) ~= "number" or v > it[TFO.Ingredients[k].class] then return false end
	end
	return true
end