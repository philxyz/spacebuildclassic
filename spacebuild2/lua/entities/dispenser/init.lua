AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
util.PrecacheSound( "ambient.steam01" )

include('shared.lua')

local Ground = 1 + 0 + 2 + 8 + 32

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.damaged = 0
	if not (WireAddon == nil) then
		self.WireDebugName = self.PrintName
	end
end

function ENT:Damage()
	if (self.damaged == 0) then self.damaged = 1 end
end

function ENT:Repair()
	self.Entity:SetColor(Color(255, 255, 255, 255))
	self.health = self.max_health
	self.damaged = 0
end

function ENT:Destruct()
	LS_Destruct( self.Entity, true )
end

local function quiet_steam(ent)
	ent:StopSound( "ambient.steam01" )
end

function ENT:SetActive( value, caller )
	self.air = RD_GetResourceAmount(self.Entity, "air")
	self.energy = RD_GetResourceAmount(self.Entity, "energy")
	self.coolant = RD_GetResourceAmount(self.Entity, "coolant")
	
	if ( (2000 - caller.suit.air) < self.air ) then
		RD_ConsumeResource(self.Entity, "air", 2000 - caller.suit.air)
		caller.suit.air = 2000
	elseif (self.air > 0) then
		caller.suit.air = caller.suit.air + self.air 
		RD_ConsumeResource(self.Entity, "air", self.air)
	end
	if ( (2000 - caller.suit.energy) < self.energy ) then
		RD_ConsumeResource(self.Entity, "energy", 2000 - caller.suit.energy)
		caller.suit.energy = 2000
	elseif (self.energy > 0) then
		caller.suit.energy = caller.suit.energy + self.energy 
		RD_ConsumeResource(self, "energy", self.energy)
	end
	if ( (2000 - caller.suit.coolant) < self.coolant ) then
		RD_ConsumeResource(self.Entity, "coolant", 2000 - caller.suit.coolant)
		caller.suit.coolant = 2000
	elseif (self.coolant > 0) then
		caller.suit.coolant = caller.suit.coolant + self.coolant
		RD_ConsumeResource(self.Entity, "energy", self.coolant)
	end
	caller:EmitSound( "ambient.steam01" )
	timer.Simple(3, function() quiet_steam(caller) end) 
end

