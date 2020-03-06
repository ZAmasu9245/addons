AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

local itemTable = {
	["tfo_paper"] = {
		pos = function(pos, ang) return pos + ang:Up() * 40 + ang:Right() * 35 + ang:Forward() * -10 end,
	},
	["tfo_ink"] = {
		pos = function(pos, ang) return pos + ang:Up() * 42 + ang:Right() * 18 + ang:Forward() * - 10 end,
		ang = function(ang) ang:RotateAroundAxis(ang:Up(), -80) return ang end,
	},
	["tfo_picture"] = {
		pos = function(pos, ang) return pos + ang:Up() * 35 + ang:Right() * 34.5 + ang:Forward() * 9 end,
	},
	["TR Harvard's seal"] = {
		pos = function(pos, ang) return pos + ang:Up() * 39 + ang:Right() * 2 + ang:Forward() * -13 end,
		ang = function(ang) ang:RotateAroundAxis(ang:Up(), 90) return ang end,
	},
}

function ENT:Initialize()
	self:SetModel("models/props/cs_militia/table_shed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:SetMass(100) end

	self.ingredientsChild = {}
	self:SetSelectedPaper(1)
	self:SetItemsTable("{}")
	self.savedData = {}
	self:SetTableStatut(0)
	self.createdSounds = {}
end

function ENT:StopEntSounds()
	for k,v in pairs(self.createdSounds) do
		v:Stop()
	end
	self.createdSounds = {}
end

function ENT:EatIngredients()
	if not self:CanMakeIt() then return end
	local tbl = self:GetItemsTable()
	tbl = util.JSONToTable(tbl)

	local selectedPaper = TFO.ForgeriesRecipes[self:GetSelectedPaper()]
	for k,v in pairs(selectedPaper.components) do
		local name = TFO.Ingredients[k].class == "tfo_misc" and k or TFO.Ingredients[k].class
		if TFO.Ingredients[k] and tbl[name] then
			tbl[name] = tbl[name] - v
			if tbl[name] <= 0 then tbl[name] = nil end
		end
	end

	self:SetItemsTable(util.TableToJSON(tbl))
	self:UpdateIngredients(tbl)
end

function ENT:OnRemove()
	self:StopEntSounds()
end

function ENT:Use(act)
	if not act or not IsValid(act) or not act:IsPlayer() or not act:Alive() or not act:GetEyeTraceNoCursor().Entity or act:GetEyeTraceNoCursor().Entity ~= self or self:GetPos():Distance(act:GetPos()) > 256 or (self.lastUse and self.lastUse > CurTime()) then return end
	self.lastUse = CurTime() + .15
	if self:GetTableStatut() == 0 then
		local pos, ang = self:GetPos(), self:GetAngles()
		local selectRight = act:GetEyeTrace().HitPos:Distance(pos + ang:Up() * 34.8 + ang:Forward() * 18 + ang:Right() * -13.5) < 4
		local selectLeft = act:GetEyeTrace().HitPos:Distance(pos + ang:Up() * 34.8 + ang:Forward() * 18 + ang:Right() * 16) < 4
		local selectCraft = act:GetEyeTrace().HitPos:Distance(self:GetPos() + ang:Up() * 34.8 + ang:Forward() * 12.4 + ang:Right() * 1) < 5

		if selectRight then
			local choice = self:GetSelectedPaper() + 1
			choice = choice > #TFO.ForgeriesRecipes and 1 or choice
			self:SetSelectedPaper(choice)
		elseif selectLeft then
			local choice = self:GetSelectedPaper() - 1
			choice = choice == 0 and #TFO.ForgeriesRecipes or choice
			self:SetSelectedPaper(choice)
		elseif selectCraft and self:CanMakeIt() then
			self:SetTableStatut(1)
			self:EatIngredients()
			self:SetStatutTime(CurTime() + TFO.TableCraftTime)
			local snd = CreateSound(self, Sound("ambient/machines/engine4.wav"))
			snd:SetSoundLevel(60) snd:PlayEx(1, 120)
			table.insert(self.createdSounds, snd)
		end
	end

	--for k,v in pairs(self.ingredientsChild) do if IsValid(v) then v:Remove() end end
	--self.ingredientsChild = {}
	--self:UpdateIngredients({
	--	["tfo_paper"] = 1,
	--	["tfo_ink"] = 2,
	--	["tfo_picture"] = 1,
	--})
end

function ENT:Think()
	if self:GetTableStatut() == 1 then
		if self:GetStatutTime() - CurTime() <= 0 then
			self:SetStatutTime(0)
			self:SetTableStatut(0)
			self:StopEntSounds()
			local selectedPaper = TFO.ForgeriesRecipes[self:GetSelectedPaper()]
			if selectedPaper and selectedPaper.name then
				local paperEntity = ents.Create("tfo_document_case")
				paperEntity:SetPos(self:GetPos() + self:GetAngles():Up() * 46)
				paperEntity:SetAngles(self:GetAngles())
				paperEntity:Spawn()
				paperEntity:SetTFOName(selectedPaper.name)
				paperEntity:SetTFOPrice( type(selectedPaper.sellingprice) == "table" and math.Round(math.random(selectedPaper.sellingprice[1], selectedPaper.sellingprice[2])) or math.Round(selectedPaper.sellingprice))
				paperEntity:GetPhysicsObject():Wake()
			end
		end
		self:NextThink(CurTime() + 1)
		return true
	end
end

function ENT:UpdateIngredients(tbl)
	if tbl and type(tbl) == "string" then tbl = util.JSONToTable(tbl) end
	self:SetItemsTable(util.TableToJSON(tbl))

	tbl = tbl or self:GetItemsTable()
	for k,_ in pairs(tbl) do
		if itemTable[k] then
			if tbl[k] and tbl[k] > 0 and not self.ingredientsChild[k] then
				local class = string.StartWith(k, "tfo_") and k or "tfo_misc"
				self.ingredientsChild[k] = ents.Create(class)
				self.ingredientsChild[k]:SetPos(itemTable[k].pos(self:GetPos(), self:GetAngles()))
				self.ingredientsChild[k]:SetAngles(itemTable[k].ang and itemTable[k].ang(self:GetAngles()) or self:GetAngles() + Angle(0, 0, 0))
				self.ingredientsChild[k]:SetParent(self)
				self.ingredientsChild[k]:Spawn()
				self.ingredientsChild[k]:SetSolid(SOLID_NONE)
				self.ingredientsChild[k]:SetMoveType(MOVETYPE_NONE)
				self.ingredientsChild[k]:GetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
				self.ingredientsChild[k]:GetPhysicsObject():Sleep()
				self:DeleteOnRemove(self.ingredientsChild[k])
			end
			if self.ingredientsChild[k] and IsValid(self.ingredientsChild[k]) then
				self.ingredientsChild[k]:SetTFOAmount(tbl[k])
			end
		end
		if not tbl[k] or tbl[k] <= 0 then
			if IsValid(self.ingredientsChild[k]) then self.ingredientsChild[k]:Remove() self.ingredientsChild[k] = nil end
			tbl[k] = nil
		end
	end

	for k,v in pairs(TFO.Ingredients) do
		local name = v.class == "tfo_misc" and k or v.class
 		if self.ingredientsChild[name] and (not tbl[name] or tbl[name] <= 0) then
			if IsValid(self.ingredientsChild[name]) then self.ingredientsChild[name]:Remove() end
			self.ingredientsChild[name] = nil
 		end
	end
end

function ENT:Touch(ent)
	if not IsValid(ent) or (self.lastTouch and self.lastTouch >= CurTime()) then return end
	local entClass, selectedIngredients, name = ent:GetClass()
	for k,v in pairs(TFO.Ingredients) do
		if v.class == entClass and not v.base then
			selectedIngredients = v
			name = k
		end
	end
	local decorName = entClass == "tfo_misc" and name or entClass
	if not selectedIngredients or (selectedIngredients.success and not selectedIngredients.success(ent)) then return end

	local tbl = self:GetItemsTable()
	if not tbl or tbl == "" then tbl = "{}" end
	tbl = util.JSONToTable(tbl)
	local am = ent:GetTFOAmount() and ent:GetTFOAmount() > 0 and ent:GetTFOAmount() or 1
	tbl[decorName] = tbl[decorName] and tbl[decorName] + am or am
	ent:Remove()
	self:UpdateIngredients(tbl)
	self.lastTouch = CurTime() + 1

	if selectedIngredients.decor then
		local decor = self.ingredientsChild[decorName]
		if decor and IsValid(decor) then selectedIngredients.decor(ent, decor) end
	end
end