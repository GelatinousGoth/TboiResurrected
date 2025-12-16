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
---@field ForceDisable boolean
---@field HasToggle boolean

---@class TR_ModSaveData
---@field SaveData string?
---@field Enabled boolean

---@class TR_Shader
---@field Function function?
---@field DefaultParams table
---@field Enabled boolean

---@class TR_Manager
---@field InitializingModsList integer[]
---@field ModData table<integer, TR_ModData>
---@field Shaders table<string, TR_Shader>
---@field DssMenuData table

local json = require("json")
local dssmenucore = require("resurrected_modpack.vendor.dssmenucore")

---@type ModReference
local TboiRekindled = RegisterMod("Tboi Rekindled", 1)

---@class TR_Manager
local TR_Manager = {
    ModData = {},
    Shaders = {},
    InitializingModsList = {},
    DssMenuData = {}
}

local function is_mod_enabled(id)
    local modData = TR_Manager.ModData[id]
    return modData.Enabled and not modData.ForceDisable
end

---@type DSSMenuProvider
local DSSMenuProvider = {
    GetGamepadToggleSetting = function ()
        return TR_Manager.DssMenuData.GamepadToggleSetting
    end,
    GetHudOffsetSetting = function ()
        return TR_Manager.DssMenuData.HudOffsetSetting
    end,
    GetMenuBuzzerSetting = function ()
        return TR_Manager.DssMenuData.MenuBuzzerSetting
    end,
    GetMenuHintSetting = function ()
        return TR_Manager.DssMenuData.MenuHintSetting
    end,
    GetMenuKeybindSetting = function ()
        return TR_Manager.DssMenuData.MenuKeybindSetting
    end,
    GetMenusNotified = function ()
        return TR_Manager.DssMenuData.MenusNotified
    end,
    GetMenusPoppedUp = function ()
        return TR_Manager.DssMenuData.MenusPoppedUp
    end,
    GetPaletteSetting = function ()
        return TR_Manager.DssMenuData.PalletteSetting
    end,
    SaveGamepadToggleSetting = function (gamepadToggleSetting)
        TR_Manager.DssMenuData.GamepadToggleSetting = gamepadToggleSetting
    end,
    SaveHudOffsetSetting = function (hudOffsetSetting)
        TR_Manager.DssMenuData.HudOffsetSetting = hudOffsetSetting
    end,
    SaveMenuBuzzerSetting = function (menuBuzzerSetting)
        TR_Manager.DssMenuData.MenuBuzzerSetting = menuBuzzerSetting
    end,
    SaveMenuHintSetting = function (menuHintSetting)
        TR_Manager.DssMenuData.MenuHintSetting = menuHintSetting
    end,
    SaveMenuKeybindSetting = function (menuKeybindSetting)
        TR_Manager.DssMenuData.MenuKeybindSetting = menuKeybindSetting
    end,
    SaveMenusNotified = function (menusNotified)
        TR_Manager.DssMenuData.MenusNotified = menusNotified
    end,
    SaveMenusPoppedUp = function (menusPoppedUp)
        TR_Manager.DssMenuData.MenusPoppedUp = menusPoppedUp
    end,
    SavePaletteSetting = function (paletteSetting)
        TR_Manager.DssMenuData.PalletteSetting = paletteSetting
    end,
    SaveSaveData = function()
        TR_Manager:SaveData()
    end
}

local dssmod = dssmenucore.init("Dead Sea Scrolls (Tboi Rekindled)", DSSMenuProvider)

local function warning_handler(warning)
    Console.PrintWarning(warning)
    Isaac.DebugString("[WARN]" .. warning .. "\n")
end

local function error_handler(error)
    Console.PrintError(error)
    Isaac.DebugString("[ERROR]" .. error .. "\n")
end

local function add_mod_to_mcm(modId)
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

local function remove_mod_from_mcm(modId)
    if not ModConfigMenu then
        return
    end

    ModConfigMenu.RemoveSetting("Tboi Rekindled", "Mods", tostring(modId))
end

local dssDirectory = {}

dssDirectory.main = {
    title = "tboi rekindled",
    buttons = {
        {str = "resume game", action = "resume"},
        {str = "settings", dest = "menusettings"},
        dssmod.changelogsButton,
        {str = '', nosel = true},
        {str = "mods", dest = "mods", tooltip = { strset = {'enable',  'or', 'disable', 'individual', 'mods' }}},
    },
    tooltip = dssmod.menuOpenToolTip
}

---Must be defined so that DssMenu settings can be changed if we are the only mod using it.
dssDirectory.menusettings = {
    title = 'menu settings',
    buttons = {
        dssmod.hudOffsetButton,
        dssmod.gamepadToggleButton,
        dssmod.menuKeybindButton,
        dssmod.menuHintButton,
        dssmod.menuBuzzerButton,
        dssmod.paletteButton
    },
    tooltip = dssmod.menuOpenToolTip
}

dssDirectory.mods = {
    title = "mods",
    buttons = {
        {str = "resume game", action = "resume"},
        {str = '', nosel = true}
    },
    tooltip = dssmod.menuOpenToolTip
}

local function add_mod_to_dss(modId)
    local modData = TR_Manager.ModData[modId]

    local button = {
        str = string.lower(modData.Mod.Name),
        fsize = 1,
        choices = {'enabled', 'disabled'},
        variable = "Tboi Rekindled (" .. modData.Mod.Name .. ")",
        setting = 1,
        load = function ()
            return modData.Enabled and 1 or 2
        end,
        store = function (var)
        end,
        func = function(button)
            if button.setting == 1 then
                TR_Manager:EnableMod(modId)
            else
                TR_Manager:DisableMod(modId)
            end
        end,
    }

    if (#dssDirectory.mods.buttons > 2) then
        table.insert(dssDirectory.mods.buttons, {str = "", fsize = 1, nosel = true})
    end
    table.insert(dssDirectory.mods.buttons, button)
end

local function remove_mod_from_dss(modId)
    local modName = string.lower(TR_Manager.ModData[modId].Mod.Name)

    for index, button in ipairs(dssDirectory.mods.buttons) do
        if button.str == modName then
            table.remove(dssDirectory.mods.buttons, index)
            break;
        end
    end
end

local isFirstShaderWarn = true
local shaderCallbackWarning = [[
[TBOI Rekindled] mod "%s" has registered a shader callback using MC_GET_SHADER_PARAMS, this could cause problems.
If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page.]]

---@param manager TR_Manager
---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param priority CallbackPriority # Default priority is 0, higher goes later, using the CallbackPriority table is recommended
---@param fn function
---@param param any
local function add_mod_callback(manager, mod, callbackId, priority, fn, param)
    ---@class TR_CallbackEntry
    local callbackEntry = {
        Mod = mod,
        Callback = callbackId,
        Priority = param,
        Function = fn,
        Param = param,
    }

    table.insert(manager.ModData[mod.TR_ID].Callbacks, callbackEntry)

    if is_mod_enabled(mod.TR_ID) then
        Isaac.AddPriorityCallback(mod, callbackId, priority, fn, param)
    end
end

---@param mod TR_Mod
---@param callbackId CallbackID # Vanilla IDs are integers, custom IDs can be any type including strings
---@param priority CallbackPriority # Default priority is 0, higher goes later, using the CallbackPriority table is recommended
---@param fn function
---@param param any
function TR_Manager:AddCallback(mod, callbackId, priority, fn, param)
    add_mod_callback(self, mod, callbackId, priority, fn, param)

    if callbackId == ModCallbacks.MC_GET_SHADER_PARAMS and isFirstShaderWarn then
        warning_handler(string.format(shaderCallbackWarning, mod.Name))
        isFirstShaderWarn = false
    end
end

---@param mod TR_Mod
---@param priority CallbackPriority # Default priority is 0, higher goes later, using the CallbackPriority table is recommended
---@param fn function
---@param param any
function TR_Manager:AddSafeShaderCallback(mod, priority, fn, param)
    add_mod_callback(self, mod, ModCallbacks.MC_GET_SHADER_PARAMS, priority, fn, param)
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

    Isaac.RemoveCallback(mod, callbackId, fn)
end

function TR_Manager:SaveData()
    local saveData = {
        ModSaveData = {},
        DssMenuData = self.DssMenuData
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

local function apply_mod_save_data(modSaveData)
    if type(modSaveData) ~= "table" then
        return
    end

    for _, mod in ipairs(TR_Manager.ModData) do
        ---@type TR_ModSaveData?
        local saveData = modSaveData[mod.Mod.Name]
        if not saveData then
            goto continue
        end

        mod.SaveData = saveData.SaveData
        if mod.Enabled ~= saveData.Enabled then -- Current Status different from saveData
            if not saveData.Enabled then
                TR_Manager:DisableMod(mod.Mod.TR_ID)
            else
                TR_Manager:EnableMod(mod.Mod.TR_ID)
            end
        end

        ::continue::
    end
end

function TR_Manager:LoadData()
    loadedData = true;

    if not TboiRekindled:HasData() then
        return;
    end

    local encodedData = TboiRekindled:LoadData()
    local success, result = xpcall(json.decode, error_handler, encodedData)
    local data = success and result or {}

    apply_mod_save_data(data.ModSaveData)
    if type(data.DssMenuData) == "table" then
        self.DssMenuData = data.DssMenuData
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
---@param hasToggle boolean?
---@return table | ModReference
function TR_Manager:RegisterMod(modName, version, hasToggle)
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
        ForceDisable = false,
        HasToggle = hasToggle or false
    }

    self.ModData[mod.TR_ID] = modData

    table.insert(self.InitializingModsList, mod.TR_ID)

    if hasToggle then
        add_mod_to_mcm(mod.TR_ID)
        add_mod_to_dss(mod.TR_ID)
    end

    return mod
end

---@param modId integer
function TR_Manager:EnableMod(modId)
    local modData = self.ModData[modId]
    if modData.Enabled or modData.ForceDisable then
        return
    end

    for _, shaderName in ipairs(modData.Shaders) do
        self.Shaders[shaderName].Enabled = true
    end

    if type(modData.Mod.pre_enable_mod) == "function" then
        local success, result = xpcall(modData.Mod.pre_enable_mod, error_handler, modData.Mod)
        if success and result then
            return
        end
    end

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:AddPriorityCallback(callback.Callback, callback.Priority, callback.Function, callback.Param)
    end

    if type(modData.Mod.post_enable_mod) == "function" then
        xpcall(modData.Mod.pre_enable_mod, error_handler, modData.Mod)
    end

    modData.Enabled = true
end

---@param manager TR_Manager
---@param modData TR_ModData
local function disable_mod(manager, modData)
    for _, shaderName in ipairs(modData.Shaders) do
        manager.Shaders[shaderName].Enabled = false
    end

    if type(modData.Mod.pre_disable_mod) == "function" then
        local success, result = xpcall(modData.Mod.pre_disable_mod, error_handler, modData.Mod)
        if success and result then
            return
        end
    end

    for _, callback in ipairs(modData.Callbacks) do
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    if type(modData.Mod.post_disable_mod) == "function" then
        xpcall(modData.Mod.pre_disable_mod, error_handler, modData.Mod)
    end
end

---@param modId integer
function TR_Manager:DisableMod(modId)
    local modData = self.ModData[modId]
    if not modData.Enabled or not modData.HasToggle or modData.ForceDisable then
        return
    end

    disable_mod(self, modData)

    modData.Enabled = false
end

function TR_Manager:ForceDisable(modId)
    local modData = self.ModData[modId]
    if modData.ForceDisable then
        return
    end

    disable_mod(self, modData)

    modData.ForceDisable = true
end

---@param modId integer
local function delete_mod(modId)
    local modData = TR_Manager.ModData[modId]

    for _, callback in ipairs(modData.Callbacks) do
---@diagnostic disable-next-line: param-type-mismatch
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    for _, callback in ipairs(modData.Callbacks) do
---@diagnostic disable-next-line: param-type-mismatch
        TboiRekindled:RemoveCallback(callback.Callback, callback.Function)
    end

    if modData.HasToggle then
        remove_mod_from_mcm(modId)
        remove_mod_from_dss(modId)
    end

    table.remove(TR_Manager.ModData, modId)

end

local loadErrorMessage = [[
[TBOI Rekindled] Something went wrong when loading a mod:
ModPath : %s
Error: %s
If you are seeing this message please notify the developers of Tboi Rekindled through the Steam Workshop page. ]]

local function load_error_handler(error, path)
    local message = string.format(loadErrorMessage, path, error)
    error_handler(message)
end

---@param path string
function TR_Manager:LoadMod(path)
    self.InitializingModsList = {}
    if not xpcall(require, function(err) load_error_handler(err, tostring(path)) end, path) then
        for i = #self.InitializingModsList, 1, -1 do
            delete_mod(self.InitializingModsList[i])
        end
    end
    self.InitializingModsList = {}
end

---@param shaderName string
---@param defaultParams table
function TR_Manager:RegisterShader(shaderName, defaultParams)
    if self.Shaders[shaderName] then
        warning_handler(string.format("[TBOI Rekindled] shader \"%s\" already exists, skipping registration.", shaderName))
        return
    end

    self.Shaders[shaderName] = {
        Function = nil,
        DefaultParams = defaultParams,
        Enabled = false,
    }
end

local shaderRegisterWarnings = {
    [1] = [[
    [TBOI Rekindled] mod "%s" has registered a shader that doesn't exist "%s".
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
function TR_Manager:RegisterShaderFunction(mod, shaderName, shaderFun)
    if type(shaderName) ~= "string" then
        warning_handler(string.format(shaderRegisterWarnings[2], tostring(mod.Name)))
        return
    end

    local shader = self.Shaders[shaderName]
    if not shader then
        warning_handler(string.format(shaderRegisterWarnings[1], tostring(mod.Name), tostring(shaderName)))
        return
    end

    if type(shaderFun) ~= "function" then
        warning_handler(string.format(shaderRegisterWarnings[3], tostring(mod.Name), tostring(shaderName)))
        return
    end

    if type(mod) ~= "table" and not mod.TR_ID then
        warning_handler(string.format(shaderRegisterWarnings[4], tostring(shaderName)))
        return
    end

    shader.Function = shaderFun
    shader.Enabled = is_mod_enabled(mod.TR_ID)

    table.insert(self.ModData[mod.TR_ID].Shaders, shaderName)
end

local function ShaderManager(_, shaderName)
    if not TR_Manager.Shaders[shaderName] then
        return
    end

    local shaderData = TR_Manager.Shaders[shaderName]

    if not shaderData.Enabled or not shaderData.Function then
        return shaderData.DefaultParams
    end

    local success, result = xpcall(shaderData.Function, error_handler)
    if not success or type(result) ~= "table" then
        return shaderData.DefaultParams
    else
        return result
    end
end

---@return DSSMod
function TR_Manager:GetDSSMod()
    return dssmod
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

local dssDirectoryKey = {
    Item = dssDirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {}
}

local dssMenu = {
    Run = dssmod.runMenu,
    Open = dssmod.openMenu,
    Close = dssmod.closeMenu,
    Directory = dssDirectory,
    DirectoryKey = dssDirectoryKey,
    UseSubMenu = true
}

DeadSeaScrollsMenu.AddMenu("Tboi Rekindled", dssMenu)

---@param name string
---@return integer?
function TR_Manager:GetModIdByName(name)
    for k, v in pairs(self.ModData) do
        local mod = v.Mod
        if mod.Name == name then
            return v.Mod.TR_ID
        end
    end
end

return TR_Manager