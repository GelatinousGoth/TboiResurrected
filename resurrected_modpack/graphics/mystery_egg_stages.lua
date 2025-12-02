local TR_Manager = require("resurrected_modpack.manager")
local MysteryEggMod = TR_Manager:RegisterMod("Mystery Egg Stages", 1)
local game = Game()
local roomsClearedWithoutDamage = 0
local tookDamageThisRoom = false
local trackingStarted = false

-- Init --

function MysteryEggMod:OnFamiliarInit(familiar)
	if familiar.Variant == FamiliarVariant.MYSTERY_EGG then
		local sprite = familiar:GetSprite()
		sprite:Load("gfx/familiar/mystery_egg.anm2", true)
		sprite:Play("Idle", true)
	end
end

MysteryEggMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, MysteryEggMod.OnFamiliarInit, FamiliarVariant.MYSTERY_EGG)


-- Ensure Stage 0 --

function MysteryEggMod:OnGameStart(isContinued)
	roomsClearedWithoutDamage = 0
	tookDamageThisRoom = false
	trackingStarted = false
end

MysteryEggMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, MysteryEggMod.OnGameStart)



-- New Room: Reset Damage Flag --

function MysteryEggMod:OnNewRoom()
	tookDamageThisRoom = false

	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERY_EGG) then
		if not trackingStarted then
			trackingStarted = true
			roomsClearedWithoutDamage = 0
		end

	-- Initial Point is added --

		if roomsClearedWithoutDamage == 0 then
			roomsClearedWithoutDamage = roomsClearedWithoutDamage + 1
		end
	end
end

MysteryEggMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MysteryEggMod.OnNewRoom)



-- When Damaged: --

function MysteryEggMod:OnPlayerDamage(entity, amount, flags, source, countdown)
	if entity:ToPlayer() then

		-- Get damage source --
		local function hasFlag(f) return (flags & f) == f end

		-- Check which damage doesn't count -- 
		if hasFlag(DamageFlag.DAMAGE_CURSED_DOOR) then return end

		tookDamageThisRoom = true
		roomsClearedWithoutDamage = 0
	end
end

MysteryEggMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MysteryEggMod.OnPlayerDamage)



-- Cleared Room: No DMG: Increase Counter --

function MysteryEggMod:OnRoomClear()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERY_EGG) then
		if not trackingStarted then
			trackingStarted = true
			roomsClearedWithoutDamage = 0
		end

		if not tookDamageThisRoom then
			roomsClearedWithoutDamage = roomsClearedWithoutDamage + 1
		end
	end
end

MysteryEggMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, MysteryEggMod.OnRoomClear)



-- Update Familiar --

function MysteryEggMod:GetEggStage()
	local r = roomsClearedWithoutDamage
	if r <= 1 then
		return 0 -- Stage 1
	elseif r <= 4 then
		return 1 -- Stage 2
	elseif r <= 7 then
		return 2 -- Stage 3
	elseif r <= 10 then
		return 3 -- Stage 4
	elseif r <= 13 then
		return 4 -- Stage 5
	else
		return 5 -- Stage 6
	end
end

function MysteryEggMod:OnFamiliarUpdate(familiar)
	if familiar.Variant == FamiliarVariant.MYSTERY_EGG then
		local sprite = familiar:GetSprite()
		local stage = MysteryEggMod:GetEggStage()
		local data = familiar:GetData()

		currentAnim = sprite:GetAnimation()
		local stagePrefix = string.match(currentAnim, "Crack") and "crack" or "idle"
		local expectedPath = "gfx/familiar/mystery_egg_stage"..tostring(stage)..".png"

		-- If playing crack, don't interrupt it --

		if currentAnim:sub(1, 5) == "Crack" then
			data.WaitingForCrackFinish = true
			return
		end

		-- When crack finishes, reload graphics --
		
		if data.WaitingForCrackFinish then
			local path = "gfx/familiar/mystery_egg_stage" .. tostring(stage) .. ".png"
			sprite:ReplaceSpritesheet(0, path)
			sprite:LoadGraphics()
			data.CurrentStage = stage
			data.CurrentAnim = "idle"
			data.WaitingForCrackFinish = false
			return
		end

		if data.CurrentStage ~= stage or data.CurrentAnim ~= stagePrefix then
			sprite:ReplaceSpritesheet(0, expectedPath)
			sprite:LoadGraphics()
			data.CurrentStage = stage
			data.CurrentAnim = stagePrefix
		end
	end
end

MysteryEggMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, MysteryEggMod.OnFamiliarUpdate, FamiliarVariant.MYSTERY_EGG)


