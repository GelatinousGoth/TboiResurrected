local mod = require("resurrected_modpack.mod_reference")
mod.LockCallbackRecord = true

local function PrintModList()
    for modName, _ in pairs(mod.Mods) do
        print(modName)
    end
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

local commands = {
    PrintModList = PrintModList,
    VarTest = VariableStressTest,
    RemoveTest = RemoveCallbackTest,
    PrintCallbackList = PrintCallbackList
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
    if parameters == "" then
        return "No command was passed"
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