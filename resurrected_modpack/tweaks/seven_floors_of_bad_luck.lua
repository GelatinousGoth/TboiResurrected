local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Seven Floors of Bad Luck"

function mod:onStart(savestate)
	if savestate then
		if mod:HasData() then mod.Storage = mod.json.decode(mod:LoadData())
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
        mod:SaveData(mod.json.encode(mod.Storage))
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
        mod:SaveData(mod.json.encode(mod.Storage))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onEnd)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newFloor)