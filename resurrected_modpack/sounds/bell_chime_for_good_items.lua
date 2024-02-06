local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Bell Chime for Good Items"

local game = Game()
local SaveState = {}
 
local ChimeSettings = {
    ["IgnoreBlind"] = false,
    ["MinimumQuality"] = 4
}
 
local CustomChimeTable = {}
 
--Loading in the sound effects to be played
SFX_Chime = Isaac.GetSoundIdByName("Chime")
 
function mod:onUpdate()
    local FindAllPedastals = Isaac.FindByType(5, 100, -1)
 
    for i, Pedastal in pairs(FindAllPedastals) do
        --If the Mod Config Menu settings allow for bypassing Curse of the Blind
        if ChimeSettings["IgnoreBlind"] or game:GetLevel():GetCurses() ~= LevelCurse.CURSE_OF_BLIND then
            local Item = Isaac.GetItemConfig():GetCollectible(Pedastal.SubType)
 
            --If set to true in Mod Config or lower than or equal to the minimum quality or if Mod Config is not installed, just see if the quality is 0
            if (CustomChimeTable[Item.ID] == nil or CustomChimeTable[Item.ID] == 0) then
                local ToPlay = SoundEffect.SOUND_NULL
 
                if (Item.Quality >= ChimeSettings["MinimumQuality"]) then
                    ToPlay = SFX_Chime
                end
 
                SFXManager():Play(ToPlay)
            else
                SFXManager():Play(SFX_Chime)
            end
        end
    end
end
 
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onUpdate)
 
local removeInitReactionPack = false
 
local function InitReactionPack()
    if removeInitReactionPack then
        return
    end
 
    if ReactionPack and ReactionPack.Enabled then
        local soundDefault = {'Chime'}
        local sounds = {}
    
        ReactionPack.AddPogSoundPack(sounds, "Bell Chime", soundDefault)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onUpdate)
    end
    removeInitReactionPack = true
--    mod:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, InitReactionPack)
end
 
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, InitReactionPack)