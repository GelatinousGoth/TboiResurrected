local ACL_22_bosses2 = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")
local Check = false

ACL_22_bosses2.Pname = "THE MONSTERS II"
ACL_22_bosses2.Description = "Study them, understand them, defeat them."
ACL_22_bosses2.Counter = 0
ACL_22_bosses2.dimX = 5
ACL_22_bosses2.dimY = 6
ACL_22_bosses2.size = 3

ACL_22_bosses2.redo = true

ACL_22_bosses2.isHidden = false

ACL_22_bosses2.portrait = "bosses2" -- call your image for the portrait this!!!!


function ACL_22_bosses2:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		Check = true
		
		ACL_22_bosses2:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and Check == true then
		Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_22_bosses2.Revise)

ACL_22_bosses2.grid = {}




function ACL_22_bosses2:Redo()

	ACL_22_bosses2.grid[1] = {
DisplayName = "A Cube of Meat",
DisplayText = "Defeat Mom",
TextName = [["A Cube of Meat" has appeared in the basement]],
gfx = "Achievement_CubeOfMeat.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_CUBE_OF_MEAT,
Near = false,
Tile = Sprite()
}
---------------------------
ACL_22_bosses2.grid[2] = {
DisplayName = "7 Seals",
DisplayText = "Defeat all 5 Harbingers",
TextName = [["7 Seals" has appeared in the basement]],
gfx = "Achievement_7Seals.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SEVEN_SEALS,
Near = true,
Tile = Sprite()
}

ACL_22_bosses2.grid[3] = {
DisplayName = "A Quarter",
DisplayText = "Defeat Mom's Heart 8 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 8),
TextName = [["A Quarter" has appeared in the basement]],
gfx = "Achievement_AQuarter.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_QUARTER,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[4] = {
DisplayName = "Filigree Feather",
DisplayText = "Acquire both Key Pieces",
TextName = [["Filigree Feather" has appeared in the basement]],
gfx = "Achievement_FiligreeFeather.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FILIGREE_FEATHER,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[5] = {
DisplayName = "Everything is Terrible!!!",
DisplayText = "Defeat Mom's Heart 5 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 5),
TextName = [[Everything is Terrible!!! The game just got harder!]],
gfx = "Achievement_EverythingIsTerrible.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVERYTHING_IS_TERRIBLE,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[6] = {
DisplayName = "A Fetus in a Jar",
DisplayText = "Defeat Mom's Heart 9 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 9),
TextName = [["A Fetus in a Jar" has appeared in the basement]],
gfx = "Achievement_AFetusInAJar.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DR_FETUS,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[7] = {
DisplayName = "Something Icky!",
DisplayText = "Defeat Isaac 10 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.ISAAC_KILLS), 10),
TextName = [[You unlocked "Something Icky!" in the basement]],
gfx = "Achievement_Triachnid.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOMETHING_ICKY,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[8] = {
DisplayName = "Rubber Cement",
DisplayText = "Defeat Mom's Heart 2 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 2),
TextName = [["Rubber Cement" has appeared in the basement]],
gfx = "Achievement_RubberCement.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUBBER_CEMENT,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[9] = {
DisplayName = "Blue Womb",
DisplayText = "Defeat Mom's Heart 10 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10),
TextName = [[You unlocked the Blue Womb!]],
gfx = "Achievement_234_BlueWomb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_WOMB,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[10] = {
DisplayName = "Burning Basement",
DisplayText = "Defeat Mom's Heart 11 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 11),
TextName = [[The Basement is burning!]],
gfx = "Achievement_BurningBasement.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BURNING_BASEMENT,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[13] = {
DisplayName = "Something Wicked... Again!",
DisplayText = "Defeat ??? as 6 different Characters"..CountingNum:UniqueBlueBabyKills(6),
TextName = [[Something wicked this way comes+!]],
gfx = "Achievement_SomethingWicked+.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOMETHING_WICKED_PLUS,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[12] = {
DisplayName = "Flooded Caves",
DisplayText = "Defeat It Lives! 16 times"..CountingNum:GetCounter(DATA:GetBestiaryKillCount(EntityType.ENTITY_MOMS_HEART, 1), 16),
TextName = [[The Caves are flooded!]],
gfx = "Achievement_FloodedCaves.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FLOODED_CAVES,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[11] = {
DisplayName = "Dank Depths",
DisplayText = "Defeat It Lives! 21 times"..CountingNum:GetCounter(DATA:GetBestiaryKillCount(EntityType.ENTITY_MOMS_HEART, 1), 21),
TextName = [[The Depths are dank!]],
gfx = "Achievement_DankDepths.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DANK_DEPTHS,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[15] = {
DisplayName = "Scarred Womb",
DisplayText = "Defeat It Lives! 30 times"..CountingNum:GetCounter(DATA:GetBestiaryKillCount(EntityType.ENTITY_MOMS_HEART, 1), 30),
TextName = [[The Womb is scarred!]],
gfx = "Achievement_ScarredWomb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SCARRED_WOMB,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[14] = {
DisplayName = "The gate is open!",
DisplayText = "Defeat The Lamb",
TextName = [[The gate is open!]],
gfx = "Achievement_GateOpen.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_GATE_IS_OPEN,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[16] = {
DisplayName = "Once more with feeling!",
DisplayText = "Complete a Victory Lap, defeating The Lamb",
TextName = [[Once more with feeling!]],
gfx = "Achievement_PillGulp.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GULP_PILL,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[17] = {
DisplayName = "Mega Blast",
DisplayText = "Defeat Mega Satan as every character",
TextName = [["Mega Blast" has appeared in the basement]],
gfx = "Achievement_MegaBlast.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MEGA_BLAST,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[18] = {
DisplayName = "Delirious",
DisplayText = "Defeat Delirium",
TextName = [["Delirious" has appeared in the basement]],
gfx = "Achievement_Delirious.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DELIRIOUS,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[19] = {
DisplayName = "Angelic Prism",
DisplayText = "Defeat an Angel 10 times",
TextName = [["Angelic Prism" has appeared in the basement]],
gfx = "Achievement_AngelicPrism.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ANGELIC_PRISM,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[20] = {
DisplayName = "A Secret Exit",
DisplayText = "Defeat Hush 3 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.HUSH_KILLS), 3),
TextName = [[You unlocked "A Secret Exit"]],
gfx = "Achievement_SecretExit.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SECRET_EXIT,
Near = false,
Tile = Sprite()
}
--------------
ACL_22_bosses2.grid[21] = {
DisplayName = "Plum Flute",
DisplayText = "Let Baby Plum be",
TextName = [["Plum Flute" has appeared in the basement]],
gfx = "Achievement_PlumFlute.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.PLUM_FLUTE,
Near = false,
Tile = Sprite()
}
-------------------------
ACL_22_bosses2.grid[22] = {
DisplayName = "Head of Krampus",
DisplayText = "Defeat Krampus",
TextName = [["Head of Krampus" has appeared in the basement]],
gfx = "Achievement_HeadOfKrampus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HEAD_OF_KRAMPUS,
Near = false,
Tile = Sprite()
}
-------------------------
ACL_22_bosses2.grid[23] = {
DisplayName = "Brimstone Bombs",
DisplayText = "Kill Hornfel before he can escape",
TextName = [["Brimstone Bombs" has appeared in the basement]],
gfx = "Achievement_BrimstoneBombs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BRIMSTONE_BOMBS,
Near = false,
Tile = Sprite()
}
-----------------------
ACL_22_bosses2.grid[25] = {
DisplayName = "Dross",
DisplayText = "Defeat all bosses in Downpour",
TextName = [[You unlocked "Dross"]],
gfx = "Achievement_Dross.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DROSS,
Near = false,
Tile = Sprite()
}
---------------------------
ACL_22_bosses2.grid[26] = {
DisplayName = "Ashpit",
DisplayText = "Defeat all bosses in the Mines",
TextName = [[You unlocked "Ashpit"]],
gfx = "Achievement_Ashpit.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ASHPIT,
Near = false,
Tile = Sprite()
}
------------------
ACL_22_bosses2.grid[27] = {
DisplayName = "Gehenna",
DisplayText = "Defeat all bosses in the Mausoleum",
TextName = [[You unlocked "Gehenna"]],
gfx = "Achievement_Gehenna.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GEHENNA,
Near = false,
Tile = Sprite()
}
----------------
ACL_22_bosses2.grid[28] = {
DisplayName = "The Cellar",
DisplayText = "Beat all bosses from the Basement",
TextName = [[The Cellar]],
gfx = "Achievement_TheCellar.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_CELLAR,
Near = false,
Tile = Sprite()
}
-----------------------
ACL_22_bosses2.grid[29] = {
DisplayName = "The Catacombs",
DisplayText = "Beat all bosses from the Caves",
TextName = [[The Catacombs]],
gfx = "Achievement_TheCatacombs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_CATACOMBS,
Near = false,
Tile = Sprite()
}
---------------------
ACL_22_bosses2.grid[30] = {
DisplayName = "The Necropolis",
DisplayText = "Beat all bosses from the Depths",
TextName = [[The Necropolis]],
gfx = "Achievement_Necropolis.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_NECROPOLIS,
Near = false,
Tile = Sprite()
}

ACL_22_bosses2.grid[24] = {
DisplayName = "Experimental Treatment",
DisplayText = "Defeat Mom's Heart 7 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 7),
TextName = [["Experimental Treatment" has appeared in the basement]],
gfx = "Achievement_ExperimentalTreatment.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EXPERIMENTAL_TREATMENT,
Near = false,
Tile = Sprite()
}
	
end



return ACL_22_bosses2