local function InstantPoopEnabler()

local InstantPoop = {}
local mod = IsaacReflourished


--Shared variable
local poopCallback = false 

function InstantPoop:Destroy(gridEntity, gridType, immediate, addTime)
	if gridType == "poop" then
		gridEntity:Destroy(immediate)
	elseif gridType == "fire" then
		gridEntity:Die()
	end
	local firerate = IsaacReflourished.Utility:toTearsPerSecond(Game():GetNearestPlayer(gridEntity.Position or Vector(0, 0)).MaxFireDelay)
	if addTime == false then return end
	local shouldAddTime = IsaacReflourished:GetSettingsValue("OneHitTimeAdded") == 2
	if not shouldAddTime then return end
	local timeAdded = math.min(60, math.floor(((1.4) / firerate) * 30))

	Game().TimeCounter = Game().TimeCounter + timeAdded

end

--Function used to destroy poops with tears (does NOT work with lasers or spectral tears)
function InstantPoop:onTearGridCollision(entityTear, gridIndex, gridEntity)
	local allowinHostileRooms = IsaacReflourished:GetSettingsValue("OneHitHostileRooms") == 2
	local allowRedPoop = IsaacReflourished:GetSettingsValue("OneHitRedPoops") == 2
	if allowinHostileRooms or (Game():GetRoom():IsClear() and Game():GetRoom():GetAliveEnemiesCount() == 0 and not Isaac.GetPlayer():HasCurseMistEffect()) then		--works only when the room is cleared. :GetAliveEnemiesCount() == 0 is needed because in Boss Rush we have always :IsClear() true.
		if gridEntity ~= nil and gridEntity:GetType() == GridEntityType.GRID_POOP then
			if gridEntity:GetVariant() == GridPoopVariant.RED then
				if not allowRedPoop then return end
			end
			InstantPoop:Destroy(gridEntity, "poop", false)	--:Destroy(boolean Immediate)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, InstantPoop.onTearGridCollision)	--https://repentogon.com/enums/ModCallbacks.html#mc_tear_grid_collision
																				--for some reason this callback does not work with an optional argument...
																				
---------------------------------------------------------------------------------

--Note: unfortunately there is no ModCallbacks.MC_LASER_GRID_COLLISION (at the moment...).
--		Therefore, I tried to combine other functions/callbacks to understand when a poop 
--      is damaged by the laser/brimstone of the player. To do that, I used a callback (added 
--      with Repentogon) that works on poop update. The problem is that this callback is activated
--      continuously (so it is less efficient compared to MC_TEAR_GRID_COLLISION).

---------------------------------------------------------------------------------

--Function used to detect if the player has lasers/brimstone 
--ONLY if the player has lasers/brimstone, the mod will add a specific callback to check (continuously) the status of the poops in the room. 
function InstantPoop:onLaserInit(entityLaser)		--works only when the player shots with lasers/brimstone

	if entityLaser.SpawnerType == EntityType.ENTITY_PLAYER and poopCallback == false then						
		mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)	--https://repentogon.com/enums/ModCallbacks.html#mc_post_grid_entity_poop_update
		poopCallback = true
	end
	
end

mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, InstantPoop.onLaserInit)

---------------------------------------------------------------------------------

--Function used to detect if the player has spectral tears (because they have collisions with grid entities)
--ONLY if the player has spectral tears, the mod will add a specific callback to check (continuously) the status of the poops in the room.
function InstantPoop:postFireTear(entityTear)		--works only when you fire a tear

	if entityTear.SpawnerType == EntityType.ENTITY_PLAYER and (entityTear:HasTearFlags(TearFlags.TEAR_SPECTRAL) or entityTear:HasTearFlags(TearFlags.TEAR_LUDOVICO)) and (poopCallback == false) then						
		mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)	--https://repentogon.com/enums/ModCallbacks.html#mc_post_grid_entity_poop_update
		poopCallback = true
	end
	
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, InstantPoop.postFireTear)	--https://moddingofisaac.com/docs/rep/enums/ModCallbacks.html#mc_post_fire_tear

---------------------------------------------------------------------------------

--Function used to add the poop callback when the player gets the collectible "Ludovico Technique"
function InstantPoop:checkAddedCollectible(collectibleType, charge, firstTime, slot, varData, player)
	
	if collectibleType == CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE and (poopCallback == false) then
		mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = true
	end
	
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, InstantPoop.checkAddedCollectible)	--https://repentogon.com/enums/ModCallbacks.html#mc_post_add_collectible


---------------------------------------------------------------------------------

--Function used to remove the poop callback when the player loses the collectible "Ludovico Technique"
---@param player EntityPlayer
function InstantPoop:checkRemovedCollectible(player, collectibleType)

	if collectibleType == CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE and (poopCallback == true) and (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) <= 0) then
		mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = false
	end

end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, InstantPoop.checkRemovedCollectible)

---------------------------------------------------------------------------------

--Function used to destroy poops on their update  
function InstantPoop:onGridEntityPoopUpdate(gridEntityPoop)		--works only if there are poops in the room
	local allowinHostileRooms = IsaacReflourished:GetSettingsValue("OneHitHostileRooms") == 2
	if allowinHostileRooms or (Game():GetRoom():IsClear() and Game():GetRoom():GetAliveEnemiesCount() == 0 and not Isaac.GetPlayer():HasCurseMistEffect()) then
		if gridEntityPoop.State ~= 0 and gridEntityPoop.State ~= 1000  then	--state == 0 -> non-damaged poop. state == 1000 -> destroyed poop 
			local allowRedPoop = IsaacReflourished:GetSettingsValue("OneHitRedPoops") == 2
			if gridEntityPoop:GetVariant() == GridPoopVariant.RED then
				if not allowRedPoop then return end
			end
			InstantPoop:Destroy(gridEntityPoop, "poop", false, false)									--:Destroy(boolean Immediate)
		end
	end

end

---------------------------------------------------------------------------------

--Function used to check some stuff when you start a run or continue an existing one
function InstantPoop:onGameStart(isContinued)

	--Remove the callback MC_POST_GRID_ENTITY_POOP_UPDATE when you start a new run (without exiting the game)
	if isContinued == false and (poopCallback == true) then
		mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = false
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, InstantPoop.onGameStart)

---------------------------------------------------------------------------------

--Function used to check some stuff when you start a run or continue an existing one
function InstantPoop:onNewRoom(isContinued)

    local tForgottenExists = PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_THEFORGOTTEN_B)
	--Remove the callback MC_POST_GRID_ENTITY_POOP_UPDATE when you enter a room
	if poopCallback == true and not tForgottenExists and not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
		mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, InstantPoop.onNewRoom)

---------------------------------------------------------------------------------

--Function used to check if the playerType of any player has changed
function InstantPoop:OnPlayerChange(player, cacheFlag)

	if not cacheFlag == CacheFlag.CACHE_COLOR then return end

    local tForgottenExists = PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_THEFORGOTTEN_B)
    if tForgottenExists and (poopCallback == false) then
        --Add the callback MC_POST_GRID_ENTITY_POOP_UPDATE if you are using Tainted Forgotten (because he can throw the skeleton)
        mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = true
    elseif not tForgottenExists and (poopCallback == true) then
		mod:RemoveCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, InstantPoop.onGridEntityPoopUpdate)
		poopCallback = false
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, InstantPoop.OnPlayerChange, CacheFlag.CACHE_COLOR)

---------------------------------------------------------------------------------

--Function used to destroy fires and poops spawned by the active item "Flush!"
function InstantPoop:onEntityTakeDamage(entity, damageAmount, damageFlags, sourceEntityRef, countdownFrames)
	if not (entity.Type == EntityType.ENTITY_FIREPLACE or entity.Type == EntityType.ENTITY_POOP) then return end
	if entity.HitPoints <= 1 then return end
	local allowinHostileRooms = IsaacReflourished:GetSettingsValue("OneHitHostileRooms") == 2
	local allowRedFirePlaces = IsaacReflourished:GetSettingsValue("OneHitRedFires") == 2
	local isClear = Game():GetRoom():IsClear() and Game():GetRoom():GetAliveEnemiesCount() == 0 and not Isaac.GetPlayer():HasCurseMistEffect()
	if not (isClear or allowinHostileRooms) then return end

	if (entity.Type == EntityType.ENTITY_FIREPLACE and (entity.Variant == 0 or (entity.Variant == 1 and allowRedFirePlaces))) --variant 0 -> normal fire places, variant 1 -> red fire places
	or entity.Type == EntityType.ENTITY_POOP then
		InstantPoop:Destroy(entity, "fire")
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, InstantPoop.onEntityTakeDamage)


end
return InstantPoopEnabler