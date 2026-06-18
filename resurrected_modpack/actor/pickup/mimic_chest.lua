--#region Dependencies



--#endregion

---@alias MimicChest.Switch.PickupLootList fun(ctx: MimicChest.Context.GetLoot)

---@class MimicChest.Context.GetLoot
---@field lootList LuaLootList
---@field rng RNG
---@field shouldAdvance boolean

local g_ItemConfig = Isaac.GetItemConfig()
local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_ItemPool = g_Game:GetItemPool()

local s_SoulRunesMap = {
    [Card.CARD_SOUL_ISAAC] = true,
    [Card.CARD_SOUL_MAGDALENE] = true,
    [Card.CARD_SOUL_CAIN] = true,
    [Card.CARD_SOUL_JUDAS] = true,
    [Card.CARD_SOUL_BLUEBABY] = true,
    [Card.CARD_SOUL_EVE] = true,
    [Card.CARD_SOUL_SAMSON] = true,
    [Card.CARD_SOUL_AZAZEL] = true,
    [Card.CARD_SOUL_LAZARUS] = true,
    [Card.CARD_SOUL_EDEN] = true,
    [Card.CARD_SOUL_LOST] = true,
    [Card.CARD_SOUL_LILITH] = true,
    [Card.CARD_SOUL_KEEPER] = true,
    [Card.CARD_SOUL_APOLLYON] = true,
    [Card.CARD_SOUL_FORGOTTEN] = true,
    [Card.CARD_SOUL_BETHANY] = true,
    [Card.CARD_SOUL_JACOB] = true,
}

local PICKUP_COIN = 1
local PICKUP_HEART = 2
local PICKUP_KEY = 3
local PICKUP_BOMB = 4

---@type table<integer, MimicChest.Switch.PickupLootList>
local ChestPickups_Switch_get_loot = {
    [PICKUP_COIN] = function(ctx)
        local count = ctx.rng:RandomInt(3) + 1
        for i = 1, count, 1 do
            ---@type LuaLootEntry
            local entry = {
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COIN,
                subtype = 0,
                seed = ctx.rng:Next()
            }

            table.insert(ctx.lootList, entry)
        end
    end,
    [PICKUP_HEART] = function(ctx)
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_HEART,
            subtype = 0,
            seed = ctx.rng:Next()
        }

        table.insert(ctx.lootList, entry)
    end,
    [PICKUP_KEY] = function(ctx)
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_KEY,
            subtype = 0,
            seed = ctx.rng:Next()
        }

        table.insert(ctx.lootList, entry)
    end,
    [PICKUP_BOMB] = function(ctx)
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_BOMB,
            subtype = 0,
            seed = ctx.rng:Next()
        }

        table.insert(ctx.lootList, entry)
    end,
}

---@param lootLit LuaLootList
---@param rng RNG
---@param runePool table
---@param soulPool table
---@param soulChance number
local function MimicChest_get_rune_loot(lootLit, rng, runePool, soulPool, soulChance)
    local rune_chosenPool = rng:RandomFloat() < soulChance and soulPool or runePool
    local rune_seed = rng:Next()
    local rune_chosenRune

    if #rune_chosenPool == 0 then
        rune_chosenRune = g_ItemPool:GetCard(rune_seed, false, true, true)
    else
        local randomFloat = rune_seed * (1.0 / (2^32)) -- [0, 1)
        local targetWeight = randomFloat * rune_chosenPool.totalWeight
        local entries = rune_chosenPool.entries
        local weight = 0.0
        local runeIt = 1
        local currentRune

        repeat
            currentRune = entries[runeIt]
            weight = weight + currentRune[2]
            runeIt = runeIt + 1
        until weight >= targetWeight

        rune_chosenRune = currentRune[1]
    end

    ---@type LuaLootEntry
    local rune_entry = {
        type = EntityType.ENTITY_PICKUP,
        variant = PickupVariant.PICKUP_TAROTCARD,
        subtype = rune_chosenRune,
        seed = rng:Next()
    }

    table.insert(lootLit, rune_entry)
end

---@param rng RNG
---@param shouldAdvance boolean
---@return LuaLootEntry[]
local function MimicChest_GetLootList(rng, shouldAdvance)
    ---@type LuaLootEntry[]
    local lootList = {}

    local level_isStage6 = g_Level:GetStage() == LevelStage.STAGE6 and not g_Game:IsGreedMode()
    if level_isStage6 then
        local collectible = g_ItemPool:GetCollectible(ItemPoolType.POOL_TREASURE, shouldAdvance, rng:Next(), CollectibleType.COLLECTIBLE_NULL)
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_COLLECTIBLE,
            subtype = collectible,
            seed = rng:GetSeed()
        }

        return lootList
    end

    -- get constants
    local hasDaemonsTail = PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_DAEMONS_TAIL)

    local baseChestLoot_picker = WeightedOutcomePicker()
    baseChestLoot_picker:AddOutcomeWeight(PICKUP_COIN, 35)
    local heartWeight = hasDaemonsTail and 4 or 20
    baseChestLoot_picker:AddOutcomeWeight(PICKUP_HEART, heartWeight)
    baseChestLoot_picker:AddOutcomeWeight(PICKUP_KEY, 15)
    baseChestLoot_picker:AddOutcomeWeight(PICKUP_BOMB, 30)

    local rune_runePool = {entries = {}, totalWeight = 0.0}
    local rune_soulPool = {entries = {}, totalWeight = 0.0}

    local cardCount = #g_ItemConfig:GetCards()
    for i = 1, cardCount, 1 do
        local id = i - 1
        local cardConfig = g_ItemConfig:GetCard(id)

        if not cardConfig:IsRune() then
            goto continue
        end

        if not cardConfig:IsAvailable() then
            goto continue
        end

        local cardId = cardConfig.ID
        local cardWeight = cardConfig.Weight

        if cardWeight <= 0.0 then
            goto continue
        end

        local pool = rune_runePool
        if s_SoulRunesMap[cardConfig.ID] then
            pool = rune_soulPool
        end

        table.insert(pool.entries, {cardId, cardWeight})
        pool.totalWeight = pool.totalWeight + cardWeight
        ::continue::
    end

    local rune_soulChance = 1/4
    if #rune_soulPool == 0 then
        rune_soulChance = 0
    elseif #rune_runePool == 0 then
        rune_soulChance = 1.0
    end

    -- random amount of coins
    local coins_count = rng:RandomInt(3) + 1
    for i = 1, coins_count, 1 do
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_COLLECTIBLE,
            subtype = 0,
            seed = rng:Next()
        }
    end

    -- base game pickups algorithm
    local outcome = baseChestLoot_picker:PickOutcome(rng)
    local GetLootFn = ChestPickups_Switch_get_loot[outcome]
    GetLootFn({lootList = lootList, rng = rng, shouldAdvance = shouldAdvance})

    -- rune or soul
    MimicChest_get_rune_loot(lootList, rng, rune_runePool, rune_soulPool, rune_soulChance)

    -- chest
    local chest_variant = rng:RandomInt(4) < 1 and PickupVariant.PICKUP_LOCKEDCHEST or PickupVariant.PICKUP_CHEST
    ---@type LuaLootEntry
    local chest_entry = {
        type = EntityType.ENTITY_PICKUP,
        variant = chest_variant,
        subtype = 0,
        seed = rng:Next()
    }

    return lootList
end

---@class Actor.Pickup.MimicChest
local Module = {}

--#region Module



--#endregion

return Module