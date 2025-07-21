local TR_Manager = require("resurrected_modpack.manager")
ExtraScaredHearts = TR_Manager:RegisterMod("Extra-Scared Hearts", 1)

--MAIN FUNCTIONS--

--#region Extra Hearts Data

---@enum ScaredHeartType
local ScaredHeartType = {
    SWEAT = 1,
    FLY = 2,
    VOID = 3,
    SPIDER = 4,
}

local SCARED_HEARTS_ANIMATION_IDENTIFIERS = {
    [ScaredHeartType.SWEAT] = "sweat",
    [ScaredHeartType.FLY] = "fly",
    [ScaredHeartType.VOID] = "void",
    [ScaredHeartType.SPIDER] = "spider",
}

local DEFAULT_WEIGHTS = {
    [ScaredHeartType.SWEAT] = 1.0,
    [ScaredHeartType.FLY] = 1.0,
    [ScaredHeartType.VOID] = 0.1,
    [ScaredHeartType.SPIDER] = 1.0,
}

--#endregion

--#region Pool

local Pool = WeightedOutcomePicker()

Pool:AddOutcomeFloat(ScaredHeartType.SWEAT, DEFAULT_WEIGHTS[ScaredHeartType.SWEAT])
Pool:AddOutcomeFloat(ScaredHeartType.FLY, DEFAULT_WEIGHTS[ScaredHeartType.FLY])
Pool:AddOutcomeFloat(ScaredHeartType.VOID, DEFAULT_WEIGHTS[ScaredHeartType.VOID])
Pool:AddOutcomeFloat(ScaredHeartType.SPIDER, DEFAULT_WEIGHTS[ScaredHeartType.SPIDER])

--#endregion

---@param pickup EntityPickup
function ExtraScaredHearts:ChangeAnm(pickup)
    if pickup.SubType ~= HeartSubType.HEART_SCARED then
        return
    end

    local anm2Path = ExtraScaredHearts:GetAnmFilepath(pickup.InitSeed)
    local sprite = pickup:GetSprite();
    local animationToPlay = sprite:GetAnimation();
    sprite:Load(anm2Path, true);
    --play the animation that the scared heart was already playing
    sprite:Play(animationToPlay);
end

--/MAIN FUNCTIONS--

--HELPER FUNCTIONS--

--Returns if the player is in the Void or not
local function in_void()
    return Game():GetLevel():GetAbsoluteStage() == LevelStage.STAGE7;
end

---@param scaredHeartType ScaredHeartType
---@return string
local function build_scared_heart_path(scaredHeartType)
    local animationId = SCARED_HEARTS_ANIMATION_IDENTIFIERS[scaredHeartType];
    if not animationId then
        error("Invalid scared heart type: " .. tostring(scaredHeartType));
    end

    return "extrascaredhearts/esh_" .. animationId .. ".anm2";
end

---@param seed integer
---@return string
function ExtraScaredHearts:GetAnmFilepath(seed)
    if in_void() then
        return build_scared_heart_path(ScaredHeartType.VOID);
    end

    local rng = RNG(seed, 35)
    local outcome = Pool:PickOutcome(rng);
    return build_scared_heart_path(outcome);
end

--/HELPER FUNCTIONS--

----CALLBACKS----

--Call the sprite function whenever a heart spawns (function will check if it is scared or not)
ExtraScaredHearts:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ExtraScaredHearts.ChangeAnm, PickupVariant.PICKUP_HEART)

----/CALLBACKS----
