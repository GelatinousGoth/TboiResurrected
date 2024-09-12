local ACL_21_bosses = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_21_bosses.Pname = "THE MONSTERS"
ACL_21_bosses.Description = "The monsters in the basement await..."
ACL_21_bosses.Counter = 0
ACL_21_bosses.dimX = 5
ACL_21_bosses.dimY = 5
ACL_21_bosses.size = 4

ACL_21_bosses.isHidden = false

ACL_21_bosses.isHidden = false


ACL_21_bosses.portrait = "bosses" -- call your image for the portrait this!!!!


ACL_21_bosses.grid = {}

ACL_21_bosses.grid[1] = {
DisplayName = "The Book of Sin",
DisplayText = "Defeat all 7 Deadly Sins",
TextName = [["The Book of Sin" has appeared in the basement]],
gfx = "Achievement_BookOfSin.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_BOOK_OF_SIN,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[2] = {
DisplayName = "The Womb",
DisplayText = "Defeat Mom",
TextName = [[You unlocked "The Womb" -Chapter 4- Mother sleeps]],
gfx = "Achievement_TheWomb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_WOMB,
Near = true,
Tile = Sprite()
}

ACL_21_bosses.grid[3] = {
DisplayName = "The Harbingers",
DisplayText = "Defeat Mom",
TextName = [[You unlocked "The Harbingers" The Horsemen are loose]],
gfx = "Achievement_Harbingers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_HARBINGERS,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[4] = {
DisplayName = "The Book of Revelations",
DisplayText = "Defeat a Harbinger",
TextName = [["The Book of Revelations" has appeared in the basement]],
gfx = "Achievement_BookOfRevelations.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BOOK_OF_REVELATIONS,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[5] = {
DisplayName = "A Noose",
DisplayText = "Mom's Heart 3 times",
TextName = [["A Noose" has appeared in the basement]],
gfx = "Achievement_Transcendence.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_NOOSE,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[6] = {
DisplayName = "Wire Coat Hanger",
DisplayText = "Defeat Mom's Heart 4 times",
TextName = [["Wire Coat Hanger" has appeared in the basement]],
gfx = "Achievement_WireCoatHanger.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WIRE_COAT_HANGER,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[7] = {
DisplayName = "Ipecac",
DisplayText = "Defeat Mom's Heart 6 times",
TextName = [["Ipecac" has appeared in the basement]],
gfx = "Achievement_Ipecac.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.IPECAC,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[8] = {
DisplayName = "A Halo",
DisplayText = "Use The Bible against Mom, Mom's Heart, or It Lives!",
TextName = [["A Halo" has appeared in the basement]],
gfx = "Achievement_TheHalo.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HALO,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[9] = {
DisplayName = "It Lives!",
DisplayText = "Defeat Mom's Heart 11 times",
TextName = [["It Lives!" Your futures past waits]],
gfx = "Achievement_ItLives.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.IT_LIVES,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[10] = {
DisplayName = "Something wicked",
DisplayText = "Defeat ??? as 3 different Characters",
TextName = [[Something wicked this way comes!]],
gfx = "Achievement_SomethingWicked.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SOMETHING_WICKED,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[13] = {
DisplayName = "ZIP!",
DisplayText = "Defeat The Lamb in under 20 minutes",
TextName = [[ZIP!]],
gfx = "Achievement_AceOfDiamonds.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ACE_OF_DIAMONDS,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[12] = {
DisplayName = "It's the key!",
DisplayText = "Defeat The Lamb without taking any Hearts, Coins, or Bombs",
TextName = [[It's the key]],
gfx = "Achievement_AceOfSpades.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ACE_OF_SPADES,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[11] = {
DisplayName = "The Negative",
DisplayText = "Defeat Satan 5 times",
TextName = [["The Negative" has appeared in the basement]],
gfx = "Achievement_TheNegative.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.NEGATIVE,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[15] = {
DisplayName = "The Polaroid",
DisplayText = "Defeat Isaac 5 times",
TextName = [["The Polaroid" has appeared in the basement]],
gfx = "Achievement_ThePolaroid.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.POLAROID,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[14] = {
DisplayName = "Fast Bombs",
DisplayText = "Defeat Little Horn 20 times",
TextName = [["Fast Bombs" has appeared in the basement]],
gfx = "Achievement_FastBombs.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FAST_BOMBS,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[16] = {
DisplayName = "Lil Delirium",
DisplayText = "Defeat Delirium for the 1st time",
TextName = [["Lil Delirium" has appeared in the basement]],
gfx = "Achievement_LilDelirium.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LIL_DELIRIUM,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[17] = {
DisplayName = "Dad's Key",
DisplayText = "Pick up both Key Pieces in one run",
TextName = [["Dad's Key" has appeared in the basement]],
gfx = "Achievement_DadsKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DADS_KEY,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[18] = {
DisplayName = "You unlocked a new area!",
DisplayText = "Defeat Hush",
TextName = [[You unlocked a new area!]],
gfx = "Achievement_TheVoid.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_VOID,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[19] = {
DisplayName = "Forgotten Lullaby",
DisplayText = "Blow up The Siren's skull",
TextName = [["Forgotten Lullaby" has appeared in the basement]],
gfx = "Achievement_ForgottenLullaby.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FORGOTTEN_LULLABY,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[20] = {
DisplayName = "Fruity Plum",
DisplayText = "Defeat Baby Plum 10 times",
TextName = [["Fruity Plum" has appeared in the basement]],
gfx = "Achievement_FruityPlum.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.FRUITY_PLUM,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[21] = {
DisplayName = "Loki's Horns",
DisplayText = "Defeat Lokii",
TextName = [["Loki's Horns" has appeared in the basement]],
gfx = "Achievement_LokisHorns.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LOKIS_HORNS,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[22] = {
DisplayName = "Little Gish",
DisplayText = "Defeat Gish",
TextName = [["Little Gish" has appeared in the basement]],
gfx = "Achievement_LittleGish.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LITTLE_GISH,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[23] = {
DisplayName = "Little Steven",
DisplayText = "Defeat Steven",
TextName = [["Little Steven" has appeared in the basement]],
gfx = "Achievement_LittleSteven.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LITTLE_STEVEN,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[24] = {
DisplayName = "Little C.H.A.D.",
DisplayText = "Defeat C.H.A.D.",
TextName = [["Little C.H.A.D." has appeared in the basement]],
gfx = "Achievement_LittleChad.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LITTLE_CHAD,
Near = false,
Tile = Sprite()
}

ACL_21_bosses.grid[25] = {
DisplayName = "A Strange Door",
DisplayText = "Defeat Mother",
TextName = [["A Strange Door" has appeared in the depths]],
gfx = "Achievement_StrangeDoor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_STRANGE_DOOR,
Near = false,
Tile = Sprite()
}




return ACL_21_bosses