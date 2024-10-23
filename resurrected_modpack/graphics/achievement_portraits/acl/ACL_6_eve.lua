local ACL_6_eve = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_6_eve.Pname = "EVE"
ACL_6_eve.Description = "She who bit the apple will plant the apple's seeds."
ACL_6_eve.Counter = 0
ACL_6_eve.dimX = 3
ACL_6_eve.dimY = 5
ACL_6_eve.size = 4

ACL_6_eve.isHidden = false

ACL_6_eve.portrait = "eve" -- call your image for the portrait this!!!!


ACL_6_eve.grid = {}

ACL_6_eve.grid[1] = {
DisplayName = "Eve",
DisplayText = "Don't pick up any Hearts for 2 floors in a row",
TextName = [[You unlocked "Eve"]],
gfx = "Achievement_Eve.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVE,
Near = true,
Tile = Sprite()
}

ACL_6_eve.grid[2] = {
DisplayName = "The Razor",
DisplayText = "Defeat Satan as Eve",
TextName = [["The Razor" has appeared in the basement]],
gfx = "Achievement_TheRazor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_RAZOR,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[3] = {
DisplayName = "Eve's Bird Foot", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Eve', --Name displayed in secrets menu
TextName = [["Eve's Bird Foot" has appeared in the basement]],
gfx = "Achievement_EvesBirdFoot.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVES_BIRD_FOOT,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[4] = {
DisplayName = "Black Lipstick",
DisplayText = 'Defeat The Lamb as Eve',
TextName = [["Black Lipstick" has appeared in the basement]],
gfx = "Achievement_BlackLipstick.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLACK_LIPSTICK,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[5] = { 
DisplayName = "Sacrificial Dagger",
DisplayText = "Defeat ??? as Eve",
TextName = [["Sacrificial Dagger" has appeared in the basement]],
gfx = "Achievement_SacrificialKnife.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SACRIFICIAL_DAGGER,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[6] = {
DisplayName = "Lil' Baby",
DisplayText = "Defeat Mega Satan as Eve",
TextName = [["Lil' Baby" has appeared in the basement]],
gfx = "Achievement_210_LilBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LIL_BABY,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[7] = {
DisplayName = "Athame",
DisplayText = "Defeat Hush as Eve",
TextName = [["Athame" has appeared in the basement]],
gfx = "Achievement_184_Athame.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ATHAME,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[8] = {
DisplayName = "Dull Razor",
DisplayText = "Defeat Delirium as Eve",
TextName = [["Dull Razor" has appeared in the basement]],
gfx = "Achievement_DullRazor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DULL_RAZOR,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[9] = {
DisplayName = "Bird Cage",
DisplayText = "Defeat Mother as Eve",
TextName = [["Bird Cage" has appeared in the basement]],
gfx = "Achievement_BirdCage.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BIRD_CAGE,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[10] = {
DisplayName = "Cracked Orb",
DisplayText = "Defeat The Beast as Eve",
TextName = [["Cracked Orb" has appeared in the basement]],
gfx = "Achievement_CrackedOrb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CRACKED_ORB,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[11] = {
DisplayName = "Crow Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Eve (Hard Mode)",
TextName = [[You unlocked "Crow Baby"]],
gfx = "Achievement_CrowBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CROW_BABY,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[12] = {
DisplayName = "Whore Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Eve",
TextName = [["Whore Baby" has appeared in the basement]],
gfx = "Achievement_255_WhoreBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WHORE_BABY,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[13] = {
DisplayName = "Eve's Mascara",
DisplayText = 'Complete the Boss Rush as Eve', 
TextName = [["Eve's Mascara" has appeared in the basement]], 
gfx = "Achievement_EvesMascara.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVES_MASCARA,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[14] = {
DisplayName = "Black Feather",
DisplayText = "Complete Greed Mode as Eve",
TextName = [["Black Feather" has appeared in the basement]],
gfx = "Achievement_197_BlackFeather.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLACK_FEATHER,
Near = false,
Tile = Sprite()
}

ACL_6_eve.grid[15] = {
DisplayName = "Crow Heart",
DisplayText = "Complete Greedier Mode as Eve",
TextName = [["Crow Heart" has appeared in the basement]],
gfx = "Achievement_CrowHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CROW_HEART,
Near = false,
Tile = Sprite()
}

return ACL_6_eve



