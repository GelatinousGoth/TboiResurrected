local mod = require("resurrected_modpack.mod_reference")

function mod:AddCallback(callbackId, callbackFn, optionalArg, modName, lockCallbackRecord)
    modName = modName or mod.CurrentModName
    lockCallbackRecord = lockCallbackRecord == nil and mod.LockCallbackRecord or lockCallbackRecord

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

    Isaac.AddPriorityCallback(self, callbackId, priority, callbackFn, optionalArg)

    if lockCallbackRecord then
        return
    end

    if not mod.Mods[modName] then
        mod.Mods[modName] = {}
        mod.Mods[modName].CallbackFunctions = {}
    end
    table.insert(mod.Mods[modName].CallbackFunctions, {Callback = callbackId, Priority = priority, Function = callbackFn, OptionalArgs = optionalArg})
end