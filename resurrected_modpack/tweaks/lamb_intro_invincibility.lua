local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Lamb Intro Invincibility"

function mod:SpawnInvincibility(entity)
    return entity:ToNPC().State ~= (NpcState.STATE_APPEAR or NpcState.STATE_APPEAR_CUSTOM or NpcState.STATE_INIT)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.SpawnInvincibility, EntityType.ENTITY_THE_LAMB)