--[[ Boss Rush ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()
local music = MusicManager()

local BOSSRUSH_PENTAGRAM_ID = 1662

-- Wave Amount
function mod:BossRushWaveAmount()
    if not self:HasConfig("bossrush_pentagram") then return end -- config

    Ambush.SetMaxBossrushWaves(10)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.BossRushWaveAmount)

-- Pentagram Animation
---@param effect EntityEffect
function mod:BossRushPentagram(effect)
    local room = game:GetLevel():GetCurrentRoom()
    local player = game:GetNearestPlayer(effect.Position)
    local distance = (player.Position - effect.Position):Length()

    -- Spawn
    if effect.Variant ~= BOSSRUSH_PENTAGRAM_ID then return end
    if effect:GetData().ec_bossrush_wave == nil then effect:GetData().ec_bossrush_wave = 0 end

    -- Start Event
    if effect:GetSprite():IsFinished("Idle") then
        if distance > 15 then
            -- Particles
            local pos = Vector(effect.Position.X + 30 * math.random() - 15, effect.Position.Y)
            local velocity = Vector(0, -3.5)
            local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, pos, velocity, effect)
            eff:GetSprite().Color = Color(0.5,0,0,1)
        else
            effect:GetSprite():Play("Start")
            music:Fadeout()
            music:PlayJingle(Music.MUSIC_JINGLE_CHALLENGE_ENTRY, 300)
        end
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

        -- Unlock items
        local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
        for i = 1, #items do
            items[i]:GetSprite().Color = Color(1,1,1,1)
            items[i]:ToPickup().Wait = 0

            local pickup = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, items[i].Position, Vector.Zero, items[i])
            pickup:SetColor(Color(1.0, 0.5, 0.5, 1.0, 0.0, 0.0, 0.0), 1, 0, false, false)
        end

        -- Remove marks
        local marks = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.REDEMPTION)
        for i = 1, #marks do marks[i]:Remove() end
    end

    -- Waves
    local wave = Ambush:GetCurrentWave()
    if wave then
        if wave ~= effect:GetData().ec_bossrush_wave and effect:GetData().ec_bossrush_wave <= 10 then
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
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BossRushPentagram, BOSSRUSH_PENTAGRAM_ID)

-- Creates Pentagram
function mod:BossRushSpawnPentagram()
    if not self:HasConfig("bossrush_pentagram") then return end -- config

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSSRUSH then return end

    -- Removes grid around effect
    self:ClearEffectPos(160)

    -- Spawn effect
    local effect = Isaac.Spawn(1000, BOSSRUSH_PENTAGRAM_ID, 0, room:GetCenterPos(), Vector.Zero, nil)
    if not room:IsAmbushDone() then
        effect:GetSprite():Play("Idle")
        local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
        for i = 1, #items do
            -- Item color
            items[i]:GetSprite().Color = Color(0.35, 0.35, 0.35, 1)
            items[i]:ToPickup().Wait = 9999999999999
            -- Mark
            local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.REDEMPTION, 0, items[i].Position, Vector.Zero, items[i])
            eff:ToEffect():FollowParent(items[i])
            eff:GetSprite().Color = Color(1,0,0,1)
        end
    else
        effect:GetData().ec_bossrush_wave = 11
        effect:GetSprite():Play("Finished")
    end
    effect.DepthOffset = -200
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.BossRushSpawnPentagram)

---@param pos Vector
function mod:BossRushReward(_, pos)
    if not self:HasConfig("bossrush_pentagram") then return end -- config

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSSRUSH then return end

    local center = room:GetCenterPos()

    -- Spawn item in the center
    Isaac.CreateTimer(function()
        local closest
        local closestDistance = math.huge

        for _, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            local distance = item.Position:DistanceSquared(pos)
            if distance < closestDistance then
                closest = item
                closestDistance = distance
            end
        end

        if closest then
            closest.Position = center
        end
    end, 1, 1, false)
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.BossRushReward)