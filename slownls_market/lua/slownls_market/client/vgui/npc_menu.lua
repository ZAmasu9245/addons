--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(870,570)
    self:Center()
    self:MakePopup()
end

function PANEL:Load()
    local strName = self:GetEntity():GetNPCName()

    local tbl = {}

    if SlownLS.Market.Cart[strName] then
        tbl = SlownLS.Market.Cart[strName]
    end

    local pList = vgui.Create("DScrollPanel",self)
        pList:SetSize(self:GetWide()/2-15,self:GetTall()-90)
        pList:SetPos(15,75)
        pList.VBar:SetHideButtons(true)
        pList.VBar:SetWide(10)
        pList.VBar.intH = 0
        pList.VBar.intLerp = 0
        local pnlVBar = pList:GetVBar()
        function pnlVBar:Paint(w, h)
            draw.RoundedBox(8,0,0,w,h,SlownLS.Market:GetColor("secondary"))

            draw.RoundedBox(8,0,self.intLerp - 1, w, self.intH + 2,SlownLS.Market:GetColor("red"))
        end        
        function pnlVBar.btnGrip:Paint(w, h)
            pnlVBar.intH = h

            local Scroll = pnlVBar:GetScroll() / pnlVBar.CanvasSize
            local BarSize = math.max( pnlVBar:BarScale() * ( pnlVBar:GetTall() ), 10 )
            local Track = pnlVBar:GetTall() - BarSize
            Track = Track + 1

            pnlVBar.intLerp = Lerp(RealFrameTime() * 4, pnlVBar.intLerp, Scroll * Track)
        end

    local function getLastKey()
        local intLast = 0

        for k,v in pairs(tbl or {}) do
            if k > intLast then
                intLast = k
            end
        end
        
        return intLast
    end

    local intLastKey = getLastKey()

    local intMargin = 0

    if table.Count(tbl or {}) > 6 then
        intMargin = 20
    end

    for k,v in SortedPairs(tbl or {}) do
        if !IsValid(v.ent) then continue end

        local p = vgui.Create("DPanel",pList)
            p:SetSize(pList:GetWide(),80)
            p:Dock(TOP)
            if intMargin > 1 then
                p:DockMargin(0,0,intMargin/2,0)
            end
            function p:Paint(w,h)
                if !IsValid(v.ent) then 
                    p:Remove()
                    return 
                end

                if k != intLastKey then                    
                    surface.SetDrawColor(SlownLS.Market:GetColor('text'))
                    surface.DrawRect(0,h-1,w,1)
                end

                draw.SimpleText(v.ent:GetItemName(),"SlownLS:Market:18:B",64+15,h/2-10,SlownLS.Market:GetColor('text'),0,1)
                draw.SimpleText(DarkRP.formatMoney(v.ent:GetItemPrice()*v.amount),"SlownLS:Market:16",64+15,h/2+10,SlownLS.Market:GetColor('text'),0,1)

                local intW2 = 125
                local intH2 = 38
                local intX = w-70-(intW2/2)
                local intY = h/2-intH2/2

                draw.RoundedBox(18,intX,intY,intW2,intH2,SlownLS.Market:GetColor('text'))
                draw.RoundedBox(18,intX+1,intY+1,intW2-2,intH2-2,SlownLS.Market:GetColor('primary'))

                draw.SimpleText(v.amount,"SlownLS:Market:18",w-70,h/2,SlownLS.Market:GetColor('text'),1,1)
            end

        local pModel = vgui.Create("SpawnIcon",p)
            pModel:SetSize(64,64)
            pModel:SetPos(0,p:GetTall()/2-64/2)
            pModel:SetModel(v.ent:GetModel())
            pModel:SetToolTip()
            function pModel:OnMousePressed() end
            function pModel:IsHovered() end

        local btnMore = vgui.Create("DButton",p)
            btnMore:SetSize(18,18)
            btnMore:SetPos(p:GetWide()-25-btnMore:GetWide()-intMargin,p:GetTall()/2-btnMore:GetTall()/2)
            btnMore:SetFont('SlownLS:Market:18')
            btnMore:SetText('+')
            btnMore:SetTextColor(SlownLS.Market:GetColor('text'))
            btnMore.Paint = nil
            btnMore.DoClick = function(p)
                SlownLS.Market.Cart[strName][k].amount = SlownLS.Market.Cart[strName][k].amount + 1
            end

        local btnLess = vgui.Create("DButton",p)
            btnLess:SetSize(18,18)
            btnLess:SetPos(p:GetWide()-95-btnLess:GetWide()-intMargin,p:GetTall()/2-btnLess:GetTall()/2-2)
            btnLess:SetFont('SlownLS:Market:18')
            btnLess:SetText('-')
            btnLess:SetTextColor(SlownLS.Market:GetColor('text'))
            btnLess.Paint = nil
            btnLess.DoClick = function()
                if SlownLS.Market.Cart[strName][k].amount > 1 then
                    SlownLS.Market.Cart[strName][k].amount = SlownLS.Market.Cart[strName][k].amount - 1
                else
                    p:Remove()
                    SlownLS.Market.Cart[strName][k] = nil
                    intLastKey = getLastKey()
                end
            end    
    end

    local pModel = vgui.Create("DModelPanel",self)
        pModel:SetModel(self:GetEntity():GetModel())
        pModel:SetSize(self:GetWide()-(self:GetWide()/2+15)-15,self:GetTall()/2-45)
        pModel:SetPos(self:GetWide()/2+15,75)
        function pModel:LayoutEntity( Entity ) return end
        local head = pModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
        if head then            
            local headpos = pModel.Entity:GetBonePosition( pModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
            if headpos then            
                pModel:SetLookAt( headpos )
                pModel:SetCamPos( headpos-Vector( -26, 0, 0 ) )
            end
        else
            local mn, mx = pModel.Entity:GetRenderBounds()
            local size = 0
            size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
            size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
            size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

            pModel:SetFOV( 45 )
            pModel:SetCamPos( Vector( size, size, size ) )
            pModel:SetLookAt( ( mn + mx ) * 0.5 )
        end

    function self:PaintOver(w,h)
        if table.Count(tbl or {}) < 1 then            
            surface.SetDrawColor(SlownLS.Market:GetColor("text"))
            surface.DrawRect(w/2,75,1,h-75-15)

            draw.DrawText(SlownLS.Market:GetLanguage('cart_empty'),"SlownLS:Market:24",w/4,h/2,SlownLS.Market:GetColor("text"),1,1)
        end

        local intTTPrice = 0

        for k,v in pairs(tbl or {} ) do
            if !IsValid(v.ent) then continue end

            intTTPrice = intTTPrice + ( v.ent:GetItemPrice() * v.amount )
        end

        surface.SetFont("SlownLS:Market:24")
        local intW, intH = surface.GetTextSize(string.format(SlownLS.Market:GetLanguage('total_price'),SlownLS.Market:FormatMoney(10000)))

        surface.SetDrawColor(SlownLS.Market:GetColor("text"))
        surface.DrawRect(w/2+15,h/2+30,w-(w/2+15)-15,1)

        draw.DrawText(
            string.format(SlownLS.Market:GetLanguage('total_price'),SlownLS.Market:FormatMoney(intTTPrice)),
            "SlownLS:Market:24",
            (w/2+15)+(w/2+15)/2-15,
            h/1.5+30-intH/2,
            SlownLS.Market:GetColor("text"),
            1
        )
    end

    local btnAccept = vgui.Create("SlownLS:Market:DButton",self)
    btnAccept:SetSize(self:GetWide()-(self:GetWide()/2+15)-15,35)
    btnAccept:SetPos(self:GetWide()/2+15,self:GetTall()-btnAccept:GetTall()-15)
    btnAccept:SetBackgroundColor(SlownLS.Market:GetColor("green"),SlownLS.Market:GetColor("green2"))
    btnAccept:SetDefaultText(SlownLS.Market:GetLanguage('buy'))
    btnAccept.DoClick = function()
        SlownLS.Market:SendEvent('npc_buy',{
            ent = self:GetEntity(),
            cart = tbl
        })

        self:FadeOut(0.2,true)
    end
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:NPC_Menu",PANEL,"SlownLS:Market:DFrame")