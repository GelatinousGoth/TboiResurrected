--[[ Item Sound ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Changes choir sound when getting an item
---@return boolean?
function mod:GetItemSound()
    local room = game:GetRoom()
    if not self.Config.item_sounds.bool then return end
    if room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_ANGEL then return end

    local itemSound = {
        [RoomType.ROOM_CURSE] = SoundEffect.SOUND_DEVILROOM_DEAL,
        [RoomType.ROOM_PLANETARIUM] = SoundEffect.SOUND_POWERUP1
    }

    local snd = itemSound[room:GetType()] or SoundEffect.SOUND_POWERUP2
    sound:Play(snd)

    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.GetItemSound, SoundEffect.SOUND_CHOIR_UNLOCK)