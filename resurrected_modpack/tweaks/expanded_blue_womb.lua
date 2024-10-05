local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Expanded Blue Womb"

local LEVEL = Game():GetLevel()
local LOCKED_ROOM_TYPES = {
    [RoomType.ROOM_SHOP] = true,
    [RoomType.ROOM_TREASURE] = true,
    [RoomType.ROOM_ARCADE] = true,
    [RoomType.ROOM_LIBRARY] = true,
    [RoomType.ROOM_ISAACS] = true,
    [RoomType.ROOM_BARREN] = true,
    [RoomType.ROOM_CHEST] = true,
    [RoomType.ROOM_DICE] = true,
    [RoomType.ROOM_PLANETARIUM] = true
}

function mod:SetRedirectBlueWomb()
    if LEVEL:GetStage() ~= LevelStage.STAGE4_3 then
        return
    end

    local rooms = LEVEL:GetRooms()

    for i = 0, rooms.Size-1 do
        local roomDescriptor = rooms:Get(i)

        if (roomDescriptor.VisitedCount == 0 and LOCKED_ROOM_TYPES[roomDescriptor.Data.Type]) then
            roomDescriptor.Flags = roomDescriptor.Flags | RoomDescriptor.FLAG_BLUE_REDIRECT
        end
    end
end

-- Using MC_POST_NEW_ROOM so that Glowing Hourglass shenanigans don't remove the flag prematurely
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SetRedirectBlueWomb)