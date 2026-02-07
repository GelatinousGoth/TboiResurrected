local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Sacrifice Room Rework", 1, true)

local game = Game()
local itemPool = game:GetItemPool()
local itemConfig = Isaac.GetItemConfig()
local sfx = SFXManager()
local zeroV = Vector.Zero

local getDamageMulti = require("resurrected_modpack.tweaks.sac_room_rework.get_damage_multi")
local s = require("resurrected_modpack.tweaks.sac_room_rework.savedata")
s.init(mod)

local SAC_ROOM_EFFECT = Isaac.GetEntityVariantByName("Sac Room Icon")
local EFFECT_OFFSET = Vector(1, -32)
local POOF_VOLUME = 1.5
local HEART_SAC_VOLUME = 0.5

local TOTAL_SAC_ROOM_VARIANTS = 4
---@enum SAC_ROOM_VARIANTS
local SAC_ROOM_VARIANTS = {
    CROSS = 0,
    HEART = 1,
    SHEEP = 2,
    CROWN = 3,
    SHEEP_DEAD = 4,
}
local MAX_SAC_ROOM_USES = {
    HEART = 2,
    SHEEP = 1,
    CROWN = 3,
}
local SAC_ROOMS_DATA = {
    HEART = {
        RewardDelay = 33,

        DropChance = 0.5,
        AngelChance = 0.10,
        NoLostBrBossChance = 0.45,
        TreasureChance = 0.45,
    },
    SHEEP = {
        RewardDelay = 33,
        Blacklist = {
            [CollectibleType.COLLECTIBLE_1UP] = true,
            [CollectibleType.COLLECTIBLE_DEAD_CAT] = true,
        },
    },
    CROWN = {
        RewardDelay = 33,

        TotalStats = 6,
        StatCount = 2,
        HealAmount = 6,
        SoulHeart = 2,

        Speed = 0.1,
        Range = 2.0,
        ShotSpeed = 0.15,
        Damage = 0.55,
        TearsMulti = 0.06,
        Luck = 1,
    },
}
local FUNCTIONS_MAP = {}
local familiarItemCache = nil
local questItemCache = nil
local shouldOverrideHurtSfx = 0

---@return SAC_ROOM_VARIANTS
local function getSacRoomVariant()
    return s.getSacRoomData().Variant
end

---@param variant SAC_ROOM_VARIANTS
local function setSacRoomVariant(variant)
    s.getSacRoomData().Variant = variant
end

local function getSacRoomUses()
    return s.getSacRoomData().EffectiveUses
end

local function addSacRoomUses()
    local sacData = s.getSacRoomData()
    sacData.EffectiveUses = sacData.EffectiveUses + 1
end

local function isSacRoomMaxed(variant)
    local roomUses = getSacRoomUses()

    if variant == SAC_ROOM_VARIANTS.HEART then
        return roomUses >= MAX_SAC_ROOM_USES.HEART
    elseif variant == SAC_ROOM_VARIANTS.SHEEP then
        return roomUses >= MAX_SAC_ROOM_USES.SHEEP
    elseif variant == SAC_ROOM_VARIANTS.CROWN then
        return roomUses >= MAX_SAC_ROOM_USES.CROWN
    end

    return false
end

local function getSacRoomSeed()
    return s.getSacRoomData().RNGSeed
end

local function setSacRoomSeed(seed)
    s.getSacRoomData().RNGSeed = seed
end

local function getSacRoomRNG()
    local sacData = s.getSacRoomData()
    local rng = RNG(sacData.RNGSeed)

    for i = 1, sacData.RNGUSes do
        rng:Next()
    end

    return rng
end

local function addSacRoomRNGUses()
    local sacData = s.getSacRoomData()
    sacData.RNGUSes = sacData.RNGUSes + 1
end

local function getRewardDelay()
    return s.getSacRoomData().rewardDelay
end

local function setRewardDelay(amount)
    s.getSacRoomData().rewardDelay = amount
end

local function updateRewardDelay()
    local sacData = s.getSacRoomData()
    sacData.rewardDelay = sacData.rewardDelay - 1
end

local function getRewardFunction()
    return FUNCTIONS_MAP[s.getSacRoomData().rewardFunc]
end

local function setRewardFunction(funcName)
    s.getSacRoomData().rewardFunc = funcName
end

local function getRewardPlayerIndex()
    return s.getSacRoomData().rewardPlayerIndex
end

local function setRewardPlayerIndex(playerIndex)
    s.getSacRoomData().rewardPlayerIndex = playerIndex
end

local function getRngFloat(rng)
    addSacRoomRNGUses()
    return rng:RandomFloat()
end

local function getRngInt(rng, x)
    addSacRoomRNGUses()
    return rng:RandomInt(x)
end

local function getNoLostBrBossItems()
    local removedItems = itemPool:GetRemovedCollectibles()
    local items = itemPool:GetCollectiblesFromPool(ItemPoolType.POOL_BOSS)
    local filteredItems = WeightedOutcomePicker()

    for i = 1, #items do
        local item = items[i]
        local config = itemConfig:GetCollectible(item.itemID)

        if not removedItems[item.itemID]
        and not config:HasTags(ItemConfig.TAG_NO_LOST_BR)
        then
            filteredItems:AddOutcomeFloat(item.itemID, item.weight)
        end
    end

    return filteredItems
end

local function rollForHeart()
    local rng = getSacRoomRNG()
    local roll = getRngFloat(rng)

    return roll <= SAC_ROOMS_DATA.HEART.DropChance
end

local function rollHeartItem()
    local rng = getSacRoomRNG()
    local seed = getSacRoomSeed()
    local chances = SAC_ROOMS_DATA.HEART
    local roll = getRngFloat(rng)

    if roll <= chances.AngelChance then
        return itemPool:GetCollectible(ItemPoolType.POOL_ANGEL, true, seed)
    elseif roll <= (chances.AngelChance + chances.NoLostBrBossChance) then
        local itemsList = getNoLostBrBossItems()
        local item = itemsList:PickOutcome(rng)
        addSacRoomRNGUses()
        itemPool:RemoveCollectible(item)

        return item or CollectibleType.COLLECTIBLE_BREAKFAST
    elseif roll <= (chances.AngelChance + chances.NoLostBrBossChance + chances.TreasureChance) then
        return itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, seed)
    end

    return CollectibleType.COLLECTIBLE_BREAKFAST
end

local function getFamiliarItems()
    if familiarItemCache then
        return familiarItemCache
    end

    familiarItemCache = {}
    
    ---@diagnostic disable-next-line: unused-function, undefined-field
    for i = 1, itemConfig:GetCollectibles().Size - 1 do
        local item = itemConfig:GetCollectible(i)

        if item
        and item.Type == ItemType.ITEM_FAMILIAR
        then
            familiarItemCache[#familiarItemCache + 1] = item.ID
        end
    end

    return familiarItemCache
end

local function anyPlayerHasFamiliars()
    local players = PlayerManager.GetPlayers()
    local familiarItems = getFamiliarItems()

    for _, player in ipairs(players) do
        local collList = player:GetCollectiblesList()

        for i = 1, #familiarItems do
            local itemId = familiarItems[i]
            if collList[itemId] ~= 0 then
                local config = itemConfig:GetCollectible(itemId)
    
                if config
                and not config:HasTags(ItemConfig.TAG_QUEST)
                and not SAC_ROOMS_DATA.SHEEP.Blacklist[itemId]
                then
                    return true
                end
            end
        end
    end

    return false
end

local function getPlayerFamiliars(player)
    local collList = player:GetCollectiblesList()
    local familiarItems = getFamiliarItems()
    local familiars = WeightedOutcomePicker()
    local hasFamiliar = false

    for i = 1, #familiarItems do
        local itemId = familiarItems[i]
        for count = 1, collList[itemId] do
            local config = itemConfig:GetCollectible(itemId)

            if config
            and not config:HasTags(ItemConfig.TAG_QUEST)
            and not SAC_ROOMS_DATA.SHEEP.Blacklist[itemId]
            then
                familiars:AddOutcomeWeight(itemId, 1)
                hasFamiliar = true
            end
        end
    end

    if not hasFamiliar then
        return false
    end

    return familiars
end

local function getSheepItem(player)
    local familiarsList = getPlayerFamiliars(player)

    if not familiarsList then
        return false
    end

    local rng = getSacRoomRNG()
    addSacRoomRNGUses()

    return familiarsList:PickOutcome(rng)
end

local function getMinGlitchedItemId()
    local glitchedItemId = 0

    while itemConfig:GetCollectible(glitchedItemId - 1) do
        glitchedItemId = glitchedItemId - 1
    end

    return glitchedItemId
end

local function getQuestItems()
    if questItemCache then
        return questItemCache
    end

    questItemCache = {}
    
    ---@diagnostic disable-next-line: unused-function, undefined-field
    for i = 1, itemConfig:GetCollectibles().Size - 1 do
        local item = itemConfig:GetCollectible(i)

        if item
        and item:HasTags(ItemConfig.TAG_QUEST)
        then
            questItemCache[#questItemCache + 1] = item.ID
        end
    end

    return questItemCache
end

local function anyPlayerHasCollectibles()
    local players = PlayerManager.GetPlayers()
    local minGlitchedItemId = getMinGlitchedItemId()
    local questItems = getQuestItems()

    for _, player in ipairs(players) do
        local hasPocketActive = player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0
        local hasSecondPocketActive = player:GetActiveItem(ActiveSlot.SLOT_POCKET2) ~= 0
        local pollyVoid = player:GetPlayerType() == PlayerType.PLAYER_APOLLYON and player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
        local modifier = (hasPocketActive and 1 or 0) + (hasSecondPocketActive and 1 or 0) + (pollyVoid and 1 or 0)

        for i = 1, #questItems do
            local totalItems = player:GetCollectibleNum(questItems[i], true, true)
            modifier = modifier + totalItems
        end

        if player:GetCollectibleCount() > modifier then
            return true
        else
            for i = -1, minGlitchedItemId, -1 do
                if player:HasCollectible(i) then
                    return true
                end
            end
        end
    end

    return false
end

local function getCollsList(player)
    local collList = player:GetCollectiblesList()
    
    for i = 0, getMinGlitchedItemId(), -1 do
        collList[i] = player:HasCollectible(i) and 1 or 0
    end

    return collList
end

---@param player EntityPlayer
local function getPlayerItems(player)
    local collList = getCollsList(player)
    local items = WeightedOutcomePicker()
    local hasItem = false

    local pocketActive = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
    local pocketActive2 = player:GetActiveItem(ActiveSlot.SLOT_POCKET2)
    local skippedPocketActive = false
    local skippedPocketActive2 = false

    for itemId = getMinGlitchedItemId(), #collList do
        for count = 1, collList[itemId] do
            if itemId == CollectibleType.COLLECTIBLE_NULL then
                goto continue
            end

            if itemId == pocketActive
            and not skippedPocketActive
            then
                skippedPocketActive = true
            elseif itemId == pocketActive2
            and not skippedPocketActive2
            then
                skippedPocketActive2 = true
            elseif itemId == CollectibleType.COLLECTIBLE_VOID
            and player:GetPlayerType() == PlayerType.PLAYER_APOLLYON
            then
                goto continue
            else
                local config = itemConfig:GetCollectible(itemId)

                if not config:HasTags(ItemConfig.TAG_QUEST) then
                    items:AddOutcomeWeight(itemId, 1)
                    hasItem = true
                end
            end

            ::continue::
        end
    end

    if not hasItem then
        return false
    end

    return items
end

local function getCrownItem(player)
    local itemsList = getPlayerItems(player)

    if not itemsList then
        return false
    end

    local rng = getSacRoomRNG()
    addSacRoomRNGUses()

    return itemsList:PickOutcome(rng)
end

---@param player EntityPlayer
local function getCrownStat(player)
    local rng = getSacRoomRNG()
    local stats = SAC_ROOMS_DATA.CROWN
    local roll = getRngInt(rng, stats.TotalStats)

    if roll == 0 then
        return "Speed", CacheFlag.CACHE_SPEED, stats.Speed
    elseif roll == 1 then
        return "Range", CacheFlag.CACHE_RANGE, stats.Range
    elseif roll == 2 then
        return "ShotSpeed", CacheFlag.CACHE_SHOTSPEED, stats.ShotSpeed
    elseif roll == 3 then
        return "Damage", CacheFlag.CACHE_DAMAGE, stats.Damage
    elseif roll == 4 then
        return "Tears", CacheFlag.CACHE_FIREDELAY, stats.TearsMulti
    elseif roll == 5 then
        return "Luck", CacheFlag.CACHE_LUCK, stats.Luck
    end

    return "Damage", CacheFlag.CACHE_DAMAGE, stats.Damage
end

local function setSpikesPosition(gridIndex)
    s.getSacRoomData().SpikePosition = gridIndex
end

local function retractSpikes()
    local room = game:GetRoom()
    local gridIndex = s.getSacRoomData().SpikePosition
    local spike = room:GetGridEntity(gridIndex)
    local sprite = spike:GetSprite()

    if sprite:GetAnimation() ~= "Unsummon" then
        sprite:Play("Unsummon", true)
    end
    spike.State = 1
end

local function unRetractSpikes()
    if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_FLAT_FILE) then
        return
    end

    local room = game:GetRoom()
    local gridIndex = s.getSacRoomData().SpikePosition
    local spike = room:GetGridEntity(gridIndex)
    local sprite = spike:GetSprite()
    local anim = sprite:GetAnimation()

    if anim ~= "Summon"
    and not string.find(anim, "Spikes")
    then
        sprite:Play("Summon", true)
    end
    spike.State = 0
end

local function isPlayerTheLost(player)
    local playerType = player:GetPlayerType()

    return playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B
end

local function tearsMulti(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = math.max(0, currentTears * val)
	
    return math.max((30 / newTears) - 1, -0.75)
end

local function hasHeartContainers(player)
    local hpType = player:GetHealthType()

    if (hpType == HealthType.DEFAULT
        and player:GetMaxHearts() == 0)
    or (hpType == HealthType.SOUL
        and player:GetSoulHearts() == 0)
    then
        return false
    end

    return true
end

local function anyPlayerHasHeartContainers()
    for _, player in ipairs(PlayerManager:GetPlayers()) do
        if player.Variant == PlayerVariant.PLAYER
        and hasHeartContainers(player)
        then
            return true
        end
    end

    return false
end

local function shouldForceCross(level)
    local gameData = Isaac.GetPersistentGameData()

    if gameData:Unlocked(Achievement.FORGOTTEN) then
        return false
    end

    if level:GetStage() == LevelStage.STAGE1_1
    and level:GetStageType() < StageType.STAGETYPE_GREEDMODE
    then
        return true
    end

    return false
end

---@param level Level
local function shouldForceSheep(level)
    local gameData = Isaac.GetPersistentGameData()

    if gameData:Unlocked(Achievement.IT_LIVES)
    or level:GetStageType() >= StageType.STAGETYPE_GREEDMODE
    then
        return false
    end

    local stage = level:GetStage()

    if stage == LevelStage.STAGE4_2
    or (stage == LevelStage.STAGE4_1
        and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0)
    then
        return true
    end

    return false
end

---- Mod Functionality

---@param player EntityPlayer
local function heartSacRoomReward(player)
    local room = game:GetRoom()
    local item = rollHeartItem()
    local spawnPos = room:FindFreePickupSpawnPosition(player:GetPosVel().Position, 65)

    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, item, spawnPos, zeroV, nil)
    sfx:Play(SoundEffect.SOUND_HOLY)
    addSacRoomUses()
end
FUNCTIONS_MAP["heartSacRoomReward"] = heartSacRoomReward

---@param player EntityPlayer
local function setUpHeartSacRoomReward(player)
    if not hasHeartContainers(player) then
        return false
    end

    player:AddMaxHearts(-2)
    sfx:Play(SoundEffect.SOUND_BLACK_POOF, POOF_VOLUME)

    if isPlayerTheLost(player) then
        player:Kill()
        return false
    end

    shouldOverrideHurtSfx = 2
    local hasCoinHP = player:GetHealthType() == HealthType.COIN

    if not hasCoinHP
    and not rollForHeart()
    then
        return true
    end

    setRewardDelay(SAC_ROOMS_DATA.HEART.RewardDelay)
    setRewardFunction("heartSacRoomReward")
    setRewardPlayerIndex(player:GetPlayerIndex())

    return true
end

---@param player EntityPlayer
local function sheepSacRoomReward(player)
    player:UseCard(Card.CARD_JOKER, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD | UseFlag.USE_NOANNOUNCER)
    addSacRoomUses()
    setSacRoomVariant(SAC_ROOM_VARIANTS.SHEEP_DEAD)
end
FUNCTIONS_MAP["sheepSacRoomReward"] = sheepSacRoomReward

---@param player EntityPlayer
local function setUpSheepSacRoomReward(player)
    local itemToRemove = getSheepItem(player)
    
    if not itemToRemove then
        return false
    end

    player:RemoveCollectible(itemToRemove)
    sfx:Play(SoundEffect.SOUND_SIREN_SING_STAB)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, player:GetPosVel().Position, zeroV, nil)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player:GetPosVel().Position, zeroV, nil)

    setRewardDelay(SAC_ROOMS_DATA.SHEEP.RewardDelay)
    setRewardFunction("sheepSacRoomReward")
    setRewardPlayerIndex(player:GetPlayerIndex())
    shouldOverrideHurtSfx = 1

    return true
end

---@param player EntityPlayer
local function deadSheepSacRoomReward(player)
    shouldOverrideHurtSfx = 1
    player:UseCard(Card.CARD_JOKER, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD | UseFlag.USE_NOANNOUNCER)
end

---@param player EntityPlayer
local function crownSacRoomReward(player)
    local data = s.getPlayerData(player)
    local cacheFlags = 0

    player:AddHearts(SAC_ROOMS_DATA.CROWN.HealAmount)

    if player:CanPickSoulHearts() then
        player:AddSoulHearts(SAC_ROOMS_DATA.CROWN.SoulHeart)
        sfx:Play(SoundEffect.SOUND_HOLY, 0.9)
    end

    for i = 1, SAC_ROOMS_DATA.CROWN.StatCount do
        local statName, statCache, statValue = getCrownStat(player)
    
        data[statName] = data[statName] or 0
        data[statName] = data[statName] + statValue
        cacheFlags = cacheFlags | statCache
    end

    addSacRoomUses()

    if cacheFlags ~= 0 then
        player:AddCacheFlags(cacheFlags, true)
    end

    sfx:Play(SoundEffect.SOUND_THUMBSUP, 0.6)
end
FUNCTIONS_MAP["crownSacRoomReward"] = crownSacRoomReward

---@param player EntityPlayer
local function setUpCrownSacRoomReward(player)
    local itemToRemove = getCrownItem(player)
    
    if not itemToRemove then
        return false
    end
    
    player:RemoveCollectible(itemToRemove)
    sfx:Play(SoundEffect.SOUND_BLACK_POOF, POOF_VOLUME)

    setRewardDelay(SAC_ROOMS_DATA.CROWN.RewardDelay)
    setRewardFunction("crownSacRoomReward")
    setRewardPlayerIndex(player:GetPlayerIndex())
    shouldOverrideHurtSfx = 1

    return true
end

function mod:onNewSacRoom()
    local room = game:GetRoom()
    
    if room:GetType() ~= RoomType.ROOM_SACRIFICE
    then
        return
    end

    local roomWidth = room:GetGridWidth()

    for y = 0, room:GetGridHeight() - 1 do
        for x = 0, roomWidth - 1 do
            local gridIndex = x + y * roomWidth
            local gridEnt = room:GetGridEntity(gridIndex)
            
            if gridEnt
            and gridEnt:GetType() == GridEntityType.GRID_SPIKES
            then
                local level = game:GetLevel()
                local gridPos = room:GetGridPosition(gridIndex)
                local spawnPos = gridPos + EFFECT_OFFSET
                
                if getSacRoomVariant() == SAC_ROOM_VARIANTS.SHEEP_DEAD then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, SAC_ROOM_EFFECT, SAC_ROOM_VARIANTS.SHEEP_DEAD, spawnPos, zeroV, nil)
                    return
                end
                
                local rng = RNG(room:GetSpawnSeed())
                local sacRoomVariant = rng:RandomInt(TOTAL_SAC_ROOM_VARIANTS)

                if shouldForceCross(level) then
                    sacRoomVariant = SAC_ROOM_VARIANTS.CROSS
                elseif shouldForceSheep(level) then
                    sacRoomVariant = SAC_ROOM_VARIANTS.SHEEP
                end

                setSacRoomVariant(sacRoomVariant)
                setSacRoomSeed(room:GetAwardSeed())
                setSpikesPosition(gridIndex)

                if not isSacRoomMaxed(sacRoomVariant) then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, SAC_ROOM_EFFECT, sacRoomVariant, spawnPos, zeroV, nil)
                else
                    retractSpikes()
                end
                
                return
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewSacRoom)

---@param player EntityPlayer
function mod:playerTakeDmg(player, damage, damageFlags, damageSource, damageCountdown)
    local room = game:GetRoom()

    if room:GetType() == RoomType.ROOM_SACRIFICE
    and damageFlags & DamageFlag.DAMAGE_SPIKES ~= 0
    and damageFlags & DamageFlag.DAMAGE_NO_PENALTIES ~= 0
    and getSacRoomVariant() ~= SAC_ROOM_VARIANTS.CROSS
    and player:GetDamageCooldown() <= 0
    then
        local hasBlindRage = player:HasTrinket(TrinketType.TRINKET_BLIND_RAGE)
        local blindRageMulti = hasBlindRage and 1.5 or 1
        local sacRoomVar = getSacRoomVariant()
        local shouldTakeDamage = true
        
        if getRewardDelay() == 0 then
            if sacRoomVar == SAC_ROOM_VARIANTS.HEART then
                shouldTakeDamage = setUpHeartSacRoomReward(player)
            elseif sacRoomVar == SAC_ROOM_VARIANTS.SHEEP then
                shouldTakeDamage = setUpSheepSacRoomReward(player)
            elseif sacRoomVar == SAC_ROOM_VARIANTS.SHEEP_DEAD then
                deadSheepSacRoomReward(player)
            elseif sacRoomVar == SAC_ROOM_VARIANTS.CROWN then
                shouldTakeDamage = setUpCrownSacRoomReward(player)
            end
        
            if shouldTakeDamage then
                player:PlayExtraAnimation("Hit")
                sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
            end
        end

        player:SetMinDamageCooldown(damageCountdown * 3 * blindRageMulti)
        return false
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.EARLY, mod.playerTakeDmg)

function mod:overrideHurtSfx(soundId, volume, frameDelay, loop, pitch, pan)
    if shouldOverrideHurtSfx == 1 then
        shouldOverrideHurtSfx = 0
        return false
    elseif shouldOverrideHurtSfx == 2 then
        shouldOverrideHurtSfx = 0
        return {soundId, HEART_SAC_VOLUME, frameDelay, loop, pitch, pan}
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.overrideHurtSfx, SoundEffect.SOUND_ISAAC_HURT_GRUNT)

function mod:postUpdate()
    local rewardFunc = getRewardFunction()

    if not rewardFunc then
        return
    end

    if getRewardDelay() > 0 then
        updateRewardDelay()
        return
    end

    local player = Isaac.GetPlayer(getRewardPlayerIndex())
    rewardFunc(player)

    setRewardFunction(nil)
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.postUpdate)

---@param effect EntityEffect
function mod:postSacRoomIconInit(effect)
    local sprite = effect:GetSprite()

    if effect.SubType == SAC_ROOM_VARIANTS.HEART then
        sprite:Play("Heart", true)

        if not anyPlayerHasHeartContainers() then
            retractSpikes()
        end
    elseif effect.SubType == SAC_ROOM_VARIANTS.SHEEP then
        sprite:Play("Sheep", true)

        if not anyPlayerHasFamiliars() then
            retractSpikes()
        end
    elseif effect.SubType == SAC_ROOM_VARIANTS.CROWN then
        sprite:Play("Crown", true)

        if not anyPlayerHasCollectibles() then
            retractSpikes()
        end
    elseif effect.SubType == SAC_ROOM_VARIANTS.SHEEP_DEAD then
        sprite:Play("SheepDead", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.postSacRoomIconInit, SAC_ROOM_EFFECT)

---@param effect EntityEffect
function mod:postSacRoomIconUpdate(effect)
    local sprite = effect:GetSprite()

    if string.find(sprite:GetAnimation(), "Fade") then
        if sprite:IsFinished() then
            effect:Remove()
        end
        return
    end

    local checkRetract = game:GetFrameCount() % 30 == 0

    if effect.SubType == SAC_ROOM_VARIANTS.HEART then
        if isSacRoomMaxed(SAC_ROOM_VARIANTS.HEART) then
            sprite:Play("HeartFade", true)

            retractSpikes()
        elseif checkRetract then
            if anyPlayerHasHeartContainers() then
                unRetractSpikes()
            else
                retractSpikes()
            end
        end
    elseif effect.SubType == SAC_ROOM_VARIANTS.SHEEP then
        if isSacRoomMaxed(SAC_ROOM_VARIANTS.SHEEP) then
            sprite:Play("SheepFade", true)

            retractSpikes()
        elseif checkRetract then
            if anyPlayerHasFamiliars() then
                unRetractSpikes()
            else
                retractSpikes()
            end
        end
    elseif effect.SubType == SAC_ROOM_VARIANTS.CROWN then
        if isSacRoomMaxed(SAC_ROOM_VARIANTS.CROWN) then
            sprite:Play("CrownFade", true)

            retractSpikes()
        elseif checkRetract then
            if anyPlayerHasCollectibles() then
                unRetractSpikes()
            else
                retractSpikes()
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.postSacRoomIconUpdate, SAC_ROOM_EFFECT)

---@param player EntityPlayer
function mod:onSpeedCache(player)
    local data = s.getPlayerData(player)

    if not data.Speed then
        return
    end

    player.MoveSpeed = player.MoveSpeed + data.Speed
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onSpeedCache, CacheFlag.CACHE_SPEED)

---@param player EntityPlayer
function mod:onRangeCache(player)
    local data = s.getPlayerData(player)

    if not data.Range then
        return
    end
    
	player.TearRange = player.TearRange + (data.Range * 40)
	player.TearHeight = player.TearHeight - data.Range
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onRangeCache, CacheFlag.CACHE_RANGE)

---@param player EntityPlayer
function mod:onShotSpeedCache(player)
    local data = s.getPlayerData(player)

    if not data.ShotSpeed then
        return
    end

    player.ShotSpeed = player.ShotSpeed + data.ShotSpeed
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onShotSpeedCache, CacheFlag.CACHE_SHOTSPEED)

---@param player EntityPlayer
function mod:onDamageCache(player)
    local data = s.getPlayerData(player)

    if not data.Damage then
        return
    end

    local mult = getDamageMulti(player)

	player.Damage = player.Damage + (data.Damage * mult)
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onDamageCache, CacheFlag.CACHE_DAMAGE)

---@param player EntityPlayer
function mod:onTearsCache(player)
    local data = s.getPlayerData(player)

    if not data.Tears then
        return
    end

    local multi = 1 + data.Tears
	player.MaxFireDelay = tearsMulti(player.MaxFireDelay, multi)
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE - 25, mod.onTearsCache, CacheFlag.CACHE_FIREDELAY)

---@param player EntityPlayer
function mod:onLuckCache(player)
    local data = s.getPlayerData(player)

    if not data.Luck then
        return
    end

	player.Luck = player.Luck + data.Luck
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onLuckCache, CacheFlag.CACHE_LUCK)

if EID then

local heartRoomDesc = "Sacrifice 1 {{Heart}} container for a 50% chance at spawning 1 {{Collectible}}"
local heartRoomDescCoin = "# {{Player14}} 100% chance to spawn 1 {{Collectible}}"
local heartRoomDescNone = "# {{Player10}} Attempting to sacrifice will kill you"
local sheepRoomDesc = "Sacrifice 1 {{Collectible".. CollectibleType.COLLECTIBLE_BROTHER_BOBBY .. "}} to instantly teleport to the {{DevilRoom}}{{AngelRoom}} room"
local crownRoomDesc = "Sacrifice 1 {{Collectible}} to get two random stat ups {{ArrowUp}} # Heals 3 {{Heart}} and grants 1 {{SoulHeart}} on sacrifice"
local deadSheepRoomDesc = "Instantly teleport to the {{DevilRoom}}{{AngelRoom}} room for free"

local function customSacrificeRoomCondition(descObj)
    if descObj.ObjType == -999
    and descObj.ObjVariant == 8
    then
        return true
    end
end

local function customSacrificeRoomCallback(descObj)
    local sacRoom = getSacRoomVariant()

    if sacRoom == SAC_ROOM_VARIANTS.HEART then
        descObj.Name = "Heart Sacrifice Room"
        descObj.Description = heartRoomDesc

        local appendedCoin = false
        local appendedNone = false

        for _, player in ipairs(PlayerManager.GetPlayers()) do
            local hpType = player:GetHealthType()

            if hpType == HealthType.COIN
            and not appendedCoin
            then
                descObj.Description = descObj.Description .. heartRoomDescCoin
                appendedCoin = true
            elseif hpType == HealthType.NO_HEALTH
            and not appendedNone
            then
                descObj.Description = descObj.Description .. heartRoomDescNone
                appendedNone = true
            end
        end
    elseif sacRoom == SAC_ROOM_VARIANTS.SHEEP then
        descObj.Name = "Sheep Sacrifice Room"
        descObj.Description = sheepRoomDesc
    elseif sacRoom == SAC_ROOM_VARIANTS.CROWN then
        descObj.Name = "Crown Sacrifice Room"
        descObj.Description = crownRoomDesc
    elseif sacRoom == SAC_ROOM_VARIANTS.SHEEP_DEAD then
        descObj.Name = "Sheep Sacrifice Room"
        descObj.Description = deadSheepRoomDesc
    end

    return descObj
end

EID:addDescriptionModifier("Custom Sac Room Modifier", customSacrificeRoomCondition, customSacrificeRoomCallback)

end
