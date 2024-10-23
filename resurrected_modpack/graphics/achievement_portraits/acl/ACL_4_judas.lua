local ACL_4_judas = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_4_judas.Pname = "JUDAS"
ACL_4_judas.Description = "Influenced by the dark lord... and 30 pieces of silver."
ACL_4_judas.Counter = 0
ACL_4_judas.dimX = 3
ACL_4_judas.dimY = 5
ACL_4_judas.size = 4

ACL_4_judas.isHidden = false

ACL_4_judas.portrait = "judas" --uses this to find image in ("resources/gfx/portrait/"..P.portrait..".png")


ACL_4_judas.grid = {}

ACL_4_judas.grid[1] = {
DisplayName = "Judas",
DisplayText = "Defeat Satan for the first time",
TextName = [[You unlocked "Judas"]],
gfx = "Achievement_Judas.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.JUDAS,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[2] = {
DisplayName = "Judas' Tongue",
DisplayText = "Defeat Satan as Judas",
TextName = [["Judas' Tongue" has appeared in the basement]],
gfx = "Achievement_JudasTongue.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[3] = {
DisplayName = "Guillotine", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Judas', --Name displayed in secrets menu
TextName = [["Guillotine" has appeared in the basement]],
gfx = "Achievement_Guillotine.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[4] = {
DisplayName = "Curved Horn",
DisplayText = 'Defeat The Lamb as Judas',
TextName = [["Curved Horn" has appeared in the basement]],
gfx = "Achievement_CurvedHorn.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[5] = { 
DisplayName = "The Left Hand",
DisplayText = "Defeat ??? as Judas or defeat Ultra Pride ",
TextName = [["The Left Hand" has appeared in the basement]],
gfx = "Achievement_TheLeftHand.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[6] = {
DisplayName = "Eye of Belial",
DisplayText = "Complete Greedier Mode as Judas",
TextName = [["Eye of Belial" has appeared in the basement]],
gfx = "Achievement_EyeOfBelial.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[7] = {
DisplayName = "Betrayal",
DisplayText = "Defeat Hush as Judas",
TextName = [["Betrayal" has appeared in the basement]],
gfx = "Achievement_182_Betrayal.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[8] = {
DisplayName = "Redemption",
DisplayText = "Defeat The Beast as Judas",
TextName = [["Redemption" has appeared in the basement]],
gfx = "Achievement_Redemption.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[9] = {
DisplayName = "Akeldama",
DisplayText = "Defeat Mother as Judas",
TextName = [["Akeldama" has appeared in the basement]],
gfx = "Achievement_Akeldama.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[10] = {
DisplayName = "Shade",
DisplayText = "Defeat Delirium as Judas",
TextName = [["Shade" has appeared in the basement]],
gfx = "Achievement_Shade.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[11] = {
DisplayName = "Shadow Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Judas (Hard Mode)",
TextName = [[You unlocked "Shadow Baby"]],
gfx = "Achievement_ShadowBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[12] = {
DisplayName = "Belial Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Judas",
TextName = [["Belial Baby" has appeared in the basement]],
gfx = "Achievement_263_BelialBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[13] = {
DisplayName = "Judas' Shadow",
DisplayText = 'Complete the Boss Rush as Judas', 
TextName = [["Judas' Shadow" has appeared in the basement]], 
gfx = "Achievement_JudasShadow.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[14] = {
DisplayName = "My Shadow",
DisplayText = "Complete Greed Mode as Judas",
TextName = [["My Shadow" has appeared in the basement]],
gfx = "Achievement_195_MyShadow.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_4_judas.grid[15] = {
DisplayName = "Brown Baby",
DisplayText = "Defeat Mega Satan as Judas",
TextName = [["Brown Baby" has appeared in the basement]],
gfx = "Achievement_208_BrownBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}


-- ADD A SPRITE VALUE TO EACH GRID DATA, AS WELL AS A VECTOR DATA.

return ACL_4_judas
