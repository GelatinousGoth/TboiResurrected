--[[ Boss ]]--
local mod = EnhancementChamber
local config = mod.ConfigSpecial
local configM = mod.ConfigMisc
local game = Game()
local sound = SFXManager()

local MAUSOLEUM_DOOR_FLAG = 301998208

function mod:bossRoomClear(rng, spawn)
    if not config["boss"] then return end
    local player = Isaac.GetPlayer(0)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

    -- Gets rid of grid entities blocking item in the bottom --
    if room:GetType() == RoomType.ROOM_BOSS and room:GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then
        for i = 0, room:GetGridSize() - 1 do
            local gridEntity = room:GetGridEntity(i)
            if gridEntity and gridEntity:GetGridIndex() >= 111 and gridEntity:GetGridIndex() < 114 then
                if not gridEntity:ToPit() then gridEntity:Destroy(false) else gridEntity:ToPit():MakeBridge(nil) end
            end
        end
    end

    -- Double Trouble Rewards --
    if mod.checkRoom(RoomType.ROOM_BOSS, "DT") then
        local roomSize = {4, 6, 8}
        local posX = {320, 600, 600}
        local posY = {400, 200, 400}
        -- Room size variants
        for i = 1, 3 do
            if room:GetRoomShape() == roomSize[i] then
                for j = 0, room:GetGridSize() - 1 do
                    local gridEntity = room:GetGridEntity(j)
                    if gridEntity then
                        local gridDistanceX = gridEntity.Position.X >= posX[i] - 80 and gridEntity.Position.X <= posX[i] + 80
                        local gridDistanceY = gridEntity.Position.Y >= posY[i] - 40 and gridEntity.Position.Y <= posY[i] + 160
                        if gridDistanceX and gridDistanceY then
                            if gridEntity.Desc.Type ~= GridEntityType.GRID_PIT then
                                gridEntity:Destroy(true)
                            else
                                gridEntity:ToPit():MakeBridge(nil)
                                gridEntity:Update()
                            end
                        end
                    end
                end
                if not room:IsMirrorWorld() then Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Isaac.GetFreeNearPosition(Vector(posX[i], posY[i]), 0), true) end
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_THERES_OPTIONS) then
                    Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]-40, posY[i]+120), 0), Vector(0,0), nil):ToPickup().OptionsPickupIndex = 10
                    Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]+40, posY[i]+120), 0), Vector(0,0), nil):ToPickup().OptionsPickupIndex = 10
                else -- There's Options synergy
                    Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]-40, posY[i]+120), 0), Vector(0,0), nil)
                    Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]+40, posY[i]+120), 0), Vector(0,0), nil)
                end
                break
            end
        end
        return true -- Prevents default rewards
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.bossRoomClear)

-- Angel Room Jingle
function mod:bossAngelJingle(door)
    if not config["boss"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BOSS then
        local spawnAngelDoor = door:GetSprite():IsPlaying("Open") and door:GetSprite():GetFrame() == 0
        if door.TargetRoomType == RoomType.ROOM_ANGEL and spawnAngelDoor then
            sound:Stop(SoundEffect.SOUND_CHOIR_UNLOCK)
            sound:Play(Isaac.GetSoundIdByName("Holyfind"), 2, 2, false, 1, 0)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.bossAngelJingle, GridEntityType.GRID_DOOR)

-- Getting random items trigger boss sound instead of angel one --
function mod:bossPreSound(id, _, _, loop, pitch, pan)
    if not config["boss"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    -- Change default item sound
    if id == SoundEffect.SOUND_CHOIR_UNLOCK then
        if room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_ANGEL then
            sound:Play(SoundEffect.SOUND_POWERUP2, 1, framedelay, loop, pitch, pan)
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.bossPreSound)

-- Double Trouble Boss Rush Music --
function mod:bossPreMusic(id)
    if not config["boss"] then return end
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    -- Double Trouble Music --
    if room:GetType() == RoomType.ROOM_BOSS and mod.checkRoom(RoomType.ROOM_BOSS, "DT") then
        if id == Music.MUSIC_BOSS or id == Music.MUSIC_BOSS2 or id == Music.MUSIC_BOSS3 then
            return Music.MUSIC_BOSS_RUSH
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, mod.bossPreMusic)

-- Mausoleum Door: Red Heart Damage --
function mod:bossMausoleumDoorPreDamage(player, _, flags)
    if not configM["redHeartDamage"] then return end
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() == RoomType.ROOM_BOSS and flags == MAUSOLEUM_DOOR_FLAG and not player:HasTrinket(TrinketType.TRINKET_CROW_HEART) then
        player:GetData().mausoleum_door_check = true
        player:AddSmeltedTrinket(TrinketType.TRINKET_CROW_HEART, false)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, mod.bossMausoleumDoorPreDamage)

function mod:bossMausoleumDoorPostDamage(entity)
    local player = entity:ToPlayer()
    if player and player:GetData().mausoleum_door_check then
        player:GetData().mausoleum_door_check = nil
        player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_CROW_HEART)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.bossMausoleumDoorPostDamage, EntityType.ENTITY_PLAYER)

-- Fix crash related to Double Trouble in Ultra Hard Challenge --
local ultraHard = false

function mod:bossPreUltraHard()
    if game.Challenge == Challenge.CHALLENGE_ULTRA_HARD then
        ultraHard = true
        game.Challenge = 0
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, mod.bossPreUltraHard)

function mod:bossPostUltraHard()
    if ultraHard then
        local level = game:GetLevel()
        ultraHard = false
        level:AddCurse(1 << 2 | 1 << 5 | 1 << 6, false)
        game.Challenge = 34
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.bossPostUltraHard)