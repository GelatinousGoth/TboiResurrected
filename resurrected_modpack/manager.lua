---@class TR_Mod
---@field TR_ID integer
---@field Name string
---@field AddCallback function
---@field AddPriorityCallback function
---@field RemoveCallback function
---@field SaveData function
---@field LoadData function
---@field HasData function
---@field RemoveData function
---@field pre_enable_mod function?
---@field post_enable_mod function?
---@field pre_disable_mod function?
---@field post_disable_mod function?

---@class TR_CallbackEntry : CallbackEntry
---@field Callback CallbackID

---@class TR_ModData
---@field Mod TR_Mod
---@field Callbacks TR_CallbackEntry[]
---@field Shaders table<string, function>
---@field SaveData string?
---@field Enabled boolean

---@class TR_ModSaveData
---@field SaveData string?
---@field Enabled boolean

---@class TR_Shader
---@field Function function
---@field DefaultParams table
---@field Enabled boolean

---@class TR_Manager
---@field InitializingModsList integer[]
---@field ModData table<integer, TR_ModData>
---@field Shaders table<string, TR_Shader>

local json = require("json")

---@type ModReference
local TboiRekindled = RegisterMod("Tboi Rekindled", 1)

---@class TR_Manager
local TR_Manager = {
    ModData = {},
    Shaders = {},
    InitializingModsList = {}
}

local function WarningHandler(warning)
    Console.PrintWarning(warning)
    Isaac.DebugString("[WARN]" .. warning .. "\n")
end

local function ErrorHandler(error)
    Console.PrintError(error)
    Isaac.DebugString("[ERROR]" .. error .. "\n")
end

local function AddModToMCM(modId)
    if not ModConfigMenu then
        return
    end

    local modData = TR_Manager.ModData[modId]

    ModConfigMenu.AddSetting("Tboi Rekindled", "Mods", {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        Attribute = tostring(modId),
        CurrentSetting = function ()
            return modData.Enabled
        end,
        Display = function()
            local choice = tostring(modData.Enabled)
            return (modData.Mod.Name) .. ': ' .. choice
        end,
        OnChange = function(currentSetting)
            if currentSetting then
                TR_Manager:EnableMod(modId)
            else
                TR_Manager:DisableMod(modId)
            end
        end,
        Info = function () return "" end
    })
end

local function RemoveModFromMCM(modId)
    if not ModConfigMenu then
        return
    end

    ModConfigMenu.RemoveSetting("Tboi Rekindled", "Mods", tostring(modId))
end

local isFirstShaderWarn = true
local shaderCallbackWarning = [[
[TBOI Rekindled] mod "%s" has registered a shader callback using MC_GET_SHADER_PARAMS, this could cause problems.
If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]]

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param priority CallbackPriority # Default priority is 0, higher goes later, using the CallbackPriority table is recommended
---@param fn function
---@param param any
function TR_Manager:AddCallback(mod, callbackId, priority, fn, param)
    ---@class TR_CallbackEntry
    local callbackEntry = {
        Mod = mod,
        Callback = callbackId,
        Priority = param,
        Function = fn,
        Param = param,
    }

    table.insert(self.ModData[mod.TR_ID].Callbacks, callbackEntry)

    if (self.ModData[mod.TR_ID].Enabled) then
        Isaac.AddPriorityCallback(TboiRekindled, callbackId, priority, fn, param)
    end

    if callbackId == ModCallbacks.MC_GET_SHADER_PARAMS and isFirstShaderWarn then
        WarningHandler(string.format(shaderCallbackWarning, mod.Name))
        isFirstShaderWarn = false
    end
end

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param fn function
function TR_Manager:RemoveCallback(mod, callbackId, fn)
    if not self.ModData[mod.TR_ID] then
        return
    end

    local callbacks = self.ModData[mod.TR_ID].Callbacks

    for i = #callbacks, 1, -1 do
        if (callbacks[i].Function == fn and callbacks[i].Callback == callbackId) then
            table.remove(callbacks, i)
        end
    end

    Isaac.RemoveCallback(TboiRekindled, callbackId, fn)
end

function TR_Manager:SaveData()
    local saveData = {
        ModSaveData = {}
    }

    for _, modData in ipairs(self.ModData) do
        saveData.ModSaveData[modData.Mod.Name] = {}
        ---@type TR_ModSaveData
        local modSaveData = saveData.ModSaveData[modData.Mod.Name]
        modSaveData.SaveData = modData.SaveData
        modSaveData.Enabled = modData.Enabled
    end

    saveData = json.encode(saveData)
    TboiRekindled:SaveData(saveData)
end

local cacheSaveData = false

local function EnableCacheSaveData()
    cacheSaveData = true
end

local function SaveCachedSaveData()
    cacheSaveData = false
    TR_Manager:SaveData()
end

---@param mod TR_Mod
---@param data string
function TR_Manager:SaveModData(mod, data)
    self.ModData[mod.TR_ID].SaveData = data

    -- mods tend to save during two specific callbacks, during those callbacks we wait until all the data has been collected and then we save to file.
    -- however if they save outside of this interval then we will be forced to save the data immediately.
    if not cacheSaveData then
        self:SaveData()
    end
end

local loadedData = false

function TR_Manager:LoadData()
    loadedData = true;

    if not TboiRekindled:HasData() then
        return;
    end

    local encodedData = TboiRekindled:LoadData()
    local success, result = xpcall(json.decode, ErrorHandler, encodedData)
    local data = success and result or {}

    if type(data.ModSaveData) ~= "table" then
        return
    end

    for _, mod in ipairs(self.ModData) do
        ---@type TR_ModSaveData?
        local saveData = data.ModSaveData[mod.Mod.Name]
        if not saveData then
            goto continue
        end

        mod.SaveData = saveData.SaveData
        if mod.Enabled ~= saveData.Enabled then
            if (saveData.Enabled == false) then
                self:DisableMod(mod.Mod.TR_ID)
            else
                self:EnableMod(mod.Mod.TR_ID)
            end
        end

        ::continue::
    end
end

---@param mod TR_Mod
---@return string?
function TR_Manager:LoadModData(mod)
    if not loadedData then
        TR_Manager:LoadData()
    end

    return self.ModData[mod.TR_ID].SaveData
end

---@param mod TR_Mod
---@return boolean
function TR_Manager:HasModData(mod)
    if not loadedData then
        TR_Manager:LoadData()
    end

    return self.ModData[mod.TR_ID].SaveData ~= nil
end

function TR_Manager:RemoveModData(mod)
    if not loadedData then
        TR_Manager:LoadData()
    end

    self.ModData[mod.TR_ID].SaveData = nil
end

local modTemplate = {}

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param fn function
---@param param any
function modTemplate.AddCallback(mod, callbackId, fn, param)
    TR_Manager:AddCallback(mod, callbackId, CallbackPriority.DEFAULT, fn, param)
end

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param priority CallbackPriority # Default priority is 0, higher goes later, using the CallbackPriority table is recommended
---@param fn function
---@param param any
function modTemplate.AddPriorityCallback(mod, callbackId, priority, fn, param)
    TR_Manager:AddCallback(mod, callbackId, priority, fn, param)
end

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param fn function
function modTemplate.RemoveCallback(mod, callbackId, fn)
    TR_Manager:RemoveCallback(mod, callbackId, fn)
end

---@param mod TR_Mod
---@param data string
function modTemplate.SaveData(mod, data)
    TR_Manager:SaveModData(mod, data)
end

---@param mod TR_Mod
---@return string?
function modTemplate.LoadData(mod)
    return TR_Manager:LoadModData(mod)
end

---@param mod TR_Mod
---@return boolean
function modTemplate.HasData(mod)
    return TR_Manager:HasModData(mod)
end

---@param mod TR_Mod
function modTemplate.RemoveData(mod)
    return TR_Manager:RemoveModData(mod)
end

---@param modName string
---@param version integer? # Unused
---@return table
function TR_Manager:RegisterMod(modName, version)
    ---@type TR_Mod
    local mod = {
        TR_ID = #TR_Manager.ModData + 1,
        Name = modName,
        AddCallback = modTemplate.AddCallback,
        AddPriorityCallback = modTemplate.AddPriorityCallback,
        RemoveCallback = modTemplate.RemoveCallback,
        SaveData = modTemplate.SaveData,
        LoadData = modTemplate.LoadData,
        HasData = modTemplate.HasData,
        RemoveData = modTemplate.RemoveData
    }

    ---@type TR_ModData
    local modData = {
        Mod = mod,
        Callbacks = {},
        Shaders = {},
        SaveData = nil,
        Enabled = true,
    }

    self.ModData[mod.TR_ID] = modData

    table.insert(self.InitializingModsList, mod.TR_ID)

    AddModToMCM(mod.TR_ID)

    return mod
end

---@param modId integer
function TR_Manager:EnableMod(modId)
    local modData = self.ModData[modId]
    if modData.Enabled then
        return
    end

    for _, shaderName in ipairs(modData.Shaders) do
        self.Shaders[shaderName].Enabled = true
    end

    if type(modData.Mod.pre_enable_mod) == "function" then
        local success, result = xpcall(modData.Mod.pre_enable_mod, ErrorHandler, modData.Mod)
        if success and result then
            return
        end
    end

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:AddPriorityCallback(callback.Callback, callback.Priority, callback.Function, callback.Param)
    end

    if type(modData.Mod.post_enable_mod) == "function" then
        xpcall(modData.Mod.pre_enable_mod, ErrorHandler, modData.Mod)
    end

    modData.Enabled = true
end

---@param modId integer
function TR_Manager:DisableMod(modId)
    local modData = self.ModData[modId]
    if not modData.Enabled then
        return
    end

    for _, shaderName in ipairs(modData.Shaders) do
        self.Shaders[shaderName].Enabled = false
    end

    if type(modData.Mod.pre_disable_mod) == "function" then
        local success, result = xpcall(modData.Mod.pre_disable_mod, ErrorHandler, modData.Mod)
        if success and result then
            return
        end
    end

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    if type(modData.Mod.post_disable_mod) == "function" then
        xpcall(modData.Mod.pre_disable_mod, ErrorHandler, modData.Mod)
    end

    modData.Enabled = false
end

---@param modId integer
local function DeleteMod(modId)
    local modData = TR_Manager.ModData[modId]

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    table.remove(TR_Manager.ModData, modId)

    RemoveModFromMCM(modId)
end

local loadErrorMessage = [[
[TBOI Rekindled] Something went wrong when loading a mod:
ModPath : %s
Error: %s
If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page. ]]

local function LoadErrorHandler(error, path)
    local message = string.format(loadErrorMessage, path, error)
    ErrorHandler(message)
end

---@param path string
function TR_Manager:LoadMod(path)
    self.InitializingModsList = {}
    if not xpcall(require, function(err) LoadErrorHandler(err, tostring(path)) end, path) then
        for i = #self.InitializingModsList, 1, -1 do
            DeleteMod(self.InitializingModsList[i])
        end
    end
    self.InitializingModsList = {}
end

local shaderRegisterWarnings = {
    [1] = [[
    [TBOI Rekindled] mod "%s" has registered shader "%s" without any Default Parameters.
    If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]],

    [2] = [[
    [TBOI Rekindled] mod "%s" has registered a shader with no name.
    If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]],

    [3] = [[
    [TBOI Rekindled] mod "%s" has registered shader "%s" without any Function.
    If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]],

    [4] = [[
    [TBOI Rekindled] shader "%s" was registered without a mod.
    If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]],
}

---@param mod TR_Mod | ModReference
---@param shaderName string
---@param shaderFun function
---@param defaultParams table
function TR_Manager:RegisterShader(mod, shaderName, shaderFun, defaultParams)
    if type(defaultParams) ~= "table"  then
        WarningHandler(string.format(shaderRegisterWarnings[1], tostring(mod.Name), tostring(shaderName)))
        return
    end

    if type(shaderName) ~= "string" then
        WarningHandler(string.format(shaderRegisterWarnings[2], tostring(mod.Name)))
        return
    end

    if type(shaderFun) ~= "function" then
        WarningHandler(string.format(shaderRegisterWarnings[3], tostring(mod.Name), tostring(shaderName)))
        return
    end

    if type(mod) ~= "table" and not mod.TR_ID then
        WarningHandler(string.format(shaderRegisterWarnings[4], tostring(shaderName)))
        return
    end

    self.Shaders[shaderName] = {
        Function = shaderFun,
        DefaultParams = defaultParams,
        Enabled = self.ModData[mod.TR_ID].Enabled
    }

    table.insert(self.ModData[mod.TR_ID].Shaders, shaderName)
end

local function ShaderManager(_, shaderName)
    if not TR_Manager.Shaders[shaderName] then
        return
    end

    local shaderData = TR_Manager.Shaders[shaderName]

    if not shaderData.Enabled then
        return shaderData.DefaultParams
    end

    local success, result = xpcall(shaderData.Function, ErrorHandler)
    if not success or type(result) ~= "table" then
        return shaderData.DefaultParams
    else
        return result
    end
end

function TR_Manager:Init()
    TboiRekindled:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, ShaderManager)

    TboiRekindled:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, -math.huge, EnableCacheSaveData)
    TboiRekindled:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, -math.huge, EnableCacheSaveData)
    TboiRekindled:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, math.huge, SaveCachedSaveData)
    TboiRekindled:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, math.huge, SaveCachedSaveData)

    TboiRekindled:AddPriorityCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, -math.huge, function() TR_Manager:LoadData() end)

    Isaac.DebugString("[Tboi Rekindled] \"Tboi Rekindled\" initialized.\n")
end

return TR_Manager;