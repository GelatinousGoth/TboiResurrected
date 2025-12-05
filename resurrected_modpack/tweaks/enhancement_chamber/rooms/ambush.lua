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