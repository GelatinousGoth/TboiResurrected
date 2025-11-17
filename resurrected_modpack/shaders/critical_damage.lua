local TR_Manager = require("resurrected_modpack.manager")
local ModID = "Critical Health"
local Mod = TR_Manager:RegisterMod(ModID, 1)

Mod.critical = 0
Mod.Damage = 0

Mod.width = Isaac.GetScreenWidth()
Mod.height = Isaac.GetScreenHeight()
Mod.scale = Isaac.GetScreenPointScale()

Mod.Bip = Sprite()
Mod.Bip:Load("gfx/Bip.anm2", true)
Mod.Bip:LoadGraphics()

function Mod:InitConfig()
  Mod.Config = {
    HUDColorMod = {
      R = 1,
      G = 0, 
      B = 0,
      A = 1
    },
    Enabled = true,
    DSS = {}
  }    
end

Mod:InitConfig()

local DefaultColor = Color(1,0,0,1)

local json = require("json")

function Mod:SyncWithConfig()
  local hud_mod = Mod.Config.HUDColorMod or DefaultColor
  Mod.Config.ColorMod = Color(1*hud_mod.R,1*hud_mod.G,1*hud_mod.B,1*hud_mod.A)
  Mod:SaveData(json.encode(Mod.Config))
end

function Mod:LoadConfig()
  if Mod:HasData() then 
    Mod.Config = json.decode(Mod:LoadData(Mod))

    if Mod.Config == nil then 
      Mod:InitConfig()
    end

    Mod:SyncWithConfig()
  else 
    Mod:InitConfig()
  end
end

function Mod:GetDSSData()
  if Mod.Config == nil then 
    Mod:LoadConfig()
  end

  Mod.Config.DSS = Mod.Config.DSS or {}
  return Mod.Config.DSS
end

-- MCM Integration

if ModConfigMenu then 
  local color_names = {
    ["R"] = "red",
    ["G"] = "green",
    ["B"] = "blue",
    ["A"] = "opacity"
  }
  ModConfigMenu.RemoveCategory(ModID)

  ModConfigMenu.AddSetting(
    ModID, -- This should be unique for your mod
    "General", -- If you don't want multiple tabs, then set this to nil
    {
      Type = ModConfigMenu.OptionType.BOOLEAN,
      CurrentSetting = function()
        return Mod.Config.Enabled
      end,
      Display = function()
        return "Enabled: " .. (Mod.Config.Enabled and "on" or "off")
      end,
      OnChange = function(b)
        Mod.Config.Enabled = b
        Mod:SyncWithConfig()
      end,
      Info = { -- This can also be a function instead of a table
        "Is the HUD Effect",
        "Enabled?",
      }
    }
  )

end

-- MCM Integration end

-- DSS Integration

local CHDSSInit = include("chmenucore")
-- Every CHMenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local CHMenuProvider = {}
local options = {}
options.mod = RegisterMod("CriticalHealthOptions", 1)

function options.mod.GetSaveData()
    return Mod:GetDSSData()
end

function options.mod.StoreSaveData()
    Mod:SyncWithConfig()
end


function CHMenuProvider.SaveSaveData()
    Mod:SyncWithConfig()
end

function CHMenuProvider.GetPaletteSetting()
    return options.mod.GetSaveData().MenuPalette
end

function CHMenuProvider.SavePaletteSetting(var)
    options.mod.GetSaveData().MenuPalette = var
end

function CHMenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return options.mod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function CHMenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        options.mod.GetSaveData().HudOffset = var
    end
end

function CHMenuProvider.GetGamepadToggleSetting()
    return options.mod.GetSaveData().GamepadToggle
end

function CHMenuProvider.SaveGamepadToggleSetting(var)
    options.mod.GetSaveData().GamepadToggle = var
end

function CHMenuProvider.GetMenuKeybindSetting()
    return options.mod.GetSaveData().MenuKeybind
end

function CHMenuProvider.SaveMenuKeybindSetting(var)
    options.mod.GetSaveData().MenuKeybind = var
end

function CHMenuProvider.GetMenuHintSetting()
    return options.mod.GetSaveData().MenuHint
end

function CHMenuProvider.SaveMenuHintSetting(var)
    options.mod.GetSaveData().MenuHint = var
end

function CHMenuProvider.GetMenuBuzzerSetting()
    return options.mod.GetSaveData().MenuBuzzer
end

function CHMenuProvider.SaveMenuBuzzerSetting(var)
    options.mod.GetSaveData().MenuBuzzer = var
end

function CHMenuProvider.GetMenusNotified()
    return options.mod.GetSaveData().MenusNotified
end

function CHMenuProvider.SaveMenusNotified(var)
    options.mod.GetSaveData().MenusNotified = var
end

function CHMenuProvider.GetMenusPoppedUp()
    return options.mod.GetSaveData().MenusPoppedUp
end

function CHMenuProvider.SaveMenusPoppedUp(var)
    options.mod.GetSaveData().MenusPoppedUp = var
end

-- This function returns a table that some useful functions and defaults are stored on
local dssmod = CHDSSInit(ModID, 6, CHMenuProvider)
local gap = {
    -- Creating gaps in your page can be done simply by inserting a blank button.
    -- The "nosel" tag will make it impossible to select, so it'll be skipped over when traversing the menu, while still rendering!
    str = '',
    fsize = 2,
    nosel = true
}

local dss_directory = {
  main = {
    title = ModID:lower(),

    buttons = {
      {str = 'resume game', action = 'resume'},
      {str = 'settings', dest = 'settings'},
      dssmod.changelogsButton,
    },

    tooltip = dssmod.menuOpenToolTip
  },
  settings = {
    title = "settings",
    buttons = {
      {
        str = 'enabled',

        choices = {'disabled','enabled'},
        setting = 2,
        variable = 'CHEnableButton',
        
        load = function()
          if Mod.Config.Enabled then 
            return 2 else return 1 end
        end,
        store = function(var)
          Mod.Config.Enabled = var == 2
          Mod:SyncWithConfig()
        end,

        tooltip = {strset = {'toggle the','hud effect'}}
    },
    }
  },
}

local color_names = {
  ["R"] = "red",
  ["G"] = "green",
  ["B"] = "blue",
  ["A"] = "opacity"
}

for key,_ in pairs(Mod.Config.HUDColorMod) do 
  table.insert(dss_directory.settings.buttons,{
    str = color_names[key].." modifier: ",
    min = 0, max = 100, increment = 5, suf = '%', setting = 100,
    variable = 'CHHUDColor'..key,
    
    load = function()
        return math.floor((Mod.Config.HUDColorMod[key] or 1)*100.0)
    end,
    store = function(var)
        Mod.Config.HUDColorMod[key] = var/100.0
        Mod:SyncWithConfig()
    end,

    func = function(button, item, menuObj)
      Mod.Config.HUDColorMod[key] = tonumber(button.setting)/100.0
      Mod:SyncWithConfig()
    end,

    tooltip = {strset = {"specify how", "intense the",
        color_names[key].." value of","the hud is"}}
  })

  if ModConfigMenu then 
    ModConfigMenu.AddSetting(
      ModID,
      "General",
      {
        Type = ModConfigMenu.OptionType.NUMBER,
        Minimum = 0,
        Maximum = 100,
        CurrentSetting = function()
          return math.floor((Mod.Config.HUDColorMod[key] or 1)*100.0)
        end,
        Display = function()
          return "HUD "..color_names[key].." Modifier: " .. math.floor((Mod.Config.HUDColorMod[key] or 1)*100.0).."%"
        end,
        OnChange = function(val)
          Mod.Config.HUDColorMod[key] = val/100.0
          Mod:SyncWithConfig()
        end,
        Info = { -- This can also be a function instead of a table
          "Specify how intense the",
          color_names[key].." value of the HUD is",
        }
      }
    ) 
  end
end

table.insert(dss_directory.settings.buttons,{str = 'back', action = 'back'})

DeadSeaScrollsMenu.AddMenu(ModID, {
    -- The Run, Close, and Open functions define the core loop of your menu
    -- Once your menu is opened, all the work is shifted off to your mod running these functions, so each mod can have its own independently functioning menu.
    -- The CHDSSInitializerFunction returns a table with defaults defined for each function, as "runMenu", "openMenu", and "closeMenu"
    -- Using these defaults will get you the same menu you see in Bertran and most other mods that use DSS
    -- But, if you did want a completely custom menu, this would be the way to do it!
    
    -- This function runs every render frame while your menu is open, it handles everything! Drawing, inputs, etc.
    Run = dssmod.runMenu,
    -- This function runs when the menu is opened, and generally initializes the menu.
    Open = dssmod.openMenu,
    -- This function runs when the menu is closed, and generally handles storing of save data / general shut down.
    Close = dssmod.closeMenu,

    -- If UseSubMenu is set to true, when other mods with UseSubMenu set to false / nil are enabled, your menu will be hidden behind an "Other Mods" button.
    -- A good idea to use to help keep menus clean if you don't expect players to use your menu very often!
    UseSubMenu = false,

    Directory = dss_directory,

    DirectoryKey = {
      Item = dss_directory.main, -- This is the initial item of the menu, generally you want to set it to your main item
      Main = 'main', -- The main item of the menu is the item that gets opened first when opening your mod's menu.

      -- These are default state variables for the menu; they're important to have in here, but you don't need to change them at all.
      Idle = false,
      MaskAlpha = 1,
      Settings = {},
      SettingsChanged = false,
      Path = {},
    }
})

-- dss integration end


function Mod:PostUpdate()
  for _,player in pairs(Isaac.FindByType(1,-1,-1)) do
    player = player:ToPlayer()
    local effectivehealth = player:GetSoulHearts() + player:GetHearts() + player:GetEternalHearts() + player:GetBoneHearts()
    
    Mod.effectivehealth = effectivehealth
    
    if effectivehealth == 2 then
      
      if Mod.Damage > 0 then
        Mod.Damage = Mod.Damage - 0.1
      end
      
       Mod.critical = math.max((math.sin(Isaac.GetFrameCount() / 100) + 1.5) / 4,Mod.Damage)
      
    elseif (effectivehealth <= 1 and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST) and (not player:IsDead()) then
      if Mod.Damage > 0 then
        Mod.Damage = Mod.Damage - 0.1
      end
      Mod.critical = math.max((math.sin(Isaac.GetFrameCount() / 100) + 1.5) / 2,Mod.Damage)
    else
      if Mod.critical ~= - 1 then
        Mod.critical = Mod.critical - 0.1
      elseif Mod.critical <= 0 then
        Mod.critical = -1
      end
      
    end 
  end
  
  Mod.width = Isaac.GetScreenWidth()
  Mod.height = Isaac.GetScreenHeight()
  Mod.scale = Isaac.GetScreenPointScale()
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Mod.PostUpdate)

function Mod:GameStarted(continued)
  Mod:LoadConfig()
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.GameStarted)

function Mod:OnDamage(entity, source, damageflag, damageSource, damageCountdown)
  local player = entity:ToPlayer()
  if damageflag ~= DamageFlag.DAMAGE_FAKE and player.SubType ~= PlayerType.PLAYER_THELOST then
  Mod.Damage = 3
   Mod.critical = Mod.Damage
  end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.OnDamage, EntityType.ENTITY_PLAYER)



function Mod:OnRender(shadername)
  local Time
  local Amount

  if Game():GetHUD():IsVisible() and not Game():IsPaused() and Mod.critical > 0 and Mod.effectivehealth <= 1 and (Mod.Config.Enabled or false) == true then
    Mod.Bip.Color = Color(1,1,1,math.max(Mod.critical,0.8 )) * (Mod.Config.ColorMod or DefaultColor)
    Mod.Bip:Play("Idle",true)
    Mod.Bip:SetFrame( math.floor(Isaac.GetFrameCount() / 1.5)%120 )
    Mod.Bip:Render( Vector(Mod.width / 2 ,Mod.height / 2))
  end

  if Mod.critical and (Mod.Config.Enabled or false) == true then
    Amount = Mod.critical
  else
    Amount = 0
  end

  local params = {
    Amount = Amount,
    RMod = (Mod.Config.ColorMod or DefaultColor).R,
    GMod = (Mod.Config.ColorMod or DefaultColor).G,
    BMod = (Mod.Config.ColorMod or DefaultColor).B,
    AMod = (Mod.Config.ColorMod or DefaultColor).A,
  }

  return params;
end

TR_Manager:RegisterShaderFunction(Mod, "Critical Health", Mod.OnRender)