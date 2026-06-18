--#region Dependencies

local LibEnums = require("lib.enums")

--#endregion

---@alias SlotChest.Switch.GetLootList fun(ctx: SlotChest.Switch.Ctx)

---@class SlotChest.Switch.Ctx
---@field lootRNG RNG
---@field lootList LuaLootEntry[]
---@field shouldAdvance boolean
---@field lootModifiers integer -- bitset

local LOOT_MODIFIER = {
    LUCKY_TOE = 1 << 0,
    MOMS_KEY = 1 << 1,
    POKER_CHIP = 1 << 2
}

local ePillEffectSubClass = LibEnums.ePillEffectSubClass
local eLootListOutcome = {
    COLLECTIBLE = 1,
    CARDS = 2,
    PILLS = 3,
}

local SLOT_ITEM_POOL = Isaac.GetPoolIdByName("[TR] slotChest")
local SLOT_ITEM_POOL_DEFAULT = CollectibleType.COLLECTIBLE_PORTABLE_SLOT

-- these specific suit cards were requested
local PLAYING_CARD_POOL = {
    Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_SPADES, Card.CARD_ACE_OF_HEARTS,
    Card.CARD_CLUBS_2, Card.CARD_DIAMONDS_2,
    Card.CARD_SPADES_2, Card.CARD_HEARTS_2,
}

local SPECIAL_CARD_POOL = {
    Card.CARD_CREDIT, Card.CARD_DICE_SHARD, Card.CARD_WILD
}

local g_ItemConfig = Isaac.GetItemConfig()
local g_Game = Game()
local g_Level = g_Game:GetLevel()
local g_ItemPool = g_Game:GetItemPool()
local g_PlayerManager = PlayerManager

---@type SlotChest.Switch.GetLootList
local function Loot_get_collectible(ctx)
    local rng = ctx.lootRNG
    local lootList = ctx.lootList
    local shouldAdvance = ctx.shouldAdvance

    local collectible = g_ItemPool:GetCollectible(SLOT_ITEM_POOL, shouldAdvance, rng:Next(), SLOT_ITEM_POOL_DEFAULT)
    ---@type LuaLootEntry
    local entry = {
        type = EntityType.ENTITY_PICKUP,
        variant = PickupVariant.PICKUP_COLLECTIBLE,
        subtype = collectible,
        seed = rng:GetSeed()
    }

    table.insert(lootList, entry)
end

---@type SlotChest.Switch.GetLootList
local function Loot_get_pill(ctx)
    local rng = ctx.lootRNG
    local lootList = ctx.lootList
    local lootModifiers = ctx.lootModifiers

    -- fetch pools
    local goodPool = {}
    local badPool = {}
    local neutralPool = {}

    local SUBCLASS_TO_POOL = {
        [ePillEffectSubClass.NEUTRAL + 1] = neutralPool,
        [ePillEffectSubClass.POSITIVE + 1] = goodPool,
        [ePillEffectSubClass.NEGATIVE + 1] = badPool,
    }

    for pillColor = 1, PillColor.NUM_PILLS, 1 do
        local pillEffect = g_ItemPool:GetPillEffect(pillColor, nil)
        local pillEffect_config = g_ItemConfig:GetPillEffect(pillEffect)
        local pillEffect_subClass = pillEffect_config.EffectSubClass

        local pool = SUBCLASS_TO_POOL[pillEffect_subClass + 1]
        table.insert(pool, pillEffect)
    end

    if #goodPool == 0 then
        goodPool = neutralPool
    end

    if #badPool == 0 then
        badPool = neutralPool
    end

    -- get loot count
    local lootCount = 2
    if lootModifiers & LOOT_MODIFIER.MOMS_KEY ~= 0 then
        lootCount = lootCount * 2
    end

    if lootModifiers & LOOT_MODIFIER.POKER_CHIP ~= 0 then
        lootCount = lootCount * 2
    end

    -- get loot
    for i = 1, lootCount, 2 do
        local goodPillSeed = rng:Next()
        local badPillSeed = rng:Next()
        local goodPill
        local badPill

        if #goodPool == 0 or #badPool == 0 then
            goodPill = g_ItemPool:GetPill(goodPillSeed) & PillColor.PILL_COLOR_MASK
            badPill = g_ItemPool:GetPill(badPillSeed) & PillColor.PILL_COLOR_MASK
        else
            local goodPill_idx = (goodPillSeed % #goodPool) + 1
            local badPill_idx = (badPillSeed % #badPool) + 1

            goodPill = goodPool[goodPill_idx]
            badPill = badPool[badPill_idx]
        end

        -- horse morph
        local horseMorph = rng:RandomInt(2)
        if horseMorph == 0 then
            goodPill = goodPill | PillColor.PILL_GIANT_FLAG
        else
            badPill = badPill | PillColor.PILL_GIANT_FLAG
        end

        ---@type LuaLootEntry
        local goodPillEntry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_PILL,
            subtype = goodPill,
            seed = goodPillSeed
        }

        ---@type LuaLootEntry
        local badPillEntry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_PILL,
            subtype = badPill,
            seed = badPillSeed
        }

        table.insert(lootList, goodPillEntry)
        table.insert(lootList, badPillEntry)
    end

    -- lucky toe modifier
    if lootModifiers & LOOT_MODIFIER.LUCKY_TOE ~= 0 then
        local pillSeed = rng:Next()
        local pill

        if #neutralPool == 0 then
            pill = g_ItemPool:GetPill(pillSeed)
        else
            local pillIdx = (pillSeed % #neutralPool) + 1
            pill = neutralPool[pillIdx]
        end

        ---@type LuaLootEntry
        local entry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_PILL,
            subtype = pill,
            seed = pillSeed
        }

        table.insert(lootList, entry)
    end
end

---@type SlotChest.Switch.GetLootList
local function Loot_get_card(ctx)
    local rng = ctx.lootRNG
    local lootList = ctx.lootList
    local lootModifiers = ctx.lootModifiers

    -- get loot count
    local lootCount = 2
    if lootModifiers & LOOT_MODIFIER.MOMS_KEY ~= 0 then
        lootCount = lootCount * 2
    end

    if lootModifiers & LOOT_MODIFIER.POKER_CHIP ~= 0 then
        lootCount = lootCount * 2
    end

    local playingCardCount = #PLAYING_CARD_POOL
    local specialCardCount = #SPECIAL_CARD_POOL

    for i = 1, lootCount, 2 do
        local playingCardSeed = rng:Next()
        local specialCardSeed = rng:Next()

        local playingCardIdx = (playingCardSeed % playingCardCount) + 1
        local specialCardIdx = (specialCardSeed % specialCardCount) + 1

        local playingCard = PLAYING_CARD_POOL[playingCardIdx]
        local specialCard = SPECIAL_CARD_POOL[specialCardIdx]

        ---@type LuaLootEntry
        local playingCardEntry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = playingCard,
            seed = playingCardSeed
        }

        ---@type LuaLootEntry
        local specialCardEntry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = specialCard,
            seed = specialCardSeed
        }

        table.insert(lootList, playingCardEntry)
        table.insert(lootList, specialCardEntry)
    end


    if lootModifiers & LOOT_MODIFIER.LUCKY_TOE ~= 0 then
        local playingCardSeed = rng:Next()
        local playingCardIdx = (playingCardSeed % playingCardCount) + 1
        local playingCard = PLAYING_CARD_POOL[playingCardIdx]

        ---@type LuaLootEntry
        local playingCardEntry = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = playingCard,
            seed = playingCardSeed
        }

        table.insert(lootList, playingCardEntry)
    end
end

local Switch_GetLootList = {
    [eLootListOutcome.COLLECTIBLE] = Loot_get_collectible,
    [eLootListOutcome.CARDS] = Loot_get_card,
    [eLootListOutcome.PILLS] = Loot_get_pill
}

---@param rng RNG
---@param shouldAdvance boolean
---@return LuaLootEntry[]
local function SlotChest_GetLootList(rng, shouldAdvance)
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

    local seed = rng:GetSeed()
    local luckyToe_rng = RNG(seed, 1)
    local pokerChip_rng = RNG(seed, 7)

    -- get loot modifiers
    local lootModifiers = 0

    if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_POKER_CHIP) then
        if pokerChip_rng:RandomInt(2) ~= 0 then
            return {{
                type = EntityType.ENTITY_ATTACKFLY,
                variant = 0,
                subtype = 0,
                seed = pokerChip_rng:Next()
            }}
        end

        lootModifiers = lootModifiers | LOOT_MODIFIER.POKER_CHIP
    end

    if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_LUCKY_TOE) and luckyToe_rng:RandomInt(3) ~= 0 then
        lootModifiers = lootModifiers | LOOT_MODIFIER.LUCKY_TOE
    end

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MOMS_KEY) then
        lootModifiers = lootModifiers | LOOT_MODIFIER.MOMS_KEY
    end

    local aceOfSpadesEffect = g_PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_ACE_SPADES)
    local safetyCapEffect = g_PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_SAFETY_CAP)

    local cardChance = 10
    local pillChance = 10

    if aceOfSpadesEffect then
        cardChance = cardChance + 1
        pillChance = pillChance - 1
    end

    if safetyCapEffect then
        cardChance = cardChance - 1
        pillChance = pillChance + 1
    end

    local picker = WeightedOutcomePicker()
    picker:AddOutcomeWeight(eLootListOutcome.COLLECTIBLE, 10)
    picker:AddOutcomeWeight(eLootListOutcome.CARDS, cardChance)
    picker:AddOutcomeWeight(eLootListOutcome.PILLS, pillChance)

    -- equal chance for each outcome
    local outcomeIdx = picker:PickOutcome(rng)
    local GetLootListFn = Switch_GetLootList[outcomeIdx]

    ---@type SlotChest.Switch.Ctx
    local ctx = {
        lootRNG = rng,
        lootList = lootList,
        shouldAdvance = shouldAdvance,
        lootModifiers = lootModifiers,
    }

    GetLootListFn(ctx)
    return lootList
end

---@class Actor.Pickup.SlotChest
local Module = {}

--#region Module

--#endregion

return Module