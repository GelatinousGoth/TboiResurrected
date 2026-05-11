local function FloorTrapdoorsEnabler()

local mod = IsaacReflourished
mod.FloorTrapdoors = {}
local FloorTrapdoors = mod.FloorTrapdoors
local utility = IsaacReflourished.Utility

local FLOOR_TO_GFX = {
    BASEMENT = "trapdoor_basement.png",
    CELLAR = "trapdoor_cellar.png",
    BURNING_BASEMENT = "trapdoor_burningbasement.png",
    CAVES = "trapdoor_caves.png",
    CATACOMBS = "trapdoor_catacombs.png",
    FLOODED_CAVES = "trapdoor_floodedcaves.png",
    DEPTHS = "trapdoor_depths.png",
    NECROPOLIS = "trapdoor_necropolis.png",
    DANK_DEPTHS = "trapdoor_dankdepths.png",
    UTERO = "trapdoor_utero.png",
    SCARRED_WOMB = "trapdoor_scarredwomb.png",
    SHEOL = "trapdoor_sheol.png",
    SHOP = "trapdoor_shop.png"
}

local FLOOR_TO_ANM2 = {
    BASEMENT = "Door_11_TrapDoor.anm2",
    CAVES = "trapdoor_caves.anm2",
    DEPTHS = "trapdoor_depths.anm2",
    WOMB = "trapdoor_wombhole.anm2",
    SHEOL = "trapdoor_sheol.anm2",
}

---@param stageID LevelStage
---@param stageType StageType
function FloorTrapdoors:GetFloorGFX(stageID, stageType)
    if stageType == StageType.STAGETYPE_REPENTANCE_B or stageType == StageType.STAGETYPE_REPENTANCE then return nil end

    if Game():IsGreedMode() then
        return FloorTrapdoors:GetGreedFloorGFX(stageID, stageType)
    end

    if stageID == LevelStage.STAGE1_1 or stageID == LevelStage.STAGE1_2 then
        if stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.CELLAR
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.BURNING_BASEMENT
        end
    elseif stageID == LevelStage.STAGE2_1 or stageID == LevelStage.STAGE2_2 then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.CAVES, FLOOR_TO_ANM2.CAVES
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.CATACOMBS, FLOOR_TO_ANM2.CAVES
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.FLOODED_CAVES, FLOOR_TO_ANM2.CAVES
        end
    elseif stageID == LevelStage.STAGE3_1 or stageID == LevelStage.STAGE3_2 then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.DEPTHS, FLOOR_TO_ANM2.DEPTHS
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.NECROPOLIS, FLOOR_TO_ANM2.DEPTHS
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.DANK_DEPTHS, FLOOR_TO_ANM2.DEPTHS
        end
    elseif stageID == LevelStage.STAGE4_1 or stageID == LevelStage.STAGE4_2 then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.WOMB
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.UTERO
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.SCARRED_WOMB
        end
    elseif stageID == LevelStage.STAGE5 then
        return nil, FLOOR_TO_ANM2.SHEOL
    end
end

---@param stageID LevelStage
---@param stageType StageType
function FloorTrapdoors:GetGreedFloorGFX(stageID, stageType)
    if stageType == StageType.STAGETYPE_REPENTANCE_B or stageType == StageType.STAGETYPE_REPENTANCE then return nil end
    
    if stageID == LevelStage.STAGE1_GREED then
        if stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.CELLAR
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.BURNING_BASEMENT
        end
    elseif stageID == LevelStage.STAGE2_GREED then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.CAVES, FLOOR_TO_ANM2.CAVES
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.CATACOMBS, FLOOR_TO_ANM2.CAVES
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.FLOODED_CAVES, FLOOR_TO_ANM2.CAVES
        end
    elseif stageID == LevelStage.STAGE3_GREED then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.DEPTHS, FLOOR_TO_ANM2.DEPTHS
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.NECROPOLIS, FLOOR_TO_ANM2.DEPTHS
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.DANK_DEPTHS, FLOOR_TO_ANM2.DEPTHS
        end
    elseif stageID == LevelStage.STAGE4_GREED then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            return FLOOR_TO_GFX.WOMB
        elseif stageType == StageType.STAGETYPE_WOTL then
            return FLOOR_TO_GFX.UTERO
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            return FLOOR_TO_GFX.SCARRED_WOMB
        end
    elseif stageID == LevelStage.STAGE5_GREED then
        return nil, FLOOR_TO_ANM2.SHEOL
    elseif stageID == LevelStage.STAGE6_GREED or stageID == LevelStage.STAGE7_GREED then
        return FLOOR_TO_GFX.SHOP, FLOOR_TO_ANM2.BASEMENT
    end
end



---@param trapdoor GridEntityTrapDoor
function FloorTrapdoors:TrapdoorSpawn(trapdoor)

    if trapdoor:GetVariant() == 1 then return end --Exclude void trapdoors
    local level = Game():GetLevel()
    if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_SECRET_EXIT_IDX then return end
    if StageAPI and StageAPI:InNewStage() then return end -- StageAPI floors don't follow vanilla next stage algorithm
    local nextStage, nextStageType = utility:GetNextStage(level)

    local gfx, anm2 = FloorTrapdoors:GetFloorGFX(nextStage, nextStageType)
    local sprite = trapdoor:GetSprite()

    if anm2 then
        sprite:Load("gfx/" .. anm2, true)
    end
    if gfx then
        for layer = 0, sprite:GetLayerCount() do
            sprite:ReplaceSpritesheet(layer, "gfx/grid/" .. gfx)
        end
        sprite:LoadGraphics()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, FloorTrapdoors.TrapdoorSpawn, GridEntityType.GRID_TRAPDOOR)


function FloorTrapdoors:PostNewRoom()
    local level = Game():GetLevel()
    if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_SECRET_EXIT_IDX then return end
    if StageAPI and StageAPI:InNewStage() then return end

    local room = Game():GetRoom()

    for i = 0, room:GetGridSize() do
        local grid = room:GetGridEntity(i)

        if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR and grid:GetVariant() ~= 1 then
            local trapdoor = grid:ToTrapDoor()
            local nextStage, nextStageType = utility:GetNextStage(level)

            local gfx, anm2 = FloorTrapdoors:GetFloorGFX(nextStage, nextStageType)
            local sprite = trapdoor:GetSprite()

            if anm2 then
                sprite:Load("gfx/" .. anm2, true)
            end
            if gfx then
                for layer = 0, sprite:GetLayerCount() do
                    sprite:ReplaceSpritesheet(layer, "gfx/grid/" .. gfx)
                end
                sprite:LoadGraphics()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FloorTrapdoors.PostNewRoom)

end
return FloorTrapdoorsEnabler