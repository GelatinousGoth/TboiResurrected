local ACL_34_item2 = {}

local DATA = Isaac.GetPersistentGameData()
local CountingNum = require("resurrected_modpack.graphics.achievement_portraits.acl.ACLcounter")

--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)

ACL_34_item2.Pname = "MY STUFF II"
ACL_34_item2.Description = "Finders keepers."
ACL_34_item2.Counter = 0
ACL_34_item2.dimX = 4
ACL_34_item2.dimY = 3
ACL_34_item2.size = 4

ACL_34_item2.isHidden = false

ACL_34_item2.portrait = "item2" -- call your image for the portrait this!!!!

ACL_34_item2.grid = {}

ACL_34_item2.redo = true
ACL_34_item2.Check = false

function ACL_34_item2:Revise()
	if MenuManager.GetActiveMenu() == MainMenuType.GAME then
	
		ACL_34_item2.Check = true
		
		ACL_34_item2:Redo()
	
	end
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and ACL_34_item2.Check == true then
		ACL_34_item2.Check = false
	end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACL_34_item2.Revise)

function ACL_34_item2:Redo()

ACL_34_item2.grid[1] = {
DisplayName = "Jumper Cables",
DisplayText = "Pick up two battery items in a single run",
TextName = [["Jumper Cables" has appeared in the basement]],
gfx = "Achievement_JumperCables.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.JUMPER_CABLES,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[2] = {
DisplayName = "Technology Zero",
DisplayText = "Pick up two technology items in a single run",
TextName = [["Technology Zero" has appeared in the basement]],
gfx = "Achievement_TechnologyZero.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TECHNOLOGY_ZERO,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[3] = {
DisplayName = "Haemolacria",
DisplayText = "Acquire Blood Clot 10 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.BLOOD_CLOT_ITEM_AQUIRED), 10),
TextName = [["Haemolacria" has appeared in the basement]],
gfx = "Achievement_Haemolacria.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HAEMOLACHRIA,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[4] = {
DisplayName = "Lachryphagy",
DisplayText = "Collect 10 Tears Up items or pills in one run",
TextName = [["Lachryphagy" has appeared in the basement]],
gfx = "Achievement_Lachryphagy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LACHRYPHAGY,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[5] = {
DisplayName = "Extension Cord",
DisplayText = "Have The Battery, 9 Volt, and Car Battery",
TextName = [["Extension Cord" has appeared in the basement]],
gfx = "Achievement_ExtensionCord.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EXTENSION_CORD,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[6] = {
DisplayName = "Flat Stone",
DisplayText = "Acquire Rubber Cement 5 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.RUBBER_CEMENT_ITEM_AQUIRED), 5),
TextName = [["Flat Stone" has appeared in the basement]],
gfx = "Achievement_FlatStone.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FLAT_STONE,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[7] = {
DisplayName = "Marbles",
DisplayText = "Use 5 Gulp! pills in one run",
TextName = [["Marbles" has appeared in the basement]],
gfx = "Achievement_Marbles.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MARBLES,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[8] = {
DisplayName = "Baby-Bender",
DisplayText = "Use The Magician or Telepathy For Dummies while having homing tears",
TextName = [["Baby-Bender" has appeared in the basement]],
gfx = "Achievement_BabyBender.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BABY_BENDER,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[9] = {
DisplayName = "Lucky Toe!",
DisplayText = "Blow up 20 Shopkeepers"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.SHOPKEEPER_KILLED), 20),
TextName = [["Lucky Toe!" has appeared in the basement]],
gfx = "Achievement_LuckyToe.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LUCKY_TOE,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[10] = {
DisplayName = "The Necronomicon",
DisplayText = "Use XIII - Death 4 times"..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.XIII_DEATH_CARD_USED), 4),
TextName = [["The Necronomicon" has appeared in the basement]],
gfx = "Achievement_Necronomicon.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_NECRONOMICON,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[11] = {
DisplayName = "Bone Heart",
DisplayText = "Use that shovel responsibly...",
TextName = [["Bone Heart" has appeared in the basement]],
gfx = "Achievement_BoneHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BONE_HEARTS,
Near = false,
Tile = Sprite()
}

ACL_34_item2.grid[12] = {
DisplayName = "Blinding Baby",
DisplayText = "Use Blank Card while holding XIX - The Sun",
TextName = [["Blinding Baby" has appeared in the basement]],
gfx = "Achievement_258_BlindingBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLINDING_BABY,
Near = false,
Tile = Sprite()
}

end

return ACL_34_item2