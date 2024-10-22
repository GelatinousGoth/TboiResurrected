local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Custom Corpse Chest", 1)

function mod:POST_BIGCHEST_INIT(entity)
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local stageType = level:GetStageType()

	if (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2) and stageType == StageType.STAGETYPE_REPENTANCE then

		local chestSprite = entity:GetSprite()

		chestSprite:ReplaceSpritesheet(0, "gfx/items/pick ups/pickup_corpse_chest.png")
		chestSprite:ReplaceSpritesheet(2, "gfx/items/pick ups/pickup_corpse_chest.png")
		chestSprite:LoadGraphics()
	end

end

--callback land

mod:AddCallback( ModCallbacks.MC_POST_PICKUP_INIT, mod.POST_BIGCHEST_INIT, PickupVariant.PICKUP_BIGCHEST )