-- from sandbox gamemode
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "TFO Button"
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Bool", 1, "IsToggle" )

	if ( SERVER ) then
		self:SetOn( false )
		self:SetIsToggle( false )
	end

end

function ENT:Initialize()
	if ( SERVER ) then
		self:PhysicsInit(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(ONOFF_USE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	else
		self.PosePosition = 0
	end
end

function ENT:Use( activator, caller, type, value )
	if ( !activator:IsPlayer() or (self.nextPress and self.nextPress > CurTime()) ) then return end

	self.nextPress = CurTime() + 1
	if ( self:GetIsToggle() ) then
		if ( type == USE_ON ) then
			self:Toggle( !self:GetOn(), activator )
		end
		return
	end

	if ( IsValid( self.LastUser ) ) then return end

	if ( self:GetOn() ) then
		self:Toggle( false, activator )
		return
	end

	self:Toggle( true, activator )
	self:NextThink( CurTime() )
	self.LastUser = activator
end

function ENT:Think()
	if ( CLIENT ) then
		self:UpdateLever()
	end

	if ( SERVER && self:GetOn() && !self:GetIsToggle() ) then
		if ( !IsValid( self.LastUser ) || !self.LastUser:KeyDown( IN_USE ) ) then
			self:Toggle( false, self.LastUser )
			self.LastUser = nil
		end
		self:NextThink( CurTime() )
	end
end

function ENT:Toggle( bEnable, ply )
	if ( bEnable ) then
		self:SetOn( true )
	else
		self:SetOn( false )
	end
	if self.OnPressed then self.OnPressed(self, ply, bEnable) end
end

function ENT:UpdateLever()
	local TargetPos = 0.0
	if ( self:GetOn() ) then TargetPos = 1.0 end

	self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 5.0 )

	self:SetPoseParameter( "switch", self.PosePosition )
	self:InvalidateBoneCache()
end