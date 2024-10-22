local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Red Portal effects for Gehenna", 1)

local game = Game()
local rng = RNG()

--Initialize resprited Lil' Portal
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc) 
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Variant == 1 and data.Gehenna == nil then
        --Check for Gehenna backdrop
        if game:GetRoom():GetBackdropType() == 47 then
            sprite:Load("gfx/monsters/repentance/lil_portal_red.anm2", true)
            data.Gehenna = true
        --Check if current stage is Gehenna
        elseif game:GetLevel():GetStage() == 5 or game:GetLevel():GetStage() == 6 then
            if game:GetLevel():GetStageType() == 5 then
                sprite:Load("gfx/monsters/repentance/lil_portal_red.anm2", true)
                data.Gehenna = true
            end     
        else
            data.Gehenna = false
        end
    end
end, 306)

--Update SplatColor every frame because I have to :(
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc) 
    if npc:GetData()["Gehenna"] then
        npc.SplatColor = Color(1, 0.95, 0.95, 0.5, 0.5, 0.2, 0.2)
    end
end, 306)

--Detect enemies spawned by resprited Lil' Portal
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc) 
    if npc.SpawnerEntity then
        if npc.SpawnerEntity.Type == 306 and npc.SpawnerEntity:GetData()["Gehenna"] then
            npc:SetColor(Color(1, 1, 1, 1, ((0.7 / 35) * (35 - npc.FrameCount)), 0, 0), 2, 1, true, false)
            npc:GetData()["RedFade"] = true
        end
    end 
end)

--Add red-colored fade out effect to the spawned enemies
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc) 
    if npc:GetData()["RedFade"] and npc.FrameCount < 35 then
        npc:SetColor(Color(1, 1, 1, 1, ((0.7 / 35) * (35 - npc.FrameCount)), 0, 0), 2, 1, true, false)
    end
end)