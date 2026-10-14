local TR_Manager = require("resurrected_modpack.manager")

local TheFutureCombatLayer = TR_Manager:RegisterMod("Combat Layer for The Future", 1)

TheFutureCombatLayer:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    if StageAPI and TheFuture and not Excelsior then
        TheFuture.Stage:SetStageMusic(Isaac.GetMusicIdByName("Anguish Alt"))
    end
end)