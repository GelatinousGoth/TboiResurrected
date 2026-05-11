local function AngelShopBeggarFixEnabler()

local AngelShopBeggarFix = {}
local mod = IsaacReflourished

local roomId = {[40] = true, [41] = true, [42] = true, [43] = true, [44] = true, [45] = true}
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local roomDesc = Game():GetLevel():GetCurrentRoomDesc().Data
	if roomDesc.Type == RoomType.ROOM_ANGEL and roomDesc.Subtype == 1 and roomId[roomDesc.Variant] then
		for _, beggar in pairs(Isaac.FindByType(6)) do
		--local beggar = Isaac.FindByType(6)[1]
			if beggar.Variant ~= 17 then
				beggar.Position = Vector(400,400)
			end
		end
	end
end)

end
return AngelShopBeggarFixEnabler