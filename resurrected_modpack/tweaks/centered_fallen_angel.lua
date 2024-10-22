local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Centered Fallen Angels", 1)

local PENTAGRAM_CENTER = Vector(320, 520)
local FALLEN_ANGELS = {
    [EntityType.ENTITY_URIEL] = true,
    [EntityType.ENTITY_GABRIEL] = true
}

function mod:CenterFallenAngel(entityNPC)
    if FALLEN_ANGELS[entityNPC.Type] and entityNPC.SpawnerType == EntityType.ENTITY_MEGA_SATAN then
        entityNPC.Position = PENTAGRAM_CENTER
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CenterFallenAngel)