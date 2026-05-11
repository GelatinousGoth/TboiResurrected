local function SpecialRockProjectilesEnabler()

local SpikedRock = {}
local mod = IsaacReflourished
local enums = mod.Enums

local spikeSpawnOffset = 14
local spikeSpeed = 7


---@param rock GridEntityRock
function SpikedRock:DestroySpikeRock(rock, type, immediate)
    if rock:GetSprite():GetAnimation() ~= "spiked" then return end
    local randAngle = math.random(45)
    for i = 1, 8, 1 do
        local direction = (i * 45) + randAngle
        local directionVector = Vector.FromAngle(direction)
        local spike = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, enums.Projectiles.SPIKE.Variant, enums.Projectiles.SPIKE.SubType, rock.Position + directionVector:Resized(spikeSpawnOffset), directionVector:Resized(spikeSpeed), nil)
        if spike then
            local sprite = spike:GetSprite()
            sprite.Offset = Vector(0, 2)
            spike.SpriteRotation = direction
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, SpikedRock.DestroySpikeRock, GridEntityType.GRID_ROCK_SPIKED)


---@param tear EntityProjectile
function SpikedRock:SpikeProjInit(tear, offset)
    local sprite = tear:GetSprite()
    sprite:Play("Idle", true)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, SpikedRock.SpikeProjInit, enums.Projectiles.SPIKE.Variant)



---@param tear EntityProjectile
function SpikedRock:SpikeProjDie(tear)

    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.SPIKE_POOF.Variant, enums.Effects.SPIKE_POOF.SubType, tear.Position, Vector.Zero, tear)
    SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 0.3, 0, false, 2)

    poof:ToEffect().Rotation = -tear.Velocity:GetAngleDegrees()
    poof:GetSprite().Offset = Vector(0, 2)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, SpikedRock.SpikeProjDie, enums.Projectiles.SPIKE.Variant)

end
return SpecialRockProjectilesEnabler