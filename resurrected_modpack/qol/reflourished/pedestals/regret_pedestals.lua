local function RegretPedestalsEnabler()

local RegretPedestals = {}
local mod = IsaacReflourished
local enums = mod.Enums
local utility = mod.Utility

local maxArcAngle = 180


-- Function to check if a table contains a value
local function contains(table, value)
    for index, result in ipairs(table) do
        if result == value then
            return true
        end
    end

    return false
end

---@param item EntityPickup
function RegretPedestals:IsBlindPedestal(item)
    if item:GetSprite():GetLayer(1):GetSpritesheetPath() == "gfx/Items/Collectibles/questionmark.png" then return true end
    if item:IsBlind() then return true end
    if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= 0 and (item.Touched == false) then return true end

    return false
end


function RegretPedestals:SpawnGhostItems(item, pos, cycleItems)

    local showCycleItems = IsaacReflourished:GetSettingsValue("RegretShowLostCyclingItems") == 2
    if showCycleItems and cycleItems and #cycleItems > 0 then
        table.insert(cycleItems, item)
        local itemCount = #cycleItems
        local arcAngle = math.min(maxArcAngle, #cycleItems * 13)
        local startAngle = -arcAngle / 2
        local angleStep = arcAngle / (itemCount - 1)

        for key, cycle in pairs(cycleItems) do
            local keyCopy = key
            Isaac.CreateTimer(function()
                local angle = startAngle + ((keyCopy-1) * angleStep)

                local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.GHOST_ITEM.Variant, enums.Effects.GHOST_ITEM.SubType, pos + Vector(0, 8), Vector.FromAngle(angle -90) * 0.5, nil)
                ghost.SpriteRotation = angle
                local sprite = ghost:GetSprite()
                local gfxPath = Isaac.GetItemConfig():GetCollectible(cycle).GfxFileName
                sprite:ReplaceSpritesheet(0, gfxPath, true)
            end, key*3, 1, false)
        end
    else
        local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.GHOST_ITEM.Variant, enums.Effects.GHOST_ITEM.SubType, pos + Vector(0, 3), Vector.Zero, nil)
        local sprite = ghost:GetSprite()
        local gfxPath = Isaac.GetItemConfig():GetCollectible(item).GfxFileName
        sprite:ReplaceSpritesheet(0, gfxPath, true)
    end
end


RegretPedestals.PendingPickups = {}
RegretPedestals.SpawnGhostQueued = false
RegretPedestals.TouchedItem = nil
RegretPedestals.TouchedItemSubType = nil

---@param pickup EntityPickup
---@param collider EntityPlayer
---@param low any
function RegretPedestals:ItemTouched(pickup, collider, low)

    if pickup.SubType <= 0 then return end
    local player = collider:ToPlayer()
    if not player then return end
    if player.Parent then return end
    if pickup.Wait > 0 then return end

    local game = Game()

    local items = Isaac.FindByType(5, 100)
    local disappearingItems = {}

    for _, itemEntity in pairs(items) do
        local item = itemEntity:ToPickup()
        if item and item.SubType > 0 then

            local isInSameOptionsGroup =
                item.OptionsPickupIndex
                and (item.OptionsPickupIndex == pickup.OptionsPickupIndex)
                and (item.OptionsPickupIndex > 0)

            local isSamePedestal = (GetPtrHash(pickup) == GetPtrHash(item))

            local shouldShowGhost = false
            if isInSameOptionsGroup then shouldShowGhost = true end
            if game:GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then shouldShowGhost = true end
            if player:GetPlayerType() == PlayerType.PLAYER_THELOST or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B or player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
            and pickup.Price < 0 and item.Price < 0 then shouldShowGhost = true end
            if isSamePedestal then shouldShowGhost = false end

            if shouldShowGhost then
                if RegretPedestals:IsBlindPedestal(item) then
                    table.insert(disappearingItems, {
                        SubType = item.SubType,
                        Position = item.Position,
                        Cycle = item:GetCollectibleCycle()
                    })
                end
            end
        end
    end

    if #disappearingItems > 0 then
        RegretPedestals.SpawnGhostQueued = true
        RegretPedestals.TouchedItem = pickup
        RegretPedestals.TouchedItemSubType = pickup.SubType
        RegretPedestals.PendingPickups = disappearingItems
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, RegretPedestals.ItemTouched, PickupVariant.PICKUP_COLLECTIBLE)


function RegretPedestals:CheckPendingPickups(pickup)

    if not RegretPedestals.SpawnGhostQueued then return end

    local touchedItem = RegretPedestals.TouchedItem
    if touchedItem:Exists() and touchedItem.SubType > 0 and RegretPedestals.TouchedItemSubType == touchedItem.SubType then
        RegretPedestals.SpawnGhostQueued = false
        RegretPedestals.TouchedItem = nil
        RegretPedestals.PendingPickups = {}
        return
    end

    for _, pickup in pairs(RegretPedestals.PendingPickups) do

        RegretPedestals:SpawnGhostItems(
            pickup.SubType,
            pickup.Position,
            pickup.Cycle
        )
    end
    RegretPedestals.SpawnGhostQueued = false
    RegretPedestals.TouchedItem = nil
    RegretPedestals.PendingPickups = {}
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, RegretPedestals.CheckPendingPickups, PickupVariant.PICKUP_COLLECTIBLE)


local usedSpindown = false
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player)
    usedSpindown = true
    Isaac.CreateTimer(function()
        usedSpindown = false
    end, 1, 1, true)

end, CollectibleType.COLLECTIBLE_SPINDOWN_DICE)


RegretPedestals.PedestalCycleTables = {}

RegretPedestals.IsPedestalMorphing = false

---@param item EntityPickup
function RegretPedestals:PrePedestalMorph(item, type, variant, subtype, keptPrice, keptSeed, ignoreModifiers)
    if item.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if item.SubType <= 0 then return end
    if usedSpindown then return end
    --if item.Touched then return end
    if not RegretPedestals:IsBlindPedestal(item) then return end

    if contains(item:GetCollectibleCycle(), subtype) then
        RegretPedestals.IsPedestalMorphing = false
        return
    end

    RegretPedestals.PedestalCycleTables[GetPtrHash(item)] = item:GetCollectibleCycle()
    RegretPedestals.IsPedestalMorphing = true
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, RegretPedestals.PrePedestalMorph)


---@param item EntityPickup
function RegretPedestals:PostPedestalMorph(item, previousType, previousVar, previousSubtype, keptPrice, keptSeed, ignoreModifiers)
    if item.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if item.SubType <= 0 then return end
    if usedSpindown then return end
    --if item.Touched then return end
    if not RegretPedestals:IsBlindPedestal(item) then return end
    if RegretPedestals.IsPedestalMorphing ~= true then return end
    RegretPedestals.IsPedestalMorphing = false

    local itemCycleArray = utility:DeepCopy(RegretPedestals.PedestalCycleTables[GetPtrHash(item)])

    Isaac.CreateTimer(function()
        if contains(item:GetCollectibleCycle(), previousSubtype) or item.Touched then 
            RegretPedestals.PedestalCycleTables = {}
            return
        end

        RegretPedestals:SpawnGhostItems(previousSubtype, item.Position, itemCycleArray)
        RegretPedestals.PedestalCycleTables = {}
    end, 1, 1, false)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_MORPH, RegretPedestals.PostPedestalMorph)


function RegretPedestals:PickupVoided(pickup)

    -- if item.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    -- if item.SubType <= 0 then return end
    -- if item.Touched then return end
    --if not RegretPedestals:IsBlindPedestal(pickup) then return end

    local items = Isaac.FindByType(5, 100)
    local disappearingItems = {}
    for _, itemEntity in pairs(items) do
        local item = itemEntity:ToPickup()
        local isInSameOptionsGroup = item.OptionsPickupIndex and (item.OptionsPickupIndex == pickup.OptionsPickupIndex) and (item.OptionsPickupIndex > 0)
        local isSamePedestal = (GetPtrHash(pickup) == GetPtrHash(item))

        if item and (item.SubType > 0) and (not item.Touched) and isInSameOptionsGroup and (not isSamePedestal) then
            if RegretPedestals:IsBlindPedestal(item) then
                table.insert(disappearingItems, item)
            end
        end
    end

    for _, poofedItem in pairs(disappearingItems) do
        RegretPedestals:SpawnGhostItems(poofedItem.SubType, poofedItem.Position, poofedItem:GetCollectibleCycle())
    end

    if RegretPedestals:IsBlindPedestal(pickup) then
        RegretPedestals:SpawnGhostItems(pickup.SubType, pickup.Position, pickup:GetCollectibleCycle())
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED, RegretPedestals.PickupVoided, PickupVariant.PICKUP_COLLECTIBLE)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED_ABYSS, RegretPedestals.PickupVoided, PickupVariant.PICKUP_COLLECTIBLE)


---@param effect EntityEffect
function RegretPedestals:GhostUpdate(effect)
    if not effect.SubType == enums.Effects.GHOST_ITEM.SubType then return end
    local sprite = effect:GetSprite()
    if sprite:IsFinished() then effect:Remove() end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, RegretPedestals.GhostUpdate, enums.Effects.GHOST_ITEM.Variant)


-- ---@param effect EntityEffect
-- function mod:RainInit(effect)
--     effect:Remove()
-- end
-- mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.RainInit, EffectVariant.RAIN_DROP)

end
return RegretPedestalsEnabler