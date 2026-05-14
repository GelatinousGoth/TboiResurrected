local mod = IsaacReflourished


local DSSInitializerFunction = IsaacReflourished.DSSInitializerFunction
local dssModName = "Dead Sea Scrolls (Isaac Reflourished)"
local dssCoreVersion = 7
local dssMod = DSSInitializerFunction(dssModName, dssCoreVersion, IsaacReflourished.SaveManager.MenuProvider)


local function getSaveData()
    local saveData = IsaacReflourished.SaveManager.GetDeadSeaScrollsSave() or {}
    saveData.Toggles = saveData.Toggles or {}
    saveData.RFSettings = saveData.RFSettings or {}
    return saveData
end


---@enum RFSettingDefaults
IsaacReflourished.RFSettingsDefaults = {

    -- accursed trapdoors
    AccursedFirstFloor              = 2,
    AccursedSameAltCurse            = 1,
    AccursedGuppysEye               = 2,

    -- instant poops + fires
    OneHitRedFires                  = 1,
    OneHitRedPoops                  = 1,
    OneHitHostileRooms              = 1,
    OneHitTimeAdded                 = 2,

    -- self damage spikes
    SelfSpikesHostileRooms          = 1,

    -- regret pedestals
    RegretShowLostCyclingItems      = 2,

    -- better room pools
    BetterPoolsArcade               = 2,
    BetterPoolsDarkRoom             = 2,
    BetterPoolsSacRoom              = 2,

    -- run logger
    RunLoggerMaxRuns                = 2, -- 100

    -- boss rush wave counter
    BossRushCounterSpriteStyle      = 1,

    -- stat multiplier display
    StatMultCalcMethod              = 1,
    StatMultShowDamage              = 2,
    StatMultShowTears               = 2,

    -- i'm excited pill timer
    ExcitedTimerShowSeconds         = 1,
    ExcitedTimerDisplayPos          = 1,

    -- reworked curse of the lost
    ReworkedLostCurseMapItems       = 2,

    -- centered fallen angels
    CenteredAngelsSpawnPos          = 1,

    -- fortune telling machine
    FortuneEightBallStackable       = 2,

    -- reworked white fireplace
    WhiteFireRemoveOnBoss           = 2,

    -- red chest teleport
    RedChestTeleportTrap            = 2,

    -- auto swap pocket active
    AutoSwapFrontNewRoom            = 2,
    AutoSwapFrontNewPickups         = 2,

    -- mega satan void portal
    VoidPortalNoCutscene            = 2,
    VoidPortalUnguarantee           = 2,
    VoidPortalHushSpawn             = 2,
}

function IsaacReflourished:GetSettingsValue(varName)
    local save = IsaacReflourished.SaveManager.GetDeadSeaScrollsSave()
    local settings = save and save.RFSettings
    return settings and settings[varName] or IsaacReflourished.RFSettingsDefaults[varName]
end

local directory = {}

local smallSpace = {str = "", nosel = true, fsize = 1}
local bigSpace = {str = "", nosel = true, fsize = 3}

-- Index the directory with the name of the page you're creating
-- The name of your pages are arbitrary, but make them something obvious
directory.main = {

    -- All strings must be in lowercase
    -- The title is what the user will see at the top of the page
    title = "isaac reflourished",

    -- buttons defines every button in our menu
    -- Make sure you define them in order of how you want them to appear
    buttons = {
        {
            -- The str tag defines the text our button will show
            str = "resume game",

            -- The action tag refers to a pre-defined function
            -- This function will run when the button is pressed
            -- "resume" closes the menu and resumes the game
            -- Check out the documentation on the action tag for more information
            action = "resume"
        },
        {
            str = "toggles",

            dest = "toggles"
        },
        {
            str = "settings",

            -- Later we're going to create a page named "settings"
            dest = "settings"
        },

        -- There are a few default buttons provided in the dssMod table
        -- These buttons will handle generic menu features, like changelogs
        -- They'll only be visible in your menu if it is the only one active
        -- Otherwise, they'll appear in the outermost DSS menu
        -- This one leads to the changelogs menu, which contains changelogs defined by all mods
        dssMod.changelogsButton,
    },

    -- A tooltip can be set on either an item or a button
    -- It will display in the corner of the menu if the button with it is selected
    -- For items, it'll display only if there are no buttons with a tooltip
    -- This default tooltip tells the user how to navigate the menu
    tooltip = dssMod.menuOpenToolTip
}

directory.toggles = {
    title = "toggle feachers",
    buttons = {

        {
            str = "[apply changes]",
            func = function()
                Isaac.CreateTimer(function()
                    IsaacReflourished:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, function()
                        Isaac.ExecuteCommand("fullrestart")
                    end)
                    IsaacReflourished.SaveManager.Save()
                    Game():Fadeout(0.1, 1)
                end, 20, 1, true)
            end,

            tooltip = {strset = {"changes to", "enabled", "feachers will", "only apply", "on game", "restart.", "", "click here to", "restart game"}},
            action = "resume"
        },

        {
            str = "",
            nosel = true
        },

        {
            str = "cursed trapdoors",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "cursedTrapdoorsEnabled",
            load = function ()
                return getSaveData().Toggles.CursedTrapdoorsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.CursedTrapdoorsEnabled = var
            end,
            tooltip = {strset = {"enable curse", "icons appearing", "above", "trapdoors"}}
        },
        {
            str = "easy push",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "easyPushEnabled",
            load = function ()
                return getSaveData().Toggles.EasyPushEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.EasyPushEnabled = var
            end,
            tooltip = {strset = {"tnt and bomb", "chests are", "easier to", "push"}}
        },
        {
            str = "instant poops + fires",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "instantPoopsAndFiresEnabled",
            load = function ()
                return getSaveData().Toggles.InstantPoopsAndFiresEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.InstantPoopsAndFiresEnabled = var
            end,
            tooltip = {strset = {"poops and", "fires are", "broken in", "one hit"}}
        },
        {
            str = "self damage spikes",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "spikesDealChanceEnabled",
            load = function ()
                return getSaveData().Toggles.SpikesDealChanceEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.SpikesDealChanceEnabled = var
            end,
            tooltip = {strset = {"floor spikes", "won't remove", "deal chance", "on hit"}}
        },
        smallSpace,
        {
            str = "spike rock projectiles",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "spikedRockProjectilesEnabled",
            load = function ()
                return getSaveData().Toggles.SpikedRockProjectilesEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.SpikedRockProjectilesEnabled = var
            end,
            tooltip = {strset = {"spike rocks", "shoot", "dangerous spike", "projectiles", "when broken"}}
        },
        smallSpace,
        {
            str = "alt path indicators",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "floorAltIndicatorsEnabled",
            load = function ()
                return getSaveData().Toggles.FloorAltIndicatorsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.FloorAltIndicatorsEnabled = var
            end,
            tooltip = {strset = {"see what", "alt path", "floor variant", "the secret exit", "door will take", "you to"}}
        },
        {
            str = "floor trapdoors",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "floorTrapdoorsEnabled",
            load = function ()
                return getSaveData().Toggles.FloorTrapdoorsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.FloorTrapdoorsEnabled = var
            end,
            tooltip = {strset = {"trapdoors", "show what", "floor alt", "they will", "take you to"}}
        },
        smallSpace,
        {
            str = "skulls drop host hat",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "skullsDropHostHatEnabled",
            load = function ()
                return getSaveData().Toggles.SkullsDropHostHatEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.SkullsDropHostHatEnabled = var
            end,
            tooltip = {strset = {"skulls have", "a 1/3 chance", "to drop a", "host hat", "instead of", "ghost baby", "or dry baby"}}
        },
        smallSpace,
        {
            str = "last chance reroll",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "lastChanceRerollEnabled",
            load = function ()
                return getSaveData().Toggles.LastChanceRerollEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.LastChanceRerollEnabled = var
            end,
            tooltip = {strset = {"reroll items", "right after", "picking them", "up while", "above your", "head"}}
        },
        {
            str = "glitched crown fix",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "glitchedCrownRespectsWaitTimeEnabled",
            load = function ()
                return getSaveData().Toggles.GlitchedCrownRespectsWaitTimeEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.GlitchedCrownRespectsWaitTimeEnabled = var
            end,
            tooltip = {strset = {"cycling", "pedestals won't", "be instantly", "picked up", "when opening", "chests"}}
        },
        {
            str = "regret pedestals",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "regretPedestalsEnabled",
            load = function ()
                return getSaveData().Toggles.RegretPedestalsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.RegretPedestalsEnabled = var
            end,
            tooltip = {strset = {"see the item", "you missed", "on blind", "choice", "pedestals"}}
        },
        smallSpace,
        {
            str = "improved blue womb",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "improvedBlueWombEnabled",
            load = function ()
                return getSaveData().Toggles.ImprovedBlueWombEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.ImprovedBlueWombEnabled = var
            end,
            tooltip = {strset = {"fight three", "blue key", "enemy rooms", "in blue womb"}}
        },
        smallSpace,
        {
            str = "choice libraries",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "choiceLibrariesEnabled",
            load = function ()
                return getSaveData().Toggles.ChoiceLibrariesEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.ChoiceLibrariesEnabled = var
            end,
            tooltip = {strset = {"only one", "book can be", "taken from", "libraries"}}
        },
        {
            str = "held book libraries",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "moreLibrariesHoldingBookEnabled",
            load = function ()
                return getSaveData().Toggles.MoreLibrariesHoldingBookEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.MoreLibrariesHoldingBookEnabled = var
            end,
            tooltip = {strset = {"libraries appear", "more frequently", "when holding", "a book"}}
        },
        {
            str = "better room pools",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "betterRoomPoolsEnabled",
            load = function ()
                return getSaveData().Toggles.BetterRoomPoolsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.BetterRoomPoolsEnabled = var
            end,
            tooltip = {strset = {"changes the", "reroll", "item pool in", "arcades,", "dark room's", "starting room,", "and sacrifice", "rooms"}}
        },
        {
            str = "greed charge fix",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "greedChargeEnabled",
            load = function ()
                return getSaveData().Toggles.GreedChargeEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.GreedChargeEnabled = var
            end,
            tooltip = {strset = {"gain an", "active charge", "when killing", "the miniboss", "before ultra", "greed"}}
        },
        smallSpace,
        (not REPENTANCE_PLUS) and { --Don't show feacher if in Rep+ cuz the bug is already fixed in rep+
            str = "greed secret room fix",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "greedSecretRoomFixEnabled",
            load = function ()
                return getSaveData().Toggles.GreedSecretRoomFixEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.GreedSecretRoomFixEnabled = var
            end,
            tooltip = {strset = {"fixes", "challenge room", "doors being", "permanantly", "locked when", "killing greed", "in secret rooms"}}
        } or {
            str = "greed secret room fix",
            fsize = 2,
            tooltip = {strset = {"already", "implemented", "in", "repentance+!"}}
        },
        smallSpace,
        {
            str = "stairway beggar fix",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "angelShopBeggarFixEnabled",
            load = function ()
                return getSaveData().Toggles.AngelShopBeggarFixEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.AngelShopBeggarFixEnabled = var
            end,
            tooltip = {strset = {"moves the", "beggar in", "stairway shops", "1 tile to", "the right"}}
        },
        {
            str = "run logger",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "runLoggerEnabled",
            load = function ()
                return getSaveData().Toggles.RunLoggerEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.RunLoggerEnabled = var
            end,
            tooltip = {strset = {"logs your runs", "in a new menu", "in the main", "stats menu"}}
        },
        {
            str = "boss rush wave hud",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "bossRushWaveCounterEnabled",
            load = function ()
                return getSaveData().Toggles.BossRushWaveCounterEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.BossRushWaveCounterEnabled = var
            end,
            tooltip = {strset = {"adds a counter", "that tracks", "the current", "wave in", "boss rush"}}
        },
        {
            str = "stat mult display",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "statMultiplierDisplayEnabled",
            load = function ()
                return getSaveData().Toggles.StatMultiplierDisplayEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.StatMultiplierDisplayEnabled = var
            end,
            tooltip = {strset = {"holding tab", "shows your", "damage and", "tears multiplier"}}
        },
        smallSpace,
        {
            str = "i'm excited pill timer",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "excitedTimerEnabled",
            load = function ()
                return getSaveData().Toggles.ExcitedTimerEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.ExcitedTimerEnabled = var
            end,
            tooltip = {strset = {"shows a timer", "that shows when", "the i'm excited", "pill will", "reactivate"}}
        },
        smallSpace,
        {
            str = "better lost curse",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "betterCurseOfTheLostEnabled",
            load = function ()
                return getSaveData().Toggles.BetterCurseOfTheLostEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.BetterCurseOfTheLostEnabled = var
            end,
            tooltip = {strset = {"when curse of", "the lost is", "active, shows", "adjacent rooms", "and rooms from", "mapping items", "on the map"}}
        },
        {
            str = "coop hud fix",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "coopHudFixEnabled",
            load = function ()
                return getSaveData().Toggles.CoopHudFixEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.CoopHudFixEnabled = var
            end,
            tooltip = {strset = {"fixes player 2's", "hud disappearing", "when exiting", "and continuing", "a run"}}
        },
        smallSpace,
        {
            str = "open console hotkey",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "openConsoleHotkeyEnabled",
            load = function ()
                return getSaveData().Toggles.OpenConsoleHotkeyEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.OpenConsoleHotkeyEnabled = var
            end,
            tooltip = {strset = {"select +", "right stick", "opens the", "debug console", "on controller", "(can be", "finnicky)"}}
        },
        smallSpace,
        {
            str = "auto swap active",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "autoSwapActiveEnabled",
            load = function ()
                return getSaveData().Toggles.AutoSwapActiveEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.AutoSwapActiveEnabled = var
            end,
            tooltip = {strset = {"pocket actives", "move to the,", "front when", "entering a", "new room", "also moves", "newly picked", "up cards/pills", "to the front"}}
        },
        {
            str = "lt skip",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "ltSkipEnabled",
            load = function ()
                return getSaveData().Toggles.LtSkipEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.LtSkipEnabled = var
            end,
            tooltip = {strset = {"lt or lb", "on controller", "skips boss vs", "and floor", "transition", "cutscenes"}}
        },
        smallSpace,
        {
            str = "sleep for cracked key",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "sleepForCrackedKeyEnabled",
            load = function ()
                return getSaveData().Toggles.SleepForCrackedKeyEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.SleepForCrackedKeyEnabled = var
            end,
            tooltip = {strset = {"dropping a", "trinket before", "sleeping in", "mom's bed in", "home will", "turn it into", "a cracked key"}}
        },
        smallSpace,
        {
            str = "centered fallen angels",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "centeredFallenAngelsEnabled",
            load = function ()
                return getSaveData().Toggles.CenteredFallenAngelsEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.CenteredFallenAngelsEnabled = var
            end,
            tooltip = {strset = {"fallen angels", "in the mega", "satan fight", "will spawn", "in the bottom", "middle"}}
        },
        smallSpace,
        {
            str = "multishot keepers fix",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "multishotKeepersFixEnabled",
            load = function ()
                return getSaveData().Toggles.MultishotKeepersFixEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.MultishotKeepersFixEnabled = var
            end,
            tooltip = {strset = {"fixes", "multishot items", "not stacking", "properly with", "the keepers'", "innate", "multishot"}}
        },
        smallSpace,
        {
            str = "bob's rotten head fix",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "bobsFuckingRottenHeadEnabled",
            load = function ()
                return getSaveData().Toggles.BobsFuckingRottenHeadEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.BobsFuckingRottenHeadEnabled = var
            end,
            tooltip = {strset = {"bob's rotten", "head will no", "longer inherit", "tear effects", "like bouncing", "off walls"}}
        },
        smallSpace,
        {
            str = "fortune machine eight ball",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "fortuneMachineEightBallEnabled",
            load = function ()
                return getSaveData().Toggles.FortuneMachineEightBallEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.FortuneMachineEightBallEnabled = var
            end,
            tooltip = {strset = {"fortune telling", "machines have a", "50% chance to", "drop eight ball", "instead of", "crystal ball"}}
        },
        smallSpace,
        {
            str = "red chest teleport",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "redChestTeleportEnabled",
            load = function ()
                return getSaveData().Toggles.RedChestTeleportEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.RedChestTeleportEnabled = var
            end,
            tooltip = {strset = {"red chests", "turn into a", "portal instead", "of instantly", "teleporting", "to devil rooms.", "lets you skip", "deals for", "angel chance"}}
        },
        {
            str = "flash unicorn music",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "flashUnicornMusicEnabled",
            load = function ()
                return getSaveData().Toggles.FlashUnicornMusicEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.FlashUnicornMusicEnabled = var
            end,
            tooltip = {strset = {"plays a cute", "melody when my", "little unicorn", "is active", "instead of", "speeding up", "the music"}}
        },
        {
            str = "debug 10 fix",
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "debug10FixEnabled",
            load = function ()
                return getSaveData().Toggles.Debug10FixEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.Debug10FixEnabled = var
            end,
            tooltip = {strset = {"debug 10", "won't softlock", "when killing", "dogma"}}
        },
        smallSpace,
        {
            str = "perma white fireplace",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "permanentWhiteFireplaceEnabled",
            load = function ()
                return getSaveData().Toggles.PermanentWhiteFireplaceEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.PermanentWhiteFireplaceEnabled = var
            end,
            tooltip = {strset = {"white fireplaces", "will give", "ghost form", "permanantly", "until exiting", "the mirror or", "leaving", "the floor"}}
        },
        smallSpace,
        {
            str = "mega satan void portal",
            fsize = 2,
            choices = {"disabled", "enabled"},
            setting = 2,
            variable = "noMegaSatanAutoCutsceneEnabled",
            load = function ()
                return getSaveData().Toggles.NoMegaSatanAutoCutsceneEnabled or 2
            end,
            store = function (var)
                getSaveData().Toggles.NoMegaSatanAutoCutsceneEnabled = var
            end,
            tooltip = {strset = {"the void portal", "after killing", "mega satan", "appears 50%", "of the time", "or 100% if", "hush is killed.", "cutscene wont", "auto play"
}}
        },

        {
            str = "",
            nosel = true
        },

        {
            str = "back",

            -- You can set the font size of buttons by using the fsize tag
            -- 3 is the biggest, 1 is the smallest
            fsize = 2,

            action = "back"
        }
    }

}


directory.settings = {
    title = "settings",

    buttons = {
        -- {
        --     str = "arbitrary switch",

        --     choices = {"on", "off"},

        --     setting = 1,

        --     variable = "arbitraryChoiceOption",

        --     load = function ()
        --         return getSaveData().SwitchState or 1
        --     end,

        --     store = function (var)
        --         getSaveData().SwitchState = var
        --     end,

        --     tooltip = {strset = {"which do you", "prefer?"}}
        -- },
    -- accursed trapdoors
        {
            str = "-accursed trapdoors-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "allow curse on first floor",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.AccursedFirstFloor,
            variable = "AccursedFirstFloor",
            load = function ()
                return getSaveData().RFSettings.AccursedFirstFloor
                    or IsaacReflourished.RFSettingsDefaults.AccursedFirstFloor
            end,
            store = function (var)
                getSaveData().RFSettings.AccursedFirstFloor = var
            end,
            tooltip = {strset = {"if curses", "should be able", "to spawn on", "the first floor", "of the run"}}
        },
        {
            str = "vanilla alt path curse parity",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.AccursedSameAltCurse,
            variable = "AccursedSameAltCurse",
            load = function ()
                return getSaveData().RFSettings.AccursedSameAltCurse
                    or IsaacReflourished.RFSettingsDefaults.AccursedSameAltCurse
            end,
            store = function (var)
                getSaveData().RFSettings.AccursedSameAltCurse = var
            end,
            tooltip = {strset = {"if the alt path", "trapdoor curse", "should be the", "same as the", "main path curse", "like in vanilla"}}
        },
        {
            str = "only show curse icon with guppy's eye",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.AccursedGuppysEye,
            variable = "AccursedGuppysEye",
            load = function ()
                return getSaveData().RFSettings.AccursedGuppysEye
                    or IsaacReflourished.RFSettingsDefaults.AccursedGuppysEye
            end,
            store = function (var)
                getSaveData().RFSettings.AccursedGuppysEye = var
            end,
            tooltip = {strset = {"trapdoors will", "still have", "smoke when", "cursed, but", "won't show", "which curse", "without", "guppy's eye"}}
        },
        bigSpace,

        -- instant poops + fires
        {
            str = "-instant poops + fires-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "red fires break in one hit",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.OneHitRedFires,
            variable = "OneHitRedFires",
            load = function ()
                return getSaveData().RFSettings.OneHitRedFires
                    or IsaacReflourished.RFSettingsDefaults.OneHitRedFires
            end,
            store = function (var)
                getSaveData().RFSettings.OneHitRedFires = var
            end,
            tooltip = {strset = {"if red", "fireplaces", "should be put", "out in one hit"}}
        },
        {
            str = "red poops break in one hit",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.OneHitRedPoops,
            variable = "OneHitRedPoops",
            load = function ()
                return getSaveData().RFSettings.OneHitRedPoops
                    or IsaacReflourished.RFSettingsDefaults.OneHitRedPoops
            end,
            store = function (var)
                getSaveData().RFSettings.OneHitRedPoops = var
            end,
            tooltip = {strset = {"if red poops", "should be put", "out in one hit"}}
        },
        {
            str = "allow in hostile rooms",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.OneHitHostileRooms,
            variable = "OneHitHostileRooms",
            load = function ()
                return getSaveData().RFSettings.OneHitHostileRooms
                    or IsaacReflourished.RFSettingsDefaults.OneHitHostileRooms
            end,
            store = function (var)
                getSaveData().RFSettings.OneHitHostileRooms = var
            end,
            tooltip = {strset = {"if poops and", "fires should be", "put out in", "one hit", "in hostile", "rooms"}}
        },
        {
            str = "add time when instant breaking",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.OneHitTimeAdded,
            variable = "OneHitTimeAdded",
            load = function ()
                return (getSaveData().RFSettings.OneHitTimeAdded and getSaveData().RFSettings.OneHitTimeAdded <= 2 and getSaveData().RFSettings.OneHitTimeAdded)
                    or IsaacReflourished.RFSettingsDefaults.OneHitTimeAdded
            end,
            store = function (var)
                getSaveData().RFSettings.OneHitTimeAdded = var
            end,
            tooltip = {strset = {"if time should", "be added to", "the timer when", "breaking poops", "or fires", "instantly"}}
        },
        bigSpace,

        -- self damage spikes
        {
            str = "-self damage spikes-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "allow in hostile rooms",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.SelfSpikesHostileRooms,
            variable = "SelfSpikesHostileRooms",
            load = function ()
                return getSaveData().RFSettings.SelfSpikesHostileRooms
                    or IsaacReflourished.RFSettingsDefaults.SelfSpikesHostileRooms
            end,
            store = function (var)
                getSaveData().RFSettings.SelfSpikesHostileRooms = var
            end,
            tooltip = {strset = {"if floor spikes", "should deal", "self damage", "in hostile", "rooms"}}
        },
        bigSpace,

        -- regret pedestals
        {
            str = "-regret pedestals-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "show all lost cycling items",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.RegretShowLostCyclingItems,
            variable = "RegretShowLostCyclingItems",
            load = function ()
                return getSaveData().RFSettings.RegretShowLostCyclingItems
                    or IsaacReflourished.RFSettingsDefaults.RegretShowLostCyclingItems
            end,
            store = function (var)
                getSaveData().RFSettings.RegretShowLostCyclingItems = var
            end,
            tooltip = {strset = {"if regret", "pedestals", "should show", "all lost items", "for cycling", "pedestals"}}
        },
        bigSpace,

        -- better room pools
        {
            str = "-better room pools-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "better arcade pool",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.BetterPoolsArcade,
            variable = "BetterPoolsArcade",
            load = function ()
                return getSaveData().RFSettings.BetterPoolsArcade
                    or IsaacReflourished.RFSettingsDefaults.BetterPoolsArcade
            end,
            store = function (var)
                getSaveData().RFSettings.BetterPoolsArcade = var
            end,
            tooltip = {strset = {"if items", "rerolled in", "arcades should", "pull from the", "crane game", "pool"}}
        },
        {
            str = "better dark room red chest pool",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.BetterPoolsDarkRoom,
            variable = "BetterPoolsDarkRoom",
            load = function ()
                return getSaveData().RFSettings.BetterPoolsDarkRoom
                    or IsaacReflourished.RFSettingsDefaults.BetterPoolsDarkRoom
            end,
            store = function (var)
                getSaveData().RFSettings.BetterPoolsDarkRoom = var
            end,
            tooltip = {strset = {"if items", "rerolled in", "the first room", "of dark room", "should pull", "from the devil", "pool"}}
        },
        {
            str = "better sacrifice room pool",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.BetterPoolsSacRoom,
            variable = "BetterPoolsSacRoom",
            load = function ()
                return getSaveData().RFSettings.BetterPoolsSacRoom
                    or IsaacReflourished.RFSettingsDefaults.BetterPoolsSacRoom
            end,
            store = function (var)
                getSaveData().RFSettings.BetterPoolsSacRoom = var
            end,
            tooltip = {strset = {"if items", "rerolled in", "sac rooms", "after the 7th", "sacrifice should", "pull from the", "angel pool"}}
        },
        bigSpace,

        -- run logger
        {
            str = "-run logger-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "max remembered runs",
            fsize = 1,
            choices = {"50", "100", "150", "250", "350", "500", "750", "1000", "5000"},
            setting = IsaacReflourished.RFSettingsDefaults.RunLoggerMaxRuns,
            variable = "RunLoggerMaxRuns",
            load = function ()
                return getSaveData().RFSettings.RunLoggerMaxRuns
                    or IsaacReflourished.RFSettingsDefaults.RunLoggerMaxRuns
            end,
            store = function (var)
                getSaveData().RFSettings.RunLoggerMaxRuns = var
            end,
            tooltip = {strset = {"the max", "number of runs", "stored in the", "run logger", "(lowering this", "will delete", "runs past", "the limit)"}}
        },
        bigSpace,

        -- -- boss rush wave counter
        -- {
        --     str = "-boss rush wave counter-",
        --     nosel = true,
        --     fsize = 2
        -- },
        -- smallSpace,
        -- {
        --     str = "wave counter sprite style",
        --     fsize = 1,
        --     choices = {"cool badass animated grimace", "skull (boring)"},
        --     setting = IsaacReflourished.RFSettingsDefaults.BossRushCounterSpriteStyle,
        --     variable = "BossRushCounterSpriteStyle",
        --     load = function ()
        --         return getSaveData().RFSettings.BossRushCounterSpriteStyle
        --             or IsaacReflourished.RFSettingsDefaults.BossRushCounterSpriteStyle
        --     end,
        --     store = function (var)
        --         getSaveData().RFSettings.BossRushCounterSpriteStyle = var
        --     end,
        --     tooltip = {strset = {"how the", "boss rush", "wave counter", "should look"}}
        -- },
        -- bigSpace,

        -- stat multiplier display
        {
            str = "-stat multiplier display-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "multiplier calculation method",
            fsize = 1,
            choices = {"accurate", "fast"},
            setting = IsaacReflourished.RFSettingsDefaults.StatMultCalcMethod,
            variable = "StatMultCalcMethod",
            load = function ()
                return getSaveData().RFSettings.StatMultCalcMethod
                    or IsaacReflourished.RFSettingsDefaults.StatMultCalcMethod
            end,
            store = function (var)
                getSaveData().RFSettings.StatMultCalcMethod = var
            end,
            tooltip = {strset = {"accurate works", "with modded", "multipliers", "switch to fast", "if playing", "vanilla or", "having issues"}}
        },
        {
            str = "show damage multiplier",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.StatMultShowDamage,
            variable = "StatMultShowDamage",
            load = function ()
                return getSaveData().RFSettings.StatMultShowDamage
                    or IsaacReflourished.RFSettingsDefaults.StatMultShowDamage
            end,
            store = function (var)
                getSaveData().RFSettings.StatMultShowDamage = var
            end,
            tooltip = {strset = {"if the player's", "damage", "multiplier", "should be", "shown when", "holding the", "map button"}}
        },
        {
            str = "show tears multiplier",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.StatMultShowTears,
            variable = "StatMultShowTears",
            load = function ()
                return getSaveData().RFSettings.StatMultShowTears
                    or IsaacReflourished.RFSettingsDefaults.StatMultShowTears
            end,
            store = function (var)
                getSaveData().RFSettings.StatMultShowTears = var
            end,
            tooltip = {strset = {"if the player's", "tear", "multiplier", "should be", "shown when", "holding the", "map button"}}
        },
        bigSpace,

        -- i'm excited pill timer
        {
            str = "-i'm excited pill timer-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "show exact seconds remaining",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.ExcitedTimerShowSeconds,
            variable = "ExcitedTimerShowSeconds",
            load = function ()
                return getSaveData().RFSettings.ExcitedTimerShowSeconds
                    or IsaacReflourished.RFSettingsDefaults.ExcitedTimerShowSeconds
            end,
            store = function (var)
                getSaveData().RFSettings.ExcitedTimerShowSeconds = var
            end,
            tooltip = {strset = {"if the exact", "seconds left", "until", "i'm excited", "reactivates", "should display", "next to the", "timer icon"}}
        },
        {
            str = "timer icon position",
            fsize = 1,
            choices = {"above isaac", "below isaac"},
            setting = IsaacReflourished.RFSettingsDefaults.ExcitedTimerDisplayPos,
            variable = "ExcitedTimerDisplayPos",
            load = function ()
                return getSaveData().RFSettings.ExcitedTimerDisplayPos
                    or IsaacReflourished.RFSettingsDefaults.ExcitedTimerDisplayPos
            end,
            store = function (var)
                getSaveData().RFSettings.ExcitedTimerDisplayPos = var
            end,
            tooltip = {strset = {"where the", "i'm excited", "pill timer icon", "should appear"}}
        },
        bigSpace,

        -- reworked curse of the lost
        {
            str = "-reworked curse of the lost-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "mapping items work during curse",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.ReworkedLostCurseMapItems,
            variable = "ReworkedLostCurseMapItems",
            load = function ()
                return getSaveData().RFSettings.ReworkedLostCurseMapItems
                    or IsaacReflourished.RFSettingsDefaults.ReworkedLostCurseMapItems
            end,
            store = function (var)
                getSaveData().RFSettings.ReworkedLostCurseMapItems = var
            end,
            tooltip = {strset = {"if mapping", "items should", "still work", "during curse", "of the lost"}}
        },
        bigSpace,

        -- centered fallen angels
        {
            str = "-centered fallen angels-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "fallen angel spawn position",
            fsize = 1,
            choices = {"bottom center", "exact center", "bottom left and bottom right"},
            setting = IsaacReflourished.RFSettingsDefaults.CenteredAngelsSpawnPos,
            variable = "CenteredAngelsSpawnPos",
            load = function ()
                return getSaveData().RFSettings.CenteredAngelsSpawnPos
                    or IsaacReflourished.RFSettingsDefaults.CenteredAngelsSpawnPos
            end,
            store = function (var)
                getSaveData().RFSettings.CenteredAngelsSpawnPos = var
            end,
            tooltip = {strset = {"where the", "fallen angels", "should spawn", "during the", "mega satan", "fight"}}
        },
        bigSpace,

        -- fortune telling machine drops eightball
        {
            str = "-fortune telling machine-",
            nosel = true,
            fsize = 2
        },
        {
            str = "drops eightball",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "stackable eight ball",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.FortuneEightBallStackable, --Default enabled
            variable = "FortuneEightBallStackable",
            load = function ()
                return getSaveData().RFSettings.FortuneEightBallStackable or IsaacReflourished.RFSettingsDefaults.FortuneEightBallStackable
            end,
            store = function (var)
                getSaveData().RFSettings.FortuneEightBallStackable = var
            end,
            tooltip = {strset = {"if eight ball's", "planetarium", "chance should", "stack when", "obtaining", "multiple copies"}}
        },
        bigSpace,
        -- reworked white fireplace
        {
            str = "-reworked white fireplace-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "remove lost form on boss defeat",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.WhiteFireRemoveOnBoss,
            variable = "WhiteFireRemoveOnBoss",
            load = function ()
                return getSaveData().RFSettings.WhiteFireRemoveOnBoss
                    or IsaacReflourished.RFSettingsDefaults.WhiteFireRemoveOnBoss
            end,
            store = function (var)
                getSaveData().RFSettings.WhiteFireRemoveOnBoss = var
            end,
            tooltip = {strset = {"if the white", "fireplace's lost", "form should", "be removed", "when beating", "the floor boss"}}
        },
        bigSpace,

        -- red chest teleport
        {
            str = "-red chest teleport-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "trapped devil chest",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.RedChestTeleportTrap,
            variable = "RedChestTeleportTrap",
            load = function ()
                return getSaveData().RFSettings.RedChestTeleportTrap
                    or IsaacReflourished.RFSettingsDefaults.RedChestTeleportTrap
            end,
            store = function (var)
                getSaveData().RFSettings.RedChestTeleportTrap = var
            end,
            tooltip = {strset = {"if red chests", "that will take", "you to the", "devil room", "should suck", "you in", "when opened"}}
        },
        bigSpace,

        -- auto swap pocket active
        {
            str = "-auto swap pocket active-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        {
            str = "front active on new room",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.AutoSwapFrontNewRoom,
            variable = "AutoSwapFrontNewRoom",
            load = function ()
                return getSaveData().RFSettings.AutoSwapFrontNewRoom
                    or IsaacReflourished.RFSettingsDefaults.AutoSwapFrontNewRoom
            end,
            store = function (var)
                getSaveData().RFSettings.AutoSwapFrontNewRoom = var
            end,
            tooltip = {strset = {"if pocket", "active items", "should be", "moved to the", "front slot", "when", "entering", "a new room"}}
        },
        {
            str = "front newly picked up cards/pills",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.AutoSwapFrontNewPickups,
            variable = "AutoSwapFrontNewPickups",
            load = function ()
                return getSaveData().RFSettings.AutoSwapFrontNewPickups
                    or IsaacReflourished.RFSettingsDefaults.AutoSwapFrontNewPickups
            end,
            store = function (var)
                getSaveData().RFSettings.AutoSwapFrontNewPickups = var
            end,
            tooltip = {strset = {"if cards/piills", "should be", "moved in", "front of", "pocket actives", "when picked", "up like in", "repentance"}}
        },
        bigSpace,

        -- mega satan void portal
        {
            str = "-mega satan void portal-",
            nosel = true,
            fsize = 2
        },
        smallSpace,
        -- {
        --     str = "no auto cutscene",
        --     fsize = 1,
        --     choices = {"disabled", "enabled"},
        --     setting = IsaacReflourished.RFSettingsDefaults.VoidPortalNoCutscene,
        --     variable = "VoidPortalNoCutscene",
        --     load = function ()
        --         return getSaveData().RFSettings.VoidPortalNoCutscene
        --             or IsaacReflourished.RFSettingsDefaults.VoidPortalNoCutscene
        --     end,
        --     store = function (var)
        --         getSaveData().RFSettings.VoidPortalNoCutscene = var
        --     end,
        --     tooltip = {strset = {"if the cutscene", "that plays", "automatically", "when beating", "mega satan", "should be", "prevented", "until touching", "the end chest"}}
        -- },
        {
            str = "hush increases void portal spawn chance",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.VoidPortalHushSpawn,
            variable = "VoidPortalHushSpawn",
            load = function ()
                return getSaveData().RFSettings.VoidPortalHushSpawn
                    or IsaacReflourished.RFSettingsDefaults.VoidPortalHushSpawn
            end,
            store = function (var)
                getSaveData().RFSettings.VoidPortalHushSpawn = var
            end,
            tooltip = {strset = {"if beating", "hush in a", "run should", "double", "void portal", "spawn chance"}}
        },
        REPENTANCE_PLUS and --Feacher only appears in REP+ since void portals are already unguaranteed in REP-
        {
            str = "unguarantee void portal spawn",
            fsize = 1,
            choices = {"disabled", "enabled"},
            setting = IsaacReflourished.RFSettingsDefaults.VoidPortalUnguarantee,
            variable = "VoidPortalUnguarantee",
            load = function ()
                return getSaveData().RFSettings.VoidPortalUnguarantee
                    or IsaacReflourished.RFSettingsDefaults.VoidPortalUnguarantee
            end,
            store = function (var)
                getSaveData().RFSettings.VoidPortalUnguarantee = var
            end,
            tooltip = {strset = {"if void", "portals should", "no longer", "have a 100%", "chance to", "spawn like", "in base", "repentance"}}
        } or smallSpace,
        -- These are the settings found on the outermost menu of DSS
        -- They'll only be visible in your menu if it is the only one active
        -- Otherwise, they'll appear in the outermost DSS menu
        dssMod.gamepadToggleButton,
        dssMod.menuKeybindButton,
        dssMod.paletteButton,
        dssMod.menuHintButton,
        dssMod.menuBuzzerButton,
    }
}

local directoryKey = {
    -- This is the initial page of your menu
    Item = directory.main,

    -- This is the index for the page that'll be displayed when opening your menu
    Main = 'main',

    -- These are default state variables for the menu
    -- They're important to have here, but you don't need to change them at all
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Isaac Reflourished", {
    -- The Run, Close, and Open functions define the core loop of your menu
    -- Once your menu is opened, all the work is shifted off to your mod running these function
    -- This allows each mod to have its own independently functioning menu.

    -- The DSSInitializerFunction returns a table with defaults defined for each function
    -- These default functions are good enough for most mods
    -- If you do want a completely custom menu, making own functions is the way to do it
    
    -- This function runs every render frame while your menu is open
    -- It handles everything
    Run = dssMod.runMenu,

    -- This function runs when the menu is opened
    -- Generally it initializes the menu
    Open = dssMod.openMenu,

    -- This function runs when the menu is closed
    -- Generally it handles the storing of save data and general shutdown logic.
    Close = dssMod.closeMenu,

    -- This will hide your mod behind an "other mods" button if enabled
    -- It only activates if other mods with DSS are enabled
    -- It's a good idea to enable this if you don't expect players to use your menu often
    UseSubMenu = false,

    Directory = directory,
    DirectoryKey = directoryKey
})

include("changelogs")

DeadSeaScrollsMenu.AddPalettes({
    {
        -- the name of your palette
        Name = "lavender",

        -- Below you will define the colors your palette will use
        -- They are defined as a list of 3 values of red, green, and blue
        -- Try using Google's RGB color picker to find some good colors

        -- What color is the paper?
        {128, 98, 189},

        -- What color is normal text?
        {20, 16, 43},

        -- What color is highlighted text?
        {28, 15, 24}
    }
})