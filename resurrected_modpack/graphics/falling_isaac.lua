local mod = require("resurrected_modpack.mod_reference")
mod.CurrentModName = "falling_isaac"

local sfx = SFXManager()

-- SOUNDS --
local fallingsound = Isaac.GetSoundIdByName ("Falling")
local GroundHit = Isaac.GetSoundIdByName ("GroundHit")
local Reroll = Isaac.GetSoundIdByName ("Reroll")
-- SOUNDS --

-- Isaac Sounds --
function mod:Sounds(Player)

    if Player:GetSprite():IsEventTriggered("Falling") then 
		sfx:Play(fallingsound,2,2,false,1,0)
    end
    if Player:GetSprite():IsEventTriggered("GroundHit") then
        sfx:Play(GroundHit,4,2,false,1,0)
    end
	if Player:GetSprite():IsEventTriggered("Reroll") then
        sfx:Play(Reroll,0.7,1,false,1,0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,mod.Sounds, PlayerType.PLAYER_ISAAC)

-- Animations --
-- Isaac --
local function IsaacFalling(_, player, cacheFlag)
    local s = player:GetSprite()
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC then
      
        if s:GetFilename() ~= "gfx/IsaacFalling.anm2" then
            s:Load("gfx/IsaacFalling.anm2", true)
            s:Update()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, IsaacFalling)