local ACL_2_magdalene = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_2_magdalene.Pname = "MAGDALENE"
ACL_2_magdalene.Description = "She who witnessed death and resurrection."
ACL_2_magdalene.Counter = 0
ACL_2_magdalene.dimX = 3
ACL_2_magdalene.dimY = 5
ACL_2_magdalene.size = 4

ACL_2_magdalene.isHidden = false

ACL_2_magdalene.portrait = "magdalene"

ACL_2_magdalene.grid = {}

ACL_2_magdalene.grid[1] = {
DisplayName = "Magdalene",
DisplayText = "Have 7 or more red hearts",
TextName = [[You unlocked "Magdalene"]],
gfx = "Achievement_Magdalene.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MAGDALENE,
Near = false,
Tile = Sprite()
}

ACL_2_magdalene.grid[2] = {
DisplayName = "Guardian Angel",
DisplayText = "Defeat Satan as Magdalene",
TextName = [["Guardian Angel" has appeared in the basement]],
gfx = "Achievement_GuardianAngel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_2_magdalene.grid[3] = {
DisplayName = "A Cross", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Magdalene', --Name displayed in secrets menu
TextName = [["A Cross" has appeared in the basement]],
gfx = "Achievement_TheRelic.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_2_magdalene.grid[4] = {
DisplayName = "Maggy's Faith",
DisplayText = 'Defeat The Lamb as Magdalene',
TextName = [["Maggy's Faith" has appeared in the basement]],
gfx = "Achievement_MaggysFaith.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[5] = { 
DisplayName = "The Celtic Cross",
DisplayText = "Defeat ??? as Magdalene",
TextName = [["The Crucifix" has appeared in the basement]],
gfx = "Achievement_CelticCross.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[6] = {
DisplayName = "Red Baby",
DisplayText = "Defeat Mega Satan as Magdalene",
TextName = [["Red Baby" has appeared in the basement]],
gfx = "Achievement_206_RedBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[7] = {
DisplayName = "Purity",
DisplayText = "Defeat Hush as Magdalene",
TextName = [["Purity" has appeared in the basement]],
gfx = "Achievement_180_Purity.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[8] = {
DisplayName = "Eucharist",
DisplayText = "Defeat Delirium as Magdalene",
TextName = [["Eucharist" has appeared in the basement]],
gfx = "Achievement_Eucharist.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[9] = {
DisplayName = "Yuck Heart",
DisplayText = "Defeat Mother as Magdalene",
TextName = [["Yuck Heart" has appeared in the basement]],
gfx = "Achievement_YuckHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[10] = {
DisplayName = "Candy Heart",
DisplayText = "Defeat The Beast as Magdalene",
TextName = [["Candy Heart" has appeared in the basement]],
gfx = "Achievement_CandyHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[11] = {
DisplayName = "Cute Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Magdalene (Hard Mode)",
TextName = [[You unlocked "Cute Baby"]],
gfx = "Achievement_CuteBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[12] = {
DisplayName = "Colorful Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Magdalene",
TextName = [["Colorful Baby" has appeared in the basement]],
gfx = "Achievement_254_ColorfulBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[13] = {
DisplayName = "Maggy's Bow",
DisplayText = 'Complete the Boss Rush as Magdalene', 
TextName = [["Maggy's Bow" has appeared in the basement]], 
gfx = "Achievement_MaggysBow.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[14] = {
DisplayName = "Censer",
DisplayText = "Complete Greed Mode as Magdalene",
TextName = [["Censer" has appeared in the basement]],
gfx = "Achievement_193_Censer.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}
ACL_2_magdalene.grid[15] = {
DisplayName = "Glyph of Balance",
DisplayText = "Complete Greedier Mode as Magdalene",
TextName = [["Glyph of Balance" has appeared in the basement]],
gfx = "Achievement_GlyphOfBalance.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}


return ACL_2_magdalene


