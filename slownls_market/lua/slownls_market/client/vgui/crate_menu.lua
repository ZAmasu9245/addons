--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(500,410)
    self:Center()
    self:MakePopup()
end

function PANEL:Load(tbl)
    local pList = vgui.Create("DScrollPanel",self)
        pList:SetSize(self:GetWide()-30,self:GetTall()-90)
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

    for k,v in SortedPairs(tbl or {}) do
        local intMargin = 0

        local p = vgui.Create("DPanel",pList)
            p:SetSize(pList:GetWide(),80)
            p:Dock(TOP)
            if table.Count(tbl or {}) > 4 then
                p:DockMargin(0,0,10,0)
                intMargin = 25
            end
            function p:Paint(w,h)
                if k != intLastKey then                    
                    surface.SetDrawColor(SlownLS.Market:GetColor('text'))
                    surface.DrawRect(0,h-1,w,1)
                end

                draw.SimpleText(v.name,"SlownLS:Market:18:B",64+15,h/2-10,SlownLS.Market:GetColor('text'),0,1)
                draw.SimpleText(SlownLS.Market:GetLanguage('amount') .. ": " .. v.amount,"SlownLS:Market:16",64+15,h/2+10,SlownLS.Market:GetColor('text'),0,1)
            end

        local pModel = vgui.Create("SpawnIcon",p)
            pModel:SetSize(64,64)
            pModel:SetPos(0,p:GetTall()/2-64/2)
            pModel:SetModel(v.model)
            pModel:SetToolTip()
            function pModel:OnMousePressed() end
            function pModel:IsHovered() end   

        local btnSpawn = vgui.Create("SlownLS:Market:DButton",p)
            btnSpawn:SetSize(100,30)
            btnSpawn:SetPos(p:GetWide()-btnSpawn:GetWide()-intMargin,p:GetTall()/2-btnSpawn:GetTall()/2)
            btnSpawn:SetDefaultText(SlownLS.Market:GetLanguage('spawn'))
            btnSpawn:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
            btnSpawn.DoClick = function()
                if v.amount == 1 then
                    p:Remove()
                    tbl[k] = nil 
                else
                    tbl[k].amount = tbl[k].amount - 1
                end

                if table.Count(tbl or {}) < 1 then
                    self:Remove()
                end

                SlownLS.Market:SendEvent('crate_spawn',{ent=self:GetEntity(),key=k})
            end
    end
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:Crate_Menu",PANEL,"SlownLS:Market:DFrame")