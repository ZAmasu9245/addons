--[[  
    Addon: Market
    By: SlownLS
]]

function SlownLS.Market:GetConfig(strName)
    return SlownLS.Market.Config[strName]
end

function SlownLS.Market:GetColor(strName)
    return SlownLS.Market.Config.Colors[strName] or color_white
end

function SlownLS.Market:InsideZone(tblPoints,vecPos)
    local boolOddNodes = false
    local j = #tblPoints

    local intH = SlownLS.Market:GetConfig("ZoneHeight") or 80

    for i = 1, #tblPoints do
        if ( tblPoints[i].y < vecPos.y && tblPoints[j].y >= vecPos.y || tblPoints[j].y < vecPos.y && tblPoints[i].y >= vecPos.y ) && vecPos.z <= tblPoints[i].z + intH && tblPoints[i].z && vecPos.z >= tblPoints[i].z - 3 then
            if ( tblPoints[i].x + ( vecPos.y - tblPoints[i].y ) / (tblPoints[j].y - tblPoints[i].y) * (tblPoints[j].x - tblPoints[i].x ) < vecPos.x ) then
                boolOddNodes = !boolOddNodes
            end
        end

        j = i
    end

    return boolOddNodes 
end

-- DarkRP Function :)
function SlownLS.Market:FormatMoney(intNumber)
	if !intNumber then return "" end
	if intNumber >= 1e14 then return tostring(intNumber) end

    intNumber = tostring(intNumber)

    local sep = sep or ","
    local dp = string.find(intNumber, "%.") or #intNumber+1
    
	for i=dp-4, 1, -3 do
		intNumber = intNumber:sub(1, i) .. sep .. intNumber:sub(i+1)
    end

    return intNumber
end

function SlownLS.Market:LerpColor(btn,strName,tblColor,boolTo,intTimeFade)
    btn.tblLerps = btn.tblLerps or {}
    btn.tblLerps[strName] = btn.tblLerps[strName] or {}

    local intTimeLerp = FrameTime() * ( intTimeFade or 5 )
    local default = table.Copy(tblColor.default)
    local to = table.Copy(tblColor.to)

    local tbl = btn.tblLerps[strName]

    tbl.actual = tbl.actual or default

    if !boolTo then
        tbl.actual.r = Lerp(intTimeLerp,tbl.actual.r,default.r)
        tbl.actual.g = Lerp(intTimeLerp,tbl.actual.g,default.g)
        tbl.actual.b = Lerp(intTimeLerp,tbl.actual.b,default.b)
        tbl.actual.a = Lerp(intTimeLerp,tbl.actual.a,default.a)
    else
        tbl.actual.r = Lerp(intTimeLerp,tbl.actual.r,to.r)
        tbl.actual.g = Lerp(intTimeLerp,tbl.actual.g,to.g)
        tbl.actual.b = Lerp(intTimeLerp,tbl.actual.b,to.b)
        tbl.actual.a = Lerp(intTimeLerp,tbl.actual.a,to.a)
    end

    return tbl.actual
end

function SlownLS.Market:IsAdmin(pPlayer)
    return SlownLS.Market.Config.AdminGroups[pPlayer:GetUserGroup()]
end