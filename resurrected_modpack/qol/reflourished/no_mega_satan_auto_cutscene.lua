local function MegaSatanCutsceneEnabler()

local mod = IsaacReflourished
local MegaSatanCutscene = {}
local game = Game()

local saveMan = mod.SaveManager


mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, mark)
    local runSave = saveMan.GetRunSave()
    if mark == CompletionType.HUSH then
        runSave.BeatHush = true
        return
    end
end)

---@param position Vector
local function spawn_void_portal(position)
    --local pos = Isaac.GetFreeNearPosition(position, 80.0)
    local room = Game():GetRoom()
    local portal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, position, true)

    if portal and portal:GetType() ~= GridEntityType.GRID_TRAPDOOR then
        portal.VarData = 1
        portal:GetSprite():Load("gfx/grid/voidtrapdoor.anm2", true)
    else
        room:RemoveGridEntityImmediate(room:GetGridIndex(position), 0, false, true)
        portal = Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 1, position, true)
        if portal then
            portal.VarData = 1
            portal:GetSprite():Load("gfx/grid/voidtrapdoor.anm2", true)
        end
    end

end


local cancelVoidPortalSpawn = false

function MegaSatanCutscene:OnPreSpawnAward(rng)
    if game.Challenge ~= Challenge.CHALLENGE_NULL then return end

    local level = game:GetLevel()
    local room = game:GetRoom()
    local desc = level:GetCurrentRoomDesc()
    if game:IsGreedMode() then return end
    if desc.Data.Type ~= RoomType.ROOM_BOSS then return end
    if not Isaac.GetPersistentGameData():Unlocked(Achievement.VOID_FLOOR) then return end

    local roomType
    local baseChance
    local portalSpawnPos

    local stage = level:GetStage()

    -- Mega Satan
    if stage == LevelStage.STAGE6
    and desc.GridIndex == GridRooms.ROOM_MEGA_SATAN_IDX then
        roomType = "MegaSatan"
        baseChance = 2 --1/2 chance
        portalSpawnPos = Vector(320, 520)

    -- ??? (Blue Baby)
    elseif stage == LevelStage.STAGE6
    and room:GetBossID() == BossType.BLUE_BABY then
        roomType = "BlueBaby"
        baseChance = 5 --1/5 chance
        portalSpawnPos = Vector(320, 360)

    -- The Lamb
    elseif stage == LevelStage.STAGE6
    and room:GetBossID() == BossType.THE_LAMB then
        roomType = "Lamb"
        baseChance = 5 --1/5 chance
        portalSpawnPos = Vector(320, 360)
    -- Mother
    elseif (stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_1 and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0))
    and room:GetBossID() == BossType.MOTHER
    and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B) then
        roomType = "Mother"
        baseChance = 2 --1/2 chance
        portalSpawnPos = Vector(320, 560)
    end

    -- Not a final boss
    if not roomType then return end

    if not REPENTANCE_PLUS and roomType == "Mother" then
        return
    end

    local unguarantee = IsaacReflourished:GetSettingsValue("VoidPortalUnguarantee") == 2
    if REPENTANCE_PLUS and not unguarantee then
        return
    end

    -- Beating hush gives X2 probability to get void portal
    local hushBonusEnabled = IsaacReflourished:GetSettingsValue("VoidPortalHushSpawn") == 2
    local probability = 0

    if hushBonusEnabled and saveMan.GetRunSave().BeatHush then
        probability = 1
    end

    local rand = rng:RandomInt(baseChance)

    if rand <= probability then
        spawn_void_portal(portalSpawnPos)
    end


    cancelVoidPortalSpawn = true
    Isaac.CreateTimer(function()
        cancelVoidPortalSpawn = false
    end, 1, 1, true)
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, MegaSatanCutscene.OnPreSpawnAward)


function MegaSatanCutscene:OnTrapdoorSpawn(type, variant, varData, gridIdx, spawnSeed, desc)
    if not (type == GridEntityType.GRID_TRAPDOOR and varData == 1) then return end
    if not cancelVoidPortalSpawn then return end
    cancelVoidPortalSpawn = false
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_SPAWN, MegaSatanCutscene.OnTrapdoorSpawn)


-- mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
--     local level = Game():GetLevel()
--     local roomDesc = level:GetCurrentRoomDesc()

--     if game:IsGreedMode() then return end
--     if roomDesc.Data.Type ~= RoomType.ROOM_BOSS then return end

--     print("-----")
--     local seed = roomDesc.AwardSeed
--     local rng = RNG(seed, 35)
--     rng:Next()

--     local shouldSpawnPortal = false
--     if rng:RandomInt(5) <= 0 then
--         shouldSpawnPortal = true
--     end
--     print("Should spawn portal", tostring(shouldSpawnPortal))

-- end)

-- mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, rng)
--     local level = Game():GetLevel()
--     local roomDesc = level:GetCurrentRoomDesc()

--     if game:IsGreedMode() then return end
--     if roomDesc.Data.Type ~= RoomType.ROOM_BOSS then return end

--     local seed = roomDesc.AwardSeed
--     local rng = RNG(seed, 35)
--     rng:Next()

--     local shouldSpawnPortal = false
--     if rng:RandomInt(100) <= 14 then
--         shouldSpawnPortal = true
--     end
--     print("POST Should spawn portal", tostring(shouldSpawnPortal))

-- end)


mod:AddCallback(ModCallbacks.MC_PRE_MEGA_SATAN_ENDING, function()
    return true
end)


end
return MegaSatanCutsceneEnabler