local mod = require("resurrected_modpack.mod_reference")

function mod:AddCallback(callbackId, callbackFn, optionalArg, modName, lockCallbackRecord)
    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

    if not mod.RemovedCallbacks[callbackId] then
        mod.RemovedCallbacks[callbackId] = {}

        local function RemoveCallbackManager()
            for _, callbackFn in ipairs(mod.RemovedCallbacks[callbackId]) do
                Isaac.RemoveCallback(self, callbackId, callbackFn)
            end
            mod.RemovedCallbacks[callbackId] = {}
        end
        Isaac.AddPriorityCallback(self, callbackId, -2^52, RemoveCallbackManager)
    end

    Isaac.AddCallback(self, callbackId, callbackFn, optionalArg)

    if lockCallbackRecord then
        return
    end

    if not mod.Mods[modName] then
        mod.Mods[modName] = {}
        mod.Mods[modName].CallbackFunctions = {}
    end
    table.insert(mod.Mods[modName].CallbackFunctions, {Callback = callbackId, Function = callbackFn, OptionalArgs = optionalArg})
end

function mod:AddPriorityCallback(callbackId, priority, callbackFn, optionalArg, modName, lockCallbackRecord)
    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

    if not mod.RemovedCallbacks[callbackId] then
        mod.RemovedCallbacks[callbackId] = {}

        local function RemoveCallbackManager()
            for _, callbackFn in ipairs(mod.RemovedCallbacks[callbackId]) do
                Isaac.RemoveCallback(self, callbackId, callbackFn)
            end
            mod.RemovedCallbacks[callbackId] = {}
        end
        Isaac.AddPriorityCallback(self, callbackId, -2^52, RemoveCallbackManager)
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