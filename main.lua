local mod = require("resurrected_modpack.mod_reference")
mod.Debug = true

mod.json = require("json")
mod.log = require("resurrected_modpack.tools.log")

local TSILFolder = "resurrected_modpack.lib.library_of_isaac"

require("resurrected_modpack.enums")

mod.Lib = {}
require("resurrected_modpack.lib.achievement_checker")
require("resurrected_modpack.tools.pickup_morph_manager")
mod.Lib.TSIL = require(TSILFolder .. ".TSIL")
mod.Lib.TSIL.Init(TSILFolder)

Isaac.DebugString("[Tboi Resurrected] \"Tboi Resurrected\" initialized.")

mod.Mods = {}
mod.RemovedCallbacks = {}

mod.CurrentModName = "Tboi Resurrected"
mod.LockCallbackRecord = false

require("resurrected_modpack.api_overwrite.callback")
require("resurrected_modpack.tools.custom_callbacks")
require("resurrected_modpack.tools.global_variables")
require("resurrected_modpack.tools.global_functions")
require("resurrected_modpack.tools.console_commands")

require("resurrected_modpack.graphics.swaggy_mushrooms")
require("resurrected_modpack.graphics.unique_gurgling_sprite")
require("resurrected_modpack.graphics.red_ending_chest")
require("resurrected_modpack.graphics.custom_corpse_chest")
require("resurrected_modpack.graphics.improved_backdrops_unique_rooms")
require("resurrected_modpack.graphics.improved_backdrops_void_overlay")
require("resurrected_modpack.graphics.improved_backdrops")
require("resurrected_modpack.graphics.beast_laugh_on_damage")
require("resurrected_modpack.graphics.gehenna_visual_tweaks")
require("resurrected_modpack.graphics.crawlspaces_rebuilt")
require("resurrected_modpack.graphics.antibirth_hornfel_trail")
require("resurrected_modpack.graphics.forgotten_got_real_chain")
require("resurrected_modpack.graphics.bygone_over_bb")
require("resurrected_modpack.graphics.keeper_coin_tears")
require("resurrected_modpack.graphics.better_lasers_for_fallen_angels")
require("resurrected_modpack.graphics.missing_costumes")
require("resurrected_modpack.graphics.item_pedestal_overhaul")
require("resurrected_modpack.graphics.missing_tears_gfx")
require("resurrected_modpack.graphics.better_donation_machines")

require("resurrected_modpack.tweaks.lamb_intro_invincibility")
require("resurrected_modpack.tweaks.chests_before_mother")
-- require("resurrected_modpack.tweaks.rare_chests")
require("resurrected_modpack.tweaks.unique_delirium_door")
require("resurrected_modpack.tweaks.fallen_gabriel_spawns_imps")
require("resurrected_modpack.tweaks.bombable_devil_statue")
require("resurrected_modpack.tweaks.amazing_chest_ahead")
require("resurrected_modpack.tweaks.seven_floors_of_bad_luck")
require("resurrected_modpack.tweaks.regret_pedestals")
require("resurrected_modpack.tweaks.fools_goldmines")

require("resurrected_modpack.qol.hanging_dream_catcher")
require("resurrected_modpack.qol.hud_toggle")
require("resurrected_modpack.qol.items_renamed")

require("resurrected_modpack.shaders.hotter_mines")

require("resurrected_modpack.sounds.shepard_tone")
require("resurrected_modpack.sounds.bell_chime_for_good_items")

require("resurrected_modpack.music.unique_mega_satan_music")

require("resurrected_modpack.compatibility.reworked_foes")

local DefaultDisabledMods = {}
for modName, _ in pairs(mod.Mods) do
    DefaultDisabledMods[modName] = false
end

local DisabledMods = TSIL.Utils.DeepCopy.DeepCopy(DefaultDisabledMods)

function mod:SavingProcedure(onExit)
    if not onExit and not mod.Globals.GameStarted then -- Prevent Saving if Loading never occurred
        return
    end
    local saveData = {}
    saveData.DisabledMods = DisabledMods
    saveData.Mods = {}
    for modName, modTable in pairs(mod.Mods) do
        if modTable.SaveData then
            saveData.Mods[modName] = modTable.SaveData()
        end
    end
    mod:SaveData(mod.json.encode(saveData))
end

function mod:SaveOnExit()
    if not mod.Globals.GameStarted then -- Prevent Saving if Loading never occurred
        return
    end
    mod.Globals.GameStarted = false -- the previous check could be avoided by just putting this after the call for SavingProcedure
    -- but given that, if a single error occurs during SavingProcedure the GameStarted variable would not be properly reset I choose to keep the check
    mod:SavingProcedure(true)
end

local function ResetDisabledSettingsToDefault()
    DisabledMods = TSIL.Utils.DeepCopy.DeepCopy(DefaultDisabledMods)
    for modName, _ in pairs(mod.Mods) do
        DisabledMods[modName] = false
        mod:EnableMod(modName, false)
    end
end

function mod:LoadingProcedure(IsContinued)
    if mod.Globals.GameStarted then
        return
    end
    mod.Globals.GameStarted = true
    if mod:HasData() then
        mod.Globals.LoadedData = mod.json.decode(mod:LoadData())
        local removedMods = mod.Globals.LoadedData.DisabledMods
        if removedMods then
            for modName, isRemoved in pairs(removedMods) do
                if mod.Mods[modName] then
                    DisabledMods[modName] = isRemoved
                    if isRemoved then
                        mod:RemoveMod(modName, false)
                    else
                        mod:EnableMod(modName, false)
                    end
                end
            end
        else
            DisabledMods = TSIL.Utils.DeepCopy.DeepCopy(DefaultDisabledMods)
            ResetDisabledSettingsToDefault()
        end
        Isaac.RunCallback(mod.CustomCallbacks.ON_SAVE_DATA_LOAD, IsContinued)
    else
        DisabledMods = TSIL.Utils.DeepCopy.DeepCopy(DefaultDisabledMods)
        ResetDisabledSettingsToDefault()
    end
end

Isaac.AddCallback(mod, ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveOnExit)

Isaac.AddPriorityCallback(mod, ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.MIN, mod.SavingProcedure)

Isaac.AddCallback(mod, ModCallbacks.MC_POST_GAME_STARTED, mod.LoadingProcedure)

Isaac.AddCallback(mod, TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED, mod.LoadingProcedure) -- In case the RemoveCallback functions cause the regular MC_POST_GAME_STARTED callback to not fire

if ModConfigMenu then
    local CategoryName = "Tboi Resurrected"
    for modName, modTable in pairs(mod.Mods) do
        ModConfigMenu.AddSetting(CategoryName, "Enabled", {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function ()
                return DisabledMods[modName]
            end,
            Display = function()
                local choice = tostring(not DisabledMods[modName])
                return (modTable.ConfigName or modName) .. ': ' .. choice
            end,
            OnChange = function(currentSetting)
                DisabledMods[modName] = currentSetting
                if currentSetting then
                    mod:RemoveMod(modName)
                else
                    mod:EnableMod(modName)
                end
            end,
            Info = function () return (modTable.ConfigInfo or "") end
        })
    end
end

mod.CurrentModName = "Post Init"