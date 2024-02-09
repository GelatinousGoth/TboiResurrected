local mod = require("resurrected_modpack.mod_reference")
mod.CurrentModName = "bygone_over_bb"
local spawnedBlueBabies = {}
local corpseSpawned = false
local bbBossId = 40

function mod:initVars(npc) -- changing this to an npc callback will make it reset per blue baby instance
    spawnedBlueBabies = {}
end

function mod:handleBlueBabyDeath(npc)
    if not npc or npc.Variant ~= 1 then
        return
    end

    local sprite = npc:GetSprite()

    if sprite:IsFinished("2Evolve") and not spawnedBlueBabies[npc.Index] then
        local newCorpse = Isaac.Spawn(79, 2021, 0, npc.Position, Vector(0.0, 0.0), npc)
        mod:animateCorpse(newCorpse)
        spawnedBlueBabies[npc.Index] = newCorpse
    end
end

function mod:animateCorpse(corpse)
    corpse:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    corpse:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
    corpse.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    local sprite = corpse:GetSprite()
    sprite:Play("2EvolveDead")
end

function mod:killMyCorpse(npc)
    if not npc or npc.Variant ~= 1 then
        return
    end

    if spawnedBlueBabies[npc.Index] then
        Isaac.Spawn(1000, 77, 0, spawnedBlueBabies[npc.Index].Position, Vector(0.0, 0.0), spawnedBlueBabies[npc.Index])
		Isaac.Spawn(1000, 16, 4, spawnedBlueBabies[npc.Index].Position, Vector(0.0, 0.0), spawnedBlueBabies[npc.Index])
        spawnedBlueBabies[npc.Index]:Kill()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.initVars, EntityType.ENTITY_ISAAC)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.handleBlueBabyDeath, EntityType.ENTITY_ISAAC)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.killMyCorpse, EntityType.ENTITY_ISAAC)