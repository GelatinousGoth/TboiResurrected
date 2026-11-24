--[[ Black Market ]]--
local mod = EnhancementChamber

-- Gets secret item pool
---@param room Room
---@param desc RoomDescriptor
function mod:BlackmarketPool(room, desc)
    if not self:HasConfig("blackmarket_itempool") then return end
    if desc.Data.Type ~= RoomType.ROOM_BLACK_MARKET then return end

    room:SetItemPool(ItemPoolType.POOL_SECRET)
end
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, mod.BlackmarketPool)