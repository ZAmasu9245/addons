--[[  
    Addon: Builder
    For: Undertale
    By: SlownLS ( www.g-core.fr )
]]

SlownLS.Market.Points = {}

TOOL.Category = "SlownLS Market"
TOOL.Name = "#tool.slownls_market_addzone.name"
TOOL.Information = {
	{ name = "left", },
	{ name = "right" },
	{ name = "reload" }
}

function TOOL:OpenConfig()
    if SERVER then return end
    
    if IsValid(self.configMenu) then self.configMenu:Remove() end

    self.configMenu = vgui.Create("SlownLS:Market:AddZone")
end

function TOOL:Holster()
    if SERVER then return end

    SlownLS.Market.Points = {}
end

function TOOL:LeftClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end
    if self.intNextLeft && CurTime() < self.intNextLeft then return end

    SlownLS.Market.Points = SlownLS.Market.Points or {}

    local vecHitPos = tr.HitPos

    SlownLS.Market.Points[#SlownLS.Market.Points+1] = vecHitPos

    self.intNextLeft = CurTime() + 0.2
end
 
function TOOL:RightClick(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end
    if self.intNextRight && CurTime() < self.intNextRight then return end

    SlownLS.Market.Points = SlownLS.Market.Points or {}

    if !SlownLS.Market.Points[#SlownLS.Market.Points] then return end

    SlownLS.Market.Points[#SlownLS.Market.Points] = nil 

    self.intNextRight = CurTime() + 0.2
end
 
function TOOL:Reload(tr)
    if SERVER then return end
    if !SlownLS.Market:IsAdmin(LocalPlayer()) then return end
    
	if !self.intNextReload || CurTime() > self.intNextReload then
        if table.Count(SlownLS.Market.Points or {}) < 2 then
            notification.AddLegacy(SlownLS.Market:GetLanguage("invalid_zone"),1,5)
        else
            self:OpenConfig()
        end

		self.intNextReload = CurTime() + 1
	end
end


if SERVER then return end

language.Add("tool.slownls_market_addzone.name","Create Zone")
language.Add("tool.slownls_market_addzone.desc","Create zone.")
language.Add("tool.slownls_market_addzone.right",SlownLS.Market:GetLanguage("config_weapon_secondary"))
language.Add("tool.slownls_market_addzone.left",SlownLS.Market:GetLanguage("config_weapon_primary"))
language.Add("tool.slownls_market_addzone.reload",SlownLS.Market:GetLanguage("config_weapon_reload"))

function TOOL:DrawHUD() 
    cam.Start3D( EyePos(), EyeAngles() )
        local intLigne = 1
        local intHeight = SlownLS.Market:GetConfig("ZoneHeight") or 80
        
        for k,v in pairs(SlownLS.Market.Points or {} ) do
            if !SlownLS.Market.Points[intLigne+1] then continue end

            render.DrawLine(SlownLS.Market.Points[intLigne],SlownLS.Market.Points[intLigne+1],Color(0,255,0),false)
            render.DrawLine(SlownLS.Market.Points[intLigne] + Vector(0,0,intHeight),SlownLS.Market.Points[intLigne+1] + Vector(0,0,intHeight),Color(255,0,0),false)
            render.DrawLine(SlownLS.Market.Points[intLigne],SlownLS.Market.Points[intLigne] + Vector(0,0,intHeight),Color(0,0,255),false)

            intLigne = intLigne + 1
        end
    cam.End3D()    
end