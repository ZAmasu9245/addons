--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market.Languages = SlownLS.Market.Languages or {}

function SlownLS.Market:AddLanguage(strName,tbl)
    SlownLS.Market.Languages = SlownLS.Market.Languages or {}

    SlownLS.Market.Languages[strName] = tbl
end

function SlownLS.Market:GetLanguage(strName)
    local strCurrent = SlownLS.Market:GetConfig("Language")

    if !SlownLS.Market.Languages[strCurrent] then return "nil" end

    return SlownLS.Market.Languages[strCurrent][strName] or "nil"
end