local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Fireworks for Good Items", 1)
local json = require("json")

local settings = {
    threshold = 4,
    frequency = 3,
    chance = 10,
    singular = false,
    blind = true,
    experimental = false
}

local EXPLOSION_SFX = SoundEffect.SOUND_BOSS1_EXPLOSIONS
local BOOM_TRIGGER = "BoomSound"

function mod:Save()
    local jsonString = json.encode(settings)
    mod:SaveData(jsonString)
end

function mod:Load()
    if not mod:HasData() then
      return
    end
    local jsonString = mod:LoadData()
    settings = json.decode(jsonString)
end

if ModConfigMenu ~= nil then
    ModConfigMenu.RemoveCategory("Fireworks")
    ModConfigMenu.UpdateCategory("Fireworks", {
        Name = "Fireworks",
        Info = "Fireworks for Good Items",
    })
    
    mod:Load()
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
          return settings.threshold
        end,
        Minimum = 0,
        Maximum = 4,
        Display = function()
          return "Item quality threshold: " .. settings.threshold
        end,
        OnChange = function(n)
          settings.threshold = n
          mod:Save()
        end,
        Info = { "The minimum item quality required for fireworks to spawn. Set to 0 for all items." }
      }
    )
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
          return settings.singular
        end,
        Display = function()
          return "Only one firework: " .. (settings.singular and "true" or "false")
        end,
        OnChange = function(n)
          settings.singular = n
          mod:Save()
        end,
        Info = { "Makes it so only one firework appears per pedestal. Best with 100% chance. Unaffected by frequency." }
      }
    )
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
          return settings.blind
        end,
        Display = function()
          return "Account for blind items: " .. (settings.blind and "true" or "false")
        end,
        OnChange = function(n)
          settings.blind = n
          mod:Save()
        end,
        Info = { "When enabled, pedestals with blind items that meet the firework requirements won't shoot fireworks." }
      }
    )
    ModConfigMenu.AddSpace("Fireworks", nil)
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
          return settings.experimental
        end,
        Display = function()
          return "Use vanilla delay: " .. (settings.experimental and "false" or "true")
        end,
        OnChange = function(n)
          settings.experimental = n
          mod:Save()
        end,
        Info = { "Uses the vanilla delay for fireworks. Disable if you want the option below to work, but keep in mind that it might be buggy." }
      }
    )
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.SCROLL,
        CurrentSetting = function()
          return settings.frequency
        end,
        Display = function()
          return "Custom delay: $scroll" .. settings.frequency
        end,
        OnChange = function(n)
          settings.frequency = n
          mod:Save()
        end,
        Info = { "The higher it is, the higher the custom delay between the fireworks." }
      }
    )
    ModConfigMenu.AddSetting("Fireworks", nil,
      {
        Type = ModConfigMenu.OptionType.SCROLL,
        CurrentSetting = function()
          return settings.chance
        end,
        Display = function()
          return "Custom chance: $scroll" .. settings.chance
        end,
        OnChange = function(n)
          settings.chance = n
          mod:Save()
        end,
        Info = { "Firework chance each custom tick. Set to 0 to disable fireworks entirely (no change in \"Use vanilla delay\" option required)." }
      }
    )
    ModConfigMenu.AddSpace("Fireworks", nil)
    ModConfigMenu.AddText("Fireworks", nil, "Note: some fireworks might despawn")
    ModConfigMenu.AddText("Fireworks", nil, "if there are too many on screen")
end

-- this is what EID and Epiphany use
local questionMarkPedestalSprite = Sprite()
questionMarkPedestalSprite:Load("gfx/005.100_collectible.anm2", true)
questionMarkPedestalSprite:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png")
questionMarkPedestalSprite:LoadGraphics()

if REPENTOGON then
  function mod:IsBlindPedestal(pedestal) 
    if pedestal:IsBlind() or (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND) == LevelCurse.CURSE_OF_BLIND then 
      return true
    else 
      return false
    end
  end
else
  ---@param pedestal EntityPickup
  ---@return boolean
  function mod:IsBlindPedestal(pedestal)
    local pedestalSprite = pedestal:GetSprite()
    questionMarkPedestalSprite:SetFrame(pedestalSprite:GetAnimation(), pedestalSprite:GetFrame())
    for i = -70, 0, 2 do
      local qcolor = questionMarkPedestalSprite:GetTexel(Vector(0, i), Vector.Zero, 1, 1)
      local ecolor = pedestalSprite:GetTexel(Vector(0, i), Vector.Zero, 1, 1)
      if qcolor.Red ~= ecolor.Red or qcolor.Green ~= ecolor.Green or qcolor.Blue ~= ecolor.Blue then
      return false
     end
    end
    return true
  end
end

function mod:fireworksCounterTests()
  local fayerworks = Isaac.FindByType(1000, 104, 0)
  print(#fayerworks)
end
-- mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.fireworksCounterTests)

local LIFETIME = 3 --secs

function mod:yayFireworks(pickup)
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        if pickup.FrameCount >= LIFETIME*30 then return end
        if pickup.SubType <= 0 then return end
        if settings.chance == 0 then return end
        local cfg = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
        if cfg.Quality >= settings.threshold then 
          if pickup:GetData().FireworksForGoodItemsIsBlind == nil then
            if mod:IsBlindPedestal(pickup) then
              pickup:GetData().FireworksForGoodItemsIsBlind = true
            else
              pickup:GetData().FireworksForGoodItemsIsBlind = false
            end
          end
          if not settings.blind or (settings.blind and pickup:GetData().FireworksForGoodItemsIsBlind == false) then
              if (not settings.experimental and not settings.singular)
              or not settings.singular and (settings.experimental and math.random() <= settings.chance / 10 and (pickup.FrameCount) % (((settings.frequency + 1) * 8)) == 0)
              or settings.singular
              then
                
                if settings.singular then
                  if pickup:GetData().FireworksForGoodItemsSingularActivated == true then return end
                end

                -- SFXManager():Play(SoundEffect.SOUND_BEEP, 1, 0, false, 1)
                local fireworks = Isaac.Spawn(1000,104,0,pickup.Position,Vector.Zero,pickup)
                fireworks:GetData().FireworksForGoodItemsIsPedestalFirework = true

                if settings.singular then
                  pickup:GetData().FireworksForGoodItemsSingularActivated = true
                end
              end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.yayFireworks)

function mod:yayFireworksUpdate(fireworks)
  if settings.experimental or settings.singular then
    if fireworks.SubType == 1 and fireworks.SpawnerEntity ~= nil and fireworks.SpawnerEntity:GetData().FireworksForGoodItemsIsPedestalFirework == true then
      fireworks.SpawnerEntity:Remove()
      print("firework 1")
      return
    end
  else
    if fireworks.SubType == 0 and fireworks:GetData().FireworksForGoodItemsIsPedestalFirework == true then
      fireworks:Remove()
      return
    end
  end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.yayFireworksUpdate, EffectVariant.FIREWORKS)

---@param effect EntityEffect
function mod:fireworkSoundCancel(effect)
local sfx = SFXManager()
local spawner = effect.SpawnerEntity
local sprite = effect:GetSprite()
  if not (spawner and spawner.Type == EntityType.ENTITY_PICKUP and spawner.Variant == PickupVariant.PICKUP_COLLECTIBLE) then return end
  if sfx:IsPlaying(EXPLOSION_SFX) then
    sfx:Stop(EXPLOSION_SFX)
  end

end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, mod.fireworkSoundCancel, EffectVariant.FIREWORKS)
