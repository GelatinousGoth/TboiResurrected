local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Unique Gurgling Sprite", 1)

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