--[[ Boss ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Boss room features
---@return boolean?
function mod:BossRoomAward()
    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS
    and room:GetType() ~= RoomType.ROOM_MINIBOSS
    and room:GetType() ~= RoomType.ROOM_BOSSRUSH then return end

    -- Clear traps
    local roomDesc = game:GetLevel():GetCurrentRoomDesc()
    roomDesc.PressurePlatesTriggered = true

    if room:GetType() ~= RoomType.ROOM_BOSS then return end

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
        return
    end

    local roomSize = {RoomShape.ROOMSHAPE_1x2, RoomShape.ROOMSHAPE_2x1, RoomShape.ROOMSHAPE_2x2}
    local roomVal = {{80, 144, 15}, {67, 183, 28}, {151, 267, 15}}

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

            if not (self:CheckRoom(RoomType.ROOM_BOSS, "DT") and self:HasConfig("doubletrouble_twoitems"))
            then return end

            -- Spawn trap door if not in mirror world
            if not room:IsMirrorWorld() then
                local trapPos = Isaac.GetFreeNearPosition(room:GetGridPosition(getVal[1] + 2), 0)

                -- Prevents overlapping
                local gridIndex = room:GetGridIndex(trapPos)
                local gridEntity = room:GetGridEntity(gridIndex)
                if gridEntity then room:RemoveGridEntity(gridIndex, 0, false) end

                Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapPos)
            end

            -- Spawn two items
            local player = Isaac.GetPlayer()
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
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.BossRoomAward)

-- Angel Room Jingle
---@param door GridEntityDoor
function mod:AngelDoorJingle(door)
    if not self:HasConfig("angeldoor_jingle") then return end -- config

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end

    if door.TargetRoomType ~= RoomType.ROOM_ANGEL then return end

    local spawnAngelDoor = door:GetSprite():IsPlaying("Open") and door:GetSprite():GetFrame() == 0
    if not spawnAngelDoor then return end

    sound:Stop(SoundEffect.SOUND_CHOIR_UNLOCK)
    sound:Play(Isaac.GetSoundIdByName("Holyfind"), 2)
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.AngelDoorJingle, GridEntityType.GRID_DOOR)

-- Double Trouble Boss Rush Music
---@param id Music
---@return Music
function mod:DoubleTroubleMusic(id)
    if not self:HasConfig("doubletrouble_music") then return id end -- config

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS or not self:CheckRoom(RoomType.ROOM_BOSS, "DT") then
        return id
    end

    -- Double Trouble Music
    local bossMusic = {
        [Music.MUSIC_BOSS] = true,
        [Music.MUSIC_BOSS2] = true,
        [Music.MUSIC_BOSS3] = true
    }

    if bossMusic[id] then
        if room:IsFirstVisit() then sound:Play(SoundEffect.SOUND_MOM_VOX_EVILLAUGH) end
        return Music.MUSIC_BOSS_RUSH
    end

    return id
end
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, mod.DoubleTroubleMusic)