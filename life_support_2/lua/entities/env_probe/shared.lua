ENT.Type 		= "anim"
ENT.Base 		= "base_rd_entity"
ENT.PrintName 	= "Atmospheric Probe"

local yesno = {}
yesno[0] = "no"
yesno[1] = "yes"

function ENT:GetOverlayText()
	local txt = ""
	
	if (self.OOOActive == 1) then
		txt = self.PrintName.." (ON)\nHabitable: " .. yesno[self.Entity:GetNetworkedInt( 1 )] .. "\nPressure: " .. self.Entity:GetNetworkedInt( 2 ) .. " Atmospheres\nTemperature: " .. self.Entity:GetNetworkedInt( 3 ) .. " K\nGravity: " .. math.floor(self.Entity:GetNetworkedInt( 4 )) .." G"
	else
		txt =  self.PrintName.." (OFF)"
	end
	
	local PlayerName = self:GetPlayerName()
	if ( not game.SinglePlayer() and PlayerName != "") then
		txt = txt .. "\n- " .. PlayerName .. " -"
	end
	
	return txt
end
