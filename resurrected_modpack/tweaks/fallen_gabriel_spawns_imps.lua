local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Fallen Gabriel Spawns Imps", 1)

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subtype, position, velocity, spawner, seed, size)
    if type == 38 and spawner and spawner.Type == 272 and spawner.Variant == 1 and spawner.SubType == 0 then
        return {259, 0, 0, seed}
    end
end)