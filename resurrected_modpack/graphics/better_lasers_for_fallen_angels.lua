local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Better Lasers For Fallen Angels"

function mod:ae()
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        if (entities[i].Type == 7) and (entities[i].Variant == 5) and (entities[i].Parent ~= nil) and (entities[i].Parent.Type == 271) and (entities[i].Parent.Variant == 1) then
            entities[i]:SetColor(Color(0.9,0,0,1,0,0,0),155,1,false,false)
        end
        if (entities[i].Type == 7) and (entities[i].Variant == 5) and (entities[i].Parent ~= nil) and (entities[i].Parent.Type == 272) and (entities[i].Parent.Variant == 1) then
            entities[i]:SetColor(Color(0.9,0,0,1,0,0,0),155,1,false,false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE , mod.ae)