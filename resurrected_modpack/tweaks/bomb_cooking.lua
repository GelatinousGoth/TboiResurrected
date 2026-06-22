local TR_Manager = require("resurrected_modpack.manager")
bombCookingMod = TR_Manager:RegisterMod("Bomb Cooking", 1, true)

local game = Game()

bombCookingMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
	if communityRemix and p:HasCollectible(communityRemix.CollectibleType.COLLECTIBLE_OVEN_MITT) then return end
	if BossButch and p:HasCollectible(BossButch.RatBombsID) then return end

	local d = p:GetData()
	
	if d.bombbuttonframes == nil then d.bombbuttonframes = -1 end
	if d.shouldplacebomb == nil then d.shouldplacebomb = false end
	
	if Input.IsActionPressed(ButtonAction.ACTION_BOMB, p.ControllerIndex) then
		if d.bombbuttonframes > -2 then
			if d.bombbuttonframes < 1 then d.bombbuttonframes = 1 end
			d.bombbuttonframes = d.bombbuttonframes + 1
		end
	else
		if d.bombbuttonframes >= 0 then
			d.bombbuttonframes = d.bombbuttonframes - 1
			if d.bombbuttonframes > 0 then d.bombbuttonframes = 0 end
		end
		if d.bombbuttonframes < -1 then
			d.bombbuttonframes = -1
		end
	end

	d.shouldplacebomb = (d.bombbuttonframes == 0 or d.bombbuttonframes == 8)
end)


bombCookingMod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, function(_, p, bomb)
	if communityRemix and p:HasCollectible(communityRemix.CollectibleType.COLLECTIBLE_OVEN_MITT) then return end
	if BossButch and p:HasCollectible(BossButch.RatBombsID) then return end

	local d = p:GetData()
	if d.bombbuttonframes == nil then d.bombbuttonframes = 0 end
	if d.bombbuttonframes >= 8 then
		p:TryHoldEntity(bomb)
		d.bombbuttonframes = -2
	end
end)


bombCookingMod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, e, hook, action)
	if e and e.Type == 1 then
		local p = e:ToPlayer()
		if communityRemix and p:HasCollectible(communityRemix.CollectibleType.COLLECTIBLE_OVEN_MITT) then return end
		local d = p:GetData()
		if action == ButtonAction.ACTION_BOMB then
			if hook == 1 then
				return d.shouldplacebomb
			end
		end
	end
end)