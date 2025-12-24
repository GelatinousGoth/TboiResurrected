local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Unused Dogma Attacks", 1, true)

local game = Game()
local rng = RNG()

rng:SetSeed(Random(), 1)

-- =====================
-- SETTINGS
-- =====================
local BABY_COOLDOWN_FAST = 110
local BURST_49_COUNT = 3
local BURST_DELAY = 4

-- =====================
-- UTILS
-- =====================
local function IsHardMode()
    local d = game.Difficulty
    return d == Difficulty.DIFFICULTY_HARD
        or d == Difficulty.DIFFICULTY_GREEDIER
end

local function BlackHoleExists()
    return #Isaac.FindByType(1000, 171, 0) > 0
end

local function KillAllAngelBabies()
    for _, baby in ipairs(Isaac.FindByType(950, 10, 0)) do
        baby:Kill()
    end
end

-- =====================
-- PHASE 1: TV
-- =====================
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, tv)
    if tv.Type ~= 950 or tv.Variant ~= 1 then return end
    if not IsHardMode() then return end

    -- Stop everything once phase 2 exists
    if #Isaac.FindByType(950, 2, 0) > 0 then
        KillAllAngelBabies()
        return
    end

    local data = tv:GetData()
    local center = game:GetRoom():GetCenterPos()

    -- ---------------------
    -- 49% BURST (ONCE)
    -- ---------------------
    if not data.Burst49Triggered
        and tv.HitPoints <= tv.MaxHitPoints * 0.49
    then
        data.Burst49Triggered = true
        data.BurstLeft = BURST_49_COUNT
        data.BurstTimer = 0

        -- Fixed spawn offsets near center
        data.BurstOffsets = {
            Vector(-40, 0),
            Vector(40, 0),
            Vector(0, 40),
        }
    end

    if data.BurstLeft and data.BurstLeft > 0 then
        data.BurstTimer = data.BurstTimer - 1

        if data.BurstTimer <= 0 then
            data.BurstTimer = BURST_DELAY
            data.BurstLeft = data.BurstLeft - 1

            local offset = data.BurstOffsets[data.BurstLeft + 1]

            Isaac.Spawn(
                950, 10, 0,
                center + offset,
                Vector.Zero,
                tv
            ):ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    -- ---------------------
    -- CONTINUOUS ≤40%
    -- ---------------------
    if tv.HitPoints > tv.MaxHitPoints * 0.4 then return end

    data.BabyTimer = (data.BabyTimer or BABY_COOLDOWN_FAST) - 1

    if data.BabyTimer <= 0 then
        data.BabyTimer = BABY_COOLDOWN_FAST + rng:RandomInt(40)

        Isaac.Spawn(
            950, 10, 0,
            center + Vector(rng:RandomInt(60)-30, rng:RandomInt(60)-30),
            Vector.Zero,
            tv
        ):ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
end)

-- =====================
-- CLEANUP ON TV DEATH
-- =====================
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Type == 950 and npc.Variant == 1 then
        KillAllAngelBabies()
    end
end)

-- =====================
-- PHASE 2: BODY
-- =====================
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, dogma)
    if dogma.Type ~= 950 or dogma.Variant ~= 2 then return end
    if not IsHardMode() then return end

    local data = dogma:GetData()

    -- Trigger black hole at 50%
    if not data.BlackHoleTriggered
        and dogma.HitPoints <= dogma.MaxHitPoints * 0.5
    then
        data.BlackHoleTriggered = true
        data.BlackHoleActive = true

        -- FULL HARD FREEZE
        dogma.State = 0
        dogma.Velocity = Vector.Zero
        dogma.ProjectileCooldown = 999
        dogma.CollisionDamage = 0

        dogma:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        dogma:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        dogma:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        dogma.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        dogma.Visible = false

        Isaac.Spawn(
            1000, 171, 0,
            game:GetRoom():GetCenterPos(),
            Vector.Zero,
            dogma
        ):ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    -- Lock Dogma while black hole exists
    if data.BlackHoleActive then
        dogma.Velocity = Vector.Zero
        dogma.State = 0
        dogma.ProjectileCooldown = 999
        dogma.CollisionDamage = 0

        if not BlackHoleExists() then
            data.BlackHoleActive = false

            -- RESTORE
            dogma:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
            dogma:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
            dogma:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

            dogma.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            dogma.Visible = true
            dogma.CollisionDamage = 1
            dogma.ProjectileCooldown = 0
        end
    end
end)

-- if you made it till here, you may have noticed it.
-- i used chatgpt to make this code.
-- im sorry but i cant code AT ALL :<
-- and i cant just learn it overnight for a mod that i want to make right now
-- at least i wrote this message myself :')