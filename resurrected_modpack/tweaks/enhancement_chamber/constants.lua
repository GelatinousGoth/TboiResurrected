--[[ Constants ]]--

-- EC Data
EnhancementChamber.DefaultData = {
    disableRedDamage = false,
    diceTriggered = false,
    diceRestart = false,
}

EnhancementChamber.Data = {}

--Special Rooms config
---@type table<string, boolean>
EnhancementChamber.ConfigSpecial = {
    ambush = true,
    blackmarket = true,
    boss = true,
    bossrush = true,
    curse = true,
    dice = true,
    error = true,
    grave = true,
    library = true,
    sacrifice = true,
    shop = true
}

--Miscellaneous config
---@type table<string, boolean>
EnhancementChamber.ConfigMisc = {
    itemSound = true,
    redHeartDamage = true
}

--Room Description
---@type table<string, string>
EnhancementChamber.ConfigDescSpecial = {
    ambush = "Challenge Rooms are available in the first floor. Ambush enemies can spawn as champion.",
    blackmarket = "Changes item pool to Secret Room pool.",
    boss = "Double Trouble has boss rush music and gives two choice items as reward. Adds unused angel room jingle.",
    bossrush = "Adds pentagram animation and extra effects. Reduces waves from 15 to 10.",
    curse = "Adds bite animation to Curse Room Door. Prevents flying damage immunity.",
    dice = "Adds dice animation effect. 5-pip only triggers by trying to go to the next floor.",
    error = "Adds error jingles. Gives a glitched item by default.",
    grave = "Reworked Grave Rooms with gravestones, custom door, death music and minimap icon. Graves give old chest instead of random chest.",
    library = "Libraries have 20% extra chance to generate by holding one book and 33% with two books. Can only take one item instead of all.",
    sacrifice = "Replaces the spike with demon/angel altars. Altars can disable red heart damage punishment. Reworks sacrifice door and condition to enter.",
    shop = "Shops can sell trinkets instead of sacks. Reworks shop variants to golden and junk shops."
}

--Misc Description
---@type table<string, string>
EnhancementChamber.ConfigDescMisc = {
    itemSound = "Replaces the generic choir sound when getting an item with more accurate sound effects related to room layouts.",
    redHeartDamage = "Curse door and Mausoleum door priorize red heart damage."
}