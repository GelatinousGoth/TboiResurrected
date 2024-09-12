local ACL_3_cain = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_3_cain.Pname = "CAIN"
ACL_3_cain.Description = "For jealousy and spite, our first life was taken."
ACL_3_cain.Counter = 0
ACL_3_cain.dimX = 3
ACL_3_cain.dimY = 5
ACL_3_cain.size = 4

ACL_3_cain.isHidden = false

ACL_3_cain.portrait = "cain" --uses this to find image in ("resources/gfx/portrait/"..P.portrait..".png")


ACL_3_cain.grid = {}

ACL_3_cain.grid[1] = {
DisplayName = "Cain",
DisplayText = "Hold 55 Coins at one time",
TextName = [[You unlocked "Cain"]],
gfx = "Achievement_Cain.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CAIN,
Near = true,
Tile = Sprite()
}

ACL_3_cain.grid[2] = {
DisplayName = "A Bag of Bombs",
DisplayText = "Defeat Satan as Cain",
TextName = [["A Bag of Bombs" has appeared in the basement]],
gfx = "Achievement_BombBag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_3_cain.grid[3] = {
DisplayName = "A Bag of Pennies", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Cain', --Name displayed in secrets menu
TextName = [["A Bag of Pennies" has appeared in the basement]],
gfx = "Achievement_CoinBag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_3_cain.grid[4] = {
DisplayName = "Abel",
DisplayText = 'Defeat The Lamb as Cain',
TextName = [["Abel" has appeared in the basement]],
gfx = "Achievement_Abel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[5] = { 
DisplayName = "Cain's Eye",
DisplayText = "Defeat ??? as Cain",
TextName = [["Cain's Eye" has appeared in the basement]],
gfx = "Achievement_CainsEye.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[6] = {
DisplayName = "Green Baby",
DisplayText = "Defeat Mega Satan as Cain",
TextName = [["Green Baby" has appeared in the basement]],
gfx = "Achievement_207_GreenBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[7] = {
DisplayName = "D12",
DisplayText = "Defeat Hush as Cain",
TextName = [["D12" has appeared in the basement]],
gfx = "Achievement_181_D12.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[8] = {
DisplayName = "Silver Dollar",
DisplayText = "Defeat Delirium as Cain",
TextName = [["Silver Dollar" has appeared in the basement]],
gfx = "Achievement_SilverDollar.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[9] = {
DisplayName = "Guppy's Eye",
DisplayText = "Defeat Mother as Cain",
TextName = [["Guppy's Eye" has appeared in the basement]],
gfx = "Achievement_GuppysEye.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[10] = {
DisplayName = "A Pound of Flesh",
DisplayText = "Defeat The Beast as Cain",
TextName = [["A Pound of Flesh" has appeared in the basement]],
gfx = "Achievement_PoundOfFlesh.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[11] = {
DisplayName = "Glass Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Cain (Hard Mode)",
TextName = [[You unlocked "Glass Baby"]],
gfx = "Achievement_GlassBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[12] = {
DisplayName = "Picky Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Cain",
TextName = [["Picky Baby" has appeared in the basement]],
gfx = "Achievement_261_PickyBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[13] = {
DisplayName = "Cain's Other Eye",
DisplayText = 'Complete the Boss Rush as Cain', 
TextName = [["Cain's Other Eye" has appeared in the basement]], 
gfx = "Achievement_CainsOtherEye.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[14] = {
DisplayName = "Evil Eye",
DisplayText = "Complete Greed Mode as Cain",
TextName = [["Evil Eye" has appeared in the basement]],
gfx = "Achievement_194_EvilEye.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_3_cain.grid[15] = {
DisplayName = "Sack of Sacks",
DisplayText = "Complete Greedier Mode as Cain",
TextName = [["Sack of Sacks" has appeared in the basement]],
gfx = "Achievement_SackOfSacks.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

return ACL_3_cain



