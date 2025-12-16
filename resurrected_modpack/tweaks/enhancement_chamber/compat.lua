--[[ Compatibility ]]--
local mod = EnhancementChamber

-- Repentogon
if not REPENTOGON then
	mod:Log("Repentogon not found!")
end

local function ModSetup()
	-- External Item Descriptions
	if EID and mod.ConfigSpecial["sacrifice"] then
		EID.Config["DisplaySacrificeInfo"] = nil
	end

	-- Mod Config Menu
	if ModConfigMenu then
		local csOrder = {"ambush", "blackmarket", "boss", "bossrush", "curse",
						 "dice", "error", "grave", "library", "sacrifice", "shop"}

		local cmOrder = {"itemSound", "redHeartDamage"}

		-- Special Rooms
		ModConfigMenu.AddSpace(mod.Name, "Rooms")
		ModConfigMenu.AddTitle(mod.Name, "Rooms", "Special Rooms")
		ModConfigMenu.AddSpace(mod.Name, "Rooms")

		for _, entry in ipairs(csOrder) do
			ModConfigMenu.AddSetting(mod.Name, "Rooms", {
				Type = ModConfigMenu.OptionType.BOOLEAN,

				CurrentSetting = function()
					return mod.ConfigSpecial[entry]
				end,

				Display = function()
					local enabled = mod.ConfigSpecial[entry]
					return entry:gsub("^%l", string.upper) .. ": " ..
						(enabled and "Enabled" or "Disabled")
				end,

				OnChange = function(b)
					mod.ConfigSpecial[entry] = b
					mod:saveAll()
				end,

				Info = { mod.ConfigDescSpecial[entry] }
			})
		end

		-- Miscellaneous
		ModConfigMenu.AddSpace(mod.Name, "Others")
		ModConfigMenu.AddTitle(mod.Name, "Others", "Miscellaneous")
		ModConfigMenu.AddSpace(mod.Name, "Others")

		for _, entry in ipairs(cmOrder) do
			ModConfigMenu.AddSetting(mod.Name, "Others", {
				Type = ModConfigMenu.OptionType.BOOLEAN,

				CurrentSetting = function()
					return mod.ConfigMisc[entry]
				end,

				Display = function()
					local enabled = mod.ConfigMisc[entry]
					return entry:gsub("^%l", string.upper) .. ": " ..
						(enabled and "Enabled" or "Disabled")
				end,

				OnChange = function(b)
					mod.ConfigMisc[entry] = b
					mod:saveAll()
				end,

				Info = { mod.ConfigDescMisc[entry] }
			})
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModSetup)