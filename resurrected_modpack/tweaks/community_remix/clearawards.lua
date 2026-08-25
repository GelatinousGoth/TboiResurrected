local game = TRCommunityRemix.GAME

TRCommunityRemix.ClearAwardsPool = WeightedOutcomePicker()

TRCommunityRemix:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, 9999, function(_, droprng, pos) -- happen late
	local didcancel = Isaac.RunCallback("CR_MC_PRE_REIMPLEMENT_CLEAN_AWARD")
	if didcancel then return nil end
	
	if game.Difficulty < 2 then
		local room = game:GetRoom()
		local level = game:GetLevel()
		local roomidx = level:GetCurrentRoomDesc().GridIndex
		local roomType = room:GetType()
		local roomDesc = level:GetCurrentRoomDesc()
		roomDesc.AwardSeed = droprng:Next()
		
		local roomTypeWhiteList = {
			[1] = true,
			[4] = true,
			[RoomType.ROOM_MINIBOSS] = true,
			[RoomType.ROOM_BLUE] = true,
			[RoomType.ROOM_SECRET_EXIT] = true,
			[RoomType.ROOM_SHOP] = true,
			[RoomType.ROOM_BLACK_MARKET] = true,
			[RoomType.ROOM_CHALLENGE] = true,
		}
		
		if roomTypeWhiteList[roomType] then
			local luck = -math.huge
			local contract = 0
			local hasOptions = false
			local tempTatCount = 0
			
			local weight = {
				[PickupVariant.PICKUP_COIN] = 0.25,
				[PickupVariant.PICKUP_HEART] = 0.225,
				[PickupVariant.PICKUP_BOMB] = 0.15,
				[PickupVariant.PICKUP_KEY] = 0.075,
				[PickupVariant.PICKUP_PILL] = 0.027,
				[PickupVariant.PICKUP_TAROTCARD] = 0.027,
				[PickupVariant.PICKUP_TRINKET] = 0.027,
				[PickupVariant.PICKUP_CHEST] = 0.05,
				[PickupVariant.PICKUP_LIL_BATTERY] = 0.0,
			}

			if DifficultyManager.GetDifficulty() == "Insane" then
				weight[PickupVariant.PICKUP_COIN] = 0.25
				weight[PickupVariant.PICKUP_HEART] = 0.33
				weight[PickupVariant.PICKUP_BOMB] = 0.20
				weight[PickupVariant.PICKUP_KEY] = 0.00
			end
			
			local callbacks_0 = Isaac.GetCallbacks("CR_MC_PRE_EVALUATE_ROOM_AWARDS")
			
			for _, callback in ipairs(callbacks_0) do
				local ret = callback.Function(callback.Mod, weight)
				if ret ~= nil then
					weight = ret
				end
			end
			
			local players = PlayerManager.GetPlayers()
			for _, p in ipairs(players) do
				if p.Luck > luck then luck = p.Luck end
				if p:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
					luck = luck * 2
				end
				if p:HasTrinket(TrinketType.TRINKET_LUCKY_TOE) then
					if not p:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
						luck = luck * 2
					else
						luck = luck * 1.25
					end
				end
				if p:HasTrinket(TrinketType.TRINKET_TEMPORARY_TATTOO) then
					tempTatCount = tempTatCount + (1 * p:GetTrinketMultiplier(TrinketType.TRINKET_TEMPORARY_TATTOO))
				end
				if p:HasTrinket(TrinketType.TRINKET_RIB_OF_GREED) then 
					weight[PickupVariant.PICKUP_HEART] = weight[PickupVariant.PICKUP_HEART] - (0.5 * p:GetTrinketMultiplier(TrinketType.TRINKET_RIB_OF_GREED))
					weight[PickupVariant.PICKUP_COIN] = weight[PickupVariant.PICKUP_COIN] + (0.5 * p:GetTrinketMultiplier(TrinketType.TRINKET_RIB_OF_GREED))
				end
				if p:HasTrinket(TrinketType.TRINKET_CHILDS_HEART) then
					weight[PickupVariant.PICKUP_HEART] = weight[PickupVariant.PICKUP_HEART] + (0.1 * p:GetTrinketMultiplier(TrinketType.TRINKET_CHILDS_HEART))
				end
				if p:HasTrinket(TrinketType.TRINKET_WATCH_BATTERY) then
					weight[PickupVariant.PICKUP_LIL_BATTERY] = weight[PickupVariant.PICKUP_LIL_BATTERY] + (0.05 * p:GetTrinketMultiplier(TrinketType.TRINKET_WATCH_BATTERY))
				end
				if p:HasTrinket(TrinketType.TRINKET_ACE_SPADES) then
					weight[PickupVariant.PICKUP_TAROTCARD] = weight[PickupVariant.PICKUP_TAROTCARD] + (0.1 * p:GetTrinketMultiplier(TrinketType.TRINKET_ACE_SPADES))
				end
				if p:HasTrinket(TrinketType.TRINKET_SAFETY_CAP) then
					weight[PickupVariant.PICKUP_PILL] = weight[PickupVariant.PICKUP_PILL] + (0.1 * p:GetTrinketMultiplier(TrinketType.TRINKET_SAFETY_CAP))
				end
				if p:HasTrinket(TrinketType.TRINKET_MATCH_STICK) then
					weight[PickupVariant.PICKUP_BOMB] = weight[PickupVariant.PICKUP_BOMB] + (0.1 * p:GetTrinketMultiplier(TrinketType.TRINKET_MATCH_STICK))
				end
				if p:HasTrinket(TrinketType.TRINKET_RUSTED_KEY) then
					weight[PickupVariant.PICKUP_KEY] = weight[PickupVariant.PICKUP_KEY] + (0.1 * p:GetTrinketMultiplier(TrinketType.TRINKET_RUSTED_KEY))
				end
				if p:HasCollectible(CollectibleType.COLLECTIBLE_SMELTER) then
					weight[PickupVariant.PICKUP_TRINKET] = weight[PickupVariant.PICKUP_TRINKET] + 0.02
				end
				if p:HasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_TAIL) then
					if droprng:RandomFloat() <= 0.33 then
						weight = {}
						weight[PickupVariant.PICKUP_CHEST] = 1
					end
					if droprng:RandomFloat() <= 0.22 then
						weight = {}
						weight[PickupVariant.PICKUP_CHEST] = 0
					end
				end
				if p:HasCollectible(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW) then
					contract = contract + p:GetCollectibleNum(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW)
				end
				if p:HasCollectible(CollectibleType.COLLECTIBLE_OPTIONS) then
					hasOptions = true
				end
				
				local callbacks_1 = Isaac.GetCallbacks("CR_MC_POST_PLAYER_EVALUATE_ROOM_AWARDS")
				
				for _, callback in ipairs(callbacks_1) do
					local ret = callback.Function(callback.Mod, weight, p)
					if ret ~= nil then
						weight = ret
					end
				end
			end
			
			if luck < 0 then luck = 0 end
			luck = math.ceil(luck)
			
			local skipweight = (0.22 - luck/50)
			if skipweight > 0 then
				TRCommunityRemix.ClearAwardsPool:AddOutcomeFloat(PickupVariant.PICKUP_NULL, skipweight)
			end
			
			if luck > 0 then
				if weight[PickupVariant.PICKUP_CHEST] then
					weight[PickupVariant.PICKUP_CHEST] = weight[PickupVariant.PICKUP_CHEST] * luck
				end
			end
			
			if level:GetStage() == LevelStage.STAGE6 then
				weight[PickupVariant.PICKUP_CHEST] = nil
				weight[PickupVariant.PICKUP_ETERNALCHEST] = nil
				weight[PickupVariant.PICKUP_REDCHEST] = nil
			end
			
			for i, v in pairs(weight) do
				if v < 0 then v = 0 end
				TRCommunityRemix.ClearAwardsPool:AddOutcomeFloat(i, v)
			end
			
			
			
			local pick = PickupVariant.PICKUP_NULL
			
			if contract > 0 then
				if droprng:RandomInt(1, 3) > 1 then
					pick = TRCommunityRemix.ClearAwardsPool:PickOutcome(droprng)
				end
			else
				pick = TRCommunityRemix.ClearAwardsPool:PickOutcome(droprng)
			end
			if skipweight > 0 then
				TRCommunityRemix.ClearAwardsPool:RemoveOutcome(PickupVariant.PICKUP_NULL)
			end
			
			
			
			local callbacks_2 = Isaac.GetCallbacks("CR_MC_POST_PICK_ROOM_AWARD")
			
			for _, callback in ipairs(callbacks_2) do
				local ret = callback.Function(callback.Mod, pick)
				if ret ~= nil then
					pick = ret
				end
			end
			
			local didTempTat
			
			if roomType == RoomType.ROOM_CHALLENGE then
				pick = PickupVariant.PICKUP_CHEST
				if tempTatCount > 0 and roomDesc.Data and roomDesc.Data.Subtype == 1 and roomDesc.Data.Difficulty > 0 then
					pick = 100
					didTempTat = true
				end
			end
			
			if game.Difficulty == Difficulty.DIFFICULTY_HARD and pick == PickupVariant.PICKUP_HEART then
				local float_chance = 0.15
				if DifficultyManager.GetDifficulty() == "Insane" then float_chance = float_chance * 2 end
				if droprng:RandomFloat() <= float_chance then
					pick = PickupVariant.PICKUP_NULL
				end
			end
			
			if pick == PickupVariant.PICKUP_NULL and PlayerManager.AnyoneHasCollectible(416) then
				pick = PickupVariant.PICKUP_COIN; contract = contract + 2
			end
			
			if pick == PickupVariant.PICKUP_HEART and PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_DAEMONS_TAIL) then
				if droprng:RandomFloat() <= 0.80 then
					if droprng:RandomFloat() < 0.50 then
						pick = PickupVariant.PICKUP_KEY
					else
						pick = PickupVariant.PICKUP_BOMB
					end
				end
			end
			
			if pick ~= PickupVariant.PICKUP_NULL then
				--print(pick)
				if didTempTat then contract = 0; hasOptions = nil end
				if contract > 0 then
					for i = 1, contract do
						local pickup1 = Isaac.Spawn(5, pick, 0, Isaac.GetFreeNearPosition(pos, 0), Vector.Zero, nil):ToPickup()
						if hasOptions then
							TRCommunityRemix.ClearAwardsPool:RemoveOutcome(PickupVariant.PICKUP_NULL)
							pick = TRCommunityRemix.ClearAwardsPool:PickOutcome(droprng)
							if pick ~= PickupVariant.PICKUP_NULL then
								local pickupOffset = Vector(0, 20):Rotated(droprng:RandomInt(0, 360))
								pickup1.Position = pickup1.Position - pickupOffset
								local pickup2 = Isaac.Spawn(5, pick, 0, pickup1.Position + pickupOffset, Vector.Zero, nil):ToPickup()
								local optionsIndex = pickup1:SetNewOptionsPickupIndex()
								pickup1.OptionsPickupIndex = optionsIndex
								pickup2.OptionsPickupIndex = optionsIndex
							end
						end
					end
				end
				local pickup1 = Isaac.Spawn(5, pick, 0, Isaac.GetFreeNearPosition(pos, 0), Vector.Zero, nil):ToPickup()
				if hasOptions then
					TRCommunityRemix.ClearAwardsPool:RemoveOutcome(PickupVariant.PICKUP_NULL)
					pick = TRCommunityRemix.ClearAwardsPool:PickOutcome(droprng)
					if pick ~= PickupVariant.PICKUP_NULL then
						local pickupOffset = Vector(0, 20):Rotated(droprng:RandomInt(0, 360))
						pickup1.Position = pickup1.Position - pickupOffset
						local pickup2 = Isaac.Spawn(5, pick, 0, pickup1.Position + pickupOffset, Vector.Zero, nil):ToPickup()
						local optionsIndex = pickup1:SetNewOptionsPickupIndex()
						pickup1.OptionsPickupIndex = optionsIndex
						pickup2.OptionsPickupIndex = optionsIndex
					end
				end
			else
				--print("no pickup")
			end
			TRCommunityRemix.ClearAwardsPool:ClearOutcomes()
			return true
		end
	end
end)