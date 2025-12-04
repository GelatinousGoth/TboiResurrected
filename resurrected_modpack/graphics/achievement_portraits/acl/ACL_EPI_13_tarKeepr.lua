local ACL_EPI_13_tarKeepr = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_13_tarKeepr.Pname = "AVARICE"
ACL_EPI_13_tarKeepr.Description = "An Eternal Dream With No Resolution..."
ACL_EPI_13_tarKeepr.Counter = 0
ACL_EPI_13_tarKeepr.dimX = 3
ACL_EPI_13_tarKeepr.dimY = 3
ACL_EPI_13_tarKeepr.size = 6
ACL_EPI_13_tarKeepr.epiphany = true

ACL_EPI_13_tarKeepr.isHidden = false

ACL_EPI_13_tarKeepr.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_13_tarKeepr.redo = true
ACL_EPI_13_tarKeepr.Check = false

function ACL_EPI_13_tarKeepr:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_13_tarKeepr.Check = true
		
		ACL_EPI_13_tarKeepr:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_13_tarKeepr.Check == true then
		ACL_EPI_13_tarKeepr.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_13_tarKeepr.Revise)

ACL_EPI_13_tarKeepr.grid = {}

function ACL_EPI_13_tarKeepr:Redo()

if Epiphany then

	ACL_EPI_13_tarKeepr.grid[2] = {
	DisplayName = "Essence of the Keeper",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Keeper",
	TextName = [[You unlocked "Essence of the Keeper"]],
	gfx = "tarnished_achievement_essence_of_keeper.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_KEEPER"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[1] = {
	DisplayName = "Stock Fluctuation",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Keeper",
	TextName = [[You unlocked "Stock Fluctuation"]],
	gfx = "tarnished_achievement_stock_fluctuation.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("STOCK_FLUCTUATION"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[3] = {
	DisplayName = "Golden Items",
	DisplayText = "Defeat Mega Satan as Tarnished Keeper",
	TextName = [[You unlocked "Golden Item"]],
	gfx = "tarnished_achievement_golden_collectible.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("GOLDEN_COLLECTIBLE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[4] = {
	DisplayName = "Bad Company",
	DisplayText = "Defeat Delirium as Tarnished Keeper",
	TextName = [[You unlocked "Bad Company"]],
	gfx = "tarnished_achievement_bad_company.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BAD_COMPANY"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[5] = {
	DisplayName = "Tarnished Keeper",
	DisplayText = "Find that item in the 1st secret room of greedier mode and defeat Ultra Greedier as...",
	TextName = [[You unlocked "Keeper"]],
	gfx = "tarnished_achievement_character_keeper.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("KEEPER"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[6] = {
	DisplayName = "Debit Card",
	DisplayText = "Defeat Ultra Greedier as Tarnished Keeper",
	TextName = [[You unlocked "Debit Card"]],
	gfx = "tarnished_achievement_debit_card.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DEBIT_CARD"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[7] = {
	DisplayName = "Golden Cobweb",
	DisplayText = "Defeat The Beast as Tarnished Keeper",
	TextName = [[You unlocked "Golden Cobweb"]],
	gfx = "tarnished_achievement_golden_cobweb.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("GOLDEN_COBWEB"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[9] = {
	DisplayName = "Lucky Cat",
	DisplayText = "Defeat Mother as Tarnished Keeper",
	TextName = [[You unlocked "Lucky Cat"]],
	gfx = "tarnished_achievement_lucky_cat.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("LUCKY_CAT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_13_tarKeepr.grid[8] = {
	DisplayName = "Turnover",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Keeper",
	TextName = [[You unlocked "Turnover"]],
	gfx = "tarnished_achievement_turnover.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("TURNOVER"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_13_tarKeepr