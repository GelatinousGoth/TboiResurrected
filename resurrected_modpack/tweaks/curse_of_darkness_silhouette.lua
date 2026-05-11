local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Darker Curse of Darkness", 1, true)

local CurseOfDarkness = {}
CurseOfDarkness.color = Color(0,0,0,0.6,0,0,0)
CurseOfDarkness.color2 = Color(0.3,0.3,0.3,0.9,0,0,0)

CurseOfDarkness.lightSources = {
  {type = 1, radius = 200, radius2 = 120 },
  {type = 3, variant = 201, subtype = 13, radius = 50 },
  {type = EntityType.ENTITY_HORF, variant = Isaac.GetEntityVariantByName("Flaming Horf"), radius = 70 },
  {type = EntityType.ENTITY_FLAMINGHOPPER, radius = 70 },
  {type = EntityType.ENTITY_GAPER, variant = 2, radius = 70 },
  {type = EntityType.ENTITY_FATTY, variant = 2, radius = 70 },
  {type = EntityType.ENTITY_CLOTTY, variant = 3, radius = 70 },
  {type = 818, variant = 2, radius = 70 }, -- coal spiders
  {type = 824, variant = 1, radius = 70 }, -- grilled gyro
  {type = 33, hitpoints = 2 , radius = 70 },
  {type = 7, radius = 60 },
  {type = 2, variant = 5, radius = 90 },
  {type = 2, variant = 46, radius = 90 },
  {type = 2, variant = 49, radius = 90 },
  {type = 2, variant = 47, radius = 50 },
  {type = 2, variant = 7, radius = 60 },
  {type = 1000, variant = 1, radius = 120 } -- bomb explosions
  }




function CurseOfDarkness.OnUpdate (_)
  if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS ~= 0 then

  local entities = Isaac.FindInRadius(Isaac.GetPlayer(0).Position,1500, EntityPartition.ENEMY | EntityPartition.BULLET | EntityPartition.PICKUP)
  for i,npc in pairs(entities) do
    local data = npc:GetData()
    data.CurseOfDarknessIsInShadows = 0
  end
  for i,v in pairs(CurseOfDarkness.lightSources) do
    for i2,source in pairs(Isaac.FindByType(v.type, v.variant or -1, v.subtype or -1)) do
      local radius = v.radius or 50
      local radii = {radius,v.radius2 or radius/2}
      if v.hitpoints == nil or source.HitPoints >= v.hitpoints then
        for j,r in pairs(radii) do
          for i3, npc in pairs(Isaac.FindInRadius(source.Position,r,EntityPartition.ENEMY | EntityPartition.BULLET | EntityPartition.PICKUP )) do
            local data = npc:GetData()
             data.CurseOfDarknessIsInShadows = math.max(data.CurseOfDarknessIsInShadows or 0, j)

          end
        end
      end
    end
  end
  
  for i,npc in pairs(entities) do
    local data = npc:GetData()
    if npc:HasEntityFlags(EntityFlag.FLAG_BURN) then
    elseif data.CurseOfDarknessIsInShadows == 0 then
      npc:SetColor(CurseOfDarkness.color,5,1,true,false) 
    elseif data.CurseOfDarknessIsInShadows == 1 then
      npc:SetColor(CurseOfDarkness.color2,5,1,true,false) 
    end
  end
  
  end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CurseOfDarkness.OnUpdate)
