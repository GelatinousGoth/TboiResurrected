local TR_Manager = require("resurrected_modpack.manager")
HUSHS_ITEMPOOL = TR_Manager:RegisterMod("Hush's Item Pool", 1, true)

HUSHS_ITEMPOOL.ItemPool = Isaac.GetPoolIdByName("blueWomb")

for _, filename in ipairs({
    "itempool_override",
    "pandoras_box",
    "door_resprite",
}) do
    include("resurrected_modpack.tweaks.hush_itempool_code." .. filename)
end