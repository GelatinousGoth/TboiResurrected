local TR_Manager = require("resurrected_modpack.manager")
local KissyMod = TR_Manager:RegisterMod("Kissy Longlegs", 1, true)

local ModName = "Kissy Longlegs"

local SaveState = {}
local json = require("json")

--Static Variables
local SpawnPos = Vector(0, 0)
local animFrames = 25;

--General Kissy Settings
local KissySettings = {
  ["KissChance"] = 100, --Percentage chance that Sissy will give a kiss.
  ["KissSound"] = true, --Do you want the kiss to make a sound?
  ["SplashEffect"] = true, --Do you want the kiss to make a tiny wet splash effect?
  ["CharmEffect"] = true, --Do you want the kiss to make Isaac charmed briefly?
  ["ThumbsUp"] = true, --Should Isaac give a thumbs-up when he gets kissed?
  ["SpawnTimerReset"] = true, --Should Sissy's spawn timer reset when you get kissed?
  ["SissyApproaches"] = true, --Should Sissy's spawn timer reset when you get kissed?
  ["SassyTransformation"] = 1, --0=No Transform, 1=Transform when Isaac gets glasses, 2=Always Sassy.
  ["IsaacDoesntLikeSassy"] = false --Um.
}

--List of items that will transform Sassy
local SassyList = { 
  "Mom's Lipstick",
  "Mom's Eyeshadow"
}

--First-time run stuff
function KissyMod:Initialize()
  math.randomseed(Isaac.GetTime())

  if KissyMod:HasData() then	
    SaveState = json.decode(KissyMod:LoadData())	
    for i, v in pairs(SaveState.Settings) do
      KissySettings[tostring(i)] = SaveState.Settings[i]
    end
    for i, v in pairs(SaveState.Items) do
      SassyList[i] = SaveState.Items[i]
    end
  else
    KissyMod:SaveGame()
  end
    
  --Configure the options menu.
  if ModConfigMenu and not ModConfigMenu.GetCategoryIDByName(ModName) then
    ModConfigMenu.UpdateCategory(ModName, {
      Info = {"Settings related to spiders that kiss you.",}
    })
    
    ModConfigMenu.AddText(ModName, "Settings", function() return "Kissy Longlegs General Settings" end)
    ModConfigMenu.AddSpace(ModName, "Settings")
	KissyMod:AddMenuItemInt("KissChance", "Kiss chance: ", "Percentage chance that Sissy gives a kiss after clearing a room.", 100)
    KissyMod:AddMenuItemBool("KissSound", "Kiss sound: ", "Enables the kiss sound effect.")
    KissyMod:AddMenuItemBool("SplashEffect", "Splash effect: ", "Enables a little water splash effect.")
    KissyMod:AddMenuItemBool("CharmEffect", "Charm effect: ", "Makes Isaac becomes charmed briefly by a kiss (no real effect).")
    KissyMod:AddMenuItemBool("ThumbsUp", "GAMEPLAY - Thumbs Up: ", "Whether Isaac does a happy animation. Can interrupt gameplay.")
    KissyMod:AddMenuItemBool("SpawnTimerReset", "GAMEPLAY - Spawn Timer Reset: ", "Whether Sissy's kiss resets her respawn timer.")
    KissyMod:AddMenuItemBool("SissyApproaches", "GAMEPLAY - Sissy Approaches: ", "Whether Sissy walks towards Isaac to give him a kiss.")
    KissyMod:AddMenuItemInt("SassyTransformation", "Sassy Transformation: ", "0=No Sassy, 1=Sassy when Isaac has Mom's Lipstick/Eyeshadow, 2=Always Sassy", 2)
    KissyMod:AddMenuItemBool("IsaacDoesntLikeSassy", "Isaac Doesn't Like Sassy: ", "Requested feature. Isaac reacts negatively instead when Sassy kisses him. (Don't ask)")
    
    ModConfigMenu.AddText(ModName, "Items", function() return "Sassy Transformation Items List" end)
    ModConfigMenu.AddSpace(ModName, "Items")
    ModConfigMenu.AddText(ModName, "Items", function() return "Editing unsupported here. Edit save1.dat" end)
    ModConfigMenu.AddText(ModName, "Items", function() return "in 'data/kissy longlegs' to add new items." end)
    ModConfigMenu.AddSpace(ModName, "Items")
    for i, v in pairs(SassyList) do
      KissyMod:AddSassyItem(i, v)
    end
  end
end

--Modular function for adding boolean menu options.
function KissyMod:AddMenuItemBool(settingName, settingText, infoText)
  ModConfigMenu.AddSetting(ModName, "Settings", {
    
    Type = ModConfigMenu.OptionType.BOOLEAN,
    
    CurrentSetting = function()
      return KissySettings[settingName]
    end,
    
    Display = function()
      return settingText .. tostring(KissySettings[settingName])
    end,
    
    OnChange = function(currentBool)
      KissySettings[settingName] = currentBool
    end,
    
    Info = {infoText}
  })
end

--Modular function for adding boolean menu options.
function KissyMod:AddMenuItemInt(settingName, settingText, infoText, maximum)
  ModConfigMenu.AddSetting(ModName, "Settings", {
    
    Type = ModConfigMenu.OptionType.NUMBER,
    
    CurrentSetting = function()
      return KissySettings[settingName]
    end,
    
    Minimum = 0,
    Maximum = maximum,
    
    Display = function()
      return settingText .. KissySettings[settingName]
    end,
    
    OnChange = function(currentNum)
      KissySettings[settingName] = currentNum
      KissyMod:UpdateSprites()
    end,
    
    Info = {infoText}
  })
end

--Modular function for adding boolean menu options.
function KissyMod:AddSassyItem(index, text)
  ModConfigMenu.AddSetting(ModName, "Items", {
    
    Type = ModConfigMenu.OptionType.TEXT,
    
    CurrentSetting = function()
      return text
    end,
    
    Display = function()
      return text
    end,
    
    OnChange = function(text)
      if text == "X" or text == "x" then
        table.remove(KissySettings, index)
      end
    end,
    
    Info = {"Item #" .. tostring(Isaac.GetItemIdByName(text)) .. ": " .. text}
  })
end

--Runs when the game loads.
function KissyMod:GameStart(continued)
  KissyMod:UpdateSprites()
end

--Save the config settings when the game exits.
function KissyMod:SaveGame()
	SaveState.Settings = {}
	SaveState.Items = {}
	
	for i, v in pairs(KissySettings) do
		SaveState.Settings[tostring(i)] = KissySettings[i]
	end
	for i, v in pairs(SassyList) do
		SaveState.Items[i] = SassyList[i]
	end
  KissyMod:SaveData(json.encode(SaveState))
end

--The method which handles the kissy stuff
function KissyMod:SissyUpdate(npc)
  
  local sissy = npc:ToFamiliar()
  if sissy.Hearts > 0 then
    
    --Check to see if Sissy has a kiss stored and there are no enemies in the room.
    if sissy.Hearts > animFrames and Isaac:CountEnemies() == 0 then
      local distance = sissy.Position:Distance(sissy.Player.Position)
      if distance <= 30 then
        
        --If Sissy is close enough to the player, she gives the kiss OwO
        sissy.Hearts = animFrames
        if KissySettings["SpawnTimerReset"] then 
          sissy.State = 0 --This sets Sissy's spawn timer to 0, guaranteeing an instant spider spawn in the next hostile room.
        end
      else
        --If not close enough, she walks towards the player.
        if KissySettings["SissyApproaches"] then
          sissy.TargetPosition = Vector(sissy.Player.Position.X, sissy.Player.Position.Y)
          sissy:SetSpriteFrame("Walk", sissy.FrameCount)
          sissy.Velocity = KissyMod:vectorWalk(sissy.Position, sissy.Player.Position)
          sissy.FlipX = KissyMod:toTheLeft(sissy.Position, sissy.Player.Position)
        end
      end
    elseif sissy.Hearts <= animFrames then
    
      --Process the kiss animation
      sissy.Hearts = sissy.Hearts - 1
      local frame = animFrames - sissy.Hearts
      sissy:SetSpriteFrame("Kiss", frame)
      sissy.Velocity = Vector(0,0)
      sissy.FlipX = KissyMod:toTheLeft(sissy.Position, sissy.Player.Position)
    
      if frame == 5 then
        --On frame 5 the kiss sound effect triggers and we show a visual effect as well.
        if KissySettings["KissSound"] then 
          SFXManager():Play(SoundEffect.SOUND_KISS_LIPS1, 1.0, 0, false, 1.0)
        end
        if KissySettings["SplashEffect"] then 
          local pos = KissyMod:vectorCenter(sissy.Position, sissy.Player.Position)
          Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_VERYSMALL, 0, pos, Vector(0,0), sissy)
        end
      
      elseif frame == 7 and KissySettings["CharmEffect"] then
        --On frame 7 we add the charmed effect
        sissy.Player.AddCharmed(sissy.Player, EntityRef(sissy), 45)
     
      elseif frame == 13 and KissySettings["ThumbsUp"] then
      --On frame 13 Isaac is happy.
        if KissySettings["IsaacDoesntLikeSassy"] and (sissy.Coins >= 1 or KissySettings["SassyTransformation"] == 2) then
          sissy.Player:AnimateSad()
        else
          sissy.Player:AnimateHappy()
        end
      
      elseif frame >= animFrames then
      --When the animation is done, Sissy goes back to normal.
        sissy:SetSpriteFrame("Idle", frame)
      end
    end
  end
  return nil
end

--Kissy gives out one kiss for free when you get her.
function KissyMod:SissyInit(npc)
  npc:ToFamiliar().Hearts = 26
  npc:ToFamiliar().Coins = 0
  KissyMod:UpdateSprites()
end

--If you forget to get the kiss from Sissy before you leave the room, you lose out on it.
function KissyMod:RoomMove()
  local entities = Isaac.GetRoomEntities()
  for i, v in pairs(entities) do
    if v:ToFamiliar() and v.Variant == FamiliarVariant.SISSY_LONGLEGS then
      v:ToFamiliar().Hearts = 0
    end
  end
  return nil
end

--Every time a room is cleared, Sissy stores a kiss.
function KissyMod:RoomClear(Rng, SpawnPos )
  local entities = Isaac.GetRoomEntities()
  for i, v in pairs(entities) do
    if v:ToFamiliar() and v.Variant == FamiliarVariant.SISSY_LONGLEGS and math.random(1,100) <= KissySettings["KissChance"] then
      v:ToFamiliar().Hearts = animFrames + 1
    end
  end
  return nil
end

--Check items after we get a new one.
function KissyMod:CheckItems(player, cacheflag)
  
  --We skip this entirely if the sassy transformation rule is not set to 1.
  if KissySettings["SassyTransformation"] ~=1 then
    return nil
  end
  
  --First we determine if Isaac picked up an item from the transformation list.
  local gotTransformItem = false
  for i, v in pairs(SassyList) do
    if player:HasCollectible(Isaac.GetItemIdByName(v)) then
      gotTransformItem = true
      break
    end
  end
  
  --Then we check if we have any Sissy's in the room and set their coin value to 1
  if gotTransformItem then
    local entities = Isaac.GetRoomEntities()
    local doTransform = false
    for i, v in pairs(entities) do
    if v:ToFamiliar() and v.Variant == FamiliarVariant.SISSY_LONGLEGS then
      sissy = v:ToFamiliar()
        if sissy.Coins <= 0 then
          doTransform = true
          Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, sissy.Position, Vector(0,0), sissy)
        end
        sissy.Coins = 1
      end
    end
    
    --If any coin value updated then we do the transformation effect.
    if doTransform then
      SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER, 1.0, 0, false, 1.0)
      Game():GetHUD():ShowItemText("Sassy!", "", false)
      KissyMod:UpdateSprites()
      
    end
  end
  return nil
end

--Update Sissy's sprites. Aka, "become sassy".
function KissyMod:UpdateSprites()
  local entities = Isaac.GetRoomEntities()
  for i, v in pairs(entities) do
    if v:ToFamiliar() and v.Variant == FamiliarVariant.SISSY_LONGLEGS then
      sissy = v:ToFamiliar()
      setting = KissySettings["SassyTransformation"]
      
      --Become Sissy
      if setting == 0 or (setting == 1 and sissy.Coins <= 0) then
        sissy:GetSprite():Load("003.280_sissylonglegs.anm2", true)
        sissy:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/familiar_280_sissylonglegs.png")
        sissy:GetSprite():LoadGraphics()
      
      --Become Sassy
      elseif setting == 2 or (setting == 1 and sissy.Coins >= 1) then
        sissy:GetSprite():Load("003.280_sissylonglegs.anm2", true)
        sissy:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/sassylonglegs.png")
        sissy:GetSprite():LoadGraphics()
      end
    end
  end
end

--Calculates midpoint between Sissy and Isaac.
function KissyMod:vectorCenter(vec1, vec2)
  return ((vec1 + vec2) / 2) - Vector(0, 30)
end

--Calculates direction Sissy should walk when in attracted mode.
function KissyMod:vectorWalk(vec1, vec2)
  return (vec1 - vec2):Normalized() * -4
end

--Calculates where Sissy should be facing.
function KissyMod:toTheLeft(vec1, vec2)
  return vec1.X > vec2.X
end

--Register the callbacks
KissyMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, KissyMod.GameStart)
KissyMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, KissyMod.SaveGame)
KissyMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, KissyMod.SissyInit, FamiliarVariant.SISSY_LONGLEGS);
KissyMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, KissyMod.SissyUpdate, FamiliarVariant.SISSY_LONGLEGS);
KissyMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, KissyMod.RoomMove);
KissyMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, KissyMod.RoomClear);
KissyMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, KissyMod.CheckItems);


--####################
--Initialization Stuff
--####################

KissyMod:Initialize()