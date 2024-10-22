local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Keeper Coin Tears", 1)

function mod:onTear(tear)
	local player = Isaac.GetPlayer(0)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
		local playerType = player:GetPlayerType()
		if (playerType == PlayerType.PLAYER_KEEPER_B) then
			tear:ChangeVariant(TearVariant.COIN)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR , mod.onTear)