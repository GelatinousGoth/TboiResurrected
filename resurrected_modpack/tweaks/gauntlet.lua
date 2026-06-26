-- 90% of coders are assholes

local TR_Manager = require("resurrected_modpack.manager")

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

TheGauntlet.Items = {}
include("resurrected_modpack.tweaks.gauntlet.items.apollo")
include("resurrected_modpack.tweaks.gauntlet.items.aphrodite")
include("resurrected_modpack.tweaks.gauntlet.items.ares")
include("resurrected_modpack.tweaks.gauntlet.items.artemis")
include("resurrected_modpack.tweaks.gauntlet.items.athena")
TheGauntlet.Items.Ceres = {}
include("resurrected_modpack.tweaks.gauntlet.items.ceres.item")
include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.colorize_shader")
include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.heatwave_shader")
include("resurrected_modpack.tweaks.gauntlet.items.ceres.visuals.particle_engine")
TheGauntlet.Items.Dionysus = {}
include("resurrected_modpack.tweaks.gauntlet.items.dionysus.item")
include("resurrected_modpack.tweaks.gauntlet.items.dionysus.shader")
TheGauntlet.Items.Hades = {}
include("resurrected_modpack.tweaks.gauntlet.items.hades.item")
include("resurrected_modpack.tweaks.gauntlet.items.hades.status_effect")
include("resurrected_modpack.tweaks.gauntlet.items.vulcan")
include("resurrected_modpack.tweaks.gauntlet.items.juno")
include("resurrected_modpack.tweaks.gauntlet.items.poseidon")
TheGauntlet.Items.Zeus = {}
TheGauntlet.Items.Zeus.Constants = {}
include("resurrected_modpack.tweaks.gauntlet.items.zeus.item")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.lightning_bolt")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.berserk")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.breath_of_life")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.eraser")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.genesis")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.isaacs_tears")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.mama_mega")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.notched_axe")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.pandoras_box")
include("resurrected_modpack.tweaks.gauntlet.items.zeus.cases.spin_to_win")

include("resurrected_modpack.tweaks.gauntlet.items.locusts.ceres")
include("resurrected_modpack.tweaks.gauntlet.items.locusts.dionysus")
include("resurrected_modpack.tweaks.gauntlet.items.locusts.hades")
include("resurrected_modpack.tweaks.gauntlet.items.locusts.poseidon")
include("resurrected_modpack.tweaks.gauntlet.items.locusts.zeus")

TheGauntlet.Compat = {}
include("resurrected_modpack.tweaks.gauntlet.compat.accurate_blurbs")
TheGauntlet.Compat.EID = {}
include("resurrected_modpack.tweaks.gauntlet.compat.eid.main")
include("resurrected_modpack.tweaks.gauntlet.compat.eid.data")
include("resurrected_modpack.tweaks.gauntlet.compat.eid.descriptions")
include("resurrected_modpack.tweaks.gauntlet.compat.minimapi")
include("resurrected_modpack.tweaks.gauntlet.compat.stageapi")

TheGauntlet.SaveManager.Init(TheGauntlet)

