--[[ Library ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local rng = mod.RNG
local game = Game()

-- Library requirement
local function tryGenerateLibrary()
    local level = game:GetLevel()
    -- Library check --
    for i = 0, level:GetRooms().Size - 1 do
        local roomDesc = level:GetRooms():Get(i)
        if roomDesc.Data.Type == RoomType.LIBRARY then
            return
        end
    end
    -- Try to generate library --
    if level:GetStage() <= 10 and level:GetStage() ~= 9 and not level:IsAscent() and not game:IsGreedMode() then
        local seed = level:GetDungeonPlacementSeed()
        local roomConfig = RoomConfigHolder.GetRandomRoom(seed, true, StbType.SPECIAL_ROOMS, RoomType.ROOM_LIBRARY, RoomShape.ROOMSHAPE_1x1, 0, 17)
        local options = level:FindValidRoomPlacementLocations(roomConfig, -1, false, false)
        for _, gridIndex in pairs(options) do
            local neighbors = level:GetNeighboringRooms(gridIndex, roomConfig.Shape)
            local connectsToSecretRoom = false
            -- Prevents generating adjacent to secret and super secret rooms
            for _, neighborDesc in pairs(neighbors) do
                if neighborDesc.GridIndex == level:GetStartingRoomIndex() or neighborDesc.Data.Type == RoomType.ROOM_SECRET or neighborDesc.Data.Type == RoomType.ROOM_SUPERSECRET then
                    connectsToSecretRoom = true
                    break
                end
            end
            -- Creates challenge room
            if not connectsToSecretRoom then
                level:TryPlaceRoom(roomConfig, gridIndex, -1, seed, false)
                return
            end
        end
    end
end

-- Library Generation --
function mod:libraryPostLevel()
    if not config["library"] then return end
    local player = Isaac.GetPlayer(0)
    local bookCount = 0
    local primaryItem = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
    local secondaryItem = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY))
    if primaryItem and primaryItem:HasTags(ItemConfig.TAG_BOOK) then bookCount = bookCount + 1 end
    if secondaryItem and secondaryItem:HasTags(ItemConfig.TAG_BOOK) then bookCount = bookCount + 1 end
    if bookCount > 0 then
        local chance = rng:RandomInt(5 - bookCount) -- 25-33% chance
        if chance == 0 then tryGenerateLibrary() end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.libraryPostLevel)

-- One Item Choice --
function mod:libraryPostRoom()
    if not config["library"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_LIBRARY and room:IsFirstVisit() then
        local items = Isaac.FindByType(5, 100, -1)
        for i = 1, #items do
            if not items[i]:ToPickup():IsShopItem() then items[i]:ToPickup().OptionsPickupIndex = 1 end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.libraryPostRoom)