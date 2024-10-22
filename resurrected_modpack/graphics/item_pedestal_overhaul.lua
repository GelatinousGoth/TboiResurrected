local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Item Pedestal Overhaul", 1)

local game = Game()

function mod:postpickup(pickup)
	local room = game:GetLevel():GetCurrentRoom()
	if pickup.Type == 5 and pickup.Variant == 100 and not pickup:IsShopItem() and pickup:GetSprite():GetOverlayFrame() == 0 and pickup:GetData().pedestal_check == nil then
		pickup:GetData().pedestal_check = true
		local sprite = pickup:GetSprite()
		local layout = {10,11,12,13,14,15,16,17,19,20,21,22,23,25,26,27,28,30,34,35,37,39,43,44,48,49,50,52,53,60} -- Backdrops
		local altar = {"womb","womb","scarred","bluewomb","devil","angel","darkroom","treasure","library","shop","library","library","secret","shop","error",
						"bluewomb","shop","sacrifice","corpse","planetarium","secret","corpse","corpse","corpse","corpse","loot","loot","loot","loot","loot"} -- Pedestal Frames
		local altarType = ""
		for i = 1, #layout do
			if room:GetBackdropType() == layout[i] then altarType = altar[i] end -- Pedestal Type
		end
		if room:GetType() == RoomType.ROOM_BOSS and (altarType == "womb" or altarType == "scarred" or altarType == "bluewomb" or altarType == "corpse") then altarType = altarType .. "boss" -- Womb Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_MINIBOSS then altarType = "boss" -- Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_TREASURE and altarType ~= "womb" and altarType ~= "scarred" and altarType ~= "bluewomb" and altarType ~= "corpse" then altarType = "treasure" -- Boss Pedestal
		elseif room:GetType() == RoomType.ROOM_CHALLENGE or room:GetType() == RoomType.ROOM_BOSSRUSH then altarType = "ambush" end -- Ambush Pedestal
		if altarType ~= "" then
			for i = 3, 5 do pickup:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/" .. altarType .. "_pedestal.png") end
			pickup:GetSprite():LoadGraphics()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.postpickup)