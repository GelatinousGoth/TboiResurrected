local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Giant Props", 1)

local game = Game()
local sfx = SFXManager()
local rng = RNG()
-- Helper effect for spawning chapter-unique giant props.
local UNIQUE_GIANT_PROP_SPAWNER = Isaac.GetEntityVariantByName("Unique Giant Prop Spawner Effect")
local UNIVERSAL_GIANT_PROP_SPAWNER = Isaac.GetEntityVariantByName("Universal Giant Prop Spawner Effect")

-- Grid cells surrounding the giant prop. Relative to bottom-right corner (main part).
-- Used to define a valid space to drop consumables.
local NearbyGrids = {
    Vector(-80, -80),
    Vector(-80, -40),
    Vector(-80, 0),
    Vector(-80, 40),
    Vector(-40, -80),
    Vector(-40, 40),
    Vector(0, -80),
    Vector(0, 40),
    Vector(40, -80),
    Vector(40, -40),
    Vector(40, 0),
    Vector(40, 40),
}

-- Helper for choosing nearby unoccupied grid.
local function chooseValidNearbyCell(gi)
    rng:SetSeed(Random() + 1, 1)
    local room = game:GetRoom()
    local pos = room:GetGridPosition(gi)
    local returnEndPos
    local returnStartPos
    local g
    local failedAttempts = 0

    repeat
        local roll = rng:RandomInt(#NearbyGrids) + 1
        returnEndPos = pos + NearbyGrids[roll]

        -- calculating start point (grid's segment)
        if roll == 1 or roll == 2 or roll == 5 then
            returnStartPos = pos + Vector(-40, -40)
        elseif roll == 3 or roll == 4 or roll == 6 then
            returnStartPos = pos + Vector(-40, 0)
        elseif roll == 7 or roll == 9 or roll == 10 then
            returnStartPos = pos + Vector(0, -40)
        else
            returnStartPos = pos
        end

        g = room:GetGridEntityFromPos(returnEndPos)

        -- prevent freezing the game when no free cells are available nearby
        failedAttempts = failedAttempts + 1
        if failedAttempts == 2000 then
            returnEndPos = pos
            returnStartPos = pos
            break
        end
    until (not g or g:GetType() < GridEntityType.GRID_ROCK
    or g:GetType() == GridEntityType.GRID_SPIDERWEB or g:GetType() == GridEntityType.GRID_SPIKES_ONOFF)

    return returnEndPos, returnStartPos
end

local function getVelocity(gi)
    local _end
    local _start
    _end, _start = chooseValidNearbyCell(gi)
    _end = _end + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10)
    local vel = (_end - _start):Normalized() * 2.25

    return _start, vel
end

-- Spawns a pickup and prevents it from being stuck inside of a giant prop segment that spawned it.
local function spawnAndPushPickup(gent, variant, subtype)
    subtype = subtype or 0

    local _start, vel = getVelocity(gent:GetGridIndex())
    local p = Isaac.Spawn(5, variant, subtype, _start, vel, nil)
    p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    p:GetData().resetGridColClass = true
end

-- Giant prop state.
local GridState = {
    BLANK = 32,
    --
    MAIN_FULL = 33,
    MAIN_BROKEN1 = 34,
    MAIN_BROKEN2 = 35,
    MAIN_BROKEN3 = 36,
    RUBBLE = 37
}

-- Giant prop animation corresponding to the state.
local GridAnimName = {
    -- blank sprite for other segments
    [GridState.BLANK] = "Blank",
    -- main segment, solely responsible for changing animation
    [GridState.MAIN_FULL] = "State1",
    -- main segment gradually being broken down
    [GridState.MAIN_BROKEN1] = "State2",
    [GridState.MAIN_BROKEN2] = "State3",
    [GridState.MAIN_BROKEN3] = "State4",
    [GridState.RUBBLE] = "Rubble"
}

local UniversalGridSubtype = {
    -- Note to future self and others: VarData seems to reset to 1 if given a value of 10 and higher to a block grid entity.
    -- So, 0-4 will be reserved for unique props, and 5-9 to universal. Should be enough.
    SHOPKEEPER = 5,
    BOMB_ROCK = 6
}

local UniqueGridSpritesheetName = {
    [LevelStage.STAGE1_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_pot_basement",
        [StageType.STAGETYPE_WOTL] = "g_pot_basement",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_pot_basement",
        [StageType.STAGETYPE_REPENTANCE] = {
            -- if chapter's props can take different forms, they are differentiated by VarData
            [0] = "g_bucket_downpour",
            [1] = "g_waterfilledbucket_downpour"
        },
        [StageType.STAGETYPE_REPENTANCE_B] = {
            [0] = "g_bucket_dross",
            [1] = "g_shitfilledbucket_dross"
        }
    },
    [LevelStage.STAGE1_2] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_pot_basement",
        [StageType.STAGETYPE_WOTL] = "g_pot_basement",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_pot_basement",
        [StageType.STAGETYPE_REPENTANCE] = {
            [0] = "g_bucket_downpour",
            [1] = "g_waterfilledbucket_downpour"
        },
        [StageType.STAGETYPE_REPENTANCE_B] = {
            [0] = "g_bucket_dross",
            [1] = "g_shitfilledbucket_dross"
        }
    },
    [LevelStage.STAGE2_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_mushroom_caves",
        [StageType.STAGETYPE_WOTL] = "g_mushroom_caves",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_mushroom_floodedcaves",
        [StageType.STAGETYPE_REPENTANCE] = "g_foolsgold_mines",
        [StageType.STAGETYPE_REPENTANCE_B] = "g_foolsgold_ashpit"
    },
    [LevelStage.STAGE2_2] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_mushroom_caves",
        [StageType.STAGETYPE_WOTL] = "g_mushroom_caves",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_mushroom_floodedcaves",
        [StageType.STAGETYPE_REPENTANCE] = "g_foolsgold_mines",
        [StageType.STAGETYPE_REPENTANCE_B] = "g_foolsgold_ashpit"
    },
    [LevelStage.STAGE3_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_skull_depths",
        [StageType.STAGETYPE_WOTL] = "g_skull_depths",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_skull_depths",
        [StageType.STAGETYPE_REPENTANCE] = "g_skull_mausoleum",
        [StageType.STAGETYPE_REPENTANCE_B] = "g_skull_gehenna"
    },
    [LevelStage.STAGE3_2] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_skull_depths",
        [StageType.STAGETYPE_WOTL] = "g_skull_depths",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_skull_depths",
        [StageType.STAGETYPE_REPENTANCE] = "g_skull_mausoleum",
        [StageType.STAGETYPE_REPENTANCE_B] = "g_skull_gehenna"
    },
    [LevelStage.STAGE4_1] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_wombpolyp_red",
        [StageType.STAGETYPE_WOTL] = "g_wombpolyp_utero",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_wombpolyp_scarred",
        [StageType.STAGETYPE_REPENTANCE] = {
            [0] = "g_corpsepolyp_green",
            [1] = "g_corpsepolyp_cyan",
            [2] = "g_corpsepolyp_rotten"
        },
        [StageType.STAGETYPE_REPENTANCE_B] = {
            [0] = "g_corpsepolyp_green",
            [1] = "g_corpsepolyp_cyan",
            [2] = "g_corpsepolyp_rotten"
        }
    },
    [LevelStage.STAGE4_2] = {
        [StageType.STAGETYPE_ORIGINAL] = "g_wombpolyp_red",
        [StageType.STAGETYPE_WOTL] = "g_wombpolyp_utero",
        [StageType.STAGETYPE_AFTERBIRTH] = "g_wombpolyp_scarred",
        [StageType.STAGETYPE_REPENTANCE] = {
            [0] = "g_corpsepolyp_green",
            [1] = "g_corpsepolyp_cyan",
            [2] = "g_corpsepolyp_rotten"
        },
        [StageType.STAGETYPE_REPENTANCE_B] = {
            [0] = "g_corpsepolyp_green",
            [1] = "g_corpsepolyp_cyan",
            [2] = "g_corpsepolyp_rotten"
        }
    },
    [LevelStage.STAGE5] = {
        [StageType.STAGETYPE_WOTL] = ((FiendFolio or EvadeTaxes) and "g_pot_cathedral") or "g_pot_basement"
    }
}

local UniversalGridSpritesheetName = {
    [UniversalGridSubtype.SHOPKEEPER] = 'g_shopkeeper_universal',
    [UniversalGridSubtype.BOMB_ROCK] = 'g_bombrock_universal'
}

-- Returns all grid entities representing the main (or all) segments of giant props in the current room.
---@return GridEntity[]
local function findGiantPropSegments(room, includeBlank)
    includeBlank = includeBlank or false
    local segments = {}

    for ind = 1, room:GetGridSize() do
        ---@type GridEntity
        local gridEnt = room:GetGridEntity(ind)

        if gridEnt and gridEnt:GetType() == GridEntityType.GRID_ROCKB
        and gridEnt:GetVariant() >= (includeBlank and GridState.BLANK or GridState.MAIN_FULL)
        and gridEnt:GetVariant() < GridState.RUBBLE then
            table.insert(segments, gridEnt)
        end

    end

    return segments
end
TR_Manager.findGiantPropSegments = findGiantPropSegments

---@return GridEntity
local function getRandomMainSegment(room)
    local segments = findGiantPropSegments(room)
    rng:SetSeed(Random() + 1, 38)

    return segments[rng:RandomInt(#segments) + 1]
end

local function getPropName(stage, stageType, varData)
    varData = varData or 0
    local spritesheet
    if varData >= 5 then
        spritesheet = UniversalGridSpritesheetName[varData]
    else
        spritesheet = UniqueGridSpritesheetName[stage][stageType]
        if type(spritesheet) == "table" then
            spritesheet = spritesheet[varData]
        end
    end

    spritesheet = string.sub(spritesheet, string.find(spritesheet, "_") + 1)
    spritesheet = string.sub(spritesheet, 1, string.find(spritesheet, "_") - 1)

    return string.upper(spritesheet)
end

local CustomPropPickups = {
    ["MUSHROOM"] = {
        MUSHROOM_TISSUE = Isaac.GetCardIdByName("Mushroom Tissue"),
        PSYCH_FUNGI = Isaac.GetCardIdByName("Psychedelic Fungi")
    },
    ["FOOLSGOLD"] = {
        COIN_PYRITE = Isaac.GetEntityVariantByName("Pyrite")
    },
}

--* Since both variations of Giant polyps use it, both when exploded and when in combat
local function shootPolypTears(gent, spawnCreep)
    spawnCreep = spawnCreep or false

    rng:SetSeed(Random() + 1, 1)
    local numTears = rng:RandomInt(5) + 6
    local polypPos = game:GetRoom():GetGridPosition(
        gent:GetGridIndex()
    ) - Vector(20, 20)

    for _ = 1, numTears do
        local tear = Isaac.Spawn(2, TearVariant.BLOOD, 0, polypPos, Vector.FromAngle(rng:RandomFloat() * 360) * 2.5, nil):ToTear()
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)

        tear.FallingSpeed = -17.5
        tear.FallingAcceleration = 0.75

        if spawnCreep then
            tear:AddTearFlags(TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP)
            local c = tear.Color
            c:SetColorize(0.5, 2, 0.5, 1)
            tear:SetColor(c, 999, 1, false, false)
        end
    end
end

local GiantPropsProperties = {
    ["POT"] = {
        ConsumablesDropFunction = function(gent)
            local rewardRoll = rng:RandomFloat()

            if rewardRoll < 0.25 then
                spawnAndPushPickup(gent, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL)
            elseif rewardRoll < 0.75 then
                spawnAndPushPickup(gent, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL)
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            else
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            end
        end,
        AltarGfx = "pot_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_INTRUDER,
            CollectibleType.COLLECTIBLE_TINYTOMA,
            CollectibleType.COLLECTIBLE_SPIDER_BUTT,
            CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
            CollectibleType.COLLECTIBLE_BURSTING_SACK,
            CollectibleType.COLLECTIBLE_SISSY_LONGLEGS,
            CollectibleType.COLLECTIBLE_INFESTATION_2,
            CollectibleType.COLLECTIBLE_SPIDERBABY,
            CollectibleType.COLLECTIBLE_DADDY_LONGLEGS,
            CollectibleType.COLLECTIBLE_JUICY_SACK
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 75 == 0
            and #Isaac.FindByType(3, FamiliarVariant.BLUE_SPIDER, 0) < 8 then
                rng:SetSeed(Random() + 1, 1)
                local spiderRoll = rng:RandomInt(2) + 1

                for _ = 1, spiderRoll do
                    Isaac.GetPlayer():ThrowBlueSpider(
                        game:GetRoom():GetGridPosition(gent:GetGridIndex()),
                        chooseValidNearbyCell(gent:GetGridIndex())
                    )
                end
            end
        end
    },
    ["BUCKET"] = {
        ConsumablesDropFunction = function(gent)
            local cRoll = rng:RandomInt(2) + 2

            for _ = 1, cRoll do
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            end
        end,
        AltarGfx = "pot_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_QUARTER,
            CollectibleType.COLLECTIBLE_WOODEN_NICKEL,
            CollectibleType.COLLECTIBLE_DADS_LOST_COIN
        },
        CombatAction = function(gent)
            return
        end
    },
    ["WATERFILLEDBUCKET"] = {
        ConsumablesDropFunction = function(gent)
            local cRoll = rng:RandomInt(2) + 2

            for _ = 1, cRoll do
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            end

            local creep = Isaac.Spawn(
                1000,
                EffectVariant.PLAYER_CREEP_HOLYWATER,
                0,
                game:GetRoom():GetGridPosition(gent:GetGridIndex()),
                Vector.Zero,
                Isaac.GetPlayer()
            ):ToEffect()
            creep.Parent = Isaac.GetPlayer()
            creep.Timeout = 3000
            creep.LifeSpan = 3000
            creep.Scale = 2.5
        end,
        AltarGfx = "pot_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_LEECH,
            CollectibleType.COLLECTIBLE_LIL_SPEWER
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 75 == 0 then
                for _ = 1, 2 do
                    local leechPos = chooseValidNearbyCell(gent:GetGridIndex())
                    local leech = Isaac.Spawn(EntityType.ENTITY_SMALL_LEECH, 0, 0, leechPos, Vector.Zero, nil)
                    leech:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    leech:AddCharmed(EntityRef(Isaac.GetPlayer()), -1)
                end
            end
        end
    },
    ["SHITFILLEDBUCKET"] = {
        ConsumablesDropFunction = function(gent)
            local cRoll = rng:RandomInt(2) + 2

            for _ = 1, cRoll do
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            end
        end,
        AltarGfx = "pot_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_DIRTY_MIND,
            CollectibleType.COLLECTIBLE_POOP,
            CollectibleType.COLLECTIBLE_BROWN_NUGGET,
            CollectibleType.COLLECTIBLE_BUTT_BOMBS,
            CollectibleType.COLLECTIBLE_SKATOLE,
            CollectibleType.COLLECTIBLE_COMPOST,
            CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 75 == 0 then
                rng:SetSeed(Random() + 1, 1)

                if rng:RandomFloat() < 0.25 then
                    local dripPos = chooseValidNearbyCell(gent:GetGridIndex())
                    local drip = Isaac.Spawn(EntityType.ENTITY_DRIP, 0, 0, dripPos, Vector.Zero, nil)
                    drip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    drip:AddCharmed(EntityRef(Isaac.GetPlayer()), -1)
                else
                    Isaac.GetPlayer():ThrowFriendlyDip(
                        0,
                        game:GetRoom():GetGridPosition(gent:GetGridIndex()),
                        chooseValidNearbyCell(gent:GetGridIndex())
                    )
                end
            end
        end
    },
    ["MUSHROOM"] = {
        ConsumablesDropFunction = function(gent)
            for _ = 1, 2 do
                local roll = rng:RandomFloat()

                if roll < 0.5 then
                    spawnAndPushPickup(gent, 300, CustomPropPickups["MUSHROOM"].MUSHROOM_TISSUE)
                elseif roll < 0.75 then
                    spawnAndPushPickup(gent, 300, CustomPropPickups["MUSHROOM"].PSYCH_FUNGI)
                end
            end
        end,
        AltarGfx = "mushroom_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
            CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
            CollectibleType.COLLECTIBLE_1UP,
            CollectibleType.COLLECTIBLE_MUCORMYCOSIS,
            CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
            CollectibleType.COLLECTIBLE_MINI_MUSH,
            CollectibleType.COLLECTIBLE_GODS_FLESH,
            CollectibleType.COLLECTIBLE_WAVY_CAP,
            CollectibleType.COLLECTIBLE_BLUE_CAP
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 60 == 0 then
                rng:SetSeed(Random() + 1, 1)
                local fartRoll = rng:RandomFloat()
                local fartPos = game:GetRoom():GetGridPosition(
                    gent:GetGridIndex()
                ) - Vector(20, 20)

                if fartRoll < 0.15 then
                    game:Fart(fartPos, 125, Isaac.GetPlayer(), 1.25)
                elseif fartRoll < 0.2 then
                    game:CharmFart(fartPos, 150, Isaac.GetPlayer())
                end
            end
        end
    },
    ["FOOLSGOLD"] = {
        ConsumablesDropFunction = function(gent)
            for _ = 1, gent:GetVariant() == GridState.MAIN_FULL and 3 or 2 do
                spawnAndPushPickup(gent, CustomPropPickups["FOOLSGOLD"].COIN_PYRITE)
            end
        end,
        AltarGfx = "foolsgold_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_MIDAS_TOUCH,
            CollectibleType.COLLECTIBLE_REMOTE_DETONATOR,
            CollectibleType.COLLECTIBLE_NOTCHED_AXE,
            CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
            CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER
        },
        CombatAction = function(gent)
            return
        end
    },
    ["SKULL"] = {
        ConsumablesDropFunction = function(gent)
            local rewardRoll = rng:RandomFloat()

            if rewardRoll < 0.4 then
                spawnAndPushPickup(gent, 10, HeartSubType.HEART_BLACK)
            elseif rewardRoll < 0.7 then
                spawnAndPushPickup(gent, 10, HeartSubType.HEART_BONE)
            elseif rewardRoll < 0.8 then
                spawnAndPushPickup(gent, 300, game:GetItemPool():GetCard(rng:GetSeed(), false, true, true))
                spawnAndPushPickup(gent, 10, HeartSubType.HEART_BONE)
            else
                spawnAndPushPickup(gent, 300, game:GetItemPool():GetCard(rng:GetSeed(), false, true, true))
            end
        end,
        AltarGfx = "skull_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_GHOST_BABY,
            CollectibleType.COLLECTIBLE_GHOST_BOMBS,
            CollectibleType.COLLECTIBLE_DRY_BABY,
            CollectibleType.COLLECTIBLE_HOST_HAT,
            CollectibleType.COLLECTIBLE_LIL_HAUNT
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 150 == 0 then
                local skullPos = game:GetRoom():GetGridPosition(
                    gent:GetGridIndex()
                ) - Vector(20, 20)

                for _, enemy in pairs(Isaac.FindInRadius(skullPos, 125, EntityPartition.ENEMY)) do
                    enemy:AddFear(EntityRef(nil), 60)
                end
            end
        end
    },
    ["WOMBPOLYP"] = {
        ConsumablesDropFunction = function(gent)
            rng:SetSeed(Random() + 1, 1)

            for _ = 1, rng:RandomInt(2) + 1 do
                local roll = rng:RandomFloat()

                if roll < 0.2 then
                    spawnAndPushPickup(gent, 10, HeartSubType.HEART_FULL)
                elseif roll < 0.4 then
                    spawnAndPushPickup(gent, 10, HeartSubType.HEART_SCARED)
                elseif roll < 0.9 then
                    spawnAndPushPickup(gent, 10, HeartSubType.HEART_HALF)
                else
                    spawnAndPushPickup(gent, 10, HeartSubType.HEART_DOUBLEPACK)
                end
            end

            shootPolypTears(gent)
        end,
        AltarGfx = "wombpolyp_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_BOILED_BABY,
            CollectibleType.COLLECTIBLE_AKELDAMA,
            CollectibleType.COLLECTIBLE_WORM_FRIEND,
            CollectibleType.COLLECTIBLE_STEM_CELLS,
            CollectibleType.COLLECTIBLE_MAGIC_SCAB,
            CollectibleType.COLLECTIBLE_BLOOD_CLOT,
            CollectibleType.COLLECTIBLE_PLACENTA,
            CollectibleType.COLLECTIBLE_VASCULITIS,
            CollectibleType.COLLECTIBLE_VARICOSE_VEINS,
            CollectibleType.COLLECTIBLE_YUM_HEART
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 60 == 0 then
                shootPolypTears(gent)
            end
        end
    },
    ["CORPSEPOLYP"] = {
        ConsumablesDropFunction = function(gent)
            rng:SetSeed(Random() + 1, 1)

            for _ = 1, rng:RandomInt(2) + 1 do
                spawnAndPushPickup(gent, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
            end

            shootPolypTears(gent, true)
        end,
        AltarGfx = "corpsepolyp_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_ROTTEN_BABY,
            CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
            CollectibleType.COLLECTIBLE_YUCK_HEART,
            CollectibleType.COLLECTIBLE_BOBS_BRAIN,
            CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
            CollectibleType.COLLECTIBLE_AKELDAMA
        },
        CombatAction = function(gent)
            if game:GetFrameCount() % 75 == 0 then
                shootPolypTears(gent, true)
                local maggot = Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, 0, 0, chooseValidNearbyCell(gent:GetGridIndex()), Vector.Zero, nil)
                maggot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                maggot:AddCharmed(EntityRef(Isaac.GetPlayer()), -1)
            end
        end
    },
    ["SHOPKEEPER"] = {
        ConsumablesDropFunction = function(gent)
            for _ = 1, 3 do
                spawnAndPushPickup(gent, PickupVariant.PICKUP_COIN)
            end
        end,
        AltarGfx = "shopkeeper_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_STEAM_SALE,
            CollectibleType.COLLECTIBLE_COUPON,
            CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER,
            CollectibleType.COLLECTIBLE_STRAW_MAN,
            CollectibleType.COLLECTIBLE_KEEPERS_BOX,
            CollectibleType.COLLECTIBLE_KEEPERS_SACK,
            CollectibleType.COLLECTIBLE_CROOKED_PENNY
        },
        CombatAction = function(gent)
            return
        end
    },
    ["BOMBROCK"] = {
        ConsumablesDropFunction = function(gent)
            return
        end,
        AltarGfx = "bombrock_itemaltar",
        Pool = {
            CollectibleType.COLLECTIBLE_MR_MEGA,
            CollectibleType.COLLECTIBLE_MAMA_MEGA,
            CollectibleType.COLLECTIBLE_MR_BOOM
        },
        CombatAction = function(gent)
            return
        end
    }
}

local function upVariant(gent)
    if gent:GetVariant() < GridState.RUBBLE then
        gent:SetVariant(gent:GetVariant() + 1)
    end
end

---@param grid GridEntity
local function updateGrid(grid, customVarData)
    customVarData = customVarData or grid:GetSaveState().VarData
    if customVarData >= 5 then
        -- Universal props. Spritesheet is determined by VarData ONLY
        -- Also see the reference to UniversalGridSubtype
        local s = grid:GetSprite()
        s:Load("gfx/grid/giant_prop.anm2", true)
        s:ReplaceSpritesheet(0, "gfx/grid/" .. UniversalGridSpritesheetName[customVarData] .. ".png")
        s:LoadGraphics()
        s:Play(GridAnimName[grid:GetVariant()])
    else
        -- Chapter unique props. Spritesheet is determined by Stage, StageType and VarData (sometimes)
        local l = game:GetLevel()
        if not UniqueGridSpritesheetName[l:GetStage()] then
            Isaac.DebugString("WARNING: No unique giant prop found for this chapter!")
            return
        end

        local s = grid:GetSprite()
        s:Load("gfx/grid/giant_prop.anm2", true)
        if type(UniqueGridSpritesheetName[l:GetStage()][l:GetStageType()]) == "table" then
            -- VarData allows for differentiating props inside the same floor (like special buckets in Dross)
            s:ReplaceSpritesheet(0, "gfx/grid/" .. UniqueGridSpritesheetName[l:GetStage()][l:GetStageType()][grid:GetSaveState().VarData] .. ".png")
        else
            s:ReplaceSpritesheet(0, "gfx/grid/" .. UniqueGridSpritesheetName[l:GetStage()][l:GetStageType()] .. ".png")
        end
        s:LoadGraphics()
        s:Play(GridAnimName[grid:GetVariant()])
    end
end

local function createGrid(pos, isMainSegment, varData)
    local grid = Isaac.GridSpawn(GridEntityType.GRID_ROCKB, 0, pos, true)
    grid:SetVariant(isMainSegment and GridState.MAIN_FULL or GridState.BLANK)
    if varData then
        grid:GetSaveState().VarData = varData
    end
    updateGrid(grid)
end

-- Spawn giant prop at a given spot.
-- BOTTOM-RIGHT corner of the prop is the main segment.
-- The effect, however, is taken up by the TOP-LEFT corner.
local function createProp(pos, varData)
    if type(pos) == "number" then
        pos = game:GetRoom():GetGridPosition(pos)
    end

    for i = 0, 3 do
        local newPos = Vector(pos.X + 40 * (i % 2), pos.Y + 40 * (i // 2))
        createGrid(newPos, i == 3, varData)
    end
end
TR_Manager.createProp = createProp

--[[
    CORE: HOW GIANT PROPS' TEXTURES, VARIANTS AND VARDATAS ARE HANDLED ON NEW ROOM
--]]
function mod:RoomUpdate()
    local room = game:GetRoom()
    local level = game:GetLevel()

    for _, e in pairs(Isaac.FindByType(1000, UNIQUE_GIANT_PROP_SPAWNER)) do
        local vd = nil

        -- Dross and Downpour special. Choosing a variant at random
        if (level:GetStage() == LevelStage.STAGE1_1 or level:GetStage() == LevelStage.STAGE1_2)
        and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE then
            vd = rng:RandomInt(2)
        end

        -- Corpse special. Choosing backdrop-specific variant. Corpse backdrops are: 34, 43, 44
        if (level:GetStage() == LevelStage.STAGE4_1 or level:GetStage() == LevelStage.STAGE4_2)
        and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE then
            vd = math.max(room:GetBackdropType() - 42, 0)
        end

        createProp(room:GetGridIndex(e.Position), vd)
        e:Remove()
    end

    for _, e in pairs(Isaac.FindByType(1000, UNIVERSAL_GIANT_PROP_SPAWNER)) do
        -- When spawning a universal prop, its appearance depends on the subtype of a spawner effect entity. Offset of 5 is used.
        -- See the reference to UniversalGridSubtype
        createProp(room:GetGridIndex(e.Position), e.SubType + 5)
        e:Remove()
    end

    for _, gent in pairs(findGiantPropSegments(room, true)) do
        updateGrid(gent)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.RoomUpdate)

--[[
    CORE: HOW GIANT PROPS' MAIN SEGMENTS(!) REACT TO NEARBY EXPLOSIONS
--]]
---@param Effect EntityEffect
function mod:OnEffectUpdate(Effect)
    if (Effect.Variant == EffectVariant.BOMB_EXPLOSION or Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION)
    and Effect.FrameCount == 1 then
        local trueExplosionDist = Effect.Variant == EffectVariant.MAMA_MEGA_EXPLOSION and 2000 or 120
        local room = game:GetRoom()

        for _, gridEnt in pairs(findGiantPropSegments(room, false)) do
            if gridEnt.Position:Distance(Effect.Position) < trueExplosionDist then
                rng:SetSeed(Random() + 1, 1)
                local gridName = getPropName(game:GetLevel():GetStage(), game:GetLevel():GetStageType(), gridEnt:GetSaveState().VarData)

                -- the prop is destroyed, drop an item and turn it into rubble
                if gridEnt:GetVariant() == GridState.MAIN_BROKEN3
                or gridName == "BOMBROCK" then
                    local ind = gridEnt:GetGridIndex()
                    for _, near in pairs({ind, ind - 1, ind - room:GetGridWidth(), ind - room:GetGridWidth() - 1}) do
                        local otherSegment = room:GetGridEntity(near)

                        otherSegment:GetSprite():Play(GridAnimName[GridState.RUBBLE])
                        otherSegment:SetType(1)
                        otherSegment:Destroy(true)
                    end

                    local pool = GiantPropsProperties[gridName].Pool
                    local id = pool[rng:RandomInt(#pool) + 1]
                    local newItem = Isaac.Spawn(5, 100, id, room:GetGridPosition(ind), Vector.Zero, nil)
                    newItem:GetSprite():ReplaceSpritesheet(5, "gfx/items/" .. GiantPropsProperties[gridName].AltarGfx .. ".png")
                    newItem:GetSprite():LoadGraphics()

                    if gridName == "BOMBROCK" then
                        Isaac.Spawn(1000, EffectVariant.MAMA_MEGA_EXPLOSION, 0, Vector.Zero, Vector.Zero, nil)
                    end

                -- the prop isn't yet broken, break it down and drop consumables
                elseif gridEnt:GetVariant() < GridState.MAIN_BROKEN3 then
                    GiantPropsProperties[gridName].ConsumablesDropFunction(gridEnt)
                    upVariant(gridEnt)
                    gridEnt:GetSprite():Play(GridAnimName[gridEnt:GetVariant()])
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnEffectUpdate)

--[[
    CORE: HOW GIANT PROPS BEHAVE IN COMBAT (UNCLEARED ROOMS)
--]]
function mod:OnUpdate()
    local room = game:GetRoom()
    local level = game:GetLevel()

    -- Giant Props' combat actions
    if not room:IsClear()
    and #findGiantPropSegments(room, false) > 0 then
        local rgent = getRandomMainSegment(room)
        local gridName = getPropName(level:GetStage(), level:GetStageType(), rgent:GetSaveState().VarData)
        GiantPropsProperties[gridName].CombatAction(rgent)
    end

    -- Resetting grid collision class of pickups, so that they don't fly off the screen on another explosion
    for _, p in pairs(Isaac.FindByType(5)) do
        if p:GetData().resetGridColClass
        and p.FrameCount >= 30 then
            p:GetData().resetGridColClass = false
            p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)


--[[
--------------------------
-- cards, pickups and etc.
--------------------------
--]]

---@param Player EntityPlayer
function mod:CardUsed(usedCard, Player, Flags)
    if usedCard == CustomPropPickups["MUSHROOM"].MUSHROOM_TISSUE then
        rng:SetSeed(Random() + 1, 1)

        local randomEffect = rng:RandomInt(PillEffect.NUM_PILL_EFFECTS)
        local randomColor = rng:RandomInt(PillColor.NUM_STANDARD_PILLS) + PillColor.PILL_GIANT_FLAG
        Player:UsePill(randomEffect, randomColor, 0)
        Player:AddCacheFlags(CacheFlag.CACHE_ALL)
        Player:EvaluateItems()

    elseif usedCard == CustomPropPickups["MUSHROOM"].PSYCH_FUNGI then
        Player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP)
        sfx:Play(SoundEffect.SOUND_VAMP_GULP)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.CardUsed)

---@param Pickup EntityPickup
---@param Collider Entity
function mod:OnPickupCollision(Pickup, Collider, _)
    local player = Collider:ToPlayer()
    if not player then return end

    if Pickup.Variant == CustomPropPickups["FOOLSGOLD"].COIN_PYRITE
    and not Pickup:GetSprite():IsPlaying("Collect") then
        rng:SetSeed(player.InitSeed + Random(), 1)
        local roll = rng:RandomInt(5) + 3
        player:AddCoins(roll)

        sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
        Pickup:GetSprite():Play("Collect", true)
        Pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        Pickup:Die()
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnPickupCollision)

---@param Pickup EntityPickup
function mod:OnPickupUpdate(Pickup)
    if Pickup:GetSprite():IsPlaying("Collect") then
        Pickup.Velocity = Vector.Zero
    elseif Pickup:GetSprite():IsFinished("Collect") then
        Pickup:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnPickupUpdate, CustomPropPickups["FOOLSGOLD"].COIN_PYRITE)


--[[
--------------
-- EID COMPATIBILITY
--------------
--]]
if EID then
    EID:addCard(CustomPropPickups["MUSHROOM"].MUSHROOM_TISSUE, "{{Pill2}} Activates a random horse pill effect")
    EID:addCard(CustomPropPickups["MUSHROOM"].PSYCH_FUNGI, "{{Collectible582}} One time use of Wavy Cap")

    EID:addEntity(5, 576, 0, "Pyrite", "{{Coin}} Adds 3-7 coins on pickup")
end
