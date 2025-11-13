--[[ Ambush ]]--
local mod = EnhancementChamber
local data = mod.Data
local config = mod.ConfigSpecial
local configM = mod.ConfigMisc
local rng = mod.RNG
local game = Game()
local sound = SFXManager()

-- Ambush Champion Chance --
function mod:ambushNPCInit(npc)
    if not configM["ambushChampion"] then return end
    if game.Difficulty < 2 and npc:GetData().ambush_check == nil then
        npc:GetData().ambush_check = true
        if npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) and npc:HasEntityFlags(EntityFlag.FLAG_AMBUSH) and EntityConfig.GetEntity(npc.Type):CanBeChampion() and not npc:IsBoss() then
            local difficultyRNG = 6 -- 16.67% Chance
            if game.Difficulty == Difficulty.DIFFICULTY_HARD then difficultyRNG = difficultyRNG - 3 end -- 33% Chance
            local chance = npc.InitSeed % difficultyRNG
            if chance == 0 then
                npc:MakeChampion(npc.InitSeed, -1, true)
                npc.HitPoints = npc.MaxHitPoints
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.ambushNPCInit)

-- Challenge Room Pickups --
function mod:ambushPostRoom()
    if not config["ambush"] then return end
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    -- Challenge --
    if room:GetType() == RoomType.ROOM_CHALLENGE then
        -- Challenge Pool --
        if room:GetItemPool() == ItemPoolType.POOL_TREASURE then mod.itemReroll(ItemPoolType.POOL_GOLDEN_CHEST) end
        -- Loot --
        if room:IsFirstVisit() then
            if level:GetStage() == LevelStage.STAGE1_1 and level:GetStageType() <= 2 then -- First floor
                local pickups = Isaac.FindByType(5, -1, -1)
                for i = 1, #pickups do pickups[i]:Remove() end -- Remove all pickups
                local chance = rng:RandomInt(100)
                if chance < 70 then -- 70% One chest
                    if chance < 40 then -- Normal (40%)
                        Isaac.Spawn(5, 50, 0, room:GetCenterPos(), Vector(0, 0), nil)
                    elseif chance < 55 then -- Golden (15%)
                        Isaac.Spawn(5, 60, 0, room:GetCenterPos(), Vector(0, 0), nil)
                    elseif chance < 65 then -- Stone (10%)
                        Isaac.Spawn(5, 51, 0, room:GetCenterPos(), Vector(0, 0), nil)
                    else -- Red (5%)
                        Isaac.Spawn(5, 360, 0, room:GetCenterPos(), Vector(0, 0), nil)
                    end
                else -- 30% Two chests
                    Isaac.Spawn(5, 50, 0, room:GetCenterPos() - Vector(40, 0), Vector(0, 0), nil)
                    Isaac.Spawn(5, 50, 0, room:GetCenterPos() + Vector(40, 0), Vector(0, 0), nil)
                end
            elseif level:GetStage() == LevelStage.STAGE5 then -- Sheol / Cathedral
                local pickups = Isaac.FindByType(5, -1, -1)
                for i = 1, #pickups do pickups[i]:Remove() end -- Remove all pickups
                Isaac.Spawn(5, 100, 0, room:GetCenterPos(), Vector(0,0), nil) -- Spawn
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ambushPostRoom)