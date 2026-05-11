local function SleepForCrackedKeyEnabler()

local Sleep = {}
local mod = IsaacReflourished


function Sleep:PostSleep(giantbookID)
    if giantbookID ~= Giantbook.SLEEP_NIGHTMARE then return end
    Isaac.CreateTimer(function() 
        local trinkets = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)
        for _, trinket in pairs(trinkets) do
            trinket:ToPickup():Morph(5, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY)
        end
    end, 1, 1, true)
end
mod:AddCallback(ModCallbacks.MC_POST_ITEM_OVERLAY_SHOW, Sleep.PostSleep)

end
return SleepForCrackedKeyEnabler