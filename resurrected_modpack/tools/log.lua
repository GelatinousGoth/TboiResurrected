local module = {}

local mod = require("resurrected_modpack.mod_reference")

local DefaultModName = "Tboi Resurrected"

local function Print(String)
    Isaac.ConsoleOutput(String .. "\n")
    Isaac.DebugString(String)
end

local function ConsolePrint(String)
    Isaac.ConsoleOutput(String .. "\n")
end

local function LogPrint(String)
    Isaac.DebugString(String)
end

local function PrintError(String, FunctionName, ModName)
    if not ModName then
        ModName = DefaultModName
    end
    if FunctionName then
        Print("[ERROR in " .. ModName .. "." .. FunctionName .. "]: " .. String)
    else
        Print("[ERROR in " .. ModName .. "]: " .. String)
    end
end

local function Diagnostic(Diagnose, String, ModName)
    if not ModName then
        ModName = DefaultModName
    end
    if mod.Diagnostics[Diagnose] then
        Print("[DIAGNOSTICS ".. ModName .."]: " .. String)
    end
end

module.print = Print
module.console = ConsolePrint
module.log = LogPrint
module.error = PrintError
module.diagnostic = Diagnostic

return module