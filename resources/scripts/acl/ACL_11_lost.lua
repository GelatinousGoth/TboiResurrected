local ACL_11_lost = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_11_lost.Pname = "THE LOST"
ACL_11_lost.Description = "Lost and locked away inside their own fantasy, their own nightmare."
ACL_11_lost.Counter = 0
ACL_11_lost.dimX = 3
ACL_11_lost.dimY = 5
ACL_11_lost.size = 4

ACL_11_lost.isHidden = false

ACL_11_lost.portrait = "lost" -- call your image for the portrait this!!!!


ACL_11_lost.grid = {}

ACL_11_lost.grid[1] = {
DisplayName = "The Lost",
DisplayText = "Hold the Missing Poster and die in...",
TextName = [[You unlocked "The Soul"]],
gfx = "Achievement_thelost.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOST,
Near = true,
Tile = Sprite()
}

ACL_11_lost.grid[2] = {
DisplayName = "The Mind",
DisplayText = "Defeat Satan as The Lost",
TextName = [["The Mind" has appeared in the basement]],
gfx = "Achievement_TheMind.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_MIND_ITEM,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[3] = {
DisplayName = "Isaac's Heart", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as The Lost', --Name displayed in secrets menu
TextName = [["Isaac's Heart" has appeared in the basement]],
gfx = "Achievement_IsaacsHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ISAACS_HEART,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[4] = {
DisplayName = "The Soul",
DisplayText = 'Defeat The Lamb as The Lost',
TextName = [["The Soul" has appeared in the basement]],
gfx = "Achievement_TheSoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOUL,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[5] = { 
DisplayName = "The Body",
DisplayText = "Defeat ??? as The Lost",
TextName = [["The Body" has appeared in the basement]],
gfx = "Achievement_TheBody.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_BODY_ITEM,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[6] = {
DisplayName = "White Baby",
DisplayText = "Defeat Mega Satan as The Lost",
TextName = [["White Baby" has appeared in the basement]],
gfx = "Achievement_215_WhiteBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WHITE_BABY,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[7] = {
DisplayName = "Sworn Protector",
DisplayText = "Defeat Hush as The Lost",
TextName = [["Sworn Protector" has appeared in the basement]],
gfx = "Achievement_189_SwornProtector.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SWORN_PROTECTOR,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[8] = {
DisplayName = "Holy Card",
DisplayText = "Defeat Delirium as The Lost",
TextName = [["Holy Card" has appeared in the basement]],
gfx = "Achievement_HolyCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HOLY_CARD,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[9] = {
DisplayName = "Lost Soul",
DisplayText = "Defeat Mother as The Lost",
TextName = [["Lost Soul" has appeared in the basement]],
gfx = "Achievement_LostSoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOST_SOUL,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[10] = {
DisplayName = "Hungry Soul",
DisplayText = "Defeat The Beast as The Lost",
TextName = [["Hungry Soul" has appeared in the basement]],
gfx = "Achievement_HungrySoul.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HUNGRY_SOUL,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[11] = {
DisplayName = "-0- Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as The Lost (Hard Mode)",
TextName = [[You unlocked "-0- Baby"]],
gfx = "Achievement_0Baby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.O_BABY,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[12] = {
DisplayName = "Godhead",
DisplayText = "Get all Completion Marks in Hard Mode as The Lost",
TextName = [["Godhead" has appeared in the basement]],
gfx = "Achievement_Godhead.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GODHEAD,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[13] = {
DisplayName = "A D100",
DisplayText = 'Complete the Boss Rush as The Lost', 
TextName = [["A D100" has appeared in the basement]], 
gfx = "Achievement_D100.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_D100,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[14] = {
DisplayName = "Zodiac",
DisplayText = "Complete Greed Mode as The Lost",
TextName = [["Zodiac" has appeared in the basement]],
gfx = "Achievement_202_Zodiac.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ZODIAC,
Near = false,
Tile = Sprite()
}

ACL_11_lost.grid[15] = {
DisplayName = "Dad's Lost Coin",
DisplayText = "Complete Greedier Mode as The Lost",
TextName = [["Dad's Lost Coin" has appeared in the basement]],
gfx = "Achievement_DadsLostCoin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DADS_LOST_COIN,
Near = false,
Tile = Sprite()
}

return ACL_11_lost



