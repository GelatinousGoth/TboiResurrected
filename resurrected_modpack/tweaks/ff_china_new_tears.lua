local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("FF China's New Tears", 1)

function mod:changeChinaTears()
if not FiendFolio then return end
    FiendFolio.ColorChinaYellow = Color(0.93,0.87,1.0,1.0,0.0,0.0,0.0)
	FiendFolio.ColorChinaYellow:SetColorize(0.55,0.18,0.77,0.22)
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.changeChinaTears)
