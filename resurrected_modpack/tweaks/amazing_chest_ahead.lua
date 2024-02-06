local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Amazing Chest Ahead"

local game = Game()

local data

--save/load

function mod:onGameStart(con)
	if not con then
		data = {
			foundItem = {},
			check = false
		}
	else
		local dataLoaded = Isaac.LoadModData(mod)
		data = mod.json.decode(dataLoaded)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)


function mod:preGameExit(shouldSave)
	if shouldSave then
		Isaac.SaveModData(mod, mod.json.encode(data, "data"))
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.preGameExit)


--Chest Replacements

function mod:chestReplace(pickup)
	local room = game:GetRoom()
	local level = game:GetLevel()
	local stage = level:GetStage()
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and room:GetType() ~= RoomType.ROOM_CHALLENGE and stage ~= 11 and not pickup:GetData().nomorph then
		if pickup.Variant == 60 and math.random(100) <= 5 then
			pickup:Morph(5, 55, 0, true, true, false)
		elseif pickup.Variant == 50 and math.random(100) <= 5 then
			pickup:Morph(5, 56, 0, true, true, false)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.chestReplace)


--Red Chest Extra Loot

function mod:red(pickup)
	if pickup:GetSprite():IsPlaying("Open") and pickup:GetSprite():GetFrame() == 1 then
		if math.random(5) == 1 then
			Isaac.Spawn(5, 300, 78, pickup.Position, Vector.FromAngle(math.random(360)) * 5, nil)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.red, PickupVariant.PICKUP_REDCHEST)

--Dupe Protection

function mod:foundItemInit()
	if not data then return end
	if Game():GetLevel():GetCurrentRoomIndex() ~= Game():GetLevel():GetStartingRoomIndex() and not data.check then
		for i = 1, 1000 do 
			for y = 0, Game():GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(y)
				if player:HasCollectible(i) then table.insert(data.foundItem, i) end
			end
		end
		data.check = true
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.foundItemInit)


function mod:foundItem(item)
	if not data then return end
	local unique = true
	for i = 1, #data.foundItem do if item.SubType == data.foundItem[i] then unique = false end end
	if unique == true then table.insert(data.foundItem, item.SubType) end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.foundItem, 100)