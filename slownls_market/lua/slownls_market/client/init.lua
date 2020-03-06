--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market.Cart = SlownLS.Market.Cart or {}

-- Fonts
surface.CreateFont( "SlownLS:Market:32", { font = "Roboto", extended = false, size = 32, weight = 500, } )
surface.CreateFont( "SlownLS:Market:24", { font = "Roboto", extended = false, size = 24, weight = 500, } )
surface.CreateFont( "SlownLS:Market:24:B", { font = "Roboto", extended = false, size = 24, weight = 1000, } )
surface.CreateFont( "SlownLS:Market:18", { font = "Roboto", extended = false, size = 18, weight = 500, } )
surface.CreateFont( "SlownLS:Market:18:B", { font = "Roboto", extended = false, size = 18, weight = 1000, } )
surface.CreateFont( "SlownLS:Market:16", { font = "Roboto", extended = false, size = 16, weight = 500, } )
surface.CreateFont( "SlownLS:Market:16:B", { font = "Roboto", extended = false, size = 16, weight = 1000, } )

-- HUDPaint
hook.Add("HUDPaint","SlownLS:Market:HUDPaint",function()
    -- Text
    local ent = LocalPlayer():GetEyeTrace().Entity

    if IsValid(ent) && ent:GetClass() == "slownls_market_item" && ent:GetItemPreview() && ent:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
        if !SlownLS.Market:HasTool() then            
            local intW = 250
            local intH = 40

            surface.SetFont("SlownLS:Market:18")
            local intTextW, intTextH = surface.GetTextSize(SlownLS.Market:GetLanguage('press_r_to_add_to_cart'))

            intW = intTextW + 30

            surface.SetDrawColor(Color(0,0,0,200))
            surface.DrawRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

            surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
            surface.DrawOutlinedRect(ScrW()/2-intW/2,ScrH()/2-intH/2,intW,intH)

            draw.SimpleText(SlownLS.Market:GetLanguage('press_r_to_add_to_cart'),"SlownLS:Market:18",ScrW()/2,ScrH()/2,SlownLS.Market:GetColor('text'),1,1)
        end
    end

    local strZone = SlownLS.Market:IsInZone()

    if !strZone then 
        -- SlownLS.Market.Cart = {} // Remove Cart
        return 
    end

    local tblZone = SlownLS.Market.Zones[strZone] or {}
    local strNPC = tblZone.npc

    SlownLS.Market.Cart[strNPC] = SlownLS.Market.Cart[strNPC] or {}

    local intHeight = 50 + table.Count(SlownLS.Market.Cart[strNPC]) * 24-10
    local intTTPrice = 0

    for k,v in SortedPairs(SlownLS.Market.Cart[strNPC] or {} ) do
        if !IsValid(v.ent) then 
            SlownLS.Market.Cart[strNPC][k] = nil
            continue 
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- VERYLEAKS.CZ
        surface.SetFont( "SlownLS:Market:18" )

        local intTextW, intTextH = surface.GetTextSize( v.ent:GetItemName() .. ' ( x' .. v.amount .. ' )' )

        intTTPrice = intTTPrice + ( v.ent:GetItemPrice() * v.amount )
    end

    if table.Count(SlownLS.Market.Cart[strNPC] or {}) < 1 then
        intHeight = 35
    end
    
    surface.SetDrawColor(SlownLS.Market:GetColor('primary'))
    surface.DrawRect(15,15,300,35)

    surface.SetDrawColor(Color(0,0,0,200))
    surface.DrawRect(15,15,300,intHeight)

    surface.SetDrawColor(SlownLS.Market:GetColor('outline'))
    surface.DrawOutlinedRect(15,15,300,intHeight)

    draw.SimpleText( SlownLS.Market:GetLanguage('cart') .. ": ( " .. DarkRP.formatMoney(intTTPrice) .. " )", "SlownLS:Market:18",25,15+35/2, SlownLS.Market:GetColor('text'),0,1)

    local intMargin = 0

    for k,v in SortedPairs(SlownLS.Market.Cart[tblZone.npc] or {}) do
        if !IsValid(v.ent) then continue end

        draw.SimpleText(v.ent:GetItemName() .. ' ( x' .. v.amount .. ' )',"SlownLS:Market:18",25,50+intMargin + 12,color_white, 0, 1)

        intMargin = intMargin + 24
    end
end)

-- PostDrawTranslucentRenderables
hook.Add("PostDrawTranslucentRenderables","SlownLS:Market:3D2D",function(bDepth,bSkybox)
	if ( bSkybox ) then return end

    if !SlownLS.Market.ConfigModel then return end
    if !IsValid(SlownLS.Market.ConfigModel) then return end


    if !SlownLS.Market.DrawConfigModel then 
        SlownLS.Market.ConfigModel:SetNoDraw(true)
        return 
    else
        SlownLS.Market.ConfigModel:SetNoDraw(false)
    end

    SlownLS.Market:PreviewModel(SlownLS.Market.ConfigModel)
end)

-- Player press
local intLastPress = 0
hook.Add("KeyPress", "SlownLS:Market:Press", function(pPlayer,intKey)
    if intKey == IN_USE && CurTime() > intLastPress then
        intLastPress = CurTime() + 0.2

        local ent = LocalPlayer():GetEyeTrace().Entity

        if !IsValid(ent) then return end
        if ent:GetClass() != "slownls_market_item" then return end
        if !ent:GetItemPreview() then return end

        local strNPC = ent:GetItemNPC()

        local strZone = SlownLS.Market:IsInZone()

        if !strZone then return end

        if strNPC ~= SlownLS.Market.Zones[strZone].npc then return end

        SlownLS.Market.Cart[strNPC] = SlownLS.Market.Cart[strNPC] or {}

        SlownLS.Market.Cart[strNPC][ent:GetItemID()] = SlownLS.Market.Cart[strNPC][ent:GetItemID()] or {}
        SlownLS.Market.Cart[strNPC][ent:GetItemID()].ent = ent
        SlownLS.Market.Cart[strNPC][ent:GetItemID()].amount = (SlownLS.Market.Cart[strNPC][ent:GetItemID()].amount or 0) + 1
	end
end)

-- Receive Zones
SlownLS.Market:AddEvent("receiveZones",function(tblInfos)
    SlownLS.Market.Zones = tblInfos or {}
end)

-- Admin Menu
SlownLS.Market:AddEvent("admin_menu",function(tblInfos)    
    local frame = vgui.Create("SlownLS:Market:Admin_Menu")
        frame:SetZones(SlownLS.Market.Zones)
        frame:Load()
end)