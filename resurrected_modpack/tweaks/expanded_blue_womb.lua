local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Expanded Blue Womb", 1, true)

local g_Game = Game()
local g_Level = g_Game:GetLevel()

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

local function get_writable_room(rooms, i)
    return rooms:Get(i)
end

if not REPENTOGON then
    get_writable_room = function(rooms, i)
        local roomDescriptor = rooms:Get(i)
        local roomPtrHash = GetPtrHash(roomDescriptor)

        for dimension = 0, 2 do
            local writableRoomDescriptor = g_Level:GetRoomByIdx(roomDescriptor.SafeGridIndex, dimension)

            if GetPtrHash(writableRoomDescriptor) == roomPtrHash then
                return writableRoomDescriptor
            end
        end

        return g_Level:GetRoomByIdx(roomDescriptor.SafeGridIndex, -1)
    end
end

local function SetRedirectBlueWomb()
    if g_Level:GetStage() ~= LevelStage.STAGE4_3 then
        return
    end

    if g_Level:GetCurrentRoomIndex() ~= g_Level:GetStartingRoomIndex() or not g_Game:GetRoom():IsFirstVisit() then
        return
    end

    local rooms = g_Level:GetRooms()

    for i = 0, rooms.Size-1 do
        local roomDescriptor = get_writable_room(rooms, i)
        if (roomDescriptor.VisitedCount == 0 and LOCKED_ROOM_TYPES[roomDescriptor.Data.Type]) then
            roomDescriptor.Flags = roomDescriptor.Flags | RoomDescriptor.FLAG_BLUE_REDIRECT
        end
    end
end

-- Using MC_POST_NEW_ROOM so that Glowing Hourglass shenanigans don't remove the flag prematurely
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SetRedirectBlueWomb)