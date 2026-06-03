local function CenteredAngelsEnabler()

local CenteredAngels = {}
local mod = IsaacReflourished



function CenteredAngels:CenterFallenAngel(entity)
    if (entity.Type == EntityType.ENTITY_URIEL or entity.Type == EntityType.ENTITY_GABRIEL) and (entity.SpawnerType == EntityType.ENTITY_MEGA_SATAN) then
        local spawnPosSetting = IsaacReflourished:GetSettingsValue("CenteredAngelsSpawnPos")
        if spawnPosSetting == 1 then
            entity.Position = Vector(320, 640)
        elseif spawnPosSetting == 2 then
            entity.Position = Vector(320, 515)
        else
            if entity.Type == EntityType.ENTITY_URIEL then
                entity.Position = Vector(120, 640)
            else
                entity.Position = Vector(520, 640)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, CenteredAngels.CenterFallenAngel)

end
return CenteredAngelsEnabler