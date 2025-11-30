local TR_Manager = require("resurrected_modpack.manager")
local modz = TR_Manager:RegisterMod("Necromancer Costume", 1)
local game = Game()
local costume = Isaac.GetCostumeIdByPath("gfx/characters/necromancercostumenewzz.anm2")
local costumebody = Isaac.GetCostumeIdByPath("gfx/characters/necromancerbodypart.anm2")

local hasthecostumestill = false
function modz:PostPlayerInit6666(player)
	hasthecostumestill = false
end

function modz:update()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(35) and player:HasCollectible(262) and player:HasTrinket(48) and hasthecostumestill == false then
		player:AddNullCostume(costume)
        player:AddNullCostume(costumebody)
        hasthecostumestill = true
	end
    end
modz:AddCallback(ModCallbacks.MC_POST_UPDATE , modz.update);
modz:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, modz.PostPlayerInit6666);