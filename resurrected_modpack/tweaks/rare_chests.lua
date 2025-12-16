local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("rare_chests", 1)
local json = require("json")
local data

--[[
	guppy chest (red). guppy items.
	overgrown chest (basic). shr00mz.
	fossil chest (bomb).
	mom's locket.
	medical cabinet.
	sealed chest.
]]

CARDBOARD_CHEST = Isaac.GetEntityVariantByName("Cardboard Chest")
SLOT_CHEST = Isaac.GetEntityVariantByName("Slot Chest")


CardboardItemPool = {102, 111, 177, 294, 349, 485, 20, 21, 22, 23, 24, 25, 26, 46, 54, 60, 64, 74, 144, 180, 195, 198, 203, 204, 227, 246, 271, 362, 376, 385, 416, 424, 447, 455, 456, 500, 514, 523, 535, 624, 669, 707, 716}
CardboardTrinketPool = {1, 2, 3, 6, 8, 13, 15, 16, 19, 24, 25, 29, 31, 36, 41, 46, 49, 50, 51, 52, 53, 63, 67, 72, 74, 83, 93, 94, 99, 100, 101, 102, 105, 106, 108, 109, 110, 120, 121, 124, 125, 126, 127, 129, 130, 131, 132, 134, 135, 136, 137, 143, 147, 151, 157, 158, 160, 169, 171, 172, 177, 184, 185, 187}
SlotItemPool = {105, 166, 177, 283, 284, 285, 295, 349, 386, 406, 437, 476, 485, 521, 555, 609, 723, 18, 46, 64, 74, 94, 109, 134, 141, 202, 227, 241, 376, 380, 385, 402, 414, 416, 429, 450, 455, 501, 602, 670, 716}
SlotTrinketPool = {1, 2, 13, 15, 19, 24, 42, 49, 50, 51, 52, 59, 67, 76, 82, 83, 84, 85, 110, 112, 126, 131, 139, 147, 154, 171, 172}

--save/load

function mod:onGameStart(con)
	if not con then
		data = {
			foundItem = {},
			foundTrinket = {},
			check = false,
			sinCount = 3,
			dealTaken = false
		}
	else
		local dataLoaded = Isaac.LoadModData(mod)
		data = json.decode(dataLoaded)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)


function mod:preGameExit(shouldSave)
	if shouldSave then
		Isaac.SaveModData(mod, json.encode(data, "data"))
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.preGameExit)


--options? check

local function optionsCheck(pickup)
	if pickup.OptionsPickupIndex and pickup.OptionsPickupIndex > 0 then
		for _, entity in pairs(Isaac.FindByType(5, -1, -1)) do
			if entity:ToPickup().OptionsPickupIndex and entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and GetPtrHash(entity:ToPickup()) ~= GetPtrHash(pickup) then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
			entity:Remove()
			end
		end
	end
end


--chest openings

function mod.openCardboardChest(pickup, player)
	optionsCheck(pickup)
	pickup.SubType = 1
	pickup:GetData()["IsInRoom"] = true
	pickup:GetSprite():Play("Open")
	SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1, 0)
	if math.random(10) <= 1 then
		local item
		for i = 1, 1000 do 
			local unique = true
			item = CardboardItemPool[math.random(#CardboardItemPool)]
			for y = 1, #data.foundItem do if item == data.foundItem[y] then unique = false end end
			if (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_NO_LOST_BR == ItemConfig.TAG_NO_LOST_BR and player:GetPlayerType() == 10 and player:HasCollectible(619)) or (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_OFFENSIVE ~= ItemConfig.TAG_OFFENSIVE and player:GetPlayerType() == 31) then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:GetPlayerType() == 31 and math.random(5) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:HasCollectible(691) and math.random(3) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 1 and player:HasCollectible(691) then unique = false end
			if unique == true then break end
			if i == 1000 then item = 25 end
		end
		local pedestal = Isaac.Spawn(5, 100, item, pickup.Position, Vector.Zero, pickup)
		pedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/pick ups/cardboard_pedestal.png") 
		pedestal:GetSprite():LoadGraphics()
		pickup:Remove()
	else
		local rolls = 1
		for i = 1, 2 do if math.random(3) > rolls then rolls = rolls + 1 end end
		if player:HasTrinket(42) then rolls = rolls + 1 end
		local mod = 1
		if player:HasCollectible(199) then mod = mod + 1 end
		local overpaid = 0
		for i = 1, rolls do
			local payout = math.random(20)
			if payout <= 6 then 
				local batches = math.random(3) * mod
				for i = 1, batches do
					Isaac.Spawn(5, 20, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				end
			elseif payout <= 8 then for i = 1, mod do Isaac.Spawn(5, 10, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 11 then for i = 1, mod do Isaac.Spawn(5, 30, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 15 then for i = 1, mod do Isaac.Spawn(5, 40, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 16 then Isaac.Spawn(5, 90, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
			elseif payout <= 17 then Isaac.Spawn(5, 300, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			elseif payout <= 18 then Isaac.Spawn(5, 70, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			elseif payout <= 19 then Isaac.Spawn(5, 69, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			else 
				local trinket
				for i = 1, 1000 do 
					local unique = true
					trinket = CardboardTrinketPool[math.random(#CardboardTrinketPool)]
					for y = 1, #data.foundTrinket do if trinket == data.foundTrinket[y] then unique = false end end
					if unique == true then break end
				end
				Isaac.Spawn(5, 350, trinket, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				overpaid = overpaid + 1
			end
			if i + overpaid >= rolls then break end
		end
	end
end

function mod.openSlotChest(pickup)
	optionsCheck(pickup)
	pickup.SubType = 8
	pickup:GetData()["IsInRoom"] = true
	pickup:GetSprite():Play("Open")
	local player = Isaac.GetPlayer(0)	
	SFXManager():Play(255, 1, 2, false, 1, 0)
	if math.random(10) <= 2 then
		local item
		for i = 1, 1000 do 
			local unique = true
			item = SlotItemPool[math.random(#SlotItemPool)]
			for y = 1, #data.foundItem do if item == data.foundItem[y] then unique = false end end
			if (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_NO_LOST_BR == ItemConfig.TAG_NO_LOST_BR and player:GetPlayerType() == 10 and player:HasCollectible(619)) or (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_OFFENSIVE ~= ItemConfig.TAG_OFFENSIVE and player:GetPlayerType() == 31) then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:GetPlayerType() == 31 and math.random(5) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:HasCollectible(691) and math.random(3) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 1 and player:HasCollectible(691) then unique = false end
			if unique == true then break end
			if i == 1000 then item = 25 end
		end
		local pedestal = Isaac.Spawn(5, 100, item, pickup.Position, Vector.Zero, pickup)
		pedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/pick ups/slot_pedestal.png") 
		pedestal:GetSprite():LoadGraphics()
		pickup:Remove()
	else
		local rolls = 1
		for i = 1, 5 do if math.random(6) > rolls then rolls = rolls + 1 end end
		local mod = 1
		for i = 0, Game():GetNumPlayers() - 1 do
			if Isaac.GetPlayer(i):HasCollectible(199) then mod = mod + 1 end
			if Isaac.GetPlayer(i):HasTrinket(42) then rolls = rolls + 1 end
		end
		local overpaid = 0
		for i = 1, rolls do
			local payout = math.random(25)
			if payout <= 14 then 
				local batches = math.random(3) * mod
				for i = 1, batches do
					Isaac.Spawn(5, 20, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				end
			elseif payout <= 16 then for i = 1, mod do Isaac.Spawn(5, 10, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 18 then for i = 1, mod do Isaac.Spawn(5, 30, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 20 then for i = 1, mod do Isaac.Spawn(5, 40, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) end
			elseif payout <= 21 then Isaac.Spawn(5, 70, 0, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			elseif payout <= 22 then Isaac.Spawn(5, 300, 22 + math.random(9), pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			elseif payout <= 23 then Isaac.Spawn(5, 300, 49, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			elseif payout <= 24 then Isaac.Spawn(5, 300, 93, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil) overpaid = overpaid + 1
			else 
				local trinket
				for i = 1, 1000 do 
					local unique = true
					trinket = SlotTrinketPool[math.random(#SlotTrinketPool)]
					for y = 1, #data.foundTrinket do if trinket == data.foundTrinket[y] then unique = false end end
					if unique == true then break end
				end
				Isaac.Spawn(5, 350, trinket, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				overpaid = overpaid + 1
			end
			if i + overpaid >= rolls then break end
		end
	end
end

function mod:rollSlotChest(pickup)
	if pickup.Variant == SLOT_CHEST and pickup:GetSprite():IsFinished("Wiggle") then
		if math.random(7) <= 1 or pickup.SubType >= 7 then
			mod.openSlotChest(pickup)
		else
			SFXManager():Play(249, 1, 2, false, 1, 0)
			pickup:GetSprite():Play("Roll")
			pickup:GetSprite():SetFrame(pickup.SubType)
			pickup:GetSprite():Stop()
		end
	end
	if pickup.Variant == BLOOD_CHEST and pickup:GetSprite():IsFinished("Wiggle") then
		if pickup.SubType >= 4 then
			mod.openBloodChest(pickup)
		else
			pickup:GetSprite():Play("Filled")
			pickup:GetSprite():SetFrame(pickup.SubType)
			pickup:GetSprite():Stop()
		end
	end
	if pickup.Variant == PENITENT_CHEST and (pickup:GetSprite():IsFinished("Initiate1") or pickup:GetSprite():IsFinished("Initiate2") or pickup:GetSprite():IsFinished("Initiate3") or pickup:GetSprite():IsFinished("Initiate4") or pickup:GetSprite():IsFinished("Initiate5") or pickup:GetSprite():IsFinished("Initiate6") or pickup:GetSprite():IsFinished("Initiate7")) then
		if pickup.SubType >= data.sinCount then
			mod.openPenitentChest(pickup)
		else
			pickup:GetSprite():Play("Bloodied")
			pickup:GetSprite():SetFrame(pickup.SubType)
			pickup:GetSprite():Stop()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.rollSlotChest)

--chest collision

function mod:chestCollision(pickup, collider, _)	
	if not collider:ToPlayer() then return end
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()
	if (pickup.Variant == CARDBOARD_CHEST and pickup.SubType == 0) then
		if sprite:IsPlaying("Appear") then return false end	
		if pickup.Variant == CARDBOARD_CHEST then mod.openCardboardChest(pickup, player) end
	end
	if pickup.Variant == SLOT_CHEST and pickup.SubType < 7 and player:GetNumCoins() > 0 and not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Wiggle")) then
		player:AddCoins(-1)
		pickup:GetSprite():Play("Wiggle")
		SFXManager():Play(24, 1, 2, false, 1, 0)
		if player:HasCollectible(46) and pickup.SubType < 6 and math.random(2) == 1 then
			pickup.SubType = pickup.SubType + 2
		else 
			pickup.SubType = pickup.SubType + 1
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.chestCollision)


--chest replacement and removal

function mod:chestInit(pickup)
	if (pickup.Variant == CARDBOARD_CHEST and pickup.SubType == 1 and not pickup:GetData()["IsInRoom"]) then
		pickup:Remove()
	end
	if pickup.Variant == SLOT_CHEST and pickup.SubType > 0 then
		if pickup.SubType == 8 and not pickup:GetData()["IsInRoom"] then pickup:Remove() end
		if pickup.SubType < 8 then 
			pickup:GetSprite():Play("Roll")
			pickup:GetSprite():SetFrame(pickup.SubType)
			pickup:GetSprite():Stop()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.chestInit)


function mod:chestUpdate(pickup)
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and Game():GetRoom():GetType() ~= 11 and Game():GetLevel():GetStage() ~= 11 and not pickup:GetData().nomorph then
		if pickup.Variant == 50 and math.random(100) <= 10 then
			local rng = math.random(100)
			if rng <= 75 then pickup:Morph(5, CARDBOARD_CHEST, 0, true, true, false)
				else pickup:Morph(5, SLOT_CHEST, 0, true, true, false)
			end 
			SFXManager():Play(21, 1, 2, false, 1, 0)
		end
		if pickup.Variant == 360 and math.random(100) <= 10 then pickup:Morph(5, DEVIL_CHEST, 0, true, true, false) SFXManager():Play(21, 1, 2, false, 1, 0) end
		if pickup.Variant == 60 and math.random(100) <= 10 then
			local rng = math.random(100)
			if rng >= 75 then pickup:Morph(5, SLOT_CHEST, 0, true, true, false)
			end 
			SFXManager():Play(21, 1, 2, false, 1, 0)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.chestUpdate)


--devil shenanigans

function mod:takingTheDeal(player)
	if player.QueuedItem and player.QueuedItem.Item and player.QueuedItem.Item:IsCollectible() then player:GetData().queuedItem = player.QueuedItem.Item.ID
	else
		if player:GetData().queuedItem and player:GetData().queuedItem > 0 then
			if Game():GetRoom():GetType() == 14 then
				if data.dealTaken == false then data.dealTaken = true end
				if data.sinCount < 7 then data.sinCount = data.sinCount + 1 end		
			end
			player:GetData().queuedItem = 0
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.takingTheDeal)


function mod:visitDevil()
	if Game():GetRoom():IsFirstVisit() and Game():GetRoom():GetType() == 14 and data.sinCount < 7 then
		data.sinCount = data.sinCount + 1
	end
	if Game():GetRoom():IsFirstVisit() and Game():GetRoom():GetType() == 15 and data.sinCount > 0 then
		data.sinCount = data.sinCount - 1
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.visitDevil)


--dupe protection

function mod:foundItemInit()
	if not data then return end
	if Game():GetLevel():GetCurrentRoomIndex() ~= Game():GetLevel():GetStartingRoomIndex() and not data.check then
		for i = 1, 1000 do 
			for y = 0, Game():GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(y)
				if player:HasCollectible(i) then table.insert(data.foundItem, i) end
				if player:HasTrinket(i, true) then table.insert(data.foundTrinket, i) end
			end
		end
		data.check = true
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.foundItemInit)


function mod:foundItem(item)
	if not data then return end
	if item.Variant == 100 then
		local unique = true
		for i = 1, #data.foundItem do if item.SubType == data.foundItem[i] then unique = false end end
		if unique == true then table.insert(data.foundItem, item.SubType) end
	end
	if item.Variant == 350 then
		for i = 1, #data.foundTrinket do if item.SubType == data.foundTrinket[i] then unique = false end end
		if unique == true then table.insert(data.foundTrinket, item.SubType) end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.foundItem)