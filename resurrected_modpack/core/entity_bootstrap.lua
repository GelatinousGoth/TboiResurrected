---@class EntityRegistry
local EntityRegistry = require("resurrected_modpack.core.entity_registry")
local NpcLogic = require("resurrected_modpack.core.npc")

---@class EntityRegistry.Config
---@field type EntityType | integer
---@field variant integer
---@field subType integer

local CLASS_PLAYER = 1
local CLASS_TEAR = 2
local CLASS_FAMILIAR = 3
local CLASS_BOMB = 4
local CLASS_PICKUP = 5
local CLASS_SLOT = 6
local CLASS_LASER = 7
local CLASS_KNIFE = 8
local CLASS_PROJECTILE = 9
local CLASS_NPC = 10
local CLASS_EFFECT = 11

local CLASS_TO_HANDLER = {
    [CLASS_NPC] = NpcLogic
}

---@param entityType EntityType
---@return integer
local function get_entity_class(entityType)
    if entityType == EntityType.ENTITY_EFFECT then
        return CLASS_EFFECT
    end

    return math.min(entityType, CLASS_NPC)
end

---@param config EntityRegistry.Config
---@return EntityRegistry.Config
local function RegisterEntity(config)
    local class = get_entity_class(config.type)
    local handler = CLASS_TO_HANDLER[class]
    if not handler then
        error(string.format("No handler for class %d", class), 2)
    end

    handler.AddConfig(config)
    return config
end

EntityRegistry.NPC_CHEST_PROP = RegisterEntity(require("resurrected_modpack.actor.npc.chest_prop"))