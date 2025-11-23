local TR_Manager = require("resurrected_modpack.manager")
local ragmegasoundslikeragman = TR_Manager:RegisterMod("Rag Mega Sounds Like Rag Man", 1)

local sound = SFXManager()
local ragmegaroom = false

--TODO: apply the Duke of Flies sound effect replacement to the Rag Mega form of Delirium
--Note that we would need to set ragmegaroom to false once Delirium changes form to something else!

function ragmegasoundslikeragman:DesignateRagMegaRoom(entitytype, variant)
	if entitytype == EntityType.ENTITY_RAG_MEGA and variant == 0 then
		ragmegaroom = true
	end
end
ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, ragmegasoundslikeragman.DesignateRagMegaRoom)

function ragmegasoundslikeragman:ResetRagMegaRoom()
	ragmegaroom = false
end
ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ragmegasoundslikeragman.ResetRagMegaRoom)

function ragmegasoundslikeragman:FindRagMegaOnRender()
	local room = Game():GetRoom()
	if room:GetFrameCount() == 5 and not ragmegaroom then
		ragmegacount = Isaac.CountEntities(nil, EntityType.ENTITY_RAG_MEGA, 0)
		if ragmegacount > 0 then
			ragmegaroom = true
		end
	end
end
ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_POST_RENDER, ragmegasoundslikeragman.FindRagMegaOnRender)

function ragmegasoundslikeragman:GetRandomRagManAttackSound()
	local rng = math.random(0,1)
	if rng == 1 then
		return SoundEffect.SOUND_RAGMAN_1
	else
		return SoundEffect.SOUND_RAGMAN_4
	end
end

--Potential issue: does Duke of Flies or Husk ever appear with Rag Mega? Don't want to replace the sounds if coming from Duke of Flies or Husk
function ragmegasoundslikeragman:ReplaceRaglingSpawnSound(id, volume, frameDelay, loop, pitch, pan)
	if ragmegaroom then
		return {ragmegasoundslikeragman:GetRandomRagManAttackSound(), volume, frameDelay, loop, pitch, pan}
	end
end

function ragmegasoundslikeragman:StopOldRagMegaSounds()
	if ragmegaroom then
		if sound:IsPlaying(SoundEffect.SOUND_MONSTER_GRUNT_1) then
			sound:Stop(SoundEffect.SOUND_MONSTER_GRUNT_1)
		end
		if sound:IsPlaying(SoundEffect.SOUND_MONSTER_GRUNT_2) then
			sound:Stop(SoundEffect.SOUND_MONSTER_GRUNT_2)
		end
		if sound:IsPlaying(SoundEffect.SOUND_MONSTER_GRUNT_4) then
			sound:Stop(SoundEffect.SOUND_MONSTER_GRUNT_4)
		end
	end
end

if REPENTOGON then
	ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, ragmegasoundslikeragman.ReplaceRaglingSpawnSound, SoundEffect.SOUND_MONSTER_GRUNT_1)
	ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, ragmegasoundslikeragman.ReplaceRaglingSpawnSound, SoundEffect.SOUND_MONSTER_GRUNT_2)
	ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, ragmegasoundslikeragman.ReplaceRaglingSpawnSound, SoundEffect.SOUND_MONSTER_GRUNT_4)
else
	ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_NPC_UPDATE, ragmegasoundslikeragman.StopOldRagMegaSounds, EntityType.ENTITY_RAG_MEGA)
end

function ragmegasoundslikeragman:PlayRagManSounds(entity)
	local sprite = entity:GetSprite()
	local anim = sprite:GetAnimation()
	local frame = sprite:GetFrame()
	
	if (anim == "Attack01" and frame == 17 and not REPENTOGON) or (anim == "Uncover" and frame == 20) then
		sound:Play(ragmegasoundslikeragman:GetRandomRagManAttackSound(),1,0,false,1)
	elseif anim == "Rebirth" and frame == 18 then
		sound:Play(SoundEffect.SOUND_RAGMAN_2,1,0,false,1)
		sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
	elseif anim == "Cover" and frame == 4 then
		sound:Play(SoundEffect.SOUND_RAGMAN_3,1,0,false,1)
	end
end
ragmegasoundslikeragman:AddCallback(ModCallbacks.MC_NPC_UPDATE, ragmegasoundslikeragman.PlayRagManSounds, EntityType.ENTITY_RAG_MEGA)