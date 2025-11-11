local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Delirium Ending Chest", 1)

--big chest init function, runs when a big chest is spawned
function mod:POST_BIGCHEST_INIT(entity)

	--get some variables
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()

	if stage == LevelStage.STAGE7 then

		--replace the default gold spritesheet with the new one
		chestSprite = entity:GetSprite()
		
		--replacing sheet 0 and 2, but not 1 (1 is the shadow and doesn't need to be changed)
		chestSprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_delirium_chest.png")
		chestSprite:ReplaceSpritesheet(2, "gfx/items/pick ups/pickup_delirium_chest.png")
		chestSprite:LoadGraphics()

	end

end

--callback land

mod:AddCallback( ModCallbacks.MC_POST_PICKUP_INIT, mod.POST_BIGCHEST_INIT, PickupVariant.PICKUP_BIGCHEST )