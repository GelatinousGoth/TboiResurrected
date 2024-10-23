local ACL_33_taintedHID = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_33_taintedHID.Pname = "THE TAINTED VII"
ACL_33_taintedHID.Description = "... The Baleful, The Soiled and The Fettered."
ACL_33_taintedHID.Counter = 0
ACL_33_taintedHID.dimX = 4
ACL_33_taintedHID.dimY = 6
ACL_33_taintedHID.size = 3

ACL_33_taintedHID.isHidden = true

ACL_33_taintedHID.portrait = "tainted7" -- call your image for the portrait this!!!!

ACL_33_taintedHID.collection = false
ACL_33_taintedHID.collectionPortrait = "taintedfull"

ACL_33_taintedHID.grid = {}

ACL_33_taintedHID.grid[1] = {
DisplayName = "The Baleful",
DisplayText = "Use the Red Key as The Lost",
TextName = [[You unlocked "The Lost"]],
gfx = "Achievement_TheLostB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[2] = {
DisplayName = "The Soiled",
DisplayText = "Use the Red Key as ???",
TextName = [[You unlocked "???"]],
gfx = "Achievement_BlueBabyB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[3] = {
DisplayName = "The Fettered",
DisplayText = "Use the Red Key as The Forgotten",
TextName = [[You unlocked "The Forgotten"]],
gfx = "Achievement_TheForgottenB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[4] = {
DisplayName = "Sacred Orb",
DisplayText = "Defeat The Beast as Tainted Lost",
TextName = [["Sacred Orb" has appeared in the basement]],
gfx = "Achievement_SacredOrb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SACRED_ORB,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[5] = {
DisplayName = "The Swarm",
DisplayText = "Defeat The Beast as Tainted ???",
TextName = [["The Swarm" has appeared in the basement]],
gfx = "Achievement_TheSwarm.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[6] = {
DisplayName = "Isaac's Tomb",
DisplayText = "Defeat The Beast as Tainted Forgotten",
TextName = [["Isaac's Tomb" has appeared in the basement]],
gfx = "Achievement_IsaacsTomb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[7] = {
DisplayName = "Reverse Fool",
DisplayText = "Defeat Ultra Greedier as Tainted Lost",
TextName = [["The Fool" has appeared in the basement]],
gfx = "Achievement_ReverseFool.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[8] = {
DisplayName = "Reverse Emperor",
DisplayText = "Defeat Ultra Greedier as Tainted ???",
TextName = [["The Emperor" has appeared in the basement]],
gfx = "Achievement_ReverseEmperor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[9] = {
DisplayName = "Reverse Death",
DisplayText = "Defeat Ultra Greedier as Tainted Forgotten",
TextName = [["Death" has appeared in the basement]],
gfx = "Achievement_ReverseDeath.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[10] = {
DisplayName = "Kid's Drawing",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Lost",
TextName = [["Kid's Drawing" has appeared in the basement]],
gfx = "Achievement_KidsDrawing.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[11] = {
DisplayName = "Dingle Berry",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted ???",
TextName = [["Dingle Berry" has appeared in the basement]],
gfx = "Achievement_DingleBerry.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[12] = {
DisplayName = "Polished Bone",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Forgotten",
TextName = [["Polished Bone" has appeared in the basement]],
gfx = "Achievement_PolishedBone.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[13] = {
DisplayName = "Crystal Key",
DisplayText = "Defeat Mother as Tainted Lost",
TextName = [["Crystal Key" has appeared in the basement]],
gfx = "Achievement_CrystalKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[14] = {
DisplayName = "Ring Cap",
DisplayText = "Defeat Mother as Tainted ???",
TextName = [["Ring Cap" has appeared in the basement]],
gfx = "Achievement_RingCap.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[15] = {
DisplayName = "Hollow Heart",
DisplayText = "Defeat Mother as Tainted Forgotten",
TextName = [["Hollow Heart" has appeared in the basement]],
gfx = "Achievement_HollowHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[16] = {
DisplayName = "Ghost Bombs",
DisplayText = "Defeat Delirium as Tainted Lost",
TextName = [["Ghost Bombs" has appeared in the basement]],
gfx = "Achievement_GhostBombs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[17] = {
DisplayName = "IBS",
DisplayText = "Defeat Delirium as Tainted ???",
TextName = [["IBS" has appeared in the basement]],
gfx = "Achievement_IBS.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[18] = {
DisplayName = "Decap Attack",
DisplayText = "Defeat Delirium as Tainted Forgotten",
TextName = [["Decap Attack" has appeared in the basement]],
gfx = "Achievement_DecapAttack.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[19] = {
DisplayName = "Haunted Chest",
DisplayText = "Defeat Mega Satan as Tainted Lost",
TextName = [["Haunted Chest" has appeared in the basement]],
gfx = "Achievement_HauntedChest.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[20] = {
DisplayName = "Charming Poop",
DisplayText = "Defeat Mega Satan as Tainted ???",
TextName = [["Charming Poop" has appeared in the basement]],
gfx = "Achievement_CharmingPoop.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[21] = {
DisplayName = "Golden Battery",
DisplayText = "Defeat Mega Satan as Tainted Forgotten",
TextName = [["Golden Battery" has appeared in the basement]],
gfx = "Achievement_GoldenBattery.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[22] = {
DisplayName = "Soul of the Lost",
DisplayText = "Defeat Hush and Boss Rush as Tainted Lost",
TextName = [["Soul of the Lost" has appeared in the basement]],
gfx = "Achievement_SoulOftheLost.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[23] = {
DisplayName = "Soul of ???",
DisplayText = "Defeat Hush and Boss Rush as Tainted ???",
TextName = [["Soul of ???" has appeared in the basement]],
gfx = "Achievement_SoulOfBlueBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_33_taintedHID.grid[24] = {
DisplayName = "Soul of the Forgotten",
DisplayText = "Defeat Hush and Boss Rush as Tainted Forgotten",
TextName = [["Soul of the Forgotten" has appeared in the basement]],
gfx = "Achievement_SoulOftheForgotten.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

return ACL_33_taintedHID