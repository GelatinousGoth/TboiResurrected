local function BetterRoomPoolsEnabler()

local RoomPools = {}
local mod = IsaacReflourished


local ignoreNext = false
local function changePool(poolType, decrease, seed)
    ignoreNext = true
    local item = Game():GetItemPool():GetCollectible(poolType, decrease, seed, CollectibleType.COLLECTIBLE_BREAKFAST)
    ignoreNext = false
    if item == CollectibleType.COLLECTIBLE_BREAKFAST then return end
    return item
end

function RoomPools:GetItem(poolType, decrease, seed)
    --print(decrease)
    local game = Game()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local floor = level:GetStage()
    local stageType = level:GetStageType()
    local roomType = room:GetType()

    if ignoreNext then
        ignoreNext = false
        return
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then return end
    if poolType ~= ItemPoolType.POOL_TREASURE then return end

    -- Dark room starting room
    if floor == LevelStage.STAGE6
    and stageType == StageType.STAGETYPE_ORIGINAL
    and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
        local replaceDarkRoom = IsaacReflourished:GetSettingsValue("BetterPoolsDarkRoom") == 2
        if replaceDarkRoom then
            return changePool(ItemPoolType.POOL_DEVIL, decrease, seed)
        end
    -- Sacrifice with angel payout
    elseif roomType == RoomType.ROOM_SACRIFICE then
        local spikes = room:GetGridEntity(67)
        if spikes and spikes.VarData >= 7 then
            local replaceSacRoom = IsaacReflourished:GetSettingsValue("BetterPoolsSacRoom") == 2
            if replaceSacRoom then
                return changePool(game:IsGreedMode() and ItemPoolType.POOL_GREED_ANGEL or ItemPoolType.POOL_ANGEL, decrease, seed)
            end
        end
    -- Arcade (duh)
    elseif roomType == RoomType.ROOM_ARCADE then
        local replaceArcade = IsaacReflourished:GetSettingsValue("BetterPoolsArcade") == 2
        if replaceArcade then
            return changePool(ItemPoolType.POOL_CRANE_GAME, decrease, seed)
        end
    end

end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, RoomPools.GetItem)

-- ---@param projectile EntityProjectile
-- mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_, projectile, offset)
--     local sprite = projectile:GetSprite()
--     projectile:GetSprite().Offset = Vector(projectile:GetSprite().Offset.X, -(projectile.Height/2))
-- end)


end
return BetterRoomPoolsEnabler
