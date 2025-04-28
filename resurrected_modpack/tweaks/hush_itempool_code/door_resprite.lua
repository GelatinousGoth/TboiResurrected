local level = Game():GetLevel()

local function PreNewRoom()
    if level:GetAbsoluteStage() ~= LevelStage.STAGE4_3 then
        return
    end

    local room = Game():GetRoom()
    --Yoinked from Tainted Treasures (which yoinked it from Andromeda)
    for _, slot in pairs(DoorSlot) do
        local door = room:GetDoor(slot)
        if not (door and door:IsRoomType(RoomType.ROOM_TREASURE)) then
            goto continue
        end
        local doorSprite = door:GetSprite()
        local anim = doorSprite:GetAnimation()
		doorSprite:Load("gfx/grid/door_hush_treasureroomdoor.anm2", true)
		doorSprite:ReplaceSpritesheet(0, "gfx/grid/door_hush_treasureroomdoor.png")
	    doorSprite:LoadGraphics()
	    doorSprite:Play(anim)
        ::continue::
    end
end

HUSHS_ITEMPOOL:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PreNewRoom)