local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Glitched Breakfast", 1)

local TIMES_CAN_FAIL = 50

function mod:PostPickupInit(pickup)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
    and pickup.SubType == CollectibleType.COLLECTIBLE_BREAKFAST then
        local isPoolBreakfast = false
        local itemPool = Game():GetItemPool()
        local roomType = Game():GetRoom():GetType()
        local seed = pickup:GetDropRNG():GetSeed()
        local roomPool = itemPool:GetPoolForRoom(roomType, seed)

        if roomPool == ItemPoolType.POOL_NULL then
            roomPool = ItemPoolType.POOL_TREASURE
        end

        local breakfastCount = 0
        repeat
            local itemId = itemPool:GetCollectible(roomPool, false)
            breakfastCount = breakfastCount + 1

            if breakfastCount == TIMES_CAN_FAIL then
                isPoolBreakfast = true
                goto exit
            end

        until itemId ~= CollectibleType.COLLECTIBLE_BREAKFAST
        ::exit::

        if isPoolBreakfast then
            pickup:GetData().GLITCHFAST_WillGlitch = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.PostPickupInit)

function mod:PostPickupUpdate(pickup)
    if pickup:GetData().GLITCHFAST_WillGlitch then
        pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.PostPickupUpdate)