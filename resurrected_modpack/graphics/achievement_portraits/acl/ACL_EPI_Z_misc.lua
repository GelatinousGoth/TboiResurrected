local ACL_EPI_Z_misc = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_Z_misc.Pname = "Epiphany Misc."
ACL_EPI_Z_misc.Description = "Leftover Achievements (for now)"
ACL_EPI_Z_misc.Counter = 0
ACL_EPI_Z_misc.dimX = 4
ACL_EPI_Z_misc.dimY = 4
ACL_EPI_Z_misc.size = 1
ACL_EPI_Z_misc.epiphany = true

ACL_EPI_Z_misc.isHidden = false

ACL_EPI_Z_misc.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_Z_misc.redo = true
ACL_EPI_Z_misc.Check = false

function ACL_EPI_Z_misc:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_Z_misc.Check = true
		
		ACL_EPI_Z_misc:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_Z_misc.Check == true then
		ACL_EPI_Z_misc.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_Z_misc.Revise)

ACL_EPI_Z_misc.grid = {}

function ACL_EPI_Z_misc:Redo()

if Epiphany then

	ACL_EPI_Z_misc.grid[2] = {
	DisplayName = "Nothing",
	DisplayText = "Complete One With Nothing",
	TextName = [[You unlocked "Nothing"]],
	gfx = "tarnished_achievement_nothing.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("NOTHING"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[1] = {
	DisplayName = "Mom's Hug",
	DisplayText = "Complete Sweet Tooth",
	TextName = [[You unlocked "Mom's Hug"]],
	gfx = "tarnished_achievement_moms_hug.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MOMS_HUG"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[3] = {
	DisplayName = "Tasty Pennies",
	DisplayText = "Complete the challenge Pool!",
	TextName = [[You unlocked "Tasty Pennies"]],
	gfx = "tarnished_achievement_tasty_penny.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("TASTY_PENNY"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[4] = {
	DisplayName = "30 Pieces of Silver",
	DisplayText = "Complete Kagemane no Jutsu",
	TextName = [[You unlocked "Thirty Pieces of Silver"]],
	gfx = "tarnished_achievement_thirty_pieces_of_silver.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("THIRTY_PIECES_OF_SILVER"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[5] = {
	DisplayName = "Drawn Card",
	DisplayText = "Complete NullPointerException",
	TextName = [[You unlocked "Drawn Card"]],
	gfx = "tarnished_achievement_drawn_card.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DRAWN_CARD"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[6] = {
	DisplayName = "Coin Case",
	DisplayText = "Complete Dealmaker",
	TextName = [[You unlocked "Coin Case"]],
	gfx = "tarnished_achievement_coin_case.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("COIN_CASE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[7] = {
	DisplayName = "Chance Cube",
	DisplayText = "Complete Overwhelming Odds",
	TextName = [[You unlocked "Chance Cube"]],
	gfx = "tarnished_achievement_chance_cube.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CHANCE_CUBE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[9] = {
	DisplayName = "Revolt",
	DisplayText = "Complete He Who Cast The First Stone",
	TextName = [[You unlocked "Revolt"]],
	gfx = "tarnished_achievement_revolt.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("REVOLT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_Z_misc.grid[8] = {
	DisplayName = "Retribution",
	DisplayText = "Complete Retribution",
	TextName = [[You unlocked "Retribution"]],
	gfx = "tarnished_achievement_retribution.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("RETRIBUTION"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[10] = {
	DisplayName = "Fly Trap",
	DisplayText = "Complete Emperor of Flies",
	TextName = [[You unlocked "Fly Trap"]],
	gfx = "tarnished_achievement_fly_trap.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("FLY_TRAP"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[11] = {
	DisplayName = "Eden now holds an item",
	DisplayText = "Debug 30 items as Tarnished Eden.",
	TextName = [[Eden now holds an item!]],
	gfx = "tarnished_achievement_eden_item.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("EDEN_ITEM"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[12] = {
	DisplayName = "Pain in a Box",
	DisplayText = "Take damage 50 times as any Samson",
	TextName = [[You unlocked "Pain in a Box"]],
	gfx = "tarnished_achievement_pain_in_a_box.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("PAIN_IN_A_BOX"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[13] = {
	DisplayName = "Bagged Essence",
	DisplayText = "Use 20 Essences",
	TextName = [[You unlocked "Bagged Essence"]],
	gfx = "tarnished_achievement_bagged_essence.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BAGGED_ESSENCE"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[14] = {
	DisplayName = "Empty Deck",
	DisplayText = "Use 50 cards with the Epiphany mod enabled",
	TextName = [[You unlocked "Empty Deck"]],
	gfx = "tarnished_achievement_empty_deck.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("EMPTY_DECK"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[15] = {
	DisplayName = "Woolen Cap",
	DisplayText = "Bag 50 items with Tarnished Cain",
	TextName = [[You unlocked "Woolen Cap"]],
	gfx = "tarnished_achievement_woolen_cap.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("WOOLEN_CAP"),
	Near = false,
	Tile = Sprite()
	}
	
	ACL_EPI_Z_misc.grid[16] = {
	DisplayName = "Work in Progress",
	DisplayText = "Start a run with Epiphany characters 50 times",
	TextName = [[You unlocked "Work in Progress"]],
	gfx = "tarnished_achievement_work_in_progress.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("WORK_IN_PROGRESS"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_Z_misc