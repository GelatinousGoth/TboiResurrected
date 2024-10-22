local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Downpour Mushrooms", 1)

function mod:OnMushroomInit(npc)
    local level = Game():GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if ((
        stage == LevelStage.STAGE2_1 or
        stage == LevelStage.STAGE2_2
    ) and stageType == StageType.STAGETYPE_AFTERBIRTH) or
    ((
        stage == LevelStage.STAGE1_1 or
        stage == LevelStage.STAGE1_2
    ) and stageType == StageType.STAGETYPE_REPENTANCE) then
        local sprite = npc:GetSprite()
		if npc:IsChampion() then
            sprite:ReplaceSpritesheet(0, "gfx/monsters/afterbirthplus/monster_300_mushroomman_flooded_caves_champion.png")
        else		
            sprite:ReplaceSpritesheet(0, "gfx/monsters/afterbirthplus/monster_300_mushroomman_flooded_caves.png")
        end
        sprite:LoadGraphics()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnMushroomInit, EntityType.ENTITY_MUSHROOM)