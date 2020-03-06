--[[  
    Addon: Market
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetSize(500,490)
    self:Center()
    self:MakePopup()

    local intType = 1

    self:SetHeader("Edit Item",60,true)

    local tblNpcs = {}

    for k,v in pairs(ents.GetAll() or {}) do
        if !IsValid(v) then continue end
        if v:GetClass() != "slownls_market_npc" then continue end

        table.insert(tblNpcs,v)
    end

    local function checkFood(intType)
        if intType != 3 then
            self:SetSize(500,490)

            if IsValid(self.nameNPC) then
                self.nameNPC:SetPos(15,70+(self.nameEntity:GetHeight()+15)*4)
                self.nameNPC:UpdateLabel()
            end
            
            if IsValid(self.btnSave) then
                self.btnSave:SetPos(15,70+(self.nameEntity:GetHeight()+15)*5)
            end

            if IsValid(self.btnDelete) then
                self.btnDelete:SetPos(15,70+(self.nameEntity:GetHeight()+15)*5+45)
            end

            if IsValid(self.energyEntity) then 
                self.energyEntity:Remove()
            end

            if IsValid(self.classEntity) then
                if self.classEntity.oldValue then
                    self.classEntity:SetValue(self.classEntity.oldValue)
                    self.classEntity.oldValue = nil
                end
                self.classEntity:SetDisabled(false)
            end

            return
        end

        if !IsValid(self.nameNPC) then return end

        self:SetSize(500,555)

        self.energyEntity = vgui.Create("SlownLS:Market:DTextEntry",self)
            self.energyEntity:SetSize(self:GetWide()-30,25)
            self.energyEntity:SetPos(15,70+(self.nameEntity:GetHeight()+15)*4)
            self.energyEntity:SetLabel(SlownLS.Market:GetLanguage('energy_of_entity'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))  
            self.energyEntity:SetNumeric(true)
            self.energyEntity:SetValue(self:GetEntity():GetItemEnergy() or 0 )

        self.nameNPC:SetPos(15,70+(self.nameEntity:GetHeight()+15)*5)
        self.nameNPC:UpdateLabel()
        
        self.classEntity.oldValue = self.classEntity:GetValue()
        self.classEntity:SetValue('spawned_food')
        self.classEntity:SetDisabled(true)

        self.btnSave:SetPos(15,70+(self.nameEntity:GetHeight()+15)*6)
        self.btnDelete:SetPos(15,70+(self.nameEntity:GetHeight()+15)*6+45)
    end

    self.nameEntity = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.nameEntity:SetSize(self:GetWide()-30,25)
        self.nameEntity:SetPos(15,75)
        self.nameEntity:SetLabel(SlownLS.Market:GetLanguage('name_of_entity'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))

    self.classEntity = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.classEntity:SetSize(self:GetWide()-30,25)
        self.classEntity:SetPos(15,70+self.nameEntity:GetHeight()+15)
        self.classEntity:SetLabel(SlownLS.Market:GetLanguage('class_of_entity'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))   

    self.priceEntity = vgui.Create("SlownLS:Market:DTextEntry",self)
        self.priceEntity:SetSize(self:GetWide()-30,25)
        self.priceEntity:SetPos(15,70+(self.nameEntity:GetHeight()+15)*2)
        self.priceEntity:SetLabel(SlownLS.Market:GetLanguage('price_of_entity'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))  
        self.priceEntity:SetNumeric(true)

    self.typeEntity = vgui.Create("SlownLS:Market:DComboBox",self)
        self.typeEntity:SetSize(self:GetWide()-30,25)
        self.typeEntity:SetPos(15,70+(self.nameEntity:GetHeight()+15)*3)
        self.typeEntity:SetValue("")  
        self.typeEntity:SetLabel(SlownLS.Market:GetLanguage('type_of_entity'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))   
        for k,v in ipairs(SlownLS.Market.Config.Types or {}) do
            self.typeEntity:AddChoice(v.name,k)
        end
        function self.typeEntity:OnSelect(i,s,d)
            intType = self:GetOptionData(i)

            checkFood(intType)
        end
        self.typeEntity:ChooseOptionID(1)

    self.nameNPC = vgui.Create("SlownLS:Market:DComboBox",self)
        self.nameNPC:SetSize(self:GetWide()-30,25)
        self.nameNPC:SetPos(15,70+(self.nameEntity:GetHeight()+15)*4)
        self.nameNPC:SetLabel(SlownLS.Market:GetLanguage('config_weapon_name_of_npc'),"SlownLS:Market:16",SlownLS.Market:GetColor("text"))   
        for k,v in SortedPairs(tblNpcs or {}) do
            if !IsValid(v) then continue end
            self.nameNPC:AddChoice(v:GetNPCName())
        end
        if table.Count(tblNpcs or {}) > 0 then
            self.nameNPC:ChooseOptionID(1)
        end

    self.btnSave = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnSave:SetSize(self:GetWide()-30,30)  
        self.btnSave:SetPos(15,70+(self.nameEntity:GetHeight()+15)*5)
        self.btnSave:SetDefaultText(SlownLS.Market:GetLanguage('save'))
        self.btnSave:SetBackgroundColor(SlownLS.Market:GetColor('green'),SlownLS.Market:GetColor('green2'))
        self.btnSave.DoClick = function()
            local intEnergy = 0
            if IsValid(self.energyEntity) then
                intEnergy = tonumber(self.energyEntity:GetValue())
            end

            SlownLS.Market:SendEvent("EditItem",{
                nameEntity = self.nameEntity:GetValue() or "",
                classEntity = self.classEntity:GetValue() or "",
                priceEntity = self.priceEntity:GetValue() or 0,
                typeEntity = intType or 0,
                npcName = self.nameNPC:GetValue() or "",
                energy = intEnergy or 0,
                ent = self:GetEntity()
            })

            self:FadeOut(0.2,true)
        end

    self.btnDelete = vgui.Create("SlownLS:Market:DButton",self)  
        self.btnDelete:SetSize(self:GetWide()-30,30)  
        self.btnDelete:SetPos(15,70+(self.nameEntity:GetHeight()+15)*5+45)
        self.btnDelete:SetDefaultText(SlownLS.Market:GetLanguage('delete'))
        self.btnDelete:SetBackgroundColor(SlownLS.Market:GetColor('red'),SlownLS.Market:GetColor('red2'))
        self.btnDelete.DoClick = function()
            SlownLS.Market:SendEvent("DeleteItem",{ent=self:GetEntity()})

            self:FadeOut(0.2,true)
        end

    timer.Simple(0.2,function()
        if !IsValid(self) then return end
        if !IsValid(self:GetEntity()) then return end

        self.nameEntity:SetValue(self:GetEntity():GetItemName() or 0)
        self.classEntity:SetValue(self:GetEntity():GetItemClass() or 0)
        self.priceEntity:SetValue(self:GetEntity():GetItemPrice() or 0)
        self.nameNPC:SetValue(self:GetEntity():GetItemNPC() or 0)
        self.typeEntity:ChooseOptionID(self:GetEntity():GetItemType())
    end)
end

function PANEL:SetEntity(ent)
    self.ent = ent
end

function PANEL:GetEntity()
    return self.ent
end

vgui.Register("SlownLS:Market:AddItem_Edit",PANEL,"SlownLS:Market:DFrame")