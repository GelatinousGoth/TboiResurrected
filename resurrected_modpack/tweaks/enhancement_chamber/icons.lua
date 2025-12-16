--[[ MinimapAPI Icons ]]--
local mod = EnhancementChamber
local game = Game()

-- Room Icon Update
function mod:roomIconUpdate()
    if ModConfigMenu then
        local config = self.ConfigSpecial
        local level = game:GetLevel()
        for i = 0, level:GetRooms().Size - 1 do
            local roomDesc = level:GetRooms():Get(i)
            local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)

            -- Avoids getting nil value
            if not getRoom then return end

            if config["sacrifice"] and roomDesc.Data.Type == RoomType.ROOM_SACRIFICE
            and not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then

                getRoom.PermanentIcons = {"sacrifice_closed_icon"}

            elseif config["boss"]
            and self.checkRoom(RoomType.ROOM_BOSS, "DT", roomDesc) then

                getRoom.PermanentIcons = {"double_trouble_icon"}

            elseif config["grave"]
            and self.checkRoom(RoomType.ROOM_DEFAULT, "Grave", roomDesc) then

                getRoom.PermanentIcons = {"grave_icon"}

            elseif config["dice"]
            and roomDesc.Data.Type == RoomType.ROOM_DICE
            and self.Data.diceTriggered then

                getRoom.PermanentIcons = {"dice_triggered_icon"}
            end
        end
    end
end

-- Icon Data
local roomIcon = nil

local function ModSetup()
    -- Minimap Check
    if MinimapAPI then
        roomIcon = Sprite()
        roomIcon:Load("gfx/ui/room_icons.anm2", true)
    
        MinimapAPI:AddIcon("sacrifice_closed_icon", roomIcon, "IconSacrificeClosed", 0)
        MinimapAPI:AddIcon("double_trouble_icon", roomIcon, "IconDoubleTrouble", 0)
        MinimapAPI:AddIcon("grave_icon", roomIcon, "IconGrave", 0)
        MinimapAPI:AddIcon("dice_triggered_icon", roomIcon, "IconDiceTriggered", 0)
    
        function mod:iconStart()
            self:roomIconUpdate()
        end
        mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.iconStart)
    
        function mod:iconRoom()
            local level = game:GetLevel()
            local room = level:GetCurrentRoom()
            if room:IsFirstVisit() then self:roomIconUpdate() end
        end
        mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.iconRoom)
    
        function mod:iconLevel()
            self:roomIconUpdate()
        end
        mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.iconLevel)
    end
end


mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModSetup)