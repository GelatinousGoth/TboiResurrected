local ACL_24_donate = {}

local PersistentGameData = Isaac.GetPersistentGameData()

ACL_24_donate.Pname = "MY EARNINGS"
ACL_24_donate.Description = "Don't be greedy..."
ACL_24_donate.Counter = 0
ACL_24_donate.dimX = 5
ACL_24_donate.dimY = 6
ACL_24_donate.size = 3

ACL_24_donate.isHidden = false

ACL_24_donate.portrait = "donate" -- call your image for the portrait this!!!!


ACL_24_donate.grid = {}

ACL_24_donate.grid[1] = {
DisplayName = "The Blue Candle",
DisplayText = "Donate 900 coins to the Donation Machine",
TextName = [["The Blue Candle" has appeared in the basement]],
gfx = "Achievement_BlueCandle.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_BLUE_CANDLE,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[2] = {
DisplayName = "Counterfeit Coin",
DisplayText = "Play Shell Game or Hell Game 100 times",
TextName = [["Counterfeit Coin" has appeared in the basement]],
gfx = "Achievement_CounterfeitPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.COUNTERFEIT_COIN,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[3] = {
DisplayName = "Blue Map",
DisplayText = "Donate 10 Coins to the Donation Machine",
TextName = [["Blue Map" has appeared in the basement]],
gfx = "Achievement_BlueMap.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLUE_MAP,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[4] = {
DisplayName = "There's Options",
DisplayText = "Donate 50 Coins to the Donation Machine",
TextName = [["There's Options" has appeared in the basement]],
gfx = "Achievement_TheresOptions.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THERES_OPTIONS,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[5] = {
DisplayName = "Black Candle",
DisplayText = "Donate 150 Coins to the Donation Machine",
TextName = [["Black Candle" has appeared in the basement]],
gfx = "Achievement_BlackCandle.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLACK_CANDLE,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[6] = {
DisplayName = "Red Candle",
DisplayText = "Donate 400 Coins to the Donation Machine",
TextName = [["Red Candle" has appeared in the basement]],
gfx = "Achievement_RedCandle.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.RED_CANDLE,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[7] = {
DisplayName = "Stop Watch",
DisplayText = "Donate 999 Coins to the Donation Machine",
TextName = [["Stop Watch" has appeared in the basement]],
gfx = "Achievement_Stopwatch.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STOP_WATCH,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[8] = {
DisplayName = "Blood Bag",
DisplayText = "Use the Blood Donation Machine 30 times",
TextName = [["Blood Bag" has appeared in the basement]],
gfx = "Achievement_BloodBag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.BLOOD_BAG,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[9] = {
DisplayName = "A D4",
DisplayText = "Blow up 30 Slot Machine",
TextName = [["A D4" has appeared in the basement]],
gfx = "Achievement_D4.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.A_D4,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[10] = {
DisplayName = "Store Upgrade lv.1",
DisplayText = "Donate 20 Coins to the Donation Machine",
TextName = [[Store Upgrade lv.1]],
gfx = "Achievement_StoreUpgrade1.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_UPGRADE_LV1,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[11] = {
DisplayName = "Store Upgrade lv.2",
DisplayText = "Donate 100 Coins to the Donation Machine",
TextName = [[Store Upgrade lv.2]],
gfx = "Achievement_StoreUpgrade2.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_UPGRADE_LV2,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[12] = {
DisplayName = "Store Upgrade lv.3",
DisplayText = "Donate 200 Coins to the Donation Machine",
TextName = [[Store Upgrade lv.3]],
gfx = "Achievement_StoreUpgrade3.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_UPGRADE_LV3,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[13] = {
DisplayName = "Store Upgrade lv.4",
DisplayText = "Donate 600 Coins to the Donation Machine",
TextName = [[Store Upgrade lv.4]],
gfx = "Achievement_StoreUpgrade4.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_UPGRADE_LV4,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[14] = {
DisplayName = "Lucky Pennies",
DisplayText = "Donate 2 Coins to the Greed Donation Machine",
TextName = [[Lucky Pennies have appeared in the basement]],
gfx = "Achievement_242_LuckyPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.LUCKY_PENNIES,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[15] = {
DisplayName = "Special Hanging Shopkeepers",
DisplayText = "Donate 14 Coins to the Greed Donation Machine",
TextName = [[You unlocked Special Hanging Shopkeepers!]],
gfx = "Achievement_243_SpecialHangingShopkeepers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SPECIAL_HANGING_SHOPKEEPERS,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[16] = {
DisplayName = "Wooden Nickel",
DisplayText = "Donate 33 Coins to the Greed Donation Machine",
TextName = [["Wooden Nickel" has appeared in the basement]],
gfx = "Achievement_244_WoodenNickel.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.WOODEN_NICKEL,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[17] = {
DisplayName = "Cain's Paperclip",
DisplayText = "Donate 68 Coins to the Greed Donation Machine",
TextName = [[Cain now holds... "Paperclip"]],
gfx = "Achievement_245_CainPaperClip.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CAIN_HOLDS_PAPERCLIP,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[18] = {
DisplayName = "Greed just got harder!",
DisplayText = "Donate 111 Coins to the Greed Donation Machine",
TextName = [[Everything is terrible 2!!! Greed just got harder!]],
gfx = "Achievement_246_EverythingIsTerrible2.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVERYTHING_IS_TERRIBLE_2,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[19] = {
DisplayName = "Special Shopkeepers",
DisplayText = "Donate 234 Coins to the Greed Donation Machine",
TextName = [[You unlocked Special Shopkeepers!]],
gfx = "Achievement_247_SpecialShopkeepers.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SPECIAL_SHOPKEEPERS,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[20] = {
DisplayName = "Eve's Razor Blade",
DisplayText = "Donate 439 Coins to the Greed Donation Machine",
TextName = [[Eve now holds... "Razor Blade"]],
gfx = "Achievement_248_EveRazorBlade.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.EVE_HOLDS_RAZOR_BLADE,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[21] = {
DisplayName = "Store Key",
DisplayText = "Donate 666 Coins to the Greed Donation Machine",
TextName = [["Store Key" has appeared in the basement]],
gfx = "Achievement_249_StoreKey.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.STORE_KEY,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[22] = {
DisplayName = "The Lost's Holy Mantle",
DisplayText = "Donate 879 Coins to the Greed Donation Machine",
TextName = [[Lost now holds... "Holy Mantle"]],
gfx = "Achievement_250_LostHolyMantle.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.THE_LOST_HOLDS_HOLY_MANTLE,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[23] = {
DisplayName = "Generosity",
DisplayText = "Donate 999 Coins to the Greed Donation Machine",
TextName = [[If only everyone was as generous as you are...]],
gfx = "Achievement_Generosity.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GENEROSITY,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[24] = {
DisplayName = "Got Greedier!",
DisplayText = "Donate 500 Coins to the Greed Donation Machine",
TextName = [[You just got Greedier!]],
gfx = "Achievement_Greedier.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GREEDIER,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[25] = {
DisplayName = "Coupon",
DisplayText = "Purchase anything 50 times",
TextName = [["Coupon" has appeared in the basement]],
gfx = "Achievement_Coupon.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.COUPON,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[26] = {
DisplayName = "Schoolbag",
DisplayText = "Enter 6 Shops in one run",
TextName = [["Schoolbag" has appeared in the basement]],
gfx = "Achievement_Schoolbag.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.SCHOOLBAG,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[27] = {
DisplayName = "Charged Penny",
DisplayText = "Donate to Battery Bums until they give an item 5 times",
TextName = [[ for a small fee..."]],
gfx = "Achievement_ChargedPenny.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.CHARGED_PENNY,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[28] = {
DisplayName = "Old Capacitor",
DisplayText = "Kill 10 Battery Bums",
TextName = [["Old Capacitor" has appeared in the basement]],
gfx = "Achievement_OldCapacitor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.OLD_CAPACITOR,
Near = false,
Tile = Sprite()
}

ACL_24_donate.grid[29] = {
DisplayName = "Member Card",
DisplayText = "Spend 40+ coins in a single Shop",
TextName = [["Member Card" has appeared in the basement]],
gfx = "Achievement_MemberCard.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.MEMBER_CARD,
Near = false,
Tile = Sprite()
}
ACL_24_donate.grid[30] = {
DisplayName = "Golden Razor",
DisplayText = "Obtain 99 Coins and spend all of them at once",
TextName = [["Golden Razor" has appeared in the basement]],
gfx = "Achievement_GoldenRazor.png",
Unlocked = false,
PosY = 0,
PosX = 0,
Enum = Achievement.GOLDEN_RAZOR,
Near = false,
Tile = Sprite()
}

return ACL_24_donate