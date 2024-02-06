local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Hanging Dream Catcher"

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