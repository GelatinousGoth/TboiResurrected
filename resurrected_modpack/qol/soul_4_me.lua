---@type ModReference
local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Soul4Me", 1)

local game = Game()

---@return EntityPlayer[]
local function GetPlayers()
    if REPENTOGON then
        return PlayerManager.GetPlayers()
    end
    local players = {}
    for i = 0 , game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        players[#players + 1] = player
    end

    return players
end

---@param plr EntityPlayer
local function isGhostPlayer(plr)
    if REPENTOGON then
        return plr:GetHealthType() == HealthType.LOST or plr:HasInstantDeathCurse()
    else
        return plr:GetPlayerType() == PlayerType.PLAYER_THELOST or plr:GetPlayerType() == PlayerType.PLAYER_THELOST_B or plr:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or plr:GetPlayerType() == PlayerType.PLAYER_JACOB2_B
    end
end



---@param player? EntityPlayer
local function shouldFakeYourSoulEffect(player)
    local players = player and {player} or GetPlayers()
    local hasNonLostPlayer = false
    local ghostPlayer

    for _, currentPlayer in pairs(players) do
        if not isGhostPlayer(currentPlayer) then
            hasNonLostPlayer = true
        elseif isGhostPlayer(currentPlayer) and not currentPlayer:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
            ghostPlayer = currentPlayer
        end
    end

    return not hasNonLostPlayer and ghostPlayer
end

---@param pickup EntityPickup
local function processPriceReplacement(pickup)
    if pickup.Price < 0 and pickup.Price ~= PickupPrice.PRICE_SPIKES and pickup.Price ~= PickupPrice.PRICE_FREE then
        if shouldFakeYourSoulEffect() then
            pickup.Price = PickupPrice.PRICE_SOUL
        end
    end
end


if REPENTOGON then
    --just set price sprite to soul one
    ---@param pickup EntityPickup
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function (_, pickup)
        if pickup.Price < 0 and pickup.Price ~= PickupPrice.PRICE_SPIKES and pickup.Price ~= PickupPrice.PRICE_FREE then
            if shouldFakeYourSoulEffect() then
                pickup:GetPriceSprite():SetFrame(4)
             end
        end
    end, PickupVariant.PICKUP_COLLECTIBLE)

else
    ---@param pickup EntityPickup
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function (_, pickup)
        processPriceReplacement(pickup)
    end, PickupVariant.PICKUP_COLLECTIBLE)

    ---@param pickup EntityPickup
    ---@param collder Entity
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function (_, pickup, collder)
        if not collder:ToPlayer() then return end
        local plr = collder:ToPlayer() ---@cast plr EntityPlayer

        local level = game:GetLevel()
        local isCurrentStartingRoom = (not game:IsGreedMode() and level:GetStage() == LevelStage.STAGE6) and (level:GetCurrentRoomIndex() == level:GetStartingRoomIndex())

        if pickup.Price == PickupPrice.PRICE_SOUL and shouldFakeYourSoulEffect(plr) and pickup.Wait == 0 and (plr:CanPickupItem() and not plr:IsHoldingItem()) then
            for _, ent in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                local pick = ent:ToPickup() ---@cast pick EntityPickup
                if pick ~= pickup and ((pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pick.SubType ~= 0 and pick.Price < 0) or isCurrentStartingRoom and pick.Variant == PickupVariant.PICKUP_REDCHEST ) then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 15, 0 , pick.Position + Vector(0, 10), Vector.Zero, nil)
                    pick.Timeout = 4
                end
            end
        end        
    end, PickupVariant.PICKUP_COLLECTIBLE)
end