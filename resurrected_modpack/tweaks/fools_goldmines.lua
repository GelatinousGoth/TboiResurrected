local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Fool's Goldmines", 1)

function mod:SwapRocks(entitytype, variant, subtype, gridindex, seed)
    -- rock check
    if entitytype ~= 1000 then return end -- 1000 = normal rocks
    
    -- floor check
    if (Game():GetLevel():GetStage() == LevelStage.STAGE2_1 or Game():GetLevel():GetStage() == LevelStage.STAGE2_2) and (Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE or Game():GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B) then
        local roomrng = RNG()
        roomrng:SetSeed(Game():GetRoom():GetDecorationSeed(), 35)
		-- Chance of room with gold rocks: 33% default
        if roomrng:RandomFloat() < 0.33 then
            local rockrng = RNG()
            rockrng:SetSeed(seed, 35)
			-- Chance of gold rock within room: 12% default
            if rockrng:RandomFloat() < 0.12 then return {1011, variant, subtype} end -- 1011 = gold rocks
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.SwapRocks)