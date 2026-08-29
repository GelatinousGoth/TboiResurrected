local Utils = require("resurrected_modpack.actor.utils")
local TYPE, VARIANT, SUBTYPE = Utils.GetIdentity("[TR] Chest Prop")

---@param npc EntityNPC
local function Update(npc)
    local isHeld = npc:GetEntityFlags() & EntityFlag.FLAG_HELD ~= 0
    if not isHeld then
        npc.Velocity = npc.Velocity * 0.8 -- chest physics
        npc.Friction = npc.Friction * 0.965 -- pickup physics
    end

    npc:SetDead(false)
    npc.HitPoints = npc.MaxHitPoints
end


---@type NpcConfig
local Config = {
    type = TYPE,
    variant = VARIANT,
    subType = SUBTYPE,
    Update = Update
}

return Config