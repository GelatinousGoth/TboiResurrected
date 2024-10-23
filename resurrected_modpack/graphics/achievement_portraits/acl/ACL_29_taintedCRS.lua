local ACL_29_taintedCRS = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_29_taintedCRS.Pname = "THE TAINTED III"
ACL_29_taintedCRS.Description = "... The Benighted, The Harlot, The Deceiver..."
ACL_29_taintedCRS.Counter = 0
ACL_29_taintedCRS.dimX = 4
ACL_29_taintedCRS.dimY = 6
ACL_29_taintedCRS.size = 3

ACL_29_taintedCRS.isHidden = true

ACL_29_taintedCRS.portrait = "tainted3" -- call your image for the portrait this!!!!

ACL_29_taintedCRS.collection = false
ACL_29_taintedCRS.collectionPortrait = "taintedfull"

ACL_29_taintedCRS.grid = {}

ACL_29_taintedCRS.grid[1] = {
DisplayName = "The Benighted",
DisplayText = "Use the Red Key as Azazel",
TextName = [[You unlocked "Azazel"]],
gfx = "Achievement_AzazelB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[2] = {
DisplayName = "The Harlot",
DisplayText = "Use the Red Key as Lilith",
TextName = [[You unlocked "Lilith"]],
gfx = "Achievement_LilithB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[3] = {
DisplayName = "The Deceiver",
DisplayText = "Use the Red Key as Judas",
TextName = [[You unlocked "Judas"]],
gfx = "Achievement_JudasB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[4] = {
DisplayName = "Azazel's Rage",
DisplayText = "Defeat The Beast as Tainted Azazel",
TextName = [["Azazel's Rage" has appeared in the basement]],
gfx = "Achievement_AzazelsRage.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[5] = {
DisplayName = "Twisted Pair",
DisplayText = "Defeat The Beast as Tainted Lilith",
TextName = [["Twisted Pair" has appeared in the basement]],
gfx = "Achievement_TwistedPair.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[6] = {
DisplayName = "Sanguine Bond",
DisplayText = "Defeat The Beast as Tainted Judas",
TextName = [["Sanguine Bond" has appeared in the basement]],
gfx = "Achievement_SanguineBond.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[7] = {
DisplayName = "Reverse High Priestess",
DisplayText = "Defeat Ultra Greedier as Tainted Lilith",
TextName = [["The High Priestess" has appeared in the basement]],
gfx = "Achievement_ReverseHighPriestess.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_THE_HIGH_PRIESTESS,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[8] = {
DisplayName = "Reverse Devil",
DisplayText = "Defeat Ultra Greedier as Tainted Azazel",
TextName = [["The Devil" has appeared in the basement]],
gfx = "Achievement_ReverseDevil.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[9] = {
DisplayName = "Reverse Magician",
DisplayText = "Defeat Ultra Greedier as Tainted Judas",
TextName = [["The Magician" has appeared in the basement]],
gfx = "Achievement_ReverseMagician.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[10] = {
DisplayName = "Wicked Crown",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Azazel",
TextName = [["Wicked Crown" has appeared in the basement]],
gfx = "Achievement_WickedCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[11] = {
DisplayName = "The Twins",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Lilith",
TextName = [["The Twins" has appeared in the basement]],
gfx = "Achievement_TheTwins.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[12] = {
DisplayName = "Your Soul",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Judas",
TextName = [["Your Soul" has appeared in the basement]],
gfx = "Achievement_YourSoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[13] = {
DisplayName = "Azazel's Stump",
DisplayText = "Defeat Mother as Tainted Azazel",
TextName = [["Azazel's Stump" has appeared in the basement]],
gfx = "Achievement_AzazelsStump.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[14] = {
DisplayName = "Adoption Papers",
DisplayText = "Defeat Mother as Tainted Lilith",
TextName = [["Adoption Papers" has appeared in the basement]],
gfx = "Achievement_AdoptionPapers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[15] = {
DisplayName = "Number Magnet",
DisplayText = "Defeat Mother as Tainted Judas",
TextName = [["Number Magnet" has appeared in the basement]],
gfx = "Achievement_NumberMagnet.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[16] = {
DisplayName = "Hemoptysis",
DisplayText = "Defeat Delirium as Tainted Azazel",
TextName = [["Hemoptysis" has appeared in the basement]],
gfx = "Achievement_Hemoptysis.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[17] = {
DisplayName = "Gello",
DisplayText = "Defeat Delirium as Tainted Lilith",
TextName = [["Gello" has appeared in the basement]],
gfx = "Achievement_Gello.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[18] = {
DisplayName = "Dark Arts",
DisplayText = "Defeat Delirium as Tainted Judas",
TextName = [["Dark Arts" has appeared in the basement]],
gfx = "Achievement_DarkArts.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[19] = {
DisplayName = "Hell Game",
DisplayText = "Defeat Mega Satan as Tainted Azazel",
TextName = [["Hell Game" has appeared in the basement]],
gfx = "Achievement_HellGame.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[20] = {
DisplayName = "Fool's Gold",
DisplayText = "Defeat Mega Satan as Tainted Lilith",
TextName = [["Fool's Gold" has appeared in the basement]],
gfx = "Achievement_FoolsGold.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[21] = {
DisplayName = "Black Sack",
DisplayText = "Defeat Mega Satan as Tainted Judas",
TextName = [["Black Sack" has appeared in the basement]],
gfx = "Achievement_BlackSack.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[22] = {
DisplayName = "Soul of Azazel",
DisplayText = "Defeat Hush and Boss Rush as Tainted Azazel",
TextName = [["Soul of Azazel" has appeared in the basement]],
gfx = "Achievement_SoulOfAzazel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[23] = {
DisplayName = "Soul of Lilith",
DisplayText = "Defeat Hush and Boss Rush as Tainted Lilith",
TextName = [["Soul of Lilith" has appeared in the basement]],
gfx = "Achievement_SoulOfLilith.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_29_taintedCRS.grid[24] = {
DisplayName = "Soul of Judas",
DisplayText = "Defeat Hush and Boss Rush as Tainted Judas",
TextName = [["Soul of Judas" has appeared in the basement]],
gfx = "Achievement_SoulOfJudas.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

return ACL_29_taintedCRS