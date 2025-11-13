--[[ Constants ]]--

-- Minimap --
EnhancementChamber.HasMinimap = true

-- Default Data --
EnhancementChamber.DefaultData = {
    altarType = -1,
    altarPayment = 0,
    disableRedDamage = false,
    diceTriggered = false,
    diceRestart = false,
}

-- Data Variables --
EnhancementChamber.Data = {}

-- Special Rooms config --
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
    shop = true,
}

-- Room Description --
EnhancementChamber.ConfigDescSpecial = {
    ambush = "Challenge Rooms are available in the first floor. Changes item pool to Golden Chest pool. Sheol/Cathedral always has an item.",
    blackmarket = "Changes item pool to Secret Room pool.",
    boss = "Double Trouble has boss rush music and gives two choice items as reward. Adds unused angel room jingle and items no longer trigger angel sound by default.",
    bossrush = "Adds pentagram animation and extra effects. Reduces waves from 15 to 10.",
    curse = "Adds bite animation to Curse Room Door. Prioritizes red heart damage and prevents flying damage immunity.",
    dice = "Adds dice animation effect. 5-pip only triggers by trying to go to the next floor.",
    error = "Rooms with error backdrop give a glitched item.",
    grave = "Reworked Grave Rooms with gravestones, custom door, death music and minimap icon. Graves give old chest instead of random chest.",
    library = "Can only take one item instead of all. Libraries have 20% extra chance to generate by holding one book and 33% with two books.",
    sacrifice = "Replaces the spike with demon/angel altars. Altars can disable red heart damage punishment. Reworks sacrifice door and condition to enter.",
    shop = "Shops can sell trinkets instead of sacks. Reworks shop variants to golden and junk shops."
}

-- Special Room order --
EnhancementChamber.ConfigSpecialOrder = {
    "ambush",
    "blackmarket",
    "boss",
    "bossrush",
    "curse",
    "dice",
    "error",
    "grave",
    "library",
    "sacrifice",
    "shop"
}

-- Miscellaneous config --
EnhancementChamber.ConfigMisc = {
    ambushChampion = true,
    redHeartDamage = true
}

-- Misc Description --
EnhancementChamber.ConfigDescMisc = {
    ambushChampion = "Ambush enemies can spawn as champion, such as challenge waves, boss waves and spawn events.",
    redHeartDamage = "Curse door, Mausoleum door and altars priorize red heart damage."
}

-- Misc order --
EnhancementChamber.ConfigMiscOrder = {
    "ambushChampion",
    "redHeartDamage"
}