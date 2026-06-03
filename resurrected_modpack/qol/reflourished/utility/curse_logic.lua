local function CurseLogicEnabler()
local CurseLogic = {}
IsaacReflourished.CurseLogic = CurseLogic

local game = Game()


-----------------------------
--- Helper functions
-----------------------------

--- Returns a random value from a weighted list of possibilities.
--- Each choice must be given as a pair of chance and value.
--- 
--- `{chance = x, value = y}`
---@generic T any
---@param seedOrRNG integer | RNG
---@param possibles {chance : number, value : T}[]
---@return T
local function TSILGetRandomElementFromWeightedList(seedOrRNG, possibles)
	---@type RNG
	local rng

	if type(seedOrRNG) == "number" then
		rng = RNG()
		rng:SetSeed(seedOrRNG, 35)
	else
		---@cast seedOrRNG RNG
		rng = seedOrRNG
	end

	local totalChance = 0
	for _, possibility in ipairs(possibles) do
		totalChance = totalChance + possibility.chance
	end

	local randomChance = rng:RandomFloat() * totalChance
	local cumulativeChance = 0
	local result = nil

	for _, possibility in ipairs(possibles) do
		cumulativeChance = cumulativeChance + possibility.chance

		if cumulativeChance > randomChance then
			result = possibility.value
			break
		end
	end

	return result
end


-----------------------------
-- Curse legality rules
-----------------------------

local function CanHaveCurseOfLabyrinth(stage)
    if stage < LevelStage.STAGE1_1 or stage > LevelStage.STAGE4_2 then
        return false
    end

    if stage % 2 == 0 then
        return false
    end

    if game.Challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if game:IsGreedMode() then
        return false
    end

    return true
end

local function CanHaveCurseOfLost()
    if game.Challenge == Challenge.CHALLENGE_RED_REDEMPTION then
        return false
    end

    if game:IsGreedMode() then
        return false
    end

    return true
end

local function CanHaveCurseOfMaze()
    return not game:IsGreedMode()
end

local function CanHaveCurseOfBlind()
    -- Daily runs block Blind but its modded so yea
    return true
end

local function GetCurseOfLabyrinthWeight(_, _, stage)
    if CanHaveCurseOfLabyrinth(stage) then
        return 1
    end

    return 0
end
IsaacReflourished:AddCallback(
    CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
    GetCurseOfLabyrinthWeight,
    LevelCurse.CURSE_OF_LABYRINTH
)

local function GetCurseOfLostWeight()
    if CanHaveCurseOfLost() then
        return 1
    end

    return 0
end
IsaacReflourished:AddCallback(
    CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
    GetCurseOfLostWeight,
    LevelCurse.CURSE_OF_THE_LOST
)

local function GetCurseOfMazeWeight()
    if CanHaveCurseOfMaze() then
        return 1
    end

    return 0
end
IsaacReflourished:AddCallback(
    CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
    GetCurseOfMazeWeight,
    LevelCurse.CURSE_OF_MAZE
)

local function GetCurseOfBlindWeight()
    if CanHaveCurseOfBlind() then
        return 1
    end

    return 0
end
IsaacReflourished:AddCallback(
    CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
    GetCurseOfBlindWeight,
    LevelCurse.CURSE_OF_BLIND
)

-----------------------------
-- Curse chance calculation
-----------------------------

---@param stage LevelStage
---@return number | true
function CurseLogic:EvaluateCurseChance(stage)
    local preReturn = Isaac.RunCallback(CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_CHANCE, stage)
    if type(preReturn) == "number" then
        return preReturn
    elseif preReturn == true then
        return true
    elseif preReturn == false then
        return 0
    end

    local gameData = Isaac.GetPersistentGameData()
    stage = stage or game:GetLevel():GetStage()
    local isHardMode = (game.Difficulty == Difficulty.DIFFICULTY_HARD)
    local chance = isHardMode and 40 or 80


    if gameData:Unlocked(Achievement.WOMB) then
        chance = isHardMode and 20 or 30
    end

    local everythingIsTerrible = gameData:Unlocked(Achievement.EVERYTHING_IS_TERRIBLE)

    if everythingIsTerrible then
        chance = isHardMode and 6 or 10
    end

    if gameData:IsBossKilled(BossType.ISAAC) then
        chance = isHardMode and 3 or 5
    end

    if stage == LevelStage.STAGE1_1 and not everythingIsTerrible then
        chance = 0
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        chance = 0
    end

    local callbacks = Isaac.GetCallbacks(CursedTrapdoorsMod.Enums.CustomCallback.POST_GET_CURSE_CHANCE)
    for _, callback in ipairs(callbacks) do
        local postReturn = callback.Function(callback.Mod, chance, stage)

        if type(postReturn) == "number" then
            chance = postReturn
        end
    end

    return chance
end

-----------------------------
-- Global curse blocking
-----------------------------

function CurseLogic:AreCursesBlocked(stage)
    stage = stage or game:GetLevel():GetStage()
    -- Chest / Dark Room
    if stage == LevelStage.STAGE8 then
        return true
    end

    -- Backwards path (Ascent)
    if game:GetLevel():IsAscent() then
        return true
    end

    -- Black Candle
    -- if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
    --     return true
    -- end

    return false
end

-----------------------------
-- Curse picking
-----------------------------

---@param rng RNG
---@param stage LevelStage
function CurseLogic:PickCurseVanilla(rng, stage)
    local roll = rng:RandomInt(6)
    stage = stage or game:GetLevel():GetStage()

    if roll == 0 and CanHaveCurseOfLabyrinth(stage) then
        return LevelCurse.CURSE_OF_LABYRINTH
    elseif roll == 1 and CanHaveCurseOfLost() then
        return LevelCurse.CURSE_OF_THE_LOST
    elseif roll == 2 then
        return LevelCurse.CURSE_OF_DARKNESS
    elseif roll == 3 then
        return LevelCurse.CURSE_OF_THE_UNKNOWN
    elseif roll == 4 and CanHaveCurseOfMaze() then
        return LevelCurse.CURSE_OF_MAZE
    elseif roll == 5 and CanHaveCurseOfBlind() then
        return LevelCurse.CURSE_OF_BLIND
    end

    return 0
end

---@param stage LevelStage
function CurseLogic:GetAccursedPossibleCurses(stage)
    ---@type {chance : number, value : LevelCurse}[]
    local curseWeights = {}

    for curse, _ in pairs(CursedTrapdoorsMod.CurseDefinitions) do
        local weight = Isaac.RunCallbackWithParam(
            CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
            curse,
            curse,
            stage
        )

        if type(weight) ~= "number" then
            weight = 1
        end

        local callbacks = Isaac.GetCallbacks(CursedTrapdoorsMod.Enums.CustomCallback.POST_GET_CURSE_WEIGHT)
        for _, callback in ipairs(callbacks) do
            local param = callback.Param
            if param == nil or param == -1 or param == curse then
                local ret = callback.Function(callback.Mod, curse, weight, stage)
                if type(ret) == "number" then
                    weight = ret
                end
            end
        end

        if weight > 0 then
            curseWeights[#curseWeights + 1] = {
                value = curse,
                chance = weight
            }
        end
    end

    return curseWeights
end

---@param stage LevelStage
---@return table<LevelCurse, boolean>, integer
function CurseLogic:GetVanillaPossibleCurses(stage)
    local possibleCurses = {
        [LevelCurse.CURSE_OF_DARKNESS] = true,
        [LevelCurse.CURSE_OF_THE_UNKNOWN] = true
    }
    local numCurses = 2

    if CanHaveCurseOfLabyrinth(stage) then
        possibleCurses[LevelCurse.CURSE_OF_LABYRINTH] = true
        numCurses = numCurses + 1
    end

    if CanHaveCurseOfLost() then
        possibleCurses[LevelCurse.CURSE_OF_THE_LOST] = true
        numCurses = numCurses + 1
    end

    if CanHaveCurseOfMaze() then
        possibleCurses[LevelCurse.CURSE_OF_MAZE] = true
        numCurses = numCurses + 1
    end

    if CanHaveCurseOfBlind() then
        possibleCurses[LevelCurse.CURSE_OF_BLIND] = true
        numCurses = numCurses + 1
    end

    return possibleCurses, numCurses
end

---@param rng RNG
---@param stage LevelStage
---@return LevelCurse
function CurseLogic:PickCurse(rng, stage)
    local accursedCurses = CurseLogic:GetAccursedPossibleCurses(stage)
    local vanillaCurses, numVanillaCurses = CurseLogic:GetVanillaPossibleCurses(stage)

    local numVanillaMatches = 0
    local hasCustomCurses = false

    for _, curseWeight in ipairs(accursedCurses) do
        if vanillaCurses[curseWeight.value] and curseWeight.chance == 1 then
            numVanillaMatches = numVanillaMatches + 1
        else
            hasCustomCurses = true
            break
        end
    end

    if hasCustomCurses or numVanillaCurses ~= numVanillaCurses then
        if #accursedCurses == 0 then
            return LevelCurse.CURSE_NONE
        end

        return TSILGetRandomElementFromWeightedList(rng, accursedCurses)
    else
        return CurseLogic:PickCurseVanilla(rng, stage)
    end
end

-----------------------------
-- Post-processing
-----------------------------

function CurseLogic:PostProcessCurses(curses, stage)
    stage = stage or game:GetLevel():GetStage()

    if game.Challenge ~= Challenge.CHALLENGE_NULL then
        if not CanHaveCurseOfLabyrinth(stage) then
            curses = curses & ~LevelCurse.CURSE_OF_LABYRINTH
        end
    end

    -- Blue Womb or Victory Lap > 2 removes Darkness
    if stage == LevelStage.STAGE4_3 or game:GetVictoryLap() > 2 then
        curses = curses & ~LevelCurse.CURSE_OF_DARKNESS
    end

    -- Process any other kind of challenge curse restriction 
    local challengeParams = Game():GetChallengeParams()
    curses = curses | challengeParams:GetCurse()
    curses = curses & ~challengeParams:GetCurseFilter()

    return curses
end

-----------------------------
-- Main entry
-----------------------------

---@param rng RNG?
---@param isVoid boolean?
function CurseLogic:GetNextCurse(rng, isVoid)
    local nextStage, stageType = IsaacReflourished.Utility:GetNextStage(Game():GetLevel())
    if isVoid then
        nextStage = LevelStage.STAGE7
        stageType = StageType.STAGETYPE_ORIGINAL
    end

    if not rng then
        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            rng = RNG(Game():GetSeeds():GetStageSeed(nextStage + 1), 35)
        else
            rng = RNG(Game():GetSeeds():GetStageSeed(nextStage), 35)
        end
        rng:Next()
        rng:Next()
    end

    local curses = 0
    local chance = CurseLogic:EvaluateCurseChance(nextStage)

    if chance == true then
        curses = curses | CurseLogic:PickCurse(rng, nextStage)
    elseif chance > 0 and not CurseLogic:AreCursesBlocked(nextStage) then
        if rng:RandomInt(chance) == 0 then
            curses = curses | CurseLogic:PickCurse(rng, nextStage)
        end
    end

    curses = CurseLogic:PostProcessCurses(curses, nextStage)

    return curses
end

return CurseLogic

end
return CurseLogicEnabler