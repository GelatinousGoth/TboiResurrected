--[[ Compatibility ]]--
local mod = EnhancementChamber

-- Repentogon --
if not REPENTOGON then error("Enhancement Chamber requires Repentogon!") end

-- MiniMAPI --
if not MinimapAPI then mod.HasMinimap = false end

-- External Item Descriptions --
if EID and mod.ConfigSpecial["sacrifice"] then EID.Config["DisplaySacrificeInfo"] = nil end

-- Mod Config Menu --
if ModConfigMenu then
	local hasSetupMCM = false
	local function setupModConfig()
		if hasSetupMCM then return end
		hasSetupMCM = true

		-- Special Rooms --
		ModConfigMenu.AddSpace(mod.Name, "Rooms")
		ModConfigMenu.AddTitle(mod.Name, "Rooms", "Special Rooms")
		ModConfigMenu.AddSpace(mod.Name, "Rooms")

		for _, key in ipairs(mod.ConfigSpecialOrder) do
			local desc = mod.ConfigDescSpecial[key]
			ModConfigMenu.AddSetting(mod.Name, "Rooms", {
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function()
					return mod.ConfigSpecial[key]
				end,
				Display = function()
					return key:gsub("^%l", string.upper) .. ": " ..
						(mod.ConfigSpecial[key] and "Enabled" or "Disabled")
				end,
				OnChange = function(b)
					mod.ConfigSpecial[key] = b
					mod:saveAll()
				end,
				Info = { desc }
			})
		end

		-- Miscellaneous --
		ModConfigMenu.AddSpace(mod.Name, "Others")
		ModConfigMenu.AddTitle(mod.Name, "Others", "Miscellaneous")
		ModConfigMenu.AddSpace(mod.Name, "Others")

		for _, key in ipairs(mod.ConfigMiscOrder) do
			local desc = mod.ConfigDescMisc[key]
			ModConfigMenu.AddSetting(mod.Name, "Others", {
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function()
					return mod.ConfigMisc[key]
				end,
				Display = function()
					return key:gsub("^%l", string.upper) .. ": " ..
						(mod.ConfigMisc[key] and "Enabled" or "Disabled")
				end,
				OnChange = function(b)
					mod.ConfigMisc[key] = b
					mod:saveAll()
				end,
				Info = { desc }
			})
		end
	end

	mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, setupModConfig)
end