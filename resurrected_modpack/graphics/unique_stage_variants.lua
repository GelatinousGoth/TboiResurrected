local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Unique Stage Variants"

function mod:StageVariants()
    RoomConfig.GetStage(StbType.BURNING_BASEMENT):SetDisplayName("Ardent Attic")
	RoomConfig.GetStage(StbType.FLOODED_CAVES):SetDisplayName("Flooded Aquifer")
	RoomConfig.GetStage(StbType.DANK_DEPTHS):SetDisplayName("Dank Tunnels")
	RoomConfig.GetStage(StbType.SCARRED_WOMB):SetDisplayName("Scarred Viscera")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.StageVariants)