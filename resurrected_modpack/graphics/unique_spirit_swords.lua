local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Spirit Sword Variants", 1)
local SwordSprites = {
    [PlayerType.PLAYER_ISAAC] = "gfx/effects/isaac_spirit_sword.png",
	[PlayerType.PLAYER_MAGDALENA] = "gfx/effects/magdalene_spirit_sword.png",
	[PlayerType.PLAYER_CAIN] = "gfx/effects/cain_spirit_sword.png",
	[PlayerType.PLAYER_JUDAS] = "gfx/effects/judas_spirit_sword.png",
	[PlayerType.PLAYER_XXX] = "gfx/effects/bb_spirit_sword.png",
	[PlayerType.PLAYER_EVE] = "gfx/effects/eve_spirit_sword.png",
	[PlayerType.PLAYER_SAMSON] = "gfx/effects/samson_spirit_sword.png",
	[PlayerType.PLAYER_AZAZEL] = "gfx/effects/azazel_spirit_sword.png",
	[PlayerType.PLAYER_LAZARUS] = "gfx/effects/lazarus_spirit_sword.png",
	[PlayerType.PLAYER_EDEN] = "gfx/effects/eden_spirit_sword.png",
	[PlayerType.PLAYER_LAZARUS2] = "gfx/effects/lazarus2_spirit_sword.png",
	[PlayerType.PLAYER_THELOST] = "gfx/effects/thelost_spirit_sword.png",
	[PlayerType.PLAYER_BLACKJUDAS] = "gfx/effects/blackjudas_spirit_sword.png",
	[PlayerType.PLAYER_LILITH] = "gfx/effects/lilith_spirit_sword.png",
	[PlayerType.PLAYER_KEEPER] = "gfx/effects/keeper_spirit_sword.png",
	[PlayerType.PLAYER_APOLLYON] = "gfx/effects/apollyon_spirit_sword.png",
	[PlayerType.PLAYER_THESOUL] = "gfx/effects/thesoul_spirit_sword.png",
	[PlayerType.PLAYER_BETHANY] = "gfx/effects/bethany_spirit_sword.png",
	[PlayerType.PLAYER_JACOB] = "gfx/effects/jacob_spirit_sword.png",
	[PlayerType.PLAYER_ESAU] = "gfx/effects/esau_spirit_sword.png",
	[PlayerType.PLAYER_ISAAC_B] = "gfx/effects/isaacb_spirit_sword.png",
	[PlayerType.PLAYER_MAGDALENA_B] = "gfx/effects/magdaleneb_spirit_sword.png",
	[PlayerType.PLAYER_CAIN_B] = "gfx/effects/cainb_spirit_sword.png",
	[PlayerType.PLAYER_JUDAS_B] = "gfx/effects/judasb_spirit_sword.png",
	[PlayerType.PLAYER_XXX_B] = "gfx/effects/bbb_spirit_sword.png",
	[PlayerType.PLAYER_EVE_B] = "gfx/effects/eveb_spirit_sword.png",
	[PlayerType.PLAYER_SAMSON_B] = "gfx/effects/samsonb_spirit_sword.png",
	[PlayerType.PLAYER_AZAZEL_B] = "gfx/effects/azazelb_spirit_sword.png",
	[PlayerType.PLAYER_LAZARUS_B] = "gfx/effects/lazarusb_spirit_sword.png",
	[PlayerType.PLAYER_EDEN_B] = "gfx/effects/edenb_spirit_sword.png",
	[PlayerType.PLAYER_LAZARUS2_B] = "gfx/effects/lazarus2b_spirit_sword.png",
	[PlayerType.PLAYER_THELOST_B] = "gfx/effects/thelostb_spirit_sword.png",
	[PlayerType.PLAYER_LILITH_B] = "gfx/effects/lilithb_spirit_sword.png",
	[PlayerType.PLAYER_KEEPER_B] = "gfx/effects/keeperb_spirit_sword.png",
	[PlayerType.PLAYER_APOLLYON_B] = "gfx/effects/apollyonb_spirit_sword.png",
	[PlayerType.PLAYER_BETHANY_B] = "gfx/effects/bethanyb_spirit_sword.png",
	[PlayerType.PLAYER_JACOB_B] = "gfx/effects/jacobb_spirit_sword.png",
	[PlayerType.PLAYER_JACOB2_B] = "gfx/effects/jacob2b_spirit_sword.png",
	
    -- ...
}

function mod:SwordReplace(knife)
    local data = knife:GetData()
    if data.UpdatedCustomSword then return end
    local player = knife.Parent
	if (not player) then return end
	if (player.Type ~= EntityType.ENTITY_PLAYER) and (player.Type ~= EntityType.ENTITY_FAMILIAR) then return end
	
	
    local lilith = player.SpawnerEntity
	local pType = nil
	if (player.Type ~= EntityType.ENTITY_FAMILIAR) then pType = player:ToPlayer():GetPlayerType() else pType = lilith:ToPlayer():GetPlayerType() end
    local sprRoot = SwordSprites[pType]
	
	
    if knife.Variant == 10 and pType ~= PlayerType.PLAYER_THEFORGOTTEN then
    local sprite = knife:GetSprite()
    sprite:ReplaceSpritesheet(0, sprRoot)
	sprite:ReplaceSpritesheet(1, sprRoot)
    sprite:LoadGraphics()
    data.UpdatedCustomSword = pType
    end
end 

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE,mod.SwordReplace)