local ACL_9_lazarus = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_9_lazarus.Pname = "LAZARUS"
ACL_9_lazarus.Description = "Righteous Lazarus, the Four-Days Dead"
ACL_9_lazarus.Counter = 0
ACL_9_lazarus.dimX = 3
ACL_9_lazarus.dimY = 5
ACL_9_lazarus.size = 4

ACL_9_lazarus.isHidden = false

ACL_9_lazarus.portrait = "lazarus" -- call your image for the portrait this!!!!


ACL_9_lazarus.grid = {}

ACL_9_lazarus.grid[1] = {
DisplayName = "Lazarus",
DisplayText = "Have 4 or more Soul Hearts at one time",
TextName = [[You unlocked "Lazarus"]],
gfx = "Achievement_Lazarus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LAZARUS,
Near = true,
Tile = Sprite()
}

ACL_9_lazarus.grid[2] = {
DisplayName = "Broken Ankh",
DisplayText = "Defeat Satan as Lazarus",
TextName = [["Broken Ankh" has appeared in the basement]],
gfx = "Achievement_BrokenAnkh.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BROKEN_ANKH,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[3] = {
DisplayName = "Lazarus' Rags", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as Lazarus', --Name displayed in secrets menu
TextName = [["Lazarus' Rags" has appeared in the basement]],
gfx = "Achievement_LazarusRags.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LAZARUS_RAGS,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[4] = {
DisplayName = "Pandora's Box",
DisplayText = 'Defeat The Lamb as Lazarus',
TextName = [["Pandora's Box" has appeared in the basement]],
gfx = "Achievement_PandorasBox.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.PANDORAS_BOX,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[5] = { 
DisplayName = "Store Credit",
DisplayText = "Defeat ??? as Lazarus",
TextName = [["Store Credit" has appeared in the basement]],
gfx = "Achievement_StoreCredit.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_CREDIT,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[6] = {
DisplayName = "Long Baby",
DisplayText = "Defeat Mega Satan as Lazarus",
TextName = [["Long Baby" has appeared in the basement]],
gfx = "Achievement_213_LongBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LONG_BABY,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[7] = {
DisplayName = "Empty Vessel",
DisplayText = "Defeat Hush as Lazarus",
TextName = [["Empty Vessel" has appeared in the basement]],
gfx = "Achievement_187_EmptyVessel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EMPTY_VESSEL,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[8] = {
DisplayName = "Compound Fracture",
DisplayText = "Defeat Delirium as Lazarus",
TextName = [["Compound Fracture" has appeared in the basement]],
gfx = "Achievement_CompoundFracture.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.COMPOUND_FRACTURE,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[9] = {
DisplayName = "Tinytoma",
DisplayText = "Defeat Mother as Lazarus",
TextName = [["Tinytoma" has appeared in the basement]],
gfx = "Achievement_Tinytoma.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TINYTOMA,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[10] = {
DisplayName = "Astral Projection",
DisplayText = "Defeat The Beast as Lazarus",
TextName = [["Astral Projection" has appeared in the basement]],
gfx = "Achievement_AstralProjection.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ASTRAL_PROJECTION,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[11] = {
DisplayName = "Wrapped Baby",
DisplayText = "Defeat Mom's Heart or It Lives! as Lazarus (Hard Mode)",
TextName = [[You unlocked "Wrapped Baby"]],
gfx = "Achievement_WrappedBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WRAPPED_BABY,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[12] = {
DisplayName = "Dripping Baby",
DisplayText = "Get all Completion Marks in Hard Mode as Lazarus",
TextName = [["Dripping Baby" has appeared in the basement]],
gfx = "Achievement_257_DrippingBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DRIPPING_BABY,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[13] = {
DisplayName = "Missing No.",
DisplayText = 'Complete the Boss Rush as Lazarus', 
TextName = [["Missing No." has appeared in the basement]], 
gfx = "Achievement_MissingNo.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MISSING_NO,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[14] = {
DisplayName = "Key Bum",
DisplayText = "Complete Greed Mode as Lazarus",
TextName = [["Key Bum" has appeared in the basement]],
gfx = "Achievement_200_KeyBum.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KEY_BUM,
Near = false,
Tile = Sprite()
}

ACL_9_lazarus.grid[15] = {
DisplayName = "Plan C",
DisplayText = "Complete Greedier Mode as Lazarus",
TextName = [["Plan C" has appeared in the basement]],
gfx = "Achievement_PlanC.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.PLAN_C,
Near = false,
Tile = Sprite()
}

return ACL_9_lazarus



