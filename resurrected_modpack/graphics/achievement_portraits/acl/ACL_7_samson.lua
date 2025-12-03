local ACL_7_samson = {}

local DATA = Isaac.GetPersistentGameData()

ACL_7_samson.Pname = "SAMSON"
ACL_7_samson.Description = "The strongest warrior with a nazarite vow"
ACL_7_samson.Counter = 0
ACL_7_samson.dimX = 3
ACL_7_samson.dimY = 5
ACL_7_samson.size = 4

ACL_7_samson.isHidden = false

ACL_7_samson.portrait = "samson" -- call your image for the portrait this!!!!

ACL_7_samson.grid = {}

ACL_7_samson.grid[1] = {
DisplayName = "Samson",
DisplayText = "Complete 2 floors in a row without taking damage ",
TextName = [[You unlocked "Samson"]],
gfx = "Achievement_Samson.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SAMSON,
Near = true,
Tile = Sprite()
}

ACL_7_samson.grid[2] = {
DisplayName = "Blood Rights",
DisplayText = "Defeat Satan as Samson",
TextName = [["Blood Rights" has appeared in the basement]],
gfx = "Achievement_BloodRights.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOOD_RIGHTS,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[3] = {
DisplayName = "Blood Lust", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Samson', --Name displayed in secrets menu
TextName = [["Blood Lust" has appeared in the basement]],
gfx = "Achievement_BloodyLust.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOODY_LUST,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[4] = {
DisplayName = "Samson's Lock",
DisplayText = 'Defeat The Lamb as Samson',
TextName = [["Samson's Lock" has appeared in the basement]],
gfx = "Achievement_SamsonsLock.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SAMSONS_LOCK,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[5] = { 
DisplayName = "Blood Penny",
DisplayText = "Defeat ??? as Samson",
TextName = [["Blood Penny" has appeared in the basement]],
gfx = "Achievement_BloodyPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOODY_PENNY,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[6] = {
DisplayName = "Rage Baby",
DisplayText = "Defeat Mega Satan as Samson",
TextName = [["Rage Baby" has appeared in the basement]],
gfx = "Achievement_211_RageBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RAGE_BABY,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[7] = {
DisplayName = "Blind Rage",
DisplayText = "Defeat Hush as Samson",
TextName = [["Blind Rage" has appeared in the basement]],
gfx = "Achievement_185_BlindRage.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLIND_RAGE,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[8] = {
DisplayName = "Bloody Crown",
DisplayText = "Defeat Delirium as Samson",
TextName = [["Bloody Crown" has appeared in the basement]],
gfx = "Achievement_BloodyCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOODY_CROWN,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[9] = {
DisplayName = "Bloody Gust",
DisplayText = "Defeat Mother as Samson",
TextName = [["Bloody Gust" has appeared in the basement]],
gfx = "Achievement_BloodyGust.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOODY_GUST,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[10] = {
DisplayName = "Empty Heart",
DisplayText = "Defeat The Beast as Samson",
TextName = [["Empty Heart" has appeared in the basement]],
gfx = "Achievement_EmptyHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EMPTY_HEART,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[11] = {
DisplayName = "Fighting Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Samson (Hard Mode)",
TextName = [[You unlocked "Fighting Baby"]],
gfx = "Achievement_FightingBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FIGHTING_BABY,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[12] = {
DisplayName = "Revenge Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Samson",
TextName = [["Revenge Baby" has appeared in the basement]],
gfx = "Achievement_262_RevengeBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVENGE_BABY,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[13] = {
DisplayName = "Samson's Chains",
DisplayText = 'Complete the Boss Rush as Samson', 
TextName = [["Samson's Chains" has appeared in the basement]], 
gfx = "Achievement_SamsonsChains.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SAMSONS_CHAINS,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[14] = {
DisplayName = "Lusty Blood",
DisplayText = "Complete Greed Mode as Samson",
TextName = [["Lusty Blood" has appeared in the basement]],
gfx = "Achievement_198_LustyBlood.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LUSTY_BLOOD,
Near = false,
Tile = Sprite()
}

ACL_7_samson.grid[15] = {
DisplayName = "Stem Cell",
DisplayText = "Complete Greedier Mode as Samson",
TextName = [["Stem Cell" has appeared in the basement]],
gfx = "Achievement_StemCell.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STEM_CELL,
Near = false,
Tile = Sprite()
}

return ACL_7_samson