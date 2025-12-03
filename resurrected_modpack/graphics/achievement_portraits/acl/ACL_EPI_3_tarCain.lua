local ACL_EPI_3_tarCain = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_3_tarCain.Pname = "ISOLATION"
ACL_EPI_3_tarCain.Description = "To Isolate Yourself..."
ACL_EPI_3_tarCain.Counter = 0
ACL_EPI_3_tarCain.dimX = 3
ACL_EPI_3_tarCain.dimY = 3
ACL_EPI_3_tarCain.size = 6
ACL_EPI_3_tarCain.epiphany = true

ACL_EPI_3_tarCain.isHidden = false

ACL_EPI_3_tarCain.portrait = "cain" -- call your image for the portrait this!!!!

ACL_EPI_3_tarCain.redo = true
ACL_EPI_3_tarCain.Check = false

function ACL_EPI_3_tarCain:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_3_tarCain.Check = true
		
		ACL_EPI_3_tarCain:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_3_tarCain.Check == true then
		ACL_EPI_3_tarCain.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_3_tarCain.Revise)

ACL_EPI_3_tarCain.grid = {}

function ACL_EPI_3_tarCain:Redo()

if Epiphany then

	ACL_EPI_3_tarCain.grid[2] = {
	DisplayName = "Essence of Cain",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Cain",
	TextName = [[You unlocked "Essence of Cain"]],
	gfx = "tarnished_achievement_essence_of_magdalene.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_CAIN"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[1] = {
	DisplayName = "Final Wishes",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Cain",
	TextName = [[You unlocked "Final Wishes"]],
	gfx = "tarnished_achievement_final_wishes.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("FINAL_WISHES"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[3] = {
	DisplayName = "Multitool",
	DisplayText = "Defeat Mega Satan as Tarnished Cain",
	TextName = [[You unlocked "Multitool"]],
	gfx = "tarnished_achievement_multitool.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MULTITOOL"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[4] = {
	DisplayName = "Dimensional Key",
	DisplayText = "Defeat Delirium as Tarnished Cain",
	TextName = [[You unlocked "Dimensional Key"]],
	gfx = "tarnished_achievement_dimensional_key.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("DIMENSIONAL_KEY"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_3_tarCain.grid[5] = {
	DisplayName = "Tarnished Cain",
	DisplayText = "Obtain the sharp rock by the 1st floor, gather some wheat to sacrifice as...",
	TextName = [[You unlocked "Cain"]],
	gfx = "tarnished_achievement_character_cain.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CAIN"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[6] = {
	DisplayName = "Go To Jail Card",
	DisplayText = "Defeat Ultra Greedier as Tarnished Cain",
	TextName = [[You unlocked "Go To Jail Card"]],
	gfx = "tarnished_achievement_go_to_jail.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("GO_TO_JAIL"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[7] = {
	DisplayName = "Warm Coat",
	DisplayText = "Defeat The Beast as Tarnished Cain",
	TextName = [[You unlocked "Warm Coat"]],
	gfx = "tarnished_achievement_warm_coat.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("WARM_COAT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[9] = {
	DisplayName = "Surprise Box",
	DisplayText = "Defeat Mother as Tarnished Cain",
	TextName = [[You unlocked "Surprise Box"]],
	gfx = "tarnished_achievement_surprise_box.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("SURPRISE_BOX"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_3_tarCain.grid[8] = {
	DisplayName = "Throwing Bag",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Cain",
	TextName = [[You unlocked "Throwing Bag"]],
	gfx = "tarnished_achievement_throwing_bag.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("THROWING_BAG"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_3_tarCain