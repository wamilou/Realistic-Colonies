     AddCSLuaFile( "cl_init.lua" )
     AddCSLuaFile( "shared.lua" )
      
     include('shared.lua')
	 
	function watermelonCount()
		local wms = ents.FindByClass("watermelon")
		return #wms
	end
	 
	 function ENT:SpawnFunction( ply, tr)
		local SpawnPos = tr.HitPos
		local ent = ents.Create( "watermelon_plant_huge" )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		return ent
	end

      
    function ENT:Initialize()
		self:SetModel("models/props_foliage/rd_tree01a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS ) // Make us work with physics,
		self:SetSolid( SOLID_VPHYSICS ) // Toolbox
		self:GetPhysicsObject():EnableMotion(false)
		self.lastmelon_plant = math.Round(CurTime())
		self.lastmelon = math.Round(CurTime())
		self:SetNWBool("RC",true)
		self.age=0
		self.nextmelon=GetConVarNumber("rc_watermelonb_time")
    end
     
     function ENT:OnTakeDamage(dmg)
     end
	 	    
	function ENT:Think()
		if GetConVarNumber("rc_remove")==1 then 
			self:Remove()
		end
		
		self.age = self.age + GetConVarNumber("rc_time")*GetConVarNumber("rc_speed")
		if self.age > GetConVarNumber("rc_watermelonp_life")then
			self:Remove()
		end
		if self.age > self.nextmelon  and watermelonCount() <= GetConVarNumber("rc_watermelon_max") then
			self.nextmelon = GetConVarNumber("rc_watermelonb_time") + self.age
			local melon = ents.Create("watermelon")
			local dist = GetConVarNumber("rc_watermelonb_distance")
			melon:SetPos(self:GetPos()+Vector(math.random(-dist,dist),math.random(-dist,dist),225))
			melon:Spawn()
			self.lastmelon = math.Round(CurTime())
		end
		
		
		self:NextThink( CurTime() + GetConVarNumber("rc_planttime") )
		return true
	end 