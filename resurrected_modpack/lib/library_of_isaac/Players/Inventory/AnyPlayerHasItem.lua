function TSIL.Players.DoesAnyPlayerHasItem(collectibleId, ignoreModifiers)
	local players = TSIL.Players.GetPlayers()

	local numPlayersWithItem = TSIL.Utils.Tables.Count(players, function (_, player)
		return player:HasCollectible(collectibleId, ignoreModifiers)
	end)

	return numPlayersWithItem > 0
end