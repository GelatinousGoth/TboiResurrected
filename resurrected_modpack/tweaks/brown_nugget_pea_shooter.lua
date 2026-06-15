local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Brown Nugget Pea Shooter Yeah", 1)

function mod:removeBrownNuggetFromPool()
    local config = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BROWN_NUGGET)
    if config then
        config.Tags = config.Tags & ~ItemConfig.TAG_POOP
    end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.removeBrownNuggetFromPool)

function mod:changePooterTears(tear)
    local spawner = tear.SpawnerEntity
    if spawner and spawner.Type == EntityType.ENTITY_FAMILIAR and spawner.Variant == FamiliarVariant.BROWN_NUGGET_POOTER then
        tear:ChangeVariant(TearVariant.BLUE)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.changePooterTears)
