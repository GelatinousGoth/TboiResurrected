local switch_NormalProgression = {
    [LevelStage.STAGE_NULL] = function (_, stageType) return LevelStage.STAGE1_1, stageType end,
    [LevelStage.STAGE1_1] = function (_, stageType) return LevelStage.STAGE1_2, stageType end,
    [LevelStage.STAGE1_2] = function (_, stageType) return LevelStage.STAGE2_1, stageType end,
    [LevelStage.STAGE2_1] = function (_, stageType) return LevelStage.STAGE2_2, stageType end,
    [LevelStage.STAGE2_2] = function (_, stageType) return LevelStage.STAGE3_1, stageType end,
    [LevelStage.STAGE3_1] = function (_, stageType) return LevelStage.STAGE3_2, stageType end,
    [LevelStage.STAGE3_2] = function (_, stageType) return LevelStage.STAGE4_1, stageType end,
    [LevelStage.STAGE4_1] = function (_, stageType) return LevelStage.STAGE4_2, stageType end,
    [LevelStage.STAGE4_2] = function (_, stageType)
        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            return LevelStage.STAGE4_2, stageType --corpse 2 goes back to corpse 2
        end
        return LevelStage.STAGE5, stageType
    end,
    [LevelStage.STAGE4_3] = function (_, stageType) return LevelStage.STAGE5, stageType end,
    [LevelStage.STAGE5] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE6] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE7] = function (_, stageType) return LevelStage.STAGE7, stageType end,
    [LevelStage.STAGE8] = function (_, stageType) return LevelStage.STAGE8, stageType end,
    default = function (context, stageType)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL, stageType
    end
}


local switch_BackasswardsProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE6 end,
    [LevelStage.STAGE6] = function () return LevelStage.STAGE5 end,
    [LevelStage.STAGE5] = function () return LevelStage.STAGE4_2 end,
    [LevelStage.STAGE4_2] = function () return LevelStage.STAGE4_1 end,
    [LevelStage.STAGE4_1] = function () return LevelStage.STAGE3_2 end,
    [LevelStage.STAGE3_2] = function () return LevelStage.STAGE3_1 end,
    [LevelStage.STAGE3_1] = function () return LevelStage.STAGE2_2 end,
    [LevelStage.STAGE2_2] = function () return LevelStage.STAGE2_1 end,
    [LevelStage.STAGE2_1] = function () return LevelStage.STAGE1_2 end,
    [LevelStage.STAGE1_2] = function () return LevelStage.STAGE1_1 end,
    [LevelStage.STAGE1_1] = function () return LevelStage.STAGE1_1 end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL
    end
}

local switch_AscentProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE3_2 end,
    [LevelStage.STAGE3_2] = function () --Mausoleum 2
        if Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) then
            return LevelStage.STAGE3_1
        else
            return LevelStage.STAGE3_2
        end
    end,
    [LevelStage.STAGE3_1] = function () return LevelStage.STAGE2_2 end,
    [LevelStage.STAGE2_2] = function () return LevelStage.STAGE2_1 end,
    [LevelStage.STAGE2_1] = function () return LevelStage.STAGE1_2 end,
    [LevelStage.STAGE1_2] = function () return LevelStage.STAGE1_1 end,
    [LevelStage.STAGE1_1] = function () return LevelStage.STAGE8 end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage (Ascent)")
        return LevelStage.STAGE_NULL
    end
}

local switch_GreedStageProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE1_GREED end,
    [LevelStage.STAGE1_GREED] = function () return LevelStage.STAGE2_GREED end,
    [LevelStage.STAGE2_GREED] = function () return LevelStage.STAGE3_GREED end,
    [LevelStage.STAGE3_GREED] = function () return LevelStage.STAGE4_GREED end,
    [LevelStage.STAGE4_GREED] = function () return LevelStage.STAGE5_GREED end,
    [LevelStage.STAGE5_GREED] = function () return LevelStage.STAGE6_GREED end,
    [LevelStage.STAGE6_GREED] = function () return LevelStage.STAGE7_GREED end,
    [LevelStage.STAGE7_GREED] = function () return LevelStage.STAGE7_GREED end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage (Greed Mode)")
        return LevelStage.STAGE_NULL
    end
}

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_wotl_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return true
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return persistentData:Unlocked(Achievement.SCARRED_WOMB)
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_repentance_b_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.DROSS)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.ASHPIT)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.GEHENNA)
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_wotl_available_greed(persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return persistentData:Unlocked(Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_GREED then
        return persistentData:Unlocked(Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_GREED then
        return persistentData:Unlocked(Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_GREED then
        return true
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available_greed(persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return persistentData:Unlocked(Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_GREED then
        return persistentData:Unlocked(Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_GREED then
        return persistentData:Unlocked(Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_GREED then
        return persistentData:Unlocked(Achievement.SCARRED_WOMB)
    end

    return false
end

---@param level Level
return function(level)
    local game = Game()
    local stage = level:GetStage()
    local stageType = level:GetStageType()
    local isAltPath = stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
    local IsBackwardsPath = level:IsAscent() or (game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT) and stage == LevelStage.STAGE3_2 and isAltPath)

    if StageAPI and StageAPI.GetCurrentStage() and StageAPI.GetCurrentStage().StageHPNumber and StageAPI.GetCurrentStage().LevelgenStage  then
        stage = StageAPI.GetCurrentStage().StageHPNumber
        isAltPath = (StageAPI.GetCurrentStage().LevelgenStage.StageType == StageType.STAGETYPE_REPENTANCE 
        or StageAPI.GetCurrentStage().LevelgenStage.StageType == StageType.STAGETYPE_REPENTANCE_B)
    end

    local newStage = LevelStage.STAGE_NULL
    local newStageType = StageType.STAGETYPE_ORIGINAL

    if game:IsGreedMode() then

        local getNextStage = switch_GreedStageProgression[stage] or switch_GreedStageProgression.default
        newStage = getNextStage()
        newStageType = StageType.STAGETYPE_ORIGINAL
    elseif IsBackwardsPath then
        -- Maybe add in code to determing the proper stageType including alt path, but not necessary for now
        local getNextStage = switch_AscentProgression[stage] or switch_AscentProgression.default
        newStage = getNextStage()
        newStageType = stageType
        return newStage, newStageType
    else

        local getNextStage = switch_NormalProgression[stage] or switch_NormalProgression.default
        newStage, newStageType = getNextStage(stageType)

        if game.Challenge == Challenge.CHALLENGE_BACKASSWARDS then
            getNextStage = switch_BackasswardsProgression[stage] or switch_BackasswardsProgression.default
            newStage = getNextStage()
        end
    end

    local curses = level:GetCurses()
    local isFirstChapterFloor = stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE4_1

    if ((curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 or game.Challenge == Challenge.CHALLENGE_RED_REDEMPTION) and isFirstChapterFloor then
        newStage = newStage + 1
        if stage == LevelStage.STAGE4_1 then
            newStage = newStage + 1
        end
    end
    if game:IsGreedMode() then
        local seeds = Game():GetSeeds()
        local seed = seeds:GetStageSeed(newStage)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available_greed(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available_greed(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE8 then
        return newStage, newStageType
    end

    local secretPath = game:GetStateFlag(GameStateFlag.STATE_SECRET_PATH) or game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED)

    if level:GetCurrentRoomIndex() == GridRooms.ROOM_SECRET_EXIT_IDX then
        secretPath = true
    end

    if secretPath or ((curses & LevelCurse.CURSE_OF_LABYRINTH) == 0 and (isAltPath and isFirstChapterFloor)) then
        if not isAltPath then -- going from non alt path to alt path
            newStage = math.max(newStage - 1, LevelStage.STAGE1_1)
        end

        local seeds = game:GetSeeds()
        local seed = seeds:GetStageSeed(newStage + 1)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed & 2) == 0 and is_repentance_b_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_REPENTANCE_B
        else
            newStageType = StageType.STAGETYPE_REPENTANCE
        end
    else
        if isAltPath and not IsBackwardsPath then -- moving from alt path to non alt path
            newStage = newStage + 1
        end

        local seeds = game:GetSeeds()
        local seed = seeds:GetStageSeed(newStage)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        if seeds:HasSeedEffect(SeedEffect.SEED_G_FUEL) and (newStage == LevelStage.STAGE2_1 or newStage == LevelStage.STAGE2_2) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end
    end

    if newStage < LevelStage.STAGE5 then
        Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)
        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE5 then
        local room = game:GetRoom()
        if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_BLUE_WOOM_IDX then
            return LevelStage.STAGE4_3, StageType.STAGETYPE_ORIGINAL
        end

        if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_THE_VOID_IDX then
            return LevelStage.STAGE7, StageType.STAGETYPE_ORIGINAL
        end

        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            return LevelStage.STAGE4_2, StageType.STAGETYPE_REPENTANCE
        end

        newStageType = StageType.STAGETYPE_ORIGINAL
        if (not game:GetStateFlag(GameStateFlag.STATE_HEAVEN_PATH) and game.Challenge ~= Challenge.CHALLENGE_BACKASSWARDS) then
            newStageType = StageType.STAGETYPE_WOTL
        end

        return LevelStage.STAGE5, newStageType
    end

    if newStage == LevelStage.STAGE6 then
        return LevelStage.STAGE6, level:GetStageType()
    end

    return newStage, newStageType
end