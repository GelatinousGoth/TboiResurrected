local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Wooden Earthquakes")

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function (_, effect)
    local stage = Game():GetLevel():GetStage()
    local stageType = Game():GetLevel():GetStageType()
    local roomType = Game():GetRoom():GetType()

    local spr = effect:GetSprite()
    local path = "gfx/effects/groundbreaks/effect_062_groundbreak_"

    --i dont feel like making this a table or smth sorry its too few cases

    if roomType == RoomType.ROOM_SHOP then
        spr:ReplaceSpritesheet(0, path .. "cellar.png", true)

    elseif roomType == RoomType.ROOM_ARCADE then
        spr:ReplaceSpritesheet(0, path .. "arcade.png", true)

    elseif stage == (LevelStage.STAGE1_1 or LevelStage.STAGE1_2) then
        if stageType == StageType.STAGETYPE_ORIGINAL then
            spr:ReplaceSpritesheet(0,path .. "basement.png", true)
        elseif stageType == StageType.STAGETYPE_WOTL then
            spr:ReplaceSpritesheet(0,path .. "cellar.png", true)
        elseif stageType == StageType.STAGETYPE_AFTERBIRTH then
            spr:ReplaceSpritesheet(0,path .. "ardent.png", true)
        end

    end
end, EffectVariant.ROCK_EXPLOSION)