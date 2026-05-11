local function AutoSwapActiveEnabler()

local mod = IsaacReflourished
local AutoSwapActive = {}

local shouldPressDrop = {}


function AutoSwapActive:PressDrop(entity, inputHook, buttonAction)
    if buttonAction ~= ButtonAction.ACTION_DROP then return end
    local player = entity and entity:ToPlayer()
    if not player then return end

    if not (shouldPressDrop[player.ControllerIndex] and shouldPressDrop[player.ControllerIndex] > 0) then return end
    shouldPressDrop[player.ControllerIndex] = (shouldPressDrop[player.ControllerIndex] or 1) - 1
    player:SwapActiveItems()
    return true
end
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, AutoSwapActive.PressDrop, InputHook.IS_ACTION_TRIGGERED)

---@param player EntityPlayer
function AutoSwapActive:AddPocketItem(player)
    if not REPENTANCE_PLUS then return end
    local FrontNewPickups = IsaacReflourished:GetSettingsValue("AutoSwapFrontNewPickups") == 2
    if not FrontNewPickups then return end

    local index = player.ControllerIndex
    if player:GetPocketItem(PillCardSlot.SECONDARY):GetType() == PocketItemType.ACTIVE_ITEM and
    player:GetPocketItem(PillCardSlot.SECONDARY):GetSlot() == ActiveSlot.SLOT_POCKET+1 then
        shouldPressDrop[index] = (shouldPressDrop[index] or 0) + 1
    elseif player:GetPocketItem(PillCardSlot.PRIMARY):GetType() == PocketItemType.ACTIVE_ITEM then

        shouldPressDrop[index] = (shouldPressDrop[index] or 0) + 1

    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_PILL, AutoSwapActive.AddPocketItem)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_CARD, AutoSwapActive.AddPocketItem)


function AutoSwapActive:NewRoom(player)
    local FrontNewRoom = IsaacReflourished:GetSettingsValue("AutoSwapFrontNewRoom") == 2
    if not FrontNewRoom then return end

    local index = player.ControllerIndex
    if player:GetPocketItem(PillCardSlot.SECONDARY):GetType() == PocketItemType.ACTIVE_ITEM and
    player:GetPocketItem(PillCardSlot.SECONDARY):GetSlot() == ActiveSlot.SLOT_POCKET+1 then
        shouldPressDrop[index] = (shouldPressDrop[index] or 0) + 1

    elseif player:GetPocketItem(PillCardSlot.TERTIARY):GetType() == PocketItemType.ACTIVE_ITEM and
    player:GetPocketItem(PillCardSlot.TERTIARY):GetSlot() == ActiveSlot.SLOT_POCKET+1 then
        shouldPressDrop[index] = (shouldPressDrop[index] or 0) + 2
        
    elseif player:GetPocketItem(PillCardSlot.QUATERNARY):GetType() == PocketItemType.ACTIVE_ITEM and
    player:GetPocketItem(PillCardSlot.QUATERNARY):GetSlot() == ActiveSlot.SLOT_POCKET+1 then
        shouldPressDrop[index] = (shouldPressDrop[index] or 0) + 3
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, AutoSwapActive.NewRoom)

end
return AutoSwapActiveEnabler