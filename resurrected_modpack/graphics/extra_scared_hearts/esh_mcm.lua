local modName = "Extra Scared Hearts";

--Check if Mod Config is installed
if ModConfigMenu then
	--Add a tab for this mod
    ModConfigMenu.UpdateCategory(modName,
	{
    Info = {
        "View settings for " .. modName .. ".",
    }});

	--Add option to select if hearts should have spider legs
    ModConfigMenu.AddSetting(modName, "Settings", {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return ExtraScaredHearts.Settings["ignoreSpiderAnms"];
        end,
        Display = function()
            local toggle = "disabled";
            if ExtraScaredHearts.Settings["ignoreSpiderAnms"] then
                toggle = "ENABLED";
            end
            return "Prevent spider legs: " .. toggle;
        end,
        OnChange = function(currentBool)
            ExtraScaredHearts.Settings["ignoreSpiderAnms"] = currentBool;
            ExtraScaredHearts:SetupAvailableAnms();
        end,
        Info = function()
            if ExtraScaredHearts.Settings["ignoreSpiderAnms"] then
                return "Scared hearts will never have spider legs.";
            else
                return "Scared hearts will occasionally have spider legs.";
            end
        end
    });
end
