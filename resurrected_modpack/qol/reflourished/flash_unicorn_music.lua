local function UnicornMusicEnabler()

local UnicornMusic = {}
local mod = IsaacReflourished

local UNICORN_MUSIC = Isaac.GetMusicIdByName("Unicorn Music")
local UNICORN_MUSIC_EXTENDED = Isaac.GetMusicIdByName("Unicorn Music Extended")
local music = (MMC and MMC.Manager or MusicManager)()
local playingUnicornMusic = false

local COLLECTIBLE_EFFECTS = {
    [CollectibleType.COLLECTIBLE_GAMEKID] = true,
    [CollectibleType.COLLECTIBLE_UNICORN_STUMP] = true,
    [CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = true,
    [CollectibleType.COLLECTIBLE_TAURUS] = true
}


if StageAPI then
    StageAPI.StopOverridingMusic(UNICORN_MUSIC, true, true)
    StageAPI.StopOverridingMusic(UNICORN_MUSIC_EXTENDED, true, true)
end

local function AnyPlayerHasInvincibilityEffect()

    for _, player in pairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()
        for j in pairs(COLLECTIBLE_EFFECTS) do
            if effects:HasCollectibleEffect(j) then
                local cooldown = player:GetEffects():GetCollectibleEffect(j).Cooldown
                if cooldown > 0 then 
                    return true
                end
            end
        end
    end
    return false
end

if not REPENTANCE_PLUS then

    function UnicornMusic:UseItem(item, rng, player, flags)
        if not COLLECTIBLE_EFFECTS[item] then return end
        music:Play(UNICORN_MUSIC_EXTENDED, 1)
        playingUnicornMusic = true

    end
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, UnicornMusic.UseItem)


    function UnicornMusic:UseCard(card, player, flags)
        if card ~= Card.CARD_CHARIOT then return end
        music:Play(UNICORN_MUSIC_EXTENDED, 1)
        playingUnicornMusic = true

    end
    mod:AddCallback(ModCallbacks.MC_USE_CARD, UnicornMusic.UseCard)


    function UnicornMusic:UsePill(effect, player, flags)
        if effect ~= PillEffect.PILLEFFECT_POWER then return end 
        --Feels like i'm walking on sunshine activates the use item callback so its not needed here
        music:Play(UNICORN_MUSIC_EXTENDED, 1)
        playingUnicornMusic = true

    end
    mod:AddCallback(ModCallbacks.MC_USE_PILL, UnicornMusic.UsePill)


    local playersThatHadTaurus = {}

    ---@param player EntityPlayer
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        local taurusEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_TAURUS)
        if (taurusEffect and taurusEffect.Cooldown and taurusEffect.Cooldown > 0) then
            if not (playersThatHadTaurus[player.ControllerIndex] and playersThatHadTaurus[player.ControllerIndex] == true) then
                playersThatHadTaurus[player.ControllerIndex] = true
                music:Play(UNICORN_MUSIC_EXTENDED, 1)
                playingUnicornMusic = true
            end
        else
            playersThatHadTaurus[player.ControllerIndex] = false
        end
    end)

else
    ---@param itemConfigItem ItemConfigItem
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, function(_, player, itemConfigItem, addCostume, count)
        if not (itemConfigItem:IsCollectible() and COLLECTIBLE_EFFECTS[itemConfigItem.ID]) then return end
        if playingUnicornMusic then return end
        local cooldown = player:GetEffects():GetCollectibleEffect(itemConfigItem.ID).Cooldown
        if cooldown <=0 then return end
        Isaac.CreateTimer(function()
            music:Play(UNICORN_MUSIC_EXTENDED, 1)
            music:UpdateVolume()
            music:ResetPitch()
        end, 1, 1, true)

        playingUnicornMusic = true
    end)
end


---@param itemConfigItem ItemConfigItem
function UnicornMusic:EffectRemoved(player, itemConfigItem)
    if not (itemConfigItem:IsCollectible() and COLLECTIBLE_EFFECTS[itemConfigItem.ID]) then return end
    if not playingUnicornMusic then return end
    if AnyPlayerHasInvincibilityEffect() then return end


    playingUnicornMusic = false
    if music:GetCurrentMusicID() == UNICORN_MUSIC or music:GetCurrentMusicID() == UNICORN_MUSIC_EXTENDED then
        MusicManager():Fadeout()
        music:PitchSlide(1)
    end
    local stageAPITrackPlaying = false
    if StageAPI and StageAPI.CurrentStage then
        local inCustomStage = StageAPI.InOverriddenStage()
        local musicRoom = StageAPI.GetCurrentRoom()
        if (inCustomStage and StageAPI.GetDimension() ~= Dimension.DEATH_CERTIFICATE) or musicRoom then
            local id = music:GetCurrentMusicID()
            local musicID, shouldLayer, shouldQueue, disregardNonOverride, isMirrorMusic
            if musicRoom then
                musicID, shouldLayer = musicRoom:GetPlayingMusic()
            end

            if not musicID then
                musicID, shouldLayer, shouldQueue, disregardNonOverride, isMirrorMusic = StageAPI.CurrentStage:GetPlayingMusic()
            end

            if musicID then 
                stageAPITrackPlaying = true
                Isaac.CreateTimer(function()
                    music:Play(musicID, 0.0)
                    music:VolumeSlide(1, 0.04)
                end,10, 1, true)
            else
                Game():GetRoom():PlayMusic()
            end
        end
    end

    local mmcTrackPlaying = false
    if MMC and not stageAPITrackPlaying then
        local room = Game():GetRoom()
        local track = MMC.GetMusicTrack()
        if room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() then
            track = MMC.GetBossTrack() or track
        end
        if track then
            mmcTrackPlaying = true
            music:Play(track, 0.0)
            music:VolumeSlide(1, 0.04)
        end
    end

    if not mmcTrackPlaying and not stageAPITrackPlaying then
        Isaac.CreateTimer(function()
            Game():GetRoom():PlayMusic()
            music:ResetPitch()
            --music:VolumeSlide(1, 0.04)
        end,10, 1, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, UnicornMusic.EffectRemoved)


mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, id)
    if (id == UNICORN_MUSIC or id == UNICORN_MUSIC_EXTENDED) then return end
    if playingUnicornMusic then
        return false
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if playingUnicornMusic then
        music:VolumeSlide(1)
        music:UpdateVolume()
        music:PitchSlide(1)
    end
end)

-- mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
--     --Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
--     -- if music:GetCurrentMusicID() == UNICORN_MUSIC or music:GetCurrentMusicID() == UNICORN_MUSIC_EXTENDED then
--     --     playingUnicornMusic = false
--     --     Game():GetRoom():PlayMusic()
--     --     --music:VolumeSlide(1, 0.04)
--     --     music:UpdateVolume()
--     -- end
-- end)

end
return UnicornMusicEnabler