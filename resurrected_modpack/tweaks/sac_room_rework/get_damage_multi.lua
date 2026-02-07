-- Updated by AgentCucco, thanks!
-- A map containing all available damage multipliers
local PLAYER_DMG_MULTI_MAP = {
    [PlayerType.PLAYER_MAGDALENE_B] = 0.75,
    [PlayerType.PLAYER_BLUEBABY] = 1.05,
    [PlayerType.PLAYER_CAIN] = 1.20,
    [PlayerType.PLAYER_KEEPER] = 1.20,
    [PlayerType.PLAYER_EVE_B] = 1.20,
    [PlayerType.PLAYER_THELOST_B] = 1.30,
    [PlayerType.PLAYER_JUDAS] = 1.35,
    [PlayerType.PLAYER_LAZARUS2] = 1.40,
    [PlayerType.PLAYER_AZAZEL] = 1.50,
    [PlayerType.PLAYER_THEFORGOTTEN] = 1.50,
    [PlayerType.PLAYER_AZAZEL_B] = 1.50,
    [PlayerType.PLAYER_LAZARUS2_B] = 1.50,
    [PlayerType.PLAYER_THEFORGOTTEN_B] = 1.50,
    [PlayerType.PLAYER_BLACKJUDAS] = 2.00,
}

-- Returns the damage multiplier of all characters
local function GetCharacterDamageMultiplier(player)
    local playerType = player:GetPlayerType()
    local playerEffects = player:GetEffects()
    local playerDamageMult = 1.00
    
    if playerType == PlayerType.PLAYER_EVE
    and not playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)
    then
        playerDamageMult = playerDamageMult * 0.75
    end
    
    playerDamageMult = playerDamageMult * (PLAYER_DMG_MULTI_MAP[playerType] or 1)
    
    return playerDamageMult
end

-- Returns the damage multiplier from all items
local function GetCollectibleDamageMultiplier(player)
	local playerEffects = player:GetEffects()
	local playerDamageMult = 1.00
	
	-- collectible damage multipliers
	if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
		playerDamageMult = playerDamageMult * 4.00
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) then
		playerDamageMult = playerDamageMult * 2.30
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA) or 
		playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then -- Dead eye item should also be there when it's at max charge, but sadly there isn't a way to get it's charge
		playerDamageMult = playerDamageMult * 2.00
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR) and playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) then
		playerDamageMult = playerDamageMult * 1.50
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) then
		playerDamageMult = playerDamageMult * 1.20
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN) then
		playerDamageMult = playerDamageMult * 0.90
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		playerDamageMult = playerDamageMult * 0.75
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
		playerDamageMult = playerDamageMult * 0.30
		
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then -- Almond milk overrides soy milk's multiplier
		playerDamageMult = playerDamageMult * 0.20
	end
	
	return playerDamageMult
end

-- Returns the damage multiplier of characters and items
local function GetDamageMultiplier(player)
    return GetCharacterDamageMultiplier(player) * GetCollectibleDamageMultiplier(player)
end

return GetDamageMultiplier