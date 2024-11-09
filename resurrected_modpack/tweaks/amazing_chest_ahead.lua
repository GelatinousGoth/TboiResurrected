local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Amazing Chest Ahead", 1)

local game = Game()

local woodenChestPercent = 5
local oldChestPercent = 5

local crackedKeyPercent = 6.66

--Chest Replacements

local function IsNewChest(chest)
	local sprite = chest:GetSprite()
	return sprite:IsPlaying("Appear") or sprite:IsPlaying("AppearFast")
end

function mod:ChestReplace(pickup)
	if not Isaac.GetPersistentGameData():Unlocked(Achievement.WOODEN_CHEST) then
		return
	end
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	if not IsNewChest(pickup) then
		return
	end
	if room:GetType() ~= RoomType.ROOM_CHALLENGE and stage ~= LevelStage.STAGE6 and not pickup:GetData().nomorph then
		if pickup.InitSeed % (100 * 100) < (woodenChestPercent * 100) then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_WOODENCHEST, 1, true, true, false)
		end
	end
end

function mod:LockedChestReplace(pickup)
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	if not IsNewChest(pickup) then
		return
	end
	if room:GetType() ~= RoomType.ROOM_CHALLENGE and stage ~= LevelStage.STAGE6 and not pickup:GetData().nomorph then
		if pickup.InitSeed % (100 * 100) < (oldChestPercent * 100) then
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_OLDCHEST, 1, true, true, false)
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, math.maxinteger, mod.ChestReplace, PickupVariant.PICKUP_CHEST)
mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, math.maxinteger, mod.LockedChestReplace, PickupVariant.PICKUP_LOCKEDCHEST)


--Red Chest Extra Loot

function mod:RedChestLoot(pickup)
	if not Isaac.GetPersistentGameData():Unlocked(Achievement.RED_KEY) then
		return
	end
	if pickup:GetSprite():IsPlaying("Open") and pickup:GetSprite():GetFrame() == 1 then
		if pickup.DropSeed % (100 * 100) < (crackedKeyPercent * 100) then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, pickup.Position, Vector.FromAngle(math.random(360)) * 5, nil)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.RedChestLoot, PickupVariant.PICKUP_REDCHEST)