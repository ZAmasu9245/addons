--[[  
    Addon: Market
    By: SlownLS
]]

-- Angles
local angP = CreateClientConVar("slownls_market_config_item_angle_p","0")
local angY = CreateClientConVar("slownls_market_config_item_angle_y","0")
local angR = CreateClientConVar("slownls_market_config_item_angle_r","-70")

-- Vectors
local vecX = CreateClientConVar("slownls_market_config_item_vector_x","10")
local vecY = CreateClientConVar("slownls_market_config_item_vector_y","0")
local vecZ = CreateClientConVar("slownls_market_config_item_vector_z","0")

local PANEL = {}

function PANEL:Init()
    self:SetSize(300,240)
    self:SetPos(ScrW()-self:GetWide()-15,15)

    self:SetHeader("Configure Item",60,false)
    self:ShowCloseButton(false)
    self:SetDraggable(false)

    local angP = angP:GetInt()
    local angY = angY:GetInt()
    local angR = angR:GetInt()

    local vecX = vecX:GetInt()
    local vecY = vecY:GetInt()
    local vecZ = vecZ:GetInt()

    local function updateAngles(angle)
        local angP = angle.p
        local angY = angle.y
        local angR = angle.r

        RunConsoleCommand("slownls_market_config_item_angle_p",angP)
        RunConsoleCommand("slownls_market_config_item_angle_y",angY)
        RunConsoleCommand("slownls_market_config_item_angle_r",angR)
    end

    local function updateVectors(vector)
        local vecX = vector.x
        local vecY = vector.y
        local vecZ = vector.z

        RunConsoleCommand("slownls_market_config_item_vector_x",vecX)
        RunConsoleCommand("slownls_market_config_item_vector_y",vecY)
        RunConsoleCommand("slownls_market_config_item_vector_z",vecZ)
    end

    local ang = Angle(angP,angY,angR)

    local vec = Vector(vecX,vecY,vecZ)

    self.scale = vgui.Create("SlownLS:Market:DNumSlider",self)
        self.scale:SetSize(self:GetWide()-30,10)
        self.scale:SetPos(15,75)
        self.scale:SetDefaultText('Scale          :')
        self.scale:SetDecimals(1)
        self.scale:SetMax(5)
        self.scale:SetValue(1)
        self.scale.OnValueChanged = function()
            local ent = self:GetEntity()
            ent:SetModelScale(self.scale:GetValue())
        end

    for i = 1,3 do
        local intY = 75 + 10 + 10

        self.angle = vgui.Create("SlownLS:Market:DNumSlider",self)
            self.angle:SetSize(self:GetWide()-30,10)
            self.angle:SetPos(15,intY + ( (i+20) * i ) - 20)
            self.angle:SetDecimals(0)
            self.angle:SetMax(36)
            if i == 1 then
                self.angle:SetDefaultText('Angle Pitch :')
                self.angle:SetValue(angP/10)
            elseif i == 2 then
                self.angle:SetDefaultText('Angle Yaw  :')
                self.angle:SetValue(angY/10)
            else
                self.angle:SetDefaultText('Angle Roll   :')
                self.angle:SetValue(angR/10)
            end

            self.angle.OnValueChanged = function(self_,val)
                local ent = self:GetEntity()

                val = val * 10

                ang = Angle(ang.p,ang.y,ang.r)

                if i == 1 then
                    ang = Angle(val,ang.y,ang.r)
                elseif i == 2 then
                    ang = Angle(ang.p,val,ang.r)
                else    
                    ang = Angle(ang.p,ang.y,val)
                end

                updateAngles(ang)

                ent.configAng = ang
            end        
    end

    for i = 1,3 do
        local intY = 75 + 10 + 10 + 70

        self.vector = vgui.Create("SlownLS:Market:DNumSlider",self)
            self.vector:SetSize(self:GetWide()-30,10)
            self.vector:SetPos(15,intY + ( (i+20) * i ) - 20)
            self.vector:SetDecimals(1)
            self.vector:SetMax(100)
            self.vector:SetMin(-100)
            if i == 1 then
                self.vector:SetDefaultText('Vector X     :')
                self.vector:SetValue(vecX)
            elseif i == 2 then
                self.vector:SetDefaultText('Vector Y     :')
                self.vector:SetValue(vecY)
            else
                self.vector:SetDefaultText('Vector Z     :')
                self.vector:SetValue(vecZ)
            end
            self.vector.OnValueChanged = function(self_,val)
                local ent = self:GetEntity()

                vec = Vector(vec.x,vec.y,vec.z)

                if i == 1 then
                    vec = Vector(val,vec.y,vec.z)
                elseif i == 2 then
                    vec = Vector(vec.x,val,vec.z)
                else    
                    vec = Vector(vec.x,vec.y,val)
                end

                updateVectors(vec)

                ent.configPos = vec
            end    
    end

    timer.Simple(0.2,function()
        if !IsValid(self) then return end
        if !IsValid(self:GetEntity()) then return end

        self:GetEntity().configPos = vec
        self:GetEntity().configAng = ang
    end)    
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:AddItem_Configure",PANEL,"SlownLS:Market:DFrame")