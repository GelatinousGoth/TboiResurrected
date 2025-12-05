--[[ SHOP ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

local GOLDEN_TRINKET_ID = 32768

-- Checks if trinket is golden
---@param trinketID integer
---@return boolean
local function isGoldenTrinket(trinketID)
    return trinketID > GOLDEN_TRINKET_ID
end

-- Shops can replace sacks with trinkets
---@param pickup EntityPickup
function mod:shopPickupInit(pickup)
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_SHOP and pickup:IsShopItem() and pickup.Variant ~= 100 then
        local chance = room:GetDecorationSeed() % 2
        local replacePickup = false
        -- 50% Chance to replace grab bag with trinket --
        if chance == 0 and pickup.Variant == 69 then
            replacePickup = true
        end
        -- Replaces pickup with trinket --
        if replacePickup then
            local price = pickup.Price
            local shopId = pickup.ShopItemId
            pickup:Remove()
            local trinket = Isaac.Spawn(5, 350, 0, pickup.Position, Vector.Zero, nil):ToPickup()
            trinket.Price = price
            trinket.ShopItemId = shopId
            trinket.AutoUpdatePrice = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.shopPickupInit)

-- Trinket Price
---@param pickupVar integer
---@param pickupSub integer
---@param price integer
function mod:shopPickupPrice(pickupVar, pickupSub, _, price)
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_SHOP then
        if pickupVar == 350 then
            local scale = 1.4
            if isGoldenTrinket(pickupSub) then scale = 2.0 end -- Golden trinket
            local value = math.floor(price * scale)
            return value
        end
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.shopPickupPrice)