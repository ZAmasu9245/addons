--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(500,185)
    self:Center()
    self:MakePopup()

    self:SetHeader("Change Model",60,true)

    self.model = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.model:SetSize(self:GetWide()-30,25)
        self.model:SetPos(15,75)
        self.model:SetLabel(SlownLS.Market:GetLanguage('model'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.btnSave = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnSave:SetSize(self:GetWide()-30,30)  
        self.btnSave:SetPos(15,140)  
        self.btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        self.btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        self.btnSave.DoClick = function()

            local ent = self:GetEntity()
            ent:SetModel(self.model:GetValue())

            self:FadeOut(0.2,true)
        end

    timer.Simple(0.2,function()
        if !IsValid(self) then return end
        if !IsValid(self.model) then return end
        if !IsValid(self:GetEntity()) then return end
        self.model:SetValue(self:GetEntity():GetModel() or "")
    end)
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:AddItem_ChangeModel",PANEL,"SlownLS:Market:DFrame")