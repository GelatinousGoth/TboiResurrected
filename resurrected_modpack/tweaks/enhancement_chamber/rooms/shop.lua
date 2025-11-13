--[[ SHOP ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local game = Game()
local sound = SFXManager()

-- Checks if trinket is golden --
local function isGoldenTrinket(trinketID)
    local bool = false
    if trinketID > 32768 then bool = true end
    return bool
end

-- Shop Variants --
function mod:shopPostRoom()
    if not config["shop"] then return end
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_SHOP then
        local goldenShop = mod.checkRoom(RoomType.ROOM_SHOP, "Golden")
        local junkShop = mod.checkRoom(RoomType.ROOM_SHOP, "Junk")
        -- Item Pools --
        if goldenShop then
            if room:IsFirstVisit() then sound:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1, 2, false, 2, 0) end
            room:TurnGold()
            mod.itemReroll(ItemPoolType.POOL_TREASURE)
        end
        if junkShop then
            if room:IsFirstVisit() then sound:Play(SoundEffect.SOUND_FART, 1, 2, false, 0.5, 0) end
            mod.itemReroll(ItemPoolType.POOL_BOSS)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.shopPostRoom)

-- Sell Trinkets -- 
function mod:shopPickupInit(pickup)
    if not config["shop"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_SHOP and pickup:IsShopItem() and pickup.Variant ~= 100 then
        local chance = room:GetDecorationSeed() % 2
        local replacePickup = false
        -- 50% Chance to replace grab bag with trinket --
        if chance == 0 and pickup.Variant == 69 then
            replacePickup = true
        end
        -- Checks if current shop is the junk variant --
        local isJunkShop = mod.checkRoom(RoomType.ROOM_SHOP, "Junk")
        -- Replaces pickup with trinket --
        if replacePickup or isJunkShop then
            local price = pickup.Price
            local shopId = pickup.ShopItemId
            pickup:Remove()
            local trinket = Isaac.Spawn(5, 350, 0, pickup.Position, Vector(0,0), nil):ToPickup()
            trinket.Price = price
            trinket.ShopItemId = shopId
            trinket.AutoUpdatePrice = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.shopPickupInit)

-- Trinket Price --
function mod:shopPickupPrice(pickupVar, pickupSub, _, price)
    if not config["shop"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_SHOP then
        if pickupVar == 350 then
            local scale = 1.4 -- Bag price adjustment
            if isGoldenTrinket(pickupSub) then scale = 2 end -- Golden trinket
            local value = math.floor(price * scale)
            return value
        end
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, mod.shopPickupPrice)