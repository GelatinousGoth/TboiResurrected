local ACL_EPI_5_tarBlueB = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_5_tarBlueB.Pname = "FARRAGO"
ACL_EPI_5_tarBlueB.Description = "Become empty, drain yourself..."
ACL_EPI_5_tarBlueB.Counter = 0
ACL_EPI_5_tarBlueB.dimX = 3
ACL_EPI_5_tarBlueB.dimY = 3
ACL_EPI_5_tarBlueB.size = 6
ACL_EPI_5_tarBlueB.epiphany = true

ACL_EPI_5_tarBlueB.isHidden = false

ACL_EPI_5_tarBlueB.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_5_tarBlueB.redo = true
ACL_EPI_5_tarBlueB.Check = false

function ACL_EPI_5_tarBlueB:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_5_tarBlueB.Check = true
		
		ACL_EPI_5_tarBlueB:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_5_tarBlueB.Check == true then
		ACL_EPI_5_tarBlueB.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_5_tarBlueB.Revise)

ACL_EPI_5_tarBlueB.grid = {}

function ACL_EPI_5_tarBlueB:Redo()

if Epiphany then

	ACL_EPI_5_tarBlueB.grid[2] = {
	DisplayName = "Essence of ???",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished ???",
	TextName = [[You unlocked "Essence of ???"]],
	gfx = "tarnished_achievement_essence_of_bluebaby.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_BLUEBABY"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[1] = {
	DisplayName = "Rotten Core",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished ???",
	TextName = [[You unlocked "Rotten Core"]],
	gfx = "tarnished_achievement_rotten_core.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ROTTEN_CORE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[3] = {
	DisplayName = "Soiled Keepers",
	DisplayText = "Defeat Mega Satan as Tarnished ???",
	TextName = [[You unlocked "Soiled Keepers"]],
	gfx = "tarnished_achievement_soiled_keeper.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("SOILED_KEEPER"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[4] = {
	DisplayName = "Cardboard Cutout",
	DisplayText = "Defeat Delirium as Tarnished ???",
	TextName = [[You unlocked "Cardboard Cutout"]],
	gfx = "tarnished_achievement_cardboard_cutout.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CARDBOARD_CUTOUT"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_5_tarBlueB.grid[5] = {
	DisplayName = "Tarnished ???",
	DisplayText = "Reach ??? with Shred while playing as...",
	TextName = [[You unlocked "???"]],
	gfx = "tarnished_achievement_character_bluebaby.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BLUEBABY"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[6] = {
	DisplayName = "Card Against Humanity",
	DisplayText = "Defeat Ultra Greedier as Tarnished ???",
	TextName = [[You unlocked "Card Against Humanity"]],
	gfx = "tarnished_achievement_card_against_humanity.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CARD_AGAINST_HUMANITY"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[7] = {
	DisplayName = "Anal Fissure",
	DisplayText = "Defeat The Beast as Tarnished ???",
	TextName = [[You unlocked "Anal Fissure"]],
	gfx = "tarnished_achievement_anal_fissure.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ANAL_FISSURE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[9] = {
	DisplayName = "IED",
	DisplayText = "Defeat Mother as Tarnished ???",
	TextName = [[You unlocked "IED"]],
	gfx = "tarnished_achievement_ied.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("IED"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_5_tarBlueB.grid[8] = {
	DisplayName = "MIX",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished ???",
	TextName = [[You unlocked "MIX"]],
	gfx = "tarnished_achievement_killer_instinct.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MIX"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_5_tarBlueB