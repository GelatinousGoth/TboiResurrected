local TR_Manager = require("resurrected_modpack.manager")
ItemPedestalOverhaul = TR_Manager:RegisterMod("Item Pedestal Overhaul", 1)
local game = Game()

-- Item Pedestal Overhaul
local scriptList = {"constants", "save", "config", "pedestal"}

for _, script in ipairs(scriptList) do
    include("resurrected_modpack.graphics.item_pedestal_overhaul." .. script)
end