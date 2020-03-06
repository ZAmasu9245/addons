AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box003b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetTFOName("Identity Card")
	timer.Simple(.1, function()
		if not IsValid(self) then return end
		local price
		for k,v in pairs(TFO.ForgeriesRecipes) do
			if v.name == self:GetTFOName() then price = v.sellingprice break end
		end
		if not price then self:Remove() end

		if self:GetTFOPrice() > price[2] or self:GetTFOPrice() < price[1] then return self:Remove() end
	end)
end

function ENT:AcceptInput(it, act, cal)
	if it ~= "Use" or not IsValid(act) or not act:IsPlayer() or not act:Alive() or act:GetPos():Distance(self:GetPos()) > 256 or act:GetEyeTraceNoCursor().Entity ~= self or (self.nextUse and self.nextUse > CurTime()) then return end
	if self:IsNearSellingPoint() then
		self:Remove()
		local price = self:GetTFOPrice()
		if not price or price <= 0 then return end
		local lang = TFO.Languages[TFO.SelectedLanguage]
		DarkRP.notify(act, 0, 5, string.format(lang.deliverySuccess, self:GetTFOName(), DarkRP.formatMoney(price)))
		act:addMoney(price)
	else
		local isID
		for k,v in pairs(TFO.ForgeriesRecipes) do
			if v.name == self:GetTFOName() and v.identity then isID = v.identity break end
		end
		if isID then
			net.Start("TFO_OpenMenu")
			net.WriteInt(4, 4)
			net.Send(act)
		end
	end
	self.nextUse = CurTime() + 1
end