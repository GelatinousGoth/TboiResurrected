local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("TR ModCompat: Retribution")

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    if CiiruleanItems then
        CiiruleanItems.CAPSULE_SPAWN_CHANCE = 0
    end
end)