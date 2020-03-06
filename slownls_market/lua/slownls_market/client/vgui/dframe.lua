--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(500,300)
    self:Center()
    self:FadeIn(0.2)
end

function PANEL:SetHeader(strHeader,intHeight,bool)
    self.tblHeader = {
        text = strHeader,
        height = intHeight
    }

    if bool then       
        self:ShowCloseButton(false)

        local btnClose = vgui.Create("DButton",self)
            btnClose:SetSize(32,32)
            btnClose:SetPos(self:GetWide() - btnClose:GetWide() - 15,intHeight/2-btnClose:GetTall()/2)
            btnClose:SetText('')
            btnClose.Paint = function(btn,w,h)
                local col = SlownLS.Market:LerpColor(btn,"background",{default = SlownLS.Market:GetColor("red"), to = SlownLS.Market:GetColor("red2")},btn:IsHovered())

                draw.RoundedBox(32,0,0,w,h,col)

                draw.SimpleText("X","SlownLS:Market:16",w/2,h/2,color_white,1,1)
            end
            btnClose.DoClick = function()
                self:FadeOut(0.2,true)
            end

        self.btnClose_ = btnClose
    end
end

function PANEL:DrawHeader(w,h)
    if !self.tblHeader then return end

    surface.SetDrawColor(SlownLS.Market:GetColor("secondary"))
    surface.DrawRect(0,0,w,self.tblHeader.height)

    draw.SimpleText(self.tblHeader.text,"SlownLS:Market:18:B",15,self.tblHeader.height/2,SlownLS.Market:GetColor("text"),0,1)
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
    surface.DrawRect(0,0,w,h)

    self:DrawHeader(w,h)
end

function PANEL:UnPopup()
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
end

function PANEL:FadeIn(intTime,funcCallback)
    self:SetAlpha(0)
    self:AlphaTo(255,intTime,0,funcCallback)
end

function PANEL:FadeOut(intTime,boolClose,cb)
    if boolClose then
        self:UnPopup()
    end

    self:AlphaTo(0,intTime,0,function()
        if cb then cb() end
        if boolClose then self:Remove() end
    end)
end

vgui.Register("SlownLS:Market:DFrame",PANEL,"DFrame")