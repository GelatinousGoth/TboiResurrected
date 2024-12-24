local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Tainted Lost Death Animation", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, p)
  if p:GetPlayerType()==PlayerType.PLAYER_THELOST_B then
    p:GetSprite():ReplaceSpritesheet(13,"taintedlostdeathanim.png")
    p:GetSprite():LoadGraphics()
  end
end)
--I hate the fact that I need to do that with Lua
--Please Nicalis add customsuffixes to every character