local ACL_EPI_1_tarIsaac = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_1_tarIsaac.Pname = "SACRIFICE"
ACL_EPI_1_tarIsaac.Description = "Destined To Rot..."
ACL_EPI_1_tarIsaac.Counter = 0
ACL_EPI_1_tarIsaac.dimX = 3
ACL_EPI_1_tarIsaac.dimY = 3
ACL_EPI_1_tarIsaac.size = 6
ACL_EPI_1_tarIsaac.epiphany = true

ACL_EPI_1_tarIsaac.isHidden = false

ACL_EPI_1_tarIsaac.portrait = "tarIsaac" -- call your image for the portrait this!!!!

ACL_EPI_1_tarIsaac.redo = true
ACL_EPI_1_tarIsaac.Check = false

function ACL_EPI_1_tarIsaac:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_1_tarIsaac.Check = true
		
		ACL_EPI_1_tarIsaac:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_1_tarIsaac.Check == true then
		ACL_EPI_1_tarIsaac.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_1_tarIsaac.Revise)

ACL_EPI_1_tarIsaac.grid = {}

function ACL_EPI_1_tarIsaac:Redo()

if Epiphany then

	ACL_EPI_1_tarIsaac.grid[1] = {
	DisplayName = "D5",
	DisplayText = "Defeat Delirium as Tarnished Isaac",
	TextName = [[You unlocked "D5"]],
	gfx = "tarnished_achievement_d5.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("D5"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[2] = {
	DisplayName = "Mother's Shadow",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Isaac",
	TextName = [[You unlocked "Mother's Shadow"]],
	gfx = "tarnished_achievement_mothers_shadow.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MOTHERS_SHADOW"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[3] = {
	DisplayName = "Dice Machine",
	DisplayText = "Defeat Mega Satan as Tarnished Isaac",
	TextName = [[You unlocked "Dice Machine"]],
	gfx = "tarnished_achievement_dice_machine.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DICE_MACHINE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[4] = {
	DisplayName = "Essence of Isaac",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Isaac",
	TextName = [[You unlocked "Essence of Isaac"]],
	gfx = "tarnished_achievement_essence_of_isaac.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_ISAAC"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_1_tarIsaac.grid[5] = {
	DisplayName = "Tarnished Isaac",
	DisplayText = "Bomb the first pedestal and reach the strange door as Tainted...",
	TextName = [[You unlocked "Isaac"]],
	gfx = "tarnished_achievement_character_isaac.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ISAAC"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[6] = {
	DisplayName = "! CARD",
	DisplayText = "Defeat Ultra Greedier as Tarnished Isaac",
	TextName = [[You unlocked "! Card"]],
	gfx = "tarnished_achievement_!card.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("!CARD"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[7] = {
	DisplayName = "First Page",
	DisplayText = "Defeat The Beast as Tarnished Isaac",
	TextName = [[You unlocked "First Page"]],
	gfx = "tarnished_achievement_first_page.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("FIRST_PAGE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[9] = {
	DisplayName = "Dad's Wallet",
	DisplayText = "Defeat Mother as Tarnished Isaac",
	TextName = [[You unlocked "Dad's Wallet"]],
	gfx = "tarnished_achievement_dads_wallet.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DADS_WALLET"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_1_tarIsaac.grid[8] = {
	DisplayName = "Blighted Dice",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Isaac",
	TextName = [[You unlocked "Blighted Dice"]],
	gfx = "tarnished_achievement_blighted_dice.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BLIGHTED_DICE"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_1_tarIsaac