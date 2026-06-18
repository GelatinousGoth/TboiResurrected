local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Tainted Eden Smelted Trinket Fix", 1)

--removes the player's current trinkets, gives the player the one you provided, uses the smelter, then gives the player back the original trinkets.
local function AddSmeltedTrinket(player, trinket, firstTimePickingUp)
	if firstTimePickingUp == nil then
		firstTimePickingUp = true
	end

	--get the trinkets they're currently holding
	local trinket0 = player:GetTrinket(0)
	local trinket1 = player:GetTrinket(1)

	--remove them
	if trinket0 ~= 0 then
		player:TryRemoveTrinket(trinket0)
	end
	if trinket1 ~= 0 then
		player:TryRemoveTrinket(trinket1)
	end

	player:AddTrinket(trinket, firstTimePickingUp) --add the trinket
	player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, false) --smelt it

	--give their trinkets back
	if trinket0 ~= 0 then
		player:AddTrinket(trinket0, false)
	end
	if trinket1 ~= 0 then
		player:AddTrinket(trinket1, false)
	end
end

local function GetMaxTrinketID()
	return Isaac.GetItemConfig():GetTrinkets().Size -1
end

function mod:entityTakeDamage(tookDamage, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local player = tookDamage:ToPlayer()
	if player then
		if player:GetPlayerType() == PlayerType.PLAYER_EDEN_B then
			if damageFlags & (DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES) == 0 then
				for i = 1, GetMaxTrinketID() do
					if (player:GetTrinketMultiplier(i) == 1) or (player:GetTrinketMultiplier(i) == 2 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX)) then -- singular trinket
						if (player:GetTrinket(0) ~= i) and (player:GetTrinket(1) ~= i) then
							if player:TryRemoveTrinket(i) then
								AddSmeltedTrinket(player, Game():GetItemPool():GetTrinket(), false)
							end
						end
					elseif player:GetTrinketMultiplier(i) > 1 then -- possibly golden trinket
						if (player:GetTrinket(0) ~= i) and (player:GetTrinket(1) ~= i) then
							if player:TryRemoveTrinket(i + TrinketType.TRINKET_GOLDEN_FLAG) then -- definitely golden trinket
								AddSmeltedTrinket(player, Game():GetItemPool():GetTrinket(), false)
							end
						end
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.entityTakeDamage, EntityType.ENTITY_PLAYER)