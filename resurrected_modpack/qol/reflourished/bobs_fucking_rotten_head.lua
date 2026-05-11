local function BobFixEnabler()

local BobFix = {}
local mod = IsaacReflourished


---@param tear EntityTear
function BobFix:StripBobHead(tear)
    Isaac.CreateTimer(function() 
        -- print("1. " .. tostring(tear.TearFlags))
        tear.TearFlags = TearFlags.TEAR_NORMAL
        tear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON)

        local player = tear.SpawnerEntity:ToPlayer()
        if not player then return end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOBBY_BOMB) then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_BLOOD_BOMB)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SAD_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_SAD_BOMB)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BUTT_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_BUTT_BOMB)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_GLITTER_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_GLITTER_BOMB)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_STICKY_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_STICKY)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE_BOMB)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_HOT_BOMBS) then
            tear:AddTearFlags(TearFlags.TEAR_BURN)
        end

        --TODO: Add custom support for ghost bombs, bomber boy cross bombs, mr. mega, 
        
        -- print("2. " .. tostring(tear.TearFlags))
    end, 1, 1, false)

end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, BobFix.StripBobHead, TearVariant.BOBS_HEAD)

end
return BobFixEnabler