local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Chests Before Mother"

local function isHoleRoom(level, room)
	if (level:GetStage() == LevelStage.STAGE4_2 or (level:GetStage() == LevelStage.STAGE4_1 and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0)) 
	   and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B)
	   and room:GetType() == 5 and room:GetGridHeight() == 9 and room:GetGridEntity(67) and room:GetGridEntity(67):GetType() == 17 then return true end
	if Isaac.GetChallenge() == Challenge.CHALLENGE_RED_REDEMPTION and level:GetStage() == 7
	   and room:GetType() == 5 and room:GetGridHeight() == 9 and room:GetGridEntity(67) and room:GetGridEntity(67):GetType() == 17 then return true end
	return false
end

function mod:onStart(savestate)
	if savestate then
		mod.ChestsSpawnedThisRoom = nil
		if mod:HasData() then mod.Storage = mod.json.decode(mod:LoadData())
		else mod.Storage = {} end -- in case of crashes, or whatnot
	else
		if mod:HasData() then mod:RemoveData() end
		mod.Storage = {}
	end
end

function mod:onEnd()
    if mod.Storage ~= nil then
        mod:SaveData(mod.json.encode(mod.Storage))
    end
end

function mod:spawnChests()
	mod.ChestsSpawnedThisRoom = nil
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if isHoleRoom(level, room) and mod.Storage and not mod.Storage.SpawnedChests then
		mod.Storage.SpawnedChests = true
		mod.ChestsSpawnedThisRoom = true
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, room:GetGridPosition(64), Vector.Zero, nil)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, room:GetGridPosition(70), Vector.Zero, nil)

	end
end

function mod:guaranteeChestItems(pickup, collider, low)
	if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and collider.Type == EntityType.ENTITY_PLAYER then
		if pickup:GetSprite():GetAnimation() ~= "Appear" then -- new-spawned chests can't be opened!
			if collider:ToPlayer():GetNumKeys() > 0 or collider:ToPlayer():HasGoldenKey() or collider:ToPlayer():HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then
				local room = Game():GetRoom()
				local level = Game():GetLevel()
				if isHoleRoom(level, room) then
					-- subtract key
					if not collider:ToPlayer():HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then collider:ToPlayer():TryUseKey() end
					-- make chest open sound effect
					SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1.0, 0, false, 1.0)
					SFXManager():Play(SoundEffect.SOUND_UNLOCK00, 1.0, 0, false, 1.0)
					-- replace with treasure room pedestal item, with golden chest base
					local pickupPos = pickup.Position
					pickup:Remove()
					local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, pickupPos, Vector.Zero, nil)
					item:ClearEntityFlags(EntityFlag.FLAG_ITEM_SHOULD_DUPLICATE) -- golden chest items shouldn't, sorry
					--item:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					-- and set the pedestal to be pretty
					item:GetSprite():SetOverlayFrame("Alternates", 4)
					return false
				end
			end
		end
	end
end

function mod:pretendItsATreasureRoom(pool, decrease, seed)
	if pool ~= ItemPoolType.POOL_BOSS then return end -- C STACK OVERFLOW NO MORE
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if isHoleRoom(level, room) then return Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, decrease, seed) end
end

function mod:makeSureTheyreGold()
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if isHoleRoom(level, room) then
		local megas = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MEGACHEST)
		for i=1, #megas do
			megas[i]:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, megas[i].SubType, false, true, true)
		end
	end
end

function mod:makeGlowingHourglassWork(_, _, _)
	if mod.ChestsSpawnedThisRoom then mod.Storage.SpawnedChests = nil end
end

function mod:victoryLapsAndRKeys()
	if mod.Storage then mod.Storage.SpawnedChests = nil end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onEnd)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.spawnChests)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.guaranteeChestItems)
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.pretendItsATreasureRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.makeSureTheyreGold) -- grumble grumble stupid mega chests
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.makeGlowingHourglassWork, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.victoryLapsAndRKeys)
