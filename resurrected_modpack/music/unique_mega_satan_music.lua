local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Unique Mega Satan Music"

local music = MusicManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function()
    if music:GetCurrentMusicID() ~= Music.MUSIC_SATAN_BOSS then return end
    music:Play(Isaac.GetMusicIdByName("Mega Satan Fight"), 0.1)
    music:UpdateVolume()
end, EntityType.ENTITY_MEGA_SATAN)