local ACL_EPI_7_tarSamson = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_7_tarSamson.Pname = "MOMENTUM"
ACL_EPI_7_tarSamson.Description = "Rage Consumes You..."
ACL_EPI_7_tarSamson.Counter = 0
ACL_EPI_7_tarSamson.dimX = 3
ACL_EPI_7_tarSamson.dimY = 3
ACL_EPI_7_tarSamson.size = 6
ACL_EPI_7_tarSamson.epiphany = true

ACL_EPI_7_tarSamson.isHidden = false

ACL_EPI_7_tarSamson.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_7_tarSamson.redo = true
ACL_EPI_7_tarSamson.Check = false

function ACL_EPI_7_tarSamson:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_7_tarSamson.Check = true
		
		ACL_EPI_7_tarSamson:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_7_tarSamson.Check == true then
		ACL_EPI_7_tarSamson.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_7_tarSamson.Revise)

ACL_EPI_7_tarSamson.grid = {}

function ACL_EPI_7_tarSamson:Redo()

if Epiphany then

	ACL_EPI_7_tarSamson.grid[2] = {
	DisplayName = "Essence of Samson",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Samson",
	TextName = [[You unlocked "Essence of Samson"]],
	gfx = "tarnished_achievement_essence_of_samson.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_SAMSON"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[1] = {
	DisplayName = "Savage Chains",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Samson",
	TextName = [[You unlocked "Savage Chains"]],
	gfx = "tarnished_achievement_savage_chains.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("SAVAGE_CHAINS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[3] = {
	DisplayName = "Pain-o-Matic",
	DisplayText = "Defeat Mega Satan as Tarnished Samson",
	TextName = [[You unlocked "Pain-o-Matic"]],
	gfx = "tarnished_achievement_pain_o_matic.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("PAIN_O_MATIC"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[4] = {
	DisplayName = "Crimson Bandana",
	DisplayText = "Defeat Delirium as Tarnished Samson",
	TextName = [[You unlocked "Crimson Bandana"]],
	gfx = "tarnished_achievement_crimson_bandana.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CRIMSON_BANDANA"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_7_tarSamson.grid[5] = {
	DisplayName = "Tarnished Samson",
	DisplayText = "Complete 3 challenge rooms holding Delilah's Razor as...",
	TextName = [[You unlocked "Samson"]],
	gfx = "tarnished_achievement_character_samson.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("SAMSON"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[6] = {
	DisplayName = "Reverse Cards",
	DisplayText = "Defeat Ultra Greedier as Tarnished Samson",
	TextName = [[You unlocked "Reverse Card and Reverse Card"]],
	gfx = "tarnished_achievement_reverse_cards.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("REVERSE_CARDS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[7] = {
	DisplayName = "Broken Pillar",
	DisplayText = "Defeat The Beast as Tarnished Samson",
	TextName = [[You unlocked "Broken Pillar"]],
	gfx = "tarnished_achievement_broken_pillar.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("BROKEN_PILLAR"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[9] = {
	DisplayName = "Killer Instinct",
	DisplayText = "Defeat Mother as Tarnished Samson",
	TextName = [[You unlocked "Killer Instinct"]],
	gfx = "tarnished_achievement_killer_instinct.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("KILLER_INSTINCT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_7_tarSamson.grid[8] = {
	DisplayName = "New Ropes",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Samson",
	TextName = [[You unlocked "New Ropes"]],
	gfx = "tarnished_achievement_ropes.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ROPES"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_7_tarSamson