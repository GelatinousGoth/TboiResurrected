--[[ Ambush ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Ambush Champion Chance
---@param npc EntityNPC
function mod:ambushNPCInit(npc)
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() ~= RoomType.ROOM_CHALLENGE or npc:GetData().ec_ambush_check then
        return
    end

    npc:GetData().ec_ambush_check = true

    if npc:HasEntityFlags(EntityFlag.FLAG_APPEAR)
    and npc:HasEntityFlags(EntityFlag.FLAG_AMBUSH)
    and EntityConfig.GetEntity(npc.Type, npc.Variant, npc.SubType):CanBeChampion()
    and not npc:IsBoss() then

        local difficultyRNG = 20
        if game.Difficulty == Difficulty.DIFFICULTY_HARD then
            difficultyRNG = difficultyRNG - 15
        end

        local chance = npc.InitSeed % difficultyRNG -- 5% Normal | 20% Hard

        if chance == 0 then
            ---@type integer
            local randomChampion = -1
            npc:MakeChampion(npc.InitSeed, randomChampion, true)
            npc.HitPoints = npc.MaxHitPoints
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.ambushNPCInit)


--the following code was written by xxlucia_07xx EPIC 
function mod:bossRushDoorRender(door)
local level = game:GetLevel()
local room = level:GetCurrentRoom()
    if not level:HasBossChallenge() then return end
    local doorIsBossAmbush =
    (room:GetType() == RoomType.ROOM_DEFAULT and door.TargetRoomType == RoomType.ROOM_CHALLENGE) or
    (room:GetType() == RoomType.ROOM_CHALLENGE and door.TargetRoomType == RoomType.ROOM_DEFAULT)

    if not doorIsBossAmbush then return end
    local sprite = door:GetSprite()

    if not door:IsOpen() then return end

    local currentAnim = sprite:GetAnimation()

    if currentAnim == "Open" then
        if sprite:IsFinished("Open") then
            sprite:Play("Opened", true)
        end
    elseif currentAnim ~= "Opened" then
        sprite:Play("Opened", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.bossRushDoorRender)
