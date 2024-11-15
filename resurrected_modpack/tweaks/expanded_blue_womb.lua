local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Expanded Blue Womb", 1, true)

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

if REPENTOGON then
    -- Using MC_POST_NEW_ROOM so that Glowing Hourglass shenanigans don't remove the flag prematurely
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SetRedirectBlueWomb)
else
    local enableOnUpdate = false

    function mod:PostNewRoomWrapper()
        if not pcall(mod.SetRedirectBlueWomb) then
            enableOnUpdate = true
        end
    end

    function mod:PostUpdateWrapper()
        if enableOnUpdate then
            enableOnUpdate = false
            mod:SetRedirectBlueWomb()
        end
    end

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoomWrapper)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdateWrapper)
end