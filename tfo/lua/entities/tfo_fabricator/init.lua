AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_washer003.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:SetMass(125) end
	self:SetupButton()
	self:SetItemsTable("{}")
	self.createdSounds = {}
	self:SetFabricatorTime(0)
	self:SetSelectedCraft(0)
end

function ENT:AcceptInput(it, act, cal)
	if it ~= "Use" or not IsValid(act) or not act:IsPlayer() or not act:Alive() or act:GetPos():Distance(self:GetPos()) > 256 or act:GetEyeTraceNoCursor().Entity ~= self then return end

	local status, ang = self:GetFabricatorStatut(), self:GetAngles()
	local isOnMenu = act:GetEyeTrace().HitPos:Distance(self:GetPos() + ang:Up() * 20.1 + ang:Forward() * - 15.1 + ang:Right() * - 13.6) < 10
	if status == 1 and isOnMenu then
		net.Start("TFO_OpenMenu")
		net.WriteInt(3, 4)
		net.WriteEntity(self)
		net.Send(act)
	end
end

function ENT:StopEntSounds()
	for k,v in pairs(self.createdSounds) do
		v:Stop()
	end
	self.createdSounds = {}
end

function ENT:OnRemove()
	self:StopEntSounds()
end

function ENT:SetupButton()
	if self.toggleButton and IsValid(self.toggleButton) then self.toggleButton:Remove() end

	self.toggleButton = ents.Create("tfo_button")
	local ang = self:GetAngles()
	self.toggleButton:SetPos(self:GetPos() + self:GetUp() * 20.25 + self:GetForward() * 17.5 + self:GetRight() * - 11.6)
	self.toggleButton:SetAngles(self:GetAngles() + Angle(0, 0, -37.5))
	self.toggleButton:SetModel("models/maxofs2d/button_01.mdl")
	self.toggleButton:SetModelScale(self:GetModelScale() * .75, 0)
	self.toggleButton:Spawn()
	self.toggleButton:Activate()
	self.toggleButton:SetIsToggle(true)
	self:DeleteOnRemove(self.toggleButton)
	self.toggleButton:SetParent(self)
	self.toggleButton.OnPressed = function(ent)
		local ent = ent:GetParent()
		if not ent or not IsValid(ent) or ent ~= self then return end
		ent:SetFabricatorStatut( self:GetFabricatorStatut() == 0 and 1 or 0 )
		if self:GetFabricatorStatut() > 0 then
			self:EmitSound("ambient/machines/spinup.wav", 75, 100)
			local snd = CreateSound(self, Sound("ambient/machines/spin_loop.wav"))
			snd:SetSoundLevel(65) snd:PlayEx(1, 120)
			table.insert(self.createdSounds, snd)
		else
			self:EmitSound("ambient/machines/spindown.wav", 75, 100)
			self:StopEntSounds()
		end
	end
end

function ENT:Touch(ent)
	if not IsValid(ent) or (self.lastTouch and self.lastTouch >= CurTime()) or not ent.GetTFOAmount or not ent.GetTFOQuality or ent:GetTFOQuality() or self:GetFabricatorStatut() ~= 1 then return end
	self.lastTouch = CurTime() + 1
	local entClass, selectedIngredients = ent:GetClass()
	for k,v in pairs(TFO.Ingredients) do
		if v.class == entClass and (not v.success or v.success(ent)) then selectedIngredients = v end
	end

	if not selectedIngredients then return end

	local tbl = self:GetItemsTable()
	if not tbl or tbl == "" then tbl = "{}" end
	tbl = util.JSONToTable(tbl)
	local am = ent:GetTFOAmount() and ent:GetTFOAmount() > 0 and ent:GetTFOAmount() or 1
	tbl[entClass] = tbl[entClass] and tbl[entClass] + am or am
	ent:Remove()
	self:SetItemsTable(util.TableToJSON(tbl))
end

function ENT:LaunchCrafting(id)
	if self:GetFabricatorStatut() ~= 1 or not TFO.FabricatorItems[id] then return end
	local recipe = TFO.FabricatorItems[id]
	self:SetFabricatorStatut(2)
	self:SetFabricatorTime(CurTime() + (recipe.time or 60))
	self:SetSelectedCraft(id)
end

function ENT:FinishCrafting()
	if not self:CanMakeIt(TFO.FabricatorItems[self:GetSelectedCraft()]) or self:GetFabricatorStatut() ~= 2 then return end
	self:SetFabricatorStatut(1)
	self:SetFabricatorTime(0)
	local t = TFO.FabricatorItems[self:GetSelectedCraft()]

	local tbl = self:GetItemsTable()
	if not tbl or tbl == "" then tbl = "{}" end
	tbl = util.JSONToTable(tbl)

	for k,v in pairs(t.components) do
		if TFO.Ingredients[k] and tbl[TFO.Ingredients[k].class] then
			tbl[TFO.Ingredients[k].class] = tbl[TFO.Ingredients[k].class] - v
			if tbl[TFO.Ingredients[k].class] <= 0 then tbl[TFO.Ingredients[k].class] = nil end
		end
	end

	self:SetItemsTable(util.TableToJSON(tbl))
	self:SetSelectedCraft(0)

	local newItem = ents.Create(t.baseclass)
	local ang = self:GetAngles()
	newItem:SetPos(self:GetPos() + self:GetUp() * 5 + self:GetForward() * -65 + self:GetRight() * 0)
	newItem:SetAngles(self:GetAngles())
	if t.model then newItem:SetModel(t.model) end
	newItem:Spawn()
	newItem:Activate()
	newItem:GetPhysicsObject():Wake()
	newItem:SetColor(TFO.QualityColor)
	newItem:SetTFOQuality(true)
	if newItem.SetTFOName then newItem:SetTFOName(t.item) end
end

function ENT:Think()
	local time = self:GetFabricatorTime() - CurTime()
	if self:GetFabricatorStatut() ~= 2 then
		if time ~= 0 then self:SetFabricatorTime(0) self:SetSelectedCraft(0) end
	elseif time <= 0 then
		if TFO.FabricatorItems[self:GetSelectedCraft()] then self:FinishCrafting() end	
	end
	self:NextThink(CurTime() + 1)
	return true
end