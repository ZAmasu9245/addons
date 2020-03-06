--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self.Label:SetColor(SlownLS.Market:GetColor("text"))
    self.Label:SetMouseInputEnabled(false)

    self.Slider.Paint = function( self, w, h )
        surface.SetDrawColor(SlownLS.Market:GetColor("secondary"))
        surface.DrawRect(0,h/2-2/2,w,2)
    end    

    self.Scratch:SetVisible(false)
    self.TextArea:SetTextColor(SlownLS.Market:GetColor("text"))

    self:UpdatePos()
end

function PANEL:GetContentSize()
	surface.SetFont( self.Label:GetFont() )
	return surface.GetTextSize( self:GetText() )
end

function PANEL:UpdatePos()
    self.Slider:Dock(NODOCK)
    
    local intW, intH = self:GetContentSize()

    self:SetSliderPos(intW+15)
    self:SetSliderWide(self:GetParent():GetWide()-self.TextArea:GetWide()-(intW+30)-30)
end

function PANEL:SetSliderPos(x)
    self.Slider:SetPos(x,self:GetTall()/2-16/2)   
end

function PANEL:SetSliderWide(w)
    self.Slider:SetSize(w,16)   
end

function PANEL:SetDefaultText(strText)
    self:SetText(strText)

    self:UpdatePos()
end

vgui.Register("SlownLS:Market:DNumSlider",PANEL,"DNumSlider")