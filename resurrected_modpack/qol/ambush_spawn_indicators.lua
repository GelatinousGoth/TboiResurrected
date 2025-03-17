local TR_Manager = require("resurrected_modpack.manager")
local AmbushSpawnIndicators = TR_Manager:RegisterMod("Ambush Spawn Indicators", 1)



--[[ Load scripts ]]--
local scriptsFolder = "resurrected_modpack/qol/ambush_spawn_indicators"

-- Only if REPENTOGON is enabled
if REPENTOGON then
	local scripts = {
		"dss.saveData",
		"library",
		"constants",
		"spawnManager",
		"waveManager",
		"dss.dssmenu",
		"compatibility",
	}

	for i, script in pairs(scripts) do
		include(scriptsFolder .. script)
	end



-- Missing dependency warning
else
	include(scriptsFolder .. "warning")
end