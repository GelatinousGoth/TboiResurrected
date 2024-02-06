local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "HUD Toggle"

--Set key binding
 local hudToggleButton = Keyboard.KEY_H

 local game = Game()
 local seeds = game:GetSeeds()
 local hudOn = true
 
 function onUpdate()
     if Input.IsButtonPressed(hudToggleButton, 0) then 
         pressCount = pressCount + 1
     else
         pressCount = 0
     end
     
     if pressCount == 1 then
         if hudOn ~= false then
             seeds:AddSeedEffect(SeedEffect.SEED_NO_HUD)
             hudOn = false
         else
             seeds:RemoveSeedEffect(SeedEffect.SEED_NO_HUD)
             hudOn = true
         end
     end	
 end
 
 mod:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)