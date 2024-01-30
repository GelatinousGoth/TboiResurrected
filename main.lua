local mod = RegisterMod("Tboi Resurrected",1)
local json = require("json")

Isaac.DebugString("[Tboi Resurrected] \"Tboi Resurrected\" initialized.")

-- Make "entity" invincible while it's in its spawning animation state
---@param entity Entity
---@return boolean
function mod:SpawnInvincibility(entity)

  if entity:ToNPC().State ~= (NpcState.STATE_APPEAR or NpcState.STATE_APPEAR_CUSTOM or NpcState.STATE_INIT) then

    return true

  end

  return false

end

-- Check if "The Lamb" is in it's spawning state before damage is applied
-- If it is, the damage won't be applied
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.SpawnInvincibility, EntityType.ENTITY_THE_LAMB)

-- KNOWN BUG: Getting the items from the chests gives the boss room item pickup sound effect, when I'd rather it gave treasure room.
--            The only way I can see to fix this involves totally hijacking the item pickup function, which is doable but please no.
-- KNOWN BUG: Guppy's Eye HATES it

local function isHoleRoom(level, room)
	if (level:GetStage() == LevelStage.STAGE4_2 or (level:GetStage() == LevelStage.STAGE4_1 and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0)) 
	   and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B)
	   and room:GetType() == 5 and room:GetGridHeight() == 9 and room:GetGridEntity(67) and room:GetGridEntity(67):GetType() == 17 then return true end
	if Isaac.GetChallenge() == Challenge.CHALLENGE_RED_REDEMPTION and level:GetStage() == 7
	   and room:GetType() == 5 and room:GetGridHeight() == 9 and room:GetGridEntity(67) and room:GetGridEntity(67):GetType() == 17 then return true end
	return false
end

-- this is pretty interesting -- it's a more perfect implementation, but it works out worse because you probably don't want them spawning around Emperor? holes
-- also it doesn't work with two holes in the same run, though that's easy to solve with a resetting of .SpawnedChests on new floor
-- local function isHoleRoom(level, room)
	-- if room:GetType() == 5 and room:GetGridHeight() == 9 and room:GetGridEntity(67) and room:GetGridEntity(67):GetType() == 17
	   -- and room:GetGridEntity(67):GetSprite():GetFilename() == "gfx/grid/trapdoor_corpse_big.anm2" then return true end
	-- return false
-- end

function mod:onStart(savestate)
	if savestate then
		mod.ChestsSpawnedThisRoom = nil
		if mod:HasData() then mod.Storage = json.decode(mod:LoadData())
		else mod.Storage = {} end -- in case of crashes, or whatnot
	else
		if mod:HasData() then mod:RemoveData() end
		mod.Storage = {}
	end
end

function mod:onEnd()
    if mod.Storage ~= nil then
        mod:SaveData(json.encode(mod.Storage))
    end
end

function mod:spawnChests()
	mod.ChestsSpawnedThisRoom = nil
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if isHoleRoom(level, room) and mod.Storage and not mod.Storage.SpawnedChests then
		mod.Storage.SpawnedChests = true
		mod.ChestsSpawnedThisRoom = true
		-- Spawn 'em
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
	-- this was originally going to only trigger on basement one, but then I realised forget me nows should spawn 4 more items.
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onEnd)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.spawnChests)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.guaranteeChestItems)
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.pretendItsATreasureRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.makeSureTheyreGold) -- grumble grumble stupid mega chests
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.makeGlowingHourglassWork, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.victoryLapsAndRKeys)

-- When these types of pickups are picked up, their pickup sound gradually increases in pitch for a short amount of time.
-- Format: { <variant>, <subtype>, <sound> }
local PITCHABLE_PICKUPS =
{
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_DOUBLEPACK,   SoundEffect.SOUND_FETUS_FEET },
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_NORMAL,       SoundEffect.SOUND_FETUS_FEET },
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_GOLDEN,       SoundEffect.SOUND_GOLDENBOMB },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_DIME,         SoundEffect.SOUND_DIMEPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_DOUBLEPACK,   SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_LUCKYPENNY,   SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_NICKEL,       SoundEffect.SOUND_NICKELPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_PENNY,        SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_STICKYNICKEL, SoundEffect.SOUND_NICKELPICKUP },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK,      SoundEffect.SOUND_UNHOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE,       SoundEffect.SOUND_BONE_HEART },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL,       SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN,     SoundEffect.SOUND_GOLD_HEART },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF,       SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL,  SoundEffect.SOUND_HOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL,       SoundEffect.SOUND_HOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL,    SoundEffect.SOUND_SUPERHOLY },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_CHARGED,        SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_DOUBLEPACK,     SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_NORMAL,         SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_GOLDEN,         SoundEffect.SOUND_GOLDENKEY },

	-- Repentance additions: use numbered ids to avoid errors on older DLCs.
	{ PickupVariant.PICKUP_BOMB,  7,  SoundEffect.SOUND_FETUS_FEET }, -- BombSubType.BOMB_GIGA
	{ PickupVariant.PICKUP_HEART, 12, 497 },                          -- HeartSubType.HEART_ROTTEN
	{ PickupVariant.PICKUP_COIN,  7,  SoundEffect.SOUND_PENNYPICKUP } -- CoinSubType.COIN_GOLDEN
}

-- Amount of pitch added.
local PITCH_AMOUNT = 0.01

-- Reset the pitch back to normal after this amount of frames from the last sound.
local PITCH_RESET = 30

-- Default pitch amount.
local DEFAULT_PITCH = 1.0

local GAME = Game()
local SFXMANAGER = SFXManager()
local CURRENT_PITCH, LAST_PITCH = 1, 2
local VARIANT, SUBTYPE, SOUND = 1, 2, 3
local SOUNDS_PITCH = {}

function mod:OnPickupUpdate(pickup)
	for i = 1, #PITCHABLE_PICKUPS do
		if pickup.Variant == PITCHABLE_PICKUPS[i][VARIANT] and pickup.SubType == PITCHABLE_PICKUPS[i][SUBTYPE] then
			local sprite = pickup:GetSprite()

			if sprite:IsPlaying("Collect") and sprite:GetFrame() == 1 then
				local sound = PITCHABLE_PICKUPS[i][SOUND]

				SOUNDS_PITCH[sound][LAST_PITCH] = GAME:GetFrameCount()
				SOUNDS_PITCH[sound][CURRENT_PITCH] = SOUNDS_PITCH[sound][CURRENT_PITCH] + PITCH_AMOUNT
			end

			break
		end
	end
end

local REGISTERED_VARIANTS = {}

for i = 1, #PITCHABLE_PICKUPS do
	SOUNDS_PITCH[PITCHABLE_PICKUPS[i][SOUND]] = { DEFAULT_PITCH, 0 }

	if not REGISTERED_VARIANTS[PITCHABLE_PICKUPS[i][VARIANT]] then
		REGISTERED_VARIANTS[PITCHABLE_PICKUPS[i][VARIANT]] = true
		mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnPickupUpdate, PITCHABLE_PICKUPS[i][VARIANT])
	end
end

function mod:OnUpdate()
	local frame = GAME:GetFrameCount()

	for i = 1, #PITCHABLE_PICKUPS do
		local sound = PITCHABLE_PICKUPS[i][SOUND]

		if SFXMANAGER:IsPlaying(sound) then
			if SOUNDS_PITCH[sound][CURRENT_PITCH] > DEFAULT_PITCH then
				if SOUNDS_PITCH[sound][LAST_PITCH] > 0 and frame - SOUNDS_PITCH[sound][LAST_PITCH] >= PITCH_RESET then
					SOUNDS_PITCH[sound][CURRENT_PITCH] = DEFAULT_PITCH
				else
					SFXMANAGER:AdjustPitch(sound, SOUNDS_PITCH[sound][CURRENT_PITCH] - PITCH_AMOUNT)
				end
			end

			break
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)

function mod:OnMushroomInit(npc)
    local level = Game():GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if ((
        stage == LevelStage.STAGE2_1 or
        stage == LevelStage.STAGE2_2
    ) and stageType == StageType.STAGETYPE_AFTERBIRTH) or
    ((
        stage == LevelStage.STAGE1_1 or
        stage == LevelStage.STAGE1_2
    ) and stageType == StageType.STAGETYPE_REPENTANCE) then
        local sprite = npc:GetSprite()
		if npc:IsChampion() then
            sprite:ReplaceSpritesheet(0, "gfx/monsters/afterbirthplus/monster_300_mushroomman_flooded_caves_champion.png")
        else		
            sprite:ReplaceSpritesheet(0, "gfx/monsters/afterbirthplus/monster_300_mushroomman_flooded_caves.png")
        end
        sprite:LoadGraphics()
    end
end

mod:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    mod.OnMushroomInit,
    EntityType.ENTITY_MUSHROOM
)

--Thank you very much to the work of piber20 for their fixed dirt mod!
--Check it out http://steamcommunity.com/sharedfiles/filedetails/?id=1201700604

function mod:ReplaceDirtSprites(entity)
	local type = entity.Type
	local variant = entity.Variant
	local subType = entity.SubType --checking for subtype is a little tricky since some enemies (bosses in particular) use subtypes if it's a champion

	if type == 300 then
		--if variant == 0 and subType == 0 then
			if mod.floor == "floodedcaves" then
				
			local sprite = entity:GetSprite()
			sprite:ReplaceSpritesheet(0, mod.mushroomdrowned)
			sprite:LoadGraphics()
			end
		--end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ReplaceDirtSprites)

function mod:onUpdate()
	if mod.floor then
		local roomFrameCount = Game():GetLevel():GetCurrentRoom():GetFrameCount()
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			local type = entity.Type
			local variant = entity.Variant
			local subType = entity.SubType
			
			--enemies in the void spawn before room:GetRoomConfigStage() is set, and also just in case the above didn't work
			if roomFrameCount <= 2 then
				mod:ReplaceDirtSprites(entity)
			end
			
			--just in case MC_POST_NPC_INIT didn't work and none of the above methods worked
			if entity.FrameCount <= 2 then
				mod:ReplaceDirtSprites(entity)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)

function mod:updateVars()
	local isGreedMode = game:IsGreedMode()
	local level = game:GetLevel()
	local curroom = level:GetCurrentRoom()
	local stage = level:GetStage()
	local currentStageType = level:GetStageType()
	if isGreedMode then
		currentChapter = stage
	else
		if stage == 1 or stage == 2 then
			currentChapter = 1
		elseif stage == 3 or stage == 4 then
			currentChapter = 2
		elseif stage == 5 or stage == 6 then
			currentChapter = 3
		elseif stage == 7 or stage == 8 then
			currentChapter = 4
		else
			currentChapter = stage - 4
		end
	end
	
	--custom stages workaround
	if StageSystem then
		if StageSystem.GetCurrentStage() ~= 0 then
			mod.floor = "nil" --so we don't overwrite any custom stage sprites
		end
	end
	
	if not isGreedMode then
		if currentChapter == 2 then
			if currentStageType == 2 then --flooded caves
				mod.floor = "floodedcaves"
			else
				mod.floor = "nil"
			end
		elseif currentChapter == 8 then
		local roomStage = curroom:GetRoomConfigStage()
			if roomStage == 6 then --flooded caves?
				mod.floor = "floodedcaves"
			else
				mod.floor = "nil"
			end
		else
			mod.floor = "nil"
		end
	else
	mod.floor = "nil"
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.updateVars)

local game = Game()

function mod:OnUpdate()
    --Getting the current level that the player is on
    local currentLevel = game:GetLevel()

    --If currentLevel is The Void
    if currentLevel:GetStage() == LevelStage.STAGE7 then
        local currentRoom = game:GetRoom()

        --Looping through all the possible door positions in the room
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
            local door = currentRoom:GetDoor(i)

            --If the door exists
            if door ~= nil then
                --Getting the index of the room, its description data, and its configuration data
                local doorSprite = door:GetSprite()
                local doorRoomIndex = door.TargetRoomIndex
                local roomDescriptor = currentLevel:GetRoomByIdx(doorRoomIndex)
                local roomConfigData = roomDescriptor.Data  
                
                --If the shape of the next room is 2x2 and is a boss room or if you are already in the Delirium fight, change the spritesheet of the door
                if (roomConfigData.Shape == RoomShape.ROOMSHAPE_2x2 and roomConfigData.Type == RoomType.ROOM_BOSS) or (currentRoom:GetType() == RoomType.ROOM_BOSS and currentRoom:GetRoomShape() == RoomShape.ROOMSHAPE_2x2) and not door:IsOpen() then
                    doorSprite:Load("gfx/grid/door_bossdeliriumdoor.anm2", false)
                    --Play the close door animation since changing the sprite messes up the animation that plays
                    doorSprite:Play("Close", false)
                    doorSprite:LoadGraphics()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnUpdate)

function mod:SpriteReplacer(Gurgling) 
	if Gurgling.Variant == 0 then 
		if not Gurgling:IsChampion() then
			local sprite = Gurgling:GetSprite()
			sprite:ReplaceSpritesheet(1,"gfx/Gurgling.png")
			sprite:LoadGraphics()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.SpriteReplacer, 237)

--[[function mod:SpriteResizer(Gurgling)
	if Gurgling.Variant == 0 then
		local sprite = Gurgling:GetSprite()
		--sprite:ReplaceSpritesheet(1,"gfx/Gurgling.png")
		sprite.Scale = sprite.Scale * 0.9
		sprite:LoadGraphics()
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SpriteResizer, 237) --This also doesn't work]]

--big chest init function, runs when a big chest is spawned
function mod:POST_BIGCHEST_INIT(entity)

	--get some variables
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local altStage = level:IsAltStage()

	--if we're on stage 5 (sheol or cathedral). cathedral is the alt stage of sheol.
	--stage 6 is dark room or chest. chest is the alt stage of dark room.
	if stage == LevelStage.STAGE5 and altStage == false or stage == LevelStage.STAGE6 and altStage == false then

		--replace the default gold spritesheet with the new red one
		chestSprite = entity:GetSprite()
		
		--replacing sheet 0 and 2, but not 1 (1 is the shadow and doesn't need to be changed)
		
		chestSprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_neo_big_chest_red.png")
		chestSprite:ReplaceSpritesheet(2, "gfx/items/pick ups/pickup_neo_big_chest_red.png")
		chestSprite:LoadGraphics()

	end

end

--callback land

mod:AddCallback( ModCallbacks.MC_POST_PICKUP_INIT, mod.POST_BIGCHEST_INIT, PickupVariant.PICKUP_BIGCHEST )

function mod:POST_UPDATE()		
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local name = level:GetName()

	if ((stage == LevelStage.STAGE4_2) and (name == "Corpse II")) then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_BIGCHEST and entities[i].SubType ~= 666 then
				local pos = entities[i].Position
				entities[i]:Remove()
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 666, pos, Vector(0,0), null)
			end		
		end
	end
end

mod:AddCallback( ModCallbacks.MC_POST_UPDATE, mod.POST_UPDATE )

local game = Game()

local DC_id = 566
local DC_name = Isaac.GetItemIdByName("Dream Catcher") -- English item name, if the item ID is modified, this will serve as a secondary check
local HangerSpawned = false
local HangerSpawnedAlt = false
local HangerSpawnedBedroom = false
local XLFirstBoss = false

local function SpawnHanger(Pos)
	hanger = Isaac.Spawn(1000, 245, 0, Pos, Vector(0,0), nil)
end

local function checkCatcher()
	for PlrCount = 0, game:GetNumPlayers() do -- Check all players collections and find the Dream Catcher.
		local plr = Isaac.GetPlayer(PlrCount)
		if plr:HasCollectible(DC_id) then
			return true
		elseif plr:HasCollectible(DC_name) then
			return true
		end
	end
end

local function onClear() -- On clearing a room, check if the room is a boss room and spawn a hanger if it is.
	if checkCatcher() and not HangerSpawned then
		local CurRoom = game:GetRoom()
		local CurLevel = game:GetLevel()
		local CurStage = CurLevel:GetStage()
		if CurStage == 8 or CurStage >= 10 then -- Do not spawn hanger IF: you beat anything further than cathedral/sheol
			return
		end
		local RoomType = CurRoom:GetType()
		if RoomType == 5 then -- Check for an XL Floor		
			if game:GetLevel():GetCurses() == 2 then 
				if XLFirstBoss then -- Spawn the hanger only in the second boss room
					SpawnHanger(CurRoom:GetCenterPos())
					HangerSpawned = true
				else -- Do not spawn hanger and flag the floor after the first boss clear
					XLFirstBoss = true
				end
			else
				SpawnHanger(CurRoom:GetCenterPos())
				HangerSpawned = true
			end
		end
	end
end

local function onTrapSpawn() -- When using Ehwaz or We Need To Go Deeper!
	if checkCatcher() then
		local CurRoom = game:GetRoom()
		for PlrCount = 0, game:GetNumPlayers() do
			local plr = Isaac.GetPlayer(PlrCount)
			local GridEnt = CurRoom:GetGridEntityFromPos(plr.Position) -- Check the entity underneath the player's feet at the time of using Shovel or Ehwaz
			if GridEnt ~= nil then
				if checkCatcher() and GridEnt:GetType() == 17 then -- Spawn the hanger if the entity under you is a trapdoor and if a player has the Dream Catcher
					SpawnHanger(GridEnt.Position)
				end
			end
		end
	end
end

local function onBarren() -- Spawn a hanger in Isaac's Dirty Bedroom
	-- 19 = dirty room enum	
	if checkCatcher() and not HangerSpawnedBedroom then
		local CurRoom = game:GetRoom()
		if CurRoom:GetType() == 19 then
			SpawnHanger(CurRoom:GetCenterPos())
			HangerSpawnedBedroom = true
		end
	end
end

local function greedTrapdoor() -- Spawn a hanger in the exit room of Greed Mode
	-- 23 = Greed-mode exit room enum
	if checkCatcher() and not HangerSpawned and game:IsGreedMode() then
		local CurRoom = game:GetRoom()
		if CurRoom:GetType() == 23 then
			SpawnHanger(CurRoom:GetCenterPos())
			HangerSpawned = true
		end
	end
end

local function altPathTrapdoor() -- Spawn a Hanger in the rooms leading to alt-floors.
	if checkCatcher() and not HangerSpawnedAlt then
		local CurLevel = game:GetLevel()
		if CurLevel:GetStage() ~= 8 then
			local CurRoom = CurLevel:GetCurrentRoom()
			local Middle = CurRoom:GetCenterPos()
			local CenterGridEnt = CurRoom:GetGridEntityFromPos(Middle)
			if CenterGridEnt ~= nil then
				if CenterGridEnt:GetType() == 17 then
					--game:GetHUD():ShowFortuneText("???")
					SpawnHanger(Middle)
					HangerSpawnedAlt = true
				end
			end
		end
	end
end

local function postClear() -- Spawn a hanger if the dream catcher is collected after a boss is cleared
	if checkCatcher() and not HangerSpawned then
		local CurLevel = game:GetLevel()
		local CurRoom = CurLevel:GetCurrentRoom()
		if CurLevel:GetStage() ~= 8 and CurRoom:GetType() == 5 and CurRoom:IsClear() then
			for i = 0, CurRoom:GetGridSize() do
				local GridEntity = CurRoom:GetGridEntity(i)
				if GridEntity ~= nil then
					if GridEntity:GetType() == 17 then
						SpawnHanger(CurRoom:GetCenterPos())
						HangerSpawned = true
						return
					end
				end
			end
		end
	end
end

local function onNewFloor() -- Reset flags for existing hangers and XL first boss
	HangerSpawned = false
	HangerSpawnedAlt = false
	HangerSpawnedBedroom = false
	XLFirstBoss = false 
	if hanger ~= nil then
		hanger:Remove()
	end
end

local function Debug()
	-- Debugging commands
	-- game:GetHUD():ShowItemText(tostring(HangerSpawned), "Hanger Spawned")
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, onClear)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, onTrapSpawn)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onBarren)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, greedTrapdoor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, altPathTrapdoor)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, postClear)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onNewFloor)
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, Debug)

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subtype, position, velocity, spawner, seed, size)
if type == 38 and spawner and spawner.Type == 272 and spawner.Variant == 1 and spawner.SubType == 0 then
return {259, 0, 0, seed}
end
end)

local game = Game() 
local level = game:GetLevel() 
local music = MusicManager()
local StatueDestroyed = false
local BossDeath = false    
    
    
    
    
--RANDOM CHANCE
function random(x) 
    if math.random(0,100) < x then 
    return true else return false
    end 
end

    
   
    
--EVERY NEW STAGE RESET 
function mod:NewLevel()
    StatueDestroyed = false
    BossDeath = false   
end




--EVERY NEW ROOM
function mod:NewRoom()

	local room = level:GetCurrentRoom()
	
	--IF THIS IS THE DEVIL ROOM AND THE STATUE HAS BEEN DESTORYED REMOVE IT AGAIN
    if room:GetType() == RoomType.ROOM_DEVIL and StatueDestroyed == true  then
        		
    	local entities = Isaac.GetRoomEntities()
		
    	for i = 1, #entities do
			if entities[i].Type == 1000 and entities[i].Variant == 6 then
			
				room:RemoveGridEntity(52,0,false)
				entities[i]:Remove()
			end
		end

    end

end



--EVERY GAME UPDATE
function mod:PostUpdate()
    
	local room = level:GetCurrentRoom()
	
	--IF THE ROOM IS A DEVIL ROOM START ALL THE CHECKS
	if room:GetType() == RoomType.ROOM_DEVIL  then
	
		local entities = Isaac.GetRoomEntities()	
		local player = Isaac.GetPlayer( 0 )	

		--LOOP ALL THE ENTITIES
		for i = 1, #entities do
	    
	  
			  --IF ONE OF THE FALLEN ANGEL BORN FROM THE STATUE DIE
			   if entities[i]:HasMortalDamage() and (entities[i].Type == EntityType.ENTITY_URIEL or entities[i].Type == EntityType.ENTITY_GABRIEL) and entities[i].Variant == 1 and BossDeath == false and StatueDestroyed == true then
			   
				   --PLAY VICTORY MUSIC
				   music:Play(Music.MUSIC_JINGLE_BOSS_OVER  ,0.2)
				   music:Queue(Music.MUSIC_BOSS_OVER) 
				   
				   --SPAWN REWARDS
				   local roomCenter = room:GetCenterPos()
				   local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0,room:FindFreePickupSpawnPosition(roomCenter,0,true), Vector(0,0), nil):ToPickup()
				     pickup.AutoUpdatePrice = false
					 pickup.Price = PickupPrice.PRICE_SPIKES
					 
				   BossDeath = true
				   
			   end
   
   
   
				--IF A BOMB DESTORY THE DEVIL STATUE
				if entities[i].Type == 1000 and entities[i].Variant == 1 and entities[i].FrameCount == 1 then
					for j = 1, #entities do
						
						if entities[j].Type == 1000 and entities[j].Variant == 6 and entities[j].Position:Distance(entities[i].Position, entities[j].Position) < 80 and StatueDestroyed == false  then

							StatueDestroyed = true

							--CLOSE THE DOORS
							local enter_door = room:GetDoor(level.EnterDoor) 
						
							if enter_door ~= nil and enter_door:IsOpen() then
								enter_door:Bar()
							end

							
							--REMOVE DEVIL STATUE AND COLLISION
							room:RemoveGridEntity(52,0,false)
							entities[j]:Remove()
							
							
							--REMOVE DEVIL DEAL ITEMS
							for y = 1, #entities do
								if entities[y].Type == 5 then
									if entities[y]:ToPickup():IsShopItem() == true then
										entities[y]:Remove()   
									end
								end
							end
								
								
							--SPAWN ON OF THE FALLEN ANGEL
							local pos = entities[j].Position
							
							if random(50) then
								Isaac.Spawn(EntityType.ENTITY_URIEL , 1, 0,pos,Vector(0,0),player)
							else
								Isaac.Spawn(EntityType.ENTITY_GABRIEL , 1, 0,pos,Vector(0,0),player)
							end
						
							room:SetClear(false)											

					 
							--CHANGE THE MUSIC
							music:Play(Music.MUSIC_SATAN_BOSS ,0.2)
	
						end
					end
				end


		end --for entities loop end

	end --if devil room end
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL , mod.NewLevel)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdate)

local game = Game()
local backdropRNG = RNG()
backdropRNG:SetSeed(Random(), 3)
local api = {}
function api.Random(min, max, rng)
    rng = rng or backdropRNG
    if min ~= nil and max ~= nil then
        return math.floor(rng:RandomFloat() * (max - min + 1) + min)
    elseif min ~= nil then
        return math.floor(rng:RandomFloat() * (min + 1))
    end
    return rng:RandomFloat()
end
local function changeBackdrop(backdrop)
    backdropRNG:SetSeed(Game():GetRoom():GetDecorationSeed(), 0)
    local backdropVariant = backdrop
    for i = 1, 2 do
        local npc = Isaac.Spawn(EntityType.ENTITY_EFFECT, 82, 0, Vector(0, 0), Vector(0, 0), nil)
        local sprite = npc:GetSprite()
        sprite:Load("gfx/unique_rooms/backdrop.anm2", true)
        for num=0, 15 do
            local wall_to_use = backdropVariant.WALLS[api.Random(1, #backdropVariant.WALLS)]
            sprite:ReplaceSpritesheet(num, wall_to_use)
        end
        local nfloor_to_use = backdropVariant.NFLOORS[api.Random(1, #backdropVariant.NFLOORS)]
        local lfloor_to_use = backdropVariant.LFLOORS[api.Random(1, #backdropVariant.LFLOORS)]
        local corner_to_use = backdropVariant.CORNERS[api.Random(1, #backdropVariant.CORNERS)]
        sprite:ReplaceSpritesheet(16, nfloor_to_use)
        sprite:ReplaceSpritesheet(17, nfloor_to_use)
        sprite:ReplaceSpritesheet(18, lfloor_to_use)
        sprite:ReplaceSpritesheet(19, lfloor_to_use)
        sprite:ReplaceSpritesheet(20, lfloor_to_use)
        sprite:ReplaceSpritesheet(21, lfloor_to_use)
        sprite:ReplaceSpritesheet(22, lfloor_to_use)
        sprite:ReplaceSpritesheet(23, corner_to_use)
        npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(260,0)
        if Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then sprite:Play("1x1_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IH then sprite:Play("IH_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IV then
            sprite:Play("IV_room", true)
            npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(113,0)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x2 then sprite:Play("1x2_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IIV then
            sprite:Play("IIV_room", true)
            npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(113,0)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x1 then sprite:Play("2x1_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IIH then sprite:Play("IIH_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then sprite:Play("2x2_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LTL then sprite:Play("LTL_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LTR then sprite:Play("LTR_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LBL then sprite:Play("LBL_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LBR then sprite:Play("LBR_room", true) end
        sprite:LoadGraphics()
        if i == 1 then
        npc:ToEffect():AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
        end
    end
end
local challenge = {
    NFLOORS = {"gfx/unique_rooms/challenge_nfloor.png"},
    LFLOORS = {"gfx/unique_rooms/challenge_lfloor.png"},
    CORNERS = {"gfx/unique_rooms/null.png"},
    WALLS = {
        "gfx/unique_rooms/challenge_1.png",
        "gfx/unique_rooms/challenge_2.png",
        "gfx/unique_rooms/challenge_3.png"
    }
}    
function mod:MC_POST_NEW_ROOM()
	if Game():GetRoom():GetType() == RoomType.ROOM_CHALLENGE and eternalarenacanappear ~= 1 then
	changeBackdrop(challenge)
	elseif Game():GetRoom():GetBackdropType() == 15 and (Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x2 or Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x1 or Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x2) then
	changeBackdrop(cathedral)
        end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,mod.MC_POST_NEW_ROOM)

function mod:VOID_OVERLAY()
    if Game():GetLevel():GetStage() == LevelStage.STAGE7 then
        if void_sprite == nil then
        void_sprite = Sprite()
        void_sprite:Load("/gfx/backdrop/voidoverlay.anm2", true)
        end
    void_sprite:Render(Game():GetRoom():GetRenderSurfaceTopLeft(), Vector(0,0), Vector(0,0))
    void_sprite:Play("Stage",false)
    void_sprite:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.VOID_OVERLAY)

local game = Game()
local json = require("json")

-- Backdrop enums
BackdropType.MAUSOLEUM_BOSS = BackdropType.MAUSOLEUM3
BackdropType.GEHENNA_BOSS = BackdropType.MAUSOLEUM4
BackdropType.CORPSE_ENTRANCE_GEHENNA = BackdropType.MORTIS

-- Shorter room shape enums
local reg  = RoomShape.ROOMSHAPE_1x1
local IH   = RoomShape.ROOMSHAPE_IH
local IV   = RoomShape.ROOMSHAPE_IV
local tall = RoomShape.ROOMSHAPE_1x2
local IIV  = RoomShape.ROOMSHAPE_IIV
local long = RoomShape.ROOMSHAPE_2x1
local IIH  = RoomShape.ROOMSHAPE_IIH
local big  = RoomShape.ROOMSHAPE_2x2
local LTL  = RoomShape.ROOMSHAPE_LTL
local LTR  = RoomShape.ROOMSHAPE_LTR
local LBL  = RoomShape.ROOMSHAPE_LBL
local LBR  = RoomShape.ROOMSHAPE_LBR

-- Positions for custom room entities
local BackdropPositons = {
	{Vector(-20, 60),  Vector(660, 60),  Vector(-20, 500), Vector(660, 500)}, -- 1x1
	{Vector(-20, 140), Vector(660, 140), Vector(-20, 420), Vector(660, 420)}, -- IH
	{Vector(140, 60),  Vector(500, 60),  Vector(140, 500), Vector(500, 500)}, -- IV
	
	{Vector(-20, 60), Vector(660, 60), Vector(-20, 780), Vector(660, 780)}, -- 1x2
	{Vector(140, 60), Vector(500, 60), Vector(140, 780), Vector(500, 780)}, -- IIV
	
	{Vector(-20, 60),  Vector(1180, 60),  Vector(-20, 500), Vector(1180, 500)}, -- 2x1
	{Vector(-20, 140), Vector(1180, 140), Vector(-20, 420), Vector(1180, 420)}, -- IIH
	
	{Vector(-20, 60), Vector(1180, 60), Vector(-20, 780), Vector(1180, 780)}, -- 2x2
	
	{Vector(-20, 340), Vector(1180, 60),  Vector(-20, 780), Vector(1180, 780)}, -- LTL
	{Vector(-20, 60),  Vector(1180, 340), Vector(-20, 780), Vector(1180, 780)}, -- LTR
	{Vector(-20, 60),  Vector(1180, 60),  Vector(-20, 500), Vector(1180, 780)}, -- LBL
	{Vector(-20, 60),  Vector(1180, 60),  Vector(-20, 780), Vector(1180, 500)}, -- LBR
}

-- Positions for inner L room walls
local LinnerPositions = {
	Vector(-20,  340), -- LTL
	Vector(1180, 340), -- LTR
	Vector(-20,  500), -- LBL
	Vector(1180, 500), -- LBR
}

-- Mod config menu settings
local config = {
	-- General
	customrocks 	 = true,
	tintedcompat 	 = false,
	cooloverlays 	 = true,
	voidstatic 		 = true,
	randvoid 		 = true,
	-- Special rooms
	udevil 			 = true,
	uangel 			 = true,
	ucurse 			 = true,
	uchallenge 		 = true,
	ucrawlspace 	 = true,
	ubmarket 		 = true,
	-- Boss rooms
	custombossrooms  = true,
	customgreedrooms = true,
}



-- Load settings
function mod:postGameStarted()
    if mod:HasData() then
        local data = json.decode(mod:LoadData())
        for k, v in pairs(data) do
            if config[k] ~= nil then config[k] = v end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.postGameStarted)

-- Save settings
function mod:preGameExit() mod:SaveData(json.encode(config)) end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.preGameExit)



-- For Revelations compatibility
function mod:CheckForRev()
	if REVEL and REVEL.IsRevelStage(true) then
		return true
	else
		return false
	end
end



-- Spawn entities when entering a room
function mod:IBackdropsEnterRoom()
	local room = game:GetRoom()
	local bg = room:GetBackdropType()
	local rtype = room:GetType()
	local shape = room:GetRoomShape()
	local level = game:GetLevel()
	local stage = level:GetStage()
	local roomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

	if FiendFolio then
		config.customrocks = false
		config.uchallenge = false
		config.ucrawlspace = false
	end


	-- Check if boss room is valid for custom walls
	function IBackdropsIsValidBossRoom()
		if config.custombossrooms == true and (rtype == RoomType.ROOM_BOSS or rtype == RoomType.ROOM_MINIBOSS) and stage ~= LevelStage.STAGE7 and mod:CheckForRev() == false then
			return true
		else
			return false
		end
	end


	-- Non-persistent changes
	if room:IsInitialized() then
		-- Basement
		if bg == BackdropType.BASEMENT then
			if config.custombossrooms == true and rtype == RoomType.ROOM_MINIBOSS then
				IBackdropsCustomBG("boss_basement_1")
			end
		
		-- Cellar
		elseif bg == BackdropType.CELLAR then
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsChangeBG(bg, true)
				IBackdropsCustomBG("boss_cellar_1")
			end
		
		-- Burning Basement
		elseif bg == BackdropType.BURNT_BASEMENT then
			if room:GetDecorationSeed() % 2 == 0 or IBackdropsIsValidBossRoom() == true then
				IBackdropsCustomBG("burning_ash", "corner")
				if IBackdropsIsValidBossRoom() == true then
					IBackdropsCustomBG("boss_burning_1")
				end
				IBackdropsGetGrids("rocks_burning_custom")
			end
		
		-- Caves
		elseif bg == BackdropType.CAVES then
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsChangeBG(bg, true)
				IBackdropsCustomBG("boss_caves_1")
			end
			
		-- Catacombs
		elseif bg == BackdropType.CATACOMBS then
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsChangeBG(bg, true)
				IBackdropsCustomBG("boss_catacombs_1")
			end
			
		-- Flooded Caves
		elseif bg == BackdropType.FLOODED_CAVES then
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsCustomBG("boss_flooded_1")
			end
			
		-- Depths
		elseif bg == BackdropType.DEPTHS then
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsChangeBG(bg, true)
				IBackdropsCustomBG("boss_depths_1")
			else
				if shape ~= IV and shape ~= IIV then
					IBackdropsCustomBG("depths_pillar", "corner")
				end
			end
		
		-- Necropolis / Sacrifice rooms
		elseif bg == BackdropType.NECROPOLIS or bg == BackdropType.SACRIFICE then
			IBackdropsGetGrids("rocks_necropolis_custom")
			if bg == BackdropType.NECROPOLIS then
				if IBackdropsIsValidBossRoom() == true then
					IBackdropsChangeBG(bg, true)
					IBackdropsCustomBG("boss_necropolis_1")
				end
			end
		
		-- Dank Depths
		elseif bg == BackdropType.DANK_DEPTHS then
			IBackdropsGetGrids("rocks_dankdepths_custom")
			if IBackdropsIsValidBossRoom() == true then
				IBackdropsCustomBG("boss_dank_1")
			else
				if shape ~= IV and shape ~= IIV then
					IBackdropsCustomBG("dank_pillar", "corner")
				end
			end
		
		-- Scarred Womb
		elseif bg == BackdropType.SCARRED_WOMB then
			if room:HasWater() then
				IBackdropsGetGrids("rocks_scarredwomb_blood")
			end
			
		-- Sheol / Sheol backdrop special rooms
		elseif bg == BackdropType.SHEOL then
			if IBackdropsIsValidBossRoom() == true or (config.udevil == true and rtype == RoomType.ROOM_DEVIL) then
				IBackdropsCustomBG("devil_1")
				
			elseif config.ucurse == true and rtype == RoomType.ROOM_CURSE and mod:CheckForRev() == false then
				IBackdropsChangeBG(bg, true, "dark")
				IBackdropsCustomBG("curse", "corner_extras")
				IBackdropsCustomBG("curse", "corner_extras_curse", true)
				
			elseif config.uchallenge == true and (rtype == RoomType.ROOM_CHALLENGE or rtype == RoomType.ROOM_BOSSRUSH) and mod:CheckForRev() == false then
				if stage % 2 == 0 then
					IBackdropsChangeBG(bg, true, "dark")
				end
				IBackdropsCustomBG("bossrush")
				
			elseif config.ubmarket == true and rtype == RoomType.ROOM_BLACK_MARKET then
				IBackdropsCustomBG("blackmarket_1")
				IBackdropsGetGrids("rocks_depths")
			end
		
		-- Cathedral / Cathedral backdrop special rooms
		elseif bg == BackdropType.CATHEDRAL then
			if config.uangel == true and rtype == RoomType.ROOM_ANGEL then
				IBackdropsCustomBG("angel_1")
				IBackdropsGetGrids("rocks_angel")
				IBackdropsGetGrids("props_angel", GridEntityType.GRID_DECORATION)
				IBackdropsGetGrids("grid_pit_angel", GridEntityType.GRID_PIT)
			
			else
				if shape == tall or shape == long or shape == big then
					IBackdropsCustomBG("cathedral_trim")
				elseif shape == LBL or shape == LBR or shape == LTL or shape == LTR then
					IBackdropsCustomBG("cathedral_l_inner", "L")
				elseif shape == IH or shape == IIH or shape == IV or shape == IIV then
					IBackdropsCustomBG("ihv_cathedral")
				end
				if IBackdropsIsValidBossRoom() == true then
					IBackdropsCustomBG("boss_cathedral_1")
				end
			end
		
		-- Dark Room
		elseif bg == BackdropType.DARKROOM then
			IBackdropsGetGrids("rocks_darkroom_custom")
			if shape == IH or shape == IV or shape == IIH or shape == IIV or shape > 8 then
				IBackdropsDarkRoomBottom(shape, tostring((room:GetDecorationSeed() % 2) + 1))
			elseif shape == reg then
				if IBackdropsIsValidBossRoom() == true then
					IBackdropsCustomBG("boss_darkroom", "boss_darkroom")
					IBackdropsCustomBG("boss_darkroom", "boss_darkroom_lights", true)
				end
			end
		
		-- Chest
		elseif bg == BackdropType.CHEST then
			IBackdropsGetGrids("rocks_chest_custom")
		
		-- Shop
		elseif bg == BackdropType.SHOP then
			if shape == reg and not (mod:CheckForRev() == true and StageAPI.GetCurrentRoomType() == "VanityShop") then
				IBackdropsCustomBG("shop_1")
			end
			if (config.customgreedrooms == true and roomDesc.SurpriseMiniboss == true) or stage == LevelStage.STAGE4_3 then
				IBackdropsCustomBG("greed_shop")
			end
		
		-- Secret Room
		elseif bg == BackdropType.SECRET then
			if (config.customgreedrooms == true and roomDesc.SurpriseMiniboss == true) or rtype == RoomType.ROOM_SHOP then
				IBackdropsCustomBG("greed_secret")
			elseif rtype == RoomType.ROOM_SECRET_EXIT then
				IBackdropsChangeBG(BackdropType.MINES_ENTRANCE)
			end
		
		-- Dice rooms
		elseif bg == BackdropType.DICE then
			IBackdropsGetGrids("rocks_red")
		
		-- Crawlspaces
		elseif bg == BackdropType.DUNGEON then
			if stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or stage == LevelStage.STAGE5 then
				IBackdropsCrawlspace("tiles_itemdungeon_gray")
			elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
				if level:GetStageType() == StageType.STAGETYPE_REPENTANCE then
					IBackdropsCrawlspace("tiles_rotgut")
				else
					IBackdropsCrawlspace("tiles_womb")
				end
			elseif stage == LevelStage.STAGE4_3 then
				IBackdropsCrawlspace("tiles_bluewomb")
			end
		
		-- Downpour
		elseif bg == BackdropType.DOWNPOUR then
			if IBackdropsIsValidBossRoom() then
				IBackdropsCustomBG("boss_downpour_1")
			end
		
		-- Mines
		elseif bg == BackdropType.MINES or bg == BackdropType.MINES_SHAFT then
			IBackdropsGetGrids("rocks_mines_custom")
			if IBackdropsIsValidBossRoom() then
				-- Remove decoration sprites that don't fit
				for i,problematics in pairs(Isaac.GetRoomEntities()) do
					if problematics.Type == EntityType.ENTITY_EFFECT and problematics.Variant == EffectVariant.BACKDROP_DECORATION then
						if problematics:GetSprite():GetFilename() ~= "gfx/backdrop/03x_mines_lanterns.anm2" and problematics:GetSprite():GetFilename() ~= "gfx/backdrop/03x_mines_lanterns_dark.anm2" then	
							problematics:Remove()
						end
					end
				end
				IBackdropsCustomBG("boss_mines_1")
			-- Better wall details for IH and IV rooms
			elseif shape == IH or shape == IIH or shape == IV or shape == IIV then
				for i,problematics in pairs(Isaac.GetRoomEntities()) do
					if problematics.Type == EntityType.ENTITY_EFFECT and problematics.Variant == EffectVariant.BACKDROP_DECORATION then
						local problemsprite = problematics:GetSprite()
						
						if problemsprite:GetFilename() == "gfx/backdrop/03x_mines_bg_details.anm2" or problemsprite:GetFilename() == "gfx/backdrop/03x_mines_bg_details_dark.anm2" then	
							if shape == IH or shape == IIH then
								problemsprite:SetFrame(1)
							elseif shape == IV or shape == IIV then
								problemsprite:SetFrame(2) -- Why don't the light layers change frame??
							end
						end
					end
				end
			end
		
		-- Mausoleum
		elseif bg == BackdropType.MAUSOLEUM or bg == BackdropType.MAUSOLEUM2 or bg == BackdropType.MAUSOLEUM_ENTRANCE or bg == BackdropType.MAUSOLEUM3 then
			IBackdropsGetGrids("rocks_mausoleum_custom")

			if bg == BackdropType.MAUSOLEUM or bg == BackdropType.MAUSOLEUM2 then
				if IBackdropsIsValidBossRoom() then
					IBackdropsChangeBG(BackdropType.MAUSOLEUM_BOSS)
				else
					local add = "1"
					if bg == BackdropType.MAUSOLEUM2 then
						add = "2"
					end
					
					if shape == LBL or shape == LBR or shape == LTL or shape == LTR then
						IBackdropsCustomBG("mausoleum_l_inner_" .. add, "L")
					elseif shape == IH or shape == IIH or shape == IV or shape == IIV then
						IBackdropsCustomBG("ihv_mausoleum_" .. add)
					end
				end
			end
		
		-- Dross
		elseif bg == BackdropType.DROSS then
			if not room:HasWater() then
				IBackdropsCustomBG("dross_drain", "corner")
			end
			if IBackdropsIsValidBossRoom() then
				IBackdropsCustomBG("boss_dross_1")
			end
		
		-- Ashpit
		elseif bg == BackdropType.ASHPIT then
			if room:HasWaterPits() or (roomDesc.Flags & RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP > 0) then
				IBackdropsGetGrids("rocks_ashpit_ash")
				if (roomDesc.Flags & RoomDescriptor.FLAG_USE_ALTERNATE_BACKDROP > 0) and not room:HasWaterPits() then
					IBackdropsGetGrids("grid_pit_ashpit_ash", GridEntityType.GRID_PIT)
				end
			else
				IBackdropsGetGrids("rocks_ashpit_custom")
			end
			if IBackdropsIsValidBossRoom() then
				IBackdropsCustomBG("boss_ashpit_1")
			end
		
		-- Gehenna
		elseif bg == BackdropType.GEHENNA then
			-- Post-Mom's Heart
			if game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED) and stage == LevelStage.STAGE3_2 then
				IBackdropsChangeBG(BackdropType.CORPSE_ENTRANCE_GEHENNA, true, "dark")
				-- Remove wall details
				for i,problematics in pairs(Isaac.GetRoomEntities()) do
					if problematics.Type == EntityType.ENTITY_EFFECT and problematics.Variant == EffectVariant.BACKDROP_DECORATION then
						if problematics:GetSprite():GetFilename() == "gfx/backdrop/06x_gehenna_wall_details.anm2" then	
							problematics:Remove()
						end
					end
				end
			else
				if IBackdropsIsValidBossRoom() then
					IBackdropsChangeBG(BackdropType.GEHENNA_BOSS)
				else
					if shape == LBL or shape == LBR or shape == LTL or shape == LTR then
						IBackdropsCustomBG("gehenna_l_inner", "L")
					elseif shape == IH or shape == IIH or shape == IV or shape == IIV then
						IBackdropsCustomBG("ihv_gehenna")
					end
				end
			end
		end
		
		-- Randomized Void backdrops
		if config.randvoid == true and stage == LevelStage.STAGE7 and rtype == RoomType.ROOM_DEFAULT and bg ~= BackdropType.DARKROOM then
			IBackdropsChangeBG()
		end
	end
	
	
	-- Persistent changes
	if room:IsFirstVisit() then
		-- Overlays
		if bg == BackdropType.CELLAR or bg == BackdropType.CAVES or bg == BackdropType.FLOODED_CAVES or bg == BackdropType.DEPTHS or bg == BackdropType.DANK_DEPTHS 
		or (bg == BackdropType.SHEOL and rtype == RoomType.ROOM_DEFAULT) or bg == BackdropType.DOWNPOUR_ENTRANCE then
			IBackdropsTopDecorPositions(shape)
			
		-- Dark Room decoration grids
		elseif bg == BackdropType.DARKROOM and rtype ~= RoomType.ROOM_BOSS then
			IBackdropsSpawnDecorGrids(shape)
		end
	end

	SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.EARLY, mod.IBackdropsEnterRoom)



-- Custom walls
function IBackdropsCustomBG(sheet, anim, animated)
	local shape = game:GetRoom():GetRoomShape()

	if anim == "corner" then
		anim = "corner_extras"
	elseif anim == "L" then
		anim = "wall_L_inner"
	elseif not anim then
		anim = "walls"
	end

	local type = EffectVariant.BACKDROP_DECORATION
	local flags = EntityFlag.FLAG_RENDER_FLOOR | EntityFlag.FLAG_RENDER_WALL | EntityFlag.FLAG_BACKDROP_DETAIL
	if animated == true then
		type = EffectVariant.WORMWOOD_HOLE
		flags = EntityFlag.FLAG_BACKDROP_DETAIL
	end


	-- L room inner walls
	if anim == "wall_L_inner" then
		local backdrop = Isaac.Spawn(EntityType.ENTITY_EFFECT, type, 0, LinnerPositions[shape - 8], Vector.Zero, nil):ToEffect()
		backdrop:AddEntityFlags(flags)
		backdrop.DepthOffset = -10000

		local sprite = backdrop:GetSprite()
		sprite:Load("gfx/backdrop/custom/" .. anim .. ".anm2", false)
		for i = 0, sprite:GetLayerCount() do
			sprite:ReplaceSpritesheet(i, "gfx/backdrop/custom/" .. sheet .. ".png")
		end
		sprite:LoadGraphics()
		sprite:SetFrame(sprite:GetDefaultAnimation(), shape - 9)


	-- Walls / Corner details
	else
		for p = 1, 4 do
			local backdrop = Isaac.Spawn(EntityType.ENTITY_EFFECT, type, 0, BackdropPositons[shape][p], Vector.Zero, nil):ToEffect()
			backdrop:AddEntityFlags(flags)
			backdrop.DepthOffset = -10000

			local sprite = backdrop:GetSprite()
			sprite:Load("gfx/backdrop/custom/" .. anim .. ".anm2", false)
			for i = 0, sprite:GetLayerCount() do
				sprite:ReplaceSpritesheet(i, "gfx/backdrop/custom/" .. sheet .. ".png")
			end
			sprite:LoadGraphics()

			if anim == "walls" then
				sprite:Play(shape, true)
			else
				sprite:Play(sprite:GetDefaultAnimation(), true)
			end
			sprite:SetFrame(p - 1)
		end
	end
end



-- Persistent entity
function mod:IBackdropsPersistentEntity(entity)
	if config.cooloverlays == true and entity.SubType == 2727 and entity.FrameCount == 0 then
		local sprite = entity:GetSprite()
		local bg = game:GetRoom():GetBackdropType()

		local sheet = "cobwebs"
		if bg == BackdropType.CAVES then
			sheet = "caves"
		elseif bg == BackdropType.FLOODED_CAVES then
			sheet = "flooded"
		elseif bg == BackdropType.DEPTHS then
			sheet = "depths"
		elseif bg == BackdropType.DANK_DEPTHS then
			sheet = "dank"
		elseif bg == BackdropType.SHEOL then
			sheet = "sheol"
		elseif bg == BackdropType.DOWNPOUR_ENTRANCE then
			sheet = "downpour"
		end

		sprite:Load("gfx/backdrop/custom/overlay.anm2", false)
		sprite:ReplaceSpritesheet(0, "gfx/backdrop/custom/overlay_" .. sheet .. ".png")
		sprite:SetFrame(sprite:GetDefaultAnimation(), entity.State % 10) -- set frame to the last digit of the state (even numbers - left, odd numbers - right)
		sprite:LoadGraphics()
		entity.DepthOffset = 10000 -- make the entity appear above other ones
		entity.Visible = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.IBackdropsPersistentEntity, EffectVariant.SPAWNER)

-- Get overlay decor positions
function IBackdropsTopDecorPositions(shape)
	local values = {}
	
	if shape == IV or shape == IIV then
		table.insert(values, {0, 140, false}) -- left
		table.insert(values, {1, 500, false}) -- right
		
	else
		local thin = false
		local extra = 0
		if shape == IH or shape == IIH then
			thin = true
		elseif shape == LTL then
			extra = 520
		end
		
		table.insert(values, {0, -20 + extra, thin}) -- left
		table.insert(values, {2, 180 + extra, thin}) -- extra left

		if shape == long or shape == big or shape == LBL or shape == LBR or shape == IIH then
			table.insert(values, {2, 380, thin}) -- extra left
			table.insert(values, {3, 780, thin}) -- extra right
			table.insert(values, {3, 980, thin}) -- extra right
			table.insert(values, {1, 1180, thin}) -- right
			
		else
			table.insert(values, {1, 660 + extra, thin}) -- right
			table.insert(values, {3, 460 + extra, thin}) -- extra right
		end
	end
	
	for i, entry in pairs(values) do
		IBackdropsSpawnTopDecor(entry[1], entry[2], entry[3])
	end
end

-- Spawn overlay decor
function IBackdropsSpawnTopDecor(type, x, thin)
	if math.random(1, 8) > 5 then
		local y = 60
		if thin == true then -- If room is thin horizontal
			y = 140
		end
		local alt = math.random(0, 1) * 4
		
		local entity = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPAWNER, 2727, Vector(x, y), Vector.Zero, nil):ToEffect()
		entity.State = 2000 + type + alt
	end
end



function IBackdropsChangeBG(id, bloody, bloodtype)
	if bloody == true then
		local bloodID = BackdropType.BASEMENT
		if bloodtype == "dark" then
			bloodID = BackdropType.CORPSE_ENTRANCE
		end
		game:ShowHallucination(0, bloodID)
		SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
	end
	game:ShowHallucination(0, id)
	SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
end



-- Go through all grid entities and replace their spritesheet if they're a rock variant
function IBackdropsGetGrids(spritesheet, checkType)
	if config.customrocks == true then
		local room = game:GetRoom()
		
		for grindex = 0, room:GetGridSize() - 1 do
			if room:GetGridEntity(grindex) ~= nil then
				local grid = room:GetGridEntity(grindex)
				local replace = false
				
				if checkType == nil and IBackdropsIsRock(grid:GetType()) == true then
					replace = true
				elseif grid:GetType() == checkType then
					replace = true
				end
				
				if replace == true then
					local gridsprite = grid:GetSprite()
					gridsprite:ReplaceSpritesheet(0, "gfx/grid/" .. spritesheet .. ".png")
					if checkType ~= GridEntityType.GRID_PIT then
						gridsprite:ReplaceSpritesheet(1, "gfx/grid/" .. spritesheet .. ".png")
					end
					gridsprite:LoadGraphics()
				end
			end
		end
	end
end

-- Check if the grid entity is a rock variant
function IBackdropsIsRock(t)
	if config.tintedcompat == true then
		if t == 2 or t == 3 or t == 5 or t == 6 or t == 22 or t == 24 or t == 25 or t == 26 or t == 27 then
			return true
		end
	else
		if t == 2 or t == 3 or t == 4 or t == 5 or t == 6 or t == 22 or t == 24 or t == 25 or t == 26 or t == 27 then
			return true
		end
	end
end

-- Replace crawlspace grids
function IBackdropsCrawlspace(spritesheet)
	if config.ucrawlspace == true then
		local room = game:GetRoom()

		for grindex = 0, room:GetGridSize() - 1 do
			if room:GetGridEntity(grindex) ~= nil then
				local gtype = room:GetGridEntity(grindex):GetType()
				local gridsprite = room:GetGridEntity(grindex):GetSprite()
				
				if gtype == GridEntityType.GRID_WALL or gtype == GridEntityType.GRID_DECORATION or (gtype == GridEntityType.GRID_GRAVITY and gridsprite:GetFilename() ~= "") then
					gridsprite:ReplaceSpritesheet(0, "gfx/grid/" .. spritesheet .. ".png")
					gridsprite:ReplaceSpritesheet(1, "gfx/grid/" .. spritesheet .. ".png")
					gridsprite:LoadGraphics()
				end
			end
		end
	end
end



-- Spawn decoration grids
function IBackdropsSpawnDecorGrids(shape)
	local debrisExtra = 0
	if shape == tall or shape == long then
		debrisExtra = 2
	elseif shape == IH or shape == IV then
		debrisExtra = -2
	elseif shape >= 8 then
		debrisExtra = 4
	end

	for i = 0, math.random(1, 4 + debrisExtra) do
		Isaac.GridSpawn(GridEntityType.GRID_DECORATION, 1, Isaac.GetRandomPosition(), false)
	end
end



-- Special overlays
function mod:IBackdropsVoidOverlay()
    if config.voidstatic == true and game:GetLevel():GetStage() == LevelStage.STAGE7 then
        if static == nil then
			static = Sprite()
			static:Load("/gfx/backdrop/void_static.anm2", true)
        end
		
		static:Render(game:GetRoom():GetRenderSurfaceTopLeft(), Vector.Zero, Vector.Zero)
		static:Play("Stage", false)
		static:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.IBackdropsVoidOverlay)



-- Dark Room bottom
function IBackdropsDarkRoomBottom(shape, spritesheet)
	local spawns = {}

	if shape == IH then
		table.insert(spawns, {Vector(-13, 410), 0}) -- Left
		table.insert(spawns, {Vector(652, 410), 4}) -- Right
	elseif shape == IV then
		table.insert(spawns, {Vector(147, 490), 3}) -- Bottom
	elseif shape == IIV then
		table.insert(spawns, {Vector(147, 770), 3}) -- Bottom
	elseif shape == IIH then
		table.insert(spawns, {Vector(-13,  410), 1}) -- Left
		table.insert(spawns, {Vector(1172, 410), 5}) -- Right
	elseif shape == LTL or shape == LTR then
		table.insert(spawns, {Vector(-13,  770), 1}) -- Left
		table.insert(spawns, {Vector(1172, 770), 5}) -- Right
	elseif shape == LBL then
		table.insert(spawns, {Vector(507,  770), 0}) -- Left
		table.insert(spawns, {Vector(1172, 770), 4}) -- Right
		table.insert(spawns, {Vector(-13,  490), 2}) -- Left extra
	elseif shape == LBR then
		table.insert(spawns, {Vector(-13,  770), 0}) -- Left
		table.insert(spawns, {Vector(652,  770), 4}) -- Right
		table.insert(spawns, {Vector(1172, 490), 6}) -- Right extra
	end
	
	for i, entry in pairs(spawns) do
		local backdrop = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BACKDROP_DECORATION, 0, entry[1], Vector.Zero, nil):ToEffect()
		backdrop:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR | EntityFlag.FLAG_RENDER_WALL | EntityFlag.FLAG_BACKDROP_DETAIL)
		backdrop.DepthOffset = -10000

		local sprite = backdrop:GetSprite()
		sprite:Load("gfx/backdrop/custom/darkroom_bottom.anm2", false)
		sprite:SetFrame(sprite:GetDefaultAnimation(), entry[2])
		sprite:ReplaceSpritesheet(0, "gfx/backdrop/custom/darkroom_bottom_" .. spritesheet .. ".png")
		sprite:ReplaceSpritesheet(1, "gfx/backdrop/custom/darkroom_bottom_" .. spritesheet .. ".png")
		sprite:LoadGraphics()
	end
end



-- Menu options
if ModConfigMenu then
  	local category = "Improved Backdrops"
	ModConfigMenu.RemoveCategory(category);
  	ModConfigMenu.UpdateCategory(category, {
		Name = category,
		Info = "Change settings for Improved Backdrops"
	})
	
	-- General settings
	ModConfigMenu.AddSetting(category, "General", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.customrocks end,
	    Display = function() return "Custom rocks: " .. (config.customrocks and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.customrocks = bool
	    end,
	    Info = {"Enable/Disable the mod's custom rocks. (default = on)"}
  	})
	
  	ModConfigMenu.AddSetting(category, "General", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.tintedcompat end,
	    Display = function() return "Tinted rock compatibility: " .. (config.tintedcompat and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.tintedcompat = bool
	    end,
	    Info = {"(for the custom rocks option) Tinted rocks will not use custom sprites, allowing you to use tinted rock mods. (default = off)"}
  	})
	
	ModConfigMenu.AddSetting(category, "General", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.cooloverlays end,
	    Display = function() return "Overlay details: " .. (config.cooloverlays and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.cooloverlays = bool
	    end,
	    Info = {"Enable/Disable overlay details eg. Stalactites in caves. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "General", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.voidstatic end,
	    Display = function() return "Void Overlay: " .. (config.voidstatic and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.voidstatic = bool
	    end,
	    Info = {"Enable/Disable the Void overlay. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "General", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.randvoid end,
	    Display = function() return "Randomize Void backdrops: " .. (config.randvoid and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.randvoid = bool
	    end,
	    Info = {"Enable/Disable randomized Void backdrops. (default = on)"}
  	})

	
	-- Unique special rooms
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.udevil end,
	    Display = function() return "Unique devil rooms: " .. (config.udevil and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.udevil = bool
	    end,
	    Info = {"Enable/Disable unique devil rooms. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.uangel end,
	    Display = function() return "Unique angel rooms: " .. (config.uangel and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.uangel = bool
	    end,
	    Info = {"Enable/Disable unique angel rooms. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.ucurse end,
	    Display = function() return "Unique curse rooms: " .. (config.ucurse and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.ucurse = bool
	    end,
	    Info = {"Enable/Disable unique curse rooms. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.uchallenge end,
	    Display = function() return "Unique challenge rooms: " .. (config.uchallenge and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.uchallenge = bool
	    end,
	    Info = {"Enable/Disable unique challenge rooms. This also applies to boss rush. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.ucrawlspace end,
	    Display = function() return "Unique crawlspaces: " .. (config.ucrawlspace and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.ucrawlspace = bool
	    end,
	    Info = {"Enable/Disable unique crawlspaces. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Special", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.ubmarket end,
	    Display = function() return "Unique black market: " .. (config.ubmarket and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.ubmarket = bool
	    end,
	    Info = {"Enable/Disable unique black markets. (default = on)"}
  	})
	
	
	-- Unique boss / miniboss rooms
	ModConfigMenu.AddSetting(category, "Boss", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.custombossrooms end,
	    Display = function() return "Unique boss rooms: " .. (config.custombossrooms and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.custombossrooms = bool
	    end,
	    Info = {"Enable/Disable unique boss rooms. (default = on)"}
  	})
	
	ModConfigMenu.AddSetting(category, "Boss", {
    	Type = ModConfigMenu.OptionType.BOOLEAN,
	    CurrentSetting = function() return config.customgreedrooms end,
	    Display = function() return "Unique Greed miniboss rooms: " .. (config.customgreedrooms and "On" or "Off") end,
	    OnChange = function(bool)
	    	config.customgreedrooms = bool
	    end,
	    Info = {"Enable/Disable unique Greed miniboss rooms. (default = on)"}
  	})
end

isaacisdamagedinbeastfight = 0

function mod:beastlaughanimation(npc)
if npc.Type == 1 and #Isaac.FindByType(951, 100, -1, false, true) >= 1 and isaacisdamagedinbeastfight == 0 then
isaacisdamagedinbeastfight = 1
end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.beastlaughanimation);

function mod:beastlaughanimation(npc)
if isaacisdamagedinbeastfight == 1 and npc.Type == 951 and npc.Variant == 100 and npc:GetSprite():IsPlaying("Idle") then
npc:GetSprite():Play("Laugh", true)
end
if npc:GetSprite():IsFinished("Laugh") and npc.Type == 951 and npc.Variant == 100 and isaacisdamagedinbeastfight == 1 then
npc:GetSprite():Play("Idle", true)
isaacisdamagedinbeastfight = 0
end
if npc.Type == 951 and npc.Variant == 40 and npc:IsDead() then
isaacisdamagedinbeastfight = 2
end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.beastlaughanimation)

local game = Game()
local rng = RNG()

--Initialize resprited Lil' Portal
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc) 
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Variant == 1 and data.Gehenna == nil then
        --Check for Gehenna backdrop
        if game:GetRoom():GetBackdropType() == 47 then
            sprite:Load("gfx/monsters/repentance/lil_portal_red.anm2", true)
            data.Gehenna = true
        --Check if current stage is Gehenna
        elseif game:GetLevel():GetStage() == 5 or game:GetLevel():GetStage() == 6 then
            if game:GetLevel():GetStageType() == 5 then
                sprite:Load("gfx/monsters/repentance/lil_portal_red.anm2", true)
                data.Gehenna = true
            end     
        else
            data.Gehenna = false
        end
    end
end, 306)

--Update SplatColor every frame because I have to :(
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc) 
    if npc:GetData()["Gehenna"] then
        npc.SplatColor = Color(1, 0.95, 0.95, 0.5, 0.5, 0.2, 0.2)
    end
end, 306)

--Detect enemies spawned by resprited Lil' Portal
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc) 
    if npc.SpawnerEntity then
        if npc.SpawnerEntity.Type == 306 and npc.SpawnerEntity:GetData()["Gehenna"] then
            npc:SetColor(Color(1, 1, 1, 1, ((0.7 / 35) * (35 - npc.FrameCount)), 0, 0), 2, 1, true, false)
            npc:GetData()["RedFade"] = true
        end
    end 
end)

--Add red-colored fade out effect to the spawned enemies
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc) 
    if npc:GetData()["RedFade"] and npc.FrameCount < 35 then
        npc:SetColor(Color(1, 1, 1, 1, ((0.7 / 35) * (35 - npc.FrameCount)), 0, 0), 2, 1, true, false)
    end
end)

local game = Game()
local json = require("json")
local data

--save/load

function mod:onGameStart(con)
	if not con then
		data = {
			foundItem = {},
			check = false
		}
	else
		local dataLoaded = Isaac.LoadModData(mod)
		data = json.decode(dataLoaded)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)


function mod:preGameExit(shouldSave)
	if shouldSave then
		Isaac.SaveModData(mod, json.encode(data, "data"))
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.preGameExit)


--Chest Replacements

function mod:chestReplace(pickup)
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and room:GetType() ~= RoomType.ROOM_CHALLENGE and stage ~= 11 and not pickup:GetData().nomorph then
		if pickup.Variant == 60 and math.random(100) <= 5 then
			pickup:Morph(5, 55, 0, true, true, false)
		elseif pickup.Variant == 50 and math.random(100) <= 5 then
			pickup:Morph(5, 56, 0, true, true, false)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.chestReplace)


--Red Chest Extra Loot

function mod:red(pickup)
	if pickup:GetSprite():IsPlaying("Open") and pickup:GetSprite():GetFrame() == 1 then
		if math.random(5) == 1 then
			Isaac.Spawn(5, 300, 78, pickup.Position, Vector.FromAngle(math.random(360)) * 5, nil)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.red, PickupVariant.PICKUP_REDCHEST)

--Dupe Protection

function mod:foundItemInit()
	if not data then return end
	if Game():GetLevel():GetCurrentRoomIndex() ~= Game():GetLevel():GetStartingRoomIndex() and not data.check then
		for i = 1, 1000 do 
			for y = 0, Game():GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(y)
				if player:HasCollectible(i) then table.insert(data.foundItem, i) end
			end
		end
		data.check = true
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.foundItemInit)


function mod:foundItem(item)
	if not data then return end
	local unique = true
	for i = 1, #data.foundItem do if item.SubType == data.foundItem[i] then unique = false end end
	if unique == true then table.insert(data.foundItem, item.SubType) end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.foundItem, 100)

 --Set key binding
local hudToggleButton = Keyboard.KEY_H

local game = Game()
local seeds = game:GetSeeds()
local hudOn = true

function onUpdate()
	if Input.IsButtonPressed(hudToggleButton, 0) then 
		pressCount = pressCount + 1
	else
		pressCount = 0
	end
	
	if pressCount == 1 then
		if hudOn ~= false then
			seeds:AddSeedEffect(SeedEffect.SEED_NO_HUD)
			hudOn = false
		else
			seeds:RemoveSeedEffect(SeedEffect.SEED_NO_HUD)
			hudOn = true
		end
	end	
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)

function mod:onTear(tear)
	local player = Isaac.GetPlayer(0)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
		local playerType = player:GetPlayerType()
		if (playerType == PlayerType.PLAYER_KEEPER) or (playerType == PlayerType.PLAYER_KEEPER_B) then
			tear:ChangeVariant(TearVariant.COIN)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR , mod.onTear)

function mod:SwapRocks(entitytype, variant, subtype, gridindex, seed)
    -- rock check
    if entitytype ~= 1000 then return end -- 1000 = normal rocks
    
    -- floor check
    if (Game():GetLevel():GetStage() == LevelStage.STAGE2_1 or Game():GetLevel():GetStage() == LevelStage.STAGE2_2) and (Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE or Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B) then
        local roomrng = RNG()
        roomrng:SetSeed(Game():GetRoom():GetDecorationSeed(), 35)
		-- Chance of room with gold rocks: 33% default
        if roomrng:RandomFloat() < 0.33 then
            local rockrng = RNG()
            rockrng:SetSeed(seed, 35)
			-- Chance of gold rock within room: 12% default
            if rockrng:RandomFloat() < 0.12 then return {1011, variant, subtype} end -- 1011 = gold rocks
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.SwapRocks)

function mod:ae()
local entities = Isaac.GetRoomEntities()
for i = 1, #entities do
if (entities[i].Type == 7) and (entities[i].Variant == 5) and (entities[i].Parent ~= nil) and (entities[i].Parent.Type == 271) and (entities[i].Parent.Variant == 1) then
entities[i]:SetColor(Color(0.9,0,0,1,0,0,0),155,1,false,false)
end
if (entities[i].Type == 7) and (entities[i].Variant == 5) and (entities[i].Parent ~= nil) and (entities[i].Parent.Type == 272) and (entities[i].Parent.Variant == 1) then
entities[i]:SetColor(Color(0.9,0,0,1,0,0,0),155,1,false,false)
end
end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE , mod.ae)

_G.Onseshigo = _G.Onseshigo or {}
_G.Onseshigo.MissingCostumes = mod

mod.Options = mod.Options or {}
mod.Options.NullCostumes = true
mod.Options.KeeperB_anm2 = true


mod.NullItemID = {}

mod.NullItemID.ID_AZAZEL_TOOTH_AND_NAIL			=	Isaac.GetCostumeIdByPath("gfx/characters/character_08_azazel_toothandnail.anm2")

mod.NullItemID.ID_BLUEBABY_B_IPECAC				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_ipecac.anm2")
mod.NullItemID.ID_BLUEBABY_B_SCORPIO			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_scorpio.anm2")
mod.NullItemID.ID_BLUEBABY_B_BLUECAP			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_bluecap.anm2")
mod.NullItemID.ID_BLUEBABY_B_SOAP				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_barofsoap.anm2")
mod.NullItemID.ID_BLUEBABY_B_KNOCKOUTDROPS		=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_knockoutdrops.anm2")
mod.NullItemID.ID_BLUEBABY_B_REVELATION			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_revelation.anm2")

mod.NullItemID.ID_FORGOTTEN_B_MUSHROOM			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_mushroom.anm2")
mod.NullItemID.ID_FORGOTTEN_B_BOB				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_bob.anm2")
mod.NullItemID.ID_FORGOTTEN_B_POOP				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_poop.anm2")


mod.Costumes = {
--	{PlayerType=PlayerType.PLAYER_AZAZEL,			NullEffect=NullItemID.ID_TOOTH_AND_NAIL,					Costume=mod.NullItemID.ID_AZAZEL_TOOTH_AND_NAIL,		Default=NullItemID.ID_AZAZEL,		Allowed=false,	Added=false,},	-- WIP

	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_IPECAC,				Costume=mod.NullItemID.ID_BLUEBABY_B_IPECAC,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_SCORPIO,			Costume=mod.NullItemID.ID_BLUEBABY_B_SCORPIO,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_BLUE_CAP,			Costume=mod.NullItemID.ID_BLUEBABY_B_BLUECAP,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_BAR_OF_SOAP,		Costume=mod.NullItemID.ID_BLUEBABY_B_SOAP,				Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,		Costume=mod.NullItemID.ID_BLUEBABY_B_KNOCKOUTDROPS,		Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_REVELATION,			Costume=mod.NullItemID.ID_BLUEBABY_B_REVELATION,		Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},

	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_MUSHROOM,					Costume=mod.NullItemID.ID_FORGOTTEN_B_MUSHROOM,			Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_BOB,						Costume=mod.NullItemID.ID_FORGOTTEN_B_BOB,				Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_POOP,						Costume=mod.NullItemID.ID_FORGOTTEN_B_POOP,				Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
}


function mod:setCostumes(player)
	local playerSprite = player:GetSprite()
	if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) and (playerSprite:GetFilename():lower() == "gfx/001.000_player.anm2") and mod.Options.KeeperB_anm2 then
		playerSprite:Load("gfx/001.000_player_keeperb.anm2", true)
		Isaac.DebugString('[MissingCostumes] changed .anm2 for player ' .. player.ControllerIndex .. 'to custom')
	end
	if (player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B) and (playerSprite:GetFilename():lower() == "gfx/001.000_player_keeperb.anm2") then
		playerSprite:Load("gfx/001.000_player.anm2", true)
		Isaac.DebugString('[MissingCostumes] changed .anm2 for player ' .. player.ControllerIndex .. 'to default')
	end

	if mod.Options.NullCostumes then
		for i, _ in ipairs(mod.Costumes) do
			if mod.Costumes[i].Allowed and (mod.Costumes[i].Costume ~= -1) then
				if mod.Costumes[i].Collectible then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:HasCollectible(mod.Costumes[i].Collectible) and player:GetCollectibleNum(mod.Costumes[i].Collectible, true) > 0 and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for item ' .. mod.Costumes[i].Collectible)
						end
						if not player:HasCollectible(mod.Costumes[i].Collectible) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for item ' .. mod.Costumes[i].Collectible)
						end
					end
				elseif mod.Costumes[i].PlayerForm then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:HasPlayerForm(mod.Costumes[i].PlayerForm) and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for player form ' .. mod.Costumes[i].PlayerForm)
						end
						if not player:HasPlayerForm(mod.Costumes[i].PlayerForm) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for player form ' .. mod.Costumes[i].PlayerForm)
						end
					end
				elseif mod.Costumes[i].NullEffect then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:GetEffects():HasNullEffect(mod.Costumes[i].NullEffect) and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for nulleffect ' .. mod.Costumes[i].NullEffect)
						end
						if not player:GetEffects():HasNullEffect(mod.Costumes[i].NullEffect) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for nulleffect ' .. mod.Costumes[i].NullEffect)
						end
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.setCostumes)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.setCostumes)

function mod:onStart(savestate)
	if savestate then
		if mod:HasData() then mod.Storage = json.decode(mod:LoadData())
		else mod.Storage = {} end
	else
		if mod:HasData() then mod:RemoveData() end
		mod.Storage = {}
	end
	
	-- To stop the luck penalty not updating on new / resumed runs
	local player = Isaac.GetPlayer(0)
	player:AddCacheFlags(CacheFlag.CACHE_LUCK)
	player:EvaluateItems()
end

function mod:onEnd()
    if mod.Storage ~= nil then
        mod:SaveData(json.encode(mod.Storage))
    end
end

function mod:onUpdate()
	-- this mod ONLY does things on downpour/dross 2, so check that first for efficiency
	local level = Game():GetLevel()
	if level:GetStage() == LevelStage.STAGE1_2 and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B) then
		local room = Game():GetRoom()
		for k,v in pairs({60, 74}) do -- this is checking the left and right door slots, since those are where the mirror might be
			if room:GetGridEntity(v) and room:GetGridEntity(v):GetType() == GridEntityType.GRID_DOOR and room:GetGridEntity(v):ToDoor().TargetRoomIndex == -100 then
				--local brokenMirror = room:GetGridEntity(v):ToDoor().Busted
				local brokenMirror = room:GetGridEntity(v).Desc.Variant == 8
				if mod.BrokenMirror == nil then
					mod.BrokenMirror = brokenMirror
				elseif mod.BrokenMirror == true and brokenMirror == false then
					mod.BrokenMirror = false
				elseif mod.BrokenMirror == false and brokenMirror == true then
					-- The real code!
					if mod.Storage.MirrorMisfortune ~= nil then
						mod.Storage.MirrorMisfortune = mod.Storage.MirrorMisfortune + 7
					else
						mod.Storage.MirrorMisfortune = 7
					end
					local pedestalIdx = 61
					if v == 74 then pedestalIdx = 73 end
					local anyTMags = false
					for num = 1, Game():GetNumPlayers() do
						local player = Game():GetPlayer(num)
						if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENA_B then
							anyTMags = true
						end
					end
					local spawnItem = CollectibleType.COLLECTIBLE_SHARD_OF_GLASS
					math.randomseed(Game():GetSeeds():GetStartSeed() + mod.Storage.MirrorMisfortune) -- does this work? I don't know.
					if (not anyTMags and math.random() < 0.2) or (anyTMags and math.random() < 0.8) then
						spawnItem = CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON
					end
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, spawnItem, room:GetGridPosition(pedestalIdx), Vector.Zero, nil)
					local player = Isaac.GetPlayer(0)
					player:AddCacheFlags(CacheFlag.CACHE_LUCK)
					player:EvaluateItems() -- else it won't update
					player:AnimateSad()
					mod.Darkness = 30
					mod.BrokenMirror = true
				end
			end
		end
		
		if mod.Darkness ~= nil and mod.Darkness > 0 then
			Game():Darken(1,1)
			mod.Darkness = mod.Darkness - 1
		end
	end
end

function mod:onCache(player, flag)
	local isItPlayer = Isaac.GetPlayer(0)
	local itIsPlayer = false
	if player:GetName() == isItPlayer:GetName() and player.ControllerIndex == isItPlayer.ControllerIndex then
		itIsPlayer = true
	end
	
	if itIsPlayer and flag == CacheFlag.CACHE_LUCK and mod.Storage ~= nil and mod.Storage.MirrorMisfortune ~= nil then
		player.Luck = player.Luck - mod.Storage.MirrorMisfortune
	end
end

function mod:newFloor()
	if mod.Storage ~= nil and mod.Storage.MirrorMisfortune ~= nil and mod.Storage.MirrorMisfortune > 0 then
		mod.Storage.MirrorMisfortune = mod.Storage.MirrorMisfortune - 1
		local player = Isaac.GetPlayer(0)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:EvaluateItems()
	end
	-- and save, to correspond with the game's autosaving on new floors
	if mod.Storage ~= nil then
        mod:SaveData(json.encode(mod.Storage))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onEnd)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newFloor)

local stopWithHourglass = true

local blindPedestalItemsInRoom = {}
local blindShopItemsInRoom = {}
-- local visibleItemsInRoom = {}
local disappearingPedestalItems = {}
local disappearingPedestalItemsFrame = {}
local disappearingShopItems = {}
local disappearingShopItemsFrame = {}

local questionMarkSprite = Sprite()
questionMarkSprite:Load("gfx/005.100_collectible.anm2",true)
questionMarkSprite:ReplaceSpritesheet(1,"gfx/items/collectibles/questionmark.png")
questionMarkSprite:LoadGraphics()
questionMarkSprite:SetFrame("Idle", 0)

local itemSprite = Sprite()
itemSprite:Load("gfx/005.100_collectible.anm2",true)

function mod:SaveStorage()
    if Game():GetFrameCount() <= 0 then return end
    if stopWithHourglass then
        mod:SaveData("true")
    else
        mod:SaveData("false")
    end
end

function mod:LoadStorage()
    if mod:HasData() then
        savedata = mod:LoadData()
        if savedata == "true" then
            stopWithHourglass = true
        else
            stopWithHourglass = false
        end
    end
end

if ModConfigMenu then

    local function SaveModConfig()
        if stopWithHourglass then
            mod:SaveData("true")
        else
            mod:SaveData("false")
        end
    end

    ModConfigMenu.AddSetting("Regret Pedestals", "Settings", {
        Type = ModConfigMenu.OptionType.BOOLEAN,
		Default = true,
		CurrentSetting = function()
			return stopWithHourglass
		end,
		Display = function()
			if stopWithHourglass then return "Disable with Glowing Hourglass: true"
			else return "Disable with Glowing Hourglass: false" end
		end,
		OnChange = function(newvalue)
			stopWithHourglass = newvalue
			SaveModConfig()
		end,
		Info = {"Disable the apparation when holding Glowing Hourglass"}
    })

end

-- POST_PICKUP_UPDATE runs each update the item is in view
function mod:postPickupUpdate(entity)
    local isQuestionMark = true
    local addToList = true

    -- If item pointer is not saved to memory, add to respective array
    if not contains(blindPedestalItemsInRoom, entity) and not contains(blindShopItemsInRoom, entity) then

        -- Blind item check, credit to EID // not working and crashes game at the moment
        -- for j = -1,1,1 do
        --     for i = -71,0,3 do
        --         local qcolor = questionMarkSprite:GetTexel(Vector(j,i),nullVector,1,1)
        --         local ecolor = entitySprite:GetTexel(Vector(j,i),nullVector,1,1)
        --         if qcolor.Red ~= ecolor.Red or qcolor.Green ~= ecolor.Green or qcolor.Blue ~= ecolor.Blue then
        --             isQuestionMark = false
        --         end
        --     end
        -- end

        for i=0, Game():GetNumPlayers()-1 do
            local player = Isaac.GetPlayer(i)
            if player:GetActiveItem() == CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS and stopWithHourglass then
                addToList = false
            end
        end

        if isQuestionMark and addToList then
            local entitySprite = entity:GetSprite()
	        local name = entitySprite:GetAnimation()

            if name == "Idle" then
                table.insert(blindPedestalItemsInRoom, entity)
            end
            if name == "ShopIdle" then
                table.insert(blindShopItemsInRoom, entity)
            end
        -- else
        --     Isaac.ConsoleOutput("Visible item")
        end
    end
end

-- Called each update, checks if isaac has deleted any pedestals
function mod:postUpdate()
    local pedestalIndicesToRemove = {}
    local shopIndicesToRemove = {}

    -- Check around Isaac for items, remove ones that were previously in the room
    local pedestals = Isaac.FindByType(5, 100, -1, true, false)
    for index, result in ipairs(blindPedestalItemsInRoom) do
        if not contains(pedestals, result) then
            table.insert(disappearingPedestalItems, result)
            table.insert(disappearingPedestalItemsFrame, 0)
            table.insert(pedestalIndicesToRemove, index)
        end
    end

    for index, result in ipairs(blindShopItemsInRoom) do
        if not contains(pedestals, result) then
            table.insert(disappearingShopItems, result)
            table.insert(disappearingShopItemsFrame, 0)
            table.insert(shopIndicesToRemove, index)
        end
    end

    -- Remove removed items from the blind item array
    for index, result in ipairs(pedestalIndicesToRemove) do
        table.remove(blindPedestalItemsInRoom, result)
        for i, r in ipairs(pedestalIndicesToRemove) do
            if r > result then
                pedestalIndicesToRemove[i] = r-1
            end
        end
    end

    for index, result in ipairs(shopIndicesToRemove) do
        table.remove(blindShopItemsInRoom, result)
        for i, r in ipairs(shopIndicesToRemove) do
            if r > result then
                shopIndicesToRemove[i] = r-1
            end
        end
    end

end

-- Empty room data on POST_NEW_ROOM
function mod:postNewRoom()
    blindPedestalItemsInRoom = {}
    blindShopItemsInRoom = {}
    -- visibleItemInRoom = {}
    disappearingPedestalItems = {}
    disappearingPedestalItemsFrame = {}
    disappearingShopItems = {}
    disappearingShopItemsFrame = {}
end

function mod:postRender()
    for index, item in ipairs(disappearingPedestalItems) do
        if item.SubType ~= 0 then
            local itemPos = Isaac.WorldToScreen(item.Position)
            local spriteFile = Isaac.GetItemConfig():GetCollectible(item.SubType).GfxFileName

            itemSprite:ReplaceSpritesheet(1,spriteFile)
            itemSprite:LoadGraphics()
            local color = Color(1,1,1,(1- (disappearingPedestalItemsFrame[index]/60)))
            itemSprite.Color = color
            itemSprite:SetFrame("Idle", 0)

            itemPos.Y = itemPos.Y - disappearingPedestalItemsFrame[index]/10

            itemSprite:Render(itemPos, Vector(0,0), Vector(0,0))

            disappearingPedestalItemsFrame[index] = disappearingPedestalItemsFrame[index] + 1

            if disappearingPedestalItemsFrame[index] == 60 then
                table.remove(disappearingPedestalItems, index)
                table.remove(disappearingPedestalItemsFrame, index)
            end
        end
    end
    for index, item in ipairs(disappearingShopItems) do
        if item.SubType ~= 0 then
            local itemPos = Isaac.WorldToScreen(item.Position)
            local spriteFile = Isaac.GetItemConfig():GetCollectible(item.SubType).GfxFileName

            itemSprite:ReplaceSpritesheet(1,spriteFile)
            itemSprite:LoadGraphics()
            local color = Color(1,1,1,(1- (disappearingShopItemsFrame[index]/60)))
            itemSprite.Color = color
            itemSprite:SetFrame("ShopIdle", 0)

            itemPos.Y = itemPos.Y - disappearingShopItemsFrame[index]/10

            itemSprite:Render(itemPos, Vector(0,0), Vector(0,0))

            disappearingShopItemsFrame[index] = disappearingShopItemsFrame[index] + 1

            if disappearingShopItemsFrame[index] == 60 then
                table.remove(disappearingShopItems, index)
                table.remove(disappearingShopItemsFrame, index)
            end
        end
    end
end

-- Function to check if a table contains a value
function contains(table, value)
    for index, result in ipairs(table) do
        if GetPtrHash(result) == GetPtrHash(value) then
            return true
        end
    end

    return false
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.postPickupUpdate, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.postNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.postUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.postRender)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveStorage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.SaveStorage)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadStorage)

local game = Game()

function mod:postpickup(pickup)
	local room = game:GetLevel():GetCurrentRoom()
	if pickup.Type == 5 and pickup.Variant == 100 and not pickup:IsShopItem() and pickup:GetSprite():GetOverlayFrame() == 0 and pickup:GetData().pedestal_check == nil then
		pickup:GetData().pedestal_check = true
		local sprite = pickup:GetSprite()
		local layout = {10,11,12,13,14,15,16,17,19,20,21,22,23,25,26,27,28,30,34,35,37,39,43,44,48,49,50,52,53,60} -- Backdrops
		local altar = {"womb","womb","scarred","bluewomb","devil","angel","darkroom","treasure","library","shop","library","library","secret","shop","error",
						"bluewomb","shop","sacrifice","corpse","planetarium","secret","corpse","corpse","corpse","corpse","loot","loot","loot","loot","loot"} -- Pedestal Frames
		local altarType = ""
		for i = 1, #layout do
			if room:GetBackdropType() == layout[i] then altarType = altar[i] end -- Pedestal Type
		end
		if room:GetType() == RoomType.ROOM_BOSS and (altarType == "womb" or altarType == "scarred" or altarType == "bluewomb" or altarType == "corpse") then altarType = altarType .. "boss" -- Womb Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_MINIBOSS then altarType = "boss" -- Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_TREASURE and altarType ~= "womb" and altarType ~= "scarred" and altarType ~= "bluewomb" and altarType ~= "corpse" then altarType = "treasure" -- Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_CHALLENGE or room:GetType() == RoomType.ROOM_BOSSRUSH then altarType = "ambush" end -- Ambush Pedestal
		if altarType ~= "" then
			for i = 3, 5 do pickup:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/" .. altarType .. "_pedestal.png") end
			pickup:GetSprite():LoadGraphics()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.postpickup)

local TEAR_STATIC = Isaac.GetEntityVariantByName("Static Tear")
local TEAR_FACING = Isaac.GetEntityVariantByName("Facing Tear")
local TEAR_CUPID = Isaac.GetEntityVariantByName("Cupid Tear (Custom)")
local TEAR_BOOMERANG = Isaac.GetEntityVariantByName("Boomerang Tear")

local TEAR_STATIC_MULTID = Isaac.GetEntityVariantByName("Static Tear (Multidimensional)")
local TEAR_FACING_MULTID = Isaac.GetEntityVariantByName("Facing Tear (Multidimensional)")
local TEAR_CUPID_MULTID = Isaac.GetEntityVariantByName("Cupid Tear (Multidimensional)")
local TEAR_BOOMERANG_MULTID = Isaac.GetEntityVariantByName("Boomerang Tear (Multidimensional)")

local TEAR_POOF_A_LARGE = Isaac.GetEntityVariantByName("Tear PoofA large")
local TEAR_POOF_B_LARGE= Isaac.GetEntityVariantByName("Tear PoofB large")

local TEAR_VARIANT = nil
--local TEAR_SPR_FILENAME = nil
local TEAR_POS = nil
local TEAR_HEIGHT = nil
local TEAR_FLAGS = nil
local TEAR_POINTER = nil
--local TEAR_ROTATION = nil
--local TEAR_SPR_ROTATION = nil
local TEAR_COLOR = nil
--local TEAR_SPR_COLOR = nil
local TEAR_SCALE = nil
--local TEAR_BASE_SCALE = nil
--local TEAR_SIZE_MULTI = nil
--local TEAR_SPR_SCALE = nil
local TEAR_ANM_NAME = nil

local bloodModifierActive

local VARIANT_BLUE = TearVariant.BLUE
local VARIANT_BLOOD = TearVariant.BLOOD
--local VARIANT_TOOTH = TearVariant.TOOTH
local VARIANT_METALLIC = TearVariant.METALLIC
local VARIANT_FIRE = TearVariant.FIRE_MIND
local VARIANT_DARK = TearVariant.DARK_MATTER
local VARIANT_MYSTERIOUS = TearVariant.MYSTERIOUS
--local VARIANT_SCHYTHE = TearVariant.SCHYTHE
local VARIANT_LOST_CONTACT = TearVariant.LOST_CONTACT
local VARIANT_CUPID = TearVariant.CUPID_BLUE
local VARIANT_CUPID_BLOOD = TearVariant.CUPID_BLOOD
local VARIANT_NAIL = TearVariant.NAIL
local VARIANT_NAIL_BLOOD = TearVariant.NAIL_BLOOD
local VARIANT_PUPULA = TearVariant.PUPULA
local VARIANT_PUPULA_BLOOD = TearVariant.PUPULA_BLOOD
local VARIANT_GODS_FLESH = TearVariant.GODS_FLESH
local VARIANT_GODS_FLESH_BLOOD = TearVariant.GODS_FLESH_BLOOD
local VARIANT_DIAMOND = TearVariant.DIAMOND
local VARIANT_EXPLOSIVO = TearVariant.EXPLOSIVO
local VARIANT_COIN = TearVariant.COIN
local VARIANT_MULTIDIMENSIONAL = TearVariant.MULTIDIMENSIONAL
--STONE
local VARIANT_GLAUCOMA = TearVariant.GLAUCOMA
local VARIANT_GLAUCOMA_BLOOD = TearVariant.GLAUCOMA_BLOOD
--BOOGER
--EGG
--RAZOR
--BONE
--BLACK_TOOTH
--NEEDLE
--local VARIANT_BELIAL = TearVariant.BELIAL
local VARIANT_EYE = TearVariant.EYE
local VARIANT_EYE_BLOOD = TearVariant.EYE_BLOOD
--BALLOON
--HUNGRY
--BALLOON_BRIMSTONE
--BALLOON_BOMB

local FLAG_BOOMERANG
local FLAG_BURN
local FLAG_FEAR
local FLAG_MLIQ
local FLAG_GODS_F
local FLAG_EXPLOSIVO
local FLAG_PIERCING
local FLAG_SPECTRAL

if REPENTANCE then	
	FLAG_BOOMERANG = 1<<8
	FLAG_BURN = 1<<22
	FLAG_FEAR = 1<<20
	FLAG_MLIQ = 1<<33
	FLAG_GODS_F = 1<<43
	FLAG_EXPLOSIVO = 1<<37
	FLAG_PIERCING = 1<<1
	FLAG_SPECTRAL = 1<<0
else
	FLAG_BOOMERANG = TearFlags.TEAR_BOMBERANG
	FLAG_BURN = TearFlags.TEAR_BURN
	FLAG_FEAR = TearFlags.TEAR_FEAR
	FLAG_MLIQ = TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP
	FLAG_GODS_F = TearFlags.TEAR_GODS_FLESH 
	FLAG_EXPLOSIVO = TearFlags.TEAR_STICKY
	FLAG_PIERCING = TearFlags.TEAR_PIERCING
	FLAG_SPECTRAL = TearFlags.TEAR_SPECTRAL
end

local overridenBy = {}
--Regular
overridenBy[1] = {VARIANT_BLUE, VARIANT_BLOOD, VARIANT_METALLIC, VARIANT_FIRE, VARIANT_DARK, VARIANT_MYSTERIOUS, VARIANT_LOST_CONTACT, VARIANT_GODS_FLESH, VARIANT_GODS_FLESH_BLOOD, VARIANT_EXPLOSIVO,
                  VARIANT_MULTIDIMENSIONAL}
--Cupid
overridenBy[2] = {VARIANT_BLUE, VARIANT_BLOOD, VARIANT_METALLIC, VARIANT_FIRE, VARIANT_DARK, VARIANT_MYSTERIOUS, VARIANT_LOST_CONTACT, VARIANT_CUPID, VARIANT_CUPID_BLOOD, VARIANT_GODS_FLESH,
                  VARIANT_GODS_FLESH_BLOOD, VARIANT_DIAMOND, VARIANT_EXPLOSIVO, VARIANT_MULTIDIMENSIONAL}
                  --VARIANT_GODS_FLESH_BLOOD, VARIANT_DIAMOND, VARIANT_EXPLOSIVO, VARIANT_MULTIDIMENSIONAL, VARIANT_GLAUCOMA, VARIANT_GLAUCOMA_BLOOD}
--Boomerang
overridenBy[3] = {VARIANT_BLUE, VARIANT_BLOOD, VARIANT_METALLIC, VARIANT_FIRE, VARIANT_DARK, VARIANT_MYSTERIOUS, VARIANT_LOST_CONTACT, VARIANT_CUPID, VARIANT_CUPID_BLOOD, VARIANT_PUPULA,
                  VARIANT_PUPULA_BLOOD, VARIANT_GODS_FLESH, VARIANT_GODS_FLESH_BLOOD, VARIANT_EXPLOSIVO, VARIANT_MULTIDIMENSIONAL} --, VARIANT_GLAUCOMA, VARIANT_GLAUCOMA_BLOOD}

local variantSelectionTable = {}

local customs_non_multiD = {TEAR_STATIC, TEAR_FACING, TEAR_CUPID, TEAR_BOOMERANG}
local customs_MultiD = {TEAR_STATIC_MULTID, TEAR_FACING_MULTID, TEAR_CUPID_MULTID, TEAR_BOOMERANG_MULTID}
local customsVariantRange = {TEAR_STATIC, TEAR_BOOMERANG_MULTID}      -- {593270, 593373}

local deadTears = {}
local tearColors = {}
local boomerangColor = {}
local tearTints = {}
local builtTears = {}
local wasBloodVariant = {}
local previousVariant = {}
local diamondVariant = {}
local tearAnimation = {}    --string name, bool using SetFrame/Play (true -> SetFrame(); false -> Play())
local tearsFrameDelay = {}
      tearsFrameDelay[1] = {}   --frame, alpha, flag (i: seed)
      tearsFrameDelay[2] = {}   --seed (i: table) (delete)

local clock = 0

local test = "a"
local test2 = "b"

local function hasFlag(tear, flag)
  local res
  if REPENTANCE then
    res = tear:HasTearFlags(flag)
  else
    res = (tear.TearFlags & flag) ~= 0
  end
  return res
end

-- Blood modifiers
local bloodM = {}
bloodM[1] = {CollectibleType.COLLECTIBLE_BLOOD_MARTYR, CollectibleType.COLLECTIBLE_PACT, CollectibleType.COLLECTIBLE_SMALL_ROCK, CollectibleType.COLLECTIBLE_STIGMATA,
             CollectibleType.COLLECTIBLE_TOOTH_PICKS, CollectibleType.COLLECTIBLE_SMB_SUPER_FAN, CollectibleType.COLLECTIBLE_MONSTROS_LUNG, CollectibleType.COLLECTIBLE_ABADDON, 
             CollectibleType.COLLECTIBLE_MAW_OF_VOID, CollectibleType.COLLECTIBLE_KIDNEY_STONE, CollectibleType.COLLECTIBLE_APPLE, CollectibleType.COLLECTIBLE_EYE_OF_BELIAL, 
             CollectibleType.COLLECTIBLE_HAEMOLACRIA, COLLECTIBLE_LACHRYPHAGY}
bloodM[2] = {CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, CollectibleType.COLLECTIBLE_RAZOR_BLADE}


local customs_anm = {}
customs_anm[TEAR_STATIC] = {0.001, 0.30, 0.55, 0.675, 0.80, 0.925, 1.05, 1.175, 1.425, 1.675, 1.925, 2.175, 2.55, 2.78, 3.022, 3.264, 3.710, 4.169, 4.871}
--customs_anm[TEAR_STATIC] = {}
--customs_anm[TEAR_STATIC][1] = {4.871, 4.169, 3.710, 3.264, 3.022, 2.78, 2.55, 2.175, 1.925, 1.675, 1.425, 1.175, 1.05, 0.925, 0.80, 0.675, 0.55, 0.30}
--customs_anm[TEAR_STATIC][2] = {19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2}

customs_anm[TEAR_FACING] = customs_anm[TEAR_STATIC]

customs_anm[TEAR_CUPID] = {0.001, 0.30, 0.55, 0.675, 0.80, 0.925, 1.05, 1.175, 1.425, 1.675, 1.925, 2.175, 2.55, 2.727, 2.914, 3.091, 3.465, 3.817, 4.740}
--customs_anm[TEAR_CUPID] = {}
--customs_anm[TEAR_CUPID][1] = {4.740, 3.817, 3.465, 3.091, 2.914, 2.727, 2.55, 2.175, 1.925, 1.675, 1.425, 1.175, 1.05, 0.925, 0.80, 0.675, 0.55, 0.30}
--customs_anm[TEAR_CUPID][2] = {19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2}

customs_anm[TEAR_BOOMERANG] = customs_anm[TEAR_STATIC]
customs_anm[TEAR_STATIC_MULTID] = customs_anm[TEAR_STATIC]
customs_anm[TEAR_FACING_MULTID] = customs_anm[TEAR_FACING]
customs_anm[TEAR_CUPID_MULTID] = customs_anm[TEAR_CUPID]
customs_anm[TEAR_BOOMERANG_MULTID] = customs_anm[TEAR_BOOMERANG]

local boomerangSizes = {"a", "a", "a", "a", "a", "a", "a", "b", "b", "b", "b", "c", "c", "c", "d", "d", "d", "e", "e"}

-- <[FUNCTIONS]>

function get_anm(sprite, str, n)
  if n == nil then
    n = 19
  end
  
  for i = 1, n do
    if sprite:IsPlaying(str .. tostring(i)) then
      return str .. tostring(i)
    end
  end
  return sprite:GetDefaultAnimationName()
end

function link_anm(scale, variant)
  local scales = customs_anm[variant]      -- #scales >= 2
  local anmNumber
  
  if scale > scales[#scales] then
    anmNumber = #scales
  else
    local i = 1
    local j = #scales
    local m = i
    while i+1 < j and not (scale > scales[i] and scale <= scales[i+1]) do
      m = math.floor((i+j)/2)
      if scale > scales[m] then
        i = m
      else
        j = m
      end
    end
    anmNumber = m
  end
  return anmNumber
end

function PlayCustom(sprite, anmName, frame, pointer)
  if tearAnimation[pointer][2] then
    if frame == 0 then          
      sprite:Play(anmName, true)
      tearAnimation[pointer][2] = false
    else
      sprite:SetFrame(anmName, frame)
    end
  end
end

function isVariant(variant, variants)
  for i = 1, #variants do
    if variant == variants[i] then
      return true
    end
  end
  return false  
end

function buildVariantSelectionTable(vars)
  for i=1, #vars do
    variantSelectionTable[i] = {}
    for j=1, #vars[i] do
      variantSelectionTable[i][vars[i][j]] = vars[i][j]
    end
  end
end
buildVariantSelectionTable(overridenBy)

function checkBloodModifiers(player, color)
  local res = false
  local i = 1
  res = player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) and areSameColor(color, Color(1, 0, 0, 1, 0, 0, 0))
  while res == false and i <= #bloodM[1] do
    res = player:HasCollectible(bloodM[1][i])
    i = i+1
  end
  i = 1
  local effects = player:GetEffects()
  while res == false and i <= #bloodM[2] do
    res = effects:HasCollectibleEffect(bloodM[2][i])
    i = i+1
  end
  return res
end

function newCustomVariant(TEAR_VARIANT, tear, TEAR_COLOR, player, seed)  
  local var
  local updatePreviousVar = true
  
  if TEAR_VARIANT == VARIANT_MULTIDIMENSIONAL then
    if isVariant(previousVariant[seed], customs_non_multiD) then
      var = previousVariant[seed] + 100
      updatePreviousVar = false
    elseif player:HasCollectible(48) or player:HasCollectible(306) or isVariant(TEAR_VARIANT, {VARIANT_CUPID, VARIANT_CUPID_BLOOD}) or 
           (player:HasTrinket(TrinketType.TRINKET_PUSH_PIN) and not player:HasCollectible(336) and hasFlag(tear, FLAG_PIERCING) and hasFlag(tear, FLAG_SPECTRAL)) then
      var = TEAR_CUPID_MULTID
    else
      var = TEAR_STATIC_MULTID
    end
  
  elseif hasFlag(tear, FLAG_BOOMERANG) and variantSelectionTable[3][TEAR_VARIANT] then
    var = TEAR_BOOMERANG
    
  else
    --local colorLess = areSameColor(TEAR_COLOR, Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0))
    --local colorLess = not (areSameColor(TEAR_COLOR, Color(0.39215689897537, 0.39215689897537, 0.39215689897537, 1.0, 0, 0, 0)) or areSameColor(TEAR_COLOR, Color(1, 0, 0, 1, 0, 0, 0)) or
    --                       areSameColor(TEAR_COLOR, Color(0.20000000298023, 0.090000003576279, 0.064999997615814, 1, 0, 0, 0)))     -- Abaddon, Blood Clot, Explosivo
    
    local has_Abaddon = player:HasCollectible(230) and hasFlag(tear, FLAG_FEAR)
    local has_BlodClot = player:HasCollectible(254) and areSameColor(TEAR_COLOR, Color(1, 0, 0, 1, 0, 0, 0))
    local has_EveMascara = player:HasCollectible(310) and areSameColor(TEAR_COLOR, Color(0.2, 0.2, 0.2, 1, 0, 0, 0))
    local has_Explosivo = player:HasCollectible(401) and hasFlag(tear, FLAG_EXPLOSIVO)
    local specialCases = has_Abaddon or has_BlodClot or has_EveMascara or has_Explosivo
    
    local has_cupid = (hasFlag(tear, FLAG_PIERCING) and (player:HasCollectible(48) or player:HasCollectible(306) or isVariant(TEAR_VARIANT, {VARIANT_CUPID, VARIANT_CUPID_BLOOD}))) or 
                      (player:HasTrinket(TrinketType.TRINKET_PUSH_PIN) and not player:HasCollectible(336) and hasFlag(tear, FLAG_PIERCING) and hasFlag(tear, FLAG_SPECTRAL))
    --if has_cupid and variantSelectionTable[2][TEAR_VARIANT] and not (colorLess and isVariant(TEAR_VARIANT, {VARIANT_CUPID_BLOOD, VARIANT_CUPID})) then
    if has_cupid and variantSelectionTable[2][TEAR_VARIANT] and not (not specialCases and isVariant(TEAR_VARIANT, {VARIANT_CUPID_BLOOD, VARIANT_CUPID})) then
      var = TEAR_CUPID
      
    --elseif variantSelectionTable[1][TEAR_VARIANT] and not (colorLess and isVariant(TEAR_VARIANT, {VARIANT_BLOOD, VARIANT_BLUE})) then
    elseif variantSelectionTable[1][TEAR_VARIANT] and not (not specialCases and isVariant(TEAR_VARIANT, {VARIANT_BLOOD, VARIANT_BLUE})) then
      local has_Dark_M = player:HasCollectible(259)
      if hasFlag(tear, FLAG_BURN) or hasFlag(tear, FLAG_MLIQ) or has_Dark_M or has_Abaddon then
        var = TEAR_FACING
      else
        var = TEAR_STATIC
      end
    end
    
  end
  
  if updatePreviousVar and var ~= nil then
  --if updatePreviousVar then
    previousVariant[seed] = var
  --else
  --  previousVariant[seed] = TEAR_VARIANT
  end
  return var
end

function getBloodVariant(var)
  local basic = {VARIANT_BLUE, VARIANT_CUPID, VARIANT_NAIL, VARIANT_PUPULA, VARIANT_GODS_FLESH, VARIANT_GLAUCOMA, VARIANT_EYE}
  local blood = {VARIANT_BLOOD, VARIANT_CUPID_BLOOD, VARIANT_NAIL_BLOOD, VARIANT_PUPULA_BLOOD, VARIANT_GODS_FLESH_BLOOD, VARIANT_GLAUCOMA_BLOOD, VARIANT_EYE_BLOOD}
  for i = 1, #basic do
    if var == basic[i] then
      return blood[i]    
    end
  end
end

function areSameColor (c1, c2)
  if c1.R == c2.R and c1.G == c2.G and c1.B == c2.B and c1.A == c2.A and c1.RO == c2.RO and c1.GO == c2.GO and c1.BO == c2.BO then
    return true
  else
    return false
  end
end

function colorToTable(c)
  return {c.R, c.G, c.B, c.A, math.floor(c.RO*255), math.floor(c.GO*255), math.floor(c.BO*255)}
end

function tableToColor(t)
  return Color(t[1], t[2], t[3], t[4], t[5], t[6], t[7])
end

function mixTearColors(c1, c2)
  return Color(c1.R * c2.R ,c1.G * c2.G,c1.B * c2.B, c1.A * c2.A, math.floor((c1.RO + c2.RO) * 255), math.floor((c1.GO + c2.GO) * 255), math.floor((c1.BO + c2.BO) * 255))
end

function getTearColor(pointer, tear, tColor, player)
  local colorT
  if hasFlag(tear, FLAG_EXPLOSIVO) then
    colorT = {"19", Color(0.319, 0.285, 0.234, 1.0, 0, 0, 0)}
    
  elseif player:HasCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
    colorT = {"3", Color(0.632, 0.565, 0.452, 1.0, 0, 0, 0)}
    
  --elseif areSameColor(tColor, Color(0.39215689897537, 0.39215689897537, 0.39215689897537, 1, 0, 0, 0)) and hasFlag(tear, FLAG_FEAR) then     -- Abaddon tear
  elseif player:HasCollectible(230) and hasFlag(tear, FLAG_FEAR) then     -- Abaddon tear
    colorT = {"6", Color(0.173, 0.155, 0.127, 1.0, 0, 0, 0)}
    
  elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_MATTER) then
    colorT = {"6", Color(0.173, 0.155, 0.127, 1.0, 0, 0, 0)} 
    
  elseif player:HasCollectible(310) and areSameColor(tColor, Color(0.2, 0.2, 0.2, 1, 0, 0, 0)) then     -- Eve's Mascara
    colorT = {"6", Color(0.173, 0.155, 0.127, 1.0, 0, 0, 0)}
    
  elseif hasFlag(tear, FLAG_BURN) then
    colorT = {"5", Color(1.5, 0.7, 0.2, 1.0, 0, 0, 0)}
    
  elseif hasFlag(tear, FLAG_MLIQ) then
    colorT = {"7", Color(0.476, 1.184, 0.298, 1.0, 0, 0, 0)}
    
  elseif wasBloodVariant[pointer] then
    colorT = {"1", Color(0.854, 0.053, 0.060, 1.0, 0, 0, 0)}
    
  else
    if bloodModifierActive == nil then
      bloodModifierActive = checkBloodModifiers(player, tColor)
    end
    if bloodModifierActive then
      colorT = {"1", Color(0.854, 0.053, 0.060, 1.0, 0, 0, 0)}
      
    else
      colorT = {"0", Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)}
    end
  end
  
  return colorT
end

function getPoofVariant(scale, height)
  if scale > 1.8625 then
    if height < -5 then
      return TEAR_POOF_A_LARGE    -- Wall impact
    else
      return TEAR_POOF_B_LARGE    -- Floor impact
    end
  elseif scale > 0.8 then
    if height < -5 then
      return EffectVariant.TEAR_POOF_A    -- Wall impact
    else
      return EffectVariant.TEAR_POOF_B    -- Floor impact
    end
  elseif scale > 0.4 then
    return EffectVariant.TEAR_POOF_SMALL
  else
    return EffectVariant.TEAR_POOF_VERYSMALL
  end
end

function getPoofScaleCons(scale)
  if scale > 1.8625 then
    return 0.4
  elseif scale > 0.8 then
    return 0.8
  end
  --less than 0.8 doesnt scale (cons = 1)
end

function getTearHeightAndSnd(height)
  if height < -5 then
    return {Vector(0, height * 0.5 - 14), SoundEffect.SOUND_TEARIMPACTS} --Wall impact - "tear block.wav"
  else 
    return {Vector(0,0), SoundEffect.SOUND_SPLATTER}  --Floor impact - "splatter 0-2.wav"
  end
end

-- splash: Color(1.103, 0.986, 0.810, 1.0, 0, 0, 0) (white);  Color(0.097, 0.087, 0.071, 1.0, 0, 0, 0) (black)
-- mLiq p: Color(0, 0, 0, 1.0, 190, 190, 190) (white);        Color(0, 0, 0, 1.0, 14, 14, 14) (black)
function multiD_Fade(frm, c1, c2, alpha)
  if frm <= 12 then
    return Color(c1[1] - c2[1]*frm, c1[2] - c2[2]*frm, c1[3] - c2[3]*frm, alpha, c1[5] - c2[5]*frm, c1[6] - c2[6]*frm, c1[7] - c2[7]*frm)
    --return Color(c1.R - c2.R*frm, c1.G - c2.G*frm, c1.R - c2.G*frm, c1.A, math.floor((c1.RO - c2.RO*frm)*255), math.floor((c1.GO - c2.GO*frm)*255), math.floor((c1.BO - c2.BO*frm)*255))
  else
    return multiD_Fade(24-frm, c1, c2, alpha)
  end
end

function getTearPlayerSpawner(parent)
  if parent ~= nil then
    if parent.Type == EntityType.ENTITY_PLAYER then
      return parent:ToPlayer()
    elseif parent.Type == EntityType.ENTITY_FAMILIAR then
      return parent:ToFamiliar().Player
    elseif parent.Type == EntityType.ENTITY_TEAR then
      return getTearPlayerSpawner(parent.Parent)
    end
  else
    return Isaac.GetPlayer(0)
  end
end

-- | ====== |
-- |  MAIN  |
-- | ====== |

function mod:main(tear)
  
  if tear.SpawnerType == 1 or (tear.SpawnerType == 0 and tear.Parent ~= nil) or tear.SpawnerType == 3 then
    
    --if tear.FrameCount == 1 then
    --  tear.Scale = 5
    --end
    --
    --tear.Scale = tear.Scale * 0.999
    
    --tear.Scale = -1
    
    local tearSpr = tear:GetSprite()
    TEAR_VARIANT = tear.Variant
    --TEAR_SPR_FILENAME = tearSpr:GetFilename()
    --TEAR_POS = tear.Position
    --TEAR_HEIGHT = tear.Height
    TEAR_FLAGS = tear.TearFlags
    TEAR_POINTER = GetPtrHash(tear)
    --TEAR_ROTATION = tear.Rotation
    --TEAR_SPR_ROTATION = tearSpr.Rotation
    TEAR_COLOR = tear:GetColor()
    --TEAR_SPR_COLOR = tearSpr.KColor
    TEAR_SCALE = tear:ToTear().Scale
    --TEAR_BASE_SCALE = tear.BaseScale
    --TEAR_SIZE_MULTI = tear.SizeMulti
    --TEAR_SPR_SCALE = tearSpr.Scale.X .. " " .. tearSpr.Scale.Y
    --TEAR_ANM_NAME = get_anm(tearSpr, "RegularTear", 19)
    if TEAR_VARIANT >= customsVariantRange[1] and TEAR_VARIANT <= customsVariantRange[2] then
      if tearAnimation[TEAR_POINTER] == nil then
        TEAR_ANM_NAME = "RegularTear" .. tostring(link_anm(TEAR_SCALE, TEAR_VARIANT))
        tearAnimation[TEAR_POINTER] = {TEAR_ANM_NAME, true}
      else
        TEAR_ANM_NAME = tearAnimation[TEAR_POINTER][1]
      end
    else
      TEAR_ANM_NAME = get_anm(tearSpr, "RegularTear", 19)
      tearAnimation[TEAR_POINTER] = {TEAR_ANM_NAME, true}
    end
    
    local player = getTearPlayerSpawner(tear.Parent)
    
    --test = tear.StickTarget
    
    -- <[VARIANT SELECTION]>
    
    local newVar
    if TEAR_VARIANT < 39 then
      newVar = newCustomVariant(TEAR_VARIANT, tear, TEAR_COLOR, player, tear.InitSeed)
    end
    if newVar ~= nil then
      tear:ChangeVariant(newVar)
      
     if isVariant(TEAR_VARIANT, {VARIANT_BLOOD, VARIANT_CUPID_BLOOD, VARIANT_PUPULA_BLOOD, VARIANT_GODS_FLESH_BLOOD}) then
       wasBloodVariant[TEAR_POINTER] = true
     end
      builtTears[TEAR_POINTER] = nil      --Ludovico reset
      boomerangColor[TEAR_POINTER] = nil  --My Reflection + MultiD
      
      TEAR_VARIANT = tear.Variant
      if isVariant(TEAR_VARIANT, {TEAR_STATIC, TEAR_BOOMERANG, TEAR_STATIC_MULTID, TEAR_BOOMERANG_MULTID})  then
        tearSpr.Rotation = 0.001
      end
      
      local seed = tear.InitSeed
      if tearsFrameDelay[1][seed] == nil then
        tearsFrameDelay[1][seed] = {nil, TEAR_COLOR.A, nil}
      end
      if isVariant(TEAR_VARIANT, customs_MultiD) then
        if tearsFrameDelay[1][seed][1] == nil then
          tearsFrameDelay[1][seed][1] = tear.FrameCount
          tearsFrameDelay[1][seed][3] = false
          table.insert(tearsFrameDelay[2], seed)
        end
        local alpha = tearsFrameDelay[1][seed][2]
        tear:SetColor(Color(1, 1, 1, alpha, 0, 0, 0), 0, 0, false, false)
        TEAR_COLOR = tear:GetColor()
      end
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SMB_SUPER_FAN) and
    isVariant(TEAR_VARIANT, {VARIANT_BLUE, VARIANT_CUPID, VARIANT_NAIL, VARIANT_PUPULA, VARIANT_GODS_FLESH, VARIANT_GLAUCOMA, VARIANT_EYE}) then
      tear:ChangeVariant(getBloodVariant(TEAR_VARIANT))
    end
    
    -- <[TEAR GFX]>
    
    if TEAR_VARIANT >= customsVariantRange[1] and TEAR_VARIANT <= customsVariantRange[2] and builtTears[TEAR_POINTER] ~= 1 and not tear:IsDead() then
      builtTears[TEAR_POINTER] = 1
      
      local bodyName = "regular/"
      local sizeChar = ""
      local effectPath = ""
      
      if isVariant(TEAR_VARIANT, {TEAR_CUPID, TEAR_CUPID_MULTID}) then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then
          bodyName = "cupid/diamond_"
          effectPath = "gfx/tears/cupid/effects.png"
          diamondVariant[TEAR_POINTER] = true
        else
          bodyName = "cupid/"
          effectPath = "gfx/tears/cupid/effects.png"
        end
      elseif isVariant(TEAR_VARIANT, {TEAR_BOOMERANG, TEAR_BOOMERANG_MULTID}) then
        sizeChar = boomerangSizes[link_anm(TEAR_SCALE, TEAR_VARIANT)]
        bodyName = "boomerang/"
        effectPath = "gfx/tears/boomerang/effects.png"
      else
        effectPath = "gfx/tears/regular/effects.png"
      end
      
      local has_Lost_C = player:HasCollectible(213)
      local has_Dark_M = player:HasCollectible(259)
      --local has_Abaddon = areSameColor(TEAR_COLOR, Color(0.39215689897537, 0.39215689897537, 0.39215689897537, 1.0, 0, 0, 0)) and hasFlag(tear, FLAG_FEAR)
      local has_Abaddon = player:HasCollectible(230) and hasFlag(tear, FLAG_FEAR)
      
      
      local color
      if isVariant(TEAR_VARIANT, customs_non_multiD) then
        color = getTearColor(TEAR_POINTER, tear, TEAR_COLOR, player)
        tearSpr:ReplaceSpritesheet(0,"gfx/tears/" .. bodyName .. color[1] .. sizeChar .. ".png")
        tearColors[TEAR_POINTER] = color[2]
        if TEAR_VARIANT == TEAR_BOOMERANG then
          boomerangColor[TEAR_POINTER] = color[1]
        end
      elseif TEAR_VARIANT == TEAR_BOOMERANG_MULTID then
        tearSpr:ReplaceSpritesheet(0,"gfx/tears/boomerang/21" .. sizeChar .. ".png")
        tearSpr:ReplaceSpritesheet(3,"gfx/tears/boomerang/21" .. sizeChar .. ".png")
      else
        tearSpr:ReplaceSpritesheet(0,"gfx/tears/" .. bodyName .. "21.png")
        tearSpr:ReplaceSpritesheet(3,"gfx/tears/" .. bodyName .. "21.png")   
      end
      
      if hasFlag(tear, FLAG_BURN) or has_Dark_M or has_Abaddon then
        if has_Dark_M or has_Abaddon then
          tearSpr:ReplaceSpritesheet(7, effectPath)
        else
          tearSpr:ReplaceSpritesheet(6, effectPath)
        end
      end
      
      if has_Lost_C then
        tearSpr:ReplaceSpritesheet(5, effectPath)
      end
      
      if hasFlag(tear, FLAG_GODS_F) and not isVariant(TEAR_VARIANT, customs_MultiD) then
        tearSpr:ReplaceSpritesheet(1,"none.png")
        tearSpr:ReplaceSpritesheet(2, effectPath)
      end
      
      if hasFlag(tear, FLAG_MLIQ) then
        tearSpr:ReplaceSpritesheet(8, effectPath)
        if not (hasFlag(tear, FLAG_BURN) or has_Dark_M or has_Abaddon) then
          tearSpr:ReplaceSpritesheet(4, effectPath)
        end
      end
      
      tearSpr:LoadGraphics()
      
      if has_Abaddon and areSameColor(TEAR_COLOR, Color(0.39215689897537, 0.39215689897537, 0.39215689897537, 1.0, 0, 0, 0)) then
        tear:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), 0, 0, false, false)
      elseif areSameColor(TEAR_COLOR, Color(0.20000000298023, 0.090000003576279, 0.064999997615814, 1, 0, 0, 0)) and hasFlag(tear, FLAG_EXPLOSIVO) then
        tear:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), 0, 0, false, false)
      elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) and areSameColor(TEAR_COLOR, Color(1, 0, 0, 1, 0, 0, 0)) and color[1] == "1" then
        tear:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), 0, 0, false, false)
      elseif player:HasCollectible(310) and areSameColor(TEAR_COLOR, Color(0.2, 0.2, 0.2, 1, 0, 0, 0)) then
        tear:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), 0, 0, false, false)
      end
      
    end
    
    -- <[TEAR SCALING]>
    
    if TEAR_VARIANT >= customsVariantRange[1] and TEAR_VARIANT <= customsVariantRange[2] then
      local currentAnm = link_anm(TEAR_SCALE, TEAR_VARIANT)
      local currentAnmName = "RegularTear" .. tostring(currentAnm)
      if currentAnmName ~= TEAR_ANM_NAME then        
        if isVariant(TEAR_VARIANT, {TEAR_BOOMERANG, TEAR_BOOMERANG_MULTID}) then
          local n = tonumber(string.sub(TEAR_ANM_NAME, 12))
          if boomerangSizes[currentAnm] ~= boomerangSizes[n] then
            local color = boomerangColor[TEAR_POINTER]
            if color == nil then
              color = "21"
            end
            if TEAR_VARIANT == TEAR_BOOMERANG_MULTID then
              tearSpr:ReplaceSpritesheet(3,"gfx/tears/boomerang/" .. color .. boomerangSizes[currentAnm] .. ".png")
            end
            tearSpr:ReplaceSpritesheet(0,"gfx/tears/boomerang/" .. color .. boomerangSizes[currentAnm] .. ".png")
            tearSpr:LoadGraphics()
          end
        end
        TEAR_ANM_NAME = currentAnmName
        tearAnimation[TEAR_POINTER] = {TEAR_ANM_NAME, true}
      end
      
      if TEAR_SCALE >= customs_anm[TEAR_VARIANT][19] or
      (TEAR_SCALE >= customs_anm[TEAR_VARIANT][12] and (hasFlag(tear, FLAG_EXPLOSIVO) or player:HasCollectible(261) or player:HasCollectible(132) or player:GetEffects():HasTrinketEffect(9))) then
        local scaleCons = customs_anm[TEAR_VARIANT][link_anm(TEAR_SCALE, TEAR_VARIANT)]
        --if TEAR_SCALE > scaleCons then
          local sizeM = scaleCons / TEAR_SCALE * 1.1660
          local sprScale = TEAR_SCALE / scaleCons * 0.85675
          tear.SizeMulti = Vector(sizeM, sizeM)
          tearSpr.Scale = Vector(sprScale, sprScale)
        --else
        --  tear.SizeMulti = Vector(1, 1)
        --  tearSpr.Scale = Vector(1, 1)
        --end
      else
        tear.SizeMulti = Vector(1, 1)
        tearSpr.Scale = Vector(1, 1)
      end
      
      
    -- <[TEAR POOF]>
    
      if tear:IsDead() then
        table.insert(deadTears, {tear, 1, TEAR_COLOR})
      --else
        --tearTints[TEAR_POINTER] = tableToColor(colorToTable(TEAR_COLOR))
      end
      
      if tearTints[TEAR_POINTER] == nil then
        tearTints[TEAR_POINTER] = tableToColor(colorToTable(TEAR_COLOR))      --Esto es una putisima mierda y me voy a pegar un tiro en la pija
      end
      
    end
    
    -- <[TEAR ANIMATION]>
    
    local frame = tear.FrameCount
    
    if TEAR_VARIANT == TEAR_STATIC then
      -- <[STATIC]>  
      --tearSpr:SetFrame(TEAR_ANM_NAME, 0)
      PlayCustom(tearSpr, TEAR_ANM_NAME, frame % 1, TEAR_POINTER)
      
    elseif isVariant(TEAR_VARIANT, {TEAR_FACING, TEAR_CUPID}) then
      -- <[FACING/CUPID]>
      PlayCustom(tearSpr, TEAR_ANM_NAME, frame % 16, TEAR_POINTER)
      --tearSpr.Rotation = tear.Velocity:GetAngleDegrees()
      if tear.StickTarget == nil then
        tearSpr.Rotation = (tear.Velocity + Vector(0, tear.FallingSpeed)):GetAngleDegrees()
      end
      
    elseif TEAR_VARIANT == TEAR_BOOMERANG then
      -- <[BOOMERNAG]>
      PlayCustom(tearSpr, TEAR_ANM_NAME, frame % 12, TEAR_POINTER)
      
      if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
        tearSpr.Rotation = 0.001
      end
      
      if hasFlag(tear, FLAG_MLIQ) and frame % 2 == 0 and math.random(1, 3) == 1 then
        TEAR_POS = tear.Position
        TEAR_HEIGHT = tear.Height
        local base = Vector.FromAngle((frame+5)%12*30)        
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, 111, 0, base:Resized(TEAR_SCALE*7):__add(TEAR_POS), base:Resized(TEAR_SCALE*0.3), nil):ToEffect()
        trail.PositionOffset = getTearHeightAndSnd(TEAR_HEIGHT)[1]
        
        local sprite = trail:GetSprite()
        local scale = 0.175 + TEAR_SCALE * 0.15
        sprite.Scale = Vector(scale, scale)
        sprite:ReplaceSpritesheet(0, "gfx/effects/tear_mysterious_trail.png")
        sprite:LoadGraphics()
        --trail:SetColor(TEAR_COLOR, 0, 0, false, false)
      end
      
    elseif isVariant(TEAR_VARIANT, customs_MultiD) then
      -- <[MULTI_Ds]>
      local seed = tear.InitSeed
      frame = tearsFrameDelay[1][seed][1]
      tearsFrameDelay[1][seed][3] = false
      PlayCustom(tearSpr, TEAR_ANM_NAME, frame % 24, TEAR_POINTER)
      if isVariant(TEAR_VARIANT, {TEAR_FACING_MULTID, TEAR_CUPID_MULTID}) then
        if tear.StickTarget == nil then
          tearSpr.Rotation = (tear.Velocity + Vector(0, tear.FallingSpeed)):GetAngleDegrees()
        end
        
      elseif TEAR_VARIANT == TEAR_BOOMERANG_MULTID then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
          tearSpr.Rotation = 0.001
        end
        if hasFlag(tear, FLAG_MLIQ) and frame % 2 == 0 and math.random(1, 3) == 1 then
          TEAR_POS = tear.Position
          TEAR_HEIGHT = tear.Height
          local base = Vector.FromAngle((frame+5)%12*30)
          local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, 111, 0, base:Resized(TEAR_SCALE*7):__add(TEAR_POS), base:Resized(TEAR_SCALE*0.3), nil):ToEffect()
          trail.PositionOffset = getTearHeightAndSnd(TEAR_HEIGHT)[1]
          
          local sprite = trail:GetSprite()
          local scale = 0.175 + TEAR_SCALE * 0.15
          sprite.Scale = Vector(scale, scale)
          sprite:ReplaceSpritesheet(0, "gfx/effects/tear_mysterious_trail.png")
          sprite:LoadGraphics()
          trail:SetColor(multiD_Fade((tear.FrameCount % 24), {0, 0, 0, 1.0, 190, 190, 190}, {0, 0, 0, 1.0, 14, 14, 14}, TEAR_COLOR.A), 0, 0, false, false)
        end
      end      
    end
  end
  
  -- <[VANILLA REGULAR/CUPID]>  
  TEAR_VARIANT = tear.Variant
  TEAR_SCALE = tear:ToTear().Scale
  local tearSpr = tear:GetSprite()
  if isVariant(TEAR_VARIANT, {VARIANT_BLUE, VARIANT_METALLIC, VARIANT_LOST_CONTACT, VARIANT_GODS_FLESH, VARIANT_EXPLOSIVO, VARIANT_MULTIDIMENSIONAL}) and TEAR_SCALE > 2.78 then
    if TEAR_VARIANT == VARIANT_MULTIDIMENSIONAL then
      tearSpr:SetFrame("RegularTear" .. tostring(link_anm(TEAR_SCALE, TEAR_STATIC)), tear.FrameCount % 24)
    else
      tearSpr:Play("RegularTear" .. tostring(link_anm(TEAR_SCALE, TEAR_STATIC)),false)
    end
  elseif isVariant(TEAR_VARIANT, {VARIANT_BLOOD, VARIANT_GODS_FLESH_BLOOD}) and TEAR_SCALE > 2.78 then
    tearSpr:Play("BloodTear" .. tostring(link_anm(TEAR_SCALE, TEAR_STATIC)),false)
  elseif TEAR_VARIANT == VARIANT_CUPID and TEAR_SCALE > 2.727 then
    tearSpr:Play("RegularTear" .. tostring(link_anm(TEAR_SCALE, TEAR_CUPID)),false)
  elseif TEAR_VARIANT == VARIANT_CUPID_BLOOD and TEAR_SCALE > 2.727 then
    tearSpr:Play("BloodTear" .. tostring(link_anm(TEAR_SCALE, TEAR_CUPID)),false)
  end
end

function mod:collision(tear, collider, low)
  TEAR_VARIANT = tear.Variant
  if TEAR_VARIANT >= customsVariantRange[1] and TEAR_VARIANT <= customsVariantRange[2] and tear.StickTarget == nil then
    TEAR_COLOR = tear:GetColor()
    TEAR_POINTER = GetPtrHash(tear)
    table.insert(deadTears, {tear, 1, TEAR_COLOR})      
    if tearTints[TEAR_POINTER] == nil then
      tearTints[TEAR_POINTER] = tableToColor(colorToTable(TEAR_COLOR))      --Esto es una putisima mierda y me voy a pegar un tiro en la pija
    end
  end
end

function mod:tearsDeath()
  bloodModifierActive = nil
  
  clock = clock + 1
  if clock > 600 then
    clock = 0
  end
  
  local i = 1
  while (i <= #deadTears) do
    if deadTears[i][2] == 1 then
      deadTears[i][2] = 2
    elseif deadTears[i][2] == 2 then
      local tear = deadTears[i][1]
      if tear:IsDead() then
        
        TEAR_SCALE = tear:ToTear().Scale
        TEAR_HEIGHT = tear.Height
        TEAR_POS = tear.Position
        TEAR_VARIANT = tear.Variant
        TEAR_POINTER = GetPtrHash(tear)
        TEAR_COLOR = tearTints[TEAR_POINTER]
        
        local poofSize = getPoofVariant(TEAR_SCALE, TEAR_HEIGHT)
        local poofHeightSnd = getTearHeightAndSnd(TEAR_HEIGHT)
        --local scaleCons = getPoofScaleCons(TEAR_SCALE)
        
        local poof
        if diamondVariant[TEAR_POINTER] then
          -- <[DIAMOND POOF]>
          poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, TEAR_POS, Vector(0,0), nil):ToEffect()
          local poofScale = TEAR_SCALE * 0.8
          poof:GetSprite().Scale = Vector(poofScale, poofScale)
          SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 0.25, 0, false, 2.5)
          
          -- <[DIAMOND PARTICLES]>
          for i = 1, math.random(2,3) do
            local vel = RandomVector() * math.random(0, 10)*0.5
            vel = Vector(vel.X, vel.Y * 0.5)
            local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DIAMOND_PARTICLE, 0, TEAR_POS, vel, nil):ToEffect()
            particle:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_085_diamondgibs_custom.png")
            particle:GetSprite():LoadGraphics()
            
            if TEAR_VARIANT == TEAR_CUPID_MULTID then
              particle:SetColor(multiD_Fade((tearsFrameDelay[1][tear.InitSeed][1]), {1.103, 0.986, 0.810, 1.0, 0, 0, 0}, {0.0838, 0.0749, 0.0616, 1.0, 0, 0, 0}, TEAR_COLOR.A), 0, 0, false, false)
            else
              local C = tearColors[TEAR_POINTER]
              if C == nil then
                C = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
                --SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1)    --crap
              end
              particle:SetColor(mixTearColors(TEAR_COLOR, C), 0, 0, false, false)
            end            
          end  
          
        else          
          -- <[REGULAR POOF]>
          poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, poofSize, 0, TEAR_POS, Vector(0,0), nil):ToEffect()
          if TEAR_SCALE >= 0.8 then
            local poofScale = TEAR_SCALE * getPoofScaleCons(TEAR_SCALE)
            poof:GetSprite().Scale = Vector(poofScale, poofScale)
          end
          SFXManager():Play(poofHeightSnd[2], 1, 0, false, 1)          
        end
        
        -- <[POOF TINT]>        
        if isVariant(TEAR_VARIANT, customs_MultiD) then          
          poof:SetColor(multiD_Fade((tearsFrameDelay[1][tear.InitSeed][1]), {1.103, 0.986, 0.810, 1.0, 0, 0, 0}, {0.0838, 0.0749, 0.0616, 1.0, 0, 0, 0}, TEAR_COLOR.A), 0, 0, false, false)
        else          
          local C = tearColors[TEAR_POINTER]
          if C == nil then
            C = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
            --SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1)    --crap
          end          
          if diamondVariant[TEAR_POINTER] and areSameColor(C, Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)) then
            poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_impact_custom.png")
            poof:GetSprite():LoadGraphics()
          end
          poof:SetColor(mixTearColors(TEAR_COLOR, C), 0, 0, false, false)
        end
        
        poof.PositionOffset = poofHeightSnd[1]
        
        if isVariant(poofSize, {TEAR_POOF_A_LARGE, TEAR_POOF_B_LARGE}) then
          poof:GetSprite().Rotation = math.random(4) * 90
        end
        
      --else
        --SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
        -- flat stone bounce
      end
      table.remove(deadTears, i)
      i = i-1
    end
    i = i+1
  end
  
  i = 1
  while (i <= #tearsFrameDelay[2]) do
    local seed = tearsFrameDelay[2][i]
    if tearsFrameDelay[1][seed][3] then
      table.remove(tearsFrameDelay[2], i)
      tearsFrameDelay[1][seed] = nil
      i = i-1
    else
      tearsFrameDelay[1][seed][1] = (tearsFrameDelay[1][seed][1] + 1) % 24
      tearsFrameDelay[1][seed][3] = true
    end
    i = i+1
  end
end

function mod.clearLists()
  clock = 0
  
  deadTears = {}
  tearColors = {}  
  boomerangColor = {}
  tearTints = {}
  builtTears = {}
  wasBloodVariant = {}
  previousVariant = {}  
  diamondVariant = {}
  tearAnimation = {}
  tearsFrameDelay[1] = {}
  tearsFrameDelay[2] = {}
end

function mod:clearTear(tear)
  TEAR_POINTER = GetPtrHash(tear)
  deadTears[TEAR_POINTER] = nil
  tearColors[TEAR_POINTER] = nil
  boomerangColor[TEAR_POINTER] = nil
  tearTints[TEAR_POINTER] = nil
  builtTears[TEAR_POINTER] = nil
  wasBloodVariant[TEAR_POINTER] = nil
  --previousVariant[tear.InitSeed] = nil
  diamondVariant[TEAR_POINTER] = nil
  tearAnimation[TEAR_POINTER] = nil
  
  local seed = tear.InitSeed
  TEAR_VARIANT = tear.Variant
  TEAR_COLOR = tear:GetColor()
  if TEAR_VARIANT >= customsVariantRange[1] and TEAR_VARIANT <= customsVariantRange[2] then
    if tearsFrameDelay[1][seed] == nil then
      tearsFrameDelay[1][seed] = {nil, TEAR_COLOR.A, nil}
    end
    if isVariant(TEAR_VARIANT, customs_MultiD) then
      if tearsFrameDelay[1][seed][1] == nil then
        tearsFrameDelay[1][seed][1] = tear.FrameCount
        tearsFrameDelay[1][seed][3] = false
        table.insert(tearsFrameDelay[2], seed)
      end
      local alpha = tearsFrameDelay[1][seed][2]
      tear:SetColor(Color(1, 1, 1, alpha, 0, 0, 0), 0, 0, false, false)
      TEAR_COLOR = tear:GetColor()
    end
  end
end

function mod:poof(poof)
  local size = poof:GetSprite().Scale.X
  if isVariant(poof.Variant, {EffectVariant.BULLET_POOF, EffectVariant.TEAR_POOF_A, EffectVariant.TEAR_POOF_B}) and size > 1.49 and poof.State == 0 then    --(1.49 = 1.8625 * 0.8)
    poof.State = 1
    local sprite = poof:GetSprite()
    if isVariant(poof.Variant, {EffectVariant.BULLET_POOF, EffectVariant.TEAR_POOF_A}) then
      sprite:Load("gfx/1000.xxx_tear poofa_large.anm2",false)
    else
      sprite:Load("gfx/1000.xxx_tear poofb_large.anm2",false)
    end    
    sprite:Play("Poof", true)
    sprite:LoadGraphics()
    poof:GetSprite().Scale = Vector(size * 0.5, size * 0.5)
    
    if poof.Variant == EffectVariant.BULLET_POOF then
      local C = Color(0.854, 0.053, 0.060, 1.0, 0, 0, 0)
      local POOF_COLOR = poof:GetColor()
      poof:SetColor(mixTearColors(POOF_COLOR, C), 0, 0, false, false)
    end
  end
  
  if poof.Variant == EffectVariant.BULLET_POOF and poof.FrameCount == 0 then
    poof.Rotation = math.random(4) * 90
  end
  
  --test = poof:GetSprite().Scale.X
  --test = poof.Color.R .. " " .. poof.Color.G .. " " .. poof.Color.B .. " " .. poof.Color.A .. " " .. poof.Color.RO .. " " .. poof.Color.GO .. " " .. poof.Color.BO
end

function mod:projectiles(projectile)
  if projectile.SpawnerType == EntityType.ENTITY_FIREPLACE then
    if projectile.FrameCount == 1 then
      local sprite = projectile:GetSprite()
      local anm = get_anm(sprite, "RegularTear", 19)
      sprite:Load("gfx/009.xxx_fire projectile.anm2", false)
      sprite:Play(anm, true)
      sprite:LoadGraphics()
    end
    projectile.SpriteRotation = (projectile.Velocity + Vector(0, projectile.FallingSpeed)):GetAngleDegrees()
  end
end

function mod:multiBB(fam)
  if fam.Variant == FamiliarVariant.MULTIDIMENSIONAL_BABY then
    fam.Velocity = Vector(0,0)
  end
end

local function ShowText()
  
  local entities = Isaac.GetRoomEntities()
  
	for i=1,#entities do
    if entities[i].Type == EntityType.ENTITY_TEAR then
      TEAR_COLOR = entities[i]:GetColor()
    end
  end
  Isaac.RenderText("Test2: " ..           tostring(test2),  45, 30, 255, 255, 255, 255)  
  Isaac.RenderText("Test:  " ..           tostring(test),  45, 40, 255, 255, 255, 255)
  
  Isaac.RenderText("Variant: " ..         tostring(TEAR_VARIANT),       45, 60, 255, 255, 255, 255)
  --Isaac.RenderText("Filename: " ..        tostring(TEAR_SPR_FILENAME),  45, 70, 255, 255, 255, 255)
  if TEAR_POS ~= nil then
    Isaac.RenderText("Position.X: " ..    tostring(TEAR_POS.X),         45, 90, 255, 255, 255, 255)
    Isaac.RenderText("Position.Y: " ..    tostring(TEAR_POS.Y),         45, 100, 255, 255, 255, 255)
  end
  
  Isaac.RenderText("Height: " ..          tostring(TEAR_HEIGHT),        45, 120, 255, 255, 255, 255)
  Isaac.RenderText("Flags: " ..           tostring(TEAR_FLAGS),         45, 130, 255, 255, 255, 255)
  Isaac.RenderText("Pointer: " ..         tostring(TEAR_POINTER),         45, 140, 255, 255, 255, 255)
  
  --Isaac.RenderText("Rotation: " ..        tostring(TEAR_ROTATION),      45, 160, 255, 255, 255, 255)
  --Isaac.RenderText("SpriteRotation: " ..  tostring(TEAR_SPR_ROTATION),  45, 170, 255, 255, 255, 255)
  
  Isaac.RenderText("EntityColor:",                                        45, 190, 255, 255, 255, 255)
  if TEAR_COLOR ~= nil then
    Isaac.RenderText("[\019]",  122, 190, TEAR_COLOR.R, TEAR_COLOR.G, TEAR_COLOR.B, TEAR_COLOR.A)
    Isaac.RenderText("(R: " .. TEAR_COLOR.R .. "; G: " .. TEAR_COLOR.G .. "; B: " .. TEAR_COLOR.B .. ")" , 55, 200, 255, 255, 255, 255)
    Isaac.RenderText("(A: " .. TEAR_COLOR.A .. "; RO: " .. TEAR_COLOR.RO .. "; GO: " .. TEAR_COLOR.GO .. "; BO: " .. TEAR_COLOR.BO .. ")" , 55, 210, 255, 255, 255, 255)
  end
  --Isaac.RenderText("SpriteColor: " ..       tostring(TEAR_SPR_COLOR),  45, 210, 255, 255, 255, 255)
  
  --Isaac.RenderText("Scale: " ..           tostring(TEAR_SCALE),  45, 230, 255, 255, 255, 255)
  Isaac.RenderText("TearSize: " ..        tostring(TEAR_SCALE),  45, 230, 255, 255, 255, 255)
  --Isaac.RenderText("BaseScale: " ..       tostring(TEAR_BASE_SCALE),  45, 240, 255, 255, 255, 255)
  --if TEAR_SIZE_MULTI ~= nil then    
  --  Isaac.RenderText("SizeMulti: " ..     tostring(TEAR_SIZE_MULTI.X) .. " " .. tostring(TEAR_SIZE_MULTI.Y),  45, 250, 255, 255, 255, 255)
  --end
  --Isaac.RenderText("SpriteScale: " ..     tostring(TEAR_SPR_SCALE),  205, 260, 255, 255, 255, 255)
  Isaac.RenderText("AnmSize: " ..         tostring(TEAR_ANM_NAME),  45, 260, 255, 255, 255, 255)
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.clearLists)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.clearTear)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.main)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.collision)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.tearsDeath)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.poof)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.projectiles)
--mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.multiBB)
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, ShowText);

local music = MusicManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function()
    if music:GetCurrentMusicID() ~= Music.MUSIC_SATAN_BOSS then return end
    music:Play(Isaac.GetMusicIdByName("Mega Satan Fight"), 0.1)
    music:UpdateVolume()
end, EntityType.ENTITY_MEGA_SATAN)

local json = require("json")
local roomIntensity = 0
local waveSpeed = 2
local intensityMultiplier = 2

local LERP_SPEED = 0.1

local MOD_PREFIX = "hotshader"

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- room:HasLava() is broken, so we have to use this instead
local function hasLava()
    return SFXManager():IsPlaying(SoundEffect.SOUND_LAVA_LOOP) and Game():GetRoom():HasLava()
end

local function split(str, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local function saveSettings()
    local data = {
        Intensity = intensityMultiplier,
        WaveSpeed = waveSpeed,
    }

    local encoded = json.encode(data)
    mod:SaveData(encoded)
end

local function loadSettings()
    local data = mod:LoadData()
    
    if data ~= "" then
        local decoded = json.decode(data)
        intensityMultiplier = decoded.Intensity or 2
        waveSpeed = decoded.WaveSpeed or 2
    else
        saveSettings()
    end
end

local function errorInCmd(correctUsage)
    Isaac.ConsoleOutput("Invalid command. Usage: " .. MOD_PREFIX .. " " .. correctUsage)
end

-- not sure if this shader crash fix by agentcucco is still necessary, but i'll put it in anyway
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end)

function mod:RenderUpdate()
    local room = Game():GetRoom()
    if hasLava() and not Game():IsPaused() then
        local lavaIntensity = room:GetLavaIntensity()
        local ratio = lavaIntensity / 1
        roomIntensity = lerp(roomIntensity, ratio * intensityMultiplier, LERP_SPEED)
    else
        roomIntensity = lerp(roomIntensity, 0, LERP_SPEED)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderUpdate)

function mod:ShaderUpdate(name)
    if name == "Hot_HeatWave" then
        return {
            Time = Game():GetFrameCount(),
            Intensity = roomIntensity,
            WaveSpeed = waveSpeed,
        }
    end
end

mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.ShaderUpdate)

function mod:GameStart()
    loadSettings()
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.GameStart)

loadSettings()

function mod:UseConsole(cmd, argString)
    local args = split(argString, " ")
    if cmd:lower() == MOD_PREFIX then
        if args[1] == "intensity" then
            local num = tonumber(args[2])
            if num then
                intensityMultiplier = num
                saveSettings()
            elseif args[2]:lower() == "default" then
                intensityMultiplier = 2
                saveSettings()
            else
                errorInCmd("intensity <number>")
            end
        elseif args[1] == "wavespeed" then
            local num = tonumber(args[2])
            if num then
                waveSpeed = num
                saveSettings()
            elseif args[2]:lower() == "default" then
                waveSpeed = 2
                saveSettings()
            else
                errorInCmd("wavespeed <number>")
            end
        else
            errorInCmd("<intensity|wavespeed> <number>")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.UseConsole)

local game = Game()

local DonationMachineVariant = 8
local GreedDonationMachineVariant = 11

--[[
Shops: Level
    - 0: Level 1
    - 1: Level 2
    - 2: Level 3
    - 3: Level 4
    - 4: Level 5
    - 10: Rare (good)
    - 11: Rare (bad)
    - 100: Tainted Keeper L1
    - 101: Tainted Keeper L2
    - 102: Tainted Keeper L3
    - 103: Tainted Keeper L4
    - 104: Tainted Keeper L5
    - 110: Tainted Keeper rare (good)
    - 111: Tainted Keeper rare (bad)
]]

local SpriteLevelPerShopSubtypes = {
    [1] = {0, 1, 11, 100, 101, 111},
    [2] = {2, 102},
    [3] = {3, 103},
    [4] = {4, 10, 104, 110}
}

function mod:OnNewRoom()
    local room = game:GetRoom()

    local uniqueCoinsSuffix = ""
    if UNIQUE_COINS_MOD then
        uniqueCoinsSuffix = "_uc"
    end

    for _, donationMachine in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, DonationMachineVariant)) do
        if not donationMachine:GetData().BetterDonationSprite then

            local spriteLevel

            if room:GetType() == RoomType.ROOM_SHOP then
                local level = game:GetLevel()
                local roomDesc = level:GetCurrentRoomDesc()
                local roomSubtype = roomDesc.Data.Subtype

                for sprlevel, subtypes in ipairs(SpriteLevelPerShopSubtypes) do
                    for _, subtype in ipairs(subtypes) do
                        if roomSubtype == subtype then
                            spriteLevel = sprlevel
                        end
                    end
                end
            else
                local shopLevel = room:GetShopLevel()

                --Do this so the shop level number is the same as the spritesheets
                shopLevel = shopLevel - 1
                spriteLevel = math.max(1, shopLevel)
            end

            local sprite = donationMachine:GetSprite()

            local spriteSheet = "/gfx/slots/donation_machine_lvl" .. spriteLevel .. uniqueCoinsSuffix .. ".png"

            for i = 0, sprite:GetLayerCount() - 1, 1 do
                if not (i == 4 and UNIQUE_COINS_MOD) then
                    sprite:ReplaceSpritesheet(i, spriteSheet)
                end
            end

            sprite:LoadGraphics()

            donationMachine:GetData().BetterDonationSprite = true
        end
    end

    for _, donationMachine in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, GreedDonationMachineVariant)) do
        if not donationMachine:GetData().BetterDonationSprite then

            local sprite = donationMachine:GetSprite()

            local spriteSheet = "gfx/slots/donation_machine_greed" .. uniqueCoinsSuffix .. ".png"

            for i = 0, sprite:GetLayerCount() - 1, 1 do
                if not (i == 4 and UNIQUE_COINS_MOD) then
                    sprite:ReplaceSpritesheet(i, spriteSheet)
                end
            end

            sprite:LoadGraphics()

            donationMachine:GetData().BetterDonationSprite = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnNewRoom)

-- {itemId, 'name', 'desc'}
local items = {
  --$$$ITEMS-START$$$
  {276, "Veyeral Heart", "Void Rains Upon It"}, {561, "Almond Water", "Backroom Beverage"}, {581, "Grey Matter", "Cerebral Discharge"}, {775, "Blue Milk", "HP + DMG Up, Perfect Freeze"}, {745, "Cool Shades", "Gold Rush"}, {809, "SPAM!", "Hunger Down"}, {904, "Fighter's Trophy", "It's The Winner!"}, {861, "Spherical Dice", "-0.1"}, {919, "Packed Lunch", "HP Up + Energy Up!"}, {844, "Hellhound Kibble", "DMG Up + It's all burnt"} 

}

local trinkets = {
  --$$$TRINKETS-START$$$
  {98, "Booger", "Nose Picker"}, {225, "Overcharged Battery", "Potentially Dangerous"}, {211, "Replica Gun", "Keep away from children"}

}

local game = Game()
if EID then
  -- Adds trinkets defined in trinkets
	for _, trinket in ipairs(trinkets) do
		local EIDdescription = EID:getDescriptionObj(5, 350, trinket[1]).Description
		EID:addTrinket(trinket[1], EIDdescription, trinket[2], "en_us")
	end

  -- Adds items defined in items
  for _, item in ipairs(items) do
		local EIDdescription = EID:getDescriptionObj(5, 100, item[1]).Description
		EID:addCollectible(item[1], EIDdescription, item[2], "en_us")
	end
end

if Encyclopedia then
  -- Adds trinkets defined in trinkets
	for _,trinket in ipairs(trinkets) do
		Encyclopedia.UpdateTrinket(trinket[1], {
			Name = trinket[2],
			Description = trinket[3],
		})
	end

  -- Adds items defined in items
  for _, item in ipairs(items) do
		Encyclopedia.UpdateItem(item[1], {
			Name = item[2],
			Description = item[3],
		})
	end
end

-- Handle displaying trinket names

if #trinkets ~= 0 then
    local t_queueLastFrame
    local t_queueNow
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
        t_queueNow = player.QueuedItem.Item
        if (t_queueNow ~= nil) then
            for _, trinket in ipairs(trinkets) do
                if (t_queueNow.ID == trinket[1] and t_queueNow:IsTrinket() and t_queueLastFrame == nil) then
                    game:GetHUD():ShowItemText(trinket[2], trinket[3])
                end
            end
        end
        t_queueLastFrame = t_queueNow
    end)
end

-- Handle displaying item names

if #items ~= 0 then
    local i_queueLastFrame
    local i_queueNow
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
        i_queueNow = player.QueuedItem.Item
        if (i_queueNow ~= nil) then
            for _, item in ipairs(items) do
                if (i_queueNow.ID == item[1] and i_queueNow:IsCollectible() and i_queueLastFrame == nil) then
                    game:GetHUD():ShowItemText(item[2], item[3])
                end
            end
        end
        i_queueLastFrame = i_queueNow
    end)
end

local json = require("json")
 
local game = Game()
local SaveState = {}
 
local ChimeSettings = {
    ["IgnoreBlind"] = false,
    ["MinimumQuality"] = 4
}
 
local CustomChimeTable = {}
 
--Loading in the sound effects to be played
SFX_Chime = Isaac.GetSoundIdByName("Chime")
 
function mod:onUpdate()
    local FindAllPedastals = Isaac.FindByType(5, 100, -1)
 
    for i, Pedastal in pairs(FindAllPedastals) do
        --If the Mod Config Menu settings allow for bypassing Curse of the Blind
        if ChimeSettings["IgnoreBlind"] or game:GetLevel():GetCurses() ~= LevelCurse.CURSE_OF_BLIND then
            local Item = Isaac.GetItemConfig():GetCollectible(Pedastal.SubType)
 
            --If set to true in Mod Config or lower than or equal to the minimum quality or if Mod Config is not installed, just see if the quality is 0
            if (CustomChimeTable[Item.ID] == nil or CustomChimeTable[Item.ID] == 0) then
                local ToPlay = SoundEffect.SOUND_NULL
 
                if (Item.Quality >= ChimeSettings["MinimumQuality"]) then
                    ToPlay = SFX_Chime
                end
 
                SFXManager():Play(ToPlay)
            else
                SFXManager():Play(SFX_Chime)
            end
        end
    end
end
 
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onUpdate)
 
local removeInitReactionPack = false
 
local function InitReactionPack()
    if removeInitReactionPack then
        return
    end
 
    if ReactionPack and ReactionPack.Enabled then
        local soundDefault = {'Chime'}
        local sounds = {}
    
        ReactionPack.AddPogSoundPack(sounds, "Bell Chime", soundDefault)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onUpdate)
    end
    removeInitReactionPack = true
--    mod:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, InitReactionPack)
end
 
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, InitReactionPack)
 