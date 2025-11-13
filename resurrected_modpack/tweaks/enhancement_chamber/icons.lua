--[[ MinimapAPI Icons ]]--
local mod = EnhancementChamber
local hasMinimap = mod.HasMinimap
local data = mod.Data
local config = mod.ConfigSpecial
local game = Game()

-- Room Icon Update --
function mod.roomIconUpdate()
    if hasMinimap then
        local level = game:GetLevel()
        for i = 0, level:GetRooms().Size - 1 do
            local roomDesc = level:GetRooms():Get(i)
            local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)
            if config["sacrifice"] and roomDesc.Data.Type == RoomType.ROOM_SACRIFICE and not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then
                getRoom.PermanentIcons = {"sacrifice_closed_icon"}
            elseif config["boss"] and mod.checkRoom(RoomType.ROOM_BOSS, "DT", roomDesc) then
                getRoom.PermanentIcons = {"double_trouble_icon"}
            elseif config["grave"] and mod.checkRoom(RoomType.ROOM_DEFAULT, "Grave", roomDesc) then
                getRoom.PermanentIcons = {"grave_icon"}
            elseif config["dice"] and roomDesc.Data.Type == RoomType.ROOM_DICE and data.diceTriggered then
                getRoom.PermanentIcons = {"dice_triggered_icon"}
            elseif config["shop"] and roomDesc.VisitedCount > 0 then
                if mod.checkRoom(RoomType.ROOM_SHOP, "Golden", roomDesc) then
                    getRoom.PermanentIcons = {"golden_shop_icon"}
                elseif mod.checkRoom(RoomType.ROOM_SHOP, "Junk", roomDesc) then
                    getRoom.PermanentIcons = {"junk_shop_icon"}
                end
            end
        end
    end
end

-- Icon Data --
local altarIcon = nil
local roomIcon = nil

-- Minimap Check --
if hasMinimap then
    altarIcon = Sprite()
    altarIcon:Load("gfx/ui/altar_icons.anm2", true)

    roomIcon = Sprite()
    roomIcon:Load("gfx/ui/room_icons.anm2", true)

    MinimapAPI:AddIcon("devil_altar_icon", altarIcon, "IconDevilAltar", 0)
    MinimapAPI:AddIcon("angel_altar_icon", altarIcon, "IconAngelAltar", 0)
    MinimapAPI:AddIcon("sacrifice_closed_icon", roomIcon, "IconSacrificeClosed", 0)
    MinimapAPI:AddIcon("double_trouble_icon", roomIcon, "IconDoubleTrouble", 0)
    MinimapAPI:AddIcon("grave_icon", roomIcon, "IconGrave", 0)
    MinimapAPI:AddIcon("dice_triggered_icon", roomIcon, "IconDiceTriggered", 0)
    MinimapAPI:AddIcon("golden_shop_icon", roomIcon, "IconGoldenShop", 0)
    MinimapAPI:AddIcon("junk_shop_icon", roomIcon, "IconJunkShop", 0)
    
    MinimapAPI:AddPickup("Devil Altar", "devil_altar_icon", 6, 88, -1, nil, "altars", 14000)
    MinimapAPI:AddPickup("Angel Altar", "angel_altar_icon", 6, 89, -1, nil, "altars", 14000)

    function mod:iconStart(isContinue)
        mod.roomIconUpdate()
    end
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.iconStart)

    function mod:iconRoom()
        local level = game:GetLevel()
        local room = level:GetCurrentRoom()
        if room:IsFirstVisit() then mod.roomIconUpdate() end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.iconRoom)

    function mod:iconLevel()
        mod.roomIconUpdate()
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.iconLevel)
end