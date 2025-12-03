local ACL_EPI_4_tarJudas = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_4_tarJudas.Pname = "ATTRITION"
ACL_EPI_4_tarJudas.Description = "There's No Remorse, Only Shadows..."
ACL_EPI_4_tarJudas.Counter = 0
ACL_EPI_4_tarJudas.dimX = 3
ACL_EPI_4_tarJudas.dimY = 3
ACL_EPI_4_tarJudas.size = 6
ACL_EPI_4_tarJudas.epiphany = true

ACL_EPI_4_tarJudas.isHidden = false

ACL_EPI_4_tarJudas.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_4_tarJudas.redo = true
ACL_EPI_4_tarJudas.Check = false

function ACL_EPI_4_tarJudas:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_4_tarJudas.Check = true
		
		ACL_EPI_4_tarJudas:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_4_tarJudas.Check == true then
		ACL_EPI_4_tarJudas.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_4_tarJudas.Revise)

ACL_EPI_4_tarJudas.grid = {}

function ACL_EPI_4_tarJudas:Redo()

if Epiphany then

	ACL_EPI_4_tarJudas.grid[2] = {
	DisplayName = "Essence of Judas",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Judas",
	TextName = [[You unlocked "Essence of Judas"]],
	gfx = "tarnished_achievement_essence_of_judas.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_JUDAS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[1] = {
	DisplayName = "Broken Halo",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Judas",
	TextName = [[You unlocked "Broken Halo"]],
	gfx = "tarnished_achievement_broken_halo.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BROKEN_HALO"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[3] = {
	DisplayName = "Twisted Rock",
	DisplayText = "Defeat Mega Satan as Tarnished Judas",
	TextName = [[You unlocked "Twisted Rock"]],
	gfx = "tarnished_achievement_twisted_rock.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("TWISTED_ROCK"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[4] = {
	DisplayName = "Old Knife",
	DisplayText = "Defeat Delirium as Tarnished Judas",
	TextName = [[You unlocked "Old Knife"]],
	gfx = "tarnished_achievement_old_knife.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("OLD_KNIFE"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_4_tarJudas.grid[5] = {
	DisplayName = "Tarnished Judas",
	DisplayText = "Defeat the first boss as Tainted Judas without using Dark Arts...",
	TextName = [[You unlocked "Judas"]],
	gfx = "tarnished_achievement_character_judas.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("JUDAS"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[6] = {
	DisplayName = "2 of Suits",
	DisplayText = "Defeat Ultra Greedier as Tarnished Judas",
	TextName = [[You unlocked "2 of Suits"]],
	gfx = "tarnished_achievement_house_2_of_suits.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("HOUSE_2_OF_SUITS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[7] = {
	DisplayName = "Kin's Curse",
	DisplayText = "Defeat The Beast as Tarnished Judas",
	TextName = [[You unlocked "Kin's Curse"]],
	gfx = "tarnished_achievement_kins_curse.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("KINS_CURSE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[9] = {
	DisplayName = "Hell's Eye",
	DisplayText = "Defeat Mother as Tarnished Judas",
	TextName = [[You unlocked "Hell's Eye"]],
	gfx = "tarnished_achievement_hells_eye.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("HELLS_EYE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_4_tarJudas.grid[8] = {
	DisplayName = "Descent",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Judas",
	TextName = [[You unlocked "Descent"]],
	gfx = "tarnished_achievement_descent.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DESCENT"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_4_tarJudas