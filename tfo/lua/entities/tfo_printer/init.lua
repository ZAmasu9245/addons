AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/pichot/tfo/imprimante.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetupButton()

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:SetMass(100) end
end

function ENT:SetupButton()
	if self.toggleButton and IsValid(self.toggleButton) then self.toggleButton:Remove() end

	self.toggleButton = ents.Create("tfo_button")
	local ang = self:GetAngles()
	self.toggleButton:SetPos(self:GetPos() + self:GetUp() * 48 + self:GetForward() * 4 + self:GetRight() * - 13.5)
	self.toggleButton:SetAngles(self:GetAngles() + Angle(50, 0, 0))
	self.toggleButton:SetModel("models/maxofs2d/button_01.mdl")
	self.toggleButton:SetModelScale(self:GetModelScale() * .225, 0)
	self.toggleButton:Spawn()
	self.toggleButton:Activate()
	self.toggleButton:SetIsToggle(true)
	self:DeleteOnRemove(self.toggleButton)
	self.toggleButton:SetParent(self)
	self.toggleButton.OnPressed = function(ent)
		local ent = ent:GetParent()
		if not ent or not IsValid(ent) or ent ~= self or ent.printing then return end
		ent:SetPrinterStatut( not ent:GetPrinterStatut() )
	end
end

function ENT:AcceptInput(it, act, cal)
	if it ~= "Use" or not IsValid(act) or not act:IsPlayer() or not act:Alive() or act:GetPos():Distance(self:GetPos()) > 256 or act:GetEyeTraceNoCursor().Entity ~= self then return end

	local status = self:GetPrinterStatut()
	if status then
		net.Start("TFO_OpenMenu")
		net.WriteInt(1, 4)

		local camData = {}
		for _,v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
			if IsValid(v) and v:GetClass() == "tfo_cam" and v.dataPictures then camData = v.dataPictures break end
		end
		--table.insert(camData, { name = "John Smith", modelData = { m = "models/Humans/Group02/Male_01.mdl", s = 0, b = {} }, date = os.time() })
		camData = camData or {}

		net.WriteTable(camData)
		net.Send(act)
	end
end

sound.Add( { name = "tfo_printer_sound", sound = "ambient/levels/labs/equipment_printer_loop1.wav" } )
function ENT:Think()
	if self.printing and self.page and IsValid(self.page) and self.printing < 19 then
		self:GetPhysicsObject():EnableMotion(false)
		self.page:GetPhysicsObject():EnableMotion(false)
		self.page:SetPos(self:GetPos() + (self:GetUp() * (21.2 + (.1 * self.printing))) + self:GetForward() * - 12 + self:GetRight() * (-5 - self.printing))
		self.page:SetAngles(self:GetAngles() + Angle(-5, 90, 0))
		self.printing = self.printing + 1
		if self.printing == 19 then
			self.page:SetParent()
			self.page:GetPhysicsObject():EnableMotion(true)
			self:DontDeleteOnRemove(self.page)
			self.printing = nil
			self.page.PreventGravGun = nil
			self.page = nil
			self:StopSound("tfo_printer_sound")
			self.PreventGravGun = false
		end
	end
	self:NextThink(CurTime() + 4)
	return true
end

function ENT:OnRemove()
	self:StopSound("tfo_printer_sound")
end

function ENT:LaunchPrinting(t, ply)
	if not t or not t.modelData or not t.date or not t.name or (self.page and IsValid(self.page)) then return end
	self:EmitSound("tfo_printer_sound", 75, 100)
	self:SetInkStatut(self:GetInkStatut() - 1)

	self.page = ents.Create("tfo_picture")
	self.page:SetPos(self:GetPos() + self:GetUp() * 21.2 + self:GetForward() * - 12 + self:GetRight() * - 5 )
	self.page:SetAngles(self:GetAngles() + Angle(-5, 90, 0))
	self.page:Spawn()
	self.page:Activate()
	self:DeleteOnRemove(self.page)
	self.page:SetPaperModel(t.modelData.m)
	self.page.PreventGravGun = true
	local phys = self.page:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(200)
	end
--	self.page:SetParent(self)

	self.printing = 0
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
	self.page:CPPISetOwner(ply)
	self.PreventGravGun = true
end