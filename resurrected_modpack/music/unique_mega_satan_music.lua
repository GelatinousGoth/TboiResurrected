local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Unique Mega Satan Music", 1)

local music = MusicManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function()
    if music:GetCurrentMusicID() ~= Music.MUSIC_SATAN_BOSS then return end
    music:Play(Isaac.GetMusicIdByName("Mega Satan Fight"), 0.1)
    music:UpdateVolume()
end, EntityType.ENTITY_MEGA_SATAN)