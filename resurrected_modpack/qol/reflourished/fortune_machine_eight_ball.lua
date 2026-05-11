local function FortuneMachine8BallEnabler()

local FortuneMachine8Ball = {}
local mod = IsaacReflourished


function FortuneMachine8Ball:CrystalBallInit(type, variant, subtype, pos, velocity, spawner, seed)
    if not (variant == PickupVariant.PICKUP_COLLECTIBLE and subtype == CollectibleType.COLLECTIBLE_CRYSTAL_BALL) then return end

    for i, entity in pairs(Isaac.FindInRadius(pos, 2)) do
        if entity.Type == EntityType.ENTITY_SLOT and entity.Variant == SlotVariant.FORTUNE_TELLING_MACHINE and entity:ToSlot():GetState() == 2 then
            local rng = Isaac.GetPlayer():GetCollectibleRNG(CollectibleType.COLLECTIBLE_MAGIC_8_BALL)
            local roll = rng:RandomInt(2)
            if roll == 1 then
                return {type, variant, CollectibleType.COLLECTIBLE_MAGIC_8_BALL, seed}
            end
        end
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, FortuneMachine8Ball.CrystalBallInit)


mod:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_ITEMS, function(_, chance)

    local eightBallStackable = IsaacReflourished:GetSettingsValue("FortuneEightBallStackable") == 2
    if not eightBallStackable then return end

    local eightBallCount = PlayerManager.GetNumCollectibles(CollectibleType.COLLECTIBLE_MAGIC_8_BALL)

    if eightBallCount > 1 then
        chance = chance + ((eightBallCount-1) * 0.15)
        return chance
    end

end)

end
return FortuneMachine8BallEnabler