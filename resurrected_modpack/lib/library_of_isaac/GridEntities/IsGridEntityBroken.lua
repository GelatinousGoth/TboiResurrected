local GridEntityTypeToBrokenState = {
    [GridEntityType.GRID_ROCK] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCKT] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCK_BOMB] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCK_ALT] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_SPIDERWEB] = TSIL.Enums.SpiderWebState.BROKEN,
    [GridEntityType.GRID_LOCK] = TSIL.Enums.LockState.UNLOCKED,
    [GridEntityType.GRID_TNT] = TSIL.Enums.TNTState.EXPLODED,
    [GridEntityType.GRID_POOP] = TSIL.Enums.PoopState.DESTROYED,
    [GridEntityType.GRID_ROCK_SS] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCK_SPIKED] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCK_ALT2] = TSIL.Enums.RockState.BROKEN,
    [GridEntityType.GRID_ROCK_GOLD] = TSIL.Enums.RockState.BROKEN
}

function TSIL.GridEntities.IsGridEntityBroken(gridEntity)
    local gridEntityType = gridEntity:GetType()
    local brokenState = GridEntityTypeToBrokenState[gridEntityType]

    return gridEntity.State == brokenState
end