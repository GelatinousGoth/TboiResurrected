local cba = CutBossesAttacks

local cfg = cba.Save.Config

------------------------------
----------Mom's Foot----------
------------------------------

local directions = {
	[7] = Vector(0, 1),
	[60] = Vector(1, 0),
	[74] = Vector(-1, 0),
	[127] = Vector(0, -1)
}
function cba:MomArmAttack(Mom)
	if Mom.Variant == 0 and Mom.SubType == 3 and cfg["General"]["MomRestore"] == true then
		local data = cba.GetData(Mom)
	
		if Mom.State == 10 and not data.chance_calc then --on enemy spawn attack
			local chance = math.random(100)
			
			if chance <= cfg["Mom"]["ArmSpawnChance"] then
			
				Mom.State = 8 --set needed state
				data.MM_arm_attack = true
				Mom:GetSprite():Play("ArmOpen", true) --play anim
			end
			
			data.chance_calc = true
			
		elseif Mom.State == 11 and not data.chance_calc then --on eye attack
			local chance = math.random(100)
			
			if chance <= cfg["Mom"]["ArmEyeChance"] then
			
				Mom.State = 8 --same actions
				data.MM_arm_attack = true
				Mom:GetSprite():Play("ArmOpen", true)
			end
			
			data.chance_calc = true
			
		elseif Mom.State == 8 then 
			if not data.MM_arm_attack and Mom:GetSprite():GetFrame() == 25 then --on eye looking anim
		
				Mom:GetSprite():Play("ArmOpen", true)
				data.MM_arm_attack = true
			
			elseif data.MM_arm_attack then --on hand attack
		
				if data.chance_calc then --reset values
					data.chance_calc = nil
				end
				
				if Mom:GetSprite():GetFrame() == 10 then
					local dir = directions[Game():GetRoom():GetGridIndex(Mom.Position)]
					
					for i = -2, 2 do --spawn a few bouncy projs
					
						local velocity = (dir * 10):Rotated(20 * i)
						
						local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, Mom.Position + dir * 80, velocity, Mom):ToProjectile()
						proj:AddProjectileFlags(ProjectileFlags.BOUNCE)
						
						proj.Height = -30
						proj.Scale = 1.5
					end
				end
			end
		elseif Mom.State == 3 and data.MM_arm_attack then
			data.MM_arm_attack = nil
		end
	end
end

cba:AddCallback(ModCallbacks.MC_NPC_UPDATE, cba.MomArmAttack, EntityType.ENTITY_MOM)

function cba:MomFootAttack(effect)
	if cfg["General"]["MomRestore"] == true 
	and effect.SpawnerEntity 
	and effect.SpawnerType == EntityType.ENTITY_MOM 
	and effect.SpawnerVariant == 10 
	and effect.SpawnerEntity.SubType == 3 then --if it's mom's crackwave
	
		if effect.Variant == EffectVariant.CRACKWAVE then
			local var = Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B and 2 or 1 --floor variations
			
			local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, var, effect.Position, effect.Velocity, effect.SpawnerEntity):ToEffect()
			
			fire.Rotation = effect.Rotation
			fire.Parent = effect.Parent
			effect:Remove() --remove crackwave
			
		elseif effect.Variant == EffectVariant.POOF02 
		and (effect.SubType == 3 or effect.SubType == 4) then --colorizing blood poof
		
			local color = Color(1, 1, 1, 1)
			color:SetColorize(5, 1, 5, 1)
			
			if Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
				color:SetColorize(5, 1, 1, 1)
			end
			
			effect:GetSprite().Color = color
		end
	end
end

cba:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, cba.MomFootAttack)

function cba:MomFootFix(Mom, dmg, dmgflags, source, frames)
	if source.Entity 
	and source.Entity.SpawnerEntity 
	and source.Entity.SpawnerEntity.Type == EntityType.ENTITY_MOM then --fire cannot damage mom
		return false
	end
end

cba:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, cba.MomFootFix, EntityType.ENTITY_MOM)