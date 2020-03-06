--[[  
    Addon: Market
    By: SlownLS
]]

-- Intialize
if SERVER then
    util.AddNetworkString( "SlownLS:Market:Events" )
end

-- Function to add event
function SlownLS.Market:AddEvent(strName,funcCallback)
	SlownLS.Market.Events = SlownLS.Market.Events or {}
	
	SlownLS.Market.Events[strName] = funcCallback
end

-- Function to send event
function SlownLS.Market:SendEvent(strName,tblInfos,pPlayer)
    if CLIENT then
        net.Start("SlownLS:Market:Events")
        net.WriteString(strName)
        net.WriteTable(tblInfos or {})
        net.SendToServer()
    else
        if !IsValid(pPlayer) then return end
        
        net.Start("SlownLS:Market:Events")
        net.WriteString(strName)
        net.WriteTable(tblInfos or {})
        net.Send(pPlayer)
    end
end

-- Receive
net.Receive( "SlownLS:Market:Events", function( len, pPlayer )
	local strEventName = net.ReadString()
	local tblInfos = net.ReadTable() or {}

	SlownLS.Market.Events = SlownLS.Market.Events or {}

	if !strEventName then return end
	if !SlownLS.Market.Events[strEventName] then return end

    if SERVER then
	    SlownLS.Market.Events[strEventName](pPlayer,tblInfos)
        return 
    end

    SlownLS.Market.Events[strEventName](tblInfos)
end)