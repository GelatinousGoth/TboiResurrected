-- Mod Config Menu Support
local mod = ItemPedestalOverhaul

-- Setup
if ModConfigMenu then
	local configOrder = {
		"treasure", "shop", "boss", "secret", "ambush", "sacrifice",
		"devil", "angel", "library", "arcade", "bedroom", "barren",
		"dice", "error", "planetarium", "darkroom", "loot"
	}

	local configDesc = {
		"Treasure Room and Chest Backdrop",
		"Shop Backdrop",
		"Boss and Miniboss Rooms",
		"Secret Backdrop",
		"Challenge, Boss Challenge and Boss Rush Rooms",
		"Sacrifice Backdrop",
		"Sheol Backdrop",
		"Cathedral Backdrop",
		"Library Backdrop",
		"Arcade Backdrop",
		"Isaac's Bedroom Backdrop",
		"Barren (Dirty Bedroom) Backdrop",
		"Dice Backdrop",
		"Error Backdrop",
		"Planetarium Backdrop",
		"Dark Room Backdrop",
		"Closet (Death Certificate) Backdrop"
	}

	-- Toggle Pedestals
	ModConfigMenu.AddSpace(mod.Name, nil)
	ModConfigMenu.AddTitle(mod.Name, nil, "Toggle Pedestals")
	ModConfigMenu.AddSpace(mod.Name, nil)

	for id, entry in ipairs(configOrder) do
		ModConfigMenu.AddSetting(mod.Name, nil, {
			Type = ModConfigMenu.OptionType.BOOLEAN,

			CurrentSetting = function()
				return mod.Config[entry]
			end,

			Display = function()
				local enabled = mod.Config[entry]
				return entry:gsub("^%l", string.upper) .. ": " ..
					(enabled and "on" or "off")
			end,

			OnChange = function(b)
				mod.Config[entry] = b
				mod:SaveConfig()
			end,

			Info = { configDesc[id] }
		})
	end

	-- Chapter 4 Variants
	ModConfigMenu.AddSpace(mod.Name, nil)
	ModConfigMenu.AddTitle(mod.Name, nil, "Pedestal Variants")
	ModConfigMenu.AddSpace(mod.Name, nil)

	local name = "isVariant"
	local desc = "Womb, Utero, Scarred Womb, Blue Womb, Corpse and Mortis variant to vanilla, boss and treasure pedestals."
	ModConfigMenu.AddSetting(mod.Name, nil, {
		Type = ModConfigMenu.OptionType.BOOLEAN,

		CurrentSetting = function()
			return mod.Config[name]
		end,

		Display = function()
			local enabled = mod.Config[name]
			return "Enabled: " ..
				(enabled and "true" or "false")
		end,

		OnChange = function(b)
			mod.Config[name] = b
			mod:SaveConfig()
		end,

		Info = { desc }
	})
end