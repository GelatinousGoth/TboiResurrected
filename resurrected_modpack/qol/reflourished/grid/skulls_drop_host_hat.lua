local function SkullHostHatEnabler()

local SkullHostHat = {}
local mod = IsaacReflourished

local SKULL_DROP_CHANCE = 3  -- 1 in X chance


---@param rock GridEntityRock
function SkullHostHat:SkullBreak(rock, type, immediate)
    if not (Game():GetLevel():GetStage() == LevelStage.STAGE3_1 or Game():GetLevel():GetStage() == LevelStage.STAGE3_2) then return end
    local skullPos = rock.Position

    Isaac.CreateTimer(function()
        local itemPool = Game():GetItemPool()
        local closeItems = Isaac.FindInRadius(skullPos, 20, EntityPartition.PICKUP)
        for _, item in ipairs(closeItems) do
            if item.Variant == PickupVariant.PICKUP_COLLECTIBLE and (item.SubType == CollectibleType.COLLECTIBLE_DRY_BABY or item.SubType == CollectibleType.COLLECTIBLE_GHOST_BABY) then
                local rng = Isaac.GetPlayer():GetCollectibleRNG(CollectibleType.COLLECTIBLE_HOST_HAT)
                local roll = rng:RandomInt(SKULL_DROP_CHANCE)
                if roll == 0 and itemPool:HasCollectible(CollectibleType.COLLECTIBLE_HOST_HAT) then
                    if item.SubType == CollectibleType.COLLECTIBLE_DRY_BABY then
                        itemPool:ResetCollectible (CollectibleType.COLLECTIBLE_DRY_BABY)
                    elseif item.SubType == CollectibleType.COLLECTIBLE_GHOST_BABY then
                        itemPool:ResetCollectible(CollectibleType.COLLECTIBLE_GHOST_BABY)
                    end
                    item:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_HOST_HAT, true)
                    itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HOST_HAT)
                end
                return
            end
        end
    end, 2, 1, false)
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, SkullHostHat.SkullBreak, GridEntityType.GRID_ROCK_ALT)


-- mod:AddCallback(ModCallbacks.MC_HUD_RENDER, function()
--     local itemPool = Game():GetItemPool()

--     local hasDry = "Has dry baby: " .. tostring(itemPool:HasCollectible(CollectibleType.COLLECTIBLE_DRY_BABY))
--     Isaac.RenderText(hasDry, 40, 40, 1, 1, 1, 1)
--     local hasGhost = "Has ghost baby: " .. tostring(itemPool:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_BABY))
--     Isaac.RenderText(hasGhost, 40, 60, 1, 1, 1, 1)
--     local hasHostHat = "Has host hat: " .. tostring(itemPool:HasCollectible(CollectibleType.COLLECTIBLE_HOST_HAT))
--     Isaac.RenderText(hasHostHat, 40, 80, 1, 1, 1, 1)



-- end)


-- mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
--     local player = Isaac.GetPlayer()
--     local collectiblesToAdd = {
--         CollectibleType.COLLECTIBLE_MERCURIUS,
--         CollectibleType.COLLECTIBLE_MERCURIUS,
--         CollectibleType.COLLECTIBLE_MERCURIUS,
--         CollectibleType.COLLECTIBLE_MERCURIUS,
--         CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,
--         CollectibleType.COLLECTIBLE_FAST_BOMBS,
--         CollectibleType.COLLECTIBLE_MIND,
--         CollectibleType.COLLECTIBLE_PYROMANIAC,
--         CollectibleType.COLLECTIBLE_PYRO,
--         CollectibleType.COLLECTIBLE_THUNDER_THIGHS,
--         CollectibleType.COLLECTIBLE_CLEAR_RUNE,
--     }

--     player:AddCard(Card.RUNE_HAGALAZ)
--     Isaac.ExecuteCommand("debug 8")
--     Isaac.ExecuteCommand("debug 10")
--     Isaac.ExecuteCommand("stage 6")
--     Isaac.ExecuteCommand("goto d.438")


--     for _, collectible in ipairs(collectiblesToAdd) do
--         player:AddCollectible(collectible)
--     end

--     Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, player.Position, Vector(0,0), nil)
-- end)

-- function SkullHostHat:ItemSpawn(type, variant, subtype, pos, velocity, spawner, seed)
--     if not (variant == PickupVariant.PICKUP_COLLECTIBLE and (subtype == CollectibleType.COLLECTIBLE_DRY_BABY or subtype == CollectibleType.COLLECTIBLE_GHOST_BABY)) then return end

--     -- if not skullBroken then return end
--     -- if skullFrameCount ~= Game():GetFrameCount() then return end

--     -- skullBroken = false
--     -- -- skullPos = Vector(0,0)
--     -- skullFrameCount = 0

--     if not (Game():GetLevel():GetStage() == LevelStage.STAGE3_1 or Game():GetLevel():GetStage() == LevelStage.STAGE3_2) then return end
--     local room = Game():GetRoom()
--     local grid = room:GetGridEntity(room:GetGridIndex(pos)):GetType()
--     print(grid)
--     if grid ~= GridEntityType.GRID_ROCK_ALT then return end
    

-- end
-- mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, SkullHostHat.ItemSpawn)

end
return SkullHostHatEnabler