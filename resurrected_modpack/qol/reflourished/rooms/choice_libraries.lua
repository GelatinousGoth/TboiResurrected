local function ChoiceLibrariesEnabler()

local ChoiceLibraries = {}
local mod = IsaacReflourished



function ChoiceLibraries:NewRoom()
    local room = Game():GetRoom()
    if not room:IsFirstVisit() then return end
    if room:GetType() ~= RoomType.ROOM_LIBRARY then return end
    local pedestals = Isaac.FindByType(5, 100)
    for _, pedestal in pairs(pedestals) do
        local item = pedestal:ToPickup()
        if item and (item.OptionsPickupIndex == 0) then
            item.OptionsPickupIndex = 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ChoiceLibraries.NewRoom)


-- mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
--     Isaac.GetPlayer():AddCollectible(CollectibleType.COLLECTIBLE_MIND)
    
--     Isaac.GetPlayer():AddCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
--     Isaac.GetPlayer():AddCollectible(CollectibleType.COLLECTIBLE_MERCURIUS)

--     Isaac.ExecuteCommand("debug 3")
--     Isaac.ExecuteCommand("debug 4")
    
    

-- end)

end
return ChoiceLibrariesEnabler