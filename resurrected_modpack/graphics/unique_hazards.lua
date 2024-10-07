local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Unique Hazards"

local game = Game()

local Mod = {}

local revelation = {
	Floor = nil
}

local backdropSkinList = {
	"_basement.png",	-- current stage (up to AB+) --
	"_cellar.png",
	"_burning.png",
	"_caves.png",
	"_catacombs.png",
	"_flooded.png",
	"_depths.png",
	"_depths.png",	
	"_dank.png",
	"_womb.png",		-- 10
	"_utero.png",
	"_scarred.png",
	"_bluewomb.png",
	"_sheol.png",
	"_cathedral.png",
	"_darkroom.png",
	"_chest.png",
	"_darkroom.png",	-- separate rooms (starting with Mega Satan) --
	"_shop.png",		-- library
	"_shop.png",		-- shop (20)
	"_basement.png",	-- Isaac's Room / Genesis 
	"_cellar.png",		-- barren room
	"_depths.png",		-- secret room
	"_caves.png",
	"_caves.png",
	"_basement.png",	-- error room
	"_bluewomb.png",	-- blue womb secret room
	"_shop.png",		-- ultra greed shop
	"_basement.png",	-- dungeon
	"_cellar.png",		-- sacrifice (30)
	"_basement.png",	-- current stage (up to Rep) --
	"_mines.png",
	"_mausoleum.png",
	"_corpse.png",
	"_planetarium.png",
	"_basement.png",	-- entrance
	"_mines.png",		-- entrance
	"_mausoleum.png",	-- entrance
	"_corpse.png",		-- entrance 	
	"_mausoleum.png",	-- v.2 (40)
	"_mausoleum.png",	-- v.3
	"_mausoleum.png",	-- v.4
	"_corpse.png",		-- v.2
	"_corpse.png",		-- v.3
	"_basement.png",		
	"_ashpit.png",
	"_gehenna.png",
	"_mortis.png",
	"_basement.png",	-- Isaac's Bedroom
	"_basement.png",	-- (50)
	"_basement.png",	-- Mom's Bedroom
	"_closet.png",
	"_closet.png",		-- v.2 // death certificate
	"_caves.png",		-- dogma
	"_caves.png",		-- dungeon gideon 
	"_caves.png",		-- dungeon rotgut
	"_caves.png",		-- dungeon beast
	"_mines.png",		-- mines shaft
	"_mines.png",		-- ashpit shaft
	"_closet.png"		-- dark closet (60)
}

-- current patchnotes v 1.4 --
-- - added Spelunky's Spiketr... uhm I mean the catacombs variant for the Grudge enemy
-- - reactivated the (functional?) Revelations code for the Grudge enemy

-- main code --
function Mod:onNewStage()

	-- Revelations compatiblity 
	revelation.Floor = false
	if StageAPI 
	and REVEL 
	and REVEL.STAGE 
	and REVEL.STAGE.Tomb
	and REVEL.STAGE.Tomb:IsStage() then
		revelation.Floor = true
	end 
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.onNewStage)


function Mod:onEntitySpawn(entity)

	local room = game:GetRoom()
	local backdrop = room:GetBackdropType()
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	local variant = Isaac.GetEntityVariantByName("Poky")
	local variantTwo = Isaac.GetEntityVariantByName("Slide")


	-- print("hello")
	-- print(roomConfigRoom.Name)

	-- if entity.Variant == variant then	-- Poky
	if entity.Variant == 0 then	-- Poky
		-- print("Poky")

		-- check if the enemy already has the different sprite
		if data.Changed == nil then
			data.Changed = true

			-- check the current stage
			if backdropSkinList[backdrop] ~= nil then
				if backdrop == 5 then
					if not (revelation.Floor == true) then	-- Revelations compatiblity
						-- replace the spritesheet
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/poky/monster_poky" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				else
					if backdrop ~= 46 then	-- currently no alt spritesheet for mines available
						-- if it doesn't need complatibility the sprite can simply replaced with the current floor variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/poky/monster_poky" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				end
			end
		end

	elseif entity.Variant == 1 then	-- Slide
		-- print("slide")

		-- check if the enemy already has the different sprite
		if data.Changed == nil then
			data.Changed = true

			-- check the current stage
			if backdropSkinList[backdrop] ~= nil then
				if backdrop == 5 then
					if not (revelation.Floor == true) then	-- Revelations compatiblity
						-- replace the spritesheet
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/slide/monster_slide" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				elseif backdrop == 32
				or backdrop == 37
				or backdrop == 58
				or backdrop == 59 then
					if room:HasLava() then
						-- if the room contains lave, then the sprite will be replaced with the alt variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/slide/monster_slide_alt" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					else
						-- apply the normal floor variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/slide/monster_slide" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				else
					
					-- if it doesn't need complatibility the sprite can simply replaced with the current floor variant
					sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/slide/monster_slide" .. backdropSkinList[backdrop])
					sprite:LoadGraphics()
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Mod.onEntitySpawn, EntityType.ENTITY_POKY)

function Mod:onWallHuggerSpawn(entity)

	local level = game:GetLevel()
	local room = game:GetRoom()
	local backdrop = room:GetBackdropType()
	local sprite = entity:GetSprite()
	local data = entity:GetData()

	-- local variant = Isaac.GetEntityVariantByName("Wall Hugger")
	

	if entity.Variant == 0 then
		-- print("Wall Hugger")

		-- check if the enemy already has the different sprite
		if data.Changed == nil then
			data.Changed = true

			-- check the current stage
			if backdropSkinList[backdrop] ~= nil then
				if backdrop == 5 then
					if not (revelation.Floor == true) then	-- Revelations compatiblity
						-- replace the spritesheet
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/wall hugger/monster_wall hugger" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				elseif backdrop == 32
				or backdrop == 37
				or backdrop == 58
				or backdrop == 59 then
					if room:HasLava() then
						-- if the room contains lave, then the sprite will be replaced with the alt variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/wall hugger/monster_wall hugger_alt" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					else
						-- apply the normal floor variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/wall hugger/monster_wall hugger" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				else
				
					-- if it doesn't need complatibility the sprite can simply replaced with the current floor variant
					sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/wall hugger/monster_wall hugger" .. backdropSkinList[backdrop])
					sprite:LoadGraphics()
				end
			end		
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Mod.onWallHuggerSpawn, EntityType.ENTITY_WALL_HUGGER)

if REPENTANCE then
	function Mod:onWallHuggerSpawn(entity)

		local level = game:GetLevel()
		local room = game:GetRoom()
		local backdrop = room:GetBackdropType()
		local sprite = entity:GetSprite()
		local data = entity:GetData()

		if entity.Variant == 0 then
			-- print("Grugde")

			-- check if the enemy already has the different sprite
			if data.Changed == nil then
				data.Changed = true

				-- check the current stage
				if backdropSkinList[backdrop] ~= nil then
					if backdrop == 5 then
						if not (revelation.Floor == true) then	-- Revelations compatiblity
							-- replace the spritesheet
							sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/grudge/monster_grudge" .. backdropSkinList[backdrop])
							sprite:LoadGraphics()
						end
						
					elseif backdrop == 1
					or backdrop == 2
					or backdrop == 10
					or backdrop == 11
					or backdrop == 31 then
						-- if it doesn't need complatibility the sprite can simply replaced with the current floor variant
						sprite:ReplaceSpritesheet(0, "gfx/monsters/custom/grudge/monster_grudge" .. backdropSkinList[backdrop])
						sprite:LoadGraphics()
					end
				end	
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Mod.onWallHuggerSpawn, EntityType.ENTITY_GRUDGE)
end