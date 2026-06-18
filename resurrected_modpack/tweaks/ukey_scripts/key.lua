local mod = UnlockKey



-- Check if the current room is any of the required boss rooms
function mod:IsMommyRoom(type)
	local room = Game():GetRoom()

	if room:GetType() == RoomType.ROOM_BOSS and Game():GetLevel():GetAbsoluteStage() ~= LevelStage.STAGE7 then
		local bossID = room:GetBossID()

		-- Mom / Mausoleum Mom
		if type == "Mom" then
			return bossID == 6 or bossID == 89

		-- Mom's Heart / It Lives
		elseif type == "Heart" then
			return bossID == 8 or bossID == 25

		-- Mother
		elseif type == "Mother" then
			return bossID == 88
		end
	end

	return false
end



-- Spawn timed doors / exits after Mother
function mod:TrySpawnUnlockKeyExits()
	if mod:DoesAnyoneHaveUnlockKey() then
		local room = Game():GetRoom()

		-- Boss Rush door from Mom
		if mod:IsMommyRoom("Mom") then
			room:TrySpawnBossRushDoor(true)


		-- Blue Womb door from Mom's Heart / It Lives
		elseif mod:IsMommyRoom("Heart") then
			room:TrySpawnBlueWombDoor(false, true)


		-- Blue Womb door, Sheol trapdoor and Cathedral light beam from Mother
		elseif mod:IsMommyRoom("Mother") then
			local trapdoorGrindex = 66
			local grid = room:GetGridEntity(trapdoorGrindex)

			-- Sheol trapdoor and Cathedral light beam (Only if they're not spawned already)
			if not grid or grid:GetType() ~= GridEntityType.GRID_TRAPDOOR then
				-- Trapdoor
				local trapdoorPos = room:GetGridPosition(trapdoorGrindex)
				Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapdoorPos, true)

				-- Light beam
				local lightPos = room:GetGridPosition(trapdoorGrindex + 2)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, lightPos, Vector.Zero, nil)
			end


			-- Blue Womb door
			room:TrySpawnBlueWombDoor(false, true, true)

			-- Load custom skin
			for doorSlot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
				local door = room:GetDoor(doorSlot)

				if door and door.TargetRoomIndex == GridRooms.ROOM_BLUE_WOOM_IDX then
					local sprite = door:GetSprite()
					local floorSuffix = "corpse"

					-- Last Judgement compatibility
					if LastJudgement and LastJudgement.STAGE.Mortis:IsStage() then
						floorSuffix = "mortis"
					end

					-- Load the spritesheets
					local sheet = "gfx/grid/door_29_doortobluewomb_" .. floorSuffix .. ".png"

					for i = 0, sprite:GetLayerCount() - 1 do
						sprite:ReplaceSpritesheet(i, sheet)
					end
					sprite:LoadGraphics()

					break
				end
			end
		end
	end
end



-- Check if the current floor is Corpse
function mod:IsInCorpse()
	local level = Game():GetLevel()
	local stageNumber = level:GetAbsoluteStage()
	local stageType = level:GetStageType()

	-- Custom Corpse replacements
	if StageAPI and StageAPI.CurrentStage and StageAPI.CurrentStage.LevelgenStage then
		local genStage = StageAPI.CurrentStage.LevelgenStage
		stageNumber = genStage.Stage
		stageType = genStage.StageType
	end

	return (stageNumber == LevelStage.STAGE4_1 or stageNumber == LevelStage.STAGE4_2)
	and stageType >= StageType.STAGETYPE_REPENTANCE
end



-- Try to spawn after the room is cleared
function mod:OnClear(rng, position)
	mod:TrySpawnUnlockKeyExits()
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnClear)

function mod:NewRoom()
	local room = Game():GetRoom()

	-- Corpse specific
	if mod:IsInCorpse() then
		local roomIndex = Game():GetLevel():GetCurrentRoomIndex()

		-- Blue Womb entrance
		if roomIndex == GridRooms.ROOM_BLUE_WOOM_IDX then
			for grindex = 0, room:GetGridSize() - 1 do
				local grid = room:GetGridEntity(grindex)

				if grid then
					-- Make the door lead to the Mother arena instead of the entrance to it
					if grid:ToDoor() then
						grid:ToDoor().TargetRoomIndex = GridRooms.ROOM_SECRET_EXIT_IDX

					-- The game replaces the Blue Womb trapdoor with a cobweb in Corpse (FUN!!!) so I have to undo it
					elseif grid:GetType() == GridEntityType.GRID_SPIDERWEB then
						room:RemoveGridEntity(grindex, 0, false)
						room:Update()

						local trapdoorPos = room:GetGridPosition(grindex)
						Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapdoorPos, true)
					end
				end
			end

		-- Remove exit doors in the Mother arena
		elseif roomIndex == GridRooms.ROOM_SECRET_EXIT_IDX then
			for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
				local door = room:GetDoor(i)

				if door and door.TargetRoomIndex ~= GridRooms.ROOM_BLUE_WOOM_IDX then
					room:RemoveDoor(i)
				end
			end
		end
	end


	-- Try to spawn after re-entering a cleared room
	if room:IsClear() then
		mod:TrySpawnUnlockKeyExits()
	end


	-- Reset key tracker
	if mod.KeyPedestal then
		mod.KeyPedestal = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)



-- Fix Mother exits taking the player to the wrong stage
function mod:PlayerUpdate(player)
	local level = Game():GetLevel()

	if mod:IsMommyRoom("Mother") -- Mother room
	or (mod:IsInCorpse() and level:GetCurrentRoomIndex() == GridRooms.ROOM_BLUE_WOOM_IDX) then -- Blue Womb entrance in Corpse
		local sprite = player:GetSprite()

		-- Sheol trapdoor
		local gridHere = Game():GetRoom():GetGridEntityFromPos(player.Position)

		if sprite:IsPlaying("Trapdoor") and sprite:GetFrame() >= 15
		and gridHere and gridHere:GetType() == GridEntityType.GRID_TRAPDOOR then -- Make sure it's not a Ventricle Razor hole
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)


		-- Cathedral light beam
		elseif sprite:IsPlaying("LightTravel") and sprite:GetFrame() >= 35
		and not player.ControlsEnabled then -- Make sure the animation isn't from the Emote mod
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PlayerUpdate)



-- Increase the HP of every enemy
function mod:EnemyInit(entity)
	if mod:DoesAnyoneHaveUnlockKey()
	and entity:IsActiveEnemy(false) and entity.MaxHitPoints > 0 then
		local onePercent = entity.MaxHitPoints / 100
		local increase = onePercent * mod.EnemyHPIncrease

		-- Prevent Gideon from softlocking
		if entity.Type == EntityType.ENTITY_GIDEON then
			increase = math.floor(increase)
		end

		entity.MaxHitPoints = entity.MaxHitPoints + increase
		entity.HitPoints = entity.MaxHitPoints
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.LATE, mod.EnemyInit)



-- Prevent the key from being rerolled (cool version)
if REPENTOGON then
	function mod:KeyPedestalUpdate(pickup)
		if pickup.SubType == mod.Item then
			mod.SpawnedKey = true
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.KeyPedestalUpdate, PickupVariant.PICKUP_COLLECTIBLE)

	function mod:PreventReroll(pickup)
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType == mod.Item then
			return false
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, mod.PreventReroll)


-- Prevent the key from being rerolled (lame version)
else
	function mod:KeyPedestalUpdate(pickup)
		if pickup.SubType ~= 0 then
			if pickup.SubType == mod.Item then
				mod.KeyPedestal = pickup.Index
				mod.SpawnedKey = true

			elseif pickup.Index == mod.KeyPedestal then
				pickup:Morph(pickup.Type, pickup.Variant, mod.Item, true, true, true)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.KeyPedestalUpdate, PickupVariant.PICKUP_COLLECTIBLE)
end