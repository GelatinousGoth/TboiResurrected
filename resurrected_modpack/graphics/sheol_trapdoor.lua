local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Slightly Cooler Sheol Trapdoor", 1)
local game = Game()

function mod.WillLeadToSheol()
	local level = game:GetLevel()
	local stage = level:GetStage()
	
	local bool = false
	if game:IsGreedMode() then
		bool = stage == LevelStage.STAGE4_GREED
	else
		local stageType = level:GetStageType()
		local curses = level:GetCurses()
		local curRoomDesc = level:GetCurrentRoomDesc()
		
		bool =
			-- Womb XL / II
			(stage == LevelStage.STAGE4_1 and curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0
			or stage == LevelStage.STAGE4_2)
			and curRoomDesc.GridIndex ~= GridRooms.ROOM_BLUE_WOOM_IDX	-- exclude Blue Womb entrance from Womb II, Womb XL
			and stageType ~= StageType.STAGETYPE_REPENTANCE	-- exclude Corpse
			and stageType ~= StageType.STAGETYPE_REPENTANCE_B	-- (just in case) exclude Mortis
			-- Blue Womb
			or stage == LevelStage.STAGE4_3
	end
	
	return bool
end

function mod:ReplaceAllTrapdoorSprites()
	if not mod.WillLeadToSheol() then return end
	
	local room = game:GetRoom()
	for i = 0, room:GetGridSize()-1 do
		local grid = room:GetGridEntity(i)
		if grid
		and grid:GetType() == GridEntityType.GRID_TRAPDOOR
		and grid:GetVariant() == 0
		then
			local sprite = grid:GetSprite()
			local anim = sprite:GetAnimation()
			sprite:Load("gfx/grid/door_11_sheolabyss.anm2", true)
			sprite:Play(anim)
		end
	end
end


function mod:ReplaceTrapdoorSprite(grid)
	if grid:GetVariant() ~= 0 then return end
	if not mod.WillLeadToSheol() then return end
	
	local sprite = grid:GetSprite()
	local anim = sprite:GetAnimation()
	sprite:Load("gfx/grid/door_11_sheolabyss.anm2", true)
	sprite:Play(anim)
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ReplaceAllTrapdoorSprites)

if REPENTOGON then
	mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, mod.ReplaceTrapdoorSprite, GridEntityType.GRID_TRAPDOOR)
else
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.ReplaceAllTrapdoorSprites, EffectVariant.HEAVEN_LIGHT_DOOR)	-- so, if light to Cathedral spawned, so should trapdoor to Sheol, right?? (feels unreliable af, but anyway)
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ReplaceAllTrapdoorSprites, CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER)	-- trapdoor is not necessarily spawned right under player, so check entire room
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ReplaceAllTrapdoorSprites, CollectibleType.COLLECTIBLE_D12)
	mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.ReplaceAllTrapdoorSprites, Card.RUNE_EHWAZ)	-- same as We Need To Go Deeper
	mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.ReplaceAllTrapdoorSprites, Card.RUNE_SHARD)	-- idk how to determine, which exact effect was triggered, so check in any case + same as We Need To Go Deeper
	
	-- upon blowing carpet (e.g. in barren Isaac's room)
	-- Notes:
		-- 1) trapdoor will always try to spawn at room center, regardless of carpet position
		-- 2) crawlspace is only spawned in Isaac's bedroom, in any other room type usual trapdoor will appear
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
		local room = game:GetRoom()
		if room:GetType() == RoomType.ROOM_ISAACS then return end
		local data = effect:GetData()
		local isDestroyed = effect.SubType == 1000	-- carpet subtype changes to 1000, when exploded
		if data.WasDestroyed ~= isDestroyed then
			if data.WasDestroyed ~= nil then
				local grid = room:GetGridEntityFromPos(room:GetCenterPos())
				if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR then
					mod:ReplaceTrapdoorSprite(grid)
				end
			end
			data.WasDestroyed = isDestroyed
		end
	end, EffectVariant.ISAACS_CARPET)
end