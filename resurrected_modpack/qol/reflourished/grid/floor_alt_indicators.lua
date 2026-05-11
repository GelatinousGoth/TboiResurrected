local function FloorAltIndicatorsEnabler()

local mod = IsaacReflourished
local game = Game()
local level = game:GetLevel()
local FloorAltIndicators = {}

---@type table<AltPathStage, BackdropType>
FloorAltIndicators.STAGE_TO_BACKDROP = {
    [mod.Enums.AltPathStage.DROSS] = BackdropType.DROSS,
    [mod.Enums.AltPathStage.ASHPIT] = BackdropType.ASHPIT,
    [mod.Enums.AltPathStage.GEHENNA] = BackdropType.GEHENNA,
}

---@type table<AltPathStage, table<GridEntityType, string>>
FloorAltIndicators.STAGE_TO_GRID_TO_SHEET = {
    [mod.Enums.AltPathStage.DROSS] = {
        [GridEntityType.GRID_DOOR] = "gfx/grid/door_dross.png",
        [GridEntityType.GRID_TRAPDOOR] = "gfx/grid/trapdoor_dross.png",
    },
    [mod.Enums.AltPathStage.ASHPIT] = {
        [GridEntityType.GRID_DOOR] = "gfx/grid/door_ashpit.png",
        [GridEntityType.GRID_TRAPDOOR] = "gfx/grid/trapdoor_ashpit.png",
    },
    [mod.Enums.AltPathStage.GEHENNA] = {
        [GridEntityType.GRID_TRAPDOOR] = "gfx/grid/trapdoor_gehenna.png",
    },
    [mod.Enums.AltPathStage.BOILER] = {
        [GridEntityType.GRID_DOOR] = "gfx/grid/door_boiler.png",
        [GridEntityType.GRID_TRAPDOOR] = "gfx/grid/trapdoor_boiler.png",
    },
    [mod.Enums.AltPathStage.GROTTO] = {
        [GridEntityType.GRID_DOOR] = "gfx/grid/door_grotto.png",
        [GridEntityType.GRID_TRAPDOOR] = "gfx/grid/trapdoor_grotto.png",
    },
}

---@type table<AltPathStage, table<GridEntityType, fun(grid: GridEntity): string>>
FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC = {
    [mod.Enums.AltPathStage.GEHENNA] = {
        [GridEntityType.GRID_DOOR] = function ()
            return level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() and "gfx/grid/door_gehenna_mysterious.png" or "gfx/grid/door_gehenna.png"
        end,
    },
}

---@type table<AltPathStage, integer>
FloorAltIndicators.STAGE_TO_FIREPLACE = {
    [mod.Enums.AltPathStage.GEHENNA] = 1
}

---StageAPI only
---@type table<AltPathStage, any>
FloorAltIndicators.STAGE_TO_ROOM_GFX = {}

function FloorAltIndicators:PostModsLoaded()
    if StageAPI then
        ---@param effect EntityEffect
        mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function (_, effect)
            if effect.FrameCount > 1 then return end

            if level:GetCurrentRoomIndex() ~= GridRooms.ROOM_SECRET_EXIT_IDX then return end

            local nextAltPathStage = FloorAltIndicators:GetNextAltPathStage()
            local nextStageGraphics = FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[nextAltPathStage] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[nextAltPathStage][GridEntityType.GRID_TRAPDOOR]
            if not nextStageGraphics then return end

            local sprite = effect:GetSprite()

            for i = 0, sprite:GetLayerCount() do
                sprite:ReplaceSpritesheet(i, nextStageGraphics)
            end

            sprite:LoadGraphics()
        end, Isaac.GetEntityVariantByName("StageAPITrapdoor"))
    end
    if FFGRACE then
        FloorAltIndicators.STAGE_TO_ROOM_GFX[mod.Enums.AltPathStage.BOILER] = FFGRACE.BoilerRoomGfx
        FloorAltIndicators.STAGE_TO_ROOM_GFX[mod.Enums.AltPathStage.GROTTO] = FFGRACE.GrottoRoomGfx
    end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, FloorAltIndicators.PostModsLoaded)
if Isaac.GetFrameCount() > 0 then FloorAltIndicators:PostModsLoaded() end

---@type table<GridEntityType, string>
FloorAltIndicators.GRID_TO_SHEET = {
    [GridEntityType.GRID_ROCK] = "rocks",
    [GridEntityType.GRID_ROCKB] = "rocks",
    [GridEntityType.GRID_ROCKT] = "rocks",
    [GridEntityType.GRID_ROCK_BOMB] = "rocks",
    [GridEntityType.GRID_ROCK_ALT] = "rocks",
    [GridEntityType.GRID_PIT] = "pit",
    [GridEntityType.GRID_SPIKES] = "spikes",
    [GridEntityType.GRID_SPIKES_ONOFF] = "spikes",
    [GridEntityType.GRID_ROCK_SS] = "rocks",
    [GridEntityType.GRID_PILLAR] = "rocks",
    [GridEntityType.GRID_ROCK_SPIKED] = "rocks",
    [GridEntityType.GRID_ROCK_ALT2] = "rocks",
    [GridEntityType.GRID_ROCK_GOLD] = "rocks",
}

---@type table<GridEntityType, string>
FloorAltIndicators.GRID_TO_ANM2 = {
    [GridEntityType.GRID_DECORATION] = "props",
}


---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_repentance_b_available(stage)
    local persistentData = Isaac.GetPersistentGameData()
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.DROSS)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.ASHPIT)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.GEHENNA)
    end

    return false
end

---@param stageID LevelStage
---@param stageType StageType
function FloorAltIndicators:GetAltStageID(stageID, stageType)
    if stageType ~= StageType.STAGETYPE_REPENTANCE_B then return mod.Enums.AltPathStage.UNKNOWN end

    if stageID == LevelStage.STAGE1_1 or stageID == LevelStage.STAGE1_2 then
        return mod.Enums.AltPathStage.DROSS
    elseif stageID == LevelStage.STAGE2_1 or stageID == LevelStage.STAGE2_2 then
        return mod.Enums.AltPathStage.ASHPIT
    elseif stageID == LevelStage.STAGE3_1 or stageID == LevelStage.STAGE3_2 then
        return mod.Enums.AltPathStage.GEHENNA
    end

    return mod.Enums.AltPathStage.UNKNOWN
end

function FloorAltIndicators:OnAltPath()
    return (FFGRACE and FFGRACE.STAGE.Grotto:IsStage()) or level:GetStageType() >= StageType.STAGETYPE_REPENTANCE
end

function FloorAltIndicators:CalculateStageTypeRepentance(stage)
    -- There is no alternate floor for Corpse.
    if stage == LevelStage.STAGE4_1 or (stage == LevelStage.STAGE4_2) then
        return StageType.STAGETYPE_REPENTANCE
    end

    -- If alt floor isn't unlocked yet, return normal floor.
    if not is_repentance_b_available(stage) then
        return StageType.STAGETYPE_REPENTANCE
    end

    -- This algorithm is from Kilburn. We add one because the alt path is offset by 1 relative to the
    -- normal path.
    local seeds = Game():GetSeeds()
    local adjustedStage = stage + 1
    local stageSeed = seeds:GetStageSeed(adjustedStage)

    -- Kilburn does not know why he divided the stage seed by 2 first.
    local halfStageSeed = math.floor(stageSeed / 2)
    if (halfStageSeed % 2 == 0) then
        return StageType.STAGETYPE_REPENTANCE_B
    end

    return StageType.STAGETYPE_REPENTANCE
end

---This is for Fall for Grace compatibility, as the RNG seed used to determine the next floor is the Secret Exit's decoration seed.
function FloorAltIndicators:GetExitRoomDescriptor() 
    local room = level:GetRoomByIdx(GridRooms.ROOM_SECRET_EXIT_IDX)

    if not room.Data then
        return level:GetCurrentRoomDesc()
    end

    if (room.DecorationSeed == 0) then
        local devilAngelRoomRNG = level:GetDevilAngelRoomRNG()
        room:InitSeeds(devilAngelRoomRNG)
    end

    return room
end

function FloorAltIndicators:GetNextAltPathStage()
    local currentStage = level:GetStage()
    local nextStage
    local stageOffset

    if FloorAltIndicators:OnAltPath() then -- From Downpour I -> Downpour II, etc.
        nextStage = currentStage + 1
        stageOffset = 1
        if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0 then
            stageOffset = 2
        end
    else -- From Basement I -> Downpour 1, etc.
        nextStage = currentStage
        stageOffset = 0
        if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0 then
            stageOffset = 1
        end
    end

    local nextStageNumber = math.max(1, currentStage + stageOffset)
    local nextStageType = FloorAltIndicators:CalculateStageTypeRepentance(nextStageNumber)
    local secretRoomDescriptor = FloorAltIndicators:GetExitRoomDescriptor()

    if FFGRACE then
        local rng = RNG(FFGRACE.StageRNG.Seed)
        rng:SetSeed(secretRoomDescriptor.DecorationSeed)
        local chance = rng:PhantomFloat()

        local saveData = FFGRACE.GetSaveData()

        if ((nextStage == LevelStage.STAGE1_1 or nextStage == LevelStage.STAGE1_2) and chance <=
            FFGRACE:ModVarToAltChance(saveData.BoilerChance)) then
            return mod.Enums.AltPathStage.BOILER
        end

        if ((nextStage == LevelStage.STAGE2_1 or nextStage == LevelStage.STAGE2_2) and chance <=
            FFGRACE:ModVarToAltChance(saveData.GrottoChance)) then
            return mod.Enums.AltPathStage.GROTTO
        end
    end

    return FloorAltIndicators:GetAltStageID(nextStage, nextStageType)
end

---@param npc EntityNPC
---@param stage? AltPathStage
function FloorAltIndicators:LoadStageSkin(npc, stage)
    if FFGRACE then
        if not stage then
            if level:GetCurrentRoomIndex() ~= GridRooms.ROOM_SECRET_EXIT_IDX then return end
            stage = FloorAltIndicators:GetNextAltPathStage()
        end

        local npcData = npc:GetData()

        if not npcData.DontLoadStageSkin then
            local table
            if stage == mod.Enums.AltPathStage.BOILER then
                table = FFGRACE.StageSkins.Boiler
            elseif stage == mod.Enums.AltPathStage.GROTTO then
                table = FFGRACE.StageSkins.Grotto
            end
            if table then
                local key = npc.Type.." "..npc.Variant
                if not table[key] then
                    key = npc.Type.." "..npc.Variant.." "..npc.SubType
                end
                if table[key] then
                    FFGRACE:LoadEnemySheet(npc, table[key])
                    npcData.FFGRACESkin = true
                end
            end
        end

        if stage == mod.Enums.AltPathStage.BOILER then
            if FFGRACE.SplatColorsToBoil[npc.Type.." "..npc.Variant] then
                npc.SplatColor = FFGRACE.SplatColorsToBoil[npc.Type.." "..npc.Variant]
            end
        elseif stage == mod.Enums.AltPathStage.GROTTO then
            if FFGRACE.EnemyRocksToMuddy[npc.Type.." "..npc.Variant] then
                if FFGRACE.EnemyRocksToMuddy[npc.Type.." "..npc.Variant] ~= "NoMudSplat" then
                    npc.SplatColor = FFGRACE.EnemyRocksToMuddy[npc.Type.." "..npc.Variant]
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FloorAltIndicators.LoadStageSkin)
mod:AddCallback(ModCallbacks.MC_POST_NPC_MORPH, FloorAltIndicators.LoadStageSkin)

function FloorAltIndicators:ReloadDoorSprites()
    local room, stage = game:GetRoom()

    for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = room:GetDoor(slot)

        if door and door.TargetRoomIndex == GridRooms.ROOM_SECRET_EXIT_IDX then
            stage = stage or FloorAltIndicators:GetNextAltPathStage()

            local sheet = (FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[stage] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[stage][GridEntityType.GRID_DOOR])
            or (FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage][GridEntityType.GRID_DOOR] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage][GridEntityType.GRID_DOOR](door))

            if sheet then
                local sprite = door:GetSprite()

                for layer = 0, sprite:GetLayerCount()-2 do --exclude layer 4 the heart sprite
                    sprite:ReplaceSpritesheet(layer, sheet)
                end

                sprite:LoadGraphics()
            end
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, FloorAltIndicators.ReloadDoorSprites)

function FloorAltIndicators:PostNewRoom()
    if level:GetCurrentRoomIndex() == GridRooms.ROOM_SECRET_EXIT_IDX then
        local stage = FloorAltIndicators:GetNextAltPathStage()
        if stage == mod.Enums.AltPathStage.UNKNOWN then return end

        if StageAPI and FloorAltIndicators.STAGE_TO_ROOM_GFX[stage] then
            StageAPI.ChangeRoomGfx(FloorAltIndicators.STAGE_TO_ROOM_GFX[stage])
        end

        local room, data = game:GetRoom()

        if FloorAltIndicators.STAGE_TO_BACKDROP[stage] then
            room:SetBackdropType(FloorAltIndicators.STAGE_TO_BACKDROP[stage], 1)
            data = XMLData.GetEntryById(XMLNode.BACKDROP, room:GetBackdropType())
        end

        for i = 0, room:GetGridSize() do
            local grid = room:GetGridEntity(i)

            if grid then
                local type = grid:GetType()
                local sheet = (FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[stage] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET[stage][type])
                or (FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage][type] and FloorAltIndicators.STAGE_TO_GRID_TO_SHEET_DYNAMIC[stage][type](grid))

                if sheet then
                    local sprite = grid:GetSprite()

                    for layer = 0, sprite:GetLayerCount() do
                        sprite:ReplaceSpritesheet(layer, sheet)
                    end

                    sprite:LoadGraphics()
                elseif data then
                    if FloorAltIndicators.GRID_TO_SHEET[type] then
                        if data[FloorAltIndicators.GRID_TO_SHEET[type]] then
                            local sprite = grid:GetSprite()

                            for layer = 0, sprite:GetLayerCount() do
                                sprite:ReplaceSpritesheet(layer, "gfx/grid/" .. data[FloorAltIndicators.GRID_TO_SHEET[type]])
                            end

                            sprite:LoadGraphics()
                        end
                    elseif FloorAltIndicators.GRID_TO_ANM2[type] then
                        if data[FloorAltIndicators.GRID_TO_ANM2[type]] then
                            local sprite = grid:GetSprite()

                            sprite:Load("gfx/grid/" .. data[FloorAltIndicators.GRID_TO_ANM2[type]], true)
                            sprite:PlayRandom(grid:GetSaveState().SpawnSeed)
                        end
                    end
                end
            end
        end

        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            local npc = entity:ToNPC()

            if npc then
                local sprite = npc:GetSprite()

                sprite:Reload()

                for i = 0, sprite:GetLayerCount(), 1 do
                    local layer = sprite:GetLayer(i)

                    if layer then
                        npc:ReplaceSpritesheet(i, layer:GetSpritesheetPath(), true)
                    end
                end

                FloorAltIndicators:LoadStageSkin(npc, stage)
            end
        end
    else
        FloorAltIndicators:ReloadDoorSprites()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FloorAltIndicators.PostNewRoom)

---@param type EntityType
---@param subtype integer
---@param seed integer
function FloorAltIndicators:preEntitySpawn(type, _, subtype, _, _, _, seed)
    if type ~= EntityType.ENTITY_FIREPLACE or level:GetCurrentRoomIndex() ~= GridRooms.ROOM_SECRET_EXIT_IDX then return end
    local variant = FloorAltIndicators.STAGE_TO_FIREPLACE[FloorAltIndicators:GetNextAltPathStage()]
    return variant and {
        type,
        variant,
        subtype,
        seed,
    } or nil
end
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, FloorAltIndicators.preEntitySpawn)

end
return FloorAltIndicatorsEnabler