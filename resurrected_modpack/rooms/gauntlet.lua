-- 90% of coders are assholes

local TR_Manager = require("resurrected_modpack.manager")

TheGauntlet = TR_Manager:RegisterMod("The Gauntlet", 1)

local backupDataHolder = nil
if TheGauntlet ~= nil then
    backupDataHolder = TheGauntlet.DataHolder
end


TheGauntlet.SaveManager = include("resurrected_modpack.rooms.gauntlet.library.save_manager")
include("resurrected_modpack.rooms.gauntlet.library.status_effect_library")

---@type DataHolder
TheGauntlet.DataHolder = include("resurrected_modpack.rooms.gauntlet.library.data_holder")(TheGauntlet)
if backupDataHolder ~= nil then
    TheGauntlet.DataHolder.Update(TheGauntlet.DataHolder, backupDataHolder)
end

include("resurrected_modpack.rooms.gauntlet.library.dead_sea_scrolls_integration")
include("resurrected_modpack.rooms.gauntlet.library.dead_sea_scrolls_changelogs")

TheGauntlet.Utility = {}
include("resurrected_modpack.rooms.gauntlet.utility.callbacks")
include("resurrected_modpack.rooms.gauntlet.utility.challenge_rooms")
include("resurrected_modpack.rooms.gauntlet.utility.entity_spawn")
include("resurrected_modpack.rooms.gauntlet.utility.entity")
include("resurrected_modpack.rooms.gauntlet.utility.logging")
include("resurrected_modpack.rooms.gauntlet.utility.math")
include("resurrected_modpack.rooms.gauntlet.utility.misc")
include("resurrected_modpack.rooms.gauntlet.utility.random")

TheGauntlet.GauntletRoom = {}
TheGauntlet.GauntletRoom.Constants = {}
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.common")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.backdrop")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.chance")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.doors")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.generation")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.render_chance")
include("resurrected_modpack.rooms.gauntlet.gauntlet_room.waves")

TheGauntlet.Items = {}
include("resurrected_modpack.rooms.gauntlet.items.apollo")
include("resurrected_modpack.rooms.gauntlet.items.aphrodite")
include("resurrected_modpack.rooms.gauntlet.items.ares")
include("resurrected_modpack.rooms.gauntlet.items.artemis")
include("resurrected_modpack.rooms.gauntlet.items.athena")
TheGauntlet.Items.Demeter = {}
include("resurrected_modpack.rooms.gauntlet.items.demeter.item")
include("resurrected_modpack.rooms.gauntlet.items.demeter.visuals.colorize_shader")
include("resurrected_modpack.rooms.gauntlet.items.demeter.visuals.heatwave_shader")
include("resurrected_modpack.rooms.gauntlet.items.demeter.visuals.particle_engine")
TheGauntlet.Items.Dionysus = {}
include("resurrected_modpack.rooms.gauntlet.items.dionysus.item")
include("resurrected_modpack.rooms.gauntlet.items.dionysus.shader")
TheGauntlet.Items.Hades = {}
include("resurrected_modpack.rooms.gauntlet.items.hades.item")
include("resurrected_modpack.rooms.gauntlet.items.hades.status_effect")
include("resurrected_modpack.rooms.gauntlet.items.hephaestus")
include("resurrected_modpack.rooms.gauntlet.items.hera")
include("resurrected_modpack.rooms.gauntlet.items.poseidon")
TheGauntlet.Items.Zeus = {}
TheGauntlet.Items.Zeus.Constants = {}
include("resurrected_modpack.rooms.gauntlet.items.zeus.item")
include("resurrected_modpack.rooms.gauntlet.items.zeus.lightning_bolt")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.berserk")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.breath_of_life")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.eraser")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.genesis")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.isaacs_tears")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.mama_mega")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.notched_axe")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.pandoras_box")
include("resurrected_modpack.rooms.gauntlet.items.zeus.cases.spin_to_win")

include("resurrected_modpack.rooms.gauntlet.items.locusts.demeter")
include("resurrected_modpack.rooms.gauntlet.items.locusts.dionysus")
include("resurrected_modpack.rooms.gauntlet.items.locusts.hades")
include("resurrected_modpack.rooms.gauntlet.items.locusts.poseidon")
include("resurrected_modpack.rooms.gauntlet.items.locusts.zeus")

TheGauntlet.Compat = {}
include("resurrected_modpack.rooms.gauntlet.compat.accurate_blurbs")
TheGauntlet.Compat.EID = {}
include("resurrected_modpack.rooms.gauntlet.compat.eid.main")
include("resurrected_modpack.rooms.gauntlet.compat.eid.data")
include("resurrected_modpack.rooms.gauntlet.compat.eid.descriptions")
include("resurrected_modpack.rooms.gauntlet.compat.minimapi")
include("resurrected_modpack.rooms.gauntlet.compat.stageapi")

TheGauntlet.SaveManager.Init(TheGauntlet)

TheGauntlet:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function ()
    TheGauntlet.Utility.Print("Not affiliated with Team Rapture")
end)