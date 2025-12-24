--If someone seing this PLEASE NOTE that my code isn't ideal and probably is ABSOLUTE TRASH
--It's because I've learned Isaac modding through docs and actual in-game testing, not by guides or mods' code
--So If you want to tell me how to make my trash code better, feel free to write about it on github with enhancement tag

local TR_Manager = require("resurrected_modpack.manager")
CutBossesAttacks = TR_Manager:RegisterMod("Cut Boss Attacks", 1, true)

local cba = CutBossesAttacks

require("resurrected_modpack.tweaks.cut_boss_attacks.cfg")
require("resurrected_modpack.tweaks.cut_boss_attacks.utils")
require("resurrected_modpack.tweaks.cut_boss_attacks.compats")

require("resurrected_modpack.tweaks.cut_boss_attacks.bosses.siren")
require("resurrected_modpack.tweaks.cut_boss_attacks.bosses.mom")
require("resurrected_modpack.tweaks.cut_boss_attacks.bosses.mega_satan2")

if ModConfigMenu then
	require("resurrected_modpack.tweaks.cut_boss_attacks.mcm")
end
require("resurrected_modpack.tweaks.cut_boss_attacks.rgon_cfg")
