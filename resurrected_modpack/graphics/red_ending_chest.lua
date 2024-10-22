local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Red Ending Chest", 1)

--big chest init function, runs when a big chest is spawned
function mod:POST_BIGCHEST_INIT(entity)

	--get some variables
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local altStage = level:IsAltStage()

	--if we're on stage 5 (sheol or cathedral). cathedral is the alt stage of sheol.
	--stage 6 is dark room or chest. chest is the alt stage of dark room.
	if stage == LevelStage.STAGE5 and altStage == false or stage == LevelStage.STAGE6 and altStage == false then

		--replace the default gold spritesheet with the new red one
		local chestSprite = entity:GetSprite()
		
		--replacing sheet 0 and 2, but not 1 (1 is the shadow and doesn't need to be changed)
		
		chestSprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_neo_big_chest_red.png")
		chestSprite:ReplaceSpritesheet(2, "gfx/items/pick ups/pickup_neo_big_chest_red.png")
		chestSprite:LoadGraphics()

	end

end

--callback land

mod:AddCallback( ModCallbacks.MC_POST_PICKUP_INIT, mod.POST_BIGCHEST_INIT, PickupVariant.PICKUP_BIGCHEST )