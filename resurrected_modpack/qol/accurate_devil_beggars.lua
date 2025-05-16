local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Accurate Devil Beggars", 1)

--Returns true if we're in or beyond Womb, in the Ascent, or have the Full Heart Damage easter egg enabled
function mod:checkFullHeartDamage()
    return (Game():GetLevel():GetStage() >= LevelStage.STAGE4_1) or Game():GetLevel():IsAscent() or Game():GetSeeds():HasSeedEffect(SeedEffect.SEED_ISAAC_TAKES_HIGH_DAMAGE)
end

--Go through every object in the new room and, if full heart damage conditions are met, swap out sprite sheets for Devil Beggars
function mod:devilBeggarSpriteChange(entity)
    if mod:checkFullHeartDamage() then
        for i, entity in ipairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_SLOT and entity.Variant == 5 then
                local sprite = entity:GetSprite()
                sprite:ReplaceSpritesheet(0, "gfx/items/slots/full.png") --Replace sign
                sprite:ReplaceSpritesheet(2, "gfx/items/slots/full.png") --Replace heart from payment animation
                sprite:LoadGraphics()
            end
        end
    end
end

--Call devilBeggarSpriteChange() whenever we enter a new room or use a Judgement card
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.devilBeggarSpriteChange)
mod:AddCallback(ModCallbacks.MC_USE_CARD,      mod.devilBeggarSpriteChange, Card.CARD_JUDGEMENT)