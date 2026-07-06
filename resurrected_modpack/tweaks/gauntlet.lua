-- 90% of coders are assholes

local TR_Manager = require("resurrected_modpack.manager")

if TheGauntlet then return end
TheGauntlet = TR_Manager:RegisterMod("The Gauntlet", 1)

local backupDataHolder = nil
if TheGauntlet ~= nil then
    backupDataHolder = TheGauntlet.DataHolder
end


TheGauntlet.SaveManager = include("resurrected_modpack.tweaks.gauntlet.library.save_manager")
include("resurrected_modpack.tweaks.gauntlet.library.status_effect_library")

---@type DataHolder
TheGauntlet.DataHolder = include("resurrected_modpack.tweaks.gauntlet.library.data_holder")(TheGauntlet)
if backupDataHolder ~= nil then
    TheGauntlet.DataHolder.Update(TheGauntlet.DataHolder, backupDataHolder)
end

include("resurrected_modpack.tweaks.gauntlet.library.dead_sea_scrolls_integration")
include("resurrected_modpack.tweaks.gauntlet.library.dead_sea_scrolls_changelogs")

TheGauntlet.Utility = {}
include("resurrected_modpack.tweaks.gauntlet.utility.callbacks")
include("resurrected_modpack.tweaks.gauntlet.utility.challenge_rooms")
include("resurrected_modpack.tweaks.gauntlet.utility.entity_spawn")
include("resurrected_modpack.tweaks.gauntlet.utility.entity")
include("resurrected_modpack.tweaks.gauntlet.utility.logging")
include("resurrected_modpack.tweaks.gauntlet.utility.math")
include("resurrected_modpack.tweaks.gauntlet.utility.misc")
include("resurrected_modpack.tweaks.gauntlet.utility.random")

TheGauntlet.GauntletRoom = {}
TheGauntlet.GauntletRoom.Constants = {}
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.common")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.backdrop")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.chance")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.doors")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.generation")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.render_chance")
include("resurrected_modpack.tweaks.gauntlet.gauntlet_room.waves")

TheGauntlet.Compat = {}
TheGauntlet.Compat.EID = {}
include("resurrected_modpack.tweaks.gauntlet.compat.minimapi")
include("resurrected_modpack.tweaks.gauntlet.compat.stageapi")

TheGauntlet.SaveManager.Init(TheGauntlet)

print("gauntlet init")