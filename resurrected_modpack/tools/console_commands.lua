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

local commands = {
    PrintModList = PrintModList,
    VarTest = VariableStressTest
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