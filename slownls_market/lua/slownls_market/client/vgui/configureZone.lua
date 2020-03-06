--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(700,255)
    self:Center()
    self:MakePopup()

    self:SetHeader("Create Zone",60,true)

    local tblNpcs = {}

    for k,v in pairs(ents.GetAll() or {}) do
        if !IsValid(v) then continue end
        if v:GetClass() != "slownls_market_npc" then continue end

        table.insert(tblNpcs,v)
    end

    self.nameZone = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.nameZone:SetSize(self:GetWide()-30,25)
        self.nameZone:SetPos(15,75)
        self.nameZone:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_zone'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.nameNPC = vgui.Create("SlownLS:Market:DComboBox",self)
        self.nameNPC:SetSize(self:GetWide()-30,25)
        self.nameNPC:SetPos(15,140)
        self.nameNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))   
        for k,v in SortedPairs(tblNpcs or {}) do
            self.nameNPC:AddChoice(v:GetNPCName())
        end
        if table.Count(tblNpcs) > 0 then
            self.nameNPC:ChooseOptionID(1)
        end

    self.btnSave = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnSave:SetSize(self:GetWide()-30,30)  
        self.btnSave:SetPos(15,210)  
        self.btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        self.btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        self.btnSave.DoClick = function()
            SlownLS.Market:SendEvent("AddZone",{
                nameZone = self.nameZone:GetValue() or "",
                nameNPC = self.nameNPC:GetValue() or "",
                tblPoints = SlownLS.Market.Points or {}
            })

            self:FadeOut(0.2,true)
        end
end

vgui.Register("SlownLS:Market:AddZone",PANEL,"SlownLS:Market:DFrame")