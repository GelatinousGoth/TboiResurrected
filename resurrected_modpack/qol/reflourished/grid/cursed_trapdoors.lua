local function CursedTrapdoorsModEnabler()
CursedTrapdoorsMod = {}


-- WIP: VERY IMPORTANT
-- When you actually implement DSS, there needs to be an option to enable curses on the first floor
-- Make this function return that option
--
-- By default this should be true btw

local excludedChallenges = {
    [Challenge.CHALLENGE_PITCH_BLACK] = true,
    [Challenge.CHALLENGE_CURSED] = true,
    [Challenge.CHALLENGE_ULTRA_HARD] = true,
}

function CursedTrapdoorsMod:SpawnCursesFirstFloor()
    return IsaacReflourished:GetSettingsValue("AccursedFirstFloor") == 2
end

function CursedTrapdoorsMod:SecretExitHasVanillaGen()
    return IsaacReflourished:GetSettingsValue("AccursedSameAltCurse") == 2
end

function CursedTrapdoorsMod:ShouldShowIcon()
    local guppyEyeSetting = IsaacReflourished:GetSettingsValue("AccursedGuppysEye") == 2

    if not guppyEyeSetting then return true end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
        return true
    end

    return false
end

local CurseIconsToRender = {}

---@class CurseDefinition
---@field Sprite Sprite

---@type table<LevelCurse, CurseDefinition>
local CurseDefinitions = {}
CursedTrapdoorsMod.CurseDefinitions = CurseDefinitions

---Adds a curse that can appear in trapdoors.
---@param curse LevelCurse | integer
---@param sprite Sprite
function CursedTrapdoorsMod:AddCurse(curse, sprite)
    CurseDefinitions[curse] = {
        Sprite = sprite
    }
end

---Use it if your mod replaces the vanilla "gfx/ui/mapitemicons.anm2".
---@param newAnm2 string
---@param anim string?
function CursedTrapdoorsMod:ChangeCursesUIAnm2(newAnm2, anim)
    if not anim then
        anim = "curses"
    end

    local oldAnm2 = CursedTrapdoorsMod:GetCursesUIAnm2()

    for _, curseDef in pairs(CurseDefinitions) do
        local sprite = curseDef.Sprite

        if sprite:GetFilename() == oldAnm2 then
            local oldAnim = sprite:GetAnimation()
            local oldFrame = sprite:GetFrame()

            sprite:Load(newAnm2, true)

            if anim then
                sprite:Play(anim, true)
            else
                sprite:Play(oldAnim, true)
            end
            sprite:SetFrame(oldFrame)
        end
    end
end

---Returns the current anm2 used to display vanilla curse icons.
---@return string
function CursedTrapdoorsMod:GetCursesUIAnm2()
    return CurseDefinitions[LevelCurse.CURSE_OF_BLIND].Sprite:GetFilename()
end


--#region ENUMS

CursedTrapdoorsMod.Enums = {}


CursedTrapdoorsMod.Enums.Achievement = {
    KILL_MOM_ONCE = 4,
    EVERYTHING_IS_TERRIBLE = 33,
    MAGGY_BEATS_ISAAC = 20,
    CAIN_BEATS_ISAAC = 21,
    BLUE_BABY_BEATS_ISAAC = 29,
    SAMSON_BEATS_ISAAC = 54,
    EVE_BEATS_ISAAC = 76,
    ISAAC_BEATS_ISAAC = 106,
    JUDAS_BEATS_ISAAC = 107,
    LAZARUS_BEATS_ISAAC = 116,
    EDEN_BEATS_ISAAC = 121,
    AZAZEL_BEATS_ISAAC = 126,
    LOST_BEATS_ISAAC = 129,
    FORGOTTEN_BEATS_ISAAC = 393,
    BETH_BEATS_ISAAC = 417,
    JACOB_BEATS_ISAAC = 429,
}

CursedTrapdoorsMod.Enums.CustomCallback = {
    --Runs before the standard calculations to get the curse chance.
    --Return a value to completely skip the calculation.
    --
    --Params:
    --
    -- * stage - LevelStage
    PRE_GET_CURSE_CHANCE = "ACCURSED_PRE_GET_CURSE_CHANCE",

    --Runs after the standard calculations to get the curse chance.
    --Return a value to override the calculation. Returned values will be
    --passed to the other callback functions.
    --
    --Params:
    --
    -- * chance - number
    -- * stage - LevelStage
    POST_GET_CURSE_CHANCE = "ACCURSED_POST_GET_CURSE_CHANCE",

    --Runs for each curse when a new one needs to be selected.
    --Return a number to set the curse's weight. If no value is returned
    --the default weight is 1.
    --
    --Params:
    --
    -- * curse - LevelCurse
    -- * stage - LevelStage
    --
    --Optional args:
	--
	-- * curse - LevelCurse
    PRE_GET_CURSE_WEIGHT = "ACCURSED_PRE_GET_CURSE_WEIGHT",

    --Runs for each curse when a new one needs to be selected.
    --Return a number to override the curse's weight. Returned values will be
    --passed to the other callback functions.
    --
    --Params:
    --
    -- * curse - LevelCurse
    -- * weight - number
    -- * stage - LevelStage
    --
    --Optional args:
    --
    -- * curse - LevelCurse
    POST_GET_CURSE_WEIGHT = "ACCURSED_POST_GET_CURSE_WEIGHT",

    --Called from the MC_POST_CURSE_EVAL after the curses for the current
    --floor have been set.
    --Return a bitmask of LevelCurse to override the curses for the floor. Returned
    --values will be passed to the other callback functions.
    --
    --Params
    --
    -- * curses - LevelCurse
    -- * curseFromTrapdoor - LevelCurse
    POST_SET_LEVEL_CURSES = "ACCURSED_POST_SET_LEVEL_CURSES"
}

--#endregion


--#region CONSTANTS

CursedTrapdoorsMod.Constants = {}


CursedTrapdoorsMod.Constants.ISAAC_ACHIEVEMENTS = {
    CursedTrapdoorsMod.Enums.Achievement.MAGGY_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.CAIN_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.BLUE_BABY_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.SAMSON_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.EVE_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.ISAAC_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.JUDAS_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.LAZARUS_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.EDEN_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.AZAZEL_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.LOST_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.FORGOTTEN_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.BETH_BEATS_ISAAC,
    CursedTrapdoorsMod.Enums.Achievement.JACOB_BEATS_ISAAC,
}

CursedTrapdoorsMod.Constants.CURSE_CHANCE = {
    NEW_GAME = { 1 / 80, 1 / 10 },
    KILLED_MOM = { 1 / 30, 1 / 5 },
    EVERYTHING_IS_TERRIBLE = { 1 / 10, 1 / 3 },
    KILLED_ISAAC = { 1 / 5, 1 / 3 }
}

CursedTrapdoorsMod.Constants.POSSIBLE_CURSES = {
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_BLIND
}

CursedTrapdoorsMod.Constants.CURSE_ICON_ANM_FRAME = {
    [LevelCurse.CURSE_OF_DARKNESS] = 0,
    [LevelCurse.CURSE_OF_THE_LOST] = 2,
    [LevelCurse.CURSE_OF_THE_UNKNOWN] = 3,
    [LevelCurse.CURSE_OF_MAZE] = 5,
    [LevelCurse.CURSE_OF_BLIND] = 6,
}

CursedTrapdoorsMod.Constants.MAP_ICONS_ANM2 = "gfx/ui/mapitemicons.anm2"
CursedTrapdoorsMod.Constants.CURSES_ANIMATION = "curses"
--#endregion


--#region VANILLA DEFINITIONS

---@param frame integer
---@return Sprite
local function GetVanillaSprite(frame)
    local sprite = Sprite()
    sprite:Load("gfx/ui/mapitemicons.anm2", true)
    sprite:Play("curses", true)
    sprite:SetFrame(frame)
    return sprite
end

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_DARKNESS,
    GetVanillaSprite(0)
)

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_LABYRINTH,
    GetVanillaSprite(1)
)

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_THE_LOST,
    GetVanillaSprite(2)
)

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_THE_UNKNOWN,
    GetVanillaSprite(3)
)

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_MAZE,
    GetVanillaSprite(5)
)

CursedTrapdoorsMod:AddCurse(
    LevelCurse.CURSE_OF_BLIND,
    GetVanillaSprite(6)
)
--#endregion


--#region MOD COMPAT

--#region Curse API
function CursedTrapdoorsMod:CurseAPICompat()
    if CurseAPI then
        CursedTrapdoorsMod:ChangeCursesUIAnm2("gfx/ui/def_curses.anm2")
    end
end
--#endregion

--#region Cursed Collection
function CursedTrapdoorsMod:CurseCollectionCompat()
    if CURCOL then
        local curcolCurses = {
            Famine = 3,
            Decay = 0,
            Blight = 4,
            Conquest = 2,
            Rebirth = 5,
            Creation = 6,
        }
        for name, frame in pairs(curcolCurses) do
            local sprite = Sprite()
            sprite:Load("gfx/ui/CURCOL_curse_icons.anm2", true)
            sprite:Play("Idle", true)
            sprite:SetFrame(frame)

            local curse = 1 << (Isaac.GetCurseIdByName("Curse of " .. name) - 1)
            CursedTrapdoorsMod:AddCurse(curse, sprite)
        end
    end
end
--#endregion

--#region Curse of Full Clear

function CursedTrapdoorsMod:CurseOfTheFullClearCompat()
    if Isaac.GetCurseIdByName("Curse of the Fullclear") > 1 then
        local curse = 1 << (Isaac.GetCurseIdByName("Curse of the Fullclear") - 1)

        local sprite = Sprite()
        sprite:Load(CursedTrapdoorsMod:GetCursesUIAnm2(), true)
        sprite:Play("curses", true)
        sprite:SetFrame(7)

        CursedTrapdoorsMod:AddCurse(curse, sprite)
    end
end

--#endregion

--#region Fiend Folio

function CursedTrapdoorsMod:FiendFolioCompat()
    if FiendFolio then
        local BLACK_LANTERN_CURSES = {
            1 << (FiendFolio.curses.impCurse - 1),
            1 << (FiendFolio.curses.stoneCurse - 1),
            1 << (FiendFolio.curses.sunCurse - 1),
            1 << (FiendFolio.curses.swineCurse - 1),
            1 << (FiendFolio.curses.scytheCurse - 1),
            1 << (FiendFolio.curses.ghostCurse - 1),
            1 << (FiendFolio.curses.masterCurse - 1),
        }

        local BLACK_LANTERN_CURSE_ANIMATION = {
            [1 << (FiendFolio.curses.impCurse - 1)] = "ffcurseimp",
            [1 << (FiendFolio.curses.stoneCurse - 1)] = "ffcursegolem",
            [1 << (FiendFolio.curses.sunCurse - 1)] = "ffcursesun",
            [1 << (FiendFolio.curses.swineCurse - 1)] = "ffcurseswine",
            [1 << (FiendFolio.curses.scytheCurse - 1)] = "ffcursescythe",
            [1 << (FiendFolio.curses.ghostCurse - 1)] = "ffcurseghost",
            [1 << (FiendFolio.curses.masterCurse - 1)] = "ffcursemaster",
        }

        BLACK_LANTERN_CURSE_ANM2 = "gfx/ui/minimapapi/icons.anm2"

        for _, curse in ipairs(BLACK_LANTERN_CURSES) do
            local curseSprite = Sprite()
            curseSprite:Load(BLACK_LANTERN_CURSE_ANM2, true)
            curseSprite:Play(BLACK_LANTERN_CURSE_ANIMATION[curse])

            CursedTrapdoorsMod:AddCurse(curse, curseSprite)
        end

        IsaacReflourished:AddPriorityCallback(
            CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_CHANCE,
            CallbackPriority.EARLY,
            function ()
                if PlayerManager.AnyoneHasCollectible(FiendFolio.ITEM.COLLECTIBLE.BLACK_LANTERN) then
                    return true
                end
            end
        )

        IsaacReflourished:AddPriorityCallback(
            CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
            CallbackPriority.EARLY,
            function(_, curse)
                if not PlayerManager.AnyoneHasCollectible(FiendFolio.ITEM.COLLECTIBLE.BLACK_LANTERN) then
                    if BLACK_LANTERN_CURSE_ANIMATION[curse] then
                        return 0
                    end

                    return
                end

                if BLACK_LANTERN_CURSE_ANIMATION[curse] then
                    return 1
                else
                    return 0
                end
            end
        )

        IsaacReflourished:AddCallback(
            CursedTrapdoorsMod.Enums.CustomCallback.POST_SET_LEVEL_CURSES,
            function (_, _, curseFromTrapdoor)
                --This is taken directly from ff code
                local player = Game():GetPlayer(0)

                if curseFromTrapdoor == 1 << (FiendFolio.curses.sunCurse - 1) then
                    player:GetData().sunCurseCounter = 0
                elseif curseFromTrapdoor == 1 << (FiendFolio.curses.masterCurse - 1) then
                    player:GetData().ffsavedata.masterLevel = FiendFolio.MASTERCURSE_STYLE_MAX / 2
                elseif curseFromTrapdoor == 1 << (FiendFolio.curses.scytheCurse - 1) then
                    player:GetData().ffsavedata.scytheRage = 0
                end

                player:GetData().lastBlackLanternCurse = curseFromTrapdoor
            end
        )
    end
end

--#endregion

--#region MinimapAPI

function CursedTrapdoorsMod:MinimapAPICompat()
    if MinimapAPI and not CurseAPI then
        CursedTrapdoorsMod:ChangeCursesUIAnm2("gfx/ui/minimapapi_mapitemicons.anm2")
    end
end

--#endregion

--#region Curse of Mortality

function CursedTrapdoorsMod:CurseOfMortalityCompat()
    if CurseOfMortality then
        local sprite = Sprite()
        sprite:Load("gfx/ui/mortality_curse_icon.anm2", true)
        sprite:Play("Idle", true)
        sprite:SetFrame(0)

        CursedTrapdoorsMod:AddCurse(CurseOfMortality.CurseBitMask, sprite)

        IsaacReflourished:AddPriorityCallback(
            CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_CHANCE,
            CallbackPriority.EARLY,
            function (_, stage)
                if stage == LevelStage.STAGE7 then
                    return true
                end
            end
        )

        IsaacReflourished:AddPriorityCallback(
            CursedTrapdoorsMod.Enums.CustomCallback.PRE_GET_CURSE_WEIGHT,
            CallbackPriority.EARLY,
            function(_, curse, stage)
                if stage == LevelStage.STAGE7 then
                    if curse == CurseOfMortality.CurseBitMask then
                        return 1
                    else
                        return 0
                    end
                elseif curse == CurseOfMortality.CurseBitMask then
                    return 0
                end
            end
        )
    end
end




--#endregion

function CursedTrapdoorsMod:HandleModCompat()

    CursedTrapdoorsMod:CurseAPICompat()
    CursedTrapdoorsMod:CurseCollectionCompat()
    CursedTrapdoorsMod:CurseOfTheFullClearCompat()
    CursedTrapdoorsMod:FiendFolioCompat()
    CursedTrapdoorsMod:MinimapAPICompat()
    CursedTrapdoorsMod:CurseOfMortalityCompat()

end
IsaacReflourished:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, CursedTrapdoorsMod.HandleModCompat)
if Isaac.GetFrameCount() > 0 then CursedTrapdoorsMod:HandleModCompat() end
--#endregion


--#region TSIL stuff

local function TSILRemoveFlags(flags, ...)
	local flagsToRemove = {...}

	for _, flag in ipairs(flagsToRemove) do
		flags = flags & ~flag
	end

	return flags
end

local function TSILAddFlags(flags, ...)
	local flagsToAdd = {...}

	for _, flag in ipairs(flagsToAdd) do
		flags = flags | flag
	end

	return flags
end


--#endregion


local curseNextFloor = LevelCurse.CURSE_NONE


---Returns all the curses this mods accounts for
---@return LevelCurse[]
local function GetAllPossibleCurses()
    local curses = {}

    for curse, _ in pairs(CurseDefinitions) do
        curses[#curses + 1] = curse
    end

    return curses
end


---@param position Vector
---@return GridEntity?
local function GetTrapdoor(position)
    local room = Game():GetRoom()

    local gridEntity = room:GetGridEntityFromPos(position)
    if gridEntity and gridEntity:GetType() == GridEntityType.GRID_TRAPDOOR then
        return gridEntity
    end
end


---@param curses LevelCurse
local function OnCurseEval(_, curses)
    if CursedTrapdoorsMod:SpawnCursesFirstFloor() and Game():GetFrameCount() == 0 then
        return
    end

    --We only remove the curses we manage, to maintain some compat (?)
    local possibleCurses = GetAllPossibleCurses()
    curses = TSILRemoveFlags(
        curses,
        table.unpack(possibleCurses)
    )

    curses = TSILAddFlags(curses, curseNextFloor)

    local callbacks = Isaac.GetCallbacks(CursedTrapdoorsMod.Enums.CustomCallback.POST_SET_LEVEL_CURSES)
    for _, callback in ipairs(callbacks) do
        local ret = callback.Function(callback.Mod, curses, curseNextFloor)
        if type(ret) == "number" then
            curses = ret
        end
    end

    curseNextFloor = LevelCurse.CURSE_NONE

    return curses
end
IsaacReflourished:AddPriorityCallback(
    ModCallbacks.MC_POST_CURSE_EVAL,
    1, --slightly late so it overrides modded curse logic to run its own logic so the trapdoors match
    OnCurseEval
)


local TrapdoorInfo = {}
local HeavenLightInfo = {}

local FINAL_TRAPDOOR_GRID_INDEX_PER_SHAPE = {
    [RoomShape.ROOMSHAPE_1x1] = 37
}
local SECRET_EXIT_TRAPDOOR_GRID_INDEX = 67
local HUSH_BOSS_TRAPDOOR_GRID_INDEX = 125
local VOID_PORTAL_TRAPDOOR_VARIANT = 1


---@param trapdoor GridEntity
local function ShouldTrapdoorUseVanillaGen(trapdoor)
    local level = Game():GetLevel()
    local room = level:GetCurrentRoomDesc()
    local stage = level:GetStage()

    if trapdoor:GetVariant() == VOID_PORTAL_TRAPDOOR_VARIANT then
        local save = IsaacReflourished.SaveManager.GetFloorSave()
        if not save.Accursed then
            save.Accursed = {}
        end

        local uniqueIndex = room.ListIndex .. "." .. trapdoor:GetGridIndex()
        if not save.Accursed.FirstVoidTrapdoor or save.Accursed.FirstVoidTrapdoor == uniqueIndex then
            save.Accursed.FirstVoidTrapdoor = uniqueIndex
            return true, true
        end
    elseif stage == LevelStage.STAGE4_3 and room.Data.Type == RoomType.ROOM_BOSS and room.Data.Shape == RoomShape.ROOMSHAPE_2x2 then
        if trapdoor:GetGridIndex() == HUSH_BOSS_TRAPDOOR_GRID_INDEX then
            return true, false
        end
    elseif CursedTrapdoorsMod:SecretExitHasVanillaGen() and room.GridIndex == GridRooms.ROOM_SECRET_EXIT_IDX then
        if trapdoor:GetGridIndex() == SECRET_EXIT_TRAPDOOR_GRID_INDEX then
            return true, false
        end
    elseif room.ListIndex == level:GetLastBossRoomListIndex() then
        local finalGridIndex = FINAL_TRAPDOOR_GRID_INDEX_PER_SHAPE[room.Data.Shape]
        if trapdoor:GetGridIndex() == finalGridIndex then
            return true, false
        end
    end

    return false, false
end


---@param trapdoor GridEntity
local function GetTrapdoorInfo(trapdoor)
    local level = Game():GetLevel()
    local room = level:GetCurrentRoomDesc()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    local index = trapdoor:GetSaveState().SpawnSeed

    local info = TrapdoorInfo[index]

    if not info then
        local curse

        if stage == LevelStage.STAGE4_2
        and (stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B)
        and room.GridIndex > 0
        and room.Data.Type == RoomType.ROOM_BOSS then
            curse = LevelCurse.CURSE_NONE
        else
            local vanillaGen, isVoid = ShouldTrapdoorUseVanillaGen(trapdoor)
            if vanillaGen then
                curse = IsaacReflourished.CurseLogic:GetNextCurse(nil, isVoid)
            else
                local rng = RNG()
                local spawnSeed = trapdoor:GetSaveState().SpawnSeed
                if spawnSeed == 0 then 
                    spawnSeed = trapdoor:GetSaveState().VariableSeed
                end
                rng:SetSeed(spawnSeed, 35)
                curse = IsaacReflourished.CurseLogic:GetNextCurse(rng)
            end
        end

        info = {
            curse = curse,
            prevAnimation = trapdoor:GetSprite():GetAnimation(),
            iconFrame = 0
        }
        TrapdoorInfo[index] = info
    end

    return info
end


---@param heavenLight EntityEffect
local function GetHeavenLightInfo(heavenLight)
    local room = Game():GetRoom()
    local gridIndex = room:GetGridIndex(heavenLight.Position)
    local index = gridIndex .. "-" .. heavenLight.InitSeed

    local info = HeavenLightInfo[index]

    if not info then
        local rng = RNG()
        rng:SetSeed(heavenLight.InitSeed, 35)
        local curse = IsaacReflourished.CurseLogic:GetNextCurse(rng)

        info = {
            curse = curse,
            hasFinishedOpening = false,
            iconFrame = 0,
            doInitialEffect = false
        }
        HeavenLightInfo[index] = info
    end

    return info
end


local function OnNewRoom()
    TrapdoorInfo = {}
    HeavenLightInfo = {}
end
IsaacReflourished:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    OnNewRoom
)


---@param curse LevelCurse
---@param frame integer
---@param basePos Vector
local function RenderCurseIcon(curse, frame, basePos)
    if not CursedTrapdoorsMod:ShouldShowIcon() then return end
    if excludedChallenges[Game().Challenge] then return end
    local alpha = frame * 0.05
    alpha = math.min(alpha, 1)

    local yOffset = -10 - (frame * 0.1)
    yOffset = math.max(yOffset, -15)

    if yOffset == -15 then
        yOffset = -15 + math.sin((frame + 10) / 20) * 2
    end

    local renderPos = Isaac.WorldToScreen(basePos)
    renderPos = Vector(renderPos.X, renderPos.Y + yOffset)
    local spriteToRender = CurseDefinitions[curse].Sprite

    spriteToRender.Color = Color(1, 1, 1, alpha)
    spriteToRender:Render(renderPos)
end



local function OnRender()
    if #CurseIconsToRender == 0 then return end
    for key, info in pairs(CurseIconsToRender) do
        --print(info.curse)
        RenderCurseIcon(info.curse, info.iconFrame, info.position)
        table.remove(CurseIconsToRender, key)
    end
end
IsaacReflourished:AddCallback(ModCallbacks.MC_POST_RENDER, OnRender)

---@param gridEntity GridEntity
local function OnTrapdoorRender(_, gridEntity)
    local info = GetTrapdoorInfo(gridEntity)

    if info.curse == LevelCurse.CURSE_NONE then return end

    local sprite = gridEntity:GetSprite()
    local currentAnimation = sprite:GetAnimation()

    if currentAnimation == "Opened" then
        if info.prevAnimation ~= currentAnimation then
            local poof = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.POOF02,
                0,
                gridEntity.Position,
                Vector.Zero,
                nil
            )

            poof.Color = Color(0, 0, 0)

            local halo = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.HALO,
                8, --Dark arts halo
                gridEntity.Position,
                Vector.Zero,
                nil
            )

            halo.SpriteScale = Vector(0.5, 0.5)
        end

        table.insert(CurseIconsToRender,
            {curse = info.curse,
            iconFrame = info.iconFrame,
            position = gridEntity.Position}
        )

        if not Game():IsPaused() then
            info.iconFrame = info.iconFrame + 1

            if info.iconFrame % 70 == 0 then
                local halo = Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.HALO,
                    8, --Dark arts halo
                    gridEntity.Position,
                    Vector.Zero,
                    nil
                )

                halo.SpriteScale = Vector(0.5, 0.5)
                halo:GetSprite().PlaybackSpeed = 0.3
                halo.Color = Color(0, 0, 0, 0.5)

            end
            if info.iconFrame % 10 == 0 then
                local speed = math.random() * 6
                local angle = math.random(0, 359)
                local velocity = Vector(speed, 0):Rotated(angle)

                local posOffset = Vector(
                    math.random(-16, 16),
                    math.random(-16, 16)
                )

                local smoke = Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.DARK_BALL_SMOKE_PARTICLE,
                    0,
                    gridEntity.Position + posOffset,
                    velocity,
                    nil
                ):ToEffect()
                if not smoke then return end

                smoke:GetSprite():Load("gfx/effects/curse_smoke.anm2", true)
                smoke:GetSprite():Play("Poof", true)
                smoke.Color = Color(0, 0, 0, 1)


                smoke:SetTimeout(60)
                smoke.SpriteScale = Vector(0.8, 0.8)
                smoke:GetSprite().PlaybackSpeed = 0.5

            end

            -- if info.iconFrame % 15 == 0 then
            --     local speed = math.random() * 0.001
            --     local angle = math.random(0, 359)
            --     local velocity = Vector(speed, 0):Rotated(angle)


            --     local posOffset = Vector(
            --         math.random(-16, 16),
            --         math.random(-16, 16)
            --     )

            --     local smoke = Isaac.Spawn(
            --         EntityType.ENTITY_EFFECT,
            --         EffectVariant.HAEMO_TRAIL,
            --         0,
            --         gridEntity.Position + posOffset,
            --         Vector(0, 0),
            --         nil
            --     ):ToEffect()
            --     if not smoke then return end

            --     smoke.SpriteScale = Vector(0.7, 0.7)
            --     smoke:SetTimeout(30)
            --     smoke:GetSprite().PlaybackSpeed = 0.5
            --     smoke.Color = Color(0, 0, 0, 1)
            -- end
        end
    end

    info.prevAnimation = currentAnimation
end
IsaacReflourished:AddCallback(
    ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_RENDER,
    OnTrapdoorRender
)


---@param effect EntityEffect
local function OnHeavenDoorUpdate(_, effect)
    if effect.SubType ~= 0 then return end

    local info = GetHeavenLightInfo(effect)

    if info.curse == LevelCurse.CURSE_NONE then return end

    if info.doInitialEffect then
        local poof = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.POOF02,
            0,
            effect.Position,
            Vector.Zero,
            nil
        )

        poof.Color = Color(0, 0, 0)

        local halo = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.HALO,
            8, --Dark arts halo
            effect.Position,
            Vector.Zero,
            nil
        )

        halo.SpriteScale = Vector(0.5, 0.5)

        info.doInitialEffect = false;
    elseif info.hasFinishedOpening and effect.FrameCount % 30 == 0 then
        local speed = math.random() * 0.5
        local angle = math.random(359)
        local velocity = Vector(speed, 0):Rotated(angle)

        local posOffset = Vector(
            math.random(-4, 4),
            -10 + math.random(-4, 4)
        )

        local smoke = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.DARK_BALL_SMOKE_PARTICLE,
            0,
            effect.Position + posOffset,
            velocity,
            nil
        ):ToEffect()
        if not smoke then return end

        smoke:SetTimeout(30)
        smoke:GetSprite().PlaybackSpeed = 0.5
        smoke.Color = Color(0.7, 0.7, 0.7, 0.7)
    end
end
IsaacReflourished:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    OnHeavenDoorUpdate,
    EffectVariant.HEAVEN_LIGHT_DOOR
)


---@param effect EntityEffect
local function OnHeavenDoorRender(_, effect)
    if effect.SubType ~= 0 then return end

    local info = GetHeavenLightInfo(effect)

    if info.curse == LevelCurse.CURSE_NONE then return end

    local sprite = effect:GetSprite()
    local hasFinished = sprite:IsFinished("Appear")
    local wasFinished = info.hasFinishedOpening

    if hasFinished and not wasFinished then
        --Just opened
        info.doInitialEffect = true

        info.hasFinishedOpening = true
    elseif wasFinished then
        table.insert(CurseIconsToRender,
            {curse = info.curse,
            iconFrame = info.iconFrame,
            position = effect.Position}
        )

        if not Game():IsPaused() then
            info.iconFrame = info.iconFrame + 1
        end
    end
end
IsaacReflourished:AddCallback(
    ModCallbacks.MC_POST_EFFECT_RENDER,
    OnHeavenDoorRender,
    EffectVariant.HEAVEN_LIGHT_DOOR
)


---@param player EntityPlayer
local function OnPlayerUpdate(_, player)
    local trapdoor = GetTrapdoor(player.Position)

    if not trapdoor or trapdoor.State == 0 then
        local heavenDoors = Isaac.FindByType(
            EntityType.ENTITY_EFFECT,
            EffectVariant.HEAVEN_LIGHT_DOOR,
            0
        )
        for _, heavenDoor in ipairs(heavenDoors) do
            if heavenDoor.Position:DistanceSquared(player.Position) < 1 then
                ---@diagnostic disable-next-line: param-type-mismatch
                local info = GetHeavenLightInfo(heavenDoor:ToEffect())
                curseNextFloor = info.curse
            end
        end

        return
    end

    local info = GetTrapdoorInfo(trapdoor)
    curseNextFloor = info.curse
end
IsaacReflourished:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    OnPlayerUpdate
)

end
return CursedTrapdoorsModEnabler