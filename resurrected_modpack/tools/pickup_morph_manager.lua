local mod = require("resurrected_modpack.mod_reference")

mod.Lib.PickupManager = {}

ModName = "PickupManager"
LockCallbackRecord = true
mod.CurrentModName = ModName
mod.LockCallbackRecord = LockCallbackRecord

local DecimalPrecision = 2
local ScaleFactor = 10^(2 + DecimalPrecision)

local RECOMMENDED_SHIFT_IDX = 35
local NONE_INDEX = 1

local TSILOutcomePicker = {}
local RepentogonOutcomePicker = {}
local MorphPersistentObjectData = {}

local usedMovingBox = false

local function GetMorphData(Pickup)
    local objectPtr = GetPtrHash(Pickup)
    if not MorphPersistentObjectData[objectPtr] then
        MorphPersistentObjectData[objectPtr] = {}
    end
    return MorphPersistentObjectData[objectPtr]
end

local function GetNewIndex(OutcomeTable)
    return #OutcomeTable.Outcomes + 1
end

local function CreateNewOutcomeTable()
end

local function PickOutcome()
end

local function UpdateNone()
end

local function AddOutcome()
end

local function RemoveOutcome()
end

local function GetOutcomes()
end

if not REPENTOGON then
    CreateNewOutcomeTable = function()
        return {Picker = WeightedOutcomePicker(), Outcomes = {}, MaxWeight = 0.0}
    end

    PickOutcome = function(OutcomeTable, Rng)
        return OutcomeTable.Outcomes[OutcomeTable.Picker:PickOutcome(Rng)]
    end

    UpdateNone = function(OutcomeTable, NewWeight, SumWeight)
        if OutcomeTable.Outcomes[NONE_INDEX] then
            OutcomeTable.Picker:RemoveOutcome(NONE_INDEX)
        end
        if type(SumWeight) ~= "number" then
            SumWeight = 0
            local registeredOutcomes = OutcomeTable.Picker:GetOutcomes()
            for _, outcome in ipairs(registeredOutcomes) do
                SumWeight = SumWeight + outcome.Weight
            end
        end
        ScaledNewWeight = NewWeight * ScaleFactor -- ActualWeight
        ScaleMultiplier = SumWeight > 0 and ScaledNewWeight > 0 and SumWeight / ScaledNewWeight or 1 -- Scales the NewWeight so that it is actually that percentage, regardless of the number of other Weighted Outcomes
        OutcomeTable.Outcomes[NONE_INDEX] = {Morph = "None", Weight = NewWeight}
        OutcomeTable.Picker:AddOutcomeFloat(NONE_INDEX, NewWeight, TSIL.Utils.Math.Round(ScaleFactor * ScaleMultiplier))
    end
    
    AddOutcome = function(OutcomeTable, OutcomeData, Weight, Index)
        if type(Index) ~= "number" or OutcomeData.Outcomes[Index] then
            Index = GetNewIndex(OutcomeTable)
        end
        OutcomeTable.Outcomes[Index] = {Morph = OutcomeData, Weight = Weight}
        OutcomeTable.Picker:AddOutcomeFloat(Index, Weight, ScaleFactor)
    end
    
    RemoveOutcome = function(OutcomeTable, OutcomeIndex)
        if type(OutcomeIndex) ~= "number" then
            return
        end
        OutcomeTable.Outcomes[OutcomeIndex] = nil
        OutcomeTable.Picker:RemoveOutcome(OutcomeIndex)
    end

    GetOutcomes = function(OutcomeTable)
        return OutcomeTable.Picker:GetOutcomes()
    end
else
    CreateNewOutcomeTable = function()
        return {List = {}, Outcomes = {}, MaxWeight = 0.0}
    end

    PickOutcome = function(OutcomeTable, Rng)
        return OutcomeTable.Outcomes[TSIL.Random.GetRandomElementFromWeightedList(Rng, OutcomeTable.List)]
    end

    local function RemoveFromList(List, Value)
        for index, outcome in pairs(List) do
            if outcome.value == Value then
                table.remove(List, index)
                break
            end
        end
    end

    GetOutcomes = function(OutcomeTable)
        return TSIL.Utils.DeepCopy.DeepCopy(OutcomeTable.List)
    end

    UpdateNone = function(OutcomeTable, NewWeight, SumWeight)
        if OutcomeTable.Outcomes[NONE_INDEX] then
            RemoveFromList(OutcomeTable.List, NONE_INDEX)
        end
        if type(SumWeight) ~= "number" then
            SumWeight = 0
            local registeredOutcomes = GetOutcomes(OutcomeTable)
            for _, outcome in ipairs(registeredOutcomes) do
                SumWeight = SumWeight + outcome.chance
            end
        end
        ScaledNewWeight = NewWeight * ScaleFactor -- ActualWeight
        ScaleMultiplier = SumWeight > 0 and ScaledNewWeight > 0 and SumWeight / ScaledNewWeight or 1 -- Scales the NewWeight so that it is actually that percentage, regardless of the number of other Weighted Outcomes
        OutcomeTable.Outcomes[NONE_INDEX] = {Morph = "None", Weight = NewWeight}
        table.insert(OutcomeTable.List, {value = NONE_INDEX, chance = NewWeight * TSIL.Utils.Math.Round(ScaleFactor * ScaleMultiplier)})
    end

    AddOutcome = function(OutcomeTable, OutcomeData, Weight, Index)
        if type(Index) ~= "number" or OutcomeData.Outcomes[Index] then
            Index = GetNewIndex(OutcomeTable)
        end
        OutcomeTable.Outcomes[Index] = {Morph = OutcomeData, Weight = Weight}
        table.insert(OutcomeTable.List, {value = Index, chance = Weight * ScaleFactor})
    end

    RemoveOutcome = function(OutcomeTable, OutcomeIndex)
        if type(OutcomeIndex) ~= "number" then
            return
        end
        OutcomeTable.Outcomes[OutcomeIndex] = nil
        RemoveFromList(OutcomeTable.List, OutcomeIndex)
    end
end

local function RemoveMorphAndSetNewNoneWeight(outcomeTable, removedOutcome)
    local sumWeight = 0.0
    local maxWeight = 0.0
    for index, outcome in pairs(outcomeTable.Outcomes) do
        if index == NONE_INDEX then
            goto continue
        end
        if outcome.Morph == removedOutcome then
            RemoveOutcome(outcomeTable, index)
            goto continue
        end
        sumWeight = sumWeight + outcome.Weight
        maxWeight = math.max(maxWeight, outcome.Weight)
        ::continue::
    end
    if maxWeight < outcomeTable.MaxWeight then
        outcomeTable.MaxWeight = maxWeight
        UpdateNone(outcomeTable, 1.0 - maxWeight, sumWeight)
    end
end

function mod.Lib.PickupManager.AddPickupMorph(Original, New, Weight)
    Weight = TSIL.Utils.Math.Round(Weight, DecimalPrecision)
    Weight = Weight/100
    local registeredVariant = not not RepentogonOutcomePicker[Original.Variant]
    if Original.Variant and not RepentogonOutcomePicker[Original.Variant] then
        RepentogonOutcomePicker[Original.Variant] = CreateNewOutcomeTable()
        UpdateNone(RepentogonOutcomePicker[Original.Variant], 1.0)
    end
    if Original.SubType and not RepentogonOutcomePicker[Original.Variant][Original.SubType] then
        RepentogonOutcomePicker[Original.Variant][Original.SubType] = CreateNewOutcomeTable()
        UpdateNone(RepentogonOutcomePicker[Original.Variant][Original.SubType], 1.0)
    end

    if Original.SubType then
        local subtypeOutcomeTable = RepentogonOutcomePicker[Original.Variant][Original.SubType]
        AddOutcome(subtypeOutcomeTable, New, Weight)
        local maxWeight = math.max(subtypeOutcomeTable.MaxWeight, Weight)
        subtypeOutcomeTable.MaxWeight = maxWeight
        UpdateNone(subtypeOutcomeTable, 1.0 - maxWeight)
    elseif Original.Variant then
        local variantOutcomeTable = RepentogonOutcomePicker[Original.Variant]
        AddOutcome(variantOutcomeTable, New, Weight)
        local maxWeight = math.max(variantOutcomeTable.MaxWeight, Weight)
        variantOutcomeTable.MaxWeight = maxWeight
        UpdateNone(variantOutcomeTable, 1.0 - maxWeight)
    end
    if not registeredVariant then
        local function MorphPickup(_, Pickup)
            local morphData = GetMorphData(Pickup)
            local originalOutcome = morphData.OriginalOutcome

            if originalOutcome then -- Avoid Infinite Recursion
                if Pickup.Type == originalOutcome.Type and Pickup.Variant == originalOutcome.Variant and Pickup.SubType == originalOutcome.SubType then
                    local morphRepeats = morphData.MorphRepeats
                    morphData.ForceOutcome = TSIL.Utils.DeepCopy.DeepCopy(originalOutcome)
                    morphData.MorphRepeats = morphRepeats and morphRepeats + 1 or 1
                    if morphData.MorphRepeats >= 2 then
                        morphData.AbortMorph = true -- Disable Force to avoid infinite recursion
                    end
                    return
                end
            else
                morphData.OriginalOutcome = {Type = Pickup.Type, Variant = Pickup.Variant, SubType = Pickup.SubType}
            end
            if usedMovingBox then
                morphData.ForceOutcome = TSIL.Utils.DeepCopy.DeepCopy(morphData.OriginalOutcome)
                morphData.UsedMovingBox = true
                return
            end
            local variantTable = RepentogonOutcomePicker[Pickup.Variant]
            if not variantTable then
                return -- Safety Return
            end
            local subtypeTable = variantTable[Pickup.SubType]
            if subtypeTable and Pickup.SubType ~= Original.SubType then
                return
            end
            local outcomeTable = variantTable[Pickup.SubType] or variantTable
            local rng = RNG()
            rng:SetSeed(Pickup.InitSeed, 0)
            local outcome = PickOutcome(outcomeTable, rng)
            local morph = outcome.Morph
            if morph == "None" then
                return
            end
            local type = morph.Type or Pickup.Type
            local variant = morph.Variant or Pickup.Variant
            local subType = morph.SubType or Pickup.SubType
            morphData.ForceOutcome = {Type = type, Variant = variant, SubType = subType}
            Pickup:Morph(type, variant, subType, true, true, false)
        end
        mod:AddPriorityCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, CallbackPriority.MAX, MorphPickup, Original.Variant, ModName, LockCallbackRecord)
    end
end
function mod.Lib.PickupManager.RemovePickupMorph(Original, New)
    if Original.SubType and RepentogonOutcomePicker[Original.Variant] and RepentogonOutcomePicker[Original.Variant][Original.SubType] then
        local subtypeOutcomeTable = RepentogonOutcomePicker[Original.Variant][Original.SubType]
        RemoveMorphAndSetNewNoneWeight(subtypeOutcomeTable, New)
    elseif Original.Variant and RepentogonOutcomePicker[Original.Variant] then
        local variantOutcomeTable = RepentogonOutcomePicker[Original.Variant]
        RemoveMorphAndSetNewNoneWeight(variantOutcomeTable, New)
    end
end

function mod.Lib.PickupManager.GetOutcomes(Original)
    if Original.SubType and RepentogonOutcomePicker[Original.Variant] and RepentogonOutcomePicker[Original.Variant][Original.SubType] then
        local subtypeOutcomeTable = RepentogonOutcomePicker[Original.Variant][Original.SubType]
        return GetOutcomes(subtypeOutcomeTable)
    elseif Original.Variant and RepentogonOutcomePicker[Original.Variant] then
        local variantOutcomeTable = RepentogonOutcomePicker[Original.Variant]
        return GetOutcomes(variantOutcomeTable)
    end
end

mod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_EARLY, function() MorphPersistentObjectData = {} end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.MAX, function() usedMovingBox = true end, CollectibleType.COLLECTIBLE_MOVING_BOX)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function() usedMovingBox = false end, CollectibleType.COLLECTIBLE_MOVING_BOX)
mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.MAX, function() usedMovingBox = false end) -- In case another MC_PRE_USE_ITEM callback returns true

-- NOTE: A lot of the code can be simplified if we decide to make two rolls (one to see if the chest morphs into a modded outcome (by using the MaxWeight for modded probability and it's Complementary for no morph)
-- and another to choose the modded outcome) instead of only rolling one random number like the way it is currently implemented.