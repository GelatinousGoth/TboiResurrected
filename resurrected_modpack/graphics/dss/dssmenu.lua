local dssmenu = {}
local mod = require("resurrected_modpack.graphics.dss.modStorage").getMod()

local MenuSaveData = {
    CYCLES = 10,
    START_DELAY = 0, -- in frames | 30/sec
    DELAY_MOD = 0.5, -- how many frames to slow the animation down per cycle
    ITEM_LIMIT = 4,
    CAN_PICK_UP = 2,
    DISPLAY_EID = 1,
    FINAL_DELAY = 6,
}

local json = require("json")
local INITIALIZED = false
function mod.GetSaveData()
    if not INITIALIZED then
        if Isaac.HasModData(mod) then
            MenuSaveData = json.decode(Isaac.LoadModData(mod))
        end

        INITIALIZED = true
    end

    return MenuSaveData
end

function mod.StoreSaveData()
    Isaac.SaveModData(mod, json.encode(MenuSaveData))
end

local DSSModName = "Innocence Glitched Animation"
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    mod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return mod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.GetSaveData().MenusPoppedUp = var
end

local dssmenucore = include("resurrected_modpack.graphics.dss.dssmenucore")
local dssmod = dssmenucore.init(DSSModName, MenuProvider)

local function sharedButtonDisplayCondition(button, item, tbl)
    return tbl.Name == "Menu" or not DeadSeaScrollsMenu.CanOpenGlobalMenu()
end

local IGTRADirectory = {
    main = {
        title = 'Treasure Room Anim',
        buttons = {
            { str = 'resume game', action = 'resume' },
            { str = 'settings',    dest = 'settings' },
            dssmod.changelogsButton,
        },
        tooltip = dssmod.menuOpenToolTip
    },
    settings = {
        title = 'settings',
        buttons = {
            
            {
                str = 'Item Cycles',
                -- If "min" and "max" are set without "slider", you've got yourself a number option!
                -- It will allow you to scroll through the entire range of numbers from "min" to
                -- "max", incrementing by "increment".
                min = 1,
                max = 20,
                increment = 1,
                setting = 10,
                variable = "CYCLES",
                load = function()
                    return mod.GetSaveData().CYCLES or 5
                end,
                store = function(var)
                    mod.GetSaveData().CYCLES = var
                end,
                tooltip = { strset = { "how many", "items cycle", "in the", "animation" } },
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = 'Start Delay',
                min = 0,
                max = 60,
                increment = 1,
                suf = ' frames',
                setting = 3,
                variable = "START_DELAY",
                load = function()
                    return mod.GetSaveData().START_DELAY or 3
                end,
                store = function(var)
                    mod.GetSaveData().START_DELAY = var
                end,
                tooltip = { strset = { "the delay", "the animation", "starts at" } },
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = 'Delay Modifier',
                min = -10,
                max = 10,
                increment = 0.5,
                suf = ' frames',
                setting = 0.5,
                variable = "DELAY_MOD",
                load = function()
                    return mod.GetSaveData().DELAY_MOD or 3
                end,
                store = function(var)
                    mod.GetSaveData().DELAY_MOD = var
                end,
                tooltip = { strset = { "how slow (+)", "or fast (-)", "the animation", "changes by", "each cycle" } },
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = 'Item Limit',
                min = 2,
                max = 10,
                increment = 1,
                setting = 4,
                variable = "ITEM_LIMIT",
                load = function()
                    return mod.GetSaveData().ITEM_LIMIT or 3
                end,
                store = function(var)
                    mod.GetSaveData().ITEM_LIMIT = var
                end,
                tooltip = { strset = { "how many", "items need to", "be in a", "room to", "stop the", "animation", "(performance", "heavy)"} },
            },
            {str = "", fsize = 1, nosel = true},
            {str = "Final Item", fsize = 3, nosel = true},
            {
                str = 'Delay',
                min = 0,
                max = 20,
                increment = 1,
                suf = ' frames',
                setting = 6,
                variable = 'FINAL_DELAY',
                load = function()
                    return mod.GetSaveData().FINAL_DELAY or 0
                end,
                store = function(var)
                    mod.GetSaveData().FINAL_DELAY = var
                end,
                tooltip = { strset = { 'An extra', 'delay added', 'to the last', "item in", "a cycle"} }
            },
            {str = "", fsize = 1, nosel = true},
            {str = "Can pick up", fsize = 3, nosel = true},
            {
                str = 'during cycle',
                choices = { 'false', 'true' },
                setting = 2,
                variable = 'CAN_PICK_UP',
                load = function()
                    return mod.GetSaveData().CAN_PICK_UP or 1
                end,
                store = function(var)
                    mod.GetSaveData().CAN_PICK_UP = var
                end,
                tooltip = { strset = { 'Whether you', 'can pick up', 'cycling', "items or", "not" } }
            },
            {str = "", fsize = 1, nosel = true},
            {str = "Display EID", fsize = 3, nosel = true},
            {
                str = 'during cycle',
                choices = { 'false', 'true' },
                setting = 1,
                variable = 'DISPLAY_EID',
                load = function()
                    return mod.GetSaveData().DISPLAY_EID or 1
                end,
                store = function(var)
                    mod.GetSaveData().DISPLAY_EID = var
                end,
                tooltip = { strset = { 'Whether you', 'can see EID', 'descriptions', "while", "cycling", "items or", "not" } }
            },
            {str = "", fsize = 3, nosel = true},
            {
                clr = 3,
                str = 'reset to default?',
                func = function(button, item, menuObj)
                    mod.GetSaveData().CYCLES = 10
                    mod.GetSaveData().START_DELAY = 0
                    mod.GetSaveData().DELAY_MOD = 0.5
                    mod.GetSaveData().ITEM_LIMIT = 4
                    mod.GetSaveData().CAN_PICK_UP = 2
                    mod.GetSaveData().DISPLAY_EID = 1
                    mod.GetSaveData().FINAL_DELAY = 6

                    mod.StoreSaveData()

                    dssmod.reloadButtons(DeadSeaScrollsMenu.Menus["Treasure Room Anim"])
                end,
                
                tooltip = {strset = {"reset all", "settings to", "default?"}},
            },
            {str = "", nosel = true, displayif = sharedButtonDisplayCondition},
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,
        }
    }
}


local IGTRADirectoryKey = {
    -- This is the initial item of the menu, generally you want to set it to your main item
    Item = IGTRADirectory.main,
    -- The main item of the menu is the item that gets opened first when opening your mod's menu.
    Main = 'main',
    -- These are default state variables for the menu; they're important to have in here, but you
    -- don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Treasure Room Anim", {
    -- The Run, Close, and Open functions define the core loop of your menu. Once your menu is
    -- opened, all the work is shifted off to your mod running these functions, so each mod can have
    -- its own independently functioning menu. The `init` function returns a table with defaults
    -- defined for each function, as "runMenu", "openMenu", and "closeMenu". Using these defaults
    -- will get you the same menu you see in Bertran and most other mods that use DSS. But, if you
    -- did want a completely custom menu, this would be the way to do it!

    -- This function runs every render frame while your menu is open, it handles everything!
    -- Drawing, inputs, etc.
    Run = dssmod.runMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data /
    -- general shut down.
    Close = dssmod.closeMenu,
    -- If UseSubMenu is set to true, when other mods with UseSubMenu set to false / nil are enabled,
    -- your menu will be hidden behind an "Other Mods" button.
    -- A good idea to use to help keep menus clean if you don't expect players to use your menu very
    -- often!
    UseSubMenu = false,
    Directory = IGTRADirectory,
    DirectoryKey = IGTRADirectoryKey
})

-- There are a lot more features that DSS supports not covered here, like sprite insertion and
-- scroller menus, that you'll have to look at other mods for reference to use. But, this should be
-- everything you need to create a simple menu for configuration or other simple use cases!

return dssmenu