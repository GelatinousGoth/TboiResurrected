local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Unique Gurgling Sprite"

function mod:SpriteReplacer(Gurgling)
	if Gurgling.Variant == 0 then 
		if not Gurgling:IsChampion() then
			local sprite = Gurgling:GetSprite()
			sprite:ReplaceSpritesheet(1,"gfx/Gurgling.png")
			sprite:LoadGraphics()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.SpriteReplacer, 237)