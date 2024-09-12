local ACL_19_challenges2 = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_19_challenges2.Pname = "CHALLENGES II"
ACL_19_challenges2.Description = "Challenging trials await Isaac."
ACL_19_challenges2.Counter = 0
ACL_19_challenges2.dimX = 5
ACL_19_challenges2.dimY = 4
ACL_19_challenges2.size = 4

ACL_19_challenges2.isHidden = false

ACL_19_challenges2.portrait = "challenge2" -- call your image for the portrait this!!!!


ACL_19_challenges2.grid = {}

ACL_19_challenges2.grid[1] = {
DisplayName = "Rune of Halagaz",
DisplayText = "Complete Pitch Black (Challenge #1)",
TextName = [["Rune of Hagalaz" has appeared in the basement]],
gfx = "Achievement_RuneOfHagalaz.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_HAGALAZ,
Near = true,
Tile = Sprite()
}

ACL_19_challenges2.grid[2] = {
DisplayName = "Rune of Jera",
DisplayText = "Complete High Brow (challenge #2)",
TextName = [["Rune of Jera" has appeared in the basement]],
gfx = "Achievement_RuneOfJera.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_JERA,
Near = true,
Tile = Sprite()
}

ACL_19_challenges2.grid[3] = {
DisplayName = "Rune of Ehwaz",
DisplayText = "Complete Head Trauma (challenge #3)",
TextName = [["Rune of Ehwaz" has appeared in the basement]],
gfx = "Achievement_RuneOfEhwaz.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_EHWAZ,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[4] = {
DisplayName = "Rune of Dagaz",
DisplayText = "Complete Darkness Falls (challenge #4)",
TextName = [["Rune of Dagaz" has appeared in the basement]],
gfx = "Achievement_RuneOfDagaz.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_DAGAZ,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[5] = {
DisplayName = "Rune of Ansuz",
DisplayText = "Complete The Tank (challenge #5)",
TextName = [["Rune of Ansuz" has appeared in the basement]],
gfx = "Achievement_RuneOfAnsuz.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_ANSUZ,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[6] = {
DisplayName = "Rune of Perthro",
DisplayText = "Complete Solar System (challenge #6)",
TextName = [["Rune of Perthro" has appeared in the basement]],
gfx = "Achievement_RuneOfPerthro.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_PERTHRO,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[7] = {
DisplayName = "Suicide King",
DisplayText = "Complete Suicide King (challenge #7)",
TextName = [["Suicide King" has appeared in the basement]],
gfx = "Achievement_SuicideKing.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SUICIDE_KING,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[8] = {
DisplayName = "Rune of Algiz",
DisplayText = "Complete Cat Got Your Tongue (challenge #8)",
TextName = [["Rune of Algiz" has appeared in the basement]],
gfx = "Achievement_RuneOfAlgiz.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_ALGIZ,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[9] = {
DisplayName = "Chaos Card",
DisplayText = "Complete Demo Man (challenge #9)",
TextName = [["Chaos Card" has appeared in the basement]],
gfx = "Achievement_TheChaosCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHAOS_CARD,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[10] = {
DisplayName = "Credit Card",
DisplayText = "Complete Cursed! (challenge #10)",
TextName = [["Credit Card" has appeared in the basement]],
gfx = "Achievement_CreditCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CREDIT_CARD,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[11] = {
DisplayName = "Rules Card",
DisplayText = "Complete Glass Cannon (challenge #11)",
TextName = [["Rules Card" has appeared in the basement]],
gfx = "Achievement_RulesCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RULES_CARD,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[12] = {
DisplayName = "Card Against Humanity",
DisplayText = "Complete When Life Gives You Lemons (challenge #12)",
TextName = [["Card Against Humanity" has appeared in the basement]],
gfx = "Achievement_CardAgainstHumanity.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CARD_AGAINST_HUMANITY,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[13] = {
DisplayName = "Burnt Penny",
DisplayText = "Complete Beans! (challenge #13)",
TextName = [["Burnt Penny" has appeared in the basement]],
gfx = "Achievement_BurntPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BURNT_PENNY,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[14] = {
DisplayName = "SMB Super Fan",
DisplayText = "Complete It's in the Cards (challenge #14)",
TextName = [["SMB Super Fan" has appeared in the basement]],
gfx = "Achievement_SuperFan.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SMB_SUPER_FAN,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[15] = {
DisplayName = "Swallowed Penny",
DisplayText = "Complete Slow Roll (challenge #15)",
TextName = [["Swallowed Penny" has appeared in the basement]],
gfx = "Achievement_SwallowedPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SWALLOWED_PENNY,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[16] = {
DisplayName = "Robo Baby 2.0",
DisplayText = "Complete Computer Savvy (challenge #16)",
TextName = [["Robo Baby 2.0" has appeared in the basement]],
gfx = "Achievement_Robobaby20.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.ROBO_BABY_2,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[17] = {
DisplayName = "Death's Touch",
DisplayText = "Complete Waka Waka (challenge #17)",
TextName = [["Death's Touch" has appeared in the basement]],
gfx = "Achievement_DeathsTouch.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.DEATHS_TOUCH,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[18] = {
DisplayName = "Technology .5",
DisplayText = "Complete The Host (challenge #18)",
TextName = [["Technology .5" has appeared in the basement]],
gfx = "Achievement_Tech5.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.TECHNOLOGY_5,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[19] = {
DisplayName = "Epic Fetus",
DisplayText = "Complete The Family Man (challenge #19)",
TextName = [["Epic Fetus" has appeared in the basement]],
gfx = "Achievement_EpicFetus.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EPIC_FETUS,
Near = false,
Tile = Sprite()
}

ACL_19_challenges2.grid[20] = {
DisplayName = "Rune of Berkano",
DisplayText = "Complete Purist (challenge #20)",
TextName = [["Rune of Berkano" has appeared in the basement]],
gfx = "Achievement_RuneOfBerkano.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RUNE_OF_BERKANO,
Near = false,
Tile = Sprite()
}

return ACL_19_challenges2