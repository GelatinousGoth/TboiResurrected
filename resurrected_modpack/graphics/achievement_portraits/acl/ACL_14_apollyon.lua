local ACL_14_apollyon = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_14_apollyon.Pname = "APOLLYON"
ACL_14_apollyon.Description = "The king of the abyss, destroyer of all things"
ACL_14_apollyon.Counter = 0
ACL_14_apollyon.dimX = 3
ACL_14_apollyon.dimY = 5
ACL_14_apollyon.size = 4

ACL_14_apollyon.isHidden = false

ACL_14_apollyon.portrait = "apollyon" -- call your image for the portrait this!!!!


ACL_14_apollyon.grid = {}

ACL_14_apollyon.grid[1] = {
DisplayName = "Apollyon",
DisplayText = "Defeat Mega Satan for the first time",
TextName = [[You unlocked "Apollyon"]],
gfx = "Achievement_Apollyon.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_DESTROYER,
Near = true,
Tile = Sprite()
}

ACL_14_apollyon.grid[2] = {
DisplayName = "Locust of Pestilence",
DisplayText = "Defeat Satan as Apollyon",
TextName = [["Locust of Pestilence" has appeared in the basement]],
gfx = "Achievement_LocustOfPestilence.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOCUST_OF_PESTILENCE,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[3] = {
DisplayName = "Locust of Wrath", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Apollyon', --Name displayed in secrets menu
TextName = [["Locust of Wrath" has appeared in the basement]],
gfx = "Achievement_LocustOfWrath.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOCUST_OF_WRATH,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[4] = {
DisplayName = "Locust of Death",
DisplayText = 'Defeat The Lamb as Apollyon',
TextName = [["Locust of Death" has appeared in the basement]],
gfx = "Achievement_LocustOfDeath.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOCUST_OF_DEATH,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[5] = { 
DisplayName = "Locust of Famine",
DisplayText = "Defeat ??? as Apollyon",
TextName = [["Locust of Famine" has appeared in the basement]],
gfx = "Achievement_LocustOfFamine.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOCUST_OF_FAMINE,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[6] = {
DisplayName = "Mort Baby",
DisplayText = "Defeat Mega Satan as Apollyon",
TextName = [["Mort Baby" has appeared in the basement]],
gfx = "Achievement_MortBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MORT_BABY,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[7] = {
DisplayName = "Hushy",
DisplayText = "Defeat Hush as Apollyon",
TextName = [["Hushy" has appeared in the basement]],
gfx = "Achievement_Hushy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HUSHY,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[8] = {
DisplayName = "Void",
DisplayText = "Defeat Delirium as Apollyon",
TextName = [["Void" has appeared in the basement]],
gfx = "Achievement_Void.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.VOID,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[9] = {
DisplayName = "Lil Portal",
DisplayText = "Defeat Mother as Apollyon",
TextName = [["Lil Portal" has appeared in the basement]],
gfx = "Achievement_LilPortal.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LIL_PORTAL,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[10] = {
DisplayName = "Worm Friend",
DisplayText = "Defeat The Beast as Apollyon",
TextName = [["Worm Friend" has appeared in the basement]],
gfx = "Achievement_WormFriend.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WORM_FRIEND,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[11] = {
DisplayName = "Smelter",
DisplayText = "Defeat Mom's Heart or It Lives! as Apollyon (Hard Mode)",
TextName = [["Smelter" has appeared in the basement]],
gfx = "Achievement_Smelter.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SMELTER,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[12] = {
DisplayName = "Apollyon Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Apollyon",
TextName = [["Apollyon Baby" has appeared in the basement]],
gfx = "Achievement_ApollyonBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.APOLLYON_BABY,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[13] = {
DisplayName = "Locust of Conquest",
DisplayText = 'Complete the Boss Rush as Apollyon', 
TextName = [["Locust of Conquest" has appeared in the basement]], 
gfx = "Achievement_LocustOfConquest.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOCUST_OF_CONQUEST,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[14] = {
DisplayName = "Brown Nugget",
DisplayText = "Complete Greed Mode as Apollyon",
TextName = [["Brown Nugget" has appeared in the basement]],
gfx = "Achievement_BrownNugget.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BROWN_NUGGET,
Near = false,
Tile = Sprite()
}

ACL_14_apollyon.grid[15] = {
DisplayName = "Black Rune",
DisplayText = "Complete Greedier Mode as Apollyon",
TextName = [["Black Rune" has appeared in the basementt]],
gfx = "Achievement_BlackRune.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLACK_RUNE,
Near = false,
Tile = Sprite()
}

return ACL_14_apollyon



