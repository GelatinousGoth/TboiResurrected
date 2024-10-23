local ACL_12_lilith = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_12_lilith.Pname = "LILITH"
ACL_12_lilith.Description = "The demon who first cohabited with man."
ACL_12_lilith.Counter = 0
ACL_12_lilith.dimX = 3
ACL_12_lilith.dimY = 5
ACL_12_lilith.size = 4

ACL_12_lilith.isHidden = false

ACL_12_lilith.portrait = "lilith" -- call your image for the portrait this!!!!


ACL_12_lilith.grid = {}

ACL_12_lilith.grid[1] = {
DisplayName = "Lilith",
DisplayText = "Complete Greed Mode with Azazel",
TextName = [[You unlocked "Lilith"]],
gfx = "Achievement_199_Lilith.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LILITH,
Near = true,
Tile = Sprite()
}

ACL_12_lilith.grid[2] = {
DisplayName = "Serpent's Kiss",
DisplayText = "Defeat Satan as Lilith",
TextName = [["Serpent's Kiss" has appeared in the basement]],
gfx = "Achievement_220_SerpentsKiss.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SERPENTS_KISS,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[3] = {
DisplayName = "Rune Bag", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Lilith', --Name displayed in secrets menu
TextName = [["Rune Bag" has appeared in the basement]],
gfx = "Achievement_218_RuneBag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_BAG,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[4] = {
DisplayName = "Succubus",
DisplayText = 'Defeat The Lamb as Lilith',
TextName = [["Succubus" has appeared in the basement]],
gfx = "Achievement_221_Succubus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUCCUBUS,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[5] = { 
DisplayName = "Cambion Conception",
DisplayText = "Defeat ??? as Lilith",
TextName = [["Cambion Conception" has appeared in the basement]],
gfx = "Achievement_219_CambionConception.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CAMBION_CONCEPTION,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[6] = {
DisplayName = "Big Baby",
DisplayText = "Defeat Mega Satan as Lilith",
TextName = [["Big Baby" has appeared in the basement]],
gfx = "Achievement_216_BigBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BIG_BABY,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[7] = {
DisplayName = "Incubus",
DisplayText = "Defeat Hush as Lilith",
TextName = [["Incubus" has appeared in the basement]],
gfx = "Achievement_190_Incubus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.INCUBUS,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[8] = {
DisplayName = "Euthanasia",
DisplayText = "Defeat Delirium as Lilith",
TextName = [["Euthanasia" has appeared in the basement]],
gfx = "Achievement_Euthanasia.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EUTHANASIA,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[9] = {
DisplayName = "Blood Puppy",
DisplayText = "Defeat Mother as Lilith",
TextName = [["Blood Puppy" has appeared in the basement]],
gfx = "Achievement_BloodPuppy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOOD_PUPPY,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[10] = {
DisplayName = "C Section",
DisplayText = "Defeat The Beast as Lilith",
TextName = [["C Section" has appeared in the basement]],
gfx = "Achievement_CSection.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.C_SECTION,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[11] = {
DisplayName = "Goat Head Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Lilith (Hard Mode)",
TextName = [["Goat Head Baby" has appeared in the basement]],
gfx = "Achievement_223_GoatHeadBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GOAT_HEAD_BABY,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[12] = {
DisplayName = "Dark Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Lilith",
TextName = [["Dark Baby" has appeared in the basement]],
gfx = "Achievement_260_DarkBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DARK_BABY,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[13] = {
DisplayName = "Immaculate Conception",
DisplayText = 'Complete the Boss Rush as Lilith', 
TextName = [["Immaculate Conception" has appeared in the basement]], 
gfx = "Achievement_222_ImmaculateConception.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.IMMACULATE_CONCEPTION,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[14] = {
DisplayName = "Box of Friends",
DisplayText = "Complete Greed Mode as Lilith",
TextName = [["Box of Friends" has appeared in the basement]],
gfx = "Achievement_203_BoxOfFriends.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOX_OF_FRIENDS,
Near = false,
Tile = Sprite()
}

ACL_12_lilith.grid[15] = {
DisplayName = "Duality",
DisplayText = "Complete Greedier Mode as Lilith",
TextName = [["Duality" has appeared in the basement]],
gfx = "Achievement_Duality.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DUALITY,
Near = false,
Tile = Sprite()
}

return ACL_12_lilith



