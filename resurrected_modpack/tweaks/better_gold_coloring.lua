local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Better Gold Coloring", 1)

local GOLDENCOLORS = {
    Normal = Color(1,1,1,1,0,0,0),
    Gilded = Color(2.0,1.14,0.3,1.0,0.11,0.11,0.11),
}

---@param entity EntityNPC
function mod:gildedShit(entity)
    if entity:GetEntityFlags() & EntityFlag.FLAG_MIDAS_FREEZE == EntityFlag.FLAG_MIDAS_FREEZE then
        entity.Color = GOLDENCOLORS.Gilded
    else
        entity.Color = GOLDENCOLORS.Normal
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.gildedShit)
