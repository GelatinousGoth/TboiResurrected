local ACL_26_play = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_26_play.Pname = "STUFF I DID"
ACL_26_play.Description = "A playground underground."
ACL_26_play.Counter = 0
ACL_26_play.dimX = 5
ACL_26_play.dimY = 5
ACL_26_play.size = 4

ACL_26_play.isHidden = false

ACL_26_play.portrait = "play" -- call your image for the portrait this!!!!


ACL_26_play.grid = {}

ACL_26_play.grid[1] = {
DisplayName = "A Small Rock",
DisplayText = "Destroy 100 Tinted Rocks",
TextName = [["A Small Rock" has appeared in the basement]],
gfx = "Achievement_ASmallRock.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[2] = {
DisplayName = "Mr. Mega!",
DisplayText = "Destroy 10 Tinted Rocks",
TextName = [["Mr. Mega!" has appeared in the basement]],
gfx = "Achievement_MrMega.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[3] = {
DisplayName = "A Forgotten Horsemen",
DisplayText = "Take 10 Angel Room items",
TextName = [[You unlocked "A Forgotten Horsemen" in the basement]],
gfx = "Achievement_Conquest.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[4] = {
DisplayName = "Lucky Rock",
DisplayText = "Destroy 100 rocks",
TextName = [["Lucky Rock" has appeared in the basement]],
gfx = "Achievement_LuckyRock.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[5] = {
DisplayName = "Butter Bean",
DisplayText = "Destroy 100 Poops",
TextName = [["Butter Bean" has appeared in the basement]],
gfx = "Achievement_ButterBean.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[6] = {
DisplayName = "Ace of Clubs",
DisplayText = "Get a 3-win streak",
TextName = [[Hat trick!]],
gfx = "Achievement_AceOfClubs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[7] = {
DisplayName = "Super Special Rocks",
DisplayText = "Get a 5-win streak, using a different character each time",
TextName = [[5 nights at moms]],
gfx = "Achievement_SuperSpecialRocks.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[8] = {
DisplayName = "Scared Heart",
DisplayText = "Reset 7 times in a row",
TextName = [[Mr. Resetter!]],
gfx = "Achievement_ScaredHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[9] = {
DisplayName = "Cracked Crown",
DisplayText = "Get a 5-win streak in the Daily Challenges",
TextName = [["Cracked Crown" has appeared in the basement]],
gfx = "Achievement_CrackedCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[10] = {
DisplayName = "RERUN!",
DisplayText = "Complete 3 Victory Laps and start a 4th",
TextName = [[You unlocked RERUN!]],
gfx = "Achievement_Rerun.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[11] = {
DisplayName = "Black Hole",
DisplayText = "Defeat 20 Portals",
TextName = [["Black Hole" has appeared in the basement]],
gfx = "Achievement_BlackHole.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[12] = {
DisplayName = "Mystery Gift",
DisplayText = "Destroy 500 rocks",
TextName = [["Mystery Gift" has appeared in the basement]],
gfx = "Achievement_MysteryGift.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[13] = {
DisplayName = "Bozo",
DisplayText = "Destroy 5 rainbow poops",
TextName = [["Bozo" has appeared in the basement]],
gfx = "Achievement_Bozo.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[14] = {
DisplayName = "Wooden Cross",
DisplayText = "Sleep in a bed",
TextName = [["Wooden Cross" has appeared in the basement]],
gfx = "Achievement_WoodenCross.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[15] = {
DisplayName = "Butter",
DisplayText = "Complete 2 Victory Laps and start a 3rd",
TextName = [["Butter" has appeared in the basement]],
gfx = "Achievement_Butter.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[16] = {
DisplayName = "Moving Box",
DisplayText = "Use Pandora's Box in Dark Room",
TextName = [["Moving Box" has appeared in the basement]],
gfx = "Achievement_MovingBox.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[17] = {
DisplayName = "Mr. Me",
DisplayText = "Open 20 Locked Chests",
TextName = [["Mr. Me" has appeared in the basement]],
gfx = "Achievement_MrMe.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[18] = {
DisplayName = "Death's List",
DisplayText = "Take 25 Deals with the Devil",
TextName = [["Death's List" has appeared in the basement]],
gfx = "Achievement_DeathsList.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[19] = {
DisplayName = "Trisagion",
DisplayText = "Take 25 Angel Rooms items",
TextName = [["Trisagion" has appeared in the basement]],
gfx = "Achievement_Trisagion.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[20] = {
DisplayName = "Sacrificial Altar",
DisplayText = "Take 50 Deals with the Devil",
TextName = [["Sacrificial Altar" has appeared in the basement]],
gfx = "Achievement_SacrificialAltar.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[21] = {
DisplayName = "Lil Spewer",
DisplayText = "Have Isaac die to his own explosion (without bombs)",
TextName = [["Lil Spewer" has appeared in the basement]],
gfx = "Achievement_LilSpewer.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[22] = {
DisplayName = "Blanket",
DisplayText = "Sleep in 10 beds",
TextName = [["Blanket" has appeared in the basement]],
gfx = "Achievement_Blanket.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[23] = {
DisplayName = "Mystery Egg",
DisplayText = "Spawn three charmed enemies in one room ",
TextName = [["Mystery Egg" has appeared in the basement]],
gfx = "Achievement_MysteryEgg.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[24] = {
DisplayName = "Rotten Penny",
DisplayText = "Have 20 Blue Flies at the same time",
TextName = [["Rotten Penny" has appeared in the basement]],
gfx = "Achievement_RottenPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_26_play.grid[25] = {
DisplayName = "The Scissors",
DisplayText = "Die a 100 times",
TextName = [["The Scissors" has appeared in the basement]],
gfx = "Achievement_Scissors.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}



return ACL_26_play