--[[ Sacrifice ]]--
local mod = EnhancementChamber
local hasMinimap = mod.HasMinimap
local data = mod.Data
local config = mod.ConfigSpecial
local configM = mod.ConfigMisc
local rng = mod.RNG
local game = Game()
local sound = SFXManager()
local music = MusicManager()

-- Checks when sacrifice room requirement is done --
local function sacrificeCondition(bool)
    local level = game:GetLevel()
    if bool then -- check condition
        local roomCount = 0
        local clearedRoomCount = 0
        local hasSacrificeRoom = false

        for i = 0, level:GetRooms().Size - 1 do
            local roomDesc = level:GetRooms():Get(i)
            -- Counts normal and miniboss rooms
            if ((roomDesc.Data.Type == RoomType.ROOM_DEFAULT and roomDesc.Data.Subtype == 0)
            or roomDesc.Data.Type == RoomType.ROOM_MINIBOSS) then
                roomCount = roomCount + 1
                 if roomDesc.Clear then
                    local value = 1
                    if level:HasMirrorDimension() then value = 2 end -- Mirror support
                    clearedRoomCount = clearedRoomCount + value
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
    else -- ignore condition
        level:SetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED, true)
        if hasMinimap then
            for _, getRoom in ipairs(MinimapAPI:GetLevel()) do
                if getRoom.Type == RoomType.ROOM_SACRIFICE then getRoom.PermanentIcons = {"SacrificeRoom"} end
            end
        end
    end
end

-- Sacrifice Door --
function mod:sacrificeDoorRender(door)
    if not config["sacrifice"] then return end
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    -- Sacrifice Room Door --
    if (room:GetType() == RoomType.ROOM_DEFAULT and door.TargetRoomType == RoomType.ROOM_SACRIFICE) or (room:GetType() == RoomType.ROOM_SACRIFICE and door.TargetRoomType == RoomType.ROOM_DEFAULT) then
        if level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then
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
            if sprite:GetFilename() ~= "gfx/sacrifice_door.anm2" then sprite:Load("gfx/sacrifice_door.anm2", true) end
            sprite:SetFrame("Closed", 0)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.sacrificeDoorRender, GridEntityType.GRID_DOOR)
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.sacrificeDoorRender, GridEntityType.GRID_DOOR)

-- Sacrifice Condition --
function mod:sacrificeRoomClear(rng, spawn)
    if not config["sacrifice"] then return end
    local level = game:GetLevel()
    if not level:GetStateFlag(LevelStateFlag.STATE_GREED_MONSTRO_SPAWNED) then sacrificeCondition(true) end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.sacrificeRoomClear)