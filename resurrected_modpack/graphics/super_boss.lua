local BossDoors = RegisterMod("Unique Final Boss Doors", 1)
local game = Game()

local DOOR_PATH = "gfx/grid/door_superboss.anm2"

local function IsWantedFloor(stage, stageType)
    if stage == LevelStage.STAGE3_2 then return true end -- mom
    if stage == LevelStage.STAGE4_2 then return true end -- heart
    if stage == LevelStage.STAGE5 then return true end -- isac / satan
    if stage == LevelStage.STAGE6 then return true end -- ??? / lamb
    return false
end

local function IsBossDoor(level, room, door)
    local targetIndex = door.TargetRoomIndex
    local desc = level:GetRoomByIdx(targetIndex)
    local data = desc and desc.Data

    local currentRoomIsBoss =
        room:GetType() == RoomType.ROOM_BOSS

    local targetRoomIsBoss =
        data ~= nil and data.Type == RoomType.ROOM_BOSS

    return currentRoomIsBoss or targetRoomIsBoss
end

function BossDoors:OnNewRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()

    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if not IsWantedFloor(stage, stageType) then
        return
    end
    
    if stage == LevelStage.STAGE6
        and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
        return
    end

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(i)

        if door ~= nil and IsBossDoor(level, room, door) then
            local sprite = door:GetSprite()

            sprite:Load(DOOR_PATH, false)
            sprite:LoadGraphics()

            if door:IsOpen() then
                sprite:Play("Opened", false)
            else
                sprite:Play("Close", false)
            end
        end
    end
end

function BossDoors:OnUpdate()
    local level = game:GetLevel()
    local room = game:GetRoom()

    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if not IsWantedFloor(stage, stageType) then
        return
    end

    if stage == LevelStage.STAGE6
        and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
        return
    end

    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(i)

        if door ~= nil and door:IsOpen() and IsBossDoor(level, room, door) then
            local sprite = door:GetSprite()

            if not sprite:IsPlaying("Opened")
                and not sprite:IsFinished("Opened") then
                sprite:Play("Opened", false)
            end
        end
    end
end

BossDoors:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    BossDoors.OnNewRoom
)

BossDoors:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    BossDoors.OnUpdate
)