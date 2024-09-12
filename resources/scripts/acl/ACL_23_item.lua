local ACL_23_item = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_23_item.Pname = "MY STUFF I"
ACL_23_item.Description = "Why's all of this here?"
ACL_23_item.Counter = 0
ACL_23_item.dimX = 3
ACL_23_item.dimY = 5
ACL_23_item.size = 4

ACL_23_item.isHidden = false

ACL_23_item.portrait = "item" -- call your image for the portrait this!!!!


ACL_23_item.grid = {}

ACL_23_item.grid[1] = {
DisplayName = "The Planetarium",
DisplayText = "Collect 3 star related items in a single run",
TextName = [[The stars are calling...]],
gfx = "Achievement_Planetarium.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_STARS_ARE_CALLING,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[2] = {
DisplayName = "A Bandage",
DisplayText = "Make a Super Bandage Girl",
TextName = [["A Bandage" has appeared in the basement]],
gfx = "Achievement_SuperBandageGirl.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_BANDAGE,
Near = true,
Tile = Sprite()
}

ACL_23_item.grid[3] = {
DisplayName = "The Parasite",
DisplayText = 'Collect two "dead" items in a single run',
TextName = [["The Parasite" has appeared in the basement]],
gfx = "Achievement_TheParasite.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_PARASITE,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[4] = {
DisplayName = "Mom's Contact",
DisplayText = "Obtain three Mother items in one run",
TextName = [["Mom's Contact" has appeared in the basement]],
gfx = "Achievement_MomsContact.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MOMS_CONTACT,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[5] = {
DisplayName = "Huge Growth",
DisplayText = "Increase in size 5 times in a single run",
TextName = [["Huge Growth" has appeared in the basement]],
gfx = "Achievement_HugeGrowth.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HUGE_GROWTH,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[6] = {
DisplayName = "Guppy's Hairball",
DisplayText = "Become Guppy",
TextName = [["Guppy's Hairball" has appeared in the basement]],
gfx = "Achievement_GuppysHairball.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.COUNTERFEIT_PENNY,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[7] = {
DisplayName = "Super Meat Boy",
DisplayText = "Make a Super Meat Boy",
TextName = [[You made a Super Meat Boy]],
gfx = "Achievement_SuperMeatBoy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUPER_MEAT_BOY,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[8] = {
DisplayName = "Little Baggy",
DisplayText = "Pick up two syringes in a single run",
TextName = [["Little Baggy" has appeared in the basement]],
gfx = "Achievement_LittleBaggy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LITTLE_BAGGY,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[9] = {
DisplayName = "Lord of the Flies",
DisplayText = "Grab three fly items in one run",
TextName = [[You became Lord of the Flies]],
gfx = "Achievement_LordOfTheFlies.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BECAME_LORD_OF_THE_FLIES,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[10] = {
DisplayName = "U broke it!",
DisplayText = "Obtain 50 items in a run",
TextName = [[U broke it!]],
gfx = "Achievement_PillVurp.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.U_BROKE_IT,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[13] = {
DisplayName = "Angry Fly",
DisplayText = "Become Beelzebub",
TextName = [["Angry Fly" has appeared in the basement]],
gfx = "Achievement_AngryFly.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ANGRY_FLY,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[12] = {
DisplayName = "Buddy in a Box",
DisplayText = "Pick up 5 familiars in a single run",
TextName = [["Buddy in a Box" has appeared in the basement]],
gfx = "Achievement_BuddyInABox.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BUDDY_IN_A_BOX,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[11] = {
DisplayName = "Hairpin",
DisplayText = "Recharge using Lil' Batteries 20 times",
TextName = [["Hairpin" has appeared in the basement]],
gfx = "Achievement_Hairpin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HAIRPIN,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[15] = {
DisplayName = "Ancient Recall",
DisplayText = "Use Cards and Runes 20 times",
TextName = [["Ancient Recall" has appeared in the basement]],
gfx = "Achievement_AncientRecall.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ANCIENT_RECALL,
Near = false,
Tile = Sprite()
}

ACL_23_item.grid[14] = {
DisplayName = "Era Walk",
DisplayText = "Add both the Broken Watch and Stop Watch to your collection",
TextName = [["Era Walk" has appeared in the basement]],
gfx = "Achievement_EraWalk.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ERA_WALK,
Near = false,
Tile = Sprite()
}



return ACL_23_item