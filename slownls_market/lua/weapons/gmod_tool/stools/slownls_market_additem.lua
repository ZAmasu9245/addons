--[[  
    Addon: Builder
    For: Undertale
    By: SlownLS ( www.g-core.fr )
]]


SlownLS.Market.CreateItemMenu = SlownLS.Market.CreateItemMenu or nil 
SlownLS.Market.ConfigModel = SlownLS.Market.ConfigModel or nil 
SlownLS.Market.DrawConfigModel = SlownLS.Market.DrawConfigModel or true

TOOL.Category = "SlownLS Market"
TOOL.Name = "#tool.slownls_market_additem.name"
TOOL.angPos = Angle(0,0,0)
TOOL.Information = {}
TOOL.intVecZ = 0

function TOOL:RemoveProp()
    if SERVER then return end

    if IsValid(self.configMenu) then self.configMenu:Remove() end
    if self.model && IsValid(self.model) then self.model:Remove() end
    SlownLS.Market.ConfigModel = nil
end

function TOOL:CreateProp()
    if SERVER then return end

    self:RemoveProp()

	self.model = ClientsideModel("models/props_junk/PopCan01a.mdl")
    self.model:SetAngles(Angle(0,0,0))
    self.model.configPos = Vector(0,0,0)
    self.angPos = Angle(0,0,0)

    SlownLS.Market.ConfigModel = self.model

    if IsValid(self.configMenu) then self.configMenu:Remove() end

    self.configMenu = vgui.Create("SlownLS:Market:AddItem_Configure")
        self.configMenu:SetEntity(self.model)
end

function TOOL:ChangeModel()
    if SERVER then return end
    
    if IsValid(self.changeModelMenu) then self.changeModelMenu:Remove() end

    self.changeModelMenu = vgui.Create("SlownLS:Market:AddItem_ChangeModel")
        self.changeModelMenu:SetEntity(self.model)
end

function TOOL:CreateItem()
    if SERVER then return end
    
    if IsValid(self.createItemMenu) then self.createItemMenu:Remove() end

    self.createItemMenu = vgui.Create("SlownLS:Market:AddItem")
        self.createItemMenu:SetEntity(self.model)

    SlownLS.Market.CreateItemMenu = self.createItemMenu
end

function TOOL:EditItem(ent)
    if SERVER then return end

    if IsValid(self.editItemMenu) then self.editItemMenu:Remove() end

    self.editItemMenu = vgui.Create("SlownLS:Market:AddItem_Edit")
        self.editItemMenu:SetEntity(ent)
end

function TOOL:Deploy()
    if SERVER then return end

    self:CreateProp()
end

function TOOL:Holster()
    if SERVER then return end

    self:RemoveProp()
end

function TOOL:Think()
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    if self.model && IsValid(self.model) then
        local vecPos = self.Owner:GetEyeTrace().HitPos
        local vecOBBMins,vecOBBMaxs = self.model:GetRenderBounds()

        if vecOBBMaxs.z > 10 then vecOBBMaxs.z = 0 end

        self.model:SetPos(vecPos+Vector(0,0,vecOBBMaxs.z+self.intVecZ))
        self.model:SetColor(Color(0,255,0,200))
    else
        self:CreateProp()
    end

    local ent = self.Owner:GetEyeTrace().Entity

    if IsValid(ent) && ent:GetClass() == "slownls_market_item" && ent.GetItemPreview && ent:GetItemPreview() then 
        SlownLS.Market.DrawConfigModel = false 

        if !self.intNextReload2 || CurTime() > self.intNextReload2 then
            if input.IsKeyDown(KEY_R) && !IsValid(self.editItemMenu) then
                self:EditItem(ent)
            end

            self.intNextReload2 = CurTime() + 0.1
        end
    else
        if !self.intNextReload || CurTime() > self.intNextReload then
            if input.IsKeyDown(KEY_R) && !IsValid(SlownLS.Market.CreateItemMenu) then
                local angCur = self.model:GetAngles()
                angCur.y = angCur.y + 1
                self.model:SetAngles(angCur)
            end

            self.intNextReload = CurTime()
        end

        if input.IsKeyDown(KEY_DOWN) && !IsValid(SlownLS.Market.CreateItemMenu) then
            self.intVecZ = self.intVecZ - 0.01
        end

        if input.IsKeyDown(KEY_UP) && !IsValid(SlownLS.Market.CreateItemMenu) then
            self.intVecZ = self.intVecZ + 0.01
        end

        SlownLS.Market.DrawConfigModel = true
    end
end

function TOOL:LeftClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    self:CreateItem()
end
 
function TOOL:RightClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    self:ChangeModel()
end

if SERVER then return end

function TOOL:DrawHUD()
    local intW = 250
    local intH = 40

    if !SlownLS.Market.DrawConfigModel then     
        surface.SetFont("SlownLS:Market:18")
        local intTextW, intTextH = surface.GetTextSize(SlownLS.Market:GetLanguage('item_reload_to_edit'))

        intW = intTextW + 30

        surface.SetDrawColor(Color(0,0,0,200))
        surface.DrawRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

        surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
        surface.DrawOutlinedRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

        draw.SimpleText(SlownLS.Market:GetLanguage('item_reload_to_edit'),"SlownLS:Market:18",ScrW()/2,ScrH()/2,SlownLS.Market:GetColor('text'),1,1)
    end
end

language.Add("tool.slownls_market_additem.name", "Create Item")
language.Add("tool.slownls_market_additem.desc", "Add item to your shop.")