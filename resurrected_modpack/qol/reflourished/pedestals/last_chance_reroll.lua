local function LastChanceRerollEnabler()

--[[
    Coded by Kerkel
  ,-.       _,---._ __  / \
 /  )    .-'       `./ /   \
(  (   ,'            `/    /|
 \  `-"             \'\   / |
  `.              ,  \ \ /  |
   /`.          ,'-`----Y   |
  (            ;        |   '
  |  ,-.    ,-'         |  /
  |  | (   |        hjw | /
  )  |  \  `.___________|/
  `--'   `--'
]]

--Thanks kerkel

local LastChanceReroll = {}

LastChanceReroll.Enum = {}

LastChanceReroll.Enum.Obj = {}

LastChanceReroll.Enum.Obj.Game = Game()
LastChanceReroll.Enum.Obj.Config = Isaac.GetItemConfig()

LastChanceReroll.Enum.Dict = {
    ---@type table<CollectibleType, ItemConfigItem>
    COLLECTIBLE_CONFIG = {},
    ---@type table<TrinketType, ItemConfigItem>
    TRINKET_CONFIG = {},
}

LastChanceReroll.Util = {}

---@param variant EffectVariant | integer
---@param position Vector
---@param velocity? Vector
---@param subtype? integer
---@param spawner? Entity
---@param seed? integer
function LastChanceReroll.Util:SpawnEffect(variant, position, velocity, spawner, subtype, seed)
    return LastChanceReroll.Enum.Obj.Game:Spawn(EntityType.ENTITY_EFFECT, variant, position, velocity or Vector.Zero, spawner or nil, subtype or 0, seed or math.max(Random(), 1)):ToEffect()
end

---@param variant PickupVariant | integer
---@param position Vector
---@param velocity? Vector
---@param subtype? integer
---@param spawner? Entity
---@param seed? integer
function LastChanceReroll.Util:SpawnPickup(variant, position, velocity, spawner, subtype, seed)
    return LastChanceReroll.Enum.Obj.Game:Spawn(EntityType.ENTITY_PICKUP, variant, position, velocity or Vector.Zero, spawner or nil, subtype or 0, seed or math.max(Random(), 1)):ToPickup()
end

---@param flags integer
---@param flag integer
function LastChanceReroll.Util:HasFlags(flags, flag)
    return flags & flag ~= 0
end

---@param id CollectibleType
function LastChanceReroll.Util:GetCollectibleConfig(id)
    LastChanceReroll.Enum.Dict.COLLECTIBLE_CONFIG[id] = LastChanceReroll.Enum.Dict.COLLECTIBLE_CONFIG[id] or LastChanceReroll.Enum.Obj.Config:GetCollectible(id)
    return LastChanceReroll.Enum.Dict.COLLECTIBLE_CONFIG[id]
end

---@param id TrinketType
function LastChanceReroll.Util:GetTrinketConfig(id)
    LastChanceReroll.Enum.Dict.TRINKET_CONFIG[id] = LastChanceReroll.Enum.Dict.TRINKET_CONFIG[id] or LastChanceReroll.Enum.Obj.Config:GetTrinket(id)
    return LastChanceReroll.Enum.Dict.TRINKET_CONFIG[id]
end

LastChanceReroll.Source = {}

local t = LastChanceReroll.Source

t.POOF_OFFSET = 12.5

---@type table<CollectibleType, fun(rng: RNG, player: EntityPlayer): CollectibleType, boolean?>
t.COLLECTIBLE_REROLL_FN = {}

t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_D6] = function (rng)
    local seed = rng:Next()

    local pool = LastChanceReroll.Enum.Obj.Game:GetRoom():GetItemPool(seed)
    if not pool or pool == ItemPoolType.POOL_NULL then
        pool = (Game():IsGreedMode() and ItemPoolType.POOL_GREED_TREASURE) or ItemPoolType.POOL_TREASURE
    end
    return LastChanceReroll.Enum.Obj.Game:GetItemPool():GetCollectible(
        pool,
        nil,
        seed
    )
end

t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_D100] = t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_D6]

t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_ETERNAL_D6] = function (rng, player)
    if rng:RandomInt(4) == 0 then
        return CollectibleType.COLLECTIBLE_NULL
    end
    return t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_D6](rng, player)
end

t.COLLECTIBLE_REROLL_FN[CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = function (_, player)
    local id = player.QueuedItem.Item.ID
    local config
    while id > 0 and (not config or config.Hidden) do
        id = id - 1
        config = LastChanceReroll.Util:GetCollectibleConfig(id)
    end
    return config and config.ID or CollectibleType.COLLECTIBLE_NULL
end

---@type table<CollectibleType, fun(rng: RNG, player: EntityPlayer): CollectibleType, boolean?>
t.TRINKET_REROLL_FN = {}

-- t.TRINKET_REROLL_FN[CollectibleType.COLLECTIBLE_D20] = function (rng, player)
--     LastChanceReroll.Util:SpawnPickup(
--         PickupVariant.PICKUP_TRINKET,
--         player.Position,
--         t:PickupVelocity(rng),
--         nil,
--         player.QueuedItem.Item.ID
--     )
--     return 0
-- end

-- t.TRINKET_REROLL_FN[CollectibleType.COLLECTIBLE_D100] = t.TRINKET_REROLL_FN[CollectibleType.COLLECTIBLE_D20]

---@type table<Card, boolean>
t.COLLECTIBLE_REROLL_CARD = {}

---@type table<Card, boolean>
t.COLLECTIBLE_REROLL_RUNE = {
    [Card.RUNE_PERTHRO] = true,
    [Card.CARD_SOUL_EDEN] = true,
}

---@type table<Card, boolean>
t.COLLECTIBLE_REROLL_OBJECT = {
    [Card.CARD_DICE_SHARD] = true,
}

---@type table<Card, boolean>
t.TRINKET_REROLL_CARD = {}

---@type table<Card, boolean>
t.TRINKET_REROLL_RUNE = {}

---@type table<Card, boolean>
t.TRINKET_REROLL_OBJECT = {}

---@type table<CollectibleType, fun(player: EntityPlayer): boolean>
t.COLLECTIBLE_MIMIC_CONDITION = {
    [CollectibleType.COLLECTIBLE_BLANK_CARD] = function (player)
        return t.COLLECTIBLE_REROLL_CARD[player:GetCard(PillCardSlot.PRIMARY)]
    end,
    [CollectibleType.COLLECTIBLE_CLEAR_RUNE] = function (player)
        return t.COLLECTIBLE_REROLL_RUNE[player:GetCard(PillCardSlot.PRIMARY)]
    end,
}

---@param entity Entity
function t:GetData(entity)
    local data = entity:GetData()
    data.________LAST_CHANCE_REROLL = data.________LAST_CHANCE_REROLL or {}
    ---@class LastChanceRerollData
    ---@field PrevQueuedItem ItemConfigItem
    ---@field UseFrame integer
    ---@field RNG RNG
    ---@field ScheduledPostUse function
    ---@field ReachedLateUse boolean
    return data.________LAST_CHANCE_REROLL
end

---@param rng RNG
function t:PickupVelocity(rng)
	return Vector.FromAngle(rng:RandomFloat() * 360):Resized(rng:RandomFloat() * 5 + 2)
end

---@param pickup EntityPickup
---@param collider Entity
IsaacReflourished:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, function (_, pickup, collider)
    if collider.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = collider:ToPlayer() ---@cast player EntityPlayer
    local data = t:GetData(collider)
    if player.QueuedItem.Item and not data.PrevQueuedItem then
        data.RNG = RNG(pickup.InitSeed, 7)
        data.RNG:SetSeed(data.RNG:Next(), 35)
        data.PrevQueuedItem = player.QueuedItem.Item
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

---@param id CollectibleType
---@param rng RNG
IsaacReflourished:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, function (_, id, rng)
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player.QueuedItem.Item then
            if player.QueuedItem.Item.Type ~= ItemType.ITEM_TRINKET then
                local data = t:GetData(player)

                if t.COLLECTIBLE_REROLL_FN[id] then
                    local reroll, hide = t.COLLECTIBLE_REROLL_FN[id](data.RNG or rng, player)
                    local config = LastChanceReroll.Util:GetCollectibleConfig(reroll)

                    if not hide then
                        local effect = LastChanceReroll.Util:SpawnEffect(EffectVariant.POOF01, player.Position)
                        effect.SpriteOffset = Vector(0, -t.POOF_OFFSET * player.SpriteScale.Y)
                    end

                    data.UseFrame = LastChanceReroll.Enum.Obj.Game.TimeCounter
                    data.PrevQueuedItem = player.QueuedItem.Item

                    if config then
                        LastChanceReroll.Enum.Obj.Game:GetHUD():ShowItemText(player, config)

                        data.ScheduledPostUse = function ()
                            if config.Type == ItemType.ITEM_ACTIVE then
                                local desc = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY)

                                if desc.Item > CollectibleType.COLLECTIBLE_NULL then
                                    -- local pickup = LastChanceReroll.Util:SpawnPickup(
                                    --     PickupVariant.PICKUP_COLLECTIBLE,
                                    --     LastChanceReroll.Enum.Obj.Game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40),
                                    --     nil,
                                    --     nil,
                                    --     desc.Item
                                    -- )
                                    -- pickup:SetVarData(desc.VarData)
                                    -- pickup.Charge = desc.Charge - (slot == ActiveSlot.SLOT_PRIMARY and player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY) or 0)
                                    -- pickup.Touched = true
                                    -- player:RemoveCollectible(desc.Item)
                                    player:DropCollectible(desc.Item)
                                end
                            end
                            player:AnimateCollectible(config.ID)
                        end

                        Isaac.CreateTimer(function ()
                            player:QueueItem(config, config.InitCharge)
                            if not data.ReachedLateUse then
                                data.ScheduledPostUse()
                                data.ReachedLateUse = nil
                                data.ScheduledPostUse = nil
                            end
                        end, 1, 1, true)
                    end

                    player:FlushQueueItem()
                end
            elseif t.TRINKET_REROLL_FN[id] then
                local data = t:GetData(player)

                data.PrevQueuedItem = player.QueuedItem.Item

                local config = LastChanceReroll.Util:GetTrinketConfig(t.TRINKET_REROLL_FN[id](rng, player))

                player:FlushQueueItem()
                player:TryRemoveTrinket(data.PrevQueuedItem.ID)

                if config and config.ID > 0 then
                    player:QueueItem(config, nil, nil, data.PrevQueuedItem.ID >= TrinketType.TRINKET_GOLDEN_FLAG)
                end
            end
        end
    end
end)

---@param id CollectibleType
IsaacReflourished:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.LATE, function (_, id)
    if id < CollectibleType.NUM_COLLECTIBLES then return end
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = t:GetData(player)
        if data.ScheduledPostUse then
            data.ReachedLateUse = true
            data.ScheduledPostUse()
            data.ScheduledPostUse = nil
        end
    end
end)

---@param card Card
---@param player EntityPlayer
---@param flags UseFlag
IsaacReflourished:AddPriorityCallback(ModCallbacks.MC_PRE_USE_CARD, CallbackPriority.IMPORTANT, function (_, card, player, flags)
    if not player.QueuedItem.Item or LastChanceReroll.Util:HasFlags(flags, UseFlag.USE_NOANIM) then return end
    if player.QueuedItem.Item.Type == ItemType.ITEM_TRINKET then
        if not (
            t.TRINKET_REROLL_CARD[card]
            or t.TRINKET_REROLL_RUNE[card]
            or t.TRINKET_REROLL_OBJECT[card]
        ) then return end
    else
        if not (
            t.COLLECTIBLE_REROLL_CARD[card]
            or t.COLLECTIBLE_REROLL_RUNE[card]
            or t.COLLECTIBLE_REROLL_OBJECT[card]
        ) then return end
    end
    player:UseCard(card, flags | UseFlag.USE_NOANIM)
    return false
end)

---@param id CollectibleType
---@param charge integer
---@param new boolean
---@param slot ActiveSlot
---@param varData integer
---@param player EntityPlayer
IsaacReflourished:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, CallbackPriority.IMPORTANT, function (_, id, charge, new, slot, varData, player)
    local data = t:GetData(player)
    if data.UseFrame ~= LastChanceReroll.Enum.Obj.Game.TimeCounter
    or not data.PrevQueuedItem
    or data.PrevQueuedItem.ID ~= id then return end
    return false
end)

---@param id CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param flags UseFlag
---@param slot ActiveSlot
IsaacReflourished:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.IMPORTANT, function (_, id, rng, player, flags, slot)
    if not player.QueuedItem.Item
    or not t.COLLECTIBLE_MIMIC_CONDITION[id]
    or not t.COLLECTIBLE_MIMIC_CONDITION[id](player)
    or LastChanceReroll.Util:HasFlags(flags, UseFlag.USE_NOANIM)
    then return end
    player:UseActiveItem(id, flags | UseFlag.USE_NOANIM, slot)
    return true
end)

local function PostModsLoaded()
    if FiendFolio then
        t.COLLECTIBLE_REROLL_FN[FiendFolio.ITEM.COLLECTIBLE.LOADED_D6] = function (rng, player)
            local list = FiendFolio:getLoadedDiceCandidateItems(player)
            return list[rng:RandomInt(1, #list)] or CollectibleType.COLLECTIBLE_NULL
        end

        -- t.TRINKET_REROLL_FN[FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN] = function (rng, player)
        --     local pickup = LastChanceReroll.Util:SpawnPickup(
        --         PickupVariant.PICKUP_TRINKET,
        --         player.Position,
        --         t:PickupVelocity(rng),
        --         nil,
        --         player.QueuedItem.Item.ID
        --     )
        --     LastChanceReroll.Scheduler:Schedule(function ()
        --         local sprite = pickup:GetSprite()
        --         sprite:Play("Appear", true)
        --         sprite:SetFrame(18)
        --     end, 1, LastChanceReroll.Scheduler.Type.LEAVE_ROOM_CANCEL)
        --     return 0
        -- end
    end
    if MilkshakeVol1 then
        t.COLLECTIBLE_REROLL_FN[MilkshakeVol1.enums.Collectibles.PRISMATIC_DICE] = function (_, player)
            local pickup = LastChanceReroll.Util:SpawnPickup(
                PickupVariant.PICKUP_COLLECTIBLE,
                player.Position,
                nil,
                nil,
                player.QueuedItem.Item.ID
            )

            pickup.Touched = true

            return CollectibleType.COLLECTIBLE_NULL, true
        end
    end

end
IsaacReflourished:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, PostModsLoaded)
if Isaac.GetFrameCount() > 0 then PostModsLoaded() end

end
return LastChanceRerollEnabler