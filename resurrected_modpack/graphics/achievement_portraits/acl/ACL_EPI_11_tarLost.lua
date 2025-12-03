local ACL_EPI_11_tarLost = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_11_tarLost.Pname = "REVERIE"
ACL_EPI_11_tarLost.Description = "An Eternal Dream With No Resolution..."
ACL_EPI_11_tarLost.Counter = 0
ACL_EPI_11_tarLost.dimX = 3
ACL_EPI_11_tarLost.dimY = 3
ACL_EPI_11_tarLost.size = 6
ACL_EPI_11_tarLost.epiphany = true

ACL_EPI_11_tarLost.isHidden = false

ACL_EPI_11_tarLost.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_11_tarLost.redo = true
ACL_EPI_11_tarLost.Check = false

function ACL_EPI_11_tarLost:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_11_tarLost.Check = true
		
		ACL_EPI_11_tarLost:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_11_tarLost.Check == true then
		ACL_EPI_11_tarLost.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_11_tarLost.Revise)

ACL_EPI_11_tarLost.grid = {}

function ACL_EPI_11_tarLost:Redo()

if Epiphany then

	ACL_EPI_11_tarLost.grid[2] = {
	DisplayName = "Essence of the Lost",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Lost",
	TextName = [[You unlocked "Essence of the Lost"]],
	gfx = "tarnished_achievement_essence_of_lost.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_LOST"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[1] = {
	DisplayName = "Linen Shroud",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Lost",
	TextName = [[You unlocked "Linen Shroud"]],
	gfx = "tarnished_achievement_linen_shroud.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("LINEN_SHROUD"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[3] = {
	DisplayName = "Dusty Chest",
	DisplayText = "Defeat Mega Satan as Tarnished Lost",
	TextName = [[You unlocked "Dusty Chest"]],
	gfx = "tarnished_achievement_dusty_chest.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DUSTY_CHEST"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[4] = {
	DisplayName = "Bottled Spirits",
	DisplayText = "Defeat Delirium as Tarnished Lost",
	TextName = [[You unlocked "Bottled Spirits"]],
	gfx = "tarnished_achievement_bottled_spirits.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BOTTLED_SPIRITS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[5] = {
	DisplayName = "Tarnished Lost",
	DisplayText = "Leave your holy card and beat the 1st boss, go back and put it back together playing as...",
	TextName = [[You unlocked "The Lost"]],
	gfx = "tarnished_achievement_character_lost.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("LOST"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[6] = {
	DisplayName = "Offering Card",
	DisplayText = "Defeat Ultra Greedier as Tarnished Lost",
	TextName = [[You unlocked "Offering Card"]],
	gfx = "tarnished_achievement_offering_card.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("OFFERING_CARD"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[7] = {
	DisplayName = "Lil' Guppy",
	DisplayText = "Defeat The Beast as Tarnished Lost",
	TextName = [[You unlocked "Lil' Guppy"]],
	gfx = "tarnished_achievement_lil_guppy.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("LIL_GUPPY"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[9] = {
	DisplayName = "Ectoplasm",
	DisplayText = "Defeat Mother as Tarnished Lost",
	TextName = [[You unlocked "Ectoplasm"]],
	gfx = "tarnished_achievement_ectoplasm.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ECTOPLASM"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_11_tarLost.grid[8] = {
	DisplayName = "Divine Remnants",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Lost",
	TextName = [[You unlocked "Divine Remnants"]],
	gfx = "tarnished_achievement_divine_remnants.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DIVINE_REMNANTS"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_11_tarLost