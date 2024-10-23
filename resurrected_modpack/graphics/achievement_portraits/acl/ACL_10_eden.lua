local ACL_10_eden = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_10_eden.Pname = "EDEN"
ACL_10_eden.Description = "A mystery everchanging, reborn and anew."
ACL_10_eden.Counter = 0
ACL_10_eden.dimX = 3
ACL_10_eden.dimY = 5
ACL_10_eden.size = 4

ACL_10_eden.isHidden = false

ACL_10_eden.portrait = "eden" -- call your image for the portrait this!!!!


ACL_10_eden.grid = {}

ACL_10_eden.grid[1] = {
DisplayName = "Eden",
DisplayText = "Complete Chapter 4",
TextName = [[You unlocked "Eden"]],
gfx = "Achievement_Eden.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EDEN,
Near = true,
Tile = Sprite()
}

ACL_10_eden.grid[2] = {
DisplayName = "Book of Secrets",
DisplayText = "Defeat Satan as Eden",
TextName = [["Book of Secrets" has appeared in the basement]],
gfx = "Achievement_BookOfSecrets.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOOK_OF_SECRETS,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[3] = {
DisplayName = "Blank Card", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Eden', --Name displayed in secrets menu
TextName = [["Blank Card" has appeared in the basement]],
gfx = "Achievement_BlankCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLANK_CARD,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[4] = {
DisplayName = "Mystery Sack",
DisplayText = 'Defeat The Lamb as Eden',
TextName = [["Mystery Sack" has appeared in the basement]],
gfx = "Achievement_MysterySack.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MYSTERY_SACK,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[5] = { 
DisplayName = "Mysterious Paper",
DisplayText = "Defeat ??? as Eden",
TextName = [["Mysterious Paper" has appeared in the basement]],
gfx = "Achievement_MysteriousPaper.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MYSTERIOUS_PAPER,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[6] = {
DisplayName = "Yellow Baby",
DisplayText = "Defeat Mega Satan as Eden",
TextName = [["Yellow Baby" has appeared in the basement]],
gfx = "Achievement_214_YellowBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.YELLOW_BABY,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[7] = {
DisplayName = "Eden's Blessing",
DisplayText = "Defeat Hush as Eden",
TextName = [["Eden's Blessing" has appeared in the basement]],
gfx = "Achievement_188_EdensBlessing.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EDENS_BLESSING,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[8] = {
DisplayName = "Eden's Soul",
DisplayText = "Defeat Delirium as Eden",
TextName = [["Eden's Soul" has appeared in the basement]],
gfx = "Achievement_EdensSoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EDENS_SOUL,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[9] = {
DisplayName = "'M",
DisplayText = "Defeat Mother as Eden",
TextName = [["'M" has appeared in the basement]],
gfx = "Achievement_M.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.M,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[10] = {
DisplayName = "Everything Jar",
DisplayText = "Defeat The Beast as Eden",
TextName = [["Everything Jar" has appeared in the basement]],
gfx = "Achievement_EverythingJar.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVERYTHING_JAR,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[11] = {
DisplayName = "Glitch Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Eden (Hard Mode)",
TextName = [[You unlocked "Glitch Baby"]],
gfx = "Achievement_GlitchBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GLITCH_BABY,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[12] = {
DisplayName = "Cracked Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Eden",
TextName = [["Cracked Baby" has appeared in the basement]],
gfx = "Achievement_256_CrackedBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CRACKED_BABY,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[13] = {
DisplayName = "Undefined",
DisplayText = 'Complete the Boss Rush as Eden', 
TextName = [["Undefined" has appeared in the basement]], 
gfx = "Achievement_Undefined.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.UNDEFINED,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[14] = {
DisplayName = "GB Bug",
DisplayText = "Complete Greed Mode as Eden",
TextName = [["GB Bug" has appeared in the basement]],
gfx = "Achievement_201_GBBug.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GB_BUG,
Near = false,
Tile = Sprite()
}

ACL_10_eden.grid[15] = {
DisplayName = "Metronome",
DisplayText = "Complete Greedier Mode as Eden",
TextName = [["Metronome" has appeared in the basement]],
gfx = "Achievement_Metronome.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.METRONOME,
Near = false,
Tile = Sprite()
}

return ACL_10_eden



