local ACL_8_azazel = {}

local DATA = Isaac.GetPersistentGameData()

local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_8_azazel.Pname = "AZAZEL"
ACL_8_azazel.Description = "A scapegoat bears sins of forbidden knowledge"
ACL_8_azazel.Counter = 0
ACL_8_azazel.dimX = 3
ACL_8_azazel.dimY = 5
ACL_8_azazel.size = 4

ACL_8_azazel.isHidden = false

ACL_8_azazel.portrait = "azazel" --uses this to find image in ("resources/gfx/portrait/"..P.portrait..".png")


ACL_8_azazel.grid = {}

ACL_8_azazel.redo = true
ACL_8_azazel.Check = false

function ACL_8_azazel:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_8_azazel.Check = true
		
		ACL_8_azazel:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_8_azazel.Check == true then
		ACL_8_azazel.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_8_azazel.Revise)

function ACL_8_azazel:Redo()

ACL_8_azazel.grid[1] = {
DisplayName = "Azazel",
DisplayText = "Make 3 Deals with the Devil in one run",
TextName = [[You unlocked "Demon Isaac"]],
gfx = "Achievement_Azazel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.AZAZEL,
Near = true,
Tile = Sprite()
}

ACL_8_azazel.grid[2] = {
DisplayName = "Daemon's Tail",
DisplayText = "Defeat Satan as Azazel",
TextName = [["Daemon's Tail" has appeared in the basement]],
gfx = "Achievement_DemonTail.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DAEMONS_TAIL,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[3] = {
DisplayName = "Satanic Bible", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Azazel', --Name displayed in secrets menu
TextName = [["Satanic Bible" has appeared in the basement]],
gfx = "Achievement_SatanicBible.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SATANIC_BIBLE,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[4] = {
DisplayName = "A Demon Baby",
DisplayText = 'Defeat The Lamb as Azazel',
TextName = [["A Demon Baby!" has appeared in the basement]],
gfx = "Achievement_DemonBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEMON_BABY,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[5] = { 
DisplayName = "Abaddon",
DisplayText = "Defeat ??? as Azazel",
TextName = [["Abaddon" has appeared in the basement]],
gfx = "Achievement_Abaddon.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ABADDON,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[15] = {
DisplayName = "Bat Wing",
DisplayText = "Complete Greedier Mode as Azazel",
TextName = [["Bat Wing" has appeared in the basement]],
gfx = "Achievement_BatWing.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BAT_WING,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[7] = {
DisplayName = "Maw of the Void",
DisplayText = "Defeat Hush as Azazel",
TextName = [["Maw of the Void" has appeared in the basement]],
gfx = "Achievement_186_MawOfTheVoid.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MAW_OF_THE_VOID,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[8] = {
DisplayName = "Lil Abaddon",
DisplayText = "Defeat The Beast as Azazel",
TextName = [["Lil Abaddon" has appeared in the basement]],
gfx = "Achievement_LilAbaddon.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LIL_ABADDON,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[9] = {
DisplayName = "Devil's Crown",
DisplayText = "Defeat Mother as Azazel",
TextName = [["Devil's Crown" has appeared in the basement]],
gfx = "Achievement_DevilsCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEVILS_CROWN,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[10] = {
DisplayName = "Dark Prince's Crown",
DisplayText = "Defeat Delirium as Azazel",
TextName = [["Dark Prince's Crown" has appeared in the basement]],
gfx = "Achievement_DarkPrincesCrown.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DARK_PRINCES_CROWN,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[11] = {
DisplayName = "Begotten Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Azazel (Hard Mode)",
TextName = [[You unlocked "Begotten Baby"]],
gfx = "Achievement_BegottenBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BEGOTTEN_BABY,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[12] = {
DisplayName = "Sucky Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Azazel",
TextName = [["Sucky Baby" has appeared in the basement]],
gfx = "Achievement_259_SuckyBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUCKY_BABY,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[13] = {
DisplayName = "The Nail",
DisplayText = 'Complete the Boss Rush as Azazel', 
TextName = [["The Nail" has appeared in the basement]], 
gfx = "Achievement_TheNail.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_NAIL,
Near = false,
Tile = Sprite()
}
ACL_8_azazel.grid[14] = {
DisplayName = "Krampus",
DisplayText = "Take 20 items from Devil Rooms"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.DEVIL_DEALS_TAKEN), 20),
TextName = [[Krampus unlocked]],
gfx = "Achievement_Krampus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KRAMPUS_UNLOCKED,
Near = false,
Tile = Sprite()
}

ACL_8_azazel.grid[6] = {
DisplayName = "Black Baby",
DisplayText = "Defeat Mega Satan as Azazel",
TextName = [["Black Baby" has appeared in the basement]],
gfx = "Achievement_212_BlackBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLACK_BABY,
Near = false,
Tile = Sprite()
}

end

-- ADD A SPRITE VALUE TO EACH GRID DATA, AS WELL AS A VECTOR DATA.

return ACL_8_azazel
