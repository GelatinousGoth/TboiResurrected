local cba = CutBossesAttacks

local function AddBoolSetting(setting, category, text, info)
	local tab = "General"
	ModConfigMenu.AddSetting(
		"CBA",
		tab,
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return cba.Save.Config[category][setting]
			end,
			Display = function()
				local onOff = "False"
				if cba.Save.Config[category][setting] then
					onOff = "True"
				end
				return text .. ": " .. onOff
			end,
			OnChange = function(currentBool)
				cba.Save.Config[category][setting] = currentBool
			end,
			Info = info
		}
	)
end

ModConfigMenu.AddSetting(
	"CBA",
	"General",
	{
		Type = ModConfigMenu.OptionType.BOOLEAN,
		CurrentSetting = function()
			return true
		end,
		Display = function()
			return "<<RESET SETTINGS TO DEFAULT>>"
		end,
		OnChange = function(currentBool)
			for k, v in pairs(cba.Save.DefaultConfig) do
				for k2, v2 in pairs(cba.Save.DefaultConfig[k]) do
					cba.Save.Config[k][k2] = cba.Save.DefaultConfig[k][k2]
				end
			end
		end,
		Info = "Press Left or Right to reset settings",
		Color = {0.25, 0, 0}
	}
)

ModConfigMenu.AddTitle("CBA", "General", "Changes")
ModConfigMenu.AddText("CBA", "General", "Siren")
AddBoolSetting("SirenRestore", "General", "Siren Restore", "Adds unused attack to Siren")
AddBoolSetting("NotesAttack", "Siren", "Note Attack", "If true, then unused Note Attack will replace Scream and Summon attacks")
AddBoolSetting("ScreamAttack", "Siren", "Scream Attack Overwrite", "Restores old Scream attack pattern from Antibirth")
ModConfigMenu.AddText("CBA", "General", "Mausoleum Mom")
AddBoolSetting("MomRestore", "General", "Mom Restore", "Changes behaivor of Mausoleum Mom")
ModConfigMenu.AddText("CBA", "General", "Mega Satan 2'nd Phase")
AddBoolSetting("MegaSatanRestore", "General", "Mega Satan 2 Hands Restore", "Readds Mega Satan's hands in 2'nd phase and adds new attacks to them")