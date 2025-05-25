local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Enhancement Chamber", 1, true)

local mod = EnhancementChamber
local game = Game()
local music = MusicManager()
local sound = SFXManager()
local volume = Options.MusicVolume

-- Repentogon check --
if not REPENTOGON then error("Enhancement Chamber requires Repentogon!") end

-- MiniMAPI check --
local hasMinimap = true
if not MinimapAPI then hasMinimap = false end

-- Local variables --
local currentMusic = nil
local roomIcon = nil

-- Local functions --
local function sacrificeCondition(room)
    local level = game:GetLevel()
    local roomCount = 0
    local clearedRoomCount = 0
    local hasSacrificeRoom = false
    for i = 0, level:GetRooms().Size - 1 do
        local roomDesc = level:GetRooms():Get(i)
        if roomDesc.Data.Type == RoomType.ROOM_DEFAULT and roomDesc.Data.Subtype == 0 and not roomDesc.Clear then
            roomCount = roomCount + 1
            if roomDesc.Clear then
                clearedRoomCount = clearedRoomCount + 1
            end
        end
        if roomDesc.Data.Type == RoomType.ROOM_SACRIFICE then
            hasSacrificeRoom = true
        end
    end
    if hasSacrificeRoom then
        if roomCount == clearedRoomCount then
            sound:Play(47, 1, 2, false, 0.5, 0)
            game:ShakeScreen(15)
            level:SetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED, true)
            if hasMinimap then
                for _, getRoom in ipairs(MinimapAPI:GetLevel()) do
                    if getRoom.Type == RoomType.ROOM_SACRIFICE then getRoom.PermanentIcons = {"SacrificeRoom"} end
                end
            end
        end
    end
end

-- Checks if room is double trouble
local function isDoubleTrouble(roomDesc)
    if roomDesc.Data.Type == RoomType.ROOM_BOSS and roomDesc.Data.Name:sub(1, 2) == "DT" then
        return true
    end
    return false
end

--[[
-- Checks if room is grave
local function isGrave(roomDesc)
    if roomDesc.Data.Type == RoomType.ROOM_DEFAULT and roomDesc.Data.Name:sub(1, 5) == "Grave" then
        return true
    end
    return false
end]]

-- MiniMAPI features --
if hasMinimap then
    roomIcon = Sprite()
    roomIcon:Load("gfx/ui/room_icons.anm2", true)
    
    MinimapAPI:AddIcon("sacrifice_closed_icon", roomIcon, "IconSacrificeClosed", 0)
    MinimapAPI:AddIcon("double_trouble_icon", roomIcon, "IconDoubleTrouble", 0)
    --MinimapAPI:AddIcon("grave_icon", roomIcon, "IconGrave", 0)

    -- Icon update --
    local function roomIconUpdate()
        local level = game:GetLevel()
        for i = 0, level:GetRooms().Size - 1 do
            local roomDesc = level:GetRooms():Get(i)
            if roomDesc.Data.Type == RoomType.ROOM_SACRIFICE then
                local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)
                getRoom.PermanentIcons = {"sacrifice_closed_icon"}
            elseif isDoubleTrouble(roomDesc) then
                local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)
                getRoom.PermanentIcons = {"double_trouble_icon"}
            end
            --elseif isGrave(roomDesc) then
            --    local getRoom = MinimapAPI:GetRoomByIdx(roomDesc.SafeGridIndex)
            --    getRoom.PermanentIcons = {"grave_icon"}
            --end
        end
    end

    -- MC_POST_GAME_STARTED --
    function mod:iconStarted(bool)
        roomIconUpdate()
    end

    -- MC_POST_NEW_LEVEL --
    function mod:iconLevel()
        roomIconUpdate()
    end

    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.iconStarted)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.iconLevel)
end

--===== CALLBACKS =====--

-- Grid Door --
function mod:doorRender(door)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    -- Sacrifice Room Door --
    if (room:GetType() == RoomType.ROOM_DEFAULT and door.TargetRoomType == RoomType.ROOM_SACRIFICE) or (room:GetType() == RoomType.ROOM_SACRIFICE and door.TargetRoomType == RoomType.ROOM_DEFAULT) then
        if level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) or room:GetType() == RoomType.ROOM_SACRIFICE then
            local sprite = door:GetSprite()
            if sprite:GetFilename() ~= "gfx/sacrifice_door.anm2" then
                sprite:Load("gfx/sacrifice_door.anm2", true)
                if level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then
                    sprite:Play("Opened", true)
                else
                    sprite:SetFrame("Opened", 0)
                end
            end
        else
            door:Close(true)
            local sprite = door:GetSprite()
            if sprite:GetFilename() ~= "gfx/sacrifice_door.anm2" then
                sprite:Load("gfx/sacrifice_door.anm2", true)
                sprite:Play("Close", true)
            end
        end
    end

    -- Curse Room Door --
    if (door:GetSprite():GetFilename() == "gfx/grid/Door_04_SelfSacrificeRoomDoor.anm2") and door.State == DoorState.STATE_OPEN then
        door:GetSprite():Load("gfx/curse_door.anm2", true)
        if room:GetFrameCount() == 0 then
            door:GetSprite():Play("Opened", true)
        else
            door:GetSprite():Play("Open", true)
        end
    end

    if door:GetSprite():GetFilename() == "gfx/curse_door.anm2" then
        local player = game:GetNearestPlayer(door.Position)
        local distance = (player.Position - door.Position):Length()
        if door.State == DoorState.STATE_OPEN and distance < 30 and not door:GetSprite():IsPlaying("Attack") then
            if not player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then
                door:GetSprite():Play("Attack", true)
            end
        end
        if door:GetSprite():IsPlaying("Attack") then
            if door:GetSprite():GetFrame() < 8 or door:GetSprite():GetFrame() >= 12 then
                local pushX = (-1) ^ math.floor(door.Slot / 2) * ((door.Slot + 1) % 2) * -1
                local pushY = (-1) ^ math.floor(door.Slot / 2) * (door.Slot % 2) * -1
                player.Velocity = Vector(pushX, pushY)
            else
                player.Velocity = Vector(0, 0)
            end
            if door:GetSprite():IsEventTriggered("Attack") then
                sound:Play(49, 1, 2, false, 0.25, 0)
                player:TakeDamage(1, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(entity), 30)
            end
        end
        if door:GetSprite():IsFinished("Attack") then door:GetSprite():Play("opened", true) end
    end
end

-- MC_POST_NEW_ROOM --
function mod:postRoom()
    local level = game:GetLevel() 
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    -- Shops can sell trinkets
    if room:GetType() == RoomType.ROOM_SHOP and room:IsFirstVisit() then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == 5 and entity.Variant == 69 and entity:ToPickup():IsShopItem() then
                local rng = RNG()
                rng:SetSeed(entity.InitSeed, 35)
                local chance = rng:RandomInt(2)
                if chance == 1 then
                    local value = entity:ToPickup().Price
                    entity:Remove()
                    local trinket = Isaac.Spawn(5, 350, 0, entity.Position, Vector(0,0), nil):ToPickup()
                    trinket.AutoUpdatePrice = false
                    trinket.Price = value
                end
            end
        end
    end

    -- Challenge --
    if room:GetType() == RoomType.ROOM_CHALLENGE then
        if roomDesc.Data.SubType == 0 or roomDesc.Data.SubType == 30 then room:SetItemPool(ItemPoolType.POOL_GOLDEN_CHEST) end -- Golden chest pool
    end

    -- Library item choice --
    if room:GetType() == RoomType.ROOM_LIBRARY and room:IsFirstVisit() then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == 5 and entity.Variant == 100 and not entity:ToPickup():IsShopItem() then entity:ToPickup().OptionsPickupIndex = 1 end
        end
    end

    -- Sacrifice spawning --
    if room:GetType() == RoomType.ROOM_SACRIFICE then
        room:SetItemPool(ItemPoolType.POOL_CURSE)
        if room:IsFirstVisit() then
            -- Prevents Softlock --
            if not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then level:SetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) end
        end
    end

    -- Sacrifice Condition --
    if not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then sacrificeCondition(room) end

    -- Black Market: Secret Item Pool --
    if room:GetType() == RoomType.ROOM_BLACK_MARKET then
        local player = Isaac.GetPlayer(0)
        room:SetItemPool(ItemPoolType.POOL_SECRET)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false, -1, 0)
    end

    -- Error Glitch --
    if room:GetBackdropType() == BackdropType.ERROR_ROOM and room:IsFirstVisit() then
        if Isaac.GetPersistentGameData():Unlocked(Achievement.TMTRAINER) then
            local player = Isaac.GetPlayer(0)
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, false) then
                local currentMusic = music:GetCurrentMusicID()
                player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, 0, true, 0, 0)
                player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false, -1, 0)
                player:RemoveCollectible(721, false, 0, true)
                music:Play(currentMusic, volume)
            end
        end
    end
end

-- MC_PRE_ROOM_CLEAN_AWARD --
function mod:roomClear(rng, spawn)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    -- Double Trouble Rewards --
    if isDoubleTrouble(roomDesc) then
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
                Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Isaac.GetFreeNearPosition(Vector(posX[i], posY[i]), 0), true)
                Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]-40, posY[i]+120), 0), Vector(0,0), nil)
                Isaac.Spawn(5, 100, 0, Isaac.GetFreeNearPosition(Vector(posX[i]+40, posY[i]+120), 0), Vector(0,0), nil)
                break
            end
        end
        return true -- Prevents default rewards
    end

    -- Sacrifice Condition --
    if not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then sacrificeCondition() end
end

-- MC_ENTITY_TAKE_DAMAGE --
function mod:takeDamage(entity, amount, flags, source, countdown)
    if entity.Type == EntityType.ENTITY_PLAYER and flags & DamageFlag.DAMAGE_CURSED_DOOR ~= 0 then
        local player = entity:ToPlayer()
        local currentFlag = flags & ~DamageFlag.DAMAGE_CURSED_DOOR
        if player:GetHearts() > amount then currentFlag = DamageFlag.DAMAGE_RED_HEARTS end
        if source.Type == 6 then
            player:TakeDamage(amount, currentFlag | DamageFlag.DAMAGE_NO_MODIFIERS, source, countdown) -- Altar damage
            sound:Play(70, 1, 2, false, 0.5, 0)
            source.Entity:GetSprite():Play("Pay" .. source.Entity.SubType + 1)
        else
            player:TakeDamage(amount, currentFlag, source, countdown) -- Curse door damage
        end
        return false
    end
end

-- MC_PRE_SOUND --
function mod:preSound(id, volume, frameDelay, loop, pitch, pan)
    local room = game:GetLevel():GetCurrentRoom()
    -- Change default item sound
    if id == SoundEffect.SOUND_CHOIR_UNLOCK then
        if room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_ANGEL then
            sound:Play(SoundEffect.SOUND_POWERUP2, 1, framedelay, loop, pitch, pan)
            return false
        end
    end
end

-- MC_PRE_MUSIC --
function mod:preMusic(id, volume, isFade)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()
    -- Double Trouble Music --
    if room:GetType() == RoomType.ROOM_BOSS and isDoubleTrouble(roomDesc) then
        if id == Music.MUSIC_BOSS or id == Music.MUSIC_BOSS2 or id == Music.MUSIC_BOSS3 then
            return Music.MUSIC_BOSS_RUSH
        end
    end
end

-- Callbacks --
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.doorRender)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.postRoom)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.roomClear)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.takeDamage)
mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.preSound)
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, mod.preMusic)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.postLevel)