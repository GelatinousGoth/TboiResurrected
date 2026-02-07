local TR_Manager = require("resurrected_modpack.manager")
StairwayTrapdoor = TR_Manager:RegisterMod("Stairway Trapdoor", 1)
local mod = StairwayTrapdoor
local game = Game()

mod.Trapdoor = Isaac.GetEntityVariantByName("Stairway Trapdoor")

function mod.StairwayCheck()
	local level = game:GetLevel()
	local gridIndex = level:GetCurrentRoomIndex()
	if gridIndex == 84 then -- starting room
		local stairways = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TALL_LADDER, 1)
		if #stairways == 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TALL_LADDER, 1, Isaac.GetFreeNearPosition(Vector(440, 160), 10), Vector.Zero, nil)
		end
	elseif gridIndex == GridRooms.ROOM_ANGEL_SHOP_IDX then
		-- remove door, spawn trapdoor
		local room = game:GetRoom()
		for slot = 0, DoorSlot.NUM_DOOR_SLOTS-1 do
			local door = room:GetDoor(slot)
			if door then
				room:RemoveDoor(slot)
			end
		end
		Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Trapdoor, 0, Isaac.GetFreeNearPosition(Vector(440, 160), -10), Vector.Zero, nil)

		-- reset player position close to trapdoor?
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			player.Position = Isaac.GetFreeNearPosition(Vector(440, 200), 10)
		end
	end
end

--if REPENTOGON then
--	function mod:NewRoom()
--		if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) then return end
--		mod.StairwayCheck()
--	end
--	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)
--else -- vanilla
function mod:NewRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		if Isaac.GetPlayer(i):HasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) then
			mod.StairwayCheck()
			break
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)
--end

function mod:EffectInit(effect)
	effect.DepthOffset = -999
	effect:GetSprite():Play("Open Animation")
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.EffectInit, mod.Trapdoor)

function mod:EffectUpdate(effect)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Open Animation") then
		sprite:Play("Opened")
	end
	--print(sprite:GetAnimation(), sprite:IsPlaying("Opened"), sprite:IsFinished("Opened"))
	if not (sprite:IsPlaying("Opened") or sprite:IsFinished("Opened")) then return end
	
	--if effect:GetData().Teleporting then return end
	local player = game:GetNearestPlayer(effect.Position)
	if effect.Position:Distance(player.Position) > 10 then return end
	--effect:GetData().Teleporting = true

	--player:AnimateTrapdoor()
	player:AddControlsCooldown(8)

	--:StartRoomTransition(RoomIndex, Direction, Animation, Player, Dimension)
	game:StartRoomTransition(84, 3, RoomTransitionAnim.WALK, player)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffectUpdate, mod.Trapdoor)
