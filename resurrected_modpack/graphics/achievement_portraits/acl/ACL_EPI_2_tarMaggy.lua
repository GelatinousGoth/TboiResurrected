local ACL_EPI_2_tarMaggy = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

ACL_EPI_2_tarMaggy.Pname = "FERVENCY"
ACL_EPI_2_tarMaggy.Description = "The Intensity of Love..."
ACL_EPI_2_tarMaggy.Counter = 0
ACL_EPI_2_tarMaggy.dimX = 3
ACL_EPI_2_tarMaggy.dimY = 3
ACL_EPI_2_tarMaggy.size = 6
ACL_EPI_2_tarMaggy.epiphany = true

ACL_EPI_2_tarMaggy.isHidden = false

ACL_EPI_2_tarMaggy.portrait = "tarMaggy" -- call your image for the portrait this!!!!

ACL_EPI_2_tarMaggy.redo = true
ACL_EPI_2_tarMaggy.Check = false

function ACL_EPI_2_tarMaggy:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_EPI_2_tarMaggy.Check = true
		
		ACL_EPI_2_tarMaggy:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_EPI_2_tarMaggy.Check == true then
		ACL_EPI_2_tarMaggy.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_EPI_2_tarMaggy.Revise)

ACL_EPI_2_tarMaggy.grid = {}

function ACL_EPI_2_tarMaggy:Redo()

if Epiphany then

	ACL_EPI_2_tarMaggy.grid[2] = {
	DisplayName = "Essence of Magdalene",
	DisplayText = "Defeat Hush and Boss Rush as Tarnished Magdalene",
	TextName = [[You unlocked "Essence of Magdalene"]],
	gfx = "tarnished_achievement_essence_of_magdalene.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("ESSENCE_OF_MAGDALENE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[1] = {
	DisplayName = "True Love",
	DisplayText = "Defeat Isaac, ???, Satan, and The Lamb as Tarnished Magdalene",
	TextName = [[You unlocked "True Love"]],
	gfx = "tarnished_achievement_true_love.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("TRUE_LOVE"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[3] = {
	DisplayName = "Coverted Beggar",
	DisplayText = "Defeat Mega Satan as Tarnished Magdalene",
	TextName = [[You unlocked "Coverted Beggar"]],
	gfx = "tarnished_achievement_converter_beggar.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CONVERTER_BEGGAR"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[4] = {
	DisplayName = "Weird Heart",
	DisplayText = "Defeat Delirium as Tarnished Magdalene",
	TextName = [[You unlocked "Weird Heart"]],
	gfx = "tarnished_achievement_weird_heart.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("WEIRD_HEART"),
	Near = false,
	Tile = Sprite()
	}
	--local CountingNum = require("ACLcounter")
	--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
	ACL_EPI_2_tarMaggy.grid[5] = {
	DisplayName = "Tarnished Magdalene",
	DisplayText = "Beat chapter 4 with Bleeding Heart as Tainted...",
	TextName = [[You unlocked "Magdalene"]],
	gfx = "tarnished_achievement_character_magdalene.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MAGDALENE"),
	Near = true,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[6] = {
	DisplayName = "Queen of Hearts",
	DisplayText = "Defeat Ultra Greedier as Tarnished Magdalene",
	TextName = [[You unlocked "Queen of Hearts"]],
	gfx = "tarnished_achievement_house_queen_of_hearts.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("HOUSE_QUEEN_OF_HEARTS"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[7] = {
	DisplayName = "Warm Coat",
	DisplayText = "Defeat The Beast as Tarnished Magdalene",
	TextName = [[You unlocked "Warm Coat"]],
	gfx = "tarnished_achievement_warm_coat.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("WARM_COAT"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[9] = {
	DisplayName = "Mom's Grief",
	DisplayText = "Defeat Mother as Tarnished Magdalene",
	TextName = [[You unlocked "Mom's Grief"]],
	gfx = "tarnished_achievement_moms_grief.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("MOMS_GRIEF"),
	Near = false,
	Tile = Sprite()
	}

	ACL_EPI_2_tarMaggy.grid[8] = {
	DisplayName = "Cardiac Arrest",
	DisplayText = "Obtain all Hard Mode Completion Marks as Tarnished Magdalene",
	TextName = [[You unlocked "Cardiac Arrest"]],
	gfx = "tarnished_achievement_cardiac_arrest.png",
	Unlocked = false,
	PosY = 0,
	PosX = 0,
	Enum = Isaac.GetAchievementIdByName("CARDIAC_ARREST"),
	Near = false,
	Tile = Sprite()
	}
end

end

return ACL_EPI_2_tarMaggy