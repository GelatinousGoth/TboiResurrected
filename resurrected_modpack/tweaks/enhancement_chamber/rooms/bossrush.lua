--[[ Boss Rush ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local game = Game()
local sound = SFXManager()
local music = MusicManager()
local bossrush_item = false

-- Wave Amount --
function mod:bossrushGameStarted()
    if not config["bossrush"] then return end
    Ambush.SetMaxBossrushWaves(10)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.bossrushGameStarted)

-- Pentagram Animation --
function mod:bossrushPostEffect(effect)
    if not config["bossrush"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    local player = game:GetNearestPlayer(effect.Position)
    local distance = (player.Position - effect.Position):Length()
    -- Spawn --
    if effect:GetData().bossrush_wave == nil then effect:GetData().bossrush_wave = 0 end
    -- Start Event --
    if effect:GetSprite():IsFinished("Idle") and distance < 15 then
        effect:GetSprite():Play("Start")
        music:Fadeout()
        music:PlayJingle(Music.MUSIC_JINGLE_CHALLENGE_ENTRY)
    end
    if effect:GetSprite():IsPlaying("Start") then
        game:ShakeScreen(5)
        local players = Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1)
        if #players == 1 then
            players[1].Position = room:GetCenterPos()
        else
            for i = 1, #players do players[i].Velocity = Vector(0,0) end
        end
    end
    if effect:GetSprite():IsFinished("Start") then
        sound:Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 2, false, 1)
        effect:GetData().bossrush_wave = 1
        effect:GetSprite():Play("Wave" .. effect:GetData().bossrush_wave, true)
        Ambush:StartChallenge()
    end
    -- Waves --
    local wave = Ambush:GetCurrentWave()
    if wave then
        if wave ~= effect:GetData().bossrush_wave and effect:GetData().bossrush_wave <= 10 then
            if bossrush_item then
                bossrush_item = false
                local items = Isaac.FindByType(5, 100, -1)
                for i = 1, #items do
                    local effect = Isaac.Spawn(1000, 15, 0, items[i].Position, Vector(0,0), items[i])
                    effect:SetColor(Color(1.0, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0), 1, 0, false, false)
                end
            end
            sound:Play(SoundEffect.SOUND_SATAN_BLAST, 1, 2, false, 1)
            effect:GetData().bossrush_wave = wave
            effect:GetSprite():Play("Wave" .. effect:GetData().bossrush_wave)
            room:EmitBloodFromWalls(10, 1)
            game:ShakeScreen(20)
        elseif effect:GetData().bossrush_wave > 10 then
            effect:GetSprite():Play("Finished")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.bossrushPostEffect, 1661)

-- Avoids items --
function mod:bossrushPostPickup(pickup)
    if not config["bossrush"] then return end
    if bossrush_item then
        pickup:SetColor(Color(1.0, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0), 1, 0, false, false)
        pickup.Wait = 1
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.bossrushPostPickup, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.bossrushPostPickup, PickupVariant.PICKUP_COLLECTIBLE)

-- Creates Pentagram --
function mod:bossrushPostRoom()
    if not config["bossrush"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if bossrush_item then bossrush_item = false end
    if room:GetType() == RoomType.ROOM_BOSSRUSH then
        -- Removes grid around effect
        mod.clearEffectPos(160)
        -- Spawn effect
        local effect = Isaac.Spawn(1000, 1661, 0, room:GetCenterPos(), Vector(0,0), nil)
        if not room:IsAmbushDone() then
            bossrush_item = true
            effect:GetSprite():Play("Idle")
        else
            effect:GetData().bossrush_wave = 11
            effect:GetSprite():Play("Finished")
        end
        effect.DepthOffset = -200
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.bossrushPostRoom)