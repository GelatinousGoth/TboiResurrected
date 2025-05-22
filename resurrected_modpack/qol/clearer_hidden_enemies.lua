local TR_Manager = require("resurrected_modpack.manager")
local Mod = TR_Manager:RegisterMod("Clearer Hidden Enemies", 1)

local transparent = Color(0, 0, 0, 0)

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  -- needle
  for _, ent in ipairs(Isaac.FindByType(881)) do
    if not ent.Visible and ent.FrameCount % 3 == 0 then
      local rock = Isaac.Spawn(1000, 4, 0, ent.Position, Vector.FromAngle(math.random() * 360):Resized(3), ent):ToEffect()
      rock:SetColor(transparent, 1, -99, false, true)
      rock:GetData().nomorehiddenentities_rock = true
      rock:GetData().nomorehiddenentities_rockscale = 1
    end
  end
  
  -- pin
  for _, ent in ipairs(Isaac.FindByType(62)) do
    if ((ent:GetSprite():GetAnimation() == 'HeadWiggle' or ent:GetSprite():GetAnimation() == 'Body1Wiggle') and not ent:IsVulnerableEnemy()) and ent.FrameCount % 3 == 0 then
      local rock = Isaac.Spawn(1000, 4, 0, ent.Position, Vector.FromAngle(math.random() * 360):Resized(3), ent):ToEffect()
      rock:SetColor(transparent, 1, -99, false, true)
      rock:GetData().nomorehiddenentities_rock = true
      rock:GetData().nomorehiddenentities_rockscale = 1.5
    end
  end
  
  -- polycephalus
  for _, ent in ipairs(Isaac.FindByType(269)) do
    if not ent:IsVulnerableEnemy() and ent.FrameCount % 3 == 0 then
      local rock = Isaac.Spawn(1000, 4, 0, ent.Position, Vector.FromAngle(math.random() * 360):Resized(2), ent):ToEffect()
      rock:SetColor(transparent, 1, -99, false, true)
      rock:GetData().nomorehiddenentities_rock = true
      rock:GetData().nomorehiddenentities_rockscale = 1.5
    end
  end
  
  -- the stain
  for _, ent in ipairs(Isaac.FindByType(401)) do
    if not ent:IsVulnerableEnemy() and ent.FrameCount % 3 == 0 then
      local rock = Isaac.Spawn(1000, 4, 0, ent.Position, Vector.FromAngle(math.random() * 360):Resized(2), ent):ToEffect()
      rock:SetColor(transparent, 1, -99, false, true)
      rock:GetData().nomorehiddenentities_rock = true
      rock:GetData().nomorehiddenentities_rockscale = 1.5
    end
  end
end)

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, rock)
  if rock:GetData().nomorehiddenentities_rock then
    rock:GetData().nomorehiddenentities_rockscale = rock:GetData().nomorehiddenentities_rockscale * 0.95
    local scale = rock:GetData().nomorehiddenentities_rockscale
    rock:GetSprite().Scale = Vector(scale, scale)
    if scale < 0.05 then rock:Remove(); rock:Die(); rock:Kill() end
  end
end, 4)
