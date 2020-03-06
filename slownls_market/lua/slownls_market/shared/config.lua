--[[  
    Addon: Market
    By: SlownLS
]]

SlownLS.Market.Config = {}

-- Language
SlownLS.Market.Config.Language = "en"

-- Max zone height
SlownLS.Market.Config.ZoneHeight = 100

-- Crate Model
SlownLS.Market.Config.CrateModel = "models/props_junk/wood_crate001a.mdl"

-- Admin groups
SlownLS.Market.Config.AdminGroups = {
    ["superadmin"] = true,
    ["admin"] = true
}

-- Open config menu
SlownLS.Market.Config.ConfigMenu = {
    cmd = "!smarket"
}

-- Colors
SlownLS.Market.Config.Colors = {
    primary = Color(32,32,32),
    secondary = Color(36,36,36),
    
    secondary125 = Color(28,28,28,125),
    tertiary = Color(28,28,28,200),
    
    blue = Color(41,128,185),

    red = Color(190,71,71),
    red2 = Color(190,71,71,150),

    green = Color(29, 131, 72),
    green2 = Color(35, 155, 86),

    text = Color(188,188,188),
    outline = Color(44,44,44),    
}

-- Types of entities // Don't touch!
SlownLS.Market.Config.Types = {
    [1] = {name = "Entity"},
    [2] = {name = "Weapon"},
    [3] = {name = "Food"}
}