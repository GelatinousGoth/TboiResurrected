local ACL_35_god = {}

local DATA = Isaac.GetPersistentGameData()


ACL_35_god.Pname = "I AM..."
ACL_35_god.Description = "Above devils and angels, you'll surpass them all!"
ACL_35_god.Counter = 0
ACL_35_god.dimX = 3
ACL_35_god.dimY = 3
ACL_35_god.size = 6

ACL_35_god.isHidden = false

ACL_35_god.portrait = "god" -- call your image for the portrait this!!!!

ACL_35_god.grid = {}



ACL_35_god.grid[1] = {
DisplayName = "Sin collector",
DisplayText = "Collect every entry in the Bestiary",
TextName = [[Sin collector]],
gfx = "Achievement_PillSunshine.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[2] = {
DisplayName = "Mega Mush",
DisplayText = "Earn all Hard mode Completion Marks for normal characters",
TextName = [["Mega Mush" has appeared in the basement]],
gfx = "Achievement_MegaMush.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[3] = {
DisplayName = "Death Certificate",
DisplayText = "Earn all Hard mode Completion Marks. Normal and Tainted",
TextName = [["Death Certificate" has appeared in the basement]],
gfx = "Achievement_DeathCertificate.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[4] = {
DisplayName = "1001%",
DisplayText = "Unlock 276 Secrets",
TextName = [[1001% (Nerd x 1000000)]],
gfx = "Achievement_235_1000Percent.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[5] = {
DisplayName = "Dead God",
DisplayText = "Unlock all secrets and items in the game",
TextName = [[]],
gfx = "Achievement_DeadGod.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEAD_GOD,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[6] = {
DisplayName = "1000000%",
DisplayText = "Unlock 339 Secrets",
TextName = [[1000000% Just Stop!]],
gfx = "Achievement_1000000Percent.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[7] = {
DisplayName = "!Platinum God!",
DisplayText = "Collect all non-DLC items at least once, secrets and endings, minus the lost's items.",
TextName = [[!Platinum God! OMG!]],
gfx = "Achievement_PlatinumGod.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[8] = {
DisplayName = "The Real Platinum God",
DisplayText = "Unlock all Non-DLC secrets, items and endings",
TextName = [[The Real Platinum God]],
gfx = "Achievement_RealPlatinumGod.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

ACL_35_god.grid[9] = {
DisplayName = "Golden God!",
DisplayText = "Defeat ??? and The Lamb",
TextName = [["Golden God!" achieved]],
gfx = "Achievement_GoldenGod.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = nil,
Near = false,
Tile = Sprite()
}

return ACL_35_god