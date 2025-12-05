--[[ Item Sound ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Changes choir sound when getting an item
---@param id SoundEffect
function mod:ItemSound(id)
    local room = game:GetLevel():GetCurrentRoom()

    if id == SoundEffect.SOUND_CHOIR_UNLOCK then

        if room:GetType() == RoomType.ROOM_CURSE then
            sound:Play(SoundEffect.SOUND_DEVILROOM_DEAL) -- Evil sound
            return false
        elseif room:GetType() == RoomType.ROOM_PLANETARIUM then
            sound:Play(SoundEffect.SOUND_POWERUP1) -- Treasure sound
            return false
        elseif room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_ANGEL then
            sound:Play(SoundEffect.SOUND_POWERUP2) -- Boss sound
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.ItemSound, SoundEffect.SOUND_CHOIR_UNLOCK)