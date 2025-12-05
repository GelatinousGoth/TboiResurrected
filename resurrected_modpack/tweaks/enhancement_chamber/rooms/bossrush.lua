--[[ Boss Rush ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()
local music = MusicManager()
local bossrush_item = false

-- Wave Amount
function mod:bossrushGameStarted()
    Ambush.SetMaxBossrushWaves(10)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.bossrushGameStarted)

-- Pentagram Animation
---@param effect EntityEffect
function mod:bossrushPostEffect(effect)
    local room = game:GetLevel():GetCurrentRoom()
    local player = game:GetNearestPlayer(effect.Position)
    local distance = (player.Position - effect.Position):Length()

    -- Spawn
    if effect.Variant ~= 1661 then return end
    if effect:GetData().ec_bossrush_wave == nil then effect:GetData().ec_bossrush_wave = 0 end

    -- Start Event
    if effect:GetSprite():IsFinished("Idle") and distance < 15 then
        effect:GetSprite():Play("Start")
        music:Fadeout()
        music:PlayJingle(Music.MUSIC_JINGLE_CHALLENGE_ENTRY, 300)
    end

    -- Prevents players from getting away
    if effect:GetSprite():IsPlaying("Start") then
        game:ShakeScreen(5)
        local players = Isaac.FindByType(EntityType.ENTITY_PLAYER)
        if #players == 1 then
            players[1].Position = room:GetCenterPos()
        else
            for i = 1, #players do players[i].Velocity = Vector.Zero end
        end
    end

    -- Finished start animation
    if effect:GetSprite():IsFinished("Start") then
        sound:Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 2, false, 1)
        effect:GetData().ec_bossrush_wave = 1
        effect:GetSprite():Play("Wave" .. effect:GetData().ec_bossrush_wave, true)
        Ambush:StartChallenge()
    end

    -- Waves --
    local wave = Ambush:GetCurrentWave()
    if wave then
        if wave ~= effect:GetData().ec_bossrush_wave and effect:GetData().ec_bossrush_wave <= 10 then

            if bossrush_item then
                bossrush_item = false
                local items = Isaac.FindByType(5, 100)
                for i = 1, #items do
                    local pickup = Isaac.Spawn(1000, 15, 0, items[i].Position, Vector.Zero, items[i])
                    pickup:SetColor(Color(1.0, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0), 1, 0, false, false)
                end
            end

            sound:Play(SoundEffect.SOUND_SATAN_BLAST, 1, 2, false, 1)
            effect:GetData().ec_bossrush_wave = wave
            effect:GetSprite():Play("Wave" .. effect:GetData().ec_bossrush_wave)
            room:EmitBloodFromWalls(10, 1)
            game:ShakeScreen(20)
        elseif effect:GetData().ec_bossrush_wave > 10 then
            effect:GetSprite():Play("Finished")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.bossrushPostEffect, 1661)

-- Avoids items
---@param pickup EntityPickup
function mod:bossrushPostPickup(pickup)
    if bossrush_item then
        pickup:SetColor(Color(1.0, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0), 1, 0, false, false)
        pickup.Wait = 1
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.bossrushPostPickup, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.bossrushPostPickup, PickupVariant.PICKUP_COLLECTIBLE)

-- Creates Pentagram
function mod:bossrushPostRoom()
    local room = game:GetLevel():GetCurrentRoom()

    -- Item effect
    if bossrush_item then bossrush_item = false end

    -- Checks boss rush
    if room:GetType() == RoomType.ROOM_BOSSRUSH then

        -- Removes grid around effect
        self.clearEffectPos(160)
        -- Spawn effect
        local effect = Isaac.Spawn(1000, 1661, 0, room:GetCenterPos(), Vector.Zero, nil)
        if not room:IsAmbushDone() then
            bossrush_item = true
            effect:GetSprite():Play("Idle")
        else
            effect:GetData().ec_bossrush_wave = 11
            effect:GetSprite():Play("Finished")
        end
        effect.DepthOffset = -200
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.bossrushPostRoom)