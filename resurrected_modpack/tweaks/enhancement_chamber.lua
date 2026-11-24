local TR_Manager = require("resurrected_modpack.manager")
EnhancementChamber = TR_Manager:RegisterMod("Enhancement Chamber", 1, true)

local mod = EnhancementChamber
mod.Version = "v2.0.4"

-- General Scripts
local scriptList = {"constants", "utils", "saveManager", "compat", "icons"}
for _, script in ipairs(scriptList) do include("resurrected_modpack.tweaks.enhancement_chamber." .. script) end

-- Room modules
local roomModules = {
    "ambush", "blackmarket", "boss", "bossrush", "curse", "dice",
    "error", "grave", "library", "sacrifice", "shop"
}
for _, room in ipairs(roomModules) do include("resurrected_modpack.tweaks.enhancement_chamber.rooms." .. room) end

-- Miscellaneous
local others = {"itemSound", "redHeartDamage"}
for _, misc in ipairs(others) do
    include("resurrected_modpack.tweaks.enhancement_chamber.misc." .. misc)
end

-- Startup
mod:Log(mod.Version .. " Loaded")