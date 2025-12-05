--[[ Boss ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Boss room features
function mod:bossRoomClear()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

    -- Checks boss room
    if room:GetType() == RoomType.ROOM_BOSS then

        -- Gets rid of grid entities blocking item in the bottom
        if room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
            for i = 0, room:GetGridSize() - 1 do
                local gridEntity = room:GetGridEntity(i)
                if gridEntity and gridEntity:GetGridIndex() > 110 and gridEntity:GetGridIndex() < 114 then
                    if not gridEntity:ToPit() then
                        gridEntity:Destroy(false)
                    else
                        gridEntity:ToPit():MakeBridge(nil)
                    end
                end
            end
        end

        -- Double Trouble Rewards --
        if self.checkRoom(RoomType.ROOM_BOSS, "DT") then
            local roomSize = {RoomShape.ROOMSHAPE_1x2, RoomShape.ROOMSHAPE_2x1, RoomShape.ROOMSHAPE_2x2}
            local roomVal = {{80, 144, 15}, {67, 183, 28}, {151, 267, 15}}

            -- Room size variants
            for idx, size in ipairs(roomSize) do
                if room:GetRoomShape() == size then
                    local getVal = roomVal[idx]
                    for i = 0, room:GetGridSize() - 1 do
                        local gridEntity = room:GetGridEntity(i)
                        if gridEntity then
                            local gridPos = room:GetGridIndex(gridEntity.Position)
                            local dist = math.floor(getVal[3] / 2)
                            if gridPos > getVal[1] and
                            gridPos < getVal[2]
                            and (gridPos % getVal[3] > dist - 1 and gridPos % getVal[3] < dist + 1) then
                                if gridEntity.Desc.Type ~= GridEntityType.GRID_PIT then
                                    gridEntity:Destroy(true)
                                else
                                    gridEntity:ToPit():MakeBridge(nil)
                                    gridEntity:Update()
                                end
                            end
                        end
                    end

                    -- Spawn trap door if not in mirror world
                    if not room:IsMirrorWorld() then
                        local trapPos = Isaac.GetFreeNearPosition(room:GetGridPosition(getVal[1] + 2), 0)
                        Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapPos)
                    end

                    -- Spawn two items
                    local player = Isaac.GetPlayer(0)
                    local itemPos1 = Isaac.GetFreeNearPosition(room:GetGridPosition(getVal[2] - 1), 0)
                    local itemPos2 = Isaac.GetFreeNearPosition(room:GetGridPosition(getVal[2] - 3), 0)
                    if not player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS) then
                        Isaac.Spawn(5, 100, 0, itemPos1, Vector.Zero, nil):ToPickup().OptionsPickupIndex = 10
                        Isaac.Spawn(5, 100, 0, itemPos2, Vector.Zero, nil):ToPickup().OptionsPickupIndex = 10
                    else -- There's Options synergy
                        Isaac.Spawn(5, 100, 0, itemPos1, Vector.Zero, nil)
                        Isaac.Spawn(5, 100, 0, itemPos2, Vector.Zero, nil)
                    end
                    return true -- Prevents default rewards
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.bossRoomClear)

-- Angel Room Jingle
---@param door GridEntityDoor
function mod:bossAngelJingle(door)
    local room = game:GetLevel():GetCurrentRoom()
    -- Checks boss room
    if room:GetType() == RoomType.ROOM_BOSS then
        local spawnAngelDoor = door:GetSprite():IsPlaying("Open") and door:GetSprite():GetFrame() == 0
        if door.TargetRoomType == RoomType.ROOM_ANGEL and spawnAngelDoor then
            sound:Stop(SoundEffect.SOUND_CHOIR_UNLOCK)
            sound:Play(Isaac.GetSoundIdByName("Holyfind"), 2)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.bossAngelJingle, GridEntityType.GRID_DOOR)

-- Double Trouble Boss Rush Music
---@param id Music
function mod:bossPreMusic(id)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

    -- Checks double trouble
    if room:GetType() == RoomType.ROOM_BOSS and self.checkRoom(RoomType.ROOM_BOSS, "DT") then

        -- Double Trouble Music
        local bossMusic = {
            [Music.MUSIC_BOSS] = true,
            [Music.MUSIC_BOSS2] = true,
            [Music.MUSIC_BOSS3] = true
        }

        if bossMusic[id] then
            return Music.MUSIC_BOSS_RUSH
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, mod.bossPreMusic)

-- Ultra Hard variable
local ultraHard = false

-- Fix crash related to Double Trouble in Ultra Hard Challenge
function mod:bossPreUltraHard()
    if game.Challenge == Challenge.CHALLENGE_ULTRA_HARD then
        ultraHard = true
        game.Challenge = 0
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, mod.bossPreUltraHard)

-- Adds missing curses to Ultra Hard challenge
function mod:bossPostUltraHard()
    if ultraHard then
        local level = game:GetLevel()
        ultraHard = false
        ---@type integer
        local flags = 1 << 2 | 1 << 5 | 1 << 6
        level:AddCurse(flags, true)
        game.Challenge = 34
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.bossPostUltraHard)