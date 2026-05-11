local function MultishotKeepersEnabler()

local MultishotKeepers = {}
local mod = IsaacReflourished
local utility = mod.Utility


---@param player EntityPlayer
---@param flag CacheFlag
function MultishotKeepers:Cache(player, flag)
    if not (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) then return end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then return end
    
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
            utility:addTearMultiplier(player, 1/0.51)
        else
            utility:addTearMultiplier(player, 1/0.42)
        end
    end

    if (player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN)) and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        utility:addTearMultiplier(player, 1/0.51)
    end

end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, MultishotKeepers.Cache, CacheFlag.CACHE_FIREDELAY)

end
return MultishotKeepersEnabler