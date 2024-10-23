local ACL_1_isaac = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_1_isaac.Pname = "ISAAC"
ACL_1_isaac.Description = "The boy that lived in a small house on a hill..."
ACL_1_isaac.Counter = 0
ACL_1_isaac.dimX = 3
ACL_1_isaac.dimY = 5
ACL_1_isaac.size = 4

ACL_1_isaac.isHidden = false

ACL_1_isaac.portrait = "isaac" --uses this to find image in ("resources/gfx/portrait/"..P.portrait..".png")


ACL_1_isaac.grid = {}

ACL_1_isaac.grid[1] = {
DisplayName = "Lil' Chest",
DisplayText = "Complete Greed Mode as lsaac",
TextName = [["Lil' Chest" has appeared in the basement]],
gfx = "Achievement_192_LilChest.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_1_isaac.grid[2] = {
DisplayName = "Mom's Knife",
DisplayText = "Defeat Satan as lsaac",
TextName = [["Mom's Knife" has appeared in the basement]],
gfx = "Achievement_MomsKnife.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MOMS_KNIFE,
Near = false,
Tile = Sprite()
}

ACL_1_isaac.grid[3] = {
DisplayName = "Isaac's Tears", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as lsaac', --Name displayed in secrets menu
TextName = [["Isaac's Tears" has appeared in the basement]],
gfx = "Achievement_IsaacsTears.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_1_isaac.grid[4] = {
DisplayName = "The Lost Poster",
DisplayText = 'Defeat The Lamb as lsaac',
TextName = [["The Lost Poster" has appeared in the basement]],
gfx = "Achievement_LostPoster.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[5] = { 
DisplayName = "The D20",
DisplayText = "Defeat ??? as lsaac",
TextName = [["The D20" has appeared in the basement]],
gfx = "Achievement_D20.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[6] = {
DisplayName = "Cry Baby",
DisplayText = "Defeat Mega Satan as lsaac",
TextName = [["Cry Baby" has appeared in the basement]],
gfx = "Achievement_205_CryBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[7] = {
DisplayName = "Fart Baby",
DisplayText = "Defeat Hush as lsaac",
TextName = [["Fart Baby" has appeared in the basement]],
gfx = "Achievement_179_FartBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[8] = {
DisplayName = "D Infinity",
DisplayText = "Defeat Delirium as lsaac",
TextName = [["D infinity" has appeared in the basement]],
gfx = "Achievement_DInf.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[9] = {
DisplayName = "Meat Cleaver",
DisplayText = "Defeat Mother as lsaac",
TextName = [["Meat Cleaver" has appeared in the basement]],
gfx = "Achievement_MeatCleaver.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[10] = {
DisplayName = "Options?",
DisplayText = "Defeat The Beast as lsaac",
TextName = [["Options?" has appeared in the basement]],
gfx = "Achievement_Options.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[11] = {
DisplayName = "Lost Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as lsaac (Hard Mode)",
TextName = [[You unlocked "Lost Baby"]],
gfx = "Achievement_LostBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[12] = {
DisplayName = "Buddy Baby",
DisplayText = "Get all Completion Marks in Hard Mode as lsaac",
TextName = [["Buddy Baby" has appeared in the basement]],
gfx = "Achievement_253_BuddyBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[13] = {
DisplayName = "Isaac's Head",
DisplayText = 'Complete the Boss Rush as lsaac', 
TextName = [["Isaac's Head" has appeared in the basement]], 
gfx = "Achievement_IsaacsHead.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[14] = {
DisplayName = "",
DisplayText = "",
TextName = [[]],
gfx = "",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = 0,
Near = false,
Tile = Sprite()
}
ACL_1_isaac.grid[15] = {
DisplayName = "The D1",
DisplayText = "Complete Greedier Mode as lsaac",
TextName = [["D1" has appeared in the basement]],
gfx = "Achievement_D1.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

return ACL_1_isaac
