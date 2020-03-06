--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:MakePopup()
end

function PANEL:CreateNPC()
    self:SetSize(500,185)
    self:Center()
    
    self:SetHeader("Configure NPC",60,true)

    self.nameNPC = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.nameNPC:SetSize(self:GetWide()-30,25)
        self.nameNPC:SetPos(15,75)
        self.nameNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.btnSave = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnSave:SetSize(self:GetWide()-30,30)  
        self.btnSave:SetPos(15,75+(self.nameNPC:GetHeight()+15)*1)
        self.btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        self.btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        self.btnSave.DoClick = function()
            local ent = self:GetEntity()

            SlownLS.Market:SendEvent("npc_add",{
                name = self.nameNPC:GetValue() or "",
                model = ent:GetModel() or "",
                pos = tostring(ent:GetPos()),
                ang = tostring(ent:GetAngles())
            })

            self:FadeOut(0.2,true)
        end
end

function PANEL:EditNPC()
    self:SetSize(500,250)
    self:Center()
    
    self:SetHeader("Edit NPC",60,true)

    self.nameNPC = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.nameNPC:SetSize(self:GetWide()-30,25)
        self.nameNPC:SetPos(15,75)
        self.nameNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.modelNPC = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.modelNPC:SetSize(self:GetWide()-30,25)
        self.modelNPC:SetPos(15,75+(self.nameNPC:GetHeight()+15)*1)
        self.modelNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_model_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.btnSave = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnSave:SetSize(self:GetWide()-30,30)  
        self.btnSave:SetPos(15,75+(self.nameNPC:GetHeight()+15)*2)
        self.btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        self.btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        self.btnSave.DoClick = function()
            local ent = self:GetEntity()

            SlownLS.Market:SendEvent("npc_edit",{
                name = self.nameNPC:GetValue() or "",
                model = self.modelNPC:GetValue() or "",
                ent = self:GetEntity()
            })

            self:FadeOut(0.2,true)
        end

    timer.Simple(0.2,function()
        if !IsValid(self) then return end
        if !IsValid(self:GetEntity()) then return end

        self.nameNPC:SetValue(self:GetEntity():GetNPCName())
        self.modelNPC:SetValue(self:GetEntity():GetModel())
    end)
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:NPC_Config",PANEL,"SlownLS:Market:DFrame")