
--[[  
    Addon: Builder
    For: Undertale
    By: SlownLS ( www.g-core.fr )
]]

TOOL.Category = "SlownLS Market"
TOOL.Name = "#tool.slownls_market_npc.name"
TOOL.Information = {
	{ name = "left", },
	{ name = "right" },
	{ name = "reload" },
}
TOOL.ClientConVar["model"] = "models/monk.mdl"

function TOOL:RemoveNPC()
    if SERVER then return end

    if IsValid(self.configMenu) then self.configMenu:Remove() end
    if self.model && IsValid(self.model) then self.model:Remove() end
end

function TOOL:CreateNPC()
    if SERVER then return end

    self:RemoveNPC()

	self.model = ClientsideModel(GetConVar("slownls_market_npc_model"):GetString())
    self.model:SetAngles(Angle(0,0,0))
end

function TOOL:Deploy()
    if SERVER then return end

    self:CreateNPC()
end

function TOOL:Holster()
    if SERVER then return end

    self:RemoveNPC()
end

function TOOL:Think()
    if SERVER then return end

    if self.model && IsValid(self.model) then
        if string.lower(self.model:GetModel()) != string.lower(GetConVar("slownls_market_npc_model"):GetString()) then
            self.model:SetModel(GetConVar("slownls_market_npc_model"):GetString())
        end

        local vecPos = self.Owner:GetEyeTrace().HitPos

        self.model:SetPos(vecPos)
        self.model:SetColor(Color(0,255,0,200))
        self.model:SetAngles(Angle(0,LocalPlayer():EyeAngles().y,0))
    else
        self:CreateNPC()
    end

    local ent = self.Owner:GetEyeTrace().Entity

    if IsValid(ent) && ent:GetClass() == "slownls_market_npc" then 
        self.model:SetNoDraw(true)
        if !self.intNextRight || CurTime() > self.intNextRight then
            if input.IsMouseDown(MOUSE_RIGHT) then
                self:RightClick(self.Owner:GetEyeTrace())
            end

            self.intNextRight = CurTime() + 0.1
        end    
        
        if !self.intNextReload || CurTime() > self.intNextReload then
            if input.IsKeyDown(KEY_R) then
                self:Reload(self.Owner:GetEyeTrace())
            end

            self.intNextReload = CurTime() + 0.1
        end    
    else
        self.model:SetNoDraw(false)
    end    

end

function TOOL:LeftClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    if IsValid(self.configMenu) then self.configMenu:Remove() end

    self.configMenu = vgui.Create("SlownLS:Market:NPC_Config")
        self.configMenu:SetEntity(self.model)
        self.configMenu:CreateNPC()
end
 
function TOOL:RightClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    local ent = tr.Entity

    if IsValid(self.configMenu) then self.configMenu:Remove() end

    if !IsValid(ent) then return end

    self.configMenu = vgui.Create("SlownLS:Market:NPC_Config")
        self.configMenu:SetEntity(ent)
        self.configMenu:EditNPC()    
end

function TOOL:Reload(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end

    if !self.intNexRemove || CurTime() > self.intNexRemove then
        SlownLS.Market:SendEvent('npc_delete',{})

        self.intNexRemove = CurTime() + 0.2
    end       
end

if SERVER then return end 

function TOOL:DrawHUD()
    local intW = 250
    local intH = 40

    if IsValid(self.model) && self.model:GetNoDraw() then     
        surface.SetFont("SlownLS:Market:18")
        local intTextW, intTextH = surface.GetTextSize(SlownLS.Market:GetLanguage('npc_reload_to_remove'))

        intW = intTextW + 30

        surface.SetDrawColor(Color(0,0,0,200))
        surface.DrawRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

        surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
        surface.DrawOutlinedRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

        draw.SimpleText(SlownLS.Market:GetLanguage('npc_reload_to_remove'),"SlownLS:Market:18",ScrW()/2,ScrH()/2,SlownLS.Market:GetColor('text'),1,1)
    end
end

function TOOL.BuildCPanel(panel)
    -- Model
	panel:AddControl("Label", {
		Text = "Enter model of npc",
        Description = "Enter model of npc"
	})

    local pModel = vgui.Create("DTextEntry")
    pModel:SetUpdateOnType(true)
    pModel:SetEnterAllowed(true)
    pModel:SetConVar("slownls_market_npc_model")
    pModel:SetValue(GetConVar("slownls_market_npc_model"):GetString()) 
    panel:AddItem(pModel)
end

language.Add("tool.slownls_market_npc.name","Create NPC")
language.Add("tool.slownls_market_npc.desc","Create NPC")
language.Add("tool.slownls_market_npc.right","'Right click' to edit NPC")
language.Add("tool.slownls_market_npc.left","'Left click' to create NPC")
language.Add("tool.slownls_market_npc.reload","'R' to delete NPC")