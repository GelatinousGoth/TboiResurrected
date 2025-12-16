local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Super Greed Coin Tears", 1)

---@param entityType EntityType
---@param variant integer
---@param subtype integer
---@param spawner Entity?
---@param seed integer
local function OnSpawn(_, entityType, variant, subtype, _, _, spawner, seed)
    if not spawner then
        return
    end

    if spawner.Type ~= EntityType.ENTITY_GREED or spawner.Variant ~= 1 then
        return
    end

    if entityType ~= EntityType.ENTITY_PROJECTILE then
        return
    end

    return {entityType, ProjectileVariant.PROJECTILE_COIN, subtype, seed}
end

-- Low priority because it's an override
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, math.maxinteger, OnSpawn)