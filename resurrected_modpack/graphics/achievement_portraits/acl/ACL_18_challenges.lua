local ACL_18_challenges = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_18_challenges.Pname = "CHALLENGES I"
ACL_18_challenges.Description = "Unlock the remaining challenges."
ACL_18_challenges.Counter = 0
ACL_18_challenges.dimX = 6
ACL_18_challenges.dimY = 6
ACL_18_challenges.size = 3

ACL_18_challenges.isHidden = false

ACL_18_challenges.portrait = "challenge" -- call your image for the portrait this!!!!


ACL_18_challenges.grid = {}

ACL_18_challenges.grid[1] = {
DisplayName = "#4: Darkness Falls",
DisplayText = "Unlock Eve and defeat ??? as her",
TextName = [[You unlocked Challenge #4 Darkness Falls]],
gfx = "Achievement_Challenge04.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_4_DARKNESS_FALLS,
Near = true,
Tile = Sprite()
}

ACL_18_challenges.grid[2] = {
DisplayName = "#5: The Tank",
DisplayText = "Have 7 or more red hearts at one time",
TextName = [[You unlocked Challenge #5 The Tank]],
gfx = "Achievement_Challenge05.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_5_THE_TANK,
Near = true,
Tile = Sprite()
}

ACL_18_challenges.grid[3] = {
DisplayName = "#6: Solar System",
DisplayText = "Defeat Mom's Heart 3 times",
TextName = [[You unlocked Challenge #6 Solar System]],
gfx = "Achievement_Challenge06.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_6_SOLAR_SYSTEM,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[4] = {
DisplayName = "#7: Suicide King",
DisplayText = "Defeat Mom's Heart 11 times and unlock Lazarus",
TextName = [[You unlocked Challenge #7 Suicide King]],
gfx = "Achievement_Challenge07.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_7_SUICIDE_KING,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[5] = {
DisplayName = "#8: Cat Got Your Tongue",
DisplayText = "Become Guppy",
TextName = [[You unlocked Challenge #8 Cat got your Tongue]],
gfx = "Achievement_Challenge08.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_8_CAT_GOT_YOUR_TONGUE,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[6] = {
DisplayName = "#9: Demo Man",
DisplayText = "Defeat Mom's Heart 9 times",
TextName = [[You unlocked Challenge #9 Demo Man]],
gfx = "Achievement_Challenge09.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_9_DEMO_MAN,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[7] = {
DisplayName = "#10: Cursed!",
DisplayText = "Have 7 or more red hearts at one time",
TextName = [[You unlocked Challenge #10 Cursed!]],
gfx = "Achievement_Challenge10.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_10_CURSED,
Near = false,
Tile = Sprite()
}
--[[THIS ONE vvv]]--
ACL_18_challenges.grid[8] = {
DisplayName = "#11: Glass Cannon",
DisplayText = "Beat Challenge #19, defeat Lokii, and unlock Judas",
TextName = [[You unlocked Challenge #11 Glass Cannon]],
gfx = "Achievement_Challenge11.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_11_GLASS_CANNON,
Near = false,
Tile = Sprite()
}
--[[THIS ONE ^^^]]--
ACL_18_challenges.grid[9] = {
DisplayName = "#19: The Family Man",
DisplayText = "Pick up both Key Pieces from the Angels in one run",
TextName = [[You unlocked Challenge #19 The Family Man]],
gfx = "Achievement_Challenge19.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_19_THE_FAMILY_MAN,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[10] = {
DisplayName = "#20: Purist",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #20 Purist]],
gfx = "Achievement_Challenge20.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_20_PURIST,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[11] = {
DisplayName = "#21: XXXXXXXXL",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #21 XXXXXXXXL]],
gfx = "Achievement_Challenge21.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_21_XXXXXXXXL,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[12] = {
DisplayName = "#22: SPEED!",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #22 SPEED!]],
gfx = "Achievement_Challenge22.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_22_SPEED,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[13] = {
DisplayName = "#23: Blue Bomber",
DisplayText = "Destroy 10 Tinted Rocks and defeat Mom's Heart 11 times",
TextName = [[You unlocked Challenge #23 Blue Bomber]],
gfx = "Achievement_Challenge23.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_23_BLUE_BOMBER,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[14] = {
DisplayName = "#24: PAY TO PLAY",
DisplayText = "Defeat Isaac as Cain and destroy 10 Tinted Rocks ",
TextName = [[You unlocked Challenge #24 PAY TO PLAY]],
gfx = "Achievement_Challenge24.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_24_PAY_TO_PLAY,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[15] = {
DisplayName = "#25: Have a Heart",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #25 Have a heart]],
gfx = "Achievement_Challenge25.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_25_HAVE_A_HEART,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[16] = {
DisplayName = "#26: I RULE!",
DisplayText = "Defeat Mega Satan and unlock The Negative",
TextName = [[You unlocked Challenge #26 I RULE!]],
gfx = "Achievement_Challenge26.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_26_I_RULE,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[17] = {
DisplayName = "#27: BRAINS!",
DisplayText = "Defeat Isaac 5 times",
TextName = [[You unlocked Challenge #27 BRAINS!]],
gfx = "Achievement_Challenge27.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_27_BRAINS,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[18] = {
DisplayName = "#28: PRIDE DAY!",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #28 PRIDE DAY!]],
gfx = "Achievement_Challenge28.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_28_PRIDE_DAY,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[19] = {
DisplayName = "#29: Onan's Streak",
DisplayText = "Unlock Judas and It Lives!",
TextName = [[You unlocked Challenge #29 Onan's Streak]],
gfx = "Achievement_Challenge29.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_29_ONANS_STREAK,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[20] = {
DisplayName = "#30: The Guardian",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #30 The Guardian]],
gfx = "Achievement_Challenge30.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_30_THE_GUARDIAN,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[21] = {
DisplayName = "#31: Backasswards",
DisplayText = "Defeat Mega Satan and unlock The Negative",
TextName = [[You unlocked Challenge #31 Backasswards]],
gfx = "Achievement_Challenge31.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_31_BACKASSWARDS,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[22] = {
DisplayName = "#32: Aprils Fool",
DisplayText = "Defeat Mom",
TextName = [[You unlocked Challenge #32 Aprils fool]],
gfx = "Achievement_Challenge32.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_32_APRILS_FOOL,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[23] = {
DisplayName = "#33: Pokey Mans",
DisplayText = "Defeat Mom's Heart 11 times",
TextName = [[You unlocked Challenge #33 Pokey mans]],
gfx = "Achievement_Challenge33.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_33_POKEY_MANS,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[24] = {
DisplayName = "#34: Ultra Hard",
DisplayText = "Defeat Mega Satan and unlock The Negative",
TextName = [[You unlocked Challenge #34 Ultra hard]],
gfx = "Achievement_Challenge34.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_34_ULTRA_HARD,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[25] = {
DisplayName = "#35: PONG",
DisplayText = "Defeat Isaac 5 times",
TextName = [[You unlocked Challenge #35 PONG]],
gfx = "Achievement_Challenge35.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_35_PONG,
Near = false,
Tile = Sprite()
}
--------------------
ACL_18_challenges.grid[26] = {
DisplayName = "Dedication",
DisplayText = "Participate in 31 Daily Challenges",
TextName = [[Dedication]],
gfx = "Achievement_PillHorf.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.HORF,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[27] = {
DisplayName = "#37: Bloody Mary",
DisplayText = "Unlock Bethany, Blood Bag, and It Lives!",
TextName = [[You unlocked Challenge #37 Bloody Mary]],
gfx = "Achievement_Challenge37.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_37_BLOODY_MARY,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[28] = {
DisplayName = "#38: Baptism By Fire",
--DisplayText = "Defeat Satan as Bethany, defeat Mom's Heart 11 times, and unlock Maggy's Faith",
DisplayText = "Unlock Maggy's Faith, Defeat Satan as Bethany and...",
TextName = [[You unlocked Challenge #38 Baptism by Fire]],
gfx = "Achievement_Challenge38.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_38_BAPTISM_BY_FIRE,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[29] = {
DisplayName = "#39: Isaac's Awakening",
DisplayText = "Defeat Mother",
TextName = [[You unlocked Challenge #39 Isaac's Awakening]],
gfx = "Achievement_Challenge39.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_39_ISAACS_AWAKENING,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[30] = {
DisplayName = "#40: Seeing Double",
DisplayText = "Defeat Mother",
TextName = [[You unlocked Challenge #40 Seeing Double]],
gfx = "Achievement_Challenge40.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_40_SEEING_DOUBLE,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[31] = {
DisplayName = "#41: Pica Run",
DisplayText = "Defeat Mom's Heart 11 times and unlock Marbles",
TextName = [[You unlocked Challenge #41 Pica Run]],
gfx = "Achievement_Challenge41.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_41_PICA_RUN,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[32] = {
DisplayName = "#42: Hot Potato",
DisplayText = "Unlock...",
TextName = [[You unlocked Challenge #42 Hot Potato]],
gfx = "Achievement_Challenge42.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_42_HOT_POTATO,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[33] = {
DisplayName = "#43: Cantripped!",
DisplayText = "Unlock...",
TextName = [[You unlocked Challenge #43 Cantripped!]],
gfx = "Achievement_Challenge43.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_43_CANTRIPPED,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[34] = {
DisplayName = "#44: Red Redemption",
DisplayText = "Unlock...",
TextName = [[You unlocked Challenge #44]],
gfx = "Achievement_Challenge44.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_44_RED_REDEMPTION,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[35] = {
DisplayName = "#45: D LETE TH !S",
DisplayText = "TODO: remove this achievement",
TextName = [[You unlocked Challenge #45]],
gfx = "Achievement_Challenge45.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHALLENGE_45_DELETE_THIS,
Near = false,
Tile = Sprite()
}

ACL_18_challenges.grid[36] = {
DisplayName = "Broken Modem",
DisplayText = "Complete 7 Daily Challenges",
TextName = [["Broken Modem" has appeared in the basement]],
gfx = "Achievement_BrokenModem.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BROKEN_MODEM,
Near = false,
Tile = Sprite()
}

return ACL_18_challenges