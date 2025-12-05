--[[ Library ]]--
local mod = EnhancementChamber
local game = Game()

-- Library requirement
local function tryGenerateLibrary()
    local level = game:GetLevel()

    -- Avoids multiple libraries in the floor
    for i = 0, level:GetRooms().Size - 1 do
        local roomDesc = level:GetRooms():Get(i)
        if roomDesc.Data.Type == RoomType.ROOM_LIBRARY then
            return
        end
    end

    -- Avoids invalid floors
    if level:GetStage() > 10
    or level:GetStage() == 9
    or level:IsAscent()
    or game:IsGreedMode() then return end

    -- Tries to generate library
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

        -- Creates library room
        if not connectsToSecretRoom then
            level:TryPlaceRoom(roomConfig, gridIndex, -1, seed, false)
            return
        end
    end
end

-- Library Generation
function mod:libraryPostLevel()
    local player = Isaac.GetPlayer(0)
    local bookCount = 0
    local primaryItem = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
    local secondaryItem = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY))

    if primaryItem and primaryItem:HasTags(ItemConfig.TAG_BOOK) then bookCount = bookCount + 1 end
    if secondaryItem and secondaryItem:HasTags(ItemConfig.TAG_BOOK) then bookCount = bookCount + 1 end

    if bookCount > 0 then
        local rng = self.RNG
        local chance = rng:RandomInt(5 - bookCount) -- 25-33% chance
        if chance == 0 then tryGenerateLibrary() end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.libraryPostLevel)

-- One Item Choice
function mod:libraryPostRoom()
    local room = game:GetLevel():GetCurrentRoom()

    -- Checks library room
    if room:GetType() == RoomType.ROOM_LIBRARY and room:IsFirstVisit() then

        -- Choice items
        local items = Isaac.FindByType(5, 100)
        for i = 1, #items do
            if not items[i]:ToPickup():IsShopItem() then items[i]:ToPickup().OptionsPickupIndex = 1 end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.libraryPostRoom)