local manager = require("resurrected_modpack.manager")
local mod = manager.ModRef
local PRIVATE_DATA = manager.PrivateData

---@class PickupData
---@field config PickupConfig

---@alias PickupConfig.Init fun(pickup: EntityPickup, data: table)
---@alias PickupConfig.Update fun(pickup: EntityPickup, data: table)
---@alias PickupConfig.ChestIsOpen fun(pickup: EntityPickup, data: table): boolean
---@alias PickupConfig.GetLootList fun(pickup: EntityPickup, data: table, shouldAdvance: boolean, rng: RNG): LootList
---@alias PickupConfig.ShowPickupGhosts fun(pickup: EntityPickup, data: table): boolean

---@class PickupConfig
---@field Name string
---@field Init? PickupConfig.Init
---@field Update? PickupConfig.Update
---@field IsChest? boolean
---@field Chest_IsOpen? PickupConfig.ChestIsOpen
---@field GetLootList? PickupConfig.GetLootList
---@field ShowPickupGhosts? PickupConfig.ShowPickupGhosts

local pickupConfigs = {}

---@param variant integer
---@param subtype integer
local function get_hash(variant, subtype)
    return string.format("%d.%d", variant, subtype)
end

---@param pickup EntityPickup
---@return PickupData?
local function get_data(pickup)
    return pickup:GetData()[PRIVATE_DATA]
end

---@param config EntityRegistry.Config
local function AddConfig(config)
    pickupConfigs[get_hash(config.variant, config.subType)] = config
end

---@param pickup EntityPickup
local function Pickup_Init(_, pickup)
    local config = pickupConfigs[get_hash(pickup.Variant, pickup.SubType)]
    if not config then
        return
    end

    local rawData = pickup:GetData()
    local data = rawData[PRIVATE_DATA]

    if not rawData[PRIVATE_DATA] then
        data = {}
        rawData[PRIVATE_DATA] = data
    end

    data.config = config
    if config.Init then
        config.Init(pickup, data)
    end
end

---@param pickup EntityPickup
local function Pickup_Update(_, pickup)
    local data = pickup:GetData()[PRIVATE_DATA]
    if not data then
        return
    end

    local config = data.config
    if config and config.Update then
        config.Update(pickup, data)
    end
end

---@param pickup EntityPickup
---@param shouldAdvance boolean
---@param rng RNG
---@return LootList?
local function Pickup_GetLootList(_, pickup, shouldAdvance, rng)
    local data = get_data(pickup)
    if not data then
        return
    end

    local config = data.config
    if config and config.GetLootList then
        return config.GetLootList(pickup, data, shouldAdvance, rng)
    end
end

---@param pickup EntityPickup
---@return boolean?
local function Pickup_UpdateGhostPickups(_, pickup)
    local data = get_data(pickup)
    if not data then
        return
    end

    local config = data.config
    if config and config.GetLootList and config.ShowPickupGhosts then
        return not config.ShowPickupGhosts(pickup, data)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, Pickup_Init)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, Pickup_Update)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, Pickup_GetLootList)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE_GHOST_PICKUPS, Pickup_UpdateGhostPickups)

---@class Main.Pickup
local Module = {}

--#region Module

Module.AddConfig = AddConfig

--#endregion

return Module