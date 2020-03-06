--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetText('')
    self:SetFont('SlownLS:Market:18')
    self:SetTextColor(color_white)

    self.tblBackground = {
        default = SlownLS.Market:GetColor("secondary"),
        to = SlownLS.Market:GetColor("secondary125")
    }
end 

function PANEL:SetDefaultText(strText)
    self.strText = strText
end

function PANEL:SetBackgroundColor(colDefault,colTo)
    self.tblBackground.default = colDefault
    self.tblBackground.to = colTo or colDefault
end

function PANEL:Paint(w,h)
    local col = SlownLS.Market:LerpColor(self,"background",{default = self.tblBackground.default, to = self.tblBackground.to},self:IsHovered())

    surface.SetDrawColor(col)
    surface.DrawRect(0,0,w,h)

    draw.SimpleText(self.strText,self:GetFont(),w/2,h/2,self:GetTextColor(),1,1)
end

vgui.Register("SlownLS:Market:DButton",PANEL,"DButton")