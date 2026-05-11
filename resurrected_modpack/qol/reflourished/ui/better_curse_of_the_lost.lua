local function BetterCurseOfTheLostEnabler()

--TODO Reset the tracked visited rooms when going to new floor from blind floor
local mod = IsaacReflourished
BetterLostCurse = {}

local game = Game()

local regularRoomTypes = {
    [RoomType.ROOM_NULL] = true,
    [RoomType.ROOM_DEFAULT] = true,
    [RoomType.ROOM_GREED_EXIT] = true,
    [RoomType.ROOM_TELEPORTER] = true
}

local secretRoomTypes = {
    [RoomType.ROOM_SECRET] = true,
    [RoomType.ROOM_SUPERSECRET] = true
}

local hadCurse = false

function BetterLostCurse:PreMapRender()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    local level = Game():GetLevel()
    if level:GetCurses() & LevelCurse.CURSE_OF_THE_LOST > 0 then
        level:RemoveCurses(LevelCurse.CURSE_OF_THE_LOST)
        hadCurse = true
    end
end

--Game():GetLevel():RemoveCurses(LevelCurse.CURSE_OF_THE_UNKNOWN)

function BetterLostCurse:PostMapRender()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    local level = Game():GetLevel()
    if hadCurse then
        level:AddCurse(LevelCurse.CURSE_OF_THE_LOST, false)
        hadCurse = false
    end
end


local RoomStates = {}


function BetterLostCurse:HideRooms()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    local level = game:GetLevel()

    --if MinimapAPI then return end

    if level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) then return end

    local currentRoomIndex = level:GetCurrentRoomIndex()

    local mappingItemsWork = IsaacReflourished:GetSettingsValue("ReworkedLostCurseMapItems") == 2

    local allowedRooms = {}
    for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = game:GetRoom():GetDoor(slot)

        if door then
            local idx  = door.TargetRoomIndex
            local desc = level:GetRoomByIdx(idx)
            allowedRooms[desc.SafeGridIndex] = true
        end
    end

    if mappingItemsWork and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_SPELUNKER_HAT) then
        for index, _ in pairs(allowedRooms) do
            local roomDesc = level:GetRoomByIdx(index)
            local allowedDoors = roomDesc.AllowedDoors
            for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                if allowedDoors & (1 << slot) ~= 0 then
                    allowedRooms[roomDesc.Doors[slot]] = true
                end
            end
        end
    end

    allowedRooms[currentRoomIndex] = true

    local roomsList = level:GetRooms()
    for i = 0, roomsList.Size - 1 do
        local roomDesc = roomsList:Get(i)
        local index = roomDesc.SafeGridIndex
        local roomType = roomDesc.Data.Type

        local miniMapiRoom = MinimapAPI and MinimapAPI:GetRoomByIdx(index)

        if miniMapiRoom then
            if miniMapiRoom.DisplayFlags ~= 000 then
                RoomStates[index] = miniMapiRoom.DisplayFlags
            end
        else
            if roomDesc.DisplayFlags ~= 000 then
                RoomStates[index] = roomDesc.DisplayFlags
            end
        end

        if allowedRooms[index] then
            --Re-reveal visited adjacent secret rooms because the game does not naturally do so once they are re-hidden
            if secretRoomTypes[roomType] and roomDesc.Clear then
                roomDesc.DisplayFlags = 101
            end
            --Don't Hide
        elseif mappingItemsWork and secretRoomTypes[roomType] and (level:GetStateFlag(LevelStateFlag.STATE_BLUE_MAP_EFFECT) or PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LUNA)) then
            --Don't Hide
        elseif mappingItemsWork and level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) and not (regularRoomTypes[roomType] or secretRoomTypes[roomType]) then
            --Don't Hide
        elseif mappingItemsWork and level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) then
            local shouldReveal = true
            if (secretRoomTypes[roomType] or roomType == RoomType.ROOM_ULTRASECRET) then --treasure map only shows secret rooms if they've been cleared
                shouldReveal = roomDesc.Clear
            end
            if shouldReveal then
                if MinimapAPI and MinimapAPI:GetRoomByIdx(index) then
                    MinimapAPI:GetRoomByIdx(index).DisplayFlags = 001
                end
                roomDesc.DisplayFlags = 001
            end
        else
            if MinimapAPI and MinimapAPI:GetRoomByIdx(index) then
                MinimapAPI:GetRoomByIdx(index).DisplayFlags = 000
            end
            roomDesc.DisplayFlags = 000
        end

    end

    level:UpdateVisibility()
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_LOST ~= 0 then
        if MinimapAPI then
            if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then 
                MinimapAPI.Config.OverrideLost = false
            else
                MinimapAPI.Config.OverrideLost = true
            end
        end
        BetterLostCurse:HideRooms()
    end
end)


function BetterLostCurse:RevealRooms()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    local level = game:GetLevel()
    local dimension = level:GetDimension()

    for index, flags in pairs(RoomStates) do
        if MinimapAPI then
            local room = MinimapAPI:GetRoomByIdx(index)
            if room then
                room.DisplayFlags = flags
            end
        else
            local roomDesc = level:GetRoomByIdx(index, dimension)
            if roomDesc then
                roomDesc.DisplayFlags = flags
            end
        end
    end

    level:UpdateVisibility()
end


local hasCurseLost = false

-- mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
--     hasCurseLost = false

-- end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_LOST ~= 0 then
        if not hasCurseLost then
            hasCurseLost = true
            BetterLostCurse:HideRooms()
        end
    else -- Doesnt have lost curse
        if hasCurseLost then
            hasCurseLost = false
            BetterLostCurse:RevealRooms()
        end
    end

end)

local function getCurseCount()
    local curses = Game():GetLevel():GetCurses()
    local count = 0
    while curses > 0 do
        if curses & 1 ~= 0 then
            count = count + 1
        end
        curses = curses >> 1
    end

    local level = Game():GetLevel()
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_RESTOCK) then
        count = count + 1
    end
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MIND) then
        count = count + 1
        return count
    end
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_TREASURE_MAP) then
        count = count + 1
    end
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BLUE_MAP) then
        count = count + 1
    end
    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_COMPASS) then
        count = count + 1
    end
    --print(count)
    return count
end

local icon = Sprite()
icon:Load("gfx/ui/mapitemicons.anm2")
icon:SetFrame("curses", 2)

function BetterLostCurse:RenderMapIcon()
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    if game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
        return
    end
    if Game():GetLevel():GetCurrentRoomDesc().Data.StageID == 35
        and Game():GetRoom():GetType() == RoomType.ROOM_DUNGEON then
        return -- In Beast fight
    end
    if not hasCurseLost then return end

    local pos = Vector(5.5, 10)

    local curseCount = getCurseCount()

    local curseCountOffset = 16
    if curseCount > 4 then
        curseCountOffset = curseCountOffset - (curseCount - 4)
    end
    pos.X = pos.X + ((curseCount - 1) * curseCountOffset)


    local displaySize = Minimap.GetDisplayedSize()
    local sizeOffset = (displaySize.X == 47 and displaySize.Y == 47) and 4 or 3
    pos = pos + Vector(sizeOffset, displaySize.Y)

    local MapColor = Minimap.GetItemIconsSprite().Color
    icon.Color = MapColor

    pos = pos + Vector(24, 14) * Options.HUDOffset

    local screenWidth = Isaac.GetScreenWidth()
    pos.X = screenWidth - pos.X

    if not RoomTransition.IsRenderingBossIntro() then
        icon:Render(pos)
    end
end


mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function(_, curse)
    if Game().Challenge == Challenge.CHALLENGE_ULTRA_HARD then return end
    local hasLost = curse & LevelCurse.CURSE_OF_THE_LOST ~= 0

    if hasLost then
        -- Curse just applied
        hasCurseLost = true
        -- Save current room states if needed
    else
        -- Curse just removed
        hasCurseLost = false
        -- Restore saved room states
    end
end)


function IsaacReflourished:SetMiniMapiMode()
    if MinimapAPI then
        MinimapAPI.Config.OverrideLost = true
    else
        mod:AddCallback(ModCallbacks.MC_HUD_RENDER, BetterLostCurse.PreMapRender)
        mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, BetterLostCurse.PostMapRender)
        mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, BetterLostCurse.RenderMapIcon)
    end
end


mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
    IsaacReflourished:SetMiniMapiMode()
end)
if Isaac.GetFrameCount() > 0 then IsaacReflourished:SetMiniMapiMode() end

end
return BetterCurseOfTheLostEnabler