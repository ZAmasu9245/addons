--[[  
    Addon: Market
    By: SlownLS
]]

function SlownLS.Market:HasTool()
    local entWep = LocalPlayer():GetActiveWeapon()

    if !IsValid(entWep) then return false end
    if entWep:GetClass() != "gmod_tool" then return false end
    if !LocalPlayer():GetTool() then return false end
    if LocalPlayer():GetTool().Mode != "slownls_market_additem" then return false end

    return true 
end

function SlownLS.Market:IsInZone()
    local bool = false 

    for k,v in pairs(SlownLS.Market.Zones or {}) do
        if SlownLS.Market:InsideZone(v.points,LocalPlayer():GetPos()) then
            bool = k
        end
    end

    return bool
end

function SlownLS.Market:PreviewModel(ent)
    if !IsValid(ent) then return end

    local intW = 300
    local intH = 90

    local vecOBBMins,vecOBBMaxs = ent:GetRenderBounds()
    local vecOBBCenter = ent:OBBCenter()

    local vecConfigPos = ent.configPos or Vector(0,0,0)
    local angConfigAng = ent.configAng or Angle(0,0,70)
    local strName = "Item name"
    local intPrice = 1000

    if ent.GetItemPos then
        vecConfigPos = ent:GetItemPos()
    end
    if ent.GetItemAng then
        angConfigAng = ent:GetItemAng()
    end
    if ent.GetItemName then
        strName = ent:GetItemName()
    end
    if ent.GetItemPrice then
        intPrice = ent:GetItemPrice()
    end

    local vecPos = ent:GetPos() + Vector(0,vecOBBCenter.y,vecOBBMins.z) + vecConfigPos
    local angPos = angConfigAng

    cam.Start3D2D(vecPos,angPos,0.05)
        surface.SetDrawColor(Color(0,0,0,200))
        surface.DrawRect(-intW/2,-intH,intW,intH)

        surface.SetDrawColor(SlownLS.Market:GetColor("primary"))
        surface.DrawOutlinedRect(-intW/2,-intH,intW,intH)

        draw.SimpleText(strName,"SlownLS:Market:24",0,-intH/2-15,color_white,1,1)
        draw.SimpleText(SlownLS.Market:GetLanguage('price') .. ": " .. DarkRP.formatMoney(intPrice),"SlownLS:Market:16",0,-intH/2+15,color_white,1,1)
    cam.End3D2D()
end