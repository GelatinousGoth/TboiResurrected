local TR_Manager = require("resurrected_modpack.manager")
IsaacReflourished = TR_Manager:RegisterMod("Isaac Reflourished", 1, true)

include("resurrected_modpack.qol.reflourished.utility.enums")
include("resurrected_modpack.qol.reflourished.utility.utilityFunctions")
IsaacReflourished.SaveManager = include("resurrected_modpack.qol.reflourished.utility.save_manager")
IsaacReflourished.SaveManager.Init(IsaacReflourished)
IsaacReflourished.DSSInitializerFunction = include("resurrected_modpack.qol.reflourished.utility.dssmenucore")

include("resurrected_modpack.qol.reflourished.utility.dss_menu")

local initialized = false

local function enableIfAllowed(toggles, toggleName, enabler)
    if not enabler then
        return
    end

    if not toggles then
        enabler()
        return
    end

    local value = toggles[toggleName]
    if value == nil or value == 2 then
        enabler()
    end
    -- value == 1 do nothing
end



local CurseLogicEnabler = include("resurrected_modpack.qol.reflourished.utility.curse_logic")
local CursedTrapdoorsEnabler = include("resurrected_modpack.qol.reflourished.grid.cursed_trapdoors")

local EasyPushEnabler = include("resurrected_modpack.qol.reflourished.grid.easy_push")
local InstantPoopsAndFiresEnabler = include("resurrected_modpack.qol.reflourished.grid.instant_poops_and_fires")
local SpikesDealChanceEnabler = include("resurrected_modpack.qol.reflourished.grid.spikes_deal_chance")
local SpikedRockProjectilesEnabler = include("resurrected_modpack.qol.reflourished.grid.spiked_rock_projectiles")
local FloorAltIndicatorsEnabler = include("resurrected_modpack.qol.reflourished.grid.floor_alt_indicators")
local SkullsDropHostHatEnabler = include("resurrected_modpack.qol.reflourished.grid.skulls_drop_host_hat")
local FloorTrapdoorsEnabler = include("resurrected_modpack.qol.reflourished.grid.floor_trapdoors")

local LastChanceRerollEnabler = include("resurrected_modpack.qol.reflourished.pedestals.last_chance_reroll")
local GlitchedCrownRespectsWaitTimeEnabler = include("resurrected_modpack.qol.reflourished.pedestals.glitched_crown_respects_wait_time")
local RegretPedestalsEnabler = include("resurrected_modpack.qol.reflourished.pedestals.regret_pedestals")

local ImprovedBlueWombEnabler = include("resurrected_modpack.qol.reflourished.rooms.improved_blue_womb")
local ChoiceLibrariesEnabler = include("resurrected_modpack.qol.reflourished.rooms.choice_libraries")
local MoreLibrariesHoldingBookEnabler = include("resurrected_modpack.qol.reflourished.rooms.more_libraries_holding_book")
local BetterRoomPoolsEnabler = include("resurrected_modpack.qol.reflourished.rooms.better_room_pools")
local GreedChargeEnabler = include("resurrected_modpack.qol.reflourished.rooms.greed_charge")

local GreedSecretRoomFixEnabler
if not REPENTANCE_PLUS then
    GreedSecretRoomFixEnabler = include("resurrected_modpack.qol.reflourished.rooms.greed_secret_room_fix")
end

local AngelShopBeggarFixEnabler = include("resurrected_modpack.qol.reflourished.rooms.angel_shop_beggar_fix")

local RunLoggerEnabler = include("resurrected_modpack.qol.reflourished.ui.run_logger")
local BossRushWaveCounterEnabler = include("resurrected_modpack.qol.reflourished.ui.boss_rush_wave_counter")
local StatMultiplierDisplayEnabler = include("resurrected_modpack.qol.reflourished.ui.stat_multiplier_display")
local ExcitedTimerEnabler = include("resurrected_modpack.qol.reflourished.ui.excited_timer")
local BetterCurseOfTheLostEnabler = include("resurrected_modpack.qol.reflourished.ui.better_curse_of_the_lost")
local CoopHudFixEnabler = include("resurrected_modpack.qol.reflourished.ui.coop_hud_fix")
local OpenConsoleHotkeyEnabler = include("resurrected_modpack.qol.reflourished.ui.open_console_hotkey")
local AutoSwapActiveEnabler = include("resurrected_modpack.qol.reflourished.ui.auto_swap_active")
local LtSkipEnabler = include("resurrected_modpack.qol.reflourished.ui.lt_skip")

local SleepForCrackedKeyEnabler = include("resurrected_modpack.qol.reflourished.sleep_for_cracked_key")

local MultishotKeepersFixEnabler = include("resurrected_modpack.qol.reflourished.multishot_keepers_fix")
local BobsFuckingRottenHeadEnabler = include("resurrected_modpack.qol.reflourished.bobs_fucking_rotten_head")

local FortuneMachineEightBallEnabler = include("resurrected_modpack.qol.reflourished.fortune_machine_eight_ball")
local RedChestTeleportEnabler = include("resurrected_modpack.qol.reflourished.red_chest_teleport")

local FlashUnicornMusicEnabler = include("resurrected_modpack.qol.reflourished.flash_unicorn_music")
local Debug10FixEnabler = include("resurrected_modpack.qol.reflourished.debug_10_fix")
local PermanentWhiteFireplaceEnabler = include("resurrected_modpack.qol.reflourished.permanent_white_fireplace")
local NoMegaSatanAutoCutsceneEnabler = include("resurrected_modpack.qol.reflourished.no_mega_satan_auto_cutscene")


IsaacReflourished:AddCallback(IsaacReflourished.SaveManager.SaveCallbacks.POST_DATA_LOAD, function()
    if initialized == true then return end
    initialized = true

    local saveData = IsaacReflourished.SaveManager.GetDeadSeaScrollsSave()
    local toggles = saveData and saveData.Toggles

    enableIfAllowed(toggles, "CursedTrapdoorsEnabled", CursedTrapdoorsEnabler)
    enableIfAllowed(toggles, "CursedTrapdoorsEnabled", CurseLogicEnabler)
    enableIfAllowed(toggles, "EasyPushEnabled", EasyPushEnabler)
    enableIfAllowed(toggles, "InstantPoopsAndFiresEnabled", InstantPoopsAndFiresEnabler)
    enableIfAllowed(toggles, "SpikesDealChanceEnabled", SpikesDealChanceEnabler)
    enableIfAllowed(toggles, "SpikedRockProjectilesEnabled", SpikedRockProjectilesEnabler)
    enableIfAllowed(toggles, "FloorAltIndicatorsEnabled", FloorAltIndicatorsEnabler)
    enableIfAllowed(toggles, "SkullsDropHostHatEnabled", SkullsDropHostHatEnabler)
    enableIfAllowed(toggles, "FloorTrapdoorsEnabled", FloorTrapdoorsEnabler)

    enableIfAllowed(toggles, "LastChanceRerollEnabled", LastChanceRerollEnabler)
    enableIfAllowed(toggles, "GlitchedCrownRespectsWaitTimeEnabled", GlitchedCrownRespectsWaitTimeEnabler)
    enableIfAllowed(toggles, "RegretPedestalsEnabled", RegretPedestalsEnabler)

    enableIfAllowed(toggles, "ImprovedBlueWombEnabled", ImprovedBlueWombEnabler)
    enableIfAllowed(toggles, "ChoiceLibrariesEnabled", ChoiceLibrariesEnabler)
    enableIfAllowed(toggles, "MoreLibrariesHoldingBookEnabled", MoreLibrariesHoldingBookEnabler)
    enableIfAllowed(toggles, "BetterRoomPoolsEnabled", BetterRoomPoolsEnabler)
    enableIfAllowed(toggles, "GreedChargeEnabled", GreedChargeEnabler)

    if not REPENTANCE_PLUS then
        enableIfAllowed(toggles, "GreedSecretRoomFixEnabled", GreedSecretRoomFixEnabler)
    end

    enableIfAllowed(toggles, "AngelShopBeggarFixEnabled", AngelShopBeggarFixEnabler)

    enableIfAllowed(toggles, "RunLoggerEnabled", RunLoggerEnabler)
    enableIfAllowed(toggles, "BossRushWaveCounterEnabled", BossRushWaveCounterEnabler)
    enableIfAllowed(toggles, "StatMultiplierDisplayEnabled", StatMultiplierDisplayEnabler)
    enableIfAllowed(toggles, "ExcitedTimerEnabled", ExcitedTimerEnabler)
    enableIfAllowed(toggles, "BetterCurseOfTheLostEnabled", BetterCurseOfTheLostEnabler)
    enableIfAllowed(toggles, "CoopHudFixEnabled", CoopHudFixEnabler)
    enableIfAllowed(toggles, "OpenConsoleHotkeyEnabled", OpenConsoleHotkeyEnabler)
    enableIfAllowed(toggles, "AutoSwapActiveEnabled", AutoSwapActiveEnabler)
    enableIfAllowed(toggles, "LtSkipEnabled", LtSkipEnabler)

    enableIfAllowed(toggles, "SleepForCrackedKeyEnabled", SleepForCrackedKeyEnabler)

    enableIfAllowed(toggles, "MultishotKeepersFixEnabled", MultishotKeepersFixEnabler)
    enableIfAllowed(toggles, "BobsFuckingRottenHeadEnabled", BobsFuckingRottenHeadEnabler)

    enableIfAllowed(toggles, "FortuneMachineEightBallEnabled", FortuneMachineEightBallEnabler)
    enableIfAllowed(toggles, "RedChestTeleportEnabled", RedChestTeleportEnabler)

    enableIfAllowed(toggles, "FlashUnicornMusicEnabled", FlashUnicornMusicEnabler)
    enableIfAllowed(toggles, "Debug10FixEnabled", Debug10FixEnabler)
    enableIfAllowed(toggles, "PermanentWhiteFireplaceEnabled", PermanentWhiteFireplaceEnabler)
    enableIfAllowed(toggles, "NoMegaSatanAutoCutsceneEnabled", NoMegaSatanAutoCutsceneEnabler)
end
)
