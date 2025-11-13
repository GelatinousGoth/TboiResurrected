--[[ Black Market ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local game = Game()

-- Black Market: Secret Item Pool --
function mod:blackmarketPostRoom()
    if not config["blackmarket"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BLACK_MARKET then mod.itemReroll(ItemPoolType.POOL_SECRET) end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.blackmarketPostRoom)