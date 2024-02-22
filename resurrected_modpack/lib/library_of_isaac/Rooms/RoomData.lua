



function TSIL.Rooms.GetRoomDescriptor(roomGridIndex)
	local level = Game():GetLevel()

	if roomGridIndex == nil then
		roomGridIndex = level:GetCurrentRoomIndex()
	end

	return level:GetRoomByIdx(roomGridIndex);
end





