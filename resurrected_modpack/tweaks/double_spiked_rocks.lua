local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Double Spiked Rocks", 1)

local modDSR = RegisterMod("Double Spiked Rocks", 1)

-------------------------------------------------------------------------------------------------------------------------------------------
-- Update Enums
-------------------------------------------------------------------------------------------------------------------------------------------
ProjectileVariant.PROJECTILE_SPIKE = Isaac.GetEntityVariantByName("Spike Projectile")
TearVariant.SPIKE = Isaac.GetEntityVariantByName("Spike Tear")
EffectVariant.SPIKE_PARTICLE = Isaac.GetEntityVariantByName("Spike Particle")

-------------------------------------------------------------------------------------------------------------------------------------------
-- Global/Local variables and constants and Getter/Setter
-------------------------------------------------------------------------------------------------------------------------------------------
local game = Game()
local sfxManager = SFXManager()

-- Spike stats
local SPIKE_COUNT_ROCKS = 10
local SPIKE_COUNT_CHEST = 7
local SPIKE_VELOCITY = 9
local SPIKE_DAMAGE = 30
local SPIKE_SIZE = 0.8
-- Coin stats
local COIN_COUNT = 8
local COIN_VELOCITY = 9
local COIN_SIZE = 0.8

-- Game states to lower utilization
local currentRoomChecked = false

-------------------------------------------------------------------------------------------------------------------------------------------
-- Return all gridEntities with the gridEntityType from the current room
----- @Return: KeyTable of (Keys: gridIndices, Values: gridEntities)
-------------------------------------------------------------------------------------------------------------------------------------------
local function getGridEntities(room, gridEntityType)
    room = room or game:GetLevel():GetCurrentRoom()
    gridEntityType = gridEntityType or 0

    local entitys = {}

    for i=1, room:GetGridSize() do
        local entity = room:GetGridEntity(i)
        if entity ~= nil then
            if entity:GetType() == gridEntityType then
                entitys[i] = entity
            end
        end
    end

    return entitys
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Spawn spikeProjectile on position with angleDeg (starting at vector (1, 0), clockwise) and velocity.
-- x-axis goes from left to right, y-axis goes up
-------------------------------------------------------------------------------------------------------------------------------------------
local function spawnSpikeProjectile(position, angleDeg, velocity)
    local direction = Vector(1, 0):Rotated(angleDeg)
    local spikeProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_SPIKE, 0,
        position, velocity * direction, nil):ToProjectile()
    spikeProjectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
    spikeProjectile.Damage = SPIKE_DAMAGE
    local spikeSprite = spikeProjectile:GetSprite()
    spikeSprite.Scale = Vector(COIN_SIZE, COIN_SIZE)
    spikeSprite:Play("Idle")
    spikeSprite.Rotation = angleDeg
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Handles impact for spikeProjectiles. Spawn spikeParticles and sound.
-------------------------------------------------------------------------------------------------------------------------------------------
local function spikeCollision(spikeEntity)
    local poofSprite = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, TearVariant.SPIKE, spikeEntity.Position, Vector(0,0)
        , nil):GetSprite()
    poofSprite.Scale = Vector(SPIKE_SIZE, SPIKE_SIZE)
    poofSprite.Rotation = spikeEntity:GetSprite().Rotation
    poofSprite.PlaybackSpeed = 0.6
    poofSprite:Play("Idle")
    local praticleSprite = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPIKE_PARTICLE, 0, spikeEntity.Position
        , spikeEntity.Velocity:Normalized(), nil):GetSprite()
    poofSprite.Scale = Vector(SPIKE_SIZE, SPIKE_SIZE)
    praticleSprite.PlaybackSpeed = 0.8
    praticleSprite:Play("Gib0" .. tostring(Random() % 9))
    sfxManager:Play(SoundEffect.SOUND_POT_BREAK, 0.3, 2, false, 2)
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Spawn spikeExplosion. Shoot spikeProjectiles (spikeCount in total) in a circle on position.
-------------------------------------------------------------------------------------------------------------------------------------------
local function spikeExplosion(position, spikeCount)
    local spawnAngle = (360/spikeCount)
    for i = 1, spikeCount do
        spawnSpikeProjectile(position, spawnAngle * i, SPIKE_VELOCITY)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Returns if a player holds the flat file trinket
----- @Return: True if player has the flat file effect, False otherwise
-------------------------------------------------------------------------------------------------------------------------------------------
local function hasPlayerFlatFile()
    for playerIndex = 0, (game:GetNumPlayers() - 1) do
        if Isaac.GetPlayer(playerIndex):HasTrinket(TrinketType.TRINKET_FLAT_FILE) then
            return true
        end
    end
    return false
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Marks all spiked rocks in state 4 (unspiked)
-------------------------------------------------------------------------------------------------------------------------------------------
local function markUnspikedSpikedRocks()
    local currentRoom = game:GetLevel():GetCurrentRoom()
    for _, spikedRock in pairs(getGridEntities(currentRoom, GridEntityType.GRID_ROCK_SPIKED)) do
        if (spikedRock.State == 4) then
            spikedRock.VarData = 1 --BUG: Rocks werden direkt resetet beim aufheben der feile
            currentRoomChecked = true
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- ModCallbacks ---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------
-- Spawn spikeExplosion or coinExplosion for every destroyed and unmarked spikeRock or goldRock exactly once.
-- Don't sapwn spikeExplosion if a player holds flatFile.
-------------------------------------------------------------------------------------------------------------------------------------------
function modDSR:onRockDestroy(type, variant, subtype, _, _, _, seed)
    local room = game:GetLevel():GetCurrentRoom()
    local spikedRocks = getGridEntities(room, GridEntityType.GRID_ROCK_SPIKED)

    if not hasPlayerFlatFile() then
        for gridIndex, spikedRock in pairs(spikedRocks) do
            if (spikedRock.State == 2) and (spikedRock.VarData == 0) then
                spikedRock.VarData = 1
                spikeExplosion(room:GetGridPosition(gridIndex), SPIKE_COUNT_ROCKS)
            end
        end
    end

    return {type, variant, subtype, seed}
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Determines if entity collides with something and handels it as a spikeCollision.
-------------------------------------------------------------------------------------------------------------------------------------------
function modDSR:onImpact(entity)
    if entity.Height >= -5 or entity:CollidesWithGrid() then
        spikeCollision(entity)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Determines if the a spikeProjectile or spikeTear has hurt an entity and handels the spikeCollision.
-------------------------------------------------------------------------------------------------------------------------------------------
function modDSR:onDamage(_, _, _, source)
    if source.Type == EntityType.ENTITY_PROJECTILE and source.Variant == ProjectileVariant.PROJECTILE_SPIKE then
        spikeCollision(source.Entity)
    elseif source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.SPIKE then
        spikeCollision(source.Entity)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-- Functions to handle flat file
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
local frameCount = 0
-- Sets currentRoomChecked to false
function modDSR:onRoomChange()
    currentRoomChecked = false
end

-- Marks spiked rocks if player has flat file
function modDSR:onUpdate()
    if not currentRoomChecked then
        if hasPlayerFlatFile() then
            if frameCount == 0 then
                frameCount = game:GetFrameCount()
            elseif (game:GetFrameCount() - frameCount) > 5 then
                currentRoomChecked = true
                markUnspikedSpikedRocks()
            end
        end
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------
-- ModCallbacks ---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
modDSR:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, modDSR.onImpact, ProjectileVariant.PROJECTILE_SPIKE)
modDSR:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, modDSR.onImpact, TearVariant.SPIKE)
modDSR:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, modDSR.onDamage)
modDSR:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, modDSR.onRockDestroy, EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE)
modDSR:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, modDSR.onRoomChange)
modDSR:AddCallback(ModCallbacks.MC_POST_UPDATE, modDSR.onUpdate)
-------------------------------------------------------------------------------------------------------------------------------------------