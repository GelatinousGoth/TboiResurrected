local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Head Of The Keeper Costume", 1)

NullItemID.ID_PENNY = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_penny_shoot.anm2")
NullItemID.ID_PENNY_IDLE = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_penny.anm2")
NullItemID.ID_NICKEL = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_nickel_shoot.anm2")
NullItemID.ID_NICKEL_IDLE = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_nickel.anm2")
NullItemID.ID_DIME = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_dime_shoot.anm2")
NullItemID.ID_DIME_IDLE = Isaac.GetCostumeIdByPath("gfx/characters/headofthekeeper_dime.anm2")

local shootCostumes = {
    PENNY = NullItemID.ID_PENNY,
    NICKEL = NullItemID.ID_NICKEL,
    DIME = NullItemID.ID_DIME
}

local idleCostumes = {
    PENNY = NullItemID.ID_PENNY_IDLE,
    NICKEL = NullItemID.ID_NICKEL_IDLE,
    DIME = NullItemID.ID_DIME_IDLE
}

local CostumeState = {
    NONE = 0,
    SHOOT_APPLIED = 1,
    IDLE_APPLIED = 2
}

local currentShootCostume = shootCostumes.PENNY
local currentIdleCostume = idleCostumes.PENNY
local currentCostumeState = CostumeState.NONE
local costumeChangeDelay = 50
local frameCounter = 0


function mod.coinCheck()
    local playerCoins = Isaac.GetPlayer():GetNumCoins()

    if playerCoins <= 30 then
        currentShootCostume = shootCostumes.PENNY
        currentIdleCostume = idleCostumes.PENNY

    elseif playerCoins <= 60 and playerCoins > 30 then
        currentShootCostume = shootCostumes.NICKEL
        currentIdleCostume = idleCostumes.NICKEL

    elseif playerCoins > 60 then
        currentShootCostume = shootCostumes.DIME
        currentIdleCostume = idleCostumes.DIME

    end
end

function mod.updateCostume()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then

        frameCounter = frameCounter + 1
        local isShooting = Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) or
                           Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) or
                           Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, 0)

        if frameCounter >= costumeChangeDelay then
            if (not isShooting and currentCostumeState == CostumeState.NONE) then
                player:AddNullCostume(currentIdleCostume)
                currentCostumeState = CostumeState.IDLE_APPLIED
                frameCounter = 0

            elseif not isShooting and currentCostumeState ~= CostumeState.IDLE_APPLIED then
                player:TryRemoveNullCostume(NullItemID.ID_PENNY)
                player:TryRemoveNullCostume(NullItemID.ID_NICKEL)
                player:TryRemoveNullCostume(NullItemID.ID_DIME)
                player:AddNullCostume(currentIdleCostume)
                currentCostumeState = CostumeState.IDLE_APPLIED
                frameCounter = 0

            elseif isShooting and currentCostumeState ~= CostumeState.SHOOT_APPLIED then
                player:TryRemoveNullCostume(NullItemID.ID_PENNY_IDLE)
                player:TryRemoveNullCostume(NullItemID.ID_NICKEL_IDLE)
                player:TryRemoveNullCostume(NullItemID.ID_DIME_IDLE)
                player:AddNullCostume(currentShootCostume)
                currentCostumeState = CostumeState.SHOOT_APPLIED
                frameCounter = 0

            end
        end

    elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
        currentCostumeState = CostumeState.NONE
        player:TryRemoveNullCostume(currentIdleCostume)
        player:TryRemoveNullCostume(currentShootCostume)
        frameCounter = 0

    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.updateCostume, 0)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.coinCheck, 0)