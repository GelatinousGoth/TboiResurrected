local ACL_5_bluebaby = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_5_bluebaby.Pname = "???"
ACL_5_bluebaby.Description = "What's in the chest?"
ACL_5_bluebaby.Counter = 0
ACL_5_bluebaby.dimX = 3
ACL_5_bluebaby.dimY = 5
ACL_5_bluebaby.size = 4

ACL_5_bluebaby.isHidden = false

ACL_5_bluebaby.portrait = "bluebaby" --uses this to find image in ("resources/gfx/portrait/"..P.portrait..".png")


ACL_5_bluebaby.grid = {}

ACL_5_bluebaby.grid[1] = {
DisplayName = "???",
DisplayText = "Defeat Mom's Heart 10 times",
TextName = [[You unlocked "???"]],
gfx = "Achievement_Bluebaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_BABY,
Near = true,
Tile = Sprite()
}

ACL_5_bluebaby.grid[2] = {
DisplayName = "A Forget Me Now",
DisplayText = "Defeat Satan as ???",
TextName = [["A Forget Me Now" has appeared in the basement]],
gfx = "Achievement_ForgetMeNow.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_FORGET_ME_NOW,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[3] = {
DisplayName = "The D6", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as ???', --Name displayed in secrets menu
TextName = [[Isaac now holds... "The D6"]],
gfx = "Achievement_D6.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ISAAC_HOLDS_THE_D6,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[4] = {
DisplayName = "???'s Soul",
DisplayText = 'Defeat The Lamb as ???',
TextName = [["???'s Soul" has appeared in the basement]],
gfx = "Achievement_BlueBabysSoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_BABYS_SOUL,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[5] = { 
DisplayName = "Fate",
DisplayText = "Defeat ??? as ???",
TextName = [["Fate" has appeared in the basement]],
gfx = "Achievement_Fate.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FATE,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[6] = {
DisplayName = "Blue Baby",
DisplayText = "Defeat Mega Satan as ???",
TextName = [["Blue Baby" has appeared in the basement]],
gfx = "Achievement_209_BlueBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_COOP_BABY,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[7] = {
DisplayName = "Fate's Reward",
DisplayText = "Defeat Hush as ???",
TextName = [["Fate's Reward" has appeared in the basement]],
gfx = "Achievement_183_FatesReward.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FATES_REWARD,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[8] = {
DisplayName = "King Baby",
DisplayText = "Defeat Delirium as ???",
TextName = [["King Baby" has appeared in the basement]],
gfx = "Achievement_KingBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KING_BABY,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[9] = {
DisplayName = "Eternal D6",
DisplayText = "Defeat Mother as ???",
TextName = [["Eternal D6" has appeared in the basement]],
gfx = "Achievement_EternalD6.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ETERNAL_D6,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[10] = {
DisplayName = "Montezuma's Revenge",
DisplayText = "Defeat The Beast as ???",
TextName = [["Montezuma's Revenge" has appeared in the basement]],
gfx = "Achievement_MontezumasRevenge.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MONTEZUMAS_REVENGE,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[11] = {
DisplayName = "Dead Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as ??? (Hard Mode)",
TextName = [[You unlocked "Dead Baby"]],
gfx = "Achievement_DeadBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEAD_BABY,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[12] = {
DisplayName = "Hive Baby",
DisplayText = "Get all Completion Marks in Hard Mode as ???",
TextName = [["Hive Baby" has appeared in the basement]],
gfx = "Achievement_252_HiveBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HIVE_BABY,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[13] = {
DisplayName = "???'s Only Friend",
DisplayText = 'Complete the Boss Rush as ???', 
TextName = [["???'s Only Friend" has appeared in the basement]], 
gfx = "Achievement_BlueBabysOnlyFriend.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_BABYS_ONLY_FRIEND,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[14] = {
DisplayName = "Cracked Dice",
DisplayText = "Complete Greed Mode as ???",
TextName = [["Cracked Dice" has appeared in the basement]],
gfx = "Achievement_196_CrackedDice.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CRACKED_DICE,
Near = false,
Tile = Sprite()
}

ACL_5_bluebaby.grid[15] = {
DisplayName = "Meconium",
DisplayText = "Complete Greedier Mode as ???",
TextName = [["Meconium" has appeared in the basement]],
gfx = "Achievement_Meconium.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MECONIUM,
Near = false,
Tile = Sprite()
}

return ACL_5_bluebaby



