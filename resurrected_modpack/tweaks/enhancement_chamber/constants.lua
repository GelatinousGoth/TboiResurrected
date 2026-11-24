--[[ Constants ]]--

---@class EnhancementData
---@field altarType integer
---@field altarPayment integer
---@field diceTriggered boolean
---@field diceRestart string?
---@field floorCleared boolean

-- EC Data
---@type EnhancementData
EnhancementChamber.DefaultData = {
    altarType = -1,
    altarPayment = 0,
    diceTriggered = false,
    diceRestart = nil,
    floorCleared = false
}

EnhancementChamber.Data = {}

---@class EnhancementConfigEntry
---@field bool boolean
---@field module string
---@field name string
---@field desc string

-- EC Config
---@type table<string, EnhancementConfigEntry>
EnhancementChamber.Config = {
    -- Modules
    challenge_firstfloor = {
        bool = true,
        module = "Ambush",
        name = "Early Challenge",
        desc = "Challenge Rooms are available in the first floor when possible."
    },
    blackmarket_itempool = {
        bool = true,
        module = "Blackmarket",
        name = "Secret Pool",
        desc = "Replaces shop pool with secret pool."
    },
    boss_hiddenshape = {
        bool = true,
        module = "Boss",
        name = "Secret Layout",
        desc = "Boss Room shows as 1x1 shape until being visited. Hides double trouble rooms as well."
    },
    doubletrouble_music = {
        bool = true,
        module = "Boss",
        name = "DT Music",
        desc = "Replace normal boss music with boss rush in double troubles."
    },
    doubletrouble_twoitems = {
        bool = true,
        module = "Boss",
        name = "DT Item Choice",
        desc = "Double Troubles give two choice items instead of one item."
    },
    bossrush_pentagram = {
        bool = true,
        module = "Bossrush",
        name = "Pentagram",
        desc = "Adds pentagram animation and extra effects. Reduces waves from 15 to 10."
    },
    curse_redheartdamage = {
        bool = true,
        module = "Curse",
        name = "Door RHD",
        desc = "Curse door prioritizes red heart damage instead of soul heart."
    },
    curse_flydamage = {
        bool = true,
        module = "Curse",
        name = "Flying Damage",
        desc = "Flying no longer prevents taking damage when entering a curse door."
    },
    dice_clearcurses = {
        bool = true,
        module = "Dice",
        name = "Clear Curses",
        desc = "Dices should clear curses from the floor."
    },
    dice_restart = {
        bool = true,
        module = "Dice",
        name = "Late Restart",
        desc = "5-pip only triggers by trying to go to the next floor."
    },
    error_itempool = {
        bool = true,
        module = "Error",
        name = "Glitch Pool",
        desc = "Replaces treasure pool with glitch pool."
    },
    error_jingle = {
        bool = true,
        module = "Error",
        name = "Jingles",
        desc = "Enables jingles to Error Room."
    },
    grave_ambience = {
        bool = true,
        module = "Grave",
        name = "Ambience",
        desc = "Grave Rooms have death music."
    },
    grave_objects = {
        bool = true,
        module = "Grave",
        name = "Objects",
        desc = "Adds graves which can spawn enemies or pickups."
    },
    grave_oldchest = {
        bool = true,
        module = "Grave",
        name = "Old Chest",
        desc = "Dirt Patch gives an old chest instead of basic chest."
    },
    library_choice = {
        bool = true,
        module = "Library",
        name = "Item Choice",
        desc = "Can only take one item instead of all."
    },
    library_generation = {
        bool = true,
        module = "Library",
        name = "Generation by Books",
        desc = "Libraries have 20% extra chance to generate by holding one book and 33% with two books."
    },
    sacrifice_condition = {
        bool = true,
        module = "Sacrifice",
        name = "Entrance Condition",
        desc = "Sacrifice Room can only be accessed by clearing the floor."
    },
    sacrifice_altars = {
        bool = true,
        module = "Sacrifice",
        name = "Altar Mechanics",
        desc = "Reworks spike mechanic by adding demon/angel altars."
    },
    sacrifice_redheartdamage = {
        bool = true,
        module = "Sacrifice",
        name = "Altar RHD",
        desc = "Altars prioritize red heart damage instead of soul heart."
    },
    shop_selltrinket = {
        bool = true,
        module = "Shop",
        name = "Trinket Sale",
        desc = "Shops can sell trinkets instead of sacks."
    },
    shop_variants = {
        bool = true,
        module = "Shop",
        name = "Variant Features",
        desc = "Golden shops have treasure item pool. Junk shops have boss item pool with trinkets."
    },
    -- Miscellaneous
    item_sounds = {
        bool = true,
        module = "Miscellaneous",
        name = "Item Sounds",
        desc = "Replaces angel sound when getting an item with something more accurate related to room layout."
    },
    angeldoor_jingle = {
        bool = true,
        module = "Miscellaneous",
        name = "Angel Door Jingle",
        desc = "Replaces eternal heart sound, when an angel door appears, with the unused angel door jingle."
    },
    mausoleumdoor_redheartdamage = {
        bool = true,
        module = "Miscellaneous",
        name = "Mausoleum Door RHD",
        desc = "Mausoleum door prioritizes red heart damage instead of soul hearts."
    },
}