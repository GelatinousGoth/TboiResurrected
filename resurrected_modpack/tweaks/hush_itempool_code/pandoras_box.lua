local pandorasBoxOpened = false

local function ClosePandorasBox()
    pandorasBoxOpened = false
end

HUSHS_ITEMPOOL:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ClosePandorasBox)

---@param player EntityPlayer
local function PreUsePandorasBox(_, _, _, player)
    if not player:HasTrinket(TrinketType.TRINKET_STRANGE_KEY) then
        return
    end
    pandorasBoxOpened = true
    Isaac.CreateTimer(ClosePandorasBox, 1, 1, true)
end
HUSHS_ITEMPOOL:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, PreUsePandorasBox, CollectibleType.COLLECTIBLE_BLUE_BOX)

---@param poolType ItemPoolType
---@param decrease boolean
---@param seed integer
local function PreGetCollectible(_, poolType, decrease, seed)
    if not pandorasBoxOpened
    or poolType == HUSHS_ITEMPOOL.ItemPool then
        return
    end
    return Game():GetItemPool():GetCollectible(HUSHS_ITEMPOOL.ItemPool, decrease, seed)
end
HUSHS_ITEMPOOL:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, PreGetCollectible)