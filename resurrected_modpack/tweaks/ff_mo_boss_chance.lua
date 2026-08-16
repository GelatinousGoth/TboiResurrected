local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("FF Mo Boss Chance", 1)

function mod:newMoBossChance()
if not FiendFolio then return end
    FiendFolio.MoChance = 0
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.newMoBossChance)
