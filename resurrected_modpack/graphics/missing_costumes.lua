local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Missing Costumes", 1)

_G.Onseshigo = _G.Onseshigo or {}
_G.Onseshigo.MissingCostumes = mod

mod.Options = mod.Options or {}
mod.Options.NullCostumes = true
mod.Options.KeeperB_anm2 = true


mod.NullItemID = {}

mod.NullItemID.ID_AZAZEL_TOOTH_AND_NAIL			=	Isaac.GetCostumeIdByPath("gfx/characters/character_08_azazel_toothandnail.anm2")

mod.NullItemID.ID_BLUEBABY_B_IPECAC				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_ipecac.anm2")
mod.NullItemID.ID_BLUEBABY_B_SCORPIO			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_scorpio.anm2")
mod.NullItemID.ID_BLUEBABY_B_BLUECAP			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_bluecap.anm2")
mod.NullItemID.ID_BLUEBABY_B_SOAP				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_barofsoap.anm2")
mod.NullItemID.ID_BLUEBABY_B_KNOCKOUTDROPS		=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_knockoutdrops.anm2")
mod.NullItemID.ID_BLUEBABY_B_REVELATION			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b05_bluebaby_revelation.anm2")

mod.NullItemID.ID_FORGOTTEN_B_MUSHROOM			=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_mushroom.anm2")
mod.NullItemID.ID_FORGOTTEN_B_BOB				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_bob.anm2")
mod.NullItemID.ID_FORGOTTEN_B_POOP				=	Isaac.GetCostumeIdByPath("gfx/characters/character_b15_theforgotten_poop.anm2")


mod.Costumes = {
--	{PlayerType=PlayerType.PLAYER_AZAZEL,			NullEffect=NullItemID.ID_TOOTH_AND_NAIL,					Costume=mod.NullItemID.ID_AZAZEL_TOOTH_AND_NAIL,		Default=NullItemID.ID_AZAZEL,		Allowed=false,	Added=false,},	-- WIP

	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_IPECAC,				Costume=mod.NullItemID.ID_BLUEBABY_B_IPECAC,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_SCORPIO,			Costume=mod.NullItemID.ID_BLUEBABY_B_SCORPIO,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_BLUE_CAP,			Costume=mod.NullItemID.ID_BLUEBABY_B_BLUECAP,			Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_BAR_OF_SOAP,		Costume=mod.NullItemID.ID_BLUEBABY_B_SOAP,				Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,		Costume=mod.NullItemID.ID_BLUEBABY_B_KNOCKOUTDROPS,		Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_XXX_B,			Collectible=CollectibleType.COLLECTIBLE_REVELATION,			Costume=mod.NullItemID.ID_BLUEBABY_B_REVELATION,		Default=NullItemID.ID_BLUEBABY_B,	Allowed=true,	Added=false,},

	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_MUSHROOM,					Costume=mod.NullItemID.ID_FORGOTTEN_B_MUSHROOM,			Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_BOB,						Costume=mod.NullItemID.ID_FORGOTTEN_B_BOB,				Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
	{PlayerType=PlayerType.PLAYER_THEFORGOTTEN_B,	PlayerForm=PlayerForm.PLAYERFORM_POOP,						Costume=mod.NullItemID.ID_FORGOTTEN_B_POOP,				Default=NullItemID.ID_FORGOTTEN_B,	Allowed=true,	Added=false,},
}


function mod:setCostumes(player)
	local playerSprite = player:GetSprite()
	if (player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) and (playerSprite:GetFilename():lower() == "gfx/001.000_player.anm2") and mod.Options.KeeperB_anm2 then
		playerSprite:Load("gfx/001.000_player_keeperb.anm2", true)
		Isaac.DebugString('[MissingCostumes] changed .anm2 for player ' .. player.ControllerIndex .. 'to custom')
	end
	if (player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B) and (playerSprite:GetFilename():lower() == "gfx/001.000_player_keeperb.anm2") then
		playerSprite:Load("gfx/001.000_player.anm2", true)
		Isaac.DebugString('[MissingCostumes] changed .anm2 for player ' .. player.ControllerIndex .. 'to default')
	end

	if mod.Options.NullCostumes then
		for i, _ in ipairs(mod.Costumes) do
			if mod.Costumes[i].Allowed and (mod.Costumes[i].Costume ~= -1) then
				if mod.Costumes[i].Collectible then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:HasCollectible(mod.Costumes[i].Collectible) and player:GetCollectibleNum(mod.Costumes[i].Collectible, true) > 0 and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for item ' .. mod.Costumes[i].Collectible)
						end
						if not player:HasCollectible(mod.Costumes[i].Collectible) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for item ' .. mod.Costumes[i].Collectible)
						end
					end
				elseif mod.Costumes[i].PlayerForm then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:HasPlayerForm(mod.Costumes[i].PlayerForm) and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for player form ' .. mod.Costumes[i].PlayerForm)
						end
						if not player:HasPlayerForm(mod.Costumes[i].PlayerForm) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for player form ' .. mod.Costumes[i].PlayerForm)
						end
					end
				elseif mod.Costumes[i].NullEffect then
					if player:GetPlayerType() == mod.Costumes[i].PlayerType then
						if player:GetEffects():HasNullEffect(mod.Costumes[i].NullEffect) and not mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Default)
							player:AddNullCostume(mod.Costumes[i].Costume)
							mod.Costumes[i].Added = true
							Isaac.DebugString('[MissingCostumes] added nullcostume for player ' .. player.ControllerIndex .. ' for nulleffect ' .. mod.Costumes[i].NullEffect)
						end
						if not player:GetEffects():HasNullEffect(mod.Costumes[i].NullEffect) and mod.Costumes[i].Added then
							player:TryRemoveNullCostume(mod.Costumes[i].Costume)
							player:AddNullCostume(mod.Costumes[i].Default)
							mod.Costumes[i].Added = false
							Isaac.DebugString('[MissingCostumes] removed nullcostume for player ' .. player.ControllerIndex .. ' for nulleffect ' .. mod.Costumes[i].NullEffect)
						end
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.setCostumes)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.setCostumes)