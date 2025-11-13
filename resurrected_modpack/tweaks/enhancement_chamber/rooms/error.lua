--[[ Error ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local game = Game()
local music = MusicManager()
local volume = Options.MusicVolume

-- Glitched Items --
function mod:errorPostRoom()
    if not config["error"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_ERROR and room:IsFirstVisit() then
        -- Glitch Item --
        local glitchUnlock = Isaac.GetPersistentGameData():Unlocked(Achievement.TMTRAINER)
        if glitchUnlock then
            local player = Isaac.GetPlayer(0)
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, false) then
                local currentMusic = music:GetCurrentMusicID()
                player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, 0, true, 0, 0)
                player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false, -1, 0)
                player:RemoveCollectible(721, false, 0, true)
                music:Play(currentMusic, volume)
                local effects = Isaac.FindByType(1000, 15, -1)
                for i = 1, #effects do effects[i]:Remove() end
            end
        end
        -- Jingle --
        local jingleChance = math.random(3)
        music:PlayJingle(Isaac.GetMusicIdByName("Error Room Entry (jingle) " .. tostring(jingleChance)))
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.errorPostRoom)