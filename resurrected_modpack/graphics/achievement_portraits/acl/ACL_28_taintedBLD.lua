local ACL_28_taintedBLD = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_28_taintedBLD.Pname = "THE TAINTED II"
ACL_28_taintedBLD.Description = "... The Curdled, The Dauntless..."
ACL_28_taintedBLD.Counter = 0
ACL_28_taintedBLD.dimX = 4
ACL_28_taintedBLD.dimY = 4
ACL_28_taintedBLD.size = 4

ACL_28_taintedBLD.isHidden = true

ACL_28_taintedBLD.portrait = "tainted2" -- call your image for the portrait this!!!!

ACL_28_taintedBLD.collection = false
ACL_28_taintedBLD.collectionPortrait = "taintedfull"

ACL_28_taintedBLD.grid = {}

ACL_28_taintedBLD.grid[1] = {
DisplayName = "The Curdled",
DisplayText = "Use the Red Key as Eve",
TextName = [[You unlocked "Eve"]],
gfx = "Achievement_EveB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[2] = {
DisplayName = "The Dauntless",
DisplayText = "Use the Red Key as Magdalene",
TextName = [[You unlocked "Magdalene"]],
gfx = "Achievement_MagdaleneB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TAINTED_MAGGY,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[3] = {
DisplayName = "Heartbreak",
DisplayText = "Defeat The Beast as Tainted Eve",
TextName = [["Heartbreak" has appeared in the basement]],
gfx = "Achievement_Heartbreak.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[4] = {
DisplayName = "Belly Jelly",
DisplayText = "Defeat The Beast as Tainted Magdalene",
TextName = [["Belly Jelly" has appeared in the basement]],
gfx = "Achievement_BellyJelly.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BELLY_JELLY,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[5] = {
DisplayName = "Reverse Empress",
DisplayText = "Defeat Ultra Greedier as Tainted Eve",
TextName = [["The Empress" has appeared in the basement]],
gfx = "Achievement_ReverseEmpress.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[6] = {
DisplayName = "Reversed Lovers",
DisplayText = "Defeat Ultra Greedier as Tainted Magdalene",
TextName = [["The Lovers" has appeared in the basement]],
gfx = "Achievement_ReverseLovers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_THE_LOVERS,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[7] = {
DisplayName = "Strange Key",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Eve",
TextName = [["Strange Key" has appeared in the basement]],
gfx = "Achievement_StrangeKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[8] = {
DisplayName = "Lil Clot",
DisplayText = "Defeat Mother as Tainted Eve",
TextName = [["Lil Clot" has appeared in the basement]],
gfx = "Achievement_LilClot.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[9] = {
DisplayName = "Holy Crown",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Magdalene",
TextName = [["Holy Crown" has appeared in the basement]],
gfx = "Achievement_HolyCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HOLY_CROWN,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[10] = {
DisplayName = "Mother's Kiss",
DisplayText = "Defeat Mother as Tainted Magdalene",
TextName = [["Mother's Kiss" has appeared in the basement]],
gfx = "Achievement_MothersKiss.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MOTHERS_KISS,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[11] = {
DisplayName = "Sumptorium",
DisplayText = "Defeat Delirium as Tainted Eve",
TextName = [["Sumptorium" has appeared in the basement]],
gfx = "Achievement_Sumptorium.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[12] = {
DisplayName = "Hypercoagulation",
DisplayText = "Defeat Delirium as Tainted Magdalene",
TextName = [["Hypercoagulation" has appeared in the basement]],
gfx = "Achievement_Hypercoagulation.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HYPERCOAGULATION,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[13] = {
DisplayName = "Horse Pill",
DisplayText = "Defeat Mega Satan as Tainted Eve",
TextName = [["Horse Pill" has appeared in the basement]],
gfx = "Achievement_HorsePill.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[14] = {
DisplayName = "Queen of Hearts",
DisplayText = "Defeat Mega Satan as Tainted Magdalene",
TextName = [["Queen of Hearts" has appeared in the basement]],
gfx = "Achievement_QueenOfHearts.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.QUEEN_OF_HEARTS,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[15] = {
DisplayName = "Soul of Eve",
DisplayText = "Defeat Hush and Boss Rush as Tainted Eve",
TextName = [["Soul of Eve" has appeared in the basement]],
gfx = "Achievement_SoulOfEve.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_28_taintedBLD.grid[16] = {
DisplayName = "Soul of Magdalene",
DisplayText = "Defeat Hush and Boss Rush as Tainted Magdalene",
TextName = [["Soul of Magdalene" has appeared in the basement]],
gfx = "Achievement_SoulOfMagdalene.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOUL_OF_MAGGY,
Near = false,
Tile = Sprite()
}

return ACL_28_taintedBLD