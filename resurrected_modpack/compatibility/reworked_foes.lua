local mod = require("resurrected_modpack.mod_reference")

local previousLockCallbackRecord = mod.LockCallbackRecord

local modName = "Reworked Compatibility"
local lockCallbackRecord = true

mod.CurrentModName = modName
mod.LockCallbackRecord = lockCallbackRecord

---------------------------------------------------------------------------------------------------
--------------------------------------REWORKED COMPATIBILITY---------------------------------------
---------------------------------------------------------------------------------------------------

local entityType = 1
local entityVariant = 2
local anm2Path = 3

local isDeliriumInRoom = false

local delayedDeliriumAnm2 = {}

local BossPortraitLayer = 4
local BossNameLayer = 7

local isCustomVersusScreen
local isOddFrame

local versusBossSprite = Sprite()
versusBossSprite:Load("gfx/ui/boss/versusscreen.anm2", false)

local function ResetVersusSpriteSheet()
    for i=0, versusBossSprite:GetLayerCount() do
        versusBossSprite:ReplaceSpritesheet(i, "gfx/null.png")
    end
end

--------------------------------------------DATA TABLES--------------------------------------------

local reworkedAnm2 = { -- Add a new entry if the animation for the Reworked Enemy cannot be merged with Vanilla {EntityType, EntityVariant, Anm2Path}
    [BossType.GISH] = {EntityType.ENTITY_MONSTRO2, 1, "gfx/043.001_gish_reworked.anm2"},
    [BossType.TRIACHNID] = {EntityType.ENTITY_DADDYLONGLEGS, 1, "gfx/101.001_triachnid_reworked.anm2"},
    [BossType.BLUE_BABY] = {EntityType.ENTITY_ISAAC, 1, "gfx/102.001_ (final boss)_reworked.anm2"},
    [BossType.THE_FORSAKEN] = {EntityType.ENTITY_FORSAKEN, 0, "gfx/403.000_theforsaken_reworked.anm2"}
}

local bossColorAnm2 = { -- Add a new entry if a Boss Champion is defined using an anm2Path rather than a prefix within bosscolors.xml
    [BossType.GISH] = {
        ["gfx/043.001_gish_heraglow.anm2"] = true
    }
}

local deliriumFormBanList = {} -- Add a Vanilla Banned Delirium Form {EntityType, EntityVariant}

local deliriumFormBanList_Reworked = { -- Add a Vanilla Banned Delirium Form {EntityType, EntityVariant}
    {EntityType.ENTITY_MONSTRO2, 1},
    {EntityType.ENTITY_DADDYLONGLEGS, 1},
    {EntityType.ENTITY_DADDYLONGLEGS, 10} -- If Delirium turns into this he instantly dies.
}

local deliriumSprites = { -- When a new reworkedAnm2 entry is created add the delirium Sprites here: {[LayerID] = Anm2Path}
    [BossType.GISH] = {
        [0] = "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_051_gish_reworked.png"
    },
    [BossType.BLUE_BABY] = {
        [0] = "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_078_bluebaby.png"
    },
    [BossType.THE_FORSAKEN] ={
        [0] = "gfx/bosses/afterbirthplus/deliriumforms/afterbirth/theforsaken.png"
    }
}

local deliriumAnm2 = { -- If the deliriumSprites method doesn't work create a specific anm2 file and add it here
    [BossType.TRIACHNID] = "gfx/bosses/afterbirthplus/deliriumforms/101.001_triachnid_reworked.anm2"
}

local VersusSprite = { -- If the Boss requires a different spritesheet for the Versus Screen Portrait then add it here
    [BossType.BLUE_BABY] = {
        [BossPortraitLayer] = {
            Original = "gfx/ui/boss/portrait_102.1_bluebaby.png",
            Vanilla = "gfx/ui/boss/portrait_102.1_bluebaby_vanilla.png",
            Reworked = "gfx/ui/boss/portrait_102.1_bluebaby_reworked.png"
        },
        [BossNameLayer] = {
            Original = "gfx/ui/boss/bossname_102.1_bluebaby.png",
            Vanilla = "gfx/ui/boss/bossname_102.1_bluebaby_vanilla.png",
            Reworked = "gfx/ui/boss/bossname_102.1_bluebaby_reworked.png"
        }
    }
}

---------------------------------------------FUNCTIONS---------------------------------------------

for bossID, reworked in pairs(reworkedAnm2) do
    local function ApplyReworkedAnm2(_, Entity)
        if not ReworkedFoes or Entity.Variant ~= reworked[entityVariant] or (Entity:GetBossColorIdx() ~= -1 and bossColorAnm2[bossID] and bossColorAnm2[bossID][Entity:GetSprite():GetFilename()]) then
            return
        end

        local sprite = Entity:GetSprite()
        sprite:Load(reworked[anm2Path])

        if isDeliriumInRoom then
            delayedDeliriumAnm2[bossID] = reworked[anm2Path]
        end
    end

    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, ApplyReworkedAnm2, reworked[entityType])
end

local function HandleTriachnidLegs(_, Legs)
    local sprite = Legs:GetSprite()
    local anm2Filename = "gfx/101.001_triachnid_reworked.anm2"
    if isDeliriumInRoom then
        anm2Filename = "gfx/bosses/afterbirthplus/deliriumforms/101.001_triachnid_reworked.anm2"
    end
    sprite:Load(anm2Filename)
end

local function HandleTriachnidFoot(_, EntityDaddyLongLegs)
    if EntityDaddyLongLegs.Variant == 10 and isDeliriumInRoom and not EntityDaddyLongLegs:GetData().DeliriumChanged then
        local sprite = EntityDaddyLongLegs:GetSprite()
        sprite:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_067_triachnid_reworked.png")
        sprite:LoadGraphics()
        EntityDaddyLongLegs:GetData().DeliriumChanged = true
    end
end

local function onPostModLoad()
    if ReworkedFoes then
        mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, HandleTriachnidLegs, ReworkedFoes.Entities.TriachnidLeg, modName, lockCallbackRecord)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, onPostModLoad)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, HandleTriachnidFoot, EntityType.ENTITY_DADDYLONGLEGS)

local function ApplyReworkedDeliriumSpriteSheet(_, EntityDelirium)
    local bossID = EntityDelirium:GetBossID()
    local reworkedAnm2Path = deliriumAnm2[bossID] or delayedDeliriumAnm2[bossID]

    local sprite = EntityDelirium:GetSprite()

    if reworkedAnm2Path then
        sprite:Load(reworkedAnm2Path)

        local pngFilenames = deliriumSprites[bossID]
        if pngFilenames then
            for layerID, pngFilename in pairs(pngFilenames) do
                sprite:ReplaceSpritesheet(layerID, pngFilename)
            end
            sprite:LoadGraphics()
        end
        local currentAnimation = sprite:GetAnimation()
        if currentAnimation == "" then -- Fix Animation being stuck
            sprite:Play(sprite:GetDefaultAnimationName())
        end
    end
    delayedDeliriumAnm2 = {}
end

for _, bannedForm in pairs(deliriumFormBanList) do
    local function PreventDeliriumMorph(_, Entity)
        if ReworkedFoes then
            return
        end
        if Entity.Variant == bannedForm[entityVariant] and isDeliriumInRoom then
            Entity:Morph(EntityType.ENTITY_DELIRIUM, 0, 0, -1)
            Entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PreventDeliriumMorph, bannedForm[entityType])
end

for _, bannedForm in pairs(deliriumFormBanList_Reworked) do
    local function PreventDeliriumMorph(_, Entity)
        if not ReworkedFoes then
            return
        end
        if Entity.Variant == bannedForm[entityVariant] and isDeliriumInRoom then
            Entity:Morph(EntityType.ENTITY_DELIRIUM, 0, 0, -1)
            Entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PreventDeliriumMorph, bannedForm[entityType])
end

local function CheckForDeliriumPresence()
    isDeliriumInRoom = #Isaac.FindByType(EntityType.ENTITY_DELIRIUM) > 0
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CheckForDeliriumPresence)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function() isDeliriumInRoom = true end, EntityType.ENTITY_DELIRIUM)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, CheckForDeliriumPresence, EntityType.ENTITY_DELIRIUM)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, ApplyReworkedDeliriumSpriteSheet, EntityType.ENTITY_DELIRIUM)

local function CheckForCustomVS()
	isCustomVersusScreen = false
	local room = Game():GetRoom()
	if (room:GetType() == RoomType.ROOM_BOSS) and (not room:IsClear()) then
        local BossId = room:GetBossID()
        if not VersusSprite[BossId] then
            return
        end
        if mod.Functions.GetStageAPIBossId() then
            return
        end

        ResetVersusSpriteSheet()
        local Mode = "Vanilla"
        if ReworkedFoes then
            Mode = "Reworked"
        end
        for layer, sheet in pairs(VersusSprite[BossId]) do
            local spriteSheet = sheet[Mode] or sheet.Vanilla
            versusBossSprite:ReplaceSpritesheet(layer, spriteSheet)
        end
        versusBossSprite:LoadGraphics()
        isCustomVersusScreen = true
    else
        isCustomVersusScreen = false
	end
end

local function RenderCustomVS()
    isOddFrame = not isOddFrame
    if isCustomVersusScreen then
        if not Game():IsPaused() then
            versusBossSprite:Stop()
        end
        if not versusBossSprite:IsPlaying("Scene") then
            versusBossSprite:Play("Scene", true)
        end
        versusBossSprite:Render(mod.Functions.GetScreenSize() / 2, Vector.Zero, Vector.Zero)
        if isOddFrame then
            versusBossSprite:Update()
        end
    else
        if versusBossSprite:IsPlaying("Scene") then
            versusBossSprite:Stop()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CheckForCustomVS)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, RenderCustomVS)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() isCustomVersusScreen = false end)

mod.LockCallbackRecord = previousLockCallbackRecord
