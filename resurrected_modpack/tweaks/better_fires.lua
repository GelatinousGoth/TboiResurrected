local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Better Fires", 1)

local sfx = SFXManager()

function mod:FireUpdate(entity)
    local sprite = entity:GetSprite()

    if entity.Variant == 1 or 3 then
	    if sprite:IsOverlayPlaying("Shoot") then
            if sprite:GetOverlayFrame() == 3 then
                sfx:Play(471)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FireUpdate, EntityType.ENTITY_FIREPLACE)