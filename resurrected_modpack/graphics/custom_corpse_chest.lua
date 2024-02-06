local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Custom Corpse Chest"

function mod:POST_UPDATE()		
	local level = Game():GetLevel()
	local stage = level:GetAbsoluteStage()
	local name = level:GetName()

	if ((stage == LevelStage.STAGE4_2) and (name == "Corpse II")) then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i].Type == EntityType.ENTITY_PICKUP and entities[i].Variant == PickupVariant.PICKUP_BIGCHEST and entities[i].SubType ~= 666 then
				local pos = entities[i].Position
				entities[i]:Remove()
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BIGCHEST, 666, pos, Vector(0,0), null)
			end		
		end
	end
end

mod:AddCallback( ModCallbacks.MC_POST_UPDATE, mod.POST_UPDATE )