--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self.labelHeight = 0

    self:SetTextColor(color_white)
    self:SetSortItems(false)    

    self.colOutline = SlownLS.Market:GetColor('text')
end

function PANEL:SetLabel(strText,strFont,colText)
    local parent = self

    if IsValid(self:GetParent()) then
        parent = self:GetParent()
    end

    local intX,intY = self:GetPos()

    surface.SetFont(strFont)
    local intTextW,intTextH = surface.GetTextSize(strText)

    self.label = vgui.Create("DLabel",parent)
        self.label:SetText(strText)
        self.label:SetPos(intX,intY)
        self.label:SetFont(strFont)
        self.label:SizeToContents()

    self.labelHeight = intTextH
    self:SetPos(intX,intY+(intTextH+10))
end

function PANEL:UpdateLabel()
    if !IsValid(self.label) then return end

    local intX,intY = self:GetPos()

    self.label:SetPos(intX,intY)

    self:SetPos(intX,intY+(self.labelHeight+10))    
end 

function PANEL:GetHeight()
    if !self.label || !IsValid(self.label) then
        return self:GetTall()
    end

    return self.labelHeight + 10 + self:GetTall()
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(SlownLS.Market:GetColor('secondary'))
    surface.DrawRect(0,0,w,h)

    if self:IsMenuOpen() then        
        surface.SetDrawColor(SlownLS.Market:GetColor('text'))
        surface.DrawOutlinedRect(0,0,w,h)    
    end
end

function PANEL:DoClick()
	if self:IsMenuOpen() then
		return self:CloseMenu()
	end

    self:OpenMenu()
    
    if !self.Menu then return end

    -- Elements painting
    for k, v in pairs(self.Menu:GetCanvas():GetChildren() or {}) do
        v:SetTextColor(color_white)

        function v:Paint(w, h)
            surface.SetDrawColor(SlownLS.Market:GetColor('text'))
            surface.DrawOutlinedRect(0,-1,w,h+1)

            local col = SlownLS.Market:LerpColor(self,"background",{ default = Color(0,0,0,0), to = SlownLS.Market:GetColor('red') },self:IsHovered())

            surface.SetDrawColor(col)
            surface.DrawRect(1,1,w-2,h-2)
        end
    end

    -- Menu
    function self.Menu:Paint(w,h)
        surface.SetDrawColor(SlownLS.Market:GetColor('secondary'))
        surface.DrawRect(0,0,w,h)
    end
end

vgui.Register("SlownLS:Market:DComboBox",PANEL,"DComboBox")