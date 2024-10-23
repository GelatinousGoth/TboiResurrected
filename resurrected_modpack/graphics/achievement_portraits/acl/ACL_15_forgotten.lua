local ACL_15_forgotten = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_15_forgotten.Pname = "THE FORGOTTEN"
ACL_15_forgotten.Description = "A terrible fate to outlast his life."
ACL_15_forgotten.Counter = 0
ACL_15_forgotten.dimX = 3
ACL_15_forgotten.dimY = 5
ACL_15_forgotten.size = 4

ACL_15_forgotten.isHidden = false

ACL_15_forgotten.portrait = "forgotten" -- call your image for the portrait this!!!!


ACL_15_forgotten.grid = {}

ACL_15_forgotten.grid[1] = {
DisplayName = "The Forgotten",
DisplayText = "Find the Shovel...",
TextName = [[You unlocked "The Forgotten"]],
gfx = "Achievement_TheForgotten.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_FORGOTTEN,
Near = true,
Tile = Sprite()
}

ACL_15_forgotten.grid[2] = {
DisplayName = "Pointy Rib",
DisplayText = "Defeat Satan as The Forgotten",
TextName = [["Pointy Rib" has appeared in the basement]],
gfx = "Achievement_PointyRib.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.POINTY_RIB,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[3] = {
DisplayName = "Slipped Rib", --Name displayed in secrets menu
DisplayText = 'Defeat Isaac as The Forgotten', --Name displayed in secrets menu
TextName = [["Slipped Rib" has appeared in the basement]],
gfx = "Achievement_SlippedRib.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SLIPPED_RIB,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[4] = {
DisplayName = "Brittle Bones",
DisplayText = 'Defeat The Lamb as The Forgotten',
TextName = [["Brittle Bones" has appeared in the basement]],
gfx = "Achievement_BrittleBones.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BRITTLE_BONES,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[5] = { 
DisplayName = "Jaw Bone",
DisplayText = "Defeat ??? as The Forgotten",
TextName = [["Jaw Bone" has appeared in the basement]],
gfx = "Achievement_JawBone.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.JAW_BONE,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[6] = {
DisplayName = "Bound Baby",
DisplayText = "Defeat Mega Satan as The Forgotten",
TextName = [["Bound Baby" has appeared in the basement]],
gfx = "Achievement_BoundBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOUND_BABY,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[7] = {
DisplayName = "Hallowed Ground",
DisplayText = "Defeat Hush as The Forgotten",
TextName = [["Hallowed Ground" has appeared in the basement]],
gfx = "Achievement_HallowedGround.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HALLOWED_GROUND,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[8] = {
DisplayName = "Book of the Dead",
DisplayText = "Defeat Delirium as The Forgotten",
TextName = [["Book of the Dead" has appeared in the basement]],
gfx = "Achievement_BookOfTheDead.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOOK_OF_THE_DEAD,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[9] = {
DisplayName = "Bone Spurs",
DisplayText = "Defeat Mother as The Forgotten",
TextName = [["Bone Spurs" has appeared in the basement]],
gfx = "Achievement_BoneSpurs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BONE_SPURS,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[10] = {
DisplayName = "Spirit Shackles",
DisplayText = "Defeat The Beast as The Forgotten",
TextName = [["Spirit Shackles" has appeared in the basement]],
gfx = "Achievement_SpiritShackles.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SPIRIT_SHACKLES,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[11] = {
DisplayName = "Marrow",
DisplayText = "Defeat Mom's Heart or It Lives! as The Forgotten (Hard Mode)",
TextName = [["Marrow" has appeared in the basement]],
gfx = "Achievement_Marrow.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MARROW,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[12] = {
DisplayName = "Bone Baby",
DisplayText = "Get all Completion Marks in Hard Mode as The Forgotten",
TextName = [["Bone Baby" has appeared in the basement]],
gfx = "Achievement_BoneBaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BONE_BABY,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[13] = {
DisplayName = "Divorce Papers",
DisplayText = 'Complete the Boss Rush as The Forgotten', 
TextName = [["Divorce Papers" has appeared in the basement]], 
gfx = "Achievement_DivorcePapers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DIVORCE_PAPERS,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[14] = {
DisplayName = "Finger Bone",
DisplayText = "Complete Greed Mode as The Forgotten",
TextName = [["Finger Bone" has appeared in the basement]],
gfx = "Achievement_FingerBone.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FINGER_BONE,
Near = false,
Tile = Sprite()
}

ACL_15_forgotten.grid[15] = {
DisplayName = "Dad's Ring",
DisplayText = "Complete Greedier Mode as The Forgotten",
TextName = [["Dad's Ring" has appeared in the basementt]],
gfx = "Achievement_DadsRing.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DADS_RING,
Near = false,
Tile = Sprite()
}

return ACL_15_forgotten



