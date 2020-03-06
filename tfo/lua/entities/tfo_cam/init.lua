AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

ENT.ShootSound = Sound( "NPC_CScanner.TakePhoto" )

function ENT:Initialize()
	self:SetModel("models/pichot/tfo/camera.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetupButton()

	self.dataPictures = {}
end

function ENT:SetupButton()
	if self.photoButton and IsValid(self.photoButton) then self.photoButton:Remove() end
	if self.toggleButton and IsValid(self.toggleButton) then self.toggleButton:Remove() end

	self.photoButton = ents.Create("tfo_button")
	local ang = self:GetAngles()
	self.photoButton:SetPos(self:GetPos() + self:GetUp() * 59.5 + self:GetForward() * 6.75 + self:GetRight() * - 3.95)
	self.photoButton:SetAngles(self:GetAngles() + Angle(90, -15, 0))
	self.photoButton:SetModel("models/maxofs2d/button_02.mdl")
	self.photoButton:SetModelScale(self:GetModelScale() * .175, 0)
	self.photoButton:Spawn()
	self.photoButton:Activate()
	self:DeleteOnRemove(self.photoButton)
	self.photoButton:SetParent(self)
	self.photoButton.OnPressed = function(ent, pl, bl)
		local ent = ent:GetParent()
		if not ent or not IsValid(ent) or ent ~= self and bl then return end
		ent:DoShootEffect(pl)
	end

	self.toggleButton = ents.Create("tfo_button")
	local ang = self:GetAngles()
	self.toggleButton:SetPos(self:GetPos() + self:GetUp() * 59.5 + self:GetForward() * 2.15 + self:GetRight() * 5)
	self.toggleButton:SetAngles(self:GetAngles() + Angle(90, -42, 0))
	self.toggleButton:SetModel("models/maxofs2d/button_01.mdl")
	self.toggleButton:SetModelScale(self:GetModelScale() * .15, 0)
	self.toggleButton:Spawn()
	self.toggleButton:Activate()
	self.toggleButton:SetIsToggle(true)
	self:DeleteOnRemove(self.toggleButton)
	self.toggleButton:SetParent(self)
	self.toggleButton.OnPressed = function(ent)
		local ent = ent:GetParent()
		if not ent or not IsValid(ent) or ent ~= self then return end
		ent:SetCamStatut( not self:GetCamStatut() )
	end
end

function ENT:DoShootEffect(pl)
	if not self:GetCamStatut() or not IsValid(pl) then return end
	self:EmitSound( self.ShootSound )
	if SERVER then
		local vPos = self:GetPos() + self:GetUp() * 59 + self:GetRight() * - 5 + self:GetForward() * - 5
		local effectdata = EffectData()
		effectdata:SetOrigin( vPos )
		util.Effect( "camera_flash", effectdata, true )
	end

	local lang = TFO.Languages[TFO.SelectedLanguage]
	if table.Count(self.dataPictures) >= TFO.PhotoLimits then
		DarkRP.notify(pl, 1, 5, string.format(lang.photoLimit,  TFO.PhotoLimits))
		return
	end

	local target = self:GetEntInSight()
	if target and IsValid(target) and target:IsPlayer() and target:Alive() and (TFO.AllowCamSelfy or target ~= pl) then
		table.insert(self.dataPictures, { name = target:Name(), modelData = { m = target:GetModel(), s = target:GetSkin(), b = target:GetBodyGroups() }, date = os.time() })
	end
end