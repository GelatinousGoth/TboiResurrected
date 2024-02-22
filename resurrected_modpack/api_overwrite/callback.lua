local mod = require("resurrected_modpack.mod_reference")

function mod:AddCallback(callbackId, callbackFn, optionalArg, modName, lockCallbackRecord)
    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

    if mod.Debug and modName == "Post Init" then
        PurposefulError.NonExistentIndex()
    end

    if not mod.RemovedCallbacks[callbackId] then
        mod.RemovedCallbacks[callbackId] = {}

        local function RemoveCallbackManager()
            for _, callbackFn in ipairs(mod.RemovedCallbacks[callbackId]) do
                Isaac.RemoveCallback(self, callbackId, callbackFn)
            end
            mod.RemovedCallbacks[callbackId] = {}
        end
        Isaac.AddPriorityCallback(self, callbackId, CallbackPriority.MAX, RemoveCallbackManager)
    end

    Isaac.AddCallback(self, callbackId, callbackFn, optionalArg)

    if lockCallbackRecord then
        return
    end

    if not mod.Mods[modName] then
        mod.Mods[modName] = {}
        mod.Mods[modName].CallbackFunctions = {}
        mod.Mods[modName].Removed = false
    end
    table.insert(mod.Mods[modName].CallbackFunctions, {Callback = callbackId, Function = callbackFn, OptionalArgs = optionalArg})
end

function mod:AddPriorityCallback(callbackId, priority, callbackFn, optionalArg, modName, lockCallbackRecord)
    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

    if mod.Debug and modName == "Post Init" then
        PurposefulError.NonExistentIndex()
    end

    if not mod.RemovedCallbacks[callbackId] then
        mod.RemovedCallbacks[callbackId] = {}

        local function RemoveCallbackManager()
            for _, callbackFn in ipairs(mod.RemovedCallbacks[callbackId]) do
                Isaac.RemoveCallback(self, callbackId, callbackFn)
            end
            mod.RemovedCallbacks[callbackId] = {}
        end
        Isaac.AddPriorityCallback(self, callbackId, CallbackPriority.MAX, RemoveCallbackManager)
    end

    Isaac.AddPriorityCallback(self, callbackId, priority, callbackFn, optionalArg)

    if not mod.RemovedCallbacks[callbackId] then
        mod.RemovedCallbacks[callbackId] = {}
    end

    if lockCallbackRecord then
        return
    end

    if not mod.Mods[modName] then
        mod.Mods[modName] = {}
        mod.Mods[modName].CallbackFunctions = {}
        mod.Mods[modName].Removed = false
    end
    table.insert(mod.Mods[modName].CallbackFunctions, {Callback = callbackId, Priority = priority, Function = callbackFn, OptionalArgs = optionalArg})
end

function mod:RemoveCallback(callbackId, callbackFn, modName, lockCallbackRecord)
    table.insert(mod.RemovedCallbacks[callbackId], callbackFn)

    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

    if lockCallbackRecord or modName == nil or type(mod.Mods[modName]) ~= "table" then
        return
    end

    for index, callbackData in ipairs(mod.Mods[modName].CallbackFunctions) do
        if callbackData.Callback == callbackId and callbackData.Function == callbackFn then
            table.remove(mod.Mods[modName].CallbackFunctions, index)
            break
        end
    end
end

function mod:EnableMod(modName, warn)
    warn = warn == nil and true or warn
    if type(modName) ~= "string" then
        if warn then
        mod.log.warn("Attempted to Enable an Invalid Mod")
        end
        return
    end
    if not mod.Mods[modName] then
        if warn then
        mod.log.warn("Attempted to Enable a non existent mod")
        end
        return
    end
    if not mod.Mods[modName].Removed then
        if warn then
        mod.log.warn("Attempted to Enable an already Enabled Mod")
        end
        return
    end

    if mod.Mods[modName].PreEnableMod then
        mod.Mods[modName].PreEnableMod()
    end

    if mod.Mods[modName].EnableMod then
        mod.Mods[modName].EnableMod()
    else
        for _, callbackData in ipairs(mod.Mods[modName].CallbackFunctions) do
            if callbackData.Priority then
                mod:AddPriorityCallback(callbackData.Callback, callbackData.Priority, callbackData.Function, callbackData.OptionalArgs, modName, true)
            else
                mod:AddCallback(callbackData.Callback, callbackData.Function, callbackData.OptionalArgs, modName, true)
            end
        end
    end

    if mod.Mods[modName].PostEnableMod then
        mod.Mods[modName].PostEnableMod()
    end

    mod.Mods[modName].Removed = true
end

function mod:RemoveMod(modName, warn)
    warn = warn == nil and true or warn
    if type(modName) ~= "string" then
        if warn then
            mod.log.warn("Attempted to Remove an Invalid Mod")
        end
        return
    end
    if not mod.Mods[modName] then
        if warn then
            mod.log.warn("Attempted to Remove a non existent mod")
        end
        return
    end
    if mod.Mods[modName].Removed then
        if warn then
            mod.log.warn("Attempted to Remove an already Removed Mod")
        end
        return
    end

    if mod.Mods[modName].PreRemoveMod then
        mod.Mods[modName].PreRemoveMod()
    end

    if mod.Mods[modName].RemoveMod then
        mod.Mods[modName].RemoveMod()
    else
        for _, callbackData in ipairs(mod.Mods[modName].CallbackFunctions) do
            mod:RemoveCallback(callbackData.Callback, callbackData.Function, modName, true)
        end
    end

    if mod.Mods[modName].PostRemoveMod then
        mod.Mods[modName].PostRemoveMod()
    end

    mod.Mods[modName].Removed = true
end