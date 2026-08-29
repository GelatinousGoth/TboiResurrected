local manager = require("resurrected_modpack.manager")
local mod = manager.ModRef
local PRIVATE_DATA = manager.PrivateData

---@class NpcConfig : EntityRegistry.Config
---@field Init? fun(npc: EntityNPC, data: table)
---@field Update? fun(npc: EntityNPC, data: table)

local npcConfigs = {}

---@param type integer
---@param variant integer
---@param subtype integer
local function get_hash(type, variant, subtype)
    return string.format("%d.%d.%d", type, variant, subtype)
end

---@param config EntityRegistry.Config
local function AddConfig(config)
    npcConfigs[get_hash(config.type, config.variant, config.subType)] = config
end

---@param npc EntityNPC
local function Npc_Init(_, npc)
    local config = npcConfigs[get_hash(npc.Type, npc.Variant, npc.SubType)]
    if not config then
        return
    end

    local rawData = npc:GetData()
    local data = rawData[PRIVATE_DATA]

    if not rawData[PRIVATE_DATA] then
        data = {}
        rawData[PRIVATE_DATA] = data
    end

    data.config = config
    if config.Init then
        config.Init(npc, data)
    end
end

local function Npc_Update(_, npc)
    local data = npc:GetData()[PRIVATE_DATA]
    if not data then
        return
    end

    local config = data.config
    if config and config.Update then
        config.Update(npc, data)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Npc_Init)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Npc_Update)

---@class Main.Npc
local Module = {}

--#region Module

Module.AddConfig = AddConfig

--#endregion

return Module