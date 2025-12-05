local TR_Manager = require("resurrected_modpack.manager")
EnhancementChamber = TR_Manager:RegisterMod("Enhancement Chamber", 1, true)

local mod = EnhancementChamber
mod.Version = "v2.0"

-- General Scripts
local scriptList = {"constants", "saveManager", "utils", "compat", "icons"}
for _, script in ipairs(scriptList) do include("resurrected_modpack.tweaks.enhancement_chamber." .. script) end

-- Room Scripts
for room, enabled in pairs(mod.ConfigSpecial) do
    if enabled then
        include("resurrected_modpack.tweaks.enhancement_chamber.rooms." .. room)
    end
end

-- Misc Scripts
for misc, enabled in pairs(mod.ConfigMisc) do
    if enabled then
        include("resurrected_modpack.tweaks.enhancement_chamber.misc." .. misc)
    end
end

-- Startup
mod:Log(mod.Version .. " Loaded")