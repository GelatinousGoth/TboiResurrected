local ACL_EPI_10_tarEden = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_10_tarEden.Pname = "CORRUPTION"
ACL_EPI_10_tarEden.Description = "Undesirable Corruption..."
ACL_EPI_10_tarEden.Counter = 0
ACL_EPI_10_tarEden.dimX = 3
ACL_EPI_10_tarEden.dimY = 3
ACL_EPI_10_tarEden.size = 6
ACL_EPI_10_tarEden.epiphany = true

ACL_EPI_10_tarEden.isHidden = false

ACL_EPI_10_tarEden.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_10_tarEden.redo = true
ACL_EPI_10_tarEden.Check = false

function ACL_EPI_10_tarEden:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_10_tarEden.Check = true
		
		ACL_EPI_10_tarEden:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_10_tarEden.Check == true then
		ACL_EPI_10_tarEden.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_10_tarEden.Revise)

ACL_EPI_10_tarEden.grid = {}

function ACL_EPI_10_tarEden:Redo()

if Epiphany then

	ACL_EPI_10_tarEden.grid[2] = {
	DisplayName = "Essence of Eden",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Eden",
	TextName = [[You unlocked "Essence of Eden"]],
	gfx = "tarnished_achievement_essence_of_eden.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_EDEN"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[1] = {
	DisplayName = "Segmentation Fault",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Eden",
	TextName = [[You unlocked "Segmentation Fault"]],
	gfx = "tarnished_achievement_segmentation_fault.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("SEGMENTATION_FAULT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[3] = {
	DisplayName = "Glitched Machine",
	DisplayText = "Defeat Mega Satan as Tarnished Eden",
	TextName = [[You unlocked "Glitched Machine"]],
	gfx = "tarnished_achievement_glitched_machine.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("GLITCHED_MACHINE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[4] = {
	DisplayName = "Zip Bombs",
	DisplayText = "Defeat Delirium as Tarnished Eden",
	TextName = [[You unlocked "Zip Bombs"]],
	gfx = "tarnished_achievement_zip_bombs.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ZIP_BOMBS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[5] = {
	DisplayName = "Tarnished Eden",
	DisplayText = "Beat the first floor boss in under 1 minute and bring that photo to the strange door as...",
	TextName = [[You unlocked "EDEN"]],
	gfx = "tarnished_achievement_character_eden.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("EDEN"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[6] = {
	DisplayName = "+1 and -1 Card",
	DisplayText = "Defeat Ultra Greedier as Tarnished Eden",
	TextName = [[You nlocked "+1 Card and -1 Card"]],
	gfx = "tarnished_achievement_one_cards.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ONE_CARDS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[7] = {
	DisplayName = "Printer",
	DisplayText = "Defeat The Beast as Tarnished Eden",
	TextName = [[You unlocked "Printer"]],
	gfx = "tarnished_achievement_printer.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("PRINTER"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[9] = {
	DisplayName = "Paper Airplane",
	DisplayText = "Defeat Mother as Tarnished Eden",
	TextName = [[You unlocked "Paper Airplane"]],
	gfx = "tarnished_achievement_paper_airplane.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("PAPER_AIRPLANE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_10_tarEden.grid[8] = {
	DisplayName = "Debug",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Eden",
	TextName = [[You unlocked "Debug"]],
	gfx = "tarnished_achievement_debug.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DEBUG"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_10_tarEden