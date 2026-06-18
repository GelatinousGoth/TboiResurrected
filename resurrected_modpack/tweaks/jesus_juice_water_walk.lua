local TR_Manager = require("resurrected_modpack.manager")
local jjwow = TR_Manager:RegisterMod("Jesus Juice: Walk on Water", 1, true)

jjwow:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for p = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(p - 1)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_JESUS_JUICE) then
			local room = Game():GetRoom()
			if room:HasWater() or room:HasWaterPits() then
				for i = 0, room:GetGridSize() do
					local water = room:GetGridEntity(i)
					if water and water:ToPit() then
						water:ToPit():SetLadder(true)
					end
				end
			end
			return
		end
	end
end)

function jjwow:useFlush()
	for p = 1, Game():GetNumPlayers() do
		local player = Isaac.GetPlayer(p - 1)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_JESUS_JUICE) then
			local room = Game():GetRoom()
			for i = 0, room:GetGridSize() do
				local water = room:GetGridEntity(i)
				if water and water:ToPit() then
					water:ToPit():SetLadder(true)
				end
			end
			return
		end
	end	
end
jjwow:AddCallback(ModCallbacks.MC_USE_ITEM, jjwow.useFlush, CollectibleType.COLLECTIBLE_FLUSH)