local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Unique Delirium Door"

local game = Game()

function mod:OnUpdate()
    --Getting the current level that the player is on
    local currentLevel = game:GetLevel()

    --If currentLevel is The Void
    if currentLevel:GetStage() == LevelStage.STAGE7 then
        local currentRoom = game:GetRoom()

        --Looping through all the possible door positions in the room
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1, 1 do
            local door = currentRoom:GetDoor(i)

            --If the door exists
            if door ~= nil then
                --Getting the index of the room, its description data, and its configuration data
                local doorSprite = door:GetSprite()
                local doorRoomIndex = door.TargetRoomIndex
                local roomDescriptor = currentLevel:GetRoomByIdx(doorRoomIndex)
                local roomConfigData = roomDescriptor.Data  
                
                --If the shape of the next room is 2x2 and is a boss room or if you are already in the Delirium fight, change the spritesheet of the door
                if (roomConfigData.Shape == RoomShape.ROOMSHAPE_2x2 and roomConfigData.Type == RoomType.ROOM_BOSS) or (currentRoom:GetType() == RoomType.ROOM_BOSS and currentRoom:GetRoomShape() == RoomShape.ROOMSHAPE_2x2) and not door:IsOpen() then
                    doorSprite:Load("gfx/grid/door_bossdeliriumdoor.anm2", false)
                    --Play the close door animation since changing the sprite messes up the animation that plays
                    doorSprite:Play("Close", false)
                    doorSprite:LoadGraphics()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnUpdate)