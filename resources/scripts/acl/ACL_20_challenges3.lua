local ACL_20_challenges3 = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_20_challenges3.Pname = "CHALLENGES III"
ACL_20_challenges3.Description = "Best the challenge before you, triumph over all!"
ACL_20_challenges3.Counter = 0
ACL_20_challenges3.dimX = 5
ACL_20_challenges3.dimY = 5
ACL_20_challenges3.size = 4

ACL_20_challenges3.isHidden = false

ACL_20_challenges3.portrait = "challenge3" -- call your image for the portrait this!!!!


ACL_20_challenges3.grid = {}

ACL_20_challenges3.grid[1] = {
DisplayName = "Gold Heart",
DisplayText = "Complete XXXXXXXXL (challenge #21)",
TextName = [["Gold Heart" has appeared in the basement]],
gfx = "Achievement_224_GoldHeart.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GOLD_HEART,
Near = true,
Tile = Sprite()
}

ACL_20_challenges3.grid[2] = {
DisplayName = "Get out of Jail Free Card",
DisplayText = "Complete SPEED! (challenge #22)",
TextName = [[Get out of Jail Free Card has appeared in the basement]],
gfx = "Achievement_225_GetOutOfJailFreeCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GET_OUT_OF_JAIL_FREE_CARD,
Near = true,
Tile = Sprite()
}

ACL_20_challenges3.grid[3] = {
DisplayName = "Gold Bomb",
DisplayText = "Complete Blue Bomber (challenge #23)",
TextName = [["Gold Bomb" has appeared in the basement]],
gfx = "Achievement_226_GoldBomb.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GOLD_BOMB,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[4] = {
DisplayName = "Two New Pills",
DisplayText = "Complete PAY TO PLAY (challenge #24)",
TextName = [[2 new pills have appeared]],
gfx = "Achievement_227_2NewPills1.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TWO_NEW_PILLS,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[5] = {
DisplayName = "Two Newer Pills",
DisplayText = "Complete Have a Heart (challenge #25)",
TextName = [[2 new pills have appeared]],
gfx = "Achievement_228_2NewPills2.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TWO_NEW_PILLS_2,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[6] = {
DisplayName = "Poker Chip",
DisplayText = "Complete I RULE! (challenge #26)",
TextName = [["Poker Chip" has appeared in the basement]],
gfx = "Achievement_229_PokerChip.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.POKER_CHIP,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[7] = {
DisplayName = "Stud Finder",
DisplayText = "Complete BRAINS! (challenge #27)",
TextName = [["Stud Finder" has appeared in the basement]],
gfx = "Achievement_230_StudFinder.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STUD_FINDER,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[8] = {
DisplayName = "D8",
DisplayText = "Complete PRIDE DAY! (challenge #28)",
TextName = [["D8" has appeared in the basement]],
gfx = "Achievement_231_D8.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.D8,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[9] = {
DisplayName = "Kidney Stone",
DisplayText = "Complete Onan's Streak (challenge #29)",
TextName = [["Kidney Stone" has appeared in the basement]],
gfx = "Achievement_233_KidneyStone.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.KIDNEY_STONE,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[10] = {
DisplayName = "Blank Rune",
DisplayText = "Complete The Guardian (challenge #30)",
TextName = [["Blank Rune" has appeared in the basement]],
gfx = "Achievement_232_BlankRune.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLANK_RUNE,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[11] = {
DisplayName = "Laz Bleeds More!",
DisplayText = "Complete Backasswards (challenge #31)",
TextName = [[Laz Bleeds More!]],
gfx = "Achievement_LazBleedsMore.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LAZARUS_BLEEDS_MORE,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[12] = {
DisplayName = "Maggy now hold a pill!",
DisplayText = "Complete Aprils Fool (challenge #32)",
TextName = [[Maggy now hold a pill!]],
gfx = "Achievement_MaggyNowHoldsAPill.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MAGDALENE_HOLDS_A_PILL,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[13] = {
DisplayName = "Charged Key",
DisplayText = "Complete Pokey Mans (challenge #33)",
TextName = [["Charged Key" has appeared in the basement]],
gfx = "Achievement_ChargedKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHARGED_KEY,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[14] = {
DisplayName = "Samson feels healthy!",
DisplayText = "Complete Ultra Hard (challenge #34)",
TextName = [[Samson feels healthy!]],
gfx = "Achievement_SamsonFeelsHealthy.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SAMMSON_FEELS_HEALTHY,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[15] = {
DisplayName = "Greed's Gullet",
DisplayText = "Complete Pong (challenge #35)",
TextName = [["Greed's Gullet" has appeared in the basement]],
gfx = "Achievement_GreedsGullet.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GREEDS_GULLET,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[16] = {
DisplayName = "Dirty Mind",
DisplayText = "Complete Scat Man (challenge #36)",
TextName = [["Dirty Mind" has appeared in the basement]],
gfx = "Achievement_DirtyMind.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DIRTY_MIND,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[17] = {
DisplayName = "Sigil of Baphomet",
DisplayText = "Complete Bloody Mary (challenge #37)",
TextName = [["Sigil of Baphomet" has appeared in the basement]],
gfx = "Achievement_SigilOfBaphomet.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SIGIL_OF_BAPHOMET,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[18] = {
DisplayName = "Purgatory",
DisplayText = "Complete Baptism by Fire (challenge #38)",
TextName = [["Purgatory" has appeared in the basement]],
gfx = "Achievement_Purgatory.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.PURGATORY,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[19] = {
DisplayName = "Spirit Sword",
DisplayText = "Complete Isaac's Awakening (challenge #39)",
TextName = [["Spirit Sword" has appeared in the basement]],
gfx = "Achievement_SpiritSword.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SPIRIT_SWORD,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[20] = {
DisplayName = "Broken Glasses",
DisplayText = "Complete Seeing Double (challenge #40)",
TextName = [["Broken Glasses" has appeared in the basement]],
gfx = "Achievement_BrokenGlasses.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BROKEN_GLASSES,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[21] = {
DisplayName = "Ice Cube",
DisplayText = "Complete Pica Run (challenge #41)",
TextName = [["Ice Cube" has appeared in the basement]],
gfx = "Achievement_IceCube.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ICE_CUBE,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[22] = {
DisplayName = "The Chariot?",
DisplayText = "Complete Hot Potato (challenge #42)",
TextName = [["The Chariot" has appeared in the basement]],
gfx = "Achievement_ReverseChariot.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_THE_CHARIOT,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[23] = {
DisplayName = "Justice?",
DisplayText = "Complete Cantripped (challenge #43)",
TextName = [["Justice" has appeared in the basement]],
gfx = "Achievement_ReverseJustice.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_JUSTICE,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[24] = {
DisplayName = "The Hermit?",
DisplayText = "Complete Red Redemption (challenge #44)",
TextName = [["The Hermit" has appeared in the basement]],
gfx = "Achievement_ReverseHermit.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_THE_HERMIT,
Near = false,
Tile = Sprite()
}

ACL_20_challenges3.grid[25] = {
DisplayName = "Temperance?",
DisplayText = "Complete DELETE THIS (challenge #45)",
TextName = [["Temperance" has appeared in the basement]],
gfx = "Achievement_ReverseTemperance.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.REVERSED_TEMPERANCE,
Near = false,
Tile = Sprite()
}




return ACL_20_challenges3