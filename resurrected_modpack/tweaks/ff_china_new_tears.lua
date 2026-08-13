local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("FF China's New Tears", 1)
if not FiendFolio then return end
function mod:changeChinaTears()
    FiendFolio.ColorChinaYellow = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorChinaYellow:SetColorize(0,0,0,0)
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.changeChinaTears)
