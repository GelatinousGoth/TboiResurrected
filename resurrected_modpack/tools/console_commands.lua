local mod = require("resurrected_modpack.mod_reference")
mod.LockCallbackRecord = true

local function ExecuteCommand(command, args)
    if type(command) == "string" then
        Isaac.ExecuteCommand(command)
        return true
    elseif type(command) == "function" then
        command(args)
        return true
    else
        print("Not a Valid Executable Command")
        return false
    end
end

local function PrintModList()
    local numMods = 0
    for modName, _ in pairs(mod.Mods) do
        numMods = numMods + 1
        print(modName)
    end
    print("Number of Registered Mods: " .. numMods)
end

local stressTestCollectibles = {
    CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,
    CollectibleType.COLLECTIBLE_CUPIDS_ARROW,
    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
    CollectibleType.COLLECTIBLE_LOST_CONTACT,
    CollectibleType.COLLECTIBLE_ABADDON,
    CollectibleType.COLLECTIBLE_DARK_MATTER
}

local function VariableStressTest()
    local player1 = Isaac.GetPlayer()
    for _, collectibleId in ipairs(stressTestCollectibles) do
        if not player1:HasCollectible(collectibleId) then
            player1:AddCollectible(collectibleId)
        end
    end
end

local function RemoveCallbackTest(args)
    local lock = type(args[1]) == "string" and args[1]:lower() == "lock"

    local previousModName = mod.CurrentModName
    local previousLockCallbackRecord = mod.LockCallbackRecord
    local modName = "RemoveCallbackTest"
    mod.CurrentModName = modName
    mod.LockCallbackRecord = lock

    local function onPostRoom()
        print("I should print")
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostRoom, modName, lock)
    end

    local function noPostRoom()
        print("but I shouldn't")
    end

    local function yePostRoom()
        print("but I should")
    end

    local function latePostRoom()
        print("what did I miss?")
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, noPostRoom, modName, lock)
    end

    local function laterPostRoom()
        print("late you messed me up didn't you?")
    end

    local function sacrificePostRoom()
        print("sacrifices had to be made")
    end

    local function tutorPostRoom()
        print("this is how you do it")
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, sacrificePostRoom, modName, lock)
    end

    local function successPostRoom()
        print("good job tutor")
    end

    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, latePostRoom)
    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, laterPostRoom)
    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, tutorPostRoom)
    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, successPostRoom)
    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, sacrificePostRoom)

    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, noPostRoom)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yePostRoom)

    local function RemoveTest()
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, yePostRoom, modName, lock)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, latePostRoom, modName, lock)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, laterPostRoom, modName, lock)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, tutorPostRoom, modName, lock)
        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, successPostRoom, modName, lock)

        mod:RemoveCallback(ModCallbacks.MC_POST_NEW_ROOM, RemoveTest, modName, lock)
    end

    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, RemoveTest)

    mod.CurrentModName = previousModName
    mod.LockCallbackRecord = previousLockCallbackRecord
end

local function PrintCallbackList(args)
    local modName = ""
    for i, arg in ipairs(args) do
        if i == 1 then
            modName = arg
        else
            modName = modName .. " " .. arg
        end
    end
    if modName == "" then
        print("No mod was specified")
        return
    end
    if not mod.Mods[modName] then
        print("The specified mod does not exist")
        return
    end
    for _, callbackData in ipairs(mod.Mods[modName].CallbackFunctions) do
        print("Callback: " .. callbackData.Callback .. ", Function: " .. tostring(callbackData.Function))
    end
end

local bossIdToRoom = {
    [BossType.MONSTRO] = "goto s.boss.1010",
    [BossType.LARRY_JR] = "goto s.boss.1020",
    [BossType.CHUB] = "goto s.boss.1030",
    [BossType.GURDY] = "goto s.boss.1130",
    [BossType.MONSTRO_II] = "goto s.boss.1050",
    [BossType.MOM] = "goto s.boss.1060",
    [BossType.SCOLEX] = "goto s.boss.1070",
    [BossType.MOMS_HEART] = "goto s.boss.1080",
    [BossType.FAMINE] = "goto s.boss.4010",
    [BossType.PESTILENCE] = "goto s.boss.4020",
    [BossType.WAR] = "goto s.boss.4030",
    [BossType.DEATH] = "goto s.boss.4040",
    [BossType.DUKE_OF_FLIES] = "goto s.boss.2010",
    [BossType.PEEP] = "goto s.boss.2020",
    [BossType.LOKI] = "goto s.boss.2030",
    [BossType.BLASTOCYST] = "goto s.boss.2040",
    [BossType.GEMINI] = "goto s.boss.2050",
    [BossType.FISTULA] = "goto s.boss.2060",
    [BossType.GISH] = "goto s.boss.1110",
    [BossType.STEVEN] = "goto s.boss.2070",
    [BossType.CHAD] = "goto s.boss.1100",
    [BossType.HEADLESS_HORSEMAN] = "goto s.boss.4050",
    [BossType.FALLEN] = "goto s.boss.3500",
    [BossType.SATAN] = "goto s.boss.3600",
    [BossType.IT_LIVES] = "goto s.boss.1090",
    [BossType.HOLLOW] = "goto s.boss.3260",
    [BossType.CARRION_QUEEN] = "goto s.boss.3270",
    [BossType.GURDY_JR] = "goto s.boss.3280",
    [BossType.HUSK] = "goto s.boss.3290",
    [BossType.BLOAT] = "goto s.boss.3300",
    [BossType.LOKII] = "goto s.boss.3310",
    [BossType.BLIGHTED_OVUM] = "goto s.boss.3320",
    [BossType.TERATOMA] = "goto s.boss.3330",
    [BossType.WIDOW] = "goto s.boss.3340",
    [BossType.MASK_OF_INFAMY] = "goto s.boss.3350",
    [BossType.WRETCHED] = "goto s.boss.3360",
    [BossType.PIN] = "goto s.boss.3370",
    [BossType.CONQUEST] = "goto s.boss.4031",
    [BossType.ISAAC] = "goto s.boss.3380",
    [BossType.BLUE_BABY] = "goto s.boss.3390",
    [BossType.DADDY_LONG_LEGS] = "goto s.boss.3400",
    [BossType.TRIACHNID] = "goto s.boss.3410",
    [BossType.HAUNT] = "goto s.boss.5010",
    [BossType.DINGLE] = "goto s.boss.5020",
    [BossType.MEGA_MAW] = "goto s.boss.5030",
    [BossType.GATE] = "goto s.boss.5040",
    [BossType.MEGA_FATTY] = "goto s.boss.5050",
    [BossType.CAGE] = "goto s.boss.5060",
    [BossType.MEGA_GURDY] = "goto s.boss.5070",
    [BossType.DARK_ONE] = "goto s.boss.5080",
    [BossType.ADVERSARY] = "goto s.boss.5090",
    [BossType.POLYCEPHALUS] = "goto s.boss.5100",
    [BossType.MR_FRED] = "goto s.boss.5110",
    [BossType.LAMB] = "goto s.boss.5130",
    [BossType.MEGA_SATAN] = "goto s.boss.5000",
    [BossType.GURGLINGS] = "goto s.boss.5140",
    [BossType.STAIN] = "goto s.boss.1106",
    [BossType.BROWNIE] = "goto s.boss.1116",
    [BossType.FORSAKEN] = "goto s.boss.1079",
    [BossType.LITTLE_HORN] = "goto s.boss.1088",
    [BossType.RAG_MAN] = "goto s.boss.1019",
    [BossType.HUSH] = {"stage 9", "goto 6 4 0"},
    [BossType.ULTRA_GREED] = function() print ("Ultra Greed is only available in Greed Mode") end,
    [BossType.DANGLE] = "goto s.boss.1117",
    [BossType.TURDLINGS] = "goto s.boss.5146",
    [BossType.FRAIL] = "goto s.boss.3384",
    [BossType.RAG_MEGA] = "goto s.boss.3398",
    [BossType.SISTERS_VIS] = "goto s.boss.3406",
    [BossType.BIG_HORN] = "goto s.boss.3394",
    [BossType.DELIRIUM] = "goto s.boss.3414",
    [BossType.ULTRA_GREEDIER] = function() print ("Ultra Greedier is only available in Greedier Mode") end,
    [BossType.MATRIARCH] = "goto s.boss.5152",
    [BossType.PILE] = "goto s.boss.5240",
    [BossType.REAP_CREEP] = "goto s.boss.5250",
    [BossType.LIL_BLUB] = "goto s.boss.5170",
    [BossType.WORMWOOD] = "goto s.boss.5180",
    [BossType.RAINMAKER] = "goto s.boss.5230",
    [BossType.VISAGE] = "goto s.boss.5300",
    [BossType.SIREN] = "goto s.boss.5370",
    [BossType.TUFF_TWINS] = "goto s.boss.5200",
    [BossType.HERETIC] = "goto s.boss.5290",
    [BossType.HORNFEL] = "goto s.boss.5220",
    [BossType.GREAT_GIDEON] = "goto s.boss.5210",
    [BossType.BABY_PLUM] = "goto s.boss.5160",
    [BossType.SCOURGE] = "goto s.boss.5360",
    [BossType.CHIMERA] = "goto s.boss.5350",
    [BossType.ROTGUT] = "goto s.boss.5340",
    [BossType.MOTHER] = {"stage 8c", "goto s.boss.6000"},
    [BossType.MAUS_MOM] = "goto s.boss.6030",
    [BossType.MAUS_HEART] = "goto s.boss.6040",
    [BossType.MIN_MIN] = "goto s.boss.5280",
    [BossType.CLOG] = "goto s.boss.5190",
    [BossType.SINGE] = "goto s.boss.5260",
    [BossType.BUMBINO] = "goto s.boss.5270",
    [BossType.COLOSTOMIA] = "goto s.boss.5330",
    [BossType.SHELL] = "goto s.boss.5310",
    [BossType.TURDLET] = "goto s.boss.5320",
    [BossType.RAGLICH] = function() print ("Raglich is Unused") end,
    [BossType.DOGMA] = {"stage 13a", "goto d.4"},
    [BossType.THE_BEAST] = {"stage 13a", function() Game():ChangeRoom(-10, 0) end},
    [BossType.HORNY_BOYS] = "goto s.boss.6010",
    [BossType.CLUTCH] = "goto s.boss.6020",
    [BossType.CADAVRA] = function() print ("Cadavra is Unused") end
}

local bossIdToRoom_Greed = {
    [BossType.ULTRA_GREED] = {"stage 7", "goto 6 4 0"},
    [BossType.ULTRA_GREEDIER] = {"stage 7", "goto 6 4 0"},
}

local function TestBoss(args)
    local bossId = tonumber(args[1])
    if not bossId then
        print("Error: a number must be passed")
        return
    end
    local conversionTable = bossIdToRoom
    local errorMessage = "No Boss is tied to this BossId"

    if Game():IsGreedMode() then
        conversionTable = bossIdToRoom_Greed
        errorMessage = "Ultra Greed is BossId (62)"
    end
    if not conversionTable[bossId] then
        print(errorMessage)
        return
    end

    local success = true
    local commands = conversionTable[bossId]
    if type(commands) == "table" then
        for _, command in ipairs(commands) do
            if not ExecuteCommand(command) then
                success = false
            end
        end
    else
        if not ExecuteCommand(commands) then
            success = false
        end
    end

    if success then
        local DebugMode = mod.Enums.DebugMode
        local EnabledDebugModes = {
            DebugMode.INFINITE_HP,
            DebugMode.HIGH_DAMAGE
        }
        local DisabledDebugModes = {
            DebugMode.QUICK_KILL
        }

        for _, mode in ipairs(EnabledDebugModes) do
            if not mod.Functions.IsDebugModeActive(mode) then
                Isaac.ExecuteCommand("debug " .. mode)
            end
        end
        for _, mode in ipairs(DisabledDebugModes) do
            if mod.Functions.IsDebugModeActive(mode) then
                Isaac.ExecuteCommand("debug " .. mode)
            end
        end
    end
end

local MorphTable = {
    Original = {Variant = PickupVariant.PICKUP_LOCKEDCHEST},
    Morphs = {
        {Variant = PickupVariant.PICKUP_CHEST, Weight = 100},
        {Variant = PickupVariant.PICKUP_LOCKEDCHEST, Weight = 50},
        {Variant = PickupVariant.PICKUP_BOMBCHEST, Weight = 10},
        {Variant = PickupVariant.PICKUP_SPIKEDCHEST, Weight = 5},
        {Variant = PickupVariant.PICKUP_BIGCHEST, Weight = 0.6}
    }
}


local previousCommand

local function PickupManager(args)
    local command = args[1]
    if not command or (command:lower() ~= "add" and command:lower() ~= "remove" and command:lower() ~= "print") then
        print("This command only accepts add or remove as parameters")
        return
    end
    if not previousCommand and command:lower() == "remove" then
        print("You should add stuff first")
        return
    end
    if command:lower() == previousCommand then
        print("This command has already been executed")
        return
    end
    if command:lower() == "print" then
        local outcomes = mod.Lib.PickupManager.GetOutcomes(MorphTable.Original)
        if not outcomes then
            print("No Outcomes")
            return
        end
        local totalWeight = 0
        for _, outcome in pairs(outcomes) do
            totalWeight = totalWeight + (outcome.Weight or outcome.chance)
        end
        if totalWeight == 0 then
            print("No Outcomes")
        end
        for _, outcome in pairs(outcomes) do
            print("Value: " .. (outcome.Value or outcome.value) .. " Percentage: " .. TSIL.Utils.Math.Round(((outcome.Weight or outcome.chance)/totalWeight) * 100, 2))
        end
        return
    end

    previousCommand = command:lower()
    if command:lower() == "add" then
        for _, morph in ipairs(MorphTable.Morphs) do
            mod.Lib.PickupManager.AddPickupMorph(MorphTable.Original, morph, morph.Weight)
        end
    end
    if command:lower() == "remove" then
        for _, morph in ipairs(MorphTable.Morphs) do
            mod.Lib.PickupManager.RemovePickupMorph(MorphTable.Original, morph.New)
        end
    end
end

local commands = {
    PrintModList = PrintModList,
    VarTest = VariableStressTest,
    RemoveTest = RemoveCallbackTest,
    PrintCallbackList = PrintCallbackList,
    TestBoss = TestBoss,
    PickupManager = PickupManager
}

local function GetCommandArgs(cmdParamsString)
    local counter = 0
    local commandName = ""
    local args = {}
    for word in cmdParamsString:gmatch("%S+") do
        if counter < 1 then
            commandName = word
        else
            args[counter] = word
        end
        counter = counter + 1
    end

    return commandName, args
end

local function onConsoleUsage(_, cmd, parameters)
    if cmd:lower() ~= "resurrected" then
        return
    end
    if not parameters or parameters == "" then
        print("No command was passed")
        return
    end
    local command, args = GetCommandArgs(parameters)
    for commandName, commandFunction in pairs(commands) do
        if command:lower() == commandName:lower() then
            commandFunction(args)
            return
        end
    end
    print("No resurrected command named \"" .. command .. "\" exists")
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, onConsoleUsage)

mod.LockCallbackRecord = false