local ACL_16_bethany = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_16_bethany.Pname = "BETHANY"
ACL_16_bethany.Description = "The woman that spilled tears and fragance."
ACL_16_bethany.Counter = 0
ACL_16_bethany.dimX = 3
ACL_16_bethany.dimY = 5
ACL_16_bethany.size = 4

ACL_16_bethany.isHidden = false

ACL_16_bethany.portrait = "bethany" -- call your image for the portrait this!!!!


ACL_16_bethany.grid = {}

ACL_16_bethany.grid[1] = {
DisplayName = "Bethany",
DisplayText = "Beat Hard mode as Lazarus without losing a life",
TextName = [[You unlocked "Bethany"]],
gfx = "Achievement_Bethany.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BETHANY,
Near = true,
Tile = Sprite()
}

ACL_16_bethany.grid[2] = {
DisplayName = "Urn of Souls",
DisplayText = "Defeat Satan as Bethany",
TextName = [["Urn of Souls" has appeared in the basement]],
gfx = "Achievement_UrnOfSouls.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.URN_OF_SOULS,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[3] = {
DisplayName = "Book of Virtues", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Bethany', --Name displayed in secrets menu
TextName = [["Book of Virtues" has appeared in the basement]],
gfx = "Achievement_BookOfVirtues.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOOK_OF_VIRTUES,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[4] = {
DisplayName = "Alabaster Box",
DisplayText = 'Defeat The Lamb as Bethany',
TextName = [["Alabaster Box" has appeared in the basement]],
gfx = "Achievement_AlabasterBox.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ALABASTER_BOX,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[5] = { 
DisplayName = "Blessed Penny",
DisplayText = "Defeat ??? as Bethany",
TextName = [["Blessed Penny" has appeared in the basement]],
gfx = "Achievement_BlessedPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLESSED_PENNY,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[6] = {
DisplayName = "Glowing Baby",
DisplayText = "Defeat Mega Satan as Bethany",
TextName = [[You unlocked "Glowing Baby"]],
gfx = "Achievement_GlowingBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GLOWING_BABY,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[7] = {
DisplayName = "Divine Intervention",
DisplayText = "Defeat Hush as Bethany",
TextName = [["Divine Intervention" has appeared in the basement]],
gfx = "Achievement_DivineIntervention.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DIVINE_INTERVENTION,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[8] = {
DisplayName = "Star of Bethlehem",
DisplayText = "Defeat Delirium as Bethany",
TextName = [["Star of Bethlehem" has appeared in the basement]],
gfx = "Achievement_StarOfBethlehem.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STAR_OF_BETHLEHEM,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[9] = {
DisplayName = "Jar of Wisps",
DisplayText = "Defeat The Beast as Bethany",
TextName = [["Jar of Wisps" has appeared in the basement]],
gfx = "Achievement_JarOfWisps.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.JAR_OF_WISPS,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[10] = {
DisplayName = "Revelation",
DisplayText = "Defeat Mother as Bethany",
TextName = [["Revelation" has appeared in the basement]],
gfx = "Achievement_Revelation.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVELATION,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[11] = {
DisplayName = "Wisp Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Bethany (Hard Mode)",
TextName = [[You unlocked "Wisp Baby"]],
gfx = "Achievement_WispBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WISP_BABY,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[12] = {
DisplayName = "Hope Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Bethany",
TextName = [[You unlocked "Hope Baby"]],
gfx = "Achievement_HopeBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HOPE_BABY,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[13] = {
DisplayName = "Beth's Faith",
DisplayText = 'Complete the Boss Rush as Bethany', 
TextName = [["Beth's Faith" has appeared in the basement]], 
gfx = "Achievement_BethsFaith.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BETHS_FAITH,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[14] = {
DisplayName = "Soul Locket",
DisplayText = "Complete Greed Mode as Bethany",
TextName = [["Soul Locket" has appeared in the basement]],
gfx = "Achievement_SoulLocket.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOUL_LOCKET,
Near = false,
Tile = Sprite()
}

ACL_16_bethany.grid[15] = {
DisplayName = "Vade Retro",
DisplayText = "Complete Greedier Mode as Bethany",
TextName = [["Vade Retro" has appeared in the basementt]],
gfx = "Achievement_VadeRetro.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.VADE_RETRO,
Near = false,
Tile = Sprite()
}

return ACL_16_bethany



