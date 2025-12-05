--[[ Black Market ]]--
local mod = EnhancementChamber
local game = Game()

-- Gets secret item pool
function mod:blackmarketPostRoom()
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BLACK_MARKET then
        self.itemReroll(ItemPoolType.POOL_SECRET)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.blackmarketPostRoom)