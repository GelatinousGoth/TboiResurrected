--[[ Compatibility ]]--
local mod = EnhancementChamber
local game = Game()

-- Repentogon
if not REPENTOGON then
	mod:Log("Repentogon not found!")
end

-- External Item Description
if EID and mod:HasConfig("sacrifice_altars") then
	EID.Config["DisplaySacrificeInfo"] = nil
end

-- Mod Config Menu
if ModConfigMenu then

	local function AddConfigSetting(category, cfg)
		ModConfigMenu.AddSetting(mod.Name, category, {
			Type = ModConfigMenu.OptionType.BOOLEAN,

			CurrentSetting = function()
				return cfg.bool
			end,

			Display = function()
				local enabled = cfg.bool
				return cfg.name .. ": " .. (enabled and "Enabled" or "Disabled")
			end,

			OnChange = function(b)
				cfg.bool = b
				mod:saveAll()
			end,

			Info = { cfg.desc }
		})
	end

	-- Special Rooms
	do
		local category = "Rooms"
		local modules = {}

		-- Group config by module
		for _, cfg in pairs(mod.Config) do
			if cfg.module ~= "Miscellaneous" then
				modules[cfg.module] = modules[cfg.module] or {}
				table.insert(modules[cfg.module], cfg)
			end
		end

		-- Sort modules alphabetically
		local moduleNames = {}

		for moduleName in pairs(modules) do
			table.insert(moduleNames, moduleName)
		end

		table.sort(moduleNames)

		-- Modules
		for _, moduleName in ipairs(moduleNames) do
			local configs = modules[moduleName]

			-- Separate module
			ModConfigMenu.AddSpace(mod.Name, category)
			ModConfigMenu.AddTitle(mod.Name, category, moduleName)

			-- Sort configs alphabetically
			table.sort(configs, function(a, b)
				return a.name < b.name
			end)

			for _, cfg in ipairs(configs) do
				AddConfigSetting(category, cfg)
			end
		end
	end

	-- Miscellaneous
	do
		local category = "Misc"

		ModConfigMenu.AddSpace(mod.Name, category)
		ModConfigMenu.AddTitle(mod.Name, category, "Miscellaneous")
		ModConfigMenu.AddSpace(mod.Name, category)

		local configs = {}

		for _, cfg in pairs(mod.Config) do
			if cfg.module == "Miscellaneous" then
				table.insert(configs, cfg)
			end
		end

		-- Sort miscellaneous settings alphabetically
		table.sort(configs, function(a, b)
			return a.name < b.name
		end)

		for _, cfg in ipairs(configs) do
			AddConfigSetting(category, cfg)
		end
	end
end

--[[ Fix Ultra Hard challenge ]]--

-- Ultra Hard variable
local ultraHard = false

-- Fix crash related to Double Trouble in Ultra Hard Challenge
function mod:bossPreUltraHard()
	---@diagnostic disable-next-line
    if ChampionOverhaul then return end

    if game.Challenge ~= Challenge.CHALLENGE_ULTRA_HARD then return end

    ultraHard = true
    game.Challenge = Challenge.CHALLENGE_NULL
end
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, mod.bossPreUltraHard)

-- Adds missing curses to Ultra Hard challenge
function mod:bossPostUltraHard()
    if not ultraHard then return end

    local level = game:GetLevel()
    ultraHard = false
    ---@type integer
    local flags = 1 << 2 | 1 << 5 | 1 << 6
    level:AddCurse(flags, true)
    game.Challenge = Challenge.CHALLENGE_ULTRA_HARD
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.bossPostUltraHard)