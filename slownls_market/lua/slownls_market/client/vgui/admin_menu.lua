--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(500,500)
    self:Center()
    self:MakePopup()
    self.tblZones = {}
end

function PANEL:OpenEditZone(strKey)
    local frame = vgui.Create("SlownLS:Market:DFrame")
        frame:SetSize(500,250)
        frame:Center()
        frame:MakePopup()
        frame:SetHeader('SlownLS Market | Edit Zone',60,{})

    local tblZone = SlownLS.Market.Zones[strKey]

    if !tblZone then
        frame:Remove()
        return
    end

    local tblNpcs = {}

    for k,v in pairs(ents.GetAll() or {}) do
        if !IsValid(v) then continue end
        if v:GetClass() != "slownls_market_npc" then continue end

        table.insert(tblNpcs,v)
    end

    local nameZone = vgui.Create("SlownLS:Market:DTextEntry",frame)
        nameZone:SetSize(frame:GetWide()-30,25)
        nameZone:SetPos(15,75)
        nameZone:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_zone'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))
        nameZone:SetValue(strKey)

    local nameNPC = vgui.Create("SlownLS:Market:DComboBox",frame)
        nameNPC:SetSize(frame:GetWide()-30,25)
        nameNPC:SetPos(15,75+(nameZone:GetHeight()+15)*1)
        nameNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))   
        for k,v in SortedPairs(tblNpcs or {}) do
            local intId = nameNPC:AddChoice(v:GetNPCName())

            if v:GetNPCName() == tblZone.npc then
                nameNPC:ChooseOptionID(intId)
            end
        end

    local btnSave = vgui.Create("SlownLS:Market:DButton",frame)  
        btnSave:SetSize(frame:GetWide()-30,30)  
        btnSave:SetPos(15,75+(nameZone:GetHeight()+15)*2)
        btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        btnSave.DoClick = function()
            SlownLS.Market:SendEvent("EditZone",{
                key = strKey,
                name = nameZone:GetValue() or "",
                npc = nameNPC:GetValue() or "",
            })

            frame:FadeOut(0.2,true)
        end
end

function PANEL:Load()
    self:SetHeader('SlownLS Market | Zones',60,{})
    
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

        for k,v in pairs(self.tblZones or {}) do
            intLast = k
        end
        
        return intLast
    end

    local intLastKey = getLastKey()
    local intMargin = 0

    if table.Count(tbl or {}) > 6 then
        intMargin = 20
    end

    for k,v in pairs(self.tblZones or {}) do
        local p = vgui.Create("DPanel",pList)
            p:SetSize(pList:GetWide(),80)
            p:Dock(TOP)
            if intMargin > 0 then
                p:DockMargin(0,0,intMargin/2,0)
            end
            function p:Paint(w,h)
                if k != intLastKey then                    
                    surface.SetDrawColor(SlownLS.Market:GetColor('text'))
                    surface.DrawRect(0,h-1,w,1)
                end

                draw.SimpleText(k,"SlownLS:Market:18:B",0,h/2-10,SlownLS.Market:GetColor('text'),0,1)
                draw.SimpleText(v.npc,"SlownLS:Market:16",0,h/2+10,SlownLS.Market:GetColor('text'),0,1)
            end

        local btnDelete = vgui.Create("SlownLS:Market:DButton",p)
            btnDelete:SetSize(100,30)
            btnDelete:SetPos(p:GetWide()-btnDelete:GetWide()-intMargin-15,p:GetTall()/2-btnDelete:GetTall()/2)
            btnDelete:SetDefaultText(SlownLS.Market:GetLanguage('delete'))
            btnDelete:SetBackgroundColor(SlownLS.Market:GetColor('red'),SlownLS.Market:GetColor('red2'))
            btnDelete.DoClick = function()
                SlownLS.Market:SendEvent('DeleteZone',{key=k})
                self.tblZones[k] = nil 

                intLastKey = getLastKey()
                p:Remove()
            end 

        local btnEdit = vgui.Create("SlownLS:Market:DButton",p)
            btnEdit:SetSize(100,30)
            btnEdit:SetPos(p:GetWide()-btnDelete:GetWide()-btnEdit:GetWide()-intMargin-30,p:GetTall()/2-btnDelete:GetTall()/2)
            btnEdit:SetDefaultText(SlownLS.Market:GetLanguage('edit'))
            btnEdit:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
            btnEdit.DoClick = function()
                self:OpenEditZone(k)
                self:FadeOut(0.2,true)
            end 
    end
end

function PANEL:SetZones(tbl)
    self.tblZones = tbl or {}
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:Admin_Menu",PANEL,"SlownLS:Market:DFrame")