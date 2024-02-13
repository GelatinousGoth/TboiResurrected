local mod = require("resurrected_modpack.mod_reference")
mod.json = require("json")

Isaac.DebugString("[Tboi Resurrected] \"Tboi Resurrected\" initialized.")

mod.Mods = {}
mod.RemovedCallbacks = {}

mod.CurrentModName = "Tboi Resurrected"
mod.LockCallbackRecord = false

require("resurrected_modpack.api_overwrite.callback")
require("resurrected_modpack.tools.custom_callbacks")
require("resurrected_modpack.tools.console_commands")
require("resurrected_modpack.tools.reworked_foes_compatibility")

require("resurrected_modpack.tweaks.lamb_intro_invincibility")
require("resurrected_modpack.tweaks.chests_before_mother")
require("resurrected_modpack.tweaks.rare_chests")

require("resurrected_modpack.sounds.shepard_tone")

require("resurrected_modpack.graphics.swaggy_mushrooms")

require("resurrected_modpack.tweaks.unique_delirium_door")

require("resurrected_modpack.graphics.unique_gurgling_sprite")
require("resurrected_modpack.graphics.red_ending_chest")
require("resurrected_modpack.graphics.custom_corpse_chest")

require("resurrected_modpack.qol.hanging_dream_catcher")

require("resurrected_modpack.tweaks.fallen_gabriel_spawns_imps")
require("resurrected_modpack.tweaks.bombable_devil_statue")

require("resurrected_modpack.graphics.improved_backdrops_unique_rooms")
require("resurrected_modpack.graphics.improved_backdrops_void_overlay")
require("resurrected_modpack.graphics.improved_backdrops")
require("resurrected_modpack.graphics.beast_laugh_on_damage")
require("resurrected_modpack.graphics.gehenna_visual_tweaks")

require("resurrected_modpack.graphics.crawlspaces_rebuilt")
require("resurrected_modpack.graphics.antibirth_hornfel_trail")
require("resurrected_modpack.graphics.forgotten_got_real_chain")
require("resurrected_modpack.graphics.bygone_over_bb")

require("resurrected_modpack.tweaks.amazing_chest_ahead")

require("resurrected_modpack.qol.hud_toggle")

require("resurrected_modpack.graphics.keeper_coin_tears")

require("resurrected_modpack.tweaks.fools_goldmines")

require("resurrected_modpack.graphics.better_lasers_for_fallen_angels")
require("resurrected_modpack.graphics.missing_costumes")
require("resurrected_modpack.graphics.item_pedestal_overhaul")
require("resurrected_modpack.graphics.missing_tears_gfx")

require("resurrected_modpack.music.unique_mega_satan_music")

require("resurrected_modpack.shaders.hotter_mines")

require("resurrected_modpack.graphics.better_donation_machines")

require("resurrected_modpack.qol.items_renamed")

require("resurrected_modpack.sounds.bell_chime_for_good_items")

mod.CurrentModName = "Post Init"