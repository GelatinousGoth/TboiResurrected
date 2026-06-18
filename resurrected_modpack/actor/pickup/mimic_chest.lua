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

local LOOT_MODIFIER_LUCKY_TOE = 1 << 0
local LOOT_MODIFIER_MOMS_KEY = 1 << 1
local LOOT_MODIFIER_POKER_CHIP = 1 << 2

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

---@param lootList LuaLootList
---@param rng RNG
---@param shouldAdvance boolean
---@param lootModifiers integer -- bitset
local function MimicChest_get_normal_chest_loot(lootList, rng, shouldAdvance, lootModifiers)
    local seed = rng:GetSeed()

    local lootCount = rng:RandomInt(4)
    lootCount = math.min(lootCount, 2)

    ---@type RNG?
    local daemonsTail_rng
    if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_DAEMONS_TAIL) then
        daemonsTail_rng = RNG(seed, 1)
    end

    if rng:RandomInt(3) ~= 0 then
        -- In the vanilla game they would choose the first to succeed
        -- however I feel that each should have the same probability
        local extraPickup_pool = {}

        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_ACE_SPADES) then
            local extraRNG = RNG(seed, 2)
            if extraRNG:RandomInt(2) == 0 then
                table.insert(extraPickup_pool, PickupVariant.PICKUP_TAROTCARD)
            end
        end

        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_SAFETY_CAP) then
            local extraRNG = RNG(seed, 3)
            if extraRNG:RandomInt(2) == 0 then
                table.insert(extraPickup_pool, PickupVariant.PICKUP_PILL)
            end
        end

        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_MATCH_STICK) then
            local extraRNG = RNG(seed, 4)
            if extraRNG:RandomInt(2) == 0 then
                table.insert(extraPickup_pool, PickupVariant.PICKUP_BOMB)
            end
        end

        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_CHILDS_HEART) then
            local extraRNG = RNG(seed, 5)
            if extraRNG:RandomInt(2) == 0 and (not daemonsTail_rng or daemonsTail_rng:RandomInt(5) == 0) then
                table.insert(extraPickup_pool, PickupVariant.PICKUP_HEART)
            end
        end

        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_RUSTED_KEY) then
            local extraRNG = RNG(seed, 6)
            if extraRNG:RandomInt(2) == 0 then
                table.insert(extraPickup_pool, PickupVariant.PICKUP_KEY)
            end
        end

        if not #extraPickup_pool == 0 then
            local poolIdx = (seed % #extraPickup_pool) + 1
            local pickupVariant = extraPickup_pool[poolIdx]

            ---@type LuaLootEntry
            local entry = {
                type = EntityType.ENTITY_PICKUP,
                variant = pickupVariant,
                subtype = 0,
                seed = rng:GetSeed()
            }
        end
    end

    if lootModifiers & LOOT_MODIFIER_LUCKY_TOE ~= 0 then
        lootCount = lootCount + 1
    end

    if lootModifiers & LOOT_MODIFIER_MOMS_KEY ~= 0 then
        lootCount = lootCount * 2
    end

    if lootModifiers & LOOT_MODIFIER_POKER_CHIP ~= 0 then
        lootCount = lootCount * 2
    end

    local hasDaemonsTail = daemonsTail_rng ~= nil

    local picker = WeightedOutcomePicker()
    picker:AddOutcomeWeight(PICKUP_COIN, 35)
    local heartWeight = hasDaemonsTail and 4 or 20
    picker:AddOutcomeWeight(PICKUP_HEART, heartWeight)
    picker:AddOutcomeWeight(PICKUP_KEY, 15)
    picker:AddOutcomeWeight(PICKUP_BOMB, 30)

    for i = 1, lootCount, 1 do
        local outcome = picker:PickOutcome(rng)
        local GetLootFn = ChestPickups_Switch_get_loot[outcome]
        GetLootFn({lootList = lootList, rng = rng, shouldAdvance = shouldAdvance})
    end
end

---@param lootLit LuaLootList
---@param rng RNG
local function MimicChest_get_rune_loot(lootLit, rng)
    -- get pools
    local runePool = {entries = {}, totalWeight = 0.0}
    local soulPool = {entries = {}, totalWeight = 0.0}

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

        local pool = runePool
        if s_SoulRunesMap[cardConfig.ID] then
            pool = soulPool
        end

        table.insert(pool.entries, {cardId, cardWeight})
        pool.totalWeight = pool.totalWeight + cardWeight
        ::continue::
    end

    local soulChance = 1/4
    if #soulPool == 0 then
        soulChance = 0
    elseif #runePool == 0 then
        soulChance = 1.0
    end

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

    local lootModifiers = 0
    if PlayerManager.AnyoneHasTrinket(LOOT_MODIFIER_POKER_CHIP) then
        local pokerChip_rng = RNG(rng:GetSeed(), 7)
        if pokerChip_rng:RandomInt(2) ~= 0 then
            return {{
                type = EntityType.ENTITY_ATTACKFLY,
                variant = 0,
                subtype = 0,
                seed = pokerChip_rng:Next()
            }}
        else
            lootModifiers = lootModifiers | LOOT_MODIFIER_POKER_CHIP
        end
    end

    if rng:RandomInt(3) ~= 0 and PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_LUCKY_TOE) then
        lootModifiers = lootModifiers | LOOT_MODIFIER_LUCKY_TOE
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MOMS_KEY) then
        lootModifiers = lootModifiers | LOOT_MODIFIER_MOMS_KEY
    end

    -- rune or soul
    MimicChest_get_rune_loot(lootList, rng)

    -- chest
    local chest_variant = rng:RandomInt(4) < 1 and PickupVariant.PICKUP_LOCKEDCHEST or PickupVariant.PICKUP_CHEST
    ---@type LuaLootEntry
    local chest_entry = {
        type = EntityType.ENTITY_PICKUP,
        variant = chest_variant,
        subtype = 0,
        seed = rng:Next()
    }

    -- base game pickups algorithm
    MimicChest_get_normal_chest_loot(lootList, rng, shouldAdvance, lootModifiers)

    -- random amount of coins
    local coins_count = rng:RandomInt(3) + 1
    if lootModifiers & LOOT_MODIFIER_LUCKY_TOE ~= 0 then
        coins_count = coins_count + 1
    end

    if lootModifiers & LOOT_MODIFIER_MOMS_KEY ~= 0 then
        coins_count = coins_count * 2
    end

    if lootModifiers & LOOT_MODIFIER_POKER_CHIP ~= 0 then
        coins_count = coins_count * 2
    end

    for i = 1, coins_count, 1 do
        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_COLLECTIBLE,
            subtype = 0,
            seed = rng:Next()
        }
    end

    return lootList
end

---@class Actor.Pickup.MimicChest
local Module = {}

--#region Module



--#endregion

return Module