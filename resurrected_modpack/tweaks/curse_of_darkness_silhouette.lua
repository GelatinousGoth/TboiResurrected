local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Darker Curse of Darkness", 1, true)

local CurseOfDarkness = {}

CurseOfDarkness.color  = Color(0, 0, 0, 0.6, 0, 0, 0)
CurseOfDarkness.color2 = Color(0.1, 0.1, 0.1, 0.7, 0, 0, 0)
CurseOfDarkness.color3 = Color(0.3, 0.3, 0.3, 0.9, 0, 0, 0)
CurseOfDarkness.color4 = Color(0.7, 0.7, 0.7, 1, 0, 0, 0)

CurseOfDarkness.colorsByLevel = {
  [0] = CurseOfDarkness.color,
  [1] = CurseOfDarkness.color2,
  [2] = CurseOfDarkness.color3,
  [3] = CurseOfDarkness.color4,
}

CurseOfDarkness.lightSources = {
  {type = 1, radius = 220, radius2 = 140, radius3 = 110, radius4 = 80 },
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

local function GetSourceRadius(v)
  local radius = {}
  local keys = {"radius", "radius2", "radius3", "radius4"}
  for tier, key in ipairs(keys) do
    if v[key] then
      table.insert(radius, {tier = tier, value = v[key]})
    end
  end
  return radius
end



function CurseOfDarkness.OnUpdate (_)
local curses = (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS)
local darkMod = Game():GetDarknessModifier()

if darkMod ~= 0 or curses ~= 0 then
  local entities = Isaac.FindInRadius(Isaac.GetPlayer(0).Position,1500, EntityPartition.ENEMY | EntityPartition.BULLET | EntityPartition.PICKUP)
  for i,npc in pairs(entities) do
    local data = npc:GetData()
    data.CurseOfDarknessIsInShadows = 0
  end
  for i,v in pairs(CurseOfDarkness.lightSources) do
    for i2,source in pairs(Isaac.FindByType(v.type, v.variant or -1, v.subtype or -1)) do
      local radius = GetSourceRadius(v)
      if v.hitpoints == nil or source.HitPoints >= v.hitpoints then
        for j,r in pairs(radius) do
          for i3, npc in pairs(Isaac.FindInRadius(source.Position,r.value,EntityPartition.ENEMY | EntityPartition.BULLET | EntityPartition.PICKUP )) do
            local data = npc:GetData()
             data.CurseOfDarknessIsInShadows = math.max(data.CurseOfDarknessIsInShadows or 0, r.tier)

          end
        end
      end
    end
  end

 for i, npc in pairs(entities) do
      local data = npc:GetData()
      if npc:HasEntityFlags(EntityFlag.FLAG_BURN) then else
        local color = CurseOfDarkness.colorsByLevel[data.CurseOfDarknessIsInShadows]
        if color then
          npc:SetColor(color, 5, 1, true, false)
        end
    end
  end
end
  
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, CurseOfDarkness.OnUpdate)
