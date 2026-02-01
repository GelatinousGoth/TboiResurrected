local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Expanded Blue Womb", 1, true)

local g_Game = Game()
local g_Level = g_Game:GetLevel()

local function SetRedirectBlueWomb()
    if g_Level:GetStage() ~= LevelStage.STAGE4_3 then
        return
    end

    local room = g_Game:GetRoom()
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
        local door = room:GetDoor(i)
        if not door then
            goto continue
        end

        local variant = door:GetVariant()
        if variant ~= DoorVariant.DOOR_LOCKED and variant ~= DoorVariant.DOOR_LOCKED_DOUBLE then
            goto continue
        end

        if door:IsOpen() then
            goto continue
        end

        local targetIdx = door.TargetRoomIndex
        local roomDesc = g_Level:GetRoomByIdx(targetIdx, -1)
        roomDesc.Flags = roomDesc.Flags | RoomDescriptor.FLAG_BLUE_REDIRECT
        ::continue::
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SetRedirectBlueWomb)