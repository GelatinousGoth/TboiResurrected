--[[ MinimapAPI Icons ]]--
local mod = EnhancementChamber
local game = Game()

-- Room Icon Update
function EnhancementChamber:RoomIconUpdate()
    if not MinimapAPI then return end

    local level = game:GetLevel()
    for i = 0, level:GetRooms().Size - 1 do
        local roomDesc = level:GetRooms():Get(i)
        local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)

        -- Avoids getting nil value
        if not getRoom then goto continue end

        -- Boss room concealment
        if self:HasConfig("boss_hiddenshape")
        and roomDesc.Data.Type == RoomType.ROOM_BOSS
        and roomDesc.Data.Shape ~= RoomShape.ROOMSHAPE_1x1 then

            local originalShape = roomDesc.Data.Shape

            -- Get relative position
            ---@param position Vector
            ---@param shape? RoomShape
            local function IsPositionInRoom(room, position, shape)
                shape = shape or room.Shape
                local cells = MinimapAPI.RoomShapePositions[shape]
                if not cells then return false end

                local relative = position - room.Position
                for _, cell in ipairs(cells) do
                    if cell.X == relative.X and cell.Y == relative.Y then
                        return true
                    end
                end

                return false
            end

            -- Get door adjacent to room
            ---@return DoorSlot?
            local function FindConnectingDoorSlot(fromRoom, toRoom, toShape)
                for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                    local candidate = MinimapAPI:GetPositionRelativeToDoor(fromRoom, slot)

                    if candidate and IsPositionInRoom(toRoom, candidate, toShape) then
                        return slot
                    end
                end

                return nil
            end

            if roomDesc.VisitedCount > 0 then
                getRoom.Shape = roomDesc.Data.Shape
                getRoom.DisplayPosition = nil
            else
                local adj = getRoom:GetAdjacentRooms()

                if #adj > 0 then
                    local neighbor = adj[1]
                    local slot = FindConnectingDoorSlot(neighbor, getRoom, originalShape)

                    getRoom.Shape = RoomShape.ROOMSHAPE_1x1

                    if slot then
                        -- Adjacent Boss room
                        getRoom.DisplayPosition = MinimapAPI:GetPositionRelativeToDoor(neighbor, slot)
                    else
                        -- Extremely rare fallback
                        getRoom.DisplayPosition = neighbor.Position + Vector(1, 0)
                    end
                else
                    getRoom.Shape = RoomShape.ROOMSHAPE_1x1
                end
            end
        end

        -- Sacrifice primary icon
        if self:HasConfig("sacrifice_condition")
        and roomDesc.Data.Type == RoomType.ROOM_SACRIFICE
        and not self.Data.floorCleared then

            getRoom.PermanentIcons = {"sacrifice_closed_icon"}

        -- Double trouble icon
        elseif self:CheckRoom(RoomType.ROOM_BOSS, "DT", roomDesc)
        and (roomDesc.VisitedCount > 0 or not self:HasConfig("boss_hiddenshape")) then

            getRoom.PermanentIcons = {"double_trouble_icon"}

        -- Grave icon
        elseif self:HasConfig("grave_ambience")
        and self:CheckRoom(RoomType.ROOM_DEFAULT, "Grave", roomDesc) then

            getRoom.PermanentIcons = {"grave_icon"}

        -- Dice icon after triggered
        elseif roomDesc.Data.Type == RoomType.ROOM_DICE
        and self.Data.diceTriggered then

            getRoom.PermanentIcons = {"dice_triggered_icon"}
        end

        ::continue::
    end
end

-- Icon Data
local altarIcon
local roomIcon

-- Minimap Check
if MinimapAPI then

    roomIcon = Sprite()
    roomIcon:Load("gfx/ui/room_icons.anm2", true)

    MinimapAPI:AddIcon("sacrifice_closed_icon", roomIcon, "IconSacrificeClosed", 0)
    MinimapAPI:AddIcon("double_trouble_icon", roomIcon, "IconDoubleTrouble", 0)
    MinimapAPI:AddIcon("grave_icon", roomIcon, "IconGrave", 0)
    MinimapAPI:AddIcon("dice_triggered_icon", roomIcon, "IconDiceTriggered", 0)
    MinimapAPI:AddIcon("golden_shop_icon", roomIcon, "IconGoldenShop", 0)
    MinimapAPI:AddIcon("junk_shop_icon", roomIcon, "IconJunkShop", 0)

    function mod:IconStart()
        self:RoomIconUpdate()
    end
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.IconStart)

    function mod:IconRoom()
        local level = game:GetLevel()
        local room = level:GetCurrentRoom()
        if room:IsFirstVisit() then self:RoomIconUpdate() end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.IconRoom)

    function mod:IconLevel()
        self:RoomIconUpdate()
    end
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.IconLevel)
end