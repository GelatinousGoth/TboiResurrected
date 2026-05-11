local function MoreLibrariesEnabler()

local MoreLibraries = {}
local mod = IsaacReflourished


-- mod:AddCallback(ModCallbacks.MC_HUD_RENDER, function()
--     local hasBook = "Has Book"
--     if Game():GetStateFlag(GameStateFlag.STATE_BOOK_PICKED_UP) == false then
--         hasBook = "No Book"
--     end
--     Isaac.RenderText(hasBook, 40, 40, 1, 1, 1, 1)

-- end)

function MoreLibraries:CheckLibraryState()
    Game():SetStateFlag(GameStateFlag.STATE_BOOK_PICKED_UP, true)
    local itemConfig = Isaac.GetItemConfig()
    for i, player in pairs(PlayerManager.GetPlayers()) do
        for _, slot in pairs(ActiveSlot) do
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then return end
            local item = player:GetActiveItem(slot)
            if item and itemConfig:GetCollectible(item) and itemConfig:GetCollectible(item):HasTags(ItemConfig.TAG_BOOK) then
                return
            end
        end
    end
    Game():SetStateFlag(GameStateFlag.STATE_BOOK_PICKED_UP, false)
end


mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item)
    local itemConfig = Isaac.GetItemConfig()
    if itemConfig:GetCollectible(item) and itemConfig:GetCollectible(item):HasTags(ItemConfig.TAG_BOOK) then
        MoreLibraries:CheckLibraryState()
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, item)
    local itemConfig = Isaac.GetItemConfig()
    if itemConfig:GetCollectible(item) and itemConfig:GetCollectible(item):HasTags(ItemConfig.TAG_BOOK) then
        MoreLibraries:CheckLibraryState()
    end
end)

end
return MoreLibrariesEnabler