local level = Game():GetLevel()

---@param room Room
---@param descriptor RoomDescriptor
local function PreNewRoom(_, room, descriptor)
    local type = descriptor.Data.Type
    if
    (
        type == RoomType.ROOM_TREASURE
        and level:GetAbsoluteStage() == LevelStage.STAGE4_3
    )
    or type == RoomType.ROOM_BLUE then
        room:SetItemPool(HUSHS_ITEMPOOL.ItemPool)
    end
end

HUSHS_ITEMPOOL:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, PreNewRoom)