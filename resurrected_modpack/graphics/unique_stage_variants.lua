local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Unique Stage Variants", 1)

function mod:StageVariants()
    RoomConfig.GetStage(StbType.BURNING_BASEMENT):SetDisplayName("Ardent Attic")
	RoomConfig.GetStage(StbType.FLOODED_CAVES):SetDisplayName("Flooded Aquifer")
	RoomConfig.GetStage(StbType.DEPTHS):SetDisplayName("Tunnels")
	RoomConfig.GetStage(StbType.SCARRED_WOMB):SetDisplayName("Scarred Viscera")
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.StageVariants)