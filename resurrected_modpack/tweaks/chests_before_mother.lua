local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Chests Before Mother", 1, true)

local spawnedChestsFrame = false

local function isHoleRoom(roomDescriptor)
	local configRoom = roomDescriptor.Data
	return configRoom.Type == RoomType.ROOM_BOSS and configRoom.StageID == 0 and configRoom.Variant == 6000
end

function mod:spawnChests()
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if isHoleRoom(level:GetCurrentRoomDesc()) then
		spawnedChestsFrame = true
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 1, room:GetGridPosition(64), Vector.Zero, nil)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 1, room:GetGridPosition(70), Vector.Zero, nil)
	end
end

function mod:guaranteeChestItems(pickup, collider, low)
	if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and collider.Type == EntityType.ENTITY_PLAYER then
		if pickup:GetSprite():GetAnimation() ~= "Appear" then -- new-spawned chests can't be opened!
			if collider:ToPlayer():GetNumKeys() > 0 or collider:ToPlayer():HasGoldenKey() or collider:ToPlayer():HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then
				local level = Game():GetLevel()
				if isHoleRoom(level:GetCurrentRoomDesc()) then
					-- subtract key
					if not collider:ToPlayer():HasTrinket(TrinketType.TRINKET_PAPER_CLIP) then collider:ToPlayer():TryUseKey() end
					-- make chest open sound effect
					SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1.0, 0, false, 1.0)
					SFXManager():Play(SoundEffect.SOUND_UNLOCK00, 1.0, 0, false, 1.0)
					-- replace with treasure room pedestal item, with golden chest base
					local pickupPos = pickup.Position
					pickup:Remove()
					local collectibleType = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, pickup.DropSeed)
					local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleType, pickupPos, Vector.Zero, nil)
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

function mod:MarkAsNoMorph(pickup)
	if not spawnedChestsFrame then
		return
	end
	pickup:GetData().nomorph = true
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.spawnChests)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.guaranteeChestItems)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.MarkAsNoMorph, PickupVariant.PICKUP_LOCKEDCHEST)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() spawnedChestsFrame = false end)