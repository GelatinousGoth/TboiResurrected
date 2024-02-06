local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Shepard Tone"

-- When these types of pickups are picked up, their pickup sound gradually increases in pitch for a short amount of time.
-- Format: { <variant>, <subtype>, <sound> }
local PITCHABLE_PICKUPS =
{
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_DOUBLEPACK,   SoundEffect.SOUND_FETUS_FEET },
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_NORMAL,       SoundEffect.SOUND_FETUS_FEET },
	{ PickupVariant.PICKUP_BOMB,  BombSubType.BOMB_GOLDEN,       SoundEffect.SOUND_GOLDENBOMB },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_DIME,         SoundEffect.SOUND_DIMEPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_DOUBLEPACK,   SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_LUCKYPENNY,   SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_NICKEL,       SoundEffect.SOUND_NICKELPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_PENNY,        SoundEffect.SOUND_PENNYPICKUP },
	{ PickupVariant.PICKUP_COIN,  CoinSubType.COIN_STICKYNICKEL, SoundEffect.SOUND_NICKELPICKUP },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK,      SoundEffect.SOUND_UNHOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE,       SoundEffect.SOUND_BONE_HEART },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL,       SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN,     SoundEffect.SOUND_GOLD_HEART },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF,       SoundEffect.SOUND_BOSS2_BUBBLES },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL,  SoundEffect.SOUND_HOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL,       SoundEffect.SOUND_HOLY },
	{ PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL,    SoundEffect.SOUND_SUPERHOLY },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_CHARGED,        SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_DOUBLEPACK,     SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_NORMAL,         SoundEffect.SOUND_KEYPICKUP_GAUNTLET },
	{ PickupVariant.PICKUP_KEY,   KeySubType.KEY_GOLDEN,         SoundEffect.SOUND_GOLDENKEY },

	-- Repentance additions: use numbered ids to avoid errors on older DLCs.
	{ PickupVariant.PICKUP_BOMB,  7,  SoundEffect.SOUND_FETUS_FEET }, -- BombSubType.BOMB_GIGA
	{ PickupVariant.PICKUP_HEART, 12, 497 },                          -- HeartSubType.HEART_ROTTEN
	{ PickupVariant.PICKUP_COIN,  7,  SoundEffect.SOUND_PENNYPICKUP } -- CoinSubType.COIN_GOLDEN
}

-- Amount of pitch added.
local PITCH_AMOUNT = 0.01

-- Reset the pitch back to normal after this amount of frames from the last sound.
local PITCH_RESET = 30

-- Default pitch amount.
local DEFAULT_PITCH = 1.0

local GAME = Game()
local SFXMANAGER = SFXManager()
local CURRENT_PITCH, LAST_PITCH = 1, 2
local VARIANT, SUBTYPE, SOUND = 1, 2, 3
local SOUNDS_PITCH = {}

function mod:OnPickupUpdate(pickup)
	for i = 1, #PITCHABLE_PICKUPS do
		if pickup.Variant == PITCHABLE_PICKUPS[i][VARIANT] and pickup.SubType == PITCHABLE_PICKUPS[i][SUBTYPE] then
			local sprite = pickup:GetSprite()

			if sprite:IsPlaying("Collect") and sprite:GetFrame() == 1 then
				local sound = PITCHABLE_PICKUPS[i][SOUND]

				SOUNDS_PITCH[sound][LAST_PITCH] = GAME:GetFrameCount()
				SOUNDS_PITCH[sound][CURRENT_PITCH] = SOUNDS_PITCH[sound][CURRENT_PITCH] + PITCH_AMOUNT
			end

			break
		end
	end
end

local REGISTERED_VARIANTS = {}

for i = 1, #PITCHABLE_PICKUPS do
	SOUNDS_PITCH[PITCHABLE_PICKUPS[i][SOUND]] = { DEFAULT_PITCH, 0 }

	if not REGISTERED_VARIANTS[PITCHABLE_PICKUPS[i][VARIANT]] then
		REGISTERED_VARIANTS[PITCHABLE_PICKUPS[i][VARIANT]] = true
		mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.OnPickupUpdate, PITCHABLE_PICKUPS[i][VARIANT])
	end
end

function mod:OnUpdate()
	local frame = GAME:GetFrameCount()

	for i = 1, #PITCHABLE_PICKUPS do
		local sound = PITCHABLE_PICKUPS[i][SOUND]

		if SFXMANAGER:IsPlaying(sound) then
			if SOUNDS_PITCH[sound][CURRENT_PITCH] > DEFAULT_PITCH then
				if SOUNDS_PITCH[sound][LAST_PITCH] > 0 and frame - SOUNDS_PITCH[sound][LAST_PITCH] >= PITCH_RESET then
					SOUNDS_PITCH[sound][CURRENT_PITCH] = DEFAULT_PITCH
				else
					SFXMANAGER:AdjustPitch(sound, SOUNDS_PITCH[sound][CURRENT_PITCH] - PITCH_AMOUNT)
				end
			end

			break
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)