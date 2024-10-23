local ACL_27_taintedREC = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_27_taintedREC.Pname = "THE TAINTED I"
ACL_27_taintedREC.Description = "The Broken, The Miser, The Hoarder..."
ACL_27_taintedREC.Counter = 0
ACL_27_taintedREC.dimX = 6
ACL_27_taintedREC.dimY = 4
ACL_27_taintedREC.size = 3


ACL_27_taintedREC.isHidden = true

ACL_27_taintedREC.portrait = "tainted1" -- call your image for the portrait this!!!!

ACL_27_taintedREC.collection = false
ACL_27_taintedREC.collectionPortrait = "taintedfull"


ACL_27_taintedREC.grid = {}

ACL_27_taintedREC.grid[1] = {
DisplayName = "The Broken",
DisplayText = "Use the Red Key as Isaac",
TextName = [[You unlocked "Isaac"]],
gfx = "Achievement_IsaacB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TAINTED_ISAAC,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[2] = {
DisplayName = "Glitched Crown",
DisplayText = "Defeat The Beast as Tainted Isaac",
TextName = [["Glitched Crown" has appeared in the basement]],
gfx = "Achievement_GlitchedCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GLITCHED_CROWN,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[3] = {
DisplayName = "Reverse Stars",
DisplayText = "Defeat Ultra Greedier as Tainted Isaac",
TextName = [["The Stars" has appeared in the basement]],
gfx = "Achievement_ReverseStars.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_THE_STARS,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[4] = {
DisplayName = "Mom's Lock",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Isaac",
TextName = [["Mom's Lock" has appeared in the basement]],
gfx = "Achievement_MomsLock.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MOMS_LOCK,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[5] = {
DisplayName = "Dice Bag",
DisplayText = "Defeat Mother as Tainted Isaac",
TextName = [["Dice Bag" has appeared in the basement]],
gfx = "Achievement_DiceBag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DICE_BAGs,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[6] = {
DisplayName = "Spindown Dice",
DisplayText = "Defeat Delirium as Tainted Isaac",
TextName = [["Spindown Dice" has appeared in the basement]],
gfx = "Achievement_SpindownDice.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SPINDOWN_DICE,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[7] = {
DisplayName = "Mega Chest",
DisplayText = "Defeat Mega Satan as Tainted Isaac",
TextName = [["Mega Chest" has appeared in the basement]],
gfx = "Achievement_MegaChest.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MEGA_CHEST,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[8] = {
DisplayName = "Soul of Isaac",
DisplayText = "Defeat Hush and Boss Rush as Tainted Isaac",
TextName = [["Soul of Isaac" has appeared in the basement]],
gfx = "Achievement_SoulOfIsaac.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOUL_OF_ISAAC,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[9] = {
DisplayName = "The Miser",
DisplayText = "Use the Red Key as Keeper",
TextName = [[You unlocked "Keeper"]],
gfx = "Achievement_KeeperB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[10] = {
DisplayName = "Strawman",
DisplayText = "Defeat The Beast as Tainted Keeper",
TextName = [["Strawman" has appeared in the basement]],
gfx = "Achievement_Strawman.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[11] = {
DisplayName = "The Reverse Hanged Man",
DisplayText = "Defeat Ultra Greedier as Tainted Keeper",
TextName = [["The Hanged Man" has appeared in the basement]],
gfx = "Achievement_ReverseHangedMan.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[12] = {
DisplayName = "Keeper's Bargain",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Keeper",
TextName = [["Keeper's Bargain" has appeared in the basement]],
gfx = "Achievement_KeepersBargain.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[13] = {
DisplayName = "Cursed Penny",
DisplayText = "Defeat Mother as Tainted Keeper",
TextName = [["Cursed Penny" has appeared in the basement]],
gfx = "Achievement_CursedPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[14] = {
DisplayName = "Keeper's Kin",
DisplayText = "Defeat Delirium as Tainted Keeper",
TextName = [["Keeper's Kin" has appeared in the basement]],
gfx = "Achievement_KeepersKin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[15] = {
DisplayName = "Golden Penny",
DisplayText = "Defeat Mega Satan as Tainted Keeper",
TextName = [["Golden Penny" has appeared in the basement]],
gfx = "Achievement_GoldenPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[16] = {
DisplayName = "Soul of the Keeper",
DisplayText = "Defeat Hush and Boss Rush as Tainted Keeper",
TextName = [["Soul of the Keeper" has appeared in the basement]],
gfx = "Achievement_SoulOftheKeeper.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[17] = {
DisplayName = "The Hoarder",
DisplayText = "Use the Red Key as Cain",
TextName = [[You unlocked "Cain"]],
gfx = "Achievement_CainB.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TAINTED_CAIN,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[18] = {
DisplayName = "Blue Key",
DisplayText = "Defeat The Beast as Tainted Cain",
TextName = [["Blue Key" has appeared in the basement]],
gfx = "Achievement_BlueKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_KEY,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[19] = {
DisplayName = "Reversed Wheel of Fortune",
DisplayText = "Defeat Ultra Greedier as Tainted Cain",
TextName = [["Wheel of Fortune" has appeared in the basement]],
gfx = "Achievement_ReverseWheelOfFortune.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_WHEEL_OF_FORTUNE,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[20] = {
DisplayName = "Gilded Key",
DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tainted Cain",
TextName = [["Gilded Key" has appeared in the basement]],
gfx = "Achievement_GildedKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GILDED_KEY,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[21] = {
DisplayName = "Lucky Sack",
DisplayText = "Defeat Mother as Tainted Cain",
TextName = [["Lucky Sack" has appeared in the basement]],
gfx = "Achievement_LuckySack.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LUCKY_SACK,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[22] = {
DisplayName = "Bag of Crafting",
DisplayText = "Defeat Delirium as Tainted Cain",
TextName = [["Bag of Crafting" has appeared in the basement]],
gfx = "Achievement_BagOfCrafting.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BAG_OF_CRAFTING,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[23] = {
DisplayName = "Gold Pill",
DisplayText = "Defeat Mega Satan as Tainted Cain",
TextName = [["Gold Pill" has appeared in the basement]],
gfx = "Achievement_GoldPill.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GOLD_PILL,
Near = false,
Tile = Sprite()
}

ACL_27_taintedREC.grid[24] = {
DisplayName = "Soul of Cain",
DisplayText = "Defeat Hush and Boss Rush as Tainted Cain",
TextName = [["Soul of Cain" has appeared in the basement]],
gfx = "Achievement_SoulOfCain.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOUL_OF_CAIN,
Near = false,
Tile = Sprite()
}


return ACL_27_taintedREC