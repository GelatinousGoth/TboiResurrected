local ACL_17_jacob = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_17_jacob.Pname = "JACOB AND ESAU"
ACL_17_jacob.Description = "Brothers born in conflict and deceit."
ACL_17_jacob.Counter = 0
ACL_17_jacob.dimX = 3
ACL_17_jacob.dimY = 5
ACL_17_jacob.size = 4

ACL_17_jacob.isHidden = false

ACL_17_jacob.portrait = "jacobesau" -- call your image for the portrait this!!!!


ACL_17_jacob.grid = {}

ACL_17_jacob.grid[1] = {
DisplayName = "Jacob and Esau",
DisplayText = "Defeat Mother",
TextName = [[You unlocked "Jacob and Esau"]],
gfx = "Achievement_JacobEsau.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.JACOB_AND_ESAU,
Near = true,
Tile = Sprite()
}

ACL_17_jacob.grid[2] = {
DisplayName = "Red Stew",
DisplayText = "Defeat Satan as Jacob and Esau",
TextName = [["Red Stew" has appeared in the basement]],
gfx = "Achievement_RedStew.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RED_STEW,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[3] = {
DisplayName = "The Stairway", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Jacob and Esau', --Name displayed in secrets menu
TextName = [["The Stairway" has appeared in the basement]],
gfx = "Achievement_TheStairway.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STAIRWAY,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[4] = {
DisplayName = "Damocles",
DisplayText = 'Defeat The Lamb as Jacob and Esau',
TextName = [["Damocles" has appeared in the basement]],
gfx = "Achievement_Damocles.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DAMOCLES,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[5] = { 
DisplayName = "Birthright",
DisplayText = "Defeat ??? as Jacob and Esau",
TextName = [["Birthright" has appeared in the basement]],
gfx = "Achievement_Birthright.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BIRTHRIGHT,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[6] = {
DisplayName = "Illusion Baby",
DisplayText = "Defeat Mega Satan as Jacob and Esau",
TextName = [[You unlocked "Illusion Baby"]],
gfx = "Achievement_IllusionBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ILLUSION_BABY,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[7] = {
DisplayName = "Vanishing Twin",
DisplayText = "Defeat Hush as Jacob and Esau",
TextName = [["Vanishing Twin" has appeared in the basement]],
gfx = "Achievement_VanishingTwin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.VANISHING_TWIN,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[8] = {
DisplayName = "Suplex!",
DisplayText = "Defeat Delirium as Jacob and Esau",
TextName = [["Suplex!" has appeared in the basement]],
gfx = "Achievement_Suplex.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUPLEX,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[9] = {
DisplayName = "Friend Finder",
DisplayText = "Defeat The Beast as Jacob and Esau",
TextName = [["Friend Finder" has appeared in the basement]],
gfx = "Achievement_FriendFinder.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FRIEND_FINDER,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[10] = {
DisplayName = "Magic Skin",
DisplayText = "Defeat Mother as Jacob and Esau",
TextName = [["Magic Skin" has appeared in the basement]],
gfx = "Achievement_MagicSkin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MAGIC_SKIN,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[11] = {
DisplayName = "Double Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Jacob and Esau (Hard Mode)",
TextName = [[You unlocked "Double Baby"]],
gfx = "Achievement_DoubleBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DOUBLE_BABY,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[12] = {
DisplayName = "Solomon's Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Jacob and Esau",
TextName = [[You unlocked "Solomon's Baby"]],
gfx = "Achievement_SolomonsBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOLOMONS_BABY,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[13] = {
DisplayName = "Rock Bottom",
DisplayText = 'Complete the Boss Rush as Jacob and Esau', 
TextName = [["Rock Bottom" has appeared in the basement]], 
gfx = "Achievement_RockBottom.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ROCK_BOTTOM,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[14] = {
DisplayName = "Inner Child",
DisplayText = "Complete Greed Mode as Jacob and Esau",
TextName = [["Inner Child" has appeared in the basement]],
gfx = "Achievement_InnerChild.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.INNER_CHILD,
Near = false,
Tile = Sprite()
}

ACL_17_jacob.grid[15] = {
DisplayName = "Genesis",
DisplayText = "Complete Greedier Mode as Jacob and Esau",
TextName = [["Genesis" has appeared in the basementt]],
gfx = "Achievement_Genesis.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GENESIS,
Near = false,
Tile = Sprite()
}

return ACL_17_jacob



