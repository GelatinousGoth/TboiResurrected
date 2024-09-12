local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Keeper Coin Tears"

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