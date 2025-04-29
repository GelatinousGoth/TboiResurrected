local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Item Spawn Animation", 1, true)

local game = Game()
local itempool = game:GetItemPool()
local itemConfig = Isaac.GetItemConfig()
local MOD_PREFIX = "_IGTRA"

local modStorage = require("resurrected_modpack.graphics.item_spawn_animation.modStorage")
modStorage.setMod(mod)
require("resurrected_modpack.graphics.item_spawn_animation.dssmenu")

local TMTRAINER_START_ID = 4000000000
local cycle = true

local function getTotalCollectibleList()
    local list = {}
    local id = 1

    while id < CollectibleType.NUM_COLLECTIBLES do
        if itemConfig:GetCollectible(id) then
            list[#list + 1] = {itemID = id}
        end
        id = id + 1
    end

    id = id + 1
    
    while itemConfig:GetCollectible(id) do
        list[#list + 1] = {itemID = id}
        id = id + 1
    end

    return list
end

---@param entity Entity
local function getData(entity)
    if not entity then
        return {}
    end

    local data = entity:GetData()
    data[MOD_PREFIX] = data[MOD_PREFIX] or {}

    return data[MOD_PREFIX]
end

---@return EntityPlayer[]
local function getPlayers()
    local players = {}

    for p = 0, game:GetNumPlayers() - 1 do
        players[#players+1] = Isaac.GetPlayer(p)
    end

    return players
end

---@param pickup EntityPickup
local function isBannedItem(pickup)
    local item = itemConfig:GetCollectible(pickup.SubType)

    if item.ID < CollectibleType.COLLECTIBLE_NULL then
        return true
    elseif item.Tags & ItemConfig.TAG_QUEST ~= 0 then
        return true
    elseif item.Tags & ItemConfig.TAG_FOOD ~= 0 then
        for _, player in ipairs(getPlayers()) do
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) then
                return true
            end
        end
    end
    
    return false
end

---@param pickup EntityPickup
local function isBlindPickup(pickup)
    local level = game:GetLevel()
    local curses = level:GetCurses()
    local hasBlindCurse = curses & LevelCurse.CURSE_OF_BLIND ~= 0

    return hasBlindCurse or pickup:IsBlind()
end

local function playerHasChaos()
    for _, player in ipairs(getPlayers()) do
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
            return true
        end
    end

    return false
end

local function isRoomSafe()
    if game:GetRoom():GetType() == RoomType.ROOM_DEFAULT then
        return false
    end

    for _, player in ipairs(getPlayers()) do
        if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B
        or player:HasCollectible(CollectibleType.COLLECTIBLE_GLITCHED_CROWN)
        then
            return false
        end
    end

    return true
end

function mod:canCycle()
    local totalItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1)
    local room = game:GetRoom()
    cycle = #totalItems < mod.GetSaveData().ITEM_LIMIT and isRoomSafe()

    if not cycle
    or not room:IsFirstVisit()
    then
        return
    end

    local pool = itempool:GetPoolForRoom(room:GetType(), room:GetSpawnSeed())
    local hasChaos = playerHasChaos()

    for _, entity in ipairs(totalItems) do
        local pickup = entity:ToPickup()

        if pickup
        and (not pickup:IsShopItem()
            and not isBannedItem(pickup)
            and not isBlindPickup(pickup))
        then
            local data = getData(pickup); data.itemSprites = {}
            local rng = RNG(); rng:SetSeed(pickup.InitSeed, 35)
            local collGfx = itemConfig:GetCollectible(pickup.SubType).GfxFileName
            local poolItems = hasChaos and getTotalCollectibleList() or itempool:GetCollectiblesFromPool(pool)
            local failsafeCount = 1

            for i = 1, mod.GetSaveData().CYCLES do
                local index = rng:RandomInt(#poolItems) + 1
                local item = #poolItems > 0 and poolItems[index].itemID or CollectibleType.COLLECTIBLE_BREAKFAST
                
                while #poolItems > 0
                and (not itemConfig:GetCollectible(item):IsAvailable()
                    or item == pickup.SubType)
                do
                    table.remove(poolItems, index)

                    index = rng:RandomInt(#poolItems) + 1
                    item = #poolItems > 0 and poolItems[index].itemID or CollectibleType.COLLECTIBLE_BREAKFAST
                end

                if #poolItems > 0 then
                    local itemGfx = itemConfig:GetCollectible(item).GfxFileName
                    data.itemSprites[i] = itemGfx
                    table.remove(poolItems, index)

                    rng:Next()
                elseif #data.itemSprites > 2 then
                    data.itemSprites[i] = data.itemSprites[failsafeCount]
                    failsafeCount = failsafeCount + 1
                else
                    data.itemSprites[i] = "gfx/items/collectibles/questionmark.png"
                end
            end

            data.itemSprites[mod.GetSaveData().CYCLES + 1] = collGfx
            data.currentSprite = 1

            local sprite = pickup:GetSprite()
            sprite:ReplaceSpritesheet(1, data.itemSprites[1])
            sprite:LoadGraphics()

            data.currentSprite = data.currentSprite + 1
            data.delay = mod.GetSaveData().START_DELAY
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.canCycle)

function mod:preCollectibleCollision(pickup, collider)
    if not getData(pickup).itemSprites
    or collider.Type ~= EntityType.ENTITY_PLAYER
    then
        return
    end
    
    if mod.GetSaveData().CAN_PICK_UP == 2 then
        local data = getData(pickup)
        local sprite = pickup:GetSprite()

        sprite:ReplaceSpritesheet(1, data.itemSprites[#data.itemSprites])
        sprite:LoadGraphics()

        return
    end

    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.preCollectibleCollision, PickupVariant.PICKUP_COLLECTIBLE)

---@param pickup EntityPickup
function mod:onPedestalCycle(pickup)
    local data = getData(pickup)

    if not data.itemSprites then
        return
    end

    if data.delay > 0 then
        data.delay = data.delay - 1
        return
    end

    local sprite = pickup:GetSprite()

    sprite:ReplaceSpritesheet(1, data.itemSprites[data.currentSprite])
    sprite:LoadGraphics()

    data.currentSprite = data.currentSprite + 1

    if data.currentSprite > #data.itemSprites then
        data.itemSprites = nil
        
        return
    end

    data.delay = mod.GetSaveData().START_DELAY + mod.GetSaveData().DELAY_MOD * (data.currentSprite - 1)

    if data.currentSprite == #data.itemSprites then
        data.delay = data.delay + mod.GetSaveData().FINAL_DELAY
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.onPedestalCycle, PickupVariant.PICKUP_COLLECTIBLE)

if EID then

local function isCyclingCollectible(descObj)
	if descObj.ObjType == EntityType.ENTITY_PICKUP
    and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE
    and getData(descObj.Entity).itemSprites
    and mod.GetSaveData().DISPLAY_EID == 1
    then
        return true
    end
end

local function questionMarkCallback(descObj)
    descObj.Transformation = nil
    descObj.Icon = nil
    descObj.Quality = nil
    descObj.ModName = nil
    descObj.Name = "{{QuestionMark}}"
    descObj.Description = "{{QuestionMark}}"

	return descObj
end

EID:addDescriptionModifier(MOD_PREFIX .. "_QuestionMark", isCyclingCollectible, questionMarkCallback)

end
