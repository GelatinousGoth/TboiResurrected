local function GlitchedCrownChestFixEnabler()

local GlitchedCrownChestFix = {}
local mod = IsaacReflourished

-- Using InitSeed as opposed to GetPtrHash to account for rerolls automatically
---@type table<number, number>
local wait = {}

-- Storing the wait frames of the collectible in a list to manually keep track of them
-- Checking for nil because PICKUP_INIT gets called every time the collectible cycles
---@param pickup EntityPickup
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function (_, pickup)
    local pickup_id = pickup.InitSeed
    if wait[pickup_id] == nil then
        wait[pickup_id] = pickup.Wait
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

-- Updating the wait frames in the list then changing the item's wait frames accordingly
---@param pickup EntityPickup
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function (_, pickup)
    local pickup_id = pickup.InitSeed
    wait[pickup_id] = math.max((wait[pickup_id] or 0) - 1, 0)
    pickup.Wait = wait[pickup_id]
end, PickupVariant.PICKUP_COLLECTIBLE)

-- Clearing the list before entering a new room since we don't need to keep track of previous collectibles
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function (_)
    wait = {}
end, PickupVariant.PICKUP_COLLECTIBLE)

-- -- Debug to check that everything works
-- ---@param pickup EntityPickup
-- mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function (_, pickup)
--     local pos = Isaac.WorldToScreen(pickup.Position)
--     Isaac.RenderText("Wait Frames: "..tostring(pickup.Wait), pos.X-40, pos.Y, 1, 1, 1, 1)
--     -- Isaac.RenderText(GetPtrHash(pickup).."", pos.X-40, pos.Y+10, 1, 1, 1, 1)
--     -- Isaac.RenderText(pickup.InitSeed.."", pos.X-40, pos.Y+20, 1, 1, 1, 1)
-- end, PickupVariant.PICKUP_COLLECTIBLE)

end
return GlitchedCrownChestFixEnabler