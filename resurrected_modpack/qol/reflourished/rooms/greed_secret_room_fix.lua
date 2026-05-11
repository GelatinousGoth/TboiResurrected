local function GreedSecretRoomFixEnabler()

local GreedFix = {}
local mod = IsaacReflourished


function GreedFix:OnClear()
    local room = Game():GetRoom()
    local descriptor = Game():GetLevel():GetCurrentRoomDesc()
    if descriptor.SurpriseMiniboss and descriptor.Data.Type == RoomType.ROOM_SECRET then
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and door:GetVariant() == DoorVariant.DOOR_LOCKED_BARRED then
                door:TryUnlock(Isaac.GetPlayer(0), true)
                SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, GreedFix.OnClear)


function GreedFix:NewRoom()
    local room = Game():GetRoom()
    local descriptor = Game():GetLevel():GetCurrentRoomDesc()
    if not (descriptor.SurpriseMiniboss and descriptor.Data.Type == RoomType.ROOM_SECRET and room:IsClear()) then return end
    Isaac.CreateTimer(function()
        for i = 0, DoorSlot.NUM_DOOR_SLOTS do
            local door = room:GetDoor(i)
            if door and not door:IsOpen() then
                --door:SetVariant(DoorVariant.DOOR_HIDDEN)
                door:TryUnlock(Isaac.GetPlayer(0), true)
                SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)
            end
        end
    end, 1, 1, false)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, GreedFix.NewRoom)

end
return GreedSecretRoomFixEnabler