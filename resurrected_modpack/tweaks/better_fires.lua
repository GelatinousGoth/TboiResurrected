local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Better Fires"

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