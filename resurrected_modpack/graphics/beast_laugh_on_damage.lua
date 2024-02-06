local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "The Beast Laughs On Damage"

local isaacisdamagedinbeastfight = 0

function mod:beastlaughanimation(npc)
    if npc.Type == 1 and #Isaac.FindByType(951, 100, -1, false, true) >= 1 and isaacisdamagedinbeastfight == 0 then
        isaacisdamagedinbeastfight = 1
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.beastlaughanimation)

function mod:beastlaughanimation(npc)
    if isaacisdamagedinbeastfight == 1 and npc.Type == 951 and npc.Variant == 100 and npc:GetSprite():IsPlaying("Idle") then
            npc:GetSprite():Play("Laugh", true)
    end
    if npc:GetSprite():IsFinished("Laugh") and npc.Type == 951 and npc.Variant == 100 and isaacisdamagedinbeastfight == 1 then
            npc:GetSprite():Play("Idle", true)
            isaacisdamagedinbeastfight = 0
    end
    if npc.Type == 951 and npc.Variant == 40 and npc:IsDead() then
            isaacisdamagedinbeastfight = 2
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.beastlaughanimation)