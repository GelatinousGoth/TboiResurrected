local ACL_13_keeper = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_13_keeper.Pname = "KEEPER"
ACL_13_keeper.Description = "Just like his father..."
ACL_13_keeper.Counter = 0
ACL_13_keeper.dimX = 3
ACL_13_keeper.dimY = 5
ACL_13_keeper.size = 4

ACL_13_keeper.isHidden = false

ACL_13_keeper.portrait = "keeper" -- call your image for the portrait this!!!!


ACL_13_keeper.grid = {}

ACL_13_keeper.grid[1] = {
DisplayName = "Keeper",
DisplayText = "Be charitable in greed mode",
TextName = [[You unlocked "Keeper"]],
gfx = "Achievement_251_Keeper.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPER,
Near = true,
Tile = Sprite()
}

ACL_13_keeper.grid[2] = {
DisplayName = "Store Key",
DisplayText = "Defeat Satan as Keeper",
TextName = [["Keeper now holds... "Store Key"]],
gfx = "Achievement_237_KeeperStoreKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPER_HOLDS_STORE_KEY,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[3] = {
DisplayName = "Wooden Nickel", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Keeper', --Name displayed in secrets menu
TextName = [[Keeper now holds... "Wooden Nickel"]],
gfx = "Achievement_236_KeeperWoodenNickel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPER_HOLDS_WOODEN_NICKEL,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[4] = {
DisplayName = "Karma",
DisplayText = 'Defeat The Lamb as Keeper',
TextName = [["Karma" has appeared in the basement]],
gfx = "Achievement_239_Karma.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KARMA,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[5] = { 
DisplayName = "Deep Pockets",
DisplayText = "Defeat ??? as Keeper",
TextName = [["Deep Pockets" has appeared in the basement]],
gfx = "Achievement_238_DeepPockets.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEEP_POCKETS,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[6] = {
DisplayName = "Noose Baby",
DisplayText = "Defeat Mega Satan as Keeper",
TextName = [["Noose Baby" has appeared in the basement]],
gfx = "Achievement_217_NooseBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.NOOSE_BABY,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[7] = {
DisplayName = "A Penny!",
DisplayText = "Defeat Hush as Keeper",
TextName = [[Keeper now holds... "A Penny!"]],
gfx = "Achievement_191_APenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPER_HOLDS_A_PENNY,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[8] = {
DisplayName = "Crooked Penny",
DisplayText = "Defeat Delirium as Keeper",
TextName = [["Crooked Penny" has appeared in the basement]],
gfx = "Achievement_CrookedPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CROOKED_CARD,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[9] = {
DisplayName = "Keeper's Sack",
DisplayText = "Defeat Mother as Keeper",
TextName = [["Keeper's Sack" has appeared in the basement]],
gfx = "Achievement_KeepersSack.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPERS_SACK,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[10] = {
DisplayName = "Keeper's Box",
DisplayText = "Defeat The Beast as Keeper",
TextName = [["Keeper's Box" has appeared in the basement]],
gfx = "Achievement_KeepersBox.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEEPERS_BOX,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[11] = {
DisplayName = "Super Greed Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Keeper (Hard Mode)",
TextName = [["Super Greed Baby" has appeared in the basement]],
gfx = "Achievement_241_SuperGreedBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUPER_GREED_BABY,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[12] = {
DisplayName = "Sale Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Keeper",
TextName = [["Sale Baby" has appeared in the basement]],
gfx = "Achievement_264_SaleBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SALE_BABY,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[13] = {
DisplayName = "Sticky Nickels",
DisplayText = 'Complete the Boss Rush as Keeper', 
TextName = [[Sticky Nickels have appeared in the basement]], 
gfx = "Achievement_240_StickyNickels.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STICKY_NICKELS,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[14] = {
DisplayName = "Rib of Greed",
DisplayText = "Complete Greed Mode as Keeper",
TextName = [["Rib of Greed" has appeared in the basement]],
gfx = "Achievement_204_RibOfGreed.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RIB_OF_GREED,
Near = false,
Tile = Sprite()
}

ACL_13_keeper.grid[15] = {
DisplayName = "Eye of Greed",
DisplayText = "Complete Greedier Mode as Keeper",
TextName = [["Eye of Greed" has appeared in the basement]],
gfx = "Achievement_EyeOfGreed.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EYE_OF_GREED,
Near = false,
Tile = Sprite()
}

return ACL_13_keeper



