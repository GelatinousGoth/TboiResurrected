local TR_Manager = require("resurrected_modpack.manager")
UnlockKey = TR_Manager:RegisterMod("Unlock Key", 1, true)
local mod = UnlockKey



--[[ Constants ]]--
mod.Item = Isaac.GetItemIdByName("Unlock Key")
mod.MoleVariant = Isaac.GetEntityVariantByName("Mr. Unlocki")
mod.EnemyHPIncrease = 22.5 -- In percent

-- Time limits (minutes * seconds * frames)
mod.TimeLimit   = 1.25 * 60 * 30
mod.TimeLimitXL = 2.5 * 60 * 30



--[[ Load scripts ]]--
local folder = "resurrected_modpack.tweaks.ukey_scripts."
include(folder .. "key")
include(folder .. "mole")
include(folder .. "compatibility")



--[[ Handle saving / loading ]]--
local json = require("json")

function mod:LoadTracker(isContinue)
	local hasData = mod:HasData()

	-- Reset the key tracker
	if not isContinue or not hasData then
		mod.SpawnedKey = false
		mod:SaveTracker()

	-- Load the key tracker
	elseif hasData then
		mod.SpawnedKey = json.decode(mod:LoadData())
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadTracker)

-- Save the key tracker
function mod:SaveTracker()
	mod:SaveData(json.encode(mod.SpawnedKey))
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveTracker)