local TR_Manager = require("resurrected_modpack.manager")
DeliriousDeath = TR_Manager:RegisterMod("Delirious Death", 1)

local mod = DeliriousDeath

local sndfired = false
local gswapclock = 0

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Type == 412 and npc.Variant == 0 then
		local sprite = npc:GetSprite()
		if sprite:IsPlaying("Scream") then
			if sprite:WasEventTriggered("DieSound1") and not sndfired then
				npc:PlaySound(SoundEffect.SOUND_DOGMA_SCREAM, 0.2, 1, false, 0.4)
				npc:PlaySound(SoundEffect.SOUND_POISON_WARN, 1, 10, false, 1.5)
				sndfired = true
				gswapclock = 60 end
			else
        sndfired = false
		end
	end
end, 412)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_WATER_EXPLOSION, 0.66, 0, false, 0.7)
    SFXManager():Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_CLOSE, 0.11, 0, false, 1.33)
end, 412)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if gswapclock > 0 then
        gswapclock = gswapclock - 1
	else gswapclock = 0
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, type, variant, subtype, position, velocity, spawner, seed)
    if gswapclock > 0 and type == EntityType.ENTITY_EFFECT then
        if variant == 2 then
            return {EntityType.ENTITY_EFFECT, 132, 2}
        elseif variant == 5 or variant == 70 then
            return {EntityType.ENTITY_EFFECT, 123, 7}
        elseif variant == 7 then
            return {EntityType.ENTITY_EFFECT, 77, 0}
        end
    end
end)