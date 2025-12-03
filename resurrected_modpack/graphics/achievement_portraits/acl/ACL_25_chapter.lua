local ACL_25_chapter = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_25_chapter.Pname = "MY BASEMENT"
ACL_25_chapter.Description = "It goes deeper than you'd think."
ACL_25_chapter.Counter = 0
ACL_25_chapter.dimX = 4
ACL_25_chapter.dimY = 5
ACL_25_chapter.size = 4

ACL_25_chapter.isHidden = false

ACL_25_chapter.portrait = "basement" -- call your image for the portrait this!!!!


ACL_25_chapter.grid = {}

ACL_25_chapter.redo = true
ACL_25_chapter.Check = false

function ACL_25_chapter:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_25_chapter.Check = true
		
		ACL_25_chapter:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_25_chapter.Check == true then
		ACL_25_chapter.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_25_chapter.Revise)

function ACL_25_chapter:Redo()

ACL_25_chapter.grid[1] = {
DisplayName = "Monstro's Tooth",
DisplayText = "Beat Chapter 1",
TextName = [["Monstro's Tooth" has appeared in the basement]],
gfx = "Achievement_MonstrosTooth.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[2] = {
DisplayName = "Lil Chubby",
DisplayText = "Beat Chapter 2",
TextName = [["Lil Chubby" has appeared in the basement]],
gfx = "Achievement_LilChubby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[3] = {
DisplayName = "Something From The Future!",
DisplayText = "Beat Basement 40 times",
TextName = [[You unlocked "Something From The Future!" in the basement]],
gfx = "Achievement_Steven.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[4] = {
DisplayName = "Something Cute",
DisplayText = "Beat Chapter 2 30 times",
TextName = [[You unlocked "Something Cute" in the caves]],
gfx = "Achievement_CHAD.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[5] = {
DisplayName = "Something Sticky",
DisplayText = "Beat Chapter 3 20 times",
TextName = [[You unlocked "Something Sticky" in the depths]],
gfx = "Achievement_Gishy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[6] = {
DisplayName = "A Gamekid",
DisplayText = "Visit 10 Arcades"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.ARCADES_ENTERED), 10),
TextName = [["A Gamekid" has appeared in the basement]],
gfx = "Achievement_GameKid.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[7] = {
DisplayName = "Basement Boy",
DisplayText = "Beat Chapter 1 without taking damage",
TextName = [["Basement Boy" achieved]],
gfx = "Achievement_BasementBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[8] = {
DisplayName = "Spelunker Boy",
DisplayText = "Beat Chapter 2 without taking damage",
TextName = [["Spelunker Boy" achieved]],
gfx = "Achievement_SpelunkerBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[9] = {
DisplayName = "Dark Boy",
DisplayText = "Beat Chapter 3 without taking damage",
TextName = [["Dark Boy" achieved]],
gfx = "Achievement_DarkBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[10] = {
DisplayName = "Mamas Boy",
DisplayText = "Beat Chapter 4 without taking damage",
TextName = [["Mamas Boy" achieved]],
gfx = "Achievement_MamasBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[11] = {
DisplayName = "Dead Boy",
DisplayText = "Complete Chapter 6 without taking damage",
TextName = [["Dead Boy" achieved]],
gfx = "Achievement_DeadBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[12] = {
DisplayName = "Angels",
DisplayText = "Complete Chapter 6",
TextName = [[You unlocked the Angel bosses]],
gfx = "Achievement_Angels.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[13] = {
DisplayName = "Ace Of Hearts",
DisplayText = "Start and end a Chapter after Basement with only half a Heart",
TextName = [[Living on the edge]],
gfx = "Achievement_AceOfHearts.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[14] = {
DisplayName = "Sprinkler",
DisplayText = "Beat Chapter 1 without taking damage",
TextName = [["Sprinkler" has appeared in the basement]],
gfx = "Achievement_Sprinkler.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[15] = {
DisplayName = "Telekinesis",
DisplayText = "Beat Chapter 2 without taking damage",
TextName = [["Telekinesis" has appeared in the basement]],
gfx = "Achievement_Telekinesis.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[16] = {
DisplayName = "Leprosy",
DisplayText = "Beat Chapter 3 without taking damage",
TextName = [["Leprosy" has appeared in the basement]],
gfx = "Achievement_Leprosy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[17] = {
DisplayName = "Pop!",
DisplayText = "Beat Chapter 4 without taking damage",
TextName = [["Pop!" has appeared in the basement]],
gfx = "Achievement_Pop.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[18] = {
DisplayName = "Door Stop",
DisplayText = "Blow up doors and Secret Room walls 50 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.SECRET_ROOMS_WALLS_OPENED), 50),
TextName = [["Door Stop" has appeared in the basement]],
gfx = "Achievement_DoorStop.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[19] = {
DisplayName = "Rotten Heart",
DisplayText = "Enter The Corpse for the first time",
TextName = [["Rotten Heart" has appeared in the basement]],
gfx = "Achievement_RottenHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_25_chapter.grid[20] = {
DisplayName = "Red Key",
DisplayText = "Open Mom's Chest...",
TextName = [["Red Key" has appeared in the basement]],
gfx = "Achievement_RedKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

end

return ACL_25_chapter