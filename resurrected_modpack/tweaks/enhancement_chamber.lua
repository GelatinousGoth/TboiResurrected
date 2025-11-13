local TR_Manager = require("resurrected_modpack.manager")
EnhancementChamber = TR_Manager:RegisterMod("Enhancement Chamber", 1, true)

local mod = EnhancementChamber
mod.Version = "v1.7.3"

-- General Scripts --
local scriptList = {"constants", "utils", "compat", "icons"}
for _, script in ipairs(scriptList) do include("resurrected_modpack.tweaks.enhancement_chamber." .. script) end

-- Room Scripts --
for _, room in pairs(mod.ConfigSpecialOrder) do include("resurrected_modpack.tweaks.enhancement_chamber.rooms." .. room) end

-- Startup --
local startDebug = mod.Name .. " " .. mod.Version .. " Loaded"
Isaac.DebugString(startDebug)
print(startDebug)