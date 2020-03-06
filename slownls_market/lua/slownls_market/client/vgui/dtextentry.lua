--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetTextColor(SlownLS.Market:GetColor("text"))
    self:SetCursorColor(color_white)
    self:SetDrawLanguageID(false)
    self.labelHeight = 0
end

function PANEL:SetLabel(strText,strFont,colText)
    local parent = self

    if IsValid(self:GetParent()) then
        parent = self:GetParent()
    end

    local intX,intY = self:GetPos()

    surface.SetFont(strFont)
    local intTextW,intTextH = surface.GetTextSize(strText)

    if IsValid(self.label) then self.label:Remove() end

    self.label = vgui.Create("DLabel",parent)
        self.label:SetText(strText)
        self.label:SetPos(intX,intY)
        self.label:SetFont(strFont)
        self.label:SizeToContents()

    self.labelHeight = intTextH
    self:SetPos(intX,intY+(intTextH+10))
end

function PANEL:OnRemove()
    if IsValid(self.label) then self.label:Remove() end
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
    surface.SetDrawColor(SlownLS.Market:GetColor("tertiary"))
    surface.DrawRect(0,0,w,h)

    if ( self.GetPlaceholderText && self.GetPlaceholderColor && self:GetPlaceholderText() && self:GetPlaceholderText():Trim() != "" && self:GetPlaceholderColor() && ( !self:GetText() || self:GetText() == "" ) ) then

        local oldText = self:GetText()

        local str = panel:GetPlaceholderText()
        if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
        str = language.GetPhrase( str )

        self:SetText( str )
        self:DrawTextEntryText( self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor() )
        self:SetText( oldText )

        return
    end

    self:DrawTextEntryText( self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor() )
end

vgui.Register("SlownLS:Market:DTextEntry",PANEL,"DTextEntry")