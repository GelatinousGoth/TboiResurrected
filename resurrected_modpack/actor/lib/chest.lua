--#region Dependencies

local Registry = require("resurrected_modpack.core.entity_registry")
local SpriteUtils = require("resurrected_modpack.core.utils.sprite")

--#endregion

local g_Game = Game()

---@class Actor.Lib.Chest
local Module = {}

---@param chest Entity
---@return Entity
local function SwitchToProp(chest)
    local CHEST_PROP = Registry.NPC_CHEST_PROP

    local prop = g_Game:Spawn(
        CHEST_PROP.type, CHEST_PROP.variant,
        chest.Position, chest.Velocity, nil,
        CHEST_PROP.subType, chest.InitSeed
    )

    prop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    prop:Update()
    local sprite = prop:GetSprite()
    local sourceSprite = chest:GetSprite()
    SpriteUtils.CopySprite(sourceSprite, sprite)

    chest:Remove()
    return prop
end

--#region Module

Module.SwitchToProp = SwitchToProp

--#endregion

return Module