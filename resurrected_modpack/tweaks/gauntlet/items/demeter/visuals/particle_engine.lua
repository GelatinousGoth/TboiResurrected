--To avoid potential lag with other mods, particles are not effect entities, and simply have logic within Lua

local game = Game()

---@class ParticleInstance
---@field Type Season
---@field Variant integer
---@field Position Vector
---@field Speed Vector
---@field AccelerationX number
---@field Size number
---@field TimeLeft integer
---@field StartingTime integer

local particleSpawnRoutines = {
    [TheGauntlet.Items.Ceres.Season.WINTER] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.snowflake_spawn"),
    [TheGauntlet.Items.Ceres.Season.SPRING] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_spawn"),
    [TheGauntlet.Items.Ceres.Season.AUTUMN] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_spawn"),
}

local particleUpdateRoutines = {
    [TheGauntlet.Items.Ceres.Season.WINTER] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.snowflake_update"),
    [TheGauntlet.Items.Ceres.Season.SPRING] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_update"),
    [TheGauntlet.Items.Ceres.Season.AUTUMN] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_update"),
}

local particleRenderRoutines = {
    [TheGauntlet.Items.Ceres.Season.WINTER] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.snowflake_render"),
    [TheGauntlet.Items.Ceres.Season.SPRING] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_render"),
    [TheGauntlet.Items.Ceres.Season.AUTUMN] = include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.falling_leaf_render"),
}

local thinRoomShapes = {
    [RoomShape.ROOMSHAPE_IV] = true,
    [RoomShape.ROOMSHAPE_IIV] = true,
}

local wideRoomShapes = {
    [RoomShape.ROOMSHAPE_2x1] = true,
    [RoomShape.ROOMSHAPE_IIH] = true,
    [RoomShape.ROOMSHAPE_2x2] = true,
    [RoomShape.ROOMSHAPE_LTL] = true,
    [RoomShape.ROOMSHAPE_LTR] = true,
    [RoomShape.ROOMSHAPE_LBL] = true,
    [RoomShape.ROOMSHAPE_LBR] = true,
}

---@type ParticleInstance[]
local particleInstances = {}

local particleGeneralRng = RNG()
local timeUntilNextParticle = 0

TheGauntlet:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function (_)
    particleInstances = {}
end)

TheGauntlet:AddCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, function (_)
    local season = TheGauntlet.Items.Ceres.GetSeason()

    if season == TheGauntlet.Items.Ceres.Season.NO_SEASON then return end
    if season == TheGauntlet.Items.Ceres.Season.SUMMER then return end

    if TheGauntlet.Settings.EnableCeresParticles() == false then
        particleInstances = {}
        return
    end

    local room = game:GetRoom()

    local isPaused = game:IsPaused()

    local topLeft = room:GetTopLeftPos()
    local bottomRight = room:GetBottomRightPos()
    local renderOffset = room:GetRenderScrollOffset()

    timeUntilNextParticle = timeUntilNextParticle - 1

    if not isPaused and timeUntilNextParticle <= 0 then
        local roomShape = room:GetRoomShape()
        if thinRoomShapes[roomShape] then
            timeUntilNextParticle = particleGeneralRng:RandomInt(15, 30)
        elseif wideRoomShapes[roomShape] then
            timeUntilNextParticle = particleGeneralRng:RandomInt(2, 5)
        else
            timeUntilNextParticle = particleGeneralRng:RandomInt(5, 15)
        end

        table.insert(particleInstances, particleSpawnRoutines[season](topLeft, bottomRight)
    )
    end

    for i = #particleInstances, 1, -1 do
        local instance = particleInstances[i]
        if not isPaused then
            particleUpdateRoutines[instance.Type](instance)

            instance.TimeLeft = instance.TimeLeft - 1
            if instance.TimeLeft < 0 then
                table.remove(particleInstances, i)
            end
        end
        
        particleRenderRoutines[instance.Type](instance, renderOffset)
    end
end)