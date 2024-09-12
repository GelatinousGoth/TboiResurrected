local MCM = ModConfigMenu;
if (not MCM) then
    return;
end
local Mod = CoinFlipper;
local ModName = Mod.Name;

MCM.SetCategoryInfo(ModName, "Flip a coin!")

do  -- Keyboard.
    local key = MCM.AddKeyboardSetting(
        ModName, 
        "Keybind", 
        "Keyboard", 
        Mod:GetKeyboardKey(), 
        "Keyboard", 
        false, 
        "The key to flip a coin")

    local setValue = Mod.SetKeyboardKey;
    Mod.SetKeyboardKey = function(self, value)
        setValue(self, value);
        MCM.Config[ModName]["Keyboard"] = value or -1;
    end

    local onChange = key.OnChange;
    key.OnChange = function(currentValue) 
        onChange(currentValue);
        Mod:SetKeyboardKey(currentValue);
    end
end
do  -- Controller.
    local key = MCM.AddControllerSetting(
        ModName, 
        "Keybind", 
        "Controller", 
        Mod:GetControllerKey(), 
        "Controller", 
        false, 
        "The controller button to flip a coin")

    local setValue = Mod.SetControllerKey;
    Mod.SetControllerKey = function(self, value)
        setValue(self, value);
        MCM.Config[ModName]["Controller"] = value or -1;
    end

    local onChange = key.OnChange;
    key.OnChange = function(currentValue) 
        onChange(currentValue);
        Mod:SetControllerKey(currentValue);
    end
end


if MCM.i18n == "Chinese" then
    MCM.SetCategoryNameTranslate(ModName, "掷硬币")
    MCM.SetSubcategoryNameTranslate(ModName, "Keybind","按键")
    MCM.SetCategoryInfoTranslate(ModName, "掷一枚硬币!")
    
    MCM.TranslateOptionsDisplayWithTable(ModName, "Keybind", {
        { "Keyboard", "键盘"},
        { "Controller", "手柄"}
    })
    MCM.TranslateOptionsInfoTextWithTable(ModName, "Keybind",{
        ["The key to flip a coin"] = 
        "掷硬币使用的按键",
        ["The controller button to flip a coin"] = 
        "掷硬币使用的手柄键",
    });
end